unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Db, IBDatabase, IBTable, IbQuery;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    edDB: TEdit;
    bibDB: TBitBtn;
    bibConnect: TBitBtn;
    od: TOpenDialog;
    IBDB: TIBDatabase;
    BitBtn1: TBitBtn;
    IBTransaction1: TIBTransaction;
    procedure bibDBClick(Sender: TObject);
    procedure bibConnectClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
const
  DefaultTransactionParamsTwo='read_committed'+#13+
                              'rec_version'+#13+
                              'nowait';
  

implementation

{$R *.DFM}

procedure TForm1.bibDBClick(Sender: TObject);
begin
  od.FileName:=edDB.Text;
  if not od.Execute then exit;
  ibdb.DatabaseName:=od.FileName;
  bibConnectClick(nil);
  edDB.Text:=od.FileName;
end;

procedure TForm1.bibConnectClick(Sender: TObject);
begin
  ibdb.Connected:=false;
  ibdb.Connected:=true;
  ShowMessage('Connected successfull');
end;

function ChangeString(Value: string; strOld, strNew: string): string;
var
  tmps: string;
  APos: Integer;
  s1,s3: string;
  lOld: Integer;
begin
  Apos:=-1;
  s3:=Value;
  lOld:=Length(strOld);
  while APos<>0 do begin
    APos:=Pos(strOld,s3);
    if APos>0 then begin
      SetLength(s1,APos-1);
      Move(Pointer(s3)^,Pointer(s1)^,APos-1);
      s3:=Copy(s3,APos+lOld,Length(s3)-APos-lOld+1);
      tmps:=tmps+s1+strNew;
    end else
      tmps:=tmps+s3;
  end;
  Result:=tmps;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  qr1: TIBQuery;
  tran: TIBTransaction;
  tran1: TIBTransaction;
  incr: Integer;
  qr: TIBQuery;
  sqls: string;
begin
  Screen.Cursor:=crHourGlass;
  tran:=TIBTransaction.Create(nil);
  tran1:=TIBTransaction.Create(nil);
  qr1:=TIBQuery.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    qr1.Database:=IBDB;
    qr1.Transaction:=tran1;
    qr.Database:=IBDB;
    qr.Transaction:=tran;

    tran1.AddDatabase(IBDB);
    IBDB.AddTransaction(tran1);
    tran1.Params.Text:=DefaultTransactionParamsTwo;

    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;

    sqls:='Select announcement_id,textannouncement from announcement where textannouncement like ''%'+#13+#10+'%''';
    qr1.SQL.Add(sqls);
    qr1.Active:=true;
    qr1.First;
    incr:=1;
    while not qr1.Eof do begin
      Application.ProcessMessages;

      qr.SQl.Clear;
      sqls:='Update announcement set textannouncement='+QuotedStr(ChangeString(qr1.FieldByName('textannouncement').AsString,#13#10,' '))+
            ' where announcement_id='+qr1.FieldByName('announcement_id').AsString;
      qr.SQl.Add(sqls);
      qr.ExecSQL;
      Caption:='Prepeared of '+inttostr(incr)+' rows';
      qr1.Next;
      incr:=incr+1;
    end;
    tran1.Commit;
  finally
   qr.Free;
   qr1.Free;
   tran1.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

end.
