{*******************************************************}
{       Run-Time Object Inspector component v1.2        }
{       Author: Gennadie Zuev                           }
{	E-mail: zuev@micex.ru                           }
{	Web: http://unicorn.micex.ru/users/gena         }
{                                                       }
{       Copyright (c) 1999 Gennadie Zuev     	        }
{                                                       }
{*******************************************************}

{ Revision History:

  Version 1.2
  ===========
+ Fixed rare "division by zero" error in VisibleRowCount function
+ When setting CurObj any unsaved changes in InplaceEdit are discarded  
+ Added events OnChanging, OnChange
+ Fixed bug with visible scrollbar on empty PropList
+ Added "autocomplete" feature for enum properties
+ Fixed bug with changing Ctl3D property at run-time

  Version 1.1
  ===========
+ Now compatible with Delphi 2, 3, 4 and 5. In Delphi 5 you may need to compile
  Delphi5\Source\Toolsapi\DsgnIntf.pas and put resulting DCU in Delphi5\Lib
  folder
+ In Delphi 5 TPropertyEditor custom drawing is supported
+ if ShowHint is True, hint window will be shown when you move the mouse over
  a long property value (not working in D2)
+ Vertical scrollbar can be flat now (in D4, D5)
+ "+"/"-" button next to collapsed property can look like that found in Delphi 5
+ Two events were added (in D2 only one event)
+ Corrected some bugs in destructor

  Version 1.0
  ===========
  Initial Delphi 4 version.


  TZPropList property & events
  ============================

 (public)
  CurObj          - determines the object we are viewing|editing
  Modified        - True if any property of CurObj was modified
  VisibleRowCount - idicates number of rows that can fit in the visible area
  RowHeight       - height of a single row

 (published)
  Filter          - determines what kind of properties to show
  IntegralHeight  - determines whether to display the partial items
  Middle          - width of first column (containing property names)
  NewButtons      - determines whether to use D4 or D5 style when
                    displaing "+"/"-" button next to collapsed property
  PropColor       - color used to display property values
  ScrollBarStyle  - can make vertical scrollbar flat (D4&5)

  OnNewObject     - occurs when a new value is assigned to CurObj
  OnHint          - occurs when the mouse pauses over the property, whose
                    value is too long and doesn't fit in view. You can change
                    hint color, position and text here (absent in D2)
}

unit ZPropLst;

{$IFDEF VER90}
  {$DEFINE Delphi2}
  {$DEFINE Prior4}
{$ENDIF}

{$IFDEF VER100}
  {$DEFINE Delphi3}
  {$DEFINE Prior4}
{$ENDIF}

{$IFDEF VER120}
  {$DEFINE Delphi4}
  {$DeFINE Post4}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE Delphi5}
  {$DeFINE Post4}
{$ENDIF}

interface

uses
{ !!! In Delphi 5 you may need to compile Delphi5\Source\Toolsapi\DsgnIntf.pas
  and put resulting DCU in Delphi5\Lib folder }
  Windows, Messages, Classes, Graphics, Controls, TypInfo, StdCtrls,
    DsgnIntf, SysUtils, Forms {$IFDEF Delphi5}, Menus {$ENDIF};

