unit UEditRBEmpPlant;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpPlant = class(TfmEditRB)
    lbCategory: TLabel;
    lbDateStart: TLabel;
    dtpDateStart: TDateTimePicker;
    lbPlant: TLabel;
    edPlant: TEdit;
    bibPlant: TBitBtn;
    lbNet: TLabel;
    edNet: TEdit;
    bibNet: TBitBtn;
    lbReasonDocum: TLabel;
    edReasonDocum: TEdit;
    bibReasonDocum: TBitBtn;
    edCategory: TEdit;
    bibCategory: TBitBtn;
    lbOrderDocum: TLabel;
    edOrderDocum: TEdit;
    bibOrderDocum: TBitBtn;
    lbProf: TLabel;
    edProf: TEdit;
    bibProf: TBitBtn;
    grbRemove: TGroupBox;
    lbReleaseDate: TLabel;
    dtpReleaseDate: TDateTimePicker;
    lbMotive: TLabel;
    edMotive: TEdit;
    bibMotive: TBitBtn;
    lbschedule: TLabel;
    edschedule: TEdit;
    bibschedule: TBitBtn;
    lbMotiveDocum: TLabel;
    edMotiveDocum: TEdit;
    bibMotiveDocum: TBitBtn;
    grbForSeatClass: TGroupBox;
    lbDepart: TLabel;
    edDepart: TEdit;
    bibDepart: TBitBtn;
    lbSeat: TLabel;
    edSeat: TEdit;
    bibSeat: TBitBtn;
    lbClass: TLabel;
    edClass: TEdit;
    bibClass: TBitBtn;
    bibFromSeatClass: TBitBtn;
    lbPay: TLabel;
    edPay: TEdit;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure bibPlantClick(Sender: TObject);
    procedure bibNetClick(Sender: TObject);
    procedure bibClassClick(Sender: TObject);
    procedure bibReasonDocumClick(Sender: TObject);
    procedure edPlantChange(Sender: TObject);
    procedure bibCategoryClick(Sender: TObject);
    procedure bibSeatClick(Sender: TObject);
    procedure bibDepartClick(Sender: TObject);
    procedure bibOrderDocumClick(Sender: TObject);
    procedure bibMotiveClick(Sender: TObject);
    procedure bibProfClick(Sender: TObject);
    procedure bibscheduleClick(Sender: TObject);
    procedure bibMotiveDocumClick(Sender: TObject);
    procedure edMotiveKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edMotiveDocumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPayKeyPress(Sender: TObject; var Key: Char);
    procedure edPayChange(Sender: TObject);
    procedure bibFromSeatClassClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetMaxStaffCount: Integer;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Variant;
    net_id: Variant;
    class_id: Variant;
    plant_id: Variant;
    reasondocum_id: Variant;
    category_id: Variant;
    seat_id: Variant;
    depart_id: Variant;
    orderdocum_id: Variant;
    motive_id: Variant;
    prof_id: Variant;
    schedule_id: Integer;
    motivedocum_id: Variant;

    seatclass_id: Variant;
    minpay,maxpay: Currency;
    staffcount: Integer;

    factpay_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpPlant: TfmEditRBEmpPlant;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpPlant.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPlant.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id,id1,id2: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbEmpPlant,1));
    sqls:='Insert into '+tbEmpPlant+
          ' (empplant_id,emp_id,net_id,class_id,plant_id,reasondocum_id,'+
          'category_id,seat_id,depart_id,orderdocum_id,prof_id,'+
          'datestart,releasedate,motive_id,motivedocum_id) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          inttostr(net_id)+','+
          inttostr(class_id)+','+
          inttostr(plant_id)+','+
          inttostr(reasondocum_id)+','+
          inttostr(category_id)+','+
          inttostr(seat_id)+','+
          inttostr(depart_id)+','+
          inttostr(orderdocum_id)+','+
          inttostr(prof_id)+','+
          QuotedStr(DateTimeToStr(dtpDateStart.Date))+','+
          GetStrFromCondition(dtpReleaseDate.Checked,
                              QuotedStr(DateTimeToStr(dtpReleaseDate.Date)),
                              'null')+','+
          GetStrFromCondition(Trim(edMotive.Text)<>'',
                              inttostr(motive_id),
                              'null')+','+
          GetStrFromCondition(Trim(edMotiveDocum.Text)<>'',
                              inttostr(motivedocum_id),
                              'null')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    qr.SQL.Clear;
    id1:=inttostr(GetGenId(IBDB,tbEmpPlantSchedule,1));
    sqls:='Insert into '+tbEmpPlantSchedule+
          '(empplantschedule_id,docum_id,schedule_id,empplant_id)values('+
          id1+','+
          inttostr(reasondocum_id)+','+
          inttostr(schedule_id)+','+
          id+')';
    qr.SQL.Add(sqls);
    qr.Transaction.Active:=true;
    qr.ExecSQL;


    qr.SQL.Clear;
    id2:=inttostr(GetGenId(IBDB,tbFactPay,1));
    sqls:='Insert into '+tbFactPay+
          '(factpay_id,docum_id,empplant_id,pay)values('+
          id2+','+
          inttostr(reasondocum_id)+','+
          id+','+
          QuotedStr(ChangeChar(Trim(edPay.Text),',','.'))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpPlant(false);
    ParentEmpForm.qrEmpPlant.Locate('empplant_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpPlant.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPlant.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpPlant.FieldByName('empplant_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpPlant+
          ' set emp_id='+inttostr(emp_id)+
          ', net_id='+inttostr(net_id)+
          ', class_id='+inttostr(class_id)+
          ', plant_id='+inttostr(plant_id)+
          ', reasondocum_id='+inttostr(reasondocum_id)+
          ', category_id='+inttostr(category_id)+
          ', seat_id='+inttostr(seat_id)+
          ', depart_id='+inttostr(depart_id)+
          ', orderdocum_id='+inttostr(orderdocum_id)+
          ', prof_id='+inttostr(prof_id)+
          ', datestart='+QuotedStr(DateTimeToStr(dtpDateStart.Date))+
          ', motive_id='+GetStrFromCondition(Trim(edMotive.Text)<>'',
                                             inttostr(motive_id),
                                             'null')+
          ', motivedocum_id='+GetStrFromCondition(Trim(edMotiveDocum.Text)<>'',
                                                  inttostr(motivedocum_id),
                                                  'null')+
          ', releasedate='+GetStrFromCondition(dtpReleaseDate.Checked,
                              QuotedStr(DateTimeToStr(dtpReleaseDate.Date)),
                              'null')+
          ' where empplant_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    sqls:='Update '+tbFactPay+
          ' set pay='+QuotedStr(ChangeChar(Trim(edPay.Text),',','.'))+
          ' where factpay_id='+inttostr(factpay_id);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpPlant(false);
    ParentEmpForm.qrEmpPlant.Locate('empplant_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpPlant.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPlant.CheckFieldsFill: Boolean;
var
  TPRBI: TParamRBookInterface;
  but: Integer;       
begin
  Result:=true;
  if trim(edPlant.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPlant.Caption]));
    bibPlant.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edReasonDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbReasonDocum.Caption]));
    bibReasonDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(ednet.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNet.Caption]));
    bibnet.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCategory.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCategory.Caption]));
    bibCategory.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edDepart.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbDepart.Caption]));
    bibDepart.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSeat.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSeat.Caption]));
    bibSeat.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edClass.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbClass.Caption]));
    bibClass.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPay.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPay.Caption]));
    edPay.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edOrderDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbOrderDocum.Caption]));
    bibOrderDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edProf.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbprof.Caption]));
    bibprof.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edschedule.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbschedule.Caption]));
    bibschedule.SetFocus;
    Result:=false;
    exit;
  end;
  if dtpReleaseDate.Checked then begin
   if trim(edMotive.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbMotive.Caption]));
    bibMotive.SetFocus;
    Result:=false;
    exit;
   end;
   if trim(edMotiveDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbMotiveDocum.Caption]));
    bibMotiveDocum.SetFocus;
    Result:=false;
    exit;
   end;
  end else begin
   if trim(edMotive.Text)<>'' then begin
    ShowErrorEx(Format(ConstFieldEmpty,[lbMotive.Caption]));
    bibMotive.SetFocus;
    Result:=false;
    exit;
   end;
   if trim(edMotiveDocum.Text)<>'' then begin
    ShowErrorEx(Format(ConstFieldEmpty,[lbMotiveDocum.Caption]));
    bibMotiveDocum.SetFocus;
    Result:=false;
    exit;
   end;
  end;

 try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Locate.KeyFields:='seatclass_id;depart_id;seat_id;class_id';
   TPRBI.Locate.KeyValues:=VarArrayOf([-1,depart_id,seat_id,class_id]);
   TPRBI.Locate.Options:=[loCaseInsensitive];
   Result:=true;
   if _ViewInterfaceFromName(NameRbkSeatClass,@TPRBI) then begin
     seatclass_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'seatclass_id');
     minpay:=GetFirstValueFromParamRBookInterface(@TPRBI,'minpay');
     maxpay:=GetFirstValueFromParamRBookInterface(@TPRBI,'maxpay');
     staffcount:=GetFirstValueFromParamRBookInterface(@TPRBI,'staffcount');

     if staffcount<=GetMaxStaffCount then begin
      but:=ShowQuestionEx(Format(ConstFieldStaffCountOverrun,[edDepart.Text,edSeat.Text,edClass.Text]));
      case but of
        mrYes: Result:=true;
        mrNo: begin
         bibDepart.SetFocus;
         Result:=false;
         exit;
        end;
      end;
     end;
     if (StrToFloat(edPay.Text)>maxpay)or(StrToFloat(edPay.Text)<minpay) then begin
      but:=ShowQuestionEx(Format(ConstFieldPayOverrun,[lbPay.Caption,
                                                            Trim(Format('%15.2m',[minpay])),
                                                            Trim(Format('%15.2m',[maxpay]))]));
      case but of
        mrYes: Result:=true;
        mrNo: begin
         edPay.SetFocus;
         Result:=false;
         exit;
        end;
      end;
     end;

   end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

