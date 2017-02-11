unit OTPDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DECUtil, Hash, ComCtrls, RFC2289, ExtCtrls;

type
  TOTPForm = class(TForm)
    Shape1: TShape;
    Label1: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    Label2: TLabel;
    ClientOTP: TOneTimePassword;
    ServerOTP: TOneTimePassword;
    Shape5: TShape;
    BtnLogin: TButton;
    Label6: TLabel;
    EPassword: TEdit;
    ClientInfo: TRichEdit;
    ServerInfo: TRichEdit;
    Shape2: TShape;
    ChannelInfo: TRichEdit;
    Label3: TLabel;
    CBPassphraseCheck: TCheckBox;
    Label4: TLabel;
    ESeed: TEdit;
    Label5: TLabel;
    EAccount: TEdit;
    CBExt: TCheckBox;
    Label8: TLabel;
    EIdent: TComboBox;
    CBHash: TComboBox;
    Label9: TLabel;
    Label7: TLabel;
    LAccount: TLabel;
    CBFormat: TCheckBox;
    Shape6: TShape;
    Shape7: TShape;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    BtnPassphrases: TButton;
    Label10: TLabel;
    procedure EPasswordChange(Sender: TObject);
    procedure DoLoginClick(Sender: TObject);
    procedure ServerParamsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBFormatClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnPassphrasesClick(Sender: TObject);
    procedure Label10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FParamsChanged: Boolean;
    
    function Send(const Reseiver, Command, Data: String): Boolean;

    procedure Protocol(M: TRichEdit; const Text: String);

    function ServerLogin(const Password: String): Boolean;
    function SendChallenge(const Challenge: String): Boolean;
    function ResponseChallenge(const InitialSeed: String): Boolean;
  public
    { Public-Deklarationen }
  end;

var
  OTPForm: TOTPForm;

implementation

{$R *.DFM}

uses ShellAPI, DECConst;

procedure TOTPForm.EPasswordChange(Sender: TObject);
begin
  BtnLogin.Enabled := Length(Trim(EPassword.Text)) >= 10;
end;

procedure TOTPForm.Protocol(M: TRichEdit; const Text: String);
begin
  if (M = ChannelInfo) and (M.Tag = 0) then
  begin
    M.Clear;
    M.Tag := 1;
  end;
  M.Lines.Add(Text);
  M.Perform(em_ScrollCaret, 0, 0);
end;

