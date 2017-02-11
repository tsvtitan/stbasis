unit UEditRBPms_City_Region;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_City_Region = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbSortNumber: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_City_Region_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_City_Region: TfmEditRBPms_City_Region;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_City_Region;

{$R *.DFM}

procedure TfmEditRBPms_City_Region.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_City_Region.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPms_City_Region,1));
    sqls:='Insert into '+tbPms_City_Region+
          ' (Pms_City_Region_id,name,sortnumber) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+inttostr(udSort.Position)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_City_Region_id:=strtoint(id);

    TfmRBPms_City_Region(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_City_Region(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_City_Region(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_City_Region_id').AsInteger:=oldPms_City_Region_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
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

procedure TfmEditRBPms_City_Region.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_City_Region.UpdateRBooks: Boolean;
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

    id:=inttostr(oldPms_City_Region_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_City_Region+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', sortnumber='+inttostr(udSort.Position)+
          ' where Pms_City_Region_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_City_Region(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_City_Region(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_City_Region(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_City_Region_id').AsInteger:=oldPms_City_Region_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
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

procedure TfmEditRBPms_City_Region.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_City_Region.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_City_Region.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_City_Region.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
end;

procedure TfmEditRBPms_City_Region.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

end.
