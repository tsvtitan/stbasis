{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1997,99 Inprise Corporation       }
{                                                       }
{ Руссификация: 1998-99 Polaris Software                }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit MidConst;

interface

{$IFDEF VER130}
const
{ Do not localize }
  MIDAS_CatDesc = 'Borland MIDAS Application Servers';
  CATID_MIDASAppServer: TGUID = '{13E85B3C-9508-11D2-AB63-00C04FA35CFA}';
  SCatImplBaseKey = 'CLSID\%s\Implemented Categories';
  SCatImplKey = SCatImplBaseKey + '\%s';
  MIDAS_DLL = 'MIDAS.DLL';
  SClsid = 'CLSID\';
  SPooled = 'Pooled';
  SMaxObjects = 'MaxObjects';
  STimeout = 'Timeout';
  SSingleton = 'Singleton';
  SSockets = 'Sockets';
  SWeb = 'Web';
  SFlagOn = '1';
  SFlagOff = '0'; 
{$ENDIF}

resourcestring
{$IFDEF VER130}
  { App Server }
  SProviderNotExported = 'Провайдер не экспортирован: %s';
{$ENDIF}

  { DBClient }
  SNoDataProvider = 'Потерян провайдер данных или пакет данных';
  SInvalidDataPacket = 'Неверный пакет данных';
  SRefreshError = 'Необходимо применить изменения перед обновлением данных';
  SProviderInvalid = 'Неверный провайдер. Провайдер был освобожден сервером приложений';
  SServerNameBlank = 'Не могу соединиться, %s должен содержать правильное ServerName или ServerGUID';
  SRepositoryIdBlank = 'Не могу соединиться, %s должен содержать правильное repository id';
  SAggsGroupingLevel = 'Уровень группировки превысил текущее количество полей индекса';
  SAggsNoSuchLevel = 'Уровень группировки не определен';
  SNoCircularReference = 'Циклические ссылки провайдеров не разрешаются';
{$IFDEF VER130}
  SErrorLoadingMidas = 'Ошибка загрузки MIDAS.DLL';
  SCannotCreateDataSet = 'Поля не определены.  Не могу создать набор данных (dataset)';
{$ENDIF}

  { MConnect }
  SSocketReadError = 'Ошибка чтения из socket';
  SInvalidProviderName = 'Имя провайдера "%s" не распознано сервером';
  SBadVariantType = 'Неподдерживаемый вариантный тип: %s';
  SInvalidAction = 'Запрошено неверное действие (action): %d';

  { Resolver }
  SInvalidResponse = 'Неверный ответ';
{$IFNDEF VER130}
  SRecordChanged = 'Запись изменена другим пользователем';
{$ENDIF}
  SRecordNotFound = 'Запись не найдена';
  STooManyRecordsModified = 'Изменение (Update) затрагивает более 1 записи.';

  { Provider }
  SInvalidOptParamType = 'Значение не может быть сохранено в необязательный параметр';
  SMissingDataSet = 'Потеряно свойство DataSet';
  SConstraintFailed = 'Условие на запись или поле (constraint) не выполнилось.';
  SField = 'Field';
  SReadOnlyProvider = 'Не могу применить изменения для ReadOnly провайдера';
  SNoKeySpecified = 'Не могу найти запись.  Не определен ключ';
  SFieldNameTooLong = 'Имя поля не может быть длиннее чем %d символов.  Попытайтесь ' +
                      'установить ObjectView в True в dataset';
  SNoDataSets = 'Не могу определить набор данных, когда используются вложенные наборы данных или ссылки';
  SRecConstFail = 'Подготовка record constraint не выполнилась с ошибкой "%s"';
  SFieldConstFail = 'Подготовка field constraint не выполнилась с ошибкой "%s"';
  SDefExprFail = 'Подготовка default expression не выполнилась с ошибкой "%s"';
  SArrayElementError = 'Массив элементов типа %s не поддерживается'; 
  SNoTableName = 'Не могу определить записи.  Имя таблицы не найдено.';
{$IFDEF VER130}
  SNoEditsAllowed = 'Изменения не допустимы';
  SNoDeletesAllowed = 'Удаления не допустимы';
  SNoInsertsAllowed = 'Добавления (inserts) не допустимы';
  SCannotChangeCommandText = 'Изменения CommandText не допустимы';
{$ENDIF}

  { ObjectBroker }
  SNoServers = 'Нет доступного сервера';

  { Socket Connection }
  SReturnError = 'Ожидаемое возвращаемое значение не получено';
  SNoWinSock2 = 'Должен быть установлен WinSock 2 для использования socket соединения';

{$IFDEF VER130}
  { Web Connection }
  SURLRequired = 'Требуется URL';
  SDefaultURL = 'http://server.company.com/scripts/httpsrvr.dll';
  SInvalidURL = 'URL должен быть в форме "http://server.company.com/scripts/httpsrvr.dll"';
  SServerIsBusy = 'Сервер занят';

  SObjectNotAvailable = 'Объект не доступен: %s';
{$ENDIF}

implementation

end.
