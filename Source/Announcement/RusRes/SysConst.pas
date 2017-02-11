{********************************************************}
{                                                        }
{       Borland Delphi Runtime Library                   }
{                                                        }
{       Copyright (C) 1995,99 Inprise Corporation        }
{                                                        }
{ Руссификация: 1999 Polaris Software                    }
{               http://members.xoom.com/PolarisSoft      }
{********************************************************}

unit SysConst;

interface

resourcestring
{$IFDEF VER130}
  SUnknown = '<неизвестен>';
{$ENDIF}
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
  SEndOfFile = 'Чтение за окончанием файла';
  SDiskFull = 'Диск полон';
  SInvalidInput = 'Неверный ввод числа';
  SDivByZero = 'Деление на ноль';
  SRangeError = 'Ошибка выхода за границы (Range check)';
  SIntOverflow = 'Переполнение целого';
  SInvalidOp = 'Неверная операция с дробными числами';
  SZeroDivide = 'Нецелочисленное деление на ноль';
  SOverflow = 'Нецелочисленное переполнение';
  SUnderflow = 'Нецелочисленная потеря (underflow)';
  SInvalidPointer = 'Неверная операция с указателем';
  SInvalidCast = 'Неверное приведение класса';
  SAccessViolation = 'Нарушение доступа по адресу %p. %s по адресу %p';
  SStackOverflow = 'Переполнение стека';
  SControlC = 'Нажатие Control-C';
  SPrivilege = 'Привилегированная инструкция';
  SOperationAborted = 'Операция прервана';
  SException = 'Исключительная ситуация %s в модуле %s по адресу %p.'#$0A'%s%s';
  SExceptTitle = 'Ошибка приложения';
  SInvalidFormat = 'Формат ''%s'' неверен или несовместим с аргументом';
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
{$IFDEF VER130}
  SSafecallException = 'Исключительная ситуация в safecall методе'; 
{$ENDIF}
  SAssertError = '%s (%s, строка %d)';
  SAbstractError = 'Абстрактная ошибка';
  SModuleAccessViolation = 'Нарушение доступа по адресу %p в модуле ''%s''. %s по адресу %p';
  SCannotReadPackageInfo = 'Не могу получить информацию пакета для пакета ''%s''';
  sErrorLoadingPackage = 'Не могу загрузить пакет %s.'#13#10'%s';
  SInvalidPackageFile = 'Неверный файл пакета ''%s''';
  SInvalidPackageHandle = 'Неверный дескриптор пакета';
  SDuplicatePackageUnit = 'Не могу загрузить пакет ''%s''.  Он включает модуль ''%s''' +
    ', который также содержится в пакете ''%s''';
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

implementation

end.





