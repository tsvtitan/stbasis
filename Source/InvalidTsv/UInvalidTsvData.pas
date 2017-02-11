unit UInvalidTsvData;

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

  hInterfaceRbkInvalidCategory: THandle;
  hInterfaceRbkViewPlace: THandle;
  hInterfaceRbkInvalidGroup: THandle;
  hInterfaceRbkPhysician: THandle;
  hInterfaceRbkInvalid: THandle;
  hInterfaceRbkVisit: THandle;
  hInterfaceRbkBranch: THandle;

  hMenuRBooks: THandle;
  hMenuRbkInvalidCategory: THandle;
  hMenuRbkViewPlace: THandle;
  hMenuRbkInvalidGroup: THandle;
  hMenuRbkPhysician: THandle;
  hMenuData: THandle;
  hMenuRbkInvalid: THandle;
  hMenuRbkVisit: THandle;
  hMenuRbkBranch: THandle;

  hToolButtonRbkInvalidCategory: THandle;
  hToolButtonRbkViewPlace: THandle;
  hToolButtonRbkInvalidGroup: THandle;
  hToolButtonRbkPhysician: THandle;
  hToolButtonRbkInvalid: THandle;
  hToolButtonRbkVisit: THandle;
  hToolButtonRbkBranch: THandle;

const
  LibraryHint='Библиотека содержит справочники и отчеты необходимые для учета инвалидов.';
  LibraryProgrammers='Томилов Сергей';

  ConstInvalidYear='Неверный год рождения';

  // Formats

  fmtYear='yyyy';

  // Names

  NameRbkInvalidCategory='Справочник категорий инвалидов';
  NameRbkViewPlace='Справочник мест осмотра';
  NameRbkInvalidGroup='Справочник групп инвалидности';
  NameRbkPhysician='Справочник врачей';
  NameRbkInvalid='Справочник инвалидов';
  NameRbkVisit='Справочник посещений';
  NameRbkSick='Справочник болезней';
  NameRbkSickGroup='Справочник групп болезней';
  NameRbkQuery='Запрос';
  NameRbkBranch='Справочник отделений поликлиники';

  // DBObjects

  tbInvalidCategory='InvalidCategory';
  tbViewPlace='ViewPlace';
  tbInvalidGroup='InvalidGroup';
  tbPhysician='Physician';
  tbInvalid='Invalid';
  tbVisit='Visit';
  tbSick='Sick';
  tbSickGroup='SickGroup';
  tbBranch='Branch';

  SQLRbkInvalidCategory='Select * from '+tbInvalidCategory+' ';
  SQLRbkViewPlace='Select * from '+tbViewPlace+' ';
  SQLRbkInvalidGroup='Select * from '+tbInvalidGroup+' ';
  SQLRbkPhysician='Select * from '+tbPhysician+' ';
  SQLRbkInvalid='Select * from '+tbInvalid+' ';
  SQLRbkVisit='Select sg.name as sickgroupname,i.fname||'' ''||i.name||'' ''||i.sname as invalidfio,'+
              'i.autotransport,'+
              'ic.name as invalidcategoryname,p.fname||'' ''||p.name||'' ''||p.sname as physicianfio,vp.name as viewplacename,'+
              'ig.name as invalidgroupname,ig1.name as cominginvalidgroupname,b.name as branchname,v.* from '+
              tbVisit+' v join '+
              tbSickGroup+' sg on v.sickgroup_id=sg.sickgroup_id join '+
              tbInvalid+' i on v.invalid_id=i.invalid_id join '+
              tbInvalidGroup+' ig on v.invalidgroup_id=ig.invalidgroup_id left join '+
              tbInvalidCategory+' ic on v.invalidcategory_id=ic.invalidcategory_id left join '+
              tbPhysician+' p on v.physician_id=p.physician_id left join '+
              tbViewPlace+' vp on v.viewplace_id=vp.viewplace_id left join '+
              tbInvalidGroup+' ig1 on v.cominginvalidgroup_id=ig1.invalidgroup_id left join '+
              tbBranch+' b on v.branch_id=b.branch_id ';
  SQLRbkBranch='Select * from '+tbBranch+' ';


implementation

end.
