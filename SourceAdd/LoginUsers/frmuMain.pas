{
 * The contents of this file are subject to the InterBase Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License.
 * 
 * You may obtain a copy of the License at http://www.Inprise.com/IPL.html.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.  The Original Code was created by Inprise
 * Corporation and its predecessors.
 * 
 * Portions created by Inprise Corporation are Copyright (C) Inprise
 * Corporation. All Rights Reserved.
 * 
 * Contributor(s): ______________________________________.
}

*  f r m u M a i n
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides an interface which acts as the
*                main switchboard for the application
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit frmuMain;
interface

uses Windows, Classes, Graphics, Forms, Controls, Menus, Dialogs, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ImgList, ToolWin, Grids, DBGrids, DBCtrls,
  Registry, zluibcClasses, IBServices, IB, Messages, SysUtils,
  RichEdit, DB, IBCustomDataSet, IBSQL, IBQuery, IBHeader, IBDatabase,
  IBDatabaseInfo, RichEditX, frmuDlgClass, ActnList, StdActns, wisql, frmuObjectWindow,
  IBExtract;

type
  TWinState = record
    _Top,
    _Left,
    _Height,
    _Width: integer;
    _State: TWindowState;
    _Read: boolean;
  end;

  TfrmMain = class(TForm)
    stbMain: TStatusBar;
    clbMain: TCoolBar;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton41: TToolButton;
    ToolButton6: TToolButton;
    ToolButton10: TToolButton;
    MainMenu1: TMainMenu;
    Console1: TMenuItem;
    View1: TMenuItem;
    Server1: TMenuItem;
    Database1: TMenuItem;
    ToolMenu: TMenuItem;
    Help1: TMenuItem;
    Exit2: TMenuItem;
    SystemData2: TMenuItem;
    Large2: TMenuItem;
    Small2: TMenuItem;
    List2: TMenuItem;
    Details1: TMenuItem;
    Register3: TMenuItem;
    UnRegister2: TMenuItem;
    Login2: TMenuItem;
    ServerProperties2: TMenuItem;
    AddCertificate2: TMenuItem;
    RemoveCertificate2: TMenuItem;
    DiagnoseConnection2: TMenuItem;
    UserSecurity2: TMenuItem;
    ServerProperties3: TMenuItem;
    Register4: TMenuItem;
    Unregister3: TMenuItem;
    Connect2: TMenuItem;
    ConnectAs2: TMenuItem;
    Disconnect2: TMenuItem;
    CreateDatabase1: TMenuItem;
    DropDatabase1: TMenuItem;
    ViewMetadata2: TMenuItem;
    Properties4: TMenuItem;
    BackupRestore1: TMenuItem;
    Backup2: TMenuItem;
    Restore2: TMenuItem;
    EditBackupAlias1: TMenuItem;
    TransactionRecovery2: TMenuItem;
    Shutdown2: TMenuItem;
    DatabaseRestart2: TMenuItem;
    DatabaseStatistics2: TMenuItem;
    Sweep2: TMenuItem;
    Validation2: TMenuItem;
    InteractiveSQL2: TMenuItem;
    Configure1: TMenuItem;
    Contents2: TMenuItem;
    TopicSearch1: TMenuItem;
    RemoveAlias2: TMenuItem;
    InterBaseHelp2: TMenuItem;
    About2: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    tvMain: TTreeView;
    ServerConnectedActions: TActionList;
    ServerLogout: TAction;
    ServerSecurity: TAction;
    ServerAddCertificate: TAction;
    ServerRemoveCertificate: TAction;
    DatabaseConnectedActions: TActionList;
    DatabaseDisconnect: TAction;
    DatabaseProperties: TAction;
    DatabaseSweep: TAction;
    DatabaseRecoverTrans: TAction;
    DatabaseStatistics: TAction;
    DatabaseMetadata: TAction;
    DatabaseShutdown: TAction;
    DatabaseRestart: TAction;
    DatabaseDrop: TAction;
    ServerActions: TActionList;
    ServerLogin: TAction;
    DatabaseActions: TActionList;
    DatabaseRegister: TAction;
    DatabaseUnregister: TAction;
    DatabaseConnect: TAction;
    DatabaseConnectAs: TAction;
    DatabaseCreate: TAction;
    ToolActions: TActionList;
    ExtToolsLaunchISQL: TAction;
    ExtToolsConfigure: TAction;
    BackupActions: TActionList;
    DatabaseBackup: TAction;
    DatabaseRestore: TAction;
    BackupRestoreModifyAlias: TAction;
    imgTreeview: TImageList;
    imgToolBarsEnabled: TImageList;
    imgLargeView: TImageList;
    imgToolBarsDisabled: TImageList;
    ExtToolDropDown: TAction;
    pmDatabaseActions: TPopupMenu;
    Connect1: TMenuItem;
    ConnectAs1: TMenuItem;
    CreateDatabase2: TMenuItem;
    Register1: TMenuItem;
    N1: TMenuItem;
    pmDatabaseConnectedActions: TPopupMenu;
    Disconnect1: TMenuItem;
    Properties1: TMenuItem;
    Sweep1: TMenuItem;
    TransactionRecovery1: TMenuItem;
    DatabaseStatistics3: TMenuItem;
    ViewMetadata1: TMenuItem;
    Maintenance1: TMenuItem;
    BackupRestore2: TMenuItem;
    EditBackupAlias3: TMenuItem;
    RemoveAlias3: TMenuItem;
    Backup1: TMenuItem;
    Restore1: TMenuItem;
    pmServer: TPopupMenu;
    Logout1: TMenuItem;
    Login1: TMenuItem;
    DiagnoseConnection1: TMenuItem;
    AddCertificate1: TMenuItem;
    AddCertificate3: TMenuItem;
    Register2: TMenuItem;
    UserSecurity1: TMenuItem;
    UnRegister1: TMenuItem;
    ViewLogfile1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    pmBackupRestore: TPopupMenu;
    EditBackupAlias4: TMenuItem;
    Backup3: TMenuItem;
    Restore3: TMenuItem;
    N6: TMenuItem;
    pmCertificates: TPopupMenu;
    AddCertificate4: TMenuItem;
    RemoveCertificate3: TMenuItem;
    ServerProperties: TAction;
    pmDatabases: TPopupMenu;
    Register5: TMenuItem;
    CreateDatabase3: TMenuItem;
    N7: TMenuItem;
    LogActions: TActionList;
    ViewServerLog: TAction;
    UserActions: TActionList;
    UserAdd: TAction;
    UserModify: TAction;
    UserDelete: TAction;
    pmUsers: TPopupMenu;
    UIActions: TActionList;
    ConsoleExit: TAction;
    ViewList: TAction;
    ViewReport: TAction;
    ViewIcon: TAction;
    ViewSmallIcon: TAction;
    ViewProperties: TAction;
    ViewSystem: TAction;
    HelpContents: THelpContents;
    HelpOnHelp: THelpOnHelp;
    HelpTopicSearch: THelpTopicSearch;
    HelpAbout: TAction;
    HelpInterBase: TAction;
    EditCopy: TEditCopy;
    EditCut: TEditCut;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    ServerRegister: TAction;
    ServerUnregister: TAction;
    ServerConnection: TAction;
    N8: TMenuItem;
    BackupRestoreRemoveAlias: TAction;
    DeleteAlias1: TMenuItem;
    N9: TMenuItem;
    N01: TMenuItem;
    Shutdown3: TMenuItem;
    DatabaseRestart1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    DeleteAlias2: TMenuItem;
    N14: TMenuItem;
    EditPopup: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N15: TMenuItem;
    SelectAll1: TMenuItem;
    DatabaseValidate: TAction;
    N17: TMenuItem;
    Validation1: TMenuItem;
    Unregister4: TMenuItem;
    splVertical: TSplitter;
    N27: TMenuItem;
    Properties2: TMenuItem;
    ServerActionProps: TAction;
    DatabaseActionsProperties: TAction;
    pmDBObjects: TPopupMenu;
    DBObjectProperties: TActionList;
    ObjectDescription: TAction;
    ObjectCreate: TAction;
    ObjectModify: TAction;
    ObjectDelete: TAction;
    ObjectExtract: TAction;
    Backup4: TMenuItem;
    EditDescription1: TMenuItem;
    EditFont: TAction;
    WindowList: TAction;
    ObjectProperties: TAction;
    Properties5: TMenuItem;
    Window2: TMenuItem;
    Maintenance2: TMenuItem;
    N16: TMenuItem;
    N10: TMenuItem;
    ViewLogfile2: TMenuItem;
    DBCBackup: TAction;
    DBCRestore: TAction;
    lvObjects: TListView;
    AddUser1: TMenuItem;
    ModifyUser1: TMenuItem;
    DeleteUser1: TMenuItem;
    DatabaseUsers: TAction;
    DiagnoseConnection3: TMenuItem;
    ConnectedUsers1: TMenuItem;
    N26: TMenuItem;
    N28: TMenuItem;
    ObjectRefresh: TAction;
    Refresh1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvObjectsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure lvObjectsDblClick(Sender: TObject);
    procedure tvMainChange(Sender: TObject; Node: TTreeNode);
    procedure tvMainDblClick(Sender: TObject);
    procedure tvMainDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvMainExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure mmiHeContentsClick(Sender: TObject);
    procedure mmiHeOverviewClick(Sender: TObject);
    procedure mmiHeUsingHelpClick(Sender: TObject);
    procedure mmiHeInterBaseHelpClick(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure tvMainKeyPress(Sender: TObject; var Key: Char);
    procedure tvMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure lvObjectsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvActionsDblClick(Sender: TObject);
    procedure lvObjectsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ConsoleExitExecute(Sender: TObject);
    procedure DatabaseShutdownExecute(Sender: TObject);
    procedure DatabaseRegisterExecute(Sender: TObject);
    procedure DatabaseUnregisterExecute(Sender: TObject);
    procedure DatabaseConnectExecute(Sender: TObject);
    procedure DatabaseConnectAsExecute(Sender: TObject);
    procedure DatabaseDisconnectExecute(Sender: TObject);
    procedure ToolsStatisticsExecute(Sender: TObject);
    procedure ToolsSweepExecute(Sender: TObject);
    procedure ToolsSQLExecute(Sender: TObject);
    procedure ServerViewLogExecute(Sender: TObject);
    procedure ServerAddCertificateExecute(Sender: TObject);
    procedure ServerRemoveCertificateExecute(Sender: TObject);
    procedure DatabaseRestartExecute(Sender: TObject);
    procedure ToolsTransRecoverExecute(Sender: TObject);
    procedure DatabaseCreateExecute(Sender: TObject);
    procedure DatabaseDropExecute(Sender: TObject);
    procedure ToolsValidationExecute(Sender: TObject);
    procedure DatabasePropertiesExecute(Sender: TObject);
    procedure DatabaseRestoreExecute(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure BackupRestoreModifyAliasExecute(Sender: TObject);
    procedure ServerDiagConnectionExecute(Sender: TObject);
    procedure ServerLoginExecute(Sender: TObject);
    procedure ServerLogoutExecute(Sender: TObject);
    procedure ServerPropertiesExecute(Sender: TObject);
    procedure ServerRegisterExecute(Sender: TObject);
    procedure ServerUnregisterExecute(Sender: TObject);
    procedure ServerSecurityExecute(Sender: TObject);
    procedure ViewSystemDataExecute(Sender: TObject);
    procedure EditFontExecute(Sender: TObject);
    procedure DatabaseBackupExecute(Sender: TObject);
    procedure DatabaseMetadataExecute(Sender: TObject);
    procedure ViewListExecute(Sender: TObject);
    procedure ViewListUpdate(Sender: TObject);
    procedure ViewReportExecute(Sender: TObject);
    procedure ViewReportUpdate(Sender: TObject);
    procedure ViewIconExecute(Sender: TObject);
    procedure ViewIconUpdate(Sender: TObject);
    procedure ViewSmallIconExecute(Sender: TObject);
    procedure ViewSmallIconUpdate(Sender: TObject);
    procedure DatabaseConnectedActionsUpdate(Sender: TObject);
    procedure ServerActionsUpdate(Sender: TObject);
    procedure ServerConnectedUpdate(Sender: TObject);
    procedure DatabaseRegisterUpdate(Sender: TObject);
    procedure DatabaseActionsUpdate(Sender: TObject);
    procedure ExtToolsConfigureExecute(Sender: TObject);
    procedure ExtToolDropDownExecute(Sender: TObject);
    procedure ExtToolLaunchExecute(Sender: TObject);
    procedure BackupRestoreUpdate(Sender: TObject);
    procedure DatabaseCreateUpdate(Sender: TObject);
    procedure EditFontUpdate(Sender: TObject);
    procedure listViewEnter(Sender: TObject);
    procedure frmMainDestroy(Sender: TObject);
    procedure BackupRestoreRemoveAliasExecute(Sender: TObject);
    procedure BackupRestoreAliasUpdate(Sender: TObject);
    procedure DatabasePropertiesUpdate(Sender: TObject);
    procedure DatabaseValidateUpdate(Sender: TObject);
    procedure ObjectDescriptionExecute(Sender: TObject);
    procedure ObjectDescriptionUpdate(Sender: TObject);
    procedure ObjectExtractExecute(Sender: TObject);
    procedure ObjectDeleteUpdate(Sender: TObject);
    procedure ObjectDeleteExecute(Sender: TObject);
    procedure ViewSystemUpdate(Sender: TObject);
    procedure Window2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvObjectsContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tvMainCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure ServerPropertiesUpdate(Sender: TObject);
    procedure ServerRemoveCertificateUpdate(Sender: TObject);
    procedure UserDeleteUpdate(Sender: TObject);
    procedure UserAddExecute(Sender: TObject);
    procedure UserModifyExecute(Sender: TObject);
    procedure UserModifyUpdate(Sender: TObject);
    procedure UserDeleteExecute(Sender: TObject);
    procedure ServerUsersExecute(Sender: TObject);
    procedure ObjectModifyUpdate(Sender: TObject);
    procedure ServerAddCertificateUpdate(Sender: TObject);
    procedure DatabaseShutdownUpdate(Sender: TObject);
    procedure ObjectRefreshExecute(Sender: TObject);

  private
    { Private declarations }
    FErrorState: boolean;
    FCurrSelDatabase: TibcDatabaseNode;
    FCurrSelServer: TibcServerNode;
    FCurrSelTreeNode: TibcTreeNode;
    FCurrSelCertificateID : String;
    FCurrSelCertificateKey : String;
    FPrevSelTreeNode: TibcTreeNode;
    FRegistry: TRegistry;
    FTableData : TIBQuery;
    FRefetch,
    FViewSystemData: Boolean;
    FQryDataSet: TIBDataSet;
    FDefaultTransaction: TIBTransaction;
    FWisql: TdlgWisql;
    FToolMenuIdx: integer;
    FLastActions: TActionList;
    FWindowList: TStringList;
    FObjectWindowState,
    FISQLWindowState,
    FMainWindowState: TWinState;
    FNILLDATABASE: TIBDatabase;

    function DoDBConnect(const SelServerNode: TibcServerNode;
      var SelDatabaseNode: TibcDatabaseNode;
      const SilentLogin: boolean): boolean;
    function DoDBDisconnect(var SelDatabaseNode: TibcDatabaseNode): boolean;
    function GetBackupFiles(const SelServerNode: TibcServerNode): integer;
    function GetCertificates(const SelServerNode: TibcServerNode; const SelTreeNode: TibcTreeNode): integer;
    function GetDDLScript: integer;
    function GetDatabases(const SelServerNode: TibcServerNode): integer;
    function GetDBObjects(const SelDatabaseNode: TibcDatabaseNode; const SelTreeNode: TibcTreeNode; const ObjType: integer): integer;
    function GetServers: integer;
    function GetUsers(const SelServerNode: TibcServerNode; const SelTreeNode: TibcTreeNode): integer;
    function RegisterBackupFile(const SelServerNode: TibcServerNode;
      const SourceDBAlias,BackupAlias: string;
      BackupFiles: TStringList): boolean;
    function RegisterDatabase(const SelServerNode: TibcServerNode; const DBAlias,
      UserName,Password,Role: string; DatabaseFiles: TStringList;
      SaveAlias, CaseSensitive: boolean; var NewDatabase: TIBDatabase): boolean;
    function RegisterServer(const ServerName,ServerAlias,UserName,Password,Description: string; Protocol: TProtocol; SaveAlias: boolean; LastAccess: TDateTime): boolean;
    function UnRegisterServer(const Node: String): boolean;
    function IsDBRegistered(const DBFile : String; var ExistingDBAlias : String) : Boolean;
    procedure DeleteNode(const Node: TTreeNode; const ChildNodesOnly: boolean);
    function DoServerLogin(const SilentLogin: boolean): boolean;
    procedure FillObjectList(const CurrSelNode: TibcTreeNode);
    procedure InitRegistry;
    procedure InitTreeView;
    procedure ReadRegistry;
    procedure AddTreeRootNode (const ObjType: Integer; const Parent: TTreeNode);
    procedure FillActionList (const ActionList: TActionList);

    { WISQL Event Methods }
    procedure EventDatabaseCreate (var Database: TIBDatabase);
    procedure EventObjectRefresh (const Database: TIBDatabase; const ObjType: integer);
    procedure EventDatabaseConnect (const ServerName: string; const Database: TIBDatabase);
//    procedure EventServerConnect (const ServerName: string);
    procedure EventDatabaseDrop;

  public
    { Public declarations }
    procedure RenameTreeNode(SelTreeNode: TibcTreeNode; NewNodeName: string);
    procedure DisplayWindow(Sender: TObject);
    function AliasExists(const AliasName: String): boolean;
    { WISQL hooks for main form objects }
    function CreateDatabase(Sender: TObject): boolean;
    function ConnectAsDatabase(Sender: TObject): boolean;
    procedure UpdateWindowList(const Caption: String; const Window: TObject;
      const Remove: boolean = false);
    procedure ShowWindows;      
    procedure SetErrorState;      
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses frmuAbout,zluGlobal,frmuUser,frmuDBRegister,frmuServerRegister,dmuMain,
  frmuDBConnect,frmuServerLogin,zluUtility,frmuMessage,
  frmuDBRestore,frmuDBBackup,
  frmuServerProperties,frmuDBProperties,frmuBackupAliasProperties,
  frmuDBCreate,frmuDBConnections,frmuDBValidation,frmuDBShutdown,
  frmuCommDiag,frmuAddCertificate, zluContextHelp, frmuDBTransactions,
  frmuDBStatistics, frmuDispMemo, frmuModifyServerAlias, zluSQL, frmuDisplayBlob,
  dbTables, frmuTools, frmuDescription, frmuWindowList, CommCtrl, IBErrorCodes;

const
  ACTIONS = 0;
  OBJECTS = 1;
  STATIC = 2;
  SYSDBA_ONLY = 999;
var
  { To detect multiple instances, we will replace the window proc with our
    own and create our own message }
  OldWindowProc: Pointer;
  IBConsole_msg: DWORD;

function IBConsoleWindowProc(WindowHandle : hWnd;
                             TheMessage   : LongInt;
                             ParamW       : LongInt;
                             ParamL       : LongInt) : LongInt stdcall;
begin
  if TheMessage = LongInt(IBConsole_msg)  then
  begin
    SendMessage(Application.handle, WM_SYSCOMMAND, SC_RESTORE, 0);
    SetForegroundWindow(Application.Handle);
    Result := 0;
    exit;
  end;
  {Call the original winproc}
  Result := CallWindowProc(OldWindowProc,
                           WindowHandle,
                           TheMessage,
                           ParamW,
                           ParamL);
end;

{****************************************************************
*
*  F o r m C l o s e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*          Action - Determines if the form actually closes
*
*  Return: None
*
*  Description: This procedure performs a number of cleanup tasks
*               when the Main form is closed
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lCnt: Integer;
  state: TWinState;
begin
  gApplShutdown := true;
  with FRegistry do begin
    OpenKey(gRegSettingsKey,false);
    with State do
    begin
      _Top := Top;
      _Left := Left;
      _Height := Height;
      _Width := Width;
      _State := WindowState;
      _Read := true;
    end;
    
    WriteBinaryData('MainState', State, sizeof(State));
    for lCnt := 0 to NUM_SETTINGS - 1 do begin
      {If something happened reading the registry, make sure that the settings
       are valid before trying to write them.  Otherwise, the app will not
       close}
      case TVarData(gAppSettings[lCnt].Setting).VType of
        varBoolean:
          WriteBool(gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
        varString:
          WriteString(gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
        varInteger:
          WriteInteger(gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
      end;
    end;
    CloseKey;
  end;
  FTableData.Free;
  FWisql.Free;
  FWindowList.Free;
end;

{****************************************************************
*
*  F o r m C r e a t e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure performs initialization tasks
*               when the Main form is created.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.FormCreate(Sender: TObject);
var
  lCnt: integer;
begin
  {First, setup a handler for detecting multiple instances }
  IBConsole_msg := RegisterWindowMessage('ib_console_mtx');
  {Set window proc to IBConsoleWindowProc. Save the old one}
  OldWindowProc := Pointer(SetWindowLong(frmMain.Handle,
                                         GWL_WNDPROC,
                                         LongInt(@IBConsoleWindowProc)));

  inherited;
  FErrorState := false;
  FNILLDATABASE := nil;
  stbMain.Height := 19;
  tvMain.Width := Width div 3;

  gApplShutdown := false;
  SetLength (gWinTempPath, MAX_PATH);
  GetTempPath(MAX_PATH,PChar(gWinTempPath));
  FCurrSelServer := nil;
  FCurrSelDatabase := nil;
  FCurrSelTreeNode := nil;
  FPrevSelTreeNode := nil;
  FTableData := TIBQuery.Create(Self);
  FQryDataSet := nil;
  FDefaultTransaction := nil;
  FLastActions := nil;
  FRefetch := false;
  FWindowList := TStringList.Create;

  { Initialize the application setting defaults }
  for lCnt := 0 to NUM_SETTINGS-1 do begin
    gAppSettings[lCnt].Name := SETTINGS[lCnt];
      case lCnt of
        {Boolean Settings}
          SYSTEM_DATA:
            gAppSettings[lCnt].Setting := false;
          DEPENDENCIES:
            gAppSettings[lCnt].Setting := true;
          USE_DEFAULT_EDITOR:
            gAppSettings[lCnt].Setting := true;
          SHOW_QUERY_PLAN:
            gAppSettings[lCnt].Setting := true;
          AUTO_COMMIT_DDL:
            gAppSettings[lCnt].Setting := true;
          SHOW_STATS:
            gAppSettings[lCnt].Setting := true;
          SHOW_LIST:
            gAppSettings[lCnt].Setting := false;
          SAVE_ISQL_OUTPUT:
            gAppSettings[lCnt].Setting := false;
          UPDATE_ON_CONNECT:
            gAppSettings[lCnt].Setting := false;
          UPDATE_ON_CREATE:
            gAppSettings[lCnt].Setting := false;
          CLEAR_INPUT:
            gAppSettings[lCnt].Setting := true;

        {String Settings}
          CHARACTER_SET:
            gAppSettings[lCnt].Setting := 'None';
          BLOB_DISPLAY:
            gAppSettings[lCnt].Setting := 'Restrict';
          BLOB_SUBTYPE:
            gAppSettings[lCnt].Setting := 'Text';
          ISQL_TERMINATOR:
            gAppSettings[lCnt].Setting := ';';

        {Integer Settings}
          COMMIT_ON_EXIT:
            gAppSettings[lCnt].Setting := 0;
          VIEW_STYLE:
            gAppSettings[lCnt].Setting := 3;
          DEFAULT_DIALECT:
            gAppSettings[lCnt].Setting := 3;
        end;
    end;

  FRegistry := TRegistry.Create;
  FRegistry.RootKey := HKEY_CURRENT_USER;
  InitRegistry;
  FMainWindowState._Read := false;
  FObjectWindowState._Read := false;
  FISQLWindowState._Read := false;
  ReadRegistry;
  if FMainWindowState._Read then
    with FMainWindowState do
    begin
      if not (_State in [wsMaximized, wsMinimized]) then
      begin
        Top := _Top;
        Left := _Left;
        Width := _Width;
        Height := _Height;
      end;
      WindowState := _State;
    end;

  tvMain.Selected := tvMain.Items[0];
  tvMainChange(nil,nil);

  FWISQL := TdlgWisql.Create (nil);
  if FISQLWindowState._Read then
    with FISQLWindowState do
    begin
      if not (_State in [wsMaximized, wsMinimized]) then
      begin
        FWISQL.Top := _Top;
        FWISQL.Left := _Left;
        FWISQL.Width := _Width;
        FWISQL.Height := _Height;
      end;
      FWISQL.WindowState := _State;
    end;

  { Get the number of items in the tool Menu }
  FToolMenuIdx := ToolMenu.Count;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FRegistry.Free;
end;

{****************************************************************
*
*  l v O b j e c t L i s t C h a n g e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*          Item - The list item that just changed
*          Change - The type of change that just occurred
*
*  Return: None
*
*  Description: This procedure enables/disables controls based on the
*               the selected treenode
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.lvObjectsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
  lTreeNode: TTreeNode;
begin
  if Assigned(lvObjects.Selected) then
  begin
    case FCurrSelTreeNode.NodeType of
      NODE_SERVERS:
      begin
        if Assigned(lvObjects.Selected.Data) then
        begin
          lTreeNode := tvMain.Items.GetNode(TTreeNode(lvObjects.Selected.Data).ItemID);
          FCurrSelServer := TibcServerNode(lTreeNode.Data);
        end;
      end;

      NODE_DATABASES:
      begin
        if Assigned(lvObjects.Selected.Data) then
        begin
          lTreeNode := tvMain.Items.GetNode(TTreeNode(lvObjects.Selected.Data).ItemID);
          FCurrSelServer := TibcServerNode(lTreeNode.Parent.Parent.Data);
          FCurrSelDatabase := TibcDatabaseNode(lTreeNode.Data);
        end;
      end;

      NODE_BACKUP_ALIASES:
      begin
        if Assigned(lvObjects.Selected.Data) then
        begin
          lTreeNode := tvMain.Items.GetNode(TTreeNode(lvObjects.Selected.Data).ItemID);
          FCurrSelServer := TibcServerNode(lTreeNode.Parent.Parent.Data);
          FCurrSelTreeNode := TibcTreeNode(lTreeNode.Data);
        end
      end;

    end;
  end;
end;

{****************************************************************
*
*  l v O b j e c t L i s t D b l C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure determines what action takes place
*               during a double click depending on the type of the
*               selected treenode
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.lvObjectsDblClick(Sender: TObject);
var
  Icon: TIcon;

begin
  if (Sender is TListView) and ((Sender as TListView).Tag = ACTIONS) then
    lvActionsDblClick (Sender)
  else
  begin
    case FCurrSelTreeNode.NodeType of
      NODE_USERS:
      begin
        if Assigned(FCurrSelServer) then
        begin
          if lvObjects.SelCount > 0 then
            frmuUser.UserInfo(FCurrSelServer,lvObjects.Selected.Caption)
          else
            frmuUser.UserInfo(FCurrSelServer,'');
        end;
      end;

      NODE_VIEWS,
      NODE_PROCEDURES,
      NODE_FUNCTIONS,
      NODE_GENERATORS,
      NODE_EXCEPTIONS,
      NODE_BLOB_FILTERS,
      NODE_ROLES,
      NODE_DOMAINS,
      NODE_TABLES:
      begin
        if Assigned(lvObjects.Selected) then
        begin
          try
            Icon := TIcon.Create;
            with lvObjects do
            begin
              SmallImages.GetIcon(Selected.ImageIndex, Icon);
              UpdateWindowList(FCurrSelDatabase.ObjectViewer.Caption, TObject(FCurrSelDatabase.ObjectViewer), true);
              FCurrSelDatabase.CreateObjectViewer;

              if FObjectWindowState._Read then
                with FObjectWindowState do
                begin
                  if not (_State in [wsMaximized, wsMinimized]) then
                  begin
                    FCurrSelDatabase.ObjectViewer.Top := _Top;
                    FCurrSelDatabase.ObjectViewer.Left := _Left;
                    FCurrSelDatabase.ObjectViewer.Width := _Width;
                    FCurrSelDatabase.ObjectViewer.Height := _Height;
                  end;
                  FCurrSelDatabase.ObjectViewer.WindowState := _State;
                  FObjectWindowState._Read := false;
                end;

              FCurrSelDatabase.ObjectViewer.InitDlg (FCurrSelTreeNode.NodeType,FCurrSelTreeNode.ObjectList,
                                     Selected.Caption, FCurrSelDatabase.Database, Icon, FViewSystemData, FRefetch);
              FRefetch := false;
            end;
            Icon.Free;
            FCurrSelDatabase.ObjectViewer.Show;
            UpdateWindowList(FCurrSelDatabase.ObjectViewer.Caption, TObject(FCurrSelDatabase.ObjectViewer));
          except
            on E: Exception do
              DisplayMsg (ERR_SYSTEM_INIT, E.Message);
          end;
        end;
      end;
    end;
  end;
end;

{****************************************************************
*
*  t v M a i n C h a n g e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure controls what actions can take place when
*               the user selectes a treenode
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.tvMainChange(Sender: TObject; Node: TTreeNode);

begin
  stbMain.Panels[0].Text := '';
  stbMain.Panels[1].Text := '';
  stbMain.Panels[2].Text := '';
  stbMain.Panels[3].Text := '';

try
  if Assigned(tvMain.Selected) then
  begin
    tvMain.PopupMenu := nil;
    lvObjects.PopupMenu := nil;
    FCurrSelTreeNode := TibcTreeNode(tvMain.Selected.Data);

    if (not Assigned(FPrevSelTreeNode)) and (Assigned(FCurrSelTreeNode)) then
      FPrevSelTreeNode := FCurrSelTreeNode;

    case FCurrSelTreeNode.NodeType of
      NODE_LOGS:
      begin
        FillActionList(LogActions);
      end;

      NODE_SERVERS:
      begin
        GetServers;
        FillObjectList(FCurrSelTreeNode);
        tvMain.PopupMenu := pmServer;
      end;

      NODE_SERVER:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Data);
        tvMain.PopupMenu := pmServer;
        if FCurrSelServer.Server.Active then
          FillActionList(ServerConnectedActions)
        else
          FillActionList(ServerActions);
      end;

      NODE_DATABASES:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Data);
        if tvMain.Selected.HasChildren then
          FCurrSelDatabase := TibcDatabaseNode((tvMain.Selected.GetFirstChild).Data)
        else
          FCurrSelDatabase := nil;
        GetDatabases(FCurrSelServer);
        FillObjectList(FCurrSelTreeNode);
        tvMain.PopupMenu := pmDatabases;
      end;

      NODE_BACKUP_ALIASES:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Data);
        GetBackupFiles(FCurrSelServer);
        FillObjectList(FCurrSelTreeNode);
        lvObjects.PopupMenu := pmBackupRestore;        
      end;

      NODE_USERS:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Data);
        GetUsers(FCurrSelServer,FCurrSelTreeNode);
        FillObjectList(FCurrSelTreeNode);
        lvObjects.PopupMenu := pmUsers;
      end;

      NODE_CERTIFICATES:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Data);
        FCurrSelCertificateID := '';
        FCurrSelCertificateKey := '';
        GetCertificates(FCurrSelServer,FCurrSelTreeNode);
        FillObjectList(FCurrSelTreeNode);
        lvObjects.PopupMenu := pmCertificates;
        tvMain.PopupMenu := pmCertificates;
      end;

      NODE_BACKUP_ALIAS:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Parent.Data);
        if FRegistry.OpenKey(Format('%s%s\Backup Files\%s',[gRegServersKey,FCurrSelServer.NodeName,FCurrSelTreeNode.NodeName]),false) then
        begin
          TibcBackupAliasNode(FCurrSelTreeNode).SourceDBServer := FRegistry.ReadString('SourceDBServer');
          TibcBackupAliasNode(FCurrSelTreeNode).SourceDBAlias := FRegistry.ReadString('SourceDBAlias');
          TibcBackupAliasNode(FCurrSelTreeNode).BackupFiles.Text := FRegistry.ReadString('BackupFiles');

          if FRegistry.KeyExists ('Created') then
            TibcBackupAliasNode(FCurrSelTreeNode).Created := FRegistry.ReadDateTime('Created');
          if FRegistry.KeyExists ('Accessed') then
            TibcBackupAliasNode(FCurrSelTreeNode).Created := FRegistry.ReadDateTime('Accessed');
        end;
        FillActionList (BackupActions);
        tvMain.popupMenu := pmBackupRestore;
      end;

      NODE_DATABASE:
      begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Parent.Data);
        FCurrSelDatabase := TibcDatabaseNode(tvMain.Selected.Data);
        stbMain.Panels[1].Text := Format('Database: %s',[FCurrSelDatabase.NodeName]);

        { Force refresh for the object viewer }
        FRefetch := true;
        
        if (Assigned(FCurrSelDatabase.Database)) and
           (FCurrSelDatabase.Database.Connected) then
        begin
          FillActionList (DatabaseConnectedActions);
          tvMain.PopupMenu := pmDatabaseConnectedActions;
        end
        else
        begin
          FillACtionList (DatabaseActions);
          tvMain.PopupMenu := pmDatabaseActions;
        end;
     end;

     NODE_DOMAINS,
     NODE_TABLES,
     NODE_VIEWS,
     NODE_PROCEDURES,
     NODE_FUNCTIONS,
     NODE_GENERATORS,
     NODE_EXCEPTIONS,
     NODE_BLOB_FILTERS,
     NODE_ROLES:
     begin
        FCurrSelServer := TibcServerNode(tvMain.Selected.Parent.Parent.Parent.Data);
        FCurrSelDatabase := TibcDatabaseNode(tvMain.Selected.Parent.Data);
        stbMain.Panels[1].Text := Format('Database: %s',[FCurrSelDatabase.NodeName]);
        if (FCurrSelTreeNode.ObjectList.Count = 0) or
           (FCurrSelTreeNode.ShowSystem <> FViewSystemData) then
        begin
          GetDBObjects(FCurrSelDatabase, FCurrSelTreeNode, FCurrSelTreeNode.NodeType);
          FCurrSelTreeNode.ShowSystem := FViewSystemData;
        end;
        FillObjectList (FCurrSelTreeNode);

        lvObjects.PopupMenu := pmDBObjects;
      end;
    end;
  end;

finally
  if Assigned(FCurrSelServer) and (FCurrSelTreeNode.NodeType <> NODE_SERVERS) then
  begin
    stbMain.Panels[0].Text := Format('Server: %s',[FCurrSelServer.NodeName]);
    if FCurrSelServer.Server.Active then
      stbMain.Panels[2].Text := Format('User: %s',[FCurrSelServer.Username]);
  end;
  if Assigned(FCurrSelTreeNode) then
    FPrevSelTreeNode := FCurrSelTreeNode;
  Application.ProcessMessages;
end;

end;

{****************************************************************
*
*  t v M a i n D b l C l i c k ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  Sender - The object that initiated the event
*
*  Return: None
*
*  Description: This procedure performs an action depending on
*               which treenode received the double-click.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.tvMainDblClick(Sender: TObject);
begin
  if not Assigned (FCurrSelTreeNode) then
    exit;

  case FCurrSelTreeNode.NodeType of
    NODE_SERVERS:
      ServerRegisterExecute(Self);

    NODE_SERVER:
      if (Assigned(FCurrSelServer)) and (not FCurrSelServer.Server.Active) and
        (FCurrSelServer.Version > 5) then
        DoServerLogin(false);

    NODE_CERTIFICATES:
      ServerAddCertificateExecute(self);

    NODE_DATABASE:
      if Assigned(FCurrSelServer) and
         Assigned(FCurrSelDatabase) and
         (not Assigned(FCurrSelDatabase.Database) or
          not (FCurrSelDatabase.Database.Connected)) then
        DoDBConnect(FCurrSelServer,FCurrSelDatabase,true);

    NODE_BACKUP_ALIAS:
      DatabaseRestoreExecute(self);
  end;
end;

procedure TfrmMain.tvMainDeletion(Sender: TObject; Node: TTreeNode);
var
  lTmpTreeNode: TibcTreeNode;
begin
  if Assigned(Node.Data) then
  begin
    lTmpTreeNode := TibcTreeNode(Node.Data);
    lTmpTreeNode.Free;
  end
end;

procedure TfrmMain.tvMainExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if (Assigned(Node.Data)) and (TibcTreeNode(Node.Data) is TibcServerNode) then
  begin
    if TibcServerNode(Node.Data).Server.Active or (FCurrSelServer.Version < 6) then
      AllowExpansion := true
    else
      AllowExpansion := false;
  end
end;

{****************************************************************
*
*  D o D B C o n n e c t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: SelServerNode - The selected server
*         SelDatabaseNode - The selected database
*         SilentLogin - Indicates whether or not to perform
*                       a silent login
*
*  Return: None
*
*  Description: This procedure makes a call to the DBConnect function.
*               If a connection is established it also creates/initializes
*               the treenodes under the database node
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.DoDBConnect(const SelServerNode: TibcServerNode;
  var SelDatabaseNode: TibcDatabaseNode;
  const SilentLogin: boolean): boolean;
var
  lDatabaseNode: TTreeNode;
begin
  Result := True;
  if Assigned(SelServerNode) and Assigned(SelDatabaseNode) then
  begin
    if frmuDBConnect.DBConnect(SelDatabaseNode,SelServerNode,SilentLogin) then
    begin
      lDatabaseNode := tvMain.Items.GetNode(SelDatabaseNode.NodeID);

      if not lDatabaseNode.HasChildren then
      begin
        lDatabaseNode.ImageIndex := NODE_DATABASES_CONNECTED_IMG;
        lDatabaseNode.SelectedIndex := NODE_DATABASES_CONNECTED_IMG;

        AddTreeRootNode (NODE_DOMAINS, lDatabaseNode);
        AddTreeRootNode (NODE_TABLES, lDatabaseNode);
        AddTreeRootNode (NODE_VIEWS, lDatabaseNode);
        AddTreeRootNode (NODE_PROCEDURES, lDatabaseNode);
        AddTreeRootNode (NODE_FUNCTIONS, lDatabaseNode);
        AddTreeRootNode (NODE_GENERATORS, lDatabaseNode);
        AddTreeRootNode (NODE_EXCEPTIONS, lDatabaseNode);
        AddTreeRootNode (NODE_BLOB_FILTERS, lDatabaseNode);
        AddTreeRootNode (NODE_ROLES, lDatabaseNode);
      end;

      if FRegistry.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey,SelServerNode.Nodename,SelDatabaseNode.Nodename]),false) then
      begin
        FRegistry.WriteString('Username',SelDatabaseNode.Username);
        FRegistry.WriteString('Role',SelDatabaseNode.Role);
        FRegistry.WriteBool('CaseSensitiveRole', SelDatabaseNode.CaseSensitiveRole);
        FRegistry.WriteDateTime('Last Accessed', Now);
        FRegistry.CloseKey;
      end;
      tvMainChange(nil,nil);

      if Assigned(lDatabaseNode) then
        lDatabaseNode.Expand (false);
    end
    else
      result := false;
  end;
end;

{****************************************************************
*
*  D o D B D i s c o n n e c t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  SelDatabaseNode - The selected database
*
*  Return: None
*
*  Description: This procedure disconnects the specified database
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.DoDBDisconnect(var SelDatabaseNode: TibcDatabaseNode): boolean;
begin
  if not Assigned(SelDatabaseNode) then
  begin
    result := false;
    exit;
  end;

  try
    if SelDatabaseNode.Database.Connected then
    begin
      SelDatabaseNode.Database.Connected := false;
      if Assigned(SelDatabaseNode.ObjectViewer) and
        (SelDatabaseNode.ObjectViewer.WindowState in [wsNormal, wsMinimized, wsMaximized])
      then
        SelDatabaseNode.ObjectViewer.Close;
        
      Application.ProcessMessages;
    end;
    result := true;
  except
    on E:EIBError do
    begin
      DisplayMsg(ERR_DB_DISCONNECT,E.Message);
      result := false;
    end;
  end;
end;

{****************************************************************
*
*  G e t B a c k u p F i l e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: SelServerNode - The selected server
*         SelTreeNode - The selected tree node
*
*  Return: integer - Indicates the success/failure of the operation
*
*  Description: This precedure retrieves a list of Backup aliases for the
*               selected server from the treeview structure
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.GetBackupFiles(const SelServerNode: TibcServerNode): integer;
var
  lObjectList: TStringList;
  lCurrParentNode, lCurrChildNode: TTreeNode;
begin
  lObjectList := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    lObjectList.AddObject('Name',nil);
    lCurrParentNode := tvMain.Items.GetNode(SelServerNode.BackupFilesID);
    lCurrChildNode := lCurrParentNode.GetFirstChild;
    while lCurrChildNode <> nil do
    begin
      lObjectList.AddObject(lCurrChildNode.Text, lCurrChildNode);
      lCurrChildNode := lCurrParentNode.GetNextChild(lCurrChildNode);
    end;
    TibcTreeNode(lCurrParentNode.Data).ObjectList.Assign(lObjectList);
    result := SUCCESS;
  finally
    lObjectList.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  G e t D D L S c r i p t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: None
*
*  Return: integer - Indicates the success/failure of the operation
*
*  Description: This procedure determines the type of the selected
*               treenode and calls the appropriate function in order to
*               retrieve the DDL script for the object(s).
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.GetDDLScript: integer;
var
  lSQLScript: TStringList;
  IBExtract : TIBExtract;

begin
  Result := 0;
  if (not Assigned(FCurrSelDatabase)) and (not Assigned (FCurrSelTreeNode)) then
    exit;
  lSQLScript := nil;
  try
    lSQLScript := TStringList.Create;
    lSQLScript.Text := '';
    Screen.Cursor := crHourGlass;
    IBExtract := TIBExtract.Create(self);
    with IBExtract do
    begin
      Database := FCurrSelDatabase.Database;
      ShowSystem := FViewsystemData;
      ObjectType := eoDatabase;
      Items := lSqlScript;
      ExtractObject;
      Free;
    end;
  finally
    FCurrSelServer.ShowText(lSQLScript, 'Database Metadata');
    Screen.Cursor := crDefault;
    lSQLScript.Free;
  end;
end;

{****************************************************************
*
*  G e t D a t a b a s e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: SelServerNode - The selected server
*
*  Return: integer - Indicates the success/failure of the operation
*
*  Description: This procedure retrieves a list of databases for the
*               specified server from the treeview structure
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.GetDatabases(const SelServerNode: TibcServerNode): integer;
var
  lObjectList: TStringList;
  lCurrParentNode,lCurrChildNode: TTreeNode;
  lDBNode: TibcDatabaseNode;
begin
  lObjectList := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    lObjectList.AddObject(Format('Name%sPath',[DEL,DEL,DEL]),nil);
    lCurrParentNode := tvMain.Items.GetNode(SelServerNode.DatabasesID);
    lCurrChildNode := lCurrParentNode.GetFirstChild;
    while lCurrChildNode <> nil do
    begin
      lDbNode := TibcDatabaseNode(lCurrChildNode.Data);
      lObjectList.AddObject(Format('%s%s%s',[lCurrChildNode.Text,DEL ,lDBNode.DatabaseFiles[0]]),lCurrChildNode);
      lCurrChildNode := lCurrParentNode.GetNextChild(lCurrChildNode);
    end;
    TibcTreeNode(lCurrParentNode.Data).ObjectList.Assign(lObjectList);
    result := SUCCESS;
  finally
    lObjectList.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  G e t S e r v e r s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: None
*
*  Return: Returns a status code indicating the success/failure of
*          the operation.
*
*  Description: Get's a list of registered servers
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.GetServers: integer;
var
  lObjectList: TStringList;
  lCurrChildNode: TTreeNode;
  lNode: TibcServerNode;
  Str, LastAccess: String;
  Connections: integer;

begin
  lObjectList := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    lObjectList.AddObject(Format('Name%sDescription%sLast Accessed%sConnections',[DEL,DEL, DEL]),nil);
    lCurrChildNode := tvMain.Items[0].GetFirstChild;
    while lCurrChildNode <> nil do
    begin
      lNode := TibcServerNode(lCurrChildNode.Data);
      Connections := 0;
      if lNode.Server.Active then
      begin
        lNode.Server.FetchDatabaseInfo;
        Connections := lNode.Server.DatabaseInfo.NoOfAttachments;
      end;
      LastAccess := DateTimeToStr(lNode.LastAccessed);
      Str := Format('%s%s%s%s%s%s%d',[lCurrChildNode.Text,DEL,lNode.Description,DEL,LastAccess,DEL, Connections]);
      lObjectList.AddObject(Str,lCurrChildNode);
      lCurrChildNode := tvMain.Items[0].GetNextChild(lCurrChildNode);
    end;
    TibcServerNode(tvMain.Items[0].Data).ObjectList.Assign(lObjectList);
    result := SUCCESS;
  finally
    lObjectList.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  G e t U s e r s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.GetUsers(const SelServerNode: TibcServerNode; const SelTreeNode: TibcTreeNode): integer;
var
  lObjectList: TStringList;
  lSecurityService: TIBSecurityService;
  lUserCount: integer;
  lUserInfo: TUserInfo;
  lPrevUsername: string;
begin
  result := FAILURE;
  lUserCount := 0;
  lPrevUsername := '';
  lObjectList := TStringList.Create;
  lSecurityService := TIBSecurityService.Create(nil);
  try
    Application.ProcessMessages;
    Screen.Cursor := crHourGlass;
    with lSecurityService do
    begin
      try
        LoginPrompt := false;
        ServerName := FCurrSelServer.Server.ServerName;
        Protocol := FCurrSelServer.Server.Protocol;
        Params.Assign(FCurrSelServer.Server.Params);
        Attach;
        if Active then
        begin
          DisplayUsers;
          while (IsServiceRunning) and (not gApplShutdown) do
            Application.ProcessMessages;
        end;
      except
        on E:EIBError do
        begin
          DisplayMsg(ERR_GET_USERS, E.Message);
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            SetErrorState;
          exit;
        end;
      end;

      lUserInfo := UserInfo[lUserCount];
      lObjectList.Add(Format('User Name%sFirst Name%sMiddle Name%sLast Name',[DEL,DEL,DEL]));
      while (lUserInfo.UserName <> '') and (lUserInfo.UserName <> lPrevUsername) do
      begin
        lObjectList.Add(Format('%s%s%s%s%s%s%s',[lUserInfo.UserName,DEL,lUserInfo.FirstName,DEL,
          lUserInfo.MiddleName,DEL,lUserInfo.LastName]));
        lPrevUsername := lUserInfo.UserName;
        inc(lUserCount);
        lUserInfo := UserInfo[lUserCount];
        Application.ProcessMessages;                        
      end;
      result := SUCCESS;
      SelTreeNode.ObjectList.Assign(lObjectList);
    end;
  finally
    lObjectList.Free;
    if lSecurityService.Active then
      lSecurityService.Detach;
    lSecurityService.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  R e g i s t e r B a c k u p F i l e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.RegisterBackupFile(const SelServerNode: TibcServerNode; const SourceDBAlias,
  BackupAlias: string; BackupFiles: TStringList): boolean;
var
  lBackupAliasNode: TTreeNode;
begin
  try
    tvMain.Items.BeginUpdate;
    lBackupAliasNode := tvMain.Items.AddChild(tvMain.Items.GetNode(SelServerNode.BackupFilesID), '');
    lBackupAliasNode.Data := TibcBackupAliasNode.Create(tvMain,lBackupAliasNode.ItemId,
      BackupAlias, Now, Now, NODE_BACKUP_ALIAS);
    lBackupAliasNode.Text := BackupAlias;
    lBackupAliasNode.SelectedIndex := NODE_BACKUP_ALIAS_IMG;
    lBackupAliasNode.ImageIndex := NODE_BACKUP_ALIAS_IMG;
    TibcBackupAliasNode(lBackupAliasNode.Data).SourceDBServer := SelServerNode.NodeName;
    TibcBackupAliasNode(lBackupAliasNode.Data).SourceDBAlias := SourceDBAlias;
    TibcBackupAliasNode(lBackupAliasNode.Data).BackupFiles.Assign(BackupFiles);
    TibcBackupAliasNode(lBackupAliasNode.Data).Created := Now;
    TibcBackupAliasNode(lBackupAliasNode.Data).LastAccessed := Now;

    if FRegistry.OpenKey(Format('%s%s\Backup Files',[gRegServersKey,SelServerNode.Nodename]),true) then
    begin
      if FRegistry.OpenKey(Format('%s%s\Backup Files\%s',[gRegServersKey,SelServerNode.Nodename,BackupAlias]),true) then
      begin
        FRegistry.WriteString('SourceDBServer',SelServerNode.NodeName);
        FRegistry.WriteString('SourceDBAlias',SourceDBAlias);
        FRegistry.WriteString('BackupFiles',BackupFiles.Text);

        if not FRegistry.KeyExists ('Created') then
          FRegistry.WriteDateTime ('Created', TibcBackupAliasNode(lBackupAliasNode.Data).Created);

        FRegistry.WriteDateTime ('Accessed', TibcBackupAliasNode(lBackupAliasNode.Data).LastAccessed);
        FRegistry.CloseKey;
      end;
    end;
  finally
    tvMain.Items.EndUpdate;
    tvMainChange(nil,nil);
    GetBackupFiles(FCurrSelServer);
    result := true;
  end;
end;

{****************************************************************
*
*  R e g i s t e r D a t a b a s e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.RegisterDatabase(const SelServerNode: TibcServerNode;
  const DBAlias,UserName,Password,Role: string; DatabaseFiles: TStringList;
  SaveAlias, CaseSensitive: boolean; var NewDatabase: TIBDatabase): boolean;
var
  lDatabaseNode,lCurrNode: TTreeNode;
  tmpDatabase: TIBDatabase;
begin
  try
    if Assigned (NewDatabase) then
      tmpDatabase := NewDatabase
    else
      tmpDatabase := FNILLDATABASE;
    tvMain.Items.BeginUpdate;
    lDatabaseNode := tvMain.Items.AddChild(tvMain.Items.GetNode(SelServerNode.DatabasesID), '');
    lDatabaseNode.Data := TibcDatabaseNode.Create(tvMain,lDatabaseNode.ItemId,DBAlias,
      NODE_DATABASE,DatabaseFiles, tmpDatabase);
    lDatabaseNode.Text := TibcDatabaseNode(lDatabaseNode.Data).NodeName;
    FCurrSelDatabase := TibcDatabaseNode(lDatabaseNode.Data);
    FCurrSelDatabase.UserName := Username;
    FCurrSelDatabase.Password := Password;
    FCurrSelDatabase.Role := Role;
    FCurrSelDatabase.CaseSensitiveRole := CaseSensitive;
    lDatabaseNode.SelectedIndex := NODE_DATABASES_DISCONNECTED_IMG;
    lDatabaseNode.ImageIndex := NODE_DATABASES_DISCONNECTED_IMG;
    lCurrNode := tvMain.Items.GetNode(SelServerNode.DatabasesID);
    lCurrNode.expand(false);
    tvMain.Selected := lDatabaseNode;

    if SaveAlias then
    begin
      if FRegistry.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey,SelServerNode.NodeName,DBAlias]),true) then
      begin
{TODO: Write more here too! }
        FRegistry.WriteString('DatabaseFiles',DatabaseFiles.Text);
        FRegistry.WriteString('Username',Username);
        FRegistry.WriteString('Role',Role);
        FRegistry.WriteBool('CaseSensitiveRole', CaseSensitive);
        FRegistry.CloseKey;
      end;
    end;
  finally
    tvMain.Items.EndUpdate;
    tvMainChange(nil,nil);
    GetDatabases(FCurrSelServer);
    result := true;
  end;
end;

{****************************************************************
*
*  R e g i s t e r S e r v e r ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.RegisterServer(const ServerName,ServerAlias,UserName,
                                 Password, Description: string;
                                 Protocol: TProtocol; SaveAlias: boolean;
                                 LastAccess: TDateTime): boolean;
var
  lServerNode: TTreeNode;
begin
  try
    tvMain.Items.BeginUpdate;
    lServerNode := tvMain.Items.AddChild(tvMain.Items[0], ServerAlias);
    if Protocol = Local then
      lServerNode.MoveTo(tvMain.Items[0],naAddChildFirst);
    lServerNode.Data := TibcServerNode.Create(tvMain,lServerNode.ItemId,ServerAlias,ServerName,UserName,Password, Description,Protocol, LastAccess, NODE_SERVER);

    lServerNode.SelectedIndex := 1;
    lServerNode.ImageIndex := 1;
    tvMain.Items[0].expand(false);

    FCurrSelServer := TibcServerNode(lServerNode.Data);
    tvMain.Selected := lServerNode;
    if SaveAlias then
    begin
      if FRegistry.OpenKey(Format('%s%s',[gRegServersKey,ServerAlias]),true) then
      begin
        FRegistry.WriteString('ServerName',ServerName);
        case Protocol of
          TCP: FRegistry.WriteInteger('Protocol',0);
          NamedPipe: FRegistry.WriteInteger('Protocol',1);
          SPX: FRegistry.WriteInteger('Protocol',2);
          Local: FRegistry.WriteInteger('Protocol',3);
        end;
        FRegistry.WriteString('Username',Username);
        FRegistry.WriteString('Description', Description);
        FRegistry.WriteDateTime('Last Accessed', LastAccess);
        FRegistry.CloseKey;
      end;
    end;
  finally
    tvMain.Items.EndUpdate;
    tvMainChange(nil,nil);
    GetServers;
    result := true;
  end;
end;

{****************************************************************
*
*  D e l e t e N o d e ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.DeleteNode(const Node: TTreeNode; const ChildNodesOnly: boolean);
begin
  if Assigned (Node) then
  begin
    { Any connected nodes are deleted in the destructor for
      TIBCDatabaseNode }
    Node.DeleteChildren;
    if not ChildNodesOnly then
      Node.Delete;
    tvMain.Refresh;
    Application.ProcessMessages;
  end;
end;

{****************************************************************
*
*  D o S e r v e r L o g i n ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: SilentLogin - Indicates wheather or not to prompt the
*         user for login information.
*
*  Return: None
*
*  Description: This procedure makes a call to the server login function
*               and refreshes the treeview depending on the success/failure
*               of the login
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.DoServerLogin(const SilentLogin: boolean): boolean;
var
  lServerNode,lCurrNode: TTreeNode;
  lDatabases,lBackupAliases,lBackupFiles,lDatabaseFiles: TStringList;
  i: integer;
  lCaseSensitive: boolean;
  lDBUserName,lRole,lSourceDBServer,lSourceDBAlias: string;
begin
  lDatabases := nil;
  lBackupAliases := nil;
  lBackupFiles := nil;
  lDatabaseFiles := nil;
  result := false;
  lCaseSensitive := false;

  if Assigned(FCurrSelServer) then
  begin
    try
      if FCurrSelServer.Server.Protocol = Local then
      begin
        if not IsIBRunning then
        begin
          if MessageDlg('The server has not been started. Would you like to start it now?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            if not StartServer then
              Exit;
          end
          else
            Exit;
        end;
      end;
      if frmuServerLogin.ServerLogin(FCurrSelServer,SilentLogin) then
      begin
        result := true;
        try
          lDatabases := TStringList.Create;
          lBackupAliases := TStringList.Create;
          lBackupFiles := TStringList.Create;
          lDatabaseFiles := TStringList.Create;

          lServerNode := tvMain.Items.GetNode(FCurrSelServer.NodeID);
          lServerNode.SelectedIndex := NODE_SERVERS_ACTIVE_IMG;
          lServerNode.ImageIndex := NODE_SERVERS_ACTIVE_IMG;
          lServerNode.Expand(True);

          if FCurrSelServer.Version < 6 then
          begin
            DisplayMsg(ERR_SERVER_LOGIN,
              Format('An error occured while trying to connect to ''%s''.  This server may be an earlier version.  As a result many features will be not work properly.',
              [FCurrSelServer.NodeName]));
          end;

          if not lServerNode.HasChildren then
          begin
          lCurrNode := tvMain.Items.AddChild(lServerNode, NODE_ARRAY[NODE_DATABASES]);
          lCurrNode.Data := TibcTreeNode.Create(tvMain,lCurrNode.ItemID,'',NODE_DATABASES);
          TibcServerNode(lServerNode.Data).DatabasesID := lCurrNode.ItemID;
          lCurrNode.ImageIndex := NODE_DATABASES_IMG;
          lCurrNode.SelectedIndex := NODE_DATABASES_IMG;

          lCurrNode := tvMain.Items.AddChild(lServerNode, NODE_ARRAY[NODE_BACKUP_ALIASES]);
          lCurrNode.Data := TibcTreeNode.Create(tvMain,lCurrNode.ItemID,'',NODE_BACKUP_ALIASES);
          TibcServerNode(lServerNode.Data).BackupFilesID := lCurrNode.ItemID;
          lCurrNode.ImageIndex := NODE_BACKUP_ALIASES_IMG;
          lCurrNode.SelectedIndex := NODE_BACKUP_ALIASES_IMG;

          lCurrNode := tvMain.Items.AddChild(lServerNode, NODE_ARRAY[NODE_CERTIFICATES]);
          lCurrNode.Data := TibcTreeNode.Create(tvMain,lCurrNode.ItemID,'',NODE_CERTIFICATES);
          lCurrNode.ImageIndex := NODE_CERTIFICATES_IMG;
          lCurrNode.SelectedIndex := NODE_CERTIFICATES_IMG;

          lCurrNode := tvMain.Items.AddChild(lServerNode, NODE_ARRAY[NODE_LOGS]);
          lCurrNode.Data := TibcTreeNode.Create(tvMain,lCurrNode.ItemID,'',NODE_LOGS);
          lCurrNode.ImageIndex := NODE_LOGS_IMG;
          lCurrNode.SelectedIndex := NODE_LOGS_IMG;

          lCurrNode := tvMain.Items.AddChild(lServerNode, NODE_ARRAY[NODE_USERS]);
          lCurrNode.Data := TibcTreeNode.Create(tvMain,lCurrNode.ItemID,'',NODE_USERS);
          lCurrNode.ImageIndex := NODE_USERS_IMG;
          lCurrNode.SelectedIndex := NODE_USERS_IMG;
          end;

          tvMain.Refresh;
          FcurrSelServer.LastAccessed := Now;
          if FRegistry.OpenKey(Format('%s%s',[gRegServersKey,FCurrSelServer.NodeName]),false) then
          begin
            FRegistry.WriteString('Username',FCurrSelServer.Username);
            FRegistry.WriteDateTime('Last Accessed', Now);

            if FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.NodeName]),false) then
            begin
              FRegistry.GetKeyNames(lDatabases);
              for i := 0 to lDatabases.Count - 1 do
              begin
                if FRegistry.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey,FCurrSelServer.NodeName,lDatabases[i]]),false) then
                begin
                  lDatabaseFiles.text := FRegistry.ReadString('DatabaseFiles');
                  lDBUserName := FRegistry.ReadString('Username');
                  lRole := FRegistry.ReadString('Role');
                  try
                    lCaseSensitive := FRegistry.ReadBool('CaseSensitiveRole');
                  except on E: Exception do
                    lCaseSensitive := false;
                  end;
                  RegisterDatabase(FCurrSelServer,lDatabases[i],lDBUserName,'',
                    lRole,lDatabaseFiles,true, lCaseSensitive, FNILLDATABASE);
                end;
              end;
            end;

            if FRegistry.OpenKey(Format('%s%s\Backup Files',[gRegServersKey,FCurrSelServer.NodeName]),false) then
            begin
              FRegistry.GetKeyNames(lBackupAliases);
              for i := 0 to (lBackupAliases.Count - 1) do
              begin
                if FRegistry.OpenKey(Format('%s%s\Backup Files\%s',[gRegServersKey,FCurrSelServer.NodeName,lBackupAliases[i]]),false) then
                begin
                  lSourceDBServer := FRegistry.ReadString('SourceDBServer');
                  lSourceDBAlias := FRegistry.ReadString('SourceDBAlias');
                  lBackupFiles.Text := FRegistry.ReadString('BackupFiles');
                  RegisterBackupFile(FCurrSelServer,lSourceDBAlias,lBackupAliases[i],lBackupFiles)
                end;
              end;
            end;
            FRegistry.CloseKey;
          end;
        finally
          lDatabases.Free;
          lBackupFiles.Free;
          lBackupAliases.Free;
          lDatabaseFiles.Free;
        end;
      end;
    finally
      tvMainChange(nil,nil);
    end;
  end;
end;

{****************************************************************
*
*  F i l l O b j e c t L i s t ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.FillObjectList(const CurrSelNode: TibcTreeNode);
var
  loListItem: TListItem;
  loListColumn: TListColumn;
  lsCurrLine: string;
  i: integer;

begin
  if not Assigned(CurrSelNode.ObjectList) or
     (CurrSelNode.NodeType in [NODE_SERVER, NODE_DATABASE, NODE_TABLE]) then
    exit;

  case CurrSelNode.NodeType of
    NODE_SERVERS,
    NODE_DATABASES,
    NODE_USERS,
    NODE_CERTIFICATES,
    NODE_BACKUP_ALIASES:
     lvObjects.Tag := STATIC;
    else
     lvObjects.Tag := OBJECTS;
  end;

  FLastActions := nil;
  lvObjects.SmallImages := imgTreeView;
  lvObjects.StateImages := imgTreeView;
  lvObjects.LargeImages := imgLargeView;

  if (CurrSelNode.ObjectList.Count = 0) then
  begin
    lvObjects.Items.BeginUpdate;
    lvObjects.Items.Clear;

    lvObjects.Columns.BeginUpdate;
    lvObjects.Columns.Clear;

    lvObjects.Items.EndUpdate;
    lvObjects.Columns.EndUpdate;
  end
  else
  begin
    Screen.Cursor := crHourglass;

    lvObjects.Items.BeginUpdate;
    lvObjects.Items.Clear;

    lvObjects.Columns.BeginUpdate;
    lvObjects.Columns.Clear;

    lvObjects.AllocBy := CurrSelNode.ObjectList.Count;

    lsCurrLine := CurrSelNode.ObjectList.Strings[0];
    while Length(lsCurrLine) > 0 do
    begin
      loListColumn := lvObjects.Columns.Add;
      loListColumn.Caption := GetNextField(lsCurrLine, DEL);
    end;

    for i := 1  to CurrSelNode.ObjectList.Count - 1 do
    begin
      lsCurrLine := CurrSelNode.ObjectList.Strings[i];
      loListItem := lvObjects.Items.Add;
      loListItem.Caption := GetNextField(lsCurrLine, DEL);

      if Assigned(CurrSelNode.ObjectList.Objects[i]) then
      begin
        loListItem.Data := CurrSelNode.ObjectList.Objects[i];
      end;

      case CurrSelNode.NodeType of
        NODE_SERVERS:
        begin
          if Assigned(CurrSelNode.ObjectList.Objects[i]) then
          begin
            if TibcServerNode(TTreeNode(CurrSelNode.ObjectList.Objects[i]).Data).Server.Active then
              loListItem.ImageIndex := NODE_SERVERS_ACTIVE_IMG
            else
              loListItem.ImageIndex := NODE_SERVERS_INACTIVE_IMG;
          end;
        end;

        NODE_DATABASES:
        begin
          if Assigned(CurrSelNode.ObjectList.Objects[i]) then
          begin
          if TibcDatabaseNode(TTreeNode(CurrSelNode.ObjectList.Objects[i]).Data).Database.Connected then
            loListItem.ImageIndex := NODE_DATABASES_CONNECTED_IMG
          else
            loListItem.ImageIndex := NODE_DATABASES_DISCONNECTED_IMG;
          end;
        end;

        NODE_BACKUP_ALIASES: loListItem.ImageIndex := NODE_BACKUP_ALIASES_IMG;
        NODE_USERS: loListItem.ImageIndex := NODE_USERS_IMG;
        NODE_CERTIFICATES: loListItem.ImageIndex := NODE_CERTIFICATES_IMG;
        
        NODE_DOMAINS: loListItem.ImageIndex := NODE_DOMAINS_IMG;
        NODE_TABLES: loListItem.ImageIndex := NODE_TABLES_IMG;
        NODE_VIEWS: loListItem.ImageIndex := NODE_VIEWS_IMG;
        NODE_PROCEDURES: loListItem.ImageIndex := NODE_PROCEDURES_IMG;
        NODE_FUNCTIONS: loListItem.ImageIndex := NODE_FUNCTIONS_IMG;
        NODE_GENERATORS: loListItem.ImageIndex := NODE_GENERATORS_IMG;
        NODE_EXCEPTIONS: loListItem.ImageIndex := NODE_EXCEPTIONS_IMG;
        NODE_BLOB_FILTERS: loListItem.ImageIndex := NODE_BLOB_FILTERS_IMG;
        NODE_ROLES: loListItem.ImageIndex := NODE_ROLES_IMG;
        NODE_COLUMNS: loListItem.ImageIndex := NODE_COLUMNS_IMG;
        NODE_INDEXES: loListItem.ImageIndex := NODE_INDEXES_IMG;
        NODE_REFERENTIAL_CONSTRAINTS: loListItem.ImageIndex := NODE_REFERENTIAL_CONSTRAINTS_IMG;
        NODE_UNIQUE_CONSTRAINTS: loListItem.ImageIndex := NODE_UNIQUE_CONSTRAINTS_IMG;
        NODE_CHECK_CONSTRAINTS: loListItem.ImageIndex := NODE_CHECK_CONSTRAINTS_IMG;
        NODE_TRIGGERS: loListItem.ImageIndex := NODE_TRIGGERS_IMG;
      end;

      while Length(lsCurrLine) > 0 do
      begin
        loListItem.SubItems.Add(GetNextField(lsCurrLine, DEL));
      end;
    end;
    for i := 0 to lvObjects.Columns.Count -1 do
    begin
      lvObjects.Columns[i].Width := ColumnHeaderWidth;     
    end;
    lvObjects.Columns.EndUpdate;
    lvObjects.Items.EndUpdate;

    Application.ProcessMessages;
    Screen.Cursor := crDefault;
    stbMain.Panels[3].Text := Format('%d objects listed',[lvObjects.Items.Count]);
  end;
end;

{****************************************************************
*
*  I n i t R e g i s t r y ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: None
*
*  Return: None
*
*  Description: Initializes the registry with default values
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.InitRegistry;
var
  lCnt: integer;

begin
  with FRegistry do begin
    OpenKey('Software',true);
    OpenKey('Borland',true);
    OpenKey('InterBase',true);
    OpenKey('IBConsole',true);
    CreateKey('Servers');
    gRegServersKey := Format('\%s\Servers\',[CurrentPath]);
    CreateKey('Settings');
    gRegSettingsKey := Format('\%s\Settings',[CurrentPath]);
    gRegToolsKey := Format('%s\Tools',[gRegSettingsKey]);
  end;

  with FRegistry do begin
    OpenKey(gRegSettingsKey,false);
    for lCnt := 0 to NUM_SETTINGS-1 do begin
      if not ValueExists (gAppSettings[lCnt].Name) then begin
        case (VarType(gAppSettings[lCnt].Setting) and varTypeMask) of
          varSmallint: WriteInteger (gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
          varInteger: WriteInteger (gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
          varBoolean: WriteBool (gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
          varString: WriteString (gAppSettings[lCnt].Name, gAppSettings[lCnt].Setting);
        end;
      end;
    end;
    CloseKey;
  end;
end;

{****************************************************************
*
*  I n i t T r e e V i e w ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return: None
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.InitTreeView;
var
  lCurrNode: TTreeNode;
begin
  lCurrNode := tvMain.Items.GetFirstNode;
  lCurrNode.Data := TibcTreeNode.Create(tvMain, lCurrNode.ItemID,'',NODE_SERVERS);
  lCurrNode.ImageIndex :=  0;
  lCurrNode.SelectedIndex := 0;
end;

{****************************************************************
*
*  R e a d R e g i s t r y ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input: None
*
*  Return: None
*
*  Description: This procedure reads application settings from
*               the registry.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TfrmMain.ReadRegistry;
var
  lServerName,lServerAlias,lServerUserName, lDescription: string;
  lLastAccessed: TDateTime;
  lProtocol: TProtocol;
  lServers: TStringList;
  i, j: integer;
  lTempInt, lResult: integer;
  lException: boolean;
  lMessage: String;

begin
  lServers := TStringList.Create;
  try
    InitTreeView;
    with FRegistry do begin
      { Read Option Settings }
      OpenKey(gRegSettingsKey,false);
      for i:= 0 to NUM_SETTINGS-1 do begin
        case i of
          SYSTEM_DATA..CLEAR_INPUT:
              gAppSettings[i].Setting := ReadBool(gAppSettings[i].Name);
          CHARACTER_SET..ISQL_TERMINATOR:
              gAppSettings[i].Setting := ReadString(gAppSettings[i].Name);
          COMMIT_ON_EXIT..DEFAULT_DIALECT:
              gAppSettings[i].Setting := ReadInteger(gAppSettings[i].Name);
        end;
      end;

      lTempInt := gAppSettings[VIEW_STYLE].Setting;;
      case lTempInt of
        0: ViewIcon.OnExecute(self);
        1: ViewSmallIcon.OnExecute(self);
        2: ViewList.OnExecute(self);
        3: ViewReport.OnExecute(self);
      end;
      FViewSystemData := gAppSettings[SYSTEM_DATA].Setting;

      { Get the window state }
      if ValueExists('MainState') then
        ReadBinaryData ('MainState', FMainWindowState, Sizeof(FMainwindowState));

      if ValueExists('ObjState') then
        ReadBinaryData ('ObjState', FObjectWindowState, Sizeof(FMainwindowState));

      if ValueExists('SQLState') then
        ReadBinaryData ('SQLState', FISQLWindowState, Sizeof(FMainwindowState));

      CloseKey; { end read options settings}

      { Read the external tools }

      gExternalApps := TStringList.Create;
      if OpenKey (gRegToolsKey, false) and ValueExists('Count') then
      begin
        i := ReadInteger ('Count');
        for j := 0 to i - 1 do
          gExternalApps.Add (ReadString (Format('Title%d', [j])));
      end;
      CloseKey;

      { Read the servers }
      if OpenKey(gRegServersKey,false) then begin
        GetKeyNames(lServers);
        for i := 0 to lServers.Count - 1 do begin
          lServerName := '';
          lServerUserName := '';
          lDescription := '';
          lLastAccessed := Now;
          lTempInt := -1;
          lException := false;
          lResult := mrOK;
          lProtocol := Local;
          if OpenKey(Format('%s%s',[gRegServersKey, lServers.Strings[i]]),false) then begin
            try
              lTempInt := ReadInteger('Protocol');
              case lTempInt of
                0: lProtocol := TCP;
                1: lProtocol := NamedPipe;
                2: lProtocol := SPX;
                3: lProtocol := Local;
              end;

              lServerName := ReadString('ServerName');
              if lServerName = '' then
              begin
                { Attempt to read the other settings }
                lServerUserName := ReadString('UserName');
                raise Exception.Create('Failed to get data for ''ServerName''.');
              end;

              lServerUserName := ReadString('UserName');
              if lServerUserName = '' then
                raise Exception.Create('Failed to get data for ''UserName''.');

              try
                lDescription := ReadString('Description');
                lLastAccessed := ReadDateTime ('Last Accessed');
              except
                begin
                  lLastAccessed := Now;
                  lDescription := '';
                end;
              end;

            except on E: Exception do
              begin
                lException := true;
                lMessage := E.Message;
                lServerUserName := ReadString('UserName');
                lServerName := ReadString('ServerName');                
              end;
            end;

            if lException then
              lResult := DisplayModifyAlias (lServers.Strings[i], lServerName, lServerUserName,
                                             lTempInt, lMessage);
            if lResult = mrOK then
              RegisterServer(lServerName,lServers.Strings[i],lServerUserName,'',
                             lDescription,lProtocol, lException, lLastAccessed)
            else begin
              while not (UnRegisterServer (lServerAlias)) do begin
                lResult := DisplayModifyAlias (lServers.Strings[i], lServerName, lServerUserName,
                                               lTempInt, lMessage);
                if lResult = mrOK then begin
                  RegisterServer(lServerName,lServers.Strings[i],lServerUserName,'',
                                 lDescription, lProtocol, lException, lLastAccessed);
                  break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    finally
      FRegistry.CloseKey;
      lServers.Free;
      Application.ProcessMessages;
    end;
end;

procedure TfrmMain.RenameTreeNode(SelTreeNode: TibcTreeNode; NewNodeName: string);
var
  lSelTreeNode: TTreeNode;
  idx: Integer;

begin

  lSelTreeNode := tvMain.Items.GetNode(SelTreeNode.NodeID);
  if SelTreeNode is TIBCServerNode then
  begin
    with TibcTreeNode(frmMain.tvMain.Items[0].Data).ObjectList do
    begin
      for idx := 0 to Count - 1 do
        if Pos(lSelTreeNode.Text, Strings[Idx]) = 1 then
        begin
          Strings[idx] := newNodeName;
          break;
        end;
    end;
  end;
  lSelTreeNode.Text := NewNodeName;
  tvMain.Refresh;
end;

{****************************************************************
*
*  G e t C e r t i f i c a t e s ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   May 4, 1999
*
*  Input: SelServerNode - The selected server
*         SelTreeNode - The selected treenode
*
*  Return: interger - Indicates the success/failure of the operation
*
*  Description: Retrieves a list of certificates for the selected server
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TfrmMain.GetCertificates(const SelServerNode: TibcServerNode; const SelTreeNode: TibcTreeNode): integer;
var
  lObjectList: TStringList;
  i: integer;
begin
  lObjectList := TStringList.Create;
  try
    SelServerNode.Server.LoginPrompt := false;
    try
      if not SelServerNode.server.Active then
        SelServerNode.server.Attach;
      SelServerNode.Server.FetchLicenseInfo;
      lObjectList.Add(Format('Certificate ID%sCertificate Key%sDescription',[DEL,DEL]));
      for i:=0 to high(SelServerNode.Server.LicenseInfo.Key) do
        lObjectList.Add(Format('%s%s%s%s%s',
         [SelServerNode.Server.LicenseInfo.ID[i],DEL,
         SelServerNode.Server.LicenseInfo.Key[i],DEL,
         SelServerNode.Server.LicenseInfo.Desc[i]]));
      SelTreeNode.ObjectList.Assign(lObjectList);
      result := SUCCESS;
    except
      on E:EIBError do
      begin
        DisplayMsg(ERR_SERVER_SERVICE,E.Message + #13#10 + 'Cannot display server certificates');
        result := FAILURE;
        SelServerNode.Server.Active := true;
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          SetErrorState;
      end;
    end;
  finally
    lObjectList.Free;
  end;
end;

procedure TfrmMain.mmiHeContentsClick(Sender: TObject);
begin
   WinHelp(Handle,CONTEXT_HELP_FILE,HELP_FINDER,0);
end;

procedure TfrmMain.mmiHeOverviewClick(Sender: TObject);
begin
  WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_CONTEXT,GENERAL_OVERVIEW);
end;

procedure TfrmMain.mmiHeUsingHelpClick(Sender: TObject);
begin
   WinHelp(Handle,CONTEXT_HELP_FILE,HELP_HELPONHELP,0);
end;

procedure TfrmMain.mmiHeInterBaseHelpClick(Sender: TObject);
begin
   WinHelp(Handle,INTERBASE_HELP_FILE,HELP_FINDER,0);
end;

function TfrmMain.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  CallHelp := False;
  Result := WinHelp(WindowHandle,CONTEXT_HELP_FILE,HELP_FINDER,0);
end;

procedure TfrmMain.tvMainKeyPress(Sender: TObject; var Key: Char);
begin
  case Ord(Key) of
    VK_RETURN :
    begin
      Key := '0';
      case FCurrSelTreeNode.NodeType of
        NODE_SERVER :
          if (not FCurrSelServer.Server.Active) and (not FCurrSelServer.Version < 6) then
            tvMainDblClick(Nil);

        NODE_DATABASE :
          if (not FCurrSelDatabase.Database.Connected) then
             tvMainDblClick(Nil);

        NODE_SERVERS, NODE_BACKUP_ALIASES, NODE_DATABASES :
          tvMainDblClick(Nil);

        NODE_BACKUP_ALIAS, NODE_USERS, NODE_CERTIFICATES :
          tvMainDblClick(Nil);
      end;  // of case nodetype of
    end;
  end;  // of case ord(key) of 
end;

procedure TfrmMain.tvMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    tvMain.Selected := tvMain.GetNodeAt(X,Y);
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  splVertical.Left := tvMain.Width;
  splVertical.Width := 3;
end;


procedure TfrmMain.lvObjectsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if (FCurrSelTreeNode.NodeType = NODE_CERTIFICATES) then
  begin
    FCurrSelCertificateID := Item.Caption;
    FCurrSelCertificateKey := Item.SubItems.Strings[0];
  end;
end;
function TfrmMain.AliasExists(const AliasName: String): boolean;
var
  lAliases: TStringList;
begin
  result := false;
  lAliases := TStringList.Create;
  FRegistry.OpenKey(gRegServersKey,false);
  if FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.ServerName]),false) then
    FRegistry.GetKeyNames(lAliases);
  FRegistry.CloseKey;

  if lAliases.IndexOf(AliasName) <> -1 then
    result := true;
  lAliases.Free;
end;

function TfrmMain.IsDBRegistered(const DBFile : String; var ExistingDBAlias : String) : Boolean;
var
  lDatabaseFiles : TStringList;
  lDatabases     : TStringList;
  i              : Integer;
begin
  Result         := False;
  lDatabaseFiles := Nil;
  lDatabases     := Nil;

  try
    lDatabaseFiles := TStringList.Create;
    lDatabases := TStringList.Create;

    if FRegistry.OpenKey(gRegServersKey,false) then
    begin
      if FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.ServerName]),false) then
      begin
        FRegistry.GetKeyNames(lDatabases);
        i := 0;

        while (i < lDatabases.Count) do
        begin
          if FRegistry.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey,FCurrSelServer.ServerName,
            lDatabases[i]]),false) then
          begin
            lDatabaseFiles.Text := FRegistry.ReadString('DatabaseFiles');
            if lDatabaseFiles.Strings[0] = DBFile then
            begin
              ExistingDBAlias := lDatabases.Strings[i];
              Result := True;
              Exit;
            end;
          end;
          Inc(i);
        end;  // of database loop
      end;
    end;
  finally
    lDatabaseFiles.Free;
    lDatabases.Free;
    FRegistry.CloseKey;
  end;
  if result then
    if MessageDlg(Format('This database is already registered with the following alias: %s.%s'+
      'Are you sure you want to register this database again?',
      [ExistingDBAlias, #13#10]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      result := false
    else
      result := true;
end;

function TfrmMain.UnRegisterServer(const Node: String): boolean;
begin
  if MessageDlg(Format('Are you sure that you want to un-register %s?', [Node]),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FRegistry.DeleteKey(Format('%s%s\Databases',[gRegServersKey,Node]));
    FRegistry.DeleteKey(Format('%s%s',[gRegServersKey, Node]));
    FRegistry.CloseKey;
    result := true
  end
  else
    result := false;
end;

procedure TfrmMain.AddTreeRootNode(const ObjType: Integer; const Parent: TTreeNode);
var
  lCurrNode: TTreeNode;

begin
  lCurrNode := tvMain.Items.AddChild(Parent, NODE_ARRAY[Objtype]);
  lCurrNode.Data := TibcTreeNode.Create(tvMain,lCurrNode.ItemID,'',ObjType);

  case ObjType of
    NODE_DOMAINS:
    begin
      lCurrNode.ImageIndex := NODE_DOMAINS_IMG;
      lCurrNode.SelectedIndex := NODE_DOMAINS_IMG;
      TibcDatabaseNode(Parent.Data).DomainsID := lCurrNode.ItemID;
    end;
    NODE_TABLES:
    begin
      lCurrNode.ImageIndex := NODE_TABLES_IMG;
      lCurrNode.SelectedIndex := NODE_TABLES_IMG;
      TibcDatabaseNode(Parent.Data).TablesID := lCurrNode.ItemID;
    end;
    NODE_PROCEDURES:
    begin
      lCurrNode.ImageIndex := NODE_PROCEDURES_IMG;
      lCurrNode.SelectedIndex := NODE_PROCEDURES_IMG;
      TibcDatabaseNode(Parent.Data).ProceduresID := lCurrNode.ItemID;
    end;
    NODE_VIEWS:
    begin
      lCurrNode.ImageIndex := NODE_VIEWS_IMG;
      lCurrNode.SelectedIndex := NODE_VIEWS_IMG;
      TibcDatabaseNode(Parent.Data).ViewsID := lCurrNode.ItemID;
    end;
    NODE_TRIGGERS:
    begin
      lCurrNode.ImageIndex := NODE_TRIGGERS_IMG;
      lCurrNode.SelectedIndex := NODE_TRIGGERS_IMG;
      TibcDatabaseNode(Parent.Data).TriggersID := lCurrNode.ItemID;
    end;
    NODE_EXCEPTIONS:
    begin
      lCurrNode.ImageIndex := NODE_EXCEPTIONS_IMG;
      lCurrNode.SelectedIndex := NODE_EXCEPTIONS_IMG;
      TibcDatabaseNode(Parent.Data).ExceptionsID := lCurrNode.ItemID;
    end;
    NODE_BLOB_FILTERS:
    begin
      lCurrNode.ImageIndex := NODE_BLOB_FILTERS_IMG;
      lCurrNode.SelectedIndex := NODE_BLOB_FILTERS_IMG;
      TibcDatabaseNode(Parent.Data).FiltersID := lCurrNode.ItemID;
    end;
    NODE_GENERATORS:
    begin
      lCurrNode.ImageIndex := NODE_GENERATORS_IMG;
      lCurrNode.SelectedIndex := NODE_GENERATORS_IMG;
      TibcDatabaseNode(Parent.Data).GeneratorsID := lCurrNode.ItemID;
    end;
    NODE_ROLES:
    begin
      lCurrNode.ImageIndex := NODE_ROLES_IMG;
      lCurrNode.SelectedIndex := NODE_ROLES_IMG;
      TibcDatabaseNode(Parent.Data).RolesID := lCurrNode.ItemID;
    end;
    NODE_FUNCTIONS:
    begin
      lCurrNode.ImageIndex := NODE_FUNCTIONS_IMG;
      lCurrNode.SelectedIndex := NODE_FUNCTIONS_IMG;
      TibcDatabaseNode(Parent.Data).FunctionsID := lCurrNode.ItemID;
    end;
  end;
end;

procedure TfrmMain.lvActionsDblClick(Sender: TObject);
begin
  with Sender as TListView do
  begin
    if Assigned (Selected) and Assigned (Selected.Data) then
      TAction(Selected.Data).OnExecute(Sender);
  end;
end;

procedure TfrmMain.lvObjectsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 pt: TPoint;
begin
  if (Sender as TListView).Tag in [ACTIONS, OBJECTS] then
    if (Key = VK_RETURN) then
    begin
       if (ssAlt in Shift) and Assigned (lvObjects.PopupMenu) then
       begin
         pt := ClientToScreen(lvObjects.Selected.GetPosition);
         lvObjects.PopupMenu.Popup (pt.X, pt.Y);
       end
       else
         lvObjectsDblClick (Sender);
    end;
end;

procedure TfrmMain.ConsoleExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.DatabaseShutdownExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    frmuDBShutDown.DoDBShutdown(FCurrSelServer,FCurrSelDatabase);
end;

procedure TfrmMain.DatabaseRegisterExecute(Sender: TObject);
var
  lDBAlias,lUserName,lPassword,lRole: string;
  lExistingAlias : String;
  lDatabaseFiles : TStringList;
  lSaveAlias, lCaseSensitive  : boolean;

begin
  if not Assigned(FCurrSelServer) then
    Exit;

  lDatabaseFiles := TStringList.Create;
  try
    tvMain.Items.BeginUpdate;
    if frmuDBRegister.RegisterDB(lDBAlias,lUserName,lPassword,lRole,
                                 lDatabaseFiles,FCurrSelServer,
                                 lSaveAlias, lCaseSensitive) then
    begin
      lExistingAlias := '';
      if not FRegistry.KeyExists(Format('%s%s\Databases\%s',[gRegServersKey,FCurrSelServer.Nodename,lDBAlias])) then
      begin
        if not IsDBRegistered(lDatabaseFiles.Strings[0], lExistingAlias) then
        begin
          if FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.Nodename,lDBAlias]),true) then
          begin
            if FRegistry.OpenKey(Format('%s%s\Databases\%s',[gRegServersKey,FCurrSelServer.Nodename,lDBAlias]),true) then
            begin
              FRegistry.WriteString('DatabaseFiles',lDatabaseFiles.Text);
              RegisterDatabase(FCurrSelServer,lDBAlias,lUserName,lPassword,lRole,
                lDatabaseFiles,lSaveAlias, lCaseSensitive, FNILLDATABASE);
            end;
            FRegistry.CloseKey;
          end;

          if (lUserName <> '') and (lPassword <> '') then
          begin
            if not DoDBConnect(FCurrSelServer,FCurrSelDatabase,true) then
            begin
              FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.Nodename]),true);
              FRegistry.DeleteKey(FCurrSelDatabase.NodeName);
              FRegistry.CloseKey;
              DeleteNode(tvMain.Items.GetNode(FCurrSelDatabase.NodeID),false);
              FCurrSelDatabase := nil;
              tvMainChange(nil,nil);
              GetDatabases(FCurrSelServer);
            end;
          end;
        end
        else { database is registered }
          DisplayMsg(WAR_DUPLICATE_DB_ALIAS,'');
      end;
    end;
  finally
    lDatabaseFiles.Free;
    tvMain.Items.EndUpdate;
  end;
