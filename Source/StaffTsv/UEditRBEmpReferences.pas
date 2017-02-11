unit UEditRBEmpReferences;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpReferences = class(TfmEditRB)
    lbTypeReferences: TLabel;
    edTypeReferences: TEdit;
    bibTypeReferences: TBitBtn;
    lbDateStart: TLabel;
    lbDateFinish: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpDateFinish: TDateTimePicker;
    chbOk: TCheckBox;
    bibPeriod: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibTypeReferencesClick(Sender: TObject);
    procedure edTypeReferencesChange(Sender: TObject);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
    procedure bibPeriodClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    typereferences_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpReferences: TfmEditRBEmpReferences;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

var
  TypePeriod: TTypeEnterPeriod;
{$R *.DFM}

procedure TfmEditRBEmpReferences.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpReferences.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpReferences,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpReferences+
          ' (empreferences_id,emp_id,typereferences_id,'+
          'datestart,datefinish,ok) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          inttostr(typereferences_id)+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+','+
          QuotedStr(DateToStr(dtpDateFinish.Date))+','+
          GetStrFromCondition(chbOk.checked,'1','0')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpReferences(false);
    ParentEmpForm.qrempreferences.Locate('empreferences_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpReferences.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpReferences.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrempreferences.FieldByName('empreferences_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpReferences+
          ' set emp_id='+inttostr(emp_id)+
          ', typereferences_id='+inttostr(typereferences_id)+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ', datefinish='+QuotedStr(DateToStr(dtpDateFinish.Date))+
          ', ok='+GetStrFromCondition(chbOk.checked,'1','0')+
          ' where empreferences_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpReferences(false);
    ParentEmpForm.qrempreferences.Locate('empreferences_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpReferences.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpReferences.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edTypeReferences.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeReferences.Caption]));
    bibTypeReferences.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpReferences.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpReferences.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edTypeReferences.MaxLength:=DomainSmallNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;
  dtpDateFinish.Date:=curDate;

  TypePeriod:=tepYear;

end;

procedure TfmEditRBEmpReferences.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpReferences.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpReferences.bibTypeReferencesClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typereferences_id';
  TPRBI.Locate.KeyValues:=typereferences_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeReferences,@TPRBI) then begin
   ChangeFlag:=true;
   typereferences_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typereferences_id');
   edTypeReferences.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpReferences.edTypeReferencesChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpReferences.edNumKeyPress(Sender: TObject;
  var Key: Char);
begin
//  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpReferences.bibPeriodClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
 try
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=TypePeriod;
   P.LoadAndSave:=false;
   P.DateBegin:=dtpDateStart.DateTime;
   P.DateEnd:=dtpDateFinish.DateTime;
   if _ViewEnterPeriod(P) then begin
     dtpDateStart.DateTime:=P.DateBegin;
     dtpDateFinish.DateTime:=P.DateEnd;
     TypePeriod:=P.TypePeriod;
     ChangeFlag:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
