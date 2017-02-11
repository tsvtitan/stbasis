unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    PHash: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Algorithm: TLabel;
    CBHash: TComboBox;
    EHashFile: TEdit;
    Label2: TLabel;
    BtnHashFile: TBitBtn;
    BtnCalcHash: TBitBtn;
    OpenDialog: TOpenDialog;
    LhashInfo: TLabel;
    Label3: TLabel;
    EDigest: TEdit;
    PCipher: TPanel;
    Label4: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    CBCipher: TComboBox;
    Label6: TLabel;
    ECipherFile: TEdit;
    BtnCipherFile: TBitBtn;
    BtnCalcCipher: TBitBtn;
    LCipherInfo: TLabel;
    EPassword: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    EHashInput: TEdit;
    Label9: TLabel;
    EHashENC: TEdit;
    Label10: TLabel;
    EhashDEC: TEdit;
    CBMode: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnHashFileClick(Sender: TObject);
    procedure BtnCalcHashClick(Sender: TObject);
    procedure BtnCipherFileClick(Sender: TObject);
    procedure BtnCalcCipherClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{Imports Prototypes from DEC1.DLL}

const
  DEC1DLL = 'DEC1.DLL';

type
  TCipherHandle = Integer;
  THashHandle   = Integer;
  TEnumProc     = function(const Name: PChar; ID, MaxKeySize: Integer; Data: Pointer): Bool; stdcall;

const
{Cipher Modes for Cipher_Create()}
  cm_CTS        = 0;
  cm_CBC        = 1;
  cm_CFB        = 2;
  cm_OFB        = 3;
  cm_ECB        = 4;

function Cipher_GetID(Name: PChar): Integer; stdcall; external DEC1DLL;
function Cipher_Create(ID, Mode: Integer): TCipherHandle; stdcall; external DEC1DLL;
function Cipher_Delete(Handle: TCipherHandle): Integer; stdcall; external DEC1DLL;
function Cipher_Encode(Handle: TCipherHandle; Source, Dest: PChar; Size: Integer): Integer; stdcall; external DEC1DLL;
function Cipher_Decode(Handle: TCipherHandle; Source, Dest: PChar; Size: Integer): Integer; stdcall; external DEC1DLL;
function Cipher_Init(Handle: TCipherHandle; Key: Pointer; KeyLen: Integer; IVector: Pointer): Integer; stdcall; external DEC1DLL;
function Cipher_InitKey(Handle: TCipherHandle; Key: PChar; IVector: Pointer): Integer; stdcall; external DEC1DLL;
function Cipher_Done(Handle: TCipherHandle): Integer; stdcall; external DEC1DLL;
function Cipher_Protect(Handle: TCipherHandle): Integer; stdcall; external DEC1DLL;
function Cipher_GetMaxKeySize(Handle: TCipherHandle): Integer; stdcall; external DEC1DLL;
function Cipher_SetHash(Handle: TCipherHandle; Hash_ID: Integer): Integer; stdcall; external DEC1DLL;
function Cipher_GetHash(Handle: TCipherHandle): Integer; stdcall; external DEC1DLL;
procedure Cipher_EnumNames(Proc: TEnumProc; UserData: Pointer); stdcall; external DEC1DLL;

function Hash_GetID(Name: PChar): Integer; stdcall; external DEC1DLL;
function Hash_Create(ID: Integer): THashHandle; stdcall; external DEC1DLL;
function Hash_Delete(Handle: THashHandle): Integer; stdcall; external DEC1DLL;
function Hash_Init(Handle: THashHandle): Integer; stdcall; external DEC1DLL;
function Hash_Done(Handle: THashHandle; Digest: PChar; DigestSize: Integer): Integer; stdcall; external DEC1DLL;
function Hash_Update(Handle: THashHandle; Source: PChar; SourceLen: Integer): Integer; stdcall; external DEC1DLL;
function Hash_GetMaxDigestSize(Handle: THashHandle): Integer; stdcall; external DEC1DLL;
function Hash_CalcFile(ID: Integer; FileName, Digest: PChar; MaxDigestLen: Integer): Integer; stdcall; external DEC1DLL;
procedure Hash_EnumNames(Proc: TEnumProc; UserData: Pointer); stdcall; external DEC1DLL;

