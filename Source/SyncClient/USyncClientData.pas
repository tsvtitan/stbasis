unit USyncClientData;

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

  hInterfaceRbkSync_Connection: THandle;
  hInterfaceSvcSync: THandle;

  hMenuService: THandle;
  hMenuServiceSync: THandle;
  hMenuRBooksSync_Connection: THandle;
  hMenuSvcSync: THandle;

  hToolButtonSync: THandle;

const
  SKey='577D7068826DE925EA2AEC01DBADF5E4'; // Client

  LibraryHint='Содержит справочники, необходимые клиенту для синхронизации данных.';
  LibraryProgrammers='Томилов Сергей';

  // formats

  // Sections

  // Strings
  // Formats

  // Interface Names

  NameRbkSync_Connection='Справочник соединений';
  NameSvcSync='Сервис синхронизации данных';

  // Db Objects

  tbSync_Connection='sync_connection';

  // Sqls

  SQLRbkSync_Connection='Select * from '+tbSync_Connection+' ';



implementation

initialization
  FSecurity:=TTsvSecurity.Create;
  FSecurity.Key:=SKey;

finalization
  FSecurity.Free;


end.
