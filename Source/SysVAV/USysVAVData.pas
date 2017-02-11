unit USysVAVData;

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

  hInterfaceRbkTypeNumerator: THandle;
  hInterfaceRbkNumerators: THandle;
  hInterfaceRbkLinkTypeDocNumerator: THandle;
  hInterfaceRbkUsersGroup: THandle;
//  hInterfaceRbkUsersInGroup: THandle;  

  hMenuRBooks: THandle;
  hMenuSys: THandle;

  hMenuRbkTypeNumerator: THandle;
  hMenuRbkNumerators: THandle;
  hMenuRbkLinkTypeDocNumerator: THandle;
  hMenuRbkUsersGroup: THandle;

  hToolButtonRbkTypeNumerator: THandle;
  hToolButtonRbkNumerators: THandle;
  hToolButtonRbkLinkTypeDocNumerator: THandle;
  hToolButtonRbkUsersGroup: THandle;
  
const
  LibraryHint='Библиотека содержит системные справочники.';
  LibraryProgrammers='Валегжанин Андрей';            

  // Names

  NameRbkTypeNumerator='Справочник типов нумераторов';
  NameRbkNumerators='Справочник нумераторов';
  NameRbkLinkTypeDocNumerator='Справочник связей документов и нумераторов';
  NameRbkTypeDoc='Справочник видов документов';
  NameRbkUsersGroup='Служба доступа к данным';


  // DBObjects

  tbTypeNumerator='TypeNumerator';
  tbNumerators='Numerators';
  tbLinkTypeDocNumerator='LinkTypeDocNumerator';
  tbTypeDoc='TypeDoc';
  tbUsersGroup='UsersGroup';
  tbUsersInGroup='UsersInGroup';
  tbUsersAccessRights='UsersAccessRights';
  tbUsers='Users';

  SQLRbkTypeNumerator='select * from '+tbTypeNumerator+' tn ';

  SQLRbkNumerators='Select n.*, tn.nametypenumerator from '+tbNumerators+' n'+
                   ' join '+ tbtypenumerator+ ' tn on n.typenumerator_id=tn.typenumerator_id';

  SQLRbkLinkTypeDocNumerator='Select ltdn.*, tn.nametypenumerator, td.name from '+tbLinkTypeDocNumerator+' ltdn ' +
                             ' join typenumerator tn on ltdn.typenumerator_id=tn.typenumerator_id ' +
                             ' join typedoc td on ltdn.typedoc_id= td.typedoc_id ';

  SQLRbkUsersGroup='Select * from '+ tbUsersGroup;
  SQLRbkUsersInGroup='Select * from '+ tbUsersInGroup;
  SQLRbkUsersAccessRights='Select * from '+ tbUsersAccessRights;


implementation

end.
