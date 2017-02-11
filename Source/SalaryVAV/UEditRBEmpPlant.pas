unit UEditRBEmpPlant;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB;

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
    lbClass: TLabel;
    edClass: TEdit;
    bibClass: TBitBtn;
    lbReasonDocum: TLabel;
    edReasonDocum: TEdit;
    bibReasonDocum: TBitBtn;
    edCategory: TEdit;
    bibCategory: TBitBtn;
    lbSeat: TLabel;
    edSeat: TEdit;
    bibSeat: TBitBtn;
    lbDepart: TLabel;
    edDepart: TEdit;
    bibDepart: TBitBtn;
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
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    emp_id: Integer;
    net_id: Integer;
    class_id: Integer;
    plant_id: Integer;
    reasondocum_id: Integer;
    category_id: Integer;
    seat_id: Integer;
    depart_id: Integer;
    orderdocum_id: Integer;
    motive_id: Integer;
    prof_id: Integer;
    schedule_id: Integer;
    motivedocum_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpPlant: TfmEditRBEmpPlant;

implementation

uses USalaryVAVCode, USalaryVAVData, UMainUnited, UOTSalary, StCalendarUtil;

{$R *.DFM}

procedure TfmEditRBEmpPlant.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPlant.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id,id1: string;
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
    qr.Transaction.Commit;

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
    qr.Transaction.Commit;

    fmOTSalary.ActiveEmpPlant(false);
    fmOTSalary.qrEmpPlant.Locate('empplant_id',id,[LocaseInsensitive]);
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

    id:=fmOTSalary.qrEmpPlant.FieldByName('empplant_id').AsString;
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
    qr.Transaction.Commit;

    fmOTSalary.ActiveEmpPlant(false);
    fmOTSalary.qrEmpPlant.Locate('empplant_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpPlant.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPlant.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edPlant.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPlant.Caption]));
    bibPlant.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(ednet.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNet.Caption]));
    bibnet.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edClass.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbClass.Caption]));
    bibClass.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edReasonDocum.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbReasonDocum.Caption]));
    bibReasonDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCategory.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbCategory.Caption]));
    bibCategory.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSeat.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbSeat.Caption]));
    bibSeat.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edDepart.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbDepart.Caption]));
    bibDepart.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edOrderDocum.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbOrderDocum.Caption]));
    bibOrderDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edProf.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbprof.Caption]));
    bibprof.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edschedule.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbschedule.Caption]));
    bibschedule.SetFocus;
    Result:=false;
    exit;
  end;
  if dtpReleaseDate.Checked then begin
   if trim(edMotive.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbMotive.Caption]));
    bibMotive.SetFocus;
    Result:=false;
    exit;
   end;
   if trim(edMotiveDocum.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbMotiveDocum.Caption]));
    bibMotiveDocum.SetFocus;
    Result:=false;
    exit;
   end;
  end else begin
   if trim(edMotive.Text)<>'' then begin
    ShowError(Handle,Format(ConstFieldEmpty,[lbMotive.Caption]));
    bibMotive.SetFocus;
    Result:=false;
    exit;
   end;
   if trim(edMotiveDocum.Text)<>'' then begin
    ShowError(Handle,Format(ConstFieldEmpty,[lbMotiveDocum.Caption]));
    bibMotiveDocum.SetFocus;
    Result:=false;
    exit;
   end;
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
  P: PPlantParams;
