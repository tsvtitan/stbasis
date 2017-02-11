unit BankAccount;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, Db, IBDatabase, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ExtCtrls, DBCtrls, StdCtrls, Data;

type
  TFBank = class(TFTable)
  procedure FormCreate(Sender: TObject);
  procedure DBGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FBank: TFBank;

implementation

procedure TFBank.FormCreate(Sender: TObject);
var
   sqls: string;
   cl: TColumn;
   List: TStrings;
begin
 inherited;
  try
    Caption := 'Банковские счета';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls := 'select * from BANK';
    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;
 
    SourceQuery := sqls;


    DBGrid.Columns.Clear;
    DBGrid.OnDblClick := DBGridDblClick;

  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFBank.DBGridDblClick(Sender: TObject);
begin
  if ModeView then begin
    TempList.Clear;
    TempList.Add(Trim(IBTable.FieldByName('BANK_ID').AsString));
    TempList.Add(Trim(IBTable.FieldByName('NAME').AsString));
    ModalResult := mrOk;
  end;
end;

end.
