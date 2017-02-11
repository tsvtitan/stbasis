{***********************************************************
                R&A Library
       Copyright (C) 1996-2000 R&A

       component   : TRAEditor
       description : 'Delphi IDE'-like Editor

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru
************************************************************}

{$inCLUDE RA.inC}

{ history
 (R&A Library versions) :
  1.00:
    - first release;
  1.01:
    - reduce caret blinking - method KeyUp;
    - fix bug with setting SelLength to 0;
    - changing SelStart now reset SelLength to 0;
    - very simple tab - two blanks;
  1.02:
    - SmartTab;
    - KeepTrailingBlanks;
    - CursorBeyondEOF;
    - Autoindent;
    - BackSpaceUnindents;
    - two-key commands;
    - automatically expands tabs when setting Lines property;
  1.04:
    - some bugs fixed in Completion;
    - fix bug with reading SelLength property;
    - new method TEditorStrings.SetLockText;
    - new dynamic method TextAllChanged;
  1.11:
    - method StatusChanged;
    - fixed bug with setting Lines.Text property;
    - new method GetText with TIEditReader syntax;
  1.14:
    - selected color intialized with system colors;
  1.17:
    some improvements and bug fixes by Rafal Smotrzyk - rsmotrzyk@mikroplan.com.pl :
    - Autoindent now worked when SmartTab Off;
    - method GetTextLen for TMemo compatibility;
    - indent, Unindent commands;
    - WM_COPY, WM_CUT, WM_PASTE message handling;
  1.17.1:
    - painting and scrolling changed:
      bug with scrolling RAEditor if other StayOnTop
      window overlapes RAEditor window  FIXED;
    - right click now not unselect text;
    - changing RightMargin, RightMarginVisible and RightMarginColor
      invalidates window;
  1.17.2:
   another good stuf by Rafal Smotrzyk - rsmotrzyk@mikroplan.com.pl :
    - fixed bug with backspace pressed when text selected;
    - fixed bug with disabling Backspace Unindents when SmartTab off;
    - fixed bug in GetTabStop method when SmartTab off;
    - new commands: DeleteWord, DeleteLine, ToUpperCase, ToLowerCase;
  1.17.3:
    - TabStops;
  1.17.4:
    - undo for selection modifiers;
    - UndoBuffer.BeginCompound, UndoBuffer.EndCompound for
      compound commands, that must interpreted by UndoBuffer as one operation;
      now not implemented, but must be used for feature compatibility;
    - fixed bug with undoable Delete on end of line;
    - new command ChangeCase;
  1.17.5:
    - UndoBuffer.BeginCompound, UndoBuffer.EndCompound fully implemented;
    - UndoBuffer property in TRACustomEditor;
  1.17.6:
    - fixed bug with compound undo;
    - fixed bug with scrolling (from v 1.171);
  1.17.7:
    - UndoBuffer.BeginCompound and UndoBuffer.EndCompound moved to TRACustomEditor;
    - Macro support: BeginRecord, EndRecord, PlayMacro; not complete;
    - additional support for compound operations: prevent updating and other;
  1.17.8:
    - bug fixed with compound commands in macro;
  1.21.2:
    - fixed bug with pressing End-key if CursorBeoyondEOF enabled
      (greetings to Martijn Laan)
  1.21.4:
    - fixed bug in commands ecNextWord and ecPrevWord
      (greetings to Ildar Noureeslamov)
  1.21.6:
    - in OnGetLineAttr now it is possible to change attributes of right
    trailing blanks.
  1.23:
    - fixed bug in completion (range check error)
    (greetings to Willo vd Merwe)
  1.51.1 (R&A Library 1.51 with Update 1):
    - methods Lines.Add and Lines.insert now properly updates editor window.
  1.51.2 (R&A Library 1.51 with Update 2):
    - "Courier New" is default font now.
  1.51.3 (R&A Library 1.51 with Update 2)::
    - fixed bug: double click on empty editor raise exception;
    - fixed bug: backspace at EOF raise exception;
    - fixed bug: gutter not repainted on vertical scrolling;
  1.53:
    - fixed bug: GetWordOnCaret returns invalid word if caret stays on start of word;
  1.54.1:
    - new: undo now works in overwrite mode;
  1.54.2:
    - fixed bug: double click not selects word on first line;
    - selection work better after consecutive moving to begin_of_line and
      end_of_line, and in other cases;
    - 4 block format supported now: Noninclusive (default), inclusive,
      Line (initial support), Column;
    - painting was improved;
  1.60:
    - DblClick work better (thanks to Constantin M. Lushnikov);
    - fixed bug: caret moved when mouse moves over raeditor after
      click on any other windows placed over raeditor, which loses focus
      after this click; (anyone understand me ? :)
    - bug fixed: accelerator key do not work on window,
      where raeditor is placed (thanks to Luis David Cardenas Bucio);
  1.61:
    - support for mouse with wheel (thanks to Michael Serpik);
    - ANY font can be used (thanks to Rients Politiek);
    - bug fixed: completion ranges error on first line
      (thanks to Walter Campelo);
    - new functions: CanCopy, CanPaste, CanCut in TRACustomEditor
      and function CanUndo in TUndoBuffer (TRACustomEditor.UndoBuffer);
  2.00:
    - removed dependencies from RAUtils.pas unit;
    - bugfixed: TDeleteUndo and TBackspaceUndo do not work always properly
      (thanks to Pavel Chromy);
    - bugfixed: workaround bug with some fonts in Win9x
      (thanks to Dmitry Rubinstain);

}


{
  to do:
   1) добавить событие OnGutterClick(Sender: TObject; Line: integer);
   2) добавить поддержку <Persistent Block> !!!!!????;
}

unit RAEditor;

{$DEFinE DEBUG}
{$IFNDEF RAEDITOR_NOEDITOR}
{$DEFinE RAEDITOR_EDITOR} {if not RAEDITOR_EDITOR then mode = Viewer}
{$ENDIF}
{$DEFinE RAEDITOR_DEFLAYOT} {set default keyboard layot}
{$IFNDEF RAEDITOR_NOUNDO}
{$DEFinE RAEDITOR_UNDO} {enable undo}
{$ENDIF}
{$IFNDEF RAEDITOR_NOCOMPLETION}
{$DEFinE RAEDITOR_COMPLETION} {enable code completion}
{$ENDIF}

{$IFNDEF RAEDITOR_EDITOR}
{$UNDEF RAEDITOR_DEFLAYOT}
{$UNDEF RAEDITOR_UNDO}
{$UNDEF RAEDITOR_COMPLETION}
{$ENDIF RAEDITOR_EDITOR}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, ClipBrd, imglist;

const
  Max_X = 1024; {max symbols per row}
  Max_X_Scroll = 256;
  {max symbols per row for scrollbar - max кол-во символов в строке для прокрутки}
  GutterRightMargin = 2;

  WM_EDITCOMMAND = WM_USER + $101;
 {$IFNDEF RA_D3H}
  WM_MOUSEWHEEL       = $020A;
 {$ENDIF RA_D3H}

type

 {$IFNDEF RA_D4H}
  TWMMouseWheel = packed record
    Msg: Cardinal;
    Keys: Smallint;
    WheelDelta: Smallint;
    case integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;
 {$ENDIF RA_D4H}

  TCellRect = record
    Width: integer;
    Height: integer;
  end;

  TLineAttr = record
    FC, BC: TColor;
    Style: TFontStyles;
  end;

  TRACustomEditor = class;

  TLineAttrs = array[0..Max_X] of TLineAttr;
  TOnGetLineAttr = procedure(Sender: TObject; var Line: string; index: integer;
    var Attrs: TLineAttrs) of object;
  TOnChangeStatus = TNotifyEvent;

  TEditorStrings = class(TStringList)
  private
    FRAEditor: TRACustomEditor;
    procedure StringsChanged(Sender: TObject);
    procedure Setinternal(index: integer; value: string);
    procedure ReLine;
    procedure SetLockText(Text: string);
  protected
    procedure SetTextStr(const Value: string); override;
    procedure Put(index: integer; const S: string); override;
  public
    constructor Create;
//    procedure LoadFromFile(FileName: String):override;
    procedure LoadFromStream(Stream: TStream);override;

    function Add(const S: string): integer; override;
    procedure insert(index: integer; const S: string); override;
    property internal[index: integer]: string write Setinternal;
  end;

  TModifiedAction = (mainsert, maDelete, mainsertColumn, maDeleteColumn);

  TBookMark = record
    X, Y: integer;
    Valid: boolean;
  end;
  TBookMarkNum = 0..9;
  TBookMarks = array[TBookMarkNum] of TBookMark;

  TEditorClient = class
  private
    FRAEditor: TRACustomEditor;
    Top: integer;
    function Left: integer;
    function Height: integer;
    function Width: integer;
    function ClientWidth: integer;
    function ClientHeight: integer;
    function ClientRect: TRect;
    function BoundsRect: TRect;
    function GetCanvas: TCanvas;
  public    
    property Canvas: TCanvas read GetCanvas;
  end;

  TGutter = class
  private
    FRAEditor: TRACustomEditor;
  public
    procedure Paint;
    procedure invalidate;
  end;
  TOnPaintGutter = procedure(Sender: TObject; Canvas: TCanvas) of object;

  TEditCommand = word;
  TMacro = string; { used as buffer }

  TTypeEditKey=(tek1,tek2);
  
  TEditKey = class
  public
    TypeEditKey: TTypeEditKey;
    Key1, Key2: Word;
    Shift1, Shift2: TShiftState;
    Command: TEditCommand;
    constructor Create(const ACommand: TEditCommand; const AKey1: word;
      const AShift1: TShiftState; ATypeEditKey: TTypeEditKey);
    constructor Create2(const ACommand: TEditCommand; const AKey1: word;
      const AShift1: TShiftState; const AKey2: word;
      const AShift2: TShiftState;ATypeEditKey: TTypeEditKey);
  end;

  TKeyboard = class
  private
    List: TList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const ACommand: TEditCommand; const AKey1: word;
      const AShift1: TShiftState): TEditKey;
    function Add2(const ACommand: TEditCommand; const AKey1: word;
      const AShift1: TShiftState; const AKey2: word;
      const AShift2: TShiftState): TEditKey;

    procedure Replace(EditKey: TEditKey; const ACommand: TEditCommand;
             const AKey1: word; const AShift1: TShiftState);
    procedure Replace2(EditKey: TEditKey; const ACommand: TEditCommand; const AKey1: word;
             const AShift1: TShiftState; const AKey2: word;
             const AShift2: TShiftState);

    procedure Clear;
    function Command(const AKey: word; const AShift: TShiftState): TEditCommand;
    function Command2(const AKey1: word; const AShift1: TShiftState;
      const AKey2: word; const AShift2: TShiftState): TEditCommand;
    function GetCount: integer;
    function GetEditKey(index: integer): TEditKey;
    procedure RemoveEditKey(EditKey: TEditKey);
    {$IFDEF RAEDITOR_DEFLAYOT}
    procedure SetDefLayot;
    {$ENDIF RAEDITOR_DEFLAYOT}
    procedure Assign(Source: TKeyboard);
    procedure GetListByCommand(ACommand: TEditCommand; AList: TList);

    
  end;

  ERAEditorError = class(Exception);

  {$IFDEF RAEDITOR_UNDO}
  TUndoBuffer = class;

  TUndo = class
  private
    FRAEditor: TRACustomEditor;
    function UndoBuffer: TUndoBuffer;
  public
    constructor Create(ARAEditor: TRACustomEditor);
    procedure Undo; dynamic; abstract;
    procedure Redo; dynamic; abstract;
  end;

  TUndoBuffer = class(TList)
  private
    FRAEditor: TRACustomEditor;
    FPtr: integer;
    inUndo: boolean;
    function LastUndo: TUndo;
    function IsNewGroup(AUndo: TUndo): boolean;
  public
    procedure Add(AUndo: TUndo);
    procedure Undo;
    procedure Redo;
    procedure Clear; {$IFDEF RA_D35H}override; {$ENDIF}
    procedure Delete;
    function CanUndo: boolean;
  end;
  {$ENDIF RAEDITOR_UNDO}

  {$IFDEF RAEDITOR_COMPLETION}
  TCompletion = class;
  TOnCompletion = procedure(Sender: TObject; var Cancel: boolean) of object;
  TOnCompletionApply = procedure(Sender: TObject; const OldString: string; var NewString: string) of object;
  {$ENDIF RAEDITOR_COMPLETION}

  TTabStop = (tsTabStop, tsAutoindent);

