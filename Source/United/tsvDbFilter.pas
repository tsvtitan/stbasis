unit tsvDbFilter;

interface

uses Classes, SysUtils, UMainUnited;

type

  TtsvDbFilterItem=class(TCollectionItem)
  private
    FFieldName: string;
    FValue: Variant;
    FEnabled: Boolean;
    FTypeCondition: TTypeDbCondition;
    FCheckCase: Boolean;
    FCaption: String;
    FValue2: Variant;
    FEnabled2: Boolean;
    FTypeCondition2: TTypeDbCondition;
    FCheckCase2: Boolean;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
  published
    property FieldName: String read FFieldName write FFieldName;
    property Value: Variant read FValue write FValue;
    property Enabled: Boolean read FEnabled write FEnabled;
    property TypeCondition: TTypeDbCondition read FTypeCondition write FTypeCondition;
    property CheckCase: Boolean read FCheckCase write FCheckCase;
    property Caption: String read FCaption write FCaption;
    property Value2: Variant read FValue2 write FValue2;
    property Enabled2: Boolean read FEnabled2 write FEnabled2;
    property TypeCondition2: TTypeDbCondition read FTypeCondition2 write FTypeCondition2;
    property CheckCase2: Boolean read FCheckCase2 write FCheckCase2;
  end;

  TtsvDbFilterItemClass=class of TtsvDbFilterItem;

  TtsvDbFilters=class(TCollection)
  private
    FOwner: TPersistent;
    FTypeFilter: TTypeDbFilter;
    FFilterInside: Boolean;
    FFilterLeftSide: Boolean;
    function GetFilterItem(Index: Integer): TtsvDbFilterItem;
    procedure SetFilterItem(Index: Integer; Value: TtsvDbFilterItem);
    function GetEnabled: Boolean;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent);
    procedure Assign(Source: TPersistent); override;
    function Add: TtsvDbFilterItem; overload;
    function Add(const FieldName: string;
                 const TypeCondition: TTypeDbCondition=tdbcEqual;
                 const CheckCase: Boolean=true;
                 const Enabled: Boolean=false): TtsvDbFilterItem; overload;
    function GetFilterString: string;
    procedure LoadFromFile(const Filename: string);
    procedure LoadFromStream(S: TStream);
    procedure SaveToFile(const Filename: string);
    procedure SaveToStream(S: TStream);
    property Items[Index: Integer]: TtsvDbFilterItem read GetFilterItem write SetFilterItem;
    property Enabled: Boolean read GetEnabled;
    property TypeFilter: TTypeDbFilter read FTypeFilter write FTypeFilter;
    property FilterInside: Boolean read FFilterInside write FFilterInside;
    property FilterLeftSide: Boolean read FFilterLeftSide write FFilterLeftSide;
  end;

implementation

{ TtsvDbFilterItem }

constructor TtsvDbFilterItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FEnabled:=true;
  FCheckCase:=true;
end;

destructor TtsvDbFilterItem.Destroy;
begin
  inherited Destroy;
end;

procedure TtsvDbFilterItem.Assign(Source: TPersistent);
begin
  if Source is TtsvDbFilterItem then
  begin
    FieldName:=TtsvDbFilterItem(Source).FieldName;
    Value:=TtsvDbFilterItem(Source).Value;
    Enabled:=TtsvDbFilterItem(Source).Enabled;
    TypeCondition:=TtsvDbFilterItem(Source).TypeCondition;
    CheckCase:=TtsvDbFilterItem(Source).CheckCase;
    Caption:=TtsvDbFilterItem(Source).Caption;
    Value2:=TtsvDbFilterItem(Source).Value2;
    Enabled2:=TtsvDbFilterItem(Source).Enabled2;
    TypeCondition2:=TtsvDbFilterItem(Source).TypeCondition2;
    CheckCase2:=TtsvDbFilterItem(Source).CheckCase2;
  end
  else inherited Assign(Source);
end;

{ TtsvDbFilters }

constructor TtsvDbFilters.Create(Owner: TPersistent);
begin
  inherited Create(TtsvDbFilterItem);
  FOwner:=Owner;
  FTypeFilter:=tdbfAnd;
  FFilterInside:=false;
  FFilterLeftSide:=true;
end;

function TtsvDbFilters.GetFilterItem(Index: Integer): TtsvDbFilterItem;
begin
  Result := TtsvDbFilterItem(inherited GetItem(Index));
end;

procedure TtsvDbFilters.SetFilterItem(Index: Integer; Value: TtsvDbFilterItem);
begin
  inherited SetItem(Index, Value);
end;

function TtsvDbFilters.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TtsvDbFilters.Update(Item: TCollectionItem);
begin
  inherited;
end;

function TtsvDbFilters.Add: TtsvDbFilterItem;
begin
  Result := TtsvDbFilterItem(inherited Add);
end;

function TtsvDbFilters.Add(const FieldName: string;
                           const TypeCondition: TTypeDbCondition=tdbcEqual;
                           const CheckCase: Boolean=true;
                           const Enabled: Boolean=false): TtsvDbFilterItem;
begin
  Result:=Add;
  Result.FieldName:=FieldName;
  Result.CheckCase:=CheckCase;
  Result.Enabled:=Enabled;
  Result.TypeCondition:=TypeCondition;
end;

