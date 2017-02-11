program WhoisGUI;

uses
  Classes,
  IdWhois,
  QControls,
  QStdCtrls,
  QGraphics,
  QExtCtrls,
  QForms,
  SysUtils;

type
  TFormMain = class(TForm)
  private
    memoResults: TMemo;
    cmboHost: TCombobox;
    editDomain: TEdit;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Button1Click(Sender: TObject);
  end;

var
  FormMain: TFormMain;

{ TFormMain }

procedure TformMain.Button1Click(Sender: TObject);
begin
  with TIdWhois.Create(nil) do try
    Host := Trim(cmboHost.Text);
    memoResults.Lines.Text := WhoIs(Trim(editDomain.text));
  finally free; end;
end;

constructor TFormMain.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Whois GUI Indy Demo for Kylix';
  SetBounds(0, 0, 537, 329);

  with TLabel.Create(Self) do begin
    Parent := Self;
    Left := 48;
    Top := 12;
    Width := 58;
    Height := 13;
    Caption := 'Whois Host:'
  end;

  with TLabel.Create(Self) do begin
    Parent := Self;
    Left := 24;
    Top := 44;
    Width := 84;
    Height := 13;
    Caption := 'Domain to check:';
  end;

  cmboHost := TCombobox.Create(Self);
  with cmboHost do begin
    Parent := Self;
    Left := 112;
    Top := 4;
    Width := 200;
    Height := 21;
    Text := 'whois.internic.net';
    Items.CommaText := 'whois.internic.net,whois.networksolutions.com,whois.register.com';
  end;

  editDomain := TEdit.Create(Self);
  with editDomain do begin
    Parent := Self;
    Left := 112;
    Top := 36;
    Width := 161;
    Height := 21;
    Text := 'borland.com';
  end;

  with TButton.Create(Self) do begin
    Parent := Self;
    Left := 288;
    Top := 32;
    Width := 75;
    Height := 25;
    Caption := '&Check';
    Default := True;
    OnClick := Button1Click;
  end;

  memoResults := TMemo.Create(self);
  with memoResults do begin
    Parent := Self;
    Left := 1;
    Top := 75;
    Width := 527;
    Height := 185;
    ReadOnly := True;
  end
end;

begin
  Application.CreateForm(TFormMain, FormMain);
  FormMain.Show;
  Application.Run;
end.
