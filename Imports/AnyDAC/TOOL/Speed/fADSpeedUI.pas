{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - main form                                             }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ADSpeed.inc}

unit fADSpeedUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, Grids, StdCtrls, Db, ActnList, ImgList, Menus, ToolWin,
  ADSpeedBase,
  daADGUIxFormsControls;

const
  WM_ADSpeed_AfterStartup = WM_USER + 1000;

type
  {---------------------------------------------------------------------------}
  { TADSpeedUIFrm                                                             }
  {---------------------------------------------------------------------------}
  TADSpeedUIFrm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SaveDialog1: TSaveDialog;
    ActionList1: TActionList;
    actTestRunSingle: TAction;
    actTestRunDS: TAction;
    actTestRunTest: TAction;
    actTestRunAll: TAction;
    actLogExport: TAction;
    MainMenu1: TMainMenu;
    est1: TMenuItem;
    Log1: TMenuItem;
    Help1: TMenuItem;
    Images: TImageList;
    RunSingle1: TMenuItem;
    RunDS1: TMenuItem;
    RunTest1: TMenuItem;
    RunAll1: TMenuItem;
    N1: TMenuItem;
    Export1: TMenuItem;
    actTestExit: TAction;
    actTestExit1: TMenuItem;
    N2: TMenuItem;
    actLogShowErrors: TAction;
    ShowErrors1: TMenuItem;
    stbDown: TStatusBar;
    actHelpAbout: TAction;
    About1: TMenuItem;
    pnlTopFrame: TADGUIxFormsPanel;
    pnlToolbar: TADGUIxFormsPanel;
    ToolBar: TToolBar;
    ToolButton11: TToolButton;
    btnTestRun: TToolButton;
    btnTestStop: TToolButton;
    ToolButton9: TToolButton;
    Panel6: TADGUIxFormsPanel;
    lvTests: TListView;
    Panel7: TADGUIxFormsPanel;
    Label2: TLabel;
    Panel8: TADGUIxFormsPanel;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Panel3: TADGUIxFormsPanel;
    ToolButton6: TToolButton;
    TabSheet2: TTabSheet;
    Panel2: TADGUIxFormsPanel;
    grdResults: TStringGrid;
    Panel9: TADGUIxFormsPanel;
    ToolButton7: TToolButton;
    actTestStop: TAction;
    Stop1: TMenuItem;
    ProgressBar1: TProgressBar;
    Bevel1: TBevel;
    TabSheet3: TTabSheet;
    Panel4: TADGUIxFormsPanel;
    Panel1: TADGUIxFormsPanel;
    Label1: TLabel;
    Panel5: TADGUIxFormsPanel;
    lvDSs: TListView;
    actLogImport: TAction;
    Import1: TMenuItem;
    ToolButton5: TToolButton;
    OpenDialog1: TOpenDialog;
    actLogClear: TAction;
    Clear1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRunAllClick(Sender: TObject);
    procedure grdResultsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const AValue: String);
    procedure actLogExportExecute(Sender: TObject);
    procedure btnRunDSClick(Sender: TObject);
    procedure btnRunTestClick(Sender: TObject);
    procedure btnRunSingleClick(Sender: TObject);
    procedure actTestRunSingleUpdate(Sender: TObject);
    procedure actOtherUpdate(Sender: TObject);
    procedure actTestRunDSUpdate(Sender: TObject);
    procedure actTestRunTestUpdate(Sender: TObject);
    procedure actTestExitExecute(Sender: TObject);
    procedure actLogShowErrorsUpdate(Sender: TObject);
    procedure actLogShowErrorsExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure actTestStopUpdate(Sender: TObject);
    procedure actTestStopExecute(Sender: TObject);
    procedure actTestRunAllUpdate(Sender: TObject);
    procedure grdResultsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure WMAfterStartup(var Message: TMessage); message WM_ADSpeed_AfterStartup;
    procedure actLogImportExecute(Sender: TObject);
    procedure actLogClearExecute(Sender: TObject);
  protected
    FMgr: TADSpeedTestManager;
    FShowErrors: Boolean;
    procedure LoadRegInfo;
    procedure LoadTestsInfo;
    procedure LoadTestsResults(ADSInd, ATestInd: Integer);
    procedure ClearTestsResults(ADSInd, ATestInd: Integer);
    procedure ExportTestResults(const AFileName: String);
    procedure ImportTestResults(const AFileName: String);
    procedure DoTestEnd(AManager: TADSpeedTestManager);
    procedure DoTestProgress(AManager: TADSpeedTestManager;
      ATest: TADSpeedCustomDataSetTest; APctDone: Integer);
    procedure DoTestError(AManager: TADSpeedTestManager; E: Exception);
    procedure DoTestStart(AManager: TADSpeedTestManager);
    procedure DoAfterTest(AManager: TADSpeedTestManager; ADSInd, ATestInd: Integer);
    procedure DoBeforeTest(AManager: TADSpeedTestManager; ADSInd, ATestInd: Integer);
  end;

