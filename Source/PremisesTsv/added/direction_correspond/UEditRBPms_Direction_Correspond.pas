unit UEditRBPms_Direction_Correspond;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Direction_Correspond = class(TfmEditRB)
    lbCityRegion: TLabel;
    edCityRegion: TEdit;
    edRegion: TEdit;
    lbRegion: TLabel;
    btCityRegion: TButton;
    btRegion: TButton;
    procedure edCityRegionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  
    procedure btCityRegionClick(Sender: TObject);
    procedure btRegionClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldpms_city_region_id: Integer;
    oldpms_region_id: Integer;
    pms_city_region_id: Integer;
    pms_region_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Direction_Correspond: TfmEditRBPms_Direction_Correspond;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Direction_Correspond;

{$R *.DFM}

procedure TfmEditRBPms_Direction_Correspond.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Direction_Correspond.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbPms_Direction_Correspond+
          ' (pms_city_region_id,pms_region_id) values '+
          ' ('+inttostr(pms_city_region_id)+
          ','+inttostr(pms_region_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldpms_city_region_id:=pms_city_region_id;
    oldpms_region_id:=pms_region_id;

    TfmRBPms_Direction_Correspond(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Direction_Correspond(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Direction_Correspond(fmParent).MainQr do begin
      Insert;
       FieldByName('pms_city_region_id').AsInteger:=pms_city_region_id;
       FieldByName('pms_region_id').AsInteger:=pms_region_id;
       FieldByName('CITY_REGION').AsString:=Trim(edCityRegion.text);
       FieldByName('REGION').AsString:=Trim(edRegion.text);

      Post;

    end;
    TfmRBPms_Direction_Correspond(fmParent).ActiveQuery(true);
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

procedure TfmEditRBPms_Direction_Correspond.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Direction_Correspond.UpdateRBooks: Boolean;
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

    sqls:='Update '+tbPms_Direction_Correspond+
          ' set pms_city_region_id='+inttostr(pms_city_region_id)+
          ', pms_region_id='+inttostr(pms_region_id)+
          ' where pms_city_region_id='+IntToStr(oldpms_city_region_id)+' and pms_region_id='
           +IntToStr(oldpms_region_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Direction_Correspond(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Direction_Correspond(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Direction_Correspond(fmParent).MainQr do begin
      Edit;
       FieldByName('pms_city_region_id').AsInteger:=pms_city_region_id;
       FieldByName('pms_region_id').AsInteger:=pms_region_id;
       FieldByName('CITY_REGION').AsString:=Trim(edCityRegion.text);
       FieldByName('REGION').AsString:=Trim(edRegion.text);

      Post;
    end;
    TfmRBPms_Direction_Correspond(fmParent).ActiveQuery(true);
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

procedure TfmEditRBPms_Direction_Correspond.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Direction_Correspond.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCityRegion.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCityRegion.Caption]));
    edCityRegion.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edRegion.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRegion.Caption]));
    edRegion.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Direction_Correspond.edCityRegionChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Direction_Correspond.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBPms_Direction_Correspond.btCityRegionClick(Sender: TObject);
 var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_city_region_id';
  TPRBI.Locate.KeyValues:=pms_city_region_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPms_City_Region,@TPRBI) then begin
   ChangeFlag:=true;
   pms_city_region_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_city_region_id');
   edCityRegion.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBPms_Direction_Correspond.btRegionClick(Sender: TObject);
 var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_region_id';
  TPRBI.Locate.KeyValues:=pms_region_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPms_Region,@TPRBI) then begin
   ChangeFlag:=true;
     pms_region_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_region_id');
     edRegion.text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   end;


end;

end.
