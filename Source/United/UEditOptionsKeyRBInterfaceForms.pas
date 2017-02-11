unit UEditOptionsKeyRBInterfaceForms;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RAEditor, ComCtrls;

type
  TfmEditOptionsKeyRBInterfaceForms = class(TForm)
    pnBut: TPanel;
    Panel2: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    lbCommand: TLabel;
    cmbCommand: TComboBox;
    lbKey: TLabel;
    hkKey: THotKey;
    procedure bibOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    function CheckFieldsFill: Boolean;
    procedure FillCommands;
  public
  end;

var
  fmEditOptionsKeyRBInterfaceForms: TfmEditOptionsKeyRBInterfaceForms;

implementation

uses UMainUnited, tsvDesignForm;

{$R *.DFM}

function TfmEditOptionsKeyRBInterfaceForms.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if cmbCommand.ItemIndex=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCommand.Caption]));
    cmbCommand.SetFocus;
    Result:=false;
    exit;
  end;

  if hkKey.HotKey=0 then  begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbkey.Caption]));
    hkKey.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditOptionsKeyRBInterfaceForms.bibOkClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  ModalResult:=mrOk;
end;

procedure TfmEditOptionsKeyRBInterfaceForms.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.hint:='';
end;

procedure TfmEditOptionsKeyRBInterfaceForms.FillCommands;
var
  i: Integer;
  P: PInfoHintDesignCommand;
begin
  cmbCommand.Items.Clear;
  for i:=0 to ListHintDesignCommand.Count-1 do begin
    P:=ListHintDesignCommand.Items[i];
    cmbCommand.Items.AddObject(P.Hint,TObject(P));
  end;
  if cmbCommand.Items.Count>0 then
    cmbCommand.ItemIndex:=0;
end;

procedure TfmEditOptionsKeyRBInterfaceForms.FormCreate(Sender: TObject);
begin
   FillCommands;
end;

end.
