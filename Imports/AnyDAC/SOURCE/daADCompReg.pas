{-------------------------------------------------------------------------------}
{ AnyDAC design time registration unit                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADCompReg;

interface

uses
  Windows, SysUtils, Classes, Dialogs, TypInfo, DB, ShellAPI, Menus,
{$IFDEF AnyDAC_D6}
    ToolsAPI, DesignIntf, DesignEditors, PropertyCategories, DSDesign, DBReg,
    StrEdit,
{$ELSE}
    ToolIntf, DsgnIntf, ExptIntf;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADConnectionDefFileNameProp                                                  }
{-------------------------------------------------------------------------------}
type
  TADConnectionDefFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
{ TADListProperty                                                               }
{-------------------------------------------------------------------------------}
type
  TADListProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
    procedure DoGetValues(AComp: TComponent; AList: TStrings); virtual; abstract;
  end;

{-------------------------------------------------------------------------------}
{ TADConnectionDefNameProp                                                      }
{-------------------------------------------------------------------------------}
type
  TADConnectionDefNameProp = class(TADListProperty)
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
{ TADDriverNameProp                                                             }
{-------------------------------------------------------------------------------}
type
  TADDriverNameProp = class(TADListProperty)
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
{ TADConnectionNameProp                                                         }
{-------------------------------------------------------------------------------}
type
  TADConnectionNameProp = class(TADListProperty)
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
{ TADTableNameProp                                                              }
{-------------------------------------------------------------------------------}
type
  TADTableNameProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
  end;

procedure Register;

implementation

uses
  daADStanConst, daADStanUtil, daADStanDef, daADStanAsync, daADStanPool,
    daADStanExpr, daADStanFactory, daADStanResStrs,
{$IFDEF AnyDAC_MONITOR}
    daADMoniIndyClient, daADMoniCustom, daADMoniFlatFile,
{$ENDIF}
  daADGUIxFormsfAbout, daADGUIxFormsQBldr, daADGUIxFormsfQBldr, daADGUIxFormsfError,
    daADGUIxFormsfLogin, daADGUIxFormsfFetchOptions, daADGUIxFormsfFormatOptions,
    daADGUIxFormsfUpdateOptions, daADGUIxFormsfResourceOptions, daADGUIxFormsfConnEdit,
    daADGUIxFormsfUSEdit, daADGUIxFormsfQEdit, daADGUIxFormsfAsync, daADGUIxFormsWait,
    daADGUIxIntf, daADGUIxFormsControls,
  daADDAptManager,
{$IFDEF AnyDAC_D6}
  {$IFDEF AnyDAC_D11}
  daADPhysTDBX,
  {$ELSE}
  daADPhysDbExp,
  {$ENDIF}
{$ENDIF}
    daADPhysODBC, daADPhysMSAcc, daADPhysMSSQL, daADPhysDb2, daADPhysMySQL,
    daADPhysOracl, daADPhysASA, daADPhysADS, daADPhysManager, daADCompDataSet,
    daADCompClient, daADCompDataMove;


{-------------------------------------------------------------------------------}
function TADListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADListProperty.GetValues(Proc: TGetStrProc);
var
  oList: TStringList;
  i: Integer;
  oComp: TComponent;
begin
  oList := TStringList.Create;
  try
    oComp := GetComponent(0) as TComponent;
    DoGetValues(oComp, oList);
    for i := 0 to oList.Count - 1 do
      Proc(oList[i]);
  finally
    oList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADListProperty.AutoFill: Boolean;
begin
  Result := False;
end;


{-------------------------------------------------------------------------------}
procedure TADConnectionNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
begin
  ADManager.GetConnectionNames(AList);
end;


{-------------------------------------------------------------------------------}
function TADConnectionDefFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    with oDialog do begin
      DefaultExt := 'ini';
      Filter := S_AD_RegIniFilter;
      FileName := GetValue;
      if Execute then
        SetValue(FileName);
    end;
  finally
    oDialog.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
begin
  ADManager.GetConnectionDefNames(AList);
end;


{-------------------------------------------------------------------------------}
procedure TADDriverNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
begin
  ADManager.GetDriverNames(AList);
end;

{-------------------------------------------------------------------------------}
{ TADConnectionEditor                                                           }
{-------------------------------------------------------------------------------}
type
  TADConnectionEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADConnectionEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0:
      if TfrmADGUIxFormsConnEdit.Execute(TADCustomConnection(Component), Component.Name) then
        Designer.Modified;
    end;
end;

{-------------------------------------------------------------------------------}
function TADConnectionEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegConnectionEditor;
    end;
end;

{-------------------------------------------------------------------------------}
function TADConnectionEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADPackageNameProp                                                            }
{-------------------------------------------------------------------------------}
type
  TADPackageNameProp = class(TADListProperty)
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADPackageNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oSP: TADCustomStoredProc;
  oConn: TADCustomConnection;
