unit URBPms_Premises;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL,
  ComCtrls, ImgList, UMainUnited;

type

   PParamRBPms_Premises=^TParamRBPms_Premises;
   TParamRBPms_Premises=packed record
     TypeOperation: Integer;
     Recyled: Integer;
     AddDisable: Boolean;
     ChangeDisable: Boolean;
     DeleteDisable: Boolean;
     FilterDisable: Boolean;
     NotUseRecyled: Boolean;
     Caption: PChar;
     NotUseAdvFilter: Boolean;
   end;

   TTabControl=class(ComCtrls.TTabControl)
   end;

   TfmRBPms_Premises = class(TfmRBMainGrid)
    tcGrid: TTabControl;
    iL: TImageList;
    btExtension: TButton;
    btAdvertisment: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure tcGridChange(Sender: TObject);
    procedure tcGridChanging(Sender: TObject; var AllowChange: Boolean);
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure btExtensionClick(Sender: TObject);
    procedure btAdvertismentClick(Sender: TObject);
  private
    NotUseRecyled: Boolean;
    isCheckDouble: Boolean;
    FSyncOfficeId: Integer;

    AddDisable, ChangeDisable, ChangeEnable, DeleteDisable, FilterDisable: Boolean;

    NotUseAdvFilter: Boolean;

    isFindTypeOperation,isFindRegionName,{by BARt}isFindCityRegionName{by BARt},isFindStreetName,isFindBalconyName,
    isFindConditionName,isFindSanitaryNodeName,isFindHeatName,isFindWaterName,isFindStyleName,
    isFindAgentName,isFindDoorName,isFindBuilderName,
    isFindCountRoomName,isFindTypeRoomName,isFindPlanningName,isFindStationName,
    isFindTypeHouseName,isFindStoveName,isFindFurnitureName,isFindContact,isFindContact2,
    isFindHouseNumber,isFindApartmentNumber,isFindPhoneName,isFindDocumentName,isFindFloor,
    isFindCountFloor,isFindGeneralArea,isFindgroundArea,
    isFindDwellingArea,isFindKitchenArea, isFindClientInfo, isFindClientInfo2,
    isFindPrice,isFindTerm,isFindPayment,isFindNote,isFindDateArrivalsStart,
    isFindDateArrivalsEnd,isFindRecyled,isFindSaleStatusName,isFindSelfFormName,isFindTypePremisesName,
    isFindUnitPriceName, isFindNN, isFindDelivery,isFindDecoration,isFindGlassy,isFindBlockSection,
    {by BARt}isFindAdvertismentNote,isFindAdvertisment,isFindTaxes,
    isFindAreaBuilding, isFindPopulatedPoint, isFindLandFeature, isFindExchangeFormula, isFindLocationStatus, isFindLandMark,
    isFindCommunications, isFindEmail, isFindEmail2, isFindLeaseOrSale, isFindObject, isFindDirection, isFindAccessWays, isFindRemoteness{by BARt}: Boolean;
    FindRegionName,{}FindCityRegionName{},FindStreetName,FindBalconyName,
    FindConditionName,FindSanitaryNodeName,FindHeatName,FindWaterName,FindStyleName,
    FindAgentName,FindDoorName,FindBuilderName,
    FindCountRoomName,FindTypeRoomName,FindPlanningName,FindStationName,
    FindTypeHouseName,FindStoveName,FindFurnitureName,FindContact,FindContact2: string;
    FindHouseNumber,FindApartmentNumber,FindPhoneName,FindDocumentName: string;
    FindFloor,FindCountFloor,FindClientInfo,FindClientInfo2: String;
    FindRecyled: Integer;
    FindGeneralArea,FindgroundArea,
    FindDwellingArea,FindKitchenArea,
    FindPrice: String;
    FindPricePlus, FindNN, Finddelivery: string;
    FindTerm,FindPayment,FindNote,FindSaleStatusName,FindSelfFormName,FindTypePremisesName,FindUnitPriceName: String;
    FindDateArrivalsStart,FindDateArrivalsEnd: TDate;
    {by BARt}FindAdvertismentNote, FindTaxes:String;
    FindAreaBuilding, FindPopulatedPoint, FindLandFeature, FindExchangeFormula, FindLocationStatus, FindLandMark,
    FindCommunications, FindEmail, FindEmail2, FindLeaseOrSale, FindObject, FindDirection, FindAccessWays, FindRemoteness:String;
    FindAdvertisment:Boolean;
    {by BARt}
    function TOS(Value: String): string;
    procedure FillGridColumns;
    procedure FillDefaultOrders;
    function GetGridName: string;
    procedure LoadFilter;
    procedure SaveFilter;
    procedure ClearFilter;
    procedure SetTabCaption;
    procedure OnTabGetImageEvent(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
    function CheckOtherPermission: Boolean;
    procedure MoveFromRecyled;
    procedure ClearAllFilters;
    procedure SetSyncOfficeId;

  protected

    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    function GetDefaultOrdersName: string; override;
    function ClassName: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface); override;
    function WarningAdvertisment: boolean;
  end;

var
  fmRBPms_Premises: TfmRBPms_Premises;

implementation

uses UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData, UEditRBPms_Premises,
     UPremisesTsvOptions, UPms_United,UAdvertisment_in_Premises;

{$R *.DFM}

procedure TfmRBPms_Premises.FillGridColumns;
var
  cl: TColumn;