end;

procedure TfmEditRBEmpPlant.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPlant.FormCreate(Sender: TObject);
var
  curdate: TDateTime;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  curdate:=_GetDateTimeFromServer;
  edPlant.MaxLength:=DomainNameLength;
  edNet.MaxLength:=DomainNameLength;
  edClass.MaxLength:=DomainSmallNameLength;
  edReasonDocum.MaxLength:=DomainSmallNameLength;
  edCategory.MaxLength:=DomainNameLength;
  edSeat.MaxLength:=DomainNameLength;
  edDepart.MaxLength:=DomainNameLength;
  edOrderDocum.MaxLength:=DomainSmallNameLength;
  edMotive.MaxLength:=DomainNameLength;
  edProf.MaxLength:=DomainNameLength;
  edMotiveDocum.MaxLength:=DomainSmallNameLength;

  dtpDateStart.date:=curdate;
  dtpReleaseDate.date:=curdate;
  dtpReleaseDate.Checked:=false;
  edPay.MaxLength:=18;

{  net_id:=1;
  class_id:=1;
  plant_id:=1;
  reasondocum_id:=1;
  category_id:=1;
  seat_id:=1;
  depart_id:=1;
  orderdocum_id:=1;
  motive_id:=1;
  prof_id:=1;}

  minpay:=1000;
  maxpay:=1000;
  staffcount:=3;