function StrToBase64(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall; external DEC1DLL;
function Base64ToStr(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall; external DEC1DLL;
function StrToBase16(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall; external DEC1DLL;
function Base16ToStr(Dest, Source: PChar; Len, MaxLen: Integer): Integer; stdcall; external DEC1DLL;

{end Imports}

procedure TMainForm.FormCreate(Sender: TObject);

  function EnumHash(const Name: PChar; ID, MaxKeySize: Integer; Combo: TComboBox): Bool; stdcall;
  {enum iterates from ID=0 to HashCount-1}
  begin
    Result := True;
    Combo.Items.AddObject(Name, Pointer(MaxKeySize));
  end;

  function EnumCipher(const Name: PChar; ID, MaxKeySize: Integer; Combo: TComboBox): Bool; stdcall;
  begin
    Result := True;
    Combo.Items.AddObject(Name, Pointer(MaxKeySize));
  end;

begin
  EHashFile.Text := ParamStr(0);
  ECipherFile.Text := ParamStr(0);

  Hash_EnumNames(@EnumHash, CBHash);
  CBHash.ItemIndex := 0;
  BtnCalcHashClick(nil);

  Cipher_EnumNames(@EnumCipher, CBCipher);
  CBCipher.ItemIndex := 0;
  CBMode.ItemIndex := 0;
  BtnCalcCipherClick(nil);
end;

procedure TMainForm.BtnHashFileClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    EHashFile.Text := OpenDialog.FileName;
    BtnCalcHashClick(nil);
  end;
end;

procedure TMainForm.BtnCalcHashClick(Sender: TObject);
var
  Handle: THashHandle;
  Len: Integer;
  S: TFileStream;
  Buffer: array[0..1023] of Char;
  Digest: String;
begin
  if FileExists(EHashFile.Text) and (CBHash.ItemIndex >= 0) then
  begin
    Len := Integer(CBHash.Items.Objects[CBHash.ItemIndex]);
    LHashInfo.Caption := Format('DigestSize: %d bytes, %d bits', [Len, Len * 8]);
    SetLength(Digest, Len);

    Handle := Hash_Create(CBHash.ItemIndex);
    if Hash_Init(Handle) = 0 then
    try
      S := TFileStream.Create(EHashFile.Text, fmOpenRead or fmShareDenyNone);
      try
        repeat
          Len := S.Read(Buffer, Sizeof(Buffer));
          Hash_Update(Handle, Buffer, Len);
        until Len <= 0;
        Hash_Done(Handle, PChar(Digest), Length(Digest));

        StrToBase16(Buffer, PChar(Digest), Length(Digest), SizeOf(Buffer));
        EDigest.Text := StrPas(Buffer);
      finally
        S.Free;
      end;
    finally
      Hash_Delete(Handle);
    end else EDigest.Text := 'Init Error';
  end;
end;

procedure TMainForm.BtnCipherFileClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    ECipherFile.Text := OpenDialog.FileName;
    BtnCalcCipherClick(nil);
  end;
end;

procedure TMainForm.BtnCalcCipherClick(Sender: TObject);

  procedure HashBase64(const FileName: String; Output: TEdit);
  var
    Digest: String;
    Len: Integer;
  begin
    SetLength(Digest, 1024);
    Len := Hash_CalcFile(CBHash.ItemIndex, PChar(FileName), PChar(Digest), Length(Digest));
    if (Len > 0) and (StrToBase64(PChar(Digest), PChar(Digest), Len, Length(Digest)) = 0) then
      Output.Text := Digest
    else Output.Text := 'Error';
  end;

var
  Len: Integer;
  Handle: TCipherHandle;
  S,D: TFileStream;
  Buffer: array[0..1023] of Char;
begin
  if FileExists(ECipherFile.Text) and (CBCipher.ItemIndex >= 0) then
  try
    Screen.Cursor := crHourGlass;
    
    Len := Integer(CBCipher.Items.Objects[CBCipher.ItemIndex]);
    LCipherInfo.Caption := Format('MaxKeySize: %d bytes, %d bits', [Len, Len * 8]);

{create a Cipher}
    Handle := Cipher_Create(CBCipher.ItemIndex, CBMode.ItemIndex);
{set the Key Hash to selected Hash, default is SHA1}
    Cipher_SetHash(Handle, CBHash.ItemIndex);
    try
{set the Passphrase}
      Cipher_InitKey(Handle, PChar(EPassword.Text), nil);
{open Source & Desfile, read in, encode}
      S := nil;
      D := nil;
      try
        S := TFileStream.Create(ECipherFile.Text, fmOpenRead or fmShareDenyNone);
        D := TFileStream.Create(ChangeFileExt(ParamStr(0), '.ENC'), fmCreate);
        repeat
          Len := S.Read(Buffer, SizeOf(Buffer));
          Cipher_Encode(Handle, Buffer, Buffer, Len);
          D.Write(Buffer, Len);
        until Len <= 0;
      finally
        Cipher_Protect(Handle);
        S.Free;
        D.Free;
      end;
{and now back, decode}
      Cipher_InitKey(Handle, PChar(EPassword.Text), nil);
      S := nil;
      D := nil;
      try
        S := TFileStream.Create(ChangeFileExt(ParamStr(0), '.ENC'), fmOpenRead or fmShareDenyNone);
        D := TFileStream.Create(ChangeFileExt(ParamStr(0), '.DEC'), fmCreate);
        repeat
          Len := S.Read(Buffer, SizeOf(Buffer));
          Cipher_Decode(Handle, Buffer, Buffer, Len);
          D.Write(Buffer, Len);
        until Len <= 0;
      finally
        Cipher_Protect(Handle);
        S.Free;
        D.Free;
      end;
    finally
      Cipher_Delete(Handle);
    end;

{check the work}
    HashBase64(ECipherFile.Text, EHashInput);
    HashBase64(ChangeFileExt(ParamStr(0), '.ENC'), EHashENC);
    HashBase64(ChangeFileExt(ParamStr(0), '.DEC'), EHashDEC);
    if EHashInput.Text <> EHashDEC.Text then EHashDEC.Color := clRed
      else EHashDEC.Color := clWindow;
  finally
    Screen.Cursor := crDefault;    
  end;
end;

end.
