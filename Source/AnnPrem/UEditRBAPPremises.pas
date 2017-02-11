unit UEditRBAPPremises;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, IBDatabase, StdCtrls, ExtCtrls, ComCtrls, IBQuery, IB, DB,
  UMainUnited, tsvDbFilter,
  tsvComCtrls, tsvStdCtrls, tsvInterbase;

type
  TfmEditRBAPPremises = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNN: TLabel;
    edNN: TEdit;
    bvGeneralINfo: TBevel;
    lbGeneralInfo: TLabel;
    lbDeliveryDateFrom: TLabel;
    dtpDeliveryDateFrom: TDateTimePicker;
    lbDeliveryDateTo: TLabel;
    dtpDeliveryDateTo: TDateTimePicker;
    lbOperation: TLabel;
    edOperation: TEdit;
    btOperation: TButton;
    lbPhones: TLabel;
    edPhones: TEdit;
    lbAgency: TLabel;
    cmbAgency: TComboBox;
    bvAddressInfo: TBevel;
    lbAddressInfo: TLabel;
    lbRegion: TLabel;
    lbHouse: TLabel;
    lbApartment: TLabel;
    cmbRegion: TComboBox;
    edHouse: TEdit;
    edApartment: TEdit;
    lbTown: TLabel;
    cmbTown: TComboBox;
    lbLandmark: TLabel;
    cmbLandmark: TComboBox;
    lbStreet: TLabel;
    cmbStreet: TComboBox;
    bvHouseInfo: TBevel;
    lbHouseInfo: TLabel;
    lbFloorCount: TLabel;
    edFloorCount: TEdit;
    lbTypeHouse: TLabel;
    cmbTypeHouse: TComboBox;
    lbTypeWater: TLabel;
    cmbTypeWater: TComboBox;
    lbTypeHeat: TLabel;
    cmbTypeHeat: TComboBox;
    lbDelivery: TLabel;
    edDelivery: TEdit;
    lbBuilder: TLabel;
    cmbBuilder: TComboBox;
    lbTypePremises: TLabel;
    cmbTypePremises: TComboBox;
    bvApartmentInfo: TBevel;
    lbApartmentInfo: TLabel;
    lbSewerage: TLabel;
    cmbSewerage: TComboBox;
    lbFloor: TLabel;
    edFloor: TEdit;
    lbCountRoom: TLabel;
    cmbCountRoom: TComboBox;
    lbPlanning: TLabel;
    cmbPlanning: TComboBox;
    lbTypeApartment: TLabel;
    cmbTypeApartment: TComboBox;
    lbTypeCondition: TLabel;
    cmbTypeCondition: TComboBox;
    lbTypePnone: TLabel;
    cmbPhone: TComboBox;
    lbTypeBalcony: TLabel;
    cmbTypeBalcony: TComboBox;
    lbTypeDoor: TLabel;
    cmbTypeDoor: TComboBox;
    lbTypeSanitary: TLabel;
    cmbTypeSanitary: TComboBox;
    lbTypeFurniture: TLabel;
    cmbTypeFurniture: TComboBox;
    lbHomeTech: TLabel;
    cmbHomeTech: TComboBox;
    lbTypePlate: TLabel;
    cmbTypePlate: TComboBox;
    lbTypeInternet: TLabel;
    cmbTypeInternet: TComboBox;
    bvAreaInfo: TBevel;
    lbAreaInfo: TLabel;
    lbGeneralArea: TLabel;
    edGeneralArea: TEdit;
    lbDwellingArea: TLabel;
    edDwelling: TEdit;
    lbKitchenArea: TLabel;
    edKitchenArea: TEdit;
    lbGroundArea: TLabel;
    edGroundArea: TEdit;
    lbPaymentInfo: TLabel;
    bvPaymentInfo: TBevel;
    lbPrice: TLabel;
    cmbPriceCondition: TComboBox;
    edPrice: TEdit;
    cmbUnitPrice: TComboBox;
    lbPeriod: TLabel;
    edPeriod: TEdit;
    lbPaymentFor: TLabel;
    edPaymentFor: TEdit;
    bvBuildingsInfo: TBevel;
    lbBuildingsInfo: TLabel;
    lbTypeGarage: TLabel;
    cmbTypeGarage: TComboBox;
    lbTypeBath: TLabel;
    cmbBath: TComboBox;
    bvAdditionalInfo: TBevel;
    lbAdditionalInfo: TLabel;
    lbNote: TLabel;
    edNote: TEdit;
    bvRegistrationInfo: TBevel;
    lbRegistrationInfo: TLabel;
    lbStyle: TLabel;
    cmbStyle: TComboBox;
    lbWhoInsert: TLabel;
    edWhoInsert: TEdit;
    lbWhoUpdate: TLabel;
    edWhoUpdate: TEdit;
    btDeliveryDate: TButton;
    lbRelease: TLabel;
    edRelease: TEdit;
    btRelease: TButton;
    lbDirection: TLabel;
    cmbDirection: TComboBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btOperationClick(Sender: TObject);
    procedure btDeliveryDateClick(Sender: TObject);
    procedure edOperationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbAgencyEnter(Sender: TObject);
    procedure cmbAgencyExit(Sender: TObject);
    procedure cmbAgencyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbAgencyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibClearClick(Sender: TObject);
    procedure btReleaseClick(Sender: TObject);
    procedure edReleaseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbRegionChange(Sender: TObject);
  private
    FParentForm: TForm;
    FAPFieldViewId: Integer;
    FOldFieldKeyValue: Variant;
    FOldAPOperationId: INteger;
    FDefaultCaption: string;
    FCurrentIndex: Integer;
    FSelected: Boolean;
    FCurrentDateTime: TDateTime;
    FUser: TInfoConnectUser;
    procedure VisibleForFilter(AVisible: Boolean);
    procedure InitForAll;
    procedure CheckColumns;
    procedure FillRBAP(Table,Field: String; Strings: TStrings; FirstEmpty: Boolean; Where: String='');
    function SelectFromRBAP(ComboBox: TComboBox): Boolean;
    function GetTableNameByControl(Control: TControl): String;
    function GetRBookNameByControl(Control: TControl): String;
    function GetEmptyByControl(Control: TControl): Boolean;
    procedure FillControls;
    function GetValueByCombo(Combo: TComboBox): String;
    function GetValueByComboEx(Combo: TComboBox): Variant;
    procedure GetControlsByHint(AHint: String; List: TList);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetAddSql: String; virtual;
    procedure CacheUpdate; virtual;
    function GetUpdateSql: String; virtual;
    procedure InitUpdateAndView;
  public
    procedure InitAdd; virtual;
    procedure InitUpdate; virtual;
    procedure InitView; virtual;
    procedure InitFilter; virtual;
    procedure DoneFilter; virtual;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    property ParentForm: TForm read FParentForm write FParentForm;
    property OldFieldKeyValue: Variant read FOldFieldKeyValue write FOldFieldKeyValue;
  end;

  TfmEditRBAPPremisesClass = class of TfmEditRBAPPremises;

var
  fmEditRBAPPremises: TfmEditRBAPPremises;

implementation

uses contnrs, UAnnPremData, URBAP, URBAPPremises;

{$R *.DFM}

procedure TfmEditRBAPPremises.GetControlsByHint(AHint: String; List: TList);
var
  i: Integer;
  Control: TControl;
begin
  List.Clear;
  for i:=0 to ControlCount-1 do begin
    Control:=Controls[i];
    if AnsiSameText(Control.Hint,AHint) then begin
      List.Add(Control);
    end;
  end;
end;

procedure TfmEditRBAPPremises.CheckColumns;
var
  Exclude: TObjectList;
  FMemIniFile: TPremisesIniFile;

  procedure LoadColumns;
  var
    S: String;
    Stream: TStringStream;
  begin
    S:=GetFirstValueBySQL(IBDB,
                          Format('SELECT FIELDS FROM AP_FIELD_VIEW WHERE AP_FIELD_VIEW_ID=%s',
                                 [InttoStr(FAPFieldViewId)]),
                          'FIELDS');
    Stream:=TStringStream.Create(S);
    try
      FMemIniFile.Clear;
      FMemIniFile.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;


  procedure DisabledAll;
  var
    i: Integer;
    Control: TControl;
    Labl: TLabel;
  begin
    for i:=0 to ControlCount-1 do begin
      Control:=Controls[i];
      Control.Enabled:=Exclude.IndexOf(Control)<>-1;
      if (Control is TWinControl) and (Exclude.IndexOf(Control)=-1) then begin
        Labl:=GetLabelByWinControl(TWinControl(Control));
        if Assigned(Labl) then begin
          Labl.Enabled:=Control.Enabled;
        end;
        if Control is TEdit then
          TEdit(Control).Color:=iff(Control.Enabled,clWindow,clBtnFace);
        if Control is TComboBox then
          TComboBox(Control).Color:=iff(Control.Enabled,clWindow,clBtnFace);
        if Control is TDateTimePicker then
          TDateTimePicker(Control).Color:=iff(Control.Enabled,clWindow,clBtnFace);
      end;
    end;
  end;
  
