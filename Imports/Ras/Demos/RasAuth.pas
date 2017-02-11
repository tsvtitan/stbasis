{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS functions interface unit                                     }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: rasauth.h, released 24 Apr 1998.           }
{ The original Pascal code is: RasAuth.pas, released 13 Jan 2000.  }
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

unit RasAuth;

{$I RAS.INC}

{$ALIGN ON}
{$MINENUMSIZE 4}
{$WEAKPACKAGEUNIT}

interface

uses
  Windows;

// Description: Contains definitions to allow for third parties to plug in
//              back-end authenticaion modules into Remote Access Service.

type
  PRasEnumAuthAttributeType = ^TRasEnumAuthAttributeType;
  _RAS_AUTH_ATTRIBUTE_TYPE = DWORD;
  {$EXTERNALSYM _RAS_AUTH_ATTRIBUTE_TYPE}
  TRasEnumAuthAttributeType = _RAS_AUTH_ATTRIBUTE_TYPE;
  RAS_AUTH_ATTRIBUTE_TYPE = _RAS_AUTH_ATTRIBUTE_TYPE;
  {$EXTERNALSYM RAS_AUTH_ATTRIBUTE_TYPE}

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
  raatUnassigned1 = 17;           // Undefined
  raatReplyMessage = 18;          // Value field is a Pointer
  raatCallbackNumber = 19;        // Value field is a Pointer
  raatCallbackId = 20;            // Value field is a Pointer
  raatUnassigned2 = 21;           // Undefined
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
  raatAcctDelayType = 41;         // Value field is a 32 bit integral value
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
  raatMD5CHAPChallenge = 60;      // Value field is a Pointer
  raatNASPortType = 61;           // Value field is a 32 bit integral value
  raatPortLimit = 62;             // Value field is a 32 bit integral value
  raatLoginLATPort = 63;          // Value field is a Pointer
  raatPrompt = 64;                // Value field is a 32 bit integral value
  raatConnectInfo = 65;           // Value field is a Pointer
  raatSignature = 66;             // Value field is a Pointer
  raatEAPMessage = 67;            // Value field is a Pointer
  raatConfigurationToken = 68;    // Value field is a Pointer
  raatPasswordRetry = 69;         // Value field is a 32 bit integral value
  raatARAPPassword = 70;          // Value field is a Pointer
  raatARAPFeatures = 71;          // Value field is a Pointer
  raatARAPZoneAccess = 72;        // Value field is a 32 bit integral value
  raatARAPSecurity = 73;          // Value field is a 32 bit integral value
  raatARAPSecurityData = 74;      // Value field is a Pointer
  raatReserved = $FFFFFFFF;       // Undefined

// Value is set to the 32 bit integral value or a pointer to data.
// 32 bit integral values should be in host format, not network format.
// Length for a 32 bit integral value can be 1, 2 or 4. The array of
// attributes must be terminated with an attribute of type raatMinimum.

type
  PRasAuthAttribute = ^TRasAuthAttribute;
  _RAS_AUTH_ATTRIBUTE = record
    raaType: TRasEnumAuthAttributeType;
    dwLength: DWORD;
    Value: Pointer;
  end;
  {$EXTERNALSYM _RAS_AUTH_ATTRIBUTE}
  TRasAuthAttribute = _RAS_AUTH_ATTRIBUTE;
  RAS_AUTH_ATTRIBUTE = _RAS_AUTH_ATTRIBUTE;
  {$EXTERNALSYM RAS_AUTH_ATTRIBUTE}

// The following APIs (except for RasStartAccounting and RasStopAccounting)
// must be exported by the back-end authentication DLL

// Called from setup application to allow backend package to bring up UI to
// configure itself.

type
  TRasAuthSetup = procedure; stdcall;

  TRasAuthConfigChangeNotification = function: DWORD; stdcall;

// Called once before any other calls are made.

  TRasAuthInitialize = function: DWORD; stdcall;

// Called once to deallocate resources etc. No more calls will be made before
// calling RasAuthInitialize again

  TRasAuthTerminate = function: DWORD; stdcall;

// Called once per multilink connection, not per link.

  TRasStartAccounting = function(pInAttributes: PRasAuthAttribute;
    var ppOutAttributes: TRasAuthAttribute): DWORD; stdcall;

// Called once per multilink connection, not per link.

  TRasStopAccounting= function(pInAttributes: PRasAuthAttribute;
    var ppOutAttributes: TRasAuthAttribute): DWORD; stdcall;

// Called to authenticate a dialed in user.

  TRasAuthenticateUser = function(pInAttributes: PRasAuthAttribute;
    var ppOutAttributes: TRasAuthAttribute;
    var lpdwResultCode: DWORD): DWORD; stdcall;

// Called to free attributes allocated by the back-end module

  TRasFreeAttributes = function(pInAttributes: PRasAuthAttribute): DWORD; stdcall;

implementation

end.
