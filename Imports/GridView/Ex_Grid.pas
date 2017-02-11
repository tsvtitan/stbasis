{
  Библиотека дополнительных компонентов

  GridView компонент (таблица)

  Некоторые свойства:

  - образован от TCustomControl; не требует TCustomGrid и т.п.
    компоненты-таблицы от Delphi, но имеет практически все аналогичные
    свойства
  - не хранит строки внутри себя, имеет методы по принятию строки ячейки
    извне для отрисовки.
  - выглядит как TListView в режиме таблицы (т.е. при ViewStyle = vsReport)
  - многострочный, многосекционный иерархический (можно сделать одну секцию
    на несколько колонок) заголовок; не является фиксированнымы строками,
    как это сделано в TCustomGrid
  - выравнивание текста секции заголовка влево, по центру, вправо
  - свои цвет и шрифт для заголовка
  - возможность настроить цвет и шрифт каждой секции заголовка
  - возможность автоматического переноса слов заголовка (WordWrap)
  - встроенная строка редактирования с кнопкой ... и выпадающим списком,
    тип строки редактирования выбирается
  - изменение ширины колонок, запрет на изменение ширины отдельных колонок
  - управление видимостью колонок
  - выравнивание текста колонок влево, по центру, вправо
  - поддержка вывода многострочного и однострочного текста в колонках с
    однострочной и многострочной строкой редактирования
  - фиксированные колонки (всегда слева, не скроллируются по горизонтали)
  - отдельный цвет и шрифт для фиксированных
  - возможность вывода текста ячеек с троеточием на конце, если текст
    целиком не помещается в ячейку
  - встроенная поддержка картинок для ячеек
  - плавный горизонтальный скроллинг ячеек
  - CellTips - Hint для ячеек, у которых текст не помещается целиком в
    ячейку (аналог ToolTips у TTreeView, только для Delphi3 и выше).
  - возможность запрещения установки курсора на отдельные ячейки
  - возможность построчного и одиночного выделения ячеек
  - развитые возможности по пользовательской отрисовки ячеек и секций
    заголовка (аналог TStringGrid.OnDrawCell)
  - возможность настроить цвет и шрифт каждой ячейки не до ее отрисовки
    (т.е. не перехватывая OnDrawCell)
  - практически все процедуры по настройке внешнего вида таблицы не скрыты
    в private части и могут быть легко переопределены в объектах - потомках
  - куча сервисных процедур и функций для работы с объектом

  НЕ ПОДДЕРЖИВАЕТСЯ:

  - разная высота строк
  - RangeSelect (выделение нескольких ячеек одновременно)
  - маска строки редактирования (просто не надо было, да и не хочется цеплять
    Mask.pas, но можно сделать)

  Сделать:

  - вид секций заголовка как кнопки и возможность нажития на них
    (аналог Columnclick у TListView)
  - CellTips, не зависящий от Hint (как ToolTips у TTreeView)

  Роман М. Мочалов
  E-mail: roman@sar.nnov.ru
}

unit Ex_Grid;

interface

uses
  Windows, Messages, SysUtils, CommCtrl, Classes, Controls, Graphics, Forms,
  StdCtrls, Math, ImgList;

type

{ Предопределение класов }

  TGridHeaderSections = class;
  TGridHeader = class;
  TGridColumn = class;
  TGridColumns = class;
  TGridRows = class;
  TGridFixed = class;
  TCustomGridView = class;

{ TGridHeaderSection }

  {
    Секция заголовка.

    Свойства:

    Column -         Индекс соответствующей колонки. Для заголовка с
                     подзаголовками индекс, соотвествующий последнему
                     подзаголовку.
    Bounds -         Прямойгольник секции.
    FixedSize -      Столбец заголовка или один из его подзоголовков
                     фиксирован.
    Header -         Ссылка на заголовок таблицы.
    Level -          Уровень заголовка. Самый верхний заголовок имеет
                     уровень 0, под ним - 1 и т.д.
    Parent -         Ссылка на верхнюю секцию.
    ParentSections - Ссылка на список секций, которому принадлежит данная
                     секция.

    Alignment -      Выравнивание текста заголовка по горизонтали.
    Caption -        Текст заголовка. Соответствует заголовку колонки.
    Sections -       Список подзаголовков (т.е. секций снизу).
    Width -          Ширина заголовка. Равна ширине соотвествующей колонки
                     или сумме ширин подзаголовков.
    WordWrap -       Перенос слов текста заголовка.
  }

  TGridHeaderSection = class(TCollectionItem)
  private
    FSections: TGridHeaderSections;
    FCaption: string;
    FWidth: Integer;
    FAlignment: TAlignment;
    FWordWrap: Boolean;
    function GetBounds: TRect;
    function GetColumn: Integer;
    function GetFixedSize: Boolean;
    function GetHeader: TGridHeader;
    function GetLevel: Integer;
    function GetParent: TGridHeaderSection;
    function GetParentSections: TGridHeaderSections;
    function GetSections: TGridHeaderSections;
    function GetWidth: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetSections(Value: TGridHeaderSections);
    procedure SetWidth(Value: Integer);
    procedure SetWordWrap(Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Bounds: TRect read GetBounds;
    property Column: Integer read GetColumn;
    property FixedSize: Boolean read GetFixedSize;
    property Header: TGridHeader read GetHeader;
    property Level: Integer read GetLevel;
    property Parent: TGridHeaderSection read GetParent;
    property ParentSections: TGridHeaderSections read GetParentSections;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string read FCaption write SetCaption;
    property Width: Integer read GetWidth write SetWidth default 64;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property Sections: TGridHeaderSections read GetSections write SetSections;
  end;

{ TGridHeaderSections }

  {
    Список секций заголовка.

    Процедуры:

    Add -         Добавить новую секцию в список.
    Synchronize - Уравнивает количество нижних секций с количеством
                  указанных столбцов.

    Свойства:

    Header -      Ссылка на заголовок таблицы.
    MaxColumn -   Максимальный индекс столбца.
    MaxLevel -    Максимальный уровень подзаголовков.
    Owner -       Ссылка на секцию - владельца.
    Sections -    Список подзаголовков.
  }

  TGridHeaderSections = class(TCollection)
  private
    FHeader: TGridHeader;
    FOwner: TGridHeaderSection;
    function GetMaxColumn: Integer;
    function GetMaxLevel: Integer;
    function GetSection(Index: Integer): TGridHeaderSection;
    procedure SetSection(Index: Integer; Value: TGridHeaderSection);
  protected
    function GetOwner: TPersistent; {$IFNDEF VER90} override; {$ENDIF}
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AHeader: TGridHeader; AOwner: TGridHeaderSection);
    function Add: TGridHeaderSection;
    procedure Synchronize(Columns: TGridColumns);
    property Header: TGridHeader read FHeader;
    property MaxColumn: Integer read GetMaxColumn;
    property MaxLevel: Integer read GetMaxLevel;
    property Owner: TGridHeaderSection read FOwner;
    property Sections[Index: Integer]: TGridHeaderSection read GetSection write SetSection; default;
  end;

