{-------------------------------------------------------------------------------}
{ AnyDAC db command preprocessor                                                }
{ Copyright (c) 2004 by Dmitry Arefiev (www.da-soft.com)                        }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysCmdPreprocessor;

interface

uses
  Classes,
  daADStanParam,
  daADPhysIntf;

type
  TADPhysPreprocessorInstr = (piCreateParams, piCreateMacros,
    piExpandParams, piExpandMacros, piExpandEscapes, piParseSQL);
  TADPhysPreprocessorInstrs = set of TADPhysPreprocessorInstr;

  TADPhysPreprocessor = class(TObject)
  private
    // control
    FConnMetadata: IADPhysConnectionMetadata;
    FParams: TADParams;
    FMacrosUpd, FMacrosRead: TADMacros;
    FInstrs: TADPhysPreprocessorInstrs;
    FDesignMode: Boolean;
    FNameDelim1, FNameDelim2: Char;
    // runtime
    FSource, FDestination: String;
    FSourceLen: Integer;
    FSrcIndex, FCommitedIndex, FDestinationIndex: Integer;
    FInComment1, FInComment2, FInStr1, FInStr2, FInName, FInMySQLConditional: Boolean;
    FEscapeLevel, FBraceLevel, FParamCount: Integer;
    FParamCache: TStringList;
    FDestStack: TStringList;
    FSQLCommandKind: TADPhysCommandKind;
    FSQLFromValue: String;
    FSQLOrderByPos: Integer;
    FSQLValuesPos: Integer;
    procedure Commit(ASkip: Integer = 0);
    procedure Writestr(const AStr: String);
    procedure PushWriter;
    function PopWriter: String;
    function GetChar: Char;
    procedure PutBack;
    procedure SkipWS;
    function ProcessIdentifier(var AIsQuoted: Boolean): String;
    procedure ProcessParam;
    procedure ProcessMacro(AFirstCh: Char);
    procedure ProcessEscape;
    function ProcessCommand: String;
    function TranslateEscape(var AEscape: TADPhysEscapeData): String;
    procedure ParseDestination;
    procedure Missed(const AStr: String);
  public
    procedure Execute;
    // R/W
    property ConnMetadata: IADPhysConnectionMetadata read FConnMetadata write FConnMetadata;
    property Source: String read FSource write FSource;
    property Destination: String read FDestination;
    property Params: TADParams read FParams write FParams;
    property MacrosUpd: TADMacros read FMacrosUpd write FMacrosUpd;
    property MacrosRead: TADMacros read FMacrosRead write FMacrosRead;
    property Instrs: TADPhysPreprocessorInstrs read FInstrs write FInstrs;
    property DesignMode: Boolean read FDesignMode write FDesignMode;
    // R/O
    property SQLCommandKind: TADPhysCommandKind read FSQLCommandKind;
    property SQLFromValue: String read FSQLFromValue;
    property SQLOrderByPos: Integer read FSQLOrderByPos;
    property SQLValuesPos: Integer read FSQLValuesPos;
  end;

implementation

uses
  SysUtils, DB,
  daADStanIntf, daADStanUtil, daADStanError, daADStanConst;

{ ---------------------------------------------------------------------------- }
{ TADPhysPreprocessor                                                          }
{ ---------------------------------------------------------------------------- }
procedure TADPhysPreprocessor.Execute;
var
  i: Integer;
