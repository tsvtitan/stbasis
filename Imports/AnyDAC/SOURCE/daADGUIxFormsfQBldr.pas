{ --------------------------------------------------------------------------- }
{ AnyDAC Query Builder base classes                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{ Portions copyright:                                                         }
{ - Sergey Orlik, 1996-99. The source is based on Open Query Builder.         }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsfQBldr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, Grids, DB, DBGrids, ImgList, IniFiles,
  ToolWin, ActnList,
  daADStanIntf,
  daADGUIxFormsfOptsBase, daADGUIxFormsQBldrCtrls, daADGUIxFormsControls;

type
  TADGUIxFormsQBldrDialog = class;
  TADGUIxFormsQBldrEngineBase = class;

  TADGUIxFormsQBldrButton = (bbSelectConnDialog, bbOpenDialog, bbSaveDialog,
    bbRunQuery, bbSaveResultsDialog);
  TADGUIxFormsQBldrButtons = set of TADGUIxFormsQBldrButton;

  TADGUIxFormsQBldrDialog = class(TADComponent)
  private
    FSystemTables: Boolean;
    FBldrForm: TForm;
    FSQL: TStrings;
    FBldrEngine: TADGUIxFormsQBldrEngineBase;
    FShowButtons: TADGUIxFormsQBldrButtons;
    FInfoCaption1: String;
    FInfoCaption2: String;
    FSQLModelChanged: Boolean;
    procedure SetBldrEngine(const AValue: TADGUIxFormsQBldrEngineBase);
    procedure SetShowButtons(const AValue: TADGUIxFormsQBldrButtons);
    procedure DoSQLModelChanged(ASender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; virtual;
    function StartBldrFrm(AForm: TForm): Boolean;
    procedure FinishBldrFrm(AForm: TForm; AResult: Boolean);
    property SQL: TStrings read FSQL;
    property SystemTables: Boolean read FSystemTables write FSystemTables default False;
  published
    property BldrEngine: TADGUIxFormsQBldrEngineBase read FBldrEngine write SetBldrEngine;
    property ShowButtons: TADGUIxFormsQBldrButtons read FShowButtons write SetShowButtons
      default [bbSelectConnDialog, bbOpenDialog, bbSaveDialog, bbRunQuery, bbSaveResultsDialog];
    property InfoCaption1: String read FInfoCaption1 write FInfoCaption1;
    property InfoCaption2: String read FInfoCaption2 write FInfoCaption2;
  end;

  TADGUIxFormsQBldrSQLJoinDialect = (sdAnsiSQL, sdOracle, sdMSAccess);
  TADGUIxFormsQBldrSQLKind = (snSelect, snUpdate, snInsert);
  TADGUIxFormsQBldrSQLScopes = set of (ssMy, ssOther, ssSystem);

  TADGUIxFormsQBldrEngineBase = class(TADComponent)
  private
    FConnection: TCustomConnection;
    FShowTables: TADGUIxFormsQBldrSQLScopes;
    FSQL: TStringList;
    FSQLcolumns: TStringList;
    FSQLcolumns_table: TStringList;
    FSQLcolumns_func: TStringList;
    FSQLfrom: TStringList;
    FSQLwhere: TStringList;
    FSQLgroupby: TStringList;
    FSQLorderby: TStringList;
    FUseTableAliases: Boolean;
    FConnectionName: String;
    FSessionName: String;
    FSQLKind: TADGUIxFormsQBldrSQLKind;
    procedure GenerateSelect;
    procedure GenerateInsert;
    procedure GenerateUpdate;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetConnection(const AValue: TCustomConnection); virtual;
    procedure SetSessionName(const AValue: String); virtual;
    procedure SetConnectionName(const AValue: String); virtual;
    procedure SetQuerySQL(AValue: String); virtual; abstract;
    procedure ReadTableList(ATables: TStrings; out ASQLDialect:
      TADGUIxFormsQBldrSQLJoinDialect); virtual; abstract;
    procedure ReadFieldList(const ATableName: String;
      AFields: TStrings); virtual; abstract;
    function  SelectConnection: Boolean; virtual; abstract;
    function  GenerateSQL: String; virtual;
    procedure ClearQuerySQL; virtual; abstract;
    function  ResultQuery: TDataSet; virtual; abstract;
    procedure SaveResultQueryData; virtual; abstract;
  public
    FBldrDialog: TADGUIxFormsQBldrDialog;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property  SQL: TStringList read FSQL;
    property  SQLcolumns: TStringList read FSQLcolumns;
    property  SQLcolumns_table: TStringList read FSQLcolumns_table;
    property  SQLcolumns_func: TStringList read FSQLcolumns_func;
    property  SQLfrom: TStringList read FSQLfrom;
    property  SQLwhere: TStringList read FSQLwhere;
    property  SQLgroupby: TStringList read FSQLgroupby;
    property  SQLorderby: TStringList read FSQLorderby;
  published
    property Connection: TCustomConnection read FConnection write SetConnection;
    property ConnectionName: String read FConnectionName write SetConnectionName;
    property SessionName: String read FSessionName write SetSessionName;
    property ShowTables: TADGUIxFormsQBldrSQLScopes read FShowTables write FShowTables default [ssMy];
    property UseTableAliases: Boolean read FUseTableAliases write FUseTableAliases default True;
    property SQLKind: TADGUIxFormsQBldrSQLKind read FSQLKind write FSQLKind default snSelect;
  end;

  TADGUIxFormsQBldrController = class(TADGUIxFormsQBldrControllerBase)
  private
    FQBGrid: TADGUIxFormsQBldrGrid;
    FQBEngine: TADGUIxFormsQBldrEngineBase;
    FQBDialog: TADGUIxFormsQBldrDialog;
    FL: TLabel;
  protected
    procedure DoGetFields(ATable: TADGUIxFormsQBldrTable; AFields: TStrings); override;
    procedure DoGetTable(var ATableName: String); override;
    procedure DoFieldChecked(ATable: TADGUIxFormsQBldrTable; const AFieldName: String; AChecked: Boolean); override;
    procedure DoTableFocused(ATable: TADGUIxFormsQBldrTable); override;
    procedure DoFieldFocused(ATable: TADGUIxFormsQBldrTable; const AFieldName: String); override;
    procedure DoLinkFocused(ALink: TADGUIxFormsQBldrLink); override;
    procedure DoAreaFocused(AArea: TADGUIxFormsQBldrArea); override;
  public
    property QBGrid: TADGUIxFormsQBldrGrid read FQBGrid write FQBGrid;
    property QBEngine: TADGUIxFormsQBldrEngineBase read FQBEngine write FQBEngine;
    property QBDialog: TADGUIxFormsQBldrDialog read FQBDialog write FQBDialog;
    property L: TLabel read FL write FL;
  end;

  TfrmADGUIxFormsQBldr = class(TfrmADGUIxFormsOptsBase)
    pcPages: TADGUIxFormsPageControl;
    tsColumns: TTabSheet;
    lbTables: TListBox;
    VSplitter: TSplitter;
    HSplitter: TSplitter;
    tsSQL: TTabSheet;
    tsResults: TTabSheet;
    dsResult: TDataSource;
    DlgSave: TSaveDialog;
    DlgOpen: TOpenDialog;
    Panel1: TADGUIxFormsPanel;
    Panel2: TADGUIxFormsPanel;
    MemoSQL: TMemo;
    Panel6: TADGUIxFormsPanel;
    ResDBGrid: TDBGrid;
    Panel7: TADGUIxFormsPanel;
    ActionList1: TActionList;
    actFileDB: TAction;
    actFileNew: TAction;
    actFileLoad: TAction;
    actFileSave: TAction;
    actViewPages: TAction;
    actViewTables: TAction;
    actRunGenerate: TAction;
    actRunResults: TAction;
    actRunSaveResult: TAction;
    ilToolBar: TImageList;
    Panel4: TADGUIxFormsPanel;
    Panel3: TADGUIxFormsPanel;
    Label1: TLabel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Image1: TImage;
    Panel8: TADGUIxFormsPanel;
    pnlQBuilder: TADGUIxFormsPanel;
    procedure actFileNewClick(Sender: TObject);
    procedure actFileOpenClick(Sender: TObject);
    procedure actFileSaveClick(Sender: TObject);
    procedure actViewTablesClick(Sender: TObject);
    procedure actViewPagesClick(Sender: TObject);
    procedure actFileDBClick(Sender: TObject);
    procedure actRunGenerateClick(Sender: TObject);
    procedure actRunResultsClick(Sender: TObject);
    procedure actRunSaveResultsClick(Sender: TObject);
  protected
    QBArea: TADGUIxFormsQBldrArea;
    QBGrid: TADGUIxFormsQBldrGrid;
    QBDialog: TADGUIxFormsQBldrDialog;
    QBController: TADGUIxFormsQBldrController;
    FSQLDialect: TADGUIxFormsQBldrSQLJoinDialect;
    procedure ClearAll;
    function OpenConnection: Boolean;
    function SelectConnection: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R daADGUIxFormsQBldrButton.RES}

uses
  CheckLst,
  daADStanResStrs, daADStanUtil;

{$R *.DFM}

const
  sLinkOpts: array [0..5] of String =
    ('=',
     '<',
     '>',
     '<=',
     '>=',
     '<>');

  sJoins: array [0..3] of String =
    (' JOIN ',
     ' LEFT OUTER JOIN ',
     ' RIGHT OUTER JOIN ',
     ' FULL OUTER JOIN ');

  sMSAccJoins: array [0..3] of String =
    (' INNER JOIN ',
     ' LEFT JOIN ',
     ' RIGHT JOIN ',
     ' JOIN ');

{ --------------------------------------------------------------------------- }
{ TQueryBuilderDialog                                                         }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSystemTables := False;
  FShowButtons := [bbSelectConnDialog, bbOpenDialog, bbSaveDialog,
                   bbRunQuery, bbSaveResultsDialog];
  FSQL := TStringList.Create;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsQBldrDialog.Destroy;
begin
  FreeAndNil(FSQL);
  FBldrEngine := nil;
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrDialog.DoSQLModelChanged(ASender: TObject);
begin
  FSQLModelChanged := True;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrDialog.StartBldrFrm(AForm: TForm): Boolean;
begin
  with TfrmADGUIxFormsQBldr(AForm) do begin
    with TADGUIxFormsQBldrController(QBController) do begin
      OnChanged := DoSQLModelChanged;
      QBEngine := FBldrEngine;
      QBDialog := Self;
      UseTableAliases := FBldrEngine.UseTableAliases;
    end;
    QBDialog := Self;
    MemoSQL.Lines.Assign(FSQL);
    actFileDB.Visible := bbSelectConnDialog in FShowButtons;
    actFileLoad.Visible := bbOpenDialog in FShowButtons;
    actFileSave.Visible := bbSaveDialog in FShowButtons;
    actRunResults.Visible := bbRunQuery in FShowButtons;
    actRunSaveResult.Visible := bbSaveResultsDialog in FShowButtons;
    if (BldrEngine.Connection <> nil) or (BldrEngine.ConnectionName <> '') then
      Result := OpenConnection
    else
      Result := SelectConnection;
    FSQLModelChanged := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrDialog.FinishBldrFrm(AForm: TForm; AResult: Boolean);
begin
  with TfrmADGUIxFormsQBldr(AForm) do begin
    if AResult then begin
      if not QBGrid.IsEmpty and FSQLModelChanged then
        actRunGenerateClick(nil);
      FSQL.Assign(MemoSQL.Lines);
    end;
    BldrEngine.ResultQuery.Close;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrDialog.Execute: Boolean;
begin
  Result := False;
  if not Assigned(FBldrForm) and Assigned(FBldrEngine) then begin
    FBldrForm := TfrmADGUIxFormsQBldr.Create(nil);
    try
      if not StartBldrFrm(TfrmADGUIxFormsQBldr(FBldrForm)) then
        Exit;
      Result := (FBldrForm.ShowModal = mrOk);
      FinishBldrFrm(TfrmADGUIxFormsQBldr(FBldrForm), Result);
    finally
      FreeAndNil(FBldrForm);
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FBldrEngine) and (Operation = opRemove) then
    SetBldrEngine(nil);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrDialog.SetBldrEngine(const AValue: TADGUIxFormsQBldrEngineBase);
