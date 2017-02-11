{********************************************************}
{                                                        }
{       Borland Delphi Visual Component Library          }
{       InterBase Express core components                }
{                                                        }
{       Copyright (c) 1998-1999 Inprise Corporation      }
{                                                        }
{    InterBase Express is based in part on the product   }
{    Free IB Components, written by Gregory H. Deatz for }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.     }
{    Free IB Components is used under license.           }
{                                                        }
{********************************************************}

unit IB;

interface

uses
  Windows, SysUtils, Classes, IBHeader, IBExternals, IBUtils, DB, IBXConst;

type
  TTraceFlag = (tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect,
     tfTransact, tfBlob, tfService, tfMisc);
  TTraceFlags = set of TTraceFlag;

  EIBError                  = class(EDatabaseError)
  private
    FSQLCode: Long;
    FIBErrorCode: Long;
  public
    constructor Create(ASQLCode: Long; Msg: string); overload;
    constructor Create(ASQLCode: Long; AIBErrorCode: Long; Msg: string); overload;
    property SQLCode: Long read FSQLCode;
    property IBErrorCode: Long read FIBErrorCode;
  end;

  EIBInterBaseError         = class(EIBError);
  EIBClientError            = class(EIBError);

  TIBDataBaseErrorMessage    = (ShowSQLCode,
                                ShowIBMessage,
                                ShowSQLMessage);
  TIBDataBaseErrorMessages   = set of TIBDataBaseErrorMessage;
  TIBClientError            = (
    ibxeUnknownError,
    ibxeInterBaseMissing,
    ibxeInterBaseInstallMissing,
    ibxeIB60feature,
    ibxeNotSupported,
    ibxeNotPermitted,
    ibxeFileAccessError,
    ibxeConnectionTimeout,
    ibxeCannotSetDatabase,
    ibxeCannotSetTransaction,
    ibxeOperationCancelled,
    ibxeDPBConstantNotSupported,
    ibxeDPBConstantUnknown,
    ibxeTPBConstantNotSupported,
    ibxeTPBConstantUnknown,
    ibxeDatabaseClosed,
    ibxeDatabaseOpen,
    ibxeDatabaseNameMissing,
    ibxeNotInTransaction,
    ibxeInTransaction,
    ibxeTimeoutNegative,
    ibxeNoDatabasesInTransaction,
    ibxeUpdateWrongDB,
    ibxeUpdateWrongTR,
    ibxeDatabaseNotAssigned,
    ibxeTransactionNotAssigned,
    ibxeXSQLDAIndexOutOfRange,
    ibxeXSQLDANameDoesNotExist,
    ibxeEOF,
    ibxeBOF,
    ibxeInvalidStatementHandle,
    ibxeSQLOpen,
    ibxeSQLClosed,
    ibxeDatasetOpen,
    ibxeDatasetClosed,
    ibxeUnknownSQLDataType,
    ibxeInvalidColumnIndex,
    ibxeInvalidParamColumnIndex,
    ibxeInvalidDataConversion,
    ibxeColumnIsNotNullable,
    ibxeBlobCannotBeRead,
    ibxeBlobCannotBeWritten,
    ibxeEmptyQuery,
    ibxeCannotOpenNonSQLSelect,
    ibxeNoFieldAccess,
    ibxeFieldReadOnly,
    ibxeFieldNotFound,
    ibxeNotEditing,
    ibxeCannotInsert,
    ibxeCannotPost,
    ibxeCannotUpdate,
    ibxeCannotDelete,
    ibxeCannotRefresh,
    ibxeBufferNotSet,
    ibxeCircularReference,
    ibxeSQLParseError,
    ibxeUserAbort,
    ibxeDataSetUniDirectional,
    ibxeCannotCreateSharedResource,
    ibxeWindowsAPIError,
    ibxeColumnListsDontMatch,
    ibxeColumnTypesDontMatch,
    ibxeCantEndSharedTransaction,
    ibxeFieldUnsupportedType,
    ibxeCircularDataLink,
    ibxeEmptySQLStatement,
    ibxeIsASelectStatement,
    ibxeRequiredParamNotSet,
    ibxeNoStoredProcName,
    ibxeIsAExecuteProcedure,
    ibxeUpdateFailed,
    ibxeNotCachedUpdates,
    ibxeNotLiveRequest,
    ibxeNoProvider,
    ibxeNoRecordsAffected,
    ibxeNoTableName,
    ibxeCannotCreatePrimaryIndex,
    ibxeCannotDropSystemIndex,
    ibxeTableNameMismatch,
    ibxeIndexFieldMissing,
    ibxeInvalidCancellation,
    ibxeInvalidEvent,
    ibxeMaximumEvents,
    ibxeNoEventsRegistered,
    ibxeInvalidQueueing,
    ibxeInvalidRegistration,
    ibxeInvalidBatchMove,
    ibxeSQLDialectInvalid,
    ibxeSPBConstantNotSupported,
    ibxeSPBConstantUnknown,
    ibxeServiceActive,
    ibxeServiceInActive,
    ibxeServerNameMissing,
    ibxeQueryParamsError,
    ibxeStartParamsError,
    ibxeOutputParsingError,
    ibxeUseSpecificProcedures,
    ibxeSQLMonitorAlreadyPresent
    );

  TStatusVector              = array[0..19] of ISC_STATUS;
  PStatusVector              = ^TStatusVector;

