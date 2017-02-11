unit UDocTurnTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls;

type
   PTempDocumRecord=^TTempDocumRecord;
   TTempDocumRecord=packed record
     hInterface: THandle;
     InterfaceName: String;
     hMenu: THandle;
     TypeDocId: Integer;
   end;
  
var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  ListInterfaceHandles: TList;
  ListMenuHandles: Tlist;
  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListMenuDocums: TList;
  ListDocums: TList;

  TempStr: String;
  IniStr: String;
  MainTypeLib: TTypeLib=ttleDefault;

  // Handles

  hInterfaceRbkTypeDoc: THandle;
  hInterfaceRbkBasisTypeDoc: THandle;
  hInterfaceJrDocum: THandle;
  hInterfaceDocWarrantHead: THandle;
  hInterfaceDocWarrantRecord: THandle;


  hMenuRBooks: THandle;
  hMenuDocTurn: THandle;
  hMenuRbkTypeDoc: THandle;
  hMenuRbkBasisTypeDoc: THandle;
  hMenuJournals: THandle;
  hMenuJrDocum: THandle;
  hMenuDocs: THandle;

  hToolButtonJrDocum: THandle;
{  hToolButtonRbkNomenclatureGroup: THandle;
  hToolButtonRbkNomenclature: THandle;}



const
  LibraryHint='Библиотека содержит справочники и отчеты необходимые для документооборота.';

  // Names

  NameRbkQuery='Запрос';
  NameRbkConsts='Справочник констант';
  NameRbkTypeDoc='Справочник видов документов';
  NameJrDocum='Журнал документов';
  NameRbkBasisTypeDoc='Справочник оснований вида документа';
  NameDocWarrantHead='Документ доверенность';
  NameDocWarrantRecord='Документ доверенность (строки)';
  NameRbkPlant='Справочник контрагентов';
  NameRbkRespondents='Справочник материально-ответственных лиц';
  NameRbkNomenclature='Справочник номенклатуры';
  NameRbkUnitOfMeasure='Справочник единиц измерений';
  NameRptWarrant='Отчет доверенность';

  // DBObjects

  tbTypeDoc='TypeDoc';
  tbDocum='Docum';
  tbBasisTypeDoc='BasisTypeDoc';
  tbRespondents='Respondents';
  tbPlant='Plant';
  tbUnitOfMeasure='UnitOfMeasure';
  tbNomenclature='Nomenclature';
  tbWarrantHead='WarrantHead';
  tbWarrantRecord='WarrantRecord';


  // SQL

  SQLRbkTypeDoc='Select * from '+tbTypeDoc+' ';
  SQLJrDocum='Select d.prefix||d.num||d.sufix as prefixnumsufix,d.*,td.name as typedocname,td.sign as sign,'+
             'td.interfacename as interfacename from '+
             tbDocum+' d join '+
             tbTypeDoc+' td on d.typedoc_id=td.typedoc_id ';
  SQLRbkBasisTypeDoc='Select btd.*, td1.name as fortypedocname, td2.name as whattypedocname from '+
                     tbBasisTypeDoc+' btd join '+
                     tbTypeDoc+' td1 on btd.fortypedoc_id=td1.typedoc_id join '+
                     tbTypeDoc+' td2 on btd.whattypedoc_id=td2.typedoc_id';
  SQLDocWarrantHead='Select wh.*, p1.smallname as granteesmallname, p2.smallname as suppliersmallname,'+
                    'r.fname||'' ''||r.name||'' ''||r.sname as respondentsname,d.prefix||'+
                    'd.num||d.sufix as basedocumnum,d.datedoc as basedocumdatedoc,td.name as basedocumtypedocname from '+
                    tbWarrantHead+' wh join '+
                    tbPlant+' p1 on wh.grantee_id=p1.plant_id join '+
                    tbPlant+' p2 on wh.supplier_id=p2.plant_id join '+
                    tbRespondents+' r on wh.respondents_id=r.respondents_id left join '+
                    tbDocum+' d on wh.basedocum_id=d.docum_id left join '+
                    tbTypeDoc+' td on d.typedoc_id=td.typedoc_id';
  SQLDocWarrantRecord='Select wr.*, n.name as nomenclaturename, um.name as unitofmeasurename from '+
                      tbWarrantRecord+' wr join '+
                      tbNomenclature+' n on wr.nomenclature_id=n.nomenclature_id join '+
                      tbUnitOfMeasure+' um on wr.unitofmeasure_id=um.unitofmeasure_id ';


implementation

end.
