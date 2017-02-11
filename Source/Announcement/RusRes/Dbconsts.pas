{********************************************************}
{                                                        }
{       Borland Delphi Visual Component Library          }
{                                                        }
{       Copyright (c) 1995,99 Inprise Corporation        }
{                                                        }
{ Руссификация: 1998-99 Polaris Software                 }
{               http://members.xoom.com/PolarisSoft      }
{********************************************************}

unit DbConsts;

interface

resourcestring
  SInvalidFieldSize = 'Неверный размер поля';
{$IFNDEF VER100}
  SInvalidFieldKind = 'Неверный FieldKind';
{$ENDIF}
  SInvalidFieldRegistration = 'Неверная регистрация поля';
  SUnknownFieldType = 'Тип поля ''%s'' неизвестен';
  SFieldNameMissing = 'Отсутствует имя поля';
  SDuplicateFieldName = 'Дубликат имени поля ''%s''';
{$IFNDEF VER100}
  SFieldNotFound = 'Поле ''%s'' не найдено';
{$ELSE}
  SFieldNotFound = '%s: Поле ''%s'' не найдено';
{$ENDIF}
  SFieldAccessError = 'Не могу получить доступ к полю ''%s'' как типа %s';
  SFieldValueError = 'Неверное значение для поля ''%s''';
  SFieldRangeError = '%g - неверное значение для поля ''%s''. Разрешенный диапазон - от %g до %g';
  SInvalidIntegerValue = '''%s'' - неверное целое значение для поля ''%s''';
  SInvalidBoolValue = '''%s'' - неверное логическое значение для поля ''%s''';
  SInvalidFloatValue = '''%s'' - неверное дробное значение для поля ''%s''';
{$IFNDEF VER100}
  SFieldTypeMismatch = 'Неверный тип поля ''%s'', ожидается: %s, установлено: %s';
  SFieldSizeMismatch = 'Неверный размер для поля ''%s'', ожидается: %d, установлено: %d';
{$ELSE}
  SFieldTypeMismatch = 'Тип поля ''%s'' не соответствует ожидаемому';
{$ENDIF}
  SInvalidVarByteArray = 'Неверный вариантный тип или размер';
  SFieldOutOfRange = 'Значение поля ''%s'' вышло за границы';
  SBCDOverflow = '(Переполнение)';
  SFieldRequired = 'Поле ''%s'' должно иметь значение';
  SDataSetMissing = 'Поле ''%s'' не имеет набора данных (dataset)';
  SInvalidCalcType = 'Поле ''%s'' не может быть вычисляемым или поисковым полем';
  SFieldReadOnly = 'Поле ''%s'' не может быть изменено';
  SFieldIndexError = 'Индекс поля вышел за границы';
  SNoFieldIndexes = 'Нет активного индекса';
  SNotIndexField = 'Поле ''%s'' не индексировано и не может быть изменено';
  SIndexFieldMissing = 'Не могу получить доступ к индексному полю ''%s''';
  SDuplicateIndexName = 'Дубликат имени индекса ''%s''';
{$IFNDEF VER100}
  SNoIndexForFields = 'Нет индекса для полей ''%s''';
  SIndexNotFound = 'Индекс ''%s'' не найден';
  SDuplicateName = 'Дубликат имени ''%s'' в %s';
{$ELSE}
  SNoIndexForFields = 'Таблица ''%s'' не имеет индекса для полей ''%s''';
{$ENDIF}
  SCircularDataLink = 'Циклические связи данных не разрешены';
  SLookupInfoError = 'Информация поиска (lookup) для поля ''%s'' - неполная';
  SDataSourceChange = 'DataSource не может быть изменен';
{$IFNDEF VER100}
  SNoNestedMasterSource = 'Вложенные таблицы не могут иметь MasterSource';
{$ENDIF}
  SDataSetOpen = 'Не могу выполнить эту операцию для открытого набора данных (dataset)';
  SNotEditing = 'Набор данных (Dataset) не в режиме редактирования или вставки';
  SDataSetClosed = 'Не могу выполнить эту операцию для закрытого набора данных (dataset)';
  SDataSetEmpty = 'Не могу выполнить эту операцию для пустого набора данных (dataset)';
  SDataSetReadOnly = 'Не могу изменять набор данных "только для чтения" (read-only dataset)';
{$IFNDEF VER100}
  SNestedDataSetClass = 'Вложенный набор данных должен наследоваться от %s';
{$ELSE}
  SAutoSessionExclusive = 'Не могу установить свойство AutoSession с более чем одной сессией в форме или модуле данных';
  SAutoSessionExists = 'Не могу добавить сессию в форму или модуль данных, пока сессия ''%s'' имеет установленный AutoSession';
  SAutoSessionActive = 'Не могу изменить SessionName, пока установлено AutoSession';
{$ENDIF}
  SExprTermination = 'Выражение фильтра некорректно завершено';
  SExprNameError = 'Незавершенное имя поля';
  SExprStringError = 'Незавершенная строковая константа';
  SExprInvalidChar = 'Неверный символ в выражении фильтра: ''%s''';
  SExprNoRParen = ''')'' ожидается, обнаружено %s';
{$IFNDEF VER100}
  SExprNoRParenOrComma = ''')'' или '','' ожидается, обнаружено %s';
  SExprNoLParen = '''('' ожидается, обнаружено %s';
{$ENDIF}
  SExprExpected = 'Ожидается выражение, обнаружено %s';
  SExprBadField = 'Поле ''%s'' не может использоваться в выражении фильтра';
  SExprBadNullTest = 'NULL разрешено только с ''='' и ''<>''';
  SExprRangeError = 'Константа вышла за границы';
  SExprNotBoolean = 'Поле ''%s'' - не логического типа';
  SExprIncorrect = 'Некорректно сформированное выражение фильтра';
  SExprNothing = 'пусто';
{$IFNDEF VER100}
  SExprTypeMis = 'Несовпадение типов в выражении';
  SExprBadScope = 'В операция нельзя смешивать агрегатные значения со значениями полей';
  SExprNoArith = 'Арифметика в выражении фильтра не поддерживается';
  SExprNotAgg = 'Выражение не является агрегатным';
  SExprBadConst = 'Константа неверного типа %s';
  SExprNoAggFilter = 'Агрегатные выражения не поддерживаются в фильтрах';
  SExprEmptyInList = 'Список IN команды не может быть пустым';
  SInvalidKeywordUse = 'Неверное использование ключевого слова';
{$ENDIF}
  STextFalse = '0';
  STextTrue = '1';
{$IFNDEF VER100}
  SParameterNotFound = 'Параметр ''%s'' не найден';
  SInvalidVersion = 'Невозможно загрузить параметры привязки';
  SParamTooBig = 'Параметр ''%s'', не могу сохранить данные длиннее %d байт';
{$IFDEF VER130}
  SBadFieldType = 'Тип поля ''%s'' не поддерживается';
{$ELSE}
  SParamBadFieldType = 'Тип поля ''%s'' не поддерживается';
{$ENDIF}
  SAggActive = 'Свойство не может быть изменено, пока aggregate активно';
{$IFDEF VER130}
  SProviderSQLNotSupported = 'SQL не поддерживается: %s';
  SProviderExecuteNotSupported = 'Выполнение не поддерживается: %s';
  SExprNoAggOnCalcs = 'Используется поле ''%s'' неверного типа вычисляемого поля в aggregate, используйте internalcalc';
  SRecordChanged = 'Запись изменена другим пользователем';
{$ENDIF}
{$ENDIF}

