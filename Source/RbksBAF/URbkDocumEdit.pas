unit URbkDocumEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, Ib;

type
  TFmRbkDocumEdit = class(TFmRbkEdit)
    EdNum: TEdit;
    LbNum: TLabel;
    LbTypeDoc: TLabel;
    EdTypeDoc: TEdit;
    BtCallTypeDoc: TButton;
    DPDateDoc: TDateTimePicker;
    LbDateDoc: TLabel;
    procedure BtCallTypeDocClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EdNumChange(Sender: TObject);
    procedure EdTypeDocKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  protected
    function UpdateRBooks: Boolean;
    function AddToRBooks: Boolean;
  public
    { Public declarations }
    Locate_id, TypeDoc_id:integer;

    procedure AddRecord(Sender: TObject);
    procedure EditRecord(Sender: TObject);
    procedure SetFilter(Sender: TObject);
    function CheckNeedFieldsExist:Boolean;
  end;

var
  FmRbkDocumEdit: TFmRbkDocumEdit;

implementation
Uses UMainUnited, URBkDocum, UConst, UFuncProc;
{$R *.DFM}
procedure TFmRbkDocumEdit.AddRecord(Sender: TObject);
begin
  if not CheckNeedFieldsExist then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TFmRbkDocumEdit.CheckNeedFieldsExist:Boolean;
begin
  Result:=true;
  If trim(EdNum.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNum.Caption]));
    EdNum.SetFocus;
    Result:=false;
    exit;
  end;
  If trim(EdTypeDoc.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeDoc.Caption]));
    BtCallTypeDoc.SetFocus;
    Result:=false;
    exit;
  end;
end;

function TFmRbkDocumEdit.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=trans;
    trans.AddDatabase(IbDb);
    IbDb.AddTransaction(trans);
    qr.Transaction.Active:=true;
    Locate_id:=GetGenId(IBDB,tbDocum,1);
    sqls:='Insert into '+tbDocum+
          ' (Docum_id, typedoc_id, num, DateDoc, parent_id) values '+
          ' ('+IntToStr(Locate_id)+','+IntToSTr(typedoc_id)+','+
          QuotedStr(Trim(edNum.Text))+','+QuotedStr(DateToStr(DPdatedoc.date))+
          ',null)';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

//    fmRBkDocum.ActiveQuery(false);
//    fmRBkDocum.IbQ.Locate('Docum_id',id,[loCaseInsensitive]);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TFmRbkDocumEdit.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    Locate_id:=FmRbkDocum.RbkQuery.FieldByName('Docum_id').AsInteger;
    qr.Database:=IBDB;
    qr.Transaction:=Trans;
    qr.Transaction.AddDatabase(IbDb);
    IbDb.AddTransaction(Trans);
    qr.Transaction.Active:=true;
    sqls:='Update '+tbDocum+
          ' set Num='+QuotedStr(Trim(edNum.Text))+
          ', TypeDoc_id = '+IntToStr(TypeDoc_id)+
          ', dateDoc = '+QuotedStr(DateToStr(DPdatedoc.date))+
          ' where docum_id='+IntToStr(Locate_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmRbkDocumEdit.EditRecord(Sender: TObject);
begin
  if ChangeFlag then
  begin
   if not CheckNeedFieldsExist then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

procedure TFmRbkDocumEdit.SetFilter(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


procedure TFmRbkDocumEdit.BtCallTypeDocClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typeDoc_id';
  TPRBI.Locate.KeyValues:=TypeDoc_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameTypeDoc,@TPRBI) then
  begin
    ChangeFlag:=true;
    TypeDoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeDoc_id');
    EdTypeDoc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TFmRbkDocumEdit.btClearClick(Sender: TObject);
begin
  EdNum.clear;
  EdTypeDoc.clear;
  DPDateDoc.Checked:=false;
end;

procedure TFmRbkDocumEdit.FormActivate(Sender: TObject);
begin
  inherited;
  EdNum.setfocus;
end;

procedure TFmRbkDocumEdit.EdNumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TFmRbkDocumEdit.EdTypeDocKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    EdTypeDoc.Clear;
    ChangeFlag:=true;
    TypeDoc_id:=0;
  end;

end;

end.
