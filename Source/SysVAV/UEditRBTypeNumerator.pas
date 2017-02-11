unit UEditRBTypeNumerator;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBTypeNumerator = class(TfmEditRB)
    lbNameTypeNumerator: TLabel;
    edNameTypeNumerator: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameTypeNumeratorChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldTypeNumerator_id: Integer;
    TypeNumerator_id: Integer;
    fmParent:TForm;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTypeNumerator: TfmEditRBTypeNumerator;

implementation

uses USysVAVCode, USysVAVData, UMainUnited, URBTypeNumerator;

{$R *.DFM}

procedure TfmEditRBTypeNumerator.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTypeNumerator.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbTypeNumerator,1));
    sqls:='Insert into '+ tbTypeNumerator +
          ' (TypeNumerator_id,NameTypeNumerator,About) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edNameTypeNumerator.text))+
          ','+QuotedStr(Trim(meAbout.text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    oldTypeNumerator_id:=strtoint(id);

    TfmRBTypeNumerator(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBTypeNumerator(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBTypeNumerator(fmParent).Mainqr do begin
      Insert;
      FieldByName('TypeNumerator_id').AsInteger:=StrToInt(id);
      FieldByName('NameTypeNumerator').AsString:=Trim(edNAmeTypeNumerator.text);
      FieldByName('About').AsString:=Trim(meAbout.text);
      Post;
    end;
    oldTypeNumerator_id:=StrToInt(id);
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
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

procedure TfmEditRBTypeNumerator.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTypeNumerator.UpdateRBooks: Boolean;
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

    id:=inttostr(oldTypeNumerator_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTypeNumerator+
          ' set NameTypeNumerator='+QuotedStr(Trim(edNameTypeNumerator.text))+
          ', about='+QuotedStr(Trim(meAbout.text))+
          ' where TypeNumerator_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;

    TfmRBTypeNumerator(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBTypeNumerator(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBTypeNumerator(fmParent).Mainqr do begin
      Edit;
      FieldByName('TypeNumerator_id').AsInteger:=StrToInt(id);
      FieldByName('NameTypeNumerator').AsString:=Trim(edNAmeTypeNumerator.text);
      FieldByName('About').AsString:=Trim(meAbout.text);
      Post;
    end;
    oldTypeNumerator_id:=StrToInt(id);
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

procedure TfmEditRBTypeNumerator.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBTypeNumerator.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNameTypeNumerator.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameTypeNumerator.Caption]));
    edNameTypeNumerator.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBTypeNumerator.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameTypeNumerator.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBTypeNumerator.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTypeNumerator.edNameTypeNumeratorChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.



