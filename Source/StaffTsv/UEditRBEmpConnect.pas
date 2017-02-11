unit UEditRBEmpConnect;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  URBEmp;

type
  TfmEditRBEmpConnect = class(TfmEditRB)
    lbConnectionString: TLabel;
    edConnectionString: TEdit;
    lbConnectionType: TLabel;
    edConnectionType: TEdit;
    bibConnectionType: TBitBtn;
    procedure edConnectionStringChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibConnectionTypeClick(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain; 
    emp_id: Integer;
    connectiontype_id: Integer;
    oldconnectiontype_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpConnect: TfmEditRBEmpConnect;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpConnect.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpConnect.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbEmpConnect,1));
    sqls:='Insert into '+tbEmpConnect+
          ' (empconnect_id,connectiontype_id,emp_id,connectstring) values '+
          ' ('+
          id+','+
          inttostr(connectiontype_id)+','+
          inttostr(emp_id)+','+
          QuotedStr(Trim(edConnectionString.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpConnect(false);
    ParentEmpForm.qrEmpConnect.Locate('empconnect_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpConnect.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpConnect.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpConnect.FieldByName('empconnect_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpConnect+
          ' set connectiontype_id='+inttostr(connectiontype_id)+
          ', connectstring='+QuotedStr(Trim(edConnectionString.Text))+
          ' where emp_id='+inttostr(emp_id)+
          ' and empconnect_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpConnect(false);
    ParentEmpForm.qrEmpConnect.Locate('empconnect_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpConnect.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpConnect.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edConnectionType.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbConnectionType.Caption]));
    bibConnectionType.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edConnectionString.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbConnectionString.Caption]));
    edConnectionString.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpConnect.edConnectionStringChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpConnect.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBEmpConnect.bibConnectionTypeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='connectiontype_id';
  TPRBI.Locate.KeyValues:=connectiontype_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkConnectiontype,@TPRBI) then begin
   ChangeFlag:=true;
   connectiontype_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'connectiontype_id');
   edConnectionType.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpConnect.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