begin
  oSP := AComp as TADCustomStoredProc;
  oConn := oSP.Command.OpenConnection;
  try
    oConn.GetPackageNames(oSP.CatalogName, oSP.SchemaName, '', AList);
  finally
    oSP.Command.CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADStoredProcNameProp                                                         }
{-------------------------------------------------------------------------------}
type
  TADStoredProcNameProp = class(TADListProperty)
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADStoredProcNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oSP: TADCustomStoredProc;
  oConn: TADCustomConnection;
begin
  oSP := AComp as TADCustomStoredProc;
  oConn := oSP.Command.OpenConnection;
  try
    oConn.GetStoredProcNames(oSP.CatalogName, oSP.SchemaName, oSP.PackageName, '', AList);
  finally
    oSP.Command.CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADDataSetEditor                                                              }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
type
  TADDSDesigner = class(TDSDesigner)
  public
    function SupportsAggregates: Boolean; override;
    function SupportsInternalCalc: Boolean; override;
    function DoCreateField(const FieldName: {$IFDEF AnyDAC_D10} WideString {$ELSE}
      string {$ENDIF}; Origin: string): TField; override;
  end;

  TADDataSetEditor = class(TDataSetEditor)
  protected
    function GetDSDesignerClass: TDSDesignerClass; override;
  end;

{-------------------------------------------------------------------------------}
function TADDSDesigner.DoCreateField(const FieldName: {$IFDEF AnyDAC_D10} WideString {$ELSE}
  string {$ENDIF}; Origin: string): TField;
var
  oDS: TADDataSet;
begin
  Result := inherited DoCreateField(FieldName, Origin);
  oDS := TADDataSet(DataSet);
  oDS.SetFieldAttributes(Result, oDS.GetFieldColumn(Result), True);
end;

{-------------------------------------------------------------------------------}
function TADDSDesigner.SupportsAggregates: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDSDesigner.SupportsInternalCalc: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDataSetEditor.GetDSDesignerClass: TDSDesignerClass;
begin
  Result := TADDSDesigner;
end;
{$ELSE}

{-------------------------------------------------------------------------------}
{-------------------------------------------------------------------------------}
var
  DataSetEditorClass: TComponentEditorClass;

{-------------------------------------------------------------------------------}
{$WARNINGS OFF}
procedure CaptureDataSetEditorClass;
var
  ds: TDataSet;
  dsEditor: TComponentEditor;
begin
  ds := nil;
  dsEditor := nil;
  try
    ds := TDataSet.Create(nil);
    dsEditor := GetComponentEditor(ds, nil);
    DataSetEditorClass := TComponentEditorClass(dsEditor.ClassType);
  finally
    dsEditor.Free;
    ds.Free;
  end;
end;
{$WARNINGS ON}

{-------------------------------------------------------------------------------}
type
  TADDataSetEditor = class(TComponentEditor)
  private
    FPrevEditor: TComponentEditor;
  public
    constructor Create(AComponent: TComponent; ADesigner: IFormDesigner); override;
    destructor Destroy; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADDataSetEditor.Create(AComponent: TComponent; ADesigner: IFormDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FPrevEditor := DataSetEditorClass.Create(AComponent, ADesigner);
end;

{-------------------------------------------------------------------------------}
destructor TADDataSetEditor.Destroy;
begin
  FreeAndNil(FPrevEditor);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSetEditor.ExecuteVerb(Index: Integer);
begin
  if Index < FPrevEditor.GetVerbCount then
    FPrevEditor.ExecuteVerb(Index);
end;

{-------------------------------------------------------------------------------}
function TADDataSetEditor.GetVerb(Index: Integer): string;
begin
  if Index < FPrevEditor.GetVerbCount then
    Result := FPrevEditor.GetVerb(Index);
end;

{-------------------------------------------------------------------------------}
function TADDataSetEditor.GetVerbCount: Integer;
begin
  Result := FPrevEditor.GetVerbCount;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSetEditor.Edit;
begin
  ExecuteVerb(0);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADRdbmsDataSetEditor                                                         }
{-------------------------------------------------------------------------------}
type
  TADRdbmsDataSetEditor = class(TADDataSetEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{$IFDEF AnyDAC_D6}
  TADSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;
{$ENDIF}  

  __TADRdbmsDataSet = class(TADRdbmsDataSet)
  end;

procedure TADRdbmsDataSetEditor.ExecuteVerb(Index: Integer);
var
  lPrep: Boolean;
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case Index - inherited GetVerbCount of
    0: with __TADRdbmsDataSet(Component) do begin
        lPrep := Prepared;
        try
          Execute;
        finally
          if not lPrep then
            Prepared := False;
        end;
      end;
    1: TADRdbmsDataSet(Component).NextRecordSet;
    end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSetEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case Index - inherited GetVerbCount of
    0: Result := S_AD_RegExecute;
    1: Result := S_AD_RegRdbmsNextRS;
    end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSetEditor.GetVerbCount: Integer;
begin
  Result := 2 + inherited GetVerbCount;
end;

{$IFDEF AnyDAC_D6}
{-------------------------------------------------------------------------------}
procedure TADSelectionEditor.RequiresUnits(Proc: TGetStrProc);
var
  i: Integer;
  oComp: TComponent;
begin
  for i := 0 to Designer.Root.ComponentCount - 1 do begin
    oComp := Designer.Root.Components[i];
    if oComp is TADDataSet then begin
      Proc('daADStanIntf');
      Proc('daADDatSManager');
    end;
    if oComp is TADCustomManager then begin
      Proc('daADStanIntf');
      Proc('daADStanOption');
      Proc('daADPhysIntf');
    end;
    if (oComp is TADCustomConnection) then begin
      Proc('daADStanIntf');
      Proc('daADStanOption');
      Proc('daADStanDef');
      Proc('daADPhysIntf');
    end;
    if (oComp is TADCustomCommand) or
       (oComp is TADAdaptedDataSet) then begin
      Proc('daADStanIntf');
      Proc('daADStanOption');
      Proc('daADStanParam');
      Proc('daADDatSManager');
      Proc('daADPhysIntf');
      Proc('daADDAptIntf');
    end;
    if oComp is TADUpdateSQL then begin
      Proc('daADStanIntf');
      Proc('daADStanParam');
      Proc('daADPhysIntf');
    end;
    if (oComp is TADCustomTableAdapter) or
       (oComp is TADCustomSchemaAdapter) then begin
      Proc('daADStanIntf');
      Proc('daADStanOption');
      Proc('daADDatSManager');
      Proc('daADPhysIntf');
      Proc('daADDAptIntf');
    end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADIndexNameProp, TADIndexFieldNamesProp, TADMasterFieldsProp                 }
{-------------------------------------------------------------------------------}
type
  TADIndexNameProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TADIndexFieldNamesProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TADMasterFieldsProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADIndexNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADIndexNameProp.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  oDS: TADDataSet;
