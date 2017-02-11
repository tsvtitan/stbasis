unit UEditRBChargeTree;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBChargeTree = class(TfmEditRB)
    lbParent: TLabel;
    edParent: TEdit;
    bibParent: TBitBtn;
    lbName: TLabel;
    edName: TEdit;
    bibName: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibParentClick(Sender: TObject);
    procedure edParentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibNameClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldchargetree_id: Integer;
    ParentChargeTreeId: Integer;
    charge_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBChargeTree: TfmEditRBChargeTree;

implementation

uses USalaryTsvCode, USalaryTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBChargeTree.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBChargeTree.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  parent_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbChargeTree,1));
    if ParentChargeTreeId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentChargeTreeId);
    sqls:='Insert into '+tbChargeTree+
          ' (chargetree_id,charge_id,parent_id) values '+
          ' ('+id+','+inttostr(charge_id)+','+parent_id+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldchargetree_id:=strtoint(id);

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBChargeTree.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBChargeTree.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id,parent_id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldchargetree_id);//fmRBSchool.MainQr.FieldByName('school_id').AsString;
    if ParentChargeTreeId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentChargeTreeId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbChargeTree+
          ' set charge_id='+inttostr(charge_id)+
          ', parent_id='+parent_id+
          ' where chargetree_id='+id;
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBChargeTree.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBChargeTree.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBChargeTree.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBChargeTree.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edParent.MaxLength:=DomainNameLength;
end;

procedure TfmEditRBChargeTree.bibParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='chargetree_id';
  TPRBI.Locate.KeyValues:=ParentChargeTreeId;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkChargeTree,@TPRBI) then begin
   ChangeFlag:=true;
   ParentChargeTreeId:=GetFirstValueFromParamRBookInterface(@TPRBI,'chargetree_id');
   edParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'chargename');
  end;
end;

procedure TfmEditRBChargeTree.edParentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edParent.Text)=Length(edParent.SelText) then begin
      edParent.Text:='';
      ParentChargeTreeId:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBChargeTree.bibNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='charge_id';
  TPRBI.Locate.KeyValues:=charge_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCharge,@TPRBI) then begin
   ChangeFlag:=true;
   charge_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'charge_id');
   edName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
