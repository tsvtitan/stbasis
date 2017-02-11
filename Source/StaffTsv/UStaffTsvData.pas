unit UStaffTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls;

type
  TTypeStaffTsvOptions=(tstoNone,tstoRBEmp);

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

  hInterfaceRbkEmpConnect: THandle;
  hInterfaceRbkEmpSciencename: THandle;
  hInterfaceRbkEmpLanguage: THandle;
  hInterfaceRbkEmpChildren: THandle;
  hInterfaceRbkEmpProperty: THandle;
  hInterfaceRbkEmpStreet: THandle;
  hInterfaceRbkEmpPersonDoc: THandle;
  hInterfaceRbkEmpMilitary: THandle;
  hInterfaceRbkEmpDiplom: THandle;
  hInterfaceRbkEmpBiography: THandle;
  hInterfaceRbkEmpPhoto: THandle;
  hInterfaceRbkEmpPlant: THandle;
  hInterfaceRbkEmpFaceAccount: THandle;
  hInterfaceRbkEmpSickList: THandle;
  hInterfaceRbkEmpLaborBook: Thandle;
  hInterfaceRbkEmpRefreshCourse: THandle;
  hInterfaceRbkEmpLeave: THandle;
  hInterfaceRbkEmpQual: THandle;
  hInterfaceRbkEmpEncouragements: THandle;
  hInterfaceRbkEmpBustripsfromus: Thandle;
  hInterfaceRbkEmpReferences: THandle;
  hInterfaceRbkEmp: THandle;
  hInterfaceRbkProperty: THandle;
  hInterfaceRbkProfession: THandle;
  hInterfaceRbkTypeStud: THandle;
  hInterfaceRbkEduc: THandle;
  hInterfaceRbkCraft: THandle;
  hInterfaceRbkSciencename: THandle;
  hInterfaceRbkLanguage: THandle;
  hInterfaceRbkKnowLevel: THandle;
  hInterfaceRbkSchool: THandle;
  hInterfaceRbkMilRank: THandle;
  hInterfaceRbkRank: THandle;
  hInterfaceRbkGroupmil: THandle;
  hInterfaceRbkReady: THandle;
  hInterfaceRbkAny: THandle;
  hInterfaceRbkTypeReferences: THandle;
  hInterfaceRbkConnectiontype: THandle;
  hInterfaceRbkTypeRelation: Thandle;
  hInterfaceRbkFamilystate: THandle;
  hInterfaceRbkTypeEncouragements: THandle;
  hInterfaceRbkSex: THandle;
  hInterfaceRbkTypeResQual: THandle;
  hInterfaceRbkBustripstous: THandle;
  hInterfaceRbkAddAccount: Thandle;
  hInterfaceRbkPlant: THandle;
  hInterfaceRbkCurrency: THandle;
  hInterfaceRbkRateCurrency: THandle;
  hInterfaceRbkTypeLive: THandle;
  hInterfaceRptEmpUniversal: THandle;

  hMenuTest: THandle;
  hMenuRBooks: THandle;
  hMenuRBooksStaff: THandle;
  hMenuRBooksEmp: THandle;
  hMenuRBooksProperty: THandle;
  hMenuRBooksEducations: THandle;
  hMenuRBooksProfession: THandle;
  hMenuRBooksTypeStud: THandle;
  hMenuRBooksEduc: THandle;
  hMenuRBooksCraft: THandle;
  hMenuRBooksSciencename: THandle;
  hMenuRBooksLanguage: THandle;
  hMenuRBooksKnowLevel: THandle;
  hMenuRBooksSchool: THandle;
  hMenuRBooksMilitaryes: THandle;
  hMenuRBooksMilRank: THandle;
  hMenuRBooksRank: THandle;
  hMenuRBooksGroupmil: THandle;
  hMenuRBooksReady: THandle;
  hMenuRBooksAny: THandle;
  hMenuRBooksTypeReferences: THandle;
  hMenuRBooksConnectiontype: THandle;
  hMenuRBooksTypeRelation: Thandle;
  hMenuRBooksFamilystate: THandle;
  hMenuRBooksTypeEncouragements: THandle;
  hMenuRBooksSex: THandle;
  hMenuRBooksTypeResQual: THandle;
  hMenuRBooksBustripstous: THandle;
  hMenuRBooksFinances: THandle;
  hMenuRBooksPlant: THandle;
  hMenuRBooksCurrency: THandle;
  hMenuRBooksRateCurrency: THandle;
  hMenuRBooksATE: THandle;
  hMenuRBooksTypeLive: THandle;
  hMenuRpts: THandle;
  hMenuRptsStaff: THandle;
  hMenuRptsEmpUniversal: THandle;

  hOptionRBooks: THandle;
  hOptionEmp: THandle;

  hToolButtonEmp: THandle;

