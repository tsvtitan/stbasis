unit UEditRBAPRegionStreet;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, tsvStdCtrls;

type
  TfmEditRBAPRegionStreet = class(TfmEditRB)
    lbRegion: TLabel;
    edRegion: TEdit;
    lbStreet: TLabel;
    edStreet: TEdit;
    bibRegion: TButton;
    bibStreet: TButton;
    procedure edRegionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRegionClick(Sender: TObject);
    procedure bibStreetClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ap_region_id: Integer;
    oldap_region_id: Integer;
    ap_street_id: Integer;
    oldap_street_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBAPRegionStreet: TfmEditRBAPRegionStreet;

implementation

uses UAnnPremData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBAPRegionStreet.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBAPRegionStreet.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbAPRegionStreet+
          ' (ap_region_id,ap_street_id) values '+
          ' ('+inttostr(ap_region_id)+','+inttostr(ap_street_id)+')';
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

procedure TfmEditRBAPRegionStreet.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAPRegionStreet.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbAPRegionStreet+
          ' set ap_region_id='+inttostr(ap_region_id)+
          ', ap_street_id='+inttostr(ap_street_id)+
          ' where ap_region_id='+inttostr(oldap_region_id)+
          ' and ap_street_id='+inttostr(oldap_street_id);
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

procedure TfmEditRBAPRegionStreet.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBAPRegionStreet.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edRegion.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRegion.Caption]));
    bibRegion.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edStreet.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    bibStreet.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAPRegionStreet.edRegionChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAPRegionStreet.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

end;

procedure TfmEditRBAPRegionStreet.bibRegionClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='AP_REGION_ID';
  TPRBI.Locate.KeyValues:=ap_region_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAPRegion,@TPRBI) then begin
   ChangeFlag:=true;
   ap_region_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'AP_REGION_ID');
   edRegion.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
  end;
end;

procedure TfmEditRBAPRegionStreet.bibStreetClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='AP_STREET_ID';
  TPRBI.Locate.KeyValues:=ap_street_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAPStreet,@TPRBI) then begin
   ChangeFlag:=true;
   edStreet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
   ap_street_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'AP_STREET_ID');
  end;
end;

end.
