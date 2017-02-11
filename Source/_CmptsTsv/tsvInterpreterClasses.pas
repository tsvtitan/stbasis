unit tsvInterpreterClasses;

interface

uses Classes, UMainUnited, tsvInterpreterCore;


type

  TClassesEvent = class(TEvent)
  public
    procedure NotifyEvent(Sender: TObject);
    function HelpEvent(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
  end;

procedure TList_Create(var Value: Variant; Args: TArguments);
procedure TList_Add(var Value: Variant; Args: TArguments);
procedure TList_Clear(var Value: Variant; Args: TArguments);
procedure TList_Delete(var Value: Variant; Args: TArguments);
procedure TList_Exchange(var Value: Variant; Args: TArguments);
procedure TList_Expand(var Value: Variant; Args: TArguments);
procedure TList_First(var Value: Variant; Args: TArguments);
procedure TList_IndexOf(var Value: Variant; Args: TArguments);
procedure TList_Insert(var Value: Variant; Args: TArguments);
procedure TList_Last(var Value: Variant; Args: TArguments);
procedure TList_Move(var Value: Variant; Args: TArguments);
procedure TList_Remove(var Value: Variant; Args: TArguments);
procedure TList_Pack(var Value: Variant; Args: TArguments);

procedure TPersistent_Assign(var Value: Variant; Args: TArguments);
procedure TPersistent_GetNamePath(var Value: Variant; Args: TArguments);

procedure TCollectionItem_Create(var Value: Variant; Args: TArguments);
procedure TCollectionItem_Read_Collection(var Value: Variant; Args: TArguments);
procedure TCollectionItem_Write_Collection(const Value: Variant; Args: TArguments);
procedure TCollectionItem_Read_ID(var Value: Variant; Args: TArguments);
procedure TCollectionItem_Read_Index(var Value: Variant; Args: TArguments);
procedure TCollectionItem_Write_Index(const Value: Variant; Args: TArguments);
procedure TCollectionItem_Read_DisplayName(var Value: Variant; Args: TArguments);
procedure TCollectionItem_Write_DisplayName(const Value: Variant; Args: TArguments);

procedure TCollection_Create(var Value: Variant; Args: TArguments);
procedure TCollection_Add(var Value: Variant; Args: TArguments);
procedure TCollection_Assign(var Value: Variant; Args: TArguments);
procedure TCollection_BeginUpdate(var Value: Variant; Args: TArguments);
procedure TCollection_Clear(var Value: Variant; Args: TArguments);
procedure TCollection_EndUpdate(var Value: Variant; Args: TArguments);
procedure TCollection_FindItemID(var Value: Variant; Args: TArguments);
procedure TCollection_Read_Count(var Value: Variant; Args: TArguments);
procedure TCollection_Read_ItemClass(var Value: Variant; Args: TArguments);
procedure TCollection_Read_Items(var Value: Variant; Args: TArguments);
procedure TCollection_Write_Items(const Value: Variant; Args: TArguments);

procedure TStrings_Add(var Value: Variant; Args: TArguments);
procedure TStrings_AddObject(var Value: Variant; Args: TArguments);
procedure TStrings_Append(var Value: Variant; Args: TArguments);
procedure TStrings_AddStrings(var Value: Variant; Args: TArguments);
procedure TStrings_Assign(var Value: Variant; Args: TArguments);
procedure TStrings_BeginUpdate(var Value: Variant; Args: TArguments);
procedure TStrings_Clear(var Value: Variant; Args: TArguments);
procedure TStrings_Delete(var Value: Variant; Args: TArguments);
procedure TStrings_EndUpdate(var Value: Variant; Args: TArguments);
procedure TStrings_Equals(var Value: Variant; Args: TArguments);
procedure TStrings_Exchange(var Value: Variant; Args: TArguments);
procedure TStrings_IndexOf(var Value: Variant; Args: TArguments);
procedure TStrings_IndexOfName(var Value: Variant; Args: TArguments);
procedure TStrings_IndexOfObject(var Value: Variant; Args: TArguments);
procedure TStrings_Insert(var Value: Variant; Args: TArguments);
procedure TStrings_InsertObject(var Value: Variant; Args: TArguments);
procedure TStrings_LoadFromFile(var Value: Variant; Args: TArguments);
procedure TStrings_LoadFromStream(var Value: Variant; Args: TArguments);
procedure TStrings_Move(var Value: Variant; Args: TArguments);
procedure TStrings_SaveToFile(var Value: Variant; Args: TArguments);
procedure TStrings_SaveToStream(var Value: Variant; Args: TArguments);
procedure TStrings_Read_Capacity(var Value: Variant; Args: TArguments);
procedure TStrings_Write_Capacity(const Value: Variant; Args: TArguments);
procedure TStrings_Read_CommaText(var Value: Variant; Args: TArguments);
procedure TStrings_Write_CommaText(const Value: Variant; Args: TArguments);
procedure TStrings_Read_Count(var Value: Variant; Args: TArguments);
procedure TStrings_Read_Names(var Value: Variant; Args: TArguments);
procedure TStrings_Read_Values(var Value: Variant; Args: TArguments);
procedure TStrings_Write_Values(const Value: Variant; Args: TArguments);
procedure TStrings_Read_Objects(var Value: Variant; Args: TArguments);
procedure TStrings_Write_Objects(const Value: Variant; Args: TArguments);
procedure TStrings_Read_Strings(var Value: Variant; Args: TArguments);
procedure TStrings_Write_Strings(const Value: Variant; Args: TArguments);
procedure TStrings_Read_Text(var Value: Variant; Args: TArguments);
procedure TStrings_Write_Text(const Value: Variant; Args: TArguments);

procedure TStringList_Create(var Value: Variant; Args: TArguments);
procedure TStringList_Add(var Value: Variant; Args: TArguments);
procedure TStringList_Clear(var Value: Variant; Args: TArguments);
procedure TStringList_Delete(var Value: Variant; Args: TArguments);
procedure TStringList_Exchange(var Value: Variant; Args: TArguments);
procedure TStringList_Find(var Value: Variant; Args: TArguments);
procedure TStringList_IndexOf(var Value: Variant; Args: TArguments);
procedure TStringList_Insert(var Value: Variant; Args: TArguments);
procedure TStringList_Sort(var Value: Variant; Args: TArguments);
procedure TStringList_Read_Duplicates(var Value: Variant; Args: TArguments);
procedure TStringList_Write_Duplicates(const Value: Variant; Args: TArguments);
procedure TStringList_Read_Sorted(var Value: Variant; Args: TArguments);
procedure TStringList_Write_Sorted(const Value: Variant; Args: TArguments);

procedure TStream_Read(var Value: Variant; Args: TArguments);
procedure TStream_Write(var Value: Variant; Args: TArguments);
procedure TStream_Seek(var Value: Variant; Args: TArguments);
procedure TStream_ReadBuffer(var Value: Variant; Args: TArguments);
procedure TStream_WriteBuffer(var Value: Variant; Args: TArguments);
procedure TStream_CopyFrom(var Value: Variant; Args: TArguments);
procedure TStream_ReadComponent(var Value: Variant; Args: TArguments);
procedure TStream_ReadComponentRes(var Value: Variant; Args: TArguments);
procedure TStream_WriteComponent(var Value: Variant; Args: TArguments);
procedure TStream_WriteComponentRes(var Value: Variant; Args: TArguments);
procedure TStream_WriteDescendent(var Value: Variant; Args: TArguments);
procedure TStream_WriteDescendentRes(var Value: Variant; Args: TArguments);
procedure TStream_ReadResHeader(var Value: Variant; Args: TArguments);
procedure TStream_Read_Position(var Value: Variant; Args: TArguments);
procedure TStream_Write_Position(const Value: Variant; Args: TArguments);
procedure TStream_Read_Size(var Value: Variant; Args: TArguments);
procedure TStream_Write_Size(const Value: Variant; Args: TArguments);

procedure TFileStream_Create(var Value: Variant; Args: TArguments);
procedure TMemoryStream_Create(var Value: Variant; Args: TArguments);
procedure TMemoryStream_Clear(var Value: Variant; Args: TArguments);
procedure TMemoryStream_LoadFromFile(var Value: Variant; Args: TArguments);
procedure TMemoryStream_SaveToFile(var Value: Variant; Args: TArguments);

procedure TStringStream_Create(var Value: Variant; Args: TArguments);
procedure TStringStream_Read(var Value: Variant; Args: TArguments);
procedure TStringStream_ReadString(var Value: Variant; Args: TArguments);
procedure TStringStream_Seek(var Value: Variant; Args: TArguments);
procedure TStringStream_Write(var Value: Variant; Args: TArguments);
procedure TStringStream_WriteString(var Value: Variant; Args: TArguments);
procedure TStringStream_Read_DataString(var Value: Variant; Args: TArguments);

procedure TComponent_Create(var Value: Variant; Args: TArguments);
procedure TComponent_DestroyComponents(var Value: Variant; Args: TArguments);
procedure TComponent_Destroying(var Value: Variant; Args: TArguments);
procedure TComponent_FindComponent(var Value: Variant; Args: TArguments);
procedure TComponent_FreeNotification(var Value: Variant; Args: TArguments);
procedure TComponent_FreeOnRelease(var Value: Variant; Args: TArguments);
procedure TComponent_GetParentComponent(var Value: Variant; Args: TArguments);
procedure TComponent_HasParent(var Value: Variant; Args: TArguments);
procedure TComponent_InsertComponent(var Value: Variant; Args: TArguments);
procedure TComponent_RemoveComponent(var Value: Variant; Args: TArguments);
procedure TComponent_SafeCallException(var Value: Variant; Args: TArguments);
procedure TComponent_Read_Components(var Value: Variant; Args: TArguments);
procedure TComponent_Read_ComponentCount(var Value: Variant; Args: TArguments);
procedure TComponent_Read_ComponentIndex(var Value: Variant; Args: TArguments);
procedure TComponent_Write_ComponentIndex(const Value: Variant; Args: TArguments);
procedure TComponent_Read_DesignInfo(var Value: Variant; Args: TArguments);
procedure TComponent_Write_DesignInfo(const Value: Variant; Args: TArguments);
procedure TComponent_Read_Owner(var Value: Variant; Args: TArguments);
procedure TComponent_Read_VCLComObject(var Value: Variant; Args: TArguments);
procedure TComponent_Write_VCLComObject(const Value: Variant; Args: TArguments);
procedure TComponent_Read_Name(var Value: Variant; Args: TArguments);
procedure TComponent_Write_Name(const Value: Variant; Args: TArguments);
procedure TComponent_Read_Tag(var Value: Variant; Args: TArguments);
procedure TComponent_Write_Tag(const Value: Variant; Args: TArguments);


implementation

uses typInfo, Dialogs;

{ TClassesEvent }

procedure TClassesEvent.NotifyEvent(Sender: TObject);
begin
  CallFunction([O2V(Sender)]);
end;

function TClassesEvent.HelpEvent(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
begin
  Result := CallFunction([Command, Data, CallHelp]);
  CallHelp := Args.Values[2];
end;

  { TList }

{  constructor }
procedure TList_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TList.Create);
end;

{  function Add(Item: Pointer): Integer; }
procedure TList_Add(var Value: Variant; Args: TArguments);
begin
  Value := TList(Args.Obj).Add(V2P(Args.Values[0]));
end;

{  procedure Clear; }
procedure TList_Clear(var Value: Variant; Args: TArguments);
begin
  TList(Args.Obj).Clear;
end;

{  procedure Delete(Index: Integer); }
procedure TList_Delete(var Value: Variant; Args: TArguments);
begin
  TList(Args.Obj).Delete(Args.Values[0]);
end;

{  procedure Exchange(Index1, Index2: Integer); }
procedure TList_Exchange(var Value: Variant; Args: TArguments);
begin
  TList(Args.Obj).Exchange(Args.Values[0], Args.Values[1]);
end;

{  function Expand: TList; }
procedure TList_Expand(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TList(Args.Obj).Expand);
end;

{  function First: Pointer; }
procedure TList_First(var Value: Variant; Args: TArguments);
begin
  Value := P2V(TList(Args.Obj).First);
end;

{  function IndexOf(Item: Pointer): Integer; }
procedure TList_IndexOf(var Value: Variant; Args: TArguments);
begin
  Value := TList(Args.Obj).IndexOf(V2P(Args.Values[0]));
end;

{  procedure Insert(Index: Integer; Item: Pointer); }
procedure TList_Insert(var Value: Variant; Args: TArguments);
begin
  TList(Args.Obj).Insert(Args.Values[0], V2P(Args.Values[1]));
end;

{  function Last: Pointer; }
procedure TList_Last(var Value: Variant; Args: TArguments);
begin
  Value := P2V(TList(Args.Obj).Last);
end;

{  procedure Move(CurIndex, NewIndex: Integer); }
procedure TList_Move(var Value: Variant; Args: TArguments);
begin
  TList(Args.Obj).Move(Args.Values[0], Args.Values[1]);
end;

{  function Remove(Item: Pointer): Integer; }
procedure TList_Remove(var Value: Variant; Args: TArguments);
begin
  Value := TList(Args.Obj).Remove(V2P(Args.Values[0]));
end;

{  procedure Pack; }
procedure TList_Pack(var Value: Variant; Args: TArguments);
begin
  TList(Args.Obj).Pack;
end;

  { TPersistent }

{  procedure Assign(Source: TPersistent); }
procedure TPersistent_Assign(var Value: Variant; Args: TArguments);
begin
  TPersistent(Args.Obj).Assign(V2O(Args.Values[0]) as TPersistent);
end;

{  function GetNamePath: string; }
procedure TPersistent_GetNamePath(var Value: Variant; Args: TArguments);
begin
  Value := TPersistent(Args.Obj).GetNamePath;
end;

  { TCollectionItem }

{ constructor Create(Collection: TCollection) }
procedure TCollectionItem_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCollectionItem.Create(V2O(Args.Values[0]) as TCollection));
end;

