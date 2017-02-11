unit UPremisesTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls,
     tsvSecurity;

var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  TempStr: String;
  IniStr: String;
  MainTypeLib: TTypeLib=ttleDefault;
  FSecurity: TTsvSecurity;

  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListInterfaceHandles: TList;
  ListMenuHandles: TList;

  SQLRbkPms_Premises: string='';
  SQLRbkPms_PremisesRpt: string='';

  // handles

  hInterfaceRbkPms_Street: Thandle;
  hInterfaceRbkPms_Region: Thandle;
  hInterfaceRbkPms_Balcony: Thandle;
  hInterfaceRbkPms_Condition: Thandle;
  hInterfaceRbkPms_SanitaryNode: Thandle;
  hInterfaceRbkPms_Heat: Thandle;
  hInterfaceRbkPms_Water: Thandle;
  hInterfaceRbkPms_Builder: Thandle;
  hInterfaceRbkPms_Investor: Thandle;
  hInterfaceRbkPms_Style: Thandle;
  hInterfaceRbkPms_CountRoom: Thandle;
  hInterfaceRbkPms_TypeRoom: Thandle;
  hInterfaceRbkPms_Station: Thandle;
  hInterfaceRbkPms_TypeHouse: Thandle;
  hInterfaceRbkPms_Stove: Thandle;
  hInterfaceRbkPms_Furniture: Thandle;
  //----------------------------------------------
  hInterfaceRbkPms_Advertisment: Thandle;
  hInterfaceRbkPms_Premises_Advertisment: Thandle;
  hInterfaceRbkPms_City_Region: Thandle;
  hInterfaceRbkPms_Regions_Correspond: Thandle;
  hInterfaceRbkPms_Direction_Correspond: Thandle;
  hInterfaceRbkPms_Taxes: Thandle;
{  hInterfaceRbkPms_AreaBuilding: Thandle;
 } hInterfaceRbkPms_PopulatedPoint: Thandle;
  hInterfaceRbkPms_LandFeature: Thandle;
  hInterfaceRbkPms_ExchangeFormula: Thandle;
  hInterfaceRbkPms_LocationStatus: Thandle;
 { hInterfaceRbkPms_LandMark: Thandle;
  }hInterfaceRbkPms_Object: Thandle;
  hInterfaceRbkPms_Direction: Thandle;
  hInterfaceRbkPms_AccessWays: Thandle;



  //-------------------------------------------------
  hInterfaceRbkPms_Door: Thandle;
  hInterfaceRbkPms_Agent: Thandle;
  hInterfaceRbkPms_Planning: Thandle;
  hInterfaceRbkPms_Phone: Thandle;
  hInterfaceRbkPms_Document: Thandle;
  hInterfaceRbkPms_Premises: Thandle;
  hInterfaceRbkPms_SaleStatus: Thandle;
  hInterfaceRbkPms_TypePremises: Thandle;
  hInterfaceRbkPms_SelfForm: Thandle;
  hInterfaceRbkPms_Perm: Thandle;
  hInterfaceRbkPms_UnitPrice: Thandle;
  hInterfaceRbkPms_Image: Thandle;
  hInterfaceRptPms_Price: Thandle;
  hInterfaceSrvPms_ImportPrice: Thandle;

  hMenuRBooks: THandle;
  hMenuRBooksPms_Street: Thandle;
  hMenuRBooksPms_Region: Thandle;
  hMenuRBooksPms_Balcony: Thandle;
  hMenuRBooksPms_Condition: Thandle;
  hMenuRBooksPms_SanitaryNode: Thandle;
  hMenuRBooksPms_Heat: Thandle;
  hMenuRBooksPms_Water: Thandle;
  hMenuRBooksPms_Builder: Thandle;
  hMenuRBooksPms_Investor: Thandle;
  hMenuRBooksPms_Style: Thandle;
  hMenuRBooksPms_CountRoom: Thandle;
  hMenuRBooksPms_TypeRoom: Thandle;
  hMenuRBooksPms_Station: Thandle;
  hMenuRBooksPms_TypeHouse: Thandle;
  hMenuRBooksPms_Stove: Thandle;
  hMenuRBooksPms_Furniture: Thandle;
  //--------------------
  hMenuRBooksPms_Advertisment: Thandle;
  hMenuRBooksPms_Premises_Advertisment: Thandle;
  hMenuRBooksPms_City_Region: Thandle;
  hMenuRBooksPms_Regions_Correspond: Thandle;
  hMenuRBooksPms_Direction_Correspond: Thandle;
  hMenuRBooksPms_Taxes: Thandle;

 { hMenuRBooksPms_AreaBuilding: Thandle;
  }hMenuRBooksPms_PopulatedPoint: Thandle;
  hMenuRBooksPms_LandFeature: Thandle;
  hMenuRBooksPms_ExchangeFormula: Thandle;
  hMenuRBooksPms_LocationStatus: Thandle;
 { hMenuRBooksPms_LandMark: Thandle;
  }hMenuRBooksPms_Object: Thandle;
  hMenuRBooksPms_Direction: Thandle;
  hMenuRBooksPms_AccessWays: Thandle;


  //-----------------------
  hMenuRBooksPms_Door: Thandle;
  hMenuRBooksPms_Agent: Thandle;
  hMenuRBooksPms_Planning: Thandle;
  hMenuRBooksPms_Phone: Thandle;
  hMenuRBooksPms_Document: Thandle;
  hMenuData: THandle;
  hMenuRBooksPms_Premises: Thandle;
  hMenuRBooksPms_SaleStatus: Thandle;
  hMenuRBooksPms_TypePremises: Thandle;
  hMenuRBooksPms_SelfForm: Thandle;
  hMenuRBooksPms_Perm: Thandle;
  hMenuRBooksPms_UnitPrice: Thandle;
  hMenuRBooksPms_Image: Thandle;
  hMenuReports: THandle;
  hMenuReportPms_Price: Thandle;
  hMenuOperations: THandle;
  hMenuOperationPms_ImportPrice: Thandle;
  hMenuHelps: THandle;
  hMenuHelpPremises: THandle;

  hOptionData: THandle;
  hOptionPremises: THandle;
  hOptionReport: THandle;
  hOptionRptPrice: THandle;
  hOptionOperation: THandle;
  hOptionImport: THandle;