begin
  FDestination := '';
  FSQLCommandKind := skOther;
  FSQLFromValue := '';
  FSQLOrderByPos := 0;
  FSQLValuesPos := 0;
  if (MacrosRead = nil) and (piExpandMacros in Instrs) or
     (MacrosUpd = nil) and (piCreateMacros in Instrs) or
     (Params = nil) and (Instrs * [piCreateParams, piExpandParams] <> []) or
     (ConnMetadata = nil) and (Instrs * [piExpandEscapes, piParseSQL] <> []) then
    ADException(Self, [S_AD_LPhys], er_AD_AccPrepParamNotDef, []);
  if FSource = '' then
    Exit;
  FInComment1 := False;
  FInMySQLConditional := False;
  FInComment2 := False;
  FInStr1 := False;
  FInStr2 := False;
  FInName := False;
  if ConnMetadata <> nil then begin
    FNameDelim1 := ConnMetadata.NameQuotaChar1;
    FNameDelim2 := ConnMetadata.NameQuotaChar2;
  end;
  FSrcIndex := 0;
  FCommitedIndex := 0;
  FEscapeLevel := 0;
  FBraceLevel := 0;
  FParamCount := 0;
  FDestinationIndex := 1;
  SetLength(FDestination, 512);
  FSourceLen := Length(FSource);
  FDestStack  := TStringList.Create;
  FParamCache := TStringList.Create;
  FParamCache.Sorted := True;
  FParamCache.Duplicates := dupAccept;
  if [piExpandParams, piCreateParams] * Instrs <> [] then begin
    for i := 0 to Params.Count - 1 do
      FParamCache.Add(AnsiUpperCase(Params[i].Name));
    FParamCount := Params.Count;
    Params.BeginUpdate;
  end;
  try
    FDestination := ProcessCommand;
    if piParseSQL in Instrs then begin
      if FEscapeLevel > 0 then
        Missed('}');
      ParseDestination;
    end;
  finally
    if [piExpandParams, piCreateParams] * Instrs <> [] then
      Params.EndUpdate;
    FreeAndNil(FParamCache);
    FreeAndNil(FDestStack);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.Missed(const AStr: String);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccPrepMissed, [AStr]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.Commit(ASkip: Integer = 0);
var
  iLen: Integer;
begin
  iLen := FSrcIndex - FCommitedIndex + ASkip;
  if FCommitedIndex + iLen >= FSourceLen then
    iLen := FSourceLen - FCommitedIndex;
  if iLen > 0 then begin
    while FDestinationIndex + iLen - 1 > Length(FDestination) do
      SetLength(FDestination, Length(FDestination) * 2);
    ADMove((PChar(FSource) + FCommitedIndex)^, (PChar(FDestination) + FDestinationIndex - 1)^, iLen);
    FDestinationIndex := FDestinationIndex + iLen;
  end;
  FCommitedIndex := FSrcIndex;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.WriteStr(const AStr: String);
var
  iLen: Integer;
begin
  iLen := Length(AStr);
  if iLen > 0 then begin
    while FDestinationIndex + iLen - 1 > Length(FDestination) do
      SetLength(FDestination, Length(FDestination) * 2);
    ADMove(PChar(AStr)^, (PChar(FDestination) + FDestinationIndex - 1)^, iLen);
    FDestinationIndex := FDestinationIndex + iLen;
  end;
  FCommitedIndex := FSrcIndex;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.PushWriter;
begin
  FDestStack.AddObject(FDestination, TObject(FDestinationIndex));
  SetLength(FDestination, 512);
  FDestinationIndex := 1;
  FCommitedIndex := FSrcIndex;
end;

{-------------------------------------------------------------------------------}
function TADPhysPreprocessor.PopWriter: String;
begin
  Commit;
  Result := Copy(FDestination, 1, FDestinationIndex - 1);
  FDestination := FDestStack[FDestStack.Count - 1];
  FDestinationIndex := Integer(FDestStack.Objects[FDestStack.Count - 1]);
  FDestStack.Delete(FDestStack.Count - 1);
  FCommitedIndex := FSrcIndex;
end;

