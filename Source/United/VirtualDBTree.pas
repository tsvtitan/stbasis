{——————————————————————————————————————————————————————————————————————————————-
 22-OCT-2001 Vadim Sedulin
 - TBaseVirtualDBTree::GoTo TBaseVirtualDBTree.GoToRec
 - TBaseVirtualDBTree::Update TBaseVirtualDBTree.UpdateTree

 23-OCT-2001 Adem Baba
  - I haven't done much other than to reorganize the code so that it is now one
    unit as oppsed to two units it originally was. I believe this is justifiable
    since this code is about 2,000 lines, there is, IMHO, no need to split them.
    Just look at VirtualTrees's line count --easily over 20,000 lines in a single
    unit.

  - I have removed all comments from the original code since they were Cyrillic,
      and they would have lost a lot in translation especially since I do not
      know Russian at all (I am only assuming they were Russian) :-)

  - I have renamed TSimpleVirtualDBTree to TVirtualDBTree. I believe it reflects
    its purpose better.

  - I have also merged the code in TCustomSimpleVirtualDBTree into TBaseVirtualDBTree;
    since everything else is derived from TBaseVirtualDBTree.

  - I got rid of TCheckDataLink, in favor of TVirtualDBTreeDataLink (which is
    renamed from TVTDataLink). There was no need for two descendants of TDataLink.

  - Finally, I have renamed the resultant file VirtualDBTree.

  Things to do:
    - Check to see if we really need these classes separately:
      TCustomCheckVirtualDBTree and TCheckVirtualDBTree. It looks as if they should
      be merged into a single class.

    - DCRs must be designed for
        - TVirtualDBTree,
        - TDBCheckVirtualDBTree,
        - TCheckVirtualDBTree

    - A demo. A demo is badly needed. I hope someone does come along and do it,
      as I am simply hopeless with those things.
 ——————————————————————————————————————————————————————————————————————————————}

Unit VirtualDBTree;

Interface

Uses
  Windows,
  Classes,
  Controls,
  ActiveX,
  DB,
  VirtualTrees;

