unit UEditRBEmpLeave;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpLeave = class(TfmEditRB)
    lbDocum: TLabel;
    edDocum: TEdit;
    bibDocum: TBitBtn;
    lbDateStart: TLabel;
    lbForPeriod: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpForPeriod: TDateTimePicker;
    lbTypeLeave: TLabel;
    edTypeLeave: TEdit;
    bibTypeLeave: TBitBtn;
    lbForPeriodOn: TLabel;
    dtpForPeriodOn: TDateTimePicker;
    lbMainAmountCalDay: TLabel;
    edMainAmountCalDay: TEdit;
    lbAddAmountCalDay: TLabel;
    edAddAmountCalDay: TEdit;
    lbAbsence: TLabel;
    edAbsence: TEdit;
    bibAbsence: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibDocumClick(Sender: TObject);
    procedure edDocumChange(Sender: TObject);
    procedure bibTypeLeaveClick(Sender: TObject);
    procedure edMainAmountCalDayKeyPress(Sender: TObject; var Key: Char);
    procedure bibAbsenceClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    docum_id: Integer;
    typeleave_id: Integer;
    absence_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpLeave: TfmEditRBEmpLeave;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpLeave.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLeave.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpLeave,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpLeave+
          ' (empleave_id,docum_id,typeleave_id,emp_id,forperiod,forperiodon,'+
          'datestart,mainamountcalday,addamountcalday,absence_id) values '+
          ' ('+
          id+','+
          inttostr(docum_id)+','+
          inttostr(typeleave_id)+','+
          inttostr(emp_id)+','+
          QuotedStr(DateToStr(dtpForPeriod.Date))+','+
          QuotedStr(DateToStr(dtpForPeriodOn.Date))+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+','+
          Trim(edMainAmountCalDay.Text)+','+
          Trim(edAddAmountCalDay.Text)+','+
          inttostr(absence_id)+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpLeave(false);
    ParentEmpForm.qrEmpLeave.Locate('empleave_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpLeave.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLeave.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpLeave.FieldByName('empleave_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpLeave+
          ' set emp_id='+inttostr(emp_id)+
          ', docum_id='+inttostr(docum_id)+
          ', typeleave_id='+inttostr(typeleave_id)+
          ', forperiod='+QuotedStr(DateToStr(dtpForPeriod.Date))+
          ', forperiodon='+QuotedStr(DateToStr(dtpForPeriodOn.Date))+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ', mainamountcalday='+Trim(edMainAmountCalDay.Text)+
          ', addamountcalday='+Trim(edAddAmountCalDay.Text)+
          ', absence_id='+inttostr(absence_id)+
          ' where empLeave_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpLeave(false);
    ParentEmpForm.qrEmpLeave.Locate('empleave_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpLeave.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLeave.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbDocum.Caption]));
    bibDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTypeLeave.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeLeave.Caption]));
    bibTypeLeave.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAbsence.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAbsence.Caption]));
    bibAbsence.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edMainAmountCalDay.Text)<>'' then begin
    if not isInteger(edMainAmountCalDay.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbMainAmountCalDay.Caption]));
     edMainAmountCalDay.SetFocus;
     Result:=false;
     exit;
    end;
  end;
  if trim(edAddAmountCalDay.Text)<>'' then begin
    if not isInteger(edAddAmountCalDay.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbAddAmountCalDay.Caption]));
     edAddAmountCalDay.SetFocus;
     Result:=false;
     exit;
    end;
  end;
  if trim(edMainAmountCalDay.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbMainAmountCalDay.Caption]));
    edMainAmountCalDay.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAddAmountCalDay.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAddAmountCalDay.Caption]));
    edAddAmountCalDay.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpLeave.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLeave.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edDocum.MaxLength:=DomainSmallNameLength;
  edTypeLeave.MaxLength:=DomainNameLength;
  edAbsence.MaxLength:=DomainNameLength;

  curDate:=_GetDateTimeFromServer;

  dtpForPeriod.Date:=curDate;
  dtpForPeriodOn.Date:=curDate;
  dtpDateStart.Date:=curDate;

  edMainAmountCalDay.MaxLength:=3;
  edAddAmountCalDay.MaxLength:=3;
end;

procedure TfmEditRBEmpLeave.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLeave.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLeave.bibDocumClick(Sender: TObject);
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

procedure TfmEditRBEmpLeave.edDocumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLeave.bibTypeLeaveClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typeleave_id';
  TPRBI.Locate.KeyValues:=typeleave_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeLeave,@TPRBI) then begin
   ChangeFlag:=true;
   typeleave_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typeleave_id');
   edTypeLeave.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpLeave.edMainAmountCalDayKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpLeave.bibAbsenceClick(Sender: TObject);
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