end;

procedure TfrmMain.DatabaseUnregisterExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure that you want to un-register the selected database?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    begin
      if FCurrSelDatabase.Database.Connected then
        if not DoDBDisConnect(FCurrSelDatabase) then
        begin
          DisplayMsg (ERR_DB_DISCONNECT, 'Database registration not removed.');
          exit;
        end;
        FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.Nodename]),true);
        FRegistry.DeleteKey(FCurrSelDatabase.NodeName);
        FRegistry.CloseKey;
        DeleteNode(tvMain.Items.GetNode(FCurrSelDatabase.NodeID),false);
        FCurrSelDatabase := nil;
        tvMainChange(nil,nil);
        GetDatabases(FCurrSelServer);
    end;
  end;
end;

procedure TfrmMain.DatabaseConnectExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase))
    and (not FCurrSelDatabase.Database.Connected) then
    DoDBConnect(FCurrSelServer,FCurrSelDatabase,true);
end;

procedure TfrmMain.DatabaseConnectAsExecute(Sender: TObject);
begin
  if Assigned(FCurrSelServer) and Assigned(FCurrSelDatabase) then
  begin
    if not FCurrSelDatabase.Database.Connected then
      DoDBConnect(FCurrSelServer,FCurrSelDatabase,false);
  end;
