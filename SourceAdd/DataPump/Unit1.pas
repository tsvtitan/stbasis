unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, DBGrids, DBTables, IBCustomDataSet, IBQuery, IBDatabase,
  StdCtrls;

type
  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    qr: TIBQuery;
    Query1: TQuery;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  sqls: string;
begin
  qr.Transaction.Active:=true;
  Query1.First;
  while not Query1.Eof do begin
    try
      qr.SQL.Clear;
      sqls:='Insert into ruswords (name) values('+QuotedStr(Query1.FieldByName('name').AsString)+')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
    finally

    end;
    Query1.Next;
  end;
  qr.Transaction.Commit;
end;

end.