const
  SKey='283B2F91F9806887249FE8C7B6B65782'; // Premises

  LibraryHint='Библиотека содержит справочники, отчеты и сервисы для приложения недвижимость.';
  LibraryCondition='Ограничений нет.';
  LibraryProgrammers='Томилов Сергей';

  ConstSelectDir='Выберите директорию';
  ConstVersionCondition_V1=1;
  ConstDelimStation=';';
  ConstDelimColumn=';';
  ConstFileNameHelp='help.doc';

  // Sections
  ConstSectionOptions='PremisesTsvOptions';

  // Reports Consts

  // Ext
  ConstExtExcel='.xls';
  dfeXML='.xml';

  // Filters
  fltXML='Файлы XML (*.xml)|*.xml';

  // ResTypes

  ConstResTypeReport='REPORT';
  ConstResTypeColumn='COLUMN';

  // ResNames

  ConstResNamePms_Price_SaleClient='PMS_PRICE_SALECLIENT';
  ConstResNamePms_Price_SaleAgent='PMS_PRICE_SALEAGENT';
  ConstResNamePms_Price_SaleInspector='PMS_PRICE_SALEINSPECTOR';
  ConstResNamePms_Price_LeaseClient='PMS_PRICE_LEASECLIENT';
  ConstResNamePms_Price_LeaseAgent='PMS_PRICE_LEASEAGENT';
  ConstResNamePms_Price_LeaseAgent2='PMS_PRICE_LEASEAGENT2';
  ConstResNamePms_Price_LeaseInspector1='PMS_PRICE_LEASEINSPECTOR1';
  ConstResNamePms_Price_LeaseInspector2='PMS_PRICE_LEASEINSPECTOR2';
  ConstResNamePms_Price_ShareClient='PMS_PRICE_SHARECLIENT';
  ConstResNamePms_Price_ShareAgent='PMS_PRICE_SHAREAGENT';
  ConstResNamePms_Price_ShareInspector='PMS_PRICE_SHAREINSPECTOR';
  ConstResNamePms_Price_ShareAgent2='PMS_PRICE_SHAREAGENT2';
  ConstResNamePms_Price_ShareInspector2='PMS_PRICE_SHAREINSPECTOR2';
  ConstResNamePms_Price_ShareClient2='PMS_PRICE_SHARECLIENT2';
  ConstResNamePms_Price_ShareClient3='PMS_PRICE_SHARECLIENT3';
  ConstResNamePms_Price_LandClient='PMS_PRICE_LANDCLIENT';
  ConstResNamePms_Price_LandClient1='PMS_PRICE_LANDCLIENT1';
  ConstResNamePms_Price_LandAgent='PMS_PRICE_LANDAGENT';

  // Formats

  fmtCurDate='dd.mm.yyyy';
  fmtSmallDate='dd.mm.yy';
  fmtPerm='%s (%s)';
  fmtImportCount='Всего импортировано: %d записи(ей)';
  fmtImportFieldRequired='Поле <%s> должно быть заполнено';
  fmtBadFieldType='Поле <%s> имеет неверный тип';
  fmtLoadPriceError='%s, значение <%s>';

  // Interface Names

  NameRbkConst='Справочник констант';
  NameRbkQuery='Запрос';
  NameRbkPms_Street='Справочник улиц';
  NameRbkPms_Region='Справочник районов';
  NameRbkPms_Balcony='Справочник видов балкона';
  NameRbkPms_Condition='Справочник состояний';
  NameRbkPms_SanitaryNode='Справочник типов санузла';
  NameRbkPms_Heat='Справочник отоплений';
  NameRbkPms_CountRoom='Справочник количества комнат';
  NameRbkPms_TypeRoom='Справочник типов комнат';
  NameRbkPms_Station='Справочник статусов квартиры';
  NameRbkPms_TypeHouse='Справочник типов дома';
  NameRbkPms_Stove='Справочник видов плит';
  NameRbkPms_Furniture='Справочник видов мебели';
  //----------------------
  NameRbkPms_Advertisment='Справочник рекламы';
  NameRbkPms_Premises_Advertisment='Справочник рекламы недвижимости';
  NameRbkPms_City_Region='Справочник районов города';
  NameRbkPms_Regions_Correspond='Справочник районов и подрайонов города';
  NameRbkPms_Direction_Correspond='Справочник районов и направлений';

  NameRbkPms_Taxes='Справочник налог';
{  NameRbkPms_AreaBuilding='Справочник зем. построек';
}  NameRbkPms_PopulatedPoint='Справочник населенный пункт';
  NameRbkPms_LandFeature='Справочник зем. хар.(Назначение)';
  NameRbkPms_ExchangeFormula='Справочник Формул обмена';
  NameRbkPms_LocationStatus='Справочник статусов расположения';
 { NameRbkPms_LandMark='Справочник ориентиров';
  }NameRbkPms_Object='Справочник объектов';
  NameRbkPms_Direction='Справочник направлений';
  NameRbkPms_AccessWays='Справочник подъездных путей';

  //----------------------
  NameRbkPms_Door='Справочник видов дверей';
  NameRbkPms_Agent='Справочник агентов';
  NameRbkPms_Planning='Справочник планировок';
  NameRbkPms_Phone='Справочник видов телефона';
  NameRbkPms_Document='Справочник видов документа';
  NameRbkPms_Premises='Недвижимость';
  NameRbkPms_SaleStatus='Справочник статусов продажи';
  NameRbkPms_TypePremises='Справочник типов недвижимости';
  NameRbkPms_SelfForm='Справочник форм собственности';
  NameRbkPms_Perm='Справочник прав на операции';
  NameRbkUser='Справочник пользователей';
  NameRptPms_Price='Прайс';
  NameSrvPms_ImportPrice='Импорт прайса';
  NameRbkPms_UnitPrice='Справочник единиц измерения цены';
  NameRbkSync_Office='Справочник офисов синхронизации';
  NameRbkPms_Water='Справочник водоснабжений';
  NameRbkPms_Builder='Справочник застройщиков';
  NameRbkPms_Investor='Справочник инвесторов';
  NameRbkPms_Style='Справочник стилей';
  NameRbkPms_Image='Изображения домов';

  // Db Objects


  tbPms_Street='pms_street';
  tbPms_Region='Pms_Region';
  tbPms_Balcony='Pms_Balcony';
  tbPms_Condition='Pms_Condition';
  tbPms_SanitaryNode='Pms_SanitaryNode';
  tbPms_CountRoom='Pms_CountRoom';
  tbPms_TypeRoom='Pms_TypeRoom';
  tbPms_Station='Pms_Station';
  tbPms_TypeHouse='Pms_TypeHouse';
  tbPms_Stove='Pms_Stove';
  tbPms_Furniture='Pms_Furniture';
  //-----------
  tbPms_Advertisment='Pms_Advertisment';
  tbPms_Premises_Advertisment='Pms_Premises_Advertisment';
  tbPms_City_Region='Pms_City_Region';
  tbPms_Regions_Correspond='Pms_Regions_Correspond';
  tbPms_Direction_Correspond='Pms_Direction_Correspond';

  tbPms_Taxes='Pms_Taxes';

