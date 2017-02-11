unit UDesignTsvData;

interface

{$I stbasis.inc}

uses Windows, Forms, Classes, Controls, IBDatabase, UMainUnited, stdctrls, RAHLEditor,
     Graphics, tsvSecurity;

type
  TReadWriteSymbolColor=class(TComponent)
  private
    FSymbolColor: TSymbolColor;
    procedure SetSymbolColor(SymbolColor: TSymbolColor);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
  published
    property SymbolColor: TSymbolColor read FSymbolColor write SetSymbolColor;
  end;

var
  isInitAll: Boolean=false;
  ListInterfaceHandles: TList;
  ListMenuHandles: Tlist;
  ListOptionHandles: TList;
  ListToolBarHandles: TList;

  ListEditInterfaceForms: TList;
  
  IBDB,IBDBSec: TIBDatabase;
  IBT,IBTSec: TIBTransaction;
  TempStr: String;
  inistr: string;
  testControl: TComboBox;
  MainTypeLib: TTypeLib=ttleDefault;
  FSecurity: TTsvSecurity;

  // Handles
  hOptionRBooks: THandle;
  hOptionRBInterface: THandle;
  hOptionScript: THandle;
  hOptionForms: THandle;
  hOptionDocs: THandle;


  hMenuServiceInterfaces: THandle;
  hMenuInterface: THandle;
  hMenuMenu: THandle;
  hMenuToolBar: THandle;
  hMenuToolbutton: THandle;
  hMenuInterfacePermission: THandle;

  hInterfaceRbkInterface: THandle;
  hInterfaceRbkMenu: THandle;
  hInterfaceRbkToolbar: THandle;
  hInterfaceRbkToolbutton: THandle;
  hInterfaceRbkInterfacePermission: THandle;

  hToolButtonInterface: THandle;
  hToolButtonMenu: THandle;
  hToolButtonToolbar: THandle;
  hToolButtonToolbutton: THandle;

  hAdditionalLogBuild: THandle;

