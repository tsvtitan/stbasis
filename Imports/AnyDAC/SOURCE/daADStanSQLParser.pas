{ --------------------------------------------------------- }
{ MetaBase                                                  }
{ Copyright (c) 1996-2003 by gs-soft ag                     }
{                                                           }
{ All rights reserved.                                      }
{ --------------------------------------------------------- }
{$I daAD.inc}

unit daADStanSQLParser;

interface

uses Classes, SysUtils;

{

-----------------------------------------------------------------------------------
TSQLFileParserGS is parsing a Stringlist into individual SQL commands.

Comments are removed:

- Areas starting with '--' until end of line
- Areas starting with '/*' until end of comment

a comment is not removed if it starts with '+' (= optimizer hint)
e.g. '/*+' or '--+'

-----------------------------------------------------------------------------------
The parser allows to add the following meta-commands within SQL comments

SQLERROR_ALLOW_NEXT      Allows the next statement to raise a silent error
                         e.g. Drop Table if you are not sure that the table exists
                         (switches the AErrorAllowed for one statment)

SQLERROR_ALLOW_ON        Begin of a section that allows SQL Errors e.g. a set
                         of Drop Commands
                         (switches the AErrorAllowed until OFF)

SQLERROR_ALLOW_OFF       End of this section

DELIMITER                defines the delimiter of a SQL Command (default ';')
                         for parsing the statements

INCLUDE                  includes the contents of another File at this place

SKIP_NEXT_COMMAND        the next SQL command will be skipped


-----------------------------------------------------------------------------------
Examples 1: Drop a table that could not exist with raising an error

-- $DEFINE SQLERROR_ALLOW_NEXT
DROP TABLE D_IPS_SETS;


-----------------------------------------------------------------------------------
Examples 2: Drop a set of tables that could not exist with raising an error

-- $DEFINE SQLERROR_ALLOW_ON
DROP TABLE D_IPS_SETS1;
DROP TABLE D_IPS_SETS2;
DROP TABLE D_IPS_SETS3;
-- $DEFINE SQLERROR_ALLOW_OFF


-----------------------------------------------------------------------------------
Examples 3: Change the delimiter in order to parse Triggers or Procedures

CREATE ...
-- $DEFINE DELIMITER /
DECLARE
  CURSOR curDAT IS SELECT Count(*) FROM D_IPS_LF_DIM_IST_SchulOB;
  iCount INTEGER;
BEGIN
  OPEN curDAT;
...
END;
/
-- $DEFINE DELIMITER ;
update D_ .....


-----------------------------------------------------------------------------------
Examples 4: Include otherfiles and keep the syntax consistent with e.g. ORACLE SQLPlus

$define INCLUDE c:\myscript1.sql
$define SKIP_NEXT_COMMAND
@@c:\myscript1.sql

- our parser will run INCLUDE c:\myscript1.sql and skip @@c:\myscript1.sql
- SQLPlus will just run @@c:\myscript1.sql

}

