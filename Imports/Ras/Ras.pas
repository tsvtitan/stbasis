{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS functions interface unit                                     }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: ras.h, released 24 Apr 1998.               }
{ The original Pascal code is: Ras.pas, released 30 Dec 1999.      }
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

unit Ras;

{$I RAS.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows, LmCons;

(*$HPPEMIT '#include <lmcons.h>'*)
(*$HPPEMIT '#include <pshpack4.h>'*)
(*$HPPEMIT '#include <ras.h>'*)

const
  RAS_MaxDeviceType = 16;
  {$EXTERNALSYM RAS_MaxDeviceType}
  RAS_MaxPhoneNumber = 128;
  {$EXTERNALSYM RAS_MaxPhoneNumber}
  RAS_MaxIpAddress = 15;
  {$EXTERNALSYM RAS_MaxIpAddress}
  RAS_MaxIpxAddress = 21;
  {$EXTERNALSYM RAS_MaxIpxAddress}

{$IFDEF WINVER_0x400_OR_GREATER}
  RAS_MaxEntryName = 256;
  {$EXTERNALSYM RAS_MaxEntryName}
  RAS_MaxDeviceName = 128;
  {$EXTERNALSYM RAS_MaxDeviceName}
  RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
  {$EXTERNALSYM RAS_MaxCallbackNumber}
{$ELSE}
  RAS_MaxEntryName = 20;
  {$EXTERNALSYM RAS_MaxEntryName}
  RAS_MaxDeviceName = 32;
  {$EXTERNALSYM RAS_MaxDeviceName}
  RAS_MaxCallbackNumber = 48;
  {$EXTERNALSYM RAS_MaxCallbackNumber}
{$ENDIF}

  RAS_MaxAreaCode = 10;
  {$EXTERNALSYM RAS_MaxAreaCode}
  RAS_MaxPadType = 32;
  {$EXTERNALSYM RAS_MaxPadType}
  RAS_MaxX25Address = 200;
  {$EXTERNALSYM RAS_MaxX25Address}
  RAS_MaxFacilities = 200;
  {$EXTERNALSYM RAS_MaxFacilities}
  RAS_MaxUserData = 200;
  {$EXTERNALSYM RAS_MaxUserData}
  RAS_MaxReplyMessage = 1024;
  {$EXTERNALSYM RAS_MaxReplyMessage}

type
  PHRasConn = ^THRasConn;
  HRASCONN = THandle;
  {$EXTERNALSYM HRASCONN}
  THRasConn = HRASCONN;

// Identifies an active RAS connection.  (See RasEnumConnections)

  PRasConnA = ^TRasConnA;
  PRasConnW = ^TRasConnW;
  PRasConn = PRasConnA;
  tagRASCONNA = record
    dwSize: DWORD;
    hrasconn: THRasConn;
    szEntryName: packed array[0..RAS_MaxEntryName] of AnsiChar;
{$IFDEF WINVER_0x400_OR_GREATER}
    szDeviceType: packed array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of AnsiChar;
{$ENDIF}
{$IFDEF WINVER_0x401_OR_GREATER}
    szPhonebook: array[0..MAX_PATH-1] of AnsiChar;
    dwSubEntry: DWORD;
{$ENDIF}
{$IFDEF WINVER_0x500_OR_GREATER}
    guidEntry: TGUID;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASCONNA}
  tagRASCONNW = record
    dwSize: DWORD;
    hrasconn: THRasConn;
    szEntryName: packed array[0..RAS_MaxEntryName] of WideChar;
{$IFDEF WINVER_0x400_OR_GREATER}
    szDeviceType: packed array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of WideChar;
{$ENDIF}
{$IFDEF WINVER_0x401_OR_GREATER}
    szPhonebook: array[0..MAX_PATH-1] of WideChar;
    dwSubEntry: DWORD;
{$ENDIF}
{$IFDEF WINVER_0x500_OR_GREATER}
    guidEntry: TGUID;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASCONNW}
  tagRASCONN = tagRASCONNA;
  TRasConnA = tagRASCONNA;
  TRasConnW = tagRASCONNW;
  TRasConn = TRasConnA;
  RASCONNA = tagRASCONNA;
  {$EXTERNALSYM RASCONNA}
  RASCONNW = tagRASCONNW;
  {$EXTERNALSYM RASCONNW}
  RASCONN = RASCONNA;

// Enumerates intermediate states to a connection.  (See RasDial)

const
  RASCS_PAUSED = $1000;
  {$EXTERNALSYM RASCS_PAUSED}
  RASCS_DONE   = $2000;
  {$EXTERNALSYM RASCS_DONE}

type
  PRasConnState = ^TRasConnState;
  RASCONNSTATE = DWORD;
  {$EXTERNALSYM RASCONNSTATE}
  TRasConnState = RASCONNSTATE;

const
  RASCS_OpenPort = 0;
  {$EXTERNALSYM RASCS_OpenPort}
  RASCS_PortOpened = 1;
  {$EXTERNALSYM RASCS_PortOpened}
  RASCS_ConnectDevice = 2;
  {$EXTERNALSYM RASCS_ConnectDevice}
  RASCS_DeviceConnected = 3;
  {$EXTERNALSYM RASCS_DeviceConnected}
  RASCS_AllDevicesConnected = 4;
  {$EXTERNALSYM RASCS_AllDevicesConnected}
  RASCS_Authenticate = 5;
  {$EXTERNALSYM RASCS_Authenticate}
  RASCS_AuthNotify = 6;
  {$EXTERNALSYM RASCS_AuthNotify}
  RASCS_AuthRetry = 7;
  {$EXTERNALSYM RASCS_AuthRetry}
  RASCS_AuthCallback = 8;
  {$EXTERNALSYM RASCS_AuthCallback}
  RASCS_AuthChangePassword = 9;
  {$EXTERNALSYM RASCS_AuthChangePassword}
  RASCS_AuthProject = 10;
  {$EXTERNALSYM RASCS_AuthProject}
  RASCS_AuthLinkSpeed = 11;
  {$EXTERNALSYM RASCS_AuthLinkSpeed}
  RASCS_AuthAck = 12;
  {$EXTERNALSYM RASCS_AuthAck}
  RASCS_ReAuthenticate = 13;
  {$EXTERNALSYM RASCS_ReAuthenticate}
  RASCS_Authenticated = 14;
  {$EXTERNALSYM RASCS_Authenticated}
  RASCS_PrepareForCallback = 15;
  {$EXTERNALSYM RASCS_PrepareForCallback}
  RASCS_WaitForModemReset = 16;
  {$EXTERNALSYM RASCS_WaitForModemReset}
  RASCS_WaitForCallback = 17;
  {$EXTERNALSYM RASCS_WaitForCallback}
  RASCS_Projected = 18;
  {$EXTERNALSYM RASCS_Projected}
{$IFDEF WINVER_0x400_OR_GREATER}
  RASCS_StartAuthentication = 19;
  {$EXTERNALSYM RASCS_StartAuthentication}
  RASCS_CallbackComplete = 20;
  {$EXTERNALSYM RASCS_CallbackComplete}
  RASCS_LogonNetwork = 21;
  {$EXTERNALSYM RASCS_LogonNetwork}
{$ENDIF}
  RASCS_SubEntryConnected = 22;
  {$EXTERNALSYM RASCS_SubEntryConnected}
  RASCS_SubEntryDisconnected = 23;
  {$EXTERNALSYM RASCS_SubEntryDisconnected}
  RASCS_Interactive = RASCS_PAUSED;
  {$EXTERNALSYM RASCS_Interactive}
  RASCS_RetryAuthentication = RASCS_PAUSED + 1;
  {$EXTERNALSYM RASCS_RetryAuthentication}
  RASCS_CallbackSetByCaller = RASCS_PAUSED + 2;
  {$EXTERNALSYM RASCS_CallbackSetByCaller}
  RASCS_PasswordExpired = RASCS_PAUSED + 3;
  {$EXTERNALSYM RASCS_PasswordExpired}
{$IFDEF WINVER_0x500_OR_GREATER}
  RASCS_InvokeEapUI = RASCS_PAUSED + 4;
  {$EXTERNALSYM RASCS_InvokeEapUI}
{$ENDIF}
  RASCS_Connected = RASCS_DONE;
  {$EXTERNALSYM RASCS_Connected}
  RASCS_Disconnected = RASCS_DONE + 1;
  {$EXTERNALSYM RASCS_Disconnected}

// Describes the status of a RAS connection.  (See RasConnectionStatus)

type
  PRasConnStatusA = ^TRasConnStatusA;
  PRasConnStatusW = ^TRasConnStatusW;
  PRasConnStatus = PRasConnStatusA;
  tagRASCONNSTATUSA = record
    dwSize: DWORD;
    rasconnstate: TRasConnState;
    dwError: DWORD;
    szDeviceType: packed array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of AnsiChar;
{$IFDEF WINVER_0x401_OR_GREATER}
    szPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of AnsiChar;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASCONNSTATUSA}
  tagRASCONNSTATUSW = record
    dwSize: DWORD;
    rasconnstate: TRasConnState;
    dwError: DWORD;
    szDeviceType: packed array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of WideChar;
{$IFDEF WINVER_0x401_OR_GREATER}
    szPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of WideChar;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASCONNSTATUSW}
  tagRASCONNSTATUS = tagRASCONNSTATUSA;
  TRasConnStatusA = tagRASCONNSTATUSA;
  TRasConnStatusW = tagRASCONNSTATUSW;
  TRasConnStatus = TRasConnStatusA;
  RASCONNSTATUSA = tagRASCONNSTATUSA;
  {$EXTERNALSYM RASCONNSTATUSA}
  RASCONNSTATUSW = tagRASCONNSTATUSW;
  {$EXTERNALSYM RASCONNSTATUSW}
  RASCONNSTATUS = RASCONNSTATUSA;

// Describes connection establishment parameters.  (See RasDial)
  PRasDialParamsA = ^TRasDialParamsA;
  PRasDialParamsW = ^TRasDialParamsW;
  PRasDialParams = PRasDialParamsA;
  tagRASDIALPARAMSA = record
    dwSize: DWORD;
    szEntryName: packed array[0..RAS_MaxEntryName] of AnsiChar;
    szPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of AnsiChar;
    szCallbackNumber: packed array[0..RAS_MaxCallbackNumber] of AnsiChar;
    szUserName: packed array[0..UNLEN] of AnsiChar;
    szPassword: packed array[0..PWLEN] of AnsiChar;
    szDomain: packed array[0..DNLEN] of AnsiChar;
{$IFDEF WINVER_0x401_OR_GREATER}
    dwSubEntry: DWORD;
    dwCallbackId: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASDIALPARAMSA}
  tagRASDIALPARAMSW = record
    dwSize: DWORD;
    szEntryName: packed array[0..RAS_MaxEntryName] of WideChar;
    szPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of WideChar;
    szCallbackNumber: packed array[0..RAS_MaxCallbackNumber] of WideChar;
    szUserName: packed array[0..UNLEN] of WideChar;
    szPassword: packed array[0..PWLEN] of WideChar;
    szDomain: packed array[0..DNLEN] of WideChar;
{$IFDEF WINVER_0x401_OR_GREATER}
    dwSubEntry: DWORD;
    dwCallbackId: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASDIALPARAMSW}
  tagRASDIALPARAMS = tagRASDIALPARAMSA;
  TRasDialParamsA = tagRASDIALPARAMSA;
  TRasDialParamsW = tagRASDIALPARAMSW;
  TRasDialParams = TRasDialParamsA;
  RASDIALPARAMSA = tagRASDIALPARAMSA;
  {$EXTERNALSYM RASDIALPARAMSA}
  RASDIALPARAMSW = tagRASDIALPARAMSW;
  {$EXTERNALSYM RASDIALPARAMSW}
  RASDIALPARAMS = RASDIALPARAMSA;