const
  SKey='1AFA74DA05CA145D3418AAD9AF510109'; // Design
  LibraryHint='Библиотека содержит функции разработки интерфейсов. '+
              'Необходима для администрирования.';
  LibraryProgrammers='Томилов Сергей';            


  // Colors
  ConstColorVar=clMaroon;
  ConstColorProcedure=clTeal;
  ConstColorFunction=clBlue;
  ConstColorType=clOlive;
  ConstColorProperty=clNavy;
  ConstColorConst=clGreen;
  ConstColorBackGround=clWindow;

  ConstColorCaption=clBlack;
  ConstColorParams=clBlack;
  ConstColorValue=clBlue;
  ConstColorHint=clBtnFace;

  // Filters
  ConstFilterAllFiles='Все файлы (*.*)|*.*';
  ConstFilterPasFiles='Файлы скрипта (*.sc)|*.sc|Файлы Pascal (*.pas)|*.pas|Все файлы (*.*)|*.*';
  ConstFilterInterfaceFiles='Файлы интерфейса (*.itf)|*.itf|Все файлы (*.*)|*.*';

  // DefaultExt
  ConstDefaultPasExt='.sc';
  ConstDefaultInterfaceExt='.itf';

  // Sections
  ConstSectionOptions='DesignTsv';

  // Logs
  ConstBuildLogName='Интерпретатор';
  ConstBuildLogHint='Лог предназначенный для отображения сообщений интерпретатора';

  // Options
  ConstOptionScript='Редактор скрипта';
  ConstOptionForms='Редактор форм';
  ConstOptionDocs='Редактор документов';

  ConstDefaultRAEditorText='unit Main;'+#13+
                           '{ модуль разработан ФИО }'+#13+#13+
                           'interface'+#13+#13+#13+#13+
                           'implementation'+#13+#13+
                           'procedure ViewInterface;'+#13+
                           'begin'+#13+#13+
                           'end;'+#13+#13+
                           'end.';
   ConstDefaultRAEditorCompletition=
      'arrayd==array declaration (var)==array[0..|] of ;'+#13+
      'arrayc==array declaration (const)==array[0..|] of = ();'+#13+
      'cases==case statement==case | of/n  : ;/n  : ;/nend;/n'+#13+
      'casee==case statement (with else)==case | of/n  : ;/n  : ;/nelse ;/nend;/n'+#13+
      'classf==class declaration (all parts)==T| = class(T)/nprivate/n/nprotected/n/npublic/n/npublished/n/nend;/n'+#13+
      'classd==class declaration (no parts)==T| = class(T)/n/nend;/n'+#13+
      'classc==class declaration (with Create/Destroy overrides)==T| = class(T)/nprivate/n/nprotected/n/npublic/n  constructor Create; override;/n  destructor Destroy; override;/npublished/n/nend;/n'+#13+
      'desc==описание модуля=={ модуль разработан | }'+#13+
      'fors==for (no begin/end)==for | :=  to  do/n'+#13+
      'forb==for statement==for | :=  to  do/nbegin/n/nend;/n'+#13+
      'function==function declaration==function |(): ;/nbegin/n/nend;/n'+#13+
      'ifs==if (no begin/end)==if | then/n'+#13+
      'ifb==if statement==if | then/nbegin/n/nend;/n'+#13+
      'ife==if then (no begin/end) else (no begin/end)==if | then/n/nelse/n'+#13+
      'ifbe==if then else==if | then/nbegin/n/nend/nelse/nbegin/n/nend;/n'+#13+
      'procedure==procedure declaration==procedure |();/nbegin/n/nend;/n'+#13+
      'trye==try except==try/n  |/nexcept/n/nend;/n'+#13+
      'tryf==try finally==try/n  |/nfinally/n/nend;/n'+#13+
      'trycf==try finally (with Create/Free)==|variable := typename.Create;/ntry/n/nfinally/nvariable.Free;/nend;/n'+#13+
      'whileb==while statement==while | do/nbegin/n/nend;/n'+#13+
      'whiles==while (no begin)==while | do/n'+#13+
      'withb==with statement==with | do/nbegin/n/nend;/n'+#13+
      'withs==with (no begin)==with | do/n';

   // Formats
   ConstFmtStatusRowColScriptEditor='%d: %d';
   ConstFmtMaxLine='Значение не входит в интервал от %d до %d';
   ConstFmtStringNotFound='Искомая строка <%s> не найдена';
   ConstFmtYourRealyLoadInterface='Вы действительно хотите загрузить интерфейс?';
   fmtPermOnColumn='%s - %s';

  // Interpreter
  ConstInterpreterReset='Выполнение модуля прервано';

  // Designer color names;
  ConstRBRFColorsHandleClr='Только одного объекта';
  ConstRBRFColorsHandleBorderClr='Рамка только одного объекта';
  ConstRBRFColorsMultySelectHandleClr='Многих объектов';
  ConstRBRFColorsMultySelectHandleBorderClr='Рамка многих объектов';
  ConstRBRFColorsInactiveHandleClr='При потере фокуса';
  ConstRBRFColorsInactiveHandleBorderClr='Рамка при потере фокуса';
  ConstRBRFColorsLockedHandleClr='При блокировке';

    // Cursors
  crImageMove=300;
  crImageDown=301;
  CursorMove='CRIMAGEMOVE';
  CursorDown='CRIMAGEDOWN';


  // Interface Names
  NameRbkQuery='Запрос';
  NameRbkInterface='Справочник интерфейсов';
  NameRbkMenu='Справочник меню';
  NameRbkToolbar='Справочник панелей инструментов';
  NameRbkToolbutton='Справочник элементов панелей';
  NameRbkInterfacePermission='Справочник прав интерфейса';

  // db Objects
  tbSysRelations='rdb$relations';
  tbSysProcedures='rdb$procedures';
  tbInterface='interface';
  tbMenu='menu';
  tbToolbar='toolbar';
  tbToolbutton='toolbutton';
  tbInterfaceForm='interfaceform';
  tbInterfaceDocument='interfacedocument';
  tbInterfacePermission='interfacepermission';

  // SQL

  SQLRbkInterface='Select interface_id,name,hint,interfacetype,changeflag,autoflag,interpreterguid,'+
                  'priority from '+tbInterface+' ';
  SQLRbkMenu='Select m.*,i.name as interfacename from '+
              tbMenu+' m left join '+
              tbInterface+' i on m.interface_id=i.interface_id ';
  SQLRbkToolbar='Select * from '+tbToolBar+' ';
  SQLRbkToolbutton='Select tb.*,t.name as toolbarname,i.name as interfacename from '+
                   tbToolbutton+' tb join '+
                   tbToolbar+' t on tb.toolbar_id=t.toolbar_id left join '+
                   tbInterface+' i on tb.interface_id=i.interface_id ';
  SQLRbkInterfacePermission='Select ip.*,i.name as interfacename from '+
                            tbInterfacePermission+' ip join '+
                            tbInterface+' i on ip.interface_id=i.interface_id ';

  // Version
  ConstInterfaceVersion_1=1;

implementation

{ TReadWriteSymbolColor }


constructor TReadWriteSymbolColor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSymbolColor:=TSymbolColor.Create;
end;

destructor TReadWriteSymbolColor.Destroy;
begin
  FSymbolColor.Free;
  inherited;
end;

procedure TReadWriteSymbolColor.SetSymbolColor(SymbolColor: TSymbolColor);
begin
  FSymbolColor.Assign(SymbolColor);
end;


initialization
  FSecurity:=TTsvSecurity.Create;
  FSecurity.Key:=SKey;

finalization
  FSecurity.Free;
  
end.
