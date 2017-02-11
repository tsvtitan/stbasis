unit USickTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls;

var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  TempStr: String;
  IniStr: String;
  MainTypeLib: TTypeLib=ttleDefault;
  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListInterfaceHandles: TList;
  ListMenuHandles: TList;

  // handles

  hInterfaceRbkSick: Thandle;
  hInterfaceRbkSickGroup: THandle;

  hMenuRBooks: THandle;
  hMenuRBooksSick: Thandle;
  hMenuRBooksSickGroup: Thandle;

const
  LibraryHint='Вспомогательная библиотека.';
  LibraryProgrammers='Томилов Сергей';

  // Reports Consts

  // Formats

  // Interface Names

  NameRbkSick='Справочник болезней';
  NameRbkSickGroup='Справочник групп болезней';


  // Db Objects

  tbSick='sick';
  tbSickGroup='sickgroup';

  prCreateSickGroup='createsickgroup';

  // Sqls


  SQLRbkSick='Select * from '+tbSick+' ';
  SQLRbkSickGroup='Select s.sickgroup_id,s.name,s.note,s.parent_id,s.sortnumber from '+prCreateSickGroup+'(null,null,null) c '+
                  'join '+tbSickGroup+' s on c.sickgroup_id=s.sickgroup_id ';


implementation

end.
