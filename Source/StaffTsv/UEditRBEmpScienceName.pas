unit UEditRBEmpScienceName;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  URBEmp;

type
  TfmEditRBEmpScienceName = class(TfmEditRB)
    lbScienceName: TLabel;
    edScienceName: TEdit;
    bibScienceName: TBitBtn;
    lbSchool: TLabel;
    edSchool: TEdit;
    bibSchool: TBitBtn;
    procedure edConnectionStringChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibScienceNameClick(Sender: TObject);
    procedure edScienceNameChange(Sender: TObject);
    procedure bibSchoolClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    sciencename_id: Integer;
    oldsciencename_id: Integer;
    school_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpScienceName: TfmEditRBEmpScienceName;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpScienceName.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpScienceName.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbEmpSciencename+
          ' (school_id,sciencename_id,emp_id) values '+
          ' ('+
          inttostr(school_id)+','+
          inttostr(sciencename_id)+','+
          inttostr(emp_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpsciencename(false);
    ParentEmpForm.qrEmpsciencename.Locate('sciencename_id;emp_id',
                                VarArrayOf([sciencename_id,emp_id]),
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

procedure TfmEditRBEmpScienceName.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpScienceName.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbEmpSciencename+
          ' set sciencename_id='+inttostr(sciencename_id)+
          ', school_id='+inttostr(school_id)+
          ' where emp_id='+inttostr(emp_id)+
          ' and sciencename_id='+inttostr(oldsciencename_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpsciencename(false);
    ParentEmpForm.qrEmpsciencename.Locate('sciencename_id;emp_id',
                                VarArrayOf([sciencename_id,emp_id]),
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

procedure TfmEditRBEmpScienceName.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpScienceName.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edScienceName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbScienceName.Caption]));
    bibScienceName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSchool.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSchool.Caption]));
    bibSchool.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpScienceName.edConnectionStringChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpScienceName.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBEmpScienceName.bibScienceNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sciencename_id';
  TPRBI.Locate.KeyValues:=sciencename_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSciencename,@TPRBI) then begin
   ChangeFlag:=true;
   sciencename_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sciencename_id');
   edScienceName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpScienceName.edScienceNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpScienceName.bibSchoolClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='school_id';
  TPRBI.Locate.KeyValues:=school_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSchool,@TPRBI) then begin
   ChangeFlag:=true;
   school_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'school_id');
   edSchool.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'schoolname');
  end;
end;

end.
