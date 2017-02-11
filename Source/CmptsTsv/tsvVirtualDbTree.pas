unit tsvVirtualDbTree;

interface

uses Classes, VirtualTrees, VirtualDbTree;

type

  TtsvVirtualDbTree=class;

  TtsvVirtualDbNode=class;

  PtsvVirtualDbNodeRecord = ^TtsvVirtualDbNodeRecord;
  TtsvVirtualDbNodeRecord = Record
    DBNode: TtsvVirtualDbNode;
  End;

  TtsvVirtualDbNode=class(TObject)
  private
    FNode: PVirtualNode;
    FData: PDBVTData;
    function GetIndex: Cardinal;
    function GetChildCount: Cardinal;
    function GetCheckState: TCheckState;
    procedure SetCheckState(Value: TCheckState);
    function GetID: Variant;
  public
    constructor CreateByNode(ANode: PVirtualNode; AData: PDBVTData); virtual;
    destructor Destroy; override;

    property Node: PVirtualNode read FNode;
  published
    property Index: Cardinal read GetIndex;
    property ChildCount: Cardinal read GetChildCount;
    property CheckState: TCheckState read GetCheckState write SetCheckState;
    property ID: Variant read GetID;
  end;

  TtsvVirtualNodeOnGetImageIndexEvent = procedure (Sender: TtsvVirtualDbTree;  Node: TtsvVirtualDbNode;
                                                   Kind: TVTImageKind; Column: Integer; var Ghosted: Boolean;
                                                   var ImageIndex: Integer) of object;

  TtsvVirtualDbTree=class(TVirtualDBTree)
  private
    FDataSize: Integer;
    FOnGetImageIndex: TtsvVirtualNodeOnGetImageIndexEvent;
    function GetVirtualDbNode(Node: PVirtualNode): TtsvVirtualDbNode;
  protected
    procedure DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: Integer;
                              var Ghosted: Boolean; var Index: Integer); override;
    Procedure DoInitNode(Parent, Node: PVirtualNode; Var InitStates: TVirtualNodeInitStates); Override;
    Procedure DoReadNodeFromDB(Node: PVirtualNode); Override;
    Procedure DoFreeNode(Node: PVirtualNode); Override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetFirst: TtsvVirtualDbNode;
    function GetNext(Node: TtsvVirtualDbNode): TtsvVirtualDbNode; 
  published
    property OnGetImageIndex: TtsvVirtualNodeOnGetImageIndexEvent read FOnGetImageIndex write FOnGetImageIndex;
  end;

implementation

type
  TSimpleData = Record
    Text: WideString;
  End;
  PSimpleData = ^TSimpleData;

{ TtsvVirtualDbNode }

constructor TtsvVirtualDbNode.CreateByNode(ANode: PVirtualNode; AData: PDBVTData);
begin
  inherited Create;
  FNode:=ANode;
  FData:=AData;
end;

destructor TtsvVirtualDbNode.Destroy;
begin
  inherited;
end;

function TtsvVirtualDbNode.GetIndex: Cardinal;
begin
  Result:=0;
  if Assigned(FNode) then
    Result:=FNode.Index;
end;

function TtsvVirtualDbNode.GetChildCount: Cardinal;
begin
  Result:=0;
  if Assigned(FNode) then
    Result:=FNode.ChildCount;
end;

function TtsvVirtualDbNode.GetCheckState: TCheckState;
begin
  Result:=csUncheckedNormal;
  if Assigned(FNode) then
    Result:=FNode.CheckState;
end;

procedure TtsvVirtualDbNode.SetCheckState(Value: TCheckState);
begin
  if Assigned(FNode) then
    FNode.CheckState:=Value;
end;

function TtsvVirtualDbNode.GetID: Variant;
begin
  Result:=Unassigned;
  if Assigned(FData) then
    Result:=FData.ID;
end;

{ TtsvVirtualDbTree }

constructor TtsvVirtualDbTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSize := sizeof(TtsvVirtualDbNodeRecord);
  DBNodeDataSize := FDataSize;
end;

procedure TtsvVirtualDbTree.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind;
                                            Column: Integer; var Ghosted: Boolean; var Index: Integer);
var
  NewNode: TtsvVirtualDbNode;
begin
  if Assigned(FOnGetImageIndex) and Assigned(Node) then begin
    NewNode:=GetVirtualDbNode(Node);
    if Assigned(NewNode) then
      FOnGetImageIndex(Self,NewNode,Kind,Column,Ghosted,Index);
  end;
end;

Procedure TtsvVirtualDbTree.DoInitNode(Parent, Node: PVirtualNode; Var InitStates: TVirtualNodeInitStates);
begin
  inherited;
end;

Procedure TtsvVirtualDbTree.DoReadNodeFromDB(Node: PVirtualNode);
var
  Data: PtsvVirtualDbNodeRecord;
  NewNode: TtsvVirtualDbNode;
begin
  inherited DoReadNodeFromDB(Node);
  if Assigned(Node) then begin
    Data:=PtsvVirtualDbNodeRecord(Integer(GetDBNodeData(Node))-FDataSize);
    if Assigned(Data) then begin
      NewNode:=TtsvVirtualDbNode.CreateByNode(Node,GetNodeData(Node));
      Data^.DBNode:=NewNode;
    end;
  end;
end;

Procedure TtsvVirtualDbTree.DoFreeNode(Node: PVirtualNode);
var
  NewNode: TtsvVirtualDbNode;
begin
  NewNode:=GetVirtualDbNode(Node);
  if Assigned(NewNode) then
    NewNode.Free;
  inherited;
end;

function TtsvVirtualDbTree.GetVirtualDbNode(Node: PVirtualNode): TtsvVirtualDbNode;
var
  Data: PtsvVirtualDbNodeRecord;
  P: Pointer;
begin
  Result:=nil;
  if Assigned(Node) then begin
    P:=GetDBNodeData(Node);
    Data:=PtsvVirtualDbNodeRecord(Integer(P)-FDataSize);
    if Assigned(Data) then begin
      Result:=Data^.DBNode;
    end;
  end;
end;

function TtsvVirtualDbTree.GetFirst: TtsvVirtualDbNode;
var
  ANode: PVirtualNode;
begin
  ANode:=inherited GetFirst;
  Result:=GetVirtualDbNode(ANode);
end;

function TtsvVirtualDbTree.GetNext(Node: TtsvVirtualDbNode): TtsvVirtualDbNode;
var
  ANode: PVirtualNode;
begin
  Result:=nil;
  if Assigned(Node) then begin
    ANode:=inherited GetNext(Node.Node);
    Result:=GetVirtualDbNode(ANode);
  end;
end;


end.
