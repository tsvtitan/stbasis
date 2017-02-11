unit UEditRBEmpPersonDoc;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, Mask, URBEmp;

type
  TfmEditRBEmpPersonDoc = class(TfmEditRB)
    lbSerial: TLabel;
    lbNum: TLabel;
    lbDateWhere: TLabel;
    lbPersonDocName: TLabel;
    edPersonDocName: TEdit;
    bibPersonDocName: TBitBtn;
    dtpDateWhere: TDateTimePicker;
    lbPlantName: TLabel;
    edPlantName: TEdit;
    bibPlantName: TBitBtn;
    msedSerial: TMaskEdit;
    msedNum: TMaskEdit;
    lbPodrCode: TLabel;
    msedPodrCode: TMaskEdit;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibPersonDocNameClick(Sender: TObject);
    procedure edPersonDocNameChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure bibPlantNameClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Variant;
    persondoctype_id: Variant;
    oldpersondoctype_id: Variant;
    plant_id: Variant;
    persondoctypemasknum: string;
    persondoctypemaskseries: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpPersonDoc: TfmEditRBEmpPersonDoc;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpPersonDoc.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPersonDoc.AddToRBooks: Boolean;
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
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpPersonDoc+
          ' (persondoctype_id,emp_id,plant_id,serial,num,datewhere,podrcode) values '+
          ' ('+
          inttostr(persondoctype_id)+','+
          inttostr(emp_id)+','+
          inttostr(plant_id)+','+
          QuotedStr(Trim(msedSerial.Text))+','+
          QuotedStr(Trim(msedNum.Text))+','+
          GetStrFromCondition(dtpDateWhere.Checked,
                              QuotedStr(DateTimeToStr(dtpDateWhere.Date)),
                              'null')+','+
          QuotedStr(Trim(msedPodrCode.Text))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpPersonDoc(false);
    ParentEmpForm.qrEmpPersonDoc.Locate('persondoctype_id',persondoctype_id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpPersonDoc.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPersonDoc.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbEmpPersonDoc+
          ' set emp_id='+inttostr(emp_id)+
          ', persondoctype_id='+inttostr(persondoctype_id)+
          ', plant_id='+inttostr(plant_id)+
          ', serial='+QuotedStr(Trim(msedSerial.Text))+
          ', num='+QuotedStr(Trim(msedNum.Text))+
          ', podrcode='+QuotedStr(Trim(msedPodrCode.Text))+
          ', datewhere='+GetStrFromCondition(dtpDateWhere.Checked,
                              QuotedStr(DateTimeToStr(dtpDateWhere.Date)),
                              'null')+
          ' where persondoctype_id='+inttostr(oldpersondoctype_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpPersonDoc(false);
    ParentEmpForm.qrEmpPersonDoc.Locate('persondoctype_id',persondoctype_id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpPersonDoc.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPersonDoc.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edPersonDocName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPersonDocName.Caption]));
    bibPersonDocName.SetFocus;
    Result:=false;
    exit;
  end;
{  if trim(edSerial.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSerial.Caption]));
    edSerial.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end; }
  if trim(edPlantName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPlantName.Caption]));
    bibPlantName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpPersonDoc.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPersonDoc.FormCreate(Sender: TObject);
var
  curdate: Tdate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edPersonDocName.MaxLength:=DomainNameLength;
  msedSerial.MaxLength:=DomainSmallNameLength;
  msedNum.MaxLength:=DomainSmallNameLength;
  edPlantName.MaxLength:=DomainNameLength;

  curdate:=_GetDateTimeFromServer;
  dtpDateWhere.date:=curdate;
  dtpDateWhere.Checked:=false;

end;

procedure TfmEditRBEmpPersonDoc.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPersonDoc.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPersonDoc.bibPersonDocNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='persondoctype_id';
  TPRBI.Locate.KeyValues:=persondoctype_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPersonDocType,@TPRBI) then begin
   ChangeFlag:=true;
   persondoctype_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'persondoctype_id');
   msedSerial.Text:='';
   msedSerial.EditMask:=GetFirstValueFromParamRBookInterface(@TPRBI,'maskSeries');
   msedNum.Text:='';
   msedNum.EditMask:=GetFirstValueFromParamRBookInterface(@TPRBI,'masknum');
   edPersonDocName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
   msedPodrCode.Text:='';
   msedPodrCode.EditMask:=GetFirstValueFromParamRBookInterface(@TPRBI,'maskpodrcode');
  end;
end;

procedure TfmEditRBEmpPersonDoc.edPersonDocNameChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpPersonDoc.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpPersonDoc.bibPlantNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='plant_id';
  TPRBI.Locate.KeyValues:=plant_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPlant,@TPRBI) then begin
   ChangeFlag:=true;
   plant_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'plant_id');
   edPlantName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'smallname');
  end;
end;

end.