Type
  TDBVTOption = (
    dboAllowChecking,
    dboAllowStructureChange,
    dboAlwaysStructured,
    dboCheckChildren,
    dboCheckDBStructure,
    dboListView,
    dboParentStructure,
    dboPathStructure,
    dboReadOnly,
    dboShowChecks,
    dboTrackActive,
    dboTrackChanges,
    dboTrackCursor,
    dboViewAll,
    dboWriteLevel,
    dboWriteSecondary
    );
  TDBVTOptions = Set Of TDBVTOption;

  TDBVTStatus = (
    dbtsChanged,
    dbtsChecking,
    dbtsDataChanging,
    dbtsDataOpening,
    dbtsDragDrop,
    dbtsEditing,
    dbtsEmpty,
    dbtsInsert,
    dbtsStructured,
    dbtsToggleAll
    );
  TDBVTStatuses = Set Of TDBVTStatus;

  TDBVTChangeMode = (
    dbcmEdit,
    dbcmInsert,
    dbcmStructure
    );

  TDBVTGoToMode = (
    gtmFromFirst,
    gtmNext,
    gtmPrev
    );

  TDBVTNodeStatus = (
    dbnsDelete,
    dbnsEdit,
    dbnsInited,
    dbnsNew,
    dbnsNone,
    dbnsRefreshed
    );

  PDBVTData = ^TDBVTData;
  TDBVTData = Record
    ID: Integer;
    Level: Integer;
    Status: TDBVTNodeStatus;
    Parent: PVirtualNode;
  End;

  TBaseVirtualDBTree = Class;
  TVirtualDBTreeDataLink = Class;

  TVTDBOpenQueryEvent = Procedure(Sender: TBaseVirtualDBTree; Var Allow: Boolean) Of Object;
  TVTDBWriteQueryEvent = Procedure(Sender: TBaseVirtualDBTree; Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean) Of Object;
  TVTNodeDataChangedEvent = Procedure(Sender: TBaseVirtualDBTree; Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean) Of Object;
  TVTNodeFromDBEvent = Procedure(Sender: TBaseVirtualDBTree; Node: PVirtualNode) Of Object;
  TVTPathToDBEvent = Procedure(Sender: TBaseVirtualDBTree; Var Path: String) Of Object;

  TVirtualDBTreeDataLink = Class(TDataLink)
  Private
    FVirtualDBTree: TBaseVirtualDBTree;
  Public
    Constructor Create(ATree: TBaseVirtualDBTree); Virtual;
  Protected
    Procedure ActiveChanged; Override;
    Procedure DataSetChanged; Override;
    Procedure DataSetScrolled(Distance: Integer); Override;
    Procedure EditingChanged; Override;
    Procedure RecordChanged(Field: TField); Override;
  End;

  TBaseVirtualDBTree = Class(TCustomVirtualStringTree)
  Private
    FCurID: Integer;
    FDBDataSize: Integer;
    FDBOptions: TDBVTOptions;
    FDBStatus: TDBVTStatuses;
    FDataLink: TVirtualDBTreeDataLink;
    FKeyField: TField;
    FKeyFieldName: String;
    FLevelField: TField;
    FLevelFieldName: String;
    FMaxLevel: Integer;
    FOnNodeDataChanged: TVTNodeDataChangedEvent;
    FOnOpeningDataSet: TVTDBOpenQueryEvent;
    FOnReadNodeFromDB: TVTNodeFromDBEvent;
    FOnReadPathFromDB: TVTPathToDBEvent;
    FOnWritePathToDB: TVTPathToDBEvent;
    FOnWritingDataSet: TVTDBWriteQueryEvent;
    FParentField: TField;
    FParentFieldName: String;
    FPathField: TField;
    FPathFieldName: String;
    FViewField: TField;
    FViewFieldName: String;
    Function GetDBNodeDataSize: Integer;
    Function GetDBOptions: TDBVTOptions;
    Function GetDBStatus: TDBVTStatuses;
    Function GetDataSource: TDataSource;
    Procedure RefreshListNode;
    Procedure RefreshNodeByParent;
    Procedure RefreshNodeByPath;
    Procedure SetDBNodeDataSize(Value: Integer);
    Procedure SetDBOptions(Value: TDBVTOptions);
    Procedure SetDataSource(Value: TDataSource);
    Procedure SetKeyFieldName(Const Value: String);
    Procedure SetLevelFieldName(Const Value: String);
    Procedure SetParentFieldName(Const Value: String);
    Procedure SetPathFieldName(Const Value: String);
    Procedure SetViewFieldName(Const Value: String);
  Protected
    Function CanEdit(Node: PVirtualNode; Column: Integer): Boolean; Override;
    Function CanOpenDataSet: Boolean; Virtual;
    Function CanWriteToDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode): Boolean; Virtual;
    Function DoCancelEdit: Boolean; Override;
    Function DoChecking(Node: PVirtualNode; Var NewCheckState: TCheckState): Boolean; Override;
    Function DoEndEdit: Boolean; Override;
    Function FindChild(Node: PVirtualNode; ID: Integer): PVirtualNode;
    Function FindNode(Start: PVirtualNode; ID: Integer): PVirtualNode;
    Function HasVisibleChildren(Node: PVirtualNode): Boolean;
    Procedure DataLinkActiveChanged; Virtual;
    Procedure DataLinkChanged; Virtual;
    Procedure DataLinkEditingChanged; Virtual;
    Procedure DataLinkRecordChanged(Field: TField); Virtual;
    Procedure DataLinkScrolled; Virtual;
    Procedure DoChecked(Node: PVirtualNode); Override;
    Procedure DoCollapsed(Node: PVirtualNode); Override;
    Procedure DoDragDrop(Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; Var Effect: Integer; Mode: TDropMode); Override;
    Procedure DoEdit; Override;
    Procedure DoFocusChange(Node: PVirtualNode; Column: Integer); Override;
    Procedure DoFreeNode(Node: PVirtualNode); Override;
    Procedure DoInitNode(Parent, Node: PVirtualNode; Var InitStates: TVirtualNodeInitStates); Override;
    Procedure DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean); Virtual;
    Procedure DoNodeMoved(Node: PVirtualNode); Override;
    Procedure DoOpeningDataSet(Var Allow: Boolean); Virtual;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Virtual;
    Procedure DoReadPathFromDB(Var Path: String); Virtual;
    Procedure DoWritePathToDB(Var Path: String); Virtual;
    Procedure DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean); Virtual;
    Procedure InitFields; Virtual;
    Procedure Notification(AComponent: TComponent; Operation: TOperation); Override;
    Procedure ReadNodeFromDB(Node: PVirtualNode); Virtual;
    Procedure RefreshNode; Virtual;
    Procedure RefreshNodes;
    Procedure ResetFields; Virtual;
    Procedure SetFocusToNode(Node: PVirtualNode);
    Procedure ToggleListView;
    Procedure ToggleViewMode;
  Public
    Constructor Create(Owner: TComponent); Override;
    Destructor Destroy; Override;
    Function GetDBNodeData(Node: PVirtualNode): Pointer;
    Function GoToRec(ID: Integer): Boolean; Overload;
    Procedure AddNode(Parent: PVirtualNode);
    Procedure CheckAllChildren(Node: PVirtualNode);
    Procedure CollapseAll;
    Procedure DeleteSelection;
    Procedure ExpandAll;
    Procedure GoToRec(AString: WideString; Mode: TDBVTGoToMode); Overload;
    Procedure OnDragOverHandler(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; Var Effect: Integer; Var Accept: Boolean);
    Procedure UnCheckAll(Node: PVirtualNode; OnlyChildren: Boolean);
    Procedure UpdateTree;
    Property DBNodeDataSize: Integer Read GetDBNodeDataSize Write SetDBNodeDataSize;
    Property DBStatus: TDBVTStatuses Read GetDBStatus;
    Property KeyField: TField Read FKeyField;
    Property LevelField: TField Read FLevelField;
    Property OnNodeDataChanged: TVTNodeDataChangedEvent Read FOnNodeDataChanged Write FOnNodeDataChanged;
    Property OnReadNodeFromDB: TVTNodeFromDBEvent Read FOnReadNodeFromDB Write FOnReadNodeFromDB;
    Property ParentField: TField Read FParentField;
    Property PathField: TField Read FPathField;
    Property ViewField: TField Read FViewField;
  Published {Since all these properties are published for all descendants, we might as well publish them here and save whitespace}
    {$IFDEF COMPILER_5+}
    Property OnContextPopup;
    {$ENDIF COMPILER_5+}
    Property Align;
    Property Alignment;
    Property Anchors;
    Property AnimationDuration;
    Property AutoExpandDelay;
    Property AutoScrollDelay;
    Property AutoScrollInterval;
    Property Background;
    Property BackgroundOffsetX;
    Property BackgroundOffsetY;
    Property BevelEdges;
    Property BevelInner;
    Property BevelKind;
    Property BevelOuter;
    Property BevelWidth;
    Property BiDiMode;
    Property BorderStyle;
    Property BorderWidth;
    Property ButtonFillMode;
    Property ButtonStyle;
    Property ChangeDelay;
    Property CheckImageKind;
    Property ClipboardFormats;
    Property Color;
    Property Colors;
    Property Constraints;
    Property Ctl3D;
    Property CustomCheckImages;
    Property DBOptions: TDBVTOptions Read GetDBOptions Write SetDBOptions;
    Property DataSource: TDataSource Read GetDataSource Write SetDataSource;
    Property DefaultNodeHeight;
    Property DefaultPasteMode;
    Property DefaultText;
    Property DragHeight;
    Property DragImageKind;
    Property DragKind;
    Property DragMode;
    Property DragOperations;
    Property DragType;
    Property DragWidth;
    Property DrawSelectionMode;
    Property EditDelay;
    Property Enabled;
    Property Font;
    Property Header;
    Property HintAnimation;
    Property HintMode;
    Property HotCursor;
    Property Images;
    Property IncrementalSearch;
    Property IncrementalSearchDirection;
    Property IncrementalSearchStart;
    Property IncrementalSearchTimeout;
    Property Indent;
    Property KeyFieldName: String Read FKeyFieldName Write SetKeyFieldName;
    Property LevelFieldName: String Read FLevelFieldName Write SetLevelFieldName;
    Property LineMode;
    Property LineStyle;
    Property Margin;
    Property NodeAlignment;
    Property OnAfterCellPaint;
    Property OnAfterItemErase;
    Property OnAfterItemPaint;
    Property OnAfterPaint;
    Property OnBeforeCellPaint;
    Property OnBeforeItemErase;
    Property OnBeforeItemPaint;
    Property OnBeforePaint;
    Property OnChange;
    Property OnChecked;
    Property OnChecking;
    Property OnClick;
    Property OnCollapsed;
    Property OnCollapsing;
    Property OnColumnClick;
    Property OnColumnDblClick;
    Property OnColumnResize;
    Property OnCompareNodes;
    Property OnCreateDataObject;
    Property OnCreateDragManager;
    Property OnCreateEditor;
    Property OnDblClick;
    Property OnDragAllowed;
    Property OnDragDrop;
    Property OnEditCancelled;
    Property OnEdited;
    Property OnEditing;
    Property OnEndDock;
    Property OnEndDrag;
    Property OnEnter;
    Property OnExit;
    Property OnExpanded;
    Property OnExpanding;
    Property OnFocusChanged;
    Property OnFocusChanging;
    Property OnFreeNode;
    Property OnGetHelpContext;
    Property OnGetHint;
    Property OnGetImageIndex;
    Property OnGetLineStyle;
    Property OnGetPopupMenu;
    Property OnGetText;
    Property OnGetUserClipboardFormats;
    Property OnHeaderClick;
    Property OnHeaderDblClick;
    Property OnHeaderDragged;
    Property OnHeaderDragging;
    Property OnHeaderDraw;
    Property OnHeaderMouseDown;
    Property OnHeaderMouseMove;
    Property OnHeaderMouseUp;
    Property OnHotChange;
    Property OnIncrementalSearch;
    Property OnInitNode;
    Property OnKeyAction;
    Property OnKeyDown;
    Property OnKeyPress;
    Property OnKeyUp;
    Property OnLoadNode;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnNewText;
    Property OnOpeningDataSet: TVTDBOpenQueryEvent Read FOnOpeningDataSet Write FOnOpeningDataSet;
    Property OnPaintBackground;
    Property OnPaintText;
    Property OnReadPathFromDB: TVTPathToDBEvent Read FOnReadPathFromDB Write FOnReadPathFromDB;
    Property OnRenderOLEData;
    Property OnResetNode;
    Property OnResize;
    Property OnSaveNode;
    Property OnScroll;
    Property OnShortenString;
    Property OnStartDock;
    Property OnStartDrag;
    Property OnUpdating;
    Property OnWritePathToDB: TVTPathToDBEvent Read FOnWritePathToDB Write FOnWritePathToDB;
    Property OnWritingDataSet: TVTDBWriteQueryEvent Read FOnWritingDataSet Write FOnWritingDataSet;
    Property ParentBiDiMode;
    Property ParentColor Default False;
    Property ParentCtl3D;
    Property ParentFieldName: String Read FParentFieldName Write SetParentFieldName;
    Property ParentFont;
    Property ParentShowHint;
    Property PathFieldName: String Read FPathFieldName Write SetPathFieldName;
    Property PopupMenu;
    Property ScrollBarOptions;
    Property SelectionCurveRadius;
    Property ShowHint;
    Property StateImages;
    Property TabOrder;
    Property TabStop Default True;
    Property TextMargin;
    Property TreeOptions;
    Property ViewFieldName: String Read FViewFieldName Write SetViewFieldName;
    Property Visible;
    Property WantTabs;
  End;

  TVirtualDBTree = Class(TBaseVirtualDBTree)
  Private
    Function GetNodeText(Node: PVirtualNode): WideString;
    Procedure SetNodeText(Node: PVirtualNode; Const Value: WideString);
  Protected
    Function DoCompare(Node1, Node2: PVirtualNode; Column: Integer): Integer; Override;
    Procedure DoGetText(Node: PVirtualNode; Column: Integer; TextType: TVSTTextType; Var Text: WideString); Override;
    Procedure DoNewText(Node: PVirtualNode; Column: Integer; Text: WideString); Override;
    Procedure DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean); Override;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Override;
    Procedure DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean); Override;
  Public
    Constructor Create(Owner: TComponent); Override;
    Property Canvas;
    Property NodeText[Node: PVirtualNode]: WideString Read GetNodeText Write SetNodeText;
  End;

  TCustomDBCheckVirtualDBTree = Class(TBaseVirtualDBTree)
  Private
    FCheckDataLink: TVirtualDBTreeDataLink;
    FResultField: TField;
    FResultFieldName: String;
    Function GetCheckDataSource: TDataSource;
    Function GetCheckList: TStringList;
    Procedure SetCheckDataSource(Value: TDataSource);
    Procedure SetResultFieldName(Const Value: String);
  Protected
    Function DoChecking(Node: PVirtualNode; Var NewCheckState: TCheckState): Boolean; Override;
    Procedure CheckDataLinkActiveChanged; Virtual;
    Procedure DoChecked(Node: PVirtualNode); Override;
    Procedure DoOpeningDataSet(Var Allow: Boolean); Override;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Override;
    Procedure Notification(AComponent: TComponent; Operation: TOperation); Override;
  Public
    Constructor Create(Owner: TComponent); Override;
    Destructor Destroy; Override;
    Property CheckList: TStringList Read GetCheckList;
    Property ResultField: TField Read FResultField;
    Property CheckDataSource: TDataSource Read GetCheckDataSource Write SetCheckDataSource;
    Property ResultFieldName: String Read FResultFieldName Write SetResultFieldName;
  End;

  TDBCheckVirtualDBTree = Class(TCustomDBCheckVirtualDBTree)
  Private
    Function GetNodeText(Node: PVirtualNode): WideString;
    Procedure SetNodeText(Node: PVirtualNode; Const Value: WideString);
  Protected
    Function DoCompare(Node1, Node2: PVirtualNode; Column: Integer): Integer; Override;
    Procedure DoGetText(Node: PVirtualNode; Column: Integer; TextType: TVSTTextType; Var Text: WideString); Override;
    Procedure DoNewText(Node: PVirtualNode; Column: Integer; Text: WideString); Override;
    Procedure DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean); Override;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Override;
    Procedure DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean); Override;
  Public
    Constructor Create(Owner: TComponent); Override;
    Property Canvas;
    Property NodeText[Node: PVirtualNode]: WideString Read GetNodeText Write SetNodeText;
  Published
    Property CheckDataSource;
    Property ResultFieldName;
  End;

  TCustomCheckVirtualDBTree = Class(TBaseVirtualDBTree)
  Private
    FList: TStringList;
    Function GetCheckList: TStringList;
    Procedure SetCheckList(Value: TStringList);
  Protected
    Procedure DoChecked(Node: PVirtualNode); Override;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Override;
  Public
    Constructor Create(Owner: TComponent); Override;
    Destructor Destroy; Override;
    Property CheckList: TStringList Read GetCheckList Write SetCheckList;
  End;

  TCheckVirtualDBTree = Class(TCustomCheckVirtualDBTree)
  Private
    Function GetNodeText(Node: PVirtualNode): WideString;
    Procedure SetNodeText(Node: PVirtualNode; Const Value: WideString);
  Protected
    Function DoCompare(Node1, Node2: PVirtualNode; Column: Integer): Integer; Override;
    Procedure DoGetText(Node: PVirtualNode; Column: Integer; TextType: TVSTTextType; Var Text: WideString); Override;
    Procedure DoNewText(Node: PVirtualNode; Column: Integer; Text: WideString); Override;
    Procedure DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean); Override;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Override;
    Procedure DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean); Override;
  Public
    Constructor Create(Owner: TComponent); Override;
    Property Canvas;
    Property NodeText[Node: PVirtualNode]: WideString Read GetNodeText Write SetNodeText;
  End;

Procedure Register;

Implementation

Uses
  SysUtils,
  Math;

Procedure Register;
Begin
  RegisterComponents('Virtual Controls', [TVirtualDBTree, TDBCheckVirtualDBTree, TCheckVirtualDBTree]);
