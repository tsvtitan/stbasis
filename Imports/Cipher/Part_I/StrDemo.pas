unit StrDemo;

interface

{$I VER.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DECUtil, Cipher, Hash;

type
  TStringForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EDecoded: TEdit;
    Label7: TLabel;
    EData: TEdit;
    Label8: TLabel;
    CBMode: TComboBox;
    EEncoded: TMemo;
    CBFormats: TComboBox;
    EMD5: TMemo;
    procedure EPasswordChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CBFormatsChange(Sender: TObject);
  private
    FStringFormat: Integer;
  public
    { Public-Deklarationen }
  end;

var
  StringForm: TStringForm;

implementation

{$R *.DFM}

procedure TStringForm.EPasswordChange(Sender: TObject);
var
  R: String;
begin
{calculate a String and give back in FStringFormat }
  EMD5.Text := THash_MD5.CalcString(EPassword.Text, nil, FStringFormat);

{Encrypt the Data}
  with TCipher_Blowfish.Create(EPassword.Text, nil) do
  try
    Mode := TCipherMode(CBMode.ItemIndex);
    R := CodeString(EData.Text, paEncode, FStringFormat);
    EEncoded.Text := R;

{or this, restart all}
//    InitKey(EPassword.Text, nil);

    EDecoded.Text := CodeString(R, paDecode, FStringFormat);
  finally
    Free;
  end;
end;

procedure TStringForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TStringForm.FormCreate(Sender: TObject);
begin
  GetStringFormats(CBFormats.Items);
  CBMode.ItemIndex := 0;
  CBFormats.ItemIndex := 0;
  CBFormatsChange(nil);
end;

procedure TStringForm.CBFormatsChange(Sender: TObject);
begin
  with CBFormats, Items do
    FStringFormat := TStringFormatClass(Objects[ItemIndex]).Format;
  EPasswordChange(nil);
end;

end.
