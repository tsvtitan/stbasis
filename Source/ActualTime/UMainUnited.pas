unit UMainUnited;

interface

{$I stbasis.inc}

uses Classes, forms, IBDatabase, Windows, IBQuery, graphics, sysutils, controls,
     IBServices, Excel97, db, dbgrids;
//**********************************************************
//******** consts, types, procedure, function  *************
//**********************************************************

// consts
const
  MainExe='stbasis.exe';

{  ConstRBooksDll='rbks';
  ConstReportsDll='rpts';
  ConstOperationsDll='opts';
  ConstDocumentsDll='dcts';
  ConstServiceDll='serv';}


  ConstSrvName=256;

  DomainNameLength=100;
  DomainSmallNameLength=30;
  DomainNoteLength=255;
  DomainNameBik=9;
  DomainNameAccount=20;
  DomainNameMoney=18;
  DomainINNLength=12;
  DomainPlantINNLength=10;
  DomainPlantOkonh=5;
  DomainPlantOkpo=8;
  DomainBuhAccountLength=10;
//*******Новые админ. тер. единицы
  DomainATICodeLength=11;
  DomainATINameLength=40;
  DomainATISocrLength=10;
  DomainATIGNINMBLength=4;
  DomainATIPostIndexLength=6;
  DomainCountryNameLength=45;
  DomainCountryName1Length=250;
  LengthWhereStr=250;

  ViewCountText='Всего выбрано: ';

  CaptionAdd='Добавить';
  CaptionDelete='Удалить';
  CaptionChange='Изменить';
  CaptionFilter='Фильтр';
  CaptionView='Подробнее';
  CaptionClose='Закрыть';
  CaptionCancel='Отмена';
  CaptionClear='Очистить';
  CaptionApply='Применить';

  ConstWarning='Предупреждение';
  ConstError='Ошибка';
  ConstQuestion='Подтверждение';
  ConstInformation='Информация';
  ConstFieldNoEmpty='Укажите значение в поле <%s>.';
  ConstFieldEmpty='Поле <%s> должно быть пустым.';
  ConstFieldLengthInvalid='Поле <%s> должно быть %d символов.';
  ConstFieldFormatInvalid='Значение поля <%s> имеет неверный формат.';
  ConstSqlExecute='Обработка запроса ...';
  ConstReportExecute='Формирование отчета ...';

  ConstSelect='Просмотр';
  ConstInsert='Вставка';
  ConstUpdate='Изменение';
  ConstDelete='Удаление';

  SelConst='S';
  DelConst='D';
  UpdConst='U';
  InsConst='I';
  RefConst='R';
  ExecConst='E';
  MigrateConst='M';

{  ConstDBNavigatorWidth=60;
  ConstDBNavigatorHeight=20;}

  ConstMainFormKeyDown='MainFormKeyDown';
  ConstMainFormKeyUp='MainFormKeyUp';
  ConstMainFormKeyPress='MainFormKeyPress';
  ConstGetIniFileName='GetIniFileName';
  ConstisPermission='isPermission';
  ConstisPermissionSecurity='isPermissionSecurity';
  ConstGetInfoLibrary='GetInfoLibrary';
  ConstGetListEntryRoot='GetListEntryRoot';
  ConstViewEntry='ViewEntry';
  ConstRefreshEntryes='RefreshEntryes';
  ConstSetAppAndScreen='SetAppAndScreen';
  ConstSetConnection='SetConnection';
  ConstSetSplashStatus='SetSplashStatus';
  ConstGetProtocolAndServerName='GetProtocolAndServerName';
  ConstGetInfoConnectUser='GetInfoConnectUser';
  ConstViewEntryFromMain='ViewEntryFromMain';
  ConstSetProgressStatus='SetProgressStatus';
  ConstAddErrorToJournal='AddErrorToJournal';
  ConstAddSqlOperationToJournal='AddSqlOperationToJournal';
  ConstCreateProgressBar='CreateProgressBar';
  ConstFreeProgressBar='FreeProgressBar';
  ConstGetDateTimeFromServer='GetDateTimeFromServer';
  ConstBeforeSetOptions='BeforeSetOptions';
  ConstAfterSetOptions='AfterSetOptions';
  ConstGetListOptionsRoot='GetListOptionsRoot';
  ConstViewEnterPeriod='ViewEnterPeriod';
  ConstAddToLastOpenEntryes='AddToLastOpenEntryes';
  ConstRemoveFromLastOpenEntryes='RemoveFromLastOpenEntryes';
  ConstGetOptions='GetOptions';
  ConstisPermissionColumn='isPermissionColumn';

  // Server functions
  ConstGetServerDateTime='now';

  // Ole consts
  ConstExcelOle='Excel.Sheet';
  ConstMesOperationInaccessible='Операция недоступна';
  ConstMesCallingWasDeclined='Вызов был отклонен';


