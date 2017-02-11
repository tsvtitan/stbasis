unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IBDatabase, StdCtrls, CheckLst, IBQuery, ComCtrls, ExtCtrls, IBTable,
  Menus, Buttons;

type
  TForm1 = class(TForm)
    IBDB: TIBDatabase;
    lv: TListView;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edACL: TEdit;
    PopupMenu1: TPopupMenu;
    Checkall1: TMenuItem;
    Uncheckall1: TMenuItem;
    Panel2: TPanel;
    Label2: TLabel;
    edDB: TEdit;
    bibDB: TBitBtn;
    od: TOpenDialog;
    bibConnect: TBitBtn;
    chbSetToDefautl: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure lvChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Button1Click(Sender: TObject);
    procedure Checkall1Click(Sender: TObject);
    procedure Uncheckall1Click(Sender: TObject);
    procedure bibDBClick(Sender: TObject);
    procedure bibConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TIBTableEx=class(TIBTable)
  protected
    function GetCanModify: Boolean; override;  
  end;

var
  Form1: TForm1;
const
  tbSysRelations='rdb$relations';
  tbSysRelation_fields='rdb$relation_fields';

  DefaultTransactionParamsTwo='read_committed'+#13+
                              'rec_version'+#13+
                              'nowait';
  
// AdminuserACL='0101030941444D494E55534552000206010305040000';

implementation

{$R *.DFM}

function StrToHexStr(S:String):String;
var
  i: Integer;
  l: Integer;
begin
  l:=Length(S);
  Result:='';
  for i:=1 to l do
   Result:=Result+IntToHex(Word(S[i]),2);
end;

function HexStrToStr(S:String):String;
var
  l: Integer;
  APos: Integer;
  tmps: string;
begin
  l:=Length(S);
  APos:=1;
  Result:='';
  while APos<(l+1) do begin
    tmps:=Copy(S,APos,2);
    Result:=Result+Char(StrToIntDef('$'+tmps,0));
    inc(APos,2);
  end;
end;

function TIBTableEx.GetCanModify: Boolean;
begin
  Result:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
  li: TListItem;
  ms: TMemoryStream;
  s: string;
begin
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  ms:=TMemoryStream.Create;
  lv.Items.BeginUpdate;
  try
   qr.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   tran.Params.Text:=DefaultTransactionParamsTwo;
   qr.ParamCheck:=false;
   qr.Transaction:=tran;
   qr.Transaction.Active:=true;
   sqls:='select r.rdb$relation_name, r.rdb$description, r.rdb$security_class, sc1.rdb$acl as acl1, '+
         'r.rdb$default_class, sc2.rdb$acl as acl2 '+
         'from rdb$relations r left join rdb$security_classes sc1 on '+
         'r.rdb$security_class=sc1.rdb$security_class left join rdb$security_classes sc2 on '+
         'r.rdb$default_class=sc2.rdb$security_class '+
         'order by r.rdb$relation_name';
   qr.SQL.Text:=sqls;
   qr.Active:=true;
   qr.First;
   lv.Items.Clear;
   while not qr.Eof do begin
    li:=Lv.Items.Add;
    li.Caption:=qr.FieldByName('rdb$relation_name').AsString;
    li.SubItems.Add(qr.FieldByName('rdb$description').AsString);
    li.SubItems.Add(qr.FieldByName('rdb$security_class').AsString);
    ms.Clear;
    TBlobField(qr.FieldByName('acl1')).SaveToStream(ms);
    if ms.Size<>0 then begin
      SetLength(s,ms.Size);
      MOve(ms.Memory^,Pointer(s)^,ms.Size);
      li.SubItems.Add(S);
      li.SubItems.Add(StrToHexStr(s));
      li.Checked:=true;
    end else begin
      li.SubItems.Add('');
      li.SubItems.Add('');
    end;
    li.SubItems.Add(qr.FieldByName('rdb$default_class').AsString);
    ms.Clear;
    TBlobField(qr.FieldByName('acl2')).SaveToStream(ms);
    if ms.Size<>0 then begin
      SetLength(s,ms.Size);
      MOve(ms.Memory^,Pointer(s)^,ms.Size);
      li.SubItems.Add(S);
      li.SubItems.Add(StrToHexStr(s));
      li.Checked:=true;
    end else begin
      li.SubItems.Add('');
      li.SubItems.Add('');
    end;  

    qr.Next;
   end;
  finally
   lv.Items.EndUpdate;
   ms.Free;
   qr.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.lvChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if LV.Selected=nil then exit;
  edACL.Text:=LV.Selected.SubItems[LV.Selected.SubItems.count-1];
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
  li: TListItem;
  tb: TIBTable;
  tran: TIBTransaction;
  ms: TMemoryStream;
  s,news: string;
