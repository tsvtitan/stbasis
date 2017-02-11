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

unit zluSQL;

interface

uses
  Classes, Windows, SysUtils, Registry, Dialogs, Forms, Messages, Controls,
  IBDatabase, IBCustomDataset, IBDatabaseInfo;

type
  TISQLExceptionCode = (eeInitialization, eeInvDialect, eeFOpen, eeParse,
                        eeCreate, eeConnect, eeStatement,
                        eeCommit, eeRollback, eeDDL, eeDML, eeQuery, eeFree,
                        eeUnsupt);

  EISQLException = class(Exception)
  private
    FExceptionCode: TISQLExceptionCode;
    FErrorCode: Integer;
    FExceptionData: String;
  public
    constructor Create (ErrorCode: Integer;
                        ExceptionData: String;
                        ExceptionCode: TISQLExceptionCode;
                        Msg: String);
  published
    property ExceptionCode: TISQLExceptionCode read FExceptionCode;
    property ExceptionData: String read FExceptionData;
    property ErrorCode: Integer read FErrorCode;
  end;

  TISQLAction = (actInput, actOutput, actCount, actEcho, actList, actNames, actPlan,
                 actStats, actTime, actUnk, actUnSup, actDialect, actAutoDDL);

  TSQLEvent = (evntDrop, evntAlter, evntConnect, evntCreate, evntTransaction,
               evntUnk, evntDialect, evntRows, evntISQL);

  TSQLSubEvent = (seTable, seTrigger, seProcedure, seDomain, seFilter, seFunction,
                  seException, seDatabase, seUnk, seView, seRole, seGenerator,
                  seDialect1, seDialect2, seDialect3, seAutoDDL);

  TDataOutput = procedure (const Info: String) of object;

  TISQLEvent = procedure (const ISQLEvent: TSQLEvent; const ISQLSubEvent: TSQLSubEvent;
                          const Data: variant; const Database: TIBDatabase) of object;

  TQueryStats = record
    Plan,
    Query: String;
    TimePrepare,
    TimeExecute: TDateTime;
    Rows: Integer;
    Buffers,
    Reads,
    Writes,
    Fetches,
    MaxMem,
    StartMem,
    EndMem: longint;
  end;

  TIBSQLObj = class (TComponent)
  private
    FStatistics: TStringList;
    FQuery: TStrings;
    FDatabase: TIBDatabase;
    FDataSet: TIBDataset;
    FDataOutput: TDataOutput;
    FISQLEvent: TISQLEvent;
    FProgressEvent: TNotifyEvent;
    FDefaultTransIDX,
    FDDLTransIDX,
    FStatements: integer;
    FStatsOn,
    FCanceled,
    FAutoDDL: boolean;
    FQueryStats: TQueryStats;
    FDBInfo: TIBDatabaseInfo;

    procedure GetEvent(const Query: String; out event: TSQLEvent;
      out sEvent: TSQLSubEvent);
    function ParseSQL(const InputSQL: TStringList; out Data: TStringList;
      const TermChar: String): boolean;
    function ParseDBCreate (const InputSQL: String; out DBName: String;
      out Params: String): boolean;
    function ParseDBConnect (const InputSQL: String; out DBName: String;
      out Params: TStringList): boolean;
    function ParseClientDialect (const InputSQL: String): Integer;
    function IsISQLCommand (const InputSQL: String; out Data: Variant): TISQLAction;
    function ParseOnOff (const InputSQL, Item: String): Boolean;

  published
    property DefaultTransIDX: integer read FDefaultTransIDX write FDefaultTransIDX;
    property DDLTransIDX: integer read FDDLTransIDX write FDDLTransIDX;    
    property AutoDDL: boolean read FAutoDDL write FAutoDDL;
    property Query: TStrings read FQuery write FQuery;
    property Database: TIBDatabase read FDatabase write FDatabase;
    property Dataset: TIBDataSet read FDataset write FDataset;
    property Statements: Integer read FStatements;
    property Statistics: boolean read FStatsOn write FStatsOn;
    property StatisticsList: TStringList read FStatistics;
    property OnDataOutput: TDataOutput read FDataOutput write FDataOutput;
    property OnISQLEvent: TISQLEvent read FISQLEvent write FISQLEvent;
    property OnQueryProgress: TNotifyEvent read FProgressEvent write FProgressEvent;

  public
    constructor Create (AComponent: TComponent); override;
    destructor Destroy; override;
    procedure DoISQL;
    procedure DoPrepare;
    procedure Cancel;
  end;

implementation

uses
  IBSql, stdctrls, zluGlobal, dmuMain, IBHeader, frmuMessage;

procedure TIBSQLObj.GetEvent (const Query: String; out event: TSQLEvent; out sEvent: TSQLSubEvent);
var
  str: String;
