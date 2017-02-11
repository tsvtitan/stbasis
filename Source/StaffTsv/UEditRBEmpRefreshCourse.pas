unit UEditRBEmpRefreshCourse;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpRefreshCourse = class(TfmEditRB)
    lbProf: TLabel;
    edProf: TEdit;
    bibProf: TBitBtn;
    lbDateStart: TLabel;
    lbDateFinish: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpDateFinish: TDateTimePicker;
    lbPlant: TLabel;
    edPlant: TEdit;
    bibPlant: TBitBtn;
    lbDocum: TLabel;
    edDocum: TEdit;
    bibDocum: TBitBtn;
    lbAbsence: TLabel;
    edAbsence: TEdit;
    bibAbsence: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibProfClick(Sender: TObject);
    procedure edProfChange(Sender: TObject);
    procedure bibPlantClick(Sender: TObject);
    procedure bibDocumClick(Sender: TObject);
    procedure bibAbsenceClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Variant;
    prof_id: Variant;
    plant_id: Variant;
    docum_id: Variant;
    absence_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpRefreshCourse: TfmEditRBEmpRefreshCourse;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpRefreshCourse.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpRefreshCourse.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpRefreshCourse,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpRefreshCourse+
          ' (emprefreshcourse_id,emp_id,prof_id,plant_id,docum_id,'+
          'datestart,datefinish,absence_id) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          inttostr(prof_id)+','+
          inttostr(plant_id)+','+
          inttostr(docum_id)+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+','+
          QuotedStr(DateToStr(dtpDateFinish.Date))+','+
          inttostr(absence_id)+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpRefreshCourse(false);
    ParentEmpForm.qrEmpRefreshCourse.Locate('emprefreshcourse_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpRefreshCourse.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpRefreshCourse.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpRefreshCourse.FieldByName('emprefreshcourse_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpRefreshCourse+
          ' set emp_id='+inttostr(emp_id)+
          ', prof_id='+inttostr(prof_id)+
          ', plant_id='+inttostr(plant_id)+
          ', docum_id='+inttostr(docum_id)+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ', datefinish='+QuotedStr(DateToStr(dtpDateFinish.Date))+
          ', absence_id='+inttostr(absence_id)+
          ' where emprefreshcourse_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpRefreshCourse(false);
    ParentEmpForm.qrEmpRefreshCourse.Locate('emprefreshcourse_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpRefreshCourse.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpRefreshCourse.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edProf.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbProf.Caption]));
    bibProf.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPlant.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPlant.Caption]));
    bibPlant.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbDocum.Caption]));
    bibDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAbsence.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAbsence.Caption]));
    bibAbsence.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpRefreshCourse.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpRefreshCourse.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edProf.MaxLength:=DomainNameLength;
  edPlant.MaxLength:=DomainSmallNameLength;
  edDocum.MaxLength:=DomainSmallNameLength;
  edAbsence.MaxLength:=DomainNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;
  dtpDateFinish.Date:=curDate;

end;

procedure TfmEditRBEmpRefreshCourse.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpRefreshCourse.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpRefreshCourse.bibProfClick(Sender: TObject);
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

procedure TfmEditRBEmpRefreshCourse.edProfChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpRefreshCourse.bibPlantClick(Sender: TObject);
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

procedure TfmEditRBEmpRefreshCourse.bibDocumClick(Sender: TObject);
var
  TPJI: TParamJournalInterface;
begin
  FillChar(TPJI,SizeOf(TPJI),0);
  TPJI.Visual.TypeView:=tvibvModal;
  TPJI.Locate.KeyFields:='docum_id';
  TPJI.Locate.KeyValues:=docum_id;
  TPJI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameJrDocum,@TPJI) then begin
   ChangeFlag:=true;
   docum_id:=GetFirstValueFromParamJournalInterface(@TPJI,'docum_id');
   edDocum.Text:=GetFirstValueFromParamJournalInterface(@TPJI,'num');
  end;
end;

procedure TfmEditRBEmpRefreshCourse.bibAbsenceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Absence_id';
  TPRBI.Locate.KeyValues:=Absence_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAbsence,@TPRBI) then begin
   ChangeFlag:=true;
   Absence_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Absence_id');
   edAbsence.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