{  ConstConnectUserName='connect';
  ConstConnectUserPass='$connect$';}
  ConstCodePagePlus='WIN1251';
  ConstCodePage='lc_ctype='+ConstCodePagePlus;

  ConstColorFilter=clRed;

  // Menu Consts
  ConstsMenuStaff='Кадровые справочники';
  ConstsMenuRptStaff='Кадровые отчеты';
  ConstsMenuMilitary='Воинский учет';
  ConstsMenuEducation='Образование';
  ConstsMenuAny='Разное';
  ConstsMenuATE='Административно-территориальные единицы';
  ConstsMenuFinances='Финансы';
  ConstsMenuDocums='Документы';
  ConstsMenuOtiz='ОТиЗ';
  ConstsMenuTime='Учёт рабочего времени';
  ConstsMenuSalary='Зарплата';

  // Option Consts
  ConstOptionWidth=370;
  ConstOptionHeight=300;
  ConstOptionGeneral='Общие';
  ConstOptionDataBase='База данных';
  ConstOptionShortCut='Горячие клавиши';
  ConstOptionAny='Разное';
  ConstOptionLibrary='Библиотеки';
  ConstOptionConsts='Константы';
  ConstOptionRBooks='Справочники';


  // by TSV
  tbSysUser_Privileges='rdb$user_privileges';
  tbJournalError='journalerror';              NameJournalError='Журнал ошибок';
  tbJournalSqlOperation='journalsqloperation';NameJournalSqlOperation='Журнал SQL операций';
  tbUsers='users';              NameUsers='Справочник пользователей';
  tbUserApp='usersapp';         NameUserApp='Справочник приложений доступных пользователям';
  tbApp='app';                  NameApp='Справочник приложений';
  tbUserEmp='useremp';          NameUserEmp='Справочник пользователь-сотрудник';
  tbAppPermColumn='apppermcolumn'; NameAppPermColumn='Справочник прав на колонки';

  tbProfession='profession';    NameProfession='Справочник специальностей по диплому';
  tbTypeStud='typestud';        NameTypeStud='Справочник видов обучения';
  tbEduc='educ';                NameEduc='Справочник видов образований';
  tbCraft='craft';              NameCraft='Справочник квалификаций по диплому';
  tbSciencename='sciencename';  NameSciencename='Справочник ученых званий';
  tbLanguage='language';        NameLanguage='Справочник иностранных языков';
  tbKnowlevel='knowlevel';      NameKnowlevel='Справочник уровней знаний';
  tbMilrank='milrank';              NameMilrank='Справочник воинских званий';
  tbRank='rank';                    NameRank='Справочник воинского состава';
  tbReady='ready';                  NameReady='Справочник годности военнообязанных';
  tbGroupmil='groupmil';            NameGroupmil='Справочник групп воинского учета';
  tbConnectiontype='connectiontype';NameConnectiontype='Справочник средств связи';
  tbFamilystate='familystate';      NameFamilystate='Справочник семейного положения';
  tbProperty='property';            NameProperty='Справочник групп сотрудников';
  tbEmp='emp';                      NameEmp='Справочник сотрудников';
  tbEmpConnect='empconnect';        NameEmpConnect='Справочник средств связи сотрудника';
  tbEmpSciencename='empsciencename';NameEmpSciencename='Справочник ученых званий сотрудника';
  tbEmpLanguage='emplanguage';      NameEmpLanguage='Справочник иностранных языков сотрудника';
  tbEmpChildren='children';         NameEmpChildren='Справочник детей сотрудника';
  tbEmpProperty='empproperty';      NameEmpProperty='Справочник признаков сотрудника';
  tbEmpStreet='empstreet';          NameEmpStreet='Справочник мест проживания сотрудника';
  tbEmpPersonDoc='emppersondoc';    NameEmpPersonDoc='Справочник документов сотрудника';
  tbEmpPlant='empplant';            NameEmpPlant='Справочник мест работы сотрудника';
  tbEmpFaceAccount='empfaceaccount';NameEmpFaceAccount='Справочник лицевых счетов сотрудника';
  tbEmpSickList='empsicklist';      NameEmpSickLict='Справочник больничных листов сотрудника';
  tbEmpLaborBook='emplaborbook';    NameEmpLaborBook='Справочник трудовых книжек сотрудника';
  tbEmpRefreshCourse='emprefreshcourse'; NameEmpRefreshCourse='Справочник переподготовок сотрудника';
  tbEmpLeave='empleave';            NameEmpLeave='Справочник отпусков сотрудника';
  tbEmpQual='empqual';              NameEmpQual='Справочник аттестаций сотрудника';
  tbEmpEncouragements='empencouragements';NameEmpEncouragements='Справочник поощрений и взысканий сотрудника';
  tbEmpBustripsfromus='empbustripsfromus';NameEmpBustripsfromus='Справочник командировок сотрудника';
  tbEmpReferences='empreferences';  NameEmpReferences='Справочник справок сотрудника';
  tbMilitary='military';            NameMilitary='Справочник военного учета сотрудника';
  tbDiplom='diplom';                NameDiplom='Справочник дипломов сотрудника';
  tbBiography='biography';          NameBiography='Справочник биографий сотрудника';
  tbPhoto='photo';                  NamePhoto='Справочник фотографий сотрудника';
  tbPlant='plant';                  NamePlant='Справочник контрагентов';
  tbSchool='school';                NameSchool='Справочник учебных заведений';
  tbTypeRelation='typerelation';    NameTypeRelation='Справочник категорий родственников';
  tbTypeLive='typelive';            NameTypeLive='Справочник видов проживаний';
  tbSex='sex';                      NameSex='Справочник пола';
  tbCurrency='currency';            NameCurrency='Справочник валют';
  tbRateCurrency='ratecurrency';    NameRateCurrency='Справочник курса валют';
  tbSick='sick';                    NameSick='Справочник болезней';
  tbTypeEncouragements='typeencouragements'; NameTypeEncouragements='Справочник видов поощрений';
  tbTypeResQual='typeresqual';      NameTypeResQual='Справочник типов результатов аттестации';
  tbBustripstous='bustripstous';    NameBustripstous='Справочник командировок к нам';
  tbAddAccount='addaccount';        NameAddAccount='Справочник дополнительных р/счетов';
  tbConsts='const';                 NameConst='Справочник констант';
  tbTypeReferences='typereferences';NameTypeReferences='Справочник типов справок';
  tbEmpPlantSchedule='empplantschedule'; NameEmpPlantSchedule='Места работы сотрудника - Графики';
  tbAlgorithm='algorithm';            NameAlgorithm='Справочник алгоритмов';
  tbCharge='charge';                NameCharge='Справочник начислений - удержаний';
  tbChargeTree='chargetree';        NameChargeTree='Справочник зависимостей начислений';


//*******Новые админ. тер. единицы
  tbCountry='country';          NameCountry='Справочник стран';
  tbRegion = 'Region';          NameRegion='Справочник краев и областей';
  tbStreet = 'Street';          NameStreet='Справочник улиц';
  tbTown = 'Town';              NameTown='Справочник городов';
  tbState = 'State';            NameState='Справочник районов';
  tbPlacement = 'Placement';    NamePlacement='Справочник населённых пунктов';
