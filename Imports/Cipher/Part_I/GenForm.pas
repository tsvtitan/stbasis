unit GenForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, DECUtil, Hash, Cipher, RNG, RFC2289, ShellAPI,
  Sample, Cipher1;

type
  TGForm = class(TForm)
    MainMenu: TMainMenu;
    HashMAC: TMenuItem;
    M: TRichEdit;
    THashXXX: TMenuItem;
    MACwithRFC1: TMenuItem;
    ViewRFC2202html1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    UsingfromHashs1: TMenuItem;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    MItemFormats: TMenuItem;
    TCipherXXX: TMenuItem;
    TRandomXXX: TMenuItem;
    UsingfromCiphers1: TMenuItem;
    N4: TMenuItem;
    CipherMAC: TMenuItem;
    TransactionNumbersTANs1: TMenuItem;
    UsingfromRandoms1: TMenuItem;
    procedure HashMACClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MACwithRFC2104Click(Sender: TObject);
    procedure ViewRFC2202html1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure UsingfromHashs1Click(Sender: TObject);
    procedure UsingfromCiphers1Click(Sender: TObject);
    procedure TransactionNumbersTANs1Click(Sender: TObject);
    procedure CipherMACClick(Sender: TObject);
    procedure UsingfromRandoms1Click(Sender: TObject);
  private
    Format: Integer; // the used String Format
    procedure DoInfo(const Value: String; Color: TColor);
    procedure FormatClick(Sender: TObject);
  public
  end;

var
  GForm: TGForm;

implementation

{$R *.DFM}
const
  sSelfTest : array[Boolean] of String = ('failed', 'success');

procedure TGForm.DoInfo(const Value: String; Color: TColor);
begin // display Value in Color on Richedit
  M.SelStart := MaxInt div 16;
  M.SelLength := 0;
  M.SelAttributes.Color := Color;
  M.Lines.Add(Value);
  M.SelAttributes.Color := clWindowText;
  M.Perform(em_ScrollCaret, 0, 0);
  M.Update;
end;

procedure TGForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TGForm.FormatClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := True;
    Format := Tag;
    DoInfo('String Displayformat changed to: ' + Caption, clRed);
  end;
end;

procedure TGForm.FormCreate(Sender: TObject);
var
  I: Integer;
  S: TStringList;
  FMT: TStringFormatClass;
  MI: TMenuItem;
begin
// setup internal States
  Format := fmtHEXVIEW;

  M.HandleNeeded;
  M.Paragraph.Tab[0] := 90;

  S := TStringList.Create;
  try
    GetStringFormats(S);
    for I := 0 to S.Count-1 do
    begin
      FMT := TStringFormatClass(S.Objects[I]);
      if (FMT.Format = fmtCOPY) or
         (FMT.Format = fmtSAMPLE) then Continue;
      MI := TMenuItem.Create(MItemFormats);
      MI.Caption := FMT.Name;
      MI.Tag := FMT.Format;
      MI.OnClick := FormatClick;
      MI.RadioItem := True;
      MI.Checked := FMT.Format = Format;
      MItemFormats.Add(MI);
    end;
  finally
    S.Free;
  end;
end;

procedure TGForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TGForm.UsingfromHashs1Click(Sender: TObject);
var
  HUser: THashClass;
  S: String;
  Buffer: array[0..127] of Byte;
  I: Integer;
  Stream: TStream;
  Cipher: TCipher;