var
  i,j: Integer;
  AName: String;
  Control: TControl;
  Labl: TLabel;
  List: TList;
  Section: TStringList;
begin
  Exclude:=TObjectList.Create;
  FMemIniFile:=TPremisesIniFile.Create;
  Section:=TStringList.Create;
  try
    Exclude.OwnsObjects:=false;
    Exclude.Add(bvGeneralINfo);
    Exclude.Add(lbGeneralInfo);
    Exclude.Add(bvAddressInfo);
    Exclude.Add(lbAddressInfo);
    Exclude.Add(bvApartmentInfo);
    Exclude.Add(lbApartmentInfo);
    Exclude.Add(bvHouseInfo);
    Exclude.Add(lbHouseInfo);
    Exclude.Add(bvAreaInfo);
    Exclude.Add(lbAreaInfo);
    Exclude.Add(bvPaymentInfo);
    Exclude.Add(lbPaymentInfo);
    Exclude.Add(bvAdditionalInfo);
    Exclude.Add(lbAdditionalInfo);
    Exclude.Add(bvBuildingsInfo);
    Exclude.Add(lbBuildingsInfo);
    Exclude.Add(bvRegistrationInfo);
    Exclude.Add(lbRegistrationInfo);
    Exclude.Add(lbRelease);
    Exclude.Add(edRelease);
    Exclude.Add(btRelease);
    Exclude.Add(lbOperation);
    Exclude.Add(edOperation);
    Exclude.Add(btOperation);
    Exclude.Add(lbWhoInsert);
    Exclude.Add(edWhoInsert);
    Exclude.Add(lbWhoUpdate);
    Exclude.Add(edWhoUpdate);
    Exclude.Add(cbInString);
    Exclude.Add(pnBut);
    Exclude.Add(bibOk);
    Exclude.Add(bibCancel);
    DisabledAll;
    LoadColumns;
    FMemIniFile.ReadSection(SColumns,Section);
    for i:=0 to Section.Count-1 do begin
      AName:=Section.Strings[i];
      List:=TList.Create;
      try
        GetControlsByHint(AName,List);
        for j:=0 to List.Count-1 do begin
          Control:=TControl(List.Items[j]);
          if Assigned(Control) and (Exclude.IndexOf(Control)=-1) then begin
            Control.Enabled:=true;
            if Control is TWinControl then begin
              Labl:=GetLabelByWinControl(TWinControl(Control));
              if Assigned(Labl) then
                Labl.Enabled:=Control.Enabled;
              if Control is TEdit then
                TEdit(Control).Color:=iff(Control.Enabled,clWindow,clBtnFace);
              if Control is TComboBox then
                TComboBox(Control).Color:=iff(Control.Enabled,clWindow,clBtnFace);
              if Control is TDateTimePicker then
                TDateTimePicker(Control).Color:=iff(Control.Enabled,clWindow,clBtnFace);
            end;
          end;
        end;
      finally
        List.Free;
      end;
    end;
  finally
    Section.Free;
    FMemIniFile.Free;
    Exclude.Free;
  end;
end;

procedure TfmEditRBAPPremises.FillControls;
var
  i: Integer;
  Control: TControl;
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    for i:=0 to ControlCount-1 do begin
      Control:=Controls[i];
      if Control is TComboBox then begin
        if TComboBox(Control).Enabled then
          FillRBAP(GetTableNameByControl(Control),'NAME',TComboBox(Control).Items,GetEmptyByControl(Control));
      end;
    end;
  finally
    Screen.Cursor:=OldCursor;
  end;  
end;

procedure TfmEditRBAPPremises.InitForAll;
begin
  FDefaultCaption:=Self.Caption;
  with TfmRBAPPremises(ParentForm) do begin
    Self.Caption:=Format(SFormatCaption,[FDefaultCaption,qrTRee.FieldByName('FULLNAME').AsString]);
    edOperation.Text:=qrTree.FieldByName('NAME').AsString;
    edOperation.Tag:=qrTree.FieldByName('AP_OPERATION_ID').AsInteger;
    FOldAPOperationId:=edOperation.Tag;
    FAPFieldViewId:=qrTree.FieldByName('AP_FIELD_VIEW_ID').AsInteger;
  end;
  CheckColumns;
  FillControls;
end;

procedure TfmEditRBAPPremises.VisibleForFilter(AVisible: Boolean);
begin
  edRelease.ReadOnly:=not AVisible;
  edRelease.Color:=iff(AVisible,clWindow,clBtnFace);
  edOperation.ReadOnly:=true;
  if Avisible then
    edOperation.OnKeyDown:=nil
  else
    edOperation.OnKeyDown:=edOperationKeyDown;
  edOperation.Color:=clBtnFace;
  btOperation.Enabled:=not AVisible;
  dtpDeliveryDateFrom.ShowCheckbox:=AVisible;
  dtpDeliveryDateFrom.Checked:=false;
  dtpDeliveryDateFrom.Checked:=false;
  lbDeliveryDateTo.Visible:=AVisible;
  dtpDeliveryDateTo.Visible:=AVisible;
  dtpDeliveryDateTo.ShowCheckbox:=AVisible;
  dtpDeliveryDateTo.Checked:=false;
  dtpDeliveryDateTo.Checked:=false;
  btDeliveryDate.Visible:=AVisible;
  lbPrice.Left:=iff(AVisible,459,515);
  cmbPriceCondition.Visible:=AVisible;
  edWhoInsert.ReadOnly:=not AVisible;
  edWhoInsert.Color:=iff(AVisible,clWindow,clBtnFace);
  edWhoUpdate.ReadOnly:=not AVisible;
  edWhoUpdate.Color:=iff(AVisible,clWindow,clBtnFace);
end;

procedure TfmEditRBAPPremises.InitAdd;

  procedure SetUsers;
  var
    T: TInfoConnectUser;
  begin
    FillChar(T,SizeOf(T),0);
    _GetInfoConnectUser(@T);
    edWhoInsert.Text:=T.UserName;
    edWhoInsert.Tag:=T.User_id;
  end;

  procedure SetNearRelease;
  var
    TPRBI: TParamRBookInterface;
  begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' DATERELEASE>='+QuotedStr(DateToStr(_GetDateTimeFromServer))+' ');
    TPRBI.Condition.OrderStr:=PChar(' DATERELEASE ');
    if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
     if ifExistsDataInPRBI(@TPRBI) then begin
       edRelease.Tag:=GetFirstValueFromParamRBookInterface(@TPRBI,'RELEASE_ID');
       edRelease.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'ABOUT');
     end;
    end;
  end;

begin
  TypeEditRBook:=terbAdd;
  InitForAll;
  SetUsers;
  SetNearRelease;
  VisibleForFilter(false);
end;