End;

Type
  THackedTreeOptions = Class(TCustomVirtualTreeOptions);
  TSimpleData = Record
    Text: WideString;
  End;
  PSimpleData = ^TSimpleData;

  {------------------------------------------------------------------------------}

Constructor TVirtualDBTreeDataLink.Create(ATree: TBaseVirtualDBTree);
Begin
  Inherited Create;
  FVirtualDBTree := ATree;
End;

Procedure TVirtualDBTreeDataLink.ActiveChanged;
Begin
  FVirtualDBTree.DataLinkActiveChanged;
End;

Procedure TVirtualDBTreeDataLink.DataSetScrolled(Distance: Integer);
Begin
  FVirtualDBTree.DataLinkScrolled;
End;

Procedure TVirtualDBTreeDataLink.DataSetChanged;
Begin
  FVirtualDBTree.DataLinkChanged;
End;

Procedure TVirtualDBTreeDataLink.RecordChanged(Field: TField);
Begin
  FVirtualDBTree.DataLinkRecordChanged(Field);
End;

Procedure TVirtualDBTreeDataLink.EditingChanged;
Begin
  FVirtualDBTree.DataLinkEditingChanged;
End;

{------------------------------------------------------------------------------}

Constructor TBaseVirtualDBTree.Create(Owner: TComponent);
Begin
  Inherited;
  FDataLink := TVirtualDBTreeDataLink.Create(Self);
  FDBDataSize := sizeof(TDBVTData);
  NodeDataSize := FDBDataSize;
  FDBOptions := [dboCheckDBStructure, dboParentStructure, dboWriteLevel, dboWriteSecondary, dboTrackActive, dboTrackChanges, dboTrackCursor, dboAlwaysStructured, dboViewAll];
  OnDragOver := OnDragOverHandler;
End;

Destructor TBaseVirtualDBTree.Destroy;
Begin
  FDataLink.Free;
  FDataLink:=nil;
  Inherited;
End;

Procedure TBaseVirtualDBTree.SetDataSource(Value: TDataSource);
Begin
  FDataLink.DataSource := Value;
  If Assigned(Value) Then Value.FreeNotification(Self);
End;

Function TBaseVirtualDBTree.GetDataSource: TDataSource;
Begin
  Result := FDataLink.DataSource;
End;

Procedure TBaseVirtualDBTree.Notification(AComponent: TComponent; Operation: TOperation);
Begin
  Inherited;
  If (Operation = opRemove) And Assigned(FDataLink) And (AComponent = DataSource) Then DataSource := Nil;
End;

Procedure TBaseVirtualDBTree.SetKeyFieldName(Const Value: String);
Begin
  If FKeyFieldName <> Value Then Begin
    FKeyFieldName := Value;
    If dboTrackActive In FDBOptions Then DataLinkActiveChanged
    Else Begin
      FDBStatus := FDBStatus + [dbtsChanged];
      FKeyField := Nil;
      If FDataLink.Active And (FKeyFieldName <> '') Then FKeyField := FDataLink.DataSet.FieldByName(FPathFieldName);
    End;
  End;
End;

Procedure TBaseVirtualDBTree.SetParentFieldName(Const Value: String);
Begin
  If (FParentFieldName <> Value) Then Begin
    FParentFieldName := Value;
    FParentField := Nil;
    If (dboParentStructure In FDBOptions) And (dboTrackActive In FDBOptions) Then Begin
      If Not (dboListView In FDBOptions) Then DataLinkActiveChanged
      Else If (dboAlwaysStructured In FDBOptions) Then DataLinkActiveChanged
      Else Begin
        FDBStatus := FDBStatus + [dbtsStructured];
        If FDataLink.Active And (FParentFieldName <> '') Then FParentField := FDataLink.DataSet.FieldByName(FParentFieldName);
      End;
    End Else Begin
      If Not (dboTrackActive In FDBOptions) Then FDBStatus := FDBStatus + [dbtsChanged];
      If FDataLink.Active And (FParentFieldName <> '') Then FParentField := FDataLink.DataSet.FieldByName(FParentFieldName);
    End;
  End;
End;

Procedure TBaseVirtualDBTree.SetPathFieldName(Const Value: String);
Begin
  If (FPathFieldName <> Value) Then Begin
    FPathFieldName := Value;
    FPathField := Nil;
    If (dboPathStructure In FDBOptions) And (dboTrackActive In FDBOptions) Then Begin
      If Not (dboListView In FDBOptions) Then DataLinkActiveChanged
      Else If (dboAlwaysStructured In FDBOptions) Then DataLinkActiveChanged
      Else Begin
        FDBStatus := FDBStatus + [dbtsStructured];
        If FDataLink.Active And (FPathFieldName <> '') Then FPathField := FDataLink.DataSet.FieldByName(FPathFieldName);
      End;
    End Else Begin
      If Not (dboTrackActive In FDBOptions) Then FDBStatus := FDBStatus + [dbtsChanged];
      If FDataLink.Active And (FPathFieldName <> '') Then FPathField := FDataLink.DataSet.FieldByName(FPathFieldName);
    End;
  End;
End;

Procedure TBaseVirtualDBTree.SetLevelFieldName(Const Value: String);
Begin
  If (FLevelFieldName <> Value) Then Begin
    FLevelFieldName := Value;
    FLevelField := Nil;
    If FDataLink.Active And (FLevelFieldName <> '') Then FLevelField := FDataLink.DataSet.FieldByName(FLevelFieldName);
  End;
End;

Procedure TBaseVirtualDBTree.DataLinkActiveChanged;
Begin
  If Not (csDesigning In ComponentState) Then Begin
    ResetFields;
    If (dboTrackActive In FDBOptions) Then Begin
      If FDataLink.Active Then InitFields;
      UpdateTree;
    End Else FDBStatus := FDBStatus + [dbtsChanged];
  End;
End;

Procedure TBaseVirtualDBTree.DataLinkScrolled;
Var
  KeyID: Integer;
Begin
  If Not (csDesigning In ComponentState) Then Begin
    If Assigned(FKeyField) And Not (dbtsDataChanging In FDBStatus) And (dboTrackCursor In FDBOptions) Then Begin
      FDBStatus := FDBStatus + [dbtsDataChanging];
      KeyID := FKeyField.AsInteger;
      If (KeyID <> 0) And (KeyID <> FCurID) Then SetFocusToNode(FindNode(Nil, KeyID));
      FDBStatus := FDBStatus - [dbtsDataChanging];
      If Not Assigned(FocusedNode) Then SetFocusToNode(GetFirst);
    End;
  End;
End;

Procedure TBaseVirtualDBTree.DataLinkChanged;
Begin
  If Not (csDesigning In ComponentState) Then Begin
    If Not FDataLink.Editing And Not (dbtsDataChanging In FDBStatus) Then Begin
      If (dboTrackChanges In FDBOptions) Then RefreshNodes
      Else FDBStatus := FDBStatus + [dbtsChanged];
    End;
  End;
End;

Procedure TBaseVirtualDBTree.DataLinkRecordChanged(Field: TField);
Var
  UpdateField: Boolean;
  Node: PVirtualNode;
Begin
  If Not (csDesigning In ComponentState) Then Begin
    If Assigned(Field) And (dboTrackChanges In FDBOptions) Then Begin
      UpdateField := False;
      If dboTrackCursor In FDBOptions Then Node := FocusedNode
      Else Node := FindNode(Nil, FKeyField.AsInteger);
      If Assigned(Node) Then Begin
        DoNodeDataChanged(Node, Field, UpdateField);
        If UpdateField Then InvalidateNode(Node);
      End;
    End;
  End;
End;

Procedure TBaseVirtualDBTree.DataLinkEditingChanged;
Var
  Data: PDBVTData;
  Node: PVirtualNode;
Begin
  If Not (csDesigning In ComponentState) Then Begin
    If FDataLink.Editing And Not (dbtsEditing In FDBStatus) And Not (dbtsInsert In FDBStatus) Then Begin
      If dboTrackChanges In FDBOptions Then Begin
        If (dboTrackCursor In FDBOptions) And (FDataLink.DataSet.State = dsEdit) Then Begin
          If Assigned(FocusedNode) And (dboTrackCursor In FDBOptions) Then Begin
            Data := GetNodeData(FocusedNode);
            Data.Status := dbnsEdit;
          End;
        End Else If FDataLink.DataSet.State = dsInsert Then Begin
          Node := AddChild(Nil);
          ValidateNode(Node, False);
          Data := GetNodeData(Node);
          Data.ID := 0;
          Data.Level := 0;
          Data.Parent := Nil;
          Data.Status := dbnsInited;
          ReadNodeFromDB(Node);
          Data.Status := dbnsNew;
          If (dboTrackCursor In FDBOptions) Then SetFocusToNode(Node);
        End;
      End Else FDBStatus := FDBStatus + [dbtsChanged];
    End;
    If Assigned(FocusedNode) And (dboTrackChanges In FDBOptions) And (dboTrackCursor In FDBOptions) Then InvalidateNode(FocusedNode);
  End;
End;

Procedure TBaseVirtualDBTree.DoFocusChange(Node: PVirtualNode; Column: Integer);
Var
  Data: PDBVTData;
Begin
  If Assigned(Node) Then Begin
    Data := GetNodeData(Node);
    If Data.ID <> FCurID Then Begin
      FCurID := Data.ID;
      If (FCurID <> 0) And Not (dbtsDataChanging In FDBStatus) And (dboTrackCursor In FDBOptions) Then Begin
        FDBStatus := FDBStatus + [dbtsDataChanging];
        FDataLink.DataSet.Locate(FKeyFieldName, Data.ID, []);
        FDBStatus := FDBStatus - [dbtsDataChanging];
      End;
    End;
  End;
  Inherited;
End;

Function TBaseVirtualDBTree.CanEdit(Node: PVirtualNode; Column: Integer): Boolean;
Begin
  If Not (dbtsEditing In FDBStatus) And Not (dbtsInsert In FDBStatus) Then Result := CanWriteToDataSet(Node, Column, dbcmEdit)
  Else Result := True;
End;

Procedure TBaseVirtualDBTree.DoEdit;
Var
  Data: PDBVTData;
