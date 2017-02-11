{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - AnyDAC client dataset unit                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedADCDS;

interface

uses
  daADGUIxConsoleWait, daADCompDataSet, daADCompClient,
  ADSpeedBase, ADSpeedBaseInMem;

type
  TADSpeedADClientDataSet = class(TADSpeedCustomInMemDataSet)
  private
    function GetCDS: TADClientDataSet;
  public
    constructor Create; override;
    procedure BeginBatch(AWithDelete: Boolean); override;
    procedure EndBatch; override;
    procedure AddIndex(const AName, AFieldNames: String); override;
    procedure CreateDataSet; override;
    procedure DeleteDataSet; override;
    procedure SetIndex(const AName: String; AIndex: Integer); override;
    function GetIndexCount: Integer; override;
    class function GetName: String; override;
    class function GetDescription: String; override;
    property CDS: TADClientDataSet read GetCDS;
  end;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedADClientDataSet                                                   }
{---------------------------------------------------------------------------}
constructor TADSpeedADClientDataSet.Create;
begin
  inherited Create;
  DataSet := TADClientDataSet.Create(nil);
  TADClientDataSet(DataSet).SilentMode := True;
end;

{---------------------------------------------------------------------------}
function TADSpeedADClientDataSet.GetCDS: TADClientDataSet;
begin
  Result := TADClientDataSet(DataSet);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADClientDataSet.BeginBatch(AWithDelete: Boolean);
begin
  if CDS.Active then
    CDS.BeginBatch(AWithDelete);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADClientDataSet.EndBatch;
begin
  if CDS.Active then
    CDS.EndBatch;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADClientDataSet.AddIndex(const AName, AFieldNames: String);
begin
  with CDS.Indexes.Add do begin
    Name := AName;
    Fields := AFieldNames;
    Active := True;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADClientDataSet.CreateDataSet;
begin
  inherited CreateDataSet;
  CDS.CreateDataSet;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADClientDataSet.DeleteDataSet;
begin
  inherited DeleteDataSet;
  CDS.IndexDefs.Clear;
  CDS.Indexes.Clear;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedADClientDataSet.SetIndex(const AName: String; AIndex: Integer);
begin
  if AName <> '' then
    CDS.IndexName := AName
  else if AIndex >= 0 then
    CDS.Indexes[AIndex].Selected := True
  else
    CDS.IndexName := '';
end;

{---------------------------------------------------------------------------}
function TADSpeedADClientDataSet.GetIndexCount: Integer;
begin
  Result := CDS.Indexes.Count;
end;

{---------------------------------------------------------------------------}
class function TADSpeedADClientDataSet.GetName: String;
begin
  Result := 'TADClientDataSet';
end;

{---------------------------------------------------------------------------}
class function TADSpeedADClientDataSet.GetDescription: String;
begin
  Result := 'AnyDAC TADClientDataSet';
end;

end.