const
    LibraryHint='Библиотека содержит справочники и отчеты необходимые для кадров.';
{    LibraryHint='содержит справочники:'+#13+
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
  ConstDefaultPassword='1234567890';
  ConstEmpInnLength=12;
  crImageMove=300;
  crImageDown=301;
  CursorMove='CRIMAGEMOVE';
  CursorDown='CRIMAGEDOWN';

  ConstTypeEntry='te';
  ConstToolBar='tb';
  ConstSectionShortCut='StafftsvHotKeys';

  ConstRBEmpClassName='TfmRBEmp';
  ConstRBEmpMultiLine='MultiLine';

  // Reports Consts
  NameRptEmpUniversal='Универсальный отчет по сотрудникам';

  // Formats

  fmtEmpConnect='%s (%s)';
  ConstFieldPayOverrun='Значение поля <%s> не входит в границы между %s и %s, Продолжить ?';
  ConstFieldStaffCountOverrun='Больше нет ставок в отделе <%s> '+
                              'на должность <%s> по разряду <%s>, Продолжить ?';

  // Interface Names

  NameRbkProfession='Справочник специальностей по диплому';
  NameRbkTypeStud='Справочник видов обучения';
  NameRbkEduc='Справочник видов образований';
  NameRbkCraft='Справочник квалификаций по диплому';
  NameRbkSciencename='Справочник ученых званий';
  NameRbkLanguage='Справочник иностранных языков';
  NameRbkKnowlevel='Справочник уровней знаний';
  NameRbkMilrank='Справочник воинских званий';
  NameRbkRank='Справочник воинского состава';
  NameRbkReady='Справочник годности военнообязанных';
  NameRbkGroupmil='Справочник групп воинского учета';
  NameRbkConnectiontype='Справочник средств связи';
  NameRbkFamilystate='Справочник семейного положения';
  NameRbkProperty='Справочник групп сотрудников';
  NameRbkEmp='Справочник сотрудников';
  NameRbkEmpConnect='Справочник средств связи сотрудника';
  NameRbkEmpSciencename='Справочник ученых званий сотрудника';
  NameRbkEmpLanguage='Справочник иностранных языков сотрудника';
  NameRbkEmpChildren='Справочник детей сотрудника';
  NameRbkEmpProperty='Справочник признаков сотрудника';
  NameRbkEmpStreet='Справочник мест проживания сотрудника';
  NameRbkEmpPersonDoc='Справочник документов сотрудника';
  NameRbkEmpPlant='Справочник мест работы сотрудника';
  NameRbkEmpFaceAccount='Справочник лицевых счетов сотрудника';
  NameRbkEmpSickList='Справочник больничных листов сотрудника';
  NameRbkEmpLaborBook='Справочник трудовых книжек сотрудника';
  NameRbkEmpRefreshCourse='Справочник переподготовок сотрудника';
  NameRbkEmpLeave='Справочник отпусков сотрудника';
  NameRbkEmpQual='Справочник аттестаций сотрудника';
  NameRbkEmpEncouragements='Справочник поощрений и взысканий сотрудника';
  NameRbkEmpBustripsfromus='Справочник командировок сотрудника';
  NameRbkEmpReferences='Справочник справок сотрудника';
  NameRbkEmpMilitary='Справочник военного учета сотрудника';
  NameRbkEmpDiplom='Справочник дипломов сотрудника';
  NameRbkEmpBiography='Справочник биографий сотрудника';
  NameRbkEmpPhoto='Справочник фотографий сотрудника';
  NameRbkPlant='Справочник контрагентов';
  NameRbkSchool='Справочник учебных заведений';
  NameRbkTypeRelation='Справочник категорий родственников';
  NameRbkTypeLive='Справочник видов проживаний';
  NameRbkSex='Справочник пола';
  NameRbkCurrency='Справочник валют';
  NameRbkRateCurrency='Справочник курса валют';
  NameRbkSick='Справочник болезней';
  NameRbkTypeEncouragements='Справочник видов поощрений';
  NameRbkTypeResQual='Справочник типов результатов аттестации';
  NameRbkBustripstous='Справочник командировок к нам';
  NameRbkAddAccount='Справочник дополнительных р/счетов';
  NameRbkConsts='Справочник констант';
  NameRbkEmpPlantSchedule='Места работы сотрудника - Графики';
  NameRbkFactPay='Фактические оклады';
  NameRbkNation='Справочник национальностей';
  NameRbkCountry='Справочник стран';
  NameRbkRegion='Справочник краев и областей';
  NameRbkStreet='Справочник улиц';
  NameRbkTown='Справочник городов';
  NameRbkState='Справочник районов';
  NameRbkPlacement='Справочник населённых пунктов';
  NameRbkPersonDocType='Справочник видов документов удостоверяющих личность';
  NameRbkDocum='Справочник документов';
  NameRbkSeat='Справочник должностей';
  NameRbkDepart='Справочник отделов';
  NameRbkMotive='Справочник причин увольнений';
  NameRbkProf='Справочник профессий';
  NameRbkBAnk='Справочник банков';
  NameRbkTypeLeave='Справочник видов отпусков';
  NameRbkTypeReferences='Справочник видов справок';
  NameRbkSeatClass='Штатное расписание';
  NameRbkNet='Справочник сеток';
  NameRbkClass='Справочник разрядов';
  NameRbkCategory='Справочник категорий';
  NameRbkSchedule='Редактор графиков и норм времени';
  NameRbkAbsence='Справочник видов неявок';
  NameJrDocum='Журнал документов';


  // Db Objects

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
  tbFamilystate='familystate';
  tbProperty='property';
  tbEmp='emp';
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
  tbTypeLive='typelive';
  tbSex='sex';
  tbCurrency='currency';
  tbRateCurrency='ratecurrency';
  tbSick='sick';
  tbTypeEncouragements='typeencouragements';
  tbTypeResQual='typeresqual';
  tbBustripstous='bustripstous';
  tbAddAccount='addaccount';
  tbConsts='const';
  tbEmpPlantSchedule='empplantschedule';
  tbFactPay='factpay';
  tbNation='nation';
  tbCountry='country';
  tbRegion='region';
  tbStreet='street';
  tbTown='town';
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
  tbTypeReferences='typereferences';
  tbNet='net';
  tbClass='class';
  tbCategory='category';
  tbAbsence='absence';
  tbSchedule='schedule';

  // Sqls


  SQLRbkEmpConnect='Select ec.*,ct.name as connectiontypename from '+
                   tbEmpConnect+' ec join '+tbConnectiontype+
                   ' ct on ec.connectiontype_id=ct.connectiontype_id ';

  SQLRbkEmpSciencename='Select sn.*,s.name as sciencename,sc.name as schoolname from '+
                       tbEmpSciencename+' sn join '+tbSciencename+
                       ' s on sn.sciencename_id=s.sciencename_id join '+tbSchool+
                       ' sc on sn.school_id=sc.school_id ';

  SQLRbkEmpLanguage='Select el.*,l.name as languagename,kl.name as knowlevelname from '+
                    tbEmpLanguage+' el join '+tbLanguage+
                    ' l on el.language_id=l.language_id join '+tbKnowlevel+
                    ' kl on el.knowlevel_id=kl.knowlevel_id ';

  SQLRbkEmpChildren='Select ec.*,tr.name as typerelationname,s.name as sexname from '+
                    tbEmpChildren+' ec'+
                    ' join '+tbTypeRelation+' tr on ec.typerelation_id=tr.typerelation_id'+
                    ' left join '+tbSex+' s on ec.sex_id=s.sex_id ';
  SQLRbkEmpProperty='Select ep.*,p.name as propertyname from '+tbEmpProperty+
                    ' ep join '+tbProperty+' p on ep.property_id=p.property_id ';
  SQLRbkEmpStreet='Select es.*,s.name as streetname,'+
                  ' tl.name as typelivename,t.name as townname,t.code as towncode,'+
                  'ct.name as countryname,r.name as regionname,r.code as regioncode,'+
                  'st.name as statename,pm.name as placementname, st.code as statecode,'+
                  'pm.code as placementcode'+
                  ' from '+tbEmpStreet+' es '+
                  ' join '+tbTypelive+' tl on es.typelive_id=tl.typelive_id'+
                  ' left join '+tbCountry+' ct on es.country_id=ct.country_id'+
                  ' left join '+tbRegion+' r on es.region_id=r.region_id'+
                  ' left join '+tbState+' st on es.state_id=st.state_id'+
                  ' left join '+tbTown+' t on es.town_id=t.town_id'+
                  ' left join '+tbPlaceMent+' pm on es.placement_id=pm.placement_id'+
                  ' left join '+tbStreet+' s on es.street_id=s.street_id ';
  SQLRbkEmpPersonDoc='Select epd.*,pdt.name as persondoctypename,pdt.masknum as masknum,'+
                     'pdt.maskseries as maskseries,p.smallname as plantname,pdt.maskpodrcode from '+tbEmpPersonDoc+
                     ' epd join '+tbPersonDocType+' pdt on epd.persondoctype_id=pdt.persondoctype_id'+
                     ' join '+tbPlant+' p on epd.plant_id=p.plant_id ';
  SQLRbkEmpMilitary='Select m.*,'+
                    ' gm.name as groupmilname,r.name as rankname,rd.name as readyname,'+
                    ' mr.name as milrankname,p.smallname as plantname from '+tbMilitary+' m '+
                    ' join '+tbGroupMil+' gm on m.groupmil_id=gm.groupmil_id'+
                    ' join '+tbRank+' r on m.rank_id=r.rank_id'+
                    ' join '+tbMilRank+' mr on m.milrank_id=mr.milrank_id'+
                    ' join '+tbPlant+' p on m.plant_id=p.plant_id'+
                    ' join '+tbReady+' rd on m.ready_id=rd.ready_id ';
  SQLRbkEmpDiplom='Select d.*,'+
                  ' p.name as professionname,ts.name as typestudname,'+
                  ' e.name as educname,c.name as craftname,'+
                  ' s.name as schoolname'+
                  ' from '+tbDiplom+' d '+
                  ' join '+tbProfession+' p on d.profession_id=p.profession_id'+
                  ' join '+tbTypeStud+' ts on d.typestud_id=ts.typestud_id'+
                  ' join '+tbEduc+' e on d.educ_id=e.educ_id'+
                  ' join '+tbCraft+' c on d.craft_id=c.craft_id'+
                  ' join '+tbSchool+' s on d.school_id=s.school_id ';
  SQLRbkEmpBiography='Select * from '+tbBiography+' ';
  SQLRbkEmpPhoto='Select * from '+tbPhoto+' ';
  SQLRbkEmpPlant='Select ep.*,n.name as netname,c.num as classnum,p.smallname as plantname,'+
                 'rd.num as reasondocumnum,ct.name as categoryname,s.name as seatname,'+
                 'd.name as departname,od.num as orderdocumnum,m.name as motivename,'+
                 'pr.name as profname, dm.num as motivedocumnum'+
                 ' from '+tbEmpPlant+' ep '+
                 ' join '+tbNet+' n on ep.net_id=n.net_id'+
                 ' join '+tbClass+' c on ep.class_id=c.class_id'+
                 ' join '+tbPlant+' p on ep.plant_id=p.plant_id'+
                 ' join '+tbDocum+' rd on ep.reasondocum_id=rd.docum_id'+
                 ' join '+tbCategory+' ct on ep.category_id=ct.category_id'+
                 ' join '+tbSeat+' s on ep.seat_id=s.seat_id'+
                 ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
                 ' join '+tbDocum+' od on ep.orderdocum_id=od.docum_id'+
                 ' join '+tbProf+' pr on ep.prof_id=pr.prof_id'+
                 ' left join '+tbMotive+' m on ep.motive_id=m.motive_id'+
                 ' left join '+tbDocum+' dm on ep.motivedocum_id=dm.docum_id ';
  SQLRbkEmpFaceAccount='Select efa.*,c.name as currencyname,b.name as bankname'+
                       ' from '+tbEmpFaceAccount+' efa '+
                       ' join '+tbCurrency+' c on efa.currency_id=c.currency_id'+
                       ' join '+tbBank+' b on efa.bank_id=b.bank_id ';
  SQLRbkEmpSickList='Select sl.*,s.name as sickname,a.name as absencename'+
                    ' from '+tbEmpSickList+' sl '+
                    ' join '+tbSick+' s on sl.sick_id=s.sick_id'+
                    ' join '+tbAbsence+' a on sl.absence_id=a.absence_id ';
  SQLRbkEmpLaborBook='Select lb.*,pr.name as profname,p.smallname as plantname,m.name as motivename'+
                     ' from '+tbEmpLaborBook+' lb '+
                     ' join '+tbProf+' pr on lb.prof_id=pr.prof_id'+
                     ' join '+tbPlant+' p on lb.plant_id=p.plant_id'+
                     ' join '+tbMotive+' m on lb.motive_id=m.motive_id ';
  SQLRbkEmpRefreshCourse='Select rc.*,pr.name as profname,p.smallname as plantname,d.num as documnum,'+
                         'a.name as absencename'+
                         ' from '+tbEmpRefreshCourse+' rc '+
                         ' join '+tbProf+' pr on rc.prof_id=pr.prof_id'+
                         ' join '+tbPlant+' p on rc.plant_id=p.plant_id'+
                         ' join '+tbDocum+' d on rc.docum_id=d.docum_id'+
                         ' join '+tbAbsence+' a on rc.absence_id=a.absence_id ';
  SQLRbkEmpLeave='Select l.*,d.num as documnum,tl.name as typeleavename,a.name as absencename'+
                 ' from '+tbEmpLeave+' l '+
                 ' join '+tbDocum+' d on l.docum_id=d.docum_id'+
                 ' join '+tbTypeLeave+' tl on l.typeleave_id=tl.typeleave_id'+
                 ' join '+tbAbsence+' a on l.absence_id=a.absence_id ';
  SQLRbkEmpQual='Select q.*,d1.num as documnum,d2.num as resdocumnum, trq.name as typeresqualname'+
                ' from '+tbEmpQual+' q '+
                ' join '+tbDocum+' d1 on q.docum_id=d1.docum_id'+
                ' join '+tbDocum+' d2 on q.resdocum_id=d2.docum_id'+
                ' join '+tbTypeResQual+' trq on q.typeresqual_id=trq.typeresqual_id ';
  SQLRbkEmpEncouragements='Select e.*,d.num as documnum,te.name as typeencouragementsname'+
                          ' from '+tbEmpEncouragements+' e '+
                          ' join '+tbDocum+' d on e.docum_id=d.docum_id'+
                          ' join '+tbTypeEncouragements+' te on e.typeencouragements_id=te.typeencouragements_id ';
  SQLRbkEmpBustripsfromus='Select eb.*,d.num as documnum,'+
                          'ep.fname as empprojfname,ed.fname as empdirectfname,'+
                          'a.name as absencename'+
                          ' from '+tbEmpBustripsfromus+' eb '+
                          ' join '+tbDocum+' d on eb.docum_id=d.docum_id'+
                          ' join '+tbEmp+' ep on eb.empproj_id=ep.emp_id'+
                          ' join '+tbEmp+' ed on eb.empdirect_id=ed.emp_id'+
                          ' join '+tbAbsence+' a on eb.absence_id=a.absence_id ';
  SQLRbkEmpReferences='Select er.*,tr.name as typereferencesname'+
                      ' from '+tbEmpReferences+' er '+
                      ' join '+tbTypeReferences+' tr on er.typereferences_id=tr.typereferences_id ';

  SQLRbkEmp='Select distinct(e.emp_id),e.*, fs.name as familystatename, '+
            'n.name as nationname, '+
            's.shortname as sexshortname, s.name as sexname,'+
            'ct.name as countryname, ct.code as countrycode,'+
            'r.name as regionname, r.code as regioncode,'+
            'st.name as statename, st.code as statecode,'+
            't.name as townname, t.code as towncode,'+
            'pm.name as placementname, pm.code as placementcode '+
            'from '+
            tbEmp+' e join '+
            tbFamilystate+' fs on e.familystate_id=fs.familystate_id join '+
            tbNation+' n on e.nation_id=n.nation_id join '+
            tbSex+' s on e.sex_id=s.sex_id left join '+
            tbCountry+' ct on e.country_id=ct.country_id left join '+
            tbRegion+' r on e.region_id=r.region_id left join '+
            tbState+' st on e.state_id=st.state_id left join '+
            tbTown+' t on e.town_id=t.town_id left join '+
            tbPlaceMent+' pm on e.placement_id=pm.placement_id '+
            ' left join '+tbEmpPlant+' ep on e.emp_id=ep.emp_id ';
  SQLRbkProperty='Select * from '+tbProperty+' ';
  SQLRbkProfession='Select * from '+tbProfession+' ';
  SQLRbkTypeStud='Select * from '+tbTypeStud+' ';
  SQLRbkEduc='Select * from '+tbEduc+' ';
  SQLRbkCraft='Select * from '+tbCraft+' ';
  SQLRbkSciencename='Select * from '+tbSciencename+' ';
  SQLRbkLanguage='Select * from '+tbLanguage+' ';
  SQLRbkKnowLevel='Select * from '+tbKnowlevel+' ';
  SQLRbkSchool='Select s.school_id, s.town_id, s.parent_id, s.name as schoolname, t.name as townname from '+
               tbSchool+' s join '+tbTown+' t on s.town_id=t.town_id ';
  SQLRbkMilRank='Select * from '+tbMilrank+' ';
  SQLRbkRank='Select * from '+tbRank+' ';
  SQLRbkGroupmil='Select * from '+tbGroupmil+' ';
  SQLRbkReady='Select * from '+tbReady+' ';
  SQLRbkTypeReferences='Select * from '+tbTypeReferences+' ';
  SQLRbkConnectiontype='Select * from '+tbConnectiontype+' ';
  SQLRbkTypeRelation='Select * from '+tbTypeRelation+' ';
  SQLRbkFamilystate='Select * from '+tbFamilystate+' ';
  SQLRbkTypeEncouragements='Select * from '+tbTypeEncouragements+' ';
  SQLRbkSex='Select * from '+tbSex+' ';
  SQLRbkTypeResQual='Select * from '+tbTypeResQual+' ';
  SQLRbkBustripstous='Select b.*, p.smallname as plantname,s.name as seatname '+
                     ' from '+tbBustripstous+' b '+
                     ' join '+tbPlant+' p on b.plant_id=p.plant_id '+
                     ' join '+tbSeat+' s on b.seat_id=s.seat_id ';
  SQLRbkAddAccount='Select ac.*, p.smallname as plantname,'+
                   'b.name as bankname'+
                   ' from '+tbAddAccount+' ac '+
                   ' join '+tbPlant+' p on ac.plant_id=p.plant_id '+
                   ' join '+tbBank+' b on ac.bank_id=b.bank_id ';
  SQLRbkPlant='Select p.*,'+
              'b.name as bankname'+
              ' from '+tbPlant+' p '+
              ' left join '+tbBank+' b on p.bank_id=b.bank_id ';
  SQLRbkCurrency='Select * from '+tbCurrency+' ';
  SQLRbkRateCurrency='Select rc.*, c.name as currencyname from '+tbRateCurrency+' rc '+
                     ' join '+tbCurrency+' c on rc.currency_id=c.currency_id ';
  SQLRbkTypeLive='Select * from '+tbTypeLive+' ';


implementation

end.