//********************************
  tbProf = 'Prof';              NameProf = 'Справочник профессий';
  tbPersonDocType = 'PersonDocType';         NamePersonDocType = 'Справочник видов док-в удостоверяющих личность';

  tbNation = 'Nation';          NameNation='Справочник нацинальностей';
  tbMotive ='Motive';           NameMotive='Справочник мотивов увольнений';

  tbSeat = 'Seat';              NameSeat='Справочник должностей';
  tbTypeDoc = 'TypeDoc';        NameTypeDoc='Справочник видов документов';
  tbDepart = 'Depart';          NameDepart='Справочник отделов';
  tbDocum='docum';              nameDocum='Справочник документов';
  tbBank='bank';                NameBank='Справочник банков';
  tbTypeLeave='typeleave';      nameTypeLeave='Справочник видов отпусков';

                                NameWizJobAccept='Помошник приема на работу';

  tbTypePay='TypePay';        NameTypePay='Справочник видов доплат от стажа';
  tbexperiencepercent='experiencepercent'; nameexperiencepercent='Справочник процент от стажа';
  tbStandartoperation='Standartoperation'; nameStandartoperation='Справочник типовых операций';
  TbAccountType='AccountType'; NameAccountType='Справочник типов проводок';
  NameSal='Зарплата';


  //Added by Volkov
  msgNoDataForView='Нет данных для отображения.';
  msgCalendarNotExist='Указанный календарь не существует.';
  //ConstFieldNoEmpty

  tbCalendar='calendar';
  fldCalendarCalendarID='calendar_id';
  fldCalendarStartDate='startdate';
  sqlSelStartDateCalendar='select startdate from calendar where calendar_id=%d';
  iniLastCalendar='LastCalendar';

  tbHoliday='holiday';

  tbCarry='carry';

  SplashCaptionShift='Справочник смен';
  MenuItemCaptionShift='Смены';
  MenuItemHintShift='';
  tbShift='shift';
  CaptionShiftEdit='Смены';
  CaptionShiftSelect='Выбор смены';
  CaptionShiftAdd='Добавить смену';
  CaptionShiftUpdate='Изменить смену';
  CaptionShiftDelete='Удалить смену <%s>?';
  sqlAddShift='insert into shift (name,addpaypercent,shift_id) values (''%s'',%d,%d)';
  sqlSelShift='select name,addpaypercent from shift where shift_id=%d';
  sqlDelShift='delete from shift where shift_id=%d';
  sqlUpdShift='update shift set name=''%s'',addpaypercent=%d where shift_id=%d';
  sqlSelShiftAll='select shift_id,name,addpaypercent from shift ';
  fldShiftName='name';
  fldShiftShiftID='shift_id';
  fldShiftAddPayPercent='addpaypercent';
  iniLastShift='LastShift';

  SplashCaptionSchedule='Редактор графиков и норм времени';
  MenuItemCaptionSchedule='Графики и нормы времени';
  MenuItemHintSchedule='';
  tbSchedule='schedule';
  sqlSelSchedule='select name,avgyear from schedule where schedule_id=%d';
  sqlAddSchedule='insert into schedule (name,avgyear,schedule_id,calendar_id) values (''%s'',%s,%d,%d)';
  sqlUpdSchedule='update schedule set name=''%s'',avgyear=%s,schedule_id=%d where schedule_id=%d';
  sqlDelSchedule='delete from schedule where schedule_id=%d';
  CaptionScheduleEdit='Графики и нормы времени';
  CaptionScheduleSelect='Выбор графика';
  CaptionScheduleAdd='Добавить график';
  CaptionScheduleUpdate='Изменить график';
  CaptionScheduleDelete='Удалить график <%s> календаря от %s?';
  fldScheduleScheduleID='schedule_id';
  fldScheduleName='name';
  fldScheduleAvgYear='avgyear';
  iniLastSchedule='LastSchedule';

  SplashCaptionNet='Справочник сеток';
  MenuItemCaptionNet='Сетки';
  MenuItemHintNet='';
  tbNet='net';

  SplashCaptionClass='Справочник разрядов';
  MenuItemCaptionClass='Разряды';
  MenuItemHintClass='';
  tbClass='class';

  SplashCaptionCategory='Справочник категорий';
  MenuItemCaptionCategory='Категории';
  MenuItemHintCategory='';
  tbCategory='category';

  SplashCaptionAbsence='Справочник видов неявок';
  MenuItemCaptionAbsence='Виды неявок';
  MenuItemHintAbsence='';
  tbAbsence='absence';
  CaptionAbsenceSelect='Выбор вида неявки';
  CaptionAbsenceEdit='Виды неявок';
  CaptionAbsenceAdd='Добавить вид неявки';
  CaptionAbsenceUpdate='Изменить вид неявки';
  CaptionAbsenceDelete='Удалить вид неявки <%s>?';
  fldAbsenceAbsenceID='absence_id';
  fldAbsenceName='name';
  fldAbsenceShortName='shortname';
  sqlAddAbsence='insert into absence (name,shortname,absence_id) values (''%s'',''%s'',%d)';
  sqlSelAbsence='select name,shortname from absence where absence_id=%d';
  sqlUpdAbsence='update absence set name=''%s'',shortname=''%s'' where absence_id=%d';
  sqlDelAbsence='delete from absence where Absence_id=%d';
  sqlSelAbsenceAll='select absence_id,name,shortname from absence ';
  iniLastAbsence='LastAbsence';

  tbNormalTime='normaltime';
  fldNormalTimeWorkDate='workdate';
  fldNormalTimeShiftID='shift_id';
  fldNormalTimeTimeCount='timecount';
  iniLastNormalTime='LastNormalTime';

  tbActualTime='actualtime';

  tbDivergence='divergence';

  tbSeatClass='seatclass';

  SplashCaptionChargeGroup='Справочник групп начислений';
  MenuItemCaptionChargeGroup='Группы начислений';
  MenuItemHintChargeGroup='';
  tbChargeGroup='chargegroup';
  CaptionChargeGroupSelect='Выбор группы начисления';
  CaptionChargeGroupEdit='Группы начислений';
  CaptionChargeGroupAdd='Добавить группу начисления';
  CaptionChargeGroupUpdate='Изменить группу начисления';
  CaptionChargeGroupDelete='Удалить группу начисления <%s>?';
  fldChargeGroupChargeGroupID='chargegroup_id';
  fldChargeGroupName='name';
  fldChargeGroupCode='code';
  fldChargeGroupGroupID='group_id';
  sqlAddChargeGroup='insert into chargegroup (name,code,group_id,chargegroup_id) values (''%s'',''%s'',%s,%d)';
  sqlSelChargeGroup='select name,code,group_id from chargegroup where chargegroup_id=%d';
  sqlUpdChargeGroup='update chargegroup set name=''%s'',code=''%s'',group_id=%s where chargegroup_id=%d';
  sqlDelChargeGroup='delete from chargegroup where chargegroup_id=%d';
  sqlSelChargeGroupAll='select chargegroup_id,name,code,group_id from chargegroup ';
  iniLastChargeGroup='LastChargeGroup';

  SplashCaptionRoundType='Справочник видов округлений';
  MenuItemCaptionRoundType='Виды округлений';
  MenuItemHintRoundType='';
  tbRoundType='roundtype';
  CaptionRoundTypeSelect='Выбор вида округления';
  CaptionRoundTypeEdit='Виды округлений';
  CaptionRoundTypeAdd='Добавить вид округления';
  CaptionRoundTypeUpdate='Изменить вид округления';
  CaptionRoundTypeDelete='Удалить вид округления <%s>?';
  fldRoundTypeRoundTypeID='roundtype_id';
  fldRoundTypeName='name';
  fldRoundTypeFactor='factor';
  sqlAddRoundType='insert into roundtype (name,factor,roundtype_id) values (''%s'',%d,%d)';
  sqlSelRoundType='select name,factor from roundtype where roundtype_id=%d';
  sqlUpdRoundType='update roundtype set name=''%s'',factor=%d where roundtype_id=%d';
  sqlDelRoundType='delete from roundtype where roundtype_id=%d';
  sqlSelRoundTypeAll='select roundtype_id,name,factor from roundtype ';
  iniLastRoundType='LastRoundType';

  SplashCaptionCategoryType='Справочник типов категорий';
  MenuItemCaptionCategoryType='Типы категорий';
  MenuItemHintCategoryType='';
  tbCategoryType='categorytype';
  CaptionCategoryTypeEdit='Типы категорий';
  CaptionCategoryTypeSelect='Выбор типа категории';
  CaptionCategoryTypeAdd='Добавить тип категории';
  CaptionCategoryTypeUpdate='Изменить тип категории';
  CaptionCategoryTypeDelete='Удалить тип категории <%s>?';
  sqlAddCategoryType='insert into categorytype (name,categorytype_id) values (''%s'',%d)';
  sqlSelCategoryType='select name from categorytype where categorytype_id=%d';
  sqlDelCategoryType='delete from categorytype where categorytype_id=%d';
  sqlUpdCategoryType='update categorytype set name=''%s'' where categorytype_id=%d';
  sqlSelCategoryTypeAll='select categorytype_id,name from categorytype ';
  fldCategoryTypeCategoryTypeID='categorytype_id';
  fldCategoryTypeName='name';
  iniLastCategoryType='LastCategoryType';

// Procedures and functions

function ShowError(Handle: THandle; Mess: String): Integer;
function ShowWarning(Handle: THandle; Mess: String): Integer;
function ShowInfo(Handle: THandle; Mess: String): Integer;
function ShowQuestion(Handle: THandle; Mess: String): Integer;
function GetRecordCount(qr: TIBQuery): Integer;
function GetGenId(DB: TIBDataBase; TableName: string; Increment: Word): Longword;
function TranslateIBError(Message: string): string;

// by Bespalov
function DeleteWarning(Handle: THandle; Mess: String): Integer;

//Added by Volkov
procedure ChangeDataBase(Owner:TComponent;DB:TIBDatabase);
function StringToHexStr(S:String):String;
function HexStrToString(S:String):String;
procedure SetSelectedRowParams(var AFont:TFont;var ABackground:TColor);
procedure SetSelectedColParams(var AFont:TFont;var ABackground:TColor);
procedure SetMinColumnsWidth(Columns: TDBGridColumns);

procedure ClearFields(wt: TWinControl);
function isFloat(Value: string): Boolean;
function isInteger(Value: string): Boolean;
function ChangeChar(Value: string; chOld, chNew: char): string;
function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
function FieldToVariant(Field: TField): OleVariant;
function TranslateSqlOperator(Operator: String): string;
procedure AssignFont(inFont,outFont: TFont);


