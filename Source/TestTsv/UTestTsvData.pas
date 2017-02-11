unit UTestTsvData;

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

  hInterfaceRbkCurrency: THandle;
  hInterfaceRbkRateCurrency: THandle;
  hInterfaceRptEmpUniversal: THandle;

  hMenuRBooks: THandle;
  hMenuRBooksFinances: THandle;
  hMenuRBooksCurrency: THandle;
  hMenuRBooksRateCurrency: THandle;
  hMenuRpts: THandle;
  hMenuRptsStaff: THandle;
  hMenuRptsEmpUniversal: THandle;

const
  LibraryHint='Это тестовый вариант библиотеки.';

  // Reports Consts
  NameRptEmpUniversal='Универсальный отчет по сотрудникам';

  // Interface Names

  NameRbkNation='Справочник национальностей';
  NameRbkFamilystate='Справочник семейного положения';
  NameRbkSex='Справочник пола';
  NameRbkCurrency='Справочник валют Test';
  NameRbkRateCurrency='Справочник курса валют Test';

  // Db Objects

{  tbProfession='profession';
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
  tbProperty='property';
  tbEmpConnect='empconnect';
  tbEmpSciencename='empsciencename';
  tbEmpLanguage='emplanguage';
  tbEmpChildren='children';
  tbEmpProperty='empproperty';
  tbEmpStreet='empstreet';
  tbEmpPersonDoc='emppersondoc';
  tbEmpPlant='empplant';
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
  tbPlant='plant';
  tbSchool='school';
  tbTypeRelation='typerelation';
  tbTypeLive='typelive';}
  tbTown='town';
  tbSex='sex';
  tbNation='nation';
  tbFamilystate='familystate';
  tbEmp='emp';
  tbCurrency='currency';
  tbRateCurrency='ratecurrency';
  {tbSick='sick';
  tbTypeEncouragements='typeencouragements';
  tbTypeResQual='typeresqual';
  tbBustripstous='bustripstous';
  tbAddAccount='addaccount';
  tbConsts='const';
  tbEmpPlantSchedule='empplantschedule';
  tbFactPay='factpay';
  tbCountry='country';
  tbRegion='region';
  tbStreet='street';
  tbState='state';
  tbPlacement='placement';
  tbPersonDocType='PersonDocType';
  tbDocum='Docum';
  tbSeat='seat';
  tbDepart='Depart';
  tbMotive='Motive';
  tbProf='prof';
  tbBank='bank';
  tbTypeLeave='TypeLeave';
  tbTypeReferences='typereferences';}

  // Sqls

  SQLRbkCurrency='Select * from '+tbCurrency+' ';
  SQLRbkRateCurrency='Select rc.*, c.name as currencyname from '+tbRateCurrency+' rc '+
                     ' join '+tbCurrency+' c on rc.currency_id=c.currency_id ';


implementation

end.