{ ---------------------------------------------------------------------------- }
type
  TSQLErrorAllowedTypeGS= (SQLErrAllowAll,SQLErrAllowNone,SQLErrAllowNext);

  TSQLFileParserGS = class(TObject)
  private
    FSQLStrings: TStringList;
    FSQLFileName: String;
    FDelimiter: String;
    FStartLineNr: integer;
    FEndLineNr: integer;
    fCurrentSQLStmtStartLineNr: integer;
    FSQLServerControlString: String;
    FSQLErrorAllowed: Boolean;
    FSkipNextCommand: Boolean;
    FIncludeComment: Boolean;
    FInComment: Boolean;
    FInString: Boolean;
    FSQLErrorAllowedType: TSQLErrorAllowedTypeGS;
    FIsOpen: Boolean;
    procedure FreeSQLStrings;
    procedure CheckOpen;
    procedure CheckClosed;
    procedure ResetLineCounters;
    function StrippedStringLine(ALine:string):string;
    function IsEmptyLine(ALineNr: integer): boolean;
    function IsCommentStartinLine(ALine:string): integer;
    function IsCommentEndinLine(ALine:string): integer;
    function IsComment(ALine:string):boolean;
    function IsCommentLine(ALineNr: integer): boolean;
    procedure SetSQLFileName(AValue: string);
    procedure SetDelimiter(AValue: string);
    procedure ApplySettings(ATextLine:string);
    procedure GetSettings;
    procedure IncludeFile(APath:string);
    function IsDelimiter(ALine:String):Boolean;
    function FindAndCut(const ASearch: String; var AText:string): Boolean;
    procedure GetNextSQLStmtInternal(ATargetStrings: TStrings; var AEOF: boolean; var AErrorAllowed: Boolean);
    procedure SetSQLErrorAllowed(const Value: Boolean);
    procedure SetSQLErrorAllowedType(const Value: TSQLErrorAllowedTypeGS);
    property SQLErrorAllowedType: TSQLErrorAllowedTypeGS read FSQLErrorAllowedType write SetSQLErrorAllowedType;
  public
    constructor Create;
    destructor Destroy; override;
    property StartLineNr: integer read FStartLineNr write FStartLineNr;
    property SQLFileName: string read FSQLFileName write SetSQLFileName;
    property SQLDelimiter: string read FDelimiter write SetDelimiter;
    property SQLServerControlString: String read FSQLServerControlString write FSQLServerControlString;
    property SQLErrorAllowed: Boolean read FSQLErrorAllowed write SetSQLErrorAllowed;
    property SkipNextCommand: Boolean read FSkipNextCommand write FSkipNextCommand;
    property IncludeComment: Boolean read FIncludeComment write FIncludeComment;
    property IsOpen: Boolean read FIsOpen;
    property SQLStrings: TStringList read FSQLStrings;
    procedure GetFirstComment(ATargetStrings: TStrings);
    procedure GetNextSQLStmt(ATargetStrings: TStrings; var AEOF: boolean; var AErrorAllowed: Boolean);
    procedure InitFromSQLString(ASQLStrings: TStrings);
    procedure Open;
    procedure Close;
  end;

  ESQLFileParserError = class(Exception)
  end;

implementation

const
  C_SQLErrorAllow_Next = 'SQLERROR_ALLOW_NEXT';
  C_SQLErrorAllow_ON = 'SQLERROR_ALLOW_ON';
  C_SQLErrorAllow_OFF = 'SQLERROR_ALLOW_OFF';
  C_Define = '$DEFINE';
  C_Delimiter = 'DELIMITER';
  C_Include = 'INCLUDE';
  C_Skip_Next_Command = 'SKIP_NEXT_COMMAND';
  C_SQLServerControlString = 'SQL_SERVER_CONTROLSTRING';


{----------------------------------------------------------------------}
{ TSQLFileParserGS                                                     }
{----------------------------------------------------------------------}
constructor TSQLFileParserGS.Create;
begin
  inherited;
  FSQLServerControlString:='';
  FDelimiter:=';';
  FIncludeComment:= False;
  FInComment:= False;
  FIsOpen:= False;
  SQLErrorAllowedType:= SQLErrAllowNone;
end;

{----------------------------------------------------------------------}
destructor TSQLFileParserGS.Destroy;
begin
  FreeSQLStrings;
  inherited destroy;
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.FreeSQLStrings;
begin
  FreeAndNil(FSQLStrings);
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.SetSQLErrorAllowed(const Value: Boolean);
begin
  FSQLErrorAllowed := Value;
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.SetSQLErrorAllowedType(
  const Value: TSQLErrorAllowedTypeGS);
begin
  FSQLErrorAllowedType := Value;
  case FSQLErrorAllowedType of
    SQLErrAllowAll: FSQLErrorAllowed:= True;
    SQLErrAllowNone: FSQLErrorAllowed:= False;
    SQLErrAllowNext: FSQLErrorAllowed:= True;
  end
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.SetSQLFileName(AValue: string);
begin
  CheckClosed;
  FSQLFileName:= AValue;
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.SetDelimiter(AValue: string);

