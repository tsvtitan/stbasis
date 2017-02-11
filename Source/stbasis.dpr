program stbasis;

{$I stbasis.inc}
{$D 'stbasis by TSV'}
//{$WARNINGS OFF}
//{$HINTS OFF}
{%File 'stbasis.inc'}
{$R 'United\WindowsXP.res' 'United\WindowsXP.rc'}

uses
  Windows,
  Forms,
  Dialogs,
  SysUtils,
  controls,
  classes,
  UMainUnited in 'United\UMainUnited.pas',
  tsvHint in 'United\tsvHint.pas',
  Marquee in 'Main\Marquee.pas',
  UMain in 'Main\UMain.pas' {fmMain},
  UMainData in 'Main\UMainData.pas',
  UAbout in 'Main\UAbout.pas' {fmAbout},
  USplash in 'Main\USplash.pas' {fmSplash},
  UServerConnect in 'Main\UServerConnect.pas' {fmServerConnect},
  ULogin in 'Main\ULogin.pas' {fmLogin},
  UMainCode in 'Main\UMainCode.pas',
  TsvGauge in 'Main\tsvGauge.pas',
  UOptions in 'Main\UOptions.pas' {fmOptions},
  UEnterPeriod in 'Main\UEnterPeriod.pas' {fmEnterPeriod},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  UChangePassword in 'Main\UChangePassword.pas' {fmChangePass},
  XPMenu in 'United\XPMenu.pas',
  tsvPathUtils in 'United\tsvPathUtils.pas',
  tsvColorBox in 'United\tsvColorBox.pas',
  tsvFontBox in 'United\tsvFontBox.pas',
  UMainOptions in 'Main\UMainOptions.pas' {fmMainOptions},
  tsvPicture in 'United\tsvPicture.pas',
  ULog in 'Main\ULog.pas' {fmLog},
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBConsts in 'Main\URBConsts.pas' {fmRBConst},
  UEditRBConsts in 'Main\UEditRBConsts.pas' {fmEditRBConsts},
  URBQuery in 'Main\URBQuery.pas' {fmRBQuery},
  tsvInterbase in 'United\tsvInterbase.pas',
  tsvLogControls in 'Main\tsvLogControls.pas',
  USrvMain in 'United\USrvMain.pas' {fmSrvMain},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  URptMain in 'United\URptMain.pas' {fmRptMain},
  UJRMainGrid in 'United\UJRMainGrid.pas' {fmJRMainGrid},
  UDocMainGrid in 'United\UDocMainGrid.pas' {fmDocMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  UMainForm in 'United\UMainForm.pas' {fmMainForm},
  tsvInterpreterCore in 'United\tsvInterpreterCore.pas',
  tsvDesignCore in 'United\tsvDesignCore.pas',
  URBMainTreeViewEx in 'United\URBMainTreeViewEx.pas' {fmRBMainTreeViewEx},
  XPMan in 'United\XPMan.pas',
  tsvLog in 'Main\tsvLog.pas',
  ULoginDb in 'Main\ULoginDb.pas' {fmLoginDb};

{$R *.res}

var
  FlagPack: Boolean;
  IsExit: Boolean;
begin
  Application.Initialize;
  UpdateNeedLibSecurity;
  SwitchParams(IsExit);
  if IsExit then
    exit;
  Randomize;
  HintWindowClass:=THintWindowClass(TNewHintWindow);
  Application.ShowHint:=false;
  Application.ShowHint:=true;
  try
    if not InitAll then exit;
    if not isCorrectApplicationExeName then exit;
  
    MessageID := RegisterWindowMessage(Pchar(STBasisMutex));
    FlagPack:=LoadPackInfo;
    if not FlagPack then begin
      LoadConnectInfo;
      if CheckMoreApplications and
         not MoreApplications then exit;
    end;  
    Screen.Cursor:=crHourGlass;
    fmSplash:=TfmSplash.Create(nil);
    try
     fmSplash.Caption:=MainCaption;
     SetSplashStatus_('-----------------------------------------------------------------------');
     SetSplashStatus_(ConstSplashStatusServerSearch);
     if not ServerFound then exit;
     SetSplashStatus_(ConstSplashStatusServerConnect);
     if not LoginToProgram then exit;
     MainLoadFromIni;
     MainLog.Init(LogFileName);
     fmSplash.Visible:=false;
     SetSplashImage(fmSplash);
     fmSplash.Visible:=isVisibleSplash;
     fmSplash.lbVersion.Visible:=isVisibleSplashVerison;
     fmSplash.lbStatus.Visible:=isVisibleSplashStatus;
     fmSplash.Caption:=MainCaption;
     SetSplashStatus_(ConstSplashStatusLoading);
     Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmOptions, fmOptions);
  Application.CreateForm(TfmMainOptions, fmMainOptions);
  Application.CreateForm(TfmLog, fmLog);
  SetLoadingSQLMonitorOptions;
     AddToListInterfaces;
     AddToListMenusRoot;
     AddToListToolBars;
     AddToListOptionsRoot;
     AddToListDesignPropertyRemoves;
     AddToListInterpreterVars;

     LoadNeedLib;
     PrepearMenus;
     PrepearToolBars;

     SetSplashStatus_(ConstOpenLastEntry);
     SaveConnectInfo;
     MainLoadFromIniAfterCreateAll;
     RunInterfacesWhereAutoRunTrue;
     RunInterfacesByListRunInterfaces;

     if not isSwitchPackFile then begin
       fmMain.InitApplicationEvents;
       fmMain.WindowState:=tmpBounds.State;
       if fmMain.WindowState<>wsMaximized then
         fmMain.SetBounds(tmpBounds.Left,tmpBounds.Top,tmpBounds.Width,tmpBounds.Height);
     end;

    finally
     FreeAndNil(fmSplash);
     Screen.Cursor:=crDefault;
    end;
    isAppLoaded:=true;
    if not isSwitchPackFile then
      Application.Run
    else fmMain.Close;
    DeInitAll;
    if MutexHan<>0 then CloseHandle(MutexHan);
  finally
  end;
end.
