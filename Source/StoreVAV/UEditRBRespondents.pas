unit UEditRBRespondents;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, Mask, URBRespondents;

type
  TfmEditRBRespondents = class(TfmEditRB)
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
    edFname: TMaskEdit;
    edName: TMaskEdit;
    lbFname: TLabel;
    lbName: TLabel;
    edSname: TMaskEdit;
    lbSname: TLabel;
    msedCod: TMaskEdit;
    lbKod: TLabel;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibPersonDocNameClick(Sender: TObject);
    procedure edPersonDocNameChange(Sender: TObject);
    procedure bibPlantNameClick(Sender: TObject);
    procedure edPersonDocNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPlantNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFnameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSnameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
//    function EnabledControl:Boolean;
  public
    persondoctype_id: Variant;
    Respondents_id: Variant;
    oldRespondents_id: Variant;
    plant_id: Variant;
    persondoctypemasknum: string;
    persondoctypemaskseries: string;
    persondoctypemaskcod: string;
    function EnabledControl:Boolean;    
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBRespondents: TfmEditRBRespondents;

implementation

uses UStoreVAVCode, UStoreVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBRespondents.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBRespondents.AddToRBooks: Boolean;
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


    Respondents_id:=GetGenId(IBDB,tbRespondents,1);
    sqls:='Insert into '+tbRespondents+
          ' (Respondents_id,fname,name,sname,series,num,cod,datewhere,plant_id,persondoctype_id) values '+
          ' ('+
          inttostr(Respondents_id)+','+
          QuotedStr(Trim(edFname.Text))+','+
          QuotedStr(Trim(edName.Text))+','+
          QuotedStr(Trim(edSname.Text))+','+
          QuotedStr(Trim(msedSerial.Text))+','+
          QuotedStr(Trim(msedNum.Text))+','+
          QuotedStr(Trim(msedCod.Text))+','+
          GetStrFromCondition(dtpDateWhere.Checked,
                              QuotedStr(DateTimeToStr(dtpDateWhere.Date)),
                              'null')+','+
          GetStrFromCondition(plant_id<>0,
                              inttostr(plant_id),
                              'null')+','+
          GetStrFromCondition(persondoctype_id<>0,
                              inttostr(persondoctype_id),
                              'null')+')';

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
  {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
   {$ENDIF}
 end;
end;

procedure TfmEditRBRespondents.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBRespondents.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbRespondents+
          ' set FName='+QuotedStr(Trim(edFname.Text))+
          ', Name='+QuotedStr(Trim(edName.Text))+
          ', SName='+QuotedStr(Trim(edSname.Text))+
          ', persondoctype_id='+GetStrFromCondition(persondoctype_id<>0,inttostr(persondoctype_id),'null')+
          ', series='+QuotedStr(Trim(msedSerial.Text))+
          ', num='+QuotedStr(Trim(msedNum.Text))+
          ', cod='+QuotedStr(Trim(msedCod.Text))+
          ', datewhere='+GetStrFromCondition(dtpDateWhere.Checked,QuotedStr(DateTimeToStr(dtpDateWhere.Date)),'null')+
          ', plant_id='+GetStrFromCondition(plant_id<>0,''+inttostr(plant_id),'null')+
          ' where Respondents_id='+inttostr(oldRespondents_id);

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
  {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end;
end;

procedure TfmEditRBRespondents.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBRespondents.CheckFieldsFill: Boolean;
begin
  Result:=false;

  if trim(edFname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbFname.Caption]));
    edFname.SetFocus;
    exit;
  end;
  if trim(edname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbname.Caption]));
    edname.SetFocus;
    exit;
  end;
  if trim(edSname.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbSname.Caption]));
    edSname.SetFocus;
    exit;
  end;

  if trim(edPersonDocName.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPersonDocName.Caption]));
    bibPersonDocName.SetFocus;
    exit;
  end;

  if (edPlantName.Enabled) and  (trim(edPlantName.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPlantName.Caption]));
    bibPlantName.SetFocus;
    exit;
  end;
  //¬ключить проверку на серию и номер документв

  if trim(edPlantName.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPlantName.Caption]));
    bibPlantName.SetFocus;
//    Result:=false;
    exit;
  end;
    Result:=True;
end;

procedure TfmEditRBRespondents.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBRespondents.FormCreate(Sender: TObject);
var
  curdate: Tdate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edFname.MaxLength:=DomainNameLength;
  edname.MaxLength:=DomainSmallNameLength;
  edSname.MaxLength:=DomainSmallNameLength;
  edPersonDocName.MaxLength:=DomainNameLength;
  msedSerial.MaxLength:=DomainSmallNameLength;
  msedNum.MaxLength:=DomainSmallNameLength;
  msedCod.MaxLength:=DomainSmallNameLength;
  edPlantName.MaxLength:=DomainNameLength;

  curdate:=_GetDateTimeFromServer;
  dtpDateWhere.date:=curdate;
  dtpDateWhere.Checked:=false;

end;

procedure TfmEditRBRespondents.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBRespondents.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

function TfmEditRBRespondents.EnabledControl:Boolean;
begin
   if Trim(msedSerial.EditMask) <> '' then msedSerial.Enabled:=true else msedSerial.Enabled:=false;
   if Trim(msedNum.EditMask) <> '' then msedNum.Enabled:=true else msedNum.Enabled:=false;
   if Trim(msedCod.EditMask) <> '' then msedCod.Enabled:=true else msedCod.Enabled:=false;
   if  Trim(edPersonDocName.Text)<> '' then
      begin
         edPlantName.Enabled:=true;
         bibPlantName.Enabled:=true;
         dtpDateWhere.Enabled:=true;
      end
        else
      begin
        edPlantName.Enabled:=false;
        bibPlantName.Enabled:=false;
        dtpDateWhere.Enabled:=false;
      end;
end;

procedure TfmEditRBRespondents.bibPersonDocNameClick(Sender: TObject);
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
   msedCod.Text:='';
//   msedCod.EditMask:=GetFirstValueFromParamRBookInterface(@TPRBI,'MaskPodrCode');
   edPersonDocName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
   EnabledControl;
  end;
end;

procedure TfmEditRBRespondents.edPersonDocNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
if (Trim(edPersonDocName.Text)='') then persondoctype_id:=0;
end;


procedure TfmEditRBRespondents.bibPlantNameClick(Sender: TObject);
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

procedure TfmEditRBRespondents.edPersonDocNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then
    begin
      edPersonDocName.Text:='';
      ChangeFlag:=true;
      persondoctype_id:=0;
      msedSerial.Text:='';
      msedNum.Text:='';
      msedCod.Text:='';
      msedSerial.EditMask:='';
      msedNum.EditMask:='';
      msedCod.EditMask:='';
      msedSerial.Enabled:=false;
      msedNum.Enabled:=false;
      msedCod.Enabled:=false;
      EnabledControl;
    end;
end;

procedure TfmEditRBRespondents.edPlantNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edPlantName.Text:='';
    ChangeFlag:=true;
    plant_id:=0;
  end;
end;

procedure TfmEditRBRespondents.edFnameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
if Key=32 then edName.SetFocus;
end;

procedure TfmEditRBRespondents.edNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
if Key=32 then edSname.SetFocus;
end;

procedure TfmEditRBRespondents.edSnameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
if Key=32 then bibPersonDocName.SetFocus;

end;

end.
