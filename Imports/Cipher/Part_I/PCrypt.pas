unit PCrypt;

interface

{$I VER.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Cipher, DECUtil;

type
  TPartForm = class(TForm)
    EPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EData: TMemo;
    Label3: TLabel;
    BtnEncrypt: TButton;
    BtnDecrypt: TButton;
    Label4: TLabel;
    LSize: TLabel;
    Label5: TLabel;
    LDigest: TLabel;
    procedure BtnEncryptClick(Sender: TObject);
    procedure BtnDecryptClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FStartPos: Integer;
    FMemory: TMemoryStream;
  public
  end;

var
  PartForm: TPartForm;

implementation

{$R *.DFM}


procedure TPartForm.BtnEncryptClick(Sender: TObject);
begin
  FMemory.SetSize(0);
  EData.Lines.SaveToStream(FMemory);

  FStartPos := FMemory.Size div 4;

  with TCipher_Blowfish.Create(EPassword.Text, nil) do
  try
    FMemory.Position := FStartPos;
    CodeStream(FMemory, FMemory, 30, paEncode); {30 Chars will be encrypt}

  {FMemory is now Hash.DigestKeySize Bytes larger}
    LSize.Caption := IntToStr(FMemory.Size);
    LDigest.Caption := IntToStr(Hash.DigestKeySize);

  finally
    Free;
  end;

  FMemory.Position := 0;
  EData.Lines.LoadFromStream(FMemory);

  BtnDecrypt.Enabled := True;
  BtnEncrypt.Enabled := False;
end;

procedure TPartForm.BtnDecryptClick(Sender: TObject);
begin
  FMemory.Position := 0;

  with TCipher_Blowfish.Create(EPassword.Text, nil) do
  try
    FMemory.Position := FStartPos;
    CodeStream(FMemory, FMemory, 30, paDecode); {30 Chars will be decrypt}

  {FMemory is now Hash.DigestKeySize Bytes smaller}
    LSize.Caption := IntToStr(FMemory.Size);
    LDigest.Caption := IntToStr(Hash.DigestKeySize);
  finally
    Free;
  end;

  FMemory.Position := 0;
  EData.Lines.Clear;
  EData.Lines.LoadFromStream(FMemory);

  BtnDecrypt.Enabled := False;
  BtnEncrypt.Enabled := True;
end;

procedure TPartForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPartForm.FormCreate(Sender: TObject);
begin
  FMemory := TMemoryStream.Create;
end;

procedure TPartForm.FormDestroy(Sender: TObject);
begin
  FMemory.Free;
end;

end.
