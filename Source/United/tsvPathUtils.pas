unit tsvPathUtils;

interface

uses ActiveX, ShlObj, ComCtrls, Windows, Classes, SysUtils, FileCtrl, Forms;

type
   TTypeBrowser=(tbForComputer, tbForPrinter, tbIncludeFiles,
                 tbReturnOnlyFSDirs,tbDontGobelowDomain,tbStatusText,
                 tbReturnFSAncestors,tbEditBox,tbValidate);
   TSetTypeBrowser=set of TTypeBrowser;

function SelectDirectoryEx(HW: Hwnd; InDir: string; Caption: string;
                           settb: TSetTypeBrowser): string;
function GetProgramFilesDir: string;

implementation

var
  Malloc: IMalloc;
  Desktop: IShellFolder;  pidlMyComputer: PItemIDList;  pidlResult: PItemIDList;
  pidlInitialFolder: PItemIDList;
  bi: TBrowseInfo;  DisplayName: string;
  ProgramFilesDir: WideString;
  CharsDone: ULONG;  dwAttributes: DWORD;  Temp: string;


function BrowseCallbackProc( hWnd: HWND; uMsg: UINT; lParam: LPARAM;
  lpData: LPARAM ): Integer; stdcall; // �������� �������� �� ���������� � ������� -
                                      // stdcallbegin  Result := 0;
var
  rt: TRect;
  w,h: Integer;                                      
begin
  Result:=0;
  case uMsg of                  
    BFFM_INITIALIZED:begin
      GetWindowRect(hWnd,rt);
      w:=rt.Right-rt.Left;
      h:=rt.Bottom-rt.Top;
      SetWindowPos(hWnd,HWND_TOP,
                   Screen.Width div 2 - w div 2,
                   Screen.Height div 2 - h div 2,
                   w,h,SWP_NOACTIVATE);
      PostMessage( hWnd, BFFM_SETSELECTION, 0, Integer(pidlInitialFolder) );
//      PostMessage( hWnd, BFFM_SETSTATUSTEXT, 0,Integer(PChar('1111111')) );
    end;
    BFFM_SELCHANGED: begin
       
    end;
 end;
end;

function GetProgramFilesDirByKeyStr(KeyStr: string): string;
var
  dwKeySize: DWORD;
  Key: HKEY;
  dwType: DWORD;
begin
 if
    RegOpenKeyEx( HKEY_LOCAL_MACHINE, PChar(KeyStr), 0, KEY_READ, Key ) = ERROR_SUCCESS
  then  try
    RegQueryValueEx( Key, 'ProgramFilesDir', nil, @dwType, nil, @dwKeySize );
    if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then    begin
      SetLength( Result, dwKeySize );
      RegQueryValueEx( Key, 'ProgramFilesDir', nil, @dwType, PByte(PChar(Result)),
        @dwKeySize );    end    else    begin
      RegQueryValueEx( Key, 'ProgramFilesPath', nil, @dwType, nil, @dwKeySize );
      if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 0) then      begin
        SetLength( Result, dwKeySize );
        RegQueryValueEx( Key, 'ProgramFilesPath', nil, @dwType, PByte(PChar(Result)),
          @dwKeySize );
      end;
  end;
  finally
    RegCloseKey( Key );
  end;
end;

function GetProgramFilesDir: string;

const
  DefaultProgramFilesDir = '%SystemDrive%\Program Files';

var
  FolderName: string;
  dwStrSize: DWORD;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then  begin    FolderName :=
      GetProgramFilesDirByKeyStr('Software\Microsoft\Windows NT\CurrentVersion');
  end;
  if Length(FolderName) = 0 then  begin    FolderName :=
      GetProgramFilesDirByKeyStr('Software\Microsoft\Windows\CurrentVersion');
  end;
  if Length(FolderName) = 0 then FolderName := DefaultProgramFilesDir;
  dwStrSize := ExpandEnvironmentStrings( PChar(FolderName), nil, 0 );
  SetLength( Result, dwStrSize );
  ExpandEnvironmentStrings( PChar(FolderName), PChar(Result), dwStrSize );
