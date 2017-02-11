{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1997,99 Inprise Corporation       }
{                                                       }
{ Руссификация: 1998-99 Polaris Software                }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit mxConsts;

{$R mxconsts.RES}

interface

{$IFDEF VER130}
const
  { DecisionCube Dialog help contexts }
  hcDDecisionCubeEditor = 30170;
  hcDDecisionCubeDimensions = 30171;
  hcDDecisionCubeMemoryControl = 30172;
  hcDDecisionCubeDesignerOptions = 30173;
  hcDDecisionCubeLimits = 30174;
  hcDDecisionQueryEditor = 30180;
  hcDDecisionQueryDimensions = 30181;
  hcDDecisionQuerySQLEditor = 30182;
{$ENDIF}

resourcestring
{$IFDEF VER130}
  sRowError             = 'ошибка строки';
{$ENDIF}
  { Strings used in the Pivot }
  sAllValues            = 'All Values';
  sMovetoRow            = 'Move to Row Area';
  sMovetoCol            = 'Move to Column Area';
  sMakeDimOpen          = 'Open Dimension';
  sDrilled              = 'Drilled In';
  sCouldNotOpen         = 'Требуемая информация не может быть загружена. ';
  sNoSumsAvailable      = 'Не были определены активные итоги. ';
  sNoSumsCouldBeLoaded  = 'Для загрузки итога не хватает места. ';
  sNoDimsAvailable      = 'Не были определены доступные измерения. ';
  sNoDimsCouldBeLoaded  = 'Для загрузки измерения не хватает места. ';

  sTemplatePrefix       = 'Template: ';
  { Strings used in the CrossTabGrid }
  sGridCellError        = '[Ошибка]';
  sTotalCaption         = 'Сумма';
  sActivateLabel        = 'Inactive Dimensions';
  sRowCaption           = 'R';
  sColCaption           = 'C';
  sCaptionMenu1         = 'Вывод данных и частичных итогов';
  sCaptionMenu2         = 'Вывод только данных';
  sCaptionMenu3         = 'Вывод только частичных итогов';
  sDrillIn              = 'Drill in to this value';
  sGridMenu1            = 'Част.итоги вкл/выкл';
  sGridMenu2            = 'Редактор Decision Cube..';
  sGridMenu3            = 'Редактор Decision Query..';
  sGridMenu4            = 'Вывод записей детализации..';

  { Strings used in mxarrays }
  sUnsupportedDataType  = 'Тип данных не поддерживается: %s';
  sRowOutOfRange        = 'Индекс строки вышел за границу: %d';
  sColOutOfRange        = 'Индекс столбца вышел за границу: %d';
  sDupeItem             = 'Дубликат элемента массива';
  sArrayIndexOutOfRange = 'Индекс массива вышел за границу: %d';
  sLowCapacityError     = 'Ресурсы DecisionCube исчерпаны. Отключите измерения или смените набор данных.';
  sQryNotInitialized    = 'Не могу выполнить запрос. Проверьте правильность Query, кода SQL и БД (Database).';
  sSortedListError      = 'Операция не разрешена на отсортированном списке строк.';
  sDuplicateString      = 'В списке строк дубликаты не разрешены.';
  sMaxAllowedSums       = 'Превышен максимум итогов для %d.';
  sGeneralArrayError    = 'Общая ошибка массива.';

  {String used in the DecisionSource}
  sDimIndexError        = 'Неверный индекс измерения';

  {String used in the DecisionCube}
  sIllegalValueForBin   = 'Initial Value - неверное для этого типа Grouping';
  sIllegalDimMap        = 'Dimension Map - неверного размера';
  sDimMapActiveError    = 'Не могу выполнить это действие на активном Dimension Map';
  sNotAvailable         = 'Недопустимо';
  sGetValueCounts       = 'Информация для получения Maximum Cell limit неактуальна.  Обновить сейчас?';
  sDateBinningNotAllowed = 'Группировка дат не разрешена для полей такого типа';
  sEmptyDataSet         = 'Не могу построить Decision Cube с пустым набором данных (data set)';

  { Strings use in Query UI}
  sNoDataSet            = 'Свойство Data set не определено';
  sNoAggs               = 'Итоги не определены. ';
  sNoDims               = 'Поля измерений не определены. ';
  sUnknownDims          = 'Типы измерений для этого набора данных не могут быть определены автоматически.  Вы должны сопоставить поля измерениям или итогам в Редакторе Decision Cube';
  sGroupsMissing        = 'Все поля измерений должны быть сгруппированы. ';
  sDecisionQueryError   = 'Запрос некорректен, либо нужно сопоставить его поля активным измерениям или итогам в Редакторе Decision Cube';
  sDataSetError         = 'Набор данных задан неверно, либо нужно сопоставить его поля активным измерениям или итогам в Редакторе Decision Cube';
  sQueryError           = 'Запрос некорректен, либо нужно сопоставить его поля активным измерениям или суммам в Редакторе Decision Cube';
  sCountStar            = 'COUNTALL';  { INTL must be in upper case }
  sAddAvgWarning        = 'Среднее вычисляется через итоги sum и count для каждого поля. Требуемые итоги были добавлены.';
  sAddAvgStarWarning    = 'Среднее вычисляется через поля sum и count(*).  Требуемые итоги были добавлены.';

  { Query UI Designer strings}
  sQueryLegal           = 'Запрос правильный.';
  sAddFieldExists       = ' - уже в запросе';
  sAggTypeNotAllowed    = ' - неверный тип итога';
  sDimTypeNotAllowed    = ' неверный тип измерения';
  sAverageRequires      = 'Итоги Average используют Sum и Count';
  sWantToExit           = 'Вы действительно хотите выйти?';
  sQueryIllegal         = 'Созданный Вами запрос неверен.';
  sQueryEditIllegal     = 'Введенный запрос неверен.  Исправьте его для продолжения.';
  sRemoveFieldError     = 'Не могу удалить поле';
  sAllFields            = 'Все поля';
  sQueryFields          = 'Поля запроса';
  sEditDone             = '&Edit Done';
  sEditQuery            = '&Edit Query';

  { Used by the query parser}
  sQParseRemovedField   = 'Одно или более полей непригодного для отображения типа были удалены из запроса.';

  { used by mxstore }
  sCubeLimitsExceeded   = 'Размер Decision Cube превысил пределы';
  sMaxAllowedDims       = 'Превышен максимум допустимой размерности %d.';
  sMaxAllowedCells      = 'Общее число ячеек %d превысило максимум - %d.';
  sUnsupportedFieldType = 'Поле %s имеет неподдерживаемый тип данных: %s';
  sFetchValues          = 'Сканирование значений набора данных (data set)...';
  sUserCanceled         = 'Вы прервали построение DecisionCube.';
  sBinningValues        = 'Группирование значений ...';
  sCreatingIndexes      = 'Создание индекса Cube для %s ...';
  sCreateDerivedSummaryError = 'Не могу создать производный итог.';
  sTrue                 = 'True';
  sFalse                = 'False';
  sBinTypeMismatch      = 'Тип контейнера не соответствует типу поля.';
  sFatalCacheError      = 'Фатальный сбой кэша: код: %d';
  sStringTypeNoSupported = 'Строковый тип данных неприменим для итогов';
  sDataSetTooLarge      = 'Набор данных (dataset) слишком велик';
  sBuildingDataStore    = 'Построение хранилища данных...';

  {String used in MXtables and mxcommon and mxqparse}
  sSumLabel             = 'Сумма %s';
  sCountLabel           = 'Количество %s';
  sMaxLabel             = 'Максимум %s';
  sMinLabel             = 'Минимум %s';
  sAverageLabel         = 'Среднее %s';
  sVarLabel             = 'Отклонение %s';
  sSDLabel              = 'Стандартная девиация %s';
  sAggLabel             = 'Итог %s';
  sUnsupportedVarType   = 'Тип данных %d не поддерживается';
  sOtherValues          = 'Другие Значения';

  sSelectFromError      = 'В запросе отсутствует предложение Select/From.';
  sArgumentExpected     = 'Для оператора или итога не задан аргумент';
  sGroupOnExpressionError = 'Выражение нельзя использовать для поля группировки';

  SOutofBounds          = 'Выход за границы';
  sIDAPILangID          = '0019';

implementation

end.