end;

procedure TfrmMain.DatabaseDisconnectExecute(Sender: TObject);
var
  lCurrNode: TTreeNode;
begin
  if not Assigned(FCurrSelDatabase) then
    exit;
  if MessageDlg('Are you sure that you want to close the connection to the selected database?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if DoDBDisconnect(FCurrSelDatabase) then
    begin
      lCurrNode := tvMain.Items.GetNode(FCurrSelDatabase.NodeID);
      lCurrNode.SelectedIndex := 2;
      lCurrNode.ImageIndex := 2;
      DeleteNode(lCurrNode, true);
      tvMainChange(nil,nil);
    end;
  end;
end;

procedure TfrmMain.ToolsStatisticsExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    frmuDBStatistics.DoDBStatistics(FCurrSelServer,FCurrSelDatabase);
end;

procedure TfrmMain.ToolsSweepExecute(Sender: TObject);
var
  lValidation: TIBValidationService;  // validation object
  lOptions: TValidateOptions;         // validation options
begin
  // show message and verify action
  if MessageDlg('Sweeping a large database may take a while and can impact server ' +
   'performance during that time. Do you wish to perform a sweep?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // if user presses the OK button and they wish to proceed
    lValidation := Nil;                // initialize
    try
      lValidation := TIBValidationService.Create(Self);
      try                              // attach to currently selected server
        lValidation.LoginPrompt := false;
        lValidation.ServerName := FCurrSelServer.Server.ServerName;
        lValidation.Protocol := FCurrSelServer.Server.Protocol;
        lValidation.Params.Assign(FCurrSelServer.Server.Params);
        lValidation.Attach;
      except                           // if an exception occurs
        on E:EIBError do               // trap it and show error message
        begin
          DisplayMsg(ERR_SERVER_LOGIN, E.Message);
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            SetErrorState;
          Exit;
        end;
      end;

      if lValidation.Active then       // if successfully attached to server
      begin
        Screen.Cursor := crHourGlass;  // change cursor to hourglass

        // define database
        lValidation.DatabaseName := FCurrSelDatabase.DatabaseFiles.Strings[0];

        // clear option lists
        lValidation.Options := [];
        lOptions := [];

        // specify SweepDB validation option
        Include(lOptions, SweepDB);

        lValidation.Options := lOptions;

        // start service
        try
          lValidation.ServiceStart;
          while (lValidation.IsServiceRunning) and (not gApplShutdown) do
          begin
            Application.ProcessMessages;
            Screen.Cursor := crHourGlass;
          end;

          if lValidation.Active then
            lValidation.Detach;
        except
          on E: EIBError do
          begin
            DisplayMsg(E.IBErrorCode, E.Message);
            if (E.IBErrorCode = isc_lost_db_connection) or
               (E.IBErrorCode = isc_unavailable) or
               (E.IBErrorCode = isc_network_error) then
              SetErrorState;
        end;
      end;
      end;
    finally
      if lValidation.Active then
        lValidation.Detach;
      lValidation.Free;
      Screen.Cursor := crDefault;
      DisplayMsg(INF_DATABASE_SWEEP, '');
    end;
  end;
end;

procedure TfrmMain.ToolsSQLExecute(Sender: TObject);
var
  lCnt: integer;
  str: string;
begin
  with FWisql do
  begin
    if CheckTransactionStatus (true) then
    begin

      if Assigned(FCurrSelDatabase) and
         Assigned(FCurrSelDatabase.Database) and
         Assigned(FCurrSelDatabase.Database.Handle) and
         (FCurrSelDatabase.Database.Connected) then
      begin
        Database := FCurrSelDatabase.Database;
        OnDropDatabase := EventDatabaseDrop;
        OnCreateObject := EventObjectRefresh;
        OnDropObject := EventObjectRefresh;
      end
      else
        Database := nil;
      
      ServerList.Clear;
      for lCnt := 1 to TibcServerNode(tvMain.Items[0].Data).ObjectList.Count - 1 do
      begin
        str := TibcServerNode(tvMain.Items[0].Data).ObjectList.Strings[lCnt];
        ServerList.Append(GetNextField(Str, DEL));
      end;
      if Assigned(FCurrSelServer) and (FCurrSelServer.Server.Active) then
        ServerIndex := ServerList.IndexOf(FCurrSelServer.NodeName)
      else
        ServerIndex := -1;

      if Assigned (FCurrSelServer) and (FCurrSelServer.server.Active) then
      begin
      OnConnectDatabase := EventDatabaseConnect;
      OnCreateDatabase := EventDatabaseCreate;
      end;
      ShowDialog;
    end;
  end;
end;

procedure TfrmMain.ServerViewLogExecute(Sender: TObject);
var
  ibcLogSvc: TIBLogService;

begin
  ibcLogSvc := TIBLogService.create(self);
  Screen.Cursor := crHourGlass;
  try
    ibcLogSvc.ServerName := FCurrSelServer.Servername;
    ibcLogSvc.Protocol := FCurrSelServer.Server.Protocol;
    ibcLogSvc.Params := FCurrSelServer.Server.Params;
    ibcLogSvc.LoginPrompt := false;
    try
      ibcLogSvc.Attach;
      ibcLogSvc.ServiceStart;
      FCurrSelServer.OpenTextViewer (ibcLogSvc, 'Server Log', false);
      ibcLogSvc.Detach;
      Screen.Cursor := crDefault;
    except
      on E: EIBError do
      begin
        DisplayMsg(E.IBErrorCode, E.Message);
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          SetErrorState;
    end;
    end;
  finally
    ibcLogSvc.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.ServerAddCertificateExecute(Sender: TObject);
var
  lCertificateID, lCertificateKey: string;
  ibcLicenser : TIBLicensingService;
begin
  ibcLicenser := TIBLicensingService.Create(self);
  try
    if Assigned(FCurrSelServer) and Assigned(FCurrSelTreeNode) then
    begin
      ibcLicenser.ServerName := FCurrSelServer.Servername;
      ibcLicenser.Protocol := FCurrSelServer.Server.Protocol;
      ibcLicenser.Params := FCurrSelServer.Server.Params;
      ibcLicenser.LoginPrompt := false;
      try
        ibcLicenser.Attach;
        if frmuAddCertificate.AddCertificate(lCertificateID, lCertificateKey) then
        begin
          Application.ProcessMessages;
          Screen.Cursor := crHourGlass;
          if not ibcLicenser.Active then
            ibcLicenser.Attach;
          ibcLicenser.ID := lCertificateID;
          ibcLicenser.Key := lCertificateKey;
          ibcLicenser.AddLicense;
        end;
      except
        on E:EIBInterBaseError do
        begin
          DisplayMsg(ERR_INVALID_CERTIFICATE,E.Message);
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            SetErrorState;
      end;
    end;
    end;
  finally
    Screen.Cursor := crDefault;
    ibcLicenser.Free;
    tvMainChange(nil,nil);
  end;
end;

procedure TfrmMain.ServerRemoveCertificateExecute(Sender: TObject);
var
  ibcLicenser : TIBLicensingService;
begin
  ibcLicenser := TIBLicensingService.Create(self);

  if MessageDlg(Format('Are you sure you want to remove certificate %s?',
    [FCurrSelCertificateID]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelTreeNode))
        and (FCurrSelTreeNode.NodeType = NODE_CERTIFICATES) then
      begin
        if lvObjects.SelCount > 0 then
        try
          Screen.Cursor := crHourGlass;
          Application.ProcessMessages;
          ibcLicenser.ServerName := FCurrSelServer.ServerName;
          ibcLicenser.Protocol := FCurrSelServer.Server.Protocol;
          ibcLicenser.Params := FCurrSelServer.Server.Params;
          ibcLicenser.LoginPrompt := false;

          ibcLicenser.ID := FCurrSelCertificateID;
          ibcLicenser.Key := FCurrSelCertificateKey;
          ibcLicenser.Attach;
          ibcLicenser.RemoveLicense;
        except
          on E:EIBError do
          begin
            DisplayMsg(ERR_INVALID_CERTIFICATE,E.Message + #13#10 +
              'Unable to remove certificate.');
            if (E.IBErrorCode = isc_lost_db_connection) or
               (E.IBErrorCode = isc_unavailable) or
               (E.IBErrorCode = isc_network_error) then
              SetErrorState;
        end;
      end;
      end;
    finally
      Screen.Cursor := crDefault;
      ibcLicenser.Free;
      tvMainChange(nil,nil);
    end;
  end;
end;

procedure TfrmMain.DatabaseRestartExecute(Sender: TObject);
var
  lConfig: TIBConfigService;
begin
  lConfig:=Nil;                        // initilialize variables
  try                                  // create ConfigService object
    lConfig:=TIBConfigService.Create(Nil);
    Screen.Cursor := crHourGlass;
    try                                // specify server information
      lConfig.LoginPrompt:=False;      // and Attempt to login
      lConfig.ServerName:=FCurrSelServer.ServerName;
      lConfig.Protocol:=FCurrSelServer.Server.Protocol;
      lConfig.DatabaseName:=FCurrSelDatabase.DatabaseFiles.Strings[0];
      lConfig.Params.Assign(FCurrSelServer.Server.Params);
      lConfig.Attach;
    except                             // if an error occurs
      on E:EIBError do                 // trap it and show
      begin                            // error message
        DisplayMsg(ERR_SERVER_LOGIN, E.Message);
        if (E.IBErrorCode = isc_lost_db_connection) or
           (E.IBErrorCode = isc_unavailable) or
           (E.IBErrorCode = isc_network_error) then
          SetErrorState;
        Exit;
      end;
    end;

    if lConfig.Active then             // if ConfigService is active
    begin                              // set the database name
      lConfig.DatabaseName:=FCurrSelDatabase.DatabaseFiles.Strings[0];

      // bring database back online
      lConfig.BringDatabaseOnline;

      // wait while processing
      while (lConfig.IsServiceRunning) and (not gApplShutdown) do
      begin
        Application.ProcessMessages;
        Screen.Cursor := crHourGlass;
      end;

      // if ConfigService is no longer active then detach
      if lConfig.Active then
        lConfig.Detach;
    end;

    DisplayMsg(INF_DATABASE_RESTARTED, '');

  finally
    Screen.Cursor := crDefault;
    // deallocate memory
    lConfig.Free;
  end;
end;

procedure TfrmMain.ToolsTransRecoverExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    frmuDBTransactions.DoDBTransactions(FCurrSelServer,FCurrSelDatabase);
end;

procedure TfrmMain.DatabaseCreateExecute(Sender: TObject);
var
  DBAlias: string;
  DatabaseFiles: TStringList;
begin
  if Assigned(FCurrSelServer) then
  begin
    DatabaseFiles := TStringList.Create;
    try
      if frmuDBCreate.CreateDB(DBAlias,DatabaseFiles,FCurrSelServer) = SUCCESS then
      begin
        RegisterDatabase(FCurrSelServer,DBAlias,'','','',DatabaseFiles,
          True, false, FNILLDATABASE);
        if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase))
          and (not FCurrSelDatabase.Database.Connected) then
          DoDBConnect(FCurrSelServer,FCurrSelDatabase,true);
      end;
    finally
      DatabaseFiles.Free;
    end;
  end;
