program whois;
{$APPTYPE CONSOLE}

uses
  IdWhois,
  SysUtils;

begin
  if ParamCount = 0 then begin
    WriteLn('');
    WriteLn('whois');
    WriteLn('  Usage:');
    WriteLn('  whois <domain to look up> <whois server>');
    WriteLn('');
    WriteLn('  <whois server> is optional and defaults to whois.internic.net');
    WriteLn('');
  end else begin
    {TODO Extract alternate servers from internic response}
    with TIdWhois.Create(nil) do try
      if ParamCount > 1 then begin
        Host := Trim(ParamStr(2));
      end else begin
        Host := 'whois.internic.net';
      end;
      System.WriteLn(WhoIs(Trim(ParamStr(1))));
    finally free; end;
  end;
end.