resourcestring
{ generic strings used in code }
  SIBDatabaseEditor = 'Редактор &БД...';
  SIBTransactionEditor = 'Редактор &транзакций...';
  SDatabaseFilter = 'Файлы БД (*.gdb)|*.gdb|Все файлы (*.*)|*.*';
  SDisconnectDatabase = 'Есть активное соединение с базой данных. Прервать соединение и продолжить?';
  SCommitTransaction = 'Транзакция активна. Откатить ее и продолжить?';
  SExecute = '&Выполнить';
  SNoDataSet = 'Нет ссылки на набор данных (dataset)';
  SSQLGenSelect = 'Необходимо выбрать хотя бы одно ключевое и одно изменяемое поле';
  SSQLNotGenerated = 'Команды Update SQL не сгенерированы, выйти?';
  SIBUpdateSQLEditor = 'Редактор &UpdateSQL...';
  SSQLDataSetOpen = 'Не могу определить имена полей для %s';

{ strings used in error messages}
  SUnknownError = 'Неизвестная ошибка';
  SInterBaseMissing = 'Библиотека InterBase gds32.dll не найдена. Пожалуйста, установите InterBase для использования этой возможности';
  SInterBaseInstallMissing = 'Библиотека установки InterBase ibinstall.dll не найдена. Пожалуйста, установите InterBase 6 для использования этой возможности';
  SIB60feature = '%s - это функция InterBase6. Пожалуйста, обновите до InterBase6 для использования этой возможности';
  SNotSupported = 'Неподдерживаемая возможность';
  SNotPermitted = 'Не допустимо';
  SFileAccessError = 'Ошибка доступа к временному файлу';
  SConnectionTimeout = 'Истекло время соединения к базе данных';
  SCannotSetDatabase = 'Не могу установить базу данных';
  SCannotSetTransaction = 'Не могу стартовать транзакцию';
  SOperationCancelled = 'Операция прервана по запросу пользователя';
  SDPBConstantNotSupported = 'DPB константа (isc_dpb_%s) не поддерживается';
  SDPBConstantUnknown = 'DPB константа (%d) неизвестна';
  STPBConstantNotSupported = 'TPB константа (isc_tpb_%s) не поддерживается';
  STPBConstantUnknown = 'TPB константа (%d) неизвестна';
  SDatabaseClosed = 'Не могу выполнить операцию -- БД не открыта';
  SDatabaseOpen = 'Не могу выполнить операцию -- БД открыта';
  SDatabaseNameMissing = 'Не указано имя базы данных';
  SNotInTransaction = 'Транзакция не активна';
  SInTransaction = 'Транзакция активна';
  STimeoutNegative = 'Значения задержек не могут быть отрицательными';
  SNoDatabasesInTransaction = 'Нет баз данных в списке transaction компонента';
  SUpdateWrongDB = 'Изменение неверной базы данных';
  SUpdateWrongTR = 'Изменение неверной транзакции. В наборе ожидается уникальная транзакция';
  SDatabaseNotAssigned = 'База данных не определена';
  STransactionNotAssigned = 'Транзакция не определена';
  SXSQLDAIndexOutOfRange = 'Индекс XSQLDA вышел за границы';
  SXSQLDANameDoesNotExist = 'Имя XSQLDA не найдено (%s)';
  SEOF = 'Конец файла';
  SBOF = 'Начало файла';
  SInvalidStatementHandle = 'Неверный дескриптор команды';
  SSQLOpen = 'IBSQL открыт';
  SSQLClosed = 'IBSQL закрыт';
  SDatasetOpen = 'Набор данных (Dataset) открыт';
  SDatasetClosed = 'Набор данных (Dataset) закрыт';
  SUnknownSQLDataType = 'Неверный тип данных SQL (%d)';
  SInvalidColumnIndex = 'Неверный индекс колонки (индекс превысил разрешенный диапазон)';
  SInvalidParamColumnIndex = 'Неверный индекс параметра (индекс превысил разрешенный диапазон)';
  SInvalidDataConversion = 'Неверное преобразование данных';
  SColumnIsNotNullable = 'Колонка не может быть установлена в NULL (%s)';
  SBlobCannotBeRead = 'Не могу прочитать из Blob stream';
  SBlobCannotBeWritten = 'Не могу записать в Blob stream';
  SEmptyQuery = 'Пустой запрос';
  SCannotOpenNonSQLSelect = 'Не могу выполнить Open для не SELECT команды. Используйте ExecQuery';
  SNoFieldAccess = 'Нет доступа к полю "%s"';
  SFieldReadOnly = 'Поле "%s" только для чтения';
  SFieldNotFound = 'Поле "%s" не найдено';
  SNotEditing = 'Не редактирование';
  SCannotInsert = 'Не могу добавить запись в набор данных (dataset). (Нет insert запроса)';
  SCannotPost = 'Не могу сохранить (post). (Нет update/insert запроса)';
  SCannotUpdate = 'Не могу изменить (update). (Нет update запроса)';
  SCannotDelete = 'Не могу удалить из набора данных (dataset). (Нет delete запроса)';
  SCannotRefresh = 'Не могу обновить запись. (Нет refresh запроса)';
  SBufferNotSet = 'Буфер не установлен';
  SCircularReference = 'Циклические ссылки не разрешены';
  SSQLParseError = 'Ошибка синтаксического разбора SQL:' + CRLF + CRLF + '%s';
  SUserAbort = 'Прервано пользователем';
  SDataSetUniDirectional = 'Однонаправленный набор данных (Data set)';
  SCannotCreateSharedResource = 'Не могу создать разделенный ресурс. (Ошибка Windows %d)';
  SWindowsAPIError = 'Ошибка Windows API. (Ошибка Windows %d [$%.8x])';
  SColumnListsDontMatch = 'Списки колонок не совпадают';
  SColumnTypesDontMatch = 'Типы колонок не совпадают. (С индекса %d до %d)';
  SCantEndSharedTransaction = 'Не могу завершить общую (shared) транзакцию кроме случаев, когда она принудительно завершена and equal ' +
                             'TimeoutAction транзакции';
  SFieldUnsupportedType = 'Неподдерживаемый тип поля';
  SCircularDataLink = 'Циклическая DataLink ссылка';
  SEmptySQLStatement = 'Пустая SQL команда';
  SIsASelectStatement = 'используйте Open для Select команды';
  SRequiredParamNotSet = 'Требуемое значение Param не установлено';
  SNoStoredProcName = 'Не определено имя хранимой процедуры';
  SIsAExecuteProcedure = 'используйте ExecProc для процедур; используйте TQuery для Select процедур';
  SUpdateFailed = 'Ошибка при изменении (Update)';
  SNotCachedUpdates = 'CachedUpdates не разрешены';
  SNotLiveRequest = 'Запрос открыт не для изменений (not live) - не могу изменять';
  SNoProvider = 'Нет провайдера';
  SNoRecordsAffected = 'Ни одной записи не обработано';
  SNoTableName = 'Не определено имя таблицы';
  SCannotCreatePrimaryIndex = 'Не могу создать Primary индекс; создан автоматически';
  SCannotDropSystemIndex = 'Не могу удалить System индекс';
  STableNameMismatch = 'Не совпадает имя таблицы';
  SIndexFieldMissing = 'Не указано индексное поле';
  SInvalidCancellation = 'Не могу отменить события во время обработки';
  SInvalidEvent = 'Неверное событие';
  SMaximumEvents = 'Достигнут максимальный предел для событий';
  SNoEventsRegistered = 'Нет зарегистрированных событий';
  SInvalidQueueing = 'Неверная организация очередей';
  SInvalidRegistration = 'Неверная регистрация';
  SInvalidBatchMove = 'Неверное пакетное перемещение (batch move)';
  SSQLDialectInvalid = 'Неверный диалект SQL';
  SSPBConstantNotSupported = 'SPB константа не поддерживается';
  SSPBConstantUnknown = 'SPB константа неизвестна';
  SServiceActive = 'Не могу выполнить операцию -- служба не подключена';
  SServiceInActive = 'Не могу выполнить операцию -- служба подключена';
  SServerNameMissing = 'Имя сервера не указано';
  SQueryParamsError = 'Параметры запроса не указаны или неверные';
  SStartParamsError = 'Start параметры не указаны или неверные';
  SOutputParsingError = 'Неожидаемые значения буфера вывода';
  SUseSpecificProcedures = 'Generic ServiceStart не применим: используйте Specific Procedures для установки параметров конфигурации';
  SSQLMonitorAlreadyPresent = 'SQL Monitor уже запущен';

