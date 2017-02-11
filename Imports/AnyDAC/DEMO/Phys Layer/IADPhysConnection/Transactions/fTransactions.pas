unit fTransactions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, DB, Buttons, ComCtrls,
  fMainLayers,
  daADStanOption, daADPhysIntf, jpeg;

type
  TfrmTransactions = class(TfrmMainLayers)
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
    FCommIntf: IADPhysCommand;
  public
    { Public declarations }
  end;

var
  frmTransactions: TfrmTransactions;

implementation

{$R *.dfm}

procedure TfrmTransactions.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  // Create command interface
  FConnIntf.CreateCommand(FCommIntf);

  Console.Lines.Add('Transaction isolation level is READ COMMITTED');
  // Set up trans isolation level
  FConnIntf.TxOptions.Isolation := xiReadCommitted;

  Console.Lines.Add('Begin transaction');
  // Start transaction
  FConnIntf.TxBegin;
  // Execute simple command during transaction
  try
    with FCommIntf do begin
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

end.