{ TGridHeader }

  {
    Заголовок таблицы.

    Свойства:

    Grid -              Ссылка на таблицу.
    Height -            Высота.
    MaxColumn -         Максимальный индекс столбца.
    MaxLevel -          Максимальный уровень подзаголовков.
    Width -             Ширина

    AutoSynchronize -   Автоматически синхронизировать секции заголовка с
                        колонками.
    Color -             Цвет фона.
    Font -              Шрифт.
    FullSynchronizing - Полностью синхронизировать секции заголовка с
                        колонками, включая текст заголовка и выравнивание
                        текста. В противном случае синхронизируется только
                        количество секций с количеством колонок.
    GridColor -         Брать ли в качестве цвета заголовка цвет таблицы.
    GridFont -          Брать ли в качестве шрифта заголовка шрифт таблицы.
    SectionHeight -     Высота одной секции (подзаголовка)
    Sections -          Список подзаголовков.
    Synchronized -      Секции заголовка синхронизированы с колонками
                        таблицы.

    События:

    OnChange -        Событие на изменение параметров.
  }

  TGridHeader = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FSections: TGridHeaderSections;
    FSectionHeight: Integer;
    FSynchronized: Boolean;
    FAutoSynchronize: Boolean;
    FFullSynchronizing: Boolean;
    FColor: TColor;
    FGridColor: Boolean;
    FFont: TFont;
    FGridFont: Boolean;
    FOnChange: TNotifyEvent;
    procedure FontChange(Sender: TObject);
    function GetHeight: Integer;
    function GetMaxColumn: Integer;
    function GetMaxLevel: Integer;
    function GetWidth: Integer;
    procedure GridColorChanged(NewColor: TColor);
    procedure GridFontChanged(NewFont: TFont);
    procedure SetAutoSynchronize(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetFont(Value: TFont);
    procedure SetGridColor(Value: Boolean);
    procedure SetGridFont(Value: Boolean);
    procedure SetSections(Value: TGridHeaderSections);
    procedure SetSectionHeight(Value: Integer);
    procedure SetSynchronized(Value: Boolean);
  protected
    procedure Change; virtual;
  public
    constructor Create(AGrid: TCustomGridView);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Grid: TCustomGridView read FGrid;
    property Height: Integer read GetHeight;
    property MaxColumn: Integer read GetMaxColumn;
    property MaxLevel: Integer read GetMaxLevel;
    property Width: Integer read GetWidth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property AutoSynchronize: Boolean read FAutoSynchronize write SetAutoSynchronize default True;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Font: TFont read FFont write SetFont;
    property FullSynchronizing: Boolean read FFullSynchronizing write FFullSynchronizing default False;
    property GridColor: Boolean read FGridColor write SetGridColor default False;
    property GridFont: Boolean read FGridFont write SetGridFont default True;
    property Sections: TGridHeaderSections read FSections write SetSections;
    property SectionHeight: Integer read FSectionHeight write SetSectionHeight default 17;
    property Synchronized: Boolean read FSynchronized write SetSynchronized default True;
  end;

{ TGridColumn }

  {
    Колонка таблицы.

    Свойства: 

    Columns -   Ссылка на список колонок.

    Alignment - Выравнивание текста колонки.
    Caption -   Текст заголовка.
    FixedSize - Ширина колонки постоянна.
    MaxLength - Максимальная длина редактируемого текста.
    MultiLine - Может ли быть текст в ячейках многострочным.
    ReadOnly  - Не редактируемая.
    Visible -   Видимость.
    Width -     Ширина колонки. Если колонка не видима, возвращает нуль.
    DefWidth -  Реальная ширина колонки. Не зависит от видимости столбца.
  }

  TGridColumn = class(TCollectionItem)
  private
    FColumns: TGridColumns;
    FCaption: string;
    FWidth: Integer;
    FDefWidth: Integer;
    FFixedSize: Boolean;
    FMaxLength: Integer;
    FAlignment: TAlignment;
    FReadOnly: Boolean;
    FMultiLine: Boolean;
    FVisible: Boolean;
    function GetWidth: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetMaxLength(Value: Integer);
    procedure SetMultiLine(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure SetVisible(Value: Boolean);
    procedure SetWidth(Value: Integer);
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    property Columns: TGridColumns read FColumns;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string read FCaption write SetCaption;
    property FixedSize: Boolean read FFixedSize write FFixedSize default False;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property MultiLine: Boolean read FMultiLine write SetMultiLine default False;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property Visible: Boolean read FVisible write SetVisible default True;
    property Width: Integer read GetWidth write SetWidth default 64;
    property DefWidth: Integer read FWidth write SetWidth default 64;
  end;

{ TGridColumns }

  {
    Список колонок таблицы.

    Процедуры:

    Add -     Добавить колонку.

    Свойства:

    Columns - Список колонок.
    Grid    - Ссылка на таблицу.
  }

  TGridColumns = class(TCollection)
  private
    FGrid: TCustomGridView;
    FOnChange: TNotifyEvent;
    function GetColumn(Index: Integer): TGridColumn;
    procedure SetColumn(Index: Integer; Value: TGridColumn);
  protected
    function GetOwner: TPersistent; {$IFNDEF VER90} override; {$ENDIF}
    procedure Update(Item: TCollectionItem); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AGrid: TCustomGridView);
    function Add: TGridColumn;
    property Columns[Index: Integer]: TGridColumn read GetColumn write SetColumn; default;
    property Grid: TCustomGridView read FGrid;
  end;

{ TGridRows }

  {
    Строки таблицы.

    Свойства:

    MaxCount -  Максимально допустимое количество строк в таблице. Зависит
                от высоты строки.
                
    Count -     Количество строк в таблице.
    Grid -      Ссылка на таблицу.
    Height -    Высота одной строки. Не может быть меньше высоты картинки
                таблицы.

    События:

    OnChange -        Событие на изменение параметров.
  }

  TGridRows = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FCount: Integer;
    FHeight: Integer;
    FOnChange: TNotifyEvent;
    function GetMaxCount: Integer;
    procedure SetHeight(Value: Integer);  
  protected
    procedure Change; virtual;
    procedure SetCount(Value: Integer); virtual;
  public
    constructor Create(AGrid: TCustomGridView);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property MaxCount: Integer read GetMaxCount;
    property Grid: TCustomGridView read FGrid;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Count: Integer read FCount write SetCount default 0;
    property Height: Integer read FHeight write SetHeight default 17;
  end;

{ TGridFixed }

  {
    Параметры фиксированныех колонок таблицы.

    Count -     Количество фиксированных столбцов. Не может быть больше, чем
                количество столбцов таблицы минус 1.
    Color -     Цвет фиксированной части.
    Font -      Шрифт.
    GridColor - Брать ли в качестве цвета фиксированных цвет таблицы.
    GridFont -  Брать ли в качестве шрифта фиксированных шрифт таблицы.

    События:

    OnChange -  Событие на изменение параметров.
  }

  TGridFixed = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FCount: Integer;
    FColor: TColor;
    FGridColor: Boolean;
    FFont: TFont;
    FGridFont: Boolean;
    FOnChange: TNotifyEvent;
    procedure FontChange(Sender: TObject);
    procedure GridColorChanged(NewColor: TColor);
    procedure GridFontChanged(NewFont: TFont);
    procedure SetColor(Value: TColor);
    procedure SetFont(Value: TFont);
    procedure SetGridColor(Value: Boolean);
    procedure SetGridFont(Value: Boolean);
  protected
    procedure Change; virtual;
    procedure SetCount(Value: Integer); virtual;
  public
    constructor Create(AGrid: TCustomGridView);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Grid: TCustomGridView read FGrid;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Count: Integer read FCount write SetCount default 0;
    property Font: TFont read FFont write SetFont;
    property GridColor: Boolean read FGridColor write SetGridColor default False;
    property GridFont: Boolean read FGridFont write SetGridFont default True;
  end;

{ TGridCell }

  TGridCell = record
    Col: Longint;
    Row: Longint;
  end;

{ TGridScrollBar }

  {
    Полоса прокрутки таблицы.

    Процедуры:

    Change -        Вызывается стразу после изменения позиции. 
    Scroll -        Вызывается непосредственно перед изменением позиции для
                    корректировки нового положения.
    ScrollMessage - Обработать сообщение Windows о нажатии на скроллер.
    SetParams -     Установить пределы.
    SetPosition -   Установить позицию.
    SetPositionEx - Установить позицию.

    Свойства:

    Grid -          Ссылка на таблицу.
    Kind -          Вид скроллера (горизонтальный или вертикальный).
    LineStep -      Малый шаг.
    LineSize -      Размер скроллируемой части окна при смещении на 1
                    позицию.
    PageStep -      Большой шаг.
    Position -      Текущая позиция.
    Range -         Максимум.

    Tracking -      Признак синхронного изменения позиции при перемещении
                    мышкой центрального движка.
    Visible -       Видимость скроллера.

    События:

    OnChange -      Произошли изменения положения.
    OnScroll -      Вызывается непосредственно перед изменением положения
                    скроллера.
  }

  TGridScrollEvent = procedure(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer) of object;

  TGridScrollBar = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FKind: TScrollBarKind;
    FPosition: Integer;
    FRange: Integer;
    FPageStep: Integer;
    FLineStep: Integer;
    FLineSize: Integer;
    FTracking: Boolean;
    FVisible: Boolean;
    FUpdateCount: Integer;
    FOnScroll: TGridScrollEvent;
    FOnChange: TNotifyEvent;
    function GetScrollPos(WinPos: Integer): Integer;
    function GetWinPos(ScrollPos: Integer): Integer;
    procedure SetLineSize(Value: Integer);
    procedure SetLineStep(Value: Integer);
    procedure SetPageStep(Value: Integer);
    procedure SetRange(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure Update;
  protected
    procedure Change; virtual;
    procedure Scroll(ScrollCode: Integer; var ScrollPos: Integer); virtual;
    procedure ScrollMessage(var Message: TWMScroll);
    procedure SetParams(ARange, APageStep, ALineStep: Integer);
    procedure SetPosition(Value: Integer);
    procedure SetPositionEx(Value: Integer; ScrollCode: Integer);
  public
    constructor Create(AGrid: TCustomGridView; AKind: TScrollBarKind);
    procedure Assign(Source: TPersistent); override;
    property Grid: TCustomGridView read FGrid;
    property Kind: TScrollBarKind read FKind;
    property LineStep: Integer read FLineStep write SetLineStep;
    property LineSize: Integer read FLineStep write SetLineSize;
    property PageStep: Integer read FPageStep write SetPageStep;
    property Position: Integer read FPosition write SetPosition;
    property Range: Integer read FRange write SetRange;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnScroll: TGridScrollEvent read FOnScroll write FOnScroll;
  published
    property Tracking: Boolean read FTracking write FTracking default True;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

{ TGridListBox }

  {
    выпадающий список строки редактирования.
  }

  TGridListBox = class(TCustomListBox)
  private
    FGrid: TCustomGridView;
    FSearchText: String;
    FSearchTime: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Grid: TCustomGridView read FGrid;
  end;

{ TGridEdit }

  {
    Сторка ввода таблицы.

    Процедуры:

    PaintButton -      Рисовать кнопку.
    UpdateBounds -     Определение положения и размера строки с последующим
                       показом ее (вызывается непосредственно из метода
                       Show).
    UpdateColors -     Определение цвета ячейки и шрифта.
    UpdateContents -   Определение текста строки, максимальной длины строки
                       и возможности редактирования.
    UpdateList -       Заполнение выпадающего списка.
    UpdateListBounds - Определение положения и размера выпадающего списка.
    UpdateStyle -      Определение типа строки.

    CloseUp -          Закрыть выпадающий список.
    DropDown -         Открыть выпадающий список. Если тип строки - кнопка
                       (EditStyle = geEllipsis), то эмулируется нажатие на
                       кнопку.
    Press -            Нажатие на кнопку с троеточием (мышкой или нажат
                       Ctrl+Enter при MultiLine = False).
    SelectNext -       Следует выбрать следующее значение из списка (нажат
                       Ctrl+Enter при MultiLine = False).

    Свойства:

    ButtonRect -       Прямоугольник кнопки.
    ButtonWidth -      Ширина кнопки.
    DropDownCount -    Количество строк в выпадающем списке.
    DropList -         Выпадающий список.
    EditStyle -        Тип строки.
    Grid -             Ссылка на кнопку.
    LineCount -        Количество строк в строке.
    MultiLine -        Может ли быть текст в строке многострочным.
  }

  TGridEditStyle = (geSimple, geEllipsis, gePickList, geDataList);

  TGridEdit = class(TCustomEdit)
  private
    FGrid: TCustomGridView;
    FClickTime: Longint;
    FEditStyle: TGridEditStyle;
    FMultiLine: Boolean;
    FDropDownCount: Integer;
    FDropList: TGridListBox;
    FDropListVisible: Boolean;
    FButtonWidth: Integer;
    FButtonTracking: Boolean;
    FButtonPressed: Boolean;
    function GetButtonRect: TRect;
    function GetLineCount: Integer;
    function GetVisible: Boolean;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetButtonWidth(Value: Integer);
    procedure SetEditStyle(Value: TGridEditStyle);
    procedure StartButtonTracking(X, Y: Integer);
    procedure StepButtonTracking(X, Y: Integer);
    procedure StopButtonTracking;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DblClick; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintButton(DC: HDC); virtual;
    procedure PaintWindow(DC: HDC); override;
    procedure UpdateBounds; virtual;
    procedure UpdateColors; virtual;
    procedure UpdateContents; virtual;
    procedure UpdateList; virtual;
    procedure UpdateListBounds; virtual;
    procedure UpdateStyle; virtual;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CloseUp(Accept: Boolean);
    procedure Deselect;
    procedure DropDown;
    procedure Invalidate; override;
    procedure Hide;
    procedure Press;
    procedure SelectNext;
    procedure SetFocus; override;
    procedure Show;
    property ButtonRect: TRect read GetButtonRect;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property Color;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount;
    property DropList: TGridListBox read FDropList;
    property EditStyle: TGridEditStyle read FEditStyle write SetEditStyle;
    property Font;
    property Grid: TCustomGridView read FGrid;
    property LineCount: Integer read GetLineCount;
    property MaxLength;
    property MultiLine: Boolean read FMultiLine write FMultiLine;
    property Visible: Boolean read GetVisible;
  end;

{ TGridTipsWindow }

  TGridTipsWindowClass = class of TGridTipsWindow;
  
  TGridTipsWindow = class(THintWindow)
  private
    FGrid: TCustomGridView;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
{$IFNDEF VER90}
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override; 
{$ENDIF}
  end;

{ TCustomGridView }

  {
    Таблица.

    Процедуры:

    AcquireFocus -         Установка фокуса на талицу или строку ввода.
                           Возвращает False, если по каим либо причинам фокус
                           не установлен.
    CellClick -            Нажатие машкой на ячейке.
    Change -               Ячейка выдлена.
    Changing -             Ячейка выделяется.
    ColumnResize -         Изменена ширина колонки.
    ColumnResizing -       Изменяется ширина колонки.
    CreateColumn -         Создать колонку.
    CreateEdit -           Создать строку редактирования.
    CreateEditList -       Создать выпадающий список строки редактирования.
    CreateFixed -          Создать список фиксированных колонок.
    CreateHeader -         Создать заголовок.
    CreateHeaderSection -  Создать секцию заголовка.
    CreateRows -           Создать список строк.
    CreateScrollBar -      Создать полосу прокрутки.
    EditButtonPress -      Произошло нажатие на кнопке строки редактирования.
    EditCanModify -        Можно ли редактировать текст в ячейке.
    EditCanAcceptKey -     Можно ли вводить указанный символ в ячейку.
    EditCanShow -          Может ли быть показана строка ввода.
    GetCellBorder -        Вернуть бордюр текста ячейки (смещение по
                           горизонтали относительно правого края). По
                           умолчанию на бордюр влияет наличие картинки.
    GetCellColors -        Установка цветов ячейки в зависимости от фокуса,
                           выделения и т.п.
    GetCellImage -         Вернуть номер картинки ячейки.
    GetCellText -          Вернуть текст ячейки.
    GetCursorCell -        Найти ячейку, на которую можно установить курсор.
                           В качестве параметров передается ячейка и смещение
                           от этой ячейки. Если полученная после смещения
                           ячейка не может принимать фокус, в указанном
                           направлении  ищется следующая доступная ячейка.
                           Параметр смещения может принимать следующие
                           значения:
                             goLeft -     Сместиться от указанной на одну
                                          колонку влево.
                             goRight -    Сместиться от указанной на одну
                                          колонку вправо.
                             goUp -       Сместиться от указанной на одну
                                          колонку вверх.
                             goDown -     Сместиться от указанной на одну
                                          колонку вниз.
                             goPageUp -   Сместиться от указанной на
                                          страницу вверх.
                             goPageDown - Сместиться от указанной на
                                          страницу вниз.
                             goHome -     Сместиться в верхний левый угол
                                          таблицы.
                             goEnd -      Сместиться в нижний правый угол
                                          таблицы.
                             goSelect -   Выделить указанную ячейку. Если
                                          ячейка не доступна, найти
                                          подходящую на той же строке или в
                                          той же колонке.
                             goFirst -    Найти пурвую доступную ячейку.
    GetEditList -          Заполнить выпадающий список строки редактирования.
    GetEditListBounds -    Подправить положение выпадающего списка строки
                           редактирования.
    GetEditRect -          Вернуть прямоугольник для строки редактирования.
                           По умолчанию равен прямоугольнику ячейки.
    GetEditStyle -         Вернуть стиль сроки редактирования.
    GetEditText -          Вернуть текст ячейки для редактирования.
    GetHeaderColors -      Установка цветов секции заголовка.
    HideCursor -           Погасить курсор.
    HideEdit -             Скрыть строку редактирования.
    HideFocus -            Погасить прямоугольник фокуса.
    PaintCells -           Рисовать ячейки.
    PaintCell -            Рисовать ячейку.
    PaintCells -           Рисовать ячейки.
    PaintCellText -        Рисовать текст ячейки.
    PaintFixed -           Рисовать фиксированные ячейки.
    PaintFocus -           Рисовать прямоугольник фокуса.
    PaintFreeField -       Рисовать область, свободную от ячеек.
    PaintGridLines -       Рисовать линии сетки.
    PaintHeader -          Рисовать секцию заголовка.
    PaintHeaders -         Рисовать заголовок.
    PaintHeaderSections -  Рисовать секции заголовка. 
    PaintResizeLine -      Рисовать линию при изменении размера колонки.
    SetEditText -          Установть текст в ячейку из строки ввода.
                           Вызывается при смене ячейки. Если текст не
                           принимается, следует вызвать исключение.
    SetCursor -            Установть курсор в указанную ячейку.
    ShowCursor -           Показать курсор.
    ShowEdit -             Показать строку редактирования.
    ShowEditChar -         Показать строку редактирования и передать ей
                           символ.
    ShowFocus -            Показать прямоугольник фокуса.
    UpdateCursor -         Обновление положения курсора.
    UpdateColors -         Обновление цветов заголовка и фиксированных при
                           изменении цвета таблицы.
    UpdateEdit -           Обновление положения, текста строки ввода и ее
                           видимости.
    UpdateFocus -          Установить фокус на талицу, если это возможно.
    UpdateFonts -          Обновление шрифтов заголовка и фиксированных при
                           изменении шрифта таблицы.
    UpdateHeader -         Обновление заголовка (приведение в соотвествии с
                           колонками, если стоит флаг AutoSynchronize или
                           Synchronized).
    UpdateScrollBars -     Обновление настроек полос прокрутки.
    UpdateScrollPos -      Обновление положение движков полос прокрутки.
    UpdateScrollRange -    Обновление настроек видимой области ячеек.
    UpdateEditText -       Обновление данных таблицы из строки ввода.

    InvalidateCell -       Перерисовать ячейку.
    InvalidateColumn -     Перерисовать колонки.
    InvalidateFixed -      Перерисовать фиксированные колонки.
    InvalidateFocus -      Перерисовать фокус (ячейку или строку).
    InvalidateGrid -       Перерисовать таблицу (все ачейки).
    InvalidateHeader -     Перерисовать заголовок.
    InvalidateRect -       Обновить прямоугольник таблицы.
    InvalidateRow -        Перерисовать строку.
    IsActiveControl -      Является ли таблица текущим активным компонентом
                           формы.
    IsCellAcceptCursor -   Можно ли установить курсор в ячейку.
    IsCellCorrect -        Проверка корректности ячейки (ненулевая ширина,
                           видимость, выход за границы столбцов и строк).
    IsCellHasImage -       Проверка на наличие картинки у ячейки.
    IsCellFocused -        Проверка на попадание ячейки в фокус.
    IsCellVisible -        Проверка видимости ячеки на экране.
    IsColumnVisible -      Проверка видимости колонки ни экране.
    IsFocusAllowed -       Признак видимости фокуса. Фокус виден, если
                           разрешено выделение строки или запрещено
                           редактирвоание. В противном случае на месте
                           фокуса находится строка ввода.
    IsRowVisible -         Проверка видимости строки.
    GetCellAt -            Найти ячейку по точке. Возвращает (-1, -1), если
                           не найдена.
    GetCellRect -          Прямоугольник ячейки.
    GetColumnAt -          Найти колонку по точке. Возвращает -1, если не
                           найдена.
    GetColumnMaxWidth -    Максмальная ширина видимого текста в указанной
                           колонке.
    GetColumnRect -        Прямоугольник колонки.
    GetColumnsWidth -      Суммарная ширина колонок с указанной по указанную.
    GetFixedRect -         Прямоугольник фиксированных колонок.
    GetFixedWidth -        Суммарная ширина фиксированных колонок.
    GetFocusRect -         Прямоугольник фокуса. По умолчанию вычисляется с
                           учетом построчного выделения и наличия картинок.
    GetGridHeight -        Высота видимой части ячеек.
    GetGridOrigin -        Смещение первой ячейки относительно левого
                           верхнего угла видимого прямойгольника тиблицы
                           (т.е. исключая заголовок).
    GetGridRect -          Прямоугольник видимой части ячеек.
    GetHeaderHeight -      Высота заголовка. Равна 0, если не видим.
    GetHeaderRect -        Прямоугольник заголовка.
    GetResizeSection -     Вернуть секцию заголовка, над правой границей
                           которой находится указанная точка.
    GetRowAt -             Найти строку по точке.
    GetRowRect -           Прямойгольник строки.
    GetRowsHeight -        Вернуть суммарную высоту строк от указанной до
                           указанной.
    GetTipsRect -          Вычислить прямоугольник для показа подсказки с
                           текстом ячейки.
    GetTipsWindow -        Вернуть класс окна подсказки ячейки.
    LockUpdate -           Заблокировать перерисовку.
    UnLockUpdate -         Разблокировать перерисовку.

    Свойства:

    CellFocused -          Текущее положение курсора.
    Cells -                Доступ к содержимому ячейки.
    CellSelected -         Признак выделенности курсора.
    Edit -                 Строка редактирования.
    EditCell -             Ячейка редактирования.
    Editing -              Идет редактирование ячейки.
    TipsCell -             Ячейка, для которой показываетсся подсказка.
    VisOrigin -            Первая видимая ячейка.
    VisSize -              Количество видимых ячеек.

    AllowEdit -            Разрешено ил запрещено редактирование таблицы.
    AlwaysSelected -       Всегда показывать фокус выделенным.
    BorderStyle -          Вордюр таблицы.
    Columns -              Список колонок таблицы.
    EndEllipsis -          Выводить или нет непомещающийся в ячейке текст с
                           ... (троеточием) на конце. Работает только для
                           однострочного текста с выравниваем влево. Сильно
                           влияет на скорость отрисовки.
    Fixed -                Параметры фиксированных колонок.
    GridLines -            Рисовать или нет линии сетки.
    Header -               Заголовок.
    HideSelection -        Гасить или нет курсор при пропадании фокуса.
    Images -               Список картинок.
    RightClickSelect -     Допускается или нет выделение ячейки правой
                           клавишей мышки.
    Rows -                 Параметры строк ячейки.
    RowSelect -            Выделение по целой строке или по ячейке.
    ShowCellTips -         Показывать или нет Hint с текстом ячейки, если
                           текст не помещается целиком в ячейку (для D3 и
                           выше). ВНИМАНИЕ: Основан на стандартном Hint-е,
                           для отображения подсказок необходимо установить
                           ShowHint в True. Если ShowCellTips установлено,
                           то обычный Hint - отображаться не будет (т.е.
                           либо Hint, либо CellTips).
    ShowFocusRect -        Показывать рамку фокуса.
    ShowHeader -           Показываеть заголовок.
    VertScrollBar -        Вертикальный скроллер.

    События:

    OnCellClick -          Щелчок мышкой на ячейке.
    OnChange -             Cменилась выделенная ячейка. Вызывается сразу
                           после изменении ячеейки курсора.
    OnChangeColumns -      Произошло изменение колонок таблицы.
    OnChangeFixed -        Произошло изменение фиксированных колонок таблицы.
    OnChangeRows -         Произошло изменение строк таблицы.
    OnChanging -           Меняется выделенная ячейка. Вызывается
                           непосредственно перед изменением ячейки курсора.
    OnColumnResize -       Ширина колонки изменилась.
    OnColumnResizing -     Изменяется ширина колонки.
    OnDrawCell -           Отрисовка ячейки. Если необходимо изменить
                           цвета ячейки, но оставить стандартную отрисовку,
                           следует переопределение цветов выполнить в
                           событии OnGetCellColors.
    OnDrawHeader -         Отрисовка секции ячейки. Если необходимо изменить
                           цвета секции, но оставить стандартную отрисовку,
                           следует переопределение цветов выполнить в
                           событии OnGetHeaderColors.
    OnEditAcceptKey -      Проверка приемлимости символа ячейки.
    OnEditButtonPress -    Нажата кнопка с троеточием у строки ввола.
    OnEditSelectNext -     Нажат Ctrl+Enter на кнопке с нераскрытым списком
                           (по идее следует в ячейку вставить следующее
                           значение из списка).
    OnGetCellImage -       Вернуть номер картинки ячейки.
    OnGetCellColors -      Определеить цвета ячейки.
    OnGetCellText -        Получить текст ячейки.
    OnGetEditList -        Заполнить выпадающий список строки редактирования.
    OnGetEditListBounds -  Подправить положение и размеры выпадающего списка
                           строки редактирования.
    OnGetEditStyle -       Определить стиль строки редактирования.
    OnGetEditText -        Вернуть текст ячейки для редактирования. По
                           умолчанию берется текст ячейки.
    OnGetHeaderColors -    Определеить цвета секции заголовка.
    OnResize -             Изменение размера таблицы.
    OnSetEditText -        Установить тест ячейки. Вызывается при перемещении
                           курсора. Если текст не принимается, следует
                           вызвать исключение.
  }

  TGridOffset = (goLeft, goRight, goUp, goDown, goPageUp, goPageDown,
    goHome, goEnd, goSelect, goFirst);

  TGridTextEvent = procedure(Sender: TObject; Cell: TGridCell; var Value: string) of object;
  TGridCellColorsEvent = procedure(Sender: TObject; Cell: TGridCell; Canvas: TCanvas) of object;
  TGridCellImageEvent = procedure(Sender: TObject; Cell: TGridCell; var ImageIndex: Integer) of object;
  TGridCellClickEvent = procedure(Sender: TObject; Cell: TGridCell; Shift: TShiftState; X, Y: Integer) of object;
  TGridCellAcceptCursorEvent = procedure(Sender: TObject; Cell: TGridCell; var Accept: Boolean) of object;
  TGridCellNotifyEvent = procedure(Sender: TObject; Cell: TGridCell) of object;
  TGridHeaderColorsEvent = procedure(Sender: TObject; Section: TGridHeaderSection; Canvas: TCanvas) of object;
  TGridDrawCellEvent = procedure(Sender: TObject; Cell: TGridCell; var Rect: TRect; var DefaultDrawing: Boolean) of object;
  TGridDrawHeaderEvent = procedure(Sender: TObject; Section: TGridHeaderSection; Rect: TRect; var DefaultDrawing: Boolean) of object;
  TGridColumnResizeEvent = procedure(Sender: TObject; Column: Integer; var Width: Integer) of object;
  TGridChangingEvent = procedure(Sender: TObject; var Cell: TGridCell; var Selected: Boolean) of object;
  TGridChangedEvent = procedure(Sender: TObject; Cell: TGridCell; Selected: Boolean) of object;
  TGridEditStyleEvent = procedure(Sender: TObject; Cell: TGridCell; var Style: TGridEditStyle) of object;
  TGridEditListEvent = procedure(Sender: TObject; Cell: TGridCell; Items: TStrings) of object;
  TGridEditListBoundsEvent = procedure(Sender: TObject; Cell: TGridCell; var Rect: TRect) of object;
  TGridAcceptKeyEvent = procedure(Sender: TObject; Key: Char; Accept: Boolean) of object;

  TCustomGridView = class(TCustomControl)
  private
    FHorzScrollBar: TGridScrollBar;
    FVertScrollBar: TGridScrollBar;
    FHeader: TGridHeader;
    FColumns: TGridColumns;
    FRows: TGridRows;
    FFixed: TGridFixed;                         
    FImages: TImageList;
    FImagesLink: TChangeLink;
    FCellFocused: TGridCell;
    FCellSelected: Boolean;
    FVisOrigin: TGridCell;
    FVisSize: TGridCell;
    FBorderStyle: TBorderStyle;
    FHideSelection: Boolean;
    FShowHeader: Boolean;
    FGridLines: Boolean;
    FGridLineWidth: Integer;
    FEndEllipsis: Boolean;
    FShowFocusRect: Boolean;
    FAlwaysSelected: Boolean;
    FRowSelect: Boolean;
    FRightClickSelect: Boolean;
    FHitTest: TPoint;
    FColResizing: Boolean;
    FColResizeSection: TGridHeaderSection;
    FColResizeOffset: Integer;
    FColResizeRect: TRect;
    FColResizePos: Integer;
    FColResizeCount: Integer;
    FLockUpdate: Integer;
    FAllowEdit: Boolean;
    FAlwaysEdit: Boolean;
    FEdit: TGridEdit;
    FEditCell: TGridCell;
    FEditing: Boolean;
    FShowCellTips: Boolean;
    FTipsCell: TGridCell;
    FOnGetCellText: TGridTextEvent;
    FOnGetCellColors: TGridCellColorsEvent;
    FOnGetCellImage: TGridCellImageEvent;
    FOnGetHeaderColors: TGridHeaderColorsEvent;
    FOnDrawCell: TGridDrawCellEvent;
    FOnDrawHeader: TGridDrawHeaderEvent;
    FOnColumnResizing: TGridColumnResizeEvent;
    FOnColumnResize: TGridColumnResizeEvent;
    FOnChangeColumns: TNotifyEvent;
    FOnChangeRows: TNotifyEvent;
    FOnChangeFixed: TNotifyEvent;
    FOnCellAcceptCursor: TGridCellAcceptCursorEvent;
    FOnChanging: TGridChangingEvent;
    FOnChange: TGridChangedEvent;
    FOnCellClick: TGridCellClickEvent;
    FOnGetEditStyle: TGridEditStyleEvent;
    FOnGetEditText: TGridTextEvent;
    FOnSetEditText: TGridTextEvent;
    FOnGetEditList: TGridEditListEvent;
    FOnGetEditListBounds: TGridEditListBoundsEvent;
    FOnEditAcceptKey: TGridAcceptKeyEvent;
    FOnEditButtonPress: TGridCellNotifyEvent;
    FOnEditSelectNext: TGridCellNotifyEvent;
    FOnResize: TNotifyEvent;
    function GetCell(Col, Row: Integer): string;
    procedure ColumnsChange(Sender: TObject);
    procedure FixedChange(Sender: TObject);
    procedure HeaderChange(Sender: TObject);
    procedure HorzScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
    procedure HorzScrollChange(Sender: TObject);
    procedure ImagesChange(Sender: TObject);
    procedure RowsChange(Sender: TObject);
    procedure SetAllowEdit(Value: Boolean);
    procedure SetAlwaysEdit(Value: Boolean);
    procedure SetAlwaysSelected(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetColumns(Value: TGridColumns);
    procedure SetCell(Col, Row: Integer; Value: string);
    procedure SetCellFocused(Value: TGridCell);
    procedure SetCellSelected(Value: Boolean);
    procedure SetEditing(Value: Boolean);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetFixed(Value: TGridFixed);
    procedure SetGridLines(Value: Boolean);
    procedure SetHeader(Value: TGridHeader);
    procedure SetHideSelection(Value: Boolean);
    procedure SetHorzScrollBar(Value: TGridScrollBar);
    procedure SetImages(Value: TImageList);
    procedure SetRows(Value: TGridRows);
    procedure SetRowSelect(Value: Boolean);
    procedure SetShowCellTips(Value: Boolean);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetShowHeader(Value: Boolean);
    procedure SetVertScrollBar(Value: TGridScrollBar);
    procedure SetVisOrigin(Value: TGridCell);
    procedure VertScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
    procedure VertScrollChange(Sender: TObject);
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMShowHintChanged(var Message: TMessage); message CM_SHOWHINTCHANGED;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
  protected
    function AcquireFocus: Boolean;
    procedure CellClick(Cell: TGridCell; Shift: TShiftState; X, Y: Integer); virtual;
    procedure Change(var Cell: TGridCell; var Selected: Boolean); virtual;
    procedure ChangeColumns; virtual;
    procedure ChangeFixed; virtual;
    procedure ChangeRows; virtual;
    procedure ChangeScale(M, D: Integer); override;
    procedure Changing(var Cell: TGridCell; var Selected: Boolean); virtual;
    procedure ColumnResize(Column: Integer; var Width: Integer); virtual;
    procedure ColumnResizing(Column: Integer; var Width: Integer); virtual;
    function CreateColumn: TGridColumn; virtual;
    function CreateColumns: TGridColumns; virtual;
    function CreateEdit: TGridEdit; virtual;
    function CreateEditList: TGridListBox; virtual;
    function CreateFixed: TGridFixed; virtual;
    function CreateHeader: TGridHeader; virtual;
    function CreateHeaderSection: TGridHeaderSection; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    function CreateRows: TGridRows; virtual;
    function CreateScrollBar(Kind: TScrollBarKind): TGridScrollBar; virtual;
    procedure DoExit; override;
    procedure EditButtonPress(Cell: TGridCell); virtual;
    procedure EditSelectNext(Cell: TGridCell); virtual;
    function EditCanModify: Boolean; virtual;
    function EditCanAcceptKey(Key: Char): Boolean; virtual;
    function EditCanShow: Boolean; virtual;
    function GetCellBorder(Cell: TGridCell): Integer; virtual;
    procedure GetCellColors(Cell: TGridCell; Canvas: TCanvas); virtual;
    function GetCellImage(Cell: TGridCell): Integer; virtual;
    function GetCellText(Cell: TGridCell): string; virtual;
    function GetClientOrigin: TPoint; override;
    function GetClientRect: TRect; override;
    function GetCursorCell(Cell: TGridCell; Offset: TGridOffset): TGridCell; virtual;
    procedure GetEditList(Cell: TGridCell; Items: TStrings); virtual;
    procedure GetEditListBounds(Cell: TGridCell; var Rect: TRect); virtual;
    function GetEditRect(Cell: TGridCell): TRect; virtual;
    function GetEditStyle(Cell: TGridCell): TGridEditStyle; virtual;
    function GetEditText(Cell: TGridCell): string; virtual;
    procedure GetHeaderColors(Section: TGridHeaderSection; Canvas: TCanvas); virtual;
    function GetTipsRect(Cell: TGridCell; MaxWidth: Integer): TRect; virtual;
    function GetTipsWindow: TGridTipsWindowClass; virtual;
    procedure HideCursor; virtual;
    procedure HideEdit; virtual;
    procedure HideFocus; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure PaintCell(Cell: TGridCell; Rect: TRect); virtual;
    procedure PaintCells; virtual;
    procedure PaintCellText(Cell: TGridCell; Rect: TRect; Canvas: TCanvas); virtual;
    procedure PaintFixed; virtual;
    procedure PaintFreeField; virtual;
    procedure PaintFocus; virtual;
    procedure PaintGridLines; virtual;
    procedure PaintHeader(Section: TGridHeaderSection; Rect: TRect); virtual;
    procedure PaintHeaders(DrawFixed: Boolean); virtual;
    procedure PaintHeaderSections(Sections: TGridHeaderSections; AllowFixed: Boolean; Rect: TRect); virtual;
    procedure PaintResizeLine;
    procedure Resize; dynamic;
    procedure SetCursor(Cell: TGridCell; Selected, Visible: Boolean); virtual;
    procedure SetEditText(Cell: TGridCell; var Value: string); virtual;
    procedure ShowCursor; virtual;
    procedure ShowEdit; virtual;
    procedure ShowEditChar(C: Char); virtual;
    procedure ShowFocus; virtual;
    procedure StartColResize(Section: TGridHeaderSection; X, Y: Integer);
    procedure StepColResize(X, Y: Integer);
    procedure StopColResize(Abort: Boolean);
    procedure UpdateCursor; virtual;
    procedure UpdateColors; virtual;
    procedure UpdateEdit(Activate: Boolean); virtual;
    procedure UpdateFocus; virtual;
    procedure UpdateFonts; virtual;
    procedure UpdateHeader; virtual;
    procedure UpdateScrollBars; virtual;
    procedure UpdateScrollPos; virtual;
    procedure UpdateScrollRange;
    procedure UpdateSelection(var Cell: TGridCell; var Selected: Boolean); virtual;
    procedure UpdateEditText; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    procedure InvalidateCell(Cell: TGridCell);
    procedure InvalidateColumn(Column: Integer);
    procedure InvalidateFixed;
    procedure InvalidateFocus; virtual;
    procedure InvalidateGrid;
    procedure InvalidateHeader;
    procedure InvalidateRect(Rect: TRect);
    procedure InvalidateRow(Row: Integer);
    function IsActiveControl: Boolean;
    function IsCellAcceptCursor(Cell: TGridCell): Boolean; virtual;
    function IsCellCorrect(Cell: TGridCell): Boolean; 
    function IsCellHasImage(Cell: TGridCell): Boolean; virtual;
    function IsCellFocused(Cell: TGridCell): Boolean;
    function IsCellVisible(Cell: TGridCell; PartialOK: Boolean): Boolean;
    function IsColumnVisible(Column: Integer): Boolean;
    function IsFocusAllowed: Boolean;
    function IsRowVisible(Row: Integer): Boolean;
    function GetCellAt(X, Y: Integer): TGridCell;
    function GetCellRect(Cell: TGridCell): TRect;
    function GetColumnAt(X, Y: Integer): Integer;
    function GetColumnMaxWidth(Column: Integer): Integer;
    function GetColumnRect(Column: Integer): TRect;
    function GetColumnsWidth(Index1, Index2: Integer): Integer;
    function GetFixedRect: TRect;
    function GetFixedWidth: Integer;
    function GetFocusRect: TRect; virtual;
    function GetGridHeight: Integer;
    function GetGridOrigin: TPoint;
    function GetGridRect: TRect;
    function GetHeaderHeight: Integer;
    function GetHeaderRect: TRect;
    function GetResizeSection(X, Y: Integer): TGridHeaderSection;
    function GetRowAt(X, Y: Integer): Integer;
    function GetRowRect(Row: Integer): TRect;
    function GetRowsHeight(Index1, Index2: Integer): Integer;
    procedure LockUpdate;
    procedure UnLockUpdate(Redraw: Boolean);
    property AllowEdit: Boolean read FAllowEdit write SetAllowEdit default False;
    property AlwaysEdit: Boolean read FAlwaysEdit write SetAlwaysEdit default False;
    property AlwaysSelected: Boolean read FAlwaysSelected write SetAlwaysSelected default False;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Columns: TGridColumns read FColumns write SetColumns;
    property Cells[Col, Row: Integer]: string read GetCell write SetCell;
    property CellFocused: TGridCell read FCellFocused write SetCellFocused;
    property CellSelected: Boolean read FCellSelected write SetCellSelected;
    property Edit: TGridEdit read FEdit;
    property EditCell: TGridCell read FEditCell;
    property Editing: Boolean read FEditing write SetEditing;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;
    property GridLines: Boolean read FGridLines write SetGridLines default True;
    property Fixed: TGridFixed read FFixed write SetFixed;
    property Header: TGridHeader read FHeader write SetHeader;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default False;
    property HorzScrollBar: TGridScrollBar read FHorzScrollBar write SetHorzScrollBar;
    property Images: TImageList read FImages write SetImages;
    property RightClickSelect: Boolean read FRightClickSelect write FRightClickSelect default True;
    property Rows: TGridRows read FRows write SetRows;
    property RowSelect: Boolean read FRowSelect write SetRowSelect default False;
    property ShowCellTips: Boolean read FShowCellTips write SetShowCellTips;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property ShowHeader: Boolean read FShowHeader write SetShowHeader default True;
    property TipsCell: TGridCell read FTipsCell;
    property VertScrollBar: TGridScrollBar read FVertScrollBar write SetVertScrollBar;
    property VisOrigin: TGridCell read FVisOrigin write SetVisOrigin;
    property VisSize: TGridCell read FVisSize;
    property OnCellAcceptCursor: TGridCellAcceptCursorEvent read FOnCellAcceptCursor write FOnCellAcceptCursor;
    property OnCellClick: TGridCellClickEvent read FOnCellClick write FOnCellClick;
    property OnChange: TGridChangedEvent read FOnChange write FOnChange;
    property OnChangeColumns: TNotifyEvent read FOnChangeColumns write FOnChangeColumns;
    property OnChangeFixed: TNotifyEvent read FOnChangeFixed write FOnChangeFixed;
    property OnChangeRows: TNotifyEvent read FOnChangeRows write FOnChangeRows;
    property OnChanging: TGridChangingEvent read FOnChanging write FOnChanging;
    property OnColumnResizing: TGridColumnResizeEvent read FOnColumnResizing write FOnColumnResizing;
    property OnColumnResize: TGridColumnResizeEvent read FOnColumnResize write FOnColumnResize;
    property OnDrawCell: TGridDrawCellEvent read FOnDrawCell write FOnDrawCell;
    property OnDrawHeader: TGridDrawHeaderEvent read FOnDrawHeader write FOnDrawHeader;
    property OnEditAcceptKey: TGridAcceptKeyEvent read FOnEditAcceptKey write FOnEditAcceptKey;
    property OnEditButtonPress: TGridCellNotifyEvent read FOnEditButtonPress write FOnEditButtonPress;
    property OnEditSelectNext: TGridCellNotifyEvent read FOnEditSelectNext write FOnEditSelectNext;
    property OnGetCellColors: TGridCellColorsEvent read FOnGetCellColors write FOnGetCellColors;
    property OnGetCellImage: TGridCellImageEvent read FOnGetCellImage write FOnGetCellImage;
    property OnGetCellText: TGridTextEvent read FOnGetCellText write FOnGetCellText;
    property OnGetEditStyle: TGridEditStyleEvent read FOnGetEditStyle write FOnGetEditStyle;
    property OnGetEditList: TGridEditListEvent read FOnGetEditList write FOnGetEditList;
    property OnGetEditListBounds: TGridEditListBoundsEvent read FOnGetEditListBounds write FOnGetEditListBounds;
    property OnGetEditText: TGridTextEvent read FOnGetEditText write FOnGetEditText;
    property OnGetHeaderColors: TGridHeaderColorsEvent read FOnGetHeaderColors write FOnGetHeaderColors;
    property OnSetEditText: TGridTextEvent read FOnSetEditText write FOnSetEditText;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
  end;

{ TGridView }

  TGridView = class(TCustomGridView)
  public
    property Canvas;
  published
    property Align;
    property AllowEdit;
    property AlwaysEdit;
    property AlwaysSelected;
    property BorderStyle;
    property Color;
    property Columns;
    property Ctl3D;
    property EndEllipsis;
    property Font;
    property Fixed;
    property GridLines;
    property Header;
    property HideSelection;
    property Hint;
    property HorzScrollBar;
    property Images;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RightClickSelect;
    property Rows;
    property RowSelect;
    property ShowCellTips;
    property ShowFocusRect;
    property ShowHeader;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property VertScrollBar;
    property Visible;
    property OnCellAcceptCursor;
    property OnCellClick;
    property OnChange;
    property OnChangeColumns;
    property OnChangeFixed;
    property OnChangeRows;
    property OnChanging;
    property OnClick;
    property OnColumnResizing;
    property OnColumnResize;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawCell;
    property OnDrawHeader;
    property OnEditAcceptKey;
    property OnEditButtonPress;
    property OnEditSelectNext;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCellColors;
    property OnGetCellImage;
    property OnGetCellText;
    property OnGetEditList;
    property OnGetEditListBounds;
    property OnGetEditStyle;
    property OnGetEditText;
    property OnGetHeaderColors;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSetEditText;
    property OnStartDrag;
    property OnResize;
  end;

function GridCell(Col, Row: Integer): TGridCell;
function IsCellEqual(Cell1, Cell2: TGridCell): Boolean;
function IsCellEmpty(Cell: TGridCell): Boolean;

implementation

uses
  Ex_Utils;

{ Утилитки }

function GridCell(Col, Row: Integer): TGridCell;
begin
  Result.Col := Col;
  Result.Row := Row;
end;

function IsCellEqual(Cell1, Cell2: TGridCell): Boolean;
begin
  Result := (Cell1.Col = Cell2.Col) and (Cell1.Row = Cell2.Row);
end;

function IsCellEmpty(Cell: TGridCell): Boolean;
begin
  Result := (Cell.Col = -1) or (Cell.Row = -1);
end;

{ TGridHeaderSection }

constructor TGridHeaderSection.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FWidth := 64;
end;

destructor TGridHeaderSection.Destroy;
begin
  FSections.Free;
  inherited Destroy;
end;

function TGridHeaderSection.GetBounds: TRect;

  function DoGetBounds(Sections: TGridHeaderSections; var Rect: TRect): Boolean;
  var
    I: Integer;
    S: TGridHeaderSection;
    R: TRect;
  begin
    R.Left := Rect.Left;
    R.Right := Rect.Left;
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      R.Left := R.Right;
      R.Right := R.Left + S.Width;
      { секция текущая - выход }
      if S = Self then
      begin
        Rect := R;
        Result := True;
        Exit;
      end;
      { отссекаем все нижнии }
      if DoGetBounds(S.Sections, R) then
      begin
        Rect := R;
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

begin
  { нет заголовка - нет размеров }
  if (Header = nil) or (Header.Grid = nil) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { первоначальная ширина - всего заголовка }
  with Result do
  begin
    Left := Header.Grid.GetGridOrigin.X;
    Right := Left + Header.Width;
  end;
  { ищем левый и правый края }
  if not DoGetBounds(Header.Sections, Result) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { верхняя и нижние границы }
  with Result do
  begin
    Top := Level * Header.SectionHeight;
    if Sections.Count > 0 then
      Bottom := Result.Top + Header.SectionHeight
    else
      Bottom := Header.Height;
  end;
  { фиксированный заголовок }
  if FixedSize then
    OffsetRect(Result, - Header.Grid.GetGridOrigin.X, 0);
end;

function TGridHeaderSection.GetColumn: Integer;
var
  C: Integer;

  function DoGetColumn(Sections: TGridHeaderSections): Boolean;
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      { есть ли подзаголовки }
      if S.Sections.Count = 0 then
      begin
        { это текущая - выходим }
        if S = Self then
        begin
          Result := True;
          Exit;
        end;
        Inc(C);
      end;
      { рекурсия на все подзаголовки снизу }
      if DoGetColumn(S.Sections) then
      begin
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

begin
  { если есть подзаголовки возвращаем колонку последнего из них }
  if Sections.Count > 0 then
  begin
    Result := Sections[Sections.Count - 1].Column;
    Exit;
  end;
  { иначе считаем кольнки }
  if Header <> nil then
  begin
    C := 0;
    if DoGetColumn(Header.Sections) then
    begin
      Result := C;
      Exit;
    end;
  end;
  Result := 0;
end;

function TGridHeaderSection.GetFixedSize: Boolean;
begin
  if Sections.Count > 0 then
  begin
    Result := Sections[0].FixedSize;
    Exit;
  end;
  if (Header = nil) or (Header.Grid = nil) then
  begin
    Result := False;
    Exit;
  end;
  Result := Column < Header.Grid.Fixed.Count;
end;

function TGridHeaderSection.GetHeader: TGridHeader;
begin
  if ParentSections <> nil then
  begin
    Result := ParentSections.Header;
    Exit;
  end;
  Result := nil;
end;

function TGridHeaderSection.GetLevel: Integer;
begin
  if Parent <> nil then
  begin
    Result := Parent.Level + 1;
    Exit;
  end;
  Result := 0
end;

function TGridHeaderSection.GetParent: TGridHeaderSection;
begin
  if ParentSections <> nil then
  begin
    Result := ParentSections.Owner;
    Exit;
  end;
  Result := nil;
end;

function TGridHeaderSection.GetParentSections: TGridHeaderSections;
begin
  if Collection <> nil then
  begin
    Result := TGridHeaderSections(Collection);
    Exit;
  end;
  Result := nil;
end;

function TGridHeaderSection.GetSections: TGridHeaderSections;
begin
  if FSections = nil then FSections := TGridHeaderSections.Create(Header, Self);
  Result := FSections;
end;

function TGridHeaderSection.GetWidth: Integer;
var
  I: Integer;
  S: TGridHeaderSection;
begin
  { если есть подзаголовки, то ширина есть сумма ширин подзаголовков }
  if Sections.Count > 0 then
  begin
    Result := 0;
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      Result := Result + S.Width;
    end;
    Exit;
  end;
  { иначе возвращаем ширину соответствующей колонки }
  if (Header <> nil) and (Header.Grid <> nil) then
  begin
    I := GetColumn;
    if I < Header.Grid.Columns.Count then
    begin
      Result := Header.Grid.Columns[I].Width;
      Exit;
    end;
  end;
  { нет колонки - своя ширина }
  Result := FWidth;
end;

procedure TGridHeaderSection.SetAlignment(Value: TAlignment);
begin
  if Alignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.SetSections(Value: TGridHeaderSections);
begin
  Sections.Assign(Value);
end;

procedure TGridHeaderSection.SetWidth(Value: Integer);
begin
  if (Value >= 0) and (Width <> Value) then
  begin
    if (Header <> nil) and (Header.Grid <> nil) then
      if Column > Header.Grid.Columns.Count - 1 then
        if Sections.Count > 0 then
        begin
          with Sections[Sections.Count - 1] do
            SetWidth(Width + (Value - Self.Width));
          Exit;
        end;
    FWidth := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.Assign(Source: TPersistent);
begin
  if Source is TGridHeaderSection then
  begin
    Sections := TGridHeaderSection(Source).Sections;
    Caption := TGridHeaderSection(Source).Caption;
    Width := TGridHeaderSection(Source).Width;
    Alignment := TGridHeaderSection(Source).Alignment;
    WordWrap := TGridHeaderSection(Source).WordWrap;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridHeaderSections }

constructor TGridHeaderSections.Create(AHeader: TGridHeader; AOwner: TGridHeaderSection);
begin
  inherited Create(TGridHeaderSection);
  FHeader := AHeader;
  FOwner := AOwner;
end;

function TGridHeaderSections.GetMaxColumn: Integer;
begin
  if Count > 0 then
  begin
    Result := Sections[Count - 1].Column;
    Exit;
  end;
  Result := 0;
end;

function TGridHeaderSections.GetMaxLevel: Integer;

  procedure DoGetMaxLevel(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      if Result < S.Level then Result := S.Level;
      DoGetMaxLevel(S.Sections);
    end;
  end;

begin
  Result := 0;
  DoGetMaxLevel(Self);
end;

function TGridHeaderSections.GetSection(Index: Integer): TGridHeaderSection;
begin
  Result := TGridHeaderSection(inherited GetItem(Index));
end;

procedure TGridHeaderSections.SetSection(Index: Integer; Value: TGridHeaderSection);
begin
  inherited SetItem(Index, Value);
end;

function TGridHeaderSections.GetOwner: TPersistent;
begin
  Result := Header;
end;

procedure TGridHeaderSections.Update(Item: TCollectionItem);
begin
  if Header <> nil then Header.Change;
end;

function TGridHeaderSections.Add: TGridHeaderSection;
begin
  if (Header = nil) or (Header.Grid = nil) then
  begin
    Result := TGridHeaderSection(inherited Add);
    Exit;
  end;
  Result := Header.Grid.CreateHeaderSection;
end;

procedure TGridHeaderSections.Synchronize(Columns: TGridColumns);
var
  I, C: Integer;

  procedure DoDeleteSections(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := Sections.Count - 1 downto 0 do
    begin
      S := Sections[I];
      DoDeleteSections(S.Sections);
      if (S.Sections.Count = 0) and (S.Column > Columns.Count - 1) then S.Free;
    end;
  end;

  procedure DoSynchronizeSections(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := Sections.Count - 1 downto 0 do
    begin
      S := Sections[I];
      if S.Sections.Count = 0 then
      begin
        C := S.Column;
        S.Width := Columns[C].Width;              
        if Header.FullSynchronizing then
        begin
          S.Caption := Columns[C].Caption;
          S.Alignment := Columns[C].Alignment;
        end;
      end
      else
        DoSynchronizeSections(S.Sections);
    end;
  end;

begin
  if (Header <> nil) and (Header.Grid.ComponentState * [csReading, csLoading] = []) then
  begin
    BeginUpdate;
    try
      { заголовок пуст - добавляем все колонки }
      if Count = 0 then
      begin
        for I := 0 to Columns.Count - 1 do
          with Add do
          begin
            Caption := Columns[I].Caption;
            Width := Columns[I].Width;
            Alignment := Columns[I].Alignment;
          end;
        Exit;
      end;
      { если секций меньше - добавляем, иначе удаляем лишние }
      C := Sections[Count - 1].Column;
      if C < Columns.Count - 1 then
      begin
        I := C;
        repeat
          Inc(I);
          Add;
        until I >= Columns.Count - 1;
      end
      else
        if C > Columns.Count - 1 then DoDeleteSections(Self);
      { у нижних секций синхронизируем заголовок, выравнивание и шинрину }
      DoSynchronizeSections(Self);
    finally
      EndUpdate;
    end;
  end;
end;

{ TGridHeader }

constructor TGridHeader.Create(AGrid: TCustomGridView);
begin
  inherited Create;
  FGrid := AGrid;
  FColor := clBtnFace;
  FSections := TGridHeaderSections.Create(Self, nil);
  FSectionHeight := 17;
  FSynchronized := True;
  FAutoSynchronize := True;
  FColor := clBtnFace;
  FFont := TFont.Create;
  FFont.OnChange := FontChange;
  FGridFont := True;
end;

destructor TGridHeader.Destroy;
begin
  FOnChange := nil;
  FSections.Free;
  FFont.Free;
  inherited Destroy;
end;

procedure TGridHeader.FontChange(Sender: TObject);
begin
  FGridFont := False;
  Change;
end;

function TGridHeader.GetHeight: Integer;
begin
  Result := (GetMaxLevel + 1) * SectionHeight - 1;
end;

function TGridHeader.GetMaxColumn: Integer;
begin
  Result := Sections.MaxColumn;
end;

function TGridHeader.GetMaxLevel: Integer;
begin
  Result := Sections.MaxLevel;
end;

function TGridHeader.GetWidth: Integer;
var
  I: Integer;
  S: TGridHeaderSection;
begin
  Result := 0;
  for I := 0 to Sections.Count - 1 do
  begin
    S := Sections[I];
    Result := Result + S.Width;
  end;
end;

procedure TGridHeader.GridColorChanged(NewColor: TColor);
begin
  if FGridColor then
  begin
    SetColor(NewColor);
    FGridColor := True;
  end;
end;

procedure TGridHeader.GridFontChanged(NewFont: Tfont);
begin
  if FGridFont then
  begin
    SetFont(NewFont);
    FGridFont := True;
  end;
end;

procedure TGridHeader.SetAutoSynchronize(Value: Boolean);
begin
  if FAutoSynchronize <> Value then
  begin
    FAutoSynchronize := Value;
    if Value then Synchronized := True;
  end;
end;

procedure TGridHeader.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FGridColor := False;
    Change;
  end;
end;

procedure TGridHeader.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TGridHeader.SetGridColor(Value: Boolean);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    if Grid <> nil then GridColorChanged(Grid.Color);
  end;
end;

procedure TGridHeader.SetGridFont(Value: Boolean);
begin
  if FGridFont <> Value then
  begin
    FGridFont := Value;
    if Grid <> nil then GridFontChanged(Grid.Font);
  end;
end;

procedure TGridHeader.SetSections(Value: TGridHeaderSections);
begin
  { устанавливаем заголовок }
  FSections.Assign(Value);
  { сбрасываем флаг синхронизации }
  SetSynchronized(False);
end;

procedure TGridHeader.SetSectionHeight(Value: Integer);
begin
  if FSectionHeight <> Value then
  begin
    FSectionHeight := Value;
    Change;
  end;
end;

procedure TGridHeader.SetSynchronized(Value: Boolean);
begin
  if FSynchronized <> Value then
  begin
    FSynchronized := Value;
    if (Value or FAutoSynchronize) and (Grid <> nil) then
    begin
      FSynchronized := True;
      Sections.Synchronize(Grid.Columns);
    end;
  end;
end;

procedure TGridHeader.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGridHeader.Assign(Source: TPersistent);
begin
  if Source is TGridHeader then
  begin
    Sections := TGridHeader(Source).Sections;
    SectionHeight := TGridHeader(Source).SectionHeight;
    Synchronized := TGridHeader(Source).Synchronized;
    AutoSynchronize := TGridHeader(Source).AutoSynchronize;
    Color := TGridHeader(Source).Color;
    GridColor := TGridHeader(Source).GridColor;
    Font := TGridHeader(Source).Font;
    GridFont := TGridHeader(Source).GridFont;                       
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridColumn }

constructor TGridColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColumns := TGridColumns(Collection);
  FWidth := 64;
  FDefWidth := 64;
  FAlignment := taLeftJustify;
  FVisible := True;
end;

function TGridColumn.GetWidth: Integer;
begin
  { а виден ли столбец }
  if not FVisible then
  begin
    Result := 0;
    Exit;
  end;
  { возвращаем ширину }
  Result := FWidth;
end;

procedure TGridColumn.SetAlignment(Value: TAlignment);
begin
  if Alignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TGridColumn.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TGridColumn.SetMaxLength(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if FMaxLength <> Value then
  begin
    FMaxLength := Value;
    Changed(False);
  end;
end;

procedure TGridColumn.SetMultiLine(Value: Boolean);
begin
  if FMultiLine <> Value then
  begin
    FMultiLine := Value;
    Changed(False);
  end;
end;

procedure TGridColumn.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    Changed(False);
  end;
end;

procedure TGridColumn.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

procedure TGridColumn.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    FDefWidth := Value;
    Changed(True);
  end;
end;

procedure TGridColumn.Assign(Source: TPersistent);
begin
  if Source is TGridColumn then
  begin
    Caption := TGridColumn(Source).Caption;
    DefWidth := TGridColumn(Source).DefWidth;
    FixedSize := TGridColumn(Source).FixedSize;
    MaxLength := TGridColumn(Source).MaxLength;
    Alignment := TGridColumn(Source).Alignment;
    ReadOnly := TGridColumn(Source).ReadOnly;
    MultiLine := TGridColumn(Source).MultiLine;
    Visible := TGridColumn(Source).Visible;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridColumns }

constructor TGridColumns.Create(AGrid: TCustomGridView);
begin
  inherited Create(TGridColumn);
  FGrid := AGrid;
end;

function TGridColumns.GetColumn(Index: Integer): TGridColumn;
begin
  Result := TGridColumn(inherited GetItem(Index));
end;

procedure TGridColumns.SetColumn(Index: Integer; Value: TGridColumn);
begin
  inherited SetItem(Index, Value);
end;

function TGridColumns.GetOwner: TPersistent;
begin
  Result := FGrid; 
end;

procedure TGridColumns.Update(Item: TCollectionItem);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TGridColumns.Add: TGridColumn;
begin
  if Grid = nil then
  begin
    Result := TGridColumn(inherited Add);
    Exit;
  end;
  Result := Grid.CreateColumn;
end;

{ TGridRows }

constructor TGridRows.Create(AGrid: TCustomGridView);
begin
  inherited Create;
  FGrid := AGrid;
  FHeight := 17;
end;

destructor TGridRows.Destroy;
begin
  FOnChange := nil;
  SetCount(0);
  inherited Destroy;
end;

function TGridRows.GetMaxCount: Integer;
begin
  Result := (MaxInt - 2) div Height - 2;
end;

procedure TGridRows.SetHeight(Value: Integer);
begin
  if Assigned(Grid.Images) then
    with Grid.Images do
      if Value < Height + 1 then Value := Height + 1;
  if FHeight <> Value then
  begin
    FHeight := Value;
    if Count > MaxCount then SetCount(Count) else Change;
  end;
end;

procedure TGridRows.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGridRows.SetCount(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > MaxCount then Value := MaxCount;
  if FCount <> Value then
  begin
    FCount := Value;
    Change;
  end;
end;

procedure TGridRows.Assign(Source: TPersistent);
begin
  if Source is TGridRows then
  begin
    Count := TGridRows(Source).Count;
    Height := TGridRows(Source).Height;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridFixed }

constructor TGridFixed.Create(AGrid: TCustomGridView);
begin
  inherited Create;
  FGrid := AGrid;
  FColor := clBtnFace;
  FFont := TFont.Create;
  FFont.OnChange := FontChange;
  FGridFont := True;
end;

destructor TGridFixed.Destroy;
begin
  FOnChange := nil;
  FFont.Free;
  inherited Destroy;
end;

procedure TGridFixed.FontChange(Sender: TObject);
begin
  FGridFont := False;
  Change;
end;

procedure TGridFixed.GridColorChanged(NewColor: TColor);
begin
  if FGridColor then
  begin
    SetColor(NewColor);
    FGridColor := True;
  end;
end;

procedure TGridFixed.GridFontChanged(NewFont: TFont);
begin
  if FGridFont then
  begin
    SetFont(NewFont);
    FGridFont := True;
  end;
end;

procedure TGridFixed.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FGridColor := False;
    Change;
  end;
end;

procedure TGridFixed.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TGridFixed.SetGridColor(Value: Boolean);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    if Grid <> nil then GridColorChanged(Grid.Color);
  end;
end;

procedure TGridFixed.SetGridFont(Value: Boolean);
begin
  if FGridFont <> Value then
  begin
    FGridFont := Value;
    if Grid <> nil then GridFontChanged(Grid.Font);
  end;
end;

procedure TGridFixed.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGridFixed.SetCount(Value: Integer);
begin
  { подправляем значение }
  if Value < 0 then Value := 0;
  if (Grid <> nil) and (Value > Grid.Columns.Count - 1) then Value := Grid.Columns.Count - 1;
  { устанавливаем }
  if FCount <> Value then
  begin
    FCount := Value;
    Change;
  end;
end;

procedure TGridFixed.Assign(Source: TPersistent);
begin
  if Source is TGridFixed then
  begin
    Count := TGridFixed(Source).Count;
    Color := TGridFixed(Source).Color;
    GridColor := TGridFixed(Source).GridColor;
    Font := TGridFixed(Source).Font;
    GridFont := TGridFixed(Source).GridFont;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridScrollBar }

const
  MaxScroll = 30000;

constructor TGridScrollBar.Create(AGrid: TCustomGridView; AKind: TScrollBarKind);
begin
  inherited Create;
  FGrid := AGrid;
  FKind := AKind;
  FPosition := 0;
  FRange := 0;
  FPageStep := 100;
  FLineStep := 8;
  FLineSize := 1;
  FTracking := True;
  FVisible := True;
end;

function TGridScrollBar.GetScrollPos(WinPos: Integer): Integer;
begin
  Result := MulDiv(WinPos, Range, MaxScroll);
end;

function TGridScrollBar.GetWinPos(ScrollPos: Integer): Integer;
begin
  if Range <> 0 then
  begin
    Result := MulDiv(ScrollPos, MaxScroll, Range);
    Exit;
  end;
  Result := 0;
end;

procedure TGridScrollBar.SetLineSize(Value: Integer);
begin
  if Value < 1 then FLineSize := 1 else FLineSize := Value;
end;

procedure TGridScrollBar.SetLineStep(Value: Integer);
begin
  SetParams(Range, PageStep, Value);
end;

procedure TGridScrollBar.SetPageStep(Value: Integer);
begin
  SetParams(Range, Value, LineStep);
end;

procedure TGridScrollBar.SetRange(Value: Integer);
begin
  SetParams(Value, PageStep, LineStep);
end;

procedure TGridScrollBar.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Update;
  end;
end;

procedure TGridScrollBar.Update;
const
  Code: array[Boolean] of Integer = (SB_VERT, SB_HORZ);
var
  ScrollInfo: TScrollInfo;
begin
  if FGrid.HandleAllocated then
  begin
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    ScrollInfo.fMask := SIF_ALL;
    ScrollInfo.nMin := 0;
    if Visible and (Range > PageStep) then
      ScrollInfo.nMax := MaxScroll
    else
      ScrollInfo.nMax := 0;
    ScrollInfo.nPage := GetWinPos(PageStep);
    ScrollInfo.nPos := GetWinPos(Position);
    ScrollInfo.nTrackPos := GetWinPos(Position);
    SetScrollInfo(FGrid.Handle, Code[Kind = sbHorizontal], ScrollInfo, FUpdateCount = 0);
  end;
end;

procedure TGridScrollBar.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGridScrollBar.Scroll(ScrollCode: Integer; var ScrollPos: Integer);
begin
  if Assigned(FOnScroll) then FOnScroll(Self, ScrollCode, ScrollPos);
end;

procedure TGridScrollBar.ScrollMessage(var Message: TWMScroll);
begin
  with Message do
  begin
    Inc(FUpdateCount);
    try
      case ScrollCode of
        SB_LINELEFT: SetPositionEx(Position - LineStep, ScrollCode);
        SB_LINERIGHT: SetPositionEx(Position + LineStep, ScrollCode);
        SB_PAGELEFT: SetPositionEx(Position - PageStep, ScrollCode);
        SB_PAGERIGHT: SetPositionEx(Position + PageStep, ScrollCode);
        SB_THUMBPOSITION: SetPositionEx(GetScrollPos(Pos), ScrollCode);
        SB_THUMBTRACK: if Tracking then SetPositionEx(GetScrollPos(Pos), ScrollCode);
        SB_ENDSCROLL: SetPositionEx(Position, ScrollCode);
      end;
    finally
      Dec(FUpdateCount);
      Update;
    end;
  end;
end;

procedure TGridScrollBar.SetParams(ARange, APageStep, ALineStep: Integer);
begin
  { подправляем новые значения }
  if APageStep < 0 then APageStep := 0;
  if ALineStep < 0 then ALineStep := 0;
  if ARange < 0 then ARange := 0;
  { изменилось ли что нибудь }
  if (FRange <> ARange) or (FPageStep <> APageStep) or (FLineStep <> ALineStep) then
  begin
    { устанавливаем новые значения }
    FRange := ARange;
    FPageStep := APageStep;
    FLineStep := ALineStep;
    { подправляем позицию }
    if FPosition > FRange - FPageStep then FPosition := FRange - FPageStep;
    if FPosition < 0 then FPosition := 0;
    { обновляем скроллер }
    Update;
  end;
end;

procedure TGridScrollBar.SetPosition(Value: Integer);
begin
  SetPositionEx(Value, SB_ENDSCROLL);
end;

procedure TGridScrollBar.SetPositionEx(Value: Integer; ScrollCode: Integer);
var
  R: TRect;

  procedure UpdatePosition;
  begin
    if Value > Range - PageStep then Value := Range - PageStep;
    if Value < 0 then Value := 0;
  end;

begin
  { проверяем позицию }
  UpdatePosition;
  { изменилась ли позиция }
  if Value <> FPosition then
  begin
    { позиция меняется }
    Scroll(ScrollCode, Value);
    { снова проверяем }
    UpdatePosition;
  end;
  { изменилась ли позиция после реакции пользователя }
  if Value <> FPosition then
  begin
    { сдвигаем сетку }
    with FGrid do
    begin
      { гасим фокус }
      HideFocus;
      { сдвигаем }
      if FKind = sbHorizontal then
      begin
        R := GetClientRect;
        R.Left := R.Left + GetFixedWidth;
        ScrollWindow(Handle, (FPosition - Value) * FLineSize, 0, @R, @R);
      end
      else
      begin
        R := GetGridRect;
        ScrollWindow(Handle, 0, (FPosition - Value) * FLineSize, @R, @R);
      end;
      { устанавливаем новую позицию }
      FPosition := Value;
      { показываем фокус }
      ShowFocus;
    end;
    { устанавливаем скроллер }
    Update;
    { изменение }
    Change;
  end;
end;

procedure TGridScrollBar.Assign(Source: TPersistent);
begin
  if Source is TGridScrollBar then
  begin
    Inc(FUpdateCount);
    try
      PageStep := TGridScrollBar(Source).PageStep;
      LineStep := TGridScrollBar(Source).LineStep;
      Range := TGridScrollBar(Source).Range;
      Position := TGridScrollBar(Source).Position;
      Tracking := TGridScrollBar(Source).Tracking;
      Visible := TGridScrollBar(Source).Visible;
      Exit;
    finally
      Dec(FUpdateCount);
    end;
  end;
  inherited Assign(Source);
end;

{ TGridListBox }

constructor TGridListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentShowHint := False;
  ShowHint := False;
end;

procedure TGridListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TGridListBox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TGridListBox.Keypress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27:
      { сбрасываем текст поиска }
      FSearchText := '';
    #32..#255:
      { инициируем поиск }
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTime > 2000 then FSearchText := '';
        FSearchTime := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TGridListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Grid <> nil then Grid.Edit.CloseUp((X >= 0) and (Y >= 0) and (X < Width) and (Y < Height));
end;

{ TGridEdit }

constructor TGridEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { внутренние переменные }
  FEditStyle := geSimple;
  FDropDownCount := 8;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  { параметры внешнего вида }
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsNone;
  ParentShowHint := False;
  ShowHint := False;
end;

function TGridEdit.GetButtonRect: TRect;
begin
  Result := Rect(Width - FButtonWidth, 0, Width, Height);
end;

function TGridEdit.GetLineCount: Integer;
begin
  Result := Ex_Utils.GetLineCount(Text); 
end;

function TGridEdit.GetVisible: Boolean;
begin
  Result := IsWindowVisible(Handle);
end;

procedure TGridEdit.ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then CloseUp(PtInRect(FDropList.ClientRect, Point(X, Y)));
end;

procedure TGridEdit.SetButtonWidth(Value: Integer);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    Repaint;
  end;
end;

procedure TGridEdit.SetEditStyle(Value: TGridEditStyle);
begin
  if FEditStyle <> Value then
  begin
    FEditStyle := Value;
    Repaint;
  end;
end;

procedure TGridEdit.StartButtonTracking(X, Y: Integer);
begin
  MouseCapture := True;
  FButtonTracking := True;
  StepButtonTracking(X, Y);
end;

procedure TGridEdit.StepButtonTracking(X, Y: Integer);
var
  R: TRect;
  P: Boolean;
begin
  R := GetButtonRect;
  P := PtInRect(R, Point(X, Y));
  if FButtonPressed <> P then
  begin
    FButtonPressed := P;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TGridEdit.StopButtonTracking;
begin
  if FButtonTracking then
  begin
    StepButtonTracking(-1, -1);
    FButtonTracking := False;
    MouseCapture := False;
  end;
end;

procedure TGridEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS + DLGC_WANTCHARS;
end;

procedure TGridEdit.WMCancelMode(var Message: TMessage);
begin
  StopButtonTracking;
  inherited;
end;

procedure TGridEdit.WMKillFocus(var Message: TMessage);
begin
  inherited;
  CloseUp(False);
end;

procedure TGridEdit.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  Invalidate;
end;

procedure TGridEdit.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TGridEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  P: TPoint;
begin
  with Message do
  begin
    P := Point(XPos, YPos);
    if (FEditStyle <> geSimple) and PtInRect(GetButtonRect, P) then Exit;
  end;
  inherited;
end;

procedure TGridEdit.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  { не попала ли мышка на кнопку }
  if (FEditStyle <> geSimple) and PtInRect(GetButtonRect, ScreenToClient(P)) then
  begin
    Windows.SetCursor(LoadCursor(0, IDC_ARROW));
    Exit;
  end;
  { обработка по умолчанию }
  inherited;
end;

procedure TGridEdit.WMPaste(var Message);
begin
  if (Grid = nil) or Grid.EditCanModify then inherited;
end;

procedure TGridEdit.WMClear(var Message);
begin
  if (Grid = nil) or Grid.EditCanModify then inherited;
end;

procedure TGridEdit.WMCut(var Message);
begin
  if (Grid = nil) or Grid.EditCanModify then inherited;
end;

procedure TGridEdit.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FDropList) then CloseUp(False);
end;

procedure TGridEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TGridEdit.CMShowingChanged(var Message: TMessage);
begin
  { игнорируем изменение видимости через изменение свойства Visible }
end;

procedure TGridEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TGridEdit.DblClick;
begin
  if Grid <> nil then Grid.DblClick;
end;

procedure TGridEdit.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    if Grid <> nil then
    begin
      Grid.KeyDown(Key, Shift);
      Key := 0;
    end;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    if Grid <> nil then
    begin
      GridKeyDown := Grid.OnKeyDown;
      if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
    end;
  end;

begin
  { обрабатываем нажатие }
  case Key of
    VK_UP,
    VK_DOWN:
      { перемещение фокуса }
      if (Shift = [ssCtrl]) or ((Shift = []) and (not MultiLine)) then SendToParent;
    VK_PRIOR,
    VK_NEXT:
      { перемещение фокуса }
      if Shift = [ssCtrl] then SendToParent;
    VK_ESCAPE:
      { отмена }
      SendToParent;
    VK_INSERT:
      { вставка }
      if (Shift = [ssCtrl]) or ReadOnly then SendToParent;
    VK_LEFT,
    VK_RIGHT,
    VK_HOME,
    VK_END:
      { перемещение фокуса при нажатом Ctrl }
      if Shift = [ssCtrl] then SendToParent;
  end;
  { кнопка не обработана - событие }
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;

procedure TGridEdit.KeyPress(var Key: Char);
begin
  if Grid <> nil then
  begin
    { отсылаем клавишу таблице }
    Grid.KeyPress(Key);
    { проверяем доступность символа }
    if (Key in [#32..#255]) and not Grid.EditCanAcceptKey(Key) then
    begin
      Key := #0;
      MessageBeep(0);
    end;
    { разбираем символ }
    case Key of
      #9, #27:
        { TAB, ESC убираем }
        Key := #0;
      ^H, ^V, ^X, #32..#255:
        { BACKSPACE, обычные символы убираем, если нельзя редактировать }
        if not Grid.EditCanModify then Key := #0;
    end;
  end;
  { обработан ли символ }
  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TGridEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Grid <> nil then Grid.KeyUp(Key, Shift);
end;

procedure TGridEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { проверяем нажатие на кнопку }
  if (Button = mbLeft) and (EditStyle <> geSimple) and PtInrect(ButtonRect, Point(X, Y)) then
  begin
    { видим ли список }
    if FDropListVisible then
      { закрываем его }
      CloseUp(False)
    else
    begin
      { начинаем нажатие на кнопку и, если нужно, открываем список }
      StartButtonTracking(X, Y);
      if EditStyle <> geEllipsis then DropDown;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TGridEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  M: TSmallPoint;
begin
  if FButtonTracking then
  begin
    { нажатие на кнопку }
    StepButtonTracking(X, Y);
    { для открытого списка }
    if FDropListVisible then
    begin
      { получаем точку на списке }
      P := FDropList.ScreenToClient(ClientToScreen(Point(X, Y)));
      { если попали на список }
      if PtInRect(FDropList.ClientRect, P) then
      begin
        { прекращаем нажатие на кнопку }
        StopButtonTracking;
        { эмулируем нажатие на список }
        M := PointToSmallPoint(P);
        SendMessage(FDropList.Handle, WM_LBUTTONDOWN, 0, Integer(M));
        Exit;
      end;
    end;
  end;
  { обработка по умолчанию }
  inherited MouseMove(Shift, X, Y);
end;

procedure TGridEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: Boolean;
begin
  P := FButtonPressed;
  { завершаем нажатие }
  StopButtonTracking;
  { нажатие на кнопку }
  if (Button = mbLeft) and (EditStyle = geEllipsis) and P then Press;
  { обработка по умолчанию }
  inherited MouseUp(Button, Shift, X, Y);
end;

function ControlRectToClientRect(Source, Dest: TControl; Rect: TRect): TRect;
begin
  { в координаты экрана }
  Result.TopLeft := Source.ClientToScreen(Rect.TopLeft);
  Result.BottomRight := Source.ClientToScreen(Rect.BottomRight);
  { в координаты клиентской области }
  Result.TopLeft := Dest.ScreenToClient(Result.TopLeft);
  Result.BottomRight := Dest.ScreenToClient(Result.BottomRight);
end;

procedure TGridEdit.PaintButton(DC: HDC);
var
  R: TRect;
  Flags: Integer;
begin
  { рисуем кнопку }
  if EditStyle <> geSimple then               
  begin
    { получаем прямоугольник кнопки }
    R := GetButtonRect;
    { рисуем кнопку }
    if EditStyle = geEllipsis then
    begin
      { кнопка с троеточием }
      Flags := 0;
      if FButtonPressed then Flags := BF_FLAT;
      DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      Flags := ((R.Right - R.Left) shr 1) - 1 + Ord(FButtonPressed);
      PatBlt(DC, R.Left + Flags, R.Top + Flags, 2, 2, BLACKNESS);
      PatBlt(DC, R.Left + Flags - 3, R.Top + Flags, 2, 2, BLACKNESS);
      PatBlt(DC, R.Left + Flags + 3, R.Top + Flags, 2, 2, BLACKNESS);
    end
    else
    begin
      { кнопка списка }
      Flags := 0;
      if FButtonPressed then Flags := DFCS_FLAT or DFCS_PUSHED;
      DrawFrameControl(DC, R, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
(*
      if FButtonPressed then Flags := DFCS_FLAT;
      DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      Flags := ((R.Right - R.Left) shr 1) - 1 + Ord(FButtonPressed);
      PatBlt(DC, R.Left + Flags - 2, R.Top + Flags + 0, 7, 1, BLACKNESS);
      PatBlt(DC, R.Left + Flags - 1, R.Top + Flags + 1, 5, 1, BLACKNESS);
      PatBlt(DC, R.Left + Flags - 0, R.Top + Flags + 2, 3, 1, BLACKNESS);
      PatBlt(DC, R.Left + Flags + 1, R.Top + Flags + 3, 1, 1, BLACKNESS);
*)
    end;
  end;
end;

procedure TGridEdit.PaintWindow(DC: HDC);
begin
  { рисуем кнопку }
  PaintButton(DC);
  { отрисовка по умолчанию }
  inherited PaintWindow(DC);
end;

procedure TGridEdit.UpdateBounds;
const
  Flags = SWP_SHOWWINDOW or SWP_NOREDRAW;
var
  R, F: TRect;
  L, T, W, H, X, Y: Integer;

  function TextHeight(const S: string): Integer;
  var
    Canvas: TControlCanvas;
  begin
    { создаем полотно }
    Canvas := TControlCanvas.Create;
    try
      { присваиваем ему параметры строки }
      Canvas.Control := Self;
      Canvas.Font := Self.Font;
      { результат }
      Result := Canvas.TextHeight(Self.Text);
    finally
      Canvas.Free;
    end;
  end;

begin
  if Grid <> nil then
  begin
    { определяем прямоугольник ячейки строки ввоа }
    R := Grid.GetEditRect(Grid.EditCell);
    { запоминаем прямоугольник }
    F := R;
    { подправляем строку в соотвествии с фиксированными }
    with Grid.GetFixedRect do
    begin
      if R.Left < Right then R.Left := Right;
      if R.Right < Right then R.Right := Right;
    end;
    { подправляем строку в соотвествии с заголовком }
    with Grid.GetHeaderRect do
    begin
      if R.Top < Bottom then R.Top := Bottom;
      if R.Bottom < Bottom then R.Bottom := Bottom;
    end;
    { устанавливаем положение }
    W := R.Right - R.Left;
    H := R.Bottom - R.Top;
    SetWindowPos(Handle, HWND_TOP, R.Left, R.Top, W, H, Flags);
    { вычисляем новые границы такста }
    L := F.Left - R.Left;
    T := F.Top - R.Top;
    W := F.Right - F.Left;
    H := F.Bottom - F.Top;
    X := Grid.GetCellBorder(Grid.EditCell);
    Y := ((F.Bottom - F.Top) - Abs(TextHeight(Text))) mod 2;
    { учитываем кнопку }
    if EditStyle <> geSimple then Dec(W, ButtonWidth - 4);
    { устанавливаем границы текста }
    R := Bounds(L + X, T + 1, W - (X + 6), H - Y);
    SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  end
end;
                                                   
procedure TGridEdit.UpdateColors;
var
  Canvas: TCanvas;
begin
  if Grid <> nil then
  begin
    Canvas := TCanvas.Create;
    try
      { получаем цвета ячейки }
      Grid.GetCellColors(Grid.EditCell, Canvas);
      { запоминаем их }
      Color := Canvas.Brush.Color;
      Font := Canvas.Font;
    finally
      Canvas.Free;
    end;
  end;
end;

procedure TGridEdit.UpdateContents;
begin
  { обновляем параметры строки }
  if Grid <> nil then
  begin
    Self.ReadOnly := Grid.Columns[Grid.EditCell.Col].ReadOnly;
    Self.MaxLength := Grid.Columns[Grid.EditCell.Col].MaxLength;
    Self.MultiLine := Grid.Columns[Grid.EditCell.Col].MultiLine;
    Self.Text := Grid.GetEditText(Grid.EditCell);
  end;
end;

procedure TGridEdit.UpdateList;
begin
  { обновляем выпадающий список }
  if (Grid <> nil) and (FDropList <> nil) then
  begin
    { очищаем старый список }
    FDropList.Items.Clear;
    { заполняем новый }
    Grid.GetEditList(Grid.EditCell, FDropList.Items);
    { устанавливаем выделенную позицию }
    SendMessage(FDropList.Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(Text)));
  end;
end;

procedure TGridEdit.UpdateListBounds;
var
  I, X, W: Integer;
  R: TRect;
begin
  { а есть ли таблица }
  if (Grid = nil) or (FDropList <> nil) then
    { обновляем размеры выпадающего списка }
    with FDropList do
    begin
      Canvas.Font := Font;
      { определяем ширину строкам списка }
      if Items.Count > 0 then
      begin
        W := 0;
        for I := 0 to Items.Count - 1 do
        begin
          X := Canvas.TextWidth(Items[I]);
          if W < X then W := X;
        end;
        ClientWidth := W + 6;
      end
      else
        ClientWidth := 100;
      { подправляем по ширине колонки }
      R := Grid.GetCellRect(Grid.EditCell);
      Width := MaxIntValue([Width, R.Right - R.Left]);
      { определяем высоту }
      if (FDropDownCount < 1) or (Items.Count = 0) then
        ClientHeight := ItemHeight
      else if Items.Count < FDropDownCount then
        ClientHeight := Items.Count * ItemHeight
      else
        ClientHeight := FDropDownCount * ItemHeight;
      { положение }
      Left := Self.ClientOrigin.X + Self.Width - Width;
      Top := Self.ClientOrigin.Y + Self.Height;
      { подправляем в соотвествием с пожеланием пользователя }
      R := BoundsRect;
      Grid.GetEditListBounds(Grid.EditCell, R);
      BoundsRect := R;
    end;
end;

procedure TGridEdit.UpdateStyle;
var
  Style: TGridEditStyle;
begin
  { получаем стиль строки }
  Style := geSimple;
  if Grid <> nil then Style := Grid.GetEditStyle(Grid.EditCell);
  { устанавливаем }
  EditStyle := Style;
end;

{
  Delete the requested message from the queue, but throw back
  any WM_QUIT msgs that PeekMessage may also return.
}
procedure KillMessage(Wnd: HWND; Msg: Integer);
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, PM_REMOVE) and (M.Message = WM_QUIT) then PostQuitMessage(M.wParam);
end;

procedure TGridEdit.WndProc(var Message: TMessage);

  procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
  begin
    case Key of
      VK_UP, VK_DOWN:
        { открытие или закрытие }
        if ssAlt in Shift then
        begin
          Key := 0;
          if FDropListVisible then CloseUp(True) else DropDown;
        end;
      VK_RETURN, VK_ESCAPE:
        { закрытие списка }
        if (not (ssAlt in Shift)) and FDropListVisible then
        begin
          KillMessage(Handle, WM_CHAR);
          Key := 0;
          CloseUp(Key = VK_RETURN);
        end;
    end;
  end;

  procedure DoButtonKeys(var Key: Word; Shift: TShiftState);
  begin
    if (Key = VK_RETURN) and (Shift = [ssCtrl]) then
    begin
      KillMessage(Handle, WM_CHAR);
      Key := 0;
      { эмуляция нажатия на кнопку }
      case EditStyle of
        geEllipsis: Press;
        gePickList,
        geDataList: if not FDropListVisible then SelectNext;
      end;
    end;
  end;

begin
  case Message.Msg of
    WM_KEYDOWN,
    WM_SYSKEYDOWN,
    WM_CHAR:
        with TWMKey(Message) do
        begin
          { открытие списка }
          if EditStyle in [gePickList, geDataList] then
          begin
            DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
            { передаем оставшееся событие списку }
            if (CharCode <> 0) and FDropListVisible then
            begin
              with TMessage(Message) do SendMessage(FDropList.Handle, Msg, WParam, LParam);
              Exit;
            end;
          end;
          { эмуляция нажатия на кнопку }
          if not MultiLine then
          begin
            DoButtonKeys(CharCode, KeyDataToShiftState(KeyData));
            if CharCode = 0 then Exit;
          end;
        end;
    WM_LBUTTONDOWN:
      { двойное нажатие мышки }
      begin
        if GetMessageTime - FClickTime < GetDoubleClickTime then Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

procedure TGridEdit.CloseUp(Accept: Boolean);
const
  Flags = SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW;
var
  I: Integer;
begin
  if FDropListVisible then
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    { скрываем список }
    SetWindowPos(FDropList.Handle, 0, 0, 0, 0, 0, Flags);
    FDropListVisible := False;
    Invalidate;
    { устанавливаем выбранное значение }
    if Accept and (Grid <> nil) then
    begin
      I := FDropList.ItemIndex;
      if I <> -1 then Text := FDropList.Items[DropList.ItemIndex];
    end;
  end;
end;

procedure TGridEdit.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, Longint($FFFFFFFF));
end;

procedure TGridEdit.DropDown;
const
  Flags = SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW;
begin
  if (Grid <> nil) and (EditStyle in [gePickList, geDataList]) then
  begin
    { создаем список }
    if FDropList = nil then
    begin
      FDropList := Grid.CreateEditList;
      FDropList.Visible := False;
      FDropList.Parent := Self;
      FDropList.FGrid := Grid;
      FDropList.OnMouseUp := ListMouseUp;
      FDropList.IntegralHeight := True;
      FDropList.Font := Font;
    end;
    { заполяем список, устанавливаем размеры }
    UpdateList;
    UpdateListBounds;
    { показываем список }
    SetWindowPos(FDropList.Handle, HWND_TOP, FDropList.Left, FDropList.Top, 0, 0, Flags);
    FDropListVisible := True;
    Invalidate;
    { устанавливаем на него фокус }
    Windows.SetFocus(Handle);
  end;
end;

procedure TGridEdit.Invalidate;
var
  Cur: TRect;
begin
  { проверяем таблицу }
  if Grid = nil then
  begin
    inherited Invalidate;
    Exit;
  end;
  { перерисовываемся }
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  { обновляем прямоугольник таблицы }
  Windows.GetClientRect(Handle, Cur);
  MapWindowPoints(Handle, Grid.Handle, Cur, 2);
  ValidateRect(Grid.Handle, @Cur);
  InvalidateRect(Grid.Handle, @Cur, False);
end;

procedure TGridEdit.Hide;
const
  Flags = SWP_HIDEWINDOW or SWP_NOZORDER or SWP_NOREDRAW;
begin
  if (Grid <> nil) and HandleAllocated and Visible then
  begin
    { сбрасываем флаг редактирования }
    Grid.FEditing := False;
    { скрываем строку ввода }
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, Flags);
    { удаляем фокус }
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;

procedure TGridEdit.Press;
begin
  if Grid <> nil then Grid.EditButtonPress(Grid.EditCell);
end;

procedure TGridEdit.SelectNext;
begin
  if Grid <> nil then Grid.EditSelectNext(Grid.EditCell);
end;

procedure TGridEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then Windows.SetFocus(Handle);
end;

procedure TGridEdit.Show;
begin
  if Grid <> nil then
  begin
    { поднимаем флаг редактирования }
    Grid.FEditing := True;
    { подправляем цвета (следует делать до установки границ) }
    UpdateColors;
    { получаем размеры }
    UpdateBounds;
    { устанавливаем фокус }
    if Grid.Focused then Windows.SetFocus(Handle);
  end;
end;

{ TGridTipsWindow }

procedure TGridTipsWindow.WMNCPaint(var Message: TMessage);
begin
  Canvas.Handle := GetWindowDC(Handle);
  try
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := Color;
    Canvas.Rectangle(0, 0, Width, Height);
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TGridTipsWindow.CMTextChanged(var Message: TMessage);
begin
  { игнорируем событие, иначе "прыгает" размер окна }
end;

procedure TGridTipsWindow.Paint;
begin
  { а есть ли таблица }
  if FGrid = nil then
  begin
    inherited Paint;
    Exit;
  end;
  { получаем шрифт ячейки }
  FGrid.GetCellColors(FGrid.FTipsCell, Canvas);
  { подправляем цвета }
  Canvas.Brush.Color := Color;
  Canvas.Font.Color := clInfoText;
  { рисуем текст }
  FGrid.PaintCellText(FGrid.FTipsCell, ClientRect, Canvas);
end;

procedure TGridTipsWindow.ActivateHint(Rect: TRect; const AHint: string);
const
  Flags = SWP_SHOWWINDOW or SWP_NOACTIVATE;
begin
  Caption := AHint;
  UpdateBoundsRect(Rect);
  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height, Flags);
  Invalidate;