const
  IBPalette1 = 'InterBase'; {do not localize}
  IBPalette2 = 'InterBase Admin'; {do not localize}

  IBLocalBufferLength = 512;
  IBBigLocalBufferLength = IBLocalBufferLength * 2;
  IBHugeLocalBufferLength = IBBigLocalBufferLength * 20;

  IBErrorMessages: array[TIBClientError] of string = (
    SUnknownError,
    SInterBaseMissing,
    SInterBaseInstallMissing,
    SIB60feature,
    SNotSupported,
    SNotPermitted,
    SFileAccessError,
    SConnectionTimeout,
    SCannotSetDatabase,
    SCannotSetTransaction,
    SOperationCancelled,
    SDPBConstantNotSupported,
    SDPBConstantUnknown,
    STPBConstantNotSupported,
    STPBConstantUnknown,
    SDatabaseClosed,
    SDatabaseOpen,
    SDatabaseNameMissing,
    SNotInTransaction,
    SInTransaction,
    STimeoutNegative,
    SNoDatabasesInTransaction,
    SUpdateWrongDB,
    SUpdateWrongTR,
    SDatabaseNotAssigned,
    STransactionNotAssigned,
    SXSQLDAIndexOutOfRange,
    SXSQLDANameDoesNotExist,
    SEOF,
    SBOF,
    SInvalidStatementHandle,
    SSQLOpen,
    SSQLClosed,
    SDatasetOpen,
    SDatasetClosed,
    SUnknownSQLDataType,
    SInvalidColumnIndex,
    SInvalidParamColumnIndex,
    SInvalidDataConversion,
    SColumnIsNotNullable,
    SBlobCannotBeRead,
    SBlobCannotBeWritten,
    SEmptyQuery,
    SCannotOpenNonSQLSelect,
    SNoFieldAccess,
    SFieldReadOnly,
    SFieldNotFound,
    SNotEditing,
    SCannotInsert,
    SCannotPost,
    SCannotUpdate,
    SCannotDelete,
    SCannotRefresh,
    SBufferNotSet,
    SCircularReference,
    SSQLParseError,
    SUserAbort,
    SDataSetUniDirectional,
    SCannotCreateSharedResource,
    SWindowsAPIError,
    SColumnListsDontMatch,
    SColumnTypesDontMatch,
    SCantEndSharedTransaction,
    SFieldUnsupportedType,
    SCircularDataLink,
    SEmptySQLStatement,
    SIsASelectStatement,
    SRequiredParamNotSet,
    SNoStoredProcName,
    SIsAExecuteProcedure,
    SUpdateFailed,
    SNotCachedUpdates,
    SNotLiveRequest,
    SNoProvider,
    SNoRecordsAffected,
    SNoTableName,
    SCannotCreatePrimaryIndex,
    SCannotDropSystemIndex,
    STableNameMismatch,
    SIndexFieldMissing,
    SInvalidCancellation,
    SInvalidEvent,
    SMaximumEvents,
    SNoEventsRegistered,
    SInvalidQueueing,
    SInvalidRegistration,
    SInvalidBatchMove,
    SSQLDialectInvalid,
    SSPBConstantNotSupported,
    SSPBConstantUnknown,
    SServiceActive,
    SServiceInActive,
    SServerNameMissing,
    SQueryParamsError,
    SStartParamsError,
    SOutputParsingError,
    SUseSpecificProcedures,
    SSQLMonitorAlreadyPresent
  );

