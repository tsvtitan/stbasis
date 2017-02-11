unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
    Buttons, ExtCtrls,
  daADStanIntf, daADStanDef, daADStanAsync,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysMySQL;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Console: TMemo;
    edtTimeout: TEdit;
    Label1: TLabel;
    rgMode: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FConnIntf: IADPhysConnection;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

uses
  DB;	

type
  TMyAsyncHandler = class(TInterfacedObject, IADStanAsyncHandler)
  private
    FFrm: TForm1;
  protected
    // IADStanAsyncHandler
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception);
  public
    constructor Create(AFrm: TForm1);
  end;

constructor TMyAsyncHandler.Create(AFrm: TForm1);
begin
  inherited Create;
  FFrm := AFrm;
end;

procedure TMyAsyncHandler.HandleFinished(const AInitiator: IADStanObject;
  AState: TADStanAsyncState; AException: Exception);
const
  StateNames: array[TADStanAsyncState] of String = ('asInactive', 'asExecuting',
    'asFinished', 'asFailed', 'asAborted', 'asExpired');
begin
  FFrm.Console.Lines.Add('    The HandleFinished is called - ' + StateNames[AState]);
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ADPhysManager.Open;
  ADPhysManager.CreateConnection('MySQL_Demo', FConnIntf);
  FConnIntf.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
  oComm: IADPhysCommand;
begin
  FConnIntf.CreateCommand(oComm);
  with oComm do begin
    // Clear the table
    Console.Lines.Add('Filling a table before demonstration...');
    Prepare('delete from {id ADQA_ForAsync}');
    Execute;

    // Fill the table using batch execution
    CommandText := 'insert into {id ADQA_ForAsync}(id, name) values(:id, :name)';
    Params[0].DataType := ftInteger;
    Params[1].DataType := ftString;
    Params[1].Size     := 20;
    Params.ArraySize   := 1000;
    Prepare;
    for i := 0 to 1000 - 1 do begin
      Params[0].AsIntegers[i] := 0;
      Params[1].AsStrings[i]  := 'str' + IntToStr(i);
    end;
    Execute(1000, 0);
    Console.Lines.Add('End filling');

    // Setup Async mode
    Console.Lines.Add('Starting long running command execution...');
    Options.ResourceOptions.AsyncCmdMode := TADStanAsyncMode(rgMode.ItemIndex);
    Options.ResourceOptions.AsyncCmdTimeout := Longword(StrToInt(edtTimeout.Text));
    AsyncHandler := TMyAsyncHandler.Create(Self);

    // Prepare long running query and open
    Prepare('SELECT Count(*) FROM {id ADQA_ForAsync} a, {id ADQA_ForAsync} b GROUP BY a.name, b.name');
    try
      Open;
    except
      on E: Exception do
        // Pressing Cancel button, Open method will trow EAbort
        Console.Lines.Add('    The execution is canceled - ' + E.Message);
    end;
    Console.Lines.Add('End execution');
  end;
end;

initialization
  {$I unit1.lrs}

end.

