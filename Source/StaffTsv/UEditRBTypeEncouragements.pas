unit UEditRBTypeEncouragements;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBTypeEncouragements = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldtypeencouragements_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTypeEncouragements: TfmEditRBTypeEncouragements;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBTypeEncouragements.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTypeEncouragements.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbTypeEncouragements,1));
    sqls:='Insert into '+tbTypeEncouragements+
          ' (typeencouragements_id,name) values '+
          ' ('+id+','+QuotedStr(Trim(edName.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldtypeencouragements_id:=strtoint(id);

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBTypeEncouragements.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTypeEncouragements.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldtypeencouragements_id);//fmRBTypeEncouragements.MainQr.FieldByName('typeencouragements_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTypeEncouragements+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ' where typeencouragements_id='+id;
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
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBTypeEncouragements.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBTypeEncouragements.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBTypeEncouragements.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBTypeEncouragements.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
end;

end.
