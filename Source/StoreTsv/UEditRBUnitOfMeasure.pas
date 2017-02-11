unit UEditRBUnitOfMeasure;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBUnitOfMeasure = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbShortName: TLabel;
    edShortName: TEdit;
    lbOkei: TLabel;
    edOkei: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldunitofmeasure_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBUnitOfMeasure: TfmEditRBUnitOfMeasure;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBUnitOfMeasure;

{$R *.DFM}

procedure TfmEditRBUnitOfMeasure.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBUnitOfMeasure.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbUnitOfMeasure,1));
    sqls:='Insert into '+tbUnitOfMeasure+
          ' (unitofmeasure_id,name,smallname,okei) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edShortName.Text))+
          ','+QuotedStr(Trim(edOkei.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldunitofmeasure_id:=strtoint(id);

    TfmRBUnitOfMeasure(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBUnitOfMeasure(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBUnitOfMeasure(fmParent).MainQr do begin
      Insert;
      FieldByName('unitofmeasure_id').AsInteger:=oldunitofmeasure_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('smallname').AsString:=Trim(edShortName.Text);
      FieldByName('okei').AsString:=Trim(edOkei.Text);
      Post;
    end;

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

procedure TfmEditRBUnitOfMeasure.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBUnitOfMeasure.UpdateRBooks: Boolean;
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

    id:=inttostr(oldunitofmeasure_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbUnitOfMeasure+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', smallname='+QuotedStr(Trim(edShortName.text))+
          ', okei='+QuotedStr(Trim(edOkei.text))+
          ' where unitofmeasure_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBUnitOfMeasure(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBUnitOfMeasure(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBUnitOfMeasure(fmParent).MainQr do begin
      Edit;
      FieldByName('unitofmeasure_id').AsInteger:=oldunitofmeasure_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('smallname').AsString:=Trim(edShortName.Text);
      FieldByName('okei').AsString:=Trim(edOkei.Text);
      Post;
    end;
    
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

procedure TfmEditRBUnitOfMeasure.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBUnitOfMeasure.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edShortName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbShortName.Caption]));
    edShortName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBUnitOfMeasure.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBUnitOfMeasure.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edShortName.MaxLength:=DomainSmallNameLength;
  edOkei.MaxLength:=DomainSmallNameLength;
end;

end.