begin
  Grid.Columns.Clear;
  if tcGrid.TabIndex=0 then begin // продажа

    cl:=Grid.Columns.Add;
    cl.FieldName:='nn';
    cl.Title.Caption:=GetColumnPremisesName(cnppNN);//'№№';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datearrivals';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateArrivals);//'Дата постуления';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='regionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppRegionName);//'Район';
    cl.Width:=100;
    {}
    cl:=Grid.Columns.Add;
    cl.FieldName:='cityregionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCityRegion);//'Район города';
    cl.Width:=100;
    {}
    cl:=Grid.Columns.Add;
    cl.FieldName:='streetname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStreetName);//'Улица';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='housenumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppHouseNumber);//'Дом';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='apartmentnumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppApartmentNumber);//'Квартира';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountRoomName);//'Количество комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typeroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypeRoomName);//'Тип комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='planningname';
    cl.Title.Caption:=GetColumnPremisesName(cnppPlanningName);//'Планировка';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='phonename';
    cl.Title.Caption:=GetColumnPremisesName(cnppPhoneName);//'Телефон';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='salestatusname';
    cl.Title.Caption:=GetColumnPremisesName(cnppSaleStatusName);//'Статус продажи';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='documentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppDocumentName);//'Документы';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='floor';
    cl.Title.Caption:=GetColumnPremisesName(cnppFloor);//'Этаж';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countfloor';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountFloor);//'Этажность';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typehousename';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypeHouseName);//'Тип дома';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='generalarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppGeneralArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='dwellingarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppDwellingArea);//'Жилая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='kitchenarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppKitchenArea);//'Площадь кухни';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='watername';
    cl.Title.Caption:=GetColumnPremisesName(cnppWaterName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='heatname';
    cl.Title.Caption:=GetColumnPremisesName(cnppHeatName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='balconyname';
    cl.Title.Caption:=GetColumnPremisesName(cnppBalconyName);//'Балкон';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='conditionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppConditionName);//'Ремонт';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stovename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStoveName);//'Плита';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='sanitarynodename';
    cl.Title.Caption:=GetColumnPremisesName(cnppSanitaryNodeName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='selfformname';
    cl.Title.Caption:=GetColumnPremisesName(cnppSelfFormName);//'Форма собственности';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typepremisesname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypePremisesname);//'Тип недвижимости';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='groundArea';
    cl.Title.Caption:=GetColumnPremisesName(cnppgroundArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='price';
    cl.Title.Caption:=GetColumnPremisesName(cnppPrice);//'Цена';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='unitpricename';
    cl.Title.Caption:=GetColumnPremisesName(cnppUnitPriceName);//'Единица измерения цены';
    cl.Width:=20;

    cl:=Grid.Columns.Add;
    cl.FieldName:='note';
    cl.Title.Caption:=GetColumnPremisesName(cnppNote);//'Примечание';
    cl.Width:=100;

    {by BART}
    cl:=Grid.Columns.Add;
    cl.FieldName:='advertisment_note';
    cl.Title.Caption:=GetColumnPremisesName(cnppAdvertismentNote);//'Примечание рекламы';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='taxes';
    cl.Title.Caption:=GetColumnPremisesName(cnppTaxesName);//'Налог';
    cl.Width:=100;
    {by BART}

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact2';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact2);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo2';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo2);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='agentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppAgentName);//'Агент';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='Stylename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStyleName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stationname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStationName);//'Статус временной';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeinsert';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeInsert);//'Дата и время ввода';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoinsertname';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoInsertName);//'Кто ввел';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeupdate';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeUpdate);//'Дата и время изменения';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoupdatename';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoUpdateName);//'Кто изменил';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='daterecyledout';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateRecyledOut);//'Дата извлечения из корзины';
    cl.Width:=60;

  end;

  {---------------------------}
  if tcGrid.TabIndex=3 then begin // земля

    cl:=Grid.Columns.Add;
    cl.FieldName:='nn';
    cl.Title.Caption:=GetColumnPremisesName(cnppNN);//'№№';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datearrivals';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateArrivals);//'Дата постуления';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='regionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppRegionName);//'Район';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='cityregionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCityRegion);//'Район города';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='object';
    cl.Title.Caption:=GetColumnPremisesName(cnppObject);//'Район Объект';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='direction';
    cl.Title.Caption:=GetColumnPremisesName(cnppDirection);//'Район Направление';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='remoteness';
    cl.Title.Caption:=GetColumnPremisesName(cnppRemoteness);//'Район Управление';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='accessways';
    cl.Title.Caption:=GetColumnPremisesName(cnppAccessWays);//'Район Подъездные пути';
    cl.Width:=100;

   { cl:=Grid.Columns.Add;
    cl.FieldName:='populatedpoint';
    cl.Title.Caption:=GetColumnPremisesName(cnppPopulatedPoint);//'Населенный пункт';
    cl.Width:=100;
    }

  {  cl:=Grid.Columns.Add;
    cl.FieldName:='streetname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStreetName);//'Улица';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='housenumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppHouseNumber);//'Дом';
    cl.Width:=30;
   }
  {  cl:=Grid.Columns.Add;
    cl.FieldName:='apartmentnumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppApartmentNumber);//'Квартира';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountRoomName);//'Количество комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typeroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypeRoomName);//'Тип комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='planningname';
    cl.Title.Caption:=GetColumnPremisesName(cnppPlanningName);//'Планировка';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='phonename';
    cl.Title.Caption:=GetColumnPremisesName(cnppPhoneName);//'Телефон';
    cl.Width:=30; }

    cl:=Grid.Columns.Add;
    cl.FieldName:='salestatusname';
    cl.Title.Caption:=GetColumnPremisesName(cnppSaleStatusName);//'Статус продажи';
    cl.Width:=30;  {

    cl:=Grid.Columns.Add;
    cl.FieldName:='documentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppDocumentName);//'Документы';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='floor';
    cl.Title.Caption:=GetColumnPremisesName(cnppFloor);//'Этаж';
    cl.Width:=30;

   }
    cl:=Grid.Columns.Add;
    cl.FieldName:='countfloor';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountFloor);//'Этажность';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typehousename';
    cl.Title.Caption:='Материал стен';//GetColumnPremisesName(cnppTypeHouseName);//'Тип дома';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='generalarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppGeneralArea);//'Общая площадь';
    cl.Width:=40;

    {cl:=Grid.Columns.Add;
    cl.FieldName:='dwellingarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppDwellingArea);//'Жилая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='kitchenarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppKitchenArea);//'Площадь кухни';
    cl.Width:=40;
     }
    cl:=Grid.Columns.Add;
    cl.FieldName:='watername';
    cl.Title.Caption:=GetColumnPremisesName(cnppWaterName);//'Вода';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='heatname';
    cl.Title.Caption:=GetColumnPremisesName(cnppHeatName);//'Отопление';
    cl.Width:=30;

    {cl:=Grid.Columns.Add;
    cl.FieldName:='balconyname';
    cl.Title.Caption:=GetColumnPremisesName(cnppBalconyName);//'Балкон';
    cl.Width:=30;
     }
    cl:=Grid.Columns.Add;
    cl.FieldName:='conditionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppConditionName);//'Ремонт';
    cl.Width:=30;
     {
    cl:=Grid.Columns.Add;
    cl.FieldName:='stovename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStoveName);//'Плита';
    cl.Width:=30;
      }
    cl:=Grid.Columns.Add;
    cl.FieldName:='sanitarynodename';
    cl.Title.Caption:=GetColumnPremisesName(cnppSanitaryNodeName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='selfformname';
    cl.Title.Caption:=GetColumnPremisesName(cnppSelfFormName);//'Форма собственности';
    cl.Width:=30;

    {cl:=Grid.Columns.Add;
    cl.FieldName:='exchangeformula';
    cl.Title.Caption:=GetColumnPremisesName(cnppExchangeFormula);//'Формула обмена';
    cl.Width:=30;
     }

   { cl:=Grid.Columns.Add;
    cl.FieldName:='typepremisesname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypePremisesname);//'Тип недвижимости';
    cl.Width:=30;
    }
    cl:=Grid.Columns.Add;
    cl.FieldName:='groundArea';
    cl.Title.Caption:=GetColumnPremisesName(cnppgroundArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='price';
    cl.Title.Caption:=GetColumnPremisesName(cnppPrice);//'Цена';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='unitpricename';
    cl.Title.Caption:=GetColumnPremisesName(cnppUnitPriceName);//'Единица измерения цены';
    cl.Width:=20;

    cl:=Grid.Columns.Add;
    cl.FieldName:='note';
    cl.Title.Caption:=GetColumnPremisesName(cnppNote);//'Примечание';
    cl.Width:=100;

    {by BART}
    cl:=Grid.Columns.Add;
    cl.FieldName:='advertisment_note';
    cl.Title.Caption:=GetColumnPremisesName(cnppAdvertismentNote);//'Примечание рекламы';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='taxes';
    cl.Title.Caption:=GetColumnPremisesName(cnppTaxesName);//'Налог';
    cl.Width:=100;
    {by BART}

    cl:=Grid.Columns.Add;
    cl.FieldName:='email';
    cl.Title.Caption:=GetColumnPremisesName(cnppEmail);//'email';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='email2';
    cl.Title.Caption:=GetColumnPremisesName(cnppEmail2);//'email';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact2';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact2);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo2';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo2);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='agentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppAgentName);//'Агент';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='Stylename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStyleName);//'Эксклюзив';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='COMMUNICATIONS';
    cl.Title.Caption:=GetColumnPremisesName(cnppCommunications);//'Электр';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stationname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStationName);//'Статус временной';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='locationstatus';
    cl.Title.Caption:=GetColumnPremisesName(cnppLocationStatus);//'статус расположения';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='landmark';
    cl.Title.Caption:=GetColumnPremisesName(cnppLandMark);//' ориентир';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='landfeature';
    cl.Title.Caption:=GetColumnPremisesName(cnppLandFeature);//'зем хар';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='areabuilding';
    cl.Title.Caption:=GetColumnPremisesName(cnppAreaBuilding);//'зем постр';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='leaseorsale';
    cl.Title.Caption:=GetColumnPremisesName(cnppLeaseOrSale);//'ар/пр';
    cl.Width:=30;


    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeinsert';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeInsert);//'Дата и время ввода';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoinsertname';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoInsertName);//'Кто ввел';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeupdate';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeUpdate);//'Дата и время изменения';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoupdatename';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoUpdateName);//'Кто изменил';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='daterecyledout';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateRecyledOut);//'Дата извлечения из корзины';
    cl.Width:=60;

  end;
  {---------------------------}
  if tcGrid.TabIndex=2 then begin // долевое

    cl:=Grid.Columns.Add;
    cl.FieldName:='nn';
    cl.Title.Caption:=GetColumnPremisesName(cnppNN);//'№№';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datearrivals';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateArrivals);//'Дата постуления';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='regionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppRegionName);//'Район';
    cl.Width:=100;
   {}
    cl:=Grid.Columns.Add;
    cl.FieldName:='cityregionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCityRegion);//'Район города';
    cl.Width:=100;
   {}
    cl:=Grid.Columns.Add;
    cl.FieldName:='streetname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStreetName);//'Улица';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='housenumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppHouseNumber);//'Дом';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='apartmentnumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppApartmentNumber);//'Квартира';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountRoomName);//'Количество комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typeroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypeRoomName);//'Тип комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='planningname';
    cl.Title.Caption:=GetColumnPremisesName(cnppPlanningName);//'Планировка';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='phonename';
    cl.Title.Caption:=GetColumnPremisesName(cnppPhoneName);//'Телефон';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='salestatusname';
    cl.Title.Caption:=GetColumnPremisesName(cnppSaleStatusName);//'Статус продажи';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='documentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppDocumentName);//'Документы';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='floor';
    cl.Title.Caption:=GetColumnPremisesName(cnppFloor);//'Этаж';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countfloor';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountFloor);//'Этажность';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typehousename';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypeHouseName);//'Тип дома';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='generalarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppGeneralArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='dwellingarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppDwellingArea);//'Жилая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='kitchenarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppKitchenArea);//'Площадь кухни';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='watername';
    cl.Title.Caption:=GetColumnPremisesName(cnppWaterName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='heatname';
    cl.Title.Caption:=GetColumnPremisesName(cnppHeatName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='delivery';
    cl.Title.Caption:=GetColumnPremisesName(cnppDelivery);//'Delivery';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='Buildername';
    cl.Title.Caption:=GetColumnPremisesName(cnppBuilderName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='balconyname';
    cl.Title.Caption:=GetColumnPremisesName(cnppBalconyName);//'Балкон';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='conditionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppConditionName);//'Ремонт';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stovename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStoveName);//'Плита';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='sanitarynodename';
    cl.Title.Caption:=GetColumnPremisesName(cnppSanitaryNodeName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='selfformname';
    cl.Title.Caption:=GetColumnPremisesName(cnppSelfFormName);//'Форма собственности';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typepremisesname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypePremisesname);//'Тип недвижимости';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='groundArea';
    cl.Title.Caption:=GetColumnPremisesName(cnppgroundArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='price';
    cl.Title.Caption:=GetColumnPremisesName(cnppPrice);//'Цена';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='price2';
    cl.Title.Caption:=GetColumnPremisesName(cnppPrice2);//'Price2';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='unitpricename';
    cl.Title.Caption:=GetColumnPremisesName(cnppUnitPriceName);//'Единица измерения цены';
    cl.Width:=20;

    cl:=Grid.Columns.Add;
    cl.FieldName:='decoration';
    cl.Title.Caption:=GetColumnPremisesName(cnppDecoration);//'отделка';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='glassy';
    cl.Title.Caption:=GetColumnPremisesName(cnppGlassy);//'остекление';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='block_section';
    cl.Title.Caption:=GetColumnPremisesName(cnppBlockSection);//'блок секция';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='note';
    cl.Title.Caption:=GetColumnPremisesName(cnppNote);//'Примечание';
    cl.Width:=100;

    {by BART}
    cl:=Grid.Columns.Add;
    cl.FieldName:='advertisment_note';
    cl.Title.Caption:=GetColumnPremisesName(cnppAdvertismentNote);//'Примечание рекламы';
    cl.Width:=100;

    {cl:=Grid.Columns.Add;
    cl.FieldName:='taxes';
    cl.Title.Caption:=GetColumnPremisesName(cnppTaxesName);//'Налог';
    cl.Width:=100;
     }

    {by BART}

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact2';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact2);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo2';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo2);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='agentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppAgentName);//'Агент';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='Stylename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStyleName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stationname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStationName);//'Статус временной';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeinsert';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeInsert);//'Дата и время ввода';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoinsertname';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoInsertName);//'Кто ввел';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeupdate';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeUpdate);//'Дата и время изменения';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoupdatename';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoUpdateName);//'Кто изменил';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='daterecyledout';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateRecyledOut);//'Дата извлечения из корзины';
    cl.Width:=60;

  end;


  if tcGrid.TabIndex=1 then begin // аренда

    cl:=Grid.Columns.Add;
    cl.FieldName:='nn';
    cl.Title.Caption:=GetColumnPremisesName(cnppNN);//'№№';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datearrivals';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateArrivals);//'Дата постуления';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='regionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppRegionName);//'Район';
    cl.Width:=100;
   {}
    cl:=Grid.Columns.Add;
    cl.FieldName:='cityregionname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCityRegion);//'Район города';
    cl.Width:=100;
   {}
    cl:=Grid.Columns.Add;
    cl.FieldName:='streetname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStreetName);//'Улица';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='housenumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppHouseNumber);//'Дом';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='ApartmentNumber';
    cl.Title.Caption:=GetColumnPremisesName(cnppApartmentNumber);//'Квартира';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountRoomName);//'Количество комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='typeroomname';
    cl.Title.Caption:=GetColumnPremisesName(cnppTypeRoomName);//'Тип комнат';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='planningname';
    cl.Title.Caption:=GetColumnPremisesName(cnppPlanningName);//'Планировка';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='floor';
    cl.Title.Caption:=GetColumnPremisesName(cnppFloor);//'Этаж';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='countfloor';
    cl.Title.Caption:=GetColumnPremisesName(cnppCountFloor);//'Этажность';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='phonename';
    cl.Title.Caption:=GetColumnPremisesName(cnppPhoneName);//'Телефон';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='furniturename';
    cl.Title.Caption:=GetColumnPremisesName(cnppFurnitureName);//'Мебель';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='generalarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppGeneralArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='dwellingarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppDwellingArea);//'Жилая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='kitchenarea';
    cl.Title.Caption:=GetColumnPremisesName(cnppKitchenArea);//'Площадь кухни';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='watername';
    cl.Title.Caption:=GetColumnPremisesName(cnppWaterName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='heatname';
    cl.Title.Caption:=GetColumnPremisesName(cnppHeatName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='doorname';
    cl.Title.Caption:=GetColumnPremisesName(cnppDoorName);//'Дверь';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='sanitarynodename';
    cl.Title.Caption:=GetColumnPremisesName(cnppSanitaryNodeName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='balconyname';
    cl.Title.Caption:=GetColumnPremisesName(cnppBalconyName);//'Балкон';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stovename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStoveName);//'Плита';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='groundArea';
    cl.Title.Caption:=GetColumnPremisesName(cnppgroundArea);//'Общая площадь';
    cl.Width:=40;

    cl:=Grid.Columns.Add;
    cl.FieldName:='price';
    cl.Title.Caption:=GetColumnPremisesName(cnppPrice);//'Цена';
    cl.Width:=50;

    cl:=Grid.Columns.Add;
    cl.FieldName:='unitpricename';
    cl.Title.Caption:=GetColumnPremisesName(cnppUnitPriceName);//'Единица измерения цены';
    cl.Width:=20;

    cl:=Grid.Columns.Add;
    cl.FieldName:='term';
    cl.Title.Caption:=GetColumnPremisesName(cnppTerm);//'Срок';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='payment';
    cl.Title.Caption:=GetColumnPremisesName(cnppPayment);//'Оплата за';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='note';
    cl.Title.Caption:=GetColumnPremisesName(cnppNote);//'Примечание';
    cl.Width:=100;

    {by BART}
    cl:=Grid.Columns.Add;
    cl.FieldName:='advertisment_note';
    cl.Title.Caption:=GetColumnPremisesName(cnppAdvertismentNote);//'Примечание рекламы';
    cl.Width:=100;

   { cl:=Grid.Columns.Add;
    cl.FieldName:='taxes';
    cl.Title.Caption:=GetColumnPremisesName(cnppTaxesName);//'Налог';
    cl.Width:=100;
    }
    {by BART}

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='contact2';
    cl.Title.Caption:=GetColumnPremisesName(cnppContact2);//'Контакт';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='clientinfo2';
    cl.Title.Caption:=GetColumnPremisesName(cnppClientInfo2);//'Клиент';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='agentname';
    cl.Title.Caption:=GetColumnPremisesName(cnppAgentName);//'Агент';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='Stylename';
    cl.Title.Caption:=GetColumnPremisesName(cnppStyleName);//'Санузел';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='stationname';
    cl.Title.Caption:=GetColumnPremisesName(cnppStationName);//'Статус временной';
    cl.Width:=30;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeinsert';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeInsert);//'Дата и время ввода';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoinsertname';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoInsertName);//'Кто ввел';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='datetimeupdate';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateTimeUpdate);//'Дата и время изменения';
    cl.Width:=60;

    cl:=Grid.Columns.Add;
    cl.FieldName:='whoupdatename';
    cl.Title.Caption:=GetColumnPremisesName(cnppWhoUpdateName);//'Кто изменил';
    cl.Width:=100;

    cl:=Grid.Columns.Add;
    cl.FieldName:='daterecyledout';
    cl.Title.Caption:=GetColumnPremisesName(cnppDateRecyledOut);//'Дата извлечения из корзины';
    cl.Width:=60;

  end;

  cl:=GetColumnByFieldName(Grid.Columns,'phonename');
  if cl<>nil then
   cl.Font.Assign(fmOptions.edPhoneColumn.Font);
end;

function TfmRBPms_Premises.TOS(Value: String): string;
begin
  Result:=Value+inttostr(tcGrid.TabIndex);
end;

function TfmRBPms_Premises.GetGridName: string;
begin
  Result:=TOS('Grid');
end;

procedure TfmRBPms_Premises.FillDefaultOrders;
begin
  DefaultOrders.Clear;
  DefaultOrders.Add('Статус квартиры (порядок)','st.sortnumber',false,tdboAsc);
  DefaultOrders.Add('Количество комнат (порядок)','cr.sortnumber',true,tdboAsc);
  DefaultOrders.Add('Район (порядок)','r.sortnumber',true,tdboAsc);
  DefaultOrders.Add('Район города (порядок)','crg.sortnumber',true,tdboAsc);
  DefaultOrders.Add('Улица (наименование)','s.name',true,tdboAsc);
  DefaultOrders.Add('Номер дома','p.housenumber',true,tdboAsc);
  DefaultOrders.Add('Номер квартиры','p.apartmentnumber',true,tdboAsc);
  DefaultOrders.Add('Дата поступления','datearrivals',false,tdboAsc);
  DefaultOrders.Add('Цена','price',false,tdboAsc);
end;

procedure TfmRBPms_Premises.ClearAllFilters;
var
  i: Integer;
  Last: Integer;
begin
  Last:=tcGrid.TabIndex;
  ClearFilter;
  for i:=0 to tcGrid.Tabs.Count-1 do begin
    tcGrid.TabIndex:=i;
    SaveFilter;
  end;
  tcGrid.TabIndex:=Last;
end;

procedure TfmRBPms_Premises.FormCreate(Sender: TObject);
begin
 inherited;
 try
  isCheckDouble:=false;

  Caption:=NameRbkPms_Premises;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  tcGrid.OnGetImageIndex:=OnTabGetImageEvent;
  FindPricePlus:='=';
  NotUseRecyled:=false;
  NotUseAdvFilter:=false;

{  AddDisable:=true;
  ChangeDisable:=true;
  DeleteDisable:=true;
  FilterDisable:=true;}

  Grid.Parent:=tcGrid;
  Grid.Name:=GetGridName;
  FillGridColumns;

  FillDefaultOrders;

  LoadFromIni;

  if fmOptions.chbClearFilterOnEnter.Checked then ClearAllFilters;

  SetTabCaption;

  MoveFromRecyled;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Premises.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPms_Premises:=nil;
end;

function TfmRBPms_Premises.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPms_Premises+GetFilterString+GetLastOrderStr;
end;

function TfmRBPms_Premises.CheckOtherPermission: Boolean;
var
  TPRBI: TParamRBookInterface;
  T: TInfoConnectUser;
  s,e,i: Integer;
  perm: string;
  isUpdate,isInsert,isDelete,isSelect: Boolean;
begin
  isUpdate:=false;
  isInsert:=false;
  isDelete:=false;
  isSelect:=false;
  FillChar(T,SizeOf(T),0);
  _GetInfoConnectUser(@T);
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' '+tbUsers+'.user_id='+inttostr(T.User_id)+' and typeoperation='+inttostr(tcGrid.TabIndex)+' ');
  if _ViewInterfaceFromName(NameRbkPms_Perm,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    for i:=s to e do begin
      perm:=GetValueByPRBI(@TPRBI,i,'perm');
      if AnsiSameText(perm,SelConst) then isSelect:=true;
      if AnsiSameText(perm,InsConst) then isInsert:=true;
      if AnsiSameText(perm,UpdConst) then isUpdate:=true;
      if AnsiSameText(perm,DelConst) then isDelete:=true;
    end;
  end;
  bibAdd.Enabled:=not AddDisable and isSelect and isInsert;
  ChangeEnable:=not ChangeDisable and isSelect and isUpdate;
  bibChange.Enabled:=ChangeEnable;
  bibDel.Enabled:=not DeleteDisable and isSelect and isDelete;
  bibRefresh.Enabled:=isSelect;
  bibView.Enabled:=isSelect;
  bibFilter.Enabled:=not FilterDisable and isSelect;
  btExtension.Enabled:=bibChange.Enabled;
  Result:=isSelect;

end;

procedure TfmRBPms_Premises.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  if not CheckOtherPermission then exit;

  SetSyncOfficeId;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindRegionName or isFindCityRegionName or isFindStreetName or isFindBalconyName or
                  isFindConditionName or isFindSanitaryNodeName or isFindHeatname or isFindWatername or
                  isFindAgentName or isFindDoorName or isFindStylename or isFindBuildername or
                  isFindCountRoomName or isFindTypeRoomName or isFindPlanningName or isFindStationName or
                  isFindTypeHouseName or isFindStoveName or isFindFurnitureName or isFindContact or isFindClientInfo or
                  isFindHouseNumber or isFindApartmentNumber or isFindPhoneName or isFindDocumentName or
                  isFindFloor or //isFindRecyled  or
                  isFindCountFloor or isFindGeneralArea or isFindgroundArea or
                  isFindDwellingArea or isFindKitchenArea or
                  isFindPrice or isFindTerm or isFindPayment or isFindNote or {by BART}isFindAdvertismentNote or isFindAdvertisment or isFindTaxes or
                  isFindObject or isFindDirection or isFindAccessWays or isFindRemoteness or{by BART}
                  isFindDateArrivalsStart or isFindDateArrivalsEnd or isFindSaleStatusname or isFindSelfFormName or isFindTypePremisesName
                  or isFindUnitPriceName or isFindNN or isFindDelivery or isFindDecoration or isFindGlassy or isFindBlockSection
                  or isFindAreaBuilding or isFindPopulatedPoint or isFindLandFeature or isFindExchangeFormula or isFindLocationStatus
                  or isFindLandMark or isFindCommunications or isFindEmail or isFindLeaseOrSale or isFindContact2 or isFindClientInfo2 or isFindEmail2);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Premises.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiSameText(fn,'regionname') then fn:='r.name';
   if AnsiSameText(fn,'cityregionname') then fn:='crg.name';
   if AnsiSameText(fn,'streetname') then fn:='s.name';
   if AnsiSameText(fn,'countroomname') then fn:='cr.name';
   if AnsiSameText(fn,'whoinsertname') then fn:='u1.name';
   if AnsiSameText(fn,'whoupdatename') then fn:='u2.name';
   if AnsiSameText(fn,'agentname') then fn:='a.name';
   if AnsiSameText(fn,'balconyname') then fn:='b.name';
   if AnsiSameText(fn,'conditionname') then fn:='c.name';
   if AnsiSameText(fn,'sanitarynodename') then fn:='sn.name';
   if AnsiSameText(fn,'heatname') then fn:='h.name';
   if AnsiSameText(fn,'watername') then fn:='w.name';
   if AnsiSameText(fn,'Buildername') then fn:='bl.name';
   if AnsiSameText(fn,'stylename') then fn:='sl.name';
   if AnsiSameText(fn,'doorname') then fn:='d.name';
   if AnsiSameText(fn,'typeroomname') then fn:='tr.name';
   if AnsiSameText(fn,'planningname') then fn:='pl.name';
   if AnsiSameText(fn,'stationname') then fn:='st.name';
   if AnsiSameText(fn,'typehousename') then fn:='th.name';
   if AnsiSameText(fn,'stovename') then fn:='sv.name';
   if AnsiSameText(fn,'furniturename') then fn:='f.name';
   if AnsiSameText(fn,'phonename') then fn:='ph.name';
   if AnsiSameText(fn,'salestausname') then fn:='ss.name';
   if AnsiSameText(fn,'selfformname') then fn:='sf.name';
   if AnsiSameText(fn,'typepremisesname') then fn:='tp.name';
   if AnsiSameText(fn,'unitpricename') then fn:='u.name';
   if AnsiSameText(fn,'documentname') then fn:='dc.name';
   if AnsiSameText(fn,'note') then fn:='p.note';
   if AnsiSameText(fn,'advertisment_note') then fn:='p.advertisment_note';
   if AnsiSameText(fn,'taxes') then fn:='tx.name';
   //-------------------
   if AnsiSameText(fn,'areabuilding') then fn:='p.areabuilding';
   if AnsiSameText(fn,'populatedpoint') then fn:='ppt.name';
   if AnsiSameText(fn,'landfeature') then fn:='lf.name';
   if AnsiSameText(fn,'exchangeformula') then fn:='ef.name';
   if AnsiSameText(fn,'locationstatus') then fn:='ls.name';
   if AnsiSameText(fn,'landmark') then fn:='p.landmark';
   if AnsiSameText(fn,'communications') then fn:='p.communications';
   if AnsiSameText(fn,'email') then fn:='p.email';
   if AnsiSameText(fn,'email2') then fn:='p.email2';
   if AnsiSameText(fn,'leaseorsale') then fn:='p.leaseorsale';
   if AnsiSameText(fn,'object') then fn:='obj.name';
   if AnsiSameText(fn,'direction') then fn:='dir.name';
   if AnsiSameText(fn,'accessways') then fn:='aw.name';
   if AnsiSameText(fn,'remoteness') then fn:='p.remoteness';


   id1:=MainQr.fieldByName('pms_premises_id').asString;
   id2:=MainQr.fieldByName('pms_agent_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   if RecordCount<1000 then
     MainQr.Locate('pms_premises_id;pms_agent_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Premises.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPms_Premises.LoadFilter;
begin
  FindRegionName:=ReadParam(ClassName,TOS('RegionName'),FindRegionName);
  FindCityRegionName:=ReadParam(ClassName,TOS('CityRegionName'),FindCityRegionName);
  FindStreetName:=ReadParam(ClassName,TOS('StreetName'),FindStreetName);
  FindBalconyName:=ReadParam(ClassName,TOS('BalconyName'),FindBalconyName);
  FindConditionName:=ReadParam(ClassName,TOS('ConditionName'),FindConditionName);
  FindSanitaryNodeName:=ReadParam(ClassName,TOS('SanitaryNodeName'),FindSanitaryNodeName);
  FindHeatName:=ReadParam(ClassName,TOS('HeatName'),FindHeatName);
  FindWaterName:=ReadParam(ClassName,TOS('WaterName'),FindWaterName);
  FindBuilderName:=ReadParam(ClassName,TOS('BuilderName'),FindBuilderName);
  FindStyleName:=ReadParam(ClassName,TOS('StyleName'),FindStyleName);
  FindAgentName:=ReadParam(ClassName,TOS('AgentName'),FindAgentName);
  FindDoorName:=ReadParam(ClassName,TOS('DoorName'),FindDoorName);
  FindCountRoomName:=ReadParam(ClassName,TOS('CountRoomName'),FindCountRoomName);
  FindTypeRoomName:=ReadParam(ClassName,TOS('TypeRoomName'),FindTypeRoomName);
  FindPlanningName:=ReadParam(ClassName,TOS('PlanningName'),FindPlanningName);
  FindStationName:=ReadParam(ClassName,TOS('StationName'),FindStationName);
  FindTypeHouseName:=ReadParam(ClassName,TOS('TypeHouseName'),FindTypeHouseName);
  FindStoveName:=ReadParam(ClassName,TOS('StoveName'),FindStoveName);
  FindFurnitureName:=ReadParam(ClassName,TOS('FurnitureName'),FindFurnitureName);
  FindContact:=ReadParam(ClassName,TOS('Contact'),FindContact);
  FindClientinfo:=ReadParam(ClassName,TOS('Clientinfo'),FindClientinfo);
  FindContact2:=ReadParam(ClassName,TOS('Contact2'),FindContact2);
  FindClientinfo2:=ReadParam(ClassName,TOS('Clientinfo2'),FindClientinfo2);
  FindHouseNumber:=ReadParam(ClassName,TOS('HouseNumber'),FindHouseNumber);
  FindApartmentNumber:=ReadParam(ClassName,TOS('ApartmentNumber'),FindApartmentNumber);
  FindPhoneName:=ReadParam(ClassName,TOS('PhoneName'),FindPhoneName);
  FindSaleStatusName:=ReadParam(ClassName,TOS('SaleStatusName'),FindSaleStatusName);
  FindSelfFormName:=ReadParam(ClassName,TOS('SelfFormName'),FindSelfFormName);
  FindTypePremisesName:=ReadParam(ClassName,TOS('TypePremisesName'),FindTypePremisesName);
  FindUnitPriceName:=ReadParam(ClassName,TOS('UnitPriceName'),FindUnitPriceName);
  FindDocumentName:=ReadParam(ClassName,TOS('DocumentName'),FindDocumentName);
  FindFloor:=ReadParam(ClassName,TOS('Floor'),FindFloor);
  FindCountFloor:=ReadParam(ClassName,TOS('CountFloor'),FindCountFloor);
  FindGeneralArea:=ReadParam(ClassName,TOS('GeneralArea'),FindGeneralArea);
  FindgroundArea:=ReadParam(ClassName,TOS('groundArea'),FindgroundArea);
  FindDwellingArea:=ReadParam(ClassName,TOS('DwellingArea'),FindDwellingArea);
  FindKitchenArea:=ReadParam(ClassName,TOS('KitchenArea'),FindKitchenArea);
  FindPrice:=ReadParam(ClassName,TOS('Price'),FindPrice);
  FindPricePlus:=ReadParam(ClassName,TOS('PricePlus'),FindPricePlus);
  if Trim(FindPricePlus)='' then FindPricePlus:='=';
  FindTerm:=ReadParam(ClassName,TOS('Term'),FindTerm);
  FindPayment:=ReadParam(ClassName,TOS('Payment'),FindPayment);
  FindNote:=ReadParam(ClassName,TOS('Note'),FindNote);
  {by BART}
  FindAdvertismentNote:=ReadParam(ClassName,TOS('AdvertismentNote'),FindAdvertismentNote);
  FindAdvertisment:=ReadParam(ClassName,TOS('Advertisment'),FindAdvertisment);
  FindTaxes:=ReadParam(ClassName,TOS('Taxes'),FindTaxes);

  FindAreaBuilding:=ReadParam(ClassName,TOS('AreaBuilding'),FindAreaBuilding);
  FindPopulatedPoint:=ReadParam(ClassName,TOS('PopulatedPoint'),FindPopulatedPoint);
  FindLandFeature:=ReadParam(ClassName,TOS('LandFeature'),FindLandFeature);
  FindExchangeFormula:=ReadParam(ClassName,TOS('ExchangeFormula'),FindExchangeFormula);
  FindLocationStatus:=ReadParam(ClassName,TOS('LocationStatus'),FindLocationStatus);
  FindLandMark:=ReadParam(ClassName,TOS('LandMark'),FindLandMark);
  FindCommunications:=ReadParam(ClassName,TOS('Communications'),FindCommunications);
  FindEmail:=ReadParam(ClassName,TOS('Email'),FindEmail);
  FindEmail2:=ReadParam(ClassName,TOS('Email2'),FindEmail2);

  FindObject:=ReadParam(ClassName,TOS('Object'),FindObject);
  FindDirection:=ReadParam(ClassName,TOS('Direction'),FindDirection);
  FindAccessWays:=ReadParam(ClassName,TOS('AccessWays'),FindAccessWays);
  FindRemoteness:=ReadParam(ClassName,TOS('Remoteness'),FindRemoteness);


  {by BART}
  FindDateArrivalsStart:=ReadParam(ClassName,TOS('DateArrivalsStart'),FindDateArrivalsStart);
  isFindDateArrivalsStart:=ReadParam(ClassName,TOS('isDateArrivalsStart'),isFindDateArrivalsStart);
  FindDateArrivalsEnd:=ReadParam(ClassName,TOS('DateArrivalsEnd'),FindDateArrivalsEnd);
  isFindDateArrivalsEnd:=ReadParam(ClassName,TOS('isDateArrivalsEnd'),isFindDateArrivalsEnd);
  FindRecyled:=ReadParam(ClassName,TOS('Recyled'),FindRecyled);
  FindNN:=ReadParam(ClassName,TOS('NN'),FindNN);
  FindDelivery:=ReadParam(ClassName,TOS('Delivery'),FindDelivery);
  FilterInside:=ReadParam(ClassName,TOS('Inside'),FilterInside);
end;

procedure TfmRBPms_Premises.LoadFromIni;
begin
 inherited;
 try
   LoadFilter;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Premises.SaveFilter;
begin
  WriteParam(ClassName,TOS('RegionName'),FindRegionName);
  WriteParam(ClassName,TOS('CityRegionName'),FindCityRegionName);
  WriteParam(ClassName,TOS('StreetName'),FindStreetName);
  WriteParam(ClassName,TOS('BalconyName'),FindBalconyName);
  WriteParam(ClassName,TOS('ConditionName'),FindConditionName);
  WriteParam(ClassName,TOS('SanitaryNodeName'),FindSanitaryNodeName);
  WriteParam(ClassName,TOS('HeatName'),FindHeatName);
  WriteParam(ClassName,TOS('WaterName'),FindWaterName);
  WriteParam(ClassName,TOS('BuilderName'),FindBuilderName);
  WriteParam(ClassName,TOS('StyleName'),FindStyleName);
  WriteParam(ClassName,TOS('AgentName'),FindAgentName);
  WriteParam(ClassName,TOS('DoorName'),FindDoorName);
  WriteParam(ClassName,TOS('CountRoomName'),FindCountRoomName);
  WriteParam(ClassName,TOS('TypeRoomName'),FindTypeRoomName);
  WriteParam(ClassName,TOS('PlanningName'),FindPlanningName);
  WriteParam(ClassName,TOS('StationName'),FindStationName);
  WriteParam(ClassName,TOS('TypeHouseName'),FindTypeHouseName);
  WriteParam(ClassName,TOS('StoveName'),FindStoveName);
  WriteParam(ClassName,TOS('FurnitureName'),FindFurnitureName);
  WriteParam(ClassName,TOS('Contact'),FindContact);
  WriteParam(ClassName,TOS('ClientInfo'),FindClientInfo);
  WriteParam(ClassName,TOS('Contact2'),FindContact2);
  WriteParam(ClassName,TOS('ClientInfo2'),FindClientInfo2);
  WriteParam(ClassName,TOS('HouseNumber'),FindHouseNumber);
  WriteParam(ClassName,TOS('ApartmentNumber'),FindApartmentNumber);
  WriteParam(ClassName,TOS('PhoneName'),FindPhoneName);
  WriteParam(ClassName,TOS('SaleStatusName'),FindSaleStatusName);
  WriteParam(ClassName,TOS('SelfFormName'),FindSelfFormName);
  WriteParam(ClassName,TOS('TypePremisesName'),FindTypePremisesName);
  WriteParam(ClassName,TOS('UnitPriceName'),FindUnitPriceName);
  WriteParam(ClassName,TOS('DocumentName'),FindDocumentName);
  WriteParam(ClassName,TOS('Floor'),FindFloor);
  WriteParam(ClassName,TOS('CountFloor'),FindCountFloor);
  WriteParam(ClassName,TOS('GeneralArea'),FindGeneralArea);
  WriteParam(ClassName,TOS('groundArea'),FindgroundArea);
  WriteParam(ClassName,TOS('DwellingArea'),FindDwellingArea);
  WriteParam(ClassName,TOS('KitchenArea'),FindKitchenArea);
  WriteParam(ClassName,TOS('Price'),FindPrice);
  WriteParam(ClassName,TOS('PricePlus'),FindPricePlus);
  WriteParam(ClassName,TOS('Term'),FindTerm);
  WriteParam(ClassName,TOS('Payment'),FindPayment);
  WriteParam(ClassName,TOS('Note'),FindNote);
  {by BART}
  WriteParam(ClassName,TOS('AdvertismentNote'),FindAdvertismentNote);
  WriteParam(ClassName,TOS('Advertisment'),FindAdvertisment);
  WriteParam(ClassName,TOS('Taxes'),FindTaxes);

  WriteParam(ClassName,TOS('AreaBuilding'),FindAreaBuilding);
  WriteParam(ClassName,TOS('PopulatedPoint'),FindPopulatedPoint);
  WriteParam(ClassName,TOS('LandFeature'),FindLandFeature);
  WriteParam(ClassName,TOS('ExchangeFormula'),FindExchangeFormula);
  WriteParam(ClassName,TOS('LocationStatus'),FindLocationStatus);
  WriteParam(ClassName,TOS('LandMark'),FindLandMark);
  WriteParam(ClassName,TOS('Communications'),FindCommunications);
  WriteParam(ClassName,TOS('Email'),FindEmail);
  WriteParam(ClassName,TOS('Email2'),FindEmail2);

  WriteParam(ClassName,TOS('Object'),FindObject);
  WriteParam(ClassName,TOS('Direction'),FindDirection);
  WriteParam(ClassName,TOS('AccessWays'),FindAccessWays);
  WriteParam(ClassName,TOS('Remoteness'),FindRemoteness);


  {by BART}

  WriteParam(ClassName,TOS('DateArrivalsStart'),FindDateArrivalsStart);
  WriteParam(ClassName,TOS('isDateArrivalsStart'),isFindDateArrivalsStart);
  WriteParam(ClassName,TOS('DateArrivalsEnd'),FindDateArrivalsEnd);
  WriteParam(ClassName,TOS('isDateArrivalsEnd'),isFindDateArrivalsEnd);
  WriteParam(ClassName,TOS('Recyled'),FindRecyled);
  WriteParam(ClassName,TOS('NN'),FindNN);
  WriteParam(ClassName,TOS('Delivery'),FindDelivery);
  WriteParam(ClassName,TOS('Inside'),FilterInside);
end;

procedure TfmRBPms_Premises.SaveToIni;
begin
 inherited;
 try
   SaveFilter;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Premises.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPms_Premises.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPms_Premises;
begin

  if not Mainqr.Active then exit;
  fm:=TfmEditRBPms_Premises.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.TypeOperation:=TTypeOperation(tcGrid.TabIndex);
    fm.FillRegion;
    fm.FillCityRegion;
    fm.FillStreet;
    fm.FillBalcony;
    fm.FillCondition;
    fm.FillSanitaryNode;
    fm.FillWater;
    fm.FillBuilder;
    fm.FillInvestor;
    fm.FillStyle;
    fm.FillHeat;
    fm.FillAgent(false,FSyncOfficeId);
    fm.FillDoor;
    fm.FillPhone;
    fm.FillCountRoom;
    fm.FillTypeRoom;
    fm.FillPlanning;
    fm.FillStation;
    fm.FillTypeHouse;
    fm.FillStove;
    fm.FillFurniture;
    fm.FillDocument;
    fm.FillSaleStatus;
    fm.FillSelfForm;
    fm.FillTypePremises;
    fm.FillUnitPrice;
    //bybart
    fm.FillTaxes;

  //  fm.FillAreaBuilding;
    fm.FillPopulatedPoint;
    fm.FillLandFeature;
    fm.FillExchangeFormula;
    fm.FillLocationStatus;
  //  fm.FillLandMark;

    fm.FillObject;
    fm.FillDirection;
    fm.FillAccessWays;

    //----------
    fm.oldRecyled:=FindRecyled;
    fm.cmbRecyled.ItemIndex:=fm.oldRecyled;
    fm.ChangeFlag:=false;
    fm.bibAdvertisment.Enabled:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('pms_premises_id;pms_agent_id',VarArrayOf([fm.oldPms_Premises_id,fm.oldpms_agent_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Premises.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPms_Premises;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Premises.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.TypeOperation:=TTypeOperation(tcGrid.TabIndex);
    fm.oldRecyled:=MainQr.FieldByName('recyled').AsInteger;
    fm.cmbRecyled.ItemIndex:=fm.oldRecyled;
    fm.edNN.Text:=MainQr.FieldByName('nn').AsString;
    fm.edDelivery.Text:=MainQr.FieldByName('delivery').AsString;
    fm.dtpDateArrivalsFrom.DateTime:=MainQr.FieldByName('datearrivals').AsDateTime;
    fm.SetContact(MainQr.FieldByName('contact').AsString);
    fm.ComboBoxClientInfo.Text:=MainQr.FieldByName('clientinfo').AsString;
    fm.SetContact2(MainQr.FieldByName('contact2').AsString);
    fm.ComboBoxClientInfo_.Text:=MainQr.FieldByName('clientinfo2').AsString;

    fm.FillRegion;
    fm.cmbRegion.ItemIndex:=fm.cmbRegion.Items.IndexOf(Mainqr.fieldByName('regionname').AsString);

    fm.FillCityRegion;
    fm.cmbCityRegion.ItemIndex:=fm.cmbCityRegion.Items.IndexOf(Mainqr.fieldByName('cityregionname').AsString);

    fm.FillStreet;
    fm.cmbStreet.ItemIndex:=fm.cmbStreet.Items.IndexOf(Mainqr.fieldByName('Streetname').AsString);
    fm.edHouseNumber.Text:=Mainqr.fieldByName('housenumber').AsString;
    fm.edApartmentNumber.Text:=Mainqr.fieldByName('apartmentnumber').AsString;
    fm.FillBalcony;
    fm.cmbBalcony.ItemIndex:=fm.cmbBalcony.Items.IndexOf(Mainqr.fieldByName('balconyname').AsString);
    fm.FillCondition;
    fm.cmbCondition.ItemIndex:=fm.cmbCondition.Items.IndexOf(Mainqr.fieldByName('Conditionname').AsString);
    fm.FillSanitaryNode;
    fm.cmbSanitaryNode.ItemIndex:=fm.cmbSanitaryNode.Items.IndexOf(Mainqr.fieldByName('SanitaryNodename').AsString);
    fm.FillHeat;
    fm.cmbHeat.ItemIndex:=fm.cmbHeat.Items.IndexOf(Mainqr.fieldByName('Heatname').AsString);
    fm.FillWater;
    fm.cmbWater.ItemIndex:=fm.cmbWater.Items.IndexOf(Mainqr.fieldByName('Watername').AsString);
    fm.FillBuilder;
    fm.cmbBuilder.ItemIndex:=fm.cmbBuilder.Items.IndexOf(Mainqr.fieldByName('Buildername').AsString);
    fm.FillInvestor;
    fm.FillStyle;
    fm.cmbStyle.ItemIndex:=fm.cmbStyle.Items.IndexOf(Mainqr.fieldByName('Stylename').AsString);
    fm.FillAgent(false,FSyncOfficeId);
    fm.cmbAgent.ItemIndex:=fm.cmbAgent.Items.IndexOf(Mainqr.fieldByName('Agentname').AsString);
    fm.FillDoor;
    fm.cmbDoor.ItemIndex:=fm.cmbDoor.Items.IndexOf(Mainqr.fieldByName('Doorname').AsString);
    fm.FillPhone;
    fm.cmbPhone.ItemIndex:=fm.cmbPhone.Items.IndexOf(Mainqr.fieldByName('Phonename').AsString);
    fm.FillCountRoom;
    fm.cmbCountRoom.ItemIndex:=fm.cmbCountRoom.Items.IndexOf(Mainqr.fieldByName('CountRoomname').AsString);
    fm.FillTypeRoom;
    fm.cmbTypeRoom.ItemIndex:=fm.cmbTypeRoom.Items.IndexOf(Mainqr.fieldByName('TypeRoomname').AsString);
    fm.FillPlanning;
    fm.cmbPlanning.ItemIndex:=fm.cmbPlanning.Items.IndexOf(Mainqr.fieldByName('Planningname').AsString);
    fm.FillStation;
    fm.cmbStation.ItemIndex:=fm.cmbStation.Items.IndexOf(Mainqr.fieldByName('Stationname').AsString);
    fm.FillTypeHouse;
    fm.cmbTypeHouse.ItemIndex:=fm.cmbTypeHouse.Items.IndexOf(Mainqr.fieldByName('TypeHousename').AsString);
    fm.FillStove;
    fm.cmbStove.ItemIndex:=fm.cmbStove.Items.IndexOf(Mainqr.fieldByName('Stovename').AsString);
    fm.FillFurniture;
    fm.cmbFurniture.ItemIndex:=fm.cmbFurniture.Items.IndexOf(Mainqr.fieldByName('Furniturename').AsString);
    fm.FillDocument;
    fm.cmbDocument.ItemIndex:=fm.cmbDocument.Items.IndexOf(Mainqr.fieldByName('Documentname').AsString);
    fm.FillSaleStatus;
    fm.cmbSaleStatus.ItemIndex:=fm.cmbSaleStatus.Items.IndexOf(Mainqr.fieldByName('SaleStatusname').AsString);
    fm.FillSelfForm;
    fm.cmbSelfForm.ItemIndex:=fm.cmbSelfForm.Items.IndexOf(Mainqr.fieldByName('SelfFormname').AsString);
    fm.FillTypePremises;
    fm.cmbTypePremises.ItemIndex:=fm.cmbTypePremises.Items.IndexOf(Mainqr.fieldByName('TypePremisesname').AsString);
    fm.FillUnitPrice;
    fm.cmbUnitPrice.ItemIndex:=fm.cmbUnitPrice.Items.IndexOf(Mainqr.fieldByName('UnitPricename').AsString);
    fm.edFloor.Text:=Mainqr.fieldByName('floor').AsString;
    fm.edCountFloor.Text:=Mainqr.fieldByName('countfloor').AsString;
    fm.edGeneralArea.Text:=Mainqr.fieldByName('generalarea').AsString;
    fm.edgroundArea.Text:=Mainqr.fieldByName('groundArea').AsString;
    fm.edDwellingArea.Text:=Mainqr.fieldByName('dwellingarea').AsString;
    fm.edKitchenArea.Text:=Mainqr.fieldByName('kitchenarea').AsString;
    fm.edTerm.Text:=Mainqr.fieldByName('term').AsString;
    fm.edPayment.Text:=Mainqr.fieldByName('payment').AsString;
    fm.edPrice.Text:=Mainqr.fieldByName('price').AsString;
    fm.edNote.Text:=Mainqr.fieldByName('note').AsString;
    {by BARt}
    fm.edAdvertismentNote.Text:=Mainqr.fieldByName('advertisment_note').AsString;
    fm.FillTaxes;
    fm.cmbTaxes.ItemIndex:=fm.cmbTaxes.Items.IndexOf(Mainqr.fieldByName('taxes').AsString);

    //fm.FillAreaBuilding;
    fm.edAreaBuilding.Text:={fm.cmbAreaBuilding.Items.IndexOf(}Mainqr.fieldByName('AreaBuilding').AsString;//);
    fm.FillPopulatedPoint;
    fm.cmbPopulatedPoint.ItemIndex:=fm.cmbPopulatedPoint.Items.IndexOf(Mainqr.fieldByName('PopulatedPoint').AsString);
    fm.FillLandFeature;
    fm.cmbLandFeature.ItemIndex:=fm.cmbLandFeature.Items.IndexOf(Mainqr.fieldByName('LandFeature').AsString);
    fm.FillExchangeFormula;
    fm.cmbExchangeFormula.ItemIndex:=fm.cmbExchangeFormula.Items.IndexOf(Mainqr.fieldByName('ExchangeFormula').AsString);
    fm.FillLocationStatus;
    fm.cmbLocationStatus.ItemIndex:=fm.cmbLocationStatus.Items.IndexOf(Mainqr.fieldByName('LocationStatus').AsString);
    //fm.FillLandMark;
    fm.edLandMark.Text:={fm.cmbLandMark.Items.IndexOf(}Mainqr.fieldByName('LandMark').AsString;//);
    fm.edCommunications.Text:=Mainqr.fieldByName('COMMUNICATIONS').AsString;
    fm.edEmail.Text:=Mainqr.fieldByName('email').AsString;
    fm.edEmail_.Text:=Mainqr.fieldByName('email2').AsString;
    fm.cbLeaseOrSale.Text:=Mainqr.fieldByName('leaseorsale').AsString;

    fm.FillObject;
    fm.cmbObject.ItemIndex:=fm.cmbObject.Items.IndexOf(Mainqr.fieldByName('Object').AsString);
    fm.FillDirection;
    fm.cmbDirection.ItemIndex:=fm.cmbDirection.Items.IndexOf(Mainqr.fieldByName('Direction').AsString);
    fm.FillAccessWays;
    fm.cmbAccessWays.ItemIndex:=fm.cmbAccessWays.Items.IndexOf(Mainqr.fieldByName('AccessWays').AsString);

    fm.edRemoteness.Text:=Mainqr.fieldByName('remoteness').AsString;
    {by BART}
    fm.edDecoration.Text:=Mainqr.fieldByName('decoration').AsString;
    fm.edGlassy.Text:=Mainqr.fieldByName('glassy').AsString;
    fm.edBlockSection.Text:=Mainqr.fieldByName('block_section').AsString;
    fm.edPrice2.Text:=Mainqr.fieldByName('price2').AsString;
    fm.cmbRecyledChange(nil);

    fm.oldPms_Premises_id:=MainQr.FieldByName('Pms_Premises_id').AsInteger;
    fm.oldpms_agent_id:=MainQr.FieldByName('pms_agent_id').AsInteger;

    fm.isEdit:=true;
    fm.isView:=false;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      MainQr.Locate('pms_premises_id;pms_agent_id',VarArrayOf([fm.oldPms_Premises_id,fm.oldpms_agent_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Premises.bibDelClick(Sender: TObject);
var
  but: Integer;
  DateRecyledOut: TDate;

(*  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbPms_Premises_Advertisment+' where Pms_Premises_id='+
            Mainqr.FieldByName('Pms_Premises_id').asString+
           ' and pms_agent_id='+
           Mainqr.FieldByName('pms_agent_id').asString;
     qr.sql.Text:=sqls;
     qr.ExecSQL;
     qr.Transaction.Commit;
     sqls:='Delete from '+tbPms_Premises+' where Pms_Premises_id='+
            Mainqr.FieldByName('Pms_Premises_id').asString+
           ' and pms_agent_id='+
           Mainqr.FieldByName('pms_agent_id').asString;
     qr.sql.Text:=sqls;
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;

     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;
  end; *)



  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    dt: TDateTime;
    T: TInfoConnectUser;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try

     FillChar(T,SizeOf(T),0);
     _GetInfoConnectUser(@T);
     dt:=_GetDateTimeFromServer;

     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbPms_Premises_Advertisment+' where Pms_Premises_id='+
            Mainqr.FieldByName('Pms_Premises_id').asString+
           ' and pms_agent_id='+
           Mainqr.FieldByName('pms_agent_id').asString;
     qr.sql.Text:=sqls;
     qr.ExecSQL;
     qr.Transaction.Commit;
     sqls:='Update '+tbPms_Premises+' Set recyled=2'+
           ', datetimeupdate='+QuotedStr(DateTimeToStr(dt))+
           ', whoupdate_id='+inttostr(T.User_id)+
           ' where Pms_Premises_id='+Mainqr.FieldByName('Pms_Premises_id').asString+
           ' and pms_agent_id='+Mainqr.FieldByName('pms_agent_id').asString;
     qr.sql.Text:=sqls;
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;

     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;
  end;

  function DeleteRecordRecyled: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    dt: TDateTime;
    T: TInfoConnectUser;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     FillChar(T,SizeOf(T),0);
     _GetInfoConnectUser(@T);
     dt:=_GetDateTimeFromServer;

     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Update '+tbPms_Premises+
           ' set datetimeupdate='+QuotedStr(DateTimeToStr(dt))+
           ', whoupdate_id='+inttostr(T.User_id)+
           ', daterecyledout='+QuotedStr(DateToStr(DateRecyledOut))+
           ', pms_station_id='+iff((fmOptions.edForDeleteTorecyled.Text)='',
                                   iff(Mainqr.FieldByName('pms_station_id').Value=Null,'null',inttostr(Mainqr.FieldByName('pms_station_id').AsInteger)),
                                   inttostr(fmOptions.edForDeleteTorecyled.Tag))+
           ', recyled='+inttostr(1)+
           ' where Pms_Premises_id='+Mainqr.FieldByName('Pms_Premises_id').asString+
           ' and pms_agent_id='+Mainqr.FieldByName('pms_agent_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;

     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

  function DeleteWarningExPlus(Msg: String): TModalResult;
  var
    fm: TForm;
    lb,lbMessage: TLabel;
    dtp: TDateTimePicker;
    bt: TButton;
  const
    Dh=0;
    dy=3;
    dx=6;
  begin
    fm:=CreateMessageDialog(CaptionDelete+' '+Msg,mtConfirmation,[mbYes,mbAll,mbNo]);
    try
      lb:=TLabel.Create(fm);
      lb.Parent:=fm;
      lb.Caption:='Дата извлечения из корзины:';
      lbMessage:=TLabel(fm.FindComponent('Message'));
      if lbMessage<>nil then begin
        lb.Left:=lbMessage.Left;
        lb.Top:=lbMessage.top+lbMessage.Height+dx;
      end;
      fm.Height:=fm.Height+Dh;
      bt:=TButton(fm.FindComponent('All'));
      if bt<>nil then bt.Caption:='Совсем';
      bt:=TButton(fm.FindComponent('Yes'));
      if bt<>nil then bt.Top:=bt.Top+Dh;
      bt:=TButton(fm.FindComponent('No'));
      if bt<>nil then bt.Top:=bt.Top+Dh;
      dtp:=TDateTimePicker.Create(fm);
      dtp.Parent:=fm;
      dtp.Left:=lb.Left+lb.Width+dx;
      dtp.Width:=82;
      dtp.Top:=lb.Top-dy;
      dtp.DateTime:=_GetWorkDate;
      fm.ActiveControl:=dtp;
      fm.Width:=fm.Width;
      fm.Position:=poScreenCenter;
      Result:=fm.ShowModal;
      DateRecyledOut:=dtp.Date;
    finally
      fm.Free;
    end;
  end;

begin
  if Mainqr.RecordCount=0 then exit;
  WarningAdvertisment;
  if FindRecyled=0 then begin
    but:=DeleteWarningExPlus('текущее предложение в корзину (да) или совсем?');
    if DateRecyledOut<_GetWorkDate then begin
      ShowErrorEx('Дата извлечения из корзины не может быть меньше текущей.');
      exit;
    end;
    case but of
      mrYes: deleteRecordRecyled;
      mrAll: deleteRecord;
    end;
  end else begin
    but:=DeleteWarningEx('предложение из корзины?');
    if but=mrYes then begin
      if not deleteRecord then begin
      end;
    end;
  end;
end;

procedure TfmRBPms_Premises.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPms_Premises;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Premises.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.TypeOperation:=TTypeOperation(tcGrid.TabIndex);
    fm.oldRecyled:=MainQr.FieldByName('recyled').AsInteger;
    fm.cmbRecyled.ItemIndex:=fm.oldRecyled;
    fm.edNN.Text:=MainQr.FieldByName('nn').AsString;
    fm.edDelivery.Text:=MainQr.FieldByName('delivery').AsString;
    fm.dtpDateArrivalsFrom.DateTime:=MainQr.FieldByName('datearrivals').AsDateTime;
    fm.SetContact(MainQr.FieldByName('contact').AsString);
    fm.SetContact2(MainQr.FieldByName('contact2').AsString);
    fm.ComboBoxClientInfo.Text:=MainQr.FieldByName('clientinfo').AsString;
    fm.ComboBoxClientInfo_.Text:=MainQr.FieldByName('clientinfo2').AsString;
    fm.FillRegion;
    fm.cmbRegion.ItemIndex:=fm.cmbRegion.Items.IndexOf(Mainqr.fieldByName('regionname').AsString);
    fm.FillCityRegion;
    fm.cmbCityRegion.ItemIndex:=fm.cmbCityRegion.Items.IndexOf(Mainqr.fieldByName('cityregionname').AsString);
    fm.FillStreet;
    fm.cmbStreet.ItemIndex:=fm.cmbStreet.Items.IndexOf(Mainqr.fieldByName('Streetname').AsString);
    fm.edHouseNumber.Text:=Mainqr.fieldByName('housenumber').AsString;
    fm.edApartmentNumber.Text:=Mainqr.fieldByName('apartmentnumber').AsString;
    fm.FillBalcony;
    fm.cmbBalcony.ItemIndex:=fm.cmbBalcony.Items.IndexOf(Mainqr.fieldByName('balconyname').AsString);
    fm.FillCondition;
    fm.cmbCondition.ItemIndex:=fm.cmbCondition.Items.IndexOf(Mainqr.fieldByName('Conditionname').AsString);
    fm.FillSanitaryNode;
    fm.cmbSanitaryNode.ItemIndex:=fm.cmbSanitaryNode.Items.IndexOf(Mainqr.fieldByName('SanitaryNodename').AsString);
    fm.FillHeat;
    fm.cmbHeat.ItemIndex:=fm.cmbHeat.Items.IndexOf(Mainqr.fieldByName('Heatname').AsString);
    fm.FillWater;
    fm.cmbWater.ItemIndex:=fm.cmbWater.Items.IndexOf(Mainqr.fieldByName('Watername').AsString);
    fm.FillBuilder;
    fm.cmbBuilder.ItemIndex:=fm.cmbBuilder.Items.IndexOf(Mainqr.fieldByName('Buildername').AsString);
    fm.FillInvestor;
    fm.FillStyle;
    fm.cmbStyle.ItemIndex:=fm.cmbStyle.Items.IndexOf(Mainqr.fieldByName('Stylename').AsString);
    fm.FillAgent(true,FSyncOfficeId);
    fm.cmbAgent.ItemIndex:=fm.cmbAgent.Items.IndexOf(Mainqr.fieldByName('Agentname').AsString);
    fm.FillDoor;
    fm.cmbDoor.ItemIndex:=fm.cmbDoor.Items.IndexOf(Mainqr.fieldByName('Doorname').AsString);
    fm.FillPhone;
    fm.cmbPhone.ItemIndex:=fm.cmbPhone.Items.IndexOf(Mainqr.fieldByName('Phonename').AsString);
    fm.FillCountRoom;
    fm.cmbCountRoom.ItemIndex:=fm.cmbCountRoom.Items.IndexOf(Mainqr.fieldByName('CountRoomname').AsString);
    fm.FillTypeRoom;
    fm.cmbTypeRoom.ItemIndex:=fm.cmbTypeRoom.Items.IndexOf(Mainqr.fieldByName('TypeRoomname').AsString);
    fm.FillPlanning;
    fm.cmbPlanning.ItemIndex:=fm.cmbPlanning.Items.IndexOf(Mainqr.fieldByName('Planningname').AsString);
    fm.FillStation;
    fm.cmbStation.ItemIndex:=fm.cmbStation.Items.IndexOf(Mainqr.fieldByName('Stationname').AsString);
    fm.FillTypeHouse;
    fm.cmbTypeHouse.ItemIndex:=fm.cmbTypeHouse.Items.IndexOf(Mainqr.fieldByName('TypeHousename').AsString);
    fm.FillStove;
    fm.cmbStove.ItemIndex:=fm.cmbStove.Items.IndexOf(Mainqr.fieldByName('Stovename').AsString);
    fm.FillFurniture;
    fm.cmbFurniture.ItemIndex:=fm.cmbFurniture.Items.IndexOf(Mainqr.fieldByName('Furniturename').AsString);
    fm.FillDocument;
    fm.cmbDocument.ItemIndex:=fm.cmbDocument.Items.IndexOf(Mainqr.fieldByName('Documentname').AsString);
    fm.FillSaleStatus;
    fm.cmbSaleStatus.ItemIndex:=fm.cmbSaleStatus.Items.IndexOf(Mainqr.fieldByName('SaleStatusname').AsString);
    fm.FillSelfForm;
    fm.cmbSelfForm.ItemIndex:=fm.cmbSelfForm.Items.IndexOf(Mainqr.fieldByName('SelfFormname').AsString);
    fm.FillTypePremises;
    fm.cmbTypePremises.ItemIndex:=fm.cmbTypePremises.Items.IndexOf(Mainqr.fieldByName('TypePremisesname').AsString);
    fm.FillUnitPrice;
    fm.cmbUnitPrice.ItemIndex:=fm.cmbUnitPrice.Items.IndexOf(Mainqr.fieldByName('UnitPricename').AsString);
    fm.edFloor.Text:=Mainqr.fieldByName('floor').AsString;
    fm.edCountFloor.Text:=Mainqr.fieldByName('countfloor').AsString;
    fm.edGeneralArea.Text:=Mainqr.fieldByName('generalarea').AsString;
    fm.edgroundArea.Text:=Mainqr.fieldByName('groundArea').AsString;
    fm.edDwellingArea.Text:=Mainqr.fieldByName('dwellingarea').AsString;
    fm.edKitchenArea.Text:=Mainqr.fieldByName('kitchenarea').AsString;
    fm.edTerm.Text:=Mainqr.fieldByName('term').AsString;
    fm.edPayment.Text:=Mainqr.fieldByName('payment').AsString;
    fm.edPrice.Text:=Mainqr.fieldByName('price').AsString;
    fm.edNote.Text:=Mainqr.fieldByName('note').AsString;
    {by BARt}
    fm.edAdvertismentNote.Text:=Mainqr.fieldByName('advertisment_note').AsString;
    fm.FillTaxes;
    fm.cmbTaxes.ItemIndex:=fm.cmbTaxes.Items.IndexOf(Mainqr.fieldByName('taxes').AsString);

  //  fm.FillAreaBuilding;
    fm.edAreaBuilding.Text:={fm.cmbAreaBuilding.Items.IndexOf(}Mainqr.fieldByName('AreaBuilding').AsString;//);
    fm.FillPopulatedPoint;
    fm.cmbPopulatedPoint.ItemIndex:=fm.cmbPopulatedPoint.Items.IndexOf(Mainqr.fieldByName('PopulatedPoint').AsString);
    fm.FillLandFeature;
    fm.cmbLandFeature.ItemIndex:=fm.cmbLandFeature.Items.IndexOf(Mainqr.fieldByName('LandFeature').AsString);
    fm.FillExchangeFormula;
    fm.cmbExchangeFormula.ItemIndex:=fm.cmbExchangeFormula.Items.IndexOf(Mainqr.fieldByName('ExchangeFormula').AsString);
    fm.FillLocationStatus;
    fm.cmbLocationStatus.ItemIndex:=fm.cmbLocationStatus.Items.IndexOf(Mainqr.fieldByName('LocationStatus').AsString);
    //fm.FillLandMark;
    fm.edLandMark.Text:={fm.cmbLandMark.Items.IndexOf(}Mainqr.fieldByName('LandMark').AsString;//);

    fm.edCommunications.Text:=Mainqr.fieldByName('COMMUNICATIONS').AsString;
    fm.edEmail.Text:=Mainqr.fieldByName('email').AsString;
    fm.edEmail_.Text:=Mainqr.fieldByName('email2').AsString;
    fm.cbLeaseOrSale.Text:=Mainqr.fieldByName('leaseorsale').AsString;

    fm.FillObject;
    fm.cmbObject.ItemIndex:=fm.cmbObject.Items.IndexOf(Mainqr.fieldByName('Object').AsString);
    fm.FillDirection;
    fm.cmbDirection.ItemIndex:=fm.cmbDirection.Items.IndexOf(Mainqr.fieldByName('Direction').AsString);
    fm.FillAccessWays;
    fm.cmbAccessWays.ItemIndex:=fm.cmbAccessWays.Items.IndexOf(Mainqr.fieldByName('AccessWays').AsString);

    fm.edRemoteness.Text:=Mainqr.fieldByName('remoteness').AsString;


    {by BARt}
    fm.edDecoration.Text:=Mainqr.fieldByName('decoration').AsString;
    fm.edGlassy.Text:=Mainqr.fieldByName('glassy').AsString;
    fm.edBlockSection.Text:=Mainqr.fieldByName('block_section').AsString;
    fm.edPrice2.Text:=Mainqr.fieldByName('price2').AsString;

    fm.oldPms_Premises_id:=MainQr.FieldByName('Pms_Premises_id').AsInteger;
    fm.oldpms_agent_id:=MainQr.FieldByName('pms_agent_id').AsInteger;

    fm.isEdit:=false;
    fm.isView:=true;


    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Premises.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPms_Premises;
  filstr: string;
begin
 fm:=TfmEditRBPms_Premises.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.TypeOperation:=TTypeOperation(tcGrid.TabIndex);
  fm.SetEnabledFilter(true);

  fm.FillRegion;
  fm.FillCityRegion;
  fm.FillStreet;
  fm.FillBalcony;
  fm.FillCondition;
  fm.FillSanitaryNode;
  fm.FillHeat;
  fm.FillWater;
  fm.FillBuilder;
  fm.FillInvestor;
  fm.FillStyle;
  fm.FillAgent(true,FSyncOfficeId);
  fm.FillDoor;
  fm.FillPhone;
  fm.FillCountRoom;
  fm.FillTypeRoom;
  fm.FillPlanning;
  fm.FillStation;
  fm.FillTypeHouse;
  fm.FillStove;
  fm.FillFurniture;
  fm.FillDocument;
  fm.FillSaleStatus;
  fm.FillSelfForm;
  fm.FillTypePremises;
  fm.FillUnitPrice;
  fm.FillTaxes;

  //fm.FillAreaBuilding;
  fm.FillPopulatedPoint;
  fm.FillLandFeature;
  fm.FillExchangeFormula;
  fm.FillLocationStatus;
  //fm.FillLandMark;

  fm.FillObject;
  fm.FillDirection;
  fm.FillAccessWays;


  fm.bibAdvertisment.Visible:=false;
  fm.cbAdverisment.Visible:=True;
  ClearFilter;
  LoadFilter;

  if isFindRegionName then fm.cmbRegion.Text:=FindRegionName;
  if isFindCityRegionName then fm.cmbCityRegion.Text:=FindCityRegionName;
  if isFindStreetName then fm.cmbStreet.Text:=FindStreetName;
  if isFindBalconyName then fm.cmbBalcony.Text:=FindBalconyName;
  if isFindConditionName then fm.cmbCondition.Text:=FindConditionName;
  if isFindSanitaryNodeName then fm.cmbSanitaryNode.Text:=FindSanitaryNodeName;
  if isFindHeatName then fm.cmbHeat.Text:=FindHeatName;
  if isFindWaterName then fm.cmbWater.Text:=FindWaterName;
  if isFindBuilderName then fm.cmbBuilder.Text:=FindBuilderName;
  if isFindStyleName then fm.cmbStyle.Text:=FindStyleName;
  if isFindAgentName then fm.cmbAgent.Text:=FindAgentName;
  if isFindDoorName then fm.cmbDoor.Text:=FindDoorName;
  if isFindCountRoomName then fm.cmbCountRoom.Text:=FindCountRoomName;
  if isFindTypeRoomName then fm.cmbTypeRoom.Text:=FindTypeRoomName;
  if isFindPlanningName then fm.cmbPlanning.Text:=FindPlanningName;
  if isFindStationName then fm.cmbStation.Text:=FindStationName;
  if isFindTypeHouseName then fm.cmbTypeHouse.Text:=FindTypeHouseName;
  if isFindStoveName then fm.cmbStove.Text:=FindStoveName;
  if isFindFurnitureName then fm.cmbFurniture.Text:=FindFurnitureName;
  if isFindContact then fm.SetContact(FindContact);
  if isFindClientInfo then fm.ComboBoxClientInfo.Text:=FindClientInfo;
  if isFindContact2 then fm.SetContact2(FindContact2);
  if isFindClientInfo2 then fm.ComboBoxClientInfo_.Text:=FindClientInfo2;
  if isFindHouseNumber then fm.edHouseNumber.Text:=FindHouseNumber;
  if isFindApartmentNumber then fm.edApartmentNumber.Text:=FindApartmentNumber;
  if isFindPhoneName then fm.cmbPhone.Text:=FindPhoneName;
  if isFindDocumentName then fm.cmbDocument.Text:=FindDocumentName;
  if isFindFloor then fm.edFloor.Text:=FindFloor;
  if isFindCountFloor then fm.edCountFloor.Text:=FindCountFloor;
  if isFindGeneralArea then fm.edGeneralArea.Text:=FindGeneralArea;
  if isFindgroundArea then fm.edgroundArea.Text:=FindgroundArea;
  if isFindDwellingArea then fm.edDwellingArea.Text:=FindDwellingArea;
  if isFindKitchenArea then fm.edKitchenArea.Text:=FindKitchenArea;
  if isFindPrice then begin
    fm.cmbPricePlus.ItemIndex:=fm.cmbPricePlus.Items.IndexOf(FindPricePlus);
    fm.edPrice.Text:=FindPrice;
  end;
  if isFindTerm then fm.edTerm.Text:=FindTerm;
  if isFindPayment then fm.edPayMent.Text:=FindPayment;
  if isFindNote then fm.edNote.Text:=FindNote;
  {by BARt}
  if isFindAdvertismentNote then fm.edAdvertismentNote.Text:=FindAdvertismentNote;
  fm.cbAdverisment.Checked:=FindAdvertisment;
  if isFindTaxes then fm.cmbTaxes.Text:=FindTaxes;

  if isFindAreaBuilding then fm.edAreaBuilding.Text:=FindAreaBuilding;
  if isFindPopulatedPoint then fm.cmbPopulatedPoint.Text:=FindPopulatedPoint;
  if isFindLandFeature then fm.cmbLandFeature.Text:=FindLandFeature;
  if isFindExchangeFormula then fm.cmbExchangeFormula.Text:=FindExchangeFormula;
  if isFindLocationStatus then fm.cmbLocationStatus.Text:=FindLocationStatus;
  if isFindLandMark then fm.edLandMark.Text:=FindLandMark;
  if isFindCommunications then fm.edCommunications.Text:=FindCommunications;
  if isFindEmail then fm.edEmail.Text:=FindEmail;
  if isFindEmail2 then fm.edEmail_.Text:=FindEmail2;
  if isFindLeaseOrSale then fm.cbLeaseOrSale.Text:=FindLeaseOrSale;

  if isFindObject then fm.cmbObject.Text:=FindObject;
  if isFindDirection then fm.cmbDirection.Text:=FindDirection;
  if isFindAccessWays then fm.cmbAccessWays.Text:=FindAccessWays;
  if isFindRemoteness then fm.edRemoteness.Text:=FindRemoteness;



  {by BARt}
  if isFindNN then fm.edNN.Text:=FindNN;
  if isFindDelivery then fm.edDelivery.Text:=FindDelivery;
  if isFindDateArrivalsStart then fm.dtpDateArrivalsFrom.Date:=FindDateArrivalsStart;
  fm.dtpDateArrivalsFrom.Checked:=isFindDateArrivalsStart;
  if isFindDateArrivalsEnd then fm.dtpDateArrivalsTo.Date:=FindDateArrivalsEnd;
  fm.dtpDateArrivalsTo.Checked:=isFindDateArrivalsEnd;
  if isFindRecyled then fm.cmbRecyled.ItemIndex:=FindRecyled;
  if isFindSaleStatusName then fm.cmbSaleStatus.Text:=FindSaleStatusName;
  if isFindSelfFormName then fm.cmbSelfForm.Text:=FindSelfFormName;
  if isFindTypePremisesName then fm.cmbTypePremises.Text:=FindTypePremisesName;
  if isFindUnitPriceName then fm.cmbUnitPrice.Text:=FindUnitPriceName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindRegionName:=Trim(fm.cmbRegion.Text);
    FindCityRegionName:=Trim(fm.cmbCityRegion.Text);
    FindStreetName:=Trim(fm.cmbStreet.Text);
    FindBalconyName:=Trim(fm.cmbBalcony.Text);
    FindConditionName:=Trim(fm.cmbCondition.Text);
    FindSanitaryNodeName:=Trim(fm.cmbSanitaryNode.Text);
    FindHeatName:=Trim(fm.cmbHeat.Text);
    FindWaterName:=Trim(fm.cmbWater.Text);
    FindBuilderName:=Trim(fm.cmbBuilder.Text);
    FindStyleName:=Trim(fm.cmbStyle.Text);
    FindAgentName:=Trim(fm.cmbAgent.Text);
    FindDoorName:=Trim(fm.cmbDoor.Text);
    FindCountRoomName:=Trim(fm.cmbCountRoom.Text);
    FindTypeRoomName:=Trim(fm.cmbTypeRoom.Text);
    FindPlanningName:=Trim(fm.cmbPlanning.Text);
    FindStationName:=Trim(fm.cmbStation.Text);
    FindTypeHouseName:=Trim(fm.cmbTypeHouse.Text);
    FindStoveName:=Trim(fm.cmbStove.Text);
    FindFurnitureName:=Trim(fm.cmbFurniture.Text);
    FindContact:=Trim(fm.GetContact);
    FindContact2:=Trim(fm.GetContact2);
    FindNN:=Trim(fm.edNN.Text);
    FindDelivery:=Trim(fm.edDelivery.Text);
    FindClientInfo:=Trim(fm.ComboBoxClientInfo.Text);
    FindClientInfo2:=Trim(fm.ComboBoxClientInfo_.Text);
    FindHouseNumber:=Trim(fm.edHouseNumber.Text);
    FindApartmentNumber:=Trim(fm.edApartmentNumber.Text);
    FindPhoneName:=Trim(fm.cmbPhone.Text);
    FindDocumentName:=Trim(fm.cmbDocument.Text);
    FindFloor:=Trim(fm.edFloor.Text);
    FindCountFloor:=Trim(fm.edCountFloor.Text);
    FindGeneralArea:=Trim(fm.edGeneralArea.Text);
    FindgroundArea:=Trim(fm.edgroundArea.Text);
    FindDwellingArea:=Trim(fm.edDwellingArea.Text);
    FindKitchenArea:=Trim(fm.edKitchenArea.Text);
    FindPrice:=Trim(fm.edPrice.Text);
    FindPricePlus:=fm.cmbPricePlus.Text;
    FindTerm:=Trim(fm.edTerm.Text);
    FindPayment:=Trim(fm.edPayMent.Text);
    FindNote:=Trim(fm.edNote.Text);
    {by BARt}
    FindAdvertismentNote:=Trim(fm.edAdvertismentNote.Text);
    FindAdvertisment:=fm.cbAdverisment.Checked;
    FindTaxes:=Trim(fm.cmbTaxes.Text);

    FindAreaBuilding:=Trim(fm.edAreaBuilding.Text);
    FindPopulatedPoint:=Trim(fm.cmbPopulatedPoint.Text);
    FindLandFeature:=Trim(fm.cmbLandFeature.Text);
    FindExchangeFormula:=Trim(fm.cmbExchangeFormula.Text);
    FindLocationStatus:=Trim(fm.cmbLocationStatus.Text);
    FindLandMark:=Trim(fm.edLandMark.Text);
    FindCommunications:=Trim(fm.edCommunications.Text);
    FindEmail:=Trim(fm.edEmail.Text);
    FindEmail2:=Trim(fm.edEmail_.Text);

    FindLeaseOrSale:=Trim(fm.cbLeaseOrSale.Text);

    FindObject:=Trim(fm.cmbObject.Text);
    FindDirection:=Trim(fm.cmbDirection.Text);
    FindAccessWays:=Trim(fm.cmbAccessWays.Text);
    FindRemoteness:=Trim(fm.edRemoteness.Text);



    {by Bart}
    FindDateArrivalsStart:=fm.dtpDateArrivalsFrom.Date;
    isFindDateArrivalsStart:=fm.dtpDateArrivalsFrom.Checked;
    FindDateArrivalsEnd:=fm.dtpDateArrivalsTo.Date;
    isFindDateArrivalsEnd:=fm.dtpDateArrivalsTo.Checked;
    FindRecyled:=fm.cmbRecyled.ItemIndex;
    FindSaleStatusName:=Trim(fm.cmbSaleStatus.Text);
    FindSelfFormName:=Trim(fm.cmbSelfForm.Text);
    FindTypePremisesName:=Trim(fm.cmbTypePremises.Text);
    FindUnitPriceName:=Trim(fm.cmbUnitPrice.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    SaveFilter;
    SetTabCaption;
    ActiveQuery(false);
    //ViewCount;
  end;
 finally
  fm.Free;
 end;
end;
{$WARNINGS OFF}
function TfmRBPms_Premises.GetFilterString: string;
var
  Apos: Integer;
  s1,s2,s3: string;
  FilInSide: string;
  wherestr: string;
  isFindNoRemoved: Boolean;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,addstr8,addstr9,addstr10: string;
  addstr11,addstr12,addstr13,addstr14,addstr15,addstr16,addstr17,addstr18,addstr19: string;
  addstr20,addstr21,addstr22,addstr23,addstr24,addstr25,addstr26,addstr27,addstr28: string;
  addstr29,addstr30,addstr31,addstr32,addstr33,addstr34,addstr35,addstr36,addstr37,
  addstr38,addstr39,addstr40,addstr41,addstr42,addstr43,addstr44,addstr45,addstr46,addstr47,addstr48,addstr49,
  addstr50,addstr51,addstr52,addstr53,addstr54,addstr55,addstr56,addstr57,addstr58,addstr59,addstr60,addstr61,
  addstr62,addstr63,addstr64,addstr65: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10: string;
  and11,and12,and13,and14,and15,and16: string;
  and17,and18,and19,and20,and21,and22,and23,and24: string;
  and25,and26,and27,and28,and29,and30,and31,and32,and33,and34,and35,and36,and37,
  and38,and39,and40,and41,and42,and43,and44,and45,and46,and47,and48,and49,and50,and51,and52,and53,and54,and55,and56,and57,and58,
  and59,and60,and61,and62,and63,and64: string;
begin

    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindTypeOperation:=true;
    isFindRecyled:=not NotUseRecyled;
    isFindNoRemoved:=Trim(inherited GetFilterStringNoRemoved)<>'';
    isFindRegionName:=Trim(FindRegionName)<>'';
    isFindCityRegionName:=Trim(FindCityRegionName)<>'';
    isFindStreetName:=Trim(FindStreetName)<>'';
    isFindBalconyName:=Trim(FindBalconyName)<>'';
    isFindConditionName:=Trim(FindConditionName)<>'';
    isFindSanitaryNodeName:=Trim(FindSanitaryNodeName)<>'';
    isFindHeatName:=Trim(FindHeatName)<>'';
    isFindWaterName:=Trim(FindWaterName)<>'';
    isFindBuilderName:=Trim(FindBuilderName)<>'';
    isFindStyleName:=Trim(FindStyleName)<>'';
    isFindAgentName:=Trim(FindAgentName)<>'';
    isFindDoorName:=Trim(FindDoorName)<>'';
    isFindCountRoomName:=Trim(FindCountRoomName)<>'';
    isFindTypeRoomName:=Trim(FindTypeRoomName)<>'';
    isFindPlanningName:=Trim(FindPlanningName)<>'';
    isFindStationName:=Trim(FindStationName)<>'';
    isFindTypeHouseName:=Trim(FindTypeHouseName)<>'';
    isFindStoveName:=Trim(FindStoveName)<>'';
    isFindFurnitureName:=Trim(FindStoveName)<>'';
    isFindContact:=Trim(FindContact)<>'';
    isFindContact2:=Trim(FindContact2)<>'';
    isFindNN:=Trim(FindNN)<>'';
    isFindDelivery:=Trim(FindDelivery)<>'';
    isFindClientInfo:=Trim(FindClientInfo)<>'';
    isFindClientInfo2:=Trim(FindClientInfo2)<>'';
    isFindHouseNumber:=Trim(FindHouseNumber)<>'';
    isFindApartmentNumber:=Trim(FindApartmentNumber)<>'';
    isFindPhoneName:=Trim(FindPhoneName)<>'';
    isFindDocumentName:=Trim(FindDocumentName)<>'';
    isFindFloor:=isInteger(FindFloor);
    isFindCountFloor:=isInteger(FindCountFloor);
    isFindGeneralArea:=isFloat(FindGeneralArea);
    isFindgroundArea:=isFloat(FindgroundArea);
    isFindDwellingArea:=isFloat(FindDwellingArea);
    isFindKitchenArea:=isFloat(FindKitchenArea);
    isFindPrice:=isFloat(FindPrice);
    isFindTerm:=Trim(FindTerm)<>'';
    isFindPayment:=Trim(FindPayment)<>'';
    isFindNote:=Trim(FindNote)<>'';
    {by BARt}
    isFindAdvertismentNote:=Trim(FindAdvertismentNote)<>'';
    isFindTaxes:=Trim(FindTaxes)<>'';
    isFindAreaBuilding:=Trim(FindAreaBuilding)<>'';
    isFindPopulatedPoint:=Trim(FindPopulatedPoint)<>'';
    isFindLandFeature:=Trim(FindLandFeature)<>'';
    isFindExchangeFormula:=Trim(FindExchangeFormula)<>'';
    isFindLocationStatus:=Trim(FindLocationStatus)<>'';
    isFindLandMark:=Trim(FindLandMark)<>'';
    isFindCommunications:=Trim(FindCommunications)<>'';
    isFindEmail:=Trim(FindEmail)<>'';
    isFindEmail2:=Trim(FindEmail2)<>'';
    isFindLeaseOrSale:=Trim(FindLeaseOrSale)<>'';

    isFindObject:=Trim(FindObject)<>'';
    isFindDirection:=Trim(FindDirection)<>'';
    isFindAccessWays:=Trim(FindAccessWays)<>'';
    isFindRemoteness:=Trim(FindRemoteness)<>'';


    isFindAdvertisment:=FindAdvertisment and not NotUseAdvFilter;
    {by BARt}
    isFindDateArrivalsStart:=isFindDateArrivalsStart;
    isFindDateArrivalsEnd:=isFindDateArrivalsEnd;
    isFindSaleStatusName:=Trim(FindSaleStatusName)<>'';
    isFindSelfFormName:=Trim(FindSelfFormName)<>'';
    isFindTypePremisesName:=Trim(FindTypePremisesName)<>'';
    isFindUnitPriceName:=Trim(FindUnitPriceName)<>'';


    if isFindNoRemoved or isFindTypeOperation or isFindRegionName or isFindCityRegionName or isFindStreetName or isFindBalconyName or
       isFindConditionName or isFindSanitaryNodeName or isFindHeatName or isFindWaterName or
       isFindAgentName or isFindDoorName or isFindStyleName or isFindBuilderName or
       isFindCountRoomName or isFindTypeRoomName or isFindPlanningName or isFindStationName or
       isFindTypeHouseName or isFindStoveName or isFindFurnitureName or isFindContact or isFindClientInfo or isFindContact2 or isFindClientInfo2 or
       isFindHouseNumber or isFindApartmentNumber or isFindPhoneName or isFindDocumentName or isFindFloor or
       isFindCountFloor  or isFindGeneralArea or isFindgroundArea or
       isFindDwellingArea or  isFindKitchenArea or isFindUnitPriceName or
       isFindPrice or  isFindTerm or isFindPayment or isFindNote or isFindDateArrivalsStart or
       isFindDateArrivalsEnd or isFindRecyled or isFindSaleStatusName or isFindSelfFormName or
       isFindTypePremisesName or isFindNN or isFindDelivery {by BARt} or isFindAdvertismentNote or isFindAdvertisment or isFindTaxes or
       isFindAreaBuilding or isFindPopulatedPoint or isFindLandFeature or isFindExchangeFormula or isFindLocationStatus
       or isFindLandMark or isFindCommunications or isFindEmail or isFindEmail2 or isFindLeaseOrSale
       or isFindObject or isFindDirection or isFindAccessWays or isFindRemoteness{by BARt}
       then begin
     wherestr:=' where ';
    end else begin
     wherestr:='';
    end;

    if FilterInside then FilInSide:='%';

    if isFindTypeOperation then begin
      addstr1:=' typeoperation='+inttostr(tcGrid.TabIndex)+' ';
    end;

    if isFindRecyled then begin
      addstr2:=' recyled='+inttostr(FindRecyled)+' ';
    end;

    if FindRecyled=2 then begin
      isFindRecyled:=true;
      addstr2:=' recyled in (0,1) ';
    end;

    if isFindNoRemoved then begin
      addstr3:=' '+inherited GetFilterStringNoRemoved+' ';
    end;

    if isFindRegionName then begin
      addstr4:=' Upper(r.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindRegionName+'%'))+' ';
    end;

    if isFindStreetName then begin
      addstr5:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindStreetName+'%'))+' ';
    end;

    if isFindBalconyName then begin
      addstr6:=' Upper(b.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBalconyName+'%'))+' ';
    end;

    if isFindConditionName then begin
      addstr7:=' Upper(c.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindConditionName+'%'))+' ';
    end;

    if isFindSanitaryNodeName then begin
      addstr8:=' Upper(sn.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSanitaryNodeName+'%'))+' ';
    end;

    if isFindAgentName then begin
      addstr9:=' Upper(a.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAgentName+'%'))+' ';
    end;

    if isFindDoorName then begin
      addstr10:=' Upper(d.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDoorName+'%'))+' ';
    end;

    if isFindCountRoomName then begin
      addstr11:=' Upper(cr.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCountRoomName+'%'))+' ';
    end;

    if isFindTypeRoomName then begin
      addstr12:=' Upper(tr.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypeRoomName+'%'))+' ';
    end;

    if isFindPlanningName then begin
      addstr13:=' Upper(pl.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPlanningName+'%'))+' ';
    end;

    if isFindStationName then begin
      addstr14:=' Upper(st.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindStationName+'%'))+' ';
    end;

    if isFindTypeHouseName then begin
      addstr15:=' Upper(th.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypeHouseName+'%'))+' ';
    end;

    if isFindStoveName then begin
      addstr16:=' Upper(sv.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindStoveName+'%'))+' ';
    end;

    if isFindFurnitureName then begin
      addstr17:=' Upper(f.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFurnitureName+'%'))+' ';
    end;

    if isFindContact then begin
//      addstr18:=' Upper(contact) like '+AnsiUpperCase(QuotedStr(FilInSide+FindContact+'%'))+' ';
      APos:=-1;
      s3:=FindContact;
      while Apos<>0 do begin
        APos:=Pos(',',s3);
        if APos>0 then begin
          s2:=trim(Copy(s3,1,Apos-Length(',')));
          s3:=Copy(s3,APos+Length(','),Length(s3));
          s1:=iff(s1='','',s1+' or ')+' Upper(contact) like '+AnsiUpperCase(QuotedStr(FilInSide+s2+'%'))+' ';
        end else begin
          s2:=Trim(s3);
          s1:=iff(s1='','',s1+' or ')+' Upper(contact) like '+AnsiUpperCase(QuotedStr(FilInSide+s2+'%'))+' ';
        end;
      end;
      addstr18:=' ('+s1+') ';
    end;

    if isFindHouseNumber then begin
      addstr19:=' Upper(housenumber) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHouseNumber+'%'))+' ';
    end;

    if isFindApartmentNumber then begin
      addstr20:=' Upper(apartmentnumber) like '+AnsiUpperCase(QuotedStr(FilInSide+FindApartmentNumber+'%'))+' ';
    end;

    if isFindPhoneName then begin
      addstr21:=' Upper(ph.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPhoneName+'%'))+' ';
    end;

    if isFindDocumentName then begin
      addstr22:=' Upper(dc.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDocumentName+'%'))+' ';
    end;

    if isFindFloor then begin
//      addstr23:=' floor='+QuotedStr(FindFloor)+' ';
      addstr22:=' Upper(floor) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFloor+'%'))+' ';
    end;

    if isFindCountFloor then begin
      addstr24:=' countfloor='+FindCountFloor+' ';
    end;

    if isFindGeneralArea then begin
      addstr25:=' generalarea='+ChangeChar(FindGeneralArea,',','.')+' ';
    end;

    if isFindDwellingArea then begin
      addstr26:=' dwellingarea='+ChangeChar(FindDwellingArea,',','.')+' ';
    end;

    if isFindKitchenArea then begin
      addstr27:=' kitchenarea='+ChangeChar(FindKitchenArea,',','.')+' ';
    end;

    if isFindPrice then begin
      addstr28:=' price'+FindPricePlus+ChangeChar(FindPrice,',','.')+' ';
    end;

    if isFindTerm then begin
      addstr29:=' Upper(term) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTerm+'%'))+' ';
    end;

    if isFindPayment then begin
      addstr30:=' Upper(payment) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPayment+'%'))+' ';
    end;

    if isFindNote then begin
      addstr31:=' Upper(p.note) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNote+'%'))+' ';
    end;

    if isFindDateArrivalsStart then begin
      addstr32:=' datearrivals>='+AnsiUpperCase(QuotedStr(DateToStr(FindDateArrivalsStart)))+' ';
    end;

    if isFindDateArrivalsEnd then begin
      addstr33:=' datearrivals<='+AnsiUpperCase(QuotedStr(DateToStr(FindDateArrivalsEnd)))+' ';
    end;

    if isFindSaleStatusName then begin
      addstr34:=' Upper(ss.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSaleStatusName+'%'))+' ';
    end;

    if isFindSelfFormName then begin
      addstr35:=' Upper(sf.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSelfFormName+'%'))+' ';
    end;

    if isFindTypePremisesName then begin
      addstr36:=' Upper(tp.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypePremisesName+'%'))+' ';
    end;

    if isFindUnitPriceName then begin
      addstr37:=' Upper(u.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUnitPriceName+'%'))+' ';
    end;

    if isFindClientInfo then begin
      addstr38:=' Upper(clientinfo) like '+AnsiUpperCase(QuotedStr(FilInSide+FindClientInfo+'%'))+' ';
    end;

    if isFindNN then begin
      addstr39:=' Upper(nn) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNN+'%'))+' ';
    end;

    if isFindgroundArea then begin
      addstr40:=' groundArea='+ChangeChar(FindgroundArea,',','.')+' ';
    end;

    if isFindWaterName then begin
      addstr41:=' Upper(w.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWaterName+'%'))+' ';
    end;

    if isFindHeatName then begin
      addstr42:=' Upper(h.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHeatName+'%'))+' ';
    end;

    if isFindStyleName then begin
      addstr43:=' Upper(sl.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindStyleName+'%'))+' ';
    end;

    if isFindBuilderName then begin
      addstr44:=' Upper(bl.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBuilderName+'%'))+' ';
    end;

    if isFindDelivery then begin
      addstr45:=' Upper(delivery) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDelivery+'%'))+' ';
    end;

    if isFindCityRegionName then begin
      addstr46:=' Upper(crg.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCityRegionName+'%'))+' ';
    end;

 {by BARt}
    if isFindAdvertismentNote then begin
      addstr47:=' Upper(p.advertisment_note) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAdvertismentNote+'%'))+' ';
    end;

    if isFindAdvertisment then begin

      addstr48:=' p.pms_premises_id in (select ppa.pms_premises_id from pms_premises_advertisment ppa)  and '+
                ' p.pms_agent_id in (select ppa.pms_agent_id from pms_premises_advertisment ppa)'+' ';
    end;

    if isFindTaxes then begin
      addstr49:=' Upper(tx.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTaxes+'%'))+' ';
    end;

    if isFindAreaBuilding then begin
      addstr50:=' Upper(p.areabuilding) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAreaBuilding+'%'))+' ';
    end;

    if isFindPopulatedPoint then begin
      addstr51:=' Upper(ppt.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPopulatedPoint+'%'))+' ';
    end;

    if isFindLandFeature then begin
      addstr52:=' Upper(lf.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindLandFeature+'%'))+' ';
    end;

    if isFindExchangeFormula then begin
      addstr53:=' Upper(ef.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindExchangeFormula+'%'))+' ';
    end;

    if isFindLocationStatus then begin
      addstr54:=' Upper(ls.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindLocationStatus+'%'))+' ';
    end;

    if isFindLandMark then begin
      addstr55:=' Upper(p.landmark) like '+AnsiUpperCase(QuotedStr(FilInSide+FindLandMark+'%'))+' ';
    end;

    if isFindCommunications then begin
      addstr56:=' Upper(p.communications) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCommunications+'%'))+' ';
    end;

    if isFindEmail then begin
      addstr57:=' Upper(p.email) like '+AnsiUpperCase(QuotedStr(FilInSide+FindEmail+'%'))+' ';
    end;

    if isFindLeaseOrSale then begin
      addstr58:=' Upper(p.leaseorsale) like '+AnsiUpperCase(QuotedStr(FilInSide+FindLeaseOrSale+'%'))+' ';
    end;

    if isFindContact2 then begin
//      addstr18:=' Upper(contact) like '+AnsiUpperCase(QuotedStr(FilInSide+FindContact+'%'))+' ';
      APos:=-1;
      s3:=FindContact2;
      while Apos<>0 do begin
        APos:=Pos(',',s3);
        if APos>0 then begin
          s2:=trim(Copy(s3,1,Apos-Length(',')));
          s3:=Copy(s3,APos+Length(','),Length(s3));
          s1:=iff(s1='','',s1+' or ')+' Upper(contact2) like '+AnsiUpperCase(QuotedStr(FilInSide+s2+'%'))+' ';
        end else begin
          s2:=Trim(s3);
          s1:=iff(s1='','',s1+' or ')+' Upper(contact2) like '+AnsiUpperCase(QuotedStr(FilInSide+s2+'%'))+' ';
        end;
      end;
      addstr59:=' ('+s1+') ';
    end;

    if isFindClientInfo2 then begin
      addstr60:=' Upper(clientinfo2) like '+AnsiUpperCase(QuotedStr(FilInSide+FindClientInfo+'%'))+' ';
    end;

    if isFindEmail2 then begin
      addstr61:=' Upper(p.email2) like '+AnsiUpperCase(QuotedStr(FilInSide+FindEmail+'%'))+' ';
    end;

    if isFindObject then begin
      addstr62:=' Upper(obj.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindObject+'%'))+' ';
    end;

    if isFindDirection then begin
      addstr63:=' Upper(dir.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDirection+'%'))+' ';
    end;

    if isFindAccessWays then begin
      addstr64:=' Upper(aw.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAccessWays+'%'))+' ';
    end;

    if isFindRemoteness then begin
      addstr65:=' Upper(p.remoteness) like '+AnsiUpperCase(QuotedStr(FilInSide+FindRemoteness+'%'))+' ';
    end;

  {by BARt}


    if (isFindTypeOperation and isFindRecyled)or
       (isFindTypeOperation and isFindNoRemoved)or
       (isFindTypeOperation and isFindRegionName)or
       (isFindTypeOperation and isFindCityRegionName)or
       (isFindTypeOperation and isFindStreetName)or
       (isFindTypeOperation and isFindBalconyName)or
       (isFindTypeOperation and isFindConditionName)or
       (isFindTypeOperation and isFindSanitaryNodeName)or
       (isFindTypeOperation and isFindAgentName)or
       (isFindTypeOperation and isFindDoorName)or
       (isFindTypeOperation and isFindCountRoomName)or
       (isFindTypeOperation and isFindTypeRoomName)or
       (isFindTypeOperation and isFindPlanningName)or
       (isFindTypeOperation and isFindStationName)or
       (isFindTypeOperation and isFindTypeHouseName)or
       (isFindTypeOperation and isFindStoveName)or
       (isFindTypeOperation and isFindFurnitureName)or
       (isFindTypeOperation and isFindContact)or
       (isFindTypeOperation and isFindHouseNumber)or
       (isFindTypeOperation and isFindApartmentNumber)or
       (isFindTypeOperation and isFindPhoneName)or
       (isFindTypeOperation and isFindDocumentName)or
       (isFindTypeOperation and isFindFloor)or
       (isFindTypeOperation and isFindCountFloor)or
       (isFindTypeOperation and isFindGeneralArea)or
       (isFindTypeOperation and isFindDwellingArea)or
       (isFindTypeOperation and isFindKitchenArea)or
       (isFindTypeOperation and isFindPrice)or
       (isFindTypeOperation and isFindTerm)or
       (isFindTypeOperation and isFindPayment)or
       (isFindTypeOperation and isFindNote)or
       (isFindTypeOperation and isFindDateArrivalsStart)or
       (isFindTypeOperation and isFindDateArrivalsEnd)or
       (isFindTypeOperation and isFindSaleStatusName)or
       (isFindTypeOperation and isFindSelfFormName)or
       (isFindTypeOperation and isFindTypePremisesName)or
       (isFindTypeOperation and isFindUnitPriceName)or
       (isFindTypeOperation and isFindClientInfo)or
       (isFindTypeOperation and isFindNN)or
       (isFindTypeOperation and isFindGroundArea)or
       (isFindTypeOperation and isFindWaterName)or
       (isFindTypeOperation and isFindHeatName)or
       (isFindTypeOperation and isFindStyleName)or
       (isFindTypeOperation and isFindBuilderName)or
       (isFindTypeOperation and isFindDelivery)or
       (isFindTypeOperation and isFindAdvertismentNote)or
       (isFindTypeOperation and isFindTaxes)or

       (isFindTypeOperation and isFindAreaBuilding)or
       (isFindTypeOperation and isFindPopulatedPoint)or
       (isFindTypeOperation and isFindLandFeature)or
       (isFindTypeOperation and isFindExchangeFormula)or
       (isFindTypeOperation and isFindLocationStatus)or
       (isFindTypeOperation and isFindLandMark)or
       (isFindTypeOperation and isFindCommunications)or
       (isFindTypeOperation and isFindEmail)or
       (isFindTypeOperation and isFindLeaseOrSale)or

       (isFindTypeOperation and isFindContact2)or
       (isFindTypeOperation and isFindClientInfo2)or
       (isFindTypeOperation and isFindEmail2)or

       (isFindTypeOperation and isFindObject)or
       (isFindTypeOperation and isFindDirection)or
       (isFindTypeOperation and isFindAccessWays)or
       (isFindTypeOperation and isFindRemoteness)or

       (isFindTypeOperation and isFindAdvertisment)  then
     and1:=' and ';

    if (isFindRecyled and isFindNoRemoved)or
       (isFindRecyled and isFindRegionName)or
       (isFindRecyled and isFindCityRegionName)or
       (isFindRecyled and isFindStreetName)or
       (isFindRecyled and isFindBalconyName)or
       (isFindRecyled and isFindConditionName)or
       (isFindRecyled and isFindSanitaryNodeName)or
       (isFindRecyled and isFindAgentName)or
       (isFindRecyled and isFindDoorName)or
       (isFindRecyled and isFindCountRoomName)or
       (isFindRecyled and isFindTypeRoomName)or
       (isFindRecyled and isFindPlanningName)or
       (isFindRecyled and isFindStationName)or
       (isFindRecyled and isFindTypeHouseName)or
       (isFindRecyled and isFindStoveName)or
       (isFindRecyled and isFindFurnitureName)or
       (isFindRecyled and isFindContact)or
       (isFindRecyled and isFindHouseNumber)or
       (isFindRecyled and isFindApartmentNumber)or
       (isFindRecyled and isFindPhoneName)or
       (isFindRecyled and isFindDocumentName)or
       (isFindRecyled and isFindFloor)or
       (isFindRecyled and isFindCountFloor)or
       (isFindRecyled and isFindGeneralArea)or
       (isFindRecyled and isFindDwellingArea)or
       (isFindRecyled and isFindKitchenArea)or
       (isFindRecyled and isFindPrice)or
       (isFindRecyled and isFindTerm)or
       (isFindRecyled and isFindPayment)or
       (isFindRecyled and isFindNote)or
       (isFindRecyled and isFindDateArrivalsStart)or
       (isFindRecyled and isFindDateArrivalsEnd)or
       (isFindRecyled and isFindSaleStatusName)or
       (isFindRecyled and isFindSelfFormName)or
       (isFindRecyled and isFindTypePremisesName)or
       (isFindRecyled and isFindUnitPriceName)or
       (isFindRecyled and isFindClientInfo)or
       (isFindRecyled and isFindNN)or
       (isFindRecyled and isFindGroundArea)or
       (isFindRecyled and isFindWaterName)or
       (isFindRecyled and isFindHeatName)or
       (isFindRecyled and isFindStyleName)or
       (isFindRecyled and isFindBuilderName)or
       (isFindRecyled and isFindDelivery)or
       (isFindRecyled and isFindAdvertismentNote)or
       (isFindRecyled and isFindTaxes)or

       (isFindRecyled and isFindAreaBuilding)or
       (isFindRecyled and isFindPopulatedPoint)or
       (isFindRecyled and isFindLandFeature)or
       (isFindRecyled and isFindExchangeFormula)or
       (isFindRecyled and isFindLocationStatus)or
       (isFindRecyled and isFindLandMark)or
       (isFindRecyled and isFindCommunications)or
       (isFindRecyled and isFindEmail)or
       (isFindRecyled and isFindLeaseOrSale)or

       (isFindRecyled and isFindContact2)or
       (isFindRecyled and isFindClientInfo2)or
       (isFindRecyled and isFindEmail2)or

       (isFindRecyled and isFindObject)or
       (isFindRecyled and isFindDirection)or
       (isFindRecyled and isFindAccessWays)or
       (isFindRecyled and isFindRemoteness)or

       (isFindRecyled and isFindAdvertisment)then
     and2:=' and ';

    if (isFindNoRemoved and isFindRegionName)or
       (isFindNoRemoved and isFindCityRegionName)or
       (isFindNoRemoved and isFindStreetName)or
       (isFindNoRemoved and isFindBalconyName)or
       (isFindNoRemoved and isFindConditionName)or
       (isFindNoRemoved and isFindSanitaryNodeName)or
       (isFindNoRemoved and isFindAgentName)or
       (isFindNoRemoved and isFindDoorName)or
       (isFindNoRemoved and isFindCountRoomName)or
       (isFindNoRemoved and isFindTypeRoomName)or
       (isFindNoRemoved and isFindPlanningName)or
       (isFindNoRemoved and isFindStationName)or
       (isFindNoRemoved and isFindTypeHouseName)or
       (isFindNoRemoved and isFindStoveName)or
       (isFindNoRemoved and isFindFurnitureName)or
       (isFindNoRemoved and isFindContact)or
       (isFindNoRemoved and isFindHouseNumber)or
       (isFindNoRemoved and isFindApartmentNumber)or
       (isFindNoRemoved and isFindPhoneName)or
       (isFindNoRemoved and isFindDocumentName)or
       (isFindNoRemoved and isFindFloor)or
       (isFindNoRemoved and isFindCountFloor)or
       (isFindNoRemoved and isFindGeneralArea)or
       (isFindNoRemoved and isFindDwellingArea)or
       (isFindNoRemoved and isFindKitchenArea)or
       (isFindNoRemoved and isFindPrice)or
       (isFindNoRemoved and isFindTerm)or
       (isFindNoRemoved and isFindPayment)or
       (isFindNoRemoved and isFindNote)or
       (isFindNoRemoved and isFindDateArrivalsStart)or
       (isFindNoRemoved and isFindDateArrivalsEnd)or
       (isFindNoRemoved and isFindSaleStatusName)or
       (isFindNoRemoved and isFindSelfFormName)or
       (isFindNoRemoved and isFindTypePremisesName)or
       (isFindNoRemoved and isFindUnitPriceName)or
       (isFindNoRemoved and isFindClientInfo)or
       (isFindNoRemoved and isFindNN)or
       (isFindNoRemoved and isFindGroundArea)or
       (isFindNoRemoved and isFindWaterName)or
       (isFindNoRemoved and isFindHeatName)or
       (isFindNoRemoved and isFindStyleName)or
       (isFindNoRemoved and isFindBuilderName)or
       (isFindNoRemoved and isFindDelivery)or
       (isFindNoRemoved and isFindAdvertismentNote)or
       (isFindNoRemoved and isFindTaxes)or

       (isFindNoRemoved and isFindAreaBuilding)or
       (isFindNoRemoved and isFindPopulatedPoint)or
       (isFindNoRemoved and isFindLandFeature)or
       (isFindNoRemoved and isFindExchangeFormula)or
       (isFindNoRemoved and isFindLocationStatus)or
       (isFindNoRemoved and isFindLandMark)or
       (isFindNoRemoved and isFindCommunications)or
       (isFindNoRemoved and isFindEmail)or
       (isFindNoRemoved and isFindLeaseOrSale)or

       (isFindNoRemoved and isFindContact2)or
       (isFindNoRemoved and isFindClientInfo2)or
       (isFindNoRemoved and isFindEmail2)or

       (isFindNoRemoved and isFindObject)or
       (isFindNoRemoved and isFindDirection)or
       (isFindNoRemoved and isFindAccessWays)or
       (isFindNoRemoved and isFindRemoteness)or

       (isFindNoRemoved and isFindAdvertisment)then
     and3:=' and ';

    if (isFindRegionName and isFindStreetName)or
       (isFindRegionName and isFindCityRegionName)or
       (isFindRegionName and isFindBalconyName)or
       (isFindRegionName and isFindConditionName)or
       (isFindRegionName and isFindSanitaryNodeName)or
       (isFindRegionName and isFindAgentName)or
       (isFindRegionName and isFindDoorName)or
       (isFindRegionName and isFindCountRoomName)or
       (isFindRegionName and isFindTypeRoomName)or
       (isFindRegionName and isFindPlanningName)or
       (isFindRegionName and isFindStationName)or
       (isFindRegionName and isFindTypeHouseName)or
       (isFindRegionName and isFindStoveName)or
       (isFindRegionName and isFindFurnitureName)or
       (isFindRegionName and isFindContact)or
       (isFindRegionName and isFindHouseNumber)or
       (isFindRegionName and isFindApartmentNumber)or
       (isFindRegionName and isFindPhoneName)or
       (isFindRegionName and isFindDocumentName)or
       (isFindRegionName and isFindFloor)or
       (isFindRegionName and isFindCountFloor)or
       (isFindRegionName and isFindGeneralArea)or
       (isFindRegionName and isFindDwellingArea)or
       (isFindRegionName and isFindKitchenArea)or
       (isFindRegionName and isFindPrice)or
       (isFindRegionName and isFindTerm)or
       (isFindRegionName and isFindPayment)or
       (isFindRegionName and isFindNote)or
       (isFindRegionName and isFindDateArrivalsStart)or
       (isFindRegionName and isFindDateArrivalsEnd)or
       (isFindRegionName and isFindSaleStatusName)or
       (isFindRegionName and isFindSelfFormName)or
       (isFindRegionName and isFindTypePremisesName)or
       (isFindRegionName and isFindUnitPriceName)or
       (isFindRegionName and isFindClientInfo)or
       (isFindRegionName and isFindNN)or
       (isFindRegionName and isFindGroundArea)or
       (isFindRegionName and isFindWaterName)or
       (isFindRegionName and isFindHeatName)or
       (isFindRegionName and isFindStyleName)or
       (isFindRegionName and isFindBuilderName)or
       (isFindRegionName and isFindDelivery)or
       (isFindRegionName and isFindAdvertismentNote)or
       (isFindRegionName and isFindTaxes)or

       (isFindRegionName and isFindAreaBuilding)or
       (isFindRegionName and isFindPopulatedPoint)or
       (isFindRegionName and isFindLandFeature)or
       (isFindRegionName and isFindExchangeFormula)or
       (isFindRegionName and isFindLocationStatus)or
       (isFindRegionName and isFindLandMark)or
       (isFindRegionName and isFindCommunications)or
       (isFindRegionName and isFindEmail)or
       (isFindRegionName and isFindLeaseOrSale)or

       (isFindRegionName and isFindContact2)or
       (isFindRegionName and isFindClientInfo2)or
       (isFindRegionName and isFindEmail2)or

       (isFindRegionName and isFindObject)or
       (isFindRegionName and isFindDirection)or
       (isFindRegionName and isFindAccessWays)or
       (isFindRegionName and isFindRemoteness)or

       (isFindRegionName and isFindAdvertisment)then
     and4:=' and ';

    if (isFindStreetName and isFindBalconyName)or
       (isFindStreetName and isFindCityRegionName)or
       (isFindStreetName and isFindConditionName)or
       (isFindStreetName and isFindSanitaryNodeName)or
       (isFindStreetName and isFindAgentName)or
       (isFindStreetName and isFindDoorName)or
       (isFindStreetName and isFindCountRoomName)or
       (isFindStreetName and isFindTypeRoomName)or
       (isFindStreetName and isFindPlanningName)or
       (isFindStreetName and isFindStationName)or
       (isFindStreetName and isFindTypeHouseName)or
       (isFindStreetName and isFindStoveName)or
       (isFindStreetName and isFindFurnitureName)or
       (isFindStreetName and isFindContact)or
       (isFindStreetName and isFindHouseNumber)or
       (isFindStreetName and isFindApartmentNumber)or
       (isFindStreetName and isFindPhoneName)or
       (isFindStreetName and isFindDocumentName)or
       (isFindStreetName and isFindFloor)or
       (isFindStreetName and isFindCountFloor)or
       (isFindStreetName and isFindGeneralArea)or
       (isFindStreetName and isFindDwellingArea)or
       (isFindStreetName and isFindKitchenArea)or
       (isFindStreetName and isFindPrice)or
       (isFindStreetName and isFindTerm)or
       (isFindStreetName and isFindPayment)or
       (isFindStreetName and isFindNote)or
       (isFindStreetName and isFindDateArrivalsStart)or
       (isFindStreetName and isFindDateArrivalsEnd)or
       (isFindStreetName and isFindSaleStatusName)or
       (isFindStreetName and isFindSelfFormName)or
       (isFindStreetName and isFindTypePremisesName)or
       (isFindStreetName and isFindUnitPriceName)or
       (isFindStreetName and isFindClientInfo)or
       (isFindStreetName and isFindNN)or
       (isFindStreetName and isFindGroundArea)or
       (isFindStreetName and isFindWaterName)or
       (isFindStreetName and isFindHeatName)or
       (isFindStreetName and isFindStyleName)or
       (isFindStreetName and isFindBuilderName)or
       (isFindStreetName and isFindDelivery)or
       (isFindStreetName and isFindAdvertismentNote)or
       (isFindStreetName and isFindTaxes)or

       (isFindStreetName and isFindAreaBuilding)or
       (isFindStreetName and isFindPopulatedPoint)or
       (isFindStreetName and isFindLandFeature)or
       (isFindStreetName and isFindExchangeFormula)or
       (isFindStreetName and isFindLocationStatus)or
       (isFindStreetName and isFindLandMark)or
       (isFindStreetName and isFindCommunications)or
       (isFindStreetName and isFindEmail)or
       (isFindStreetName and isFindLeaseOrSale)or

       (isFindStreetName and isFindContact2)or
       (isFindStreetName and isFindClientInfo2)or
       (isFindStreetName and isFindEmail2)or

       (isFindStreetName and isFindObject)or
       (isFindStreetName and isFindDirection)or
       (isFindStreetName and isFindAccessWays)or
       (isFindStreetName and isFindRemoteness)or

       (isFindStreetName and isFindAdvertisment)then
     and5:=' and ';

    if (isFindBalconyName and isFindConditionName)or
       (isFindBalconyName and isFindCityRegionName)or
       (isFindBalconyName and isFindSanitaryNodeName)or
       (isFindBalconyName and isFindAgentName)or
       (isFindBalconyName and isFindDoorName)or
       (isFindBalconyName and isFindCountRoomName)or
       (isFindBalconyName and isFindTypeRoomName)or
       (isFindBalconyName and isFindPlanningName)or
       (isFindBalconyName and isFindStationName)or
       (isFindBalconyName and isFindTypeHouseName)or
       (isFindBalconyName and isFindStoveName)or
       (isFindBalconyName and isFindFurnitureName)or
       (isFindBalconyName and isFindContact)or
       (isFindBalconyName and isFindHouseNumber)or
       (isFindBalconyName and isFindApartmentNumber)or
       (isFindBalconyName and isFindPhoneName)or
       (isFindBalconyName and isFindDocumentName)or
       (isFindBalconyName and isFindFloor)or
       (isFindBalconyName and isFindCountFloor)or
       (isFindBalconyName and isFindGeneralArea)or
       (isFindBalconyName and isFindDwellingArea)or
       (isFindBalconyName and isFindKitchenArea)or
       (isFindBalconyName and isFindPrice)or
       (isFindBalconyName and isFindTerm)or
       (isFindBalconyName and isFindPayment)or
       (isFindBalconyName and isFindNote)or
       (isFindBalconyName and isFindDateArrivalsStart)or
       (isFindBalconyName and isFindDateArrivalsEnd)or
       (isFindBalconyName and isFindSaleStatusName)or
       (isFindBalconyName and isFindSelfFormName)or
       (isFindBalconyName and isFindTypePremisesName)or
       (isFindBalconyName and isFindUnitPriceName)or
       (isFindBalconyName and isFindClientInfo)or
       (isFindBalconyName and isFindNN)or
       (isFindBalconyName and isFindGroundArea)or
       (isFindBalconyName and isFindWaterName)or
       (isFindBalconyName and isFindHeatName)or
       (isFindBalconyName and isFindStyleName)or
       (isFindBalconyName and isFindBuilderName)or
       (isFindBalconyName and isFindDelivery)or
       (isFindBalconyName and isFindAdvertismentNote)or
       (isFindBalconyName and isFindTaxes)or

       (isFindBalconyName and isFindAreaBuilding)or
       (isFindBalconyName and isFindPopulatedPoint)or
       (isFindBalconyName and isFindLandFeature)or
       (isFindBalconyName and isFindExchangeFormula)or
       (isFindBalconyName and isFindLocationStatus)or
       (isFindBalconyName and isFindLandMark)or
       (isFindBalconyName and isFindCommunications)or
       (isFindBalconyName and isFindEmail)or
       (isFindBalconyName and isFindLeaseOrSale)or

       (isFindBalconyName and isFindContact2)or
       (isFindBalconyName and isFindClientInfo2)or
       (isFindBalconyName and isFindEmail2)or

       (isFindBalconyName and isFindObject)or
       (isFindBalconyName and isFindDirection)or
       (isFindBalconyName and isFindAccessWays)or
       (isFindBalconyName and isFindRemoteness)or

       (isFindBalconyName and isFindAdvertisment)then


     and6:=' and ';

    if (isFindConditionName and isFindSanitaryNodeName)or
       (isFindConditionName and isFindCityRegionName)or
       (isFindConditionName and isFindAgentName)or
       (isFindConditionName and isFindDoorName)or
       (isFindConditionName and isFindCountRoomName)or
       (isFindConditionName and isFindTypeRoomName)or
       (isFindConditionName and isFindPlanningName)or
       (isFindConditionName and isFindStationName)or
       (isFindConditionName and isFindTypeHouseName)or
       (isFindConditionName and isFindStoveName)or
       (isFindConditionName and isFindFurnitureName)or
       (isFindConditionName and isFindContact)or
       (isFindConditionName and isFindHouseNumber)or
       (isFindConditionName and isFindApartmentNumber)or
       (isFindConditionName and isFindPhoneName)or
       (isFindConditionName and isFindDocumentName)or
       (isFindConditionName and isFindFloor)or
       (isFindConditionName and isFindCountFloor)or
       (isFindConditionName and isFindGeneralArea)or
       (isFindConditionName and isFindDwellingArea)or
       (isFindConditionName and isFindKitchenArea)or
       (isFindConditionName and isFindPrice)or
       (isFindConditionName and isFindTerm)or
       (isFindConditionName and isFindPayment)or
       (isFindConditionName and isFindNote)or
       (isFindConditionName and isFindDateArrivalsStart)or
       (isFindConditionName and isFindDateArrivalsEnd)or
       (isFindConditionName and isFindSaleStatusName)or
       (isFindConditionName and isFindSelfFormName)or
       (isFindConditionName and isFindTypePremisesName)or
       (isFindConditionName and isFindUnitPriceName)or
       (isFindConditionName and isFindClientInfo)or
       (isFindConditionName and isFindNN)or
       (isFindConditionName and isFindGroundArea)or
       (isFindConditionName and isFindWaterName)or
       (isFindConditionName and isFindHeatName)or
       (isFindConditionName and isFindStyleName)or
       (isFindConditionName and isFindBuilderName)or
       (isFindConditionName and isFindDelivery)or
       (isFindConditionName and isFindAdvertismentNote)or
       (isFindConditionName and isFindTaxes)or

       (isFindConditionName and isFindAreaBuilding)or
       (isFindConditionName and isFindPopulatedPoint)or
       (isFindConditionName and isFindLandFeature)or
       (isFindConditionName and isFindExchangeFormula)or
       (isFindConditionName and isFindLocationStatus)or
       (isFindConditionName and isFindLandMark)or
       (isFindConditionName and isFindCommunications)or
       (isFindConditionName and isFindEmail)or
       (isFindConditionName and isFindLeaseOrSale)or

       (isFindConditionName and isFindContact2)or
       (isFindConditionName and isFindClientInfo2)or
       (isFindConditionName and isFindEmail2)or

       (isFindConditionName and isFindObject)or
       (isFindConditionName and isFindDirection)or
       (isFindConditionName and isFindAccessWays)or
       (isFindConditionName and isFindRemoteness)or

       (isFindConditionName and isFindAdvertisment)then
     and7:=' and ';

    if (isFindSanitaryNodeName and isFindAgentName)or
       (isFindSanitaryNodeName and isFindCityRegionName)or
       (isFindSanitaryNodeName and isFindDoorName)or
       (isFindSanitaryNodeName and isFindCountRoomName)or
       (isFindSanitaryNodeName and isFindTypeRoomName)or
       (isFindSanitaryNodeName and isFindPlanningName)or
       (isFindSanitaryNodeName and isFindStationName)or
       (isFindSanitaryNodeName and isFindTypeHouseName)or
       (isFindSanitaryNodeName and isFindStoveName)or
       (isFindSanitaryNodeName and isFindFurnitureName)or
       (isFindSanitaryNodeName and isFindContact)or
       (isFindSanitaryNodeName and isFindHouseNumber)or
       (isFindSanitaryNodeName and isFindApartmentNumber)or
       (isFindSanitaryNodeName and isFindPhoneName)or
       (isFindSanitaryNodeName and isFindDocumentName)or
       (isFindSanitaryNodeName and isFindFloor)or
       (isFindSanitaryNodeName and isFindCountFloor)or
       (isFindSanitaryNodeName and isFindGeneralArea)or
       (isFindSanitaryNodeName and isFindDwellingArea)or
       (isFindSanitaryNodeName and isFindKitchenArea)or
       (isFindSanitaryNodeName and isFindPrice)or
       (isFindSanitaryNodeName and isFindTerm)or
       (isFindSanitaryNodeName and isFindPayment)or
       (isFindSanitaryNodeName and isFindNote)or
       (isFindSanitaryNodeName and isFindDateArrivalsStart)or
       (isFindSanitaryNodeName and isFindDateArrivalsEnd)or
       (isFindSanitaryNodeName and isFindSaleStatusName)or
       (isFindSanitaryNodeName and isFindSelfFormName)or
       (isFindSanitaryNodeName and isFindTypePremisesName)or
       (isFindSanitaryNodeName and isFindUnitPriceName)or
       (isFindSanitaryNodeName and isFindClientInfo)or
       (isFindSanitaryNodeName and isFindNN)or
       (isFindSanitaryNodeName and isFindGroundArea)or
       (isFindSanitaryNodeName and isFindWaterName)or
       (isFindSanitaryNodeName and isFindHeatName)or
       (isFindSanitaryNodeName and isFindStyleName)or
       (isFindSanitaryNodeName and isFindBuilderName)or
       (isFindSanitaryNodeName and isFindDelivery)or
       (isFindSanitaryNodeName and isFindAdvertismentNote)or
       (isFindSanitaryNodeName and isFindTaxes)or

       (isFindSanitaryNodeName and isFindAreaBuilding)or
       (isFindSanitaryNodeName and isFindPopulatedPoint)or
       (isFindSanitaryNodeName and isFindLandFeature)or
       (isFindSanitaryNodeName and isFindExchangeFormula)or
       (isFindSanitaryNodeName and isFindLocationStatus)or
       (isFindSanitaryNodeName and isFindLandMark)or
       (isFindSanitaryNodeName and isFindCommunications)or
       (isFindSanitaryNodeName and isFindEmail)or
       (isFindSanitaryNodeName and isFindLeaseOrSale)or

       (isFindSanitaryNodeName and isFindContact2)or
       (isFindSanitaryNodeName and isFindClientInfo2)or
       (isFindSanitaryNodeName and isFindEmail2)or

       (isFindSanitaryNodeName and isFindObject)or
       (isFindSanitaryNodeName and isFindDirection)or
       (isFindSanitaryNodeName and isFindAccessWays)or
       (isFindSanitaryNodeName and isFindRemoteness)or

       (isFindSanitaryNodeName and isFindAdvertisment)then
     and8:=' and ';

    if (isFindAgentName and isFindDoorName)or
       (isFindAgentName and isFindCityRegionName)or
       (isFindAgentName and isFindCountRoomName)or
       (isFindAgentName and isFindTypeRoomName)or
       (isFindAgentName and isFindPlanningName)or
       (isFindAgentName and isFindStationName)or
       (isFindAgentName and isFindTypeHouseName)or
       (isFindAgentName and isFindStoveName)or
       (isFindAgentName and isFindFurnitureName)or
       (isFindAgentName and isFindContact)or
       (isFindAgentName and isFindHouseNumber)or
       (isFindAgentName and isFindApartmentNumber)or
       (isFindAgentName and isFindPhoneName)or
       (isFindAgentName and isFindDocumentName)or
       (isFindAgentName and isFindFloor)or
       (isFindAgentName and isFindCountFloor)or
       (isFindAgentName and isFindGeneralArea)or
       (isFindAgentName and isFindDwellingArea)or
       (isFindAgentName and isFindKitchenArea)or
       (isFindAgentName and isFindPrice)or
       (isFindAgentName and isFindTerm)or
       (isFindAgentName and isFindPayment)or
       (isFindAgentName and isFindNote)or
       (isFindAgentName and isFindDateArrivalsStart)or
       (isFindAgentName and isFindDateArrivalsEnd)or
       (isFindAgentName and isFindSaleStatusName)or
       (isFindAgentName and isFindSelfFormName)or
       (isFindAgentName and isFindTypePremisesName)or
       (isFindAgentName and isFindUnitPriceName)or
       (isFindAgentName and isFindClientInfo)or
       (isFindAgentName and isFindNN)or
       (isFindAgentName and isFindGroundArea)or
       (isFindAgentName and isFindWaterName)or
       (isFindAgentName and isFindHeatName)or
       (isFindAgentName and isFindStyleName)or
       (isFindAgentName and isFindBuilderName)or
       (isFindAgentName and isFindDelivery)or
       (isFindAgentName and isFindAdvertismentNote)or
       (isFindAgentName and isFindTaxes)or

       (isFindAgentName and isFindAreaBuilding)or
       (isFindAgentName and isFindPopulatedPoint)or
       (isFindAgentName and isFindLandFeature)or
       (isFindAgentName and isFindExchangeFormula)or
       (isFindAgentName and isFindLocationStatus)or
       (isFindAgentName and isFindLandMark)or
       (isFindAgentName and isFindCommunications)or
       (isFindAgentName and isFindEmail)or
       (isFindAgentName and isFindLeaseOrSale)or

       (isFindAgentName and isFindContact2)or
       (isFindAgentName and isFindClientInfo2)or
       (isFindAgentName and isFindEmail2)or

       (isFindAgentName and isFindObject)or
       (isFindAgentName and isFindDirection)or
       (isFindAgentName and isFindAccessWays)or
       (isFindAgentName and isFindRemoteness)or

       (isFindAgentName and isFindAdvertisment)then
     and9:=' and ';

    if (isFindDoorName and isFindCountRoomName)or
       (isFindDoorName and isFindCityRegionName)or
       (isFindDoorName and isFindTypeRoomName)or
       (isFindDoorName and isFindPlanningName)or
       (isFindDoorName and isFindStationName)or
       (isFindDoorName and isFindTypeHouseName)or
       (isFindDoorName and isFindStoveName)or
       (isFindDoorName and isFindFurnitureName)or
       (isFindDoorName and isFindContact)or
       (isFindDoorName and isFindHouseNumber)or
       (isFindDoorName and isFindApartmentNumber)or
       (isFindDoorName and isFindPhoneName)or
       (isFindDoorName and isFindDocumentName)or
       (isFindDoorName and isFindFloor)or
       (isFindDoorName and isFindCountFloor)or
       (isFindDoorName and isFindGeneralArea)or
       (isFindDoorName and isFindDwellingArea)or
       (isFindDoorName and isFindKitchenArea)or
       (isFindDoorName and isFindPrice)or
       (isFindDoorName and isFindTerm)or
       (isFindDoorName and isFindPayment)or
       (isFindDoorName and isFindNote)or
       (isFindDoorName and isFindDateArrivalsStart)or
       (isFindDoorName and isFindDateArrivalsEnd)or
       (isFindDoorName and isFindSaleStatusName)or
       (isFindDoorName and isFindSelfFormName)or
       (isFindDoorName and isFindTypePremisesName)or
       (isFindDoorName and isFindUnitPriceName)or
       (isFindDoorName and isFindClientInfo)or
       (isFindDoorName and isFindNN)or
       (isFindDoorName and isFindGroundArea)or
       (isFindDoorName and isFindWaterName)or
       (isFindDoorName and isFindHeatName)or
       (isFindDoorName and isFindStyleName)or
       (isFindDoorName and isFindBuilderName)or
       (isFindDoorName and isFindDelivery)or
       (isFindDoorName and isFindAdvertismentNote)or
       (isFindDoorName and isFindTaxes)or

       (isFindDoorName and isFindAreaBuilding)or
       (isFindDoorName and isFindPopulatedPoint)or
       (isFindDoorName and isFindLandFeature)or
       (isFindDoorName and isFindExchangeFormula)or
       (isFindDoorName and isFindLocationStatus)or
       (isFindDoorName and isFindLandMark)or
       (isFindDoorName and isFindCommunications)or
       (isFindDoorName and isFindEmail)or
       (isFindDoorName and isFindLeaseOrSale)or

       (isFindDoorName and isFindContact2)or
       (isFindDoorName and isFindClientInfo2)or
       (isFindDoorName and isFindEmail2)or

       (isFindDoorName and isFindObject)or
       (isFindDoorName and isFindDirection)or
       (isFindDoorName and isFindAccessWays)or
       (isFindDoorName and isFindRemoteness)or

       (isFindDoorName and isFindAdvertisment)then
     and10:=' and ';

    if (isFindCountRoomName and isFindTypeRoomName)or
       (isFindCountRoomName and isFindCityRegionName)or
       (isFindCountRoomName and isFindPlanningName)or
       (isFindCountRoomName and isFindStationName)or
       (isFindCountRoomName and isFindTypeHouseName)or
       (isFindCountRoomName and isFindStoveName)or
       (isFindCountRoomName and isFindFurnitureName)or
       (isFindCountRoomName and isFindContact)or
       (isFindCountRoomName and isFindHouseNumber)or
       (isFindCountRoomName and isFindApartmentNumber)or
       (isFindCountRoomName and isFindPhoneName)or
       (isFindCountRoomName and isFindDocumentName)or
       (isFindCountRoomName and isFindFloor)or
       (isFindCountRoomName and isFindCountFloor)or
       (isFindCountRoomName and isFindGeneralArea)or
       (isFindCountRoomName and isFindDwellingArea)or
       (isFindCountRoomName and isFindKitchenArea)or
       (isFindCountRoomName and isFindPrice)or
       (isFindCountRoomName and isFindTerm)or
       (isFindCountRoomName and isFindPayment)or
       (isFindCountRoomName and isFindNote)or
       (isFindCountRoomName and isFindDateArrivalsStart)or
       (isFindCountRoomName and isFindDateArrivalsEnd)or
       (isFindCountRoomName and isFindSaleStatusName)or
       (isFindCountRoomName and isFindSelfFormName)or
       (isFindCountRoomName and isFindTypePremisesName)or
       (isFindCountRoomName and isFindUnitPriceName)or
       (isFindCountRoomName and isFindClientInfo)or
       (isFindCountRoomName and isFindNN)or
       (isFindCountRoomName and isFindGroundArea)or
       (isFindCountRoomName and isFindWaterName)or
       (isFindCountRoomName and isFindHeatName)or
       (isFindCountRoomName and isFindStyleName)or
       (isFindCountRoomName and isFindBuilderName)or
       (isFindCountRoomName and isFindDelivery)or
       (isFindCountRoomName and isFindAdvertismentNote)or
       (isFindCountRoomName and isFindTaxes)or

       (isFindCountRoomName and isFindAreaBuilding)or
       (isFindCountRoomName and isFindPopulatedPoint)or
       (isFindCountRoomName and isFindLandFeature)or
       (isFindCountRoomName and isFindExchangeFormula)or
       (isFindCountRoomName and isFindLocationStatus)or
       (isFindCountRoomName and isFindLandMark)or
       (isFindCountRoomName and isFindCommunications)or
       (isFindCountRoomName and isFindEmail)or
       (isFindCountRoomName and isFindLeaseOrSale)or

       (isFindCountRoomName and isFindContact2)or
       (isFindCountRoomName and isFindClientInfo2)or
       (isFindCountRoomName and isFindEmail2)or

       (isFindCountRoomName and isFindObject)or
       (isFindCountRoomName and isFindDirection)or
       (isFindCountRoomName and isFindAccessWays)or
       (isFindCountRoomName and isFindRemoteness)or

       (isFindCountRoomName and isFindAdvertisment)then
     and11:=' and ';

    if (isFindTypeRoomName and isFindPlanningName)or
       (isFindTypeRoomName and isFindCityRegionName)or
       (isFindTypeRoomName and isFindStationName)or
       (isFindTypeRoomName and isFindTypeHouseName)or
       (isFindTypeRoomName and isFindStoveName)or
       (isFindTypeRoomName and isFindFurnitureName)or
       (isFindTypeRoomName and isFindContact)or
       (isFindTypeRoomName and isFindHouseNumber)or
       (isFindTypeRoomName and isFindApartmentNumber)or
       (isFindTypeRoomName and isFindPhoneName)or
       (isFindTypeRoomName and isFindDocumentName)or
       (isFindTypeRoomName and isFindFloor)or
       (isFindTypeRoomName and isFindCountFloor)or
       (isFindTypeRoomName and isFindGeneralArea)or
       (isFindTypeRoomName and isFindDwellingArea)or
       (isFindTypeRoomName and isFindKitchenArea)or
       (isFindTypeRoomName and isFindPrice)or
       (isFindTypeRoomName and isFindTerm)or
       (isFindTypeRoomName and isFindPayment)or
       (isFindTypeRoomName and isFindNote)or
       (isFindTypeRoomName and isFindDateArrivalsStart)or
       (isFindTypeRoomName and isFindDateArrivalsEnd)or
       (isFindTypeRoomName and isFindSaleStatusName)or
       (isFindTypeRoomName and isFindSelfFormName)or
       (isFindTypeRoomName and isFindTypePremisesName)or
       (isFindTypeRoomName and isFindUnitPriceName)or
       (isFindTypeRoomName and isFindClientInfo)or
       (isFindTypeRoomName and isFindNN)or
       (isFindTypeRoomName and isFindGroundArea)or
       (isFindTypeRoomName and isFindWaterName)or
       (isFindTypeRoomName and isFindHeatName)or
       (isFindTypeRoomName and isFindStyleName)or
       (isFindTypeRoomName and isFindBuilderName)or
       (isFindTypeRoomName and isFindDelivery)or
       (isFindTypeRoomName and isFindAdvertismentNote)or
       (isFindTypeRoomName and isFindTaxes)or

       (isFindTypeRoomName and isFindAreaBuilding)or
       (isFindTypeRoomName and isFindPopulatedPoint)or
       (isFindTypeRoomName and isFindLandFeature)or
       (isFindTypeRoomName and isFindExchangeFormula)or
       (isFindTypeRoomName and isFindLocationStatus)or
       (isFindTypeRoomName and isFindLandMark)or
       (isFindTypeRoomName and isFindCommunications)or
       (isFindTypeRoomName and isFindEmail)or
       (isFindTypeRoomName and isFindLeaseOrSale)or

       (isFindTypeRoomName and isFindContact2)or
       (isFindTypeRoomName and isFindClientInfo2)or
       (isFindTypeRoomName and isFindEmail2)or

       (isFindTypeRoomName and isFindObject)or
       (isFindTypeRoomName and isFindDirection)or
       (isFindTypeRoomName and isFindAccessWays)or
       (isFindTypeRoomName and isFindRemoteness)or

       (isFindTypeRoomName and isFindAdvertisment)then
     and12:=' and ';

    if (isFindPlanningName and isFindStationName)or
       (isFindPlanningName and isFindCityRegionName)or
       (isFindPlanningName and isFindTypeHouseName)or
       (isFindPlanningName and isFindStoveName)or
       (isFindPlanningName and isFindFurnitureName)or
       (isFindPlanningName and isFindContact)or
       (isFindPlanningName and isFindHouseNumber)or
       (isFindPlanningName and isFindApartmentNumber)or
       (isFindPlanningName and isFindPhoneName)or
       (isFindPlanningName and isFindDocumentName)or
       (isFindPlanningName and isFindFloor)or
       (isFindPlanningName and isFindCountFloor)or
       (isFindPlanningName and isFindGeneralArea)or
       (isFindPlanningName and isFindDwellingArea)or
       (isFindPlanningName and isFindKitchenArea)or
       (isFindPlanningName and isFindPrice)or
       (isFindPlanningName and isFindTerm)or
       (isFindPlanningName and isFindPayment)or
       (isFindPlanningName and isFindNote)or
       (isFindPlanningName and isFindDateArrivalsStart)or
       (isFindPlanningName and isFindDateArrivalsEnd)or
       (isFindPlanningName and isFindSaleStatusName)or
       (isFindPlanningName and isFindSelfFormName)or
       (isFindPlanningName and isFindTypePremisesName)or
       (isFindPlanningName and isFindUnitPriceName)or
       (isFindPlanningName and isFindClientInfo)or
       (isFindPlanningName and isFindNN)or
       (isFindPlanningName and isFindGroundArea)or
       (isFindPlanningName and isFindWaterName)or
       (isFindPlanningName and isFindHeatName)or
       (isFindPlanningName and isFindStyleName)or
       (isFindPlanningName and isFindBuilderName)or
       (isFindPlanningName and isFindDelivery)or
       (isFindPlanningName and isFindAdvertismentNote)or
       (isFindPlanningName and isFindTaxes)or

       (isFindPlanningName and isFindAreaBuilding)or
       (isFindPlanningName and isFindPopulatedPoint)or
       (isFindPlanningName and isFindLandFeature)or
       (isFindPlanningName and isFindExchangeFormula)or
       (isFindPlanningName and isFindLocationStatus)or
       (isFindPlanningName and isFindLandMark)or
       (isFindPlanningName and isFindCommunications)or
       (isFindPlanningName and isFindEmail)or
       (isFindPlanningName and isFindLeaseOrSale)or

       (isFindPlanningName and isFindContact2)or
       (isFindPlanningName and isFindClientInfo2)or
       (isFindPlanningName and isFindEmail2)or

       (isFindPlanningName and isFindObject)or
       (isFindPlanningName and isFindDirection)or
       (isFindPlanningName and isFindAccessWays)or
       (isFindPlanningName and isFindRemoteness)or

       (isFindPlanningName and isFindAdvertisment)then

     and13:=' and ';

    if (isFindStationName and isFindTypeHouseName)or
       (isFindStationName and isFindCityRegionName)or
       (isFindStationName and isFindStoveName)or
       (isFindStationName and isFindFurnitureName)or
       (isFindStationName and isFindContact)or
       (isFindStationName and isFindHouseNumber)or
       (isFindStationName and isFindApartmentNumber)or
       (isFindStationName and isFindPhoneName)or
       (isFindStationName and isFindDocumentName)or
       (isFindStationName and isFindFloor)or
       (isFindStationName and isFindCountFloor)or
       (isFindStationName and isFindGeneralArea)or
       (isFindStationName and isFindDwellingArea)or
       (isFindStationName and isFindKitchenArea)or
       (isFindStationName and isFindPrice)or
       (isFindStationName and isFindTerm)or
       (isFindStationName and isFindPayment)or
       (isFindStationName and isFindNote)or
       (isFindStationName and isFindDateArrivalsStart)or
       (isFindStationName and isFindDateArrivalsEnd)or
       (isFindStationName and isFindSaleStatusName)or
       (isFindStationName and isFindSelfFormName)or
       (isFindStationName and isFindTypePremisesName)or
       (isFindStationName and isFindUnitPriceName)or
       (isFindStationName and isFindClientInfo)or
       (isFindStationName and isFindNN)or
       (isFindStationName and isFindGroundArea)or
       (isFindStationName and isFindWaterName)or
       (isFindStationName and isFindHeatName)or
       (isFindStationName and isFindStyleName)or
       (isFindStationName and isFindBuilderName)or
       (isFindStationName and isFindDelivery)or
       (isFindStationName and isFindAdvertismentNote)or
       (isFindStationName and isFindTaxes)or

       (isFindStationName and isFindAreaBuilding)or
       (isFindStationName and isFindPopulatedPoint)or
       (isFindStationName and isFindLandFeature)or
       (isFindStationName and isFindExchangeFormula)or
       (isFindStationName and isFindLocationStatus)or
       (isFindStationName and isFindLandMark)or
       (isFindStationName and isFindCommunications)or
       (isFindStationName and isFindEmail)or
       (isFindStationName and isFindLeaseOrSale)or

       (isFindStationName and isFindContact2)or
       (isFindStationName and isFindClientInfo2)or
       (isFindStationName and isFindEmail2)or

       (isFindStationName and isFindObject)or
       (isFindStationName and isFindDirection)or
       (isFindStationName and isFindAccessWays)or
       (isFindStationName and isFindRemoteness)or

       (isFindStationName and isFindAdvertisment)then
     and14:=' and ';

    if (isFindTypeHouseName and isFindStoveName)or
       (isFindTypeHouseName and isFindCityRegionName)or
       (isFindTypeHouseName and isFindFurnitureName)or
       (isFindTypeHouseName and isFindContact)or
       (isFindTypeHouseName and isFindHouseNumber)or
       (isFindTypeHouseName and isFindApartmentNumber)or
       (isFindTypeHouseName and isFindPhoneName)or
       (isFindTypeHouseName and isFindDocumentName)or
       (isFindTypeHouseName and isFindFloor)or
       (isFindTypeHouseName and isFindCountFloor)or
       (isFindTypeHouseName and isFindGeneralArea)or
       (isFindTypeHouseName and isFindDwellingArea)or
       (isFindTypeHouseName and isFindKitchenArea)or
       (isFindTypeHouseName and isFindPrice)or
       (isFindTypeHouseName and isFindTerm)or
       (isFindTypeHouseName and isFindPayment)or
       (isFindTypeHouseName and isFindNote)or
       (isFindTypeHouseName and isFindDateArrivalsStart)or
       (isFindTypeHouseName and isFindDateArrivalsEnd)or
       (isFindTypeHouseName and isFindSaleStatusName)or
       (isFindTypeHouseName and isFindSelfFormName)or
       (isFindTypeHouseName and isFindTypePremisesName)or
       (isFindTypeHouseName and isFindUnitPriceName)or
       (isFindTypeHouseName and isFindClientInfo)or
       (isFindTypeHouseName and isFindNN)or
       (isFindTypeHouseName and isFindGroundArea)or
       (isFindTypeHouseName and isFindWaterName)or
       (isFindTypeHouseName and isFindHeatName)or
       (isFindTypeHouseName and isFindStyleName)or
       (isFindTypeHouseName and isFindBuilderName)or
       (isFindTypeHouseName and isFindDelivery)or
       (isFindTypeHouseName and isFindAdvertismentNote)or
       (isFindTypeHouseName and isFindTaxes)or

       (isFindTypeHouseName and isFindAreaBuilding)or
       (isFindTypeHouseName and isFindPopulatedPoint)or
       (isFindTypeHouseName and isFindLandFeature)or
       (isFindTypeHouseName and isFindExchangeFormula)or
       (isFindTypeHouseName and isFindLocationStatus)or
       (isFindTypeHouseName and isFindLandMark)or
       (isFindTypeHouseName and isFindCommunications)or
       (isFindTypeHouseName and isFindEmail)or
       (isFindTypeHouseName and isFindLeaseOrSale)or

       (isFindTypeHouseName and isFindContact2)or
       (isFindTypeHouseName and isFindClientInfo2)or
       (isFindTypeHouseName and isFindEmail2)or

       (isFindTypeHouseName and isFindObject)or
       (isFindTypeHouseName and isFindDirection)or
       (isFindTypeHouseName and isFindAccessWays)or
       (isFindTypeHouseName and isFindRemoteness)or

       (isFindTypeHouseName and isFindAdvertisment)then
     and15:=' and ';

    if (isFindStoveName and isFindFurnitureName)or
       (isFindStoveName and isFindCityRegionName)or
       (isFindStoveName and isFindContact)or
       (isFindStoveName and isFindHouseNumber)or
       (isFindStoveName and isFindApartmentNumber)or
       (isFindStoveName and isFindPhoneName)or
       (isFindStoveName and isFindDocumentName)or
       (isFindStoveName and isFindFloor)or
       (isFindStoveName and isFindCountFloor)or
       (isFindStoveName and isFindGeneralArea)or
       (isFindStoveName and isFindDwellingArea)or
       (isFindStoveName and isFindKitchenArea)or
       (isFindStoveName and isFindPrice)or
       (isFindStoveName and isFindTerm)or
       (isFindStoveName and isFindPayment)or
       (isFindStoveName and isFindNote)or
       (isFindStoveName and isFindDateArrivalsStart)or
       (isFindStoveName and isFindDateArrivalsEnd)or
       (isFindStoveName and isFindSaleStatusName)or
       (isFindStoveName and isFindSelfFormName)or
       (isFindStoveName and isFindTypePremisesName)or
       (isFindStoveName and isFindUnitPriceName)or
       (isFindStoveName and isFindClientInfo)or
       (isFindStoveName and isFindNN)or
       (isFindStoveName and isFindGroundArea)or
       (isFindStoveName and isFindWaterName)or
       (isFindStoveName and isFindHeatName)or
       (isFindStoveName and isFindStyleName)or
       (isFindStoveName and isFindBuilderName)or
       (isFindStoveName and isFindDelivery)or
       (isFindStoveName and isFindAdvertismentNote)or
       (isFindStoveName and isFindTaxes)or

       (isFindStoveName and isFindAreaBuilding)or
       (isFindStoveName and isFindPopulatedPoint)or
       (isFindStoveName and isFindLandFeature)or
       (isFindStoveName and isFindExchangeFormula)or
       (isFindStoveName and isFindLocationStatus)or
       (isFindStoveName and isFindLandMark)or
       (isFindStoveName and isFindCommunications)or
       (isFindStoveName and isFindEmail)or
       (isFindStoveName and isFindLeaseOrSale)or

       (isFindStoveName and isFindContact2)or
       (isFindStoveName and isFindClientInfo2)or
       (isFindStoveName and isFindEmail2)or

       (isFindStoveName and isFindObject)or
       (isFindStoveName and isFindDirection)or
       (isFindStoveName and isFindAccessWays)or
       (isFindStoveName and isFindRemoteness)or

       (isFindStoveName and isFindAdvertisment)then
     and16:=' and ';

    if (isFindFurnitureName and isFindContact)or
       (isFindFurnitureName and isFindCityRegionName)or
       (isFindFurnitureName and isFindHouseNumber)or
       (isFindFurnitureName and isFindApartmentNumber)or
       (isFindFurnitureName and isFindPhoneName)or
       (isFindFurnitureName and isFindDocumentName)or
       (isFindFurnitureName and isFindFloor)or
       (isFindFurnitureName and isFindCountFloor)or
       (isFindFurnitureName and isFindGeneralArea)or
       (isFindFurnitureName and isFindDwellingArea)or
       (isFindFurnitureName and isFindKitchenArea)or
       (isFindFurnitureName and isFindPrice)or
       (isFindFurnitureName and isFindTerm)or
       (isFindFurnitureName and isFindPayment)or
       (isFindFurnitureName and isFindNote)or
       (isFindFurnitureName and isFindDateArrivalsStart)or
       (isFindFurnitureName and isFindDateArrivalsEnd)or
       (isFindFurnitureName and isFindSaleStatusName)or
       (isFindFurnitureName and isFindSelfFormName)or
       (isFindFurnitureName and isFindTypePremisesName)or
       (isFindFurnitureName and isFindUnitPriceName)or
       (isFindFurnitureName and isFindClientInfo)or
       (isFindFurnitureName and isFindNN)or
       (isFindFurnitureName and isFindGroundArea)or
       (isFindFurnitureName and isFindWaterName)or
       (isFindFurnitureName and isFindHeatName)or
       (isFindFurnitureName and isFindStyleName)or
       (isFindFurnitureName and isFindBuilderName)or
       (isFindFurnitureName and isFindDelivery)or
       (isFindFurnitureName and isFindAdvertismentNote)or
       (isFindFurnitureName and isFindTaxes)or

       (isFindFurnitureName and isFindAreaBuilding)or
       (isFindFurnitureName and isFindPopulatedPoint)or
       (isFindFurnitureName and isFindLandFeature)or
       (isFindFurnitureName and isFindExchangeFormula)or
       (isFindFurnitureName and isFindLocationStatus)or
       (isFindFurnitureName and isFindLandMark)or
       (isFindFurnitureName and isFindCommunications)or
       (isFindFurnitureName and isFindEmail)or
       (isFindFurnitureName and isFindLeaseOrSale)or

       (isFindFurnitureName and isFindContact2)or
       (isFindFurnitureName and isFindClientInfo2)or
       (isFindFurnitureName and isFindEmail2)or

       (isFindFurnitureName and isFindObject)or
       (isFindFurnitureName and isFindDirection)or
       (isFindFurnitureName and isFindAccessWays)or
       (isFindFurnitureName and isFindRemoteness)or

       (isFindFurnitureName and isFindAdvertisment)then
     and17:=' and ';

    if (isFindContact and isFindHouseNumber)or
       (isFindContact and isFindCityRegionName)or
       (isFindContact and isFindApartmentNumber)or
       (isFindContact and isFindPhoneName)or
       (isFindContact and isFindDocumentName)or
       (isFindContact and isFindFloor)or
       (isFindContact and isFindCountFloor)or
       (isFindContact and isFindGeneralArea)or
       (isFindContact and isFindDwellingArea)or
       (isFindContact and isFindKitchenArea)or
       (isFindContact and isFindPrice)or
       (isFindContact and isFindTerm)or
       (isFindContact and isFindPayment)or
       (isFindContact and isFindNote)or
       (isFindContact and isFindDateArrivalsStart)or
       (isFindContact and isFindDateArrivalsEnd)or
       (isFindContact and isFindSaleStatusName)or
       (isFindContact and isFindSelfFormName)or
       (isFindContact and isFindTypePremisesName)or
       (isFindContact and isFindUnitPriceName)or
       (isFindContact and isFindClientInfo)or
       (isFindContact and isFindNN)or
       (isFindContact and isFindGroundArea)or
       (isFindContact and isFindWaterName)or
       (isFindContact and isFindHeatName)or
       (isFindContact and isFindStyleName)or
       (isFindContact and isFindBuilderName)or
       (isFindContact and isFindDelivery)or
       (isFindContact and isFindAdvertismentNote)or
       (isFindContact and isFindTaxes)or

       (isFindContact and isFindAreaBuilding)or
       (isFindContact and isFindPopulatedPoint)or
       (isFindContact and isFindLandFeature)or
       (isFindContact and isFindExchangeFormula)or
       (isFindContact and isFindLocationStatus)or
       (isFindContact and isFindLandMark)or
       (isFindContact and isFindCommunications)or
       (isFindContact and isFindEmail)or
       (isFindContact and isFindLeaseOrSale)or

       (isFindContact and isFindContact2)or
       (isFindContact and isFindClientInfo2)or
       (isFindContact and isFindEmail2)or

       (isFindContact and isFindObject)or
       (isFindContact and isFindDirection)or
       (isFindContact and isFindAccessWays)or
       (isFindContact and isFindRemoteness)or

       (isFindContact and isFindAdvertisment)then
     and18:=' and ';

    if (isFindHouseNumber and isFindApartmentNumber)or
       (isFindHouseNumber and isFindCityRegionName)or
       (isFindHouseNumber and isFindPhoneName)or
       (isFindHouseNumber and isFindDocumentName)or
       (isFindHouseNumber and isFindFloor)or
       (isFindHouseNumber and isFindCountFloor)or
       (isFindHouseNumber and isFindGeneralArea)or
       (isFindHouseNumber and isFindDwellingArea)or
       (isFindHouseNumber and isFindKitchenArea)or
       (isFindHouseNumber and isFindPrice)or
       (isFindHouseNumber and isFindTerm)or
       (isFindHouseNumber and isFindPayment)or
       (isFindHouseNumber and isFindNote)or
       (isFindHouseNumber and isFindDateArrivalsStart)or
       (isFindHouseNumber and isFindDateArrivalsEnd)or
       (isFindHouseNumber and isFindSaleStatusName)or
       (isFindHouseNumber and isFindSelfFormName)or
       (isFindHouseNumber and isFindTypePremisesName)or
       (isFindHouseNumber and isFindUnitPriceName)or
       (isFindHouseNumber and isFindClientInfo)or
       (isFindHouseNumber and isFindNN)or
       (isFindHouseNumber and isFindGroundArea)or
       (isFindHouseNumber and isFindWaterName)or
       (isFindHouseNumber and isFindHeatName)or
       (isFindHouseNumber and isFindStyleName)or
       (isFindHouseNumber and isFindBuilderName)or
       (isFindHouseNumber and isFindDelivery)or
       (isFindHouseNumber and isFindAdvertismentNote)or
       (isFindHouseNumber and isFindTaxes)or

       (isFindHouseNumber and isFindAreaBuilding)or
       (isFindHouseNumber and isFindPopulatedPoint)or
       (isFindHouseNumber and isFindLandFeature)or
       (isFindHouseNumber and isFindExchangeFormula)or
       (isFindHouseNumber and isFindLocationStatus)or
       (isFindHouseNumber and isFindLandMark)or
       (isFindHouseNumber and isFindCommunications)or
       (isFindHouseNumber and isFindEmail)or
       (isFindHouseNumber and isFindLeaseOrSale)or

       (isFindHouseNumber and isFindContact2)or
       (isFindHouseNumber and isFindClientInfo2)or
       (isFindHouseNumber and isFindEmail2)or

       (isFindHouseNumber and isFindObject)or
       (isFindHouseNumber and isFindDirection)or
       (isFindHouseNumber and isFindAccessWays)or
       (isFindHouseNumber and isFindRemoteness)or

       (isFindHouseNumber and isFindAdvertisment)then
     and19:=' and ';

    if (isFindApartmentNumber and isFindPhoneName)or
       (isFindApartmentNumber and isFindCityRegionName)or
       (isFindApartmentNumber and isFindDocumentName)or
       (isFindApartmentNumber and isFindFloor)or
       (isFindApartmentNumber and isFindCountFloor)or
       (isFindApartmentNumber and isFindGeneralArea)or
       (isFindApartmentNumber and isFindDwellingArea)or
       (isFindApartmentNumber and isFindKitchenArea)or
       (isFindApartmentNumber and isFindPrice)or
       (isFindApartmentNumber and isFindTerm)or
       (isFindApartmentNumber and isFindPayment)or
       (isFindApartmentNumber and isFindNote)or
       (isFindApartmentNumber and isFindDateArrivalsStart)or
       (isFindApartmentNumber and isFindDateArrivalsEnd)or
       (isFindApartmentNumber and isFindSaleStatusName)or
       (isFindApartmentNumber and isFindSelfFormName)or
       (isFindApartmentNumber and isFindTypePremisesName)or
       (isFindApartmentNumber and isFindUnitPriceName)or
       (isFindApartmentNumber and isFindClientInfo)or
       (isFindApartmentNumber and isFindNN)or
       (isFindApartmentNumber and isFindGroundArea)or
       (isFindApartmentNumber and isFindWaterName)or
       (isFindApartmentNumber and isFindHeatName)or
       (isFindApartmentNumber and isFindStyleName)or
       (isFindApartmentNumber and isFindBuilderName)or
       (isFindApartmentNumber and isFindDelivery)or
       (isFindApartmentNumber and isFindAdvertismentNote)or
       (isFindApartmentNumber and isFindTaxes)or

       (isFindApartmentNumber and isFindAreaBuilding)or
       (isFindApartmentNumber and isFindPopulatedPoint)or
       (isFindApartmentNumber and isFindLandFeature)or
       (isFindApartmentNumber and isFindExchangeFormula)or
       (isFindApartmentNumber and isFindLocationStatus)or
       (isFindApartmentNumber and isFindLandMark)or
       (isFindApartmentNumber and isFindCommunications)or
       (isFindApartmentNumber and isFindEmail)or
       (isFindApartmentNumber and isFindLeaseOrSale)or

       (isFindApartmentNumber and isFindContact2)or
       (isFindApartmentNumber and isFindClientInfo2)or
       (isFindApartmentNumber and isFindEmail2)or

       (isFindApartmentNumber and isFindObject)or
       (isFindApartmentNumber and isFindDirection)or
       (isFindApartmentNumber and isFindAccessWays)or
       (isFindApartmentNumber and isFindRemoteness)or

       (isFindApartmentNumber and isFindAdvertisment)then
     and20:=' and ';

    if (isFindPhoneName and isFindDocumentName)or
       (isFindPhoneName and isFindCityRegionName)or
       (isFindPhoneName and isFindFloor)or
       (isFindPhoneName and isFindCountFloor)or
       (isFindPhoneName and isFindGeneralArea)or
       (isFindPhoneName and isFindDwellingArea)or
       (isFindPhoneName and isFindKitchenArea)or
       (isFindPhoneName and isFindPrice)or
       (isFindPhoneName and isFindTerm)or
       (isFindPhoneName and isFindPayment)or
       (isFindPhoneName and isFindNote)or
       (isFindPhoneName and isFindDateArrivalsStart)or
       (isFindPhoneName and isFindDateArrivalsEnd)or
       (isFindPhoneName and isFindSaleStatusName)or
       (isFindPhoneName and isFindSelfFormName)or
       (isFindPhoneName and isFindTypePremisesName)or
       (isFindPhoneName and isFindUnitPriceName)or
       (isFindPhoneName and isFindClientInfo)or
       (isFindPhoneName and isFindNN)or
       (isFindPhoneName and isFindGroundArea)or
       (isFindPhoneName and isFindWaterName)or
       (isFindPhoneName and isFindHeatName)or
       (isFindPhoneName and isFindStyleName)or
       (isFindPhoneName and isFindBuilderName)or
       (isFindPhoneName and isFindDelivery)or
       (isFindPhoneName and isFindAdvertismentNote)or
       (isFindPhoneName and isFindTaxes)or

       (isFindPhoneName and isFindAreaBuilding)or
       (isFindPhoneName and isFindPopulatedPoint)or
       (isFindPhoneName and isFindLandFeature)or
       (isFindPhoneName and isFindExchangeFormula)or
       (isFindPhoneName and isFindLocationStatus)or
       (isFindPhoneName and isFindLandMark)or
       (isFindPhoneName and isFindCommunications)or
       (isFindPhoneName and isFindEmail)or
       (isFindPhoneName and isFindLeaseOrSale)or

       (isFindPhoneName and isFindContact2)or
       (isFindPhoneName and isFindClientInfo2)or
       (isFindPhoneName and isFindEmail2)or

       (isFindPhoneName and isFindObject)or
       (isFindPhoneName and isFindDirection)or
       (isFindPhoneName and isFindAccessWays)or
       (isFindPhoneName and isFindRemoteness)or

       (isFindPhoneName and isFindAdvertisment)then
     and21:=' and ';

    if (isFindDocumentName and isFindFloor)or
       (isFindDocumentName and isFindCityRegionName)or
       (isFindDocumentName and isFindCountFloor)or
       (isFindDocumentName and isFindGeneralArea)or
       (isFindDocumentName and isFindDwellingArea)or
       (isFindDocumentName and isFindKitchenArea)or
       (isFindDocumentName and isFindPrice)or
       (isFindDocumentName and isFindTerm)or
       (isFindDocumentName and isFindPayment)or
       (isFindDocumentName and isFindNote)or
       (isFindDocumentName and isFindDateArrivalsStart)or
       (isFindDocumentName and isFindDateArrivalsEnd)or
       (isFindDocumentName and isFindSaleStatusName)or
       (isFindDocumentName and isFindSelfFormName)or
       (isFindDocumentName and isFindTypePremisesName)or
       (isFindDocumentName and isFindUnitPriceName)or
       (isFindDocumentName and isFindClientInfo)or
       (isFindDocumentName and isFindNN)or
       (isFindDocumentName and isFindGroundArea)or
       (isFindDocumentName and isFindWaterName)or
       (isFindDocumentName and isFindHeatName)or
       (isFindDocumentName and isFindStyleName)or
       (isFindDocumentName and isFindBuilderName)or
       (isFindDocumentName and isFindDelivery)or
       (isFindDocumentName and isFindAdvertismentNote)or
       (isFindDocumentName and isFindTaxes)or

       (isFindDocumentName and isFindAreaBuilding)or
       (isFindDocumentName and isFindPopulatedPoint)or
       (isFindDocumentName and isFindLandFeature)or
       (isFindDocumentName and isFindExchangeFormula)or
       (isFindDocumentName and isFindLocationStatus)or
       (isFindDocumentName and isFindLandMark)or
       (isFindDocumentName and isFindCommunications)or
       (isFindDocumentName and isFindEmail)or
       (isFindDocumentName and isFindLeaseOrSale)or

       (isFindDocumentName and isFindContact2)or
       (isFindDocumentName and isFindClientInfo2)or
       (isFindDocumentName and isFindEmail2)or

       (isFindDocumentName and isFindObject)or
       (isFindDocumentName and isFindDirection)or
       (isFindDocumentName and isFindAccessWays)or
       (isFindDocumentName and isFindRemoteness)or

       (isFindDocumentName and isFindAdvertisment)then
     and22:=' and ';

    if (isFindFloor and isFindCountFloor)or
       (isFindFloor and isFindCityRegionName)or
       (isFindFloor and isFindGeneralArea)or
       (isFindFloor and isFindDwellingArea)or
       (isFindFloor and isFindKitchenArea)or
       (isFindFloor and isFindPrice)or
       (isFindFloor and isFindTerm)or
       (isFindFloor and isFindPayment)or
       (isFindFloor and isFindNote)or
       (isFindFloor and isFindDateArrivalsStart)or
       (isFindFloor and isFindDateArrivalsEnd)or
       (isFindFloor and isFindSaleStatusName)or
       (isFindFloor and isFindSelfFormName)or
       (isFindFloor and isFindTypePremisesName)or
       (isFindFloor and isFindUnitPriceName)or
       (isFindFloor and isFindClientInfo)or
       (isFindFloor and isFindNN)or
       (isFindFloor and isFindGroundArea)or
       (isFindFloor and isFindWaterName)or
       (isFindFloor and isFindHeatName)or
       (isFindFloor and isFindStyleName)or
       (isFindFloor and isFindBuilderName)or
       (isFindFloor and isFindDelivery)or
       (isFindFloor and isFindAdvertismentNote)or
       (isFindFloor and isFindTaxes)or

       (isFindFloor and isFindAreaBuilding)or
       (isFindFloor and isFindPopulatedPoint)or
       (isFindFloor and isFindLandFeature)or
       (isFindFloor and isFindExchangeFormula)or
       (isFindFloor and isFindLocationStatus)or
       (isFindFloor and isFindLandMark)or
       (isFindFloor and isFindCommunications)or
       (isFindFloor and isFindEmail)or
       (isFindFloor and isFindLeaseOrSale)or

       (isFindFloor and isFindContact2)or
       (isFindFloor and isFindClientInfo2)or
       (isFindFloor and isFindEmail2)or

       (isFindFloor and isFindObject)or
       (isFindFloor and isFindDirection)or
       (isFindFloor and isFindAccessWays)or
       (isFindFloor and isFindRemoteness)or

       (isFindFloor and isFindAdvertisment)then
     and23:=' and ';

    if (isFindCountFloor and isFindGeneralArea)or
       (isFindCountFloor and isFindCityRegionName)or
       (isFindCountFloor and isFindDwellingArea)or
       (isFindCountFloor and isFindKitchenArea)or
       (isFindCountFloor and isFindPrice)or
       (isFindCountFloor and isFindTerm)or
       (isFindCountFloor and isFindPayment)or
       (isFindCountFloor and isFindNote)or
       (isFindCountFloor and isFindDateArrivalsStart)or
       (isFindCountFloor and isFindDateArrivalsEnd)or
       (isFindCountFloor and isFindSaleStatusName)or
       (isFindCountFloor and isFindSelfFormName)or
       (isFindCountFloor and isFindTypePremisesName)or
       (isFindCountFloor and isFindUnitPriceName)or
       (isFindCountFloor and isFindClientInfo)or
       (isFindCountFloor and isFindNN)or
       (isFindCountFloor and isFindGroundArea)or
       (isFindCountFloor and isFindWaterName)or
       (isFindCountFloor and isFindHeatName)or
       (isFindCountFloor and isFindStyleName)or
       (isFindCountFloor and isFindBuilderName)or
       (isFindCountFloor and isFindDelivery)or
       (isFindCountFloor and isFindAdvertismentNote)or
       (isFindCountFloor and isFindTaxes)or

       (isFindCountFloor and isFindAreaBuilding)or
       (isFindCountFloor and isFindPopulatedPoint)or
       (isFindCountFloor and isFindLandFeature)or
       (isFindCountFloor and isFindExchangeFormula)or
       (isFindCountFloor and isFindLocationStatus)or
       (isFindCountFloor and isFindLandMark)or
       (isFindCountFloor and isFindCommunications)or
       (isFindCountFloor and isFindEmail)or
       (isFindCountFloor and isFindLeaseOrSale)or

       (isFindCountFloor and isFindContact2)or
       (isFindCountFloor and isFindClientInfo2)or
       (isFindCountFloor and isFindEmail2)or

       (isFindCountFloor and isFindObject)or
       (isFindCountFloor and isFindDirection)or
       (isFindCountFloor and isFindAccessWays)or
       (isFindCountFloor and isFindRemoteness)or

       (isFindCountFloor and isFindAdvertisment)then
     and24:=' and ';

    if (isFindGeneralArea and isFindDwellingArea)or
       (isFindGeneralArea and isFindCityRegionName)or
       (isFindGeneralArea and isFindKitchenArea)or
       (isFindGeneralArea and isFindPrice)or
       (isFindGeneralArea and isFindTerm)or
       (isFindGeneralArea and isFindPayment)or
       (isFindGeneralArea and isFindNote)or
       (isFindGeneralArea and isFindDateArrivalsStart)or
       (isFindGeneralArea and isFindDateArrivalsEnd)or
       (isFindGeneralArea and isFindSaleStatusName)or
       (isFindGeneralArea and isFindSelfFormName)or
       (isFindGeneralArea and isFindTypePremisesName)or
       (isFindGeneralArea and isFindUnitPriceName)or
       (isFindGeneralArea and isFindClientInfo)or
       (isFindGeneralArea and isFindNN)or
       (isFindGeneralArea and isFindGroundArea)or
       (isFindGeneralArea and isFindWaterName)or
       (isFindGeneralArea and isFindHeatName)or
       (isFindGeneralArea and isFindStyleName)or
       (isFindGeneralArea and isFindBuilderName)or
       (isFindGeneralArea and isFindDelivery)or
       (isFindGeneralArea and isFindAdvertismentNote)or
       (isFindGeneralArea and isFindTaxes)or

       (isFindGeneralArea and isFindAreaBuilding)or
       (isFindGeneralArea and isFindPopulatedPoint)or
       (isFindGeneralArea and isFindLandFeature)or
       (isFindGeneralArea and isFindExchangeFormula)or
       (isFindGeneralArea and isFindLocationStatus)or
       (isFindGeneralArea and isFindLandMark)or
       (isFindGeneralArea and isFindCommunications)or
       (isFindGeneralArea and isFindEmail)or
       (isFindGeneralArea and isFindLeaseOrSale)or

       (isFindGeneralArea and isFindContact2)or
       (isFindGeneralArea and isFindClientInfo2)or
       (isFindGeneralArea and isFindEmail2)or

       (isFindGeneralArea and isFindObject)or
       (isFindGeneralArea and isFindDirection)or
       (isFindGeneralArea and isFindAccessWays)or
       (isFindGeneralArea and isFindRemoteness)or

       (isFindGeneralArea and isFindAdvertisment)then
     and25:=' and ';

    if (isFindDwellingArea and isFindKitchenArea)or
       (isFindDwellingArea and isFindCityRegionName)or
       (isFindDwellingArea and isFindPrice)or
       (isFindDwellingArea and isFindTerm)or
       (isFindDwellingArea and isFindPayment)or
       (isFindDwellingArea and isFindNote)or
       (isFindDwellingArea and isFindDateArrivalsStart)or
       (isFindDwellingArea and isFindDateArrivalsEnd)or
       (isFindDwellingArea and isFindSaleStatusName)or
       (isFindDwellingArea and isFindSelfFormName)or
       (isFindDwellingArea and isFindTypePremisesName)or
       (isFindDwellingArea and isFindUnitPriceName)or
       (isFindDwellingArea and isFindClientInfo)or
       (isFindDwellingArea and isFindNN)or
       (isFindDwellingArea and isFindGroundArea)or
       (isFindDwellingArea and isFindWaterName)or
       (isFindDwellingArea and isFindHeatName)or
       (isFindDwellingArea and isFindStyleName)or
       (isFindDwellingArea and isFindBuilderName)or
       (isFindDwellingArea and isFindDelivery)or
       (isFindDwellingArea and isFindAdvertismentNote)or
       (isFindDwellingArea and isFindTaxes)or

       (isFindDwellingArea and isFindAreaBuilding)or
       (isFindDwellingArea and isFindPopulatedPoint)or
       (isFindDwellingArea and isFindLandFeature)or
       (isFindDwellingArea and isFindExchangeFormula)or
       (isFindDwellingArea and isFindLocationStatus)or
       (isFindDwellingArea and isFindLandMark)or
       (isFindDwellingArea and isFindCommunications)or
       (isFindDwellingArea and isFindEmail)or
       (isFindDwellingArea and isFindLeaseOrSale)or

       (isFindDwellingArea and isFindContact2)or
       (isFindDwellingArea and isFindClientInfo2)or
       (isFindDwellingArea and isFindEmail2)or

       (isFindDwellingArea and isFindObject)or
       (isFindDwellingArea and isFindDirection)or
       (isFindDwellingArea and isFindAccessWays)or
       (isFindDwellingArea and isFindRemoteness)or

       (isFindDwellingArea and isFindAdvertisment)then
     and26:=' and ';

    if (isFindKitchenArea and isFindPrice)or
       (isFindKitchenArea and isFindCityRegionName)or
       (isFindKitchenArea and isFindTerm)or
       (isFindKitchenArea and isFindPayment)or
       (isFindKitchenArea and isFindNote)or
       (isFindKitchenArea and isFindDateArrivalsStart)or
       (isFindKitchenArea and isFindDateArrivalsEnd)or
       (isFindKitchenArea and isFindSaleStatusName)or
       (isFindKitchenArea and isFindSelfFormName)or
       (isFindKitchenArea and isFindTypePremisesName)or
       (isFindKitchenArea and isFindUnitPriceName)or
       (isFindKitchenArea and isFindClientInfo)or
       (isFindKitchenArea and isFindNN)or
       (isFindKitchenArea and isFindGroundArea)or
       (isFindKitchenArea and isFindWaterName)or
       (isFindKitchenArea and isFindHeatName)or
       (isFindKitchenArea and isFindStyleName)or
       (isFindKitchenArea and isFindBuilderName)or
       (isFindKitchenArea and isFindDelivery)or
       (isFindKitchenArea and isFindAdvertismentNote)or
       (isFindKitchenArea and isFindTaxes)or

       (isFindKitchenArea and isFindAreaBuilding)or
       (isFindKitchenArea and isFindPopulatedPoint)or
       (isFindKitchenArea and isFindLandFeature)or
       (isFindKitchenArea and isFindExchangeFormula)or
       (isFindKitchenArea and isFindLocationStatus)or
       (isFindKitchenArea and isFindLandMark)or
       (isFindKitchenArea and isFindCommunications)or
       (isFindKitchenArea and isFindEmail)or
       (isFindKitchenArea and isFindLeaseOrSale)or

       (isFindKitchenArea and isFindContact2)or
       (isFindKitchenArea and isFindClientInfo2)or
       (isFindKitchenArea and isFindEmail2)or

       (isFindKitchenArea and isFindObject)or
       (isFindKitchenArea and isFindDirection)or
       (isFindKitchenArea and isFindAccessWays)or
       (isFindKitchenArea and isFindRemoteness)or

       (isFindKitchenArea and isFindAdvertisment)then
     and27:=' and ';

    if (isFindPrice and isFindTerm)or
       (isFindPrice and isFindCityRegionName)or
       (isFindPrice and isFindPayment)or
       (isFindPrice and isFindNote)or
       (isFindPrice and isFindDateArrivalsStart)or
       (isFindPrice and isFindDateArrivalsEnd)or
       (isFindPrice and isFindSaleStatusName)or
       (isFindPrice and isFindSelfFormName)or
       (isFindPrice and isFindTypePremisesName)or
       (isFindPrice and isFindUnitPriceName)or
       (isFindPrice and isFindClientInfo)or
       (isFindPrice and isFindNN)or
       (isFindPrice and isFindGroundArea)or
       (isFindPrice and isFindWaterName)or
       (isFindPrice and isFindHeatName)or
       (isFindPrice and isFindStyleName)or
       (isFindPrice and isFindBuilderName)or
       (isFindPrice and isFindDelivery)or
       (isFindPrice and isFindAdvertismentNote)or
       (isFindPrice and isFindTaxes)or

       (isFindPrice and isFindAreaBuilding)or
       (isFindPrice and isFindPopulatedPoint)or
       (isFindPrice and isFindLandFeature)or
       (isFindPrice and isFindExchangeFormula)or
       (isFindPrice and isFindLocationStatus)or
       (isFindPrice and isFindLandMark)or
       (isFindPrice and isFindCommunications)or
       (isFindPrice and isFindEmail)or
       (isFindPrice and isFindLeaseOrSale)or

       (isFindPrice and isFindContact2)or
       (isFindPrice and isFindClientInfo2)or
       (isFindPrice and isFindEmail2)or

       (isFindPrice and isFindObject)or
       (isFindPrice and isFindDirection)or
       (isFindPrice and isFindAccessWays)or
       (isFindPrice and isFindRemoteness)or

       (isFindPrice and isFindAdvertisment)then
     and28:=' and ';

    if (isFindTerm and isFindPayment)or
       (isFindTerm and isFindCityRegionName)or
       (isFindTerm and isFindNote)or
       (isFindTerm and isFindDateArrivalsStart)or
       (isFindTerm and isFindDateArrivalsEnd)or
       (isFindTerm and isFindSaleStatusName)or
       (isFindTerm and isFindSelfFormName)or
       (isFindTerm and isFindTypePremisesName)or
       (isFindTerm and isFindUnitPriceName)or
       (isFindTerm and isFindClientInfo)or
       (isFindTerm and isFindNN)or
       (isFindTerm and isFindGroundArea)or
       (isFindTerm and isFindWaterName)or
       (isFindTerm and isFindHeatName)or
       (isFindTerm and isFindStyleName)or
       (isFindTerm and isFindBuilderName)or
       (isFindTerm and isFindDelivery)or
       (isFindTerm and isFindAdvertismentNote)or
       (isFindTerm and isFindTaxes)or

       (isFindTerm and isFindAreaBuilding)or
       (isFindTerm and isFindPopulatedPoint)or
       (isFindTerm and isFindLandFeature)or
       (isFindTerm and isFindExchangeFormula)or
       (isFindTerm and isFindLocationStatus)or
       (isFindTerm and isFindLandMark)or
       (isFindTerm and isFindCommunications)or
       (isFindTerm and isFindEmail)or
       (isFindTerm and isFindLeaseOrSale)or

       (isFindTerm and isFindContact2)or
       (isFindTerm and isFindClientInfo2)or
       (isFindTerm and isFindEmail2)or

       (isFindTerm and isFindObject)or
       (isFindTerm and isFindDirection)or
       (isFindTerm and isFindAccessWays)or
       (isFindTerm and isFindRemoteness)or

       (isFindTerm and isFindAdvertisment)then
     and29:=' and ';

    if (isFindPayment and isFindNote)or
       (isFindPayment and isFindCityRegionName)or
       (isFindPayment and isFindDateArrivalsStart)or
       (isFindPayment and isFindDateArrivalsEnd)or
       (isFindPayment and isFindSaleStatusName)or
       (isFindPayment and isFindSelfFormName)or
       (isFindPayment and isFindTypePremisesName)or
       (isFindPayment and isFindUnitPriceName)or
       (isFindPayment and isFindClientInfo)or
       (isFindPayment and isFindNN)or
       (isFindPayment and isFindGroundArea)or
       (isFindPayment and isFindWaterName)or
       (isFindPayment and isFindHeatName)or
       (isFindPayment and isFindStyleName)or
       (isFindPayment and isFindBuilderName)or
       (isFindPayment and isFindDelivery)or
       (isFindPayment and isFindAdvertismentNote)or
       (isFindPayment and isFindTaxes)or

       (isFindPayment and isFindAreaBuilding)or
       (isFindPayment and isFindPopulatedPoint)or
       (isFindPayment and isFindLandFeature)or
       (isFindPayment and isFindExchangeFormula)or
       (isFindPayment and isFindLocationStatus)or
       (isFindPayment and isFindLandMark)or
       (isFindPayment and isFindCommunications)or
       (isFindPayment and isFindEmail)or
       (isFindPayment and isFindLeaseOrSale)or

       (isFindPayment and isFindContact2)or
       (isFindPayment and isFindClientInfo2)or
       (isFindPayment and isFindEmail2)or

       (isFindPayment and isFindObject)or
       (isFindPayment and isFindDirection)or
       (isFindPayment and isFindAccessWays)or
       (isFindPayment and isFindRemoteness)or

       (isFindPayment and isFindAdvertisment)then
     and30:=' and ';

    if (isFindNote and isFindDateArrivalsStart)or
       (isFindNote and isFindCityRegionName)or
       (isFindNote and isFindDateArrivalsEnd)or
       (isFindNote and isFindSaleStatusName)or
       (isFindNote and isFindSelfFormName)or
       (isFindNote and isFindTypePremisesName)or
       (isFindNote and isFindUnitPriceName)or
       (isFindNote and isFindClientInfo)or
       (isFindNote and isFindNN)or
       (isFindNote and isFindGroundArea)or
       (isFindNote and isFindWaterName)or
       (isFindNote and isFindHeatName)or
       (isFindNote and isFindStyleName)or
       (isFindNote and isFindBuilderName)or
       (isFindNote and isFindDelivery)or
       (isFindNote and isFindAdvertismentNote)or
       (isFindNote and isFindTaxes)or

       (isFindNote and isFindAreaBuilding)or
       (isFindNote and isFindPopulatedPoint)or
       (isFindNote and isFindLandFeature)or
       (isFindNote and isFindExchangeFormula)or
       (isFindNote and isFindLocationStatus)or
       (isFindNote and isFindLandMark)or
       (isFindNote and isFindCommunications)or
       (isFindNote and isFindEmail)or
       (isFindNote and isFindLeaseOrSale)or

       (isFindNote and isFindContact2)or
       (isFindNote and isFindClientInfo2)or
       (isFindNote and isFindEmail2)or

       (isFindNote and isFindObject)or
       (isFindNote and isFindDirection)or
       (isFindNote and isFindAccessWays)or
       (isFindNote and isFindRemoteness)or

       (isFindNote and isFindAdvertisment)then
     and31:=' and ';

    if (isFindDateArrivalsStart and isFindDateArrivalsEnd)or
       (isFindDateArrivalsStart and isFindCityRegionName)or
       (isFindDateArrivalsStart and isFindSaleStatusName)or
       (isFindDateArrivalsStart and isFindSelfFormName)or
       (isFindDateArrivalsStart and isFindTypePremisesName)or
       (isFindDateArrivalsStart and isFindUnitPriceName)or
       (isFindDateArrivalsStart and isFindClientInfo)or
       (isFindDateArrivalsStart and isFindNN)or
       (isFindDateArrivalsStart and isFindGroundArea)or
       (isFindDateArrivalsStart and isFindWaterName)or
       (isFindDateArrivalsStart and isFindHeatName)or
       (isFindDateArrivalsStart and isFindStyleName)or
       (isFindDateArrivalsStart and isFindBuilderName)or
       (isFindDateArrivalsStart and isFindDelivery)or
       (isFindDateArrivalsStart and isFindAdvertismentNote)or
       (isFindDateArrivalsStart and isFindTaxes)or

       (isFindDateArrivalsStart and isFindAreaBuilding)or
       (isFindDateArrivalsStart and isFindPopulatedPoint)or
       (isFindDateArrivalsStart and isFindLandFeature)or
       (isFindDateArrivalsStart and isFindExchangeFormula)or
       (isFindDateArrivalsStart and isFindLocationStatus)or
       (isFindDateArrivalsStart and isFindLandMark)or
       (isFindDateArrivalsStart and isFindCommunications)or
       (isFindDateArrivalsStart and isFindEmail)or
       (isFindDateArrivalsStart and isFindLeaseOrSale)or

       (isFindDateArrivalsStart and isFindContact2)or
       (isFindDateArrivalsStart and isFindClientInfo2)or
       (isFindDateArrivalsStart and isFindEmail2)or

       (isFindDateArrivalsStart and isFindObject)or
       (isFindDateArrivalsStart and isFindDirection)or
       (isFindDateArrivalsStart and isFindAccessWays)or
       (isFindDateArrivalsStart and isFindRemoteness)or

       (isFindDateArrivalsStart and isFindAdvertisment)then
     and32:=' and ';

    if (isFindDateArrivalsEnd and isFindSaleStatusName)or
       (isFindDateArrivalsEnd and isFindCityRegionName)or
       (isFindDateArrivalsEnd and isFindSelfFormName)or
       (isFindDateArrivalsEnd and isFindTypePremisesName)or
       (isFindDateArrivalsEnd and isFindUnitPriceName)or
       (isFindDateArrivalsEnd and isFindClientInfo)or
       (isFindDateArrivalsEnd and isFindNN)or
       (isFindDateArrivalsEnd and isFindGroundArea)or
       (isFindDateArrivalsEnd and isFindWaterName)or
       (isFindDateArrivalsEnd and isFindHeatName)or
       (isFindDateArrivalsEnd and isFindStyleName)or
       (isFindDateArrivalsEnd and isFindBuilderName)or
       (isFindDateArrivalsEnd and isFindDelivery)or
       (isFindDateArrivalsEnd and isFindAdvertismentNote)or
       (isFindDateArrivalsEnd and isFindTaxes)or

       (isFindDateArrivalsEnd and isFindAreaBuilding)or
       (isFindDateArrivalsEnd and isFindPopulatedPoint)or
       (isFindDateArrivalsEnd and isFindLandFeature)or
       (isFindDateArrivalsEnd and isFindExchangeFormula)or
       (isFindDateArrivalsEnd and isFindLocationStatus)or
       (isFindDateArrivalsEnd and isFindLandMark)or
       (isFindDateArrivalsEnd and isFindCommunications)or
       (isFindDateArrivalsEnd and isFindEmail)or
       (isFindDateArrivalsEnd and isFindLeaseOrSale)or

       (isFindDateArrivalsEnd and isFindContact2)or
       (isFindDateArrivalsEnd and isFindClientInfo2)or
       (isFindDateArrivalsEnd and isFindEmail2)or

       (isFindDateArrivalsEnd and isFindObject)or
       (isFindDateArrivalsEnd and isFindDirection)or
       (isFindDateArrivalsEnd and isFindAccessWays)or
       (isFindDateArrivalsEnd and isFindRemoteness)or

       (isFindDateArrivalsEnd and isFindAdvertisment)then
     and33:=' and ';

    if (isFindSaleStatusName and isFindSelfFormName)or
       (isFindSaleStatusName and isFindCityRegionName)or
       (isFindSaleStatusName and isFindTypePremisesName)or
       (isFindSaleStatusName and isFindUnitPriceName)or
       (isFindSaleStatusName and isFindClientInfo)or
       (isFindSaleStatusName and isFindNN)or
       (isFindSaleStatusName and isFindGroundArea)or
       (isFindSaleStatusName and isFindWaterName)or
       (isFindSaleStatusName and isFindHeatName)or
       (isFindSaleStatusName and isFindStyleName)or
       (isFindSaleStatusName and isFindBuilderName)or
       (isFindSaleStatusName and isFindDelivery)or
       (isFindSaleStatusName and isFindAdvertismentNote)or
       (isFindSaleStatusName and isFindTaxes)or

       (isFindSaleStatusName and isFindAreaBuilding)or
       (isFindSaleStatusName and isFindPopulatedPoint)or
       (isFindSaleStatusName and isFindLandFeature)or
       (isFindSaleStatusName and isFindExchangeFormula)or
       (isFindSaleStatusName and isFindLocationStatus)or
       (isFindSaleStatusName and isFindLandMark)or
       (isFindSaleStatusName and isFindCommunications)or
       (isFindSaleStatusName and isFindEmail)or
       (isFindSaleStatusName and isFindLeaseOrSale)or

       (isFindSaleStatusName and isFindContact2)or
       (isFindSaleStatusName and isFindClientInfo2)or
       (isFindSaleStatusName and isFindEmail2)or

       (isFindSaleStatusName and isFindObject)or
       (isFindSaleStatusName and isFindDirection)or
       (isFindSaleStatusName and isFindAccessWays)or
       (isFindSaleStatusName and isFindRemoteness)or

       (isFindSaleStatusName and isFindAdvertisment)then
     and34:=' and ';

    if (isFindSelfFormName and isFindTypePremisesName)or
       (isFindSelfFormName and isFindCityRegionName)or
       (isFindSelfFormName and isFindUnitPriceName)or
       (isFindSelfFormName and isFindClientInfo)or
       (isFindSelfFormName and isFindNN)or
       (isFindSelfFormName and isFindGroundArea)or
       (isFindSelfFormName and isFindWaterName)or
       (isFindSelfFormName and isFindHeatName)or
       (isFindSelfFormName and isFindStyleName)or
       (isFindSelfFormName and isFindBuilderName)or
       (isFindSelfFormName and isFindDelivery)or
       (isFindSelfFormName and isFindAdvertismentNote)or
       (isFindSelfFormName and isFindTaxes)or

       (isFindSelfFormName and isFindAreaBuilding)or
       (isFindSelfFormName and isFindPopulatedPoint)or
       (isFindSelfFormName and isFindLandFeature)or
       (isFindSelfFormName and isFindExchangeFormula)or
       (isFindSelfFormName and isFindLocationStatus)or
       (isFindSelfFormName and isFindLandMark)or
       (isFindSelfFormName and isFindCommunications)or
       (isFindSelfFormName and isFindEmail)or
       (isFindSelfFormName and isFindLeaseOrSale)or

       (isFindSelfFormName and isFindContact2)or
       (isFindSelfFormName and isFindClientInfo2)or
       (isFindSelfFormName and isFindEmail2)or

       (isFindSelfFormName and isFindObject)or
       (isFindSelfFormName and isFindDirection)or
       (isFindSelfFormName and isFindAccessWays)or
       (isFindSelfFormName and isFindRemoteness)or

       (isFindSelfFormName and isFindAdvertisment)then
     and35:=' and ';

    if (isFindTypePremisesName and isFindUnitPriceName)or
       (isFindTypePremisesName and isFindCityRegionName)or
       (isFindTypePremisesName and isFindClientInfo)or
       (isFindTypePremisesName and isFindNN)or
       (isFindTypePremisesName and isFindGroundArea)or
       (isFindTypePremisesName and isFindWaterName)or
       (isFindTypePremisesName and isFindHeatName)or
       (isFindTypePremisesName and isFindStyleName)or
       (isFindTypePremisesName and isFindBuilderName)or
       (isFindTypePremisesName and isFindDelivery)or
       (isFindTypePremisesName and isFindAdvertismentNote)or
       (isFindTypePremisesName and isFindTaxes)or

       (isFindTypePremisesName and isFindAreaBuilding)or
       (isFindTypePremisesName and isFindPopulatedPoint)or
       (isFindTypePremisesName and isFindLandFeature)or
       (isFindTypePremisesName and isFindExchangeFormula)or
       (isFindTypePremisesName and isFindLocationStatus)or
       (isFindTypePremisesName and isFindLandMark)or
       (isFindTypePremisesName and isFindCommunications)or
       (isFindTypePremisesName and isFindEmail)or
       (isFindTypePremisesName and isFindLeaseOrSale)or

       (isFindTypePremisesName and isFindContact2)or
       (isFindTypePremisesName and isFindClientInfo2)or
       (isFindTypePremisesName and isFindEmail2)or

       (isFindTypePremisesName and isFindObject)or
       (isFindTypePremisesName and isFindDirection)or
       (isFindTypePremisesName and isFindAccessWays)or
       (isFindTypePremisesName and isFindRemoteness)or

       (isFindTypePremisesName and isFindAdvertisment) then
     and36:=' and ';

    if (isFindUnitPriceName and isFindClientInfo)or
       (isFindUnitPriceName and isFindCityRegionName)or
       (isFindUnitPriceName and isFindNN)or
       (isFindUnitPriceName and isFindGroundArea)or
       (isFindUnitPriceName and isFindWaterName)or
       (isFindUnitPriceName and isFindHeatName)or
       (isFindUnitPriceName and isFindStyleName)or
       (isFindUnitPriceName and isFindBuilderName)or
       (isFindUnitPriceName and isFindDelivery)or
       (isFindUnitPriceName and isFindAdvertismentNote)or
       (isFindUnitPriceName and isFindTaxes)or

       (isFindUnitPriceName and isFindAreaBuilding)or
       (isFindUnitPriceName and isFindPopulatedPoint)or
       (isFindUnitPriceName and isFindLandFeature)or
       (isFindUnitPriceName and isFindExchangeFormula)or
       (isFindUnitPriceName and isFindLocationStatus)or
       (isFindUnitPriceName and isFindLandMark)or
       (isFindUnitPriceName and isFindCommunications)or
       (isFindUnitPriceName and isFindEmail)or
       (isFindUnitPriceName and isFindLeaseOrSale)or

       (isFindUnitPriceName and isFindContact2)or
       (isFindUnitPriceName and isFindClientInfo2)or
       (isFindUnitPriceName and isFindEmail2)or

       (isFindUnitPriceName and isFindObject)or
       (isFindUnitPriceName and isFindDirection)or
       (isFindUnitPriceName and isFindAccessWays)or
       (isFindUnitPriceName and isFindRemoteness)or

       (isFindUnitPriceName and isFindAdvertisment)then
     and37:=' and ';

    if (isFindClientInfo and isFindNN)or
       (isFindClientInfo and isFindCityRegionName)or
       (isFindClientInfo and isFindGroundArea)or
       (isFindClientInfo and isFindWaterName)or
       (isFindClientInfo and isFindHeatName)or
       (isFindClientInfo and isFindStyleName)or
       (isFindClientInfo and isFindBuilderName)or
       (isFindClientInfo and isFindDelivery)or
       (isFindClientInfo and isFindAdvertismentNote)or
       (isFindClientInfo and isFindTaxes)or

       (isFindClientInfo and isFindAreaBuilding)or
       (isFindClientInfo and isFindPopulatedPoint)or
       (isFindClientInfo and isFindLandFeature)or
       (isFindClientInfo and isFindExchangeFormula)or
       (isFindClientInfo and isFindLocationStatus)or
       (isFindClientInfo and isFindLandMark)or
       (isFindClientInfo and isFindCommunications)or
       (isFindClientInfo and isFindEmail)or
       (isFindClientInfo and isFindLeaseOrSale)or

       (isFindClientInfo and isFindContact2)or
       (isFindClientInfo and isFindClientInfo2)or
       (isFindClientInfo and isFindEmail2)or

       (isFindClientInfo and isFindObject)or
       (isFindClientInfo and isFindDirection)or
       (isFindClientInfo and isFindAccessWays)or
       (isFindClientInfo and isFindRemoteness)or

       (isFindClientInfo and isFindAdvertisment)then
     and38:=' and ';

    if (isFindNN and isFindGroundArea)or
       (isFindNN and isFindCityRegionName)or
       (isFindNN and isFindWaterName)or
       (isFindNN and isFindHeatName)or
       (isFindNN and isFindStyleName)or
       (isFindNN and isFindBuilderName)or
       (isFindNN and isFindDelivery)or
       (isFindNN and isFindAdvertismentNote)or
       (isFindNN and isFindTaxes)or

       (isFindNN and isFindAreaBuilding)or
       (isFindNN and isFindPopulatedPoint)or
       (isFindNN and isFindLandFeature)or
       (isFindNN and isFindExchangeFormula)or
       (isFindNN and isFindLocationStatus)or
       (isFindNN and isFindLandMark)or
       (isFindNN and isFindCommunications)or
       (isFindNN and isFindEmail)or
       (isFindNN and isFindLeaseOrSale)or

       (isFindNN and isFindContact2)or
       (isFindNN and isFindClientInfo2)or
       (isFindNN and isFindEmail2)or

       (isFindNN and isFindObject)or
       (isFindNN and isFindDirection)or
       (isFindNN and isFindAccessWays)or
       (isFindNN and isFindRemoteness)or

       (isFindNN and isFindAdvertisment)then
     and39:=' and ';

    if (isFindGroundArea and isFindWaterName)or
       (isFindGroundArea and isFindCityRegionName)or
       (isFindGroundArea and isFindHeatName)or
       (isFindGroundArea and isFindStyleName)or
       (isFindGroundArea and isFindBuilderName)or
       (isFindGroundArea and isFindDelivery)or
       (isFindGroundArea and isFindAdvertismentNote)or
       (isFindGroundArea and isFindTaxes)or

       (isFindGroundArea and isFindAreaBuilding)or
       (isFindGroundArea and isFindPopulatedPoint)or
       (isFindGroundArea and isFindLandFeature)or
       (isFindGroundArea and isFindExchangeFormula)or
       (isFindGroundArea and isFindLocationStatus)or
       (isFindGroundArea and isFindLandMark)or
       (isFindGroundArea and isFindCommunications)or
       (isFindGroundArea and isFindEmail)or
       (isFindGroundArea and isFindLeaseOrSale)or

       (isFindGroundArea and isFindContact2)or
       (isFindGroundArea and isFindClientInfo2)or
       (isFindGroundArea and isFindEmail2)or

       (isFindGroundArea and isFindObject)or
       (isFindGroundArea and isFindDirection)or
       (isFindGroundArea and isFindAccessWays)or
       (isFindGroundArea and isFindRemoteness)or

       (isFindGroundArea and isFindAdvertisment)then
     and40:=' and ';

    if (isFindWaterName and isFindHeatName)or
       (isFindWaterName and isFindCityRegionName)or
       (isFindWaterName and isFindStyleName)or
       (isFindWaterName and isFindBuilderName)or
       (isFindWaterName and isFindDelivery)or
       (isFindWaterName and isFindAdvertismentNote)or
       (isFindWaterName and isFindTaxes)or

       (isFindWaterName and isFindAreaBuilding)or
       (isFindWaterName and isFindPopulatedPoint)or
       (isFindWaterName and isFindLandFeature)or
       (isFindWaterName and isFindExchangeFormula)or
       (isFindWaterName and isFindLocationStatus)or
       (isFindWaterName and isFindLandMark)or
       (isFindWaterName and isFindCommunications)or
       (isFindWaterName and isFindEmail)or
       (isFindWaterName and isFindLeaseOrSale)or

       (isFindWaterName and isFindContact2)or
       (isFindWaterName and isFindClientInfo2)or
       (isFindWaterName and isFindEmail2)or

       (isFindWaterName and isFindObject)or
       (isFindWaterName and isFindDirection)or
       (isFindWaterName and isFindAccessWays)or
       (isFindWaterName and isFindRemoteness)or

       (isFindWaterName and isFindAdvertisment)then
     and41:=' and ';

    if (isFindHeatName and isFindStyleName) or
       (isFindHeatName and isFindCityRegionName)or
       (isFindHeatName and isFindBuilderName)or
       (isFindHeatName and isFindDelivery)or
       (isFindHeatName and isFindAdvertismentNote)or
       (isFindHeatName and isFindTaxes)or

       (isFindHeatName and isFindAreaBuilding)or
       (isFindHeatName and isFindPopulatedPoint)or
       (isFindHeatName and isFindLandFeature)or
       (isFindHeatName and isFindExchangeFormula)or
       (isFindHeatName and isFindLocationStatus)or
       (isFindHeatName and isFindLandMark)or
       (isFindHeatName and isFindCommunications)or
       (isFindHeatName and isFindEmail)or
       (isFindHeatName and isFindLeaseOrSale)or

       (isFindHeatName and isFindContact2)or
       (isFindHeatName and isFindClientInfo2)or
       (isFindHeatName and isFindEmail2)or

       (isFindHeatName and isFindObject)or
       (isFindHeatName and isFindDirection)or
       (isFindHeatName and isFindAccessWays)or
       (isFindHeatName and isFindRemoteness)or

       (isFindHeatName and isFindAdvertisment)then
     and42:=' and ';

    if (isFindStyleName and isFindBuilderName)or
       (isFindStyleName and isFindCityRegionName)or
       (isFindStyleName and isFindDelivery)or
       (isFindStyleName and isFindAdvertismentNote)or
       (isFindStyleName and isFindTaxes)or

       (isFindStyleName and isFindAreaBuilding)or
       (isFindStyleName and isFindPopulatedPoint)or
       (isFindStyleName and isFindLandFeature)or
       (isFindStyleName and isFindExchangeFormula)or
       (isFindStyleName and isFindLocationStatus)or
       (isFindStyleName and isFindLandMark)or
       (isFindStyleName and isFindCommunications)or
       (isFindStyleName and isFindEmail)or
       (isFindStyleName and isFindLeaseOrSale)or

       (isFindStyleName and isFindContact2)or
       (isFindStyleName and isFindClientInfo2)or
       (isFindStyleName and isFindEmail2)or

       (isFindStyleName and isFindObject)or
       (isFindStyleName and isFindDirection)or
       (isFindStyleName and isFindAccessWays)or
       (isFindStyleName and isFindRemoteness)or

       (isFindStyleName and isFindAdvertisment) then
     and43:=' and ';

    if (isFindBuilderName and isFindDelivery)or
       (isFindBuilderName and isFindCityRegionName)or
       (isFindBuilderName and isFindAdvertismentNote)or
       (isFindBuilderName and isFindTaxes)or

       (isFindBuilderName and isFindAreaBuilding)or
       (isFindBuilderName and isFindPopulatedPoint)or
       (isFindBuilderName and isFindLandFeature)or
       (isFindBuilderName and isFindExchangeFormula)or
       (isFindBuilderName and isFindLocationStatus)or
       (isFindBuilderName and isFindLandMark)or
       (isFindBuilderName and isFindCommunications)or
       (isFindBuilderName and isFindEmail)or
       (isFindBuilderName and isFindLeaseOrSale)or

       (isFindBuilderName and isFindContact2)or
       (isFindBuilderName and isFindClientInfo2)or
       (isFindBuilderName and isFindEmail2)or

       (isFindBuilderName and isFindObject)or
       (isFindBuilderName and isFindDirection)or
       (isFindBuilderName and isFindAccessWays)or
       (isFindBuilderName and isFindRemoteness)or

       (isFindBuilderName and isFindAdvertisment) then
     and44:=' and ';

    if (isFindDelivery and isFindCityRegionName)or
       (isFindDelivery and isFindAdvertismentNote)or
       (isFindDelivery and isFindTaxes)or

       (isFindDelivery and isFindAreaBuilding)or
       (isFindDelivery and isFindPopulatedPoint)or
       (isFindDelivery and isFindLandFeature)or
       (isFindDelivery and isFindExchangeFormula)or
       (isFindDelivery and isFindLocationStatus)or
       (isFindDelivery and isFindLandMark)or
       (isFindDelivery and isFindCommunications)or
       (isFindDelivery and isFindEmail)or
       (isFindDelivery and isFindLeaseOrSale)or

       (isFindDelivery and isFindContact2)or
       (isFindDelivery and isFindClientInfo2)or
       (isFindDelivery and isFindEmail2)or

       (isFindDelivery and isFindObject)or
       (isFindDelivery and isFindDirection)or
       (isFindDelivery and isFindAccessWays)or
       (isFindDelivery and isFindRemoteness)or

       (isFindDelivery and isFindAdvertisment) then
     and45:=' and ';

    if (isFindCityRegionName and isFindAdvertismentNote)or
       (isFindCityRegionName and isFindTaxes)or

       (isFindCityRegionName and isFindAreaBuilding)or
       (isFindCityRegionName and isFindPopulatedPoint)or
       (isFindCityRegionName and isFindLandFeature)or
       (isFindCityRegionName and isFindExchangeFormula)or
       (isFindCityRegionName and isFindLocationStatus)or
       (isFindCityRegionName and isFindLandMark)or
       (isFindCityRegionName and isFindCommunications)or
       (isFindCityRegionName and isFindEmail)or
       (isFindCityRegionName and isFindLeaseOrSale)or

       (isFindCityRegionName and isFindContact2)or
       (isFindCityRegionName and isFindClientInfo2)or
       (isFindCityRegionName and isFindEmail2)or

       (isFindCityRegionName and isFindObject)or
       (isFindCityRegionName and isFindDirection)or
       (isFindCityRegionName and isFindAccessWays)or
       (isFindCityRegionName and isFindRemoteness)or

       (isFindCityRegionName and isFindAdvertisment)then
     and46:=' and ';

    if (isFindAdvertismentNote and isFindAdvertisment) or
       (isFindAdvertismentNote and isFindTaxes) or
       (isFindAdvertismentNote and isFindAreaBuilding)or
       (isFindAdvertismentNote and isFindPopulatedPoint)or
       (isFindAdvertismentNote and isFindLandFeature)or
       (isFindAdvertismentNote and isFindExchangeFormula)or
       (isFindAdvertismentNote and isFindLocationStatus)or
       (isFindAdvertismentNote and isFindLandMark)or
       (isFindAdvertismentNote and isFindCommunications)or
       (isFindAdvertismentNote and isFindEmail)or
       (isFindAdvertismentNote and isFindLeaseOrSale)or

       (isFindAdvertismentNote and isFindContact2)or
       (isFindAdvertismentNote and isFindClientInfo2)or
       (isFindAdvertismentNote and isFindEmail2)or

       (isFindAdvertismentNote and isFindObject)or
       (isFindAdvertismentNote and isFindDirection)or
       (isFindAdvertismentNote and isFindAccessWays)or
       (isFindAdvertismentNote and isFindRemoteness)then

     and47:=' and ';

    if (isFindAdvertisment and isFindTaxes) or
       (isFindAdvertisment and isFindAreaBuilding)or
       (isFindAdvertisment and isFindPopulatedPoint)or
       (isFindAdvertisment and isFindLandFeature)or
       (isFindAdvertisment and isFindExchangeFormula)or
       (isFindAdvertisment and isFindLocationStatus)or
       (isFindAdvertisment and isFindLandMark)or
       (isFindAdvertisment and isFindCommunications)or
       (isFindAdvertisment and isFindEmail)or
       (isFindAdvertisment and isFindLeaseOrSale)or

       (isFindAdvertisment and isFindContact2)or
       (isFindAdvertisment and isFindClientInfo2)or
       (isFindAdvertisment and isFindEmail2)or

       (isFindAdvertisment and isFindObject)or
       (isFindAdvertisment and isFindDirection)or
       (isFindAdvertisment and isFindAccessWays)or
       (isFindAdvertisment and isFindRemoteness)then

     and48:=' and ';

    if (isFindTaxes and isFindAreaBuilding)or
       (isFindTaxes and isFindPopulatedPoint)or
       (isFindTaxes and isFindLandFeature)or
       (isFindTaxes and isFindExchangeFormula)or
       (isFindTaxes and isFindLocationStatus)or
       (isFindTaxes and isFindLandMark)or
       (isFindTaxes and isFindCommunications)or
       (isFindTaxes and isFindEmail)or
       (isFindTaxes and isFindLeaseOrSale)or

       (isFindTaxes and isFindContact2)or
       (isFindTaxes and isFindClientInfo2)or
       (isFindTaxes and isFindEmail2)or

       (isFindTaxes and isFindObject)or
       (isFindTaxes and isFindDirection)or
       (isFindTaxes and isFindAccessWays)or
       (isFindTaxes and isFindRemoteness)then

     and49:=' and ';

    if (isFindAreaBuilding and isFindPopulatedPoint)or
       (isFindAreaBuilding and isFindLandFeature)or
       (isFindAreaBuilding and isFindExchangeFormula)or
       (isFindAreaBuilding and isFindLocationStatus)or
       (isFindAreaBuilding and isFindLandMark)or
       (isFindAreaBuilding and isFindCommunications)or
       (isFindAreaBuilding and isFindEmail)or
       (isFindAreaBuilding and isFindLeaseOrSale)or

       (isFindAreaBuilding and isFindObject)or
       (isFindAreaBuilding and isFindDirection)or
       (isFindAreaBuilding and isFindAccessWays)or
       (isFindAreaBuilding and isFindRemoteness)or

       (isFindAreaBuilding and isFindContact2)or
       (isFindAreaBuilding and isFindClientInfo2)or
       (isFindAreaBuilding and isFindEmail2)then


     and50:=' and ';

    if (isFindPopulatedPoint and isFindLandFeature)or
       (isFindPopulatedPoint and isFindExchangeFormula)or
       (isFindPopulatedPoint and isFindLocationStatus)or
       (isFindPopulatedPoint and isFindLandMark)or
       (isFindPopulatedPoint and isFindCommunications)or
       (isFindPopulatedPoint and isFindEmail)or
       (isFindPopulatedPoint and isFindLeaseOrSale)or

       (isFindPopulatedPoint and isFindObject)or
       (isFindPopulatedPoint and isFindDirection)or
       (isFindPopulatedPoint and isFindAccessWays)or
       (isFindPopulatedPoint and isFindRemoteness)or

       (isFindPopulatedPoint and isFindContact2)or
       (isFindPopulatedPoint and isFindClientInfo2)or
       (isFindPopulatedPoint and isFindEmail2)then


     and51:=' and ';

    if (isFindLandFeature and isFindExchangeFormula)or
       (isFindLandFeature and isFindLocationStatus)or
       (isFindLandFeature and isFindLandMark)or
       (isFindLandFeature and isFindCommunications)or
       (isFindLandFeature and isFindEmail)or
       (isFindLandFeature and isFindLeaseOrSale)or

       (isFindLandFeature and isFindObject)or
       (isFindLandFeature and isFindDirection)or
       (isFindLandFeature and isFindAccessWays)or
       (isFindLandFeature and isFindRemoteness)or

       (isFindLandFeature and isFindContact2)or
       (isFindLandFeature and isFindClientInfo2)or
       (isFindLandFeature and isFindEmail2)then


     and52:=' and ';

    if (isFindExchangeFormula and isFindLocationStatus)or
       (isFindExchangeFormula and isFindLandMark)or
       (isFindExchangeFormula and isFindCommunications)or
       (isFindExchangeFormula and isFindEmail)or
       (isFindExchangeFormula and isFindLeaseOrSale)or

       (isFindExchangeFormula and isFindObject)or
       (isFindExchangeFormula and isFindDirection)or
       (isFindExchangeFormula and isFindAccessWays)or
       (isFindExchangeFormula and isFindRemoteness)or

       (isFindExchangeFormula and isFindContact2)or
       (isFindExchangeFormula and isFindClientInfo2)or
       (isFindExchangeFormula and isFindEmail2)then


     and53:=' and ';

    if (isFindLocationStatus and isFindLandMark)or
       (isFindLocationStatus and isFindCommunications)or
       (isFindLocationStatus and isFindEmail)or
       (isFindLocationStatus and isFindLeaseOrSale)or

       (isFindLocationStatus and isFindObject)or
       (isFindLocationStatus and isFindDirection)or
       (isFindLocationStatus and isFindAccessWays)or
       (isFindLocationStatus and isFindRemoteness)or
       
       (isFindLocationStatus and isFindContact2)or
       (isFindLocationStatus and isFindClientInfo2)or
       (isFindLocationStatus and isFindEmail2)then


     and54:=' and ';

    if (isFindLandMark and isFindCommunications)or
       (isFindLandMark and isFindEmail)or
       (isFindLandMark and isFindLeaseOrSale)or

       (isFindLandMark and isFindObject)or
       (isFindLandMark and isFindDirection)or
       (isFindLandMark and isFindAccessWays)or
       (isFindLandMark and isFindRemoteness)or
       
       (isFindLandMark and isFindContact2)or
       (isFindLandMark and isFindClientInfo2)or
       (isFindLandMark and isFindEmail2)then


     and55:=' and ';

    if (isFindCommunications and isFindEmail)or
       (isFindCommunications and isFindLeaseOrSale)or

       (isFindCommunications and isFindObject)or
       (isFindCommunications and isFindDirection)or
       (isFindCommunications and isFindAccessWays)or
       (isFindCommunications and isFindRemoteness)or
       
       (isFindCommunications and isFindContact2)or
       (isFindCommunications and isFindClientInfo2)or
       (isFindCommunications and isFindEmail2)then


     and56:=' and ';

    if (isFindEmail and isFindLeaseOrSale)or

       (isFindEmail and isFindObject)or
       (isFindEmail and isFindDirection)or
       (isFindEmail and isFindAccessWays)or
       (isFindEmail and isFindRemoteness)or

       (isFindEmail and isFindContact2)or
       (isFindEmail and isFindClientInfo2)or
       (isFindEmail and isFindEmail2)then


     and57:=' and ';

    if (isFindLeaseOrSale and isFindContact2)or

       (isFindLeaseOrSale and isFindObject)or
       (isFindLeaseOrSale and isFindDirection)or
       (isFindLeaseOrSale and isFindAccessWays)or
       (isFindLeaseOrSale and isFindRemoteness)or

       (isFindLeaseOrSale and isFindClientInfo2)or
       (isFindLeaseOrSale and isFindEmail2)then


     and58:=' and ';

    if (isFindContact2 and isFindClientInfo2)or
       (isFindContact2 and isFindEmail2)or

       (isFindContact2 and isFindObject)or
       (isFindContact2 and isFindDirection)or
       (isFindContact2 and isFindAccessWays)or
       (isFindContact2 and isFindRemoteness)then

     and59:=' and ';

    if (isFindClientInfo2 and isFindEmail2)or
       (isFindClientInfo2 and isFindObject)or
       (isFindClientInfo2 and isFindDirection)or
       (isFindClientInfo2 and isFindAccessWays)or
       (isFindClientInfo2 and isFindRemoteness)then

     and60:=' and ';

    if (isFindEmail2 and isFindObject)or
       (isFindEmail2 and isFindDirection)or
       (isFindEmail2 and isFindAccessWays)or
       (isFindEmail2 and isFindRemoteness)then

     and61:=' and ';

    if (isFindObject and isFindDirection)or
       (isFindObject and isFindAccessWays)or
       (isFindObject and isFindRemoteness)then

     and62:=' and ';

    if (isFindDirection and isFindAccessWays)or
       (isFindDirection and isFindRemoteness)then

     and63:=' and ';

    if (isFindAccessWays and isFindRemoteness)then

     and64:=' and ';


    Result:=wherestr+addstr1+and1+addstr2+and2+
                     addstr3+and3+addstr4+and4+
                     addstr5+and5+addstr6+and6+
                     addstr7+and7+addstr8+and8+
                     addstr9+and9+addstr10+and10+
                     addstr11+and11+addstr12+and12+
                     addstr13+and13+addstr14+and14+
                     addstr15+and15+addstr16+and16+
                     addstr17+and17+addstr18+and18+
                     addstr19+and19+addstr20+and20+
                     addstr21+and21+addstr22+and22+
                     addstr23+and23+addstr24+and24+
                     addstr25+and25+addstr26+and26+
                     addstr27+and27+addstr28+and28+
                     addstr29+and29+addstr30+and30+
                     addstr31+and31+addstr32+and32+
                     addstr33+and33+addstr34+and34+
                     addstr35+and35+addstr36+and36+
                     addstr37+and37+addstr38+and38+
                     addstr39+and39+addstr40+and40+
                     addstr41+and41+addstr42+and42+
                     addstr43+and43+addstr44+and44+
                     addstr45+and45+addstr46+and46+
                     addstr47+and47+addstr48+and48+
                     addstr49+and49+addstr50+and50+
                     addstr51+and51+addstr52+and52+
                     addstr53+and53+addstr54+and54+
                     addstr55+and55+addstr56+and56+
                     addstr57+and57+addstr58+and58+
                     addstr59+and59+addstr60+and60+
                     addstr61+and61+addstr62+and62+
                     addstr63+and63+addstr64+and64+
                     addstr65;
end;
{$WARNINGS ON}

procedure TfmRBPms_Premises.ClearFilter;
begin
  FindRegionName:='';
  FindCityRegionName:='';
  FindStreetName:='';
  FindBalconyName:='';
  FindConditionName:='';
  FindSanitaryNodeName:='';
  FindHeatName:='';
  FindWaterName:='';
  FindStyleName:='';
  FindBuilderName:='';
  FindDelivery:='';
  FindAgentName:='';
  FindDoorName:='';
  FindCountRoomName:='';
  FindTypeRoomName:='';
  FindPlanningName:='';
  FindStationName:='';
  FindTypeHouseName:='';
  FindStoveName:='';
  FindFurnitureName:='';
  FindContact:='';
  FindClientInfo:='';
  FindContact2:='';
  FindClientInfo2:='';
  FindHouseNumber:='';
  FindApartmentNumber:='';
  FindPhoneName:='';
  FindDocumentName:='';
  FindFloor:='';
  FindCountFloor:='';
  FindGeneralArea:='';
  FindgroundArea:='';
  FindDwellingArea:='';
  FindKitchenArea:='';
  FindPrice:='';
  FindTerm:='';
  FindPayment:='';
  FindNote:='';
  {by BART}
  FindAdvertismentNote:='';
  FindAdvertisment:=false;
  FindTaxes:='';

  FindAreaBuilding:='';
  FindPopulatedPoint:='';
  FindLandFeature:='';
  FindExchangeFormula:='';
  FindLocationStatus:='';
  FindLandMark:='';
  FindCommunications:='';
  FindEmail:='';
  FindEmail2:='';
  FindLeaseOrSale:='';

  FindObject:='';
  FindDirection:='';
  FindAccessWays:='';
  FindRemoteness:='';

  {by BARt}
  FindDateArrivalsStart:=Now;
  isFindDateArrivalsStart:=false;
  FindDateArrivalsEnd:=Now;
  isFindDateArrivalsEnd:=false;
  FindRecyled:=0;
  FindSaleStatusName:='';
  FindSelfFormName:='';
  FindTypePremisesName:='';
  FindUnitPriceName:='';
  FindNN:='';
  Finddelivery:='';
end;

procedure TfmRBPms_Premises.tcGridChange(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  try
    Grid.Name:=GetGridName;
    FillGridColumns;
    LoadGridProp(ClassName,TDbGrid(Grid));
    FillDefaultOrders;
    LoadDbOrders(ClassName,DefaultOrders);
    ClearFilter;
    LoadFilter;
    ActiveQuery(false);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRBPms_Premises.tcGridChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  Screen.Cursor:=crHourGlass;
  try
    Grid.Name:=GetGridName;
    SaveGridProp(ClassName,TDbGrid(Grid));
    SaveDbOrders(ClassName,DefaultOrders);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

{procedure TfmRBPms_Premises.SetTabCaption;
var
  i: Integer;
  Recyled: Integer;
begin
  for i:=0 to tcGrid.Tabs.Count-1 do begin
    Recyled:=0;
    Recyled:=ReadParam(ClassName,'Recyled'+inttostr(i),Recyled);
    case i of
      0: begin
        tcGrid.Tabs.Strings[i]:='Продажа'+iff(Recyled<>0,' - Корзина','');
      end;
      1:begin
        tcGrid.Tabs.Strings[i]:='Аренда'+iff(Recyled<>0,' - Корзина','');
      end;
      2:begin
        tcGrid.Tabs.Strings[i]:='Долевое'+iff(Recyled<>0,' - Корзина','');
      end;
    end;
 end;
end;}

procedure TfmRBPms_Premises.SetTabCaption;
var
  i: Integer;
  Recyled: Integer;
begin
  for i:=0 to tcGrid.Tabs.Count-1 do begin
    Recyled:=ReadParam(ClassName,'Recyled'+inttostr(i),0);
    {by BART}
    case i of
      0: begin
         if Recyled=1 then tcGrid.Tabs.Strings[i]:='Продажа - Корзина';
         if Recyled=2 then tcGrid.Tabs.Strings[i]:='Продажа - Все';
         if Recyled=0 then tcGrid.Tabs.Strings[i]:='Продажа';

        {tcGrid.Tabs.Strings[i]:='Продажа'+iff(Recyled=1,' - Корзина','');
         }
      end;
      1:begin
        if Recyled=1 then tcGrid.Tabs.Strings[i]:='Аренда - Корзина';
        if Recyled=2 then tcGrid.Tabs.Strings[i]:='Аренда - Все';
        if Recyled=0 then tcGrid.Tabs.Strings[i]:='Аренда';

       { tcGrid.Tabs.Strings[i]:='Аренда'+iff(Recyled=1,' - Корзина','');}
      end;
      2:begin
        if Recyled=1 then tcGrid.Tabs.Strings[i]:='Долевое - Корзина';
        if Recyled=2 then tcGrid.Tabs.Strings[i]:='Долевое - Все';
        if Recyled=0 then tcGrid.Tabs.Strings[i]:='Долевое';
      end;
      3:begin
        if Recyled=1 then tcGrid.Tabs.Strings[i]:='Земля - Корзина';
        if Recyled=2 then tcGrid.Tabs.Strings[i]:='Земля - Все';
        if Recyled=0 then tcGrid.Tabs.Strings[i]:='Земля';
       end;
        {tcGrid.Tabs.Strings[i]:='Долевое'+iff(Recyled=1,' - Корзина',''); }

     {by BART}
    end;
 end;
end;


procedure TfmRBPms_Premises.OnTabGetImageEvent(Sender: TObject; TabIndex: Integer; var ImageIndex: Integer);
begin
  if not NotUseRecyled then
   ImageIndex:=ReadParam(ClassName,'Recyled'+inttostr(TabIndex),0)
  else ImageIndex:=2;
end;

procedure TfmRBPms_Premises.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  if isValidPointer(Param.Param) then begin
    Screen.Cursor:=crHourGlass;
    try
      isCheckDouble:=true;
      tcGrid.TabIndex:=PParamRBPms_Premises(Param.Param).TypeOperation;
      Caption:=PParamRBPms_Premises(Param.Param).Caption;
    //  FindRecyled:=PParamRBPms_Premises(Param.Param).Recyled;
      NotUseRecyled:=PParamRBPms_Premises(Param.Param).NotUseRecyled;
      Grid.Name:=GetGridName;
      FillGridColumns;
      LoadGridProp(ClassName,TDbGrid(Grid));
      FillDefaultOrders;
      LoadDbOrders(ClassName,DefaultOrders);
      ClearFilter;
    //  LoadFilter;
    finally
      Screen.Cursor:=crDefault;
    end;  
  end;
  inherited;
  if isValidPointer(Param.Param) then begin
    AddDisable:=not PParamRBPms_Premises(Param.Param).AddDisable;
    ChangeDisable:=not PParamRBPms_Premises(Param.Param).ChangeDisable;
    DeleteDisable:=not PParamRBPms_Premises(Param.Param).DeleteDisable;
    FilterDisable:=not PParamRBPms_Premises(Param.Param).FilterDisable;
    NotUseAdvFilter:=PParamRBPms_Premises(Param.Param).NotUseAdvFilter;
  end;
end;

procedure TfmRBPms_Premises.MoveFromRecyled;
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
  dt: TDateTime;
  T: TInfoConnectUser;
begin
 Screen.Cursor:=crHourGlass;
 qr:=TIBQuery.Create(nil);
 tran:=TIBTransaction.Create(nil);
 try
  try
   FillChar(T,SizeOf(T),0);
   _GetInfoConnectUser(@T);
   dt:=_GetDateTimeFromServer;

   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   tran.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=IBDB;
   qr.Transaction:=tran;
   qr.Transaction.Active:=true;
   sqls:='Update '+tbPms_Premises+
         ' set datetimeupdate='+QuotedStr(DateTimeToStr(dt))+
         ', whoupdate_id='+inttostr(T.User_id)+
         ', daterecyledout=null'+
         ', pms_station_id='+iff((fmOptions.edMoveFromRecyled.Text)='','null',inttostr(fmOptions.edMoveFromRecyled.Tag))+
         ', recyled=0'+
         ' where recyled=1 and daterecyledout is not null and daterecyledout<='+QuotedStr(DateToStr(_GetWorkDate));
   qr.sql.Add(sqls);
   qr.ExecSQL;
   qr.Transaction.Commit;

  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
 finally
  tran.Free;
  qr.Free;
  Screen.Cursor:=crDefault;
 end;

end;

function TfmRBPms_Premises.GetDefaultOrdersName: string;
begin
  Result:=TOS(inherited GetDefaultOrdersName)
end;

function TfmRBPms_Premises.ClassName: string;
begin
  if not isCheckDouble then
    Result:=inherited ClassName
  else
    Result:=inherited ClassName+'Double';                    
end;

procedure TfmRBPms_Premises.MainqrAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if DataSet.Active and not DataSet.IsEmpty then begin
    bibChange.Enabled:=ChangeEnable and (FSyncOfficeId=DataSet.FieldByName('sync_office_id').AsInteger);
    btExtension.Enabled:=bibChange.Enabled;
  end;
end;

procedure TfmRBPms_Premises.SetSyncOfficeId;
var
  TPRBI: TParamRbookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr('ОФИС')+' ');
  if _ViewInterfaceFromName(NameRbkConst,@TPRBI) then begin
    FSyncOfficeId:=StrToInt(GetFirstValueFromPRBI(@TPRBI,'valueview'));
  end;
end;

procedure TfmRBPms_Premises.btExtensionClick(Sender: TObject);
var
  but: Integer;
  NewDate: TDate;

  function ExtensionCurrent: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    dt: TDateTime;
    T: TInfoConnectUser;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     FillChar(T,SizeOf(T),0);
     _GetInfoConnectUser(@T);
     dt:=_GetDateTimeFromServer;

     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='UPDATE '+tbPms_Premises+
           ' SET DATEARRIVALS='+QuotedStr(DateToStr(NewDate))+
           ', DATETIMEUPDATE='+QuotedStr(DateTimeToStr(dt))+
           ', WHOUPDATE_ID='+inttostr(T.User_id)+
           ' WHERE PMS_PREMISES_ID='+Mainqr.FieldByName('PMS_PREMISES_ID').asString+
           ' AND PMS_AGENT_ID='+Mainqr.FieldByName('PMS_AGENT_ID').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.ModifySQL.Clear;
     IBUpd.ModifySQL.Add(sqls);

     with MainQr do begin
       Edit;
       FieldByName('DATEARRIVALS').AsDateTime:=NewDate;
       FieldByName('DATETIMEUPDATE').AsDateTime:=dt;
       FieldByName('WHOUPDATE_ID').AsInteger:=T.User_id;
       FieldByName('WHOUPDATENAME').AsString:=T.UserName;
       Post;
     end;


     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

  function ExtensionByFilter: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    B: TBookmark;
    dt: TDateTime;
    T: TInfoConnectUser;
    PbHandle: THandle;
    TCPB: TCreateProgressBar;
    TSPBS: TSetProgressBarStatus;
    Progress: Integer;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     FillChar(T,SizeOf(T),0);
     _GetInfoConnectUser(@T);
     dt:=_GetDateTimeFromServer;

     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;

     MainQr.DisableControls;
     B:=MainQr.GetBookmark;
     MainQr.AfterScroll:=nil;
     MainQr.FetchAll;
     FillChar(TCPB,SizeOf(TCPB),0);
     TCPB.Min:=0;
     TCPB.Max:=MainQr.RecordCount;
     TCPB.Color:=clNavy;
     PBHandle:=_CreateProgressBar(@TCPB);
     try
       Progress:=0;
       MainQr.First;
       while not MainQr.Eof do begin

         qr.Transaction.Active:=false;
         qr.Transaction.Active:=true;
         sqls:='UPDATE '+tbPms_Premises+
               ' SET DATEARRIVALS='+QuotedStr(DateToStr(NewDate))+
               ', DATETIMEUPDATE='+QuotedStr(DateTimeToStr(dt))+
               ', WHOUPDATE_ID='+inttostr(T.User_id)+
               ' WHERE PMS_PREMISES_ID='+Mainqr.FieldByName('PMS_PREMISES_ID').asString+
               ' AND PMS_AGENT_ID='+Mainqr.FieldByName('PMS_AGENT_ID').asString;
         qr.sql.Text:=sqls;
         qr.ExecSQL;
         qr.Transaction.Commit;

         IBUpd.ModifySQL.Clear;
         IBUpd.ModifySQL.Add(sqls);

         MainQr.Edit;
         MainQr.FieldByName('DATEARRIVALS').AsDateTime:=NewDate;
         MainQr.FieldByName('DATETIMEUPDATE').AsDateTime:=dt;
         MainQr.FieldByName('WHOUPDATE_ID').AsInteger:=T.User_id;
         MainQr.FieldByName('WHOUPDATENAME').AsString:=T.UserName;
         MainQr.Post;

         inc(Progress);
         FillChar(TSPBS,SizeOf(TSPBS),0);
         TSPBS.Progress:=Progress;
         TSPBS.Max:=MainQr.RecordCount;
         _SetProgressBarStatus(PBHandle,@TSPBS);

         MainQr.Next;
       end;
     finally
       _FreeProgressBar(PBHandle);
       if Assigned(B) then
         if MainQr.BookmarkValid(B) then
            MainQr.GotoBookmark(B);
       MainQr.AfterScroll:=MainqrAfterScroll;
       MainqrAfterScroll(MainQr);
       MainQr.EnableControls;     
     end;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

  function ExtensionMessage(Msg: String): TModalResult;
  var
    fm: TForm;
    lb,lbMessage: TLabel;
    dtp: TDateTimePicker;
    bt: TButton;
  const
    Dh=0;
    dy=3;
    dx=6;
  begin
    fm:=CreateMessageDialog(Msg,mtConfirmation,[mbYes,mbAll,mbNo]);
    try
      lb:=TLabel.Create(fm);
      lb.Parent:=fm;
      lb.Caption:='Новая дата поступления:';
      lbMessage:=TLabel(fm.FindComponent('Message'));
      if lbMessage<>nil then begin
        lb.Left:=lbMessage.Left;
        lb.Top:=lbMessage.top+lbMessage.Height+dx;
      end;
      fm.Height:=fm.Height+Dh;
      bt:=TButton(fm.FindComponent('All'));
      if bt<>nil then bt.Caption:='Все';
      bt:=TButton(fm.FindComponent('Yes'));
      if bt<>nil then bt.Top:=bt.Top+Dh;
      bt:=TButton(fm.FindComponent('No'));
      if bt<>nil then bt.Top:=bt.Top+Dh;
      dtp:=TDateTimePicker.Create(fm);
      dtp.Parent:=fm;
      dtp.Left:=lb.Left+lb.Width+dx;
      dtp.Width:=82;
      dtp.Top:=lb.Top-dy;
      dtp.DateTime:=_GetWorkDate;
      fm.ActiveControl:=dtp;
      fm.Width:=fm.Width;
      fm.Position:=poScreenCenter;
      Result:=fm.ShowModal;
      NewDate:=dtp.Date;
    finally
      fm.Free;
    end;
  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=ExtensionMessage('Продлить текущий вариант (да) или все по фильтру (все)?');
  case but of
    mrYes: ExtensionCurrent;
    mrAll: begin
      if ShowQuestionEx('Вы уверены?')=mrYes then
        ExtensionByFilter;
    end;
  end;
end;
{by BARt}
procedure TfmRBPms_Premises.btAdvertismentClick(Sender: TObject);
var
 fm:TfmAdvertisment_in_Premises;
begin
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmAdvertisment_in_Premises.Create(nil);
   try
    fm.fmParent:=self;
    fm.isView:=not bibChange.Enabled;
    fm.Pms_Premises_id:=MainQr.FieldByName('Pms_Premises_id').AsInteger;;
    fm.Pms_Agent_id:=MainQr.FieldByName('pms_agent_id').AsInteger;
    fm.TypeOperation:=tcGrid.TabIndex;
    fm.ActiveQuery;
    fm.ShowModal;

   finally
    fm.Free;
   end;
end;

function TfmRBPms_Premises.WarningAdvertisment: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
 //   dt: TDateTime;
  //  T: TInfoConnectUser;
  begin
   //ShowMessage('sdsds');
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try

     {FillChar(T,SizeOf(T),0);
     _GetInfoConnectUser(@T);
     dt:=_GetDateTimeFromServer;
      }
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Select count(*) as ctn from '+tbPms_Premises_Advertisment+' where Pms_Premises_id='+
            Mainqr.FieldByName('Pms_Premises_id').asString+
           ' and pms_agent_id='+
           Mainqr.FieldByName('pms_agent_id').asString;
     qr.sql.Text:=sqls;
     qr.Open;
     //qr.Transaction.Commit;
     qr.First;
     if qr.FieldByName('ctn').asString<>'0' then btAdvertisment.Click ;
   //  ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;
  end;

{by BARt}


end.
