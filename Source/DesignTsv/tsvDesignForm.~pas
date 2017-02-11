unit tsvDesignForm;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, ELDsgnr, buttons, Menus, Commctrl, rmTVComboBox,
  ZPropLst, TypInfo, DsgnIntf, imglist, tsvDesignCore, Mask, RAHLEditor,
  UMainUnited, Db, IBCustomDataSet, IBQuery;

type

  TDesignTabControl=class;
  TDesignForm=class;
  TDesignObjInsp=class;
  TDesignScrollBox=class;

  IDesignFormDesigner=IFormDesigner;

  TDesignFormDesigner=class(TInterfacedObject,IDesignFormDesigner)

    // from IDesignerNotify
    procedure Modified;
    procedure Notification(AnObject: TPersistent; Operation: TOperation);

    // from IDesigner
    function GetCustomForm: TCustomForm;
    procedure SetCustomForm(Value: TCustomForm);
    function GetIsControl: Boolean;
    procedure SetIsControl(Value: Boolean);
    function IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;
    procedure PaintGrid;
    procedure ValidateRename(AComponent: TComponent;
      const CurName, NewName: string);
    function UniqueName(const BaseName: string): string;
    function GetRoot: TComponent;
    property IsControl: Boolean read GetIsControl write SetIsControl;
    property Form: TCustomForm read GetCustomForm write SetCustomForm;

    // from IFormDesigner
    function CreateMethod(const Name: string; TypeData: PTypeData): TMethod;
    function GetMethodName(const Method: TMethod): string;
    procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
    function GetPrivateDirectory: string;
    procedure GetSelections(const List: IDesignerSelections);
    function MethodExists(const Name: string): Boolean;
    procedure RenameMethod(const CurName, NewName: string);
    procedure SelectComponent(Instance: TPersistent);
    procedure SetSelections(const List: IDesignerSelections);
    procedure ShowMethod(const Name: string);
    procedure GetComponentNames(TypeData: PTypeData; Proc: TGetStrProc);
    function GetComponent(const Name: string): TComponent;
    function GetComponentName(Component: TComponent): string;
    function GetObject(const Name: string): TPersistent;
    function GetObjectName(Instance: TPersistent): string;
    procedure GetObjectNames(TypeData: PTypeData; Proc: TGetStrProc);
    function MethodFromAncestor(const Method: TMethod): Boolean;
    function CreateComponent(ComponentClass: TComponentClass; Parent: TComponent;
      Left, Top, Width, Height: Integer): TComponent;
    function IsComponentLinkable(Component: TComponent): Boolean;
    procedure MakeComponentLinkable(Component: TComponent);
    procedure Revert(Instance: TPersistent; PropInfo: PPropInfo);
    function GetIsDormant: Boolean;
    function HasInterface: Boolean;
    function HasInterfaceMember(const Name: string): Boolean;
    procedure AddToInterface(InvKind: Integer; const Name: string; VT: Word;
      const TypeInfo: string);
    procedure GetProjectModules(Proc: TGetModuleProc);
    function GetAncestorDesigner: IFormDesigner;
    function IsSourceReadOnly: Boolean;
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
    property IsDormant: Boolean read GetIsDormant;
    property AncestorDesigner: IFormDesigner read GetAncestorDesigner;
    property ContainerWindow: TWinControl read GetContainerWindow write SetContainerWindow;

  private
    FDSB: TDesignScrollBox;
    function Check: Boolean;
    function isVisibleComponent(AComponent: TComponent): Boolean;
//    procedure GetFuncAndProcFromEditor(str: TStringList; MethodType,Params,ResultType: string; BreakOnFirst: Boolean=false);


  end;

  TDesignCommand=(dkcNone,
                  dkcNewForm,dkcOpenForm,dkcSaveForm,dkcSaveFormsToBase,dkcCutComponents,dkcCopyComponents,
                  dkcPasteComponents,dkcDeleteComponents,dkcSelectAllComponents,
                  dkcAlignToGridComponents,dkcBringToFrontComponents,dkcSendToBackComponents,
                  dkcLocksNoDeleteComponents,dkcLocksNoMoveComponents,
                  dkcLocksNoResizeComponents,dkcLocksNoInsertInComponents,
                  dkcLocksNoCopyComponents,dkcLocksClerComponents,dkcViewObjInsp,
                  dkcViewAlignPalette,dkcViewTabOrder,dkcViewOptions,
                  dkcShowPopup,dkcViewScript,dkcRunScript,dkcResetScript);

  PDesignKeyboard=^TDesignKeyboard;
  TDesignKeyboard=packed record
    Key: Word;
    Shift: TShiftState;
    Command: TDesignCommand;
  end;

  TDesignListKeyboard=class
  private
    FList: TList;
    function GetCount: Integer;
    function GetDesignKeyboard(Index: Integer): PDesignKeyboard; 
  public
    constructor Create;
    destructor Destroy;override;
    function Add(ACommand: TDesignCommand; AKey: Word; AShift: TShiftState): PDesignKeyboard;
    procedure Clear;
    procedure GetDesignKeyboardFromKey(AKey: Word; AShift: TShiftState; AList: TList);
    procedure GetDesignKeyboardFromCommand(ACommand: TDesignCommand; AList: TList);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: PDesignKeyboard read GetDesignKeyboard; 
  end;

  TOnDesignCommand=procedure (Sender: TObject; DesignCommand: TDesignCommand) of object;

  TDesignScrollBox=class(TScrollBox)
  private
    FOldCaretPos: TPoint;
    FIncMethod: Integer;
    FTempForm: TForm;
    FListMethods: TList;
    FDFD: TDesignFormDesigner;
    FDLK: TDesignListKeyboard;
    FDesignObjInsp: TDesignObjInsp;
    FListForms: TList;
    FActiveDesignForm: TDesignForm;
    FActiveDesign: Boolean;
    FCaption: TCaption;
    FLastLeft,FLastTop: Integer;
    FLastInc: Integer;
    FDesignPopupMenu: TPopupMenu;
    FDesignTabControl: TDesignTabControl;
    FOnDesignCommand: TOnDesignCommand;
    FGridVisible: Boolean;
    FGridAlign: Boolean;
    FGridXStep: Integer;
    FGridYStep: Integer;
    FGridColor: TColor;
    FHintControl: Boolean;
    FHintSize: Boolean;
    FHintMove: Boolean;
    FHintInsert: Boolean;
    FHandleClr: TColor;
    FHandleBorderClr: TColor;
    FMultySelectHandleClr: TColor;
    FMultySelectHandleBorderClr: TColor;
    FInactiveHandleClr: TColor;
    FInactiveHandleBorderClr: TColor;
    FLockedHandleClr: TColor;
    FSizeHandle: Integer;
    FVisibleComponentCaption: Boolean;

    FOnChange: TNotifyEvent;

    FEditor: TRAHLEditor;
    FCreateInterfaceProcName: string;

    procedure MiOnClick(Sender: TObject);
    procedure SetDesignTabControl(Value: TDesignTabControl);
    procedure SetDesignObjInsp(Value: TDesignObjInsp);
    procedure SetDesignPopupMenu(Value: TPopupMenu);
    procedure SetActiveDesign(Value: Boolean);
    procedure SetRangeScrollBar(X,Y: Integer);
    procedure SetDefaultKeyBoard;
    procedure SetGridVisible(Value: Boolean);
    procedure SetGridAlign(Value: Boolean);
    procedure SetGridXStep(Value: Integer);
    procedure SetGridYStep(Value: Integer);
    procedure SetGridColor(Value: TColor);
    procedure SetHintControl(Value: Boolean);
    procedure SetHintSize(Value: Boolean);
    procedure SetHintMove(Value: Boolean);
    procedure SetHintInsert(Value: Boolean);
    procedure SetHandleClr(Value: TColor);
    procedure SetHandleBorderClr(Value: TColor);
    procedure SetMultySelectHandleClr(Value: TColor);
    procedure SetMultySelectHandleBorderClr(Value: TColor);
    procedure SetInactiveHandleClr(Value: TColor);
    procedure SetInactiveHandleBorderClr(Value: TColor);
    procedure SetLockedHandleClr(Value: TColor);
    procedure SetSizeHandle(Value: Integer);
    procedure SetVisibleComponentCaption(Value: Boolean);
    procedure SetEditor(Value: TRAHLEditor);
    procedure PackMethod(P: Pointer);
    procedure PackEndUnit;
    procedure SetRealScrollBoxRange;


  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

    procedure DoChange(Sender: TObject);
    function GetFormByName(inName: string): TForm;
    function ifExistsFormByName(inName: string): Boolean;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFileDesignFormWithDialog;
    procedure SaveToFileDesignFormWithDialog;

    procedure ClearListForms;
    function CreateDesignForm(View: Boolean=true): TDesignForm;
    function CreateDesignFormStream(Stream: TStream): TDesignForm;

    procedure CutComponents;
    procedure CopyComponents;
    procedure PasteComponents;
    procedure DeleteComponents;
    procedure SelectAllComponents;
    procedure AlignToGridComponents;
    procedure BringToFrontComponents;
    procedure SendToBackComponents;
    procedure LockComponents(LockMode: TELDesignerLockMode);
    function GetLockComponents: TELDesignerLockMode;
    function isSelectedControls: Boolean;
    procedure ShowPopup;
    procedure AddComponentEditors;
    procedure RunDesignCommand(Sender: TObject; DesingCommand: TDesignCommand);
    procedure ClearListMethods;
    procedure RemoveListMethod(P: Pointer);
    procedure SetMethodPropByInfo(P: Pointer; M: TMethod);

    function AddToListMethods(Name,MethodKind,Params,ResultType: string): Pointer;
    procedure FillListMethodsFromEditor;
    function GetMethodKindName(MethodKind: TMethodKind; var isResult: Boolean): string;
    function GetMethodParams(TypeData: PTypeData; var MethodKind,Params,ResultType: string): string;
    function GetMethodName(Method: TMethod): string;
    function GetInfoMethod(Name: string): Pointer;
    procedure GetListMethods;
    procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
    procedure GetMethodsToStrings(TypeData: PTypeData; str: TStringList);
    function MethodExists(const Name: string): Boolean;
    function CreateMethod(const Name: string; TypeData: PTypeData): TMethod;
    procedure CreateMethodByLine(Line: Integer; P: Pointer);
    procedure ShowMethod(const Name: string);
    procedure RenameMethod(const CurName, NewName: string);
    function GetMethodSourcePosInHeader(P: Pointer; var PosType,PosName,PosParams,PosResult: Integer;
                                                     var LType,LName,LParams,LResult: Integer): Boolean;

    function GetMethodSourcePosInBody(P: Pointer; var PosType,PosName,PosParams,PosResult,PosBegin,PosEnd: Integer;
                                                   var LType,LName,LParams,LResult,LBegin,LEnd: Integer): Boolean;

    function GetSourcePosByInfoMethod(P: Pointer): Integer;
    procedure PackMethods;

    property ActiveDesignForm: TDesignForm read FActiveDesignForm;
    property ActiveDesign: Boolean read FActiveDesign write SetActiveDesign;
    property DesignPopupMenu: TPopupMenu read FDesignPopupMenu write SetDesignPopupMenu;
    property DesignTabControl: TDesignTabControl read FDesignTabControl write SetDesignTabControl;
    property DesignObjInsp: TDesignObjInsp read FDesignObjInsp write SetDesignObjInsp;
    property Caption: TCaption read FCaption write FCaption;
    property ListForms: TList read FListForms;
    property DesignListKeyboard: TDesignListKeyboard read FDLK;
    property OnDesignCommand: TOnDesignCommand read FOnDesignCommand write FOnDesignCommand;
    property GridVisible: Boolean read FGridVisible write SetGridVisible;
    property GridAlign: Boolean read FGridAlign write SetGridAlign;
    property GridXStep: Integer read FGridXStep write SetGridXStep;
    property GridYStep: Integer read FGridYStep write SetGridYStep;
    property GridColor: TColor read FGridColor write SetGridColor;
    property HintControl: Boolean read FHintControl write SetHintControl;
    property HintSize: Boolean read FHintSize write SetHintSize;
    property HintMove: Boolean read FHintMove write SetHintMove;
    property HintInsert: Boolean read FHintInsert write SetHintInsert;
    property HandleClr: TColor read FHandleClr write SetHandleClr;
    property HandleBorderClr: TColor read FHandleBorderClr write SetHandleBorderClr;
    property MultySelectHandleClr: TColor read FMultySelectHandleClr write SetMultySelectHandleClr;
    property MultySelectHandleBorderClr: TColor read FMultySelectHandleBorderClr write SetMultySelectHandleBorderClr;
    property InactiveHandleClr: TColor read FInactiveHandleClr write SetInactiveHandleClr;
    property InactiveHandleBorderClr: TColor read FInactiveHandleBorderClr write SetInactiveHandleBorderClr;
    property LockedHandleClr: TColor read FLockedHandleClr write SetLockedHandleClr;
    property SizeHandle: Integer read FSizeHandle write SetSizeHandle;
    property VisibleComponentCaption: Boolean read FVisibleComponentCaption write SetVisibleComponentCaption;
    property Editor: TRAHLEditor read FEditor write SetEditor;
    property CreateInterfaceProcName: String read FCreateInterfaceProcName write FCreateInterfaceProcName;

    property OnChange: TNotifyEvent read FOnChange write FOnChange; 
  end;

  TDesignForm = class(TForm)
  private
    FAPersistentForced: TPersistent;
    FOperationForced: TOperation;

    FChangeFlag: Boolean;
    FLastFileName: String;
    FDesignScrollBox: TDesignScrollBox;
    FELDesigner: TELDesigner;
    FReaderOnErrorHandled: Boolean;
    ReaderPBH: THandle;
    FEnabledAdjust: Boolean;