procedure TfmEditRBAPPremises.InitUpdateAndView;
begin
  with TfmRBAPPremises(ParentForm) do begin
    FOldFieldKeyValue:=Mainqr.FieldByName(FieldKeyName).AsInteger;
    edRelease.Text:=MainQr.FieldByName('RELEASE_ABOUT').AsString;
    edRelease.Tag:=MainQr.FieldByName('RELEASE_ID').AsInteger;
    edNN.Text:=Mainqr.fieldByName('NN').AsString;
    dtpDeliveryDateFrom.DateTime:=Mainqr.fieldByName('DELIVERY_DATE').AsDateTime;
    edPhones.Text:=Mainqr.fieldByName('PREMISES_PHONES').AsString;
    edName.Text:=Mainqr.fieldByName('PREMISES_NAME').AsString;
    cmbAgency.ItemIndex:=cmbAgency.Items.IndexOf(Mainqr.fieldByName('AGENCY_NAME').AsString);
    cmbTown.ItemIndex:=cmbTown.Items.IndexOf(Mainqr.fieldByName('TOWN_NAME').AsString);
    cmbRegion.ItemIndex:=cmbRegion.Items.IndexOf(Mainqr.fieldByName('REGION_NAME').AsString);
    cmbLandmark.ItemIndex:=cmbLandmark.Items.IndexOf(Mainqr.fieldByName('LANDMARK_NAME').AsString);
    cmbDirection.ItemIndex:=cmbDirection.Items.IndexOf(Mainqr.fieldByName('DIRECTION_NAME').AsString);
    cmbStreet.ItemIndex:=cmbStreet.Items.IndexOf(Mainqr.fieldByName('STREET_NAME').AsString);
    edHouse.Text:=Mainqr.fieldByName('HOUSE').AsString;
    edApartment.Text:=Mainqr.fieldByName('APARTMENT').AsString;
    cmbTypePremises.ItemIndex:=cmbTypePremises.Items.IndexOf(Mainqr.fieldByName('TYPE_PREMISES_NAME').AsString);
    edFloorCount.Text:=Mainqr.fieldByName('FLOOR_COUNT').AsString;
    cmbTypeHouse.ItemIndex:=cmbTypeHouse.Items.IndexOf(Mainqr.fieldByName('TYPE_BUILDING_NAME').AsString);
    cmbTypeWater.ItemIndex:=cmbTypeWater.Items.IndexOf(Mainqr.fieldByName('TYPE_WATER_NAME').AsString);
    cmbTypeHeat.ItemIndex:=cmbTypeHeat.Items.IndexOf(Mainqr.fieldByName('TYPE_HEAT_NAME').AsString);
    cmbSewerage.ItemIndex:=cmbSewerage.Items.IndexOf(Mainqr.fieldByName('TYPE_SEWERAGE_NAME').AsString);
    edDelivery.Text:=Mainqr.fieldByName('DELIVERY').AsString;
    cmbBuilder.ItemIndex:=cmbBuilder.Items.IndexOf(Mainqr.fieldByName('BUILDER_NAME').AsString);
    cmbTypeGarage.ItemIndex:=cmbTypeGarage.Items.IndexOf(Mainqr.fieldByName('TYPE_GARAGE_NAME').AsString);
    cmbBath.ItemIndex:=cmbBath.Items.IndexOf(Mainqr.fieldByName('TYPE_BATH_NAME').AsString);
    edFloor.Text:=Mainqr.fieldByName('FLOOR').AsString;
    cmbCountRoom.ItemIndex:=cmbCountRoom.Items.IndexOf(Mainqr.fieldByName('COUNTROOM_NAME').AsString);
    cmbPlanning.ItemIndex:=cmbPlanning.Items.IndexOf(Mainqr.fieldByName('PLANNING_NAME').AsString);
    cmbTypeApartment.ItemIndex:=cmbTypeApartment.Items.IndexOf(Mainqr.fieldByName('TYPE_APARTMENT_NAME').AsString);
    cmbTypeCondition.ItemIndex:=cmbTypeCondition.Items.IndexOf(Mainqr.fieldByName('TYPE_CONDITION_NAME').AsString);
    cmbPhone.ItemIndex:=cmbPhone.Items.IndexOf(Mainqr.fieldByName('TYPE_PHONE_NAME').AsString);
    cmbTypeBalcony.ItemIndex:=cmbTypeBalcony.Items.IndexOf(Mainqr.fieldByName('TYPE_BALCONY_NAME').AsString);
    cmbTypeDoor.ItemIndex:=cmbTypeDoor.Items.IndexOf(Mainqr.fieldByName('TYPE_DOOR_NAME').AsString);
    cmbTypeSanitary.ItemIndex:=cmbTypeSanitary.Items.IndexOf(Mainqr.fieldByName('TYPE_SANITARY_NAME').AsString);
    cmbTypeFurniture.ItemIndex:=cmbTypeFurniture.Items.IndexOf(Mainqr.fieldByName('TYPE_FURNITURE_NAME').AsString);
    cmbHomeTech.ItemIndex:=cmbHomeTech.Items.IndexOf(Mainqr.fieldByName('HOME_TECH_NAME').AsString);
    cmbTypePlate.ItemIndex:=cmbTypePlate.Items.IndexOf(Mainqr.fieldByName('TYPE_PLATE_NAME').AsString);
    cmbTypeInternet.ItemIndex:=cmbTypeInternet.Items.IndexOf(Mainqr.fieldByName('TYPE_INTERNET_NAME').AsString);
    edGeneralArea.Text:=Mainqr.fieldByName('GENERAL_AREA').AsString;
    edDwelling.Text:=Mainqr.fieldByName('DWELLING_AREA').AsString;
    edKitchenArea.Text:=Mainqr.fieldByName('KITCHEN_AREA').AsString;
    edGroundArea.Text:=Mainqr.fieldByName('GROUND_AREA').AsString;
    edPrice.Text:=Mainqr.fieldByName('PRICE').AsString;
    cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(Mainqr.fieldByName('UNIT_PRICE_NAME').AsString);
    edPeriod.Text:=Mainqr.fieldByName('PERIOD').AsString;
    edPaymentFor.Text:=Mainqr.fieldByName('PAYMENT_FOR').AsString;
    edNote.Text:=Mainqr.fieldByName('NOTE').AsString;
    cmbStyle.ItemIndex:=cmbStyle.Items.IndexOf(Mainqr.fieldByName('STYLE_NAME').AsString);
    edWhoInsert.Text:=Mainqr.fieldByName('WHO_INSERT_NAME').AsString;
    edWhoInsert.Tag:=Mainqr.fieldByName('WHO_INSERT_ID').AsInteger;
    edWhoUpdate.Text:=Mainqr.fieldByName('WHO_UPDATE_NAME').AsString;
    edWhoUpdate.Tag:=Mainqr.fieldByName('WHO_UPDATE_ID').AsInteger;
  end;
end;

procedure TfmEditRBAPPremises.InitUpdate;
begin
  TypeEditRBook:=terbChange;
  InitForAll;
  VisibleForFilter(false);
  InitUpdateAndView;
end;

procedure TfmEditRBAPPremises.InitView;
begin
  TypeEditRBook:=terbView;
  InitForAll;
  VisibleForFilter(false);
  InitUpdateAndView;
end;

procedure TfmEditRBAPPremises.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAPPremises.GetValueByCombo(Combo: TComboBox): String;
var
  Empty: Boolean;
begin
  Result:='NULL';
  Empty:=GetEmptyByControl(Combo);
  Combo.ItemIndex:=Combo.Items.IndexOf(Combo.Text);
  if not Empty then begin
    if (Combo.ItemIndex<>-1) then begin
      Result:=Inttostr(Integer(Combo.Items.Objects[Combo.ItemIndex]));
    end;
  end else begin
    if (Combo.ItemIndex<>-1) and (Combo.ItemIndex<>0) then begin
      Result:=Inttostr(Integer(Combo.Items.Objects[Combo.ItemIndex]));
    end;
  end;
end;

function TfmEditRBAPPremises.GetValueByComboEx(Combo: TComboBox): Variant;
var
  Empty: Boolean;
begin
  Result:=NULL;
  Empty:=GetEmptyByControl(Combo);
  Combo.ItemIndex:=Combo.Items.IndexOf(Combo.Text);
  if not Empty then begin
    if (Combo.ItemIndex<>-1) then begin
      Result:=Integer(Combo.Items.Objects[Combo.ItemIndex]);
    end;
  end else begin
    if (Combo.ItemIndex<>-1) and (Combo.ItemIndex<>0) then begin
      Result:=Integer(Combo.Items.Objects[Combo.ItemIndex]);
    end;
  end;
end;

