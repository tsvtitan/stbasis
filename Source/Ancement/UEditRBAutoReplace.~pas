unit UEditRBAutoReplace;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBAutoReplace = class(TfmEditRB)
    lbWhat: TLabel;
    edWhat: TEdit;
    lbOnWhat: TLabel;
    edOnWhat: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edWhatChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldAutoReplace_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBAutoReplace: TfmEditRBAutoReplace;

implementation

uses UAncementCode, UAncementData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBAutoReplace.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAutoReplace.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbAutoReplace,1));
    sqls:='Insert into '+tbAutoReplace+
          ' (Auto_Replace_id,What,on_what) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edWhat.text))+
          ','+QuotedStr(Trim(edOnWhat.text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldAutoReplace_id:=strtoint(id);

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

procedure TfmEditRBAutoReplace.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAutoReplace.UpdateRBooks: Boolean;
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

    id:=inttostr(oldAutoReplace_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbAutoReplace+
          ' set What='+QuotedStr(Trim(edWhat.text))+
          ', on_what='+QuotedStr(Trim(edOnWhat.text))+
          ' where Auto_Replace_id='+id;

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

procedure TfmEditRBAutoReplace.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAutoReplace.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edWhat.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbWhat.Caption]));
    edWhat.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edOnWhat.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbOnWhat.Caption]));
    edOnWhat.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAutoReplace.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edWhat.MaxLength:=DomainSmallNameLength;
  edOnWhat.MaxLength:=DomainSmallNameLength;
end;

procedure TfmEditRBAutoReplace.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAutoReplace.edWhatChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
