{ --------------------------------------------------------------------------- }
{ AnyDAC monitor main form                                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fMainFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, Menus, ActnList, StdActns, ComCtrls, ImgList, ToolWin,
    Buttons, DBCtrls, Clipbrd, AppEvnts,
{$IFDEF AnyDAC_D6}
    Variants,
{$ENDIF}  
  IdSocketHandle, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
{$IFDEF AnyDAC_INDY10}
    IdException,
{$ENDIF}
  daADStanIntf, daADStanConst,
  daADGUIxFormsControls,
  daADMoniIndyBase, daADMoniIndyServer;

type
  TADMoniBufferMode = (tmLimitItems, tmLimitItemsAndPage, tmLimitMemory,
    tmLimitMemoryAndPage);

  TADMoniOptions = class(TObject)
  private
    FClntAutoSwitch: Boolean;
    FAdaptAutoSwitch: Boolean;
    FCollectingPaused: Boolean;
    FDisplayingPaused: Boolean;
    FBufferCapacity: Integer;
    FBufferPageFile: String;
    FEventKinds: TADMoniEventKinds;
    FBufferMode: TADMoniBufferMode;
    FStayOnTop: Boolean;
    FListeningPort: Integer;
    FFormatWithID: Boolean;
    FFormatWithTime: Boolean;
    FTabWidth: Integer;
  public
    constructor Create;
    procedure SaveToRegistry;
    procedure LoadFromRegistry;
    property ClntAutoSwitch: Boolean read FClntAutoSwitch write FClntAutoSwitch;
    property AdaptAutoSwitch: Boolean read FAdaptAutoSwitch write FAdaptAutoSwitch;
    property CollectingPaused: Boolean read FCollectingPaused write FCollectingPaused;
    property DisplayingPaused: Boolean read FDisplayingPaused write FDisplayingPaused;
    property EventKinds: TADMoniEventKinds read FEventKinds write FEventKinds;
    property BufferMode: TADMoniBufferMode read FBufferMode write FBufferMode;
    property BufferCapacity: Integer read FBufferCapacity write FBufferCapacity;
    property BufferPageFile: String read FBufferPageFile write FBufferPageFile;
    property StayOnTop: Boolean read FStayOnTop write FStayOnTop;
    property ListeningPort: Integer read FListeningPort write FListeningPort;
    property FormatWithID: Boolean read FFormatWithID write FFormatWithID;
    property FormatWithTime: Boolean read FFormatWithTime write FFormatWithTime;
    property TabWidth: Integer read FTabWidth write FTabWidth;
  end;

  TADMoniAdapterInfo = class(TObject)
  private
    FPath: String;
    FHandle: LongWord;
    FStat: Variant;
    FOptions: TADMoniOptions;
    function WalkThroughTree(ATree: TTreeView; const APath: String;
      var AIndex: Integer; AOwner: TTreeNode; var ACurrent: TTreeNode;
      var AName: String): Boolean;
  public
    constructor Create(AOptions: TADMoniOptions; AMessage: TADMoniIndyServerQueueItem);
    procedure InsertIntoTree(ATree: TTreeView);
    procedure RemoveFromTree(ATree: TTreeView);
    procedure UpdateState(AMessage: TADMoniIndyServerQueueItem);
    procedure ShowStat(AStat: TListView; ASQL: TMemo; AParams: TListView);
    property Path: String read FPath;
    property Handle: LongWord read FHandle;
    property Stat: Variant read FStat;
  end;

  TADMoniBuffer = class(TObject)
  private
    FItems: TStringList;
    FPtr: Integer;
    FCapacity: Integer;
    FAllocatedSize: Integer;
    FMode: TADMoniBufferMode;
    FPagingFile: String;
    FTotalItems: Integer;
    FBaseTime: TDateTime;
    FChanged: Boolean;
    FLock: TRTLCriticalSection;
    FTabWidth: Integer;
    function GetCount: Integer;
    function GetCaptions(AIndex: Integer): String;
    procedure PageOut;
    function GetIDs(AIndex: Integer): LongWord;
    function GetTimes(AIndex: Integer): TDateTime;
    function GetPhysicalIndex(AIndex: Integer): Integer;
    function GetTexts(AIndex: Integer): String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const AStr: String; ATime: Int64);
    procedure Clear;
    procedure SaveToFile(const AFileName: String);
    function CheckChanged: Boolean;
    property Captions[AIndex: Integer]: String read GetCaptions; default;
    property IDs[AIndex: Integer]: LongWord read GetIDs;
    property Times[AIndex: Integer]: TDateTime read GetTimes;
    property Texts[AIndex: Integer]: String read GetTexts;
    property Count: Integer read GetCount;
    property TotalItems: Integer read FTotalItems;
    property Capacity: Integer read FCapacity write FCapacity;
    property PagingFile: String read FPagingFile write FPagingFile;
    property Mode: TADMoniBufferMode read FMode write FMode;
    property TabWidth: Integer read FTabWidth write FTabWidth;
  end;

  TADMoniClientInfo = class(TObject)
  private
    FCaption: String;
    FHost: String;
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FMenuItem: TMenuItem;
    FAdapters: TList;
    FLevel: Integer;
    FBuffer: TADMoniBuffer;
    FOptions: TADMoniOptions;
    FStartupTimeDelta: Int64;
    FLastSender: String;
    function BuildClientName(AMessage: TADMoniIndyServerQueueItem;
      AClientMenu: TMenuItem; AMonSrv: TADMoniIndyServer): String;
    function GetAdapterCount: Integer;
    function GetAdapters(AIndex: Integer): TADMoniAdapterInfo;
    procedure Notify(var ALevel: Integer; AKind: TADMoniEventKind;
      AStep: TADMoniEventStep; ATime: Int64; const ASender, AMsg: String;
      const AArgs: Variant);
  public
    constructor Create(AMessage: TADMoniIndyServerQueueItem;
      AClientMenu: TMenuItem; AMonSrv: TADMoniIndyServer;
      AOptions: TADMoniOptions);
    destructor Destroy; override;
    function Equals(AMessage: TADMoniIndyServerQueueItem): Boolean;
    procedure AddAdapterInfo(AAdaptInfo: TADMoniAdapterInfo);
    procedure RemoveAdapterInfo(AAdaptInfo: TADMoniAdapterInfo);
    function GetAdapterInfo(AMessage: TADMoniIndyServerQueueItem): TADMoniAdapterInfo;
    procedure Trace(const AMsg: String; ATime: Int64);
    property AdapterCount: Integer read GetAdapterCount;
    property Adapters[AIndex: Integer]: TADMoniAdapterInfo read GetAdapters;
    property Buffer: TADMoniBuffer read FBuffer;
  end;

  TADMoniMainFrm = class(TForm)
    ilImages: TImageList;
    mmMenu: TMainMenu;
    miFile: TMenuItem;
    miClients: TMenuItem;
    miOptions: TMenuItem;
    miHelp: TMenuItem;
    ActionList1: TActionList;
    miFileExit: TMenuItem;
    Exit2: TMenuItem;
    acOptionsStayOnTop: TAction;
    StayOnTop1: TMenuItem;
    acOptionsStop: TAction;
    acEditCopy: TAction;
    acEditClearLog: TAction;
    acEditSelectAll: TAction;
    Copy1: TMenuItem;
    Clearlog1: TMenuItem;
    Selectall1: TMenuItem;
    sbMain: TStatusBar;
    acHelpAbout: TAction;
    About1: TMenuItem;
    SaveDialog1: TSaveDialog;
    acFileSave: TAction;
    SaveLog1: TMenuItem;
    N1: TMenuItem;
    acOptionsAutoClntSw: TAction;
    acOptionsAutoAdaptSw: TAction;
    AutoClientSwitch1: TMenuItem;
    AutoAdapterSwitch1: TMenuItem;
    acOptionsTraceOptions: TAction;
    raceOptions1: TMenuItem;
    acViewNumber: TAction;
    acViewTimestamp: TAction;
    C1: TMenuItem;
    ReferenceNumber1: TMenuItem;
    imeStamp1: TMenuItem;
    tmRefresh: TTimer;
    ApplicationEvents1: TApplicationEvents;
    IdAntiFreeze1: TIdAntiFreeze;
    N5: TMenuItem;
    N2: TMenuItem;
    pnlTopFrame: TADGUIxFormsPanel;
    pnlToolbar: TADGUIxFormsPanel;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    ToolButton5: TToolButton;
    ToolButton8: TToolButton;
    PauseTracing1: TMenuItem;
    N4: TMenuItem;
    AutoSwitch1: TMenuItem;
    pnlTopContainer: TADGUIxFormsPanel;
    pnlTopLeft: TADGUIxFormsPanel;
    pnlTopRight: TADGUIxFormsPanel;
    acFileExit: TAction;
    procedure MonSrvMessage(Sender: TObject;
      AMessage: TADMoniIndyQueueItem);
    procedure acOptionsStayOnTopExecute(Sender: TObject);
    procedure acOptionsStopExecute(Sender: TObject);
    procedure acEditCopyExecute(Sender: TObject);
    procedure acEditClearLogExecute(Sender: TObject);
    procedure acEditSelectAllExecute(Sender: TObject);
    procedure acEditCopyUpdate(Sender: TObject);
    procedure acEditClearLogUpdate(Sender: TObject);
    procedure acEditSelectAllUpdate(Sender: TObject);
    procedure acHelpAboutExecute(Sender: TObject);
    procedure acFileSaveUpdate(Sender: TObject);
    procedure acFileSaveExecute(Sender: TObject);
    procedure tvAdaptersChange(Sender: TObject; Node: TTreeNode);
    procedure lbTraceClick(Sender: TObject);
    procedure acOptionsAutoClntSwExecute(Sender: TObject);
    procedure acOptionsAutoAdaptSwExecute(Sender: TObject);
    procedure acOptionsTraceOptionsExecute(Sender: TObject);
    procedure acViewNumberExecute(Sender: TObject);
    procedure acViewTimestampExecute(Sender: TObject);
    procedure lbTraceDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
    procedure tmRefreshTimer(Sender: TObject);
    procedure sbMainResize(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure MainFrmRunning(var Message: TMessage); message C_AD_WM_MoniMainFrmRunning;
    procedure acFileExitExecute(Sender: TObject);
    procedure acOptionsStayOnTopUpdate(Sender: TObject);
    procedure acOptionsStopUpdate(Sender: TObject);
    procedure acOptionsAutoClntSwUpdate(Sender: TObject);
    procedure acOptionsAutoAdaptSwUpdate(Sender: TObject);
    procedure acViewNumberUpdate(Sender: TObject);
    procedure acViewTimestampUpdate(Sender: TObject);
  private
    FMonSrv: TADMoniIndyServer;
    FActiveClient: TADMoniClientInfo;
    FOptions: TADMoniOptions;
    FZombiBuffer: TADMoniBuffer;
    FProcessedMessages: LongWord;
    FLastProcessedMessages: LongWord;
    // tracing
    procedure SetStatus(const AMsg: String);
    function IsTraceEmpty: Boolean;
    procedure ProcessNotify(AMessage: TADMoniIndyServerQueueItem);
    function GetBuffer: TADMoniBuffer;
    procedure Trace(const AMsg: String);
    procedure UpdateHeader;
    procedure UpdateTopmost;
    // clients
    procedure DoClientClicked(ASender: TObject);
    function SetActiveClient(AClientInfo: TADMoniClientInfo): Boolean;
    function GetClientInfo(AMessage: TADMoniIndyServerQueueItem): TADMoniClientInfo;
    procedure ProcessConnectClient(AMessage: TADMoniIndyServerQueueItem);
    procedure ProcessDisconnectClient(AMessage: TADMoniIndyServerQueueItem);
    // adaptors
    procedure ProcessRegisterAdapter(AMessage: TADMoniIndyServerQueueItem);
    procedure ProcessUnRegisterAdapter(AMessage: TADMoniIndyServerQueueItem);
    procedure BuildAdaptersTree(AClientInfo: TADMoniClientInfo);
    procedure ProcessUpdateAdapter(AMessage: TADMoniIndyServerQueueItem);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  ADMoniMainFrm: TADMoniMainFrm;

implementation

uses
  Registry,
{$IFDEF AnyDAC_D6}
  StrUtils,
{$ENDIF}
  fOptionsFrm, fObjFrm, fTraceFrm,
  daADGUIxFormsfAbout,
  daADStanUtil;

{$R *.dfm}
{$R ADMonitorButtons.res}

resourcestring
  S_AD_MoniPortInUse =
    'AnyDAC Monitor TCP/IP port %d is in use.' + C_AD_EOL +
    'To continue you must change port number. Press OK to change settings.' + C_AD_EOL +
    'Also you can use -ADMP:<port number> command line switch.';
  S_AD_MoniStarted = 'Monitor started';
  S_AD_MoniPaused = 'Monitor paused';
  S_AD_MoniRunning = 'Monitor running';
  S_AD_MoniRunTracing = '&Run tracing';
  S_AD_MoniPauseTracing = '&Pause tracing';
  S_AD_MoniToChangePortRestart =
    'To change listening port you should restart AnyDAC Monitor.' + C_AD_EOL +
    'Do you want to close it now ?';
  S_AD_MoniClientActivated = 'Client %s activated';
  S_AD_MoniClientConnected = 'Client %s connected';
  S_AD_MoniClientDisconnected = 'Client %s disconnected';
  S_AD_MoniNoneClients = '(none)';
  S_AD_MoniAdapterRegistered = 'Adapter %s registered with client';
  S_AD_MoniAdapterUnregistered = 'Adapter %s unregistered with client';

{ ----------------------------------------------------------------------------- }
{ TADMoniOptions                                                                }
{ ----------------------------------------------------------------------------- }
constructor TADMoniOptions.Create;
begin
  inherited Create;
  FClntAutoSwitch := True;
  FAdaptAutoSwitch := False;
  FCollectingPaused := False;
  FDisplayingPaused := False;
  FEventKinds := [ekLiveCycle .. ekVendor];
  FBufferMode := tmLimitMemory;
  FBufferCapacity := 256 * 1024;
  FBufferPageFile := '';
  FStayOnTop := False;
  FListeningPort := C_AD_MonitorPort;
  FFormatWithID := True;
  FFormatWithTime := True;
  FTabWidth := 2;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniOptions.LoadFromRegistry;
var
  oReg: TRegistry;
  i: Integer;
begin
  oReg := TRegistry.Create(KEY_READ);
  try
    oReg.RootKey := HKEY_CURRENT_USER;
    if oReg.OpenKey(S_AD_CfgKeyName + '\Monitor', False) then begin
      FListeningPort := oReg.ReadInteger('ListeningPort');
      FClntAutoSwitch := oReg.ReadBool('ClntAutoSwitch');
      FAdaptAutoSwitch := oReg.ReadBool('AdaptAutoSwitch');
      FCollectingPaused := oReg.ReadBool('CollectingPaused');
      FDisplayingPaused := oReg.ReadBool('DisplayingPaused');
      i := oReg.ReadInteger('EventKinds');
      FEventKinds := TADMoniEventKinds(Pointer(@i)^);
      FBufferMode := TADMoniBufferMode(oReg.ReadInteger('BufferMode'));
      FBufferCapacity := oReg.ReadInteger('BufferCapacity');
      FBufferPageFile := oReg.ReadString('BufferPageFile');
      FStayOnTop := oReg.ReadBool('StayOnTop');
      FFormatWithID := oReg.ReadBool('FormatWithID');
      FFormatWithTime := oReg.ReadBool('FormatWithTime');
      FTabWidth := oReg.ReadInteger('TabWidth');
    end;
  except
    // nothing
  end;
  oReg.Free;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniOptions.SaveToRegistry;
var
  oReg: TRegistry;
begin
  oReg := TRegistry.Create(KEY_WRITE);
  try
    oReg.RootKey := HKEY_CURRENT_USER;
    if oReg.OpenKey(S_AD_CfgKeyName + '\Monitor', True) then begin
      oReg.WriteInteger('ListeningPort', FListeningPort);
      oReg.WriteBool('ClntAutoSwitch', FClntAutoSwitch);
      oReg.WriteBool('AdaptAutoSwitch', FAdaptAutoSwitch);
      oReg.WriteBool('CollectingPaused', FCollectingPaused);
      oReg.WriteBool('DisplayingPaused', FDisplayingPaused);
      oReg.WriteInteger('EventKinds', PInteger(@FEventKinds)^);
      oReg.WriteInteger('BufferMode', Integer(FBufferMode));
      oReg.WriteInteger('BufferCapacity', FBufferCapacity);
      oReg.WriteString('BufferPageFile', FBufferPageFile);
      oReg.WriteBool('StayOnTop', FStayOnTop);
      oReg.WriteBool('FormatWithID', FFormatWithID);
      oReg.WriteBool('FormatWithTime', FFormatWithTime);
      oReg.WriteInteger('TabWidth', FTabWidth);
    end;
  except
    ADHandleException;    
  end;
  oReg.Free;
end;

{ ----------------------------------------------------------------------------- }
{ TADMoniAdapterInfo                                                            }
{ ----------------------------------------------------------------------------- }
constructor TADMoniAdapterInfo.Create(AOptions: TADMoniOptions;
  AMessage: TADMoniIndyServerQueueItem);
begin
  inherited Create;
  FOptions := AOptions;
  FPath := AMessage.FPath;
  FHandle := AMessage.FHandle;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniAdapterInfo.WalkThroughTree(ATree: TTreeView; const APath: String;
  var AIndex: Integer; AOwner: TTreeNode; var ACurrent: TTreeNode; var AName: String): Boolean;
var
  iPrevIndex: Integer;
begin
  if AIndex > Length(APath) then begin
    Result := False;
    Exit;
  end;
  iPrevIndex := AIndex;
  Result := True;
  while (AIndex <= Length(APath)) and (APath[AIndex] <> '.') do
    Inc(AIndex);
  AName := Copy(APath, iPrevIndex, AIndex - iPrevIndex);
  Inc(AIndex);
  if AOwner = nil then
    ACurrent := ATree.Items.GetFirstNode
  else
    ACurrent := AOwner.getFirstChild;
  while (ACurrent <> nil) and (AnsiCompareText(ACurrent.Text, AName) <> 0) do
    ACurrent := ACurrent.getNextSibling;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterInfo.InsertIntoTree(ATree: TTreeView);
var
  i: Integer;
  sName: String;
  oNodeOwner, oNodeCurrent: TTreeNode;
begin
  i := 1;
  oNodeOwner := nil;
  oNodeCurrent := nil;
  while WalkThroughTree(ATree, Path, i, oNodeOwner, oNodeCurrent, sName) do begin
    if oNodeCurrent = nil then
      oNodeCurrent := ATree.Items.AddChild(oNodeOwner, sName);
    oNodeOwner := oNodeCurrent;
  end;
  if oNodeCurrent <> nil then begin
    oNodeCurrent.Data := Self;
    if FOptions.AdaptAutoSwitch then begin
      oNodeCurrent.MakeVisible;
      oNodeCurrent.Selected := True;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterInfo.RemoveFromTree(ATree: TTreeView);
var
  i: Integer;
  sName: String;
  oNodeOwner, oNodeCurrent: TTreeNode;
begin
  i := 1;
  oNodeOwner := nil;
  oNodeCurrent := nil;
  while WalkThroughTree(ATree, Path, i, oNodeOwner, oNodeCurrent, sName) do begin
    if oNodeCurrent = nil then
      Break;
    oNodeOwner := oNodeCurrent;
  end;
  while oNodeCurrent <> nil do begin
    oNodeOwner := oNodeCurrent.Parent;
    if oNodeCurrent.Count = 0 then
      oNodeCurrent.Free;
    oNodeCurrent := oNodeOwner;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterInfo.UpdateState(AMessage: TADMoniIndyServerQueueItem);
begin
  FStat := AMessage.GetArgs;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterInfo.ShowStat(AStat: TListView; ASQL: TMemo; AParams: TListView);
var
  i: Integer;
  lQuotes: Boolean;
  sName, sVal: String;
  eKind: TADDebugMonitorAdapterItemKind;
begin
  if not VarIsNull(FStat) and not VarIsEmpty(FStat) then begin
    i := 0;
    while i <= VarArrayHighBound(FStat, 1) do begin
      sName := ADIdentToStr(FStat[i], lQuotes);
      sVal := ADValToStr(FStat[i + 1], lQuotes);
      eKind := TADDebugMonitorAdapterItemKind(Byte(FStat[i + 2]));
      case eKind of
      ikSQL:
        ASQL.Text := ADFixCRLF(sVal);
      ikParam:
        with AParams.Items.Add do begin
          Caption := sName;
          SubItems.Add(sVal);
        end;
      ikStat,
      ikClientInfo,
      ikSessionInfo:
        with AStat.Items.Add do begin
          Caption := sName;
          SubItems.Add(sVal);
        end;
      end;
      Inc(i, 3);
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
{ TADMoniBuffer                                                                 }
{ ----------------------------------------------------------------------------- }

type
  TADMonBufferItemInfo = packed record
    FID: LongWord;
    FTime: Int64;
    FText: String;
  end;
  PDEMonBufferItemInfo = ^TADMonBufferItemInfo;

constructor TADMoniBuffer.Create;
begin
  inherited Create;
  FItems := TStringList.Create;
  FMode := tmLimitMemory;
  FCapacity := 256 * 1024;
  FTabWidth := 2;
  InitializeCriticalSection(FLock);
  Clear;
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniBuffer.Destroy;
begin
  FItems.Free;
  FItems := nil;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.GetCount: Integer;
begin
  EnterCriticalSection(FLock);
  try
    Result := FItems.Count;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.GetPhysicalIndex(AIndex: Integer): Integer;
begin
  Inc(AIndex, FPtr + 1);
  if AIndex >= FItems.Count then
    AIndex := AIndex - FItems.Count;
  Result := AIndex;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.GetCaptions(AIndex: Integer): String;
begin
  EnterCriticalSection(FLock);
  try
    Result := FItems[GetPhysicalIndex(AIndex)];
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.GetIDs(AIndex: Integer): LongWord;
begin
  EnterCriticalSection(FLock);
  try
    Result := PDEMonBufferItemInfo(FItems.Objects[GetPhysicalIndex(AIndex)])^.FID;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.GetTimes(AIndex: Integer): TDateTime;
begin
  EnterCriticalSection(FLock);
  try
    Result := FBaseTime +
      PDEMonBufferItemInfo(FItems.Objects[GetPhysicalIndex(AIndex)])^.FTime /
        (1000.0 * 3600.0 * 24.0);
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.GetTexts(AIndex: Integer): String;
begin
  EnterCriticalSection(FLock);
  try
    Result := PDEMonBufferItemInfo(FItems.Objects[GetPhysicalIndex(AIndex)])^.FText;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniBuffer.PageOut;
var
  oFS: TFileStream;
begin
  EnterCriticalSection(FLock);
  try
    if not FileExists(FPagingFile) then
      oFS := TFileStream.Create(FPagingFile, fmCreate)
    else begin
      oFS := TFileStream.Create(FPagingFile, fmOpenWrite or fmShareDenyWrite);
      oFS.Seek(0, soEnd);
    end;
    try
      FItems.SaveToStream(oFS);
    finally
      oFS.Free;
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniBuffer.Add(const AStr: String; ATime: Int64);
var
  pInfo: PDEMonBufferItemInfo;
  sCaption, sText, sChar: String;
  iText, iStr, iCRLF: Integer;
begin
  EnterCriticalSection(FLock);
  try
    iStr := 1;
    iCRLF := 0;
    iText := 1;
    SetLength(sText, Length(AStr) * 4);
    while iStr <= Length(AStr) do begin
      if (AStr[iStr] in [#13, #10]) and (iCRLF = 0) then
        iCRLF := iText;
      if (AStr[iStr] < ' ') and not (AStr[iStr] in [#13, #10]) then begin
        if (AStr[iStr] = #9) and (FTabWidth > 0) then
          sChar := StringOfChar(' ', FTabWidth)
        else
          sChar := '#' + IntToStr(Ord(AStr[iStr]));
        ADMove(sChar[1], sText[iText], Length(sChar));
        Inc(iText, Length(sChar));
      end
      else begin
        sText[iText] := AStr[iStr];
        Inc(iText);
      end;
      Inc(iStr);
    end;
    SetLength(sText, iText - 1);
    if iCRLF = 0 then
      sCaption := sText
    else
      sCaption := Copy(sText, 1, iCRLF - 1) + ' ...';
    if FMode in [tmLimitItems, tmLimitItemsAndPage] then begin
      Inc(FPtr);
      if FPtr = FItems.Count then begin
        if FItems.Count = FCapacity then begin
          if FMode = tmLimitItemsAndPage then
            PageOut;
          FPtr := 0;
        end
        else begin
          New(pInfo);
          FItems.AddObject('', TObject(pInfo));
        end;
      end;
      FItems[FPtr] := sCaption;
    end
    else if FMode in [tmLimitMemory, tmLimitMemoryAndPage] then begin
      Inc(FPtr);
      if FPtr = FItems.Count then begin
        if (FAllocatedSize + Length(sCaption) + 48) >= FCapacity then begin
          if FMode = tmLimitMemoryAndPage then
            PageOut;
          FPtr := 0
        end
        else begin
          New(pInfo);
          FItems.AddObject('', TObject(pInfo));
          Inc(FAllocatedSize, 48);
        end;
      end;
      Dec(FAllocatedSize, Length(FItems[FPtr]));
      FItems[FPtr] := sCaption;
      Inc(FAllocatedSize, Length(sCaption));
    end;
    with PDEMonBufferItemInfo(FItems.Objects[FPtr])^ do begin
      FID := FTotalItems;
      FTime := ATime;
      FText := sText;
    end;
    Inc(FTotalItems);
    FChanged := True;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniBuffer.Clear;
var
  i: Integer;
  p: PDEMonBufferItemInfo;
begin
  EnterCriticalSection(FLock);
  try
    for i := 0 to FItems.Count - 1 do begin
      p := PDEMonBufferItemInfo(FItems.Objects[i]);
      Dispose(p);
    end;
    FItems.Clear;
    FPtr := -1;
    FAllocatedSize := 0;
    FTotalItems := 0;
    FBaseTime := Now() - (GetTickCount / (1000.0 * 3600.0 * 24.0));
    FChanged := True;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniBuffer.SaveToFile(const AFileName: String);
var
  oFS: TFileStream;
  i: Integer;
  s: String;
begin
  EnterCriticalSection(FLock);
  try
    oFS := TFileStream.Create(AFileName, fmCreate);
    try
      for i := 0 to Count - 1 do begin
        s := Texts[i];
        oFS.Write(PChar(s)^, Length(s));
        oFS.Write(PChar(C_AD_EOL)^, Length(C_AD_EOL));
      end;
    finally
      oFS.Free;
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniBuffer.CheckChanged: Boolean;
begin
  Result := FChanged;
  FChanged := False;
end;

{ ----------------------------------------------------------------------------- }
{ TADMoniClientInfo                                                             }
{ ----------------------------------------------------------------------------- }
constructor TADMoniClientInfo.Create(AMessage: TADMoniIndyServerQueueItem;
  AClientMenu: TMenuItem; AMonSrv: TADMoniIndyServer; AOptions: TADMoniOptions);
begin
  inherited Create;
  FOptions := AOptions;
  FAdapters := TList.Create;
  FBuffer := TADMoniBuffer.Create;
  FBuffer.Mode := FOptions.BufferMode;
  FBuffer.Capacity := FOptions.BufferCapacity;
  FBuffer.PagingFile := FOptions.BufferPageFile;
  FCaption := BuildClientName(AMessage, AClientMenu, AMonSrv);
  FHost := AMessage.FHost;
  FProcessID := AMessage.FProcessID;
  FMonitorID := AMessage.FMonitorID;
  FStartupTimeDelta := AMessage.FTime - Int64(GetTickCount());
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniClientInfo.Destroy;
begin
  if FMenuItem <> nil then begin
    FMenuItem.Free;
    FMenuItem := nil;
  end;
  if FBuffer <> nil then begin
    FBuffer.Free;
    FBuffer := nil;
  end;
  FAdapters.Free;
  FAdapters := nil;
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniClientInfo.BuildClientName(AMessage: TADMoniIndyServerQueueItem;
  AClientMenu: TMenuItem; AMonSrv: TADMoniIndyServer): String;
var
  sMonName: String;
  i, iProcIDStart: Integer;
begin
  Result := '';
  if not ADMoniIndyIsLocalHost(AMessage.FHost) then
    Result := '[H: ' + AMessage.FHost + '] ';
  i := Pos(';', AMessage.FMessage);
  Result := Result + '[P: ' + Copy(AMessage.FMessage, 1, i - 1) + ']';
  iProcIDStart := Length(Result);
  if i = Length(AMessage.FMessage) then begin
    if AMessage.FMonitorID > 1 then
      Result := Result + ' [S#: ' + IntToStr(AMessage.FMonitorID) + ']';
  end
  else begin
    sMonName := Copy(AMessage.FMessage, i + 1, Length(AMessage.FMessage));
    if CompareText(sMonName, 'Default') <> 0 then
      Result := Result + ' [S: ' + sMonName + ']';
  end;
  if AClientMenu.Find(Result) <> nil then
    Insert(' [P#: ' + IntToStr(AMessage.FProcessID) + ']', Result, iProcIDStart + 1);
end;

{ ----------------------------------------------------------------------------- }
function TADMoniClientInfo.Equals(AMessage: TADMoniIndyServerQueueItem): Boolean;
begin
  Result := (CompareText(FHost, AMessage.FHost) = 0) and
    (FProcessID = AMessage.FProcessID) and (FMonitorID = AMessage.FMonitorID);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniClientInfo.AddAdapterInfo(AAdaptInfo: TADMoniAdapterInfo);
begin
  FAdapters.Add(AAdaptInfo);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniClientInfo.RemoveAdapterInfo(AAdaptInfo: TADMoniAdapterInfo);
begin
  FAdapters.Remove(AAdaptInfo);
end;

{ ----------------------------------------------------------------------------- }
function TADMoniClientInfo.GetAdapterInfo(AMessage: TADMoniIndyServerQueueItem): TADMoniAdapterInfo;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FAdapters.Count - 1 do
    if TADMoniAdapterInfo(FAdapters.Items[i]).Handle = AMessage.FHandle then begin
      Result := TADMoniAdapterInfo(FAdapters.Items[i]);
      Break;
    end;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniClientInfo.GetAdapterCount: Integer;
begin
  Result := FAdapters.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniClientInfo.GetAdapters(AIndex: Integer): TADMoniAdapterInfo;
begin
  Result := TADMoniAdapterInfo(FAdapters.Items[AIndex]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniClientInfo.Trace(const AMsg: String; ATime: Int64);
begin
  if FOptions.CollectingPaused then
    Exit;
  Buffer.Add(AMsg, ATime);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniClientInfo.Notify(var ALevel: Integer; AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ATime: Int64; const ASender: String; const AMsg: String;
  const AArgs: Variant);
var
  s: String;
  i, iLow, iHigh: Integer;
  lQuotes: Boolean;
begin
  if AStep = esEnd then
    Dec(ALevel);
  if not FOptions.CollectingPaused and (AKind in FOptions.FEventKinds) then begin
    s := StringOfChar(' ', ALevel * 4);
    case AStep of
    esStart:    s := s + '>> ';
    esProgress: s := s + ' . ';
    esEnd:      s := s + '<< ';
    end;
    if (AStep <> esProgress) and (ASender <> '') and (ASender <> FLastSender) then begin
      s := s + ASender + '.';
      FLastSender := ASender;
    end;
    s := s + AMsg;
    if VarIsArray(AArgs) then begin
      iHigh := VarArrayHighBound(AArgs, 1);
      iLow := VarArrayLowBound(AArgs, 1);
      if iHigh - iLow + 1 >= 2 then begin
        s := s + ' [';
        i := iLow;
        while i < iHigh do begin
          if i <> iLow then
            s := s + ', ';
          s := s + ADIdentToStr(AArgs[i], lQuotes) + '=' + ADValToStr(AArgs[i + 1], lQuotes);
          Inc(i, 2);
        end;
        s := s + ']';
      end;
    end;
    Trace(s, ATime - FStartupTimeDelta);
  end;
  if AStep = esStart then
    Inc(ALevel);
end;

{ ----------------------------------------------------------------------------- }
{ TADMonServerFrm                                                               }
{ ----------------------------------------------------------------------------- }
constructor TADMoniMainFrm.Create(AOwner: TComponent);
var
  sModule, sProduct, sVersion, sVersionName, sCopyright, sInfo: String;
  iRetry: Integer;
{$IFNDEF AnyDAC_D6}
  ModName: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
  inherited Create(AOwner);
  FMonSrv := TADMoniIndyServer.Create;
  FMonSrv.OnMessage := MonSrvMessage;
  Application.ShowHint := True;
{$IFDEF AnyDAC_D6}
  sModule := GetModuleName(HInstance);
{$ELSE}
  SetString(sModule, ModName, GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
{$ENDIF}
  ADGetVersionInfo(sModule, sProduct, sVersion, sVersionName, sCopyright, sInfo);
  sbMain.Panels[2].Text := 'Version: ' + sVersion;
  sbMain.Panels[3].Text := sCopyright;
  FOptions := TADMoniOptions.Create;
  FOptions.LoadFromRegistry;
  iRetry := 0;
  while iRetry <> -1 do
    try
      if iRetry = 0 then begin
        FMonSrv.Port := StrToInt(ADGetCmdParam('ADMP', IntToStr(FOptions.ListeningPort)));
        FMonSrv.Tracing := True;
      end
      else
        acOptionsTraceOptionsExecute(nil);
      iRetry := -1;
    except
      on E: EIdCouldNotBindSocket do begin
        if MessageDlg(Format(S_AD_MoniPortInUse, [FOptions.ListeningPort]),
                      mtError, [mbOK, mbCancel], -1) = mrOK then
          Inc(iRetry)
        else
          iRetry := -1;
      end;
    end;
  if FMonSrv.Tracing then
    PostMessage(Handle, C_AD_WM_MoniMainFrmRunning, 0, 0)
  else
    Application.Terminate;
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniMainFrm.Destroy;
begin
  if FZombiBuffer <> nil then begin
    FZombiBuffer.Free;
    FZombiBuffer := nil;
  end;
  FMonSrv.Tracing := False;
  FOptions.SaveToRegistry;
  FOptions.Free;
  FOptions := nil;
  FMonSrv.Free;
  FMonSrv := nil;
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.MainFrmRunning(var Message: TMessage);
begin
  ADMoniObjectsFrm := TADMoniObjectsFrm.Create(Application);
  ADMoniObjectsFrm.tvAdapters.OnChange := tvAdaptersChange;
  ADMoniTraceFrm := TADMoniTraceFrm.Create(Application);
  ADMoniTraceFrm.lbTrace.OnClick := lbTraceClick;
  ADMoniTraceFrm.lbTrace.OnDrawItem := lbTraceDrawItem;
  UpdateHeader;
  UpdateTopmost;
  SetStatus(S_AD_MoniStarted);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.ApplicationEvents1Hint(Sender: TObject);
begin
  sbMain.Panels[0].Text := Application.Hint;
end;

{ ----------------------------------------------------------------------------- }
// File

procedure TADMoniMainFrm.acFileSaveUpdate(Sender: TObject);
begin
  acFileSave.Enabled := not IsTraceEmpty;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acFileSaveExecute(Sender: TObject);
begin
  SaveDialog1.FileName := 'Trace_' + FormatDateTime('yymmdd_hhnn', Now()) + '.log';
  if SaveDialog1.Execute then
    GetBuffer().SaveToFile(SaveDialog1.FileName);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acFileExitExecute(Sender: TObject);
begin
  Close;
end;

{ ----------------------------------------------------------------------------- }
// Edit

procedure TADMoniMainFrm.acEditCopyUpdate(Sender: TObject);
begin
  acEditCopy.Enabled := not IsTraceEmpty and (ADMoniTraceFrm.lbTrace.SelCount > 0);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acEditCopyExecute(Sender: TObject);
var
  i: Integer;
  s: String;
begin
  s := '';
  with ADMoniTraceFrm do
    for i := 0 to lbTrace.Count - 1 do
      if lbTrace.Selected[i] then begin
        if s <> '' then
          s := s + C_AD_EOL;
        s := s + GetBuffer()[i];
      end;
  Clipboard.AsText := s;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acEditClearLogUpdate(Sender: TObject);
begin
  acEditClearLog.Enabled := not IsTraceEmpty;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acEditClearLogExecute(Sender: TObject);
begin
  GetBuffer().Clear;
  with ADMoniTraceFrm do begin
    lbTrace.Count := 0;
    mmDetails.Clear;
  end;
  if FActiveClient = nil then
    with ADMoniObjectsFrm do begin
      tvAdapters.Items.Clear;
      lvStat.Items.Clear;
      mmSQL.Lines.Clear;
      lvParams.Items.Clear;
    end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acEditSelectAllUpdate(Sender: TObject);
begin
  acEditSelectAll.Enabled := not IsTraceEmpty;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acEditSelectAllExecute(Sender: TObject);
var
  i: Integer;
begin
  with ADMoniTraceFrm.lbTrace do
    for i := 0 to Items.Count - 1 do
      Selected[i] := True;
end;

{ ----------------------------------------------------------------------------- }
// View

procedure TADMoniMainFrm.acViewNumberUpdate(Sender: TObject);
begin
  acViewNumber.Checked := FOptions.FormatWithID;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acViewNumberExecute(Sender: TObject);
begin
  FOptions.FormatWithID := not FOptions.FormatWithID;
  UpdateHeader;
  ADMoniTraceFrm.lbTrace.Invalidate;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acViewTimestampUpdate(Sender: TObject);
begin
  acViewTimestamp.Checked := FOptions.FormatWithTime;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acViewTimestampExecute(Sender: TObject);
begin
  FOptions.FormatWithTime := not FOptions.FormatWithTime;
  UpdateHeader;
  ADMoniTraceFrm.lbTrace.Invalidate;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.sbMainResize(Sender: TObject);
begin
  with sbMain do
    Panels[0].Width := Width - (Panels[1].Width + Panels[2].Width + Panels[3].Width);
end;

{ ----------------------------------------------------------------------------- }
// Options

procedure TADMoniMainFrm.acOptionsStopUpdate(Sender: TObject);
begin
  acOptionsStop.Checked := FOptions.CollectingPaused;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsStopExecute(Sender: TObject);
begin
  if not FOptions.CollectingPaused then begin
    tmRefreshTimer(nil);
    acOptionsStop.ImageIndex := 4;
    acOptionsStop.Caption := S_AD_MoniRunTracing;
    SetStatus(S_AD_MoniPaused);
    FOptions.CollectingPaused := True;
  end
  else begin
    FOptions.CollectingPaused := False;
    acOptionsStop.ImageIndex := 3;
    acOptionsStop.Caption := S_AD_MoniPauseTracing;
    SetStatus(S_AD_MoniRunning);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsTraceOptionsExecute(Sender: TObject);
var
  lClearBuffer: Boolean;
  i: Integer;
  oCI: TADMoniClientInfo;
begin
  if TfrmOptions.Execute(FOptions, Sender = nil, lClearBuffer) then begin
    if FMonSrv.Tracing and (FMonSrv.Port <> FOptions.ListeningPort) then
      if MessageDlg(S_AD_MoniToChangePortRestart, mtWarning, [mbOk, mbCancel], -1) = mrOk then
        Close;
    FMonSrv.Port := FOptions.ListeningPort;
    FMonSrv.Tracing := True;
    for i := 0 to miClients.Count - 1 do begin
      oCI := TADMoniClientInfo(miClients.Items[i].Tag);
      if oCI <> nil then begin
        oCI.Buffer.Mode := FOptions.BufferMode;
        oCI.Buffer.Capacity := FOptions.BufferCapacity;
        oCI.Buffer.PagingFile := FOptions.BufferPageFile;
        oCI.Buffer.TabWidth := FOptions.TabWidth;
        if lClearBuffer then
          oCI.Buffer.Clear;
      end;
    end;
    if lClearBuffer and (FActiveClient <> nil) then
      with ADMoniTraceFrm do begin
        lbTrace.Count := 0;
        mmDetails.Clear;
      end;
  end
  else if Sender = nil then
    Application.Terminate;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.UpdateTopmost;
var
  hWndInsertAfter: HWND;
begin
  if FOptions.StayOnTop then
    hWndInsertAfter := HWND_TOPMOST
  else
    hWndInsertAfter := HWND_NOTOPMOST;
  SetWindowPos(Handle, hWndInsertAfter, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsStayOnTopUpdate(Sender: TObject);
begin
  acOptionsStayOnTop.Checked := FOptions.StayOnTop;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsStayOnTopExecute(Sender: TObject);
begin
  FOptions.StayOnTop := not FOptions.StayOnTop;
  UpdateTopmost;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsAutoClntSwUpdate(Sender: TObject);
begin
  acOptionsAutoClntSw.Checked := FOptions.ClntAutoSwitch;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsAutoClntSwExecute(Sender: TObject);
begin
  FOptions.ClntAutoSwitch := not FOptions.ClntAutoSwitch;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsAutoAdaptSwUpdate(Sender: TObject);
begin
  acOptionsAutoAdaptSw.Checked := FOptions.AdaptAutoSwitch;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.acOptionsAutoAdaptSwExecute(Sender: TObject);
begin
  FOptions.AdaptAutoSwitch := not FOptions.AdaptAutoSwitch;
end;

{ ----------------------------------------------------------------------------- }
// Help

procedure TADMoniMainFrm.acHelpAboutExecute(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute;
end;

{ ----------------------------------------------------------------------------- }
{ Tracing }

procedure TADMoniMainFrm.UpdateHeader;
begin
  if ADMoniTraceFrm = nil then
    Exit;
  with ADMoniTraceFrm do begin
    if FOptions.FormatWithID then
      HeaderControl1.Sections[0].Width := 50
    else
      HeaderControl1.Sections[0].Width := 0;
    if FOptions.FormatWithTime then
      HeaderControl1.Sections[1].Width := 80
    else
      HeaderControl1.Sections[1].Width := 0;
    HeaderControl1.Sections[2].Width := HeaderControl1.Width;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.FormResize(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
    UpdateHeader;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniMainFrm.GetBuffer: TADMoniBuffer;
begin
  if FActiveClient <> nil then
    Result := FActiveClient.Buffer
  else
    Result := FZombiBuffer;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.Trace(const AMsg: String);
var
  oBuffer: TADMoniBuffer;
begin
  if FOptions.CollectingPaused then
    Exit;
  oBuffer := GetBuffer();
  if oBuffer <> nil then
    oBuffer.Add(AMsg, GetTickCount());
end;

{ ----------------------------------------------------------------------------- }
function TADMoniMainFrm.IsTraceEmpty: Boolean;
begin
  Result := (GetBuffer() = nil) or (GetBuffer().Count = 0);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.SetStatus(const AMsg: String);
begin
  if sbMain.Visible then
    sbMain.Panels[0].Text := AMsg;
  Trace('***** ' + AMsg);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.lbTraceDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: String;
  liFlags: Longint;
  oBuffer: TADMoniBuffer;
begin
  with ADMoniTraceFrm do begin
    lbTrace.Canvas.FillRect(Rect);
    oBuffer := GetBuffer;
    if (Index < lbTrace.Count) and (oBuffer <> nil) then begin
      liFlags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      Inc(Rect.Left, 2);
      if FOptions.FormatWithID then begin
        s := IntToStr(oBuffer.IDs[Index]);
        DrawText(lbTrace.Canvas.Handle, PChar(s), Length(s), Rect, liFlags);
        Inc(Rect.Left, 50);
      end;
      if FOptions.FormatWithTime then begin
        s := FormatDateTime('hh:nn:ss:zzz', oBuffer.Times[Index]);
        DrawText(lbTrace.Canvas.Handle, PChar(s), Length(s), Rect, liFlags);
        Inc(Rect.Left, 80);
      end;
      s := oBuffer[Index];
      DrawText(lbTrace.Canvas.Handle, PChar(s), Length(s), Rect, liFlags);
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.lbTraceClick(Sender: TObject);
var
  oBuffer: TADMoniBuffer;
begin
  oBuffer := GetBuffer;
  with ADMoniTraceFrm do
    if (oBuffer <> nil) and (lbTrace.ItemIndex >= 0) then
      mmDetails.Text := oBuffer.Texts[lbTrace.ItemIndex]
    else
      mmDetails.Text := '';
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.tmRefreshTimer(Sender: TObject);
var
  iPrevIndex: Integer;
  lLastIndex: Boolean;
  oBuffer: TADMoniBuffer;
begin
  with ADMoniTraceFrm do
    if not FOptions.DisplayingPaused then begin
      oBuffer := GetBuffer();
      if (oBuffer <> nil) and oBuffer.CheckChanged then begin
        iPrevIndex := lbTrace.ItemIndex;
        lLastIndex := (iPrevIndex = lbTrace.Count - 1) or (lbTrace.Count = 0);
        if lbTrace.Count <> GetBuffer().Count then
          lbTrace.Count := GetBuffer().Count
        else
          lbTrace.Invalidate;
        if lLastIndex then
          lbTrace.ItemIndex := lbTrace.Count - 1
        else
          lbTrace.ItemIndex := iPrevIndex;
      end;
    end;
  if sbMain.Visible then begin
    sbMain.Panels[1].Text := IntToStr(FProcessedMessages - FLastProcessedMessages);
    FLastProcessedMessages := FProcessedMessages;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.MonSrvMessage(Sender: TObject; AMessage: TADMoniIndyQueueItem);
begin
  case AMessage.FEvent of
  ptConnectClient:
    ProcessConnectClient(TADMoniIndyServerQueueItem(AMessage));
  ptDisConnectClient:
    ProcessDisconnectClient(TADMoniIndyServerQueueItem(AMessage));
  ptNotify:
    ProcessNotify(TADMoniIndyServerQueueItem(AMessage));
  ptRegisterAdapter:
    ProcessRegisterAdapter(TADMoniIndyServerQueueItem(AMessage));
  ptUnRegisterAdapter:
    ProcessUnRegisterAdapter(TADMoniIndyServerQueueItem(AMessage));
  ptUpdateAdapter:
    ProcessUpdateAdapter(TADMoniIndyServerQueueItem(AMessage));
  end;
end;

{ ----------------------------------------------------------------------------- }
{ Client management }

function TADMoniMainFrm.GetClientInfo(AMessage: TADMoniIndyServerQueueItem): TADMoniClientInfo;
var
  i: Integer;
begin
  i := 0;
  Result := nil;
  while i < miClients.Count do begin
    Result := TADMoniClientInfo(miClients.Items[i].Tag);
    if Result.Equals(AMessage) then
      Break;
    Inc(i);
  end;
  if i = miClients.Count then
    Result := nil;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniMainFrm.SetActiveClient(AClientInfo: TADMoniClientInfo): Boolean;
begin
  if FActiveClient <> AClientInfo then begin
    FActiveClient := AClientInfo;
    if FActiveClient <> nil then begin
      if FZombiBuffer <> nil then begin
        FZombiBuffer.Free;
        FZombiBuffer := nil;
      end;
      ADMoniTraceFrm.lbTrace.Count := FActiveClient.Buffer.Count;
      with ADMoniObjectsFrm do begin
        tvAdapters.Items.Clear;
        lvStat.Items.Clear;
        mmSQL.Lines.Clear;
        lvParams.Items.Clear;
      end;
      AClientInfo.FMenuItem.Checked := True;
      BuildAdaptersTree(AClientInfo);
      SetStatus(Format(S_AD_MoniClientActivated, [AClientInfo.FCaption]));
    end;
    Result := True;
  end
  else
    Result := False;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.DoClientClicked(ASender: TObject);
begin
  TMenuItem(ASender).Checked := not TMenuItem(ASender).Checked;
  SetActiveClient(TADMoniClientInfo(TMenuItem(ASender).Tag));
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.ProcessConnectClient(AMessage: TADMoniIndyServerQueueItem);
var
  oMI: TMenuItem;
  oCI: TADMoniClientInfo;
begin
  oCI := TADMoniClientInfo.Create(AMessage, miClients, FMonSrv, FOptions);
  oMI := NewItem(oCI.FCaption, 0, False, True, DoClientClicked, 0, '');
  oMI.RadioItem := True;
  oMI.GroupIndex := 1;
  oMI.Tag := LongWord(oCI);
  oCI.FMenuItem := oMI;
  if (miClients.Count = 1) and (miClients.Items[0].Tag = 0) then
    miClients.Delete(0);
  miClients.Add(oMI);
  if FOptions.ClntAutoSwitch then
    oMI.Click
  else
    SetStatus(Format(S_AD_MoniClientConnected, [oCI.FCaption]));
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.ProcessDisconnectClient(AMessage: TADMoniIndyServerQueueItem);
var
  i: Integer;
  oCI: TADMoniClientInfo;
begin
  oCI := GetClientInfo(AMessage);
  if oCI <> nil then begin
    SetStatus(Format(S_AD_MoniClientDisconnected, [oCI.FCaption]));
    try
      if oCI = FActiveClient then
        if FOptions.ClntAutoSwitch and (miClients.Count > 1) then begin
          i := oCI.FMenuItem.MenuIndex;
          if i > 0 then
            Dec(i)
          else
            Inc(i);
          miClients.Items[i].Click;
        end
        else
          SetActiveClient(nil);
    finally
      if FActiveClient = nil then begin
        FZombiBuffer := oCI.Buffer;
        oCI.FBuffer := nil;
      end;
      oCI.Free;
    end;
    if miClients.Count = 0 then
      miClients.Add(NewItem(S_AD_MoniNoneClients, 0, False, False, nil, 0, ''));
  end;
end;

{ ----------------------------------------------------------------------------- }
{ Adapter management }

procedure TADMoniMainFrm.ProcessRegisterAdapter(AMessage: TADMoniIndyServerQueueItem);
var
  oCI: TADMoniClientInfo;
  oAI: TADMoniAdapterInfo;
begin
  oCI := GetClientInfo(AMessage);
  if oCI <> nil then begin
    oAI := TADMoniAdapterInfo.Create(FOptions, AMessage);
    oCI.Trace('>> ' + Format(S_AD_MoniAdapterRegistered, [oAI.Path]), GetTickCount());
    oCI.AddAdapterInfo(oAI);
    if FActiveClient = oCI then
      oAI.InsertIntoTree(ADMoniObjectsFrm.tvAdapters);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.BuildAdaptersTree(AClientInfo: TADMoniClientInfo);
var
  i: Integer;
begin
  with ADMoniObjectsFrm do begin
    tvAdapters.Items.BeginUpdate;
    try
      tvAdapters.Items.Clear;
      for i := 0 to AClientInfo.AdapterCount - 1 do
        AClientInfo.Adapters[i].InsertIntoTree(tvAdapters);
    finally
      tvAdapters.Items.EndUpdate;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.ProcessUnRegisterAdapter(AMessage: TADMoniIndyServerQueueItem);
var
  oCI: TADMoniClientInfo;
  oAI: TADMoniAdapterInfo;
begin
  oCI := GetClientInfo(AMessage);
  if oCI <> nil then begin
    oAI := oCI.GetAdapterInfo(AMessage);
    if oAI <> nil then begin
      oCI.Trace('>> ' + Format(S_AD_MoniAdapterUnregistered, [oAI.Path]), GetTickCount());
      if FActiveClient = oCI then
        oAI.RemoveFromTree(ADMoniObjectsFrm.tvAdapters);
      oCI.RemoveAdapterInfo(oAI);
      oAI.Free;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.tvAdaptersChange(Sender: TObject; Node: TTreeNode);
var
  oAI: TADMoniAdapterInfo;
begin
  with ADMoniObjectsFrm do begin
    lvStat.Items.BeginUpdate;
    mmSQL.Lines.BeginUpdate;
    lvParams.Items.BeginUpdate;
    try
      lvStat.Items.Clear;
      mmSQL.Lines.Clear;
      lvParams.Items.Clear;
      if (Node <> nil) and (Node.Data <> nil) then begin
        oAI := TADMoniAdapterInfo(Node.Data);
        oAI.ShowStat(lvStat, mmSQL, lvParams);
      end;
    finally
      lvStat.Items.EndUpdate;
      mmSQL.Lines.EndUpdate;
      lvParams.Items.EndUpdate;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniMainFrm.ProcessUpdateAdapter(AMessage: TADMoniIndyServerQueueItem);
var
  oCI: TADMoniClientInfo;
  oAI: TADMoniAdapterInfo;
  oSelNode: TTreeNode;
begin
  oCI := GetClientInfo(AMessage);
  if oCI <> nil then begin
    oAI := oCI.GetAdapterInfo(AMessage);
    if oAI <> nil then begin
      oAI.UpdateState(AMessage);
      if (FActiveClient = oCI) and not (csDestroying in ComponentState) then begin
        oSelNode := ADMoniObjectsFrm.tvAdapters.Selected;
        if (oSelNode <> nil) and (oSelNode.Data <> nil) and (TADMoniAdapterInfo(oSelNode.Data) = oAI) then
          tvAdaptersChange(ADMoniObjectsFrm.tvAdapters, oSelNode);
      end;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
{ Notifications }

procedure TADMoniMainFrm.ProcessNotify(AMessage: TADMoniIndyServerQueueItem);
var
  oCI: TADMoniClientInfo;
begin
  Inc(FProcessedMessages);
  oCI := GetClientInfo(AMessage);
  if oCI <> nil then
    with AMessage do
      oCI.Notify(oCI.FLevel, FKind, FStep, FTime, FPath, FMessage, GetArgs);
end;

end.
