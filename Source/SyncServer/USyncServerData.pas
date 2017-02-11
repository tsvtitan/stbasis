unit USyncServerData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls, Graphics,
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

  // handles

  hInterfaceRbkSync_Office: THandle;
  hInterfaceRbkSync_Package: THandle;
  hInterfaceRbkSync_Object: THandle;
  hInterfaceRbkSync_OfficePackage: THandle;

  hMenuServiceSync: THandle;
  hMenuRBooksSync_Office: THandle;
  hMenuRBooksSync_Package: THandle;
  hMenuRBooksSync_Object: THandle;
  hMenuRBooksSync_OfficePackage: THandle;

const
  SKey='9AA1B03934893D7134A660AF4204F2A9'; // Server

  LibraryHint='Содержит справочники, необходимые серверу для синхронизации данных.';
  LibraryProgrammers='Томилов Сергей';

  // formats

  // Sections

  // Formats


  // Interface Names

  NameRbkSync_Office='Справочник офисов синхронизации';
  NameRbkSync_Package='Справочник пакетов синхронизации';
  NameRbkSync_Object='Справочник объектов синхронизации';
  NameRbkSync_OfficePackage='Справочник офисных пакетов';

  // Db Objects

  tbSync_Office='sync_office';
  tbSync_Package='sync_package';
  tbSync_Object='sync_object';
  tbSync_OfficePackage='sync_office_package';

  // Sqls

  SQLRbkSync_Office='Select * from '+tbSync_Office+' ';
  SQLRbkSync_Package='Select * from '+tbSync_Package+' ';
  SQLRbkSync_Object='Select so.*, sp.name as package_name from '+
                    tbSync_Object+' so join '+
                    tbSync_Package+' sp on sp.sync_package_id=so.sync_package_id ';
  SQLRbkSync_OfficePackage='Select sop.*, so.name as office_name, sp.name as package_name from '+
                            tbSync_OfficePackage+' sop join '+
                            tbSync_Office+' so on so.sync_office_id=sop.sync_office_id join '+
                            tbSync_Package+' sp on sp.sync_package_id=sop.sync_package_id ';

implementation

initialization
  FSecurity:=TTsvSecurity.Create;
  FSecurity.Key:=SKey;

finalization
  FSecurity.Free;

end.
