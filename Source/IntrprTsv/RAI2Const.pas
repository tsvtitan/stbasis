{***********************************************************
                R&A Library
       Copyright (C) 1996-2000 R&A

       description : Language specific constant for English

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru
************************************************************}

{$INCLUDE RA.INC}

unit RAI2Const;

interface

const

{RAI2Parser}
 {$IFDEF RA_D}
  StIdSymbols      = ['_', '0'..'9', 'A'..'Z', 'a'..'z', 'А'..'Я', 'а'..'я'];
  StIdFirstSymbols = ['_', 'A'..'Z', 'a'..'z', 'А'..'Я', 'а'..'я'];
  StConstSymbols   = ['0'..'9', 'A'..'F', 'a'..'f'];
  StConstSymbols10 = ['0'..'9'];
  StSeparators     = ['(', ')', ',', '.', ';'];
 {$ENDIF RA_D}
 {$IFDEF RA_B}
  StIdSymbols      = '_0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁйцукенгшщзхъфывапролджэячсмитьбюё';
  StIdFirstSymbols = '_QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁйцукенгшщзхъфывапролджэячсмитьбюё';
  StConstSymbols   = '0123456789ABCDEFabcdef';
  StConstSymbols10 = '0123456789';
  StSeparators     = '(),.;';
 {$ENDIF RA_B}

 {RAI2Fm}
  SNoReportProc = 'Не найдена процедура "RAI2RunReportPreview"';
  SNoReportProc2 = 'Не найдена процедура "RAI2RunReportPreview2"';

 {RAI2 Error Descriptions}
  RAI2Errors : array [0..47] of
    record
      ID: Integer;
      Description: String;
    end
    = (
      (ID:   0; Description: 'Ok'),
      (ID:   1; Description: 'Неизвестная ошибка'),
      (ID:   2; Description: 'Внутренняя ошибка интерпретатора: %s'),
      (ID:   3; Description: 'Прервано пользователем'),
      (ID:   4; Description: 'Re-raising an exception only allowed in exception handler'),
      (ID:   5; Description: 'Ошибка в модуле ''%s'' на линии %d : %s'),
      (ID:   6; Description: 'Внешняя ошибка в модуле ''%s'' на линии %d : %s'),
      (ID:   7; Description: 'Нет доступа к ''%s'''),
      (ID:  31; Description: 'Запись ''%s'' не определена'),

      (ID:  52; Description: 'Переполнение стека'),
      (ID:  53; Description: 'Неверный тип'),
      (ID:  55; Description: 'Функция ''ViewInterface'' не определена'),
      (ID:  56; Description: 'Модуль ''%s'' не найден'),
      (ID:  57; Description: 'Событие ''%s'' не зарегистрировано'),
      (ID:  58; Description: 'Форма ''%s'' не найдена'),

      (ID: 101; Description: 'Ошибка в замечании'),
      (ID: 103; Description:'%s ожидалось(ся), но найден(а) %s'),
      (ID: 104; Description: 'Не определен идентификатор ''%s'''),
      (ID: 105; Description: 'Тип выражения должен быть булев'),
      (ID: 106; Description: 'Требуется тип класса'),
      (ID: 107; Description:' не допускается до если'),
      (ID: 108; Description: 'Тип выражения должен быть целым'),
      (ID: 109; Description: 'Требуется тип запись, объект или класс'),
      (ID: 110; Description: 'Не наидена точка с запятой'),
      (ID: 111; Description: 'Идентификатор объявлен много раз: ''%s'''),

      (ID: 171; Description: 'Индекс массива вне пределов'),
      (ID: 172; Description: 'Слишком большие пределы массива'),
      (ID: 173; Description: 'Не хватает пределов массива'),
      (ID: 174; Description: 'Неверный размер массива'),
      (ID: 175; Description: 'Неверные пределы массива'),
      (ID: 176; Description: 'Требуется тип массива'),

      (ID: 181; Description: 'Слишком много фактических параметров'),
      (ID: 182; Description: 'Не хватает параметров'),
      (ID: 183; Description: 'Несовместимые типы: ''%s'' и ''%s'''),
      (ID: 184; Description: 'Ошибка загрузки библиотеки ''%s'''),
      (ID: 185; Description: 'Неверный тип аргументов в вызываемой функции ''%s'''),
      (ID: 186; Description: 'Неверный тип возвращаемый функцией ''%s'''),
      (ID: 187; Description: 'Немогу получить адрес для функции ''%s'''),
      (ID: 188; Description: 'Неверный тип аргументов в вызове функции ''%s'''),
      (ID: 189; Description: 'Неверный тип возврата в вызове функции ''%s'''),
      (ID: 190; Description: 'Неверное соглашение для вызова функции ''%s'''),

      (ID: 201; Description: 'Вызов ''%s'' неудачный: ''%s'''),

      (ID: 301; Description: 'Выражение'),
      (ID: 302; Description: 'Индетификатор'),
      (ID: 303; Description: 'Объявление'),
      (ID: 304; Description: 'конец файла'),
      (ID: 305; Description: 'объявление класса'),

      (ID: 401; Description: 'Раздел ''Implementation'' не найден в модуле')
    );

implementation

end.
