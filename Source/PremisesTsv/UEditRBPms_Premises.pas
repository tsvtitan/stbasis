unit UEditRBPms_Premises;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, tsvStdCtrls, tsvComCtrls, ImgList;

type
  TTypeOperation=(toSale,toLease,toShare,toLand);

  TfmEditRBPms_Premises = class(TfmEditRB)
    lbDateArrivalsFrom: TLabel;
    lbTo: TLabel;
    dtpDateArrivalsFrom: TDateTimePicker;
    dtpDateArrivalsTo: TDateTimePicker;
    btPeriod: TButton;
    lbRecyled: TLabel;
    cmbRecyled: TComboBox;
    iL: TImageList;
    lbFloor: TLabel;
    edFloor: TEdit;
    lbCountFloor: TLabel;
    edCountFloor: TEdit;
    lbTypeHouse: TLabel;
    cmbTypeHouse: TComboBox;
    lbHouse: TLabel;
    bvHouse: TBevel;
    lbContact1: TLabel;
    lbClientInfo: TLabel;
    lbDelim1: TLabel;
    lbDelim2: TLabel;
    lbContact2: TLabel;
    lbContact3: TLabel;
    lbDelim3: TLabel;
    lbContact4: TLabel;
    lbDelim4: TLabel;
    edContact1: TEdit;
    edContact2: TEdit;
    edContact3: TEdit;
    edContact4: TEdit;
    lbContact: TLabel;
    Bevel1: TBevel;
    lbRegion: TLabel;
    lbStreet: TLabel;
    lbHouseNumber: TLabel;
    lbApartmentNumber: TLabel;
    cmbRegion: TComboBox;
    cmbStreet: TComboBox;
    edHouseNumber: TEdit;
    edApartmentNumber: TEdit;
    lbAddress: TLabel;
    Bevel2: TBevel;
    lbCountRoom: TLabel;
    lbTypeRoom: TLabel;
    lbPlanning: TLabel;
    lbGeneralArea: TLabel;
    lbDwellingArea: TLabel;
    lbKitchenArea: TLabel;
    lbPhone: TLabel;
    lbBalcony: TLabel;
    lbSanitaryNode: TLabel;
    lbCondition: TLabel;
    lbStove: TLabel;
    lbFurniture: TLabel;
    lbDoor: TLabel;
    lbTerm: TLabel;
    lbPayment: TLabel;
    lbPrice: TLabel;
    lbDocument: TLabel;
    lbSaleStatus: TLabel;
    lbSelfForm: TLabel;
    lbTypePremises: TLabel;
    cmbCountRoom: TComboBox;
    cmbTypeRoom: TComboBox;
    cmbPlanning: TComboBox;
    edGeneralArea: TEdit;
    edDwellingArea: TEdit;
    edKitchenArea: TEdit;
    cmbPhone: TComboBox;
    cmbBalcony: TComboBox;
    cmbSanitaryNode: TComboBox;
    cmbCondition: TComboBox;
    cmbStove: TComboBox;
    cmbFurniture: TComboBox;
    cmbDoor: TComboBox;
    edTerm: TEdit;
    edPayment: TEdit;
    edPrice: TEdit;
    cmbDocument: TComboBox;
    btPlanning: TButton;
    cmbSaleStatus: TComboBox;
    cmbSelfForm: TComboBox;
    cmbTypePremises: TComboBox;
    cmbPricePlus: TComboBox;
    cmbUnitPrice: TComboBox;
    lbApartment: TLabel;
    Bevel3: TBevel;
    lbNote: TLabel;
    edNote: TEdit;
    lbStation: TLabel;
    cmbStation: TComboBox;
    lbAgent: TLabel;
    cmbAgent: TComboBox;
    lbAdditional: TLabel;
    Bevel4: TBevel;
    lbNN: TLabel;
    edNN: TEdit;
    lbGroundArea: TLabel;
    edGroundArea: TEdit;
    lbWater: TLabel;
    cmbWater: TComboBox;
    lbHeat: TLabel;
    cmbHeat: TComboBox;
    lbStyle: TLabel;
    cmbStyle: TComboBox;
    lbBuilder: TLabel;
    cmbBuilder: TComboBox;
    lbDelivery: TLabel;
    edDelivery: TEdit;
    lbBlockSection: TLabel;
    edBlockSection: TEdit;
    lbDecoration: TLabel;
    edDecoration: TEdit;
    lbGlassy: TLabel;
    edGlassy: TEdit;
    lbPrice2: TLabel;
    edPrice2: TEdit;
    bibAdvertisment: TButton;
    cmbCityRegion: TComboBox;
    lbCityRegion: TLabel;
    edAdvertismentNote: TEdit;
    Label1: TLabel;
    cbAdverisment: TCheckBox;
    ComboBoxClientInfo: TComboBox;
    lbTaxes: TLabel;
    cmbTaxes: TComboBox;
    cmbPopulatedPoint: TComboBox;
    cmbLandFeature: TComboBox;
    cmbExchangeFormula: TComboBox;
    cmbLocationStatus: TComboBox;
    edCommunications_: TEdit;
    edEmail: TEdit;
    cbLeaseOrSale: TComboBox;
    lbEmail: TLabel;
    lbCommunications: TLabel;
    lbAreaBuilding: TLabel;
    lbPopulatedPoint: TLabel;
    lbLandFeature: TLabel;
    lbExchangeFormula: TLabel;
    lbLandMark: TLabel;
    lbLocationStatus: TLabel;
    lbLeaseOrSale: TLabel;
    lbContact_1: TLabel;
    lbClientInfo_: TLabel;
    lbDelim_1: TLabel;
    lbDelim_2: TLabel;
    lbContact_2: TLabel;
    lbContact_3: TLabel;
    lbDelim_3: TLabel;
    lbContact_4: TLabel;
    Label10: TLabel;
    edContact_1: TEdit;
    edContact_2: TEdit;
    edContact_3: TEdit;
    edContact_4: TEdit;
    ComboBoxClientInfo_: TComboBox;
    lbContact_: TLabel;
    Bevel5: TBevel;
    Label2: TLabel;
    lbEmail_: TLabel;
    edEmail_: TEdit;
    ed1: TComboBox;
    ed2: TComboBox;
    ed4: TComboBox;
    ed3: TComboBox;
    ed_1: TComboBox;
    ed_2: TComboBox;
    ed_3: TComboBox;
    ed_4: TComboBox;
    lbObject: TLabel;
    cmbObject: TComboBox;
    lbDirection: TLabel;
    cmbDirection: TComboBox;
    lbRemoteness: TLabel;
    lbAccessWays: TLabel;
    cmbAccessWays: TComboBox;
    edRemoteness: TEdit;
    edLandMark: TEdit;
    edAreaBuilding: TEdit;
    edCommunications: TComboBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btPeriodClick(Sender: TObject);
    procedure edContact1Change(Sender: TObject);
    procedure dtpDateArrivalsFromChange(Sender: TObject);
    procedure cmbStreetEnter(Sender: TObject);
    procedure cmbStreetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbStreetKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edContact1Exit(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure edPriceKeyPress(Sender: TObject; var Key: Char);
    procedure edContact1KeyPress(Sender: TObject; var Key: Char);
    procedure cmbRecyledDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btPlanningClick(Sender: TObject);
    procedure cmbRecyledChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edContact1Enter(Sender: TObject);
    procedure edContact1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPrice2Change(Sender: TObject);
    procedure bibAdvertismentClick(Sender: TObject);
    procedure cmbRegionChange(Sender: TObject);
    procedure ComboBoxClientInfoChange(Sender: TObject);
    procedure cmbStationChange(Sender: TObject);
    procedure ComboBoxClientInfo_Change(Sender: TObject);
 

  private
    isDelete: Boolean;
    isInsert: Boolean;
    isUpdate: Boolean;

    CurrentIndex: Integer;

    WhoInsertedEx, WhoInsertedNameEx, DateTimeInsertedEx: Variant;
    FTypeOperation: TTypeOperation;
    FNewRecyled: Integer;
    FOldRecyled: Integer;
    procedure SetTypeOperation(Value: TTypeOperation);
    procedure SetoldRecyled(Value: Integer);
    procedure CheckOther(Control: TControl);
    function GetSyncOfficeId(pms_agent_id: Integer): Integer;

  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function GetTabOrdersName: string; override;
  public
    fmParent: TForm;
    oldPms_Premises_id: Variant;
    oldpms_agent_id: Integer;
    isEdit,isView:boolean;

    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    procedure FillRegion;
    procedure FillCityRegion;
    procedure FillStreet;
    procedure FillBalcony;
    procedure FillCondition;
    procedure FillSanitaryNode;
    procedure FillWater;
    procedure FillBuilder;
    procedure FillInvestor;
    procedure FillStyle;
    procedure FillHeat;
    procedure FillAgent(All: Boolean; SyncOfficeId: Integer);
    procedure FillDoor;
    procedure FillPhone;
    procedure FillCountRoom;
    procedure FillTypeRoom;
    procedure FillPlanning;
    procedure FillStation;
    procedure FillTypeHouse;
    procedure FillStove;
    procedure FillFurniture;
    //byBart
    procedure FillTaxes;
   // procedure FillAreaBuilding;
    procedure FillPopulatedPoint;
    procedure FillLandFeature;
    procedure FillExchangeFormula;
    procedure FillLocationStatus;
//    procedure FillLandMark;
    procedure FillObject;
    procedure FillDirection;
    procedure FillAccessWays;

    //--------
    procedure FillDocument;
    procedure FillSaleStatus;
    procedure FillSelfForm;
    procedure FillTypePremises;
    procedure FillUnitPrice;
    procedure SetContact(Value: string);
    function GetContact: string;
    procedure SetContact2(Value: string);
    function GetContact2: string;
    procedure SetEnabledFilter(Value: Boolean);

    property TypeOperation: TTypeOperation read FTypeOperation write SetTypeOperation;
    property oldRecyled: Integer read FoldRecyled write SetoldRecyled;
  end;

var
  fmEditRBPms_Premises: TfmEditRBPms_Premises;

implementation

uses Math,
     UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Premises,
     UPremisesTsvOptions, StbasisSUtils, UAdvertisment_in_Premises;

{$R *.DFM}

procedure TfmEditRBPms_Premises.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Premises.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  T: TInfoConnectUser;
  dt: TDateTime;

  pms_typehouse_id: string;
  pms_stove_id: string;
  pms_street_id: string;
  whoinsert_id,whoupdate_id: string;
  pms_agent_id: string;
  pms_door_id,pms_balcony_id: string;
  pms_sanitarynode_id,pms_condition_id: string;
  pms_water_id,pms_style_id,pms_heat_id,pms_builder_id: string;
  pms_furniture_id,pms_station_id: string;
  //byBart
  pms_taxes_id: string;
  {pms_areabuilding_id,}pms_populatedpoint_id,pms_landfeature_id,pms_exchangeformula_id,
  pms_locationstatus_id{,pms_landmark_id}:string;

  pms_object_id,pms_direction_id,pms_accessways_id:string;

  //---------
  pms_planning_id,pms_typeroom_id: string;
  pms_countroom_id,pms_region_id,pms_city_region_id: string;
  pms_phone_id,pms_document_id: string;
  pms_salestatus_id,pms_selfform_id,pms_typepremises_id: string;
  pms_UnitPrice_id: string;
  sync_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    FillChar(T,SizeOf(T),0);
    _GetInfoConnectUser(@T);
    whoinsert_id:=inttostr(T.User_id);
    whoupdate_id:=whoinsert_id;

    dt:=_GetDateTimeFromServer;

    cmbTypeHouse.ItemIndex:=cmbTypeHouse.Items.IndexOf(cmbTypeHouse.Text);
    if (cmbTypeHouse.ItemIndex<>-1)and(cmbTypeHouse.ItemIndex<>0) then begin
      pms_typehouse_id:=Inttostr(Integer(cmbTypeHouse.Items.Objects[cmbTypeHouse.ItemIndex]));
    end else pms_typehouse_id:='null';

    cmbStove.ItemIndex:=cmbStove.Items.IndexOf(cmbStove.Text);
    if (cmbStove.ItemIndex<>-1)and(cmbStove.ItemIndex<>0) then begin
      pms_Stove_id:=Inttostr(Integer(cmbStove.Items.Objects[cmbStove.ItemIndex]));
    end else pms_Stove_id:='null';

    cmbStreet.ItemIndex:=cmbStreet.Items.IndexOf(cmbStreet.Text);
    if (cmbStreet.ItemIndex<>-1) then begin
      pms_Street_id:=Inttostr(Integer(cmbStreet.Items.Objects[cmbStreet.ItemIndex]));
    end else pms_Street_id:='null';

    cmbAgent.ItemIndex:=cmbAgent.Items.IndexOf(cmbAgent.Text);
    if (cmbAgent.ItemIndex<>-1) then begin
      pms_Agent_id:=Inttostr(Integer(cmbAgent.Items.Objects[cmbAgent.ItemIndex]));
    end else pms_Agent_id:='null';

    cmbDoor.ItemIndex:=cmbDoor.Items.IndexOf(cmbDoor.Text);
    if (cmbDoor.ItemIndex<>-1)and(cmbDoor.ItemIndex<>0) then begin
      pms_Door_id:=Inttostr(Integer(cmbDoor.Items.Objects[cmbDoor.ItemIndex]));
    end else pms_Door_id:='null';

    cmbSanitaryNode.ItemIndex:=cmbSanitaryNode.Items.IndexOf(cmbSanitaryNode.Text);
    if (cmbSanitaryNode.ItemIndex<>-1)and(cmbSanitaryNode.ItemIndex<>0) then begin
      pms_SanitaryNode_id:=Inttostr(Integer(cmbSanitaryNode.Items.Objects[cmbSanitaryNode.ItemIndex]));
    end else pms_SanitaryNode_id:='null';

    cmbHeat.ItemIndex:=cmbHeat.Items.IndexOf(cmbHeat.Text);
    if (cmbHeat.ItemIndex<>-1)and(cmbHeat.ItemIndex<>0) then begin
      pms_Heat_id:=Inttostr(Integer(cmbHeat.Items.Objects[cmbHeat.ItemIndex]));
    end else pms_Heat_id:='null';

    cmbWater.ItemIndex:=cmbWater.Items.IndexOf(cmbWater.Text);
    if (cmbWater.ItemIndex<>-1)and(cmbWater.ItemIndex<>0) then begin
      pms_Water_id:=Inttostr(Integer(cmbWater.Items.Objects[cmbWater.ItemIndex]));
    end else pms_Water_id:='null';

    cmbBuilder.ItemIndex:=cmbBuilder.Items.IndexOf(cmbBuilder.Text);
    if (cmbBuilder.ItemIndex<>-1)and(cmbBuilder.ItemIndex<>0) then begin
      pms_Builder_id:=Inttostr(Integer(cmbBuilder.Items.Objects[cmbBuilder.ItemIndex]));
    end else pms_Builder_id:='null';

    cmbStyle.ItemIndex:=cmbStyle.Items.IndexOf(cmbStyle.Text);
    if (cmbStyle.ItemIndex<>-1)and(cmbStyle.ItemIndex<>0) then begin
      pms_Style_id:=Inttostr(Integer(cmbStyle.Items.Objects[cmbStyle.ItemIndex]));
    end else pms_Style_id:='null';

    cmbCondition.ItemIndex:=cmbCondition.Items.IndexOf(cmbCondition.Text);
    if (cmbCondition.ItemIndex<>-1)and(cmbCondition.ItemIndex<>0) then begin
      pms_Condition_id:=Inttostr(Integer(cmbCondition.Items.Objects[cmbCondition.ItemIndex]));
    end else pms_Condition_id:='null';

    cmbBalcony.ItemIndex:=cmbBalcony.Items.IndexOf(cmbBalcony.Text);
    if (cmbBalcony.ItemIndex<>-1)and(cmbBalcony.ItemIndex<>0) then begin
      pms_Balcony_id:=Inttostr(Integer(cmbBalcony.Items.Objects[cmbBalcony.ItemIndex]));
    end else pms_Balcony_id:='null';

    cmbFurniture.ItemIndex:=cmbFurniture.Items.IndexOf(cmbFurniture.Text);
    if (cmbFurniture.ItemIndex<>-1)and(cmbFurniture.ItemIndex<>0) then begin
      pms_Furniture_id:=Inttostr(Integer(cmbFurniture.Items.Objects[cmbFurniture.ItemIndex]));
    end else pms_Furniture_id:='null';

    //byBart
    cmbTaxes.ItemIndex:=cmbTaxes.Items.IndexOf(cmbTaxes.Text);
    if (cmbTaxes.ItemIndex<>-1) and(cmbTaxes.ItemIndex<>0) then begin
      pms_Taxes_id:=Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_Taxes_id:='null';


{    cmbAreaBuilding.ItemIndex:=cmbAreaBuilding.Items.IndexOf(cmbAreaBuilding.Text);
    if (cmbAreaBuilding.ItemIndex<>-1) and(cmbAreaBuilding.ItemIndex<>0) then begin
      pms_areabuilding_id:=Inttostr(Integer(cmbAreaBuilding.Items.Objects[cmbAreaBuilding.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_areabuilding_id:='null';
 }
    cmbPopulatedPoint.ItemIndex:=cmbPopulatedPoint.Items.IndexOf(cmbPopulatedPoint.Text);
    if (cmbPopulatedPoint.ItemIndex<>-1) and(cmbPopulatedPoint.ItemIndex<>0) then begin
      pms_PopulatedPoint_id:=Inttostr(Integer(cmbPopulatedPoint.Items.Objects[cmbPopulatedPoint.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_PopulatedPoint_id:='null';

    cmbLandFeature.ItemIndex:=cmbLandFeature.Items.IndexOf(cmbLandFeature.Text);
    if (cmbLandFeature.ItemIndex<>-1) and(cmbLandFeature.ItemIndex<>0) then begin
      pms_LandFeature_id:=Inttostr(Integer(cmbLandFeature.Items.Objects[cmbLandFeature.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_LandFeature_id:='null';

    cmbExchangeFormula.ItemIndex:=cmbExchangeFormula.Items.IndexOf(cmbExchangeFormula.Text);
    if (cmbExchangeFormula.ItemIndex<>-1) and(cmbExchangeFormula.ItemIndex<>0) then begin
      pms_ExchangeFormula_id:=Inttostr(Integer(cmbExchangeFormula.Items.Objects[cmbExchangeFormula.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_ExchangeFormula_id:='null';

    cmbLocationStatus.ItemIndex:=cmbLocationStatus.Items.IndexOf(cmbLocationStatus.Text);
    if (cmbLocationStatus.ItemIndex<>-1) and(cmbLocationStatus.ItemIndex<>0) then begin
      pms_LocationStatus_id:=Inttostr(Integer(cmbLocationStatus.Items.Objects[cmbLocationStatus.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_LocationStatus_id:='null';

{    cmbLandMark.ItemIndex:=cmbLandMark.Items.IndexOf(cmbLandMark.Text);
    if (cmbLandMark.ItemIndex<>-1) and(cmbLandMark.ItemIndex<>0) then begin
      pms_LandMark_id:=Inttostr(Integer(cmbLandMark.Items.Objects[cmbLandMark.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_LandMark_id:='null';
 }
    cmbObject.ItemIndex:=cmbObject.Items.IndexOf(cmbObject.Text);
    if (cmbObject.ItemIndex<>-1) and(cmbObject.ItemIndex<>0) then begin
      pms_Object_id:=Inttostr(Integer(cmbObject.Items.Objects[cmbObject.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_Object_id:='null';

    cmbDirection.ItemIndex:=cmbDirection.Items.IndexOf(cmbDirection.Text);
    if (cmbDirection.ItemIndex<>-1) and(cmbDirection.ItemIndex<>0) then begin
      pms_Direction_id:=Inttostr(Integer(cmbDirection.Items.Objects[cmbDirection.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_Direction_id:='null';

    cmbAccessWays.ItemIndex:=cmbAccessWays.Items.IndexOf(cmbAccessWays.Text);
    if (cmbAccessWays.ItemIndex<>-1) and(cmbAccessWays.ItemIndex<>0) then begin
      pms_AccessWays_id:=Inttostr(Integer(cmbAccessWays.Items.Objects[cmbAccessWays.ItemIndex]));
  //    showmessage(Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]))) ;
    end else pms_AccessWays_id:='null';

    //--------

    cmbStation.ItemIndex:=cmbStation.Items.IndexOf(cmbStation.Text);
    if (cmbStation.ItemIndex<>-1) then begin
      pms_Station_id:=Inttostr(Integer(cmbStation.Items.Objects[cmbStation.ItemIndex]));
    end else pms_Station_id:='null';

    cmbPlanning.ItemIndex:=cmbPlanning.Items.IndexOf(cmbPlanning.Text);
    if (cmbPlanning.ItemIndex<>-1)and(cmbPlanning.ItemIndex<>0) then begin
      pms_Planning_id:=Inttostr(Integer(cmbPlanning.Items.Objects[cmbPlanning.ItemIndex]));
    end else pms_Planning_id:='null';

    cmbTypeRoom.ItemIndex:=cmbTypeRoom.Items.IndexOf(cmbTypeRoom.Text);
    if (cmbTypeRoom.ItemIndex<>-1)and(cmbTypeRoom.ItemIndex<>0) then begin
      pms_TypeRoom_id:=Inttostr(Integer(cmbTypeRoom.Items.Objects[cmbTypeRoom.ItemIndex]));
    end else pms_TypeRoom_id:='null';

    cmbCountRoom.ItemIndex:=cmbCountRoom.Items.IndexOf(cmbCountRoom.Text);
    if (cmbCountRoom.ItemIndex<>-1) then begin
      pms_CountRoom_id:=Inttostr(Integer(cmbCountRoom.Items.Objects[cmbCountRoom.ItemIndex]));
    end else pms_CountRoom_id:='null';

    cmbRegion.ItemIndex:=cmbRegion.Items.IndexOf(cmbRegion.Text);
    if (cmbRegion.ItemIndex<>-1) then begin
      pms_Region_id:=Inttostr(Integer(cmbRegion.Items.Objects[cmbRegion.ItemIndex]));
    end else pms_Region_id:='null';

    cmbCityRegion.ItemIndex:=cmbCityRegion.Items.IndexOf(cmbCityRegion.Text);
    if (cmbCityRegion.ItemIndex<>-1) then begin
      pms_City_Region_id:=Inttostr(Integer(cmbCityRegion.Items.Objects[cmbCityRegion.ItemIndex]));
    end else pms_City_Region_id:='null';


    cmbPhone.ItemIndex:=cmbPhone.Items.IndexOf(cmbPhone.Text);
    if (cmbPhone.ItemIndex<>-1)and(cmbPhone.ItemIndex<>0) then begin
      pms_Phone_id:=Inttostr(Integer(cmbPhone.Items.Objects[cmbPhone.ItemIndex]));
    end else pms_Phone_id:='null';

    cmbDocument.ItemIndex:=cmbDocument.Items.IndexOf(cmbDocument.Text);
    if (cmbDocument.ItemIndex<>-1)and(cmbDocument.ItemIndex<>0) then begin
      pms_Document_id:=Inttostr(Integer(cmbDocument.Items.Objects[cmbDocument.ItemIndex]));
    end else pms_Document_id:='null';

    cmbSaleStatus.ItemIndex:=cmbSaleStatus.Items.IndexOf(cmbSaleStatus.Text);
    if (cmbSaleStatus.ItemIndex<>-1)and(cmbSaleStatus.ItemIndex<>0) then begin
      pms_SaleStatus_id:=Inttostr(Integer(cmbSaleStatus.Items.Objects[cmbSaleStatus.ItemIndex]));
    end else pms_SaleStatus_id:='null';

    cmbSelfForm.ItemIndex:=cmbSelfForm.Items.IndexOf(cmbSelfForm.Text);
    if (cmbSelfForm.ItemIndex<>-1)and(cmbSelfForm.ItemIndex<>0) then begin
      pms_SelfForm_id:=Inttostr(Integer(cmbSelfForm.Items.Objects[cmbSelfForm.ItemIndex]));
    end else pms_SelfForm_id:='null';

    cmbTypePremises.ItemIndex:=cmbTypePremises.Items.IndexOf(cmbTypePremises.Text);
    if (cmbTypePremises.ItemIndex<>-1)and(cmbTypePremises.ItemIndex<>0) then begin
      pms_TypePremises_id:=Inttostr(Integer(cmbTypePremises.Items.Objects[cmbTypePremises.ItemIndex]));
    end else pms_TypePremises_id:='null';

    cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(cmbUnitPrice.Text);
    if (cmbUnitPrice.ItemIndex<>-1)and(cmbUnitPrice.ItemIndex<>0) then begin
      pms_UnitPrice_id:=Inttostr(Integer(cmbUnitPrice.Items.Objects[cmbUnitPrice.ItemIndex]));
    end else pms_UnitPrice_id:='null';

    if trim(edPrice.Text)='' then begin
      pms_UnitPrice_id:='null';
    end;

    sync_id:=CreateUniqueId;

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbPms_Premises,1));
    sqls:='Insert into '+tbPms_Premises+
          ' (Pms_Premises_id,pms_typehouse_id,pms_stove_id,pms_street_id,whoinsert_id,pms_agent_id,'+
          'pms_door_id,pms_sanitarynode_id,pms_condition_id,whoupdate_id,pms_balcony_id,pms_furniture_id,pms_taxes_id, '+
          'datearrivals,pms_station_id,pms_planning_id,pms_typeroom_id,contact,clientinfo,contact2,clientinfo2,pms_countroom_id,'+
          'pms_region_id,pms_city_region_id,housenumber,apartmentnumber,pms_phone_id,floor,countfloor,generalarea,'+
          'pms_document_id,dwellingarea,kitchenarea,typeoperation,price,term,payment,note,datetimeinsert,'+
          'datetimeupdate,pms_salestatus_id,pms_selfform_id,pms_typepremises_id,pms_unitprice_id,recyled,'+
          'sync_id,nn,delivery,groundarea,pms_water_id,pms_style_id,pms_heat_id,pms_builder_id,'+
          'decoration,glassy,block_section,price2,advertisment_note,areabuilding,pms_populatedpoint_id,'+
          'pms_landfeature_id,pms_exchangeformula_id,pms_locationstatus_id,landmark,communications,email,email2,leaseorsale,'+
          'pms_object_id,pms_direction_id,pms_accessways_id,remoteness'+
          ') values '+
          ' ('+id+
          ','+pms_typehouse_id+
          ','+pms_Stove_id+
          ','+pms_Street_id+
          ','+whoinsert_id+
          ','+pms_Agent_id+
          ','+pms_door_id+
          ','+pms_sanitarynode_id+
          ','+pms_condition_id+
          ','+whoupdate_id+
          ','+pms_balcony_id+
          ','+pms_furniture_id+
          ','+pms_Taxes_id+
          ','+QuotedStr(DateToStr(dtpDateArrivalsFrom.Date))+
          ','+pms_station_id+
          ','+pms_planning_id+
          ','+pms_typeroom_id+
          ','+QuotedStr(GetContact)+
          ','+iff(Trim(ComboBoxClientInfo.Text)<>'',QuotedStr(Trim(ComboBoxClientInfo.Text)),'null')+
          ','+QuotedStr(GetContact2)+
          ','+iff(Trim(ComboBoxClientInfo_.Text)<>'',QuotedStr(Trim(ComboBoxClientInfo_.Text)),'null')+
          ','+pms_countroom_id+
          ','+pms_region_id+
          ','+pms_city_region_id+
          ','+iff(Trim(edHouseNumber.Text)<>'',QuotedStr(Trim(edHouseNumber.Text)),'null')+
          ','+iff(Trim(edApartmentNumber.Text)<>'',QuotedStr(Trim(edApartmentNumber.Text)),'null')+
          ','+pms_phone_id+
          ','+iff(Trim(edFloor.Text)<>'',QuotedStr(Trim(edFloor.Text)),'null')+
          ','+iff(Trim(edCountFloor.Text)<>'',Trim(edCountFloor.Text),'null')+
          ','+iff(trim(edGeneralArea.Text)<>'',QuotedStr(ChangeChar(edGeneralArea.Text,',','.')),'null')+
          ','+pms_document_id+
          ','+iff(Trim(edDwellingArea.Text)<>'',QuotedStr(ChangeChar(edDwellingArea.Text,',','.')),'null')+
          ','+iff(trim(edKitchenArea.Text)<>'',QuotedStr(ChangeChar(edKitchenArea.Text,',','.')),'null')+
          ','+IntTostr(Integer(FTypeOperation))+
          ','+iff(trim(edPrice.Text)<>'',QuotedStr(ChangeChar(edPrice.Text,',','.')),'null')+
          ','+iff(Trim(edTerm.Text)<>'',QuotedStr(Trim(edTerm.Text)),'null')+
          ','+iff(Trim(edPayment.Text)<>'',QuotedStr(Trim(edPayment.Text)),'null')+
          ','+iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.Text)),'null')+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+pms_salestatus_id+
          ','+pms_selfform_id+
          ','+pms_typepremises_id+
          ','+pms_unitprice_id+
          ','+inttostr(cmbRecyled.ItemIndex)+
          ','+QuotedStr(Sync_id)+
          ','+iff(Trim(edNN.Text)<>'',QuotedStr(Trim(edNN.Text)),'null')+
          ','+iff(Trim(edDelivery.Text)<>'',QuotedStr(Trim(edDelivery.Text)),'null')+
          ','+iff(Trim(edGroundArea.Text)<>'',QuotedStr(ChangeChar(edGroundArea.Text,',','.')),'null')+
          ','+pms_water_id+
          ','+pms_style_id+
          ','+pms_heat_id+
          ','+pms_builder_id+
          ','+iff(Trim(edDecoration.Text)<>'',QuotedStr(Trim(edDecoration.Text)),'null')+
          ','+iff(Trim(edGlassy.Text)<>'',QuotedStr(Trim(edGlassy.Text)),'null')+
          ','+iff(Trim(edBlockSection.Text)<>'',QuotedStr(Trim(edBlockSection.Text)),'null')+
          ','+iff(trim(edPrice2.Text)<>'',QuotedStr(ChangeChar(edPrice2.Text,',','.')),'null')+
          ','+iff(Trim(edAdvertismentNote.Text)<>'',QuotedStr(Trim(edAdvertismentNote.Text)),'null')+
          ','+iff(Trim(edAreaBuilding.Text)<>'',QuotedStr(Trim(edAreaBuilding.Text)),'null')+
          //','+pms_areabuilding_id+
          ','+pms_populatedpoint_id+
          ','+pms_landfeature_id+
          ','+pms_exchangeformula_id+
          ','+pms_locationstatus_id+
          ','+iff(Trim(edLandMark.Text)<>'',QuotedStr(Trim(edLandMark.Text)),'null')+
       //   ','+pms_landmark_id+
          ','+iff(Trim(edCommunications.Text)<>'',QuotedStr(Trim(edCommunications.Text)),'null')+
          ','+iff(trim(edEmail.Text)<>'',QuotedStr(Trim(edEmail.Text)),'null')+
          ','+iff(trim(edEmail_.Text)<>'',QuotedStr(Trim(edEmail_.Text)),'null')+
          ','+iff(Trim(cbLeaseOrSale.Text)<>'',QuotedStr(Trim(cbLeaseOrSale.Text)),'null')+
          ','+pms_object_id+
          ','+pms_direction_id+
          ','+pms_accessways_id+
          ','+iff(Trim(edRemoteness.Text)<>'',QuotedStr(Trim(edRemoteness.Text)),'null')+
          ')';

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Premises_id:=strtoint(id);
    oldpms_agent_id:=StrToInt(pms_agent_id);

    if oldRecyled=cmbRecyled.ItemIndex then begin
      TfmRBPms_Premises(fmParent).IBUpd.InsertSQL.Clear;
      TfmRBPms_Premises(fmParent).IBUpd.InsertSQL.Add(sqls);

      with TfmRBPms_Premises(fmParent).MainQr do begin
        Insert;
        FieldByName('Pms_Premises_id').AsInteger:=oldPms_Premises_id;
        FieldByName('pms_typehouse_id').Value:=Iff(AnsiSameText(pms_typehouse_id,'null'),NULL,pms_typehouse_id);
        FieldByName('pms_stove_id').Value:=Iff(AnsiSameText(pms_stove_id,'null'),NULL,pms_stove_id);
        FieldByName('pms_street_id').Value:=pms_street_id;
        FieldByName('whoinsert_id').Value:=whoinsert_id;
        FieldByName('pms_agent_id').Value:=oldpms_agent_id;
        FieldByName('sync_office_id').Value:=GetSyncOfficeId(oldpms_agent_id);
        FieldByName('pms_door_id').Value:=Iff(AnsiSameText(pms_door_id,'null'),NULL,pms_door_id);
        FieldByName('pms_sanitarynode_id').Value:=Iff(AnsiSameText(pms_sanitarynode_id,'null'),NULL,pms_sanitarynode_id);
        FieldByName('pms_condition_id').Value:=Iff(AnsiSameText(pms_condition_id,'null'),NULL,pms_condition_id);
        FieldByName('whoupdate_id').Value:=whoupdate_id;
        FieldByName('pms_balcony_id').Value:=Iff(AnsiSameText(pms_balcony_id,'null'),NULL,pms_balcony_id);
        FieldByName('pms_furniture_id').Value:=Iff(AnsiSameText(pms_furniture_id,'null'),NULL,pms_furniture_id);
        FieldByName('taxes').Value:=iff(Trim(cmbTaxes.Text)<>'',Trim(cmbTaxes.Text),Null);
        FieldByName('datearrivals').Value:=dtpDateArrivalsFrom.Date;
        FieldByName('pms_station_id').Value:=Iff(AnsiSameText(pms_station_id,'null'),NULL,pms_station_id);
        FieldByName('pms_planning_id').Value:=Iff(AnsiSameText(pms_planning_id,'null'),NULL,pms_planning_id);
        FieldByName('pms_typeroom_id').Value:=Iff(AnsiSameText(pms_typeroom_id,'null'),NULL,pms_typeroom_id);
        FieldByName('contact').Value:=GetContact;
        FieldByName('clientinfo').Value:=iff(Trim(ComboBoxClientInfo.Text)<>'',Trim(ComboBoxClientInfo.Text),Null);
        FieldByName('contact2').Value:=GetContact;
        FieldByName('clientinfo2').Value:=iff(Trim(ComboBoxClientInfo.Text)<>'',Trim(ComboBoxClientInfo.Text),Null);
        FieldByName('pms_countroom_id').Value:=Iff(AnsiSameText(pms_countroom_id,'null'),NULL,pms_countroom_id);;
        FieldByName('pms_region_id').Value:=pms_region_id;
        FieldByName('pms_city_region_id').Value:=Iff(AnsiSameText(pms_city_region_id,'null'),NULL,pms_city_region_id);
        FieldByName('housenumber').Value:=iff(Trim(edHouseNumber.Text)<>'',Trim(edHouseNumber.Text),Null);
        FieldByName('apartmentnumber').Value:=iff(Trim(edApartmentNumber.Text)<>'',Trim(edApartmentNumber.Text),Null);
        FieldByName('pms_phone_id').Value:=Iff(AnsiSameText(pms_phone_id,'null'),NULL,pms_phone_id);
        FieldByName('floor').Value:=iff(Trim(edFloor.Text)<>'',Trim(edFloor.Text),Null);
        FieldByName('countfloor').Value:=iff(Trim(edCountFloor.Text)<>'',Trim(edCountFloor.Text),Null);
        FieldByName('generalarea').Value:=iff(trim(edGeneralArea.Text)<>'',edGeneralArea.Text,Null);
        FieldByName('groundArea').Value:=iff(trim(edgroundArea.Text)<>'',edgroundArea.Text,Null);
        FieldByName('pms_document_id').Value:=Iff(AnsiSameText(pms_document_id,'null'),NULL,pms_document_id);
        FieldByName('dwellingarea').Value:=iff(trim(edDwellingArea.Text)<>'',edDwellingArea.Text,Null);
        FieldByName('kitchenarea').Value:=iff(trim(edKitchenArea.Text)<>'',edKitchenArea.Text,Null);
        FieldByName('typeoperation').Value:=Integer(FTypeOperation);
        FieldByName('price').Value:=iff(trim(edPrice.Text)<>'',edPrice.Text,Null);
        FieldByName('term').Value:=iff(Trim(edTerm.Text)<>'',Trim(edTerm.Text),Null);
        FieldByName('payment').Value:=iff(Trim(edPayment.Text)<>'',Trim(edPayment.Text),Null);
        FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',Trim(edNote.Text),Null);
        FieldByName('datetimeinsert').Value:=DateTimeToStr(dt);
        FieldByName('datetimeupdate').Value:=DateTimeToStr(dt);
        FieldByName('pms_salestatus_id').Value:=Iff(AnsiSameText(pms_salestatus_id,'null'),NULL,pms_salestatus_id);
        FieldByName('pms_selfform_id').Value:=Iff(AnsiSameText(pms_selfform_id,'null'),NULL,pms_selfform_id);
        FieldByName('pms_typepremises_id').Value:=Iff(AnsiSameText(pms_typepremises_id,'null'),NULL,pms_typepremises_id);
        FieldByName('pms_UnitPrice_id').Value:=Iff(AnsiSameText(pms_UnitPrice_id,'null'),NULL,pms_UnitPrice_id);
        FieldByName('recyled').Value:=inttostr(cmbRecyled.ItemIndex);
        FieldByName('regionname').Value:=iff(Trim(cmbRegion.Text)<>'',Trim(cmbRegion.Text),Null);
        FieldByName('cityregionname').Value:=iff(Trim(cmbCityRegion.Text)<>'',Trim(cmbCityRegion.Text),Null);
        FieldByName('streetname').Value:=iff(Trim(cmbStreet.Text)<>'',Trim(cmbStreet.Text),Null);
        FieldByName('countroomname').Value:=iff(Trim(cmbCountRoom.Text)<>'',Trim(cmbCountRoom.Text),Null);
        FieldByName('whoinsertname').AsString:=T.UserName;
        FieldByName('whoupdatename').AsString:=T.UserName;
        FieldByName('agentname').Value:=iff(Trim(cmbAgent.Text)<>'',Trim(cmbAgent.Text),Null);
        FieldByName('balconyname').Value:=iff(Trim(cmbBalcony.Text)<>'',Trim(cmbBalcony.Text),Null);
        FieldByName('conditionname').Value:=iff(Trim(cmbCondition.Text)<>'',Trim(cmbCondition.Text),Null);
        FieldByName('sanitarynodename').Value:=iff(Trim(cmbSanitaryNode.Text)<>'',Trim(cmbSanitaryNode.Text),Null);
        FieldByName('doorname').Value:=iff(Trim(cmbDoor.Text)<>'',Trim(cmbDoor.Text),Null);
        FieldByName('typeroomname').Value:=iff(Trim(cmbTypeRoom.Text)<>'',Trim(cmbTypeRoom.Text),Null);
        FieldByName('planningname').Value:=iff(Trim(cmbPlanning.Text)<>'',Trim(cmbPlanning.Text),Null);
        FieldByName('stationname').Value:=iff(Trim(cmbStation.Text)<>'',Trim(cmbStation.Text),Null);
        FieldByName('typehousename').Value:=iff(Trim(cmbTypeHouse.Text)<>'',Trim(cmbTypeHouse.Text),Null);
        FieldByName('stovename').Value:=iff(Trim(cmbStove.Text)<>'',Trim(cmbStove.Text),Null);
        FieldByName('furniturename').Value:=iff(Trim(cmbFurniture.Text)<>'',Trim(cmbFurniture.Text),Null);
        FieldByName('phonename').Value:=iff(Trim(cmbPhone.Text)<>'',Trim(cmbPhone.Text),Null);
        FieldByName('documentname').Value:=iff(Trim(cmbDocument.Text)<>'',Trim(cmbDocument.Text),Null);
        FieldByName('SaleStatusname').Value:=iff(Trim(cmbSaleStatus.Text)<>'',Trim(cmbSaleStatus.Text),Null);
        FieldByName('SelfFormname').Value:=iff(Trim(cmbSelfForm.Text)<>'',Trim(cmbSelfForm.Text),Null);
        FieldByName('TypePremisesname').Value:=iff(Trim(cmbTypePremises.Text)<>'',Trim(cmbTypePremises.Text),Null);
        FieldByName('UnitPricename').Value:=iff(Trim(cmbUnitPrice.Text)<>'',iff(trim(edPrice.Text)<>'',Trim(cmbUnitPrice.Text),Null),Null);
        FieldByName('sync_id').Value:=sync_id;
        FieldByName('nn').Value:=iff(trim(edNN.Text)<>'',edNN.Text,Null);
        FieldByName('delivery').Value:=iff(trim(edDelivery.Text)<>'',edDelivery.Text,Null);
        FieldByName('Heatname').Value:=iff(Trim(cmbHeat.Text)<>'',Trim(cmbHeat.Text),Null);
        FieldByName('pms_Heat_id').Value:=Iff(AnsiSameText(pms_Heat_id,'null'),NULL,pms_Heat_id);
        FieldByName('Watername').Value:=iff(Trim(cmbWater.Text)<>'',Trim(cmbWater.Text),Null);
        FieldByName('pms_Water_id').Value:=Iff(AnsiSameText(pms_Water_id,'null'),NULL,pms_Water_id);
        FieldByName('Buildername').Value:=iff(Trim(cmbBuilder.Text)<>'',Trim(cmbBuilder.Text),Null);
        FieldByName('pms_Builder_id').Value:=Iff(AnsiSameText(pms_Builder_id,'null'),NULL,pms_Builder_id);
        FieldByName('Stylename').Value:=iff(Trim(cmbStyle.Text)<>'',Trim(cmbStyle.Text),Null);
        FieldByName('pms_Style_id').Value:=Iff(AnsiSameText(pms_Style_id,'null'),NULL,pms_Style_id);
        FieldByName('decoration').Value:=iff(Trim(edDecoration.Text)<>'',Trim(edDecoration.Text),Null);
        FieldByName('glassy').Value:=iff(Trim(edGlassy.Text)<>'',Trim(edGlassy.Text),Null);
        FieldByName('block_section').Value:=iff(Trim(edBlockSection.Text)<>'',Trim(edBlockSection.Text),Null);
        FieldByName('price2').Value:=iff(trim(edPrice2.Text)<>'',edPrice2.Text,Null);
        FieldByName('advertisment_note').Value:=iff(Trim(edAdvertismentNote.Text)<>'',Trim(edAdvertismentNote.Text),Null);
        {}
        FieldByName('areabuilding').Value:=iff(Trim(edAreaBuilding.Text)<>'',Trim(edAreaBuilding.Text),Null);
        FieldByName('populatedpoint').Value:=iff(Trim(cmbPopulatedPoint.Text)<>'',Trim(cmbPopulatedPoint.Text),Null);
        FieldByName('landfeature').Value:=iff(Trim(cmbLandFeature.Text)<>'',Trim(cmbLandFeature.Text),Null);
        FieldByName('exchangeformula').Value:=iff(Trim(cmbExchangeFormula.Text)<>'',Trim(cmbExchangeFormula.Text),Null);
        FieldByName('locationstatus').Value:=iff(Trim(cmbLocationStatus.Text)<>'',Trim(cmbLocationStatus.Text),Null);
        FieldByName('landmark').Value:=iff(Trim(edLandMark.Text)<>'',Trim(edLandMark.Text),Null);
        FieldByName('object').Value:=iff(Trim(cmbObject.Text)<>'',Trim(cmbObject.Text),Null);
        FieldByName('direction').Value:=iff(Trim(cmbDirection.Text)<>'',Trim(cmbDirection.Text),Null);
        FieldByName('accessways').Value:=iff(Trim(cmbAccessWays.Text)<>'',Trim(cmbAccessWays.Text),Null);


        {}
       // FieldByName('pms_areabuilding_id').Value:=Iff(AnsiSameText(pms_areabuilding_id,'null'),NULL,pms_areabuilding_id);
        FieldByName('pms_populatedpoint_id').Value:=Iff(AnsiSameText(pms_populatedpoint_id,'null'),NULL,pms_populatedpoint_id);
        FieldByName('pms_landfeature_id').Value:=Iff(AnsiSameText(pms_landfeature_id,'null'),NULL,pms_landfeature_id);
        FieldByName('pms_exchangeformula_id').Value:=Iff(AnsiSameText(pms_exchangeformula_id,'null'),NULL,pms_exchangeformula_id);
        FieldByName('pms_locationstatus_id').Value:=Iff(AnsiSameText(pms_locationstatus_id,'null'),NULL,pms_locationstatus_id);
     //   FieldByName('pms_landmark_id').Value:=Iff(AnsiSameText(pms_landmark_id,'null'),NULL,pms_landmark_id);
        FieldByName('communications').Value:=iff(Trim(edCommunications.Text)<>'',Trim(edCommunications.Text),Null);
        FieldByName('email').Value:=iff(Trim(edEmail.Text)<>'',Trim(edEmail.Text),Null);
        FieldByName('email2').Value:=iff(Trim(edEmail_.Text)<>'',Trim(edEmail_.Text),Null);
        FieldByName('leaseorsale').Value:=iff(Trim(cbLeaseOrSale.Text)<>'',Trim(cbLeaseOrSale.Text),Null);

        FieldByName('pms_object_id').Value:=Iff(AnsiSameText(pms_object_id,'null'),NULL,pms_object_id);
        FieldByName('pms_direction_id').Value:=Iff(AnsiSameText(pms_direction_id,'null'),NULL,pms_direction_id);
        FieldByName('pms_accessways_id').Value:=Iff(AnsiSameText(pms_accessways_id,'null'),NULL,pms_accessways_id);
        FieldByName('remoteness').Value:=iff(Trim(edRemoteness.Text)<>'',Trim(edRemoteness.Text),Null);

        Post;
      end;
    end else begin
      //
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

procedure TfmEditRBPms_Premises.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Premises.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  b: TBookmark;

  T: TInfoConnectUser;
  dt: TDateTime;

  pms_typehouse_id: string;
  pms_stove_id: string;
  pms_street_id: string;
  whoupdate_id: string;
  pms_agent_id: string;
  pms_door_id,pms_balcony_id: string;
  pms_sanitarynode_id,pms_condition_id: string;
  pms_water_id,pms_style_id,pms_heat_id,pms_builder_id: string;
  pms_furniture_id,pms_station_id: string;
  //byBart
  pms_taxes_id: string;
 { pms_areabuilding_id,}pms_populatedpoint_id,pms_landfeature_id,pms_exchangeformula_id,
  pms_locationstatus_id{,pms_landmark_id}:string;

  pms_object_id,pms_direction_id,pms_accessways_id:string;

  //----
  pms_planning_id,pms_typeroom_id: string;
  pms_countroom_id,pms_region_id,pms_city_region_id: string;
  pms_phone_id,pms_document_id: string;
  pms_salestatus_id,pms_selfform_id,pms_typepremises_id: string;
  pms_UnitPrice_id: string;

  isLocate: Boolean;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    FillChar(T,SizeOf(T),0);
    _GetInfoConnectUser(@T);
    whoupdate_id:=inttostr(T.User_id);

    dt:=_GetDateTimeFromServer;

    cmbTypeHouse.ItemIndex:=cmbTypeHouse.Items.IndexOf(cmbTypeHouse.Text);
    if (cmbTypeHouse.ItemIndex<>-1)and(cmbTypeHouse.ItemIndex<>0) then begin
      pms_typehouse_id:=Inttostr(Integer(cmbTypeHouse.Items.Objects[cmbTypeHouse.ItemIndex]));
    end else pms_typehouse_id:='null';

    cmbStove.ItemIndex:=cmbStove.Items.IndexOf(cmbStove.Text);
    if (cmbStove.ItemIndex<>-1)and(cmbStove.ItemIndex<>0) then begin
      pms_Stove_id:=Inttostr(Integer(cmbStove.Items.Objects[cmbStove.ItemIndex]));
    end else pms_Stove_id:='null';

    cmbStreet.ItemIndex:=cmbStreet.Items.IndexOf(cmbStreet.Text);
    if (cmbStreet.ItemIndex<>-1) then begin
      pms_Street_id:=Inttostr(Integer(cmbStreet.Items.Objects[cmbStreet.ItemIndex]));
    end else pms_Street_id:='null';

    cmbAgent.ItemIndex:=cmbAgent.Items.IndexOf(cmbAgent.Text);
    if (cmbAgent.ItemIndex<>-1) then begin
      pms_Agent_id:=Inttostr(Integer(cmbAgent.Items.Objects[cmbAgent.ItemIndex]));
    end else pms_Agent_id:='null';

    cmbDoor.ItemIndex:=cmbDoor.Items.IndexOf(cmbDoor.Text);
    if (cmbDoor.ItemIndex<>-1)and(cmbDoor.ItemIndex<>0) then begin
      pms_Door_id:=Inttostr(Integer(cmbDoor.Items.Objects[cmbDoor.ItemIndex]));
    end else pms_Door_id:='null';

    cmbSanitaryNode.ItemIndex:=cmbSanitaryNode.Items.IndexOf(cmbSanitaryNode.Text);
    if (cmbSanitaryNode.ItemIndex<>-1)and(cmbSanitaryNode.ItemIndex<>0) then begin
      pms_SanitaryNode_id:=Inttostr(Integer(cmbSanitaryNode.Items.Objects[cmbSanitaryNode.ItemIndex]));
    end else pms_SanitaryNode_id:='null';

    cmbHeat.ItemIndex:=cmbHeat.Items.IndexOf(cmbHeat.Text);
    if (cmbHeat.ItemIndex<>-1)and(cmbHeat.ItemIndex<>0) then begin
      pms_Heat_id:=Inttostr(Integer(cmbHeat.Items.Objects[cmbHeat.ItemIndex]));
    end else pms_Heat_id:='null';

    cmbWater.ItemIndex:=cmbWater.Items.IndexOf(cmbWater.Text);
    if (cmbWater.ItemIndex<>-1)and(cmbWater.ItemIndex<>0) then begin
      pms_Water_id:=Inttostr(Integer(cmbWater.Items.Objects[cmbWater.ItemIndex]));
    end else pms_Water_id:='null';

    cmbBuilder.ItemIndex:=cmbBuilder.Items.IndexOf(cmbBuilder.Text);
    if (cmbBuilder.ItemIndex<>-1)and(cmbBuilder.ItemIndex<>0) then begin
      pms_Builder_id:=Inttostr(Integer(cmbBuilder.Items.Objects[cmbBuilder.ItemIndex]));
    end else pms_Builder_id:='null';

    cmbStyle.ItemIndex:=cmbStyle.Items.IndexOf(cmbStyle.Text);
    if (cmbStyle.ItemIndex<>-1)and(cmbStyle.ItemIndex<>0) then begin
      pms_Style_id:=Inttostr(Integer(cmbStyle.Items.Objects[cmbStyle.ItemIndex]));
    end else pms_Style_id:='null';

    cmbCondition.ItemIndex:=cmbCondition.Items.IndexOf(cmbCondition.Text);
    if (cmbCondition.ItemIndex<>-1)and(cmbCondition.ItemIndex<>0) then begin
      pms_Condition_id:=Inttostr(Integer(cmbCondition.Items.Objects[cmbCondition.ItemIndex]));
    end else pms_Condition_id:='null';

    cmbBalcony.ItemIndex:=cmbBalcony.Items.IndexOf(cmbBalcony.Text);
    if (cmbBalcony.ItemIndex<>-1)and(cmbBalcony.ItemIndex<>0) then begin
      pms_Balcony_id:=Inttostr(Integer(cmbBalcony.Items.Objects[cmbBalcony.ItemIndex]));
    end else pms_Balcony_id:='null';

    cmbFurniture.ItemIndex:=cmbFurniture.Items.IndexOf(cmbFurniture.Text);
    if (cmbFurniture.ItemIndex<>-1)and(cmbFurniture.ItemIndex<>0) then begin
      pms_Furniture_id:=Inttostr(Integer(cmbFurniture.Items.Objects[cmbFurniture.ItemIndex]));
    end else pms_Furniture_id:='null';

    //byBart
    cmbTaxes.ItemIndex:=cmbTaxes.Items.IndexOf(cmbTaxes.Text);
    if (cmbTaxes.ItemIndex<>-1) and(cmbTaxes.ItemIndex<>0) then begin
      pms_taxes_id:=Inttostr(Integer(cmbTaxes.Items.Objects[cmbTaxes.ItemIndex]));
    end else pms_taxes_id:='null';

  {  cmbAreaBuilding.ItemIndex:=cmbAreaBuilding.Items.IndexOf(cmbAreaBuilding.Text);
    if (cmbAreaBuilding.ItemIndex<>-1) and(cmbAreaBuilding.ItemIndex<>0) then begin
      pms_areabuilding_id:=Inttostr(Integer(cmbAreaBuilding.Items.Objects[cmbAreaBuilding.ItemIndex]));
    end else pms_areabuilding_id:='null';
   }
    cmbPopulatedPoint.ItemIndex:=cmbPopulatedPoint.Items.IndexOf(cmbPopulatedPoint.Text);
    if (cmbPopulatedPoint.ItemIndex<>-1) and(cmbPopulatedPoint.ItemIndex<>0) then begin
      pms_PopulatedPoint_id:=Inttostr(Integer(cmbPopulatedPoint.Items.Objects[cmbPopulatedPoint.ItemIndex]));
    end else pms_PopulatedPoint_id:='null';

    cmbLandFeature.ItemIndex:=cmbLandFeature.Items.IndexOf(cmbLandFeature.Text);
    if (cmbLandFeature.ItemIndex<>-1) and(cmbLandFeature.ItemIndex<>0) then begin
      pms_LandFeature_id:=Inttostr(Integer(cmbLandFeature.Items.Objects[cmbLandFeature.ItemIndex]));
    end else pms_LandFeature_id:='null';

    cmbExchangeFormula.ItemIndex:=cmbExchangeFormula.Items.IndexOf(cmbExchangeFormula.Text);
    if (cmbExchangeFormula.ItemIndex<>-1) and(cmbExchangeFormula.ItemIndex<>0) then begin
      pms_ExchangeFormula_id:=Inttostr(Integer(cmbExchangeFormula.Items.Objects[cmbExchangeFormula.ItemIndex]));
    end else pms_ExchangeFormula_id:='null';

    cmbLocationStatus.ItemIndex:=cmbLocationStatus.Items.IndexOf(cmbLocationStatus.Text);
    if (cmbLocationStatus.ItemIndex<>-1) and(cmbLocationStatus.ItemIndex<>0) then begin
      pms_LocationStatus_id:=Inttostr(Integer(cmbLocationStatus.Items.Objects[cmbLocationStatus.ItemIndex]));
    end else pms_LocationStatus_id:='null';

  {  cmbLandMark.ItemIndex:=cmbLandMark.Items.IndexOf(cmbLandMark.Text);
    if (cmbLandMark.ItemIndex<>-1) and(cmbLandMark.ItemIndex<>0) then begin
      pms_LandMark_id:=Inttostr(Integer(cmbLandMark.Items.Objects[cmbLandMark.ItemIndex]));
    end else pms_LandMark_id:='null';
   }
    cmbObject.ItemIndex:=cmbObject.Items.IndexOf(cmbObject.Text);
    if (cmbObject.ItemIndex<>-1) and(cmbObject.ItemIndex<>0) then begin
      pms_Object_id:=Inttostr(Integer(cmbObject.Items.Objects[cmbObject.ItemIndex]));
    end else pms_Object_id:='null';

    cmbDirection.ItemIndex:=cmbDirection.Items.IndexOf(cmbDirection.Text);
    if (cmbDirection.ItemIndex<>-1) and(cmbDirection.ItemIndex<>0) then begin
      pms_Direction_id:=Inttostr(Integer(cmbDirection.Items.Objects[cmbDirection.ItemIndex]));
    end else pms_Direction_id:='null';

    cmbAccessWays.ItemIndex:=cmbAccessWays.Items.IndexOf(cmbAccessWays.Text);
    if (cmbAccessWays.ItemIndex<>-1) and(cmbAccessWays.ItemIndex<>0) then begin
      pms_AccessWays_id:=Inttostr(Integer(cmbAccessWays.Items.Objects[cmbAccessWays.ItemIndex]));
    end else pms_AccessWays_id:='null';

    //-------

    cmbStation.ItemIndex:=cmbStation.Items.IndexOf(cmbStation.Text);
    if (cmbStation.ItemIndex<>-1) then begin
      pms_Station_id:=Inttostr(Integer(cmbStation.Items.Objects[cmbStation.ItemIndex]));
    end else pms_Station_id:='null';

    cmbPlanning.ItemIndex:=cmbPlanning.Items.IndexOf(cmbPlanning.Text);
    if (cmbPlanning.ItemIndex<>-1)and(cmbPlanning.ItemIndex<>0) then begin
      pms_Planning_id:=Inttostr(Integer(cmbPlanning.Items.Objects[cmbPlanning.ItemIndex]));
    end else pms_Planning_id:='null';

    cmbTypeRoom.ItemIndex:=cmbTypeRoom.Items.IndexOf(cmbTypeRoom.Text);
    if (cmbTypeRoom.ItemIndex<>-1)and(cmbTypeRoom.ItemIndex<>0) then begin
      pms_TypeRoom_id:=Inttostr(Integer(cmbTypeRoom.Items.Objects[cmbTypeRoom.ItemIndex]));
    end else pms_TypeRoom_id:='null';

    cmbCountRoom.ItemIndex:=cmbCountRoom.Items.IndexOf(cmbCountRoom.Text);
    if (cmbCountRoom.ItemIndex<>-1) then begin
      pms_CountRoom_id:=Inttostr(Integer(cmbCountRoom.Items.Objects[cmbCountRoom.ItemIndex]));
    end else pms_CountRoom_id:='null';

    cmbRegion.ItemIndex:=cmbRegion.Items.IndexOf(cmbRegion.Text);
    if (cmbRegion.ItemIndex<>-1) then begin
      pms_Region_id:=Inttostr(Integer(cmbRegion.Items.Objects[cmbRegion.ItemIndex]));
    end else pms_Region_id:='null';

    cmbCityRegion.ItemIndex:=cmbCityRegion.Items.IndexOf(cmbCityRegion.Text);
    if (cmbCityRegion.ItemIndex<>-1) then begin
      pms_City_Region_id:=Inttostr(Integer(cmbCityRegion.Items.Objects[cmbCityRegion.ItemIndex]));
    end else pms_City_Region_id:='null';

    cmbPhone.ItemIndex:=cmbPhone.Items.IndexOf(cmbPhone.Text);
    if (cmbPhone.ItemIndex<>-1)and(cmbPhone.ItemIndex<>0) then begin
      pms_Phone_id:=Inttostr(Integer(cmbPhone.Items.Objects[cmbPhone.ItemIndex]));
    end else pms_Phone_id:='null';

    cmbDocument.ItemIndex:=cmbDocument.Items.IndexOf(cmbDocument.Text);
    if (cmbDocument.ItemIndex<>-1)and(cmbDocument.ItemIndex<>0) then begin
      pms_Document_id:=Inttostr(Integer(cmbDocument.Items.Objects[cmbDocument.ItemIndex]));
    end else pms_Document_id:='null';

    cmbSaleStatus.ItemIndex:=cmbSaleStatus.Items.IndexOf(cmbSaleStatus.Text);
    if (cmbSaleStatus.ItemIndex<>-1)and(cmbSaleStatus.ItemIndex<>0) then begin
      pms_SaleStatus_id:=Inttostr(Integer(cmbSaleStatus.Items.Objects[cmbSaleStatus.ItemIndex]));
    end else pms_SaleStatus_id:='null';

    cmbSelfForm.ItemIndex:=cmbSelfForm.Items.IndexOf(cmbSelfForm.Text);
    if (cmbSelfForm.ItemIndex<>-1)and(cmbSelfForm.ItemIndex<>0) then begin
      pms_SelfForm_id:=Inttostr(Integer(cmbSelfForm.Items.Objects[cmbSelfForm.ItemIndex]));
    end else pms_SelfForm_id:='null';

    cmbTypePremises.ItemIndex:=cmbTypePremises.Items.IndexOf(cmbTypePremises.Text);
    if (cmbTypePremises.ItemIndex<>-1)and(cmbTypePremises.ItemIndex<>0) then begin
      pms_TypePremises_id:=Inttostr(Integer(cmbTypePremises.Items.Objects[cmbTypePremises.ItemIndex]));
    end else pms_TypePremises_id:='null';

    cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(cmbUnitPrice.Text);
    if (cmbUnitPrice.ItemIndex<>-1)and(cmbUnitPrice.ItemIndex<>0) then begin
      pms_UnitPrice_id:=Inttostr(Integer(cmbUnitPrice.Items.Objects[cmbUnitPrice.ItemIndex]));
    end else pms_UnitPrice_id:='null';

    id:=inttostr(oldPms_Premises_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Premises+
          ' set pms_typehouse_id='+pms_typehouse_id+
          ',pms_stove_id='+pms_Stove_id+
          ',pms_street_id='+pms_Street_id+
          ',pms_agent_id='+pms_Agent_id+
          ',pms_door_id='+pms_door_id+
          ',pms_sanitarynode_id='+pms_sanitarynode_id+
          ',pms_Heat_id='+pms_Heat_id+
          ',pms_Water_id='+pms_Water_id+
          ',pms_Builder_id='+pms_Builder_id+
          ',pms_Style_id='+pms_Style_id+
          ',pms_condition_id='+pms_condition_id+
          ',whoupdate_id='+whoupdate_id+
          ',pms_balcony_id='+pms_balcony_id+
          ',pms_furniture_id='+pms_furniture_id+
          ',pms_taxes_id='+pms_taxes_id+
          ',datearrivals='+QuotedStr(DateToStr(dtpDateArrivalsFrom.Date))+
          ',pms_station_id='+pms_station_id+
          ',pms_planning_id='+pms_planning_id+
          ',pms_typeroom_id='+pms_typeroom_id+
          ',contact='+QuotedStr(GetContact)+
          ',clientinfo='+iff(Trim(ComboBoxClientInfo.Text)<>'',QuotedStr(Trim(ComboBoxClientInfo.Text)),'null')+
          ',contact2='+QuotedStr(GetContact2)+
          ',clientinfo2='+iff(Trim(ComboBoxClientInfo_.Text)<>'',QuotedStr(Trim(ComboBoxClientInfo_.Text)),'null')+
          ',pms_countroom_id='+pms_countroom_id+
          ',pms_region_id='+pms_region_id+
          ',pms_city_region_id='+pms_city_region_id+
          ',housenumber='+iff(Trim(edHouseNumber.Text)<>'',QuotedStr(Trim(edHouseNumber.Text)),'null')+
          ',apartmentnumber='+iff(Trim(edApartmentNumber.Text)<>'',QuotedStr(Trim(edApartmentNumber.Text)),'null')+
          ',pms_phone_id='+pms_phone_id+
          ',floor='+iff(Trim(edFloor.Text)<>'',QuotedStr(Trim(edFloor.Text)),'null')+
          ',countfloor='+iff(Trim(edCountFloor.Text)<>'',Trim(edCountFloor.Text),'null')+
          ',generalarea='+iff(trim(edGeneralArea.Text)<>'',QuotedStr(ChangeChar(edGeneralArea.Text,',','.')),'null')+
          ',groundArea='+iff(trim(edgroundArea.Text)<>'',QuotedStr(ChangeChar(edgroundArea.Text,',','.')),'null')+
          ',pms_document_id='+pms_document_id+
          ',dwellingarea='+iff(Trim(edDwellingArea.Text)<>'',QuotedStr(ChangeChar(edDwellingArea.Text,',','.')),'null')+
          ',kitchenarea='+iff(trim(edKitchenArea.Text)<>'',QuotedStr(ChangeChar(edKitchenArea.Text,',','.')),'null')+
          ',typeoperation='+IntTostr(Integer(FTypeOperation))+
          ',price='+iff(trim(edPrice.Text)<>'',QuotedStr(ChangeChar(edPrice.Text,',','.')),'null')+
          ',term='+iff(Trim(edTerm.Text)<>'',QuotedStr(Trim(edTerm.Text)),'null')+
          ',payment='+iff(Trim(edPayment.Text)<>'',QuotedStr(Trim(edPayment.Text)),'null')+
          ',note='+iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.Text)),'null')+
          ',advertisment_note='+iff(Trim(edAdvertismentNote.Text)<>'',QuotedStr(Trim(edAdvertismentNote.Text)),'null')+
          ',datetimeupdate='+QuotedStr(DateTimeToStr(dt))+
          ',pms_salestatus_id='+pms_salestatus_id+
          ',pms_selfform_id='+pms_selfform_id+
          ',pms_typepremises_id='+pms_typepremises_id+
          ',pms_UnitPrice_id='+pms_UnitPrice_id+
          ',recyled='+inttostr(cmbRecyled.ItemIndex)+
          ',nn='+iff(Trim(edNN.Text)<>'',QuotedStr(Trim(edNN.Text)),'null')+
          ',delivery='+iff(Trim(eddelivery.Text)<>'',QuotedStr(Trim(eddelivery.Text)),'null')+
          ',decoration='+iff(Trim(edDecoration.Text)<>'',QuotedStr(Trim(edDecoration.Text)),'null')+
          ',glassy='+iff(Trim(edGlassy.Text)<>'',QuotedStr(Trim(edGlassy.Text)),'null')+
          ',block_section='+iff(Trim(edBlockSection.Text)<>'',QuotedStr(Trim(edBlockSection.Text)),'null')+
          ',price2='+iff(trim(edPrice2.Text)<>'',QuotedStr(ChangeChar(edPrice2.Text,',','.')),'null')+
          ',areabuilding='+iff(Trim(edAreaBuilding.Text)<>'',QuotedStr(Trim(edAreaBuilding.Text)),'null')+
      //      ',pms_areabuilding_id='+pms_areabuilding_id+
          ',pms_populatedpoint_id='+pms_populatedpoint_id+
          ',pms_landfeature_id='+pms_landfeature_id+
          ',pms_exchangeformula_id='+pms_exchangeformula_id+
          ',pms_locationstatus_id='+pms_locationstatus_id+
          ',landmark='+iff(Trim(edLandMark.Text)<>'',QuotedStr(Trim(edLandMark.Text)),'null')+
      //  ',pms_landmark_id='+pms_landmark_id+
          ',communications='+iff(Trim(edCommunications.Text)<>'',QuotedStr(Trim(edcommunications.Text)),'null')+
          ',email='+iff(trim(edEmail.Text)<>'',QuotedStr(Trim(edEmail.Text)),'null')+
          ',email2='+iff(trim(edEmail_.Text)<>'',QuotedStr(Trim(edEmail_.Text)),'null')+
          ',leaseorsale='+iff(Trim(cbLeaseOrSale.Text)<>'',QuotedStr(Trim(cbLeaseOrSale.Text)),'null')+
          ',pms_object_id='+pms_object_id+
          ',pms_direction_id='+pms_direction_id+
          ',pms_accessways_id='+pms_accessways_id+
          ',remoteness='+iff(trim(edRemoteness.Text)<>'',QuotedStr(Trim(edRemoteness.Text)),'null')+
          iff(cmbRecyled.ItemIndex=0,',daterecyledout=null','')+
          ' where Pms_Premises_id='+id+' and pms_agent_id='+IntTostr(oldpms_agent_id);
     //     showmessage(sqls);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    if isUpdate then begin
      TfmRBPms_Premises(fmParent).MainQr.DisableControls;
      b:=TfmRBPms_Premises(fmParent).MainQr.GetBookmark;
      try
        isLocate:=TfmRBPms_Premises(fmParent).MainQr.Locate('Pms_Premises_id;pms_agent_id',
                                                            VarArrayOf([oldPms_Premises_id,oldpms_agent_id]),[loCaseInsensitive]);

        if isLocate then begin
          TfmRBPms_Premises(fmParent).IBUpd.ModifySQL.Clear;
          TfmRBPms_Premises(fmParent).IBUpd.ModifySQL.Add(sqls);

          with TfmRBPms_Premises(fmParent).MainQr do begin
            Edit;
            FieldByName('Pms_Premises_id').AsInteger:=oldPms_Premises_id;
            FieldByName('pms_typehouse_id').Value:=Iff(AnsiSameText(pms_typehouse_id,'null'),NULL,pms_typehouse_id);
            FieldByName('pms_stove_id').Value:=Iff(AnsiSameText(pms_stove_id,'null'),NULL,pms_stove_id);
            FieldByName('pms_street_id').Value:=pms_street_id;
            FieldByName('pms_agent_id').Value:=pms_agent_id;
            FieldByName('sync_office_id').Value:=GetSyncOfficeId(StrToInt(pms_agent_id));
            FieldByName('pms_door_id').Value:=Iff(AnsiSameText(pms_door_id,'null'),NULL,pms_door_id);
            FieldByName('pms_sanitarynode_id').Value:=Iff(AnsiSameText(pms_sanitarynode_id,'null'),NULL,pms_sanitarynode_id);
            FieldByName('pms_condition_id').Value:=Iff(AnsiSameText(pms_condition_id,'null'),NULL,pms_condition_id);
            FieldByName('whoupdate_id').Value:=whoupdate_id;
            FieldByName('pms_balcony_id').Value:=Iff(AnsiSameText(pms_balcony_id,'null'),NULL,pms_balcony_id);
            FieldByName('pms_furniture_id').Value:=Iff(AnsiSameText(pms_furniture_id,'null'),NULL,pms_furniture_id);
            FieldByName('taxes').Value:=iff(Trim(cmbTaxes.Text)<>'',Trim(cmbTaxes.Text),Null);;
            FieldByName('datearrivals').Value:=dtpDateArrivalsFrom.Date;
            FieldByName('pms_station_id').Value:=Iff(AnsiSameText(pms_station_id,'null'),NULL,pms_station_id);
            FieldByName('pms_planning_id').Value:=Iff(AnsiSameText(pms_planning_id,'null'),NULL,pms_planning_id);
            FieldByName('pms_typeroom_id').Value:=Iff(AnsiSameText(pms_typeroom_id,'null'),NULL,pms_typeroom_id);
            FieldByName('contact').Value:=GetContact;
            FieldByName('clientinfo').Value:=iff(Trim(ComboBoxClientInfo.Text)<>'',Trim(ComboBoxClientInfo.Text),Null);
            FieldByName('contact2').Value:=GetContact2;
            FieldByName('clientinfo2').Value:=iff(Trim(ComboBoxClientInfo_.Text)<>'',Trim(ComboBoxClientInfo_.Text),Null);
            FieldByName('pms_countroom_id').Value:=Iff(AnsiSameText(pms_countroom_id,'null'),NULL,pms_countroom_id);;
            FieldByName('pms_region_id').Value:=pms_region_id;
            FieldByName('pms_city_region_id').Value:=Iff(AnsiSameText(pms_city_region_id,'null'),NULL,pms_city_region_id);
            FieldByName('housenumber').Value:=iff(Trim(edHouseNumber.Text)<>'',Trim(edHouseNumber.Text),Null);
            FieldByName('apartmentnumber').Value:=iff(Trim(edApartmentNumber.Text)<>'',Trim(edApartmentNumber.Text),Null);
            FieldByName('pms_phone_id').Value:=Iff(AnsiSameText(pms_phone_id,'null'),NULL,pms_phone_id);
            FieldByName('floor').Value:=iff(Trim(edFloor.Text)<>'',Trim(edFloor.Text),Null);
            FieldByName('countfloor').Value:=iff(Trim(edCountFloor.Text)<>'',Trim(edCountFloor.Text),Null);
            FieldByName('generalarea').Value:=iff(trim(edGeneralArea.Text)<>'',edGeneralArea.Text,Null);
            FieldByName('groundArea').Value:=iff(trim(edgroundArea.Text)<>'',edgroundArea.Text,Null);
            FieldByName('pms_document_id').Value:=Iff(AnsiSameText(pms_document_id,'null'),NULL,pms_document_id);
            FieldByName('dwellingarea').Value:=iff(trim(edDwellingArea.Text)<>'',edDwellingArea.Text,Null);
            FieldByName('kitchenarea').Value:=iff(trim(edKitchenArea.Text)<>'',edKitchenArea.Text,Null);
            FieldByName('typeoperation').Value:=Integer(FTypeOperation);
            FieldByName('price').Value:=iff(trim(edPrice.Text)<>'',edPrice.Text,Null);
            FieldByName('term').Value:=iff(Trim(edTerm.Text)<>'',Trim(edTerm.Text),Null);
            FieldByName('payment').Value:=iff(Trim(edPayment.Text)<>'',Trim(edPayment.Text),Null);
            FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',Trim(edNote.Text),Null);
            FieldByName('datetimeupdate').Value:=DateTimeToStr(dt);
            FieldByName('recyled').Value:=inttostr(cmbRecyled.ItemIndex);
            FieldByName('pms_salestatus_id').Value:=Iff(AnsiSameText(pms_salestatus_id,'null'),NULL,pms_salestatus_id);
            FieldByName('pms_selfform_id').Value:=Iff(AnsiSameText(pms_selfform_id,'null'),NULL,pms_selfform_id);
            FieldByName('pms_typepremises_id').Value:=Iff(AnsiSameText(pms_typepremises_id,'null'),NULL,pms_typepremises_id);
            FieldByName('pms_UnitPrice_id').Value:=Iff(AnsiSameText(pms_UnitPrice_id,'null'),NULL,pms_UnitPrice_id);
            FieldByName('regionname').Value:=iff(Trim(cmbRegion.Text)<>'',Trim(cmbRegion.Text),Null);
            FieldByName('cityregionname').Value:=iff(Trim(cmbCityRegion.Text)<>'',Trim(cmbCityRegion.Text),Null);
            FieldByName('streetname').Value:=iff(Trim(cmbStreet.Text)<>'',Trim(cmbStreet.Text),Null);
            FieldByName('countroomname').Value:=iff(Trim(cmbCountRoom.Text)<>'',Trim(cmbCountRoom.Text),Null);
            FieldByName('whoupdatename').AsString:=T.UserName;
            FieldByName('agentname').Value:=iff(Trim(cmbAgent.Text)<>'',Trim(cmbAgent.Text),Null);
            FieldByName('balconyname').Value:=iff(Trim(cmbBalcony.Text)<>'',Trim(cmbBalcony.Text),Null);
            FieldByName('conditionname').Value:=iff(Trim(cmbCondition.Text)<>'',Trim(cmbCondition.Text),Null);
            FieldByName('sanitarynodename').Value:=iff(Trim(cmbSanitaryNode.Text)<>'',Trim(cmbSanitaryNode.Text),Null);
            FieldByName('doorname').Value:=iff(Trim(cmbDoor.Text)<>'',Trim(cmbDoor.Text),Null);
            FieldByName('typeroomname').Value:=iff(Trim(cmbTypeRoom.Text)<>'',Trim(cmbTypeRoom.Text),Null);
            FieldByName('planningname').Value:=iff(Trim(cmbPlanning.Text)<>'',Trim(cmbPlanning.Text),Null);
            FieldByName('stationname').Value:=iff(Trim(cmbStation.Text)<>'',Trim(cmbStation.Text),Null);
            FieldByName('typehousename').Value:=iff(Trim(cmbTypeHouse.Text)<>'',Trim(cmbTypeHouse.Text),Null);
            FieldByName('stovename').Value:=iff(Trim(cmbStove.Text)<>'',Trim(cmbStove.Text),Null);
            FieldByName('furniturename').Value:=iff(Trim(cmbFurniture.Text)<>'',Trim(cmbFurniture.Text),Null);
            FieldByName('phonename').Value:=iff(Trim(cmbPhone.Text)<>'',Trim(cmbPhone.Text),Null);
            FieldByName('documentname').Value:=iff(Trim(cmbDocument.Text)<>'',Trim(cmbDocument.Text),Null);
            FieldByName('SaleStatusname').Value:=iff(Trim(cmbSaleStatus.Text)<>'',Trim(cmbSaleStatus.Text),Null);
            FieldByName('SelfFormname').Value:=iff(Trim(cmbSelfForm.Text)<>'',Trim(cmbSelfForm.Text),Null);
            FieldByName('TypePremisesname').Value:=iff(Trim(cmbTypePremises.Text)<>'',Trim(cmbTypePremises.Text),Null);
            FieldByName('UnitPricename').Value:=iff(Trim(cmbUnitPrice.Text)<>'',Trim(cmbUnitPrice.Text),Null);
            FieldByName('nn').Value:=iff(Trim(edNN.Text)<>'',Trim(edNN.Text),Null);
            FieldByName('delivery').Value:=iff(Trim(eddelivery.Text)<>'',Trim(edDelivery.Text),Null);
            FieldByName('Watername').Value:=iff(Trim(cmbWater.Text)<>'',Trim(cmbWater.Text),Null);
            FieldByName('pms_Water_id').Value:=Iff(AnsiSameText(pms_Water_id,'null'),NULL,pms_Water_id);
            FieldByName('Buildername').Value:=iff(Trim(cmbBuilder.Text)<>'',Trim(cmbBuilder.Text),Null);
            FieldByName('pms_Builder_id').Value:=Iff(AnsiSameText(pms_Builder_id,'null'),NULL,pms_Builder_id);
            FieldByName('Stylename').Value:=iff(Trim(cmbStyle.Text)<>'',Trim(cmbStyle.Text),Null);
            FieldByName('pms_Style_id').Value:=Iff(AnsiSameText(pms_Style_id,'null'),NULL,pms_Style_id);
            FieldByName('Heatname').Value:=iff(Trim(cmbHeat.Text)<>'',Trim(cmbHeat.Text),Null);
            FieldByName('pms_Heat_id').Value:=Iff(AnsiSameText(pms_Heat_id,'null'),NULL,pms_Heat_id);
            FieldByName('decoration').Value:=iff(Trim(edDecoration.Text)<>'',Trim(edDecoration.Text),Null);
            FieldByName('glassy').Value:=iff(Trim(edGlassy.Text)<>'',Trim(edGlassy.Text),Null);
            FieldByName('block_section').Value:=iff(Trim(edBlockSection.Text)<>'',Trim(edBlockSection.Text),Null);
            FieldByName('price2').Value:=iff(trim(edPrice2.Text)<>'',edPrice2.Text,Null);
            FieldByName('advertisment_note').Value:=iff(Trim(edAdvertismentNote.Text)<>'',Trim(edAdvertismentNote.Text),Null);
            FieldByName('areabuilding').Value:=Iff(Trim(edAreaBuilding.Text)<>'',Trim(edAreaBuilding.Text),Null);
            FieldByName('populatedpoint').Value:=Iff(AnsiSameText(cmbPopulatedPoint.Text,'null'),NULL,cmbPopulatedPoint.Text);
            FieldByName('landfeature').Value:=Iff(AnsiSameText(cmbLandFeature.Text,'null'),NULL,cmbLandFeature.Text);
            FieldByName('exchangeformula').Value:=Iff(AnsiSameText(cmbExchangeFormula.Text,'null'),NULL,cmbExchangeFormula.Text);
            FieldByName('locationstatus').Value:=Iff(AnsiSameText(cmbLocationStatus.Text,'null'),NULL,cmbLocationStatus.Text);
            FieldByName('landmark').Value:=Iff(Trim(edLandMark.Text)<>'',Trim(edLandMark.Text),Null);
          //  FieldByName('landmark').Value:=Iff(AnsiSameText(cmbLandMark.Text,'null'),NULL,cmbLandMark.Text);
            FieldByName('communications').Value:=iff(Trim(edcommunications.Text)<>'',Trim(edcommunications.Text),Null);
            FieldByName('email').Value:=iff(Trim(edEmail.Text)<>'',Trim(edEmail.Text),Null);
            FieldByName('email2').Value:=iff(Trim(edEmail_.Text)<>'',Trim(edEmail_.Text),Null);
            FieldByName('leaseorsale').Value:=iff(Trim(cbLeaseOrSale.Text)<>'',Trim(cbLeaseOrSale.Text),Null);

            FieldByName('object').Value:=Iff(AnsiSameText(cmbObject.Text,'null'),NULL,cmbObject.Text);
            FieldByName('direction').Value:=Iff(AnsiSameText(cmbDirection.Text,'null'),NULL,cmbDirection.Text);
            FieldByName('accessways').Value:=Iff(AnsiSameText(cmbAccessWays.Text,'null'),NULL,cmbAccessWays.Text);
            FieldByName('remoteness').Value:=iff(Trim(edRemoteness.Text)<>'',Trim(edRemoteness.Text),Null);

            Post;
          end;
        end

      finally
        TfmRBPms_Premises(fmParent).MainQr.GotoBookmark(b);
        TfmRBPms_Premises(fmParent).MainQr.EnableControls;
      end;
    end;

    if isInsert then begin

        TfmRBPms_Premises(fmParent).IBUpd.InsertSQL.Clear;
        TfmRBPms_Premises(fmParent).IBUpd.InsertSQL.Add(sqls);

        with TfmRBPms_Premises(fmParent).MainQr do begin
          Insert;
          FieldByName('Pms_Premises_id').AsInteger:=oldPms_Premises_id;
          FieldByName('pms_typehouse_id').Value:=Iff(AnsiSameText(pms_typehouse_id,'null'),NULL,pms_typehouse_id);
          FieldByName('pms_stove_id').Value:=Iff(AnsiSameText(pms_stove_id,'null'),NULL,pms_stove_id);
          FieldByName('pms_street_id').Value:=pms_street_id;
          FieldByName('whoinsert_id').Value:=WhoInsertedEx;
          FieldByName('pms_agent_id').Value:=pms_agent_id;
          FieldByName('sync_office_id').Value:=GetSyncOfficeId(StrToInt(pms_agent_id));
          FieldByName('pms_door_id').Value:=Iff(AnsiSameText(pms_door_id,'null'),NULL,pms_door_id);
          FieldByName('pms_sanitarynode_id').Value:=Iff(AnsiSameText(pms_sanitarynode_id,'null'),NULL,pms_sanitarynode_id);
          FieldByName('pms_condition_id').Value:=Iff(AnsiSameText(pms_condition_id,'null'),NULL,pms_condition_id);
          FieldByName('whoupdate_id').Value:=whoupdate_id;
          FieldByName('pms_balcony_id').Value:=Iff(AnsiSameText(pms_balcony_id,'null'),NULL,pms_balcony_id);
          FieldByName('pms_furniture_id').Value:=Iff(AnsiSameText(pms_furniture_id,'null'),NULL,pms_furniture_id);
          FieldByName('taxes').Value:=iff(Trim(cmbTaxes.Text)<>'',Trim(cmbTaxes.Text),Null);
          FieldByName('datearrivals').Value:=dtpDateArrivalsFrom.Date;
          FieldByName('pms_station_id').Value:=Iff(AnsiSameText(pms_station_id,'null'),NULL,pms_station_id);
          FieldByName('pms_planning_id').Value:=Iff(AnsiSameText(pms_planning_id,'null'),NULL,pms_planning_id);
          FieldByName('pms_typeroom_id').Value:=Iff(AnsiSameText(pms_typeroom_id,'null'),NULL,pms_typeroom_id);
          FieldByName('contact').Value:=GetContact;
          FieldByName('clientinfo').Value:=iff(Trim(ComboBoxClientInfo.Text)<>'',Trim(ComboBoxClientInfo.Text),Null);
          FieldByName('contact2').Value:=GetContact2;
          FieldByName('clientinfo2').Value:=iff(Trim(ComboBoxClientInfo_.Text)<>'',Trim(ComboBoxClientInfo_.Text),Null);
          FieldByName('pms_countroom_id').Value:=pms_countroom_id;
          FieldByName('pms_region_id').Value:=pms_region_id;
          FieldByName('pms_city_region_id').Value:=Iff(AnsiSameText(pms_city_region_id,'null'),NULL,pms_city_region_id);
          FieldByName('housenumber').Value:=iff(Trim(edHouseNumber.Text)<>'',Trim(edHouseNumber.Text),Null);
          FieldByName('apartmentnumber').Value:=iff(Trim(edApartmentNumber.Text)<>'',Trim(edApartmentNumber.Text),Null);
          FieldByName('pms_phone_id').Value:=Iff(AnsiSameText(pms_phone_id,'null'),NULL,pms_phone_id);
          FieldByName('floor').Value:=iff(Trim(edFloor.Text)<>'',Trim(edFloor.Text),Null);
          FieldByName('countfloor').Value:=iff(Trim(edCountFloor.Text)<>'',Trim(edCountFloor.Text),Null);
          FieldByName('generalarea').Value:=iff(trim(edGeneralArea.Text)<>'',edGeneralArea.Text,Null);
          FieldByName('groundArea').Value:=iff(trim(edgroundArea.Text)<>'',edgroundArea.Text,Null);
          FieldByName('pms_document_id').Value:=Iff(AnsiSameText(pms_document_id,'null'),NULL,pms_document_id);
          FieldByName('dwellingarea').Value:=iff(trim(edDwellingArea.Text)<>'',edDwellingArea.Text,Null);
          FieldByName('kitchenarea').Value:=iff(trim(edKitchenArea.Text)<>'',edKitchenArea.Text,Null);
          FieldByName('typeoperation').Value:=Integer(FTypeOperation);
          FieldByName('price').Value:=iff(trim(edPrice.Text)<>'',edPrice.Text,Null);
          FieldByName('term').Value:=iff(Trim(edTerm.Text)<>'',Trim(edTerm.Text),Null);
          FieldByName('payment').Value:=iff(Trim(edPayment.Text)<>'',Trim(edPayment.Text),Null);
          FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',Trim(edNote.Text),Null);
          FieldByName('datetimeinsert').Value:=DateTimeInsertedEx;
          FieldByName('datetimeupdate').Value:=DateTimeToStr(dt);
          FieldByName('pms_salestatus_id').Value:=Iff(AnsiSameText(pms_salestatus_id,'null'),NULL,pms_salestatus_id);
          FieldByName('pms_selfform_id').Value:=Iff(AnsiSameText(pms_selfform_id,'null'),NULL,pms_selfform_id);
          FieldByName('pms_typepremises_id').Value:=Iff(AnsiSameText(pms_typepremises_id,'null'),NULL,pms_typepremises_id);
          FieldByName('pms_UnitPrice_id').Value:=Iff(AnsiSameText(pms_UnitPrice_id,'null'),NULL,pms_UnitPrice_id);
          FieldByName('recyled').Value:=inttostr(cmbRecyled.ItemIndex);
          FieldByName('regionname').Value:=iff(Trim(cmbRegion.Text)<>'',Trim(cmbRegion.Text),Null);
          FieldByName('cityregionname').Value:=iff(Trim(cmbCityRegion.Text)<>'',Trim(cmbCityRegion.Text),Null);
          FieldByName('streetname').Value:=iff(Trim(cmbStreet.Text)<>'',Trim(cmbStreet.Text),Null);
          FieldByName('countroomname').Value:=iff(Trim(cmbCountRoom.Text)<>'',Trim(cmbCountRoom.Text),Null);
          FieldByName('whoinsertname').AsString:=WhoInsertedNameEx;
          FieldByName('whoupdatename').AsString:=T.UserName;
          FieldByName('agentname').Value:=iff(Trim(cmbAgent.Text)<>'',Trim(cmbAgent.Text),Null);
          FieldByName('balconyname').Value:=iff(Trim(cmbBalcony.Text)<>'',Trim(cmbBalcony.Text),Null);
          FieldByName('conditionname').Value:=iff(Trim(cmbCondition.Text)<>'',Trim(cmbCondition.Text),Null);
          FieldByName('sanitarynodename').Value:=iff(Trim(cmbSanitaryNode.Text)<>'',Trim(cmbSanitaryNode.Text),Null);
          FieldByName('doorname').Value:=iff(Trim(cmbDoor.Text)<>'',Trim(cmbDoor.Text),Null);
          FieldByName('typeroomname').Value:=iff(Trim(cmbTypeRoom.Text)<>'',Trim(cmbTypeRoom.Text),Null);
          FieldByName('planningname').Value:=iff(Trim(cmbPlanning.Text)<>'',Trim(cmbPlanning.Text),Null);
          FieldByName('stationname').Value:=iff(Trim(cmbStation.Text)<>'',Trim(cmbStation.Text),Null);
          FieldByName('typehousename').Value:=iff(Trim(cmbTypeHouse.Text)<>'',Trim(cmbTypeHouse.Text),Null);
          FieldByName('stovename').Value:=iff(Trim(cmbStove.Text)<>'',Trim(cmbStove.Text),Null);
          FieldByName('furniturename').Value:=iff(Trim(cmbFurniture.Text)<>'',Trim(cmbFurniture.Text),Null);
          FieldByName('phonename').Value:=iff(Trim(cmbPhone.Text)<>'',Trim(cmbPhone.Text),Null);
          FieldByName('documentname').Value:=iff(Trim(cmbDocument.Text)<>'',Trim(cmbDocument.Text),Null);
          FieldByName('SaleStatusname').Value:=iff(Trim(cmbSaleStatus.Text)<>'',Trim(cmbSaleStatus.Text),Null);
          FieldByName('SelfFormname').Value:=iff(Trim(cmbSelfForm.Text)<>'',Trim(cmbSelfForm.Text),Null);
          FieldByName('TypePremisesname').Value:=iff(Trim(cmbTypePremises.Text)<>'',Trim(cmbTypePremises.Text),Null);
          FieldByName('UnitPricename').Value:=iff(Trim(cmbUnitPrice.Text)<>'',iff(trim(edPrice.Text)<>'',Trim(cmbUnitPrice.Text),Null),Null);
          FieldByName('nn').Value:=iff(Trim(edNN.Text)<>'',Trim(edNN.Text),Null);
          FieldByName('delivery').Value:=iff(Trim(edDelivery.Text)<>'',Trim(edDelivery.Text),Null);
          FieldByName('Heatname').Value:=iff(Trim(cmbHeat.Text)<>'',Trim(cmbHeat.Text),Null);
          FieldByName('pms_Heat_id').Value:=Iff(AnsiSameText(pms_Heat_id,'null'),NULL,pms_Heat_id);
          FieldByName('Watername').Value:=iff(Trim(cmbWater.Text)<>'',Trim(cmbWater.Text),Null);
          FieldByName('pms_Water_id').Value:=Iff(AnsiSameText(pms_Water_id,'null'),NULL,pms_Water_id);
          FieldByName('Buildername').Value:=iff(Trim(cmbBuilder.Text)<>'',Trim(cmbBuilder.Text),Null);
          FieldByName('pms_Builder_id').Value:=Iff(AnsiSameText(pms_Builder_id,'null'),NULL,pms_Builder_id);
          FieldByName('Stylename').Value:=iff(Trim(cmbStyle.Text)<>'',Trim(cmbStyle.Text),Null);
          FieldByName('pms_Style_id').Value:=Iff(AnsiSameText(pms_Style_id,'null'),NULL,pms_Style_id);
          FieldByName('decoration').Value:=iff(Trim(edDecoration.Text)<>'',Trim(edDecoration.Text),Null);
          FieldByName('glassy').Value:=iff(Trim(edGlassy.Text)<>'',Trim(edGlassy.Text),Null);
          FieldByName('block_section').Value:=iff(Trim(edBlockSection.Text)<>'',Trim(edBlockSection.Text),Null);
          FieldByName('price2').Value:=iff(trim(edPrice2.Text)<>'',edPrice2.Text,Null);
          FieldByName('advertisment_note').Value:=iff(Trim(edAdvertismentNote.Text)<>'',Trim(edAdvertismentNote.Text),Null);
          FieldByName('areabuilding').Value:=iff(Trim(edAreaBuilding.Text)<>'',Trim(edAreaBuilding.Text),Null);
         // FieldByName('pms_areabuilding_id').Value:=Iff(AnsiSameText(pms_areabuilding_id,'null'),NULL,pms_areabuilding_id);
          FieldByName('pms_populatedpoint_id').Value:=Iff(AnsiSameText(pms_populatedpoint_id,'null'),NULL,pms_populatedpoint_id);
          FieldByName('pms_landfeature_id').Value:=Iff(AnsiSameText(pms_landfeature_id,'null'),NULL,pms_landfeature_id);
          FieldByName('pms_exchangeformula_id').Value:=Iff(AnsiSameText(pms_exchangeformula_id,'null'),NULL,pms_exchangeformula_id);
          FieldByName('pms_locationstatus_id').Value:=Iff(AnsiSameText(pms_locationstatus_id,'null'),NULL,pms_locationstatus_id);
          FieldByName('landmark').Value:=iff(Trim(edLandMark.Text)<>'',Trim(edLandMark.Text),Null);
         //FieldByName('pms_landmark_id').Value:=Iff(AnsiSameText(pms_landmark_id,'null'),NULL,pms_landmark_id);
          FieldByName('communications').Value:=iff(Trim(edcommunications.Text)<>'',Trim(edcommunications.Text),Null);
          FieldByName('email').Value:=iff(Trim(edEmail.Text)<>'',Trim(edEmail.Text),Null);
          FieldByName('email2').Value:=iff(Trim(edEmail_.Text)<>'',Trim(edEmail_.Text),Null);
          FieldByName('leaseorsale').Value:=iff(Trim(cbLeaseOrSale.Text)<>'',Trim(cbLeaseOrSale.Text),Null);

          FieldByName('object').Value:=Iff(AnsiSameText(cmbObject.Text,'null'),NULL,cmbObject.Text);
          FieldByName('direction').Value:=Iff(AnsiSameText(cmbDirection.Text,'null'),NULL,cmbDirection.Text);
          FieldByName('accessways').Value:=Iff(AnsiSameText(cmbAccessWays.Text,'null'),NULL,cmbAccessWays.Text);
          FieldByName('remoteness').Value:=iff(Trim(edRemoteness.Text)<>'',Trim(edRemoteness.Text),Null);

          Post;
        end;
      end;

    if isDelete then begin
      TfmRBPms_Premises(fmParent).MainQr.DisableControls;
      try
        isLocate:=TfmRBPms_Premises(fmParent).MainQr.Locate('Pms_Premises_id;pms_agent_id',
                                                            VarArrayOf([oldPms_Premises_id,oldpms_agent_id]),[loCaseInsensitive]);

        if isLocate then begin
          TfmRBPms_Premises(fmParent).IBUpd.DeleteSQL.Clear;
          TfmRBPms_Premises(fmParent).IBUpd.DeleteSQL.Add(sqls);
          TfmRBPms_Premises(fmParent).Mainqr.Delete;
        end;

      finally
        TfmRBPms_Premises(fmParent).MainQr.EnableControls;
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

procedure TfmEditRBPms_Premises.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Premises.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if (trim(GetContact)='')then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[Trim(lbContact.Caption)]));
    edContact1.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbRegion.Items.IndexOf(Trim(cmbRegion.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRegion.Caption]));
    cmbRegion.SetFocus;
    Result:=false;
    exit;
  end;
  {if cmbCityRegion.Items.IndexOf(Trim(cmbCityRegion.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCityRegion.Caption]));
    cmbCityRegion.SetFocus;
    Result:=false;
    exit;
  end; }

    if (TypeOperation<>toLand) and (cmbStreet.Items.IndexOf(Trim(cmbStreet.Text))=-1) then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[lbStreet.Caption]));
      cmbStreet.SetFocus;
      Result:=false;
      exit;
    end;
{  if trim(edHouseNumber.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbHouseNumber.Caption]));
    edHouseNumber.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edApartmentNumber.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbApartmentNumber.Caption]));
    edApartmentNumber.SetFocus;
    Result:=false;
    exit;
  end;}
if TypeOperation<>toLand then
   begin
    if cmbCountRoom.Items.IndexOf(Trim(cmbCountRoom.Text))=-1 then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[lbCountRoom.Caption]));
      cmbCountRoom.SetFocus;
      Result:=false;
      exit;
    end;
   end;
{  if TypeOperation=toLand then
    if cmbPopulatedPoint.Items.IndexOf(Trim(cmbPopulatedPoint.Text))=-1 then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[lbPopulatedPoint.Caption]));
      cmbPopulatedPoint.SetFocus;
      Result:=false;
      exit;
    end;
 }
 if TypeOperation=toLand then
    cmbStreet.ItemIndex:=1;

{  if Trim(edFloor.Text)<>'' then begin
    if not isInteger(edFloor.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbFloor.Caption]));
      edFloor.SetFocus;
      Result:=false;
      exit;
    end;
  end;}
  if Trim(edCountFloor.Text)<>'' then begin
    if not isInteger(edCountFloor.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbCountFloor.Caption]));
      edCountFloor.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if Trim(edGeneralArea.Text)<>'' then begin
    if not isFloat(edGeneralArea.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbGeneralArea.Caption]));
      edGeneralArea.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if Trim(edDwellingArea.Text)<>'' then begin
    if not isFloat(edDwellingArea.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbDwellingArea.Caption]));
      edDwellingArea.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if Trim(edKitchenArea.Text)<>'' then begin
    if not isFloat(edKitchenArea.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbKitchenArea.Caption]));
      edKitchenArea.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if Trim(edgroundArea.Text)<>'' then begin
    if not isFloat(edgroundArea.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbgroundArea.Caption]));
      edgroundArea.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if Trim(edPrice.Text)<>'' then begin
    if not isFloat(edPrice.Text) then begin
      ShowErrorEx(Format(ConstFieldFormatInvalid,[lbPrice.Caption]));
      edPrice.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if cmbStation.Items.IndexOf(Trim(cmbStation.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbStation.Caption]));
    cmbStation.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbAgent.Items.IndexOf(Trim(cmbAgent.Text))=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAgent.Caption]));
    cmbAgent.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Premises.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Premises.FormCreate(Sender: TObject);