{  tbPms_AreaBuilding='Pms_AreaBuilding';
 } tbPms_PopulatedPoint='Pms_PopulatedPoint';
  tbPms_LandFeature='Pms_LandFeature';
  tbPms_ExchangeFormula='Pms_ExchangeFormula';
  tbPms_LocationStatus='Pms_LocationStatus';
{  tbPms_LandMark='Pms_LandMark';
 } tbPms_Object='Pms_Object';
  tbPms_Direction='Pms_Direction';
  tbPms_AccessWays='Pms_AccessWays';


  //-----------
  tbPms_Door='Pms_Door';
  tbPms_Agent='Pms_Agent';
  tbPms_Planning='Pms_Planning';
  tbPms_Phone='Pms_Phone';
  tbPms_Document='Pms_Document';
  tbPms_Premises='Pms_Premises';
  tbUsers='users';
  tbPms_SaleStatus='Pms_SaleStatus';
  tbPms_TypePremises='Pms_TypePremises';
  tbPms_SelfForm='Pms_SelfForm';
  tbPms_Perm='Pms_Perm';
  tbConst='constex';
  tbPms_UnitPrice='Pms_UnitPrice';
  tbSync_Office='sync_office';
  tbPms_Water='Pms_Water';
  tbPms_Builder='Pms_Builder';
  tbPms_Investor='Pms_Investor';
  tbPms_Heat='Pms_Heat';
  tbPms_Style='Pms_Style';
  tbPms_Image='Pms_Image';

  genCheckPremises='Check_Premises';

  // Sqls

  SQLRbkPms_Street='Select * from '+tbPms_Street+' ';
  SQLRbkPms_Region='Select * from '+tbPms_Region+' ';
  SQLRbkPms_Balcony='Select * from '+tbPms_Balcony+' ';
  SQLRbkPms_Condition='Select * from '+tbPms_Condition+' ';
  SQLRbkPms_SanitaryNode='Select * from '+tbPms_SanitaryNode+' ';
  SQLRbkPms_Heat='Select * from '+tbPms_Heat+' ';
  SQLRbkPms_Water='Select * from '+tbPms_Water+' ';
  SQLRbkPms_Builder='Select * from '+tbPms_Builder+' ';
  SQLRbkPms_Investor='Select * from '+tbPms_Investor+' ';
  SQLRbkPms_Style='Select * from '+tbPms_Style+' ';
  SQLRbkPms_CountRoom='Select * from '+tbPms_CountRoom+' ';
  SQLRbkPms_TypeRoom='Select * from '+tbPms_TypeRoom+' ';
  SQLRbkPms_Station='Select * from '+tbPms_Station+' ';
  SQLRbkPms_TypeHouse='Select * from '+tbPms_TypeHouse+' ';
  SQLRbkPms_Stove='Select * from '+tbPms_Stove+' ';
  SQLRbkPms_Furniture='Select * from '+tbPms_Furniture+' ';
 //-----------
  SQLRbkPms_Advertisment='Select * from '+tbPms_Advertisment+' ';
  SQLRbkPms_Premises_Advertisment='Select ppa.*'+
                        ', pa.name as advertisment_name, '+
                        '  pag.name as agent_name,  '+
                        '  p.pms_premises_id as premises_id from '+
                        tbPms_Premises_Advertisment+' ppa join '+
                        tbPms_Advertisment+' pa on pa.pms_advertisment_id=ppa.pms_advertisment_id join '+
                        tbPms_Agent+' pag on pag.pms_agent_id=ppa.pms_agent_id join '+
                        tbPms_Premises+' p on p.pms_premises_id=ppa.pms_premises_id ';
  {SQLRbkSync_OfficePackage='Select sop.*, so.name as office_name, sp.name as package_name from '+
                            tbSync_OfficePackage+' sop join '+
                            tbSync_Office+' so on so.sync_office_id=sop.sync_office_id join '+
                            tbSync_Package+' sp on sp.sync_package_id=sop.sync_package_id ';
   }
   SQLRbkPms_City_Region='Select * from '+tbPms_City_Region+' ';
   SQLRbkPms_Regions_Correspond='Select PRC.*, '+
                                ' PCR.NAME as CITY_REGION,'+
                                ' PR.NAME as REGION from '+
                                tbPms_Regions_Correspond+' PRC join '+
                                tbPms_City_Region+' PCR on PCR.pms_city_region_id=PRC.pms_city_region_id join '+
                                tbPms_Region+' PR on PR.pms_region_id=PRC.pms_region_id ';
   SQLRbkPms_Direction_Correspond='Select PDC.*, '+
                                ' PCR.NAME as CITY_REGION,'+
                                ' DR.NAME as DIRECTION from '+
                                tbPms_Direction_Correspond+' PDC join '+
                                tbPms_City_Region+' PCR on PCR.pms_city_region_id=PDC.pms_city_region_id join '+
                                tbPms_Direction+' DR on DR.pms_direction_id=PDC.pms_direction_id ';
  SQLRbkPms_Taxes='Select * from '+tbPms_Taxes+' ';

 { SQLRbkPms_AreaBuilding='Select * from '+tbPms_AreaBuilding+' ';
  }SQLRbkPms_PopulatedPoint='Select * from '+tbPms_PopulatedPoint+' ';
  SQLRbkPms_LandFeature='Select * from '+tbPms_LandFeature+' ';
  SQLRbkPms_ExchangeFormula='Select * from '+tbPms_ExchangeFormula+' ';
  SQLRbkPms_LocationStatus='Select * from '+tbPms_LocationStatus+' ';
 { SQLRbkPms_LandMark='Select * from '+tbPms_LandMark+' ';
  }
  SQLRbkPms_Object='Select * from '+tbPms_Object+' ';
  SQLRbkPms_Direction='Select * from '+tbPms_Direction+' ';
  SQLRbkPms_AccessWays='Select * from '+tbPms_AccessWays+' ';


  //-----------
  SQLRbkPms_Door='Select * from '+tbPms_Door+' ';
  SQLRbkPms_Agent='Select a.*,so.name as office_name from '+
                  tbPms_Agent+' a join '+
                  tbSync_Office+' so on so.sync_office_id=a.sync_office_id ';
  SQLRbkPms_Image='Select i.*, s.name as street_name from '+
                  tbPms_Image+' i join '+
                  tbPms_Street+' s on s.pms_street_id=i.pms_street_id ';

  SQLRbkPms_Planning='Select * from '+tbPms_Planning+' ';
  SQLRbkPms_Phone='Select * from '+tbPms_Phone+' ';
  SQLRbkPms_Document='Select * from '+tbPms_Document+' ';
  SQLRbkPms_PremisesDf='Select p.*,'+
                       'r.name as regionname,'+
                       'crg.name as cityregionname,'+
                       's.name as streetname,'+
                       'cr.name as countroomname,'+
                       'u1.name as whoinsertname,'+
                       'u2.name as whoupdatename,'+
                       'a.name as agentname,'+
                       'a.sync_office_id as sync_office_id,'+
                       'b.name as balconyname,'+
                       'c.name as conditionname,'+
                       'sn.name as sanitarynodename,'+
                       'h.name as heatname,'+
                       'w.name as watername,'+
                       'sl.name as stylename,'+
                       'sl.style as stylestyle,'+
                       'd.name as doorname,'+
                       'tr.name as typeroomname,'+
                       'pl.name as planningname,'+
                       'st.name as stationname,'+
                       'th.name as typehousename,'+
                       'sv.name as stovename,'+
                       'f.name as furniturename,'+
                       'ph.name as phonename,'+
                       'ss.name as salestatusname,'+
                       'sf.name as selfformname,'+
                       'tp.name as typepremisesname,'+
                       'u.name as unitpricename,'+
                       'dc.name as documentname,'+
                       'bl.name as buildername,'+
                       //--------------1208byBart
                       'tx.name as taxes,'+
                       {'ab.name as areabuilding,'+
                       }'ppt.name as populatedpoint,'+
                       'lf.name as landfeature,'+
                       'ef.name as exchangeformula,'+
                       'ls.name as locationstatus,'+
                       {'lm.name as landmark, '+
                       }'obj.name as object,'+
                       'dir.name as direction,'+
                       'aw.name as accessways '+

                       //'adver.name as advername '+

                       //----------------
                       '%s'+
                       ' from '+
                       tbPms_Premises+' p join '+
                       tbPms_Region+' r on p.pms_region_id=r.pms_region_id join '+
                       tbPms_Street+' s on p.pms_street_id=s.pms_street_id join '+
                       tbUsers+' u1 on p.whoinsert_id=u1.user_id join '+
                       tbUsers+' u2 on p.whoupdate_id=u2.user_id join '+
                       tbPms_Agent+' a on p.pms_agent_id=a.pms_agent_id left join '+
                       tbPms_Balcony+' b on p.pms_balcony_id=b.pms_balcony_id left join '+
                       tbPms_Condition+' c on p.pms_condition_id=c.pms_condition_id left join '+
                       tbPms_SanitaryNode+' sn on p.pms_sanitarynode_id=sn.pms_sanitarynode_id left join '+
                       tbPms_Door+' d on p.pms_door_id=d.pms_door_id left join '+
                       tbPms_TypeRoom+' tr on p.pms_typeroom_id=tr.pms_typeroom_id left join '+
                       tbPms_Planning+' pl on p.pms_planning_id=pl.pms_planning_id left join '+
                       tbPms_Station+' st on p.pms_station_id=st.pms_station_id left join '+
                       tbPms_TypeHouse+' th on p.pms_typehouse_id=th.pms_typehouse_id left join '+
                       tbPms_Stove+' sv on p.pms_stove_id=sv.pms_stove_id left join '+
                       tbPms_Phone+' ph on p.pms_phone_id=ph.pms_phone_id left join '+
                       tbPms_Document+' dc on p.pms_document_id=dc.pms_document_id left join '+
                       tbPms_SaleStatus+' ss on p.pms_salestatus_id=ss.pms_salestatus_id left join '+
                       tbPms_SelfForm+' sf on p.pms_selfform_id=sf.pms_selfform_id left join '+
                       tbPms_TypePremises+' tp on p.pms_typepremises_id=tp.pms_typepremises_id left join '+
                       tbPms_Furniture+' f on p.pms_furniture_id=f.pms_furniture_id left join '+
                       tbPms_CountRoom+' cr on p.pms_countroom_id=cr.pms_countroom_id left join '+
                       //-----------------------------------
                       tbPms_UnitPrice+' u on p.pms_unitprice_id=u.pms_unitprice_id left join '+
                       tbPms_Water+' w on p.pms_water_id=w.pms_water_id left join '+
                       tbPms_Builder+' bl on p.pms_builder_id=bl.pms_builder_id left join '+
                       tbPms_Style+' sl on p.pms_style_id=sl.pms_style_id left join '+
                       tbPms_Heat+' h on p.pms_heat_id=h.pms_heat_id left join '+
                       tbPms_City_Region+' crg on p.pms_city_region_id=crg.pms_city_region_id left join '+
                       {tbPms_AreaBuilding+' ab on p.pms_areabuilding_id=ab.pms_areabuilding_id left join '+
                       }tbPms_PopulatedPoint+' ppt on p.pms_populatedpoint_id=ppt.pms_populatedpoint_id left join '+
                       tbPms_LandFeature+' lf on p.pms_landfeature_id=lf.pms_landfeature_id left join '+
                       tbPms_ExchangeFormula+' ef on p.pms_exchangeformula_id=ef.pms_exchangeformula_id left join '+
                       tbPms_LocationStatus+' ls on p.pms_locationstatus_id=ls.pms_locationstatus_id left join '+
                       {tbPms_LandMark+' lm on p.pms_landmark_id=lm.pms_landmark_id left join '+
                       }tbPms_Object+' obj on p.pms_object_id=obj.pms_object_id left join '+
                       tbPms_Direction+' dir on p.pms_direction_id=dir.pms_direction_id left join '+
                       tbPms_AccessWays+' aw on p.pms_accessways_id=aw.pms_accessways_id left join '+
                       
                       //tbPms_Advertisment+' adver on p.pms_premises_id=adver.pms_premises_id'
                       tbPms_Taxes+' tx on p.pms_taxes_id=tx.pms_taxes_id';


  SQLRbkPms_SaleStatus='Select * from '+tbPms_SaleStatus+' ';
  SQLRbkPms_TypePremises='Select * from '+tbPms_TypePremises+' ';
  SQLRbkPms_SelfForm='Select * from '+tbPms_SelfForm+' ';
  SQLRbkPms_Perm='Select p.*,u.name as username from '+tbPms_Perm+' p join '+
                 tbUsers+' u on p.user_id=u.user_id ';
  SQLRbkPms_UnitPrice='Select * from '+tbPms_UnitPrice+' ';
  SQLRbkSync_Office='Select * from '+tbSync_Office+' ';


implementation

uses SysUtils;

initialization
  FSecurity:=TTsvSecurity.Create;
  FSecurity.Key:=SKey;

  SQLRbkPms_Premises:=Format(SQLRbkPms_PremisesDf,[',price2,decoration,glassy,block_section']);
  SQLRbkPms_PremisesRpt:=Format(SQLRbkPms_PremisesDf,[',price2,decoration,glassy,block_section'+
                                                      ',(select agent_name from getfullagent(p.pms_premises_id,p.pms_agent_id)) as fullagent']);

finalization
  FSecurity.Free;


end.