var
  ADSpeedUIFrm: TADSpeedUIFrm;

implementation

{$R *.DFM}

uses
  daADStanUtil, daADStanConst, daADStanIntf, daADStanFactory, daADGUIxFormsfAbout;

{---------------------------------------------------------------------------}
{ TADSpeedUIFrm                                                             }
{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.FormCreate(Sender: TObject);
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
  FMgr := ADSpeedRegister();
  FMgr.OnStart := DoTestStart;
  FMgr.OnProgress := DoTestProgress;
  FMgr.OnError := DoTestError;
  FMgr.OnEnd := DoTestEnd;
  FMgr.BeforeTest := DoBeforeTest;
  FMgr.AfterTest := DoAfterTest;
  FMgr.AllocTests;
  LoadRegInfo;
  LoadTestsInfo;
  PostMessage(Handle, WM_ADSpeed_AfterStartup, 0, 0);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.WMAfterStartup(var Message: TMessage);
begin
  grdResults.Col := StrToInt(ADGetCmdParam('C', '2')) - 1;
  grdResults.Row := StrToInt(ADGetCmdParam('R', '2')) - 1;
  if ADGetCmdParam('S', '') = '1' then
    btnRunSingleClick(nil)
  else if ADGetCmdParam('D', '') = '1' then
    btnRunDSClick(nil)
  else if ADGetCmdParam('T', '') = '1' then
    btnRunTestClick(nil)
  else if ADGetCmdParam('A', '') = '1' then
    btnRunAllClick(nil);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.FormDestroy(Sender: TObject);
begin
  ADSpeedUnRegister;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.FormResize(Sender: TObject);
begin
  with stbDown do
    Panels[0].Width := Width - (Panels[1].Width + Panels[2].Width);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.DoTestStart(AManager: TADSpeedTestManager);
begin
  if Visible then begin
    ProgressBar1.Position := 0;
    stbDown.Panels[0].Text := 'Starting ...';
    Application.ProcessMessages;
    Application.HandleMessage;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.DoTestProgress(AManager: TADSpeedTestManager;
  ATest: TADSpeedCustomDataSetTest; APctDone: Integer);
var
  s: String;
begin
  if Visible then begin
    ProgressBar1.Position := APctDone;
    s := 'Done %' + IntToStr(APctDone);
    if ATest <> nil then begin
      if ATest.TestingDataSet <> nil then
        s := s + '; ' + ATest.TestingDataSet.GetName;
      s := s + '; ' + ATest.GetName;
    end;
    stbDown.Panels[0].Text := s;
    Application.ProcessMessages;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.DoTestError(AManager: TADSpeedTestManager; E: Exception);
begin
  if FShowErrors then
{$IFDEF VER140}
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self);
{$ELSE}
    Application.HandleException(nil);
{$ENDIF}
  stbDown.Panels[0].Text := 'Error !';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.DoTestEnd(AManager: TADSpeedTestManager);
begin
  if Visible then begin
    ProgressBar1.Position := 100;
    stbDown.Panels[0].Text := 'Finishing ...';
    Sleep(500);
    ProgressBar1.Position := 0;
    stbDown.Panels[0].Text := '';
    Application.ProcessMessages;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.DoBeforeTest(AManager: TADSpeedTestManager;
  ADSInd, ATestInd: Integer);
