{ --------------------------------------------------------------------------- }
{ AnyDAC TADQuery editor form                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfQEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, ComCtrls, Grids, DBGrids, DB, Buttons, CheckLst,
    ActnList, ImgList, Registry,
  daADGUIxFormsfOptsBase, daADGUIxFormsControls, daADGUIxFormsfResourceOptions,
    daADGUIxFormsfUpdateOptions, daADGUIxFormsfFormatOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfQBldr, daADGUIxFormsQBldr,
  daADDatSManager, daADStanIntf, daADStanOption, daADStanError, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient;

type
  TfrmADGUIxFormsQEdit = class(TfrmADGUIxFormsOptsBase)
    pcMain: TADGUIxFormsPageControl;
    tsSQL: TTabSheet;
    tsAdvOptions: TTabSheet;
    ptAdvOptions: TADGUIxFormsPanelTree;
    frmFetchOptions: TfrmADGUIxFormsFetchOptions;
    frmFormatOptions: TfrmADGUIxFormsFormatOptions;
    frmUpdateOptions: TfrmADGUIxFormsUpdateOptions;
    frmResourceOptions: TfrmADGUIxFormsResourceOptions;
    Panel2: TADGUIxFormsPanel;
    DataSource1: TDataSource;
    ADGUIxFormsPageControl2: TADGUIxFormsPageControl;
    tsRecordSet: TTabSheet;
    tsStructure: TTabSheet;
    Panel1: TADGUIxFormsPanel;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    tsMessages: TTabSheet;
    Panel4: TADGUIxFormsPanel;
    Panel5: TADGUIxFormsPanel;
    lvStructure: TListView;
    Panel8: TADGUIxFormsPanel;
    Panel9: TADGUIxFormsPanel;
    mmMessages: TMemo;
    tsParameters: TTabSheet;
    Panel14: TADGUIxFormsPanel;
    lbParams: TCheckListBox;
    Panel15: TADGUIxFormsPanel;
    Panel18: TADGUIxFormsPanel;
    Panel19: TADGUIxFormsPanel;
    tsMacros: TTabSheet;
    FQuery: TADQuery;
    alActions: TActionList;
    ilImages: TImageList;
    Panel6: TADGUIxFormsPanel;
    Panel13: TADGUIxFormsPanel;
    Panel10: TADGUIxFormsPanel;
    Panel12: TADGUIxFormsPanel;
    lbMacros: TListBox;
    pnlRight: TADGUIxFormsPanel;
    Panel16: TADGUIxFormsPanel;
    pnlRightTitle: TADGUIxFormsPanel;
    pnlRightTitleLine: TADGUIxFormsPanel;
    pnlRightContent: TADGUIxFormsPanel;
    btnExecute: TButton;
    btnNextRecordSet: TButton;
    cbRollback: TCheckBox;
    btnQBuilder: TButton;
    Panel3: TADGUIxFormsPanel;
    acNextRS: TAction;
    acQueryBuilder: TAction;
    QBldrEngine: TADGUIxFormsQBldrEngine;
    QBldrDialog: TADGUIxFormsQBldrDialog;
    acExecute: TAction;
    Label1: TLabel;
    BitBtn1: TButton;
    acUpdateSQLEditor: TAction;
    Image1: TImage;
    acCodeEditor: TAction;
    lvParametersAdv: TADGUIxFormsListView;
    lvParameters: TADGUIxFormsListView;
    lvMacros: TADGUIxFormsListView;
    cbOpen: TCheckBox;
    procedure mmSQLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbParamsClick(Sender: TObject);
    procedure lbParamsClickCheck(Sender: TObject);
    procedure lvParametersAdvExit(Sender: TObject);
    procedure lbMacrosClick(Sender: TObject);
    procedure lvParametersAfterEdit(Sender: TADGUIxFormsListView;
      AEditedIndex: Integer);
    procedure lvMacrosExit(Sender: TObject);
    procedure lvMacrosAfterEdit(Sender: TADGUIxFormsListView;
      AEditedIndex: Integer);
    procedure mmSQLChange(Sender: TObject);
    procedure acExecuteExec(Sender: TObject);
    procedure acNextRSExecute(Sender: TObject);
    procedure acNextRSUpdate(Sender: TObject);
    procedure acQueryBuilderExecute(Sender: TObject);
    procedure mmSQLExit(Sender: TObject);
    procedure acExecuteUpdate(Sender: TObject);
    procedure frmOptionsModified(Sender: TObject);
    procedure acUpdateSQLEditorUpdate(Sender: TObject);
    procedure acUpdateSQLEditorExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDefinitionChanged: Boolean;
    mmSQL: TADGUIxFormsMemo;
    procedure CMDialogKey(var AMessage: TCMDialogKey); message CM_DIALOGKEY;
    function IsInplaceEditing: Boolean;
    procedure LoadParameters(AIndex: Integer);
    procedure LoadParameter(AIndex: Integer);
    procedure SaveParameter(AIndex: Integer);
    procedure LoadMacros(AIndex: Integer);
    procedure LoadMacro(AIndex: Integer);
    procedure SaveMacros(AIndex: Integer);
    procedure ExecQuery;
    procedure NextRecordSet;
    procedure FillMessages(AMessages: EADDBEngineException);
    procedure FillStructure(ATable: TADDatSTable);
    function ShowQueryBuilder: Boolean;
    procedure UpdateQuery;
  protected
    procedure LoadFormState(AReg: TRegistry); override;
    procedure SaveFormState(AReg: TRegistry); override;
  public
    class function Execute(AQuery: TADCustomQuery; const ACaption: String): Boolean;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, 
{$ENDIF}
  Math, 
  daADStanConst, daADStanResStrs, daADStanUtil,
  daADGUIxFormsfUSEdit;

{$R *.dfm}

const
  C_ParamTypeNames: array [TParamType] of string =
    ('ptUnknown', 'ptInput', 'ptOutput', 'ptInputOutput', 'ptResult');

  C_FieldTypeNames: array [TFieldType] of string =
    ('ftUnknown', 'ftString', 'ftSmallInt', 'ftInteger', 'ftWord', 'ftBoolean',
     'ftFloat', 'ftCurrency', 'ftBCD', 'ftDate', 'ftTime', 'ftDateTime',
     'ftBytes', 'ftVarBytes', 'ftAutoInc', 'ftBlob', 'ftMemo', 'ftGraphic',
     'ftFmtMemo', 'ftParadoxOle', 'ftDBaseOle', 'ftTypedBinary', 'ftCursor',
     'ftFixedChar', 'ftWideString', 'ftLargeint', 'ftADT', 'ftArray', 'ftReference',
     'ftDataSet', 'ftOraBlob', 'ftOraClob', 'ftVariant', 'ftInterface', 'ftIDispatch',
     'ftGuid'
{$IFDEF AnyDAC_D6}
    , 'ftTimeStamp', 'ftFMTBcd'
  {$IFDEF AnyDAC_D10}
    ,'ftFixedWideChar', 'ftWideMemo', 'ftOraTimeStamp', 'ftOraInterval'
  {$ENDIF}
{$ENDIF}
    );

  C_FieldType2VarType: array[TFieldType] of Integer = (
    varError, varString, varSmallint, varInteger, varSmallint,
    varBoolean, varDouble, varCurrency, varCurrency, varDate, varDate, varDate,
    varString, varString, varInteger, varString, varString, varString, varOleStr,
    varString, varString, varString, varError, varString, varOleStr,
    varInt64, varError, varError, varError, varError, varString, varString,
    varVariant, varUnknown, varDispatch, varString
{$IFDEF AnyDAC_D6}
    , varString, varString
  {$IFDEF AnyDAC_D10}
    , varString, varString
    , varString, varString
  {$ENDIF}
{$ENDIF}
    );

  C_MacroDataType2VarType: array[TADMacroDataType] of Integer = (
    varError, varString, varString, varInteger, varBoolean, varDouble, varDate,
    varDate, varDate, varString);

  C_ADDataAttributeNames: array[TADDataAttribute] of string =
    ('Searchable', 'AllowNull', 'FixedLen', 'BlobData', 'ReadOnly', 'AutoInc',
     'ROWID', 'Default', 'RowVersion', 'Internal', 'Calculated', 'Volatile', 'Unnamed');

  C_ADParamArrayTypeNames: array[TADParamArrayType] of string =
    ('atScalar', 'atArray', 'atPLSQLTable');

  C_MacroTypeNames: array [TADMacroDataType] of string =
    ('mdUnknown', 'mdString', 'mdIdentifier', 'mdInteger',
     'mdBoolean', 'mdFloat', 'mdDate', 'mdTime', 'mdDateTime', 'mdRaw');

{ --------------------------------------------------------------------------- }
function GetStringValue(AValue: Variant): string;
var
  iVarType: Integer;
begin
  iVarType := VarType(AValue);
  if iVarType = varEmpty then
    Result := '<unassigned>'
  else if iVarType = varNull then
    Result := '<null>'
  else
    Result := VarToStr(AValue);
end;

{ --------------------------------------------------------------------------- }
function GetVariantValue(AVarType: Integer; const AValue: string): Variant;
begin
  if AVarType <> varError then begin
    if AValue = '<unassigned>' then
      Result := Unassigned
    else if AValue = '<null>' then
      Result := Null
    else
      VarCast(Result, AValue, AVarType);
  end
  else
    Result := Null;
end;

{ --------------------------------------------------------------------------- }
{ TfrmADGUIxFormsQEdit                                                        }
{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQEdit.FormCreate(Sender: TObject);
begin
  mmSQL := TADGUIxFormsMemo.Create(Self);
  with mmSQL do begin
    Parent := Panel2;
    Align := alClient;
    BevelInner := bvSpace;
    BevelKind := bkFlat;
    BorderStyle := bsNone;
    ScrollBars := ssBoth;
    TabOrder := 0;
    WordWrap := False;
    OnChange := mmSQLChange;
    OnExit := mmSQLExit;
    OnKeyDown := mmSQLKeyDown;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TfrmADGUIxFormsQEdit.Execute(AQuery: TADCustomQuery;
  const ACaption: String): Boolean;
var
  oFrm: TfrmADGUIxFormsQEdit;
begin
  oFrm := TfrmADGUIxFormsQEdit.Create(nil);
  with oFrm do
  try
    LoadState;
    Caption := Format(S_AD_QEditCaption, [ACaption]);
    // SQL
    FQuery.SQL.Assign(AQuery.SQL);
    mmSQL.Lines.Assign(AQuery.SQL);
    FDefinitionChanged := False;
    // Parameters
    FQuery.Params.Assign(TADQuery(AQuery).Params);
    LoadParameters(0);
    // Macroses
    FQuery.Macros.Assign(TADQuery(AQuery).Macros);
    LoadMacros(0);
    // Load options
    frmFetchOptions.LoadFrom(TADQuery(AQuery).FetchOptions);
    frmUpdateOptions.LoadFrom(TADQuery(AQuery).UpdateOptions);
    frmFormatOptions.LoadFrom(TADQuery(AQuery).FormatOptions);
    frmResourceOptions.LoadFrom(TADQuery(AQuery).ResourceOptions);
    // Referenced objects
    FQuery.ConnectionName := AQuery.ConnectionName;
    FQuery.Connection := AQuery.Connection;
    pcMain.ActivePageIndex := 0;
    FQuery.UpdateObject := TADQuery(AQuery).UpdateObject;
    try
      Result := ShowModal = mrOK;
    finally
      TADQuery(AQuery).UpdateObject := FQuery.UpdateObject;
    end;
    if Result then begin
      // SQL
      UpdateQuery;
      AQuery.SQL.Assign(FQuery.SQL);
      // Parameters
      TADQuery(AQuery).Params.Assign(FQuery.Params);
      // Macroses
      TADQuery(AQuery).Macros.Assign(FQuery.Macros);
      // Save options
      frmFetchOptions.SaveTo(TADQuery(AQuery).FetchOptions);
      frmUpdateOptions.SaveTo(TADQuery(AQuery).UpdateOptions);
      frmFormatOptions.SaveTo(TADQuery(AQuery).FormatOptions);
      frmResourceOptions.SaveTo(TADQuery(AQuery).ResourceOptions);
    end;
    SaveState;
  finally
    Free;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.LoadFormState(AReg: TRegistry);
begin
  inherited LoadFormState(AReg);
  ADGUIxFormsPageControl2.Height := AReg.ReadInteger('Spliter');
  ptAdvOptions.LoadState(AReg);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.SaveFormState(AReg: TRegistry);
begin
  inherited SaveFormState(AReg);
  AReg.WriteInteger('Spliter', ADGUIxFormsPageControl2.Height);
  ptAdvOptions.SaveState(AReg);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.CMDialogKey(var AMessage: TCMDialogKey);
begin
  if (AMessage.CharCode in [VK_RETURN, VK_ESCAPE]) and IsInplaceEditing then begin
    // emulation of pressing Alt to avoid 'Cancel' and 'Ok' button click
    AMessage.KeyData := AMessage.KeyData or $20000000;
  end;
  inherited;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsQEdit.IsInplaceEditing: Boolean;
begin
  Result := lvParameters.IsEditing or lvParametersAdv.IsEditing or lvMacros.IsEditing;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.LoadParameters(AIndex: Integer);
var
  i: Integer;
begin
  lbParams.Items.BeginUpdate;
  try
    lbParams.Items.Clear;
    for i := 0 to FQuery.Params.Count - 1 do begin
      lbParams.Items.Add(FQuery.Params[i].Name);
      lbParams.Checked[i] := FQuery.Params[i].Active;
    end;
    if AIndex > -1 then begin
      if AIndex < lbParams.Items.Count then
        lbParams.ItemIndex := AIndex
      else
        lbParams.ItemIndex := lbParams.Items.Count - 1;
    end
    else if lbParams.Items.Count > 0 then
      lbParams.ItemIndex := 0
    else
      lbParams.ItemIndex := -1;
    lbParamsClick(nil);
  finally
    lbParams.Items.EndUpdate;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.LoadParameter(AIndex: Integer);
var
  ePT: TParamType;
  eFT: TFieldType;
  eDT: TADDataType;
  eAT: TADParamArrayType;
  oList: TStrings;
  oParam: TADParam;
begin
  if AIndex >= 0 then begin
    oList := TStringList.Create;
    try
      oParam := FQuery.Params[AIndex];
      with lvParameters do begin
        Items.BeginUpdate;
        try
          Items.Clear;
          // Name
          AddValue('Name', oParam.Name);
          // ParamType
          oList.Clear;
          for ePT := Low(TParamType) to High(TParamType) do
            oList.Add(C_ParamTypeNames[ePT]);
          AddValues('ParamType', oList, Integer(oParam.ParamType));
          // DataType
          oList.Clear;
          for eFT := Low(TFieldType) to High(TFieldType) do
            oList.Add(C_FieldTypeNames[eFT]);
          AddValues('DataType', oList, Integer(oParam.DataType));
          // Size
          AddIntegerValue('Size', oParam.Size);
          // Value
          AddValue('Value', GetStringValue(oParam.Value));
        finally
          Items.EndUpdate;
        end;
      end;
      with lvParametersAdv do begin
        Items.BeginUpdate;
        try
          Items.Clear;
          // IsCaseSensitive
          AddBooleanValue('IsCaseSensitive', oParam.IsCaseSensitive);
          // Position
          AddIntegerValue('Position', oParam.Position);
          // ADDataType
          oList.Clear;
          for eDT := Low(TADDataType) to High(TADDataType) do
            oList.Add('dt' + C_AD_DataTypeNames[eDT]);
          AddValues('ADDataType', oList, Integer(oParam.ADDataType));
          // Precision
          AddIntegerValue('Precision', oParam.Precision);
          // NumericScale
          AddIntegerValue('NumericScale', oParam.NumericScale);
          // ArrayType
          oList.Clear;
          for eAT := Low(TADParamArrayType) to High(TADParamArrayType) do
            oList.Add(C_ADParamArrayTypeNames[eAT]);
          AddValues('ArrayType', oList, Integer(oParam.ArrayType));
          // ArraySize
          AddIntegerValue('ArraySize', oParam.ArraySize);
        finally
          Items.EndUpdate;
        end;
      end;
    finally
      oList.Free;
    end;
  end
  else begin
    lvParameters.Items.Clear;
    lvParametersAdv.Items.Clear;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.SaveParameter(AIndex: Integer);
var
  oParam: TADParam;
  s: String;
begin
  if AIndex >= 0 then begin
    oParam := FQuery.Params[AIndex];
    // Name
    oParam.Name := lvParameters.Value['Name'];
    // IsCaseSensitive
    s := lvParametersAdv.Value['IsCaseSensitive'];
    oParam.IsCaseSensitive := (s <> '') and (s[1] in ['t', 'T', 'y', 'Y']);
    // ParamType
    oParam.ParamType := TParamType(lvParameters.ValueIndex['ParamType']);
    // Position
    oParam.Position := StrToInt(lvParametersAdv.Value['Position']);
    // DataType
    oParam.DataType := TFieldType(lvParameters.ValueIndex['DataType']);
    // ADDataType
    oParam.ADDataType := TADDataType(lvParametersAdv.ValueIndex['ADDataType']);
    // Size
    oParam.Size := StrToInt(lvParameters.Value['Size']);
    // Precision
    oParam.Precision := StrToInt(lvParametersAdv.Value['Precision']);
    // NumericScale
    oParam.NumericScale := StrToInt(lvParametersAdv.Value['NumericScale']);
    // ArrayType
    oParam.ArrayType := TADParamArrayType(lvParametersAdv.ValueIndex['ArrayType']);
    // ArraySize
    oParam.ArraySize := StrToInt(lvParametersAdv.Value['ArraySize']);
    // Value
    oParam.Value := GetVariantValue(C_FieldType2VarType[oParam.DataType], lvParameters.Value['Value']);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.LoadMacros(AIndex: Integer);
var
  i: Integer;
begin
  lbMacros.Items.BeginUpdate;
  try
    lbMacros.Items.Clear;
    for i := 0 to FQuery.Macros.Count - 1 do
      lbMacros.Items.Add(FQuery.Macros[i].Name);
    if AIndex > -1 then begin
      if AIndex < lbMacros.Items.Count then
        lbMacros.ItemIndex := AIndex
      else
        lbMacros.ItemIndex := lbMacros.Items.Count - 1;
    end
    else if lbMacros.Items.Count > 0 then
      lbMacros.ItemIndex := 0
    else
      lbMacros.ItemIndex := -1;
    lbMacrosClick(nil);
  finally
    lbMacros.Items.EndUpdate;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.LoadMacro(AIndex: Integer);
var
  eMT: TADMacroDataType;
  oList: TStrings;
  oMacro: TADMacro;
begin
  if AIndex >= 0 then
    with lvMacros do begin
      Items.BeginUpdate;
      try
        Items.Clear;
        if AIndex >= 0 then begin
          oList := TStringList.Create;
          try
            oMacro := FQuery.Macros[AIndex];
            // Name
            AddValue('Name', oMacro.Name);
            // DataType
            oList.Clear;
            for eMT := Low(TADMacroDataType) to High(TADMacroDataType) do
              oList.Add(C_MacroTypeNames[eMT]);
            AddValues('DataType', oList, Integer(oMacro.DataType));
            // Value
            AddValue('Value', GetStringValue(oMacro.Value));
          finally
            oList.Free;
          end;
        end;
      finally
        Items.EndUpdate;
      end;
    end
  else
    lvMacros.Items.Clear;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.SaveMacros(AIndex: Integer);
var
  oMacro: TADMacro;
begin
  if AIndex >= 0 then begin
    oMacro := FQuery.Macros[AIndex];
    // Name
    oMacro.Name := lvMacros.Value['Name'];
    // DataType
    oMacro.DataType := TADMacroDataType(lvMacros.ValueIndex['DataType']);
    // Value
    oMacro.Value := GetVariantValue(C_MacroDataType2VarType[oMacro.DataType], lvMacros.Value['Value']);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.UpdateQuery;
begin
  if FDefinitionChanged then begin
    FDefinitionChanged := False;
    FQuery.SQL.Assign(mmSQL.Lines);
    LoadParameters(lbParams.ItemIndex);
    LoadMacros(lbMacros.ItemIndex);
    frmFetchOptions.SaveTo(FQuery.FetchOptions);
    frmUpdateOptions.SaveTo(FQuery.UpdateOptions);
    frmFormatOptions.SaveTo(FQuery.FormatOptions);
    frmResourceOptions.SaveTo(FQuery.ResourceOptions);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.ExecQuery;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  FQuery.DisableControls;
  try
    UpdateQuery;
    FQuery.Active := False;
    SaveParameter(lbParams.ItemIndex);
    SaveMacros(lbMacros.ItemIndex);
    FQuery.Prepare;
    FQuery.Connection.ConnectionIntf.CreateMetadata(oConnMeta);
    if cbRollback.Checked and oConnMeta.TxSupported then
      FQuery.Connection.StartTransaction;
    try
      if (FQuery.Command.CommandKind in [skSelect, skSelectForUpdate, skStoredProcWithCrs]) or
         cbOpen.Checked then
        FQuery.Open
      else
        FQuery.ExecSQL;
    finally
      FillStructure(FQuery.Table);
      FillMessages(FQuery.Connection.ConnectionIntf.Messages);
      if cbRollback.Checked and oConnMeta.TxSupported then
        FQuery.Connection.Rollback;
    end;
  finally
    FQuery.EnableControls;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.NextRecordSet;
begin
  FQuery.DisableControls;
  try
    FQuery.NextRecordSet;
  finally
    FillStructure(FQuery.Table);
    FillMessages(FQuery.Connection.ConnectionIntf.Messages);
    FQuery.EnableControls;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.FillMessages(AMessages: EADDBEngineException);
var
  i: Integer;
begin
  mmMessages.Lines.BeginUpdate;
  try
    mmMessages.Lines.Clear;
    if AMessages <> nil then begin
      for i := 0 to AMessages.ErrorCount - 1 do
        mmMessages.Lines.Add(AMessages.Errors[i].Message);
    end;
  finally
    mmMessages.Lines.EndUpdate;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.FillStructure(ATable: TADDatSTable);
var
  i: Integer;
  sTmp: string;
  eAttribute: TADDataAttribute;
  oColumn: TADDatSColumn;
begin
  lvStructure.Items.BeginUpdate;
  try
    lvStructure.Items.Clear;
    if ATable <> nil then begin
      for i := 0 to ATable.Columns.Count - 1 do begin
        oColumn := ATable.Columns.ItemsI[i];
        with lvStructure.Items.Add do begin
          Caption := oColumn.Name;

          sTmp := C_AD_DataTypeNames[oColumn.DataType];
          if oColumn.DataType in [dtDouble, dtCurrency, dtBCD, dtFmtBCD] then
            if oColumn.Precision = 0 then
              sTmp := sTmp + Format('(*, %d)', [oColumn.Scale])
            else
              sTmp := sTmp + Format('(%d, %d)', [oColumn.Precision, oColumn.Scale])
          else if oColumn.DataType in [dtAnsiString, dtWideString, dtByteString] then
            sTmp := sTmp + Format('(%d)', [oColumn.Size]);
          SubItems.Add(sTmp);
          sTmp := '';
          for eAttribute := Low(TADDataAttribute) to High(TADDataAttribute) do
            if eAttribute in oColumn.Attributes then
              sTmp := sTmp + C_ADDataAttributeNames[eAttribute] + '; ';
          if sTmp <> '' then
            SetLength(sTmp, Length(sTmp) - 2);
          SubItems.Add(sTmp);
          SubItems.Add(oColumn.OriginName);
          SubItems.Add(oColumn.SourceDataTypeName);
        end;
      end;
    end;
  finally
    lvStructure.Items.EndUpdate;
  end;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsQEdit.ShowQueryBuilder: Boolean;
begin
  QBldrEngine.ConnectionName := FQuery.ConnectionName;
  QBldrEngine.Connection := FQuery.Connection;
  if (QBldrEngine.Connection <> nil) or (QBldrEngine.ConnectionName <> '') then
    QBldrDialog.ShowButtons := QBldrDialog.ShowButtons - [bbSelectConnDialog];
  if FQuery.ConnectionName <> '' then
    QBldrDialog.InfoCaption1 := FQuery.ConnectionName
  else if FQuery.Connection <> nil then begin
    if FQuery.Connection.ConnectionName <> '' then
      QBldrDialog.InfoCaption1 := FQuery.Connection.ConnectionName
    else if FQuery.Connection.ConnectionDefName <> '' then
      QBldrDialog.InfoCaption1 := FQuery.Connection.ConnectionDefName
    else
      QBldrDialog.InfoCaption1 := FQuery.Connection.Name;
  end;
  QBldrDialog.SQL.Assign(mmSQL.Lines);
  Result := QBldrDialog.Execute;
  if Result then begin
    mmSQL.Lines.Assign(QBldrDialog.SQL);
    FDefinitionChanged := True;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lbParamsClick(Sender: TObject);
begin
  LoadParameter(lbParams.ItemIndex);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lbParamsClickCheck(Sender: TObject);
begin
  FQuery.Params[lbParams.ItemIndex].Active := lbParams.Checked[lbParams.ItemIndex];
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lvParametersAdvExit(Sender: TObject);
begin
  SaveParameter(lbParams.ItemIndex);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lbMacrosClick(Sender: TObject);
begin
  LoadMacro(lbMacros.ItemIndex);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lvParametersAfterEdit(
  Sender: TADGUIxFormsListView; AEditedIndex: Integer);
begin
  if AEditedIndex = 0 then
    lbParams.Items[lbParams.ItemIndex] := lvParameters.Value['Name'];
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lvMacrosExit(Sender: TObject);
begin
  SaveMacros(lbMacros.ItemIndex);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.lvMacrosAfterEdit(
  Sender: TADGUIxFormsListView; AEditedIndex: Integer);
begin
  if AEditedIndex = 0 then
    lbMacros.Items[lbMacros.ItemIndex] := lvMacros.Value['Name'];
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.mmSQLChange(Sender: TObject);
begin
  FDefinitionChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.frmOptionsModified(Sender: TObject);
begin
  FDefinitionChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.mmSQLExit(Sender: TObject);
begin
  UpdateQuery;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.mmSQLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and ((Key = Ord('A')) or (Key = Ord('a'))) then begin
    mmSQL.SelectAll;
    Key := 0;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acExecuteUpdate(Sender: TObject);
begin
  acExecute.Enabled := mmSQL.Lines.Count > 0;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acExecuteExec(Sender: TObject);
begin
  ExecQuery;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acNextRSUpdate(Sender: TObject);
begin
  acNextRS.Enabled := FQuery.Active;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acNextRSExecute(Sender: TObject);
begin
  NextRecordSet;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acQueryBuilderExecute(Sender: TObject);
begin
  if ShowQueryBuilder then begin
    FQuery.Close;
    pcMain.ActivePage := tsSQL;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acUpdateSQLEditorUpdate(Sender: TObject);
begin
  acUpdateSQLEditor.Enabled := (FQuery.UpdateObject <> nil) and
    (FQuery.UpdateObject is TADUpdateSQL);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsQEdit.acUpdateSQLEditorExecute(Sender: TObject);
begin
  TfrmADGUIxFormsUSEdit.Execute(TADUpdateSQL(FQuery.UpdateObject),
    FQuery.UpdateObject.Name);
end;

end.