end;

{$IFNDEF VER90}

procedure TGridTipsWindow.ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer);
begin
  FGrid := AData;
  inherited ActivateHintData(Rect, AHint, AData);
end;

function TGridTipsWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
var
  R: TRect;
begin
  { ссылка на таблицу }
  FGrid := AData;
  { есть ли таблица }
  if FGrid = nil then
  begin
    Result := inherited CalcHintRect(MaxWidth, AHint, AData);
    Exit;
  end;
  { прямоугольник подсказки }
  R := FGrid.GetTipsRect(FGrid.FTipsCell, MaxWidth);
  { подправляем положение, учитываем бордюр }
  OffsetRect(R, -R.Left, -R.Top);
  { результат }
  Result := R;
end;

{$ENDIF}

{ TCustomGridView }

constructor TCustomGridView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Width := 185;
  Height := 105;
  Color := clWindow;
  ParentColor := False;
  TabStop := True;
  FHorzScrollBar := CreateScrollBar(sbHorizontal);
  FHorzScrollBar.OnScroll := HorzScroll;
  FHorzScrollBar.OnChange := HorzScrollChange;
  FVertScrollBar := CreateScrollBar(sbVertical);
  FVertScrollBar.LineSize := 17;
  FVertScrollBar.OnScroll := VertScroll;
  FVertScrollBar.OnChange := VertScrollChange;
  FHeader := CreateHeader;
  FHeader.OnChange := HeaderChange;
  FColumns := CreateColumns;
  FColumns.OnChange := ColumnsChange;
  FRows := CreateRows;
  FRows.OnChange := RowsChange;
  FFixed := CreateFixed;
  FFixed.OnChange := FixedChange;
  FImagesLink := TChangeLink.Create;
  FImagesLink.OnChange := ImagesChange;
  FBorderStyle := bsSingle;
  FShowHeader := True;
  FGridLines := True;
  FGridLineWidth := 1;
  FEndEllipsis := True;
  FShowFocusRect := True;
  FRightClickSelect := True;
  FEditCell := GridCell(-1, -1);