var
  dt: TDateTime;
begin
  inherited;
  FTypeOperation:=toSale;
  EnabledAdjust:=true;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  dt:=_GetWorkDate;
  dtpDateArrivalsFrom.DateTime:=dt;
  dtpDateArrivalsFrom.Checked:=false;
  dtpDateArrivalsTo.DateTime:=dt;
  dtpDateArrivalsTo.Checked:=false;

  cmbRecyled.ItemIndex:=0;
  
  edContact1.MaxLength:=DomainShortNameLength;
  edContact2.MaxLength:=DomainShortNameLength;
  edContact3.MaxLength:=DomainShortNameLength;
  edContact4.MaxLength:=DomainShortNameLength;
  ComboBoxClientInfo.MaxLength:=DomainShortNameLength;
  edContact_1.MaxLength:=DomainShortNameLength;
  edContact_2.MaxLength:=DomainShortNameLength;
  edContact_3.MaxLength:=DomainShortNameLength;
  edContact_4.MaxLength:=DomainShortNameLength;
  ComboBoxClientInfo_.MaxLength:=DomainShortNameLength;

  cmbRegion.MaxLength:=DomainNameLength;
  cmbCityRegion.MaxLength:=DomainNameLength;
  cmbStreet.MaxLength:=DomainNameLength;
  edHouseNumber.MaxLength:=DomainShortNameLength;
  edApartmentNumber.MaxLength:=DomainShortNameLength;
  edFloor.MaxLength:=DomainShortNameLength;
  edCountFloor.MaxLength:=DomainIntegerLength;
  cmbCountRoom.MaxLength:=DomainShortNameLength;
  cmbTypeRoom.MaxLength:=DomainShortNameLength;
  cmbPlanning.MaxLength:=DomainShortNameLength;
  edGeneralArea.MaxLength:=DomainNameMoney;
  edgroundArea.MaxLength:=DomainNameMoney;
  edDwellingArea.MaxLength:=DomainNameMoney;
  edKitchenArea.MaxLength:=DomainNameMoney;
  cmbStation.MaxLength:=DomainShortNameLength;
  cmbPhone.MaxLength:=DomainShortNameLength;
  cmbPhone.Font.Assign(fmOptions.edPhoneColumn.Font);
  cmbBalcony.MaxLength:=DomainShortNameLength;
  cmbSanitaryNode.MaxLength:=DomainShortNameLength;
  cmbCondition.MaxLength:=DomainShortNameLength;
  cmbStove.MaxLength:=DomainShortNameLength;
  cmbDocument.MaxLength:=DomainShortNameLength;
  cmbFurniture.MaxLength:=DomainShortNameLength;
  cmbTaxes.MaxLength:=DomainShortNameLength;
  cmbDoor.MaxLength:=DomainShortNameLength;
  edTerm.MaxLength:=DomainShortNameLength;
  edPayment.MaxLength:=DomainShortNameLength;
  edPrice.MaxLength:=DomainNameMoney;
  edNote.MaxLength:=DomainNoteLength;
  edAdvertismentNote.MaxLength:=DomainNoteLength;
  cmbAgent.MaxLength:=DomainShortNameLength;
  cmbSaleStatus.MaxLength:=DomainShortNameLength;
  cmbSelfForm.MaxLength:=DomainShortNameLength;
  cmbTypePremises.MaxLength:=DomainShortNameLength;
  cmbUnitPrice.MaxLength:=DomainShortNameLength;
  cmbPricePlus.ItemIndex:=0;

  edNN.MaxLength:=DomainShortNameLength;
  edDelivery.MaxLength:=DomainShortNameLength;
  cmbWater.MaxLength:=DomainShortNameLength;
  cmbBuilder.MaxLength:=DomainShortNameLength;
  cmbHeat.MaxLength:=DomainShortNameLength;
  cmbStyle.MaxLength:=DomainShortNameLength;

  edAreaBuilding.MaxLength:=DomainShortNameLength;
  cmbPopulatedPoint.MaxLength:=DomainShortNameLength;
  cmbLandFeature.MaxLength:=DomainShortNameLength;
  edLandMark.MaxLength:=DomainShortNameLength;
  cmbExchangeFormula.MaxLength:=DomainShortNameLength;
  cmbLocationStatus.MaxLength:=DomainShortNameLength;
  cbLeaseOrSale.MaxLength:=DomainShortNameLength;
  edcommunications.MaxLength:=DomainShortNameLength;
  edEmail.MaxLength:=DomainShortNameLength;
  edEmail_.MaxLength:=DomainShortNameLength;

  cmbObject.MaxLength:=DomainShortNameLength;
  cmbDirection.MaxLength:=DomainShortNameLength;
  cmbAccessWays.MaxLength:=DomainShortNameLength;
  edRemoteness.MaxLength:=DomainShortNameLength;


  edDecoration.MaxLength:=DomainShortNameLength;
  edGlassy.MaxLength:=DomainShortNameLength;
  edBlockSection.MaxLength:=DomainShortNameLength;
  edPrice2.MaxLength:=DomainNameMoney;

  LoadFromIni;