Begin
  Inherited;
  If IsEditing Then Begin
    Data := GetNodeData(FocusedNode);
    If Data.Status = dbnsEdit Then FDBStatus := FDBStatus + [dbtsEditing]
    Else If Data.Status = dbnsNew Then FDBStatus := FDBStatus + [dbtsInsert]
    Else If Not (dbtsInsert In FDBStatus) Then Begin
      FDBStatus := FDBStatus + [dbtsEditing];
      FDataLink.DataSet.Edit;
    End;
  End;
End;

Function TBaseVirtualDBTree.DoEndEdit: Boolean;
Var
  Data: PDBVTData;
Begin
  Result := Inherited DoEndEdit;
  If Result Then Begin
    Data := GetNodeData(FocusedNode);
    Data.Status := dbnsRefreshed;
    If (dbtsEditing In FDBStatus) Then Begin
      FDBStatus := FDBStatus - [dbtsEditing] + [dbtsDataChanging];
      If FDataLink.Editing Then FDataLink.DataSet.Post;
      FDBStatus := FDBStatus - [dbtsDataChanging];
    End Else If (dbtsInsert In FDBStatus) Then Begin
      FDBStatus := FDBStatus - [dbtsInsert] + [dbtsDataChanging];
      If FDataLink.Editing Then FDataLink.DataSet.Post;
      FDBStatus := FDBStatus - [dbtsDataChanging];
      Data.ID := FKeyField.AsInteger;
      FCurID := Data.ID;
    End;
  End;
End;

Function TBaseVirtualDBTree.DoCancelEdit: Boolean;
Var
  Data: PDBVTData;
Begin
  If dbtsInsert In FDBStatus Then Begin
    FDBStatus := FDBStatus - [dbtsInsert] + [dbtsDataChanging];
    If FDataLink.Editing Then FDataLink.DataSet.Cancel;
    FDBStatus := FDBStatus - [dbtsDataChanging];
    Result := Inherited DoCancelEdit;
    DeleteNode(FocusedNode);
    DataLinkScrolled;
    Exit;
  End Else If (dbtsEditing In FDBStatus) Then Begin
    FDBStatus := FDBStatus - [dbtsEditing] + [dbtsDataChanging];
    If FDataLink.Editing Then FDataLink.DataSet.Cancel;
    FDBStatus := FDBStatus - [dbtsDataChanging];
    Data := GetNodeData(FocusedNode);
    Data.Status := dbnsRefreshed;
  End;
  Result := Inherited DoCancelEdit;
End;

Procedure TBaseVirtualDBTree.DoCollapsed(Node: PVirtualNode);
Var
  Focus: PVirtualNode;
Begin
  If Assigned(Node) Then Begin
    If Assigned(FocusedNode) And HasAsParent(FocusedNode, Node) Then Begin
      Focus := Node;
      If Not Selected[Focus] Then Begin
        Focus := GetNextSibling(Node);
        While Assigned(Focus) And Not Selected[Focus] Do Focus := GetNextVisible(Focus);
        If Not Assigned(Focus) Then Begin
          Focus := GetPreviousVisible(Node);
          While Assigned(Focus) And Not Selected[Focus] Do Focus := GetPreviousVisible(Focus);
          If Not Assigned(Focus) Then Focus := Node;
        End;
      End;
      FocusedNode := Focus;
      Selected[Focus] := True;
    End;
    Focus := GetNextSibling(Node);
    If Not Assigned(Focus) Then Begin
      Focus := GetLastChild(Node);
      If Not Assigned(Focus) Then Focus := Node;
      Focus := GetNext(Focus);
    End;
    Node := GetNext(Node);
    While Node <> Focus Do Begin
      Selected[Node] := False;
      Node := GetNext(Node);
    End;
  End;
  Inherited;
End;

Procedure TBaseVirtualDBTree.DoDragDrop(Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; Var Effect: Integer; Mode: TDropMode);
Var
  CanProcess: Boolean;
  Focus: PVirtualNode;
Begin
  Effect := DROPEFFECT_MOVE;
  If CanWriteToDataSet(DropTargetNode, 0, dbcmStructure) Then Begin
    CanProcess := True;
    If CanProcess Then Begin
      Focus := FocusedNode;
      BeginUpdate;
      FDataLink.DataSet.DisableControls;
      FDBStatus := FDBStatus + [dbtsDataChanging, dbtsDragDrop];
      ProcessDrop(DataObject, DropTargetNode, Effect, amAddChildLast);
      Effect := DROPEFFECT_LINK;
      FocusedNode := Nil;
      EndUpdate;
      FDataLink.DataSet.EnableControls;
      FDBStatus := FDBStatus - [dbtsDataChanging, dbtsDragDrop];
      FCurID := 0;
      FocusedNode := Focus;
    End Else Effect := DROPEFFECT_NONE;
  End Else Effect := DROPEFFECT_NONE;
  Inherited;
End;

Procedure TBaseVirtualDBTree.OnDragOverHandler(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; Var Effect: Integer; Var Accept: Boolean);
Begin
  Accept := CanWriteToDataSet(DropTargetNode, 0, dbcmStructure);
End;

Procedure TBaseVirtualDBTree.DoNodeMoved(Node: PVirtualNode);
Var
  Data: PDBVTData;
  Path: String;
  Parent: PVirtualNode;
  ParentID: Integer;
  Level: Integer;
Begin
  If (dbtsDragDrop In FDBStatus) Then Begin
    ParentID := 0;
    Level := 0;
    Parent := Node.Parent;
    If Parent <> RootNode Then Begin
      Data := GetNodeData(Parent);
      Level := Data.Level + 1;
      ParentID := Data.ID;
      If (dboPathStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions) Then Begin
        Path := IntToStr(ParentID);
        Parent := Parent.Parent;
        While Parent <> RootNode Do Begin
          Data := GetNodeData(Parent);
          Path := Format('%d.%s', [Data.ID, Path]);
          Parent := Parent.Parent;
        End;
      End;
    End;
    Data := GetNodeData(Node);
    Data.Level := Level;
    FDataLink.DataSet.Locate(FKeyFieldName, Data.ID, []);
    FDataLink.DataSet.Edit;
    If (dboPathStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions) Then Begin
      DoWritePathToDB(Path);
      FPathField.AsString := Path;
    End;
    If (dboParentStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions) Then Begin
      FParentField.AsInteger := ParentID;
    End;
    If (dboWriteLevel In FDBOptions) Then Begin
      FLevelField.AsInteger := Level;
    End;
    FDataLink.DataSet.Post;
    Inherited;
    Node := GetFirstChild(Node);
    While Assigned(Node) Do Begin
      DoNodeMoved(Node);
      Node := GetNextSibling(Node);
    End;
  End;
End;

Procedure TBaseVirtualDBTree.DoFreeNode(Node: PVirtualNode);
Var
  Data: PDBVTData;
Begin
  Data := GetNodeData(Node);
  If (Data.Status = dbnsDelete) Then Begin
    If FDataLink.DataSet.Locate(FKeyFieldName, Data.ID, []) Then FDataLink.DataSet.Delete;
  End;
  Inherited;
End;

Procedure TBaseVirtualDBTree.SetFocusToNode(Node: PVirtualNode);
Begin
  If Assigned(FocusedNode) Then Selected[FocusedNode] := False;
  FocusedNode := Node;
  If Assigned(Node) Then Begin
    Selected[Node] := True;
    FullyVisible[Node] := True;
  End;
End;

Function TBaseVirtualDBTree.FindChild(Node: PVirtualNode; ID: Integer): PVirtualNode;
Var
  Data: PDBVTData;
Begin
  Result := GetFirstChild(Node);
  While Assigned(Result) Do Begin
    Data := GetNodeData(Result);
    If Data.ID = ID Then break;
    Result := GetNextSibling(Result);
  End;
End;

Function TBaseVirtualDBTree.FindNode(Start: PVirtualNode; ID: Integer): PVirtualNode;
Var
  Data: PDBVTData;
Begin
  If Assigned(Start) Then Result := Start
  Else Result := GetFirst;
  While Assigned(Result) Do Begin
    Data := GetNodeData(Result);
    If Data.ID = ID Then break;
    Result := GetNext(Result);
  End;
End;

Procedure TBaseVirtualDBTree.GoToRec(AString: WideString; Mode: TDBVTGoToMode);
Var
  Text: WideString;
  Node: PVirtualNode;
  Column: Integer;
Begin
  EndEditNode;
  Column := Header.MainColumn;
  Case Mode Of
    gtmFromFirst: Begin
        Node := GetFirst;
        Mode := gtmNext;
      End;
    gtmNext: Node := GetNext(FocusedNode);
    gtmPrev: Node := GetPrevious(FocusedNode);
  Else Node := Nil;
  End;
  While Assigned(Node) Do Begin
    DoGetText(Node, Column, ttNormal, Text);
    If Pos(AString, Text) = 1 Then break;
    If Mode = gtmNext Then Node := GetNext(Node)
    Else Node := GetPrevious(Node);
  End;
  If Assigned(Node) Then SetFocusToNode(Node);
End;

Function TBaseVirtualDBTree.GoToRec(ID: Integer): Boolean;
Var
  Node: PVirtualNode;
Begin
  Node := FindNode(Nil, ID);
  If Assigned(Node) Then SetFocusToNode(Node);
  Result := Node <> Nil;
End;

Procedure TBaseVirtualDBTree.AddNode(Parent: PVirtualNode);
Var
  Level: Integer;
  ParentID: Integer;
  Path: String;
  Node: PVirtualNode;
  Data: PDBVTData;