end;

procedure TfmEditRBEmpPlant.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPlant.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPlant.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpPlant.bibPlantClick(Sender: TObject);
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
   edPlant.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'smallname');
  end;
end;

procedure TfmEditRBEmpPlant.bibNetClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='net_id';
  TPRBI.Locate.KeyValues:=net_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkNet,@TPRBI) then begin
   ChangeFlag:=true;
   net_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'net_id');
   edNet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibClassClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='class_id';
  TPRBI.Locate.KeyValues:=class_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkClass,@TPRBI) then begin
   ChangeFlag:=true;
   class_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'class_id');
   edClass.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'num');
  end;
end;

procedure TfmEditRBEmpPlant.bibReasonDocumClick(Sender: TObject);
var
  TPJI: TParamJournalInterface;
begin
  FillChar(TPJI,SizeOf(TPJI),0);
  TPJI.Visual.TypeView:=tvibvModal;
  TPJI.Locate.KeyFields:='docum_id';
  TPJI.Locate.KeyValues:=reasondocum_id;
  TPJI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameJrDocum,@TPJI) then begin
   ChangeFlag:=true;
   reasondocum_id:=GetFirstValueFromParamJournalInterface(@TPJI,'docum_id');
   edReasonDocum.Text:=GetFirstValueFromParamJournalInterface(@TPJI,'num');
  end;
