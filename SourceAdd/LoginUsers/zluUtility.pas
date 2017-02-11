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

{****************************************************************
*
*  z l u U t i l i t y
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit contains utility functions used throughout
*                the application
*
*****************************************************************
* Revisions:
*
*****************************************************************}

unit zluUtility;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  FileCtrl, Registry, IBDatabase, IBSQL;

function CheckDirectory(Directory: string): boolean;
function GetNewFileName(Directory: string; FileExtension: string): string;
function GetNextField(var InputStr: string; const FieldDelimiter: string): string;
function IsIBRunning(): boolean;
function IsServerRegistered(const Alias: String): boolean;
function OSVersionInfo(): DWORD;
function RemoveControlChars(const InputStr: string): string;
function StartGuardian(): boolean;
function StartServer(): boolean;
function StopServer(): boolean;
function ParseConnectStr(Str, Tok, Del : String) : String;
function ConvertStr(lStr : String) : String;
function ObjTypeToStr(const objType: integer): string;
function StripMenuChars(const Caption: String): String;
function GetImageIndex (const ObjType: integer): integer;
function Max (const val1, val2: integer): integer;
function IsValidDBName(const DBName: String): boolean;

implementation

uses
  zluGlobal, frmuMessage, IBHeader;

{****************************************************************
*
*  C h e c k D i r e c t o r y ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   May 9, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function CheckDirectory(Directory: string): boolean;
begin
  if (Directory <> '') and not (DirectoryExists(Directory)) then
  begin
    if MessageDlg(Format('The directory %s does not exist. Do you wish to create it?',[Directory]),
      mtConfirmation, [mbYes,mbNo], 0) = mrYes then
    begin
      if not CreateDir(Directory) then
      begin
        MessageDlg(Format('An error occurred while attemting to create directory %s. Operation cancelled.',[Directory]),
          mtInformation, [mbOk], 0);
        result := false;
      end
      else
        result := true;
    end
    else
      result := false;
  end
  else
    result := true;
end;

{****************************************************************
*
*  G e t N e w F i l e N a m e ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   May 9, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetNewFileName(Directory: string; FileExtension: string): string;
var
  lFileName: string;
begin
  Randomize;
  lFileName := Format('%s%s%s',[Directory,Format('%-8.8d',[Random(99999999)]),FileExtension]);
  while FileExists(lFileName) do
  begin
    lFileName := Format('%s%s%s',[Directory,Format('%-8.8d',[Random(99999999)]),FileExtension]);
  end;
  result := lFileName;
end;

{****************************************************************
*
*  G e t N e x t F i e l d ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  InputStr - The string to process
*          FieldDelimiter - The field delimiter to use
*
*  Return: string - The extracted string
*
*  Description:  Receives a delimited string and extracts the
*                first field in the string based on the given delimiter
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function GetNextField(var InputStr: string; const FieldDelimiter: string): string;
var
  lFieldDelPos: integer;
  lRetVal: string;
begin
  // get position of the first Delimiter found
  lFieldDelPos := Pos(FieldDelimiter, InputStr);
  if lFieldDelPos > 0 then
  begin
    // copy the field to a new string
    lRetVal := Copy(InputStr, 1, lFieldDelPos - 1);

    // delete field from our incoming string
    Delete(InputStr, 1, lFieldDelPos + Length(FieldDelimiter)-1);
  end
  else
  begin
    // last field
    lRetVal := InputStr;
    InputStr := '';
  end;
  result := Trim(lRetVal);
end;

{****************************************************************
*
*  I s R u n n i n g ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function IsIBRunning(): boolean;
begin
  if GetWindow(GetDesktopWindow,GW_HWNDNEXT)= FindWindow('IB_Server', 'InterBase Server') then
    result := false
  else
    result := true;
end;

{****************************************************************
*
*  O S V e r s i o n I n f o ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function OSVersionInfo(): DWORD;
var
  lVersion: Windows.OSVERSIONINFO;
begin
  ZeroMemory(@lVersion, SizeOf(lVersion));
  lVersion.dwOSVersionInfoSize := sizeof(lVersion);
  GetVersionEx(lVersion);
  result := lVersion.dwPlatformId
end;

{****************************************************************
*
*  R e m o v e C o n t r o l C h a r s ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  InputStr - The string to process
*
*  Return: string - The processed string
*
*  Description:  Receives a string and removes any control
*                characters from it
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function RemoveControlChars(const InputStr: string): string;
var
  i: integer;
  lStrVal: string;
begin
  lStrVal := Trim(InputStr);
  for i := 0 to Length(lStrVal) - 1 do
  begin
    if (Ord(lStrVal[i]) in [32..126]) then
    begin
      // The lStrVal[i+1] is safe in this case because with the use
      // of the above Trim() function the if condition will never be true for
      // the last character.
      if (lStrVal[i] = Chr(32)) and (lStrVal[i+1] = Chr(32)) then
        Delete(lStrVal,i,1);
    end;
  end;
  { Make sure that the first character is capitalized }
  if Length(lStrVal) > 0 then
    lStrVal[1] := UpCase(lStrVal[1]);
  result := lStrVal;
end;

{****************************************************************
*
*  S t a r t G u a r d i a n ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function StartGuardian(): boolean;
var
  lRegistry: TRegistry;
  lEXEName: string;
  lArray: array[0..255] of char;
begin
  result := false;
  lRegistry := TRegistry.Create;
  try
    Screen.Cursor := crHourglass;
    lRegistry.RootKey := HKEY_LOCAL_MACHINE;
    if not lRegistry.OpenKey('Software\Borland\InterBase\CurrentVersion',False) then
      ShowMessage('InterBase server is not installed on your computer.')
    else
      lEXEName := Format('%s%s ',[lRegistry.ReadString('ServerDirectory'),'ibguard.exe']);
  finally
    if WinExec(StrPCopy(lArray,lEXEName),1) > 31 then
      result := true;
    lRegistry.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  S t a r t S e r v e r ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function StartServer(): boolean;
var
  lRegistry: TRegistry;
  lStartUpInfo: STARTUPINFO;
  lSecurityAttr: SECURITY_ATTRIBUTES;
  lProcessInfo: PROCESS_INFORMATION;
  lEXEName: string;
  lArray: array[0..255] of char;
begin
  result := false;
  lRegistry := TRegistry.Create;
  try
    Screen.Cursor := crHourglass;
    lRegistry.RootKey := HKEY_LOCAL_MACHINE;
    if not lRegistry.OpenKey('Software\Borland\InterBase\CurrentVersion',False) then
      ShowMessage('InterBase server is not installed on your system.')
    else
      lEXEName := Format('%s%s -a',[lRegistry.ReadString('ServerDirectory'),'ibserver.exe']);

    ZeroMemory(@lStartUpInfo, SizeOf(lStartUpInfo));
    lStartUpInfo.cb := SizeOf(lStartUpInfo);
    lSecurityAttr.nLength := SizeOf (lSecurityAttr);
    lSecurityAttr.lpSecurityDescriptor := nil;
    lSecurityAttr.bInheritHandle := TRUE;
    if CreateProcess (nil,StrPCopy(lArray,lEXEName), @lSecurityAttr, nil, FALSE, 0, nil,
      nil, lStartUpInfo, lProcessInfo) <> Null then
      result := true
    else
      ShowMessage('The server could not be started.')
  finally
    lRegistry.Free;
    Screen.Cursor := crDefault;
  end;
end;

{****************************************************************
*
*  S t o p S e r v e r ( )
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:
*
*  Return:
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function StopServer(): boolean;
var
  lHWND: HWND;
  lVersion: DWORD;
  lRegistry: TRegistry;
  lEXEName: string;
  lArray: array[0..255] of char;
begin
  result := false;
  lRegistry := TRegistry.Create;
  try
    Screen.Cursor := crHourglass;
    lVersion := OSVersionInfo();
    if lVersion = VER_PLATFORM_WIN32_NT then
    begin
      lRegistry.RootKey := HKEY_LOCAL_MACHINE;
      if not lRegistry.OpenKey('Software\Borland\InterBase\CurrentVersion',False) then
        ShowMessage('InterBase server is not installed on your system.')
      else
        lEXEName := Format('%s%s',[lRegistry.ReadString('ServerDirectory'),'instsvc.exe stop']);

      if WinExec(StrPCopy(lArray,lEXEName), 2) > 31 then
        result := true;
    end
    else if lVersion = VER_PLATFORM_WIN32_WINDOWS then
    begin
      lHWND:= FindWindow('IB_Server', 'InterBase Server');
      if PostMessage(lHWND, WM_CLOSE, 0, 0)<> Null then
        result := true;
      Application.ProcessMessages;
    end;
  finally
    lRegistry.Free;
    Screen.Cursor := crDefault;
  end;
end;

// extracts param values for a connect statememt
function ParseConnectStr(Str, Tok, Del : String) : String;
  var
    iStart, iEnd : Integer;
    lReturn : String;
  begin
    iStart := Pos(Tok, Str);
    // found parameter - must find parameter value
    if iStart <> 0 then
    begin
      Delete(Str, 1, iStart);
      iEnd := Pos(Del, Str);
      if iEnd <> 0 then
      begin
        // delete the parameter - next is the parameter value
        Delete(Str, 1, iEnd);

        iEnd := Pos(Del, Str);

        if iEnd <> 0 then
          lReturn := Trim(Copy(Str, 0, iEnd - 1))
        else
          lReturn := '';
      end
      else
        lReturn := '';
    end
    else
      lReturn := '';
    Result := lReturn;
  end;

  // this function removes ' and replaces them with "
  // and converts all non-quoted characters to uppercase
function ConvertStr(lStr : String) : String;
  var
    lQuote : Boolean;
    i : Integer;
  begin
    lStr := Trim(lStr);
    lQuote := False;
    i := 1;
    while i <= Length(lStr) do
    begin
      if (Ord(lStr[i]) = 10) or (Ord(lStr[i]) = 13) then
        lStr[i] := ' '
      else  if (lStr[i] = '''') or (lStr[i] = '"') then
      begin
        if (lStr[i] = '''') then
          lStr[i] := '"';
        if lQuote then
          lQuote := False
        else
          lQuote := True;
      end
      else
      begin
        if (not lQuote) and (Ord(lStr[i]) > 96) and (Ord(lStr[i]) < 123) then
        begin
          lStr[i] := Chr(Ord(lStr[i]) - 32)
        end;
      end;
      Inc(i);
    end;
    Result := lStr;
  end;

function ObjTypeToStr(const objType: integer): string;
begin
  case objType of
    0: result := 'Table';
    1: result := 'View';
    2: result := 'Trigger';
    3: result := 'Computed Field';
    4: result := 'Validation';
    5: result := 'Procedure';
    6: result := 'Expression Index';
    7: result := 'Exception';
    8: result := 'User';
    9: result := 'Field';
    10: result := 'Index';
    13: result := 'Role';
    else
      result := 'Unknown';
  end;
end;

function StripMenuChars(const Caption: String): String;
var
  Psrc, Pdest: PChar;
  dest_str: String;
begin
  Psrc := PChar(Caption);
  SetLength(dest_str, Length(Caption));
  Pdest := PChar(dest_str);
  while Psrc^ <> #0 do
  begin
    if not (Psrc^ in ['&', '.']) then
    begin
      Pdest^ := Psrc^;
      Inc(Pdest);
    end;
    Inc(Psrc);
  end;
  Pdest^ := PSrc^;
  result := dest_str;
end;

function GetImageIndex (const ObjType: integer): integer;
begin
  case ObjType of
    DEP_TABLE: result := NODE_TABLES_IMG;
    DEP_VIEW:  result := NODE_VIEWS_IMG;
    DEP_TRIGGER: result := NODE_TRIGGERS_IMG;
    DEP_COMPUTED_FIELD: result := NODE_UNK_IMG;
    DEP_VALIDATION: result := NODE_CHECK_CONSTRAINTS_IMG;
    DEP_PROCEDURE: result := NODE_PROCEDURES_IMG;
    DEP_EXPRESSION_INDEX: result := NODE_UNK_IMG;
    DEP_EXCEPTION: result := NODE_EXCEPTIONS_IMG;
    DEP_USER: result := NODE_USERS_IMG;
    DEP_FIELD: result := NODE_COLUMNS_IMG;
    DEP_INDEX: result := NODE_INDEXES_IMG;
    else
      result := NODE_UNK_IMG;
  end;
end;

function IsServerRegistered(const Alias: String): boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    result := OpenKey(Format('%s%s',[gRegServersKey,Alias]), false);
    Free;
  end;
end;

function Max (const val1, val2: integer): integer;
begin
  if val1 > val2 then
    result := val1
  else
    result := val2;
end;

function IsValidDBName(const DBName: String): boolean;
(* NOTE:  If this function returns FALSE, all areas of the code
   return a warning and DO NOT ABORT *)
begin
  result := true;
  { Make sure it is not a UNC name }
  if (Pos('//', DBName) = 1) or
     (Pos ('\\', DBName) = 1) or
  { Make sure it is not TCP/IP }
     (Pos(':', DBName) > 2) or
  { Make sure it is not SPX.}
     (Pos('@', DBName) <> 0) then
    result := false;
end;

end.