begin
  oDS := GetComponent(0) as TADDataSet;
  for i := 0 to oDS.Indexes.Count - 1 do
    Proc(oDS.Indexes[i].Name);
end;

{-------------------------------------------------------------------------------}
function TADIndexFieldNamesProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADIndexFieldNamesProp.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  oDS: TADDataSet;
begin
  oDS := GetComponent(0) as TADDataSet;
  for i := 0 to oDS.Indexes.Count - 1 do
    if oDS.Indexes[i].Fields <> '' then
      Proc(oDS.Indexes[i].Fields);
end;

{-------------------------------------------------------------------------------}
function TADMasterFieldsProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

{-------------------------------------------------------------------------------}
procedure TADMasterFieldsProp.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  oDS: TADDataSet;
  oDS2: TDataSet;
  oList: TStringList;
begin
  oDS := GetComponent(0) as TADDataSet;
  if oDS.MasterSource <> nil then begin
    oDS2 := oDS.MasterSource.DataSet;
    if oDS2 <> nil then begin
      oList := TStringList.Create;
      try
        oDS2.GetFieldNames(oList);
        for i := 0 to oList.Count - 1 do
          Proc(oList[i]);
      finally
        oList.Free;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADUpdateSQLEditor                                                            }
{-------------------------------------------------------------------------------}
type
  TADUpdateSQLEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TADUpdateSQLEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: if TfrmADGUIxFormsUSEdit.Execute(TADUpdateSQL(Component), Component.Name) then
         Designer.Modified;
    end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQLEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegUpdSQLEditor;
    end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQLEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADQueryEditor                                                                }
{-------------------------------------------------------------------------------}
type
  TADQueryEditor = class(TADRdbmsDataSetEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TADQueryEditor.ExecuteVerb(Index: Integer);
begin
  if Index < 1 then
    case Index of
    0: if TfrmADGUIxFormsQEdit.Execute(TADCustomQuery(Component), Component.Name) then
         Designer.Modified;
    end
  else
    inherited ExecuteVerb(Index - 1);
end;

{-------------------------------------------------------------------------------}
function TADQueryEditor.GetVerb(Index: Integer): string;
begin
  if Index < 1 then
    case Index of
    0: Result := S_AD_RegQEditor;
    end
  else
    Result := inherited GetVerb(Index - 1);
end;

{-------------------------------------------------------------------------------}
function TADQueryEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADStoredProcEditor                                                           }
{-------------------------------------------------------------------------------}
type
  TADStoredProcEditor = class(TADRdbmsDataSetEditor)
  end;

{-------------------------------------------------------------------------------}
{ TADCommandEditor                                                              }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
type
  TADSQLProperty = class(TStringListProperty)
  public
    procedure Edit; override;
  end;

procedure TADSQLProperty.Edit;
var
  oComponents: IDesignerSelections;
  oDesigner: IDesigner;
begin
  inherited Edit;
  oComponents := TDesignerSelections.Create;
  oDesigner := Designer;
  oDesigner.GetSelections(oComponents);
  oDesigner.ClearSelection;
  if Assigned(oDesigner) then
    oDesigner.SetSelections(oComponents);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADCommandEditor                                                              }
{-------------------------------------------------------------------------------}
type
  TADCommandEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TADCommandEditor.ExecuteVerb(Index: Integer);
