unit tsvDbOrder;

interface

uses Classes, SysUtils, UMainUnited;

type

  TtsvDbOrderItem=class(TCollectionItem)
  private
    FCaption: string;
    FFieldName: string;
    FEnabled: Boolean;
    FTypeOrder: TTypeDbOrder;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: String read FCaption write FCaption;
    property FieldName: String read FFieldName write FFieldName;
    property Enabled: Boolean read FEnabled write FEnabled;
    property TypeOrder: TTypeDbOrder read FTypeOrder write FTypeOrder;
  end;

  TtsvDbOrderItemClass=class of TtsvDbOrderItem;

  TtsvDbOrders=class(TCollection)
  private
    FOwner: TPersistent;
    function GetOrderItem(Index: Integer): TtsvDbOrderItem;
    procedure SetOrderItem(Index: Integer; Value: TtsvDbOrderItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent);
    function Add: TtsvDbOrderItem; overload;
    function Add(const Caption, FieldName: string; const Enabled: Boolean=true;
                 const TypeOrder: TTypeDbOrder=tdboNone): TtsvDbOrderItem; overload;
    function GetOrderString: string;
    procedure LoadFromFile(const Filename: string);
    procedure LoadFromStream(S: TStream);
    procedure SaveToFile(const Filename: string);
    procedure SaveToStream(S: TStream);
    property Items[Index: Integer]: TtsvDbOrderItem read GetOrderItem write SetOrderItem;
  end;

implementation

{ TtsvDbOrderItem }

constructor TtsvDbOrderItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled:=true;
  FTypeOrder:=tdboNone;
end;

destructor TtsvDbOrderItem.Destroy;
begin
  inherited Destroy;
end;

procedure TtsvDbOrderItem.Assign(Source: TPersistent);
begin
  if Source is TtsvDbOrderItem then
  begin
    FCaption:=TtsvDbOrderItem(Source).Caption;
    FFieldName:=TtsvDbOrderItem(Source).FieldName;
    FEnabled:=TtsvDbOrderItem(Source).Enabled;
    FTypeOrder:=TtsvDbOrderItem(Source).TypeOrder;
  end
  else inherited Assign(Source);
end;

{ TtsvDbOrders }

constructor TtsvDbOrders.Create(Owner: TPersistent);
begin
  inherited Create(TtsvDbOrderItem);
  FOwner:=Owner;
end;

function TtsvDbOrders.GetOrderItem(Index: Integer): TtsvDbOrderItem;
begin
  Result := TtsvDbOrderItem(inherited GetItem(Index));
end;

procedure TtsvDbOrders.SetOrderItem(Index: Integer; Value: TtsvDbOrderItem);
begin
  inherited SetItem(Index, Value);
end;

function TtsvDbOrders.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TtsvDbOrders.Update(Item: TCollectionItem);
begin
  inherited;
end;

function TtsvDbOrders.Add: TtsvDbOrderItem;
begin
  Result := TtsvDbOrderItem(inherited Add);
end;

function TtsvDbOrders.Add(const Caption, FieldName: string; const Enabled: Boolean=true;
                          const TypeOrder: TTypeDbOrder=tdboNone): TtsvDbOrderItem;
begin
  Result:=Add;
  Result.Caption:=Caption;
  Result.FieldName:=FieldName;
  Result.Enabled:=Enabled;
  Result.TypeOrder:=TypeOrder;
end;

function TtsvDbOrders.GetOrderString: string;
var
  i: Integer;
  incr: Integer;
begin
  Result:='';
  incr:=0;
  for i:=0 to Count-1 do begin
    if Items[i].Enabled then begin
      if incr=0 then Result:=Items[i].FieldName+' '+TranslateOrder(Items[i].TypeOrder)
      else Result:=Result+','+Items[i].FieldName+' '+TranslateOrder(Items[i].TypeOrder);
      inc(incr);
    end;  
  end;  
end;

type
  TtsvDbOrdersComponent=class(TComponent)
  private
    FDbOrders: TtsvDbOrders;
    procedure SetDbOrders(Value: TtsvDbOrders);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
  published
    property DbOrders: TtsvDbOrders read FDbOrders write SetDbOrders;
  end;

constructor TtsvDbOrdersComponent.Create(AOwner: TComponent);
begin
  inHerited Create(AOwner);
  FDbOrders:=TtsvDbOrders.Create(Self);
end;

destructor TtsvDbOrdersComponent.Destroy;
begin
  FDbOrders.Free;
  inherited;
end;

procedure TtsvDbOrdersComponent.SetDbOrders(Value: TtsvDbOrders);
begin
  FDbOrders.Assign(Value);
end;

procedure TtsvDbOrders.LoadFromFile(const Filename: string);
var
  S: TFileStream;
begin
  S := TFileStream.Create(Filename, fmOpenRead);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TtsvDbOrders.LoadFromStream(S: TStream);
var
  Wrapper: TtsvDbOrdersComponent;
begin
  Wrapper := TtsvDbOrdersComponent.Create(nil);
  try
    S.ReadComponent(Wrapper);
    Assign(Wrapper.DbOrders);
  finally
    Wrapper.Free;
  end;
end;

procedure TtsvDbOrders.SaveToFile(const Filename: string);
var
  S: TStream;
begin
  S := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TtsvDbOrders.SaveToStream(S: TStream);
var
  Wrapper: TtsvDbOrdersComponent;
begin
  Wrapper := TtsvDbOrdersComponent.Create(nil);
  try
    Wrapper.DbOrders := Self;
    S.WriteComponent(Wrapper);
  finally
    Wrapper.Free;
  end;
end;


end.