begin
 try
  getMem(P,sizeof(TPlantParams));
  try
   ZeroMemory(P,sizeof(TPlantParams));
   P.plant_id:=plant_id;
   if ViewEntry_(tte_rbksplant,p,true) then begin
     ChangeFlag:=true;
     plant_id:=P.plant_id;
     edPlant.Text:=P.smallname;
   end;
  finally
    FreeMem(P,sizeof(TPlantParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmpPlant.bibNetClick(Sender: TObject);
var
  P: PNetParams;
begin
 try
  getMem(P,sizeof(TNetParams));
  try
   ZeroMemory(P,sizeof(TNetParams));
   P.net_id:=net_id;
   if _ViewEntryFromMain(tte_rbksnet,p,true) then begin
     ChangeFlag:=true;
     net_id:=P.net_id;
     edNet.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TNetParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmpPlant.bibClassClick(Sender: TObject);
var
  P: PClassParams;
begin
 try
  getMem(P,sizeof(TClassParams));
  try
   ZeroMemory(P,sizeof(TClassParams));
   P.class_id:=class_id;
   if _ViewEntryFromMain(tte_rbksclass,p,true) then begin
     ChangeFlag:=true;
     class_id:=P.class_id;
     edClass.Text:=P.num;
   end;
  finally
    FreeMem(P,sizeof(TClassParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBEmpPlant.bibReasonDocumClick(Sender: TObject);
var
  P: PDocumParams;
begin
 try
  getMem(P,sizeof(TDocumParams));
  try
   ZeroMemory(P,sizeof(TDocumParams));
   P.docum_id:=reasondocum_id;
   if _ViewEntryFromMain(tte_rbksdocum,p,true) then begin
     ChangeFlag:=true;
     reasondocum_id:=P.docum_id;
     edReasonDocum.Text:=P.num;
   end;
  finally
    FreeMem(P,sizeof(TDocumParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.edPlantChange(Sender: TObject);
begin
   ChangeFlag:=true;
end;

procedure TfmEditRBEmpPlant.bibCategoryClick(Sender: TObject);
var
  P: PCategoryParams;
begin
 try
  getMem(P,sizeof(TCategoryParams));
  try
   ZeroMemory(P,sizeof(TCategoryParams));
   P.category_id:=category_id;
   if _ViewEntryFromMain(tte_rbkscategory,p,true) then begin
     ChangeFlag:=true;
     category_id:=P.category_id;
     edCategory.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TCategoryParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibSeatClick(Sender: TObject);
var
  P: PSeatParams;
begin
 try
  getMem(P,sizeof(TSeatParams));
  try
   ZeroMemory(P,sizeof(TSeatParams));
   P.id:=seat_id;
   if _ViewEntryFromMain(tte_rbksseat,p,true) then begin
     ChangeFlag:=true;
     seat_id:=P.id;
     edSeat.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TSeatParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibDepartClick(Sender: TObject);
var
  P: PDepartParams;
begin
 try
  getMem(P,sizeof(TDepartParams));
  try
   ZeroMemory(P,sizeof(TDepartParams));
   P.depart_id:=depart_id;
   if _ViewEntryFromMain(tte_rbksdepart,p,true) then begin
     ChangeFlag:=true;
     depart_id:=P.depart_id;
     edDepart.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TDepartParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibOrderDocumClick(Sender: TObject);
var
  P: PDocumParams;
begin
 try
  getMem(P,sizeof(TDocumParams));
  try
   ZeroMemory(P,sizeof(TDocumParams));
   P.docum_id:=orderdocum_id;
   if _ViewEntryFromMain(tte_rbksdocum,p,true) then begin
     ChangeFlag:=true;
     orderdocum_id:=P.docum_id;
     edOrderDocum.Text:=P.num;
   end;
  finally
    FreeMem(P,sizeof(TDocumParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibMotiveClick(Sender: TObject);
var
  P: PMotiveParams;
begin
 try
  getMem(P,sizeof(TMotiveParams));
  try
   ZeroMemory(P,sizeof(TMotiveParams));
   P.id:=motive_id;
   if _ViewEntryFromMain(tte_rbksmotive,p,true) then begin
     ChangeFlag:=true;
     motive_id:=P.id;
     edMotive.Text:=P.Name;
   end;
  finally
    FreeMem(P,sizeof(TMotiveParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibProfClick(Sender: TObject);
var
  P: PProfParams;
begin
 try
  getMem(P,sizeof(TProfParams));
  try
   ZeroMemory(P,sizeof(TProfParams));
   P.id:=prof_id;
   if _ViewEntryFromMain(tte_rbksprof,p,true) then begin
     ChangeFlag:=true;
     prof_id:=P.id;
     edProf.Text:=P.name;
   end;
  finally
    FreeMem(P,sizeof(TProfParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibscheduleClick(Sender: TObject);
var
  P: PScheduleParams;
begin
 try
  getMem(P,sizeof(TScheduleParams));
//  InitCalendarUtil(IBDB);
  try
   ZeroMemory(P,sizeof(TScheduleParams));
   P.Schedule_ID:=schedule_id;
   P.Calendar_ID:=GetCurrentCalendarID;
   if _ViewEntryFromMain(tte_rbksSchedule,p,true) then begin
     ChangeFlag:=true;
     schedule_id:=P.Schedule_ID;
     edschedule.Text:=P.Name;
   end;
  finally
    DoneCalendarUtil;
    FreeMem(P,sizeof(TScheduleParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpPlant.bibMotiveDocumClick(Sender: TObject);
var
  P: PDocumParams;
begin
 try
  getMem(P,sizeof(TDocumParams));
  try
   ZeroMemory(P,sizeof(TDocumParams));
   P.docum_id:=motivedocum_id;
   if _ViewEntryFromMain(tte_rbksdocum,p,true) then begin
     ChangeFlag:=true;
     motivedocum_id:=P.docum_id;
     edMotiveDocum.Text:=P.num;
   end;
  finally
    FreeMem(P,sizeof(TDocumParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
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

end.
