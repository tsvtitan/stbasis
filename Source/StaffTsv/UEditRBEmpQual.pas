unit UEditRBEmpQual;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpQual = class(TfmEditRB)
    lbDocum: TLabel;
    edDocum: TEdit;
    bibDocum: TBitBtn;
    lbDateStart: TLabel;
    dtpDateStart: TDateTimePicker;
    lbTypeResQual: TLabel;
    edTypeResQual: TEdit;
    bibTypeResQual: TBitBtn;
    lbResDocum: TLabel;
    edresdocum: TEdit;
    bibResDocum: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibDocumClick(Sender: TObject);
    procedure edDocumChange(Sender: TObject);
    procedure bibTypeResQualClick(Sender: TObject);
    procedure bibResDocumClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    docum_id: Integer;
    resdocum_id: Integer;
    typeresqual_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpQual: TfmEditRBEmpQual;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpQual.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpQual.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpQual,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpQual+
          ' (empqual_id,docum_id,resdocum_id,typeresqual_id,emp_id,'+
          'datestart) values '+
          ' ('+
          id+','+
          inttostr(docum_id)+','+
          inttostr(resdocum_id)+','+
          inttostr(typeresqual_id)+','+
          inttostr(emp_id)+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpQual(false);
    ParentEmpForm.qrEmpQual.Locate('empqual_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpQual.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpQual.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpQual.FieldByName('empqual_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpQual+
          ' set emp_id='+inttostr(emp_id)+
          ', docum_id='+inttostr(docum_id)+
          ', resdocum_id='+inttostr(resdocum_id)+
          ', typeresqual_id='+inttostr(typeresqual_id)+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ' where empQual_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpQual(false);
    ParentEmpForm.qrEmpQual.Locate('empqual_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpQual.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpQual.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbDocum.Caption]));
    bibDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edResDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbResDocum.Caption]));
    bibResDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTyperesQual.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTyperesQual.Caption]));
    bibTyperesQual.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpQual.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpQual.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edDocum.MaxLength:=DomainSmallNameLength;
  edResDocum.MaxLength:=DomainSmallNameLength;
  edTypeResQual.MaxLength:=DomainNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;

end;

procedure TfmEditRBEmpQual.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpQual.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpQual.bibDocumClick(Sender: TObject);
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

procedure TfmEditRBEmpQual.edDocumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpQual.bibTypeResQualClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typeresqual_id';
  TPRBI.Locate.KeyValues:=typeresqual_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeResQual,@TPRBI) then begin
   ChangeFlag:=true;
   typeresqual_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typeresqual_id');
   edTypeResQual.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpQual.bibResDocumClick(Sender: TObject);
var
  TPJI: TParamJournalInterface;
begin
  FillChar(TPJI,SizeOf(TPJI),0);
  TPJI.Visual.TypeView:=tvibvModal;
  TPJI.Locate.KeyFields:='docum_id';
  TPJI.Locate.KeyValues:=resdocum_id;
  TPJI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameJrDocum,@TPJI) then begin
   ChangeFlag:=true;
   resdocum_id:=GetFirstValueFromParamJournalInterface(@TPJI,'docum_id');
   edresDocum.Text:=GetFirstValueFromParamJournalInterface(@TPJI,'num');
  end;
end;

end.