begin
  if FBldrEngine <> nil then
    FBldrEngine.FBldrDialog := nil;
  FBldrEngine := AValue;
  if FBldrEngine <> nil then begin
    FBldrEngine.FBldrDialog := Self;
    FBldrEngine.FreeNotification(Self);
    FreeNotification(FBldrEngine);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrDialog.SetShowButtons(const AValue: TADGUIxFormsQBldrButtons);
begin
  if AValue <> FShowButtons then
    FShowButtons := AValue;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrEngineBase                                                 }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrEngineBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowTables := [ssMy];
  FSQL := TStringList.Create;
  FSQLcolumns := TStringList.Create;
  FSQLcolumns_table := TStringList.Create;
  FSQLcolumns_func := TStringList.Create;
  FSQLfrom := TStringList.Create;
  FSQLwhere := TStringList.Create;
  FSQLgroupby := TStringList.Create;
  FSQLorderby := TStringList.Create;
  FUseTableAliases := True;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsQBldrEngineBase.Destroy;
begin
  FreeAndNil(FSQL);
  FreeAndNil(FSQLcolumns);
  FreeAndNil(FSQLcolumns_table);
  FreeAndNil(FSQLcolumns_func);
  FreeAndNil(FSQLfrom);
  FreeAndNil(FSQLwhere);
  FreeAndNil(FSQLgroupby);
  FreeAndNil(FSQLorderby);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FBldrDialog) and (Operation = opRemove) then
    FBldrDialog := nil;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.SetConnection(const AValue: TCustomConnection);
