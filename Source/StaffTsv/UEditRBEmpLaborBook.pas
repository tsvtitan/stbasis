unit UEditRBEmpLaborBook;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpLaborBook = class(TfmEditRB)
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
    lbMotive: TLabel;
    edMotive: TEdit;
    bibMotive: TBitBtn;
    pngrb: TPanel;
    meHint: TMemo;
    chbMainProf: TCheckBox;
    grb: TGroupBox;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibProfClick(Sender: TObject);
    procedure edProfChange(Sender: TObject);
    procedure bibPlantClick(Sender: TObject);
    procedure bibMotiveClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Variant;
    prof_id: Variant;
    plant_id: Variant;
    motive_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpLaborBook: TfmEditRBEmpLaborBook;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpLaborBook.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLaborBook.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpLaborBook,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpLaborBook+
          ' (emplaborbook_id,emp_id,prof_id,plant_id,motive_id,'+
          'datestart,datefinish,hint,mainprof) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          inttostr(prof_id)+','+
          inttostr(plant_id)+','+
          inttostr(motive_id)+','+
          QuotedStr(DateToStr(dtpDateStart.Date))+','+
          GetStrFromCondition(dtpDateFinish.Checked,
                              QuotedStr(DateTimeToStr(dtpDateFinish.Date)),
                              'null')+','+
          GetStrFromCondition(Trim(meHint.Text)<>'',
                              QuotedStr(Trim(meHint.Text)),
                              'null')+','+
          GetStrFromCondition(chbMainProf.checked,'1','0')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpLaborBook(false);
    ParentEmpForm.qrEmpLaborBook.Locate('emplaborbook_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpLaborBook.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLaborBook.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpLaborBook.FieldByName('emplaborbook_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpLaborBook+
          ' set emp_id='+inttostr(emp_id)+
          ', prof_id='+inttostr(prof_id)+
          ', plant_id='+inttostr(plant_id)+
          ', motive_id='+inttostr(motive_id)+
          ', datestart='+QuotedStr(DateToStr(dtpDateStart.Date))+
          ', datefinish='+GetStrFromCondition(dtpDateFinish.Checked,
                              QuotedStr(DateTimeToStr(dtpDateFinish.Date)),
                              'null')+
          ', hint='+GetStrFromCondition(Trim(meHint.Text)<>'',
                                        QuotedStr(Trim(meHint.Text)),
                                        'null')+
          ', mainprof='+GetStrFromCondition(chbMainProf.checked,'1','0')+
          ' where emplaborbook_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpLaborBook(false);
    ParentEmpForm.qrEmpLaborBook.Locate('emplaborbook_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpLaborBook.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLaborBook.CheckFieldsFill: Boolean;
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
  if trim(edMotive.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbMotive.Caption]));
    bibMotive.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpLaborBook.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLaborBook.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edProf.MaxLength:=DomainNameLength;
  edPlant.MaxLength:=DomainSmallNameLength;
  edMotive.MaxLength:=DomainSmallNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateStart.Date:=curDate;
  dtpDateFinish.Date:=curDate;
  dtpDateFinish.Checked:=false;

  meHint.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBEmpLaborBook.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLaborBook.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLaborBook.bibProfClick(Sender: TObject);
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

procedure TfmEditRBEmpLaborBook.edProfChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpLaborBook.bibPlantClick(Sender: TObject);
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

procedure TfmEditRBEmpLaborBook.bibMotiveClick(Sender: TObject);
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

end.