{$IFDEF WINVER_0x500_OR_GREATER}
  PRasEapInfo = ^TRasEapInfo;
  tagRASEAPINFO = record
    dwSizeofEapInfo: DWORD;
    pbEapInfo: Pointer;
  end;
  {$EXTERNALSYM tagRASEAPINFO}
  TRasEapInfo = tagRASEAPINFO;
  RASEAPINFO = tagRASEAPINFO;
  {$EXTERNALSYM RASEAPINFO}
{$ENDIF}

// Describes extended connection establishment options.  (See RasDial)

  PRasDialExtensions = ^TRasDialExtensions;
  tagRASDIALEXTENSIONS = record
    dwSize: DWORD;
    dwfOptions: DWORD;
    hwndParent: HWND;
    reserved: DWORD;
{$IFDEF WINVER_0x500_OR_GREATER}
    reserved1: DWORD;
    RasEapInfo: TRasEapInfo;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASDIALEXTENSIONS}
  TRasDialExtensions = tagRASDIALEXTENSIONS;
  RASDIALEXTENSIONS = tagRASDIALEXTENSIONS;
  {$EXTERNALSYM RASDIALEXTENSIONS}

// 'dwfOptions' bit flags.

const
  RDEOPT_UsePrefixSuffix           = $00000001;
  {$EXTERNALSYM RDEOPT_UsePrefixSuffix}
  RDEOPT_PausedStates              = $00000002;
  {$EXTERNALSYM RDEOPT_PausedStates}
  RDEOPT_IgnoreModemSpeaker        = $00000004;
  {$EXTERNALSYM RDEOPT_IgnoreModemSpeaker}
  RDEOPT_SetModemSpeaker           = $00000008;
  {$EXTERNALSYM RDEOPT_SetModemSpeaker}
  RDEOPT_IgnoreSoftwareCompression = $00000010;
  {$EXTERNALSYM RDEOPT_IgnoreSoftwareCompression}
  RDEOPT_SetSoftwareCompression    = $00000020;
  {$EXTERNALSYM RDEOPT_SetSoftwareCompression}
  RDEOPT_DisableConnectedUI        = $00000040;
  {$EXTERNALSYM RDEOPT_DisableConnectedUI}
  RDEOPT_DisableReconnectUI        = $00000080;
  {$EXTERNALSYM RDEOPT_DisableReconnectUI}
  RDEOPT_DisableReconnect          = $00000100;
  {$EXTERNALSYM RDEOPT_DisableReconnect}
  RDEOPT_NoUser                    = $00000200;
  {$EXTERNALSYM RDEOPT_NoUser}
  RDEOPT_PauseOnScript             = $00000400;
  {$EXTERNALSYM RDEOPT_PauseOnScript}
  RDEOPT_Router                    = $00000800;
  {$EXTERNALSYM RDEOPT_Router}
{$IFDEF WINVER_0x500_OR_GREATER}
  RDEOPT_CustomDial                = $00001000;
  {$EXTERNALSYM RDEOPT_CustomDial}
{$ENDIF}

// This flag when set in the RASENTRYNAME structure
// indicates that the phonebook to which this entry
// belongs is a system phonebook.

  REN_User                         = $00000000;
  {$EXTERNALSYM REN_User}
  REN_AllUsers                     = $00000001;
  {$EXTERNALSYM REN_AllUsers}

// Describes an enumerated RAS phone book entry name.  (See RasEntryEnum)

type
  PRasEntryNameA = ^TRasEntryNameA;
  PRasEntryNameW = ^TRasEntryNameW;
  PRasEntryName = PRasEntryNameA;
  tagRASENTRYNAMEA = record
    dwSize: DWORD;
    szEntryName: packed array[0..RAS_MaxEntryName] of AnsiChar;
{$IFDEF WINVER_0x500_OR_GREATER}
    dwFlags: DWORD;
    szPhonebookPath: packed array[0..MAX_PATH] of AnsiChar;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASENTRYNAMEA}
  tagRASENTRYNAMEW = record
    dwSize: DWORD;
    szEntryName: packed array[0..RAS_MaxEntryName] of WideChar;
{$IFDEF WINVER_0x500_OR_GREATER}
    dwFlags: DWORD;
    szPhonebookPath: packed array[0..MAX_PATH] of WideChar;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASENTRYNAMEW}
  tagRASENTRYNAME = tagRASENTRYNAMEA;
  TRasEntryNameA = tagRASENTRYNAMEA;
  TRasEntryNameW = tagRASENTRYNAMEW;
  TRasEntryName = TRasEntryNameA;
  RASENTRYNAMEA = tagRASENTRYNAMEA;
  {$EXTERNALSYM RASENTRYNAMEA}
  RASENTRYNAMEW = tagRASENTRYNAMEW;
  {$EXTERNALSYM RASENTRYNAMEW}
  RASENTRYNAME = RASENTRYNAMEA;

// Protocol code to projection data structure mapping.

type
  PRasProjection = ^TRasProjection;
  TRasProjection = DWORD;

const
  RASP_Amb = $10000;
  {$EXTERNALSYM RASP_Amb}
  RASP_PppNbf = $803F;
  {$EXTERNALSYM RASP_PppNbf}
  RASP_PppIpx = $802B;
  {$EXTERNALSYM RASP_PppIpx}
  RASP_PppIp = $8021;
  {$EXTERNALSYM RASP_PppIp}
{$IFDEF WINVER_0x500_OR_GREATER}
  RASP_PppCcp = $80FD;
  {$EXTERNALSYM RASP_PppCcp}
{$ENDIF}
  RASP_PppLcp = $C021;
  {$EXTERNALSYM RASP_PppLcp}
  RASP_Slip = $20000;
  {$EXTERNALSYM RASP_Slip}

// Describes the result of a RAS AMB (Authentication Message Block)
// projection.  This protocol is used with NT 3.1 and OS/2 1.3 downlevel
// RAS servers.

type
  PRasAmbA = ^TRasAmbA;
  PRasAmbW = ^TRasAmbW;
  PRasAmb = PRasAmbA;
  tagRASAMBA = record
    dwSize: DWORD;
    dwError: DWORD;
    szNetBiosError: packed array[0..NETBIOS_NAME_LEN] of AnsiChar;
    bLana: Byte;
  end;
  {$EXTERNALSYM tagRASAMBA}
  tagRASAMBW = record
    dwSize: DWORD;
    dwError: DWORD;
    szNetBiosError: packed array[0..NETBIOS_NAME_LEN] of WideChar;
    bLana: Byte;
  end;
  {$EXTERNALSYM tagRASAMBW}
  tagRASAMB = tagRASAMBA;
  TRasAmbA = tagRASAMBA;
  TRasAmbW = tagRASAMBW;
  TRasAmb = TRasAmbA;
  RASAMBA = tagRASAMBA;
  {$EXTERNALSYM RASAMBA}
  RASAMBW = tagRASAMBW;
  {$EXTERNALSYM RASAMBW}
  RASAMB = RASAMBA;

// Describes the result of a PPP NBF (NetBEUI) projection.

  PRasPppNBFA = ^TRasPppNBFA;
  PRasPppNBFW = ^TRasPppNBFW;
  PRasPppNBF = PRasPppNBFA;
  tagRASPPPNBFA = record
    dwSize: DWORD;
    dwError: DWORD;
    dwNetBiosError: DWORD;
    szNetBiosError: packed array[0..NETBIOS_NAME_LEN] of AnsiChar;
    szWorkstationName: packed array[0..NETBIOS_NAME_LEN] of AnsiChar;
    bLana: Byte;
  end;
  {$EXTERNALSYM tagRASPPPNBFA}
  tagRASPPPNBFW = record
    dwSize: DWORD;
    dwError: DWORD;
    dwNetBiosError: DWORD;
    szNetBiosError: packed array[0..NETBIOS_NAME_LEN] of WideChar;
    szWorkstationName: packed array[0..NETBIOS_NAME_LEN] of WideChar;
    bLana: Byte;
  end;
  {$EXTERNALSYM tagRASPPPNBFW}
  tagRASPPPNBF = tagRASPPPNBFA;
  TRasPppNBFA = tagRASPPPNBFA;
  TRasPppNBFW = tagRASPPPNBFW;
  TRasPppNBF = TRasPppNBFA;
  RASPPPNBFA = tagRASPPPNBFA;
  {$EXTERNALSYM tagRASPPPNBFA}
  RASPPPNBFW = tagRASPPPNBFW;
  {$EXTERNALSYM tagRASPPPNBFW}
  RASPPPNBF = RASPPPNBFA;

// Describes the results of a PPP IPX (Internetwork Packet Exchange) projection.

  PRasPppIPXA = ^TRasPppIPXA;
  PRasPppIPXW = ^TRasPppIPXW;
  PRasPppIPX = PRasPppIPXA;
  tagRASPPPIPXA = record
    dwSize: DWORD;
    dwError: DWORD;
    szIpxAddress: packed array[0..RAS_MaxIpxAddress] of AnsiChar;
  end;
  {$EXTERNALSYM tagRASPPPIPXA}
  tagRASPPPIPXW = record
    dwSize: DWORD;
    dwError: DWORD;
    szIpxAddress: packed array[0..RAS_MaxIpxAddress] of WideChar;
  end;
  {$EXTERNALSYM tagRASPPPIPXW}
  tagRASPPPIPX = tagRASPPPIPXA;
  TRasPppIPXA = tagRASPPPIPXA;
  TRasPppIPXW = tagRASPPPIPXW;
  TRasPppIPX = TRasPppIPXA;
  RASPPPIPXA = tagRASPPPIPXA;
  {$EXTERNALSYM RASPPPIPXA}
  RASPPPIPXW = tagRASPPPIPXW;
  {$EXTERNALSYM RASPPPIPXW}
  RASPPPIPX = RASPPPIPXA;

// Describes the results of a PPP IP (Internet) projection

{$IFDEF WINVER_0x500_OR_GREATER}
// RASPPPIP 'dwOptions' and 'dwServerOptions' flags
const
  RASIPO_VJ       = $00000001;
  {$EXTERNALSYM RASIPO_VJ}
{$ENDIF}

type
  PRasPppIPA = ^TPRasPppIPA;
  PRasPppIPW = ^TPRasPppIPW;
  PRasPppIP = PRasPppIPA;
  tagRASIPA = record
    dwSize: DWORD;
    dwError: DWORD;
    szIpAddress: packed array[0..RAS_MaxIpAddress] of AnsiChar;
  end;
  {$EXTERNALSYM tagRASIPA}
  tagRASIPW = record
    dwSize: DWORD;
    dwError: DWORD;
    szIpAddress: packed array[0..RAS_MaxIpAddress] of WideChar;
  end;
  {$EXTERNALSYM tagRASIPW}
  tagRASIP = tagRASIPA;
  TPRasPppIPA = tagRASIPA;
  TPRasPppIPW = tagRASIPW;
  TPRasPppIP = TPRasPppIPA;
  RASIPA = tagRASIPA;
  {$EXTERNALSYM RASIPA}
  RASIPW = tagRASIPW;
  {$EXTERNALSYM RASIPW}
  RASIP = RASIPA;

