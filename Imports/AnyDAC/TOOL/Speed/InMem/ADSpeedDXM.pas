{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - DevEx memory dataset unit                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedDXM;

interface

uses
  DB,
  ADSpeedBase, ADSpeedBaseInMem,
  dxmdaset;

type
  TADSpeedDxMemData = class(TADSpeedCustomInMemDataSet)
  private
    function GetMemData: TdxMemData;
  public
    constructor Create; override;
    procedure AddField(const AName: String; AType: TFieldType; ASize: Integer = 0); override;
    procedure AddIndex(const AName, AFieldNames: String); override;
    procedure DeleteDataSet; override;
    procedure SetIndex(const AName: String; AIndex: Integer); override;
    function GetIndexCount: Integer; override;
    class function GetName: String; override;
    class function GetDescription: String; override;
    property MemData: TdxMemData read GetMemData;
  end;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedDxMemData                                                         }
{---------------------------------------------------------------------------}
constructor TADSpeedDxMemData.Create;
begin
  inherited Create;
  DataSet := TdxMemData.Create(nil);
end;

{---------------------------------------------------------------------------}
function TADSpeedDxMemData.GetMemData: TdxMemData;
begin
  Result := TdxMemData(DataSet);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDxMemData.AddField(const AName: String; AType: TFieldType; ASize: Integer);
begin
  with DefaultFieldClasses[AType].Create(DataSet) do begin
    FieldName := AName;
    if Size <> 0 then
      Size := ASize;
    DataSet := Self.DataSet;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDxMemData.AddIndex(const AName, AFieldNames: String);
begin
  MemData.Indexes.Add.FieldName := AFieldNames;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDxMemData.DeleteDataSet;
begin
  MemData.Indexes.Clear;
  inherited DeleteDataSet;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDxMemData.SetIndex(const AName: String; AIndex: Integer);
begin
  // ??? nothing
end;

{---------------------------------------------------------------------------}
function TADSpeedDxMemData.GetIndexCount: Integer;
begin
  Result := MemData.Indexes.Count;
end;

{---------------------------------------------------------------------------}
class function TADSpeedDxMemData.GetName: String;
begin
  Result := 'TdxMemData';
end;

{---------------------------------------------------------------------------}
class function TADSpeedDxMemData.GetDescription: String;
begin
  Result := 'DevEx TdxMemData';
end;

end.
