{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer main form                                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fExplorer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ExtCtrls, ActnList, ImgList, ToolWin, DBCtrls, AppEvnts,
  StdCtrls,
  daADStanIntf,
  daADGUIxFormsfAsync, daADGUIxFormsfLogin, daADGUIxFormsfError, 
    daADGUIxFormsWait, daADGUIxFormsControls,
  daADCompClient;

type
  TADExplorerNode = class;
  TADExplorerNodeClass = class of TADExplorerNode;
  TADExplorerNodeExpander = class;
  TfrmExplorer = class;

  {----------------------------------------------------------------------------}
  TADExplorerNodeStatuses = set of (
    nsExpandable, nsSettingsInvalidate,
    nsPassive, nsActive, nsInactive,
    nsEditable, nsNameEditable, nsDataEditable, nsInsertable, nsParentInsertable,
      nsWizard, nsTest,
    nsModified, nsInserted
  );

  TADExplorerNode = class(TObject)
  protected
    FObjectName: String;
    FParentNode: TADExplorerNode;
    FExpanderCalled: Boolean;
    FStatus: TADExplorerNodeStatuses;
    FTreeNode: TTreeNode;
    FImageIndex: Integer;
    function GetParent(AClass: TADExplorerNodeClass): TADExplorerNode;
    function GetStatus: TADExplorerNodeStatuses; virtual;
    function GetObjectName: String; virtual;
    function GetTemplateName: String; virtual;
    function GetExplorer: TfrmExplorer; virtual;
    function GetConnection: TADCustomConnection; virtual;
    function GetConnectionDefs: IADStanConnectionDefs; virtual;
    function GetConnectionDef: IADStanConnectionDef; virtual;
  public
    constructor Create;
    function CreateExpander: TADExplorerNodeExpander; virtual;
    function CreateFrame: TFrame; virtual;
    function CreateSubNode: TADExplorerNode; virtual;
    procedure Close; virtual;
    procedure Open; virtual;
    procedure Apply; virtual;
    procedure Delete; virtual;
    procedure Cancel; virtual;
    property ObjectName: String read GetObjectName write FObjectName;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
    property TemplateName: String read GetTemplateName;
    property ParentNode: TADExplorerNode read FParentNode;
    property Status: TADExplorerNodeStatuses read GetStatus;
    property TreeNode: TTreeNode read FTreeNode;
    property Explorer: TfrmExplorer read GetExplorer;
    property Connection: TADCustomConnection read GetConnection;
    property ConnectionDefs: IADStanConnectionDefs read GetConnectionDefs;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef;
  end;

  {----------------------------------------------------------------------------}
  TADExplorerNodeExpander = class(TObject)
  private
    FNode: TADExplorerNode;
    FImageIndex: Integer;
  public
    constructor Create(ANode: TADExplorerNode); virtual;
    destructor Destroy; override;
    function Next: TADExplorerNode; virtual; abstract;
    property Node: TADExplorerNode read FNode;
    property ImageIndex: Integer read FImageIndex write FImageIndex;
  end;

  {----------------------------------------------------------------------------}
  TfrmExplorer = class(TForm)
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miClose: TMenuItem;
    miOpen: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    stbDown: TStatusBar;
    Tool1: TMenuItem;
    Options1: TMenuItem;
    N2: TMenuItem;
    miNew: TMenuItem;
    miApply: TMenuItem;
    miDelete: TMenuItem;
    miCancel: TMenuItem;
    miRename: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ActionList1: TActionList;
    actFileOpen: TAction;
    actFileClose: TAction;
    actFileNew: TAction;
    actFileDelete: TAction;
    actFileRename: TAction;
    actFileApply: TAction;
    actFileCancel: TAction;
    actFileExit: TAction;
    actToolsOptions: TAction;
    actHelpAbout: TAction;
    pmTree: TPopupMenu;
    Open1: TMenuItem;
    Close1: TMenuItem;
    N3: TMenuItem;
    New1: TMenuItem;
    Delete1: TMenuItem;
    Rename1: TMenuItem;
    Apply1: TMenuItem;
    Cancel1: TMenuItem;
    ilMain: TImageList;
    ilStates: TImageList;
    ApplicationEvents1: TApplicationEvents;
    actFileRefresh: TAction;
    actFileRefresh1: TMenuItem;
    actToolsResetPage: TAction;
    Apply2: TMenuItem;
    actToolsImportBDE: TAction;
    actToolsMakeBDECompatible: TAction;
    ImportBDEaliases1: TMenuItem;
    MakeBDEcompatible1: TMenuItem;
    actToolsWizard: TAction;
    ConnectionWizard1: TMenuItem;
    ADGUIxFormsErrorDialog1: TADGUIxFormsErrorDialog;
    ADGUIxFormsLoginDialog1: TADGUIxFormsLoginDialog;
    ADGUIxFormsAsyncExecuteDialog1: TADGUIxFormsAsyncExecuteDialog;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    pnlMain: TADGUIxFormsPanel;
    Panel3: TADGUIxFormsPanel;
    Panel4: TADGUIxFormsPanel;
    pnlRight: TADGUIxFormsPanel;
    Splitter1: TSplitter;
    Panel6: TADGUIxFormsPanel;
    Panel7: TADGUIxFormsPanel;
    pnlInstructionName: TADGUIxFormsPanel;
    lblCurrentItem: TLabel;
    pnlTopFrame: TADGUIxFormsPanel;
    pnlToolbar: TADGUIxFormsPanel;
    tlbMain: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton10: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton8: TToolButton;
    DBNavigator1: TDBNavigator;
    Panel5: TADGUIxFormsPanel;
    tvLeft: TTreeView;
    ilTree: TImageList;
    actToolsTest: TAction;
    estconnection1: TMenuItem;
    Connection1: TMenuItem;
    procedure miOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure tvLeftExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvLeftChange(Sender: TObject; Node: TTreeNode);
    procedure Exit1Click(Sender: TObject);
    procedure tvLeftDeletion(Sender: TObject; Node: TTreeNode);
    procedure actToolsOptionsExecute(Sender: TObject);
    procedure tvLeftEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure miNewClick(Sender: TObject);
    procedure tvLeftChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure miApplyClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miRenameClick(Sender: TObject);
    procedure miCancelClick(Sender: TObject);
    procedure tvLeftEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure tvLeftExpanded(Sender: TObject; Node: TTreeNode);
    procedure actFileOpenUpdate(Sender: TObject);
    procedure actFileCloseUpdate(Sender: TObject);
    procedure actFileNewUpdate(Sender: TObject);
    procedure actFileDeleteUpdate(Sender: TObject);
    procedure actFileRenameUpdate(Sender: TObject);
    procedure actFileApplyUpdate(Sender: TObject);
    procedure actFileCancelUpdate(Sender: TObject);
    procedure tvLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvLeftEnter(Sender: TObject);
    procedure tvLeftKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stbDownResize(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure actFileRefreshExecute(Sender: TObject);
    procedure actFileRefreshUpdate(Sender: TObject);
    procedure actToolsResetPageUpdate(Sender: TObject);
    procedure actToolsResetPageExecute(Sender: TObject);
    procedure actToolsImportBDEUpdate(Sender: TObject);
    procedure actToolsImportBDEExecute(Sender: TObject);
    procedure actToolsMakeBDECompatibleUpdate(Sender: TObject);
    procedure actToolsMakeBDECompatibleExecute(Sender: TObject);
    procedure actToolsWizardExecute(Sender: TObject);
    procedure actToolsWizardUpdate(Sender: TObject);
    procedure actToolsTestUpdate(Sender: TObject);
    procedure actToolsTestExecute(Sender: TObject);
  private
    { Private declarations }
    FWaitCount: Integer;
    FCurrentFrame: TFrame;
    FSkipExpander: Boolean;
    // options
    FHierarchy, FPrevHierarchy: String;
    FConfirmations: Boolean;
    FDefinitionFileName: String;
    FTracing: Boolean;
    FDblclickMemo: Boolean;
    FBDEEnableBCD: Boolean;
    FBDEEnableIntegers: Boolean;
    FBDEOverwriteConnectionDef: Boolean;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ClearTree;
    procedure InitTree;
    procedure OptionsChanged;
    function BuildUniqueName(AParentNode: TTreeNode; const ATemplate: String): String;
    procedure CheckName(AParentNode: TTreeNode; ANode: TADExplorerNode;
      const ANewName: String);
    function IsPropertyPageModifed: Boolean;
    procedure SaveChanges(AOnlySave: Boolean);
    procedure UpdatePropertyPageData(ANode: TADExplorerNode);
    procedure UpdatePropertyPageState(ANode: TADExplorerNode);
    procedure UpdateStatusBar(ANode: TADExplorerNode);
    procedure UpdateNodeImage(ANode: TADExplorerNode);
    function GetSelectedNode: TADExplorerNode;
    procedure MarkAsModified(AOnlySave: Boolean);
  public
    { Public declarations }
    procedure BeginWait;
    procedure EndWait;
    property Hierarchy: String read FHierarchy;
    property Confirmations: Boolean read FConfirmations;
    property DefinitionFileName: String read FDefinitionFileName;
    property DblclickMemo: Boolean read FDblclickMemo write FDblclickMemo;
    property BDEEnableBCD: Boolean read FBDEEnableBCD write FBDEEnableBCD;
    property BDEEnableIntegers: Boolean read FBDEEnableIntegers write FBDEEnableIntegers;
    property BDEOverwriteConnectionDef: Boolean read FBDEOverwriteConnectionDef write FBDEOverwriteConnectionDef;
  end;

var
  frmExplorer: TfrmExplorer;
  FADExplorerWithSQL: Boolean = False;

implementation

Uses
  Registry,
  daADStanConst, daADStanUtil, daADPhysIntf,
  fBaseDesc, fRootDesc, fConnDefDesc, fOptions, fBlob, fImpAliases,
  fMakeBDECompatible,
  daADGUIxFormsfAbout;

{$R *.DFM}

{----------------------------------------------------------------------------}
{ TfrmExplorer                                                               }
{----------------------------------------------------------------------------}
procedure TfrmExplorer.FormCreate(Sender: TObject);
var
  sModule, sProduct, sVersion, sVersionName, sCopyright, sInfo: String;
{$IFNDEF AnyDAC_D6}
  ModName: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
  Application.ShowHint := True;
{$IFDEF AnyDAC_D6}
  sModule := GetModuleName(HInstance);
{$ELSE}
  SetString(sModule, ModName, GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
{$ENDIF}
  ADGetVersionInfo(sModule, sProduct, sVersion, sVersionName, sCopyright, sInfo);
  stbDown.Panels[3].Text := 'Version: ' + sVersion;
  stbDown.Panels[4].Text := sCopyright;
  if FADExplorerWithSQL then begin
    TPanel(DBNavigator1).Color := clWhite;
    Caption := 'AnyDAC Explorer';
  end
  else begin
    DBNavigator1.Visible := False;
    Caption := 'AnyDAC Administrator';
  end;
  FDefinitionFileName := ChangeFileExt(sModule, '.ini');
  try
    LoadSettings;
  except
    SaveSettings;
  end;
  InitTree;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.FormDestroy(Sender: TObject);
begin
  ClearTree;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.stbDownResize(Sender: TObject);
begin
  with stbDown do
    Panels[0].Width := Width - (Panels[1].Width + Panels[2].Width +
      Panels[3].Width + Panels[4].Width);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.ApplicationEvents1Hint(Sender: TObject);
begin
  stbDown.Panels[0].Text := Application.Hint;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.LoadSettings;
var
  oReg: TRegistry;
begin
  oReg := TRegistry.Create;
  try
    oReg.Access := KEY_READ;
    oReg.RootKey := HKEY_CURRENT_USER;
    if oReg.OpenKey(S_AD_CfgKeyName + '\Explorer', False) then begin
      FHierarchy := oReg.ReadString('Hierarchy');
      FConfirmations := oReg.ReadBool('Confirmations');
      FTracing := oReg.ReadBool('Tracing');
      FDblclickMemo := oReg.ReadBool('DblclickMemo');
      FBDEEnableBCD := oReg.ReadBool('BDEEnableBCD');
      FBDEEnableIntegers := oReg.ReadBool('BDEEnableIntegers');
      FBDEOverwriteConnectionDef := oReg.ReadBool('BDEOverwriteConnectionDef');
    end
    else begin
      FHierarchy := 'ByObjType';
      FConfirmations := True;
      FTracing := False;
      FDblclickMemo := True;
      FBDEEnableBCD := False;
      FBDEEnableIntegers := False;
      FBDEOverwriteConnectionDef := False;
    end;
    OptionsChanged;
  finally
    oReg.Free;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.SaveSettings;
var
  oReg: TRegistry;
begin
  oReg := TRegistry.Create;
  try
    oReg.Access := KEY_WRITE;
    oReg.RootKey := HKEY_CURRENT_USER;
    if oReg.OpenKey(S_AD_CfgKeyName + '\Explorer', True) then begin
      oReg.WriteString('Hierarchy', FHierarchy);
      oReg.WriteBool('Confirmations', FConfirmations);
      oReg.WriteBool('Tracing', FTracing);
      oReg.WriteBool('DblclickMemo', FDblclickMemo);
      oReg.WriteBool('BDEEnableBCD', FBDEEnableBCD);
      oReg.WriteBool('BDEEnableIntegers', FBDEEnableIntegers);
      oReg.WriteBool('BDEOverwriteConnectionDef', FBDEOverwriteConnectionDef);
    end;
  finally
    oReg.Free;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.BeginWait;
begin
  Inc(FWaitCount);
  if FWaitCount = 1 then begin
    stbDown.Panels[0].Text := 'Working ...';
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.EndWait;
begin
  if FWaitCount > 0 then begin
    Dec(FWaitCount);
    if FWaitCount = 0 then begin
      stbDown.Panels[0].Text := '';
      Screen.Cursor := crDefault;
      Application.ProcessMessages;
    end;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.ClearTree;
begin
  BeginWait;
  try
    UpdatePropertyPageData(nil);
    UpdateStatusBar(nil);
    tvLeft.Items.Clear;
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.InitTree;
var
  oRootNode: TADRootNode;
begin
  tvLeft.Items.BeginUpdate;
  try
    ClearTree;
    oRootNode := TADRootNode.Create(Self);
    oRootNode.FTreeNode := tvLeft.Items.AddObject(nil, oRootNode.ObjectName, oRootNode);
    oRootNode.FTreeNode.HasChildren := True;
    UpdateNodeImage(oRootNode);
  finally
    tvLeft.Items.EndUpdate;
  end;
end;

{----------------------------------------------------------------------------}
function TfrmExplorer.IsPropertyPageModifed: Boolean;
begin
  Result := False;
  if FCurrentFrame <> nil then
    with FCurrentFrame as TfrmBaseDesc do begin
      PostChanges;
      if ([nsEditable, nsDataEditable] * ExplNode.Status = [nsEditable, nsDataEditable]) and
         Modified then
        Result := True;
    end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.MarkAsModified(AOnlySave: Boolean);
begin
  with FCurrentFrame as TfrmBaseDesc do begin
    ExplNode.FStatus := ExplNode.FStatus + [nsModified];
    if nsInserted in ExplNode.FStatus then
      ExplNode.TreeNode.StateIndex := 2
    else
      ExplNode.TreeNode.StateIndex := 1;
    if not AOnlySave then begin
      UpdatePropertyPageData(ExplNode);
      UpdateStatusBar(ExplNode);
    end;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.SaveChanges(AOnlySave: Boolean);
begin
  if IsPropertyPageModifed then
    with FCurrentFrame as TfrmBaseDesc do begin
      SaveData;
      MarkAsModified(AOnlySave);
    end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.UpdatePropertyPageData(ANode: TADExplorerNode);
var
  oFrame: TFrame;
  oMenuItem: TMenuItem;
  i: Integer;
begin
  BeginWait;
  try
    oFrame := nil;
    pnlRight.DisableAlign;
    try
      if (FCurrentFrame <> nil) and
         ((ANode = nil) or
          (ANode.ClassType <> (FCurrentFrame as TfrmBaseDesc).ExplNode.ClassType)) then begin
        oFrame := FCurrentFrame;
        FCurrentFrame := nil;
        with oFrame as TfrmBaseDesc do
          if GetMenu <> nil then
            mmMain.UnMerge(GetMenu);
        while pmTree.Items.Count > 8 do
          pmTree.Items[pmTree.Items.Count - 1].Free;
      end;
      if ANode <> nil then begin
        if FCurrentFrame = nil then begin
          FCurrentFrame := ANode.CreateFrame;
          if FCurrentFrame <> nil then begin
            FCurrentFrame.Align := alClient;
            FCurrentFrame.BoundsRect := pnlRight.ClientRect;
            FCurrentFrame.Parent := pnlRight;
            with FCurrentFrame as TfrmBaseDesc do begin
              ExplNode := ANode;
              ResetState(True);
              if GetMenu <> nil then
                mmMain.Merge(GetMenu);
              if GetPopup <> nil then begin
                pmTree.Items.Add(NewLine);
                for i := 0 to GetPopup.Items.Count - 1 do begin
                  oMenuItem := TMenuItem.Create(nil);
                  with oMenuItem do begin
                    Caption := GetPopup.Items[i].Caption;
                    ShortCut := GetPopup.Items[i].ShortCut;
                    OnClick := GetPopup.Items[i].OnClick;
                    HelpContext := GetPopup.Items[i].HelpContext;
                    Checked := GetPopup.Items[i].Checked;
                    Enabled := GetPopup.Items[i].Enabled;
                  end;
                  pmTree.Items.Add(oMenuItem);
                end;
              end;
            end;
          end;
        end
        else with FCurrentFrame as TfrmBaseDesc do begin
          ExplNode := ANode;
          ResetState(True);
        end;
      end;
    finally
      oFrame.Free;
      pnlRight.EnableAlign;
    end;
    Application.ProcessMessages;
    if FCurrentFrame <> nil then
      with FCurrentFrame as TfrmBaseDesc do
        LoadData;
    UpdatePropertyPageState(ANode);
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.UpdatePropertyPageState(ANode: TADExplorerNode);
var
  sName: String;
  lRO: Boolean;
begin
  lRO := True;
  if FCurrentFrame <> nil then
    with FCurrentFrame as TfrmBaseDesc do
      if (ANode = ExplNode) and (ANode <> nil) then begin
        ReadOnly := (nsActive in ExplNode.Status) or
          ([nsEditable, nsDataEditable] * ExplNode.Status <>
           [nsEditable, nsDataEditable]);
        lRO := ReadOnly;
        ResetState(False);
      end;
  if ANode <> nil then begin
    sName := ANode.ObjectName;
    if lRO then
      sName := sName + ' (Read Only)';
  end
  else
    sName := '';
  lblCurrentItem.Caption := sName;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FCurrentFrame <> nil then
    with FCurrentFrame as TfrmBaseDesc do
      DoKeyDown(Key, Shift);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.UpdateStatusBar(ANode: TADExplorerNode);
var
  oCurNode: TADExplorerNode;
begin
  if FCurrentFrame <> nil then
    with FCurrentFrame as TfrmBaseDesc do
      oCurNode := ExplNode
  else
    oCurNode := nil;
  if oCurNode = ANode then begin
    if (ANode <> nil) and (ANode.Connection <> nil) then
      with ANode.Connection do
        if Connected then
          with ResultConnectionDef do
            stbDown.Panels[2].Text := UserName + '/' + Database
        else
          stbDown.Panels[2].Text := 'disconnected'
    else
      stbDown.Panels[2].Text := '';
    if (ANode <> nil) and (nsModified in ANode.Status) then
      stbDown.Panels[1].Text := 'modified'
    else
      stbDown.Panels[1].Text := '';
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.UpdateNodeImage(ANode: TADExplorerNode);
begin
  if ANode.FImageIndex <> - 1 then begin
    ANode.TreeNode.ImageIndex := ANode.FImageIndex;
    ANode.TreeNode.SelectedIndex := ANode.FImageIndex;
  end
  else begin
    ANode.TreeNode.ImageIndex := ilTree.Count - 1;
    ANode.TreeNode.SelectedIndex := ilTree.Count - 1;
  end;
end;

{----------------------------------------------------------------------------}
function TfrmExplorer.BuildUniqueName(AParentNode: TTreeNode;
  const ATemplate: String): String;
var
  iIndex, i: Integer;
  lDone: Boolean;
  oNode: TADExplorerNode;
begin
  iIndex := 0;
  lDone := False;
  while not lDone do begin
    Inc(iIndex);
    lDone := True;
    Result := ATemplate + IntToStr(iIndex);
    for i := 0 to AParentNode.Count - 1 do begin
      oNode := TADExplorerNode(AParentNode.Item[i].Data);
      if AnsiCompareText(oNode.ObjectName, Result) = 0 then begin
        lDone := False;
        Break;
      end;
    end;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.CheckName(AParentNode: TTreeNode;
  ANode: TADExplorerNode; const ANewName: String);
var
  i: Integer;
  oNode: TADExplorerNode;
begin
  if ANode.ObjectName = '' then
    raise Exception.Create('Object name cant be empty');
  if AParentNode <> nil then
    for i := 0 to AParentNode.Count - 1 do begin
      oNode := TADExplorerNode(AParentNode.Item[i].Data);
      if (ANode <> oNode) and (AnsiCompareText(oNode.ObjectName, ANewName) = 0) then
        raise Exception.Create('Object name dublicated');
    end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  CThreshold = 10;
var
  oNode: TTreeNode;
  startPnt,
  endPnt: TPoint;
  Msg: TMsg;
  lDrag: boolean;
begin
  oNode := tvLeft.GetNodeAt(X, Y);
  if Button = mbRight then begin
    if oNode <> nil then
      oNode.Selected := True;
    with tvLeft.ClientToScreen(Point(X, Y)) do
      pmTree.Popup(X, Y);
  end
  else if Button = mbLeft then begin
    lDrag := False;
    GetCursorpos(startPnt);
    while (GetAsyncKeyState(VK_LBUTTON) < 0) and GetMessage(Msg, 0, 0, 0) do begin
      if Msg.message = WM_MOUSEMOVE then begin
        GetCursorPos(endPnt);
        if (Abs(endPnt.x - startPnt.x) > CThreshold) or
           (Abs(endPnt.y - startPnt.y) > CThreshold) then begin
          lDrag := True;
          Break;
        end;
      end;
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
    if lDrag then
      tvLeft.BeginDrag(False, CThreshold);
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) and (Shift = []) then begin
    if tvLeft.Selected <> nil then
      tvLeft.Selected.EditText;
    Key := 0;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftDeletion(Sender: TObject;
  Node: TTreeNode);
begin
  TADExplorerNode(Node.Data).Free;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  oNode, oSubNode: TADExplorerNode;
  oExp: TADExplorerNodeExpander;
  R: TRect;
begin
  if FSkipExpander then
    Exit;
  BeginWait;
  try
    try
      oNode := TADExplorerNode(Node.Data);
      SaveChanges(False);
      if (oNode.FStatus * [nsModified, nsInserted] <> []) then
        if not FConfirmations or
           (MessageDlg('To continue you should apply changes to node. Do you want ?',
                       mtConfirmation, mbOKCancel, -1) = mrOK) then
          miApplyClick(nil)
        else
          Exit;
      if not oNode.FExpanderCalled then begin
        oExp := oNode.CreateExpander;
        oNode.FExpanderCalled := True;
        if oExp <> nil then
          try
            tvLeft.Items.BeginUpdate;
            try
              while True do begin
                oSubNode := oExp.Next;
                if oSubNode = nil then
                  Break;
                oSubNode.FParentNode := oNode;
                oSubNode.FTreeNode := tvLeft.Items.AddChildObject(Node, oSubNode.ObjectName, oSubNode);
                oSubNode.FTreeNode.HasChildren := nsExpandable in oSubNode.Status;
                UpdateNodeImage(oSubNode);
              end;
            finally
              tvLeft.Items.EndUpdate;
            end;
          finally
            oExp.Free;
          end;
        Node.HasChildren := Node.Count > 0;
        if not Node.HasChildren then begin
          R := Node.DisplayRect(False);
          InvalidateRect(tvLeft.Handle, @R, True);
        end;
      end;
      oNode.Open;
      UpdatePropertyPageState(oNode);
      UpdateStatusBar(oNode);
    except
      Application.HandleException(nil);
      AllowExpansion := False;
    end;
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftExpanded(Sender: TObject;
  Node: TTreeNode);
var
  oNode: TADExplorerNode;
begin
  if FSkipExpander then
    Exit;
  oNode := TADExplorerNode(Node.Data);
  UpdatePropertyPageState(oNode);
  UpdateStatusBar(oNode);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  SaveChanges(False);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftChange(Sender: TObject;
  Node: TTreeNode);
var
  oNode: TADExplorerNode;
begin
  oNode := TADExplorerNode(Node.Data);
  UpdatePropertyPageData(oNode);
  UpdateStatusBar(oNode);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftEnter(Sender: TObject);
begin
  SaveChanges(False);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
var
  oNode: TADExplorerNode;
begin
  SaveChanges(False);
  oNode := TADExplorerNode(Node.Data);
  AllowEdit := oNode.Status * [nsEditable, nsNameEditable] =
    [nsEditable, nsNameEditable];
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.tvLeftEdited(Sender: TObject;
  Node: TTreeNode; var S: String);
var
  oNode: TADExplorerNode;
begin
  oNode := TADExplorerNode(Node.Data);
  if Node.Parent <> nil then
    try
      CheckName(Node.Parent, oNode, S);
    except
      Node.Text := oNode.ObjectName;
      raise;
    end;
  oNode.FObjectName := S;
  oNode.FStatus := oNode.FStatus + [nsModified];
  if nsInserted in oNode.FStatus then
    Node.StateIndex := 2
  else
    Node.StateIndex := 1;
  UpdatePropertyPageData(oNode);
  UpdateStatusBar(oNode);
end;

{----------------------------------------------------------------------------}
function TfrmExplorer.GetSelectedNode: TADExplorerNode;
begin
  if tvLeft.Selected <> nil then
    Result := TADExplorerNode(tvLeft.Selected.Data)
  else
    Result := nil;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileOpenUpdate(Sender: TObject);
begin
  actFileOpen.Enabled := (GetSelectedNode <> nil) and
    (nsInactive in GetSelectedNode.Status);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miOpenClick(Sender: TObject);
var
  oNode: TADExplorerNode;
begin
  BeginWait;
  try
    if tvLeft.Selected <> nil then begin
      oNode := TADExplorerNode(tvLeft.Selected.Data);
      if nsInactive in oNode.Status then begin
        SaveChanges(False);
        oNode.Open;
        tvLeft.Selected.Expand(False);
        UpdatePropertyPageState(oNode);
        UpdateStatusBar(oNode);
      end;
    end;
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileCloseUpdate(Sender: TObject);
begin
  actFileClose.Enabled := (GetSelectedNode <> nil) and
    (nsActive in GetSelectedNode.Status);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miCloseClick(Sender: TObject);
var
  oNode: TADExplorerNode;
begin
  BeginWait;
  try
    if tvLeft.Selected <> nil then begin
      oNode := TADExplorerNode(tvLeft.Selected.Data);
      if nsActive in oNode.Status then begin
        with tvLeft.Selected do begin
          DeleteChildren;
          HasChildren := nsExpandable in oNode.Status;
        end;
        with oNode do begin
          Close;
          FExpanderCalled := False;
        end;
        UpdatePropertyPageState(oNode);
        UpdateStatusBar(oNode);
      end;
    end;
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileNewUpdate(Sender: TObject);
begin
  actFileNew.Enabled := (GetSelectedNode <> nil) and (
    (nsInsertable in GetSelectedNode.Status) or
    (nsParentInsertable in GetSelectedNode.Status)
  );
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miNewClick(Sender: TObject);
var
  oCurNode, oSubNode: TADExplorerNode;
  oCurTreeNode, oNewTreeNode: TTreeNode;
begin
  BeginWait;
  try
    oCurTreeNode := tvLeft.Selected;
    if oCurTreeNode <> nil then begin
      oCurNode := TADExplorerNode(oCurTreeNode.Data);
      if nsParentInsertable in oCurNode.Status then begin
        oCurNode := oCurNode.ParentNode;
        oCurTreeNode := oCurTreeNode.Parent;
      end;
      if nsInsertable in oCurNode.Status then begin
        oCurTreeNode.Expanded := True;
        oSubNode := oCurNode.CreateSubNode;
        if oSubNode <> nil then begin
          oSubNode.FObjectName := BuildUniqueName(oCurTreeNode, oSubNode.TemplateName);
          oSubNode.FStatus := oSubNode.FStatus + [nsModified, nsInserted];
          oSubNode.FParentNode := oCurNode;
          if oCurTreeNode.Count = 0 then begin
            FSkipExpander := True;
            try
              oCurTreeNode.HasChildren := True;
              oCurTreeNode.Expanded := True;
            finally
              FSkipExpander := False;
            end;
          end
          else if not oCurTreeNode.Expanded then begin
            oCurTreeNode.HasChildren := True;
            oCurTreeNode.Expanded := True;
          end;
          oNewTreeNode := tvLeft.Items.AddChildObject(oCurTreeNode, oSubNode.ObjectName, oSubNode);
          oNewTreeNode.HasChildren := nsExpandable in oSubNode.Status;
          oNewTreeNode.Selected := True;
          oNewTreeNode.StateIndex := 2;
          oSubNode.FTreeNode := oNewTreeNode;
          oNewTreeNode.EditText;
          UpdateNodeImage(oSubNode);
        end;
      end;
    end;
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileApplyUpdate(Sender: TObject);
begin
  actFileApply.Enabled := (GetSelectedNode <> nil) and
    ([nsEditable, nsModified] * GetSelectedNode.Status = [nsEditable, nsModified]);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miApplyClick(Sender: TObject);
var
  oCurNode: TADExplorerNode;
  oCurTreeNode: TTreeNode;
begin
  BeginWait;
  try
    oCurTreeNode := tvLeft.Selected;
    if oCurTreeNode <> nil then begin
      oCurNode := TADExplorerNode(oCurTreeNode.Data);
      if nsModified in oCurNode.Status then begin
        SaveChanges(True);
        if oCurTreeNode.Parent <> nil then
          CheckName(oCurTreeNode.Parent, oCurNode, oCurNode.ObjectName);
        oCurNode.Apply;
        oCurNode.FStatus := oCurNode.FStatus - [nsModified, nsInserted];
        oCurTreeNode.StateIndex := -1;
        UpdatePropertyPageData(oCurNode);
        UpdatePropertyPageState(oCurNode);
        UpdateStatusBar(oCurNode);
      end;
    end;
  finally
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileCancelUpdate(Sender: TObject);
begin
  actFileCancel.Enabled := (GetSelectedNode <> nil) and
    ([nsEditable, nsModified] * GetSelectedNode.Status = [nsEditable, nsModified]);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miCancelClick(Sender: TObject);
var
  oCurNode: TADExplorerNode;
  oCurTreeNode: TTreeNode;
  lPrevConf: Boolean;
begin
  oCurTreeNode := tvLeft.Selected;
  if oCurTreeNode <> nil then
    if not FConfirmations or
       (MessageDlg('Do you want to cancel editings for ''' + oCurTreeNode.Text + ''' ?',
                   mtConfirmation, mbOKCancel, -1) = mrOK) then begin
      BeginWait;
      try
        oCurNode := TADExplorerNode(oCurTreeNode.Data);
        if [nsModified, nsInserted] * oCurNode.Status = [nsModified, nsInserted] then begin
          lPrevConf := FConfirmations;
          FConfirmations := False;
          try
            miDeleteClick(nil);
          finally
            FConfirmations := lPrevConf;
          end;
        end
        else if nsModified in oCurNode.Status then begin
          oCurNode.Cancel;
          oCurNode.FStatus := oCurNode.FStatus - [nsModified, nsInserted];
          oCurNode.FExpanderCalled := False;
          oCurTreeNode.DeleteChildren;
          oCurTreeNode.HasChildren := nsExpandable in oCurNode.Status;
          oCurTreeNode.StateIndex := -1;
          oCurTreeNode.Text := oCurNode.ObjectName;
          UpdatePropertyPageData(oCurNode);
          UpdatePropertyPageState(oCurNode);
          UpdateStatusBar(oCurNode);
        end;
      finally
        EndWait;
      end;
    end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileDeleteUpdate(Sender: TObject);
begin
  actFileDelete.Enabled := tvLeft.Focused and 
    (GetSelectedNode <> nil) and
    (GetSelectedNode.ParentNode <> nil) and
    (nsInsertable in GetSelectedNode.ParentNode.Status);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miDeleteClick(Sender: TObject);
var
  oCurNode: TADExplorerNode;
  oCurTreeNode: TTreeNode;
begin
  oCurTreeNode := tvLeft.Selected;
  if oCurTreeNode <> nil then
    if not FConfirmations or
       (MessageDlg('Do you want to delete ''' + oCurTreeNode.Text + ''' ?',
                   mtConfirmation, mbOKCancel, -1) = mrOK) then begin
      BeginWait;
      try
        oCurNode := TADExplorerNode(oCurTreeNode.Data);
        if (oCurNode.ParentNode <> nil) and (nsInsertable in oCurNode.ParentNode.Status) then begin
          if oCurTreeNode.getPrevSibling <> nil then
            oCurTreeNode.getPrevSibling.Selected := True
          else if oCurTreeNode.getNextSibling <> nil then
            oCurTreeNode.getNextSibling.Selected := True
          else if oCurTreeNode.Parent <> nil then
            oCurTreeNode.Parent.Selected := True;
          oCurNode.Close;
          oCurNode.Delete;
          oCurTreeNode.Free;
        end;
      finally
        EndWait;
      end;
    end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileRenameUpdate(Sender: TObject);
begin
  actFileRename.Enabled :=
    tvLeft.Focused and (GetSelectedNode <> nil) and
    ([nsEditable, nsNameEditable] * GetSelectedNode.Status =
     [nsEditable, nsNameEditable]);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.miRenameClick(Sender: TObject);
begin
  if tvLeft.Selected <> nil then
    tvLeft.Selected.EditText;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileRefreshUpdate(Sender: TObject);
begin
  actFileRefresh.Enabled :=
    (tvLeft.Selected <> nil) and (tvLeft.Selected.Parent <> nil);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actFileRefreshExecute(Sender: TObject);
var
  sID: String;
  lExpanded: Boolean;
  oNode: TADExplorerNode;
  oTvNode, oTvCloseNode: TTreeNode;
begin
  BeginWait;
  tvLeft.Items.BeginUpdate;
  try
    if (tvLeft.Selected <> nil) and (tvLeft.Selected.Parent <> nil) then begin
      oTvNode := tvLeft.Selected.Parent;
      oNode := TADExplorerNode(oTvNode.Data);
      with tvLeft.Selected do begin
        sID := Text;
        lExpanded := Expanded;
      end;
      UpdatePropertyPageData(nil);
      UpdateStatusBar(nil);
      with oTvNode do begin
        DeleteChildren;
        HasChildren := nsExpandable in oNode.Status;
      end;
      with oNode do begin
        Close;
        FExpanderCalled := False;
      end;
      oTvNode.Expanded := True;
      oTvNode := oTvNode.getFirstChild;
      oTvCloseNode := nil;
      while (oTvNode <> nil) and (AnsiCompareText(oTvNode.Text, sID) <> 0) do begin
        if (oTvCloseNode = nil) and (AnsiCompareText(oTvNode.Text, sID) > 0) then
          oTvCloseNode := oTvNode;
        oTvNode := oTvNode.getNextSibling;
      end;
      if oTvNode <> nil then begin
        oTvNode.Selected := True;
        oTvNode.Expanded := lExpanded;
      end
      else if oTvCloseNode <> nil then
        oTvCloseNode.Selected := True;
    end;
  finally
    tvLeft.Items.EndUpdate;
    EndWait;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.Exit1Click(Sender: TObject);
begin
  Close;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsWizardUpdate(Sender: TObject);
begin
  actToolsWizard.Enabled := (GetSelectedNode <> nil) and
    ([nsActive, nsEditable, nsDataEditable, nsWizard] * GetSelectedNode.Status =
     [nsEditable, nsDataEditable, nsWizard]);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsWizardExecute(Sender: TObject);
begin
  if (FCurrentFrame <> nil) and (FCurrentFrame is TfrmBaseDesc) then
    if TfrmBaseDesc(FCurrentFrame).RunWizard then
      MarkAsModified(False);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsTestUpdate(Sender: TObject);
begin
  actToolsTest.Enabled := (GetSelectedNode <> nil) and
    (nsTest in GetSelectedNode.Status);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsTestExecute(Sender: TObject);
begin
  if (FCurrentFrame <> nil) and (FCurrentFrame is TfrmBaseDesc) then
    TfrmBaseDesc(FCurrentFrame).Test;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsResetPageUpdate(Sender: TObject);
begin
  actToolsResetPage.Enabled := (GetSelectedNode <> nil) and
    ([nsActive, nsEditable, nsDataEditable] * GetSelectedNode.Status =
     [nsEditable, nsDataEditable]) and
    (FCurrentFrame <> nil) and (FCurrentFrame is TfrmBaseDesc) and
      FCurrentFrame.ContainsControl(Screen.ActiveControl); 
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsResetPageExecute(Sender: TObject);
begin
  if (FCurrentFrame <> nil) and (FCurrentFrame is TfrmBaseDesc) then
    TfrmBaseDesc(FCurrentFrame).ResetPageData;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsImportBDEUpdate(Sender: TObject);
begin
  actToolsImportBDE.Enabled := ADManager.ConnectionDefFileName <> '';
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsImportBDEExecute(Sender: TObject);
begin
  InitTree;
  ADManager.Active := False;
  TfrmImportAliases.Execute(ADManager.ConnectionDefFileName, FBDEOverwriteConnectionDef);
  tvLeft.Items[0].Expanded := True;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsMakeBDECompatibleUpdate(Sender: TObject);
begin
  actToolsMakeBDECompatible.Enabled := (GetSelectedNode <> nil) and
    ([nsActive, nsEditable, nsDataEditable] * GetSelectedNode.Status =
     [nsEditable, nsDataEditable]) and
    (GetSelectedNode.ConnectionDef <> nil);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsMakeBDECompatibleExecute(Sender: TObject);
begin
  SaveChanges(True);
  if TfrmMakeBDECompatible.Execute(GetSelectedNode.ConnectionDef, BDEEnableBCD,
                                   BDEEnableIntegers) then
    MarkAsModified(False);
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actToolsOptionsExecute(Sender: TObject);
begin
  if TfrmOptions.Execute(FHierarchy, FConfirmations, FTracing, FDblclickMemo,
                         FBDEEnableBCD, FBDEEnableIntegers, FBDEOverwriteConnectionDef) then begin
    SaveSettings;
    OptionsChanged;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.OptionsChanged;

  procedure DoOptionsChanged(ATreeNode: TTreeNode);
  var
    i: Integer;
    oTreeNode: TTreeNode;
    oCurNode: TADExplorerNode;
  begin
    for i := 0 to ATreeNode.Count - 1 do begin
      oTreeNode := ATreeNode.Item[i];
      oCurNode := TADExplorerNode(oTreeNode.Data);
      if nsSettingsInvalidate in oCurNode.Status then begin
        with oTreeNode do begin
          DeleteChildren;
          HasChildren := nsExpandable in oCurNode.Status;
        end;
        with oCurNode do begin
          Close;
          oTreeNode.Text := ObjectName;
          FExpanderCalled := False;
        end;
      end
      else
        DoOptionsChanged(oTreeNode);
    end;
  end;

begin
{$IFDEF AnyDAC_MONITOR}
  FADMoniEnabled := FTracing;
{$ENDIF}
  DBNavigator1.ConfirmDelete := FConfirmations;
  if FPrevHierarchy <> FHierarchy then begin
    FPrevHierarchy := FHierarchy;
    stbDown.Panels[0].Text := 'Hierarchy: ' + FHierarchy;
    if tvLeft.Items.Count > 0 then begin
      tvLeft.Items.BeginUpdate;
      BeginWait;
      try
        UpdatePropertyPageData(nil);
        UpdateStatusBar(nil);
        DoOptionsChanged(tvLeft.Items[0]);
      finally
        tvLeft.Items.EndUpdate;
        EndWait;
      end;
    end;
  end;
end;

{----------------------------------------------------------------------------}
procedure TfrmExplorer.actHelpAboutExecute(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute;
end;

{----------------------------------------------------------------------------}
{ TADExplorerNode                                                            }
{----------------------------------------------------------------------------}
constructor TADExplorerNode.Create;
begin
  inherited Create;
  FStatus := [nsExpandable, nsPassive];
  FImageIndex := -1;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetParent(AClass: TADExplorerNodeClass): TADExplorerNode;
begin
  Result := Self;
  while (Result <> nil) and not (Result is AClass) do
    Result := Result.ParentNode;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetConnectionDef: IADStanConnectionDef;
var
  oNode: TADConnectionDefNode;
begin
  oNode := TADConnectionDefNode(GetParent(TADConnectionDefNode));
  if oNode = nil then
    Result := nil
  else
    Result := oNode.ConnectionDef;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetConnection: TADCustomConnection;
var
  oNode: TADConnectionDefNode;
begin
  oNode := TADConnectionDefNode(GetParent(TADConnectionDefNode));
  if oNode = nil then
    Result := nil
  else
    Result := oNode.Connection;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetExplorer: TfrmExplorer;
var
  oNode: TADRootNode;
begin
  oNode := TADRootNode(GetParent(TADRootNode));
  if oNode = nil then
    Result := nil
  else
    Result := oNode.Explorer;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetConnectionDefs: IADStanConnectionDefs;
var
  oNode: TADRootNode;
begin
  oNode := TADRootNode(GetParent(TADRootNode));
  if oNode = nil then
    Result := nil
  else
    Result := oNode.ConnectionDefs;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.CreateExpander: TADExplorerNodeExpander;
begin
  Result := nil;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.CreateFrame: TFrame;
begin
  Result := nil;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetStatus: TADExplorerNodeStatuses;
begin
  Result := FStatus;
end;

{----------------------------------------------------------------------------}
procedure TADExplorerNode.Open;
begin
  // NOP
end;

{----------------------------------------------------------------------------}
procedure TADExplorerNode.Close;
begin
  // NOP
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.CreateSubNode: TADExplorerNode;
begin
  Result := nil;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetObjectName: String;
begin
  Result := FObjectName;
end;

{----------------------------------------------------------------------------}
function TADExplorerNode.GetTemplateName: String;
begin
  Result := 'obj';
end;

{----------------------------------------------------------------------------}
procedure TADExplorerNode.Apply;
begin
  // NOP
end;

{----------------------------------------------------------------------------}
procedure TADExplorerNode.Delete;
begin
  // NOP
end;

{----------------------------------------------------------------------------}
procedure TADExplorerNode.Cancel;
begin
  // NOP
end;

{----------------------------------------------------------------------------}
{ TADExplorerNodeExpander                                                    }
{----------------------------------------------------------------------------}
constructor TADExplorerNodeExpander.Create(ANode: TADExplorerNode);
begin
  inherited Create;
  FNode := ANode;
  FImageIndex := -1;
end;

{----------------------------------------------------------------------------}
destructor TADExplorerNodeExpander.Destroy;
begin
  inherited Destroy;
end;

end.