var
  IBCS: TRTLCriticalSection;

procedure IBAlloc(var P; OldSize, NewSize: Integer);

procedure IBError(ErrMess: TIBClientError; const Args: array of const);
procedure IBDataBaseError;

function StatusVector: PISC_STATUS;
function StatusVectorArray: PStatusVector;
function CheckStatusVector(ErrorCodes: array of ISC_STATUS): Boolean;
function StatusVectorAsText: string;

procedure SetIBDataBaseErrorMessages(Value: TIBDataBaseErrorMessages);
function GetIBDataBaseErrorMessages: TIBDataBaseErrorMessages;

implementation

uses
  IBIntf;

var
  IBDataBaseErrorMessages: TIBDataBaseErrorMessages;
threadvar
  FStatusVector : TStatusVector;

procedure IBAlloc(var P; OldSize, NewSize: Integer);
var
  i: Integer;
begin
  ReallocMem(Pointer(P), NewSize);
  for i := OldSize to NewSize - 1 do PChar(P)[i] := #0;
end;

procedure IBError(ErrMess: TIBClientError; const Args: array of const);
begin
  raise EIBClientError.Create(Ord(ErrMess),
                              Format(IBErrorMessages[ErrMess], Args));
end;

procedure IBDataBaseError;
var
  sqlcode: Long;
  IBErrorCode: Long;
  local_buffer: array[0..IBHugeLocalBufferLength - 1] of char;
  usr_msg: string;
  status_vector: PISC_STATUS;
  IBDataBaseErrorMessages: TIBDataBaseErrorMessages;