function TfmEditRBAPPremises.GetAddSql: String;
begin
  FCurrentDateTime:=_GetDateTimeFromServer;
  FillChar(FUser,SizeOf(FUser),0);
  _GetInfoConnectUser(@FUser);
  Result:='INSERT INTO '+TfmRBAPPremises(ParentForm).TableName+
          ' ('+TfmRBAPPremises(ParentForm).FieldKeyName+
          ',RELEASE_ID'+
          ',AP_OPERATION_ID'+
          ',NN'+
          ',DELIVERY_DATE'+
          ',PHONES'+
          ',NAME'+
          ',AP_AGENCY_ID'+
          ',AP_TOWN_ID'+
          ',AP_REGION_ID'+
          ',AP_LANDMARK_ID'+
          ',AP_DIRECTION_ID'+
          ',AP_STREET_ID'+
          ',HOUSE'+
          ',APARTMENT'+
          ',AP_TYPE_PREMISES_ID'+
          ',FLOOR_COUNT'+
          ',AP_TYPE_BUILDING_ID'+
          ',AP_TYPE_WATER_ID'+
          ',AP_TYPE_HEAT_ID'+
          ',AP_TYPE_SEWERAGE_ID'+
          ',DELIVERY'+
          ',AP_BUILDER_ID'+
          ',FLOOR'+
          ',AP_COUNTROOM_ID'+
          ',AP_PLANNING_ID'+
          ',AP_TYPE_APARTMENT_ID'+
          ',AP_TYPE_CONDITION_ID'+
          ',AP_TYPE_PHONE_ID'+
          ',AP_TYPE_BALCONY_ID'+
          ',AP_TYPE_DOOR_ID'+
          ',AP_TYPE_SANITARY_ID'+
          ',AP_TYPE_FURNITURE_ID'+
          ',AP_HOME_TECH_ID'+
          ',AP_TYPE_PLATE_ID'+
          ',AP_TYPE_INTERNET_ID'+
          ',GENERAL_AREA'+
          ',DWELLING_AREA'+
          ',KITCHEN_AREA'+
          ',GROUND_AREA'+
          ',PRICE'+
          ',AP_UNIT_PRICE_ID'+
          ',PERIOD'+
          ',PAYMENT_FOR'+
          ',AP_TYPE_GARAGE_ID'+
          ',AP_TYPE_BATH_ID'+
          ',NOTE'+
          ',AP_STYLE_ID'+
          ',WHO_INSERT_ID'+
          ',WHEN_INSERT'+
          ',WHO_UPDATE_ID'+
          ',WHEN_UPDATE'+
          ') VALUES ('+inttostr(FOldFieldKeyValue)+
          ','+IntTostr(edRelease.Tag)+
          ','+IntTostr(edOperation.Tag)+
          ','+iff(Trim(edNN.Text)<>'',QuotedStr(Trim(edNN.Text)),'NULL')+
          ','+QuotedStr(DateToStr(dtpDeliveryDateFrom.Date))+
          ','+iff(Trim(edPhones.Text)<>'',QuotedStr(Trim(edPhones.Text)),'NULL')+
          ','+iff(Trim(edName.Text)<>'',QuotedStr(Trim(edName.Text)),'NULL')+
          ','+GetValueByCombo(cmbAgency)+
          ','+GetValueByCombo(cmbTown)+
          ','+GetValueByCombo(cmbRegion)+
          ','+GetValueByCombo(cmbLandMark)+
          ','+GetValueByCombo(cmbDirection)+
          ','+GetValueByCombo(cmbStreet)+
          ','+iff(Trim(edHouse.Text)<>'',QuotedStr(Trim(edHouse.Text)),'NULL')+
          ','+iff(Trim(edApartment.Text)<>'',QuotedStr(Trim(edApartment.Text)),'NULL')+
          ','+GetValueByCombo(cmbTypePremises)+
          ','+iff(Trim(edFloorCount.Text)<>'',QuotedStr(Trim(edFloorCount.Text)),'NULL')+
          ','+GetValueByCombo(cmbTypeHouse)+
          ','+GetValueByCombo(cmbTypeWater)+
          ','+GetValueByCombo(cmbTypeHeat)+
          ','+GetValueByCombo(cmbSewerage)+
          ','+iff(Trim(edDelivery.Text)<>'',QuotedStr(Trim(edDelivery.Text)),'NULL')+
          ','+GetValueByCombo(cmbBuilder)+
          ','+iff(Trim(edFloor.Text)<>'',QuotedStr(Trim(edFloor.Text)),'NULL')+
          ','+GetValueByCombo(cmbCountRoom)+
          ','+GetValueByCombo(cmbPlanning)+
          ','+GetValueByCombo(cmbTypeApartment)+
          ','+GetValueByCombo(cmbTypeCondition)+
          ','+GetValueByCombo(cmbPhone)+
          ','+GetValueByCombo(cmbTypeBalcony)+
          ','+GetValueByCombo(cmbTypeDoor)+
          ','+GetValueByCombo(cmbTypeSanitary)+
          ','+GetValueByCombo(cmbTypeFurniture)+
          ','+GetValueByCombo(cmbHomeTech)+
          ','+GetValueByCombo(cmbTypePlate)+
          ','+GetValueByCombo(cmbTypeInternet)+
          ','+iff(Trim(edGeneralArea.Text)<>'',QuotedStr(ChangeChar(edGeneralArea.Text,',','.')),'NULL')+
          ','+iff(Trim(edDwelling.Text)<>'',QuotedStr(ChangeChar(edDwelling.Text,',','.')),'NULL')+
          ','+iff(Trim(edKitchenArea.Text)<>'',QuotedStr(ChangeChar(edKitchenArea.Text,',','.')),'NULL')+
          ','+iff(Trim(edGroundArea.Text)<>'',QuotedStr(ChangeChar(edGroundArea.Text,',','.')),'NULL')+
          ','+iff(Trim(edPrice.Text)<>'',QuotedStr(ChangeChar(edPrice.Text,',','.')),'NULL')+
          ','+GetValueByCombo(cmbUnitPrice)+
          ','+iff(Trim(edPeriod.Text)<>'',QuotedStr(Trim(edPeriod.Text)),'NULL')+
          ','+iff(Trim(edPaymentFor.Text)<>'',QuotedStr(Trim(edPaymentFor.Text)),'NULL')+
          ','+GetValueByCombo(cmbTypeGarage)+
          ','+GetValueByCombo(cmbBath)+
          ','+iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.Text)),'NULL')+
          ','+GetValueByCombo(cmbStyle)+
          ','+IntToStr(FUser.User_id)+
          ','+QuotedStr(DateTimeToStr(FCurrentDateTime))+
          ','+IntToStr(FUser.User_id)+
          ','+QuotedStr(DateTimeToStr(FCurrentDateTime))+
          ')';
end;

