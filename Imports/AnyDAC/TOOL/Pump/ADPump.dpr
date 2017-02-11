{-------------------------------------------------------------------------------}
{ AnyDAC Ascii Data Pump utility                                                }
{ Copyright (c) 2004 by Dmitry Arefiev (www.da-soft.com)                        }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

program ADPump;

{$APPTYPE CONSOLE}

uses
  Windows, Classes, SysUtils, IniFiles,
  {$I ..\TOOLDBs.inc}
  daADStanIntf, daADStanOption, daADStanUtil,
  daADGUIxIntf, daADGUIxConsoleWait,
  daADCompClient, daADCompDataMove;

{$R *.res}

var
  oConnDest:    TADConnection;
  oDataMove:    TADDataMove;
  oQryDest:     TADQuery;
  s,
  sName,
  sConnDef,
  sConnDefFile,
  sUsername,
  sPassword,
  sDataPath:    String;
  oTabList:     TStringList;
  i:            Integer;

{$IFNDEF AnyDAC_D6}
  function DirectoryExists(const Directory: string): Boolean;
  var
    Code: Integer;
  begin
    Code := GetFileAttributes(PChar(Directory));
    Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
  end;
{$ENDIF}  

  function DefineFileName(const ADir, AFile, AExt: String): String;
  begin
    if ADir <> '' then
      Result := ADir + '\';
    Result := Result + AFile + '.' + AExt;
  end;

  procedure ShowAbout;
  var
    sProd, sVer, sVerName, sCpr, sInfo: String;
  begin
    ADGetVersionInfo(ParamStr(0), sProd, sVer, sVerName, sCpr, sInfo);
    Writeln;
    Writeln(sProd + ' v ' + sVerName);
    Writeln('Copyright ' + sCpr + ' (' + sInfo + ')');
    Writeln('All Rights Reserved.');
    Writeln;
    Writeln('Use: ADPump -d <name> [-n <file name>] [-u <user>] [-w <pwd>]');
    Writeln('            [-p <path>] {<text data file>}');
    Writeln('-d        - connection definition name');
    Writeln('-n        - connection definitions file name');
    Writeln('-u        - user name');
    Writeln('-w        - password');
    Writeln('-p        - path to text data files');
    Writeln('-? or -h  - show this text');
    Writeln('Comment: The text data file name must have .CSV or .TXT extension.');
  end;

begin
  FADGUIxSilentMode := True;
  try
    if ParamCount = 0 then begin
      ShowAbout;
      Exit;
    end;

    oConnDest  := TADConnection.Create(nil);
    oDataMove  := TADDataMove.Create(nil);
    oQryDest   := TADQuery.Create(nil);
    oTabList   := TStringList.Create;

    try

      i := 1;
      while i <= ParamCount do begin
        s := ParamStr(i);
        if s[1] in ['-', '/'] then begin
          s := UpperCase(Copy(s, 2, Length(s)));
          if s = 'D' then begin
            Inc(i);
            sConnDef := ADExpandStr(ParamStr(i));
          end
          else if s = 'N' then begin
            Inc(i);
            sConnDefFile := ADExpandStr(ParamStr(i));
          end
          else if s = 'P' then begin
            Inc(i);
            sDataPath := ADExpandStr(ParamStr(i));
            if (sDataPath <> '') and (sDataPath[Length(sDataPath)] = '\') then
              sDataPath := Copy(sDataPath, 1, Length(sDataPath) - 1);
          end
          else if s = 'U' then begin
            Inc(i);
            sUsername := ADExpandStr(ParamStr(i));
          end
          else if s = 'W' then begin
            Inc(i);
            sPassword := ParamStr(i);
          end
          else begin
            ShowAbout;
            Exit;
          end;
        end
        else
          oTabList.Add(s);
        Inc(i);
      end;

      if oTabList.Count = 0 then
        raise Exception.Create('No ascii data tables specified');
      if (sDataPath <> '') and not DirectoryExists(sDataPath) then
        raise Exception.Create('Directory [' + sDataPath + '] does not exists');
      if sConnDef = '' then
        raise Exception.Create('Parameter /D must be defined');

      ADManager.ConnectionDefFileName := sConnDefFile;

      with oConnDest do begin
        ConnectionDefName := sConnDef;
        if sUsername <> '' then
          ResultConnectionDef.UserName := sUsername;
        if sPassword <> '' then
          ResultConnectionDef.UserName := sPassword;
        FetchOptions.Mode := fmAll;
        Connected := True;
      end;

      with oTabList do
        for i := 0 to Count - 1 do begin
          s := DefineFileName(sDataPath, Strings[i], 'csv');
          if not FileExists(s) then begin
            s := DefineFileName(sDataPath, Strings[i], 'txt');
            if not FileExists(s) then
              raise Exception.Create('Ascii data file [' + Strings[i] + '] does not exists');
          end;
          Strings[i] := Strings[i] + '=' + s;
        end;

      with oDataMove do begin
        with AsciiDataDef do begin
          WithFieldNames := True;
          FormatSettings.DecimalSeparator := '.';
          FormatSettings.DateSeparator := '-';
          FormatSettings.TimeSeparator := ':';
          FormatSettings.ShortDateFormat := 'yyyy/mm/dd';
          FormatSettings.ShortTimeFormat := 'hh:mm:ss';
        end;
        Mode          := dmAlwaysInsert;
        Options       := [poClearDest, poClearDestNoUndo, poAbortOnExc];
        SourceKind    := skAscii;
        Destination   := oQryDest;
        LogFileAction := laNone;
      end;

      oQryDest.Connection := oConnDest;

      with oTabList do
        for i := 0 to Count - 1 do begin
          sName := Names[i];
          oQryDest.SQL.Text := 'select * from ' + oConnDest.EncodeObjectName('', '', '', sName);
          with oDataMove do begin
            AsciiFileName := oTabList.Values[sName];
            Writeln('Pumping [' + AsciiFileName + '] file.');
            Execute;
          end
        end;

    finally
      oConnDest.Free;
      oDataMove.Free;
      oQryDest.Free;
      oTabList.Free;
    end;

    Writeln('Done.');

  except
    on E: Exception do begin
      Writeln('ERROR: ' + e.Message);
      ExitCode := 1;
    end;
  end;

end.