end;

procedure TfmEditRBPms_Premises.SetTypeOperation(Value: TTypeOperation);

  function GetCaption: String;
  begin
    Result:='';
    case TypeEditRBook of
       terbNone: Result:='';
       terbAdd: Result:=CaptionAdd;
       terbChange: Result:=CaptionChange;
       terbView: Result:=CaptionView;
       terbFilter: Result:=CaptionFilter;
    end;
  end;
var
 CompinentInd:integer;
begin
  FTypeOperation:=Value;


  for CompinentInd:=0 to Self.ComponentCount-1
   do begin
    if Self.Components[CompinentInd] is TControl then begin
       TControl(Self.Components[CompinentInd]).Visible:=true;
     end;
   end;
  lbTo. Visible:=False;
  dtpDateArrivalsTo.Visible:=False;
  btPeriod.Visible:=False;
  cmbPricePlus.Visible:=False;
  cbAdverisment.Visible:= False;
  cmbTaxes.Visible:=False;
  bibPrev.Visible:=false;
  bibNext.Visible:=false;
  lbHouse.Caption:='Дом';


  case FTypeOperation of
    toSale: Caption:=GetCaption+' - Продажа';
    toLease: Caption:=GetCaption+' - Аренда';
    toShare: Caption:=GetCaption+' - Долевое';
    toLand: Caption:=GetCaption+' - Земля';
  end;
  case FTypeOperation of
    toLease: begin
      lbSaleStatus.Visible:=false;
      cmbSaleStatus.Visible:=false;
      lbSelfForm.Visible:=false;
      cmbSelfForm.Visible:=false;
      lbTypePremises.Visible:=false;
      cmbTypePremises.Visible:=false;
      lbCondition.Visible:=false;
      cmbCondition.Visible:=false;
      lbDocument.Visible:=false;
      cmbDocument.Visible:=false;

      lbFurniture.Visible:=true;
      cmbFurniture.Visible:=true;
      lbTaxes.Visible:=false;
      cmbTaxes.Visible:=false;

      lbDoor.Visible:=true;
      cmbDoor.Visible:=true;
      lbTerm.Visible:=true;
      edTerm.Visible:=true;
      lbPayment.Visible:=true;
      edPayment.Visible:=true;
      lbDelivery.Visible:=false;
      edDelivery.Visible:=false;
      lbBuilder.Visible:=false;
      cmbBuilder.Visible:=false;

      lbBlockSection.Visible:=false;
      edBlockSection.Visible:=false;
      lbDecoration.Visible:=false;
      edDecoration.Visible:=false;
      lbGlassy.Visible:=false;
      edGlassy.Visible:=false;
      lbPrice2.Visible:=false;
      edPrice2.Visible:=false;

      edAreaBuilding.Visible:=false;
      cmbPopulatedPoint.Visible:=false;
      cmbLandFeature.Visible:=false;
      edLandMark.Visible:=false;
      cmbExchangeFormula.Visible:=false;
      cmbLocationStatus.Visible:=false;
      cbLeaseOrSale.Visible:=false;
      edCommunications.Visible:=false;
      edCommunications_.Visible:=false;
      edEmail.Visible:=false;
      edEmail_.Visible:=false;

      cmbObject.Visible:=false;
      cmbDirection.Visible:=false;
      cmbAccessWays.Visible:=false;
      edRemoteness.Visible:=false;
      lbObject.Visible:=false;
      lbDirection.Visible:=false;
      lbAccessWays.Visible:=false;
      lbRemoteness.Visible:=false;


      lbAreaBuilding.Visible:=false;
      lbPopulatedPoint.Visible:=false;
      lbLandFeature.Visible:=false;
      lbLandMark.Visible:=false;
      lbExchangeFormula.Visible:=false;
      lbLocationStatus.Visible:=false;
      lbLeaseOrSale.Visible:=false;
      lbcommunications.Visible:=false;
      lbEmail.visible:=false;
      lbEmail_.visible:=false;
    end;
    toSale: begin
      lbSaleStatus.Visible:=true;
      cmbSaleStatus.Visible:=true;
      lbSelfForm.Visible:=true;
      cmbSelfForm.Visible:=true;
      lbTypePremises.Visible:=true;
      cmbTypePremises.Visible:=true;
      lbCondition.Visible:=true;
      cmbCondition.Visible:=true;
      lbDocument.Visible:=true;
      cmbDocument.Visible:=true;

      lbFurniture.Visible:=false;
      cmbFurniture.Visible:=false;
      lbTaxes.Visible:=true;
      cmbTaxes.Visible:=true;
      lbDoor.Visible:=false;
      cmbDoor.Visible:=false;
      lbTerm.Visible:=false;
      edTerm.Visible:=false;
      lbPayment.Visible:=false;
      edPayment.Visible:=false;
      lbDelivery.Visible:=false;
      edDelivery.Visible:=false;
      lbBuilder.Visible:=false;
      cmbBuilder.Visible:=false;

      edAreaBuilding.Visible:=false;
      cmbPopulatedPoint.Visible:=false;
      cmbLandFeature.Visible:=false;
      edLandMark.Visible:=false;
      cmbExchangeFormula.Visible:=false;
      cmbLocationStatus.Visible:=false;
      cbLeaseOrSale.Visible:=false;
      edCommunications.Visible:=false;
      edCommunications_.Visible:=false;
      edEmail.Visible:=false;
      edEmail_.Visible:=false;

      lbAreaBuilding.Visible:=false;
      lbPopulatedPoint.Visible:=false;
      lbLandFeature.Visible:=false;
      lbLandMark.Visible:=false;
      lbExchangeFormula.Visible:=false;
      lbLocationStatus.Visible:=false;
      lbLeaseOrSale.Visible:=false;
      lbcommunications.Visible:=false;
      lbEmail.visible:=false;
      lbEmail_.visible:=false;

      cmbObject.Visible:=false;
      cmbDirection.Visible:=false;
      cmbAccessWays.Visible:=false;
      edRemoteness.Visible:=false;
      lbObject.Visible:=false;
      lbDirection.Visible:=false;
      lbAccessWays.Visible:=false;
      lbRemoteness.Visible:=false;

    end;
    toLand: begin
      lbClientInfo.Caption:='Собственник(Инвестор)';
      lbClientInfo_.Caption:='Собственник(Инвестор)';
      lbSaleStatus.Visible:=true;
      cmbSaleStatus.Visible:=true;
      lbSelfForm.Visible:=true;
      lbSelfForm.Caption:='Право:';
      cmbSelfForm.Visible:=true;
      lbTypePremises.Visible:=true;
      cmbTypePremises.Visible:=true;
      lbCondition.Visible:=true;
      cmbCondition.Visible:=true;
      lbDocument.Visible:=true;
      cmbDocument.Visible:=true;

      lbFurniture.Visible:=false;
      cmbFurniture.Visible:=false;
      lbTaxes.Visible:=true;
      cmbTaxes.Visible:=true;
      lbDoor.Visible:=false;
      cmbDoor.Visible:=false;
      lbTerm.Visible:=false;
      edTerm.Visible:=false;
      lbPayment.Visible:=false;
      edPayment.Visible:=false;
      lbDelivery.Visible:=false;
      edDelivery.Visible:=false;
      lbBuilder.Visible:=false;
      cmbBuilder.Visible:=false;

      cmbCityRegion.Visible:=true;
      edAreaBuilding.Visible:=true;
      cmbPopulatedPoint.Visible:=false;
      cmbLandFeature.Visible:=true;
      edLandMark.Visible:=true;
      cmbExchangeFormula.Visible:=false;
      cmbLocationStatus.Visible:=false;
      cbLeaseOrSale.Visible:=true;
      lbAreaBuilding.Visible:=true;
      lbPopulatedPoint.Visible:=false;
      lbLandFeature.Visible:=true;
      lbLandMark.Visible:=true;
      lbExchangeFormula.Visible:=false;
      lbLocationStatus.Visible:=false;
      lbLeaseOrSale.Visible:=true;

      edcommunications.Visible:=true;
      lbcommunications.Visible:=true;
      edEmail.Visible:=true;
      lbEmail.visible:=true;
      edEmail_.Visible:=true;
      lbEmail_.visible:=true;

      cmbObject.Visible:=true;
      cmbDirection.Visible:=true;
      cmbAccessWays.Visible:=true;
      edRemoteness.Visible:=true;
      lbObject.Visible:=true;
      lbDirection.Visible:=true;
      lbAccessWays.Visible:=true;
      lbRemoteness.Visible:=true;
      lbCityRegion.Caption:='Район:';
      lbCityRegion.Visible:=TRUE;
      lbRegion.Caption:='Насел. пункт:';
      lbStreet.Visible:=false;
      cmbStreet.Visible:=false;
      lbHouse.Visible:=false;
      edHouseNumber.Visible:=false;
      lbHouseNumber.Visible:=false;

      ed4.Visible:=false;
      edContact4.Visible:=false;
      lbContact4.Visible:=false;

      ed_4.Visible:=false;
      edContact_4.Visible:=false;
      lbContact_4.Visible:=false;

      lbApartmentNumber.Visible:=false;
      edApartmentNumber.Visible:=false;
      lbBlockSection.Visible:=false;
      edBlockSection.Visible:=false;
      lbFloor.Visible:=false;
      edFloor.Visible:=false;
     // lbHouse.Caption:='Постройки';
      lbCountFloor.Visible:=true;
      edCountFloor.Visible:=true;
      lbTypeHouse.Visible:=true;
      lbTypeHouse.Caption:='Мат. стен:';
      cmbTypeHouse.Visible:=true;
      lbHouse.Visible:=true;
      bvHouse.Visible:=true;
      lbCountRoom.Visible:=false;
      lbTypeRoom.Visible:=false;
      lbPlanning.Visible:=false;
      lbGeneralArea.Visible:=true;
      lbDwellingArea.Visible:=false;
      lbKitchenArea.Visible:=false;
      lbPhone.Visible:=false;
      lbBalcony.Visible:=false;
      lbSanitaryNode.Visible:=true;
      lbCondition.Visible:=true;
      lbStove.Visible:=false;
      lbFurniture.Visible:=false;
      lbDoor.Visible:=false;
      lbDocument.Visible:=false;
      lbTypePremises.Visible:=false;
      cmbCountRoom.Visible:=false;
      cmbTypeRoom.Visible:=false;
      cmbPlanning.Visible:=false;
      edGeneralArea.Visible:=true;
      edDwellingArea.Visible:=false;
      edKitchenArea.Visible:=false;
      cmbPhone.Visible:=false;
      cmbBalcony.Visible:=false;
      cmbSanitaryNode.Visible:=true;
      cmbCondition.Visible:=true;
      cmbStove.Visible:=false;
      cmbFurniture.Visible:=false;
      cmbDoor.Visible:=false;
      cmbDocument.Visible:=false;
      btPlanning.Visible:=false;
      cmbTypePremises.Visible:=false;
      lbApartment.Visible:=false;
      lbGroundArea.Visible:=true;
      edGroundArea.Visible:=true;
      lbWater.Visible:=true;
      cmbWater.Visible:=true;
      lbWater.Caption:='Вода:';
      lbHeat.Visible:=true;
      cmbHeat.Visible:=true;
      lbStyle.Visible:=true;
      cmbStyle.Visible:=true;
      lbBuilder.Visible:=false;
      cmbBuilder.Visible:=false;
      lbDelivery.Visible:=false;
      edDelivery.Visible:=false;
      lbBlockSection.Visible:=false;
      edBlockSection.Visible:=false;
      lbDecoration.Visible:=false;
      edDecoration.Visible:=false;
      lbGlassy.Visible:=false;
      edGlassy.Visible:=false;
      lbPrice2.Visible:=false;
      edPrice2.Visible:=false;
      bibAdvertisment.Visible:=false;
      cmbTypeRoom.Visible:=false;

      edGeneralArea.Left:=495;
      cmbCondition.Left:=495;
      cmbSanitaryNode.Left:=495;
      cmbHeat.Left:=495;

      edGeneralArea.Top:=206;
      cmbCondition.Top:=230;
      cmbSanitaryNode.Top:=254;
      cmbHeat.Top:=278;

      lbGeneralArea.Left:=484-lbGeneralArea.Width;
      lbCondition.Left:=484-lbCondition.Width;
      lbSanitaryNode.Left:=484-lbSanitaryNode.Width;
      lbHeat.Left:=484-lbHeat.Width;
      lbGeneralArea.Top:=209;
      lbCondition.Top:=227;
      lbSanitaryNode.Top:=257;
      lbHeat.Top:=281;

      cmbObject.Left:=118;
      edGroundArea.Left:=118;
      cmbLandFeature.Left:=118;
      cmbSelfForm.Left:=118;
      cmbWater.Left:=118;
      edCommunications.Left:=118;
      cmbAccessWays.Left:=118;
      edAreaBuilding.Left:=118;
      edRemoteness.Left:=118;

      cmbObject.Top:=274;
      edGroundArea.Top:=298;
      cmbLandFeature.Top:=322;
      cmbSelfForm.Top:=346;
      cmbWater.Top:=370;
      edCommunications.Top:=394;
      cmbAccessWays.Top:=418;
      edAreaBuilding.Top:=442;
      edRemoteness.Top:=466;

      lbObject.Left:=107-lbObject.Width;
      lbGroundArea.Left:=107-lbGroundArea.Width;
      lbLandFeature.Left:=107-lbLandFeature.Width;
      lbSelfForm.Left:=107-lbSelfForm.Width;
      lbWater.Left:=107-lbWater.Width;
      lbCommunications.Left:=107-lbCommunications.Width;
      lbAccessWays.Left:=107-lbAccessWays.Width;
      lbAreaBuilding.Left:=107-lbAreaBuilding.Width;
      lbRemoteness.Left:=107-lbRemoteness.Width;

      lbObject.Top:=278;
      lbGroundArea.Top:=278+24-6;
      lbLandFeature.Top:=278+48;
      lbSelfForm.Top:=278+72;
      lbWater.Top:=278+96;
      lbCommunications.Top:=278+120;
      lbAccessWays.Top:=278+144;
      lbAreaBuilding.Top:=278+168;
      lbRemoteness.Top:=278+192;

      lbApartment.Caption:='Оъект';
      Bevel3.Width:=295;
      lbApartment.Visible:=true;
      cmbTypeHouse.Width:=60;
      edCountFloor.Left:=495;
      lbCountFloor.left:=484-lbCountFloor.Width;

    end;
    toShare: begin
      lbSaleStatus.Visible:=true;
      cmbSaleStatus.Visible:=true;
      lbSelfForm.Visible:=true;
      cmbSelfForm.Visible:=true;
      lbTypePremises.Visible:=true;
      cmbTypePremises.Visible:=true;
      lbCondition.Visible:=true;
      cmbCondition.Visible:=true;
      lbDocument.Visible:=true;
      cmbDocument.Visible:=true;
      lbBuilder.Visible:=true;
      cmbBuilder.Visible:=true;
      lbDelivery.Visible:=true;
      edDelivery.Visible:=true;

      lbFurniture.Visible:=false;
      cmbFurniture.Visible:=false;
      lbTaxes.Visible:=false;
      cmbTaxes.Visible:=false;
      lbDoor.Visible:=false;
      cmbDoor.Visible:=false;
      lbTerm.Visible:=false;
      edTerm.Visible:=false;
      lbPayment.Visible:=false;
      edPayment.Visible:=false;
      lbGroundArea.Visible:=false;
      edGroundArea.Visible:=false;

      edAreaBuilding.Visible:=false;
      cmbPopulatedPoint.Visible:=false;
      cmbLandFeature.Visible:=false;
      edLandMark.Visible:=false;
      cmbExchangeFormula.Visible:=false;
      cmbLocationStatus.Visible:=false;
      cbLeaseOrSale.Visible:=false;
      edCommunications.Visible:=false;
      edCommunications_.Visible:=false;
      
      edEmail.Visible:=false;
      edEmail_.Visible:=false;

      lbAreaBuilding.Visible:=false;
      lbPopulatedPoint.Visible:=false;
      lbLandFeature.Visible:=false;
      lbLandMark.Visible:=false;
      lbExchangeFormula.Visible:=false;
      lbLocationStatus.Visible:=false;
      lbLeaseOrSale.Visible:=false;
      lbcommunications.Visible:=false;
      lbEmail.visible:=false;
      lbEmail_.visible:=false;

      cmbObject.Visible:=false;
      cmbDirection.Visible:=false;
      cmbAccessWays.Visible:=false;
      edRemoteness.Visible:=false;
      lbObject.Visible:=false;
      lbDirection.Visible:=false;
      lbAccessWays.Visible:=false;
      lbRemoteness.Visible:=false;

    end;
  end;
  LoadFromIni;