{#ifndef WINNT35COMPATIBLE

    /* This field was added between Windows NT 3.51 beta and Windows NT 3.51
    ** final, and between Windows 95 M8 beta and Windows 95 final.  If you do
    ** not require the server address and wish to retrieve PPP IP information
    ** from Windows NT 3.5 or early Windows NT 3.51 betas, or on early Windows
    ** 95 betas, define WINNT35COMPATIBLE.
    **
    ** The server IP address is not provided by all PPP implementations,
    ** though Windows NT server's do provide it.
    */
    WCHAR szServerIpAddress[ RAS_MaxIpAddress + 1 ];

#endif}

{$IFDEF WINVER_0x500_OR_GREATER}
const
// RASPPPLCP 'dwAuthenticatonProtocol' values.
  RASLCPAP_PAP          = $C023;
  {$EXTERNALSYM RASLCPAP_PAP}
  RASLCPAP_SPAP         = $C027;
  {$EXTERNALSYM RASLCPAP_SPAP}
  RASLCPAP_CHAP         = $C223;
  {$EXTERNALSYM RASLCPAP_CHAP}
  RASLCPAP_EAP          = $C227;
  {$EXTERNALSYM RASLCPAP_EAP}

// RASPPPLCP 'dwAuthenticatonData' values.
  RASLCPAD_CHAP_MD5     = $05;
  {$EXTERNALSYM RASLCPAD_CHAP_MD5}
  RASLCPAD_CHAP_MS      = $80;
  {$EXTERNALSYM RASLCPAD_CHAP_MS}
  RASLCPAD_CHAP_MSV2    = $81;
  {$EXTERNALSYM RASLCPAD_CHAP_MSV2}

// RASPPPLCP 'dwOptions' and 'dwServerOptions' flags.
  RASLCPO_PFC           = $00000001;
  {$EXTERNALSYM RASLCPO_PFC}
  RASLCPO_ACFC          = $00000002;
  {$EXTERNALSYM RASLCPO_ACFC}
  RASLCPO_SSHF          = $00000004;
  {$EXTERNALSYM RASLCPO_SSHF}
  RASLCPO_DES_56        = $00000008;
  {$EXTERNALSYM RASLCPO_DES_56}
  RASLCPO_3_DES         = $00000010;
  {$EXTERNALSYM RASLCPO_3_DES}
{$ENDIF}

// Describes the results of a PPP LCP/multi-link negotiation.

type
  PRasPppLCPA = ^TRasPppLCPA;
  PRasPppLCPW = ^TRasPppLCPW;
  PRasPppLCP = PRasPppLCPA;
  tagRASPPPLCPA = record
    dwSize: DWORD;
    fBundled: BOOL;
{$IFDEF WINVER_0x500_OR_GREATER}
    dwError: DWORD;
    dwAuthenticationProtocol: DWORD;
    dwAuthenticationData: DWORD;
    dwEapTypeId: DWORD;
    dwServerAuthenticationProtocol: DWORD;
    dwServerAuthenticationData: DWORD;
    dwServerEapTypeId: DWORD;
    fMultilink: BOOL;
    dwTerminateReason: DWORD;
    dwServerTerminateReason: DWORD;
    szReplyMessage: array[0..RAS_MaxReplyMessage - 1] of WideChar;
    dwOptions: DWORD;
    dwServerOptions: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASPPPLCPA}
  tagRASPPPLCPW = record
    dwSize: DWORD;
    fBundled: BOOL;
{$IFDEF WINVER_0x500_OR_GREATER}
    dwError: DWORD;
    dwAuthenticationProtocol: DWORD;
    dwAuthenticationData: DWORD;
    dwEapTypeId: DWORD;
    dwServerAuthenticationProtocol: DWORD;
    dwServerAuthenticationData: DWORD;
    dwServerEapTypeId: DWORD;
    fMultilink: BOOL;
    dwTerminateReason: DWORD;
    dwServerTerminateReason: DWORD;
    szReplyMessage: array[0..RAS_MaxReplyMessage - 1] of WideChar;
    dwOptions: DWORD;
    dwServerOptions: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASPPPLCPW}
  tagRASPPPLCP = tagRASPPPLCPA;
  TRasPppLCPA = tagRASPPPLCPA;
  TRasPppLCPW = tagRASPPPLCPW;
  TRasPppLCP = TRasPppLCPA;
  RASPPPLCPA = tagRASPPPLCPA;
  {$EXTERNALSYM RASPPPLCPA}
  RASPPPLCPW = tagRASPPPLCPW;
  {$EXTERNALSYM RASPPPLCPW}
  RASPPPLCP = RASPPPLCPA;

// Describes the results of a SLIP (Serial Line IP) projection.

  PRasSlipA = ^TRasSlipA;
  PRasSlipW = ^TRasSlipW;
  PRasSlip = PRasSlipA;
  tagRASSLIPA = record
    dwSize: DWORD;
    dwError: DWORD;
    szIpAddress: packed array[0..RAS_MaxIpAddress] of AnsiChar;
  end;
  {$EXTERNALSYM tagRASSLIPA}
  tagRASSLIPW = record
    dwSize: DWORD;
    dwError: DWORD;
    szIpAddress: packed array[0..RAS_MaxIpAddress] of WideChar;
  end;
  {$EXTERNALSYM tagRASSLIPW}
  tagRASSLIP = tagRASSLIPA;
  TRasSlipA = tagRASSLIPA;
  TRasSlipW = tagRASSLIPW;
  TRasSlip = TRasSlipA;
  RASSLIPA = tagRASSLIPA;
  {$EXTERNALSYM RASSLIPA}
  RASSLIPW = tagRASSLIPW;
  {$EXTERNALSYM RASSLIPW}
  RASSLIP = RASSLIPA;

{$IFDEF WINVER_0x500_OR_GREATER}

// Describes the results of a PPP CCP (Compression Control Protocol)

const

// RASPPPCCP 'dwCompressionAlgorithm' values.
  RASCCPCA_MPPC         = $00000006;
  {$EXTERNALSYM RASCCPCA_MPPC}
  RASCCPCA_STAC         = $00000005;
  {$EXTERNALSYM RASCCPCA_STAC}

// RASPPPCCP 'dwOptions' values.
  RASCCPO_Compression       = $00000001;
  {$EXTERNALSYM RASCCPO_Compression}
  RASCCPO_HistoryLess       = $00000002;
  {$EXTERNALSYM RASCCPO_HistoryLess}
  RASCCPO_Encryption56bit   = $00000010;
  {$EXTERNALSYM RASCCPO_Encryption56bit}
  RASCCPO_Encryption40bit   = $00000020;
  {$EXTERNALSYM RASCCPO_Encryption40bit}
  RASCCPO_Encryption128bit  = $00000040;
  {$EXTERNALSYM RASCCPO_Encryption128bit}

type
  PRasPppCcp = ^TRasPppCcp;
  tagRASPPPCCP = record
    dwSize: DWORD;
    dwError: DWORD;
    dwCompressionAlgorithm: DWORD;
    dwOptions: DWORD;
    dwServerCompressionAlgorithm: DWORD;
    dwServerOptions: DWORD;
  end;
  {$EXTERNALSYM tagRASPPPCCP}
  TRasPppCcp = tagRASPPPCCP;
  RASPPPCCP = tagRASPPPCCP;
  {$EXTERNALSYM RASPPPCCP}

{$ENDIF}


// If using RasDial message notifications, get the notification message code
// by passing this string to the RegisterWindowMessageA() API.
// WM_RASDIALEVENT is used only if a unique message cannot be registered.

const
  RASDIALEVENT    = 'RasDialEvent';
  {$EXTERNALSYM RASDIALEVENT}
  WM_RASDIALEVENT = $CCCD;
  {$EXTERNALSYM WM_RASDIALEVENT}

// Prototypes for caller's RasDial callback handler.  Arguments are the
// message ID (currently always WM_RASDIALEVENT), the current RASCONNSTATE and
// the error that has occurred (or 0 if none).  Extended arguments are the
// handle of the RAS connection and an extended error code.
//
// For RASDIALFUNC2, subsequent callback notifications for all
// subentries can be cancelled by returning FALSE.

type
  TRasDialFunc = procedure (unMsg: UINT; rasconnstate: TRasConnState; dwError: DWORD); stdcall;
  {$EXTERNALSYM TRasDialFunc}
  TRasDialFunc1 = procedure (hrasconn: THRasConn; unMsg: UINT; rascs: TRasConnState;
    dwError: DWORD; dwExtendedError: DWORD); stdcall;
  {$EXTERNALSYM TRasDialFunc1}
  TRasDialFunc2 = function (dwCallbackId: DWORD; dwSubEntry: DWORD;
    hrasconn: THRasConn; unMsg: UINT; rascs: TRasConnState; dwError: DWORD;
    dwExtendedError: DWORD): DWORD; stdcall;
  {$EXTERNALSYM TRasDialFunc2}

// Information describing a RAS-capable device.

  PRasDevInfoA = ^TRasDevInfoA;
  PRasDevInfoW = ^TRasDevInfoW;
  PRasDevInfo = PRasDevInfoA;
  tagRASDEVINFOA = record
    dwSize: DWORD;
    szDeviceType: packed array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of AnsiChar;
  end;
  {$EXTERNALSYM tagRASDEVINFOA}
  tagRASDEVINFOW = record
    dwSize: DWORD;
    szDeviceType: packed array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of WideChar;
  end;
  {$EXTERNALSYM tagRASDEVINFOW}
  tagRASDEVINFO = tagRASDEVINFOA;
  TRasDevInfoA = tagRASDEVINFOA;
  TRasDevInfoW = tagRASDEVINFOW;
  TRasDevInfo = TRasDevInfoA;
  RASDEVINFOA = tagRASDEVINFOA;
  {$EXTERNALSYM RASDEVINFOA}
  RASDEVINFOW = tagRASDEVINFOW;
  {$EXTERNALSYM RASDEVINFOW}
  RASDEVINFO = RASDEVINFOA;

// RAS country information (currently retrieved from TAPI).

  PRasCtryInfoA = ^TRasCtryInfoA;
  PRasCtryInfoW = ^TRasCtryInfoW;
  PRasCtryInfo = PRasCtryInfoA;
  RASCTRYINFOA = record
    dwSize: DWORD;
    dwCountryID: DWORD;
    dwNextCountryID: DWORD;
    dwCountryCode: DWORD;
    dwCountryNameOffset: DWORD;
  end;
  {$EXTERNALSYM RASCTRYINFOA}
  RASCTRYINFOW = record
    dwSize: DWORD;
    dwCountryID: DWORD;
    dwNextCountryID: DWORD;
    dwCountryCode: DWORD;
    dwCountryNameOffset: DWORD;
  end;
  {$EXTERNALSYM RASCTRYINFOW}
  RASCTRYINFO = RASCTRYINFOA;
  TRasCtryInfoA = RASCTRYINFOA;
  TRasCtryInfoW = RASCTRYINFOW;
  TRasCtryInfo = TRasCtryInfoA;
  CTRYINFOA = RASCTRYINFOA;
  {$EXTERNALSYM CTRYINFOA}
  CTRYINFOW = RASCTRYINFOW;
  {$EXTERNALSYM CTRYINFOW}
  CTRYINFO = CTRYINFOA;

// There is currently no difference between RASCTRYINFOA and RASCTRYINFOW.
// This may change in the future.

const
{$IFDEF WINVER_0x500_OR_GREATER}
  ET_40Bit        = 1;
  {$EXTERNALSYM ET_40Bit}
  ET_128Bit       = 2;
  {$EXTERNALSYM ET_128Bit}

  ET_None         = 0;  // No encryption
  {$EXTERNALSYM ET_None}
  ET_Require      = 1;  // Require Encryption
  {$EXTERNALSYM ET_Require}
  ET_RequireMax   = 2;  // Require max encryption
  {$EXTERNALSYM ET_RequireMax}
  ET_Optional     = 3;  // Do encryption if possible. None Ok.
  {$EXTERNALSYM ET_Optional}
{$ENDIF}

  VS_Default	= 0; // default (PPTP for now)
  {$EXTERNALSYM VS_Default}
  VS_PptpOnly   = 1; // Only PPTP is attempted.
  {$EXTERNALSYM VS_PptpOnly}
  VS_PptpFirst	= 2; // PPTP is tried first.
  {$EXTERNALSYM VS_PptpFirst}
  VS_L2tpOnly 	= 3; // Only L2TP is attempted.
  {$EXTERNALSYM VS_L2tpOnly}
  VS_L2tpFirst	= 4; // L2TP is tried first.
  {$EXTERNALSYM VS_L2tpFirst}