{-------------------------------------------------------------------------------}
function TADPhysPreprocessor.GetChar: Char;
begin
  Inc(FSrcIndex);
  if FSrcIndex > FSourceLen then
    Result := #0
  else
    Result := FSource[FSrcIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.PutBack;
begin
  Dec(FSrcIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.SkipWS;
var
  ch: Char;
begin
  repeat
    ch := GetChar;
  until (ch > ' ') or (ch = #0);
  if ch <> #0 then
    PutBack;
end;

{-------------------------------------------------------------------------------}
function TADPhysPreprocessor.ProcessIdentifier(var AIsQuoted: Boolean): String;
var
  aBuff: array [0 .. 255] of Char;
  i: Integer;
begin
  i := -1;
  if (ConnMetadata <> nil) and (GetChar = FNameDelim1) then begin
    AIsQuoted := True;
    repeat
      Inc(i);
      if i = 256 then
        ADException(Self, [S_AD_LPhys], er_AD_AccPrepTooLongIdent, []);
      aBuff[i] := GetChar;
    until (aBuff[i] in [#0, FNameDelim2]);
    SetString(Result, aBuff, i);
  end
  else begin
    AIsQuoted := False;
    PutBack;
    repeat
      Inc(i);
      if i = 256 then
        ADException(Self, [S_AD_LPhys], er_AD_AccPrepTooLongIdent, []);
      aBuff[i] := GetChar;
    until not (aBuff[i] in ['0'..'9', 'a'..'z', 'A'..'Z', '#', '$',
                            '_', 'À'..'ß', 'à'..'ÿ']);
    PutBack;
    SetString(Result, aBuff, i);
    Result := AnsiUpperCase(Result);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.ProcessParam;
var
  ch: Char;
  sName, sSubst: String;
  lIsQuoted: Boolean;
  oPar: TADParam;
  iPar: Integer;
begin
  ch := GetChar;
  if ch in [#13, #10, #7, ' ', '='] then begin
    // skip assignment operator in PL/SQL
    // skip label in TSQL
  end
  else if ch = ':' then
    Commit(-1)
  else begin
    Commit(-2);
    PutBack;
    lIsQuoted := False;
    sName := ProcessIdentifier(lIsQuoted);
    sSubst := sName;
    iPar := FParamCache.IndexOf(AnsiUpperCase(sName));
    if (piCreateParams in Instrs) and
       ((ConnMetadata <> nil) and (ConnMetadata.ParamMark <> prName) or
        (Params.BindMode = pbByNumber) or
        (iPar = -1)) then begin
      if (ConnMetadata.ParamNameMaxLength > 0) and (Length(sName) > ConnMetadata.ParamNameMaxLength - 1) then begin
        if iPar <> -1 then begin
          oPar := TADParam(FParamCache.Objects[iPar]);
          iPar := oPar.Index;
        end
        else begin
          oPar := nil;
          iPar := Params.Count;
        end;
        Inc(iPar);
        sSubst := Copy(sSubst, 1, ConnMetadata.ParamNameMaxLength - 2 -
          Length(IntToStr(iPar))) + '_' + IntToStr(iPar);
      end
      else
        oPar := Params.FindParam(sName);
      if lIsQuoted then
        sSubst := ':' + FNameDelim1 + sSubst + FNameDelim2
      else
        sSubst := ':' + sSubst;
      if (oPar = nil) or
         (ConnMetadata <> nil) and (ConnMetadata.ParamMark <> prName) or
         (Params.BindMode = pbByNumber) then begin
        oPar := Params.Add;
        with oPar do begin
          if DesignMode then
            ParamType := ptInput;
          Name := sName;
          if Params.BindMode = pbByNumber then
            Position := Params.Count;
          IsCaseSensitive := lIsQuoted;
          FParamCache.AddObject(AnsiUpperCase(sName), oPar);
        end;
      end;
    end
    else
      sSubst := ':' + sSubst;
    if piExpandParams in Instrs then
      case ConnMetadata.ParamMark of
      prQMark:
        sSubst := '?';
      prNumber:
        begin
          sSubst := IntToStr(FParamCount);
          Inc(FParamCount);
        end;
      end;
    WriteStr(sSubst);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.ProcessMacro(AFirstCh: Char);
var
  ch: Char;
  sName: String;
  oMacro: TADMacro;
  lIsRaw, lIsQuoted, lProcessRes: Boolean;
  sRes: String;
  i: Integer;
  oPP: TADPhysPreprocessor;
begin
  lIsRaw := (AFirstCh = '!');
  ch := GetChar;
  if ch = AFirstCh then
    Commit(-1)
  else begin
    if piExpandMacros in Instrs then
      Commit(-2);
    PutBack;
    lIsQuoted := False;
    sName := ProcessIdentifier(lIsQuoted);
    if (MacrosUpd <> nil) and (piCreateMacros in Instrs) then begin
      oMacro := MacrosUpd.FindMacro(sName);
      if oMacro = nil then begin
        oMacro := TADMacro.Create(MacrosUpd);
        oMacro.Name := sName;
        if lIsRaw then
          oMacro.DataType := mdRaw
        else
          oMacro.DataType := mdIdentifier;
      end;
    end
    else
      oMacro := nil;
    if piExpandMacros in Instrs then begin
      if MacrosUpd <> MacrosRead then
        oMacro := MacrosRead.FindMacro(sName);
      if oMacro <> nil then begin
        sRes := oMacro.SQL;
        lProcessRes := False;
        for i := 1 to Length(sRes) do
          if sRes[i] in ['!', '&', ':', '{'] then begin
            lProcessRes := True;
            Break;
          end;
        if lProcessRes then begin
          oPP := TADPhysPreprocessor.Create;
          try
            oPP.ConnMetadata := ConnMetadata;
            oPP.Params := Params;
            oPP.MacrosUpd := MacrosUpd;
            oPP.MacrosRead := MacrosRead;
            oPP.Instrs := Instrs - [piParseSQL];
            oPP.DesignMode := DesignMode;
            oPP.Source := sRes;
            oPP.Execute;
            sRes := oPP.Destination;
          finally
            oPP.Free;
          end;
        end;
        WriteStr(sRes);
      end
      else
        WriteStr('');
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.ProcessEscape;
var
  sKind: String;
  lTemp: Boolean;
  rEsc: TADPhysEscapeData;
  ch: Char;
  iPrevSrcIndex, iCnt: Integer;
begin
  // check for GUID and $DEFINE
  iPrevSrcIndex := FSrcIndex;
  iCnt := 0;
  while GetChar in ['0' .. '9', 'a' .. 'f', 'A' .. 'F', '-', '$'] do
    Inc(iCnt);
  if iCnt > 3 then begin
    Commit(0);
    Exit;
  end;
  FSrcIndex := iPrevSrcIndex;

  // it is rather escape sequence
  Commit(-1);
  Inc(FEscapeLevel);
  SkipWS;
  lTemp := False;
  sKind := UpperCase(ProcessIdentifier(lTemp));
  SkipWS;
  if sKind = 'E' then begin
    rEsc.FKind := eskFloat;
    SetLength(rEsc.FArgs, 1);
    rEsc.FArgs[0] := ProcessCommand;
  end
  else if sKind = 'D' then begin
    rEsc.FKind := eskDate;
    SetLength(rEsc.FArgs, 1);
    rEsc.FArgs[0] := ProcessCommand;
  end
  else if sKind = 'T' then begin
    rEsc.FKind := eskTime;
    SetLength(rEsc.FArgs, 1);
    rEsc.FArgs[0] := ProcessCommand;
  end
  else if sKind = 'DT' then begin
    rEsc.FKind := eskDateTime;
    SetLength(rEsc.FArgs, 1);
    rEsc.FArgs[0] := ProcessCommand;
  end
  else if sKind = 'ID' then begin
    rEsc.FKind := eskIdentifier;
    SetLength(rEsc.FArgs, 1);
    rEsc.FArgs[0] := ProcessCommand;
  end
  else if sKind = 'L' then begin
    rEsc.FKind := eskBoolean;
    SetLength(rEsc.FArgs, 1);
    rEsc.FArgs[0] := ProcessCommand;
  end
  else if (sKind = 'IF') or (sKind = 'IIF') then begin
    rEsc.FKind := eskIF;
    SkipWS;
    ch := GetChar;
    if ch <> '(' then
      Missed('(');
    Inc(FBraceLevel);
    repeat
      ch := GetChar;
      if ch <> ')' then begin
        SetLength(rEsc.FArgs, Length(rEsc.FArgs) + 2);
        PutBack;
        rEsc.FArgs[Length(rEsc.FArgs) - 2] := ProcessCommand;
        ch := GetChar;
        if ch <> ')' then begin
          rEsc.FArgs[Length(rEsc.FArgs) - 1] := ProcessCommand;
          ch := GetChar;
        end;
      end;
    until (ch = ')') or (ch = #0);
    if ch = ')' then
      Dec(FBraceLevel);
    if rEsc.FArgs[Length(rEsc.FArgs) - 1] = '' then
      SetLength(rEsc.FArgs, Length(rEsc.FArgs) - 1);
    SkipWS;
  end
  else if sKind = 'ESCAPE' then begin
    rEsc.FKind := eskEscape;
    SkipWS;
    ch := GetChar;
    if ch <> '''' then
      Missed('''');
    SetLength(rEsc.FArgs, 2);
    rEsc.FArgs[0] := GetChar;
    ch := GetChar;
    if ch <> '''' then
      Missed('''');
    SkipWS;
    rEsc.FArgs[1] := ProcessCommand;
  end
  else if sKind = 'FN' then begin
    rEsc.FKind := eskFunction;
    rEsc.FName := ProcessIdentifier(lTemp);
    SkipWS;
    ch := GetChar;
    if ch <> '(' then
      Missed('(');
    Inc(FBraceLevel);
    repeat
      ch := GetChar;
      if ch <> ')' then begin
        PutBack;
        SetLength(rEsc.FArgs, Length(rEsc.FArgs) + 1);
        rEsc.FArgs[Length(rEsc.FArgs) - 1] := ProcessCommand;
        ch := GetChar;
      end;
    until (ch = ')') or (ch = #0);
    if ch = ')' then
      Dec(FBraceLevel);
    SkipWS;
  end
  else
    ADException(Self, [S_AD_LPhys], er_AD_AccPrepUnknownEscape, [sKind]);
  if GetChar <> '}' then
    Missed('}');
  WriteStr(TranslateEscape(rEsc));
  Dec(FEscapeLevel);
end;

{-------------------------------------------------------------------------------}
function TADPhysPreprocessor.ProcessCommand: String;
var
  iEnterBraceLevel: Integer;
  ch: Char;
begin
  PushWriter;
  iEnterBraceLevel := FBraceLevel;
  repeat
    ch := GetChar;
    case ch of
    '}':
      if (piExpandEscapes in Instrs) and
         not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName then
        Break;
    '(':
      if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName then
        Inc(FBraceLevel);
    ')':
      if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName then begin
        if (FEscapeLevel > 0) and (FBraceLevel = iEnterBraceLevel) then
          Break;
        Dec(FBraceLevel);
        if (FEscapeLevel > 0) and (FBraceLevel = iEnterBraceLevel) then
          Break;
      end;
    '/':
      begin
        ch := GetChar;
        if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName and (ch = '*') then
          if FConnMetadata.Kind = mkMySQL then begin
            ch := GetChar;
            if ch = '!' then
              FInMySQLConditional := True
            else begin
              PutBack;
              FInComment1 := True;
            end
          end
          else
            FInComment1 := True
        else
          PutBack;
      end;
    '*':
      begin
        ch := GetChar;
        if not FInComment2 and not FInStr1 and not FInStr2 and not FInName and (ch = '/') then
          if FInMySQLConditional then
            FInMySQLConditional := False
          else
            FInComment1 := False
        else
          PutBack;
      end;
    '-':
      begin
        ch := GetChar;
        if not FInComment1 and not FInStr1 and not FInStr2 and not FInName and (ch = '-') then
          FInComment2 := True
        else
          PutBack;
      end;
    '''':
      if not FInComment1 and not FInComment2 and not FInName and not FInStr2 then
        FInStr1 := not FInStr1;
    #13, #10:
      begin
        if not FInComment1 and FInComment2 then
          FInComment2 := False;
        if ch = #13 then
          Commit(-1);
      end;
    ':':
      if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName and
         (Instrs * [piExpandParams, piCreateParams] <> []) then
        ProcessParam;
    '{':
      if piExpandEscapes in Instrs then
        ProcessEscape;
    ',':
      if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName then
        if (iEnterBraceLevel > 0) and (iEnterBraceLevel = FBraceLevel) then
          Break;
    '!', '&':
      if Instrs * [piExpandMacros, piCreateMacros] <> [] then
        ProcessMacro(ch);
    '^':
      begin
        Commit(-1);
        GetChar;
      end;
    else
      if (ch = '"') and (FNameDelim1 <> '"') then begin
        if not FInComment1 and not FInComment2 and not FInName and not FInStr1 then
          FInStr2 := not FInStr2;
      end
      else if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 then
        if ch = FNameDelim1 then
          if FNameDelim1 = FNameDelim2 then
            FInName := not FInName
          else
            FInName := True
        else if ch = FNameDelim2 then
          if FNameDelim1 = FNameDelim2 then
            FInName := not FInName
          else
            FInName := False;
    end;
  until (ch = #0);
  if ch <> #0 then
    PutBack;
  Result := PopWriter;
end;

{-------------------------------------------------------------------------------}
function TADPhysPreprocessor.TranslateEscape(var AEscape: TADPhysEscapeData): String;
begin
  Result := ConnMetadata.TranslateEscapeSequence(AEscape);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPreprocessor.ParseDestination;
var
  iPos, iLen: Integer;
  iAdjustOBPos, iAdjustValuesPos: Integer;
  lFirstWord: Boolean;
  iFromStartedPos, iFromEndedPos, iCmdStartedPos: Integer;
  ch: Char;
begin
  iPos := 1;
  iLen := Length(FDestination);
  lFirstWord := True;
  iFromStartedPos := 0;
  iFromEndedPos := 0;
  FBraceLevel := 0;
  FInComment1 := False;
  FInMySQLConditional := False;
  FInComment2 := False;
  FInStr1 := False;
  FInStr2 := False;
  FInName := False;
  FBraceLevel := 0;
  iAdjustOBPos := 0;
  iAdjustValuesPos := 0;
  while iPos <= iLen do begin
    ch := FDestination[iPos];
    case ch of
    '(':
        if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName then
          Inc(FBraceLevel);
    ')':
      if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName then begin
        Dec(FBraceLevel);
        if (FBraceLevel = 0) and (iFromStartedPos <> 0) and (FDestination[iFromStartedPos] = '(') and
           (iFromEndedPos = 0) then
          iFromEndedPos := iPos;
      end;
    '/':
      begin
        Inc(iPos);
        if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName and (FDestination[iPos] = '*') then
          if FConnMetadata.Kind = mkMySQL then begin
            Inc(iPos);
            if FDestination[iPos] = '!' then
              FInMySQLConditional := True
            else begin
              Dec(iPos);
              FInComment1 := True;
            end
          end
          else
            FInComment1 := True
        else
          Dec(iPos);
      end;
    '*':
      begin
        Inc(iPos);
        if not FInComment2 and not FInStr1 and not FInStr2 and not FInName and (FDestination[iPos] = '/') then
          if FInMySQLConditional then
            FInMySQLConditional := False
          else
            FInComment1 := False
        else
          Dec(iPos);
      end;
    '-':
      begin
        Inc(iPos);
        if not FInComment1 and not FInStr1 and not FInStr2 and not FInName and (FDestination[iPos] = '-') then
          FInComment2 := True
        else
          Dec(iPos);
      end;
    '''':
      if not FInComment1 and not FInComment2 and not FInName and not FInStr2 then
        FInStr1 := not FInStr1;
    #13, #10, ' ', #9, ',':
      begin
        if ch in [#13, #10] then begin
          if not FInComment1 and FInComment2 then
            FInComment2 := False;
          if (ch = #10) and ((iPos <= 1) or (FDestination[iPos - 1] <> #13)) then begin
            if FSQLOrderByPos = 0 then
              Inc(iAdjustOBPos);
            if FSQLValuesPos = 0 then
              Inc(iAdjustValuesPos);
          end;
        end;
        if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName and
           (iFromStartedPos <> 0) and (iFromEndedPos = 0) and (FBraceLevel = 0) then
          iFromEndedPos := iPos - 1;
      end;
    'A' .. 'Z', 'a' .. 'z':
      if not FInComment1 and not FInComment2 and not FInStr1 and not FInStr2 and not FInName and
         (FBraceLevel = 0) and ((iPos = 1) or (FDestination[iPos - 1] <= ' ')) then begin
        if lFirstWord then begin
          iCmdStartedPos := iPos;
          repeat
            Inc(iPos);
          until (iPos > Length(FDestination)) or
                not (FDestination[iPos] in ['A' .. 'Z', 'a' .. 'z']);
          FSQLCommandKind := FConnMetadata.GetSQLCommandKind(
            UpperCase(Copy(FDestination, iCmdStartedPos, iPos - iCmdStartedPos)));
          Dec(iPos);
        end
        else if (FSQLCommandKind in [skSelect, skSelectForUpdate]) and
                (FSQLFromValue = '') and (iFromStartedPos = 0) and ((ch = 'F') or (ch = 'f')) and
                (CompareText(Copy(FDestination, iPos, 4), 'FROM') = 0) then begin
          Inc(iPos, 4);
          while (iPos <= Length(FDestination)) and
                (FDestination[iPos] in [' ', #13, #10, #7]) do
            Inc(iPos);
          if iPos <= Length(FDestination) then begin
            iFromStartedPos := iPos;
            while FDestination[iPos] = FNameDelim1 do begin
              repeat
                Inc(iPos);
              until (iPos > Length(FDestination)) or
                    (FDestination[iPos] in [FNameDelim2, #0]);
              if (iPos <= Length(FDestination)) and
                 (FDestination[iPos] = FNameDelim2) then begin
                Inc(iPos);
                if (iPos <= Length(FDestination)) and (FDestination[iPos] = '.') then
                  Inc(iPos)
                else
                  Break;
              end
              else
                Break;
            end;
          end;
          Dec(iPos);
        end
        else if (FSQLOrderByPos = 0) and ((ch = 'O') or (ch = 'o')) and
                (CompareText(Copy(FDestination, iPos, 8), 'ORDER BY') = 0) then begin
          FSQLOrderByPos := iPos;
          Inc(iPos, 7);
        end
        else if (FSQLValuesPos = 0) and ((ch = 'V') or (ch = 'v')) and
                (CompareText(Copy(FDestination, iPos, 6), 'VALUES') = 0) then begin
          FSQLValuesPos := iPos;
          Inc(iPos, 5);
        end;
        lFirstWord := False;
      end;
    else
      if (ch = '"') and (FNameDelim1 <> '"') then begin
        if not FInComment1 and not FInComment2 and not FInName and not FInStr1 then
          FInStr2 := not FInStr2;
      end
      else if ch = FNameDelim1 then
        if FNameDelim1 = FNameDelim2 then
          FInName := not FInName
        else
          FInName := True
      else if ch = FNameDelim2 then
        if FNameDelim1 = FNameDelim2 then
          FInName := not FInName
        else
          FInName := False;
    end;
    Inc(iPos);
  end;
  if iFromStartedPos <> 0 then begin
    if iFromEndedPos = 0 then
      iFromEndedPos := iPos - 1;
    FSQLFromValue := Copy(FDestination, iFromStartedPos, iFromEndedPos - iFromStartedPos + 1);
  end;
  if FSQLOrderByPos <> 0 then
    Inc(FSQLOrderByPos, iAdjustOBPos);
  if FSQLValuesPos <> 0 then
    Inc(FSQLValuesPos, iAdjustValuesPos);
end;

end.
