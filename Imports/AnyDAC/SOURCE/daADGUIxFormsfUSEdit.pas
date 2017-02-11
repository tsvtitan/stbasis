{ --------------------------------------------------------------------------- }
{ AnyDAC TADUpdateSQL editor form                                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfUSEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, ComCtrls, StdCtrls,
    ExtCtrls, Controls,
  daADStanIntf, daADStanOption,
  daADCompClient,
  daADGUIxFormsfOptsBase, daADGUIxFormsfUpdateOptions, daADGUIxFormsControls;

type
  TfrmADGUIxFormsUSEdit = class(TfrmADGUIxFormsOptsBase)
    pcMain: TADGUIxFormsPageControl;
    tsOptions: TTabSheet;
    Label1: TLabel;
    cbxTableName: TComboBox;
    btnDSDefaults: TButton;
    btnGenSQL: TButton;
    btnServerInfo: TButton;
    GroupBox2: TLabel;
    lbKeyFields: TListBox;
    GroupBox3: TLabel;
    lbUpdateFields: TListBox;
    GroupBox4: TLabel;
    lbRefetchFields: TListBox;
    tsSQL: TTabSheet;
    Panel1: TADGUIxFormsPanel;
    tcSQLKind: TADGUIxFormsTabControl;
    tsAdvanced: TTabSheet;
    ptreeAdvanced: TADGUIxFormsPanelTree;
    GroupBox5: TADGUIxFormsPanel;
    cbQuoteTabName: TCheckBox;
    cbQuoteColName: TCheckBox;
    frmUpdateOptions: TfrmADGUIxFormsUpdateOptions;
    Image1: TImage;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    procedure cbxTableNameDropDown(Sender: TObject);
    procedure btnServerInfoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDSDefaultsClick(Sender: TObject);
    procedure btnGenSQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgSQLKindClick(Sender: TObject);
    procedure mmSQLExit(Sender: TObject);
    procedure cbxTableNameChange(Sender: TObject);
    procedure cbxTableNameClick(Sender: TObject);
  private
    { Private declarations }
    mmSQL: TADGUIxFormsMemo;
    FConnection: TADCustomConnection;
    FDataSet: TADAdaptedDataSet;
    FUpdateSQL: TADUpdateSQL;
    FUpdOpts: TADUpdateOptions;
    FSQLs: array [0 .. 5] of TStringList;
    FLastSQLKind: Integer;
    procedure UpdateExistSQLs;
    procedure GenCommands;
  public
    { Public declarations }
    class function Execute(AUpdSQL: TADUpdateSQL; const ACaption: String): Boolean;
  end;

var
  frmADGUIxFormsUSEdit: TfrmADGUIxFormsUSEdit;

implementation

{$R *.dfm}

uses
  DB, 
  daADStanResStrs,
  daADDatSManager,
  daADPhysIntf;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  mmSQL := TADGUIxFormsMemo.Create(Self);
  with mmSQL do begin
    Parent := Panel1;
    Align := alClient;
    BevelInner := bvSpace;
    BevelKind := bkFlat;
    BorderStyle := bsNone;
    Color := clInfoBk;
    Ctl3D := True;
    ParentCtl3D := False;
    TabOrder := 1;
    OnExit := mmSQLExit;
  end;
  for i := 0 to 5 do
    FSQLs[i] := TStringList.Create;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FreeAndNil(FUpdOpts);
  for i := 0 to 5 do
    FSQLs[i].Free;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameDropDown(Sender: TObject);
begin
  cbxTableName.Perform(CB_SETDROPPEDWIDTH, Width div 2, 0);
  if cbxTableName.Items.Count = 0 then
    try
      FConnection.GetTableNames('', '', '', cbxTableName.Items, [osMy]);
    except
      cbxTableName.DroppedDown := False;
      raise;
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameChange(Sender: TObject);
begin
  btnGenSQL.Enabled := (cbxTableName.Text <> '');
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameClick(Sender: TObject);
begin
  btnServerInfoClick(nil);
  btnDSDefaultsClick(nil);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.btnServerInfoClick(Sender: TObject);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  sName: String;
  eAttrs: TADDataAttributes;
  i, j: Integer;
begin
  FConnection.ConnectionIntf.CreateMetadata(oConnMeta);
  oView := oConnMeta.GetTableFields('', '', cbxTableName.Text, '');
  try
    lbKeyFields.Items.Clear;
    lbUpdateFields.Items.Clear;
    lbRefetchFields.Items.Clear;
    for i := 0 to oView.Rows.Count - 1 do begin
      sName := oView.Rows[i].GetData('COLUMN_NAME');
      if sName = '' then
        sName := '_' + IntToStr(lbKeyFields.Items.Count);
      lbKeyFields.Items.Add(sName);
      lbUpdateFields.Items.Add(sName);
      lbRefetchFields.Items.Add(sName);
    end;
    for i := 0 to oView.Rows.Count - 1 do begin
      sName := oView.Rows[i].GetData('COLUMN_NAME');
      j := oView.Rows[i].GetData('COLUMN_ATTRIBUTES');
      eAttrs := TADDataAttributes(Pointer(@J)^);
      if (sName <> '') and (eAttrs * [caCalculated, caInternal, caUnnamed] = []) then
        lbUpdateFields.Selected[i] := True;
      if eAttrs * [caAutoInc, caROWID, caDefault, caRowVersion, caCalculated, caVolatile] <> [] then
        lbRefetchFields.Selected[i] := True;
    end;
  finally
    oView.Free;
  end;
  oView := oConnMeta.GetTablePrimaryKeyFields('', '', cbxTableName.Text, '');
  try
    for i := 0 to oView.Rows.Count - 1 do begin
      sName := oView.Rows[i].GetData('COLUMN_NAME');
      j := lbKeyFields.Items.IndexOf(sName);
      if j <> -1 then
        lbKeyFields.Selected[j] := True;
    end;
  finally
    oView.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.btnDSDefaultsClick(Sender: TObject);
var
  i, j: Integer;
  oFld: TField;
  sFldName: String;
begin
  if FDataSet = nil then
    Exit;
  for i := 0 to lbKeyFields.Items.Count - 1 do
    lbKeyFields.Selected[i] := False;
  for i := 0 to lbUpdateFields.Items.Count - 1 do
    lbUpdateFields.Selected[i] := False;
  for i := 0 to lbRefetchFields.Items.Count - 1 do
    lbRefetchFields.Selected[i] := False;
  for i := 0 to FDataSet.Fields.Count - 1 do begin
    oFld := FDataSet.Fields[i];
    if oFld.Origin = '' then
      sFldName := oFld.FieldName
    else
      sFldName := oFld.Origin;
    j := lbKeyFields.Items.IndexOf(sFldName);
    if j <> -1 then begin
      lbKeyFields.Selected[j] := pfInKey in oFld.ProviderFlags;
      lbUpdateFields.Selected[j] := pfInUpdate in oFld.ProviderFlags;
      lbRefetchFields.Selected[j] := (oFld.AutoGenerateValue <> DB.arNone);
    end;
  end;
  if FDataSet.Adapter <> nil then begin
    FUpdOpts.Assign(FDataSet.Command.UpdateOptions);
    frmUpdateOptions.LoadFrom(FUpdOpts);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.btnGenSQLClick(Sender: TObject);
begin
  frmUpdateOptions.SaveTo(FUpdOpts);
  GenCommands;
  rgSQLKindClick(nil);
  UpdateExistSQLs;
  pcMain.ActivePage := tsSQL;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.rgSQLKindClick(Sender: TObject);
begin
  if mmSQL.Modified then
    mmSQLExit(nil);
  mmSQL.Lines.Assign(FSQLs[tcSQLKind.TabIndex]);
  mmSQL.Modified := False;
  FLastSQLKind := tcSQLKind.TabIndex;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.mmSQLExit(Sender: TObject);
begin
  FSQLs[FLastSQLKind].Assign(mmSQL.Lines);
  mmSQL.Modified := False;
  UpdateExistSQLs;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.UpdateExistSQLs;
var
  i: Integer;
  s: String;
begin
  for i := 0 to 5 do begin
    s := tcSQLKind.Tabs[i];
    if FSQLs[i].Count > 0 then begin
      if Pos('*', s) = 0 then
        s := s + ' *';
    end
    else begin
      if Pos('*', s) <> 0 then
        s := Copy(s, 1, Pos('*', s) - 1);
    end;
    tcSQLKind.Tabs[i] := s;
  end;
  tcSQLKind.Invalidate;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.GenCommands;
var
  i, j: Integer;
  oCmdGen: IADPhysCommandGenerator;
  oTab: TADDatSTable;
  oCol: TADDatSColumn;
  oFld: TField;
  sFldName: String;
  oCmd: IADPhysCommand;
  oOpts: IADStanOptions;
begin
  oTab := TADDatSTable.Create;
  FConnection.ConnectionIntf.CreateCommand(oCmd);
  FConnection.ConnectionIntf.CreateCommandGenerator(oCmdGen);
  try
    oOpts := oCmd.Options;
    with oOpts do begin
      UpdateOptions.Assign(FUpdOpts);
      FetchOptions.RowsetSize := 0;
      FetchOptions.Mode := fmManual;
      FetchOptions.Items := FetchOptions.Items + [fiMeta];
    end;

    // define table
    oCmd.Prepare('select * from ' + cbxTableName.Text);
    oCmd.Define(oTab);
    oTab.SourceName := cbxTableName.Text;

    // Include into Where only fields existing in dataset and
    // having pfInWhere in ProviderFlags
    if FDataSet <> nil then
      for i := 0 to oTab.Columns.Count - 1 do begin
        oCol := oTab.Columns[i];
        if coInWhere in oCol.Options then begin
          oCol.Options := oCol.Options - [coInWhere];
          for j := 0 to FDataSet.Fields.Count - 1 do begin
            oFld := FDataSet.Fields[j];
            if oFld.Origin = '' then
              sFldName := oFld.FieldName
            else
              sFldName := oFld.Origin;
            if (AnsiCompareText(oCol.Name, sFldName) = 0) and
               (pfInWhere in oFld.ProviderFlags) then
              oCol.Options := oCol.Options + [coInWhere];
          end;
        end;
      end;

    // Include into where selected Key fields
    for i := 0 to lbKeyFields.Items.Count - 1 do
      with oTab.Columns.ColumnByName(lbKeyFields.Items[i]) do
        if lbKeyFields.Selected[i] then
          Options := Options + [coInKey, coInWhere]
        else
          Options := Options - [coInKey, coInWhere];

    // Include into update selected Updating fields
    for i := 0 to lbUpdateFields.Items.Count - 1 do
      with oTab.Columns.ColumnByName(lbUpdateFields.Items[i]) do
        if lbUpdateFields.Selected[i] then
          Options := Options + [coInUpdate, coInWhere]
        else
          Options := Options - [coInUpdate, coInWhere];

    // Include into refetch selected Refreshing fields
    for i := 0 to lbRefetchFields.Items.Count - 1 do
      with oTab.Columns.ColumnByName(lbRefetchFields.Items[i]) do
        if lbRefetchFields.Selected[i] then
          Options := Options + [coAfterInsChanged, coAfterUpdChanged]
        else
          Options := Options - [coAfterInsChanged, coAfterUpdChanged];

    // Setup SQL generator
    oCmdGen.FillRowOptions := [foData, foBlobs, foDetails, foClear] +
      ADGetFillRowOptions(oOpts.FetchOptions);
    oCmdGen.GenOptions := [goClassicParamName, goBeautify];
    if cbQuoteColName.Checked then
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceQuoteCol]
    else
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceNoQuoteCol];
    if cbQuoteTabName.Checked then
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceQuoteTab]
    else
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceNoQuoteTab];
    oCmdGen.Options := oOpts;
    oCmdGen.Table := oTab;

    // Generate commands
    if FUpdOpts.EnableInsert then
      FSQLs[0].Text := oCmdGen.GenerateInsert;
    if FUpdOpts.EnableUpdate then
      FSQLs[1].Text := oCmdGen.GenerateUpdate;
    if FUpdOpts.EnableDelete then
      FSQLs[2].Text := oCmdGen.GenerateDelete;
    if FUpdOpts.LockMode <> lmRely then begin
      FSQLs[3].Text := oCmdGen.GenerateLock;
      FSQLs[4].Text := oCmdGen.GenerateUnLock;
    end;
    FSQLs[5].Text := oCmdGen.GenerateSelect;
  finally
    oTab.Free;
    oCmdGen := nil;
    oCmd := nil;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TfrmADGUIxFormsUSEdit.Execute(AUpdSQL: TADUpdateSQL; const ACaption: String): Boolean;
