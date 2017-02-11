unit UTaxesVAVData;

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

  hInterfaceRbkTaxesType: THandle;
  hInterfaceRbkTreeTaxes: THandle;
  hInterfaceRbkLinkSummPercent: THandle;

  hMenuRBooks: THandle;
  hMenuTaxes: THandle;

  hMenuRbkTaxesType: THandle;
  hMenuRbkLinkSummPercent: THandle;
  hMenuRbkTreeTaxes: THandle;

  hToolButtonRbkLinkSummPercent: THandle;
  hToolButtonRbkTaxesType: THandle;
  hToolButtonRbkTreeTaxes: THandle;


const
  LibraryHint='Библиотека содержит справочники налогов';

  // Names

  NameRbkTaxesType='Справочник видов налогов';
  NameRbkLinkSummPercent='Справочник соотношений сумма-процент налога';
  NameRbkTreeTaxes='Справочник зависимостей налогов';
  NameRbkStandartOperation='Справочник cстандартных операций';  

  // DBObjects

  tbTaxesType='TaxesType';
  tbLinkSummPercent='LinkSummPercent';
  tbTreeTaxes='TreeTaxes';


  SQLRbkTaxesType='Select * from '+tbTaxesType+' ';

  SQLRbkLinkSummPercent='Select v.*, pr.nameproperties, pr.properties_id  from '+tbLinkSummPercent+' lsp ' +
                        ' left join ' +tbTaxesType+' tt on lsp.TaxesType_id=tt.TaxesType_id';

  SQLRbkTreeTaxes='select p.* , pr.nameproperties, pr.properties_id from ' +tbTreeTaxes +' tt' +
                   ' left join ' +tbTreeTaxes+' t on t.parent_id=tt.TreeTaxes_id';


implementation

end.
