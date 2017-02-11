{-------------------------------------------------------------------------------}
{ AnyDAC Data Adapter Column mapping                                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADDAptColumn;

interface

uses
  Classes,
  daADDatSManager,
  daADPhysIntf;

type
  TADDAptColumnMapping = class(TCollectionItem)
  private
    FDatSColumnName: String;
    FSourceColumnID: Integer;
    FSourceColumnName: String;
    FUpdateColumnName: String;
    procedure SetSourceColumnName(const AValue: String);
    procedure SetSourceColumnID(const AValue: Integer);
    function GetUpdateColumnName: String;
    function GetDatSColumnName: String;
    function GetDatSColumn: TADDatSColumn;
    function MatchRecordSetColumn(AColumn: Pointer;
      AColNameKind: TADPhysNameKind): Boolean;
  protected
    function GetDisplayName: String; override;
  public
    constructor Create(ACollection: TCollection); override;
    property DatSColumn: TADDatSColumn read GetDatSColumn;
  published
    property SourceColumnName: String read FSourceColumnName write SetSourceColumnName;
    property SourceColumnID: Integer read FSourceColumnID write SetSourceColumnID default -1;
    property UpdateColumnName: String read GetUpdateColumnName write FUpdateColumnName;
    property DatSColumnName: String read GetDatSColumnName write FDatSColumnName;
  end;

  TADDAptColumnMappings = class(TCollection)
  private
    FDatSTable: TADDatSTable;
    FOwner: TPersistent;
    function Find(AColumn: Pointer;
      ANameKind: TADPhysNameKind): Integer;
    function GetItems(AIndex: Integer): TADDAptColumnMapping;
    procedure SetItems(AIndex: Integer; const Value: TADDAptColumnMapping);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent); overload;
    destructor Destroy; override;
    procedure SetOwner(AOwner: TPersistent);
    function Lookup(AColumn: Pointer; ANameKind: TADPhysNameKind): TADDAptColumnMapping;
    function Add(const ASourceColumnName: String = '';
      const ADatSColumnName: String = '';
      const AUpdateColumnName: String = ''): TADDAptColumnMapping;
    procedure Remove(AColumn: Pointer; ANameKind: TADPhysNameKind);
    property Items[AIndex: Integer]: TADDAptColumnMapping read GetItems write SetItems; default;
    property DatSTable: TADDatSTable read FDatSTable write FDatSTable;
  end;

procedure ADGetRecordSetColumnInfo(AColMap: TADDAptColumnMapping;
  var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
  var ADatSColumn: TADDatSColumn);

implementation

uses
  SysUtils,
  daADStanUtil;

{-------------------------------------------------------------------------------}
{ TADDAptColumnMapping                                                          }
{-------------------------------------------------------------------------------}
constructor TADDAptColumnMapping.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FSourceColumnID := -1;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMapping.GetDisplayName: String;
begin
  if SourceColumnName <> '' then
    Result := SourceColumnName
  else if SourceColumnID <> -1 then
    Result := Format('[%d]', [SourceColumnID]);
  if (Result <> '') and (DatSColumnName <> '') then
    Result := Result + ' -> ' + DatSColumnName;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMapping.GetDatSColumn: TADDatSColumn;
var
  i: Integer;
  oCols: TADDatSColumnList;
begin
  if (GetDatSColumnName <> '') and (TADDAptColumnMappings(Collection).DatSTable <> nil) then begin
    oCols := TADDAptColumnMappings(Collection).DatSTable.Columns;
    i := oCols.IndexOfName(GetDatSColumnName);
    if i <> -1 then
      Result := oCols.ItemsI[i]
    else
      Result := nil;
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMapping.GetDatSColumnName: String;
begin
  Result := FDatSColumnName;
  if Result = '' then
    Result := FSourceColumnName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptColumnMapping.SetSourceColumnID(const AValue: Integer);
