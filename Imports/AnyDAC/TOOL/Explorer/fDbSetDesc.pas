{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer class for set of RDBMS objects property page                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fDbSetDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Menus,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, ComCtrls, DBGrids, DB,
  daADStanOption, daADDatSManager, daADStanIntf, daADStanParam,
  daADDAptIntf,
  daADPhysIntf,
  daADCompClient, daADCompDataSet,
  daADGUIxFormsControls,
  fDbDesc, fExplorer;

type
  {---------------------------------------------------------------------------}
  TADDbSetNode = class(TADDbNode)
  private
    FObjTypeName: String;
    FNameField: String;
    FPushFields: String;
    FDataSQL: String;
    FExpandSQL: String;
    FObjTerminal: Boolean;
    FNodeFromMetaInfo: Boolean;
    FMetaInfoKind: TADPhysMetaInfoKind;
    FMetaTableKinds: TADPhysTableKinds;
    FMetaObjectScopes: TADPhysObjectScopes;
    FMetaCatalogName: String;
    FMetaSchemaName: String;
    FMetaBaseObjectName: String;
    FMetaObjectName: String;
    function ExtractMetaInfoName(var AStr: String): String;
    function ExtractParams(var AStr: String): String;
    procedure FormatError;
    procedure GetMetaInfo(AObjNode: TADExplorerNode);
    function Params2ObjectScopes(const AParams: String): TADPhysObjectScopes;
    procedure Params2SchemaParts(const AParams: String; AObjNode: TADExplorerNode;
      ADS: TDataSet; var ACatalog, ASchema, ABaseObj, AObj: String);
    function Params2TableKinds(const AParams: String): TADPhysTableKinds;
  public
    constructor Create(AObjNode: TADExplorerNode;
      const AObjTypeName: String; AObjTerminal: Boolean);
    function CreateExpander: TADExplorerNodeExpander; override;
    function CreateFrame: TFrame; override;
    property ObjTypeName: String read FObjTypeName;
    property NameField: String read FNameField;
    property PushFields: String read FPushFields;
    property DataSQL: String read FDataSQL;
    property ExpandSQL: String read FExpandSQL;
    property ObjTerminal: Boolean read FObjTerminal;
    property NodeFromMetaInfo: Boolean read FNodeFromMetaInfo;
    property MetaInfoKind: TADPhysMetaInfoKind read FMetaInfoKind;
    property MetaTableKinds: TADPhysTableKinds read FMetaTableKinds;
    property MetaObjectScopes: TADPhysObjectScopes read FMetaObjectScopes;
    property MetaCatalogName: String read FMetaCatalogName;
    property MetaSchemaName: String read FMetaSchemaName;
    property MetaBaseObjectName: String read FMetaBaseObjectName;
    property MetaObjectName: String read FMetaObjectName;
  end;

  {---------------------------------------------------------------------------}
  TADDbKnownSetNodeExpander = class(TADExplorerNodeExpander)
  private
    FQuery: TADQuery;
  public
    constructor Create(ANode: TADExplorerNode); override;
    destructor Destroy; override;
    function Next: TADExplorerNode; override;
  end;

  {---------------------------------------------------------------------------}
  TADDbUnknownSetNodeExpander = class(TADExplorerNodeExpander)
  private
    FMetaInfo: TADMetaInfoQuery;
  public
    constructor Create(ANode: TADExplorerNode); override;
    destructor Destroy; override;
    function Next: TADExplorerNode; override;
  end;

  {---------------------------------------------------------------------------}
  TfrmDbSetDesc = class(TfrmDbDesc)
    tsSummary: TTabSheet;
    qSummary: TADQuery;
    dsSummary: TDataSource;
    DBGrid1: TDBGrid;
    mqSummary: TADMetaInfoQuery;
    Panel8: TADGUIxFormsPanel;
    pnlSummarySubTitle: TADGUIxFormsPanel;
    procedure pcMainChange(Sender: TObject);
    procedure dbgDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadData; override;
  end;

var
  frmDbSetDesc: TfrmDbSetDesc;

implementation

{$R *.dfm}

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}
  IniFiles,
  daADStanUtil, daADStanConst,
  fDbObjDesc, fBaseDesc;

