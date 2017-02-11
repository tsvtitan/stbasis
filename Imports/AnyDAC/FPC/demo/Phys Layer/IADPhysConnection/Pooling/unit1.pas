unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
    Buttons, StdCtrls,
  daADStanDef, daADStanAsync, daADStanExpr, daADStanOption, daADStanPool,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysOracl;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnRun: TButton;
    cbPooled: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    lblTotalExec: TLabel;
    lblTotalTime: TLabel;
    Console: TMemo;
    procedure btnRunClick(Sender: TObject);
  private
    FCount: Integer;
    FStartTime: LongWord;
  public
    procedure Executed;
  end;

var
  Form1: TForm1; 

implementation

const
  C_ConnDefName = 'Oracle_Demo';

type
  TConnectThread = class(TThread)
  private
    FForm: TForm1;
  public
    constructor Create(AForm: TForm1);
    procedure Execute; override;
  end;

constructor TConnectThread.Create(AForm: TForm1);
begin
  FForm := AForm;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TConnectThread.Execute;
var
  i:      Integer;
  oTab:   TADDatSTable;
  oConn:  IADPhysConnection;
  oComm:  IADPhysCommand;
  lClose: Boolean;
begin
  ADPhysManager.CreateConnection(C_ConnDefName, oConn);
  oConn.CreateCommand(oComm);
  oComm.Options.FetchOptions.Items := oComm.Options.FetchOptions.Items - [fiMeta];
  oTab := TADDatSTable.Create;
  lClose := False;
  try
    for i := 1 to 50 do
      with oComm do begin
        if oConn.State = csDisconnected then begin
          lClose := True;
          oConn.Open;
        end;
        Prepare('select count(*) from {id Region}');
        Define(oTab);
        Open;
        if lClose then
          oConn.Close;
        Synchronize(Self, @FForm.Executed);
      end;
  finally
    oTab.Free;
  end;
end;

procedure TForm1.Executed;
begin
  Inc(FCount);
  if (FCount mod 10) = 0 then
    lblTotalExec.Caption := IntToStr(FCount);
  if FCount = 500 then
    lblTotalTime.Caption := FloatToStr((GetTickCount - FStartTime) / 1000.0);
end;

procedure TForm1.btnRunClick(Sender: TObject);
var
  i: Integer;
begin
  if ADPhysManager.State = dmsActive then
    ADPhysManager.Close(True);
  ADPhysManager.Open;
  if cbPooled.Checked then begin
    ADPhysManager.ConnectionDefs.ConnectionDefByName(C_ConnDefName).Pooled := True;
    Console.Lines.Add('Run pooled...');
  end
  else begin
    ADPhysManager.ConnectionDefs.ConnectionDefByName(C_ConnDefName).Pooled := False;
    Console.Lines.Add('Run non pooled...');
  end;
  FStartTime := GetTickCount;
  FCount := 0;
  lblTotalExec.Caption := '---';
  lblTotalTime.Caption := '---';
  for i := 1 to 10 do
    TConnectThread.Create(Self);
end;

initialization
  {$I unit1.lrs}

end.