end;

procedure TfmEditRBPms_Premises.btPeriodClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=ReadParam(ClassName,'period',P.TypePeriod);
   P.DateBegin:=dtpDateArrivalsFrom.DateTime;
   P.DateEnd:=dtpDateArrivalsTo.DateTime;
   if _ViewEnterPeriod(P) then begin
     dtpDateArrivalsFrom.DateTime:=P.DateBegin;
     dtpDateArrivalsTo.DateTime:=P.DateEnd;
     WriteParam(ClassName,'period',P.TypePeriod);
     ChangeFlag:=true;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
end;

procedure TfmEditRBPms_Premises.FillRegion;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Region,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbRegion.Items.BeginUpdate;
    try
      cmbRegion.Items.Clear;
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_region_id');
        cmbRegion.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbRegion.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillCityRegion;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_City_Region,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbCityRegion.Items.BeginUpdate;
    try
      cmbCityRegion.Items.Clear;
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_city_region_id');
        cmbCityRegion.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbCityRegion.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillStreet;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkPms_Street,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbStreet.Items.BeginUpdate;
    try
      cmbStreet.Items.Clear;
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Street_id');
        cmbStreet.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbStreet.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillBalcony;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Balcony,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbBalcony.Items.BeginUpdate;
    try
      cmbBalcony.Items.Clear;
      cmbBalcony.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Balcony_id');
        cmbBalcony.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbBalcony.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillCondition;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Condition,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbCondition.Items.BeginUpdate;
    try
      cmbCondition.Items.Clear;
      cmbCondition.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Condition_id');
        cmbCondition.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbCondition.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillSanitaryNode;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_SanitaryNode,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbSanitaryNode.Items.BeginUpdate;
    try
      cmbSanitaryNode.Items.Clear;
      cmbSanitaryNode.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_SanitaryNode_id');
        cmbSanitaryNode.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbSanitaryNode.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillWater;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Water,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbWater.Items.BeginUpdate;
    try
      cmbWater.Items.Clear;
      cmbWater.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Water_id');
        cmbWater.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbWater.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillBuilder;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Builder,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbBuilder.Items.BeginUpdate;
    try
      cmbBuilder.Items.Clear;
      cmbBuilder.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Builder_id');
        cmbBuilder.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbBuilder.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillInvestor;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Investor,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    ComboBoxClientInfo.Items.BeginUpdate;
    try
      ComboBoxClientInfo.Items.Clear;
      ComboBoxClientInfo.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Investor_id');
        ComboBoxClientInfo.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      ComboBoxClientInfo.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillStyle;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Style,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbStyle.Items.BeginUpdate;
    try
      cmbStyle.Items.Clear;
      cmbStyle.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Style_id');
        cmbStyle.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbStyle.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillHeat;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Heat,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbHeat.Items.BeginUpdate;
    try
      cmbHeat.Items.Clear;
      cmbHeat.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Heat_id');
        cmbHeat.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbHeat.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillAgent(All: Boolean; SyncOfficeId: Integer);
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if not All then
    TPRBI.Condition.WhereStr:=PChar(' a.sync_office_id='+IntToStr(SyncOfficeId)+' ');
  if _ViewInterfaceFromName(NameRbkPms_Agent,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbAgent.Items.BeginUpdate;
    try
      cmbAgent.Items.Clear;
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Agent_id');
        cmbAgent.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbAgent.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillDoor;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Door,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbDoor.Items.BeginUpdate;
    try
      cmbDoor.Items.Clear;
      cmbDoor.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Door_id');
        cmbDoor.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbDoor.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillPhone;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Phone,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbPhone.Items.BeginUpdate;
    try
      cmbPhone.Items.Clear;
      cmbPhone.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Phone_id');
        cmbPhone.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbPhone.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillCountRoom;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_CountRoom,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbCountRoom.Items.BeginUpdate;
    try
      cmbCountRoom.Items.Clear;
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_CountRoom_id');
        cmbCountRoom.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbCountRoom.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillTypeRoom;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_TypeRoom,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbTypeRoom.Items.BeginUpdate;
    try
      cmbTypeRoom.Items.Clear;
      cmbTypeRoom.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_TypeRoom_id');
        cmbTypeRoom.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbTypeRoom.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillPlanning;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Planning,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbPlanning.Items.BeginUpdate;
    try
      cmbPlanning.Items.Clear;
      cmbPlanning.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Planning_id');
        cmbPlanning.Items.AddObject(sname,TObject(Pointer(id)));
      end;
      if FTypeOperation=toShare then
        if TypeEditRBook=terbAdd then
          if cmbPlanning.Items.Count>2 then
            cmbPlanning.ItemIndex:=1;
    finally
      cmbPlanning.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillStation;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
  Flag: Boolean;
  id100: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkPms_Station,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbStation.Items.BeginUpdate;
    try
      Flag:=(Trim(fmOptions.edForDeleteTorecyled.Text)<>'') and (FoldRecyled=0);
      id100:=fmOptions.edForDeleteTorecyled.Tag;
      cmbStation.Items.Clear;
//      cmbStation.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Station_id');
        if not (Flag and (id=id100)) then begin
          cmbStation.Items.AddObject(sname,TObject(Pointer(id)));
        end;
      end;
    finally
      cmbStation.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillTypeHouse;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_TypeHouse,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbTypeHouse.Items.BeginUpdate;
    try
      cmbTypeHouse.Items.Clear;
      cmbTypeHouse.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_TypeHouse_id');
        cmbTypeHouse.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbTypeHouse.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillStove;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Stove,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbStove.Items.BeginUpdate;
    try
      cmbStove.Items.Clear;
      cmbStove.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Stove_id');
        cmbStove.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbStove.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillFurniture;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Furniture,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbFurniture.Items.BeginUpdate;
    try
      cmbFurniture.Items.Clear;
      cmbFurniture.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Furniture_id');
        cmbFurniture.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbFurniture.Items.EndUpdate;
    end;
  end;
end;

//byBart
procedure TfmEditRBPms_Premises.FillTaxes;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Taxes,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbTaxes.Items.BeginUpdate;
    try
      cmbTaxes.Items.Clear;
      cmbTaxes.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_taxes_id');
        cmbTaxes.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbTaxes.Items.EndUpdate;
    end;
  end;
end;

{procedure TfmEditRBPms_Premises.FillAreaBuilding;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_AreaBuilding,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbAreaBuilding.Items.BeginUpdate;
    try
      cmbAreaBuilding.Items.Clear;
      cmbAreaBuilding.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_AreaBuilding_id');
        cmbAreaBuilding.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbAreaBuilding.Items.EndUpdate;
    end;
  end;
end;
 }
procedure TfmEditRBPms_Premises.FillPopulatedPoint;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_PopulatedPoint,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbPopulatedPoint.Items.BeginUpdate;
    try
      cmbPopulatedPoint.Items.Clear;
      cmbPopulatedPoint.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_PopulatedPoint_id');
        cmbPopulatedPoint.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbPopulatedPoint.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillLandFeature;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_LandFeature,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbLandFeature.Items.BeginUpdate;
    try
      cmbLandFeature.Items.Clear;
      cmbLandFeature.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_LandFeature_id');
        cmbLandFeature.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbLandFeature.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillExchangeFormula;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_ExchangeFormula,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbExchangeFormula.Items.BeginUpdate;
    try
      cmbExchangeFormula.Items.Clear;
      cmbExchangeFormula.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_ExchangeFormula_id');
        cmbExchangeFormula.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbExchangeFormula.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillLocationStatus;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_LocationStatus,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbLocationStatus.Items.BeginUpdate;
    try
      cmbLocationStatus.Items.Clear;
      cmbLocationStatus.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_LocationStatus_id');
        cmbLocationStatus.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbLocationStatus.Items.EndUpdate;
    end;
  end;
end;

{procedure TfmEditRBPms_Premises.FillLandMark;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_LandMark,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbLandMark.Items.BeginUpdate;
    try
      cmbLandMark.Items.Clear;
      cmbLandMark.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_LandMark_id');
        cmbLandMark.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbLandMark.Items.EndUpdate;
    end;
  end;
end;
 }
procedure TfmEditRBPms_Premises.FillObject;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Object,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbObject.Items.BeginUpdate;
    try
      cmbObject.Items.Clear;
      cmbObject.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Object_id');
        cmbObject.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbObject.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillDirection;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Direction,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbDirection.Items.BeginUpdate;
    try
      cmbDirection.Items.Clear;
      cmbDirection.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Direction_id');
        cmbDirection.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbDirection.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillAccessWays;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_AccessWays,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbAccessWays.Items.BeginUpdate;
    try
      cmbAccessWays.Items.Clear;
      cmbAccessWays.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_AccessWays_id');
        cmbAccessWays.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbAccessWays.Items.EndUpdate;
    end;
  end;
end;

//------

procedure TfmEditRBPms_Premises.FillDocument;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Document,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbDocument.Items.BeginUpdate;
    try
      cmbDocument.Items.Clear;
      cmbDocument.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Document_id');
        cmbDocument.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbDocument.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillSaleStatus;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_SaleStatus,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbSaleStatus.Items.BeginUpdate;
    try
      cmbSaleStatus.Items.Clear;
      cmbSaleStatus.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_SaleStatus_id');
        cmbSaleStatus.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbSaleStatus.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillSelfForm;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_SelfForm,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbSelfForm.Items.BeginUpdate;
    try
      cmbSelfForm.Items.Clear;
      cmbSelfForm.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_SelfForm_id');
        cmbSelfForm.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbSelfForm.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillTypePremises;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_TypePremises,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbTypePremises.Items.BeginUpdate;
    try
      cmbTypePremises.Items.Clear;
      cmbTypePremises.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_TypePremises_id');
        cmbTypePremises.Items.AddObject(sname,TObject(Pointer(id)));
      end;
      if TypeEditRBook=terbAdd then
        if cmbTypePremises.Items.Count>2 then
          cmbTypePremises.ItemIndex:=1;
    finally
      cmbTypePremises.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.FillUnitPrice;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_UnitPrice,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbUnitPrice.Items.BeginUpdate;
    try
      cmbUnitPrice.Items.Clear;
      cmbUnitPrice.Items.AddObject('',TObject(Pointer(-1)));
      for i:=s to e do begin

        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_UnitPrice_id');
        cmbUnitPrice.Items.AddObject(sname,TObject(Pointer(id)));
      end;
      if TypeEditRBook=terbAdd then
        case FTypeOperation of
          toSale: cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(fmOptions.edSaleUnitPrice.Text);
          toLand: cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(fmOptions.edSaleUnitPrice.Text);
          toLease: cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(fmOptions.edLeaseUnitPrice.Text);
          toShare: cmbUnitPrice.ItemIndex:=cmbUnitPrice.Items.IndexOf(fmOptions.edShareUnitPrice.Text);
        end;
    finally
      cmbUnitPrice.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.edContact1Change(Sender: TObject);



begin
  inherited;
  ChangeFlag:=true;
  //fmRBPms_Premises.WarningAdvertisment;

end;

procedure TfmEditRBPms_Premises.dtpDateArrivalsFromChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Premises.cmbStreetEnter(Sender: TObject);
begin
  TComboBox(Sender).DroppedDown:=true;
end;

procedure TfmEditRBPms_Premises.cmbStreetKeyDown(Sender: TObject;
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
      CurrentIndex:=TComboBox(Sender).ItemIndex;
      if Shift=[] then
        SelectNext(TWinControl(Sender),true,true)
      else if Shift=[ssSHIFT] then
        SelectNext(TWinControl(Sender),false,true);
      if CurrentIndex>-1 then
        TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[CurrentIndex]
      else TComboBox(Sender).Text:='';
      SendMessage(TComboBox(Sender).Handle, CB_SETCURSEL, CurrentIndex, 0);
    end;
    VK_RETURN: begin
      CurrentIndex:=TComboBox(Sender).ItemIndex;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.cmbStreetKeyUp(Sender: TObject;
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
   case Key of
    VK_DELETE,VK_BACK,VK_TAB,
    VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN:;
    VK_RETURN: begin
      if CurrentIndex>-1 then
        TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[CurrentIndex]
      else TComboBox(Sender).Text:='';
      SendMessage(TComboBox(Sender).Handle, CB_SETCURSEL, CurrentIndex, 0);
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
     CurrentIndex:=val;
    end;
   end;
end;

procedure TfmEditRBPms_Premises.SetContact(Value: string);
var
  Apos: Integer;
  s1: string;
const
  Space=' ';
begin
  APos:=AnsiPos(lbDelim1.Caption,Value);
  if APos>0 then begin
    s1:=Copy(Value,1,Apos-1);
    Value:=Trim(Copy(Value,APos+Length(lbDelim1.Caption),Length(Value)-APos-Length(lbDelim1.Caption)+1));
    Apos:=AnsiPos(Space,s1);
    if Apos>0 then begin
      edContact1.Text:=Copy(s1,1,APos-1);
      ed1.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
    end else edContact1.Text:=s1;
    APos:=AnsiPos(lbDelim2.Caption,Value);
    if APos>0 then begin
      s1:=Copy(Value,1,Apos-1);
      Value:=Trim(Copy(Value,APos+Length(lbDelim1.Caption),Length(Value)-APos-Length(lbDelim1.Caption)+1));
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact2.Text:=Copy(s1,1,APos-1);
        ed2.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact2.Text:=s1;
    end;
    APos:=AnsiPos(lbDelim3.Caption,Value);
    if APos>0 then begin
      s1:=Copy(Value,1,Apos-1);
      Value:=Trim(Copy(Value,APos+Length(lbDelim1.Caption),Length(Value)-APos-Length(lbDelim1.Caption)+1));
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact3.Text:=Copy(s1,1,APos-1);
        ed3.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact3.Text:=s1;
    end;

    if Trim(edContact2.Text)='' then begin
      s1:=Value;
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact2.Text:=Copy(s1,1,APos-1);
        ed2.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact2.Text:=s1;
      exit;
    end;

    if Trim(edContact3.Text)='' then begin
      s1:=Value;
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact3.Text:=Copy(s1,1,APos-1);
        ed3.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact3.Text:=s1;
      exit;
    end;

    s1:=Value;
    Apos:=AnsiPos(Space,s1);
    if Apos>0 then begin
      edContact4.Text:=Copy(s1,1,APos-1);
      ed4.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
    end else edContact4.Text:=s1;

  end else begin
    s1:=Value;
    Apos:=AnsiPos(Space,s1);
    if Apos>0 then begin
      edContact1.Text:=Copy(s1,1,APos-1);
      ed1.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
    end else edContact1.Text:=s1;
  end;
end;

function TfmEditRBPms_Premises.GetContact: string;
var
  s1,s2,s3,s4,s5: string;
const
  Space=' ';
begin
  s1:=Trim(Trim(edContact1.text)+Space+Trim(ed1.text));
  s2:=Trim(Trim(edContact2.text)+Space+Trim(ed2.text));
  s3:=Trim(Trim(edContact3.text)+Space+Trim(ed3.text));
  s4:=Trim(Trim(edContact4.text)+Space+Trim(ed4.text));
  s5:='';
  if ((Trim(s1)<>'')and(Trim(s2)<>''))or
     ((Trim(s1)<>'')and(Trim(s3)<>''))or
     ((Trim(s1)<>'')and(Trim(s4)<>''))or
     ((Trim(s1)<>'')and(Trim(s5)<>''))then
     s1:=s1+lbDelim1.Caption;
  if ((Trim(s2)<>'')and(Trim(s3)<>''))or
     ((Trim(s2)<>'')and(Trim(s4)<>''))or
     ((Trim(s2)<>'')and(Trim(s5)<>''))then
     s2:=s2+lbDelim2.Caption;
  if ((Trim(s3)<>'')and(Trim(s4)<>''))or
     ((Trim(s3)<>'')and(Trim(s5)<>''))then
     s3:=s3+lbDelim3.Caption;
  if ((Trim(s4)<>'')and(Trim(s5)<>''))then
     s4:=s4+lbDelim4.Caption;
  Result:=Trim(s1+s2+s3+s4+s5);
end;

procedure TfmEditRBPms_Premises.SetContact2(Value: string);
var
  Apos: Integer;
  s1: string;
const
  Space=' ';
begin
  APos:=AnsiPos(lbDelim1.Caption,Value);
  if APos>0 then begin
    s1:=Copy(Value,1,Apos-1);
    Value:=Trim(Copy(Value,APos+Length(lbDelim1.Caption),Length(Value)-APos-Length(lbDelim1.Caption)+1));
    Apos:=AnsiPos(Space,s1);
    if Apos>0 then begin
      edContact_1.Text:=Copy(s1,1,APos-1);
      ed_1.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
    end else edContact_1.Text:=s1;
    APos:=AnsiPos(lbDelim2.Caption,Value);
    if APos>0 then begin
      s1:=Copy(Value,1,Apos-1);
      Value:=Trim(Copy(Value,APos+Length(lbDelim1.Caption),Length(Value)-APos-Length(lbDelim1.Caption)+1));
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact_2.Text:=Copy(s1,1,APos-1);
        ed_2.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact_2.Text:=s1;
    end;
    APos:=AnsiPos(lbDelim3.Caption,Value);
    if APos>0 then begin
      s1:=Copy(Value,1,Apos-1);
      Value:=Trim(Copy(Value,APos+Length(lbDelim1.Caption),Length(Value)-APos-Length(lbDelim1.Caption)+1));
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact_3.Text:=Copy(s1,1,APos-1);
        ed_3.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact_3.Text:=s1;
    end;

    if Trim(edContact_2.Text)='' then begin
      s1:=Value;
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact_2.Text:=Copy(s1,1,APos-1);
        ed_2.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact_2.Text:=s1;
      exit;
    end;

    if Trim(edContact_3.Text)='' then begin
      s1:=Value;
      Apos:=AnsiPos(Space,s1);
      if Apos>0 then begin
        edContact_3.Text:=Copy(s1,1,APos-1);
        ed_3.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
      end else edContact_3.Text:=s1;
      exit;
    end;

    s1:=Value;
    Apos:=AnsiPos(Space,s1);
    if Apos>0 then begin
      edContact_4.Text:=Copy(s1,1,APos-1);
      ed_4.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
    end else edContact_4.Text:=s1;

  end else begin
    s1:=Value;
    Apos:=AnsiPos(Space,s1);
    if Apos>0 then begin
      edContact_1.Text:=Copy(s1,1,APos-1);
      ed_1.Text:=Copy(s1,APos+Length(Space),Length(s1)-APos-Length(Space)+1);
    end else edContact_1.Text:=s1;
  end;
end;

function TfmEditRBPms_Premises.GetContact2: string;
var
  s1,s2,s3,s4,s5: string;
const
  Space=' ';
begin
  s1:=Trim(Trim(edContact_1.text)+Space+Trim(ed_1.text));
  s2:=Trim(Trim(edContact_2.text)+Space+Trim(ed_2.text));
  s3:=Trim(Trim(edContact_3.text)+Space+Trim(ed_3.text));
  s4:=Trim(Trim(edContact_4.text)+Space+Trim(ed_4.text));
  s5:='';
  if ((Trim(s1)<>'')and(Trim(s2)<>''))or
     ((Trim(s1)<>'')and(Trim(s3)<>''))or
     ((Trim(s1)<>'')and(Trim(s4)<>''))or
     ((Trim(s1)<>'')and(Trim(s5)<>''))then
     s1:=s1+lbDelim1.Caption;
  if ((Trim(s2)<>'')and(Trim(s3)<>''))or
     ((Trim(s2)<>'')and(Trim(s4)<>''))or
     ((Trim(s2)<>'')and(Trim(s5)<>''))then
     s2:=s2+lbDelim2.Caption;
  if ((Trim(s3)<>'')and(Trim(s4)<>''))or
     ((Trim(s3)<>'')and(Trim(s5)<>''))then
     s3:=s3+lbDelim3.Caption;
  if ((Trim(s4)<>'')and(Trim(s5)<>''))then
     s4:=s4+lbDelim4.Caption;
  Result:=Trim(s1+s2+s3+s4+s5);
end;

procedure TfmEditRBPms_Premises.edContact1Exit(Sender: TObject);
var
  index: Integer;
begin
  index:=-1;
  if Sender is TComboBox then begin
    index:=TComboBox(Sender).ItemIndex;
  end;
  if (TypeEditRBook=terbAdd) or
     (TypeEditRBook=terbChange) then begin
    CheckOther(TControl(Sender));
  end;
  if Sender is TComboBox then begin
    if index>-1 then
      TComboBox(Sender).Text:=TComboBox(Sender).Items.Strings[index];
    SendMessage(TComboBox(Sender).Handle, CB_SETCURSEL, index, 0);
  end;
  if Sender=cmbRegion then
    cmbRegionChange(Sender);
  bibOk.Default:=true;
end;

procedure TfmEditRBPms_Premises.SetEnabledFilter(Value: Boolean);
begin
  dtpDateArrivalsFrom.ShowCheckbox:=true;
  dtpDateArrivalsFrom.Checked:=false;
  lbTo.Visible:=Value;
  dtpDateArrivalsTo.Visible:=Value;
  dtpDateArrivalsTo.ShowCheckbox:=true;
  dtpDateArrivalsTo.Checked:=false;
  btPeriod.Visible:=Value;
  lbRecyled.Visible:=Value;
  cmbRecyled.Visible:=Value;
  cmbPricePlus.Visible:=true;
  edPrice.Left:=cmbPricePlus.Left+cmbPricePlus.Width+2;
  edPrice.Width:=edPrice.Width-cmbPricePlus.Width-2;
  lbBlockSection.Enabled:=not Value;
  edBlockSection.Enabled:=not Value;
  lbDecoration.Enabled:=not Value;
  edDecoration.Enabled:=not Value;
  lbGlassy.Enabled:=not Value;
  edGlassy.Enabled:=not Value;
  lbPrice2.Enabled:=not Value;
  edPrice2.Enabled:=not Value;
end;

procedure TfmEditRBPms_Premises.bibClearClick(Sender: TObject);
var
  OldIndex: Integer;
  ind1: Integer;
begin
  OldIndex:=cmbRecyled.ItemIndex;
  ind1:=cmbPricePlus.ItemIndex;
  inherited bibClearClick(Sender);
  cbAdverisment.Checked:=false;
  cmbPricePlus.ItemIndex:=ind1;
  cmbRecyled.ItemIndex:=OldIndex;
end;

procedure TfmEditRBPms_Premises.SetoldRecyled(Value: Integer);
begin
  FoldRecyled:=Value;
  FNewRecyled:=Value;
  if FoldRecyled<>0 then begin
    lbRecyled.Visible:=true;
    cmbRecyled.Visible:=true;
  end else begin
    lbRecyled.Visible:=false;
    cmbRecyled.Visible:=false;
  end;
end;

procedure TfmEditRBPms_Premises.edPriceKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key in [',','.',DecimalSeparator] then Key:=DecimalSeparator;
end;

procedure TfmEditRBPms_Premises.edContact1KeyPress(
  Sender: TObject; var Key: Char);
begin
  if not isValidIntegerKey(Key) then Key:=#0;
end;

procedure TfmEditRBPms_Premises.cmbRecyledDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);

  procedure DRawImages;
  var
    tmps: string;
    rc: TRect;
    t: Integer;
    newRect: TRect;
    NewIndex: Integer;
    bmp: TBitmap;
  begin
    bmp:=TBitmap.Create;
    try
      tmps:=cmbRecyled.Items.Strings[Index];
      NewIndex:=Index;

      rc.TopLeft:=Rect.TopLeft;
      rc.BottomRight:=Rect.BottomRight;
      rc.Top:=rc.Top;
      rc.Bottom:=rc.Bottom;
      rc.Left:=rc.Left;
      rc.Right:=rc.Left+IL.Width+2;

      newRect.Left:=rc.Right;
      newRect.Top:=Rect.Top;
      newRect.Right:=Rect.Right;
      newRect.Bottom:=Rect.Bottom;

      bmp.Width:=IL.Width;
      bmp.Height:=IL.Height;

      with cmbRecyled.Canvas do begin
       if State<>[odFocused,odSelected] then begin
        FillRect(newRect);
        Brush.Color:=clBtnFace;
        Brush.Style:=bsSolid;
        FillRect(rc);
        IL.Draw(bmp.Canvas,0,0,NewIndex);
        cmbRecyled.Canvas.Draw(rc.Left+1,rc.Top+1,bmp);
       end else begin
        FillRect(newRect);
        Brush.Color:=clBtnFace;
        Brush.Style:=bsSolid;
        FillRect(rc);
        IL.Draw(bmp.Canvas,0,0,NewIndex);
        cmbRecyled.Canvas.Draw(rc.Left+1,rc.Top+1,bmp);
       end;
       Brush.Style:=bsClear;
       Pen.Color:=clWindow;
       Rectangle(rc.left,rc.top,rc.Right,rc.Bottom);
       t:=(rc.Bottom-rc.Top)div 2 -(TextHeight(tmps) div 2);
       t:=rc.top+t;
       TextOut(rc.Right+1,t,tmps);
      end;
    finally
      bmp.Free;
    end;

  end;

begin
  DRawImages;
end;

procedure TfmEditRBPms_Premises.btPlanningClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  pms_planning_id: Variant;
  val: Integer;
  sname: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_planning_id';
  val:=cmbPlanning.Items.IndexOf(cmbPlanning.Text);
  if val<>-1 then begin
    pms_planning_id:=Integer(cmbPlanning.Items.Objects[val]);
  end;
  TPRBI.Locate.KeyValues:=pms_planning_id;
  if _ViewInterfaceFromName(NameRbkPms_Planning,@TPRBI) then begin
    sname:=GetFirstValueFromPRBI(@TPRBI,'name');
    cmbPlanning.ItemIndex:=cmbPlanning.Items.IndexOf(sname);
    ChangeFlag:=true;
  end;
end;

procedure TfmEditRBPms_Premises.CheckOther(Control: TControl);

var
  ExitThis: Boolean;

  function isEmpty: Boolean;
  begin
    Result:=true;
    if Control is TEdit then
      Result:=Trim(TEdit(Control).Text)='';
    if Control is TComboBox then
      Result:=Trim(TComboBox(Control).Text)='';
  end;

  function isCheckByContact: boolean;
  begin
    Result:=false;
    if (Control=edContact1)or
       (Control=edContact2)or
       (Control=edContact3)or
       (Control=edContact4)or
       (Control=edContact_1)or
       (Control=edContact_2)or
       (Control=edContact_3)or
       (Control=edContact_4)then Result:=true;
  end;

  function isCheckByAddress: Boolean;
  begin
    Result:=false;
    if (Control=cmbRegion)or
       (Control=cmbStreet)or
       (Control=edHouseNumber)or
       (Control=edApartmentNumber)then begin
      if (Trim(cmbRegion.Text)<>'')and
         (Trim(cmbStreet.Text)<>'')and
         (Trim(edHouseNumber.Text)<>'')and
         (Trim(edApartmentNumber.Text)<>'')then begin
        Result:=true;
      end;
    end;
  end;

  function GetContactLike: string;
  var
    isContact1,isContact2,isContact3,isContact4: Boolean;
    isContact_1,isContact_2,isContact_3,isContact_4: Boolean;

    addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,addstr8 : string;
    or1,or2,or3,or4,or5,or6,or7: string;
  begin
    isContact1:=Trim(edContact1.Text)<>'';
    isContact2:=Trim(edContact2.Text)<>'';
    isContact3:=Trim(edContact3.Text)<>'';
    isContact4:=Trim(edContact4.Text)<>'';
    isContact_1:=Trim(edContact_1.Text)<>'';
    isContact_2:=Trim(edContact_2.Text)<>'';
    isContact_3:=Trim(edContact_3.Text)<>'';
    isContact_4:=Trim(edContact_4.Text)<>'';

    if isContact1 then begin
      addstr1:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact1.Text))+'%')+' ';
    end;

    if isContact2 then begin
      addstr2:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact2.Text))+'%')+' ';
    end;

    if isContact3 then begin
      addstr3:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact3.Text))+'%')+' ';
    end;

    if isContact4 then begin
      addstr4:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact4.Text))+'%')+' ';
    end;

    if isContact_1 then begin
      addstr5:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact_1.Text))+'%')+' ';
    end;

    if isContact_2 then begin
      addstr6:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact_2.Text))+'%')+' ';
    end;

    if isContact_3 then begin
      addstr7:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact_3.Text))+'%')+' ';
    end;

    if isContact_4 then begin
      addstr8:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact_4.Text))+'%')+' ';
    end;

    if (isContact1 and isContact2)or
       (isContact1 and isContact3)or
       (isContact1 and isContact_1)or
       (isContact1 and isContact_2)or
       (isContact1 and isContact_3)or
       (isContact1 and isContact_4)or
       (isContact1 and isContact4)then or1:=' or ';

    if (isContact2 and isContact3)or
       (isContact2 and isContact_1)or
       (isContact2 and isContact_2)or
       (isContact2 and isContact_3)or
       (isContact2 and isContact_4)or
       (isContact2 and isContact4)then or2:=' or ';

    if (isContact3 and isContact4)or
       (isContact3 and isContact_1)or
       (isContact3 and isContact_2)or
       (isContact3 and isContact_3)or
       (isContact3 and isContact_4)then or3:=' or ';

    if (isContact4 and isContact_1)or
       (isContact4 and isContact_2)or
       (isContact4 and isContact_3)or
       (isContact4 and isContact_4)then or4:=' or ';

    if (isContact_1 and isContact_2)or
       (isContact_1 and isContact_3)or
       (isContact_1 and isContact_4)then or5:=' or ';

    if (isContact_2 and isContact_3)or
       (isContact_2 and isContact_4)then or6:=' or ';

    if (isContact_3 and isContact_4)then or7:=' or ';

    Result:=addstr1+or1+
            addstr2+or2+
            addstr3+or3+
            addstr4+or4+
            addstr5+or5+
            addstr6+or6+
            addstr7+or7+
            addstr8;
  end;

  function GetFilter: string;
  var
    s: string;
  begin
    if isCheckByContact then begin
    {  if Control=edContact1 then begin
        Result:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact1.Text))+'%')+' and ';
      end;
      if Control=edContact2 then begin
        Result:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact1.Text))+'%')+' and '+
                ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact2.Text))+'%')+' and ';
      end;
      if Control=edContact3 then begin
        Result:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact1.Text))+'%')+' and '+
                ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact2.Text))+'%')+' and '+
                ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact3.Text))+'%')+' and ';
      end;
      if Control=edContact4 then begin
        Result:=' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact1.Text))+'%')+' and '+
                ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact2.Text))+'%')+' and '+
                ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact3.Text))+'%')+' and '+
                ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact4.Text))+'%')+' and ';
      end;}
{      Result:=' ( contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact1.Text))+'%')+' or '+
              ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact2.Text))+'%')+' or '+
              ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact3.Text))+'%')+' or '+
              ' contact like '+QuotedStr('%'+AnsiUpperCase(Trim(edContact4.Text))+'%')+' ) and ';}
      s:=GetContactLike;
      Result:=Iff(Trim(s)<>'',' ( '+s+' ) and ','');
      Result:=Result+' typeoperation='+Inttostr(Integer(FTypeOperation))+' '+
              iff(TypeEditRBook=terbChange,' and p.pms_premises_id<>'+inttostr(oldPms_Premises_id)+' ','');
      Result:=Result+' and recyled in (0,1)';
      exit;
    end;
    if isCheckByAddress then begin
      Result:=' Upper(r.name) like '+QuotedStr(AnsiUpperCase(Iff(Trim(cmbRegion.Text)<>'',Trim(cmbRegion.Text),'%%')))+' and '+
              ' Upper(s.name) like '+QuotedStr(AnsiUpperCase(Iff(Trim(cmbStreet.Text)<>'',Trim(cmbStreet.Text),'%%')))+' and '+
              ' Upper(housenumber) like '+QuotedStr(AnsiUpperCase(Iff(Trim(edHouseNumber.Text)<>'',Trim(edHouseNumber.Text),'%%')))+' and '+
              ' Upper(apartmentnumber) like '+QuotedStr(AnsiUpperCase(Iff(Trim(edApartmentNumber.Text)<>'',Trim(edApartmentNumber.Text),'%%')))+' and ';
      Result:=Result+' typeoperation='+Inttostr(Integer(FTypeOperation))+' '+
              iff(TypeEditRBook=terbChange,' and p.pms_premises_id<>'+inttostr(oldPms_Premises_id)+' ','');
    end else ExitThis:=true;
    Result:=Result+' and recyled in (0,1)';
  end;

  function ExistsThis: Boolean;
  var
    TPRBI: TParamRBookInterface;
  begin
    Result:=false;
    ExitThis:=false;
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.SQL.Select:=PChar('Select count(*) as ct from '+tbPms_Premises+' p join '+
                            tbPms_region+' r on p.pms_region_id=r.pms_region_id join '+
                            tbPms_Street+' s on p.pms_street_id=s.pms_street_id ');
    TPRBI.Condition.WhereStr:=PChar(GetFilter);
    if ExitThis then exit;
    if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
      Result:=GetFirstValueFromPRBI(@TPRBI,'ct')>0;
    end;
  end;

  function GetCurrentSyncOfficeId: Integer;
  var
    TPRBI: TParamRbookInterface;
  begin
    Result:=0;
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr('ОФИС')+' ');
    if _ViewInterfaceFromName(NameRbkConst,@TPRBI) then begin
      Result:=StrToInt(GetFirstValueFromPRBI(@TPRBI,'valueview'));
    end;
  end;

