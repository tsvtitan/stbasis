unit tsvInterpreterVirtualTree;

interface

uses ComCtrls, UMainUnited, tsvInterpreterCore, VirtualTrees, VirtualDBTree, tsvVirtualDbTree;

type
  TtsvVirtualDbTreesEvent = class(TEvent)
  public
    procedure GetImageIndexEvent(Sender: TtsvVirtualDbTree;  Node: TtsvVirtualDbNode;
                                 Kind: TVTImageKind; Column: Integer; var Ghosted: Boolean;
                                 var ImageIndex: Integer);
  end;

{ TtsvVirtualDbNode }
procedure TtsvVirtualDbNode_Read_Index(var Value: Variant; Args: TArguments);
procedure TtsvVirtualDbNode_Read_ChildCount(var Value: Variant; Args: TArguments);
procedure TtsvVirtualDbNode_Read_CheckState(var Value: Variant; Args: TArguments);
procedure TtsvVirtualDbNode_Write_CheckState(const Value: Variant; Args: TArguments);
procedure TtsvVirtualDbNode_Read_GetID(var Value: Variant; Args: TArguments);

{ TtsvVirtualDbTree }
procedure TtsvVirtualDbTree_Create(var Value: Variant; Args: TArguments);
procedure TtsvVirtualDbTree_GetFirst(var Value: Variant; Args: TArguments);
procedure TtsvVirtualDbTree_GetNext(var Value: Variant; Args: TArguments);
procedure TtsvVirtualDbTree_Read_TotalCount(var Value: Variant; Args: TArguments);

implementation

uses Classes;

{ TtsvVirtualDbTreesEvent }

procedure TtsvVirtualDbTreesEvent.GetImageIndexEvent(Sender: TtsvVirtualDbTree;  Node: TtsvVirtualDbNode;
                                                  Kind: TVTImageKind; Column: Integer; var Ghosted: Boolean;
                                                  var ImageIndex: Integer);
begin
  CallFunction( [O2V(Sender), O2V(Node), Kind, Column, Ghosted, ImageIndex]);
  Ghosted:=Args.Values[4];
  ImageIndex:=Args.Values[5];
end;

{ TtsvVirtualDbNode }

procedure TtsvVirtualDbNode_Read_Index(var Value: Variant; Args: TArguments);
begin
  Value:=Integer(TtsvVirtualDbNode(Args.Obj).Index);
end;

procedure TtsvVirtualDbNode_Read_ChildCount(var Value: Variant; Args: TArguments);
begin
  Value:=Integer(TtsvVirtualDbNode(Args.Obj).ChildCount);
end;

procedure TtsvVirtualDbNode_Read_CheckState(var Value: Variant; Args: TArguments);
begin
  Value:=Integer(TtsvVirtualDbNode(Args.Obj).CheckState);
end;

procedure TtsvVirtualDbNode_Write_CheckState(const Value: Variant; Args: TArguments);
begin
  TtsvVirtualDbNode(Args.Obj).CheckState := Value;
end;

procedure TtsvVirtualDbNode_Read_GetID(var Value: Variant; Args: TArguments);
begin
  Value:=Integer(TtsvVirtualDbNode(Args.Obj).Id);
end;

{ TtsvVirtualDbTree }

{ constructor Create(AOwner: TComponent) }
procedure TtsvVirtualDbTree_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TtsvVirtualDbTree.Create(V2O(Args.Values[0]) as TComponent));
end;

// function GetFirst: TtsvVirtualDbNode;
procedure TtsvVirtualDbTree_GetFirst(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TtsvVirtualDbNode(TtsvVirtualDbTree(Args.Obj).GetFirst));
end;

// function GetNext(Node: TtsvVirtualDbNode): TtsvVirtualDbNode;
procedure TtsvVirtualDbTree_GetNext(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TtsvVirtualDbNode(TtsvVirtualDbTree(Args.Obj).GetNext(TtsvVirtualDbNode(V2O(Args.Values[0])))));
end;

// function GetTotalCount: Cardinal;
procedure TtsvVirtualDbTree_Read_TotalCount(var Value: Variant; Args: TArguments);
begin
  Value:=Integer(TtsvVirtualDbTree(Args.Obj).TotalCount);
end;

end.

