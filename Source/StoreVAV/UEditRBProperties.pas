unit UEditRBProperties;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBProperties = class(TfmEditRB)
    lbProperties: TLabel;
    edNameProperties: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    edParentProperties: TEdit;
    bibParentProperties: TBitBtn;
    lbParent: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNamePropertiesChange(Sender: TObject);
    procedure bibParentPropertiesClick(Sender: TObject);
    procedure edParentPropertiesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldProperties_id: Integer;
    ParentProperties_ID: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBProperties: TfmEditRBProperties;

implementation

uses UStoreVAVCode, UStoreVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBProperties.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBProperties.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbProperties,1));
    sqls:='Insert into '+tbProperties+
          ' (Properties_id,NameProperties,about,parent_id) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edNameProperties.text))+
          ','+QuotedStr(Trim(meAbout.Text))+
          ','+GetStrFromCondition(ParentProperties_id<>0,IntToStr(ParentProperties_id),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldProperties_id:=strtoint(id);
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

procedure TfmEditRBProperties.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBProperties.UpdateRBooks: Boolean;
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

    id:=inttostr(oldProperties_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbProperties+
          ' set NameProperties='+QuotedStr(Trim(edNameProperties.text))+
          ', About='+QuotedStr(Trim(meAbout.Text))+
          ', Parent_id='+GetStrFromCondition(ParentProperties_id<>0,IntToStr(ParentProperties_id),'null')+
          ' where Properties_id='+id;
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

procedure TfmEditRBProperties.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBProperties.CheckFieldsFill: Boolean;
begin
  Result:=false;
  if trim(edNameProperties.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbProperties.Caption]));
    edNameProperties.SetFocus;
    exit;
  end;
 Result:=true;
end;

procedure TfmEditRBProperties.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameProperties.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBProperties.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBProperties.edNamePropertiesChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBProperties.bibParentPropertiesClick(Sender: TObject);
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

procedure TfmEditRBProperties.edParentPropertiesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edParentProperties.Text:='';
    ChangeFlag:=true;
    ParentProperties_id:=0;
  end;
end;

end.