var
  lPrep: Boolean;
  oQry: TADQuery;
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0:
      begin
        oQry := TADQuery.Create(nil);
        try
          oQry.Name := Component.Name;
          oQry.Connection := TADCustomCommand(Component).Connection;
          oQry.ConnectionName := TADCustomCommand(Component).ConnectionName;
          oQry.SQL := TADCustomCommand(Component).CommandText;
          oQry.Params := TADCustomCommand(Component).Params;
          oQry.Macros := TADCustomCommand(Component).Macros;
          oQry.FetchOptions.RestoreDefaults;
          oQry.FetchOptions := TADCustomCommand(Component).FetchOptions;
          oQry.ResourceOptions := TADCustomCommand(Component).ResourceOptions;
          oQry.UpdateOptions := TADCustomCommand(Component).UpdateOptions;
          oQry.FormatOptions := TADCustomCommand(Component).FormatOptions;
          if TfrmADGUIxFormsQEdit.Execute(oQry, oQry.Name) then begin
            TADCustomCommand(Component).CommandText := oQry.SQL;
            TADCustomCommand(Component).Params := oQry.Params;
            TADCustomCommand(Component).Macros := oQry.Macros;
            TADCustomCommand(Component).FetchOptions := oQry.FetchOptions;
            TADCustomCommand(Component).ResourceOptions := oQry.ResourceOptions;
            TADCustomCommand(Component).UpdateOptions := oQry.UpdateOptions;
            TADCustomCommand(Component).FormatOptions := oQry.FormatOptions;
            Designer.Modified;
          end;
        finally
          oQry.Free;
        end;
      end;
    1:
      begin
        lPrep := TADCustomCommand(Component).Prepared;
        try
          TADCustomCommand(Component).Execute;
        finally
          TADCustomCommand(Component).Prepared := lPrep;
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADCommandEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegQEditor;
    1: Result := S_AD_RegExecute;
    end;
end;

{-------------------------------------------------------------------------------}
function TADCommandEditor.GetVerbCount: Integer;
begin
  Result := 2 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADDataMoveEditor                                                             }
{-------------------------------------------------------------------------------}
type
  TADDataMoveEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADDataMoveEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: TADDataMove(Component).Execute;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDataMoveEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegExecute;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDataMoveEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADDataMoveMapFieldEditor                                                     }
{-------------------------------------------------------------------------------}
type
  TADDataMoveMapFieldEditor = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADDataMoveMapFieldEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

{-------------------------------------------------------------------------------}
procedure TADDataMoveMapFieldEditor.GetValues(Proc: TGetStrProc);
var
  oList: TStringList;
  i: Integer;
  oComp: TADMappingItem;
  oDS: TDataSet;
begin
  oList := TStringList.Create;
  try
    oComp := GetComponent(0) as TADMappingItem;
    if GetName = 'SourceFieldName' then
      oDS := TADMappings(oComp.Collection).DataMove.Source
    else if GetName = 'DestinationFieldName' then
      oDS := TADMappings(oComp.Collection).DataMove.Destination
    else
      oDS := nil;
    if oDS <> nil then begin
      oDS.GetFieldNames(oList);
      for i := 0 to oList.Count - 1 do
        Proc(oList[i]);
    end;
  finally
    oList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADAsciiFileNameProp                                                          }
{-------------------------------------------------------------------------------}
type
  TADAsciiFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADAsciiFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADAsciiFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    with oDialog do begin
      DefaultExt := 'txt';
      Filter := S_AD_RegTxtFilter;
      FileName := GetValue;
      if Execute then
        SetValue(FileName);
    end;
  finally
    oDialog.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADLogFileNameProp                                                            }
{-------------------------------------------------------------------------------}
type
  TADLogFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADLogFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADLogFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    with oDialog do begin
      DefaultExt := 'log';
      Filter := S_AD_RegLogFilter;
      FileName := GetValue;
      if Execute then
        SetValue(FileName);
    end;
  finally
    oDialog.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADScriptEditor                                                               }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_Script}
type
  TADScriptEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADScriptEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: TADScript(Component).ExecuteAll;
    1: TADScript(Component).Validate;
    end;
end;

{-------------------------------------------------------------------------------}
function TADScriptEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegExecute;
    1: Result := S_AD_RegValidate;
    end;
end;

{-------------------------------------------------------------------------------}
function TADScriptEditor.GetVerbCount: Integer;
begin
  Result := 2 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADSQLScriptFileNameProp                                                      }
{-------------------------------------------------------------------------------}
type
  TADSQLScriptFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADSQLScriptFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScriptFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    with oDialog do begin
      DefaultExt := 'sql';
      Filter := S_AD_RegSQLFilter;
      FileName := GetValue;
      if Execute then
        SetValue(FileName);
    end;
  finally
    oDialog.Free;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADTableNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