{ property Read Collection: TCollection }
procedure TCollectionItem_Read_Collection(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCollectionItem(Args.Obj).Collection);
end;

{ property Write Collection(Value: TCollection) }
procedure TCollectionItem_Write_Collection(const Value: Variant; Args: TArguments);
begin
  TCollectionItem(Args.Obj).Collection := V2O(Value) as TCollection;
end;

{ property Read ID: Integer }
procedure TCollectionItem_Read_ID(var Value: Variant; Args: TArguments);
begin
  Value := TCollectionItem(Args.Obj).ID;
end;

{ property Read Index: Integer }
procedure TCollectionItem_Read_Index(var Value: Variant; Args: TArguments);
begin
  Value := TCollectionItem(Args.Obj).Index;
end;

{ property Write Index(Value: Integer) }
procedure TCollectionItem_Write_Index(const Value: Variant; Args: TArguments);
begin
  TCollectionItem(Args.Obj).Index := Value;
end;

{ property Read DisplayName: string }
procedure TCollectionItem_Read_DisplayName(var Value: Variant; Args: TArguments);
begin
  Value := TCollectionItem(Args.Obj).DisplayName;
end;

{ property Write DisplayName(Value: string) }
procedure TCollectionItem_Write_DisplayName(const Value: Variant; Args: TArguments);
begin
  TCollectionItem(Args.Obj).DisplayName := Value;
