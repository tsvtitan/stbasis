{ ************************************************************ }
{ * Demo of the IdSMTPServer                                 * }
{ * Author: Andrew Neillans                                  * }
{ * E-Mail: andy@neillans.co.uk                              * }
{ * Date: 17th April 2001                                    * }
{ * Version: 0.1                                             * }
{ * IdSMTPServer version required: 4.9                       * }
{ * NOTE: If you have any problems with IdMessage, use the   * }
{ * copy in the backup directory. Some changes have been     * }
{ * made to ensure (hopefully) reliability.                  * }
{ ************************************************************ }
{ * Known problems:                                          * }
{ *  . appears a the end of the body                         * }
{ *  subject not loaded into the AMessage correctly          * }
{ * Features:                                                * }
{ *  In the DATA event: AMessage.SaveToText :)               * }
{ ************************************************************ }

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, IdSMTPServer, StdCtrls, IdMessage;

type
  TForm1 = class(TForm)
    IdSMTPServer1: TIdSMTPServer;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ToLabel: TLabel;
    FromLabel: TLabel;
    SubjectLabel: TLabel;
    procedure IdSMTPServer1ADDRESSError(AThread: TIdPeerThread;
      const CmdStr: String);
    procedure IdSMTPServer1CommandAUTH(AThread: TIdPeerThread;
      const CmdStr: String);
    procedure IdSMTPServer1CommandCheckUser(AThread: TIdPeerThread;
      const Username, Password: String; var Accepted: Boolean);
    procedure IdSMTPServer1CommandDATA(AThread: TIdPeerThread;
      AMessage: TIdMessage);
    procedure IdSMTPServer1CommandRCPT(AThread: TIdPeerThread;
      var EMailAddress: String; var Accepted, ToForward: Boolean);
    procedure IdSMTPServer1CommandMAIL(AThread: TIdPeerThread;
      var EMailAddress: String; var Accepted, ToForward: Boolean);
    procedure IdSMTPServer1CommandQUIT(AThread: TIdPeerThread);
    procedure IdSMTPServer1CommandX(AThread: TIdPeerThread;
      const CmdStr: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.IdSMTPServer1ADDRESSError(AThread: TIdPeerThread;
  const CmdStr: String);
begin
 // Send the Address Error String - this *WILL* be coded in eventually.
 AThread.Connection.Writeln('500 Syntax Error in MAIL FROM or RCPT TO');
end;

procedure TForm1.IdSMTPServer1CommandAUTH(AThread: TIdPeerThread;
  const CmdStr: String);
begin
 // This is where you would process the AUTH command - for now, we send a error
 AThread.Connection.Writeln(IdSMTPServer1.Messages.ErrorReply);
end;

procedure TForm1.IdSMTPServer1CommandCheckUser(AThread: TIdPeerThread;
  const Username, Password: String; var Accepted: Boolean);
begin
 // This event allows you to 'login' a user - this is used internall in the
 // IdSMTPServer to validate users connecting using the AUTH.
 Accepted := False;
end;

procedure TForm1.IdSMTPServer1CommandDATA(AThread: TIdPeerThread;
  AMessage: TIdMessage);
begin
// This is the main event.
// The AMessage contains the completed TIdMessage.
// NOTE: Dont forget to add IdMessage to your USES clause!

ToLabel.Caption := AMessage.Recipients.EMailAddresses;
FromLabel.Caption := AMessage.From.Text;
SubjectLabel.Caption := AMessage.Subject;
Memo1.Lines := AMessage.Body;

// Implement your file system here :)
end;

procedure TForm1.IdSMTPServer1CommandRCPT(AThread: TIdPeerThread;
  var EMailAddress: String; var Accepted, ToForward: Boolean);
begin
 // This is required!
 // You check the EMAILADDRESS here to see if it is to be accepted / processed.
 // Set Accepted := True if its allowed
 // Set ToForward := True if its needing to be forwarded.
 Accepted := True;
end;

procedure TForm1.IdSMTPServer1CommandMAIL(AThread: TIdPeerThread;
  var EMailAddress: String; var Accepted, ToForward: Boolean);
begin
 // This is required!
 // You check the EMAILADDRESS here to see if it is to be accepted / processed.
 // Set Accepted := True if its allowed
 Accepted := True;
end;

procedure TForm1.IdSMTPServer1CommandQUIT(AThread: TIdPeerThread);
begin
// Process any logoff events here - e.g. clean temp files
end;

procedure TForm1.IdSMTPServer1CommandX(AThread: TIdPeerThread;
  const CmdStr: String);
begin
 // You can use this for debugging :)
 
end;

end.