type
  TRasIPAddr = record
    a, b, c, d: Byte;
  end;
  RASIPADDR = TRasIPAddr;
  {$EXTERNALSYM RASIPADDR}

// A RAS phone book entry.

  PRasEntryA = ^TRasEntryA;
  PRasEntryW = ^TRasEntryW;
  PRasEntry = PRasEntryA;
  tagRASENTRYA = record
    dwSize: DWORD;
    dwfOptions: DWORD;
    // Location/phone number.
    dwCountryID: DWORD;
    dwCountryCode: DWORD;
    szAreaCode: packed array[0..RAS_MaxAreaCode] of AnsiChar;
    szLocalPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of AnsiChar;
    dwAlternateOffset: DWORD;
    // PPP/Ip
    ipaddr: RASIPADDR;
    ipaddrDns: RASIPADDR;
    ipaddrDnsAlt: RASIPADDR;
    ipaddrWins: RASIPADDR;
    ipaddrWinsAlt: RASIPADDR;
    // Framing
    dwFrameSize: DWORD;
    dwfNetProtocols: DWORD;
    dwFramingProtocol: DWORD;
    // Scripting
    szScript: packed array[0..MAX_PATH-1] of AnsiChar;
    // AutoDial
    szAutodialDll: packed array[0..MAX_PATH-1] of AnsiChar;
    szAutodialFunc: packed array[0..MAX_PATH-1] of AnsiChar;
    // Device
    szDeviceType: packed array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of AnsiChar;
    // X.25
    szX25PadType: packed array[0..RAS_MaxPadType] of AnsiChar;
    szX25Address: packed array[0..RAS_MaxX25Address] of AnsiChar;
    szX25Facilities: packed array[0..RAS_MaxFacilities] of AnsiChar;
    szX25UserData: packed array[0..RAS_MaxUserData] of AnsiChar;
    dwChannels: DWORD;
    // Reserved
    dwReserved1: DWORD;
    dwReserved2: DWORD;
{$IFDEF WINVER_0x401_OR_GREATER}
    // Multilink
    dwSubEntries: DWORD;
    dwDialMode: DWORD;
    dwDialExtraPercent: DWORD;
    dwDialExtraSampleSeconds: DWORD;
    dwHangUpExtraPercent: DWORD;
    dwHangUpExtraSampleSeconds: DWORD;
    // Idle timeout
    dwIdleDisconnectSeconds: DWORD;
{$ENDIF}
{$IFDEF WINVER_0x500_OR_GREATER}
    dwType: DWORD;
    dwEncryptionType: DWORD;
    dwCustomAuthKey: DWORD;
    guidId: TGUID;
    szCustomDialDll: packed array[0..MAX_PATH-1] of AnsiChar;
    dwVpnStrategy: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASENTRYA}
  tagRASENTRYW = record
    dwSize: DWORD;
    dwfOptions: DWORD;
    // Location/phone number.
    dwCountryID: DWORD;
    dwCountryCode: DWORD;
    szAreaCode: packed array[0..RAS_MaxAreaCode] of WideChar;
    szLocalPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of WideChar;
    dwAlternateOffset: DWORD;
    // PPP/Ip
    ipaddr: RASIPADDR;
    ipaddrDns: RASIPADDR;
    ipaddrDnsAlt: RASIPADDR;
    ipaddrWins: RASIPADDR;
    ipaddrWinsAlt: RASIPADDR;
    // Framing
    dwFrameSize: DWORD;
    dwfNetProtocols: DWORD;
    dwFramingProtocol: DWORD;
    // Scripting
    szScript: packed array[0..MAX_PATH-1] of WideChar;
    // AutoDial
    szAutodialDll: packed array[0..MAX_PATH-1] of WideChar;
    szAutodialFunc: packed array[0..MAX_PATH-1] of WideChar;
    // Device
    szDeviceType: packed array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of WideChar;
    // X.25
    szX25PadType: packed array[0..RAS_MaxPadType] of WideChar;
    szX25Address: packed array[0..RAS_MaxX25Address] of WideChar;
    szX25Facilities: packed array[0..RAS_MaxFacilities] of WideChar;
    szX25UserData: packed array[0..RAS_MaxUserData] of WideChar;
    dwChannels: DWORD;
    // Reserved
    dwReserved1: DWORD;
    dwReserved2: DWORD;
{$IFDEF WINVER_0x401_OR_GREATER}
    // Multilink
    dwSubEntries: DWORD;
    dwDialMode: DWORD;
    dwDialExtraPercent: DWORD;
    dwDialExtraSampleSeconds: DWORD;
    dwHangUpExtraPercent: DWORD;
    dwHangUpExtraSampleSeconds: DWORD;
    // Idle timeout
    dwIdleDisconnectSeconds: DWORD;
{$ENDIF}
{$IFDEF WINVER_0x500_OR_GREATER}
    dwType: DWORD;
    dwEncryptionType: DWORD;
    dwCustomAuthKey: DWORD;
    guidId: TGUID;
    szCustomDialDll: packed array[0..MAX_PATH-1] of WideChar;
    dwVpnStrategy: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM tagRASENTRYW}
  tagRASENTRY = tagRASENTRYA;
  TRasEntryA = tagRASENTRYA;
  TRasEntryW = tagRASENTRYW;
  TRasEntry = TRasEntryA;
  RASENTRYA = tagRASENTRYA;
  {$EXTERNALSYM RASENTRYA}
  RASENTRYW = tagRASENTRYW;
  {$EXTERNALSYM RASENTRYW}
  RASENTRY = RASENTRYA;

// RASENTRY 'dwfOptions' bit flags.

const
  RASEO_UseCountryAndAreaCodes    = $00000001;
  {$EXTERNALSYM RASEO_UseCountryAndAreaCodes}
  RASEO_SpecificIpAddr            = $00000002;
  {$EXTERNALSYM RASEO_SpecificIpAddr}
  RASEO_SpecificNameServers       = $00000004;
  {$EXTERNALSYM RASEO_SpecificNameServers}
  RASEO_IpHeaderCompression       = $00000008;
  {$EXTERNALSYM RASEO_IpHeaderCompression}
  RASEO_RemoteDefaultGateway      = $00000010;
  {$EXTERNALSYM RASEO_RemoteDefaultGateway}
  RASEO_DisableLcpExtensions      = $00000020;
  {$EXTERNALSYM RASEO_DisableLcpExtensions}
  RASEO_TerminalBeforeDial        = $00000040;
  {$EXTERNALSYM RASEO_TerminalBeforeDial}
  RASEO_TerminalAfterDial         = $00000080;
  {$EXTERNALSYM RASEO_TerminalAfterDial}
  RASEO_ModemLights               = $00000100;
  {$EXTERNALSYM RASEO_ModemLights}
  RASEO_SwCompression             = $00000200;
  {$EXTERNALSYM RASEO_SwCompression}
  RASEO_RequireEncryptedPw        = $00000400;
  {$EXTERNALSYM RASEO_RequireEncryptedPw}
  RASEO_RequireMsEncryptedPw      = $00000800;
  {$EXTERNALSYM RASEO_RequireMsEncryptedPw}
  RASEO_RequireDataEncryption     = $00001000;
  {$EXTERNALSYM RASEO_RequireDataEncryption}
  RASEO_NetworkLogon              = $00002000;
  {$EXTERNALSYM RASEO_NetworkLogon}
  RASEO_UseLogonCredentials       = $00004000;
  {$EXTERNALSYM RASEO_UseLogonCredentials}
  RASEO_PromoteAlternates         = $00008000;
  {$EXTERNALSYM RASEO_PromoteAlternates}
{$IFDEF WINVER_0x401_OR_GREATER}
  RASEO_SecureLocalFiles          = $00010000;
  {$EXTERNALSYM RASEO_SecureLocalFiles}
{$ENDIF}
{$IFDEF WINVER_0x500_OR_GREATER}
  RASEO_RequireEAP                = $00020000;
  {$EXTERNALSYM RASEO_RequireEAP}
  RASEO_RequirePAP                = $00040000;
  {$EXTERNALSYM RASEO_RequirePAP}
  RASEO_RequireSPAP               = $00080000;
  {$EXTERNALSYM RASEO_RequireSPAP}
  RASEO_Custom                    = $00100000;
  {$EXTERNALSYM RASEO_Custom}
  RASEO_PreviewPhoneNumber        = $00200000;
  {$EXTERNALSYM RASEO_PreviewPhoneNumber}
  RASEO_SharedPhoneNumbers        = $00800000;
  {$EXTERNALSYM RASEO_SharedPhoneNumbers}
  RASEO_PreviewUserPw             = $01000000;
  {$EXTERNALSYM RASEO_PreviewUserPw}
  RASEO_PreviewDomain             = $02000000;
  {$EXTERNALSYM RASEO_PreviewDomain}
  RASEO_ShowDialingProgress       = $04000000;
  {$EXTERNALSYM RASEO_ShowDialingProgress}
  RASEO_RequireCHAP               = $08000000;
  {$EXTERNALSYM RASEO_RequireCHAP}
  RASEO_RequireMsCHAP             = $10000000;
  {$EXTERNALSYM RASEO_RequireMsCHAP}
  RASEO_RequireMsCHAP2            = $20000000;
  {$EXTERNALSYM RASEO_RequireMsCHAP2}
  RASEO_RequireW95MSCHAP          = $40000000;
  {$EXTERNALSYM RASEO_RequireW95MSCHAP}
  RASEO_CustomScript              = $80000000;
  {$EXTERNALSYM RASEO_CustomScript}
{$ENDIF}


// RASENTRY 'dwProtocols' bit flags.
  RASNP_NetBEUI                   = $00000001;
  {$EXTERNALSYM RASNP_NetBEUI}
  RASNP_Ipx                       = $00000002;
  {$EXTERNALSYM RASNP_Ipx}
  RASNP_Ip                        = $00000004;
  {$EXTERNALSYM RASNP_Ip}

// RASENTRY 'dwFramingProtocols' bit flags.
  RASFP_Ppp                       = $00000001;
  {$EXTERNALSYM RASFP_Ppp}
  RASFP_Slip                      = $00000002;
  {$EXTERNALSYM RASFP_Slip}
  RASFP_Ras                       = $00000004;
  {$EXTERNALSYM RASFP_Ras}

// RASENTRY 'szDeviceType' default strings.
  RASDT_Modem                     = 'modem';
  {$EXTERNALSYM RASDT_Modem}
  RASDT_Isdn                      = 'isdn';
  {$EXTERNALSYM RASDT_Isdn}
  RASDT_X25                       = 'x25';
  {$EXTERNALSYM RASDT_X25}
  RASDT_Vpn                       = 'vpn';
  {$EXTERNALSYM RASDT_Vpn}
  RASDT_Pad                       = 'pad';
  {$EXTERNALSYM RASDT_Pad}
  RASDT_Generic                   = 'GENERIC';
  {$EXTERNALSYM RASDT_Generic}
  RASDT_Serial                    = 'SERIAL';
  {$EXTERNALSYM RASDT_Serial}
  RASDT_FrameRelay                = 'FRAMERELAY';
  {$EXTERNALSYM RASDT_FrameRelay}
  RASDT_Atm                       = 'ATM';
  {$EXTERNALSYM RASDT_Atm}
  RASDT_Sonet                     = 'SONET';
  {$EXTERNALSYM RASDT_Sonet}
  RASDT_SW56                      = 'SW56';
  {$EXTERNALSYM RASDT_SW56}
  RASDT_Irda                      = 'IRDA';
  {$EXTERNALSYM RASDT_Irda}
  RASDT_Parallel                  = 'PARALLEL';
  {$EXTERNALSYM RASDT_Parallel}