procedure TfmEditRBAPPremises.CacheUpdate;
begin
  with TfmRBAPPremises(ParentForm) do begin
    MainQr.FieldByName(FieldKeyName).Value:=FOldFieldKeyValue;
    MainQr.FieldByName('RELEASE_ID').Value:=edRelease.Tag;
    MainQr.FieldByName('AP_OPERATION_ID').Value:=edOperation.Tag;
    MainQr.FieldByName('NN').Value:=iff(Trim(edNN.Text)<>'',Trim(edNN.Text),NULL);
    MainQr.FieldByName('DELIVERY_DATE').Value:=dtpDeliveryDateFrom.Date;
    MainQr.FieldByName('PREMISES_PHONES').Value:=iff(Trim(edPhones.Text)<>'',Trim(edPhones.Text),NULL);
    MainQr.FieldByName('PREMISES_NAME').Value:=iff(Trim(edName.Text)<>'',Trim(edName.Text),NULL);
    MainQr.FieldByName('AP_AGENCY_ID').Value:=GetValueByComboEx(cmbAgency);
    MainQr.FieldByName('AP_TOWN_ID').Value:=GetValueByComboEx(cmbTown);
    MainQr.FieldByName('AP_REGION_ID').Value:=GetValueByComboEx(cmbRegion);
    MainQr.FieldByName('AP_LANDMARK_ID').Value:=GetValueByComboEx(cmbLandmark);
    MainQr.FieldByName('AP_DIRECTION_ID').Value:=GetValueByComboEx(cmbDirection);
    MainQr.FieldByName('AP_STREET_ID').Value:=GetValueByComboEx(cmbStreet);
    MainQr.FieldByName('HOUSE').Value:=iff(Trim(edHouse.Text)<>'',Trim(edHouse.Text),NULL);
    MainQr.FieldByName('APARTMENT').Value:=iff(Trim(edApartment.Text)<>'',Trim(edApartment.Text),NULL);
    MainQr.FieldByName('AP_TYPE_PREMISES_ID').Value:=GetValueByComboEx(cmbTypePremises);
    MainQr.FieldByName('FLOOR_COUNT').Value:=iff(Trim(edFloorCount.Text)<>'',Trim(edFloorCount.Text),NULL);
    MainQr.FieldByName('AP_TYPE_BUILDING_ID').Value:=GetValueByComboEx(cmbTypeHouse);
    MainQr.FieldByName('AP_TYPE_WATER_ID').Value:=GetValueByComboEx(cmbTypeWater);
    MainQr.FieldByName('AP_TYPE_HEAT_ID').Value:=GetValueByComboEx(cmbTypeHeat);
    MainQr.FieldByName('AP_TYPE_SEWERAGE_ID').Value:=GetValueByComboEx(cmbSewerage);
    MainQr.FieldByName('DELIVERY').Value:=iff(Trim(edDelivery.Text)<>'',Trim(edDelivery.Text),NULL);
    MainQr.FieldByName('AP_BUILDER_ID').Value:=GetValueByComboEx(cmbBuilder);
    MainQr.FieldByName('FLOOR').Value:=iff(Trim(edFloor.Text)<>'',Trim(edFloor.Text),NULL);
    MainQr.FieldByName('AP_COUNTROOM_ID').Value:=GetValueByComboEx(cmbCountRoom);
    MainQr.FieldByName('AP_PLANNING_ID').Value:=GetValueByComboEx(cmbPlanning);
    MainQr.FieldByName('AP_TYPE_APARTMENT_ID').Value:=GetValueByComboEx(cmbTypeApartment);
    MainQr.FieldByName('AP_TYPE_CONDITION_ID').Value:=GetValueByComboEx(cmbTypeCondition);
    MainQr.FieldByName('AP_TYPE_PHONE_ID').Value:=GetValueByComboEx(cmbPhone);
    MainQr.FieldByName('AP_TYPE_BALCONY_ID').Value:=GetValueByComboEx(cmbTypeBalcony);
    MainQr.FieldByName('AP_TYPE_DOOR_ID').Value:=GetValueByComboEx(cmbTypeDoor);
    MainQr.FieldByName('AP_TYPE_SANITARY_ID').Value:=GetValueByComboEx(cmbTypeSanitary);
    MainQr.FieldByName('AP_TYPE_FURNITURE_ID').Value:=GetValueByComboEx(cmbTypeFurniture);
    MainQr.FieldByName('AP_HOME_TECH_ID').Value:=GetValueByComboEx(cmbHomeTech);
    MainQr.FieldByName('AP_TYPE_PLATE_ID').Value:=GetValueByComboEx(cmbTypePlate);
    MainQr.FieldByName('AP_TYPE_INTERNET_ID').Value:=GetValueByComboEx(cmbTypeInternet);
    MainQr.FieldByName('GENERAL_AREA').Value:=iff(Trim(edGeneralArea.Text)<>'',Trim(edGeneralArea.Text),Null);
    MainQr.FieldByName('DWELLING_AREA').Value:=iff(Trim(edDwelling.Text)<>'',Trim(edDwelling.Text),Null);
    MainQr.FieldByName('KITCHEN_AREA').Value:=iff(Trim(edKitchenArea.Text)<>'',Trim(edKitchenArea.Text),Null);
    MainQr.FieldByName('GROUND_AREA').Value:=iff(Trim(edGroundArea.Text)<>'',Trim(edGroundArea.Text),Null);
    MainQr.FieldByName('PRICE').Value:=iff(Trim(edPrice.Text)<>'',Trim(edPrice.Text),Null);
    MainQr.FieldByName('AP_UNIT_PRICE_ID').Value:=GetValueByComboEx(cmbUnitPrice);
    MainQr.FieldByName('PERIOD').Value:=iff(Trim(edPeriod.Text)<>'',Trim(edPeriod.Text),Null);
    MainQr.FieldByName('PAYMENT_FOR').Value:=iff(Trim(edPaymentFor.Text)<>'',Trim(edPaymentFor.Text),Null);
    MainQr.FieldByName('AP_TYPE_GARAGE_ID').Value:=GetValueByComboEx(cmbTypeGarage);
    MainQr.FieldByName('AP_TYPE_BATH_ID').Value:=GetValueByComboEx(cmbBath);
    MainQr.FieldByName('NOTE').Value:=iff(Trim(edNote.Text)<>'',Trim(edNote.Text),Null);
    MainQr.FieldByName('AP_STYLE_ID').Value:=GetValueByComboEx(cmbStyle);
    MainQr.FieldByName('WHO_INSERT_ID').Value:=edWhoInsert.Tag;
    MainQr.FieldByName('WHEN_INSERT').Value:=iff(TypeEditRBook=terbAdd,FCurrentDateTime,MainQr.FieldByName('WHEN_INSERT').Value);
    MainQr.FieldByName('WHO_UPDATE_ID').Value:=FUser.User_id;
    MainQr.FieldByName('WHEN_UPDATE').Value:=FCurrentDateTime;
    MainQr.FieldByName('TOWN_NAME').Value:=iff(cmbTown.ItemIndex<>-1,cmbTown.Text,Null);
    MainQr.FieldByName('STREET_NAME').Value:=iff(cmbStreet.ItemIndex<>-1,cmbStreet.Text,Null);
    MainQr.FieldByName('LANDMARK_NAME').Value:=iff(cmbLandMark.ItemIndex<>-1,cmbLandMark.Text,Null);
    MainQr.FieldByName('DIRECTION_NAME').Value:=iff(cmbDirection.ItemIndex<>-1,cmbDirection.Text,Null);
    MainQr.FieldByName('REGION_NAME').Value:=iff(cmbRegion.ItemIndex<>-1,cmbRegion.Text,Null);
    MainQr.FieldByName('COUNTROOM_NAME').Value:=iff(cmbCountRoom.ItemIndex<>-1,cmbCountRoom.Text,Null);
    MainQr.FieldByName('TYPE_BUILDING_NAME').Value:=iff(cmbTypeHouse.ItemIndex<>-1,cmbTypeHouse.Text,Null);
    MainQr.FieldByName('AGENCY_NAME').Value:=iff(cmbAgency.ItemIndex<>-1,cmbAgency.Text,Null);
    MainQr.FieldByName('UNIT_PRICE_NAME').Value:=iff(cmbUnitPrice.ItemIndex<>-1,cmbUnitPrice.Text,Null);
    MainQr.FieldByName('TYPE_INTERNET_NAME').Value:=iff(cmbTypeInternet.ItemIndex<>-1,cmbTypeInternet.Text,Null);
    MainQr.FieldByName('TYPE_PREMISES_NAME').Value:=iff(cmbTypePremises.ItemIndex<>-1,cmbTypePremises.Text,Null);
    MainQr.FieldByName('BUILDER_NAME').Value:=iff(cmbBuilder.ItemIndex<>-1,cmbBuilder.Text,Null);
    MainQr.FieldByName('TYPE_DOOR_NAME').Value:=iff(cmbTypeDoor.ItemIndex<>-1,cmbTypeDoor.Text,Null);
    MainQr.FieldByName('HOME_TECH_NAME').Value:=iff(cmbHomeTech.ItemIndex<>-1,cmbHomeTech.Text,Null);
    MainQr.FieldByName('TYPE_FURNITURE_NAME').Value:=iff(cmbTypeFurniture.ItemIndex<>-1,cmbTypeFurniture.Text,Null);
    MainQr.FieldByName('TYPE_GARAGE_NAME').Value:=iff(cmbTypeGarage.ItemIndex<>-1,cmbTypeGarage.Text,Null);
    MainQr.FieldByName('TYPE_BATH_NAME').Value:=iff(cmbBath.ItemIndex<>-1,cmbBath.Text,Null);
    MainQr.FieldByName('TYPE_SEWERAGE_NAME').Value:=iff(cmbSewerage.ItemIndex<>-1,cmbSewerage.Text,Null);
    MainQr.FieldByName('TYPE_CONDITION_NAME').Value:=iff(cmbTypeCondition.ItemIndex<>-1,cmbTypeCondition.Text,Null);
    MainQr.FieldByName('TYPE_PLATE_NAME').Value:=iff(cmbTypePlate.ItemIndex<>-1,cmbTypePlate.Text,Null);
    MainQr.FieldByName('TYPE_WATER_NAME').Value:=iff(cmbTypeWater.ItemIndex<>-1,cmbTypeWater.Text,Null);
    MainQr.FieldByName('TYPE_HEAT_NAME').Value:=iff(cmbTypeHeat.ItemIndex<>-1,cmbTypeHeat.Text,Null);
    MainQr.FieldByName('TYPE_PHONE_NAME').Value:=iff(cmbPhone.ItemIndex<>-1,cmbPhone.Text,Null);
    MainQr.FieldByName('TYPE_BALCONY_NAME').Value:=iff(cmbTypeBalcony.ItemIndex<>-1,cmbTypeBalcony.Text,Null);
    MainQr.FieldByName('PLANNING_NAME').Value:=iff(cmbPlanning.ItemIndex<>-1,cmbPlanning.Text,Null);
    MainQr.FieldByName('TYPE_APARTMENT_NAME').Value:=iff(cmbTypeApartment.ItemIndex<>-1,cmbTypeApartment.Text,Null);
    MainQr.FieldByName('TYPE_SANITARY_NAME').Value:=iff(cmbTypeSanitary.ItemIndex<>-1,cmbTypeSanitary.Text,Null);
    MainQr.FieldByName('STYLE_NAME').Value:=iff(cmbStyle.ItemIndex<>-1,cmbStyle.Text,Null);
    MainQr.FieldByName('WHO_INSERT_NAME').Value:=Trim(edWhoInsert.Text);
    MainQr.FieldByName('WHO_UPDATE_NAME').Value:=String(FUser.UserName);
    MainQr.FieldByName('RELEASE_ABOUT').Value:=Trim(edRelease.Text);
  end;
end;

function TfmEditRBAPPremises.AddToRBooks: Boolean;
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
    FOldFieldKeyValue:=Integer(GetGenId(IBDB,TfmRBAPPremises(ParentForm).TableName,1));
    sqls:=GetAddSql;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    if FOldAPOperationId=edOperation.Tag then begin
      TfmRBAPPremises(ParentForm).IBUpd.InsertSQL.Clear;
      TfmRBAPPremises(ParentForm).IBUpd.InsertSQL.Add(sqls);

      with TfmRBAPPremises(ParentForm).MainQr do begin
        Insert;
        CacheUpdate;
        Post;
      end;
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