var
  TPRBI: TParamRBookInterface;
  T: TParamRBPms_Premises;
  SyncOfficeId: Integer;
begin
  if not fmOptions.chbCheckDoubleOnEdit.Checked then exit;
  if isEmpty then exit;
  if not ExistsThis then exit;
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Condition.WhereStrNoRemoved:=PChar(GetFilter);
  FillChar(T,SizeOf(T),0);
  TPRBI.Param:=@T;
  T.TypeOperation:=Integer(FTypeOperation);
  T.Recyled:=FoldRecyled;
  T.Caption:='Вариант с данным контактом в базе существует';
  T.NotUseRecyled:=true;
  T.AddDisable:=true;
  T.ChangeDisable:=true;
  T.DeleteDisable:=true;
  T.FilterDisable:=true;
  T.NotUseAdvFilter:=true;
  if _ViewInterfaceFromName(NameRbkPms_Premises,@TPRBI) then begin
    oldpms_agent_id:=GetFirstValueFromPRBI(@TPRBI,'pms_agent_id');
    SyncOfficeId:=GetSyncOfficeId(oldpms_agent_id);
    if GetCurrentSyncOfficeId<>SyncOfficeId then begin
      ShowError(Handle,'Изменить вариант другого офиса нельзя.');
      exit;
    end else begin
      TypeEditRBook:=terbChange;
      TypeOperation:=FTypeOperation;
      dtpDateArrivalsFrom.DateTime:=GetFirstValueFromPRBI(@TPRBI,'datearrivals');
      SetContact(GetFirstValueFromPRBI(@TPRBI,'contact'));
      edNN.Text:=GetFirstValueFromPRBI(@TPRBI,'nn');
      ComboBoxClientInfo.Text:=GetFirstValueFromPRBI(@TPRBI,'clientinfo');
      ComboBoxClientInfo_.Text:=GetFirstValueFromPRBI(@TPRBI,'clientinfo');
      cmbRegion.ItemIndex:=cmbRegion.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'regionname'));
      cmbCityRegion.ItemIndex:=cmbCityRegion.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'cityregionname'));
      cmbStreet.ItemIndex:=cmbStreet.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Streetname'));
      edHouseNumber.Text:=GetFirstValueFromPRBI(@TPRBI,'housenumber');
      edApartmentNumber.Text:=GetFirstValueFromPRBI(@TPRBI,'apartmentnumber');
      cmbBalcony.ItemIndex:=cmbBalcony.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'balconyname'));
      cmbCondition.ItemIndex:=cmbCondition.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Conditionname'));
      cmbSanitaryNode.ItemIndex:=cmbSanitaryNode.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'SanitaryNodename'));
      cmbHeat.ItemIndex:=cmbHeat.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Heatname'));
      cmbWater.ItemIndex:=cmbWater.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Watername'));
      edDelivery.Text:=GetFirstValueFromPRBI(@TPRBI,'delivery');
      cmbBuilder.ItemIndex:=cmbBuilder.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Buildername'));
      cmbStyle.ItemIndex:=cmbStyle.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Stylename'));
      cmbAgent.ItemIndex:=cmbAgent.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Agentname'));
      cmbDoor.ItemIndex:=cmbDoor.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Doorname'));
      cmbPhone.ItemIndex:=cmbPhone.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Phonename'));
      cmbCountRoom.ItemIndex:=cmbCountRoom.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'CountRoomname'));
      cmbTypeRoom.ItemIndex:=cmbTypeRoom.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'TypeRoomname'));
      cmbPlanning.ItemIndex:=cmbPlanning.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Planningname'));
      cmbStation.ItemIndex:=cmbStation.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Stationname'));
      cmbTypeHouse.ItemIndex:=cmbTypeHouse.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'TypeHousename'));
      cmbStove.ItemIndex:=cmbStove.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Stovename'));
      cmbFurniture.ItemIndex:=cmbFurniture.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Furniturename'));
      cmbTaxes.ItemIndex:=cmbTaxes.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Taxes'));

      cmbDocument.ItemIndex:=cmbDocument.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Documentname'));
      cmbSaleStatus.ItemIndex:=cmbSaleStatus.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'SaleStatusname'));
      cmbSelfForm.ItemIndex:=cmbSelfForm.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'SelfFormname'));
      cmbTypePremises.ItemIndex:=cmbTypePremises.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'TypePremisesname'));
      edFloor.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'floor',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'floor',false));
      edCountFloor.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'countfloor',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'countfloor',false));
      edGeneralArea.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'generalarea',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'generalarea',false));
      edgroundArea.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'groundArea',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'groundArea',false));
      edDwellingArea.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'dwellingarea',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'dwellingarea',false));
      edKitchenArea.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'kitchenarea',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'kitchenarea',false));
      edTerm.Text:=GetFirstValueFromPRBI(@TPRBI,'term');
      edPayment.Text:=GetFirstValueFromPRBI(@TPRBI,'payment');
      edPrice.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'price',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'price',false));
      edNote.Text:=GetFirstValueFromPRBI(@TPRBI,'note');
      edAdvertismentNote.Text:=GetFirstValueFromPRBI(@TPRBI,'advertisment_note');
      edDecoration.Text:=GetFirstValueFromPRBI(@TPRBI,'decoration');
      edGlassy.Text:=GetFirstValueFromPRBI(@TPRBI,'glassy');
      edBlockSection.Text:=GetFirstValueFromPRBI(@TPRBI,'block_section');
      edPrice2.Text:=Iff(GetFirstValueFromPRBI(@TPRBI,'price2',false)=Null,'',GetFirstValueFromPRBI(@TPRBI,'price2',false));
      FNewRecyled:=GetFirstValueFromPRBI(@TPRBI,'recyled');
      cmbRecyled.ItemIndex:=FNewRecyled;
      cmbRecyled.Visible:=true;

      edAreaBuilding.Text:=GetFirstValueFromPRBI(@TPRBI,'areabuilding');
      cmbPopulatedPoint.ItemIndex:=cmbPopulatedPoint.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'PopulatedPoint'));
      cmbLandFeature.ItemIndex:=cmbLandFeature.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'LandFeature'));
      cmbExchangeFormula.ItemIndex:=cmbExchangeFormula.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'ExchangeFormula'));
      cmbLocationStatus.ItemIndex:=cmbLocationStatus.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'LocationStatus'));
      edLandMark.Text:=GetFirstValueFromPRBI(@TPRBI,'landmark');
      edCommunications.Text:=GetFirstValueFromPRBI(@TPRBI,'communications');
      edEmail.Text:=GetFirstValueFromPRBI(@TPRBI,'email');
      edEmail_.Text:=GetFirstValueFromPRBI(@TPRBI,'email2');
      cbLeaseOrSale.Text:=GetFirstValueFromPRBI(@TPRBI,'LeaseOrSale');

      cmbObject.ItemIndex:=cmbObject.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Object'));
      cmbDirection.ItemIndex:=cmbDirection.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'Direction'));
      cmbAccessWays.ItemIndex:=cmbAccessWays.Items.IndexOf(GetFirstValueFromPRBI(@TPRBI,'AccessWays'));
      edRemoteness.Text:=GetFirstValueFromPRBI(@TPRBI,'Remoteness');


      cmbRecyledChange(nil);

      WhoInsertedEx:=GetFirstValueFromPRBI(@TPRBI,'whoinsert_id');
      WhoInsertedNameEx:=GetFirstValueFromPRBI(@TPRBI,'whoinsertname');
      DateTimeInsertedEx:=GetFirstValueFromPRBI(@TPRBI,'datetimeinsert');
      oldPms_Premises_id:=GetFirstValueFromPRBI(@TPRBI,'Pms_Premises_id');
    end;
  end;
