{***********************************************************
                R&A Library
       Copyright (C) 1996-98 R&A

       component   : RADBTreeView
       description : db-aware TreeView

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru
************************************************************}

{$INCLUDE RA.INC}

{ history
 (R&A Library versions) :
  1.20:
    - first release;
  1.61:
    - support for non-bde components,
      by Yakovlev Vacheslav (jwe@belkozin.com)
}

unit RADBTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Dialogs, Graphics,
  CommCtrl, ComCtrls, ExtCtrls, Db, dbctrls
  {$IFDEF RA_D6H}, Variants {$ENDIF}
  ;

type
  TRADBTreeNode = class;
  TRADBTreeViewDataLink = class;
  TFieldTypes = set of TFieldType;
  TGetDetailValue = function (const AMasterValue : variant; var DetailValue : variant) : boolean;

  TCustomRADBTreeView = class(TCustomTreeView)
  private
    FDataLink : TRADBTreeViewDataLink;

    FMasterFieldOldValue: Variant;
    FMasterField : string;
    FDetailField : string;
    FItemField   : string;
    FIconField   : string;
    FStartMasterValue: variant;
    FGetDetailValue : TGetDetailValue;
    FUseFilter: boolean;
    FSelectedIndex : integer;

   {Update flags}
    FUpdateLock : Byte;
    InTreeUpdate : boolean;
    InDataScrolled : boolean;
    InAddChild : boolean;
    InDelete : boolean;
    Sel : TTreeNode;
    oldRecCount : integer;

    FPersistentNode : boolean;

    procedure InternalDataChanged;
    procedure InternalDataScrolled;
    procedure InternalRecordChanged(Field: TField);
   {*** for property}
    procedure SetMasterField(Value: string);
    procedure SetDetailField(Value: string);
    procedure SetItemField(Value: string);
    procedure SetIconField(Value: string);
    function GetStartMasterValue : string;
    procedure SetStartMasterValue(Value: string);

    function  GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
   {### for property}
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  private
 {**** Drag'n'Drop ****}
    YY : integer;
    timerDnD : TTimer;
    procedure timerDnDTimer(Sender: TObject);
  protected
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
 {#### Drag'n'Drop ####}
  protected
    procedure Warning(Message : string);
    procedure HideEditor;
    function ValidDataSet: Boolean;
    procedure CheckDataSet;
    function ValidField(FieldName : string; AllowFieldTypes : TFieldTypes) : boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(Component : TComponent; Operation : TOperation); override;
    procedure Change(Node: TTreeNode); override;

   { data }
    procedure DataChanged; dynamic;
    procedure DataScrolled; dynamic;
    procedure Change2(Node: TTreeNode); dynamic;
    procedure RecordChanged(Field: TField); dynamic;

    function CanExpand(Node: TTreeNode) : Boolean; override;
    procedure Collapse(Node: TTreeNode); override;
    function CreateNode: TTreeNode; override;
    function CanEdit(Node: TTreeNode): Boolean; override;
    procedure Edit(const Item: TTVItem); override;
    procedure MoveTo(Source, Destination: TRADBTreeNode; Mode: TNodeAttachMode);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshChild(ANode : TRADBTreeNode);
    procedure UpdateTree;
    procedure LinkActive(Value: Boolean); virtual;
    procedure UpdateLock;
    procedure UpdateUnLock(const AUpdateTree : boolean);
    function UpdateLocked : boolean;
    function AddChildNode(const Node : TTreeNode; const Select : boolean) : TRADBTreeNode;
    procedure DeleteNode(Node : TTreeNode);
    function FindNextNode(const Node : TTreeNode) : TTreeNode;
    function FindNode(AMasterValue : variant) : TRADBTreeNode;
    function SelectNode(AMasterValue : variant) : TTreeNode;

    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DataLink: TRADBTreeViewDataLink read FDataLink;
    property MasterField: string read FMasterField write SetMasterField;
    property DetailField: string read FDetailField write SetDetailField;
    property ItemField: string read FItemField write SetItemField;
    property IconField: string read FIconField write SetIconField;
    property StartMasterValue: string read GetStartMasterValue write SetStartMasterValue;
    property GetDetailValue : TGetDetailValue read FGetDetailValue write FGetDetailValue;
    property PersistentNode : boolean read FPersistentNode write FPersistentNode;
    property SelectedIndex : integer read FSelectedIndex write FSelectedIndex default 1;
    property UseFilter: boolean read FUseFilter write FUseFilter;

    property Items;
  end;

  TRADBTreeViewDataLink = class(TDataLink)
  private
    FTreeView: TCustomRADBTreeView;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
  public
    constructor Create(ATreeView: TCustomRADBTreeView);
    destructor Destroy; override;
  end;


  TRADBTreeNode = class(TTreeNode)
  private
    FMasterValue : variant;
  public
    procedure SetMasterValue(AValue : variant);
    procedure MoveTo(Destination: TTreeNode; Mode: TNodeAttachMode); {$IFNDEF RA_D2} override; {$ENDIF}
    property MasterValue : variant read FMasterValue;
  end;

  TRADBTreeView = class(TCustomRADBTreeView)
  published
    property DataSource;
    property MasterField;
    property DetailField;
    property IconField;
    property ItemField;
    property StartMasterValue;
    property UseFilter;
    property PersistentNode;
    property SelectedIndex;
    property BorderStyle;
    property DragCursor;
    property ShowButtons;
    property ShowLines;
    property ShowRoot;
    property ReadOnly;
   {$IFDEF RA_D3H}
    property RightClickSelect;
   {$ENDIF RA_D3H}
    property DragMode;
    property HideSelection;
    property Indent;
    property OnEditing;
    property OnEdited;
    property OnExpanding;
    property OnExpanded;
    property OnCollapsing;
    property OnCompare;
    property OnCollapsed;
    property OnChanging;
    property OnChange;
    property OnDeletion;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property Align;
    property Enabled;
    property Font;
    property Color;
    property ParentColor default False;
    property ParentCtl3D;
    property Ctl3D;
    property SortType;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property PopupMenu;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Images;
    property StateImages;
   {$IFDEF RA_D4H}
    property Anchors;
    property AutoExpand;
    property BiDiMode;
    property BorderWidth;
    property ChangeDelay;
    property Constraints;
    property DragKind;
    property HotTrack;
    property ParentBiDiMode;
    property RowSelect;
    property ToolTips;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnEndDock;
    property OnStartDock;
   {$ENDIF RA_D4H}
  end;

  ERADBTreeViewError = class(ETreeViewError);

const
  DnDScrollArea : integer = 15;
  DnDInterval   : integer = 200;

implementation

uses RADBConst;

function Var2Type(V : Variant; const VarType : integer) : variant;
begin
  if V = null then
  begin
    case VarType of
      varString,
      varOleStr    : Result := '';
      varInteger,
      varSmallint,
      varByte      : Result := 0;
      varBoolean   : Result := false;
      varSingle,
      varDouble,
      varCurrency,
      varDate      : Result := 0.0;
      else Result := VarAsType(V, VarType);
    end;
  end else
    Result := VarAsType(V, VarType);
end;


{********************* TRADBTreeViewDataLink *********************}

constructor TRADBTreeViewDataLink.Create(ATreeView: TCustomRADBTreeView);
begin
  inherited Create;
  FTreeView := ATreeView;
end;

destructor TRADBTreeViewDataLink.Destroy;
begin
  inherited Destroy;
end;

procedure TRADBTreeViewDataLink.ActiveChanged;
begin
  FTreeView.LinkActive(Active);
end;

procedure TRADBTreeViewDataLink.RecordChanged(Field: TField);
begin
  FTreeView.InternalRecordChanged(Field);
end;

procedure TRADBTreeViewDataLink.DataSetChanged;
begin
  FTreeView.InternalDataChanged;
end;

procedure TRADBTreeViewDataLink.DataSetScrolled(Distance: Integer);
begin
  FTreeView.InternalDataScrolled;
end;

{##################### TRADBTreeViewDataLink #####################}



{********************* TRADBTreeNode **********************}
procedure TRADBTreeNode.MoveTo(Destination: TTreeNode; Mode: TNodeAttachMode);
var
  PersistNode : boolean;
  TV : TRADBTreeView;
begin
  TV := (TreeView as TRADBTreeView);
  PersistNode := TV.FPersistentNode;
  TV.MoveTo(Self as TRADBTreeNode, Destination as TRADBTreeNode, Mode);
  TV.FPersistentNode := true;
  if Destination.HasChildren and (Destination.Count = 0) then
    Free
  else
    inherited MoveTo(Destination, Mode);
 {$IFDEF RA_D2}
  Destination.HasChildren := true;
 {$ENDIF}   
  TV.FPersistentNode := PersistNode;
end;

procedure TRADBTreeNode.SetMasterValue(AValue : variant);
begin
  FMasterValue := AValue;
end;

{##################### TRADBTreeNode ######################}


{********************* TCustomRADBTreeView *********************}

constructor TCustomRADBTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TRADBTreeViewDataLink.Create(Self);
  timerDnD := TTimer.Create(Self);
  timerDnD.Enabled := false;
  timerDnD.Interval := DnDInterval;
  timerDnD.OnTimer := timerDnDTimer;
  FStartMasterValue := Null;
  FMasterFieldOldValue:=Null;
  FSelectedIndex := 1;
end;

destructor TCustomRADBTreeView.Destroy;
begin
  FDataLink.Free;
  FDataLink:=nil;
  timerDnD.Free;
  inherited Destroy;
end;

procedure TCustomRADBTreeView.CheckDataSet;
begin
  if not ValidDataSet then
    raise ERADBTreeViewError.Create(SDataSetNotActive);
end;

procedure TCustomRADBTreeView.Warning(Message : string);
begin
  MessageDlg(Name + ': ' + Message, mtWarning, [mbOk], 0);
end;

function TCustomRADBTreeView.ValidField(FieldName : string; AllowFieldTypes : TFieldTypes) : boolean;
var
  AField : TField;
begin
  Result := (csLoading in ComponentState) or
            (FDataLink.DataSet = nil) or
            not FDataLink.DataSet.Active;
  if not Result and (Length(FieldName) > 0) then begin
    AField := FDataLink.DataSet.FindField(FieldName); { no exceptions }
    Result := (AField <> nil) and (AField.DataType in AllowFieldTypes);
  end;
end;

procedure TCustomRADBTreeView.SetMasterField(Value: String);
begin
  if ValidField(Value, [ftSmallInt, ftInteger, ftWord, ftString]) then
    FMasterField := Value
  else
    Warning(SMasterFieldError);
end;

procedure TCustomRADBTreeView.SetDetailField(Value: String);
begin
  if ValidField(Value, [ftSmallInt, ftInteger, ftWord, ftString]) then
    FDetailField := Value
  else
    Warning(SDetailFieldError);
end;

procedure TCustomRADBTreeView.SetItemField(Value: String);
begin
  if ValidField(Value, [ftString, ftMemo, ftSmallInt, ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftDate, ftTime, ftDateTime]) then
    FItemField := Value
  else
    Warning(SItemFieldError);
end;

procedure TCustomRADBTreeView.SetIconField(Value: String);
begin
  if ValidField(Value, [ftSmallInt, ftInteger, ftWord]) then
    FIconField := Value
  else
    Warning(SIconFieldError);
end;

function TCustomRADBTreeView.GetStartMasterValue : string;
begin
  if FStartMasterValue = null then
    Result := ''
  else
    Result := FStartMasterValue;
end;

procedure TCustomRADBTreeView.SetStartMasterValue(Value: string);
begin
  if Length(Value) > 0 then
    FStartMasterValue := Value
  else
    FStartMasterValue := null;
end;

function TCustomRADBTreeView.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TCustomRADBTreeView.SetDataSource(Value: TDataSource);
begin
  if Value = FDatalink.Datasource then Exit;
  Items.Clear;
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TCustomRADBTreeView.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TCustomRADBTreeView.Notification(Component : TComponent; Operation : TOperation);
begin
  inherited Notification(Component, Operation);
  if (FDataLink <> nil) and (Component= DataSource) and (Operation = opRemove) then
    DataSource := nil;
end;

function TCustomRADBTreeView.CreateNode: TTreeNode;
begin
  Result := TRADBTreeNode.Create(Items);
end;

procedure TCustomRADBTreeView.HideEditor;
begin
  if Selected <> nil then
    Selected.EndEdit(true);
end;

function TCustomRADBTreeView.ValidDataSet: Boolean;
begin
  Result := FDataLink.Active and Assigned(FDataLink.DataSet) and FDataLink.DataSet.Active;
end;

procedure TCustomRADBTreeView.LinkActive(Value: Boolean);

  function AllFieldsValid : boolean;
  begin
    Result := false;
    if ValidDataSet then begin
      if (FMasterField = '') or (FDataLink.DataSet.FindField(FMasterField) = nil) then begin
        Warning(SMasterFieldEmpty);
        Exit;
      end;
      if (FDetailField = '') or (FDataLink.DataSet.FindField(FDetailField) = nil) then begin
        Warning(SDetailFieldEmpty);
        Exit;
      end;
      if (FItemField = '') or (FDataLink.DataSet.FindField(FItemField) = nil) then begin
        Warning(SItemFieldEmpty);
        Exit;
      end;
     { if (FDataLink.DataSet.FindField(FMasterField).DataType <> FDataLink.DataSet.FindField(FDetailField).DataType) then begin
        Warning(SMasterDetailFieldError);
        Exit;
      end; }
      if (FDataLink.DataSet.FindField(FItemField).DataType in
          [ftBytes,ftVarBytes,ftBlob,ftGraphic,ftFmtMemo,ftParadoxOle,ftDBaseOle,ftTypedBinary]) then begin
        Warning(SItemFieldError);
        Exit;
      end;
      if (FIconField <> '') and not (FDataLink.DataSet.FindField(FIconField).DataType in [ftSmallInt, ftInteger, ftWord]) then begin
        Warning(SIconFieldError);
        Exit;
      end;
    end;
    Result := true;
  end;
begin
  if not Value then HideEditor;
  if not AllFieldsValid then exit;
  //if ( csDesigning in ComponentState ) then Exit;
  if ValidDataSet then begin
    RefreshChild(nil);
    oldRecCount := FDataLink.DataSet.RecordCount;
  end else if FUpdateLock = 0 then
    Items.Clear;
end;

procedure TCustomRADBTreeView.UpdateLock;
begin
  inc(FUpdateLock);
end;

procedure TCustomRADBTreeView.UpdateUnLock(const AUpdateTree : boolean);
begin
  if FUpdateLock > 0 then
    dec(FUpdateLock);
  if (FUpdateLock = 0) then
    if AUpdateTree then
      UpdateTree else
      oldRecCount := FDataLink.DataSet.RecordCount;
end;

function TCustomRADBTreeView.UpdateLocked : boolean;
begin
  Result := FUpdateLock > 0;
end;

procedure TCustomRADBTreeView.RefreshChild(ANode : TRADBTreeNode);
var
  ParentValue : variant;
  BK : TBookmark;
  oldFilter : string;
  oldFiltered :boolean;
  PV : string;
  i : integer;
begin
  CheckDataSet;
  if UpdateLocked then exit;
  inc(FUpdateLock);
  with FDataLink.DataSet do begin
    BK := GetBookmark;
    try
      DisableControls;
      if ANode <> nil then begin
        ANode.DeleteChildren;
        ParentValue := ANode.FMasterValue;
      end else begin
        Items.Clear;
        ParentValue := FStartMasterValue;
      end;
      oldFiltered := false;
      oldFilter := '';
      if FUseFilter then
      begin
        if ParentValue = null then
          PV := 'null'
        else
          PV := ''''+Var2Type(ParentValue, varString)+'''';
        oldFilter := Filter; oldFiltered := Filtered;
        if Filtered then
          Filter := '('+oldFilter+') and ('+FDetailField+'='+PV+')'
        else
          Filter := '('+FDetailField+'='+PV+')';
        Filtered := true;
      end;
      try
        First;
        while not Eof do
        begin
          if FUseFilter or
            ( ((ParentValue=null) and
             ((Length(FieldByName(FDetailField).asString)=0)
               or (Copy(Trim(FieldByName(FDetailField).asString),1,1)='-'))
             ) or (FieldByName(FDetailField).Value = ParentValue)) then
          begin
            with Items.AddChild(ANode, FieldByName(FItemField).Text) as TRADBTreeNode do
            begin
              FMasterValue := FieldValues[FMasterField];
              if FIconField <> '' then begin
                ImageIndex := Var2Type(FieldValues[FIconField], varInteger);
                SelectedIndex := ImageIndex + FSelectedIndex;
              end;
            end;
          end;
          Next;
        end;
      finally
        if FUseFilter then
        begin
          Filtered := oldFiltered; Filter := oldFilter;
        end;
      end;
      if ANode = nil then
        for i := 0 to Items.Count-1 do
          with Items[i] as TRADBTreeNode do
            HasChildren := Lookup(FDetailField, FMasterValue, FDetailField) <> null
      else
        for i := 0 to ANode.Count-1 do
          with ANode[i] as TRADBTreeNode do
            HasChildren := Lookup(FDetailField, FMasterValue, FDetailField) <> null
    finally
      try
        GotoBookmark(BK);
        FreeBookmark(BK);
        EnableControls;
      finally
        dec(FUpdateLock);
      end;
    end;
  end;
end;

function TCustomRADBTreeView.CanExpand(Node: TTreeNode): Boolean;
begin
  Result := inherited CanExpand(Node);
  if Result and (Node.Count = 0) then
    RefreshChild(Node as TRADBTreeNode);
end;

procedure TCustomRADBTreeView.Collapse(Node: TTreeNode);
var
  HasChildren : boolean;
begin
  inherited Collapse(Node);
  if not FPersistentNode then begin
    HasChildren := Node.HasChildren;
    Node.DeleteChildren;
    Node.HasChildren := HasChildren;
  end;
end;

function TCustomRADBTreeView.FindNode(AMasterValue : variant) : TRADBTreeNode;

 function GetNode: TRADBTreeNode;

  function GetRecurseNode(ndParent: TRADBTreeNode):TRADBTreeNode;
  var
    i: Integer;
    nd: TRADBTreeNode;
  begin
    for i:=0 to ndParent.Count-1 do begin
      nd:=ndParent.Item[i] as TRADBTreeNode;
      if nd.FMasterValue=AMasterValue then begin
        Result:=nd;
        exit;
      end else begin
        RefreshChild(nd);
        Result:=GetRecurseNode(nd);
        if Result<>nil then
         exit;
      end;
    end;
    Result:=nil;
  end;

 var
   i: Integer;
 begin
  for i := 0 to Items.Count -1 do begin
    Result := Items[i] as TRADBTreeNode;
    if Result.FMasterValue = AMasterValue then
      exit
    else begin
      RefreshChild(TRADBTreeNode(Items[i]));
      Result:=GetRecurseNode(TRADBTreeNode(Items[i]));
      if Result<>nil then
       exit;
    end;
  end;
  Result:=nil;
 end;

var
  i : integer;
const
  useOld=false;
begin
 if not useOld then begin
  Result := GetNode;
 end else begin
  for i := 0 to Items.Count -1 do begin
    Result := Items[i] as TRADBTreeNode;
    if Result.FMasterValue = AMasterValue then
      exit;
  end;
  Result:=nil;
 end;
end;


function TCustomRADBTreeView.SelectNode(AMasterValue : variant) : TTreeNode;

  function GetDetailValue(const AMasterValue : variant; var DetailValue : variant) : boolean;
  var
    V : variant;
  begin
    if Assigned(FGetDetailValue) then begin
      Result := FGetDetailValue(AMasterValue, DetailValue);
      if DetailValue = FStartMasterValue then
        raise ERADBTreeViewError.Create('error value for DetailValue');
    end else begin
      V := FDataLink.DataSet.Lookup(FMasterField, AMasterValue, FMasterField+';'+FDetailField);
      Result := ((VarType(V) and varArray) = varArray) and (V[1] <> null);
      if Result then begin
        DetailValue := V[1];
        if DetailValue = FStartMasterValue then
          raise ERADBTreeViewError.Create('internal error');
      end;
    end;
  end;
var
  V : variant;
  Node : TRADBTreeNode;
  Parents : variant; {varArray}
  i : integer;
begin
  Result := FindNode(AMasterValue);
  if Result = nil then
    try
     // inc(FUpdateLock);
      Parents := VarArrayCreate([0, 0], varVariant);
      V := AMasterValue;
      i := 0;
      repeat
        if not GetDetailValue(V, V) then exit;
        Node := FindNode(V);
        if Node <> nil then begin
          {раскрыть все ветки от найденной до нужной}
          //..
          Node.Expand(false);
          while i > 0 do begin
            FindNode(Parents[i]).Expand(false);
            dec(i);
          end;
          Result := FindNode(AMasterValue);
        end else begin
          {добавить в массив родителей}
          inc(i);
          VarArrayRedim(Parents, i);
          Parents[i] := V;
        end;
      until Node <> nil;
    finally
     // dec(FUpdateLock);
    end;
  if Result <> nil then Result.Selected := true;
end;

procedure TCustomRADBTreeView.UpdateTree;
  procedure AddRecord;
  var
    Node, ParentNode : TRADBTreeNode;
  begin
    {если текущая запись отсутствует в дереве, но должна быть в нем, то добавить}
    Node := FindNode(FDataLink.DataSet[FMasterField]);
    if (Node = nil) then begin
      ParentNode := FindNode(FDataLink.DataSet[FDetailField]);
      if (((ParentNode <> nil) and (not ParentNode.HasChildren or (ParentNode.Count <> 0))) or
        (FDataLink.DataSet[FDetailField] = FStartMasterValue))
      then begin
        if FDataLink.DataSet[FDetailField] = FStartMasterValue then
          Node := nil
        else begin
          Node := FindNode(FDataLink.DataSet[FDetailField]);
          if (Node = nil) or (Node.HasChildren and (Node.Count = 0)) then exit;
        end;
        with FDataLink.DataSet, Items.AddChild(Node, FDataLink.DataSet.FieldByName(FItemField).Text) as TRADBTreeNode do begin
          FMasterValue := FieldValues[FMasterField];
          if FIconField <> '' then begin
            ImageIndex := Var2Type(FieldValues[FIconField], varInteger);
            SelectedIndex := ImageIndex + FSelectedIndex;
          end;
          HasChildren := Lookup(FDetailField, FMasterValue, FDetailField) <> null
        end;
      end;
    end;  
  end;
var
  i : integer;
  BK : TBookmark;
  AllChecked : boolean;
begin
  CheckDataSet;
  if UpdateLocked or (InTreeUpdate) then exit;
  InTreeUpdate := true;
  Items.BeginUpdate;
  try
    with FDataLink.DataSet do begin
      BK := GetBookmark;
      DisableControls;
      try
       {*** удалить из дерева удаленные записи}
        repeat
          AllChecked := true;
          for i :=0 to Items.Count -1 do
            if not Locate(FMasterField, (Items[i] as TRADBTreeNode).FMasterValue, []) then begin
              Items[i].Free;
              AllChecked := false;
              break;
            end else
              Items[i].HasChildren := Lookup(FDetailField, (Items[i] as TRADBTreeNode).FMasterValue, FDetailField) <> null;
        until AllChecked;
       {###}
       {*** добавить новые}
        First;
        while not Eof do begin
          AddRecord;
          Next;
        end;
       {###} 
      finally
        GotoBookmark(BK);
        FreeBookmark(BK);
        EnableControls;
      end;
    end;
  finally
    Items.EndUpdate;
    InTreeUpdate := false;
  end;
end;

procedure TCustomRADBTreeView.InternalDataChanged;
begin
  if not HandleAllocated or UpdateLocked or InDataScrolled then Exit;
//  InDataScrolled := true;
  try
    DataChanged;
  finally
//    InDataScrolled := false;
  end;
end;

procedure TCustomRADBTreeView.DataChanged;
var
  RecCount : integer;
begin
  case FDataLink.DataSet.State of
    dsBrowse :
      begin
        RecCount := FDataLink.DataSet.RecordCount;
        if (RecCount = -1) or (RecCount <> oldRecCount) then
          UpdateTree;
        oldRecCount := RecCount;
      end;
    dsInsert : oldRecCount := -1; { TQuery don't change RecordCount value after insert new record }
  end;
  if FMasterFieldOldValue<>FDataLink.DataSet.FieldByName(FMasterField).AsVariant then begin
   Selected := FindNode(FDataLink.DataSet[FMasterField]);
   FMasterFieldOldValue:=FDataLink.DataSet.FieldByName(FMasterField).AsVariant;
  end; 
end;

procedure TCustomRADBTreeView.InternalDataScrolled;
begin
  if not HandleAllocated or UpdateLocked then Exit;
  InDataScrolled := true;
  try
    DataScrolled;
  finally
    InDataScrolled := false;
  end;
end;

procedure TCustomRADBTreeView.DataScrolled;
begin
  Selected := FindNode(FDataLink.DataSet[FMasterField]);
end;

procedure TCustomRADBTreeView.Change(Node: TTreeNode);
begin
  if ValidDataSet and Assigned(Node) and not InDataScrolled and
    (FUpdateLock = 0) and
    (FDataLink.DataSet.State in [dsBrowse, dsEdit, dsInsert])
  then begin
    inc(FUpdateLock);
    try
      Change2(Node);
    finally
      dec(FUpdateLock);
    end;
  end;
  inherited Change(Node);
end;

procedure TCustomRADBTreeView.Change2(Node: TTreeNode);
begin
  FDataLink.DataSet.Locate(FMasterField, (Node as TRADBTreeNode).FMasterValue, []);
end;

procedure TCustomRADBTreeView.InternalRecordChanged(Field: TField);
begin
  if not (HandleAllocated and ValidDataSet) then Exit;
  if (Selected <> nil) and (FUpdateLock = 0) and
     (FDataLink.DataSet.State = dsEdit)
  then begin
    inc(FUpdateLock);
    try
      RecordChanged(Field);
    finally
      dec(FUpdateLock);
    end;
  end;
end;

procedure TCustomRADBTreeView.RecordChanged(Field: TField);
var
  Node : TRADBTreeNode;
begin
  Selected.Text := FDataLink.DataSet.FieldByName(FItemField).Text;
  with (Selected as TRADBTreeNode) do
    if FIconField <> '' then begin
      ImageIndex := Var2Type(FDataLink.DataSet[FIconField], varInteger);
      SelectedIndex := ImageIndex + FSelectedIndex;
    end;
 {*** ParentNode changed ?}
  if ((Selected.Parent <> nil) and
      (FDataLink.DataSet[FDetailField] <>
       (Selected.Parent as TRADBTreeNode).FMasterValue))
      or
     ((Selected.Parent = nil) and
      (FDataLink.DataSet[FDetailField] <> FStartMasterValue))
  then begin
    Node := FindNode(FDataLink.DataSet[FDetailField]);
    if (FDataLink.DataSet[FDetailField] = FStartMasterValue) or
       (Node <> nil) then
      (Selected as TRADBTreeNode).MoveTo(Node, naAddChild)
    else
      Selected.Free;
  end;
 {###}
 {*** MasterValue changed ?}
  if (FDataLink.DataSet[FMasterField] <>
     (Selected as TRADBTreeNode).FMasterValue)
  then begin
    with (Selected as TRADBTreeNode) do begin
      FMasterValue := FDataLink.DataSet[FMasterField];
      if FIconField <> '' then begin
        ImageIndex := Var2Type(FDataLink.DataSet[FIconField], varInteger);
        SelectedIndex := ImageIndex + FSelectedIndex;
      end;
    end;  
    {that must I do with Childrens ?}
    {if you now, place your code there...}
  end;
 {###}
end;

function TCustomRADBTreeView.CanEdit(Node: TTreeNode): Boolean;
begin
  Result := inherited CanEdit(Node);
  if FDataLink.DataSet <> nil then
   Result := Result and not FDataLink.ReadOnly;
end;

procedure TCustomRADBTreeView.Edit(const Item: TTVItem);
begin
  CheckDataSet;
  inherited Edit(Item);
  if Assigned(Selected) then begin
    inc(FUpdateLock);
    try
      if Item.pszText <> nil then begin
        if FDataLink.Edit then
          FDataLink.DataSet.FieldByName(FItemField).Text := Item.pszText;
        Change2(Self.Selected); {?}
      end else begin
        FDataLink.DataSet.Cancel;
        if InAddChild then begin
          Self.Selected.Free;
          if Sel <> nil then Selected := Sel;
        end;
      end;
    finally
      InAddChild := false;
      dec(FUpdateLock);
    end;
  end;
end;

function TCustomRADBTreeView.AddChildNode(const Node : TTreeNode; const Select : boolean) : TRADBTreeNode;
var
  MV : variant;
  M : string;
begin
  CheckDataSet;
  if Assigned(Node) then
    MV := (Node as TRADBTreeNode).FMasterValue else
    MV := FStartMasterValue;
  if Assigned(Node) and Node.HasChildren and (Node.Count = 0) then
    RefreshChild(Node as TRADBTreeNode);
  inc(FUpdateLock);
  InAddChild := true;
  try
    oldRecCount := FDataLink.DataSet.RecordCount + 1;
    FDataLink.DataSet.Append;
    FDataLink.DataSet[FDetailField] := MV;
    if FDataLink.DataSet.FieldValues[FItemField] = null then
      M := '' else
      M := FDataLink.DataSet.FieldByName(FItemField).Text;
    Result := Items.AddChild(Node, M) as TRADBTreeNode;
    with Result do begin
      FMasterValue := FDataLink.DataSet.FieldValues[FMasterField];
      if FIconField <> '' then
      begin
        ImageIndex := Var2Type(FDataLink.DataSet[FIconField], varInteger);
        SelectedIndex := ImageIndex + FSelectedIndex;
      end;
    end;
    Result.Selected := Select;
    Result.Selected := Select; {эта строка очень нужна, ну не понимает он с первого раза}
  finally                                
    dec(FUpdateLock);
  end;
end;

procedure TCustomRADBTreeView.DeleteNode(Node : TTreeNode);
var
  NewSel : TTreeNode;
begin
  CheckDataSet;
  inc(FUpdateLock);
  InDelete := true;
  try
    NewSel := FindNextNode(Selected);
    FDataLink.DataSet.Delete;
    Selected.Free;
    if NewSel <> nil then
      NewSel.Selected := true;
  finally
    InDelete := false;
    dec(FUpdateLock);
  end;
end;

function TCustomRADBTreeView.FindNextNode(const Node : TTreeNode) : TTreeNode;
begin
  if (Node <> nil) and (Node.Parent <> nil) then
    if Node.Parent.Count > 1 then
      if Node.Index = Node.Parent.Count-1 then
        Result := Node.Parent[Node.Index-1] else
        Result := Node.Parent[Node.Index+1]
    else
      Result := Node.Parent
  else
   { if Items.Count > 1 then
      if Node.Index = Items.Count-1 then
        Result := Items[Node.Index-1] else
        Result := Items[Node.Index+1]
    else} Result := nil;
end;

procedure TCustomRADBTreeView.MoveTo(Source, Destination: TRADBTreeNode; Mode: TNodeAttachMode);
var
  MV, V : variant;
begin
  CheckDataSet;
  if FUpdateLock = 0 then begin
    inc(FUpdateLock);
    try
      MV := Source.FMasterValue;
      if FDataLink.DataSet.Locate(FMasterField, MV, []) and
         FDataLink.Edit
      then begin
        case Mode of
          naAdd :
            if Destination.Parent <> nil then
              V := (Destination.Parent as TRADBTreeNode).FMasterValue
            else
              V := FStartMasterValue;
          naAddChild : V := Destination.FMasterValue;
          else raise ERADBTreeViewError.Create(SMoveToModeError);
        end;
        FDataLink.DataSet[FDetailField] := V;
      end;
    finally
      dec(FUpdateLock);
    end;
  end;
end;

{******************* Drag'n'Drop ********************}
procedure TCustomRADBTreeView.timerDnDTimer(Sender: TObject);
begin
  if (YY < DnDScrollArea) then
    Perform(WM_VSCROLL, SB_LINEUP, 0)
  else if (YY > ClientHeight - DnDScrollArea) then
    Perform(WM_VSCROLL, SB_LINEDOWN, 0);
end;

procedure TCustomRADBTreeView.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Node : TTreeNode;
  HT: THitTests;
begin
  inherited DragOver(Source, X, Y, State, Accept);
  if ValidDataSet and (DragMode = dmAutomatic) and
     not FDataLink.ReadOnly and not Accept
  then begin
    HT := GetHitTestInfoAt(X, Y);
    Node := GetNodeAt(X, Y);
    Accept := (Source = Self) and Assigned(Selected) and
              (Node <> Selected) and Assigned(Node) and
               not Node.HasAsParent(Selected) and
              (HT - [htOnLabel, htOnItem, htOnIcon, htNowhere, htOnIndent, htOnButton] <> HT);
    YY := Y;
    timerDnD.Enabled := ((Y < DnDScrollArea) or (Y > ClientHeight - DnDScrollArea));
  end;
end;

procedure TCustomRADBTreeView.DragDrop(Source: TObject; X, Y: Integer);
var
  AnItem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
begin
  timerDnD.Enabled := false;
  inherited DragDrop(Source, X, Y);
  AnItem := GetNodeAt(X, Y);
  if ValidDataSet and (DragMode = dmAutomatic) and Assigned(Selected) and Assigned(AnItem) then
  begin
    HT := GetHitTestInfoAt(X, Y);
    if (HT - [htOnItem, htOnLabel, htOnIcon, htNowhere, htOnIndent, htOnButton] <> HT) then
    begin
      if (HT - [htOnItem, htOnLabel, htOnIcon] <> HT) then
        AttachMode := naAddChild else
        AttachMode := naAdd;
      (Selected as TRADBTreeNode).MoveTo(AnItem, AttachMode);
    end;
  end;
{
var
  AnItem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
begin
  if TreeView1.Selected = nil then Exit;
  HT := TreeView1.GetHitTestInfoAt(X, Y);
  AnItem := TreeView1.GetNodeAt(X, Y);
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then
  begin
    if (htOnItem in HT) or (htOnIcon in HT) then AttachMode := naAddChild
    else if htNowhere in HT then AttachMode := naAdd

    else if htOnIndent in HT then AttachMode := naInsert;
    TreeView1.Selected.MoveTo(AnItem, AttachMode);
  end;
end;
}  
end;

{################### Drag'n'Drop ####################}

procedure TCustomRADBTreeView.KeyDown(var Key: Word; Shift: TShiftState);
  procedure DeleteSelected;
  var
    M : string;
  begin
    if Selected.HasChildren then M := SDeleteNode2 else M := SDeleteNode;
    if MessageDlg(Format(M, [Selected.Text]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      DeleteNode(Selected);
  end;
begin
  inherited KeyDown(Key, Shift);
  if not ValidDataSet or (FDataLink.ReadOnly) or ReadOnly then exit;
  case Key of
    VK_DELETE :
      if ([ssCtrl] = Shift) and Assigned(Selected) then
        DeleteSelected;
    VK_INSERT :
      if not IsEditing then begin
        Sel := Selected;
        if [ssAlt] = Shift then
          //AddChild
          AddChildNode(Selected, true).EditText
        else
          //Add
          AddChildNode(Selected.Parent, true).EditText;
      end;
    VK_F2 : if Selected <> nil then Selected.EditText;
  end;
end;

end.

