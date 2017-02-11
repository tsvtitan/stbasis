program daemon;
{
  $Id: daemon.pp,v 1.1 2000/07/13 06:30:19 michael Exp $
  Filename..: daemon.pas
  Programmer: Ken J. Wright / Anthony J. Caduto
  Date......: 03/21/2000

  Purpose - Program to demonstrate construction of a Linux daemon.

  Usage:
    1) Compile this program.
    2) Run it. You will be immediately returned to a command prompt.
    3) Issue the command: ps ax|grep daemon. This will show you the process
       id of the program "daemon" that you just ran.
    4) Issue the command: tail -f daemon.log. This let's you watch the log file
       being filled with the message in the code below. Press Ctrl/c to break
       out of the tail command.
    5) Issue the command: kill -HUP pid. pid is the process number you saw with
       the ps command above. You will see that a new log file has been created.
    6) Issue the command: kill -TERM pid. This will stop the daemon. Issuing the
       ps command above, you will see that the daemon is no longer running.

-------------------------------<< REVISIONS >>--------------------------------
  Ver  |    Date    | Prog | Decription
-------+------------+------+--------------------------------------------------
  1.00 | 03/21/2000 | kjw  | Initial release.
  1.01 | 03/21/2000 | kjw  | Forgot to close input, output, & stderr.
  1.02 | 03/15/2001 | AJC  | Ported to Kylix Object Pascal by Anthony J. Caduto
------------------------------------------------------------------------------
If you find any flaws or make improvement to this demo please email me the revised file so I can include
the changes to this demo.  I will give full credit to whoever makes improvements
My email address is tcaduto@amsoftwaredesign.com}

{$APPTYPE CONSOLE}

uses
  Libc in '../../kylix/source/rtl/linux/Libc.pas',
  SysUtils in '../../kylix/source/rtl/sys/SysUtils.pas',
  IndyTCPServer in 'IndyTCPServer.pas';

Var
   { vars for daemonizing }
   bHup,
   bTerm : boolean;
   fLog : Text;
   logname : string;
   aOld,
   aTerm,
   aHup : PSigAction;   //was pSigActionRec
   ps1  : psigset;
   sSet : cardinal;
   pid : longint;
   secs : longint;
   indyserver:TIndyTCPServer;


{ handle SIGHUP & SIGTERM }
procedure DoSig(sig : longint);cdecl;
begin
   case sig of
      SIGHUP : bHup := true;
      SIGTERM : bTerm := true;
   end;
end;

{ open the log file }
Procedure NewLog;
Begin
   Assignfile(fLog,logname);
   Rewrite(fLog);
   Writeln(flog,'Indy TCP DaemonLog created at '+ formatdatetime('dd/mm/yyyy',now));
   Closefile(fLog);
End;

begin
    logname := 'indyTCPdaemon.log';
    secs := 10;

    { set global daemon booleans }
    bHup := true; { to open log file }
    bTerm := false;

    { block all signals except -HUP & -TERM }
    sSet := $ffffbffe;
    ps1 := @sSet;
    sigprocmask(sig_block,ps1,nil);

   { setup the signal handlers }
   new(aOld);
   new(aHup);
   new(aTerm);
   aTerm^.__sigaction_handler := @DoSig;
   aTerm^.sa_flags := 0;
   aTerm^.sa_restorer := nil;
   aHup^.__sigaction_handler:= @DoSig;
   aHup^.sa_flags := 0;
   aHup^.sa_restorer := nil;
   SigAction(SIGTERM,aTerm,aOld);
   SigAction(SIGHUP,aHup,aOld);

   { daemonize }
   pid := Fork;
   Case pid of
      0 : Begin { we are in the child }
             Close(input);  { close standard in }
             AssignFile(output,'/dev/null');
             ReWrite(output);
             AssignFile(ErrOutPut,'/dev/null');
             ReWrite(ErrOutPut);
          End;
      -1 : secs := 0;     { forking error, so run as non-daemon }
      Else Halt;          { successful fork, so parent dies }

   End;  //case
   { Create any objects before you go into the processing loop}
    indyserver:=TIndyTCPServer.Create;
   { begin processing loop }
   Repeat
      If bHup Then Begin
         NewLog;
         bHup := false;
      End;
      {----------------------}
      { Do your daemon stuff }

       Append(flog);
       Writeln(flog,'Indy TCP Server daemon activated at '+pchar(formatdatetime('mm/dd/yyy hh:mm:ss',now)));
        Close(fLog);
      { the following output goes to the bit bucket }
        Writeln('Indy TCP Server daemon activated at '+pchar(formatdatetime('mm/dd/yyy hh:mm:ss',now)));

      {----------------------}
      If (bTerm) or (indyserver.IndyTCP.Active = false) Then
         begin
          indyserver.Free;
          BREAK
         end

             Else
                 { wait a while }
                 __sleep(secs*1000);


   Until bTerm;

end.