end;

procedure TfrmMain.DatabaseDropExecute(Sender: TObject);
var
  lOriginalState : Boolean;
begin
  if MessageDlg('Are you sure that you want to drop the selected database?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    lOriginalState := FCurrSelDatabase.Database.Connected;

    // disconnect from database
    FCurrSelDatabase.Database.Connected := False;

    // check if the database is open
    if not FCurrSelDatabase.Database.Connected then
    begin
      // if the databsae is not open then connect to it using the username
      // and password used to connected to the server
      FCurrSelDatabase.Database.LoginPrompt:=False;
      FCurrSelDatabase.Database.Params.Add(Format('isc_dpb_user_name=%s',[FCurrSelServer.UserName]));
      FCurrSelDatabase.Database.Params.Add(Format('isc_dpb_password=%s',[FCurrSelServer.Password]));
      FCurrSelDatabase.Database.Connected:=True;
    end;

    try
    // drop the databsae
    FCurrSelDatabase.Database.DropDatabase;

    // remove from treeview and un-register from the windows registry
    if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    begin
      FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.Nodename]),true);
      FRegistry.DeleteKey(FCurrSelDatabase.NodeName);
      FRegistry.CloseKey;
      DeleteNode(tvMain.Items.GetNode(FCurrSelDatabase.NodeID),false);
      tvMainChange(nil,nil);
      GetDatabases(FCurrSelServer);
    end;
    except
      on E : EIBError do
      begin
        DisplayMsg(ERR_DROP_DATABASE, E.Message);
        FCurrSelDatabase.Database.Connected := lOriginalState;
      end;
    end;
  end;
