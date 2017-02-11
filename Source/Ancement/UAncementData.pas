unit UAncementData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, extctrls, Graphics,
     tsvSecurity;

type
  TTypeStaffTsvOptions=(tstoNone,tstoRBEmp);

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

  hInterfaceRbkRelease: THandle;
  hInterfaceRbkKeyWords: THandle;
  hInterfaceRbkBlackList: THandle;
  hInterfaceRbkAutoReplace: THandle;
  hInterfaceRbkTreeHeading: THandle;
  hInterfaceRbkAnnouncement: THandle;
  hInterfaceRbkAnnouncementDubl: THandle;
  hInterfaceRbkRusWords: THandle;
  hInterfaceRbkAnnStreet: THandle;
  hInterfaceRbkAnnStreetTree: THandle;
  hInterfaceRptExport: THandle;
  hInterfaceSrvImport: THandle;
  hInterfaceRptTreeHeading: THandle;
  hInterfaceRbkPublishing: THandle;


  hMenuRBooks: THandle;
  hMenuRBooksFree: THandle;
  hMenuRBooksRelease: THandle;
  hMenuRBooksKeyWords: THandle;
  hMenuRBooksBlackList: THandle;
  hMenuRBooksAutoReplace: THandle;
  hMenuRBooksTreeHeading: THandle;
  hMenuRBooksRusWords: THandle;
  hMenuRBooksAnnStreet: THandle;
  hMenuRBooksAnnStreetTree: THandle;
  hMenuRBooksPublishing: THandle;
  hMenuData: THandle;

  hMenuRpts: THandle;
  hMenuRptsFree: THandle;
  hMenuRptsExport: THandle;
  hMenuRptsTreeHeading: THandle;

  hMenuOpts: THandle;
  hMenuOptsFree: THandle;
  hMenuOptsAnnouncement: THandle;
  hMenuOptsAnnouncementDubl: THandle;
  hMenuOptsImport: THandle;

  hOptionRBooks: THandle;
  hOptionAnnouncement: THandle;
  hOptionReports: THandle;
  hOptionExport: THandle;
  hOptionOperations: THandle;
  hOptionImport: THandle;
  hOptionExportTreeHeading: THandle;

  hToolButtonRelease: THandle;
  hToolButtonKeyWords: THandle;
  hToolButtonBlackList: THandle;
  hToolButtonTreeHeading: THandle;
  hToolButtonAnnouncement: THandle;
  hToolButtonAnnouncementDubl: THandle;
  hToolButtonExport: THandle;
  hToolButtonImport: THandle;

  hAboutTest: THandle;