// Types and records
type


  TTypeLib=(ttlRBooks,ttlReports,ttlOperations,ttlDocuments,ttlService);
  TSetTypeLib=set of TTypeLib;

  PInfoLibrary=^TInfoLibrary;
  TInfoLibrary=packed record
    Hint: Pchar;
    TypeLib: TSetTypeLib;
  end;

  TTypeEntry=(tte_None,
              tte_rbksusers,
              tte_rbksapp,
              tte_rbksuserapp,
              tte_rbksuseremp,
              tte_rbksapppermcolumn,

              tte_rbkscalctype,
              tte_rbkscarry,
              tte_rbkscategory,
              tte_rbkschargecalctype,
              tte_rbksclass,
              tte_rbksconnectiontype,
              tte_rbkscraft,
              tte_rbksActualTime,//!!!!!!!!!!!
              tte_rbksdepart,
              tte_rbksdiplom,
              tte_rbksdocum,
              tte_rbkseduc,
              tte_rbksemp,
              tte_rbksempconnect,
              tte_rbksempdiplom   ,
              tte_rbksemplanguage,
              tte_rbksemppersondoc,
              tte_rbksempplant,
              tte_rbksempproperty,
              tte_rbksempsciencename,
              tte_rbksempstreet,
              tte_rbksfactpay,
              tte_rbksfamilystate,
              tte_rbksCalendar,
              tte_rbksgroupmil,
              tte_rbksholiday,
              tte_rbksknowlevel  ,
              tte_rbkslanguage,
              tte_rbksmilitary,
              tte_rbksmilrank,
              tte_rbksmotive,
              tte_rbksnation ,
              tte_rbksnetweek,
              tte_rbkspersondoctype,
              tte_rbksplant,
              tte_rbksprof,
              tte_rbksprofession,
              tte_rbksproperty,
              tte_rbksrank,
              tte_rbkssalary,
              tte_rbksschool,
              tte_rbkssciencename,
              tte_rbksseat,
              tte_rbksseatclass,
              //******Новые АТИ*************************************************
              tte_rbksCountry,
              tte_rbksregion,
              tte_rbksstate,
              tte_rbkstown,
              tte_rbksplacement,
              tte_rbksstreet,
              //***************************************************************
              tte_rbkstypedoc,
              tte_rbkstypestud,
              tte_rbksSchedule,
              tte_rbksready,              tte_rbkstyperelation,              tte_rbkstypelive,              tte_rbkssex,              tte_rbksbiography,              tte_rbksphoto,              tte_rbksnet,              tte_rbkscurrency,              tte_rbksShift,              tte_rbksBank,              tte_rbksTypeLeave,
              tte_rbksratecurrency,
              tte_rbkssick,
              tte_rbkstypeencouragements,
              tte_rbkstyperesqual,              tte_rbksempfaceaccount,              tte_rbksempsicklist,              tte_rbksemplaborbook,              tte_rbksemprefreshcourse,              tte_rbksempleave,              tte_rbksempqual,              tte_rbksempencouragements,              tte_rbksempbustripsfromus,              tte_rbksbustripstous,              tte_rbksAbsence,              tte_rbksaddaccount,              tte_rbkstypereferences,              tte_rbkstypepay,              tte_rbksexperiencepercent,              tte_rbksChargeGroup,//Volkov              tte_rbksRoundType,//Volkov              tte_rbksCategoryType,//Volkov              tte_rbksalgorithm,              tte_rbksStandartOperation,              tte_rbksAccountType,              tte_rbkscharge,              tte_rbkschargetree,              tte_salperiod,              tte_servCalendar,              tte_servJournalError,              tte_servJournalsqloperation,              tte_wizJobAssept,              tte_rptstest,              tte_rptsempuniversal,              tte_const,              tte_Last              );



type

  TTypeGetInfoLibrary=procedure (P: PInfoLibrary);stdcall;
  TTypeGetListEntryRoot=function: TList;stdcall;
  TTypeViewEntry=function (TypeEntry: TTypeEntry; Params:
                           Pointer; isModal: Boolean; OnlyData: Boolean=false): Boolean; stdcall;
  TTypeRefreshEntryes=procedure;stdcall;
  TTypeSetAppAndScreen=procedure(A: TApplication; S: TScreen);stdcall;
  TTypeSetConnection=procedure (IBDbase: TIBDatabase; IBTran: TIBTransaction;
                                IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
  TTypeGetListOptionsRoot=function: TList;stdcall;
  TTypeBeforeSetOptions=procedure;stdcall;
  TTypeAfterSetOptions=procedure(isOK: Boolean);stdcall;
  TTypeMenuClick=procedure(Index: Integer);stdcall;

  PInfoMenu=^TInfoMenu;
  TInfoMenu=packed record
    Name: PChar;
    Hint: PChar;
    TypeEntry: TTypeEntry;
    List: TList;
    Bitmap: TBitmap;
    TypeLib: TSetTypelib;
    ShortCut: TShortCut;
  end;

  PInfoChargeTree=^TInfoChargeTree;
  TInfoChargeTree=packed record
    chargetree_id: Integer;
    charge_id: Integer;
    parent_id: Integer;
    List: TList;
  end;

  PInfoOption=^TInfoOption;
  TInfoOption=packed record
    Name: PChar;
    List: TList;
    Index: Integer;
    ParentWindow: THandle;
    Bitmap: TBitmap;
  end;

  PInfoProgressBarMenu=^TInfoProgressBarMenu;
  TInfoProgressBarMenu=packed record
    Name: PChar;
    Hint: PChar;
    Proc: TTypeMenuClick;
  end;

  TTypeEnterPeriod=(tepQuarter,tepMonth,tepDay,tepInterval,tepYear);

  PInfoEnterPeriod=^TInfoEnterPeriod;
  TInfoEnterPeriod=packed record
    DateBegin: TDate;
    DateEnd: TDate;
    LoadAndSave: Boolean;
    TypePeriod: TTypeEnterPeriod;
  end;

  PMainOption=^TMainOption;
  TMainOption=packed record
    isEditRBOnSelect: Boolean;
    RBTableFont: TFont;
    RBTableRecordColor: TColor;
    RBTableCursorColor: TColor;
  end;
                                          
// imports
  procedure _MainFormKeyDown(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyDown;
  procedure _MainFormKeyUp(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyUp;
  procedure _MainFormKeyPress(var Key: Char);stdcall;
                         external MainExe name ConstMainFormKeyPress;
  function _GetIniFileName: Pchar;stdcall; external MainExe name ConstGetIniFileName;
  procedure _AddToLastOpenEntryes(TypeEntry: TTypeEntry);stdcall;
                         external MainExe name ConstAddToLastOpenEntryes;
  procedure _RemoveFromLastOpenEntryes(TypeEntry: TTypeEntry);stdcall;
                         external MainExe name ConstRemoveFromLastOpenEntryes;
  function _GetOptions: TMainOption;stdcall;
                         external MainExe name ConstGetOptions;
  
type

  PUserParams=^TUserParams;
  TUserParams=packed record
    user_name: array[0..128-1] of char;
    name: array[0..DomainNameLength-1] of char;
  end;

  PInfoConnectUser=^TInfoConnectUser;
  TInfoConnectUser=packed record
    UserName: array[0..DomainNameLength-1] of char;
    UserPass: array[0..DomainNameLength-1] of char;
    SqlUserName: array[0..128-1] of char;
    SqlRole: array[0..128-1] of char;
  end;

  PProfessionParams=^TProfessionParams;
  TProfessionParams=packed record
    profession_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    code: array[0..DomainSmallNameLength-1] of char;
  end;

  PTypeStudParams=^TTypeStudParams;
  TTypeStudParams=packed record
    typestud_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PEducParams=^TEducParams;
  TEducParams=packed record
    educ_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PCraftParams=^TCraftParams;
  TCraftParams=packed record
    craft_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PAppParams=^TAppParams;
  TAppParams=packed record
    app_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    sqlrole: array[0..DomainNameLength-1] of char;
  end;

  PUserAppParams=^TUserAppParams;
  TUserAppParams=packed record
    user_name: array[0..128-1] of char;
    app_id: Integer;
  end;

  PSciencenameParams=^TSciencenameParams;
  TSciencenameParams=packed record
    sciencename_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PLanguageParams=^TLanguageParams;
  TLanguageParams=packed record
    language_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PKnowlevelParams=^TKnowlevelParams;
  TKnowlevelParams=packed record
    knowlevel_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PJournalErrorParams=^TJournalErrorParams;
  TJournalErrorParams=packed record
    journalerror_id: Integer;
    user_name: array[0..128-1] of char;
    hint: array[0..1000-1] of char;
    indatetime: TDateTime;
    classerror: array[0..DomainNameLength-1] of char;
  end;

  PJournalSqlOperationParams=^TJournalSqlOperationParams;
  TJournalSqlOperationParams=packed record
    journalsqloperation_id: Integer;
    user_name: array[0..128-1] of char;
    hint: array[0..1000-1] of char;
    indatetime: TDateTime;
    name: array[0..DomainSmallNameLength-1] of char;
  end;

  PUserEmpParams=^TUserEmpParams;
  TUserEmpParams=packed record
    emp_id: Integer;
    username: array[0..DomainNameLength-1] of char;
  end;

  PAppPermColumnParams=^TAppPermColumnParams;
  TAppPermColumnParams=packed record
    apppermcolumn_id: Integer;
    app_id: Integer;
    obj: array[0..DomainNameLength-1] of char;
    col: array[0..DomainNameLength-1] of char;
    perm: array[0..DomainNameLength-1] of char;
  end;

  PMilrankParams=^TMilrankParams;
  TMilrankParams=packed record
    milrank_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PRankParams=^TRankParams;
  TRankParams=packed record
    rank_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PReadyParams=^TReadyParams;
  TReadyParams=packed record
    ready_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PGroupmilParams=^TGroupmilParams;
  TGroupmilParams=packed record
    groupmil_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PConnectiontypeParams=^TConnectiontypeParams;
  TConnectiontypeParams=packed record
    connectiontype_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PFamilystateParams=^TFamilystateParams;
  TFamilystateParams=packed record
    familystate_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PPropertyParams=^TPropertyParams;
  TPropertyParams=packed record
    property_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    parent_id: Integer;
  end;

  PEmpParams=^TEmpParams;
  TEmpParams=packed record
    emp_id: Integer;
    sex_id: Integer;
    familystate_id: Integer;
    nation_id: Integer;
    borntown_id: Integer;
    fname: array[0..DomainNameLength-1] of char;
    name: array[0..DomainSmallNameLength-1] of char;
    sname: array[0..DomainSmallNameLength-1] of char;
    perscardnum: array[0..DomainSmallNameLength-1] of char;
    tabnum: Integer;
    birthdate: TDateTime;
    continioussenioritydate: TDateTime;
    inn: array[0..12-1] of char;
  end;

  PEmpConnectParams=^TEmpConnectParams;
  TEmpConnectParams=packed record
    connection_id: Integer;
    emp_id: Integer;
    connectstring: array[0..DomainNameLength-1] of char;
  end;

  PEmpScienceNameParams=^TEmpScienceNameParams;
  TEmpScienceNameParams=packed record
    emp_id: Integer;
    sciencename_id: Integer;
  end;

  PPlantParams=^TPlantParams;
  TPlantParams=packed record
    plant_id: Integer;
    juristaddress_id: Integer;
    juristaddress: array[0..DomainSmallNameLength-1] of char;
    postaddress_id: Integer;
    postaddress: array[0..DomainSmallNameLength-1] of char;
    bank_id: Integer;
    inn: array[0..DomainPlantINNLength-1] of char;
    account: array[0..DomainNameAccount-1] of char;
    smallname: array[0..DomainNameLength-1] of char;
    fullname: array[0..DomainNameLength-1] of char;
    contactpeople: array[0..200-1] of char;
    phone: array[0..DomainSmallNameLength-1] of char;
    okonh: array[0..DomainPlantOkonh-1] of char;
    okpo: array[0..DomainPlantOkpo-1] of char;
  end;

  PSchoolParams=^TSchoolParams;
  TSchoolParams=packed record
    school_id: Integer;
    town_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    parent_id: Integer;
  end;

  PTypeRelationParams=^TTypeRelationParams;
  TTypeRelationParams=packed record
    typerelation_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PTypeLiveParams=^TTypeLiveParams;
  TTypeLiveParams=packed record
    typelive_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PSexParams=^TSexParams;
  TSexParams=packed record
    sex_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    shortname: array[0..DomainSmallNameLength-1] of char;
  end;

  PBiographyParams=^TBiographyParams;
  TBiographyParams=packed record
    biography_id: Integer;
    emp_id: Integer;
    datestart: TDateTime;
    note: array[0..DomainNoteLength-1] of char;
  end;
  
  PPhotoParams=^TPhotoParams;
  TPhotoParams=packed record
    photo_id: Integer;
    emp_id: Integer;
//    photo: Blob; 
    datephoto: TDateTime;
    note: array[0..DomainNoteLength-1] of char;
  end;

  PEmpPlantParams=^TEmpPlantParams;
  TEmpPlantParams=packed record
    empplant_id: Integer;
    emp_id: Integer;
    net_id: Integer;
    class_id: Integer;
    plant_id: Integer;
    reasondocum_id: Integer;
    category_id: Integer;
    seat_id: Integer;
    depart_id: Integer;
    orderdocum_id: Integer;
    motive_id: Integer;
    prof_id: Integer;
    releasedate: TDateTime;
    datestart: TDateTime;
  end;

  PCurrencyParams=^TCurrencyParams;
  TCurrencyParams=packed record
    currency_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    shortname: array[0..DomainSmallNameLength-1] of char;
  end;

  PRateCurrencyParams=^TRateCurrencyParams;
  TRateCurrencyParams=packed record
    ratecurrency_id: Integer;
    currency_id: Integer;
    indate: TDateTime;
    factor: currency;
  end;

  PSickParams=^TSickParams;
  TSickParams=packed record
    sick_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    cipher: array[0..DomainSmallNameLength-1] of char;
  end;

  PTypeEncouragementsParams=^TTypeEncouragementsParams;
  TTypeEncouragementsParams=packed record
    typeencouragements_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PTypeResQualParams=^TTypeResQualParams;
  TTypeResQualParams=packed record
    typeresqual_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PEmpFaceAccountParams=^TEmpFaceAccountParams;
  TEmpFaceAccountParams=packed record
    empfaceaccount_id: Integer;
    currency_id: Integer;
    emp_id: Integer;
    bank_id: Integer;
    num: array[0..DomainNameAccount-1] of char;
    percent: Currency;
    summ: Currency;
  end;                          

  PEmpSickListParams=^TEmpSickListParams;
  TEmpSickListParams=packed record
    empsicklist_id: Integer;
    sick_id: Integer;
    emp_id: Integer;
    num: array[0..DomainSmallNameLength-1] of char;
    datestart: TDateTime;
    datefinish: TDateTime;
    percent: Currency;
  end;

  PEmpLaborBookParams=^TEmpLaborBookParams;
  TEmpLaborBookParams=packed record
    emplaborbook_id: Integer;
    emp_id: Integer;
    prof_id: Integer;
    plant_id: Integer;
    motive_id: Integer;
    datestart: TDateTime;
    datefinish: TDateTime;
    hint: array[0..DomainNoteLength-1] of char;
    mainprof: Integer;
  end;

  PEmpRefreshCourseParams=^TEmpRefreshCourseParams;
  TEmpRefreshCourseParams=packed record
    emprefreshcourse_id: Integer;
    emp_id: Integer;
    prof_id: Integer;
    plant_id: Integer;
    docum_id: Integer;
    datestart: TDateTime;
    datefinish: TDateTime;
  end;

  PEmpLeaveParams=^TEmpLeaveParams;
  TEmpLeaveParams=packed record
    empleave_id: Integer;
    docum_id: Integer;
    typeleave_id: Integer;
    forperiod: TDateTime;
    forperiodon: TDateTime;
    datestart: TDateTime;
    mainamountcalday: Integer;
    addamountcalday: Integer;
  end;

  PEmpQualParams=^TEmpQualParams;
  TEmpQualParams=packed record
    empqual_id: Integer;
    typeresqual_id: Integer;
    resdocum_id: Integer;
    docum_id: Integer;
    emp_id: Integer;
    datestart: TDateTime;
  end;

  PEmpEncouragementsParams=^TEmpEncouragementsParams;
  TEmpEncouragementsParams=packed record
    empencouragements_id: Integer;
    typeencouragements_id: Integer;
    docum_id: Integer;
    emp_id: Integer;
    datestart: TDateTime;
  end;

  PEmpBustripsfromusParams=^TEmpBustripsfromusParams;
  TEmpBustripsfromusParams=packed record
    empbustripsfromus_id: Integer;
    emp_id: Integer;
    empproj_id: Integer;
    empdirect_id: Integer;
    docum_id: Integer;
    num: array[0..DomainSmallNameLength-1] of char;
    datestart: TDateTime;
    datefinish: TDateTime;
    ok: Integer;
  end;

  PBustripstousParams=^TBustripstousParams;
  TBustripstousParams=packed record
    bustripstous_id: Integer;
    plant_id: Integer;
    seat_id: Integer;
    fname: array[0..DomainNameLength-1] of char;
    name: array[0..DomainSmallNameLength-1] of char;
    sname: array[0..DomainSmallNameLength-1] of char;
    datestart: TDateTime;
    datefinish: TDateTime;
  end;

  PAddAccountParams=^TAddAccountParams;
  TAddAccountParams=packed record
    addaccount_id: Integer;
    bank_id: Integer;
    plant_id: Integer;
    account: array[0..DomainNameAccount-1] of char;
  end;

  PConstParams=^TConstParams;
  TConstParams=packed record
    const_id: Integer;
    defaultproperty_id: Integer;
    defaultpropertyname: array[0..DomainNameLength-1] of char;
    leaveabsence_id: Integer;
    leaveabsencename: array[0..DomainNameLength-1] of char;
    refreshcourseabsence_id: Integer;
    refreshcourseabsencename: array[0..DomainNameLength-1] of char;
    empstaffboss_id: Integer;
    empstaffbossname: array[0..DomainNameLength+DomainNameLength+DomainNameLength-1] of char;
    defaultcurrency_id: Integer;
    defaultcurrencyname: array[0..DomainNameLength-1] of char;
    empaccount_id: Integer;
    empaccountname: array[0..DomainNameLength+DomainNameLength+DomainNameLength-1] of char;
    empboss_id: Integer;
    empbossname: array[0..DomainNameLength+DomainNameLength+DomainNameLength-1] of char;
    plant_id: Integer;
    plantname: array[0..DomainSmallNameLength-1] of char;
    plantPFRcode: array[0..DomainSmallNameLength-1] of char;
    IMNScode: array[0..4-1] of char;
    roundto: Integer;
    emppassport_id: Integer;
    passportname: array[0..DomainNameLength-1] of char;
    tariffcategorytype_id: Integer;
    tariffcategorytypename: array[0..DomainNameLength-1] of char;
    salarycategorytype_id: Integer;
    salarycategorytypename: array[0..DomainNameLength-1] of char;
    pieceworkcategorytype_id: Integer;
    pieceworkcategorytypename: array[0..DomainNameLength-1] of char;
    country_id: Integer;
    countryname: array[0..DomainCountryNameLength-1] of char;
    region_id: Integer;
    regionname: array[0..DomainATINameLength-1] of char;
    state_id: Integer;
    statename: array[0..DomainATINameLength-1] of char;
    town_id: Integer;
    townname: array[0..DomainATINameLength-1] of char;
    placement_id: Integer;
    placementname: array[0..DomainATINameLength-1] of char;
    countrycode: array[0..DomainCountryNameLength-1] of char;
    regioncode: array[0..DomainATINameLength-1] of char;
    statecode: array[0..DomainATINameLength-1] of char;
    towncode: array[0..DomainATINameLength-1] of char;
    placementcode: array[0..DomainATINameLength-1] of char;
  end;

  PTypeReferencesParams=^TTypeReferencesParams;
  TTypeReferencesParams=packed record
    typereferences_id: Integer;
    name: array[0..DomainNameLength-1] of char;
  end;

  PAlgorithmParams=^TAlgorithmParams;
  TAlgorithmParams=packed record
    algorithm_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    typefactorworktime: Integer;
    typebaseamount: Integer;
    typepercent: Integer;
    typemultiply: Integer;
    bs_amountmonthsback: Integer;
    bs_totalamountmonths: Integer;
    bs_multiplyfactoraverage: Currency;
    bs_divideamountperiod: Integer;
    bs_salary: Currency;
    bs_tariffrate: Currency;
    bs_averagemonthsbonus: Currency;
    bs_annualbonuses: Currency;
    bs_minsalary: Currency;
    krv_typeratetime: Integer;
    krv_amountmonthsback: Integer;
    krv_totalamountmonths: Integer;
    u_besiderowtable: Integer;
    typepay_id: Integer;
  end;

  PChargeParams=^TChargeParams;
  TChargeParams=packed record
    charge_id: Integer;
    name: array[0..DomainNameLength-1] of char;
    shortname: array[0..DomainSmallNameLength-1] of char;
    standartoperation_id: Integer;
    chargegroup_id: Integer;
    roundtype_id: Integer;
    algorithm_id: Integer;
    flag: Integer;
    fallsintototal: Integer;
    fixedamount: Currency;
    fixedrateathours: Currency;
    fixedpercent: Currency;
  end;

  PChargeTreeParams=^TChargeTreeParams;
  TChargeTreeParams=packed record
    chargetree_id: Integer;
    parent_id: Integer;
    charge_id: Integer;
    chargename: array[0..DomainNameLength-1] of char;
  end;

  //Added by Volkov
  PCalendarParams=^TCalendarParams;
  TCalendarParams=packed record
   Calendar_ID:Integer;
   StartDate:TDateTime;
   HolidaysAddPayPercent:Integer;
  end;

  PHolidayParams=^THolidayParams;
  THolidayParams=packed record
   Calendar_ID,Holiday_ID:Integer;
   Holiday:TDateTime;
   Name:String[DomainNameLength];
  end;

  PCarryParams=^TCarryParams;
  TCarryParams=packed record
   Calendar_ID,Carry_ID:Integer;
   FromDate,ToDate:TDateTime;
   Name:String[DomainNameLength];
  end;

  PScheduleParams=^TScheduleParams;
  TScheduleParams=packed record
   Calendar_ID,Schedule_ID:Integer;
   Name:String[DomainNameLength];
   AvgYear:Double;
  end;

  PShiftParams=^TShiftParams;
  TShiftParams=packed record
   Shift_ID:Integer;
   Name:String[DomainNameLength];
   AddPayPercent:Integer;
  end;

  PNetParams=^TNetParams;
  TNetParams=packed record
    Net_id: Integer;
    Name:String[DomainNameLength];
  end;

  PClassParams=^TClassParams;
  TClassParams=packed record
    Class_id: Integer;
    Num:String[DomainSmallNameLength];
  end;

  PAbsenceParams=^TAbsenceParams;
  TAbsenceParams=packed record
    Absence_id: Integer;
    Name:String[DomainNameLength];
    ShortName:String[DomainSmallNameLength];
  end;

  PCategoryParams=^TCategoryParams;
  TCategoryParams=packed record
    Category_id: Integer;
    Name:String[DomainNameLength];
    PayType: Integer;
  end;

  PChargeGroupParams=^TChargeGroupParams;
  TChargeGroupParams=packed record
    ChargeGroup_id: Integer;
    Name:String[DomainNameLength];
    Code:String[DomainSmallNameLength];
    Group_id: Integer;
  end;

  PRoundTypeParams=^TRoundTypeParams;
  TRoundTypeParams=packed record
    RoundType_id: Integer;
    Name:String[DomainNameLength];
    Factor: Integer;
  end;

  PCategoryTypeParams=^TCategoryTypeParams;
  TCategoryTypeParams=packed record
   CategoryType_ID:Integer;
   Name:String[DomainNameLength];
  end;

  //*************Новые АТЕ ***************************************
          // by Bespalov
  PCountryParams=^TCountryParams;
  TCountryParams = packed record
    Country_id : integer;
    CountryName: Array [0..DomainCountryNameLength-1] of char;
    Code:        Array [0..DomainATICodeLength-1] of char;
    Name1:       Array [0..DomainCountryName1Length-1] of char;
    alfa2:       Array [0..18-1] of char;
    alfa3:       Array [0..18-1] of char;
  end;

  PRegionParams =^TRegionParams; //края
  TRegionParams = packed record
    Region_id : integer;
    RegionName:  Array [0..DomainATINameLength-1] of char;
    Code:        Array [0..DomainATICodeLength-1] of char;
    Socr:        Array [0..DomainATISocrLength-1] of char;
    GNINMB:      Array [0..DomainATIGNINMBLength-1] of char;
    postIndex:   Array [0..DomainATIPostIndexLength-1] of char;
    wherestr:    Array [0..LengthWhereStr-1] of char;
  end;

  PStateParams =^TStateParams;
  TStateParams = packed record
    State_id : integer;
    StateName:   Array [0..DomainATINameLength-1] of char;
    Code:        Array [0..DomainATICodeLength-1] of char;
    Socr:        Array [0..DomainATISocrLength-1] of char;
    GNINMB:      Array [0..DomainATIGNINMBLength-1] of char;
    postIndex:   Array [0..DomainATIPostIndexLength-1] of char;
    wherestr:    Array [0..LengthWhereStr-1] of char;
  end;

  PTownParams = ^TTownParams;
  TTownParams = packed record
    Town_id :    integer;
    TownName:    Array [0..DomainATINameLength-1] of char;
    Code:        Array [0..DomainATICodeLength-1] of char;
    Socr:        Array [0..DomainATISocrLength-1] of char;
    GNINMB:      Array [0..DomainATIGNINMBLength-1] of char;
    postIndex:   Array [0..DomainATIPostIndexLength-1] of char;
    wherestr:    Array [0..LengthWhereStr-1] of char;
  end;

  PPlacementParams = ^TPlacementParams;
  TPlacementParams = packed record
    Placement_id :    integer;
    PlacementName: Array [0..DomainATINameLength-1] of char;
    Code:          Array [0..DomainATICodeLength-1] of char;
    Socr:          Array [0..DomainATISocrLength-1] of char;
    GNINMB:        Array [0..DomainATIGNINMBLength-1] of char;
    postIndex:     Array [0..DomainATIPostIndexLength-1] of char;
    wherestr:    Array [0..LengthWhereStr-1] of char;
  end;

  PStreetParams=^TStreetParams;
  TStreetParams = packed record
    Street_id: integer;
    StreetName:  Array [0..DomainATINameLength-1] of char;
    Code:        Array [0..DomainATICodeLength-1] of char;
    Socr:        Array [0..DomainATISocrLength-1] of char;
    GNINMB:      Array [0..DomainATIGNINMBLength-1] of char;
    postIndex:   Array [0..DomainATIPostIndexLength-1] of char;
    wherestr:    Array [0..LengthWhereStr-1] of char;    
  end;


//******************************************************************************
  PProfParams = ^TProfParams;
  TProfParams = packed record
    id: integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PNationParams = ^TNationParams;
  TNationParams = packed record
    id: integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PMotiveParams = ^TMotiveParams;
  TMotiveParams = packed record
    id:Integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PPersonDocTypeParams=^TPersonDocTypeParams;
  TPersonDocTypeParams=packed record
    id:Integer;
    Name: Array [0..DomainNameLength-1] of char;
    masknum: Array [0..DomainSmallNameLength-1] of char;
    maskSeries: Array [0..DomainSmallNameLength-1] of char;
  end;

  //18.09.2001
  PSeatParams=^TSeatParams;
  TSeatParams=packed record
    id:Integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PTypeDocParams=^TTypeDocParams;
  TTypeDocParams=packed record
    id:Integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PDocumParams=^TDocumParams;
  TDocumParams=packed record
    docum_id: Integer;
    typedoc_id: Integer;
    num: Array [0..DomainSmallNameLength-1] of char;
    datedoc: TDateTime;
    parent_id: Integer;
  end;

  PDepartParams=^TDepartParams;
  TDepartParams=packed record
    depart_id: Integer;
    name: Array [0..DomainNameLength-1] of char;
    code: Integer;
    ftype: Integer;
    parent_id: Integer;
  end;

  PBankParams=^TBankParams;
  TBankParams=packed record
    bank_id: Integer;
    name: Array [0..DomainNameLength-1] of char;
    bik: Array [0..DomainNameBik-1] of char;
    bikrkc: Array [0..DomainNameBik-1] of char;
    koraccount: Array [0..DomainNameAccount-1] of char;
    address: Array [0..DomainNameLength-1] of char;
  end;

  PTypeLeaveParams=^TTypeLeaveParams;
  TTypeLeaveParams = packed record
    TypeLeave_id : integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PTypePayParams=^TTypePayParams;
  TTypePayParams = packed record
    TypePay_id : Integer;
    Name: Array [0..DomainNameLength-1] of char;
  end;

  PExperiencePercentParams=^TExperiencePercentParams;
  TExperiencePercentParams = packed record
    ExperiencePercent_id :integer;
    percent :integer;
    TypePay_id :integer;
    Experience :integer;
  end;

  PStandartOperationParams=^TStandartOperationParams;
  TStandartOperationParams = packed record
    StandartOperation_id :integer;
    Name: Array [0..49] of char;
    Code: Array [0..30-1] of char;
  end;

  PAccountTypeParams=^TAccountTypeParams;
  TAccountTypeParams = packed record
    AccountType_id :integer;
    Name: Array [0..39] of char;
    Debit: Array [0..DomainBuhAccountLength-1] of char;
    Kredit: Array [0..DomainBuhAccountLength-1] of char;
  end;

  //Added by Volkov
  TSetMode=(smNone,smRectangle,smCols,smRows,smAll);

////*************************************************************
implementation

uses StrUtils, IBCustomDataSet, stdctrls, comctrls;

function ShowError(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstError,MB_ICONERROR);
end;

function ShowWarning(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstWarning,MB_ICONWARNING);
end;

function ShowInfo(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstInformation,MB_ICONINFORMATION);
end;

function ShowQuestion(Handle: THandle; Mess: String): Integer;
begin
 Result:=MessageBox(Handle,Pchar(Mess),ConstQuestion,MB_ICONQUESTION+MB_YESNO);
end;

function DeleteWarning(Handle: THandle; Mess: String): Integer;
begin
 Result:=ShowQuestion(Handle,CaptionDelete+' '+Mess);
{ Result:=MessageBox(Handle,(Pchar(CaptionDelete+' '+Mess)),
   ConstWarning,MB_YESNO+MB_ICONWARNING);}
end;

function GetRecordCount(qr: TIBQuery): Integer;
var
 sqls: string;
 Apos: Integer;
 newsqls: string;
 qrnew: TIBQuery;
const
 from='from';
begin
 Result:=0;
 try
  if not qr.Active then exit;
  sqls:=qr.SQL.Text;
  if Trim(sqls)='' then exit;
  Apos:=Pos(AnsiUpperCase(from),AnsiUpperCase(sqls));
  if Apos=0 then exit;
  newsqls:='Select count(*) as ctn from '+
           Copy(sqls,Apos+Length(from),Length(sqls)-Apos-Length(from));
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  try
   qrnew.Database:=qr.Database;
   qrnew.Transaction:=qr.Transaction;//Пусть работает в контексте передаваемой
//   qrnew.Transaction.Active:=true; //транзакции. Это позволяет сразу реагировать
                                     //на только что внесённые изменения
   qrnew.SQL.Add(newsqls);

   //Added by Volkov (needed for master-detail)
   qrnew.DataSource:=qr.DataSource;
   qrnew.Params.AssignValues(qr.Params);
   //////////////////////////////////////

   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin //Так круче :-)
//   if qrnew.RecordCount=1 then begin
     Result:=qrnew.FieldByName('ctn').AsInteger;
   end;
  finally
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

function GetGenId(DB: TIBDataBase; TableName: string; Increment: Word): Longword;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 Result:=0;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=DB;
   tran.AddDatabase(DB);
   DB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select (gen_id(gen_'+Tablename+'_id,'+inttostr(Increment)+')) from dual';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('gen_id').AsInteger;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TranslateIBError(Message: string): string;
var
  str: TStringList;
  APos: Integer;
  tmps: string;
const
  ExceptConst='exception';
  NewConst='Исключение №';
begin
  str:=TStringList.Create;
  try
   str.Text:=Message;
   if str.Count>1 then begin
     tmps:=str.Strings[0];
     APos:=Pos(ExceptConst,tmps);
     if APos<>0 then begin
{      tmps:=NewConst+Copy(tmps,APos+Length(ExceptConst)+1,
                          Length(tmps)-APos+Length(ExceptConst)+1);
      str.Strings[0]:=tmps;}

     end;
     str.Delete(0);
   end;
   Result:=str.Text;
  finally
   str.Free;
  end;
end;

procedure SetSelectedRowParams(var AFont:TFont;var ABackground:TColor);
begin
 AssignFont(_GetOptions.RBTableFont,AFont);
 ABackground:=_GetOptions.RBTableRecordColor;
end;

procedure SetSelectedColParams(var AFont:TFont;var ABackground:TColor);
begin
 ABackground:=_GetOptions.RBTableCursorColor;
end;

function StringToHexStr(S:String):String;
var I:Integer;
begin
 Result:='';
 for I:=1 to Length(S) do
  Result:=Result+IntToHex(Ord(S[I]),2)+'-';
 Delete(Result,Length(Result),1);
end;

function HexStrToString(S:String):String;
var I:Integer;
begin
 SetLength(Result,WordCount(S,['-']));
 for I:=1 to WordCount(S,['-']) do
  Result[I]:=Chr(Hex2Dec(ExtractWord(I,S,['-'])));
end;

procedure ChangeDataBase(Owner:TComponent;DB:TIBDatabase);
var I:Integer;
begin
 with Owner do
 begin
  try
   for I:=1 to ComponentCount do
    if Components[I-1] is TIBTransaction then
     with Components[I-1] as TIBTransaction do DefaultDatabase:=DB;
  except
  end;
  try
   for I:=1 to ComponentCount do
    if Components[I-1] is TIBCustomDataSet then
     with Components[I-1] as TIBCustomDataSet do Database:=DB;
  except
  end;
 end;
end;

procedure SetMinColumnsWidth(Columns: TDBGridColumns);
var I:Integer;
begin
 for I:=1 to Columns.Count do
  Columns[I-1].Width:=90;
end;

procedure ClearFields(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  if wt=nil then exit;
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    if ct is TWinControl then begin
      ClearFields(TWinControl(ct));
    end;
    if ct is TEdit then begin
      TEdit(ct).Text:='';
    end;
    if ct is TComboBox then begin
      TComboBox(ct).ItemIndex:=-1;
      TComboBox(ct).Text:='';
    end;
    if ct is TMemo then begin
      TMemo(ct).Clear;
    end;
    if ct is TDateTimePicker then begin
      TDateTimePicker(ct).Checked:=false;
    end;

  end;
end;

function isFloat(Value: string): Boolean;
begin
 try
   strtofloat(value);
   Result:=true;
 except
   Result:=false;
 end;
end;

function isInteger(Value: string): Boolean;
var
  i: Integer;
begin
  Result:=false;
  if Length(Value)=0 then exit;
  for i:=1 to Length(Value) do begin
    if not (Value[i] in ['0'..'9'])  then begin
     Result:=false;
     exit;
    end;
  end;
  Result:=true;
end;

function ChangeChar(Value: string; chOld, chNew: char): string;
var
  i: Integer;
  tmps: string;
begin
  for i:=1 to Length(Value) do begin
    if Value[i]=chOld then
     Value[i]:=chNew;
    tmps:=tmps+Value[i];
  end;
  Result:=tmps;
end;

function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
begin
 if isNotEmpty then
  Result:=STrue
 else Result:=SFalse;
end;

function FieldToVariant(Field: TField): OleVariant;
begin
  Result := '';
  case Field.DataType of
    ftString, ftFixedChar, ftWideString, ftMemo, ftFmtMemo: Result := '''' + Field.AsString;
    ftSmallint, ftInteger, ftWord, ftLargeint, ftAutoInc: Result := Field.AsInteger;
    ftFloat, ftCurrency, ftBCD: Result := Field.AsFloat;
    ftBoolean: Result := Field.AsBoolean;
    ftDate, ftTime, ftDateTime: Result := Field.AsDateTime;
  end;
end;

function TranslateSqlOperator(Operator: String): string;
begin
  Result:='';
  if Operator=SelConst then Result:=ConstSelect;
  if Operator=InsConst then Result:=ConstInsert;
  if Operator=UpdConst then Result:=ConstUpdate;
  if Operator=DelConst then Result:=ConstDelete;
end;

procedure AssignFont(inFont,outFont: TFont);
begin
  outFont.FontAdapter:=inFont.FontAdapter;
  outFont.Name:=inFont.Name;
  outFont.PixelsPerInch:=inFont.PixelsPerInch;
  outFont.Charset:=inFont.Charset;
  outFont.Color:=inFont.Color;
  outFont.Height:=inFont.Height;
  outFont.Pitch:=inFont.Pitch;
  outFont.Size:=inFont.Size;
  outFont.Style:=inFont.Style;
end;


end.
