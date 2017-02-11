library annfree;

{$I stbasis.inc}     

{%File 'stbasis.inc'}
{%File 'Ancement\RX.INC'}

uses
  SysUtils,
  Classes,
  Windows,
  UAncementCode in 'Ancement\UAncementCode.pas',
  UAncementData in 'Ancement\UAncementData.pas',
  UAncementDM in 'Ancement\UAncementDM.pas',
  UAncementOptions in 'Ancement\UAncementOptions.pas' {fmOptions},
  UMainUnited in 'United\UMainUnited.pas',
  tsvDbGrid in 'United\tsvDbGrid.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  URBRelease in 'Ancement\URBRelease.pas' {fmRBRelease},
  UEditRBRelease in 'Ancement\UEditRBRelease.pas' {fmEditRBRelease},
  URBBlackList in 'Ancement\URBBlackList.pas' {fmRBBlackList},
  UEditRBBlackList in 'Ancement\UEditRBBlackList.pas' {fmEditRBBlackList},
  URBTreeHeading in 'Ancement\URBTreeHeading.pas' {fmRBTreeHeading},
  UEditRBTreeHeading in 'Ancement\UEditRBTreeHeading.pas' {fmEditRBTreeheading},
  URBKeyWords in 'Ancement\URBKeyWords.pas' {fmRBKeyWords},
  UEditRBKeyWords in 'Ancement\UEditRBKeyWords.pas' {fmEditRBKeyWords},
  URBAnnouncement in 'Ancement\URBAnnouncement.pas' {fmRBAnnouncement},
  UEditRBAnnouncement in 'Ancement\UEditRBAnnouncement.pas' {fmEditRBAnnouncement},
  URptExport in 'Ancement\URptExport.pas' {fmRptExport},
  URBAnnouncementDubl in 'Ancement\URBAnnouncementDubl.pas' {fmRBAnnouncementDubl},
  UEditRBAnnouncementDubl in 'Ancement\UEditRBAnnouncementDubl.pas' {fmEditRBAnnouncementDubl},
  RxRichEd in 'Ancement\RxRichEd.pas',
  MaxMin in 'Ancement\MAXMIN.PAS',
  tsvRTFStream in 'Ancement\tsvRTFStream.pas',
  RxMemDS in 'Ancement\RxMemDS.pas',
  URptThread in 'United\URptThread.pas',
  USrvMain in 'United\USrvMain.pas' {fmSrvMain},
  USrvImport in 'Ancement\USrvImport.pas' {fmSrvImport},
  StrUtils in 'United\StrUtils.pas',
  URBRusWords in 'Ancement\URBRusWords.pas' {fmRBRusWords},
  UEditRBRusWords in 'Ancement\UEditRBRusWords.pas' {fmEditRBRusWords},
  tsvInterbase in 'United\tsvInterbase.pas',
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  URptTreeHeading in 'Ancement\URptTreeHeading.pas' {fmRptTreeHeading},
  URBMainTreeViewEx in 'United\URBMainTreeViewEx.pas' {fmRBMainTreeViewEx},
  tsvTVNavigator in 'United\tsvTVNavigator.pas',
  tsvStdCtrls in 'United\tsvStdCtrls.pas',
  URBAnnStreet in 'Ancement\URBAnnStreet.pas' {fmRBAnnStreet},
  UEditRBAnnStreet in 'Ancement\UEditRBAnnStreet.pas' {fmEditRBAnnStreet},
  URBAnnStreetTree in 'Ancement\URBAnnStreetTree.pas' {fmRBAnnStreetTree},
  UEditRBAnnStreetTree in 'Ancement\UEditRBAnnStreetTree.pas' {fmEditRBAnnStreetTree},
  URBAutoReplace in 'Ancement\URBAutoReplace.pas' {fmRBAutoReplace},
  UEditRBAutoReplace in 'Ancement\UEditRBAutoReplace.pas' {fmEditRBAutoReplace},
  URBPublishing in 'Ancement\URBPublishing.pas' {fmRBPublishing},
  UEditRBPublishing in 'Ancement\UEditRBPublishing.pas' {fmEditRBPublishing},
  rmLibrary in 'Ancement\rmLibrary.pas';

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
    //  InitAll;
    end;
    DLL_PROCESS_DETACH: begin
      DeInitAll;
    end;
  end;
end;

exports
  GetInfoLibrary_ name ConstGetInfoLibrary,
  RefreshLibrary_ name ConstRefreshLibrary,
  SetConnection_ name ConstSetConnection,
  InitAll_ name ConstInitAll;

{$R *.RES}
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

