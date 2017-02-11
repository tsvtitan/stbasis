unit UEditRBEmpSickList;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpSickList = class(TfmEditRB)
    lbNum: TLabel;
    edNum: TEdit;
    lbPercent: TLabel;
    edPercent: TEdit;
    lbSick: TLabel;
    edSick: TEdit;
    bibSick: TBitBtn;
    lbDateStart: TLabel;
    lbDateFinish: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpDateFinish: TDateTimePicker;
    lbAbsence: TLabel;
    edAbsence: TEdit;
    bibAbsence: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibSickClick(Sender: TObject);
    procedure edSickChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure edPercentKeyPress(Sender: TObject; var Key: Char);
    procedure bibAbsenceClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    sick_id: Integer;
    absence_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpSickList: TfmEditRBEmpSickList;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpSickList.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpSickList.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpSickList,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpSickList+
          ' (empsicklist_id,sick_id,emp_id,num,datestart,datefinish,percent,absence_id) values '+
          ' ('+
          id+','+
          inttostr(sick_id)+','+
          inttostr(emp_id)+','+
          QuotedStr(Trim(edNum.Text))+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+','+
          QuotedStr(DateToStr(dtpDateFinish.Date))+','+
          GetStrFromCondition(Trim(edPercent.Text)<>'',
                              QuotedStr(ChangeChar(Trim(edPercent.Text),',','.')),
                              'null')+','+
          inttostr(absence_id)+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpSickList(false);
    ParentEmpForm.qrEmpSickList.Locate('empsicklist_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpSickList.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpSickList.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpSickList.FieldByName('empsicklist_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpSickList+
          ' set sick_id='+inttostr(sick_id)+
          ', emp_id='+inttostr(emp_id)+
          ', num='+QuotedStr(Trim(edNum.Text))+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ', datefinish='+QuotedStr(DateToStr(dtpDateFinish.Date))+
          ', percent='+GetStrFromCondition(Trim(edPercent.Text)<>'',
                              QuotedStr(ChangeChar(Trim(edPercent.Text),',','.')),
                              'null')+
          ', absence_id='+inttostr(absence_id)+
          ' where empsicklist_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpSickList(false);
    ParentEmpForm.qrEmpSickList.Locate('empsicklist_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpSickList.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpSickList.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edSick.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSick.Caption]));
    bibSick.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAbsence.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAbsence.Caption]));
    bibAbsence.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPercent.Text)<>'' then begin
    if not isFloat(edPercent.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbPercent.Caption]));
     edPercent.SetFocus;
     Result:=false;
     exit;
    end;
  end;
  
end;

procedure TfmEditRBEmpSickList.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpSickList.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edSick.MaxLength:=DomainNameLength;
  edNum.MaxLength:=DomainSmallNameLength;
  edAbsence.MaxLength:=DomainNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;
  dtpDateFinish.Date:=curDate;
  edPercent.MaxLength:=DomainNameMoney;
end;

procedure TfmEditRBEmpSickList.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpSickList.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpSickList.bibSickClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sick_id';
  TPRBI.Locate.KeyValues:=sick_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSick,@TPRBI) then begin
   ChangeFlag:=true;
   sick_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sick_id');
   edSick.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpSickList.edSickChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpSickList.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpSickList.edPercentKeyPress(Sender: TObject;
  var Key: Char);
var
  APos: Integer;
begin
  ChangeFlag:=true;
  if (not (Key in ['0'..'9']))and
   (Key<>DecimalSeparator)and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;

procedure TfmEditRBEmpSickList.bibAbsenceClick(Sender: TObject);
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