end;

  { TCollection }

{ constructor Create(ItemClass: TCollectionItemClass) }
procedure TCollection_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCollection.Create(TCollectionItemClass(V2O(Args.Values[0]))));
end;

{  function Add: TCollectionItem; }
procedure TCollection_Add(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCollection(Args.Obj).Add);
end;

{  procedure Assign(Source: TPersistent); }
procedure TCollection_Assign(var Value: Variant; Args: TArguments);
begin
  TCollection(Args.Obj).Assign(V2O(Args.Values[0]) as TPersistent);
end;

{  procedure BeginUpdate; }
procedure TCollection_BeginUpdate(var Value: Variant; Args: TArguments);
begin
  TCollection(Args.Obj).BeginUpdate;
end;

{  procedure Clear; }
procedure TCollection_Clear(var Value: Variant; Args: TArguments);
begin
  TCollection(Args.Obj).Clear;
end;

{  procedure EndUpdate; }
procedure TCollection_EndUpdate(var Value: Variant; Args: TArguments);
begin
  TCollection(Args.Obj).EndUpdate;
end;

{  function FindItemID(ID: Integer): TCollectionItem; }
procedure TCollection_FindItemID(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCollection(Args.Obj).FindItemID(Args.Values[0]));
end;

{ property Read Count: Integer }
procedure TCollection_Read_Count(var Value: Variant; Args: TArguments);
begin
  Value := TCollection(Args.Obj).Count;
