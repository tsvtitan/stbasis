unit mainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdComponent, IdTCPServer, IdFingerServer, IdBaseComponent;

type
  TForm1 = class(TForm)
    IdFingerServer1: TIdFingerServer;
    procedure IdFingerServer1CommandFinger(AThread: TIdPeerThread;
      const AUserName: String);
    procedure IdFingerServer1CommandVerboseFinger(AThread: TIdPeerThread;
      const AUserName: String);
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

uses
  IdGlobal;

{These are our sample users}

Const SampleUsers : Array [1..3] of String =
  ('TIDFINGER', 'TIDQUOTD', 'TIDTIME');

procedure TForm1.IdFingerServer1CommandFinger(AThread: TIdPeerThread;
  const AUserName: String);

begin
  {general querry - just list users}
  if AUserName = '' then
  begin
    AThread.Connection.WriteLn('TIdFinger');
    AThread.Connection.WriteLn('TIdQuotD');
    AThread.Connection.WriteLn('TIdTime');
  end //if AUserName = '' then
  else
  begin {Just Provide breif information}
    Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
      1 : //TIdFinger
          begin
            AThread.Connection.WriteLn('TIdFinger implements RFC 1288');
          end; {1}
      2 : //TIdQuotD
          begin
            AThread.Connection.WriteLn('TIdQuotD implements RFC 865');
          end; {2}
      3 : //TIdTime
          begin
            AThread.Connection.WriteLn('TIdTime implements RFC 868');
          end; {3}
      else
      begin  {This user is not on our system}
        AThread.Connection.WriteLn( AUserName + '?' );
      end; //else..case
    end; //Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
  end; //if AUserName = '' then
end;

procedure TForm1.IdFingerServer1CommandVerboseFinger(
  AThread: TIdPeerThread; const AUserName: String);
begin
  AThread.Connection.WriteLn('Verbose query');
   {general querry - just list users}
  if AUserName = '' then
  begin
    AThread.Connection.WriteLn('TIdFinger');
    AThread.Connection.WriteLn('TIdQuotD');
    AThread.Connection.WriteLn('TIdTime');
  end //if AUserName = '' then
  else
  begin {Just Provide breif information}
    Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
      1 : //TIdFinger
          begin
            AThread.Connection.WriteLn('TIdFinger implements RFC 1288');
            AThread.Connection.WriteLn('');
            AThread.Connection.WriteLn('Finger is used to provide information');
            AThread.Connection.WriteLn('such as if the user is logged into a');
            AThread.Connection.WriteLn('mainframe, when they last checked their');
            AThread.Connection.WriteLn('E-Mail and received new E-Mail.  It');
            AThread.Connection.WriteLn('can also provide other information such');
            AThread.Connection.WriteLn('what a user puts into a plan file.');
          end; {1}
      2 : //TIdQuotD
          begin
            AThread.Connection.WriteLn('TIdQuotD implements RFC 865');
            AThread.Connection.WriteLn('');
            AThread.Connection.WriteLn('Quote of the Day is used for testing');
            AThread.Connection.WriteLn('TCP development by providing a quote.');
            AThread.Connection.WriteLn('to the client.  It is sometimes used');
            AThread.Connection.WriteLn('brief information for anybody.');
          end; {2}
      3 : //TIdTime
          begin
            AThread.Connection.WriteLn('TIdTime implements RFC 868');
            AThread.Connection.WriteLn('');
            AThread.Connection.WriteLn('Time is used for synchronizing clocks');
            AThread.Connection.WriteLn('on a local area network.  For acurate');
            AThread.Connection.WriteLn('synchronization, use SNTP (Simple');
            AThread.Connection.WriteLn('Network Time Protocol).');

          end; {3}
      else
      begin  {This user is not on our system}
        AThread.Connection.WriteLn( AUserName + '?' );
      end; //else..case
    end; //Case Succ ( PosInStrArray ( Uppercase ( AUserName ), SampleUsers ) ) of
  end; //if AUserName = '' then
end;

end.