begin
  str := AnsiUpperCase(Query);
  if Pos ('CREATE', Str) = 1 then
  begin
    event := evntCreate;
    Delete (str, 1, Length('CREATE')+1);
  end
  else
  begin
    if Pos ('DROP', str) = 1 then
    begin
      event := evntDrop;
      Delete (str, 1, Length ('DROP')+1);
    end
    else
    begin
      if Pos ('ALTER', str) = 1 then
      begin
        event := evntALTER;
        Delete (str, 1, Length ('ALTER')+1);
      end
      else
      begin
        event := evntUnk;
        sEvent := seUnk;
        exit;
      end;
    end
  end;

  if Pos ('VIEW', str) = 1 then
  begin
    sEvent := seView;
    exit;
  end;
  if Pos ('TABLE', str) = 1 then
  begin
    sEvent := seTable;
    exit;
  end;
  if Pos ('PROCEDURE', str) = 1 then
  begin
    sEvent := seProcedure;
    exit;
  end;
  if Pos ('DOMAIN', str) = 1 then
  begin
    sEvent := seDomain;
    exit;
  end;
  if Pos ('EXTERNAL', str) = 1 then
  begin
    sEvent := seFunction;
    exit;
  end;
  if Pos ('FILTER', str) = 1 then
  begin
    sEvent := seFilter;
    exit;
  end;
  if Pos ('EXCEPTION', str) = 1 then
  begin
    sEvent := seException;
    exit;
  end;
  if Pos ('ROLE', str) = 1 then
  begin
    sEvent := seRole;
    exit;
  end;
  if Pos ('GENERATOR', str) = 1 then
  begin
    sEvent := seGenerator;
    exit;
  end;
  if Pos ('TRIGGER', str) = 1 then
  begin
    sEvent := seTrigger;
    exit;
  end;
  sEvent := seUnk;
end;


function TIBSQLObj.ParseSQL(const InputSQL: TStringList; out Data: TStringList;
  const TermChar: string): boolean;

var
  lTermLen,
  lDelimPos,
  lLineLen,
  lSrc_Cnt: Integer;

  done,
  inStatement,
  inComment: boolean;

  lTmp,
  lLine,
  lTermChar: String;


begin
  lTermChar := TermChar;
  inComment := false;
  lSrc_Cnt := 0;
  result := true;
  done := false;
  while not done and (lSrc_Cnt < InputSQL.Count) do
  begin
    Application.ProcessMessages;
    { If the line is blank, skip it }
    if Length (Trim (InputSQL.Strings[lSrc_Cnt])) = 0 then
    begin
      Inc (lSrc_Cnt);
      Continue;
    end;

    { If the current line contains only a close comment, append it to the last
      line }
    if Trim(InputSQL.Strings[lSrc_Cnt]) = '*/' then
    begin
      Data.Strings[Data.Count-1] := Format('%s%s', [Data.Strings[Data.Count-1],
        InputSQL.Strings[lSrc_Cnt]]);
      Inc(lSrc_Cnt);
      Continue;
    end;

    { Next, check to see if the line is a comment or starts one.
      If it does, then remove it }
    lDelimPos := AnsiPos('/*', Trim(InputSQL.Strings[lSrc_Cnt]));
    if  lDelimPos = 1 then
    begin
      { since this line contains a comment character, save anything to the
        left of the comment (if applicable) }
      if AnsiPos('*/', InputSQL.Strings[lSrc_Cnt]) = 0 then
        inComment := true;

      { If the line above started a comment, then keep going until the
        comment is completed }
      while inComment do
      begin
        repeat
          Application.ProcessMessages;
          Inc (lSrc_Cnt);
          if (lSrc_Cnt = InputSQL.Count) then
          begin
            result := false;
            done := true;
            continue;
          end;
        until (AnsiPos('*/', InputSQL.Strings[lSrc_Cnt]) <> 0);

        { if there is something after the comment, save it }
        lDelimPos := AnsiPos('*/', InputSQL.Strings[lSrc_Cnt]);
        lLine := Format('%s %s', [lLine, Copy (InputSQL.Strings[lSrc_cnt],
          lDelimPos+2, Length(InputSQL.Strings[lSrc_Cnt]))]);
        inComment := false;
      end;
      Inc (lSrc_Cnt);
      Continue;
    end;

    { Is the delimiter being changed? }
    if AnsiPos ('SET TERM', AnsiUpperCase(Trim(InputSQL.Strings[lSrc_Cnt]))) = 1 then
    begin
      lTmp := Trim(InputSQL.Strings[lSrc_Cnt]);
      Delete (lTmp, 1, Length('SET TERM'));
      lTmp := Trim(lTmp);
      lDelimPos := Pos (lTermChar, lTmp);
      Delete (lTmp, lDelimPos, Length(lTermChar));
      lTermChar := Trim(lTmp);
      lTmp := '';
      Inc (lSrc_Cnt);
      Continue;
    end;

    { If the delimiter is at the end of the line, or if a comment exists
       after the delimiter, then this is an entire statement.  If there is
       a comment after the delimiter, remove it }
    lDelimPos := AnsiPos (lTermChar, Trim(InputSQL.Strings[lSrc_Cnt]));
    lTermLen := Length (lTermChar);
    lLineLen := Length (Trim(InputSQL.Strings[lSrc_Cnt]));
    
    if (lDelimPos = (lLineLen - (lTermLen - 1))) or
       (AnsiPos ('/*', InputSQL.Strings[lSrc_Cnt]) > lDelimPos) then
    begin
      lLine := Trim(Format('%s %s',[lLine, InputSQL.Strings[lSrc_Cnt]]));
      Delete (lLine, lDelimPos, lTermLen);

      { Make sure that the line isn't blank after removing the terminator.
        Some case tools print too many termination characters }
      if Length(Trim(lLine)) <> 0 then
         Data.Append (Trim(lLine));
      lLine := '';
      Inc(lSrc_Cnt);
    end
    else
    begin
      { This statement spans multiple lines, so concatenate the lines into 1
        adding a CR/LF between the lines to ensure that the source looks
        as it was added }
      inStatement := true;
      lLine := Format('%s %s',[lLine, InputSQL.Strings[lSrc_Cnt]]);
      repeat
        Application.ProcessMessages;
        Inc (lSrc_Cnt);
        if (lSrc_Cnt = InputSQL.Count) then
        begin
          result := true;
          done := true;
          instatement := false;
          continue;
        end;
        { Blank line }
        if Length (Trim (InputSQL.Strings[lSrc_Cnt])) = 0 then
          Continue;

        lDelimPos := AnsiPos (lTermChar, InputSQL.Strings[lSrc_Cnt]);
        lLineLen := Length (InputSQL.Strings[lSrc_Cnt]);
        if (lDelimPos = (lLineLen - (lTermLen - 1))) or
           ((lDelimPos > 0) and
            (AnsiPos ('/*', InputSQL.Strings[lSrc_Cnt]) > lDelimPos)) then
          inStatement := false;
        lLine := lLine + #13#10 + InputSQL.Strings[lSrc_Cnt];
      until not inStatement;

      { Remove the termination character }
      lDelimPos := AnsiPos (lTermChar, lLine);
      Delete (lLine, lDelimPos, lTermLen);

      { Make sure that the line isn't blank after removing the terminator.
        Some case tools print too many termination characters }
      if Length(Trim(lLine)) <> 0 then
        Data.Append (Trim(lLine));

      lLine := '';
      Inc (lSrc_Cnt);
    end;
  end; { while }
