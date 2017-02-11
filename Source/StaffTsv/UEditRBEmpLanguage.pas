unit UEditRBEmpLanguage;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB
  , URBEmp;

type
  TfmEditRBEmpLanguage = class(TfmEditRB)
    lbLanguage: TLabel;
    edLanguage: TEdit;
    bibLanguage: TBitBtn;
    lbKnowLevel: TLabel;
    edKnowLevel: TEdit;
    bibKnowLevel: TBitBtn;
    procedure edConnectionStringChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibLanguageClick(Sender: TObject);
    procedure edLanguageChange(Sender: TObject);
    procedure bibKnowLevelClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    language_id: Integer;
    oldlanguage_id: Integer;
    knowlevel_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpLanguage: TfmEditRBEmpLanguage;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpLanguage.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLanguage.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpLanguage+
          ' (language_id,emp_id,knowlevel_id) values '+
          ' ('+
          inttostr(language_id)+','+
          inttostr(emp_id)+','+
          inttostr(knowlevel_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpLanguage(false);
    ParentEmpForm.qrEmplanguage.Locate('language_id;emp_id',
                                VarArrayOf([language_id,emp_id]),
                                [LocaseInsensitive]);
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

procedure TfmEditRBEmpLanguage.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLanguage.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpLanguage+
          ' set language_id='+inttostr(language_id)+
          ', knowlevel_id='+inttostr(knowlevel_id)+
          ' where emp_id='+inttostr(emp_id)+
          ' and language_id='+inttostr(oldlanguage_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpLanguage(false);
    ParentEmpForm.qrEmplanguage.Locate('language_id;emp_id',
                                VarArrayOf([language_id,emp_id]),
                                [LocaseInsensitive]);
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

procedure TfmEditRBEmpLanguage.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpLanguage.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edLanguage.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbLanguage.Caption]));
    bibLanguage.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edKnowLevel.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbKnowLevel.Caption]));
    bibKnowLevel.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpLanguage.edConnectionStringChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLanguage.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBEmpLanguage.bibLanguageClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='language_id';
  TPRBI.Locate.KeyValues:=language_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkLanguage,@TPRBI) then begin
   ChangeFlag:=true;
   language_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'language_id');
   edLanguage.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpLanguage.edLanguageChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpLanguage.bibKnowLevelClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='knowlevel_id';
  TPRBI.Locate.KeyValues:=knowlevel_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkKnowlevel,@TPRBI) then begin
   ChangeFlag:=true;
   knowlevel_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'knowlevel_id');
   edKnowLevel.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