{-----------------------------------------------------------------------------}
{ TADDbSetNode                                                                }
{-----------------------------------------------------------------------------}
constructor TADDbSetNode.Create(AObjNode: TADExplorerNode;
  const AObjTypeName: String; AObjTerminal: Boolean);
var
  oDef: TIniFile;
  sSection, sVal, sName, sRDBMS, sHier: String;
  i: Integer;
begin
  inherited Create;
  FObjTypeName := AObjTypeName;
  FObjTerminal := AObjTerminal;
  oDef := TADDbObjNode(AObjNode).GetDef(sRDBMS, sHier);
  try
    sSection := sRDBMS + '.' + ObjTypeName;
    ObjectName := Trim(oDef.ReadString(sSection, 'SetName', FObjTypeName));
    FNameField := Trim(oDef.ReadString(sSection, 'ObjName', ''));
    FPushFields := Trim(oDef.ReadString(sSection, 'ObjPush', ''));
    FDataSQL := Trim(oDef.ReadString(sSection, 'ObjData', ''));
    sVal := Trim(oDef.ReadString(sSection, 'ImageIndex', '-1'));
    try
      FImageIndex := StrToInt(sVal);
    except
      FImageIndex := -1;
    end;
    FExpandSQL := '';
    i := 0;
    while True do begin
      sName := 'SQL';
      if i > 0 then
        sName := sName + IntToStr(i);
      sVal := Trim(oDef.ReadString(sSection, sName, ''));
      if sVal = '' then
        Break;
      FExpandSQL := FExpandSQL + sVal + C_AD_EOL;
      Inc(i);
    end;
    FNodeFromMetaInfo := (Copy(FExpandSQL, 1, 1) = '#');
    if FNodeFromMetaInfo then
      GetMetaInfo(AObjNode);
  finally
    oDef.Free;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TADDbSetNode.FormatError;
begin
  Exception.Create('Definition file format error encountered');
end;

{-----------------------------------------------------------------------------}
function TADDbSetNode.ExtractParams(var AStr: String): String;
var
  i1, i2: Integer;
begin
  i1 := Pos('[', AStr);
  i2 := Pos(']', AStr);
  if (i1 = 0) or (i2 = 0) then
    FormatError;
  Result := Trim(Copy(AStr, i1 + 1, i2 - i1 - 1));
  AStr := Copy(AStr, i2 + 1, Length(AStr));
end;

{-----------------------------------------------------------------------------}
function TADDbSetNode.ExtractMetaInfoName(var AStr: String): String;
var
  i: Integer;
begin
  i := Pos(',', AStr);
  if i = 0 then
    FormatError;
  Result := Copy(AStr, 2, i - 2);
end;

{-----------------------------------------------------------------------------}
procedure TADDbSetNode.Params2SchemaParts(const AParams: String;
  AObjNode: TADExplorerNode; ADS: TDataSet; var ACatalog, ASchema,
  ABaseObj, AObj: String);
var
  i, iItemNo: Integer;
  sItem, sVal: String;
  oStack: TStringList;
begin
  oStack := TStringList.Create;
  try
    TADDbNode(AObjNode).GetParamStack(oStack);
    i := 1;
    iItemNo := 0;
    while i <= Length(AParams) do begin
      Inc(iItemNo);
      sItem := Trim(ADExtractFieldName(AParams, i));
      if sItem <> '' then begin
        if ADS <> nil then
          sVal := VarToStr(ADS.FieldValues[sItem])
        else
          sVal := '';
        if sVal = '' then
          sVal := oStack.Values[sItem];
        case iItemNo of
        1: ACatalog := sVal;
        2: ASchema := sVal;
        3: ABaseObj := sVal;
        4: AObj := sVal;
        end;
      end;
    end;
  finally
    oStack.Free;
  end;
end;

{-----------------------------------------------------------------------------}
function TADDbSetNode.Params2ObjectScopes(const AParams: String): TADPhysObjectScopes;
var
  i: Integer;
  sScope: String;
begin
  i := 1;
  Result := [];
  while i <= Length(AParams) do begin
    sScope := Trim(ADExtractFieldName(AParams, i));
    if CompareText(sScope, 'osMy') = 0 then
      Include(Result, osMy)
    else if CompareText(sScope, 'osOther') = 0 then
      Include(Result, osOther)
    else if CompareText(sScope, 'osSystem') = 0 then
      Include(Result, osSystem)
    else
      FormatError;
  end;