end;

destructor TCustomGridView.Destroy;
begin
  FImagesLink.Free;
  FRows.Free;
  FColumns.Free;
  FHeader.Free;
  FHorzScrollBar.Free;
  FVertScrollBar.Free;
  inherited Destroy;
end;

function TCustomGridView.GetCell(Col, Row: Integer): string;
begin
  Result := GetCellText(GridCell(Col, Row));
end;

procedure TCustomGridView.ColumnsChange(Sender: TObject);
begin
  if [csReading, csLoading] * ComponentState = [] then
  begin
    Header.Synchronized := False;
    Fixed.Count := Fixed.Count;
  end;
  UpdateScrollBars;
  UpdateScrollRange;
  UpdateEdit(Editing);
  UpdateCursor;
  Invalidate;
  ChangeColumns;
end;

procedure TCustomGridView.FixedChange(Sender: TObject);
begin
  UpdateScrollBars;
  UpdateScrollRange;
  UpdateEdit(Editing);
  UpdateCursor;
  Invalidate;
  ChangeFixed; 
end;

procedure TCustomGridView.HeaderChange(Sender: TObject);
begin
  UpdateScrollBars;
  UpdateScrollRange;
  UpdateEdit(Editing);
  Invalidate;
end;

procedure TCustomGridView.HorzScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
begin
  UpdateFocus;