// The entry type used to determine which UI properties
// are to be presented to user.  This generally corresponds
// to a Connections "add" wizard selection.

  RASET_Phone    = 1;  // Phone lines: modem, ISDN, X.25, etc
  {$EXTERNALSYM RASET_Phone}
  RASET_Vpn      = 2;  // Virtual private network
  {$EXTERNALSYM RASET_Vpn}
  RASET_Direct   = 3;  // Direct connect: serial, parallel
  {$EXTERNALSYM RASET_Direct}
  RASET_Internet = 4;  // BaseCamp internet
  {$EXTERNALSYM RASET_Internet}


// Old AutoDial DLL function prototype.
//
// This prototype is documented for backward-compatibility
// purposes only.  It is superceded by the RASADFUNCA
// and RASADFUNCW definitions below.  DO NOT USE THIS
// PROTOTYPE IN NEW CODE.  SUPPORT FOR IT MAY BE REMOVED
// IN FUTURE VERSIONS OF RAS.

type
 TORASADFunc = function(hwndOwner: HWND; lpszEntry: LPSTR; dwFlags: DWORD;
   var lpdwRetCode: DWORD): BOOL; stdcall;
 {$EXTERNALSYM TORASADFunc}

{$IFDEF WINVER_0x401_OR_GREATER}
const
// Flags for RasConnectionNotification().
  RASCN_Connection        = $00000001;
  {$EXTERNALSYM RASCN_Connection}
  RASCN_Disconnection     = $00000002;
  {$EXTERNALSYM RASCN_Disconnection}
  RASCN_BandwidthAdded    = $00000004;
  {$EXTERNALSYM RASCN_BandwidthAdded}
  RASCN_BandwidthRemoved  = $00000008;
  {$EXTERNALSYM RASCN_BandwidthRemoved}

// RASENTRY 'dwDialMode' values.
  RASEDM_DialAll          = 1;
  {$EXTERNALSYM RASEDM_DialAll}
  RASEDM_DialAsNeeded     = 2;
  {$EXTERNALSYM RASEDM_DialAsNeeded}

// RASENTRY 'dwIdleDisconnectSeconds' constants.
  RASIDS_Disabled         = $ffffffff;
  {$EXTERNALSYM RASIDS_Disabled}
  RASIDS_UseGlobalValue   = $0;
  {$EXTERNALSYM RASIDS_UseGlobalValue}

// AutoDial DLL function parameter block.
type
  PRasAdParams = ^TRasAdParams;
  tagRASADPARAMS = record
    dwSize: DWORD;
    hwndOwner: HWND;
    dwFlags: DWORD;
    xDlg: LongInt;
    yDlg: LongInt;
 end;
 {$EXTERNALSYM tagRASADPARAMS}
 TRasAdParams = tagRASADPARAMS;
 RASADPARAMS = tagRASADPARAMS;
 {$EXTERNALSYM RASADPARAMS}

// AutoDial DLL function parameter block 'dwFlags.'

const
  RASADFLG_PositionDlg            = $00000001;
  {$EXTERNALSYM RASADFLG_PositionDlg}

// Prototype AutoDial DLL function.
type
  TRasAdFuncA = function (lpszPhonebook: PAnsiChar; lpszEntry: PAnsiChar;
    lpAutodialParams: PRasAdParams; var lpdwRetCode: DWORD): BOOL; stdcall;
  TRasAdFuncW = function (lpszPhonebook: PWideChar; lpszEntry: PWideChar;
    lpAutodialParams: PRasAdParams; var lpdwRetCode: DWORD): BOOL; stdcall;
  TRasAdFunc = TRasAdFuncA;

// A RAS phone book multilinked sub-entry.
  PRasSubEntryA = ^TRasSubEntryA;
  PRasSubEntryW = ^TRasSubEntryW;
  PRasSubEntry = PRasSubEntryA;
  tagRASSUBENTRYA = record
    dwSize: DWORD;
    dwfFlags: DWORD;
    // Device
    szDeviceType: packed array[0..RAS_MaxDeviceType] of AnsiChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of AnsiChar;
    // Phone numbers
    szLocalPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of AnsiChar;
    dwAlternateOffset: DWORD;
  end;
  {$EXTERNALSYM tagRASSUBENTRYA}
  tagRASSUBENTRYW = record
    dwSize: DWORD;
    dwfFlags: DWORD;
    // Device
    szDeviceType: packed array[0..RAS_MaxDeviceType] of WideChar;
    szDeviceName: packed array[0..RAS_MaxDeviceName] of WideChar;
    // Phone numbers
    szLocalPhoneNumber: packed array[0..RAS_MaxPhoneNumber] of WideChar;
    dwAlternateOffset: DWORD;
  end;
  {$EXTERNALSYM tagRASSUBENTRYW}
  tagRASSUBENTRY = tagRASSUBENTRYA;
  TRasSubEntryA = tagRASSUBENTRYA;
  TRasSubEntryW = tagRASSUBENTRYW;
  TRasSubEntry = TRasSubEntryA;
  RASSUBENTRYA = tagRASSUBENTRYA;
  {$EXTERNALSYM RASSUBENTRYA}
  RASSUBENTRYW = tagRASSUBENTRYW;
  {$EXTERNALSYM RASSUBENTRYW}
  RASSUBENTRY = RASSUBENTRYA;

// Ras(Get,Set)Credentials structure. These calls supercede Ras(Get,Set)EntryDialParams.

  PRasCredentialsA = ^TRasCredentialsA;
  PRasCredentialsW = ^TRasCredentialsW;
  PRasCredentials = PRasCredentialsA;
  tagRASCREDENTIALSA = record
    dwSize: DWORD;
    dwMask: DWORD;
    szUserName: packed array[0..UNLEN] of AnsiChar;
    szPassword: packed array[0..PWLEN] of AnsiChar;
    szDomain: packed array[0..DNLEN] of AnsiChar;
  end;
  {$EXTERNALSYM tagRASCREDENTIALSA}
  tagRASCREDENTIALSW = record
    dwSize: DWORD;
    dwMask: DWORD;
    szUserName: packed array[0..UNLEN] of WideChar;
    szPassword: packed array[0..PWLEN] of WideChar;
    szDomain: packed array[0..DNLEN] of WideChar;
  end;
  {$EXTERNALSYM tagRASCREDENTIALSW}
  tagRASCREDENTIALS = tagRASCREDENTIALSA;
  TRasCredentialsA = tagRASCREDENTIALSA;
  TRasCredentialsW = tagRASCREDENTIALSW;
  TRasCredentials = TRasCredentialsA;
  RASCREDENTIALSA = tagRASCREDENTIALSA;
  {$EXTERNALSYM RASCREDENTIALSA}
  RASCREDENTIALSW = tagRASCREDENTIALSW;
  {$EXTERNALSYM RASCREDENTIALSW}
  RASCREDENTIALS = RASCREDENTIALSA;

// RASCREDENTIALS 'dwMask' values.
const
  RASCM_UserName       = $00000001;
  {$EXTERNALSYM RASCM_UserName}
  RASCM_Password       = $00000002;
  {$EXTERNALSYM RASCM_Password}
  RASCM_Domain         = $00000004;
  {$EXTERNALSYM RASCM_Domain}

// AutoDial address properties.

type
  PRasAutodialEntryA = ^TRasAutodialEntryA;
  PRasAutodialEntryW = ^TRasAutodialEntryW;
  PRasAutodialEntry = PRasAutodialEntryA;
  tagRASAUTODIALENTRYA = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDialingLocation: DWORD;
    szEntry: packed array[0..RAS_MaxEntryName] of AnsiChar;
  end;
  {$EXTERNALSYM tagRASAUTODIALENTRYA}
  tagRASAUTODIALENTRYW = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwDialingLocation: DWORD;
    szEntry: packed array[0..RAS_MaxEntryName] of WideChar;
  end;
  {$EXTERNALSYM tagRASAUTODIALENTRYW}
  tagRASAUTODIALENTRY = tagRASAUTODIALENTRYA;
  TRasAutodialEntryA = tagRASAUTODIALENTRYA;
  TRasAutodialEntryW = tagRASAUTODIALENTRYW;
  TRasAutodialEntry = TRasAutodialEntryA;
  RASAUTODIALENTRYA = tagRASAUTODIALENTRYA;
  {$EXTERNALSYM RASAUTODIALENTRYA}
  RASAUTODIALENTRYW = tagRASAUTODIALENTRYW;
  {$EXTERNALSYM RASAUTODIALENTRYW}
  RASAUTODIALENTRY = RASAUTODIALENTRYA;

// AutoDial control parameter values for Ras(Get,Set)AutodialParam.

const
  RASADP_DisableConnectionQuery           = 0;
  {$EXTERNALSYM RASADP_DisableConnectionQuery}
  RASADP_LoginSessionDisable              = 1;
  {$EXTERNALSYM RASADP_LoginSessionDisable}
  RASADP_SavedAddressesLimit              = 2;
  {$EXTERNALSYM RASADP_SavedAddressesLimit}
  RASADP_FailedConnectionTimeout          = 3;
  {$EXTERNALSYM RASADP_FailedConnectionTimeout}
  RASADP_ConnectionQueryTimeout           = 4;
  {$EXTERNALSYM RASADP_ConnectionQueryTimeout}

{$ENDIF}
// (WINVER >= 0x401)

{$IFDEF WINVER_0x500_OR_GREATER}
const
  RASEAPF_NonInteractive          = $00000002;
  {$EXTERNALSYM RASEAPF_NonInteractive}
  RASEAPF_Logon                   = $00000004;
  {$EXTERNALSYM RASEAPF_Logon}
  RASEAPF_Preview                 = $00000008;
  {$EXTERNALSYM RASEAPF_Preview}

type
  PRasEapUserIdentityA = ^TRasEapUserIdentityA;
  PRasEapUserIdentityW = ^TRasEapUserIdentityW;
  PRasEapUserIdentity = PRasEapUserIdentityA;
  tagRASEAPUSERIDENTITYA = record
    szUserName: array[0..UNLEN] of AnsiChar;
    dwSizeofEapInfo: DWORD;
    pbEapInfo: Byte;
  end;
  {$EXTERNALSYM tagRASEAPUSERIDENTITYA}
  tagRASEAPUSERIDENTITYW = record
    szUserName: array[0..UNLEN] of WideChar;
    dwSizeofEapInfo: DWORD;
    pbEapInfo: Byte;
  end;
  {$EXTERNALSYM tagRASEAPUSERIDENTITYW}
  tagRASEAPUSERIDENTITY = tagRASEAPUSERIDENTITYA;
  TRasEapUserIdentityA = tagRASEAPUSERIDENTITYA;
  TRasEapUserIdentityW = tagRASEAPUSERIDENTITYW;
  TRasEapUserIdentity = TRasEapUserIdentityA;
  RASEAPUSERIDENTITYA = tagRASEAPUSERIDENTITYA;
  {$EXTERNALSYM RASEAPUSERIDENTITYA}
  RASEAPUSERIDENTITYW = tagRASEAPUSERIDENTITYW;
  {$EXTERNALSYM RASEAPUSERIDENTITYW}
  RASEAPUSERIDENTITY = RASEAPUSERIDENTITYA;

{$ENDIF}

