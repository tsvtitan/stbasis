unit fTransactions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Buttons, StdCtrls, ExtCtrls, ComCtrls,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, jpeg;

type
  TfrmTransactions = class(TfrmMainCompBase)
    ADQuery1: TADQuery;
    lblPInfo: TLabel;
    mmInfo: TMemo;
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTransactions: TfrmTransactions;

implementation

uses
  dmMainComp;

{$R *.dfm}
{ ---------------------------------------------------------------------------- }
procedure TfrmTransactions.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  mmInfo.Lines.Add('Set up trans isolation level...');
  with dmlMainComp.dbMain do begin
    TxOptions.Isolation := xiReadCommitted;
    mmInfo.Lines.Add('  Isolation Level = ReadCommitted');

    mmInfo.Lines.Add(' ');
    mmInfo.Lines.Add('Turn off auto commit mode');
    TxOptions.AutoCommit := False;

    mmInfo.Lines.Add(' ');
    mmInfo.Lines.Add('Start first transaction...');
    StartTransaction;
    try
      mmInfo.Lines.Add('  Execute simple command inside transaction');
      ADQuery1.SQL.Text := 'select * from {id Categories}';
      ADQuery1.Open;
      mmInfo.Lines.Add('  Commit transaction');
      Commit;
    except
      mmInfo.Lines.Add('  Rollback transaction');
      Rollback;
      raise;
    end;

    mmInfo.Lines.Add(' ');
    mmInfo.Lines.Add('Start second transaction...');
    StartTransaction;
    try
      mmInfo.Lines.Add('  Execute simple command during transaction, provoke an error');
      // Now we specially provoke an error to Rollback our transaction and insert into
      // integer field a string value
      ADQuery1.SQL.Text := 'insert into {id Categories}(CategoryID) values(''Provocation'')';
      ADQuery1.ExecSQL;
      mmInfo.Lines.Add('  Commit transaction');
      Commit;
    except
      mmInfo.Lines.Add('  Rollback transaction');
      // During ADQuery1.ExecSQL it's raised an exception and transaction now rollbacking
      Rollback;
      raise;
    end;
  end;
end;

end.