end;

procedure TCustomGridView.HorzScrollChange(Sender: TObject);
begin
  UpdateScrollRange;
  UpdateEdit(Editing);
end;

procedure TCustomGridView.ImagesChange(Sender: TObject);
begin
  InvalidateGrid;
end;

procedure TCustomGridView.RowsChange(Sender: TObject);
begin
  UpdateScrollBars;
  UpdateScrollRange;
  UpdateEdit(Editing);
  UpdateCursor;
  InvalidateGrid;
  ChangeRows;
end;

procedure TCustomGridView.SetAllowEdit(Value: Boolean);
begin
  if FAllowEdit <> Value then
  begin
    FAllowEdit := Value;
    if Value then RowSelect := False else AlwaysEdit := False;
    UpdateEdit(Editing);
  end;
end;

procedure TCustomGridView.SetAlwaysEdit(Value: Boolean);
begin
  if FAlwaysEdit <> Value then
  begin
    FAlwaysEdit := Value;
    if Value then AllowEdit := True;
    UpdateEdit(Editing);
  end;
end;

procedure TCustomGridView.SetAlwaysSelected(Value: Boolean);
begin
  if FAlwaysSelected <> Value then
  begin
    FAlwaysSelected := Value;
    FCellSelected := FCellSelected or Value;
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCustomGridView.SetCell(Col, Row: Integer; Value: string);
begin
  SetEditText(GridCell(Col, Row), Value);
end;

procedure TCustomGridView.SetCellFocused(Value: TGridCell);
begin
  SetCursor(Value, CellSelected, True);
end;

procedure TCustomGridView.SetCellSelected(Value: Boolean);
begin
  SetCursor(CellFocused, Value, True);
end;

procedure TCustomGridView.SetColumns(Value: TGridColumns);
begin
  FColumns.Assign(Value);
end;

procedure TCustomGridView.SetEditing(Value: Boolean);
begin
  if Value then
  begin
    ShowEdit;
    if FEdit <> nil then FEdit.Deselect;
  end
  else
    HideEdit;
end;

procedure TCustomGridView.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetFixed(Value: TGridFixed);
begin
  FFixed.Assign(Value);
end;

procedure TCustomGridView.SetHeader(Value: TGridHeader);
begin
  Header.Assign(Value);
end;

procedure TCustomGridView.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetHorzScrollBar(Value: TGridScrollBar);
begin
  FHorzScrollBar.Assign(Value);
end;

procedure TCustomGridView.SetGridLines(Value: Boolean);
begin
  if FGridLines <> Value then
  begin
    FGridLines := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetShowCellTips(Value: Boolean);
begin
  if FShowCellTips <> Value then
  begin
    FShowCellTips := Value;
    ShowHint := ShowHint or Value;
  end;
end;

procedure TCustomGridView.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetShowHeader(Value: Boolean);
begin
  if FShowHeader <> Value then
  begin
    FShowHeader := Value;
    UpdateScrollBars;
    UpdateScrollRange;
    UpdateEdit(Editing);
    UpdateCursor;
    Invalidate;
  end;
end;

procedure TCustomGridView.SetImages(Value: TImageList);
begin
  if FImages <> Value then
  begin
    if Assigned(FImages) then FImages.UnRegisterChanges(FImagesLink);
    FImages := Value;
    if Assigned(FImages) then FImages.RegisterChanges(FImagesLink);
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetRows(Value: TGridRows);
begin
  FRows.Assign(Value);
end;

procedure TCustomGridView.SetRowSelect(Value: Boolean);
begin
  if FRowSelect <> Value then
  begin
    FRowSelect := Value;
    if Value then AllowEdit := False else UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetVertScrollBar(Value: TGridScrollBar);
begin
  FVertScrollBar.Assign(Value);
end;

procedure TCustomGridView.SetVisOrigin(Value: TGridCell);
var
  SOrigin: TGridCell;
begin
  if (FVisOrigin.Col <> Value.Col) or (FVisOrigin.Row <> Value.Row) then
  begin
    SOrigin := FVisOrigin;
    FVisOrigin := Value;
    if SOrigin.Col <> Value.Col then
      Invalidate
    else
      InvalidateGrid;
  end;
end;

procedure TCustomGridView.VertScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
begin
  UpdateFocus;
end;

procedure TCustomGridView.VertScrollChange(Sender: TObject);
begin
  UpdateScrollRange;
  UpdateEdit(Editing);
end;

procedure TCustomGridView.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS + DLGC_WANTCHARS;
end;

procedure TCustomGridView.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  if Rows.Count > 0 then
  begin
    InvalidateFocus;
    if (FEdit = nil) or (Message.FocusedWnd <> FEdit.Handle) then HideCursor;
  end;
end;

procedure TCustomGridView.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if Rows.Count > 0 then
  begin
    InvalidateFocus;
    if (FEdit = nil) or (Message.FocusedWnd <> FEdit.Handle) then ShowCursor;
  end;
end;