//    CurFilerProcString: string;

    procedure ELDesignerControlInserting(Sender: TObject; var AComponentClass: TComponentClass);
    procedure ELDesignerControlInserted(Sender: TObject);
    procedure ELDesignerOnNotification(Sender: TObject;
                                       AnObject: TPersistent; Operation: TOperation);
    procedure ELDesignerOnModified(Sender: TObject);
    procedure ELDesignerOnChangeSelection(Sender: TObject);
    procedure ELDesignerOnDesignFormClose(Sender: TObject; var Action: TCloseAction);
    procedure ELDesignerOnKeyDown(Sender: TObject; var Key: Word;
                                  Shift: TShiftState);
    procedure ELDesignerGetDesignComponentGlyph(Sender: TObject;
                 AClass: TClass; var Glyph: TBitmap);
    procedure FELDesignerOnSetDesignComponent(Sender: TObject; AComponent: TComponent);
    procedure FELDesignerOnDblClick(Sender: TObject);

    procedure RemoveSelfLinks;
    procedure WriterOnFindAncestor(Writer: TWriter; Component: TComponent;
                   const Name: string; var Ancestor, RootAncestor: TComponent);
    procedure ReaderOnCreateComponent(Reader: TReader;
                   ComponentClass: TComponentClass; var Component: TComponent);
    procedure ReaderOnError(Reader: TReader; const Message: string;
                    var Handled: Boolean);
    procedure ReaderOnFindMethod(Reader: TReader; const MethodName: string; var Address: Pointer; var Error: Boolean);
    procedure ReaderOnReferenceName(Reader: TReader; var Name: string);
    procedure ReaderOnAncestorNotFound(Reader: TReader; const ComponentName: string;
                                       ComponentClass: TPersistentClass; var Component: TComponent);
    procedure ReaderOnSetName(Reader: TReader; Component: TComponent;  var Name: string);

    procedure FillFromRoot(wt: TWinControl);
    procedure ForcedNotification(APersistent: TPersistent; Operation: TOperation);
{    procedure ReaderProc(Reader: TReader);
    procedure WriterProc(Writer: TWriter);}
    procedure SetChangeFlag(Value: Boolean);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMIconEraseBkgnd(var Message: TWMIconEraseBkgnd); message WM_ICONERASEBKGND;
    procedure WMNCCreate(var Message: TWMNCCreate);message WM_NCCREATE;
    procedure WMMDIActivate(var Message: TWMMDIActivate);message WM_MDIACTIVATE;
    procedure WMPaint(var Message: TWMPaint);message WM_PAINT;
    procedure WMClose(var Message: TWMClose);message WM_CLOSE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;

    procedure DoClose(var Action: TCloseAction); override;
    procedure Resizing(State: TWindowState);override;
    procedure Activate; override;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Click;override;
    procedure DefineProperties(Filer: TFiler);override;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(FileName: String);
    procedure SaveToFile(FileName: String);
    function LoadFromFileWithDialog: Boolean;
    function SaveToFileWithDialog: Boolean;

    procedure ViewComponent(ct: TComponent; isClear: Boolean=false);
    property ELDesigner: TELDesigner read FELDesigner;
    property ChangeFlag: Boolean read FChangeFlag write SetChangeFlag;
  published
    property EnabledAdjust: Boolean read FEnabledAdjust write FEnabledAdjust;
  end;

  TDesignSpeedButton=class(TSpeedButton)
  private
    FDesignPageControl: TDesignTabControl;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Click;override;
  end;

  TDesignPageScroller=class(TPageScroller)
  private
    FDesignPageControl: TDesignTabControl;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Scroll(Shift: TShiftState; X, Y: Integer;
                     Orientation: TPageScrollerOrientation; var Delta: Integer); override;
  end;

  TComponentSpeedButton=class(TSpeedButton)
  private
    FDesignPageControl: TDesignTabControl;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    Cls: TPersistentClass;
    procedure Click;override;
    procedure Paint;override;
  end;

  TDesignTabControl=class(TCustomTabControl)
  private
    FGetComponentClass: TClass;
    FGetComponentClassBitmap: TBitmap;
    FUseFirstFill: Boolean;
    FTempInterface: TTypeInterface;
    FDesignSpeedButtonPanel: TPanel;
    FDesignButtonsPanel: TPanel;
    FDesignButtonsPanelLength: Integer;
    FDesignSpeedButton: TDesignSpeedButton;
    FDesignPageScroller: TDesignPageScroller;
    FButtons: TList;
    FNotExistsBitmap: TBitmap;
    FSorted: Boolean;
    procedure SetSorted(Value: Boolean);
    procedure SetDefaultButtonDown(Value: Boolean);
    function GetDefaultButtonDown: Boolean;
    function GetComponentClass: TComponentClass;
    function GetComponentGlyph(Cls: TClass): TBitmap;
    procedure SetDefaultBitmap(Value: TBitmap);
    procedure SetNotExistsBitmap(Value: TBitmap);
    function GetDefaultBitmap: TBitmap;
    procedure ClearButtons;
    procedure ClearTabs;
    procedure PackTabs;
    procedure FillComponentsFromIndex;
    procedure QuickSort(L, R: Integer);
    procedure SortTabs;
    procedure DesignPageScrollerScroll(Sender: TObject; Shift: TShiftState; X, Y: Integer;
                                       Orientation: TPageScrollerOrientation; var Delta: Integer);
    procedure RemoveButtonsUp;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
    procedure Change; override;
    procedure DrawTab(ATabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure ResizeControl;
    procedure GetDesignPaletteProc(PGDP: PGetDesignPalette);
    procedure GetDesignPaletteProcForGetComponentClass(PGDP: PGetDesignPalette);
    procedure FillDesignPalettes(TypeInterface: TTypeInterface);
    property DefaultButtonDown: Boolean read GetDefaultButtonDown write SetDefaultButtonDown;
    property DesignSpeedButton: TDesignSpeedButton read FDesignSpeedButton;
    property DesignSpeedButtonPanel: TPanel read FDesignSpeedButtonPanel;
    property DesignPageScroller: TDesignPageScroller read FDesignPageScroller;
    property TabHeight;
    property TabIndex;
    property Tabs;
    property DefaultBitmap: TBitmap read GetDefaultBitmap write SetDefaultBitmap;
    property NotExistsBitmap: TBitmap read FNotExistsBitmap write SetNotExistsBitmap;
    property ComponentClass: TComponentClass read GetComponentClass;
    property Sorted: Boolean read FSorted write SetSorted;
    property OnChange;
    property OnChanging;
  end;

  TtsvComboTreeView=class(TrmComboTreeView)
  private
    FDesignObjInsp: TDesignObjInsp;
    function GetSelectedNode: TTreeNode;
    procedure SetSelectedNode(Value: TTreeNode);
  public
    property SelectedNode: TTreeNode read GetSelectedNode write SetSelectedNode;
  end;

  TDesignObjInsp = class(TForm)
  private
    FDesignScrollBox: TDesignScrollBox;
    FObjTV: TtsvComboTreeView;
    FTabProp: TTabControl;
    FObjInsp: TZPropList;
    FTranslateSplitter: TSplitter;
    FTranslateMemo: TMemo;

    function GetSorted: Boolean;
    procedure SetSorted(Value: Boolean);
    function GetTranslated: Boolean;
    procedure SetTranslated(Value: Boolean);
    function GetImageList: TCustomImageList;
    procedure SetImageList(Value: TCustomImageList);
    function GenerateNodeName(Obj: TObject): string;
    procedure ObjTVOnChanged(Sender: TObject; Node: TTreeNode);
    procedure TabPropChange(Sender: TObject);
    function GetNodeFromData(Data: Pointer): TTreeNode;
    procedure ObjInspOnChange(Sender: TZPropList; Prop: TPropertyEditor);
    procedure ObjInspOnChanging(Sender: TZPropList; Prop: TPropertyEditor;
                                var CanChange: Boolean; const Value: string);
    procedure ObjInspOnHint(Sender: TZPropList; Prop: TPropertyEditor; HintInfo: PHintInfo);
    procedure ObjInspOnInitCurrent(Sender: TZPropList; const PropName: String);
    procedure LocalStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure LocalGetSiteInfo(Sender: TObject; DockClient: TControl;
                              var InfluenceRect: TRect; MousePos: TPoint;
                              var CanDock: Boolean);
    procedure LocalEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure LocalDockOver(Sender: TObject; Source: TDragDockObject;
                   X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure LocalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function ifExistsFormByName(inName: string): Boolean;
    function GetPanelHintVisible: Boolean;
    procedure SetPanelHintVisible(Value: Boolean);
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0);override;
    destructor Destroy; override;
    procedure SetObject(Obj: TObject; Flag: Boolean; NotView: Boolean=false);
    procedure RemoveObject(Obj: TObject);
    procedure GetDesignPropertyTranslateProc(PGDPT: PGetDesignPropertyTranslate);
    procedure FillDesignPropertyTranslates;
    procedure GetDesignPropertyRemoveProc(PGDPR: PGetDesignPropertyRemove);
    procedure FillDesignPropertyRemoves;
    property ImageList: TCustomImageList read GetImageList write SetImageList;
    property Translated: Boolean read GetTranslated write SetTranslated;
    property Sorted: Boolean read GetSorted write SetSorted;
    property PanelHintVisible: Boolean read GetPanelHintVisible write SetPanelHintVisible;
    property ObjInsp: TZPropList read FObjInsp;  
  end;

  function GetHintDesignCommand(ACommand: TDesignCommand; Default: string=''):String;
  function GetHintWithShortCutFromDesignCommand(DSB: TDesignScrollBox;
                ACommand: TDesignCommand; Default: string):String;
  function GetShortCutFromDesignCommand(DSB: TDesignScrollBox; ACommand: TDesignCommand): TShortCut;

type
  PInfoHintDesignCommand=^TInfoHintDesignCommand;
  TInfoHintDesignCommand=packed record
    Hint: String;
    Command: TDesignCommand;
  end;

var
  ListHintDesignCommand: TList;

const
  ConstdkcNone='Неизвестная';
  DFDInterface='interface';
  DFDImplementation='implementation';
  DFDBegin='begin';
  DFDThen='then';
  DFDend='end;';
  DFDendUnit='end.';


implementation

uses Toolwin, UDesignTsvCode, consts, rartti, tsvInterpreterCore;

{$R *.DFM}

type
  PInfoMethod=^TInfoMethod;
  TInfoMethod=packed record
    Method: TMethod;
    Name: string;
    MethodKind: string;
    Params: string;
    ResultType: string;
  end;

const

  DesignFormReadWriteSize=4096;
  DesignFormLoad='Загрузка компонетов';
  DesignFormCaption='Новая форма';
  DesignFormDialogSave='Сохранить форму <%s>?';
  DesignFormReaderError='%s'+#13+'Продолжить?';
  DesignFormDefaultExt='*.fm';
  DesignFormFilterExt='Файлы форм (*.fm)|*.fm|Файлы Delphi форм (*.dfm)|*.dfm|Все файлы (*.*)|*.*';

  DesignObjInspCaption='Инспектор объектов';
  DesignObjInspTabProp='Свойства';
  DesignObjInspTabMet='События';
  DesignObjInspCheckClassName='TComponentName';
  DesignObjInspImageIndexForm=0;
  DesignObjInspImageIndexControl=2;
  DesignObjInspImageIndexComponent=1;
  DesignObjInspInvalidEmptyName='Пустое значение недопустимо в качестве имени компонента';

  ConstdkcNewForm='Новая форма';
  ConstdkcOpenForm='Открыть форму';
  ConstdkcSaveForm='Сохранить форму';
  ConstdkcSaveFormsToBase='Сохранить форму в базу';
  ConstdkcCutComponents='Вырезать';
  ConstdkcCopyComponents='Копировать';
  ConstdkcPasteComponents='Вставить';
  ConstdkcDeleteComponents='Удалить';
  ConstdkcSelectAllComponents='Выделить все';
  ConstdkcAlignToGridComponents='Равнение по сетке';
  ConstdkcBringToFrontComponents='Переместить на верх';
  ConstdkcSendToBackComponents='Переместить вниз';
  ConstdkcLocksNoDeleteComponents='Нельзя удалить';
  ConstdkcLocksNoMoveComponents='Нельзя передвигать';
  ConstdkcLocksNoResizeComponents='Нельзя растягивать';
  ConstdkcLocksNoInsertInComponents='Нельзя вставлять';
  ConstdkcLocksNoCopyComponents='Нельзя копировать';
  ConstdkcLocksClerComponents='Очистить блокировки';
  ConstdkcViewObjInsp='Объектный инспектор';
  ConstdkcViewAlignPalette='Панель выравнивания';
  ConstdkcViewTabOrder='Порядок перехода';
  ConstdkcViewOptions='Настройка';
  ConstdkcShowPopup='Всплывающее меню';
  ConstdkcViewScript='Показать скрипт';
  ConstdkcRunScript='Запустить скрипт';
  ConstdkcResetScript='Прервать скрипт';



{ TDesignFormDesigner }

function TDesignFormDesigner.Check: Boolean;
begin
  Result:=FDSB.FActiveDesignForm<>nil;
  if Result then
    Result:=FDSB.FActiveDesignForm.Designer<>nil;
end;

procedure TDesignFormDesigner.Modified;
begin
  if Check then begin
   FDSB.FActiveDesignForm.ChangeFlag:=true;
   FDSB.FActiveDesignForm.FELDesigner.Modified;
{   if FDSB.FDesignObjInsp<>nil then
     FDSB.FDesignObjInsp.FObjInsp.Synchronize;}
  end; 
end;

procedure TDesignFormDesigner.Notification(AnObject: TPersistent; Operation: TOperation);
begin
  if Check then
   FDSB.FActiveDesignForm.Notification(TComponent(AnObject),Operation);
end;

function TDesignFormDesigner.GetCustomForm: TCustomForm;
begin
  Result:=nil;
  if Check then
   Result:=FDSB.FActiveDesignForm.Designer.GetCustomForm;
end;

procedure TDesignFormDesigner.SetCustomForm(Value: TCustomForm);
begin
  if Check then
   FDSB.FActiveDesignForm.Designer.SetCustomForm(Value);
end;

function TDesignFormDesigner.GetIsControl: Boolean;
begin
  Result:=false;
  if Check then
   Result:=FDSB.FActiveDesignForm.Designer.GetIsControl;
end;

procedure TDesignFormDesigner.SetIsControl(Value: Boolean);
begin
  if Check then
   FDSB.FActiveDesignForm.Designer.SetIsControl(Value);
end;

function TDesignFormDesigner.IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;
begin
  Result:=false;
  if Check then
   Result:=FDSB.FActiveDesignForm.Designer.IsDesignMsg(Sender,Message);
end;

procedure TDesignFormDesigner.PaintGrid;
begin
  if Check then
   FDSB.FActiveDesignForm.Designer.PaintGrid;
end;

procedure TDesignFormDesigner.ValidateRename(AComponent: TComponent;
      const CurName, NewName: string);
begin
 if Check then
  FDSB.FActiveDesignForm.Designer.ValidateRename(AComponent,CurName,NewName);
end;

function TDesignFormDesigner.UniqueName(const BaseName: string): string;
begin
 Result:='';
 if Check then
  Result:=FDSB.FActiveDesignForm.Designer.UniqueName(BaseName);
end;

function TDesignFormDesigner.GetRoot: TComponent;
begin
 Result:=nil;
 if Check then
  Result:=FDSB.FActiveDesignForm.Designer.GetRoot;
end;

procedure TDesignFormDesigner.ShowMethod(const Name: string);
begin
  if FDSB=nil then exit;
  FDSB.ShowMethod(Name);
end;

function TDesignFormDesigner.CreateMethod(const Name: string; TypeData: PTypeData): TMethod;
begin
  if FDSB=nil then exit;
    Result:=FDSB.CreateMethod(Name,TypeData);
end;

function TDesignFormDesigner.GetMethodName(const Method: TMethod): string;
begin
  Result:='';
  if FDSB<>nil then
    Result:=FDSB.GetMethodName(Method);
end;

(*procedure TDesignFormDesigner.GetFuncAndProcFromEditor(str: TStringList; MethodType,Params,ResultType: string;
                                                       BreakOnFirst: Boolean=false);

  function LocalPrepearString(s: string): string;
  begin
    Result:=ChangeString(s,' ','');
    Result:=ChangeString(Result,#13#10,'');
  end;
  
var
  APosMethod: Integer;
  MethodName: string;
  APosParams1,APosParams2: Integer;
  APosResult: Integer;
  APosBegin: Integer;
  APosMethodName: Integer;
  Checks: string;
  tmps: string;
  lmethodtype,lresulttype,lparams: Integer;
  lmethodname,lchecks: Integer;
  lstart: Integer;
  s1: string;
  DFDBeginEx: string;
  s: string;
  t1: TTime;
  CheckNext: Boolean; 
begin
  if FDSB=nil then exit;
  if FDSB.FEditor=nil then exit;
  APosMethod:=-1;
  lstart:=0;
  MethodType:=AnsiUpperCase(LocalPrepearString(MethodType));
  lmethodtype:=Length(MethodType);
  Params:=AnsiUpperCase(LocalPrepearString(Params));
  lparams:=Length(Params);
  ResultType:=AnsiUpperCase(LocalPrepearString(ResultType));
  lresulttype:=Length(ResultType);
  Checks:=AnsiUpperCase(FDSB.FEditor.Lines.Text);
  DFDBeginEx:=AnsiUpperCase(DFDBegin);
//  t1:=Time;
  while APosMethod<>0 do begin
    APosMethod:=Pos(MethodType,Checks);
    if APosMethod>0 then begin
      lstart:=lstart+APosMethod+lmethodtype-1;
      lchecks:=Length(Checks);
      tmps:=Copy(Checks,APosMethod+lmethodtype,lchecks-APosMethod-lmethodtype);
      CheckNext:=false;
      if lparams>0 then begin
        APosParams1:=Pos(Params[1],tmps);
        CheckNext:=APosParams1>0;
      end else begin
        APosParams1:=Pos(ResultType,tmps);
        CheckNext:=APosParams1>0;
      end;
      if CheckNext then
        if (Pos(MethodType,Copy(tmps,1,APosParams1))=0) then begin
          CheckNext:=false;
          if lparams>0 then begin
            APosParams2:=Pos(Params[lparams],tmps);
            CheckNext:=APosParams2>0;
          end else begin
            APosParams2:=Pos(ResultType,tmps)-1;
            CheckNext:=APosParams2>0;
          end;

          if CheckNext then begin
            s1:=Copy(tmps,APosParams1,APosParams2-APosParams1+1);
            s1:=LocalPrepearString(s1);
            if AnsiSameText(s1,Params) then begin
              MethodName:=Copy(tmps,1,APosParams1-1);
              lmethodname:=Length(MethodName);
              APosMethodName:=lstart+APosParams1-lmethodname;
              MethodName:=LocalPrepearString(MethodName);
              tmps:=Copy(tmps,APosParams2+1,Length(tmps)-APosParams2);
              APosResult:=Pos(ResultType[lresulttype],tmps);
              if APosResult>0 then begin
                s1:=Copy(tmps,1,APosResult);
                s1:=LocalPrepearString(s1);
                if AnsiSameText(s1,ResultType) then begin
                  APosBegin:=Pos(DFDBeginEx,tmps);
                  if APosBegin>0 then begin
                   APosBegin:=lstart+APosParams2+APosBegin+Length(DFDBeginEx);
                   if MethodName<>'' then
                    if str.IndexOf(MethodName)=-1 then begin
                      MethodName:=Copy(FDSB.FEditor.Lines.Text,APosMethodName,lmethodname);
                      str.AddObject(Trim(MethodName),TObject(APosBegin));
                    end;
                    if BreakOnFirst then
                      if str.Count>0 then exit;
                  end;
                end;
              end;
            end;
          end;
        end;
      Checks:=Copy(Checks,APosMethod+lmethodtype,lchecks-APosMethod-lmethodtype);
    end;
  end;
{  s:=FormatDateTime('ss.zzz',Time-t1);
  showmessage(s);}
end;*)

procedure TDesignFormDesigner.GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
begin
 if FDSB<>nil then
   FDSB.GetMethods(TypeData,proc);
end;

procedure TDesignFormDesigner.ChainCall(const MethodName, InstanceName,
       InstanceMethod: string; TypeData: PTypeData);
begin
  ShowMessage(MethodName);
end;

function TDesignFormDesigner.MethodExists(const Name: string): Boolean;
begin
  Result:=false;
  if FDSB=nil then exit;
    Result:=FDSB.MethodExists(Name);
end;

procedure TDesignFormDesigner.RenameMethod(const CurName, NewName: string);
begin
  if FDSB=nil then exit;
  FDSB.RenameMethod(CurName,NewName);
end;

function TDesignFormDesigner.MethodFromAncestor(const Method: TMethod): Boolean;
begin
   Result:=false;
end;

procedure TDesignFormDesigner.Edit(const Component: IComponent);
begin
  //
end;

function TDesignFormDesigner.GetPrivateDirectory: string;
begin
 //
end;

function MakeIPersistentProcEx(Instance: TPersistent): IPersistent;
begin
  Result:=nil;
end;

procedure TDesignFormDesigner.GetSelections(const List: IDesignerSelections);
var
  i: Integer;
begin
  if Check then begin
    MakeIPersistentProc:=MakeIPersistentProcEx;
    for i:=0 to FDSB.FActiveDesignForm.FELDesigner.SelectedControls.Count-1 do
   //  List.Add(MakeIPersistent(FDSB.FActiveDesignForm.FELDesigner.SelectedControls[i]));
  end;   
end;

function TDesignFormDesigner.isVisibleComponent(AComponent: TComponent): Boolean;
begin
  Result:=false;
  if AComponent is TMenuItem then exit;
  Result:=true;
end;

procedure TDesignFormDesigner.SelectComponent(Instance: TPersistent);
begin
 if Check then begin
  if FDSB.FDesignObjInsp=nil then exit;
  if Instance=nil then begin
    FDSB.FActiveDesignForm.FELDesigner.SelectedControls.Clear;
    FDSB.FDesignObjInsp.FObjTV.SelectedNode:=nil;
    FDSB.FDesignObjInsp.FObjTV.Text:='';
    FDSB.FDesignObjInsp.FObjInsp.Selections.Clear;
    FDSB.FDesignObjInsp.FObjInsp.CurObj:=nil;
  end else
   if (Instance is TComponent) then begin
    FDSB.FActiveDesignForm.FELDesigner.SelectedControls.Clear;
    if isVisibleComponent(TComponent(Instance)) then
      FDSB.FActiveDesignForm.FELDesigner.SelectedControls.AddComponent(TComponent(Instance))
    else begin
      FDSB.FDesignObjInsp.SetObject(Instance,false);
    end;
   end else begin
    FDSB.FDesignObjInsp.SetObject(Instance,false);
   end;
 end;
end;

procedure TDesignFormDesigner.SetSelections(const List: IDesignerSelections);
var
  i: Integer;
  pr: TPersistent;
begin
  if Check then begin
    FDSB.FActiveDesignForm.FELDesigner.SelectedControls.Clear;
    for i:=0 to List.Count-1 do begin
      pr:=ExtractPersistent(List.Items[i]);
      if pr is TComponent then
       FDSB.FActiveDesignForm.FELDesigner.SelectedControls.AddComponent(TComponent(pr));
    end;  
  end;
end;

procedure TDesignFormDesigner.GetComponentNames(TypeData: PTypeData; Proc: TGetStrProc);
var
  j,i: Integer;
  ct: TComponent;
begin
  if not Check then exit;
  for j:=0 to FDSB.ListForms.Count-1 do begin
    for i:=0 to TComponent(FDSB.ListForms.Items[j]).ComponentCount-1 do begin
      ct:=TComponent(FDSB.ListForms.Items[j]).Components[i];
      if not (ct is TDesignComponent) then begin
       if isClassParent(ct.ClassType,TypeData.ClassType) then
         if Assigned(Proc) then begin
           if FDSB.ListForms.Items[j]=FDSB.FActiveDesignForm then Proc(ct.Name)
           else
             if ct.Owner<>nil then begin
               Proc(ct.Owner.Name+'.'+ct.Name);
             end;
         end;  
      end;
    end;
  end;  
end;

function TDesignFormDesigner.GetComponent(const Name: string): TComponent;
var
  APos: Integer;
  sOwner,sName: string;
  ctOwner: TComponent;
begin
 Result:=nil;
 if Check then begin
   APos:=Pos('.',Name);
   if APos=0 then Result:=FDSB.FActiveDesignForm.FindComponent(Name)
   else begin
     sOwner:=Copy(Name,1,APos-1);
     sName:=Copy(Name,APos+1,Length(Name)-Length(sOwner));
     ctOwner:=FDSB.GetFormByName(sOwner);
     if ctOwner<>nil then begin
       Result:=ctOwner.FindComponent(sName);
     end;
   end;
 end;  
end;

function TDesignFormDesigner.GetComponentName(Component: TComponent): string;
begin
 Result:='';
 if Check and (Component<>nil) then begin
   if Component.Owner=FDSB.FActiveDesignForm then Result:=Component.Name
   else begin
     if Component.Owner<>nil then begin
       Result:=Component.Owner.Name+'.'+Component.Name;
     end;
   end;
 end; 
end;

function TDesignFormDesigner.GetObject(const Name: string): TPersistent;
begin
  Result:=nil;
end;

function TDesignFormDesigner.GetObjectName(Instance: TPersistent): string;
begin
  Result:='';
end;

procedure TDesignFormDesigner.GetObjectNames(TypeData: PTypeData; Proc: TGetStrProc);
begin
  //
end;

function TDesignFormDesigner.CreateComponent(ComponentClass: TComponentClass;
     Parent: TComponent; Left, Top, Width, Height: Integer): TComponent;
begin
 Result:=nil;
 if Check then begin
  Result:=ComponentClass.Create(FDSB.ActiveDesignForm);
  Result.Name:=UniqueName(Result.ClassName);
  if isClassParent(ComponentClass,TControl) and
     (Parent is TWinControl) then begin
    TControl(Result).Parent:=TWinControl(Parent);
    TControl(Result).SetBounds(Left, Top, Width, Height);
    SelectComponent(Result);
  end;
 end;
end;

function TDesignFormDesigner.IsComponentLinkable(Component: TComponent): Boolean;
begin
  Result:=false;
end;

procedure TDesignFormDesigner.MakeComponentLinkable(Component: TComponent);
begin
  //
end;

procedure TDesignFormDesigner.Revert(Instance: TPersistent; PropInfo: PPropInfo);
begin
  //
end;

function TDesignFormDesigner.GetIsDormant: Boolean;
begin
  Result:=false;
end;

function TDesignFormDesigner.HasInterface: Boolean;
begin
  Result:=false;
end;

function TDesignFormDesigner.HasInterfaceMember(const Name: string): Boolean;
begin
  Result:=false;
end;

procedure TDesignFormDesigner.AddToInterface(InvKind: Integer; const Name: string;
               VT: Word; const TypeInfo: string);
begin
 //
end;

procedure TDesignFormDesigner.GetProjectModules(Proc: TGetModuleProc);
begin
end;

function TDesignFormDesigner.GetAncestorDesigner: IFormDesigner;
begin
  Result:=Self;
end;

function TDesignFormDesigner.IsSourceReadOnly: Boolean;
begin
  Result:=false;
end;

function TDesignFormDesigner.GetContainerWindow: TWinControl;
begin
 Result:=nil;
 if Check then
  Result:=FDSB.FActiveDesignForm;
end;

procedure TDesignFormDesigner.SetContainerWindow(const NewContainer: TWinControl);
begin
  //
end;

function TDesignFormDesigner.GetScrollRanges(const ScrollPosition: TPoint): TPoint;
begin
  //
end;

function TDesignFormDesigner.BuildLocalMenu(Base: TPopupMenu; Filter: TLocalMenuFilters): TPopupMenu;
begin
  Result:=Base;
end;

procedure TDesignFormDesigner.CopySelection;
begin
 if Check then
  FDSB.CopyComponents;
end;

procedure TDesignFormDesigner.CutSelection;
begin
 if Check then
  FDSB.CutComponents;
end;

function TDesignFormDesigner.CanPaste: Boolean;
begin
 Result:=false;
 if Check then
  Result:=FDSB.FActiveDesignForm.FELDesigner.CanPaste;
end;

procedure TDesignFormDesigner.PasteSelection;
begin
 if Check then
  FDSB.PasteComponents;
end;

procedure TDesignFormDesigner.DeleteSelection;
begin
 if Check then
  FDSB.DeleteComponents;
end;

procedure TDesignFormDesigner.ClearSelection;
begin
 if Check then
  FDSB.FActiveDesignForm.FELDesigner.SelectedControls.Clear;
end;

procedure TDesignFormDesigner.NoSelection;
begin
  //
end;

procedure TDesignFormDesigner.ModuleFileNames(var ImplFileName,
       IntfFileName, FormFileName: string);
begin
  //
end;

function TDesignFormDesigner.GetRootClassName: string;
begin
  Result:='';
  if Check then
   Result:=FDSB.FActiveDesignForm.ClassName;
end;


{ TDesignKeyboard }

constructor TDesignListKeyboard.Create;
begin
  FList:=TList.Create;
end;

destructor TDesignListKeyboard.Destroy;
begin
  FList.Free;
end;

procedure TDesignListKeyboard.Clear;
var
  i: Integer;
  P: PDesignKeyboard;
begin
  for i:=0 to FList.Count-1 do begin
    P:=FList.Items[i];
    Dispose(P);
  end;
  FList.Clear;
end;

function TDesignListKeyboard.Add(ACommand: TDesignCommand; AKey: Word;
               AShift: TShiftState): PDesignKeyboard;
var
  P: PDesignKeyboard;
begin
  New(P);
  P.Key:=Akey;
  P.Shift:=AShift;
  P.Command:=ACommand;
  FList.Add(P);
  Result:=P;
end;

procedure TDesignListKeyboard.GetDesignKeyboardFromKey(AKey: Word; AShift: TShiftState; AList: TList);
var
  i: Integer;
  P: PDesignKeyboard;
begin
  if AList=nil then exit;
  for i:=0 to FList.Count-1 do begin
    P:=FList.Items[i];
    if (P.Key=AKey) and (P.Shift=AShift) then
      AList.Add(P);
  end;
end;

procedure TDesignListKeyboard.GetDesignKeyboardFromCommand(ACommand: TDesignCommand; AList: TList);
var
  i: Integer;
  P: PDesignKeyboard;
begin
  if AList=nil then exit;
  for i:=0 to FList.Count-1 do begin
    P:=FList.Items[i];
    if P.Command=ACommand then
      AList.Add(P);
  end;
end;

function TDesignListKeyboard.GetCount: Integer;
begin
  Result:=FList.Count;
end;

function TDesignListKeyboard.GetDesignKeyboard(Index: Integer): PDesignKeyboard;
begin
  Result:=nil;
  if (Index>=0) or (Index<=FList.Count-1) then
    Result:=FList.Items[Index];
end;

{ TDesignScrollBox }

constructor TDesignScrollBox.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FListMethods:=TList.Create;
  FListForms:=TList.Create;
  FActiveDesignForm:=nil;
  FLastLeft:=0;
  FLastTop:=0;
  FLastInc:=10;
  FGridVisible:=true;
  FGridAlign:=true;
  FGridXStep:=8;
  FGridYStep:=8;
  FGridColor:=clBlack;
  FHintControl:=true;
  FHintSize:=true;
  FHintMove:=true;
  FHintInsert:=true;
  FHandleClr:=clBlack;
  FHandleBorderClr:=clBlack;
  FMultySelectHandleClr:=clGray;
  FMultySelectHandleBorderClr:=clGray;
  FInactiveHandleClr:=clGray;
  FInactiveHandleBorderClr:=clBlack;
  FLockedHandleClr:=clRed;
  FSizeHandle:=5;
  FDLK:=TDesignListKeyboard.Create;
  FDFD:=TDesignFormDesigner.Create;
  FDFD.FDSB:=Self;
  FTempForm:=TForm.CreateNew(Self);
  SetDefaultKeyBoard;
end;

procedure TDesignScrollBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;

procedure TDesignScrollBox.CreateWnd;
var
  i: Integer;
  fm: TDesignForm;
begin
  inherited CreateWnd;
  for i:=0 to ListForms.Count-1 do begin
    fm:=ListForms.Items[i];
    fm.Parent:=Self;
  end;
end;

destructor TDesignScrollBox.Destroy;
begin
  FTempForm.Free;
  FDFD:=nil;
  FDLK.Free;
  FActiveDesignForm:=nil;
  ClearListForms;
  FListForms.Free;
  ClearListMethods;
  FListMethods.Free;
  inherited;
end;

procedure TDesignScrollBox.ClearListMethods;
var
  i: Integer;
  P: PInfoMethod;
begin
  for i:=FListMethods.Count-1 downto 0 do begin
    P:=FListMethods.Items[i];
    RemoveListMethod(P);
  end;
  FListMethods.Clear;
end;

procedure TDesignScrollBox.SetMethodPropByInfo(P: Pointer; M: TMethod);
var
  PInfo: PInfoMethod;

  procedure SetMethodLocal(ct: TComponent);
  var
    I,Count: Integer;
    PropInfo: PPropInfo;
    PropList: PPropList;
    MOld: TMethod;
  begin
    Count := GetTypeData(ct.ClassInfo)^.PropCount;
    if Count > 0 then begin
      GetMem(PropList, Count * SizeOf(Pointer));
      try
        GetPropInfos(ct.ClassInfo, PropList);
        for I := 0 to Count - 1 do begin
          PropInfo := PropList^[I];
          if PropInfo = nil then break;
          if PropInfo.PropType^.Kind=tkMethod then begin
            MOld:=GetMethodProp(ct,PropInfo);
            if PInfo.Method.Code=MOld.Code then begin
              SetMethodProp(ct,PropInfo,M);
            end;
          end;
        end;
      finally
        FreeMem(PropList, Count * SizeOf(Pointer));
      end;
    end;
  end;

var
 i,j: Integer;
 ct: TComponent;
begin
 if P=nil then exit;
 PInfo:=PInfoMethod(P);
 for i:=0 to FListForms.Count-1 do begin
   SetMethodLocal(FListForms.Items[i]);
   for j:=0 to TWinControl(FListForms.Items[i]).ComponentCount-1 do begin
     ct:=TWinControl(FListForms.Items[i]).Components[j];
     SetMethodLocal(ct);
   end;
 end;
end;

procedure TDesignScrollBox.RemoveListMethod(P: Pointer);
var
  PInfo: PInfoMethod;
  M: TMethod;
begin
  if P=nil then exit;
  PInfo:=PInfoMethod(P);
  M.Code:=nil;
  M.Data:=nil;
  SetMethodPropByInfo(P,M);
  FListMethods.Remove(PInfo);
  Dispose(P);
end;

procedure TDesignScrollBox.ClearListForms;
var
  i: Integer;
  fm: TDesignForm;
begin
  for i:=FListForms.Count-1 downto 0 do begin
    fm:=FListForms.Items[i];
    fm.Free;
  end;
  FListForms.Clear;
end;

procedure TDesignScrollBox.DoChange(Sender: TObject);
begin
  if Assigned(FOnChange) then FOnChange(Sender);
end;

function TDesignScrollBox.GetFormByName(inName: string): TForm;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to ListForms.Count-1 do begin
    if AnsiUpperCase(TDesignForm(ListForms.Items[i]).Name)=
       AnsiUpperCase(inName) then begin
      Result:=TDesignForm(ListForms.Items[i]);
      exit;
    end;
  end;
end;

function TDesignScrollBox.ifExistsFormByName(inName: string): Boolean;
begin
  Result:=GetFormByName(inName)<>nil;
end;

function TDesignScrollBox.CreateDesignFormStream(Stream: TStream): TDesignForm;
var
  fm: TDesignForm;
  NewStyle: Longint;
  NewVisible: Boolean;
begin
  fm:=TDesignForm.Create(nil);
  fm.ParentWindow:=Handle;

  fm.FDesignScrollBox:=Self;
  fm.FELDesigner.OnChangeSelection:=nil;
  fm.FELDesigner.OnSetDesignComponent:=nil;

  fm.FELDesigner.Grid.Visible:=FGridVisible;
  fm.FELDesigner.SnapToGrid:=FGridAlign;
  fm.FELDesigner.Grid.XStep:=FGridXStep;
  fm.FELDesigner.Grid.YStep:=FGridYStep;
  fm.FELDesigner.Grid.Color:=FGridColor;
  if FHintControl then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htControl]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htControl];
  if FHintSize then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htSize]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htSize];
  if FHintMove then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htMove]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htMove];
  if FHintInsert then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htInsert]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htInsert];
  fm.FELDesigner.HandleClr:=FHandleClr;
  fm.FELDesigner.HandleBorderClr:=FHandleBorderClr;
  fm.FELDesigner.MultySelectHandleClr:=FMultySelectHandleClr;
  fm.FELDesigner.MultySelectHandleBorderClr:=FMultySelectHandleBorderClr;
  fm.FELDesigner.InactiveHandleClr:=FInactiveHandleClr;
  fm.FELDesigner.InactiveHandleBorderClr:=FInactiveHandleBorderClr;
  fm.FELDesigner.LockedHandleClr:=FLockedHandleClr;
  fm.FELDesigner.SizeHandle:=FSizeHandle;
  fm.FELDesigner.VisibleComponentCaption:=FVisibleComponentCaption;
  
  fm.FELDesigner.Active:=FActiveDesign;
  fm.FELDesigner.PopupMenu:=FDesignPopupMenu;

  fm.LoadFromStream(Stream);
  fm.FillFromRoot(fm);

  NewVisible:=fm.Visible;
  fm.FELDesigner.OnChangeSelection:=fm.ELDesignerOnChangeSelection;
  fm.FELDesigner.OnSetDesignComponent:=fm.FELDesignerOnSetDesignComponent;

  NewStyle:=GetWindowLong(fm.Handle, GWL_STYLE) or Longint(WS_POPUP);
  SetWindowLong(fm.Handle,GWL_STYLE,NewStyle);

  FListForms.Add(fm);
  if FDesignObjInsp<>nil then
   FDesignObjInsp.SetObject(fm,true);

  FActiveDesignForm:=fm;

  fm.Show;
  fm.BringToFront;
  fm.ChangeFlag:=false;
  fm.Visible:=NewVisible;

  Result:=fm;