Begin
  EndEditNode;
  If CanWriteToDataSet(Parent, 0, dbcmInsert) Then Begin
    FDBStatus := FDBStatus + [dbtsDataChanging];
    Node := AddChild(Parent);
    If (Parent = Nil) Or (Parent = RootNode) Then Begin
      Level := 0;
      ParentID := 0;
      Path := '';
    End Else Begin
      Data := GetNodeData(Parent);
      Level := Data.Level + 1;
      ParentID := Data.ID;
      If (dboPathStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions) Then Begin
        Path := IntToStr(ParentID);
        Parent := Parent.Parent;
        While Parent <> RootNode Do Begin
          Data := GetNodeData(Parent);
          Path := Format('%d.%s', [Data.ID, Path]);
          Parent := Parent.Parent;
        End;
      End;
    End;
    Data := GetNodeData(Node);
    Data.ID := 0;
    Data.Level := Level;
    Data.Parent := Nil;
    FDBStatus := FDBStatus + [dbtsInsert];
    FDataLink.DataSet.Insert;
    If Not (dboListView In FDBOptions) Then Begin
      If (dboPathStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions) Then Begin
        DoWritePathToDB(Path);
        FPathField.AsString := Path;
      End;
      If (dboParentStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions) Then FParentField.AsInteger := ParentID;
      If (dboWriteLevel In FDBOptions) Then FLevelField.AsInteger := Level;
    End;
    DoReadNodeFromDB(Node);
    FCurID := 0;
    SetFocusToNode(Node);
    FDBStatus := FDBStatus - [dbtsDataChanging];
    EditNode(Node, Header.MainColumn);
  End;
End;

Procedure TBaseVirtualDBTree.DeleteSelection;
Var
  Data: PDBVTData;
  Node: PVirtualNode;
  Temp: PVirtualNode;
  Last: PVirtualNode;
  Focus: PVirtualNode;
Begin
  If Not (dbtsDataChanging In FDBStatus) And Assigned(FocusedNode) And (SelectedCount > 0) And Not (dboReadOnly In FDBOptions) And FDataLink.Active And Assigned(FKeyField) And Not FDataLink.ReadOnly Then Begin
    Node := GetFirst;
    Focus := FocusedNode;
    While Selected[Focus.Parent] Do Focus := Focus.Parent;
    Temp := Focus;
    Repeat
      Focus := GetNextSibling(Focus);
    Until Not Assigned(Focus) Or Not Selected[Focus];
    If Not Assigned(Focus) Then Begin
      Focus := Temp;
      Repeat
        Focus := GetPreviousSibling(Focus);
      Until Not Assigned(Focus) Or Not Selected[Focus];
      If Not Assigned(Focus) Then Focus := Temp.Parent;
      If Focus = RootNode Then Focus := Nil;
    End;
    FDBStatus := FDBStatus + [dbtsDataChanging];
    BeginUpdate;
    FDataLink.DataSet.DisableControls;
    While Assigned(Node) Do Begin
      If Selected[Node] Then Begin
        Temp := Node;
        Last := GetNextSibling(Node);
        Repeat
          Data := GetNodeData(Temp);
          Data.Status := dbnsDelete;
          Temp := GetNext(Temp);
        Until Temp = Last;
        If Not Assigned(Temp) And (Node.Parent <> RootNode) Then Temp := GetNextSibling(Node.Parent);
        DeleteNode(Node);
        Node := Temp;
      End Else Node := GetNextVisible(Node);
    End;
    FDataLink.DataSet.EnableControls;
    EndUpdate;
    FDBStatus := FDBStatus - [dbtsDataChanging];
    If Assigned(Focus) And (Focus <> RootNode) Then SetFocusToNode(Focus);
  End;
End;

Function TBaseVirtualDBTree.GetDBNodeData(Node: PVirtualNode): Pointer;
Begin
  If Not Assigned(Node) Or (DBNodeDataSize = 0) Then Result := Nil
  Else Result := PChar(GetNodeData(Node)) + FDBDataSize;
End;

Procedure TBaseVirtualDBTree.RefreshNodes;
Var
  Data: PDBVTData;
  Node: PVirtualNode;
  Temp: PVirtualNode;
  I: Integer;
Begin
  If Not (dbtsDataChanging In FDBStatus) And CanOpenDataSet Then Begin
    FDBStatus := FDBStatus + [dbtsDataChanging];
    BeginUpdate;
    FMaxLevel := 0;
    FCurID := 0;
    If (dboAlwaysStructured In FDBOptions) Then Begin
      If Not (dbtsStructured In FDBStatus) Then Clear
      Else If (dboListView In FDBOptions) Then Begin
        FDBOptions := FDBOptions - [dboListView];
        ToggleListView;
        FDBOptions := FDBOptions + [dboListView];
      End;
      FDBStatus := FDBStatus + [dbtsStructured];
    End Else Begin
      If (dboListView In FDBOptions) Then FDBStatus := FDBStatus - [dbtsStructured]
      Else Begin
        If Not (dbtsStructured In FDBStatus) Then Clear;
        FDBStatus := FDBStatus + [dbtsStructured];
      End;
    End;
    Temp := GetFirst;
    If Not Assigned(Temp) Then FDBStatus := FDBStatus + [dbtsEmpty];
    While Assigned(Temp) Do Begin
      Data := GetNodeData(Temp);
      If Data.Status = dbnsRefreshed Then Data.Status := dbnsNone;
      Temp := GetNext(Temp);
    End;
    FDataLink.DataSet.DisableControls;
    If Not FDataLink.DataSet.EOF Or Not FDataLink.DataSet.Bof Then FCurID := FKeyField.AsInteger;
    I := 0;
    While Not FDataLink.DataSet.EOF Do Begin
      RefreshNode;
      FDataLink.DataSet.Next;
      Inc(I);
    End;
    If (I > 0) Then FDataLink.DataSet.MoveBy(-I);
    I := 0;
    While Not (FDataLink.DataSet.Bof) Do Begin
      RefreshNode;
      FDataLink.DataSet.Prior;
      Inc(I);
    End;
    If (I > 0) Then FDataLink.DataSet.MoveBy(I);
    If (dboTrackCursor In FDBOptions) And Assigned(FocusedNode) Then Begin
      Selected[FocusedNode] := False;
      FocusedNode := Nil;
    End;
    Temp := GetFirst;
    While Assigned(Temp) Do Begin
      Data := GetNodeData(Temp);
      If (Data.Status <> dbnsRefreshed) Then Begin
        Node := GetNextSibling(Temp);
        DeleteNode(Temp);
      End Else Begin
        If (dbtsStructured In FDBStatus) And (dboParentStructure In FDBOptions) Then Begin
          Data.Level := GetNodeLevel(Temp);
          FMaxLevel := Max(FMaxLevel, Data.Level);
        End;
        If (dboTrackCursor In FDBOptions) And Not Assigned(FocusedNode) And (Data.ID = FCurID) Then Begin
          Selected[Temp] := True;
          FocusedNode := Temp;
          FullyVisible[Temp] := True;
        End;
        Node := GetNext(Temp);
      End;
      Temp := Node;
    End;
    FDataLink.DataSet.EnableControls;
    FDBStatus := FDBStatus - [dbtsDataChanging, dbtsChanged, dbtsEmpty];
    If (dboAlwaysStructured In FDBOptions) And (dboListView In FDBOptions) Then ToggleListView;
    If Not (dboListView In FDBOptions) And Not (dboViewAll In FDBOptions) And Not (dbtsToggleAll In FDBStatus) Then ToggleViewMode;
    EndUpdate;
  End;
End;

Procedure TBaseVirtualDBTree.RefreshNode;
Begin
  If Not (dbtsStructured In FDBStatus) Then RefreshListNode
  Else If (dboPathStructure In FDBOptions) Then RefreshNodeByPath
  Else RefreshNodeByParent
End;

Procedure TBaseVirtualDBTree.RefreshListNode;
Var
  Data: PDBVTData;
  Node: PVirtualNode;
  ID: Integer;
Begin
  ID := FKeyField.AsInteger;
  If dbtsEmpty In FDBStatus Then Node := Nil
  Else Node := FindChild(Nil, ID);
  If Not Assigned(Node) Then Begin
    Node := AddChild(Nil);
    ValidateNode(Node, False);
    Data := GetNodeData(Node);
    Data.ID := ID;
    Data.Parent := Nil;
    Data.Status := dbnsInited;
  End;
  ReadNodeFromDB(Node);
End;

Procedure TBaseVirtualDBTree.RefreshNodeByPath;
Var
  Pos: Integer;
  ID: Integer;
  Level: Integer;
  Node: PVirtualNode;
  Last: PVirtualNode;
  Data: PDBVTData;
  Temp: String;
  Path: String;
Begin
  Data := Nil;
  Path := FPathField.AsString;
  Last := RootNode;
  DoReadPathFromDB(Path);
  Temp := IntToStr(FKeyField.AsInteger);
  If Path = '' Then Path := Temp
  Else Path := Format('%s.%s', [Path, Temp]);

  Repeat
    Node := Last;
    Pos := System.Pos('.', Path);
    If (Pos = 0) Then Begin
      Temp := Path;
      Pos := Length(Path);
    End Else Temp := Copy(Path, 1, Pos - 1);

    Try
      ID := StrToInt(Temp);
      Last := FindChild(Node, ID);
    Except
      Exit;
    End;

    If Assigned(Last) Then Delete(Path, 1, Pos);
  Until Not Assigned(Last) Or (Path = '');

  If Path = '' Then Begin
    Node := Last;
    Data := GetNodeData(Node);
  End Else Begin
    If (Node = RootNode) Then Level := -1
    Else Begin
      Data := GetNodeData(Node);
      Level := Data.Level;
    End;

    Repeat
      Pos := System.Pos('.', Path);
      If (Pos = 0) Then Begin
        Temp := Path;
        Pos := Length(Path);
      End Else Temp := Copy(Path, 1, Pos - 1);

      Try
        ID := StrToInt(Temp);
        Node := AddChild(Node);
        ValidateNode(Node, False);
        Data := GetNodeData(Node);
        Inc(Level);
        Data.ID := ID;
        Data.Level := Level;
        Data.Status := dbnsInited;
        Data.Parent := Nil;
        Delete(Path, 1, Pos);
      Except
        Exit;
      End;
    Until Path = '';
  End;
  If Data <> Nil Then FMaxLevel := Max(FMaxLevel, Data.Level);
  If Node <> Nil Then ReadNodeFromDB(Node);
End;

Procedure TBaseVirtualDBTree.RefreshNodeByParent;
Var
  ID: Integer;
  ParentID: Integer;
  Data: PDBVTData;
  This: PVirtualNode;
  Parent: PVirtualNode;
  Temp: PVirtualNode;
  Created: Boolean;
