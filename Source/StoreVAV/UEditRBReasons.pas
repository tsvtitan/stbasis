unit UEditRBReasons;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBReasons = class(TfmEditRB)
    lbReasons: TLabel;
    edReasons: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edReasonsChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldReasons_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBReasons: TfmEditRBReasons;

implementation

uses UStoreVAVCode, UStoreVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBReasons.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBReasons.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbReasons,1));
    sqls:='Insert into '+ tbReasons +
          ' (Reasons_id,NameReasons,About) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edReasons.text))+
          ','+QuotedStr(Trim(meAbout.text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldReasons_id:=strtoint(id);

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
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

procedure TfmEditRBReasons.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBReasons.UpdateRBooks: Boolean;
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

    id:=inttostr(oldReasons_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbReasons+
          ' set NameReasons='+QuotedStr(Trim(edReasons.text))+
          ', about='+QuotedStr(Trim(meAbout.text))+
          ' where Reasons_id='+id;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBReasons.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBReasons.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edReasons.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbReasons.Caption]));
    edReasons.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBReasons.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edReasons.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBReasons.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBReasons.edReasonsChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.



