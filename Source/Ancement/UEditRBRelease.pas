unit UEditRBRelease;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBRelease = class(TfmEditRB)
    lbNumRelease: TLabel;
    lbDate: TLabel;
    dtpDate: TDateTimePicker;
    edNumRelease: TEdit;
    lbAbout: TLabel;
    edAbout: TEdit;
    lbToDate: TLabel;
    dtpToDate: TDateTimePicker;
    bibTodate: TButton;
    lbPublishing: TLabel;
    edPublishing: TEdit;
    bibPublishing: TButton;
    procedure edFactorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNumReleaseKeyPress(Sender: TObject; var Key: Char);
    procedure edNumReleaseChange(Sender: TObject);
    procedure bibTodateClick(Sender: TObject);
    procedure bibPublishingClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldrelease_id: Integer;
    release_id: Integer;
    publishing_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBRelease: TfmEditRBRelease;

implementation

uses UAncementCode, UAncementData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBRelease.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBRelease.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbRelease,1));
    sqls:='Insert into '+tbRelease+
          ' (release_id,numrelease,daterelease,publishing_id,about) values '+
          ' ('+id+
          ','+Trim(edNumRelease.text)+
          ','+QuotedStr(DateTimeToStr(dtpDate.Date))+
          ','+IntToStr(publishing_id)+
          ','+QuotedStr(Trim(edAbout.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldrelease_id:=strtoint(id);

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

procedure TfmEditRBRelease.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBRelease.UpdateRBooks: Boolean;
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

    id:=inttostr(oldrelease_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbRelease+
          ' set numrelease='+Trim(edNumrelease.Text)+
          ', daterelease='+QuotedStr(DateTimeToStr(dtpDate.Date))+
          ', publishing_id='+IntToStr(publishing_id)+
          ', about='+QuotedStr(Trim(edAbout.text))+
          ' where release_id='+id;
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

procedure TfmEditRBRelease.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBRelease.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNumRelease.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNumRelease.Caption]));
    edNumRelease.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAbout.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAbout.Caption]));
    edAbout.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPublishing.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPublishing.Caption]));
    edPublishing.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBRelease.edFactorChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBRelease.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNumRelease.MaxLength:=9;
  
  dtpDate.Date:=_GetDateTimeFromServer;
  dtpToDate.Date:=dtpDate.Date;

  edAbout.MaxLength:=DomainNoteLength;
  edPublishing.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBRelease.edNumReleaseKeyPress(Sender: TObject;
  var Key: Char);
begin
  ChangeFlag:=true;
  if (not (Key in ['0'..'9']))and
     (Key<>DecimalSeparator)and
     (Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmEditRBRelease.edNumReleaseChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBRelease.bibTodateClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
 try
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepMonth;
   P.LoadAndSave:=false;
   P.DateBegin:=dtpDate.Date;
   P.DateEnd:=dtpToDate.Date;
   if _ViewEnterPeriod(P) then begin
     dtpDate.Date:=P.DateBegin;
     dtpToDate.Date:=P.DateEnd;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBRelease.bibPublishingClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='publishing_id';
  TPRBI.Locate.KeyValues:=publishing_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPublishing,@TPRBI) then begin
   ChangeFlag:=true;
   publishing_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'publishing_id');
   edPublishing.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
