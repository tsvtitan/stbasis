{************************************************************************}
{                                                                        }
{       Borland Delphi Visual Component Library                          }
{       InterBase Express core components                                }
{                                                                        }
{       Copyright (c) 1998-2000 Inprise Corporation                      }
{                                                                        }
{    InterBase Express is based in part on the product                   }
{    Free IB Components, written by Gregory H. Deatz for                 }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.                     }
{    Free IB Components is used under license.                           }
{                                                                        }
{    The contents of this file are subject to the InterBase              }
{    Public License Version 1.0 (the "License"); you may not             }
{    use this file except in compliance with the License. You            }
{    may obtain a copy of the License at http://www.Inprise.com/IPL.html }
{    Software distributed under the License is distributed on            }
{    an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either              }
{    express or implied. See the License for the specific language       }
{    governing rights and limitations under the License.                 }
{    The Original Code was created by InterBase Software Corporation     }
{       and its successors.                                              }
{    Portions created by Inprise Corporation are Copyright (C) Inprise   }
{       Corporation. All Rights Reserved.                                }
{    Contributor(s): Jeff Overcash                                       }
{                                                                        }
{************************************************************************}

unit IBDBReg;

(*
 * Compiler defines
 *)
{$A+}                           (* Aligned records: On *)
{$B-}                           (* Short circuit boolean expressions: Off *)
{$G+}                           (* Imported data: On *)
{$H+}                           (* Huge Strings: On *)
{$J-}                           (* Modification of Typed Constants: Off *)
{$M+}                           (* Generate run-time type information: On *)
{$O+}                           (* Optimization: On *)
{$Q-}                           (* Overflow checks: Off *)
{$R-}                           (* Range checks: Off *)
{$T+}                           (* Typed address: On *)
{$U+}                           (* Pentim-safe FDIVs: On *)
{$W-}                           (* Always generate stack frames: Off *)
{$X+}                           (* Extended syntax: On *)
{$Z1}                           (* Minimum Enumeration Size: 1 Byte *)

interface

uses Windows, SysUtils, Classes, Graphics, Dialogs, Controls, Forms, TypInfo,
     DsgnIntf, DB, {ParentageSupport, dsndb, DBReg, ColnEdit, FldLinks, SQLEdit,
     DataModelSupport, }IBTable, IBDatabase, IBUpdateSQLEditor,  IBEventsEditor,
     IBXConst; 

type

{ TIBFileNameProperty
  Property editor the DataBase Name property.  Brings up the Open dialog }

  TIBFileNameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TIBNameProperty
  }
  TIBNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TIBStoredProcNameProperty
    Editor for the TIBStoredProc.StoredProcName property.  Displays a drop-down list of all
    the StoredProcedures in the Database.}
  TIBStoredProcNameProperty = class(TIBNameProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  { TIBTableNameProperty
    Editor for the TIBTable.TableName property.  Displays a drop-down list of all
    the Tables in the Database.}
  TIBTableNameProperty = class(TIBNameProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TIBIndexFieldNamesProperty = class(TDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TIBIndexNameProperty = class(TDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

{ TIBDatabaseEditor }

  TIBDatabaseEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{ TIBTransactionEditor }

  TIBTransactionEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{ TIBQueryEditor }

{  TIBQueryEditor = class(TDataSetEditor)
  protected
    FGetTableNamesProc: TGetTableNamesProc;
    FGetFieldnamesProc: TGetFieldNamesProc;
  public
    procedure EditSQL;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;}

{ TIBStoredProcEditor }

{  TIBStoredProcEditor = class(TDataSetEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;}

{ TIBDataSetEditor }

{  TIBDataSetEditor = class(TDataSetEditor)
  protected
    FGetTableNamesProc: TGetTableNamesProc;
    FGetFieldnamesProc: TGetFieldNamesProc;
  public
    procedure EditSQL;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;}

{ TIBUpdateSQLEditor }

  TIBUpdateSQLEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
   function GetVerbCount: Integer; override;
  end;

{  TIBStoredProcParamsProperty = class(TCollectionProperty)
  public
    procedure Edit; override;
  end;}

{  TIBTableFieldLinkProperty = class(TFieldLinkProperty)
  private
    FTable: TIBTable;
  protected
    function GetIndexFieldNames: string; override;
    function GetMasterFields: string; override;
    procedure SetIndexFieldNames(const Value: string); override;
    procedure SetMasterFields(const Value: string); override;
  public
    procedure Edit; override;
  end;}

{ TSQLPropertyEditor }

{  TSQLPropertyEditor = class(TClassProperty)
  protected
    FGetTableNamesProc: TGetTableNamesProc;
    FGetFieldnamesProc: TGetFieldNamesProc;
  public
    procedure EditSQL;
    function GetAttributes: TPropertyAttributes; override;
  end;
 }
{ TIBQuerySQLProperty }

{  TIBQuerySQLProperty = class(TSQLPropertyEditor)
  public
    procedure Edit; override;
  end;}

{ TIBDatasetSQLProperty }

{  TIBDatasetSQLProperty = class(TSQLPropertyEditor)
  public
    procedure Edit; override;
  end;}

{ TIBSQLProperty }

{  TIBSQLProperty = class(TSQLPropertyEditor)
  public
    procedure Edit; override;
  end;

  TIBEventListProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;}

{ DataModel Designer stuff }

{  TIBSQLSprig = class(TSprig)
  public
    procedure FigureParent; override;
    function AnyProblems: Boolean; override;
    function DragDropTo(AItem: TSprig): Boolean; override;
    function DragOverTo(AItem: TSprig): Boolean; override;
    class function PaletteOverTo(AParent: TSprig; AClass: TClass): Boolean; override;
  end;

  TIBCustomDataSetSprig = class(TDataSetSprig)
  public
    procedure FigureParent; override;
    function AnyProblems: Boolean; override;
    function DragDropTo(AItem: TSprig): Boolean; override;
    function DragOverTo(AItem: TSprig): Boolean; override;
    class function PaletteOverTo(AParent: TSprig; AClass: TClass): Boolean; override;
  end;

  TIBQuerySprig = class(TIBCustomDataSetSprig)
  public
    function AnyProblems: Boolean; override;
  end;

  TIBTableSprig = class(TIBCustomDataSetSprig)
  public
    function AnyProblems: Boolean; override;
    function Caption: string; override;
  end;

  TIBStoredProcSprig = class(TIBCustomDataSetSprig)
  public
    function AnyProblems: Boolean; override;
    function Caption: string; override;
  end;

  TIBUpdateSQLSprig = class(TSprigAtRoot)
  public
    function AnyProblems: Boolean; override;
  end;

  TIBDatabaseSprig = class(TSprigAtRoot)
  public
    function AnyProblems: Boolean; override;
    function Caption: string; override;
  end;

  TIBTransactionSprig = class(TSprig)
  public
    function Caption: string; override;
    procedure FigureParent; override;
    function AnyProblems: Boolean; override;
    function DragDropTo(AItem: TSprig): Boolean; override;
    function DragOverTo(AItem: TSprig): Boolean; override;
    class function PaletteOverTo(AParent: TSprig; AClass: TClass): Boolean; override;
  end;

  TIBDatabaseInfoSprig = class(TSprig)
  public
    class function ParentProperty: string; override;
  end;

  TIBEventsSprig = class(TSprig)
  public
    class function ParentProperty: string; override;
    function AnyProblems: Boolean; override;
  end;

  TIBTransactionIsland = class(TIsland)
  public
    function VisibleTreeParent: Boolean; override;
  end;

  TIBSQLIsland = class(TIsland)
  public
    function VisibleTreeParent: Boolean; override;
  end;

  TIBCustomDataSetIsland = class(TDataSetIsland)
  public
    function VisibleTreeParent: Boolean; override;
  end;

  TIBTableIsland = class(TIBCustomDataSetIsland)
  end;

  TIBTableMasterDetailBridge = class(TMasterDetailBridge)
  public
    function CanEdit: Boolean; override;
    class function OmegaIslandClass: TIslandClass; override;
    class function GetOmegaSource(AItem: TPersistent): TDataSource; override;
    class procedure SetOmegaSource(AItem: TPersistent; ADataSource: TDataSource); override;
    function Caption: string; override;
    function Edit: Boolean; override;
  end;

  TIBQueryIsland = class(TIBCustomDataSetIsland)
  end;

  TIBQueryMasterDetailBridge = class(TMasterDetailBridge)
  public
    class function RemoveMasterFieldsAsWell: Boolean; override;
    class function OmegaIslandClass: TIslandClass; override;
    class function GetOmegaSource(AItem: TPersistent): TDataSource; override;
    class procedure SetOmegaSource(AItem: TPersistent; ADataSource: TDataSource); override;
    function Caption: string; override;
  end;}

procedure Register;

implementation

uses IB, IBQuery, IBStoredProc, IBUpdateSQL, IBCustomDataSet,
     IBIntf, IBSQL, IBSQLMonitor, IBDatabaseInfo, IBEvents,
     IBServices, IBInstall, IBDatabaseEdit, IBTransactionEdit,
     IBBatchMove, DBLogDlg;

procedure Register;
begin
  RegisterComponents(IBPalette1, [TIBTable, TIBQuery,
    TIBStoredProc, TIBDatabase, TIBTransaction, TIBUpdateSQL,
    TIBDataSet, TIBSQL, TIBDatabaseInfo, TIBSQLMonitor, TIBEvents]);
{$IFDEF IB6_ONLY}
  if (TryIBLoad) and (GetIBClientVersion >= 6) then
    RegisterComponents(IBPalette2, [TIBConfigService, TIBBackupService,
      TIBRestoreService, TIBValidationService, TIBStatisticalService,
      TIBLogService, TIBSecurityService, TIBServerProperties,
      TIBInstall, TIBUninstall]);
{$ENDIF}
  RegisterClasses([TIBStringField, TIBBCDField]);
  RegisterFields([TIBStringField, TIBBCDField]);
  RegisterPropertyEditor(TypeInfo(TIBFileName), TIBDatabase, 'DatabaseName', TIBFileNameProperty); {do not localize}
  RegisterPropertyEditor(TypeInfo(string), TIBStoredProc, 'StoredProcName', TIBStoredProcNameProperty); {do not localize}
//  RegisterPropertyEditor(TypeInfo(TParams), TIBStoredProc, 'Params', TIBStoredProcParamsProperty);
  RegisterPropertyEditor(TypeInfo(string), TIBTable, 'TableName', TIBTableNameProperty); {do not localize}
  RegisterPropertyEditor(TypeInfo(string), TIBTable, 'IndexName', TIBIndexNameProperty); {do not localize}
  RegisterPropertyEditor(TypeInfo(string), TIBTable, 'IndexFieldNames', TIBIndexFieldNamesProperty); {do not localize}
//  RegisterPropertyEditor(TypeInfo(string), TIBTable, 'MasterFields', TIBTableFieldLinkProperty); {do not localize}
//  RegisterPropertyEditor(TypeInfo(TStrings), TIBQuery, 'SQL', TIBQuerySQLProperty); {do not localize}
//  RegisterPropertyEditor(TypeInfo(TStrings), TIBDataSet, 'SelectSQL', TIBDatasetSQLProperty); {do not localize}
//  RegisterPropertyEditor(TypeInfo(TStrings), TIBSQL, 'SQL', TIBSQLProperty); {do not localize}
//  RegisterPropertyEditor(TypeInfo(TStrings), TIBEvents, 'Events', TIBEventListProperty); {do not localize}

  RegisterComponentEditor(TIBDatabase, TIBDatabaseEditor);
  RegisterComponentEditor(TIBTransaction, TIBTransactionEditor);
  RegisterComponentEditor(TIBUpdateSQL, TIBUpdateSQLEditor);
{  RegisterComponentEditor(TIBDataSet, TIBDataSetEditor);
  RegisterComponentEditor(TIBQuery, TIBQueryEditor);
  RegisterComponentEditor(TIBStoredProc, TIBStoredProcEditor);

  RegisterSprigType(TIBDatabase, TIBDatabaseSprig);
  RegisterSprigType(TIBTransaction, TIBTransactionSprig);

  RegisterSprigType(TIBDatabaseInfo, TIBDatabaseInfoSprig);
  RegisterSprigType(TIBEvents, TIBEventsSprig);
  RegisterSprigType(TIBSQL, TIBSQLSprig);

  RegisterSprigType(TIBUpdateSQL, TIBUpdateSQLSprig);

  RegisterSprigType(TIBCustomDataSet, TIBCustomDataSetSprig);
  RegisterSprigType(TIBQuery, TIBQuerySprig);
  RegisterSprigType(TIBTable, TIBTableSprig);
  RegisterSprigType(TIBStoredProc, TIBStoredProcSprig);

  RegisterIslandType(TIBTransactionSprig, TIBTransactionIsland);
  RegisterIslandType(TIBSQLSprig, TIBSQLIsland);
  RegisterIslandType(TIBCustomDataSetSprig, TIBCustomDataSetIsland);
  RegisterIslandType(TIBTableSprig, TIBTableIsland);
  RegisterIslandType(TIBQuerySprig, TIBQueryIsland);

  RegisterBridgeType(TDataSetIsland, TIBTableIsland, TIBTableMasterDetailBridge);
  RegisterBridgeType(TDataSetIsland, TIBQueryIsland, TIBQueryMasterDetailBridge);}
end;

{ TIBFileNameProperty }
procedure TIBFileNameProperty.Edit;
begin
  with TOpenDialog.Create(Application) do
    try
      InitialDir := ExtractFilePath(GetStrValue);
      Filter := 'Database Files|*.gdb'; {do not localize}
      if Execute then
        SetStrValue(FileName);
    finally
      Free
    end;
end;

function TIBFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{ TIBNameProperty }

function TIBNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

{ TIBStoredProcNameProperty }

procedure TIBStoredProcNameProperty.GetValues(Proc: TGetStrProc);
var
   StoredProc : TIBStoredProc;
   i : integer;
begin
    StoredProc := GetComponent(0) as TIBStoredProc;
    with StoredProc do
      for I := 0 to StoredProcedureNames.Count - 1 do
        Proc (StoredProcedureNames[i]);
end;

{ TIBTableNameProperty }

procedure TIBTableNameProperty.GetValues(Proc: TGetStrProc);
var
   TableName : TIBTable;
   i : integer;
begin
  TableName := GetComponent(0) as TIBTable;
  with TableName do
    for I := 0 to TableNames.Count - 1 do
      Proc (TableNames[i]);
end;

{ TDBStringProperty }

function TDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TDBStringProperty.GetValueList(List: TStrings);
begin
end;

procedure TDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

{ Utility Functions }

function GetPropertyValue(Instance: TPersistent; const PropName: string): TPersistent;
var
  PropInfo: PPropInfo;
begin
  Result := nil;
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, PropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
    Result := TObject(GetOrdProp(Instance, PropInfo)) as TPersistent;
end;

function GetIndexDefs(Component: TPersistent): TIndexDefs;
var
  DataSet: TDataSet;
begin
  DataSet := Component as TDataSet;
  Result := GetPropertyValue(DataSet, 'IndexDefs') as TIndexDefs; {do not localize}
  if Assigned(Result) then
  begin
    Result.Updated := False;
    Result.Update;
  end;
end;

{ TIBIndexFieldNamesProperty }

procedure TIBIndexFieldNamesProperty.GetValueList(List: TStrings);
var
  I: Integer;
  IndexDefs: TIndexDefs;
begin
  IndexDefs := GetIndexDefs(GetComponent(0));
  for I := 0 to IndexDefs.Count - 1 do
    with IndexDefs[I] do
      if (Options * [ixExpression, ixDescending] = []) and (Fields <> '') then
        List.Add(Fields);
end;


{ TIBIndexNameProperty }

procedure TIBIndexNameProperty.GetValueList(List: TStrings);
begin
  GetIndexDefs(GetComponent(0)).GetItemNames(List);
end;

{ TSQLPropertyEditor }

(*procedure TSQLPropertyEditor.EditSQL;
var
  SQLText: string;
  SQL: TStrings;
begin
  SQL := TStringList.Create;
  try
    SQL.Assign(TStrings(GetOrdValue));
    SQLText := SQL.Text;
    if (SQLEdit.EditSQL(SQLText, FGetTableNamesProc, FGetFieldNamesProc)) and
      (SQL.Text <> SQLText) then
    begin
      SQL.Text := SQLText;
      SetOrdValue(LongInt(SQL));
    end;
  finally
    SQL.free;
  end;
end;

function TSQLPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog] - [paSubProperties];
end;

{ TIBQuerySQLProperty }

procedure TIBQuerySQLProperty.Edit;
var
  Query: TIBQuery;
begin
  Query := TIBQuery(GetComponent(0));
  if Assigned(Query.Database) then
  begin
    FGetTableNamesProc := Query.Database.GetTableNames;
    FGetFieldNamesProc := Query.Database.GetFieldNames;
  end
  else
  begin
    FGetTableNamesProc := nil;
    FGetFieldNamesProc := nil;
  end;
  EditSQL;
end;

{ TIBDatasetSQLProperty }

procedure TIBDatasetSQLProperty.Edit;
var
  IBDataset: TIBDataset;
begin
  IBDataset := TIBDataset(GetComponent(0));
  if Assigned(IBDataSet.Database) then
  begin
    FGetTableNamesProc := IBDataset.Database.GetTableNames;
    FGetFieldNamesProc := IBDataset.Database.GetFieldNames;
  end
  else
  begin
    FGetTableNamesProc := nil;
    FGetFieldNamesProc := nil;
  end;
  EditSQL;
end;

{ TIBSQLProperty }

procedure TIBSQLProperty.Edit;
var
  IBSQL: TIBSQL;
begin
  IBSQL := TIBSQL(GetComponent(0));
  if Assigned(IBSQL.Database) then
  begin
    FGetTableNamesProc := IBSQL.Database.GetTableNames;
    FGetFieldNamesProc := IBSQL.Database.GetFieldNames;
  end
  else
  begin
    FGetTableNamesProc := nil;
    FGetFieldNamesProc := nil;
  end;
  EditSQL;
end;

*)
{ TIBUpdateSQLEditor }

procedure TIBUpdateSQLEditor.ExecuteVerb(Index: Integer);
begin
  if EditIBUpdateSQL(TIBUpdateSQL(Component)) then Designer.Modified;
end;

function TIBUpdateSQLEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0 : Result := SIBUpdateSQLEditor;
    1: Result := SInterbaseExpressVersion;
  end;
end;

function TIBUpdateSQLEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

(*
{ TIBDataSetEditor }

procedure TIBDataSetEditor.EditSQL;
var
  SQLText: string;
  SQL: TStrings;
begin
  SQL := TStringList.Create;
  try
    SQL.Assign(TIBDataset(Component).SelectSQL);
    SQLText := SQL.Text;
    if (SQLEdit.EditSQL(SQLText, FGetTableNamesProc, FGetFieldNamesProc)) and
      (SQL.Text <> SQLText) then
    begin
      SQL.Text := SQLText;
      TIBDataset(Component).SelectSQL.Assign(SQL);
    end;
  finally
    SQL.free;
  end;
end;

procedure TIBDataSetEditor.ExecuteVerb(Index: Integer);
var
  IBDataset: TIBDataset;
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    case Index of
      0:
        if EditIBDataSet(TIBDataSet(Component)) then
          Designer.Modified;
      1: (Component as TIBDataSet).ExecSQL;
      2:
      begin
        IBDataset := TIBDataset(Component);
        if Assigned(IBDataSet.Database) then
        begin
          FGetTableNamesProc := IBDataset.Database.GetTableNames;
          FGetFieldNamesProc := IBDataset.Database.GetFieldNames;
        end
        else
        begin
          FGetTableNamesProc := nil;
          FGetFieldNamesProc := nil;
        end;
        EditSQL;
      end;
    end;
  end;
end;

function TIBDataSetEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    case Index of
      0: Result := SIBDataSetEditor;
      1: Result := SExecute;
      2: Result := SEditSQL;
      3: Result := SInterbaseExpressVersion;
    end;
  end;
end;

function TIBDataSetEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 4;
end;

{ TIBEventListProperty }

function TIBEventListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog] - [paSubProperties];
end;

procedure TIBEventListProperty.Edit;
var
  Events: TStrings;
begin
  Events := TStringList.Create;
  try
    Events.Assign( TStrings(GetOrdValue));
    if EditAlerterEvents( Events) then SetOrdValue( longint(Events));
  finally
    Events.Free;
  end;
end;

*)
{ TIBDatabaseEditor }
procedure TIBDatabaseEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    case Index of
      0 : if EditIBDatabase(TIBDatabase(Component)) then Designer.Modified;
    end;
  end;
end;

function TIBDatabaseEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    case Index of
      0: Result := SIBDatabaseEditor;
//      1 : Result := SInterbaseExpressVersion;
    end;
  end;
end;

function TIBDatabaseEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 1;
end;


{ TIBTransactionEditor }

procedure TIBTransactionEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: if EditIBTransaction(TIBTransaction(Component)) then Designer.Modified;
  end;
end;

function TIBTransactionEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := SIBTransactionEditor;
//    1: Result := SInterbaseExpressVersion;
  end;
end;

function TIBTransactionEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

(*
{ TIBQueryEditor }

procedure TIBQueryEditor.EditSQL;
var
  SQLText: string;
  SQL: TStrings;
begin
  SQL := TStringList.Create;
  try
    SQL.Assign(TIBQuery(Component).SQL);
    SQLText := SQL.Text;
    if (SQLEdit.EditSQL(SQLText, FGetTableNamesProc, FGetFieldNamesProc)) and
      (SQL.Text <> SQLText) then
    begin
      SQL.Text := SQLText;
      TIBQuery(Component).SQL.Assign(SQL);
    end;
  finally
    SQL.free;
  end;
end;

procedure TIBQueryEditor.ExecuteVerb(Index: Integer);
var
  Query: TIBQuery;
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index) else
  begin
    Query := Component as TIBQuery;
    Dec(Index, inherited GetVerbCount);
    case Index of
      0: Query.ExecSQL;
      1:
      begin
        if Assigned(Query.Database) then
        begin
          FGetTableNamesProc := Query.Database.GetTableNames;
          FGetFieldNamesProc := Query.Database.GetFieldNames;
        end
        else
        begin
          FGetTableNamesProc := nil;
          FGetFieldNamesProc := nil;
        end;
        EditSQL;
      end;
    end;
  end;
end;

function TIBQueryEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    case Index of
      0: Result := SExecute;
      1: Result := SEditSQL;
      2: Result := SInterbaseExpressVersion;
    end;
  end;
end;

function TIBQueryEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 3;
end;

{ TIBStoredProcEditor }

procedure TIBStoredProcEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    if Index = 0 then (Component as TIBStoredProc).ExecProc;
  end;
end;

function TIBStoredProcEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index) else
  begin
    Dec(Index, inherited GetVerbCount);
    case Index of
      0: Result := SExecute;
      1: Result := SInterbaseExpressVersion;
    end;
  end;
end;

function TIBStoredProcEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 2;
end;

{ TIBStoredProcParamsProperty }

procedure TIBStoredProcParamsProperty.Edit;
var
  StoredProc: TIBStoredProc;
  Params: TParams;
begin
  StoredProc := (GetComponent(0) as TIBStoredProc);
  Params := TParams.Create(nil);
  try
    StoredProc.CopyParams(Params);
  finally
    Params.Free;
  end;
  inherited Edit;
end;

{ TIBTableFieldLinkProperty }

procedure TIBTableFieldLinkProperty.Edit;
begin
  FTable := DataSet as TIBTable;
  inherited Edit;
end;

function TIBTableFieldLinkProperty.GetIndexFieldNames: string;
begin
  Result := FTable.IndexFieldNames;
end;

function TIBTableFieldLinkProperty.GetMasterFields: string;
begin
  Result := FTable.MasterFields;
end;

procedure TIBTableFieldLinkProperty.SetIndexFieldNames(const Value: string);
begin
  FTable.IndexFieldNames := Value;
end;

procedure TIBTableFieldLinkProperty.SetMasterFields(const Value: string);
begin
  FTable.MasterFields := Value;
end;

{ TIBDatabaseSprig }

function TIBDatabaseSprig.AnyProblems: Boolean;
begin
  Result := (TIBDatabase(Item).DatabaseName = '') or
            (TIBDatabase(Item).DefaultTransaction = nil);
end;

function TIBDatabaseSprig.Caption: string;
begin
  Result := CaptionFor(TIBDatabase(Item).DatabaseName, UniqueName);
end;

{ TIBTransactionSprig }

function TIBTransactionSprig.AnyProblems: Boolean;
begin
  Result := TIBTransaction(Item).DefaultDatabase = nil;
end;

function TIBTransactionSprig.Caption: string;
begin
  if (TIBTransaction(Item).DefaultDatabase <> nil) and
     (TIBTransaction(Item).DefaultDatabase.DefaultTransaction = Item) then
    Result := CaptionFor(Format(SDefaultTransaction, [UniqueName]))
  else
    Result := inherited Caption;
end;

procedure TIBTransactionSprig.FigureParent;
begin
  SeekParent(TIBTransaction(Item).DefaultDatabase).Add(Self);
end;

function TIBTransactionSprig.DragDropTo(AItem: TSprig): Boolean;
begin
  Result := False;
  if AItem is TIBDatabaseSprig then
  begin
    Result := TIBDatabase(AItem.Item) <> TIBTransaction(Item).DefaultDatabase;
    if Result then
    begin
      TIBTransaction(Item).DefaultDatabase := TIBDatabase(AItem.Item);
      TIBDatabase(AItem.Item).DefaultTransaction := TIBTransaction(Item);
    end;
  end
end;

function TIBTransactionSprig.DragOverTo(AItem: TSprig): Boolean;
begin
  Result := (AItem is TIBDatabaseSprig);
end;

class function TIBTransactionSprig.PaletteOverTo(AParent: TSprig; AClass: TClass): Boolean;
begin
  Result := (AParent is TIBDatabaseSprig);
end;

{ support stuff for sprigs }

function IBAnyProblems(ATransaction: TIBTransaction; ADatabase: TIBDatabase): Boolean;
begin
  Result := (ATransaction = nil) or
            (ADatabase = nil) or
            (ATransaction.DefaultDatabase <> ADatabase);
end;

procedure IBFigureParent(ASprig: TSprig; ATransaction: TIBTransaction; ADatabase: TIBDatabase);
begin
  if ATransaction <> nil then
    ASprig.SeekParent(ATransaction).Add(ASprig)
  else if ADatabase <> nil then
    ASprig.SeekParent(ADatabase).Add(ASprig)
  else
    ASprig.Root.Add(ASprig);
end;

function IBDragOver(ASprig: TSprig): Boolean;
begin
  Result := (ASprig is TIBTransactionSprig) or
            (ASprig is TIBDatabaseSprig);
end;

function IBDropOver(AParent: TSprig; var ATransaction: TIBTransaction; var ADatabase: TIBDatabase): Boolean;
var
  vParentTransaction: TIBTransaction;
  vParentDatabase: TIBDatabase;
begin
  Result := False;
  if AParent is TIBTransactionSprig then
  begin
    vParentTransaction := TIBTransaction(AParent.Item);
    Result := vParentTransaction <> ATransaction;
    if Result then
      ATransaction := vParentTransaction;
    if (vParentTransaction.DefaultDatabase = nil) or
       (ADatabase <> vParentTransaction.DefaultDatabase) then
    begin
      Result := True;
      ADatabase := vParentTransaction.DefaultDatabase;
    end;
  end else if AParent is TIBDatabaseSprig then
  begin
    vParentDatabase := TIBDatabase(AParent.Item);
    Result := vParentDatabase <> ADatabase;
    if Result then
      ADatabase := vParentDatabase;
    if (vParentDatabase.DefaultTransaction = nil) or
       (ATransaction <> vParentDatabase.DefaultTransaction) then
    begin
      Result := True;
      ATransaction := vParentDatabase.DefaultTransaction;
    end;
  end;
end;

{ TIBSQLSprig }

function TIBSQLSprig.AnyProblems: Boolean;
begin
  Result := IBAnyProblems(TIBSQL(Item).Transaction,
                          TIBSQL(Item).Database) or
            (TIBSQL(Item).SQL.Count = 0);
end;

function TIBSQLSprig.DragDropTo(AItem: TSprig): Boolean;
var
  vTransaction: TIBTransaction;
  vDatabase: TIBDatabase;
begin
  with TIBSQL(Item) do
  begin
    vTransaction := Transaction;
    vDatabase := Database;
    Result := IBDropOver(AItem, vTransaction, vDatabase);
    if Result then
    begin
      Transaction := vTransaction;
      Database := vDatabase;
    end;
  end;
end;

function TIBSQLSprig.DragOverTo(AItem: TSprig): Boolean;
begin
  Result := IBDragOver(AItem);
end;

procedure TIBSQLSprig.FigureParent;
begin
  IBFigureParent(Self, TIBSQL(Item).Transaction,
                       TIBSQL(Item).Database);
end;

class function TIBSQLSprig.PaletteOverTo(AParent: TSprig; AClass: TClass): Boolean;
begin
  Result := IBDragOver(AParent);
end;

{ TIBCustomDataSetSprig }

function TIBCustomDataSetSprig.AnyProblems: Boolean;
begin
  Result := IBAnyProblems(TIBCustomDataSet(Item).Transaction,
                          TIBCustomDataSet(Item).Database);
end;

procedure TIBCustomDataSetSprig.FigureParent;
begin
  IBFigureParent(Self, TIBCustomDataSet(Item).Transaction,
                       TIBCustomDataSet(Item).Database);
end;

function TIBCustomDataSetSprig.DragDropTo(AItem: TSprig): Boolean;
var
  vTransaction: TIBTransaction;
  vDatabase: TIBDatabase;
begin
  with TIBCustomDataSet(Item) do
  begin
    vTransaction := Transaction;
    vDatabase := Database;
    Result := IBDropOver(AItem, vTransaction, vDatabase);
    if Result then
    begin
      Transaction := vTransaction;
      Database := vDatabase;
    end;
  end;
end;

function TIBCustomDataSetSprig.DragOverTo(AItem: TSprig): Boolean;
begin
  Result := IBDragOver(AItem);
end;

class function TIBCustomDataSetSprig.PaletteOverTo(AParent: TSprig; AClass: TClass): Boolean;
begin
  Result := IBDragOver(AParent);
end;

{ TIBStoredProcSprig }

function TIBStoredProcSprig.AnyProblems: Boolean;
begin
  Result := inherited AnyProblems or
            (TIBStoredProc(Item).StoredProcName = '');
end;

function TIBStoredProcSprig.Caption: string;
begin
  Result := CaptionFor(TIBStoredProc(Item).StoredProcName, UniqueName);
end;

{ TIBTableSprig }

function TIBTableSprig.AnyProblems: Boolean;
begin
  Result := inherited AnyProblems or
            (TIBTable(Item).TableName = '');
end;

function TIBTableSprig.Caption: string;
begin
  Result := CaptionFor(TIBTable(Item).TableName, UniqueName);
end;

{ TIBQuerySprig }

function TIBQuerySprig.AnyProblems: Boolean;
begin
  Result := inherited AnyProblems or
            (TIBQuery(Item).SQL.Count = 0);
end;

{ TIBDatabaseInfoSprig }

class function TIBDatabaseInfoSprig.ParentProperty: string;
begin
  Result := 'Database'; { do not localize }
end;

{ TIBUpdateSQLSprig }

function TIBUpdateSQLSprig.AnyProblems: Boolean;
begin
  with TIBUpdateSQL(Item) do
    Result := (ModifySQL.Count = 0) and
              (InsertSQL.Count = 0) and
              (DeleteSQL.Count = 0) and
              (RefreshSQL.Count = 0);
end;

{ TIBEventsSprig }

function TIBEventsSprig.AnyProblems: Boolean;
begin
  Result := inherited AnyProblems or
            (TIBEvents(Item).Events.Count = 0);
end;

class function TIBEventsSprig.ParentProperty: string;
begin
  Result := 'Database'; { do not localize }
end;

{ TIBTableMasterDetailBridge }

function TIBTableMasterDetailBridge.CanEdit: Boolean;
begin
  Result := True;
end;

function TIBTableMasterDetailBridge.Caption: string;
begin
  if TIBTable(Omega.Item).MasterFields = '' then
    Result := SNoMasterFields
  else
    Result := TIBTable(Omega.Item).MasterFields;
end;

function TIBTableMasterDetailBridge.Edit: Boolean;
var
  vPropEd: TIBTableFieldLinkProperty;
begin
  vPropEd := TIBTableFieldLinkProperty.CreateWith(TDataSet(Omega.Item));
  try
    vPropEd.Edit;
    Result := vPropEd.Changed;
  finally
    vPropEd.Free;
  end;
end;

class function TIBTableMasterDetailBridge.GetOmegaSource(
  AItem: TPersistent): TDataSource;
begin
  Result := TIBTable(AItem).MasterSource;
end;

class function TIBTableMasterDetailBridge.OmegaIslandClass: TIslandClass;
begin
  Result := TIBTableIsland;
end;

class procedure TIBTableMasterDetailBridge.SetOmegaSource(
  AItem: TPersistent; ADataSource: TDataSource);
begin
  TIBTable(AItem).MasterSource := ADataSource;
end;

{ TIBQueryMasterDetailBridge }

function TIBQueryMasterDetailBridge.Caption: string;
begin
  Result := SParamsFields;
end;

class function TIBQueryMasterDetailBridge.GetOmegaSource(
  AItem: TPersistent): TDataSource;
begin
  Result := TIBQuery(AItem).DataSource;
end;

class function TIBQueryMasterDetailBridge.OmegaIslandClass: TIslandClass;
begin
  Result := TIBQueryIsland;
end;

class function TIBQueryMasterDetailBridge.RemoveMasterFieldsAsWell: Boolean;
begin
  Result := False;
end;

class procedure TIBQueryMasterDetailBridge.SetOmegaSource(
  AItem: TPersistent; ADataSource: TDataSource);
begin
  TIBQuery(AItem).DataSource := ADataSource;
end;

{ TIBCustomDataSetIsland }

function TIBCustomDataSetIsland.VisibleTreeParent: Boolean;
begin
  Result := False;
end;

{ TIBSQLIsland }

function TIBSQLIsland.VisibleTreeParent: Boolean;
begin
  Result := False;
end;

{ TIBTransactionIsland }

function TIBTransactionIsland.VisibleTreeParent: Boolean;
begin
  Result := TIBTransaction(Sprig.Item).DefaultDatabase = nil;
end;*)

end.