end;

function TDesignScrollBox.CreateDesignForm(View: Boolean=true): TDesignForm;
var
  fm: TDesignForm;
  NewStyle: Longint;
begin
  fm:=TDesignForm.Create(nil);
  fm.ParentWindow:=Handle;

  if (FLastLeft+fm.Width>=Width)or
     (FLastTop+fm.Height>=Height) then begin
   FLastLeft:=0;
   FLastTop:=0;
  end;

  fm.Left:=FLastLeft;
  fm.Top:=FLastTop;
  inc(FLastLeft,FLastInc);
  inc(FLastTop,FLastInc);

  fm.FDesignScrollBox:=Self;
  fm.Caption:=DesignFormCaption;
  if View then begin
   fm.Visible:=true;
   fm.BringToFront;
  end;

  fm.FELDesigner.Grid.Visible:=FGridVisible;
  fm.FELDesigner.SnapToGrid:=FGridAlign;
  fm.FELDesigner.Grid.XStep:=FGridXStep;
  fm.FELDesigner.Grid.YStep:=FGridYStep;
  fm.FELDesigner.Grid.Color:=FGridColor;
  if FHintControl then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htControl]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htControl];
  if FHintSize then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htSize]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htSize];
  if FHintMove then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htMove]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htMove];
  if FHintInsert then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htInsert]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htInsert];
  fm.FELDesigner.HandleClr:=FHandleClr;
  fm.FELDesigner.HandleBorderClr:=FHandleBorderClr;
  fm.FELDesigner.MultySelectHandleClr:=FMultySelectHandleClr;
  fm.FELDesigner.MultySelectHandleBorderClr:=FMultySelectHandleBorderClr;
  fm.FELDesigner.InactiveHandleClr:=FInactiveHandleClr;
  fm.FELDesigner.InactiveHandleBorderClr:=FInactiveHandleBorderClr;
  fm.FELDesigner.LockedHandleClr:=FLockedHandleClr;
  fm.FELDesigner.SizeHandle:=FSizeHandle;
  fm.FELDesigner.VisibleComponentCaption:=FVisibleComponentCaption;
  


  fm.FELDesigner.Active:=FActiveDesign;
  fm.FELDesigner.PopupMenu:=FDesignPopupMenu;
  if FDesignTabControl<>nil then begin
    fm.FELDesigner.DesignComponentWidth:=FDesignTabControl.FDesignSpeedButton.Width;
  end;

  if View then begin
   NewStyle:=GetWindowLong(fm.Handle, GWL_STYLE) or Longint(WS_POPUP);
   SetWindowLong(fm.Handle,GWL_STYLE,NewStyle);
  end; 

  FListForms.Add(fm);
  if FDesignObjInsp<>nil then
     FDesignObjInsp.SetObject(fm,true);

  FActiveDesignForm:=fm;
  fm.ChangeFlag:=false;

  DoChange(fm);
  
  Result:=fm;
end;

procedure TDesignScrollBox.SetActiveDesign(Value: Boolean);
var
  i: Integer;
begin
  if Value<>FActiveDesign then begin
    FActiveDesign:=Value;
    for i:=0 to FListForms.Count-1 do
      TDesignForm(FListForms.Items[i]).FELDesigner.Active:=Value;
  end;
end;

procedure TDesignScrollBox.SetDesignObjInsp(Value: TDesignObjInsp);
begin
  FDesignObjInsp:=Value;
  if Value<>nil then begin
    FDesignObjInsp.FDesignScrollBox:=Self;
    FDesignObjInsp.FObjInsp.Designer:=FDFD;
  end;
end;

procedure TDesignScrollBox.SetRealScrollBoxRange;
var
  i: Integer;
  ct: TControl;
  maxX,maxY: Integer;
begin
  maxX:=0;
  maxY:=0;
  for i:=0 to FListForms.Count-1 do begin
    ct:=FListForms.Items[i];
    if (ct.Left+ct.Width)>maxX then MaxX:=ct.Left+ct.Width;
    if (ct.Top+ct.Height)>maxY then MaxY:=ct.Top+ct.Height;
  end;
  SetRangeScrollBar(maxX,maxY);
end;

procedure TDesignScrollBox.SetRangeScrollBar(X,Y: Integer);
begin
  HorzScrollBar.Range:=X;
  VertScrollBar.Range:=Y;  
end;

procedure TDesignScrollBox.SetDesignPopupMenu(Value: TPopupMenu);
var
  i: Integer;
begin
  if FDesignPopupMenu<>Value then begin
    FDesignPopupMenu:=Value;
    for i:=0 to FListForms.Count-1 do
      TDesignForm(FListForms.Items[i]).FELDesigner.PopupMenu:=Value;
  end;
end;

procedure TDesignScrollBox.LoadFromStream(Stream: TStream);
begin

end;

procedure TDesignScrollBox.SaveToStream(Stream: TStream);
begin

end;

procedure TDesignScrollBox.LoadFromFileDesignFormWithDialog;
var
  fm: TDesignForm;
  NewStyle: Longint;
  NewVisible: Boolean;
begin
  fm:=TDesignForm.Create(nil);
  fm.ParentWindow:=Handle;

  fm.FDesignScrollBox:=Self;
  fm.FELDesigner.OnChangeSelection:=nil;
  fm.FELDesigner.OnSetDesignComponent:=nil;

  fm.FELDesigner.Grid.Visible:=FGridVisible;
  fm.FELDesigner.SnapToGrid:=FGridAlign;
  fm.FELDesigner.Grid.XStep:=FGridXStep;
  fm.FELDesigner.Grid.YStep:=FGridYStep;
  fm.FELDesigner.Grid.Color:=FGridColor;
  if FHintControl then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htControl]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htControl];
  if FHintSize then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htSize]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htSize];
  if FHintMove then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htMove]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htMove];
  if FHintInsert then fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints+[htInsert]
  else fm.FELDesigner.ShowingHints:=fm.FELDesigner.ShowingHints-[htInsert];
  fm.FELDesigner.HandleClr:=FHandleClr;
  fm.FELDesigner.HandleBorderClr:=FHandleBorderClr;
  fm.FELDesigner.MultySelectHandleClr:=FMultySelectHandleClr;
  fm.FELDesigner.MultySelectHandleBorderClr:=FMultySelectHandleBorderClr;
  fm.FELDesigner.InactiveHandleClr:=FInactiveHandleClr;
  fm.FELDesigner.InactiveHandleBorderClr:=FInactiveHandleBorderClr;
  fm.FELDesigner.LockedHandleClr:=FLockedHandleClr;
  fm.FELDesigner.SizeHandle:=FSizeHandle;
  fm.FELDesigner.VisibleComponentCaption:=FVisibleComponentCaption;
  
  fm.FELDesigner.Active:=FActiveDesign;
  fm.FELDesigner.PopupMenu:=FDesignPopupMenu;

  if not fm.LoadFromFileWithDialog then begin
    fm.Free;
  end else begin

    NewVisible:=fm.Visible;
    fm.FELDesigner.OnChangeSelection:=fm.ELDesignerOnChangeSelection;
    fm.FELDesigner.OnSetDesignComponent:=fm.FELDesignerOnSetDesignComponent;

    NewStyle:=GetWindowLong(fm.Handle, GWL_STYLE) or Longint(WS_POPUP);
    SetWindowLong(fm.Handle,GWL_STYLE,NewStyle);

    FListForms.Add(fm);
    if FDesignObjInsp<>nil then
     FDesignObjInsp.SetObject(fm,true);

    FActiveDesignForm:=fm;

    fm.Show;
    fm.BringToFront;
    fm.ChangeFlag:=false;
    fm.Visible:=NewVisible;
  end;
