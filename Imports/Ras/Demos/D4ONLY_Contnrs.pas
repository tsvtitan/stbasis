unit Contnrs;

interface

uses
  Classes;

type
  TObjectList = class(TList)
  private
    FOwnObjects: Boolean;
    function GetItems(Index: Integer): TObject;
    procedure SetItems(Index: Integer; const Value: TObject);
  public
    procedure Clear; override;
    constructor Create(AOwnObjects: Boolean = False);
    property Items[Index: Integer]: TObject read GetItems write SetItems; default;
    property OwnObjects: Boolean read FOwnObjects;
  end;

implementation

{ TObjectList }

procedure TObjectList.Clear;
var
  I: Integer;
begin
  if FOwnObjects then
    for I := 0 to Count - 1 do Items[I].Free;
  inherited;
end;

constructor TObjectList.Create(AOwnObjects: Boolean);
begin
  inherited Create;
  FOwnObjects := AOwnObjects;
end;

function TObjectList.GetItems(Index: Integer): TObject;
begin
  Result := TObject(Get(Index));
end;

procedure TObjectList.SetItems(Index: Integer; const Value: TObject);
begin
  Put(Index, Value);
end;

end.