end;

{-----------------------------------------------------------------------------}
function TADDbSetNode.Params2TableKinds(const AParams: String): TADPhysTableKinds;
var
  i: Integer;
  sTableKind: String;
begin
  i := 1;
  Result := [];
  while i <= Length(AParams) do begin
    sTableKind := Trim(ADExtractFieldName(AParams, i));
    if CompareText(sTableKind, 'tkSynonym') = 0 then
      Include(Result, tkSynonym)
    else if CompareText(sTableKind, 'tkTable') = 0 then
      Include(Result, tkTable)
    else if CompareText(sTableKind, 'tkView') = 0 then
      Include(Result, tkView)
    else if CompareText(sTableKind, 'tkTempTable') = 0 then
      Include(Result, tkTempTable)
    else if CompareText(sTableKind, 'tkLocalTable') = 0 then
      Include(Result, tkLocalTable)
    else
      FormatError;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TADDbSetNode.GetMetaInfo(AObjNode: TADExplorerNode);
var
  s, sMetaInfo: String;
begin
  s := FExpandSQL;
  sMetaInfo := ExtractMetaInfoName(s);
  if CompareText(sMetaInfo, 'mkTables') = 0 then begin
    FMetaInfoKind := mkTables;
    FMetaTableKinds := Params2TableKinds(ExtractParams(s));
    FMetaObjectScopes := Params2ObjectScopes(ExtractParams(s));
  end
  else if CompareText(sMetaInfo, 'mkProcs') = 0 then begin
    FMetaInfoKind := mkProcs;
    FMetaTableKinds := Params2TableKinds(ExtractParams(s));
    FMetaObjectScopes := Params2ObjectScopes(ExtractParams(s));
  end
  else if CompareText(sMetaInfo, 'mkTableFields') = 0 then begin
    FMetaInfoKind := mkTableFields;
    Params2SchemaParts(ExtractParams(s), AObjNode, nil, FMetaCatalogName,
      FMetaSchemaName, FMetaBaseObjectName, FMetaObjectName);
  end
  else if CompareText(sMetaInfo, 'mkIndexes') = 0 then begin
    FMetaInfoKind := mkIndexes;
    Params2SchemaParts(ExtractParams(s), AObjNode, nil, FMetaCatalogName,
      FMetaSchemaName, FMetaBaseObjectName, FMetaObjectName);
  end
  else if CompareText(sMetaInfo, 'mkIndexFields') = 0 then begin
    FMetaInfoKind := mkIndexFields;
    Params2SchemaParts(ExtractParams(s), AObjNode, nil, FMetaCatalogName,
      FMetaSchemaName, FMetaBaseObjectName, FMetaObjectName);
  end
  else if CompareText(sMetaInfo, 'mkPrimaryKey') = 0 then begin
    FMetaInfoKind := mkPrimaryKey;
    Params2SchemaParts(ExtractParams(s), AObjNode, nil, FMetaCatalogName,
      FMetaSchemaName, FMetaBaseObjectName, FMetaObjectName);
  end
  else if CompareText(sMetaInfo, 'mkPrimaryKeyFields') = 0 then begin
    FMetaInfoKind := mkPrimaryKeyFields;
    Params2SchemaParts(ExtractParams(s), AObjNode, nil, FMetaCatalogName,
      FMetaSchemaName, FMetaBaseObjectName, FMetaObjectName);
  end
  else if CompareText(sMetaInfo, 'mkProcArgs') = 0 then begin
    FMetaInfoKind := mkProcArgs;
    Params2SchemaParts(ExtractParams(s), AObjNode, nil, FMetaCatalogName,
      FMetaSchemaName, FMetaBaseObjectName, FMetaObjectName);
  end
  else
    FormatError;
end;

{-----------------------------------------------------------------------------}
function TADDbSetNode.CreateExpander: TADExplorerNodeExpander;
begin
  if FNodeFromMetaInfo then
    Result := TADDbUnknownSetNodeExpander.Create(Self)
  else
    Result := TADDbKnownSetNodeExpander.Create(Self);
end;

{-----------------------------------------------------------------------------}
function TADDbSetNode.CreateFrame: TFrame;
begin
  Result := TfrmDbSetDesc.Create(nil);
end;

