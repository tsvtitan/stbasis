{-------------------------------------------------------------------------------}
{ AnyDAC QA variant array manager implementation                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAVarField;

interface

uses
  Classes, DB
{$IFDEF AnyDAC_D6}
  , Variants
{$ENDIF}
  ;

type
  TADQAVariantField = class (TObject)
  private
    FFieldType: TFieldType;
    FSize: Integer;
    FName: string;
    FValue: Variant;
  public
    constructor Create;
    property FieldType: TFieldType read FFieldType write FFieldType;
    property Size: Integer read FSize write FSize;
    property Name: string read FName write FName;
    property Value: Variant read FValue write FValue;
  end;

  TADQAVariantFieldList = class (TObject)
  private
    FVariantFields: TList;
    function GetAssignedCount: Integer;
    function GetCount: Integer;
    function GetNames(AIndex: Integer): string;
    function GetTypes(AIndex: Integer): TFieldType;
    function GetVariantField(AIndex: Integer): TADQAVariantField;
    function GetVarValues(AIndex: Integer): Variant;
    procedure SetNames(AIndex: Integer; const AValue: string);
    procedure SetTypes(AIndex: Integer; AValue: TFieldType);
    procedure SetVarValues(AIndex: Integer; AValue: Variant);
    function GetSizes(AIndex: Integer): Integer;
    procedure SetSizes(AIndex: Integer; const AValue: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AName: String; AValue: Variant; AType: TFieldType; ASize: Integer = -1);
    procedure Clear;
    procedure CreateEmptyList(ACount: Integer);
    procedure SetField(AValue: Variant; AType: TFieldType; AIndex: Integer);
    function IsOfUnknownType(AIndex: Integer): Boolean;
    property AssignedCount: Integer read GetAssignedCount;
    property Count: Integer read GetCount;
    property Names[Index: Integer]: string read GetNames write SetNames;
    property Types[Index: Integer]: TFieldType read GetTypes write SetTypes;
    property Sizes[Index: Integer]: Integer read GetSizes write SetSizes;
    property VariantFields[Index: Integer]: TADQAVariantField read GetVariantField;
    property VarValues[Index: Integer]: Variant read GetVarValues write SetVarValues;
  end;

implementation

{-------------------------------------------------------------------------------}
{ TADQAVariantField                                                             }
{-------------------------------------------------------------------------------}
constructor TADQAVariantField.Create;
begin
  FValue     := Unassigned;
  FFieldType := ftUnknown;
  FName      := '';
end;

{-------------------------------------------------------------------------------}
{ TADQAVariantFieldList                                                        }
{-------------------------------------------------------------------------------}
constructor TADQAVariantFieldList.Create;
begin
  FVariantFields := TList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADQAVariantFieldList.Destroy;
begin
  Clear;
  FVariantFields.Free;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.Add(AName: String; AValue: Variant;
  AType: TFieldType; ASize: Integer = -1);
var
  oVarField: TADQAVariantField;
begin
  oVarField := TADQAVariantField.Create;
  with oVarField do begin
    Name := AName;
    Value := AValue;
    FieldType  := AType;
    if ASize <> -1 then
      Size := ASize;
  end;
  FVariantFields.Add(oVarField);
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetAssignedCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FVariantFields.Count - 1 do
    if not IsOfUnknownType(i) then
      Inc(Result);
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetCount: Integer;
begin
  Result := FVariantFields.Count;
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetNames(AIndex: Integer): string;
begin
  ASSERT(AIndex < FVariantFields.Count);
  Result := TADQAVariantField(FVariantFields[AIndex]).Name;
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetTypes(AIndex: Integer): TFieldType;
begin
  ASSERT(AIndex < FVariantFields.Count);
  Result := TADQAVariantField(FVariantFields[AIndex]).FieldType;
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.SetNames(AIndex: Integer; const AValue: string);
begin
  ASSERT(AIndex < FVariantFields.Count);
  TADQAVariantField(FVariantFields[AIndex]).Name := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.SetTypes(AIndex: Integer; AValue: TFieldType);
begin
  ASSERT(AIndex < FVariantFields.Count);
  TADQAVariantField(FVariantFields[AIndex]).FieldType := AValue;
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetSizes(AIndex: Integer): Integer;
begin
  ASSERT(AIndex < FVariantFields.Count);
  Result := TADQAVariantField(FVariantFields[AIndex]).Size;
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.SetSizes(AIndex: Integer;
  const AValue: Integer);
begin
  ASSERT(AIndex < FVariantFields.Count);
  TADQAVariantField(FVariantFields[AIndex]).Size := AValue;
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetVarValues(AIndex: Integer): Variant;
begin
  ASSERT(AIndex < FVariantFields.Count);
  Result := TADQAVariantField(FVariantFields[AIndex]).Value;
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.SetVarValues(AIndex: Integer; AValue: Variant);
begin
  ASSERT(AIndex < FVariantFields.Count);
  TADQAVariantField(FVariantFields[AIndex]).Value := AValue;
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.GetVariantField(AIndex: Integer):
        TADQAVariantField;
begin
  ASSERT(AIndex < FVariantFields.Count);
  Result := TADQAVariantField(FVariantFields[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.Clear;
var
  i: Integer;
begin
  if FVariantFields.Count = 0 then
    Exit;
  for i := 0 to FVariantFields.Count - 1 do
    TADQAVariantField(FVariantFields[i]).Free;
  FVariantFields.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.CreateEmptyList(ACount: Integer);
var
  i: Integer;
begin
  Clear;
  for i := 0 to ACount - 1 do
    FVariantFields.Add(TADQAVariantField.Create);
end;

{-------------------------------------------------------------------------------}
procedure TADQAVariantFieldList.SetField(AValue: Variant;
  AType: TFieldType; AIndex: Integer);
begin
  ASSERT(AIndex < FVariantFields.Count);
  VarValues[AIndex]  := AValue;
  Types[AIndex] := AType;
end;

{-------------------------------------------------------------------------------}
function TADQAVariantFieldList.IsOfUnknownType(AIndex: Integer): Boolean;
begin
  ASSERT(AIndex < FVariantFields.Count);
  Result := TADQAVariantField(FVariantFields[AIndex]).FieldType = ftUnknown;
end;

end.
