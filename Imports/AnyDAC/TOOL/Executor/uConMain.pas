{-------------------------------------------------------------------------------}
{ AnyDAC Executor console part                                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit uConMain;

interface

uses
  Windows, Classes, Messages, SysUtils,
{$IFDEF AnyDAC_D6}
  StrUtils, Variants, Types,
{$ENDIF}  
  daADStanIntf, daADStanOption, daADStanParam, daADStanSQLParser,
  daADDatSManager,
  daADPhysIntf;

type
  TADScriptEnv = class
  public
    procedure DoConnectError(E: Exception); virtual; abstract;
    procedure DoCommandError(E: Exception); virtual; abstract;
    procedure DoCommandChanged; virtual; abstract;
    procedure DoLog(const AMsg: String; ANewLine: Boolean); virtual; abstract;
    procedure DoCheckUpdateScriptAndPos; virtual; abstract;
  end;

  TADScriptConsoleEnv = class (TADScriptEnv)
  public
    procedure DoConnectError(E: Exception); override;
    procedure DoCommandError(E: Exception); override;
    procedure DoCommandChanged; override;
    procedure DoLog(const AMsg: String; ANewLine: Boolean); override;
    procedure DoCheckUpdateScriptAndPos; override;
  end;

  TADScriptExecutor = class(TObject)
  private
    FEOF: Boolean;
    FPosX: Integer;
    FLockEofUpdate: Boolean;
    FErrors: Integer;
    FEnv: TADScriptEnv;
    FOraUROWIDSupported: Boolean;
    FFileList: TStringList;
    FCommand: TStringList;
    FConnIntf: IADPhysConnection;
    FCommIntf: IADPhysCommand;
    FSQLParser: TSQLFileParserGS;
    FLoginPrompt: Boolean;
    FUsername, FPassword: String;
    FConnectionDefFile: String;
    FConnectionDef: String;
    FScriptPath: String;
    FContinueOnError: Boolean;
    FShowMessages: Boolean;
    FErrorAllowed: Boolean;
    FDropNonexistObj: Boolean;
    FScriptExecuting: Boolean;
    function GetCurrentPosition: TPoint;
    procedure SetCurrentPosition(const AValue: TPoint);
    procedure CheckUpdateScriptAndPos;
    procedure UpdateEOF;
    function GetEOF: Boolean;
    function GetConnected: Boolean;
    procedure SetEnv(AEnv: TADScriptEnv);
    function GetSQLDelimiter: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ShowAbout;
    function ExtractParams: Boolean;
    procedure Init;
    function Connect: Boolean;
    procedure OpenScript(AIndex: Integer);
    procedure AssignStrings(ASQLStrings: TStrings);
    function NextCommand: Boolean;
    function RunCommand: Boolean;
    procedure RunScript;
    procedure RunAllScripts;
    procedure Log(const AMsg: String; ANewLine: Boolean);
    property Env: TADScriptEnv read FEnv write SetEnv;
    property FileList: TStringList read FFileList;
    property Connected: Boolean read GetConnected;
    property CurrentPosition: TPoint read GetCurrentPosition write SetCurrentPosition;
    property EOF: Boolean read GetEOF;
    property Command: TStringList read FCommand;
    property SQLDelimiter: String read GetSQLDelimiter;
    property Errors: Integer read FErrors;
    property ConnIntf: IADPhysConnection read FConnIntf;
    property LoginPrompt: Boolean read FLoginPrompt write FLoginPrompt;
    property ContinueOnError: Boolean read FContinueOnError write FContinueOnError;
    property DropNonexistObj: Boolean read FDropNonexistObj write FDropNonexistObj;
    property ShowMessages: Boolean read FShowMessages write FShowMessages;
    property ConnectionDef: String read FConnectionDef write FConnectionDef;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
  end;

implementation

uses
  Dialogs,
  uDatSUtils,
  daADStanUtil, daADStanError;

{-------------------------------------------------------------------------------}
{ TADScriptConsoleEnv                                                           }
{-------------------------------------------------------------------------------}
procedure TADScriptConsoleEnv.DoCommandChanged;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScriptConsoleEnv.DoConnectError(E: Exception);
begin
  WriteLn(Format('Error on connection open'#13#10'%s', [E.Message]));
end;

{-------------------------------------------------------------------------------}
procedure TADScriptConsoleEnv.DoCommandError(E: Exception);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScriptConsoleEnv.DoLog(const AMsg: String; ANewLine: Boolean);
begin
  Write(AMsg);
  if ANewLine then
    Writeln;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptConsoleEnv.DoCheckUpdateScriptAndPos;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{ TADScriptExecutor                                                             }
{-------------------------------------------------------------------------------}
constructor TADScriptExecutor.Create;
begin
  inherited Create;
  FFileList := TStringList.Create;
  FConnectionDefFile := '';
  FConnectionDef := '';
  FContinueOnError := False;
  FDropNonexistObj := False;
  FShowMessages := True;
  FErrorAllowed := False;
  FLoginPrompt := False;
  FSQLParser := TSQLFileParserGS.Create;
  FEOF := True;
  FCommand := TStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADScriptExecutor.Destroy;
begin
  FFileList.Free;
  FFileList := nil;
  FSQLParser.Free;
  FSQLParser := nil;
  FCommand.Free;
  FCommand := nil;
  SetEnv(nil);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.SetEnv(AEnv: TADScriptEnv);
begin
  if FEnv <> nil then
    FEnv.Free;
  FEnv := AEnv;
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.GetConnected: Boolean;
begin
  Result := (FConnIntf <> nil) and (FConnIntf.State = csConnected);
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.GetSQLDelimiter: String;
begin
  Result := FSQLParser.SQLDelimiter;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.AssignStrings(ASQLStrings: TStrings);
begin
  FSQLParser.InitFromSQLString(ASQLStrings);
  UpdateEOF;
  FErrors := 0;
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.GetCurrentPosition: TPoint;
begin
  Result := Point(FPosX, FSQLParser.StartLineNr);
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.SetCurrentPosition(const AValue: TPoint);
begin
  if (AValue.Y <> FSQLParser.StartLineNr) or (AValue.X <> FPosX) then begin
    FSQLParser.StartLineNr := AValue.Y;
    FPosX := AValue.X;
    UpdateEOF;
    FErrors := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.GetEOF: Boolean;
begin
  if not FLockEofUpdate then
    CheckUpdateScriptAndPos;
  Result := FEOF;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.ShowAbout;
var
  sProd, sVer, sVerName, sCpr, sInfo: String;
begin
  ADGetVersionInfo(ParamStr(0), sProd, sVer, sVerName, sCpr, sInfo);
  FEnv.DoLog('', True);
  FEnv.DoLog(sProd + ' v ' + sVerName, True);
  FEnv.DoLog('Copyright ' + sCpr + ' (' + sInfo + ')', True);
  FEnv.DoLog('All Rights Reserved.', True);
  FEnv.DoLog('', True);
  FEnv.DoLog('Use: ADExecutor -d <name> [-n <file name>] [-u <user>] [-w <pwd>]', True);
  FEnv.DoLog('                [-e] [-i] [-s] [-p <path>] {<scripts>}', True);
  FEnv.DoLog('', True);
  FEnv.DoLog('-d        - connection definition name', True);
  FEnv.DoLog('-n        - connection definitions file name', True);
  FEnv.DoLog('-u        - user name', True);
  FEnv.DoLog('-w        - password', True);
  FEnv.DoLog('-l        - login prompt', True);
  FEnv.DoLog('-p        - path to SQL script files', True);
  FEnv.DoLog('-e        - ignore drop non-existing object error', True);
  FEnv.DoLog('-i        - continue SQL script execution after error', True);
  FEnv.DoLog('-s        - do not show messages during SQL script execution', True);
  FEnv.DoLog('-? or -h  - show this text', True);
  FEnv.DoLog('', True);
  FEnv.DoLog('Example: ADExecutor -d Oracle_Demo -i -p x:\MyScripts s1.sql s2.sql', True);
  FEnv.DoLog('executes s1.sql and s2.sql scripts in directory x:\MyScripts, using', True);
  FEnv.DoLog('connection definition Oracle_Demo, dont stop on error', True);
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.ExtractParams: Boolean;
var
  s: String;
  i: Integer;
begin
  i := 1;
  while i <= ParamCount do begin
    s := ParamStr(i);
    if s[1] in ['-', '/'] then begin
      s := UpperCase(Copy(s, 2, Length(s)));
      if s = 'D' then begin
        Inc(i);
        FConnectionDef := ADExpandStr(ParamStr(i));
      end
      else if s = 'E' then
        FDropNonexistObj := True
      else if s = 'I' then
        FContinueOnError := True
      else if s = 'N' then begin
        Inc(i);
        FConnectionDefFile := ADExpandStr(ParamStr(i));
      end
      else if s = 'P' then begin
        Inc(i);
        FScriptPath := ADExpandStr(ParamStr(i));
        if (FScriptPath <> '') and (FScriptPath[Length(FScriptPath)] = '\') then
          FScriptPath := Copy(FScriptPath, 1, Length(FScriptPath) - 1);
      end
      else if s = 'S' then
        FShowMessages := False
      else if s = 'U' then begin
        Inc(i);
        FUsername := ADExpandStr(ParamStr(i));
      end
      else if s = 'W' then begin
        Inc(i);
        FPassword := ParamStr(i);
      end
      else if s = 'L' then begin
        Inc(i);
        FLoginPrompt := True;
      end
      else begin
        ShowAbout;
        Result := False;
        Exit;
      end;
    end
    else
      FFileList.Add(s);
    Inc(i);
  end;
  for i := 0 to FFileList.Count - 1 do begin
    s := FFileList[i];
    if ExtractFileExt(s) = '' then
      s := s + '.sql';
    if FScriptPath <> '' then
      s := FScriptPath + '\' + s;
    if not FileExists(s) then begin
      if FShowMessages then
        FEnv.DoLog('Script file [' + s + '] does not exists !', True);
      Result := False;
      Exit;
    end;
    FFileList[i] := s;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.Init;
begin
  if FConnectionDefFile <> '' then
    ADPhysManager.ConnectionDefs.Storage.FileName := FConnectionDefFile;
  ADPhysManager.Options.ResourceOptions.ParamCreate := False;
  ADPhysManager.Open;
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.Connect: Boolean;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  ADPhysManager.CreateConnection(FConnectionDef, FConnIntf);
  with FConnIntf.Options.FetchOptions do
    Items := Items - [fiMeta];
  FOraUROWIDSupported := False;
  try
    if FUserName <> '' then
      FConnIntf.ConnectionDef.UserName := FUserName;
    if FPassword <> '' then
      FConnIntf.ConnectionDef.Password := FPassword;
    if not FLoginPrompt then
      FConnIntf.LoginPrompt := False;
    FConnIntf.Open;
    Result := True;
  except
    on E: Exception do begin
      FEnv.DoConnectError(E);
      Result := False;
      Exit;
    end;
  end;
  FConnIntf.CreateCommand(FCommIntf);
  FConnIntf.CreateMetadata(oConnMeta);
  if oConnMeta.Kind = mkOracle then begin
    try
      FCommIntf.Prepare('declare r urowid; begin null; end;');
      FCommIntf.Execute;
      FOraUROWIDSupported := True;
    except
    end;
    FCommIntf.Unprepare;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.OpenScript(AIndex: Integer);
begin
  FSQLParser.Close;
  FSQLParser.SQLFileName := FFileList[AIndex];
  FSQLParser.Open;
  FErrors := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.UpdateEOF;
var
  i: Integer;
  s: String;
begin
  FEOF := True;
  if FSQLParser.SQLStrings <> nil then begin
    for i := FSQLParser.StartLineNr to FSQLParser.SQLStrings.Count - 1 do begin
      s := FSQLParser.SQLStrings[i];
      if i = FSQLParser.StartLineNr then
        s := Copy(s, FPosX + 1, Length(s));
      if Trim(s) <> '' then begin
        FEOF := False;
        Break;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.CheckUpdateScriptAndPos;
begin
  FEnv.DoCheckUpdateScriptAndPos;
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.NextCommand: Boolean;
begin
  CheckUpdateScriptAndPos;
  if not FEOF and FSQLParser.IsOpen then begin
    FCommand.Clear;
    FSQLParser.GetNextSQLStmt(FCommand, FEOF, FErrorAllowed);
    FLockEofUpdate := True;
    try
      FEnv.DoCommandChanged;
    finally
      FLockEofUpdate := False;
    end;
  end;
  Result := not FEOF and FSQLParser.IsOpen;
end;

{-------------------------------------------------------------------------------}
function TADScriptExecutor.RunCommand: Boolean;
var
  i: Integer;
  oTab: TADDatSTable;
  oLines: TStringList;
  iTm: LongWord;
  oURIMac: TADMacro;
  sLine: String;
  lOpen: Boolean;
begin
  if (FCommand.Count = 0) or
     (CompareText(Trim(FCommand.Text), 'exit') = 0) then begin
    Result := False;
    Exit;
  end;
  Result := True;
  with FCommIntf do
  try
    if not FScriptExecuting then
      Options.ResourceOptions.AsyncCmdMode := amCancelDialog;
    Options.FetchOptions.AutoClose := False;
    try
      iTm := GetTickCount;
      if FShowMessages then
        FEnv.DoLog(Copy(FCommand.Text, 1, 30) + ' ... ', False);
      CommandText := FCommand.Text;
      oURIMac := Macros.FindMacro('_ora_UROWID');
      if oURIMac <> nil then
        if FOraUROWIDSupported then
          oURIMac.AsRaw := 'UROWID'
        else
          oURIMac.AsRaw := 'ROWID';
      Prepare;
      lOpen := (CommandKind in [skSelect, skSelectForUpdate, skStoredProcWithCrs,
        skExecute]);
      try
        try
          while True do begin
            if lOpen then begin
              Open;
              if State <> csOpen then
                Break;
              oTab := TADDatSTable.Create;
              oLines := TStringList.Create;
              try
                Define(oTab, mmReset);
                Fetch(oTab, True);
                if FShowMessages then begin
                  oLines.Clear;
                  PrintRows(oTab, oLines);
                  FEnv.DoLog('', True);
                  for i := 0 to oLines.Count - 1 do
                    FEnv.DoLog(oLines[i], True);
                end;
              finally
                oLines.Free;
                oTab.Free;
              end;
            end
            else
              Execute;
            NextRecordSet := True;
            Close;
            lOpen := True;
          end;
        except
          on E: EADDBEngineException do begin
            if (E.Kind = ekObjNotExists) and (CommandKind = skDrop) and DropNonexistObj then begin
              if FShowMessages then
                if E[0].ObjName <> '' then
                  FEnv.DoLog('[' + E[0].ObjName + '] does not exists. ', True)
                else
                  FEnv.DoLog('Object does not exists. ', True);
            end
            else
              raise;
          end;
        end;
      finally
        CloseAll;
      end;
      iTm := GetTickCount - iTm;
      if FShowMessages then
        FEnv.DoLog('Done [' + IntToStr(iTm) + ' ms]', True);
    except
      on E: Exception do begin
        if FShowMessages then begin
          FEnv.DoLog(Copy(FCommand.Text, 1, 25) + ' ... ', False);
          FEnv.DoLog('', True);
          i := 1;
          while i <= Length(E.Message) do begin
            sLine := ADStrToken(E.Message, [#13, #10], i, True);
            FEnv.DoLog('ERROR: ' + sLine, True);
          end;
          FEnv.DoLog('', True);
        end;
        Inc(FErrors);
        Result := FContinueOnError;
        if not FScriptExecuting then
          FEnv.DoCommandError(E);
      end;
    end;
  finally
    if not FScriptExecuting then
      Options.ResourceOptions.RestoreDefaults;
  end;
  FCommand.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.RunScript;
var
  iTm: LongWord;
begin
  UpdateEOF;
  CheckUpdateScriptAndPos;
  iTm := GetTickCount;
  FErrors := 0;
  FScriptExecuting := True;
  try
    if FCommand.Text = '' then
      NextCommand;
    while RunCommand do
      NextCommand;
  finally
    FScriptExecuting := False;
  end;

  if FShowMessages then
    if FEOF then begin
      iTm := GetTickCount - iTm;
      FEnv.DoLog('', True);
      FEnv.DoLog('---------------------------------------------', True);
      FEnv.DoLog('Script finished (' + FloatToStr(iTm / 1000) + ' s).', True);
      FEnv.DoLog('', True);
    end
    else begin
      FEnv.DoLog('', True);
      FEnv.DoLog('---------------------------------------------', True);
      FEnv.DoLog('Script executing aborted with errors.', True);
      FEnv.DoLog('', True);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.RunAllScripts;
var
  i: Integer;
begin
  for i := 0 to FFileList.Count - 1 do begin
    OpenScript(i);
    RunScript;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptExecutor.Log(const AMsg: String; ANewLine: Boolean);
begin
  FEnv.DoLog(AMsg, ANewLine);
end;

end.
