unit ULog;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ImgList, Menus, Tabs, tsvLogControls;

type
  TfmLog = class(TForm)
    pm: TPopupMenu;
    miDelete: TMenuItem;
    miView: TMenuItem;
    N1: TMenuItem;
    miClear: TMenuItem;
    N2: TMenuItem;
    miOption: TMenuItem;
    miSave: TMenuItem;
    sd: TSaveDialog;
    miCopy: TMenuItem;
    il: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure LVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LVDblClick(Sender: TObject);
    procedure miOptionClick(Sender: TObject);
    procedure miClearClick(Sender: TObject);
    procedure pmPopup(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miViewClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure ViewLogItem;
    procedure LoadFromIni;
    procedure SaveToFile(FileName: string);
    procedure LogsLogTabChange(Sender: TObject; NewTab: Integer);
  public
    Logs: TtsvLogs;
//    MainLog: TtsvLogsItem;
    procedure SaveToIni;
    function GetCurrentLogsItem: TTsvLogsItem;
    procedure ShowOrHideMainLog;
  end;

var
  fmLog: TfmLog;
  liFree: TListItem;

implementation

uses UMain, extctrls, UMainData, UMainUnited, UMainCode, 
  UMainOptions;

{$R *.DFM}

procedure TfmLog.FormCreate(Sender: TObject);
var
  TCAL: TCreateAdditionalLog;
begin
  AssignFont(_GetOptions.FormFont,Font);
  Height:=80;
  Logs:=TtsvLogs.Create(nil);
  Logs.Parent:=Self;
  Logs.Align:=alClient;
  Logs.Images:=fmMainOptions.ilLog;
  Logs.LogPopupMenu:=pm;
  Logs.LogKeyDown:=LVKeyDown;
  Logs.LogDblClick:=LVDblClick;
  Logs.LogTabChange:=LogsLogTabChange;
  TCAL.Name:=ConstCaptionMainLog;
  TCAL.Hint:=ConstMainLogHint;
  TCAL.Limit:=0;
  TCAL.ViewAdditionalLogOptionProc:=ViewAdditionalLogOptionProc;
  hAdditionalLogMain:=CreateAdditionalLog_(@TCAL);
  Logs.ItemIndex:=0;

  LoadFromIni;
{  ManualDock(fmMain.pnBottomDock);
  fmMain.SetUndockBounds(fmMain.pnBottomDock);}
 { Visible:=true;
  Update;}
end;

procedure TfmLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  VisibleLog:=false;
  if HostDockSite<>nil then begin
    fmMain.ShowDockPanel(TPanel(HostDockSite), false, Self);
  end;
end;

procedure TfmLog.FormShow(Sender: TObject);
begin
 { if HostDockSite<>nil then
     fmMain.ShowDockPanel(TPanel(HostDockSite), true, Self);      }
end;

procedure TfmLog.ViewLogItem;
var
  P: PInfoAdditionalLogItem;
  logsitem: TtsvLogsItem;
  logitem: TtsvLogItem;
begin
  if logs.ItemIndex<>-1 then begin
   logsitem:=logs.Items.Items[logs.ItemIndex];
   if logsitem.ItemIndex<>-1 then begin
    logitem:=logsitem.Items.Items[logsitem.ItemIndex];
    P:=logitem.Data;
    if P=nil then exit;
    if isValidPointer(@P.ViewAdditionalLogItemProc) then
     P.ViewAdditionalLogItemProc(P.Owner,THandle(P));
   end;
  end;
end;

procedure TfmLog.LVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key=VK_RETURN then ViewLogItem;
   if Key=VK_DELETE then miDeleteClick(nil);
   if Shift=[ssCtrl] then
    if (Key=VK_INSERT) then miCopyClick(nil);
end;

procedure TfmLog.LVDblClick(Sender: TObject);
begin
  ViewLogItem;
end;

procedure TfmLog.miOptionClick(Sender: TObject);
var
  LogsItem: TTsvLogsItem;
  PLog: PInfoAdditionalLog;
begin
  LogsItem:=GetCurrentLogsItem;
  if LogsItem=nil then exit;
  PLog:=LogsItem.Data;
  if PLog=nil then exit;
  if not isValidPointer(@PLog.ViewAdditionalLogOptionProc) then exit;
  PLog.ViewAdditionalLogOptionProc(THandle(PLog));
end;

procedure TfmLog.miClearClick(Sender: TObject);
var
  LogsItem: TTsvLogsItem;
begin
  LogsItem:=GetCurrentLogsItem;
  if LogsItem=nil then exit;
  ClearAdditionalLog_(THandle(LogsItem.Data));
end;

procedure TfmLog.pmPopup(Sender: TObject);
var
  P: PInfoAdditionalLogItem;
  PLog: PInfoAdditionalLog;
begin
  miDelete.Enabled:=false;
  miView.Enabled:=false;
  miClear.Enabled:=false;
  miCopy.Enabled:=false;
  miSave.Enabled:=false;
  miOption.Enabled:=false;
  if Logs.ItemIndex=-1 then exit;
  miClear.Enabled:=Logs.Items.Items[Logs.ItemIndex].Items.Count>0;
  miSave.Enabled:=miClear.Enabled;
  PLog:=Logs.Items.Items[Logs.ItemIndex].Data;
  miOption.Enabled:=@PLog.ViewAdditionalLogOptionProc<>nil;
  if Logs.Items.Items[Logs.ItemIndex].ItemIndex=-1 then exit;
  miCopy.Enabled:=Logs.Items.Items[Logs.ItemIndex].SelCount>0;
  P:=Logs.Items.Items[Logs.ItemIndex].Items.Items[Logs.Items.Items[Logs.ItemIndex].ItemIndex].Data;
  miView.Enabled:=@P.ViewAdditionalLogItemProc<>nil;
  miDelete.Enabled:=true;
end;

function TfmLog.GetCurrentLogsItem: TTsvLogsItem;
begin
  Result:=nil;
  if Logs.ItemIndex=-1 then exit;
  Result:=Logs.Items.Items[Logs.ItemIndex];
end;

procedure TfmLog.miDeleteClick(Sender: TObject);
var
  i: Integer;
  P: PInfoAdditionalLogItem;
  LogsItem: TTsvLogsItem;
  LogItem: TtsvLogItem;
begin
 LogsItem:=GetCurrentLogsItem;
 if LogsItem=nil then exit;
 Screen.Cursor:=crHourGlass;
 LogsItem.Items.BeginUpdate;
 try
  for i:=LogsItem.Items.Count-1 downto 0 do begin
    LogItem:=LogsItem.Items.Items[i];
    if LogItem.Selected then
     if LogItem.Data<>nil then begin
      P:=LogItem.Data;
      FreeLogItem_(THandle(P));
     end;
  end;
  LogsItem.Invalidate;
 finally
   LogsItem.Items.EndUpdate;
   Screen.Cursor:=crDefault;
 end;
end;

procedure TfmLog.miViewClick(Sender: TObject);
begin
  ViewLogItem;
end;

procedure TfmLog.LoadFromIni;
var
  TSPAL: TSetParamsToAdditionalLog;
begin
  try
    isLogChecked[0]:=ReadParam(ConstSectionLog,'isWarning',isLogChecked[0]);
    isLogChecked[1]:=ReadParam(ConstSectionLog,'isError',isLogChecked[1]);
    isLogChecked[2]:=ReadParam(ConstSectionLog,'isInformation',isLogChecked[2]);
    isLogChecked[3]:=ReadParam(ConstSectionLog,'isConfirmation',isLogChecked[3]);

    if ReadParam(ConstSectionLog,'LogStayOnTop',false) then fmLog.FormStyle:=fsStayOnTop
    else fmLog.FormStyle:=fsNormal;
    if ReadParam(ConstSectionLog,'Position',0)=0 then begin

    end else begin
      ManualDock(fmMain.pnBottomDock);
      fmMain.ShowDockPanel(TPanel(HostDockSite), false, Self);
    end;
    Left:=ReadParam(ConstSectionLog,'Left',Left);
    Top:=ReadParam(ConstSectionLog,'Top',Top);
    Width:=ReadParam(ConstSectionLog,'Width',Width);
    Height:=ReadParam(ConstSectionLog,'Height',Height);

    isLogShowDateTime:=ReadParam(ConstSectionLog,'ShowDateTime',isLogShowDateTime);

    fmMainOptions.udLogLimit.Position:=ReadParam(ConstSectionLog,fmMainOptions.udLogLimit.Name,fmMainOptions.udLogLimit.Position);
    TSPAL.Limit:=fmMainOptions.udLogLimit.Position;
    SetParamsToAdditionalLog_(THandle(ListAdditionalLogs.Items[0]),@TSPAL);

  except
    {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmLog.SaveToIni;
begin
 try
    WriteParam(ConstSectionLog,'isWarning',isLogChecked[0]);
    WriteParam(ConstSectionLog,'isError',isLogChecked[1]);
    WriteParam(ConstSectionLog,'isInformation',isLogChecked[2]);
    WriteParam(ConstSectionLog,'isConfirmation',isLogChecked[3]);

    WriteParam(ConstSectionLog,'LogStayOnTop',fmLog.FormStyle=fsStayOnTop);
    if HostDockSite=nil then WriteParam(ConstSectionLog,'Position',0)
    else WriteParam(ConstSectionLog,'Position',1);
    WriteParam(ConstSectionLog,'Left',Left);
    WriteParam(ConstSectionLog,'Top',Top);
    WriteParam(ConstSectionLog,'Width',Width);
    WriteParam(ConstSectionLog,'Height',Height);

    WriteParam(ConstSectionLog,'ShowDateTime',isLogShowDateTime);

    WriteParam(ConstSectionLog,fmMainOptions.udLogLimit.Name,fmMainOptions.udLogLimit.Position);

    
 except
  {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;
end;


procedure TfmLog.miSaveClick(Sender: TObject);
begin
  if sd.Execute then begin
    try
      SaveToFile(sd.FileName);
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
  end;
end;

procedure TfmLog.SaveToFile(FileName: string);
begin
  Screen.Cursor:=crHourGlass;
  try
   if Logs.ItemIndex<>-1 then begin
     Logs.Items.Items[Logs.ItemIndex].SaveToFileAsText(FileName);
   end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmLog.FormDestroy(Sender: TObject);
begin
  FreeAdditionalLog_(hAdditionalLogMain);
  Logs.Free;
end;

procedure TfmLog.ShowOrHideMainLog;
var
  i,j: Integer;
  MainLog: TtsvlogsItem;
begin
  if Logs.Items.Count=0 then exit; 
  MainLog:=Logs.Items.Items[0];
  for i:=0 to MainLog.Items.Count-1 do begin
    for j:=0 to MainLog.Items.Items[i].Captions.Count-1 do
      if j=1 then
        MainLog.Items.Items[i].Captions.Items[j].Visible:=isLogShowDateTime;
  end;
end;

procedure TfmLog.miCopyClick(Sender: TObject);
begin
  if Logs.ItemIndex<>-1 then begin
    Logs.Items.Items[Logs.ItemIndex].CopyToClipboard;
  end;
end;

procedure TfmLog.LogsLogTabChange(Sender: TObject; NewTab: Integer);
var
  h: THandle;
begin
  if Logs.ItemIndex<>-1 then begin
    h:=GetAdditionalLogHandleByLogIndex(NewTab);
    if not isValidAdditionalLog_(h) then hAdditionalLogLast:=hAdditionalLogMain
    else hAdditionalLogLast:=h;
  end;
end;

procedure TfmLog.FormResize(Sender: TObject);
begin
  fmMain.SetLogoPosition(false);
  fmMain.SetLogoPosition(true);
end;

end.