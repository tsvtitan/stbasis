unit UEditRBEmpDiplom;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpDiplom = class(TfmEditRB)
    lbNum: TLabel;
    edNum: TEdit;
    lbDateWhere: TLabel;
    dtpDateWhere: TDateTimePicker;
    lbProfession: TLabel;
    edProfession: TEdit;
    bibProfession: TBitBtn;
    lbTypeStud: TLabel;
    edTypeStud: TEdit;
    bibTypeStud: TBitBtn;
    lbEduc: TLabel;
    edEduc: TEdit;
    bibEduc: TBitBtn;
    lbCraft: TLabel;
    edCraft: TEdit;
    bibCraft: TBitBtn;
    lbFinishDate: TLabel;
    dtpFinishDate: TDateTimePicker;
    lbSchool: TLabel;
    edSchool: TEdit;
    bibSchool: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure bibProfessionClick(Sender: TObject);
    procedure bibTypeStudClick(Sender: TObject);
    procedure bibEducClick(Sender: TObject);
    procedure bibCraftClick(Sender: TObject);
    procedure edProfessionChange(Sender: TObject);
    procedure bibSchoolClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    profession_id: Integer;
    typestud_id: Integer;
    educ_id: Integer;
    craft_id: Integer;
    school_id: Integer;
    olddiplom_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpDiplom: TfmEditRBEmpDiplom;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpDiplom.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpDiplom.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbDiplom,1));
    sqls:='Insert into '+tbDiplom+
          ' (emp_id,diplom_id,educ_id,school_id,craft_id,typestud_id,'+
          'profession_id,num,datewhere,finishdate) values '+
          ' ('+
          inttostr(emp_id)+','+
          id+','+
          inttostr(educ_id)+','+
          inttostr(school_id)+','+
          inttostr(craft_id)+','+
          inttostr(typestud_id)+','+
          inttostr(profession_id)+','+
          QuotedStr(Trim(edNum.Text))+','+
          QuotedStr(DateTimeToStr(dtpDateWhere.Date))+','+
          QuotedStr(DateTimeToStr(dtpFinishDate.Date))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpDiplom(false);
    ParentEmpForm.qrEmpDiplom.Locate('diplom_id',id,[LocaseInsensitive]);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpDiplom.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpDiplom.UpdateRBooks: Boolean;
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
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbDiplom+
          ' set emp_id='+inttostr(emp_id)+
          ', educ_id='+inttostr(educ_id)+
          ', school_id='+inttostr(school_id)+
          ', craft_id='+inttostr(craft_id)+
          ', typestud_id='+inttostr(typestud_id)+
          ', profession_id='+inttostr(profession_id)+
          ', num='+QuotedStr(Trim(edNum.Text))+
          ', datewhere='+QuotedStr(DateTimeToStr(dtpDateWhere.Date))+
          ', finishdate='+QuotedStr(DateTimeToStr(dtpFinishDate.Date))+
          ' where diplom_id='+inttostr(olddiplom_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpDiplom(false);
    ParentEmpForm.qrEmpDiplom.Locate('diplom_id',olddiplom_id,[LocaseInsensitive]);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpDiplom.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpDiplom.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edProfession.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbProfession.Caption]));
    bibProfession.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTypeStud.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeStud.Caption]));
    bibTypeStud.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edEduc.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbEduc.Caption]));
    bibEduc.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCraft.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCraft.Caption]));
    bibCraft.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSchool.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSchool.Caption]));
    bibSchool.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpDiplom.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpDiplom.FormCreate(Sender: TObject);
var
  curdate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edProfession.MaxLength:=DomainNameLength;
  edTypeStud.MaxLength:=DomainNameLength;
  edEduc.MaxLength:=DomainNameLength;
  edCraft.MaxLength:=DomainNameLength;
  edSchool.MaxLength:=DomainNameLength;
  edNum.MaxLength:=DomainSmallNameLength;

  curdate:=_GetDateTimeFromServer;

  dtpDatewhere.date:=curdate;
  dtpFinishdate.date:=curdate;

end;

procedure TfmEditRBEmpDiplom.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpDiplom.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpDiplom.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpDiplom.bibProfessionClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='profession_id';
  TPRBI.Locate.KeyValues:=profession_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkProfession,@TPRBI) then begin
   ChangeFlag:=true;
   profession_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'profession_id');
   edProfession.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpDiplom.bibTypeStudClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typestud_id';
  TPRBI.Locate.KeyValues:=typestud_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeStud,@TPRBI) then begin
   ChangeFlag:=true;
   typestud_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typestud_id');
   edTypeStud.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpDiplom.bibEducClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='educ_id';
  TPRBI.Locate.KeyValues:=educ_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkEduc,@TPRBI) then begin
   ChangeFlag:=true;
   educ_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'educ_id');
   edEduc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpDiplom.bibCraftClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='craft_id';
  TPRBI.Locate.KeyValues:=craft_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCraft,@TPRBI) then begin
   ChangeFlag:=true;
   craft_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'craft_id');
   edCraft.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpDiplom.edProfessionChange(Sender: TObject);
begin
   ChangeFlag:=true;
end;

procedure TfmEditRBEmpDiplom.bibSchoolClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='school_id';
  TPRBI.Locate.KeyValues:=school_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSchool,@TPRBI) then begin
   ChangeFlag:=true;
   school_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'school_id');
   edSchool.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'schoolname');
  end;
end;

end.
