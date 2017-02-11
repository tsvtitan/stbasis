{Copyright:      Hagen Reddmann  mailto:HaReddmann@AOL.COM
 Author:         Hagen Reddmann
 Remarks:        freeware, but this Copyright must included
 known Problems: none
 Version:        3.0,  Part I from Delphi Encryption Compendium
                 Delphi 2-4, designed and testet under D3 and D4
 Description:    Low Level API Routines for Cipher and Hash

 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

                 }
unit DEC_api;

interface

{$I VER.INC}

uses Windows;

type
  TCipherHandle = Integer;
  THashHandle   = Integer;
  TEnumProc     = function(Name: PChar; ID, MaxKeySize: Integer; Data: Pointer): Bool; stdcall;

const
{Cipher Modes for Cipher_Create()}
  cm_CTS        = 0;
  cm_CBC        = 1;
  cm_CFB        = 2;
  cm_OFB        = 3;
  cm_ECB        = 4;

function Cipher_GetID(Name: PChar): Integer; stdcall;
function Cipher_Create(ID, Mode: Integer): TCipherHandle; stdcall;
function Cipher_Delete(Handle: TCipherHandle): Integer; stdcall;
function Cipher_Encode(Handle: TCipherHandle; Source, Dest: PChar; Size: Integer): Integer; stdcall;
function Cipher_Decode(Handle: TCipherHandle; Source, Dest: PChar; Size: Integer): Integer; stdcall;
function Cipher_Init(Handle: TCipherHandle; Key: Pointer; KeyLen: Integer; IVector: Pointer): Integer; stdcall;
function Cipher_InitKey(Handle: TCipherHandle; Key: PChar; IVector: Pointer): Integer; stdcall;
function Cipher_Done(Handle: TCipherHandle): Integer; stdcall;
function Cipher_Protect(Handle: TCipherHandle): Integer; stdcall;
function Cipher_GetMaxKeySize(Handle: TCipherHandle): Integer; stdcall;
function Cipher_SetHash(Handle: TCipherHandle; Hash_ID: Integer): Integer; stdcall;
function Cipher_GetHash(Handle: TCipherHandle): Integer; stdcall;
procedure Cipher_EnumNames(Proc: TEnumProc; UserData: Pointer); stdcall;

function Hash_GetID(Name: PChar): Integer; stdcall;
function Hash_Create(ID: Integer): THashHandle; stdcall;
function Hash_Delete(Handle: THashHandle): Integer; stdcall;
function Hash_Init(Handle: THashHandle): Integer; stdcall;
function Hash_Done(Handle: THashHandle; Digest: PChar; DigestSize: Integer): Integer; stdcall;
function Hash_Update(Handle: THashHandle; Source: PChar; SourceLen: Integer): Integer; stdcall;
function Hash_GetMaxDigestSize(Handle: THashHandle): Integer; stdcall;
function Hash_CalcFile(ID: Integer; FileName, Digest: PChar; MaxDigestLen: Integer): Integer; stdcall;
procedure Hash_EnumNames(Proc: TEnumProc; UserData: Pointer); stdcall;

