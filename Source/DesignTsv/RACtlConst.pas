{***********************************************************
                R&A Library
       Copyright (C) 1996-2000 R&A

       description : Language specific constants for Russian

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru
************************************************************}

{$INCLUDE RA.INC}

unit RACtlConst;

interface

const

 {TRADBTreeView}
  SDeleteNode             = 'Удалить %s ?';
  SDeleteNode2            = 'Удалить %s (вместе со всем содержимым) ?';
  SMasterFieldEmpty       = '"MasterField" property must be filled';
  SDetailFieldEmpty       = '"DetailField" property must be filled';
  SItemFieldEmpty         = '"ItemField" property must be filled';
  SMasterDetailFieldError = '"MasterField" and "DetailField" must be of same type';
  SMasterFieldError       = '"MasterField" must be integer type';
  SDetailFieldError       = '"DetailField" must be integer type';
  SItemFieldError         = '"ItemField" must be string, date or integer type';
  SIconFieldError         = '"IconField" must be integer type';
  SMoveToModeError        = 'Неверный режим перемещения RADBTreeNode';
  SDataSetNotActive       = 'DataSet not active';

   {RegAutoEditor}
  sRegAutoEditorEdtPropHint    = 'Имя свойства можно ввести прямо здесь';
  sRegAutoEditorTreeHint       = 'Доступные свойства';
  sRegAutoEditorListHint       = 'Список сохраняемых свойств';
  sRegAutoEditorBtnAddPropHint = 'Добавить/Удалить свойство';
  sRegAutoEditorSort           = 'Упорядочить';

 {RAEditor}
  RAEditorCompletionChars = #8+'_0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁйцукенгшщзхъфывапролджэячсмитьбюё';

{IParser}
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

