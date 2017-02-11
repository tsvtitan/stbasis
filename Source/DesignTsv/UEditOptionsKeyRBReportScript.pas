unit UEditOptionsKeyRBReportScript;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RAEditor, ComCtrls;

type
  TfmEditOptionsKeyRBReportScript = class(TForm)
    pnBut: TPanel;
    Panel2: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    rgCase: TRadioGroup;
    lbCommand: TLabel;
    cmbCommand: TComboBox;
    lbKeyOne: TLabel;
    hkKeyOne: THotKey;
    lbKeyTwo: TLabel;
    hkKeyTwo: THotKey;
    procedure bibOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure rgCaseClick(Sender: TObject);
  private
    function CheckFieldsFill: Boolean;
    procedure FillCommands;
  public
  end;

var
  fmEditOptionsKeyRBReportScript: TfmEditOptionsKeyRBReportScript;

implementation

uses UMainUnited;

{$R *.DFM}

function TfmEditOptionsKeyRBReportScript.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if cmbCommand.ItemIndex=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCommand.Caption]));
    cmbCommand.SetFocus;
    Result:=false;
    exit;
  end;

  case rgCase.ItemIndex of
    0: begin
      if hkKeyOne.HotKey=0 then  begin
       ShowErrorEx(Format(ConstFieldNoEmpty,[lbkeyOne.Caption]));
       hkKeyOne.SetFocus;
       Result:=false;
       exit;
      end;
    end;
    1: begin
      if hkKeyOne.HotKey=0 then  begin
       ShowErrorEx(Format(ConstFieldNoEmpty,[lbkeyOne.Caption]));
       hkKeyOne.SetFocus;
       Result:=false;
       exit;
      end;
      if hkKeyTwo.HotKey=0 then  begin
       ShowErrorEx(Format(ConstFieldNoEmpty,[lbkeyTwo.Caption]));
       hkKeyTwo.SetFocus;
       Result:=false;
       exit;
      end;
    end;
  end;
end;

procedure TfmEditOptionsKeyRBReportScript.bibOkClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  ModalResult:=mrOk;
end;

procedure TfmEditOptionsKeyRBReportScript.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.hint:='';
end;

procedure TfmEditOptionsKeyRBReportScript.FillCommands;
var
  i: Integer;
  P: PCommandHint;
begin
  cmbCommand.Items.Clear;
  for i:=0 to ListCommandHint.Count-1 do begin
    P:=ListCommandHint.Items[i];
    cmbCommand.Items.AddObject(P.Hint,TObject(P));
  end;
  if cmbCommand.Items.Count>0 then
    cmbCommand.ItemIndex:=0;
end;

procedure TfmEditOptionsKeyRBReportScript.FormCreate(Sender: TObject);
begin
  FillCommands;
  rgCaseClick(nil);
end;

procedure TfmEditOptionsKeyRBReportScript.rgCaseClick(Sender: TObject);
begin
  case rgCase.ItemIndex of
    0: begin
      lbKeyTwo.Enabled:=false;
      hkKeyTwo.Enabled:=false;
    end;
    1: begin
      lbKeyTwo.Enabled:=true;
      hkKeyTwo.Enabled:=true;
    end;
  end;
end;

end.