end;

procedure TDesignScrollBox.SaveToFileDesignFormWithDialog;
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.SaveToFileWithDialog;
  end;
end;

procedure TDesignScrollBox.CutComponents;
begin
  if FActiveDesignForm<>nil then begin
    if FActiveDesignForm.FELDesigner.CanCut then
      FActiveDesignForm.FELDesigner.Cut;
  end;
end;

procedure TDesignScrollBox.CopyComponents;
begin
  if FActiveDesignForm<>nil then begin
    if FActiveDesignForm.FELDesigner.CanCopy then
      FActiveDesignForm.FELDesigner.Copy;
  end;
end;

procedure TDesignScrollBox.PasteComponents;
begin
  if FActiveDesignForm<>nil then begin
    if FActiveDesignForm.FELDesigner.CanPaste then
      FActiveDesignForm.FELDesigner.Paste;
  end;
end;

procedure TDesignScrollBox.DeleteComponents;
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.FELDesigner.DeleteSelectedControls;
  end;
end;

procedure TDesignScrollBox.SelectAllComponents;
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.FELDesigner.SelectedControls.SelectAll;
  end;
end;

procedure TDesignScrollBox.AlignToGridComponents;
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.FELDesigner.SelectedControls.AlignToGrid;
  end;
end;

procedure TDesignScrollBox.BringToFrontComponents;
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.FELDesigner.SelectedControls.BringToFront;
  end;
end;

procedure TDesignScrollBox.SendToBackComponents;
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.FELDesigner.SelectedControls.SendToBack;
  end;
end;

procedure TDesignScrollBox.ShowPopup;
var
  pt: TPoint;
  dx,dy: Integer;
begin
  if FActiveDesignForm<>nil then begin
    if FActiveDesignForm.FELDesigner.PopupMenu<>nil then begin
      dx:=FActiveDesignForm.ClientRect.Left;
      dy:=FActiveDesignForm.ClientRect.Top;
      pt:=Point(dx,dy);
      pt:=FActiveDesignForm.ClientToScreen(pt);
      FActiveDesignForm.FELDesigner.PopupMenu.Popup(pt.x,pt.y);
    end;  
  end;
end;

procedure TDesignScrollBox.LockComponents(LockMode: TELDesignerLockMode);
begin
  if FActiveDesignForm<>nil then begin
    FActiveDesignForm.FELDesigner.SelectedControls.Lock(LockMode);
  end;
end;

function TDesignScrollBox.GetLockComponents: TELDesignerLockMode;
begin
  Result:=[];
  if FActiveDesignForm<>nil then begin
    if FActiveDesignForm.FELDesigner.SelectedControls.Count>0 then
     Result:=FActiveDesignForm.FELDesigner.GetLockMode(
                FActiveDesignForm.FELDesigner.SelectedControls.DefaultControl);
  end;
end;

function TDesignScrollBox.isSelectedControls: Boolean;
var
  ls: TList;
begin
  Result:=false;
  ls:=TList.Create;
  try
   if FActiveDesignForm<>nil then begin
     Result:=FActiveDesignForm.FELDesigner.SelectedControls.Count>0;
   end;
  finally
    ls.Free;
  end;
end;

procedure TDesignScrollBox.SetDefaultKeyBoard;
begin
  if FDLK=nil then exit;
  FDLK.Clear;
  FDLK.Add(dkcNewForm,Ord('N'),[ssCtrl]);
  FDLK.Add(dkcOpenForm,Ord('L'),[ssCtrl]);
  FDLK.Add(dkcSaveFormsToBase,Ord('S'),[ssCtrl]);
  FDLK.Add(dkcCutComponents,Ord('X'),[ssCtrl]);
  FDLK.Add(dkcCopyComponents,Ord('C'),[ssCtrl]);
  FDLK.Add(dkcCopyComponents,VK_INSERT,[ssCtrl]);
  FDLK.Add(dkcPasteComponents,Ord('V'),[ssCtrl]);
  FDLK.Add(dkcPasteComponents,VK_INSERT,[ssShift]);
  FDLK.Add(dkcDeleteComponents,VK_DELETE,[ssCtrl]);
  FDLK.Add(dkcSelectAllComponents,Ord('A'),[ssCtrl]);
  FDLK.Add(dkcViewObjInsp,VK_F11,[]);
  FDLK.Add(dkcShowPopup,VK_F10,[ssShift]);
  FDLK.Add(dkcViewScript,VK_F12,[]);
  FDLK.Add(dkcRunScript,VK_F9,[]);
  FDLK.Add(dkcResetScript,VK_F2,[ssCtrl]);
end;

procedure TDesignScrollBox.RunDesignCommand(Sender: TObject; DesingCommand: TDesignCommand);
var
  LockMode: TELDesignerLockMode;
begin
  LockMode:=GetLockComponents;
  case DesingCommand of
    dkcNewForm: CreateDesignForm;
    dkcOpenForm: LoadFromFileDesignFormWithDialog;
    dkcSaveForm: SaveToFileDesignFormWithDialog;
    dkcCutComponents: CutComponents;
    dkcCopyComponents: CopyComponents;
    dkcPasteComponents: PasteComponents;
    dkcDeleteComponents: DeleteComponents;
    dkcSelectAllComponents: SelectAllComponents;
    dkcAlignToGridComponents: AlignToGridComponents;
    dkcBringToFrontComponents: BringToFrontComponents;
    dkcSendToBackComponents: SendToBackComponents;
    dkcLocksNoDeleteComponents:begin
      if lmNoDelete in LockMode then Exclude(LockMode,lmNoDelete)
      else Include(LockMode,lmNoDelete);
      LockComponents(LockMode);
    end;
    dkcLocksNoMoveComponents:begin
      if lmNoMove in LockMode then Exclude(LockMode,lmNoMove)
      else Include(LockMode,lmNoMove);
      LockComponents(LockMode);
    end;
    dkcLocksNoResizeComponents:begin
      if lmNoResize in LockMode then Exclude(LockMode,lmNoResize)
      else Include(LockMode,lmNoResize);
      LockComponents(LockMode);
    end;
    dkcLocksNoInsertInComponents:begin
      if lmNoInsertIn in LockMode then Exclude(LockMode,lmNoInsertIn)
      else Include(LockMode,lmNoInsertIn);
      LockComponents(LockMode);
    end;
    dkcLocksNoCopyComponents:begin
      if lmNoCopy in LockMode then Exclude(LockMode,lmNoCopy)
      else Include(LockMode,lmNoCopy);
      LockComponents(LockMode);
    end;
    dkcLocksClerComponents: LockComponents([]);
    dkcViewObjInsp:;
    dkcViewAlignPalette:;
    dkcViewTabOrder:;
    dkcViewOptions:;
    dkcShowPopup: ShowPopup;
  end;
  if Assigned(FOnDesignCommand) then
    FOnDesignCommand(Sender,DesingCommand);
end;

procedure TDesignScrollBox.DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AList: TList;
  i: Integer;
  P: PDesignKeyboard;
begin
  AList:=TList.Create;
  try
    FDLK.GetDesignKeyboardFromKey(Key,Shift,AList);
    for i:=0 to AList.Count-1 do begin
      P:=AList.Items[i];
      RunDesignCommand(Sender,P.Command);
    end;
  finally
   AList.Free;
  end;
end;

procedure TDesignScrollBox.SetDesignTabControl(Value: TDesignTabControl);
var
  i: Integer;
  fm: TDesignForm;
begin
  FDesignTabControl:=Value;
  if Value=nil then exit;
  for i:=0 to ListForms.Count-1 do begin
    fm:=ListForms.Items[i];
    fm.FELDesigner.DesignComponentWidth:=Value.FDesignSpeedButton.Width;
  end;
end;

procedure TDesignScrollBox.AddComponentEditors;
var
  pm: TPopupMenu;
  obj: TObject;
  ce :TComponentEditor;
  nCount: Integer;
  mi: TMenuItem;
  i: Integer;
begin
  if FActiveDesignForm<>nil then begin
    pm:=FActiveDesignForm.FELDesigner.PopupMenu;
    if pm=nil then exit;
    if FDesignObjInsp<>nil then begin
      obj:=FDesignObjInsp.FObjInsp.CurObj;
      if obj is TComponent then begin
       try
        ce:=GetComponentEditor(TComponent(obj),FDFD);
        nCount:=ce.GetVerbCount;
        if nCount>0 then begin
          mi:=TMenuItem.Create(Self);
          mi.Caption:='-';
          pm.Items.Insert(0,mi);
        end;
        for i:=nCount-1 downto 0 do begin
          mi:=TMenuItem.Create(nil);
          mi.Caption:=ce.GetVerb(i);
          mi.Hint:=mi.Caption;
          mi.OnClick:=MiOnClick;
          mi.Tag:=i+1;
          pm.Items.Insert(0,mi);
        end;
       except
       end; 
      end;
    end;
  end;
end;

procedure TDesignScrollBox.MiOnClick(Sender: TObject);
var
  mi: TMenuItem;
  obj: TObject;
  ce :TComponentEditor;
begin
  if not (Sender is TMenuItem) then exit;
  mi:=TMenuItem(Sender);
  if FActiveDesignForm<>nil then begin
    if FDesignObjInsp<>nil then begin
      obj:=FDesignObjInsp.FObjInsp.CurObj;
      if (obj is TComponent)then begin
       try
         ce:=GetComponentEditor(TComponent(obj),FDFD);
         ce.ExecuteVerb(mi.Tag-1);
       except
         on E: Exception do begin
           ShowMessage(E.Message);
         end;
       end;  
      end;
    end;
  end;
end;

procedure TDesignScrollBox.SetGridVisible(Value: Boolean);
var
  i: Integer;
begin
  if Value=FGridVisible then exit;
  FGridVisible:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.Grid.Visible:=Value;
end;

procedure TDesignScrollBox.SetGridAlign(Value: Boolean);
var
  i: Integer;
begin
  if Value=FGridAlign then exit;
  FGridAlign:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.SnapToGrid:=Value;
end;

procedure TDesignScrollBox.SetGridXStep(Value: Integer);
var
  i: Integer;
begin
  if Value=FGridXStep then exit;
  FGridXStep:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.Grid.XStep:=Value;
end;

procedure TDesignScrollBox.SetGridYStep(Value: Integer);
var
  i: Integer;
begin
  if Value=FGridYStep then exit;
  FGridYStep:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.Grid.YStep:=Value;
end;

procedure TDesignScrollBox.SetGridColor(Value: TColor);
var
  i: Integer;
begin
  if Value=FGridColor then exit;
  FGridColor:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.Grid.Color:=Value;
end;

procedure TDesignScrollBox.SetHintControl(Value: Boolean);
var
  i: Integer;
begin
  if Value=FHintControl then exit;
  FHintControl:=Value;
  if FHintControl then begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints+[htControl];
  end else begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints-[htControl];
  end;
end;

procedure TDesignScrollBox.SetHintSize(Value: Boolean);
var
  i: Integer;
begin
  if Value=FHintSize then exit;
  FHintSize:=Value;
  if FHintSize then begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints+[htSize];
  end else begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints-[htSize];
  end;
end;

procedure TDesignScrollBox.SetHintMove(Value: Boolean);
var
  i: Integer;
begin
  if Value=FHintMove then exit;
  FHintMove:=Value;
  if FHintMove then begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints+[htMove];
  end else begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints-[htMove];
  end;
end;

procedure TDesignScrollBox.SetHintInsert(Value: Boolean);
var
  i: Integer;
begin
  if Value=FHintInsert then exit;
  FHintInsert:=Value;
  if FHintInsert then begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints+[htInsert];
  end else begin
   for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints:=
      TDesignForm(FListForms.Items[i]).FELDesigner.ShowingHints-[htInsert];
  end;
end;

procedure TDesignScrollBox.SetHandleClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FHandleClr then exit;
  FHandleClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.HandleClr:=Value;
end;

procedure TDesignScrollBox.SetHandleBorderClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FHandleBorderClr then exit;
  FHandleBorderClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.HandleBorderClr:=Value;
end;

procedure TDesignScrollBox.SetMultySelectHandleClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FMultySelectHandleClr then exit;
  FMultySelectHandleClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.MultySelectHandleClr:=Value;
end;

procedure TDesignScrollBox.SetMultySelectHandleBorderClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FMultySelectHandleBorderClr then exit;
  FMultySelectHandleBorderClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.MultySelectHandleBorderClr:=Value;
end;

procedure TDesignScrollBox.SetInactiveHandleClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FInactiveHandleClr then exit;
  FInactiveHandleClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.InactiveHandleClr:=Value;
end;

procedure TDesignScrollBox.SetInactiveHandleBorderClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FInactiveHandleBorderClr then exit;
  FInactiveHandleBorderClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.InactiveHandleBorderClr:=Value;
end;

procedure TDesignScrollBox.SetLockedHandleClr(Value: TColor);
var
  i: Integer;
begin
  if Value=FLockedHandleClr then exit;
  FLockedHandleClr:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.LockedHandleClr:=Value;
end;

procedure TDesignScrollBox.SetSizeHandle(Value: Integer);
var
  i: Integer;
begin
  if Value=FSizeHandle then exit;
  FSizeHandle:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.SizeHandle:=Value;
end;

procedure TDesignScrollBox.SetVisibleComponentCaption(Value: Boolean);
var
  i: Integer;
begin
  if Value=FVisibleComponentCaption then exit;
  FVisibleComponentCaption:=Value;
  for i:=0 to FListForms.Count-1 do
    TDesignForm(FListForms.Items[i]).FELDesigner.VisibleComponentCaption:=Value;
end;

procedure TDesignScrollBox.SetEditor(Value: TRAHLEditor);
begin
  if Value<>FEditor then begin
   FEditor:=Value;
   FillListMethodsFromEditor;
  end; 
end;

function TDesignScrollBox.AddToListMethods(Name,MethodKind,Params,ResultType: string): Pointer;

  function PrepearParams(s: string): string;
  var
    APos: Integer;
    tmps: string;
  begin
    while true do begin
      APos:=Pos(':',s);
      if APos>0 then begin
        tmps:=Copy(s,1,Apos);
        Result:=Result+tmps+' ';
        s:=Trim(Copy(s,APos+1,Length(s)-APos));
      end else begin
        Result:=Trim(Result+s);
        exit;
      end;
    end;
  end;

  function PrepearResultType(s: string): string;
  begin

  end;

var
  P: PInfoMethod;
begin
  Result:=GetInfoMethod(Name);
  if Result<>nil then exit;
  New(P);
  FillChar(P^,Sizeof(TInfoMethod),0);
  Inc(FIncMethod);
  P.Method.Code:=Pointer(FIncMethod);
  P.Method.Data:=nil;
  P.Name:=Trim(Name);
  P.MethodKind:=Trim(MethodKind);
  P.Params:=Trim(Params);
  P.ResultType:=Trim(ResultType);
  FListMethods.Add(P);
  Result:=P;
end;

function TDesignScrollBox.GetMethodParams(TypeData: PTypeData; var MethodKind,Params,ResultType: string): string;
type
  PParamList=^TParamList;
  TParamList=record
    Flags: TParamFlags;
    ParamName: ShortString;
    TypeName: ShortString;
  end;
var
  pl,plOld: TParamList;
  tmps: ShortString;
  CurPos: Integer;
  CurSize,L: Integer;
  pref: string;
  mk: string;
  rt: ShortString;
  isResult: Boolean;
  tmpsprev: string;
begin
   Result:='';
   if TypeData=nil then exit;
   CurPos:=0;
   CurSize:=0;
   isResult:=false;
   mk:=GetMethodKindName(TypeData.MethodKind,isResult);
   while CurPos<=TypeData.ParamCount-1 do begin
    pl.Flags:=TParamFlags(TypeData.ParamList[CurSize]);
    inc(CurSize);
    L:=Byte(TypeData.ParamList[CurSize]);
    SetLength(pl.ParamName,L);
    inc(CurSize);
    Move(Pointer(@TypeData.ParamList[CurSize-1])^,pl.ParamName,L+1);
    inc(CurSize,L);
    L:=Byte(TypeData.ParamList[CurSize]);
    SetLength(pl.TypeName,L);
    inc(CurSize);
    Move(Pointer(@TypeData.ParamList[CurSize-1])^,pl.TypeName,L+1);
    inc(CurSize,L);
    if pfVar in pl.Flags then pref:='var';
    if pfConst in pl.Flags then pref:='const';
    if (AnsiUpperCase(plOld.TypeName)=AnsiUpperCase(pl.TypeName)) and
       (plOld.Flags=pl.Flags) then begin
     if CurPos=0 then begin
       // nothing
     end else begin
       tmps:=tmpsprev+', '+pl.ParamName+': '+pl.TypeName;
     end;
    end else begin
     if CurPos=0 then begin
      tmpsprev:=pref+' '+pl.ParamName;
      tmps:=tmpsprev+': '+pl.TypeName
     end else begin
      tmpsprev:=tmps+'; '+pref+' '+pl.ParamName;
      tmps:=tmpsprev+': '+pl.TypeName;
     end;
    end;
    inc(CurPos);
    Move(pl,plOld,sizeof(pl));
   end;
   if isResult then begin
     L:=Byte(TypeData.ParamList[CurSize]);
     SetLength(rt,L);
     inc(CurSize);
     Move(Pointer(@TypeData.ParamList[CurSize-1])^,rt,L+1);
     rt:=': '+rt;
   end;
   MethodKind:=mk;
   Params:='('+Trim(tmps)+')';
   rt:=rt+';';
   ResultType:=rt;
   Result:=MethodKind+' '+Params+ResultType;
end;

function TDesignScrollBox.GetMethodKindName(MethodKind: TMethodKind; var isResult: Boolean): string;
var
  mk: string;
begin
   Result:='';
   case MethodKind of
     mkProcedure: mk:='procedure';
     mkFunction: begin
       mk:='function';
       isResult:=true;
     end;
     mkConstructor: mk:='constructor';
     mkDestructor: mk:='destructor';
     mkClassProcedure: mk:='class procedure';
     mkClassFunction: begin
       mk:='class function';
       isResult:=true;
     end;
     mkSafeProcedure: mk:='safe procedure';
     mkSafeFunction: begin
       mk:='safe function';
       isResult:=true;
     end;
   end;
   Result:=mk;
end;

function TDesignScrollBox.GetMethodName(Method: TMethod): string;
var
  i: Integer;
  P: PInfoMethod;
begin
  Result:='';
  for i:=0 to FListMethods.Count-1 do begin
    P:=FListMethods.Items[i];
    if (P.Method.Code=Method.Code){and(P.Method.Data=Method.Data)} then begin
      Result:=P.Name;
      exit;
    end;
  end;
end;  

function TDesignScrollBox.GetInfoMethod(Name: string): Pointer;
var
  i: Integer;
  P: PInfoMethod;
begin
  Result:=nil;
  for i:=0 to FListMethods.Count-1 do begin
    P:=FListMethods.Items[i];
    if AnsiSameText(P.Name,Name) then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure TDesignScrollBox.GetListMethods;

  function GetPosBySet(Lines: string; soc: array of char): Integer;
  var
    APos: Integer;
    i: Integer;
  begin
    Result:=0;
    for i:=Low(soc) to High(soc) do begin
      APos:=Pos(soc[i],Lines);
      if Apos>0 then begin
        Result:=APos;
        exit;
      end;
    end;
  end;

  function GetPosByAllMethodKind(Str: string; var L: Integer): Integer;
  var
    i: TMethodKind;
    isResult: Boolean;
    MInPos: Integer;
    s: string;
  begin
    L:=0;
    MinPos:=Length(Str);
    for i:=Low(TMethodKind) to High(TMethodKind) do begin
      s:=AnsiUpperCase(GetMethodKindName(i,isResult));
      Result:=Pos(s,str);
      if Result>0 then
       if Result<MinPos then begin
         MinPos:=Result;
         L:=Length(s);
       end;
    end;
    if L>0 then
     Result:=MinPos;
  end;