{$IFDEF RA_D2}
  SScrollBarRange = 'значение Scrollbar вышло за допустимые пределы';
{$ENDIF}

 {RADlg}
  SOk = 'OK';
  SCancel = 'Отмена';

 { Menu Designer }
  SMDMenuDesigner       = 'Menu &Designer';
  SMDInsertItem         = '&Insert';
  SMDDeleteItem         = '&Delete';
  SMDCreateSubmenuItem  = 'Create &SubMenu';

  SCantGetShortCut      = 'Target FileName for ShortCut %s not available';


 { RALib 1.23 } 
  SPropertyNotExists    = 'Property "%s" does not exists';
  SInvalidPropertyType  = 'Property "%s" has invalid type';

 { RALib 1.55 }

 {RAHLEdPropDlg}
  SHLEdPropDlg_Caption = 'Свойства: Редактор';
  SHLEdPropDlg_tsEditor = 'Редактор';
  SHLEdPropDlg_tsColors = 'Цвета';
  SHLEdPropDlg_lblEditorSpeedSettings = 'Набор горячих клавиш';
  SHLEdPropDlg_cbKeyboardLayotDefault = 'Стандартный набор';
  SHLEdPropDlg_gbEditor = 'Параметры редактора:';
  SHLEdPropDlg_cbAutoIndent = '&Автоотступ';
  SHLEdPropDlg_cbSmartTab = '&Умный таб';
  SHLEdPropDlg_cbBackspaceUnindents = 'Забой &сдвигает назад';
  SHLEdPropDlg_cbGroupUndo = '&Групповая отмена';
  SHLEdPropDlg_cbCursorBeyondEOF = 'Курсор за конец &файла';
  SHLEdPropDlg_cbUndoAfterSave = 'Отмена &после сохранения';
  SHLEdPropDlg_cbKeepTrailingBlanks = 'Сохранять &завершающие пробелы';
  SHLEdPropDlg_cbDoubleClickLine = '&Двойной клик выделяет строку';
  SHLEdPropDlg_cbSytaxHighlighting = 'Выделять &синтаксис';
  SHLEdPropDlg_lblTabStops = '&Табулостопы:';
  SHLEdPropDlg_lblColorSpeedSettingsFor = 'Цвета для';
  SHLEdPropDlg_lblElement = '&Элемент:';
  SHLEdPropDlg_lblColor = '&Цвет:';
  SHLEdPropDlg_gbTextAttributes = 'Атрибуты текста:';
  SHLEdPropDlg_gbUseDefaultsFor = 'Стандартные:';
  SHLEdPropDlg_cbBold = '&Жирный';
  SHLEdPropDlg_cbItalic = '&Наклонный';
  SHLEdPropDlg_cbUnderline = '&Подчеркнутый';
  SHLEdPropDlg_cbDefForeground = '&Буквы';
  SHLEdPropDlg_cbDefBackground = '&Фон';
  SHLEdPropDlg_OptionCantBeChanged = 'Этот параметр менять нельзя. Извините.';
  SHLEdPropDlg_RAHLEditorNotAssigned = 'Свойство RAHLEditor не назначено';
  SHLEdPropDlg_RegAutoNotAssigned = 'Свойство RegAuto не назначено';

  { add by TSV}

  Const_ecLeft='Влево';
  Const_ecRight='Вправо';
  Const_ecUp='Вверх';
  Const_ecDown='Вниз';
  Const_ecSelLeft='Выделить слева';
  Const_ecSelRight='Выделить справа';
  Const_ecSelUp='Выделить вверх';
  Const_ecSelDown='Выделить вниз';
  Const_ecBeginLine='На начальную линию';
  Const_ecSelBeginLine='Выделить до начальной линии';
  Const_ecBeginDoc='В начало документа';
  Const_ecSelBeginDoc='Выделить до начала документа';
  Const_ecEndLine='На последнюю линию';
  Const_ecSelEndLine='Выделить до последней линии';
  Const_ecEndDoc='В конец документа';
  Const_ecSelEndDoc='Выделить до конца документа';
  Const_ecPrevWord='Предыдущее слово';
  Const_ecNextWord='Следующее слово';
  Const_ecSelPrevWord='Выделить предыдущее слово';
  Const_ecSelNextWord='Выделить следующее слово';
  Const_ecSelAll='Выделить все';

  Const_ecWindowTop='Окно вверх';
  Const_ecWindowBottom='Окно вниз';
  Const_ecPrevPage='Предыдущая страница';
  Const_ecNextPage='Следующая страница';
  Const_ecSelPrevPage='Выделить предыдущую страницу';
  Const_ecSelNextPage='Выделить следующую страницу';
  Const_ecScrollLineUp='Пролистать линии вверх';
  Const_ecScrollLineDown='Пролистать линии вниз';

  Const_ecChangeInsertMode='Изменит действие Insert';

  Const_ecInsertPara='Перевод каретки';
  Const_ecBackspace='Забой';
  Const_ecDelete='Удалить';
  Const_ecTab='Табуляция';
  Const_ecBackTab='Обратная табуляция';
  Const_ecDeleteSelected='Удалить выделенное';
  Const_ecClipboardCopy='Копировать в буфер';
  Const_ecClipboardCut='Вырезать в буфер';
  Const_ecClipBoardPaste='Вставить из буфера';

  Const_ecSetBookmark0='Поставить закладку 0';
  Const_ecSetBookmark1='Поставить закладку 1';
  Const_ecSetBookmark2='Поставить закладку 2';
  Const_ecSetBookmark3='Поставить закладку 3';
  Const_ecSetBookmark4='Поставить закладку 4';
  Const_ecSetBookmark5='Поставить закладку 5';
  Const_ecSetBookmark6='Поставить закладку 6';
  Const_ecSetBookmark7='Поставить закладку 7';
  Const_ecSetBookmark8='Поставить закладку 8';
  Const_ecSetBookmark9='Поставить закладку 9';

  Const_ecGotoBookmark0='Перейти к закладке 0';
  Const_ecGotoBookmark1='Перейти к закладке 1';
  Const_ecGotoBookmark2='Перейти к закладке 2';
  Const_ecGotoBookmark3='Перейти к закладке 3';
  Const_ecGotoBookmark4='Перейти к закладке 4';
  Const_ecGotoBookmark5='Перейти к закладке 5';
  Const_ecGotoBookmark6='Перейти к закладке 6';
  Const_ecGotoBookmark7='Перейти к закладке 7';
  Const_ecGotoBookmark8='Перейти к закладке 8';
  Const_ecGotoBookmark9='Перейти к закладке 9';

  Const_ecNonInclusiveBlock='Не эксклюзивный блок';
  Const_ecInclusiveBlock='Эксклюзивный блок';
  Const_ecColumnBlock='Колоночный блок';

  Const_ecUndo='Отмена';

  Const_ecCompletionIdentifers='Идентификаторы';
  Const_ecCompletionTemplates='Заготовка кода';

  { cursor movement - default and classic }

  Const_ecDeleteWord='Удалить слово';
  Const_ecDeleteLine='Удалить линию';

  Const_ecSelWord='Выделить слово';
  Const_ecToUpperCase='Перевести в верхний регистр';
  Const_ecToLowerCase='Перевести в нижний регистр';
  Const_ecChangeCase='Изменить регистр';
  Const_ecIndent='Indent';
  Const_ecUnindent='Unindent';

  Const_ecRecordMacro='RecordMacro';
  Const_ecPlayMacro='PlayMacro';

  Const_ecNewScript='Новый скрипт';
  Const_ecOpenScript='Открыть скрипт';
  Const_ecSaveScript='Сохранить скрипт';
  Const_ecSaveScriptToBase='Сохранить скрипт в базу';
  Const_ecRunScript='Запустить скрипт';
  Const_ecStopScript='Остановить скрипт';
  Const_ecResetScript='Прервать скрипт';
  Const_ecCompileScript='Компилировать скрипт';
  Const_ecGotoLine='Перейти на линию';
  Const_ecFind='Найти';
  Const_ecFindNext='Найти далее';
  Const_ecReplace='Заменить';
  Const_ecViewOption='Настройка';
  Const_ecViewForms='Показать формы';

  ConstReplaceText='Заменить этот текст на <%s>?';
  ConstReplaceConfirm='Подтверждение';

  // Long operations
  ConstLongOperationExpandTabs='Преобразование';


implementation

end.