begin
  M.Clear;
  HUser := THash_RipeMD128; // change this for other Hash's

  for I := Low(Buffer) to High(Buffer) do Buffer[I] := I; // setup Buffer

  DoInfo('Hash using', clRed);
  DoInfo('User defined Hash is: ' + GetHashName(HUser), clMaroon);
  DoInfo('Self Test of used Hashs', clBlue);
  DoInfo('MD5:'#9 + sSelfTest[THash_MD5.SelfTest], clWindowText);
  DoInfo('HUser:'#9 + sSelfTest[HUser.SelfTest], clWindowText);

//------------------------------------------------------------------------------
  DoInfo('1. Fingerprint from ParamStr(0), DEMO.EXE', clBlue);


  S := THash_MD5.CalcFile(ParamStr(0), nil, Format);
  DoInfo('MD5'#9+S, clWindowText);

  S := HUser.CalcFile(ParamStr(0), nil, Format);
  DoInfo('HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
  DoInfo('2. Fingerprint from String, "Test"', clBlue);

  S := THash_MD5.CalcString('Test', nil, Format);
  DoInfo('MD5'#9+S, clWindowText);

  S := HUser.CalcString('Test', nil, Format);
  DoInfo('HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
  DoInfo('3. Fingerprint from Buffer', clBlue);

  S := THash_MD5.CalcBuffer(Buffer, SizeOf(Buffer), nil, Format);
  DoInfo('MD5'#9+S, clWindowText);

  S := HUser.CalcBuffer(Buffer, SizeOf(Buffer), nil, Format);
  DoInfo('HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
  DoInfo('4. Fingerprint from TStream, 1024 Bytes from DEMO.EXE at Position 123', clBlue);

  Stream := TFileStream.Create(ParamStr(0), fmOpenRead or fmShareDenyNone);
  try
    Stream.Position := 123;
    S := THash_MD5.CalcStream(Stream, 1024, nil, Format);
    DoInfo('MD5'#9+S, clWindowText);

    Stream.Position := 123;
    S := HUser.CalcStream(Stream, 1024, nil, Format);
    DoInfo('HUser'#9+S, clWindowText);

  finally
    Stream.Free;
  end;

//------------------------------------------------------------------------------
  DoInfo('5. Use any Hash Instance and Modify Initial Digest', clBlue);

  with THash_MD5.Create(nil) do
  try
    Init;
// setup the Initial Digest, XOR's a Passphrase with the Digest, must be after a call to Init
// ATTENTION: this is not the best Solution, the Strenght can be loose
    S := 'Password';
    for I := 0 to Length(S)-1 do
      PByteArray(DigestKey)[I mod DigestKeySize] := PByteArray(DigestKey)[I mod DigestKeySize] xor Byte(S[I+1]);

    Calc(Buffer[ 0], 16);   // calc the first 16 Bytes from Buffer
    Calc(Buffer[33], 15);   // calc from Buffer[33] 15 Bytes
    for I := 1 to 11 do     // calc 11 times an "Middle Password"
      Calc('DEC Part I', 10);
    Calc(Buffer[99],  20);
    Done;

    S := DigestStr(Format);
    DoInfo('MD5'#9+S, clWindowText);

  finally
    Free;
  end;
// and now for User Hash
  with HUser.Create(nil) do
  try
    Init;
// setup the Initial Digest, XOR's a Passphrase with the Digest, must be after a call to Init
// ATTENTION: this is not the best Solution, the Strenght can be loose
    S := 'Password';
    for I := 0 to Length(S)-1 do
      PByteArray(DigestKey)[I mod DigestKeySize] := PByteArray(DigestKey)[I mod DigestKeySize] xor Byte(S[I+1]);

    Calc(Buffer[ 0], 16);   // calc the first 16 Bytes from Buffer
    Calc(Buffer[33], 15);   // calc from Buffer[33] 15 Bytes
    for I := 1 to 11 do
      Calc('DEC Part I', 10);
    Calc(Buffer[99],  3);
    Done;

    S := DigestStr(Format);
    DoInfo('HUser'#9+S, clWindowText);

  finally
    Free;
  end;
//------------------------------------------------------------------------------
  DoInfo('6. Use the TProtection Methods from Hash', clBlue);

  with THash_MD5.Create(nil) do
  try
//------------------------------------------------------------------------------
// use a MD5 to En/Decrypt any String, all Hash Classes using follow Method:
// compute the first, Initialseed S0 (Password), compute from S0->S1->S2 and so on,
// the Datas now XOR'ed with these Seeds
    DoInfo('MD5 Encryption, PlainText: "Your Plaintext here", Password "DEC"', clGreen);
    Protection := TMAC_RFC2104.Create('DEC', nil); // Your Password

    S := CodeString('Your Plaintext here', paEncode, Format);
    DoInfo('encoded'#9+S, clWindowText);

    S := CodeString(S, paDecode, Format);
    DoInfo('decoded'#9+S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('MD5 Encryption, PlainText: "Your Plaintext here", Password "DED"', clGreen);
    Protection := TMAC_RFC2104.Create('DED', nil); // Your Password
//    Protection := TCipher_Blowfish.Create('DED', nil);

    S := CodeString('Your Plaintext here', paEncode, Format);
    DoInfo('1. encoded'#9+S, clWindowText);

    S := CodeString(S, paDecode, Format);
    DoInfo('1. decoded'#9+S, clWindowText);

// reverse Encryption paEncode/paDecode exchanged,
// change the Protection above to Blowfish and see these Result
    S := CodeString('Your Plaintext here', paDecode, fmtCOPY); // Format must be fmtCOPY
    DoInfo('2. encoded'#9+StrToFormat(PChar(S), Length(S), Format), clWindowText);

    S := CodeString(S, paEncode, fmtCopy);
    DoInfo('2. decoded'#9+S, clWindowText);

//------------------------------------------------------------------------------
// paScramble, it's a One Way Function
    DoInfo('MD5 Scramble, Data: "Data to scramble"', clGreen);
    Protection := TMAC.Create('DEC Scramble', nil); // Your Password

    S := CodeString('Data to scramble', paScramble, Format);
    DoInfo('1. scramble'#9+S, clWindowText);
    S := CodeString('Data to scramble', paScramble, Format);
    DoInfo('2. scramble'#9+S, clWindowText);

//------------------------------------------------------------------------------
// paWipe, it's a One Way Function (paScramble) but produce allways other Results
// Protection it's not needed, normaly used with CodeBuffer, CodeFile, CodeStream
// to wipe sensitive Datas, here we use to demonstrate CodeString()
 
    DoInfo('MD5 Wipe, Data: "Data to wipe"', clGreen);
    Protection := nil;

    S := CodeString('Data to wipe', paWipe, Format);
    DoInfo('1. wiped'#9+S, clWindowText);
    S := CodeString('Data to wipe', paWipe, Format);
    DoInfo('2. wiped'#9+S, clWindowText);
    S := CodeString('Data to wipe', paWipe, Format);
    DoInfo('3. wiped'#9+S, clWindowText);

//------------------------------------------------------------------------------
// calculate a MD5 Fingerprint over Blowfish encrypted DEMO.EXE
// THash_MD5.CalcFile() with same Blowfish Cipher will be calculate
// a MD5 Fingerprint and ONLY encrypt the Final Digest.
// Follow Method encrypt DEMO.EXE, calculates MD5 and encrypt MD5 Final Digest
// in one Step. Set CodeFile(ParamStr(0), 'C:\DEMO.ENC', paEncode) for a
// encryption from DEMO.EXE to DEMO.ENC, AND calculation of a MD5-Blowfish-HMAC
// over the DEMO.ENC in one Step.
    DoInfo('MD5 Calculation over Blowfish encrypted DEMO.EXE', clGreen);

    Protection := TCipher_Blowfish.Create('DEC', nil);
    CodeFile(ParamStr(0), '', paCalc);

    DoInfo('MD5-Digest'#9+DigestStr(Format), clWindowText);

//------------------------------------------------------------------------------
// calculate a MD5-HMAC Fingerprint over Blowfish encrypted String
    DoInfo('MD5 Calculation over Blowfish encrypted String', clGreen);
// use TProtection methods for a chain
    Protection := TCipher_Blowfish.Create('DEC Part I', nil);
    CodeString('Teststring', paCalc, fmtNONE); // fmtNONE = no Stringconvert

    DoInfo('CodeString()'#9+DigestStr(Format), clWindowText);
//------------------------------------------------------------------------------
// calculate a MD5 Fingerprint over Blowfish encrypted String with conventional Method
    Protection := nil; // no Protection needed
// simulate TProtection Methods above
    Cipher := TCipher_Blowfish.Create('', nil);
    try
      // initialize Cipher and encrypt String
      Cipher.InitKey('DEC Part I', nil);
      S := Cipher.EncodeString('Teststring');
      Cipher.Done;
      // calculate MD5 over encrypted String
      Init;                       // init MD5
      Calc(PChar(S)^, Length(S)); // calc MD5
      Done;                       // done MD5
      // encrypt the MD5 Digest
      Cipher.EncodeBuffer(DigestKey^, DigestKey^, DigestKeySize);
      
// display Digest, must be equal as above
      DoInfo('conventional'#9+DigestStr(Format), clWindowText);
    finally
      Cipher.Free;
    end;

// the CodeBuffer(), CodeStream() and CodeFile() works equal as above.
  finally
    Free; // destroy MD5
  end;

end;

procedure TGForm.HashMACClick(Sender: TObject);
var
  S,FileName: String;
  MAC: TMAC;
  Protection: TProtection;
  HUser: THashClass;
begin
  M.Clear;

  HUser := THash_Haval192; // change this for other Hash's
  FileName := ParamStr(0); // change this for other File

  DoInfo('Hash Message Authentication Codes', clRed);
  DoInfo('User defined Hash is: ' + GetHashName(HUser), clMaroon);
  DoInfo('follow MACs use .CalcFile(ParamStr(0)), computes a MAC over DEMO.EXE', clMaroon);
  DoInfo('Self Test of used Hashs', clBlue);
  DoInfo('MD5:'#9 + sSelfTest[THash_MD5.SelfTest], clWindowText);
  DoInfo('SHA1:'#9 + sSelfTest[THash_SHA1.SelfTest], clWindowText);
  DoInfo('HUser:'#9 + sSelfTest[HUser.SelfTest], clWindowText);

//------------------------------------------------------------------------------
  DoInfo('1. Generic THash_MD5(TMAC) -> MAC-MD5', clBlue);

  S := THash_MD5.CalcFile(FileName, TMAC.Create('DEC Part I', nil), Format);
  DoInfo('MAC-MD5, Password "DEC Part I"'#9+S, clWindowText);

  S := THash_MD5.CalcFile(FileName, TMAC.Create('DEC PArt I', nil), Format);
  DoInfo('MAC-MD5, Password "DEC PArt I"'#9+S, clWindowText);


//------------------------------------------------------------------------------

  MAC := TMAC.Create('DEC', nil);
  try
    MAC.AddRef;  // don't forgot these, it's a shared Resource

//------------------------------------------------------------------------------
    DoInfo('2. Generic TMAC -> use TMAC Instance, THash_XXX(TMAC("DEC"))', clBlue);

    S := THash_MD5.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('3. Generic TMAC -> use TMAC Instance with Protection, THash_XXX(TMAC("DEC", TCipher_Blowfish("Secret")))', clBlue);
// install a Blowfish Protection, these encrypt the final Hash.DigestKey
    MAC.Protection := TCipher_Blowfish.Create('Secret', nil);

    S := THash_MD5.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
//  frees the Blowfish MAC Protection and install a TRandom_LFSR protection
//  TRandom_LFSR has a Period from 2^400-1, see RNG.pas for more Details
    MAC.Protection := TRandom_LFSR.Create('Secret', 400, False, nil);

    DoInfo('4. Generic TMAC -> use TMAC Instance with Protection, THash_XXX(TMAC("DEC", TRandom_LFSR("Secret")))', clBlue);

    S := THash_MD5.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
//  frees the LFSR MAC Protection and install a THash_MD4(TMAC) protection
// a Double HMAC -> HMAC-MD5-HMAC-MD4
    MAC.Protection := THash_MD4.Create(TMAC.Create('Secret', nil));
// the Chain is now: THash_XXX -> TMAC('DEC') -> THash_MD4 -> TMAC('Secret')
    DoInfo('5. Generic TMAC -> use TMAC Instance with Protection, THash_XXX(TMAC("DEC", THash_MD4(TMAC("Secret"))))', clBlue);

    S := THash_MD5.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
//  Change Password
    MAC.Protection.Protection := TMAC.Create('SecRet', nil);

    DoInfo('6. Generic TMAC -> use TMAC Instance with Protection, THash_XXX(TMAC("DEC", THash_MD4(TMAC("SecRet"))))', clBlue);

    S := THash_MD5.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
// set MAC.Protection to THash_SHA1(TMAC("SecRet"))
// a HMAC-MD5-HMAC-SHA1
    MAC.Protection := THash_SHA1.Create(TMAC.Create('SecRet', nil));

    DoInfo('7. Generic TMAC -> use TMAC Instance with Protection, THash_XXX(TMAC("DEC", THash_SHA1(TMAC("SecRet"))))', clBlue);

    S := THash_MD5.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, MAC, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);

  finally
// release the MAC Instance and linked Protections (THash_MD4 -> TMAC);
    MAC.Release;
  end;

//------------------------------------------------------------------------------
  DoInfo('8. polymorph MAC -> THash_XXX(TCipher_Blowfish("Secret"))', clBlue);

  Protection := TCipher_Blowfish.Create('Secret', nil);
  try
    Protection.AddRef; // don't forgot these, it's a shared Resource
    Protection.AddRef;
    // MD5-Blowfish-CTS-MAC
    S := THash_MD5.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);
    // SHA1-Blowfish-CTS-MAC
    S := THash_SHA1.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);
  finally
    Protection.Release; // double AddRef -> double Release, or one .Free
    Protection.Release; // frees the Cipher
  end;

//------------------------------------------------------------------------------
  DoInfo('9. polymorph MAC -> THash_XXX(TRandom_LFSR("Secret"))', clBlue);

  Protection := TRandom_LFSR.Create('Secret', 2032, False, nil); // Period 2^2032-1 see RNG.pas for Details
  try
    Protection.AddRef; // don't forgot these, it's a shared Resource

    S := THash_MD5.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);
  finally
    Protection.Release; // frees the Random
  end;

//------------------------------------------------------------------------------
  DoInfo('10. polymorph MAC -> THash_XXX(TMAC("DEC"))', clBlue);
  DoInfo('The Results must be same as Step 2.', clMaroon);

  Protection := TMAC.Create('DEC', nil);
  try
    Protection.AddRef; // don't forgot these, it's a shared Resource

    S := THash_MD5.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-MD5'#9+S, clWindowText);

    S := THash_SHA1.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-SHA1'#9+S, clWindowText);

    S := HUser.CalcFile(FileName, Protection, Format);
    DoInfo('MAC-HUser'#9+S, clWindowText);
  finally
    Protection.Release;
  end;

end;

procedure TGForm.MACwithRFC2104Click(Sender: TObject);

  function RepKey(Value, Count: Integer): String;
  begin
    SetLength(Result, Count);
    FillChar(PChar(Result)^, Count, Value);
  end;

var
  HUser: THashClass;
  MAC: TMAC;
  Data: array[1..50] of Byte;
  S: String;
  I: Integer;
  Stream: TMemoryStream;
begin
  M.Clear;

  HUser := DefaultHashClass;

  DoInfo('RFC2104 Standard HMAC', clRed);
  DoInfo('User defined Hash is: ' + GetHashName(HUser), clMaroon);
  DoInfo('follow MACs use the Testcases from RFC2202, see Docus\RFC2202.html', clMaroon);
  DoInfo('the gray HEX values are from RFC2202.html', clMaroon);
  DoInfo('Self Test of used Hashs', clBlue);
  DoInfo('MD5:'#9 + sSelfTest[THash_MD5.SelfTest], clWindowText);
  DoInfo('SHA1:'#9 + sSelfTest[THash_SHA1.SelfTest], clWindowText);
  DoInfo('HUser:'#9 + sSelfTest[HUser.SelfTest], clWindowText);

//------------------------------------------------------------------------------
  DoInfo('Testcase No. 1', clBlue); // shit Test, use other Key's for the same Thing

  S := THash_MD5.CalcString('Hi There', TMAC_RFC2104.Create(RepKey($0B, 16), nil), fmtHEXL);
  DoInfo('HMAC-MD5'#9+S, clWindowText);
  DoInfo(#9'9294727a3638bb1c13f48ef8158bfc9d', clGrayText);

  S := THash_SHA1.CalcString('Hi There', TMAC_RFC2104.Create(RepKey($0B, 20), nil), fmtHEXL);
  DoInfo('HMAC-SHA1'#9+S, clWindowText);
  DoInfo(#9'b617318655057264e28bc0b6fb378c8ef146be00', clGrayText);

  S := HUser.CalcString('Hi There', TMAC_RFC2104.Create(RepKey($0B, 20), nil), fmtHEXL);
  DoInfo('HMAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
  DoInfo('Testcase No. 2', clBlue);

  MAC := TMAC_RFC2104.Create('Jefe', nil);
  try
    MAC.AddRef;

    S := THash_MD5.CalcString('what do ya want for nothing?', MAC, fmtHEXL);
    DoInfo('HMAC-MD5'#9+S, clWindowText);
    DoInfo(#9'750c783e6ab0b503eaa86e310a5db738', clGrayText);

    S := THash_SHA1.CalcString('what do ya want for nothing?', MAC, fmtHEXL);
    DoInfo('HMAC-SHA1'#9+S, clWindowText);
    DoInfo(#9'effcdf6ae5eb2fa2d27416d5f184df9c259a7c79', clGrayText);

    S := HUser.CalcString('what do ya want for nothing?', MAC, fmtHEXL);
    DoInfo('HMAC-HUser'#9+S, clWindowText);

  finally
    MAC.Release;
  end;

//------------------------------------------------------------------------------
  DoInfo('Testcase No. 3', clBlue);

  FillChar(Data, SizeOf(Data), $DD);

  S := THash_MD5.CalcBuffer(Data, SizeOf(Data), TMAC_RFC2104.Create(RepKey($AA, 16), nil), fmtHEXL);
  DoInfo('HMAC-MD5'#9+S, clWindowText);
  DoInfo(#9'56be34521d144c88dbb8c733f0e8b3f6', clGrayText);

  S := THash_SHA1.CalcBuffer(Data, SizeOf(Data), TMAC_RFC2104.Create(RepKey($AA, 20), nil), fmtHEXL);
  DoInfo('HMAC-SHA1'#9+S, clWindowText);
  DoInfo(#9'125d7342b9ac11cd91a39af48aa17b4f63f175d3', clGrayText);

  S := HUser.CalcBuffer(Data, SizeOf(Data), TMAC_RFC2104.Create(RepKey($AA, 20), nil), fmtHEXL);
  DoInfo('HMAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
  DoInfo('Testcase No. 4', clBlue);

  FillChar(Data, SizeOf(Data), $CD);
  SetLength(S, 25);
  for I := 1 to 25 do Byte(S[I]) := I;

  MAC := TMAC_RFC2104.Create(S, nil);
  try
    MAC.AddRef;

    S := THash_MD5.CalcBuffer(Data, SizeOf(Data), MAC, fmtHEXL);
    DoInfo('HMAC-MD5'#9+S, clWindowText);
    DoInfo(#9'697eaf0aca3a3aea3a75164746ffaa79', clGrayText);

    S := THash_SHA1.CalcBuffer(Data, SizeOf(Data), MAC, fmtHEXL);
    DoInfo('HMAC-SHA1'#9+S, clWindowText);
    DoInfo(#9'4c9007f4026250c6bc8414f9bf50c86c2d7235da', clGrayText);

    S := HUser.CalcBuffer(Data, SizeOf(Data), MAC, fmtHEXL);
    DoInfo('HMAC-HUser'#9+S, clWindowText);

  finally
    MAC.Release;
  end;

//------------------------------------------------------------------------------
  DoInfo('Testcase No. 5', clBlue);

  S := THash_MD5.CalcString('Test With Truncation', TMAC_RFC2104.Create(RepKey($0C, 16), nil), fmtHEXL);
  DoInfo('HMAC-MD5'#9+S, clWindowText);
  DoInfo(#9'56461ef2342edc00f9bab995690efd4c', clGrayText);
  SetLength(S, 96 div 8 * 2);  // 96 Bits div 8 Bit * 2 Chars per Byte
  DoInfo('HMAC-MD5-96'#9+S, clWindowText);
  DoInfo(#9'56461ef2342edc00f9bab995', clGrayText);

  S := THash_SHA1.CalcString('Test With Truncation', TMAC_RFC2104.Create(RepKey($0C, 20), nil), fmtHEXL);
  DoInfo('HMAC-SHA1'#9+S, clWindowText);
  DoInfo(#9'4c1a03424b55e07fe7f27be1d58bb9324a9a5a04', clGrayText);
  SetLength(S, 96 div 8 * 2);
  DoInfo('HMAC-SHA1-96'#9+S, clWindowText);
  DoInfo(#9'4c1a03424b55e07fe7f27be1', clGrayText);

  S := HUser.CalcString('Test With Truncation', TMAC_RFC2104.Create(RepKey($0C, 20), nil), fmtHEXL);
  DoInfo('HMAC-HUser'#9+S, clWindowText);
  SetLength(S, 96 div 8 * 2);
  DoInfo('HMAC-HUser-96'#9+S, clWindowText);

// follow Tests use a Stream
  Stream := TMemoryStream.Create;
  MAC    := TMAC_RFC2104.Create(RepKey($AA, 80), nil);
  try
    MAC.AddRef;

//------------------------------------------------------------------------------
    DoInfo('Testcase No. 6', clBlue);

    Stream.Write('Test Using Larger Than Block-Size Key - Hash Key First', 54);
// here must be not set the Stream.Position, we use a StreamSize = -1, THash_XXX manage the Seeking
    S := THash_MD5.CalcStream(Stream, -1, MAC, fmtHEXL);
    DoInfo('HMAC-MD5'#9+S, clWindowText);
    DoInfo(#9'6b1ab7fe4bd7bf8f0b62e6ce61b9d0cd', clGrayText);

    S := THash_SHA1.CalcStream(Stream, -1, MAC, fmtHEXL);
    DoInfo('HMAC-SHA1'#9+S, clWindowText);
    DoInfo(#9'aa4ae5e15272d00e95705637ce8a3b55ed402112', clGrayText);

    S := HUser.CalcStream(Stream, -1, MAC, fmtHEXL);
    DoInfo('HMAC-HUser'#9+S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('Testcase No. 7', clBlue);

    Stream.Size := 0;
    Stream.Write('Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data', 73);
// here must be set the Stream.Position, we use a StreamSize = Stream.Size
    Stream.Position := 0;
    S := THash_MD5.CalcStream(Stream, Stream.Size, MAC, fmtHEXL);
    DoInfo('HMAC-MD5'#9+S, clWindowText);
    DoInfo(#9'6f630fad67cda0ee1fb1f562db3aa53e', clGrayText);

    Stream.Position := 0;
    S := THash_SHA1.CalcStream(Stream, Stream.Size, MAC, fmtHEXL);
    DoInfo('HMAC-SHA1'#9+S, clWindowText);
    DoInfo(#9'e8e99d0f45237d786d6bbaa7965c7808bbff1a91', clGrayText);

    Stream.Position := 0;
    S := HUser.CalcStream(Stream, Stream.Size, MAC, fmtHEXL);
    DoInfo('HMAC-HUser'#9+S, clWindowText);

  finally
    MAC.Release;
    Stream.Free;
  end;

end;

procedure TGForm.ViewRFC2202html1Click(Sender: TObject);
var
  S: String;
begin
  S := ExtractFilePath(ParamStr(0));
  SetLength(S, Length(S)-1);
  S := ExtractFilePath(S) + 'Docus\RFC2202.html';
  ShellExecute(Handle, nil, PChar(S), nil, nil, sw_ShowNormal);
end;

procedure TGForm.TransactionNumbersTANs1Click(Sender: TObject);
const
  HashTAN : THashClass = THash_SHA1;
  maxTANEntries = 10; // TAN List have 10 Numbers

// make a String shorter
  function FoldStr(const Value: String): String;
  const
    maxLen = 8; // make this not shorter as 6, 6 Bytes are only 2^48 combination !
  var
    I,Len: Integer;
  begin
    Result := Value;
    Len := Length(Result);
    for I := 1 to Len do
      Byte(Result[I]) := Byte(Result[I]) xor Byte(Result[(I + maxLen) mod Len]);
    SetLength(Result, maxLen);
  end;

// create a TAN List for a Client
  function CreateTANList(const SeedTANList, SeedTAN, Name: String; ID: Integer; var LastTAN: String): TStringList;
  type
    PClient = ^TClient;
    TClient = packed record
                Name: array[0..80] of Char; // Clientname uppercase
                ID: Integer;                // Client ID
                Seed: array[0..64] of Char; // internal Seed on the Server, enough for all Hash
                TANCount: Integer;          // counter of TAN lists
              end;
   var
     Client: TClient;
     S: String;
     I: Integer;
   begin
// create the TAN List
     Result := TStringList.Create;
// setup Client Infos
     FillChar(Client, Sizeof(Client), 0);
     StrPLCopy(Client.Name, AnsiUpperCase(Trim(Name)), SizeOf(Client.Name));
     Client.ID := ID;
// must be increment for the next TAN List
     Client.TANCount := 1;
// or randimzed, produce allways other TAN Lists
//     Client.TANCount := RndTimeSeed;

// compute the Client secure Seed from the Server internal Seed S0
// Seed S0 is never used in the Client record
// the Client Seed is only known for the Server (BANK), any Attacker can not compute, with known
// Client Name and ID, the correct TAN List, only with the correct Sever Seed (S0) can
// be rebuild the TAN List, except the TANCount is randomized, any TAN List is than unique
// (I think this is the better Way)

// convert to binary Representation
     S := FormatToStr(PChar(SeedTANList), -1, Format);
     I := ID;
     repeat
       S := HashTAN.CalcString(S, nil, fmtCOPY);
       Dec(I);
     until I <= 0;
     StrPLCopy(Client.Seed, S, SizeOf(Client.Seed));
// compute the Client TAN List
// first: S0 Initial Seed over Client record, is never used
     S := HashTAN.CalcBuffer(Client, SizeOf(Client), nil, fmtCOPY);
     I := maxTANEntries;
     repeat
       S := HashTAN.CalcString(S, nil, fmtCOPY);
       S := FoldStr(S);
       Result.Insert(0, StrToFormat(PChar(S), Length(S), Format));
       Dec(I);
     until I <= 0;
// one Step more for the LastTAN
     S := HashTAN.CalcString(S, nil, fmtCOPY);
     S := FoldStr(S);
     S := S + FormatToStr(PChar(SeedTAN), -1, Format);
// compute MD5 over Last TAN + SeedTAN
     LastTAN := HashTAN.CalcString(S, nil, Format);
   end;

// check CurrentTAN with LastTAN/SeedTAN and store the next LastTAN
   function CheckTAN(const SeedTAN, LastTAN: String; var CurrentTAN: String): Boolean;
   var
     C,L,S: String;
     I: Integer;
   begin
     try
       S := FormatToStr(PChar(SeedTAN), -1, Format);
       C := FormatToStr(PChar(CurrentTAN), -1, Format);
       L := FormatToStr(PChar(LastTAN), -1, Format);
       I := maxTANEntries; // max. TAN List Count
       repeat
         C := HashTAN.CalcString(C, nil, fmtCOPY);
         C := FoldStr(C);
// compute the correct TAN from C + SeedTAN and check these
         Result := HashTAN.CalcString(C + S, nil, fmtCOPY) = L;
         Dec(I);
       until Result or (I <= 0);
       C := FormatToStr(PChar(CurrentTAN), -1, Format) + S;
       CurrentTAN := HashTAN.CalcString(C, nil, Format);
     except
       Result := False;
       Application.HandleException(nil);
     end;
   end;

var
  SeedTANList, SeedTAN: String;
  TANList: TStringList;
  I: Integer;
  LastTAN: String;
  TAN: String;
begin
  M.Clear;
  DoInfo('Transaction Number Lists and One Time Password Demonstration', clRed);
  DoInfo('Hash Algorithm is: ' + GetHashName(HashTAN), clMaroon);
  DoInfo('Self Test of used Hashs', clBlue);
  DoInfo('HashTAN:'#9 + sSelfTest[HashTAN.SelfTest], clWindowText);
// The Server has an internal secure Seed
  DoInfo('build Server Seed S0', clBlue);

  SeedTANList := HashTAN.CalcString('Server Password from the "Sample BANK of Germany"', nil, Format);
  SeedTAN     := SeedTANList; // here both Seeds are equal

  DoInfo('S0:'#9+SeedTANList, clWindowText);

// The Server build for "Hagen Reddmann" with ID "54" a TAN List
  DoInfo('build TAN list for "Reddmann, Hagen"', clBlue);

  TANList := CreateTANList(SeedTANList, SeedTAN, 'Reddmann, Hagen', 54, LastTAN);

  try
// now, on the Sever exists a Database with follow Fields:
// ClientID and Last used TAN
// store the first TAN (LastTAN) into these Database

// on the Client
    DoInfo('Clients TAN list:', clWindowText);
    for I := 0 to TANList.Count-1 do
      DoInfo(IntToStr(I)+ ':'#9+TANList[I], clWindowText);

    DoInfo('Client make Transactions', clBlue);

// 1. TA --------------------------------------------------------------------
    TAN := TANList[0]; TANList.Delete(0);
    DoInfo('Current TAN:'#9 + TAN, clWindowText);

// the Clients send the TAN and Client ID to the Server
// the Server search in the Database the Client ID, extracts LastTAN and
// check the TAN
    if CheckTAN(SeedTAN, LastTAN, TAN) then
    begin
      DoInfo('TAN is ok', clGreen);
// save the Current TAN (modified with SeedTAN) into Database as last used TAN
      LastTAN := TAN;
      DoInfo('Last TAN:'#9+LastTAN, clGreen);
    end else
    begin
      DoInfo('TAN is bad', clMaroon);
    end;
    DoInfo('', clWindowText);

// 2. TA --------------------------------------------------------------------
    TAN := TANList[0]; TANList.Delete(0);
    DoInfo('Current TAN:'#9 + TAN, clWindowText);
// make a bad TAN
    Delete(TAN, 1, 4);
    DoInfo('Bad TAN:'#9 + TAN, clMaroon);
// on the Server, check the TAN
    if CheckTAN(SeedTAN, LastTAN, TAN) then
    begin
      DoInfo('TAN is ok', clGreen);
      LastTAN := TAN;
      DoInfo('Last TAN:'#9+LastTAN, clGreen);
    end else
    begin
// above TAN must be bad
      DoInfo('TAN is bad', clMaroon);
    end;
    DoInfo('', clWindowText);

// 3. TA --------------------------------------------------------------------
// skip 2 TAN's
    TANList.Delete(0); TANList.Delete(0);

    TAN := TANList[0]; TANList.Delete(0);
    DoInfo('Current TAN:'#9 + TAN, clWindowText);

// on the Server, check the TAN, the Sever must be now skip 3 TAN's and use the next
    if CheckTAN(SeedTAN, LastTAN, TAN) then
    begin
      DoInfo('TAN is ok', clGreen);
// save the Current TAN into Database as last used TAN
      LastTAN := TAN;
      DoInfo('Last TAN:'#9+LastTAN, clGreen);
    end else
    begin
      DoInfo('TAN is bad', clMaroon);
    end;

  finally
    TANList.Free;
  end;
{ final Remarks:
  - The Client can skip one or more TAN's in the TAN list, but can than never use
    these skipped TAN's.
  - The Security of these Method is on the Server (BANK) the SeedTANList and SeedTAN,
    the best Way is a precomputation of these Values from the Password without any saving.
  - Only one Weakness exists, the TAN List on the Client, with known TAN can be make
    correct Transactions. That is the general Weakness from all TAN Systems.
  - A good extension of these TAN Methods is the use of HMAC (Hash Message
    Authentication Codes) or the Installation from any Protection.
  - The above Method can be use as One Time Password System with only one difference:
    the SeedTANList and TANList is computed on the Client and the first LastTAN is
    send over a secure Channel to the Server. SeedTAN is computed and used on the Server.
    For more Details see RFC2289.pas the One Time Password Component.
}
end;

procedure TGForm.UsingfromCiphers1Click(Sender: TObject);
const
  sMode: array[TCipherMode] of String = ('cmCTS', 'cmCBC', 'cmCFB', 'cmOFB',
                                         'cmECB', 'cmCTSMAC', 'cmCBCMAC', 'cmCFBMAC');
var
  CUser: TCipherClass;
  Buffer: array[0..15] of Byte;
  I: Integer;
  S: String;
  Stream: TMemoryStream;
  K: TCipherMode;
begin
  M.Clear;
  CUser := TCipher_Blowfish; // change this for other Hash's

  for I := Low(Buffer) to High(Buffer) do Buffer[I] := I + 32; // setup Buffer

  DoInfo('Cipher using', clRed);
  DoInfo('User defined Cipher is: ' + GetCipherName(CUser), clMaroon);
  DoInfo('Self Test of used Ciphers', clBlue);
  DoInfo('CUser:'#9 + sSelfTest[CUser.SelfTest], clWindowText);
  DoInfo('Blowfish:'#9 + sSelfTest[TCipher_Blowfish.SelfTest], clWindowText);
  DoInfo('IDEA:'#9 + sSelfTest[TCipher_IDEA.SelfTest], clWindowText);
  DoInfo('GOST:'#9 + sSelfTest[TCipher_GOST.SelfTest], clWindowText);


  with CUser.Create('', nil) do
  try
//------------------------------------------------------------------------------
    DoInfo('1. En/Decryption of a File, ParamStr(0), DEMO.EXE', clBlue);

    InitKey('DEC', nil);
    EncodeFile(ParamStr(0), ChangeFileExt(ParamStr(0), '.ENC'));
    DoInfo('MAC'#9+CalcMAC(Format), clWindowText);

    Done;  // call done or InitKey() to reinitialize, done is faster
//    InitKey('DEC', nil);

    DecodeFile(ChangeFileExt(ParamStr(0), '.ENC'), ChangeFileExt(ParamStr(0), '.DEC'));
    DoInfo('MAC'#9+CalcMAC(Format), clWindowText);

    Protect; // protect any secure Data on the Cipher, after this You must Reinit

//------------------------------------------------------------------------------
    DoInfo('2. En/Decryption of a String, "String Encryption Test"', clBlue);
    InitKey('DEC Part I', nil);

    S := EncodeString('String Entryption Test');
    DoInfo('Encryted:'#9+ StrToFormat(PChar(S), Length(S), Format), clWindowText);
    DoInfo('MAC'#9+CalcMAC(Format), clWindowText);
    Done;

    S := DecodeString(S);

    DoInfo('Decryted:'#9+ S, clWindowText);
    DoInfo('MAC'#9+CalcMAC(Format), clWindowText);

    Protect;

//------------------------------------------------------------------------------
    DoInfo('3. En/Decryption of a Buffer, "' +StrToFormat(@Buffer, Sizeof(Buffer), Format) + '"', clBlue);
    InitKey('DEC Part I', nil);

    EncodeBuffer(Buffer, Buffer, SizeOf(Buffer));
    DoInfo('Encryted:'#9+ StrToFormat(@Buffer, Sizeof(Buffer), Format), clWindowText);
    DoInfo('MAC'#9+CalcMAC(Format), clWindowText);
    Done;

    DecodeBuffer(Buffer, Buffer, SizeOf(Buffer));

    DoInfo('Decryted:'#9+ StrToFormat(@Buffer, Sizeof(Buffer), Format), clWindowText);
    DoInfo('MAC'#9+CalcMAC(Format), clWindowText);

    Protect;

//------------------------------------------------------------------------------
    DoInfo('4. En/Decryption of a Stream, "Partial Stream En/Decryption"', clBlue);
    InitKey('DEC Part I', nil);

    Stream := TMemoryStream.Create;
    try
      S := 'Partial Stream En/Decryption';
      Stream.Write(PChar(S)^, Length(S));

      Stream.Position := 8;
      EncodeStream(Stream, Stream, 6);

      DoInfo('Encryted:'#9+ StrToFormat(Stream.Memory, Stream.Size, Format), clWindowText);
      DoInfo('MAC'#9+CalcMAC(Format), clWindowText);
      Done;

      Stream.Position := 8;
      DecodeStream(Stream, Stream, 6);

      DoInfo('Decryted:'#9+ StrToFormat(Stream.Memory, Stream.Size, Format), clWindowText);
      DoInfo('MAC'#9+CalcMAC(Format), clWindowText);

    finally
      Stream.Free;
    end;

//------------------------------------------------------------------------------
    DoInfo('5. Various Cipher Modes', clBlue);
// The Datas in Mode cmECB must be allways a multiply from Cipher.BufSize, otherwise
// will be not correct decrypt. Follow Code demonstrate this. 
    for K := cmCTS to cmECB do
    begin
      DoInfo('Mode: ' + sMode[K], clGreen);
      Mode := K;

      InitKey('DEC', nil);
      S := EncodeString('Teststring to encrypt');
      DoInfo('Encryted:'#9+ StrToFormat(PChar(S), Length(S), Format), clWindowText);

      Done;

      S := DecodeString(S);
      DoInfo('Decryted:'#9+ StrToFormat(PChar(S), Length(S), Format), clWindowText);
    end;
  finally
    Free;
  end;

//------------------------------------------------------------------------------
  DoInfo('6. Using from TProtection-Method CodeString() with any Protection', clBlue);

  with CUser.Create('', nil) do
  try
//------------------------------------------------------------------------------
    DoInfo('Without any Protection', clBlue);

    InitKey('DEC', nil);
// one call from Init() or InitKey() is enough for all Modes
// TProtection Methods CodeString(), CodeBuffer(), CodeFile() and CodeStream()
// have a implicit Initialization and Finalization with CodeInit() and CodeDone().
    for K := cmCTS to cmECB do
    begin
      DoInfo('Mode: ' + sMode[K], clGreen);
      Mode := K;

      S := CodeString('Teststring to encrypt', paEncode, Format);
      DoInfo('Encryted:'#9+ S, clWindowText);

      S := CodeString(S, paDecode, Format);
      DoInfo('Decryted:'#9+ S, clWindowText);
    end;

//------------------------------------------------------------------------------
    DoInfo('With Protection TRandom_LFSR("DEC")', clBlue);
    Protection := TRandom_LFSR.Create('DEC', 400, False, nil);
    InitKey('DEC', nil);

    for K := cmCTS to cmECB do
    begin
      DoInfo('Mode: ' + sMode[K], clGreen);
      Mode := K;

      S := CodeString('Teststring to encrypt', paEncode, Format);
      DoInfo('Encryted:'#9+ S, clWindowText);

      S := CodeString(S, paDecode, Format);
      DoInfo('Decryted:'#9+ S, clWindowText);
    end;

//------------------------------------------------------------------------------
    DoInfo('With Protection THash_MD5(TMAC_RFC2104("DEC"))', clBlue);
    Protection := THash_MD5.Create(TMAC_RFC2104.Create('DEC', nil));
    InitKey('DEC', nil);

    for K := cmCTS to cmECB do
    begin
      DoInfo('Mode: ' + sMode[K], clGreen);
      Mode := K;

      S := CodeString('Teststring to encrypt', paEncode, Format);
      DoInfo('Encryted:'#9+ S, clWindowText);

      S := CodeString(S, paDecode, Format);
      DoInfo('Decryted:'#9+ S, clWindowText);
    end;

  finally
    Free;
  end;

//------------------------------------------------------------------------------
  DoInfo('7. Using from TProtections Methods', clBlue);

  with CUser.Create('', nil) do
  try
    HashClass := THash_MD5;  // setup another HashClass for the InitKey()
    InitKey('DEC', nil);

//------------------------------------------------------------------------------
    DoInfo('CodeString(paEncode/paDecode)', clGreen);

    S := CodeString('CodeString()', paEncode, Format);
    DoInfo('Encryted:'#9+ S, clWindowText);
    S := CodeString(S, paDecode, Format);
    DoInfo('Decryted:'#9+ S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('CodeString(paScramble)', clGreen);

    S := CodeString('CodeString()', paScramble, Format);
    DoInfo('Scramble:'#9+ S, clWindowText);
    S := CodeString('CodeString()', paScramble, Format);
    DoInfo('Scramble:'#9+ S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('CodeString(paWipe)', clGreen);
// paWipe is normaly used with CodeBuffer(), CodeFile() and CodeStream()
    S := CodeString('CodeString()', paWipe, Format);
    DoInfo('Wipe:'#9+ S, clWindowText);
    S := CodeString('CodeString()', paWipe, Format);
    DoInfo('Wipe:'#9+ S, clWindowText);
    S := CodeString('CodeString()', paWipe, Format);
    DoInfo('Wipe:'#9+ S, clWindowText);

  finally
    Free;
  end;
//------------------------------------------------------------------------------
  DoInfo('8. A secure Encryption for the Future', clBlue);
// Follow demonstrate a Multi-En/Decryption that use 3 Ciphers in a Chain.
// Ok, You think that any Cipher (i.E. GOST) in the Future is brocken, then
// can You encrypt any datas with more as one Cipher Algorithm. The Strenght
// is than the Strenght from the best Cipher Algorithm (I think here it's IDEA).
// Is now in the Future any used Cipher brocken (i.E. GOST), then is the Data secure.
// All Ciphers use the same Password "DEC" and CipherMode "cmCTS".
// The Random_LFSR() scramble the Input Data, that means:
// You send allways Documents with same headers and footers or in a known Language,
// and these is any Attacker known. The TRandom_LFSR scrambles now these headers and
// footers and remove so any redunance in the Language or Documents.

  with TCipher_Blowfish.Create('DEC',
         TCipher_IDEA.Create('DEC',
           TCipher_GOST.Create('DEC',
             TRandom_LFSR.Create('Scramble', 128, False, nil)))) do
  try
    S := CodeString('The nice DEC Part I', paEncode, Format);
    DoInfo('Encrypted:'#9+S, clWindowText);
    S := CodeString(S, paDecode, Format);
    DoInfo('Decrypted:'#9+S, clWindowText);
  finally
    Free;
  end;
// The Encryption calls now:
//  1. TRandom_LFSR() to Scamble the Input
//  2. TCipher_GOST to Encrypt with GOST the LFSR scrambled Input
//  3. TCipher_IDEA to Encrypt with IDEA the Data from GOST
//  4. TCipher_Blowfish to Encrypt with Blowfish the Data from IDEA
// The Decryption calls reverse:
//  Blowfish -> IDEA -> GOST -> unscramble with LFSR
// I think this is hard to crack :-))

end;

procedure TGForm.CipherMACClick(Sender: TObject);
const
  sMode: array[TCipherMode] of String = ('CTS-MAC', 'CBC-MAC', 'CFB-MAC',
                                         'invalid', 'invalid',
                                         'CTS-MAC', 'CBC-MAC', 'CFB-MAC');
var
  CUser: TCipherClass;
  K: TCipherMode;
  I: Integer;
begin
  M.Clear;
  CUser := TCipher_Blowfish; // change this for other Hash's

  DoInfo('Message Authentication Codes with Ciphers', clRed);
  DoInfo('User defined Cipher is: ' + GetCipherName(CUser), clMaroon);
  DoInfo('Self Test of used Ciphers', clBlue);
  DoInfo('CUser:'#9 + sSelfTest[CUser.SelfTest], clWindowText);
  DoInfo('SCOP:'#9 + sSelfTest[TCipher_SCOP.SelfTest], clWindowText);

//------------------------------------------------------------------------------
  DoInfo('1. MAC from ParamStr(0), DEMO.EXE', clBlue);
// - the Ciphermodes cmCTSMAC, cmCBCMAC, cmCFBMAC caluculates only a MAC
// - all Datas are readonly and NOT changed
// - En/Decode Methods produced allways the same Results
// - CalcMAC can be called more than one to produce a MAC-Chain
// - CalcMAC make implicit calls to .Done

// constructor Create('Password', nil) calls InitKey() when Password not empty
// means a implicit Initialization
  with CUser.Create('DEC', nil) do
  try
    for K := cmCTSMAC to cmCFBMAC do
    begin
      Mode := K;
      DoInfo('EncodeFile() in MAC Mode: ' + sMode[K], clGreen);
      EncodeFile(ParamStr(0), '');
      for I := 1 to 3 do
        DoInfo(IntToStr(I) + ': ' + sMode[K] + #9 + CalcMAC(Format), clWindowText);

      DoInfo('DecodeFile() in MAC Mode: ' + sMode[K], clGreen);
      DecodeFile(ParamStr(0), '');
      for I := 1 to 3 do
        DoInfo(IntToStr(I) + ': ' + sMode[K] + #9 + CalcMAC(Format), clWindowText);
    end;
  finally
    Free;
  end;

//------------------------------------------------------------------------------
  DoInfo('2. MAC from ParamStr(0), DEMO.EXE with Protection Blowfish("Secret")', clBlue);
  with CUser.Create('DEC', TCipher_Blowfish.Create('Secret', nil)) do
  try
    for K := cmCTSMAC to cmCFBMAC do
    begin
      Mode := K;
      DoInfo('EncodeFile() in MAC Mode: ' + sMode[K], clGreen);
      EncodeFile(ParamStr(0), '');
      for I := 1 to 3 do
        DoInfo(IntToStr(I) + ': ' + sMode[K] + #9 + CalcMAC(Format), clWindowText);

      DoInfo('DecodeFile() in MAC Mode: ' + sMode[K], clGreen);
      DecodeFile(ParamStr(0), '');
      for I := 1 to 3 do
        DoInfo(IntToStr(I) + ': ' + sMode[K] + #9 + CalcMAC(Format), clWindowText);
    end;
  finally
    Free;
  end;
// Remarks:
// - all Methods En/DecodeString, En/DecodeBuffer, En/DecodeFile, En/DecodeStream
//   works as above
// - in CipherModes cmCTS, cmCBC, cmCFB can You use the CalcMAC() function after any
//   Encryption/Decryption to check of correct Decrpytion
// - in CipherModes cmECB, cmOFB You can not use CalcMAC()

//------------------------------------------------------------------------------
  DoInfo('3. MAC''s with TProtection Method CodeString', clBlue);

  with CUser.Create('DEC', nil) do
  try
// install a HMAC-MD5-LFSR128-SCOP protection :-)
//------------------------------------------------------------------------------
    DoInfo('Protection HMAC-MD5-LFSR128-SCOP', clGreen);
    Protection := THash_MD5.Create(TMAC_RFC2104.Create('Secret 1',
                     TRandom_LFSR.Create('Secret 2', 128, False,
                        TCipher_SCOP.Create('Secret 3', nil))));

    for K := cmCTSMAC to cmCFBMAC do
    begin
      Mode := K;
      CodeString('The nice DEC Part I', paCalc, fmtNONE);
      DoInfo(sMode[K] + #9 + CalcMAC(Format), clWindowText);
    end;

//------------------------------------------------------------------------------
    DoInfo('Protection HMAC-MD5-LFSR128-SCOP with other Password for MD5', clGreen);
    Protection := THash_MD5.Create(TMAC_RFC2104.Create('SecRet 1',
                     TRandom_LFSR.Create('Secret 2', 128, False,
                        TCipher_SCOP.Create('Secret 3', nil))));

    for K := cmCTSMAC to cmCFBMAC do
    begin
      Mode := K;
      CodeString('The nice DEC Part I', paCalc, fmtNONE);
      DoInfo(sMode[K] + #9 + CalcMAC(Format), clWindowText);
    end;

//------------------------------------------------------------------------------
    DoInfo('Protection HMAC-MD5-LFSR128-SCOP with other Password for LFSR', clGreen);
    Protection := THash_MD5.Create(TMAC_RFC2104.Create('Secret 1',
                     TRandom_LFSR.Create('SecRet 2', 128, False,
                        TCipher_SCOP.Create('Secret 3', nil))));

    for K := cmCTSMAC to cmCFBMAC do
    begin
      Mode := K;
      CodeString('The nice DEC Part I', paCalc, fmtNONE);
      DoInfo(sMode[K] + #9 + CalcMAC(Format), clWindowText);
    end;

//------------------------------------------------------------------------------
    DoInfo('Protection HMAC-MD5-LFSR128-SCOP with other Password for SCOP', clGreen);
    Protection := THash_MD5.Create(TMAC_RFC2104.Create('Secret 1',
                     TRandom_LFSR.Create('Secret 2', 128, False,
                        TCipher_SCOP.Create('SecRet 3', nil))));

    for K := cmCTSMAC to cmCFBMAC do
    begin
      Mode := K;
      CodeString('The nice DEC Part I', paCalc, fmtNONE);
      DoInfo(sMode[K] + #9 + CalcMAC(Format), clWindowText);
    end;
  finally
    Free;
  end;
// Remarks:
// - above methods works with all TProtection Methods, CodeBuffer(), CodeString()
//   CodeStream(), CodeFile()
// - with Action = paCalc it's the Result from CodeString() allways the same as the Input

end;

procedure TGForm.UsingfromRandoms1Click(Sender: TObject);
var
  I: Integer;
  S,SaveState: String;
  Buf: array[0..15] of Byte;
begin
  M.Clear;

  DoInfo('Random using', clRed);
//------------------------------------------------------------------------------
  DoInfo('1. TRandom_LFSR Instance with Period 2^400-1', clBlue);

  with TRandom_LFSR.Create('', 400, False, nil) do
  try
//------------------------------------------------------------------------------
    DoInfo('20 randomized Integer in Range 1000, Seed "DEC Part I"', clBlue);
    Seed('DEC Part I', 10);
    S := '';
    for I := 1 to 20 do
      S := S + IntToStr( Int(1000) ) + ',';
    SetLength(S, Length(S) -1);
    DoInfo(S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('20 randomized Integer in Range 1000, Seed "DEC ParT I"', clBlue);
    Seed('DEC ParT I', 10);
    S := '';
    for I := 1 to 20 do
      S := S + IntToStr( Int(1000) ) + ',';
    SetLength(S, Length(S) -1);
    DoInfo(S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('20 randomized Integer in Range 1000, default Seed', clBlue);
    Seed('', 0);
    S := '';
    for I := 1 to 20 do
      S := S + IntToStr( Int(1000) ) + ',';
    SetLength(S, Length(S) -1);
    DoInfo(S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('20 randomized Integer in Range 1000, randomized Seed', clBlue);
    Seed('', -1);
    S := '';
    for I := 1 to 20 do
      S := S + IntToStr( Int(1000) ) + ',';
    SetLength(S, Length(S) -1);
    DoInfo(S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('20 randomized Integer in Range -1000 to 1000, randomized Seed', clBlue);
    Seed('', -1);
    S := '';
    for I := 1 to 20 do
      S := S + IntToStr( Int(-1000) ) + ',';
    SetLength(S, Length(S) -1);
    DoInfo(S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('Change Period to 2^2032-1', clGreen);
    Size := 2032;

//------------------------------------------------------------------------------
    DoInfo('20 randomized Integer in Range -1 to 1, randomized Seed', clBlue);
    Seed('', -1);
    S := '';
    for I := 1 to 20 do
      S := S + IntToStr( Int(-1) ) + ',';
    SetLength(S, Length(S) -1);
    DoInfo(S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('randomized Buffer, default Seed', clBlue);
    Seed('', 0);

    Buffer(Buf, SizeOf(Buf));

    DoInfo(StrToFormat(@Buf, Sizeof(Buf), Format), clWindowText);

//------------------------------------------------------------------------------
    DoInfo('randomized Buffer, default Seed with saveing of State', clBlue);
    DoInfo('Switch back to Period 2^128-1', clGreen);
    Size := 128;
// install a Protection, this protect:
// - TRandom.State
// - any with Seed() setted Seed
// - the results from TRandom.Int() and TRandom.Buffer()
// and produce cryptographicaly secure Randomness
    Protection := TCipher_Blowfish.Create('DEC', nil);
    Seed('', -1);       // new randomized Seed, scrambled with Blowfish
    SaveState := State; // save the actual Random State in SaveState, encrypted with Blowfish
    DoInfo('SaveState:' + InsertBlocks(SaveState, #9, #10, 64), clGreen);
// random Buffer
    Buffer(Buf, SizeOf(Buf));

    DoInfo(StrToFormat(@Buf, SizeOf(Buf), Format), clWindowText);

    Seed('', -1); // new randomized Seed
    DoInfo('State restored with SaveState', clGreen);

    State := SaveState;
// random Buffer, another way with a LongString
    SetLength(S, Sizeof(Buf));
    Buffer(PChar(S)^, Length(S));

    DoInfo(StrToFormat(PChar(S), Length(S), Format), clWindowText);

  finally
    Free;
  end;

//------------------------------------------------------------------------------
  DoInfo('2. Global Random Variable "RND"', clBlue);
// RND is per default TRandom_LFSR('', 128);
  RND.Seed('', 0);
  RND.Buffer(Buf, SizeOf(Buf));
  DoInfo(StrToFormat(@Buf, Sizeof(Buf), Format), clWindowText);

//------------------------------------------------------------------------------
  DoInfo('3. TProtection Methods with TRandom_LFSR', clBlue);
  with TRandom_LFSR.Create('DEC', 128, False, nil) do
  try
//------------------------------------------------------------------------------
    DoInfo('En/Decryption with TRandom', clGreen);

    S := CodeString('The nice DEC Part I', paEncode, Format);
    DoInfo('Encrypted:'#9+S, clWindowText);

    S := CodeString(S, paDecode, Format);
    DoInfo('Decrypted:'#9+S, clWindowText);

//------------------------------------------------------------------------------
    DoInfo('Scrambling with TRandom', clGreen);

    S := CodeString('The nice DEC Part I', paScramble, Format);
    DoInfo('Scrambled:'#9+S, clWindowText);

    DoInfo('BasicSeed changed from: '+ SysUtils.Format('$%0.8x to $%0.8x', [BasicSeed, BasicSeed +1]), clGreen);
    BasicSeed := BasicSeed +1; // use another BasicSeed to produce other Outputs

    S := CodeString('The nice DEC Part I', paScramble, Format);
    DoInfo('Scrambled:'#9+S, clWindowText);
    
//------------------------------------------------------------------------------
    DoInfo('Wipe with TRandom', clGreen);
// paWipe is normaly used with CodeBuffer(), CodeFile() and CodeStream()
    S := CodeString('The nice DEC Part I', paWipe, Format);
    DoInfo('Wiped:'#9+S, clWindowText);

    S := CodeString('The nice DEC Part I', paWipe, Format);
    DoInfo('Wiped:'#9+S, clWindowText);

    S := CodeString('The nice DEC Part I', paWipe, Format);
    DoInfo('Wiped:'#9+S, clWindowText);
  finally
    Free;
  end;

end;

end.
