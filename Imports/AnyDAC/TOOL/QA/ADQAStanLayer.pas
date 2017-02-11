{-------------------------------------------------------------------------------}
{ AnyDAC Stan Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAStanLayer;

interface

uses
  Classes, Windows, SysUtils,
  ADQAPack,
  daADGUIxIntf;

type
  TADQAStanTsHolder = class (TADQATsHolderBase)
  public
    procedure RegisterTests; override;
    procedure ClearAfterTest; override;
    procedure TestConnectionDef;
{$IFDEF AnyDAC_MONITOR}
    procedure TestFlatFileMonitoring;
    procedure TestIndyMonitoring;
{$ENDIF}
  end;


implementation

uses
  ShellAPI, IniFiles, Registry, Dialogs, Controls, Forms,
  ADQAConst, ADQAUtils, ADQAfMain,
  daADStanIntf, daADStanUtil, daADStanConst, daADStanDef, daADStanFactory,
{$IFDEF AnyDAC_MONITOR}
    daADMoniIndyClient, daADMoniFlatFile,
{$ENDIF}
  daADDatSManager,
  daADPhysIntf;

{-------------------------------------------------------------------------------}
{ TADQAStanTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQAStanTsHolder.RegisterTests;
begin
  RegisterTest('Connection definitions', TestConnectionDef, mkMSSQL);
{$IFDEF AnyDAC_MONITOR}
  RegisterTest('Monitoring;Indy',        TestIndyMonitoring, mkMSSQL);
  RegisterTest('Monitoring;FlatFile',    TestFlatFileMonitoring, mkMSSQL);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADQAStanTsHolder.TestConnectionDef;
var
  oConnectionDef, oConnectionDef2, oTmpDef: IADStanConnectionDef;
  lWasExcp: Boolean;
  oParamList: TStrings;
  oIni: TIniFile;
  oConnDefs: IADStanConnectionDefs;
  sTemp:  String;

  procedure ExtractParams(ASection: String);
  begin
    oIni.ReadSectionValues(ASection, oParamList);
  end;

  procedure TryFetch(AMaster: Boolean = False);
  var
    oCmd: IADPhysCommand;
    l: Boolean;
  begin
    l := False;
    FConnIntf.CreateCommand(oCmd);
    with oCmd do begin
      if not AMaster then
        Prepare('select * from {id Categories}')
      else
        Prepare('select * from {id systypes}');
      try
        Define(FTab);
        Open;
        Fetch(FTab);
      except
        l := True;
      end;
    end;
    if l then
      Error(ConnectToErrBase);
  end;

  procedure Cleanup;
  begin
    DeleteFile(ExtractFilePath(ParamStr(0)) + '\' + S_AD_DefCfgFileName);
    DeleteFile(ExtractFilePath(ParamStr(0)) + '\aaa.ini');
    DeleteFile(sTemp + 'aaa.ini');
  end;

begin
  Cleanup;
  oIni := TIniFile.Create(ADExpandStr('$(ADHOME)\DB\ADConnectionDefs.ini'));
  oParamList := TStringList.Create;
  try
    ExtractParams('MSSQL2000_Demo');
    if oParamList.Count = 0 then begin
      Error(ThereAreNoParInIni('MSSQL2000_Demo'));
      Exit;
    end;

    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    if not ADPhysManager.ConnectionDefs.Loaded then
      ADPhysManager.ConnectionDefs.Load;

    // add connection definition
    oConnectionDef := ADPhysManager.ConnectionDefs.AddConnectionDef;
    with oConnectionDef do begin
      Name := 'MyDef';
      DriverID := oParamList.Values['DriverID'];
      AsString['Server'] := oParamList.Values['Server'];
      Database := oParamList.Values['Database'];
      UserName := oParamList.Values['User_name'];
      Password := oParamList.Values['Password'];
      AsString['MetaDefSchema'] := oParamList.Values['MetaDefSchema'];
      AsString['MetaDefCatalog'] := oParamList.Values['MetaDefCatalog'];
      AsString['RDBMS'] := oParamList.Values['RDBMS'];
    end;
    OpenPhysManager;
    try
      ADPhysManager.CreateConnection(oConnectionDef, FConnIntf);
      FConnIntf.LoginPrompt := False;
      FConnIntf.Open;
      TryFetch;
      FConnIntf := nil;
    except
      on E: Exception do
        Error(E.Message);
    end;

    // modify connection definition
    oConnectionDef.AsString['MetaDefCatalog'] := 'master';
    try
      ADPhysManager.CreateConnection(oConnectionDef, FConnIntf);
      FConnIntf.LoginPrompt := False;
      FConnIntf.Open;
      TryFetch(True);
      lWasExcp := False;
      try
        oConnectionDef.AsString['MetaDefCatalog'] := 'master';
      except
        lWasExcp := True;
      end;
      FConnIntf := nil;
      if not lWasExcp then
        Error(ConnectionDefIsNotLocked('MyDef'));
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;

    // add connection definition with dublicate name
    oConnectionDef2 := ADPhysManager.ConnectionDefs.AddConnectionDef;
    lWasExcp := False;
    try
      oConnectionDef2.Name := 'MyDef';
    except
      lWasExcp := True;
    end;
    if not lWasExcp then
      Error(ConnectionDefNameDublicated('MyDef'));
    oConnectionDef2.Delete;
    oConnectionDef2 := nil;

    // clear connection definition
    try
      oConnectionDef.Clear;
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;
    if (AnsiCompareText(oConnectionDef.Name, 'Unnamed') <> 0) or
       (oConnectionDef.Database <> '') or
       (oConnectionDef.Params.Count <> 1) then
      Error(TheConnectionDefIsNotCleared);
    oConnectionDef := nil;

    // delete connection definition
    oConnectionDef2 := ADPhysManager.ConnectionDefs.AddConnectionDef;
    oConnectionDef2.Name := 'MyDef2';
    oTmpDef := ADPhysManager.ConnectionDefs.ConnectionDefByName('MyDef2');
    oTmpDef := nil;
    try
      oConnectionDef2.Delete;
      oConnectionDef2 := nil;
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;
    lWasExcp := False;
    try
      oTmpDef := ADPhysManager.ConnectionDefs.ConnectionDefByName('MyDef2');
      oTmpDef := nil;
    except
      lWasExcp := True;
    end;
    if not lWasExcp then
      Error(ConnectionDefAlreadyDel('MyDef2'));

    // Auto load feature
    with ADPhysManager, ConnectionDefs do begin
      Close(True);
      oTmpDef := FindConnectionDef('MSSQL2000_Demo');
      if oTmpDef = nil then
        Error(ConnectionDefNotLoaded);
      oTmpDef := nil;
      Clear;
      if Count = 0 then
        Error(ConnectionDefNotLoaded);
    end;

    // file name detection
    Cleanup;
    ADCreateInterface(IADStanConnectionDefs, oConnDefs);
    if oConnDefs.Storage.ActualFileName <> ADExpandStr(ADLoadConnDefGlobalFileName) then
      Error('Failed to locate global connection definition file');

    FileCreate(ExtractFilePath(ParamStr(0)) + '\' + S_AD_DefCfgFileName);
    ADCreateInterface(IADStanConnectionDefs, oConnDefs);
    if ExtractFilePath(oConnDefs.Storage.ActualFileName) <> ExtractFilePath(ParamStr(0)) then
      Error('Failed to locate local connection definition file');

    FileCreate(ExtractFilePath(ParamStr(0)) + '\aaa.ini');
    ADCreateInterface(IADStanConnectionDefs, oConnDefs);
    oConnDefs.Storage.FileName := 'aaa.ini';
    if ExtractFilePath(oConnDefs.Storage.ActualFileName) <> ExtractFilePath(ParamStr(0)) then
      Error('Failed to locate specified connection definition file without path');

    sTemp := GetEnvironmentVariable('Temp');
    if sTemp = '' then
      sTemp := GetEnvironmentVariable('Tmp');
    if sTemp <> '' then
      sTemp := sTemp + '\';
    FileCreate(sTemp + 'aaa.ini');
    ADCreateInterface(IADStanConnectionDefs, oConnDefs);
    oConnDefs.Storage.FileName := sTemp + 'aaa.ini';
    if oConnDefs.Storage.ActualFileName <> oConnDefs.Storage.FileName then
      Error('Failed to locate specified connection definition file with path');

  finally
    // cleanup
    Cleanup;
    oParamList.Free;
    oIni.Free;
  end;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADQAStanTsHolder.TestIndyMonitoring;
var
  oConnectionDef: IADStanConnectionDef;
begin
  SetConnectionDefFileName(CONN_DEF_STORAGE);
  OpenPhysManager;
  try
    // add connection definition
    oConnectionDef := ADPhysManager.ConnectionDefs.AddConnectionDef;
    oConnectionDef.Name := 'MyDef';
    oConnectionDef.ParentDefinition := ADPhysManager.ConnectionDefs.ConnectionDefByName('MSSQL2000_Demo');
    oConnectionDef.MonitorBy := S_AD_MoniIndy;

    // verify - remote monitor client is linked
    try
      ADPhysManager.CreateConnection(oConnectionDef, FConnIntf);
      if FConnIntf.Monitor = nil then
        Error('Remote monitor client is not linked');
    except
      on E: Exception do
        Error('Failed to create connection - ' + E.Message);
    end;

    // verify - remote monitor server is not running
    try
      FConnIntf.LoginPrompt := False;
      FConnIntf.Open;
      if FConnIntf.Monitor.Tracing then
        Error('Failed to detect remote monitor server is not running');
    except
      on E: Exception do
        Error('Failed to open connection - ' + E.Message);
    end;

    // run remote monitor server
    ShellExecute(0, 'open', PChar(ADExpandStr(ADReadRegValue(S_AD_MoniValName))), nil, nil, SW_SHOW);
    Application.ProcessMessages;

    // verify - remote monitor server is running (1)
    try
      FConnIntf.Monitor.ResetFailure;
      FConnIntf.Monitor.Tracing := True;
      if not FConnIntf.Monitor.Tracing then
        Error('Failed to detect remote monitor server is running (1)');
    except
      on E: Exception do
        Error('Failed to connect to remote monitor server - ' + E.Message);
    end;

    // verify - remote monitor server is running (2)
    try
      ADPhysManager.CreateConnection(oConnectionDef, FConnIntf);
      FConnIntf.LoginPrompt := False;
      FConnIntf.Open;
      if not FConnIntf.Monitor.Tracing then
        Error('Failed to detect remote monitor server is running (2)');
    except
      on E: Exception do
        Error('Failed to open connection - ' + E.Message);
    end;

    // verify - remote monitor server output
    if MessageDlg(DidYouSee('Remote monitoring output'), mtInformation, [mbYes, mbNo], 0) <> Ord(mrYes) then
      Error('Remote monitoring does not work');

  finally
    FConnIntf := nil;
    oConnectionDef := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAStanTsHolder.TestFlatFileMonitoring;
var
  oConnectionDef: IADStanConnectionDef;
  oFFClnt: IADMoniFlatFileClient;
begin
  SetConnectionDefFileName(CONN_DEF_STORAGE);
  OpenPhysManager;
  try
    // FLAT FILE ================================================================
    // add connection definition
    oConnectionDef := ADPhysManager.ConnectionDefs.AddConnectionDef;
    oConnectionDef.Name := 'MyDef2';
    oConnectionDef.ParentDefinition := ADPhysManager.ConnectionDefs.ConnectionDefByName('MSSQL2000_Demo');
    oConnectionDef.MonitorBy := 'FlatFile';

    // verify - FlatFile monitor client is linked
    try
      ADPhysManager.CreateConnection(oConnectionDef, FConnIntf);
      if FConnIntf.Monitor = nil then
        Error('FlatFile monitor client is not linked');
    except
      on E: Exception do
        Error('Failed to create connection - ' + E.Message);
    end;

    // verify - FlatFile monitoring is running
    try
      FConnIntf.LoginPrompt := False;
      FConnIntf.Open;
      if not FConnIntf.Monitor.Tracing then
        Error('Failed to detect FlatFile monitoring is running');
    except
      on E: Exception do
        Error('Failed to open connection - ' + E.Message);
    end;

    // run FlatFile "monitor server"
    FConnIntf.Monitor.Tracing := False;
    ADCreateInterface(IADMoniFlatFileClient, oFFClnt);
    ShellExecute(0, 'open', PChar(ADExpandStr(oFFClnt.FileName)), nil, nil, SW_SHOW);
    if MessageDlg(DidYouSee('FlatFile monitoring output'), mtInformation, [mbYes, mbNo], 0) <> Ord(mrYes) then
      Error('FlatFile monitoring does not work');

  finally
    FConnIntf := nil;
    oConnectionDef := nil;
    oFFClnt := nil;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADQAStanTsHolder.ClearAfterTest;
begin
  inherited ClearAfterTest;
  if ADPhysManager.State = dmsActive then begin
    ADPhysManager.Close(True);
    ADPhysManager.Open;
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Stan Layer', TADQAStanTsHolder);

end.