{ Borland Block Type:
  00 - inclusive;
  01 - line;
  02 - column;
  03 - noninclusive; }
  
  TSelBlockFormat = (bfinclusive, bfLine, bfColumn, bfNoninclusive);


  TRAControlScrollBar95 = class
  private
    FKind: TScrollBarKind;
    FPosition: integer;
    FMin: integer;
    FMax: integer;
    FSmallChange: TScrollBarinc;
    FLargeChange: TScrollBarinc;
    FPage : integer;
    FHandle : hWnd;
    FOnScroll: TScrollEvent;
    procedure SetParam(index, Value: integer);
  protected
    procedure Scroll(ScrollCode: TScrollCode; var ScrollPos: integer); dynamic;
  public
    constructor Create;
    procedure SetParams(AMin, AMax, APosition, APage : integer);
    procedure DoScroll(var Message: TWMScroll);

    property Kind: TScrollBarKind read FKind write FKind default sbHorizontal;
    property SmallChange: TScrollBarinc read FSmallChange write FSmallChange default 1;
    property LargeChange: TScrollBarinc read FLargeChange write FLargeChange default 1;
    property Min  : integer index 0 read FMin write SetParam default 0;
    property Max  : integer index 1 read FMax write SetParam default 100;
    property Position : integer index 2 read FPosition write SetParam default 0;
    property Page : integer index 3 read FPage write SetParam;
    property Handle : hWnd read FHandle write FHandle;
    property OnScroll: TScrollEvent read FOnScroll write FOnScroll;
  end;

  {*** TRACustomEditor }

  // by TSV

  TFindTxt=class
    private
      FEditor: TRACustomEditor;
      FVisible: Boolean;
      FPosition: integer;
      FStartPoint: TPoint;
      procedure SetVisible(Value: Boolean);
      procedure SetPosition(Value: integer);
    protected
      constructor Create(Editor: TRACustomEditor);
    public
      Text: string;
      property Visible: Boolean read FVisible write SetVisible;
      property Position: integer read FPosition write SetPosition;
      property StartPoint: TPoint read FStartPoint; 
  end;

  TErrorLine=class
    private
      FEditor: TRACustomEditor;
      FVisible: Boolean;
      procedure SetVisible(Value: Boolean);
    protected
      constructor Create(Editor: TRACustomEditor);
    public
      Line,Column: integer;
      property Visible: Boolean read FVisible write SetVisible;
  end;

  TOnStartLongOperation=procedure(Sender: TObject; vMin,vMax: Integer; vHint: String)of object;
  TOnProgressLongOperation=procedure(Sender: TObject; vProgress: Integer) of object;
  TOnFinishLongOperation=procedure(Sender: TObject) of object;
  TOnCommand=procedure (Sender: TObject; Command: TEditCommand) of object;
  TOnIdentiferHint=procedure (Sender: TObject; const Identifer: string; const PosBegin,PosEnd,X,Y: Integer) of object;

  TRACustomEditor = class(TCustomControl)
  private
    { internal objects }
    FLines: TEditorStrings;
    scbHorz: TRAControlScrollBar95;
    scbVert: TRAControlScrollBar95;
    FEditorClient: TEditorClient;
    FGutter: TGutter;
    FKeyboard: TKeyboard;
    FUpdateLock: integer;
    {$IFDEF RAEDITOR_UNDO}
    FUndoBuffer: TUndoBuffer;
    FGroupUndo: boolean;
    FUndoAfterSave: boolean;
    {$ENDIF RAEDITOR_UNDO}
    FCompletionImages: TCustomImageList;
    {$IFDEF RAEDITOR_COMPLETION}

    FCompletion: TCompletion;
    {$ENDIF RAEDITOR_COMPLETION}

    { internal - Columns and rows attributes }
    FCols, FRows: integer;
    FLeftCol, FTopRow: integer;
    // FLeftColMax, FTopRowMax : integer;
    FLastVisibleCol, FLastVisibleRow: integer;
    FCaretX, FCaretY: integer;
    FVisibleColCount: integer;
    FVisibleRowCount: integer;

    { internal - other flags and attributes }
    FAllRepaint: boolean;
    FCellRect: TCellRect;
    {$IFDEF RAEDITOR_EDITOR}
    IgnoreKeyPress: boolean;
    {$ENDIF RAEDITOR_EDITOR}
    WaitSecondKey: Boolean;
    Key1: Word;
    Shift1: TShiftState;

    { internal - selection attributes }
    FSelected: boolean;
    FSelBlockFormat: TSelBlockFormat;
    FSelBegX, FSelBegY, FSelEndX, FSelEndY: integer;
    FUpdateSelBegY, FUpdateSelEndY: integer;
    FSelStartX, FSelStartY: integer;
    FclSelectBC, FclSelectFC: TColor;

    { mouse support }
    timerScroll: TTimer;
    timerHint: TTimer;
    MouseMoveY, MouseMoveXX, MouseMoveYY: integer;
    FDoubleClick: Boolean;
    FMouseDowned: Boolean;

    { internal }
    FTabPos: array[0..Max_X] of boolean;
    FTabStops: string;
    MyDi: array[0..1024] of integer;

    { internal - primary for TIReader support }
    FEditBuffer: string;
    FPEditBuffer: PChar;
    FEditBufferSize: integer;

    FCompound: integer;
    { FMacro - buffer of TEditCommand, each command represents by two chars }
    FMacro: TMacro;
    FDefMacro: TMacro;

    { visual attributes - properties }
    FBorderStyle: TBorderStyle;
    FGutterColor: TColor;
    FGutterWidth: integer;
    FRightMarginVisible: boolean;
    FRightMargin: integer;
    FRightMarginColor: TColor;
    FScrollBars: TScrollStyle;
    FDoubleClickLine: boolean;
    FSmartTab: Boolean;
    FBackSpaceUnindents: Boolean;
    FAutoindent: Boolean;
    FKeepTrailingBlanks: Boolean;
    FCursorBeyondEOF: Boolean;


    { non-visual attributes - properties }
    FinsertMode: boolean;
    FReadOnly: boolean;
    FModified: boolean;
    FRecording: boolean;

    FSyntaxHighlighting: Boolean;

    { Events }
    FOnGetLineAttr: TOnGetLineAttr;
    FOnChange: TNotifyEvent;
    FOnSelectionChange: TNotifyEvent;
    FOnChangeStatus: TOnChangeStatus;
    FOnScroll: TNotifyEvent;
    FOnResize: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnPaintGutter: TOnPaintGutter;
    {$IFDEF RAEDITOR_COMPLETION}
    FOnCompletionIdentifer: TOnCompletion;
    FOnCompletionTemplate: TOnCompletion;
    FOnCompletionDrawItem: TDrawItemEvent;
    FOnCompletionMeasureItem: TMeasureItemEvent;
    FOnCompletionApply: TOnCompletionApply;
    {$ENDIF RAEDITOR_COMPLETION}

    // by TSV
    FFindTxt: TFindTxt;
    FErrorLine: TErrorLine;
    FOnStartLongOperation: TOnStartLongOperation;
    FOnProgressLongOperation: TOnProgressLongOperation;
    FOnFinishLongOperation: TOnFinishLongOperation;
    FOnCommand: TOnCommand;
    FOnIdentiferHint: TOnIdentiferHint;
    FIdentiferHint: string;
    FIdentiferPosBegin: Integer;
    FIdentiferPosEnd: Integer;
    OldX: Integer;
    OldY: Integer;

    { internal message processing }
    {$IFNDEF RA_D4H}
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    {$ENDIF RA_D4H}
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMEditCommand(var Message: TMessage); message WM_EDITCOMMAND;
    procedure WMCopy(var Message: TMessage); message WM_COPY;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;

    procedure UpdateEditorSize;
    {$IFDEF RAEDITOR_COMPLETION}
    procedure DoCompletionIdentifer(var Cancel: boolean);
    procedure DoCompletionTemplate(var Cancel: boolean);
    {$ENDIF RAEDITOR_COMPLETION}
    procedure ScrollTimer(Sender: TObject);
    procedure HintTimer(Sender: TObject);

    procedure ReLine;
    function GetDefTabStop(const X: integer; const Next: Boolean): integer;
    function GetTabStop(const X, Y: integer; const What: TTabStop;
      const Next: Boolean): integer;
    function GetBackStop(const X, Y: integer): integer;

    procedure TextAllChangedinternal(const Unselect: Boolean);

    { property }
    procedure SetGutterWidth(AWidth: integer);
    procedure SetGutterColor(AColor: TColor);
    function GetLines: TStrings;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetLines(ALines: TStrings);
    function GetSelStart: integer;
    procedure SetSelStart(const ASelStart: integer);
    procedure SetSelLength(const ASelLength: integer);
    function GetSelLength: integer;
    procedure SetSelBlockFormat(const Value: TSelBlockFormat);
    procedure SetMode(index: integer; Value: boolean);
    procedure SetCaretPosition(const index, Pos: integer);
    procedure SetCols(ACols: integer);
    procedure SetRows(ARows: integer);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetRightMarginVisible(Value: boolean);
    procedure SetRightMargin(Value: integer);
    procedure SetRightMarginColor(Value: TColor);
    procedure SetSyntaxHighlighting(Value: Boolean);

    procedure SetCompletionImages(Value: TCustomImageList);

  protected
    LineAttrs: TLineAttrs;
    procedure Resize; {$IFDEF RA_D4H}override; {$ELSE}dynamic; {$ENDIF RA_D4H}
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode; var
      ScrollPos: integer);
    procedure Scroll(const Vert: boolean; const ScrollPos: integer);
    procedure PaintLine(const Line: integer; ColBeg, ColEnd: integer);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    {$IFDEF RAEDITOR_EDITOR}
    procedure KeyPress(var Key: Char); override;
    procedure insertChar(const Key: Char);
    {$ENDIF RAEDITOR_EDITOR}
    function GetClipboardBlockFormat: TSelBlockFormat;
    procedure SetClipboardBlockFormat(const Value: TSelBlockFormat);
    procedure SetSel(const SelX, SelY: integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
      integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
      override;
    procedure DblClick; override;
    procedure DrawRightMargin;
    procedure PaintSelection;
    procedure SetUnSelected;
    procedure Mouse2Cell(const X, Y: integer; var CX, CY: integer);
    procedure Mouse2Caret(const X, Y: integer; var CX, CY: integer);
    procedure CaretCoord(const X, Y: integer; var CX, CY: integer);
    function PosFromMouse(const X, Y: integer): integer;
    procedure SetLockText(const Text: string);
    function ExpandTabs(const S: string): string;
    // add by patofan
   {$IFDEF RA_D3H}
    function CheckDoubleByteChar(var x: integer; y: integer; ByteType : TMbcsByteType; delta_inc: integer): boolean;
   {$ENDIF RA_D3H}
    // ending add by patofan

    {$IFDEF RAEDITOR_UNDO}
    procedure NotUndoable;
    {$ENDIF RAEDITOR_UNDO}
    procedure SetCaretinternal(X, Y: integer);
    procedure ValidateEditBuffer;

    {$IFDEF RAEDITOR_EDITOR}
    procedure ChangeBookMark(const BookMark: TBookMarkNum; const Valid:
      boolean);
    {$ENDIF RAEDITOR_EDITOR}
    procedure BeginRecord;
    procedure EndRecord(var AMacro: TMacro);
    procedure PlayMacro(const AMacro: TMacro);

    { triggers for descendants }
    procedure Changed; dynamic;
    procedure TextAllChanged; dynamic;
    procedure StatusChanged; dynamic;
    procedure SelectionChanged; dynamic;
    procedure GetLineAttr(var Str: string; Line, ColBeg, ColEnd: integer); virtual;
    procedure GetAttr(Line, ColBeg, ColEnd: integer); virtual;
    procedure ChangeAttr(Line, ColBeg, ColEnd: integer); virtual;
    procedure GutterPaint(Canvas: TCanvas); dynamic;
    procedure BookmarkCnanged(BookMark: integer); dynamic;
    {$IFDEF RAEDITOR_COMPLETION}
    procedure CompletionIdentifer(var Cancel: boolean); dynamic;
    procedure CompletionTemplate(var Cancel: boolean); dynamic;
    {$ENDIF RAEDITOR_COMPLETION}
    { don't use method TextModified: see comment at method body }
    procedure TextModified(Pos: integer; Action: TModifiedAction; Text: string);
      dynamic;
    property Gutter: TGutter read FGutter;
  public
    BookMarks: TBookMarks;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetLeftTop(ALeftCol, ATopRow: integer);
    procedure ClipBoardCopy;
    procedure ClipBoardPaste;
    procedure ClipBoardCut;
    function CanCopy: Boolean;
    function CanPaste: Boolean;
    function CanCut: Boolean;
    procedure DeleteSelected;
    function CalcCellRect(const X, Y: integer): TRect;
    procedure SetCaret(X, Y: integer);
    procedure CaretFromPos(const Pos: integer; var X, Y: integer);
    function PosFromCaret(const X, Y: integer): integer;
    procedure PaintCaret(const bShow: boolean);
    function GetTextLen: integer;
    function GetSelText: string;
    procedure SetSelText(const AValue: string);
    function GetWordOnCaret: string;
    function GetPosByLine(const Line: Integer): Integer;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure MakeRowVisible(ARow: integer);

    procedure Command(ACommand: TEditCommand); virtual;
    procedure PostCommand(ACommand: TEditCommand);
    {$IFDEF RAEDITOR_EDITOR}
    procedure insertText(const Text: string);
    procedure ReplaceWord(const NewString: string);
    procedure ReplaceWord2(const NewString: string);
    {$ENDIF}
    procedure BeginCompound;
    procedure EndCompound;

    // by TSV
    procedure ReplaceWord2FromPosition(const Pos,LenOld: integer; const NewString: string);
    function FindText(Value: string; WithCase,WordOnly,RegExpresion: Boolean;
                      Direction,Scope,Origin: Boolean;
                      First: Boolean=false; ResetSelection: Boolean=false;
                      View: Boolean=true): Boolean;
    function ReplaceText(OldValue,NewValue: string; WithCase,WordOnly,RegExpresion: Boolean;
                          Direction,Scope,Origin,Promt: Boolean; First: Boolean=false;
                          ResetSelection: Boolean=false): Boolean;
    function GetWordFromCaret: string;
    procedure SetCaretXY(X, Y: integer);
    procedure SetErrorLine(X, Y: integer);
    property EditorClient: TEditorClient read FEditorClient;

    function GetText(Position: Longint; Buffer: PChar; Count: Longint): Longint;
    property LeftCol: integer read FLeftCol;
    property TopRow: integer read FTopRow;
    property VisibleColCount: integer read FVisibleColCount;
    property VisibleRowCount: integer read FVisibleRowCount;
    property LastVisibleCol: integer read FLastVisibleCol;
    property LastVisibleRow: integer read FLastVisibleRow;
    property Cols: integer read FCols write SetCols;
    property Rows: integer read FRows write SetRows;
    property CaretX: integer index 0 read FCaretX write SetCaretPosition;
    property CaretY: integer index 1 read FCaretY write SetCaretPosition;
    property Modified: boolean read FModified write FModified;
    property SelBlockFormat: TSelBlockFormat read FSelBlockFormat write SetSelBlockFormat default bfNoninclusive;
    property SelStart: integer read GetSelStart write SetSelStart;
    property SelLength: integer read GetSelLength write SetSelLength;
    property SelText: string read GetSelText write SetSelText;
    property Keyboard: TKeyboard read FKeyboard;
    property CellRect: TCellRect read FCellRect;
    {$IFDEF RAEDITOR_UNDO}
    property UndoBuffer: TUndoBuffer read FUndoBuffer;
    property GroupUndo: boolean read FGroupUndo write FGroupUndo default True;
    property UndoAfterSave: boolean read FUndoAfterSave write FUndoAfterSave;
    {$ENDIF RAEDITOR_UNDO}
    property Recording: boolean read FRecording;
  public { published in descendants }
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Lines: TStrings read GetLines write SetLines;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property Cursor default crIBeam;
    property Color default clWindow;

    property GutterWidth: integer read FGutterWidth write SetGutterWidth;
    property GutterColor: TColor read FGutterColor write SetGutterColor default clBtnFace;
    property RightMarginVisible: boolean read FRightMarginVisible write SetRightMarginVisible default true;
    property RightMargin: integer read FRightMargin write SetRightMargin default 80;
    property RightMarginColor: TColor read FRightMarginColor write SetRightMarginColor default clBtnFace;
    property insertMode: boolean index 0 read FinsertMode write SetMode default true;
    property ReadOnly: boolean index 1 read FReadOnly write SetMode default false;
    property DoubleClickLine: boolean read FDoubleClickLine write FDoubleClickLine default false;

    property CompletionImages: TCustomImageList read FCompletionImages write SetCompletionImages;
    {$IFDEF RAEDITOR_COMPLETION}
    property Completion: TCompletion read FCompletion write FCompletion;
    {$ENDIF RAEDITOR_COMPLETION}
    property TabStops: string read FTabStops write FTabStops;
    property SmartTab: Boolean read FSmartTab write FSmartTab default true;
    property BackSpaceUnindents: Boolean read FBackSpaceUnindents write FBackSpaceUnindents default true;
    property Autoindent: Boolean read FAutoindent write FAutoindent default true;
    property KeepTrailingBlanks: Boolean read FKeepTrailingBlanks write FKeepTrailingBlanks default false;
    property CursorBeyondEOF: Boolean read FCursorBeyondEOF write FCursorBeyondEOF default false;
    property SelForeColor: TColor read FclSelectFC write FclSelectFC;
    property SelBackColor: TColor read FclSelectBC write FclSelectBC;
    property SyntaxHighlighting: boolean read FSyntaxHighlighting write SetSyntaxHighlighting default True;

    property OnGetLineAttr: TOnGetLineAttr read FOnGetLineAttr write FOnGetLineAttr;
    property OnChangeStatus: TOnChangeStatus read FOnChangeStatus write FOnChangeStatus;
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnSelectionChange: TNotifyEvent read FOnSelectionChange write FOnSelectionChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnPaintGutter: TOnPaintGutter read FOnPaintGutter write FOnPaintGutter;
    {$IFDEF RAEDITOR_COMPLETION}
    property OnCompletionIdentifer: TOnCompletion read FOnCompletionIdentifer write FOnCompletionIdentifer;
    property OnCompletionTemplate: TOnCompletion read FOnCompletionTemplate write FOnCompletionTemplate;
    property OnCompletionDrawItem: TDrawItemEvent read FOnCompletionDrawItem write FOnCompletionDrawItem;
    property OnCompletionMeasureItem: TMeasureItemEvent read FOnCompletionMeasureItem write FOnCompletionMeasureItem;
    property OnCompletionApply: TOnCompletionApply read FOnCompletionApply write FOnCompletionApply;
    {$ENDIF RAEDITOR_COMPLETION}
    {$IFDEF RA_D4H}
    property DockManager;
    {$ENDIF RA_D4H}

    // by TSV
    property FindTxt: TFindTxt read FFindTxt;
    property ErrorLine: TErrorLine read FErrorLine;
    property OnStartLongOperation: TOnStartLongOperation read FOnStartLongOperation write FOnStartLongOperation;
    property OnProgressLongOperation: TOnProgressLongOperation read FOnProgressLongOperation write FOnProgressLongOperation;
    property OnFinishLongOperation: TOnFinishLongOperation read FOnFinishLongOperation write FOnFinishLongOperation;
    property OnCommand: TOnCommand read FOnCommand write FOnCommand;
    property OnIdentiferHint: TOnIdentiferHint read FOnIdentiferHint write FOnIdentiferHint;

  end;

  TRAEditor = class(TRACustomEditor)
  published
    property BorderStyle;
    property Lines;
    property ScrollBars;
    property GutterWidth;
    property GutterColor;
    property RightMarginVisible;
    property RightMargin;
    property RightMarginColor;
    property insertMode;
    property ReadOnly;
    property DoubleClickLine;

    property CompletionImages;
    {$IFDEF RAEDITOR_COMPLETION}
    property Completion;
    {$ENDIF RAEDITOR_COMPLETION}
    property TabStops;
    property SmartTab;
    property BackSpaceUnindents;
    property Autoindent;
    property KeepTrailingBlanks;
    property CursorBeyondEOF;
    property SelForeColor;
    property SelBackColor;
    property SelBlockFormat;
    
    property OnGetLineAttr;
    property OnChangeStatus;
    property OnScroll;
    property OnResize;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnChange;
    property OnSelectionChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnPaintGutter;
    {$IFDEF RAEDITOR_COMPLETION}
    property OnCompletionIdentifer;
    property OnCompletionTemplate;
    property OnCompletionDrawItem;
    property OnCompletionMeasureItem;
    property OnCompletionApply;
    {$ENDIF RAEDITOR_COMPLETION}

    { TCustomControl }
    property Align;
    property Enabled;
    property Color;
    property Ctl3D;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabStop;
    property Visible;
    {$IFDEF RA_D4H}
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Constraints;
    property UseDockManager default True;
    property DockSite;
    property DragKind;
    property ParentBiDiMode;
    property OnCanResize;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnGetSiteinfo;
    property OnStartDock;
    property OnUnDock;
    {$ENDIF RA_D4H}

    // by TSV
    property OnStartLongOperation;
    property OnProgressLongOperation;
    property OnFinishLongOperation;
    property OnIdentiferHint;
  end;

  {$IFDEF RAEDITOR_COMPLETION}


  TCompletionItemCaption=class(TCollectionItem)
    private
      FAutoSize: Boolean;
      FAlignment: TAlignment;
      FCaption: string;
      FWidth: Integer;
      FFont: TFont;
      FBrush: TBrush;
      FPen: TPen;
      procedure SetAutoSize(Value: Boolean);
      procedure SetAlignment(Value: TAlignment);
      procedure SetWidth(Value: Integer);
      procedure SetFont(Value: TFont);
      procedure SetBrush(Value: TBrush);
      procedure SetPen(Value: TPen);
      procedure SetCaption(Value: string);
    public
      constructor Create(Collection: TCollection); override;
      destructor Destroy;override;
      procedure Assign(Source: TPersistent); override;
    published
      property AutoSize: Boolean read FAutoSize write SetAutoSize;
      property Alignment: TAlignment read FAlignment write SetAlignment;
      property Caption: String read FCaption write SetCaption;
      property Width: Integer read FWidth write SetWidth;
      property Font: TFont read FFont write SetFont;
      property Brush: TBrush read FBrush write SetBrush;
      property Pen: TPen read Fpen write SetPen;
  end;

  TCompletionItemCaptionClass=class of TCompletionItemCaption;
  TCompletionItem=class;

  TCompletionItemCaptions=class(TCollection)
  private
    FItem: TCompletionItem;
    function GetCompletionItemCaption(Index: Integer): TCompletionItemCaption;
    procedure SetCompletionItemCaption(Index: Integer; Value: TCompletionItemCaption);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TCompletionItem; CompletionItemCaptionClass: TCompletionItemCaptionClass);
    function  Add: TCompletionItemCaption;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TCompletionItemCaption;
    property Items[Index: Integer]: TCompletionItemCaption read GetCompletionItemCaption write SetCompletionItemCaption;
  end;

  TCompletionItem=class(TCollectionItem)
  private
    FImageIndex: TImageIndex;
    FCaption: String;
    FCaptionEx: TCompletionItemCaptions;
    FFont: TFont;
    FBrush: TBrush;
    FPen: TPen;
    FInsertedText: TStrings;
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetCaption(Value: string);
    procedure SetFont(Value: TFont);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetCaptionEx(Value: TCompletionItemCaptions);
    procedure SetInsertedText(Value: TStrings);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: String read FCaption write SetCaption;
    property CaptionEx: TCompletionItemCaptions read FCaptionEx write SetCaptionEx;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex;
    property Font: TFont read FFont write SetFont;
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read Fpen write SetPen;
    property InsertedText: TStrings read FInsertedText write SetInsertedText;
  end;

  TCompletionItemClass=class of TCompletionItem;

  TCompletionItems=class(TCollection)
  private
    FNoUseListBox: Boolean;
    FCompletion: TCompletion;
    function GetCompletionItem(Index: Integer): TCompletionItem;
    procedure SetCompletionItem(Index: Integer; Value: TCompletionItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TCompletion; CompletionItemClass: TCompletionItemClass);
    destructor Destroy; override;
    function  Add: TCompletionItem;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate; override;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure EndUpdate; override;
    function Insert(Index: Integer): TCompletionItem;
    property Completion: TCompletion read FCompletion;
    property Items[Index: Integer]: TCompletionItem read GetCompletionItem write SetCompletionItem;
  end;

  TCompletionList = (cmIdentifers, cmTemplates);

  TCompletion = class(TPersistent)
  private
    FDefItemHeight: Integer;
    FRAEditor: TRACustomEditor;
    FPopupList: TListBox;
    FIdentifers: TCompletionItems;
    FTemplates: TCompletionItems;
    FItems: TCompletionItems;
    FItemindex: integer;
    FMode: TCompletionList;
    FDefMode: TCompletionList;
    FTimer: TTimer;
    FEnabled: boolean;
    FVisible: boolean;
    FDropDownCount: integer;
    FDropDownWidth: integer;
    FCaretChar: char;
{    FCRLF: string;
    FSeparator: string;}
    function DoKeyDown(Key: Word; Shift: TShiftState): boolean;
    procedure DoKeyPress(Key: Char);
    procedure OnTimer(Sender: TObject);
    procedure FindSelItem(var Eq: boolean);
    procedure ReplaceWord(const NewString: string);

    procedure SetStrings(index: integer; AValue: TCompletionItems);
    function GetItemindex: integer;
    procedure SetItemindex(AValue: integer);
    function Getinterval: cardinal;
    procedure Setinterval(AValue: cardinal);
    procedure MakeItems;
    function GetItems: TCompletionItems;
    procedure SetItemHeight(Value: Integer);
    function GetItemHeight: Integer;
    procedure SetDropDownWidth(Value: Integer);
    procedure SetDropDownCount(Value: Integer);
  protected

   
  public
    constructor Create2(ARAEditor: TRACustomEditor);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure DropDown(const AMode: TCompletionList; const ShowAlways: boolean);
    procedure DoCompletion(const AMode: TCompletionList);
    procedure CloseUp(const Apply: boolean);
    procedure SelectItem;
    property Itemindex: integer read GetItemindex write SetItemindex;
    property Visible: boolean read FVisible write FVisible;
    property Mode: TCompletionList read FMode write FMode;
    property Items: TCompletionItems read FItems;
  published
    property DropDownCount: integer read FDropDownCount write SetDropDownCount default 6;
    property DropDownWidth: integer read FDropDownWidth write SetDropDownWidth default 300;
    property Enabled: boolean read FEnabled write FEnabled default false;
    property Identifers: TCompletionItems index 0 read FIdentifers write SetStrings;
    property Templates: TCompletionItems index 1 read FTemplates write SetStrings;
    property ItemHeight: Integer read GetItemHeight write SetItemHeight;
    property Interval: Cardinal read Getinterval write Setinterval;

    property CaretChar: char read FCaretChar write FCaretChar;
{    property CRLF: string read FCRLF write FCRLF;
    property Separator: string read FSeparator write FSeparator;}
  end;
  {$ENDIF RAEDITOR_COMPLETION}

const

 { Editor commands }
 { When add new commands, please add them into RAI2_RAEditor.pas unit also ! }

  ecCharFirst = $00;
  ecCharLast = $FF;
  ecCommandFirst = $100;
  ecUser = $8000; { use this for descendants }

  {Cursor}
  ecLeft = ecCommandFirst + 1;
  ecUp = ecLeft + 1;
  ecRight = ecLeft + 2;
  ecDown = ecLeft + 3;
  {Cursor with select}
  ecSelLeft = ecCommandFirst + 9;
  ecSelUp = ecSelLeft + 1;
  ecSelRight = ecSelLeft + 2;
  ecSelDown = ecSelLeft + 3;
  {Cursor по словам}
  ecPrevWord = ecSelDown + 1;
  ecNextWord = ecPrevWord + 1;
  ecSelPrevWord = ecPrevWord + 2;
  ecSelNextWord = ecPrevWord + 3;
  ecSelWord = ecPrevWord + 4;

  ecWindowTop = ecSelWord + 1;
  ecWindowBottom = ecWindowTop + 1;
  ecPrevPage = ecWindowTop + 2;
  ecNextPage = ecWindowTop + 3;
  ecSelPrevPage = ecWindowTop + 4;
  ecSelNextPage = ecWindowTop + 5;

  ecBeginLine = ecSelNextPage + 1;
  ecEndLine = ecBeginLine + 1;
  ecBeginDoc = ecBeginLine + 2;
  ecEndDoc = ecBeginLine + 3;
  ecSelBeginLine = ecBeginLine + 4;
  ecSelEndLine = ecBeginLine + 5;
  ecSelBeginDoc = ecBeginLine + 6;
  ecSelEndDoc = ecBeginLine + 7;
  ecSelAll = ecBeginLine + 8;

  ecScrollLineUp = ecSelAll + 1;
  ecScrollLineDown = ecScrollLineUp + 1;

  ecinclusiveBlock = ecCommandFirst + 100;
  ecLineBlock = ecCommandFirst + 101;
  ecColumnBlock = ecCommandFirst + 102;
  ecNoninclusiveBlock = ecCommandFirst + 103;

  ecinsertPara = ecCommandFirst + 121;
  ecBackspace = ecinsertPara + 1;
  ecDelete = ecinsertPara + 2;
  ecChangeinsertMode = ecinsertPara + 3;
  ecTab = ecinsertPara + 4;
  ecBackTab = ecinsertPara + 5;
  ecindent = ecinsertPara + 6;
  ecUnindent = ecinsertPara + 7;

  ecDeleteSelected = ecinsertPara + 10;
  ecClipboardCopy = ecinsertPara + 11;
  ecClipboardCut = ecClipboardCopy + 1;
  ecClipBoardPaste = ecClipboardCopy + 2;

  ecDeleteLine = ecClipBoardPaste + 1;
  ecDeleteWord = ecDeleteLine + 1;

  ecToUpperCase = ecDeleteLine + 2;
  ecToLowerCase = ecToUpperCase + 1;
  ecChangeCase = ecToUpperCase + 2;

  ecUndo = ecChangeCase + 1;
  ecRedo = ecUndo + 1;
  ecBeginCompound = ecUndo + 2; { not implemented }
  ecEndCompound = ecUndo + 3; { not implemented }

  ecBeginUpdate = ecUndo + 4;
  ecEndUpdate = ecUndo + 5;

  ecSetBookmark0 = ecEndUpdate + 1;
  ecSetBookmark1 = ecSetBookmark0 + 1;
  ecSetBookmark2 = ecSetBookmark0 + 2;
  ecSetBookmark3 = ecSetBookmark0 + 3;
  ecSetBookmark4 = ecSetBookmark0 + 4;
  ecSetBookmark5 = ecSetBookmark0 + 5;
  ecSetBookmark6 = ecSetBookmark0 + 6;
  ecSetBookmark7 = ecSetBookmark0 + 7;
  ecSetBookmark8 = ecSetBookmark0 + 8;
  ecSetBookmark9 = ecSetBookmark0 + 9;

  ecGotoBookmark0 = ecSetBookmark9 + 1;
  ecGotoBookmark1 = ecGotoBookmark0 + 1;
  ecGotoBookmark2 = ecGotoBookmark0 + 2;
  ecGotoBookmark3 = ecGotoBookmark0 + 3;
  ecGotoBookmark4 = ecGotoBookmark0 + 4;
  ecGotoBookmark5 = ecGotoBookmark0 + 5;
  ecGotoBookmark6 = ecGotoBookmark0 + 6;
  ecGotoBookmark7 = ecGotoBookmark0 + 7;
  ecGotoBookmark8 = ecGotoBookmark0 + 8;
  ecGotoBookmark9 = ecGotoBookmark0 + 9;

  ecCompletionIdentifers = ecGotoBookmark9 + 1;
  ecCompletionTemplates = ecCompletionIdentifers + 1;

  ecRecordMacro = ecCompletionTemplates + 1;
  ecPlayMacro = ecRecordMacro + 1;
  ecBeginRecord = ecRecordMacro + 2;
  ecEndRecord = ecRecordMacro + 3;

  // by TSV
  ecNewScript=ecEndRecord+1;
  ecOpenScript=ecNewScript+1;
  ecSaveScript=ecOpenScript+1;
  ecSaveScriptToBase=ecSaveScript+1;
  ecRunScript=ecSaveScriptToBase+1;
  ecStopScript=ecRunScript+1;
  ecResetScript=ecStopScript+1;
  ecCompileScript=ecResetScript+1;
  ecFind=ecCompileScript+1;
  ecFindNext=ecFind+1;
  ecReplace=ecFindNext+1;
  ecGotoLine=ecReplace+1;
  ecViewOption=ecGotoLine+1;
  ecViewForms=ecViewOption+1;

  twoKeyCommand = High(word);


type
  PCommandHint=^TCommandHint;
  TCommandHint=packed record
    Command: TEditCommand;
    Hint: String;
  end;

var
  ListCommandHint: TList;

  function GetCommandHint(Command: TEditCommand): PCommandHint;
  function GetHintScriptCommand(ACommand: TEditCommand; Default: string=''): string;
  function GetHintWithShortCutScriptCommand(SE: TRAEditor; ACommand: TEditCommand; Default: string=''): string;
  function GetShortCutScriptEditor(SE: TRAEditor; ACommand: TEditCommand): TShortCut;
  
implementation

uses Consts, Dialogs, RACtlConst, RAStrUtil, Menus;


{$IFDEF RAEDITOR_UNDO}

type

  TCaretUndo = class(TUndo)
  private
    FCaretX, FCaretY: integer;
  public
    constructor Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY: integer);
    procedure Undo; override;
    procedure Redo; override;
  end;

  TinsertUndo = class(TCaretUndo)
  private
    FText: string;
  public
    constructor Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY: integer;
      AText: string);
    procedure Undo; override;
  end;

  TOverwriteUndo = class(TCaretUndo)
  private
    FOldText: string;
    FNewText: string;
  public
    constructor Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY: integer;
      AOldText, ANewText: string);
    procedure Undo; override;
  end;

  TReLineUndo = class(TinsertUndo);

  TinsertTabUndo = class(TinsertUndo);

  TinsertColumnUndo = class(TinsertUndo)
  public
    procedure Undo; override;
  end;

  TDeleteUndo = class(TinsertUndo)
  public
    procedure Undo; override;
  end;

  TDeleteTrailUndo = class(TDeleteUndo);

  TBackspaceUndo = class(TDeleteUndo)
  public
    procedure Undo; override;
  end;

  TReplaceUndo = class(TCaretUndo)
  private
    FBeg, FEnd: integer;
    FText, FNewText: string;
  public
    constructor Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY: integer;
      ABeg, AEnd: integer; AText, ANewText: string);
    procedure Undo; override;
  end;

  TDeleteSelectedUndo = class(TDeleteUndo)
  private
    FSelBegX, FSelBegY, FSelEndX, FSelEndY: integer;
    FSelBlockFormat: TSelBlockFormat;
  public
    constructor Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY: integer;
      AText: string; ASelBlockFormat: TSelBlockFormat;
      ASelBegX, ASelBegY, ASelEndX, ASelEndY: integer);
    procedure Undo; override;
  end;

  TSelectUndo = class(TCaretUndo)
  private
    FSelected: boolean;
    FSelBlockFormat: TSelBlockFormat;
    FSelBegX, FSelBegY, FSelEndX, FSelEndY: integer;
  public
    constructor Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY: integer;
      ASelected: boolean; ASelBlockFormat: TSelBlockFormat;
      ASelBegX, ASelBegY, ASelEndX, ASelEndY: integer);
    procedure Undo; override;
  end;

  TUnselectUndo = class(TSelectUndo);

  TBeginCompoundUndo = class(TUndo)
  public
    procedure Undo; override;
  end;

  TEndCompoundUndo = class(TBeginCompoundUndo);

  {$ENDIF RAEDITOR_UNDO}

var
  BlockTypeFormat: integer;

{********************* Debug ***********************}

