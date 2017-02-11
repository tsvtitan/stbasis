{********************************************************}
{                                                        }
{       Borland Delphi Visual Component Library          }
{                                                        }
{       Copyright (c) 1995,99 Inprise Corporation        }
{                                                        }
{ Руссификация: 1998-99 Polaris Software                 }
{               http://members.xoom.com/PolarisSoft      }
{********************************************************}

unit OleConst;

interface

resourcestring
  SBadPropValue = '''%s'' - недопустимое значение свойства';
  SCannotActivate = 'Ошибка активации элемента управления OLE';
  SNoWindowHandle = 'Не могу получить дескриптор окна элемента управления OLE';
  SOleError = 'Ошибка OLE %.8x';
  SVarNotObject = 'Variant не ссылается на объект OLE';
  SVarNotAutoObject = 'Variant не ссылается на объект automation';
  SNoMethod = 'Метод ''%s'' не поддерживается объектом OLE';
  SLinkProperties = 'Свойства соединения';
  SInvalidLinkSource = 'Не могу подключиться к неверному источнику.';
  SCannotBreakLink = 'Операция сброса соединения не поддерживается.';
  SLinkedObject = 'Подключен %s';
  SEmptyContainer = 'Операция не разрешена на пустом OLE контейнере';
  SInvalidVerb = 'Invalid object verb';
  SPropDlgCaption = '%s Свойства';
  SInvalidStreamFormat = 'Неверный формат потока';
  SInvalidLicense = 'Неверная информация о лицензии для %s';
  SNotLicensed = 'Информация о лицензии для %s не найдена. Вы не можете использовать этот элемент управления в режиме разработки';
{$IFDEF VER130}
  sNoRunningObject = 'Не могу получить ссылку на работающий объект, зарегистрированный в OLE, для %s/%s';
{$ENDIF}

implementation

end.