end;

procedure TfmEditRBEmpPlant.edPlantChange(Sender: TObject);
begin
   ChangeFlag:=true;
   if dtpReleaseDate.Checked then begin
     lbMotive.Enabled:=true;
     edMotive.Enabled:=true;
     bibMotive.Enabled:=true;
     lbMotiveDocum.Enabled:=true;
     edMotiveDocum.Enabled:=true;
     bibMotiveDocum.Enabled:=true;
   end else begin
     lbMotive.Enabled:=false;
     edMotive.Enabled:=false;
     bibMotive.Enabled:=false;
     lbMotiveDocum.Enabled:=false;
     edMotiveDocum.Enabled:=false;
     bibMotiveDocum.Enabled:=false;
   end;
end;

procedure TfmEditRBEmpPlant.bibCategoryClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='category_id';
  TPRBI.Locate.KeyValues:=category_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCategory,@TPRBI) then begin
   ChangeFlag:=true;
   category_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'category_id');
   edCategory.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibSeatClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='seat_id';
  TPRBI.Locate.KeyValues:=seat_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSeat,@TPRBI) then begin
   ChangeFlag:=true;
   seat_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'seat_id');
   edSeat.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibDepartClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='depart_id';
  TPRBI.Locate.KeyValues:=depart_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkDepart,@TPRBI) then begin
   ChangeFlag:=true;
   depart_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'depart_id');
   edDepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibOrderDocumClick(Sender: TObject);
var
  TPJI: TParamJournalInterface;
begin
  FillChar(TPJI,SizeOf(TPJI),0);
  TPJI.Visual.TypeView:=tvibvModal;
  TPJI.Locate.KeyFields:='docum_id';
  TPJI.Locate.KeyValues:=orderdocum_id;
  TPJI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameJrDocum,@TPJI) then begin
   ChangeFlag:=true;
   orderdocum_id:=GetFirstValueFromParamJournalInterface(@TPJI,'docum_id');
   edOrderDocum.Text:=GetFirstValueFromParamJournalInterface(@TPJI,'num');
  end;
end;

procedure TfmEditRBEmpPlant.bibMotiveClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='motive_id';
  TPRBI.Locate.KeyValues:=motive_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkMotive,@TPRBI) then begin
   ChangeFlag:=true;
   motive_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'motive_id');
   edMotive.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibProfClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='prof_id';
  TPRBI.Locate.KeyValues:=prof_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkProf,@TPRBI) then begin
   ChangeFlag:=true;
   prof_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'prof_id');
   edProf.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibscheduleClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='schedule_id';
  TPRBI.Locate.KeyValues:=schedule_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSchedule,@TPRBI) then begin
   ChangeFlag:=true;
   schedule_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'schedule_id');
   edschedule.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpPlant.bibMotiveDocumClick(Sender: TObject);
