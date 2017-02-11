{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - kbmMemTable unit                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedKBM;

interface

uses
  ADSpeedBase,
  ADSpeedBaseInMem,
  kbmMemTable;

type
  TADSpeedKbmMemTable = class(TADSpeedCustomInMemDataSet)
  private
    function GetMemTable: TkbmMemTable;
  public
    constructor Create; override;
    procedure DeleteDataSet; override;
    procedure CreateDataSet; override;
    procedure AddIndex(const AName, AFieldNames: String); override;
    procedure SetIndex(const AName: String; AIndex: Integer); override;
    function GetIndexCount: Integer; override;
    procedure BeginBatch(AWithDelete: Boolean); override;
    procedure EndBatch; override;
    class function GetName: String; override;
    class function GetDescription: String; override;
    property MemTable: TkbmMemTable read GetMemTable;
  end;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedKbmMemTable                                                       }
{---------------------------------------------------------------------------}
constructor TADSpeedKbmMemTable.Create;
begin
  inherited Create;
  DataSet := TkbmMemTable.Create(nil);
end;

{---------------------------------------------------------------------------}
function TADSpeedKbmMemTable.GetMemTable: TkbmMemTable;
begin
  Result := TkbmMemTable(DataSet);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedKbmMemTable.BeginBatch(AWithDelete: Boolean);
begin
  MemTable.EnableIndexes := False;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedKbmMemTable.EndBatch;
begin
  MemTable.EnableIndexes := True;
  MemTable.UpdateIndexes;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedKbmMemTable.AddIndex(const AName, AFieldNames: String);
begin
   MemTable.IndexDefs.Add(AName, AFieldNames, []);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedKbmMemTable.CreateDataSet;
begin
  inherited CreateDataSet;
  MemTable.CreateTable;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedKbmMemTable.DeleteDataSet;
begin
  inherited DeleteDataSet;
  MemTable.DeleteTable;
  MemTable.IndexDefs.Clear;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedKbmMemTable.SetIndex(const AName: String; AIndex: Integer);
begin
  if AName <> '' then
    MemTable.IndexName := AName
  else if AIndex >= 0 then
    MemTable.IndexName := MemTable.Indexes.GetIndex(AIndex).Name
  else
    MemTable.IndexName := '';
end;

{---------------------------------------------------------------------------}
function TADSpeedKbmMemTable.GetIndexCount: Integer;
begin
  Result := MemTable.Indexes.Count;
end;

{---------------------------------------------------------------------------}
class function TADSpeedKbmMemTable.GetName: String;
begin
  Result := 'TKbmMemTable';
end;

{---------------------------------------------------------------------------}
class function TADSpeedKbmMemTable.GetDescription: String;
begin
  Result := 'Comp4Dev TKbmMemTable Stan';
end;

end.
