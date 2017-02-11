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

unit thdExternalEditor;

interface

uses
  Classes;

type
  TExternalEditorThread = class(TThread)
  private
    { Private declarations }
    FFileName,
    FCmdLine,
    FExceptionMsg: String;
    procedure thdDisplayMessage;

  protected
    procedure Execute; override;

  public
    constructor Create(const ExtCmdLine, ExtFilename: string);
  end;

implementation

uses
  zluUtility, frmuMessage, Windows, SysUtils;

{ TExternalEditorThread }

constructor TExternalEditorThread.Create(const ExtCmdLine, ExtFilename: string);
begin
  FFileName := ExtFileName;
  FCmdLine := ExtCmdLine+' '+ExtFileName;
  FreeOnTerminate := true;
  inherited Create(False);
end;

procedure TExternalEditorThread.Execute;
var
  retval: boolean;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  buf: array[byte] of char;

begin
  try
    try
      FillChar (StartupInfo, sizeof(StartupInfo), 0);
      StartupInfo.cb := sizeof (StartupInfo);
      retval := CreateProcess (nil, PChar(FCmdLine), nil, nil, False,
         NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);

      if retval then
      begin
        with ProcessInfo do
          WaitForSingleObject (hProcess, INFINITE);
      end
      else
      begin
        FormatMessage (FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError,
                LOCALE_USER_DEFAULT, Buf, sizeof(Buf), nil);
        raise Exception.Create (Buf+#13#10+'Command: '+cmdLine);
      end;
    except
    on E: Exception do
      begin
        FExceptionMsg := E.Message;
        Synchronize (thdDisplayMessage);
      end;
    end;
  finally
    DeleteFile (FFileName);
  end;
end;

procedure TExternalEditorThread.thdDisplayMessage;
begin
 DisplayMsg (ERR_EXTERNAL_EDITOR, FExceptionMsg);
end;

end.
 