var
  APosMethodKind,APosImplem: Integer;
  APosParams1,APosParams2: Integer;
  APosName: Integer;
  APosMethodEnd: Integer;
  DFDImplementationEx: string;
  lMethodKind: Integer;
  Lines: String;
  s: string;
  MethodKind,Params,ResultType: string;
begin
  if FEditor=nil then exit;
  Lines:=AnsiUpperCase(FEditor.Lines.Text);
  DFDImplementationEx:=AnsiUpperCase(DFDImplementation);
  APosImplem:=Pos(DFDImplementationEx,Lines);
  if APosImplem=0 then exit;
  Lines:=Copy(Lines,1,APosImplem-1);
  APosMethodKind:=-1;
  APosName:=0;
  while APosMethodKind<>0 do begin
    APosMethodKind:=GetPosByAllMethodKind(Lines,lMethodKind);
    if APosMethodKind>0 then begin
      MethodKind:=Copy(FEditor.Lines.Text,APosName+APosMethodKind,lMethodKind);
      APosName:=APosName+APosMethodKind+lMethodKind;
      Lines:=Copy(Lines,APosMethodKind+lMethodKind,Length(Lines)-(APosMethodKind+lMethodKind)+1);
      APosParams1:=GetPosBySet(Lines,['(']);
      if APosParams1>0 then begin
        APosParams2:=GetPosBySet(Lines,[')']);
        if APosParams2>0 then begin
         Params:=Copy(FEditor.Lines.Text,APosName+APosParams1-1,APosParams2-APosParams1+1);
         APosMethodEnd:=0;
         s:=Copy(Lines,APosParams2+1,Length(Lines)-APosParams2);
         s:=GetNextWord(s,[';'],APosMethodEnd);
         s:=Copy(Lines,APosParams2+1,APosMethodEnd+1);
         if Trim(s)<>'' then begin
          ResultType:=Copy(FEditor.Lines.Text,APosName+APosParams2,Length(s));
          s:=Copy(FEditor.Lines.Text,APosName,APosParams1-1);
          APosName:=APosName-1;
          AddToListMethods(s,MethodKind,Params,ResultType);
         end; 
        end;
      end;
    end;
  end;
end;

procedure TDesignScrollBox.GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
var
  i: Integer;
  str: TStringList;
begin
  str:=TStringList.Create;
  try
    GetMethodsToStrings(TypeData,str);
    for i:=0 to str.Count-1 do Proc(str.Strings[i]);
  finally
    str.Free;
  end;
end;

function TDesignScrollBox.CreateMethod(const Name: string; TypeData: PTypeData): TMethod;
var
  MethodKind,Params,ResultType: string;
  str: TStringList;
  isCreate: Boolean;
  APosEnd: Integer;
  APosImplem: Integer;
  X,Y: Integer;
  P: PInfoMethod;
  val: Integer;
begin
  if Trim(Name)='' then exit;
  isCreate:=false;
  P:=nil;
  str:=TStringList.Create;
  try
    GetMethodsToStrings(TypeData,str);
    val:=str.IndexOf(Name);
    if val=-1 then isCreate:=true
    else P:=PInfoMethod(str.Objects[val]);
  finally
   str.Free;
  end;

  if isCreate then begin
    APosImplem:=Pos(AnsiUpperCase(DFDImplementation),AnsiUpperCase(FEditor.Lines.Text));
    if APosImplem>0 then begin
      GetMethodParams(TypeData,MethodKind,Params,ResultType);
      P:=AddToListMethods(Name,MethodKind,Params,ResultType);

      FOldCaretPos:=Point(FEditor.CaretX,FEditor.CaretY);

      FEditor.CaretFromPos(APosImplem,X,Y);
      if Y>0 then Y:=Y-1;
      FEditor.Lines.Insert(Y,MethodKind+' '+Name+Params+ResultType);
      Inc(Y);
      FOldCaretPos.x:=FOldCaretPos.x+1;
      
      if (Y>0) and (Y<FEditor.Lines.Count-1) then
        if trim(FEditor.Lines.Strings[Y])<>'' then begin
          FEditor.Lines.Insert(Y,'');
          FOldCaretPos.x:=FOldCaretPos.x+1;
        end;

      APosEnd:=Pos(AnsiUpperCase(DFDendUnit),AnsiUpperCase(Editor.Lines.Text));
      if APosEnd>0 then begin
        FEditor.CaretFromPos(APosEnd,X,Y);
        CreateMethodByLine(Y,P);
        Result:=P.Method;
      end;

      FEditor.SetCaret(FOldCaretPos.x,FOldCaretPos.y);
    end;
  end else begin
    if P<>nil then
      Result:=P.Method;
  end;
end;

procedure TDesignScrollBox.CreateMethodByLine(Line: Integer; P: Pointer);
var
  PInfo: PInfoMethod;
begin
  if P=nil then exit;
  PInfo:=PInfoMethod(P);
  if Line=-1 then Line:=0;
  if (Line>0) and (Line<=FEditor.Lines.Count-1) then
    if trim(FEditor.Lines.Strings[Line-1])<>'' then begin
      FEditor.Lines.Insert(Line,'');
      Inc(Line);
      FOldCaretPos.x:=FOldCaretPos.x+1;
    end;
  FEditor.Lines.Insert(Line,PInfo.MethodKind+' '+PInfo.Name+PInfo.Params+PInfo.ResultType);
  Inc(Line);
  FOldCaretPos.x:=FOldCaretPos.x+1;
  FEditor.Lines.Insert(Line,DFDBegin);
  Inc(Line);
  FOldCaretPos.x:=FOldCaretPos.x+1;
  FEditor.Lines.Insert(Line,'');
  Inc(Line);
  FOldCaretPos.x:=FOldCaretPos.x+1;
  FEditor.Lines.Insert(Line,DFDend);
  if (Line>0) and (Line<FEditor.Lines.Count-1) then
    if trim(FEditor.Lines.Strings[Line+1])<>'' then begin
      Inc(Line);
      FEditor.Lines.Insert(Line,'');
      FOldCaretPos.x:=FOldCaretPos.x+1;
    end;
end;

function TDesignScrollBox.GetSourcePosByInfoMethod(P: Pointer): Integer;
var
  p1,p2,p3,p4,p5,p6: Integer;
  l1,l2,l3,l4,l5,l6: Integer;
begin
  Result:=0;
  if GetMethodSourcePosInBody(P,p1,p2,p3,p4,p5,p6,l1,l2,l3,l4,l5,l6) then
    Result:=p5+l5;
end;

procedure TDesignScrollBox.ShowMethod(const Name: string);
var
  APos: Integer;
begin
  APos:=GetSourcePosByInfoMethod(GetInfoMethod(Name));
  if APos>0 then
    FEditor.ShowSource(APos);
end;

procedure TDesignScrollBox.PackMethods;
var
  i: Integer;
begin
  for i:=FListMethods.Count-1 downto 0 do begin
    PackMethod(PInfoMethod(FListMethods.Items[i]));
  end; 
end;

procedure TDesignScrollBox.PackMethod(P: Pointer);
var
  PInfo: PInfoMethod;
  
  procedure PackHeader;
  var
    PosType,PosName,PosParams,PosResult: Integer;
    LType,LName,LParams,LResult: Integer;
    YTop,YBottom: Integer;
    XTop,XBottom: Integer;
    i: Integer;
  begin
    if GetMethodSourcePosInHeader(PInfo,PosType,PosName,PosParams,PosResult,LType,LName,LParams,LResult) then begin
      FEditor.CaretFromPos(PosType,XTop,YTop);
      FEditor.CaretFromPos(PosResult,XBottom,YBottom);
      for i:=YBottom downto YTop do
        FEditor.Lines.Delete(i);
      RemoveListMethod(PInfo);
      DoChange(Self);
      FDesignObjInsp.FObjInsp.Synchronize;
    end;
  end;
  
var
  PosType,PosName,PosParams,PosResult,PosBegin,PosEnd: Integer;
  LType,LName,LParams,LResult,LBegin,LEnd: Integer;
  sEmpty: String;
  YTop,YBottom: Integer;
  XTop,XBottom: Integer;
  i: Integer;
begin
  if P=nil then exit;
  PInfo:=PInfoMethod(P);
  if GetMethodSourcePosInBody(PInfo,PosType,PosName,PosParams,PosResult,PosBegin,PosEnd,
                                LType,LName,LParams,LResult,LBegin,LEnd) then begin
    sEmpty:=Copy(FEditor.Lines.Text,PosBegin+LBegin,PosEnd-PosBegin-LBegin);
    if Trim(sEmpty)='' then begin
      FEditor.CaretFromPos(PosType,XTop,YTop);
      FEditor.CaretFromPos(PosEnd,XBottom,YBottom);
      for i:=YBottom downto YTop do
        FEditor.Lines.Delete(i);
      PackEndUnit;  
      PackHeader;
    end;
  end else begin
    PackHeader;
  end;
end;

procedure TDesignScrollBox.PackEndUnit;
var
  AposEnd: Integer;
  X,Y: Integer;
  i: Integer;
begin
  APosEnd:=Pos(AnsiUpperCase(DFDendUnit),AnsiUpperCase(FEditor.Lines.Text));
  if APosEnd>0 then begin
    FEditor.CaretFromPos(APosEnd,X,Y);
    for i:=Y-1 downto 1 do begin
      if Trim(FEditor.Lines.Strings[i])='' then begin
        if (i-1)>=1 then begin
          if Trim(FEditor.Lines.Strings[i-1])='' then begin
            FEditor.Lines.Delete(i);
          end else break; 
        end;
      end;
    end;
  end;
end;

function TDesignScrollBox.GetMethodSourcePosInHeader(P: Pointer; var PosType,PosName,PosParams,PosResult: Integer;
                                                     var LType,LName,LParams,LResult: Integer): Boolean;
var
  Lines: string;
  PInfo: PInfoMethod;
  APosImplem: Integer;
  APosName: Integer;
  s: string;
  RetPos: Integer;
