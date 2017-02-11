unit UStoreVAVData;

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

  hInterfaceRbkRespondents: THandle;
  hInterfaceRbkStoreType: THandle;
  hInterfaceRbkProperties: THandle;
  hInterfaceRbkValueProperties: THandle;
  hInterfaceRbkReasons: THandle;
  hInterfaceRbkStorePlace: THandle;

  hMenuRBooks: THandle;
  hMenuStore: THandle;

  hMenuRbkRespondents: THandle;
  hMenuRbkStoreType: THandle;
  hMenuRbkValueProperties: THandle;
  hMenuRbkProperties: THandle;
  hMenuRbkStorePlace: THandle;
  hMenuRbkReasons: THandle;

  hToolButtonRbkRespondents: THandle;
  hToolButtonRbkValueProperties: THandle;
  hToolButtonRbkStoreType: THandle;
  hToolButtonRbkProperties: THandle;
  hToolButtonRbkStorePlace: THandle;
  hToolButtonRbkReasons: THandle;


const
  LibraryHint='Библиотека содержит справочники и отчеты необходимые для склада.';

  // Names

  NameRbkRespondents='Справочник материально-ответственных лиц';
  NameRbkStoreType='Справочник видов мест хранений';
  NameRbkValueProperties='Справочник значений свойств';
  NameRbkProperties='Справочник свойств';
  NameRbkPersonDocType='Справочник видов документов удостоверяющих личность';
  NameRbkPlant='Справочник контрагентов';
  NameRbkStorePlace='Справочник мест хранения';
  NameRbkReasons='Справочник причин списания';

  // DBObjects

  tbRespondents='Respondents';
  tbStoreType='StoreType';
  tbValueProperties='ValueProperties';
  tbProperties='Properties';
  tbEmpPersonDoc='EmpPersonDoc';
  tbPERSONDOCTYPE='PERSONDOCTYPE';
  tbplant='plant';
  tbReasons='Reasons';
  tbStorePlace='StorePlace';

  SQLRbkRespondents='select r.*, p.name as docname,p.masknum,p.maskseries, p.maskpodrcode,pl.smallname from '+tbRespondents+' r '+
                    ' join '+tbPERSONDOCTYPE +' p on r.persondoctype_id=p.persondoctype_id '+
                    ' join '+tbplant+' pl on r.plant_id=pl.plant_id ';


  SQLRbkStoreType='Select * from '+tbStoreType+' ';

  SQLRbkValueProperties='Select v.*, pr.nameproperties, pr.properties_id  from '+tbValueProperties+' V ' +
                        ' left join ' +tbProperties +' pr on v.properties_id=pr.properties_id';

  SQLRbkProperties='select p.* , pr.nameproperties, pr.properties_id from ' +tbProperties +' p ' +
                   ' left join ' +tbProperties +' pr on p.parent_id=pr.properties_id';

  SQLRbkStorePlace='select sp.*, r.fname,r.name,r.sname,st.namestoretype,p.smallname from '+ tbstoreplace+' sp ' +
                   ' join '+tbrespondents +' r on r.respondents_id=sp.respondents_id' +
                   ' join '+tbstoretype+' st on st.storetype_id=sp.storetype_id' +
                   ' join '+tbplant+' p on p.plant_id=sp.plant_id';

  SQLRbkReasons='Select * from '+tbReasons+' ';

implementation

end.