begin
  usr_msg := '';

  { Get a local reference to the status vector.
    Get a local copy of the IBDataBaseErrorMessages options.
    Get the SQL error code }
  status_vector := StatusVector;
  IBErrorCode := StatusVectorArray[1];
  IBDataBaseErrorMessages := GetIBDataBaseErrorMessages;
  sqlcode := isc_sqlcode(status_vector);

  if (ShowSQLCode in IBDataBaseErrorMessages) then
    usr_msg := usr_msg + 'SQLCODE: ' + IntToStr(sqlcode); {do not localize}
  Exclude(IBDataBaseErrorMessages, ShowSQLMessage);
  if (ShowSQLMessage in IBDataBaseErrorMessages) then
  begin
    isc_sql_interprete(sqlcode, local_buffer, IBLocalBufferLength);
    if (ShowSQLCode in IBDataBaseErrorMessages) then
      usr_msg := usr_msg + CRLF;
    usr_msg := usr_msg + string(local_buffer);
  end;

  if (ShowIBMessage in IBDataBaseErrorMessages) then
  begin
    if (ShowSQLCode in IBDataBaseErrorMessages) or
       (ShowSQLMessage in IBDataBaseErrorMessages) then
      usr_msg := usr_msg + CRLF;
    while (isc_interprete(local_buffer, @status_vector) > 0) do
    begin
      if (usr_msg <> '') and (usr_msg[Length(usr_msg)] <> LF) then
        usr_msg := usr_msg + CRLF;
      usr_msg := usr_msg + string(local_buffer);
    end;
  end;
  if (usr_msg <> '') and (usr_msg[Length(usr_msg)] = '.') then
    Delete(usr_msg, Length(usr_msg), 1);

  raise EIBInterBaseError.Create(sqlcode, IBErrorCode, usr_msg);
