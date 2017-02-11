unit IVDemo;

interface

{$I VER.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DECUtil, Hash, Cipher;

type
  TIVForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EEncPass1: TEdit;
    Label3: TLabel;
    EEncPass2: TEdit;
    Label4: TLabel;
    EData: TEdit;
    Encrypted: TLabel;
    EEncrypted: TEdit;
    Label5: TLabel;
    EDecPass1: TEdit;
    Label6: TLabel;
    EDecPass2: TEdit;
    Label8: TLabel;
    EDecrypted: TEdit;
    Label9: TLabel;
    Bevel1: TBevel;
    Label10: TLabel;
    Bevel2: TBevel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoCalc(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  IVForm: TIVForm;

implementation

{$R *.DFM}

procedure TIVForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TIVForm.DoCalc(Sender: TObject);
var
  IV: array[0..127] of Byte; {must be large enough}
  R: String;
begin
  FillChar(IV, SizeOf(IV), 0);
{build the IVector from Encryption Password One, can you see as a secret Password}
  with TCipher_IDEA.Create(EEncPass1.Text, nil) do
  try
    CodeString(EEncPass1.Text, paEncode, -1); {or other Data, i.E. Companyname}
    Move(Feedback^, IV, BufSize);
  finally
    Free;
  end;
{now, encrypt the Data with Password Two}
  with TCipher_Blowfish.Create('', nil) do
  try
    InitKey(EEncPass2.Text, @IV);
    R := CodeString(EData.Text, paEncode, -1);
    EEncrypted.Text := R;
  finally
    Free;
  end;

{and now back}

{build the IVector from Decryption Password One}
  with TCipher_IDEA.Create(EDecPass1.Text, nil) do
  try
    CodeString(EDecPass1.Text, paEncode, -1);
    Move(Feedback^, IV, BufSize);
  finally
    Free;
  end;

{now, decrypt the Cipher with Password Two}
  with TCipher_Blowfish.Create('', nil) do
  try
    InitKey(EDecPass2.Text, @IV);
    EDecrypted.Text := CodeString(R, paDecode, -1);
  finally
    Free;
  end;

end;

end.
