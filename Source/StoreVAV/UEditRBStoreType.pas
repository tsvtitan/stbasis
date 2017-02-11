unit UEditRBStoreType;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBStoreType = class(TfmEditRB)
    lbStoreType: TLabel;
    edstoreType: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edstoreTypeChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldStoreType_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBStoreType: TfmEditRBStoreType;

implementation

uses UStoreVAVCode, UStoreVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBStoreType.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBStoreType.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbStoreType,1));
    sqls:='Insert into '+ tbStoreType +
          ' (StoreType_id,NameStoreType,About) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edstoreType.text))+
          ','+QuotedStr(Trim(meAbout.text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldStoreType_id:=strtoint(id);

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

procedure TfmEditRBStoreType.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBStoreType.UpdateRBooks: Boolean;
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

    id:=inttostr(oldStoreType_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbStoreType+
          ' set NameStoreType='+QuotedStr(Trim(edstoreType.text))+
          ', about='+QuotedStr(Trim(meAbout.text))+
          ' where storetype_id='+id;

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

procedure TfmEditRBStoreType.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBStoreType.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edstoreType.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbStoreType.Caption]));
    edstoreType.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBStoreType.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edstoreType.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBStoreType.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBStoreType.edstoreTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.