begin
  if FConnection <> AValue then begin
    if ResultQuery.Active then
      ResultQuery.Close;
    FSessionName := '';
    FConnectionName := '';
    FConnection := AValue;
    if FConnection <> nil then
      FConnection.FreeNotification(Self);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.SetSessionName(const AValue: String);
begin
  if FSessionName <> AValue then begin
    if ResultQuery.Active then
      ResultQuery.Close;
    FSessionName := AValue;
    FConnectionName := '';
    FConnection := nil;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.SetConnectionName(const AValue: String);
begin
  if FConnectionName <> AValue then begin
    if ResultQuery.Active then
      ResultQuery.Close;
    FConnectionName := AValue;
    FConnection := nil;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.GenerateSelect;
var
  s: String;
  i: Integer;
begin
  s := 'SELECT ';
  for i := 0 to SQLcolumns.Count - 1 do begin
    if SQLcolumns_func[i] = '' then
      s := s + SQLcolumns_table[i] + '.' + SQLcolumns[i]
    else if SQLcolumns[i] = '*' then
      s := s + SQLcolumns_func[i] + '(' + SQLcolumns[i] + ')'
    else
      s := s + SQLcolumns_func[i] + '(' + SQLcolumns_table[i] + '.' + SQLcolumns[i] + ')';
    if i < SQLcolumns.Count - 1 then
      s := s + ', ';
    if (length(s) > 70) or (i = SQLcolumns.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;

  s := 'FROM ';
  for i := 0 to SQLfrom.Count - 1 do begin
    s := s + SQLfrom[i];
    if i < SQLfrom.Count - 1 then
      s := s + ', ';
    if (Length(s) > 70) or (i = SQLfrom.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;

  s := 'WHERE ';
  for i := 0 to SQLwhere.Count - 1 do begin
    if i < SQLwhere.Count - 1 then
      s := s + SQLwhere[i] + ' AND '
    else
      s := s + SQLwhere[i];
    if (Length(s) > 70) or (i = SQLwhere.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;

  s := 'GROUP BY ';
  for i := 0 to SQLgroupby.Count - 1 do begin
    if i < SQLgroupby.Count-1 then
      s := s + SQLgroupby[i] + ', '
    else
      s := s + SQLgroupby[i];
    if (Length(s) > 70) or (i = SQLgroupby.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;

  s := 'ORDER BY ';
  for i := 0 to SQLorderby.Count - 1 do begin
    if i < SQLorderby.Count - 1 then
      s := s + SQLorderby[i] + ', '
    else
      s := s + SQLorderby[i];
    if (Length(s) > 70) or (i = SQLorderby.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.GenerateUpdate;
//var
//  s: String;
//  i: Integer;
begin
{  s := 'UPDATE ';
  for i := 0 to SQLfrom.Count - 1 do begin
    s := s + SQLfrom[i];
    if i < SQLfrom.Count - 1 then
      s := s + ', ';
    if (Length(s) > 70) or (i = SQLfrom.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;

  s := 'SET ';
  for i := 0 to SQLcolumns.Count - 1 do begin
    s := s + SQLcolumns_table[i] + '.' + SQLcolumns[i] + ' = :P' + IntToStr(i)
    if i < SQLcolumns.Count - 1 then
      s := s + ', ';
    if (length(s) > 70) or (i = SQLcolumns.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;

  s := 'WHERE ';
  for i := 0 to SQLwhere.Count - 1 do begin
    if i < SQLwhere.Count - 1 then
      s := s + SQLwhere[i] + ' AND '
    else
      s := s + SQLwhere[i];
    if (Length(s) > 70) or (i = SQLwhere.Count - 1) then begin
      SQL.Add(s);
      s := '  ';
    end;
  end;
}
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrEngineBase.GenerateInsert;
begin
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrEngineBase.GenerateSQL: String;
begin
  SQL.Clear;
  case SQLKind of
  snSelect: GenerateSelect;
  snUpdate: GenerateUpdate;
  snInsert: GenerateInsert;
  end;
  Result := SQL.Text;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrController                                                 }
{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoGetFields(ATable: TADGUIxFormsQBldrTable;
  AFields: TStrings);
begin
  QBEngine.ReadFieldList(ATable.TableName, AFields);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoGetTable(var ATableName: String);
begin
  with TListBox(QBTableList) do
    ATableName := Items[ItemIndex];
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoFieldChecked(ATable: TADGUIxFormsQBldrTable;
  const AFieldName: String; AChecked: Boolean);
var
  iCol: Integer;
begin
  if AChecked then
    QBGrid.Insert(QBGrid.ColCount, AFieldName, ATable.RefTableName)
  else begin
    iCol := QBGrid.FindColumn(AFieldName, ATable.RefTableName);
    while iCol <> -1 do begin
      QBGrid.RemoveColumn(iCol);
      iCol := QBGrid.FindColumn(AFieldName, ATable.RefTableName);
    end;
  end;
  QBGrid.Refresh;
  DoChanged;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoFieldFocused(ATable: TADGUIxFormsQBldrTable;
  const AFieldName: String);
begin
  // nothing
  L.Caption := 'Field: [' + ATable.RefTableName + ',' + AFieldName + ']';
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoLinkFocused(ALink: TADGUIxFormsQBldrLink);
begin
  // nothing
  L.Caption := 'Link: [' + ALink.Tbl1.RefTableName + ',' + ALink.Tbl2.RefTableName + ']';
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoTableFocused(ATable: TADGUIxFormsQBldrTable);
begin
  // nothing
  L.Caption := 'Table: [' + ATable.RefTableName + ']';
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrController.DoAreaFocused(AArea: TADGUIxFormsQBldrArea);
begin
  // nothing
  L.Caption := 'Area';
end;

{ --------------------------------------------------------------------------- }
{ TfrmADGUIxFormsQBldr                                                        }
{ --------------------------------------------------------------------------- }
constructor TfrmADGUIxFormsQBldr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  QBController := TADGUIxFormsQBldrController.Create;
  QBController.QBTableList := lbTables;
  QBController.L := Label1;
  QBArea := QBController.NewArea(Self);
  with QBArea do begin
    Parent := Panel1;
    Align := alClient;
    Color := clAppWorkSpace;
    BorderStyle := bsNone;
  end;
  QBArea.QBController := QBController;
  QBGrid := TADGUIxFormsQBldrGrid.Create(Self);
  with QBGrid do begin
    Parent := Panel7;
    Align := alClient;
    Color := clInfoBk;
    BorderStyle := bsNone;
    DefaultRowHeight := tsColumns.Height div (6 + 1) - GridLineWidth;
    QBArea := Self.QBArea;
  end;
  QBController.QBGrid := QBGrid;
  VSplitter.Tag := VSplitter.Left;
  HSplitter.Tag := HSplitter.Top;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.ClearAll;
var
  i: Integer;
  oTab: TADGUIxFormsQBldrTable;
begin
  for i := QBArea.ControlCount - 1 downto 0 do
    if QBArea.Controls[i] is TADGUIxFormsQBldrTable then begin
      oTab := TADGUIxFormsQBldrTable(QBArea.Controls[i]);
      QBGrid.RemoveColumns(oTab.RefTableName);
      oTab.Free;
    end
    else
      QBArea.Controls[i].Free;
  MemoSQL.Lines.Clear;
  with QBDialog.BldrEngine do begin
    ResultQuery.Close;
    ClearQuerySQL;
  end;
  pcPages.ActivePage := tsColumns;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actFileNewClick(Sender: TObject);
begin
  ClearAll;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actFileOpenClick(Sender: TObject);
var
  i, j: Integer;
  s: String;
  oTab: TADGUIxFormsQBldrTable;
  sTableName, sTableAlias: String;
  X, Y, W, H: Integer;
  lIsMin: Boolean;
  oLink: TADGUIxFormsQBldrLink;
  oTable1, oTable2: TADGUIxFormsQBldrTable;
  iFieldN1, iFieldN2: Integer;
  sField, sTable: String;
  oLst: TStringList;
  oIni: TCustomIniFile;

  function GetNextVal(var s: String): String;
  var
    p: Integer;
  begin
    Result := '';
    if Length(s) = 0 then
      Exit;
    p := Pos(',', s);
    if p = 0 then
      p := Length(s) + 1;
    Result := Copy(s, 1, p - 1);
    s := Copy(s, p + 1, Length(s));
  end;

begin
  if not DlgOpen.Execute then
    Exit;
  ClearAll;
  oLst := TStringList.Create;
  oIni := TIniFile.Create(DlgOpen.FileName);
  QBArea.BeginLoad;
  try
    // read options
    oIni.ReadSectionValues('main', oLst);
    if oLst.IndexOfName('AnyDACQB') = -1 then begin
      ShowMessage(Format(S_AD_QBBadQueryFile, [DlgOpen.FileName]));
      Exit;
    end;

    s := ADValueFromIndex(oLst, 1);
    if UpperCase(s) = 'X' then
      WindowState := wsMaximized
    else begin
      WindowState := wsNormal;
      Top := StrToInt(GetNextVal(s));
      Left := StrToInt(GetNextVal(s));
      Height := StrToInt(GetNextVal(s));
      Width := StrToInt(GetNextVal(s));
    end;

    s := ADValueFromIndex(oLst, 2);
    actViewTables.Checked := Boolean(StrToInt(GetNextVal(s)));
    VSplitter.Visible := actViewTables.Checked;
    lbTables.Visible := actViewTables.Checked;
    lbTables.Width := StrToInt(GetNextVal(s));
    actViewPages.Checked := Boolean(StrToInt(GetNextVal(s)));
    HSplitter.Visible := actViewPages.Checked;
    pcPages.Visible := actViewPages.Checked;
    pcPages.Height := StrToInt(GetNextVal(s));

    s := ADValueFromIndex(oLst, 3);
    with QBDialog.BldrEngine do begin
      SessionName := GetNextVal(s);
      ConnectionName := GetNextVal(s);
      i := StrToInt(GetNextVal(s));
      ShowTables := TADGUIxFormsQBldrSQLScopes(Pointer(@i)^);
    end;
    OpenConnection;

    // read tables
    oIni.ReadSectionValues('tables', oLst);
    for i := 0 to oLst.Count - 1 do begin
      s := ADValueFromIndex(oLst, i);
      sTableName := GetNextVal(s);
      sTableAlias := GetNextVal(s);
      Y := StrToInt(GetNextVal(s));
      X := StrToInt(GetNextVal(s));
      lIsMin := Boolean(StrToInt(GetNextVal(s)));
      if not lIsMin then begin
        H := StrToInt(GetNextVal(s));
        W := StrToInt(GetNextVal(s));
      end
      else begin
        H := -1;
        W := -1;
      end;
      oTab := QBController.NewTable(Self);
      try
        oTab.Parent := QBArea;
        oTab.Activate(sTableName, sTableAlias, X, Y, lIsMin, W, H);
        with oTab.Fields do
          for j := 0 to Items.Count - 1 do
            Checked[j] := Boolean(StrToIntDef(GetNextVal(s), 0));
      except
        oTab.Free;
        raise;
      end;
    end;

    // read links
    oIni.ReadSectionValues('links', oLst);
    for i := 0 to oLst.Count - 1 do begin
      s := ADValueFromIndex(oLst, i);
      oTable1 := QBArea.FindTable(GetNextVal(s));
      iFieldN1 := StrToInt(GetNextVal(s));
      oTable2 := QBArea.FindTable(GetNextVal(s));
      iFieldN2 := StrToInt(GetNextVal(s));
      oLink := QBArea.InsertLink(oTable1, oTable2, iFieldN1, iFieldN2);
      oLink.LinkOpt := StrToInt(GetNextVal(s));
      oLink.LinkType := StrToInt(GetNextVal(s));
    end;

    // read columns
    oIni.ReadSectionValues('columns', oLst);
    for i := 0 to oLst.Count - 1 do begin
      j := StrToInt(oLst.Names[i]) + 1;
      s := ADValueFromIndex(oLst, i);
      sField := GetNextVal(s);
      sTable := GetNextVal(s);
      QBGrid.Insert(j, sField, sTable);
      QBGrid.Cells[j, cShow] := GetNextVal(s);
      QBGrid.Cells[j, cSort] := GetNextVal(s);
      QBGrid.Cells[j, cFunc] := GetNextVal(s);
      QBGrid.Cells[j, cGroup] := GetNextVal(s);
    end;

  finally
    QBArea.EndLoad;
    oLst.Free;
    oIni.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actFileSaveClick(Sender: TObject);
var
  i, j, n: Integer;
  s: String;
  oTab: TADGUIxFormsQBldrTable;
  oLink: TADGUIxFormsQBldrLink;
  oLst: TStringList;
  eScopes: TADGUIxFormsQBldrSQLScopes;
begin
  if not DlgSave.Execute then
    Exit;
  oLst := TStringList.Create;
  try
    // save parameters and options
    oLst.Add('[Main]');
    oLst.Add('AnyDACQB=1');
    if WindowState = wsMaximized then
      oLst.Add('W=X')
    else
      oLst.Add('W=' + IntToStr(Top) + ',' + IntToStr(Left) + ',' +
        IntToStr(Height) + ',' + IntToStr(Width));
    oLst.Add('C=' + IntToStr(Integer(actViewTables.Checked)) + ',' +
      IntToStr(lbTables.Width) + ',' + IntToStr(Integer(actViewPages.Checked)) + ',' +
      IntToStr(pcPages.Height));
    eScopes := QBDialog.BldrEngine.ShowTables;
    oLst.Add('D=' + QBDialog.BldrEngine.SessionName + ',' +
      QBDialog.BldrEngine.ConnectionName + ',' +
      IntToStr(PInteger(@eScopes)^));

    // save tables
    oLst.Add('[Tables]');
    n := 0;
    for i := 0 to QBArea.ControlCount - 1 do
      if QBArea.Controls[i] is TADGUIxFormsQBldrTable then begin
        oTab := TADGUIxFormsQBldrTable(QBArea.Controls[i]);
        s := IntToStr(n) + '=' + oTab.TableName + ',' + oTab.TableAlias + ',' +
          IntToStr(oTab.Top + QBArea.VertScrollBar.ScrollPos) + ',' +
          IntToStr(oTab.Left + QBArea.HorzScrollBar.ScrollPos) + ',' +
          IntToStr(Integer(oTab.Minimized));
        if not oTab.Minimized then
          s := s + ',' + IntToStr(oTab.Height) + ',' + IntToStr(oTab.Width);
        for j := 0 to oTab.Fields.Items.Count - 1 do
          s := s + ',' + IntToStr(Integer(oTab.Fields.Checked[j]));
        oLst.Add(s);
        Inc(n);
      end;

    // save links
    oLst.Add('[Links]');
    n := 0;
    for i := 0 to QBArea.ControlCount - 1 do
      if QBArea.Controls[i] is TADGUIxFormsQBldrLink then begin
        oLink := TADGUIxFormsQBldrLink(QBArea.Controls[i]);
        s := IntToStr(n) + '=' + oLink.Tbl1.RefTableName + ',' +
          IntToStr(oLink.FldN1) + ',' + oLink.Tbl2.RefTableName + ',' +
          IntToStr(oLink.FldN2) + ',' + IntToStr(oLink.LinkOpt) + ',' +
          IntToStr(oLink.LinkType);
        oLst.Add(s);
        Inc(n);
      end;

    // save columns
    oLst.Add('[Columns]');
    if not QBGrid.IsEmpty then
      for i := 1 to QBGrid.ColCount - 1 do begin
        s := IntToStr(i - 1) + '=' + QBGrid.Cells[i, cFld] + ',' +
          QBGrid.Cells[i, cTbl] + ',' + QBGrid.Cells[i, cShow] + ',' +
          QBGrid.Cells[i, cSort] + ',' + QBGrid.Cells[i, cFunc] + ',' +
          QBGrid.Cells[i, cGroup];
        oLst.Add(s);
      end;

    oLst.SaveToFile(DlgSave.FileName);
  finally
    oLst.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actViewTablesClick(Sender: TObject);
begin
  actViewTables.Checked := not actViewTables.Checked;
  VSplitter.Visible := actViewTables.Checked;
  Panel3.Visible := actViewTables.Checked;
  if not VSplitter.Visible then
    VSplitter.Tag := VSplitter.Left
  else
    VSplitter.Left := VSplitter.Tag;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actViewPagesClick(Sender: TObject);
begin
  actViewPages.Checked := not actViewPages.Checked;
  HSplitter.Visible := actViewPages.Checked;
  Panel4.Visible := actViewPages.Checked;
  if not HSplitter.Visible then
    HSplitter.Tag := HSplitter.Top
  else
    HSplitter.Top := HSplitter.Tag;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsQBldr.OpenConnection: Boolean;
var
  s: String;
begin
  QBDialog.BldrEngine.ReadTableList(lbTables.Items, FSQLDialect);
  dsResult.DataSet := QBDialog.BldrEngine.ResultQuery;
  if ClassType = TfrmADGUIxFormsQBldr then begin
    s := S_AD_QBMainCaption;
    if QBDialog.InfoCaption1 <> '' then
      s := s + ' [' + QBDialog.InfoCaption1 + ']';
    Caption := s;
    s := S_AD_QBInfoCaption;
    if QBDialog.InfoCaption2 <> '' then
      s := s + ' [' + QBDialog.InfoCaption2 + ']';
    lblTitle.Caption := s;
  end;
  Result := True;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsQBldr.SelectConnection: Boolean;
begin
  Result := QBDialog.BldrEngine.SelectConnection;
  if Result then begin
    lbTables.Items.Clear;
    ClearAll;
    OpenConnection;
  end
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actFileDBClick(Sender: TObject);
begin
  SelectConnection;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actRunGenerateClick(Sender: TObject);
var
  Lst, Lst1, Lst2: TStringList;
  i: Integer;
  s, s1, s2, sJoin: String;
  sTblRef1, sTblRef2, sTblFull1, sTblFull2: String;
  oLink: TADGUIxFormsQBldrLink;
  oTab: TADGUIxFormsQBldrTable;
begin
  if QBGrid.IsEmpty then begin
    ShowMessage(S_AD_QBNoColumns);
    Exit;
  end;
  Lst := TStringList.Create;
  Lst1 := TStringList.Create;        // referenced tables
  Lst2 := TStringList.Create;        // FROM tables
  with QBDialog.BldrEngine do
  try

    SQLcolumns.Clear;
    SQLcolumns_func.Clear;
    SQLcolumns_table.Clear;
    SQLfrom.Clear;
    SQLwhere.Clear;
    SQLgroupby.Clear;
    SQLorderby.Clear;

    //  SELECT clause
    with QBGrid do begin
      for i := 1 to ColCount - 1 do
        if Cells[i, cShow] = S_AD_QBldrGrdShow then begin
          sTblRef1 := Cells[i, cTbl];
          SQLcolumns.Add(Cells[i, cFld]);
          SQLcolumns_table.Add(sTblRef1);
          SQLcolumns_func.Add(Cells[i, cFunc]);
        end;
      if SQLcolumns.Count = 0 then begin
        ShowMessage(S_AD_QBNoColumns);
        Exit;
      end;
    end;

    //  FROM clause
    with QBArea do begin
      // joined tables
      if FSQLDialect in [sdAnsiSQL, sdMSAccess] then
        for i := 0 to ControlCount - 1 do
          if Controls[i] is TADGUIxFormsQBldrLink then begin
            oLink := TADGUIxFormsQBldrLink(Controls[i]);
            sTblRef1 := oLink.Tbl1.RefTableName;
            sTblRef2 := oLink.Tbl2.RefTableName;
            if sTblRef1 <> sTblRef2 then begin
              sTblFull1 := oLink.Tbl1.FullTableName;
              sTblFull2 := oLink.Tbl2.FullTableName;
              if Lst1.IndexOf(sTblFull1) = -1 then
                Lst1.Add(sTblFull1);
              if Lst1.IndexOf(sTblFull2) = -1 then
                Lst1.Add(sTblFull2);
              if FSQLDialect = sdMSAccess then
                sJoin := sMSAccJoins[oLink.LinkType]
              else
                sJoin := sJoins[oLink.LinkType];
              Lst2.Add(sTblFull1 + sJoin + sTblFull2 + ' ON ' +
                       sTblRef1 + '.' + oLink.FldNam1 + sLinkOpts[oLink.LinkOpt] +
                       sTblRef2 + '.' + oLink.FldNam2);
            end;
          end;

      // nonjoined tables
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TADGUIxFormsQBldrTable then begin
          oTab := TADGUIxFormsQBldrTable(Controls[i]);
          sTblFull1 := oTab.FullTableName;
          if Lst1.IndexOf(sTblFull1) = -1 then begin
            Lst1.Add(sTblFull1);
            Lst2.Add(sTblFull1);
          end;
        end;

      SQLfrom.Assign(Lst2);
    end;

    //  WHERE clause
    with QBArea do begin
      // joined tables
      for i := 0 to ControlCount - 1 do
        if Controls[i] is TADGUIxFormsQBldrLink then begin
          oLink := TADGUIxFormsQBldrLink(Controls[i]);
          if (FSQLDialect = sdOracle) or
             (oLink.Tbl1.RefTableName = oLink.Tbl2.RefTableName) then begin
            s1 := '';
            s2 := '';
            if oLink.LinkType = 1 then
              s2 := ' (+)'
            else if oLink.LinkType = 2 then
              s1 := ' (+)'
            else if oLink.LinkType = 3 then begin
              s1 := ' (+)';
              s2 := ' (+)';
            end;
            Lst.Add(
              oLink.Tbl1.RefTableName + '.' + oLink.FldNam1 + s1 +
              sLinkOpts[oLink.LinkOpt] +
              oLink.Tbl2.RefTableName + '.' + oLink.FldNam2 + s2
            );
          end;
        end;
      SQLwhere.Assign(Lst);
      Lst.Clear;
    end;

    // GROUP BY clause
    with QBGrid do begin
      for i := 1 to ColCount - 1 do
        if Cells[i, cGroup] <> '' then
          Lst.Add(Cells[i, cTbl] + '.' + Cells[i, cFld]);
      SQLgroupby.Assign(Lst);
      Lst.Clear;
    end;

    // ORDER BY clause
    with QBGrid do begin
      for i := 1 to ColCount - 1 do begin
        if Cells[i,cSort] <> '' then begin
          sTblRef1 := Cells[i, cTbl];
          // --- to order result set by the result of an aggregate function
          if Cells[i,cFunc] = '' then
            s := sTblRef1 + '.' + Cells[i, cFld]
          else
            s := IntToStr(i);
          // ---
          if Cells[i, cSort] = sSorts[3] then
            s := s + ' DESC';
          Lst.Add(s);
        end;
      end;
      SQLorderby.Assign(Lst);
      Lst.Clear;
    end;

    MemoSQL.Lines.Text := QBDialog.BldrEngine.GenerateSQL;
    if Sender = actRunGenerate then
      pcPages.ActivePage := tsSQL;
  finally
    Lst.Free;
    Lst1.Free;
    Lst2.Free;
  end;
  QBDialog.FSQLModelChanged := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actRunResultsClick(Sender: TObject);
begin
  if not QBGrid.IsEmpty then
    actRunGenerateClick(Sender);
  with QBDialog.BldrEngine do begin
    ResultQuery.Close;
    SetQuerySQL(MemoSQL.Lines.Text);
    ResultQuery.Open;
  end;
  pcPages.ActivePage := tsResults;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsQBldr.actRunSaveResultsClick(Sender: TObject);
begin
  QBDialog.BldrEngine.SaveResultQueryData;
end;

end.