Begin
  ID := FKeyField.AsInteger;
  ParentID := FParentField.AsInteger;
  If (ID = 0) Then Begin
    Exit;
  End;
  This := Nil;
  Parent := Nil;
  Temp := GetFirst;
  If (ParentID = 0) Or (ParentID = ID) Then Begin
    Parent := RootNode;
    ParentID := 0;
  End;
  While Assigned(Temp) And (Not Assigned(This) Or Not Assigned(Parent)) Do Begin
    Data := GetNodeData(Temp);
    If (Data.ID = ID) Then Begin
      If (Data.Status = dbnsRefreshed) Then Begin
        Exit;
      End;
      This := Temp;
    End;
    If (Data.ID = ParentID) And (ParentID <> 0) Then Parent := Temp;
    Temp := GetNext(Temp);
  End;
  If Not Assigned(Parent) Then Begin
    Parent := AddChild(Nil);
    ValidateNode(Parent, False);
    Data := GetNodeData(Parent);
    Data.ID := ParentID;
    Data.Status := dbnsInited;
    Data.Parent := Nil;
  End;
  Created := True;
  If Assigned(This) Then Begin
    If (This.Parent <> Parent) Then Begin
      If HasAsParent(Parent, This) Then Begin
        Data := GetNodeData(Parent);
        If (Data.Status = dbnsRefreshed) Then Begin
          Exit;
        End;
        Temp := This;
        This := Parent;
        Parent := Temp;
        Data := GetNodeData(Parent);
        Data.ID := ParentID;
      End Else Begin
        MoveTo(This, Parent, amAddChildLast, False);
      End;
    End;
  End Else Begin
    Created := False;
    This := AddChild(Parent);
    ValidateNode(This, False);
  End;
  Data := GetNodeData(This);
  Data.ID := ID;
  If Not Created Then Data.Status := dbnsInited;
  ReadNodeFromDB(This);
End;

Procedure TBaseVirtualDBTree.UpdateTree;
Begin
  Clear;
  RefreshNodes;
End;

Procedure TBaseVirtualDBTree.ToggleListView;
Var
  Data: PDBVTData;
  Node: PVirtualNode;
  Temp: PVirtualNode;
Begin
  If dbtsDragDrop In FDBStatus Then Exit;
  BeginUpdate;
  If (dboListView In FDBOptions) Then Begin
    Node := GetFirst;
    While Assigned(Node) Do Begin
      Data := GetNodeData(Node);
      If (Node.Parent <> RootNode) Then Begin
        Data.Parent := Node.Parent;
        Temp := GetNextSibling(Node);
        If Not Assigned(Temp) Then Begin
          Temp := GetLastChild(Node);
          If Assigned(Temp) Then Begin
            Temp := GetNext(Temp);
            If Not Assigned(Temp) Then Temp := GetNext(Node);
          End Else Temp := GetNext(Node);
        End;
        MoveTo(Node, RootNode, amAddChildLast, False);
        Node := Temp;
      End Else Node := GetNext(Node);
    End;
    If Not (dboViewAll In FDBOptions) Then ToggleViewMode;
  End Else Begin
    Node := GetFirst;
    While Assigned(Node) Do Begin
      Data := GetNodeData(Node);
      If Data.Parent <> Nil Then Begin
        Temp := GetNextSibling(Node);
        MoveTo(Node, Data.Parent, amAddChildLast, False);
        Data.Parent := Nil;
        Node := Temp;
      End Else Node := GetNextSibling(Node);
    End;
    If Not (dboViewAll In FDBOptions) Then Begin
      FDBStatus := FDBStatus + [dbtsToggleAll];
      ToggleViewMode;
      FDBStatus := FDBStatus - [dbtsToggleAll];
    End;
  End;
  If Assigned(FocusedNode) Then FullyVisible[FocusedNode] := True;
  EndUpdate;
End;

Procedure TBaseVirtualDBTree.ResetFields;
Begin
  FKeyField := Nil;
  FParentField := Nil;
  FPathField := Nil;
  FLevelField := Nil;
  FViewField := Nil;
End;

Procedure TBaseVirtualDBTree.InitFields;
Begin
  If (FKeyFieldName <> '') Then FKeyField := FDataLink.DataSet.FieldByName(FKeyFieldName);
  If (FParentFieldName <> '') Then FParentField := FDataLink.DataSet.FieldByName(FParentFieldName);
  If (FPathFieldName <> '') Then FPathField := FDataLink.DataSet.FieldByName(FPathFieldName);
  If (FLevelFieldName <> '') Then FLevelField := FDataLink.DataSet.FieldByName(FLevelFieldName);
  If FViewFieldName <> '' Then FViewField := DataSource.DataSet.FieldByName(FViewFieldName);
End;

Procedure TBaseVirtualDBTree.SetDBNodeDataSize(Value: Integer);
Begin
  If (Value <> DBNodeDataSize) And (Value >= 0) Then Begin
    NodeDataSize := FDBDataSize + Value;
    UpdateTree;
  End;
End;

Function TBaseVirtualDBTree.GetDBNodeDataSize: Integer;
Begin
  Result := NodeDataSize - FDBDataSize;
End;

Function TBaseVirtualDBTree.GetDBStatus: TDBVTStatuses;
Begin
  Result := FDBStatus;
End;

Function TBaseVirtualDBTree.GetDBOptions: TDBVTOptions;
Begin
  Result := FDBOptions;
End;

Procedure TBaseVirtualDBTree.SetDBOptions(Value: TDBVTOptions);
Var
  ToBeSet, ToBeCleared: TDBVTOptions;
Begin
  EndEditNode;
  ToBeSet := Value - FDBOptions;
  ToBeCleared := FDBOptions - Value;
  FDBOptions := Value;

  If (dboTrackCursor In ToBeSet) Then Begin
    If Not (dboTrackActive In FDBOptions) Or Not (dboTrackChanges In FDBOptions) Then Begin
      FDBOptions := FDBOptions + [dboTrackActive, dboTrackChanges];
      FDBOptions := FDBOptions - [dboAllowChecking];
      If (dbtsChanged In FDBStatus) Then DataLinkActiveChanged;
    End Else DataLinkScrolled;
  End Else If (dboTrackChanges In ToBeSet) Then Begin
    If Not (dboTrackActive In FDBOptions) Then FDBOptions := FDBOptions + [dboTrackActive];
    If dbtsChanged In FDBStatus Then DataLinkActiveChanged;
  End Else If dboTrackActive In ToBeSet Then Begin
    If dbtsChanged In FDBStatus Then DataLinkActiveChanged;
  End Else If dboTrackActive In ToBeCleared Then Begin
    FDBOptions := FDBOptions - [dboTrackCursor, dboTrackChanges];
    FDBOptions := FDBOptions + [dboReadOnly];
  End Else If dboTrackChanges In ToBeCleared Then Begin
    FDBOptions := FDBOptions - [dboTrackCursor];
    FDBOptions := FDBOptions + [dboReadOnly];
  End Else If dboTrackCursor In ToBeCleared Then FDBOptions := FDBOptions + [dboReadOnly];

  If dboShowChecks In ToBeSet Then Begin
    If dboTrackCursor In FDBOptions Then Begin
      FDBOptions := FDBOptions - [dboShowChecks];
      FDBOptions := FDBOptions + [dboViewAll];
    End Else Begin
      BeginUpdate;
      THackedTreeOptions(TreeOptions).MiscOptions := THackedTreeOptions(TreeOptions).MiscOptions + [toCheckSupport];
      If Not (dboViewAll In FDBOptions) Then ToggleViewMode;
      EndUpdate;
    End;
  End Else If dboShowChecks In ToBeCleared Then Begin
    BeginUpdate;
    THackedTreeOptions(TreeOptions).MiscOptions := THackedTreeOptions(TreeOptions).MiscOptions - [toCheckSupport];
    If Not (dboViewAll In FDBOptions) Then Begin
      FDBOptions := FDBOptions + [dboViewAll];
      RefreshNodes;
    End;
    EndUpdate;
  End Else If dboViewAll In ToBeSet Then Begin
    If dboShowChecks In FDBOptions Then ToggleViewMode;
  End Else If dboViewAll In ToBeCleared Then Begin
    If dboShowChecks In FDBOptions Then ToggleViewMode
    Else FDBOptions := FDBOptions + [dboViewAll];
  End;

  If dboPathStructure In ToBeSet Then Begin
    FDBOptions := FDBOptions - [dboParentStructure];
    If dboTrackActive In FDBOptions Then UpdateTree;
  End Else If dboParentStructure In ToBeSet Then Begin
    FDBOptions := FDBOptions - [dboPathStructure];
    If dboTrackActive In FDBOptions Then UpdateTree;
  End Else If dboPathStructure In ToBeCleared Then Begin
    FDBOptions := FDBOptions + [dboParentStructure];
    If dboTrackActive In FDBOptions Then UpdateTree;
  End Else If dboParentStructure In ToBeCleared Then Begin
    FDBOptions := FDBOptions + [dboPathStructure];
    If dboTrackActive In FDBOptions Then UpdateTree;
  End;

  If dboAlwaysStructured In ToBeSet Then Begin
    If Not (dbtsStructured In FDBStatus) Then RefreshNodes;
  End Else If dboAlwaysStructured In ToBeCleared Then Begin
    If dboShowChecks In FDBOptions Then FDBOptions := FDBOptions + [dboAlwaysStructured];
  End;

  If dboListView In ToBeSet Then ToggleListView
  Else If dboListView In ToBeCleared Then Begin
    If dbtsStructured In FDBStatus Then ToggleListView
    Else RefreshNodes;
  End;
  If (dboReadOnly In ToBeCleared) And (Not (dboTrackCursor In FDBOptions) Or Not (dboTrackChanges In FDBOptions) Or Not (dboTrackActive In FDBOptions)) Then FDBOptions := FDBOptions + [dboReadOnly];
End;

Function TBaseVirtualDBTree.CanOpenDataSet: Boolean;
Begin
  Result := (FKeyField <> Nil);
  If Result And (Not (dboListView In FDBOptions) Or (dboAlwaysStructured In FDBOptions)) Then Result := ((dboPathStructure In FDBOptions) And Assigned(FPathField)) Or ((dboParentStructure In FDBOptions) And Assigned(FParentField));
  If Result Then DoOpeningDataSet(Result);