procedure TCustomGridView.WMChar(var Msg: TWMChar);
begin
  { показываем строку ввода, если можно }
  if AllowEdit and (Char(Msg.CharCode) in [^H, #32..#255]) then
  begin
    ShowEditChar(Char(Msg.CharCode));
    Exit;
  end;
  { иначе обработка по умолчанию }
  inherited;
end;

procedure TCustomGridView.WMSize(var Message: TWMSize);
begin
  inherited;
  UpdateScrollBars;
  UpdateScrollRange;
  UpdateEdit(Editing);
  Resize;
end;

procedure TCustomGridView.WMHScroll(var Message: TWMHScroll);
begin
  if Message.ScrollBar = 0 then
    FHorzScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TCustomGridView.WMVScroll(var Message: TWMVScroll);
begin
  if Message.ScrollBar = 0 then
    FVertScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TCustomGridView.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  FHitTest := ScreenToClient(SmallPointToPoint(Message.Pos));
end;

procedure TCustomGridView.WMSetCursor(var Message: TWMSetCursor);
begin
  with Message, FHitTest do
    if (HitTest = HTCLIENT) and not (csDesigning in ComponentState) then
      if ShowHeader and PtInRect(GetHeaderRect, FHitTest) then
        if GetResizeSection(X, Y) <> nil then
        begin
          Windows.SetCursor(Screen.Cursors[crHSplit]);
          Exit;
        end;
  inherited;
end;

procedure TCustomGridView.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TCustomGridView.CMCancelMode(var Message: TCMCancelMode); 
begin
  if FEdit <> nil then FEdit.WndProc(TMessage(Message));
  inherited;
end;

procedure TCustomGridView.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;

procedure TCustomGridView.CMFontChanged(var Message: TMessage);
begin
  { запоминаем шрифт }
  Canvas.Font := Font;
  { подправляем шрифт у заголовка и фиксированных }
  UpdateFonts;
  { обработка по умолчанию }
  inherited;
end;

procedure TCustomGridView.CMColorChanged(var Message: TMessage);
begin
  { запоминаем цвет }
  Brush.Color := Color;
  { подправляем цвет у заголовка и фиксированных }
  UpdateColors;
  { обработка по умолчанию }
  inherited;
end;

procedure TCustomGridView.CMShowHintChanged(var Message: TMessage);
begin
  ShowCellTips := ShowCellTips and ShowHint;
end;

{$IFNDEF VER90}

procedure TCustomGridView.CMHintShow(var Message: TMessage);
var
  R: TRect;
  T: string;
begin
  with Message, PHintInfo(LParam)^ do
  begin
    { а нужны ли подсказки }
    if not ShowCellTips then
    begin
      inherited;
      Exit;
    end;
    { ищем ячейку, на которую указывает курсор }
    FTipsCell := GetCellAt(CursorPos.X, CursorPos.Y);
    { если не попали - подсказки нет, выход }
    if IsCellEmpty(FTipsCell) then
    begin
      Result := 1;
      Exit;
    end;
    { а не идел ли редактирование этой ячейки }
    if IsCellEqual(EditCell, FTipsCell) and Editing then
    begin
      Result := 1;
      Exit;
    end;
    { получаем прямоугольник ячейки }
    R := GetEditRect(FTipsCell);
    { получаем прямоугольник текста }
    Inc(R.Left, GetCellBorder(FTipsCell));
    Dec(R.Right, 6);
    { учитываем клиентскую часть }
    IntersectRect(R, R, ClientRect);
    { получаем текст ячейки }
    T := GetCellText(FTipsCell);
    { настраиваем цвета и шрифт ячейки }
    GetCellColors(FTipsCell, Canvas);
    { а вылезает ли текст за ячейку }
    if Canvas.TextWidth(T) < R.Right - R.Left then
    begin
      Result := 1;
      Exit;
    end;
    { получаем прямоугольник подсказки }
    R := GetTipsRect(FTipsCell, HintMaxWidth);
    { настраиваем положение и текст подсказки }
    HintPos := ClientToScreen(R.TopLeft);
    HintStr := T;
    { настраиваем прямоугольник подсказки }
    R := GetCellRect(FTipsCell);
    if FTipsCell.Col < Fixed.Count then
    begin
      R.Left := MaxIntValue([R.Left, 0]);
      R.Right := MinIntValue([R.Right, GetFixedWidth]);
    end
    else
    begin
      R.Left := MaxIntValue([R.Left, GetFixedWidth]);
      R.Right := MinIntValue([R.Right, ClientWidth]);
    end;
    InflateRect(R, 1, 1);
    CursorRect := R;
    { тип окна подсказки }
    HintWindowClass := GetTipsWindow;
    HintData := Self;
    { результат }
    Result := 0;
  end;
end;

{$ELSE}

procedure TCustomGridView.CMHintShow(var Message: TMessage);
begin
  inherited;
end;

{$ENDIF}

function TCustomGridView.AcquireFocus: Boolean;
begin
  Result := True;
  { можно ли устанавливать фокус }
  if not (csDesigning in ComponentState) and CanFocus then
  begin
    UpdateFocus;
    Result := IsActiveControl;
  end;
end;

procedure TCustomGridView.CellClick(Cell: TGridCell; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnCellClick) then FOnCellClick(Self, Cell, Shift, X, Y);
end;

procedure TCustomGridView.Change(var Cell: TGridCell; var Selected: Boolean);
begin
  if Assigned(FOnChange) then FOnChange(Self, Cell, Selected);
end;

procedure TCustomGridView.ChangeColumns;
begin
  if Assigned(FOnChangeColumns) then FOnChangeColumns(Self);
end;

procedure TCustomGridView.ChangeFixed;
begin
  if Assigned(FOnChangeFixed) then FOnChangeFixed(Self);
end;

procedure TCustomGridView.ChangeRows;
begin
  if Assigned(FOnChangeRows) then FOnChangeRows(Self);
end;

procedure TCustomGridView.ChangeScale(M, D: Integer);
var
  S: Boolean;
  I: Integer;
begin
  inherited ChangeScale(M, D);
  if M <> D then
  begin
    S := Header.Synchronized;
    try
      with Columns do
      begin
        BeginUpdate;
        try             
          for I := 0 to Count - 1 do
            Columns[I].Width := MulDiv(Columns[I].Width, M, D);
        finally
          EndUpdate;
        end;
      end;
      with Rows do
        Height := MulDiv(Height, M, D);
      with Header do
      begin
        SectionHeight := MulDiv(SectionHeight, M, D);
        Font.Size := MulDiv(Font.Size, M, D);
      end;
    finally
      Header.Synchronized := S;
    end;
  end;
end;

procedure TCustomGridView.Changing(var Cell: TGridCell; var Selected: Boolean);
begin
  if Assigned(FOnChanging) then FOnChanging(Self, Cell, Selected);
end;

procedure TCustomGridView.ColumnResize(Column: Integer; var Width: Integer);
begin
  if Assigned(FOnColumnResize) then FOnColumnResize(Self, Column, Width);
end;

procedure TCustomGridView.ColumnResizing(Column: Integer; var Width: Integer);
begin
  if Assigned(FOnColumnResizing) then FOnColumnResizing(Self, Column, Width);
end;

function TCustomGridView.CreateColumn: TGridColumn;
begin
  Result := TGridColumn(TGridColumn.Create(FColumns));
end;

function TCustomGridView.CreateColumns: TGridColumns;
begin
  Result := TGridColumns.Create(Self);
end;

function TCustomGridView.CreateEdit: TGridEdit;
begin
  Result := TGridEdit.Create(Self);
end;

function TCustomGridView.CreateEditList: TGridListBox;
begin
  Result := TGridListBox.Create(Self);
end;

function TCustomGridView.CreateFixed: TGridFixed;
begin
  Result := TGridFixed.Create(Self);
end;

function TCustomGridView.CreateHeader: TGridHeader;
begin
  Result := TGridHeader.Create(Self);
end;

function TCustomGridView.CreateHeaderSection: TGridHeaderSection;
begin
  Result := TGridHeaderSection(TGridHeaderSection.Create(FHeader.Sections));
end;

procedure TCustomGridView.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of Longint = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_TABSTOP;
    Style := Style or BorderStyles[FBorderStyle];
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end
      else
        Style := Style or WS_BORDER;
  end;
end;

function TCustomGridView.CreateRows: TGridRows;
begin
  Result := TGridRows.Create(Self);
end;

function TCustomGridView.CreateScrollBar(Kind: TScrollBarKind): TGridScrollBar;
begin
  Result := TGridScrollBar.Create(Self, Kind);
end;

procedure TCustomGridView.DoExit;
begin
  inherited DoExit;
  { устанавливаем текст и гасим строку редактирования }
  if Editing and (not AlwaysEdit) then
  try
    UpdateEditText;
    HideEdit;
  except
    Windows.SetFocus(Handle);
    raise;
  end;
end;

procedure TCustomGridView.EditButtonPress(Cell: TGridCell);
begin
  if Assigned(FOnEditButtonPress) then FOnEditButtonPress(Self, Cell);
end;

procedure TCustomGridView.EditSelectNext(Cell: TGridCell);
begin
  if Assigned(FOnEditSelectNext) then FOnEditSelectNext(Self, Cell);
end;

function TCustomGridView.EditCanModify: Boolean;
begin
  Result := not Columns[CellFocused.Col].ReadOnly;
end;

function TCustomGridView.EditCanAcceptKey(Key: Char): Boolean;
begin
  Result := True;
  if Assigned(FOnEditAcceptKey) then FOnEditAcceptKey(Self, Key, Result);
end;

function TCustomGridView.EditCanShow: Boolean;
begin
  { проверяем режим дизайна и загрузки }
  if [csReading, csLoading, csDesigning] * ComponentState <> [] then
  begin
    Result := False;
    Exit;
  end;
  { результат }
  Result := HandleAllocated and AllowEdit and (AlwaysEdit or IsActiveControl);
end;

function TCustomGridView.GetCellBorder(Cell: TGridCell): Integer;
begin
  if IsCellHasImage(Cell) then Result := 2 else Result := 6;
end;

procedure TCustomGridView.GetCellColors(Cell: TGridCell; Canvas: TCanvas);
begin
  { фиксированные ячейки }
  if Cell.Col < Fixed.Count then
  begin
    Canvas.Brush.Color := Fixed.Color;
    Canvas.Font := Fixed.Font;
  end
  else
  begin
    { обычная ячейка }
    Canvas.Brush.Color := Self.Color;
    Canvas.Font := Self.Font;
    { выделенныя ячейка }
    if IsFocusAllowed and CellSelected and IsCellFocused(Cell) then
      { есть ли фокус на таблице }
      if Focused then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end
      { надо ли гасить выделенную ячейку }
      else if not HideSelection then
      begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.Font.Color := Font.Color;
      end;
  end;
  { событие пользователя }
  if Assigned(FOnGetCellColors) then FOnGetCellColors(Self, Cell, Canvas);
end;

function TCustomGridView.GetCellImage(Cell: TGridCell): Integer;
begin
  { а есть ли картинки }
  if not Assigned(Images) then
  begin
    Result := -1;
    Exit;
  end;
  { для первой картинки есть индекс, для остальных нет }
  if Cell.Col = Fixed.Count then Result := 0 else Result := -1;
  { событие пользователя }
  if Assigned(FOnGetCellImage) then FOnGetCellImage(Self, Cell, Result);
end;

function TCustomGridView.GetCellText(Cell: TGridCell): string;
begin
  Result := '';
  if Assigned(FOnGetCellText) then FOnGetCellText(Self, Cell, Result);
end;

function TCustomGridView.GetClientOrigin: TPoint;
begin
  if Parent = nil then
  begin
    Result.X := 0;
    Result.Y := 0;
    Exit;
  end;
  Result := inherited GetClientOrigin;
end;

function TCustomGridView.GetClientRect: TRect;
begin
  if Parent = nil then
  begin
    Result.Left := 0;
    Result.Top := 0;
    Result.Right := Width;
    Result.Bottom := Height;
    Exit;
  end;
  Result := inherited GetClientRect;
end;

function TCustomGridView.GetCursorCell(Cell: TGridCell; Offset: TGridOffset): TGridCell;

  function DoMoveLeft(O: Integer): TGridCell;
  var
    I: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := MaxIntValue([Cell.Col - O, Fixed.Count]);
    { перебираем колонки до фиксированных, пока не устанвится активная }
    while I >= Fixed.Count do
    begin
      C := GridCell(I, Cell.Row);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { предыдущая колонка }
      Dec(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveRight(O: Integer): TGridCell;
  var
    I: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := MinIntValue([Cell.Col + O, Columns.Count - 1]);
    { перебираем колонки до последней, пока не устанвится активная }
    while I <= Columns.Count - 1 do
    begin
      C := GridCell(I, Cell.Row);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { следующая колонка }
      Inc(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveUp(O: Integer): TGridCell;
  var
    J: Integer;
    C: TGridCell;
  begin
    { новая активная строка }
    J := MaxIntValue([Cell.Row - O, 0]);
    { перебираем строки до первой, пока не устанвится активная }
    while J >= 0 do
    begin
      C := GridCell(Cell.Col, J);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { предыдущая строка }
      Dec(J);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveDown(O: Integer): TGridCell;
  var
    J: Integer;
    C: TGridCell;
  begin
    { новая активная строка }
    J := MinIntValue([CellFocused.Row + O, Rows.Count - 1]);
    { перебираем строки до последней, пока не устанвится активная }
    while J <= Rows.Count - 1 do
    begin
      C := GridCell(Cell.Col, J);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { следующая строка }
      Inc(J);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveHome: TGridCell;
  var
    I, J: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := Fixed.Count;
    { перебираем колонки до текущей, пока не устанвится активная }
    while I <= Cell.Col do
    begin
      { новая активная строка }
      J := 0;
      { перебираем строки до текущей, пока не устанвится активная }
      while J <= Cell.Row do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая строка }
        Inc(J);
      end;
      { следующая колонка }
      Inc(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveEnd: TGridCell;
  var
    I, J: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := Columns.Count - 1;
    { перебираем колонки до текущей, пока не устанвится активная }
    while I >= Cell.Col do
    begin
      J := Rows.Count - 1;
      { перебираем строки до текущей, пока не устанвится активная }
      while J >= Cell.Row do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая строка }
        Dec(J);
      end;
      { предыдущая колонка }
      Dec(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoSelect: TGridCell;

    function DoSelectLeft: TGridCell;
    var
      I: Integer;
      C: TGridCell;
    begin
      I := MaxIntValue([Cell.Col, Fixed.Count]);
      { перебираем колонки до текущей, пока не устанвится активная }
      while I <= CellFocused.Col do
      begin
        C := GridCell(I, Cell.Row);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая колонка }
        Inc(I);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

    function DoSelectRight: TGridCell;
    var
      I: Integer;
      C: TGridCell;
    begin
      I := MinIntValue([Cell.Col, Columns.Count - 1]);
      { перебираем колонки до текущей, пока не устанвится активная }
      while I >= CellFocused.Col do
      begin
        C := GridCell(I, Cell.Row);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая колонка }
        Dec(I);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

    function DoSelectUp: TGridCell;
    var
      J: Integer;
      C: TGridCell;
    begin
      J := MaxIntValue([Cell.Row, 0]);
      { перебираем строки до текущей, пока не устанвится активная }
      while J <= CellFocused.Row do
      begin
        C := GridCell(Cell.Col, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая строка }
        Inc(J);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

    function DoSelectDown: TGridCell;
    var
      J: Integer;
      C: TGridCell;
    begin
      J := MinIntValue([Cell.Row, Rows.Count - 1]);
      { перебираем строки до текущей, пока не устанвится активная }
      while J >= CellFocused.Row do
      begin
        C := GridCell(Cell.Col, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая строка }
        Dec(J);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

  begin
    { а доступна ли указанная ячейка }
    if IsCellAcceptCursor(Cell) then
    begin
      Result := Cell;
      Exit;
    end;
    { если выделение слева от курсора - ищем слева }
    if Cell.Col < CellFocused.Col then
    begin
      Result := DoSelectLeft;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { если выделение справа от курсора - ищем справа }
    if Cell.Col > CellFocused.Col then
    begin
      Result := DoSelectRight;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { если выделение над курсором - ищем сверху }
    if Cell.Row < CellFocused.Row then
    begin
      Result := DoSelectUp;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { выделение под курсором - ищем снизу }
    if Cell.Row > CellFocused.Row then
    begin
      Result := DoSelectDown;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { ничего не изменилось }
    Result := CellFocused;
  end;

  function DoFirst: TGridCell;
  var
    C: TGridCell;
    I, J: Integer;
  begin
    J := 0;
    { перебираем строки до текущей, пока не устанвится активная }
    while J <= Rows.Count - 1 do
    begin
      I := Fixed.Count;
      { перебираем колонки до последней, пока не устанвится активная }
      while I <= Columns.Count - 1 do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая  колонка }
        Inc(I);
      end;
      { следующая строка }
      Inc(J);
    end;
    { результат по умолчанию }
    Result := CellFocused;
  end;

begin
  case Offset of
    goLeft:
      { смещение на колонку влево }
      Result := DoMoveLeft(1);
    goRight:
      { смещение вправо на одну колонку }
      Result := DoMoveRight(1);
    goUp:
      { смещение вверх на одну колонку }
      Result := DoMoveUp(1);
    goDown:
      { смещение вниз на одну колонку }
      Result := DoMoveDown(1);
    goPageUp:
      { смещение на страницу вверх }
      Result := DoMoveUp(VisSize.Row - 1);
    goPageDown:
      { смещение на страницу вниз }
      Result := DoMoveDown(VisSize.Row - 1);
    goHome:
      { в начало таблицы }
      Result := DoMoveHome;
    goEnd:
      { в конец таблицы }
      Result := DoMoveEnd;
    goSelect:
      { проверка ячейки }
      Result := DoSelect;
    goFirst:
      { выбрать первую возможную ячейку }
      Result := DoFirst;
    else
      { остальное игнорируем }
      Result := Cell;
  end;
end;

procedure TCustomGridView.GetEditList(Cell: TGridCell; Items: TStrings);
begin
  if Assigned(FOnGetEditList) then FOnGetEditList(Self, Cell, Items);
end;

procedure TCustomGridView.GetEditListBounds(Cell: TGridCell; var Rect: TRect);
begin
  if Assigned(FOnGetEditListBounds) then FOnGetEditListBounds(Self, Cell, Rect);
end;

function TCustomGridView.GetEditRect(Cell: TGridCell): TRect;
var
  L: Integer;
begin
  Result := GetCellRect(Cell);
  { место под картинку }
  if IsCellHasImage(Cell) then
  begin
    { сдвигаем результат на ширину картинок + 2 }
    Inc(Result.Left, Images.Width + 2);
    { проверяем правый край }
    L := GetColumnsWidth(0, Cell.Col);
    if Result.Left > L then Result.Left := L;
  end;
  { учитываем сетку }
  if GridLines then
  begin
    Dec(Result.Right, FGridLineWidth);
    Dec(Result.Bottom, FGridLineWidth);
  end;
end;

function TCustomGridView.GetEditStyle(Cell: TGridCell): TGridEditStyle;
begin
  Result := geSimple;
  if Assigned(FOnGetEditStyle) then FOnGetEditStyle(Self, Cell, Result);
end;

function TCustomGridView.GetEditText(Cell: TGridCell): string;
begin
  Result := GetCellText(Cell);
  if Assigned(FOnGetEditText) then FOnGetEditText(Self, Cell, Result);
end;

procedure TCustomGridView.GetHeaderColors(Section: TGridHeaderSection; Canvas: TCanvas);
begin
  { стандартные цвета }
  Canvas.Brush.Color := Header.Color;
  Canvas.Font := Header.Font;
  { событие пользователя }
  if Assigned(FOnGetHeaderColors) then FOnGetHeaderColors(Self, Section, Canvas);
end;

function TCustomGridView.GetTipsRect(Cell: TGridCell; MaxWidth: Integer): TRect;
var
  T: string;
  Rect, R: TRect;
  P: TDrawTextParams;
  F, W, H, B, X, Y: Integer;
begin
  { получаем текст ячейки }
  T := GetCellText(Cell);
  { получаем прямоугольник текста }
  Rect := GetEditRect(Cell);                                                 
  { выводим текст }
  if Columns[Cell.Col].MultiLine or EndEllipsis then
  begin
    { параметры вывода текста }
    FillChar(P, SizeOf(P), 0);
    P.cbSize := SizeOf(P);
    P.iLeftMargin := GetCellBorder(Cell);
    P.iRightMargin := 6;
    { атрибуты текста }
    F := DT_NOPREFIX;
    { горизонтальное выравнивание }
    case Columns[Cell.Col].Alignment of
      taLeftJustify: F := F or DT_LEFT;
      taCenter: F := F or DT_CENTER;
      taRightJustify: F := F or DT_RIGHT;
    end;
    { вертикальное выравнивание }
    if not Columns[Cell.Col].MultiLine then
    begin
      { автоматическое выравнивание }
      F := F or DT_SINGLELINE or DT_VCENTER;
      { троеточие на конце не учитываем }
    end;
    { прямоугольник текста }
    R := Rect;
    { создаем окно подсказки }
    with GetTipsWindow.Create(Self) do
    try
      GetCellColors(Cell, Canvas);
      DrawTextEx(Canvas.Handle, PChar(T), Length(T), R, F or DT_CALCRECT, @P)
    finally
      Free;
    end;
    { размеры текста }
    W := MaxIntValue([Rect.Right - Rect.Left, R.Right - R.Left]);
    H := MaxIntValue([Rect.Bottom - Rect.Top, R.Bottom - R.Top]);
    { смещение текста при выравнивании по центру }
    X := W - (Rect.Right - Rect.Left);
    X := (X div 2 + (X mod 2));
    { смещение по вертикали }
    Y := 0;
    if not Columns[Cell.Col].Multiline then
    begin
      Y := H - (Rect.Bottom - Rect.Top);
      Y := Y div 2;
    end;
  end
  else
  begin
    { бордюр }
    B := GetCellBorder(Cell);
    { высота и ширина текста }
    with GetTipsWindow.Create(Self) do
    try
      { учитываем шрифт }
      GetCellColors(Cell, Canvas);
      { размеры текста }
      W := MaxIntValue([Rect.Right - Rect.Left, B + Canvas.TextWidth(T) + 6]);
      H := MaxIntValue([Rect.Bottom - Rect.Top, Canvas.TextHeight(T)]);
      { смещение текста при выравнивании по центру }
      X := W - (Rect.Right - Rect.Left);
      X := X div 2;
      { смещение по вертикали }
      Y := H - (Rect.Bottom - Rect.Top);
      Y := Y div 2;
    finally
      Free;
    end;
  end;
  { формируем прямоугольник }
  case Columns[Cell.Col].Alignment of
    taCenter:
      begin
        R.Left := Rect.Left - X;
        R.Right := R.Left + W;
      end;
    taRightJustify:
      begin
        R.Right := Rect.Right;
        R.Left := R.Right - W;
      end;
    else
      begin
        R.Left := Rect.Left;
        R.Right := R.Left + W;
      end;
  end;
  R.Top := Rect.Top - Y;
  R.Bottom := R.Top + H;
  { учитываем бордюр }
  InflateRect(R, 1, 1);
  { результат }
  Result := R;
end;

function TCustomGridView.GetTipsWindow: TGridTipsWindowClass;
begin
  Result := TGridTipsWindow;
end;

procedure TCustomGridView.HideCursor;
begin
  if IsFocusAllowed then
  begin
    InvalidateFocus;
    Exit;
  end;
  HideEdit;
end;

procedure TCustomGridView.HideEdit;
begin
  if FEdit <> nil then
  begin
    FEditCell := GridCell(-1, -1);
    FEdit.Hide;
  end;
end;

procedure TCustomGridView.HideFocus;
begin
  if IsFocusAllowed then PaintFocus;
end;

procedure TCustomGridView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LEFT: SetCursor(GetCursorCell(CellFocused, goLeft), True, True);
    VK_RIGHT: SetCursor(GetCursorCell(CellFocused, goRight), True, True);
    VK_UP: SetCursor(GetCursorCell(CellFocused, goUp), True, True);
    VK_DOWN: SetCursor(GetCursorCell(CellFocused, goDown), True, True);
    VK_PRIOR: SetCursor(GetCursorCell(CellFocused, goPageUp), True, True);
    VK_NEXT: SetCursor(GetCursorCell(CellFocused, goPageDown), True, True);
    VK_HOME: SetCursor(GetCursorCell(CellFocused, goHome), True, True);
    VK_END: SetCursor(GetCursorCell(CellFocused, goEnd), True, True);
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TCustomGridView.KeyPress(var Key: Char);
begin
  { обработка по умолчанию }
  inherited KeyPress(Key);
  { нажат ENTER - показываем строку ввода, если можно }
  if Key = #13 then
  begin
    Key := #0;
    { идет ли редактирование }
    if Editing then
    begin
      { вставляем текст }
      UpdateEditText;
      { гасим строку }
      if not AlwaysEdit then HideEdit;
    end
    else
      { показываем строку ввода }
      if not AlwaysEdit then ShowEdit;
  end;
  { нажат ESC - закрываем строку ввода }
  if Key = #27 then
  begin
    Key := #0;
    { гасим строку }
    if Editing and (not AlwaysEdit) then HideEdit;
  end;
end;

procedure TCustomGridView.Loaded;
begin
  inherited Loaded;
  { подправляем параметры }
  UpdateHeader;
  UpdateColors;
  UpdateFonts;
  UpdateEdit(False);
  { ищем пурвую ячейку фокуса }
  CellFocused := GetCursorCell(CellFocused, goFirst);
end;

procedure TCustomGridView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  S: TGridHeaderSection;
  I, W: Integer;
  C: TGridCell;
begin
  { устанавливаем фокус на себя }
  if not AcquireFocus then
  begin
    MouseCapture := False;
    Exit;
  end;
  { проверяем новую выделенную ячейку }
  if (Button = mbLeft) or ((Button = mbRight) and RightClickSelect) then
    { если мышка в ячейке }
    if PtInRect(GetGridRect, Point(X, Y)) then
    begin
      C := GetCellAt(X, Y);
      { не попали на в какую в ячейку }
      if IsCellEmpty(C) then
      begin
        { гасим выделение курсора }
        SetCursor(CellFocused, False, False);
      end
      { попадание в каую-то }
      else
      begin
        { выделяем ячейку }
        SetCursor(C, True, True);
        CellClick(C, Shift, X, Y);
        { если попали в текущую - проверяем начало редактирования }
        if (Shift = [ssLeft, ssDouble]) and IsCellEqual(C, CellFocused) and AllowEdit then
        begin
          ShowEdit;
          if Editing then Exit;
        end;
      end;
    end;
  { левая клавиша }
  if Button = mbLeft then
  begin
    { попытка начать изменения размера колонки }
    if PtInRect(GetHeaderRect, FHitTest) then
    begin
      if ShowHeader then
      begin
        { попали ли мышкой на край секции заголовка }
        S := GetResizeSection(X, Y);
        if S <> nil then
        begin
          if ssDouble In Shift then
          begin
            { устанавливаем ширину колонки равной максимальной ширине текста }
            I := S.Column;
            if I < Columns.Count then
            begin
              W := GetColumnMaxWidth(I);
              ColumnResize(I, W);
              Columns[I].Width := W;
            end;
          end
          else
            { начинаем изменение размера }
            StartColResize(S, X, Y);
          { не пускаем дальше }
          Exit;
        end;
      end;
    end;
  end;
  { правая клавиша }
  if Button = mbRight then
    { если идет изменение размера - прекратить }
    if FColResizing then
    begin
      { прекращаем изменение }
      StopColResize(True);
      { не пускаем дальше }
      Exit;
    end;
  { обработчик по умолчанию }
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TCustomGridView.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  { если идет изменение размера - продолжаем }
  if FColResizing then
  begin
    { продолжаем изменение размера колонки }
    StepColResize(X, Y);
    { не пускаем дальше }
    Exit;
  end;
  { обработчик по умолчанию }
  inherited MouseMove(Shift, X, Y);
end;

procedure TCustomGridView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { если идет изменение размера - заканчиваем }
  if FColResizing then
  begin
    { заканчиваем изменение размера колонки }
    StopColResize(False);
    { не пускаем дальше }
    Exit;
  end;
  { обработчик по умолчанию }
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TCustomGridView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FImages) then Images := nil;
end;

