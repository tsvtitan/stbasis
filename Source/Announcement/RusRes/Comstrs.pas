{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{       Copyright (c) 1996,99 Inprise Corporation       }
{                                                       }
{ Руссификация: 1998-99 Polaris Software                }
{               http://members.xoom.com/PolarisSoft     }
{*******************************************************}

unit ComStrs;

interface

resourcestring
{$IFNDEF VER100}
  sTabFailClear = 'Не удалось очистить tab control';
  sTabFailDelete = 'Не удалось удалить страницу (tab) с индексом %d';
  sTabFailRetrieve = 'Не удалось восстановить страницу (tab) с индексом %d';
  sTabFailGetObject = 'Не удалось получить объект с индексом %d';
  sTabFailSet = 'Не удалось установить страницу (tab) "%s" с индексом %d';
  sTabFailSetObject = 'Не удалось установить объект с индексом %d';
  sTabMustBeMultiLine = 'MultiLine должно быть True, когда TabPosition равно tpLeft или tpRight';
{$ELSE}
  sTabAccessError = 'Ошибка доступа к tab control';
{$ENDIF}

  sInvalidLevel = 'Присваивание неверного уровня элемента';
  sInvalidLevelEx = 'Неверный уровень (%d) для элемента "%s"';
  sInvalidIndex = 'Неверный индекс';
  sInsertError = 'Невозможно вставить элемент';

  sInvalidOwner = 'Неверный владелец';
  sUnableToCreateColumn = 'Невозможно создать новый столбец';
  sUnableToCreateItem = 'Невозможно создать новый элемент';

  sRichEditInsertError = 'Ошибка вставки строки в RichEdit';
  sRichEditLoadFail = 'Сбой при Load Stream';
  sRichEditSaveFail = 'Сбой при Save Stream';

  sTooManyPanels = 'StatusBar не может иметь более 64 панелей';

  sHKError = 'Ошибка назначения Hot-Key на %s. %s';
  sHKInvalid = 'Неверный Hot-Key';
  sHKInvalidWindow = 'Неверное или дочернее окно';
  sHKAssigned = 'Hot-Key назначен на другое окно';

  sUDAssociated = '%s уже связан с %s';

  sPageIndexError = 'Неверное значение PageIndex (%d).  PageIndex должен быть ' +
    'между 0 и %d';

  sInvalidComCtl32 = 'Этот компонент требует COMCTL32.DLL версии 4.70 или выше';

  sDateTimeMax = 'Дата превысила максимум %s';
  sDateTimeMin = 'Дата меньше, чем минимум %s';
  sNeedAllowNone = 'Требуется режим ShowCheckbox для установки этой даты';
{$IFNDEF VER100}
  sFailSetCalDateTime = 'Ошибка при установке даты или времени в календаре';
  sFailSetCalMaxSelRange = 'Ошибка при установке максимального диапазона выбора';
  sFailSetCalMinMaxRange = 'Ошибка при установке мин/макс диапазона календаря';
  sCalRangeNeedsMultiSelect = 'Диапазон дат может использоваться только в режиме мультивыбора';
  sFailsetCalSelRange = 'Ошибка при установке выбранного диапазона календаря';
{$ENDIF}

implementation

end.