{give back 0 when Ok otherwise the required Size for Dest}
function StrToBase64(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall;
function Base64ToStr(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall;
function StrToBase16(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall;
function Base16ToStr(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall;

{using Hash

var
  Handle: THashHandle;
  Digest: Pointer;
  DigestSize: Integer;
begin
  Handle := Hash_Create(3);  // for SHA1
  try
    DigestSize := Hash_GetMaxDigestSize(Handle);
    Digest := GetMem(DigestSize);
    Hash_Init(Handle);
    Hash_Update(Handle, Data, DataSize);
    Hash_Done(Handle, Digest, DigestSize);
  finally
    Hash_Delete(Handle);
    FreeMem(Digest, DigestSize);
  end;
end;

using Cipher

var
  Handle: TCipherHandle;
begin
  Handle := Cipher_Create(1); // for Blowfish
  try
    Cipher_SetHash(Handle, 14);  // for Tiger, default is SHA1
    Cipher_InitKey(Handle, 'Password', nil);
    Cipher_Encode(Handle, Data, Data, DataSize);
  finally
    Cipher_Delete(Handle);
  end;
end;

}
implementation

uses SysUtils, Classes, DECUtil, Hash, Cipher, Cipher1;

const
  FCipherList: TStringList = nil;
  FHashList: TStringList = nil;

function StrToBase64(Dest, Source: PChar; Len, MaxLen: Integer): Integer;
var
  S: String;
begin
  Result := -1;
  if Source <> nil then
  begin
    S := DECUtil.StrToBase64(Source, Len);
    Result := Length(S);
    if (Dest <> nil) and (MaxLen >= Result) then
    begin
      Result := 0;
      FillChar(Dest^, MaxLen, 0);
      StrPLCopy(Dest, S, MaxLen);
    end;
  end;
end;

function Base64ToStr(Dest, Source: PChar; Len, MaxLen: Integer): Integer;
var
  S: String;
begin
  Result := -1;
  if Source <> nil then
  begin
    S := DECUtil.Base64ToStr(Source, Len);
    Result := Length(S);
    if (Dest <> nil) and (MaxLen >= Result) then
    begin
      Result := 0;
      FillChar(Dest^, MaxLen, 0);
      StrPLCopy(Dest, S, MaxLen);
    end;
  end;
end;

function StrToBase16(Dest, Source: PChar; Len, MaxLen: Integer): Integer;
var
  S: String;
begin
  Result := -1;
  if Source <> nil then
  begin
    S := DECUtil.StrToBase16(Source, Len);
    Result := Length(S);
    if (Dest <> nil) and (MaxLen >= Result) then
    begin
      Result := 0;
      FillChar(Dest^, MaxLen, 0);
      StrPLCopy(Dest, S, MaxLen);
    end;
  end;
end;

function Base16ToStr(Dest, Source: PChar; Len, MaxLen: Integer): Integer;
var
  S: String;
begin
  Result := -1;
  if Source <> nil then
  begin
    S := DECUtil.Base16ToStr(Source, Len);
    Result := Length(S);
    if (Dest <> nil) and (MaxLen >= Result) then
    begin
      Result := 0;
      FillChar(Dest^, MaxLen, 0);
      StrPLCopy(Dest, S, MaxLen);
    end;
  end;
end;

function IsObject(AObject: Integer; AClass: TClass): Boolean;
var
  E: Pointer;
begin
  Result := False;
  if AObject = 0 then Exit;
  E := ExceptionClass;
  ExceptionClass := nil;
  try
    if (PInteger(PChar(AObject) - SizeOf(Integer))^ and $00000002 = $00000002) and
       (TObject(AObject) is AClass) then Result := True;
  except
  end;
  ExceptionClass := E;
end;

function Cipher_GetID(Name: PChar): Integer;
begin
  Result := FCipherList.IndexOf(Name);
end;

function Cipher_Create(ID, Mode: Integer): TCipherHandle;
begin
  if (ID >= 0) and (ID < FCipherList.Count) then
  begin
    if TCipherClass(FCipherList.Objects[ID]).SelfTest then
    begin
      Result := Integer(TCipherClass(FCipherList.Objects[ID]).Create);
      Mode := Mode and $F;
      if Mode > 4 then Mode := 0;
      TCipher(Result).Mode := TCipherMode(Mode);
    end else Result := -2;
  end else Result := -1;
end;

function Cipher_Delete(Handle: TCipherHandle): Integer;
begin
  Result := 0;
  if IsObject(Handle, TCipher) then TCipher(Handle).Free else Result := -1
end;

function Cipher_Encode(Handle: TCipherHandle; Source, Dest: PChar; Size: Integer): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    if TCipher(Handle).Initialized then
    begin
      TCipher(Handle).EncodeBuffer(Source^, Dest^, Size);
      Result := 0;
    end else Result := -2;
  end else Result := -1;
end;

function Cipher_Decode(Handle: TCipherHandle; Source, Dest: PChar; Size: Integer): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    if TCipher(Handle).Initialized then
    begin
      TCipher(Handle).DecodeBuffer(Source^, Dest^, Size);
      Result := 0;
    end else Result := -2;
  end else Result := -1;
end;

function Cipher_Init(Handle: TCipherHandle; Key: Pointer; KeyLen: Integer; IVector: Pointer): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    TCipher(Handle).Init(Key^, KeyLen, IVector);
    Result := 0;
  end else Result := -1;
end;

function Cipher_InitKey(Handle: TCipherHandle; Key: PChar; IVector: Pointer): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    TCipher(Handle).InitKey(Key, IVector);
    Result := 0;
  end else Result := -1;
end;

function Cipher_Done(Handle: TCipherHandle): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    TCipher(Handle).Done;
    Result := 0;
  end else Result := -1;
end;

function Cipher_Protect(Handle: TCipherHandle): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    TCipher(Handle).Protect;
    Result := 0;
  end else Result := -1;
end;

function Cipher_GetMaxKeySize(Handle: TCipherHandle): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then Result := TCipher(Handle).MaxKeySize
    else Result := -1;
end;

function Cipher_SetHash(Handle: TCipherHandle; Hash_ID: Integer): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
  begin
    if (Hash_ID >= 0) and (Hash_ID < FHashList.Count) then
      TCipher(Handle).HashClass := THashClass(FHashList.Objects[Hash_ID]);
  end else Result := -1;
end;

function Cipher_GetHash(Handle: TCipherHandle): Integer;
begin
  Result := -3;
  if IsObject(Handle, TCipher) then
    Result := FHashList.IndexOfObject(Pointer(TCipher(Handle).HashClass))
  else Result := -1;
end;

procedure Cipher_EnumNames(Proc: TEnumProc; UserData: Pointer);
var
  I: Integer;
begin
  for I := 0 to FCipherList.Count-1 do
    if not Proc(PChar(FCipherList[I]), I, TCipherClass(FCipherList.Objects[I]).MaxKeySize, UserData) then Break;
end;

function Hash_GetID(Name: PChar): Integer;
begin
  Result := FHashList.IndexOf(Name);
end;

function Hash_Create(ID: Integer): THashHandle;
begin
  if (ID >= 0) and (ID < FHashList.Count) then
  begin
    if THashClass(FHashList.Objects[ID]).SelfTest then
      Result := Integer(THashClass(FHashList.Objects[ID]).Create)
    else Result := -2;
  end else Result := -1;
end;

function Hash_Delete(Handle: THashHandle): Integer;
begin
  Result := 0;
  if IsObject(Handle, THash) then THash(Handle).Free else Result := -1
end;

function Hash_Init(Handle: THashHandle): Integer;
begin
  Result := -3;
  if IsObject(Handle, THash) then
  begin
    THash(Handle).Init;
    Result := 0;
  end else Result := -1
end;

function Hash_Done(Handle: THashHandle; Digest: PChar; DigestSize: Integer): Integer;
begin
  Result := -3;
  if IsObject(Handle, THash) then
  begin
    THash(Handle).Done;
    FillChar(Digest^, DigestSize, 0);
    if DigestSize > THash(Handle).DigestKeySize then DigestSize := THash(Handle).DigestKeySize;
    Move(THash(Handle).DigestKey^, Digest^, DigestSize);
    Result := 0;
  end else Result := -1
end;

function Hash_Update(Handle: THashHandle; Source: PChar; SourceLen: Integer): Integer;
begin
  Result := -3;
  if IsObject(Handle, THash) then
  begin
    THash(Handle).Calc(Source^, SourceLen);
    Result := 0;
  end else Result := -1
end;

function Hash_GetMaxDigestSize(Handle: THashHandle): Integer;
begin
  Result := -3;
  if IsObject(Handle, THash) then Result := THash(Handle).DigestKeySize
    else Result := -1
end;

function Hash_CalcFile(ID: Integer; FileName, Digest: PChar; MaxDigestLen: Integer): Integer; stdcall;
begin
  Result := -5;
  if (FileName = nil) or not FileExists(FileName) then Exit;
  Result := -1;
  if (ID < 0) or (ID >= FHashList.Count) then Exit;
  Result := -2;
  if not THashClass(FHashList.Objects[ID]).SelfTest then Exit;
  Result := -3;
  if (MaxDigestLen < THashClass(FHashList.Objects[ID]).DigestKeySize) or
     (Digest = nil) then Exit;
  try
    FillChar(Digest^, MaxDigestLen, 0);
    THashClass(FHashList.Objects[ID]).CalcFile(Digest, FileName);
    Result := THashClass(FHashList.Objects[ID]).DigestKeySize;
  except
    Result := -4;
  end;
end;

procedure Hash_EnumNames(Proc: TEnumProc; UserData: Pointer);
var
  I: Integer;
begin
  for I := 0 to FHashList.Count-1 do
    if not Proc(PChar(FHashList[I]), I, THashClass(FHashList.Objects[I]).DigestKeySize, UserData) then Break;
end;


exports
  Cipher_GetID,
  Cipher_Create,
  Cipher_Delete,
  Cipher_Encode,
  Cipher_Decode,
  Cipher_Init,
  Cipher_InitKey,
  Cipher_Done,
  Cipher_Protect,
  Cipher_GetMaxKeySize,
  Cipher_SetHash,
  Cipher_GetHash,
  Cipher_EnumNames,

  Hash_GetID,
  Hash_Create,
  Hash_Delete,
  Hash_Init,
  Hash_Done,
  Hash_Update,
  Hash_GetMaxDigestSize,
  Hash_CalcFile,
  Hash_EnumNames,

  StrToBase64,
  Base64ToStr,
  StrToBase16,
  Base16ToStr;


initialization
  FCipherList := TStringList.Create;
  FHashList := TStringList.Create;
  with FCipherList do
  begin
    AddObject('3Way', Pointer(TCipher_3Way));
    AddObject('Blowfish', Pointer(TCipher_Blowfish));
    AddObject('Cast128', Pointer(TCipher_Cast128));
    AddObject('Cast256', Pointer(TCipher_Cast256));
    AddObject('1DES', Pointer(TCipher_1DES));
    AddObject('2DES', Pointer(TCipher_2DES));
    AddObject('2DDES', Pointer(TCipher_2DDES));
    AddObject('3DES', Pointer(TCipher_3DES));
    AddObject('3DDES', Pointer(TCipher_3DDES));
    AddObject('3TDES', Pointer(TCipher_3TDES));
    AddObject('DESX', Pointer(TCipher_DESX));
    AddObject('Diamond2', Pointer(TCipher_Diamond2));
    AddObject('Diamond2Lite', Pointer(TCipher_Diamond2Lite));
    AddObject('FROG', Pointer(TCipher_FROG));
    AddObject('Gost', Pointer(TCipher_Gost));
    AddObject('IDEA', Pointer(TCipher_IDEA));
    AddObject('Mars', Pointer(TCipher_Mars));
    AddObject('Misty1', Pointer(TCipher_Misty));
    AddObject('NewDES', Pointer(TCipher_NewDES));
    AddObject('Q128', Pointer(TCipher_Q128));
    AddObject('RC2', Pointer(TCipher_RC2));
    AddObject('RC4', Pointer(TCipher_RC4));
    AddObject('RC5', Pointer(TCipher_RC5));
    AddObject('RC6', Pointer(TCipher_RC6));
    AddObject('Rijndael', Pointer(TCipher_Rijndael));
    AddObject('SAFER-K40', Pointer(TCipher_SAFER_K40));
    AddObject('SAFER-SK40', Pointer(TCipher_SAFER_SK40));
    AddObject('SAFER-K64', Pointer(TCipher_SAFER_K64));
    AddObject('SAFER-SK64', Pointer(TCipher_SAFER_SK64));
    AddObject('SAFER-K128', Pointer(TCipher_SAFER_K128));
    AddObject('SAFER-SK128', Pointer(TCipher_SAFER_SK128));
    AddObject('Sapphire', Pointer(TCipher_Sapphire));
    AddObject('SCOP', Pointer(TCipher_SCOP));
    AddObject('Shark', Pointer(TCipher_Shark));
    AddObject('Skipjack', Pointer(TCipher_Skipjack));
    AddObject('Square', Pointer(TCipher_Square));
    AddObject('TEA', Pointer(TCipher_TEA));
    AddObject('TEAN', Pointer(TCipher_TEAN));
    AddObject('Twofish', Pointer(TCipher_Twofish));
  end;
  with FHashList do
  begin
    AddObject('MD4', Pointer(THash_MD4));
    AddObject('MD5', Pointer(THash_MD5));
    AddObject('SHA', Pointer(THash_SHA));
    AddObject('SHA1', Pointer(THash_SHA1));
    AddObject('RMD128', Pointer(THash_RipeMD128));
    AddObject('RMD160', Pointer(THash_RipeMD160));
    AddObject('RMD256', Pointer(THash_RipeMD256));
    AddObject('RMD320', Pointer(THash_RipeMD320));
    AddObject('Haval128', Pointer(THash_Haval128));
    AddObject('Haval160', Pointer(THash_Haval160));
    AddObject('Haval192', Pointer(THash_Haval192));
    AddObject('Haval224', Pointer(THash_Haval224));
    AddObject('Haval256', Pointer(THash_Haval256));
    AddObject('Sapphire128', Pointer(THash_Sapphire128));
    AddObject('Sapphire160', Pointer(THash_Sapphire160));
    AddObject('Sapphire192', Pointer(THash_Sapphire192));
    AddObject('Sapphire224', Pointer(THash_Sapphire224));
    AddObject('Sapphire256', Pointer(THash_Sapphire256));
    AddObject('Sapphire288', Pointer(THash_Sapphire288));
    AddObject('Sapphire320', Pointer(THash_Sapphire320));
    AddObject('Snefru', Pointer(THash_Snefru));
    AddObject('Square', Pointer(THash_Square));
    AddObject('Tiger', Pointer(THash_Tiger));
    AddObject('XOR16', Pointer(THash_XOR16));
    AddObject('XOR32', Pointer(THash_XOR32));
    AddObject('CRC32', Pointer(THash_CRC32));
    AddObject('CRC16C', Pointer(THash_CRC16_CCITT));
    AddObject('CRC16S', Pointer(THash_CRC16_Standard));
  end;
finalization
  FCipherList.Free;
  FHashList.Free;
end.