End;

Procedure TBaseVirtualDBTree.DoOpeningDataSet(Var Allow: Boolean);
Begin
  Allow := (FViewField <> Nil);
  If Allow Then Begin
    If Assigned(FOnOpeningDataSet) Then FOnOpeningDataSet(Self, Allow);
  End;
End;

Procedure TBaseVirtualDBTree.DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean);
Begin
  If Assigned(FOnNodeDataChanged) Then FOnNodeDataChanged(Self, Node, Field, UpdateNode);
End;

Procedure TBaseVirtualDBTree.DoReadPathFromDB(Var Path: String);
Begin
  If Assigned(FOnReadPathFromDB) Then FOnReadPathFromDB(Self, Path);
End;

Procedure TBaseVirtualDBTree.DoWritePathToDB(Var Path: String);
Begin
  If Assigned(FOnWritePathToDB) Then FOnWritePathToDB(Self, Path);
End;

Procedure TBaseVirtualDBTree.ReadNodeFromDB(Node: PVirtualNode);
Var
  Data: PDBVTData;
Begin
  Data := GetNodeData(Node);
  If (Data.Status <> dbnsNone) And (Data.Status <> dbnsRefreshed) Then DoReadNodeFromDB(Node);
  Data.Status := dbnsRefreshed;
End;

Procedure TBaseVirtualDBTree.DoReadNodeFromDB(Node: PVirtualNode);
Begin
  If Assigned(FOnReadNodeFromDB) Then FOnReadNodeFromDB(Self, Node);
End;

Function TBaseVirtualDBTree.CanWriteToDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode): Boolean;
Begin
  Result := Not (dboReadOnly In FDBOptions) And Assigned(FKeyField) And FDataLink.DataSet.CanModify;
  If Result Then Begin
    If dboListView In DBOptions Then Begin
      If (ChangeMode = dbcmStructure) Or (ChangeMode = dbcmInsert) Then Result := (Node = Nil) Or (Node = RootNode);
    End Else If (ChangeMode = dbcmStructure) Or (ChangeMode = dbcmInsert) Then Begin
      Result := (((dboPathStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions)) And Assigned(FPathField) And FPathField.CanModify) Or (((dboParentStructure In FDBOptions) Or (dboWriteSecondary In FDBOptions)) And Assigned(FParentField) And FParentField.CanModify);
      If Result And (dboWriteLevel In FDBOptions) Then Result := Assigned(FLevelField) And FLevelField.CanModify;
    End;
    If Result Then DoWritingDataSet(Node, Column, ChangeMode, Result);
  End;
End;

Procedure TBaseVirtualDBTree.DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean);
Begin
  If (ChangeMode = dbcmEdit) And (Column = Header.MainColumn) Then Allow := FViewField.CanModify;
  If Allow Then Begin
    If Assigned(FOnWritingDataSet) Then FOnWritingDataSet(Self, Node, Column, ChangeMode, Allow);
  End;
End;

Function TBaseVirtualDBTree.DoChecking(Node: PVirtualNode; Var NewCheckState: TCheckState): Boolean;
Begin
  If dbtsDataChanging In FDBStatus Then Result := True
  Else If (dboShowChecks In FDBOptions) And (dboAllowChecking In FDBOptions) Then Result := Inherited DoChecking(Node, NewCheckState)
  Else Result := False;
End;

Procedure TBaseVirtualDBTree.DoChecked(Node: PVirtualNode);
Begin
  If Not (dbtsDataChanging In FDBStatus) Then Begin
    BeginUpdate;
    If CheckState[Node] = csCheckedNormal Then Begin
      If dboCheckChildren In FDBOptions Then CheckAllChildren(Node);
    End Else If Not (dboViewAll In FDBOptions) Then ToggleViewMode;
    If Not (dbtsChecking In FDBStatus) And (dboPathStructure In FDBOptions) Then RefreshNodes;
    EndUpdate;
    Inherited;
  End;
End;

Procedure TBaseVirtualDBTree.CheckAllChildren(Node: PVirtualNode);
Begin
  If (dboShowChecks In FDBOptions) And (dboAllowChecking In FDBOptions) Then Begin
    FDBStatus := FDBStatus + [dbtsChecking];
    Node := GetFirstChild(Node);
    While Assigned(Node) Do Begin
      CheckState[Node] := csCheckedNormal;
      Node := GetNextSibling(Node);
    End;
    FDBStatus := FDBStatus - [dbtsChecking];
  End;
End;

Procedure TBaseVirtualDBTree.UnCheckAll(Node: PVirtualNode; OnlyChildren: Boolean);
Var
  Changed: Boolean;
  Last: PVirtualNode;
Begin
  If (dboShowChecks In FDBOptions) And (dboAllowChecking In FDBOptions) Then Begin
    Changed := False;
    Last := GetNextSibling(Node);
    If Not Assigned(Last) Then Begin
      Last := GetLastChild(Node);
      If Not Assigned(Last) Then Last := Node;
      Last := GetNext(Last);
    End;
    If OnlyChildren Then Node := GetNext(Node);
    While Node <> Last Do Begin
      If CheckState[Node] <> csUncheckedNormal Then Begin
        CheckState[Node] := csUncheckedNormal;
        If CheckState[Node] = csUncheckedNormal Then Changed := True;
      End;
    End;
    If Changed Then ToggleViewMode;
  End;
End;

Procedure TBaseVirtualDBTree.DoInitNode(Parent: PVirtualNode; Node: PVirtualNode; Var InitStates: TVirtualNodeInitStates);
Begin
  Inherited;
  Node.CheckType := ctCheckBox;
  Node.CheckState := csUncheckedNormal;
End;

Procedure TBaseVirtualDBTree.ToggleViewMode;
Var
  Node: PVirtualNode;
Begin
  If Not (dbtsDataChanging In FDBStatus) And (dboShowChecks In FDBOptions) Then Begin
    BeginUpdate;
    If dboViewAll In FDBOptions Then RefreshNodes()
    Else Begin
      If dbtsToggleAll In FDBStatus Then RefreshNodes;
      Node := GetLastChild(RootNode);
      While Assigned(Node) And (Node <> RootNode) Do Begin
        If (CheckState[Node] <> csCheckedNormal) And Not Assigned(GetFirstChild(Node)) Then Begin
          DeleteNode(Node);
          If dboListView In FDBOptions Then FDBStatus := FDBStatus - [dbtsStructured];
        End;
        Node := GetPrevious(Node);
      End;
    End;
    EndUpdate;
  End;
End;

Function TBaseVirtualDBTree.HasVisibleChildren(Node: PVirtualNode): Boolean;
Var
  Last: PVirtualNode;
Begin
  Result := False;
  If Assigned(Node) Then Begin
    Last := GetNextSibling(Node);
    If Not Assigned(Last) Then Begin
      Last := GetLastChild(Node);
      If Not Assigned(Last) Then Last := Node;
      Last := GetNext(Last);
    End;
    Node := GetNext(Node);
    While Node <> Last Do Begin
      If IsVisible[Node] Then Begin
        Result := True;
        Break;
      End;
      Node := GetNext(Node);
    End;
  End;
End;

Procedure TBaseVirtualDBTree.ExpandAll;
Var
  Node: PVirtualNode;
Begin
  Node := GetFirst;
  BeginUpdate;
  While Assigned(Node) Do Begin
    Expanded[Node] := True;
    Node := GetNext(Node);
  End;
  EndUpdate;
End;

Procedure TBaseVirtualDBTree.CollapseAll;
Var
  Node: PVirtualNode;
Begin
  Node := GetFirst;
  BeginUpdate;
  While Assigned(Node) Do Begin
    Expanded[Node] := False;
    Node := GetNext(Node);
  End;
  EndUpdate;
End;

Procedure TBaseVirtualDBTree.SetViewFieldName(Const Value: String);
Begin
  If FViewFieldName <> Value Then Begin
    FViewField := Nil;
    FViewFieldName := Value;
    DataLinkActiveChanged;
  End;
End;

{------------------------------------------------------------------------------}

Constructor TVirtualDBTree.Create(Owner: TComponent);
Begin
  Inherited;
  DBNodeDataSize := sizeof(TSimpleData);
End;

Procedure TVirtualDBTree.DoReadNodeFromDB(Node: PVirtualNode);
Begin
  NodeText[Node] := ViewField.AsString;
End;

Procedure TVirtualDBTree.DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean);
Begin
  If Field = ViewField Then Begin
    NodeText[Node] := Field.AsString;
    UpdateNode := True;
  End;
End;

Procedure TVirtualDBTree.DoGetText(Node: PVirtualNode; Column: Integer; TextType: TVSTTextType; Var Text: WideString);
Begin
  If Assigned(Node) And (Node <> RootNode) Then Begin
    If (Column = Header.MainColumn) And (TextType = ttNormal) Then Text := NodeText[Node]
    Else Inherited;
  End;
End;

Procedure TVirtualDBTree.DoNewText(Node: PVirtualNode; Column: Integer; Text: WideString);
Begin
  If Column = Header.MainColumn Then ViewField.AsString := Text;
End;

Procedure TVirtualDBTree.DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean);
Begin
  If ChangeMode = dbcmEdit Then Begin
    If Column = Header.MainColumn Then Inherited
    Else Allow := False;
  End;
End;

Function TVirtualDBTree.DoCompare(Node1, Node2: PVirtualNode; Column: Integer): Integer;
Begin
  If Column = Header.MainColumn Then If NodeText[Node1] > NodeText[Node2] Then Result := 1
    Else Result := -1
  Else Result := 0;
End;

Procedure TVirtualDBTree.SetNodeText(Node: PVirtualNode; Const Value: WideString);
Begin
  If Assigned(Node) Then PSimpleData(GetDBNodeData(Node)).Text := Value;
End;

Function TVirtualDBTree.GetNodeText(Node: PVirtualNode): WideString;
Begin
  If Assigned(Node) Then Result := PSimpleData(GetDBNodeData(Node)).Text;
End;

{------------------------------------------------------------------------------}

