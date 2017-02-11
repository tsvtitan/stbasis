{-------------------------------------------------------------------------------}
{ AnyDAC QA main form                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAfMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls, CheckLst, ExtCtrls, ImgList, ActnList,
  StdActns, Menus, ToolWin, Buttons, Registry, DB, Dialogs,
  daADGUIxFormsfLogin, daADGUIxFormsfError, daADGUIxFormsfAsync, daADGUIxFormsWait,
  ADQAPack, daADGUIxFormsControls, daADStanIntf;

type
  EDEQAException = class (Exception)
  end;

  TfrmADQAMain = class (TForm)
    acConnectionExit: TAction;
    acTestClearAll: TAction;
    acTestRun: TAction;
    acTestSelAll: TAction;
    ActionList: TActionList;
    ClearAll1: TMenuItem;
    miTestClearAll: TMenuItem;
    Exit1: TMenuItem;
    miFile: TMenuItem;
    Images: TImageList;
    MainMenu1: TMainMenu;
    miTestSep1: TMenuItem;
    PopupMenu1: TPopupMenu;
    miTestRun: TMenuItem;
    SelectAll1: TMenuItem;
    miTestSelAll: TMenuItem;
    miTest: TMenuItem;
    acTestSelFailedTests: TAction;
    acTestSelOkTests: TAction;
    SelectallOktests1: TMenuItem;
    Selectallfailuretests1: TMenuItem;
    miTestSelOkTests: TMenuItem;
    miTestSelFailedTests: TMenuItem;
    imgStates: TImageList;
    miOptions: TMenuItem;
    acLogOpen: TAction;
    acTestStop: TAction;
    miTestStop: TMenuItem;
    acHelpAbout: TAction;
    miHelp: TMenuItem;
    acHelpAbout1: TMenuItem;
    PopupMenu2: TPopupMenu;
    acTestCheckSelInTree: TAction;
    Checkselectedinthetestlist1: TMenuItem;
    miTestCheckSelInTree: TMenuItem;
    acTestRunSelInList: TAction;
    miTestRunSelInList: TMenuItem;
    Runselectediteminrightside1: TMenuItem;
    acLogSaveAs: TAction;
    SaveErrorlogas1: TMenuItem;
    dlgSave: TSaveDialog;
    acConnectionEditDef: TAction;
    acConnectionSelectDef: TAction;
    miOptionsSetupConnDef: TMenuItem;
    acTestFind: TAction;
    miSearchFind: TMenuItem;
    acTestSearchAgain: TAction;
    miSearchSearchAgain: TMenuItem;
    OpenErrorloginNotepad1: TMenuItem;
    miOptionsOpenConDef: TMenuItem;
    miFileSep2: TMenuItem;
    acLogViewExec: TAction;
    acLogViewTrace: TAction;
    acLogWriteToFile: TAction;
    ADGUIxFormsErrorDialog1: TADGUIxFormsErrorDialog;
    ADGUIxFormsLoginDialog1: TADGUIxFormsLoginDialog;
    ADGUIxFormsAsyncExecuteDialog1: TADGUIxFormsAsyncExecuteDialog;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    stbDown: TStatusBar;
    pnlMain: TADGUIxFormsPanel;
    pnlMainFrame: TADGUIxFormsPanel;
    splDetailSpliter: TSplitter;
    Panel4: TADGUIxFormsPanel;
    Panel10: TADGUIxFormsPanel;
    pnlTraceTitle: TADGUIxFormsPanel;
    lblTraceTitle: TLabel;
    pnlTraceTitleBottomLine: TADGUIxFormsPanel;
    pnlDetails: TADGUIxFormsPanel;
    pnlDetailsWhite: TADGUIxFormsPanel;
    pnlDetailTitle: TADGUIxFormsPanel;
    lblDetailTitle: TLabel;
    pnlDetailTitleBottomLine: TADGUIxFormsPanel;
    Panel7: TADGUIxFormsPanel;
    pnlTopFrame: TADGUIxFormsPanel;
    pnlToolbar: TADGUIxFormsPanel;
    ToolBar: TToolBar;
    btnTestRun: TToolButton;
    btnTestStop: TToolButton;
    ToolButton11: TToolButton;
    ToolButton9: TToolButton;
    Panel17: TADGUIxFormsPanel;
    Panel8: TADGUIxFormsPanel;
    pnlObjectsTitle: TADGUIxFormsPanel;
    lblObjectsTitle: TLabel;
    pnlObjectsTitleBottomLine: TADGUIxFormsPanel;
    Splitter1: TSplitter;
    tvTestList: TTreeView;
    pnlRDBMS: TADGUIxFormsPanel;
    pnlRDBMSTitle: TADGUIxFormsPanel;
    Label3: TLabel;
    pnlRDBMSTitleLine: TADGUIxFormsPanel;
    chlBase: TCheckListBox;
    Panel21: TADGUIxFormsPanel;
    lvResultView: TListView;
    pcInfo: TADGUIxFormsPageControl;
    tshLog: TTabSheet;
    mmLog: TMemo;
    tshMessage: TTabSheet;
    mmErrors: TMemo;
    tshTrace: TTabSheet;
    mmTrace: TMemo;
    btnShowRDBMS: TSpeedButton;
    miViewExecLog: TMenuItem;
    miViewTraceLog: TMenuItem;
    SaveErrorLogAs2: TMenuItem;
    N2: TMenuItem;
    SelectAllFailedTests1: TMenuItem;
    Find1: TMenuItem;
    EditConnectionDefinitions1: TMenuItem;
    N1: TMenuItem;
    SelectAllSuccessful1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure acConnectionExitExecute(Sender: TObject);
    procedure acTestClearAllExecute(Sender: TObject);
    procedure acTestRunExecute(Sender: TObject);
    procedure acTestRunUpdate(Sender: TObject);
    procedure acTestSelAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvResultViewResize(Sender: TObject);
    procedure acTestSelOkTestsExecute(Sender: TObject);
    procedure acTestSelFailedTestsExecute(Sender: TObject);
    procedure tvTestListClick(Sender: TObject);
    procedure tvTestListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvResultViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lvResultViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvResultViewDblClick(Sender: TObject);
    procedure acLogOpenExecute(Sender: TObject);
    procedure acTestStopExecute(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acTestCheckSelInTreeExecute(Sender: TObject);
    procedure acLogSaveAsExecute(Sender: TObject);
    procedure tvTestListKeyPress(Sender: TObject; var Key: Char);
    procedure tvTestListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acTestSelForBaseExecute(Sender: TObject);
    procedure acConnectionEditDefExecute(Sender: TObject);
    procedure acConnectionSelectDefExecute(Sender: TObject);
    procedure acTestFindExecute(Sender: TObject);
    procedure acTestSearchAgainExecute(Sender: TObject);
    procedure stbDownResize(Sender: TObject);
    procedure btnShowRDBMSClick(Sender: TObject);
    procedure acExecuteStub(Sender: TObject);
  private
    FRDBMSPanelHeight: Integer;
    FHistoryFailList: TList;
    FTraceList: TStringList;
    FRegistry: TRegistry;
    FRunLog: TList;
    FStopping: Boolean;
    FRunning: Boolean;
    FQADir: String;
    // the service procedures
    procedure AdjustResultView;
    procedure FindTest;
    function GetNumInRunLog(AListItem: TListItem): Integer;
    procedure InitTreeNodes;
    procedure DoCheckTreeNode(ANode: TTreeNode);
    procedure ReadRegistry;
    procedure Run;
    procedure SetTestListChecked(AChecked: Boolean);
    procedure StoreResToFile;
    procedure WriteRegistry;
    procedure UpdateRDBMSPanel;
  end;

var
  frmADQAMain: TfrmADQAMain;

implementation

{$R *.dfm}

uses
  ShellAPI,
  ADQAConst, ADQAUtils, ADQAfConnOptions, ADQAfSearch,
  daADStanUtil, daADGUIxFormsfAbout;

var
  glMouseX, glMouseY: Integer;
  glMouseOnLViewX, glMouseOnLViewY: Integer;

{-------------------------------------------------------------------------------}
{ TfrmADQAMain                                                                  }
{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acConnectionExitExecute(Sender: TObject);
begin
  Close;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestClearAllExecute(Sender: TObject);
begin
  SetTestListChecked(False);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestRunExecute(Sender: TObject);

  procedure BeforeRunning;
  begin
    acConnectionEditDef.Enabled := False;
    acConnectionSelectDef.Enabled := False;
    acConnectionExit.Enabled := False;
    acTestFind.Enabled := False;
    acTestRun.Enabled := False;
    acTestStop.Enabled := True;
    acLogOpen.Enabled := False;
    acLogSaveAs.Enabled := False;
    acHelpAbout.Enabled := False;
  end;

  procedure AfterRunning;
  begin
    acConnectionEditDef.Enabled  := True;
    acConnectionSelectDef.Enabled := True;
    acConnectionExit.Enabled := True;
    acTestFind.Enabled  := True;
    acTestRun.Enabled  := True;
    acTestStop.Enabled := False;
    acLogOpen.Enabled := True;
    acLogSaveAs.Enabled := True;
    acHelpAbout.Enabled := True;
    acTestRunUpdate(Sender);
  end;

begin
  mmLog.Clear;
  lvResultView.Selected := nil;
  mmErrors.Clear;
  WriteRegistry;
  Application.ProcessMessages;
  BeforeRunning;
  Run;
  AfterRunning;
  StoreResToFile;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestRunUpdate(Sender: TObject);
var
  oNode: TTreeNode;
begin
  if FRunning then
    Exit;
  oNode := tvTestList.Items[0];
  while oNode <> nil do begin
    if oNode.StateIndex <> UNCHECKED then begin
      acTestRun.Enabled := True;
      Exit;
    end;
    oNode := oNode.getNext;
  end;
  acTestRun.Enabled := False;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestSelAllExecute(Sender: TObject);
begin
  SetTestListChecked(True);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestSelOkTestsExecute(Sender: TObject);
var
  i, j: Integer;
begin
  if FHistoryFailList.Count = 0 then
    Exit;
  for j := 0 to FRunLog.Count - 1 do
    if TTreeNode(FRunLog[j]).StateIndex <> CHECKED then begin
      TTreeNode(FRunLog[j]).StateIndex := CHECKED;
      CheckParGrayWhenCheck(TTreeNode(FRunLog[j]));
    end;
  for i := 0 to FHistoryFailList.Count - 1 do
    for j := 0 to FRunLog.Count - 1 do
      if FRunLog[j] = FHistoryFailList[i] then begin
        TTreeNode(FRunLog[j]).StateIndex := UNCHECKED;
        CheckParGrayWhenUncheck(TTreeNode(FRunLog[j]));
        break;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestSelFailedTestsExecute(Sender: TObject);
var
  i, j: Integer;
begin
  if FHistoryFailList.Count = 0 then
    Exit;
  SetTestListChecked(False);
  for i := 0 to FHistoryFailList.Count - 1 do
    for j := 0 to FRunLog.Count - 1 do
      if FRunLog[j] = FHistoryFailList[i] then begin
        TTreeNode(FRunLog[j]).StateIndex := CHECKED;
        CheckParGrayWhenCheck(TTreeNode(FRunLog[j]));
      end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.FormCreate(Sender: TObject);
var
  sModule, sProduct, sVersion, sVersionName, sCopyright, sInfo: String;
{$IFNDEF AnyDAC_D6}
  ModName: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6}
  sModule := GetModuleName(HInstance);
{$ELSE}
  SetString(sModule, ModName, GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
{$ENDIF}
  ADGetVersionInfo(sModule, sProduct, sVersion, sVersionName, sCopyright, sInfo);
  stbDown.Panels[0].Text := '';
  stbDown.Panels[1].Text := 'Version: ' + sVersion;
  stbDown.Panels[2].Text := sCopyright;

  FHistoryFailList := TList.Create;
  FRegistry := TRegistry.Create;
  FRunLog := TList.Create;
  FTraceList := TStringList.Create;
  FRDBMSPanelHeight := pnlRDBMS.Height;
  InitTreeNodes;
  ReadRegistry;
  acTestStop.Enabled := False;
  acTestRunUpdate(Sender);
  FQADir := GetCurrentDir;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteRegistry;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.FormDestroy(Sender: TObject);
begin
  FHistoryFailList.Free;
  FRegistry.Free;
  FRunLog.Free;
  FTraceList.Free;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.FormActivate(Sender: TObject);
begin
  if lvResultView.Column[0].Width > 1000 then begin
    lvResultView.Column[0].Width := 210;
    lvResultViewResize(nil);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.lvResultViewResize(Sender: TObject);
begin
  AdjustResultView;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.tvTestListClick(Sender: TObject);
var
  oNode: TTreeNode;
  HitTests: THitTests;
begin
  HitTests := tvTestList.GetHitTestInfoAt(glMouseX, glMouseY);
  if htOnStateIcon in HitTests then
    oNode := tvTestList.GetNodeAt(glMouseX, glMouseY)
  else
    Exit;
  DoCheckTreeNode(oNode);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.tvTestListKeyPress(Sender: TObject; var Key: Char);
begin
  if tvTestList.Selected = nil then
    Exit;
  if Key = ' ' then
    DoCheckTreeNode(tvTestList.Selected);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.tvTestListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  glMouseX := X;
  glMouseY := Y;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.tvTestListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if tvTestList.Selected = nil then
    Exit;
  if (Shift = [ssAlt]) then begin
    if Key = 40 then
      tvTestList.Selected.Expand(False);
    if Key = 38 then
      tvTestList.Selected.Collapse(False);
    Key := 18;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestSelForBaseExecute(Sender: TObject);
var
  i, j: Integer;
begin
  SetTestListChecked(False);
  with tvTestList do
    for i := 0 to Items.Count - 1 do
      if not Items[i].HasChildren then
        for j := 0 to chlBase.Items.Count - 1 do
          if (TADQATsInfo(Items[i].Data).RDBMS = TADRDBMSKind(j)) and
             chlBase.Checked[j] then begin
            Items[i].StateIndex := CHECKED;
            CheckParGrayWhenCheck(Items[i]);
          end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.lvResultViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  glMouseOnLViewX := X;
  glMouseOnLViewY := Y;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.lvResultViewDblClick(Sender: TObject);
var
  iRun: Integer;
  oListItem: TListItem;
begin
  oListItem := lvResultView.Selected;
  if oListItem = nil then
    Exit;
  iRun := GetNumInRunLog(oListItem);
  acTestClearAllExecute(nil);
  TTreeNode(FRunLog[iRun]).StateIndex := CHECKED;
  CheckParGrayWhenCheck(TTreeNode(FRunLog[iRun]));
  acTestRunExecute(nil);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.lvResultViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  pcInfo.ActivePageIndex := 1;
  mmErrors.Clear;
  if Item = nil then
    Exit;
  if Item.SubItems.Count > 0 then
    mmErrors.Text := Item.SubItems[0];
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acLogOpenExecute(Sender: TObject);
begin
  if not FileExists(FQADir + '\Log.txt') then
    Exit;
  ShellExecute(Handle, 'open', PChar(FQADir + '\Log.txt'), nil, nil, SW_SHOW);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acConnectionEditDefExecute(Sender: TObject);
begin
  if not FileExists(ADExpandStr(CONN_DEF_STORAGE)) then
    Exit;
  ShellExecute(Handle, 'open', PChar(ADExpandStr(CONN_DEF_STORAGE)), nil, nil, SW_SHOW);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestStopExecute(Sender: TObject);
begin
  FStopping := True;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestSearchAgainExecute(Sender: TObject);
begin
  if (tvTestList.Selected <> nil) and
     (tvTestList.Selected.AbsoluteIndex < tvTestList.Items.Count - 1) then
    tvTestList.Selected := tvTestList.Items[tvTestList.Selected.AbsoluteIndex + 1];
  FindTest;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acConnectionSelectDefExecute(Sender: TObject);
begin
  frmConnOptions.ShowModal;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestFindExecute(Sender: TObject);
begin
  with frmADQASearch do begin
    FindClicked := False;
    ShowModal;
    if FindClicked then
      FindTest;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acHelpAboutExecute(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acTestCheckSelInTreeExecute(Sender: TObject);
var
  i, iCheck: Integer;
  oListItem: TListItem;
begin
  if lvResultView.SelCount = 0 then
    Exit;
  oListItem := lvResultView.Selected;
  acTestClearAllExecute(nil);
  with lvResultView do
    for i := 0 to SelCount - 1 do begin
      if oListItem = nil then
        break;
      iCheck := GetNumInRunLog(oListItem);
      TTreeNode(FRunLog[iCheck]).StateIndex := CHECKED;
      CheckParGrayWhenCheck(TTreeNode(FRunLog[iCheck]));
      oListItem := GetNextItem(oListItem, sdBelow, [isSelected]);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acLogSaveAsExecute(Sender: TObject);
var
  sBackupName: String;
begin
  with dlgSave do
    if Execute then begin
      if FileExists(FileName) then begin
        sBackupName := ExtractFileName(FileName);
        sBackupName := ChangeFileExt(sBackupName, '.bak');
        if not RenameFile(FileName, sBackupName) then
          raise Exception.Create('Unable to create backup file.');
      end;
      CopyFile(PChar(FQADir + '\Log.txt'), PChar(FileName), True);
    end;
end;

// Service procedures
{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.AdjustResultView;
begin
  with lvResultView do
    if Width - Column[0].Width - 6 > 0 then
      Column[1].Width := Width - Column[0].Width - 6;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.FindTest;
var
  iIndex, iIndexTo: Integer;
  sSearchText: String;

  function Search: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    with tvTestList do
      for i := iIndex to iIndexTo do
        if Pos(sSearchText, AnsiUpperCase(Items[i].Text)) > 0 then begin
          with Items[i] do begin
            MakeVisible;
            Selected := True;
            Focused := True;
          end;
          Result := True;
          Exit;
        end;
  end;

  procedure NotFound;
  begin
    MessageDlg(TestNotFound(frmADQASearch.cbTestName.Text), mtInformation, [mbOk], 0);
  end;

begin
  with frmADQASearch do begin
    if cbTestName.Text = '' then
      Exit;
    sSearchText := AnsiUpperCase(cbTestName.Text);
    iIndex := 0;
    if tvTestList.Selected <> nil then
      iIndex := tvTestList.Selected.AbsoluteIndex
    else
      tvTestList.Selected := tvTestList.Items[0];
    iIndexTo := tvTestList.Items.Count - 1;
    if (not Search) and (iIndex > 0) then begin
      if MessageDlg(SearchFromBegin, mtInformation,
                    [mbYes, mbNo], 0) = Ord(mrYes) then begin
        iIndexTo := iIndex - 1;
        iIndex := 0;
        if not Search then
          NotFound;
      end;
    end
    else if not Search then
      NotFound;
  end;
end;

{-------------------------------------------------------------------------------}
function TfrmADQAMain.GetNumInRunLog(AListItem: TListItem): Integer;
var
  i: Integer;
  oListItem: TListItem;
begin
  Result := 0;
  for i := 1 to AListItem.Index do begin
    oListItem := lvResultView.Items[i];
    if (oListItem.Caption <> '') and (oListItem.Caption <> '...') then
      Inc(Result);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.InitTreeNodes;
var
  i, j: Integer;

  procedure AddRootGroupToTree(AGroup: TADQATestGroup; AParNode: TTreeNode);
  var
    i: Integer;
    oNode, oChNode: TTreeNode;
  begin
    if AParNode <> nil then
      oNode := tvTestList.Items.AddChild(AParNode, AGroup.Name)
    else begin
      oNode := nil;
      if tvTestList.Items.Count <> 0 then
        oNode := tvTestList.Items[0];
      while oNode <> nil do begin
        if oNode.Text = AGroup.Name then
          break;
        oNode := oNode.getNextSibling;
      end;
      if oNode = nil then
        oNode := tvTestList.Items.AddChild(AParNode, AGroup.Name);
    end;
    oNode.Data := AGroup;
    oNode.StateIndex := UNCHECKED;
    for i := 0 to AGroup.Children.Count - 1 do
      AddRootGroupToTree(AGroup.Children[i], oNode);
    for i := 0 to AGroup.Count - 1 do begin
      oChNode := tvTestList.Items.AddChild(oNode, AGroup.ADQATestNames[i]);
      oChNode.Data := AGroup[i];
      oChNode.StateIndex := UNCHECKED;
    end;
  end;

begin
  tvTestList.Items.BeginUpdate;
  try
    tvTestList.Items.Clear;
    for j := 0 to ADQAPackManager.Count - 1 do
      with ADQAPackManager[j] do
        for i := 0 to RootGroup.Children.Count - 1 do
          AddRootGroupToTree(RootGroup.Children[i], nil);
  finally
    tvTestList.Items.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.DoCheckTreeNode(ANode: TTreeNode);

  procedure UncheckChildren(ANode: TTreeNode);
  var
    oChildNode: TTreeNode;
  begin
    oChildNode := ANode.getFirstChild;
    while oChildNode <> nil do begin
      if oChildNode.StateIndex <> UNCHECKED then
        oChildNode.StateIndex := UNCHECKED;

      if oChildNode.HasChildren then
        UncheckChildren(oChildNode);

      oChildNode := oChildNode.getNextSibling;
    end;
  end;

  procedure CheckChildren(ANode: TTreeNode);
  var
    oChildNode: TTreeNode;
  begin
    oChildNode := ANode.getFirstChild;
    while oChildNode <> nil do begin
      if oChildNode.StateIndex <> CHECKED then
        oChildNode.StateIndex := CHECKED;

      if oChildNode.HasChildren then
        CheckChildren(oChildNode);

      oChildNode := oChildNode.getNextSibling;
    end;
  end;

begin
  if ANode.HasChildren then
    case ANode.StateIndex of
    CHECKED, GRAYED:
      begin
        ANode.StateIndex := UNCHECKED;
        UncheckChildren(ANode);
        CheckParGrayWhenUncheck(ANode);
      end;
    UNCHECKED:
      begin
        ANode.StateIndex := CHECKED;
        CheckChildren(ANode);
        CheckParGrayWhenCheck(ANode);
      end;
    end
  else
    case ANode.StateIndex of
    CHECKED:
      begin
        ANode.StateIndex := UNCHECKED;
        CheckParGrayWhenUncheck(ANode);
      end;
    UNCHECKED:
      begin
        ANode.StateIndex := CHECKED;
        CheckParGrayWhenCheck(ANode);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.ReadRegistry;
var
  iCnt, i: Integer;
  iExpand,
  iState: Byte;
  sExpand: String;
begin
  FRegistry.RootKey := HKEY_CURRENT_USER;
  if FRegistry.OpenKey('\Software\da-soft\AnyDAC\QA', False) then
    try
      if FRegistry.ValueExists('ShowLog') then
        acLogViewExec.Checked := FRegistry.ReadBool('ShowLog');

      if FRegistry.ValueExists('ErrorsToFile') then
        acLogWriteToFile.Checked := FRegistry.ReadBool('ErrorsToFile');

      iCnt := FRegistry.GetDataSize('Expanded');
      if iCnt <> -1 then begin
        if iCnt <> tvTestList.Items.Count + 1 then begin
          FRegistry.DeleteValue('Expanded');
          Exit;
        end;
      end
      else
        Exit;
      Dec(iCnt);
      sExpand := FRegistry.ReadString('Expanded');
      for i := 0 to iCnt - 1 do begin
        iExpand := Byte(sExpand[i + 1]);
        if iExpand >= 10 then begin
          iState  := iExpand div 10;
          iExpand := iExpand - iState * 10;
          tvTestList.Items[i].StateIndex := iState;
        end;
        tvTestList.Items[i].Expanded := Boolean(iExpand);
      end;
    finally
      FRegistry.CloseKey;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.Run;
var
  oNode: TTreeNode;
  i: Integer;
  iTm: LongWord;
  oListItem: TListItem;
  lShowed: Boolean;

  procedure RunTest(ANode: TTreeNode);
  var
    sTestName, sFullName: String;
    iTime: LongWord;

    function GetFullTestName(ANode: TTreeNode): String;
    var
      oNode: TTreeNode;
    begin
      Result := ANode.Text;
      oNode := ANode.Parent;
      while oNode <> nil do begin
        Result := oNode.Text + '/' + Result;
        oNode := oNode.Parent;
      end;
    end;

    procedure UpdateTraceLog;
    begin
      if acLogViewTrace.Checked then begin
        mmTrace.Lines.BeginUpdate;
        try
          mmTrace.Lines.AddStrings(FTraceList);
        finally
          mmTrace.Lines.EndUpdate;
        end;
      end;
    end;

    procedure UpdateExecLog(AStart: Boolean);
    begin
      if AStart then begin
        if acLogViewExec.Checked then begin
          mmLog.Lines.Add('---------------------------');
          mmLog.Lines.Add('Start test: ' + sFullName);
        end;
      end
      else
        if acLogViewExec.Checked then begin
          mmLog.Lines.Add('End test: ' + sFullName);
          mmLog.Lines.Add('Total execution time  = ' + IntToStr(iTime) + ' ms');
        end;
    end;

    procedure ScrollView;
    begin
      with lvResultView do
        if Items.Count > VisibleRowCount then
          Scroll(0, 17);
    end;

    procedure ShowTestResult;
    var
      oErrorList: TStringList;
      oPack: TADQATsHolderBase;
      j, iErrCount: Integer;
    begin
      oPack := TADQATestGroup(ANode.Parent.Data).Pack;
      iErrCount := oPack.LastErrorCount;
      lvResultView.Items.BeginUpdate;
      try
        if iErrCount > 0 then begin
          FHistoryFailList.Add(ANode);
          oErrorList := TStringList(oPack.InfoList.Last);
          oListItem.ImageIndex := FAILURE_INDEX;
          oListItem.SubItems.Add(oErrorList[0]);
          for j := 1 to oErrorList.Count - 1 do begin
            oListItem := lvResultView.Items.Add;
            oListItem.ImageIndex := -1;
            oListItem.Caption := '...';
            oListItem.SubItems.Add(oErrorList[j]);
            ScrollView;
          end;
        end
        else begin
          oListItem.SubItems.Add(OK_MSG);
          oListItem.ImageIndex := OK_INDEX;
        end;
      finally
        lvResultView.Items.EndUpdate;
      end;
    end;

  begin
    sFullName := GetFullTestName(ANode);
    sTestName := ANode.Parent.Text + '/' + ANode.Text;
    stbDown.Panels[0].Text := 'Executing - ' + sFullName;
    try
      oListItem := lvResultView.Items.Add;
      oListItem.ImageIndex := EXEC_INDEX;
      oListItem.Caption := sTestName;
      ScrollView;

      FRunLog.Add(ANode);
      UpdateExecLog(True);

      // run a test method
      iTime := GetTickCount;
      TADQATsInfo(ANode.Data).Run(FTraceList);
      iTime := GetTickCount - iTime;
      ShowTestResult;

      UpdateTraceLog;
      UpdateExecLog(False);
    except
      on E: Exception do begin
        oListItem.ImageIndex := FAILURE_INDEX;
        oListItem.SubItems.Add(ErrorOnTestExec(sTestName, E.Message));
        if acLogViewExec.Checked then
          mmLog.Lines.Add('Error on test: ' + sFullName);
      end;
    end;
  end;

  procedure RunChildren(ANode: TTreeNode);
  var
    oChildNode: TTreeNode;
  begin
    if FStopping then begin
      if acLogViewExec.Checked and not lShowed then begin
        mmLog.Lines.Add('');
        mmLog.Lines.Add(ExecAborted);
      end;
      lShowed := True;
      Exit;
    end;
    if not ANode.HasChildren then
      RunTest(ANode)
    else begin
      oChildNode := ANode.getFirstChild;
      while oChildNode <> nil do begin
        if oChildNode.StateIndex <> UNCHECKED then
          RunChildren(oChildNode);
        oChildNode := oChildNode.getNextSibling;
      end;
    end;
  end;

begin
  lvResultView.Items.BeginUpdate;
  lvResultView.Items.Clear;
  lvResultView.Items.EndUpdate;
  FRunLog.Clear;
  FHistoryFailList.Clear;
  FStopping := False;
  FRunning := True;
  lShowed := False;
  if acLogViewExec.Checked then
    mmLog.Clear;
  for i := 0 to ADQAPackManager.Count - 1 do
    ADQAPackManager[i].ClearHistory;
  iTm := GetTickCount;
  try
    oNode := tvTestList.Items[0];
    while oNode <> nil do begin
      RunChildren(oNode);
      oNode := oNode.getNextSibling;
    end;
  finally
    iTm := GetTickCount - iTm;
    stbDown.Panels[0].Text := 'Total execution time  = ' + FloatToStr(iTm / 1000) + ' s';
    FRunning := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.SetTestListChecked(AChecked: Boolean);
var
  oNode: TTreeNode;
begin
  oNode := tvTestList.Items[0];
  while oNode <> nil do begin
    if AChecked then
      oNode.StateIndex := CHECKED
    else
      oNode.StateIndex := UNCHECKED;
    oNode := oNode.GetNext;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.StoreResToFile;
var
  i, j, k: Integer;
  sString: String;
  oFile: TextFile;
begin
  if acLogWriteToFile.Checked then begin
    AssignFile(oFile, FQADir + '\Log.txt');
    Rewrite(oFile);
    try
      j := Length(lvResultView.Items[0].Caption);
      for i := 1 to lvResultView.Items.Count - 1 do
        if j < Length(lvResultView.Items[i].Caption) then
          j := Length(lvResultView.Items[i].Caption);

      for i := 0 to lvResultView.Items.Count - 1 do begin
        sString := lvResultView.Items[i].Caption;
        if (sString <> '') and (sString <> '...') then
          WriteLn(oFile, '-----------------------------------------------------' +
                  '------------------------------------------------------------');
        for k := Length(sString) to j do
          sString := sString + ' ';
        sString := sString + ' - ';
        if lvResultView.Items[i].SubItems.Count > 0 then
          sString := sString + lvResultView.Items[i].SubItems.Strings[0];
        WriteLn(oFile, sString);
      end;
    finally
      CloseFile(oFile);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.WriteRegistry;
var
  i: Integer;
  sExpand: AnsiString;
begin
  FRegistry.RootKey := HKEY_CURRENT_USER;
  if FRegistry.OpenKey('\Software\da-soft\AnyDAC\QA', True) then
    try
      SetLength(sExpand, tvTestList.Items.Count);
      for i := 0 to tvTestList.Items.Count - 1 do
        sExpand[i + 1] := Char(Byte(tvTestList.Items[i].Expanded) +
                          Byte(tvTestList.Items[i].StateIndex) * 10);
      FRegistry.WriteString('Expanded', sExpand);
      FRegistry.WriteBool('ShowLog', acLogViewExec.Checked);
      FRegistry.WriteBool('ErrorsToFile', acLogWriteToFile.Checked);
    finally
      FRegistry.CloseKey;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.UpdateRDBMSPanel;
begin
  if btnShowRDBMS.Caption = '1' then begin
    pnlRDBMS.Height := FRDBMSPanelHeight;
    btnShowRDBMS.Caption := '0';
    pnlRDBMSTitleLine.Visible := True;
  end
  else begin
    FRDBMSPanelHeight := pnlRDBMS.Height;
    pnlRDBMS.Height := pnlRDBMSTitle.Height;
    btnShowRDBMS.Caption := '1';
    pnlRDBMSTitleLine.Visible := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.stbDownResize(Sender: TObject);
begin
  with stbDown do
    Panels[0].Width := Width - (Panels[1].Width + Panels[2].Width);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.btnShowRDBMSClick(Sender: TObject);
begin
  UpdateRDBMSPanel;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADQAMain.acExecuteStub(Sender: TObject);
begin
  ;
end;

end.




