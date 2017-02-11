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

unit zluPrevInstance;

interface

uses Forms, Windows, Dialogs, SysUtils;

// The following declaration is necessary because of an error in
// the declaration of BroadcastSystemMessage() in the Windows unit
//function BroadcastSystemMessage(Flags: DWORD; Recipients: PDWORD;
//  uiMessage: UINT; wParam: WPARAM; lParam: LPARAM): Longint; stdcall;
//  external 'user32.dll';


const
  MI_NO_ERROR          = 0;
  MI_FAIL_SUBCLASS     = 1;
  MI_FAIL_CREATE_MUTEX = 2;

{ Query this function to determine if error occurred in startup. }
{ Value will be one or more of the MI_* error flags. }
function GetMIError: Integer;

implementation

const
  UniqueAppStr : PChar = 'IBCONSOLE';

var
  MessageId: Integer;
  WProc: TFNWndProc = Nil;
  MutHandle: THandle = 0;
  MIError: Integer = 0;

function GetMIError: Integer;
begin
  Result := MIError;
end;

function NewWndProc(Handle: HWND; Msg: Integer; wParam, lParam: Longint):
  Longint; stdcall;
begin

  { If this is the registered message... }
  if Msg = MessageID then
  begin
    { if main form is minimized, normalize it }
    { set focus to application }
    if IsIconic(Application.Handle) then
    begin
      Application.MainForm.WindowState := wsNormal;
      Application.Restore;
    end;
    SetForegroundWindow(Application.MainForm.Handle);
    Result := 0;
  end
  { Otherwise, pass message on to old window proc }
  else
    Result := CallWindowProc(WProc, Handle, Msg, wParam, lParam);
end;

procedure SubClassApplication;
begin
  { We subclass Application window procedure so that }
  { Application.OnMessage remains available for user. }
  WProc := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC,
                                    Longint(@NewWndProc)));
  { Set appropriate error flag if error condition occurred }
  if WProc = Nil then
    MIError := MIError or MI_FAIL_SUBCLASS;
end;

procedure DoFirstInstance;
begin
  SubClassApplication;
  MutHandle := CreateMutex(Nil, False, UniqueAppStr);
  if MutHandle = 0 then
    MIError := MIError or MI_FAIL_CREATE_MUTEX;
end;

procedure BroadcastFocusMessage;
{ This is called when there is already an instance running. }
var
  BSMRecipients: DWORD;
begin
  { Don't flash main form }
  Application.ShowMainForm := False;
  { Post message and inform other instance to focus itself }
  BSMRecipients := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
    @BSMRecipients, MessageID, 0, 0);
  Application.Terminate;
end;

procedure InitInstance;
begin
  MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, UniqueAppStr);
  if MutHandle = 0 then
    { Mutex object has not yet been created, meaning that no previous }
    { instance has been created. }
    DoFirstInstance
  else
    BroadcastFocusMessage;
end;

initialization
  MessageID := RegisterWindowMessage(UniqueAppStr);
  InitInstance;
finalization
  if WProc <> Nil then
    { Restore old window procedure }
    SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(WProc));
end.

