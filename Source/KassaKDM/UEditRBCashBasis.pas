unit UEditRBCashBasis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB;

type
  TfmEditRBCashBasis = class(TfmEditRB)
    Label1: TLabel;
    Edit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldcb_text: string;
    cb_id: Integer;
    cb_text: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBCashBasis: TfmEditRBCashBasis;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBCashBasis.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBCashBasis.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbCashBasis+
          ' (CB_ID,CB_TEXT) values '+
          ' (gen_id(gen_cashbasis_id,1),'+QuotedStr(Trim(Edit.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBCashBasis.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBCashBasis.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id2:=IntToStr(cb_id);//fmRBCashBasis.MainQr.FieldByname('username').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbCashBasis+
          ' set CB_TEXT='+QuotedStr(Trim(Edit.Text))+
          ' where CB_ID='+id2;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBCashBasis.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBCashBasis.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(Edit.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label1.Caption]));
    Edit.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBCashBasis.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCashBasis.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

end;

end.