function TADTableNameProp.AutoFill: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADTableNameProp.GetValues(Proc: TGetStrProc);
var
  oList: TStringList;
  i: Integer;
  oTab: TADTable;
  oConn: TADCustomConnection;
  sCatalogName, sSchemaName, sBaseObjectName, sObjectName: String;
begin
  oTab := GetComponent(0) as TADTable;
  try
    oConn := oTab.Command.OpenConnection;
    oList := TStringList.Create;
    try
      sCatalogName := oTab.CatalogName;
      sSchemaName := oTab.SchemaName;
      if (sCatalogName = '') and (sSchemaName = '') and (Value <> '') then
        oConn.DecodeObjectName(Value, sCatalogName, sSchemaName,
          sBaseObjectName, sObjectName);
      oConn.GetTableNames(sCatalogName, sSchemaName, '', oList);
      for i := 0 to oList.Count - 1 do
        Proc(oList[i]);
    finally
      oList.Free;
      oTab.Command.CloseConnection(oConn);
    end;
  except
  end;
end;

{-------------------------------------------------------------------------------}
{ TADUpdateTableNameProp                                                        }
{-------------------------------------------------------------------------------}
type
  TADUpdateTableNameProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADUpdateTableNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
function TADUpdateTableNameProp.AutoFill: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateTableNameProp.GetValues(Proc: TGetStrProc);
var
  oList: TStringList;
  i: Integer;
  oCmd: TADCommand;
  oConn: TADCustomConnection;
begin
  oCmd := ((GetComponent(0) as TADTableUpdateOptions).OwnerObj as TADCommand);
  oList := TStringList.Create;
  try
    try
      oConn := oCmd.OpenConnection;
      try
        oConn.GetTableNames('', '', '', oList);
        for i := 0 to oList.Count - 1 do
          Proc(oList[i]);
      finally
        oCmd.CloseConnection(oConn);
      end;
    finally
      oList.Free;
    end;
  except
  end;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsQBldrDialogEditor                                                 }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsQBldrDialogEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsQBldrDialogEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: TADGUIxFormsQBldrDialog(Component).Execute;
    end;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsQBldrDialogEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegExecute;
    end;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsQBldrDialogEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADExpert                                                                     }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