end;

{ Return the status vector for the current thread }
function StatusVector: PISC_STATUS;
begin
  result := @FStatusVector;
end;

function StatusVectorArray: PStatusVector;
begin
  result := @FStatusVector;
end;

function CheckStatusVector(ErrorCodes: array of ISC_STATUS): Boolean;
var
  p: PISC_STATUS;
  i: Integer;
  procedure NextP(i: Integer);
  begin
    p := PISC_STATUS(PChar(p) + (i * SizeOf(ISC_STATUS)));
  end;
begin
  p := @FStatusVector;
  result := False;
  while (p^ <> 0) and (not result) do
    case p^ of
      3: NextP(3);
      1, 4:
      begin
        NextP(1);
        i := 0;
        while (i <= High(ErrorCodes)) and (not result) do
        begin
          result := p^ = ErrorCodes[i];
          Inc(i);
        end;
        NextP(1);
      end;
      else
        NextP(2);
    end;
end;

function StatusVectorAsText: string;
var
  p: PISC_STATUS;
  function NextP(i: Integer): PISC_STATUS;
  begin
    p := PISC_STATUS(PChar(p) + (i * SizeOf(ISC_STATUS)));
    result := p;
  end;
begin
  p := @FStatusVector;
  result := '';
  while (p^ <> 0) do
    if (p^ = 3) then
    begin
      result := result + Format('%d %d %d', [p^, NextP(1)^, NextP(1)^]) + CRLF;
      NextP(1);
    end
    else begin
      result := result + Format('%d %d', [p^, NextP(1)^]) + CRLF;
      NextP(1);
    end;
end;


{ EIBError }
constructor EIBError.Create(ASQLCode: Long; Msg: string);
begin
  inherited Create(Msg);
  FSQLCode := ASQLCode;
end;

constructor EIBError.Create(ASQLCode: Long; AIBErrorCode: Long; Msg: string);
begin
  inherited Create(Msg);
  FSQLCode :=  ASQLCode;
  FIBErrorCode := AIBErrorCode;
end;

procedure SetIBDataBaseErrorMessages(Value: TIBDataBaseErrorMessages);
begin
  EnterCriticalSection(IBCS);
  try
    IBDataBaseErrorMessages := Value;
  finally
    LeaveCriticalSection(IBCS);
  end;
end;

function GetIBDataBaseErrorMessages: TIBDataBaseErrorMessages;
begin
  EnterCriticalSection(IBCS);
  try
    result := IBDataBaseErrorMessages;
  finally
    LeaveCriticalSection(IBCS);
  end;
end;

initialization
  IsMultiThread := True;
  InitializeCriticalSection(IBCS);
  IBDataBaseErrorMessages := [ShowSQLMessage, ShowIBMessage];

finalization
  DeleteCriticalSection(IBCS);

end.