end;

procedure TfmEditRBPms_Premises.cmbRecyledChange(Sender: TObject);
begin
  ChangeFlag:=true;
  isDelete:=(FOldRecyled=FNewRecyled)and(FNewRecyled<>cmbRecyled.ItemIndex);
  isInsert:=(FOldRecyled<>FNewRecyled)and(FNewRecyled<>cmbRecyled.ItemIndex);
  isUpdate:=(FOldRecyled=FNewRecyled)and(FNewRecyled=cmbRecyled.ItemIndex);
end;

procedure TfmEditRBPms_Premises.FormDestroy(Sender: TObject);
begin
  SaveToIni;
  inherited;
end;

function TfmEditRBPms_Premises.GetTabOrdersName: string;
begin
  Result:=inherited GetTabOrdersName+inttostr(Integer(FTypeOperation));
end;

function TfmEditRBPms_Premises.GetSyncOfficeId(pms_agent_id: Integer): Integer;
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
begin
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    Result:=-1;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=IBDB;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:='Select sync_office_id from '+tbPms_Agent+' where pms_agent_id='+IntToStr(pms_agent_id)+' ';
    qr.sql.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then begin
      Result:=qr.FieldByName('sync_office_id').AsInteger;
    end;
  finally
    tran.Free;
    qr.Free;
  end;