begin
  FSourceColumnID := AValue;
  if AValue >= 0 then
    FSourceColumnName := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDAptColumnMapping.SetSourceColumnName(const AValue: String);
begin
  FSourceColumnName := AValue;
  if AValue <> '' then
    FSourceColumnID := -1;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMapping.GetUpdateColumnName: String;
begin
  Result := FUpdateColumnName;
  if Result = '' then
    Result := FSourceColumnName;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMapping.MatchRecordSetColumn(AColumn: Pointer;
  AColNameKind: TADPhysNameKind): Boolean;
var
  oCol: TADDatSColumn;
begin
  case AColNameKind of
  nkID:
    Result := SourceColumnID = Integer(AColumn);
  nkSource:
    Result := {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
      (String(AColumn), SourceColumnName) = 0;
  nkDatS:
    Result := {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
      (String(AColumn), DatSColumnName) = 0;
  nkObj:
    begin
      oCol := TADDatSColumn(AColumn);
      Result :=
        (DatSColumn <> nil) and (DatSColumn = oCol) or
        (SourceColumnID <> -1) and (SourceColumnID = oCol.SourceID) or
        (SourceColumnName <> '') and (
          {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
          (SourceColumnName, oCol.SourceName) = 0) or
        (DatSColumnName <> '') and (
          {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
          (DatSColumnName, oCol.Name) = 0);
    end;
  else
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADGetRecordSetColumnInfo(AColMap: TADDAptColumnMapping;
  var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
  var ADatSColumn: TADDatSColumn);
begin
  if AColMap.SourceColumnID <> -1 then
    ASourceID := AColMap.SourceColumnID;
  if AColMap.SourceColumnName <> '' then
    ASourceName := AColMap.SourceColumnName;
  if AColMap.DatSColumnName <> '' then
    ADatSName := AColMap.DatSColumnName;
  if AColMap.UpdateColumnName <> '' then
    AUpdateName := AColMap.UpdateColumnName;
  if AColMap.DatSColumn <> nil then
    ADatSColumn := AColMap.DatSColumn;
end;

{-------------------------------------------------------------------------------}
{ TADDAptColumnMappings                                                         }
{-------------------------------------------------------------------------------}
constructor TADDAptColumnMappings.Create(AOwner: TPersistent);
begin
  inherited Create(TADDAptColumnMapping);
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptColumnMappings.Destroy;
begin
  FOwner := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptColumnMappings.SetOwner(AOwner: TPersistent);
begin
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMappings.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMappings.GetItems(AIndex: Integer): TADDAptColumnMapping;
begin
  Result := inherited Items[AIndex] as TADDAptColumnMapping;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptColumnMappings.SetItems(AIndex: Integer; const Value: TADDAptColumnMapping);
begin
  inherited Items[AIndex] := Value;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMappings.Add(const ASourceColumnName: String = '';
  const ADatSColumnName: String = ''; const AUpdateColumnName: String = ''): TADDAptColumnMapping;
begin
  Result := inherited Add as TADDAptColumnMapping;
  with Result do begin
    SourceColumnName := ASourceColumnName;
    DatSColumnName := ADatSColumnName;
    UpdateColumnName := AUpdateColumnName;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMappings.Find(AColumn: Pointer;
  ANameKind: TADPhysNameKind): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if Items[i].MatchRecordSetColumn(AColumn, ANameKind) then begin
      Result := i;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDAptColumnMappings.Lookup(AColumn: Pointer;
  ANameKind: TADPhysNameKind): TADDAptColumnMapping;
var
  i: Integer;
begin
  i := Find(AColumn, ANameKind);
  if i <> -1 then
    Result := Items[i]
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptColumnMappings.Remove(AColumn: Pointer;
  ANameKind: TADPhysNameKind);
var
  i: Integer;
begin
  i := Find(AColumn, ANameKind);
  if i <> -1 then
    Delete(i);
end;

end.
