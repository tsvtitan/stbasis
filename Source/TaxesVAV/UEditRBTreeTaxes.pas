unit UEditRBTreeTaxes;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBTreeTaxes = class(TfmEditRB)
    edTaxesType: TEdit;
    bibTaxesType: TBitBtn;
    lbTaxesType: TLabel;
    lbStandartOperation: TLabel;
    edStandartOperation: TEdit;
    bibStandartOperation: TBitBtn;
    lbParent: TLabel;
    edParentTreeTaxes: TEdit;
    bibParentTreeTaxes: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameTaxesChange(Sender: TObject);
    procedure bibTaxesTypeClick(Sender: TObject);
    procedure edTaxesTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStandartOperationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
//    procedure edParentTreeTaxesEnter(Sender: TObject);
//    procedure edParentTreeTaxesChange(Sender: TObject);
    procedure edParentTreeTaxesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibParentTreeTaxesClick(Sender: TObject);
    procedure bibStandartOperationClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldTreeTaxes_id: Integer;
    ParentTreeTaxes_ID,StandartOperation_id,taxestype_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTreeTaxes: TfmEditRBTreeTaxes;

implementation

uses UTaxesVAVCode, UTaxesVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBTreeTaxes.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTreeTaxes.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbTreeTaxes,1));
    sqls:='Insert into '+tbTreeTaxes+
          ' (TreeTaxes_id,TaxesType_id,StandartOperation_id,parent_id) values '+
          ' ('+id+
          ','+IntToStr(TaxesType_id)+
          ','+IntToStr(StandartOperation_id)+
          ','+GetStrFromCondition(ParentTreeTaxes_id<>0,IntToStr(ParentTreeTaxes_id),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldTreeTaxes_id:=strtoint(id);
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

procedure TfmEditRBTreeTaxes.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTreeTaxes.UpdateRBooks: Boolean;
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

    id:=inttostr(oldTreeTaxes_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTreeTaxes+
          ' set TaxesType_id='+IntToStr(TaxesType_id)+
          ', StandartOperation_id='+IntToStr(StandartOperation_id)+
          ', Parent_id='+GetStrFromCondition(ParentTreeTaxes_id<>0,IntToStr(ParentTreeTaxes_id),'null')+
          ' where TreeTaxes_id='+id;
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

procedure TfmEditRBTreeTaxes.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBTreeTaxes.CheckFieldsFill: Boolean;
begin
  Result:=false;
  if trim(edTaxesType.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTaxesType.Caption]));
    edTaxesType.SetFocus;
    exit;
  end;
  if trim(edStandartOperation.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbStandartOperation.Caption]));
    edStandartOperation.SetFocus;
    exit;
  end;
 Result:=true;
end;

procedure TfmEditRBTreeTaxes.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

//  edNameTaxes.MaxLength:=DomainSmallNameLength;
//  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBTreeTaxes.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTreeTaxes.edNameTaxesChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTreeTaxes.bibTaxesTypeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TaxesType_id';
  TPRBI.Locate.KeyValues:=TaxesType_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTaxesType,@TPRBI) then begin
   ChangeFlag:=true;
   TaxesType_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TaxesType_id');
   edTaxesType.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameTreeTaxes');
  end;
end;

procedure TfmEditRBTreeTaxes.edTaxesTypeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edTaxesType.Text:='';
    ChangeFlag:=true;
    TaxesType_id:=0;
  end;
end;

procedure TfmEditRBTreeTaxes.edStandartOperationKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edStandartOperation.Text:='';
    ChangeFlag:=true;
    StandartOperation_id:=0;
  end;
end;

procedure TfmEditRBTreeTaxes.edParentTreeTaxesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edParentTreeTaxes.Text:='';
    ChangeFlag:=true;
    ParentTreeTaxes_ID:=0;
  end;
end;

procedure TfmEditRBTreeTaxes.bibParentTreeTaxesClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TreeTaxes_id';
  TPRBI.Locate.KeyValues:=ParentTreeTaxes_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTreeTaxes,@TPRBI) then begin
   ChangeFlag:=true;
   ParentTreeTaxes_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TreeTaxes_id');
   edParentTreeTaxes.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameTreeTaxes');
  end;
end;

procedure TfmEditRBTreeTaxes.bibStandartOperationClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='StandartOperation_id';
  TPRBI.Locate.KeyValues:=StandartOperation_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkStandartOperation,@TPRBI) then begin
   ChangeFlag:=true;
   StandartOperation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'StandartOperation_id');
   edStandartOperation.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

end.