begin
  ClearTestsResults(ADSInd, ATestInd);
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.DoAfterTest(AManager: TADSpeedTestManager;
  ADSInd, ATestInd: Integer);
begin
  LoadTestsResults(ADSInd, ATestInd);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.LoadRegInfo;
var
  i: Integer;
begin
  with lvTests do
    for i := 0 to FMgr.TestCount - 1 do
      with Items.Add do begin
        Caption := FMgr.TestClass[i].GetName;
        SubItems.Add(FMgr.TestClass[i].GetDescription);
      end;
  with lvDSs do
    for i := 0 to FMgr.DSCount - 1 do
      with Items.Add do begin
        Caption := FMgr.DSClass[i].GetName;
        SubItems.Add(FMgr.DSClass[i].GetDescription);
      end;
  Application.ProcessMessages;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.LoadTestsInfo;
var
  i: Integer;
begin
  with grdResults do begin
    RowCount := FMgr.TestCount + 1;
    ColCount := FMgr.DSCount + 2;
    Cells[1, 0] := 'Times';
    for i := 0 to FMgr.TestCount - 1 do begin
      Cells[0, i + 1] := FMgr.TestClass[i].GetName;
      Cells[1, i + 1] := IntToStr(FMgr.TestTimes[i]);
    end;
    for i := 0 to FMgr.DSCount - 1 do
      Cells[i + 2, 0] := FMgr.DSClass[i].GetName;
  end;
  Application.ProcessMessages;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.ClearTestsResults(ADSInd, ATestInd: Integer);
var
  i, j, i1, i2, j1, j2: Integer;
begin
  if ATestInd = -1 then begin
    i1 := 0;
    i2 := FMgr.TestCount - 1;
  end
  else begin
    i1 := ATestInd;
    i2 := ATestInd;
  end;
  if ADSInd = -1 then begin
    j1 := 0;
    j2 := FMgr.DSCount - 1;
  end
  else begin
    j1 := ADSInd;
    j2 := ADSInd;
  end;
  with grdResults do begin
    for i := i1 to i2 do
      for j := j1 to j2 do begin
        Cells[j + 2, i + 1] := '';
        Objects[j + 2, i + 1] := nil;
      end;
  end;
  Application.ProcessMessages;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.LoadTestsResults(ADSInd, ATestInd: Integer);
const
  C_Large: Double = 999999999.0;
var
  i, j, i1, i2, j1, j2, i3: Integer;
  s: String;
  v, v1, v2, v3: Double;
begin
  if ATestInd = -1 then begin
    i1 := 0;
    i2 := FMgr.TestCount - 1;
  end
  else begin
    i1 := ATestInd;
    i2 := ATestInd;
  end;
  if ADSInd = -1 then begin
    j1 := 0;
    j2 := FMgr.DSCount - 1;
  end
  else begin
    j1 := ADSInd;
    j2 := ADSInd;
  end;
  with grdResults do begin
    for i := i1 to i2 do
      for j := j1 to j2 do begin
        if FMgr.Tests[j, i] = nil then
          s := '---'
        else
          s := FMgr.Tests[j, i].TimeStr;
        Cells[j + 2, i + 1] := s;
      end;
    for i := 1 to RowCount - 1 do begin
      v1 := C_Large;
      v2 := C_Large;
      v3 := C_Large;
      i1 := 0;
      i2 := 0;
      i3 := 0;
      for j := 2 to ColCount - 1 do
        Objects[j, i] := nil;
      for j := 2 to ColCount - 1 do
        if (Cells[j, i] <> '') and (Cells[j, i] <> '---') then begin
          v := StrToFloatDef(Cells[j, i], C_Large);
          if v < v1 then begin
            v1 := v;
            i1 := j;
          end;
        end;
      if i1 <> 0 then begin
        Objects[i1, i] := TObject(1);
        for j := 2 to ColCount - 1 do
          if (Cells[j, i] <> '') and (Cells[j, i] <> '---') then begin
            v := StrToFloatDef(Cells[j, i], C_Large);
            if (v < v2) and (v > v1) then begin
              v2 := v;
              i2 := j;
            end;
          end;
        if i2 <> 0 then begin
          Objects[i2, i] := TObject(2);
          for j := 2 to ColCount - 1 do
            if (Cells[j, i] <> '') and (Cells[j, i] <> '---') then begin
              v := StrToFloatDef(Cells[j, i], C_Large);
              if (v < v3) and (v > v2) then begin
                v3 := v;
                i3 := j;
              end;
            end;
          if i3 <> 0 then
            Objects[i3, i] := TObject(3);
        end;
      end;
    end;
  end;
  Application.ProcessMessages;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.ExportTestResults(const AFileName: String);
