{*******************************************************}
{                                                       }
{       Delphi Runtime Library                          }
{       System Utilities Include File                   }
{                                                       }
{       Copyright (C) 1995,97 Borland International     }
{                                                       }
{ Руссификация: 1999 Polaris Software                   }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

resourcestring

  SInvalidInteger = '''%s'' - неверное целое значение';
  SInvalidFloat = '''%s'' - неверное дробное значение';
  SInvalidDate = '''%s'' - неверная дата';
  SInvalidTime = '''%s'' - неверное время';
  SInvalidDateTime = '''%s'' - неверная дата и время';
  STimeEncodeError = 'Неверный аргумент для формирования времени';
  SDateEncodeError = 'Неверный аргумент для формирования даты';
  SOutOfMemory = 'Не хватает памяти';
  SInOutError = 'Ошибка ввода/вывода %d';
  SFileNotFound = 'Файл не найден';
  SInvalidFilename = 'Неверное имя файла';
  STooManyOpenFiles = 'Слишком много открытых файлов';
  SAccessDenied = 'В доступе к файлу отказано';
  SEndOfFile = 'Чтение за границей файла';
  SDiskFull = 'Диск полный';
  SInvalidInput = 'Неверный ввод числа';
  SDivByZero = 'Деление на ноль';
  SRangeError = 'Ошибка выхода за границы (Range check error)';
  SIntOverflow = 'Переполнение целого';
  SInvalidOp = 'Неверная операция с дробными числами';
  SZeroDivide = 'Нецелочисленное деление на ноль';
  SOverflow = 'Нецелочисленное переполнение';
  SUnderflow = 'Нецелочисленная потеря (underflow)';
  SInvalidPointer = 'Неверная ссылочная операция';
  SInvalidCast = 'Неверное преобразование типов классов';
  SAccessViolation = 'Нарушение доступа по адресу %p. %s адреса %p';
  SStackOverflow = 'Переполнение стека';
  SControlC = 'Нажато Control-C';
  SPrivilege = 'Привилегированная команда';
  SOperationAborted = 'Операция прервана';
  SException = 'Исключительная ситуация %s в модуле %s по адресу %p.'#$0A'%s%s';
  SExceptTitle = 'Ошибка программы';
  SInvalidFormat = 'Формат ''%s'' - неверный или несовместимый с аргументом';
  SArgumentMissing = 'Нет аргумента для формата ''%s''';
  SInvalidVarCast = 'Неверное преобразование вариантного типа';
  SInvalidVarOp = 'Неверная операция с вариантом';
  SDispatchError = 'Вызовы вариантных методов не поддерживаются';
  SReadAccess = 'Чтение';
  SWriteAccess = 'Запись';
  SResultTooLong = 'Результат форматирования длиннее, чем 4096 символов';
  SFormatTooLong = 'Строка формата слишком длинная';
  SVarArrayCreate = 'Ошибка создания вариантного массива';
  SVarNotArray = 'Вариант не является массивом';
  SVarArrayBounds = 'Индекс вариантного массива вышел за границы';
  SExternalException = 'Внешняя исключительная ситуация %x';
  SAssertionFailed = 'Assertion failed';
  SIntfCastError = 'Интерфейс не поддерживается';
  SAssertError = '%s (%s, строка %d)';
  SAbstractError = 'Абстрактная ошибка';
  SModuleAccessViolation = 'Нарушение доступа по адресу %p в модуле ''%s''. %s по адресу %p';
  SCannotReadPackageInfo = 'Не могу получить информацию пакета для пакета ''%s''';
  sErrorLoadingPackage = 'Не могу загрузить пакет %s.'#13#10'%s';
  SInvalidPackageFile = 'Неверный файл пакета ''%s''';
  SInvalidPackageHandle = 'Неверный дескриптор пакета';
  SDuplicatePackageUnit = 'Не могу загрузить пакет ''%s.''  Он включает модуль ''%s,''' +
    ';который также содержится в пакете ''%s''';
  SWin32Error = 'Ошибка Win32.  Код: %d.'#10'%s';
  SUnkWin32Error = 'Ошибка функции Win32 API';
  SNL = 'Приложение не имеет лицензии на использование этой возможности';

  SShortMonthNameJan = 'Янв';
  SShortMonthNameFeb = 'Фев';
  SShortMonthNameMar = 'Мар';
  SShortMonthNameApr = 'Апр';
  SShortMonthNameMay = 'Май';
  SShortMonthNameJun = 'Июн';
  SShortMonthNameJul = 'Июл';
  SShortMonthNameAug = 'Авг';
  SShortMonthNameSep = 'Сен';
  SShortMonthNameOct = 'Окт';
  SShortMonthNameNov = 'Ноя';
  SShortMonthNameDec = 'Дек';

  SLongMonthNameJan = 'Январь';
  SLongMonthNameFeb = 'Февраль';
  SLongMonthNameMar = 'Март';
  SLongMonthNameApr = 'Апрель';
  SLongMonthNameMay = 'Май';
  SLongMonthNameJun = 'Июнь';
  SLongMonthNameJul = 'Июль';
  SLongMonthNameAug = 'Август';
  SLongMonthNameSep = 'Сентябрь';
  SLongMonthNameOct = 'Октябрь';
  SLongMonthNameNov = 'Ноябрь';
  SLongMonthNameDec = 'Декабрь';

  SShortDayNameSun = 'Вск';
  SShortDayNameMon = 'Пон';
  SShortDayNameTue = 'Втр';
  SShortDayNameWed = 'Срд';
  SShortDayNameThu = 'Чет';
  SShortDayNameFri = 'Пят';
  SShortDayNameSat = 'Суб';

  SLongDayNameSun = 'Воскресенье';
  SLongDayNameMon = 'Понедельник';
  SLongDayNameTue = 'Вторник';
  SLongDayNameWed = 'Среда';
  SLongDayNameThu = 'Четверг';
  SLongDayNameFri = 'Пятница';
  SLongDayNameSat = 'Суббота';

