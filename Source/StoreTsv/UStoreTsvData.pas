unit UStoreTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls;

var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  ListInterfaceHandles: TList;
  ListMenuHandles: Tlist;
  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  TempStr: String;
  IniStr: String;
  MainTypeLib: TTypeLib=ttleDefault;

  // Handles

  hInterfaceRbkUnitOfMeasure: THandle;
  hInterfaceRbkTypeOfPrice: THandle;
  hInterfaceRbkGTD: THandle;
  hInterfaceRbkNomenclatureGroup: THandle;
  hInterfaceRbkNomenclature: THandle;
  hInterfaceRbkNomenclatureTypeOfPrice: THandle;
  hInterfaceRbkNomenclatureUnitOfMeasure: THandle;
  hInterfaceRbkNomenclatureProperties: THandle;

  hMenuRBooks: THandle;
  hMenuStore: THandle;
  hMenuRbkUnitOfMeasure: THandle;
  hMenuRbkTypeOfPrice: THandle;
  hMenuRbkGTD: THandle;
  hMenuRbkNomenclatureGroup: THandle;
  hMenuRbkNomenclature: THandle;

  hToolButtonRbkUnitOfMeasure: THandle;
  hToolButtonRbkNomenclatureGroup: THandle;
  hToolButtonRbkNomenclature: THandle;

const
  LibraryHint='Библиотека содержит справочники и отчеты необходимые для склада.';

  // Names

  NameRbkUnitOfMeasure='Справочник единиц измерений';
  NameRbkTypeOfPrice='Справочник типов цен';
  NameRbkGTD='Справочник ГТД';
  NameRbkNomenclatureGroup='Справочник групп номенклатуры';
  NameRbkNomenclature='Справочник номенклатуры';
  NameRbkCountry='Справочник стран';
  NameRbkConsts='Справочник констант';
  NameRbkNomenclatureProperties='Справочник значений свойств номенклатуры';
  NameRbkNomenclatureUnitOfMeasure='Справочник единиц измерения номенклатуры';
  NameRbkNomenclatureTypeOfPrice='Справочник цен номенклатуры';
  NameRbkValueProperties='Справочник значений свойств';
  NameRbkCurrency='Справочник валют';

  // DBObjects

  tbUnitOfMeasure='Unitofmeasure';
  tbTypeOfPrice='TypeOfPrice';
  tbGTD='GTD';
  tbNomenclatureGroup='NomenclatureGroup';
  tbNomenclature='Nomenclature';
  tbCountry='Country';
  tbNomenclatureValueProperties='NomenclatureValueProperties';
  tbValueProperties='ValueProperties';
  tbProperties='Properties';
  tbNomenclatureUnitOfMeasure='NomenclatureUnitOfMeasure';
  tbNomenclatureTypeOfPrice='NomenclatureTypeOfPrice';
  tbCurrency='Currency';

  SQLRbkUnitOfMeasure='Select * from '+tbUnitOfMeasure+' ';
  SQLRbkTypeOfPrice='Select * from '+tbTypeOfPrice+' ';
  SQLRbkGTD='Select * from '+tbGTD+' ';
  SQLRbkNomenclatureGroup='Select * from '+tbNomenclatureGroup+' ';
  SQLRbkNomenclature='Select n.*, c.name as countryname, g.num as gtdnum, ng.name as nomenclaturegroupname from '+
                     tbNomenclature+' n join '+
                     tbNomenclatureGroup+' ng on n.nomenclaturegroup_id=ng.nomenclaturegroup_id join '+
                     tbCountry+' c on n.country_id=c.country_id left join '+
                     tbGTD+' g on n.gtd_id=g.gtd_id ';
  SQLRbkNomenclatureProperties='Select nvp.*,vp.valueproperties as valueproperties,p.nameproperties as nameproperties from '+
                               tbNomenclatureValueProperties+' nvp join '+
                               tbValueProperties+' vp on nvp.valueproperties_id=vp.valueproperties_id join '+
                               tbProperties+' p on vp.properties_id=p.properties_id ';
  SQLRbkNomenclatureUnitOfMeasure='Select nm.*,um.name as unitofmeasurename from '+
                                  tbNomenclatureUnitOfMeasure+' nm join '+
                                  tbUnitOfMeasure+' um on nm.unitofmeasure_id=um.unitofmeasure_id ';
  SQLRbkNomenclatureTypeOfPrice='Select ntp.*,tp.name as typeofpricename, um.name as unitofmeasurename,'+
                                 'c.name as currencyname from '+
                                 tbNomenclatureTypeOfPrice+' ntp join '+
                                 tbTypeOfPrice+' tp on ntp.typeofprice_id=tp.typeofprice_id join '+
                                 tbUnitOfMeasure+' um on ntp.unitofmeasure_id=um.unitofmeasure_id join '+
                                 tbCurrency+' c on ntp.currency_id=c.currency_id ';


implementation

end.