end;

function TIBSQLObj.ParseDBCreate (const InputSQL: String; out DBName: String; out Params: String): boolean;
var
  lCnt,
  lDelimPos,
  lStartPos: Integer;

  lLine,
  lTemp,
  QuoteChar: String;

begin

  lLine := Trim(InputSQL);

  (* Get the database name *)
  (* A database can be created using CREATE DATABASE or CREATE SCHEMA *)
  if Pos ('CREATE DATABASE', AnsiUpperCase(lLine)) = 1 then
    Delete (lLine, 1, Length ('CREATE DATABASE '))
  else
    Delete (lLine, 1, Length ('CREATE SCHEMA '));

  QuoteChar := Copy (lLine, 1, 1);

  lStartPos := 1;
  lDelimPos := 1;

  repeat
    Application.ProcessMessages;
    Delete (lLine, lStartPos, lDelimPos);
    lDelimPos := Pos (QuoteChar, lLine);
    lTemp := Copy (lLine, lStartPos, lDelimPos-1);
    DBName := DBName + lTemp;
  until (lLine[lDelimPos+1] in [#0, #13, #10, ' ']) or
        (lDelimPos = 0);

  if lDelimPos = 0 then
  begin
    result := false;
    exit;
  end;

  (* Remove the database name from the line *)
  Delete (lLine, lStartPos, lDelimPos);

  Params := ' '+lLine;

  for lCnt := 1 to Length(Params) do
    if Params[lCnt] = '"' then Params[lCnt] := '''';

  result := true;
end;

function TIBSQLObj.ParseDBConnect (const InputSQL: String; out DBName: String; out Params: TStringList): boolean;
var
  lDelimPos: Integer;

  lLine,
  lTemp,
  lParam,
  QuoteChar: String;

  isaRole: boolean;
begin

  lLine := Trim(InputSQL);
  isaRole := false;
  (* Get the database name *)
  Delete (lLine, 1, Length ('CONNECT '));
  QuoteChar := Copy (lLine, 1, 1);

  (* Connect statements don't require a quoted database name *)
  if (QuoteChar = '''') or (QuoteChar = '"') then
  begin
    lDelimPos := 1;

    repeat
      Application.ProcessMessages;
      lLine := Trim(lLine);
      Delete (lLine, 1, lDelimPos);
      lDelimPos := Pos (QuoteChar, lLine);
      lTemp := Copy (lLine, 1, lDelimPos-1);
      DBName := DBName + lTemp;
    until (lLine[lDelimPos+1] in [#0, #13, #10, ' ']) or
          (lDelimPos = 0);

    if lDelimPos = 0 then
    begin
      result := false;
      exit;
    end;
    (* Remove the database name from the line *)
    Delete (lLine, 1, lDelimPos);
  end
  else
  begin
    lDelimPos := Pos (' ', lLine);

    (* If there are no spaces on the line, then the only thing is the database
     * name
     *)
    if lDelimPos = 0 then
    begin
      DBName := lLine;
      result := true;
      exit;
    end;
    DBName := Copy (lLine, 1, lDelimPos-1);
    Delete (lLine, 1, lDelimPos);
  end;

  (* Get the parameters for connecting *)
  lLine := Trim(lLine);
  while Length (lLine) > 0 do
  begin
    Application.ProcessMessages;
    lDelimPos := Pos (' ', lLine);
    if lDelimPos = 0 then
    begin
      lTemp := Copy (lLine, 1, Length(lLine));
      lParam := lParam + ' ' + lTemp;
      Params.Append (lParam);
      break;
    end;
    lTemp := Copy (lLine, 1, lDelimPos-1);

    if AnsiSameText (lTemp, 'USER') or AnsiSameText (lTemp, 'USERNAME') then
      lParam := 'USER_NAME='
    else
    begin
      if AnsiSameText (lTemp, 'PASS') or AnsiSameText (lTemp, 'PASSWORD') then
        lParam := 'PASSWORD='
      else
      begin
        if AnsiSameText (lTemp, 'ROLE') then
        begin
          lParam := 'SQL_ROLE_NAME=';
          isaRole := true;
        end
        else
          if AnsiSameText (lTemp, 'CACHE') then
            lParam := 'NUM_BUFFERS='
      end;
    end;

    Delete (lLine, 1, lDelimPos);
    lLine := Trim(lLine);
    lDelimPos := Pos (' ', lLine);
    if lDelimPos = 0 then
      lDelimPos := Length(lLine)+1;

    lTemp := Copy (lLine, 1, lDelimPos-1);
    QuoteChar := Copy (lTemp, 1, 1);
    if (not isaRole) and
       ((QuoteChar = '''') or
        (QuoteChar = '"')) then
    begin
      { Delete the first quote }
      Delete (lTemp, 1, 1);
      { Delete the second }
      Delete (lTemp, Pos(QuoteChar, lTemp), 1);
    end;

    Delete (lLine, 1, lDelimPos);
    lLine := Trim(lLine);
    lParam := lParam + lTemp;
    Params.Append (lParam);
    Continue;
  end;

  result := true;
end;

function TIBSQLObj.ParseClientDialect (const InputSQL: String): Integer;
var
  lLine: String;
begin
  lLine := Trim(InputSQL);
  Delete (lLine, 1, Length ('SET SQL DIALECT '));
  result := StrToInt(lLine);
end;

function TIBSQLObj.ParseOnOff (const InputSQL, Item: String): Boolean;
var
  lLine: String;
begin
  lLine := Trim(AnsiUpperCase(InputSQL));
  Delete (lLine, 1, Length (Item+' '));

  if Pos ('ON', lLine) = 1 then
    result := true
  else
    if Pos ('OFF', lLine) = 1 then
      result := false
    else
      result := true;  (* default *)
end;

function TIBSQLObj.IsISQLCommand (const InputSQL: String; out Data: Variant): TISQLAction;
var
  lLine: String;

begin

  lLine := Trim(AnsiUpperCase(InputSQL));

  if (Pos ('BLOBDUMP', lLine) = 1) or
     (Pos ('EDIT', lLine) = 1) or
     (Pos ('EXIT', lLine) = 1) or
     (Pos ('HELP', lLine) = 1) or
     (Pos ('QUIT', lLine) = 1) or
     (Pos ('SHOW ',lLine) = 1) then
  begin
     result := actUnSup;
     exit;
  end;

  if (Pos ('IN ', lLine) = 1) or
     (Pos ('INPUT', lLine) = 1) or
     (Pos ('OUT ', lLine) = 1) or
     (Pos ('OUTPUT', lLine) = 1) then
  begin
    if (Pos ('I', lLine) = 1) then
      result := actInput
    else
      result := actOutput;

    (* grab the filename to read or output to *)
    Data := Copy (lLine, Pos (' ', lLine), Length(lLine));
    Data := Trim(Data);
    exit;
  end;

  if Pos('SET COUNT', lLine) = 1 then
  begin
    Data := ParseOnOff (lLine, 'SET COUNT');
    result := actCount;
    exit;
  end;

  if Pos('SET ECHO', lLine) = 1 then
  begin
    Data := ParseOnOff (lLine, 'SET ECHO');
    result := actEcho;
    exit;
  end;

  if Pos('SET LIST', lLine) = 1 then
  begin
    Data := ParseOnOff (lLine, 'SET LIST');
    result := actList;
    exit;
  end;

  if Pos('SET NAMES', lLine) = 1 then
  begin
    result := actNames;

    (* Grab the character set name *)
    Data := Copy (lLine, Length('SET NAMES '), Length(lLine));
    Data := Trim(Data);
    exit;
  end;

  if Pos('SET PLAN', lLine) = 1 then
  begin
    Data := ParseOnOff (lLine, 'SET PLAN');
    result := actPlan;
    exit;
  end;

  if Pos('SET STATS', lLine) = 1 then
  begin
    Data := ParseOnOff (lLine, 'SET STATS');
    result := actStats;
    exit;
  end;

  if Pos('SET TIME', lLine) = 1 then
  begin
    Data := ParseOnOff (lLine, 'SET TIME');
    result := actTime;
    exit;
  end;

    (* Setting the Client dialect *)
  if Pos ('SET SQL DIALECT', lLine) = 1 then
  begin
    Data := ParseClientDialect (lLine);
    Data := Trim(Data);
    result := actDialect;
    exit;
  end;

  if (Pos ('SET AUTODDL', lLine) = 1) or
     (Pos ('SET AUTO', lLine) = 1) then
  begin
    if Pos ('DDL', lLine) <> 0 then
      Data := ParseOnOff (lLine, 'SET AUTODDL')
    else
      Data := ParseOnOff (lLine, 'SET AUTO');
    result := actAutoDDL;
    exit;
  end;

  result := actUnk;
end;

procedure TIBSQLObj.DoISQL;
var
  ISQLObj: TIBSQLObj;
  retval,
  lCnt: integer;

  evnt: TSQLEvent;
  sEvent: TSQLSubEvent;

  Hour,
  Min,
  Sec,
  MSec: Word;

  Tmp,
  Params,
  DBName: String;

  NewSource : TStringList;

  Data,
  ParamList,
  Source: TStringList;

  TmpTransaction,
  DDLTransaction,
  QryTransaction: TIBTransaction;

  TmpQuery,
  DDLQuery,
  IBQuery: TIBSQL;

  ISQLValue: Variant;
  ISQLAction: TISQLAction;

  done,
  show_Plan,
  show_Stats,
  show_List,
  show_Count,
  show_Echo,
  show_time,
  Output: boolean;

  ClientDialect: Integer;
  CharSet: String;

  InputFile: TextFile;
  TmpTime: TDateTime;

  StartSecs,
  EndSecs : Comp;

begin
  TmpQuery := nil;
  DDLQuery := nil;
  IBQuery := nil;
  DDLTransaction := nil;
  TmpTransaction := nil;
  Data := TStringList.Create;
  Source := TStringList.Create;
  Source.AddStrings (FQuery);

  (* Defaults *)
  ClientDialect := gAppSettings[DEFAULT_DIALECT].Setting;
  CharSet := gAppSettings[CHARACTER_SET].Setting;

  if not ParseSQL (Source, Data, gAppSettings[ISQL_TERMINATOR].Setting) then
    raise EISQLException.Create (ERR_ISQL_ERROR, '', eeParse, 'Unable to parse script');

  FStatements := Data.Count - 1;
  Source.Free;

  try
    (* If the database was already assigned and attached to,
     * then create the components for the database
     *)
    if Assigned(Database.Handle) then
    begin
//      QryTransaction := Database.Transactions[FDefaultTransIDX];
      DDLTransaction := Database.Transactions[FDDLTransIDX];
      TmpTransaction := TIBTransaction.Create (nil);

      IBQuery := TIBSQL.Create (nil);
      DDLQuery:= TIBSQL.Create (nil);
      TmpQuery:= TIBSQL.Create (nil);

      TmpTransaction.DefaultDatabase := FDatabase;

      with IBQuery do
      begin
        Database := FDatabase;
        Transaction := Database.Transactions[FDefaultTransIDX];
        ParamCheck := false;
      end;

      with TmpQuery do
      begin
        Database := FDatabase;
        Transaction := TmpTransaction;
        ParamCheck := false;
      end;

      with DDLQuery do
      begin
        Database := FDatabase;
        Transaction := Database.Transactions[FDDLTransIDX];
        ParamCheck := false;
      end;
    end;
  except on E: Exception do
  begin
    raise EISQLException.Create (ERR_ISQL_ERROR, '', eeInitialization, E.Message);
  end;
  end;

  (* Go through the String list excecuting the information line by line.
   * Each statement is executed against the currently connected database
   * and server (if there is one).
   *)
  for lCnt := 0 to Data.Count-1 do
  begin
    if FCanceled then
      break;

    Application.ProcessMessages;
//    dlgProgress.DoStep;

    if Assigned(FProgressEvent) then
      OnQueryProgress(self);

    (* Is this an ISQL Command? *)
    IsqlAction := IsISQLCommand (Data.Strings[lCnt], IsqlValue);

    case ISQlAction of
      actInput:
      begin
        try
          AssignFile(InputFile, IsqlValue);
          Reset (InputFile);
          NewSource := TStringList.Create;
          while not SeekEof(InputFile) do
          begin
            Readln(InputFile, Tmp);
            NewSource.Append(Tmp);
          end;
        except on E: Exception do
          raise EISQLException.Create (ERR_FOPEN, ISQLValue, eeFopen, E.Message);
        end;
        ISQLObj := TIBSQLObj.Create (self);
        with ISQLObj do
        begin
          DefaultTransIDX := FDefaultTransIDX;
          DDLTransIDX := FDDLTransIDX;
          AutoDDL := FAutoDDL;
          Query := NewSource;
          Database := Self.FDatabase;
          DataSet := Self.FDataSet;
          OnDataOutput := Self.FDataOutput;
          OnISQLEvent := Self.OnISQLEvent;
          DoIsql;
          Free;
          NewSource.Free;          
        end;
        Continue;
      end;
      actOutput:
      begin
        Output := True;
      end;
      actCount:
      begin
        show_Count := ISQLValue;
        continue;
      end;

      actEcho:
      begin
        show_Echo := ISQLValue;
        continue;
      end;

      actList:
      begin
        show_List := ISQLValue;
        continue;
      end;

      actNames:
      begin
        Charset := ISQLValue;
        continue;
      end;

      actPlan:
      begin
        show_Plan := ISQLValue;
        continue;
      end;

      actStats:
      begin
        show_Stats := ISQLValue;
        continue;
      end;

      actTime:
      begin
        show_time := ISQLValue;
        continue;
      end;

      actDialect:
      begin
        ClientDialect := ISQLValue;
        if Assigned (Database) then
        try
          Database.SQLDialect := ClientDialect;
          if Assigned (OnISQLEvent) then
            case ClientDialect of
              1: OnISQLEvent (evntDialect, seDialect1, ClientDialect, Database);
              2: OnISQLEvent (evntDialect, seDialect2, ClientDialect, Database);
              3: OnISQLEvent (evntDialect, seDialect3, ClientDialect, Database);
            end;
        except
          on E: Exception do
          begin
            raise EISQLException.Create (ERR_ISQL_ERROR, IntToStr(ClientDialect),
                    eeInvDialect, E.Message);
          end;
        end;
        continue;
      end;

      actAutoDDL:
      begin
        FAutoDDL := ISQLValue;
        if Assigned (OnISQLEvent) then
          OnISQLEvent (evntISQL, seAutoDDL, FAutoDDL, Database);

        continue;
      end;

      actUnSup:
        Continue;
//        raise EISQLException.Create (ERR_ISQL_ERROR, '', eeUnsupt, Data.Strings[lCnt]);
    end;
    (* Does this line drop a database *)
    if (Pos ('DROP DATABASE', AnsiUpperCase(Data.Strings[lCnt])) = 1) then
    begin
      FDatabase.DropDatabase;
      if Assigned (OnISQLEvent) then
        OnISQLEvent (evntDrop, seDatabase, FDatabase.DatabaseName, Database);
      continue;
    end;

    (* Does this line create a database *)
    if (Pos ('CREATE DATABASE', AnsiUpperCase(Data.Strings[lCnt])) = 1) or
       (Pos ('CREATE SCHEMA', AnsiUpperCase(Data.Strings[lCnt])) = 1) then
    begin
      if not ParseDBCreate (Data.Strings[lCnt], DBName, Params) then
        raise EISQLException.Create (ERR_ISQL_ERROR, '', eeParse, 'An error occured parsing CREATE statement.')
      else
      begin
        try
          try
            FDatabase.CheckInactive;
          except
            on E: Exception do
            begin
              if FDatabase.Transactions[FDefaultTransIDX].InTransaction then
                raise EISQLException.Create (ERR_ISQL_ERROR, DBName, eeConnect,
                  E.Message+#13#10'Commit or Rollback the current transaction')
              else
                FDatabase.Close;
            end;
          end;

          FDatabase.DatabaseName := DBName;
          FDatabase.SQLDialect := ClientDialect;
          FDatabase.Params.Text := Params;

          FDatabase.LoginPrompt := false;
          FDatabase.CreateDatabase;

          QryTransaction := TIBTransaction.Create (nil);
          DDLTransaction := TIBTransaction.Create (nil);
          TmpTransaction := TIBTransaction.Create (nil);

          FDefaultTransIDX := FDatabase.AddTransaction (QryTransaction);
          FDDLTransIDX := FDatabase.AddTransaction (DDLTransaction);
          FDatabase.AddTransaction (TmpTransaction);

          QryTransaction.DefaultDatabase := FDatabase;
          DDLTransaction.DefaultDatabase := FDatabase;
          TmpTransaction.DefaultDatabase := FDatabase;

          IBQuery := TIBSQL.Create (nil);
          DDLQuery:= TIBSQL.Create (nil);
          TmpQuery:= TIBSQL.Create (nil);

          with IBQuery do
          begin
            Database := FDatabase;
            Transaction := QryTransaction;
            ParamCheck := false;
          end;

          with TmpQuery do
          begin
            Database := FDatabase;
            Transaction := TmpTransaction;
            ParamCheck := false;
          end;

          with DDLQuery do
          begin
            Database := FDatabase;
            Transaction := DDLTransaction;
            ParamCheck := false;
          end;

          FDatabase.Open;
          if Assigned (OnISQLEvent) then
            OnISQLEvent (evntCreate, seDatabase, DBName, FDatabase);
        except
          on E: Exception do
          raise EISQLException.Create (ERR_ISQL_ERROR, DBName, eeCreate, E.Message);
        end;
      end;
      Continue;
    end;

    (* Does this line connect to a database *)
    if Pos ('CONNECT', AnsiUpperCase(Data.Strings[lCnt])) = 1 then
    begin
      ParamList := TStringList.Create;
      if not ParseDBConnect (Data.Strings[lCnt], DBName, ParamList) then
        raise EISQLException.Create (ERR_ISQL_ERROR, '', eeParse, 'An error occured parsing CONNECT statement.')
      else
      begin
        try
          try
            FDatabase.CheckInactive;
          except
            on E: Exception do
            begin
              if FDatabase.Transactions[FDefaultTransIDX].InTransaction then
                raise EISQLException.Create (ERR_ISQL_ERROR, DBName, eeConnect,
                  E.Message+#13#10'Commit or Rollback the current transaction')
              else
                FDatabase.Close;
            end;
          end;
          FDatabase.DatabaseName := DBName;
          if (charset <> '') and (charset <> 'NONE') then
            ParamList.Add ('lc_ctype='+charset);
          FDatabase.Params.Text := ParamList.Text;
          FDatabase.Params.Add(Format('isc_dpb_sql_dialect=%d',[ClientDialect]));
          ParamList.Free;
          FDatabase.LoginPrompt := false;
          FDatabase.SQLDialect := ClientDialect;
          FDatabase.Open;

          QryTransaction := TIBTransaction.Create (nil);
          DDLTransaction := TIBTransaction.Create (nil);
          TmpTransaction := TIBTransaction.Create (nil);

          FDefaultTransIDX := FDatabase.AddTransaction (QryTransaction);
          FDDLTransIDX := FDatabase.AddTransaction (DDLTransaction);
          FDatabase.AddTransaction (TmpTransaction);

          IBQuery := TIBSQL.Create (nil);
          DDLQuery:= TIBSQL.Create (nil);
          TmpQuery:= TIBSQL.Create (nil);

          QryTransaction.DefaultDatabase := FDatabase;
          DDLTransaction.DefaultDatabase := FDatabase;
          TmpTransaction.DefaultDatabase := FDatabase;

          with IBQuery do
          begin
            Database := FDatabase;

            if Assigned (FDataset) then
              Transaction := FDataset.Transaction
            else
              Transaction := QryTransaction;
            ParamCheck := false;
          end;

          with TmpQuery do
          begin
            Database := FDatabase;
            Transaction := TmpTransaction;
            ParamCheck := false;
          end;

          with DDLQuery do
          begin
            Database := FDatabase;
            Transaction := DDLTransaction;
            ParamCheck := false;
          end;

          if Assigned (OnISQLEvent) then
            OnISQLEvent (evntConnect, seDatabase, DBName, FDatabase);
        except
          on E: Exception do
            raise EISQLException.Create (ERR_ISQL_ERROR, DBName, eeConnect, E.Message);
        end;
      end;
      Continue;
    end;

    (* If it isn't any of the above, then execute the statement *)
    if not Assigned (IBQuery) then
      raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeStatement, 'No active connection');

    with IBQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add (Data.Strings[lCnt]);
      TmpQuery.SQL.Clear;
      TmpQuery.SQL.Add (Data.Strings[lCnt]);
      (* See if the statement is valid *)
      with TmpQuery do
      begin
        try
          if TmpTransaction.InTransaction then
            TmpTransaction.Commit;
          TmpTransaction.StartTransaction;
          Prepare;
          Close;
        except on E: Exception do
          begin
            TmpTransaction.Commit;
            Close;
            raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeStatement, E.Message);
          end;
        end;
        TmpTransaction.Commit;
      end;

      case TmpQuery.SQLType of
        SQLCommit:
        begin
          try
            if Assigned(Dataset) then
              Transaction := Dataset.Transaction;

            if Transaction.InTransaction then
              Transaction.Commit;

            if DDLTransaction.InTransaction then
              DDLTransaction.Commit;

            if Assigned(OnISQLEvent) then
              OnISQLEvent (evntTransaction, seUnk, false, Database);
              
          except on E: Exception do
            raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeCommit, E.Message);
          end;
        end;

        SQLRollback:
        begin
          try
            if Assigned(Dataset) then
              Transaction := Dataset.Transaction;
          
            if Transaction.InTransaction then
              Transaction.Rollback;

            if DDLTransaction.InTransaction then
              DDLTransaction.Rollback;

            if Assigned(OnISQLEvent) then
              OnISQLEvent (evntTransaction, seUnk, false, Database);

          except on E: Exception do
            raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeRollback, E.Message);
          end;
        end;

        SQLDDL, SQLSetGenerator:
        begin
          (* Use a different IBQuery since DDL can be set to autocommit *)
          DDLQuery.SQL.Clear;
          DDLQuery.SQL := SQL;
          with DDLQuery do begin
            try
              if not DDLTransaction.InTransaction then
                DDLTransaction.StartTransaction;
              Prepare;
              ExecQuery;
              if FAutoDDL then
                DDLTransaction.Commit;

              if Assigned (OnISQLEvent) then
              begin
                GetEvent (DDLQuery.SQL.Strings[0], evnt, sevent);
                OnISQLEvent (evnt, sEvent, DBName, Database);
              end;
               Close;
            except on E: Exception do
            begin
              Close;
              if FAutoDDL then
                DDLTransaction.Rollback;
              raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeDDL, E.Message);
            end;
            end;
          end;
        end;

        SQLDelete, SQLInsert, SQLUpdate:
        begin
          try
            if Assigned(Dataset) then
              Transaction := Dataset.Transaction;
              
            if not Transaction.InTransaction then
              Transaction.StartTransaction;

            StartSecs := 0;
            if FStatsOn then
            begin
              FDBInfo.Database := FDatabase;
              FQueryStats.StartMem := FDBInfo.CurrentMemory;
              FQueryStats.Query := SQL.Text;
              StartSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
            end;

            Prepare;

            if FStatsOn then
            begin
              EndSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
              TmpTime := TimeStampToDateTime(MSecsToTimeStamp(EndSecs - StartSecs));
              FQueryStats.TimePrepare := TmpTime;
              StartSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
            end;

            ExecQuery;

            FQueryStats.Plan := Plan;
            FQueryStats.Rows := IBQuery.RowsAffected;

            if FStatsOn then
            begin
              EndSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
              TmpTime := TimeStampToDateTime(MSecsToTimeStamp(EndSecs - StartSecs));
              FQueryStats.TimeExecute := TmpTime;
              FQueryStats.EndMem := FDBInfo.CurrentMemory;
              FQueryStats.MaxMem := FDBInfo.MaxMemory;
              FQueryStats.Buffers := FDBInfo.NumBuffers;
              FQueryStats.Reads := FDBInfo.Reads;
              FQueryStats.Writes := FDBInfo.Writes;
            end;

            if Assigned (OnISQLEvent) then
              OnISQLEvent(evntRows, seUnk, RowsAffected, Database);

            Close;
          except on E: Exception do
          begin
            Close;
            raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeDML, E.Message);
          end;
          end;
        end;

        SQLSelect, SQLSelectForUpdate, SQLExecProcedure:
        begin
          try
            if Assigned (DataSet) then
            begin
              if not Transaction.InTransaction then
                Transaction.StartTransaction;

              DataSet.Close;
              DataSet.SelectSQL.Text := SQL.Text;

              StartSecs := 0;
              if FStatsOn then
              begin
                FDBInfo.Database := FDatabase;
                FQueryStats.StartMem := FDBInfo.CurrentMemory;
                FQueryStats.Query := SQL.Text;
                StartSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
              end;

              DataSet.Prepare;

              if FStatsOn then
              begin
                EndSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
                TmpTime := TimeStampToDateTime(MSecsToTimeStamp(EndSecs - StartSecs));
                FQueryStats.TimePrepare := TmpTime;
                StartSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
              end;

              DataSet.Open;
              DataSet.FetchAll;
              FQueryStats.Plan := Dataset.QSelect.Plan;
              FQueryStats.Rows := Dataset.RecordCount;

              if FStatsOn then
              begin
                EndSecs := TimeStampToMSecs(DateTimeToTimeStamp(Time));
                TmpTime := TimeStampToDateTime(MSecsToTimeStamp(EndSecs - StartSecs));
                FQueryStats.TimeExecute := TmpTime;
                FQueryStats.EndMem := FDBInfo.CurrentMemory;
                FQueryStats.MaxMem := FDBInfo.MaxMemory;
                FQueryStats.Buffers := FDBInfo.NumBuffers;
                FQueryStats.Reads := FDBInfo.Reads;
                FQueryStats.Writes := FDBInfo.Writes;
              end;
            end
            else
            begin
              if not Transaction.InTransaction then
                Transaction.StartTransaction;
              Prepare;
              ExecQuery;
              Close;
            end;
          except
            on E: Exception do
              begin
                Close;
                raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeQuery, E.Message);
              end;
          end;
        end;
      end;
    end;
  end;
  
  try
    with FQueryStats do
    begin
      DecodeTime(TimeExecute, Hour, Min, Sec, MSec);
      FStatistics.Add(Format('Execution Time (hh:mm:ss.ssss)%s%.2d:%.2d:%.2d.%.4d',[DEL, Hour, Min, Sec, MSec]));
      DecodeTime(TimePrepare, Hour, Min, Sec, MSec);
      FStatistics.Add(Format('Prepare Time (hh:mm:ss.ssss)%s%.2d:%.2d:%.2d:%.4d',[DEL,Hour, Min, Sec, MSec]));
      FStatistics.Add(Format('Starting Memory%s%d',[DEL,StartMem]));
      FStatistics.Add(Format('Current Memory%s%d',[DEL,EndMem]));
      FStatistics.Add(Format('Delta Memory%s%d',[DEL,EndMem-StartMem]));
      FStatistics.Add(Format('Number of Buffers%s%d',[DEL, Buffers]));
      FStatistics.Add(Format('Reads%s%d',[DEL,Reads]));
      FStatistics.Add(Format('Writes%s%d',[DEL,Writes]));
      if Length(Plan) > 0 then
        FStatistics.Add(Format('Plan%s%s',[DEL, Plan]))
      else
        FStatistics.Add(Format('Plan%s%s',[DEL, 'Not Available']));
      FStatistics.Add(Format('Records Fetched%s%d',[DEL, Rows]));
    end;
    IBQuery.Free;
    FDatabase.RemoveTransaction (FDatabase.FindTransaction(TmpTransaction));
    TmpTransaction.Free;
  except
  on E: Exception do
    begin
      raise EISQLException.Create (ERR_ISQL_ERROR, '', eeFree, E.Message);
    end;
  end;
end;

procedure TIBSQLObj.Cancel;
begin
  FCanceled := true;
end;

constructor TIBSQLObj.Create(AComponent: TComponent);
begin
  inherited;
  FAutoDDL := true;
  FDBInfo := TIBDatabaseInfo.Create(nil);
  FStatistics := TStringList.create;
end;

procedure TIBSQLObj.DoPrepare;
var
  Data,
  Source: TStringList;

  lQry: TIBSql;
  lTrans: TIBTransaction;

  lCnt: integer;

begin
  Data := TStringList.Create;
  Source := TStringList.Create;
  Source.AddStrings (FQuery);

  (* Defaults *)
  if not ParseSQL (Source, Data,  gAppSettings[ISQL_TERMINATOR].Setting) then
    raise EISQLException.Create (ERR_ISQL_ERROR, '', eeParse, 'Unable to parse script');
  Source.Free;

  { Prepare each line and post results }
  lQry := TIBSql.Create(self);
  lTrans := TIBTransaction.Create(self);
  lTrans.DefaultDatabase := FDatabase;
  try
    with lQry do
    begin
      Transaction := lTrans;
      Database := FDatabase;
    end;

    for lCnt := 0 to Data.Count-1 do
    begin
      with lQry do
      begin
        SQL.Text := Data.Strings[lCnt];
        Transaction.StartTransaction;

        try
          Prepare;
        except on E: Exception do
          raise EISQLException.Create (ERR_ISQL_ERROR, Data.Strings[lCnt], eeStatement, E.Message);
        end;

        if Assigned (OnDataOutput) then
        begin
          OnDataOutput (Format('Statement: %s',[Data.Strings[lCnt]]));
          if Length(Plan) > 0 then
            OnDataOutput (Format('%s', [Plan]))
          else
            OnDataOutput ('Not Available')
        end;

        Transaction.Commit;
        Close;
      end;
    end;
  finally
    lQry.Free;
    lTrans.Free;
  end;
end;

{ EISQLException }
constructor EISQLException.Create(ErrorCode: Integer;
  ExceptionData: String; ExceptionCode: TISQLExceptionCode; Msg: String);
begin
  inherited Create (Msg);
  FExceptionData := ExceptionData;
  FExceptionCode := ExceptionCode;
  FErrorCode:= ErrorCode;
end;

destructor TIBSQLObj.Destroy;
begin
  FDBInfo.Free;
  FStatistics.Free;
  inherited;
end;

end.

