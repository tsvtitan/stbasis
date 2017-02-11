{*******************************************************}
{                                                       }
{       Borland Delphi Runtime Library                  }
{                                                       }
{       Copyright (C) 1998-99 Inprise Corporation       }
{                                                       }
{ Руссификация: 1998-99 Polaris Software                }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit CorbCnst;

interface

resourcestring
  SCorbaDllNotLoaded = 'Не могу загрузить библиотеки CORBA';
  SCorbaNotInitialized = 'Библиотеки CORBA не найдены или не инициализированы';
  SCorbaSkeletonNotRegistered = 'Сервер-скелет CORBA не зарегистрирован для объекта %s';
  SCorbaStubNotRegistered = 'Клиентский экземпляр (stub) CORBA не зарегистрирован';
  SCorbaInterfaceIDNotRegister = 'Интерфейс CORBA не зарегистрирован';
  SCorbaRepositoryIDNotRegistered = 'CORBA Repository ID "%s" не зарегистрирован';
  SCorbaIncompleteFactory = 'CORBA Factory не выполнила CreateInterface';

resourcestring
  sInvalidTypeCast = 'Вариант не может быть сконвертирован в CORBA Any';
  sNotCorbaObject = 'Variant/Any - не объект CORBA';
  sParamTypeCast = 'Параметр (%d) метода %s - неверного типа';
  sParamOut = 'Параметр (%d) метода %s - параметр out или in/out и требует обращения как к переменной';
  sNoRepository = 'Не могу выполнить CORBA Dispatch, не найден репозиторий интерфейса';
  sInvalidParameterCount = 'неверное количество параметров у метода %s';
  sMethodNotFound = 'Метод %s не найден';
  sConnecting = 'Соединение с сервером CORBA...';

implementation

end.