begin
  CheckClosed;
  FDelimiter:=AValue;
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.CheckClosed;
begin
  if Assigned(FSQLStrings) then
    raise ESQLFileParserError.Create('TSQLFileParserGS: File has to be closed for this action!');
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.CheckOpen;
begin
  if not Assigned(FSQLStrings) then
    raise ESQLFileParserError.Create('TSQLFileParserGS: File has to be open for this action!');
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.ResetLineCounters;
begin
  FStartLineNr:= 0;
  FEndLineNr:= -1;
  fCurrentSQLStmtStartLineNr:= 0;
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.Close;
begin
  FIsOpen:= False;
  FreeSQLStrings;
  ResetLineCounters;
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.Open;
begin
  Close;
  if not FileExists(FSQLFileName) then
    raise ESQLFileParserError.Create('TSQLFileParserGS: File '+FSQLFileName+' does not exist!');
  FSQLStrings:= TStringList.Create;
  FSQLStrings.LoadFromFile(FSQLFileName);
  FIsOpen:= True;
  ResetLineCounters;
  GetSettings;
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.InitFromSQLString(ASQLStrings: TStrings);
begin
  Close;
  FSQLStrings:= TStringList.Create;
  FSQLStrings.Assign(ASQLStrings);
  FIsOpen:= True;
  ResetLineCounters;
  GetSettings;
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.GetFirstComment(ATargetStrings: TStrings);
var
  iStart, iEnd, i: integer;
begin
  CheckOpen;
  // ATargetStrings.Clear;
  iStart:= -1;
  for i:=0 to FSQLStrings.Count-1 do
  begin
    if IsEmptyLine(i) then system.continue;
    if IsCommentLine(i) then
    begin
      iStart:= i;
      system.break;
    end;
  end;
  if iStart=-1 then exit; // no comment found at the top
  iEnd:= iStart;
  for i:=iStart to FSQLStrings.Count-1 do
  begin
    if IsEmptyLine(i) or not IsCommentLine(i) then system.break;
    iEnd:= i
  end;
  for i:=iStart to iEnd do
    ATargetStrings.Append(FSQLStrings[i]);
end;

{----------------------------------------------------------------------}
procedure TSQLFileParserGS.GetNextSQLStmtInternal(ATargetStrings: TStrings; var AEOF: Boolean; var AErrorAllowed: Boolean);
var
  cLine: string;
  cCopyLine: string;
  iStartChar,iEndChar: integer;
begin
  CheckOpen;
  ATargetStrings.Clear;
  AEOF:= True;
  SkipNextCommand:= False;
  // search first non Comment or Empty line
  while (FStartLineNr<FSQLStrings.Count) and
        IsEmptyLine(FStartLineNr) do
    Inc(FStartLineNr);
  // finished?
  if FStartLineNr>=FSQLStrings.Count then exit;
  // search for end of command ...
  FEndLineNr:= FStartLineNr;

  ATargetStrings.BeginUpdate;
  ATargetStrings.Clear;

  FInComment:= False;
  FInString:= False;
  while (FEndLineNr<FSQLStrings.Count)do
  begin
    cLine:= Uppercase(FSQLStrings[FEndLineNr]);
    cCopyLine:= StrippedStringLine(cLine);

    iStartChar:= IsCommentStartinLine(cCopyLine);
    if iStartChar = 0 then
      iStartChar:= pos('--',cCopyLine)
    else
      FInComment:= True;

    if FInComment then
      iEndChar:= IsCommentEndinLine(cCopyLine)
    else
      iEndChar:= 0;
    if iEndChar > 0  then
       FInComment:= False;

    if FInComment and (iStartChar = 0) then
    begin
      cLine:= Uppercase(FSQLStrings[FEndLineNr]);
      ApplySettings(cLine);
      AErrorAllowed:= FSQLErrorAllowed;
    end else
    begin
      if (iStartChar = 0) and (iEndChar = 0) then
      begin
        if length(TrimLeft(FSQLStrings[FEndLineNr])) > 0 then
         ATargetStrings.Add(FSQLStrings[FEndLineNr]);
        if IsDelimiter(FSQLStrings[FEndLineNr]) then break;
      end
      else
      begin
        ApplySettings(cLine);
        AErrorAllowed:= FSQLErrorAllowed;

        cCopyLine:='';
        if iStartChar > 0 then
          cCopyLine:=  copy(FSQLStrings[FEndLineNr],1,iStartChar-1);
        if iEndChar > 0 then
        begin
          if iStartChar > 0 then
            cCopyLine:= cCopyLine+ copy(FSQLStrings[FEndLineNr],iEndChar+2,length(FSQLStrings[FEndLineNr]))
          else
            cCopyLine:= copy(FSQLStrings[FEndLineNr],iEndChar+2,length(FSQLStrings[FEndLineNr]));
        end;
        if length(TrimLeft(cCopyLine)) > 0 then
          ATargetStrings.Add(cCopyLine);
      end;
      if IsDelimiter(cCopyLine) then break;
    end;
    Inc(FEndLineNr);
  end;
  // Delete Delimiter out of text ATargetStrings
  if ATargetStrings.Count>0 then
  begin
    cCopyLine:= trim(ATargetStrings.Strings[ATargetStrings.Count-1]);
    if IsDelimiter(cCopyLine) then
      ATargetStrings.Strings[ATargetStrings.Count-1]:= copy(cCopyLine,1,length(cCopyLine)-length(SQLDelimiter));
  end;
  ATargetStrings.EndUpdate;
  // could be at the Emptyline or at EOF
  if FEndLineNr>=FSQLStrings.Count then
    FEndLineNr:= FSQLStrings.Count-1
  else begin
    inc(FEndLineNr);
    AEOF:= FEndLineNr>=FSQLStrings.Count;
  end;

  FCurrentSQLStmtStartLineNr:= FStartLineNr+1;
  FStartLineNr:= FEndLineNr;