function TOTPForm.Send(const Reseiver, Command, Data: String): Boolean;
begin // that here is the Channel, a Networkconnection
  Result := False;

  Protocol(ChannelInfo, Reseiver+ ':'#9 + Command + #10 + Data);

  if Reseiver = 'Server' then
  begin
    if Command = 'Login'    then Result := ServerLogin(Data);
    if Command = 'Response' then Result := ResponseChallenge(Data);
  end;

  if Reseiver = 'Client' then
  begin
    if Command = 'Init' then Result := SendChallenge(Data);
  end;
end;

procedure TOTPForm.DoLoginClick(Sender: TObject);
var
  OneTimePassword: String;
  LastOTP: String;
begin
  LastOTP := ClientOTP.LastOTP;
// Compute the aktual OTP
  OneTimePassword := ClientOTP.Execute(EPassword.Text);
// Check the OTP with LastOTP, .Check(OTP) compute the next
// Passphrase and compare these with LastOTP
  if CBPassphraseCheck.Checked then
    if (LastOTP <> '') and not ClientOTP.Check(OneTimePassword) then
    begin
      Protocol(ClientInfo, 'LogIn:'#9'invalid Passwort');
      MessageDlg('Invalid Password, try again', mtError, [mbOk], 0);
      Exit;
    end;

  Protocol(ClientInfo, 'LogIn:'#10 + OneTimePassword);
  if Send('Server', 'Login', OneTimePassword) then
  begin
    ClientOTP.Next(OneTimePassword);
    Protocol(ClientInfo, 'LogIn:'#9'accepted');
  end else
    if LastOTP = ClientOTP.LastOTP then
    begin
      Protocol(ClientInfo, 'LogIn:'#9'NOT accepted');
      MessageDlg('Invalid Password, try again', mtError, [mbOk], 0);
    end;
end;

function TOTPForm.ServerLogin(const Password: String): Boolean;
begin
  Result := False;
// User will login on the Server, this code is on the Server
  Protocol(ServerInfo, 'LogIn:'#10 + Password);

  if (ServerOTP.Count <= 0) or FParamsChanged then
  begin
  // User is not registered, Sever sends a challenge
  // first we set our params
    ServerOTP.Hash := THashClass(CBHash.Items.Objects[CBHash.ItemIndex]);
    ServerOTP.Seed := ESeed.Text;
    ServerOTP.Count := StrToIntDef(EAccount.Text, 10);
    ServerOTP.Extended := CBExt.Checked;
    ServerOTP.Ident := EIdent.Text;

    Protocol(ServerInfo, #10'Init:'#10 + ServerOTP.Challenge);

    ESeed.Text := ServerOTP.Seed;
    CBExt.Checked := ServerOTP.Extended;
    EIdent.Text := ServerOTP.Ident;
    CBHash.ItemIndex := CBHash.Items.IndexOfObject(Pointer(ServerOTP.Hash));

    FParamsChanged := False;
// now we send Challenge to the Client
    Send('Client', 'Init', ServerOTP.Challenge);
  end else
  begin
    Result := ServerOTP.Check(Password);
    if Result then  // OTP is correct
    begin
      Protocol(ServerInfo, 'Login:'#9 + 'accepted');
      ServerOTP.Next(Password);
    end else
      Protocol(ServerInfo, 'Login:'#9 + 'NOT accepted');
  end;

  LAccount.Caption := IntToStr(ServerOTP.Count);
end;

function TOTPForm.SendChallenge(const Challenge: String): Boolean;
var
  InitialSeed: String;
begin
// Client received a Challenge from the Server, new Registration or reinitialization
  Result := True;

  Protocol(ClientInfo, #10'Init:'#10 + Challenge);

  ClientOTP.LastOTP := '';          // invalidate Last OTP
  ClientOTP.Challenge := Challenge; // set the new params
// compute the Last password from the "Table" count'te
  InitialSeed := ClientOTP.Execute(EPassword.Text);
  if Send('Server', 'Response', Initialseed) then
  begin
    ClientOTP.Next(InitialSeed);
    Protocol(ClientInfo, 'Resp:'#10 + InitialSeed);
// Client must new Login
    DoLoginClick(nil);
  end else
    Protocol(ClientInfo, 'Resp:'#10 + 'NOT accepted');
end;

function TOTPForm.ResponseChallenge(const InitialSeed: String): Boolean;
begin
// Sever accept the new User
  Protocol(ServerInfo, 'Resp:'#10 + InitialSeed);
  ServerOTP.Next(InitialSeed);
  Result := True;
end;

procedure TOTPForm.ServerParamsChange(Sender: TObject);
begin
  FParamsChanged := True;
end;

procedure TOTPForm.FormCreate(Sender: TObject);
begin
  Hash.HashNames(CBHash.Items);
  CBHash.ItemIndex := 0;
end;

procedure TOTPForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TOTPForm.CBFormatClick(Sender: TObject);
begin
  if CBFormat.Checked then ClientOTP.Format := fmtRFC1760
    else ClientOTP.Format := fmtHEX;
end;

procedure TOTPForm.BtnPassphrasesClick(Sender: TObject);
var
  I: Cardinal;
  S: String;
begin
// Build a Passwordlist
  Protocol(ChannelInfo, 'Build Passwordlist:');
  I := 0;
  S := ClientOTP.FirstPhrase(EPassword.Text);  // compute S0
  repeat
    Protocol(ChannelInfo, IntToStr(I)+#9+S);
    S := ClientOTP.NextPhrase(S, 0);           // compute S := S + 1
    Inc(I);
  until (I > ClientOTP.Count+2) or (I > 100);  // limited to display the first 100
end;

procedure TOTPForm.Label10MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  S: String;
begin
  Label10.Font.Color := clMaroon;
  S := ExtractFilePath(ParamStr(0));
  SetLength(S, Length(S) -1);
  S := ExtractFilePath(S) + 'Docus\';
  ShellExecute(Handle, nil, 'RFC2444.HTML', nil, PChar(S), sw_ShowNormal);
  ShellExecute(Handle, nil, 'RFC2289.HTML', nil, PChar(S), sw_ShowNormal);
  ShellExecute(Handle, nil, 'RFC1938.HTML', nil, PChar(S), sw_ShowNormal);
  ShellExecute(Handle, nil, 'RFC1760.HTML', nil, PChar(S), sw_ShowNormal);
end;

end.