end;

function SelectDirectoryEx(HW: Hwnd; InDir: string; Caption: string;
                           settb: TSetTypeBrowser): string;
var
  WindowList: Pointer;                           
begin
  if DirectoryExists(InDir) then begin
   ProgramFilesDir :=ExpandFileName(InDir);
  end else
   ProgramFilesDir := ExtractFileDir(Application.Exename);  // acquire shell's allocator
//   ProgramFilesDir := GetProgramFilesDir;  // acquire shell's allocator
  if SUCCEEDED( SHGetMalloc( Malloc ) ) then
  try
    if SUCCEEDED( SHGetDesktopFolder( Desktop ) ) then
    try
      if SUCCEEDED( SHGetSpecialFolderLocation(HW, CSIDL_DESKTOP, pidlMyComputer ) ) then
      try        // acquire PIDL for folder that will be selected by default
        if  SUCCEEDED(Desktop.ParseDisplayName(HW, nil, PWideChar(ProgramFilesDir),
                      CharsDone, pidlInitialFolder, dwAttributes ))then
         try
          SetLength( DisplayName, MAX_PATH );
          FillChar( bi, sizeof(bi), 0 );
          bi.hwndOwner:=HW;
          bi.pidlRoot := pidlMyComputer; // roots from 'My Computer'
          bi.pszDisplayName := PChar( DisplayName );
          bi.lpszTitle := PChar(Caption);
//          bi.ulFlags := BIF_RETURNONLYFSDIRS;
          if tbForComputer in settb then bi.ulFlags:=bi.ulFlags+BIF_BROWSEFORCOMPUTER;
          if tbForPrinter in settb then bi.ulFlags:=bi.ulFlags+BIF_BROWSEFORPRINTER;
          if tbIncludeFiles in settb then bi.ulFlags:=bi.ulFlags+BIF_BROWSEINCLUDEFILES;
          if tbRETURNONLYFSDIRS in settb then bi.ulFlags:=bi.ulFlags+BIF_RETURNONLYFSDIRS;
          if tbDONTGOBELOWDOMAIN in settb then bi.ulFlags:=bi.ulFlags+BIF_DONTGOBELOWDOMAIN;
          if tbSTATUSTEXT in settb then bi.ulFlags:=bi.ulFlags+BIF_STATUSTEXT;
          if tbRETURNFSANCESTORS in settb then bi.ulFlags:=bi.ulFlags+BIF_RETURNFSANCESTORS;
          if tbEDITBOX in settb then bi.ulFlags:=bi.ulFlags+BIF_EDITBOX;
          if tbVALIDATE in settb then bi.ulFlags:=bi.ulFlags+BIF_VALIDATE;

          bi.lpfn := BrowseCallbackProc;
          WindowList := DisableTaskWindows(0);
          try
           pidlResult := SHBrowseForFolder( bi );
          finally
           EnableTaskWindows(WindowList);
          end;

          if Assigned(pidlResult) then begin
           try
            SetLength( Temp, MAX_PATH );
            if SHGetPathFromIDList( pidlResult, PChar(Temp) ) then begin
              DisplayName := Temp;
            end;
            DisplayName := Trim(DisplayName);
            Result:=StrPas(Pchar(DisplayName));
           finally
             Malloc.Free( pidlResult ); // release returned value
           end;
          end else Result:=InDir; 
         finally
          Malloc.Free( pidlInitialFolder ); // release PIDL for folder that
         end;
      finally
         Malloc.Free( pidlMyComputer ); // release folder that was served as root in dialog
      end;
    finally
      Desktop := nil; // release shell namespace root folder
    end;
  finally
    Malloc := nil; // release shell's allocator  end;
  end;
end;

end.