procedure TfmEditRBAPPremises.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAPPremises.GetUpdateSql: String;
begin
  FCurrentDateTime:=_GetDateTimeFromServer;
  FillChar(FUser,SizeOf(FUser),0);
  _GetInfoConnectUser(@FUser);

  Result:='UPDATE '+TfmRBAPPremises(ParentForm).TableName+
          ' SET AP_OPERATION_ID='+IntTostr(edOperation.Tag)+
          ',RELEASE_ID='+IntTostr(edRelease.Tag)+
          ',NN='+iff(Trim(edNN.Text)<>'',QuotedStr(Trim(edNN.Text)),'NULL')+
          ',DELIVERY_DATE='+QuotedStr(DateToStr(dtpDeliveryDateFrom.Date))+
          ',PHONES='+iff(Trim(edPhones.Text)<>'',QuotedStr(Trim(edPhones.Text)),'NULL')+
          ',NAME='+iff(Trim(edName.Text)<>'',QuotedStr(Trim(edName.Text)),'NULL')+
          ',AP_AGENCY_ID='+GetValueByCombo(cmbAgency)+
          ',AP_TOWN_ID='+GetValueByCombo(cmbTown)+
          ',AP_REGION_ID='+GetValueByCombo(cmbRegion)+
          ',AP_LANDMARK_ID='+GetValueByCombo(cmbLandMark)+
          ',AP_DIRECTION_ID='+GetValueByCombo(cmbDirection)+
          ',AP_STREET_ID='+GetValueByCombo(cmbStreet)+
          ',HOUSE='+iff(Trim(edHouse.Text)<>'',QuotedStr(Trim(edHouse.Text)),'NULL')+
          ',APARTMENT='+iff(Trim(edApartment.Text)<>'',QuotedStr(Trim(edApartment.Text)),'NULL')+
          ',AP_TYPE_PREMISES_ID='+GetValueByCombo(cmbTypePremises)+
          ',FLOOR_COUNT='+iff(Trim(edFloorCount.Text)<>'',QuotedStr(Trim(edFloorCount.Text)),'NULL')+
          ',AP_TYPE_BUILDING_ID='+GetValueByCombo(cmbTypeHouse)+
          ',AP_TYPE_WATER_ID='+GetValueByCombo(cmbTypeWater)+
          ',AP_TYPE_HEAT_ID='+GetValueByCombo(cmbTypeHeat)+
          ',AP_TYPE_SEWERAGE_ID='+GetValueByCombo(cmbSewerage)+
          ',DELIVERY='+iff(Trim(edDelivery.Text)<>'',QuotedStr(Trim(edDelivery.Text)),'NULL')+
          ',AP_BUILDER_ID='+GetValueByCombo(cmbBuilder)+
          ',FLOOR='+iff(Trim(edFloor.Text)<>'',QuotedStr(Trim(edFloor.Text)),'NULL')+
          ',AP_COUNTROOM_ID='+GetValueByCombo(cmbCountRoom)+
          ',AP_PLANNING_ID='+GetValueByCombo(cmbPlanning)+
          ',AP_TYPE_APARTMENT_ID='+GetValueByCombo(cmbTypeApartment)+
          ',AP_TYPE_CONDITION_ID='+GetValueByCombo(cmbTypeCondition)+
          ',AP_TYPE_PHONE_ID='+GetValueByCombo(cmbPhone)+
          ',AP_TYPE_BALCONY_ID='+GetValueByCombo(cmbTypeBalcony)+
          ',AP_TYPE_DOOR_ID='+GetValueByCombo(cmbTypeDoor)+
          ',AP_TYPE_SANITARY_ID='+GetValueByCombo(cmbTypeSanitary)+
          ',AP_TYPE_FURNITURE_ID='+GetValueByCombo(cmbTypeFurniture)+
          ',AP_HOME_TECH_ID='+GetValueByCombo(cmbHomeTech)+
          ',AP_TYPE_PLATE_ID='+GetValueByCombo(cmbTypePlate)+
          ',AP_TYPE_INTERNET_ID='+GetValueByCombo(cmbTypeInternet)+
          ',GENERAL_AREA='+iff(Trim(edGeneralArea.Text)<>'',QuotedStr(ChangeChar(edGeneralArea.Text,',','.')),'NULL')+
          ',DWELLING_AREA='+iff(Trim(edDwelling.Text)<>'',QuotedStr(ChangeChar(edDwelling.Text,',','.')),'NULL')+
          ',KITCHEN_AREA='+iff(Trim(edKitchenArea.Text)<>'',QuotedStr(ChangeChar(edKitchenArea.Text,',','.')),'NULL')+
          ',GROUND_AREA='+iff(Trim(edGroundArea.Text)<>'',QuotedStr(ChangeChar(edGroundArea.Text,',','.')),'NULL')+
          ',PRICE='+iff(Trim(edPrice.Text)<>'',QuotedStr(ChangeChar(edPrice.Text,',','.')),'NULL')+
          ',AP_UNIT_PRICE_ID='+GetValueByCombo(cmbUnitPrice)+
          ',PERIOD='+iff(Trim(edPeriod.Text)<>'',QuotedStr(Trim(edPeriod.Text)),'NULL')+
          ',PAYMENT_FOR='+iff(Trim(edPaymentFor.Text)<>'',QuotedStr(Trim(edPaymentFor.Text)),'NULL')+
          ',AP_TYPE_GARAGE_ID='+GetValueByCombo(cmbTypeGarage)+
          ',AP_TYPE_BATH_ID='+GetValueByCombo(cmbBath)+
          ',NOTE='+iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.Text)),'NULL')+
          ',AP_STYLE_ID='+GetValueByCombo(cmbStyle)+
          ',WHO_UPDATE_ID='+IntToStr(FUser.User_id)+
          ',WHEN_UPDATE='+QuotedStr(DateTimeToStr(FCurrentDateTime))+
          ' WHERE '+TfmRBAPPremises(ParentForm).FieldKeyName+'='+VarToStr(FOldFieldKeyValue);
end;

function TfmEditRBAPPremises.UpdateRBooks: Boolean;
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
    sqls:=GetUpdateSql;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    if FOldAPOperationId=edOperation.Tag then begin
      TfmRBAPPremises(ParentForm).IBUpd.ModifySQL.Clear;
      TfmRBAPPremises(ParentForm).IBUpd.ModifySQL.Add(sqls);

      with TfmRBAPPremises(ParentForm).MainQr do begin
        Edit;
        CacheUpdate;
        Post;
      end;
    end else begin
      with TfmRBAPPremises(ParentForm) do begin
        IBUpd.DeleteSQL.Clear;
        IBUpd.DeleteSQL.Add(Format('DELETE FROM AP_PREMISES WHERE AP_PREMISES_ID=%s',[VarToStr(FOldFieldKeyValue)]));
        MainQr.Delete;
      end;
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

procedure TfmEditRBAPPremises.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAPPremises.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edRelease.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRelease.Caption]));
    edRelease.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edOperation.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbOperation.Caption]));
    edOperation.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPhones.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPhones.Caption]));
    if edPhones.CanFocus then
      edPhones.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbAgency.Items.IndexOf(Trim(cmbAgency.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAgency.Caption]));
    if cmbAgency.CanFocus then
      cmbAgency.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbTown.Items.IndexOf(Trim(cmbTown.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTown.Caption]));
    if cmbTown.CanFocus then
      cmbTown.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbStreet.Items.IndexOf(Trim(cmbStreet.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    if cmbStreet.CanFocus then
      cmbStreet.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAPPremises.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAPPremises.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edNN.MaxLength:=DomainSmallNameLength;
  dtpDeliveryDateFrom.Date:=_GetDateTimeFromServer;
  dtpDeliveryDateFrom.Checked:=false;
  dtpDeliveryDateTo.Date:=dtpDeliveryDateFrom.Date;
  dtpDeliveryDateTo.Checked:=false;
  edOperation.MaxLength:=DomainNameLength;
  edRelease.MaxLength:=DomainSmallNameLength;
  edPhones.MaxLength:=DomainNameLength;
  cmbAgency.MaxLength:=DomainNameLength;
  cmbRegion.MaxLength:=DomainNameLength;
  edHouse.MaxLength:=DomainSmallNameLength;
  edApartment.MaxLength:=DomainSmallNameLength;
  cmbTown.MaxLength:=DomainNameLength;
  cmbLandmark.MaxLength:=DomainNameLength;
  cmbDirection.MaxLength:=DomainNameLength;
  cmbStreet.MaxLength:=DomainNameLength;
  edFloorCount.MaxLength:=DomainSmallNameLength;
  cmbTypeHouse.MaxLength:=DomainNameLength;
  cmbTypeWater.MaxLength:=DomainNameLength;
  cmbTypeHeat.MaxLength:=DomainNameLength;
  edDelivery.MaxLength:=DomainSmallNameLength;
  cmbBuilder.MaxLength:=DomainNameLength;
  cmbTypePremises.MaxLength:=DomainNameLength;
  cmbSewerage.MaxLength:=DomainNameLength;
  edFloor.MaxLength:=DomainSmallNameLength;
  cmbCountRoom.MaxLength:=DomainNameLength;
  cmbPlanning.MaxLength:=DomainNameLength;
  cmbTypeApartment.MaxLength:=DomainNameLength;
  cmbTypeCondition.MaxLength:=DomainNameLength;
  cmbPhone.MaxLength:=DomainNameLength;
  cmbTypeBalcony.MaxLength:=DomainNameLength;
  cmbTypeDoor.MaxLength:=DomainNameLength;
  cmbTypeSanitary.MaxLength:=DomainNameLength;
  cmbTypeFurniture.MaxLength:=DomainNameLength;
  cmbHomeTech.MaxLength:=DomainNameLength;
  cmbTypePlate.MaxLength:=DomainNameLength;
  cmbTypeInternet.MaxLength:=DomainNameLength;
  edGeneralArea.MaxLength:=DomainNameLength;
  edDwelling.MaxLength:=DomainNameLength;
  edKitchenArea.MaxLength:=DomainNameLength;
  edGroundArea.MaxLength:=DomainNameLength;
  cmbPriceCondition.ItemIndex:=0;
  edPrice.MaxLength:=DomainNameLength;
  cmbUnitPrice.MaxLength:=DomainNameLength;
  edPeriod.MaxLength:=DomainSmallNameLength;
  edPaymentFor.MaxLength:=DomainSmallNameLength;
  cmbTypeGarage.MaxLength:=DomainNameLength;
  cmbBath.MaxLength:=DomainNameLength;
  edNote.MaxLength:=DomainVariant;
  cmbStyle.MaxLength:=DomainNameLength;
  edWhoInsert.MaxLength:=DomainNameLength;
  edWhoUpdate.MaxLength:=DomainNameLength;

  EnabledAdjust:=true;
end;

procedure TfmEditRBAPPremises.btOperationClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  FullName: String;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='AP_OPERATION_ID';
  TPRBI.Locate.KeyValues:=edOperation.Tag;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAPOperation,@TPRBI) then begin
   ChangeFlag:=true;
   edOperation.Tag:=GetFirstValueFromParamRBookInterface(@TPRBI,'AP_OPERATION_ID');
   edOperation.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
   FAPFieldViewId:=GetFirstValueFromParamRBookInterface(@TPRBI,'AP_FIELD_VIEW_ID');
   FullName:=GetFirstValueFromParamRBookInterface(@TPRBI,'FULLNAME');
   CheckColumns;
   Caption:=Format(SFormatCaption,[FDefaultCaption,FullName]);
   Update;
  end;
end;

procedure TfmEditRBAPPremises.btDeliveryDateClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=ReadParam(ClassName,'period',P.TypePeriod);
   P.DateBegin:=dtpDeliveryDateFrom.DateTime;
   P.DateEnd:=dtpDeliveryDateTo.DateTime;
   if _ViewEnterPeriod(P) then begin
     dtpDeliveryDateFrom.DateTime:=P.DateBegin;
     dtpDeliveryDateTo.DateTime:=P.DateEnd;
     WriteParam(ClassName,'period',P.TypePeriod);
     ChangeFlag:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
end;

procedure TfmEditRBAPPremises.edOperationKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edOperation.Text)=Length(edOperation.SelText) then begin
      edOperation.Text:='';
      edOperation.Tag:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBAPPremises.FillRBAP(Table,Field: String; Strings: TStrings; FirstEmpty: Boolean; Where: String='');