{-----------------------------------------------------------------------------}
{ TADDbKnownSetNodeExpander                                                   }
{-----------------------------------------------------------------------------}
constructor TADDbKnownSetNodeExpander.Create(ANode: TADExplorerNode);
begin
  inherited Create(ANode);
  FQuery := TADQuery.Create(nil);
  FQuery.Connection := ANode.Connection;
  FQuery.SQL.Text := TADDbSetNode(ANode).ExpandSQL;
  FQuery.UpdateOptions.RequestLive := False;
  TADDbSetNode(ANode).SetQParams(FQuery);
  FQuery.Open;
end;

{-----------------------------------------------------------------------------}
destructor TADDbKnownSetNodeExpander.Destroy;
begin
  if FQuery <> nil then
    FQuery.Free;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
function TADDbKnownSetNodeExpander.Next: TADExplorerNode;
var
  s, sFlds, sNames, sFld, sName: String;
  i, i1, i2: Integer;
begin
  if not FQuery.Eof then begin
    Result := TADDbObjNode.Create;
    if Node.ImageIndex <> -1 then
      Result.ImageIndex := Node.ImageIndex + 1;
    with TADDbObjNode(Result) do begin

      s := TADDbSetNode(Node).NameField;
      i := Pos(':', s);
      sFlds := Copy(s, 1, i - 1);
      sNames := Copy(s, i + 1, Length(s));
      Result.ObjectName := FQuery.CreateExpression(sFlds).Evaluate;

      s := TADDbSetNode(Node).PushFields;
      i := Pos(':', s);
      sFlds := Copy(s, 1, i - 1);
      sNames := Copy(s, i + 1, Length(s));
      i1 := 1;
      i2 := 1;
      while (i1 <= Length(sFlds)) and (i1 <= Length(sNames)) do begin
        sFld := ADExtractFieldName(sFlds, i1);
        sName := ADExtractFieldName(sNames, i2);
        Params.Add(sName + '=' + VarToStr(FQuery.CreateExpression(sFld).Evaluate));
      end;

      for i := 0 to FQuery.FieldCount - 1 do
        with FQuery.Fields[i] do
          Props.Add(DisplayLabel + '=' + DisplayText);
    end;
    FQuery.Next;
  end
  else
    Result := nil;
end;