Constructor TCustomDBCheckVirtualDBTree.Create(Owner: TComponent);
Begin
  Inherited;
  FCheckDataLink := TVirtualDBTreeDataLink.Create(Self);
  DBOptions := DBOptions - [dboTrackChanges];
  DBOptions := DBOptions + [dboShowChecks, dboAllowChecking];
  FResultField := Nil;
End;

Destructor TCustomDBCheckVirtualDBTree.Destroy;
Begin
  FCheckDataLink.Free;
  Inherited;
End;

Procedure TCustomDBCheckVirtualDBTree.CheckDataLinkActiveChanged;
Begin
  If Not (csDesigning In ComponentState) Then Begin
    FResultField := Nil;
    If FCheckDataLink.Active Then Begin
      If FResultFieldName <> '' Then FResultField := FCheckDataLink.DataSet.FieldByName(FResultFieldName);
    End;
    UpdateTree;
  End;
End;

Procedure TCustomDBCheckVirtualDBTree.DoOpeningDataSet(Var Allow: Boolean);
Begin
  If Assigned(FResultField) Then Inherited
  Else Allow := False;
End;

Procedure TCustomDBCheckVirtualDBTree.SetCheckDataSource(Value: TDataSource);
Begin
  FCheckDataLink.DataSource := Value;
  If Assigned(Value) Then Value.FreeNotification(Self);
End;

Function TCustomDBCheckVirtualDBTree.GetCheckDataSource: TDataSource;
Begin
  Result := FCheckDataLink.DataSource;
End;

Procedure TCustomDBCheckVirtualDBTree.Notification(AComponent: TComponent; Operation: TOperation);
Begin
  Inherited;
  If (Operation = opRemove) And Assigned(FCheckDataLink) And (AComponent = CheckDataSource) Then CheckDataSource := Nil;
End;

Procedure TCustomDBCheckVirtualDBTree.SetResultFieldName(Const Value: String);
Begin
  If FResultFieldName <> Value Then Begin
    FResultFieldName := Value;
    CheckDataLinkActiveChanged;
  End;
End;

Function TCustomDBCheckVirtualDBTree.DoChecking(Node: PVirtualNode; Var NewCheckState: TCheckState): Boolean;
Begin
  If dbtsDataChanging In DBStatus Then Result := Inherited DoChecking(Node, NewCheckState)
  Else If Assigned(FResultField) And FResultField.CanModify Then Result := Inherited DoChecking(Node, NewCheckState)
  Else Result := False;
End;

Procedure TCustomDBCheckVirtualDBTree.DoChecked(Node: PVirtualNode);
Var
  Data: PDBVTData;
Begin
  If Not (dbtsDataChanging In DBStatus) Then Begin
    Data := GetNodeData(Node);
    If CheckState[Node] = csCheckedNormal Then Begin
      FCheckDataLink.DataSet.Insert;
      FResultField.AsInteger := Data.ID;
      FCheckDataLink.DataSet.Post;
    End Else If FCheckDataLink.DataSet.Locate(FResultFieldName, Data.ID, []) Then FCheckDataLink.DataSet.Delete;
  End;
  Inherited;
End;

Procedure TCustomDBCheckVirtualDBTree.DoReadNodeFromDB(Node: PVirtualNode);
Var
  Data: PDBVTData;
Begin
  Inherited;
  Data := GetNodeData(Node);
  If FCheckDataLink.DataSet.Locate(FResultFieldName, Data.ID, []) Then CheckState[Node] := csCheckedNormal
  Else CheckState[Node] := csUncheckedNormal;
End;

{------------------------------------------------------------------------------}

Constructor TDBCheckVirtualDBTree.Create(Owner: TComponent);
Begin
  Inherited;
  DBNodeDataSize := sizeof(TSimpleData);
End;

Procedure TDBCheckVirtualDBTree.DoReadNodeFromDB(Node: PVirtualNode);
Begin
  NodeText[Node] := ViewField.AsString;
  Inherited;
End;

Procedure TDBCheckVirtualDBTree.DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean);
Begin
  If Field = ViewField Then Begin
    NodeText[Node] := Field.AsString;
    UpdateNode := True;
  End;
End;

Procedure TDBCheckVirtualDBTree.DoGetText(Node: PVirtualNode; Column: Integer; TextType: TVSTTextType; Var Text: WideString);
Begin
  If Assigned(Node) And (Node <> RootNode) Then Begin
    If (Column = Header.MainColumn) And (TextType = ttNormal) Then Text := NodeText[Node]
    Else Inherited;
  End;
End;

Procedure TDBCheckVirtualDBTree.DoNewText(Node: PVirtualNode; Column: Integer; Text: WideString);
Begin
  If Column = Header.MainColumn Then ViewField.AsString := Text;
End;

Procedure TDBCheckVirtualDBTree.DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean);
Begin
  If ChangeMode = dbcmEdit Then Begin
    If Column = Header.MainColumn Then Inherited
    Else Allow := False;
  End;
End;

Function TDBCheckVirtualDBTree.DoCompare(Node1, Node2: PVirtualNode; Column: Integer): Integer;
Begin
  If Column = Header.MainColumn Then If NodeText[Node1] > NodeText[Node2] Then Result := 1
    Else Result := -1
  Else Result := 0;
End;

Procedure TDBCheckVirtualDBTree.SetNodeText(Node: PVirtualNode; Const Value: WideString);
Begin
  If Assigned(Node) Then PSimpleData(GetDBNodeData(Node)).Text := Value;
End;

Function TDBCheckVirtualDBTree.GetNodeText(Node: PVirtualNode): WideString;
Begin
  If Assigned(Node) Then Result := PSimpleData(GetDBNodeData(Node)).Text;
End;

{------------------------------------------------------------------------------}

Constructor TCustomCheckVirtualDBTree.Create(Owner: TComponent);
Begin
  Inherited;
  FList := TStringList.Create;
  FList.Sorted := True;
  DBOptions := DBOptions - [dboTrackChanges];
  DBOptions := DBOptions + [dboShowChecks, dboAllowChecking];
End;

Destructor TCustomCheckVirtualDBTree.Destroy;
Begin
  FList.Free;
  Inherited;
End;

Function TCustomCheckVirtualDBTree.GetCheckList: TStringList;
Begin
  Result := TStringList.Create;
  Result.Assign(FList);
End;

Procedure TCustomCheckVirtualDBTree.SetCheckList(Value: TStringList);
Begin
  FList.Assign(Value);
  UpdateTree;
End;

Procedure TCustomCheckVirtualDBTree.DoChecked(Node: PVirtualNode);
Var
  Data: PDBVTData;
  Index: Integer;
Begin
  If Not (dbtsDataChanging In DBStatus) Then Begin
    Data := GetNodeData(Node);
    If CheckState[Node] = csCheckedNormal Then FList.Add(IntToStr(Data.ID))
    Else Begin
      Index := FList.IndexOf(IntToStr(Data.ID));
      If Index <> -1 Then FList.Delete(Index);
    End;
  End;
  Inherited;
End;

Procedure TCustomCheckVirtualDBTree.DoReadNodeFromDB(Node: PVirtualNode);
Var
  Data: PDBVTData;
  Index: Integer;
Begin
  Inherited;
  Data := GetNodeData(Node);
  If FList.Find(IntToStr(Data.ID), Index) Then CheckState[Node] := csCheckedNormal
  Else CheckState[Node] := csUncheckedNormal;
End;

{------------------------------------------------------------------------------}

Constructor TCheckVirtualDBTree.Create(Owner: TComponent);
Begin
  Inherited;
  DBNodeDataSize := sizeof(TSimpleData);
End;

Procedure TCheckVirtualDBTree.DoReadNodeFromDB(Node: PVirtualNode);
Begin
  NodeText[Node] := ViewField.AsString;
  Inherited;
End;

Procedure TCheckVirtualDBTree.DoNodeDataChanged(Node: PVirtualNode; Field: TField; Var UpdateNode: Boolean);
Begin
  If Field = ViewField Then Begin
    NodeText[Node] := Field.AsString;
    UpdateNode := True;
  End;
End;

Procedure TCheckVirtualDBTree.DoGetText(Node: PVirtualNode; Column: Integer; TextType: TVSTTextType; Var Text: WideString);
Begin
  If Assigned(Node) And (Node <> RootNode) Then Begin
    If (Column = Header.MainColumn) And (TextType = ttNormal) Then Text := NodeText[Node]
    Else Inherited;
  End;
End;

Procedure TCheckVirtualDBTree.DoNewText(Node: PVirtualNode; Column: Integer; Text: WideString);
Begin
  If Column = Header.MainColumn Then ViewField.AsString := Text;
End;

Procedure TCheckVirtualDBTree.DoWritingDataSet(Node: PVirtualNode; Column: Integer; ChangeMode: TDBVTChangeMode; Var Allow: Boolean);
Begin
  If ChangeMode = dbcmEdit Then Begin
    If Column = Header.MainColumn Then Inherited
    Else Allow := False;
  End;
End;

Function TCheckVirtualDBTree.DoCompare(Node1, Node2: PVirtualNode; Column: Integer): Integer;
Begin
  If Column = Header.MainColumn Then If NodeText[Node1] > NodeText[Node2] Then Result := 1
    Else Result := -1
  Else Result := 0;
End;

Procedure TCheckVirtualDBTree.SetNodeText(Node: PVirtualNode; Const Value: WideString);
Begin
  If Assigned(Node) Then PSimpleData(GetDBNodeData(Node)).Text := Value;
End;

Function TCheckVirtualDBTree.GetNodeText(Node: PVirtualNode): WideString;
Begin
  Result := '';
  If Assigned(Node) And (Node <> RootNode) Then Result := PSimpleData(GetDBNodeData(Node)).Text;
End;

Function TCustomDBCheckVirtualDBTree.GetCheckList: TStringList;
Var
  Data: PDBVTData;
  Node: PVirtualNode;
Begin
  Result := TStringList.Create;
  Node := GetFirst;
  While Assigned(Node) Do Begin
    Data := GetNodeData(Node);
    If CheckState[Node] = csCheckedNormal Then Result.Add(IntToStr(Data.ID));
    Node := GetNext(Node);
  End;
End;

End.

