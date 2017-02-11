{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1997,99 Inprise Corporation       }
{                                                       }
{ Руссификация: 1999 Polaris Software                   }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit WebConst;

interface

resourcestring
  sInvalidActionRegistration = 'Неверная регистрация Action';
{$IFNDEF VER130}
  sOnlyOneDataModuleAllowed = 'Допустим только один модуль данных на приложение';
  sNoDataModulesRegistered = 'Не зарегистрировано ни одного модуля данных';
  sNoDispatcherComponent = 'Не найдено ни одного компонента-диспетчера в модуле данных';
  sOnlyOneDispatcher = 'Только один WebDispatcher на формы/модуля данных';
{$ENDIF}
  sDuplicateActionName = 'Дубликат имени action';
{$IFDEF VER130}
  sOnlyOneDispatcher = 'Только один WebDispatcher на формы/модуля данных';
{$ENDIF}
{$IFNDEF VER130}
  sTooManyActiveConnections = 'Достигнут максимум конкурирующих соединений.  ' +
    'Повторите попытку позже';
{$ENDIF}
  sHTTPItemName = 'Name';
  sHTTPItemURI = 'PathInfo';
  sHTTPItemEnabled = 'Enabled';
  sHTTPItemDefault = 'Default';
{$IFDEF VER130}
  sHTTPItemProducer = 'Producer';
{$ENDIF}

{$IFNDEF VER130}
  sInternalServerError = '<html><title>Внутренняя Ошибка Сервера 500</title>'#13#10 +
    '<h1>Внутренняя Ошибка Сервера 500</h1><hr>'#13#10 +
    'Исключительная ситуация: %s<br>'#13#10 +
    'Сообщение: %s<br></html>'#13#10;
{$ENDIF}
{$IFDEF VER120}
  sDocumentMoved = '<html><title>Документ перемещен 302</title>'#13#10 +
    '<body><h1>Объект перемещен</h1><hr>'#13#10 +
    'Этот объект может быть найден <a HREF="%s">здесь.</a><br>'#13#10 +
    '<br></body></html>'#13#10;
{$ENDIF}
{$IFDEF VER100}
  sWindowsSocketError = 'Ошибка Windows socket: %s (%d), в API ''%s''';
  sNoAddress = 'Не указан адрес';
  sCannotCreateSocket = 'Не могу создать новый socket';
  sCannotListenOnOpen = 'Не могу слушать открытый socket';
  sSocketAlreadyOpen = 'Socket уже открыт';
  sCantChangeWhileActive = 'Не могу изменить значение, пока socket активный';
  sMustCreateThread = 'Поток должен создаваться в режиме Thread blocking';
  sSocketMustBeBlocking = 'Socket должен быть в blocking mode';
  sSocketIOError = '%s ошибка %d, %s';
  sSocketRead = 'Чтения';
  sSocketWrite = 'Записи';
  sAsyncSocketError = 'Ошибка асинхронного socket %d';
{$ENDIF}

  sResNotFound = 'Ресурс %s не найден';

  sTooManyColumns = 'Слишком много столбцов в таблице';
  sFieldNameColumn = 'Field Name';
  sFieldTypeColumn = 'Field Type';

{$IFNDEF VER130}
  sInvalidMask = '''%s'' - неверная маска (%d)';
{$ENDIF}

implementation

end.

