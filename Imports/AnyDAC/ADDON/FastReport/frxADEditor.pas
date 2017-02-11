
{******************************************}
{                                          }
{             FastReport v4.0              }
{      AD components design editors        }
{                                          }
{       Created by: Serega Glazyrin        }
{      E-mail: glserega@mezonplus.ru       }
{                                          }
{                                          }
{                                          }
{                                          }
{******************************************}

unit frxADEditor;

interface

{$I frx.inc}

implementation

uses
  Windows, Classes, SysUtils, Forms, Dialogs, frxADComponents, frxCustomDB,
  frxDsgnIntf, frxRes, daADCompClient
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxDatabaseProperty = class(TfrxComponentProperty)
  public
    function GetValue: String; override;
    procedure SetValue(const Value: String); override;
  end;
  TfrxDatabaseDriverNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const Value: String); override;
  end;

  TfrxDatabaseConnectionNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const Value: String); override;
  end;

  TfrxPackageNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const Value: String); override;
  end;

  TfrxStoredProcNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure GetValues; override;
    procedure SetValue(const Value: String); override;
  end;



function TfrxDatabaseProperty.GetValue: String;
var
  db: TfrxADDatabase;
begin
  db := TfrxADDatabase(GetOrdValue);
  if db = nil then
  begin
    if (ADComponents <> nil) and (ADComponents.DefaultDatabase <> nil) then
      Result := ADComponents.DefaultDatabase.Name
    else
      Result := frxResources.Get('prNotAssigned');
  end
  else
    Result := inherited GetValue;
end;




function TfrxPackageNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

procedure TfrxPackageNameProperty.GetValues;
begin
  inherited;
  with TfrxADStoredProc(Component).StoredProc do
    if Connection <> nil then
      Connection.GetPackageNames('', SchemaName, '',Values);
end;

procedure TfrxPackageNameProperty.SetValue(const Value: String);
begin
  inherited;
  Designer.UpdateDataTree;
end;


function TfrxStoredProcNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

procedure TfrxStoredProcNameProperty.GetValues;
begin
  inherited;
  with TfrxADStoredProc(Component).StoredProc do
    if Connection <> nil then
      Connection.GetStoredProcNames('', SchemaName, PackageName,'', Values);
end;

procedure TfrxStoredProcNameProperty.SetValue(const Value: String);
begin
  inherited;
end;

{ TfrxDatabaseDriverNameProperty }

function TfrxDatabaseDriverNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

procedure TfrxDatabaseDriverNameProperty.GetValues;
begin
  inherited;
  ADManager.GetDriverNames(Values);
end;

procedure TfrxDatabaseDriverNameProperty.SetValue(const Value: String);
begin
  inherited;
  Designer.UpdateDataTree;
end;

{ TfrxDatabaseConnectionNameProperty }

function TfrxDatabaseConnectionNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

procedure TfrxDatabaseConnectionNameProperty.GetValues;
begin
  inherited;
  ADManager.GetConnectionNames(Values);
end;

procedure TfrxDatabaseConnectionNameProperty.SetValue(const Value: String);
begin
  inherited;
  Designer.UpdateDataTree;
end;

{ TfrxConnectionProperty }

{ TfrxConnectionProperty }

procedure TfrxDatabaseProperty.SetValue(const Value: String);
begin
  inherited;
  Designer.UpdateDataTree;
end;

initialization
  frxPropertyEditors.Register(TypeInfo(TfrxADDatabase), TfrxADQuery, 'Database',
    TfrxDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(string), TfrxADDatabase, 'DriverName',
    TfrxDatabaseDriverNameProperty);
  frxPropertyEditors.Register(TypeInfo(string), TfrxADQuery, 'ConnectionName',
    TfrxDatabaseConnectionNameProperty);
  frxPropertyEditors.Register(TypeInfo(string), TfrxADStoredProc, 'ConnectionName',
    TfrxDatabaseConnectionNameProperty);

  frxPropertyEditors.Register(TypeInfo(TfrxADDatabase), TfrxADStoredProc, 'Database',
    TfrxDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(string), TfrxADStoredProc, 'PackageName',
    TfrxPackageNameProperty);
  frxPropertyEditors.Register(TypeInfo(string), TfrxADStoredProc, 'StoredProcName',
    TfrxStoredProcNameProperty);

end.