{  SInvalidInteger = 65408;
  SInvalidFloat = 65409;
  SInvalidDate = 65410;
  SInvalidTime = 65411;
  SInvalidDateTime = 65412;
  STimeEncodeError = 65413;
  SDateEncodeError = 65414;
  SOutOfMemory = 65415;
  SInOutError = 65416;
  SFileNotFound = 65417;
  SInvalidFilename = 65418;
  STooManyOpenFiles = 65419;
  SAccessDenied = 65420;
  SEndOfFile = 65421;
  SDiskFull = 65422;
  SInvalidInput = 65423;
  SDivByZero = 65424;
  SRangeError = 65425;
  SIntOverflow = 65426;
  SInvalidOp = 65427;
  SZeroDivide = 65428;
  SOverflow = 65429;
  SUnderflow = 65430;
  SInvalidPointer = 65431;
  SInvalidCast = 65432;
  SAccessViolation = 65433;
  SStackOverflow = 65434;
  SControlC = 65435;
  SPrivilege = 65436;
  SOperationAborted = 65437;
  SException = 65438;
  SExceptTitle = 65439;
  SInvalidFormat = 65440;
  SArgumentMissing = 65441;
  SInvalidVarCast = 65442;
  SInvalidVarOp = 65443;
  SDispatchError = 65444;
  SReadAccess = 65445;
  SWriteAccess = 65446;
  SResultTooLong = 65447;
  SFormatTooLong = 65448;
  SVarArrayCreate = 65449;
  SVarNotArray = 65450;
  SVarArrayBounds = 65451;
  SExternalException = 65452;
  SAssertionFailed = 65453;
  SIntfCastError = 65454;
  SAssertError = 65455;
  SModuleAccessViolation = 65456;
  SCannotReadPackageInfo = 65457;
  SErrorLoadingPackage = 65458;
  SInvalidPackageFile = 65459;
  SInvalidPackageHandle = 65460;
  SDuplicatePackageUnit = 65461;
  SWin32Error = 65462;
  SUnkWin32Error = 65463;

  SShortMonthNames = 65472;
  SLongMonthNames = 65488;
  SShortDayNames = 65504;
  SLongDayNames = 65511;}
