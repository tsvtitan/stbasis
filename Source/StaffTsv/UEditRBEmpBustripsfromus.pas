unit UEditRBEmpBustripsfromus;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpBustripsfromus = class(TfmEditRB)
    lbEmpProj: TLabel;
    edEmpProj: TEdit;
    bibEmpProj: TBitBtn;
    lbDateStart: TLabel;
    lbDateFinish: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpDateFinish: TDateTimePicker;
    lbEmpDirect: TLabel;
    edEmpDirect: TEdit;
    bibEmpDirect: TBitBtn;
    lbDocum: TLabel;
    edDocum: TEdit;
    bibDocum: TBitBtn;
    chbOk: TCheckBox;
    lbNum: TLabel;
    edNum: TEdit;
    lbAbsence: TLabel;
    edAbsence: TEdit;
    bibAbsence: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibEmpProjClick(Sender: TObject);
    procedure edEmpProjChange(Sender: TObject);
    procedure bibEmpDirectClick(Sender: TObject);
    procedure bibDocumClick(Sender: TObject);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
    procedure bibAbsenceClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    empproj_id: Integer;
    empdirect_id: Integer;
    docum_id: Integer;
    Absence_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpBustripsfromus: TfmEditRBEmpBustripsfromus;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpBustripsfromus.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpBustripsfromus.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpBustripsfromus,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpBustripsfromus+
          ' (empbustripsfromus_id,emp_id,empproj_id,empdirect_id,docum_id,'+
          'num,datestart,datefinish,ok,absence_id) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          inttostr(empproj_id)+','+
          inttostr(empdirect_id)+','+
          inttostr(docum_id)+','+
          QuotedStr(Trim(edNum.Text))+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+','+
          QuotedStr(DateToStr(dtpDateFinish.Date))+','+
          GetStrFromCondition(chbOk.checked,'1','0')+','+
          inttostr(absence_id)+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpBustripsfromus(false);
    ParentEmpForm.qrEmpBustripsfromus.Locate('empbustripsfromus_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpBustripsfromus.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpBustripsfromus.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpBustripsfromus.FieldByName('empbustripsfromus_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpBustripsfromus+
          ' set emp_id='+inttostr(emp_id)+
          ', empproj_id='+inttostr(empproj_id)+
          ', empdirect_id='+inttostr(empdirect_id)+
          ', docum_id='+inttostr(docum_id)+
          ', num='+QuotedStr(Trim(edNum.Text))+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ', datefinish='+QuotedStr(DateToStr(dtpDateFinish.Date))+
          ', ok='+GetStrFromCondition(chbOk.checked,'1','0')+
          ', absence_id='+inttostr(absence_id)+
          ' where empbustripsfromus_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpBustripsfromus(false);
    ParentEmpForm.qrEmpBustripsfromus.Locate('empbustripsfromus_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpBustripsfromus.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpBustripsfromus.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edEmpProj.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbEmpProj.Caption]));
    bibEmpProj.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edEmpDirect.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbEmpDirect.Caption]));
    bibEmpDirect.SetFocus;
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
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
(*  if trim(edNum.Text)<>'' then begin
   if not isInteger(edNum.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbNum.Caption]));
     edNum.SetFocus;
     Result:=false;
     exit;
   end;
  end;*)

end;

procedure TfmEditRBEmpBustripsfromus.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpBustripsfromus.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edEmpProj.MaxLength:=DomainSmallNameLength;
  edEmpDirect.MaxLength:=DomainSmallNameLength;
  edDocum.MaxLength:=DomainSmallNameLength;
  edNum.MaxLength:=DomainSmallNameLength;
  edAbsence.MaxLength:=DomainNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;
  dtpDateFinish.Date:=curDate;

end;

procedure TfmEditRBEmpBustripsfromus.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpBustripsfromus.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpBustripsfromus.bibEmpProjClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='emp_id';
  TPRBI.Locate.KeyValues:=empproj_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
   ChangeFlag:=true;
   empproj_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
   edEmpProj.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname');
  end;
end;

procedure TfmEditRBEmpBustripsfromus.edEmpProjChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpBustripsfromus.bibEmpDirectClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='emp_id';
  TPRBI.Locate.KeyValues:=empdirect_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
   ChangeFlag:=true;
   empdirect_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'emp_id');
   edEmpDirect.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname');
  end;
end;

procedure TfmEditRBEmpBustripsfromus.bibDocumClick(Sender: TObject);
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

procedure TfmEditRBEmpBustripsfromus.edNumKeyPress(Sender: TObject;
  var Key: Char);
begin
//  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpBustripsfromus.bibAbsenceClick(Sender: TObject);
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
