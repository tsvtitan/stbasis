{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS error messages and return code checking function             }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original Pascal code is: RasUtils.pas, released 02 Jan 2000  }
{ The initial developer of the Pascal code is Petr Vones           }
{ (petr.v@mujmail.cz).                                             }
{                                                                  }
{ Portions created by Petr Vones are                               }
{ Copyright (C) 1999 Petr Vones                                    }
{                                                                  }
{ Obtained through:                                                }
{                                                                  }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html                          }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}

unit RasUtils;

interface

uses
  Windows, SysUtils, Ras, RasError;

function RasCheck(RetCode: DWORD): DWORD;

function RasErrorMessage(RetCode: DWORD): String;

function SysAndRasErrorMessage(RetCode: DWORD): String;

function RasConnStatusString(State: TRasConnState; ErrorCode: DWORD = 0): String;

implementation

resourcestring
  sRasError = 'RAS Error code: %d.'#10'"%s"';
  sRASCS_OpenPort = 'Port is about to be opened';
  sRASCS_PortOpened = 'Port has been opened';
  sRASCS_ConnectDevice = 'A device is about to be connected';
  sRASCS_DeviceConnected = 'A device has connected successfully';
  sRASCS_AllDevicesConnected = 'All devices in the device chain have successfully connected';
  sRASCS_Authenticate = 'The authentication process is starting';
  sRASCS_AuthNotify = 'An authentication event has occurred';
  sRASCS_AuthRetry = 'The client has requested another validation attempt with a new user name/password/domain';
  sRASCS_AuthCallback = 'The remote access server has requested a callback number';
  sRASCS_AuthChangePassword = 'The client has requested to change the password on the account';
  sRASCS_AuthProject = 'The projection phase is starting';
  sRASCS_AuthLinkSpeed = 'The link-speed calculation phase is starting';
  sRASCS_AuthAck = 'An authentication request is being acknowledged';
  sRASCS_ReAuthenticate = 'Reauthentication (after callback) is starting';
  sRASCS_Authenticated = 'The client has successfully completed authentication';
  sRASCS_PrepareForCallback = 'The line is about to disconnect in preparation for callback';
  sRASCS_WaitForModemReset = 'The client is delaying in order to give the modem time to reset itself in preparation for callback';
  sRASCS_WaitForCallback = 'The client is waiting for an incoming call from the remote access server';
  sRASCS_Projected = 'Projection result information is available';
  sRASCS_StartAuthentication = 'User authentication is being initiated or retried';
  sRASCS_CallbackComplete = 'Client has been called back and is about to resume authentication';
  sRASCS_LogonNetwork = 'Client is logging on to the network';
  sRASCS_SubEntryConnected = 'Subentry has been connected during the dialing process';
  sRASCS_SubEntryDisconnected = 'Subentry has been disconnected during the dialing process';
  sRASCS_Interactive = 'Terminal state supported by RASPHONE.EXE';
  sRASCS_RetryAuthentication = 'Retry authentication state supported by RASPHONE.EXE';
  sRASCS_CallbackSetByCaller = 'Callback state supported by RASPHONE.EXE';
  sRASCS_PasswordExpired = 'Change password state supported by RASPHONE.EXE';
  sRASCS_Connected = 'Connected';
  sRASCS_Disconnected = 'Disconnected';

function RasErrorMessage(RetCode: DWORD): String;
var
  C: array[0..255] of Char;
begin
  if RasGetErrorString(RetCode, @C, Sizeof(C)) = SUCCESS then
    Result := C
  else
    Result := '';
end;

function SysAndRasErrorMessage(RetCode: DWORD): String;
begin
  if (RetCode >= RASBASE) and (RetCode <= RASBASEEND) then
    Result := RasErrorMessage(RetCode)
  else
    Result := SysErrorMessage(RetCode);
end;

function RasCheck(RetCode: DWORD): DWORD;
var
  Error: EWin32Error;
begin
  if RetCode <> SUCCESS then
  begin
    Error := EWin32Error.CreateFmt(sRasError, [RetCode, SysAndRasErrorMessage(RetCode)]);
    Error.ErrorCode := RetCode;
    raise Error;
  end;
  Result := RetCode;
end;

function RasConnStatusString(State: TRasConnState; ErrorCode: DWORD = 0): String;
begin
  if ErrorCode <> 0 then
    Result := SysAndRasErrorMessage(ErrorCode)
  else
    case State of
      RASCS_OpenPort: Result := sRASCS_OpenPort;
      RASCS_PortOpened: Result := sRASCS_PortOpened;
      RASCS_ConnectDevice: Result := sRASCS_ConnectDevice;
      RASCS_DeviceConnected: Result := sRASCS_DeviceConnected;
      RASCS_AllDevicesConnected: Result := sRASCS_AllDevicesConnected;
      RASCS_Authenticate: Result := sRASCS_Authenticate;
      RASCS_AuthNotify: Result := sRASCS_AuthNotify;
      RASCS_AuthRetry: Result := sRASCS_AuthRetry;
      RASCS_AuthCallback: Result := sRASCS_AuthCallback;
      RASCS_AuthChangePassword: Result := sRASCS_AuthChangePassword;
      RASCS_AuthProject: Result := sRASCS_AuthProject;
      RASCS_AuthLinkSpeed: Result := sRASCS_AuthLinkSpeed;
      RASCS_AuthAck: Result := sRASCS_AuthAck;
      RASCS_ReAuthenticate: Result := sRASCS_ReAuthenticate;
      RASCS_Authenticated: Result := sRASCS_Authenticated;
      RASCS_PrepareForCallback: Result := sRASCS_PrepareForCallback;
      RASCS_WaitForModemReset: Result := sRASCS_WaitForModemReset;
      RASCS_WaitForCallback: Result := sRASCS_WaitForCallback;
      RASCS_Projected: Result := sRASCS_Projected;
      RASCS_StartAuthentication: Result := sRASCS_StartAuthentication;
      RASCS_CallbackComplete: Result := sRASCS_CallbackComplete;
      RASCS_LogonNetwork: Result := sRASCS_LogonNetwork;
      RASCS_SubEntryConnected: Result := sRASCS_SubEntryConnected;
      RASCS_SubEntryDisconnected: Result := sRASCS_SubEntryDisconnected;
      RASCS_Interactive: Result := sRASCS_Interactive;
      RASCS_RetryAuthentication: Result := sRASCS_RetryAuthentication;
      RASCS_CallbackSetByCaller: Result := sRASCS_CallbackSetByCaller;
      RASCS_PasswordExpired: Result := sRASCS_PasswordExpired;
      RASCS_Connected: Result := sRASCS_Connected;
      RASCS_Disconnected: Result := sRASCS_Disconnected;
    else
      Result := '';
    end;
end;

end.