{-----------------------------------------------------------------------------}
{ TADDbUnknownSetNodeExpander                                                 }
{-----------------------------------------------------------------------------}
constructor TADDbUnknownSetNodeExpander.Create(ANode: TADExplorerNode);
var
  oConMeta: IADPhysConnectionMetadata;
  ch1, ch2: Char;

  function QuoteName(const AStr: string): String;
  begin
    Result := AStr;
    if (Result <> '') and (ch1 <> #0) then
      Result := ch1 + Result + ch2;
  end;

begin
  inherited Create(ANode);
  FMetaInfo := TADMetaInfoQuery.Create(nil);
  FMetaInfo.Connection := ANode.Connection;
  ANode.Connection.ConnectionIntf.CreateMetadata(oConMeta);
  ch1 := oConMeta.NameQuotaChar1;
  ch2 := oConMeta.NameQuotaChar2;
  FMetaInfo.MetaInfoKind := TADDbSetNode(ANode).MetaInfoKind;
  FMetaInfo.TableKinds := TADDbSetNode(ANode).MetaTableKinds;
  FMetaInfo.ObjectScopes := TADDbSetNode(ANode).MetaObjectScopes;
  FMetaInfo.CatalogName := QuoteName(TADDbSetNode(ANode).MetaCatalogName);
  FMetaInfo.SchemaName := QuoteName(TADDbSetNode(ANode).MetaSchemaName);
  FMetaInfo.BaseObjectName := QuoteName(TADDbSetNode(ANode).MetaBaseObjectName);
  FMetaInfo.ObjectName := QuoteName(TADDbSetNode(ANode).MetaObjectName);
  FMetaInfo.Open;
end;

{-----------------------------------------------------------------------------}
destructor TADDbUnknownSetNodeExpander.Destroy;
begin
  if FMetaInfo <> nil then
    FMetaInfo.Free;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
function TADDbUnknownSetNodeExpander.Next: TADExplorerNode;
var
  s, sFlds, sNames, sFld, sName, sFunc, sParams, sCatalog, sSchema, sBaseObj, sObj: String;
  i, i1, i2: Integer;
begin
  if not FMetaInfo.Eof then begin
    Result := TADDbObjNode.Create;
    if Node.ImageIndex <> -1 then
      Result.ImageIndex := Node.ImageIndex + 1;
    with TADDbObjNode(Result) do begin

      s := TADDbSetNode(Node).NameField;
      i := Pos(':', s);
      sFlds := Copy(s, 1, i - 1);
      sNames := Copy(s, i + 1, Length(s));
      if Copy(sFlds, 1, 1) = '#' then begin
        sFunc := TADDbSetNode(Node).ExtractMetaInfoName(sFlds);
        sParams := TADDbSetNode(Node).ExtractParams(sFlds);
        if CompareText(sFunc, 'full_name') = 0 then begin
          TADDbSetNode(Node).Params2SchemaParts(sParams, Node, FMetaInfo,
            sCatalog, sSchema, sBaseObj, sObj);
          Result.ObjectName := Node.Connection.EncodeObjectName(sCatalog, sSchema,
            sBaseObj, sObj);
          Params.Add('FULL_NAME=' + Result.ObjectName);
        end
        else
          TADDbSetNode(Node).FormatError;
      end
      else
        Result.ObjectName := VarToStr(FMetaInfo.FieldValues[sFlds]);

      s := TADDbSetNode(Node).PushFields;
      i := Pos(':', s);
      sFlds := Copy(s, 1, i - 1);
      sNames := Copy(s, i + 1, Length(s));
      i1 := 1;
      i2 := 1;
      while (i1 <= Length(sFlds)) and (i1 <= Length(sNames)) do begin
        sFld := ADExtractFieldName(sFlds, i1);
        sName := ADExtractFieldName(sNames, i2);
        if CompareText(sFld, 'FULL_NAME') <> 0 then
          Params.Add(sName + '=' + FMetaInfo.FieldByName(sFld).AsString);
      end;

      for i := 0 to FMetaInfo.FieldCount - 1 do
        with FMetaInfo.Fields[i] do
          Props.Add(DisplayLabel + '=' + DisplayText);
    end;
    FMetaInfo.Next;
  end
  else
    Result := nil;
end;

{-----------------------------------------------------------------------------}
{ TfrmDbSetDesc                                                               }
{-----------------------------------------------------------------------------}
procedure TfrmDbSetDesc.LoadData;
begin
  qSummary.Disconnect;
  mqSummary.Disconnect;
  if TADDbSetNode(ExplNode).NodeFromMetaInfo then begin
    mqSummary.Connection := ExplNode.Connection;
    mqSummary.MetaInfoKind := TADDbSetNode(ExplNode).MetaInfoKind;
    mqSummary.TableKinds := TADDbSetNode(ExplNode).MetaTableKinds;
    mqSummary.ObjectScopes := TADDbSetNode(ExplNode).MetaObjectScopes;
    mqSummary.CatalogName := TADDbSetNode(ExplNode).MetaCatalogName;
    mqSummary.SchemaName := TADDbSetNode(ExplNode).MetaSchemaName;
    mqSummary.BaseObjectName := TADDbSetNode(ExplNode).MetaBaseObjectName;
    mqSummary.ObjectName := TADDbSetNode(ExplNode).MetaObjectName;
    mqSummary.Open;
    dsSummary.DataSet := mqSummary;
  end
  else begin
    qSummary.Connection := ExplNode.Connection;
    qSummary.SQL.Text := TADDbSetNode(ExplNode).ExpandSQL;
    TADDbSetNode(ExplNode).SetQParams(qSummary);
    qSummary.Open;
    dsSummary.DataSet := qSummary;
  end;
  pcMain.ActivePage := tsSummary;
  inherited LoadData;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbSetDesc.pcMainChange(Sender: TObject);
begin
  inherited pcMainChange(Sender);
  if pcMain.ActivePage = tsSummary then
    SetDS(dsSummary);
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbSetDesc.dbgDblClick(Sender: TObject);
begin
  with ExplNode.Explorer.tvLeft.Selected do
  try
    Expand(False);
    with Item[dsSummary.DataSet.RecNo - 1] do begin
      Selected := True;
      Focused := True;
    end;
  except
    // silent
  end;
end;

end.