type
  TZPropList = class;

  TZPropType = (ptSimple, ptEllipsis, ptPickList);

  TZPopupList = class(TCustomListBox)
  private
    FSearchText: string;
    FSearchTickCount: Integer;
  protected
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Hide;
  end;

  TZInplaceEdit = class;
  TZListButton = class(TCustomControl)
  private
    FButtonWidth: Integer;
    FPressed: Boolean;
    FArrow: Boolean;
    FTracking: Boolean;
    FActiveList: TZPopupList;
    FListVisible: Boolean;
    FEditor: TZInplaceEdit;
    FPropList: TZPropList;
{$IFDEF Delphi5}
    FListItemHeight: Integer;
{$ENDIF}
    procedure TrackButton(X, Y: Integer);
    procedure StopTracking;
    procedure DropDown;
    procedure CloseUp(Accept: Boolean);
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
    function Editor: TPropertyEditor;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMCancelMode(var Msg: TWMKillFocus); message WM_CANCELMODE;
{$IFDEF Delphi5}
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure MeasureHeight(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
{$ENDIF}
  protected
    procedure KeyPress(var Key: Char); override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Hide;
  end;

  TZInplaceEdit = class(TCustomEdit)
  private
    FPropList: TZPropList;
    FClickTime: Integer;
    FListButton: TZListButton;
    FAutoUpdate: Boolean;
    FPropType: TZPropType;
    FIgnoreChange: Boolean;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure BoundsChanged;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DblClick; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Change; override;
    procedure AutoComplete(const S: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Move(const Loc: TRect);
    procedure UpdateLoc(const Loc: TRect);
    procedure SetFocus; override;
  end;

  PZEditor = ^TZEditor;
  TZEditor = record
    peEditor: TPropertyEditor;
    peRealName: String;
    peIdent: Integer;
    peNode: Boolean;
    peExpanded: Boolean;
    peSortPos: Integer;
    peParent: TPersistent;
  end;

  TZEditorList = class(TList)
  private
    FPropList: TZPropList;
    function GetEditor(AIndex: Integer): PZEditor;
    procedure SetEditor(AIndex: Integer; Value: PZEditor);
  public
    procedure Clear;{$IFDEF Post4}override;{$ENDIF}
    procedure Add(Editor: PZEditor);
    procedure DeleteEditor(Index: Integer);
    function IndexOfPropName(const PropName: string;
      StartIndex: Integer): Integer;
    function FindPropName(const PropName: string): Integer;
    constructor Create(APropList: TZPropList);
    property Editors[AIndex: Integer]: PZEditor read GetEditor write SetEditor; default;
  end;

{$IFDEF Prior4}
  TZFormDesigner = class(TFormDesigner)
{$ELSE}
  TZFormDesigner = class(TInterfacedObject, IFormDesigner)
{$ENDIF}
  private
    FPropList: TZPropList;
    procedure Modified; {$IFDEF Prior4} override; {$ENDIF}
{$IFDEF Prior4}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetSelections(List: TComponentList); override;
    procedure SetSelections(List: TComponentList); override;
  {$IFDEF Delphi3}
    procedure AddInterfaceMember(const MemberText: string); override;
  {$ENDIF}
{$ELSE}
    procedure Notification(AnObject: TPersistent; Operation: TOperation);
    procedure GetSelections(const List: IDesignerSelections);
    procedure SetSelections(const List: IDesignerSelections);
    function GetCustomForm: TCustomForm;
    procedure SetCustomForm(Value: TCustomForm);
    function GetIsControl: Boolean;
    procedure SetIsControl(Value: Boolean);
    procedure AddToInterface(InvKind: Integer; const Name: string; VT: Word;
      const TypeInfo: string);
    procedure GetProjectModules(Proc: TGetModuleProc);
    function GetAncestorDesigner: IFormDesigner;
    function IsSourceReadOnly: Boolean;
{$ENDIF}
    function IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean; {$IFDEF Prior4} override; {$ENDIF}
    procedure PaintGrid; {$IFDEF Prior4} override; {$ENDIF}
    procedure ValidateRename(AComponent: TComponent;
      const CurName, NewName: string); {$IFDEF Prior4} override; {$ENDIF}
    { IFormDesigner }
    function CreateMethod(const Name: string; TypeData: PTypeData): TMethod; {$IFDEF Prior4} override; {$ENDIF}
    function GetMethodName(const Method: TMethod): string; {$IFDEF Prior4} override; {$ENDIF}
    procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc); {$IFDEF Prior4} override; {$ENDIF}
    function GetPrivateDirectory: string; {$IFDEF Prior4} override; {$ENDIF}
    function MethodExists(const Name: string): Boolean; {$IFDEF Prior4} override; {$ENDIF}
    procedure RenameMethod(const CurName, NewName: string); {$IFDEF Prior4} override; {$ENDIF}
    procedure SelectComponent(Instance: {$IFDEF Delphi2}TComponent{$ELSE}TPersistent{$ENDIF}); {$IFDEF Prior4} override; {$ENDIF}
    procedure ShowMethod(const Name: string); {$IFDEF Prior4} override; {$ENDIF}
    function UniqueName(const BaseName: string): string; {$IFDEF Prior4} override; {$ENDIF}
    procedure GetComponentNames(TypeData: PTypeData; Proc: TGetStrProc); {$IFDEF Prior4} override; {$ENDIF}
    function GetComponent(const Name: string): TComponent; {$IFDEF Prior4} override; {$ENDIF}
    function GetComponentName(Component: TComponent): string; {$IFDEF Prior4} override; {$ENDIF}
    function MethodFromAncestor(const Method: TMethod): Boolean; {$IFDEF Prior4} override; {$ENDIF}
    function CreateComponent(ComponentClass: TComponentClass; Parent: TComponent;
      Left, Top, Width, Height: Integer): TComponent; {$IFDEF Prior4} override; {$ENDIF}
    function IsComponentLinkable(Component: TComponent): Boolean; {$IFDEF Prior4} override; {$ENDIF}
    procedure MakeComponentLinkable(Component: TComponent); {$IFDEF Prior4} override; {$ENDIF}
    function GetRoot: TComponent; {$IFDEF Prior4} override; {$ENDIF}
    procedure Revert(Instance: TPersistent; PropInfo: PPropInfo); {$IFDEF Prior4} override; {$ENDIF}
{$IFNDEF Delphi2}
    function GetObject(const Name: string): TPersistent; {$IFDEF Prior4} override; {$ENDIF}
    function GetObjectName(Instance: TPersistent): string; {$IFDEF Prior4} override; {$ENDIF}
    procedure GetObjectNames(TypeData: PTypeData; Proc: TGetStrProc); {$IFDEF Prior4} override; {$ENDIF}
    function GetIsDormant: Boolean; {$IFDEF Prior4} override; {$ENDIF}
    function HasInterface: Boolean; {$IFDEF Prior4} override; {$ENDIF}
    function HasInterfaceMember(const Name: string): Boolean; {$IFDEF Prior4} override; {$ENDIF}
{$ENDIF}
{$IFDEF Delphi5}
    function GetContainerWindow: TWinControl;
    procedure SetContainerWindow(const NewContainer: TWinControl);
    function GetScrollRanges(const ScrollPosition: TPoint): TPoint;
    procedure Edit(const Component: IComponent);
    function BuildLocalMenu(Base: TPopupMenu; Filter: TLocalMenuFilters): TPopupMenu;
    procedure ChainCall(const MethodName, InstanceName, InstanceMethod: string;
      TypeData: PTypeData);
    procedure CopySelection;
    procedure CutSelection;
    function CanPaste: Boolean;
    procedure PasteSelection;
    procedure DeleteSelection;
    procedure ClearSelection;
    procedure NoSelection;
    procedure ModuleFileNames(var ImplFileName, IntfFileName, FormFileName: string);
    function GetRootClassName: string;
{$ENDIF}
  public
    constructor Create(APropList: TZPropList);
  end;

  TNewObjectEvent = procedure (Sender: TZPropList; OldObj,
    NewObj: TObject) of object;
{$IFNDEF Delphi2}
  THintEvent = procedure (Sender: TZPropList; Prop: TPropertyEditor;
    HintInfo: PHintInfo) of object;
{$ENDIF}
  TChangingEvent = procedure (Sender: TZPropList; Prop: TPropertyEditor;
    var CanChange: Boolean; const Value: string) of object;
  TChangeEvent = procedure (Sender: TZPropList; Prop: TPropertyEditor) of object;
  TInitCurrentEvent=procedure (Sender: TZPropList; const PropName: String) of object;

  TTranslateList=class(TObject)
  private
    FReal: TStringList;
    FTranslate: TStringList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy;override;
    procedure BeginUpdate;
    procedure EndUpdate;
    function Add(Real,Translate: string): Integer;
    function GetTranslate(Real: String): String; overload;
    function GetTranslate(Index: Integer): String; overload;
    procedure Clear;
    property Count: Integer read GetCount;
  end;

  IDesignDesignerSelections=IDesignerSelections;

  TDesignDesignerSelections=class(TInterfacedObject,IDesignDesignerSelections)
    function Add(const Item: IPersistent): Integer;
    function Equals(const List: IDesignerSelections): Boolean;
    function Get(Index: Integer): IPersistent;
    function GetCount: Integer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: IPersistent read Get; default;
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
  end;
  
  TZPropList = class(TCustomControl)
  private
    FCurObj: TObject;
    FPropCount: Integer;
    FEditors: TZEditorList;
    FRowHeight: Integer;
    FHasScrollBar: Boolean;
    FTopRow: Integer;
    FCurrent: Integer;
    FVertLine: Integer;
    FHitTest: TPoint;
    FDividerHit: Boolean;
    FInplaceEdit: TZInplaceEdit;
    FInUpdate: Boolean;
    FDesigner: IFormDesigner;
    FIntegralHeight: Boolean;
    FDefFormProc: Pointer;
    FFormHandle: HWND;
    FFilter: TTypeKinds;
    FModified: Boolean;
    FCurrentIdent: Integer;
    FCurrentPos: Integer;
    FTracking: Boolean;
    FNewButtons: Boolean;
    FDestroying: Boolean;
    FBorderStyle: TBorderStyle;
{$IFDEF Post4}
    FScrollBarStyle: TScrollBarStyle;
{$ENDIF}
    FOnNewObject: TNewObjectEvent;
{$IFNDEF Delphi2}
    FOnHint: THintEvent;
{$ENDIF}
    FOnChanging: TChangingEvent;
    FOnChange: TChangeEvent;
    FOnInitCurrent: TInitCurrentEvent;

    FLastProp: string;
    FTranslateList: TTranslateList;
    FTranslated: Boolean;
    FSorted: Boolean;
    FRemoveList: TStringList;
    isCreateWnd: Boolean;
    FValueColor: TColor;
    FSubPropertyColor: TColor;
    FReferenceColor: TColor;

    FSelections: TList;

    procedure SetSorted(Value: Boolean);
    procedure QuickSort(L, R: Integer; WithExchange: Boolean);
//    function GetSortPos(Index1,Index2: Integer): Integer;

    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
{$IFNDEF Delphi2}
    procedure CMHintShow(var Msg: TCMHintShow); message CM_HINTSHOW;
{$ENDIF}
    procedure SetCurObj(const Value: TObject);
    procedure UpdateScrollRange;
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMCancelMode(var Msg: TMessage); message WM_CANCELMODE;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMMouseWheel(var Message: TWMMouseWheel);message WM_MOUSEWHEEL;
    procedure ModifyScrollBar(ScrollCode: Integer);
    procedure MoveTop(NewTop: Integer);
    function MoveCurrent(NewCur: Integer): Boolean;
    procedure InvalidateSelection;
    function VertLineHit(X: Integer): Boolean;
    function YToRow(Y: Integer): Integer;
    procedure SizeColumn(X: Integer);
    function GetValue(Index: Integer): string;
    function GetPrintableValue(Index: Integer): string;
    procedure DoEdit(E: TPropertyEditor; DoEdit: Boolean; const Value: string);
    procedure SetValue(Index: Integer; const Value: string);
    procedure CancelMode;
    function GetEditRect: TRect;
    function UpdateText(Exiting: Boolean): Boolean;
    function ColumnSized(X: Integer): Boolean;
    procedure FreePropList;
    procedure InitPropList;
    procedure PropEnumProc(Prop: TPropertyEditor);
    procedure SetIntegralHeight(const Value: Boolean);
    procedure FormWndProc(var Message: TMessage);
    procedure SetFilter(const Value: TTypeKinds);
    procedure ChangeCurObj(const Value: TObject);
    function GetName(Index: Integer): string;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    function GetValueRect(ARow: Integer): TRect;
    procedure SetNewButtons(const Value: Boolean);
    procedure SetMiddle(const Value: Integer);
{$IFDEF Post4}
    procedure SetScrollBarStyle(const Value: TScrollBarStyle);
{$ENDIF}
    procedure NodeClicked;
    function ButtonHit(X: Integer): Boolean;
    procedure SetBorderStyle(Value: TBorderStyle);
    function GetFullPropName(Index: Integer): string;
    function TranslateName(Value: string): string;
  protected
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DblClick; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function GetPropType: TZPropType;
    procedure Edit;
    function Editor: TPropertyEditor;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateEditor(CallActivate: Boolean);
    function GetParentPersistent(Ident,Pos: Integer): TPersistent;
    function IsPropertyClassValueExists(Curr,CurrParent: TPersistent): Boolean;
    function IsPropertyMoreOne(Curr: TPersistent; PropEditor: TPropertyEditor; PropName: string): Boolean;
    function InListRemove(PropName: String; ClassType: TClass): Boolean;

    procedure SetValueColor(Value: TColor);
    procedure SetSubPropertyColor(Value: TColor);
    procedure SetReferenceColor(Value: TColor);
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Resize;override;
    procedure InitCurrent(const PropName: string);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    function VisibleRowCount: Integer;
    procedure MarkModified;
    procedure ClearModified;
    procedure Synchronize;
    procedure SetFocus; override;
    procedure Sort(FromIndex,ToIndex: Integer);
    property CurObj: TObject read FCurObj write SetCurObj;
    property Modified: Boolean read FModified;
    property RowHeight: Integer read FRowHeight;
    property PropCount: Integer read FPropCount;
    property InplaceEdit: TZInplaceEdit read FInplaceEdit;
    property LastProp: string read FLastProp write FLastProp;
    property TranslateList: TTranslateList read FTranslateList;
    property Translated: Boolean read FTranslated write FTranslated;
    property Sorted: Boolean read FSorted write SetSorted;
    property RemoveList: TStringList read FRemoveList;
    property Designer: IFormDesigner read FDesigner write FDesigner;
    property Selections: TList read FSelections;
  published
    property ValueColor: TColor read FValueColor write SetValueColor;
    property SubPropertyColor: TColor read FSubPropertyColor write SetSubPropertyColor;
    property ReferenceColor: TColor read FReferenceColor write SetReferenceColor;

    property IntegralHeight: Boolean read FIntegralHeight
      write SetIntegralHeight default False;
    property Filter: TTypeKinds read FFilter write SetFilter default tkProperties;
    property NewButtons: Boolean read FNewButtons write SetNewButtons
      default {$IFDEF Delphi5}True{$ELSE}False{$ENDIF};
    property Middle: Integer read FVertLine write SetMiddle default 85;
{$IFDEF Post4}
    property ScrollBarStyle: TScrollBarStyle read FScrollBarStyle
      write SetScrollBarStyle default ssRegular;
{$ENDIF}
    property OnNewObject: TNewObjectEvent read FOnNewObject write FOnNewObject;
{$IFNDEF Delphi2}
    property OnHint: THintEvent read FOnHint write FOnHint;
{$ENDIF}
    property OnChanging: TChangingEvent read FOnChanging write FOnChanging;
    property OnChange: TChangeEvent read FOnChange write FOnChange;
    property OnInitCurrent: TInitCurrentEvent read FOnInitCurrent write FOnInitCurrent; 

    property Align;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color default clBtnFace;
    property Ctl3D;
    property Cursor;
    property Enabled;
    property Font;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint default False;
    property PopupMenu;
    property ShowHint default True;
    property TabOrder;
    property TabStop default True;
    property Visible;
  end;


procedure Register;

implementation

uses
  CommCtrl{$IFDEF Delphi3}, Menus {$ENDIF} ,dialogs, consts, UMainUnited, tsvDesignCore;

const
  MINCOLSIZE   = 32;
  DROPDOWNROWS = 8;
  TranslateNotFound='Свойству <%s> нет перевода';

procedure Register;
begin
  RegisterComponents('Gena''s', [TZPropList]);
end;

{ Return mimimum of two signed integers }
function EMax(A, B: Integer): Integer;
asm
{     ->EAX     A
        EDX     B
      <-EAX     Min(A, B) }

        CMP     EAX,EDX
        JGE     @@Exit
        MOV     EAX,EDX
  @@Exit:
end;

{ Return maximum of two signed integers }
function EMin(A, B: Integer): Integer;
asm
{     ->EAX     A
        EDX     B
      <-EAX     Max(A, B) }

        CMP     EAX,EDX
        JLE     @@Exit
        MOV     EAX,EDX
  @@Exit:
end;

{ TDesignDesignerSelections }

constructor TDesignDesignerSelections.Create;
begin
  FList:=TList.Create;
end;

destructor TDesignDesignerSelections.Destroy;
begin
  FList.Free;
  inherited;
end;

function TDesignDesignerSelections.Add(const Item: IPersistent): Integer;
begin
  Result:=FList.Add(Pointer(Item));
end;

function TDesignDesignerSelections.Equals(const List: IDesignerSelections): Boolean;
begin
  Result:=false;
end;

function TDesignDesignerSelections.Get(Index: Integer): IPersistent;
begin
  Result:=IPersistent(FList.Items[Index]);
end;

function TDesignDesignerSelections.GetCount: Integer;
begin
  Result:=FList.Count;
end;

procedure TDesignDesignerSelections.Clear;
begin
  FList.Clear;
  FList.Count:=0;
end;

{ TZEditorList }

constructor TZEditorList.Create(APropList: TZPropList);
begin
  inherited Create;
  FPropList := APropList;
end;

procedure TZEditorList.DeleteEditor(Index: Integer);
var
  P: PZEditor;
begin
  P := Editors[Index];
  P.peEditor.Free;
  FreeMem(P);
end;

function TZEditorList.IndexOfPropName(const PropName: string;
  StartIndex: Integer): Integer;
var
  I: Integer;
begin
  if StartIndex < Count then
  begin
    Result := 0;
{    for I := StartIndex to Count - 1 do
      if FPropList.TranslateName(Editors[I].peEditor.GetName) =
         FPropList.TranslateName(PropName) then
      begin
        Result := I;
        Exit;
      end;}
    for I := StartIndex to Count - 1 do
      if Editors[I].peEditor.GetName =
         PropName then
      begin
        Result := I;
        Exit;
      end;

  end
  else
    Result := -1;
end;

function TZEditorList.FindPropName(const PropName: string): Integer;
var
  S, Prop: string;
  I: Integer;
begin
  Result := -1;
  S := PropName;
  while S <> '' do        // Expand subproperties
  begin
    I := Pos('\', S);
    if I > 0 then
    begin
      Prop := Copy(S, 1, I - 1);
      System.Delete(S, 1, I);
    end
    else
    begin
      Prop := S;
      S := '';
    end;

    I := IndexOfPropName(Prop, Succ(Result));
    if I <= Result then Exit;
    Result := I;

    if S <> '' then
      with Editors[Result]^ do
        if peNode then
          if not peExpanded then
          begin
            FPropList.FCurrentIdent := peIdent + 1;
            FPropList.FCurrentPos := Result + 1;
            try
              peEditor.GetProperties(FPropList.PropEnumProc);
            except
            end;
            peExpanded := True;
            FPropList.FPropCount := Count;
          end
        else Exit;
  end;
end;

procedure TZEditorList.Add(Editor: PZEditor);
begin
  inherited Add(Editor);
end;

procedure TZEditorList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do DeleteEditor(I);
  inherited;
end;

function TZEditorList.GetEditor(AIndex: Integer): PZEditor;
begin
  Result := Items[AIndex];
end;

procedure TZEditorList.SetEditor(AIndex: Integer; Value: PZEditor);
begin
  Items[AIndex]:=Value;
end;

{ TZPopupList }

constructor TZPopupList.Create(AOwner: TComponent);
begin
  inherited;
  Parent := AOwner as TWinControl;
  ParentCtl3D := False;
  Ctl3D := False;
  Visible := False;
  TabStop := False;
{$IFDEF Delphi5}
  Style := lbOwnerDrawVariable;
{$ELSE}
  IntegralHeight := True;
{$ENDIF}
end;

procedure TZPopupList.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    X := -200;  // move listbox offscreen
{$IFDEF Post4}
    AddBiDiModeExStyle(ExStyle);
{$ENDIF}
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TZPopupList.CreateWnd;
begin
  inherited;
{  if not (csDesigning in ComponentState) then
  begin}
    Windows.SetParent(Handle, 0);
    CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
    
//  end;
end;

procedure TZPopupList.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
  end;
end;

procedure TZPopupList.KeyPress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27: FSearchText := '';
    #32..#255:
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTickCount > 2000 then FSearchText := '';
        FSearchTickCount := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

{ TZListButton }

constructor TZListButton.Create(AOwner: TComponent);
begin
  inherited;
  FEditor := AOwner as TZInplaceEdit;
  FPropList := FEditor.FPropList;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  FActiveList := TZPopupList.Create(Self);
  FActiveList.OnMouseUp := ListMouseUp;
{$IFDEF Delphi5}
  FActiveList.OnMeasureItem := MeasureHeight;
  FActiveList.OnDrawItem := DrawItem;
{$ENDIF}
end;

procedure TZListButton.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
//    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
  end;
end;

procedure TZListButton.Paint;
var
  R,R1: TRect;
  Flags, X, Y, W: Integer;
begin
  R := ClientRect;
  InflateRect(R, 0, 0);
  Flags := 0;

  with Canvas do
    if FArrow then
    begin
      if FPressed then Flags := DFCS_FLAT or DFCS_PUSHED;
      R1:=R;
      R1.Top:=R1.Top-1;
      DrawFrameControl(Handle, R1, DFC_SCROLL, Flags or DFCS_SCROLLCOMBOBOX);
    end
    else
    begin
      if FPressed then Flags := BF_FLAT;
      DrawEdge(Handle, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
      X := R.Left + ((R.Right - R.Left) shr 1) - 1 + Ord(FPressed);
      Y := R.Top + ((R.Bottom - R.Top) shr 1) - 1 + Ord(FPressed);
      W := (FButtonWidth) shr 3;
      if W = 0 then W := 1;
      PatBlt(Handle, X, Y, W, W, BLACKNESS);
      PatBlt(Handle, X - (W + W)+1, Y, W, W, BLACKNESS);
      PatBlt(Handle, X + W + W-1, Y, W, W, BLACKNESS);
    end;
end;

procedure TZListButton.TrackButton(X, Y: Integer);
var
  NewState: Boolean;
  R: TRect;
begin
  R := ClientRect;
  NewState := PtInRect(R, Point(X, Y));
  if FPressed <> NewState then
  begin
    FPressed := NewState;
    Invalidate;
  end;
end;

function TZListButton.Editor: TPropertyEditor;
begin
  Result := FPropList.Editor;
end;

type
  TGetStrFunc = function(const Value: string): Integer of object;
  
procedure TZListButton.DropDown;
var
  I, M, W: Integer;
  P: TPoint;
  MCanvas: TCanvas;
  AddValue: TGetStrFunc;
begin
  if not FListVisible then
  begin
    FActiveList.Clear;
    with Editor do
    begin
      FActiveList.Sorted := paSortList in GetAttributes;
      AddValue := FActiveList.Items.Add;
      GetValues(TGetStrProc(AddValue));
      SendMessage(FActiveList.Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(GetValue)));
    end;

    with FActiveList do
    begin
      M := EMax(1, EMin(Items.Count, DROPDOWNROWS));
      {$IFDEF Delphi5}
      I := FListItemHeight;
      MeasureHeight(nil, 0, I);
      {$ELSE}
      I := ItemHeight;
      {$ENDIF}
      Height := M * I + 2;
      width := Self.Width + FEditor.Width + 1;
    end;

    with FActiveList do
    begin
      M := ClientWidth;
      MCanvas := FPropList.Canvas;
      for I := 0 to Items.Count - 1 do
      begin
        W := MCanvas.TextWidth(Items[I]) + 4;
        {$IFDEF Delphi5}
        with Editor do
          ListMeasureWidth(GetName, MCanvas, W);
        {$ENDIF}
        if W > M then M := W;
      end;
      ClientWidth := M;
      W := Self.Parent.ClientWidth;
      if Width > W then Width := W;
    end;

    P := Parent.ClientToScreen(Point(Left + Width, Top + Height));
    with FActiveList do
    begin
      if P.Y + Height > Screen.Height then P.Y := P.Y - Self.Height - Height;
      SetWindowPos(Handle, HWND_TOP, P.X - Width, P.Y,
        0, 0, SWP_NOSIZE + SWP_SHOWWINDOW);
      SetActiveWindow(Handle);
    end;
    SetFocus;
    FListVisible := True;
  end;
end;

procedure TZListButton.CloseUp(Accept: Boolean);
var
  ListValue: string;
  Ch: Char;
begin
  if FListVisible then
  begin
    with FActiveList do
    begin
      if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
        ListValue := Items[ItemIndex] else Accept := False;
//    Invalidate;
      Hide;
      Ch := #27; // Emulate ESC
      FEditor.KeyPress(Ch);
    end;
    FListVisible := False;
    if Accept then  // Emulate ENTER keypress
    begin
      FEditor.Text := ListValue;
      FEditor.Modified := True;
      Ch := #13;
      FEditor.KeyPress(Ch);
    end;
    if Focused then FEditor.SetFocus;
  end;
end;                    

procedure TZListButton.StopTracking;
begin
  if FTracking then
  begin
    TrackButton(-1, -1);
    FTracking := False;
//    MouseCapture := False;
  end;
end;

procedure TZListButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if FListVisible then
      CloseUp(False)
    else
    begin
//      MouseCapture := True;
      FTracking := True;
      TrackButton(X, Y);
      if FArrow then DropDown;
    end;
  end;
  inherited;
end;

procedure TZListButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ListPos: TPoint;
  MousePos: TSmallPoint;
begin
  if FTracking then
  begin
    TrackButton(X, Y);
    if FListVisible then
    begin
      ListPos := FActiveList.ScreenToClient(ClientToScreen(Point(X, Y)));
      if PtInRect(FActiveList.ClientRect, ListPos) then
      begin
        StopTracking;
        MousePos := PointToSmallPoint(ListPos);
        SendMessage(FActiveList.Handle, WM_LBUTTONDOWN, 0, Integer(MousePos));
        Exit;
      end;
    end;
  end;
  inherited;
end;

procedure TZListButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  WasPressed: Boolean;
begin
  WasPressed := FPressed;
  StopTracking;
  if (Button = mbLeft) and not FArrow and WasPressed then FEditor.DblClick;
  inherited;
end;

procedure TZListButton.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CloseUp(PtInRect(FActiveList.ClientRect, Point(X, Y)));
end;

procedure TZListButton.DoDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN, VK_ESCAPE:
      if FListVisible and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
    else
  end;
end;

procedure TZListButton.CMCancelMode(var Message: TCMCancelMode);
begin
  inherited;
  if (Message.Sender <> Self) and (Message.Sender <> FActiveList) then
    CloseUp(False);
end;

procedure TZListButton.WMCancelMode(var Msg: TWMKillFocus);
begin
  StopTracking;
  inherited;
end;

procedure TZListButton.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  CloseUp(False);
end;

procedure TZListButton.KeyPress(var Key: Char);
begin
  if FListVisible then FActiveList.KeyPress(Key);
end;

procedure TZListButton.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_KEYDOWN, WM_SYSKEYDOWN, WM_CHAR:
      with TWMKey(Message) do
      begin
        DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
        if (CharCode <> 0) and FListVisible then
        begin
          with TMessage(Message) do
            SendMessage(FActiveList.Handle, Msg, WParam, LParam);
          Exit;
        end;
      end
  end;
  inherited;
end;

procedure TZListButton.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

{$IFDEF Delphi5}
procedure TZListButton.MeasureHeight(Control: TWinControl; Index: Integer;
  var Height: Integer);
begin
  Height := FListItemHeight;
  with Editor do
    ListMeasureHeight(GetName, FActiveList.Canvas, Height);
end;

procedure TZListButton.DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with FActiveList do
    Editor.ListDrawValue(Items[Index], Canvas,
      Rect, odSelected in State);
end;

procedure TZListButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Canvas.Font := FPropList.Font;
  FListItemHeight := Canvas.TextHeight('Wg') + 2;
end;
{$ENDIF}

{ TZInplaceEdit }

constructor TZInplaceEdit.Create(AOwner: TComponent);
begin
  inherited;
  Parent := AOwner as TWinControl;
  FPropList := AOwner as TZPropList;
  FListButton := TZListButton.Create(Self);
  FListButton.Parent := Parent;
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsNone;
  Visible := False;
end;

procedure TZInplaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TZInplaceEdit.InternalMove(const Loc: TRect; Redraw: Boolean);
var
  W, H: Integer;
  ButtonVisible: Boolean;
begin
  if IsRectEmpty(Loc) then Exit;
  Redraw := Redraw or not IsWindowVisible(Handle);
  with Loc do
  begin
    W := Right - Left;
    H := Bottom - Top;
    FPropType := FPropList.GetPropType;

    ButtonVisible := (FPropType <> ptSimple);

    if ButtonVisible then Dec(W, FListButton.FButtonWidth);
    SetWindowPos(Handle, HWND_TOP, Left, Top, W, H,
      SWP_SHOWWINDOW or SWP_NOREDRAW);
    if ButtonVisible then
    begin
      FListButton.FArrow := FPropType = ptPickList;
      SetWindowPos(FListButton.Handle, HWND_TOP, Left + W, Top,
        FListButton.FButtonWidth, H, SWP_SHOWWINDOW or SWP_NOREDRAW);
    end
    else FListButton.Hide;
  end;
  BoundsChanged;

  if Redraw then
  begin
    Invalidate;
    FListButton.Invalidate;
  end;
  if FPropList.Focused then Windows.SetFocus(Handle);
end;

procedure TZInplaceEdit.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 1, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, Integer(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TZInplaceEdit.UpdateLoc(const Loc: TRect);
begin
  InternalMove(Loc, False);
end;

procedure TZInplaceEdit.Move(const Loc: TRect);
begin
  InternalMove(Loc, True);
end;

procedure TZInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
//  OutputDebugString('KeyDown');
  if (Key = VK_DOWN) and (ssAlt in Shift) then
    with FListButton do
  begin
    if (FPropType = ptPickList) and not FListVisible then DropDown;
    Key := 0;
  end;
  FIgnoreChange := Key = VK_DELETE;
  FPropList.KeyDown(Key, Shift);
  if Key in [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT] then Key := 0;
end;

procedure TZInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
//  OutputDebugString('KeyUp');
  FPropList.KeyUp(Key, Shift);
end;

procedure TZInplaceEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then
    Windows.SetFocus(Handle);
end;

procedure TZInplaceEdit.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  DestroyCaret;
  CreateCaret(Handle, 0, 1, FPropList.Canvas.TextHeight('A'));
  ShowCaret(Handle);
end;

procedure TZInplaceEdit.KeyPress(var Key: Char);
begin
//  OutputDebugString('KeyPress');
//  FPropList.KeyPress(Key);
  FIgnoreChange := (Key = #8) or (SelText <> '');
  case Key of
    #10: DblClick;  // Ctrl + ENTER;
    #13: if Modified then FPropList.UpdateText(True) else SelectAll;
    #27: with FPropList do
           if paRevertable in Editor.getAttributes then UpdateEditor(False);
    else Exit;
  end;
  Key := #0;
end;

procedure TZInplaceEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if (Msg.FocusedWnd <> FPropList.Handle) and
    (Msg.FocusedWnd <> FListButton.Handle) then
    if not FPropList.UpdateText(True) then SetFocus;
end;

procedure TZInplaceEdit.WMMouseWheel(var Message: TWMMouseWheel);
var
  NewCurrent: Integer;
begin
  NewCurrent := FPropList.FCurrent;
  with Message do begin
    if WheelDelta<0 then
      Inc(NewCurrent)
    else Dec(NewCurrent);
    Result:=1;
  end;
  FPropList.MoveCurrent(NewCurrent);
end;

procedure TZInplaceEdit.DblClick;
begin
  FPropList.Edit;
end;

procedure TZInplaceEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited;
end;

procedure TZInplaceEdit.AutoComplete(const S: string);
var
  I: Integer;
  Values: TStringList;
  AddValue: TGetStrFunc;
begin
  Values := TStringList.Create;
  try
    AddValue := Values.Add;
    FPropList.Editor.GetValues(TGetStrProc(AddValue));
    for I := 0 to Values.Count - 1 do
      if StrLIComp(PChar(S), PChar(Values[I]), Length(S)) = 0 then
      begin
        SendMessage(Handle, WM_SETTEXT, 0, Integer(Values[I]));
        SendMessage(Handle, EM_SETSEL, Length(S), Length(Values[I]));
        Modified := True;
        Break;
      end;
  finally
    Values.Free;
  end;
end;

procedure TZInplaceEdit.Change;
begin
  inherited;
  if Modified then
  begin
//    OutputDebugString(PChar('Change, Text = "' + Text + '"'));
    if (FPropType = ptPickList) and not FIgnoreChange then
      AutoComplete(Text);
    FIgnoreChange := False;
    if FAutoUpdate then FPropList.UpdateText(False);
  end;
end;

{ TZPropList }

constructor TZPropList.Create(AOwner: TComponent);
const
  PropListStyle = [csCaptureMouse, csOpaque, csDoubleClicks];
begin
  inherited;
  FFormHandle:=0;
  FInplaceEdit := TZInplaceEdit.Create(Self);
  FValueColor:=clNavy;
  FSubPropertyColor:=clBtnShadow;
  FReferenceColor:=clMaroon;
  
  FEditors := TZEditorList.Create(Self);
//  FDesigner := TZFormDesigner.Create(Self);
  FDesigner :=nil;
{$IFDEF Post4}
//  IFormDesigner(FDesigner)._AddRef;
{$ENDIF}
{$IFDEF Delphi5}
  FNewButtons := True;
{$ENDIF}  
  FCurrent := -1;
  FFilter := tkProperties;
  FBorderStyle := bsSingle;

  if NewStyleControls then
    ControlStyle := PropListStyle else
    ControlStyle := PropListStyle + [csFramed];
  Color := clBtnFace;
  ParentColor := False;
  TabStop := True;
  SetBounds(Left, Top, 200, 200);
  FVertLine := 85;
  ShowHint := True;
  ParentShowHint := False;

  FTranslateList:=TTranslateList.Create;
  FRemoveList:=TStringList.Create;
  FSelections:=TList.Create;

end;

procedure TZPropList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style + WS_TABSTOP;
    Style := Style + WS_VSCROLL;
    WindowClass.style := CS_DBLCLKS;
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

procedure TZPropList.InitCurrent(const PropName: string);
begin
//  FCurrent := FEditors.FindPropName(PropName);
  MoveCurrent(FEditors.FindPropName(PropName));
//  if Assigned(FInplaceEdit) then FInplaceEdit.Move(GetEditRect);
end;

procedure TZPropList.FreePropList;
begin
  FEditors.Clear;
  FPropCount := 0;
end;

procedure TZPropList.InitPropList;
var
  Components: TDesignerSelectionList;
  i: Integer;
begin
  Components := TDesignerSelectionList.Create;
  try
    if FSelections.Count>0 then begin
      if FCurObj is TComponent then
        for i:=0 to FSelections.Count-1 do begin
          Components.Add(FSelections.Items[i]);
        end
       else Components.Add(TPersistent(FCurObj));
    end else begin
      Components.Add(TPersistent(FCurObj));
    end;
    FCurrentIdent := 0;
    FCurrentPos := 0;
    GetComponentProperties(Components, FFilter, FDesigner, PropEnumProc);
    FPropCount := FEditors.Count;
  finally
    Components.Free;
  end;
end;

function TZPropList.GetFullPropName(Index: Integer): string;
begin
  Result := FEditors[Index].peEditor.GetName;
  while Index > 0 do
  begin
    if FEditors[Pred(Index)].peIdent <> FEditors[Index].peIdent then
      Result := FEditors[Pred(Index)].peEditor.GetName + '\' + Result;
    Dec(Index);
  end;
end;

procedure TZPropList.ChangeCurObj(const Value: TObject);
var
  SavedPropName: string;
begin
  if (FCurrent >= 0) and (FCurrent < FPropCount) then
    SavedPropName := GetFullPropName(FCurrent)
  else SavedPropName := '';

  FCurObj := Value;
  FreePropList;
  if not FDestroying then
  begin
    InitCurrent('');

    if Assigned(Value) then
    begin
      InitPropList;
      Sort(0,FEditors.Count-1);
      InitCurrent(SavedPropName);
      UpdateEditor(True);
    end;


    
    Invalidate;
    UpdateScrollRange;
  end;
end;

procedure TZPropList.SetCurObj(const Value: TObject);
begin
//  if FCurObj <> Value then begin
    if Assigned(FOnNewObject) then FOnNewObject(Self, FCurObj, Value);
    if not FDestroying then
      FInplaceEdit.Modified := False;
    FModified := False;
    ChangeCurObj(Value);

    if Value is TComponent then
      TComponent(Value).FreeNotification(Self);
//  end;
end;

procedure TZPropList.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Canvas.Font := Font;
  FRowHeight := Canvas.TextHeight('Wg') + 3;
  Invalidate;
  UpdateScrollRange;
  FInplaceEdit.Move(GetEditRect);
end;

procedure TZPropList.UpdateScrollRange;
var
  si: TScrollInfo;
  diVisibleCount, diCurrentPos: Integer;
begin
  if not FHasScrollBar or not HandleAllocated or not Showing then Exit;

  { Temporarily mark us as not having scroll bars to avoid recursion }
  FHasScrollBar := False;
  try
    with si do
    begin
      cbSize := SizeOf(TScrollInfo);
      fMask := SIF_RANGE + SIF_PAGE + SIF_POS;
      nMin := 0;
      diVisibleCount := VisibleRowCount;
      diCurrentPos := FTopRow;

      if FPropCount <= diVisibleCount then
      begin
        nPage := 0;
        nMax := 0;
      end
      else
      begin
        nPage := diVisibleCount;
        nMax := FPropCount - 1;
      end;

      if diCurrentPos + diVisibleCount > FPropCount then
        diCurrentPos := EMax(0, FPropCount - diVisibleCount);
      nPos := diCurrentPos;
      {$IFDEF Prior4}
      SetScrollInfo(Handle, SB_VERT, si, True);
      {$ELSE}
      FlatSB_SetScrollInfo(Handle, SB_VERT, si, True);
      {$ENDIF}
      MoveTop(diCurrentPos);
    end;
  finally
    FHasScrollBar := True;
  end;
end;

function TZPropList.VisibleRowCount: Integer;
begin
  if FRowHeight > 0 then // avoid division by zero
    Result := EMin(ClientHeight div FRowHeight, FPropCount)
  else
    Result := FPropCount;
end;

procedure TZPropList.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then
  begin
    FHasScrollBar := True;
    Perform(CM_FONTCHANGED, 0, 0);
    FInplaceEdit.FListButton.Perform(CM_FONTCHANGED, 0, 0);
    if csDesigning in ComponentState then CurObj := Self;
    Parent.Realign;
{    UpdateScrollRange;
    InitCurrent;
    UpdateEditor(True);}
  end;
end;

procedure TZPropList.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;

procedure TZPropList.WMSize(var Msg: TWMSize);
begin
  inherited;
  if FRowHeight <= 0 then Exit;
  ColumnSized(FVertLine);         // move divider if needed
  Invalidate;
  FInplaceEdit.UpdateLoc(GetEditRect);
  UpdateScrollRange;
end;

procedure TZPropList.ModifyScrollBar(ScrollCode: Integer);
var
  OldPos, NewPos, MaxPos: Integer;
  si: TScrollInfo;
begin
  OldPos := FTopRow;
  NewPos := OldPos;

  with si do
  begin
    cbSize := SizeOf(TScrollInfo);
    fMask := SIF_ALL;
    {$IFDEF Prior4}
    GetScrollInfo(Handle, SB_VERT, si);
    {$ELSE}
    FlatSB_GetScrollInfo(Handle, SB_VERT, si);
    {$ENDIF}
    MaxPos := nMax - Integer(nPage) + 1;

    case ScrollCode of
      SB_LINEUP: Dec(NewPos);
      SB_LINEDOWN: Inc(NewPos);
      SB_PAGEUP: Dec(NewPos, nPage);
      SB_PAGEDOWN: Inc(NewPos, nPage);
      SB_THUMBPOSITION, SB_THUMBTRACK: NewPos := nTrackPos;
      SB_TOP: NewPos := nMin;
      SB_BOTTOM: NewPos := MaxPos;
      else Exit;
    end;

{    if NewPos < 0 then NewPos := 0;
    if NewPos > MaxPos then NewPos := MaxPos;}
    MoveTop(NewPos);
  end;
end;

procedure TZPropList.WMVScroll(var Msg: TWMVScroll);
begin
  ModifyScrollBar(Msg.ScrollCode);
end;

procedure TZPropList.MoveTop(NewTop: Integer);
var
  VertCount, ShiftY: Integer;
  ScrollArea: TRect;
begin
  if NewTop < 0 then NewTop := 0;
  VertCount := VisibleRowCount;
  if NewTop + VertCount > FPropCount then
    NewTop := FPropCount - VertCount;

  if NewTop = FTopRow then Exit;

  ShiftY := (FTopRow - NewTop) * FRowHeight;
  FTopRow := NewTop;
  ScrollArea := ClientRect;
  {$IFDEF Prior4}
  SetScrollPos(Handle, SB_VERT, NewTop, True);
  {$ELSE}
  FlatSB_SetScrollPos(Handle, SB_VERT, NewTop, True);
  {$ENDIF}
  if Abs(ShiftY) >= VertCount * FRowHeight then
    InvalidateRect(Handle, @ScrollArea, True)
  else
    ScrollWindowEx(Handle, 0, ShiftY,
      @ScrollArea, @ScrollArea, 0, nil, SW_INVALIDATE);

  FInplaceEdit.Move(GetEditRect);
end;

function TZPropList.GetValueRect(ARow: Integer): TRect;
var
  RowStart: Integer;
begin
  RowStart := (ARow - FTopRow) * FRowHeight;
  Result := Rect(FVertLine + 1, RowStart, ClientWidth, RowStart + FRowHeight - 1);
end;

function TZPropList.GetEditRect: TRect;
begin
  Result := GetValueRect(FCurrent);
end;

function TZPropList.IsPropertyClassValueExists(Curr,CurrParent: TPersistent): Boolean;
var
  I,Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
  obj: TObject;
begin
  Result:=false;
  Count := GetTypeData(Curr.ClassInfo)^.PropCount;
  if Count > 0 then begin
    GetMem(PropList, Count * SizeOf(Pointer));
    try
      GetPropInfos(Curr.ClassInfo, PropList);
      for I := 0 to Count - 1 do begin
        PropInfo := PropList^[I];
        if PropInfo = nil then break;
        if PropInfo.PropType^.Kind=tkClass then begin
          obj:=GetObjectProp(Curr,PropInfo);
          if obj=CurrParent then begin
            result:=true;
          end;
          if Result then exit;
        end;
      end;
    finally
      FreeMem(PropList, Count * SizeOf(Pointer));
    end;
  end;
end;

function TZPropList.InListRemove(PropName: String; ClassType: TClass): Boolean;
var
  i: Integer;
  cls: TClass;
begin
  Result:=false;
  for i:=0 to FRemoveList.Count-1 do begin
    if AnsiSameText(PropName,FRemoveList.Strings[i]) then begin
     cls:=TClass(FRemoveList.Objects[i]);
     if cls<>nil then begin
//       if isClassParent(ClassType,cls) then Result:=true;
       if cls=ClassType then Result:=true;
     end else Result:=true;
    end;
    if Result then exit;
  end;
end;

function TZPropList.IsPropertyMoreOne(Curr: TPersistent; PropEditor: TPropertyEditor; PropName: string): Boolean;
var
  I,Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
  obj: TObject;
  Check: Boolean;
begin
  Result:=true;
  if PropEditor is TComponentProperty then begin
    obj:=GetObjectProp(Curr,PropName);
    if obj<>nil then begin
      Count := GetTypeData(obj.ClassInfo)^.PropCount;
      if Count > 0 then begin
        GetMem(PropList, Count * SizeOf(Pointer));
        try
          GetPropInfos(obj.ClassInfo, PropList);
          for I := 0 to Count - 1 do begin
            PropInfo := PropList^[I];
            if PropInfo = nil then break;
            Check:=(PropInfo.PropType^.Kind in tkProperties);
            if Check then begin
              Result:=not InListRemove(PropInfo.Name,obj.ClassType);
              if Result then exit;
            end;
          end;
        finally
          FreeMem(PropList, Count * SizeOf(Pointer));
        end;
      end;
    end;  
  end;
end;

procedure TZPropList.Paint;
var
  NameColor: TColor;

  function IsPropertyClassValueExistsLocal(E: PZEditor; CurrParent: TPersistent): Boolean;
  begin
    if FSelections.Count=0 then begin
      Result:=IsPropertyClassValueExists(E.peEditor.GetComponent(0),CurrParent);
    end else begin
      Result:=IsPropertyClassValueExists(E.peEditor.GetComponent(0),CurrParent);
     { for i:=0 to FSelections.Count-1 do begin
        Result:=IsPropertyClassValueExists(TPersistent(FSelections.Items[i]),CurrParent);
        if Result then exit;
      end; }
    end;
  end;

  function IsPropertyMoreOneLocal(E: PZEditor): Boolean;
  begin
    if FSelections.Count=0 then begin
      Result:=IsPropertyMoreOne(E.peEditor.GetComponent(0),E.peEditor,E.peRealName);
    end else begin
      Result:=IsPropertyMoreOne(E.peEditor.GetComponent(0),E.peEditor,E.peRealName);
  {    for i:=0 to FSelections.Count-1 do begin
        Result:=IsPropertyMoreOne(FSelections.Items[i],E.peEditor,E.peRealName);
        if Result then exit;
      end;   }
    end;
  end;

  procedure DrawName(Index: Integer; R: TRect; XOfs: Integer);
  var
    S: string;
    E: PZEditor;
    BColor, PColor: TColor;
    YOfs: Integer;
    OldStyle: TFontStyles;
  begin
    if FNewButtons then begin
      E := FEditors[Index];
      S := E.peRealName;
      E.peNode:=paSubProperties in E.peEditor.GetAttributes;
      if E.peNode then
        if not IsPropertyMoreOneLocal(E) then
          E.peNode:=false;
      if E.peNode then
        if IsPropertyClassValueExistsLocal(E,E.peParent) then
           E.peNode:=false;

      OldStyle:=Font.Style;
      Inc(XOfs, R.Left + E.peIdent * 10);
      ExtTextOut(Canvas.Handle, XOfs + 11, R.Top + 1, ETO_CLIPPED or ETO_OPAQUE, @R, PChar(S), Length(S), nil);
      Font.Style:=OldStyle;

      if E.peNode then
       with Canvas do begin
        BColor := Brush.Color;
        PColor := Pen.Color;
        Brush.Color := clWindow;
        Pen.Color := NameColor;
        YOfs := R.Top + (FRowHeight - 9) shr 1;
        Rectangle(XOfs, YOfs, XOfs + 9, YOfs + 9);
        PolyLine([Point(XOfs + 2, YOfs + 4), Point(XOfs + 7, YOfs + 4)]);
        if not E.peExpanded then
          PolyLine([Point(XOfs + 4, YOfs + 2), Point(XOfs + 4, YOfs + 7)]);

        Brush.Color := BColor;
        Pen.Color := PColor;
      end;
    end else begin
      Canvas.TextRect(R, R.Left + XOfs, R.Top + 1, GetName(Index));
    end;
  end;


  function GetPenColor(Color: Integer): Integer;
  type
    TRGB = record
      R, G, B, A: Byte;
    end;
  begin
    // produce slightly darker color
    if Color < 0 then Color := GetSysColor(Color and $FFFFFF);
    Dec(TRGB(Color).R, EMin(TRGB(Color).R, $10));
    Dec(TRGB(Color).G, EMin(TRGB(Color).G, $10));
    Dec(TRGB(Color).B, EMin(TRGB(Color).B, $10));
    Result := Color;
  end;

var
  RedrawRect, NameRect, ValueRect, CurRect: TRect;
  FirstRow, LastRow, Y, RowIdx, CW, Offset: Integer;
  Color1,Color2: TColor;
  DrawCurrent: Boolean;
  PTI: PTypeInfo;
begin
  if FRowHeight < 1 then Exit;
  FInplaceEdit.Move(GetEditRect);

  with Canvas do begin
    RedrawRect := ClipRect;
    FirstRow := RedrawRect.Top div FRowHeight;
    LastRow := EMin(FPropCount - FTopRow - 1, (RedrawRect.Bottom - 1) div FRowHeight);
    if LastRow + FTopRow = Pred(FCurrent) then Inc(LastRow); // Selection occupies 2 rows

{with RedrawRect do
  Form1.p1.Caption := Format('%d, %d, %d, %d: %d-%d',
    [Left, Top, Right, Bottom, FirstRow, LastRow]);}

    NameRect := Bounds(0, FirstRow * FRowHeight, FVertLine, FRowHeight - 1);
    ValueRect := NameRect;
    ValueRect.Left := FVertLine + 2;
    CW := ClientWidth;
    ValueRect.Right := CW;
    Brush.Color := Self.Color;
    Pen.Color := GetPenColor(Self.Color);
    Font := Self.Font;
    NameColor := Font.Color;
    Color1:=FSubPropertyColor;
    Color2:=FReferenceColor;
    DrawCurrent := False;

    for Y := FirstRow to LastRow do begin
      RowIdx := Y + FTopRow;

      PTI:=FEditors[RowIdx].peEditor.GetPropType;

      if FEditors[RowIdx].peIdent=0 then begin
        Font.Color := NameColor;
        if PTI.Kind=tkClass then
          if FEditors[RowIdx].peEditor is TComponentProperty then
            Font.Color := Color2;
      end else begin
        Font.Color := NameColor;
        if PTI.Kind=tkClass then
          if FEditors[RowIdx].peEditor is TComponentProperty then Font.Color := Color2
          else Font.Color := Color1
        else {if FEditors[RowIdx].peParent<>FEditors[RowIdx].peEditor.GetComponent(0) then} Font.Color := Color1;
      end;

      if RowIdx = FCurrent then begin
        CurRect := Rect(0, NameRect.Top - 2, CW, NameRect.Bottom + 1);
        DrawCurrent := True;
        Inc(NameRect.Left); // Space for DrawEdge
        DrawName(RowIdx, NameRect, 1);
        Dec(NameRect.Left);
      end  else begin
        if RowIdx <> Pred(FCurrent) then  begin
          Offset := 0;
          PolyLine([Point(0, NameRect.Bottom), Point(CW, NameRect.Bottom)]);
        end else
          Offset := 1;
        Dec(NameRect.Bottom, Offset);
        DrawName(RowIdx, NameRect, 2);
        Inc(NameRect.Bottom, Offset);
        Font.Color := FValueColor;
        FEditors[RowIdx].peEditor.PropDrawValue(Self.Canvas, ValueRect, False);
      end;

      OffsetRect(NameRect, 0, FRowHeight);
      OffsetRect(ValueRect, 0, FRowHeight);
    end;

    Dec(NameRect.Bottom, FRowHeight - 1);
    NameRect.Right := CW;
    ValueRect := Rect(FVertLine, RedrawRect.Top, 10, NameRect.Bottom - 1);
    DrawEdge(Handle, ValueRect, EDGE_ETCHED, BF_LEFT);

    if DrawCurrent then
    begin
      DrawEdge(Handle, CurRect, BDR_SUNKENOUTER, BF_LEFT + BF_BOTTOM + BF_RIGHT);
      DrawEdge(Handle, CurRect, EDGE_SUNKEN, BF_TOP);
    end;

    if NameRect.Bottom < RedrawRect.Bottom then
    begin
      Brush.Color := Self.Color;
      RedrawRect.Top := NameRect.Bottom;
      FillRect(RedrawRect);
    end;
  end;
end;

procedure TZPropList.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TZPropList.KeyDown(var Key: Word; Shift: TShiftState);
var
  PageHeight, NewCurrent: Integer;
begin
  inherited KeyDown(Key, Shift);
  NewCurrent := FCurrent;
  PageHeight := VisibleRowCount - 1;
  case Key of
    VK_UP: Dec(NewCurrent);
    VK_DOWN: Inc(NewCurrent);
    VK_NEXT: Inc(NewCurrent, PageHeight);
    VK_PRIOR: Dec(NewCurrent, PageHeight);
    else Exit;
  end;
  MoveCurrent(NewCurrent);
end;

procedure TZPropList.InvalidateSelection;
var
  R: TRect;
  RowStart: Integer;
begin
  RowStart := (FCurrent - FTopRow) * FRowHeight;
  R := Rect(0, RowStart - 2, ClientWidth, RowStart + FRowHeight + 1);
  InvalidateRect(Handle, @R, True);
end;

function TZPropList.MoveCurrent(NewCur: Integer): Boolean;
var
  NewTop, VertCount: Integer;
  tmps: string;
begin
  Result := UpdateText(True);
  if not Result then Exit;

  if NewCur < 0 then NewCur := 0;
  if NewCur >= FPropCount then NewCur := FPropCount - 1;
  if NewCur = FCurrent then Exit;

  InvalidateSelection;
  FCurrent := NewCur;
  InvalidateSelection;

  NewTop := FTopRow;
  VertCount := VisibleRowCount;
  if NewCur < NewTop then NewTop := NewCur;
  if NewCur >= NewTop + VertCount then NewTop := NewCur - VertCount + 1;

  FInplaceEdit.Move(GetEditRect);
  UpdateEditor(True);
  MoveTop(NewTop);
  if Assigned(FOnInitCurrent) then begin
    if FCurrent=-1 then FCurrent:=0;
    if FCurrent>FEditors.Count-1 then FCurrent:=FEditors.Count-1;
    tmps:='';
    if FEditors.Count>0 then
     tmps:=FEditors[FCurrent].peEditor.GetName;
    FOnInitCurrent(Self,tmps);
  end;
end;

procedure TZPropList.MarkModified;
begin
  FModified := True;
end;

procedure TZPropList.ClearModified;
begin
  FModified := False;
end;

procedure TZPropList.Synchronize;
begin
  MarkModified;
  Invalidate;
  UpdateEditor(False);
end;

procedure TZPropList.UpdateEditor(CallActivate: Boolean);
var
  Attr: TPropertyAttributes;
begin
  if Assigned(FInplaceEdit) and (FCurrent >= 0) then
  with FInplaceEdit, Editor do
  begin
    if CallActivate then Activate;
    MaxLength := GetEditLimit;
    Attr := GetAttributes;
    ReadOnly := paReadOnly in Attr;
    FAutoUpdate := paAutoUpdate in Attr;
    Text := GetPrintableValue(FCurrent);
    SelectAll;
    Modified := False;
  end;
end;

function TZPropList.UpdateText(Exiting: Boolean): Boolean;
begin
  Result := True;
  if not FInUpdate and Assigned(FInplaceEdit) and
    (FCurrent >= 0) and (FInplaceEdit.Modified) then
  begin
    FInUpdate := True;
    try
      SetValue(FCurrent, FInplaceEdit.Text);
    except
      Result := False;
      FTracking := False;
      ShowErrorEx(Exception(ExceptObject).Message); 
    end;
    if Exiting then UpdateEditor(False);
    Invalidate;            // repaint all dependent properties
    FInUpdate := False;
  end;
end;

procedure TZPropList.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  FHitTest := ScreenToClient(SmallPointToPoint(Msg.Pos));
end;

function TZPropList.VertLineHit(X: Integer): Boolean;
begin
  Result := Abs(X - FVertLine) < 3;
end;

function TZPropList.ButtonHit(X: Integer): Boolean;
begin
// whether we hit collapse/expand button next to property with subproperties
  if FCurrent >= 0 then
  begin
    Dec(X, FEditors[FCurrent].peIdent * 10);
    Result := (X > 0) and (X < 12);
  end
  else
    Result := False;
end;

procedure TZPropList.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TZPropList.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
begin
  Cur := 0;
  if (Msg.HitTest = HTCLIENT) and VertLineHit(FHitTest.X) then
    Cur := Screen.Cursors[crSizeWE];
  if Cur <> 0 then SetCursor(Cur) else inherited;
end;

procedure TZPropList.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  Msg.Result := Integer(FDividerHit or VertLineHit(Msg.XPos));
end;

function TZPropList.YToRow(Y: Integer): Integer;
begin
  Result := FTopRow + Y div FRowHeight;
end;

procedure TZPropList.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if not (csDesigning in ComponentState) and
    (CanFocus or (GetParentForm(Self) = nil)) then SetFocus;

  if ssDouble in Shift then DblClick
  else
  begin
    FDividerHit := VertLineHit(X) and (Button = mbLeft);
    if not FDividerHit and (Button = mbLeft) then
    begin
      if not MoveCurrent(YToRow(Y)) then Exit;
      if FNewButtons and ButtonHit(X) then NodeClicked
      else
      begin
        FTracking := True;
        FInplaceEdit.FClickTime := GetMessageTime;
      end;
    end;
  end;

  inherited;
end;

procedure TZPropList.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FDividerHit then SizeColumn(X)
  else
    if FTracking and (ssLeft in Shift) then MoveCurrent(YToRow(Y));

  inherited;
end;

procedure TZPropList.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  FDividerHit := False;
  FTracking := False;
  inherited;
end;

function TZPropList.ColumnSized(X: Integer): Boolean;
var
  NewSizingPos: Integer;
begin
  NewSizingPos := EMax(MINCOLSIZE, EMin(X, ClientWidth - MINCOLSIZE));
  Result := NewSizingPos <> FVertLine;
  FVertLine := NewSizingPos
end;

procedure TZPropList.SizeColumn(X: Integer);
begin
  if ColumnSized(X) then
  begin
    Invalidate;
    FInplaceEdit.UpdateLoc(GetEditRect);
  end;
end;

procedure TZPropList.CMCancelMode(var Msg: TMessage);
begin
  inherited;
  CancelMode;
end;

procedure TZPropList.CancelMode;
begin
  FDividerHit := False;
  FTracking := False;
end;

procedure TZPropList.WMCancelMode(var Msg: TMessage);
begin
  inherited;
  CancelMode;
end;

destructor TZPropList.Destroy;
begin
  FSelections:=nil;
  FRemoveList.Free;
  FTranslateList.Free;

  FDestroying := True;
  FHasScrollBar := False;      // disable UpdateScrollRange
  FInplaceEdit := nil;
  CurObj := nil;
  {$IFDEF Prior4}
//  FDesigner.Free;
  {$ELSE}
//  IFormDesigner(FDesigner)._Release;
  {$ENDIF}
  FEditors.Free;

  DestroyWnd;
  FFormHandle:=0;
  inherited;
end;

procedure TZPropList.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  FInplaceEdit.SetFocus;
end;

procedure TZPropList.WMMouseWheel(var Message: TWMMouseWheel);
var
  NewCurrent: Integer;
begin
  NewCurrent := FCurrent;
  with Message do begin
    if WheelDelta<0 then
      Inc(NewCurrent)
    else Dec(NewCurrent);
    Result:=1;
  end;
  MoveCurrent(NewCurrent);
end;

function TZPropList.GetName(Index: Integer): string;
var
  Ident: Integer;
begin
  with FEditors[Index]^ do
  begin
    Ident := peIdent shl 1;
    if not peNode then Inc(Ident, 2);
    Result := peEditor.GetName;
    if peNode then
      if peExpanded then Result := '- ' + Result
      else Result := '+' + Result;
    Result := StringOfChar(' ', Ident) + Result;
  end;
end;

function TZPropList.GetValue(Index: Integer): string;
begin
  Result := FEditors[Index].peEditor.GetValue;
end;

function TZPropList.GetPrintableValue(Index: Integer): string;
var
  I: Integer;
  P: PChar;
begin
  Result := GetValue(Index);
  UniqueString(Result);
  P := Pointer(Result);
  for I := 0 to Length(Result) - 1 do
  begin
    if P^ < #32 then P^ := '.';
    Inc(P);
  end;
end;

procedure TZPropList.DoEdit(E: TPropertyEditor; DoEdit: Boolean; const Value: string);
var
  CanChange: Boolean;
  isCollapse: Boolean;
  OldValue: String;
begin
  CanChange := True;
  if Assigned(FOnChanging) then FOnChanging(Self, E, CanChange, Value);
  if CanChange then
  begin
    OldValue:=E.Value;

    if DoEdit then
      E.Edit
    else
      E.SetValue(Value);

    isCollapse:=not AnsiSameText(OldValue,E.Value);

    if isCollapse then
      if FEditors[FCurrent].peExpanded then NodeClicked; // collapse modified prop
      
    if Assigned(FOnChange) then FOnChange(Self, E);
  end;
end;

procedure TZPropList.SetValue(Index: Integer; const Value: string);
begin

  DoEdit(FEditors[Index].peEditor, False, Value);

end;

procedure TZPropList.SetValueColor(Value: TColor);
begin
  if FValueColor <> Value then
  begin
    FValueColor := Value;
    Invalidate;
  end;
end;

procedure TZPropList.SetSubPropertyColor(Value: TColor);
begin
  if FSubPropertyColor <> Value then
  begin
    FSubPropertyColor := Value;
    Invalidate;
  end;
end;

procedure TZPropList.SetReferenceColor(Value: TColor);
begin
  if FReferenceColor <> Value then
  begin
    FReferenceColor := Value;
    Invalidate;
  end;
end;

function TZPropList.GetPropType: TZPropType;
var
  Attr: TPropertyAttributes;
begin
  Result := ptSimple;
  if (FCurrent >= 0) and (FCurrent < FPropCount) then
  begin
    Attr := Editor.GetAttributes;
    if paValueList in Attr then Result := ptPickList
    else
      if paDialog in Attr then Result := ptEllipsis;
  end;
end;

function TZPropList.GetParentPersistent(Ident,Pos: Integer): TPersistent;
var
  i: Integer;
  E: PZEditor;
begin
  Result:=TPersistent(FCurObj);
  for i:=Pos downto 0 do begin
    E:=FEditors[i];
    if E.peIdent<Ident then begin
      Result:=E.peEditor.GetComponent(0);
      exit;
    end;
  end;
end;

procedure TZPropList.PropEnumProc(Prop: TPropertyEditor);
var
  P: PZEditor;
  tmps: string;
  isAdd: Boolean;
  i: Integer;
  isMulti: Boolean;
begin
  tmps:=Prop.GetName;

  isAdd:=true;
  isMulti:=paMultiSelect in Prop.GetAttributes;
  if FSelections.Count>0 then begin
    for i:=0 to FSelections.Count-1 do begin
      isAdd:=not InListRemove(tmps,TPersistent(FSelections.Items[i]).ClassType);
      if FSelections.Count>1 then
        isAdd:=isAdd and isMulti;
      if not isAdd then exit;
    end;
  end else begin
    isAdd:=not InListRemove(tmps,Prop.GetComponent(0).ClassType);
    if not isAdd then exit;
  end;

  if isAdd then begin
   New(P);
   FillChar(P^,SizeOf(P^),0);
   P.peRealName:=TranslateName(tmps);
   P.peEditor := Prop;
   P.peIdent := FCurrentIdent;
   P.peExpanded := False;
   P.peNode := paSubProperties in Prop.GetAttributes;
   FEditors.Insert(FCurrentPos, P);
   P.peParent:=GetParentPersistent(FCurrentIdent,FCurrentPos);
   Inc(FCurrentPos);
  end;
end;

procedure TZPropList.Edit;
begin
  DoEdit(Editor, True, '');
  UpdateEditor(False);
  Invalidate;            // repaint all dependent properties
end;

procedure TZPropList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  NCH: Integer;
begin
  if FIntegralHeight and (FRowHeight > 0) then
  begin
    NCH := Height - ClientHeight;
    AHeight := ((AHeight - NCH) div FRowHeight) * FRowHeight + NCH;
  end;
  inherited;
end;

procedure TZPropList.SetIntegralHeight(const Value: Boolean);
begin
  if FIntegralHeight <> Value then
  begin
    FIntegralHeight := Value;
    {$IFDEF Prior4}
    Parent.Realign;
    {$ELSE}
    AdjustSize;
    {$ENDIF}
  end;
end;

{$IFDEF Post4}
const
  Styles: array[TScrollBarStyle] of Integer = (FSB_REGULAR_MODE,
    FSB_ENCARTA_MODE, FSB_FLAT_MODE);
{$ENDIF}

procedure TZPropList.DestroyWnd;
begin
 if not isCreateWnd then exit;
  if (FFormHandle <> 0) then
  begin
    SetWindowLong(FFormHandle, GWL_WNDPROC, Integer(FDefFormProc));
    FFormHandle := 0;
    isCreateWnd:=false;
  end;
  inherited;
end;

procedure TZPropList.CreateWnd;
begin
  inherited;
  {$IFDEF Post4}
  ShowScrollBar(Handle, SB_BOTH, False);
  InitializeFlatSB(Handle);
  FlatSB_SetScrollProp(Handle, WSB_PROP_VSTYLE,
    Styles[FScrollBarStyle], False);
  {$ENDIF}

  if not (csDesigning in ComponentState) then
  begin
    FFormHandle := GetParentForm(Self).Handle;
    if FFormHandle <> 0 then
      FDefFormProc := Pointer(SetWindowLong(FFormHandle, GWL_WNDPROC,
        Integer(MakeObjectInstance(FormWndProc))));
  end;
  isCreateWnd:=true;
end;

procedure TZPropList.FormWndProc(var Message: TMessage);
begin
  with Message do
  begin
    if (Msg = WM_NCLBUTTONDOWN) or (Msg = WM_LBUTTONDOWN) then
      FInplaceEdit.FListButton.CloseUp(False);
    if FFormHandle<>0 then
     Result := CallWindowProc(FDefFormProc, FFormHandle, Msg, WParam, LParam);
  end;
end;

procedure TZPropList.SetFilter(const Value: TTypeKinds);
begin
  if FFilter <> Value then
  begin
    FFilter := Value;
    ChangeCurObj(FCurObj);
  end;
end;

procedure TZPropList.CMCtl3DChanged(var Message: TMessage);
begin
  RecreateWnd;
  inherited;
end;

procedure TZPropList.DblClick;
begin
  inherited;
  NodeClicked;
end;

procedure TZPropList.NodeClicked;
var
  Index, CurIdent, AddedCount, NewTop: Integer;
begin
// Expand|collapse node subproperties
  if (FCurrent >= 0) and (FEditors[FCurrent].peNode) then
    with FEditors[FCurrent]^ do
  begin
    if peExpanded then
    begin
      Index := FCurrent + 1;
      CurIdent := peIdent;
      while (Index < FEditors.Count) and
        (FEditors[Index].peIdent > CurIdent) do
      begin
        FEditors.DeleteEditor(Index);
        FEditors.Delete(Index);
      end
    end
    else
    begin
      FCurrentIdent := peIdent + 1;
      FCurrentPos := FCurrent + 1;
      try
        Editor.GetProperties(PropEnumProc);
      except
      end;
    end;

    peExpanded := not peExpanded;
    AddedCount := FEditors.Count - FPropCount;
    FPropCount := FEditors.Count;
    if AddedCount > 0 then  // Bring expanded properties in view
    begin
      Dec(AddedCount, VisibleRowCount - 1);
      if AddedCount > 0 then AddedCount := 0;
      NewTop := FCurrent + AddedCount;
      if NewTop > FTopRow then MoveTop(NewTop);
    end
{    else
      if AddedCount = 0 then peNode := False};
    Invalidate;
    UpdateScrollRange;
  end;
end;

function TZPropList.Editor: TPropertyEditor;
begin
  Result := FEditors[FCurrent].peEditor;
end;


procedure TZPropList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and not FDestroying then
  begin
    if AComponent = FCurObj then CurObj := nil;
  end;
end;

{$IFNDEF Delphi2}
procedure TZPropList.CMHintShow(var Msg: TCMHintShow);
var
  Row, W: Integer;
  S: string;
{$IFDEF Delphi5}
  W2: Integer;
{$ENDIF}  
begin
  with Msg, HintInfo^ do
  begin
    Result := 1;
    Row := YToRow(CursorPos.Y);
    if (CursorPos.X > FVertLine) and (Row < FPropCount) then
    begin
      S := GetValue(Row);
      CursorRect := GetValueRect(Row);
      if Pos(#10, S) > 0 then         // Multiline string
        W := MaxInt
      else
      begin
        W := Canvas.TextWidth(S);
        {$IFDEF Delphi5}
        W2 := W;
        FEditors[Row].peEditor.ListMeasureWidth(S, Canvas, W2);
        if W2 <> W then W := W2 + 4; // add extra space in case of custom drawing
        {$ENDIF}
      end;
      
      if W >= CursorRect.Right - CursorRect.Left - 1 then
      begin
        Inc(CursorRect.Bottom);
        HintPos := ClientToScreen(
          Point(CursorRect.Left - 1, CursorRect.Top - 2));
        HintStr := S;
        if Assigned(FOnHint) then FOnHint(Self, FEditors[Row].peEditor, HintInfo);
        Result := 0;
      end;
    end;
  end;
end;
{$ENDIF}

{$IFDEF Post4}
procedure TZPropList.SetScrollBarStyle(const Value: TScrollBarStyle);
begin
  if FScrollBarStyle <> Value then
  begin
    FScrollBarStyle := Value;
    FlatSB_SetScrollProp(Handle, WSB_PROP_VSTYLE, Styles[Value], True);
  end;
end;
{$ENDIF}

procedure TZPropList.SetNewButtons(const Value: Boolean);
begin
  if FNewButtons <> Value then
  begin
    FNewButtons := Value;
    Invalidate;
  end;
end;

procedure TZPropList.SetMiddle(const Value: Integer);
begin
  SizeColumn(Value);
end;

procedure TZPropList.SetFocus;
begin
  if IsWindowVisible(Handle) then inherited SetFocus;
end;

function TZPropList.TranslateName(Value: string): string;
begin
  if FTranslated then
   Result:=FTranslateList.GetTranslate(Value)
  else
   Result:=Value;
end;

var
  TmpCurIndex: Integer=0;
{
function TZPropList.GetSortPos(Index1,Index2: Integer): Integer;
begin
  TmpCurIndex:=Index2;
  if FSorted then
   if (FEditors.Count > 1) then begin
    QuickSort(Index1, Index2 ,true);
   end;
  Result:=TmpCurIndex;
end;}

procedure TZPropList.QuickSort(L, R: Integer; WithExchange: Boolean);

 procedure ExchangeItems(Index1, Index2: Integer);
 var
  oldE: PZEditor;
 begin
  if not WithExchange then begin
   oldE:=FEditors[Index1];
   FEditors[Index1]:=FEditors[Index2];
   FEditors[Index2]:=oldE;
  end else begin
   if Index1=TmpCurIndex then
     TmpCurIndex:=Index2;
  end; 
 end;

var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
{      while AnsiCompareText(TranslateName(FEditors[I].peEditor.GetName),
                            TranslateName(FEditors[P].peEditor.GetName)) < 0 do Inc(I);
      while AnsiCompareText(TranslateName(FEditors[J].peEditor.GetName),
                            TranslateName(FEditors[P].peEditor.GetName)) > 0 do Dec(J);}
      while AnsiCompareText(FEditors[I].peRealName,FEditors[P].peRealName) < 0 do Inc(I);
      while AnsiCompareText(FEditors[J].peRealName,FEditors[P].peRealName) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J,WithExchange);
    L := I;
  until I >= R;
end;

procedure TZPropList.Sort(FromIndex,ToIndex: Integer);
begin
  if FSorted then
   if (FEditors.Count > 1) then begin
    QuickSort(FromIndex, ToIndex ,false);
  end;
end;

procedure TZPropList.SetSorted(Value: Boolean);
begin
  FSorted:=Value;
  Sort(0,FEditors.Count-1);
end;

procedure TZPropList.Resize;
var
  OldM: Integer;
begin
  OldM:=Middle;
  inherited;
  Middle:=OldM;
end;


{ TZFormDesigner }

constructor TZFormDesigner.Create(APropList: TZPropList);
begin
  inherited Create;
  FPropList := APropList;
end;

function TZFormDesigner.CreateComponent(ComponentClass: TComponentClass;
  Parent: TComponent; Left, Top, Width, Height: Integer): TComponent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

function TZFormDesigner.CreateMethod(const Name: string;
  TypeData: PTypeData): TMethod;
begin
{ CreateMethod is the abstract prototype of a method that creates an event
  handler. Call CreateMethod to add an event handler to the unit of the object
  returned by the GetRoot method. Allocate a TTypeData structure and fill in
  the MethodKind, ParamCount, and ParamList fields. The event handler gets the
  name specified by the Name parameter and the type specified by the TypeData
  parameter. CreateMethod returns a method pointer to the new event handler }
  Result.Code := nil;
  Result.Data := nil;
end;

{$IFDEF Post4}
function TZFormDesigner.GetAncestorDesigner: IFormDesigner;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

procedure TZFormDesigner.GetProjectModules(Proc: TGetModuleProc);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.IsSourceReadOnly: Boolean;
begin
// Not used by TPropertyEditor
  Result := True;
end;

function TZFormDesigner.GetCustomForm: TCustomForm;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

procedure TZFormDesigner.SetCustomForm(Value: TCustomForm);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.GetIsControl: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

procedure TZFormDesigner.SetIsControl(Value: Boolean);
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.AddToInterface(InvKind: Integer;
  const Name: string; VT: Word; const TypeInfo: string);
begin
// Not used by TPropertyEditor
end;
{$ENDIF}

function TZFormDesigner.GetComponent(const Name: string): TComponent;
begin
{ GetComponent is the abstract prototype for a method that returns the
  component with the name passed as a parameter. Call GetComponent to access a
  component given its name. If the component is not in the current root object,
  the Name parameter should include the name of the entity in which it resides }
  Result := nil;
end;

function TZFormDesigner.GetComponentName(Component: TComponent): string;
begin
{ GetComponentName is the abstract prototype of a method that returns the name
  of the component passed as its parameter. Call GetComponentName to obtain the
  name of a component. This is the inverse of GetComponent }
  if Assigned(Component) then
    Result := Component.Name
  else
    Result := '';
end;

procedure TZFormDesigner.GetComponentNames(TypeData: PTypeData;
  Proc: TGetStrProc);
begin
{ GetComponentNames is the abstract prototype of a method that implements a
  callback for every component that can be assigned a property of a specified
  type. Use GetComponentNames to call the procedure specified by the Proc
  parameter for every component that can be assigned a property that matches
  the TypeData parameter. For each component, Proc is called with its S
  parameter set to the name of the component. This parameter can be used to
  obtain a reference to the component by calling the GetComponent method } 
end;

{$IFNDEF Delphi2}
function TZFormDesigner.GetIsDormant: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

function TZFormDesigner.HasInterface: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

function TZFormDesigner.HasInterfaceMember(const Name: string): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

function TZFormDesigner.GetObject(const Name: string): TPersistent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

function TZFormDesigner.GetObjectName(Instance: TPersistent): string;
begin
// Not used by TPropertyEditor
  Result := 'IFormDesigner.GetObjectName';
end;

procedure TZFormDesigner.GetObjectNames(TypeData: PTypeData;
  Proc: TGetStrProc);
begin
// Not used by TPropertyEditor
end;
{$ENDIF}

function TZFormDesigner.GetMethodName(const Method: TMethod): string;
var
  Instance: TComponent;
begin
{ GetMethodName is the abstract prototype of a method that returns the name of
  a specified event handler. Call GetMethodName to obtain the name of an event
  handler given a pointer to it }
  Instance := Method.Data;
  if Assigned(Instance) then
    Result := Instance.Name + '.' + Instance.MethodName(Method.Code)
  else
    Result := '';
end;

procedure TZFormDesigner.GetMethods(TypeData: PTypeData;
  Proc: TGetStrProc);
begin
{ GetMethods is the abstract prototype of a method that implements a callback
  for every method of a specified type.
  Use GetMethods to call the procedure specified by the Proc parameter for every
  event handler that matches the TypeData parameter. For each event handler,
  Proc is called with its S parameter set to the name of the method. This
  parameter can be used to bring up a code editor for the method by calling the
  ShowMethod method }
end;

function TZFormDesigner.GetPrivateDirectory: string;
begin
// Not used by TPropertyEditor
  Result := '';
end;

function TZFormDesigner.GetRoot: TComponent;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

{$IFDEF Prior4}
procedure TZFormDesigner.GetSelections(List: TComponentList);
{$ELSE}
procedure TZFormDesigner.GetSelections(const List: IDesignerSelections);
{$ENDIF}
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.IsComponentLinkable(
  Component: TComponent): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

function TZFormDesigner.IsDesignMsg(Sender: TControl;
  var Message: TMessage): Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

procedure TZFormDesigner.MakeComponentLinkable(Component: TComponent);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.MethodExists(const Name: string): Boolean;
begin
{ MethodExists is the abstract prototype for a method that indicates whether
  an event handler with a specified name already exists.
  Call MethodExists to determine whether an event handler with a given name
  has already been created. If MethodExists returns True, the specified event
  handler exists and can be displayed by calling the ShowMethod method. If
  MethodExists returns False, the specified event handler does not exist, and
  can be created by calling the CreateMethod method }
  Result := False;
end;

function TZFormDesigner.MethodFromAncestor(const Method: TMethod): Boolean;
begin
// Not used by TPropertyEditor
  Result := True;
end;

procedure TZFormDesigner.Modified;
begin
{ The Modified method notifes property and component editors when a change
  is made to a component. }
  FPropList.MarkModified;
end;

{$IFDEF Delphi3}
procedure TZFormDesigner.AddInterfaceMember(const MemberText: string); 
begin
// Not used by TPropertyEditor
end;
{$ENDIF}

{$IFDEF Prior4}
procedure TZFormDesigner.Notification(AComponent: TComponent; Operation: TOperation);
{$ELSE}
procedure TZFormDesigner.Notification(AnObject: TPersistent;
  Operation: TOperation);
{$ENDIF}
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.PaintGrid;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.RenameMethod(const CurName, NewName: string);
begin
{ RenameMethod is the abstract prototype for a method that renames an existing
  event handler.
  Call RenameMethod to provide an event handler with a new name. The CurName
  parameter specifies the current name of the event handler, and the NewName
  parameter specifies the value that the name should be changed to }
end;

procedure TZFormDesigner.Revert(Instance: TPersistent;
  PropInfo: PPropInfo);
begin
// Used by TPropertyEditor, but not called from TZPropList component
end;

procedure TZFormDesigner.SelectComponent(Instance: {$IFDEF Delphi2}TComponent{$ELSE}TPersistent{$ENDIF});
begin
// Not used by TPropertyEditor
end;

{$IFDEF Prior4}
procedure TZFormDesigner.SetSelections(List: TComponentList);
{$ELSE}
procedure TZFormDesigner.SetSelections(const List: IDesignerSelections);
{$ENDIF}
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ShowMethod(const Name: string);
begin
{ ShowMethod is the abstract prototype for a method that activates the code
  editor with the input cursor in a specified event handler.
  Call ShowMethod to allow the user to edit the method specified by the Name
  parameter }
end;

function TZFormDesigner.UniqueName(const BaseName: string): string;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ValidateRename(AComponent: TComponent;
  const CurName, NewName: string);
begin
// Not used by TPropertyEditor
end;

{$IFDEF Delphi5}
function TZFormDesigner.GetContainerWindow: TWinControl;
begin
// Not used by TPropertyEditor
  Result := nil;
end;

procedure TZFormDesigner.SetContainerWindow(const NewContainer: TWinControl);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.GetScrollRanges(const ScrollPosition: TPoint): TPoint;
begin
// Not used by TPropertyEditor
  Result := ScrollPosition;
end;

procedure TZFormDesigner.Edit(const Component: IComponent);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.BuildLocalMenu(Base: TPopupMenu; Filter: TLocalMenuFilters): TPopupMenu;
begin
// Not used by TPropertyEditor
  Result := Base;
end;

procedure TZFormDesigner.ChainCall(const MethodName, InstanceName, InstanceMethod: string;
  TypeData: PTypeData);
begin
{ Used internally when creating event methods that call another event handler
  inherited from a frame. ChainCall is used internally to generate the method
  call to an inherited method. Applications should not use this method }
end;

procedure TZFormDesigner.CopySelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.CutSelection;
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.CanPaste: Boolean;
begin
// Not used by TPropertyEditor
  Result := False;
end;

procedure TZFormDesigner.PasteSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.DeleteSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ClearSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.NoSelection;
begin
// Not used by TPropertyEditor
end;

procedure TZFormDesigner.ModuleFileNames(var ImplFileName, IntfFileName, FormFileName: string);
begin
// Not used by TPropertyEditor
end;

function TZFormDesigner.GetRootClassName: string;
begin
{ Returns the class name for the root component. Call GetRootClassName to
  obtain the name of the component returned by the GetRoot method }
  Result := '';
end;
{$ENDIF}

{ TTranslateList }

constructor TTranslateList.Create;
begin
  FReal:=TStringList.Create;
  FTranslate:=TStringList.Create;
end;

destructor TTranslateList.Destroy;
begin
  FReal.Free;
  FTranslate.Free;
  inherited;
end;

procedure TTranslateList.BeginUpdate;
begin
  FReal.BeginUpdate;
  FTranslate.BeginUpdate;
end;

procedure TTranslateList.EndUpdate;
begin
  FReal.EndUpdate;
  FTranslate.EndUpdate;
end;

function TTranslateList.Add(Real,Translate: string): Integer;
begin
  Result:=FReal.Add(Real);
  FTranslate.Add(Translate);
end;

function TTranslateList.GetTranslate(Real: String): String;
var
  val: Integer;
  tmps: string;
begin
  Result:=Format(TranslateNotFound,[Real]);
  val:=FReal.IndexOf(Real);
  if val<>-1 then
   tmps:=FTranslate.Strings[val];
  if Trim(tmps)<>'' then
   Result:=tmps; 
end;

function TTranslateList.GetTranslate(Index: Integer): String;
begin
  Result:='';
  if (Index>FReal.Count-1) and (Index<0) then exit;
  Result:=FTranslate.Strings[Index];  
end;

procedure TTranslateList.Clear;
begin
  FReal.Clear;
  FTranslate.Clear;
end;

function TTranslateList.GetCount: Integer;
begin
  Result:=FReal.Count;
end;


type
  TBitmapProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


{ TFontProperty }

procedure TBitmapProperty.Edit;
var
  FontDialog: TFontDialog;
begin
  FontDialog := TFontDialog.Create(Application);
  try
{    FontDialog.Font := TFont(GetOrdValue);
    FontDialog.HelpContext := hcDFontEditor;
    FontDialog.Options := FontDialog.Options + [fdShowHelp, fdForceFontExist];}
    if FontDialog.Execute then ;//SetOrdValue(Longint(FontDialog.Font));
  finally
    FontDialog.Free;
  end;
end;

function TBitmapProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

/////////////////////

procedure RegPropEdit(PropertyType: PTypeInfo; EditorClass: TPropertyEditorClass);
begin
  RegisterPropertyEditor(PropertyType, nil, '', EditorClass);
end;

initialization

// Register common property editors
  RegPropEdit(TypeInfo(string), TStringProperty);
  RegPropEdit(TypeInfo(TCaption), TCaptionProperty);
  RegPropEdit(TypeInfo(TColor), TColorProperty);
  RegPropEdit(TypeInfo(TComponentName), TComponentNameProperty);
//  RegPropEdit(TypeInfo(TComponent), TComponentProperty);
  RegPropEdit(TypeInfo(TCursor), TCursorProperty);

  RegPropEdit(TypeInfo(TDate), TDateProperty);
  RegPropEdit(TypeInfo(TDateTime), TDateTimeProperty);
  RegPropEdit(TypeInfo(TFontCharset), TFontCharsetProperty);
  RegPropEdit(TypeInfo(TImeName), TImeNameProperty);
  RegPropEdit(TypeInfo(TTime), TTimeProperty);

  RegPropEdit(TypeInfo(TFontName), TFontNameProperty);
  RegPropEdit(TypeInfo(TFont), TFontProperty);
  RegPropEdit(TypeInfo(TModalResult), TModalResultProperty);
  RegPropEdit(TypeInfo(TShortCut), TShortCutProperty);
  RegPropEdit(TypeInfo(TTabOrder), TTabOrderProperty);

  RegPropEdit(TypeInfo(TBrushStyle), TBrushStyleProperty);
  RegPropEdit(TypeInfo(Int64), TInt64Property);
  RegPropEdit(TypeInfo(TPenStyle), TPenStyleProperty);

  RegisterComponentEditor(TComponent,TDefaultEditor);

finalization
    

end.