end;

procedure TfmEditRBPms_Premises.edContact1Enter(Sender: TObject);
begin
  bibOk.Default:=
  false;
end;

procedure TfmEditRBPms_Premises.edContact1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    edContact1.OnExit:=nil;
    edContact2.OnExit:=nil;
    edContact3.OnExit:=nil;
    edContact4.OnExit:=nil;
    edContact_1.OnExit:=nil;
    edContact_2.OnExit:=nil;
    edContact_3.OnExit:=nil;
    edContact_4.OnExit:=nil;
    try
      edContact1Exit(Sender);
      bibOk.SetFocus;
    finally
      edContact1.OnExit:=edContact1Exit;
      edContact2.OnExit:=edContact1Exit;
      edContact3.OnExit:=edContact1Exit;
      edContact4.OnExit:=edContact1Exit;
      edContact_1.OnExit:=edContact1Exit;
      edContact_2.OnExit:=edContact1Exit;
      edContact_3.OnExit:=edContact1Exit;
      edContact_4.OnExit:=edContact1Exit;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.edPrice2Change(Sender: TObject);
var
  NewValue: Extended;
begin
  ChangeFlag:=true;
  if TypeEditRBook in [terbAdd,terbChange,terbView] then begin
    if (Sender=edPrice2)or(Sender=edGeneralArea) then begin
      if (Trim(edGeneralArea.Text)<>'') and (Trim(edPrice2.Text)<>'') then begin
        if isFloat(Trim(edGeneralArea.Text)) and IsFloat(Trim(edPrice2.Text)) then begin
          edPrice.OnChange:=nil;
          try
            NewValue:=StrToFloat(Trim(edPrice2.Text))*StrToFloat(Trim(edGeneralArea.Text));
            edPrice.Text:=FormatFloat('#.##',NewValue);
            edPrice.Text:=ChangeChar(edPrice.Text,'.',DecimalSeparator);
          finally
            edPrice.OnChange:=edPrice2Change;
          end;
        end;
      end;
    end;
    if Sender=edPrice then begin
      if (Trim(edGeneralArea.Text)<>'') and (Trim(edPrice.Text)<>'') then begin
        if isFloat(Trim(edGeneralArea.Text)) and IsFloat(Trim(edPrice.Text)) then begin
          edPrice2.OnChange:=nil;
          try
            NewValue:=StrToFloat(Trim(edPrice.Text))/StrToFloat(Trim(edGeneralArea.Text));
            edPrice2.Text:=FormatFloat('#.##',NewValue);
            edPrice2.Text:=ChangeChar(edPrice2.Text,'.',DecimalSeparator);
          finally
            edPrice2.OnChange:=edPrice2Change;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.bibAdvertismentClick(Sender: TObject);