procedure TCustomGridView.Paint;
begin
  { заголовок }
  if ShowHeader and RectVisible(Canvas.Handle, GetHeaderRect) then
  begin
    { фиксированная часть }
    PaintHeaders(True);
    { отсекаем прямоугольник фиксированного заголовка }
    with GetHeaderRect do
      ExcludeClipRect(Canvas.Handle, 0, Top, GetFixedWidth, Bottom);
    { обычная часть }
    PaintHeaders(False);
    { отсекаем прямоугольник заголовка }
    with GetHeaderRect do
      ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
  end;
  { поле справа и снизу }
  PaintFreeField;
  { фиксированные ячейки }
  if (Fixed.Count > 0) and RectVisible(Canvas.Handle, GetFixedRect) then
  begin
    { ячейки }
    PaintFixed;
    { отсекаем прямоугольник фиксированных }
    with GetFixedRect do
      ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
  end;
  { обычные ячейки }
  if (VisSize.Col > 0) and (VisSize.Row > 0) then
  begin
    { сетка }
    if GridLines then PaintGridLines;
    { ячейки }
    PaintCells;
    { прямоугольник фокуса }
    if IsFocusAllowed then
    begin
      PaintFocus;
    end;
  end;
  { линия изменения ширины столбца }
  if FColResizing and (FColResizeCount > 0) then PaintResizeLine;
end;

function GetRGBColor(Value: TColor): DWORD;
begin
  Result := ColorToRGB(Value);
  case Result of
    clNone: Result := CLR_NONE;
    clDefault: Result := CLR_DEFAULT;
  end;
end;

procedure TCustomGridView.PaintCell(Cell: TGridCell; Rect: TRect);
const
  DS: array[Boolean] of Longint = (ILD_NORMAL, ILD_SELECTED);
var
  DefDraw: Boolean;
  I, X, Y: Integer;
  IW, IH: Integer;
  IDS: Longint;
  BKC, BLC: DWORD;
  R: TRect;
  C: TColor;
  H: Boolean;
begin
  { устанавливаем цвета и шрифт ячейки }
  GetCellColors(Cell, Canvas);
  { смещаем края чтобы не залить линии сетки }
  if GridLines then
  begin
    Dec(Rect.Right, FGridLineWidth);
    Dec(Rect.Bottom, FGridLineWidth);
  end;
  { отрисовка пользователя }
  DefDraw := True;
  try
    if Assigned(FOnDrawCell) then FOnDrawCell(Self, Cell, Rect, DefDraw);
  except
    Application.HandleException(Self);
  end;
  { отрисовка по умолчанию }
  if DefDraw then
  begin
    { получаем номер картинки }
    I := -1;
    if Assigned(Images) then I := GetCellImage(Cell);
    { рисуем картинку }
    if I <> -1 then
    begin
      { получаем прямоугольник картинки }
      R.Left := Rect.Left;
      R.Top := Rect.Top;
      R.Right := R.Left + (Images.Width + 2);
      R.Bottom := Rect.Bottom;
      { проверяем его }
      if R.Right > Rect.Right then R.Right := Rect.Right;
      { рисуем }
      with Canvas do
      begin
        { получаем признак первой выделенной ячейки }
        H := (RowSelect and (Cell.Col = Fixed.Count) and (Cell.Row = CellFocused.Row)) or (not RowSelect and IsCellEqual(Cell, CellFocused));
        { запоминаем цвет фона ячейки }
        C := Brush.Color;
        { устанавливаем цвет фона картинки }
        if H then Brush.Color := Color;
        { заливаем фон }
        FillRect(R);
        { положение картинки }
        X := R.Right - Images.Width;
        if X < R.Left + 2 then X := R.Left + 2;
        Y := R.Top;
        { размер картинки (необходимо для отсечения картинок узких колонок) }
        IW := Images.Width;
        if X + IW > R.Right then IW := R.Right - X;
        IH := Images.Height;
        if Y + IH > R.Bottom then IH := R.Bottom - Y;
        { стиль и фоновые цвета картинки }
        IDS := DS[IsCellFocused(Cell) and CellSelected and Focused and H];
        BKC := GetRGBColor(Images.BkColor);
        BLC := GetRGBColor(Images.BlendColor);
        { рисуем картинку }
        ImageList_DrawEx(Images.Handle, I, Canvas.Handle, X, Y, IW, IH, BKC, BLC, IDS);
        { восстанавливаем цвет фона ячейки }
        Brush.Color := C;
      end;
    end;
    { признак видимости строки ввода }
    if not (IsCellEqual(Cell, FEditCell) and (not IsFocusAllowed)) then
    begin
      { получаем прямоугольник текста }
      R := Rect;
      { учитываем картинку }
      if I <> -1 then Inc(R.Left, Images.Width + 2);
      if R.Left > R.Right then R.Left := R.Right;
      { рисуем текст }
      with Canvas do
      begin
        { заливаем поле под текстом }
        FillRect(R);
        { выводим текст }
        PaintCellText(Cell, R, Canvas);
      end;
    end;
    { полоски фиксированных ячеек }
    if Cell.Col < Fixed.Count then
    begin
      { восстанавливаем края прямоугольника, учитывающие сетку }
      if GridLines then
      begin
        Inc(Rect.Right, FGridLineWidth);
        Inc(Rect.Bottom, FGridLineWidth);
      end;
      { полоска снизу только, если есть сетка }
      if GridLines then
        with Canvas do
        begin
          Pen.Color := clBtnShadow;
          MoveTo(Rect.Left, Rect.Bottom - 2);
          LineTo(Rect.Right, Rect.Bottom - 2);
          Pen.Color := clBtnHighlight;
          MoveTo(Rect.Left, Rect.Bottom - 1);
          LineTo(Rect.Right, Rect.Bottom - 1);
        end;
      { полоска справа только, если есть сетка или последняя колонка }
      if GridLines or (Cell.Col = Fixed.Count - 1) then
      begin
        { смещение для полоски справа }
        I := Ord(Cell.Col < Fixed.Count - 1);
        { полоска справа }
        with Canvas do
        begin
          Pen.Color := clBtnShadow;
          MoveTo(Rect.Right - 2, Rect.Top);
          LineTo(Rect.Right - 2, Rect.Bottom - I);
          Pen.Color := clBtnHighlight;
          MoveTo(Rect.Right - 1, Rect.Top);
          LineTo(Rect.Right - 1, Rect.Bottom - I);
        end;
      end;
    end;
  end;
end;

procedure TCustomGridView.PaintCells;
var
  I, J: Integer;
  L, T, W: Integer;
  R: TRect;
  C: TGridCell;
begin
  { левая и верхняя краницы видимых ячеек }
  L := GetColumnsWidth(0, VisOrigin.Col - 1) + GetGridOrigin.X;
  T := GetRowsHeight(0, VisOrigin.Row - 1) + GetGridOrigin.Y;
  { инициализируем верхнюю границу }
  R.Bottom := T;
  { перебираем строки }
  for J := 0 to FVisSize.Row - 1 do
  begin
    { смещаем прямоугольник по вертикали }
    R.Top := R.Bottom;
    R.Bottom := R.Bottom + Rows.Height;
    { инициализируем левую границу }
    R.Right := L;
    { пребираем колонки }
    for I := 0 to FVisSize.Col - 1 do
    begin
      { ячейка и ее ширина }
      C := GridCell(VisOrigin.Col + I, VisOrigin.Row + J);
      W := Columns[C.Col].Width;
      { римуем только видимые ячейки }
      if W > 0 then
      begin
        { смещаем прямоугольник по горизонтали }
        R.Left := R.Right;
        R.Right := R.Right + W;
        { рисуем ячейку }
        if RectVisible(Canvas.Handle, R) then PaintCell(C, R);
      end;
    end;
  end;
end;

procedure TCustomGridView.PaintCellText(Cell: TGridCell; Rect: TRect; Canvas: TCanvas);
var
  T: string;
  P: TDrawTextParams;
  F, X, Y, A: Integer;
begin
  { получаем текст ячейки }
  T := GetCellText(Cell);
  { выводим текст }
  if Columns[Cell.Col].MultiLine or EndEllipsis then
  begin
    { параметры вывода текста }
    FillChar(P, SizeOf(P), 0);
    P.cbSize := SizeOf(P);
    P.iLeftMargin := GetCellBorder(Cell);
    P.iRightMargin := 6;
    { атрибуты текста }
    F := DT_NOPREFIX;
    { горизонтальное выравнивание }
    case Columns[Cell.Col].Alignment of
      taLeftJustify: F := F or DT_LEFT;
      taCenter: F := F or DT_CENTER;
      taRightJustify: F := F or DT_RIGHT;
    end;
    { вертикальное выравнивание }
    if not Columns[Cell.Col].MultiLine then
    begin
      { автоматическое выравнивание }
      F := F or DT_SINGLELINE or DT_VCENTER;
      { троеточие на конце }
      if Columns[Cell.Col].Alignment = taLeftJustify then F := F or DT_END_ELLIPSIS
    end;
    { выводим текст }
    DrawTextEx(Canvas.Handle, PChar(T), Length(T), Rect, F, @P);
  end
  else
  begin
    { смещение по горизонтали }
    case Columns[Cell.Col].Alignment of
      taCenter:
        begin
          X := GetCellBorder(Cell) + (Rect.Right - Rect.Left) div 2;
          A := TA_CENTER;
        end;
      taRightJustify:
        begin
          X := (Rect.Right - Rect.Left) - 6;
          A := TA_RIGHT;
        end;
      else
        begin
          X := GetCellBorder(Cell);
          A := TA_LEFT;
        end;
    end;
    { смещение по вертикали }
    Y := ((Rect.Bottom - Rect.Top) - Abs(Canvas.TextHeight(T))) div 2;
    { стандартный вывод текста }
    with Canvas do
    begin
      SetTextAlign(Handle, A);
      TextRect(Rect, Rect.Left + X, Rect.Top + Y, T);
      SetTextAlign(Handle, TA_LEFT);
    end;
  end;
end;

procedure TCustomGridView.PaintFixed;
var
  I, J, W: Integer;
  R: TRect;
  C: TGridCell;
begin
  { фиксированные ячейки }
  R.Bottom := GetRowsHeight(0, VisOrigin.Row - 1) + GetGridOrigin.Y;
  for J := 0 to FVisSize.Row - 1 do
  begin
    R.Top := R.Bottom;
    R.Bottom := R.Bottom + Rows.Height;
    R.Right := 0;
    for I := 0 to Fixed.Count - 1 do
    begin
      C := GridCell(I, VisOrigin.Row + J);
      W := Columns[C.Col].Width;
      if W > 0 then
      begin
        R.Left := R.Right;
        R.Right := R.Right + W;
        if RectVisible(Canvas.Handle, R) then PaintCell(C, R);
      end;
    end;
  end;
  { полоска справа }
  R.Left := 0;
  R.Right := GetColumnsWidth(0, Fixed.Count - 1);
  R.Top := GetRowsHeight(0, VisOrigin.Row + FVisSize.Row - 1) + GetGridOrigin.Y;
  R.Bottom := GetGridRect.Bottom;
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    MoveTo(R.Right - 2, R.Top - 1);
    LineTo(R.Right - 2, R.Bottom);
    Pen.Color := clBtnHighlight;
    MoveTo(R.Right - 1, R.Bottom - 1);
    LineTo(R.Right - 1, R.Top - 1);
  end;
  { линия изменения ширины колонки }
  if FColResizing and (FColResizeCount > 0) then PaintResizeLine;
end;

procedure TCustomGridView.PaintFocus;
var
  R: TRect;
begin
  { а видим ли фокус }
  if ShowFocusRect and Focused and (VisSize.Row > 0) then
  begin
    { прямоугольник фокуса }
    R := GetFocusRect;
    { учитываем сетку }
    if GridLines then
    begin
      Dec(R.Right, FGridLineWidth);
      Dec(R.Bottom, FGridLineWidth);
    end;
    { цвета }
    GetCellColors(CellFocused, Canvas);
    { рисуем }
    with Canvas do
    begin
      { отсекаем место под заголовок и фиксированные }
      with GetHeaderRect do ExcludeClipRect(Handle, Left, Top, Right, Bottom);
      with GetFixedRect do ExcludeClipRect(Handle, Left, Top, Right, Bottom);
      { фокус }
      DrawFocusRect(R);
    end;
  end;
end;

procedure TCustomGridView.PaintFreeField;
var
  X, Y: Integer;
  R: TRect;
begin
  { поле справа }
  if VisSize.Col = 0 then
    X := GetColumnRect(VisOrigin.Col).Left
  else
    X := GetColumnRect(VisOrigin.Col + VisSize.Col - 1).Right;
  { видно ли его }
  if X < ClientWidth then
  begin
    R := GetGridRect;
    R.Left := X;
    R.Right := ClientWidth;
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(R);
    end;
  end;
  { поле снизу }
  if VisSize.Row = 0 then
    Y := GetRowRect(VisOrigin.Row).Top
  else
    Y := GetRowRect(VisOrigin.Row + VisSize.Row - 1).Bottom;
  { видно ли его }
  if Y < ClientHeight then
  begin
    { под фиксированными }
    R := GetGridRect;
    R.Right := GetFixedWidth;
    R.Top := Y;
    R.Bottom := ClientHeight;
    with Canvas do
    begin
      Brush.Color := Fixed.Color;
      FillRect(R);
    end;
    { под ячейками }
    R := GetGridRect;
    R.Left := GetFixedWidth;
    R.Top := Y;
    R.Bottom := ClientHeight;
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(R);
    end;
  end;
end;

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxListSize - 1] of Integer;

procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI
end;

procedure TCustomGridView.PaintGridLines;
const
  LineColors: array[Boolean] of TColor = (clSilver, clGray);
var
  PointsList: PIntArray;
  PointCount: Integer;
  StrokeList: PIntArray;
  StrokeCount: Integer;
  I: Integer;
  L, R, T, B, X, Y: Integer;
  Index: Integer;
begin
  { опрелеяем количество точек сетки }
  StrokeCount := FVisSize.Col + FVisSize.Row;
  PointCount := StrokeCount * 2;
  { выделяем память под линии }
  StrokeList := AllocMem(StrokeCount * SizeOf(Integer));
  PointsList := AllocMem(PointCount * SizeOf(TPoint));
  { инициализация массива количества точек полилиний }
  FillDWord(StrokeList^, StrokeCount, 2);
  { точки вертикальных линий }
  T := GetGridRect.Top;
  B := GetRowsHeight(0, VisOrigin.Row + FVisSize.Row - 1) + GetGridOrigin.Y;
  X := GetColumnsWidth(0, VisOrigin.Col - 1) + GetGridOrigin.X;
  for I := 0 to FVisSize.Col - 1 do
  begin
    X := X + Columns[VisOrigin.Col + I].Width;
    Index := I * 4;
    PointsList^[Index + 0] := X - 1;
    PointsList^[Index + 1] := T;
    PointsList^[Index + 2] := X - 1;
    PointsList^[Index + 3] := B;
  end;
  { точки горизонтальных линий }
  L := GetGridRect.Left + GetFixedWidth;
  R := GetColumnsWidth(0, VisOrigin.Col + VisSize.Col - 1) + GetGridOrigin.X;
  Y := GetRowsHeight(0, VisOrigin.Row - 1) + GetGridOrigin.Y;
  for I := 0 to FVisSize.Row - 1 do
  begin
    Y := Y + Rows.Height;
    Index := FVisSize.Col * 4 + I * 4;
    PointsList^[Index + 0] := L;
    PointsList^[Index + 1] := Y - 1;
    PointsList^[Index + 2] := R;
    PointsList^[Index + 3] := Y - 1;
  end;
  { рисуем }
  with Canvas do
  begin
    Pen.Color := LineColors[ColorToRGB(Color) = clSilver];
    Pen.Width := FGridLineWidth;
    PolyPolyLine(Handle, PointsList^, StrokeList^, StrokeCount);
  end;
  { освобождаем память }
  FreeMem(PointsList);
  FreeMem(StrokeList);
end;

procedure TCustomGridView.PaintHeader(Section: TGridHeaderSection; Rect: TRect);
var
  DefDraw: Boolean;
  F: Integer;
  P: TDrawTextParams;
  T: string;
  R: TRect;
begin
  { устанавливаем цвет и шрифт секции }
  GetHeaderColors(Section, Canvas);
  { отрисовка пользователя }
  DefDraw := True;
  try
    if Assigned(FOnDrawHeader) then FOnDrawHeader(Self, Section, Rect, DefDraw);
  except
    Application.HandleException(Self);
  end;
  { отрисовка по умолчанию }
  if DefDraw then
  begin
    { получаем текст заголовка }
    T := Section.Caption;
    { рисуем }
    with Canvas do
    begin
      { заливка }
      FillRect(Rect);
      { параметры вывода текста }
      FillChar(P, SizeOf(P), 0);
      P.cbSize := SizeOf(P);
      P.iLeftMargin := 6;
      P.iRightMargin := 6;
      { выравнивание }
      F := DT_END_ELLIPSIS or DT_NOPREFIX;
      case Section.Alignment of
        taLeftJustify: F := F or DT_LEFT;
        taRightJustify: F := F or DT_RIGHT;
        taCenter: F := F or DT_CENTER;
      end;
      case Section.WordWrap of
        False: F := F or 0;
        True: F := F or DT_WORDBREAK;
      end;
      { получаем прямоугольник теста }
      R := Rect;
      DrawTextEx(Handle, PChar(T), Length(T), R, F or DT_CALCRECT, @P);
      OffsetRect(R, 0, ((Rect.Bottom - Rect.Top) - (R.Bottom - R.Top)) div 2);
      R.Left := Rect.Left;
      R.Right := Rect.Right;
      { выводим текст }
      DrawTextEx(Handle, PChar(T), Length(T), R, F, @P);
      { полоска снизу }
      Pen.Color := clBtnShadow;
      MoveTo(Rect.Left, Rect.Bottom - 2);
      LineTo(Rect.Right - 1, Rect.Bottom - 2);
      Pen.Color := clBtnHighlight;
      MoveTo(Rect.Left, Rect.Bottom - 1);
      LineTo(Rect.Right - 2, Rect.Bottom - 1);
      { полоска справа }
      Pen.Color := clBtnShadow;
      MoveTo(Rect.Right - 2, Rect.Top - 2);
      LineTo(Rect.Right - 2, Rect.Bottom - 1);
      Pen.Color := clBtnHighlight;
      MoveTo(Rect.Right - 1, Rect.Top - 1);
      LineTo(Rect.Right - 1, Rect.Bottom - 1);
    end;
  end;
end;

procedure TCustomGridView.PaintHeaders(DrawFixed: Boolean);
var
  R: TRect;
begin
  { подзаголовки }
  if DrawFixed then
  begin
    R.Left := 0;
    R.Right := Header.Width;
  end
  else
  begin
    R.Left := GetGridOrigin.X;
    R.Right := R.Left + Header.Width;
  end;
  R.Top := 0;
  R.Bottom := Header.Height + 1;
  PaintHeaderSections(Header.Sections, DrawFixed, R);
  { оставшееся место }
  if DrawFixed then
  begin
    R.Left := Header.Width;
    R.Right := GetFixedWidth
  end
  else
  begin
    R.Left := GetGridOrigin.X + Header.Width;
    R.Right := Width;
  end;
  with Canvas do
  begin
    Brush.Color := Header.Color;
    FillRect(R);
  end;
  { серая полоска снизу }
  if DrawFixed then
  begin
    R.Left := 0;
    R.Right := GetFixedWidth;
  end
  else
  begin
    R.Left := GetFixedWidth;
    R.Right := Width;
  end;
  R.Top := 0;
  R.Bottom := Header.Height;
  with Canvas do
  begin
    Pen.Color := clBtnShadow;
    MoveTo(R.Left, R.Bottom - 1);
    LineTo(R.Right, R.Bottom - 1);
    Pen.Color := clBtnHighlight;
    MoveTo(R.Left, R.Bottom);
    LineTo(R.Right, R.Bottom);
  end;
  { линия изменения ширины колонки }
  if FColResizing and (FColResizeCount > 0) then PaintResizeLine;
end;

procedure TCustomGridView.PaintHeaderSections(Sections: TGridHeaderSections; AllowFixed: Boolean; Rect: TRect);
var
  I: Integer;
  S: TGridHeaderSection;
  R, SR: TRect;
begin
  { пустое место, если нет подзаголовков }
  if Sections.Count = 0 then Exit;
  { рисуем подзаголовки, если надо }
  if RectVisible(Canvas.Handle, Rect) then
  begin
    R := Rect;
    R.Right := R.Left;
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      { нефиксированный заголовок не рисуем }
      if AllowFixed and not S.FixedSize then Exit;
      R.Left := R.Right;
      R.Right := R.Left + S.Width;
      { пустой заголовок не рисуем }
      if R.Right > R.Left then
      begin
        { прямоугольник }
        SR := R;
        if S.Sections.Count > 0 then
          SR.Bottom := R.Top + Header.SectionHeight;
        { заголовок (секция) }
        PaintHeader(S, SR);
        { подзаголовки }
        if S.Sections.Count > 0 then
        begin
          { вычитаем строку сверху }
          SR.Top := R.Top + Header.SectionHeight;
          SR.Bottom := R.Bottom;
          { подзаголовки снизу }
          PaintHeaderSections(S.Sections, AllowFixed, SR);
        end;
      end;
    end;
  end;
end;

procedure TCustomGridView.PaintResizeLine;
var
  OldPen: TPen;
begin
  OldPen := TPen.Create;
  try
    with Canvas do
    begin
      OldPen.Assign(Pen);
      try
        Pen.Style := psSolid;
        Pen.Mode := pmXor;
        Pen.Width := 1;
        with FColResizeRect do
        begin
          MoveTo(FColResizePos, Top);
          LineTo(FColResizePos, Bottom);
        end;
      finally
        Pen := OldPen;
      end;
    end;
  finally
    OldPen.Free;
  end;
end;

procedure TCustomGridView.Resize;
begin
  if Assigned(FOnResize) then FOnResize(Self);
end;

procedure TCustomGridView.SetEditText(Cell: TGridCell; var Value: string);
begin
  if Assigned(FOnSetEditText) then FOnSetEditText(Self, Cell, Value);
end;