function RasDialA(lpRasDialExtensions: PRasDialExtensions; lpszPhonebook: PAnsiChar;
  lpRasDialParams: PRasDialParamsA; dwNotifierType: DWORD; lpvNotifier: Pointer;
  var lphRasConn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasDialA}
function RasDialW(lpRasDialExtensions: PRasDialExtensions; lpszPhonebook: PWideChar;
  lpRasDialParams: PRasDialParamsW; dwNotifierType: DWORD; lpvNotifier: Pointer;
  var lphRasConn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasDialW}
function RasDial(lpRasDialExtensions: PRasDialExtensions; lpszPhonebook: PChar;
  lpRasDialParams: PRasDialParams; dwNotifierType: DWORD; lpvNotifier: Pointer;
  var lphRasConn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasDial}

function RasEnumConnectionsA(lprasconn: PRasConnA; var lpcb: DWORD;
  var pcConnections: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumConnectionsA}
function RasEnumConnectionsW(lprasconn: PRasConnW; var lpcb: DWORD;
  var pcConnections: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumConnectionsW}
function RasEnumConnections(lprasconn: PRasConn; var lpcb: DWORD;
  var pcConnections: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumConnections}

function RasEnumEntriesA(reserved: PAnsiChar; lpszPhonebook: PAnsiChar;
  lprasentryname: PRasEntryNameA; var lpcb: DWORD;
  var lpcEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumEntriesA}
function RasEnumEntriesW(reserved: PWideChar; lpszPhonebook: PWideChar;
  lprasentryname: PRasEntryNameW; var lpcb: DWORD;
  var lpcEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumEntriesW}
function RasEnumEntries(reserved: PChar; lpszPhonebook: PChar;
  lprasentryname: PRasEntryName; var lpcb: DWORD;
  var lpcEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumEntries}

function RasGetConnectStatusA(hrasconn: THRasConn;
  var lprasconnstatus: TRasConnStatusA): DWORD; stdcall;
{$EXTERNALSYM RasGetConnectStatusA}
function RasGetConnectStatusW(hrasconn: THRasConn;
  var lprasconnstatus: TRasConnStatusW): DWORD; stdcall;
{$EXTERNALSYM RasGetConnectStatusW}
function RasGetConnectStatus(hrasconn: THRasConn;
  var lprasconnstatus: TRasConnStatus): DWORD; stdcall;
{$EXTERNALSYM RasGetConnectStatus}

function RasGetErrorStringA(uErrorValue: UINT; lpszErrorString: PAnsiChar;
  cBufSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetErrorStringA}
function RasGetErrorStringW(uErrorValue: UINT; lpszErrorString: PWideChar;
  cBufSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetErrorStringW}
function RasGetErrorString(uErrorValue: UINT; lpszErrorString: PChar;
  cBufSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetErrorString}

function RasHangUpA(hrasconn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasHangUpA}
function RasHangUpW(hrasconn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasHangUpW}
function RasHangUp(hrasconn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasHangUp}

function RasGetProjectionInfoA(hrasconn: THRasConn; rasprojection: TRasProjection;
  lpprojection: Pointer; var lpcb: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetProjectionInfoA}
function RasGetProjectionInfoW(hrasconn: THRasConn; rasprojection: TRasProjection;
  lpprojection: Pointer; var lpcb: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetProjectionInfoW}
function RasGetProjectionInfo(hrasconn: THRasConn; rasprojection: TRasProjection;
  lpprojection: Pointer; var lpcb: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetProjectionInfo}

function RasCreatePhonebookEntryA(hwnd: HWND; lpszPhonebook: PAnsiChar): DWORD; stdcall;
{$EXTERNALSYM RasCreatePhonebookEntryA}
function RasCreatePhonebookEntryW(hwnd: HWND; lpszPhonebook: PWideChar): DWORD; stdcall;
{$EXTERNALSYM RasCreatePhonebookEntryW}
function RasCreatePhonebookEntry(hwnd: HWND; lpszPhonebook: PChar): DWORD; stdcall;
{$EXTERNALSYM RasCreatePhonebookEntry}

function RasEditPhonebookEntryA(hwnd: HWND; lpszPhonebook: PAnsiChar;
  lpszEntryName: PAnsiChar): DWORD; stdcall;
{$EXTERNALSYM RasEditPhonebookEntryA}
function RasEditPhonebookEntryW(hwnd: HWND; lpszPhonebook: PWideChar;
  lpszEntryName: PWideChar): DWORD; stdcall;
{$EXTERNALSYM RasEditPhonebookEntryW}
function RasEditPhonebookEntry(hwnd: HWND; lpszPhonebook: PChar;
  lpszEntryName: PChar): DWORD; stdcall;
{$EXTERNALSYM RasEditPhonebookEntry}

function RasSetEntryDialParamsA(lpszPhonebook: PAnsiChar;
  lprasdialparams: PRasDialParamsA; fRemovePassword: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetEntryDialParamsA}
function RasSetEntryDialParamsW(lpszPhonebook: PWideChar;
  lprasdialparams: PRasDialParamsW; fRemovePassword: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetEntryDialParamsW}
function RasSetEntryDialParams(lpszPhonebook: PChar;
  lprasdialparams: PRasDialParams; fRemovePassword: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetEntryDialParams}

function RasGetEntryDialParamsA(lpszPhonebook: PAnsiChar;
  var lprasdialparams: TRasDialParamsA; var lpfPassword: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasGetEntryDialParamsA}
function RasGetEntryDialParamsW(lpszPhonebook: PWideChar;
  var lprasdialparams: TRasDialParamsW; var lpfPassword: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasGetEntryDialParamsW}
function RasGetEntryDialParams(lpszPhonebook: PChar;
  var lprasdialparams: TRasDialParams; var lpfPassword: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasGetEntryDialParams}

function RasEnumDevicesA(lpRasDevInfo: PRasDevInfoA; var lpcb: DWORD;
  var lpcDevices: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumDevicesA}
function RasEnumDevicesW(lpRasDevInfo: PRasDevInfoW; var lpcb: DWORD;
  var lpcDevices: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumDevicesW}
function RasEnumDevices(lpRasDevInfo: PRasDevInfo; var lpcb: DWORD;
  var lpcDevices: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumDevices}

function RasGetCountryInfoA(var lpRasCtryInfo: TRasCtryInfoA;
  var lpdwSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetCountryInfoA}
function RasGetCountryInfoW(var lpRasCtryInfo: TRasCtryInfoW;
  var lpdwSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetCountryInfoW}
function RasGetCountryInfo(var lpRasCtryInfo: TRasCtryInfo;
  var lpdwSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetCountryInfo}

function RasGetEntryPropertiesA(lpszPhonebook: PAnsiChar; lpszEntry: PAnsiChar;
  lpRasEntry: PRasEntryA; var lpdwEntryInfoSize: DWORD;
  lpbDeviceInfo: Pointer; lpdwDeviceInfoSize: PDWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetEntryPropertiesA}
function RasGetEntryPropertiesW(lpszPhonebook: PWideChar; lpszEntry: PWideChar;
  lpRasEntry: PRasEntryW; var lpdwEntryInfoSize: DWORD;
  lpbDeviceInfo: Pointer; lpdwDeviceInfoSize: PDWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetEntryPropertiesW}
function RasGetEntryProperties(lpszPhonebook: PChar; lpszEntry: PChar;
  lpRasEntry: PRasEntry; var lpdwEntryInfoSize: DWORD;
  lpbDeviceInfo: Pointer; lpdwDeviceInfoSize: PDWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetEntryProperties}

function RasSetEntryPropertiesA(lpszPhonebook: PAnsiChar; lpszEntry: PAnsiChar;
  lpRasEntry: PRasEntryA; dwEntryInfoSize: DWORD;
  lpbDeviceInfo: Pointer; lpdwDeviceInfoSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetEntryPropertiesA}
function RasSetEntryPropertiesW(lpszPhonebook: PWideChar; lpszEntry: PWideChar;
  lpRasEntry: PRasEntryW; dwEntryInfoSize: DWORD;
  lpbDeviceInfo: Pointer; lpdwDeviceInfoSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetEntryPropertiesW}
function RasSetEntryProperties(lpszPhonebook: PChar; lpszEntry: PChar;
  lpRasEntry: PRasEntry; dwEntryInfoSize: DWORD;
  lpbDeviceInfo: Pointer; lpdwDeviceInfoSize: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetEntryProperties}

function RasRenameEntryA(lpszPhonebook: PAnsiChar; lpszOldEntry: PAnsiChar;
  lpszNewEntry: PAnsiChar): DWORD; stdcall;
{$EXTERNALSYM RasRenameEntryA}
function RasRenameEntryW(lpszPhonebook: PWideChar; lpszOldEntry: PWideChar;
  lpszNewEntry: PWideChar): DWORD; stdcall;
{$EXTERNALSYM RasRenameEntryW}
function RasRenameEntry(lpszPhonebook: PChar; lpszOldEntry: PChar;
  lpszNewEntry: PChar): DWORD; stdcall;
{$EXTERNALSYM RasRenameEntry}

function RasDeleteEntryA(lpszPhonebook, lpszEntry: PAnsiChar): DWORD; stdcall;
{$EXTERNALSYM RasDeleteEntryA}
function RasDeleteEntryW(lpszPhonebook, lpszEntry: PWideChar): DWORD; stdcall;
{$EXTERNALSYM RasDeleteEntryW}
function RasDeleteEntry(lpszPhonebook, lpszEntry: PChar): DWORD; stdcall;
{$EXTERNALSYM RasDeleteEntry}

function RasValidateEntryNameA(lpszPhonebook, lpszEntry: PAnsiChar): DWORD; stdcall;
{$EXTERNALSYM RasValidateEntryNameA}
function RasValidateEntryNameW(lpszPhonebook, lpszEntry: PWideChar): DWORD; stdcall;
{$EXTERNALSYM RasValidateEntryNameW}
function RasValidateEntryName(lpszPhonebook, lpszEntry: PChar): DWORD; stdcall;
{$EXTERNALSYM RasValidateEntryName}

{$IFDEF WINVER_0x401_OR_GREATER}

function RasGetSubEntryHandleA(hrasconn: THRasConn; dwSubEntry: DWORD;
  var lphrasconn: TRasConnA): DWORD; stdcall;
{$EXTERNALSYM RasGetSubEntryHandleA}
function RasGetSubEntryHandleW(hrasconn: THRasConn; dwSubEntry: DWORD;
  var lphrasconn: TRasConnW): DWORD; stdcall;
{$EXTERNALSYM RasGetSubEntryHandleW}
function RasGetSubEntryHandle(hrasconn: THRasConn; dwSubEntry: DWORD;
  var lphrasconn: TRasConn): DWORD; stdcall;
{$EXTERNALSYM RasGetSubEntryHandle}

function RasGetCredentialsA(lpszPhonebook, lpszEntry: PAnsiChar;
  var lpCredentials: TRasCredentialsA): DWORD; stdcall;
{$EXTERNALSYM RasGetCredentialsA}
function RasGetCredentialsW(lpszPhonebook, lpszEntry: PWideChar;
  var lpCredentials: TRasCredentialsW): DWORD; stdcall;
{$EXTERNALSYM RasGetCredentialsW}
function RasGetCredentials(lpszPhonebook, lpszEntry: PChar;
  var lpCredentials: TRasCredentials): DWORD; stdcall;
{$EXTERNALSYM RasGetCredentials}

function RasSetCredentialsA(lpszPhonebook, lpszEntry: PAnsiChar;
  lpCredentials: PRasCredentialsA; fClearCredentials: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetCredentialsA}
function RasSetCredentialsW(lpszPhonebook, lpszEntry: PWideChar;
  lpCredentials: PRasCredentialsW; fClearCredentials: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetCredentialsW}
