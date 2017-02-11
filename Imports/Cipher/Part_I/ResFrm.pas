{ Copyright (c) 1999 by Hagen Reddmann
  mailto:HaReddmann@AOL.COM

  This is the Resourcecheck Demonstration for Demo, Delphi Encryption Compendium Part I
  and demonstrate the conventional using from any THash_XXXX without THashManager.
  The routine iterates over all Resources in this Demo and calculate a Fingerprint,
  any modification will detected :-)
  other way is

  CheckEXE := THash_XXXX.CalcFile(nil, ParamStr(0), nil, fmtDEFAULT);

  to perfrom any modification from the EXE. it's not easy ? :-)

  }
unit ResFrm;

interface

{$I VER.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DECUtil;

type
  TCheckResForm = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    LOriginal: TLabel;
    LActual: TLabel;
    LInfo: TLabel;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  CheckResForm: TCheckResForm;

implementation

{$R *.DFM}

uses IniFiles, Hash, Cipher;

{enumerate over all Resources and calculate the Hash-Digest as MAC}
function EnumResHash(Module: hModule; Name: PChar; Hash: Integer): Bool; stdcall;

  function EnumNames(Module: hModule; ResType, ResName: PChar; Hash: THash): Bool; stdcall;
  var
    ResInfo,ResHandle: THandle;
    ResData: Pointer;
  begin
    Result := True;
    ResInfo := FindResource(Module, ResName, ResType);
    if ResInfo = 0 then Exit;
    ResHandle := LoadResource(Module, ResInfo);
    if ResHandle = 0 then Exit;
    ResData := LockResource(ResHandle);
    if ResData <> nil then
      Hash.Calc(ResData^, SizeOfResource(Module, ResInfo));
    UnlockResource(ResHandle);
    FreeResource(ResHandle);
  end;

begin
  Result := True;
  EnumResourceNames(Module, Name, @EnumNames, Hash);
end;

{this use a Cipher in MAC Mode}
function EnumResCipher(Module: hModule; Name: PChar; Cipher: Integer): Bool; stdcall;

  function EnumNames(Module: hModule; ResType, ResName: PChar; Cipher: TCipher): Bool; stdcall;
  var
    ResInfo,ResHandle: THandle;
    ResData: Pointer;
  begin
    Result := True;
    if not (Cipher.Mode in [cmCBCMAC, cmCTSMAC, cmCFBMAC]) then Exit;
    ResInfo := FindResource(Module, ResName, ResType);
    if ResInfo = 0 then Exit;
    ResHandle := LoadResource(Module, ResInfo);
    if ResHandle = 0 then Exit;
    ResData := LockResource(ResHandle);
    if ResData <> nil then
//      Cipher.EncodeBuffer(ResData^, NullStr, SizeOfResource(Module, ResInfo));
      Cipher.CodeBuffer(ResData^, SizeOfResource(Module, ResInfo), paCalc);
    UnlockResource(ResHandle);
    FreeResource(ResHandle);
  end;

begin
  Result := True;
  EnumResourceNames(Module, Name, @EnumNames, Cipher);
end;

procedure TCheckResForm.FormActivate(Sender: TObject);
var
  Hash: THash;
//  Cipher: TCipher;
begin
{Disable Memo without changing Textcolor}
  SetWindowLong(Memo1.Handle, gwl_Style, GetWindowLong(Memo1.Handle, gwl_Style) or ws_Disabled);
{load the Original Digest from INI-File}
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.INI')) do
  try
    LOriginal.Caption := ReadString('System', 'Digest', '');
  finally
    Free;
  end;
  Update;

{This check a modification in chaining mode with a Hash and
 demonstrate the work of a HMAC Algorithm, Haval-Blowfish-HMAC.
 HMAC = Hash Message Authentication Code}
  Hash := THash_Haval192.Create(TCipher_Blowfish.Create('Your Password here', nil));
  try
    Hash.Init;
{$IFDEF VER_D3H}
    EnumResourceTypes(MainInstance, @EnumResHash, Integer(Hash));
{$ELSE}
    EnumResourceTypes(HInstance, @EnumResHash, Integer(Hash));
{$ENDIF}
    Hash.Done;
    LActual.Caption := Hash.DigestStr(fmtDEFAULT);
  finally
    Hash.Free;
  end;

{this check a modification in chaining mode with a Cipher as CBC-MAC.
 CBCMAC = Cipher Block Chaining Message Authentication Code}
{  Cipher := TCipher_GOST.Create('Your Password here', nil);
  try
    Cipher.Mode := cmCBCMAC;
    EnumResourceTypes(MainInstance, @EnumResCipher, Integer(Cipher));
// set a second protection before calculate the MAC, Password must be set
//    Cipher.Protection := TCipher_Blowfish.Create('Your second Password here', nil);
    LActual.Caption := Cipher.CalcMAC(fmtDEFAULT);
  finally
    Cipher.Free;
  end;}

{Message for You}
  if LActual.Caption = LOriginal.Caption then LInfo.Caption := 'You have NOT modified'
    else LInfo.Caption := 'You have modified';
end;

procedure TCheckResForm.Button1Click(Sender: TObject);
begin
{Save the current calculated Digest as original Digest}
  with TIniFile.Create(ChangeFileExt(ParamStr(0), '.INI')) do
  try
    WriteString('System', 'Digest', LActual.Caption);
  finally
    Free;
  end;
  LOriginal.Caption := LActual.Caption;
  LInfo.Caption := 'Calculated Digest is saved as Original Digest !';
end;

end.
