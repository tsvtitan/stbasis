unit UEditRBStorePlace;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBStorePlace = class(TfmEditRB)
    lbNameStorePlace: TLabel;
    edNameStorePlace: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    edStoreType: TEdit;
    bibStoreType: TBitBtn;
    lbStoreType: TLabel;
    lbRespondents: TLabel;
    edRespondents: TEdit;
    bibRespondents: TBitBtn;
    lbPlant: TLabel;
    edPlant: TEdit;
    bibPlant: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameStorePlaceChange(Sender: TObject);
    procedure bibStoreTypeClick(Sender: TObject);
    procedure edStoreTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibRespondentsClick(Sender: TObject);
    procedure bibPlantClick(Sender: TObject);
    procedure edRespondentsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPlantKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldStorePlace_id: Integer;
    StorePlace_id,Respondents_id,Plant_id,StoreType_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBStorePlace: TfmEditRBStorePlace;

implementation

uses UStoreVAVCode, UStoreVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBStorePlace.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBStorePlace.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbStorePlace,1));
    sqls:='Insert into '+tbStorePlace+
          ' (StorePlace_id,NameStorePlace,Respondents_id,Storetype_id,Plant_id,about) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edNameStorePlace.text))+
          ','+IntToStr(Respondents_id)+
          ','+IntToStr(StoreType_id)+
          ','+IntToStr(Plant_id)+
          ','+QuotedStr(Trim(meAbout.Text))+')';

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldStorePlace_id:=strtoint(id);
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

procedure TfmEditRBStorePlace.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBStorePlace.UpdateRBooks: Boolean;
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

    id:=inttostr(oldStorePlace_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbStorePlace+
          ' set NameStorePlace='+QuotedStr(Trim(edNameStorePlace.text))+
          ', Respondents_id='+IntToStr(Respondents_id)+
          ', StoreType_id='+IntToStr(StoreType_id)+
          ', Plant_id='+IntToStr(Plant_id)+
          ', About='+QuotedStr(Trim(meAbout.Text))+
          ' where StorePlace_id='+id;
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

procedure TfmEditRBStorePlace.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBStorePlace.CheckFieldsFill: Boolean;
begin
  Result:=false;
  if trim(edNameStorePlace.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameStorePlace.Caption]));
    edNameStorePlace.SetFocus;
    exit;
  end;
  if trim(edStoreType.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbStoreType.Caption]));
    edStoreType.SetFocus;
    exit;
  end;
  if trim(edRespondents.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbRespondents.Caption]));
    edRespondents.SetFocus;
    exit;
  end;
  if trim(edPlant.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPlant.Caption]));
    edPlant.SetFocus;
    exit;
  end;

 Result:=true;
end;

procedure TfmEditRBStorePlace.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameStorePlace.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBStorePlace.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBStorePlace.edNameStorePlaceChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBStorePlace.bibStoreTypeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='StoreType_id';
  TPRBI.Locate.KeyValues:=StoreType_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkStoreType,@TPRBI) then begin
   ChangeFlag:=true;
   StoreType_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'StoreType_id');
   edStoreType.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameStoreType');
  end;
end;

procedure TfmEditRBStorePlace.edStoreTypeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edStoreType.Text:='';
    ChangeFlag:=true;
    StoreType_id:=0;
  end;
end;

procedure TfmEditRBStorePlace.bibRespondentsClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  n:Ansistring;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Respondents_id';
  TPRBI.Locate.KeyValues:=Respondents_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRespondents,@TPRBI) then begin
   ChangeFlag:=true;
   Respondents_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Respondents_id');
   n:=GetFirstValueFromParamRBookInterface(@TPRBI,'FNAME');
   n:=n+' '+GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
   n:=n+' '+GetFirstValueFromParamRBookInterface(@TPRBI,'SNAME');
   edRespondents.Text:=n;

  end;
end;

procedure TfmEditRBStorePlace.bibPlantClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Plant_id';
  TPRBI.Locate.KeyValues:=Plant_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPlant,@TPRBI) then begin
   ChangeFlag:=true;
   Plant_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Plant_id');
   edPlant.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'SmallName');
  end;
end;

procedure TfmEditRBStorePlace.edRespondentsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edRespondents.Text:='';
    ChangeFlag:=true;
    Respondents_id:=0;
  end;
end;

procedure TfmEditRBStorePlace.edPlantKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edPlant.Text:='';
    ChangeFlag:=true;
    Plant_id:=0;
  end;
end;

end.
