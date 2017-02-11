unit UEditRBEmpBiography;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpBiography = class(TfmEditRB)
    lbDateStart: TLabel;
    dtpDateStart: TDateTimePicker;
    lbDateFinish: TLabel;
    dtpDateFinish: TDateTimePicker;
    lbNote: TLabel;
    meNote: TMemo;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure edProfessionChange(Sender: TObject);
    procedure meNoteChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    profession_id: Integer;
    typestud_id: Integer;
    educ_id: Integer;
    craft_id: Integer;
    school_id: Integer;
    olddiplom_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpBiography: TfmEditRBEmpBiography;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpBiography.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpBiography.AddToRBooks: Boolean;
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

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbBiography,1));
    sqls:='Insert into '+tbBiography+
          ' (emp_id,biography_id,datestart,datefinish,note) values '+
          ' ('+
          inttostr(emp_id)+','+
          id+','+
          QuotedStr(DateTimeToStr(dtpDateStart.Date))+','+
          QuotedStr(DateTimeToStr(dtpDateFinish.Date))+','+
          QuotedStr(Trim(meNote.Lines.Text))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpBiography(false);
    ParentEmpForm.qrEmpBiography.Locate('biography_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpBiography.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpBiography.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpBiography.fieldbyname('biography_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbBiography+
          ' set emp_id='+inttostr(emp_id)+
          ', note='+QuotedStr(Trim(meNote.Lines.Text))+
          ', datestart='+QuotedStr(DateTimeToStr(dtpDateStart.Date))+
          ', datefinish='+QuotedStr(DateTimeToStr(dtpDateFinish.Date))+
          ' where biography_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpBiography(false);
    ParentEmpForm.qrEmpBiography.Locate('biography_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpBiography.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpBiography.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(meNote.Lines.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    meNote.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpBiography.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpBiography.FormCreate(Sender: TObject);
var
  curdate: TDate; 
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  meNote.MaxLength:=DomainNoteLength;

  curdate:=_GetDateTimeFromServer;
  dtpDateStart.date:=curdate;
  dtpDateFinish.date:=curdate;

end;

procedure TfmEditRBEmpBiography.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpBiography.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpBiography.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
 if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpBiography.edProfessionChange(Sender: TObject);
begin
   ChangeFlag:=true;
end;

procedure TfmEditRBEmpBiography.meNoteChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
