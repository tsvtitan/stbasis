unit URbkDepartEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls, ib;

type
  TFmRbkDepartEdit = class(TFmRbkEdit)
    EdCode: TEdit;
    LbCode: TLabel;
    LbName: TLabel;
    Edname: TEdit;
    LbFType: TLabel;
    EdFType: TEdit;
    LbParent: TLabel;
    EdParent: TEdit;
    BtCallParent: TButton;
    procedure BtCallParentClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EdnameChange(Sender: TObject);
    procedure EdCodeChange(Sender: TObject);
    procedure EdFTypeChange(Sender: TObject);
  private

    { Private declarations }
  protected
    function UpdateRBooks: Boolean;
    function AddToRBooks: Boolean;
  public
    ParentDepartId: Integer;
    procedure AddNode(Sender: TObject);
    procedure EditNode(Sender: TObject);
    procedure SetFilter(Sender: TObject);
    function CheckNeedFieldsExist:Boolean;
    { Public declarations }
  end;

var
  FmRbkDepartEdit: TFmRbkDepartEdit;

implementation
Uses UMainUnited, URBkDepart, UConst, UFuncProc;
{$R *.DFM}

procedure TFmRbkDepartEdit.SetFilter(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TFmRbkDepartEdit.CheckNeedFieldsExist:Boolean;
begin
  Result:=true;
  If trim(EdCode.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCode.Caption]));
    EdCode.SetFocus;
    Result:=false;
    exit;
  end;
  If trim(EdName.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  If trim(EdFtype.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbFtype.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TFmRbkDepartEdit.AddNode(Sender: TObject);
begin
  if not CheckNeedFieldsExist then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TFmRbkDepartEdit.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  parent_id: string;
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
    id:=inttostr(GetGenId(IBDB,tbDepart,1));
    if ParentDepartId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentDepartId);
    sqls:='Insert into '+tbDepart+
          ' (Depart_id,code, name, ftype, parent_id) values '+
          ' ('+id+','+QuotedStr(Trim(edCode.Text))+','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edfType.Text))+','+parent_id+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    fmRBkDepart.ActiveQuery(false);
    fmRBkDepart.IbQ.Locate('Depart_id',id,[loCaseInsensitive]);
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

procedure TFmRbkDepartEdit.EditNode(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckNeedFieldsExist then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TFmRbkDepartEdit.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id,parent_id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id:=fmRBkDepart.IbQ.FieldByName('Depart_id').AsString;
    if ParentDepartId=0 then   parent_id:='null'    else
      parent_id:=inttostr(ParentDepartId);
    qr.Database:=IBDB;
    qr.Transaction:=Trans;
    qr.Transaction.AddDatabase(IbDb);
    IbDb.AddTransaction(Trans);
    qr.Transaction.Active:=true;
    sqls:='Update '+tbDepart+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ', code = '+Trim(edCode.Text)+
          ', ftype = '+Trim(edftype.Text)+
          ', parent_id='+parent_id+
          ' where depart_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    fmRBkDepart.ActiveQuery(false);
    fmRBkDepart.IbQ.Locate('Depart_id',id,[loCaseInsensitive]);
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


procedure TFmRbkDepartEdit.BtCallParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tvibvModal;
 TPRBI.Locate.KeyFields:='depart_id';
 TPRBI.Locate.KeyValues:=ParentDepartId;
 TPRBI.Locate.Options:=[loCaseInsensitive];
 if _ViewInterfaceFromName(NameDepart,@TPRBI) then begin
   ChangeFlag:=true;
   ParentDepartId:=GetFirstValueFromParamRBookInterface(@TPRBI,'depart_id');
   EdParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
 end;
end;

procedure TFmRbkDepartEdit.btClearClick(Sender: TObject);
begin
  EdCode.clear;
  EdName.Clear;
  EdFType.Clear;
  EdParent.clear;
end;

procedure TFmRbkDepartEdit.FormActivate(Sender: TObject);
begin
  EdCode.setfocus;
end;

procedure TFmRbkDepartEdit.EdnameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TFmRbkDepartEdit.EdCodeChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TFmRbkDepartEdit.EdFTypeChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

end.