end;

procedure TfrmMain.ToolsValidationExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    frmuDBValidation.DoDBValidation(FCurrSelServer,FCurrSelDatabase);
end;

procedure TfrmMain.DatabasePropertiesExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    frmuDBProperties.EditDBProperties(FCurrSelServer,FCurrSelDatabase);

  GetDatabases(FCurrSelServer);
end;

procedure TfrmMain.DatabaseRestoreExecute(Sender: TObject);
var
  bckupAlias: TibcBackupAliasNode;

begin
  if Assigned(FCurrSelServer) and Assigned(FCurrSelTreeNode) then
  begin
    if frmuDBRestore.DoDBRestore(FCurrSelServer, FCurrSelTreeNode) = SUCCESS then
    begin
      if FCurrSelTreeNode is TibcBackupAliasNode then
      begin
      bckupAlias := TibcBackupAliasNode(FCurrSelTreeNode);
      if FRegistry.OpenKey(Format('%s%s\Backup Files\%s',[gRegServersKey, FCurrSelServer.NodeName,
        FCurrSelTreeNode.Nodename]), false) then
      begin
        FRegistry.WriteDateTime ('Accessed', Now);
        FRegistry.WriteString('SourceDBAlias', bckupAlias.SourceDBAlias);
        FRegistry.WriteString('SourceDBServer', bckupAlias.SourceDBServer);
      end;
    end;
  end;
