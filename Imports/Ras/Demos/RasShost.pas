{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS functions interface unit                                     }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: rasshost.h, released 24 Apr 1998.          }
{ The original Pascal code is: RasShost.pas, released 13 Jan 2000. }
{ The initial developer of the Pascal code is Petr Vones           }
{ (petr.v@mujmail.cz).                                             }
{                                                                  }
{ Portions created by Petr Vones are                               }
{ Copyright (C) 2000 Petr Vones                                    }
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

unit RasShost;

{$I RAS.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows, LmCons, RasSapi;

(*$HPPEMIT '#include <rassapi.h>'*)
(*$HPPEMIT '#include <mprapi.h>'*)

// Description: This header defines the interface between third party security
//              DLLs and the RAS server.

type
  PHPort = ^THPort;
  HPORT = DWORD;
  {$EXTERNALSYM HPORT}
  THPort = HPORT;

  PSecurityMessage = ^TSecurityMessage;
  _SECURITY_MESSAGE = record
    dwMsgId: DWORD;
    hPort: THPort;
    dwError: DWORD;                 // Should be non-zero only if error
                                    // occurred during the security dialog.
                                    // Should contain errors from winerror.h
                                    // or raserror.h
    UserName: packed array[0..UNLEN] of Char; // Should always contain username if
                                              // dwMsgId is SUCCESS/FAILURE
    Domain: packed array[0..DNLEN] of Char;   // Should always contain domain if
                                              // dwMsgId is SUCCESS/FAILURE
  end;
  {$EXTERNALSYM _SECURITY_MESSAGE}
  TSecurityMessage = _SECURITY_MESSAGE;
  SECURITY_MESSAGE = _SECURITY_MESSAGE;
  {$EXTERNALSYM SECURITY_MESSAGE}

// Values for dwMsgId in SECURITY_MESSAGE structure

const
  SECURITYMSG_SUCCESS    = 1;
  {$EXTERNALSYM SECURITYMSG_SUCCESS}
  SECURITYMSG_FAILURE    = 2;
  {$EXTERNALSYM SECURITYMSG_FAILURE}
  SECURITYMSG_ERROR      = 3;
  {$EXTERNALSYM SECURITYMSG_ERROR}

// Used by RasSecurityGetInfo call

type
  PRasSecurityInfo = ^TRasSecurityInfo;
  _RAS_SECURITY_INFO = record
    LastError: DWORD;                    // SUCCESS = receive completed
                                         // PENDING = receive pending
                                         // else completed with error
    BytesReceived: DWORD;                // only valid if LastError == SUCCESS
    DeviceName: packed array[0..RASSAPI_MAX_DEVICE_NAME] of Char;
  end;
  {$EXTERNALSYM _RAS_SECURITY_INFO}
  TRasSecurityInfo = _RAS_SECURITY_INFO;
  RAS_SECURITY_INFO = _RAS_SECURITY_INFO;
  {$EXTERNALSYM RAS_SECURITY_INFO}

  TRasSecurityProc = function: DWORD; stdcall;
  RASSECURITYPROC = TRasSecurityProc;
  {$EXTERNALSYM RASSECURITYPROC}

// Called by third party DLL to notify the supervisor of termination of
// the security dialog

  TRasSecurityDialogComplete = procedure (pSecMsg: PSecurityMessage); stdcall;

// Called by supervisor into the security DLL to notify it to begin the
// security dialog for a client.
//
// Should return errors from winerror.h or raserror.h

  TRasSecurityDialogBegin = function (hPort: THPort; pSendBuf: PByte;
    SendBufSize: DWORD; pRecvBuf: PByte; RecvBufSize: DWORD;
    RasSecurityDialogComplete: TRasSecurityDialogComplete): DWORD; stdcall;

// Called by supervisor into the security DLL to notify it to stop the
// security dialog for a client. If this call returns an error, then it is not
// neccesary for the dll to call RasSecurityDialogComplete. Otherwise the DLL
// must call RasSecurityDialogComplete.
//
// Should return errors from winerror.h or raserror.h

  TRasSecurityDialogEnd = function (hPort: THPort): DWORD; stdcall;

// The following entrypoints should be loaded by calling GetProcAddress from
// RasMan.lib
//
// Called to send data to remote host
// Will return errors from winerror.h or raserror.h

  TRasSecurityDialogSend = function (hPort: THPort; pBuffer: PByte;
    BufferLength: DWORD): DWORD; stdcall;

// Called to receive data from remote host
// Will return errors from winerror.h or raserror.h

  TRasSecurityDialogReceive = function (hPort: THPort; pBuffer: PByte;
    var pBufferLength: DWORD; Timeout: DWORD; hEvent: THandle): DWORD; stdcall;

// Called to get Information about port.
// Will return errors from winerror.h or raserror.h

  TRasSecurityDialogGetInfo = function (hPort: THPort;
    pBuffer: PRasSecurityInfo): DWORD; stdcall;


var
  RasSecurityDialogGetInfo: TRasSecurityDialogGetInfo = nil;
  {$EXTERNALSYM RasSecurityDialogGetInfo}
  RasSecurityDialogSend: TRasSecurityDialogSend = nil;
  {$EXTERNALSYM RasSecurityDialogSend}
  RasSecurityDialogReceive: TRasSecurityDialogReceive = nil;
  {$EXTERNALSYM RasSecurityDialogReceive}

function RasmanCheckAPI: Boolean;

implementation

const
  rasmanlib = 'rasman.dll';

var
  LibHandle: THandle = 0;

function RasmanCheckAPI: Boolean;
begin
  Result := (LibHandle <> 0);
end;

function RasmanInitAPI: Boolean;
begin
  if LibHandle = 0 then LibHandle := LoadLibrary(rasmanlib);
  if LibHandle <> 0 then
  begin
    @RasSecurityDialogGetInfo := GetProcAddress(LibHandle, 'RasSecurityDialogGetInfo');
    @RasSecurityDialogSend := GetProcAddress(LibHandle, 'RasSecurityDialogSend');
    @RasSecurityDialogReceive := GetProcAddress(LibHandle, 'RasSecurityDialogReceive');
    Result := True;
  end else Result := False;
end;

function RasmanFreeAPI: Boolean;
begin
  if LibHandle <> 0 then Result := FreeLibrary(LibHandle) else Result := True;
  LibHandle := 0;
end;

initialization
  RasmanInitAPI;

finalization
  RasmanFreeAPI;

end.
