{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1995,99 Inprise Corporation       }
{                                                       }
{ Руссификация: 1999 Polaris Software                   }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit BrkrConst;

interface

resourcestring
  sOnlyOneDataModuleAllowed = 'Допустим только один модуль данных на приложение';
  sNoDataModulesRegistered = 'Не зарегистрировано ни одного модуля данных';
  sNoDispatcherComponent = 'Не найдено ни одного компонента-диспетчера в модуле данных';
  sTooManyActiveConnections = 'Достигнут максимум конкурирующих соединений.  ' +
    'Повторите попытку позже';
  sInternalServerError = '<html><title>Внутренняя Ошибка Сервера 500</title>'#13#10 +
    '<h1>Внутренняя Ошибка Сервера 500</h1><hr>'#13#10 +
    'Исключительная ситуация: %s<br>'#13#10 +
    'Сообщение: %s<br></html>'#13#10;
  sDocumentMoved = '<html><title>Документ перемещен 302</title>'#13#10 +
    '<body><h1>Объект перемещен</h1><hr>'#13#10 +
    'Этот объект может быть найден <a HREF="%s">здесь.</a><br>'#13#10 +
    '<br></body></html>'#13#10;


implementation

end.
