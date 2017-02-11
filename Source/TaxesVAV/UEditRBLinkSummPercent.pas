unit UEditRBLinkSummPercent;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBLinkSummPercent = class(TfmEditRB)
    lbLinkSummPercent: TLabel;
    lbParent: TLabel;
    edLinkSummPercent: TEdit;
    edNameTaxes: TEdit;
    bibParentTaxesType: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edBlackStringChange(Sender: TObject);
    procedure edNameTaxesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibParentTaxesTypeClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldLinkSummPercent_id: Integer;
//    Properties_id: Integer;
    ParentProperties_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBLinkSummPercent: TfmEditRBLinkSummPercent;

implementation

uses UTaxesVAVCode, UTaxesVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBLinkSummPercent.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBLinkSummPercent.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbLinkSummPercent,1));
    sqls:='Insert into '+tbLinkSummPercent+
          ' (LinkSummPercent_id,LinkSummPercent,Properties_id) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edLinkSummPercent.text))+
          ','+GetStrFromCondition(ParentProperties_id<>0,IntToStr(ParentProperties_id),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldLinkSummPercent_id:=strtoint(id);

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

procedure TfmEditRBLinkSummPercent.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBLinkSummPercent.UpdateRBooks: Boolean;
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

    id:=inttostr(oldLinkSummPercent_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbLinkSummPercent+
          ' set LinkSummPercent='+QuotedStr(Trim(edLinkSummPercent.text))+
          ', Properties_id='+GetStrFromCondition(ParentProperties_id<>0,IntToStr(ParentProperties_id),'null')+
          ' where LinkSummPercent_id='+id;
    oldLinkSummPercent_id:=StrToInt(id);

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

procedure TfmEditRBLinkSummPercent.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBLinkSummPercent.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edLinkSummPercent.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbLinkSummPercent.Caption]));
    edLinkSummPercent.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBLinkSummPercent.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edLinkSummPercent.MaxLength:=DomainSmallNameLength;
end;

procedure TfmEditRBLinkSummPercent.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBLinkSummPercent.edBlackStringChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBLinkSummPercent.edNameTaxesKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edNameTaxes.Text:='';
    ChangeFlag:=true;
    ParentProperties_id:=0;
  end;
end;

procedure TfmEditRBLinkSummPercent.bibParentTaxesTypeClick(
  Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TaxesType_id';
  TPRBI.Locate.KeyValues:=ParentProperties_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTaxesType,@TPRBI) then begin
   ChangeFlag:=true;
   ParentProperties_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TaxesType_id');
   edNameTaxes.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameTaxes');
  end;
end;

end.