end;
end;

procedure TfrmMain.HelpAboutExecute(Sender: TObject);
begin
  frmuAbout.ShowAboutDialog('IBConsole', APP_VERSION);
end;

procedure TfrmMain.BackupRestoreModifyAliasExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelTreeNode)) and (FCurrSelTreeNode is TibcBackupAliasNode) then
    frmuBackupAliasProperties.EditBackupAliasProperties(FCurrSelServer,TibcBackupAliasNode(FCurrSelTreeNode));

  GetBackupFiles(FCurrSelServer);
end;

procedure TfrmMain.ServerDiagConnectionExecute(Sender: TObject);
begin
  frmuCommDiag.DoDiagnostics(FCurrSelServer);
end;

procedure TfrmMain.ServerLoginExecute(Sender: TObject);
begin
  DoServerLogin(false);
end;

procedure TfrmMain.ServerLogoutExecute(Sender: TObject);
var
  lCurrNode     : TTreeNode;
  lDatabaseNode : TibcDatabaseNode;
  i             : integer;
begin
  if FErrorState or (MessageDlg('Are you sure that you want to close the connection to the selected server?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    if Assigned (FCurrSelDatabase) then
    begin
      DoDBDisConnect(FCurrSelDatabase);
      FCurrSelDatabase := nil;
    end;

    if Assigned(FCurrSelServer) then
    begin
      try
        if Assigned(FCurrSelServer.OutputWindow) and
          (FCurrSelServer.OutputWindow.WindowState in [wsNormal, wsMinimized, wsMaximized])
        then
          FCurrSelServer.OutputWindow.Close;
          
        if FCurrSelServer.Version > 5 then
          FCurrSelServer.Server.Detach;

        FCurrSelServer.Version := 6;
        if not FCurrSelServer.Server.Active then
        begin
          lCurrNode := tvMain.Items.GetNode(FCurrSelServer.DatabasesID);
          for i := lCurrNode.Count - 1 downto 0  do
          begin
            lDatabaseNode := TibcDatabaseNode(lCurrNode.Item[i].Data);
            DoDBDisconnect(lDatabaseNode);
            DeleteNode(lCurrNode.Item[i], true);
            lCurrNode.Item[i].SelectedIndex := 2;
            lCurrNode.Item[i].ImageIndex := 2;
          end;
          lCurrNode := tvMain.Items.GetNode(FCurrSelServer.NodeID);
          DeleteNode(lCurrNode, true);
          lCurrNode.SelectedIndex := 1;
          lCurrNode.ImageIndex := 1;
          lCurrNode.Collapse(true);
        end;
        tvMain.Refresh;
        tvMainChange(nil,nil);
      except
        DisplayMsg(ERR_SERVER_SERVICE, 'This server may be shutdown or disconnected.');

        if not FCurrSelServer.Server.Active then
        begin
          tvMain.Items.BeginUpdate;
          lCurrNode := tvMain.Items.GetNode(FCurrSelServer.DatabasesID);
          if Assigned (lCurrNode) then
          begin
          for i := lCurrNode.Count - 1 downto 0  do
          begin
            lDatabaseNode := TibcDatabaseNode(lCurrNode.Item[i].Data);
            DoDBDisconnect(lDatabaseNode);
            DeleteNode(lCurrNode.Item[i], true);
            lCurrNode.Item[i].SelectedIndex := 2;
            lCurrNode.Item[i].ImageIndex := 2;
          end;
          end;
          lCurrNode := tvMain.Items.GetNode(FCurrSelServer.NodeID);
          DeleteNode(lCurrNode, true);
          lCurrNode.SelectedIndex := 1;
          lCurrNode.ImageIndex := 1;
          lCurrNode.Collapse(true);
        end;
        tvMain.Refresh;
        tvMainChange(nil,nil);
        tvMain.Items.EndUpdate;        
      end;  // of try except
    end;  // of if assigned
  end;  // of confirmation
end;

procedure TfrmMain.ServerPropertiesExecute(Sender: TObject);
begin
  if Assigned(FCurrSelServer) then
    frmuServerProperties.EditServerProperties(FCurrSelServer);
end;

procedure TfrmMain.ServerRegisterExecute(Sender: TObject);
var
  lServerName,lServerAlias,lUserName,lPassword, lDescription: string;
  lSaveAlias: boolean;
  lProtocol: TProtocol;
begin
  try
    tvMain.Items.BeginUpdate;
    lvObjects.Items.BeginUpdate;
    if frmuServerRegister.RegisterServer(lServerName,lServerAlias,lUserName,lPassword, lDescription,lProtocol,REGISTER_SERVER,lSaveAlias) = SUCCESS then
    begin
      if not FRegistry.KeyExists(Format('%s%s',[gRegServersKey,lServerName])) then
      begin
        if RegisterServer(lServerName,lServerAlias,lUserName,lPassword,lDescription,lProtocol,lSaveAlias, Now) then
        begin
          if (lUserName <> '') and (lPassword <> '') then
          begin
          { NOTE:  This code has been duplicated to save time }
            try
              DoServerLogin(true);
            except
              on E: Exception do
              begin
                FRegistry.DeleteKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.NodeName]));
                FRegistry.DeleteKey(Format('%s%s',[gRegServersKey, FCurrSelServer.NodeName]));
                FRegistry.CloseKey;
                DeleteNode(tvMain.Items.GetNode(FCurrSelServer.NodeID),false);
                FCurrSelServer := nil;
                tvMainChange(nil,nil);
                GetServers;
                tvMain.Selected := tvMain.TopItem;
                tvMain.Items.EndUpdate;
                lvObjects.Items.EndUpdate;
                DisplayMsg (ERR_SERVER_LOGIN, E.Message);
              end;
            end;
          end;
        end;
      end
      else
        DisplayMsg(WAR_SERVER_REGISTERED,'');
    end;
  finally
    tvMain.Items.EndUpdate;
    lvObjects.Items.EndUpdate;
  end;