begin
  if Trim(edAcl.Text)='' then begin
    ShowMessage('Input ACL Text');
    edAcl.SetFocus;
    exit;
  end;
  news:=edACL.Text;
  Screen.Cursor:=crHourGlass;
  tran:=TIBTransaction.Create(nil);
  ms:=TMemoryStream.Create;
  tb:=TIBTable.Create(nil);
  lv.OnChange:=nil;
//  lv.Items.BeginUpdate;
  try
    tb.Database:=IBDB;
    tb.Transaction:=tran;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    for i:=0 to lv.Items.Count-1 do begin
      li:=lv.Items[i];
      if Li.Checked then begin
        li.Selected:=true;
        li.MakeVisible(true);
        Application.ProcessMessages;

        tb.TableTypes:=[ttSystem];
        tb.Active:=false;
        tb.tablename:='rdb$security_classes';
        tb.Transaction.Active:=true;
        tb.Active:=true;
        tb.Filter:=' rdb$security_class='+QuotedStr(li.SubItems[1]);
        tb.Filtered:=true;
        tb.Edit;
        s:=HexStrToStr(news);
        ms.Clear;
        ms.SetSize(Length(s));
        Move(Pointer(s)^,ms.Memory^,Length(s));
        ms.Position:=0;
        if ms.Size>0 then begin
         TBlobField(tb.FieldByName('rdb$acl')).LoadFromStream(ms);
        end;
        tb.Post;
        tb.Transaction.Commit;
        li.SubItems[2]:=s;
        li.SubItems[3]:=news;

        if chbSetToDefautl.Checked then begin
          tb.TableTypes:=[ttSystem];
          tb.Active:=false;
          tb.tablename:='rdb$security_classes';
          tb.Transaction.Active:=true;
          tb.Active:=true;
          tb.Filter:=' rdb$security_class='+QuotedStr(li.SubItems[4]);
          tb.Filtered:=true;
          tb.Edit;
          s:=HexStrToStr(news);
          ms.Clear;
          ms.SetSize(Length(s));
          Move(Pointer(s)^,ms.Memory^,Length(s));
          ms.Position:=0;
          if ms.Size>0 then begin
           TBlobField(tb.FieldByName('rdb$acl')).LoadFromStream(ms);
          end;
          tb.Post;
          tb.Transaction.Commit;
          li.SubItems[5]:=s;
          li.SubItems[6]:=news;
        end;

      end;
    end;
  finally
   lv.OnChange:=lvChange;
//   lv.Items.EndUpdate;
   tb.Free;
   ms.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.Checkall1Click(Sender: TObject);
var
  i: Integer;
begin
  lv.Items.BeginUpdate;
  try
   for i:=0 to lv.Items.Count-1 do
     lv.Items[i].Checked:=true;
  finally
   lv.Items.EndUpdate;
  end; 
end;

procedure TForm1.Uncheckall1Click(Sender: TObject);
var
  i: Integer;
begin
  lv.Items.BeginUpdate;
  try
   for i:=0 to lv.Items.Count-1 do
     lv.Items[i].Checked:=false;
  finally
   lv.Items.EndUpdate;
  end; 
end;

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
  lv.Items.Clear;
  ShowMessage('Connected successfull');
end;

end.
