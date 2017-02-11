unit mapsMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient,
  IdDNSResolver;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    IdDNSResolver1: TIdDNSResolver;
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Memo2: TMemo;
    Edit2: TEdit;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses IdGlobal;

function ReverseIPAddress(IPAddress : String) : String;
var Part1, Part2, Part3, Part4 : String;
begin
  Part1 := Fetch(IPAddress,'.');
  Part2 := Fetch(IPAddress,'.');
  Part3 := Fetch(IPAddress,'.');
  Part4 := Fetch(IPAddress);
  Result := Part4+'.'+Part3+'.'+Part2+'.'+Part1;
end;

procedure TForm1.Button1Click(Sender: TObject);
var idx : Integer;
begin
  Memo1.Clear;
  IdDNSResolver1.Host := Edit2.Text;
  IdDNSResolver1.RequestedRecords := [cA];
  try
    {MAPS RBL - Real Time Blackhole list}
    IdDNSResolver1.ResolveDomain(ReverseIPAddress(Edit1.Text)+'.rbl.maps.vix.com');
    for idx := 0 to IdDNSResolver1.Answers.Count - 1 do
    begin
      if IdDNSResolver1.DNSAnList[idx].AType = cA then
      begin
        Memo1.Lines.Add(IdDNSResolver1.DNSAnList[idx].RData.DomainName+' is in the MAPS RBL');
      end;
    end;
    {Now get a helpful bounce message}
    IdDNSResolver1.RequestedRecords := [cTXT];
    try
      IdDNSResolver1.ResolveDomain(ReverseIPAddress(Edit1.Text)+'.rbl.maps.vix.com');
      for idx := 0 to IdDNSResolver1.DNSAnList.Count - 1 do
      begin
        if IdDNSResolver1.DNSAnList[idx].AType = cTXT then
        begin
          Memo1.Lines.Add('Bounce Message: '+IdDNSResolver1.DNSAnList[idx].StarData);
        end;
      end;
    finally
    end;
  except
    Memo1.Lines.Add('Not in MAPS RBL');
  end;

  IdDNSResolver1.RequestedRecords := [cA];
  try
    {MAPS DUL - Dial-Up User List}
    IdDNSResolver1.ResolveDomain(ReverseIPAddress(Edit1.Text)+'.dul.maps.vix.com');
    for idx := 0 to IdDNSResolver1.Answers.Count - 1 do
    begin
      if IdDNSResolver1.DNSAnList[idx].AType = cA then
      begin
        Memo1.Lines.Add(IdDNSResolver1.DNSAnList[idx].RData.DomainName+' is in the MAPS DUL');
      end;
    end;
    {Now get a helpful bounce message}
    IdDNSResolver1.RequestedRecords := [cTXT];
    try
      IdDNSResolver1.ResolveDomain(ReverseIPAddress(Edit1.Text)+'.dul.maps.vix.com');
      for idx := 0 to IdDNSResolver1.Answers.Count - 1 do
      begin
        if IdDNSResolver1.DNSAnList[idx].AType = cTXT then
        begin
          Memo1.Lines.Add('Bounce Message: '+IdDNSResolver1.DNSAnList[idx].StarData);
        end;
      end;
    finally
    end;
  except
    Memo1.Lines.Add('Not in MAPS DUL');
  end;
  IdDNSResolver1.RequestedRecords := [cA];
  try
    {MAPS RSS - Relay Spam Stopper}
    IdDNSResolver1.ResolveDomain(Edit1.Text +'.relays.mail-abuse.org');
    for idx := 0 to IdDNSResolver1.Answers.Count - 1 do
    begin
      if IdDNSResolver1.DNSAnList[idx].AType = cA then
      begin
        Memo1.Lines.Add(IdDNSResolver1.DNSAnList[idx].RData.DomainName+' is in the MAPS RRS');
      end;
    end;
    IdDNSResolver1.RequestedRecords := [cTXT];
    try
      IdDNSResolver1.ResolveDomain(Edit1.Text+'.relays.mail-abuse.org');
      for idx := 0 to IdDNSResolver1.Answers.Count - 1 do
      begin
        if IdDNSResolver1.DNSAnList[idx].AType = cTXT then
        begin
          Memo1.Lines.Add(IdDNSResolver1.DNSAnList[idx].StarData+' is in the MAPS RBL');
        end;
      end;
    finally
    end;
  except
    Memo1.Lines.Add('Not in MAPS RSS');
  end;
end;

end.