type
  TADExpert = class(TNotifierObject, IOTAWIzard)
  private
    FAnyDACMainMI: TMenuItem;
    FAboutMI: TMenuItem;
    FSplit1MI: TMenuItem;
    FDaSoftMI: TMenuItem;
    FMonitorMI: TMenuItem;
    FExplorerMI: TMenuItem;
    FExecutorMI: TMenuItem;
    FErrDlg: TADGUIxFormsErrorDialog;
    FLoginDlg: TADGUIxFormsLoginDialog;
    FAsyncDlg: TADGUIxFormsAsyncExecuteDialog;
{$IFDEF AnyDAC_MONITOR}
    FMoniIndy: TADMoniIndyClientLink;
    FMoniFlatFile: TADMoniFlatFileClientLink;
{$ENDIF}
    procedure AboutClick(Sender: TObject);
    procedure DaSoftClick(Sender: TObject);
    procedure MonitorClick(Sender: TObject);
    procedure ExplorerClick(Sender: TObject);
    procedure RunRegisteredApp(const AName: String);
    procedure ExecutorClick(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
  end;

{-------------------------------------------------------------------------------}
constructor TADExpert.Create;
var
  oNTAServ: INTAServices;
  oMainMenu: TMainMenu;
  i: Integer;
begin
  inherited Create;
  FAnyDACMainMI := nil;
  FAboutMI := nil;
  FSplit1MI := nil;
  FDaSoftMI := nil;
  FMonitorMI := nil;
  FExplorerMI := nil;
  FExecutorMI := nil;

  oNTAServ := BorlandIDEServices as INTAServices;
  oMainMenu := oNTAServ.MainMenu;

  for i := 0 to oMainMenu.Items.Count - 1 do
    if oMainMenu.Items[i].Name = 'ToolsMenu' then begin
      FAnyDACMainMI := NewItem('&AnyDAC', 0, False, True, nil, -1, 'ADMenu');

      FExecutorMI := NewItem(S_AD_Executor, 0, False, True, ExecutorClick, -1, 'ADExecutorItem');
      FExplorerMI := NewItem(S_AD_Explorer, 0, False, True, ExplorerClick, -1, 'ADExplorerItem');
      FMonitorMI := NewItem(S_AD_Monitor, 0, False, True, MonitorClick, -1, 'ADMonitorItem');
      FSplit1MI := NewLine;
      FDaSoftMI := NewItem(S_AD_DAHome, 0, False, True, DaSoftClick, -1, 'DaSoftHomeItem');
      FAboutMI := NewItem(S_AD_About, 0, False, True, AboutClick, -1, 'ADAboutItem');

      FAnyDACMainMI.Add([FExecutorMI, FExplorerMI, FMonitorMI, FSplit1MI,
        FDaSoftMI, FAboutMI]);
      oMainMenu.Items.Insert(i, FAnyDACMainMI);

      Break;
    end;
    
  FErrDlg := TADGUIxFormsErrorDialog.Create(nil);
  FLoginDlg := TADGUIxFormsLoginDialog.Create(nil);
  FLoginDlg.LoginRetries := $7FFFFFFF;
  FLoginDlg.DefaultDialog := True;
  FAsyncDlg := TADGUIxFormsAsyncExecuteDialog.Create(nil);
{$IFDEF AnyDAC_MONITOR}
  FMoniIndy := TADMoniIndyClientLink.Create(nil);
  FMoniFlatFile := TADMoniFlatFileClientLink.Create(nil);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADExpert.Destroy;
begin
  FreeAndNil(FAboutMI);
  FreeAndNil(FExecutorMI);
  FreeAndNil(FExplorerMI);
  FreeAndNil(FMonitorMI);
  FreeAndNil(FDaSoftMI);
  FreeAndNil(FSplit1MI);
  FreeAndNil(FAnyDACMainMI);

  FreeAndNil(FErrDlg);
  FreeAndNil(FLoginDlg);
  FreeAndNil(FAsyncDlg);
{$IFDEF AnyDAC_MONITOR}
  FreeAndNil(FMoniIndy);
  FreeAndNil(FMoniFlatFile);
{$ENDIF}  

  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADExpert.GetIDString: string;
begin
  Result := 'da-soft.AnyDAC.Expert';
end;

{-------------------------------------------------------------------------------}
function TADExpert.GetName: string;
begin
  Result := 'AnyDACExpert';
end;

{-------------------------------------------------------------------------------}
function TADExpert.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.Execute;
begin
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.AboutClick(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute(HInstance);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.DaSoftClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar('http://www.da-soft.com'), nil, nil, SW_SHOW);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.RunRegisteredApp(const AName: String);
var
  sPath: String;
begin
  sPath := ADExpandStr(ADReadRegValue(AName));
  if sPath = '' then
    MessageDlg('No value [' + AName + '] in AnyDAC registry', mtError, [mbOk], -1)
  else if ShellExecute(0, 'open', PChar(sPath), nil, nil, SW_SHOW) <= 32 then
    MessageDlg('Failed to run [' + sPath + ']', mtError, [mbOk], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ExecutorClick(Sender: TObject);
begin
  RunRegisteredApp(S_AD_ExecValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ExplorerClick(Sender: TObject);
begin
  RunRegisteredApp(S_AD_ExplValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.MonitorClick(Sender: TObject);
begin
  RunRegisteredApp(S_AD_MoniValName);
end;

{$ELSE}
{-------------------------------------------------------------------------------}
type
  TADExpert = class(TIExpert)
  private
    FAnyDACMainMI: TIMenuItemIntf;
    FAboutMI: TIMenuItemIntf;
    FSplit1MI: TIMenuItemIntf;
    FDaSoftMI: TIMenuItemIntf;
    FMonitorMI: TIMenuItemIntf;
    FExplorerMI: TIMenuItemIntf;
    FExecutorMI: TIMenuItemIntf;
    FErrDlg: TADGUIxFormsErrorDialog;
    FLoginDlg: TADGUIxFormsLoginDialog;
    FAsyncDlg: TADGUIxFormsAsyncExecuteDialog;
{$IFDEF AnyDAC_MONITOR}
    FMoniIndy: TADMoniIndyClientLink;
    FMoniFlatFile: TADMoniFlatFileClientLink;
{$ENDIF}
    procedure AboutClick(Sender: TIMenuItemIntf);
    procedure DaSoftClick(Sender: TIMenuItemIntf);
    procedure ExecutorClick(Sender: TIMenuItemIntf);
    procedure ExplorerClick(Sender: TIMenuItemIntf);
    procedure MonitorClick(Sender: TIMenuItemIntf);
    procedure RunRegisteredApp(const AName: String);
  public
    constructor Create;
    destructor Destroy; override;
    function GetName: string; override;
    function GetStyle: TExpertStyle; override;
    function GetIDString: string; override;
  end;

{ --------------------------------------------------------------------------- }
function TADExpert.GetIDString: string;
begin
  Result := 'da-soft.AnyDAC.Expert';
end;

{ --------------------------------------------------------------------------- }
function TADExpert.GetName: string;
begin
  Result := 'AnyDACExpert';
end;

{ --------------------------------------------------------------------------- }
function TADExpert.GetStyle: TExpertStyle;
begin
  Result := esAddIn;
end;

{ --------------------------------------------------------------------------- }
constructor TADExpert.Create;
var
  oMainMenu: TIMainMenuIntf;
  oMenuItems: TIMenuItemIntf;
  oToolsMenu: TIMenuItemIntf;
begin
  inherited Create;
  FAnyDACMainMI := nil;
  FAboutMI := nil;
  FSplit1MI := nil;
  FDaSoftMI := nil;
  FMonitorMI := nil;
  FExplorerMI := nil;
  FExecutorMI := nil;

  oToolsMenu := nil;
  oMenuItems := nil;
  oMainMenu := ToolServices.GetMainMenu;
  if oMainMenu <> nil then
  try
    oMenuItems := oMainMenu.GetMenuItems;
    if oMenuItems <> nil then begin
      FAnyDACMainMI := oMainMenu.FindMenuItem('AnyDACMenu');
      if FAnyDACMainMI = nil then begin
        oToolsMenu := oMainMenu.FindMenuItem('ToolsMenu');
        if oToolsMenu <> nil then begin
          FAnyDACMainMI := oMenuItems.InsertItem(oToolsMenu.GetIndex,
            '&AnyDAC', 'AnyDACMenu', '', 0, 0, 0, [mfVisible, mfEnabled], nil);
          FExecutorMI := FAnyDACMainMI.InsertItem(0, S_AD_Executor,
            'ADExecutorItem', '', 0, 0, 0, [mfVisible, mfEnabled], ExecutorClick);
          FExplorerMI := FAnyDACMainMI.InsertItem(1, S_AD_Explorer,
            'ADExplorerItem', '', 0, 0, 0, [mfVisible, mfEnabled], ExplorerClick);
          FMonitorMI := FAnyDACMainMI.InsertItem(2, S_AD_Monitor,
            'ADMonitorItem', '', 0, 0, 0, [mfVisible, mfEnabled], MonitorClick);
          FSplit1MI := FAnyDACMainMI.InsertItem(3, '-',
            'Split1', '', 0, 0, 0, [mfVisible, mfEnabled], nil);
          FDaSoftMI := FAnyDACMainMI.InsertItem(4, S_AD_DAHome,
            'DaSoftHomeItem', '', 0, 0, 0, [mfVisible, mfEnabled], DaSoftClick);
          FAboutMI := FAnyDACMainMI.InsertItem(5, S_AD_About,
            'ADAboutItem', '', 0, 0, 0, [mfVisible, mfEnabled], AboutClick);
       end;
     end;
   end;
 finally
   FreeAndNil(oToolsMenu);
   FreeAndNil(oMenuItems);
   FreeAndNil(oMainMenu);
  end;

  FErrDlg := TADGUIxFormsErrorDialog.Create(nil);
  FLoginDlg := TADGUIxFormsLoginDialog.Create(nil);
  FLoginDlg.LoginRetries := $7FFFFFFF;
  FLoginDlg.DefaultDialog := True;
  FAsyncDlg := TADGUIxFormsAsyncExecuteDialog.Create(nil);
{$IFDEF AnyDAC_MONITOR}
  FMoniIndy := TADMoniIndyClientLink.Create(nil);
  FMoniFlatFile := TADMoniFlatFileClientLink.Create(nil);
{$ENDIF}
end;

{ --------------------------------------------------------------------------- }
destructor TADExpert.Destroy;
begin
  FreeAndNil(FAboutMI);
  FreeAndNil(FExecutorMI);
  FreeAndNil(FExplorerMI);
  FreeAndNil(FMonitorMI);
  FreeAndNil(FDaSoftMI);
  FreeAndNil(FSplit1MI);
  FreeAndNil(FAnyDACMainMI);

  FreeAndNil(FErrDlg);
  FreeAndNil(FLoginDlg);
  FreeAndNil(FAsyncDlg);
{$IFDEF AnyDAC_MONITOR}
  FreeAndNil(FMoniIndy);
  FreeAndNil(FMoniFlatFile);
{$ENDIF}  

  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.AboutClick(Sender: TIMenuItemIntf);
begin
  TfrmADGUIxFormsAbout.Execute(HInstance);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.DaSoftClick(Sender: TIMenuItemIntf);
begin
  ShellExecute(0, 'open', PChar('http://www.da-soft.com'), nil, nil, SW_SHOW);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.RunRegisteredApp(const AName: String);
var
  sPath: String;
begin
  sPath := ADExpandStr(ADReadRegValue(AName));
  if sPath = '' then
    MessageDlg('No value [' + AName + '] in AnyDAC registry', mtError, [mbOk], -1)
  else if ShellExecute(0, 'open', PChar(sPath), nil, nil, SW_SHOW) <= 32 then
    MessageDlg('Failed to run [' + sPath + ']', mtError, [mbOk], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ExecutorClick(Sender: TIMenuItemIntf);
begin
  RunRegisteredApp(S_AD_ExecValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ExplorerClick(Sender: TIMenuItemIntf);
begin
  RunRegisteredApp(S_AD_ExplValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.MonitorClick(Sender: TIMenuItemIntf);
begin
  RunRegisteredApp(S_AD_MoniValName);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure Register;
begin
{$IFNDEF AnyDAC_D6}
  CaptureDataSetEditorClass;
{$ENDIF}

  RegisterComponents('AnyDAC', [TADManager, TADConnection, TADCommand,
    TADTableAdapter, TADSchemaAdapter, TADClientDataSet, TADQuery,
    TADStoredProc, TADTable, TADUpdateSQL, TADDataMove, 
{$IFDEF AnyDAC_Script}
    TADScript,
{$ENDIF}
    TADMetaInfoQuery]);
  RegisterComponents('AnyDAC UI', [TADGUIxFormsQBldrEngine,
    TADGUIxFormsQBldrDialog, TADGUIxFormsErrorDialog, TADGUIxFormsLoginDialog,
    TADGUIxFormsAsyncExecuteDialog, TADGUIxWaitCursor]);
  RegisterComponents('AnyDAC Links', [
{$IFDEF AnyDAC_MONITOR}
    TADMoniIndyClientLink, TADMoniCustomClientLink, TADMoniFlatFileClientLink,
{$ENDIF}
    TADPhysOraclDriverLink, TADPhysDB2DriverLink, TADPhysMSAccessDriverLink,
    TADPhysMSSQLDriverLink, TADPhysMySQLDriverLink, TADPhysASADriverLink,
    TADPhysADSDriverLink, TADPhysODBCDriverLink
{$IFDEF AnyDAC_D6}
  {$IFDEF AnyDAC_D11}
    , TADPhysTDBXDriverLink
  {$ELSE}
    , TADPhysDBXDriverLink
  {$ENDIF}
{$ENDIF}
    ]);
  RegisterComponents('AnyDAC Devs', [TfrmADGUIxFormsFetchOptions,
    TfrmADGUIxFormsFormatOptions, TfrmADGUIxFormsUpdateOptions,
    TfrmADGUIxFormsResourceOptions, TADGUIxFormsPanelTree,
    TADGUIxFormsTabControl, TADGUIxFormsPageControl, TADGUIxFormsListView,
    TADGUIxFormsMemo, TADGUIxFormsPanel]);
  RegisterFields([TADWideMemoField, TADAutoIncField]);

  RegisterPropertyEditor(TypeInfo(String), TADCustomManager,
    'ConnectionDefFileName', TADConnectionDefFileNameProp);
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADCustomManager, TADSelectionEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADCustomConnection,
    'ConnectionDefName', TADConnectionDefNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomConnection,
    'DriverName', TADDriverNameProp);
  RegisterComponentEditor(TADCustomConnection, TADConnectionEditor);
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADCustomConnection, TADSelectionEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADCustomCommand,
    'ConnectionName', TADConnectionNameProp);
  // 1) BaseObjectName, Oracle, skStoredProc -> Packages
  // CatalogName
  // SchemaName
  // 2) CommandEditor = Query Editor
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADCustomCommand, TADSelectionEditor);
{$ENDIF}

{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADDataSet, TADSelectionEditor);
{$ENDIF}
  RegisterComponentEditor(TADDataSet, TADDataSetEditor);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'IndexName', TADIndexNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'IndexFieldNames', TADIndexFieldNamesProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'MasterFields', TADMasterFieldsProp);

  RegisterPropertyEditor(TypeInfo(String), TADRdbmsDataSet,
    'ConnectionName', TADConnectionNameProp);

  RegisterComponentEditor(TADCustomCommand, TADCommandEditor);
  RegisterComponentEditor(TADQuery, TADQueryEditor);
{$IFDEF AnyDAC_D6}
  RegisterPropertyEditor(TypeInfo(TStrings), TComponent,
    'SQL', TADSQLProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), TComponent,
    'CommandText', TADSQLProperty);
{$ENDIF}

  RegisterComponentEditor(TADCustomStoredProc, TADStoredProcEditor);
  RegisterPropertyEditor(TypeInfo(String), TADCustomStoredProc,
    'PackageName', TADPackageNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomStoredProc,
    'StoredProcName', TADStoredProcNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADUpdateSQL,
    'ConnectionName', TADConnectionNameProp);
  RegisterComponentEditor(TADUpdateSQL, TADUpdateSQLEditor);

  RegisterPropertyEditor(TypeInfo(String), TADDataMove,
    'AsciiFileName', TADAsciiFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataMove,
    'LogFileName', TADLogFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADMappingItem,
    'SourceFieldName', TADDataMoveMapFieldEditor);
  RegisterPropertyEditor(TypeInfo(String), TADMappingItem,
    'DestinationFieldName', TADDataMoveMapFieldEditor);
  RegisterComponentEditor(TADDataMove, TADDataMoveEditor);

{$IFDEF AnyDAC_Script}
  RegisterPropertyEditor(TypeInfo(String), TADScript,
    'SQLScriptFileName', TADSQLScriptFileNameProp);
  RegisterComponentEditor(TADScript, TADScriptEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADTable,
    'TableName', TADTableNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADTableUpdateOptions,
    'UpdateTableName', TADUpdateTableNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADGUIxFormsQBldrEngine,
    'ConnectionName', TADConnectionNameProp);

  RegisterComponentEditor(TADGUIxFormsQBldrDialog, TADGUIxFormsQBldrDialogEditor);

{$IFDEF AnyDAC_D6}
  RegisterPackageWizard(TADExpert.Create as IOTAWizard);
{$ELSE}
//  RegisterLibraryExpert(TADExpert.Create);
{$ENDIF}
end;

end.