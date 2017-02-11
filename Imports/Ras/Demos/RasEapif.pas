{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS functions interface unit                                     }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: raseapif.h, released 24 Apr 1998.          }
{ The original Pascal code is: RasEapif.pas, released 13 Jan 2000. }
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

unit RasEapif;

{$I RAS.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows, LmCons;

(*$HPPEMIT '#include <raseapif.h>'*)

{$IFDEF WINVER_0x500_OR_GREATER}

// Defines used for installtion of EAP DLL
//
// Custom EAP DLL (ex. Name=Sample.dll, Type=(decimal 40) regsitry installation)
//
// HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Rasman\PPP\EAP\40)
//      Path                (REG_EXPAND_SZ) %SystemRoot%\system32\sample.dll
//      ConfigUIPath        (REG_EXPAND_SZ) %SystemRoot%\system32\sample.dll
//      InteractiveUIPath   (REG_EXPAND_SZ) %SystemRoot%\system32\sample.dll
//      IdentityPath        (REG_EXPAND_SZ) %SystemRoot%\system32\sample.dll
//      FriendlyName        (REG_SZ) Sample EAP Protocol
//      RequireConfigUI     (REG_DWORD)     1
//      ConfigCLSID         (REG_SZ)        {0000031A-0000-0000-C000-000000000046}
//      StandaloneSupported (REG_DWORD)     1

const
  RAS_EAP_REGISTRY_LOCATION = 'System\CurrentControlSet\Services\Rasman\PPP\EAP';
  {$EXTERNALSYM RAS_EAP_REGISTRY_LOCATION}

  RAS_EAP_VALUENAME_PATH                  = 'Path';
  {$EXTERNALSYM RAS_EAP_VALUENAME_PATH}
  RAS_EAP_VALUENAME_CONFIGUI              = 'ConfigUIPath';
  {$EXTERNALSYM RAS_EAP_VALUENAME_CONFIGUI}
  RAS_EAP_VALUENAME_INTERACTIVEUI         = 'InteractiveUIPath';
  {$EXTERNALSYM RAS_EAP_VALUENAME_INTERACTIVEUI}
  RAS_EAP_VALUENAME_IDENTITY              = 'Identity';
  {$EXTERNALSYM RAS_EAP_VALUENAME_IDENTITY}
  RAS_EAP_VALUENAME_FRIENDLY_NAME         = 'FriendlyName';
  {$EXTERNALSYM RAS_EAP_VALUENAME_FRIENDLY_NAME}
  RAS_EAP_VALUENAME_DEFAULT_DATA          = 'ConfigData';
  {$EXTERNALSYM RAS_EAP_VALUENAME_DEFAULT_DATA}
  RAS_EAP_VALUENAME_REQUIRE_CONFIGUI      = 'RequireConfigUI';
  {$EXTERNALSYM RAS_EAP_VALUENAME_REQUIRE_CONFIGUI}
  RAS_EAP_VALUENAME_ENCRYPTION            = 'MPPEEncryptionSupported';
  {$EXTERNALSYM RAS_EAP_VALUENAME_ENCRYPTION}
  RAS_EAP_VALUENAME_INVOKE_NAMEDLG        = 'InvokeUsernameDialog';
  {$EXTERNALSYM RAS_EAP_VALUENAME_INVOKE_NAMEDLG}
  RAS_EAP_VALUENAME_INVOKE_PWDDLG         = 'InvokePasswordDialog';
  {$EXTERNALSYM RAS_EAP_VALUENAME_INVOKE_PWDDLG}
  RAS_EAP_VALUENAME_CONFIG_CLSID          = 'ConfigCLSID';
  {$EXTERNALSYM RAS_EAP_VALUENAME_CONFIG_CLSID}
  RAS_EAP_VALUENAME_STANDALONE_SUPPORTED  = 'StandaloneSupported';
  {$EXTERNALSYM RAS_EAP_VALUENAME_STANDALONE_SUPPORTED}

type
  PRasAuthAttributeType = ^TRasAuthAttributeType;
  RAS_AUTH_ATTRIBUTE_TYPE = DWORD;
  {$EXTERNALSYM RAS_AUTH_ATTRIBUTE_TYPE}
  TRasAuthAttributeType = RAS_AUTH_ATTRIBUTE_TYPE;
  _RAS_AUTH_ATTRIBUTE_TYPE_ = RAS_AUTH_ATTRIBUTE_TYPE;

const
  raatMinimum = 0;                // Undefined
  raatUserName = 1;               // Value field is a Pointer
  raatUserPassword = 2;           // Value field is a Pointer
  raatMD5CHAPPassword = 3;        // Value field is a Pointer
  raatNASIPAddress = 4;           // Value field is a 32 bit integral value
  raatNASPort = 5;                // Value field is a 32 bit integral value
  raatServiceType = 6;            // Value field is a 32 bit integral value
  raatFramedProtocol = 7;         // Value field is a 32 bit integral value
  raatFramedIPAddress = 8;        // Value field is a 32 bit integral value
  raatFramedIPNetmask = 9;        // Value field is a 32 bit integral value
  raatFramedRouting = 10;         // Value field is a 32 bit integral value
  raatFilterId = 11;              // Value field is a Pointer
  raatFramedMTU = 12;             // Value field is a 32 bit integral value
  raatFramedCompression = 13;     // Value field is a 32 bit integral value
  raatLoginIPHost = 14;           // Value field is a 32 bit integral value
  raatLoginService = 15;          // Value field is a 32 bit integral value
  raatLoginTCPPort = 16;          // Value field is a 32 bit integral value
  raatUnassigned17 = 17;          // Undefined
  raatReplyMessage = 18;          // Value field is a Pointer
  raatCallbackNumber = 19;        // Value field is a Pointer
  raatCallbackId = 20;            // Value field is a Pointer
  raatUnassigned21 = 21;          // Undefined
  raatFramedRoute = 22;           // Value field is a Pointer
  raatFramedIPXNetwork = 23;      // Value field is a 32 bit integral value
  raatState = 24;                 // Value field is a Pointer
  raatClass = 25;                 // Value field is a Pointer
  raatVendorSpecific = 26;        // Value field is a Pointer
  raatSessionTimeout = 27;        // Value field is a 32 bit integral value
  raatIdleTimeout = 28;           // Value field is a 32 bit integral value
  raatTerminationAction = 29;     // Value field is a 32 bit integral value
  raatCalledStationId = 30;       // Value field is a Pointer
  raatCallingStationId = 31;      // Value field is a Pointer
  raatNASIdentifier = 32;         // Value field is a Pointer
  raatProxyState = 33;            // Value field is a Pointer
  raatLoginLATService = 34;       // Value field is a Pointer
  raatLoginLATNode = 35;          // Value field is a Pointer
  raatLoginLATGroup = 36;         // Value field is a Pointer
  raatFramedAppleTalkLink = 37;   // Value field is a 32 bit integral value
  raatFramedAppleTalkNetwork = 38;// Value field is a 32 bit integral value
  raatFramedAppleTalkZone = 39;   // Value field is a Pointer
  raatAcctStatusType = 40;        // Value field is a 32 bit integral value
  raatAcctDelayTime = 41;         // Value field is a 32 bit integral value
  raatAcctInputOctets = 42;       // Value field is a 32 bit integral value
  raatAcctOutputOctets = 43;      // Value field is a 32 bit integral value
  raatAcctSessionId = 44;         // Value field is a Pointer
  raatAcctAuthentic = 45;         // Value field is a 32 bit integral value
  raatAcctSessionTime = 46;       // Value field is a 32 bit integral value
  raatAcctInputPackets = 47;      // Value field is a 32 bit integral value
  raatAcctOutputPackets = 48;     // Value field is a 32 bit integral value
  raatAcctTerminateCause = 49;    // Value field is a 32 bit integral value
  raatAcctMultiSessionId = 50;    // Value field is a Pointer
  raatAcctLinkCount = 51;         // Value field is a 32 bit integral value
  raatAcctEventTimeStamp = 55;    // Value field is a 32 bit integral value
  raatMD5CHAPChallenge = 60;      // Value field is a Pointer
  raatNASPortType = 61;           // Value field is a 32 bit integral value
  raatPortLimit = 62;             // Value field is a 32 bit integral value
  raatLoginLATPort = 63;          // Value field is a Pointer
  raatTunnelType = 64;            // Value field is a 32 bit integral value
  raatTunnelMediumType = 65;      // Value field is a 32 bit integral value
  raatTunnelClientEndpoint = 66;  // Value field is a Pointer
  raatTunnelServerEndpoint = 67;  // Value field is a Pointer
  raatARAPPassword = 70;          // Value field is a Pointer
  raatARAPFeatures = 71;          // Value field is a Pointer
  raatARAPZoneAccess = 72;        // Value field is a 32 bit integral value
  raatARAPSecurity = 73;          // Value field is a 32 bit integral value
  raatARAPSecurityData = 74;      // Value field is a Pointer
  raatPasswordRetry = 75;         // Value field is a 32 bit integral value
  raatPrompt = 76;                // Value field is a 32 bit integral value
  raatConnectInfo = 77;           // Value field is a Pointer
  raatConfigurationToken = 78;    // Value field is a Pointer
  raatEAPMessage = 79;            // Value field is a Pointer
  raatSignature = 80;             // Value field is a Pointer
  raatARAPChallengeResponse = 84; // Value field is a Pointer
  raatAcctInterimInterval = 85;   // Value field is a 32 bit integral value
  raatARAPGuestLogon = 8096;      // Value field is a 32 bit integral value
  raatReserved = $FFFFFFFF;       // Undefined


// VSA attribute ids for ARAP

  raatARAPChallenge              = 33;
  {$EXTERNALSYM raatARAPChallenge}
  raatARAPOldPassword            = 19;
  {$EXTERNALSYM raatARAPOldPassword}
  raatARAPNewPassword            = 20;
  {$EXTERNALSYM raatARAPNewPassword}
  raatARAPPasswordChangeReason   = 21;
  {$EXTERNALSYM raatARAPPasswordChangeReason}


// Value is set to the 32 bit integral value or a pointer to data.
// 32 bit integral values should be in host format, not network format.
// Length for a 32 bit integral value can be 1, 2 or 4. The array of
// attributes must be terminated with an attribute of type raatMinimum.

type
  PRasAuthAttribute = ^TRasAuthAttribute;
  _RAS_AUTH_ATTRIBUTE = record
    raaType: TRasAuthAttributeType;
    dwLength: DWORD;
    Value: Pointer;
  end;
  {$EXTERNALSYM _RAS_AUTH_ATTRIBUTE}
  TRasAuthAttribute = _RAS_AUTH_ATTRIBUTE;
  RAS_AUTH_ATTRIBUTE = _RAS_AUTH_ATTRIBUTE;
  {$EXTERNALSYM RAS_AUTH_ATTRIBUTE}

const

// EAP packet codes from EAP spec.
  EAPCODE_Request       = 1;
  {$EXTERNALSYM EAPCODE_Request}
  EAPCODE_Response      = 2;
  {$EXTERNALSYM EAPCODE_Response}
  EAPCODE_Success       = 3;
  {$EXTERNALSYM EAPCODE_Success}
  EAPCODE_Failure       = 4;
  {$EXTERNALSYM EAPCODE_Failure}

  MAXEAPCODE            = 4;
  {$EXTERNALSYM MAXEAPCODE}

  RAS_EAP_FLAG_ROUTER             = $00000001;  // This is a router
  {$EXTERNALSYM RAS_EAP_FLAG_ROUTER}
  RAS_EAP_FLAG_NON_INTERACTIVE    = $00000002;  // No UI should be displayed
  {$EXTERNALSYM RAS_EAP_FLAG_NON_INTERACTIVE}
  RAS_EAP_FLAG_LOGON              = $00000004;  // The user data was
                                                // obtained from Winlogon
  {$EXTERNALSYM RAS_EAP_FLAG_LOGON}
  RAS_EAP_FLAG_PREVIEW            = $00000008;  // User has checked
                                                // "Prompt for information
                                                // before dialing"
  {$EXTERNALSYM RAS_EAP_FLAG_PREVIEW}
  RAS_EAP_FLAG_FIRST_LINK         = $00000010;  // This is the first link
  {$EXTERNALSYM RAS_EAP_FLAG_FIRST_LINK}


type
  PPppEapPacket = ^TPppEapPacket;
  _PPP_EAP_PACKET = record
    Code: Byte;           // 1-Request, 2-Response, 3-Success, 4-Failure
    Id: Byte;             // Id of this packet
    Length: Word;         // Length of this packet
    Data: Byte;           // Data - First byte is Type for Request/Response
  end;
  {$EXTERNALSYM _PPP_EAP_PACKET}
  TPppEapPacket = _PPP_EAP_PACKET;
  PPP_EAP_PACKET = _PPP_EAP_PACKET;
  {$EXTERNALSYM PPP_EAP_PACKET}


// Interface structure between the engine and APs. This is passed to the
// AP's via the RasCpBegin call.

  PPppEapInput = ^TPppEapInput;
  _PPP_EAP_INPUT = record
    // Size of this structure
    dwSizeInBytes: DWORD;

    // The following five fields are valid only in RasEapBegin call
    fFlags: DWORD;             // See RAS_EAP_FLAG_*
    fAuthenticator: BOOL;      // Act as authenticator or authenticatee
    pwszIdentity: PWideChar;   // Users's identity
    pwszPassword: PWideChar;   // Client's account password. Only valid when
                               // fAuthenticator is FALSE.
    bInitialId: Byte;          // Initial packet identifier. Must be used for
                               // the first EAP packet sent by the DLL and
                               // incremented by one for each subsequent
                               // request packet.

    // During the RasEapBegin call on the authenticator side, pUserAttributes
    // contains the set of attributes for the currently dialed in user, e.g.,
    // the port used, NAS IP Address, etc.
    //
    // When the fAuthenticationComplete flag is TRUE, pUserAttributes contains
    // attributes (if any) returned by the authentication provider.
    //
    // This memory is not owned by the EAP DLL and should be treated as
    // read-only.
    pUserAttributes: PRasAuthAttribute;

    // The next two fields are used only if the EAP DLL is using the
    // currently configured authentication provider ex: RADIUS or Windows NT
    // domain authentication, and the fAuthenticator field above is set to
    // TRUE.

    // Indicates that the authenticator has completed authentication.
    // Ignore this field if an authentication provider is not being used.
    fAuthenticationComplete: BOOL;

    // Result of the authentication process by the authentication provider.
    // NO_ERROR indicates success, otherwise it is a value from winerror.h,
    // raserror.h or mprerror.h indicating failure reason.
    dwAuthResultCode: DWORD;

    // Valid only on the authenticatee side. This may be used on the
    // authenticatee side to impersonate the user being authenticated.
    hTokenImpersonateUser: THandle;

    // This variable should be examined only by the authenticatee side.
    // The EAP specification states that the success packet may be lost and
    // since it is a non-acknowledged packet, reception of an NCP packet should
    // be interpreted as a success packet. This varable is set to TRUE in this
    // case only on the authenticatee side
    fSuccessPacketReceived: BOOL;

    // Will be set to TRUE only when the user dismissed the interactive
    // UI that was invoked by the EAP dll
    fDataReceivedFromInteractiveUI: BOOL;

    // Data received from the Interactive UI. Will be set to
    // non-NULL when fDataReceivedFromInteractiveUI is set to TRUE and
    // RasEapInvokeInteractiveUI returned non-NULL data. This buffer will be
    // freed by the PPP engine on return from the RasEapMakeMessage call. A
    // copy of this data should be made in the EAP Dll's memory space.
    pDataFromInteractiveUI: Pointer;

    // Size in bytes of data pointed to by pInteractiveConnectionData. This may
    // be 0 if there was no data passed back by RasEapInvokeInteractiveUI.
    dwSizeOfDataFromInteractiveUI: DWORD;

    // Connection data received from the Config UI. Will be set to non-NULL
    // when the RasEapBegin call is made and the RasEapInvokeConfigUI
    // returned non-NULL data. This buffer will be freed by the PPP engine
    // on return from the RasEapBegin call. A copy of this data should
    // be made in the EAP Dll's memory space.
    pConnectionData: Pointer;

    // Size in bytes of data pointed to by pConnectionData. This may be
    // 0 if there was no data passed back by the RasEapInvokeConfigUI call.
    dwSizeOfConnectionData: DWORD;

    // User data received from the Identity UI or Interactive UI. Will be set
    // to non-NULL when the RasEapBegin call is made if such data exists.
    // This buffer will be freed by the PPP engine on return from the
    // RasEapBegin call. A copy of this data should be made in the EAP Dll's
    // memory space.
    pUserData: Pointer;

    // Size in bytes of data pointed to by pUserData. This may be 0 if there
    // is no data.
    dwSizeOfUserData: DWORD;

    // Reserved.
    hReserved: THandle;
  end;
  {$EXTERNALSYM _PPP_EAP_INPUT}
  TPppEapInput = _PPP_EAP_INPUT;
  PPP_EAP_INPUT = _PPP_EAP_INPUT;
  {$EXTERNALSYM PPP_EAP_INPUT}


  PPppEapAction = ^TPppEapAction;
  _PPP_EAP_ACTION = DWORD;
  {EXTERNALSYM _PPP_EAP_ACTION}
  TPppEapAction = _PPP_EAP_ACTION;
  PPP_EAP_ACTION = _PPP_EAP_ACTION;
  {EXTERNALSYM PPP_EAP_ACTION}

// These actions are provided by the EAP DLL as output from the
// RasEapMakeMessage API.  They tell the PPP engine what action (if any) to
// take on the EAP DLL's behalf, and eventually inform the engine that the
// EAP DLL has finished authentication.


const
  EAPACTION_NoAction = 0;        // Be passive, i.e. listen without timeout (default)
  {EXTERNALSYM EAPACTION_NoAction}
  EAPACTION_Authenticate = 1;    // Invoke the back-end authenticator.
  {EXTERNALSYM EAPACTION_Authenticate}
  EAPACTION_Done = 2;            // End auth session, dwAuthResultCode is set
  {EXTERNALSYM EAPACTION_Done}
  EAPACTION_SendAndDone = 3;     // As above but send message without timeout first
  {EXTERNALSYM EAPACTION_SendAndDone}
  EAPACTION_Send = 4;            // Send message, don't timeout waiting for reply
  {EXTERNALSYM EAPACTION_Send}
  EAPACTION_SendWithTimeout = 5; // Send message, timeout if reply not received
  {EXTERNALSYM EAPACTION_SendWithTimeout}
  EAPACTION_SendWithTimeoutInteractive = 6; // As above, but don't increment
                                            // retry count
  {EXTERNALSYM EAPACTION_SendWithTimeoutInteractive}

type
  PPppEapOutput = ^TPppEapOutput;
  _PPP_EAP_OUTPUT = record
    // Size of this structure
    dwSizeInBytes: DWORD;

    // Action that the PPP engine should take
    Action: TPppEapAction;

    // dwAuthResultCode is valid only with an Action code of Done or
    // SendAndDone. Zero value indicates succesful authentication.
    // Non-zero indicates unsuccessful authentication with the value
    // indicating the reason for authentication failure.
    // Non-zero return codes should be only from winerror.h, raserror.h and
    // mprerror.h
    dwAuthResultCode: DWORD;

    // When Action is EAPACTION_Authenticate, pUserAttributes may contain
    // additional attributes necessary to authenticate the user, e.g.,
    // User-Password. If no credentials are presented, the back-end
    // authenticator will assume the user is authentic and only retrieve
    // authorizations.
    //
    // When Action is EAPACTION_Done, EAPACTION_SendAndDone, or EAPACTION_Send,
    // pUserAttributes may contain additional attributes for the user. These
    // attributes will overwrite any attributes of the same type returned by
    // the back-end authenticator.
    //
    // It is up to the EAP DLL to free this memory in RasEapEnd call.
    pUserAttributes: PRasAuthAttribute;

    // Flag set to true will cause the RasEapInvokeInteractiveUI call to be
    // made.
    fInvokeInteractiveUI: BOOL;

    // Pointer to context data, if any, to be sent to the UI. The EAP dll
    // is responsible for freeing this buffer in the RasEapEnd call or when
    // a response from the user for this invocation is obtained.
    pUIContextData: Pointer;

    // Size in bytes of the data pointed to by pUIContextData. Ignored if
    // pUIContextData is NULL
    dwSizeOfUIContextData: DWORD;

    // When set to TRUE, indicates that the information pointed to by
    // pConnectionData should be saved in the phonebook. Only valid on
    // the authenticatee side.
    fSaveConnectionData: BOOL;

    // If fSaveConnectionData above is true, the data pointed to by
    // pConnectionData will be saved in the phonebook. This data
    // must be freed by the DLL when the RasEapEnd call is made.
    pConnectionData: Pointer;

    // Size, in bytes, of the data pointed to by pConnectionData
    dwSizeOfConnectionData: DWORD;

    // When set to TRUE, indicates that the information pointed to by
    // pUserData should be saved in the registry for this user. Only valid
    // on the authenticatee side.
    fSaveUserData: BOOL;

    // If fSaveUserData above is true, the data pointed to by pUserData will be
    // saved in the registry for this user. This data must be freed by the DLL
    // when the RasEapEnd call is made.
    pUserData: PBYTE;

    // Size, in bytes, of the data pointed to by pUserData
    dwSizeOfUserData: DWORD;
  end;
  {$EXTERNALSYM _PPP_EAP_OUTPUT}
  TPppEapOutput = _PPP_EAP_OUTPUT;
  PPP_EAP_OUTPUT = _PPP_EAP_OUTPUT;
  {$EXTERNALSYM PPP_EAP_OUTPUT}

  PPppEapInfo = ^TPppEapInfo;
  _PPP_EAP_INFO = record
    // Size of this structure
    dwSizeInBytes: DWORD;
    dwEapTypeId: DWORD;

    // Called to initialize/uninitialize this module. This will be called before
    // any other call is made. fInitialize will be TRUE iff the module has to be
    // initialized. Must return errorcodes only from winerror.h, raserror.h or
    // mprerror.h
    RasEapInitialize: function (fInitialize: BOOL): DWORD; stdcall;

    // Called to get a context buffer for this EAP session and pass
    // initialization information. This will be called before any other
    // call is made, except RasEapInitialize. Must return errorcodes only from
    // winerror.h, raserror.h or mprerror.h
    RasEapBegin: function (var ppWorkBuffer: Pointer; pPppEapInput: PPppEapInput): DWORD; stdcall;

    // Called to free the context buffer for this EAP session.
    // Called after this session is completed successfully or not, provided
    // the RasEapBegin call for this EAP session returned successfully.
    // Must return errorcodes only from winerror.h, raserror.h or mprerror.h
    RasEapEnd: function (pWorkBuffer: Pointer): DWORD; stdcall;

    // Called to process an incomming packet and/or send a packet.
    // cbSendPacket is the size in bytes of the buffer pointed to by
    // pSendPacket. Must return errorcodes only from winerror.h, raserror.h or
    // mprerror.h. Error return code indicates an error occurance during the
    // authentication process.
    RasEapMakeMessage: function (pWorkBuf: Pointer; pReceivePacket: PPppEapPacket;
      var pSendPacket: TPppEapPacket; cbSendPacket: DWORD;
      var pEapOutput: TPppEapOutput; pEapInput: PPppEapInput): DWORD; stdcall;

  end;
  {EXTERNALSYM _PPP_EAP_INFO}
  TPppEapInfo = _PPP_EAP_INFO;
  PPP_EAP_INFO = _PPP_EAP_INFO;
  {EXTERNALSYM PPP_EAP_INFO}

// RasEapGetInfo should be exported by the 3rd party EAP dll installed in the
// registry via the Path value.

  TRasEapGetInfo = function (dwEapTypeId: DWORD;
    var pEapInfo: TPppEapInfo): DWORD; stdcall;


// RasEapFreeMemory should be exported by the 3rd party EAP dlls installed in
// the registry via the InteractiveUIPath, ConfigUIPath, and IdentityPath
// values.

  TRasEapFreeMemory = function (pMemory: Pointer): DWORD; stdcall;

// RasEapInvokeInteractiveUI and RasEapFreeUserData should be exported by the
// 3rd party EAP dll installed in the registry via the InterfactiveUI value.

  TRasEapInvokeInteractiveUI = function (dwEapTypeId: DWORD; hwndParent: HWND;
    pUIContextData: Pointer; dwSizeofUIContextData: DWORD; ppUserData: Pointer;
    var lpdwSizeOfUserData: DWORD): DWORD; stdcall;

// RasEapInvokeConfigUI and RasEapFreeMemory should be exported by the
// 3rd party EAP dll installed in the registry via the ConfigUIPath value.

  TRasEapInvokeConfigUI = function (dwEapTypeId: DWORD; hwndParent: HWND;
    dwFlags: DWORD; pConnectionDataIn: Pointer; dwSizeOfConnectionDataIn: DWORD;
    ppConnectionDataOut: Pointer; var pdwSizeOfConnectionDataOut: DWORD): DWORD; stdcall;

// RasEapGetIdentity and RasEapFreeMemory should be exported by the
// 3rd party EAP dll installed in the registry via the IdentityPath value.

  TRasEapGetIdentity = function (dwEapTypeId: DWORD; hwndParent: HWND;
    dwFlags: DWORD; pwszPhonebook, pwszEntry: PWideChar;
    pConnectionDataIn: Pointer; dwSizeOfConnectionDataIn: DWORD;
    pUserDataIn: Pointer; dwSizeOfUserDataIn: DWORD; ppUserDataOut: Pointer;
    var pdwSizeOfUserDataOut: DWORD; ppwszIdentity: PWideChar): DWORD; stdcall;

{$ENDIF}

implementation

end.
