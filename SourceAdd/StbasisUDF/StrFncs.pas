unit StrFncs;

interface

uses
  SysUtils, Windows, Classes, StdFuncs, StdConsts, udf_glob;

function Character(var Number: Integer): PChar; cdecl; export;
function CRLF: PChar; cdecl; export;
{ Words are delimited by anything that's not an alphabetic. }
function FindNthWord(sz: PChar; var i: Integer): PChar; cdecl; export;
function FindWord(sz: PChar; var i: Integer): PChar; cdecl; export;
function FindWordIndex(sz: PChar; var i: Integer): Integer; cdecl; export;
function Left(sz: PChar; var Number: Integer): PChar; cdecl; export;
function LineWrap(sz: PChar; var Start, ColWidth: Integer): PChar; cdecl; export;
function lrTrim(sz: PChar): PChar; cdecl; export;
function lTrim(sz: PChar): PChar; cdecl; export;
function Mid(sz: PChar; var Start, Number: Integer): PChar; cdecl; export;
function PadLeft(sz, szPadString: PChar; var Len: Integer): PChar; cdecl; export;
function PadRight(sz, szPadString: PChar; var Len: Integer): PChar; cdecl; export;
function ProperCase(sz: PChar): PChar; cdecl; export;
function Right(sz: PChar; var Number: Integer): PChar; cdecl; export;
function rTrim(sz: PChar): PChar; cdecl; export;
function StringLength(sz: PChar): Integer; cdecl; export;
function StripString(sz, szCharsToStrip: PChar): PChar; cdecl; export;
function SubStr(szSubStr, szStr: PChar): Integer; cdecl; export;

{* ************************************************************************** *}
{* Some nice "data formatting routines"                                       *}
{* ************************************************************************** *}
{* Format a "name"                                                            *}
{* ************************************************************************** *}
function GenerateFormattedName(szFormatString, szNamePrefix, szFirstName,
  szMiddleInitial, szLastName, szNameSuffix: PChar): PChar; cdecl; export;
function InternalGenerateFormattedName(strFormatString: String;
  var strResult: String; strNamePrefix, strFirstName, strMiddleInitial,
  strLastName, strNameSuffix: String): Boolean;
function ValidateNameFormat(szFormatString: PChar): Integer; cdecl; export;

{* ************************************************************************** *}
{* Regular expressions!                                                       *}
{*     declared but not implemented yet....                                   *}
{* ************************************************************************** *}
function ValidateRegularExpression(sz: PChar): Integer; cdecl; export;
function ValidateStringInRE(sz, re: PChar): Integer; cdecl; export;

{* ************************************************************************** *}
{* Soundex function                                                           *}
{* ************************************************************************** *}
function GenerateSndxIndex(sz: PChar): PChar; cdecl; export; // ** NEW 6/11/98

implementation

const
  WordChars: TCharSet = ['0'..'9', 'A'..'Z', 'a'..'z'];

function Character(var Number: Integer): PChar;
var
  c: Char;
begin
  {$ifdef FULDebug}
  WriteDebug('Truncate() - Enter');
  {$endif}
  c := Char(Number);
  result := MakeResultString(@c, nil, 2);
  {$ifdef FULDebug}
  WriteDebug('Truncate() - Exit');
  {$endif}
end;

function CRLF: PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('CRLF() - Enter');
  {$endif}
  result := MakeResultString(StdConsts.CRLF, nil, 3);
  {$ifdef FULDebug}
  WriteDebug('CRLF() - Exit');
  {$endif}
end;

function FindNthWord(sz: PChar; var i: Integer): PChar;
var
  j, Len: Integer;
  str, res: String;
begin
  str := String(sz);
  res := '';
  Len := Length(str);
  j := 1;
  while (j <= Len) and
        (i > 0) do begin
    res := FindTokenStartingAt(String(sz), i, WordChars, True);
    Dec(i);
  end;
  result := MakeResultString(PChar(res), nil, 0);
end;

function FindWord(sz: PChar; var i: Integer): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('FindWord() - Enter');
  {$endif}
  Inc(i);
  result := MakeResultString(
    PChar(FindTokenStartingAt(String(sz), i, WordChars, True)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('FindWord() - Exit');
  {$endif}
end;

function FindWordIndex(sz: PChar; var i: Integer): Integer;
var
  Len, j: Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('FindWordIndex() - Enter');
  {$endif}
  j := i; Len := StrLen(sz);
  while (j < Len) and
        (not (sz[j] in WordChars)) do Inc(j);
  if (j = Len) then
    result := -1
  else
    result := j;
  {$ifdef FULDebug}
  WriteDebug('FindWordIndex() - Exit');
  {$endif}
end;

function Left(sz: PChar; var Number: Integer): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('Left() - Enter');
  {$endif}
  result := MakeResultString(PChar(Copy(String(sz), 1, Number)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('Left() - Exit');
  {$endif}
end;

function LineWrap(sz: PChar; var Start, ColWidth: Integer): PChar;
var
  i, j, len: Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('LineWrap() - Enter');
  {$endif}
  (*
   * 1. Get the length of the string.
   * 2. If "The rest" of the string is smaller than ColWidth, just return
   *    it.
   * 3. Otherwise, let 'j' be the end of the column, and decrement j to
   *    a word boundary.
   *    a. Find a word boundary.
   *    b. If j = i (meaning the word is too long), then the word has
   *       has to be chopped.
   *)
  len := StrLen(sz);                                                // (1)
  i := Start;
  if (len - i) <= ColWidth then                                     // (2)
    j := len - i
  else begin                                                        // (3)
    j := ColWidth + i - 1;
    while (j > i) and not (sz[j] in [' ', #9, #10, #13]) do Dec(j); // (a)
    if (j = i) then
      j := ColWidth                                                 // (b)
    else
      j := j - i + 1;
  end;
  result := MakeResultString(PChar(Copy(String(sz), i + 1, j)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('LineWrap() - Exit');
  {$endif}
end;

function lrTrim(sz: PChar): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('lrTrim() - Enter');
  {$endif}
  result := MakeResultString(PChar(Trim(String(sz))), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('lrTrim() - Exit');
  {$endif}
end;

function lTrim(sz: PChar): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('lTrim() - Enter');
  {$endif}
  result := MakeResultString(PChar(TrimLeft(String(sz))), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('lTrim() - Exit');
  {$endif}
end;

function Mid(sz: PChar; var Start, Number: Integer): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('Mid() - Enter');
  {$endif}
  result := MakeResultString(PChar(Copy(String(sz), Start + 1, Number)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('Mid() - Exit');
  {$endif}
end;

function PadLeft(sz, szPadString: PChar; var Len: Integer): PChar;
var
  str, strPad: String;
  LenPad, LenStr, i: Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('PadLeft() - Enter');
  {$endif}
  str := String(sz);             LenStr := Length(str);
  strPad := String(szPadString); LenPad := Length(strPad);
  if (LenStr < Len) and (LenPad <= Len - LenStr) then begin
    for i := 1 to (Len - LenStr) div LenPad do
      str := strPad + str;
  end;
  result := MakeResultString(PChar(str), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('PadLeft() - Exit');
  {$endif}
end;

function PadRight(sz, szPadString: PChar; var Len: Integer): PChar;
var
  str, strPad: String;
  LenPad, LenStr, i: Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('PadRight() - Enter');
  {$endif}
  str := String(sz);             LenStr := Length(str);
  strPad := String(szPadString); LenPad := Length(strPad);
  if (LenStr < Len) and (LenPad <= Len - LenStr) then begin
    for i := 1 to (Len - LenStr) div LenPad do
      str := str + strPad;
  end;
  result := MakeResultString(PChar(str), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('PadRight() - Exit');
  {$endif}
end;

function ProperCase(sz: PChar): PChar;
var
  rs: String;
  i, Len: Integer;
  bUpperCaseIt: Boolean;
begin
  {$ifdef FULDebug}
  WriteDebug('ProperCase() - Enter');
  {$endif}
  rs := '';
  Len := StrLen(sz);
  bUpperCaseIt := True;
  for i := 0 to Len - 1 do begin
    if ((sz[i] in ['A'..'Z','a'..'z'])
        and bUpperCaseIt) then begin
      rs := rs + UpperCase(sz[i]);
      bUpperCaseIt := False;
    end else if (sz[i] in ['A'..'Z','a'..'z','''']) then
      rs := rs + LowerCase(sz[i])
    else begin
      rs := rs + LowerCase(sz[i]);
      bUpperCaseIt := True;
    end;
  end;
  result := MakeResultString(PChar(rs), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('ProperCase() - Exit');
  {$endif}
end;

function Right(sz: PChar; var Number: Integer): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('Right() - Enter');
  {$endif}
  result := MakeResultString(
    PChar(Copy(String(sz), Length(String(sz)) - Number + 1, Number)), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('Right() - Exit');
  {$endif}
end;

function rTrim(sz: PChar): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('rTrim() - Enter');
  {$endif}
  result := MakeResultString(PChar(TrimRight(String(sz))), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('rTrim() - Exit');
  {$endif}
end;

function StringLength(sz: PChar): Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('StringLength() - Enter');
  {$endif}
  result := StrLen(sz);
  {$ifdef FULDebug}
  WriteDebug('StringLength() - Exit');
  {$endif}
end;

function StripString(sz, szCharsToStrip: PChar): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('StripString() - Enter');
  {$endif}
  result := MakeResultString(
    PChar(StdFuncs.StripString(String(sz), String(szCharsToStrip))), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('StripString() - Exit');
  {$endif}
end;

function SubStr(szSubStr, szStr: PChar): Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('SubStr() - Enter');
  {$endif}
  result := Pos(String(szSubStr), String(szStr)) - 1;
  {$ifdef FULDebug}
  WriteDebug('SubStr() - Exit');
  {$endif}
end;

{* ************************************************************************** *}
{* Some nice "data formatting routines"                                       *}
{* ************************************************************************** *}

{* ************************************************************************** *}
{* Formatting names for "pretty" output.                                      *}
{* ************************************************************************** *}
{* Valid format "fields" are:                                                 *}
{* \<pretext>\<posttext>\P  name prefix                                       *}
{* \<pretext>\<posttext>\F  first name                                        *}
{* \<pretext>\<posttext>\M  middle initial                                    *}
{* \<pretext>\<posttext>\L  last name                                         *}
{* \<pretext>\<posttext>\S  name suffix                                       *}
{* @ - escape character; anything following an @ will be printed as a literal *}
{* --options--                                                                *}
{* \\\A   print only alpha's                                                  *}
{* \\\9   print only alpha's and numeric's                                                  *}
{* \\\U   uppercase string                                                    *}
{* All other strings are just printed as-is.                                  *}
{* You use "pretext" and "posttext" values when the text preceding or         *}
{* succeeding a field depends on the presence of a value in the field.        *}
{* An example:                                                                *}
{*  "\\ \P\\ \F\\. \M\\\L\, \\S"                                              *}
{*  yields                                                                    *}
{*  Mr. John M. Smith, III    - or -                                          *}
{*  John Smith                - or -                                          *}
{*  John M. Smith             etc....                                         *}
{* ************************************************************************** *}
{* Just as a small note: This is not complicated, but the strings might       *}
{* initially seem that way... The intent of this function is so that the      *}
{* developer can ask the back-end to produce arbitrarily formatted name       *}
{* strings, but include some intelligent decision-making about how to print   *}
{* intermediate text.                                                         *}
{* ************************************************************************** *}
const
  FORMAT_CHAR = '\';
  ESC_CHAR = '@';

  STATE_INSERT = 1;
  STATE_PRESTR = 2;
  STATE_POSTSTR = 3;
  STATE_FORMAT = 4;
  STATE_ESC = 5;
  STATE_PRESTR_ESC = 6;
  STATE_POSTSTR_ESC = 7;

function GenerateFormattedName(szFormatString, szNamePrefix, szFirstName,
  szMiddleInitial, szLastName, szNameSuffix: PChar): PChar;
var
  strInternalResult: String;
begin
  {$ifdef FULDebug}
  WriteDebug('GenerateFormattedName() - Enter');
  {$endif}
  InternalGenerateFormattedName(
       String(szFormatString), strInternalResult,
       String(szNamePrefix), String(szFirstName), String(szMiddleInitial),
       String(szLastName), String(szNameSuffix));
  result := MakeResultString(PChar(strInternalResult), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('GenerateFormattedName() - Exit');
  {$endif}
end;

function InternalGenerateFormattedName(strFormatString: String;
  var strResult: String; strNamePrefix, strFirstName, strMiddleInitial,
  strLastName, strNameSuffix: String): Boolean;
var
  i, CurrentState: integer;
  OptionA, Option9, OptionU: Boolean;
  PreString, PostString, AlphaString: String;
begin
  {$ifdef FULDebug}
  WriteDebug('InternalGenerateFormattedName() - Enter');
  {$endif}
  PreString := '';
  PostString := '';
  OptionA := False;
  Option9 := False;
  OptionU := False;
  result := True;
  CurrentState := STATE_INSERT;
  i := 0;
  while (i < Length(strFormatString)) do begin
    inc(i);
    case CurrentState of
      STATE_INSERT: begin
        if strFormatString[i] = FORMAT_CHAR then
          CurrentState := STATE_PRESTR
        else if strFormatString[i] = ESC_CHAR then
          CurrentState := STATE_ESC
        else
          strResult := strResult + strFormatString[i];
      end;
      STATE_ESC: begin
        strResult := strResult + strFormatString[i];
        CurrentState := STATE_INSERT;
      end;
      STATE_PRESTR: begin
        if strFormatString[i] = FORMAT_CHAR then
          CurrentState := STATE_POSTSTR
        else if strFormatString[i] = ESC_CHAR then
          CurrentState := STATE_PRESTR_ESC
        else
          PreString := PreString + strFormatString[i];
      end;
      STATE_PRESTR_ESC: begin
        PreString := PreString + strFormatString[i];
        CurrentState := STATE_PRESTR;
      end;
      STATE_POSTSTR: begin
        if strFormatString[i] = FORMAT_CHAR then
          CurrentState := STATE_FORMAT
        else if strFormatString[i] = ESC_CHAR then
          CurrentState := STATE_POSTSTR_ESC
        else
          PostString := PostString + strFormatString[i];
      end;
      STATE_POSTSTR_ESC: begin
        PostString := PostString + strFormatString[i];
        CurrentState := STATE_POSTSTR;
      end;
      STATE_FORMAT: begin
        case strFormatString[i] of
          'P': if Length(strNamePrefix) <> 0 then
            strResult := strResult + PreString + strNamePrefix + PostString;
          'F': if Length(strFirstName) <> 0 then
            strResult := strResult + PreString + strFirstName + PostString;
          'M': if Length(strMiddleInitial) <> 0 then
            strResult := strResult + PreString + strMiddleInitial + PostString;
          'L': if Length(strLastName) <> 0 then
            strResult := strResult + PreString + strLastName + PostString;
          'S': if Length(strNameSuffix) <> 0 then
            strResult := strResult + PreString + strNameSuffix + PostString;
          'A': if not Option9 then OptionA := True else Break; // out of while
          '9': if not OptionA then Option9 := True else Break; // out of while
          'U': optionU := True;
          else Break; // out of while
        end; // case strFormatString[i] of
        PreString := '';
        PostString := '';
        CurrentState := STATE_INSERT;
      end;
    end; // case CurrentState of
  end; // while i < Length(strFormatString) do
  if CurrentState <> STATE_INSERT then
    result := False;
  if not result then
    strResult := 'Position: ' + IntToStr(i) + ', CurrentState: ' +
                 IntToStr(CurrentState)
  else begin
    if Option9 or OptionA then begin
      i := 0;
      while i < Length(strResult) do begin
        inc(i);
        case strResult[i] of
          'A'..'Z', 'a'..'z': AlphaString := AlphaString + strResult[i];
          '0'..'9': if Option9 then
            AlphaString := AlphaString + strResult[i];
        end;
      end;
      strResult := AlphaString;
    end;
    if OptionU then
      strResult := UpperCase(strResult);
  end;
  {$ifdef FULDebug}
  WriteDebug('InternalGenerateFormattedName() - Exit');
  {$endif}
end; // boolFSLibValStrAndGenFormattedName

function ValidateNameFormat(szFormatString: PChar): Integer;
var
  strInternalResult: String;
begin
  {$ifdef FULDebug}
  WriteDebug('ValidateNameFormat() - Enter');
  {$endif}
  if InternalGenerateFormattedName(
       String(szFormatString), strInternalResult,
       '', '', '', '', '') then
    result := 1
  else
    result := 0;
  {$ifdef FULDebug}
  WriteDebug('ValidateNameFormat() - Exit');
  {$endif}
end;

{* ************************************************************************** *}
{* Regular expressions!                                                       *}
{* ************************************************************************** *}
function ValidateRegularExpression(sz: PChar): Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('ValidateRegularExpression() - Enter');
  {$endif}
  result := 1;
  {$ifdef FULDebug}
  WriteDebug('ValidateRegularExpression() - Exit');
  {$endif}
end;

function ValidateStringInRE(sz, re: PChar): Integer;
begin
  {$ifdef FULDebug}
  WriteDebug('ValidateStringInRE() - Enter');
  {$endif}
  result := 1;
  {$ifdef FULDebug}
  WriteDebug('ValidateStringInRE() - Exit');
  {$endif}
end;

{* ************************************************************************** *}
{* Soundex function -                                                         *}
{*     returns the 5 character soundex index for the string                   *}
{* ************************************************************************** *}
function GenerateSndxIndex(sz: PChar): PChar;
begin
  {$ifdef FULDebug}
  WriteDebug('GenerateSndxIndex() - Enter');
  {$endif}
  result := MakeResultString(PChar(StdFuncs.Soundex(String(sz))), nil, 0);
  {$ifdef FULDebug}
  WriteDebug('GenerateSndxIndex() - Exit');
  {$endif}
end;

end.