function RasSetCredentials(lpszPhonebook, lpszEntry: PChar;
  lpCredentials: PRasCredentials; fClearCredentials: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetCredentials}

function RasConnectionNotificationA(hrasconn: THRasConn; hEvent: THandle;
  dwFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasConnectionNotificationA}
function RasConnectionNotificationW(hrasconn: THRasConn; hEvent: THandle;
  dwFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasConnectionNotificationW}
function RasConnectionNotification(hrasconn: THRasConn; hEvent: THandle;
  dwFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasConnectionNotification}

function RasGetSubEntryPropertiesA(lpszPhonebook, lpszEntry: PAnsiChar;
  dwSubEntry: DWORD; var lpRasSubEntry: TRasSubEntryA; var lpdwcb: DWORD;
  lpbDeviceConfig: Pointer; var lpcbDeviceConfig: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetSubEntryPropertiesA}
function RasGetSubEntryPropertiesW(lpszPhonebook, lpszEntry: PWideChar;
  dwSubEntry: DWORD; var lpRasSubEntry: TRasSubEntryW; var lpdwcb: DWORD;
  lpbDeviceConfig: Pointer; var lpcbDeviceConfig: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetSubEntryPropertiesW}
function RasGetSubEntryProperties(lpszPhonebook, lpszEntry: PChar;
  dwSubEntry: DWORD; var lpRasSubEntry: TRasSubEntry; var lpdwcb: DWORD;
  lpbDeviceConfig: Pointer; var lpcbDeviceConfig: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetSubEntryProperties}

function RasSetSubEntryPropertiesA(lpszPhonebook, lpszEntry: PAnsiChar;
  dwSubEntry: DWORD; lpRasSubEntry: PRasSubEntryA; dwcbRasSubEntry: DWORD;
  lpbDeviceConfig: Pointer; lpcbDeviceConfig: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetSubEntryPropertiesA}
function RasSetSubEntryPropertiesW(lpszPhonebook, lpszEntry: PWideChar;
  dwSubEntry: DWORD; lpRasSubEntry: PRasSubEntryW; dwcbRasSubEntry: DWORD;
  lpbDeviceConfig: Pointer; lpcbDeviceConfig: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetSubEntryPropertiesW}
function RasSetSubEntryProperties(lpszPhonebook, lpszEntry: PChar;
  dwSubEntry: DWORD; lpRasSubEntry: PRasSubEntry; dwcbRasSubEntry: DWORD;
  lpbDeviceConfig: Pointer; lpcbDeviceConfig: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetSubEntryProperties}

function RasGetAutodialAddressA(lpszAddress: PAnsiChar; lpdwReserved: PDWORD;
  lpAutoDialEntries: PRasAutodialEntryA; var lpdwcbAutoDialEntries: DWORD;
  var lpdwcAutoDialEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialAddressA}
function RasGetAutodialAddressW(lpszAddress: PWideChar; lpdwReserved: PDWORD;
  lpAutoDialEntries: PRasAutodialEntryW; var lpdwcbAutoDialEntries: DWORD;
  var lpdwcAutoDialEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialAddressW}
function RasGetAutodialAddress(lpszAddress: PChar; lpdwReserved: PDWORD;
  lpAutoDialEntries: PRasAutodialEntry; var lpdwcbAutoDialEntries: DWORD;
  var lpdwcAutoDialEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialAddress}

function RasSetAutodialAddressA(lpszAddress: PAnsiChar; dwReserved: DWORD;
  lpAutoDialEntries: PRasAutodialEntryA; dwcbAutoDialEntries: DWORD;
  dwcAutoDialEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialAddressA}
function RasSetAutodialAddressW(lpszAddress: PWideChar; dwReserved: DWORD;
  lpAutoDialEntries: PRasAutodialEntryW; dwcbAutoDialEntries: DWORD;
  dwcAutoDialEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialAddressW}
function RasSetAutodialAddress(lpszAddress: PChar; dwReserved: DWORD;
  lpAutoDialEntries: PRasAutodialEntry; dwcbAutoDialEntries: DWORD;
  dwcAutoDialEntries: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialAddress}

function RasEnumAutodialAddressesA(lppAddresses: Pointer;
  var lpdwcbAddresses: DWORD; var lpdwcAddresses: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumAutodialAddressesA}
function RasEnumAutodialAddressesW(lppAddresses: Pointer;
  var lpdwcbAddresses: DWORD; var lpdwcAddresses: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumAutodialAddressesW}
function RasEnumAutodialAddresses(lppAddresses: Pointer;
  var lpdwcbAddresses: DWORD; var lpdwcAddresses: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasEnumAutodialAddresses}

function RasGetAutodialEnableA(dwDialingLocation: DWORD;
  var lpfEnabled: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialEnableA}
function RasGetAutodialEnableW(dwDialingLocation: DWORD;
  var lpfEnabled: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialEnableW}
function RasGetAutodialEnable(dwDialingLocation: DWORD;
  var lpfEnabled: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialEnable}

function RasSetAutodialEnableA(dwDialingLocation: DWORD;
  fEnabled: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialEnableA}
function RasSetAutodialEnableW(dwDialingLocation: DWORD;
  fEnabled: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialEnableW}
function RasSetAutodialEnable(dwDialingLocation: DWORD;
  fEnabled: BOOL): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialEnable}

function RasGetAutodialParamA(dwKey: DWORD; lpvValue: Pointer;
  var lpdwcbValue: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialParamA}
function RasGetAutodialParamW(dwKey: DWORD; lpvValue: Pointer;
  var lpdwcbValue: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialParamW}
function RasGetAutodialParam(dwKey: DWORD; lpvValue: Pointer;
  var lpdwcbValue: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetAutodialParam}

function RasSetAutodialParamA(dwKey: DWORD; lpvValue: Pointer;
  dwcbValue: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialParamA}
function RasSetAutodialParamW(dwKey: DWORD; lpvValue: Pointer;
  dwcbValue: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialParamW}
function RasSetAutodialParam(dwKey: DWORD; lpvValue: Pointer;
  dwcbValue: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetAutodialParam}

{$ENDIF}

{$IFDEF WINVER_0x500_OR_GREATER}
type
  PRasStats = ^TRasStats;
  _RAS_STATS = record
    dwSize: DWORD;
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
    dwCompressionRatioIn: DWORD;
    dwCompressionRatioOut: DWORD;
    dwBps: DWORD;
    dwConnectDuration: DWORD;
  end;
  {$EXTERNALSYM _RAS_STATS}
  TRasStats = _RAS_STATS;
  RAS_STATS = _RAS_STATS;
  {$EXTERNALSYM RAS_STATS}

  RasCustomHangUpFnA = function(hRasConn: THRasConn): DWORD; stdcall;
  {$EXTERNALSYM RasCustomHangUpFnA}
  RasCustomHangUpFnW = function(hRasConn: THRasConn): DWORD; stdcall;
  {$EXTERNALSYM RasCustomHangUpFnW}
  RasCustomHangUpFn = RasCustomHangUpFnA;

  RasCustomDialFnA = function (hInstDll: THandle;
    lpRasDialExtensions: PRasDialExtensions; lpszPhonebook: PAnsiChar;
    lpRasDialParams: PRasDialParams; dwNotifierType: DWORD; lpvNotifier: Pointer;
    var lphRasConn: THRasConn; dwFlags: DWORD): DWORD; stdcall;
  {$EXTERNALSYM RasCustomDialFnA}
  RasCustomDialFnW = function (hInstDll: THandle;
    lpRasDialExtensions: PRasDialExtensions; lpszPhonebook: PWideChar;
    lpRasDialParams: PRasDialParams; dwNotifierType: DWORD; lpvNotifier: Pointer;
    var lphRasConn: THRasConn; dwFlags: DWORD): DWORD; stdcall;
  {$EXTERNALSYM RasCustomDialFnW}
  RasCustomDialFn = RasCustomDialFnA;

  RasCustomDeleteEntryNotifyFnA = function (lpszPhonebook, lpszEntry: PAnsiChar;
    dwFlags: DWORD): DWORD; stdcall;
  {$EXTERNALSYM RasCustomDeleteEntryNotifyFnA}
  RasCustomDeleteEntryNotifyFnW = function (lpszPhonebook, lpszEntry: PWideChar;
    dwFlags: DWORD): DWORD; stdcall;
  {$EXTERNALSYM RasCustomDeleteEntryNotifyFnW}
  RasCustomDeleteEntryNotifyFn = RasCustomDeleteEntryNotifyFnA;

const
  RCD_SingleUser  = 0;
  {$EXTERNALSYM RCD_SingleUser}
  RCD_AllUsers    = $00000001;
  {$EXTERNALSYM RCD_AllUsers}
  RCD_Eap         = $00000002;
  {$EXTERNALSYM RCD_Eap}

function RasInvokeEapUI(hRasConn: THRasConn; dwSubEntry: DWORD;
  lpExtensions: PRasDialExtensions; hwnd: HWND): DWORD; stdcall;
{$EXTERNALSYM RasInvokeEapUI}

function RasGetLinkStatistics(hRasConn: THRasConn; dwSubEntry: DWORD;
  var lpStatistics: TRasStats): DWORD; stdcall;
{$EXTERNALSYM RasGetLinkStatistics}

function RasGetConnectionStatistics(hRasConn: THRasConn;
  var lpStatistics: TRasStats): DWORD; stdcall;
{$EXTERNALSYM RasGetConnectionStatistics}

function RasClearLinkStatistics(hRasConn: THRasConn;
  dwSubEntry: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasClearLinkStatistics}

function RasClearConnectionStatistics(hRasConn: THRasConn): DWORD; stdcall;
{$EXTERNALSYM RasClearConnectionStatistics}

function RasGetEapUserDataA(hToken: THandle; pszPhonebook, pszEntry: PAnsiChar;
  pbEapData: Pointer; var pdwSizeofEapData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetEapUserDataA}
function RasGetEapUserDataW(hToken: THandle; pszPhonebook, pszEntry: PAnsiChar;
  pbEapData: Pointer; var pdwSizeofEapData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetEapUserDataW}
function RasGetEapUserData(hToken: THandle; pszPhonebook, pszEntry: PAnsiChar;
  pbEapData: Pointer; var pdwSizeofEapData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetEapUserData}

function RasSetEapUserDataA(hToken: THandle; pszPhonebook, pszEntry: PAnsiChar;
  pbEapData: Pointer; pdwSizeofEapData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetEapUserDataA}
function RasSetEapUserDataW(hToken: THandle; pszPhonebook, pszEntry: PAnsiChar;
  pbEapData: Pointer; pdwSizeofEapData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetEapUserDataW}
function RasSetEapUserData(hToken: THandle; pszPhonebook, pszEntry: PAnsiChar;
  pbEapData: Pointer; pdwSizeofEapData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetEapUserData}

function RasGetCustomAuthDataA(pszPhonebook, pszEntry: PAnsiChar;
  pbCustomAuthData: Pointer; var pdwSizeofCustomAuthData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetCustomAuthDataA}
function RasGetCustomAuthDataW(pszPhonebook, pszEntry: PAnsiChar;
  pbCustomAuthData: Pointer; var pdwSizeofCustomAuthData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetCustomAuthDataW}
function RasGetCustomAuthData(pszPhonebook, pszEntry: PAnsiChar;
  pbCustomAuthData: Pointer; var pdwSizeofCustomAuthData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasGetCustomAuthData}

function RasSetCustomAuthDataA(pszPhonebook, pszEntry: PAnsiChar;
  pbCustomAuthData: Pointer; pdwSizeofCustomAuthData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetCustomAuthDataA}
