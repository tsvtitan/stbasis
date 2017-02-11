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

{****************************************************************
*
*  f r m u C o m m D i a g
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Description:  This unit provides all the necessary functions
*                to ping a remote server, test specific services
*                via TCP/IP and test a connection to a server
*                using NetBEUI and SPX.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
unit zluCommDiag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Winsock, PSock, Math;

type
  TIPAddress = LongInt;                // IP address
  TIPMask    = LongInt;                // IP mask
  TIPStatus  = LongInt;                // IP status
  HINSTANCE  = Longint;                // instance handle
  HANDLE     = Cardinal;               // handle

  TIPOptions = packed record           // IP options structure
    TTL         : Byte;
    TOS         : Byte;
    Flags       : Byte;
    OptionsSize : Byte;
    OptionsData : PChar;
  end;
  ptrIPOptions = ^TIPOptions;

  TICMPEchoReply = packed record       // ICMP reply structure
    Address      : TIPAddress;
    Status       : DWORD;
    RTT          : DWORD;
    DataSize     : WORD;
    Reserved     : WORD;
    Data         : Pointer;
    Options      : TIPOptions;
  end;
  ptrICMPEchoReply = ^TICMPEchoReply;

  // SPX socket
  TSockAddrIPX = packed record
	  sa_family: u_short;
	  sa_netnum: array[0..3] of Char;
	  sa_nodenum: array[0..5] of Char;
	  sa_socket: u_short;
  end;
	pSockAddrIPX = ^TSockAddrIPX;

  // ICMP dll function
  TICMPCreateFile = function : THandle; stdcall;

  // ICMP dll function
  TICMPCloseHandle = function(ICMPHandle : Thandle) : Boolean; stdcall;

  // ICMP dll function
  TICMPSendEcho = function (ICMPHandle     : THandle;
                            DestAddr       : TIPAddress;
                            RequestData    : Pointer;
                            RequestSize    : WORD;
                            RequestOptions : ptrIPOptions;
                            ReplyBuffer    : Pointer;
                            ReplySize      : DWORD;
                            Timeout        : DWORD) : DWORD; stdcall;


  // socket exception
  TSVCException = class(Exception);

  // Novell Netware function types
  TNWCallsInit        = function(Reserved1, Reserved2 : Pointer) : Cardinal;  StdCall;
  TNWCLXInit          = function(Reserved1, Reserved2 : Pointer) : Cardinal;  StdCall;
  TNWCCOpenConnByName = function(StartConnHandle : Cardinal; Name : PChar; NameFormat, OpenState, TranType : Cardinal; var pConnHandle : Cardinal) : Cardinal;  StdCall;
  TNWCCCloseConn      = function(ConnHandle : Cardinal) : Cardinal;  StdCall;

  {****************************************************************
  *
  *  T i b c P i n g
  *
  ****************************************************************
  *  Author: The Client Server Factory Inc.
  *  Date:   March 1, 1999
  *
  *  Description:  This class implements the interface to
  *                perform packet internet groping on a remote
  *                server using TCP/IP using a 32 byte packet.
  *
  *****************************************************************
  * Revisions:
  *
  *****************************************************************}
  TibcPing = class
  private
    { private declarations }
    FAddress                : String;
    FAddrResolved           : Boolean;
    FHostIP                 : String;
    FHostName               : String;
    FIPAddress              : LongInt;
    FLastError              : DWORD;
//    FPackets                : Integer;
    FReply                  : TICMPEchoReply;
    FSize                   : Integer;
    FTimeout                : Integer;
    FTTL                    : Integer;
    hICMP                   : THandle;
    hICMPdll                : HModule;
    function GetAddr        : String;
    function GetHostIP      : String;
    function GetHostName    : String;
    function GetLastErr     : Integer;
    function GetResult      : String;
    function GetRTTReply    : Integer;
    function GetSize        : Integer;
    function GetTimeOut     : Integer;
    function GetTTL         : Integer;
    function GetTTLReply    : Integer;
    procedure SetAddr(Host : String);
    procedure SetHostName(Host : String);
    procedure SetSize(PacketSize : Integer);
    procedure SetTimeOut(TOut : Integer);
    procedure SetTTL(LiveTime : Integer);
  public
    { public declarations }
    function ResolveHost   : Boolean;
    function Ping          : Boolean;
    property HostIP        : String read GetHostIP;
    property LastError     : Integer read GetLastErr;
    property RTTReply      : Integer read GetRTTReply;
    property TTLReply      : Integer read GetTTLReply;
    property VerboseResult : String read GetResult;
  published
    { published declarations }
    property Host      : String read GetAddr write SetAddr;
    property HostName  : String read GetHostName write SetHostName;
    property Size      : Integer read GetSize write SetSize;
    property TimeOut   : Integer read GetTimeout write SetTimeout;
    property TTL       : Integer read GetTTL write SetTTL;
  end;

  {****************************************************************
  *
  *  T i b c S o c k e t
  *
  ****************************************************************
  *  Author: The Client Server Factory Inc.
  *  Date:   March 1, 1999
  *
  *  Description:  This class implements the interface to test
  *                a port/service on a specified remote
  *                server using TCP/IP.
  *
  *****************************************************************
  * Revisions:
  *
  *****************************************************************}
  TibcSocket = class(TPowerSock)
  private
    { private declarations }
    FPortName               : String;
    function GetPortName    : String;
    function GetSockDesc    : String;
    function GetSockVersion : String;
  public
    { public declarations }
    property PortName       : String read GetPortName;
    property WSDescription  : String read GetSockDesc;
    property WSVersion      : String read GetSockVersion;
  published
    { published declarations }
  end;

  {****************************************************************
  *
  *  T i b c S P X
  *
  ****************************************************************
  *  Author: The Client Server Factory Inc.
  *  Date:   March 1, 1999
  *
  *  Description:  This class implements the interface to
  *                test an unlicensed connection to a Netware
  *                server using IPX/SPX.  The client machine
  *                must have the proper Netware client installed.
  *
  *****************************************************************
  * Revisions:
  *
  *****************************************************************}
  TibcSPX = class
  private
    { private declarations }
    FServer : String;
    function GetServer : String;
    procedure SetServer(Server : String);
  public
    { public declarations }
    procedure TestSPX(var sResult : String);
  published
    { published declarations }
    property ServerName : String read GetServer write SetServer;

  end;

  {****************************************************************
  *
  *  T i b c P i p e s
  *
  ****************************************************************
  *  Author: The Client Server Factory Inc.
  *  Date:   March 1, 1999
  *
  *  Description:  This class implements the interface to
  *                test a connection to an NT server using a named
  *                pipe.
  *
  *****************************************************************
  * Revisions:
  *
  *****************************************************************}
  TibcPipes = class
  private
    FDefault : String;  // CSDiagDefault
//    FItem    : String;
//    FName    : String;
    FPath    : String;
    FPipe    : String;
    FSA      : SECURITY_ATTRIBUTES;
    FServer  : String;
    FTotal   : Integer;
    hPipe    : HANDLE;
    function GetPath : String;
    function GetServer : String;
    function GetTries : Integer;
    procedure SetPath(Path : String);
    procedure SetServer(Server : String);
    procedure SetTries(Tries : Integer);
  public
    function TestPipe(var sResult : String; SilentTest : Boolean) : Boolean;
  published
    property Path   : String read GetPath write SetPath;
    property Server : String read GetServer write SetServer;
    property Tries  : Integer read GetTries write SetTries;
  end;

const
  CRLF          = #13#10;              // carriage return linefeed pair
  ICMPdll       = 'icmp.dll';          // name of ICMP dll
  CALWIN32      = 'calwin32.dll';
  CLXWIN32      = 'clxwin32.dll';
	NSPROTO_IPX   = 1000;
	NSPROTO_SPX   = 1256;
	NSPROTO_SPXII = 1257;
  SOCK_DIAG_SPX = $0456;
  NWCC_NAME_FORMAT_BIND = $0002;
  NWCC_OPEN_LICENSED    = $0001;
  NWCC_TRAN_TYPE_WILD  = $00008000;

  // IP status codes returned to transports and
  // user IO controls.
  IP_SUCCESS                = 0;
  IP_BASE                   = 11000;
  IP_BUFFER_TOO_SMALL       = IP_BASE + $1;
  IP_DEST_NET_UNREACHABLE   = IP_BASE + $2;
  IP_DEST_HOST_UNREACHABLE  = IP_BASE + $3;
  IP_DEST_PROT_UNREACHABLE  = IP_BASE + $4;
  IP_DEST_PORT_UNREACHABLE  = IP_BASE + $5;
  IP_NO_RESOURCES           = IP_BASE + $6;
  IP_BAD_OPTION             = IP_BASE + $7;
  IP_ERR_HARDWARE           = IP_BASE + $8;
  IP_PACKET_TOO_LARGE       = IP_BASE + $9;
  IP_REQ_TIMEOUT            = IP_BASE + $A;
  IP_BAD_REQ                = IP_BASE + $B;
  IP_BAD_ROUTE              = IP_BASE + $C;
  IP_TTL_EXPIRED_TRANSIT    = IP_BASE + $D;
  IP_TTL_EXPIRED_REASSEM    = IP_BASE + $E;
  IP_PARAM_PROBLEM          = IP_BASE + $F;
  IP_SOURCE_QUENCH          = IP_BASE + $10;
  IP_OPTION_TOO_LARGE       = IP_BASE + $11;
  IP_BAD_DESTINATION        = IP_BASE + $12;

  // IP Ports
  IP_PORT_ECHO              = 7;
  IP_PORT_DISCARD           = 9;
  IP_PORT_SYSTAT            = 11;
  IP_PORT_DAYTIME           = 13;
  IP_PORT_NETSTAT           = 15;
  IP_PORT_FTP               = 21;
  IP_PORT_TELNET            = 23;
  IP_PORT_SMTP              = 25;
  IP_PORT_TIMESERVER        = 37;
  IP_PORT_NAMESERVER        = 42;
  IP_PORT_WHOIS             = 43;
  IP_PORT_MTP               = 57;
  IP_PORT_GDS_DB            = 3050;

  // status codes passed up on status indications.
  IP_ADDR_DELETED           = IP_BASE + $13;
  IP_SPEC_MTU_CHANGE        = IP_BASE + $14;
  IP_MTU_CHANGE             = IP_BASE + $15;
  GENERAL_FAILURE           = IP_BASE + $16;
  IP_PENDING                = IP_BASE + $FF;

  // IP header flags
  IP_FLAG_DF                = $2;

  // IP option types
  IP_OPT_EOL                = $0;           // end of list option
  IP_OPT_NOP                = $1;           // no-op
  IP_OPT_SECURITY           = $82;          // security option
  IP_OPT_LSRR               = $83;          // loose source route
  IP_OPT_SSRR               = $89;          // strict source route
  IP_OPT_RR                 = $07;          // record route
  IP_OPT_TS                 = $44;          // timestamp
  IP_OPT_SID                = $88;          // stread id
  MAX_OPT_SIZE              = $40;

implementation

{****************************************************************
*
*  G e t R e s u l t
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: String - contains a verbose error message
*
*  Description:  converts a numeric error code to a
*                verbose error message
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TibcPing.GetResult : String;
var
  lErr : String;
begin
  // determine which error code
  case FLastError of
    IP_SUCCESS               : lErr:='Success';
    IP_BUFFER_TOO_SMALL      : lErr:='Buffer too small';
    IP_DEST_NET_UNREACHABLE  : lErr:='Destination network unreachable';
    IP_DEST_HOST_UNREACHABLE : lErr:='Destination host unreachable';
    IP_DEST_PROT_UNREACHABLE : lErr:='Destination protocol unreachable';
    IP_DEST_PORT_UNREACHABLE : lErr:='Destination port unreachable';
    IP_NO_RESOURCES          : lErr:='No resources';
    IP_BAD_OPTION            : lErr:='Bad Option';
    IP_ERR_HARDWARE          : lErr:='Hardware error';
    IP_PACKET_TOO_LARGE      : lErr:='Packet too large';
    IP_REQ_TIMEOUT           : lErr:='Request timed out';
    IP_BAD_REQ               : lErr:='Bad request';
    IP_BAD_ROUTE             : lErr:='Bad route';
    IP_TTL_EXPIRED_TRANSIT   : lErr:='TTL expired in transit';
    IP_TTL_EXPIRED_REASSEM   : lErr:='TTL expired in reassembly';
    IP_PARAM_PROBLEM         : lErr:='Parameter problems';
    IP_SOURCE_QUENCH         : lErr:='Source quench';
    IP_OPTION_TOO_LARGE      : lErr:='Option too large';
    IP_BAD_DESTINATION       : lErr:='Bad destination';

    IP_ADDR_DELETED          : lErr:='Address deleted';
    IP_SPEC_MTU_CHANGE       : lErr:='Spec MTU change';
    IP_MTU_CHANGE            : lErr:='MTU change';
    GENERAL_FAILURE          : lErr:='General failure';
    IP_PENDING               : lErr:='Pending...';
  else
    lErr:='ICMP Error #' + IntToStr(FLastError);  // just in case
  end;

  // return error message
  Result:=lErr;
end;

// accessor to return hostname
function TibcPing.GetHostName : String;
var
  Host : String;
begin
  if FHostName <> '' then
    Host:=FHostName
  else
    Host:='';

  Result:=Host;
end;

// accessor to specify hostname
procedure TibcPing.SetHostName(Host : String);
begin
  FHostName:=Host;
end;

// accessor to get packet size
function TibcPing.GetSize : Integer;
begin
  Result:=FSize;
end;

// accessor to specify packet size
procedure TibcPing.SetSize(PacketSize : Integer);
begin
  FSize:=PacketSize;
end;

// accessor to get time to live
function TibcPing.GetTTL : Integer;
begin
  Result:=FTTL;
end;

// accessor to specify time to live
procedure TibcPing.SetTTL(LiveTime : Integer);
begin
  FTTL:=LiveTime;
end;

// accessor to get time out
function TibcPing.GetTimeOut : Integer;
begin
  Result:=FTimeOut;
end;

// accessor to specify time out
procedure TibcPing.SetTimeOut(TOut : Integer);
begin
  FTimeout:=TOut;
end;

// accessor to get host
function TibcPing.GetAddr : String;
begin
  Result:=FAddress;
end;

// accessor to specify host
procedure TibcPing.SetAddr(Host : String);
begin
  FAddress:=Host;
end;

// accessor to get time to live of reply
function TibcPing.GetTTLReply : Integer;
begin
  Result:=Integer(FReply.Options.TTL);
end;

// accessor to get round trip time of reply
function TibcPing.GetRTTReply : Integer;
begin
  Result:=LongInt(FReply.RTT);
end;

// accessor to get host IP
function TibcPing.GetHostIP : String;
begin
  Result:=FHostIP;
end;

// accessor to get last error code
function TibcPing.GetLastErr : Integer;
begin
  Result:=FLastError;
end;

{****************************************************************
*
*  R e s o l v e H o s t
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: Boolean - inidicates whether the name resolution of
*                    the host was successful.
*
*  Description:  Converts a hostname to an IP address.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TibcPing.ResolveHost : Boolean;
var
  WSAData : TWSAData;                  // Winsock data
  ptrHE   : PHostEnt;                  // pointer to HostEnt structure

begin
  result := false;
  // initialize winsock
  if WSAStartup($101, WSAData) <> 0 then
    raise TSVCException.Create('Can not initialize winsock.');

  // set hostname
  FIPAddress:=inet_addr(PChar(FAddress));

  // try to resolve hostname to ip address
  if FIPAddress <> LongInt(INADDR_NONE) then
    FHostName:=FAddress                // if no resolution is required
  else
  begin                                // otherwise, get host by name
    ptrHE:=GetHostByName(PChar(FAddress));
    if ptrHE = Nil then                // if the structure isn't filled
    begin
      FLastError:=GetLastError;        // get error code
      FAddrResolved:=False;            // set resolution flag to false
      Result:=FAddrResolved;
      Exit;
    end;

    // set IP address, hostname and resolution flag True
    FIPAddress:=LongInt(PLongInt(ptrHE^.h_addr_list^)^);
    FHostName:=ptrHE.h_name;
    FAddrResolved:=True;
    Result:=FAddrResolved;
  end;

  // set host IP
  FHostIP:=StrPas(inet_ntoa(TInAddr(FIPAddress)));
end;

{****************************************************************
*
*  P i n g
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: Boolean - inidicates whether the ping operation
*                    was successful.
*
*  Description:
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TibcPing.Ping : Boolean;
var
  WSAData         : TWSAData;          // winsock data
//  ptrHE           : PHostEnt;          // pointer to HostEnt structure
  BufferSize      : Integer;           // size of buffer
  pReqData        : Pointer;           // pointer to request data
  PData           : Pointer;           // pointer to data
  pIPE            : ptrICMPEchoReply;  // pointer to ICMP reply
  IPOpt           : TIPOptions;        // IP options
  Msg             : String;            // dummy date
//  iResult         : Integer;           // result
  ICMPCreateFile  : TICMPCreateFile;   //
  ICMPCloseHandle : TICMPCloseHandle;
  ICMPSendEcho    : TICMPSendEcho;

begin
  Result:=False;

  // initialize winsock
  if WSAStartup($101, WSAData) <> 0 then
    raise TSVCException.Create('Can not initialize winsock.');

  // load ICMO dll
  hICMPdll:=LoadLibrary(ICMPdll);
  if hICMPdll = 0 then
    raise TSVCException.Create('Unable to register ' + ICMPdll);

  // ICMP library functions
  @ICMPCreateFile:=GetProcAddress(hICMPdll, 'IcmpCreateFile');
  @ICMPCloseHandle:=GetProcAddress(hICMPdll, 'IcmpCloseHandle');
  @ICMPSendEcho:=GetProcAddress(hICMPdll, 'IcmpSendEcho');

  // ensure addresses where returned
  if (@ICMPCreateFile = Nil) or
     (@ICMPCloseHandle = Nil) or
     (@ICMPSendEcho = Nil) then
       raise TSVCException.Create('Error loading dll functions.');

  // create ICMP file
  hICMP:=IcmpCreateFile;
  if hICMP = INVALID_HANDLE_VALUE then
    raise TSVCException.Create('Unable to get ping handle.');

  // get buffer size
  BufferSize:=SizeOf(TICMPEchoReply) + FSize;
  GetMem(pReqData, FSize);
  GetMem(pData, FSize);
  GetMem(pIPE, BufferSize);

  try
    // Initialize request data buffer
    FillChar(pReqData^, FSize, $20);
    Msg:=('SevenOfNine');
    Move(Msg[1], pReqData^, Min(FSize, Length(Msg)));

    // initialize ICMP reply data
    pIPE^.Data:=pData;
    FillChar(pIPE^, SizeOf(pIPE^), 0);

    // set IP options
    FillChar(IPOpt, SizeOf(IPOpt), 0);
    IPOpt.TTL:=FTTL;

    // get result of ICMP echo
    IcmpSendEcho(hICMP, FIPAddress, pReqData, FSize,
                 @IPOpt, pIPE, BufferSize, FTimeOut);

    // get last error
    FLastError:=GetLastError;

    // get ICMP reply structure
    FReply:=pIPE^;
  finally
    // deallocate memory
    FreeMem(pIPE);
    FreeMem(pData);
    FreeMem(pReqData);
    FreeLibrary(hICMPdll);
  end;
end;

{****************************************************************
*
*  G e t P o r t N a  m e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  None
*
*  Return: String - name of well-known port
*
*  Description: Returns the name of a well-known port
*               based on the port service number
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TibcSocket.GetPortName : String;
var
  Service : String;
begin
  // list of well known ports

  // determine service name based on port number
  // these are well-known ports
  case Port of
    IP_PORT_ECHO       : Service:='ECHO';
    IP_PORT_DISCARD    : Service:='DISCARD';
    IP_PORT_SYSTAT     : Service:='SYSTAT';
    IP_PORT_DAYTIME    : Service:='DAYTIME';
    IP_PORT_NETSTAT    : Service:='NETSTAT';
    IP_PORT_FTP        : Service:='FTP';
    IP_PORT_TELNET     : Service:='TELNET';
    IP_PORT_SMTP       : Service:='SMTP';
    IP_PORT_TIMESERVER : Service:='TIMESERVER';
    IP_PORT_NAMESERVER : Service:='NAMESERVER';
    IP_PORT_WHOIS      : Service:='WHOIS';
    IP_PORT_MTP        : Service:='MTP';
    IP_PORT_GDS_DB     : Service:='GDS_DB';
  else
    Service:='';
  end;

  FPortName:=Service;
  Result:=FPortName;                   // return service name
end;

// accessor to get socket desciption
function TibcSocket.GetSockDesc : String;
var
  Desc : String;
begin
  if assigned(WSAInfo) then
  begin
    Desc:=WSAInfo.Strings[2];
  end
  else
    Desc:='N/A';

  Result:=Desc;
end;

// accessor to get socket version
function TibcSocket.GetSockVersion : String;
var
  Version : String;
begin
  if assigned(WSAInfo) then
  begin
    Version:=WSAInfo.Strings[1];
  end
  else
    Version:='N/A';

  Result:=Version;
end;

// accessor to get server name
function TibcPipes.GetServer : String;
begin
  Result := FServer;
end;

// accessor to get path name
function TibcPipes.GetPath : String;
begin
  Result := FPath;
end;

// accessor to get max number of attempts
function TibcPipes.GetTries : Integer;
begin
  Result := FTotal;
end;

// accessor to set the server name
procedure TibcPipes.SetServer(Server : String);
begin
  FServer := Server;
end;

// accessor to set path
procedure TibcPipes.SetPath(Path : String);
begin
  FPath := Path;
end;

// accessor to set max number of attempts
procedure TibcPipes.SetTries(Tries : Integer);
begin
  FTotal := Tries;
end;

{****************************************************************
*
*  T e s t P i p e
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  sResult - a string containing the result buffer
*
*  Return: Boolean - indicates whether test was successful
*
*  Description: Creates client end of a named pipe and attempts
*               to connect to the specified pipe.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
function TibcPipes.TestPipe(var sResult : String; SilentTest : Boolean) : Boolean;
var
  pPipe    : PChar;                    // pipe name
  iSuccess : Boolean;                  // success flag
  iNum     : Integer;                  // number of tries so far
//  iResult  : Integer;                  // error code
begin
  iSuccess := False;                 // initialize variables
  iNum := 0;
  try
//    iResult := 0;

    if Server = '' then
    begin                               // if no server name is supplied
      result := false;
      Exit;                            // then exit function
    end;

    // set pipe name
    FPipe := Format('\\%s%s', [FServer, FPath]);

    // set security attributes
    FDefault:='CSDiagDefault';
    FSA.nLength := SizeOf(FSA);
    FSA.lpSecurityDescriptor := Nil;
    FSA.bInheritHandle := FALSE;

    pPipe:=PChar(FPipe);

    if not SilentTest then
      sResult:=Format('Attempting to attach to %s using NetBEUI.%s%s', [Server, CRLF, CRLF]);

    // poll until a connection is established or the max number of tries have exceeded
    while (not iSuccess) and (iNum < FTotal) do
    begin
      hPipe := CreateFile(pPipe, GENERIC_READ or GENERIC_WRITE,
			  FILE_SHARE_READ or FILE_SHARE_WRITE, @FSA,
			  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

      if hPipe <> INVALID_HANDLE_VALUE then
      begin
        // if a connection is established then set success flag
        iSuccess:=True;
      end
      else
        // if no connection yet then increment the number of tries so far
        Inc(iNum);
    end;

//    iResult := GetLastError;

    // build result message in buffer
    if not SilentTest then
    begin
      if hPipe <> INVALID_HANDLE_VALUE then
      begin
        sResult:=Format('%sAttached successfully to %s using %s', [sResult, Server, CRLF]);
        sResult:=Format('%sthe following named pipe: %s', [sResult, CRLF]);
        sResult:=Format('%s   %s.%S%S', [sResult, FPipe, CRLF, CRLF]);
        sResult:=Format('%sNetBEUI Communication Test Passed!', [sResult]);
      end
      else
      begin
        sResult:=Format('%sAn error occurred attempting to connect to %s%s', [sResult, Server, CRLF]);
        sResult:=Format('%s   using the following named pipe:%s', [sResult, CRLF]);
        sResult:=Format('%s   %s%s%s', [SResult, FPipe, CRLF, CRLF]);
        sResult:=Format('%sNetBEUI Communication Test Failed!', [sResult]);
      end;
    end;
  finally
    if iSuccess then
      CloseHandle(hPipe);

    Result := iSuccess;
  end;
end;

{****************************************************************
*
*  T e s t S P X
*
****************************************************************
*  Author: The Client Server Factory Inc.
*  Date:   March 1, 1999
*
*  Input:  sResult - a string containing the result buffer
*
*  Return: Boolean - indicates whether test was successful
*
*  Description: Tests a SPX connection to the specified server.
*
*****************************************************************
* Revisions:
*
*****************************************************************}
procedure TibcSPX.TestSPX(var sResult : String);
var
  ccode         : Cardinal;            // return code
  ConnHandle    : Cardinal;            // connection handle
  lServer       : array [0..7] of char;// servername
  hInstCalWin   : THandle;
  hInstCLXWin   : THandle;
  lError        : Boolean;
  NWCallsInit   : TNWCallsInit;
  NWCLXInit     : TNWCLXInit;
  NWCCCloseConn : TNWCCCloseConn;
  NWCCOpenConnByName : TNWCCOpenConnByName;
begin
  lError := False;
  ccode := 0;
  hInstCalWin := 0;
//  hInstCLXWin := 0;
  try
    // load libraries
    hInstCalWin := LoadLibrary(CALWIN32);
    hInstCLXWin := LoadLibrary(CLXWIN32);

    // determine if libraries where successfully loaded
    if (hInstCalWin > 0) and (hInstCLXWIN > 0) then
    begin
      // get function pointer
      @NWCallsInit := GetProcAddress(hInstCalWin, PChar('NWCallsInit'));

      // if a valid function pointer is returned then call function
      if @NWCallsInit <> Nil then
        ccode := NWCallsInit(Nil, Nil)   // initialize
      else
        lError := True;                  // if no valid pointer then set error flag

      // if function call successful and no error
      if (ccode = 0) and (not lError) then
      begin                              // check return code
        // get function pointer
        @NWCLXInit := GetProcAddress(hInstCLXWin, PChar('NWCLXInit'));

        // if a valid function pointer is returned then call function
        if @NWCLXInit <> Nil then
          ccode := NWCLXInit(Nil, Nil)   // initialize
        else
          lError := True;                // if no valid pointer then set error flag

      end;

      // if either of the calls failed
      if (ccode <> 0) or (lError) then
      begin                              // show error message
        sResult:=Format('Could not initialize Netware client library.%s%s', [CRLF, CRLF]);
        sResult:=Format('%sSPX Communication Test Failed!', [sResult]);
      end
      else
      begin
        // get function pointer
        @NWCCOpenConnByName := GetProcAddress(hInstCLXWin, PChar('NWCCOpenConnByName'));

        StrCopy(lServer, PChar(FServer));

        sResult:=Format('Attempting to attach to %s using SPX.%s%s', [FServer, CRLF, CRLF]);

        // if a valid function pointer is returned then call function
        if @NWCCOpenConnByName <> Nil then
        begin
          // attempt to connect to the Netware server
          ccode := NWCCOpenConnByName(0, @lServer, NWCC_NAME_FORMAT_BIND,
            NWCC_OPEN_LICENSED, NWCC_TRAN_TYPE_WILD, ConnHandle);
        end
        else
          lError := True;              // if no valid pointer then set error flag

        // check return code
        if (ccode <> 0) or (lError) then
        begin                            // show error message if return code not 0
          sResult:=Format('%sAn error occurred attempting to connect to %s%s', [sResult, FServer, CRLF]);
          sResult:=Format('%s   using the SPX protocol.%s%s', [sResult, CRLF, CRLF]);
          sResult:=Format('%sSPX Communication Test Failed!', [sResult]);
        end
        else
        begin                            // show success message if return node is 0
          sResult:=Format('%sAttached successfully to %s%s', [sResult, FServer, CRLF]);
          sResult:=Format('%s   using the SPX protocol.%s%s', [sResult, CRLF, CRLF]);
          sResult:=Format('%sSPX Communication Test Passed!', [sResult]);
        end;
      end;
    end
    else
    begin
      // show error message is one of the dlls failed to load
      sResult:=Format('%sAn error occurred attempting to connect to %s%s', [sResult, FServer, CRLF]);
      sResult:=Format('%s   using the SPX protocol.%s%s', [sResult, CRLF, CRLF]);
      sResult:=Format('%sYou do not seem to have the proper NetWare client installed.%s%s', [sResult, CRLF, CRLF]);
      sResult:=Format('%sSPX Communication Test Failed!', [sResult]);
    end;
  finally
    // close connection if active
    hInstCLXWin := LoadLibrary(CLXWIN32);
    if hInstCLXWin > 0 then
    begin
      @NWCCCloseConn := GetProcAddress(hInstCLXWin, PChar('NWCCCloseConn'));
      if (@NWCCCloseConn <> Nil) and (ccode = 0) then
      begin                              // if a connection is open
        NWCCCloseConn(ConnHandle);       // then close the connection
      end;
    end;

    // free libraries
    FreeLibrary(hInstCalWin);
    FreeLibrary(hInstCLXWin);
  end;
end;

function TibcSPX.GetServer : String;
begin
  Result := FServer;
end;

procedure TibcSPX.SetServer(Server : String);
begin
  FServer:=Server;
end;

end.