end;

{ ---------------------------------------------------------------------------- }
function TSQLFileParserGS.IsDelimiter(ALine:String):Boolean;
var
  cLine: String;
begin
  cLine:= trim(ALine);
  Result:= False;
  if length(cLine) >= length(SQLDelimiter) then
    Result:= Uppercase(
      copy(cLine,(length(cLine)-length(SQLDelimiter))+1,length(cLine))) = Uppercase(SQLDelimiter);
end;

{----------------------------------------------------------------------}
function TSQLFileParserGS.IsEmptyLine(ALineNr: integer): boolean;
begin
  if Length(FSQLStrings[ALineNr])=0 then
  begin
    Result:= True;
    exit;
  end;
  Result:= Length(TrimRight(FSQLStrings[ALineNr]))=0;
end;

{----------------------------------------------------------------------}
function TSQLFileParserGS.IsCommentLine(ALineNr: integer): boolean;
var
  cLine: string;
begin
  cLine:= TrimLeft(FSQLStrings[ALineNr]);
  Result:= IsComment(cLine);
end;

{ ---------------------------------------------------------------------------- }
function TSQLFileParserGS.IsCommentStartinLine(ALine:string): integer;
begin
  Result:= Pos('/*',ALine);
  if (Result > 0) and (Result +1 <= length(ALine)) then
    if ALine[Result+1] = '+' then  Result := 0; // SQL Server Hint
end;

{ ---------------------------------------------------------------------------- }
function TSQLFileParserGS.IsCommentEndinLine(ALine:string): integer;
begin
  Result:= Pos('*/',ALine);
  if Result = 0 then
    Result:= Pos('*)',ALine);
end;

{ ---------------------------------------------------------------------------- }
function TSQLFileParserGS.IsComment(ALine: string): boolean;
begin
  Result:= (Copy(ALine,1,2)='--') or (Copy(ALine,1,2)='/*') or FInComment;
(*  if (Copy(ALine,1,2)='/*') then FInComment:= True else
  if (Copy(ALine,1,2)='(*') then FInComment:= True;
  if FInComment then if IsEndOfComment(ALine) then FInComment:= False;
  if Result then
    if FSQLServerControlString <>'' then
      Result:= not(pos(FSQLServerControlString,ALine) > 0);*)
end;

{ ---------------------------------------------------------------------------- }
function TSQLFileParserGS.FindAndCut(const ASearch: String; var AText:string): Boolean;
var
  iLeText: integer;
  iSearchPos: integer;