end;

procedure TfrmMain.ServerUnregisterExecute(Sender: TObject);
begin
  if Assigned(FCurrSelServer) then
  begin
    if UnRegisterServer (FCurrSelServer.Nodename) then
    begin
      if Assigned(FCurrSelServer.OutputWindow) and
        (FCurrSelServer.OutputWindow.WindowState in [wsNormal, wsMinimized, wsMaximized])
      then
        FCurrSelServer.OutputWindow.Close;

      DeleteNode(tvMain.Items.GetNode(FCurrSelServer.NodeID),false);
      FCurrSelServer := nil;
      tvMainChange(nil,nil);
      GetServers();
      tvMain.Selected := tvMain.TopItem;
    end;
  end;
end;

procedure TfrmMain.ServerSecurityExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelTreeNode) and
    (FCurrSelTreeNode.NodeType = NODE_USERS)) then
  begin
    if lvObjects.SelCount > 0 then
      frmuUser.UserInfo(FCurrSelServer,lvObjects.Selected.Caption)
    else
      frmuUser.UserInfo(FCurrSelServer,'');
  end
  else
    frmuUser.UserInfo(FCurrSelServer,'');
end;

procedure TfrmMain.ViewSystemDataExecute(Sender: TObject);
begin
  FViewSystemData := not (Sender as TAction).Checked;
  gAppSettings[SYSTEM_DATA].Setting := FViewSystemData;
  if lvObjects.Tag = OBJECTS then
  begin
    lvObjects.Items.BeginUpdate;
    lvObjects.Items.Clear;
    GetDBObjects(FCurrSelDatabase,FCurrSelTreeNode, FCurrSelTreeNode.NodeType);
    FillObjectList (FCurrSelTreeNode);
    lvObjects.Items.EndUpdate;
  end;
end;

procedure TfrmMain.EditFontExecute(Sender: TObject);
begin
  if ActiveControl is TRichEditX then
    with (ActiveControl as TRichEditX) do
      ChangeFont;
end;

procedure TfrmMain.DatabaseBackupExecute(Sender: TObject);
var
  lSourceDBAlias,lBackupAlias: string;
  lBackupFiles: TStringList;
  lBackupAliasNode: TibcBackupAliasNode;  
begin
 lBackupFiles := TStringList.Create;
 try
   if Assigned(FCurrSelServer) then
    begin
      if Assigned(FCurrSelTreeNode) and (FcurrSelTreeNode.NodeType = NODE_BACKUP_ALIAS) then
      begin
        lBackupAliasNode := TibcBackupAliasNode(FCurrSelTreeNode);
        lSourceDBAlias := lBackupAliasNode.SourceDBAlias;
        lBackupAlias := FCurrSelTreeNode.NodeName;
        lBackupFiles.Text := lBackupAliaSNode.BackupFiles.Text;
      end;

      if Assigned (FCurrSelTreeNode) and (FCurrSelTreeNode.NodeType = NODE_DATABASE) then
        lSourceDBAlias := FCurrSelTreeNode.NodeName;
        
      if frmuDBBackup.DoDBBackup(lSourceDBAlias, lBackupAlias,
        lBackupFiles, FCurrSelServer,FCurrSelDatabase) = SUCCESS then
      begin
        if not FRegistry.KeyExists(Format('%s%s\Backup Files\%s',[gRegServersKey,FCurrSelServer.Nodename,lBackupAlias])) then
        begin
          RegisterBackupFile(FCurrSelServer,lSourceDBAlias,lBackupAlias, lBackupFiles);
        end
        else
        begin
          if FRegistry.OpenKey(Format('%s%s\Backup Files\%s',[gRegServersKey,FCurrSelServer.Nodename,lBackupAlias]),false) then
          begin
            FRegistry.WriteString('BackupFiles',lBackupFiles.Text);
            FRegistry.CloseKey;
          end;
        end;
      end;
    end;
  finally
    lBackupFiles.Free;
  end
end;

procedure TfrmMain.DatabaseMetadataExecute(Sender: TObject);
begin
  GetDDLScript;
end;

procedure TfrmMain.ViewListExecute(Sender: TObject);
begin
  lvObjects.ViewStyle := vsList;
end;

procedure TfrmMain.ViewListUpdate(Sender: TObject);
begin
  (Sender as TAction).Checked := (lvObjects.ViewStyle = vsList);
end;

procedure TfrmMain.ViewReportExecute(Sender: TObject);
begin
  lvObjects.ViewStyle := vsReport;
end;

procedure TfrmMain.ViewReportUpdate(Sender: TObject);
begin
  (Sender as TAction).Checked := (lvObjects.ViewStyle = vsReport);
end;

procedure TfrmMain.ViewIconExecute(Sender: TObject);
begin
  lvObjects.ViewStyle := vsIcon;
end;

procedure TfrmMain.ViewIconUpdate(Sender: TObject);
begin
  (Sender as TAction).Checked := (lvObjects.ViewStyle = vsIcon);
end;

procedure TfrmMain.ViewSmallIconExecute(Sender: TObject);
begin
  lvObjects.ViewStyle := vsSmallIcon;
end;

procedure TfrmMain.ViewSmallIconUpdate(Sender: TObject);
begin
  (Sender as TAction).Checked := (lvObjects.ViewStyle = vsSmallIcon);
end;

procedure TfrmMain.FillActionList(const ActionList: TActionList);
var
  lCnt: Integer;
  ListItem: TListItem;
  LColumn: TListColumn;
begin
  lvObjects.Tag := ACTIONS;

  if FLastActions <> ActionList then
  begin
    FLastActions := ActionList;
    lvObjects.Items.BeginUpdate;
    lvObjects.Items.Clear;

    lvObjects.Columns.BeginUpdate;
    lvObjects.Columns.Clear;

    lColumn := lvObjects.Columns.Add;
    lColumn.Caption := 'Action';

    lColumn := lvObjects.Columns.Add;
    lColumn.Caption := 'Description';

    lvObjects.Columns.EndUpdate;
{ TODO: Do not show icons since not all objects have them }

    lvObjects.SmallImages := nil;
    lvObjects.StateImages := nil;
    lvObjects.LargeImages := nil;
    with ActionList do
    begin
      for lCnt := 0 to ActionCount-1 do
      begin
        with Actions[lCnt] as TAction do
        begin
          if Tag <> 1 then
          begin
            if (Tag = SYSDBA_ONLY) and
               (UpperCase(FCurrSelServer.UserName) <> 'SYSDBA') then
              continue;
            ListItem := lvObjects.Items.Add;
            ListItem.Caption := StripMenuChars(Caption);
//            ListItem.ImageIndex := ImageIndex;
            ListItem.SubItems.Add (Hint);
            ListItem.Data := TAction(Actions[lCnt]);
          end;
        end;
      end;
    end;
    lvObjects.Items.EndUpdate;

    lvObjects.Columns.BeginUpdate;
    for lCnt := 0 to lvObjects.Columns.Count - 1 do
    begin
      lvObjects.Columns[lCnt].Width := ColumnTextWidth;
    end;
    lvObjects.Columns.EndUpdate;

  end;
end;

procedure TfrmMain.DatabaseConnectedActionsUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelDatabase) and
     Assigned (FCurrSelDatabase.Database) and  
     Assigned (FCurrSelDatabase.Database.Handle) then
    (Sender as TAction).Enabled := FCurrSelDatabase.Database.Connected
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.ServerActionsUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelServer) and Assigned (FCurrSelServer.Server) then
    if FCurrSelTreeNode.NodeType  = NODE_SERVERS then
      (Sender as TAction).Enabled := false
    else
      (Sender as TAction).Enabled := not FCurrSelServer.Server.Active
  else
    (Sender as TAction).Enabled := true;
end;

procedure TfrmMain.ServerConnectedUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelServer) and Assigned (FCurrSelServer.Server) then
    if FCurrSelTreeNode.NodeType  = NODE_SERVERS then
      (Sender as TAction).Enabled := false
    else
      (Sender as TAction).Enabled := FCurrSelServer.Server.Active
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.DatabaseRegisterUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelDatabase) and
     Assigned (FCurrSelDatabase.Database) and
     Assigned (FCurrSelDatabase.Database.Handle) then
    (Sender as TAction).Enabled := not FCurrSelDatabase.Database.Connected
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.EventDatabaseDrop;
begin
  // remove from treeview and un-register from the windows registry
  try
    if (Assigned(FCurrSelServer)) and (Assigned(FCurrSelDatabase)) then
    begin
      FRegistry.OpenKey(Format('%s%s\Databases',[gRegServersKey,FCurrSelServer.Nodename]),true);
      FRegistry.DeleteKey(FCurrSelDatabase.NodeName);
      FRegistry.CloseKey;
      DeleteNode(tvMain.Items.GetNode(FCurrSelDatabase.NodeID),false);
      tvMainChange(nil,nil);
      GetDatabases(FCurrSelServer);
    end;
  except
    on E : EIBError do
    begin
      DisplayMsg(ERR_DROP_DATABASE, E.Message);
    end;
  end;
end;

procedure TfrmMain.EventDatabaseCreate(var Database: TIBDatabase);
var
  dbName: TStringList;
  alias,
  username,
  password,
  role:  String;
  lCnt: integer;
begin
  if Assigned(FCurrSelServer) and (FCurrSelServer.Server.Active) then
  begin
    dbName := TStringList.create;
    dbName.append(Database.DatabaseName);
    alias := ExtractFileName(Database.DatabaseName);

    { Check to make sure that we are not overwriting an alias }
    lCnt := 0;
    while AliasExists(Alias) do
    begin
      Inc(lCnt);
      Alias := Format('%s_%d',[Alias, lCnt]);
    end;

    username := Database.DBParamByDPB[isc_dpb_user_name];
    password := Database.DBParamByDPB[isc_dpb_password];
    role := Database.DBParamByDPB[isc_dpb_sql_role_name];

    if FCurrSelServer.Server.Protocol = Local then
      if ExtractFilePath(Database.DatabaseName) = '' then
         Database.DatabaseName := ExtractFilePath(Application.ExeName)+Database.Databasename;

    RegisterDatabase (FCurrSelServer, alias, username, password, role, dbName,
      true, false, Database);
    dbName.Free;
    GetDatabases(FCurrSelServer);
    FillObjectList(FCurrSelTreeNode);
    DoDBConnect(FCurrSelServer, FCurrSelDatabase, true);
    FWisql.OnCreateObject := EventObjectRefresh;
    FWisql.OnDropObject := EventObjectRefresh;
    FWisql.OnDropDatabase := EventDatabaseDrop;
  end;
end;

procedure TfrmMain.EventObjectRefresh(const Database: TIBDatabase;
  const ObjType: integer);
begin
  if ObjType = NODE_UNK then
    case FcurrSelTreeNode.NodeType of
      NODE_DOMAINS:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_DOMAIN);
      NODE_TABLES:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_TABLE);
      NODE_VIEWS:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_VIEW);
      NODE_PROCEDURES:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_PROCEDURE);
      NODE_FUNCTIONS:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_FUNCTION);
      NODE_GENERATORS:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_GENERATOR);
      NODE_EXCEPTIONS:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_EXCEPTION);
      NODE_BLOB_FILTERS:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_BLOB_FILTER);
      NODE_ROLES:
        GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, NODE_ROLE);
    end
  else
    GetDBObjects (FCurrSelDatabase, FCurrSelTreeNode, ObjType);
  FillObjectList (FCurrSelTreeNode);
  FRefetch := true;
  
  if Assigned (FCurrSelDatabase.ObjectViewer) then
    FCurrSelDatabase.ObjectViewer.Refetch;
end;

procedure TfrmMain.DatabaseActionsUpdate(Sender: TObject);
begin
  if Assigned (FCurrSelTreeNode) and (FCurrSelTreeNode.NodeType = NODE_DATABASE) then
  begin
    if Assigned (FCurrSelServer) and Assigned (FCurrSelServer.server) then
      (Sender as TAction).Enabled := FCurrSelServer.Server.Active
    else
      (Sender as TAction).Enabled := false;
    end
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.EventDatabaseConnect(const ServerName: String; const Database: TIBDatabase);
begin
{ TODO: implement }
{
    FWisql.OnCreateObject := EventObjectRefresh;
    FWisql.OnDropObject := EventObjectRefresh;
    FWisql.OnDropDatabase := EventDatabaseDrop;
}
end;
{
procedure TfrmMain.EventServerConnect(const ServerName: string);
var
  treeNode: TTreeNode;
  ibTreeNode: TibcTreeNode;
begin
  with tvMain do
  begin
    treeNode := Items.GetFirstNode;
    treeNode := treeNode.GetFirstChild;
    if Assigned(treeNode) then
      ibTreeNode := TibcTreeNode(treeNode.Data)
    else
      ibTreeNode := nil;
    while Assigned(treeNode) and (ibTreeNode is TibcServerNode) do
    begin
      if (AnsiCompareText (ibTreeNode.NodeName, ServerName) = 0) then
      begin
        FCurrSelServer := TibcServerNode(ibtreeNode);
        if not FCurrSelServer.Server.Active then
          DoServerLogin (false);
        exit;
      end;
      treeNode := treeNode.GetNextSibling;
      if Assigned(treeNode) then
        ibTreeNode := TibcTreeNode(treeNode.Data)
      else
        ibTreeNode := nil;
    end;
  end;
end;
}
procedure TfrmMain.ExtToolsConfigureExecute(Sender: TObject);
var
  dlgTools: TfrmTools;
begin
  dlgTools := TfrmTools.Create (self);
  dlgTools.ShowModal;
  dlgTools.Free;
end;

procedure TfrmMain.ExtToolDropDownExecute(Sender: TObject);
var
  MenuItem: TMenuItem;
  lCnt, x : integer;
begin

  { Clear out all external tool options }
  lCnt := ToolMenu.Count;
  for x := lCnt - 1 downto FToolMenuIdx do
  begin
     MenuItem := ToolMenu.Items[x];
     MenuItem.Free;
  end;

  if gExternalApps.Count > 0 then
  begin
    { Add a separator }
    ToolMenu.NewBottomLine;
    for lCnt := 0 to gExternalApps.Count - 1 do
    begin
      MenuItem := ToolMenu.Find (gExternalApps.Strings[lCnt]);
      if not Assigned (MenuItem) then
      begin
        MenuItem := TMenuItem.Create (self);
        MenuItem.OnClick := ExtToolLaunchExecute;
        MenuItem.Caption := gExternalApps.Strings[lCnt];
        MenuItem.Tag := lCnt;
        ToolMenu.Add (MenuItem);
      end;
    end;
  end;
end;

procedure TfrmMain.ExtToolLaunchExecute(Sender: TObject);
var
  Reg: TRegistry;
  lPos: integer;
  retval: boolean;
  path,
  workDir,
  cmdLine,
  params: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  buf: array[byte] of char;