var
  oTestCmd: TADCustomCommand;
  oFrm: TfrmADGUIxFormsUSEdit;
begin
  Result := False;
  oFrm := TfrmADGUIxFormsUSEdit.Create(nil);
  with oFrm do
  try
    LoadState;
    Caption := Format(S_AD_USEditCaption, [ACaption]);
    FUpdateSQL := AUpdSQL;
    FDataSet := FUpdateSQL.DataSet;
    btnDSDefaults.Enabled := (FDataSet <> nil);
    btnGenSQL.Enabled := False;
    oTestCmd := FUpdateSQL.Commands[arInsert];
    FConnection := oTestCmd.GetConnection(False);
    pcMain.ActivePage := tsOptions;
    if FConnection = nil then
      raise Exception.Create(S_AD_USEditCantEdit);
    ADManager.OpenConnection(FConnection);
    try
      FUpdOpts := TADUpdateOptions.Create(FConnection);
      FUpdOpts.Assign(oTestCmd.UpdateOptions);
      frmUpdateOptions.LoadFrom(FUpdOpts);
      frmUpdateOptions.SQLGenerator := True;
      cbxTableName.Text := oTestCmd.UpdateOptions.UpdateTableName;
      if cbxTableName.Text <> '' then begin
        cbxTableNameChange(cbxTableName);
        cbxTableNameClick(cbxTableName);
      end;
      if btnDSDefaults.Enabled then begin
        btnDSDefaultsClick(nil);
        ActiveControl := btnDSDefaults;
      end
      else
        ActiveControl := cbxTableName;
      FSQLs[0].Assign(AUpdSQL.InsertSQL);
      FSQLs[1].Assign(AUpdSQL.ModifySQL);
      FSQLs[2].Assign(AUpdSQL.DeleteSQL);
      FSQLs[3].Assign(AUpdSQL.LockSQL);
      FSQLs[4].Assign(AUpdSQL.UnlockSQL);
      FSQLs[5].Assign(AUpdSQL.FetchRowSQL);
      UpdateExistSQLs;
      rgSQLKindClick(nil);
      Result := (ShowModal = mrOK);
    finally
      ADManager.CloseConnection(FConnection);
    end;
    if Result then begin
      AUpdSQL.InsertSQL.Assign(FSQLs[0]);
      AUpdSQL.ModifySQL.Assign(FSQLs[1]);
      AUpdSQL.DeleteSQL.Assign(FSQLs[2]);
      AUpdSQL.LockSQL.Assign(FSQLs[3]);
      AUpdSQL.UnlockSQL.Assign(FSQLs[4]);
      AUpdSQL.FetchRowSQL.Assign(FSQLs[5]);
    end;
    SaveState;
  finally
    Free;
  end;
end;

end.

