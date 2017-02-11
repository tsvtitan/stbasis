unit UFindDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmFindDialog = class(TForm)
    pnBut: TPanel;
    Panel2: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    lbFindText: TLabel;
    grbOptions: TGroupBox;
    grbDirection: TGroupBox;
    rbForward: TRadioButton;
    rgBackward: TRadioButton;
    grbScope: TGroupBox;
    rbGlobal: TRadioButton;
    rbSelected: TRadioButton;
    grbOrigin: TGroupBox;
    rbFromCursor: TRadioButton;
    rbEntire: TRadioButton;
    cmbSearchText: TComboBox;
    chbWithCase: TCheckBox;
    chbWordOnly: TCheckBox;
    chbRegExpresion: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AddLastValue;
  public
    MaxLine: Integer;
  end;

implementation

uses UMainUnited, UDesignTsvData;

{$R *.DFM}

procedure TfmFindDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Hint:='';
end;

procedure TfmFindDialog.AddLastValue;
var
  val: integer;
  oldVal: string;
begin
  oldVal:=cmbSearchText.Text;
  val:=cmbSearchText.Items.IndexOf(oldval);
  if val=-1 then begin
    cmbSearchText.Items.Insert(0,oldVal);
  end else begin
    cmbSearchText.Items.Delete(val);
    cmbSearchText.Items.Insert(0,oldVal);
  end;
  cmbSearchText.Text:=oldVal;
end;

procedure TfmFindDialog.bibOkClick(Sender: TObject);
begin
  if Trim(cmbSearchText.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFindText.Caption]));
    cmbSearchText.SetFocus;
    exit;
  end;
  AddLastValue;
  ModalResult:=mrOk;
end;

procedure TfmFindDialog.FormShow(Sender: TObject);
begin
  cmbSearchText.SetFocus;
end;

end.