begin
  with (Sender as TMenuItem) do
  begin
    lPos := Tag;
    Reg := TRegistry.Create;
    with Reg do
    begin
      OpenKey (gRegToolsKey, false);
      path := ReadString (Format('Path%d', [lPos]));
      workDir := ReadString (Format('WorkingDir%d', [lPos]));
      Params := ReadString (Format('Params%d', [lPos]));
      CloseKey;
      Free;
    end;
    cmdLine := Path+' '+Params;
    try
      FillChar (StartupInfo, sizeof(StartupInfo), 0);
      StartupInfo.cb := sizeof (StartupInfo);
      retval := CreateProcess (nil, PChar(CmdLine), nil, nil, False,
         NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);

      if not retval then
      begin
        FormatMessage (FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError,
                LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil);
        raise Exception.Create (Buf+#13#10+'Command: '+cmdLine);
      end;
    except
      on E: Exception do
      begin
        DisplayMsg (ERR_EXT_TOOL_ERROR, E.Message);
      end;
    end;
  end;
end;

procedure TfrmMain.BackupRestoreUpdate(Sender: TObject);
begin
  if Assigned (FCurrSelDatabase) and
     Assigned (FCurrSelDatabase.Database) and
     Assigned (FCurrSelDatabase.Database.Handle) then
    (Sender as TAction).Enabled := FcurrSelDatabase.Database.Connected
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.DatabaseCreateUpdate(Sender: TObject);
begin
  if Assigned (FCurrSelServer) and Assigned (FCurrSelServer.server) then
    (Sender as TAction).Enabled := FCurrSelServer.Server.Active
  else
    (Sender as TAction).Enabled := false;
end;

function TfrmMain.GetDBObjects(const SelDatabaseNode: TibcDatabaseNode;
  const SelTreeNode: TibcTreeNode; const ObjType: integer): integer;
var
  lObjectList: TStringList;
  retval: integer;
begin
  result := FAILURE;
  lObjectList := nil;
  lObjectList := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    case FCurrSelTreeNode.NodeType of
      NODE_DOMAINS: retval := dmMain.GetDomainList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_TABLES: retval := dmMain.GetTableList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_VIEWS: retval := dmMain.GetViewList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_PROCEDURES: retval := dmMain.GetProcedureList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_FUNCTIONS: retval := dmMain.GetFunctionList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_GENERATORS: retval := dmMain.GetGeneratorList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_EXCEPTIONS: retval := dmMain.GetExceptionList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_BLOB_FILTERS: retval := dmMain.GetBlobFilterList(lObjectList, SelDatabaseNode.Database, FViewSystemData);
      NODE_ROLES: retval := dmMain.GetRoleList(lObjectList, SelDatabaseNode.Database);
      else
        retval := FAILURE;
    end;
    if  retval = SUCCESS then
    begin
      SelTreeNode.ObjectList.Assign(lObjectList);
      result := SUCCESS;
    end
    else
      selTreeNode.ObjectList.Clear;
  finally
    lObjectList.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.EditFontUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (ActiveControl is TRichEditX);
end;


procedure TfrmMain.listViewEnter(Sender: TObject);
begin
  if (Sender is TListView) then
  begin
    with (Sender as TListView) do
    begin
      if not Assigned (Selected) then
        Selected := TopItem;
    end;
  end;
end;


procedure TfrmMain.frmMainDestroy(Sender: TObject);
begin
//  SetWindowLong(frmMain.Handle, GWL_WNDPROC, LongInt(OldWindowProc));
  inherited;
end;

procedure TfrmMain.BackupRestoreRemoveAliasExecute(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (FCurrSelTreeNode is TibcBackupAliasNode) then
  begin
    if MessageDlg(Format('Are you sure that you want to remove "%s" from the alias list?',
      [AnsiUppercase(FCurrSelTreeNode.NodeName)]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FRegistry.OpenKey(Format('%s%s\Backup Files',[gRegServersKey,FCurrSelServer.Nodename]),true);
      FRegistry.DeleteKey(FCurrSelTreeNode.NodeName);
      FRegistry.CloseKey;
      DeleteNode(tvMain.Items.GetNode(FCurrSelTreeNode.NodeID),false);
      tvMainChange(nil,nil);
    end;
  end;
end;

procedure TfrmMain.BackupRestoreAliasUpdate(Sender: TObject);
begin
  if (Assigned(FCurrSelServer)) and (FCurrSelTreeNode is TibcBackupAliasNode) then
    (Sender as TAction).Enabled := True
  else
    (Sender as TAction).Enabled := False;  
end;

procedure TfrmMain.DatabasePropertiesUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(FCurrSelDatabase);
end;

procedure TfrmMain.DatabaseValidateUpdate(Sender: TObject);
begin
  if Assigned (FCurrSelDatabase) and
     Assigned (FCurrSelDatabase.Database) and
     not Assigned (FCurrSelDatabase.Database.Handle) then
    (Sender as TAction).Enabled := not FCurrSeldatabase.Database.connected
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.DisplayWindow(Sender: TObject);
begin
  with (Sender as TMenuItem) do
    ShowWindow (Tag, sW_RESTORE);
end;

procedure TfrmMain.ObjectDescriptionExecute(Sender: TObject);
var
  lQry: TIBQuery;
  lTrans: TIBTransaction;
  dlgDescription: TfrmDescription;
  table, fld, desc, qry: String;
  cols, retval: integer;
begin
  cols := 999;
  case FCurrSelTreeNode.NodeType of
    NODE_DOMAINS:
    begin
      table := 'RDB$FIELDS';
      fld := 'RDB$FIELD_NAME';
      cols := 2-1;
    end;
    NODE_TABLES,
    NODE_VIEWS:
    begin
      table := 'RDB$RELATIONS';
      fld := 'RDB$RELATION_NAME';
      cols := 3-1;
    end;
    NODE_PROCEDURES:
    begin
      table := 'RDB$PROCEDURES';
      fld := 'RDB$PROCEDURE_NAME';
      cols := 3-1;
    end;
    NODE_FUNCTIONS:
    begin
      table := 'RDB$FUNCTIONS';
      fld := 'RDB$FUNCTION_NAME';
      cols := 4-1;
    end;
    NODE_EXCEPTIONS:
    begin
      table := 'RDB$EXCEPTIONS';
      fld := 'RDB$EXCEPTION_NAME';
      cols := 3-1;
    end;
    NODE_BLOB_FILTERS:
    begin
      table := 'RDB$FILTERS';
      fld := 'RDB$FUNCTION_NAME';
      cols := 6-1;
    end;
  end;

  dlgDescription := TFrmDescription.Create (self);
  if lvObjects.Selected.Subitems.Count < cols then
    dlgDescription.reDescription.Text := ''
  else
    dlgDescription.reDescription.Text := lvObjects.Selected.SubItems[cols - 1];
  retval := dlgDescription.ShowModal;
  desc := dlgDescription.reDescription.Text;
  dlgDescription.Free;

  if retval = mrOK then
  begin
    lQry := TIBQuery.Create (self);
    lTrans := TIBTransaction.Create (self);
    lTrans.DefaultDatabase := FCurrSelDatabase.Database;
    with lQry do
    begin
      Transaction := lTrans;
      Database := FcurrSelDatabase.Database;
      Transaction.StartTransaction;
      qry := Format('UPDATE %s SET RDB$DESCRIPTION = :description',[table]);
      qry := Format('%s WHERE %s = ''%s''', [qry, fld, lvObjects.Selected.Caption]);
      SQL.Add(qry);
      Params[0].AsString := Desc;
      ExecSQL;
      Transaction.Commit;
      Close;
      Free;
    end;
    lTrans.Free;
    EventObjectRefresh (FCurrSelDatabase.Database, FCurrSelTreeNode.NodeType);
  end;
end;

procedure TfrmMain.ObjectDescriptionUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelTreeNode) then
    if FCurrSelTreeNode.NodeType in [NODE_ROLES, NODE_GENERATORS] then
      (Sender as TAction).Enabled := false
    else
      (Sender as TAction).Enabled := true
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.ObjectExtractExecute(Sender: TObject);
var
  IBExtract: TIBExtract;
  MetadataScript: TStringList;

begin

  if Assigned(lvObjects.Selected) then
  begin
    IBExtract := TIBExtract.Create (self);
    MetadataScript := TStringList.Create;
    MetadataScript.Text := '';
    Screen.Cursor := crHourGlass;
    with IBExtract do
    begin
      Database := FCurrSelDatabase.Database;
      Items := MetadataScript;
      ObjectName := lvObjects.Selected.Caption;
      ShowSystem := FViewSystemData;
      case FCurrSelTreeNode.NodeType of
        NODE_DOMAINS:
          ObjectType := eoDomain;
        NODE_TABLES:
          ObjectType := eoTable;
        NODE_VIEWS:
          ObjectType := eoView;
        NODE_PROCEDURES:
          ObjectType := eoProcedure;
        NODE_FUNCTIONS:
          ObjectType := eoFunction;
        NODE_GENERATORS:
          ObjectType := eoGenerator;
        NODE_EXCEPTIONS:
          ObjectType := eoException;
        NODE_BLOB_FILTERS:
          ObjectType := eoBLOBFilter;
        NODE_ROLES:
          ObjectType := eoRole;
      end;
      ExtractObject;
      Screen.Cursor := crDefault;
      FCurrSelServer.ShowText(MetadataScript, Format('Metadata for %s',[ObjectName]));
      Free;
    end;
    MetadataScript.Free;
  end;
end;

procedure TfrmMain.ObjectDeleteUpdate(Sender: TObject);
begin
  { Do not allow System Metadata to be dropped!}
  if Assigned(lvObjects.Selected) then
  begin
    if Pos('RDB$', lvObjects.Selected.Caption) <> 0 then
      (Sender as TAction).Enabled := false
    else
      (Sender as TAction).Enabled := true;
  end;
end;

procedure TfrmMain.ObjectDeleteExecute(Sender: TObject);
var
  lQry: TIBSql;
  lTrans: TIBTransaction;
  Qry, Obj: String;
begin

  if Assigned (lvObjects.Selected) then
  begin
    Qry := 'DROP %s %s';
    case FCurrSelTreeNode.NodeType of
      NODE_DOMAINS: Obj := 'DOMAIN';
      NODE_TABLES: Obj := 'TABLE';
      NODE_VIEWS: Obj := 'VIEW';
      NODE_PROCEDURES: Obj := 'PROCEDURE';
      NODE_FUNCTIONS: Obj := 'EXTERNAL FUNCTION';
      NODE_EXCEPTIONS: Obj := 'EXCEPTION';
      NODE_BLOB_FILTERS: Obj := 'FILTER';
      NODE_ROLES: Obj := 'ROLE';
      NODE_GENERATORS:
      begin
        Qry := 'DELETE FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME = ''%s''';
        Obj := 'GENERATOR';
      end;
    end;

    lQry := TIBSql.Create (self);
    lTrans := TIBTransaction.Create (self);

    if MessageDlg (Format('Once %s is dropped it can no longer be accessed.'+
                          #13#10'Do you wish to continue?',[lvObjects.Selected.Caption]),
                          mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      try
        lTrans.DefaultDatabase := FCurrSelDatabase.Database;
        with lQry do
        begin
          Database := FCurrSelDatabase.Database;
          Transaction := lTrans;
          Transaction.StartTransaction;
          if Obj = 'GENERATOR' then
            Qry := Format(Qry, [lvObjects.Selected.Caption])
          else
            Qry := Format(Qry, [Obj, lvObjects.Selected.Caption]);
          Sql.Add (Qry);
          Prepare;
          ExecQuery;
          Close;
        end;
      finally
        lQry.Free;
        lTrans.Commit;
        lTrans.Free;
        EventObjectRefresh (FCurrSelDatabase.Database, FCurrSelTreeNode.NodeType);
      end;
    end;
  end;
end;

procedure TfrmMain.ViewSystemUpdate(Sender: TObject);
begin
  (Sender as TAction).Checked := gAppSettings[SYSTEM_DATA].Setting;
end;

function TfrmMain.ConnectAsDatabase(Sender: Tobject): boolean;
begin
  try
    result := true;
    DatabaseConnectAsExecute (Sender);
    FWisql.Database := FCurrSelDatabase.Database;
    FWisql.OnCreateObject := EventObjectRefresh;
    FWisql.OnDropObject := EventObjectRefresh;
    FWisql.OnDropDatabase := EventDatabaseDrop;
  except
    result := false;
  end;
end;

function TfrmMain.CreateDatabase(Sender: TObject): boolean;
begin
  try
    result := true;
    DatabaseCreateExecute (Sender);
    if Assigned (FCurrSelDatabase) then
    begin
      FWisql.Database := FCurrSelDatabase.Database;
      FWisql.OnCreateObject := EventObjectRefresh;
      FWisql.OnDropObject := EventObjectRefresh;
      FWisql.OnDropDatabase := EventDatabaseDrop;
    end
    else
      result := false;
  except
    result := false;
  end;
end;

procedure TfrmMain.ShowWindows;
var
  lCnt: integer;
  dlgWindows: TdlgWindowList;
begin
  dlgWindows := TdlgWindowList.Create(self);
  with dlgWindows do
  begin
    for lCnt := 0 to FWindowList.Count - 1 do
    lbWindows.Items.AddObject(FWindowList.Strings[lCnt],
      FWindowList.Objects[lCnt]);
    ShowModal;
    Free;
  end;
end;

procedure TfrmMain.UpdateWindowList(const Caption: String;
  const Window: TObject; const Remove: boolean = false);
var
  idx: integer;
begin
  if Remove then
  begin
    idx := FWindowList.IndexOf(Caption);
    if idx <> -1 then
      FWindowList.Delete (idx);
  end
  else
    FWindowList.AddObject (Caption, Window);
end;

procedure TfrmMain.Window2Click(Sender: TObject);
begin
  ShowWindows;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  UpdateWindowList(Caption, TObject(Self));
end;

procedure TfrmMain.lvObjectsContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

  if not Assigned (lvObjects.Selected) then
    Handled := true
  else
  begin
    case lvObjects.Tag of
      ACTIONS:
        Handled := true;
      OBJECTS, STATIC:
        if not Assigned(lvObjects.PopupMenu) then
          Handled := true;
      else
        Handled := true;
    end;
  end;
end;

procedure TfrmMain.tvMainCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  if Node.GetPrev = nil then
    AllowCollapse := false;
end;

procedure TfrmMain.ServerPropertiesUpdate(Sender: TObject);
begin
  if FCurrSelTreeNode.NodeType  = NODE_SERVERS then
    (Sender as TAction).Enabled := false
  else
    (Sender as TAction).Enabled := true;
end;

procedure TfrmMain.ServerRemoveCertificateUpdate(Sender: TObject);
begin
  if FCurrSelTreeNode.NodeType  = NODE_CERTIFICATES then
    if Assigned (FCurrSelServer) and (UpperCase(FCurrSelServer.UserName) = 'SYSDBA') then
    (Sender as TAction).Enabled := Assigned(lvObjects.Selected)
  else
      (Sender as TAction).Enabled := false
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.UserDeleteUpdate(Sender: TObject);
begin
  if Assigned(lvObjects.Selected) then
    (Sender as TAction).Enabled := not (lvObjects.Selected.Caption = 'SYSDBA')
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.UserAddExecute(Sender: TObject);
begin
  if Assigned(FCurrSelServer) then
  begin
    frmuUser.UserInfo(FCurrSelServer,'', true);
    tvMainChange(nil, nil);    
  end;
end;

procedure TfrmMain.UserModifyExecute(Sender: TObject);
begin
  if Assigned(FCurrSelServer) then
  begin
    frmuUser.UserInfo(FCurrSelServer,lvObjects.Selected.Caption);
    tvMainChange(nil, nil);
  end;
end;

procedure TfrmMain.UserModifyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(lvObjects.Selected);
end;

procedure TfrmMain.UserDeleteExecute(Sender: TObject);
var
  SecurityService: TIBSecurityService;
begin
  if Assigned (lvObjects.Selected) then
  begin
    if MessageDlg(Format('Are you sure that you want to delete user: %s?',
       [lvObjects.Selected.Caption]),mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      try
        SecurityService := TIBSecurityService.Create(self);
        with SecurityService do
        begin
          Screen.Cursor := crHourGlass;
          LoginPrompt := false;
          ServerName := FCurrSelServer.Server.ServerName;
          Protocol := FCurrSelServer.Server.Protocol;
          Params.Assign(FCurrSelServer.Server.Params);
          Attach;
          UserName := lvObjects.Selected.Caption;
          DeleteUser;
          while (IsServiceRunning) do
            Application.ProcessMessages;
          Detach;
          Free;
        end;
      except
        on E: EIBError do
        begin
            DisplayMsg(E.IBErrorCode, E.Message);
          if (E.IBErrorCode = isc_lost_db_connection) or
             (E.IBErrorCode = isc_unavailable) or
             (E.IBErrorCode = isc_network_error) then
            SetErrorState;
          exit;
      end;
    end;
    end;
    tvMainChange(nil, nil);
  end;
end;

procedure TfrmMain.ServerUsersExecute(Sender: TObject);
begin
  if Assigned(FCurrSelServer) and Assigned(FCurrSelDatabase) then
    frmuDBConnections.ViewDBConnections (FCurrSelServer, FCurrSelDatabase.Database);
end;

procedure TfrmMain.ObjectModifyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (FCurrSelTreeNode.NodeType in [NODE_DOMAINS,
        NODE_TABLES, NODE_PROCEDURES, NODE_EXCEPTIONS]);
end;

procedure TfrmMain.SetErrorState;
begin
  FErrorState := true;
  ServerLogoutExecute(nil);
end;

procedure TfrmMain.ServerAddCertificateUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelServer) and Assigned (FCurrSelServer.Server) then
    if UpperCase(FCurrSelServer.UserName) <> 'SYSDBA' then
      (Sender as TAction).Enabled := false
    else
      if FCurrSelTreeNode.NodeType  = NODE_SERVERS then
        (Sender as TAction).Enabled := false
      else
        (Sender as TAction).Enabled := FCurrSelServer.Server.Active
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.DatabaseShutdownUpdate(Sender: TObject);
begin
  if Assigned(FCurrSelDatabase) and
     Assigned (FCurrSelDatabase.Database) and  
     Assigned (FCurrSelDatabase.Database.Handle) then
    if UpperCase(FCurrSelServer.UserName) = 'SYSDBA' then
      (Sender as TAction).Enabled := FCurrSelDatabase.Database.Connected
    else
      (Sender as TAction).Enabled := false
  else
    (Sender as TAction).Enabled := false;
end;

procedure TfrmMain.ObjectRefreshExecute(Sender: TObject);
begin
  if Assigned (FCurrSelTreeNode) then
    FCurrSeltreeNode.ObjectList.Clear;
  tvMainChange(nil, nil);
end;

end.
