unit UEditRBSick;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBSick = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbCipher: TLabel;
    edCipher: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldsick_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSick: TfmEditRBSick;

implementation

uses USickTsvCode, USickTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBSick.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBSick.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbSick,1));
    sqls:='Insert into '+tbSick+
          ' (sick_id,name,cipher) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edCipher.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldsick_id:=strtoint(id);

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

procedure TfmEditRBSick.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSick.UpdateRBooks: Boolean;
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

    id:=inttostr(oldsick_id);//fmRBSick.MainQr.FieldByName('sick_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSick+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ', cipher='+QuotedStr(Trim(edCipher.Text))+
          ' where sick_id='+id;
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

procedure TfmEditRBSick.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBSick.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCipher.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCipher.Caption]));
    edCipher.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBSick.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBSick.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edCipher.MaxLength:=DomainSmallNameLength;
end;

end.