function TtsvDbFilters.GetFilterString: string;

  function PrepearValue(Condition: TTypeDbCondition; Value: Variant; CheckCase: Boolean): String;
  begin
    Result:='';
    if Condition in [tdbcIsNull,tdbcIsNotNull] then exit;

    case VarType(Value) of
      varEmpty: Result:='';
      varNull: Result:='';
      varBoolean,varByte,varSmallint,varInteger: Result:=InttoStr(Value);
      varSingle,varDouble,varCurrency: Result:=ChangeChar(FloatToStr(Value),',','.');
      varOleStr,varStrArg,varString: begin
        if Condition=tdbcLike then begin
          Result:=iff(not CheckCase,
                      AnsiUpperCase(QuotedStr(iff(FFilterInside,'%','')+Value+iff(FFilterLeftSide,'%',''))),
                      QuotedStr(iff(FFilterInside,'%','')+Value+iff(FFilterLeftSide,'%','')));
        end else begin
          Result:=iff(not CheckCase,AnsiUpperCase(QuotedStr(Value)),QuotedStr(Value));
        end;
      end;
    end;
  end;

var
  i: Integer;
  incr: Integer;
  Item: TtsvDbFilterItem; 
begin
  Result:='';
  incr:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled or Item.Enabled2 then
      if incr=0 then begin
        Result:=iff(Item.Enabled,
                    iff(not Item.CheckCase,'Upper('+Item.FieldName+')',Item.FieldName)+
                    TranslateCondition(Item.TypeCondition)+PrepearValue(Item.TypeCondition,Item.Value,Item.CheckCase)+' ','')+
                iff(Item.Enabled2,
                    iff(Item.Enabled,TranslateFilter(tdbfAnd)+' ','')+
                    iff(not Item.CheckCase2,'Upper('+Item.FieldName+')',Item.FieldName)+
                    TranslateCondition(Item.TypeCondition2)+PrepearValue(Item.TypeCondition2,Item.Value2,Item.CheckCase2),
                    '');
        inc(incr);
      end else begin
        Result:=Result+' '+
                TranslateFilter(FTypeFilter)+' '+
                iff(Item.Enabled,
                    iff(not Item.CheckCase,'Upper('+Item.FieldName+')',Item.FieldName)+
                    TranslateCondition(Item.TypeCondition)+PrepearValue(Item.TypeCondition,Item.Value,Item.CheckCase)+' ','')+
                iff(Item.Enabled2,
                    iff(Item.Enabled,TranslateFilter(tdbfAnd)+' ','')+
                    iff(not Item.CheckCase2,'Upper('+Item.FieldName+')',Item.FieldName)+
                    TranslateCondition(Item.TypeCondition2)+PrepearValue(Item.TypeCondition2,Item.Value2,Item.CheckCase2),
                    '');

      end;
  end;
end;

type
  TtsvDbFiltersComponent=class(TComponent)
  private
    FDbFilters: TtsvDbFilters;
    FTypeFilter: TTypeDbFilter;
    FFilterInside: Boolean;
    FFilterLeftSide: Boolean;
    procedure SetDbFilters(Value: TtsvDbFilters);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
  published
    property DbFilters: TtsvDbFilters read FDbFilters write SetDbFilters;
    property TypeFilter: TTypeDbFilter read FTypeFilter write FTypeFilter;
    property FilterInside: Boolean read FFilterInside write FFilterInside;
    property FilterLeftSide: Boolean read FFilterLeftSide write FFilterLeftSide;
  end;

constructor TtsvDbFiltersComponent.Create(AOwner: TComponent);
begin
  inHerited Create(AOwner);
  FDbFilters:=TtsvDbFilters.Create(Self);
  FTypeFilter:=tdbfAnd;
  FFilterInside:=false;
  FFilterLeftSide:=true;
end;

destructor TtsvDbFiltersComponent.Destroy;
begin
  FDbFilters.Free;
  inherited;
end;

procedure TtsvDbFiltersComponent.SetDbFilters(Value: TtsvDbFilters);
begin
  FDbFilters.Assign(Value);
  FTypeFilter:=Value.TypeFilter;
  FFilterInside:=Value.FilterInside;
  FFilterLeftSide:=Value.FilterLeftSide;
end;

procedure TtsvDbFilters.Assign(Source: TPersistent);
begin
  if Source is TtsvDbFiltersComponent then begin
    Assign(TtsvDbFiltersComponent(Source).DbFilters);
    TypeFilter:=TtsvDbFiltersComponent(Source).TypeFilter;
    FilterInside:=TtsvDbFiltersComponent(Source).FilterInside;
    FilterLeftSide:=TtsvDbFiltersComponent(Source).FilterLeftSide;
  end else
    inherited Assign(Source);
end;

procedure TtsvDbFilters.LoadFromFile(const Filename: string);
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

procedure TtsvDbFilters.LoadFromStream(S: TStream);
var
  Wrapper: TtsvDbFiltersComponent;
begin
  Wrapper := TtsvDbFiltersComponent.Create(nil);
  try
    S.ReadComponent(Wrapper);
    Assign(Wrapper);
  finally
    Wrapper.Free;
  end;
end;

procedure TtsvDbFilters.SaveToFile(const Filename: string);
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

procedure TtsvDbFilters.SaveToStream(S: TStream);
var
  Wrapper: TtsvDbFiltersComponent;
begin
  Wrapper := TtsvDbFiltersComponent.Create(nil);
  try
    Wrapper.DbFilters := Self;
    S.WriteComponent(Wrapper);
  finally
    Wrapper.Free;
  end;
end;

function TtsvDbFilters.GetEnabled: Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    if Items[i].Enabled then begin
      Result:=true;
      break;
    end;
  end;
end;


end.