var
  TPJI: TParamJournalInterface;
begin
  FillChar(TPJI,SizeOf(TPJI),0);
  TPJI.Visual.TypeView:=tvibvModal;
  TPJI.Locate.KeyFields:='docum_id';
  TPJI.Locate.KeyValues:=motivedocum_id;
  TPJI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameJrDocum,@TPJI) then begin
   ChangeFlag:=true;
   motivedocum_id:=GetFirstValueFromParamJournalInterface(@TPJI,'docum_id');
   edMotiveDocum.Text:=GetFirstValueFromParamJournalInterface(@TPJI,'num');
  end;
end;

procedure TfmEditRBEmpPlant.edMotiveKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edMotive.Text:='';
    motive_id:=0;
  end;
end;

procedure TfmEditRBEmpPlant.edMotiveDocumKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edMotiveDocum.Text:='';
    motivedocum_id:=0;
  end;
end;

procedure TfmEditRBEmpPlant.edPayKeyPress(Sender: TObject; var Key: Char);
var
  APos: Integer;
begin
  ChangeFlag:=true;
  if (not (Key in ['0'..'9']))and
   (Key<>DecimalSeparator)and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if Pos(String(DecimalSeparator),TEdit(Sender).Text)>0 then
    if (Length(TEdit(Sender).Text)-Pos(String(DecimalSeparator),TEdit(Sender).Text)>=2)
        and (Integer(Key)<>VK_Back) then begin
     Key:=#0;
     exit;
    end;
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;

procedure TfmEditRBEmpPlant.edPayChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPlant.bibFromSeatClassClick(Sender: TObject);

  procedure SetDepartName;
  var
    TPRBI: TParamRBookInterface;
  begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' depart_id='+inttostr(depart_id)+' ');
    if _ViewInterfaceFromName(NameRbkDepart,@TPRBI) then begin
     ChangeFlag:=true;
     depart_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'depart_id');
     edDepart.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
    end;
  end;

  procedure SetSeatName;
  var
    TPRBI: TParamRBookInterface;
  begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' seat_id='+inttostr(seat_id)+' ');
    if _ViewInterfaceFromName(NameRbkSeat,@TPRBI) then begin
     ChangeFlag:=true;
     seat_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'seat_id');
     edSeat.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
    end;
  end;

  procedure SetClassName;
  var
    TPRBI: TParamRBookInterface;
  begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' class_id='+inttostr(class_id)+' ');
    if _ViewInterfaceFromName(NameRbkClass,@TPRBI) then begin
     ChangeFlag:=true;
     class_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'class_id');
     edClass.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'num');
    end;
  end;

var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='depart_id;seat_id;class_id';
  TPRBI.Locate.KeyValues:=VarArrayOf([depart_id,seat_id,class_id]);
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSeatClass,@TPRBI) then begin
   ChangeFlag:=true;
   minpay:=GetFirstValueFromParamRBookInterface(@TPRBI,'minpay');
   maxpay:=GetFirstValueFromParamRBookInterface(@TPRBI,'maxpay');
   staffcount:=GetFirstValueFromParamRBookInterface(@TPRBI,'staffcount');
   depart_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'depart_id');
   SetDepartName;
   seat_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'seat_id');
   SetSeatName;
   class_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'class_id');
   SetClassName;
   edPay.Text:=floattostr(minpay);
  end;
end;

function TfmEditRBEmpPlant.GetMaxStaffCount: Integer;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 Result:=0;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select count(*) as ct from '+tbEmpPlant+
         ' where depart_id='+inttostr(depart_id)+
         ' and seat_id='+inttostr(seat_id)+
         ' and class_id='+inttostr(class_id)+
         ' and releasedate is null';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('ct').AsInteger;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
