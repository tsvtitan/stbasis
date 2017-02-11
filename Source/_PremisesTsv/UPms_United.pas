unit UPms_United;

interface

{$I stbasis.inc}

uses Classes;

var
  cnppNN,cnppWaterName,cnppHeatName,cnppStyleName,
  cnppDateArrivals,cnppRegionName,{}cnppCityRegionName{},cnppStreetName,cnppHouseNumber,cnppApartmentNumber,
  cnppCountRoomName,cnppTypeRoomName,cnppPlanningName,cnppPhoneName,cnppSaleStatusName,
  cnppDocumentName,cnppFloor,cnppCountFloor,cnppTypeHouseName,cnppGeneralArea,
  cnppDwellingArea,cnppgroundArea,
  cnppKitchenArea,cnppBalconyName,cnppConditionName,cnppStoveName,cnppSanitaryNodeName,
  cnppSelfFormName,cnppTypePremises,cnppPrice,cnppUnitPriceName,cnppNote,{by BART} cnppAdvertismentNote {by BART},cnppContact,
  cnppClientInfo,cnppAgentName,cnppStationName,cnppDateTimeInsert,cnppWhoInsertName,
  cnppDateTimeUpdate,cnppWhoUpdateName,cnppDateRecyledOut,cnppFurnitureName,cnppTerm,
  cnppPayment,cnppTypePremisesname,cnppDoorName,cnppPriceUnitPrice,cnppContactClientInfo,
  cnppFloorCountFloorTypeHouseName,cnppGeneralDwellingKitchenArea,cnppPaymentTerm,
  cnppBuilderName,cnppDelivery,cnppPrice2, cnppDecoration,cnppGlassy,cnppBlockSection


  : Integer;

  function GetColumnPremisesName(Index: Integer): string;


implementation

var
  ColumnsPremises: TStringList;

  function GetColumnPremisesName(Index: Integer): string;
  begin
    Result:='';
    if (Index>=0)or(Index<=ColumnsPremises.Count-1) then
      Result:=ColumnsPremises.Strings[Index];
  end;

  function AddToColumnsPremises(Name: String): Integer;
  begin
    Result:=ColumnsPremises.Add(Name);
  end;


initialization
  ColumnsPremises:=TStringList.Create;
  cnppDateArrivals:=AddToColumnsPremises('Дата поступления');
  cnppRegionName:=AddToColumnsPremises('Район');
 {by BART} cnppCityRegionName:=AddToColumnsPremises('Район города');  {byBaRT}
  cnppStreetName:=AddToColumnsPremises('Улица');
  cnppHouseNumber:=AddToColumnsPremises('Дом');
  cnppApartmentNumber:=AddToColumnsPremises('Квартира');
  cnppCountRoomName:=AddToColumnsPremises('Количество комнат');
  cnppTypeRoomName:=AddToColumnsPremises('Тип комнат');
  cnppPlanningName:=AddToColumnsPremises('Планировка');
  cnppPhoneName:=AddToColumnsPremises('Телефон');
  cnppSaleStatusName:=AddToColumnsPremises('Статус продажи');
  cnppDocumentName:=AddToColumnsPremises('Документы');
  cnppFloor:=AddToColumnsPremises('Этаж');
  cnppCountFloor:=AddToColumnsPremises('Этажность');
  cnppTypeHouseName:=AddToColumnsPremises('Тип дома');
  cnppGeneralArea:=AddToColumnsPremises('Общая площадь');
  cnppDwellingArea:=AddToColumnsPremises('Жилая площадь');
  cnppKitchenArea:=AddToColumnsPremises('Площадь кухни');
  cnppBalconyName:=AddToColumnsPremises('Балкон');
  cnppConditionName:=AddToColumnsPremises('Ремонт');
  cnppStoveName:=AddToColumnsPremises('Плита');
  cnppSanitaryNodeName:=AddToColumnsPremises('Санузел');
  cnppSelfFormName:=AddToColumnsPremises('Форма собственности');
  cnppTypePremises:=AddToColumnsPremises('Тип недвижимости');
  cnppPrice:=AddToColumnsPremises('Цена');
  cnppUnitPriceName:=AddToColumnsPremises('Единица измерения цены');
  cnppNote:=AddToColumnsPremises('Примечание');
  cnppAdvertismentNote:=AddToColumnsPremises('Примечание для рекламы');
  cnppContact:=AddToColumnsPremises('Контакт');
  cnppClientInfo:=AddToColumnsPremises('Клиент');
  cnppAgentName:=AddToColumnsPremises('Агент');
  cnppStationName:=AddToColumnsPremises('Статус временный');
  cnppDateTimeInsert:=AddToColumnsPremises('Дата и время ввода');
  cnppWhoInsertName:=AddToColumnsPremises('Кто ввел');
  cnppDateTimeUpdate:=AddToColumnsPremises('Дата и время изменения');
  cnppWhoUpdateName:=AddToColumnsPremises('Кто изменил');
  cnppDateRecyledOut:=AddToColumnsPremises('Дата извлечения из корзины');
  cnppFurnitureName:=AddToColumnsPremises('Мебель');
  cnppTerm:=AddToColumnsPremises('Срок');
  cnppPayment:=AddToColumnsPremises('Оплата за');
  cnppTypePremisesname:=AddToColumnsPremises('Тип недвижимости');
  cnppDoorName:=AddToColumnsPremises('Дверь');
  cnppPriceUnitPrice:=AddToColumnsPremises('Цена и единица измерения');
  cnppContactClientInfo:=AddToColumnsPremises('Контакт и клиент');
  cnppFloorCountFloorTypeHouseName:=AddToColumnsPremises('Этаж/Этажность Тип дома');
  cnppGeneralDwellingKitchenArea:=AddToColumnsPremises('Площадь Общая/Жилая/Кухни');
  cnppPaymentTerm:=AddToColumnsPremises('Оплата за/Срок');
  cnppNN:=AddToColumnsPremises('№№');
  cnppgroundArea:=AddToColumnsPremises('Площадь зем.участка');
  cnppWaterName:=AddToColumnsPremises('Водоснабжение');
  cnppHeatName:=AddToColumnsPremises('Отопление');
  cnppStyleName:=AddToColumnsPremises('Стиль');
  cnppBuilderName:=AddToColumnsPremises('Застройщик');
  cnppDelivery:=AddToColumnsPremises('Сдача');
  cnppPrice2:=AddToColumnsPremises('Цена за м2');
  cnppDecoration:=AddToColumnsPremises('Отделка');
  cnppGlassy:=AddToColumnsPremises('Остекление');
  cnppBlockSection:=AddToColumnsPremises('Блок секция');

finalization
  ColumnsPremises.Free;

end.
