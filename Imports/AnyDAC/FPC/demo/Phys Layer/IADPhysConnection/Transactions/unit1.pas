unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons,
  daADStanDef, daADStanAsync, daADStanExpr, daADStanOption, daADStanPool,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysOracl;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Console: TMemo;
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

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);
begin
  ADPhysManager.Open;
  ADPhysManager.CreateConnection('Oracle_Demo', FConnIntf);
  FConnIntf.Open;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  oCommIntf: IADPhysCommand;
begin
  // Create command interface
  FConnIntf.CreateCommand(oCommIntf);

  Console.Lines.Add('Transaction isolation level is READ COMMITTED');
  // Set up trans isolation level
  FConnIntf.TxOptions.Isolation := xiReadCommitted;

  Console.Lines.Add('Begin transaction');
  // Start transaction
  FConnIntf.TxBegin;
  // Execute simple command during transaction
  try
    with oCommIntf do begin
      Prepare('delete from {id ADQA_TransTable}');
      Execute;
    end;

    Console.Lines.Add('Committing transaction');
    // Commit transaction
    FConnIntf.TxCommit;
  except
    Console.Lines.Add('Rollbacking transaction');
    // If exception - Rollback transaction
    FConnIntf.TxRollback;
    raise;
  end;
end;

initialization
  {$I unit1.lrs}

end.