var
  oStr: TFileStream;
  i, j: Integer;
  s, sExt, sLine: String;

  procedure WriteStr(const AStr: String);
  begin
    if Length(AStr) > 0 then
      oStr.Write(AStr[1], Length(AStr));
    oStr.Write(C_AD_EOL[1], Length(C_AD_EOL));
  end;

  function Replace(const AStr: String; ASrc, ADest: String): String;
  var
    i: Integer;
  begin
    Result := AStr;
    while True do begin
      i := Pos(ASrc, Result);
      if i = 0 then
        Break;
      Delete(Result, i, Length(ASrc));
      Insert(ADest, Result, i);
    end;
  end;

begin
  oStr := TFileStream.Create(AFileName, fmCreate);
  try
    sExt := UpperCase(ExtractFileExt(AFileName));
    if (sExt = '.CSV') or (sExt = '.TXT') then begin
      sLine := 'Tests, Times';
      for j := 0 to FMgr.DSCount - 1 do
        sLine := sLine + ',' + Replace(FMgr.DSClass[j].GetName, ',', ';');
      WriteStr(sLine);
      for i := 0 to FMgr.TestCount - 1 do begin
        sLine := FMgr.TestClass[i].GetName + ',' + IntToStr(FMgr.TestTimes[i]);
        for j := 0 to FMgr.DSCount - 1 do begin
          if FMgr.Tests[j, i] = nil then
            s := '---'
          else
            s := Replace(FMgr.Tests[j, i].TimeStr, ',', '.');
          sLine := sLine + ',' + s;
        end;
        WriteStr(sLine);
      end;
    end
    else if sExt = '.XML' then begin
      WriteStr('<?xml version="1.0" standalone="yes"?>');
      WriteStr('<tests>');
      for i := 0 to FMgr.TestCount - 1 do begin
        WriteStr('  <test Name="' + FMgr.TestClass[i].GetName + '" Times="' + IntToStr(FMgr.TestTimes[i]) + '">');
        for j := 0 to FMgr.DSCount - 1 do begin
          if FMgr.Tests[j, i] = nil then
            s := '---'
          else
            s := FMgr.Tests[j, i].TimeStr;
          WriteStr('    <dataset Name="' + FMgr.DSClass[j].GetName + '" Time="' + s + '"/>');
        end;
        WriteStr('  </test>');
      end;
      WriteStr('</tests>');
    end;
  finally
    oStr.Free;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.ImportTestResults(const AFileName: String);
var
  sExt, sTst, sTimes, sRes: String;
  oLines: TStrings;
  rPFmt: TADParseFmtSettings;
  rFS: TFormatSettings;
  oDSs: TStrings;
  i, j, k, iTest, iDS: Integer;
begin
  sExt := UpperCase(ExtractFileExt(AFileName));
  if (sExt <> '.CSV') and (sExt <> '.TXT') then
    raise Exception.CreateFmt('File type [%s] is not supported', [sExt]);
  ClearTestsResults(-1, -1);
  FMgr.AllocTests;
  with rPFmt do begin
    FQuote1 := #0;
    FQuote2 := #0;
    FQuote := #0;
    FDelimiter := ',';
  end;
  with rFS do begin
    DecimalSeparator := '.';
  end;
  oLines := TStringList.Create;
  oDSs := TStringList.Create;
  try
    oLines.LoadFromFile(AFileName);
    j := 1;
    ADExtractFieldName(oLines[0], j, rPFmt);
    ADExtractFieldName(oLines[0], j, rPFmt);
    while j <= Length(oLines[0]) do
      oDSs.Add(ADExtractFieldName(oLines[0], j, rPFmt));
    for i := 1 to oLines.Count - 1 do begin
      j := 1;
      sTst := ADExtractFieldName(oLines[i], j, rPFmt);
      sTimes := ADExtractFieldName(oLines[i], j, rPFmt);
      iTest := FMgr.IndexOfTest(sTst);
      if iTest <> -1 then begin
        FMgr.TestTimes[iTest] := StrToInt(sTimes);
        k := 0;
        while j <= Length(oLines[i]) do begin
          sRes := ADExtractFieldName(oLines[i], j, rPFmt);
          if sRes <> '---' then begin
            iDS := FMgr.IndexOfDS(oDSs[k]);
            if (iDS <> -1) and (sRes <> '') then
              try
                FMgr.Tests[iDS, iTest].Time := StrToFloat(sRes, rFS);
              except
                FMgr.Tests[iDS, iTest].Error := sRes;
              end;
          end;
          Inc(k);
        end;
      end;
    end;
  finally
    oDSs.Free;
    oLines.Free;
  end;
  LoadTestsResults(-1, -1);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.grdResultsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const AValue: String);
