unit UEditRBEmpProperty;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  URBEmp;

type
  TfmEditRBEmpProperty = class(TfmEditRB)
    lbProperty: TLabel;
    edProperty: TEdit;
    bibProperty: TBitBtn;
    procedure edConnectionStringChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibPropertyClick(Sender: TObject);
    procedure edPropertyChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    property_id: Integer;
    oldproperty_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpProperty: TfmEditRBEmpProperty;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpProperty.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpProperty.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbEmpProperty+
          ' (property_id,emp_id) values '+
          ' ('+
          inttostr(property_id)+','+
          inttostr(emp_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpProperty(false);
    ParentEmpForm.qrEmpProperty.Locate('property_id;emp_id',
                                VarArrayOf([property_id,emp_id]),
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

procedure TfmEditRBEmpProperty.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpProperty.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbEmpProperty+
          ' set property_id='+inttostr(property_id)+
          ' where emp_id='+inttostr(emp_id)+
          ' and property_id='+inttostr(oldproperty_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpProperty(false);
    ParentEmpForm.qrEmpProperty.Locate('property_id;emp_id',
                                VarArrayOf([property_id,emp_id]),
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

procedure TfmEditRBEmpProperty.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpProperty.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edproperty.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbproperty.Caption]));
    bibproperty.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpProperty.edConnectionStringChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpProperty.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBEmpProperty.bibPropertyClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='property_id';
  TPRBI.Locate.KeyValues:=property_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkProperty,@TPRBI) then begin
   ChangeFlag:=true;
   property_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'property_id');
   edProperty.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpProperty.edPropertyChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