end;

{ property Read ItemClass: TCollectionItemClass }
procedure TCollection_Read_ItemClass(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TObject(TCollection(Args.Obj).ItemClass));
end;

{ property Read Items[Integer]: TCollectionItem }
procedure TCollection_Read_Items(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TCollection(Args.Obj).Items[Args.Values[0]]);
end;

{ property Write Items[Integer]: TCollectionItem }
procedure TCollection_Write_Items(const Value: Variant; Args: TArguments);
begin
  TCollection(Args.Obj).Items[Args.Values[0]] := V2O(Value) as TCollectionItem;
end;

  { TStrings }



{  function Add(const S: string): Integer; }
procedure TStrings_Add(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Add(Args.Values[0]);
end;

{  function AddObject(const S: string; AObject: TObject): Integer; }
procedure TStrings_AddObject(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).AddObject(Args.Values[0], V2O(Args.Values[1]));
end;

{  procedure Append(const S: string); }
procedure TStrings_Append(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Append(Args.Values[0]);
end;

{  procedure AddStrings(Strings: TStrings); }
procedure TStrings_AddStrings(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).AddStrings(V2O(Args.Values[0]) as TStrings);
end;

{  procedure Assign(Source: TPersistent); }
procedure TStrings_Assign(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Assign(V2O(Args.Values[0]) as TPersistent);
end;

{  procedure BeginUpdate; }
procedure TStrings_BeginUpdate(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).BeginUpdate;
end;

{  procedure Clear; }
procedure TStrings_Clear(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Clear;
end;

{  procedure Delete(Index: Integer); }
procedure TStrings_Delete(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Delete(Args.Values[0]);
end;

{  procedure EndUpdate; }
procedure TStrings_EndUpdate(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).EndUpdate;
end;

{  function Equals(Strings: TStrings): Boolean; }
procedure TStrings_Equals(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Equals(V2O(Args.Values[0]) as TStrings);
end;

{  procedure Exchange(Index1, Index2: Integer); }
procedure TStrings_Exchange(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Exchange(Args.Values[0], Args.Values[1]);
end;

{  function IndexOf(const S: string): Integer; }
procedure TStrings_IndexOf(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).IndexOf(Args.Values[0]);
end;

{  function IndexOfName(const Name: string): Integer; }
procedure TStrings_IndexOfName(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).IndexOfName(Args.Values[0]);
end;

{  function IndexOfObject(AObject: TObject): Integer; }
procedure TStrings_IndexOfObject(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).IndexOfObject(V2O(Args.Values[0]));
end;

{  procedure Insert(Index: Integer; const S: string); }
procedure TStrings_Insert(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Insert(Args.Values[0], Args.Values[1]);
end;

{  procedure InsertObject(Index: Integer; const S: string; AObject: TObject); }
procedure TStrings_InsertObject(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).InsertObject(Args.Values[0], Args.Values[1], V2O(Args.Values[2]));
end;

{  procedure LoadFromFile(const FileName: string); }
procedure TStrings_LoadFromFile(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).LoadFromFile(Args.Values[0]);
end;

{  procedure LoadFromStream(Stream: TStream); }
procedure TStrings_LoadFromStream(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).LoadFromStream(V2O(Args.Values[0]) as TStream);
end;

{  procedure Move(CurIndex, NewIndex: Integer); }
procedure TStrings_Move(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Move(Args.Values[0], Args.Values[1]);
end;

{  procedure SaveToFile(const FileName: string); }
procedure TStrings_SaveToFile(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).SaveToFile(Args.Values[0]);
end;

{  procedure SaveToStream(Stream: TStream); }
procedure TStrings_SaveToStream(var Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).SaveToStream(V2O(Args.Values[0]) as TStream);
end;

{ property Read Capacity: Integer }
procedure TStrings_Read_Capacity(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Capacity;
end;

{ property Write Capacity(Value: Integer) }
procedure TStrings_Write_Capacity(const Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Capacity := Value;
end;

{ property Read CommaText: string }
procedure TStrings_Read_CommaText(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).CommaText;
end;

{ property Write CommaText(Value: string) }
procedure TStrings_Write_CommaText(const Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).CommaText := Value;
end;

{ property Read Count: Integer }
procedure TStrings_Read_Count(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Count;
end;

{ property Read Names[Integer]: string }
procedure TStrings_Read_Names(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Names[Args.Values[0]];
end;

{ property Read Values[Integer]: string }
procedure TStrings_Read_Values(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Values[Args.Values[0]];
end;

{ property Write Values[Integer]: string }  // ivan_ra
procedure TStrings_Write_Values(const Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Values[Args.Values[0]] := Value;
end;

{ property Read Objects[Integer]: TObject }
procedure TStrings_Read_Objects(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TStrings(Args.Obj).Objects[Args.Values[0]]);
end;

{ property Write Objects[Integer]: TObject }
procedure TStrings_Write_Objects(const Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Objects[Args.Values[0]] := V2O(Value);
end;

{ property Read Strings[Integer]: string }
procedure TStrings_Read_Strings(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Strings[Args.Values[0]];
end;

{ property Write Strings[Integer]: string }
procedure TStrings_Write_Strings(const Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Strings[Args.Values[0]] := Value;
end;

{ property Read Text: string }
procedure TStrings_Read_Text(var Value: Variant; Args: TArguments);
begin
  Value := TStrings(Args.Obj).Text;
end;

{ property Write Text(Value: string) }
procedure TStrings_Write_Text(const Value: Variant; Args: TArguments);
begin
  TStrings(Args.Obj).Text := Value;
end;

  { TStringList }

{  constructor }
procedure TStringList_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TStringList.Create);
end;

{  function Add(const S: string): Integer; }
procedure TStringList_Add(var Value: Variant; Args: TArguments);
begin
  Value := TStringList(Args.Obj).Add(Args.Values[0]);
end;

{  procedure Clear; }
procedure TStringList_Clear(var Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Clear;
end;

{  procedure Delete(Index: Integer); }
procedure TStringList_Delete(var Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Delete(Args.Values[0]);
end;

{  procedure Exchange(Index1, Index2: Integer); }
procedure TStringList_Exchange(var Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Exchange(Args.Values[0], Args.Values[1]);
end;

{  function Find(const S: string; var Index: Integer): Boolean; }
procedure TStringList_Find(var Value: Variant; Args: TArguments);
begin
  Value := TStringList(Args.Obj).Find(Args.Values[0], TVarData(Args.Values[1]).vInteger);
end;

{  function IndexOf(const S: string): Integer; }
procedure TStringList_IndexOf(var Value: Variant; Args: TArguments);
begin
  Value := TStringList(Args.Obj).IndexOf(Args.Values[0]);
end;

{  procedure Insert(Index: Integer; const S: string); }
procedure TStringList_Insert(var Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Insert(Args.Values[0], Args.Values[1]);
end;

{  procedure Sort; }
procedure TStringList_Sort(var Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Sort;
end;

{ property Read Duplicates: TDuplicates }
procedure TStringList_Read_Duplicates(var Value: Variant; Args: TArguments);
begin
  Value := TStringList(Args.Obj).Duplicates;
end;

{ property Write Duplicates(Value: TDuplicates) }
procedure TStringList_Write_Duplicates(const Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Duplicates := Value;
end;

{ property Read Sorted: Boolean }
procedure TStringList_Read_Sorted(var Value: Variant; Args: TArguments);
begin
  Value := TStringList(Args.Obj).Sorted;
end;

{ property Write Sorted(Value: Boolean) }
procedure TStringList_Write_Sorted(const Value: Variant; Args: TArguments);
begin
  TStringList(Args.Obj).Sorted := Value;
end;


  { TStream }

{  function Read(var Buffer; Count: Longint): Longint; }
procedure TStream_Read(var Value: Variant; Args: TArguments);
begin
  Value := TStream(Args.Obj).Read(Args.Values[0], Args.Values[1]);
end;

{  function Write(const Buffer; Count: Longint): Longint; }
procedure TStream_Write(var Value: Variant; Args: TArguments);
begin
  Value := TStream(Args.Obj).Write(Args.Values[0], Args.Values[1]);
end;

{  function Seek(Offset: Longint; Origin: Word): Longint; }
procedure TStream_Seek(var Value: Variant; Args: TArguments);
begin
  Value := TStream(Args.Obj).Seek(Args.Values[0], Args.Values[1]);
end;

{  procedure ReadBuffer(var Buffer; Count: Longint); }
procedure TStream_ReadBuffer(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).ReadBuffer(Args.Values[0], Args.Values[1]);
end;

{  procedure WriteBuffer(const Buffer; Count: Longint); }
procedure TStream_WriteBuffer(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).WriteBuffer(Args.Values[0], Args.Values[1]);
end;

{  function CopyFrom(Source: TStream; Count: Longint): Longint; }
procedure TStream_CopyFrom(var Value: Variant; Args: TArguments);
begin
  Value := TStream(Args.Obj).CopyFrom(V2O(Args.Values[0]) as TStream, Args.Values[1]);
end;

{  function ReadComponent(Instance: TComponent): TComponent; }
procedure TStream_ReadComponent(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TStream(Args.Obj).ReadComponent(V2O(Args.Values[0]) as TComponent));
end;

{  function ReadComponentRes(Instance: TComponent): TComponent; }
procedure TStream_ReadComponentRes(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TStream(Args.Obj).ReadComponentRes(V2O(Args.Values[0]) as TComponent));
end;

{  procedure WriteComponent(Instance: TComponent); }
procedure TStream_WriteComponent(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).WriteComponent(V2O(Args.Values[0]) as TComponent);
end;

{  procedure WriteComponentRes(const ResName: string; Instance: TComponent); }
procedure TStream_WriteComponentRes(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).WriteComponentRes(Args.Values[0], V2O(Args.Values[1]) as TComponent);
end;

{  procedure WriteDescendent(Instance, Ancestor: TComponent); }
procedure TStream_WriteDescendent(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).WriteDescendent(V2O(Args.Values[0]) as TComponent, V2O(Args.Values[1]) as TComponent);
end;

{  procedure WriteDescendentRes(const ResName: string; Instance, Ancestor: TComponent); }
procedure TStream_WriteDescendentRes(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).WriteDescendentRes(Args.Values[0], V2O(Args.Values[1]) as TComponent, V2O(Args.Values[2]) as TComponent);
end;

{  procedure ReadResHeader; }
procedure TStream_ReadResHeader(var Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).ReadResHeader;
end;

{ property Read Position: Longint }
procedure TStream_Read_Position(var Value: Variant; Args: TArguments);
begin
  Value := TStream(Args.Obj).Position;
end;

{ property Write Position(Value: Longint) }
procedure TStream_Write_Position(const Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).Position := Value;
end;

{ property Read Size: Longint }
procedure TStream_Read_Size(var Value: Variant; Args: TArguments);
begin
  Value := TStream(Args.Obj).Size;
end;

{ property Write Size(Value: Longint) }
procedure TStream_Write_Size(const Value: Variant; Args: TArguments);
begin
  TStream(Args.Obj).Size := Value;
end;


  { TFileStream }

{ constructor Create(FileName: string; Mode: Word) }
procedure TFileStream_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TFileStream.Create(Args.Values[0], Args.Values[1]));
end;

  { TMemoryStream }

{ constructor Create }
procedure TMemoryStream_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TMemoryStream.Create);
end;

{ procedure Clear }
procedure TMemoryStream_Clear(var Value: Variant; Args: TArguments);
begin
  TMemoryStream(Args.Obj).Clear;
end;

{  procedure LoadFromFile(const FileName: string); }
procedure TMemoryStream_LoadFromFile(var Value: Variant; Args: TArguments);
begin
  TMemoryStream(Args.Obj).LoadFromFile(Args.Values[0]);
end;

{  procedure SaveToFile(const FileName: string); }
procedure TMemoryStream_SaveToFile(var Value: Variant; Args: TArguments);
begin
  TMemoryStream(Args.Obj).SaveToFile(Args.Values[0]);
end;

  { TStringStream }

{ constructor Create(AString: string) }
procedure TStringStream_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TStringStream.Create(Args.Values[0]));
end;

{  function Read(var Buffer; Count: Longint): Longint; }
procedure TStringStream_Read(var Value: Variant; Args: TArguments);
begin
  Value := TStringStream(Args.Obj).Read(Args.Values[0], Args.Values[1]);
end;

{  function ReadString(Count: Longint): string; }
procedure TStringStream_ReadString(var Value: Variant; Args: TArguments);
begin
  Value := TStringStream(Args.Obj).ReadString(Args.Values[0]);
end;

{  function Seek(Offset: Longint; Origin: Word): Longint; }
procedure TStringStream_Seek(var Value: Variant; Args: TArguments);
begin
  Value := TStringStream(Args.Obj).Seek(Args.Values[0], Args.Values[1]);
end;

{  function Write(const Buffer; Count: Longint): Longint; }
procedure TStringStream_Write(var Value: Variant; Args: TArguments);
begin
  Value := TStringStream(Args.Obj).Write(Args.Values[0], Args.Values[1]);
end;

{  procedure WriteString(const AString: string); }
procedure TStringStream_WriteString(var Value: Variant; Args: TArguments);
begin
  TStringStream(Args.Obj).WriteString(Args.Values[0]);
end;

{ property Read DataString: string }
procedure TStringStream_Read_DataString(var Value: Variant; Args: TArguments);
begin
  Value := TStringStream(Args.Obj).DataString;
end;

  { TComponent }

{ constructor Create(AOwner: TComponent) }
procedure TComponent_Create(var Value: Variant; Args: TArguments);
begin
//  Value := O2V(TComponent.Create(TComponent(V2O(Args.Values[0]))));
  Value:=O2V(TComponentClass(Args.Obj).Create(TComponent(V2O(Args.Values[0]))));
end;

{  procedure DestroyComponents; }
procedure TComponent_DestroyComponents(var Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).DestroyComponents;
end;

{  procedure Destroying; }
procedure TComponent_Destroying(var Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).Destroying;
end;

{  function FindComponent(const AName: string): TComponent; }
procedure TComponent_FindComponent(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TComponent(Args.Obj).FindComponent(Args.Values[0]));
end;

{  procedure FreeNotification(AComponent: TComponent); }
procedure TComponent_FreeNotification(var Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).FreeNotification(V2O(Args.Values[0]) as TComponent);
end;

{  procedure FreeOnRelease; }
procedure TComponent_FreeOnRelease(var Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).FreeOnRelease;
end;

{  function GetParentComponent: TComponent; }
procedure TComponent_GetParentComponent(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TComponent(Args.Obj).GetParentComponent);
end;

{  function HasParent: Boolean; }
procedure TComponent_HasParent(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).HasParent;
end;

{  procedure InsertComponent(AComponent: TComponent); }
procedure TComponent_InsertComponent(var Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).InsertComponent(V2O(Args.Values[0]) as TComponent);
end;

{  procedure RemoveComponent(AComponent: TComponent); }
procedure TComponent_RemoveComponent(var Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).RemoveComponent(V2O(Args.Values[0]) as TComponent);
end;

{  function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): Integer; }
procedure TComponent_SafeCallException(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).SafeCallException(V2O(Args.Values[0]), V2P(Args.Values[1]));
end;

{ property Read Components[Integer]: TComponent }
procedure TComponent_Read_Components(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TComponent(Args.Obj).Components[Args.Values[0]]);
end;

{ property Read ComponentCount: Integer }
procedure TComponent_Read_ComponentCount(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).ComponentCount;
end;

{ property Read ComponentIndex: Integer }
procedure TComponent_Read_ComponentIndex(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).ComponentIndex;
end;

{ property Write ComponentIndex(Value: Integer) }
procedure TComponent_Write_ComponentIndex(const Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).ComponentIndex := Value;
end;

{ property Read DesignInfo: Longint }
procedure TComponent_Read_DesignInfo(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).DesignInfo;
end;

{ property Write DesignInfo(Value: Longint) }
procedure TComponent_Write_DesignInfo(const Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).DesignInfo := Value;
end;

{ property Read Owner: TComponent }
procedure TComponent_Read_Owner(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TComponent(Args.Obj).Owner);
end;

{ property Read VCLComObject: Pointer }
procedure TComponent_Read_VCLComObject(var Value: Variant; Args: TArguments);
begin
  Value := P2V(TComponent(Args.Obj).VCLComObject);
end;

{ property Write VCLComObject(Value: Pointer) }
procedure TComponent_Write_VCLComObject(const Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).VCLComObject := V2P(Value);
end;

{ property Read Name: TComponentName }
procedure TComponent_Read_Name(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).Name;
end;

{ property Write Name(Value: TComponentName) }
procedure TComponent_Write_Name(const Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).Name := Value;
end;

{ property Read Tag: Longint }
procedure TComponent_Read_Tag(var Value: Variant; Args: TArguments);
begin
  Value := TComponent(Args.Obj).Tag;
end;

{ property Write Tag(Value: Longint) }
procedure TComponent_Write_Tag(const Value: Variant; Args: TArguments);
begin
  TComponent(Args.Obj).Tag := Value;
end;






end.