function RasSetCustomAuthDataW(pszPhonebook, pszEntry: PAnsiChar;
  pbCustomAuthData: Pointer; pdwSizeofCustomAuthData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetCustomAuthDataW}
function RasSetCustomAuthData(pszPhonebook, pszEntry: PAnsiChar;
  pbCustomAuthData: Pointer; pdwSizeofCustomAuthData: DWORD): DWORD; stdcall;
{$EXTERNALSYM RasSetCustomAuthData}

function RasGetEapUserIdentityA(pszPhonebook, pszEntry: PAnsiChar; dwFlags: DWORD;
  hwnd: HWND; ppRasEapUserIdentity: PRasEapUserIdentityA): DWORD; stdcall;
{$EXTERNALSYM RasGetEapUserIdentityA}
function RasGetEapUserIdentityW(pszPhonebook, pszEntry: PAnsiChar; dwFlags: DWORD;
  hwnd: HWND; ppRasEapUserIdentity: PRasEapUserIdentityW): DWORD; stdcall;
{$EXTERNALSYM RasGetEapUserIdentityW}
function RasGetEapUserIdentity(pszPhonebook, pszEntry: PAnsiChar; dwFlags: DWORD;
  hwnd: HWND; ppRasEapUserIdentity: PRasEapUserIdentity): DWORD; stdcall;
{$EXTERNALSYM RasGetEapUserIdentity}

function RasFreeEapUserIdentityA(pRasEapUserIdentity: PRasEapUserIdentityA): DWORD; stdcall;
{$EXTERNALSYM RasFreeEapUserIdentityA}
function RasFreeEapUserIdentityW(pRasEapUserIdentity: PRasEapUserIdentityW): DWORD; stdcall;
{$EXTERNALSYM RasFreeEapUserIdentityW}
function RasFreeEapUserIdentity(pRasEapUserIdentity: PRasEapUserIdentity): DWORD; stdcall;
{$EXTERNALSYM RasFreeEapUserIdentity}

{$ENDIF}

implementation

const
  raslib = 'rasapi32.dll';

function RasDialA; external raslib name 'RasDialA';
function RasDialW; external raslib name 'RasDialW';
function RasDial; external raslib name 'RasDialA';
function RasEnumConnectionsA; external raslib name 'RasEnumConnectionsA';
function RasEnumConnectionsW; external raslib name 'RasEnumConnectionsW';
function RasEnumConnections; external raslib name 'RasEnumConnectionsA';
function RasEnumEntriesA; external raslib name 'RasEnumEntriesA';
function RasEnumEntriesW; external raslib name 'RasEnumEntriesW';
function RasEnumEntries; external raslib name 'RasEnumEntriesA';
function RasGetConnectStatusA; external raslib name 'RasGetConnectStatusA';
function RasGetConnectStatusW; external raslib name 'RasGetConnectStatusW';
function RasGetConnectStatus; external raslib name 'RasGetConnectStatusA';
function RasGetErrorStringA; external raslib name 'RasGetErrorStringA';
function RasGetErrorStringW; external raslib name 'RasGetErrorStringW';
function RasGetErrorString; external raslib name 'RasGetErrorStringA';
function RasHangUpA; external raslib name 'RasHangUpA';
function RasHangUpW; external raslib name 'RasHangUpW';
function RasHangUp; external raslib name 'RasHangUpA';
function RasGetProjectionInfoA; external raslib name 'RasGetProjectionInfoA';
function RasGetProjectionInfoW; external raslib name 'RasGetProjectionInfoW';
function RasGetProjectionInfo; external raslib name 'RasGetProjectionInfoA';
function RasCreatePhonebookEntryA; external raslib name 'RasCreatePhonebookEntryA';
function RasCreatePhonebookEntryW; external raslib name 'RasCreatePhonebookEntryW';
function RasCreatePhonebookEntry; external raslib name 'RasCreatePhonebookEntryA';
function RasEditPhonebookEntryA; external raslib name 'RasEditPhonebookEntryA';
function RasEditPhonebookEntryW; external raslib name 'RasEditPhonebookEntryW';
function RasEditPhonebookEntry; external raslib name 'RasEditPhonebookEntryA';
function RasSetEntryDialParamsA; external raslib name 'RasSetEntryDialParamsA';
function RasSetEntryDialParamsW; external raslib name 'RasSetEntryDialParamsW';
function RasSetEntryDialParams; external raslib name 'RasSetEntryDialParamsA';
function RasGetEntryDialParamsA; external raslib name 'RasGetEntryDialParamsA';
function RasGetEntryDialParamsW; external raslib name 'RasGetEntryDialParamsW';
function RasGetEntryDialParams; external raslib name 'RasGetEntryDialParamsA';
function RasEnumDevicesA; external raslib name 'RasEnumDevicesA';
function RasEnumDevicesW; external raslib name 'RasEnumDevicesW';
function RasEnumDevices; external raslib name 'RasEnumDevicesA';
function RasGetCountryInfoA; external raslib name 'RasGetCountryInfoA';
function RasGetCountryInfoW; external raslib name 'RasGetCountryInfoW';
function RasGetCountryInfo; external raslib name 'RasGetCountryInfoA';
function RasGetEntryPropertiesA; external raslib name 'RasGetEntryPropertiesA';
function RasGetEntryPropertiesW; external raslib name 'RasGetEntryPropertiesW';
function RasGetEntryProperties; external raslib name 'RasGetEntryPropertiesA';
function RasSetEntryPropertiesA; external raslib name 'RasSetEntryPropertiesA';
function RasSetEntryPropertiesW; external raslib name 'RasSetEntryPropertiesW';
function RasSetEntryProperties; external raslib name 'RasSetEntryPropertiesA';
function RasRenameEntryA; external raslib name 'RasRenameEntryA';
function RasRenameEntryW; external raslib name 'RasRenameEntryW';
function RasRenameEntry; external raslib name 'RasRenameEntryA';
function RasDeleteEntryA; external raslib name 'RasDeleteEntryA';
function RasDeleteEntryW; external raslib name 'RasDeleteEntryW';
function RasDeleteEntry; external raslib name 'RasDeleteEntryA';
function RasValidateEntryNameA; external raslib name 'RasValidateEntryNameA';
function RasValidateEntryNameW; external raslib name 'RasValidateEntryNameW';
function RasValidateEntryName; external raslib name 'RasValidateEntryNameA';

{$IFDEF WINVER_0x401_OR_GREATER}
function RasGetSubEntryHandleA; external raslib name 'RasGetSubEntryHandleA';
function RasGetSubEntryHandleW; external raslib name 'RasGetSubEntryHandleW';
function RasGetSubEntryHandle; external raslib name 'RasGetSubEntryHandleA';
function RasConnectionNotificationA; external raslib name 'RasConnectionNotificationA';
function RasConnectionNotificationW; external raslib name 'RasConnectionNotificationW';
function RasConnectionNotification; external raslib name 'RasConnectionNotificationA';
function RasGetSubEntryPropertiesA; external raslib name 'RasGetSubEntryPropertiesA';
function RasGetSubEntryPropertiesW; external raslib name 'RasGetSubEntryPropertiesW';
function RasGetSubEntryProperties; external raslib name 'RasGetSubEntryPropertiesA';
function RasSetSubEntryPropertiesA; external raslib name 'RasSetSubEntryPropertiesA';
function RasSetSubEntryPropertiesW; external raslib name 'RasSetSubEntryPropertiesW';
function RasSetSubEntryProperties; external raslib name 'RasSetSubEntryPropertiesA';
function RasGetCredentialsA; external raslib name 'RasGetCredentialsA';
function RasGetCredentialsW; external raslib name 'RasGetCredentialsW';
function RasGetCredentials; external raslib name 'RasGetCredentialsA';
function RasSetCredentialsA; external raslib name 'RasSetCredentialsA';
function RasSetCredentialsW; external raslib name 'RasSetCredentialsW';
function RasSetCredentials; external raslib name 'RasSetCredentialsA';
function RasGetAutodialAddressA; external raslib name 'RasGetAutodialAddressA';
function RasGetAutodialAddressW; external raslib name 'RasGetAutodialAddressW';
function RasGetAutodialAddress; external raslib name 'RasGetAutodialAddressA';
function RasSetAutodialAddressA; external raslib name 'RasSetAutodialAddressA';
function RasSetAutodialAddressW; external raslib name 'RasSetAutodialAddressW';
function RasSetAutodialAddress; external raslib name 'RasSetAutodialAddressA';
function RasEnumAutodialAddressesA; external raslib name 'RasEnumAutodialAddressesA';
function RasEnumAutodialAddressesW; external raslib name 'RasEnumAutodialAddressesW';
function RasEnumAutodialAddresses; external raslib name 'RasEnumAutodialAddressesA';
function RasGetAutodialEnableA; external raslib name 'RasGetAutodialEnableA';
function RasGetAutodialEnableW; external raslib name 'RasGetAutodialEnableW';
function RasGetAutodialEnable; external raslib name 'RasGetAutodialEnableA';
function RasSetAutodialEnableA; external raslib name 'RasSetAutodialEnableA';
function RasSetAutodialEnableW; external raslib name 'RasSetAutodialEnableW';
function RasSetAutodialEnable; external raslib name 'RasSetAutodialEnableA';
function RasGetAutodialParamA; external raslib name 'RasGetAutodialParamA';
function RasGetAutodialParamW; external raslib name 'RasGetAutodialParamW';
function RasGetAutodialParam; external raslib name 'RasGetAutodialParamA';
function RasSetAutodialParamA; external raslib name 'RasSetAutodialParamA';
function RasSetAutodialParamW; external raslib name 'RasSetAutodialParamW';
function RasSetAutodialParam; external raslib name 'RasSetAutodialParamA';
{$ENDIF}

{$IFDEF WINVER_0x500_OR_GREATER}

function RasInvokeEapUI; external raslib name 'RasInvokeEapUI';
function RasGetLinkStatistics; external raslib name 'RasGetLinkStatistics';
function RasGetConnectionStatistics; external raslib name 'RasGetConnectionStatistics';
function RasClearLinkStatistics; external raslib name 'RasClearLinkStatistics';
function RasClearConnectionStatistics; external raslib name 'RasClearConnectionStatistics';
function RasGetEapUserDataA; external raslib name 'RasGetEapUserDataA';
function RasGetEapUserDataW; external raslib name 'RasGetEapUserDataW';
function RasGetEapUserData; external raslib name 'RasGetEapUserDataA';
function RasSetEapUserDataA; external raslib name 'RasSetEapUserDataA';
function RasSetEapUserDataW; external raslib name 'RasSetEapUserDataW';
function RasSetEapUserData; external raslib name 'RasSetEapUserDataA';
function RasGetCustomAuthDataA; external raslib name 'RasGetCustomAuthDataA';
function RasGetCustomAuthDataW; external raslib name 'RasGetCustomAuthDataW';
function RasGetCustomAuthData; external raslib name 'RasGetCustomAuthDataA';
function RasSetCustomAuthDataA; external raslib name 'RasSetCustomAuthDataA';
function RasSetCustomAuthDataW; external raslib name 'RasSetCustomAuthDataW';
function RasSetCustomAuthData; external raslib name 'RasSetCustomAuthDataA';
function RasGetEapUserIdentityA; external raslib name 'RasGetEapUserIdentityA';
function RasGetEapUserIdentityW; external raslib name 'RasGetEapUserIdentityW';
function RasGetEapUserIdentity; external raslib name 'RasGetEapUserIdentityA';
function RasFreeEapUserIdentityA; external raslib name 'RasFreeEapUserIdentityA';
function RasFreeEapUserIdentityW; external raslib name 'RasFreeEapUserIdentityW';
function RasFreeEapUserIdentity; external raslib name 'RasFreeEapUserIdentityA';

{$ENDIF}

end.
