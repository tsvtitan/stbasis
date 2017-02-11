{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS functions interface unit                                     }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: rassapi.h, released 24 Apr 1998.           }
{ The original Pascal code is: RasSapi.pas, released 01 Jan 2000.  }
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

unit RasSapi;

{$I RAS.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows, LmCons;

(*$HPPEMIT '#include <lmcons.h>'*)
(*$HPPEMIT '#include <rassapi.h>'*)

{   This file contains the RASADMIN structures, defines and
    function prototypes for the following APIs and they can
    be imported from RASSAPI.DLL:

     RasAdminServerGetInfo
     RasAdminGetUserAccountServer
     RasAdminUserSetInfo
     RasAdminUserGetInfo
     RasAdminPortEnum
     RasAdminPortGetInfo
     RasAdminPortClearStatistics
     RasAdminPortDisconnect
     RasAdminFreeBuffer

Note:

    This header file and the sources containing the APIs will work
    only with UNICODE strings.

--*}

const
  RASSAPI_MAX_PHONENUMBER_SIZE = 128;
  {$EXTERNALSYM RASSAPI_MAX_PHONENUMBER_SIZE}
  RASSAPI_MAX_MEDIA_NAME = 16;
  {$EXTERNALSYM RASSAPI_MAX_MEDIA_NAME}
  RASSAPI_MAX_PORT_NAME = 16;
  {$EXTERNALSYM RASSAPI_MAX_PORT_NAME}
  RASSAPI_MAX_DEVICE_NAME = 128;
  {$EXTERNALSYM RASSAPI_MAX_DEVICE_NAME}
  RASSAPI_MAX_DEVICETYPE_NAME = 16;
  {$EXTERNALSYM RASSAPI_MAX_DEVICETYPE_NAME}
  RASSAPI_MAX_PARAM_KEY_SIZE = 32;
  {$EXTERNALSYM RASSAPI_MAX_PARAM_KEY_SIZE}

// Bits indicating user's Remote Access privileges and mask to isolate
// call back privilege.
//
// Note: Bit 0 MUST represent NoCallback due to a quirk of the "userparms"
//       storage method.  When a new LAN Manager user is created, bit 0 of the
//       userparms field is set to 1 and all other bits are 0.  These bits are
//       arranged so this "no Dial-In info" state maps to the "default Dial-In
//       privilege" state.

  RASPRIV_NoCallback        = $01;
  {$EXTERNALSYM RASPRIV_NoCallback}
  RASPRIV_AdminSetCallback  = $02;
  {$EXTERNALSYM RASPRIV_AdminSetCallback}
  RASPRIV_CallerSetCallback = $04;
  {$EXTERNALSYM RASPRIV_CallerSetCallback}
  RASPRIV_DialinPrivilege   = $08;
  {$EXTERNALSYM RASPRIV_DialinPrivilege}

  RASPRIV_CallbackType = RASPRIV_AdminSetCallback or RASPRIV_CallerSetCallback or
                         RASPRIV_NoCallback;
  {$EXTERNALSYM RASPRIV_CallbackType}

// Modem condition codes

  RAS_MODEM_OPERATIONAL = 1; // No modem errors.
  {$EXTERNALSYM RAS_MODEM_OPERATIONAL}
  RAS_MODEM_NOT_RESPONDING = 2;
  {$EXTERNALSYM RAS_MODEM_NOT_RESPONDING}
  RAS_MODEM_HARDWARE_FAILURE = 3;
  {$EXTERNALSYM RAS_MODEM_HARDWARE_FAILURE}
  RAS_MODEM_INCORRECT_RESPONSE = 4;
  {$EXTERNALSYM RAS_MODEM_INCORRECT_RESPONSE}
  RAS_MODEM_UNKNOWN = 5;
  {$EXTERNALSYM RAS_MODEM_UNKNOWN}

// Line condition codes

  RAS_PORT_NON_OPERATIONAL = 1;
  {$EXTERNALSYM RAS_PORT_NON_OPERATIONAL}
  RAS_PORT_DISCONNECTED	= 2;
  {$EXTERNALSYM RAS_PORT_DISCONNECTED}
  RAS_PORT_CALLING_BACK = 3;
  {$EXTERNALSYM RAS_PORT_CALLING_BACK}
  RAS_PORT_LISTENING = 4;
  {$EXTERNALSYM RAS_PORT_LISTENING}
  RAS_PORT_AUTHENTICATING = 5;
  {$EXTERNALSYM RAS_PORT_AUTHENTICATING}
  RAS_PORT_AUTHENTICATED = 6;
  {$EXTERNALSYM RAS_PORT_AUTHENTICATED}
  RAS_PORT_INITIALIZING = 7;
  {$EXTERNALSYM RAS_PORT_INITIALIZING}

// The following three structures are same as the ones
// defined in rasman.h and have been renamed to prevent
// redefinitions when both header files are included.

type
  TRasParamsFormat = DWORD;
  {$NODEFINE TRasParamsFormat}
  RAS_PARAMS_FORMAT = TRasParamsFormat;
  {$EXTERNALSYM RAS_PARAMS_FORMAT}

const
  ParamNumber = 0;
  {$EXTERNALSYM ParamNumber}
  ParamString = 1;
  {$EXTERNALSYM ParamString}

type
  PRasParamsValue = ^TRasParamsValue;
  RAS_PARAMS_VALUE = record
    Number: DWORD;
    case Integer of
      0: (_String: record
            Length: DWORD;
	    Data: PChar
          end;)
  end;
  {$EXTERNALSYM RAS_PARAMS_VALUE}
  TRasParamsValue = RAS_PARAMS_VALUE;

  PRasParameters = ^TRasParameters;
  RAS_PARAMETERS = record
    P_Key: packed array[0..RASSAPI_MAX_PARAM_KEY_SIZE-1] of AnsiChar;
    P_Type: RAS_PARAMS_FORMAT;
    P_Attributes: Byte;
    P_Value: RAS_PARAMS_VALUE;
  end;
  {$EXTERNALSYM RAS_PARAMETERS}
  TRasParameters = RAS_PARAMETERS;

// structures used by the RASADMIN APIs

type
  PRasUser0 = ^TRasUser0;
  _RAS_USER_0 = record
    bfPrivilege: Byte;
    szPhoneNumber: packed array[0..RASSAPI_MAX_PHONENUMBER_SIZE] of WideChar;
  end;
  {$EXTERNALSYM _RAS_USER_0}
  TRasUser0 = _RAS_USER_0;
  RAS_USER_0 = _RAS_USER_0;
  {$EXTERNALSYM RAS_USER_0}

  PRasPort0 = ^TRasPort0;
  _RAS_PORT_0 = record
    wszPortName: packed array[0..RASSAPI_MAX_PORT_NAME-1] of WideChar;
    wszDeviceType: packed array[0..RASSAPI_MAX_DEVICETYPE_NAME-1] of WideChar;
    wszDeviceName: packed array[0..RASSAPI_MAX_DEVICE_NAME-1] of WideChar;
    wszMediaName: packed array[0..RASSAPI_MAX_MEDIA_NAME-1] of WideChar;
    reserved: DWORD;
    Flags: DWORD;
    wszUserName: packed array[0..UNLEN] of WideChar;
    wszComputer: packed array[0..NETBIOS_NAME_LEN-1] of WideChar;
    dwStartSessionTime: DWORD; // seconds from 1/1/1970
    wszLogonDomain: packed array[0..DNLEN] of WideChar;
    fAdvancedServer: BOOL;
  end;
  {$EXTERNALSYM _RAS_PORT_0}
  TRasPort0 = _RAS_PORT_0;
  RAS_PORT_0 = _RAS_PORT_0;
  {$EXTERNALSYM RAS_PORT_0}

const
// Possible values for MediaId
  MEDIA_UNKNOWN       = 0;
  {$EXTERNALSYM MEDIA_UNKNOWN}
  MEDIA_SERIAL        = 1;
  {$EXTERNALSYM MEDIA_SERIAL}
  MEDIA_RAS10_SERIAL  = 2;
  {$EXTERNALSYM MEDIA_RAS10_SERIAL}
  MEDIA_X25           = 3;
  {$EXTERNALSYM MEDIA_X25}
  MEDIA_ISDN          = 4;
  {$EXTERNALSYM MEDIA_ISDN}


// Possible bits set in Flags field
  USER_AUTHENTICATED    = $0001;
  {$EXTERNALSYM USER_AUTHENTICATED}
  MESSENGER_PRESENT     = $0002;
  {$EXTERNALSYM MESSENGER_PRESENT}
  PPP_CLIENT            = $0004;
  {$EXTERNALSYM PPP_CLIENT}
  GATEWAY_ACTIVE        = $0008;
  {$EXTERNALSYM GATEWAY_ACTIVE}
  REMOTE_LISTEN         = $0010;
  {$EXTERNALSYM REMOTE_LISTEN}
  PORT_MULTILINKED      = $0020;
  {$EXTERNALSYM PORT_MULTILINKED}

type
  PIpAddr = ^TIpAddr;
  IPADDR = ULONG;
  {$EXTERNALSYM IPADDR}
  TIpAddr = IPADDR;

// The following PPP structures are same as the ones
// defined in rasppp.h and have been renamed to prevent
// redefinitions when both header files are included
// in a module.

// Maximum length of address string, e.g. "255.255.255.255" for IP.

const
  RAS_IPADDRESSLEN  = 15;
  {$EXTERNALSYM RAS_IPADDRESSLEN}
  RAS_IPXADDRESSLEN = 22;
  {$EXTERNALSYM RAS_IPXADDRESSLEN}
  RAS_ATADDRESSLEN  = 32;
  {$EXTERNALSYM RAS_ATADDRESSLEN}

type
  PRasPppNbfcpResult = ^TRasPppNbfcpResult;
  _RAS_PPP_NBFCP_RESULT = record
    dwError: DWORD;
    dwNetBiosError: DWORD;
    szName: packed array[0..NETBIOS_NAME_LEN] of AnsiChar;
    wszWksta: packed array[0..NETBIOS_NAME_LEN] of WideChar;
  end;
  {$EXTERNALSYM _RAS_PPP_NBFCP_RESULT}
  TRasPppNbfcpResult = _RAS_PPP_NBFCP_RESULT;
  RAS_PPP_NBFCP_RESULT = _RAS_PPP_NBFCP_RESULT;
  {$EXTERNALSYM RAS_PPP_NBFCP_RESULT}

  PRasPppIpcpResult = ^TRasPppIpcpResult;
  _RAS_PPP_IPCP_RESULT = record
    dwError: DWORD;
    wszAddress: packed array[0..RAS_IPADDRESSLEN] of WideChar;
  end;
  {$EXTERNALSYM _RAS_PPP_IPCP_RESULT}
  TRasPppIpcpResult = _RAS_PPP_IPCP_RESULT;
  RAS_PPP_IPCP_RESULT = _RAS_PPP_IPCP_RESULT;
  {$EXTERNALSYM RAS_PPP_IPCP_RESULT}

  PRasPppIpxcpResult = ^TRasPppIpxcpResult;
  _RAS_PPP_IPXCP_RESULT = record
    dwError: DWORD;
    wszAddress: packed array[0..RAS_IPXADDRESSLEN] of WideChar;
  end;
  {$EXTERNALSYM _RAS_PPP_IPXCP_RESULT}
  TRasPppIpxcpResult = _RAS_PPP_IPXCP_RESULT;
  RAS_PPP_IPXCP_RESULT = _RAS_PPP_IPXCP_RESULT;
  {$EXTERNALSYM RAS_PPP_IPXCP_RESULT}

  PRasPppAtcpResult = ^TRasPppAtcpResult;
  _RAS_PPP_ATCP_RESULT = record
    dwError: DWORD;
    wszAddress: packed array[0..RAS_ATADDRESSLEN] of WideChar;
  end;
  {$EXTERNALSYM _RAS_PPP_ATCP_RESULT}
  TRasPppAtcpResult = _RAS_PPP_ATCP_RESULT;
  RAS_PPP_ATCP_RESULT = _RAS_PPP_ATCP_RESULT;
  {$EXTERNALSYM RAS_PPP_ATCP_RESULT}

  PRasProjectionResult = ^TRasProjectionResult;
  _RAS_PPP_PROJECTION_RESULT = record
    nbf: RAS_PPP_NBFCP_RESULT;
    ip: RAS_PPP_IPCP_RESULT;
    ipx: RAS_PPP_IPXCP_RESULT;
    at: RAS_PPP_ATCP_RESULT;
  end;
  {$EXTERNALSYM _RAS_PPP_PROJECTION_RESULT}
  TRasProjectionResult = _RAS_PPP_PROJECTION_RESULT;
  RAS_PPP_PROJECTION_RESULT = _RAS_PPP_PROJECTION_RESULT;
  {$EXTERNALSYM RAS_PPP_PROJECTION_RESULT}

  PRasPort1 = ^TRasPort1;
  _RAS_PORT_1 = record
    rasport0: RAS_PORT_0;
    LineCondition: DWORD;
    HardwareCondition: DWORD;
    LineSpeed: DWORD; // in bits/second
    NumStatistics: Word;
    NumMediaParms: Word;
    SizeMediaParms: DWORD;
    ProjResult: RAS_PPP_PROJECTION_RESULT;
  end;
  {$EXTERNALSYM _RAS_PORT_1}
  TRasPort1 = _RAS_PORT_1;
  RAS_PORT_1 = _RAS_PORT_1;
  {$EXTERNALSYM RAS_PORT_1}

  PRasPortStatistics = ^TRasPortStatistics;
  _RAS_PORT_STATISTICS = record
    // The connection statistics are followed by port statistics
    // A connection is across multiple ports.
    dwBytesXmited: DWORD;
    dwBytesRcved: DWORD;
    dwFramesXmited: DWORD;
    dwFramesRcved: DWORD;
    dwCrcErr: DWORD;
    dwTimeoutErr: DWORD;
    dwAlignmentErr: DWORD;
    dwHardwareOverrunErr: DWORD;
    dwFramingErr: DWORD;
    dwBufferOverrunErr: DWORD;
    dwBytesXmitedUncompressed: DWORD;
    dwBytesRcvedUncompressed: DWORD;
    dwBytesXmitedCompressed: DWORD;
    dwBytesRcvedCompressed: DWORD;
    // the following are the port statistics
    dwPortBytesXmited: DWORD;
    dwPortBytesRcved: DWORD;
    dwPortFramesXmited: DWORD;
    dwPortFramesRcved: DWORD;
    dwPortCrcErr: DWORD;
    dwPortTimeoutErr: DWORD;
    dwPortAlignmentErr: DWORD;
    dwPortHardwareOverrunErr: DWORD;
    dwPortFramingErr: DWORD;
    dwPortBufferOverrunErr: DWORD;
    dwPortBytesXmitedUncompressed: DWORD;
    dwPortBytesRcvedUncompressed: DWORD;
    dwPortBytesXmitedCompressed: DWORD;
    dwPortBytesRcvedCompressed: DWORD;
  end;
  {$EXTERNALSYM _RAS_PORT_STATISTICS}
  TRasPortStatistics = _RAS_PORT_STATISTICS;
  RAS_PORT_STATISTICS = _RAS_PORT_STATISTICS;
  {$EXTERNALSYM RAS_PORT_STATISTICS}

// Server version numbers

const
  RASDOWNLEVEL       = 10;    // identifies a LM RAS 1.0 server
  {$EXTERNALSYM RASDOWNLEVEL}
  RASADMIN_35        = 35;    // Identifies a NT RAS 3.5 server or client
  {$EXTERNALSYM RASADMIN_35}
  RASADMIN_CURRENT   = 40;    // Identifies a NT RAS 4.0 server or client
  {$EXTERNALSYM RASADMIN_CURRENT}

type
  PRasServer0 = ^TRasServer0;
  _RAS_SERVER_0 = record
    TotalPorts: Word;             // Total ports configured on the server
    PortsInUse: Word;             // Ports currently in use by remote clients
    RasVersion: DWORD;            // version of RAS server
  end;
  {$EXTERNALSYM _RAS_SERVER_0}
  TRasServer0 = _RAS_SERVER_0;
  RAS_SERVER_0 = _RAS_SERVER_0;
  {$EXTERNALSYM RAS_SERVER_0}

function RasAdminServerGetInfo(const lpszServer: PWChar;
  var pRasServer0: TRasServer0): DWORD; stdcall;
{$EXTERNALSYM RasAdminServerGetInfo}

function RasAdminGetUserAccountServer(const lpszDomain, lpszServer: PWChar;
  lpszUserAccountServer: LPWSTR): DWORD; stdcall;
{$EXTERNALSYM RasAdminGetUserAccountServer}

function RasAdminUserGetInfo(const lpszUserAccountServer, lpszUser: PWChar;
  var pRasUser0: TRasUser0): DWORD; stdcall;
{$EXTERNALSYM RasAdminUserGetInfo}

function RasAdminUserSetInfo(lpszUserAccountServer, lpszUser: PWChar;
  pRasUser0: PRasUser0): DWORD; stdcall;
{$EXTERNALSYM RasAdminUserSetInfo}

function RasAdminPortEnum(const lpszServer: PWChar; var ppRasPort0: PRasPort0;
  var pcEntriesRead: Word): DWORD; stdcall;
{$EXTERNALSYM RasAdminPortEnum}

function RasAdminPortGetInfo(const lpszServer, lpszPort: PWChar;
  var pRasPort1: TRasPort1; var pRasStats: TRasPortStatistics;
  var ppRasParams: PRasParameters): DWORD; stdcall;
{$EXTERNALSYM RasAdminPortGetInfo}

function RasAdminPortClearStatistics(const lpszServer, lpszPort: PWChar): DWORD; stdcall;
{$EXTERNALSYM RasAdminPortClearStatistics}

function RasAdminPortDisconnect(const lpszServer, lpszPort: PWChar): DWORD; stdcall;
{$EXTERNALSYM RasAdminPortDisconnect}

function RasAdminFreeBuffer(_Pointer: Pointer): DWORD; stdcall;
{$EXTERNALSYM RasAdminFreeBuffer}

function RasAdminGetErrorString(ResourceId: UINT; lpszString: PWChar;
  InBufSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasAdminGetErrorString}

function RasAdminAcceptNewConnection(pRasPort1: PRasPort1;
  pRasStats: PRasPortStatistics; pRasParams: PRasParameters): DWORD; stdcall;
{$EXTERNALSYM RasAdminAcceptNewConnection}

function RasAdminConnectionHangupNotification(pRasPort1: PRasPort1;
  pRasStats: PRasPortStatistics; pRasParams: PRasParameters): DWORD; stdcall;
{$EXTERNALSYM RasAdminConnectionHangupNotification}

function RasAdminGetIpAddressForUser(lpszUserName, lpszPortName: PWChar;
  var pipAddress: TIpAddr; var bNotifyRelease: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasAdminGetIpAddressForUser}

function RasAdminReleaseIpAddress(lpszUserName, lpszPortName: PWChar;
  pipAddress: PIpAddr): DWORD; stdcall;
{$EXTERNALSYM RasAdminReleaseIpAddress}

// The following two APIs are used to get/set
// RAS user permissions in to a UsrParms buffer
// obtained by a call to NetUserGetInfo.
//
// Note that RasAdminUserGetInfo and RasAdminUserSetInfo
// are the APIs you should be using for getting and
// setting RAS permissions.

function RasAdminGetUserParms(lpszParms: PWChar; var pRasUser0: TRasUser0): DWORD; stdcall;
{$EXTERNALSYM RasAdminGetUserParms}

function RasAdminSetUserParms(lpszParms: PWChar; cchNewParms: DWORD;
  pRasUser0: PRasUser0): DWORD; stdcall;
{$EXTERNALSYM RasAdminSetUserParms}

implementation

const
  rassapilib = 'rassapi.dll';

function RasAdminServerGetInfo; external rassapilib name 'RasAdminServerGetInfo';
function RasAdminGetUserAccountServer; external rassapilib name 'RasAdminGetUserAccountServer';
function RasAdminUserGetInfo; external rassapilib name 'RasAdminUserGetInfo';
function RasAdminUserSetInfo; external rassapilib name 'RasAdminUserSetInfo';
function RasAdminPortEnum; external rassapilib name 'RasAdminPortEnum';
function RasAdminPortGetInfo; external rassapilib name 'RasAdminPortGetInfo';
function RasAdminPortClearStatistics; external rassapilib name 'RasAdminPortClearStatistics';
function RasAdminPortDisconnect; external rassapilib name 'RasAdminPortDisconnect';
function RasAdminFreeBuffer; external rassapilib name 'RasAdminFreeBuffer';
function RasAdminGetErrorString; external rassapilib name 'RasAdminGetErrorString';
function RasAdminAcceptNewConnection; external rassapilib name 'RasAdminAcceptNewConnection';
function RasAdminConnectionHangupNotification; external rassapilib name 'RasAdminConnectionHangupNotification';
function RasAdminGetIpAddressForUser; external rassapilib name 'RasAdminGetIpAddressForUser';
function RasAdminReleaseIpAddress; external rassapilib name 'RasAdminReleaseIpAddress';
function RasAdminGetUserParms; external rassapilib name 'RasAdminGetUserParms';
function RasAdminSetUserParms; external rassapilib name 'RasAdminSetUserParms';

end.