var
  qr: TIBQuery;
  tr: TIBTransaction;
  sqls: string;
  Value: String;
  Key: Integer;
  FieldKeyID: string;
  WhereS: String;
begin
  if Trim(Table)='' then
    exit;
  Strings.BeginUpdate;
  qr:=TIBQuery.Create(nil);
  tr:=TIBTransaction.Create(nil);
  try
    FieldKeyID:=Table+'_ID';
    tr.AddDatabase(IBDB);
    IBDB.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=IBDB;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    WhereS:='';
    if Trim(Where)<>'' then
      WhereS:='WHERE '+Where;
    sqls:=Format(SQLSelectAPTable,[Table,WhereS]);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    Strings.Clear;
    if qr.Active and not qr.IsEmpty then begin
      if FirstEmpty then
        Strings.Add('');
      qr.First;
      while not qr.Eof do begin
        Value:=qr.FieldByName(Field).AsString;
        Key:=qr.FieldByName(FieldKeyID).AsInteger;
        Strings.AddObject(Value,TObject(Key));
        qr.Next;
      end;
    end;
  finally
    tr.free;
    qr.Free;
    Strings.EndUpdate;
  end;
end;

procedure TfmEditRBAPPremises.cmbAgencyEnter(Sender: TObject);
begin
  TComboBox(Sender).DroppedDown:=true;
end;

procedure TfmEditRBAPPremises.cmbAgencyExit(Sender: TObject);
var
  index: Integer;
begin
  index:=-1;
  if Sender is TComboBox then begin
    index:=TComboBox(Sender).ItemIndex;
  end;
  if Sender is TComboBox then begin
    if index>-1 then
      TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[index];
    SendMessage(TComboBox(Sender).Handle, CB_SETCURSEL, index, 0);
  end;
end;

procedure TfmEditRBAPPremises.cmbAgencyKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearWord;
  var
    s: string;
  begin
    s:=Copy(TComboBox(Sender).Text,1,TComboBox(Sender).SelStart);
    TComboBox(Sender).ItemIndex:=-1;
    TComboBox(Sender).Text:=s;
    TComboBox(Sender).SelStart:=Length(s);
    TComboBox(Sender).SelLength:=Length(TComboBox(Sender).Text)-TComboBox(Sender).SelStart;
  end;

begin
  ChangeFlag:=true;
  case Key of
    VK_DELETE,VK_BACK: ClearWord;
    VK_TAB: begin
      FCurrentIndex:=TComboBox(Sender).ItemIndex;
      if Shift=[] then
        SelectNext(TWinControl(Sender),true,true)
      else if Shift=[ssSHIFT] then
        SelectNext(TWinControl(Sender),false,true);
      if FCurrentIndex>-1 then
        TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[FCurrentIndex]
      else TComboBox(Sender).Text:='';
      SendMessage(TComboBox(Sender).Handle, CB_SETCURSEL, FCurrentIndex, 0);
    end;
    VK_RETURN: begin
      if Shift=[] then begin
        FCurrentIndex:=TComboBox(Sender).ItemIndex;
      end else 
        if Shift=[ssCtrl] then begin
          FSelected:=SelectFromRBAP(TComboBox(Sender));
        end;
    end;
  end;
end;

procedure TfmEditRBAPPremises.cmbAgencyKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  function GetWordStringIndex(s: string): Integer;
  var
    i: Integer;
    APos: Integer;
  begin
    Result:=-1;
    for i:=0 to TComboBox(Sender).Items.Count-1 do begin
      APos:=AnsiPos(AnsiUpperCase(s),AnsiUpperCase(TComboBox(Sender).Items.Strings[i]));
      if Apos=1 then begin
        Result:=i;
        exit;
      end;
    end;
  end;

var
  val: Integer;
  s: string;
begin
   if FSelected then begin
     FSelected:=false;
     exit;
   end;  
   case Key of
    VK_DELETE,VK_BACK,VK_TAB,
    VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN:;
    VK_RETURN: begin
      if not (ssCtrl in Shift) then begin
        if FCurrentIndex>-1 then
          TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[FCurrentIndex]
        else TComboBox(Sender).Text:='';
        SendMessage(TComboBox(Sender).Handle, CB_SETCURSEL, FCurrentIndex, 0);
      end else begin
      end;
    end;
    else begin
      S:=Copy(TComboBox(Sender).Text,1,TComboBox(Sender).SelStart);
      val:=GetWordStringIndex(S);
      if val<>-1 then begin

        TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[val];
        TComboBox(Sender).ItemIndex:=val;
        TComboBox(Sender).SelStart:=Length(s);
        TComboBox(Sender).SelLength:=Length(TComboBox(Sender).Text)-TComboBox(Sender).SelStart;
      end;
      FCurrentIndex:=val;
    end;
   end;
end;

function TfmEditRBAPPremises.GetTableNameByControl(Control: TControl): String;
begin
  Result:='';
  if Control=cmbAgency then Result:=tbAPAgency;
  if Control=cmbTown then Result:=tbAPTown;
  if Control=cmbRegion then Result:=tbAPRegion;
  if Control=cmbLandmark then Result:=tbAPLandMark;
  if Control=cmbDirection then Result:=tbAPDirection;
  if Control=cmbStreet then Result:=tbAPStreet;
  if Control=cmbTypePremises then Result:=tbAPTypePremises;
  if Control=cmbTypeHouse then Result:=tbAPTypeBuilding;
  if Control=cmbTypeWater then Result:=tbAPTypeWater;
  if Control=cmbTypeHeat then Result:=tbAPTypeHeat;
  if Control=cmbSewerage then Result:=tbAPTypeSewerage;
  if Control=cmbBuilder then Result:=tbAPBuilder;
  if Control=cmbTypeGarage then Result:=tbAPTypeGarage;
  if Control=cmbBath then Result:=tbAPTypeBath;
  if Control=cmbCountRoom then Result:=tbAPCountRoom;
  if Control=cmbPlanning then Result:=tbAPPlanning;
  if Control=cmbTypeApartment then Result:=tbAPTypeApartment;
  if Control=cmbTypeCondition then Result:=tbAPTypeCondition;
  if Control=cmbPhone then Result:=tbAPTypePhone;
  if Control=cmbTypeBalcony then Result:=tbAPTypeBalcony;
  if Control=cmbTypeDoor then Result:=tbAPTypeDoor;
  if Control=cmbTypeSanitary then Result:=tbAPTypeSanitary;
  if Control=cmbTypeFurniture then Result:=tbAPTypeFurniture;
  if Control=cmbHomeTech then Result:=tbAPHomeTech;
  if Control=cmbTypePlate then Result:=tbAPTypePlate;
  if Control=cmbTypeInternet then Result:=tbAPTypeInternet;
  if Control=cmbStyle then Result:=tbAPStyle;
  if Control=cmbUnitPrice then Result:=tbAPUnitPrice;