begin
  Result:=false;
  if P=nil then exit;
  PInfo:=PInfoMethod(P);
  Lines:=AnsiUpperCase(FEditor.Lines.Text);
  APosImplem:=Pos(AnsiUpperCase(DFDImplementation),Lines);
  if APosImplem>0 then begin
    Lines:=Copy(Lines,1,APosImplem-1);
    APosName:=Pos(AnsiUpperCase(PInfo.Name),Lines);
    if APosName>0 then begin
      PosName:=APosName;
      LName:=Length(PInfo.Name);
      s:=Copy(Lines,1,APosName-1);
      RetPos:=0;
      s:=GetPrevWord(s,[';',#10,#13],RetPos);
      if AnsiSameText(ChangeString(Trim(s),' ',''),ChangeString(Trim(PInfo.MethodKind),' ','')) then begin
        PosType:=PosName-RetPos-1;
        LType:=Length(s);
        Lines:=Copy(Lines,APosName+LName,Length(Lines)-APosName-LName);
        RetPos:=0;
        s:=GetNextWord(Lines,[')'],RetPos);
        if Trim(s)<>'' then s:=Copy(Lines,1,RetPos+1);
        if AnsiSameText(ChangeString(Trim(s),' ',''),ChangeString(Trim(PInfo.Params),' ','')) then begin
          PosParams:=PosName+LName;
          LParams:=Length(s);
          Lines:=Copy(Lines,Length(s)+1,Length(Lines)-Length(s));
          RetPos:=0;
          s:=GetNextWord(Lines,[';'],RetPos);
          s:=Copy(Lines,1,RetPos+1);
          if AnsiSameText(ChangeString(Trim(s),' ',''),ChangeString(Trim(PInfo.ResultType),' ','')) then begin
            PosResult:=PosParams+LParams;
            LResult:=Length(s);
            Result:=true;
          end;
        end;
      end;
    end;
  end;
end;

function TDesignScrollBox.GetMethodSourcePosInBody(P: Pointer; var PosType,PosName,PosParams,PosResult,PosBegin,PosEnd: Integer;
                                                   var LType,LName,LParams,LResult,LBegin,LEnd: Integer): Boolean;
var
  Lines: string;
  PInfo: PInfoMethod;
  APosImplem: Integer;
  APosName: Integer;
  APosBegin: Integer;
  APosEnd: Integer;
  s: string;
  RetPos: Integer;
begin
  Result:=false;
  if P=nil then exit;
  PInfo:=PInfoMethod(P);
  Lines:=AnsiUpperCase(FEditor.Lines.Text);
  APosImplem:=Pos(AnsiUpperCase(DFDImplementation),Lines);
  if APosImplem>0 then begin
    Lines:=Copy(Lines,APosImplem,Length(Lines)-APosImplem+1);
    APosName:=Pos(AnsiUpperCase(PInfo.Name),Lines);
    if APosName>0 then begin
      PosName:=APosImplem+APosName-1;
      LName:=Length(PInfo.Name);
      s:=Copy(Lines,1,APosName-1);
      RetPos:=0;
      s:=GetPrevWord(s,[';',#10,#13],RetPos);
      if AnsiSameText(ChangeString(Trim(s),' ',''),ChangeString(Trim(PInfo.MethodKind),' ','')) then begin
        PosType:=PosName-RetPos-1;
        LType:=Length(s);
        Lines:=Copy(Lines,APosName+LName,Length(Lines)-APosName-LName);
        RetPos:=0;
        s:=GetNextWord(Lines,[')'],RetPos);
        if Trim(s)<>'' then s:=Copy(Lines,1,RetPos+1);
        if AnsiSameText(ChangeString(Trim(s),' ',''),ChangeString(Trim(PInfo.Params),' ','')) then begin
          PosParams:=PosName+LName;
          LParams:=Length(s);
          Lines:=Copy(Lines,Length(s)+1,Length(Lines)-Length(s));
          RetPos:=0;
          s:=GetNextWord(Lines,[';'],RetPos);
          s:=Copy(Lines,1,RetPos+1);
          if AnsiSameText(ChangeString(Trim(s),' ',''),ChangeString(Trim(PInfo.ResultType),' ','')) then begin
            PosResult:=PosParams+LParams;
            LResult:=Length(s);
            APosBegin:=AnsiPos(AnsiUpperCase(DFDBegin),Lines);
            if APosBegin>0 then begin
              PosBegin:=PosResult+APosBegin-1;
              LBegin:=Length(DFDBegin);
              APosEnd:=AnsiPos(AnsiUpperCase(DFDEnd),Lines);
              if APosEnd>0 then begin
                PosEnd:=PosResult+APosEnd-1;
                LEnd:=Length(DFDEnd);
                Result:=true;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TDesignScrollBox.GetMethodsToStrings(TypeData: PTypeData; str: TStringList);
var
  MethodKind,Params,ResultType: string;
  i: Integer;
  P: PInfoMethod;
begin
  GetMethodParams(TypeData,MethodKind,Params,ResultType);
  for i:=0 to FListMethods.Count-1 do begin
    P:=FListMethods.Items[i];
    if AnsiSameText(ChangeString(Trim(P.MethodKind),' ',''),ChangeString(Trim(MethodKind),' ',''))and
       AnsiSameText(ChangeString(Trim(P.Params),' ',''),ChangeString(Trim(Params),' ',''))and
       AnsiSameText(ChangeString(Trim(P.ResultType),' ',''),ChangeString(Trim(ResultType),' ','')) then begin
      str.AddObject(P.name,TObject(P));
    end;
  end;
end;

function TDesignScrollBox.MethodExists(const Name: string): Boolean;
begin
  Result:=GetInfoMethod(name)<>nil;
end;

procedure TDesignScrollBox.RenameMethod(const CurName, NewName: string);
var
  PCur: PInfoMethod;
  Pnew: PInfoMethod;
begin
  PCur:=GetInfoMethod(CurName);
  if PCur=nil then exit;
  PNew:=GetInfoMethod(NewName);
  if PNew<>nil then exit;
  PCur.Name:=NewName;
end;

procedure TDesignScrollBox.FillListMethodsFromEditor;
begin
  if FEditor=nil then exit;
  ClearListMethods;
  GetListMethods;
end;


{ TDesignForm }

constructor TDesignForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FELDesigner:=TELDesigner.Create(nil);
  FELDesigner.DesignControl:=Self;

  FELDesigner.DesignComponentWidth:=28;
  FELDesigner.OnControlInserting:=ELDesignerControlInserting;
  FELDesigner.OnControlInserted:=ELDesignerControlInserted;
  FELDesigner.OnNotification:=ELDesignerOnNotification;
  FELDesigner.OnModified:=ELDesignerOnModified;
  FELDesigner.OnChangeSelection:=ELDesignerOnChangeSelection;
  FELDesigner.OnDesignFormClose:=ELDesignerOnDesignFormClose;
  FELDesigner.OnKeyDown:=ELDesignerOnKeyDown;
  FELDesigner.OnGetDesignComponentGlyph:=ELDesignerGetDesignComponentGlyph;
  FELDesigner.OnSetDesignComponent:=FELDesignerOnSetDesignComponent;
  FELDesigner.OnDblClick:=FELDesignerOnDblClick;
end;

procedure TDesignForm.FELDesignerOnDblClick(Sender: TObject);
var
  obj: TObject;
  ce :TComponentEditor;
begin
  if FDesignScrollBox<>nil then begin
    if FDesignScrollBox.FActiveDesignForm<>nil then begin
      if FDesignScrollBox.FDesignObjInsp<>nil then begin
        obj:=FDesignScrollBox.FDesignObjInsp.FObjInsp.CurObj;
        if (obj is TComponent){ and not(obj is TControl)  }then begin
         try
          ce:=GetComponentEditor(TComponent(obj),FDesignScrollBox.FDFD);
          ce.Edit;
         except
         end; 
        end else begin

        end;
      end;
    end;
  end;
end;

procedure TDesignForm.RemoveSelfLinks;
begin
    if FDesignScrollBox<>nil then
      if FDesignScrollBox.FDesignObjInsp<>nil then begin
        FELDesigner.SelectedControls.Clear;
        FDesignScrollBox.FDesignObjInsp.RemoveObject(Self);
      end;  
end;

procedure TDesignForm.ELDesignerOnDesignFormClose(Sender: TObject; var Action: TCloseAction);
var
  but: Integer;
  tmps: string;
begin
  if not ChangeFlag then begin
   Action:=caFree;
   exit;
  end;
  tmps:=Format(DesignFormDialogSave,[Name]);
  but:=MessageDlg(tmps,mtConfirmation,[mbYes,mbNo,mbCancel],0);
  case but of
    mrYes: begin
      if SaveToFileWithDialog then begin
       Action:=caFree;
      end else Action:=caNone;
    end;
    mrNo: begin
      Action:=caFree;
    end;
    mrCancel: begin
      Action:=caNone;
    end;
  end;
end;

procedure TDesignForm.FELDesignerOnSetDesignComponent(Sender: TObject; AComponent: TComponent);
begin
  if FDesignScrollBox<>nil then
   if FDesignScrollBox.FDesignObjInsp<>nil then
    if AComponent<>nil then
     FDesignScrollBox.FDesignObjInsp.SetObject(AComponent,false);
end;

procedure TDesignForm.ELDesignerOnChangeSelection(Sender: TObject);
var
  i: Integer;
begin
  if FDesignScrollBox<>nil then
   if FDesignScrollBox.FDesignObjInsp<>nil then begin
     FDesignScrollBox.DoChange(Self);
     FDesignScrollBox.FDesignObjInsp.FObjInsp.Selections.Clear;
     if FDesignScrollBox.FActiveDesignForm<>nil then begin
       for i:=0 to FDesignScrollBox.FActiveDesignForm.
                     FELDesigner.SelectedControls.Count-1 do begin
         if not (FDesignScrollBox.FActiveDesignForm.
                     FELDesigner.SelectedControls[i] is TDesignComponentEx) then
           FDesignScrollBox.FDesignObjInsp.FObjInsp.Selections.Add(FDesignScrollBox.FActiveDesignForm.FELDesigner.SelectedControls[i])
         else FDesignScrollBox.FDesignObjInsp.
                FObjInsp.Selections.Add(TDesignComponentEx(FDesignScrollBox.FActiveDesignForm.
                                                               FELDesigner.SelectedControls[i]).Component);
       end;
     end;
   end;
end;

procedure TDesignForm.ELDesignerOnModified(Sender: TObject);
begin
  ChangeFlag:=true;
  if FDesignScrollBox<>nil then
    if FDesignScrollBox.FDesignObjInsp<>nil then begin
       FDesignScrollBox.DoChange(FDesignScrollBox.FDesignObjInsp.FObjInsp);
       FDesignScrollBox.FDesignObjInsp.FObjInsp.Synchronize;
       if FDesignScrollBox.FDesignObjInsp.FObjInsp.CurObj=nil then
          FDesignScrollBox.FDesignObjInsp.SetObject(Self,false);
    end;
end;

procedure TDesignForm.ELDesignerOnNotification(Sender: TObject;
                 AnObject: TPersistent; Operation: TOperation);
begin
  if FDesignScrollBox<>nil then
   if FDesignScrollBox.FDesignObjInsp<>nil then
    case Operation of
      opInsert: begin
        // Property Parent not assigned
      end;
      opRemove: begin
        FDesignScrollBox.FDesignObjInsp.RemoveObject(AnObject);
      end;
    end;
    ForcedNotification(AnObject,Operation);
end;

procedure TDesignForm.ELDesignerControlInserting(Sender: TObject; var AComponentClass: TComponentClass);
begin
  if FDesignScrollBox<>nil then
   if FDesignScrollBox.FDesignTabControl<>nil then begin
     AComponentClass:=FDesignScrollBox.FDesignTabControl.ComponentClass;
   end;  
end;

procedure TDesignForm.ELDesignerControlInserted(Sender: TObject);
begin
  if FDesignScrollBox<>nil then begin
   if FDesignScrollBox.FDesignTabControl<>nil then
     FDesignScrollBox.FDesignTabControl.DefaultButtonDown:=true;

  end;
end;

destructor TDesignForm.Destroy;

  procedure LocalForcedNotification;
  var
    i: Integer;
  begin
    for i:=0 to ComponentCount-1 do
      ForcedNotification(Components[i],opRemove);
  end;
  
begin
  LocalForcedNotification;
  
  RemoveSelfLinks;
  if FDesignScrollBox<>nil then begin
    with FDesignScrollBox do begin
      FListForms.Remove(Self);
      if FActiveDesignForm=Self then
       if FListForms.Count>0 then begin
         TDesignForm(FListForms.Items[FListForms.Count-1]).Activate;
      end else FActiveDesignForm:=nil;
    end;
  end;
  FELDesigner.Active:=false;
  FELDesigner.Free;
  inherited Destroy;
end;

procedure TDesignForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;

procedure TDesignForm.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if not(csDesigning in ComponentState) and (Message.Result = HTCLIENT) then
    Message.Result := HTCAPTION;
end;

procedure TDesignForm.Click;
begin
  inherited;
end;

procedure TDesignForm.Activate;
var
   obj: TObject;
begin
  inherited;
  if FDesignScrollBox.FActiveDesignForm=nil then exit;
  if FDesignScrollBox.FDesignObjInsp<>nil then
 // if FDesignScrollBox.FActiveDesignForm<>Self then begin
    FDesignScrollBox.FActiveDesignForm:=Self;
    FELDesigner.OnSetDesignComponent:=nil;
    FELDesigner.OnChangeSelection:=nil;
    obj:=FELDesigner.SelectedControls.DefaultComponent;
    if obj<>nil then begin
     if obj<>Self then begin
       ELDesignerOnChangeSelection(nil);
       FDesignScrollBox.FDesignObjInsp.SetObject(obj,true,true);
     end else begin
       FDesignScrollBox.FDesignObjInsp.FObjInsp.Selections.Clear;
       FDesignScrollBox.FDesignObjInsp.SetObject(Self,true);
     end;
    end else begin
      FDesignScrollBox.FDesignObjInsp.FObjInsp.Selections.Clear;
      FDesignScrollBox.FDesignObjInsp.SetObject(self,true);
    end;

    BringToFront;
    FELDesigner.OnSetDesignComponent:=FELDesignerOnSetDesignComponent;
    FELDesigner.OnChangeSelection:=ELDesignerOnChangeSelection;
  // end;
end;

procedure TDesignForm.DoClose(var Action: TCloseAction);
begin
  Action:=caMinimize;
  Inherited DoClose(Action);
end;

procedure TDesignForm.Resizing(State: TWindowState);
begin
  ChangeFlag:=true;
  inherited;
  if FDesignScrollBox<>nil then begin
    FDesignScrollBox.SetRealScrollBoxRange;
    if FDesignScrollBox.FDesignObjInsp<>nil then begin
      FDesignScrollBox.FDesignObjInsp.FObjInsp.Synchronize;
    end;  
  end;
end;

procedure TDesignForm.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  ChangeFlag:=true;
  inherited;
  if FDesignScrollBox<>nil then begin
    FDesignScrollBox.SetRealScrollBoxRange;
    if FDesignScrollBox.FDesignObjInsp<>nil then
     if FDesignScrollBox.FDesignObjInsp.FObjInsp.CurObj=Self then
       FDesignScrollBox.FDesignObjInsp.FObjInsp.Synchronize;
  end;
end;

procedure TDesignForm.WMIconEraseBkgnd(var Message: TWMIconEraseBkgnd);
begin
  inherited;
end;

procedure TDesignForm.WMNCCreate(var Message: TWMNCCreate);
begin
  inherited;
end;

procedure TDesignForm.WMMDIActivate(var Message: TWMMDIActivate);
begin
  inherited;
end;

procedure TDesignForm.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;

procedure TDesignForm.WMClose(var Message: TWMClose);
begin
  inherited;
end;

procedure TDesignForm.ViewComponent(ct: TComponent; isClear: Boolean=false);
begin
  FELDesigner.SelectedControls.Clear;
  if ct<>nil then begin
    FELDesigner.SelectedControls.AddComponent(ct);
  end;
  BringToFront;
  ShowWindow(Handle,SW_RESTORE);
end;

var
  FReaderComponent: TComponent;
  
procedure TDesignForm.ReaderOnCreateComponent(Reader: TReader;
     ComponentClass: TComponentClass; var Component: TComponent);
begin
  Component:=ComponentClass.Create(Self);
  FReaderComponent:=Component;
end;

procedure TDesignForm.ReaderOnError(Reader: TReader; const Message: string;
          var Handled: Boolean);
var
  but: Integer;
  tmps: string;
begin
  if FReaderOnErrorHandled then begin
    Handled:=true;
    exit;
  end;
  tmps:=Format(DesignFormReaderError,[Message]);
  but:=MessageDlg(tmps,mtConfirmation,[mbYes,mbYesToAll,mbCancel],0);
  case but of
    mrYes: begin
      Handled:=true;
    end;
    mrYesToAll: begin
      Handled:=true;
      FReaderOnErrorHandled:=true;
    end;
    mrCancel: begin
      Handled:=false;
    end;
  end;
end;

procedure TDesignForm.ReaderOnFindMethod(Reader: TReader; const MethodName: string;
                                         var Address: Pointer; var Error: Boolean);
var
  P: PInfoMethod;
begin
  P:=FDesignScrollBox.GetInfoMethod(MethodName);
  if P<>nil then begin
    Address:=P.Method.Code;
    Error:=Address=nil;
  end;
end;

type
  TReaderEx=class(TReader)
  public
    property PropName; 
  end;

procedure TDesignForm.ReaderOnReferenceName(Reader: TReader; var Name: string);
begin
end;

procedure TDesignForm.ReaderOnAncestorNotFound(Reader: TReader; const ComponentName: string;
    ComponentClass: TPersistentClass; var Component: TComponent);
begin
end;

procedure TDesignForm.ReaderOnSetName(Reader: TReader; Component: TComponent;  var Name: string);
var
  TSPBS: TSetProgressBarStatus;
begin
  TSPBS.Progress:=Reader.Position;
  TSPBS.Hint:=PChar(Name);
  _SetProgressBarStatus(ReaderPBH,@TSPBS);
end;

function FindGlobalComponentProc(const Name: string): TComponent;
var
  obj: TObject;
begin
  Result:=nil;
  obj:=GetInterpreterVarObjectByName(Name);
  if obj<>nil then begin
    if obj is TComponent then
      Result:=TComponent(obj);
  end;
end;

procedure TDesignForm.LoadFromStream(Stream: TStream);
var
  ms: TMemoryStream;
  rd: TReaderEx;
  oldPos: Integer;
  I: Integer;
  Flags: TFilerFlags;
  NewName: string;
  TCPB: TCreateProgressBar;
  OldFind: TFindGlobalComponent;
begin
  Screen.Cursor:=crHourGlass;
  ms:=TMemoryStream.Create;
  FReaderOnErrorHandled:=false;
  try
    ObjectTextToBinary(Stream,ms);
    ms.Position:=0;
    DestroyComponents;
    FillCHar(TCPB,SizeOf(TCreateProgressBar),0);
    TCPB.Min:=0;
    TCPB.Max:=ms.Size;
    TCPB.Hint:=DesignFormLoad;
    TCPB.Color:=clNavy;
    ReaderPBH:=_CreateProgressBar(@TCPB);

    rd:=TReaderEx.Create(ms,DesignFormReadWriteSize);
    try
      rd.OnCreateComponent:=ReaderOnCreateComponent;
      rd.OnError:=ReaderOnError;
      rd.OnFindMethod:=ReaderOnFindMethod;
      rd.OnReferenceName:=ReaderOnReferenceName;
      rd.OnAncestorNotFound:=ReaderOnAncestorNotFound;
      rd.OnSetName:=ReaderOnSetName;
      FReaderComponent:=nil;
      try
       oldPos:=rd.Position;
       rd.ReadSignature;
       rd.ReadPrefix(Flags, I);
       rd.ReadStr;
       NewName:=rd.ReadStr;
       if not FDesignScrollBox.ifExistsFormByName(NewName) then
        Name:=NewName;
       rd.Position:=oldPos;
       rd.ReadRootComponent(Self);

       if Self.Left<0 then Self.Left:=0;
       if Self.Top<0 then Self.Top:=0;
      except
      end;
    finally
      _FreeProgressBar(ReaderPBH);
      rd.Free;
      OldFind:=FindGlobalComponent;
      FindGlobalComponent:=FindGlobalComponentProc;
      GlobalFixupReferences;
      FindGlobalComponent:=OldFind;
    end;
    FELDesigner.AssignDesignComponents;
  finally
    ms.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TDesignForm.WriterOnFindAncestor(Writer: TWriter; Component: TComponent;
            const Name: string; var Ancestor, RootAncestor: TComponent);
begin
  if Component is TDesignComponent then  begin
    Ancestor:=Component;
  end else begin
    Caption:=Caption;
  end;
end;

{procedure TDesignForm.ReaderProc(Reader: TReader);
begin
  CurFilerProcString:=Reader.ReadIdent;
end;

procedure TDesignForm.WriterProc(Writer: TWriter);
begin
  Writer.WriteIdent(CurFilerProcString);
end;}

procedure TDesignForm.DefineProperties(Filer: TFiler);
{var
  I, Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
  PropType: PTypeInfo;
  M: TMethod;}
begin
  inherited;
{  Count := GetTypeData(Self.ClassInfo)^.PropCount;
  if Count > 0 then
  begin
    GetMem(PropList, Count * SizeOf(Pointer));
    try
      GetPropInfos(Self.ClassInfo, PropList);
      for I := 0 to Count - 1 do begin
        PropInfo := PropList^[I];
        if PropInfo = nil then break;
        if IsStoredProp(self, PropInfo) then begin
         if (PropInfo^.SetProc <> nil) and
            (PropInfo^.GetProc <> nil) then begin
           PropType := PropInfo^.PropType^;

           case PropType^.Kind of
             tkMethod: begin
               if FDesignScrollBox<>nil then begin
                M:=GetMethodProp(Self,PropInfo);
                CurFilerProcString:=FDesignScrollBox.GetMethodName(M);
                Filer.DefineProperty(PPropInfo(PropInfo)^.Name,ReaderProc,WriterProc,Trim(CurFilerProcString)<>'');
               end else break;
             end;
           end;
         end;
        end;
      end;
    finally
      FreeMem(PropList, Count * SizeOf(Pointer));
    end;
  end;   }
end;

procedure TDesignForm.SaveToStream(Stream: TStream);
var
  MethodTable: PMethodTable;
  MethodTableSize: Integer;

  procedure CreateMethodTable;
  var
    i: Integer;
    P: PMethodTable;
    PInfo: PInfoMethod;
  begin
    if FDesignScrollBox.FListMethods.Count = 0 then
      MethodTable := nil
    else
    begin
      MethodTableSize := sizeof(MethodTable^.EntryCount) + sizeof(TMethodEntry) * FDesignScrollBox.FListMethods.Count;

      GetMem(MethodTable, MethodTableSize);
      MethodTable^.EntryCount := FDesignScrollBox.FListMethods.Count;
      P := IncPtr(MethodTable, sizeof(MethodTable^.EntryCount));
      for i := 0 to MethodTable^.EntryCount - 1 do begin
        PInfo:=FDesignScrollBox.FListMethods.Items[i];
        PMethodEntry(P).Size := 6 + Length(PInfo.Name) + 1;
        PMethodEntry(P).Code := PInfo.Method.Code;
        PMethodEntry(P).Name := PInfo.Name;
        P := IncPtr(P, PMethodEntry(P).Size);
      end;
    end;
  end;

  procedure FreeMethodTable;
  begin
    if MethodTable <> nil then
      FreeMem(MethodTable, MethodTableSize);
  end;

var
  ms: TMemoryStream;
  wr: TWriter;
  ss: TStringList;
  oldVMT: Pointer;
  mrtti: TRARTTIMaker;
  Instance: TComponent;
begin
  Screen.Cursor:=crHourGlass;
  ms:=TMemoryStream.Create;
  ss:=TStringList.Create;
  mrtti:=TRARTTIMaker.Create(nil);
  try
    Instance:=Self;
    oldVMT:=PPointer(Instance)^;
    CreateMethodTable;
    try
     mrtti.MakeClass(Self);
     mrtti.RClass.ClassName := 'T'+Self.Name;
     mrtti.RClass.VMT.MethodTable := MethodTable;
     mrtti.RClass.VMT.Parent := IncPtr(TForm, vmtOffset);
     PPointer(Instance)^ := mrtti.CClass;

     wr:=TWriter.Create(ms,DesignFormReadWriteSize);
     try
      wr.OnFindAncestor:=WriterOnFindAncestor;
//      ReadMethodTable(Self,ss);
//      showMessage(ss.Text);
      wr.WriteRootComponent(Self);
     finally
      wr.Free;
     end;
    finally
     PPointer(Instance)^:=oldVMT;
     FreeMethodTable;
    end;
    ms.Position:=0;
    ObjectBinaryToText(ms,Stream);
  finally
    mrtti.Free;
    ss.Free;
    ms.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TDesignForm.LoadFromFile(FileName: String);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
   fs:=TFileStream.Create(FileName,fmOpenRead);
   LoadFromStream(fs);   
  finally
   fs.Free;
  end; 
end;

procedure TDesignForm.SaveToFile(FileName: String);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
   fs:=TFileStream.Create(FileName,fmCreate or fmOpenWrite);
   SaveToStream(fs);
  finally
   fs.Free;
  end;
end;

procedure TDesignForm.FillFromRoot(wt: TWinControl);

  procedure FillLocalAsParent(wtParent: TWinControl; ndParent: TTreeNode);
  var
   i: Integer;
   ct: TControl;
   nd: TTreeNode;
  begin
    for i:=0 to wtParent.ControlCount-1 do begin
     ct:=wtParent.Controls[i];
     if ct.Owner=wt then 
       if not (ct is TDesignComponent) then begin
        if ct.Parent=wtParent then begin
          nd:=FDesignScrollBox.FDesignObjInsp.FObjTV.Items.AddChildObject(ndParent,
                           FDesignScrollBox.FDesignObjInsp.GenerateNodeName(ct),ct);
          nd.ImageIndex:=DesignObjInspImageIndexControl;
          nd.SelectedIndex:=nd.ImageIndex;
          if (ct is TWinControl) then
             FillLocalAsParent(TWinControl(ct),nd);
        end;
       end;
    end;
  end;
  
  procedure FillLocal(wtParent: TWinControl; ndParent: TTreeNode);
  var
   i: Integer;
   ct: TComponent;
   nd: TTreeNode;
  begin
    for i:=0 to wtParent.ComponentCount-1 do begin
     ct:=wtParent.Components[i];
     if ct.Owner=wt then 
       if not (ct is TDesignComponent) then begin
         if ct Is TControl then begin
          if TControl(ct).Parent=wtParent then begin
           nd:=FDesignScrollBox.FDesignObjInsp.FObjTV.Items.AddChildObject(ndParent,
                           FDesignScrollBox.FDesignObjInsp.GenerateNodeName(ct),ct);
           nd.ImageIndex:=DesignObjInspImageIndexControl;
           nd.SelectedIndex:=nd.ImageIndex;
           if (ct is TWinControl) then
             FillLocalAsParent(TWinControl(ct),nd);
          end;
         end else begin
          nd:=FDesignScrollBox.FDesignObjInsp.FObjTV.Items.AddChildObject(ndParent,
                           FDesignScrollBox.FDesignObjInsp.GenerateNodeName(ct),ct);
          nd.ImageIndex:=DesignObjInspImageIndexComponent;
          nd.SelectedIndex:=nd.ImageIndex;
         end;

       end;
    end;
  end;

var
  nd: TTreeNode;
begin
  if FDesignScrollBox=nil then exit;
  if FDesignScrollBox.FDesignObjInsp=nil then exit;

  FDesignScrollBox.FDesignObjInsp.FObjTV.Items.BeginUpdate;
  try
    FDesignScrollBox.FDesignObjInsp.FObjInsp.CurObj:=nil;
    nd:=FDesignScrollBox.FDesignObjInsp.GetNodeFromData(wt);
    if nd<>nil then nd.Delete;
    nd:=FDesignScrollBox.FDesignObjInsp.FObjTV.Items.AddChildObject(nil,
                  FDesignScrollBox.FDesignObjInsp.GenerateNodeName(wt),wt);
    nd.ImageIndex:=DesignObjInspImageIndexForm;
    nd.SelectedIndex:=nd.ImageIndex;
    FillLocal(wt,nd);
    FDesignScrollBox.FDesignObjInsp.FObjInsp.CurObj:=wt;
  finally
    FDesignScrollBox.FDesignObjInsp.FObjTV.Items.EndUpdate;
  end;
end;

function TDesignForm.LoadFromFileWithDialog: Boolean;
var
  od: TOpenDialog;
begin
  Result:=false;
  od:=TOpenDialog.Create(nil);
  try
    od.FileName:=FLastFileName;
    od.Filter:=DesignFormFilterExt;
    od.DefaultExt:=DesignFormDefaultExt;
    od.Options:=od.Options-[ofHideReadOnly];
    if od.Execute then begin
      try
       LoadFromFile(od.FileName);
       FLastFileName:=od.FileName;
       FillFromRoot(Self);
       ChangeFlag:=false;
       Result:=true;
      except
       on E: Exception do begin
         ShowErrorEx(E.Message);
       end;
      end; 
    end;
  finally
    od.Free;
  end;
end;

function TDesignForm.SaveToFileWithDialog: Boolean;
var
  sd: TSaveDialog;
begin
  Result:=false;
  sd:=TSaveDialog.Create(nil);
  try
    if Trim(FLastFileName)='' then
      sd.FileName:=Name    
    else sd.FileName:=FLastFileName;
    sd.Filter:=DesignFormFilterExt;
    sd.DefaultExt:=DesignFormDefaultExt;
    sd.Options:=sd.Options-[ofHideReadOnly];
    if sd.Execute then begin
      try
       SaveToFile(sd.FileName);
       FLastFileName:=sd.FileName;
       ChangeFlag:=false;
       Result:=true;
      except
       on E: Exception do begin
         ShowErrorEx(E.Message);
       end;
      end;
    end;
  finally
    sd.Free;
  end;
end;

procedure TDesignForm.ELDesignerOnKeyDown(Sender: TObject; var Key: Word;
                                  Shift: TShiftState);
begin
  if FDesignScrollBox<>nil then
    FDesignScrollBox.DoKeyDown(Sender,Key,Shift);  
end;

procedure TDesignForm.ELDesignerGetDesignComponentGlyph(Sender: TObject;
                           AClass: TClass; var Glyph: TBitmap);
begin
  if FDesignScrollBox<>nil then
   if FDesignScrollBox.FDesignTabControl<>nil then
     Glyph:=FDesignScrollBox.FDesignTabControl.GetComponentGlyph(AClass);
end;

procedure DesignFormGetLibraryProc(Owner: Pointer; PGL: PGetLibrary); stdcall;
var
  P1: PInfoComponentsLibrary;
  GetInfoComponentsLibrary: TGetInfoComponentsLibraryProc;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGL) then exit;
  if PGL.Active then begin
    if PGL.TypeLib=ttleComponents then begin
      @GetInfoComponentsLibrary:=GetProcAddress(PGL.LibHandle,Pchar(ConstGetInfoComponentsLibrary));
      if isValidPointer(@GetInfoComponentsLibrary) then begin
       P1:=nil;
       try
        new(P1);
        FillChar(P1^,SizeOf(TInfoComponentsLibrary),0);
        GetInfoComponentsLibrary(P1);
        if isValidPointer(@P1.ForcedNotification) then begin
          P1.ForcedNotification(Owner,TDesignForm(Owner).FAPersistentForced,TDesignForm(Owner).FOperationForced);
        end;
       finally
        Dispose(P1);
       end;
      end;
    end;
  end;
end;

procedure TDesignForm.ForcedNotification(APersistent: TPersistent; Operation: TOperation);
begin
  FAPersistentForced:=APersistent;
  FOperationForced:=Operation;
  _GetLibraries(Self,DesignFormGetLibraryProc);
end;

procedure TDesignForm.WMSizing(var Message: TMessage);
var
  NewHeight, NewWidth: Integer;
  R: PRect;
begin
    R := PRect(Message.LParam);
    NewHeight:=R.Bottom-R.Top;
    NewWidth:=R.Right-R.Left;

    if Constraints.MinHeight>0 then
     if NewHeight<=Constraints.MinHeight then
        NewHeight:=Constraints.MinHeight;

    if Constraints.MinWidth>0 then
     if NewWidth<=Constraints.MinWidth then
        NewWidth:=Constraints.MinWidth;

    if Constraints.MaxHeight>0 then
      if NewHeight>=Constraints.MaxHeight then
        NewHeight:=Constraints.MaxHeight;

    if Constraints.MaxWidth>0 then
      if NewWidth>=Constraints.MaxWidth then
        NewWidth:=Constraints.MaxWidth;

    if Message.WParam in [WMSZ_BOTTOM,WMSZ_BOTTOMRIGHT,WMSZ_BOTTOMLEFT] then begin
     R.Bottom := R.Top + NewHeight;
    end else begin
     R.Top := R.Bottom - NewHeight;
    end;

    if Message.WParam in [WMSZ_RIGHT,WMSZ_TOPRIGHT,WMSZ_BOTTOMRIGHT] then begin
     R.Right := R.Left + NewWidth;
    end else begin
     R.Left := R.Right - NewWidth;
    end;

end;

procedure TDesignForm.SetChangeFlag(Value: Boolean);
begin
  if Value<>FChangeFlag then begin
    FChangeFlag:=Value;
  end;
  if FDesignScrollBox<>nil then
     FDesignScrollBox.DoChange(Self);
end;

{ TDesignSpeedButton }

constructor TDesignSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner is TDesignTabControl then
    FDesignPageControl:=TDesignTabControl(AOwner);
end;

destructor TDesignSpeedButton.Destroy;
begin
  FDesignPageControl:=nil;
  Inherited;
end;

procedure TDesignSpeedButton.Click;
var
  i: Integer;
begin
  inherited;
  for i:=0 to FDesignPageControl.FButtons.Count-1 do begin
    TComponentSpeedButton(FDesignPageControl.FButtons.Items[i]).AllowAllUp:=true;
    TComponentSpeedButton(FDesignPageControl.FButtons.Items[i]).Down:=false;
    TComponentSpeedButton(FDesignPageControl.FButtons.Items[i]).AllowAllUp:=false;
  end;  
end;

{ TDesignPageScroller }

constructor TDesignPageScroller.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner is TDesignTabControl then
    FDesignPageControl:=TDesignTabControl(AOwner);
end;

destructor TDesignPageScroller.Destroy;
begin
  FDesignPageControl:=nil;
  Inherited;
end;

procedure TDesignPageScroller.CMMouseEnter(var Message: TMessage); 
begin
  inherited;
  if FDesignPageControl<>nil then begin
    FDesignPageControl.RemoveButtonsUp;
  end;
end;

procedure TDesignPageScroller.Scroll(Shift: TShiftState; X, Y: Integer;
            Orientation: TPageScrollerOrientation; var Delta: Integer);
begin
  if FDesignPageControl<>nil then
   Delta:=FDesignPageControl.FDesignSpeedButton.Width;
end;

{ TComponentSpeedButton }

procedure TComponentSpeedButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
end;

procedure TComponentSpeedButton.Click;
begin
  FDesignPageControl.FDesignSpeedButton.AllowAllUp:=true;
  FDesignPageControl.FDesignSpeedButton.Down:=false;
  FDesignPageControl.FDesignSpeedButton.AllowAllUp:=false;
end;

procedure TComponentSpeedButton.Paint;
{var
  ARect: TRect;
  dx,dy: Integer;}
begin
  inherited; 
{  with Canvas do begin
    Brush.Color := Color;
    Brush.Style:=bsSolid;
    FillRect(ARect);
  end;
  if isValidPointer(P) then begin
   if isValidPointer(P.Bitmap) then begin
    dx:=Width div 2 - P.Bitmap.Width div 2;
    dy:=Height div 2 - P.Bitmap.Height div 2;
    Canvas.Draw(dx,dy,P.Bitmap);
   end;
  end;
  ARect:=ClientRect;
  Frame3D(Canvas,ARect,clBtnHighlight,clBtnShadow,1);}
end;

{ TDesignTabControl }

constructor TDesignTabControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderWidth:=0;
  BevelEdges:=[];
  BevelInner:=bvNone;
  BevelOuter:=bvNone;
  Ctl3D:=false;
  FGetComponentClassBitmap:=TBitmap.Create;
  FNotExistsBitmap:=TBitmap.Create;
  HotTrack:=true;
  TabStop:=false;
//  Style:=tsFlatButtons;
  OwnerDraw:=false;
  FButtons:=TList.Create;

  FDesignSpeedButtonPanel:=TPanel.Create(Self);
  FDesignSpeedButtonPanel.BevelOuter:=bvNone;
  FDesignSpeedButtonPanel.BorderWidth:=0;
  FDesignSpeedButtonPanel.Align:=alLeft;
  FDesignSpeedButton:=TDesignSpeedButton.Create(Self);
  FDesignSpeedButton.Align:=alLeft;
  FDesignSpeedButton.AllowAllUp:=false;
  FDesignSpeedButton.Flat:=true;
  FDesignSpeedButton.Down:=true;
  FDesignSpeedButton.GroupIndex:=1;
  FDesignPageScroller:=TDesignPageScroller.Create(Self);
  FDesignPageScroller.AutoScroll:=false;
  FDesignPageScroller.align:=alClient;
  FDesignPageScroller.OnScroll:=DesignPageScrollerScroll;
  
  FDesignButtonsPanel:=TPanel.Create(Self);
  FDesignButtonsPanel.BevelOuter:=bvNone;
  FDesignButtonsPanel.Left:=FDesignPageScroller.ButtonSize;
  FDesignButtonsPanel.Width:=FButtons.Count*FDesignPageScroller.Height;
  FDesignButtonsPanel.Height:=FDesignPageScroller.Height;
end;

procedure TDesignTabControl.CreateParams(var Params: TCreateParams);
begin
  inherited;
  FDesignSpeedButtonPanel.Parent:=Self;
  FDesignSpeedButton.Parent:=FDesignSpeedButtonPanel;
  FDesignPageScroller.Parent:=Self;
  FDesignButtonsPanel.Parent:=FDesignPageScroller;
end;

destructor TDesignTabControl.Destroy;
begin
  ClearButtons;
  FButtons.Free;
  ClearTabs;
  FDesignButtonsPanel.Free;
  FDesignPageScroller.Free;
  FDesignSpeedButton.Free;
  FNotExistsBitmap.Free;
  FGetComponentClassBitmap.Free;
  FDesignSpeedButtonPanel.Free;
  inherited;
end;

procedure TDesignTabControl.DesignPageScrollerScroll(Sender: TObject; Shift: TShiftState; X, Y: Integer;
        Orientation: TPageScrollerOrientation; var Delta: Integer);
begin
end;

procedure TDesignTabControl.RemoveButtonsUp;
var
  i: Integer;
  csp: TComponentSpeedButton;
begin
  for i:=0 to FButtons.Count-1 do begin
    csp:=FButtons.Items[i];
    if csp.MouseInControl then begin
      csp.Perform(CM_MOUSELEAVE,0,0);
    end;
  end;
end;
    
procedure TDesignTabControl.SetDefaultBitmap(Value: TBitmap);
begin
  FDesignSpeedButton.Glyph.Assign(Value);
end;

function TDesignTabControl.GetDefaultBitmap: TBitmap;
begin
  Result:=FDesignSpeedButton.Glyph;
end;

procedure TDesignTabControl.SetNotExistsBitmap(Value: TBitmap);
begin
  FNotExistsBitmap.Assign(Value);
end;

procedure TDesignTabControl.Change;
begin
  inherited;
  FillComponentsFromIndex;
end;

procedure TDesignTabControl.ClearButtons;
var
  i: integer;
  csp: TComponentSpeedButton;
begin
  for i:=0 to FButtons.Count-1 do begin
    csp:=FButtons.Items[i];
    csp.Free;
  end;
  FButtons.Clear;
end;

procedure TDesignTabControl.FillComponentsFromIndex;
begin
   if Tabs.Count=0 then exit; 
   FDesignButtonsPanel.Width:=0;
   ClearButtons;
   FDesignButtonsPanelLength:=0;
   FUseFirstFill:=false;
   _GetDesignPalettes(Owner,EditInterfaceGetDesignPaletteProc);
   PackTabs;
   FDesignSpeedButton.Down:=true;
   FDesignButtonsPanel.Width:=FDesignButtonsPanelLength;
   ResizeControl;
end;   

procedure TDesignTabControl.GetDesignPaletteProc(PGDP: PGetDesignPalette);

  function GetCountByButtons: Integer;
  var
    j: Integer;
    PPB: PGetDesignPaletteButton;
  begin
    Result:=0;
    for j:=Low(PGDP.Buttons) to High(PGDP.Buttons) do begin
      PPB:=PGDP.Buttons[j];
      if isValidPointer(PPB.Cls)and(FTempInterface in PPB.UseForInterfaces) then begin
        Inc(Result);
      end;
    end;  
  end;

var
  val: Integer;
  j: Integer;
  PPB: PGetDesignPaletteButton;
  csp: TComponentSpeedButton;
  isAdd: Boolean;
  countb: Integer;
begin
  if not isValidPointer(PGDP) then exit;
  if not isValidPointer(PGDP.Buttons) then exit;
  isAdd:=false;
  countb:=GetCountByButtons;
  if countb=0 then exit;
  val:=Tabs.IndexOf(PGDP.Name);
  if val=-1 then begin
    Tabs.Add(PGDP.Name);
    if FUseFirstFill then begin
     isAdd:=true;
     FUseFirstFill:=false;
    end;
  end else begin
   if not FUseFirstFill then
    if val=TabIndex then
      isAdd:=true;
  end;
  if isAdd then begin
   for j:=Low(PGDP.Buttons) to High(PGDP.Buttons) do begin
     PPB:=PGDP.Buttons[j];
     if isValidPointer(PPB.Cls)and(FTempInterface in PPB.UseForInterfaces) then begin
       csp:=TComponentSpeedButton.Create(nil);
       csp.FDesignPageControl:=Self;
       csp.Cls:=PPB.Cls;
       csp.Flat:=true;
       csp.AllowAllUp:=false;
       csp.Caption:='';
       csp.Hint:=Trim(PPB.Hint+' ('+PPB.Cls.ClassName+')');
       csp.ShowHint:=true;
       csp.GroupIndex:=1;
       csp.parent:=FDesignButtonsPanel;
       csp.SetBounds(FDesignButtonsPanelLength,0,FDesignButtonsPanel.Height+1,FDesignButtonsPanel.Height);
       FDesignButtonsPanelLength:=csp.Left+csp.Width;

       if isValidPointer(PPB.Bitmap) then
        csp.Glyph.Assign(PPB.Bitmap)
       else csp.Glyph.Assign(FNotExistsBitmap);

       csp.Glyph.TransparentColor:=csp.Glyph.Canvas.Pixels[0,0];

       FButtons.Add(csp);
    end;
   end;
  end; 
end;

procedure TDesignTabControl.PackTabs;
begin
  if FButtons.Count=0 then begin

  end;
end;

procedure TDesignTabControl.FillDesignPalettes(TypeInterface: TTypeInterface);
begin
  Tabs.BeginUpdate;
  try
    ClearTabs;
    FDesignButtonsPanel.Width:=0;
    ClearButtons;
    FDesignButtonsPanelLength:=0;
    FUseFirstFill:=true;
    FTempInterface:=TypeInterface;
    _GetDesignPalettes(Owner,EditInterfaceGetDesignPaletteProc);
    PackTabs;
    FDesignSpeedButton.Down:=true;
    FDesignButtonsPanel.Width:=FDesignButtonsPanelLength;
    ResizeControl;
    if FSorted then SortTabs;
  finally
    Tabs.EndUpdate;
  end;
end;

procedure TDesignTabControl.ClearTabs;
begin
  Tabs.Clear;
end;

procedure TDesignTabControl.QuickSort(L, R: Integer);

 procedure ExchangeItems(Index1, Index2: Integer);
 var
  Item1str, Item2str: string;
  Item1obj, Item2obj: TObject;
 begin
  Item1str:=Tabs.Strings[Index1];
  Item1obj:=Tabs.Objects[Index1];
  Item2str:=Tabs.Strings[Index2];
  Item2obj:=Tabs.Objects[Index2];
  Tabs.Strings[Index1]:=Item2str;
  Tabs.Objects[Index1]:=Item2obj;
  Tabs.Strings[Index2]:=Item1str;
  Tabs.Objects[Index2]:=Item1obj;
 end;

var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while AnsiCompareText(Tabs.Strings[I],Tabs.Strings[P]) < 0 do Inc(I);
      while AnsiCompareText(Tabs.Strings[J],Tabs.Strings[P]) > 0 do Dec(J);
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
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure TDesignTabControl.SortTabs;
begin
  if (Tabs.Count > 1) then
  begin
    QuickSort(0, Tabs.Count - 1);
  end;
end;

procedure TDesignTabControl.WMSize(var Message: TMessage);
begin
  inherited;
end;

function GetComponentSpeedButtonDown(ButtonsList: TList): TComponentSpeedButton;
var
  csp: TComponentSpeedButton;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to ButtonsList.Count-1 do begin
    csp:=TComponentSpeedButton(ButtonsList.Items[i]);
    if csp.Down then begin
      Result:=csp;
      exit;
    end;
  end;
end;

function TDesignTabControl.GetComponentClass: TComponentClass;
var
  csp: TComponentSpeedButton;
begin
  Result:=nil;
  if FDesignSpeedButton.Down then exit;
  csp:=GetComponentSpeedButtonDown(FButtons);
  if csp=nil then exit;
  if isClassParent(csp.Cls,TComponent) then begin
   Result:=TComponentClass(csp.Cls);
  end else begin
   Result:=nil;
  end;
end;

procedure TDesignTabControl.GetDesignPaletteProcForGetComponentClass(PGDP: PGetDesignPalette);
var
  j: Integer;
  PPB: PGetDesignPaletteButton;
begin
  if not FGetComponentClassBitmap.Empty then exit;
  if not isValidPointer(PGDP) then exit;
  for j:=Low(PGDP.Buttons) to High(PGDP.Buttons) do begin
    PPB:=PGDP.Buttons[j];
    if isValidPointer(PPB) then
     if PPB.Cls=FGetComponentClass then
      if isValidPointer(PPB.Bitmap) then begin
       FGetComponentClassBitmap.Assign(PPB.Bitmap);
       exit;
      end; 
  end;
end;

function TDesignTabControl.GetComponentGlyph(Cls: TClass): TBitmap;
begin
  FGetComponentClass:=Cls;
  FGetComponentClassBitmap.Assign(nil);
  _GetDesignPalettes(Owner,EditInterfaceGetDesignPaletteProcForGetComponentClass);
  if FGetComponentClassBitmap.Empty then
   Result:=FNotExistsBitmap
  else Result:=FGetComponentClassBitmap;
end;

procedure TDesignTabControl.SetDefaultButtonDown(Value: Boolean);
var
  i: Integer;
  csp: TComponentSpeedButton;
begin
  FDesignSpeedButton.AllowAllUp:=true;
  FDesignSpeedButton.Down:=Value;
  FDesignSpeedButton.AllowAllUp:=false;
  for i:=0 to FButtons.Count-1 do begin
    csp:=TComponentSpeedButton(FButtons.Items[i]);
    csp.AllowAllUp:=true;
    if i=0 then csp.Down:=not Value
    else csp.Down:=false;
    csp.AllowAllUp:=false;
  end;
end;

function TDesignTabControl.GetDefaultButtonDown: Boolean;
begin
  Result:=FDesignSpeedButton.Down;
end;

procedure TDesignTabControl.DrawTab(ATabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  tabRt: TRect;
begin
 inherited;
 with Canvas do begin
   Pen.Color := clBtnHighlight;
   tabRt:=TabRect(TabIndex);
   OffsetRect(tabRt,0,-1);
   MoveTo(tabRt.Left, tabRt.Top);
   LineTo(tabRt.Right, tabRt.Top);
 end;
end;

procedure TDesignTabControl.ResizeControl;
var
  i,L: Integer;
begin
  if Parent<>nil then begin
   SetBounds(-1,-1,Parent.Width+3,Parent.Height+5);
   FDesignSpeedButton.Height:=FDesignPageScroller.Height;
   FDesignSpeedButton.Width:=FDesignSpeedButton.Height+1;
   FDesignSpeedButtonPanel.Width:=FDesignSpeedButton.Width+5;
   FDesignButtonsPanel.Height:=FDesignPageScroller.Height;
   L:=0;
   for i:=0 to FButtons.Count-1 do begin
     TComponentSpeedButton(FButtons.Items[i]).SetBounds(L,0,FDesignButtonsPanel.Height+1,FDesignButtonsPanel.Height);
     L:=TComponentSpeedButton(FButtons.Items[i]).Left+TComponentSpeedButton(FButtons.Items[i]).Width;
   end;
   FDesignButtonsPanel.Left:=FDesignPageScroller.ButtonSize;
   FDesignButtonsPanel.Width:=FButtons.Count*FDesignPageScroller.Height;
  end;
end;

procedure TDesignTabControl.SetSorted(Value: Boolean);
begin
  FSorted:=Value;
end;

{ TtsvComboTreeView }

function TtsvComboTreeView.GetSelectedNode: TTreeNode;
begin
  Result:=inherited SelectedNode;
end;

procedure TtsvComboTreeView.SetSelectedNode(Value: TTreeNode);
begin
  if FDesignObjInsp.FObjInsp.Selections.Count<=1 then
    inherited SelectedNode:=Value
  else if FDesignObjInsp.FObjInsp.Selections.Count>1 then
    inherited SelectedNode:=nil;
end;

{ TDesignObjInsp }

constructor TDesignObjInsp.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited CreateNew(AOwner,Dummy);

  OnStartDock:=LocalStartDock;
  OnGetSiteInfo:=LocalGetSiteInfo;
  OnEndDock:=LocalEndDock;
  OnDockOver:=LocalDockOver;
  OnKeyDown:=LocalKeyDown;


  DragKind:=dkDock;
  DragMode:=dmAutomatic;
  FormStyle:=fsStayOnTop;
  BorderStyle:=bsSizeToolWin;
  Caption:=DesignObjInspCaption;
  Width:=200;
  Height:=300;
  Left:=Screen.Width-Width-10;
  Top:=Screen.Height div 2 - Height div 2;
  Constraints.MinHeight:=200;
  Constraints.MinWidth:=100;
  KeyPreview:=true;

  FObjTV:=TtsvComboTreeView.Create(nil);
  FObjTV.FDesignObjInsp:=Self;
  FObjTV.Align:=alTop;
  FObjTV.Parent:=Self;
  FObjTV.Cursor:=crArrow;
  FObjTV.HotTrack:=true;
  FObjTV.OnChanged:=ObjTVOnChanged;

  FTabProp:=TTabControl.Create(nil);
  FTabProp.Align:=alClient;
  FTabProp.Parent:=Self;
  FTabProp.HotTrack:=true;
  FTabProp.TabStop:=false;
  FTabProp.Tabs.Add(DesignObjInspTabProp);
  FTabProp.Tabs.Add(DesignObjInspTabMet);
  FTabProp.OnChange:=TabPropChange;

  FTranslateMemo:=TMemo.Create(nil);
  FTranslateMemo.Parent:=FTabProp;
  FTranslateMemo.ReadOnly:=true;
  FTranslateMemo.Height:=30;
  FTranslateMemo.Constraints.MinHeight:=30;
  FTranslateMemo.Align:=alBottom;
  FTranslateMemo.Color:=clBtnFace;
  FTranslateMemo.BorderStyle:=bsNone;

  FTranslateSplitter:=TSplitter.Create(nil);
  FTranslateSplitter.Parent:=FTabProp;
  FTranslateSplitter.Align:=alBottom;
  FTranslateSplitter.MinSize:=50;
  FTranslateSplitter.Cursor:=crSizeNS;

  FObjInsp:=TZPropList.Create(nil);
  FObjInsp.Parent:=FTabProp;
  FObjInsp.Align:=alClient;
  FObjInsp.Filter:=tkProperties;
  FObjInsp.OnChange:=ObjInspOnChange;
  FObjInsp.OnChanging:=ObjInspOnChanging;
  FObjInsp.Middle:=Width div 2;
  FObjInsp.Constraints.MinHeight:=50;
  FObjInsp.OnHint:=ObjInspOnHint;
  FObjInsp.OnInitCurrent:=ObjInspOnInitCurrent;

  PanelHintVisible:=false;
end;

destructor TDesignObjInsp.Destroy;
begin
  if FDesignScrollBox<>nil then
     FDesignScrollBox.FDesignObjInsp:=nil;
  FObjInsp.CurObj:=nil;     
  FObjInsp.Free;
  FTranslateMemo.Free;
  FTranslateSplitter.Free;
  FTabProp.Free;
  FObjTV.Free;
  inherited;
end;

function TDesignObjInsp.GetPanelHintVisible: Boolean;
begin
  Result:=FTranslateMemo.Visible;
end;

procedure TDesignObjInsp.SetPanelHintVisible(Value: Boolean);
begin
  FTranslateMemo.Visible:=Value;
  FTranslateSplitter.Visible:=Value;
end;

procedure TDesignObjInsp.TabPropChange(Sender: TObject);
begin
  case FTabProp.TabIndex of
    0: FObjInsp.Filter:=tkProperties;
    1: FObjInsp.Filter:=[tkMethod];
  end;
end;

function TDesignObjInsp.GetNodeFromData(Data: Pointer): TTreeNode;
var
  i: Integer;
  nd: TTreeNode;
begin
  Result:=nil;
  for i:=0 to FObjTV.Items.Count-1 do begin
    nd:=FObjTV.Items.Item[i];
    if nd.Data=Data then begin
      Result:=nd;
      exit;
    end;
  end;
end;

function TDesignObjInsp.GenerateNodeName(Obj: TObject): string;
var
  sname: string;
begin
   if Obj is TComponent then begin
    sname:=TComponent(Obj).Name;
    if Obj is TForm then begin
     Result:=Format('%s: T%s',[sname,sname]);
    end else begin
     Result:=Format('%s: %s',[sname,TComponent(Obj).ClassName]);
    end; 
   end else begin
    Result:=Format('$%p: %s',[Pointer(Obj),TComponent(Obj).ClassName]);
   end;
end;

procedure TDesignObjInsp.SetObject(Obj: TObject; Flag: Boolean; NotView: Boolean=false);
var
  nd: TTreeNode;
  ndNew,ndParent: TTreeNode;
  fm: TDesignForm;
begin
  if (Obj is TDesignComponent) then exit;
  nd:=GetNodeFromData(Obj);

  if nd=nil then begin
    if Obj is TDesignForm then begin
      fm:=TDesignForm(Obj);
      ndNew:=FObjTV.Items.AddChildObject(nil,GenerateNodeName(fm),fm);
      ndNew.ImageIndex:=DesignObjInspImageIndexForm;
      ndNew.SelectedIndex:=ndNew.ImageIndex;
      FObjTV.SelectedNode:=ndNew;
    end else begin
      if Obj is TControl then begin
        ndParent:=GetNodeFromData(TControl(obj).Parent);
        ndNew:=FObjTV.Items.AddChildObject(ndParent,GenerateNodeName(obj),obj);
        FObjTV.SelectedNode:=ndNew;
        ndNew.ImageIndex:=DesignObjInspImageIndexControl;
        ndNew.SelectedIndex:=ndNew.ImageIndex;
      end else begin
        if Obj is TComponent then begin
          ndParent:=GetNodeFromData(TComponent(Obj).Owner);
          ndNew:=FObjTV.Items.AddChildObject(ndParent,GenerateNodeName(obj),obj);
          FObjTV.SelectedNode:=ndNew;
          ndNew.ImageIndex:=DesignObjInspImageIndexComponent;
          ndNew.SelectedIndex:=ndNew.ImageIndex;
        end else begin
          if Obj is TCollectionItem then begin
           FObjTV.SelectedNode:=nil;
           FObjTV.Text:=TCollectionItem(Obj).GetNamePath;
          end else
            FObjTV.SelectedNode:=nd;
        end;
      end;
    end;
  end else begin
   if Flag then begin
    if FDesignScrollBox<>nil then begin
      if not (obj is TDesignForm) then begin
       if obj is TControl then begin
         fm:=TDesignForm(GetParentForm(TControl(obj)));
         if (fm<>nil)and (not NotView) then fm.ViewComponent(TControl(obj));
        end else begin
         fm:=TDesignForm(TComponent(Obj).Owner);
         if (fm<>nil)and (not NotView) then fm.ViewComponent(TComponent(obj));
        end;
      end else begin
       fm:=TDesignForm(obj);
       if (fm<>nil)and (not NotView) then fm.ViewComponent(nil);
      end;
    end;
   end else begin
     //
   end;
   FObjTV.SelectedNode:=nd;
  end;

  FObjInsp.CurObj:=Obj;
end;

procedure TDesignObjInsp.RemoveObject(Obj: TObject);
var
  nd: TTreeNode;
begin
  nd:=GetNodeFromData(Obj);
  if nd=nil then exit;
  nd.Delete;
  FObjInsp.CurObj:=nil;
  FObjTV.SelectedNode:=nil;
end;

procedure TDesignObjInsp.ObjTVOnChanged(Sender: TObject; Node: TTreeNode);
begin
  if Node=nil then exit;
  if Node.Data=nil then exit;
  SetObject(Node.Data,true);
end;

procedure TDesignObjInsp.ObjInspOnChange(Sender: TZPropList; Prop: TPropertyEditor);
var
  tmps: string;
  nd: TTreeNode;
  dc: TDesignComponentEx;
begin
  tmps:=Prop.GetPropType.Name;
  if FDesignScrollBox.FActiveDesignForm<>nil then begin
    FDesignScrollBox.FActiveDesignForm.ChangeFlag:=true;
  end;
  if tmps=DesignObjInspCheckClassName then begin
    nd:=GetNodeFromData(FObjInsp.CurObj);
    if nd<>nil then begin
      nd.Text:=GenerateNodeName(FObjInsp.CurObj);
      FObjTV.SelectedNode:=nd;
    end;
    if not (FObjInsp.CurObj is TControl) then
     if FObjInsp.CurObj is TComponent then
      if FDesignScrollBox.FActiveDesignForm<>nil then begin
        dc:=TDesignComponentEx(FDesignScrollBox.FActiveDesignForm.FELDesigner.GetDesignComponent(TComponent(FObjInsp.CurObj)));
        if dc<>nil then begin
          dc.EditLabel.Caption:=Prop.Value;
        end;
      end;
  end;
end;

function TDesignObjInsp.ifExistsFormByName(inName: string): Boolean;
begin
  Result:=false;
  if FDesignScrollBox<>nil then
    Result:=FDesignScrollBox.ifExistsFormByName(inName);
end;

procedure TDesignObjInsp.ObjInspOnChanging(Sender: TZPropList; Prop: TPropertyEditor;
                                           var CanChange: Boolean; const Value: string);
var
  tmps: string;
  nd: TTreeNode;
begin
  tmps:=Prop.GetPropType.Name;
  if tmps=DesignObjInspCheckClassName then begin
    nd:=GetNodeFromData(FObjInsp.CurObj);
    if nd<>nil then begin
     if Trim(Value)='' then begin
       CanChange:=false;
       raise EComponentError.Create(DesignObjInspInvalidEmptyName);
     end;
     if FObjInsp.CurObj is TForm then
        CanChange:=not ifExistsFormByName(Value);
     if not CanChange then
       raise EComponentError.CreateResFmt(@SDuplicateName, [Value]);
    end;
  end;
end;

procedure TDesignObjInsp.ObjInspOnHint(Sender: TZPropList; Prop: TPropertyEditor; HintInfo: PHintInfo);
begin
end;

procedure TDesignObjInsp.ObjInspOnInitCurrent(Sender: TZPropList; const PropName: String);
begin
  if Trim(PropName)<>'' then
   FTranslateMemo.Lines.Text:=Sender.TranslateList.GetTranslate(PropName)
  else FTranslateMemo.Lines.Text:='';
end;

procedure TDesignObjInsp.LocalStartDock(Sender: TObject; var DragObject: TDragDockObject);
{var
  ARect: TRect;}
begin
{  if Parent=nil then exit;
  ARect:=Rect(0,0,Parent.Width,Parent.Height);
  Width:=Parent.Width;
  if DragObject<>nil then
    DragObject.DockRect := ARect;}
// DragObject:=TToolDockObject.Create(TControl(Sender));
// ShowMessage('StartDock');
end;

procedure TDesignObjInsp.LocalGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
//  ShowMessage('DockGetSiteInfo');
//  CanDock := DockClient is TDesignObjInsp;
end;

procedure TDesignObjInsp.LocalEndDock(Sender, Target: TObject; X, Y: Integer);
begin
 //ShowMessage('EndDock');
end;

procedure TDesignObjInsp.LocalDockOver(Sender: TObject; Source: TDragDockObject;
                   X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
// ShowMessage('DockOver');
end;

procedure TDesignObjInsp.LocalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if FDesignScrollBox<>nil then
    FDesignScrollBox.DoKeyDown(Sender,Key,Shift);  
end;

function TDesignObjInsp.GetImageList: TCustomImageList;
begin
  Result:=FObjTV.Images;
end;

procedure TDesignObjInsp.SetImageList(Value: TCustomImageList);
begin
  FObjTV.Images:=Value;
end;

function TDesignObjInsp.GetTranslated: Boolean;
begin
  Result:=FObjInsp.Translated;
end;

procedure TDesignObjInsp.SetTranslated(Value: Boolean);
begin
  FObjInsp.Translated:=Value;
end;

function TDesignObjInsp.GetSorted: Boolean;
begin
  Result:=FObjInsp.Sorted;
end;

procedure TDesignObjInsp.SetSorted(Value: Boolean);
begin
  FObjInsp.Sorted:=Value;
end;

procedure TDesignObjInsp.GetDesignPropertyTranslateProc(PGDPT: PGetDesignPropertyTranslate);
begin
  if not isValidPointer(PGDPT) then exit;
  FObjInsp.TranslateList.Add(PGDPT.Real,PGDPT.Translate);
end;

procedure TDesignObjInsp.FillDesignPropertyTranslates;
begin
  FObjInsp.TranslateList.BeginUpdate;
  try
    FObjInsp.TranslateList.Clear;
   _GetDesignPropertyTranslates(Owner,EditInterfaceGetDesignPropertyTranslateProc);
  finally
    FObjInsp.TranslateList.EndUpdate;
  end; 
end;

procedure TDesignObjInsp.GetDesignPropertyRemoveProc(PGDPR: PGetDesignPropertyRemove);
begin
  if not isValidPointer(PGDPR) then exit;
  FObjInsp.RemoveList.AddObject(PGDPR.Name,TObject(PGDPR.Cls));
end;

procedure TDesignObjInsp.FillDesignPropertyRemoves;
begin
  FObjInsp.RemoveList.BeginUpdate;
  try
    FObjInsp.RemoveList.Clear;
    _GetDesignPropertyRemoves(Owner,EditInterfaceGetDesignPropertyRemoveProc);
  finally
    FObjInsp.RemoveList.EndUpdate;
  end;
end;


////////////////////////////////////////////

procedure ClearListHintDesignCommand;
var
  i: Integer;
  P: PInfoHintDesignCommand;
begin
  for i:=0 to ListHintDesignCommand.Count-1 do begin
    P:=ListHintDesignCommand.Items[i];
    Dispose(P);
  end;
  ListHintDesignCommand.Clear;
end;

procedure AddToListHintDesignCommand(AHint: String; ACommand: TDesignCommand);
var
  P: PInfoHintDesignCommand;
begin
  New(P);
  P.Hint:=AHint;
  P.Command:=ACommand;
  ListHintDesignCommand.Add(P);
end;

function GetHintDesignCommand(ACommand: TDesignCommand; Default: string=''):String;
var
  i: Integer;
  P: PInfoHintDesignCommand;
begin
  Result:=Default;
  for i:=0 to ListHintDesignCommand.Count-1 do begin
   P:=ListHintDesignCommand.Items[i];
   if P.Command=ACommand then begin
     Result:=P.Hint;
     exit;
   end;
  end;
end;

function GetHintWithShortCutFromDesignCommand(DSB: TDesignScrollBox;
             ACommand: TDesignCommand; Default: string):String;
var
  AList: TList;
  tmps: string;
  P: PDesignKeyboard;
  i: Integer;
begin
  Result:=Default;
  if DSB=nil then exit;
  AList:=TList.Create;
  try
    DSB.DesignListKeyboard.GetDesignKeyboardFromCommand(ACommand,AList);
    for i:=0 to AList.Count-1 do begin
      P:=AList.Items[i];
      if i=0 then tmps:=ShortCutToText(ShortCut(P.Key,P.Shift))
      else tmps:=tmps+', '+ShortCutToText(ShortCut(P.Key,P.Shift));
    end;
    if Trim(tmps)<>'' then
      Result:=GetHintDesignCommand(ACommand,Default)+' ('+tmps+')';
  finally
    AList.Free;
  end;
end;

function GetShortCutFromDesignCommand(DSB: TDesignScrollBox; ACommand: TDesignCommand): TShortCut;
var
  AList: TList;
  P: PDesignKeyboard;
  i: Integer;
begin
  Result:=0;
  if DSB=nil then exit;
  AList:=TList.Create;
  try
    DSB.DesignListKeyboard.GetDesignKeyboardFromCommand(ACommand,AList);
    for i:=0 to AList.Count-1 do begin
      P:=AList.Items[i];
      Result:=ShortCut(P.Key,P.Shift);
      exit;
    end;
  finally
    AList.Free;
  end;
end;             


initialization
  ListHintDesignCommand:=TList.Create;
  AddToListHintDesignCommand(ConstdkcNewForm,dkcNewForm);
  AddToListHintDesignCommand(ConstdkcOpenForm,dkcOpenForm);
  AddToListHintDesignCommand(ConstdkcSaveForm,dkcSaveForm);
  AddToListHintDesignCommand(ConstdkcSaveFormsToBase,dkcSaveFormsToBase);
  AddToListHintDesignCommand(ConstdkcCutComponents,dkcCutComponents);
  AddToListHintDesignCommand(ConstdkcCopyComponents,dkcCopyComponents);
  AddToListHintDesignCommand(ConstdkcPasteComponents,dkcPasteComponents);
  AddToListHintDesignCommand(ConstdkcDeleteComponents,dkcDeleteComponents);
  AddToListHintDesignCommand(ConstdkcSelectAllComponents,dkcSelectAllComponents);
  AddToListHintDesignCommand(ConstdkcAlignToGridComponents,dkcAlignToGridComponents);
  AddToListHintDesignCommand(ConstdkcBringToFrontComponents,dkcBringToFrontComponents);
  AddToListHintDesignCommand(ConstdkcSendToBackComponents,dkcSendToBackComponents);
  AddToListHintDesignCommand(ConstdkcLocksNoDeleteComponents,dkcLocksNoDeleteComponents);
  AddToListHintDesignCommand(ConstdkcLocksNoMoveComponents,dkcLocksNoMoveComponents);
  AddToListHintDesignCommand(ConstdkcLocksNoResizeComponents,dkcLocksNoResizeComponents);
  AddToListHintDesignCommand(ConstdkcLocksNoInsertInComponents,dkcLocksNoInsertInComponents);
  AddToListHintDesignCommand(ConstdkcLocksNoCopyComponents,dkcLocksNoCopyComponents);
  AddToListHintDesignCommand(ConstdkcLocksClerComponents,dkcLocksClerComponents);
  AddToListHintDesignCommand(ConstdkcViewObjInsp,dkcViewObjInsp);
  AddToListHintDesignCommand(ConstdkcViewAlignPalette,dkcViewAlignPalette);
  AddToListHintDesignCommand(ConstdkcViewTabOrder,dkcViewTabOrder);
  AddToListHintDesignCommand(ConstdkcViewOptions,dkcViewOptions);
  AddToListHintDesignCommand(ConstdkcShowPopup,dkcShowPopup);
  AddToListHintDesignCommand(ConstdkcViewScript,dkcViewScript);
  AddToListHintDesignCommand(ConstdkcRunScript,dkcRunScript);
  AddToListHintDesignCommand(ConstdkcResetScript,dkcResetScript);

finalization
  ClearListHintDesignCommand;
  ListHintDesignCommand.Free;


end.