begin
  iLeText:= length(AText);
  iSearchPos:= pos(ASearch, Uppercase(AText));
  result:= (iSearchPos > 0);
  if Result then
    AText:= trim(copy(AText,iSearchPos+length(ASearch),iLeText));
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.GetSettings;
var
  oSettings: TStringlist;
  i: integer;
  cText: string;
  iLeText: integer;
  cDefPos: integer;
begin
  oSettings:= TStringlist.Create;
  try
    GetFirstComment(oSettings);
    for i:= 0 to oSettings.Count -1 do
    begin
      cText:= oSettings.Strings[i];
      cText:= trim(cText);
      if FindAndCut('/*',cText) then
      begin
        cDefPos:= pos('*/',cText);
        if cDefPos > 0 then
          cText:= copy(cText,1,cDefPos-1);
      end else
      FindAndCut('--',cText);
      iLeText:= length(cText);
      if iLeText > 0 then
      begin
        if (cText[1]='{') and (cText[iLeText]= '}') then
        begin
          ApplySettings(cText);
        end;
      end;
    end;
  finally
    oSettings.Free;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.ApplySettings(ATextLine: string);
var
  cText: string;
begin
  cText:= ATextLine;
  if FindAndCut(C_Define,cText) then
  begin
    if FindAndCut(C_Delimiter,cText) then
      FDelimiter:= copy(cText,1,length(cText))
    else if FindAndCut(C_SQLServerControlString,cText) then
      SQLServerControlString:= copy(cText,1,length(cText))
    else if FindAndCut(C_SQLErrorAllow_ON,cText) then
      SQLErrorAllowedType:= SQLErrAllowAll
    else if FindAndCut(C_SQLErrorAllow_OFF,cText) then
      SQLErrorAllowedType:= SQLErrAllowNone
    else if FindAndCut(C_SQLErrorAllow_Next,cText) then
    begin
      if SQLErrorAllowedType = SQLErrAllowNone then
      SQLErrorAllowedType:= SQLErrAllowNext;
    end
    else if FindAndCut(C_Skip_Next_Command,cText) then
      FSkipNextCommand:=True
    else if FindAndCut(C_Include,cText) then
      IncludeFile(copy(cText,1,length(cText)));
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.IncludeFile(APath: string);
var
  oInclude: TStringlist;
  cFilePath: String;
  cInitialDir: String;
  i: Integer;
begin
  cInitialDir:= ExtractFilePath(SQLFileName);
  cFilePath:= StringReplace(APath,'/','\',[rfReplaceAll]);
  if not FileExists(cFilePath) then
  begin
    if cFilePath[1]='\' then
      cFilePath:= copy(cFilePath,2,Length(cFilePath));
    if cInitialDir[length(cInitialDir)]='\' then
      cInitialDir:= copy(cInitialDir,1,length(cInitialDir)-1);
    cFilePath:= cInitialDir +'\'+cFilePath;
  end;
  oInclude:= TStringlist.Create;
  try
    oInclude.LoadFromFile(cFilePath);
    for i := 0 to oInclude.Count-1 do
      FSQLStrings.Insert(FEndLineNr+i+1,oInclude.Strings[i]);
    //insert a empty line to make assure it is a empty line after the included script.
    FSQLStrings.Insert(FEndLineNr+oInclude.Count+1,'');
    FStartLineNR:= FEndLineNr+1;
  finally
    oInclude.Free;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TSQLFileParserGS.GetNextSQLStmt(ATargetStrings: TStrings;
  var AEOF, AErrorAllowed: Boolean);
begin
  repeat
    if SQLErrorAllowedType =  SQLErrAllowNext then
      SQLErrorAllowedType:= SQLErrAllowNone;
    GetNextSQLStmtInternal(ATargetStrings,AEOF, AErrorAllowed);
  until not SkipNextCommand;
end;

{ ---------------------------------------------------------------------------- }
function TSQLFileParserGS.StrippedStringLine(ALine: string): string;
var
  i:integer;
begin
  Result:='';
  for i:= 1 to length(ALine) do
  begin
   if ALine[i] = #39 then FInString:= not FInString;
   if FInString then
     Result:=Result+' '
   else
     Result:=Result+ALine[i];
  end;
end;


end.