procedure TCustomGridView.SetCursor(Cell: TGridCell; Selected, Visible: Boolean);
begin
  { проверяем выделение }
  UpdateSelection(Cell, Selected);
  { изменилось ли что нибудь }
  if (not IsCellEqual(FCellFocused, Cell)) or (FCellSelected <> Selected) then
  begin
    { ячейка меняется }
    Changing(Cell, Selected);
    { устанавливаем активную ячейку }
    if not IsCellEqual(FCellFocused, Cell) then
    begin
      { если изменяется ячейка - проверяем текст }
      UpdateEditText;
      { меняем ячейку}
      HideCursor;
      FCellFocused := Cell;
      FCellSelected := Selected;
      if Visible then UpdateScrollPos;
      ShowCursor;
    end
    { устанавливаем выделение }
    else if FCellSelected <> Selected then
    begin
      HideCursor;
      FCellSelected := Selected;
      ShowCursor;
    end;
    { ячейка сменилась }
    Change(FCellFocused, FCellSelected);
  end;
end;

procedure TCustomGridView.ShowCursor;
begin
  if IsFocusAllowed then
  begin
    InvalidateFocus;
    Exit;
  end;
  ShowEdit;
end;

procedure TCustomGridView.ShowEdit;
begin
  UpdateEdit(True);
end;

procedure TCustomGridView.ShowEditChar(C: Char);
begin
  { показываем строку ввода }
  ShowEdit;
  { вставляем символ }
  if (Edit <> nil) and Editing then PostMessage(Edit.Handle, WM_CHAR, Word(C), 0);
end;

procedure TCustomGridView.ShowFocus;
begin
  if IsFocusAllowed then PaintFocus;
end;

procedure TCustomGridView.StartColResize(Section: TGridHeaderSection; X, Y: Integer);
var
  I: Integer;
begin
  FColResizeSection := Section;
  { вычисляем граничный прямоугольник для изменения размера }
  with FColResizeSection do
  begin
    I := Column;
    if I <= Columns.Count - 1 then
    begin
      FColResizeRect := GetColumnRect(I);
      FColResizeRect.Left := FColResizeRect.Left{ + Columns[I].MinWidth};
    end
    else
      FColResizeRect := Bounds;
    if Section <> nil then
      FColResizeRect.Top := Level * Header.SectionHeight
    else
      FColResizeRect.Top := 0;
    FColResizeRect.Bottom := Height;
  end;
  { положение линии размера }
  FColResizePos := FColResizeRect.Right;
  FColResizeOffset := FColResizePos - X;
  { можно изменять размер колонки }
  FColResizeCount := 0;
  FColResizing := True;
  { захватываем мышку }
  MouseCapture := True;
end;

procedure TCustomGridView.StepColResize(X, Y: Integer);
var
  W: Integer;
begin
  { а едет ли изменение размера колонки }
  if FColResizing then
  begin
    { новое положение линии }
    X := X + FColResizeOffset;
    if X < FColResizeRect.Left then X := FColResizeRect.Left;
    { новая ширина }
    W := X - FColResizeRect.Left;
    Columnresizing(FColResizeSection.Column, W);
    X := FColResizeRect.Left + W;
    { проводим линию }
    if FColResizePos <> X then
    begin
      { закрашиваем старую линию }
      if FColResizeCount > 0 then PaintResizeLine;
      Inc(FColResizeCount);
      { новое положение линии }
      FColResizePos := X;
      { рисуем новую линию }
      PaintResizeLine;
    end
    else
    begin
      { рисуем линию первый раз }
      if FColResizeCount = 0 then PaintResizeLine;
      Inc(FColResizeCount);
    end;
  end;
end;

procedure TCustomGridView.StopColResize(Abort: Boolean);
var
  I, W: Integer;
begin
  if FColResizing then
  begin
    { освобождаем мышку }
    MouseCapture := False;
    { изменение размера закончено }
    FColResizing := False;
    { было ли хотябы одно перемещение }
    if FColResizeCount > 0 then
    begin
      { закрашиваем линию }
      PaintResizeLine;
      { устанавливаем размер колонки }
      if not Abort then
        with FColResizeSection do
        begin
          { новая ширина }
          I := Column;
          W := FColResizePos - FColResizeRect.Left;
          ColumnResize(I, W);
          { устанавливаем ширину }
          if I < Columns.Count then Columns[I].Width := W;
          Width := W;
        end;
    end;
  end;
end;

procedure TCustomGridView.UpdateCursor;
begin
  if not IsCellAcceptCursor(CellFocused) then
    SetCursor(GetCursorCell(CellFocused, goFirst), FCellSelected, True);
end;

procedure TCustomGridView.UpdateColors;
begin
  Header.GridColorChanged(Color);
  Fixed.GridColorChanged(Color);
end;

procedure TCustomGridView.UpdateEdit(Activate: Boolean);

  procedure DoUpdateEdit;
  begin
    FEditCell := FCellFocused;
    FEdit.UpdateStyle;
    FEdit.UpdateContents;
    FEdit.SelectAll;
  end;

begin
  { а разрешена ли строка ввода }
  if EditCanShow then
  begin
    { создаем строку ввода, если ее нет }
    if FEdit = nil then
    begin
      FEdit := CreateEdit;
      FEdit.Parent := Self;
      FEdit.FGrid := Self;
      { устанавливаем параметры }
      DoUpdateEdit;
    end
    else if not IsCellEqual(FEditCell, FCellFocused) then
    begin
      Activate := Activate or Editing;
      HideEdit;
      DoUpdateEdit;
    end;
    { показываем строку }
    if Activate then FEdit.Show;
  end
  else
    { гасим строку }
    HideEdit;
end;

procedure TCustomGridView.UpdateFocus;
begin                                                                              
  if not ((csDesigning in ComponentState) or IsActiveControl) then
    { а можно ли устанавливать фокус }
    if TabStop and (CanFocus or (GetParentForm(Self) = nil)) then
    begin
      SetFocus;
      if AlwaysEdit and (Edit <> nil) then UpdateEdit(True);
    end;
end;

procedure TCustomGridView.UpdateFonts;
begin
  Header.GridFontChanged(Font);
  Fixed.GridFontChanged(Font);
end;

procedure TCustomGridView.UpdateHeader;
begin
  with Header do
    if AutoSynchronize or Synchronized then Sections.Synchronize(Columns);
end;

procedure TCustomGridView.UpdateScrollBars;
var
  R, P, L: Integer;
begin
  { параметры вертикального скроллера }
  with GetGridRect do
  begin
    R := Rows.Count - 1;
    P := (Bottom - Top) div Rows.Height - 1;
    L := 1;
    with VertScrollBar do
    begin
      SetLineSize(Rows.Height);
      SetParams(R, P, L);
    end;
  end;
  { параметры горизонтального скроллера }
  with GetGridRect do
  begin
    R := GetColumnsWidth(0, Columns.Count - 1) - GetFixedWidth;
    P := (Right - Left) - GetFixedWidth;
    L := 8;
    with HorzScrollBar do
    begin
      SetLineSize(1);
      SetParams(R, P, L);
    end;
  end;
end;

procedure TCustomGridView.UpdateScrollPos;
var
  DX, DY, X, Y: Integer;
  R: TRect;
begin
  DX := 0;
  DY := 0;
  with GetGridRect do
  begin
    { смещение по горизонтали }
    if not RowSelect then
    begin
      R := GetColumnRect(CellFocused.Col);
      X := Left + GetFixedWidth;
      if R.Right > Right then DX := Right - R.Right;
      if R.Left < X then DX := X - R.Left;
      if R.Right - R.Left > Right - X then DX := X - R.Left;
    end;
    { смещение по вертикали }
    R := GetRowRect(CellFocused.Row);
    if R.Bottom > Bottom then DY := Bottom - R.Bottom;
    if R.Top < Top then DY := Top - R.Top;
    if R.Bottom - R.Top > Bottom - Top then DY := Top - R.Top;
    Y := DY div Rows.Height;
    if (FVisSize.Row > 1) and (DY mod Rows.Height <> 0) then Dec(Y);
    DY := Y;
  end;
  { изменяем положение }
  with VertScrollBar do Position := Position - DY;
  with HorzScrollBar do Position := Position - DX;
end;

procedure TCustomGridView.UpdateScrollRange;
var
  I, X: Integer;
begin
  if Columns.Count > 0 then
  begin
    X := - HorzScrollBar.Position + GetFixedWidth;
    I := Fixed.Count;
    while I < Columns.Count - 1 do
    begin
      X := X + Columns[I].Width;
      if X >= GetGridRect.Left + GetFixedWidth then Break;
      Inc(I);
    end;
    FVisOrigin.Col := I;
    while I < Columns.Count - 1 do
    begin
      if X >= GetGridRect.Right then Break;
      Inc(I);
      X := X + Columns[I].Width;
    end;
    FVisSize.Col := I - FVisOrigin.Col + 1;
  end
  else
  begin
    FVisOrigin.Col := 0;
    FVisSize.Col := 0;
  end;
  if Rows.Count > 0 then
  begin
    FVisOrigin.Row := VertScrollBar.Position;
    FVisSize.Row := GetGridHeight div Rows.Height;
    if GetGridHeight mod Rows.Height > 0 then Inc(FVisSize.Row);
    if FVisSize.Row + FVisOrigin.Row  > Rows.Count then FVisSize.Row := Rows.Count - FVisOrigin.Row;
  end
  else
  begin
    FVisOrigin.Row := 0;
    FVisSize.Row := 0;
  end;
end;

procedure TCustomGridView.UpdateSelection(var Cell: TGridCell; var Selected: Boolean);
begin
  { Проверка флага выделения }
  Selected := Selected or FAlwaysSelected;
  Selected := Selected and (Rows.Count > 0) and (Columns.Count > 0);
  { проверка ячейки на границы }
  with Cell do
  begin
    if Col < Fixed.Count then Col := Fixed.Count;
    if Col < 0 then Col := 0;
    if Col > Columns.Count - 1 then Col := Columns.Count - 1;
    if Row < 0 then Row := 0;
    if Row > Rows.Count - 1 then Row := Rows.Count - 1;
  end;
  { проверяем фокус }
  Cell := GetCursorCell(Cell, goSelect);
end;

procedure TCustomGridView.UpdateEditText;
var
  Text: string;
begin
  if (Edit <> nil) and IsCellCorrect(EditCell) then
  try
    { проверяем текст троки ввода }
    Text := Edit.Text;
    try
      SetEditText(EditCell, Text);
    finally
      Edit.Text := Text;
    end;
  except
    { показываем ячейку с ошибкой }
    UpdateScrollPos;
    { ошибка }
    raise;
  end;
end;

procedure TCustomGridView.Invalidate;
begin
  if (FLockUpdate = 0) and IsControlVisible(Self) then inherited Invalidate;
end;

procedure TCustomGridView.InvalidateCell(Cell: TGridCell);
begin
  HideFocus;
  InvalidateRect(GetCellRect(Cell));
  ShowFocus;
end;

procedure TCustomGridView.InvalidateColumn(Column: Integer);
begin
  HideFocus;
  InvalidateRect(GetColumnRect(Column));
  ShowFocus;
end;

procedure TCustomGridView.InvalidateFixed;
begin
  InvalidateRect(GetFixedRect);
end;

procedure TCustomGridView.InvalidateFocus;
var
  Rect: TRect;
begin
  Rect := GetFocusRect;
  { подправляем прямоугольник фокуса (он не учитываемт картинку) }
  if RowSelect then
    UnionRect(Rect, Rect, GetCellRect(GridCell(Fixed.Count, CellFocused.Row)))
  else
    UnionRect(Rect, Rect, GetCellRect(CellFocused));
  { обновляем прямоугольник }
  InvalidateRect(Rect);
end;

procedure TCustomGridView.InvalidateGrid;
begin
  InvalidateRect(GetGridRect);
end;

procedure TCustomGridView.InvalidateHeader;
begin
  if ShowHeader then InvalidateRect(GetHeaderRect);
end;

procedure TCustomGridView.InvalidateRect(Rect: TRect);
begin
  if (FLockUpdate = 0) then InvalidateControlRect(Self, Rect, False);
end;

procedure TCustomGridView.InvalidateRow(Row: Integer);
begin
  InvalidateRect(GetRowRect(Row));
end;

function TCustomGridView.IsActiveControl: Boolean;
var
  H: HWND;
begin
  { определяем активность по форме }
  if (GetParentForm(Self) <> nil) and (GetParentForm(Self).ActiveControl = Self) then
  begin
    Result := True;
    Exit;
  end;
  { определяем по описателю }
  H := GetFocus;
  while IsWindow(H) do
  begin
    if H = WindowHandle then
    begin
      Result := True;
      Exit;
    end;
    H := GetParent(H);
  end;
  { ничего не нашли }
  Result := False;
end;

function TCustomGridView.IsCellAcceptCursor(Cell: TGridCell): Boolean;
begin
  { а корректна ли ячейка }
  if not IsCellCorrect(Cell) then
  begin
    Result := False;
    Exit;
  end;
  { результат по умолчанию }
  Result := True;
  { можно ли устанавливать курсор на ячейку }
  if Assigned(FOnCellAcceptCursor) then FOnCellAcceptCursor(Self, Cell, Result);
end;

function TCustomGridView.IsCellCorrect(Cell: TGridCell): Boolean;
var
  C, R, V: Boolean;
begin
  { определяем видимость, ширину колонки и коррестность ячейки }
  with Cell do
  begin
    C := (Col >= Fixed.Count) and (Col < Columns.Count);
    R := (Row >= 0) and (Row < Rows.Count);
    V := C and Columns[Col].Visible and (Columns[Col].Width > 0);
  end;
  { результат }
  Result := C and R and V;
end;

function TCustomGridView.IsCellHasImage(Cell: TGridCell): Boolean;
begin
  Result := Assigned(Images) and (GetCellImage(Cell) <> -1);
end;

function TCustomGridView.IsCellFocused(Cell: TGridCell): Boolean;
begin
  Result := ((Cell.Col = CellFocused.Col) or RowSelect) and
    (Cell.Row = CellFocused.Row) and (Cell.Col >= Fixed.Count);
end;

function TCustomGridView.IsCellVisible(Cell: TGridCell; PartialOK: Boolean): Boolean;
var
  CR, GR, R: TRect;
begin
  { получаем границы ячейки и сетки }
  CR := GetCellRect(Cell);
  GR := GetGridRect;
  { пересечение }
  Result := IntersectRect(R, CR, GR);
  { полная видимость }
  if not PartialOK then Result := EqualRect(R, CR);
end;

function TCustomGridView.IsColumnVisible(Column: Integer): Boolean;
var
  R: TRect;
begin
  Result := IntersectRect(R, GetColumnRect(Column), GetGridRect);
end;

function TCustomGridView.IsFocusAllowed: Boolean;
begin
  Result := RowSelect or (not (Editing or AlwaysEdit));
end;

function TCustomGridView.IsRowVisible(Row: Integer): Boolean;
var
  R: TRect;
begin
  Result := IntersectRect(R, GetRowRect(Row), GetGridRect);
end;

function TCustomGridView.GetCellAt(X, Y: Integer): TGridCell;
var
  C, R: Integer;
begin
  C := GetColumnAt(X, Y);
  R := GetRowAt(X, Y);
  if (C <> -1) and (R <> -1) then
  begin
    Result.Col := C;
    Result.Row := R;
  end
  else
  begin
    Result.Col := -1;
    Result.Row := -1;
  end;
end;

function TCustomGridView.GetCellRect(Cell: TGridCell): TRect;
begin
  IntersectRect(Result, GetColumnRect(Cell.Col), GetRowRect(Cell.Row));
end;

function TCustomGridView.GetColumnAt(X, Y: Integer): Integer;
var
  L, R: Integer;
begin
  if PtInRect(GetGridRect, Point(X, Y)) then
  begin
    Result := 0;
    { ищем среди фиксированных }
    L := 0;
    while Result <= Fixed.Count - 1 do
    begin
      R := L + Columns[Result].Width;
      if (R <> L) and (X >= L) and (X < R) then Exit;
      L := R;
      Inc(Result);
    end;
    { ищем среди обычных }
    L := L + GetGridOrigin.X;
    while Result <= Columns.Count - 1 do
    begin
      R := L + Columns[Result].Width;
      if (R <> L) and (X >= L) and (X < R) then Exit;
      L := R;
      Inc(Result);
    end;
  end;
  Result := -1;
end;

function TCustomGridView.GetColumnMaxWidth(Column: Integer): Integer;
var
  I, W: Integer;
  C: TGridCell;
  S: string;
begin
  Result := 0;
  for I := 0 to FVisSize.Row - 1 do
  begin
    C := GridCell(Column, VisOrigin.Row + I);
    GetCellColors(C, Canvas);
    S := GetCellText(C);
    W := Canvas.TextWidth(S);
    if IsCellHasImage(C) then Inc(W, Images.Width + 2);
    if Result < W then Result := W;
  end;
  Inc(Result, 15);
end;

function TCustomGridView.GetColumnRect(Column: Integer): TRect;
begin
  if (Column < 0) or (Column >= Columns.Count) then
  begin
    Result.Left := 0;
    Result.Right := 0;
  end
  else
  begin
    if Column < Fixed.Count then
      Result.Left := GetColumnsWidth(0, Column - 1)
    else
      Result.Left := GetColumnsWidth(0, Column - 1) + GetGridOrigin.X;
    Result.Right := Result.Left + Columns[Column].Width;
  end;
  Result.Top := GetGridOrigin.Y;
  Result.Bottom := Result.Top + GetRowsHeight(0, Rows.Count - 1);
end;

function TCustomGridView.GetColumnsWidth(Index1, Index2: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Index1 to Index2 do Inc(Result, Columns[I].Width);
end;

function TCustomGridView.GetHeaderHeight: Integer;
begin
  Result := Header.Height;
end;

function TCustomGridView.GetHeaderRect: TRect;
begin
  Result := ClientRect;
  if ShowHeader then
    Result.Bottom := Result.Top + GetHeaderHeight + 1
  else
    Result.Bottom := Result.Top;
end;

function TCustomGridView.GetFixedRect: TRect;
var
  I: Integer;
begin
  Result := GetGridRect;
  with Result do
  begin
    Right := Left;
    for I := 0 to Fixed.Count - 1 do Inc(Right, Columns[I].Width);
  end;
end;

function TCustomGridView.GetFixedWidth: Integer;
begin
  with GetFixedRect do Result := Right - Left;
end;

function TCustomGridView.GetFocusRect: TRect;
var
  C, L: Integer;
begin
  if RowSelect then
  begin
    { прямоугольник строки }
    Result := GetRowRect(CellFocused.Row);
    Result.Left := Result.Left + GetFixedWidth;
  end
  else
    { прямоугольник ячейки }
    Result := GetCellRect(CellFocused);
  { получаем крайнюю левую колонку фокуса }
  C := CellFocused.Col;
  if RowSelect then C := Fixed.Count;
  { место под картинку }
  if IsCellHasImage(GridCell(C, CellFocused.Row)) then
  begin
    { сдвигаем результат на ширину картинок + 2 }
    Inc(Result.Left, Images.Width + 2);
    { получаем крайнее левое положение фокуса }
    L := GetColumnsWidth(0, C);
    { проверяем правый край результата }
    if Result.Left > L then Result.Left := L;
  end;
end;

function TCustomGridView.GetGridHeight: Integer;
begin
  Result := ClientHeight;
  if ShowHeader then Dec(Result, GetHeaderHeight + 1);
end;

function TCustomGridView.GetGridOrigin: TPoint;
begin
  Result.X := GetGridRect.Left - HorzScrollBar.Position;
  Result.Y := GetGridRect.Top - VertScrollBar.Position * Rows.Height;
end;

function TCustomGridView.GetGridRect: TRect;
begin
  Result := ClientRect;
  if ShowHeader then Inc(Result.Top, GetHeaderHeight + 1);
end;

function TCustomGridView.GetResizeSection(X, Y: Integer): TGridHeaderSection;

  function FindSection(Sections: TGridHeaderSections; var Section: TGridHeaderSection): Boolean;
  var
    I, C: Integer;
    R: TRect;
    S: TGridHeaderSection;
  begin
    for I := Sections.Count - 1 downto 0 do
    begin
      { получаем ячейку и ее колонку }
      S := Sections[I];
      C := S.Column;
      { ищем только для видимых колонок } 
      if (C > Columns.Count - 1) or Columns[C].Visible then
      begin
        { получаем прямоугольник области изменения размера }
        R := S.Bounds;
        with R do
        begin
          if R.Right > R.Left then Left := Right - 7;
          Right := Right + 5;
        end;
        { попала ли точка в него }
        if PtInRect(R, Point(X, Y)) then
        begin
          { проверяем колнку на фиксированный размер }
          if (C < Columns.Count) and (Columns[C].FixedSize) then
          begin
            Section := nil;
            Result := False;
          end
          else
          begin
            Section := S;
            Result := True;
          end;
          { секцию нашли - выход }
          Exit;
        end;
        { ищем секцию в подзаголовках }
        if FindSection(S.Sections, Section) then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
    Section := nil;
    Result := False;
  end;

begin
  FindSection(Header.Sections, Result);
end;

function TCustomGridView.GetRowAt(X, Y: Integer): Integer;
var
  Row: Integer;
begin
  if PtInRect(GetGridRect, Point(X, Y)) then
  begin
    Row := (Y - GetGridOrigin.Y) div Rows.Height;
    if (Row >= 0) and (Row < Rows.Count) then
    begin
      Result := Row;
      Exit;
    end;
  end;
  Result := -1;
end;

function TCustomGridView.GetRowRect(Row: Integer): TRect;
begin
  Result.Left := GetGridOrigin.X;
  Result.Right := Result.Left + GetColumnsWidth(0, Columns.Count - 1);
  Result.Top := GetRowsHeight(0, Row - 1) + GetGridOrigin.Y;
  Result.Bottom := Result.Top + Rows.Height;
end;

function TCustomGridView.GetRowsHeight(Index1, Index2: Integer): Integer;
begin
  if Index2 < Index1 then
  begin
    Result := 0;
    Exit;
  end;
  Result := (Index2 - Index1 + 1) * Rows.Height;
end;

procedure TCustomGridView.LockUpdate;
begin
  Inc(FLockUpdate);
end;

procedure TCustomGridView.UnLockUpdate(Redraw: Boolean);
begin
  Dec(FLockUpdate);
  if (FLockUpdate = 0) and Redraw then Invalidate;
end;

end.
