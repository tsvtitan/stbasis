unit UEditRBValuesProperties;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBValuesProperties = class(TfmEditRB)
    lbValueProperties: TLabel;
    lbParent: TLabel;
    edValueProperties: TEdit;
    edParentProperties: TEdit;
    bibParentProperties: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edBlackStringChange(Sender: TObject);
    procedure edParentPropertiesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibParentPropertiesClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldValueProperties_id: Integer;
//    Properties_id: Integer;
    ParentProperties_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBValuesProperties: TfmEditRBValuesProperties;

implementation

uses UStoreVAVCode, UStoreVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBValuesProperties.Filterclick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBValuesProperties.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbVaLueProperties,1));
    sqls:='Insert into '+tbVaLueProperties+
          ' (VaLueProperties_id,VaLueProperties,Properties_id) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edValueProperties.text))+
          ','+GetStrFromCondition(ParentProperties_id<>0,IntToStr(ParentProperties_id),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldValueProperties_id:=strtoint(id);

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

procedure TfmEditRBValuesProperties.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBValuesProperties.UpdateRBooks: Boolean;
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

    id:=inttostr(oldValueProperties_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbValueProperties+
          ' set ValueProperties='+QuotedStr(Trim(edValueProperties.text))+
          ', Properties_id='+GetStrFromCondition(ParentProperties_id<>0,IntToStr(ParentProperties_id),'null')+
          ' where ValueProperties_id='+id;
    oldValueProperties_id:=StrToInt(id);

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

procedure TfmEditRBValuesProperties.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBValuesProperties.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edValueProperties.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbValueProperties.Caption]));
    edValueProperties.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBValuesProperties.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edValueProperties.MaxLength:=DomainSmallNameLength;
end;

procedure TfmEditRBValuesProperties.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBValuesProperties.edBlackStringChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBValuesProperties.edParentPropertiesKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edParentProperties.Text:='';
    ChangeFlag:=true;
    ParentProperties_id:=0;
  end;
end;

procedure TfmEditRBValuesProperties.bibParentPropertiesClick(
  Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Properties_id';
  TPRBI.Locate.KeyValues:=ParentProperties_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkProperties,@TPRBI) then begin
   ChangeFlag:=true;
   ParentProperties_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Properties_id');
   edParentProperties.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameProperties');
  end;
end;

end.
