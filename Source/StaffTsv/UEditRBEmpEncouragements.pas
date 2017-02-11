unit UEditRBEmpEncouragements;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpEncouragements = class(TfmEditRB)
    lbDocum: TLabel;
    edDocum: TEdit;
    bibDocum: TBitBtn;
    lbDateStart: TLabel;
    dtpDateStart: TDateTimePicker;
    lbtypeencouragements: TLabel;
    edtypeencouragements: TEdit;
    bibtypeencouragements: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibDocumClick(Sender: TObject);
    procedure edDocumChange(Sender: TObject);
    procedure bibtypeencouragementsClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    docum_id: Integer;
    typeencouragements_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpEncouragements: TfmEditRBEmpEncouragements;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpEncouragements.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpEncouragements.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpEncouragements,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpEncouragements+
          ' (empencouragements_id,docum_id,typeencouragements_id,emp_id,'+
          'datestart) values '+
          ' ('+
          id+','+
          inttostr(docum_id)+','+
          inttostr(typeencouragements_id)+','+
          inttostr(emp_id)+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpEncouragements(false);
    ParentEmpForm.qrEmpEncouragements.Locate('empencouragements_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpEncouragements.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpEncouragements.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpEncouragements.FieldByName('empencouragements_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpEncouragements+
          ' set emp_id='+inttostr(emp_id)+
          ', docum_id='+inttostr(docum_id)+
          ', typeencouragements_id='+inttostr(typeencouragements_id)+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ' where empencouragements_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpEncouragements(false);
    ParentEmpForm.qrEmpEncouragements.Locate('empencouragements_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpEncouragements.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpEncouragements.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edDocum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbDocum.Caption]));
    bibDocum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edtypeencouragements.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbtypeencouragements.Caption]));
    bibtypeencouragements.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpEncouragements.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpEncouragements.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edDocum.MaxLength:=DomainSmallNameLength;
  edtypeencouragements.MaxLength:=DomainNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;

end;

procedure TfmEditRBEmpEncouragements.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpEncouragements.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpEncouragements.bibDocumClick(Sender: TObject);
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

procedure TfmEditRBEmpEncouragements.edDocumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpEncouragements.bibtypeencouragementsClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typeencouragements_id';
  TPRBI.Locate.KeyValues:=typeencouragements_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeEncouragements,@TPRBI) then begin
   ChangeFlag:=true;
   typeencouragements_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typeencouragements_id');
   edtypeencouragements.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
