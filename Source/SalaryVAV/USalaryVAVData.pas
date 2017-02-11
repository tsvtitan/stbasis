unit USalaryVAVData;

interface

{$I stbasis.inc}

uses Windows,Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls;

type
  TTypeSalaryVAVOptions=(tstoNone,tstoRBEmp);


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

  hMenuOperations: THandle;
  hMenuOperations_Salary: THandle;
  hMenuOperationsBuildingTree: THandle;
  hMenuOperationsSalPeriod: THandle;
  hMenuOperationsCalcPeriod: THandle;
  hMenuOperationsPrivelege: THandle;
  hMenuOperationsSalary: THandle;

  hInterfaceBuildingTree: THandle;
  hInterfaceSalPeriod: THandle;
  hInterfaceSalary: THandle;
  hInterfaceCalcPeriod: THandle;
  hInterfacePrivelege: THandle;



  hOptionRBooks: THandle;
  hOptionSalary: THandle;

  hToolButtonSalary: THandle;



  ConstShiftDay: Currency;
  ConstShiftEvening: Currency;
  ConstShiftNight: Currency;
  ConstPrivilegent: Currency;
  ConstDependent: Currency;
  ConstMaxSummForPrivelege: Currency;




const
    LibraryHint='содержит модуль рассчета заработной платы'+#13;

  ConstDefaultPassword='1234567890';
  ConstEmpInnLength=12;
  crImageMove=300;
  crImageDown=301;
  CursorMove='CRIMAGEMOVE';
  CursorDown='CRIMAGEDOWN';

  ConstTypeEntry='te';
  ConstSectionShortCut='SalaryVAVHotKeys';

  ConstRBSalaryClassName='TfmRBSalary';

  // Reports Consts
  NameRptEmpSprav='Справки сотрудникам';

  // Interface Names
  NameBuildingTree = 'Расчет начислений';
  NameSal          = 'Расчет зарплаты';
  NameCalcPeriod   = 'Расчетные периоды';
  NameDepart       = 'Справочник отделов';
  NameEmp          = 'Справочник сотрудников';
  NameAlgorithm    = 'Справочник алгоритмов';
  NameCharge       = 'Справочник начислений';
  NameSalary       = 'Ввод начислений и удержаний';
  NameConst        = 'Константы';
  NameSalPeriod    = 'Управление периодами';
  NameMrot         = 'Справочник минимальных оплат труда';
  NameConstCharge  = 'Справочник постоянных начислений';
  NamePrivelege    = 'Льготы на подоходный налог';
  NameRbkCharge    = 'Справочник начислений - удержаний';


  tbSalary     = 'salary';
  tbcalcperiod = 'calcperiod';
  tbemp        = 'emp';
  tbcharge     = 'charge';
  tbPrivelege  = 'privelege';
  tbdepart     = 'depart';
  tbempplant   = 'empplant';
  tbFamilystate= 'Familystate';
  tbNation     = 'Nation';
  tbCountry    = 'Country';
  tbRegion     = 'Region';
  tbState      = 'State';
  tbTown       = 'Town';
  tbPlaceMent  = 'PlaceMent';
  tbSex        = 'Sex';
  tbPlant      = 'Plant';
  tbDocum      = 'Docum';
  tbSeat       = 'Seat';
  tbMotive     = 'Motive';
  tbProf       = 'Prof';
  tbSchedule   = 'Schedule';
  tbEmpPlantSchedule = 'EmpPlantSchedule';
  tbAlgorithm  = 'Algorithm';
  tbMrot       = 'Mrot';
  tbConstCharge='ConstCharge';
  tbSheet      = 'Sheet';
  tbProfession='profession';
  tbTypeStud='typestud';
  tbEduc='educ';
  tbCraft='craft';
  tbSciencename='sciencename';
  tbLanguage='language';
  tbKnowlevel='knowlevel';
  tbMilrank='milrank';
  tbRank='rank';
  tbReady='ready';
  tbGroupmil='groupmil';
  tbConnectiontype='connectiontype';
//  tbFamilystate='familystate';
  tbProperty='property';
//  tbEmp='emp';
  tbEmpConnect='empconnect';
  tbEmpSciencename='empsciencename';
  tbEmpLanguage='emplanguage';
  tbEmpChildren='children';
  tbEmpProperty='empproperty';
  tbEmpStreet='empstreet';
  tbEmpPersonDoc='emppersondoc';
//  tbEmpPlant='empplant';
  tbEmpFaceAccount='empfaceaccount';
  tbEmpSickList='empsicklist';
  tbEmpLaborBook='emplaborbook';
  tbEmpRefreshCourse='emprefreshcourse';
  tbEmpLeave='empleave';
  tbEmpQual='empqual';
  tbEmpEncouragements='empencouragements';
  tbEmpBustripsfromus='empbustripsfromus';
  tbEmpReferences='empreferences';
  tbMilitary='military';
  tbDiplom='diplom';
  tbBiography='biography';
  tbPhoto='photo';
//  tbPlant='plant';
  tbSchool='school';
  tbTypeRelation='typerelation';
  tbTypeLive='typelive';
//  tbSex='sex';
  tbCurrency='currency';
  tbRateCurrency='ratecurrency';
  tbSick='sick';
  tbTypeEncouragements='typeencouragements';
  tbTypeResQual='typeresqual';
  tbBustripstous='bustripstous';
  tbAddAccount='addaccount';
  tbConsts='const';
//  tbEmpPlantSchedule='empplantschedule';
  tbFactPay='factpay';
//  tbNation='nation';
//  tbCountry='country';
//  tbRegion='region';
  tbStreet='street';
//  tbTown='town';
//  tbState='state';
//  tbPlacement='placement';
  tbPersonDocType='PersonDocType';
//  tbDocum='Docum';
//  tbSeat='seat';
//  tbDepart='Depart';
//  tbMotive='Motive';
//  tbProf='prof';
  tbBank='bank';
  tbTypeLeave='TypeLeave';
  tbTypeReferences='typereferences';
  tbNet='net';
  tbClass='class';
  tbCategory='category';
  tbAbsence='absence';
//  tbSchedule='schedule';
  tbNormalTime='NormalTime';
  tbActualTime='ActualTime';




  SQLRbCalcPeriod = 'Select * from '+tbCalcPeriod;
  SQLRbPrivelege = 'Select * from '+tbPrivelege;
  SQLRbkCalcPeriod = 'Select * from '+tbCalcperiod;

implementation

end.