const
  SKey='6345A0BB5720E45AE6B5519272BCE431'; // Annfree

  LibraryHint='Содержит справочники и отчеты необходимые для формирования бесплатных объявлений.';
  LibraryProgrammers='Томилов Сергей';            

  ConstCreateTreeHeading='Создание рубрикатора';
  ConstCreateAnnouncement='Создание объявлений';
  ConstLoadExportToResult='Загрузка объявлений в результат';
  ConstsMenuRBooksAnnFree='Бесплатные';
  ConstsMenuOptsFree=ConstsMenuRBooksAnnFree;
  ConstsMenuRptsFree=ConstsMenuRBooksAnnFree;
  
  // formats

  fmtExportCountPlusTime='Всего экспортировано %d объявления(ий) за время %s';
  fmtExportTreeheading='Рубрика %s %d';
  fmtBuildFor='Библиотека: %s'+#13+'разработана специально для газеты: %s';
  fmtTreeHeadingInsertSql='%s,%s,%s,%s';
  fmtAnnouncementInsertSql='%s,%s,%s,%s,%s,%s';
  fmtDateTimeExportForSite='yyyy-mm-dd hh:nn:ss';

  FileNameTreeHeadingXml='treeheading.xml';
  FileNameTreeHeadingRtf='treeheading.rtf';
  FileNameTreeHeadingTxt='treeheading.txt';

  // Sections
  ConstSectionOptions='AncementOptions';

  // Formats

  // About Marquee
  ConstNewsPaper='"НОВЫЕ ВРЕМЕНА"';

  // Interface Names

  NameRbkRelease='Справочник выпусков';
  NameRbkKeyWords='Ключевые слова';
  NameRbkBlackList='Исключения объявлений';
  NameRbkAutoReplace='Автозамена';
  NameRbkTreeHeading='Дерево рубрик';
  NameRbkAnnouncement='Бесплатные объявления';
  NameRbkAnnouncementDubl='Дублированные объявления';
  NameRbkRusWords='Словарь русских слов';
  NameRbkAnnStreet='Улицы';
  NameRbkAnnStreetTree='Дерево рубрик - улицы';
  NameRbkQuery='Запрос';
  NameRbkPublishing='Справочник изданий';

  NameRptExport='Экспорт данных для верстки';
  NameRptTreeHeading='Экспорт рубрикатора';

  NameSrvImport='Импорт бесплатных';

  // Db Objects

  tbRelease='"RELEASE"';
  tbKeyWords='keywords';
  tbBlackList='blacklist';
  tbAutoReplace='auto_replace';
  tbTreeHeading='treeheading';
  tbAnnouncement='announcement';
  tbRusWords='ruswords';
  tbAnnStreet='ann_street';
  tbAnnStreetTree='ann_streettreeheading';
  tbPublishing='publishing';

  prGetTreeHeadingName='gettreeheadingname';
  prCreateTreeHeading='createtreeheading';

  fsys_CompareStrByWord='sys_CompareStrByWord';

  // Sqls


  SQLRbkRelease='Select r.*, p.name as publishing_name from '+
                tbRelease+' r join '+tbPublishing+' p on r.publishing_id=p.publishing_id ';

  SQLRbkPublishing='Select * from '+tbPublishing+' ';
  SQLRbkKeyWords='Select kw.*, th.nameheading as treeheadingname from '+
                 tbKeywords+' kw join '+tbTreeHeading+' th on kw.treeheading_id=th.treeheading_id ';
  SQLRbkBlacklist='Select * from '+tbBlackList+' ';
  SQLRbkAutoReplace='Select * from '+tbAutoReplace+' ';
  SQLRbkTreeHeading='Select * from '+tbTreeHeading+' ';
  SQLRbkAnnouncement='Select SubstrEx(a.textannouncement,1,50) as texta,a.textannouncement,'+
                     'a.contactphone,a.homephone,a.workphone,a.indate,a.whoin,a.changedate,a.whochange,'+
                     'a.announcement_id,a.release_id,a.treeheading_id,'+
                     'a.word_id,a.copyprint,a.about,'+
                     'addstr(r.about,'' (''||r.numrelease||'')'','''') as releasenumrelease,'+
                     'r.daterelease as releasedaterelease, '+
                     '(select %s||nameheading||%s from '+prGetTreeHeadingName+'(%s,t.treeheading_id,1))as treeheadingnameheading, '+
//                     't.nameheading as treeheadingnameheadingex, '+
                     'k.word as keywordsword from '+tbAnnouncement+' a join '+tbRelease+
                     ' r on a.release_id=r.release_id join '+tbTreeHeading+
                     ' t on a.treeheading_id=t.treeheading_id left join '+tbKeyWords+
                     ' k on a.word_id=k.word_id ';
  SQLRbkAnnouncementDouble='Select '+fsys_CompareStrByWord+'(%s,a.textannouncement) as outpercent, '+
                           'a.textannouncement,'+
                           'a.contactphone,a.homephone,a.workphone,a.indate,a.whoin,a.changedate,a.whochange,'+
                           'a.announcement_id,'+
                           'a.copyprint,a.about,'+
                           'addstr(r.about,'' (''||r.numrelease||'')'','''') as releasenumrelease,'+
                           'r.daterelease as releasedaterelease, '+
                           '(select %s||nameheading||%s from '+prGetTreeHeadingName+'(%s,t.treeheading_id,1))as treeheadingnameheading, '+
                           'k.word as keywordsword '+
                           'from '+tbAnnouncement+' a join '+tbRelease+
                           ' r on a.release_id=r.release_id join '+tbTreeHeading+
                           ' t on a.treeheading_id=t.treeheading_id, '+tbKeyWords+' k '+
                           'where a.word_id=+k.word_id and '+
                           'a.release_id=%s and '+
                           'a.announcement_id<>%s '+
                           'and '+fsys_CompareStrByWord+'(%s,a.textannouncement)>=%d '+
                           'order by 1 desc ';
  SQLRbkAnnouncementImport='Select a.textannouncement,'+
                     'a.contactphone,a.homephone,a.workphone,a.indate,a.whoin,a.changedate,a.whochange,'+
                     'a.announcement_id,a.release_id,a.treeheading_id,'+
                     'a.word_id,a.copyprint,a.about,'+
                     'r.numrelease as releasenumrelease,'+
                     'r.daterelease as releasedaterelease, t.nameheading as treeheadingnameheading, '+
                     'k.word as keywordsword from '+tbAnnouncement+' a join '+tbRelease+
                     ' r on a.release_id=r.release_id join '+tbTreeHeading+
                     ' t on a.treeheading_id=t.treeheading_id left join '+tbKeyWords+
                     ' k on a.word_id=k.word_id ';

  SQLRbkAnnouncementExport='Select addstr(Upper(k.word),SubstrEx(Upper(a.textannouncement),1,80),''''),a.textannouncement,'+
                           'a.contactphone,a.homephone,a.workphone,'+
                           'r.numrelease as releasenumrelease,'+
                           'r.daterelease as releasedaterelease, t.nameheading as treeheadingnameheading, '+
                           'k.word as keywordsword from '+tbAnnouncement+' a join '+tbRelease+
                           ' r on a.release_id=r.release_id join '+tbTreeHeading+
                           ' t on a.treeheading_id=t.treeheading_id left join '+tbKeyWords+
                           ' k on a.word_id=k.word_id ';

  SQLRbkAnnouncementDubl='Select a.*, r.numrelease as releasenumrelease, '+
                     'r.daterelease as releasedaterelease, t.nameheading as treeheadingnameheading, '+
                     'k.word as keywordsword from '+tbAnnouncement+' a join '+tbRelease+
                     ' r on a.release_id=r.release_id join '+tbTreeHeading+
                     ' t on a.treeheading_id=t.treeheading_id left join '+tbKeyWords+
                     ' k on a.word_id=k.word_id ';

  SQLRbkRusWords='Select * from '+tbRusWords+' ';
  SQLRbkAnnStreet='Select * from '+tbAnnStreet+' ';
  SQLRbkAnnStreetTree='Select ast.*, th.nameheading as treeheadingname, a.name as streetname from '+
                       tbAnnStreetTree+' ast join '+
                       tbTreeHeading+' th on ast.treeheading_id=th.treeheading_id join '+
                       tbAnnStreet+' a on ast.ann_street_id=a.ann_street_id ';
  SQLRptTreeHeading='Select treeheading_id,nameheading,parent_id,font,sortnumber from '+tbTreeHeading+' ';{*+
                    'order by treeheading_id,sortnumber ';                                 *}

implementation

initialization
  FSecurity:=TTsvSecurity.Create;
  FSecurity.Key:=SKey;

finalization
  FSecurity.Free;

end.
