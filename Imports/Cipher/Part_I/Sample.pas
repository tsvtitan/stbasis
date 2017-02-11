unit Sample;
{ Copyright (c) 1999 by Hagen Reddmann
  mailto:HaReddmann@AOL.COM

  This Unit include Sample Classes, Delphi Encryption Compendium Part I

  anonyme Designers, you can see the easy way to implement new cipher's and
  hash's, help me, and implement more, to make this Packages to the biggest.
  }

interface

{$I VER.INC}

uses DECUtil, Hash, Cipher, RNG;

const
  fmtSAMPLE  = 1704;
  fmtHEXVIEW = 1705;

type
  THash_Sample = class(THash){Calculate a Crosssum, german Quersumme ?}
  private
    FDigest: array[0..1] of Integer;
  protected
    class function TestVector: Pointer; override;
  public
    class function DigestKeySize: Integer; override;
    procedure Init; override;
    procedure Calc(const Data; DataSize: Integer); override;
    function DigestKey: Pointer; override;
  end;

  TCipher_Sample = class(TCipher){Borland's String Encryption Method}
  protected
    class procedure GetContext(var ABufSize, AKeySize, AUserSize: Integer); override;
    class function TestVector: Pointer; override;
    procedure Encode(Data: Pointer); override;
    procedure Decode(Data: Pointer); override;
  public
    procedure Init(const Key; Size: Integer; IVector: Pointer); override;
    procedure Done; override;
  end;

// New Sample Stringformat, displays all other registered Formats
  TStringFormat_Sample = class(TStringFormat)
  public
    class function ToStr(Value: PChar; Len: Integer): String; override;
    class function StrTo(Value: PChar; Len: Integer): String; override;
    class function Name: String; override;
    class function Format: Integer; override;
    class function IsValid(Value: PChar; Len: Integer; ToStr: Boolean): Boolean; override;
  end;

  TStringFormat_HEXVIEW = class(TStringFormat)
  public
    class function ToStr(Value: PChar; Len: Integer): String; override;
    class function StrTo(Value: PChar; Len: Integer): String; override;
    class function Name: String; override;
    class function Format: Integer; override;
  end;

implementation

uses SysUtils, Classes, HCMngr;

{this Code is automaticly generated,
 click 'File\Generate Testvector for Hash' and Paste from Clipboard here}
class function THash_Sample.TestVector: Pointer;
asm
         MOV   EAX,OFFSET @Vector
         RET
@Vector: DB    0F3h,0C5h,05Ch,05Ch,005h,000h,000h,000h
end;

class function THash_Sample.DigestKeySize: Integer;
begin
  Result := SizeOf(Integer) * 2;
end;

procedure THash_Sample.Init;
begin
  FillChar(FDigest, SizeOf(FDigest), 0);
end;

procedure THash_Sample.Calc(const Data; DataSize: Integer);
// calculate a Crosssum !??, in german Quersumme
var
  B: PInteger;
  T: Integer;
begin
  B := @Data;
  while DataSize >= SizeOf(Integer) do
  begin
    T := FDigest[0];
    Inc(FDigest[0], B^);
    if FDigest[0] < T then Inc(FDigest[1]);
    Inc(B);
    Dec(DataSize, SizeOf(Integer));
  end;
  if DataSize > 0 then
  begin
    T := 0;
    Move(B^, T, DataSize);
    Inc(FDigest[0], T);
  end;
end;

function THash_Sample.DigestKey: Pointer;
begin
  Result := @FDigest;
end;

{Borland's String Encryption Method}
class procedure TCipher_Sample.GetContext(var ABufSize, AKeySize, AUserSize: Integer);
begin
  ABufSize := 128;
  AKeySize := 6 * SizeOf(Integer);
  AUserSize := 6 * SizeOf(Integer);
end;

{this Code is automaticly generated,
 click 'File\Generate Testvector for Cipher' and Paste from Clipboard here}
class function TCipher_Sample.TestVector: Pointer;
asm
         MOV   EAX,OFFSET @Vector
         RET
@Vector: DB    0F5h,076h,09Ch,08Fh,04Dh,065h,0BEh,0ACh
         DB    019h,08Ch,0B9h,08Ch,000h,0F9h,06Eh,072h
         DB    0D0h,072h,0C7h,018h,03Eh,0C4h,0BEh,007h
         DB    0AFh,013h,0A8h,0B9h,017h,01Ch,05Fh,077h
end;

type
  PSampleKey = ^TSampleKey;
  TSampleKey = packed record
                 StartKey: Integer;
                 MultKey: Integer;
                 AddKey: Integer;
               end;
  PSaveKey = ^TSaveKey;
  TSaveKey = packed record
               WorkKey: TSampleKey;
               SaveKey: TSampleKey;
             end;

procedure TCipher_Sample.Encode(Data: Pointer);
var
  I,T: Integer;
  B: PByte;
begin
  B := Data;
  with PSampleKey(User)^ do
    for I := 1 to BufSize do
    begin
      T  := B^;
      T  := (T xor (StartKey shr 8)) and $FF;
      B^ := T;
      StartKey := (StartKey + T) * MultKey + AddKey;
      Inc(B);
    end;
end;

procedure TCipher_Sample.Decode(Data: Pointer);
var
  I,T: Integer;
  B: PByte;
begin
  B := Data;
  with PSampleKey(User)^ do
    for I := 1 to BufSize do
    begin
      T  := B^;
      B^ := B^ xor StartKey shr 8;
      StartKey := (StartKey + T) * MultKey + AddKey;
      Inc(B);
    end;
end;

procedure TCipher_Sample.Init(const Key; Size: Integer; IVector: Pointer);
const
  DefaultKey : TSampleKey = (StartKey: 981; MultKey: 12674; AddKey: 35891);
begin
  InitBegin(Size);
  Move(DefaultKey, User^, SizeOf(DefaultKey));
  Move(Key, User^, Size);
  InitEnd(IVector);
{Save the Key to SaveKey}
  with PSaveKey(User)^ do Move(WorkKey, SaveKey, SizeOf(WorkKey));
end;

procedure TCipher_Sample.Done;
begin
  inherited Done;
{Restore the WorkKey}
  with PSaveKey(User)^ do Move(SaveKey, WorkKey, SizeOf(SaveKey));
end;

class function TStringFormat_Sample.ToStr(Value: PChar; Len: Integer): String;
begin
  Result := '';
 // here nothing, put code to convert back
end;

class function TStringFormat_Sample.StrTo(Value: PChar; Len: Integer): String;
var
  S: TStringList;
  Fmt: TStringFormatClass;
begin
  Result := '';
  S := TStringList.Create;
  try
    GetStringFormats(S);
    while S.Count > 0 do
    begin
      Fmt := TStringFormatClass(S.Objects[0]);
      S.Delete(0);
      if Fmt.Format = Self.Format then Continue;
      Result := Result + Fmt.Name + ':'#13#10'" ' +
                Fmt.StrTo(Value, Len) + ' "'#13#10#13#10;
    end;
  finally
    S.Free;
  end;
end;

class function TStringFormat_Sample.Name: String;
begin
  Result := 'Sample see Sample.pas';
end;

class function TStringFormat_Sample.Format: Integer;
begin
  Result := fmtSAMPLE;
end;

class function TStringFormat_Sample.IsValid(Value: PChar; Len: Integer; ToStr: Boolean): Boolean;
begin
  Result := True;
// here code to Test any Input of correctness
// if ToStr then      -  convert from Sample Format to String
// if not ToStr then  -  convert from String to Sample Format
end;

class function TStringFormat_HEXVIEW.ToStr(Value: PChar; Len: Integer): String;
var
  P: PChar;
begin
  P := StrScan(Value, ',');
  if P <> nil then Len := P - Value;
  Result := FormatToStr(Value, Len, fmtHEX);
end;

class function TStringFormat_HEXVIEW.StrTo(Value: PChar; Len: Integer): String;

  function CC: String;
  begin
    Result := ',{';
    while Len > 0 do
    begin
      if Value^ in [#0,#1,#8,#9,#10,#13] then Result := Result + '.'
        else Result := Result + Value^;
      Dec(Len);
      Inc(Value);
    end;
    Result := Result + '}';
  end;

begin
  Result := StrToFormat(Value, Len, fmtHEX) + CC;
end;

class function TStringFormat_HEXVIEW.Name: String;
begin
  Result := 'HEX-View, see Sample.pas';
end;

class function TStringFormat_HEXVIEW.Format: Integer;
begin
  Result := fmtHEXVIEW;
end;

initialization
  RegisterHash(THash_Sample, 'Sample Hash', 'see Unit "Sample"');
  RegisterCipher(TCipher_Sample, 'Sample Cipher', 'see Unit "Sample"');
  RegisterStringFormats([TStringFormat_Sample, TStringFormat_HEXVIEW]);
finalization
  UnregisterHash(THash_Sample);
  UnregisterCipher(TCipher_Sample);
end.