begin
  if ACol = 1 then
    FMgr.TestTimes[ARow - 1] := StrToIntDef(AValue, 0);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.grdResultsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with grdResults do begin
    case Integer(Objects[ACol, ARow]) of
    0: ;
    1:
      begin
        Canvas.Brush.Color := clRed;
        Canvas.FillRect(Rect);
      end;
    2:
      begin
        Canvas.Brush.Color := clYellow;
        Canvas.FillRect(Rect);
      end;
    3:
      begin
        Canvas.Brush.Color := clGreen;
        Canvas.FillRect(Rect);
      end;
    end;
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actOtherUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not FMgr.IsRunning;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestRunSingleUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (grdResults.Col >= 2) and (grdResults.Row >= 1) and
    not FMgr.IsRunning and FMgr.IsValid;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.btnRunSingleClick(Sender: TObject);
var
  i, j: Integer;
begin
  i := grdResults.Col - 2;
  j := grdResults.Row - 1;
  ClearTestsResults(i, j);
  FMgr.Execute(FMgr.TestClass[j], FMgr.DSClass[i]);
  LoadTestsResults(i, j);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestRunAllUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not FMgr.IsRunning and FMgr.IsValid;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.btnRunAllClick(Sender: TObject);
begin
  ClearTestsResults(-1, -1);
  FMgr.Execute(nil, nil);
  LoadTestsResults(-1, -1);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestRunDSUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (grdResults.Col >= 2) and not FMgr.IsRunning and
    FMgr.IsValid;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.btnRunDSClick(Sender: TObject);
var
  i: Integer;
begin
  if PageControl1.ActivePageIndex = 0 then
    i := lvDSs.ItemIndex
  else
    i := grdResults.Col - 2;
  ClearTestsResults(i, -1);
  FMgr.Execute(nil, FMgr.DSClass[i]);
  LoadTestsResults(i, -1);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestRunTestUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (grdResults.Row >= 1) and not FMgr.IsRunning and
    FMgr.IsValid;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.btnRunTestClick(Sender: TObject);
var
  i: Integer;
begin
  if PageControl1.ActivePageIndex = 0 then
    i := lvTests.ItemIndex
  else
    i := grdResults.Row - 1;
  ClearTestsResults(-1, i);
  FMgr.Execute(FMgr.TestClass[i], nil);
  LoadTestsResults(-1, i);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestStopUpdate(Sender: TObject);
begin
  actTestStop.Enabled := FMgr.IsRunning;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestStopExecute(Sender: TObject);
begin
  FMgr.Cancel;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actTestExitExecute(Sender: TObject);
begin
  Close;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actLogExportExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    ExportTestResults(SaveDialog1.FileName);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actLogImportExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ImportTestResults(OpenDialog1.FileName);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actLogClearExecute(Sender: TObject);
begin
  FMgr.ClearTests;
  FMgr.AllocTests;
  LoadTestsResults(-1, -1);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actLogShowErrorsUpdate(Sender: TObject);
begin
  actLogShowErrors.Checked := FShowErrors;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actLogShowErrorsExecute(Sender: TObject);
begin
  FShowErrors := not FShowErrors;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIFrm.actHelpAboutExecute(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute;
end;

end.
