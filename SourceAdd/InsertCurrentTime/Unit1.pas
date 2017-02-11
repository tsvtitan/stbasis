unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls;

type
  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    Timer1: TTimer;
    IBTransaction2: TIBTransaction;
    qr: TIBQuery;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    ICount: Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  qr.SQL.Clear;
  qr.SQL.Add('insert into test (test_id,indate,name) '+
             'values (3,current_timestamp,''n_'')');
  qr.ExecSQL;
  IBTransaction2.Commit;
  inc(ICount);
  Caption:='Inserted: '+inttostr(ICount);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ICount:=0;
  Timer1.Enabled:=not Timer1.Enabled; 
end;

end.