{$IFDEF VER100}
  { DBClient }
  SNoDataProvider = 'Потеряна связь с провайдером или пакет данных';
  SInvalidDataPacket = 'Неверный пакет данных';
  SRefreshError = 'Необходимо сохранить изменения перед обновлением данных';
  SExportProvider = 'Экспорт %s из модуля данных';
  SProviderInvalid = 'Неверный провайдер. Провайдер закрыт сервером приложений';
  SClientDSAssignData = 'Assign Local &Data...';
  SLoadFromFile = '&Загрузить из файла...';
  SSaveToFile = 'Сохранить в &файл...';
  SClientDSClearData = '&Очистить данные';
  SClientDataSetEditor = '%s.%s Data';
  SClientDataFilter = 'Client DataSet (*.cds)|*.cds|Все файлы (*.*)|*.*';
  SInvalidProviderName = 'Провайдер не распознан сервером';
  SServerNameBlank = 'Не могу подключиться, %s должен содержать правильное ServerName или ServerGUID';
{$ENDIF}

  { DBCtrls }
  SFirstRecord = 'Первая запись';
  SPriorRecord = 'Предыдущая запись';
  SNextRecord = 'Следующая запись';
  SLastRecord = 'Последняя запись';
  SInsertRecord = 'Вставить запись';
  SDeleteRecord = 'Удалить запись';
  SEditRecord = 'Изменить запись';
  SPostEdit = 'Подтвердить изменения';
  SCancelEdit = 'Отменить изменения';
  SRefreshRecord = 'Обновить данные';
  SDeleteRecordQuestion = 'Удалить запись?';
  SDeleteMultipleRecordsQuestion = 'Удалить все выбранные записи?';
  SRecordNotFound = 'Запись не найдена';
  SDataSourceFixed = 'Операция не разрешена в DBCtrlGrid';
  SNotReplicatable = 'Этот элемент не может использоваться в DBCtrlGrid';
  SPropDefByLookup = 'Свойство уже определено поисковым полем (lookup field)';
  STooManyColumns = 'Требуется Grid для отображения более 256 колонок';

{$IFNDEF VER100}
  { DBLogDlg }
  SRemoteLogin = 'Remote Login';

  { DBOleEdt }
  SDataBindings = 'Привязка данных...';
{$ELSE}
  { MIDASCon }
  SSocketReadError = 'Ошибка чтения из socket';
  SSocketWriteError = 'Ошибка записи в socket';
  SBadVariantType = 'Неподдерживаемый вариантный тип: %s';
  SInvalidAction = 'Запрошено неверное действие';
  SConnectionLost = 'Соединение потеряно';
  SComputerNameRequired = 'Требуется ComputerName';

  { ScktSrvr }
  SErrChangePort = 'Не могу изменить порт, пока есть активные соединения';
  SErrClose = 'Не могу выйти, пока есть активные соединения';
  SButtonApply = 'Применить';
  SButtonExit = 'Выход';
{$ENDIF}

implementation

end.
