{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ RAS error constants                                              }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: raserror.h, released 24 Apr 1998.          }
{ The original Pascal code is: RasError.pas, released 30 Dec 1999. }
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

unit RasError;

{$I RAS.INC}

{$WEAKPACKAGEUNIT}

interface

const
  RASBASE = 600;
  {$EXTERNALSYM RASBASE}
  SUCCESS = 0;
  {$EXTERNALSYM SUCCESS}

  PENDING = RASBASE+0;
  {$EXTERNALSYM PENDING}
  // An operation is pending.

  ERROR_INVALID_PORT_HANDLE = RASBASE+1;
  {$EXTERNALSYM ERROR_INVALID_PORT_HANDLE}
  // The port handle is invalid.

  ERROR_PORT_ALREADY_OPEN = RASBASE+2;
  {$EXTERNALSYM ERROR_PORT_ALREADY_OPEN}
  // The port is already open.

  ERROR_BUFFER_TOO_SMALL = RASBASE+3;
  {$EXTERNALSYM ERROR_BUFFER_TOO_SMALL}
  // Caller's buffer is too small.

  ERROR_WRONG_INFO_SPECIFIED = RASBASE+4;
  {$EXTERNALSYM ERROR_WRONG_INFO_SPECIFIED}
  // Wrong information specified.

  ERROR_CANNOT_SET_PORT_INFO = RASBASE+5;
  {$EXTERNALSYM ERROR_CANNOT_SET_PORT_INFO}
  // Cannot set port information.

  ERROR_PORT_NOT_CONNECTED = RASBASE+6;
  {$EXTERNALSYM ERROR_PORT_NOT_CONNECTED}
  // The port is not connected.

  ERROR_EVENT_INVALID = RASBASE+7;
  {$EXTERNALSYM ERROR_EVENT_INVALID}
  // The event is invalid.

  ERROR_DEVICE_DOES_NOT_EXIST = RASBASE+8;
  {$EXTERNALSYM ERROR_DEVICE_DOES_NOT_EXIST}
  // The device does not exist.

  ERROR_DEVICETYPE_DOES_NOT_EXIST = RASBASE+9;
  {$EXTERNALSYM ERROR_DEVICETYPE_DOES_NOT_EXIST}
  // The device type does not exist.

  ERROR_BUFFER_INVALID = RASBASE+10;
  {$EXTERNALSYM ERROR_BUFFER_INVALID}
  // The buffer is invalid.

  ERROR_ROUTE_NOT_AVAILABLE = RASBASE+11;
  {$EXTERNALSYM ERROR_ROUTE_NOT_AVAILABLE}
  // The route is not available.

  ERROR_ROUTE_NOT_ALLOCATED = RASBASE+12;
  {$EXTERNALSYM ERROR_ROUTE_NOT_ALLOCATED}
  // The route is not allocated.

  ERROR_INVALID_COMPRESSION_SPECIFIED = RASBASE+13;
  {$EXTERNALSYM ERROR_INVALID_COMPRESSION_SPECIFIED}
  // Invalid compression specified.

  ERROR_OUT_OF_BUFFERS = RASBASE+14;
  {$EXTERNALSYM ERROR_OUT_OF_BUFFERS}
  // Out of buffers.

  ERROR_PORT_NOT_FOUND = RASBASE+15;
  {$EXTERNALSYM ERROR_PORT_NOT_FOUND}
  // The port was not found.

  ERROR_ASYNC_REQUEST_PENDING = RASBASE+16;
  {$EXTERNALSYM ERROR_ASYNC_REQUEST_PENDING}
  // An asynchronous request is pending.

  ERROR_ALREADY_DISCONNECTING = RASBASE+17;
  {$EXTERNALSYM ERROR_ALREADY_DISCONNECTING}
  // The port or device is already disconnecting.

  ERROR_PORT_NOT_OPEN = RASBASE+18;
  {$EXTERNALSYM ERROR_PORT_NOT_OPEN}
  // The port is not open.

  ERROR_PORT_DISCONNECTED = RASBASE+19;
  {$EXTERNALSYM ERROR_PORT_DISCONNECTED}
  // The port is disconnected.

  ERROR_NO_ENDPOINTS = RASBASE+20;
  {$EXTERNALSYM ERROR_NO_ENDPOINTS}
  // There are no endpoints.

  ERROR_CANNOT_OPEN_PHONEBOOK = RASBASE+21;
  {$EXTERNALSYM ERROR_CANNOT_OPEN_PHONEBOOK}
  // Cannot open the phone book file.

  ERROR_CANNOT_LOAD_PHONEBOOK = RASBASE+22;
  {$EXTERNALSYM ERROR_CANNOT_LOAD_PHONEBOOK}
  // Cannot load the phone book file.

  ERROR_CANNOT_FIND_PHONEBOOK_ENTRY = RASBASE+23;
  {$EXTERNALSYM ERROR_CANNOT_FIND_PHONEBOOK_ENTRY}
  // Cannot find the phone book entry.

  ERROR_CANNOT_WRITE_PHONEBOOK = RASBASE+24;
  {$EXTERNALSYM ERROR_CANNOT_WRITE_PHONEBOOK}
  // Cannot write the phone book file.

  ERROR_CORRUPT_PHONEBOOK = RASBASE+25;
  {$EXTERNALSYM ERROR_CORRUPT_PHONEBOOK}
  // Invalid information found in the phone book file.

  ERROR_CANNOT_LOAD_STRING = RASBASE+26;
  {$EXTERNALSYM ERROR_CANNOT_LOAD_STRING}
  // Cannot load a string.

  ERROR_KEY_NOT_FOUND = RASBASE+27;
  {$EXTERNALSYM ERROR_KEY_NOT_FOUND}
  // Cannot find key.

  ERROR_DISCONNECTION = RASBASE+28;
  {$EXTERNALSYM ERROR_DISCONNECTION}
  // The port was disconnected.

  ERROR_REMOTE_DISCONNECTION = RASBASE+29;
  {$EXTERNALSYM ERROR_REMOTE_DISCONNECTION}
  // The data link was terminated by the remote machine.

  ERROR_HARDWARE_FAILURE = RASBASE+30;
  {$EXTERNALSYM ERROR_HARDWARE_FAILURE}
  // The port was disconnected due to hardware failure.

  ERROR_USER_DISCONNECTION = RASBASE+31;
  {$EXTERNALSYM ERROR_USER_DISCONNECTION}
  // The port was disconnected by the user.

  ERROR_INVALID_SIZE = RASBASE+32;
  {$EXTERNALSYM ERROR_INVALID_SIZE}
  // The structure size is incorrect.

  ERROR_PORT_NOT_AVAILABLE = RASBASE+33;
  {$EXTERNALSYM ERROR_PORT_NOT_AVAILABLE}
  // The port is already in use or is not configured for Remote Access dial out.

  ERROR_CANNOT_PROJECT_CLIENT = RASBASE+34;
  {$EXTERNALSYM ERROR_CANNOT_PROJECT_CLIENT}
  // Cannot register your computer on on the remote network.

  ERROR_UNKNOWN = RASBASE+35;
  {$EXTERNALSYM ERROR_UNKNOWN}
  // Unknown error.

  ERROR_WRONG_DEVICE_ATTACHED = RASBASE+36;
  {$EXTERNALSYM ERROR_WRONG_DEVICE_ATTACHED}
  // The wrong device is attached to the port.

  ERROR_BAD_STRING = RASBASE+37;
  {$EXTERNALSYM ERROR_BAD_STRING}
  // The string could not be converted.

  ERROR_REQUEST_TIMEOUT = RASBASE+38;
  {$EXTERNALSYM ERROR_REQUEST_TIMEOUT}
  // The request has timed out.

  ERROR_CANNOT_GET_LANA = RASBASE+39;
  {$EXTERNALSYM ERROR_CANNOT_GET_LANA}
  // No asynchronous net available.

  ERROR_NETBIOS_ERROR = RASBASE+40;
  {$EXTERNALSYM ERROR_NETBIOS_ERROR}
  // A NetBIOS error has occurred.

  ERROR_SERVER_OUT_OF_RESOURCES = RASBASE+41;
  {$EXTERNALSYM ERROR_SERVER_OUT_OF_RESOURCES}
  // The server cannot allocate NetBIOS resources needed to support the client.

  ERROR_NAME_EXISTS_ON_NET = RASBASE+42;
  {$EXTERNALSYM ERROR_NAME_EXISTS_ON_NET}
  // One of your NetBIOS names is already registered on the remote network.

  ERROR_SERVER_GENERAL_NET_FAILURE = RASBASE+43;
  {$EXTERNALSYM ERROR_SERVER_GENERAL_NET_FAILURE}
  // A network adapter at the server failed.

  WARNING_MSG_ALIAS_NOT_ADDED = RASBASE+44;
  {$EXTERNALSYM WARNING_MSG_ALIAS_NOT_ADDED}
  // You will not receive network message popups.

  ERROR_AUTH_INTERNAL = RASBASE+45;
  {$EXTERNALSYM ERROR_AUTH_INTERNAL}
  // Internal authentication error.

  ERROR_RESTRICTED_LOGON_HOURS = RASBASE+46;
  {$EXTERNALSYM ERROR_RESTRICTED_LOGON_HOURS}
  // The account is not permitted to logon at this time of day.

  ERROR_ACCT_DISABLED = RASBASE+47;
  {$EXTERNALSYM ERROR_ACCT_DISABLED}
  // The account is disabled.

  ERROR_PASSWD_EXPIRED = RASBASE+48;
  {$EXTERNALSYM ERROR_PASSWD_EXPIRED}
  // The password has expired.

  ERROR_NO_DIALIN_PERMISSION = RASBASE+49;
  {$EXTERNALSYM ERROR_NO_DIALIN_PERMISSION}
  // The account does not have Remote Access permission.

  ERROR_SERVER_NOT_RESPONDING = RASBASE+50;
  {$EXTERNALSYM ERROR_SERVER_NOT_RESPONDING}
  // The Remote Access server is not responding.

  ERROR_FROM_DEVICE = RASBASE+51;
  {$EXTERNALSYM ERROR_FROM_DEVICE}
  // Your modem (or other connecting device) has reported an error.

  ERROR_UNRECOGNIZED_RESPONSE = RASBASE+52;
  {$EXTERNALSYM ERROR_UNRECOGNIZED_RESPONSE}
  // Unrecognized response from the device.

  ERROR_MACRO_NOT_FOUND = RASBASE+53;
  {$EXTERNALSYM ERROR_MACRO_NOT_FOUND}
  // A macro required by the device was not found in the device .INF file section.

  ERROR_MACRO_NOT_DEFINED = RASBASE+54;
  {$EXTERNALSYM ERROR_MACRO_NOT_DEFINED}
  // A command or response in the device .INF file section refers to an undefined macro.

  ERROR_MESSAGE_MACRO_NOT_FOUND = RASBASE+55;
  {$EXTERNALSYM ERROR_MESSAGE_MACRO_NOT_FOUND}
  // The <message> macro was not found in the device .INF file secion.

  ERROR_DEFAULTOFF_MACRO_NOT_FOUND = RASBASE+56;
  {$EXTERNALSYM ERROR_DEFAULTOFF_MACRO_NOT_FOUND}
  // The <defaultoff> macro in the device .INF file section contains an undefined macro.

  ERROR_FILE_COULD_NOT_BE_OPENED = RASBASE+57;
  {$EXTERNALSYM ERROR_FILE_COULD_NOT_BE_OPENED}
  // The device .INF file could not be opened.

  ERROR_DEVICENAME_TOO_LONG = RASBASE+58;
  {$EXTERNALSYM ERROR_DEVICENAME_TOO_LONG}
  // The device name in the device .INF or media .INI file is too long.

  ERROR_DEVICENAME_NOT_FOUND = RASBASE+59;
  {$EXTERNALSYM ERROR_DEVICENAME_NOT_FOUND}
  // The media .INI file refers to an unknown device name.

  ERROR_NO_RESPONSES = RASBASE+60;
  {$EXTERNALSYM ERROR_NO_RESPONSES}
  // The device .INF file contains no responses for the command.

  ERROR_NO_COMMAND_FOUND = RASBASE+61;
  {$EXTERNALSYM ERROR_NO_COMMAND_FOUND}
  // The device .INF file is missing a command.

  ERROR_WRONG_KEY_SPECIFIED = RASBASE+62;
  {$EXTERNALSYM ERROR_WRONG_KEY_SPECIFIED}
  // Attempted to set a macro not listed in device .INF file section.

  ERROR_UNKNOWN_DEVICE_TYPE = RASBASE+63;
  {$EXTERNALSYM ERROR_UNKNOWN_DEVICE_TYPE}
  // The media .INI file refers to an unknown device type.

  ERROR_ALLOCATING_MEMORY = RASBASE+64;
  {$EXTERNALSYM ERROR_ALLOCATING_MEMORY}
  // Cannot allocate memory.

  ERROR_PORT_NOT_CONFIGURED = RASBASE+65;
  {$EXTERNALSYM ERROR_PORT_NOT_CONFIGURED}
  // The port is not configured for Remote Access.

  ERROR_DEVICE_NOT_READY = RASBASE+66;
  {$EXTERNALSYM ERROR_DEVICE_NOT_READY}
  // Your modem (or other connecting device) is not functioning.

  ERROR_READING_INI_FILE = RASBASE+67;
  {$EXTERNALSYM ERROR_READING_INI_FILE}
  // Cannot read the media .INI file.

  ERROR_NO_CONNECTION = RASBASE+68;
  {$EXTERNALSYM ERROR_NO_CONNECTION}
  // The connection dropped.

  ERROR_BAD_USAGE_IN_INI_FILE = RASBASE+69;
  {$EXTERNALSYM ERROR_BAD_USAGE_IN_INI_FILE}
  // The usage parameter in the media .INI file is invalid.

  ERROR_READING_SECTIONNAME = RASBASE+70;
  {$EXTERNALSYM ERROR_READING_SECTIONNAME}
  // Cannot read the section name from the media .INI file.

  ERROR_READING_DEVICETYPE = RASBASE+71;
  {$EXTERNALSYM ERROR_READING_DEVICETYPE}
  // Cannot read the device type from the media .INI file.

  ERROR_READING_DEVICENAME = RASBASE+72;
  {$EXTERNALSYM ERROR_READING_DEVICENAME}
  // Cannot read the device name from the media .INI file.

  ERROR_READING_USAGE = RASBASE+73;
  {$EXTERNALSYM ERROR_READING_USAGE}
  // Cannot read the usage from the media .INI file.

  ERROR_READING_MAXCONNECTBPS = RASBASE+74;
  {$EXTERNALSYM ERROR_READING_MAXCONNECTBPS}
  // Cannot read the maximum connection BPS rate from the media .INI file.

  ERROR_READING_MAXCARRIERBPS = RASBASE+75;
  {$EXTERNALSYM ERROR_READING_MAXCARRIERBPS}
  // Cannot read the maximum carrier BPS rate from the media .INI file.

  ERROR_LINE_BUSY = RASBASE+76;
  {$EXTERNALSYM ERROR_LINE_BUSY}
  // The line is busy.

  ERROR_VOICE_ANSWER = RASBASE+77;
  {$EXTERNALSYM ERROR_VOICE_ANSWER}
  // A person answered instead of a modem.

  ERROR_NO_ANSWER = RASBASE+78;
  {$EXTERNALSYM ERROR_NO_ANSWER}
  // There is no answer.

  ERROR_NO_CARRIER = RASBASE+79;
  {$EXTERNALSYM ERROR_NO_CARRIER}
  // Cannot detect carrier.

  ERROR_NO_DIALTONE = RASBASE+80;
  {$EXTERNALSYM ERROR_NO_DIALTONE}
  // There is no dial tone.

  ERROR_IN_COMMAND = RASBASE+81;
  {$EXTERNALSYM ERROR_IN_COMMAND}
  // General error reported by device.

  ERROR_WRITING_SECTIONNAME = RASBASE+82;
  {$EXTERNALSYM ERROR_WRITING_SECTIONNAME}
  // ERROR_WRITING_SECTIONNAME

  ERROR_WRITING_DEVICETYPE = RASBASE+83;
  {$EXTERNALSYM ERROR_WRITING_DEVICETYPE}
  // ERROR_WRITING_DEVICETYPE

  ERROR_WRITING_DEVICENAME = RASBASE+84;
  {$EXTERNALSYM ERROR_WRITING_DEVICENAME}
  // ERROR_WRITING_DEVICENAME

  ERROR_WRITING_MAXCONNECTBPS = RASBASE+85;
  {$EXTERNALSYM ERROR_WRITING_MAXCONNECTBPS}
  // ERROR_WRITING_MAXCONNECTBPS

  ERROR_WRITING_MAXCARRIERBPS = RASBASE+86;
  {$EXTERNALSYM ERROR_WRITING_MAXCARRIERBPS}
  // ERROR_WRITING_MAXCARRIERBPS

  ERROR_WRITING_USAGE = RASBASE+87;
  {$EXTERNALSYM ERROR_WRITING_USAGE}
  // ERROR_WRITING_USAGE

  ERROR_WRITING_DEFAULTOFF = RASBASE+88;
  {$EXTERNALSYM ERROR_WRITING_DEFAULTOFF}
  // ERROR_WRITING_DEFAULTOFF

  ERROR_READING_DEFAULTOFF = RASBASE+89;
  {$EXTERNALSYM ERROR_READING_DEFAULTOFF}
  // ERROR_READING_DEFAULTOFF

  ERROR_EMPTY_INI_FILE = RASBASE+90;
  {$EXTERNALSYM ERROR_EMPTY_INI_FILE}
  // ERROR_EMPTY_INI_FILE

  ERROR_AUTHENTICATION_FAILURE = RASBASE+91;
  {$EXTERNALSYM ERROR_AUTHENTICATION_FAILURE}
  // Access denied because username and/or password is invalid on the domain.

  ERROR_PORT_OR_DEVICE = RASBASE+92;
  {$EXTERNALSYM ERROR_PORT_OR_DEVICE}
  // Hardware failure in port or attached device.

  ERROR_NOT_BINARY_MACRO = RASBASE+93;
  {$EXTERNALSYM ERROR_NOT_BINARY_MACRO}
  // ERROR_NOT_BINARY_MACRO

  ERROR_DCB_NOT_FOUND = RASBASE+94;
  {$EXTERNALSYM ERROR_DCB_NOT_FOUND}
  // ERROR_DCB_NOT_FOUND

  ERROR_STATE_MACHINES_NOT_STARTED = RASBASE+95;
  {$EXTERNALSYM ERROR_STATE_MACHINES_NOT_STARTED}
  // ERROR_STATE_MACHINES_NOT_STARTED

  ERROR_STATE_MACHINES_ALREADY_STARTED = RASBASE+96;
  {$EXTERNALSYM ERROR_STATE_MACHINES_ALREADY_STARTED}
  // ERROR_STATE_MACHINES_ALREADY_STARTED

  ERROR_PARTIAL_RESPONSE_LOOPING = RASBASE+97;
  {$EXTERNALSYM ERROR_PARTIAL_RESPONSE_LOOPING}
  // ERROR_PARTIAL_RESPONSE_LOOPING

  ERROR_UNKNOWN_RESPONSE_KEY = RASBASE+98;
  {$EXTERNALSYM ERROR_UNKNOWN_RESPONSE_KEY}
  // A response keyname in the device .INF file is not in the expected format.

  ERROR_RECV_BUF_FULL = RASBASE+99;
  {$EXTERNALSYM ERROR_RECV_BUF_FULL}
  // The device response caused buffer overflow.

  ERROR_CMD_TOO_LONG = RASBASE+100;
  {$EXTERNALSYM ERROR_CMD_TOO_LONG}
  // The expanded command in the device .INF file is too long.

  ERROR_UNSUPPORTED_BPS = RASBASE+101;
  {$EXTERNALSYM ERROR_UNSUPPORTED_BPS}
  // The device moved to a BPS rate not supported by the COM driver.

  ERROR_UNEXPECTED_RESPONSE = RASBASE+102;
  {$EXTERNALSYM ERROR_UNEXPECTED_RESPONSE}
  // Device response received when none expected.

  ERROR_INTERACTIVE_MODE = RASBASE+103;
  {$EXTERNALSYM ERROR_INTERACTIVE_MODE}
  // The Application does not allow user interaction. The connection requires interaction with the user to complete successfully.

  ERROR_BAD_CALLBACK_NUMBER = RASBASE+104;
  {$EXTERNALSYM ERROR_BAD_CALLBACK_NUMBER}
  // ERROR_BAD_CALLBACK_NUMB

  ERROR_INVALID_AUTH_STATE = RASBASE+105;
  {$EXTERNALSYM ERROR_INVALID_AUTH_STATE}
  // ERROR_INVALID_AUTH_STATE

  ERROR_WRITING_INITBPS = RASBASE+106;
  {$EXTERNALSYM ERROR_WRITING_INITBPS}
  // ERROR_WRITING_INITBPS

  ERROR_X25_DIAGNOSTIC = RASBASE+107;
  {$EXTERNALSYM ERROR_X25_DIAGNOSTIC}
  // X.25 diagnostic indication.

  ERROR_ACCT_EXPIRED = RASBASE+108;
  {$EXTERNALSYM ERROR_ACCT_EXPIRED}
  // The account has expired.

  ERROR_CHANGING_PASSWORD = RASBASE+109;
  {$EXTERNALSYM ERROR_CHANGING_PASSWORD}
  // Error changing password on domain.  The password may be too short or may match a previously used password.

  ERROR_OVERRUN = RASBASE+110;
  {$EXTERNALSYM ERROR_OVERRUN}
  // Serial overrun errors were detected while communicating with your modem.

  ERROR_RASMAN_CANNOT_INITIALIZE = RASBASE+111;
  {$EXTERNALSYM ERROR_RASMAN_CANNOT_INITIALIZE}
  // RasMan initialization failure.  Check the event log.

  ERROR_BIPLEX_PORT_NOT_AVAILABLE = RASBASE+112;
  {$EXTERNALSYM ERROR_BIPLEX_PORT_NOT_AVAILABLE}
  // Biplex port initializing.  Wait a few seconds and redial.

  ERROR_NO_ACTIVE_ISDN_LINES = RASBASE+113;
  {$EXTERNALSYM ERROR_NO_ACTIVE_ISDN_LINES}
  // No active ISDN lines are available.

  ERROR_NO_ISDN_CHANNELS_AVAILABLE = RASBASE+114;
  {$EXTERNALSYM ERROR_NO_ISDN_CHANNELS_AVAILABLE}
  // No ISDN channels are available to make the call.

  ERROR_TOO_MANY_LINE_ERRORS = RASBASE+115;
  {$EXTERNALSYM ERROR_TOO_MANY_LINE_ERRORS}
  // Too many errors occurred because of poor phone line quality.

  ERROR_IP_CONFIGURATION = RASBASE+116;
  {$EXTERNALSYM ERROR_IP_CONFIGURATION}
  // The Remote Access IP configuration is unusable.

  ERROR_NO_IP_ADDRESSES = RASBASE+117;
  {$EXTERNALSYM ERROR_NO_IP_ADDRESSES}
  // No IP addresses are available in the static pool of Remote Access IP addresses.

  ERROR_PPP_TIMEOUT = RASBASE+118;
  {$EXTERNALSYM ERROR_PPP_TIMEOUT}
  // Timed out waiting for a valid response from the remote PPP peer.

  ERROR_PPP_REMOTE_TERMINATED = RASBASE+119;
  {$EXTERNALSYM ERROR_PPP_REMOTE_TERMINATED}
  // PPP terminated by remote machine.

  ERROR_PPP_NO_PROTOCOLS_CONFIGURED = RASBASE+120;
  {$EXTERNALSYM ERROR_PPP_NO_PROTOCOLS_CONFIGURED}
  // No PPP control protocols configured.

  ERROR_PPP_NO_RESPONSE = RASBASE+121;
  {$EXTERNALSYM ERROR_PPP_NO_RESPONSE}
  // Remote PPP peer is not responding.

  ERROR_PPP_INVALID_PACKET = RASBASE+122;
  {$EXTERNALSYM ERROR_PPP_INVALID_PACKET}
  // The PPP packet is invalid.

  ERROR_PHONE_NUMBER_TOO_LONG = RASBASE+123;
  {$EXTERNALSYM ERROR_PHONE_NUMBER_TOO_LONG}
  // The phone number including prefix and suffix is too long.

  ERROR_IPXCP_NO_DIALOUT_CONFIGURED = RASBASE+124;
  {$EXTERNALSYM ERROR_IPXCP_NO_DIALOUT_CONFIGURED}
  // The IPX protocol cannot dial-out on the port because the machine is an IPX router.

  ERROR_IPXCP_NO_DIALIN_CONFIGURED = RASBASE+125;
  {$EXTERNALSYM ERROR_IPXCP_NO_DIALIN_CONFIGURED}
  // The IPX protocol cannot dial-in on the port because the IPX router is not installed.

  ERROR_IPXCP_DIALOUT_ALREADY_ACTIVE = RASBASE+126;
  {$EXTERNALSYM ERROR_IPXCP_DIALOUT_ALREADY_ACTIVE}
  // The IPX protocol cannot be used for dial-out on more than one port at a time.

  ERROR_ACCESSING_TCPCFGDLL = RASBASE+127;
  {$EXTERNALSYM ERROR_ACCESSING_TCPCFGDLL}
  // Cannot access TCPCFG.DLL.

  ERROR_NO_IP_RAS_ADAPTER = RASBASE+128;
  {$EXTERNALSYM ERROR_NO_IP_RAS_ADAPTER}
  // Cannot find an IP adapter bound to Remote Access.

  ERROR_SLIP_REQUIRES_IP = RASBASE+129;
  {$EXTERNALSYM ERROR_SLIP_REQUIRES_IP}
  // SLIP cannot be used unless the IP protocol is installed.

  ERROR_PROJECTION_NOT_COMPLETE = RASBASE+130;
  {$EXTERNALSYM ERROR_PROJECTION_NOT_COMPLETE}
  // Computer registration is not complete.

  ERROR_PROTOCOL_NOT_CONFIGURED = RASBASE+131;
  {$EXTERNALSYM ERROR_PROTOCOL_NOT_CONFIGURED}
  // The protocol is not configured.

  ERROR_PPP_NOT_CONVERGING = RASBASE+132;
  {$EXTERNALSYM ERROR_PPP_NOT_CONVERGING}
  // The PPP negotiation is not converging.

  ERROR_PPP_CP_REJECTED = RASBASE+133;
  {$EXTERNALSYM ERROR_PPP_CP_REJECTED}
  // The PPP control protocol for this network protocol is not available on the server.

  ERROR_PPP_LCP_TERMINATED = RASBASE+134;
  {$EXTERNALSYM ERROR_PPP_LCP_TERMINATED}
  // The PPP link control protocol terminated.

  ERROR_PPP_REQUIRED_ADDRESS_REJECTED = RASBASE+135;
  {$EXTERNALSYM ERROR_PPP_REQUIRED_ADDRESS_REJECTED}
  // The requested address was rejected by the server.

  ERROR_PPP_NCP_TERMINATED = RASBASE+136;
  {$EXTERNALSYM ERROR_PPP_NCP_TERMINATED}
  // The remote computer terminated the control protocol.

  ERROR_PPP_LOOPBACK_DETECTED = RASBASE+137;
  {$EXTERNALSYM ERROR_PPP_LOOPBACK_DETECTED}
  // Loopback detected.

  ERROR_PPP_NO_ADDRESS_ASSIGNED = RASBASE+138;
  {$EXTERNALSYM ERROR_PPP_NO_ADDRESS_ASSIGNED}
  // The server did not assign an address.

  ERROR_CANNOT_USE_LOGON_CREDENTIALS = RASBASE+139;
  {$EXTERNALSYM ERROR_CANNOT_USE_LOGON_CREDENTIALS}
  // The authentication protocol required by the remote server cannot use the Windows NT encrypted password.  Redial, entering the password explicitly.

  ERROR_TAPI_CONFIGURATION = RASBASE+140;
  {$EXTERNALSYM ERROR_TAPI_CONFIGURATION}
  // Invalid TAPI configuration.

  ERROR_NO_LOCAL_ENCRYPTION = RASBASE+141;
  {$EXTERNALSYM ERROR_NO_LOCAL_ENCRYPTION}
  // The local computer does not support the required encryption type.

  ERROR_NO_REMOTE_ENCRYPTION = RASBASE+142;
  {$EXTERNALSYM ERROR_NO_REMOTE_ENCRYPTION}
  // The remote computer does not support the required encryption type.

  ERROR_REMOTE_REQUIRES_ENCRYPTION = RASBASE+143;
  {$EXTERNALSYM ERROR_REMOTE_REQUIRES_ENCRYPTION}
  // The remote computer requires encryption.

  ERROR_IPXCP_NET_NUMBER_CONFLICT = RASBASE+144;
  {$EXTERNALSYM ERROR_IPXCP_NET_NUMBER_CONFLICT}
  // Cannot use the IPX network number assigned by remote server.  Check the event log.

  ERROR_INVALID_SMM = RASBASE+145;
  {$EXTERNALSYM ERROR_INVALID_SMM}
  // ERROR_INVALID_SMM

  ERROR_SMM_UNINITIALIZED = RASBASE+146;
  {$EXTERNALSYM ERROR_SMM_UNINITIALIZED}
  // ERROR_SMM_UNINITIALIZED

  ERROR_NO_MAC_FOR_PORT = RASBASE+147;
  {$EXTERNALSYM ERROR_NO_MAC_FOR_PORT}
  // ERROR_NO_MAC_FOR_PORT

  ERROR_SMM_TIMEOUT = RASBASE+148;
  {$EXTERNALSYM ERROR_SMM_TIMEOUT}
  // ERROR_SMM_TIMEOUT

  ERROR_BAD_PHONE_NUMBER = RASBASE+149;
  {$EXTERNALSYM ERROR_BAD_PHONE_NUMBER}
  // ERROR_BAD_PHONE_NUMBER

  ERROR_WRONG_MODULE = RASBASE+150;
  {$EXTERNALSYM ERROR_WRONG_MODULE}
  // ERROR_WRONG_MODULE

  ERROR_INVALID_CALLBACK_NUMBER = RASBASE+151;
  {$EXTERNALSYM ERROR_INVALID_CALLBACK_NUMBER}
  // Invalid callback number.  Only the characters 0 to 9, T, P, W, (, ), -, @, and space are allowed in the number.

  ERROR_SCRIPT_SYNTAX = RASBASE+152;
  {$EXTERNALSYM ERROR_SCRIPT_SYNTAX}
  // A syntax error was encountered while processing a script.

  ERROR_HANGUP_FAILED = RASBASE+153;
  {$EXTERNALSYM ERROR_HANGUP_FAILED}
  // The connection could not be disconnected because it was created by the Multi-Protocol Router.


  ERROR_BUNDLE_NOT_FOUND = RASBASE+154;
  //The system could not find the multi-link bundle,

  ERROR_CANNOT_DO_CUSTOMDIAL = RASBASE+155;
  {$EXTERNALSYM ERROR_CANNOT_DO_CUSTOMDIAL}
  //The system cannot perform automated dial because this connection  has a custom dialer specified,

  ERROR_DIAL_ALREADY_IN_PROGRESS = RASBASE+156;
  {$EXTERNALSYM ERROR_DIAL_ALREADY_IN_PROGRESS}
  //This connection is already being dialed,

  ERROR_RASAUTO_CANNOT_INITIALIZE = RASBASE+157;
  {$EXTERNALSYM ERROR_RASAUTO_CANNOT_INITIALIZE}
  //Remote Access Services could not be started automatically. Additional information is provided in the event log,

  ERROR_CONNECTION_ALREADY_SHARED = RASBASE+158;
  {$EXTERNALSYM ERROR_CONNECTION_ALREADY_SHARED}
  //Internet Connection Sharing is already enabled on the connection,

  ERROR_SHARING_CHANGE_FAILED = RASBASE+159;
  {$EXTERNALSYM ERROR_SHARING_CHANGE_FAILED}
  // An error occurred while the existing Internet Connection Sharing
  // settings were being changed,

  ERROR_SHARING_ROUTER_INSTALL = RASBASE+160;
  {$EXTERNALSYM ERROR_SHARING_ROUTER_INSTALL}
  //An error occurred while routing capabilities were being enabled,

  ERROR_SHARE_CONNECTION_FAILED = RASBASE+161;
  {$EXTERNALSYM ERROR_SHARE_CONNECTION_FAILED}
  // An error occurred while Internet Connection Sharing was being enabled
  // for the connection,

  ERROR_SHARING_PRIVATE_INSTALL = RASBASE+162;
  {$EXTERNALSYM ERROR_SHARING_PRIVATE_INSTALL}
  //An error occurred while the local network was being configured for sharing,

  ERROR_CANNOT_SHARE_CONNECTION = RASBASE+163;
  {$EXTERNALSYM ERROR_CANNOT_SHARE_CONNECTION}
  // Internet Connection Sharing cannot be enabled.
  // There is more than one LAN connection other than the connection
  // to be shared,

  ERROR_NO_SMART_CARD_READER = RASBASE+164;
  {$EXTERNALSYM ERROR_NO_SMART_CARD_READER}
  //No smart card reader is installed,

  ERROR_SHARING_ADDRESS_EXISTS = RASBASE+165;
  {$EXTERNALSYM ERROR_SHARING_ADDRESS_EXISTS}
  // Internet Connection Sharing cannot be enabled.
  // A LAN connection is already configured with the IP address
  // that is required for automatic IP addressing,

  ERROR_NO_CERTIFICATE = RASBASE+166;
  {$EXTERNALSYM ERROR_NO_CERTIFICATE}
  //A certificate could not be found. Connections that use the L2TP protocol over IPSec require the installation of a machine certificate, also known as a computer certificate,

  ERROR_SHARING_MULTIPLE_ADDRESSES = RASBASE+167;
  {$EXTERNALSYM ERROR_SHARING_MULTIPLE_ADDRESSES}
  // Internet Connection Sharing cannot be enabled. The LAN connection selected
  // as the private network has more than one IP address configured.
  // Please reconfigure the LAN connection with a single IP address
  // before enabling Internet Connection Sharing,

  ERROR_FAILED_TO_ENCRYPT = RASBASE+168;
  {$EXTERNALSYM ERROR_FAILED_TO_ENCRYPT}
  //The connection attempt failed because of failure to encrypt data,

  ERROR_BAD_ADDRESS_SPECIFIED = RASBASE+169;
  {$EXTERNALSYM ERROR_BAD_ADDRESS_SPECIFIED}
  //The specified destination is not reachable,

  ERROR_CONNECTION_REJECT = RASBASE+170;
  {$EXTERNALSYM ERROR_CONNECTION_REJECT}
  //The remote computer rejected the connection attempt,

  ERROR_CONGESTION = RASBASE+171;
  {$EXTERNALSYM ERROR_CONGESTION}
  //The connection attempt failed because the network is busy,

  ERROR_INCOMPATIBLE = RASBASE+172;
  {$EXTERNALSYM ERROR_INCOMPATIBLE}
  //The remote computer's network hardware is incompatible with the type of call requested,

  ERROR_NUMBERCHANGED = RASBASE+173;
  {$EXTERNALSYM ERROR_NUMBERCHANGED}
  //The connection attempt failed because the destination number has changed,

  ERROR_TEMPFAILURE = RASBASE+174;
  {$EXTERNALSYM ERROR_TEMPFAILURE}
  //The connection attempt failed because of a temporary failure.  Try connecting again,

  ERROR_BLOCKED = RASBASE+175;
  {$EXTERNALSYM ERROR_BLOCKED}
  //The call was blocked by the remote computer,

  ERROR_DONOTDISTURB = RASBASE+176;
  {$EXTERNALSYM ERROR_DONOTDISTURB}
  //The call could not be connected because the remote computer has invoked the Do Not Disturb feature,

  ERROR_OUTOFORDER = RASBASE+177;
  {$EXTERNALSYM ERROR_OUTOFORDER}
  //The connection attempt failed because the modem (or other connecting device) on the remote computer is out of order,

  ERROR_UNABLE_TO_AUTHENTICATE_SERVER = RASBASE+178;
  {$EXTERNALSYM ERROR_UNABLE_TO_AUTHENTICATE_SERVER}
  //It was not possible to verify the identity of the server,

  ERROR_SMART_CARD_REQUIRED = RASBASE+179;
  {$EXTERNALSYM ERROR_SMART_CARD_REQUIRED}
  //To dial out using this connection you must use a smart card,

  ERROR_INVALID_FUNCTION_FOR_ENTRY = RASBASE+180;
  {$EXTERNALSYM ERROR_INVALID_FUNCTION_FOR_ENTRY}
  //An attempted function is not valid for this connection,

  ERROR_CERT_FOR_ENCRYPTION_NOT_FOUND = RASBASE+181;
  {$EXTERNALSYM ERROR_CERT_FOR_ENCRYPTION_NOT_FOUND}
  //The encryption attempt failed because no valid certificate was found,

  ERROR_SHARING_RRAS_CONFLICT = RASBASE+182;
  {$EXTERNALSYM ERROR_SHARING_RRAS_CONFLICT}
  // Connection Sharing (NAT) is currently installed as a routing protocol, and must be
  // removed before enabling Internet Connection Sharing,

  ERROR_SHARING_NO_PRIVATE_LAN = RASBASE+183;
  {$EXTERNALSYM ERROR_SHARING_NO_PRIVATE_LAN}
  // Internet Connection Sharing cannot be enabled. The LAN connection selected
  // as the private network is either not present, or is disconnected
  // from the network. Please ensure that the LAN adapter is connected
  // before enabling Internet Connection Sharing,

  ERROR_NO_DIFF_USER_AT_LOGON = RASBASE+184;
  {$EXTERNALSYM ERROR_NO_DIFF_USER_AT_LOGON}
  // You cannot dial using this connection at logon time, because it is
  // configured to use a user name different than the one on the smart
  // card. If you want to use it at logon time, you must configure it to
  // use the user name on the smart card,

  ERROR_NO_REG_CERT_AT_LOGON = RASBASE+185;
  {$EXTERNALSYM ERROR_NO_REG_CERT_AT_LOGON}
  // You cannot dial using this connection at logon time, because it is
  // not configured to use a smart card. If you want to use it at logon
  // time, you must edit the properties of this connection so that it uses
  // a smart card,

  ERROR_OAKLEY_NO_CERT = RASBASE+186;
  {$EXTERNALSYM ERROR_OAKLEY_NO_CERT}
  //The L2TP connection attempt failed because there is no valid machine certificate on your computer for security authentication,

  ERROR_OAKLEY_AUTH_FAIL = RASBASE+187;
  {$EXTERNALSYM ERROR_OAKLEY_AUTH_FAIL}
  //The L2TP connection attempt failed because the security layer could not authenticate the remote computer,

  ERROR_OAKLEY_ATTRIB_FAIL = RASBASE+188;
  {$EXTERNALSYM ERROR_OAKLEY_ATTRIB_FAIL}
  //The L2TP connection attempt failed because the security layer could not negotiate compatible parameters with the remote computer,

  ERROR_OAKLEY_GENERAL_PROCESSING = RASBASE+189;
  {$EXTERNALSYM ERROR_OAKLEY_GENERAL_PROCESSING}
  //The L2TP connection attempt failed because the security layer encountered a processing error during initial negotiations with the remote computer,

  ERROR_OAKLEY_NO_PEER_CERT = RASBASE+190;
  {$EXTERNALSYM ERROR_OAKLEY_NO_PEER_CERT}
  //The L2TP connection attempt failed because certificate validation on the remote computer failed,

  ERROR_OAKLEY_NO_POLICY = RASBASE+191;
  {$EXTERNALSYM ERROR_OAKLEY_NO_POLICY}
  //The L2TP connection attempt failed because security policy for the connection was not found,

  ERROR_OAKLEY_TIMED_OUT = RASBASE+192;
  {$EXTERNALSYM ERROR_OAKLEY_TIMED_OUT}
  //The L2TP connection attempt failed because security negotiation timed out,

  ERROR_OAKLEY_ERROR = RASBASE+193;
  {$EXTERNALSYM ERROR_OAKLEY_ERROR}
  //The L2TP connection attempt failed because an error occurred while negotiating security,

  ERROR_UNKNOWN_FRAMED_PROTOCOL = RASBASE+194;
  {$EXTERNALSYM ERROR_UNKNOWN_FRAMED_PROTOCOL}
  //The Framed Protocol RADIUS attribute for this user is not PPP,

  ERROR_WRONG_TUNNEL_TYPE = RASBASE+195;
  {$EXTERNALSYM ERROR_WRONG_TUNNEL_TYPE}
  //The Tunnel Type RADIUS attribute for this user is not correct,

  ERROR_UNKNOWN_SERVICE_TYPE = RASBASE+196;
  {$EXTERNALSYM ERROR_UNKNOWN_SERVICE_TYPE}
  //The Service Type RADIUS attribute for this user is neither Framed nor Callback Framed,

  ERROR_CONNECTING_DEVICE_NOT_FOUND = RASBASE+197;
  {$EXTERNALSYM ERROR_CONNECTING_DEVICE_NOT_FOUND}
  //The connection failed because the modem (or other connecting device) was not found. Please make sure that the modem or other connecting device is installed,

  ERROR_NO_EAPTLS_CERTIFICATE = RASBASE+198;
  {$EXTERNALSYM ERROR_NO_EAPTLS_CERTIFICATE}
  //A certificate could not be found that can be used with this Extensible Authentication Protocol,

  RASBASEEND = RASBASE+198;
  {$EXTERNALSYM RASBASEEND}

implementation

end.