var
 fm:TfmAdvertisment_in_Premises;
begin
  inherited;
  fm:=TfmAdvertisment_in_Premises.Create(nil);
   try
    fm.fmParent:=self;
    fm.isView:=isView;
    fm.Pms_Premises_id:=OldPms_Premises_id;
    fm.Pms_Agent_id:=Oldpms_Agent_id;
    fm.TypeOperation:=Integer(FTypeOperation);
    fm.ActiveQuery;
    fm.ShowModal;
   finally
    fm.Free;
   end;
end;

procedure TfmEditRBPms_Premises.cmbRegionChange(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
  region_id, city_region_id:integer;
begin
  if TypeEditRBook in [terbAdd,terbChange] then begin
    cmbCityRegion.ItemIndex:=cmbCityRegion.Items.IndexOf(cmbCityRegion.Text);
    cmbDirection.ItemIndex:=cmbDirection.Items.IndexOf(cmbDirection.Text);
    if (cmbRegion.ItemIndex<>-1) and (cmbCityRegion.ItemIndex=-1) and (cmbDirection.ItemIndex=-1) then begin
      region_id:=integer(cmbRegion.Items.Objects[cmbRegion.ItemIndex]);
      FillChar(TPRBI,SizeOf(TPRBI),0);
      TPRBI.Visual.TypeView:=tviOnlyData;
      TPRBI.Condition.WhereStr:=PChar(Format('PRC.pms_region_id=%d',[region_id]));
      if _ViewInterfaceFromName(NameRbkPms_Regions_Correspond,@TPRBI) then begin
        GetStartAndEndByPRBI(@TPRBI,s,e);
        for i:=s to e do begin
          sname:=GetValueByPRBI(@TPRBI,i,'CITY_REGION');
          id:=GetValueByPRBI(@TPRBI,i,'pms_region_id');
          if id=region_id then  begin
            if trim(sname)<>'' then begin
              cmbCityRegion.ItemIndex:=cmbCityRegion.Items.IndexOf(sname);
              ChangeFlag:=true;
            end;
        //    exit;
          end;
        end;
      end;
      city_region_id:=integer(cmbCityRegion.Items.Objects[cmbCityRegion.ItemIndex]);
      FillChar(TPRBI,SizeOf(TPRBI),0);
      TPRBI.Visual.TypeView:=tviOnlyData;
      TPRBI.Condition.WhereStr:=PChar(Format('PDC.pms_city_region_id=%d',[city_region_id]));
      if _ViewInterfaceFromName(NameRbkPms_Direction_Correspond,@TPRBI) then begin
        GetStartAndEndByPRBI(@TPRBI,s,e);
        for i:=s to e do begin
          sname:=GetValueByPRBI(@TPRBI,i,'DIRECTION');
          id:=GetValueByPRBI(@TPRBI,i,'pms_city_region_id');
          if id=city_region_id then  begin
            if trim(sname)<>'' then begin
              cmbDirection.ItemIndex:=cmbDirection.Items.IndexOf(sname);
              ChangeFlag:=true;
            end;
            exit;
          end;
        end;
      end;

    end;
  end;
end;

procedure TfmEditRBPms_Premises.ComboBoxClientInfoChange(Sender: TObject);
var
  Index: Integer;
  TPRBI: TParamRBookInterface;
  Id: Integer;
  Phones: TStringList;
  i: Integer;
  S: String;
begin
  ChangeFlag:=true;
  Index:=ComboBoxClientInfo.ItemIndex;
  if Index>0 then begin
    Id:=Integer(ComboBoxClientInfo.Items.Objects[Index]);
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(Format(' PMS_INVESTOR_ID=%d ',[Id]));
    if _ViewInterfaceFromName(NameRbkPms_Investor,@TPRBI) then begin
      Phones:=TStringList.Create;
      try
        Phones.Text:=GetFirstValueFromPRBI(@TPRBI,'PHONES');
        for i:=0 to Phones.Count-1 do begin
          S:=Trim(Phones.Strings[i]);
          if i=0 then
            edContact1.Text:=S;
          if i=1 then
            edContact2.Text:=S;
          if i=2 then
            edContact3.Text:=S;
          if i=3 then
            edContact4.Text:=S;
        end;
        ChangeFlag:=true;
      finally
        Phones.Free;
      end;
    end;
  end;
end;

procedure TfmEditRBPms_Premises.cmbStationChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
  if isEdit then fmRBPms_Premises.WarningAdvertisment;
end;

procedure TfmEditRBPms_Premises.ComboBoxClientInfo_Change(Sender: TObject);
var
  Index: Integer;
  TPRBI: TParamRBookInterface;
  Id: Integer;
  Phones: TStringList;
  i: Integer;
  S: String;
begin
  ChangeFlag:=true;
  Index:=ComboBoxClientInfo_.ItemIndex;
  if Index>0 then begin
    Id:=Integer(ComboBoxClientInfo_.Items.Objects[Index]);
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(Format(' PMS_INVESTOR_ID=%d ',[Id]));
    if _ViewInterfaceFromName(NameRbkPms_Investor,@TPRBI) then begin
      Phones:=TStringList.Create;
      try
        Phones.Text:=GetFirstValueFromPRBI(@TPRBI,'PHONES');
        for i:=0 to Phones.Count-1 do begin
          S:=Trim(Phones.Strings[i]);
          if i=0 then
            edContact_1.Text:=S;
          if i=1 then
            edContact_2.Text:=S;
          if i=2 then
            edContact_3.Text:=S;
          if i=3 then
            edContact_4.Text:=S;
        end;
        ChangeFlag:=true;
      finally
        Phones.Free;
      end;
    end;
  end;
end;



end.