end;

function TfmEditRBAPPremises.GetRBookNameByControl(Control: TControl): String;
begin
  Result:='';
  if Control=cmbAgency then Result:=NameRbkApAgency;
  if Control=cmbTown then Result:=NameRbkApTown;
  if Control=cmbRegion then Result:=NameRbkApRegion;
  if Control=cmbLandmark then Result:=NameRbkApLandMark;
  if Control=cmbDirection then Result:=NameRbkApDirection;
  if Control=cmbStreet then Result:=NameRbkApStreet;
  if Control=cmbTypePremises then Result:=NameRbkApTypePremises;
  if Control=cmbTypeHouse then Result:=NameRbkApTypeBuilding;
  if Control=cmbTypeWater then Result:=NameRbkApTypeWater;
  if Control=cmbTypeHeat then Result:=NameRbkApTypeHeat;
  if Control=cmbSewerage then Result:=NameRbkApTypeSewerage;
  if Control=cmbBuilder then Result:=NameRbkApBuilder;
  if Control=cmbTypeGarage then Result:=NameRbkApTypeGarage;
  if Control=cmbBath then Result:=NameRbkApTypeBath;
  if Control=cmbCountRoom then Result:=NameRbkApCountRoom;
  if Control=cmbPlanning then Result:=NameRbkApPlanning;
  if Control=cmbTypeApartment then Result:=NameRbkApTypeApartment;
  if Control=cmbTypeCondition then Result:=NameRbkApTypeCondition;
  if Control=cmbPhone then Result:=NameRbkApTypePhone;
  if Control=cmbTypeBalcony then Result:=NameRbkApTypeBalcony;
  if Control=cmbTypeDoor then Result:=NameRbkApTypeDoor;
  if Control=cmbTypeSanitary then Result:=NameRbkApTypeSanitary;
  if Control=cmbTypeFurniture then Result:=NameRbkApTypeFurniture;
  if Control=cmbHomeTech then Result:=NameRbkApHomeTech;
  if Control=cmbTypePlate then Result:=NameRbkApTypePlate;
  if Control=cmbTypeInternet then Result:=NameRbkApTypeInternet;
  if Control=cmbStyle then Result:=NameRbkApStyle;
  if Control=cmbUnitPrice then Result:=NameRbkApUnitPrice;
end;

function TfmEditRBAPPremises.GetEmptyByControl(Control: TControl): Boolean;
begin
  Result:=true;
  if Control=cmbAgency then Result:=false;
  if Control=cmbTown then Result:=false;
  if Control=cmbStreet then Result:=false;
end;

function TfmEditRBAPPremises.SelectFromRBAP(ComboBox: TComboBox): Boolean;
var
  TPRBI: TParamRBookInterface;
  Table,Rbook: String;
  Value: String;
begin
  Result:=false;
  Table:=GetTableNameByControl(ComboBox);
  Rbook:=GetRBookNameByControl(ComboBox);
  if Trim(Table)<>'' then begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tvibvModal;
    TPRBI.Locate.KeyFields:=PChar(Table+'_ID');
    if ComboBox.ItemIndex<>-1 then
      TPRBI.Locate.KeyValues:=Integer(ComboBox.Items.Objects[ComboBox.ItemIndex]);
    TPRBI.Locate.Options:=[loCaseInsensitive];
    if _ViewInterfaceFromName(PChar(Rbook),@TPRBI) then begin
      ChangeFlag:=true;
      Value:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
      FillRBAP(Table,'NAME',ComboBox.Items,GetEmptyByControl(ComboBox));
      ComboBox.ItemIndex:=ComboBox.Items.IndexOf(Value);
      Result:=true;
    end;
  end;
end;

procedure TfmEditRBAPPremises.InitFilter;
var
  i,j: Integer;
  Filter: TtsvDbFilterItem;
  List: TList;
  Control: TControl;
  First: Boolean;
begin
  TypeEditRBook:=terbFilter;
  InitForAll;
  VisibleForFilter(true);
  with TfmRBAPPremises(ParentForm) do begin
    cbInString.Checked:=Filters.FilterInside;
    List:=TList.Create;
    try
      for i:=0 to Filters.Count-1 do begin
        Filter:=Filters.Items[i];
        GetControlsByHint(Filter.Caption,List);
        First:=false;
        for j:=0 to List.Count-1 do begin
          Control:=TControl(List.Items[j]);
          if Control is TWinControl then begin
            if Control is TEdit then begin
              TEdit(Control).Text:=VarToStr(Filter.Value);
              if Control=edPrice then
                cmbPriceCondition.ItemIndex:=Integer(Filter.TypeCondition);
            end;  
            if Control is TComboBox then
              TComboBox(Control).Text:=VarToStr(Filter.Value);
            if Control is TDateTimePicker then begin
              if First then begin
                if Filter.Enabled2 then
                  TDateTimePicker(Control).Date:=VarToDateTime(Filter.Value2);
              end;
              if not First then begin
                if Filter.Enabled then
                  TDateTimePicker(Control).Date:=VarToDateTime(Filter.Value);
                First:=true;
              end;
            end;  
          end;
        end;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TfmEditRBAPPremises.DoneFilter;
var
  i,j: Integer;
  Filter: TtsvDbFilterItem;
  List: TList;
  Control: TControl;
  First: Boolean;
begin
  with TfmRBAPPremises(ParentForm) do begin
    Filters.FilterInside:=cbInString.Checked;
    List:=TList.Create;
    try
      for i:=0 to Filters.Count-1 do begin
        Filter:=Filters.Items[i];
        GetControlsByHint(Filter.Caption,List);
        First:=false;
        for j:=0 to List.Count-1 do begin
          Control:=TControl(List.Items[j]);
          if Control is TWinControl then begin
            if Control is TEdit then begin
              Filter.Value:=Trim(TEdit(Control).Text);
              Filter.Enabled:=Trim(TEdit(Control).Text)<>'';
              if Control=edPrice then
                Filter.TypeCondition:=TTypeDbCondition(cmbPriceCondition.ItemIndex);
            end;
            if Control is TComboBox then begin
              Filter.Value:=Trim(TComboBox(Control).Text);
              Filter.Enabled:=Trim(TComboBox(Control).Text)<>'';
            end;
            if Control is TDateTimePicker then begin
              if First then begin
                Filter.Value2:=DateToStr(TDateTimePicker(Control).Date);
                Filter.Enabled2:=TDateTimePicker(Control).Checked;
              end;
              if not First then begin
                Filter.Value:=DateToStr(TDateTimePicker(Control).Date);
                Filter.Enabled:=TDateTimePicker(Control).Checked;
                First:=true;
              end;
            end;  
          end;
        end;
      end;
    finally
      List.Free;
    end;
  end;
end;

procedure TfmEditRBAPPremises.bibClearClick(Sender: TObject);
var
  Id: Integer;
  S: String;
  Index: Integer;
begin
  S:=edOperation.Text;
  Id:=edOperation.Tag;
  Index:=cmbPriceCondition.ItemIndex;
  try
    inherited;
  finally
    cmbPriceCondition.ItemIndex:=Index;
    edOperation.Text:=S;
    edOperation.Tag:=Id;
  end;
end;

procedure TfmEditRBAPPremises.btReleaseClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='RELEASE_ID';
  TPRBI.Locate.KeyValues:=edRelease.Tag;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRelease,@TPRBI) then begin
   ChangeFlag:=true;
   edRelease.Tag:=GetFirstValueFromParamRBookInterface(@TPRBI,'RELEASE_ID');
   edRelease.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'ABOUT');
  end;
end;

procedure TfmEditRBAPPremises.edReleaseKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edRelease.Text)=Length(edRelease.SelText) then begin
      edRelease.Text:='';
      edRelease.Tag:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBAPPremises.cmbRegionChange(Sender: TObject);
var
  RegionValue: Variant;
  Where: String;
begin
  ChangeFlag:=true;
  RegionValue:=GetValueByComboEx(cmbRegion);
  if not VarIsNull(RegionValue) then begin
    Where:=Format('AP_STREET_ID IN (SELECT AP_STREET_ID FROM AP_REGION_STREET WHERE AP_REGION_ID=%s)',[VarToStr(RegionValue)]);
    FillRBAP(GetTableNameByControl(cmbStreet),'NAME',cmbStreet.Items,GetEmptyByControl(cmbStreet),Where);
  end else begin
    cmbStreet.Clear;
  end;
end;

end.
