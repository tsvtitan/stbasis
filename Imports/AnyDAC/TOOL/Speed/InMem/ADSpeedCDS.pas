{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - Delphi client dataset unit                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedCDS;

interface

uses
  ADSpeedBase, ADSpeedBaseInMem,
  DBClient;

type
  TADSpeedClientDataSet = class(TADSpeedCustomInMemDataSet)
  private
    function GetCDS: TClientDataSet;
  public
    constructor Create; override;
    procedure AddIndex(const AName, AFieldNames: String); override;
    procedure CreateDataSet; override;
    procedure DeleteDataSet; override;
    procedure SetIndex(const AName: String; AIndex: Integer); override;
    function GetIndexCount: Integer; override;
    class function GetName: String; override;
    class function GetDescription: String; override;
    property CDS: TClientDataSet read GetCDS;
  end;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedClientDataSet                                                     }
{---------------------------------------------------------------------------}
constructor TADSpeedClientDataSet.Create;
begin
  inherited Create;
  DataSet := TClientDataSet.Create(nil);
end;

{---------------------------------------------------------------------------}
function TADSpeedClientDataSet.GetCDS: TClientDataSet;
begin
  Result := TClientDataSet(DataSet);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedClientDataSet.AddIndex(const AName, AFieldNames: String);
begin
  CDS.IndexDefs.Add(AName, AFieldNames, []);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedClientDataSet.CreateDataSet;
begin
  inherited CreateDataSet;
  CDS.CreateDataSet;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedClientDataSet.DeleteDataSet;
begin
  inherited DeleteDataSet;
  CDS.IndexDefs.Clear;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedClientDataSet.SetIndex(const AName: String; AIndex: Integer);
begin
  if AName <> '' then
    CDS.IndexName := AName
  else if AIndex >= 0 then
    CDS.IndexName := CDS.IndexDefs[AIndex].Name
  else
    CDS.IndexName := '';
end;

{---------------------------------------------------------------------------}
function TADSpeedClientDataSet.GetIndexCount: Integer;
begin
  Result := CDS.IndexDefs.Count;
end;

{---------------------------------------------------------------------------}
class function TADSpeedClientDataSet.GetName: String;
begin
  Result := 'TClientDataSet';
end;

{---------------------------------------------------------------------------}
class function TADSpeedClientDataSet.GetDescription: String;
begin
  Result := 'Delphi TClientDataSet';
end;

end.
