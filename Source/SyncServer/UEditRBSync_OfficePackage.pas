unit UEditRBSync_OfficePackage;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, ExtDlgs, IBTable, clipbrd;

type
  TfmEditRBSync_OfficePackage = class(TfmEditRB)
    lbOffice: TLabel;
    lbPackage: TLabel;
    edOffice: TEdit;
    btOffice: TButton;
    edPackage: TEdit;
    btPackage: TButton;
    lbPriority: TLabel;
    edPriority: TEdit;
    lbDirection: TLabel;
    cmbDirection: TComboBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure htShortCutEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btOfficeClick(Sender: TObject);
    procedure btPackageClick(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edHowMuchChange(Sender: TObject);
    procedure cmbDirectionChange(Sender: TObject);
  private
  protected
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldoffice_id: Integer;
    oldpackage_id: Integer;
    office_id: Integer;
    package_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSync_OfficePackage: TfmEditRBSync_OfficePackage;

implementation

uses USyncServerCode, USyncServerData, UMainUnited, URBSync_OfficePackage;

{$R *.DFM}

procedure TfmEditRBSync_OfficePackage.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBSync_OfficePackage.AddToRBooks: Boolean;
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
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbSync_OfficePackage+
          ' (sync_office_id,sync_package_id,priority,direction) values '+
          ' ('+Inttostr(office_id)+
          ','+inttostr(package_id)+
          ','+Trim(edPriority.Text)+
          ','+IntToStr(cmbDirection.ItemIndex)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    oldoffice_id:=office_id;
    oldpackage_id:=package_id;

    TfmRBSync_OfficePackage(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBSync_OfficePackage(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBSync_OfficePackage(fmParent).MainQr do begin
      Insert;
      FieldByName('sync_office_id').AsInteger:=office_id;
      FieldByName('sync_package_id').AsInteger:=package_id;
      FieldByName('priority').AsInteger:=StrToInt(Trim(edPriority.Text));
      FieldByName('direction').AsInteger:=cmbDirection.ItemIndex;
      FieldByName('office_name').AsString:=edOffice.Text;
      FieldByName('package_name').AsString:=edPackage.Text;
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

procedure TfmEditRBSync_OfficePackage.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSync_OfficePackage.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbSync_OfficePackage+
          ' set sync_office_id='+inttostr(office_id)+
          ', sync_package_id='+inttostr(package_id)+
          ', priority='+Trim(edPriority.Text)+
          ', direction='+IntToStr(cmbDirection.ItemIndex)+
          ' where sync_office_id='+IntToStr(oldoffice_id)+' and sync_package_id='+IntToStr(oldpackage_id);

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    oldoffice_id:=office_id;
    oldpackage_id:=package_id;
    
    TfmRBSync_OfficePackage(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBSync_OfficePackage(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBSync_OfficePackage(fmParent).MainQr do begin
      Edit;
      FieldByName('sync_office_id').AsInteger:=office_id;
      FieldByName('sync_package_id').AsInteger:=package_id;
      FieldByName('priority').AsInteger:=StrToInt(Trim(edPriority.Text));
      FieldByName('direction').AsInteger:=cmbDirection.ItemIndex;
      FieldByName('office_name').AsString:=edOffice.Text;
      FieldByName('package_name').AsString:=edPackage.Text;
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

procedure TfmEditRBSync_OfficePackage.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBSync_OfficePackage.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edOffice.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbOffice.Caption]));
    btOffice.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPackage.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPackage.Caption]));
    btPackage.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPriority.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPriority.Caption]));
    edPriority.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBSync_OfficePackage.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_OfficePackage.FormCreate(Sender: TObject);
begin
  inherited;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edOffice.MaxLength:=DomainNameLength;
  edPackage.MaxLength:=DomainNameLength;
  edPriority.Text:='1';
  cmbDirection.ItemIndex:=0;

  LoadFromIni;
end;

procedure TfmEditRBSync_OfficePackage.htShortCutEnter(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_OfficePackage.FormDestroy(Sender: TObject);
begin
  inherited;

  SaveToIni;
end;

procedure TfmEditRBSync_OfficePackage.LoadFromIni;
begin
end;

procedure TfmEditRBSync_OfficePackage.SaveToIni;
begin
end;

procedure TfmEditRBSync_OfficePackage.btOfficeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sync_office_id';
  TPRBI.Locate.KeyValues:=office_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSync_Office,@TPRBI) then begin
   ChangeFlag:=true;
   office_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sync_office_id');
   edOffice.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBSync_OfficePackage.btPackageClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sync_package_id';
  TPRBI.Locate.KeyValues:=package_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSync_Package,@TPRBI) then begin
   ChangeFlag:=true;
   package_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sync_package_id');
   edPackage.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBSync_OfficePackage.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_OfficePackage.edHowMuchChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_OfficePackage.cmbDirectionChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
