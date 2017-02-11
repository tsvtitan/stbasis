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
*  f r m u A b o u t
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit displays the application's About box
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit frmuAbout;

interface

uses WinTypes, WinProcs, Classes, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Graphics, frmuDlgClass, SYSUtils, jpeg;

type
  TfrmAbout = class(TDialog)
    Panel1: TPanel;
    Image1: TImage;
    StaticText2: TStaticText;
    Bevel1: TBevel;
    StaticText1: TStaticText;
    stxAppVersion: TStaticText;
    stxCopyright: TStaticText;
    stxhttpLink: TStaticText;
    stxWindowsVersion: TStaticText;
    Button1: TButton;
    stxIBConsoleVer: TStaticText;
    stxInterBase: TStaticText;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure stxhttpLinkClick(Sender: TObject);
    procedure GetFileVersion (const Filename: String; out Major1, Major2, Minor1, Minor2: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAboutDialog(ProductName, ProductVersion: string);

implementation

uses zluGlobal, ShellApi; //, URLMon;

{$R *.DFM}

const
  BUILDSTR = 'Build %d %s';
  PLATFORM_W9x = 'Windows 9x';
  PLATFORM_NT  = 'Windows NT';
  MEM_IN_USE = 'Memory in use %d%%';
  IBCONSOLE = 'ibconsole.exe';

{****************************************************************
*
*  S h o w A b o u t D i a l o g ()
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  ProductName - The short name of the application
*          ProductVersion - The version of the application
*
*  Return: None
*
*  Description:  Displays the application About dialog
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure ShowAboutDialog(ProductName, ProductVersion: string);
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(Application);
  with frmAbout do
  begin
    // show name and version
    if (ProductName <> '') and (ProductVersion <> '') then
    begin
      Caption := Caption + ' ' + ProductName;
    end;
    ShowModal;
    Free;
  end;
end;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
var
  VersionInfo : TOsVersionInfo;
  Build: String;
  V1, V2, V3, V4: Integer;
  tmpBuffer,
  Path: string;
begin
  inherited;
  { Get OS Version Information }
  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);

  with VersionInfo do
  begin
    if dwPlatformID = VER_PLATFORM_WIN32_NT then
    begin
      build := Format (BUILDSTR, [LoWord(dwBuildNumber), szCSDVersion]);
      stxWindowsVersion.Caption := Format('%s %d.%d (%s)', [PLATFORM_NT, dwMajorVersion, dwMinorVersion, Build]);
    end
    else
      stxWindowsVersion.Caption := Format('%s', [PLATFORM_W9X]);
  end;

  { Get the version information for IBConsole }
  Path := Application.ExeName;
  GetFileVersion(Path, V1, V2, V3, V4);
  stxIBConsoleVer.Caption := Format('Version: %d.%d.%d.%d', [V1, V2, V3, V4]);

  { Get file version information for GDS32.DLL and IBSERVER.EXE }
  // Get the gds32.dll path
  SetLength(tmpBuffer, MAX_PATH);
  GetSystemDirectory(PChar(tmpBuffer), MAX_PATH);
  Path := tmpBuffer + '\gds32.dll';

  // Check to see if it exists
  if FileExists(Path) then
  begin
    GetFileVersion(Path, V1, V2, V3, V4);
//    stxIBVer.Caption := Format('Version: %d.%d.%d.%d', [V1, V2, V3, V4]);
  end;
end;

procedure TfrmAbout.GetFileVersion(const Filename: String; out Major1,
  Major2, Minor1, Minor2: integer);
  { Helper function to get the actual file version information }
var
  Info: Pointer;
  InfoSize: DWORD;
  FileInfo: PVSFixedFileInfo;
  FileInfoSize: DWORD;
  Tmp: DWORD;
begin
  // Get the size of the FileVersionInformatioin
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Tmp);
  // If InfoSize = 0, then the file may not exist, or
  // it may not have file version information in it.
  if InfoSize = 0 then
    raise Exception.Create('Can''t get file version information for '
      + FileName);
  // Allocate memory for the file version information
  GetMem(Info, InfoSize);
  try
    // Get the information
    GetFileVersionInfo(PChar(FileName), 0, InfoSize, Info);
    // Query the information for the version
    VerQueryValue(Info, '\', Pointer(FileInfo), FileInfoSize);
    // Now fill in the version information
    Major1 := FileInfo.dwFileVersionMS shr 16;
    Major2 := FileInfo.dwFileVersionMS and $FFFF;
    Minor1 := FileInfo.dwFileVersionLS shr 16;
    Minor2 := FileInfo.dwFileVersionLS and $FFFF;
  finally
    FreeMem(Info, FileInfoSize);
  end;
end;

procedure TfrmAbout.stxhttpLinkClick(Sender: TObject);
begin
  inherited;
  ShellExecute (0, 'open', PChar((Sender as TStaticText).Caption), '', '', SW_SHOWNORMAL);
end;

end.



