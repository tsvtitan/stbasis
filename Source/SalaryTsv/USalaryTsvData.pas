unit USalaryTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls;

var
  isInitAll: Boolean=false;
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  ListInterfaceHandles: TList;
  ListMenuHandles: Tlist;
  TempStr: String;
  IniStr: String;
  MainTypeLib: TTypeLib=ttleDefault;

  // Handles

  hInterfaceRbkAlgorithm: THandle;
  hInterfaceRbkCharge: THandle;
  hInterfaceRbkChargeTree: Thandle;
  hInterfaceRbkTypeBordereau: THandle;
  hInterfaceRptBordereau: THandle;
  hInterfaceRptAccountSheets: THandle;

  hMenuRBooks: THandle;
  hMenuReports: THandle;
  hMenuSalary: THandle;
  hMenuRptSalary: THandle;
  hMenuAlgorithm: THandle;
  hMenuCharge: THandle;
  hMenuChargeTree: THandle;
  hMenuTypeBordereau: Thandle;
  hMenuBordereau: Thandle;
  hMenuRptAccountSheets: Thandle;
  


const
  LibraryHint='Библиотека содержит справочники и отчеты необходимые для зарплаты.';

   { LibraryHint='содержит справочники:'+#13+
                NameProfession+#13+
                NameTypeStud+#13+
                NameEduc+#13+
                NameCraft+#13+
                NameSciencename+#13+
                NameLanguage+#13+
                NameKnowlevel+#13+
                NameMilrank+#13+
                NameRank+#13+
                NameReady+#13+
                NameGroupmil+#13+
                NameConnectiontype+#13+
                NameFamilystate+#13+
                NameProperty+#13+
                NameEmp+#13+
                NameEmpConnect+#13+
                NameEmpSciencename+#13+
                NameEmpLanguage+#13+
                NameEmpChildren+#13+
                NameEmpProperty+#13+
                NameEmpStreet+#13+
                NameEmpPersonDoc+#13+
                NameMilitary+#13+
                NameDiplom+#13+
                NameBiography+#13+
                NamePhoto+#13+
                NamePlant+#13+
                NameSchool+#13+
                NameTypeRelation+#13+
                NameTypeLive+#13+
                NameSex;}
  ConstEmpInnLength=12;

  ConstTypeEntry='te';
  ConstSectionShortCut='SalarytsvHotKeys';

  // Names

  NameRbkAlgorithm='Справочник алгоритмов';
  NameRbkCharge='Справочник начислений - удержаний';
  NameRbkStandartoperation='Справочник типовых операций';
  NameRbkChargeTree='Справочник зависимостей начислений';
  NameRbkTypeBordereau='Справочник видов ведомостей';
  NameRbkTypeBordereauCalcPeriod='Справочник видов ведомостей - расчетные периоды';
  NameRbkCalcPeriod='Расчетные периоды';
  NameRbkDepart='Справочник отделов';
  NameRbkSalary='Начисление зарплаты';
  NameRbkBordereau='Справочник ведомостей по зарплате';
//  NameRbkTypePay='Справочник видов доплат от стажа';
  NameRbkTypePay='Проценты от стажа';
  NameRbkAbsence='Справочник видов неявок';
  NameRbkChargeGroup='Справочник групп начислений';
  NameRbkRoundType='Справочник видов округлений';
  NameRbkEmp='Справочник сотрудников';
  NameRptAccountSheets='Расчетные листы';
  NameRptBordereau='Ведомости';


  // DBObjects

  tbAlgorithm='Algorithm';
  tbExperiencepercent='experiencepercent';
  tbTypePay='typepay';
  tbCharge='charge';
  tbStandartoperation='Standartoperation';
  tbChargeTree='chargetree';
  tbTypeBordereau='typebordereau';
  tbTypeBordereauCalcPeriod='typebordereaucalcperiod';
  tbCalcPeriod='CalcPeriod';
  tbDepart='depart';
  tbSalary='salary';
  tbEmpPlant='empplant';
  tbEmp='emp';
  tbFactPay='factpay';
  tbEmpPlantSchedule='empplantschedule';
  tbBordereau='bordereau';
  tbAbsence='absence';
  tbChargeGroup='chargegroup';
  tbRoundType='roundtype';
  tbNormalTime='normaltime';
  tbActualTime='actualtime';

  SQLRbkAlgorithm='Select al.*,ab.name as abname,tp.name as typepayname from '+tbAlgorithm+' al'+
                  ' left join '+tbAbsence+' ab on al.u_besiderowtable=ab.absence_id '+
                  ' left join '+tbTypePay+' tp on al.typepay_id=tp.typepay_id ';
  SQLRbkCharge='Select ch.*, so.name as standartoperationname,cg.name as chargegroupname,'+
               ' rt.name as roundtypename,al.name as algorithmname,ch.name as chargename'+
               ' from '+tbCharge+' ch'+
               ' join '+tbStandartoperation+' so on ch.standartoperation_id=so.standartoperation_id '+
               ' join '+tbChargeGroup+' cg on ch.chargegroup_id=cg.chargegroup_id '+
               ' join '+tbRoundType+' rt on ch.roundtype_id=rt.roundtype_id '+
               ' join '+tbAlgorithm+' al on ch.algorithm_id=al.algorithm_id ';
  SQLRbkChargeTree='Select ct.*, ch.name as chargename, ch.shortname as chargeshortname from '+
                   tbChargeTree+' ct join '+tbCharge+' ch on ct.charge_id=ch.charge_id ';
  SQLRbkTypeBordereau='Select tb.*,ch.name as chargename'+
                      ' from '+tbTypeBordereau+' tb'+
                      ' left join '+tbCharge+' ch on tb.charge_id=ch.charge_id ';




implementation

end.