{
procedure Debug(const S: string);
begin
  Tracer.Writeln(S);
end;

procedure BeginTick;
begin
  Tracer.TimerStart(1);
end;

procedure EndTick;
begin
  Tracer.TimerStop(1);
end;
}
{#################### Debug ######################}

procedure Err;
begin
  MessageBeep(0);
end;

function KeyPressed(VK : integer) : boolean;
begin
  Result := GetKeyState(VK) and $8000 = $8000;
end;

function Max(x,y:integer):integer;
begin
  if x > y then Result := x else Result := y;
end;

function Min(x,y:integer):integer;
begin
  if x < y then Result := x else Result := y;
end;

{$IFDEF RA_D2}
function CompareMem(P1, P2: Pointer; Length: integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,1
        SHR     ECX,1
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    inC     EAX
@@2:    POP     EDI
        POP     ESI
end;
{$ENDIF RA_D2}

{************************* TRAControlScrollBar95 ****************************}
constructor TRAControlScrollBar95.Create;
begin
  FPage := 1;
  FSmallChange := 1;
  FLargeChange := 1;
end;

const
  SBKinD : array[TScrollBarKind] of integer = (SB_HORZ, SB_VERT);

procedure TRAControlScrollBar95.SetParams(AMin, AMax, APosition, APage : integer);
var
  SCROLLinFO : TSCROLLinFO;
begin
  if AMax < AMin then
    raise EinvalidOperation.Create(SScrollBarRange);
  if APosition < AMin then APosition := AMin;
  if APosition > AMax then APosition := AMax;
  if Handle > 0 then begin
    with SCROLLinFO do begin
      cbSize := sizeof(TSCROLLinFO);
      fMask := SIF_DISABLENOSCROLL;
      if (AMin >= 0) or (AMax >= 0) then fMask := fMask or SIF_RANGE;
      if APosition >= 0 then fMask := fMask or SIF_POS;
      if APage >= 0 then fMask := fMask or SIF_PAGE;
      nPos := APosition;
      nMin := AMin;
      nMax := AMax;
      nPage := APage;
    end;
    SetScrollinfo(
      Handle,         // handle of window with scroll bar
      SBKinD[Kind] ,  // scroll bar flag
      SCROLLinFO,     // pointer to structure with scroll parameters
      true            // redraw flag
    );
  end;
end;

procedure TRAControlScrollBar95.SetParam(index, Value: integer);
begin
  case index of
    0 : FMin := Value;
    1 : FMax := Value;
    2 : FPosition := Value;
    3 : FPage := Value;
  end;
  if FMax < FMin then
    raise EinvalidOperation.Create(SScrollBarRange);
  if FPosition < FMin then FPosition := FMin;
  if FPosition > FMax then FPosition := FMax;
  SetParams(FMin, FMax, FPosition, FPage);
end;

{
procedure TRAControlScrollBar95.SetVisible(Value : boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    if Handle <> 0 then

  end;
end;
}

procedure TRAControlScrollBar95.DoScroll(var Message: TWMScroll);
var
  ScrollPos: integer;
  NewPos: Longint;
  Scrollinfo: TScrollinfo;
begin
  with Message do
  begin
    NewPos := FPosition;
    case TScrollCode(ScrollCode) of
      scLineUp:
        Dec(NewPos, FSmallChange);
      scLineDown:
        inc(NewPos, FSmallChange);
      scPageUp:
        Dec(NewPos, FLargeChange);
      scPageDown:
        inc(NewPos, FLargeChange);
      scPosition, scTrack:
        with Scrollinfo do
        begin
          cbSize := SizeOf(Scrollinfo);
          fMask := SIF_ALL;
          GetScrollinfo(Handle, SBKinD[Kind], Scrollinfo);
          NewPos := nTrackPos;
        end;
      scTop:
        NewPos := FMin;
      scBottom:
        NewPos := FMax;
    end;
    if NewPos < FMin then NewPos := FMin;
    if NewPos > FMax then NewPos := FMax;
    ScrollPos := NewPos;
    Scroll(TScrollCode(ScrollCode), ScrollPos);
  end;
  Position := ScrollPos;
end;

procedure TRAControlScrollBar95.Scroll(ScrollCode: TScrollCode; var ScrollPos: integer);
begin
  if Assigned(FOnScroll) then FOnScroll(Self, ScrollCode, ScrollPos);
end;

{ TFindText }

constructor TFindTxt.Create(Editor: TRACustomEditor);
begin
  Text:='';
  FEditor:=Editor;
  FVisible:=false;
  FStartPoint:=Point(0,0);
  FPosition:=0;
end;

procedure TFindTxt.SetVisible(Value: Boolean);
var
  nCaretX,nCaretY: integer;
begin
  if Value<>FVisible then begin
    FVisible:=Value;
    FEditor.CaretFromPos(Position,nCaretX,nCaretY);
    FEditor.PaintLine(nCaretY,0,Max_X);
    FEditor.Invalidate;
  end;
end;

procedure TFindTxt.SetPosition(Value: integer);
var
  nCaretX,nCaretY: integer;
begin
  if Value<>FPosition then begin
    FPosition:=Value;
    FEditor.CaretFromPos(FPosition,nCaretX,nCaretY);
    FStartPoint.y:=(nCaretY+1)*FEditor.CellRect.Height;
    FStartPoint.x:=(nCaretX-1)*FEditor.CellRect.Width+FEditor.GutterWidth;
  end;
end;

{ TErrorLine }

constructor TErrorLine.Create(Editor: TRACustomEditor);
begin
  Line:=-1;
  Column:=-1;
  FEditor:=Editor;
  FVisible:=false;
end;

procedure TErrorLine.SetVisible(Value: Boolean);
begin
  if Value<>FVisible then begin
    FVisible:=Value;
    FEditor.SetCaretXY(Column,Line);
    FEditor.PaintLine(Line,0,Max_X);
    FEditor.Invalidate;
  end;
end;

{######################### TRAControlScrollBar95 #########################}

constructor TEditorStrings.Create;
begin
  inherited Create;
  OnChange := StringsChanged;
end;

procedure TEditorStrings.SetTextStr(const Value: string);
begin
  inherited SetTextStr(FRAEditor.ExpandTabs(Value));
 {$IFDEF RAEDITOR_UNDO}
  if FRAEditor.FUpdateLock = 0 then FRAEditor.NotUndoable;
 {$ENDIF RAEDITOR_UNDO}
  FRAEditor.TextAllChanged;
end;

procedure TEditorStrings.StringsChanged(Sender: TObject);
begin
  if FRAEditor.FUpdateLock = 0 then 
    FRAEditor.TextAllChanged;
end;

procedure TEditorStrings.SetLockText(Text: string);
begin
  inc(FRAEditor.FUpdateLock);
  try
    inherited SetTextStr(Text)
  finally
    dec(FRAEditor.FUpdateLock);
  end;
end;

procedure TEditorStrings.Setinternal(index: integer; value: string);
begin
  inc(FRAEditor.FUpdateLock);
  try
    inherited Strings[index] := Value;
  finally
    dec(FRAEditor.FUpdateLock);
  end;
end;

function TEditorStrings.Add(const S: string): integer;
begin
  //inc(FRAEditor.FUpdateLock);
  try
    Result := inherited Add(FRAEditor.ExpandTabs(S));
  finally
    //dec(FRAEditor.FUpdateLock);
  end;
end;

procedure TEditorStrings.insert(index: integer; const S: string);
begin
  //inc(FRAEditor.FUpdateLock);
  try
    inherited insert(index, FRAEditor.ExpandTabs(S));
  finally
    //dec(FRAEditor.FUpdateLock);
  end;
end;

procedure TEditorStrings.Put(index: integer; const S: string);
{$IFDEF RAEDITOR_UNDO}
var
  L: integer;
  {$ENDIF RAEDITOR_UNDO}
begin
  if FRAEditor.FKeepTrailingBlanks then
    inherited Put(index, S)
  else
  begin
    {$IFDEF RAEDITOR_UNDO}
    L := Length(S) - Length(TrimRight(S));
    if L > 0 then
      TDeleteTrailUndo.Create(FRAEditor, Length(S), index, Spaces(L));
    {$ENDIF RAEDITOR_UNDO}
    inherited Put(index, TrimRight(S));
  end;
end;

procedure TEditorStrings.ReLine;
var
  L: integer;
begin
  inc(FRAEditor.FUpdateLock);
  try
    {$IFDEF RAEDITOR_UNDO}
    if Count = 0 then
      L := FRAEditor.FCaretX
    else
      L := Length(Strings[Count - 1]);
    while FRAEditor.FCaretY > Count - 1 do
    begin
      TReLineUndo.Create(FRAEditor, L, FRAEditor.FCaretY, #13#10);
      L := 0;
      Add('');
    end;
    {$ENDIF RAEDITOR_UNDO}
    if FRAEditor.FCaretX > Length(Strings[FRAEditor.FCaretY]) then
    begin
      L := FRAEditor.FCaretX - Length(Strings[FRAEditor.FCaretY]);
      {$IFDEF RAEDITOR_UNDO}
      TReLineUndo.Create(FRAEditor, Length(Strings[FRAEditor.FCaretY]),
        FRAEditor.FCaretY, Spaces(L));
      {$ENDIF RAEDITOR_UNDO}
      inherited Put(FRAEditor.FCaretY, Strings[FRAEditor.FCaretY] + Spaces(L));
    end;
  finally
    dec(FRAEditor.FUpdateLock);
  end;
end; { ReLine }

procedure TEditorStrings.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: string;
const
  ReadSize=4096;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetString(s, nil, Size);

    Stream.Read(Pointer(S)^, Size);
    SetTextStr(S);

  finally
    EndUpdate;
  end;
end;

{ TEditorClient }

function TEditorClient.GetCanvas: TCanvas;
begin
  Result := FRAEditor.Canvas;
end;

function TEditorClient.Left: integer;
begin
  Result := FRAEditor.GutterWidth + 2;
end;

function TEditorClient.Height: integer;
begin
  Result := FRAEditor.ClientHeight;
end;

function TEditorClient.Width: integer;
begin
  Result := Max(FRAEditor.ClientWidth - Left, 0);
end;

function TEditorClient.ClientWidth: integer;
begin
  Result := Width;
end;

function TEditorClient.ClientHeight: integer;
begin
  Result := Height;
end;

function TEditorClient.ClientRect: TRect;
begin
  Result := Bounds(Left, Top, Width, Height);
end;

function TEditorClient.BoundsRect: TRect;
begin
  Result := Bounds(0, 0, Width, Height);
end;

procedure TGutter.invalidate;
{var
  R : TRect;}
begin
  //  Owner.invalidate;
  //  R := Bounds(0, 0, FRAEditor.GutterWidth, FRAEditor.Height);
  //  invalidateRect(FRAEditor.Handle, @R, false);
  Paint;
end;

procedure TGutter.Paint;
begin
  with FRAEditor, Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := FGutterColor;
    FillRect(Bounds(0, FEditorClient.Top, GutterWidth, FEditorClient.Height));
    Pen.Width := 1;
    Pen.Color := clWhite;
    MoveTo(GutterWidth-1 , FEditorClient.Top);
    LineTo(GutterWidth-1, FEditorClient.Top + FEditorClient.Height);
    Pen.Width := 1;
    Pen.Color := clGray;
    MoveTo(GutterWidth , FEditorClient.Top);
    LineTo(GutterWidth , FEditorClient.Top + FEditorClient.Height);
    Pen.Width := 1;
    Pen.Color := Color;
    MoveTo(GutterWidth+1 , FEditorClient.Top);
    LineTo(GutterWidth+1 , FEditorClient.Top + FEditorClient.Height);
  end;
  with FRAEditor do
    GutterPaint(Canvas);
end;



{*********************** TRACustomEditor ***********************}

constructor TRACustomEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents {, csOpaque}, csDoubleClicks,
    csReplicatable];
  FinsertMode := true;
  FLines := TEditorStrings.Create;
  FLines.FRAEditor := self;
  FKeyboard := TKeyboard.Create;
  FRows := 1;
  FCols := 1;
  {$IFDEF RAEDITOR_UNDO}
  FUndoBuffer := TUndoBuffer.Create;
  FUndoBuffer.FRAEditor := Self;
  FGroupUndo := true;
  {$ENDIF RAEDITOR_UNDO}

  FRightMarginVisible := true;
  FRightMargin := 80;
  FBorderStyle := bsSingle;
  Ctl3d := true;
  Height := 40;
  Width := 150;
  ParentColor := false;
  Cursor := crIBeam;
  TabStop := true;
  FTabStops := '3 5';
  FSmartTab := true;
  FBackSpaceUnindents := true;
  FAutoindent := true;
  FKeepTrailingBlanks := false;
  FCursorBeyondEOF := false;

  FScrollBars := ssBoth;
  scbHorz := TRAControlScrollBar95.Create;
  scbVert := TRAControlScrollBar95.Create;
  scbVert.Kind := sbVertical;
  scbHorz.OnScroll := ScrollBarScroll;
  scbVert.OnScroll := ScrollBarScroll;

  Color := clWindow;
  FGutterColor := clBtnFace;
  FclSelectBC := clHighLight;
  FclSelectFC := clHighLightText;
  FRightMarginColor := clSilver;

  FEditorClient := TEditorClient.Create;
  FEditorClient.FRAEditor := Self;
  FGutter := TGutter.Create;
  FGutter.FRAEditor := Self;

  FLeftCol := 0;
  FTopRow := 0;
  FSelected := false;
  FCaretX := 0;
  FCaretY := 0;

  timerScroll := TTimer.Create(Self);
  timerScroll.Enabled := false;
  timerScroll.interval := 100;
  timerScroll.OnTimer := ScrollTimer;

  timerHint:=TTimer.Create(Self);
  timerHint.Enabled := false;
  timerHint.interval := 500;
  timerHint.OnTimer := HintTimer;

  {$IFDEF RAEDITOR_EDITOR}

  {$IFDEF RAEDITOR_DEFLAYOT}
  FKeyboard.SetDefLayot;
  {$ENDIF RAEDITOR_DEFLAYOT}

  {$IFDEF RAEDITOR_COMPLETION}
  FCompletion := TCompletion.Create2(Self);
  {$ENDIF RAEDITOR_COMPLETION}

  {$ENDIF RAEDITOR_EDITOR}

  FSyntaxHighlighting:=true;
  
  FSelBlockFormat := bfNoninclusive;
  if BlockTypeFormat = 0 then
    BlockTypeFormat := RegisterClipboardFormat('Borland IDE Block Type');

  { we can change font only after all objects are created }
  Font.Name := 'Courier New';
  Font.Size := 10;

  // by TSV
  FFindTxt:=TFindTxt.Create(Self);
  FErrorLine:=TErrorLine.Create(Self);
end;

destructor TRACustomEditor.Destroy;
begin
  FLines.Free;
  scbHorz.Free;
  scbVert.Free;
  FEditorClient.Free;
  FKeyboard.Free;
  {$IFDEF RAEDITOR_EDITOR}
  {$IFDEF RAEDITOR_UNDO}
  FUndoBuffer.Free;
  {$ENDIF RAEDITOR_UNDO}
  {$IFDEF RAEDITOR_COMPLETION}
  FCompletion.Free;
  {$ENDIF RAEDITOR_COMPLETION}
  {$ENDIF RAEDITOR_EDITOR}
  FGutter.Free;

  // by TSV
  FFindTxt.Free;
  FErrorLine.Free;
  
  inherited Destroy;
end;

procedure TRACustomEditor.Loaded;
begin
  inherited Loaded;
  UpdateEditorSize;
  {  Rows := FLines.Count;
    Cols := Max_X; }
end;

{************** Управление отрисовкой ***************}

procedure TRACustomEditor.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of cardinal = (0, WS_BORDER);
  ScrollStyles: array[TScrollStyle] of cardinal = (0, WS_HSCROLL, WS_VSCROLL,
    WS_HSCROLL or WS_VSCROLL);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle] or ScrollStyles[FScrollBars];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

{$IFNDEF RA_D4H}

procedure TRACustomEditor.WMSize(var Message: TWMSize);
begin
  inherited;
  if not (csLoading in ComponentState) then Resize;
end;
{$ENDIF RA_D4H}

procedure TRACustomEditor.Resize;
begin
  UpdateEditorSize;
end;

procedure TRACustomEditor.CreateWnd;
begin
  inherited CreateWnd;
  if FScrollBars in [ssHorizontal, ssBoth] then
    scbHorz.Handle := Handle;
  if FScrollBars in [ssVertical, ssBoth] then
    scbVert.Handle := Handle;
  FAllRepaint := true;
end;

procedure TRACustomEditor.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TRACustomEditor.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if HandleAllocated then UpdateEditorSize;
end;

procedure TRACustomEditor.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  {$IFDEF RAEDITOR_NOOPTIMIZE}
  inherited;
  Message.Result := 1;
  {$ELSE}
  Message.Result := 0;
  {$ENDIF}
end;

procedure TRACustomEditor.PaintSelection;
var
  iR: integer;
begin
  for iR := FUpdateSelBegY to FUpdateSelEndY do
    PaintLine(iR, -1, -1);
end;

procedure TRACustomEditor.SetUnSelected;
begin
  if FSelected then
  begin
    FSelected := false;
    {$IFDEF RAEDITOR_UNDO}
    TUnselectUndo.Create(Self, FCaretX, FCaretY, FSelected, FSelBlockFormat,
      FSelBegX, FSelBegY, FSelEndX, FSelEndY);
    {$ENDIF RAEDITOR_UNDO}

    //SelLength:=0;
 //   SelStart:=0;
    PaintSelection;
  end;
end;

procedure TRACustomEditor.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  if (P.X < GutterWidth) and (Cursor = crIBeam) then
  begin
    Message.Result := 1;
    Windows.SetCursor(Screen.Cursors[crArrow])
  end
  else
    inherited;
end;
{############## Управление отрисовкой ###############}

{************** Отрисовка ***************}

{
function IsRectEmpty(R: TRect): boolean;
begin
  Result := (R.Top = R.Bottom) and (R.Left = R.Right);
end;
}

function TRACustomEditor.CalcCellRect(const X, Y: integer): TRect;
begin
  Result := Bounds(
    FEditorClient.Left + X * FCellRect.Width + 1,
    FEditorClient.Top + Y * FCellRect.Height,
    FCellRect.Width,
    FCellRect.Height)
end;

procedure TRACustomEditor.Paint;
var
  iR: integer;
  ECR: TRect;
  BX, EX, BY, EY: integer;
begin
  if FUpdateLock > 0 then exit;
  {$IFDEF RAEDITOR_NOOPTIMIZE}
  FAllRepaint := true;
  {$ENDIF}
  {оптимизировано - отрисовывается только необходимая часть}
  PaintCaret(false);

  ECR := FEditorClient.Canvas.ClipRect;
  OffsetRect(ECR, -FGutterWidth, 0);
  if FAllRepaint then ECR := FEditorClient.BoundsRect;
  BX := ECR.Left div FCellRect.Width - 1;
  EX := ECR.Right div FCellRect.Width + 1;
  BY := ECR.Top div FCellRect.Height;
  EY := ECR.Bottom div FCellRect.Height + 1;
  for iR := BY to EY do
    PaintLine(FTopRow + iR, FLeftCol + BX, FLeftCol + EX);

  PaintCaret(true);
  FGutter.Paint;

  FAllRepaint := false;
end;

procedure TRACustomEditor.BeginUpdate;
begin
  inc(FUpdateLock);
end;

procedure TRACustomEditor.EndUpdate;
begin
  if FUpdateLock = 0 then Exit; { Error ? }
  dec(FUpdateLock);
  if FUpdateLock = 0 then
  begin
    FAllRepaint := True;
    UpdateEditorSize;
    StatusChanged;
    invalidate;
  end;
end;

procedure TRACustomEditor.UpdateEditorSize;
const
  BiggestSymbol = 'W';
var
  i: integer;
  //Wi, Ai: integer;
begin
  if (csLoading in ComponentState) then exit;
  FEditorClient.Canvas.Font := Font;
  FCellRect.Height := FEditorClient.Canvas.TextHeight(BiggestSymbol) + 1;

  // workaround the bug in Windows-9x
  // fixed by Dmitry Rubinstain
  FCellRect.Width := FEditorClient.Canvas.TextWidth(BiggestSymbol + BiggestSymbol) div 2;

  //Ai := FEditorClient.Canvas.TextWidth('W');
  //FEditorClient.Canvas.Font.Style := [fsBold];
  //Wi := FEditorClient.Canvas.TextWidth('w');
  //FCellRect.Width := (Wi+Ai) div 2;

  for i := 0 to 1024 do
    MyDi[i]:= FCellRect.Width;

  FVisibleColCount := Trunc(FEditorClient.ClientWidth / FCellRect.Width);
  FVisibleRowCount := Trunc(FEditorClient.ClientHeight / FCellRect.Height);
  FLastVisibleCol := FLeftCol + FVisibleColCount - 1;
  FLastVisibleRow := FTopRow + FVisibleRowCount - 1;
  Rows := FLines.Count;
  Cols := Max_X_Scroll;
  scbHorz.Page := FVisibleColCount;
  scbVert.Page := FVisibleRowCount;
  scbHorz.LargeChange := Max(FVisibleColCount, 1);
  scbVert.LargeChange := Max(FVisibleRowCount, 1);
  scbVert.Max := Max(1, FRows - 1 + FVisibleRowCount -1);
  FGutter.invalidate;
end;

procedure TRACustomEditor.PaintLine(const Line: integer; ColBeg, ColEnd:
  integer);                        
var
  Ch: string;
  R: TRect;
  i, iC, jC, SL, MX: integer;
  S: string;
  LA: TLineAttr;
begin
  if (Line < FTopRow) or (Line > FTopRow + FVisibleRowCount) then exit;
  // Debug('PaintLine '+intToStr(Line));
  if ColBeg < FLeftCol then
    ColBeg := FLeftCol;
  if (ColEnd < 0) or (ColEnd > FLeftCol + FVisibleColCount) then
    ColEnd := FLeftCol + FVisibleColCount;
  ColEnd := Min(ColEnd, Max_X - 1);
  i := ColBeg;
  if (Line > -1) and (Line < FLines.Count) {and (Length(FLines[Line]) > 0)} then
    with FEditorClient do
    begin
      S := FLines[Line];
      GetLineAttr(S, Line, ColBeg, ColEnd);

      {left line}
      Canvas.Brush.Color := LineAttrs[FLeftCol+1].BC;
      Canvas.FillRect(Bounds(FEditorClient.Left, (Line - FTopRow) *
        FCellRect.Height, 1, FCellRect.Height));

      {optimized, paint group of chars with identical attributes}
      SL := Length(S);
     { if SL > ColEnd then
        MX := ColEnd
      else
        MX := SL; }
      MX := ColEnd;

      i := ColBeg;
      while i < MX do
        with Canvas do
        begin
          iC := i + 1;
          LA := LineAttrs[iC];
          jC := iC + 1;
          if iC <= SL then
            Ch := S[iC]
          else
            Ch := ' ';
          while (jC <= MX + 1) and
            CompareMem(@LA, @LineAttrs[jC], sizeof(LineAttrs[1])) do
          begin
            if jC <= SL then
              Ch := Ch + S[jC]
            else
              Ch := Ch + ' ';
            inc(jC);
          end;

           Brush.Color := LA.BC;
           Font.Color := LA.FC;
           Font.Style := LA.Style;

          R := CalcCellRect(i - FLeftCol, Line - FTopRow);
          {bottom line}
          FillRect(Bounds(R.Left, R.Bottom - 1, FCellRect.Width * Length(Ch), 1));

          // add by patofan
          if (i = ColBeg) and (i < SL) {$IFDEF RA_D3H} and
              (StrByteType( pchar( s ), i ) = mbTrailByte) {$ENDIF} then
          begin
            R.Right := R.Left + FCellRect.Width * Length(Ch) ;
            Ch :=  S[ i ] + Ch;
            TextRect( R , R.left - FCellRect.Width , R.top , Ch );
          end
          else
          begin
            // ending add by patofan
            //Self.Canvas.TextOut(R.Left, R.Top, Ch);
            ExtTextOut(Canvas.Handle,R.Left,R.Top,0,nil,PChar(Ch),Length(Ch),@MyDi);
            // add by patofan
          end;
          // ending add by patofan

          i := jC - 1;
        end;
    end
  else
  begin
    FEditorClient.Canvas.Brush.Color := Color;
    FEditorClient.Canvas.FillRect(Bounds(FEditorClient.Left, (Line - FTopRow) *
      FCellRect.Height, 1, FCellRect.Height));
  end;
  {right part}
  R := Bounds(CalcCellRect(i - FLeftCol, Line - FTopRow).Left,
    (Line - FTopRow) * FCellRect.Height,
    (FLeftCol + FVisibleColCount - i + 2) * FCellRect.Width,
    FCellRect.Height);
  {if the line is selected, paint right empty space with selected background}
  if FSelected and (FSelBlockFormat in [bfinclusive, bfLine, bfNoninclusive]) and
     (Line >= FSelBegY) and (Line < FSelEndY) then
    FEditorClient.Canvas.Brush.Color := FclSelectBC
  else
    FEditorClient.Canvas.Brush.Color := Color;
  FEditorClient.Canvas.FillRect(R);
  DrawRightMargin;
end;

procedure TRACustomEditor.GetLineAttr(var Str: string; Line, ColBeg, ColEnd: integer);

  procedure ChangeSelectedAttr;

    procedure DoChange(const iBeg, iEnd: integer);
    var
      i: integer;
    begin
      for i := iBeg to iEnd do
      begin
        LineAttrs[i + 1].FC := FclSelectFC;
        LineAttrs[i + 1].BC := FclSelectBC;
      end;
    end;

  begin
    if FSelBlockFormat = bfColumn then
    begin
      if (Line >= FSelBegY) and (Line <= FSelEndY) then
        DoChange(FSelBegX, FSelEndX - 1 + integer(1{always inclusive}))
    end
    else
    begin
      if (Line = FSelBegY) and (Line = FSelEndY) then
        DoChange(FSelBegX, FSelEndX - 1 + integer(FSelBlockFormat = bfinclusive))
      else
      begin
        if Line = FSelBegY then DoChange(FSelBegX, FSelBegX + FVisibleColCount);
        if (Line > FSelBegY) and (Line < FSelEndY) then DoChange(ColBeg, ColEnd);
        if Line = FSelEndY then
          DoChange(ColBeg, FSelEndX - 1 + integer(FSelBlockFormat = bfinclusive));
      end;
    end;
  end;
var
  i: integer;
  S: string;
begin
   LineAttrs[ColBeg].FC := Font.Color;
   LineAttrs[ColBeg].Style := Font.Style;
   LineAttrs[ColBeg].BC := Color;
   for i := ColBeg to ColEnd + 1 do
    Move(LineAttrs[ColBeg], LineAttrs[i], sizeof(LineAttrs[1]));
   S := FLines[Line];
   if FSyntaxHighlighting then
    GetAttr(Line, ColBeg, ColEnd);
   if Assigned(FOnGetLineAttr) then FOnGetLineAttr(Self, S, Line, LineAttrs);
   if FSelected then ChangeSelectedAttr; {изменяем атрибуты выделенного блока}
   ChangeAttr(Line, ColBeg, ColEnd);
end;

procedure TRACustomEditor.GetAttr(Line, ColBeg, ColEnd: integer);
begin
end;

procedure TRACustomEditor.ChangeAttr(Line, ColBeg, ColEnd: integer);
begin
end;

procedure TRACustomEditor.DrawRightMargin;
var
  F: integer;
begin
  if FRightMarginVisible and (FRightMargin > FLeftCol)
    and (FRightMargin < FLastVisibleCol + 3) then
    with FEditorClient.Canvas do
    begin
      {рисуем RightMargin Line}
      Pen.Color := FRightMarginColor;
      F := CalcCellRect(FRightMargin - FLeftCol, 0).Left;
      MoveTo(F, FEditorClient.Top);
      LineTo(F, FEditorClient.Top + FEditorClient.Height);
    end;
end;

{************************** Scroll **************************}

procedure TRACustomEditor.WMHScroll(var Message: TWMHScroll);
begin
  scbHorz.DoScroll(Message);
end;

procedure TRACustomEditor.WMVScroll(var Message: TWMVScroll);
begin
  scbVert.DoScroll(Message);
end;

procedure TRACustomEditor.WMMouseWheel(var Message: TWMMouseWheel);
begin
  scbVert.Position := scbVert.Position - Message.WheelDelta div 40;
  Scroll(true, scbVert.Position);
end;

procedure TRACustomEditor.ScrollBarScroll(Sender: TObject; ScrollCode:
  TScrollCode; var ScrollPos: integer);
begin
  case ScrollCode of
    scLineUp..scPageDown, {scPosition,} scTrack {, scEndScroll}:
      begin
        if Sender = scbVert then
          Scroll(true, ScrollPos)
        else if Sender = scbHorz then
          Scroll(false, ScrollPos);
      end;
  end;
  //  Tracer.Writeln(intToStr((Sender as TRAControlScrollBar95).Position));
end;

procedure TRACustomEditor.Scroll(const Vert: boolean; const ScrollPos: integer);
var
  R, RClip, RUpdate: TRect;
  OldFTopRow: integer;
  //  OldFLeftCol: integer;
begin
  //  BeginTick;
  if FUpdateLock = 0 then
  begin
    PaintCaret(false);
    if Vert then
    begin {Vertical Scroll}
      {оптимизировано}
      OldFTopRow := FTopRow;
      FTopRow := ScrollPos;
      if Abs((OldFTopRow - ScrollPos) * FCellRect.Height) < FEditorClient.Height
        then
      begin
        R := FEditorClient.ClientRect;
        R.Bottom := R.Top + CellRect.Height * (FVisibleRowCount + 1); {??}
        R.Left := 0; // update gutter 
        RClip := R;
        ScrollDC(
          FEditorClient.Canvas.Handle, // handle of device context
          0, // horizontal scroll units
          (OldFTopRow - ScrollPos) * FCellRect.Height, // vertical scroll units
          R, // address of structure for scrolling rectangle
          RClip, // address of structure for clipping rectangle
          0, // handle of scrolling region
          @RUpdate // address of structure for update rectangle
          );
        invalidateRect(Handle, @RUpdate, False);
      end
      else
        invalidate;
      Update;
    end
    else {Horizontal Scroll}
    begin
      {неоптимизировано}
      FLeftCol := ScrollPos;
      (*  OldFLeftCol := FLeftCol;
        FLeftCol := ScrollPos;
        if Abs((OldFLeftCol - ScrollPos) * FCellRect.Width) < FEditorClient.Width then
        begin
          R := FEditorClient.ClientRect;
          R.Right := R.Left + CellRect.Width * (FVisibleColCount + 1); {??}
          RClip := R;
          ScrollDC(
            FEditorClient.Canvas.Handle, // handle of device context
            (OldFLeftCol - ScrollPos) * FCellRect.Width, // horizontal scroll units
            0, // vertical scroll units
            R, // address of structure for scrolling rectangle
            RClip, // address of structure for clipping rectangle
            0, // handle of scrolling region
            @RUpdate // address of structure for update rectangle
            );
          invalidateRect(Handle, @RUpdate, False);
        end
        else
          invalidate;
        Update;  *)
      invalidate;
    end;
  end
  else { FUpdateLock > 0 }
  begin
    if Vert then
      FTopRow := ScrollPos
    else
      FLeftCol := ScrollPos;
  end;
  FLastVisibleRow := FTopRow + FVisibleRowCount - 1;
  FLastVisibleCol := FLeftCol + FVisibleColCount - 1;
  if FUpdateLock = 0 then
  begin
    DrawRightMargin;
    FGutter.Paint;
    PaintCaret(true);
  end;
  if Assigned(FOnScroll) then FOnScroll(Self);
  //  EndTick;
end;
{####################### Scroll #########################}
{####################### Painting - Отрисовка #######################}

{************** Caret ***************}

procedure TRACustomEditor.PaintCaret(const bShow: boolean);
var
  R: TRect;
begin
  // Debug('PaintCaret: ' + intToStr(integer(bShow)));
  if not bShow then
    HideCaret(Handle)
  else if Focused then
  begin
    R := CalcCellRect(FCaretX - FLeftCol, FCaretY - FTopRow);
    SetCaretPos(R.Left - 1, R.Top + 1);
    ShowCaret(Handle)
  end
end;

procedure TRACustomEditor.SetCaretinternal(X, Y: integer);
var
  R: TRect;
begin
  if (X = FCaretX) and (Y = FCaretY) then exit;
  //прокручивать изображение
  if not FCursorBeyondEOF then
    Y := Min(Y, FLines.Count - 1);
  Y := Max(Y, 0);
  X := Min(X, Max_X);
  X := Max(X, 0);
  if Y < FTopRow then
    SetLeftTop(FLeftCol, Y)
  else if Y > Max(FLastVisibleRow, 0) then
    SetLeftTop(FLeftCol, Y - FVisibleRowCount + 1);
  if X < 0 then X := 0;
  if X < FLeftCol then
    SetLeftTop(X, FTopRow)
  else if X > FLastVisibleCol then
    SetLeftTop(X - FVisibleColCount + 1, FTopRow);

  if Focused then  {mac: do not move Caret when not focused!}
  begin
    R := CalcCellRect(X - FLeftCol, Y - FTopRow);
    SetCaretPos(R.Left - 1, R.Top + 1);
  end;

  if Assigned(FOnChangeStatus) and ((FCaretX <> X) or (FCaretY <> Y)) then
  begin
    FCaretX := X;
    FCaretY := Y;
    FOnChangeStatus(Self);
  end;
  FCaretX := X;
  FCaretY := Y;
end;

procedure TRACustomEditor.SetCaret(X, Y: integer);
begin
  if (X = FCaretX) and (Y = FCaretY) then exit;
  {$IFDEF RAEDITOR_UNDO}
  TCaretUndo.Create(Self, FCaretX, FCaretY);
  {$ENDIF RAEDITOR_UNDO}
  SetCaretinternal(X, Y);
  if FUpdateLock = 0 then StatusChanged;
end;

procedure TRACustomEditor.SetCaretPosition(const index, Pos: integer);
begin
  if index = 0 then
    SetCaret(Pos, FCaretY)
  else
    SetCaret(FCaretX, Pos)
end;

procedure TRACustomEditor.WMSetFocus(var Message: TWMSetFocus);
begin
  CreateCaret(Handle, 0, 2, CellRect.Height - 2);
  PaintCaret(true);
end;

procedure TRACustomEditor.WMKillFocus(var Message: TWMSetFocus);
begin
  inherited;
  {$IFDEF RAEDITOR_COMPLETION}
  if FCompletion.FVisible then FCompletion.CloseUp(false);
  {$ENDIF RAEDITOR_COMPLETION}
  DestroyCaret;
end;

{############### Caret ###############}

{************** Keyboard ***************}

procedure TRACustomEditor.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTTAB or DLGC_WANTCHARS or DLGC_WANTMESSAGE;
end;

procedure TRACustomEditor.KeyDown(var Key: Word; Shift: TShiftState);
{$IFDEF RAEDITOR_EDITOR}
var
  Com: word;
{$ENDIF RAEDITOR_EDITOR}
begin
  {$IFDEF RAEDITOR_COMPLETION}
  if FCompletion.FVisible then
    if FCompletion.DoKeyDown(Key, Shift) then
      exit
    else
  else
    FCompletion.FTimer.Enabled := false;
  {$ENDIF RAEDITOR_COMPLETION}
  {$IFDEF RAEDITOR_EDITOR}
  if WaitSecondKey then
  begin
    Com := FKeyboard.Command2(Key1, Shift1, Key, Shift);
    WaitSecondKey := false;
    IgnoreKeyPress := true;
  end
  else
  begin
    inherited KeyDown(Key, Shift);
    Key1 := Key;
    Shift1 := Shift;
    Com := FKeyboard.Command(Key, Shift);
    if Com = twoKeyCommand then
    begin
      IgnoreKeyPress := true;
      WaitSecondKey := true;
    end
    else
      IgnoreKeyPress := Com > 0;
  end;
  if (Com > 0) and (Com <> twoKeyCommand) then
  begin
    Command(Com);
    Key := 0;
  end;
  {$IFDEF RAEDITOR_COMPLETION}
  if (Com = ecBackSpace) then
    FCompletion.DoKeyPress(#8);
  {$ENDIF RAEDITOR_COMPLETION}
  {$ENDIF RAEDITOR_EDITOR}
end;

{$IFDEF RAEDITOR_EDITOR}

procedure TRACustomEditor.ReLine;
begin
  FLines.ReLine;
end; { ReLine }

procedure TRACustomEditor.KeyPress(var Key: Char);
begin
  if IgnoreKeyPress then
  begin
    IgnoreKeyPress := false;
    exit
  end;
  if FReadOnly then exit;
  PaintCaret(false);
  inherited KeyPress(Key);

  Command(ord(Key));

  PaintCaret(true);
end;

procedure TRACustomEditor.insertChar(const Key: Char);
var
  S: string;
begin
  ReLine;
  case Key of
    #32..#255:
      begin
        {$IFDEF RAEDITOR_COMPLETION}
        if not HasChar(Key, RAEditorCompletionChars) then
          FCompletion.DoKeyPress(Key);
        {$ENDIF RAEDITOR_COMPLETION}
        begin
          DeleteSelected;
          S := FLines[FCaretY];
          if FinsertMode then
          begin
            {$IFDEF RAEDITOR_UNDO}
            TinsertUndo.Create(Self, FCaretX, FCaretY, Key);
            {$ENDIF RAEDITOR_UNDO}
            insert(Key, S, FCaretX + 1);
          end
          else
          begin
            {$IFDEF RAEDITOR_UNDO}
            if FCaretX + 1 <= Length(S) then
              TOverwriteUndo.Create(Self, FCaretX, FCaretY, S[FCaretX + 1], Key)
            else
              TOverwriteUndo.Create(Self, FCaretX, FCaretY, '', Key);
            {$ENDIF RAEDITOR_UNDO}
            if FCaretX + 1 <= Length(S) then
              S[FCaretX + 1] := Key
            else
              S := S + Key
          end;
          FLines.internal[FCaretY] := S;
          SetCaretinternal(FCaretX + 1, FCaretY);
          TextModified(SelStart, mainsert, Key);
          PaintLine(FCaretY, -1, -1);
          Changed;
        end;
        {$IFDEF RAEDITOR_COMPLETION}
        if HasChar(Key, RAEditorCompletionChars) then
          FCompletion.DoKeyPress(Key);
        {$ENDIF RAEDITOR_COMPLETION}
      end;
  end;
end;

{$ENDIF RAEDITOR_EDITOR}

{$IFDEF RAEDITOR_EDITOR}
type
  EComplete = class(EAbort);

procedure TRACustomEditor.Command(ACommand: TEditCommand);
var
  X, Y: integer;
  {$IFDEF RAEDITOR_UNDO}
  CaretUndo: boolean;
  {$ENDIF RAEDITOR_UNDO}
  // add by patofan
  K : integer;
  // ending add by patofan

type
  TPr = procedure of object;

  procedure DoAndCorrectXY(Pr: TPr);
  begin
    Pr;
    X := FCaretX;
    Y := FCaretY;
    {$IFDEF RAEDITOR_COMPLETION}
    CaretUndo := false;
    {$ENDIF RAEDITOR_COMPLETION}
  end;

  function Com(const Args: array of TEditCommand): boolean;
  var
    i: integer;
  begin
    for i := 0 to High(Args) do
      if Args[i] = ACommand then
      begin
        Result := true;
        exit;
      end;
    Result := false;
  end;

  procedure SetSel1(X, Y: integer);
  begin
    SetSel(X, Y);
    {$IFDEF RAEDITOR_UNDO}
    CaretUndo := False;
    {$ENDIF RAEDITOR_UNDO}
  end;

  procedure SetSelText1(S: string);
  begin
    SelText := S;
   {$IFDEF RAEDITOR_UNDO}
    CaretUndo := False;
   {$ENDIF RAEDITOR_UNDO}
  end;

var
  F: integer;
  S, S2: string;
  B: boolean;
  iBeg, iEnd: integer;
  // add by patofan
  deltastep : integer;
  // ending by patofan
begin
  X := FCaretX;
  Y := FCaretY;
  {$IFDEF RAEDITOR_UNDO}
  CaretUndo := true;
  {$ENDIF RAEDITOR_UNDO}
  PaintCaret(false);
  // inc(FUpdateLock);

  FFindTxt.Visible:=false;
  FErrorLine.Visible:=false;

 { macro recording }
  if FRecording and not Com([ecRecordMacro, ecBeginCompound]) and
     (FCompound = 0) then
    FMacro := FMacro + Char(Lo(ACommand)) + Char(Hi(ACommand));
  try
    // add by patofan
    deltastep := -1;
    // ending add by patofan
    case ACommand of

      { caret movements }

      ecLeft, ecRight, ecSelLeft, ecSelRight:
        begin
          if Com([ecSelLeft, ecSelRight]) and not FSelected then
            SetSel1(X, Y);
          if Com([ecLeft, ecSelLeft]) then
            dec(X)
          else
          begin
            inc(X);
            // add by patofan
            deltastep := 1;
            // ending add by patofan
          end;
          if Com([ecSelLeft, ecSelRight]) then
          begin
            // add by patofan
            {$IFDEF RA_D3H}
            CheckDoubleByteChar( x , y  , mbTrailByte , deltastep );
            {$ENDIF}
            // ending add by patofan
            SetSel1(X, Y);
          end
          else
            SetUnSelected;
        end;
      ecUp, ecDown, ecSelUp, ecSelDown:
        if Com([ecUp, ecSelUp]) or (Y < FRows - 1) or FCursorBeyondEOF then
        begin
          if Com([ecSelUp, ecSelDown]) and not FSelected then SetSel1(X, Y);
          if Com([ecUp, ecSelUp]) then
            dec(Y)
          else
          begin
            inc(Y);
            // add by patofan
            deltastep := 1;
            // ending add by patofan
          end;
          if Com([ecSelUp, ecSelDown]) then
          begin
            // add by patofan
            {$IFDEF RA_D3H}
            CheckDoubleByteChar( x , y  , mbTrailByte , deltastep );
            {$ENDIF RA_D3H}
            // ending add by patofan
            SetSel1(X, Y);
          end
          else
            SetUnSelected;
        end;
      ecPrevWord, ecSelPrevWord:
        begin
          if (ACommand = ecSelPrevWord) and not FSelected then
            SetSel1(FCaretX, FCaretY);
          S := FLines[Y];
          B := false;
          if FCaretX > Length(s) then
          begin
            X:=Length(s);
            SetSel1(X, Y);
          end
          else
          begin
            for F := X - 1 downto 0 do
              if B then
                if (S[F + 1] in Separators) then
                begin
                  X := F + 1;
                  break;
                end
                else
              else if not (S[F + 1] in Separators) then
                B := true;
            if X = FCaretX then
              X := 0;
            if ACommand = ecSelPrevWord then
              SetSel1(X, Y)
            else
              SetUnselected;
          end;    
        end;
      ecNextWord, ecSelNextWord:
        begin
          if (ACommand = ecSelNextWord) and not FSelected then
            SetSel1(FCaretX, FCaretY);
          if Y >= FLines.Count then
          begin
            Y := FLines.Count - 1;
            X := Length(FLines[Y]);
          end;
          S := FLines[Y];
          B := false;
          if FCaretX >= Length(S) then
          begin
            if Y < FLines.Count - 1 then
            begin
              Y := FCaretY + 1;
              X := 0;
              SetSel1(X, Y);
            end;
          end
          else
          begin
            for F := X to Length(S) - 1 do
              if B then
                if not (S[F + 1] in Separators) then
                begin
                  X := F;
                  break;
                end
                else
              else if (S[F + 1] in Separators) then
                B := true;
            if X = FCaretX then
              X := Length(S);
            if ACommand = ecSelNextWord then
              SetSel1(X, Y)
            else
              SetUnselected;
          end;    
        end;
      ecScrollLineUp, ecScrollLineDown:
        begin
          if not ((ACommand = ecScrollLineDown) and
            (Y >= FLines.Count - 1) and (Y = FTopRow)) then
          begin
            if ACommand = ecScrollLineUp then
              F := -1
            else
              F := 1;
            scbVert.Position := scbVert.Position + F;
            Scroll(true, scbVert.Position);
          end;
          if Y < FTopRow then
            Y := FTopRow
          else if Y > FLastVisibleRow then
            Y := FLastVisibleRow;
          // add by patofan
         {$IFDEF RA_D3H}
          CheckDoubleByteChar( x , y  , mbTrailByte , -1 );
         {$ENDIF RA_D3H}
          // ending add by patofan
        end;
      ecBeginLine, ecSelBeginLine, ecBeginDoc, ecSelBeginDoc,
        ecEndLine, ecSelEndLine, ecEndDoc, ecSelEndDoc:
        begin
          if Com([ecSelBeginLine, ecSelBeginDoc, ecSelEndLine, ecSelEndDoc])
            and not FSelected then
            SetSel1(FCaretX, Y);
          if Com([ecBeginLine, ecSelBeginLine]) then
            X := 0
          else if Com([ecBeginDoc, ecSelBeginDoc]) then
          begin
            X := 0;
            Y := 0;
            SetLeftTop(0, 0);
          end
          else if Com([ecEndLine, ecSelEndLine]) then
            if Y < FLines.Count then
              X := Length(FLines[Y])
             else
              X := 0
          else if Com([ecEndDoc, ecSelEndDoc]) then
          begin
            Y := FLines.Count - 1;
            X := Length(FLines[Y]);
            SetLeftTop(X - FVisibleColCount, Y - FVisibleRowCount div 2);
          end;
          if Com([ecSelBeginLine, ecSelBeginDoc, ecSelEndLine, ecSelEndDoc])
            then
            SetSel1(X, Y)
          else
            SetUnSelected;
        end;
      ecPrevPage:
        begin
          scbVert.Position := scbVert.Position - scbVert.LargeChange;
          Scroll(true, scbVert.Position);
          Y := Y - FVisibleRowCount;
          SetUnSelected;
        end;
      ecNextPage:
        begin
          scbVert.Position := scbVert.Position + scbVert.LargeChange;
          Scroll(true, scbVert.Position);
          Y := Y + FVisibleRowCount;
          SetUnSelected;
        end;
      ecSelPrevPage:
        begin
          BeginUpdate;
          SetSel1(X, Y);
          scbVert.Position := scbVert.Position - scbVert.LargeChange;
          Scroll(true, scbVert.Position);
          Y := Y - FVisibleRowCount;
          // add by patofan
         {$IFDEF RA_D3H}
          CheckDoubleByteChar( x , y  , mbTrailByte , deltastep );
         {$ENDIF RA_D3H}
          // ending add by patofan
          SetSel1(X, Y);
          EndUpdate;
        end;
      ecSelNextPage:
        begin
          BeginUpdate;
          SetSel1(X, Y);
          scbVert.Position := scbVert.Position + scbVert.LargeChange;
          Scroll(true, scbVert.Position);
          Y := Y + FVisibleRowCount;
          if Y <= FLines.Count - 1 then
          begin
            // add by patofan
            {$IFDEF RA_D3H}
            CheckDoubleByteChar( x , y  , mbTrailByte , deltastep );
            {$ENDIF RA_D3H}
            // ending add by patofan
            SetSel1(X, Y);
          end
          else
          begin
            // add by patofan
            {$IFDEF RA_D3H}
            CheckDoubleByteChar( x , FLines.Count - 1  , mbTrailByte , deltastep );
            {$ENDIF RA_D3H}
            // ending add by patofan
            SetSel1(X, FLines.Count - 1);
          end;
          EndUpdate;
        end;
      ecSelWord:
        if not FSelected and (GetWordOnPosEx(FLines[Y] + ' ', X + 1, iBeg,
          iEnd) <> '') then
        begin
          SetSel1(iBeg - 1, Y);
          SetSel1(iEnd - 1, Y);
          X := iEnd - 1;
        end;

      ecWindowTop:
        Y := FTopRow;
      ecWindowBottom:
        Y := FTopRow + FVisibleRowCount - 1;

      { editing }

      {$IFDEF RAEDITOR_EDITOR}
      ecCharFirst..ecCharLast:
        if not FReadOnly then
        begin
          insertChar(Char(ACommand - ecCharFirst));
          Exit;
        end;
      ecinsertPara:
        if not FReadOnly then
        begin
          DeleteSelected;
          {$IFDEF RAEDITOR_UNDO}
          TinsertUndo.Create(Self, FCaretX, FCaretY, #13#10);
          CaretUndo := false;
          {$ENDIF RAEDITOR_UNDO}
          inc(FUpdateLock);
          try
            if FLines.Count = 0 then FLines.Add('');
            F := SelStart - 1;
            FLines.insert(Y + 1, Copy(FLines[Y], X + 1, Length(FLines[Y])));
            FLines.internal[Y] := Copy(FLines[Y], 1, X);
            inc(Y);
            { smart tab }
            if FAutoindent and
              (((Length(FLines[FCaretY]) > 0) and
               (FLines[FCaretY][1] = ' ')) or
              ((Trim(FLines[FCaretY]) = '') and (X > 0))) then
            begin
              X := GetTabStop(0, Y, tsAutoindent, True);
              {$IFDEF RAEDITOR_UNDO}
              TinsertUndo.Create(Self, 0, Y, Spaces(X));
              {$ENDIF RAEDITOR_UNDO}
              FLines.internal[Y] := Spaces(X) + FLines[Y];
            end
            else
              X := 0;
            UpdateEditorSize;
            TextModified(F, mainsert, #13#10);
          finally
            dec(FUpdateLock);
          end;
          invalidate;
          Changed;
        end;
      ecBackspace:
        if not FReadOnly then
          if X > 0 then
          begin
            { into line - в середине строки }
            if FSelected then
              DoAndCorrectXY(DeleteSelected)
            else
            begin
              ReLine;
              if FBackSpaceUnindents then
                X := GetBackStop(FCaretX, FCaretY)
              else
                X := FCaretX - 1;

              // add by patofan
             {$IFDEF RA_D3H}
              k := x - 1;
              if CheckDoubleByteChar( k , y  , mbLeadByte , 0 ) then
              begin
                X := k;
              end;
             {$ENDIF RA_D3H}
              // ending add by patofan

              S := Copy(FLines[FCaretY], X + 1, FCaretX - X);
              {$IFDEF RAEDITOR_UNDO}
              TBackspaceUndo.Create(Self, FCaretX, FCaretY, S);
              CaretUndo := false;
              {$ENDIF RAEDITOR_UNDO}
              F := SelStart - 1;
              FLines.internal[Y] := Copy(FLines[Y], 1, X) +
                Copy(FLines[Y], FCaretX + 1, Length(FLines[Y]));
              TextModified(F, maDelete, S);
              PaintLine(Y, -1, -1);
            end;
            Changed;
          end
          else if Y > 0 then
          begin
            { on begin of line - в начале строки}
            DeleteSelected;
            ReLine;
            F := SelStart - 2;
            if F <= 0 then
              S:='#$A#$D'
            else
              S := FLines.Text[SelStart - 2] +
                FLines.Text[SelStart - 1];
            X := Length(FLines[Y - 1]);
            {$IFDEF RAEDITOR_UNDO}
            TBackspaceUndo.Create(Self, FCaretX, FCaretY, #13);
            CaretUndo := false;
            {$ENDIF RAEDITOR_UNDO}
            FLines.internal[Y - 1] := FLines[Y - 1] + FLines[Y];
            FLines.Delete(Y);
            dec(Y);
            UpdateEditorSize;
            TextModified(F, maDelete, S);
            invalidate;
            Changed;
          end;
      ecDelete:
        if not FReadOnly then
        begin
          inc(FUpdateLock);
          try
            if FLines.Count = 0 then FLines.Add('');
          finally
            dec(FUpdateLock);
          end;
          if FSelected then
            DoAndCorrectXY(DeleteSelected)
          else if X < Length(FLines[Y]) then
          begin
            { into line - в середине строки}
            {$IFDEF RAEDITOR_UNDO}
            TDeleteUndo.Create(Self, FCaretX, FCaretY, FLines[Y] [X + 1]);
            CaretUndo := false;
            {$ENDIF RAEDITOR_UNDO}

            // add by patofan
            {$IFDEF RA_D3H}
            k := x + 1;
            if CheckDoubleByteChar( k , y  , mbTrailByte , 0 ) then
            begin
              S := FLines[Y] [X + 1] + FLines[Y] [X + 2];
              FLines.internal[Y] := Copy(FLines[Y], 1, X) +
                Copy(FLines[Y], X + 3, Length(FLines[Y]));
            end else
            {$ENDIF RA_D3H}
            begin
            // ending add by patofan
              S := FLines[Y] [X + 1];
              FLines.internal[Y] := Copy(FLines[Y], 1, X) +
                Copy(FLines[Y], X + 2, Length(FLines[Y]));
            // add by patofan
            end;
            // ending add by patofan

            TextModified(SelStart, maDelete, S);
            PaintLine(FCaretY, -1, -1);
            Changed;
          end
          else if (Y >= 0) and (Y <= FLines.Count - 2) then
          begin
            { on end of line - в конце строки}
            {$IFDEF RAEDITOR_UNDO}
            TDeleteUndo.Create(Self, FCaretX, FCaretY, #13#10);
            CaretUndo := false;
            {$ENDIF RAEDITOR_UNDO}
            S := FLines.Text[SelStart + 1] + FLines.Text[SelStart + 2];
            FLines.internal[Y] := FLines[Y] + FLines[Y + 1];
            FLines.Delete(Y + 1);
            UpdateEditorSize;
            TextModified(SelStart, maDelete, S);
            invalidate;
            Changed;
          end;
          // add by patofan
          deltastep := 0;
          // ending add by patofan
        end;
      ecTab, ecBackTab:
        if not FReadOnly then
        begin
          if FSelected then
          begin
            if ACommand = ecTab then
              PostCommand(ecindent)
            else
              PostCommand(ecUnindent);
          end
          else
          begin
            ReLine;
            X := GetTabStop(FCaretX, FCaretY, tsTabStop, ACommand = ecTab);
            if (ACommand = ecTab) and FinsertMode then
            begin
              S := FLines[FCaretY];
              S2 := Spaces(X - FCaretX);
              {$IFDEF RAEDITOR_UNDO}
              TinsertTabUndo.Create(Self, FCaretX, FCaretY, S2);
              CaretUndo := false;
              {$ENDIF RAEDITOR_UNDO}
              insert(S2, S, FCaretX + 1);
              FLines.internal[FCaretY] := S;
              TextModified(SelStart, mainsert, S2);
              PaintLine(FCaretY, -1, -1);
              Changed;
            end
            else
              { move cursor - oh yes!, it's allready moved: X := GetTabStop(..); }
          end;
        end;
      ecindent:
        if not FReadOnly and FSelected and (FSelBegY <> FSelEndY) and
          (FSelBegX = 0) and (FSelEndX = 0) then
        begin
          F := FindNotBlankCharPos(FLines[FCaretY]);
          S2 := Spaces(GetDefTabStop(F, True) - FCaretX);
          S := SelText;
          S := ReplaceString(S, #13#10, #13#10 + S2);
          Delete(S, Length(S) - Length(S2) + 1, Length(S2));
          SetSelText1(S2 + S)
        end;
      ecUnindent:
        if not FReadOnly and FSelected and (FSelBegY <> FSelEndY) and
          (FSelBegX = 0) and (FSelEndX = 0) then
        begin
          F := FindNotBlankCharPos(FLines[FCaretY]);
          S2 := Spaces(GetDefTabStop(F, True) - FCaretX);
          S := SelText;
          S := ReplaceString(S, #13#10 + S2, #13#10);
          for iBeg := 1 to Length(S2) do
            if S[1] = ' ' then
              Delete(S, 1, 1)
            else
              Break;
          SetSelText1(S);
        end;

      ecChangeinsertMode:
        begin
          FinsertMode := not FinsertMode;
          StatusChanged;
        end;
      ecinclusiveBlock .. ecNoninclusiveBlock:
        begin
          FSelBlockFormat := TSelBlockFormat(ACommand - ecinclusiveBlock);
          PaintSelection;
          StatusChanged;
        end;

      ecClipBoardCut:
        if not FReadOnly then
          DoAndCorrectXY(ClipBoardCut);
      {$ENDIF RAEDITOR_EDITOR}
      ecClipBoardCopy:
        ClipBoardCopy;
      {$IFDEF RAEDITOR_EDITOR}
      ecClipBoardPaste:
        if not FReadOnly then
          DoAndCorrectXY(ClipBoardPaste);
      ecDeleteSelected:
        if not FReadOnly and FSelected then
          DoAndCorrectXY(DeleteSelected);

      ecDeleteWord:
        if not FReadOnly then
        begin
          Command(ecBeginCompound);
          Command(ecBeginUpdate);
          Command(ecSelWord);
          // Command(ecSelNextWord); //???? it should work as in Delphi editor...
          Command(ecDeleteSelected);
          Command(ecEndUpdate);
          Command(ecEndCompound);
          Exit;
        end;
      ecDeleteLine:
        if not FReadOnly then
        begin
          Command(ecBeginCompound);
          Command(ecBeginUpdate);
          Command(ecBeginLine);
          Command(ecSelEndLine);
          Command(ecDelete);
          Command(ecDelete);
          Command(ecEndUpdate);
          Command(ecEndCompound);
          Exit;
        end;
      ecSelAll:
        begin
          Command(ecBeginCompound);
          Command(ecBeginUpdate);
          Command(ecBeginDoc);
          Command(ecSelEndDoc);
          Command(ecEndUpdate);
          Command(ecEndCompound);
          Exit;
        end;
      ecToUpperCase:
        if not FReadOnly then
          SelText := ANSIUpperCase(SelText);
      ecToLowerCase:
        if not FReadOnly then
          SelText := ANSILowerCase(SelText);
      ecChangeCase:
        if not FReadOnly then
          SelText := ANSIChangeCase(SelText);
      {$ENDIF RAEDITOR_EDITOR}
      {$IFDEF RAEDITOR_UNDO}
      ecUndo:
        if not FReadOnly then
        begin
          FUndoBuffer.Undo;
          PaintCaret(true);
          Exit;
        end;
      ecRedo:
        if not FReadOnly then
        begin
          FUndoBuffer.Redo;
          PaintCaret(true);
          Exit;
        end;
      ecBeginCompound:
        BeginCompound;
      ecEndCompound:
        EndCompound;
      {$ENDIF RAEDITOR_UNDO}

      ecSetBookmark0..ecSetBookmark9:
        ChangeBookMark(ACommand - ecSetBookmark0, true);
      ecGotoBookmark0..ecGotoBookmark9:
        begin
          ChangeBookMark(ACommand - ecGotoBookmark0, false);
          X := FCaretX;
          Y := FCaretY;
        end;
      {$IFDEF RAEDITOR_COMPLETION}
      ecCompletionIdentifers:
        if not FReadOnly then
        begin
          FCompletion.DoCompletion(cmIdentifers);
          PaintCaret(true);
          Exit;
        end;
      ecCompletionTemplates:
        if not FReadOnly then
        begin
          FCompletion.DoCompletion(cmTemplates);
          PaintCaret(true);
          Exit;
        end;
      {$ENDIF RAEDITOR_COMPLETION}
      ecBeginUpdate:
        BeginUpdate;
      ecEndUpdate:
        EndUpdate;

      ecRecordMacro:
        if FRecording then
          EndRecord(FDefMacro)
        else
          BeginRecord;
      ecPlayMacro:
        begin
          PlayMacro(FDefMacro);
          Exit;
        end;
    end;

    // add by patofan
    {$IFDEF RA_D3H}
    CheckDoubleByteChar( x , y  , mbTrailByte , deltastep );
    {$ENDIF RA_D3H}
    // add by patofan

    {$IFDEF RAEDITOR_UNDO}
    if CaretUndo then
      SetCaret(X, Y)
    else
      SetCaretinternal(X, Y);
    {$ELSE}
    SetCaret(X, Y);
    {$ENDIF RAEDITOR_UNDO}

    // by TSV

    if Assigned(FOnCommand) then FOnCommand(Self,ACommand);


  finally
    // dec(FUpdateLock);
    PaintCaret(true);
  end;
end;
{$ENDIF}

procedure TRACustomEditor.PostCommand(ACommand: TEditCommand);
begin
  PostMessage(Handle, WM_EDITCOMMAND, ACommand, 0);
end; { PostCommand }

procedure TRACustomEditor.WMEditCommand(var Message: TMessage);
begin
  Command(Message.WParam);
  Message.Result := ord(True);
end;

procedure TRACustomEditor.WMCopy(var Message: TMessage);
begin
  PostCommand(ecClipboardCopy);
  Message.Result := ord(True);
end;

{$IFDEF RAEDITOR_EDITOR}

procedure TRACustomEditor.WMCut(var Message: TMessage);
begin
  if not FReadOnly then
    PostCommand(ecClipboardCut);
  Message.Result := ord(True);
end;

procedure TRACustomEditor.WMPaste(var Message: TMessage);
begin
  if not FReadOnly then
    PostCommand(ecClipBoardPaste);
  Message.Result := ord(True);
end;
{$ENDIF}

{$IFDEF RAEDITOR_EDITOR}

procedure TRACustomEditor.ChangeBookMark(const BookMark: TBookMarkNum; const
  Valid: boolean);

  procedure SetXY(X, Y: integer);
  var
    X1, Y1: integer;
  begin
    X1 := FLeftCol;
    Y1 := FTopRow;
    if (Y < FTopRow) or (Y > FLastVisibleRow) then
      Y1 := Y - (FVisibleRowCount div 2);
    if (X < FLeftCol) or (X > FVisibleColCount) then
      X1 := X - (FVisibleColCount div 2);
    SetLeftTop(X1, Y1);
    SetCaret(X, Y);
  end;

begin
  if Valid then begin
    if BookMarks[Bookmark].Valid and (BookMarks[Bookmark].Y = FCaretY) then
      BookMarks[Bookmark].Valid := false
    else
    begin
      BookMarks[Bookmark].X := FCaretX;
      BookMarks[Bookmark].Y := FCaretY;
      BookMarks[Bookmark].Valid := true;
    end;
  end else if BookMarks[Bookmark].Valid then
    SetXY(BookMarks[Bookmark].X, BookMarks[Bookmark].Y);
  BookmarkCnanged(BookMark);
  FGutter.Paint;

end;
{$ENDIF}

procedure TRACustomEditor.BookmarkCnanged(BookMark: integer);
begin
  FGutter.invalidate;
end;


{############### Клавиатура ###############}

procedure TRACustomEditor.SelectionChanged;
begin
  {abstract}
end;

procedure TRACustomEditor.SetSel(const SelX, SelY: integer);

  procedure UpdateSelected;
  var
    iR: integer;
  begin
    if FSelBlockFormat = bfColumn then
    begin
      if FUpdateSelBegY < FSelBegY then
        for iR := FUpdateSelBegY to FSelBegY do
          PaintLine(iR, -1, -1);
      for iR := FSelBegY to FSelEndY do
        PaintLine(iR, -1, -1);
      if FUpdateSelEndY > FSelEndY then
        for iR := FSelEndY to FUpdateSelEndY do
          PaintLine(iR, -1, -1);
    end
    else
    begin
      if FUpdateSelBegY < FSelBegY then
        for iR := FUpdateSelBegY to FSelBegY do
          PaintLine(iR, -1, -1)
      else
        for iR := FSelBegY to FUpdateSelBegY do
          PaintLine(iR, -1, -1);
      if FUpdateSelEndY < FSelEndY then
        for iR := FUpdateSelEndY to FSelEndY do
          PaintLine(iR, -1, -1)
      else
        for iR := FSelEndY to FUpdateSelEndY do
          PaintLine(iR, -1, -1);
    end;
    SelectionChanged;
    if Assigned(FOnSelectionChange) then FOnSelectionChange(Self);
  end;

begin
  {$IFDEF RAEDITOR_UNDO}
  TSelectUndo.Create(Self, FCaretX, FCaretY, FSelected, FSelBlockFormat,
    FSelBegX, FSelBegY, FSelEndX, FSelEndY);
  {$ENDIF RAEDITOR_UNDO}
  if not FSelected then
  begin
    FSelStartX := SelX;
    FSelStartY := SelY;
    FSelEndX := SelX;
    FSelEndY := SelY;
    FSelBegX := SelX;
    FSelBegY := SelY;
    FSelected := true;
  end
  else
  begin
    FUpdateSelBegY := FSelBegY;
    FUpdateSelEndY := FSelEndY;

    if SelY <= FSelStartY then
    begin
      FSelBegY := SelY;
      FSelEndY := FSelStartY;
    end;
    if SelY >= FSelStartY then
    begin
      FSelBegY := FSelStartY;
      FSelEndY := SelY;
    end;
    if (SelY < FSelStartY) or ((SelY = FSelStartY) and (SelX <= FSelStartX)) then
      if (FSelBlockFormat = bfColumn) and (SelX > FSelStartX) then
      begin
        FSelBegX := FSelStartX;
        FSelEndX := SelX;
      end
      else
      begin
        FSelBegX := SelX;
        FSelEndX := FSelStartX;
      end;
    if (SelY > FSelStartY) or ((SelY = FSelStartY) and (SelX >= FSelStartX)) then
      if (FSelBlockFormat = bfColumn) and (SelX < FSelStartX) then
      begin
        FSelBegX := SelX;
        FSelEndX := FSelStartX;
      end
      else
      begin
        FSelBegX := FSelStartX;
        FSelEndX := SelX;
      end;

    FSelected := true;
  end;
  if FCompound = 0 then
    UpdateSelected;
  if FUpdateSelBegY > FSelBegY then FUpdateSelBegY := FSelBegY;
  if FUpdateSelEndY < FSelEndY then FUpdateSelEndY := FSelEndY;
end;

procedure TRACustomEditor.SetSelBlockFormat(const Value: TSelBlockFormat);
begin
  Command(ecinclusiveBlock + integer(Value));
end;

{************** Мышь ***************}

procedure TRACustomEditor.Mouse2Cell(const X, Y: integer; var CX, CY: integer);
begin
  CX := Round((X - FEditorClient.Left) / FCellRect.Width);
  CY := (Y - FEditorClient.Top) div FCellRect.Height;
end;

procedure TRACustomEditor.Mouse2Caret(const X, Y: integer; var CX, CY: integer);
begin
  Mouse2Cell(X, Y, CX, CY);
  if CX < 0 then CX := 0;
  if CY < 0 then CY := 0;
  CX := CX + FLeftCol;
  CY := CY + FTopRow;
  if CX > FLastVisibleCol then CX := FLastVisibleCol;
  if CY > FLines.Count - 1 then CY := FLines.Count - 1;
end;

procedure TRACustomEditor.CaretCoord(const X, Y: integer; var CX, CY: integer);
begin
  CX := X - FLeftCol;
  CY := Y - FTopRow;
  if CX < 0 then CX := 0;
  if CY < 0 then CY := 0;
  CX := FCellRect.Width * CX;
  CY := FCellRect.Height * CY;
end;

procedure TRACustomEditor.DblClick;
var
  iBeg, iEnd: integer;
begin
  FDoubleClick := true;
  if Assigned(FOnDblClick) then FOnDblClick(Self);
  if FDoubleClickLine then
  begin
    PaintCaret(false);
    SetSel(0, FCaretY);
    if FCaretY = FLines.Count - 1 then
    begin
      SetSel(Length(FLines[FCaretY]), FCaretY);
      SetCaret(Length(FLines[FCaretY]), FCaretY);
    end
    else
    begin
      SetSel(0, FCaretY + 1);
      SetCaret(0, FCaretY + 1);
    end;
    PaintCaret(true);
  end
  else if (FLines.Count > 0) and (Trim(FLines[FCaretY]) <> '') then
  begin
    iEnd := Length(TrimRight(FLines[FCaretY]));
    if FCaretX < iEnd then
      while FLines[FCaretY][FCaretX + 1] <= ' ' do
        inc(FCaretX)
    else
    begin
      FCaretX := iEnd - 1;
      while FLines[FCaretY][FCaretX + 1] <= ' ' do
        Dec(FCaretX)
    end;
    if GetWordOnPosEx(FLines[FCaretY] + ' ', FCaretX + 1, iBeg, iEnd) <> '' then
    begin
      PaintCaret(false);
      SetSel(iBeg - 1, FCaretY);
      SetSel(iEnd - 1, FCaretY);
      SetCaret(iEnd - 1, FCaretY);
      PaintCaret(true);
    end;
  end
end;

procedure TRACustomEditor.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
var
  XX, YY: integer;
  fm: TCustomForm;
begin
  if not (csDesigning in ComponentState) and CanFocus then begin
    fm:=Screen.ActiveCustomForm;
    if fm<>nil then
      Windows.SetFocus(fm.Handle);
  end;     
  
  FFindTxt.Visible:=false;
  FErrorLine.Visible:=false;

  if FDoubleClick then
  begin
    FDoubleClick := false;
    Exit;
  end;
  {$IFDEF RAEDITOR_COMPLETION}
  if FCompletion.FVisible then FCompletion.CloseUp(false);
  {$ENDIF RAEDITOR_COMPLETION}
  Mouse2Caret(X, Y, XX, YY);
  // if (XX = FCaretX) and (YY = FCaretY) then exit;

  // add by patofan
 {$IFDEF RA_D3H}
  CheckDoubleByteChar( xx , yy  , mbTrailByte , -1 );
 {$ENDIF RA_D3H}
  // ending add by patofan
  
  PaintCaret(false);
  if Button = mbLeft then
  begin
    FSelBlockFormat := bfNoninclusive;
    SetUnSelected;
  end;
  SetFocus;
  if Button = mbLeft then
    SetCaret(XX, YY);
  PaintCaret(true);
  FMouseDowned := True;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TRACustomEditor.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: integer);
begin
  timerScroll.Enabled := false;
  FMouseDowned := False;
  inherited MouseUp(Button, Shift, X, Y);
end;

function TRACustomEditor.GetPosByLine(const Line: Integer): Integer;
var
  i: Integer;
begin
  Result:=0;
  if (Line>-1)and(Line<=FLines.Count-1) then begin
    for i:=0 to Line do
      Inc(Result,Length(FLines.Strings[i])+2);
  end;
end;

procedure TRACustomEditor.MouseMove(Shift: TShiftState; X, Y: integer);
var
  XX, YY, dPos: Integer;
  NewPosBegin,NewPosEnd: Integer;
  S: string;
begin
  if FMouseDowned and (Shift = [ssLeft]) then
  begin
    PaintCaret(false);
    MouseMoveY := Y;
    Mouse2Caret(X, Y, MouseMoveXX, MouseMoveYY);

    // add by patofan
    {$IFDEF RA_D3H}
    CheckDoubleByteChar( MouseMoveXX, MouseMoveYY  , mbTrailByte , -1 );
    {$ENDIF RA_D3H}
    // ending add by patofan

    if MouseMoveYY <= FLastVisibleRow then
    begin
      SetSel(MouseMoveXX, MouseMoveYY);
      SetCaret(MouseMoveXX, MouseMoveYY);
    end;
    timerScroll.Enabled := (Y < 0) or (Y > ClientHeight);
    PaintCaret(true);
  end else begin

    Mouse2Caret(X, Y, XX, YY);
    if (XX>=0)and(YY>=0)and(YY<=FLines.Count-1) then begin
      if (OldY<>YY)or(OldX<>XX) then begin
        NewPosBegin:=0;
        NewPosEnd:=0;
        S:=GetWordOnPosEx(FLines[YY],XX+1,NewPosBegin,NewPosEnd);
        if FIdentiferHint<>S then begin
          FIdentiferHint:=S;
          if Trim(FIdentiferHint)<>'' then begin
            dPos:=GetPosByLine(YY-1);
            FIdentiferPosBegin:=dPos+NewPosBegin;
            FIdentiferPosEnd:=FIdentiferPosBegin+Length(S);
//            timerHint.Enabled:=true;
            if Assigned(FOnIdentiferHint) then
               FOnIdentiferHint(Self,FIdentiferHint,FIdentiferPosBegin,FIdentiferPosEnd,X,Y);
          end else begin
            FIdentiferPosBegin:=0;
            FIdentiferPosEnd:=0;
            if Assigned(FOnIdentiferHint) then
               FOnIdentiferHint(Self,FIdentiferHint,FIdentiferPosBegin,FIdentiferPosEnd,X,Y);
          end;
        end;
      end;
      OldX:=XX;
      OldY:=YY;
    end;

  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TRACustomEditor.HintTimer(Sender: TObject);
begin
  timerHint.Enabled:=false;
  if Assigned(FOnIdentiferHint) then
     FOnIdentiferHint(Self,FIdentiferHint,FIdentiferPosBegin,FIdentiferPosEnd,0,0);
end;

procedure TRACustomEditor.ScrollTimer(Sender: TObject);
begin
  if (MouseMoveY < 0) or (MouseMoveY > ClientHeight) then
  begin
    if (MouseMoveY < -20) then
      dec(MouseMoveYY, FVisibleRowCount)
    else if (MouseMoveY < 0) then
      dec(MouseMoveYY)
    else if (MouseMoveY > ClientHeight + 20) then
      inc(MouseMoveYY, FVisibleRowCount)
    else if (MouseMoveY > ClientHeight) then
      inc(MouseMoveYY);
    PaintCaret(false);
    SetSel(MouseMoveXX, MouseMoveYY);
    SetCaret(MouseMoveXX, MouseMoveYY);
    PaintCaret(true);
  end;
end;

{############## Мышь ###############}

{************** ClipBoard ***************}

function TRACustomEditor.GetClipboardBlockFormat: TSelBlockFormat;
var
  Data: THandle;
begin
  Result := bfNoninclusive;
  if Clipboard.HasFormat(BlockTypeFormat) then
  begin
    Clipboard.Open;
    Data := GetClipboardData(BlockTypeFormat);
    try
      if Data <> 0 then
        Result := TSelBlockFormat(Pinteger(GlobalLock(Data))^);
    finally
      if Data <> 0 then GlobalUnlock(Data);
      Clipboard.Close;
    end;
  end;
end;

procedure TRACustomEditor.SetClipboardBlockFormat(const Value: TSelBlockFormat);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  Clipboard.Open;
  try
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, 1);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(Value, DataPtr^, 1);
        //Adding;
        SetClipboardData(BlockTypeFormat, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    Clipboard.Close;
  end;
end;

function TRACustomEditor.GetSelText: string;
var
  S1: string;
  i: integer;
begin
  Result := '';
//  if not FSelected then exit;
  if (FSelBegY < 0) or (FSelBegY > FLines.Count - 1) or (FSelEndY < 0) or
    (FSelEndY > FLines.Count - 1) then
  begin
    Err;
    Exit;
  end;
  if FSelBlockFormat = bfColumn then
  begin
    for i := FSelBegY to FSelEndY do
    begin
      S1 := Copy(FLines[i], FSelBegX + 1, FSelEndX - FSelBegX + 1);
      S1 := S1 + Spaces((FSelEndX - FSelBegX + 1) - Length(S1)) + #13#10;
      Result := Result + S1;
    end;
  end
  else
  begin
    if FSelBegY = FSelEndY then
      Result := Copy(FLines[FSelEndY], FSelBegX + 1, FSelEndX - FSelBegX +
        integer(FSelBlockFormat = bfinclusive))
    else
    begin
      Result := Copy(FLines[FSelBegY], FSelBegX + 1, Length(FLines[FSelBegY]));
      for i := FSelBegY + 1 to FSelEndY - 1 do
        Result := Result + #13#10 + FLines[i];
      Result := Result + #13#10 + Copy(FLines[FSelEndY], 1, FSelEndX +
        integer(FSelBlockFormat = bfinclusive));
    end;
  end;
end;

procedure TRACustomEditor.SetSelText(const AValue: string);
begin
  BeginUpdate;
  try
    BeginCompound;
    DeleteSelected;
    insertText(AValue);
    FSelected := True;
    SelStart := PosFromCaret(FSelBegX, FSelBegY);
    SelLength := Length(AValue);
    EndCompound;
  finally
    EndUpdate;
  end;
end;

procedure TRACustomEditor.ClipBoardCopy;
begin
  ClipBoard.SetTextBuf(PChar(GetSelText));
  SetClipboardBlockFormat(SelBlockFormat);
end;

{$IFDEF RAEDITOR_EDITOR}

procedure TRACustomEditor.insertText(const Text: string);
var
  S: string;
  P: integer;
  X, Y: integer;
begin
  PaintCaret(false);
  BeginUpdate;
  S := FLines.Text;
  P := PosFromCaret(FCaretX, FCaretY);
  {$IFDEF RAEDITOR_UNDO}
  TinsertUndo.Create(Self, FCaretX, FCaretY, Text);
  //FUndoBuffer.EndGroup;
  {$ENDIF RAEDITOR_UNDO}
  insert(Text, S, P + 1);
  TextModified(P, mainsert, Text);
  FLines.Text := S; {!!! Вызывает перерисовку всего}
  CaretFromPos(P + Length(Text), X, Y);
  SetCaretinternal(X, Y);
  Changed;
  EndUpdate;
  PaintCaret(true);
end;

{заменяет слово в позиции курсора на NewString}
{ строка NewString не должна содержать #13, #10}

procedure TRACustomEditor.ReplaceWord(const NewString: string);
var
  iBeg, iEnd: integer;

  function GetWordOnPos2(S: string; P: integer): string;
  begin
    Result := '';
    if P < 1 then exit;
    if (S[P] in Separators) and ((P < 1) or (S[P - 1] in Separators)) then
      inc(P);
    iBeg := P;
    while iBeg >= 1 do
      if S[iBeg] in Separators then
        break
      else
        dec(iBeg);
    inc(iBeg);
    iEnd := P;
    while iEnd <= Length(S) do
      if S[iEnd] in Separators then
        break
      else
        inc(iEnd);
    if iEnd > iBeg then
      Result := Copy(S, iBeg, iEnd - iBeg)
    else
      Result := S[P];
  end;

var
  S, W: string;
  X: integer;
  F: integer;
begin
  PaintCaret(false);
  BeginUpdate;
  F := PosFromCaret(FCaretX, FCaretY);
  S := FLines[FCaretY];
  while FCaretX > Length(S) do
    S := S + ' ';
  W := Trim(GetWordOnPos2(S, FCaretX));
  if W = '' then
  begin
    iBeg := FCaretX + 1;
    iEnd := FCaretX
  end;
  {$IFDEF RAEDITOR_UNDO}
  NotUndoable;
  //TReplaceUndo.Create(Self, FCaretX - Length(W), FCaretY, iBeg, iEnd, W, NewString);
  {$ENDIF RAEDITOR_UNDO}
  //  LW := Length(W);
  if FSelected then
  begin
    if (FSelBegY <= FCaretY) or (FCaretY >= FSelEndY) then
      // скорректировать LW ..
  end;
  Delete(S, iBeg, iEnd - iBeg);
  insert(NewString, S, iBeg);
  FLines.internal[FCaretY] := S;
  X := iBeg + Length(NewString) - 1;
  TextModified(F, mainsert, NewString);
  PaintLine(FCaretY, -1, -1);
  SetCaretinternal(X, FCaretY);
  Changed;
  EndUpdate;
  PaintCaret(true);
end;

{заменяет слово в позиции курсора на NewString}

procedure TRACustomEditor.ReplaceWord2FromPosition(const Pos,LenOld: integer; const NewString: string);
var
  S, S1, W: string;
  P, X, Y: integer;
  iBeg, iEnd: integer;
  NewCaret: integer;
  nCaretX,nCaretY: integer;
  SS,SE: Integer;
begin
  BeginUpdate;
  SS:=SelStart;
  SE:=SelLength;
  CaretFromPos(Pos,nCaretX,nCaretY);
  if nCaretX > Length(FLines[nCaretY]) then
    FLines.internal[nCaretY] := FLines[nCaretY] +
      Spaces(nCaretX - Length(FLines[nCaretY]));
  S := FLines.Text;
  P := PosFromCaret(nCaretX, nCaretY);
  W := Trim(GetWordOnPosEx(S, P, iBeg, iEnd));
  if W = '' then
  begin
    iBeg := P + 1;
    iEnd := P
  end;
  S1 := NewString;
  NewCaret := Length(NewString);
  {$IFDEF RAEDITOR_UNDO}
  TReplaceUndo.Create(Self, nCaretX, nCaretY, iBeg, iEnd, W, S1);
  {$ENDIF RAEDITOR_UNDO}
  //  LW := Length(W);
  if FSelected then
  begin
    if (FSelBegY <= nCaretY) or (nCaretY >= FSelEndY) then
      // скорректировать LW ..
  end;
//  Delete(S, iBeg, iEnd - iBeg);
  Delete(S, Pos, LenOld);
  insert(S1, S, Pos);
  FLines.Text := S; {!!! Вызывает перерисовку всего}
  SelStart:=SS;
  SelLength:=SE;
  CaretFromPos(Pos+NewCaret - 1, X, Y);
  SetCaretinternal(X, Y);
  Changed;
  EndUpdate;
end;

procedure TRACustomEditor.ReplaceWord2(const NewString: string);
var
  S, S1, W: string;
  P, X, Y: integer;
  iBeg, iEnd: integer;
  NewCaret: integer;
begin
  PaintCaret(false);
  if FCaretX > Length(FLines[FCaretY]) then
    FLines.internal[FCaretY] := FLines[FCaretY] +
      Spaces(FCaretX - Length(FLines[FCaretY]));
  S := FLines.Text;
  P := PosFromCaret(FCaretX, FCaretY);
  W := Trim(GetWordOnPosEx(S, P, iBeg, iEnd));
  if W = '' then
  begin
    iBeg := P + 1;
    iEnd := P
  end;
  S1 := NewString;
  NewCaret := Length(NewString);
  {$IFDEF RAEDITOR_UNDO}
  TReplaceUndo.Create(Self, FCaretX, FCaretY, iBeg, iEnd, W, S1);
  {$ENDIF RAEDITOR_UNDO}
  //  LW := Length(W);
  if FSelected then
  begin
    if (FSelBegY <= FCaretY) or (FCaretY >= FSelEndY) then
      // скорректировать LW ..
  end;
  Delete(S, iBeg, iEnd - iBeg);
  insert(S1, S, iBeg);
  FLines.Text := S; {!!! Вызывает перерисовку всего}
  CaretFromPos(iBeg + NewCaret - 1, X, Y);
  SetCaretinternal(X, Y);
  Changed;
  PaintCaret(true);
end;
{$ENDIF RAEDITOR_EDITOR}

procedure TRACustomEditor.ClipBoardPaste;
var
  S, ClipS: string;
  Len, P: integer;
  H: THandle;
  X, Y: integer;
  SS: TStringList;
  i: integer;
begin
  if (FCaretY > FLines.Count - 1) and (FLines.Count > 0) then Err;
  BeginUpdate;
  H := ClipBoard.GetAsHandle(CF_TEXT);
  Len := GlobalSize(H);
  if Len = 0 then exit;
  SetLength(ClipS, Len);
  SetLength(ClipS, ClipBoard.GetTextBuf(PChar(ClipS), Len));
  ClipS := ExpandTabs(AdjustLineBreaks(ClipS));
  PaintCaret(false);

  BeginCompound;
  try
    DeleteSelected;
    if FLines.Count > 0 then
      ReLine;
    FSelBlockFormat := GetClipBoardBlockFormat;
    if FSelBlockFormat in [bfinclusive, bfNoninclusive] then
    begin
      S := FLines.Text;
      if FLines.Count > 0 then
        P := PosFromCaret(FCaretX, FCaretY)
      else
        P := 0;
     {$IFDEF RAEDITOR_UNDO}
      TinsertUndo.Create(Self, FCaretX, FCaretY, ClipS);
     {$ENDIF RAEDITOR_UNDO}
      insert(ClipS, S, P + 1);
      FLines.SetLockText(S);
      TextModified(P, mainsert, ClipS);
      CaretFromPos(P + Length(ClipS), X, Y);
    end
    else if FSelBlockFormat = bfColumn then
    begin
     {$IFDEF RAEDITOR_UNDO}
      TinsertColumnUndo.Create(Self, FCaretX, FCaretY, ClipS);
      //NotUndoable;
     {$ENDIF RAEDITOR_UNDO}
      SS := TStringList.Create;
      try
        SS.Text := ClipS;
        for i := 0 to SS.Count - 1 do
        begin
          if FCaretY + i > FLines.Count - 1 then
            FLines.Add(Spaces(FCaretX));
          S := FLines[FCaretY + i];
          insert(SS[i], S, FCaretX + 1);
          FLines[FCaretY + i] := S;
        end;
        X := FCaretX;
        Y := FCaretY + SS.Count;
      finally
        SS.Free;
      end;
    end;
  finally
    EndCompound;
  end;

  SetCaretinternal(X, Y);
  Changed;
  EndUpdate; {!!! Вызывает перерисовку всего}
  PaintCaret(true);
end;

procedure TRACustomEditor.ClipBoardCut;
begin
  ClipBoardCopy;
  DeleteSelected;
end;

procedure TRACustomEditor.DeleteSelected;
var
  S, S1: string;
  i, iBeg, iEnd, X, Y: integer;
begin
  if FSelected then
  begin
    PaintCaret(false);
    BeginUpdate;
    {$IFDEF RAEDITOR_UNDO}
    TDeleteSelectedUndo.Create(Self, FCaretX, FCaretY, GetSelText,
      FSelBlockFormat, FSelBegX, FSelBegY, FSelEndX, FSelEndY);
    {$ENDIF RAEDITOR_UNDO}
    if FSelBlockFormat in [bfinclusive, bfNoninclusive] then
    begin
      S := FLines.Text;
      iBeg := PosFromCaret(FSelBegX, FSelBegY);
      iEnd := PosFromCaret(FSelEndX + integer(FSelBlockFormat = bfinclusive), FSelEndY);
      Delete(S, iBeg + 1, iEnd - iBeg);
      S1 := GetSelText;
      FSelected := false;
      FLines.SetLockText(S);
      TextModified(iBeg, maDelete, S1);
      CaretFromPos(iBeg, X, Y);
    end
    else if FSelBlockFormat = bfColumn then
    begin
      Y := FCaretY;
      X := FSelBegX;
      iBeg := PosFromCaret(FSelBegX, FSelBegY);
      for i := FSelBegY to FSelEndY do
      begin
        S := FLines[i];
        Delete(S, FSelBegX + 1, FSelEndX - FSelBegX + 1);
        FLines.internal[i] := S;
      end;
      FSelected := false;
      TextModified(iBeg, maDeleteColumn, S1);
    end;
    SetCaretinternal(X, Y);
    Changed;
    EndUpdate;
    PaintCaret(true);
  end;
end;
{############### ClipBoard ###############}

procedure TRACustomEditor.SetGutterWidth(AWidth: integer);
begin
  if FGutterWidth <> AWidth then
  begin
    FGutterWidth := AWidth;
    UpdateEditorSize;
    invalidate;
  end;
end;

procedure TRACustomEditor.SetGutterColor(AColor: TColor);
begin
  if FGutterColor <> AColor then
  begin
    FGutterColor := AColor;
    FGutter.invalidate;
  end;
end;

function TRACustomEditor.GetLines: TStrings;
begin
  Result := FLines;
end;

procedure TRACustomEditor.SetLines(ALines: TStrings);
begin
  if ALines <> nil then FLines.Assign(ALines);
 {$IFDEF RAEDITOR_UNDO}
  NotUndoable;
 {$ENDIF RAEDITOR_UNDO}
end;

procedure TRACustomEditor.TextAllChanged;
begin
  TextAllChangedinternal(True);
end;

procedure TRACustomEditor.TextAllChangedinternal(const Unselect: Boolean);
begin
  if Unselect then
    FSelected := false;
  TextModified(0, mainsert, FLines.Text);
  UpdateEditorSize;
  if Showing and (FUpdateLock = 0) then invalidate;
end;

procedure TRACustomEditor.SetCols(ACols: integer);
begin
  if FCols <> ACols then
  begin
    FCols := Max(ACols, 1);
    scbHorz.Max := FCols - 1;
  end;
end;

procedure TRACustomEditor.SetRows(ARows: integer);
begin
  if FRows <> ARows then
  begin
    FRows := Max(ARows, 1);
    scbVert.Max := Max(1, FRows - 1 + FVisibleRowCount - 1);
  end;
end;

procedure TRACustomEditor.SetLeftTop(ALeftCol, ATopRow: integer);
begin
  if ALeftCol < 0 then ALeftCol := 0;
  if (FLeftCol <> ALeftCol) then
  begin
    scbHorz.Position := ALeftCol;
    Scroll(false, ALeftCol);
  end;
  if ATopRow < 0 then ATopRow := 0;
  if (FTopRow <> ATopRow) then
  begin
    scbVert.Position := ATopRow;
    Scroll(true, ATopRow);
  end;
end;

procedure TRACustomEditor.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TRACustomEditor.SetRightMarginVisible(Value: boolean);
begin
  if FRightMarginVisible <> Value then
  begin
    FRightMarginVisible := Value;
    invalidate;
  end;
end;

procedure TRACustomEditor.SetRightMargin(Value: integer);
begin
  if FRightMargin <> Value then
  begin
    FRightMargin := Value;
    invalidate;
  end;
end;

procedure TRACustomEditor.SetRightMarginColor(Value: TColor);
begin
  if FRightMarginColor <> Value then
  begin
    FRightMarginColor := Value;
    invalidate;
  end;
end;

function TRACustomEditor.ExpandTabs(const S: string): string;
var
 // i: integer;
  Sp: string;
 // l: Integer;
  tmps: string;
  APos: Integer;
begin
  { very slow and not complete implementation - NEED TO OPTIMIZE ! }
 // l:=Length(S);
  if Pos(#9, S) > 0 then
  begin
    Sp := Spaces(GetDefTabStop(0 {!!}, True));
    Result := S;
    tmps:=#9;
    APos:=-1;
    while APos<>0 do begin
      APos:=Pos(tmps,Result);
      if APos>0 then begin
        Delete(Result,Apos,Length(tmps));
        Insert(Sp,Result,APos);
      end;
    end;
{    for i := 1 to l do begin
      if S[i] = #9 then
        Result := Result + Sp
      else
        Result := Result + S[i];
    end;}
  end
  else
    Result := S;

end;

// add by patofan
{$IFDEF RA_D3H}
function TRACustomEditor.CheckDoubleByteChar(  var x : integer ; y : integer ; ByteType : TMbcsByteType ;
  delta_inc : integer ):boolean;
var
  CurByteType : TMbcsByteType;
begin
  result := false;
  try
      if ( y >= 0 ) and ( x >= 0 ) and ( y < Flines.Count ) then
      begin
        CurByteType := StrByteType( pchar( FLines[ y ] ) , x  );
        if (CurByteType = ByteType ) then
        begin
          x := x  + delta_inc;
          result := true;
        end;
      end;
  except
    on E:EStringListError do
  end;
end;
{$ENDIF RA_D3H}
// ending add by patofan

{ ************************ triggers ************************ }

procedure TRACustomEditor.TextModified(Pos: integer; Action: TModifiedAction;
  Text: string);
begin
  { This method don't called at all cases, when text is modified,
    so don't use it. Later I may be complete it. }
end;

procedure TRACustomEditor.Changed;
begin
  FModified := true;
  FPEditBuffer := nil;
  if Assigned(FOnChange) then FOnChange(self);
  StatusChanged;
end;

procedure TRACustomEditor.StatusChanged;
begin
  if Assigned(FOnChangeStatus) then FOnChangeStatus(self);
end;

procedure TRACustomEditor.CaretFromPos(const Pos: integer; var X, Y: integer);
{возвращает по индексу Pos - номеру символа - его координаты}
begin
  GetXYByPos(FLines.Text, Pos, X, Y);
end;

function TRACustomEditor.PosFromCaret(const X, Y: integer): integer;
{наоборот}
var
  i: integer;
begin
  if (Y > FLines.Count - 1) or (Y < 0) then
    Result := -1
  else
  begin
    Result := 0;
    for i := 0 to Y - 1 do
      inc(Result, Length(FLines[i]) + 2 {CR/LF});
    if X < Length(FLines[Y]) then
      inc(Result, X)
    else
      inc(Result, Length(FLines[Y]))
  end;
end;

function TRACustomEditor.PosFromMouse(const X, Y: integer): integer;
var
  X1, Y1: integer;
begin
  Mouse2Caret(X, Y, X1, Y1);
  if (X1 < 0) or (Y1 < 0) then
    Result := -1
  else
    Result := PosFromCaret(X1, Y1);
end;

function TRACustomEditor.GetTextLen: integer;
begin
  Result := Length(FLines.Text);
end;

function TRACustomEditor.GetSelStart: integer;
begin
  Result := PosFromCaret(FSelBegX, FSelBegY);
end;

procedure TRACustomEditor.SetSelStart(const ASelStart: integer);
begin
  FSelected := true;
  CaretFromPos(ASelStart, FSelBegX, FSelBegY);
 { FCaretX := FSelBegX;
  FCaretY := FSelBegY; }
  SetCaretinternal(FSelBegX, FSelBegY);
  SetSelLength(0);
  MakeRowVisible(FSelBegY);
  //  PaintSelection;
  //  EditorPaint;
end;

procedure TRACustomEditor.MakeRowVisible(ARow: integer);
begin
  if (ARow < FTopRow) or (ARow > FLastVisibleRow) then
  begin
    ARow := ARow {mac: bugfix - FCaretY} - Trunc(VisibleRowCount / 2);
    if ARow < 0 then ARow := 0;
    SetLeftTop(FLeftCol, ARow);
  end;
end;

function TRACustomEditor.GetSelLength: integer;
begin
  Result := Length(GetSelText);
end;

procedure TRACustomEditor.SetSelLength(const ASelLength: integer);
begin
  FSelected := ASelLength > 0;
  CaretFromPos(SelStart + ASelLength, FSelEndX, FSelEndY);
  FUpdateSelBegY := FSelBegY;
  FUpdateSelEndY := FSelEndY;
  SetCaretinternal(FSelEndX, FSelEndY);
  //PaintSelection;
  invalidate;
end;

procedure TRACustomEditor.SetLockText(const Text: string);
begin
  FLines.SetLockText(Text);
end;

procedure TRACustomEditor.GutterPaint(Canvas: TCanvas);
begin
  if Assigned(FOnPaintGutter) then FOnPaintGutter(Self, Canvas);
end;

procedure TRACustomEditor.SetMode(index: integer; Value: boolean);
var
  PB: ^boolean;
begin
  case index of
    0: PB := @FinsertMode;
    else {1 :}
      PB := @FReadOnly;
  end;
  if PB^ <> Value then
  begin
    PB^ := Value;
    StatusChanged;
  end;
end;

function TRACustomEditor.GetWordOnCaret: string;
begin
  Result := GetWordOnPos(FLines[CaretY], CaretX + 1);
end;

function TRACustomEditor.GetTabStop(const X, Y: integer; const What: TTabStop;
  const Next: Boolean): integer;

  procedure UpdateTabStops;
  var
    S: string;
    j, i: integer;
  begin
    FillChar(FTabPos, sizeof(FTabPos), False);
    if (What = tsAutoindent) or FSmartTab then
    begin
      j := 1;
      i := 1;
      while Y - j >= 0 do
      begin
        S := TrimRight(FLines[Y - j]);
        if Length(S) > i then
          FTabPos[Length(S)] := True;
        while i <= Length(S) do { Iterate }
        begin
          if CharinSet(S[i], StIdSymbols) then
          begin
            FTabPos[i - 1] := True;
            while (i <= Length(S)) and CharinSet(S[i], StIdSymbols) do
              inc(i);
          end;
          inc(i);
        end; { for }
        if i >= Max_X_Scroll then Break;
        if j >= FVisibleRowCount * 2 then Break;
        inc(j);
      end;
    end;
  end;

var
  i: integer;
begin
  UpdateTabStops;
  Result := X;
  if Next then
  begin
    for i := X + 1 to High(FTabPos) do { Iterate }
      if FTabPos[i] then
      begin
        Result := i;
        Exit;
      end;
    if Result = X then
      Result := GetDefTabStop(X, True);
  end
  else
  begin
    if Result = X then
      Result := GetDefTabStop(X, False);
  end;
end;

function TRACustomEditor.GetDefTabStop(const X: integer; const Next: Boolean)
  : integer;
var
  i: integer;
  S: string;
  A, B: integer;
begin
  i := 0;
  S := Trim(SubStr(FTabStops, i, ' '));
  A := 0; B := 1;
  while S <> '' do
  begin
    A := B;
    B := StrToint(S) - 1;
    if B > X then
    begin
      Result := B;
      Exit;
    end;
    inc(i);
    S := Trim(SubStr(FTabStops, i, ' '));
  end;
  { after last tab pos }
  Result := X + ((B - A) - ((X - B) mod (B - A)));
end;

function TRACustomEditor.GetBackStop(const X, Y: integer): integer;

  procedure UpdateBackStops;
  var
    S: string;
    j, i, k: integer;
  begin
    j := 1;
    i := X - 1;
    FillChar(FTabPos, sizeof(FTabPos), False);
    FTabPos[0] := True;
    while Y - j >= 0 do
    begin
      S := FLines[Y - j];
      for k := 1 to Min(Length(S), i) do { Iterate }
        if S[k] <> ' ' then
        begin
          i := k;
          FTabPos[i - 1] := True;
          Break;
        end;
      if i = 1 then Break;
      if j >= FVisibleRowCount * 2 then Break;
      inc(j);
    end;
  end;

var
  i: integer;
  S: string;
begin
  Result := X - 1;
  S := TrimRight(FLines[Y]);
  if (Trim(Copy(S, 1, X)) = '') and
    ((X + 1 > Length(S)) or (S[X + 1] <> ' ')) then
  begin
    UpdateBackStops;
    for i := X downto 0 do
      if FTabPos[i] then
      begin
        Result := i;
        Exit;
      end;
  end;
end;

procedure TRACustomEditor.BeginCompound;
begin
  inc(FCompound);
 {$IFDEF RAEDITOR_UNDO}
  TBeginCompoundUndo.Create(Self);
 {$ENDIF RAEDITOR_UNDO}
end;

procedure TRACustomEditor.EndCompound;
begin
 {$IFDEF RAEDITOR_UNDO}
  TEndCompoundUndo.Create(Self);
 {$ENDIF RAEDITOR_UNDO}
  dec(FCompound);
end;

procedure TRACustomEditor.BeginRecord;
begin
  FMacro := '';
  FRecording := True;
  StatusChanged;
end;

procedure TRACustomEditor.EndRecord(var AMacro: TMacro);
begin
  FRecording := False;
  AMacro := FMacro;
  StatusChanged;
end;

procedure TRACustomEditor.PlayMacro(const AMacro: TMacro);
var
  i: integer;
begin
  BeginUpdate;
  BeginCompound;
  try
    i := 1;
    while i < Length(AMacro) do
    begin
      Command(byte(AMacro[i]) + byte(AMacro[i + 1]) shl 8);
      inc(i, 2);
    end;
  finally
    EndCompound;
    EndUpdate;
  end;
end;

function TRACustomEditor.CanCopy: Boolean;
begin
  Result := (FSelected) and ((FSelBegX<>FSelEndX) or
    (FSelBegY<>FSelEndY));//SeBco 03/10/01
end;

function TRACustomEditor.CanCut: Boolean;
begin
  Result := CanCopy;
end;

function TRACustomEditor.CanPaste: Boolean;
var
  H: THandle;
  Len: integer;
begin
  Result := False;
  if (FCaretY > FLines.Count - 1) and (FLines.Count > 0) then Exit;
  H := ClipBoard.GetAsHandle(CF_TEXT);
  Len := GlobalSize(H);
  Result := (Len > 0);
end;

procedure TRACustomEditor.SetCompletionImages(Value: TCustomImageList);
begin
  FCompletionImages := Value;
  if FCompletionImages <> nil then begin
    FCompletion.ItemHeight:=FCompletionImages.Height+4;
  end else begin
    FCompletion.ItemHeight:=FCompletion.FDefItemHeight;
  end;
end;

procedure TRACustomEditor.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = CompletionImages then CompletionImages := nil;
  end;
end;


{************************** TEditKey ***************************}

constructor TEditKey.Create(const ACommand: TEditCommand; const AKey1: word;
  const AShift1: TShiftState; ATypeEditKey: TTypeEditKey);
begin
  Key1 := AKey1;
  Shift1 := AShift1;
  Command := ACommand;
  TypeEditKey:=ATypeEditKey;
end;

constructor TEditKey.Create2(const ACommand: TEditCommand; const AKey1: word;
  const AShift1: TShiftState; const AKey2: word; const AShift2: TShiftState;
  ATypeEditKey: TTypeEditKey);
begin
  Key1 := AKey1;
  Shift1 := AShift1;
  Key2 := AKey2;
  Shift2 := AShift2;
  Command := ACommand;
  TypeEditKey:=ATypeEditKey;
end;

constructor TKeyboard.Create;
begin
  List := TList.Create;
end;

destructor TKeyboard.Destroy;
begin
  Clear;
  List.Free;
end;

procedure TKeyboard.Assign(Source: TKeyboard);
var
  i: Integer;
  ek: TEditKey;
begin
  Clear;
  for i:=0 to Source.GetCount-1 do begin
    ek:=Source.GetEditKey(i);
    case ek.TypeEditKey of
      tek1: begin
        Add(ek.Command,ek.Key1,ek.Shift1);
      end;  
      tek2:begin
        Add2(ek.Command,ek.Key1,ek.Shift1,ek.Key2,ek.Shift2);
      end;
    end;
  end;
end;

function TKeyboard.Add(const ACommand: TEditCommand; const AKey1: word;
  const AShift1: TShiftState): TEditKey;
begin
  Result:=TEditKey.Create(ACommand, AKey1, AShift1,tek1);
  List.Add(Result);
end;

procedure TKeyboard.Replace(EditKey: TEditKey; const ACommand: TEditCommand;
 const AKey1: word; const AShift1: TShiftState);
var
  val: integer;
begin
  val:=List.indexOf(Pointer(EditKey));
  if val<>-1 then begin
    EditKey.TypeEditKey:=tek1;
    EditKey.Command:=ACommand;
    EditKey.Key1:=AKey1;
    EditKey.Shift1:=AShift1;
  end;
end;

function TKeyboard.Add2(const ACommand: TEditCommand; const AKey1: word;
  const AShift1: TShiftState; const AKey2: word; const AShift2: TShiftState): TEditKey;
begin
  Result:=TEditKey.Create2(ACommand, AKey1, AShift1, AKey2, AShift2,tek2);
  List.Add(Result);
end;

procedure TKeyboard.Replace2(EditKey: TEditKey; const ACommand: TEditCommand;
  const AKey1: word; const AShift1: TShiftState; const AKey2: word;
  const AShift2: TShiftState);
var
  val: integer;
begin
  val:=List.indexOf(Pointer(EditKey));
  if val<>-1 then begin
    EditKey.TypeEditKey:=tek1;
    EditKey.Command:=ACommand;
    EditKey.Key1:=AKey1;
    EditKey.Shift1:=AShift1;
    EditKey.Key2:=AKey2;
    EditKey.Shift2:=AShift2;
  end;
end;

procedure TKeyboard.Clear;
var
  i: integer;
begin
  for i := 0 to List.Count - 1 do
    TObject(List[i]).Free;
  List.Clear;
end;

function TKeyboard.Command(const AKey: word; const AShift: TShiftState):
  TEditCommand;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to List.Count - 1 do
    with TEditKey(List[i]) do
      if (Key1 = AKey) and (Shift1 = AShift) then
      begin
        if Key2 = 0 then
          Result := Command
        else
          Result := twoKeyCommand;
        Exit;
      end;
end;

function TKeyboard.Command2(const AKey1: word; const AShift1: TShiftState;
  const AKey2: word; const AShift2: TShiftState): TEditCommand;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to List.Count - 1 do
    with TEditKey(List[i]) do
      if (Key1 = AKey1) and (Shift1 = AShift1) and
        (Key2 = AKey2) and (Shift2 = AShift2) then
      begin
        Result := Command;
        Exit;
      end;
end;

function TKeyboard.GetCount: integer;
begin
  Result:=List.Count;
end;

function TKeyboard.GetEditKey(index: integer): TEditKey;
begin
  Result:=TEditKey(List.Items[index]);
end;

procedure TKeyboard.RemoveEditKey(EditKey: TEditKey);
var
  val: integer;
begin
  val:=List.indexOf(Pointer(EditKey));
  if val<>-1 then List.Delete(val);
end;

procedure TKeyboard.GetListByCommand(ACommand: TEditCommand; AList: TList);
var
  i: Integer;
  E: TEditKey;
begin
  if AList=nil then exit;
  for i:=0 to List.Count-1 do begin
    E:=List.Items[i];
    if E.Command=ACommand then AList.Add(E);
  end;
end;

{$IFDEF RAEDITOR_EDITOR}
{$IFDEF RAEDITOR_DEFLAYOT}

procedure TKeyboard.SetDefLayot;
begin
  Clear;
  Add(ecLeft, VK_LEFT, []);
  Add(ecRight, VK_RIGHT, []);
  Add(ecUp, VK_UP, []);
  Add(ecDown, VK_DOWN, []);
  Add(ecSelLeft, VK_LEFT, [ssShift]);
  Add(ecSelRight, VK_RIGHT, [ssShift]);
  Add(ecSelUp, VK_UP, [ssShift]);
  Add(ecSelDown, VK_DOWN, [ssShift]);
  Add(ecBeginLine, VK_HOME, []);
  Add(ecSelBeginLine, VK_HOME, [ssShift]);
  Add(ecBeginDoc, VK_HOME, [ssCtrl]);
  Add(ecSelBeginDoc, VK_HOME, [ssCtrl, ssShift]);
  Add(ecEndLine, VK_END, []);
  Add(ecSelEndLine, VK_END, [ssShift]);
  Add(ecEndDoc, VK_END, [ssCtrl]);
  Add(ecSelEndDoc, VK_END, [ssCtrl, ssShift]);
  Add(ecPrevWord, VK_LEFT, [ssCtrl]);
  Add(ecNextWord, VK_RIGHT, [ssCtrl]);
  Add(ecSelPrevWord, VK_LEFT, [ssCtrl, ssShift]);
  Add(ecSelNextWord, VK_RIGHT, [ssCtrl, ssShift]);
  Add(ecSelAll, ord('A'), [ssCtrl]);

  Add(ecWindowTop, VK_PRIOR, [ssCtrl]);
  Add(ecWindowBottom, VK_NEXT, [ssCtrl]);
  Add(ecPrevPage, VK_PRIOR, []);
  Add(ecNextPage, VK_NEXT, []);
  Add(ecSelPrevPage, VK_PRIOR, [ssShift]);
  Add(ecSelNextPage, VK_NEXT, [ssShift]);
  Add(ecScrollLineUp, VK_UP, [ssCtrl]);
  Add(ecScrollLineDown, VK_DOWN, [ssCtrl]);

  Add(ecChangeinsertMode, VK_inSERT, []);

  Add(ecinsertPara, VK_RETURN, []);
  Add(ecBackspace, VK_BACK, []);
  Add(ecDelete, VK_DELETE, []);
  Add(ecTab, VK_TAB, []);
  Add(ecBackTab, VK_TAB, [ssShift]);
  Add(ecDeleteSelected, VK_DELETE, [ssCtrl]);
  Add(ecClipboardCopy, VK_inSERT, [ssCtrl]);
  Add(ecClipboardCut, VK_DELETE, [ssShift]);
  Add(ecClipBoardPaste, VK_inSERT, [ssShift]);

  Add(ecClipboardCopy, ord('C'), [ssCtrl]);
  Add(ecClipboardCut, ord('X'), [ssCtrl]);
  Add(ecClipBoardPaste, ord('V'), [ssCtrl]);


  Add(ecSetBookmark0, ord('0'), [ssCtrl, ssShift]);
  Add(ecSetBookmark1, ord('1'), [ssCtrl, ssShift]);
  Add(ecSetBookmark2, ord('2'), [ssCtrl, ssShift]);
  Add(ecSetBookmark3, ord('3'), [ssCtrl, ssShift]);
  Add(ecSetBookmark4, ord('4'), [ssCtrl, ssShift]);
  Add(ecSetBookmark5, ord('5'), [ssCtrl, ssShift]);
  Add(ecSetBookmark6, ord('6'), [ssCtrl, ssShift]);
  Add(ecSetBookmark7, ord('7'), [ssCtrl, ssShift]);
  Add(ecSetBookmark8, ord('8'), [ssCtrl, ssShift]);
  Add(ecSetBookmark9, ord('9'), [ssCtrl, ssShift]);

  Add(ecGotoBookmark0, ord('0'), [ssCtrl]);
  Add(ecGotoBookmark1, ord('1'), [ssCtrl]);
  Add(ecGotoBookmark2, ord('2'), [ssCtrl]);
  Add(ecGotoBookmark3, ord('3'), [ssCtrl]);
  Add(ecGotoBookmark4, ord('4'), [ssCtrl]);
  Add(ecGotoBookmark5, ord('5'), [ssCtrl]);
  Add(ecGotoBookmark6, ord('6'), [ssCtrl]);
  Add(ecGotoBookmark7, ord('7'), [ssCtrl]);
  Add(ecGotoBookmark8, ord('8'), [ssCtrl]);
  Add(ecGotoBookmark9, ord('9'), [ssCtrl]);

  Add2(ecSetBookmark0, ord('K'), [ssCtrl], ord('0'), []);
  Add2(ecSetBookmark0, ord('K'), [ssCtrl], ord('0'), [ssCtrl]);
  Add2(ecSetBookmark1, ord('K'), [ssCtrl], ord('1'), []);
  Add2(ecSetBookmark1, ord('K'), [ssCtrl], ord('1'), [ssCtrl]);
  Add2(ecSetBookmark2, ord('K'), [ssCtrl], ord('2'), []);
  Add2(ecSetBookmark2, ord('K'), [ssCtrl], ord('2'), [ssCtrl]);
  Add2(ecSetBookmark3, ord('K'), [ssCtrl], ord('3'), []);
  Add2(ecSetBookmark3, ord('K'), [ssCtrl], ord('3'), [ssCtrl]);
  Add2(ecSetBookmark4, ord('K'), [ssCtrl], ord('4'), []);
  Add2(ecSetBookmark4, ord('K'), [ssCtrl], ord('4'), [ssCtrl]);
  Add2(ecSetBookmark5, ord('K'), [ssCtrl], ord('5'), []);
  Add2(ecSetBookmark5, ord('K'), [ssCtrl], ord('5'), [ssCtrl]);
  Add2(ecSetBookmark6, ord('K'), [ssCtrl], ord('6'), []);
  Add2(ecSetBookmark6, ord('K'), [ssCtrl], ord('6'), [ssCtrl]);
  Add2(ecSetBookmark7, ord('K'), [ssCtrl], ord('7'), []);
  Add2(ecSetBookmark7, ord('K'), [ssCtrl], ord('7'), [ssCtrl]);
  Add2(ecSetBookmark8, ord('K'), [ssCtrl], ord('8'), []);
  Add2(ecSetBookmark8, ord('K'), [ssCtrl], ord('8'), [ssCtrl]);
  Add2(ecSetBookmark9, ord('K'), [ssCtrl], ord('9'), []);
  Add2(ecSetBookmark9, ord('K'), [ssCtrl], ord('9'), [ssCtrl]);

  Add2(ecGotoBookmark0, ord('Q'), [ssCtrl], ord('0'), []);
  Add2(ecGotoBookmark0, ord('Q'), [ssCtrl], ord('0'), [ssCtrl]);
  Add2(ecGotoBookmark1, ord('Q'), [ssCtrl], ord('1'), []);
  Add2(ecGotoBookmark1, ord('Q'), [ssCtrl], ord('1'), [ssCtrl]);
  Add2(ecGotoBookmark2, ord('Q'), [ssCtrl], ord('2'), []);
  Add2(ecGotoBookmark2, ord('Q'), [ssCtrl], ord('2'), [ssCtrl]);
  Add2(ecGotoBookmark3, ord('Q'), [ssCtrl], ord('3'), []);
  Add2(ecGotoBookmark3, ord('Q'), [ssCtrl], ord('3'), [ssCtrl]);
  Add2(ecGotoBookmark4, ord('Q'), [ssCtrl], ord('4'), []);
  Add2(ecGotoBookmark4, ord('Q'), [ssCtrl], ord('4'), [ssCtrl]);
  Add2(ecGotoBookmark5, ord('Q'), [ssCtrl], ord('5'), []);
  Add2(ecGotoBookmark5, ord('Q'), [ssCtrl], ord('5'), [ssCtrl]);
  Add2(ecGotoBookmark6, ord('Q'), [ssCtrl], ord('6'), []);
  Add2(ecGotoBookmark6, ord('Q'), [ssCtrl], ord('6'), [ssCtrl]);
  Add2(ecGotoBookmark7, ord('Q'), [ssCtrl], ord('7'), []);
  Add2(ecGotoBookmark7, ord('Q'), [ssCtrl], ord('7'), [ssCtrl]);
  Add2(ecGotoBookmark8, ord('Q'), [ssCtrl], ord('8'), []);
  Add2(ecGotoBookmark8, ord('Q'), [ssCtrl], ord('8'), [ssCtrl]);
  Add2(ecGotoBookmark9, ord('Q'), [ssCtrl], ord('9'), []);
  Add2(ecGotoBookmark9, ord('Q'), [ssCtrl], ord('9'), [ssCtrl]);

  Add2(ecNoninclusiveBlock, ord('O'), [ssCtrl], ord('K'), [ssCtrl]);
  Add2(ecinclusiveBlock, ord('O'), [ssCtrl], ord('I'), [ssCtrl]);
  Add2(ecColumnBlock, ord('O'), [ssCtrl], ord('C'), [ssCtrl]);

  {$IFDEF RAEDITOR_UNDO}
  Add(ecUndo, ord('Z'), [ssCtrl]);
  Add(ecUndo, VK_BACK, [ssAlt]);
  {$ENDIF RAEDITOR_UNDO}

  {$IFDEF RAEDITOR_COMPLETION}
  Add(ecCompletionIdentifers, VK_SPACE, [ssCtrl]);
  Add(ecCompletionTemplates, ord('J'), [ssCtrl]);
  {$ENDIF RAEDITOR_COMPLETION}

  { cursor movement - default and classic }
  Add2(ecEndDoc, ord('Q'), [ssCtrl], ord('C'), []);
  Add2(ecEndLine, ord('Q'), [ssCtrl], ord('D'), []);
  Add2(ecWindowTop, ord('Q'), [ssCtrl], ord('E'), []);
  Add2(ecLeft, ord('Q'), [ssCtrl], ord('P'), []);
  Add2(ecBeginDoc, ord('Q'), [ssCtrl], ord('R'), []);
  Add2(ecBeginLine, ord('Q'), [ssCtrl], ord('S'), []);
  Add2(ecWindowTop, ord('Q'), [ssCtrl], ord('T'), []);
  Add2(ecWindowBottom, ord('Q'), [ssCtrl], ord('U'), []);
  Add2(ecWindowBottom, ord('Q'), [ssCtrl], ord('X'), []);
  Add2(ecEndDoc, ord('Q'), [ssCtrl], ord('C'), [ssCtrl]);
  Add2(ecEndLine, ord('Q'), [ssCtrl], ord('D'), [ssCtrl]);
  Add2(ecWindowTop, ord('Q'), [ssCtrl], ord('E'), [ssCtrl]);
  Add2(ecLeft, ord('Q'), [ssCtrl], ord('P'), [ssCtrl]);
  Add2(ecBeginDoc, ord('Q'), [ssCtrl], ord('R'), [ssCtrl]);
  Add2(ecBeginLine, ord('Q'), [ssCtrl], ord('S'), [ssCtrl]);
  Add2(ecWindowTop, ord('Q'), [ssCtrl], ord('T'), [ssCtrl]);
  Add2(ecWindowBottom, ord('Q'), [ssCtrl], ord('U'), [ssCtrl]);
  Add2(ecWindowBottom, ord('Q'), [ssCtrl], ord('X'), [ssCtrl]);

  Add(ecDeleteWord, ord('T'), [ssCtrl]);
//  Add(ecinsertPara, ord('N'), [ssCtrl]);
  Add(ecDeleteLine, ord('Y'), [ssCtrl]);

  Add2(ecSelWord, ord('K'), [ssCtrl], ord('T'), [ssCtrl]);
  Add2(ecToUpperCase, ord('K'), [ssCtrl], ord('O'), [ssCtrl]);
  Add2(ecToLowerCase, ord('K'), [ssCtrl], ord('N'), [ssCtrl]);
  Add2(ecChangeCase, ord('O'), [ssCtrl], ord('U'), [ssCtrl]);
  Add2(ecindent, ord('K'), [ssCtrl], ord('I'), [ssCtrl]);
  Add2(ecUnindent, ord('K'), [ssCtrl], ord('U'), [ssCtrl]);

  Add(ecRecordMacro, ord('R'), [ssCtrl, ssShift]);
  Add(ecPlayMacro, ord('P'), [ssCtrl, ssShift]);

  Add(ecNewScript, ord('N'), [ssCtrl]);
  Add(ecOpenScript, ord('L'), [ssCtrl]);
  Add(ecSaveScriptToBase, ord('S'), [ssCtrl]);
  Add(ecRunScript, VK_F9, []);
  Add(ecResetScript, VK_F2, [ssCtrl]);
  Add(ecGotoLine, ord('G'), [ssCtrl]);
  Add(ecFind, ord('F'), [ssCtrl]);
  Add(ecFindNext, VK_F3, []);
  Add(ecReplace, ord('R'), [ssCtrl]);
  Add(ecViewForms, VK_F12, []);

end;
{$ENDIF RAEDITOR_DEFLAYOT}


{$IFDEF RAEDITOR_UNDO}

procedure RedoNotImplemented;
begin
  raise ERAEditorError.Create('Redo not yet implemented');
end;

procedure TRACustomEditor.NotUndoable;
begin
  FUndoBuffer.Clear;
end;

procedure TUndoBuffer.Add(AUndo: TUndo);
begin
  if inUndo then exit;
  while (Count > 0) and (FPtr < Count - 1) do
  begin
    TUndo(Items[FPtr + 1]).Free;
    inherited Delete(FPtr + 1);
  end;
  inherited Add(AUndo);
  FPtr := Count - 1;
end;

procedure TUndoBuffer.Undo;
var
  UndoClass: TClass;
  Compound: integer;
begin
  inUndo := true;
  try
    if LastUndo <> nil then
    begin
      Compound := 0;
      UndoClass := LastUndo.ClassType;
      while (LastUndo <> nil) and
        ((UndoClass = LastUndo.ClassType) or
        (LastUndo is TDeleteTrailUndo) or
        (LastUndo is TReLineUndo) or
        (Compound > 0)) do
      begin
        if LastUndo.ClassType = TBeginCompoundUndo then
        begin
          dec(Compound);
          UndoClass := nil;
        end
        else if LastUndo.ClassType = TEndCompoundUndo then
          inc(Compound);
        LastUndo.Undo;
        dec(FPtr);
        if (UndoClass = TDeleteTrailUndo) or
          (UndoClass = TReLineUndo) then
          UndoClass := LastUndo.ClassType;
        if not FRAEditor.FGroupUndo then break;
        // FRAEditor.Paint; {DEBUG !!!!!!!!!}
      end;
      if FRAEditor.FUpdateLock = 0 then
      begin
        FRAEditor.TextAllChangedinternal(False);
        FRAEditor.Changed;
      end;
    end;
  finally
    inUndo := false;
  end;
end;

procedure TUndoBuffer.Redo;
begin
  { DEBUG !!!! }
 { LastUndo.Redo;
  inc(FPtr); }
end;

procedure TUndoBuffer.Clear;
begin
  while Count > 0 do
  begin
    TUndo(Items[0]).Free;
    inherited Delete(0);
  end;
end;

procedure TUndoBuffer.Delete;
begin
  if Count > 0 then
  begin
    TUndo(Items[Count - 1]).Free;
    inherited Delete(Count - 1);
  end;
end;

function TUndoBuffer.LastUndo: TUndo;
begin
  if (FPtr >= 0) and (Count > 0) then
    Result := TUndo(Items[FPtr])
  else
    Result := nil;
end;

function TUndoBuffer.IsNewGroup(AUndo: TUndo): boolean;
begin
  Result := (LastUndo = nil) or (LastUndo.ClassType <> AUndo.ClassType)
end;

function TUndoBuffer.CanUndo: boolean;
begin
  Result := (LastUndo <> nil);
end;

{* TUndo}

constructor TUndo.Create(ARAEditor: TRACustomEditor);
begin
  FRAEditor := ARAEditor;
  UndoBuffer.Add(Self);
end;

function TUndo.UndoBuffer: TUndoBuffer;
begin
  if FRAEditor <> nil then
    Result := FRAEditor.FUndoBuffer
  else
    Result := nil;
end;
{* TUndo}

{* TCaretUndo}

constructor TCaretUndo.Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY:
  integer);
begin
  inherited Create(ARAEditor);
  FCaretX := ACaretX;
  FCaretY := ACaretY;
end;

procedure TCaretUndo.Undo;
begin
  with UndoBuffer do
  begin
    dec(FPtr);
    while FRAEditor.FGroupUndo and (FPtr >= 0) and not IsNewGroup(Self) do
      dec(FPtr);
    inc(FPtr);
    with TCaretUndo(Items[FPtr]) do
      FRAEditor.SetCaretinternal(FCaretX, FCaretY);
  end;
end;

procedure TCaretUndo.Redo;
begin
//  RedoNotImplemented;
end;
{# TCaretUndo}

{* TinsertUndo}

constructor TinsertUndo.Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY:
  integer; AText: string);
begin
  inherited Create(ARAEditor, ACaretX, ACaretY);
  FText := AText;
end;

procedure TinsertUndo.Undo;
var
  S, Text: string;
  iBeg: integer;
begin
  Text := '';
  with UndoBuffer do
  begin
    while (FPtr >= 0) and not IsNewGroup(Self) do
    begin
      Text := TinsertUndo(LastUndo).FText + Text;
      dec(FPtr);
      if not FRAEditor.FGroupUndo then break;
    end;
    inc(FPtr);
  end;
  with TinsertUndo(UndoBuffer.Items[UndoBuffer.FPtr]) do
  begin
    S := FRAEditor.FLines.Text;
    iBeg := FRAEditor.PosFromCaret(FCaretX, FCaretY);
    Delete(S, iBeg + 1, Length(Text));
    FRAEditor.FLines.SetLockText(S);
    FRAEditor.SetCaretinternal(FCaretX, FCaretY);
  end;
end;

{ TinsertColumnUndo }
procedure TinsertColumnUndo.Undo;
var
  SS: TStringList;
  i: integer;
  S: string;
begin
  { not optimized }
  SS := TStringList.Create;
  try
    SS.Text := FText;
    for i := 0 to SS.Count - 1 do
    begin
      S := FRAEditor.FLines[FCaretY + i];
      Delete(S, FCaretX + 1, Length(SS[i]));
      FRAEditor.FLines[FCaretY + i] := S;
    end;
  finally
    SS.Free;
  end;
  FRAEditor.SetCaretinternal(FCaretX, FCaretY);
end;

constructor TOverwriteUndo.Create(ARAEditor: TRACustomEditor; ACaretX,
  ACaretY: integer; AOldText, ANewText: string);
begin
  inherited Create(ARAEditor, ACaretX, ACaretY);
  FOldText := AOldText;
  FNewText := ANewText;
end;

procedure TOverwriteUndo.Undo;
var
  S: string;
begin
  { not optimized }
  S := FRAEditor.Lines[FCaretY];
  S[FCaretX + 1] := FOldText[1];
  FRAEditor.Lines[FCaretY] := S;
  FRAEditor.SetCaretinternal(FCaretX, FCaretY);
end;

{* TDeleteUndo}

procedure TDeleteUndo.Undo;
var
  S, Text: string;
  iBeg: integer;
begin
  Text := '';
  with UndoBuffer do
  begin
    while (FPtr >= 0) and not IsNewGroup(Self) do
    begin
      Text := TDeleteUndo(LastUndo).FText + Text;
      dec(FPtr);
      if not FRAEditor.FGroupUndo then break;
    end;
    inc(FPtr);
  end;
  with TDeleteUndo(UndoBuffer.Items[UndoBuffer.FPtr]) do
  begin
    S := FRAEditor.FLines.Text;
    iBeg := FRAEditor.PosFromCaret({mac: FRAEditor.}FCaretX, {mac: FRAEditor.}FCaretY);
    insert(Text, S, iBeg + 1);
    FRAEditor.FLines.SetLockText(S);
    FRAEditor.SetCaretinternal(FCaretX, FCaretY);
  end;
end;
{# TDeleteUndo}

{* TBackspaceUndo}

procedure TBackspaceUndo.Undo;
var
  S, Text: string;
  iBeg: integer;
begin
  Text := '';
  with UndoBuffer do
  begin
    while (FPtr >= 0) and not IsNewGroup(Self) do
    begin
      Text := Text + TDeleteUndo(LastUndo).FText;
      dec(FPtr);
      if not FRAEditor.FGroupUndo then break;
    end;
    inc(FPtr);
  end;
  with TDeleteUndo(UndoBuffer.Items[UndoBuffer.FPtr]) do
  begin
    S := FRAEditor.FLines.Text;
    iBeg := FRAEditor.PosFromCaret({mac: FRAEditor.}FCaretX, {mac: FRAEditor.}FCaretY);
    insert(Text, S, iBeg + 1);
    FRAEditor.FLines.SetLockText(S);
    FRAEditor.SetCaretinternal(FCaretX, FCaretY);
  end;
end;
{# TBackspaceUndo}

{* TReplaceUndo}

constructor TReplaceUndo.Create(ARAEditor: TRACustomEditor; ACaretX, ACaretY:
  integer; ABeg, AEnd: integer; AText, ANewText: string);
begin
  inherited Create(ARAEditor, ACaretX, ACaretY);
  FBeg := ABeg;
  FEnd := AEnd;
  FText := AText;
  FNewText := ANewText;
end;

procedure TReplaceUndo.Undo;
var
  S: string;
begin
  S := FRAEditor.FLines.Text;
  Delete(S, FBeg, Length(FNewText));
  insert(FText, S, FBeg);
  FRAEditor.FLines.SetLockText(S);
  FRAEditor.SetCaretinternal(FCaretX, FCaretY);
end;
{# TReplaceUndo}

{* TDeleteSelectedUndo}

constructor TDeleteSelectedUndo.Create(ARAEditor: TRACustomEditor; ACaretX,
  ACaretY: integer; AText: string; ASelBlockFormat: TSelBlockFormat;
  ASelBegX, ASelBegY, ASelEndX, ASelEndY: integer);
begin
  inherited Create(ARAEditor, ACaretX, ACaretY, AText);
  FSelBlockFormat := ASelBlockFormat;
  FSelBegX := ASelBegX;
  FSelBegY := ASelBegY;
  FSelEndX := ASelEndX;
  FSelEndY := ASelEndY;
end;

procedure TDeleteSelectedUndo.Undo;
var
  S: string;
  iBeg: integer;
  i: integer;
begin
    if FSelBlockFormat in [bfinclusive, bfNoninclusive] then
    begin
      S := FRAEditor.FLines.Text;
      iBeg := FRAEditor.PosFromCaret(FSelBegX, FSelBegY);
      insert(FText, S, iBeg + 1);
      FRAEditor.FLines.SetLockText(S);
    end
    else if FSelBlockFormat = bfColumn then
    begin
      for i := FSelBegY to FSelEndY do
      begin
        S := FRAEditor.FLines[i];
        insert(SubStr(FText, i - FSelBegY, #13#10), S, FSelBegX + 1);
        FRAEditor.FLines[i] := S;
      end;
    end;
    FRAEditor.FSelBegX := FSelBegX;
    FRAEditor.FSelBegY := FSelBegY;
    FRAEditor.FSelEndX := FSelEndX;
    FRAEditor.FSelEndY := FSelEndY;
    FRAEditor.FSelBlockFormat := FSelBlockFormat;
    FRAEditor.FSelected := Length(FText) > 0;
    FRAEditor.SetCaretinternal(FCaretX, FCaretY);
end;
{# TDeleteSelectedUndo}

{* TSelectUndo}

constructor TSelectUndo.Create(ARAEditor: TRACustomEditor; ACaretX,
  ACaretY: integer; ASelected: boolean; ASelBlockFormat: TSelBlockFormat;
  ASelBegX, ASelBegY, ASelEndX, ASelEndY: integer);
begin
  inherited Create(ARAEditor, ACaretX, ACaretY);
  FSelected := ASelected;
  FSelBlockFormat := ASelBlockFormat;
  FSelBegX := ASelBegX;
  FSelBegY := ASelBegY;
  FSelEndX := ASelEndX;
  FSelEndY := ASelEndY;
end;

procedure TSelectUndo.Undo;
begin
  FRAEditor.FSelected := FSelected;
  FRAEditor.FSelBlockFormat := FSelBlockFormat;
  FRAEditor.FSelBegX := FSelBegX;
  FRAEditor.FSelBegY := FSelBegY;
  FRAEditor.FSelEndX := FSelEndX;
  FRAEditor.FSelEndY := FSelEndY;
  FRAEditor.SetCaretinternal(FCaretX, FCaretY);
end;
{# TSelectUndo}

procedure TBeginCompoundUndo.Undo;
begin
  { nothing }
end;

{$ENDIF RAEDITOR_UNDO}

{#####################  Undo  #####################}


{*********************  Code Completion  *********************}
{$IFDEF RAEDITOR_COMPLETION}

procedure TRACustomEditor.CompletionIdentifer(var Cancel: boolean);
begin
  {abstract}
end;

procedure TRACustomEditor.CompletionTemplate(var Cancel: boolean);
begin
  {abstract}
end;

procedure TRACustomEditor.DoCompletionIdentifer(var Cancel: boolean);
begin
  CompletionIdentifer(Cancel);
  if Assigned(FOnCompletionIdentifer) then FOnCompletionIdentifer(Self, Cancel);
end;

procedure TRACustomEditor.DoCompletionTemplate(var Cancel: boolean);
begin
  CompletionTemplate(Cancel);
  if Assigned(FOnCompletionTemplate) then FOnCompletionTemplate(Self, Cancel);
end;



{ TCompletionItemCaption }

constructor TCompletionItemCaption.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFont := TFont.Create;
  FBrush:= TBrush.Create;
  FPen:=TPen.Create;
  FWidth:=50;
end;

destructor TCompletionItemCaption.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  Inherited Destroy;
end;

procedure TCompletionItemCaption.SetAlignment(Value: TAlignment);
begin
  if Value<>FAlignment then begin
    FAlignment:=Value;
  end;
end;

procedure TCompletionItemCaption.SetWidth(Value: Integer);
begin
  if Value<>FWidth then begin
    FWidth:=Value;
  end;
end;

procedure TCompletionItemCaption.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCompletionItemCaption.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TCompletionItemCaption.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TCompletionItemCaption.SetCaption(Value: String);
begin
  if Value<>FCaption then begin
    FCaption:=Value;
  end;
end;

procedure TCompletionItemCaption.SetAutoSize(Value: Boolean);
begin
  if Value<>FAutoSize then begin
    FAutoSize:=Value;
  end;
end;

procedure TCompletionItemCaption.Assign(Source: TPersistent);
begin
  if Source is TCompletionItemCaption then begin
    FAutoSize:=TCompletionItemCaption(Source).AutoSize;
    FAlignment:=TCompletionItemCaption(Source).Alignment;
    FCaption:=TCompletionItemCaption(Source).Caption;
    FWidth:=TCompletionItemCaption(Source).Width;
    FFont.Assign(TCompletionItemCaption(Source).Font);
    FBrush.Assign(TCompletionItemCaption(Source).Brush);
    FPen.Assign(TCompletionItemCaption(Source).Pen);
  end else
   inherited;
end;

{ TCompletionItemCaptions }

constructor TCompletionItemCaptions.Create(AOwner: TCompletionItem; CompletionItemCaptionClass: TCompletionItemCaptionClass);
begin
  inherited Create(CompletionItemCaptionClass);
  FItem := AOwner;
end;

function TCompletionItemCaptions.GetCompletionItemCaption(Index: Integer): TCompletionItemCaption;
begin
  Result := TCompletionItemCaption(inherited Items[Index]);
end;

procedure TCompletionItemCaptions.SetCompletionItemCaption(Index: Integer; Value: TCompletionItemCaption);
begin
  Items[Index].Assign(Value);
end;

function TCompletionItemCaptions.GetOwner: TPersistent;
begin
  Result := FItem;
end;

procedure TCompletionItemCaptions.Update(Item: TCollectionItem);
begin
  if (FItem = nil)  then Exit;
end;

function TCompletionItemCaptions.Add: TCompletionItemCaption;
begin
  Result := TCompletionItemCaption(inherited Add);
end;

procedure TCompletionItemCaptions.Clear;
begin
  inherited Clear;
end;

procedure TCompletionItemCaptions.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

function TCompletionItemCaptions.Insert(Index: Integer): TCompletionItemCaption;
begin
  Result:=TCompletionItemCaption(inherited Insert(Index));
end;

{ TCompletionItem }

constructor TCompletionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  if not TCompletionItems(Collection).FNoUseListBox then
   TCompletionItems(Collection).FCompletion.FPopupList.Items.Add('');
  FCaptionEx:=TCompletionItemCaptions.Create(Self,TCompletionItemCaption);
  FFont := TFont.Create;
  FBrush:= TBrush.Create;
  FPen:=TPen.Create;
  FInsertedText:=TStringList.Create;
  FImageIndex:=-1;
end;

destructor TCompletionItem.Destroy;
begin
  FInsertedText.Free;
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  FCaptionEx.Free;
  Inherited Destroy;
end;

procedure TCompletionItem.SetImageIndex(Value: TImageIndex);
begin
  if Value<>FImageIndex then begin
    FImageIndex:=Value;
  end;
end;

procedure TCompletionItem.SetCaption(Value: String);
begin
  if Value<>FCaption then begin
    FCaption:=Value;
    if not TCompletionItems(Collection).FNoUseListBox then
     TCompletionItems(Collection).FCompletion.FPopupList.Items[Index]:=Value;
  end;
end;

procedure TCompletionItem.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCompletionItem.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TCompletionItem.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TCompletionItem.SetCaptionEx(Value: TCompletionItemCaptions);
begin
  FCaptionEx.Assign(Value);
end;

procedure TCompletionItem.SetInsertedText(Value: TStrings);
begin
  FInsertedText.Assign(Value);
end;

procedure TCompletionItem.Assign(Source: TPersistent);
begin
  if Source is TCompletionItem then begin
    FImageIndex:=TCompletionItem(Source).ImageIndex;
    FCaption:=TCompletionItem(Source).Caption;
    FCaptionEx.Assign(TCompletionItem(Source).CaptionEx);
    FFont.Assign(TCompletionItem(Source).Font);
    FBrush.Assign(TCompletionItem(Source).Brush);
    FPen.Assign(TCompletionItem(Source).Pen);
    FInsertedText.Assign(TCompletionItem(Source).InsertedText);
  end else
   inherited;
end;

{ TCompletionItems }

constructor TCompletionItems.Create(AOwner: TCompletion; CompletionItemClass: TCompletionItemClass);
begin
  inherited Create(CompletionItemClass);
  FCompletion := AOwner;
end;

destructor TCompletionItems.Destroy;
begin
  inherited Destroy;
end;

function TCompletionItems.GetCompletionItem(Index: Integer): TCompletionItem;
begin
  Result := TCompletionItem(inherited Items[Index]);
end;

procedure TCompletionItems.SetCompletionItem(Index: Integer; Value: TCompletionItem);
begin
  Items[Index].Assign(Value);
end;

function TCompletionItems.GetOwner: TPersistent;
begin
  Result := FCompletion;
end;

procedure TCompletionItems.Update(Item: TCollectionItem);
begin
  if (FCompletion = nil)  then Exit;
end;

function TCompletionItems.Add: TCompletionItem;
begin
  Result := TCompletionItem(inherited Add);
end;

procedure TCompletionItems.Clear;
begin
  if not FNoUseListBox then
   FCompletion.FPopupList.Items.Clear;
  inherited Clear;
end;

procedure TCompletionItems.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

procedure TCompletionItems.Delete(Index: Integer);
begin
  if not FNoUseListBox then
   FCompletion.FPopupList.Items.Delete(Index);
  Inherited Delete(Index);
end;

function TCompletionItems.Insert(Index: Integer): TCompletionItem;
begin
  if not FNoUseListBox then
   FCompletion.FPopupList.Items.Insert(Index,'');
  Result:=TCompletionItem(Inherited Insert(Index));
end;

procedure TCompletionItems.BeginUpdate;
begin
  inherited BeginUpdate;
end;

procedure TCompletionItems.EndUpdate;
begin
  inherited EndUpdate;
end;

type
  TRAEditorCompletionList = class(TListBox)
  private
    FCompletion: TCompletion;
    FTimer: TTimer;
    YY: integer;
    // HintWindow : THintWindow;
    procedure CMHintShow(var Message: TMessage); message CM_HinTSHOW;
    procedure WMCancelMode(var Message: TMessage); message WM_CancelMode;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
//    procedure WMGETMINMAXINFO(var msg: TMessage); message WM_GETMINMAXINFO;

    procedure OnTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
      integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
      override;
    procedure DrawItem(index: integer; Rect: TRect; State: TOwnerDrawState); override;
//    procedure DrawItem(index: integer; Rect: TRect; State: TOwnerDrawState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

constructor TCompletion.Create2(ARAEditor: TRACustomEditor);
begin
  inherited Create;
  FRAEditor := ARAEditor;
  FPopupList := TRAEditorCompletionList.Create(FRAEditor);
  TRAEditorCompletionList(FPopupList).FCompletion:=Self;
  FDefItemHeight:=16;
  FDropDownCount:=6;
  FDropDownWidth:=300;
  FPopupList.Width:=FDropDownWidth;
  FPopupList.Constraints.MinHeight:=FPopupList.ItemHeight*FDropDownCount;
  FPopupList.Constraints.MinWidth:=FDropDownWidth;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := false;
  FTimer.interval := 800;
  FTimer.OnTimer := OnTimer;
  FIdentifers := TCompletionItems.Create(Self,TCompletionItem);
  FIdentifers.FNoUseListBox:=true;
  FTemplates := TCompletionItems.Create(Self,TCompletionItem);
  FTemplates.FNoUseListBox:=true;
  FItems := TCompletionItems.Create(Self,TCompletionItem);
  FItems.FNoUseListBox:=false;
  FDefMode := cmIdentifers;
  FCaretChar := '|';
{  FCRLF := '/n';
  FSeparator := '=';}
end;

destructor TCompletion.Destroy;
begin
  CloseUp(False);
  FreeAndNil(FItems);
  inherited Destroy;

  FPopupList.Free;
  FIdentifers.Free;
  FTemplates.Free;

  FTimer.Free;
end;

procedure TCompletion.Assign(Source: TPersistent);
begin
  if Source is TCompletion then begin
   FIdentifers.Assign(TCompletion(Source).FIdentifers);
   FTemplates.Assign(TCompletion(Source).FTemplates);
   FItems.Assign(TCompletion(Source).FItems);
   FDropDownCount := TCompletion(Source).FDropDownCount;
   FDropDownWidth := TCompletion(Source).FDropDownWidth;
   FDefMode := TCompletion(Source).FDefMode;
   FCaretChar := TCompletion(Source).FCaretChar;
{   FCRLF := TCompletion(Source).FCRLF;
   FSeparator := TCompletion(Source).FSeparator;}
  end else
    inherited;
end;

function TCompletion.GetItems: TCompletionItems;
begin
  case FMode of
    cmIdentifers: Result := FIdentifers;
    cmTemplates: Result := FTemplates;
  else
    Result := nil;
  end;
end;

{заменяет слово в позиции курсора на NewString}

procedure TCompletion.ReplaceWord(const NewString: string);
var
  S, S1, W: string;
  P, X, Y: integer;
  iBeg, iEnd: integer;
  NewCaret, LNum, CX, CY, i: integer;
begin
  with FRAEditor do
  begin
    PaintCaret(false);
    BeginUpdate;
    ReLine;
    S := FLines.Text;
    P := PosFromCaret(FCaretX, FCaretY);
    if (P = 0) or (S[P] in Separators) then
      W := ''
    else
      W := Trim(GetWordOnPosEx(S, P, iBeg, iEnd));
    LNum := 0;
    CaretFromPos(iBeg, CX, CY);
    if W = '' then
    begin
      iBeg := P + 1;
      iEnd := P
    end;
    case FMode of
      cmIdentifers:
        begin
          S1 := NewString;
          if Assigned(FOnCompletionApply) then
            FOnCompletionApply(Self, W, S1);
          NewCaret := Length(S1);
        end;
      cmTemplates:
        begin
          S1 := NewString;
          S1 := ReplaceString(S1, FCaretChar, '');
          NewCaret := Pos(FCaretChar, NewString) - 1;
          if NewCaret = -1 then NewCaret := Length(S1);
          for i := 1 to NewCaret do
            if S1[i] = #13 then inc(LNum);
        end
    else
      raise ERAEditorError.Create('invalid RAEditor Completion Mode');
    end;
    {$IFDEF RAEDITOR_UNDO}
    TReplaceUndo.Create(FRAEditor, FCaretX, FCaretY, iBeg, iEnd, W, S1);
    {$ENDIF RAEDITOR_UNDO}
    //  LW := Length(W);
    if FSelected then
    begin
      if (FSelBegY <= FCaretY) or (FCaretY >= FSelEndY) then
        // скорректировать LW ..
    end;
    Delete(S, iBeg, iEnd - iBeg);
    insert(S1, S, iBeg);
    FLines.SetLockText(S);
    CaretFromPos(iBeg - 1 + (CX - 1) * LNum + NewCaret, X, Y);
    SetCaretinternal(X, Y);
    FRAEditor.TextAllChanged; // invalidate; {!!!}
    Changed;
    EndUpdate;
    PaintCaret(true);
  end;
end;

procedure TCompletion.DoKeyPress(Key: Char);
begin
  if FVisible then
    if HasChar(Key, RAEditorCompletionChars) then
      SelectItem
    else
      CloseUp(true)
  else if FEnabled then
    FTimer.Enabled := true;
end;

function TCompletion.DoKeyDown(Key: Word; Shift: TShiftState): boolean;
begin
  Result := true;
  case Key of
    VK_ESCAPE: CloseUp(false);
    VK_RETURN: CloseUp(true);
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_HOME, VK_END:
      FPopupList.Perform(WM_KEYDOWN, Key, 0);
  else
    Result := false;
  end;
end;

procedure TCompletion.DoCompletion(const AMode: TCompletionList);
var
  Eq: boolean;
  Cancel: boolean;
begin
  if FRAEditor.FReadOnly then exit;
  if FPopupList.Visible then CloseUp(False);
  FMode := AMode;
  case FMode of
    cmIdentifers:
      DropDown(AMode, true);
    cmTemplates:
      begin
        Cancel := false;
        // FRAEditor.DoCompletionIdentifer(Cancel);
        FRAEditor.DoCompletionTemplate(Cancel);
        if Cancel or (FTemplates.Count = 0) then exit;
        MakeItems;
        FindSelItem(Eq);
        if Eq then
          ReplaceWord(FItems.Items[Itemindex].Caption)
        else
          DropDown(AMode, true);
      end;
  end;
end;

procedure TCompletion.DropDown(const AMode: TCompletionList; const ShowAlways:
  boolean);
var
  ItemCount: integer;
  P: TPoint;
  Y: integer;
  {PopupWidth, }PopupHeight: integer;
  SysBorderWidth, SysBorderHeight: integer;
  R: TRect;
  Cancel: boolean;
  Eq: boolean;
  i: Integer;
begin
  CloseUp(false);
  FMode := AMode;
  with FRAEditor do
  begin
    Cancel := false;
    case FMode of
      cmIdentifers: FRAEditor.DoCompletionIdentifer(Cancel);
      cmTemplates: FRAEditor.DoCompletionTemplate(Cancel)
    end;
    MakeItems;
    FindSelItem(Eq);
    // Cancel := not Visible and (Itemindex = -1);
    if Cancel or (FItems.Count = 0) or (((Itemindex = -1) or Eq) and not
      ShowAlways) then exit;
    FPopupList.Items.Clear;
    for i:=0 to FItems.Count-1 do
      FPopupList.Items.Add(FItems.Items[i].Caption);
    FVisible := true;
    SetItemindex(FItemindex);
    FPopupList.OnMeasureItem := FRAEditor.FOnCompletionMeasureItem;
    FPopupList.OnDrawItem := FRAEditor.FOnCompletionDrawItem;

    ItemCount := FItems.Count;
    SysBorderWidth := GetSystemMetrics(SM_CXBORDER);
    SysBorderHeight := GetSystemMetrics(SM_CYBORDER);
    R := CalcCellRect(FCaretX - FLeftCol, FCaretY - FTopRow + 1);
    P := R.TopLeft;
    P.X := ClientOrigin.X + P.X;
    P.Y := ClientOrigin.Y + P.Y;
    Dec(P.X, 2 * SysBorderWidth);
    Dec(P.Y, SysBorderHeight);
    if ItemCount > FDropDownCount then ItemCount := FDropDownCount;
    PopupHeight := ItemHeight * ItemCount + 2;
    Y := P.Y;
    if (Y + PopupHeight) > Screen.Height then
    begin
      Y := P.Y - PopupHeight - FCellRect.Height + 1;
      if Y < 0 then Y := P.Y;
    end;

    PopupHeight:=(FPopupList.ClientHeight div FPopupList.ItemHeight)*FPopupList.ItemHeight;
    if PopupHeight<FPopupList.Constraints.MinHeight then begin
      PopupHeight:=PopupHeight+FPopupList.ItemHeight;
    end;
  //  PopupWidth := FDropDownWidth;
//    if PopupWidth = 0 then PopupWidth := Width + 2 * SysBorderWidth;
  end;
  FPopupList.Left := P.X;
  FPopupList.Top := Y;
  FPopupList.Width := FDropDownWidth;
  FPopupList.ClientHeight := PopupHeight;
  SetWindowPos(FPopupList.Handle, HWND_TOP, P.X, Y, 0, 0,
    SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWinDOW);
  FPopupList.Visible := true;
end;

procedure TCompletion.MakeItems;
var
  i: integer;
  S: string;
begin
  FItems.Clear;
  case FMode of
    cmIdentifers: begin
        with FRAEditor do
          if FLines.Count > CaretY then
            S := GetWordOnPos(FLines[CaretY], CaretX)
          else
            S := '';
        for i := 0 to FIdentifers.Count - 1 do
          if ANSIStrLIComp(PChar(FIdentifers.Items[i].Caption), PChar(S), Length(S)) = 0 then
            with FItems.Add do
             Assign(FIdentifers.Items[i]);
        if FItems.Count = 0 then FItems.Assign(FIdentifers);
    end;
//       FItems.Assign(FIdentifers);
    cmTemplates:  begin
        with FRAEditor do
          if FLines.Count > CaretY then
            S := GetWordOnPos(FLines[CaretY], CaretX)
          else
            S := '';
        for i := 0 to FTemplates.Count - 1 do
          if ANSIStrLIComp(PChar(FTemplates.Items[i].Caption), PChar(S), Length(S)) = 0 then
            with FItems.Add do
             Assign(FTemplates.Items[i]);
        if FItems.Count = 0 then FItems.Assign(FTemplates);
      end;
  end;
end;

procedure TCompletion.FindSelItem(var Eq: boolean);

  function FindFirst(Ss: TCompletionItems; S: string): integer;
  var
    i: integer;
  begin
    for i := 0 to Ss.Count - 1 do
      if ANSIStrLIComp(PChar(Ss.Items[i].Caption), PChar(S), Length(S)) = 0 then
      begin
        Result := i;
        exit;
      end;
    Result := -1;
  end;

var
  S: string;
begin
  with FRAEditor do
    if FLines.Count > 0 then
      S := GetWordOnPos(FLines[CaretY], CaretX) else
      S := '';
  if Trim(S) = '' then
    Itemindex := -1
  else
    Itemindex := FindFirst(FItems, S);

  Eq := (Itemindex > -1) and Cmp(Trim(FItems.Items[Itemindex].Caption), S);
end;

procedure TCompletion.SelectItem;
var
  Cancel: boolean;
  Param: boolean;
begin
  FindSelItem(Param);
  Cancel := not Visible and (Itemindex = -1);
  // by Tsv
{  case FMode of
    cmIdentifers: FRAEditor.DoCompletionIdentifer(Cancel);
    cmTemplates: FRAEditor.DoCompletionTemplate(Cancel);
  end;}
  if Cancel or (GetItems.Count = 0) then CloseUp(false);
end;

procedure TCompletion.CloseUp(const Apply: boolean);
begin
  FItemindex := Itemindex;
  FPopupList.Visible := false;

  //  (FPopupList as TRAEditorCompletionList). HintWindow.ReleaseHandle;
  FVisible := false;
  FTimer.Enabled := false;
  if Apply and (Itemindex > -1) then
    case FMode of
      cmIdentifers: ReplaceWord(SubStr(FItems.Items[Itemindex].InsertedText.Text,0,#13#10));
      cmTemplates: ReplaceWord(FItems.Items[Itemindex].InsertedText.Text);
    end;
end;

procedure TCompletion.OnTimer(Sender: TObject);
begin
  DropDown(FDefMode, false);
end;

procedure TCompletion.SetStrings(index: integer; AValue: TCompletionItems);
begin
  case index of
    0: FIdentifers.Assign(AValue);
    1: FTemplates.Assign(AValue);
  end;
end;

function TCompletion.GetItemindex: integer;
begin
  Result := FItemindex;
  if FVisible then
    Result := FPopupList.Itemindex;
end;

procedure TCompletion.SetItemindex(AValue: integer);
begin
  FItemindex := AValue;
  if FVisible then
    FPopupList.Itemindex := FItemindex;
end;

function TCompletion.Getinterval: cardinal;
begin
  Result := FTimer.interval;
end;

procedure TCompletion.Setinterval(AValue: cardinal);
begin
  FTimer.interval := AValue;
end;

procedure TCompletion.SetItemHeight(Value: Integer);
begin
  if Value<>FPopupList.ItemHeight then begin
    FPopupList.ItemHeight:=Value;
    FPopupList.Constraints.MinHeight:=FPopupList.ItemHeight*FDropDownCount;
  end;
end;

function TCompletion.GetItemHeight: Integer;
begin
  Result:=FPopupList.ItemHeight;
end;

procedure TCompletion.SetDropDownWidth(Value: Integer);
begin
  if Value<>FPopupList.Width then begin
    FPopupList.Width:=Value;
  end;
end;

procedure TCompletion.SetDropDownCount(Value: Integer);
begin
  FPopupList.Height:=FPopupList.ItemHeight*Value;
end;

{
function TCompletion.GetDropDownWidth: Integer;
begin
  Result:=FPopupList.Width;
end;}


{**************  TRAEditorCompletionList  *************}

constructor TRAEditorCompletionList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Left := -1000;
  Visible := false;
  TabStop := False;
  ParentFont := false;
  Parent := Owner as TRACustomEditor;
  Ctl3D := false;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := false;
  FTimer.interval := 200;
  FTimer.OnTimer := OnTimer;
  Style := lbOwnerDrawFixed;
  //  HintWindow := THintWindow.Create(Self);
end;

destructor TRAEditorCompletionList.Destroy;
begin
  FTimer.Free;
  //  HintWindow.Free;
  inherited Destroy;
end;

procedure TRAEditorCompletionList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
      Style := Style or WS_BORDER or WS_THICKFRAME;
      ExStyle := ExStyle or WS_EX_TOOLWinDOW;
      WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
  end;
end;

procedure TRAEditorCompletionList.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then
    Windows.SetParent(Handle, 0);
  //  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0); {??}
end;

procedure TRAEditorCompletionList.DestroyWnd;
begin
  inherited DestroyWnd;
  //  HintWindow.ReleaseHandle;
end;

procedure TRAEditorCompletionList.MouseMove(Shift: TShiftState; X, Y: integer);
var
  F: integer;
begin
  YY := Y;
  F := ItemAtPos(Point(X, Y), true);
  if KeyPressed(VK_LBUTTON) then
  begin
    F := ItemAtPos(Point(X, Y), true);
    if F > -1 then Itemindex := F;
    FTimer.Enabled := (Y < 0) or (Y > ClientHeight);
    if (Y < -ItemHeight) or (Y > ClientHeight + ItemHeight) then
      FTimer.interval := 50
    else
      FTimer.interval := 200;
  end;
  if (F > -1) and not FTimer.Enabled then
  begin
    //Application.CancelHint;
   // Hint := Items[F];
  //  HintWindow.ActivateHint(Bounds(ClientOrigin.X + X, ClientOrigin.Y + Y, 300, ItemHeight), Items[F]);
  end;
end;

procedure TRAEditorCompletionList.MouseDown(Button: TMouseButton; Shift:
  TShiftState; X, Y: integer);
var
  F: integer;
begin
  MouseCapture := true;
  F := ItemAtPos(Point(X, Y), true);
  if F > -1 then Itemindex := F;
end;

procedure TRAEditorCompletionList.MouseUp(Button: TMouseButton; Shift:
  TShiftState; X, Y: integer);
begin
  MouseCapture := false;
  (Owner as TRACustomEditor).FCompletion.CloseUp(
    (Button = mbLeft) and PtinRect(ClientRect, Point(X, Y)));
end;

procedure TRAEditorCompletionList.OnTimer(Sender: TObject);
begin
  if (YY < 0) then
    Perform(WM_VSCROLL, SB_LinEUP, 0)
  else if (YY > ClientHeight) then
    Perform(WM_VSCROLL, SB_LinEDOWN, 0);
end;

procedure TRAEditorCompletionList.WMCancelMode(var Message: TMessage);
begin
  (Owner as TRACustomEditor).FCompletion.CloseUp(false);
end;

procedure TRAEditorCompletionList.CMHintShow(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TRAEditorCompletionList.DrawItem(index: integer; Rect: TRect; State:
  TOwnerDrawState);
var
  Flags: Longint;
  OldRect: TRect;
  xImage,yImage: Integer;
  oldBrush: TBrush;
  oldFont: TFont;
  oldPen: TPen;
  FItemsEx: TCompletionItems;
  CurItemEx: TCompletionItem;
  CurCaptionEx: TCompletionItemCaption;
  FCompl: TCompletion;
  i: Integer;
begin
  if Assigned(OnDrawItem) then
    OnDrawItem(Self, index, Rect, State)
  else begin

   FCompl:=(Owner as TRACustomEditor).FCompletion;
   if FCompl=nil then exit;
   
   FItemsEx:=FCompl.FItems;
   if FItemsEx=nil then exit;

   oldBrush:=TBrush.Create;
   oldFont:=TFont.Create;
   oldPen:=TPen.Create;
   try

    oldBrush.Assign(Canvas.Brush);
    oldFont.Assign(Canvas.Font);
    oldPen.Assign(Canvas.Pen);

    CurItemEx:=FItemsEx.Items[Index];
    if CurItemEx=nil then exit;

    Canvas.Brush.Assign(CurItemEx.Brush);
    Canvas.Font.Assign(CurItemEx.Font);
    Canvas.Pen.Assign(CurItemEx.Pen);
    Canvas.FillRect(Rect);

    if (odSelected in State) then begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
      Canvas.FillRect(Rect);
    end;

    if Index<Items.Count then begin

      OldRect:=Rect;

      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment then Inc(Rect.Left, 2)
      else Dec(Rect.Right, 2);

      if FCompl.FRAEditor.CompletionImages<>nil then begin
        xImage:=Rect.Left;
        yImage:=Rect.Top+2;
        FCompl.FRAEditor.CompletionImages.Draw(Canvas,xImage,yImage,CurItemEx.ImageIndex,true);
        Inc(Rect.Left, FCompl.FRAEditor.CompletionImages.Width+4);
      end;

      if CurItemEx.CaptionEx.Count>0 then begin

        for i:=0 to CurItemEx.CaptionEx.Count-1 do begin

          CurCaptionEx:=CurItemEx.CaptionEx.Items[i];

          Canvas.Brush.Assign(CurCaptionEx.Brush);
          Canvas.Font.Assign(CurCaptionEx.Font);
          Canvas.Pen.Assign(CurCaptionEx.Pen);

          if i=CurItemEx.CaptionEx.Count-1 then begin
           Rect.Right:=OldRect.Right;
           Dec(Rect.Right,2);
          end else begin
           if CurCaptionEx.AutoSize then
            Rect.Right:=Rect.Left+Canvas.TextWidth(CurCaptionEx.Caption)
           else
            Rect.Right:=Rect.Left+CurCaptionEx.Width;
          end;

          Canvas.FillRect(Rect);

          if (odSelected in State) then begin
            Canvas.Brush.Color := clHighlight;
            Canvas.Font.Color := clHighlightText;
            Canvas.FillRect(Rect);
          end;

          case CurCaptionEx.Alignment of
            taLeftJustify:  Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_LEFT);
            taRightJustify: Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_RIGHT);
            taCenter:       Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_CENTER);
          end;

          DrawText(Canvas.Handle, PChar(CurCaptionEx.Caption), Length(CurCaptionEx.Caption), Rect, Flags);
          Rect.Left:=Rect.Right;
        end;

      end else begin
       DrawText(Canvas.Handle, PChar(CurItemEx.Caption), Length(CurItemEx.Caption), Rect, Flags);
      end;

      if (odSelected in State) then
       Canvas.DrawFocusRect(OldRect);

     end;
    finally
     Canvas.Brush.Assign(oldBrush);
     Canvas.Font.Assign(oldFont);
     Canvas.Pen.Assign(oldPen);
     oldBrush.Free;
     oldFont.Free;
     oldPen.Free;
    end;

  end;
end;

procedure TRAEditorCompletionList.WMSizing(var Message: TMessage);
var
  HRow, NewHeight, Diff: Integer;
  R: PRect;
  IntDiv{, IntMod}: Integer;
  dH: Integer;
begin
    R := PRect(Message.LParam);
    HRow := ItemHeight;
    NewHeight := R.Bottom - R.Top;

    if HRow > 0 then  begin

      Diff := NewHeight - Height;
      IntDiv:=(Diff div HRow);
      dH:=Height-ClientHeight;
    //  IntMod:=(Diff mod HRow);
      NewHeight := Height+HRow*IntDiv;
      if Constraints.MinHeight>0 then
       if NewHeight<=Constraints.MinHeight then
        NewHeight:=Constraints.MinHeight+dH+(Constraints.MinHeight mod HRow);
      if Constraints.MaxHeight>0 then
       if NewHeight>=Constraints.MaxHeight then
        NewHeight:=Constraints.MaxHeight-dH-(Constraints.MaxHeight mod HRow);

    end;


    if Message.WParam in [WMSZ_BOTTOM, WMSZ_BOTTOMLEFT, WMSZ_BOTTOMRIGHT] then
     R.Bottom := R.Top + NewHeight
    else
     R.Top := R.Bottom - NewHeight;

end;

procedure TRAEditorCompletionList.WMSize(var Message: TMessage);
begin
  Invalidate;
  Inherited;
  FCompletion.FDropDownWidth:=Width;
  FCompletion.FDropDownCount:=ClientHeight div ItemHeight;
end;

(*procedure TRAEditorCompletionList.WMGETMINMAXINFO(var msg: TMessage);
var
   p: PMinMaxInfo;
begin
   p := PMinMaxInfo(Msg.lParam);
// This represents the size of the Window when Maximized
{   p.ptMaxSize.x := 320;
   p.ptMaxSize.y := 240;}
// This represents the position of the Window when Maximized
   p.ptMaxPosition.x := 10;
   p.ptMaxPosition.y := 10;
// This represents the minimum size of the Window
   p.ptMinTrackSize.x := Constraints.MinWidth;
   p.ptMinTrackSize.y := Constraints.MinHeight;
// This represents the maximum size of the Window
{   p.ptMaxTrackSize.x := 400;
   p.ptMaxTrackSize.y := 320}
end;*)

{$ENDIF RAEDITOR_COMPLETION}

{$ENDIF RAEDITOR_EDITOR}


{ TIEditReader support }

procedure TRACustomEditor.ValidateEditBuffer;
begin
  if FPEditBuffer = nil then
  begin
    FEditBuffer := Lines.Text;
    FPEditBuffer := PChar(FEditBuffer);
    FEditBufferSize := Length(FEditBuffer);
  end;
end; { ValidateEditBuffer }

function TRACustomEditor.GetText(Position: Longint; Buffer: PChar;
  Count: Longint): Longint;
begin
  ValidateEditBuffer;
  if Position <= FEditBufferSize then
  begin
    Result := Min(FEditBufferSize - Position, Count);
    Move(FPEditBuffer[Position], Buffer[0], Result);
  end
  else
    Result := 0;
end;

procedure TRACustomEditor.SetSyntaxHighlighting(Value: Boolean);
begin
  if Value<>FSyntaxHighlighting then begin
   FSyntaxHighlighting:=Value;
   Paint;
  end;
end;

// by TSV

procedure TRACustomEditor.SetErrorLine(X, Y: integer);
begin
  FErrorLine.Line:=Y;
  FErrorLine.Column:=X;
  SetCaretXY(X,Y);
  FErrorLine.Visible:=true;
  PaintCaret(true);
end;

function TRACustomEditor.GetWordFromCaret: string;
begin
  Result:=GetWordOnPos(Lines.Text,PosFromCaret(CaretX,CaretY));
end;

procedure TRACustomEditor.SetCaretXY(X, Y: integer);
var
    X1, Y1: integer;
begin
    X1 := FLeftCol;
    Y1 := FTopRow;
    if (Y < FTopRow) or (Y > FLastVisibleRow) then
      Y1 := Y - (FVisibleRowCount div 2);
    if (X < FLeftCol) or (X > FVisibleColCount) then
      X1 := X - (FVisibleColCount div 2);
    SetLeftTop(X1, Y1);
    SetCaret(X, Y);
end;

function PosBack(Substr,Str: String): integer;
var
  curstr: string;
  i: integer;
  l1,l2: integer;
begin
  Result:=0;
  l1:=Length(Substr);
  l2:=Length(Str);
  if l1>=l2 then exit;
  for i:=l2 downto 1 do begin
    curstr:=Copy(str,i-l1,l1);
    if curstr=Substr then begin
      Result:=i-l1;
      exit;
    end;
  end;
end;

function PosWord(Substr,Str: string; Back: Boolean): integer;
var
  isBreak: Boolean;
  APos,NewPos: integer;
  vStr,vSubstr: string;
  l1,l2: integer;
  f,b: char;
begin
  isBreak:=false;
  vStr:=Str;
  vSubstr:=Substr;
  l1:=Length(vStr)-1;
  l2:=Length(vSubstr)-1;
  NewPos:=0;
  while not isBreak do begin
     if not Back then APos:=Pos(vSubstr,vStr)
     else APos:=PosBack(vSubstr,vStr);
     isBreak:=APos=0;
     if isBreak then begin
       NewPos:=0;
       break;
     end;
     if ((APos-1)>=1) and ((APos+l2+1)<=l1) then begin
       b:=vStr[APos-1];
       f:=vStr[APos+l2+1];
       if (CharinSet(b, Separators) and CharinSet(f, Separators)) then
         isBreak:=true;
     end;
     if not Back then begin
      vStr:=Copy(vStr,APos+1,l1-APos);
      NewPos:=NewPos+APos;
     end else begin
      vStr:=Copy(vStr,1,APos);
      NewPos:=APos;
     end;

  end;
  Result:=NewPos;
end;

function TRACustomEditor.FindText(Value: string; WithCase,WordOnly,RegExpresion: Boolean;
                                  Direction,Scope,Origin: Boolean; First: Boolean=false;
                                  ResetSelection: Boolean=false;
                                  View: Boolean=true): Boolean;

  function RealSelected: Boolean;
  begin
    Result:=FSelected;
{   if not Result then
     Result:=SelLength<>0;}
  end;

var
  NewValue: string;
  NewLines: string;
  PosStart: integer;
  APos: integer;
  NewCaretX,NewCaretY: integer;
  PosPlus: integer;
  lCopy: integer;
  oldPos: integer;
  PosCaret: integer;
  PosTxt: integer;
begin
  Result:=false;

  if View then PaintCaret(false);
  PosCaret:=FFindTxt.Position+Length(FFindTxt.Text);
  PosTxt:=FFindTxt.Position;

  if Origin then begin
    oldPos:=PosFromCaret(CaretX,CaretY)+1;
  end else begin
    if First then oldPos:=1
    else begin
     oldPos:=PosFromCaret(CaretX,CaretY)+1;
     Origin:=true;
    end;
  end;

  if Scope then begin
    NewLines:=StrPas(Lines.GetText);
  end else begin
    if not RealSelected then exit;
    NewLines:=SelText;
  end;

  if WithCase then begin
    NewValue:=Value;
    NewLines:=NewLines;
  end else begin
    NewValue:=AnsiUpperCase(Value);
    NewLines:=AnsiUpperCase(NewLines);
  end;

  if not RealSelected then begin
   PosStart:=oldPos;
   lCopy:=Length(NewLines);
   PosPlus:=PosStart-1;
  end else begin
    if First then begin
     if Direction then begin
      PosStart:=1;
      PosPlus:=PosFromCaret(FSelBegX,FSelBegY);
     end else begin
      PosStart:=PosFromCaret(FSelEndX,FSelEndY);
      PosPlus:=PosFromCaret(FSelBegX,FSelBegY);
     end;
     lCopy:=SelLength;
    end else begin
     if Direction then begin
      PosStart:=oldPos-PosFromCaret(FSelBegX,FSelBegY);
      PosPlus:=oldPos-1;
     end else begin
      PosStart:=oldPos-PosFromCaret(FSelBegX,FSelBegY);
      PosPlus:=PosFromCaret(FSelBegX,FSelBegY);
     end;
     lCopy:=SelLength;
    end;
  end;

  if Origin then begin
    if Direction then begin
      NewLines:=Copy(NewLines,PosStart,lCopy-PosStart);
    end else begin
      NewLines:=Copy(NewLines,1,PosStart-1);
    end;
  end else begin
    NewLines:=NewLines;
  end;

  if View then FFindTxt.Visible:=false;
  if NewValue<>FFindTxt.Text then begin
    FFindTxt.Position:=0;
    FFindTxt.Text:='';
  end;

  if Direction then begin
    if not WordOnly then begin
      APos:=Pos(NewValue,NewLines);
    end else begin
      APos:=PosWord(NewValue,NewLines,false);
    end;
    Result:=APos<>0;
    if Result then
     if RealSelected then begin
      if (PosPlus+APos)>(SelStart+SelLength) then exit;
      PosCaret:=PosPlus+APos+Length(NewValue)-1;
      PosTxt:=PosPlus+APos;
     end else begin
      PosCaret:=PosPlus+APos+Length(NewValue)-1;
      PosTxt:=PosPlus+APos;
     end;
  end else begin
    if not WordOnly then begin
      APos:=PosBack(NewValue,NewLines);
    end else begin
      APos:=PosWord(NewValue,NewLines,true);
    end;
    Result:=APos<>0;
    if Result then
     if RealSelected then begin
      if (PosPlus+APos)>(SelStart+SelLength) then exit;
      PosCaret:=PosPlus+APos+Length(NewValue)-1;
      PosTxt:=PosPlus+APos;
     end else begin
      PosCaret:=APos+Length(NewValue)-1;
      PosTxt:=APos;
     end;
  end;

  if Result then begin
    FFindTxt.Text:=NewValue;
    FFindTxt.Position:=PosTxt;
    CaretFromPos(PosCaret,NewCaretX,NewCaretY);
    SetCaretXY(NewCaretX,NewCaretY);
    if View then FFindTxt.Visible:=true;
    if ResetSelection then SetUnSelected;
  end else begin
    if View then FFindTxt.Visible:=false;
    FFindTxt.Position:=0;
    FFindTxt.Text:='';
  end;
  
  if View then PaintCaret(true);
end;

function TRACustomEditor.ReplaceText(OldValue,NewValue: string; WithCase,WordOnly,RegExpresion: Boolean;
                                      Direction,Scope,Origin,Promt: Boolean; First: Boolean=false;
                                      ResetSelection: Boolean=false): Boolean;

   procedure ReplaceLocal;
   begin
    if Promt then FFindTxt.Visible:=false;
    ReplaceWord2FromPosition(FFindTxt.Position,Length(OldValue),NewValue);
    FFindTxt.Text:=NewValue;
    if Promt then FFindTxt.Visible:=true;
   end;

   function TranslatePoint: TPoint;
   var
     X1, Y1: integer;
     nCaretX,nCaretY: Integer;
     pt: TPoint;
   begin
     CaretFromPos(FFindTxt.Position,nCaretX,nCaretY);
     X1 := nCaretX-(FLastVisibleCol-FVisibleColCount)-2;
     Y1 := nCaretY-(FLastVisibleRow-FVisibleRowCount);

     pt.y:=(Y1)*CellRect.Height;
     pt.x:=(X1)*CellRect.Width+GutterWidth;
     Result:=pt;
   end;

var
  ret: Boolean;
  but: integer;
  isFindNext: Boolean;
  pt: TPoint;
begin
  Result:=false;
  ret:=FindText(OldValue,WithCase,WordOnly,RegExpresion,
                Direction,Scope,Origin,First,ResetSelection,Promt);
  if not ret then exit;
  Result:=true;
  if Promt then begin
   isFindNext:=true;

   pt:=TranslatePoint;
   pt:=ClientToScreen(pt);
   but:=MessageDlgPos(Format(ConstReplaceText,[NewValue]),mtConfirmation,
                     [mbYes,mbNo,mbCancel,mbAll],0,
                     pt.x,pt.y);
   case but of
    mrYes: ReplaceLocal;
    mrNo:;
    mrCancel: begin
     isFindNext:=false;
     FFindTxt.Visible:=false;
    end;
    mrAll: begin
     Promt:=false;
     FFindTxt.Visible:=false;
     ReplaceLocal;
    end; 
   end;
  end else begin
    isFindNext:=true;
    ReplaceLocal;
  end;

  if isFindNext then
    ReplaceText(OldValue,NewValue,WithCase,WordOnly,RegExpresion,
                Direction,Scope,Origin,Promt,false,ResetSelection);
end;

procedure ClearListCommandHint;
var
  i: integer;
  P: PCommandHint;
begin
  for i:=0 to ListCommandHint.Count-1 do begin
    P:=ListCommandHint.Items[i];
    Dispose(P);
  end;
  ListCommandHint.Clear;
end;

function GetCommandHint(Command: TEditCommand): PCommandHint;
var
  i: integer;
  P: PCommandHint;
begin
  result:=nil;
  for i:=0 to ListCommandHint.Count-1 do begin
    P:=ListCommandHint.Items[i];
    if P.Command=Command then begin
     result:=P;
     exit;
    end;  
  end;  
end;

procedure AddToListCommandHint(Command: TEditCommand; Hint: String);
var
  P: PCommandHint;
begin
  New(P);
  P.Command:=Command;
  P.Hint:=Hint;
  ListCommandHint.Add(P);
end;

function GetHintScriptCommand(ACommand: TEditCommand; Default: string=''): string;
var
  P: PCommandHint;
begin
  Result:=Default;
  P:=GetCommandHint(ACommand);
  if P<>nil then
    Result:=P.Hint;
end;

function GetHintWithShortCutScriptCommand(SE: TRAEditor; ACommand: TEditCommand; Default: string=''): string;
var
  AList: TList;
  tmps: string;
  E: TEditKey;
  i: Integer;
begin
  Result:=Default;
  if SE=nil then exit;
  AList:=TList.Create;
  try
    SE.Keyboard.GetListByCommand(ACommand,AList);
    for i:=0 to AList.Count-1 do begin
      E:=AList.Items[i];
      if i=0 then tmps:=ShortCutToText(ShortCut(E.Key1,E.Shift1))
      else tmps:=tmps+', '+ShortCutToText(ShortCut(E.Key1,E.Shift1));
    end;
    if Trim(tmps)<>'' then
      Result:=GetHintScriptCommand(ACommand,Default)+' ('+tmps+')';
  finally
    AList.Free;
  end;
end;

function GetShortCutScriptEditor(SE: TRAEditor; ACommand: TEditCommand): TShortCut;
var
  AList: TList;
  E: TEditKey;
  i: Integer;
begin
  Result:=0;
  if SE=nil then exit;
  AList:=TList.Create;
  try
    SE.Keyboard.GetListByCommand(ACommand,AList);
    for i:=0 to AList.Count-1 do begin
      E:=AList.Items[i];
      Result:=ShortCut(E.Key1,E.Shift1);
      exit;
    end;
  finally
    AList.Free;
  end;
end;             

initialization
  ListCommandHint:=TList.Create;
  AddToListCommandHint(ecLeft,Const_ecLeft);
  AddToListCommandHint(ecRight,Const_ecRight);
  AddToListCommandHint(ecUp,Const_ecUp);
  AddToListCommandHint(ecDown,Const_ecDown);
  AddToListCommandHint(ecSelLeft,Const_ecSelLeft);
  AddToListCommandHint(ecSelRight,Const_ecSelRight);
  AddToListCommandHint(ecSelUp,Const_ecSelUp);
  AddToListCommandHint(ecSelDown,Const_ecSelDown);
  AddToListCommandHint(ecBeginLine,Const_ecBeginLine);
  AddToListCommandHint(ecSelBeginLine,Const_ecSelBeginLine);
  AddToListCommandHint(ecBeginDoc,Const_ecBeginDoc);
  AddToListCommandHint(ecSelBeginDoc,Const_ecSelBeginDoc);
  AddToListCommandHint(ecEndLine,Const_ecEndLine);
  AddToListCommandHint(ecSelEndLine,Const_ecSelEndLine);
  AddToListCommandHint(ecEndDoc,Const_ecEndDoc);
  AddToListCommandHint(ecSelEndDoc,Const_ecSelEndDoc);
  AddToListCommandHint(ecPrevWord,Const_ecPrevWord);
  AddToListCommandHint(ecNextWord,Const_ecNextWord);
  AddToListCommandHint(ecSelPrevWord,Const_ecSelPrevWord);
  AddToListCommandHint(ecSelNextWord,Const_ecSelNextWord);
  AddToListCommandHint(ecSelAll,Const_ecSelAll);
  AddToListCommandHint(ecWindowTop,Const_ecWindowTop);
  AddToListCommandHint(ecWindowBottom,Const_ecWindowBottom);
  AddToListCommandHint(ecPrevPage,Const_ecPrevPage);
  AddToListCommandHint(ecNextPage,Const_ecNextPage);
  AddToListCommandHint(ecSelPrevPage,Const_ecSelPrevPage);
  AddToListCommandHint(ecSelNextPage,Const_ecSelNextPage);
  AddToListCommandHint(ecScrollLineUp,Const_ecScrollLineUp);
  AddToListCommandHint(ecScrollLineDown,Const_ecScrollLineDown);
  AddToListCommandHint(ecChangeinsertMode,Const_ecChangeinsertMode);
  AddToListCommandHint(ecinsertPara,Const_ecinsertPara);
  AddToListCommandHint(ecBackspace,Const_ecBackspace);
  AddToListCommandHint(ecDelete,Const_ecDelete);
  AddToListCommandHint(ecTab,Const_ecTab);
  AddToListCommandHint(ecBackTab,Const_ecBackTab);
  AddToListCommandHint(ecDeleteSelected,Const_ecDeleteSelected);
  AddToListCommandHint(ecClipboardCopy,Const_ecClipboardCopy);
  AddToListCommandHint(ecClipboardCut,Const_ecClipboardCut);
  AddToListCommandHint(ecClipBoardPaste,Const_ecClipBoardPaste);
  AddToListCommandHint(ecSetBookmark0,Const_ecSetBookmark0);
  AddToListCommandHint(ecSetBookmark1,Const_ecSetBookmark1);
  AddToListCommandHint(ecSetBookmark2,Const_ecSetBookmark2);
  AddToListCommandHint(ecSetBookmark3,Const_ecSetBookmark3);
  AddToListCommandHint(ecSetBookmark4,Const_ecSetBookmark4);
  AddToListCommandHint(ecSetBookmark5,Const_ecSetBookmark5);
  AddToListCommandHint(ecSetBookmark6,Const_ecSetBookmark6);
  AddToListCommandHint(ecSetBookmark7,Const_ecSetBookmark7);
  AddToListCommandHint(ecSetBookmark8,Const_ecSetBookmark8);
  AddToListCommandHint(ecSetBookmark9,Const_ecSetBookmark9);
  AddToListCommandHint(ecGotoBookmark0,Const_ecGotoBookmark0);
  AddToListCommandHint(ecGotoBookmark1,Const_ecGotoBookmark1);
  AddToListCommandHint(ecGotoBookmark2,Const_ecGotoBookmark2);
  AddToListCommandHint(ecGotoBookmark3,Const_ecGotoBookmark3);
  AddToListCommandHint(ecGotoBookmark4,Const_ecGotoBookmark4);
  AddToListCommandHint(ecGotoBookmark5,Const_ecGotoBookmark5);
  AddToListCommandHint(ecGotoBookmark6,Const_ecGotoBookmark6);
  AddToListCommandHint(ecGotoBookmark7,Const_ecGotoBookmark7);
  AddToListCommandHint(ecGotoBookmark8,Const_ecGotoBookmark8);
  AddToListCommandHint(ecGotoBookmark9,Const_ecGotoBookmark9);
  AddToListCommandHint(ecNoninclusiveBlock,Const_ecNoninclusiveBlock);
  AddToListCommandHint(ecinclusiveBlock,Const_ecinclusiveBlock);
  AddToListCommandHint(ecColumnBlock,Const_ecColumnBlock);
  AddToListCommandHint(ecUndo,Const_ecUndo);
  AddToListCommandHint(ecCompletionIdentifers,Const_ecCompletionIdentifers);
  AddToListCommandHint(ecCompletionTemplates,Const_ecCompletionTemplates);
  AddToListCommandHint(ecDeleteWord,Const_ecDeleteWord);
  AddToListCommandHint(ecDeleteLine,Const_ecDeleteLine);
  AddToListCommandHint(ecSelWord,Const_ecSelWord);
  AddToListCommandHint(ecToUpperCase,Const_ecToUpperCase);
  AddToListCommandHint(ecToLowerCase,Const_ecToLowerCase);
  AddToListCommandHint(ecChangeCase,Const_ecChangeCase);
  AddToListCommandHint(ecindent,Const_ecindent);
  AddToListCommandHint(ecUnindent,Const_ecUnindent);
  AddToListCommandHint(ecRecordMacro,Const_ecRecordMacro);
  AddToListCommandHint(ecPlayMacro,Const_ecPlayMacro);

  AddToListCommandHint(ecNewScript,Const_ecNewScript);
  AddToListCommandHint(ecOpenScript,Const_ecOpenScript);
  AddToListCommandHint(ecSaveScript,Const_ecSaveScript);
  AddToListCommandHint(ecSaveScriptToBase,Const_ecSaveScriptToBase);
  AddToListCommandHint(ecRunScript,Const_ecRunScript);
  AddToListCommandHint(ecStopScript,Const_ecStopScript);
  AddToListCommandHint(ecResetScript,Const_ecResetScript);
  AddToListCommandHint(ecCompileScript,Const_ecCompileScript);
  AddToListCommandHint(ecGotoLine,Const_ecGotoLine);
  AddToListCommandHint(ecFind,Const_ecFind);
  AddToListCommandHint(ecFindNext,Const_ecFindNext);
  AddToListCommandHint(ecReplace,Const_ecReplace);
  AddToListCommandHint(ecViewOption,Const_ecViewOption);
  AddToListCommandHint(ecViewForms,Const_ecViewForms);

finalization
  ClearListCommandHint;
  ListCommandHint.Free;
  
end.

