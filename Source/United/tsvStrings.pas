unit tsvStrings;

interface

uses Classes;

type

  TtsvStringList=class(TComponent)
  private
    FStrings: TStrings;
    procedure SetStrings(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Strings: TStrings read FStrings write SetStrings;
  end;


implementation

{ TtsvStringList }

constructor TtsvStringList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStrings:=TStringList.Create;
end;

destructor TtsvStringList.Destroy;
begin
  FStrings.Free;
  inherited Destroy;
end;

procedure TtsvStringList.SetStrings(Value: TStrings);
begin
  FStrings.Assign(Value);
end;

end.
