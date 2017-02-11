unit USalBafConst;

interface
uses Forms, Classes, IBDatabase, UmainUnited;
var
  AppOld: TApplication;
  ScrOld: TScreen;
  LERoot: Tlist; // содержит структуру меню
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  IniStr: String;
  MainTypeLib: TSetTypeLib=[ttlRBooks,ttlReports,ttlOperations,ttlDocuments,
    ttlService];
  ListOptionsRoot: TList;
  
const
  LibraryHint='Содержит пока неизвестно что';
  ConstTypeEntry='te';
  ConstSectionShortCut='SalaryBAFHotKeys';

implementation

end.
