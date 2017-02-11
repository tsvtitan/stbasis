unit UReplaceDialog;
                                
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmReplaceDialog = class(TForm)
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
    lbReplace: TLabel;
    cmbReplace: TComboBox;
    chbPromt: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bibOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AddSearchLastValue;
    procedure AddReplaceLastValue;
  public
    MaxLine: Integer;
  end;

implementation

uses UMainUnited, UDesignTsvData;

{$R *.DFM}

procedure TfmReplaceDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Hint:='';
end;

procedure TfmReplaceDialog.AddSearchLastValue;
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

procedure TfmReplaceDialog.AddReplaceLastValue;
var
  val: integer;
  oldVal: string;
begin
  oldVal:=cmbReplace.Text;
  val:=cmbReplace.Items.IndexOf(oldval);
  if val=-1 then begin
    cmbReplace.Items.Insert(0,oldVal);
  end else begin
    cmbReplace.Items.Delete(val);
    cmbReplace.Items.Insert(0,oldVal);
  end;
  cmbReplace.Text:=oldVal;
end;

procedure TfmReplaceDialog.bibOkClick(Sender: TObject);
begin
  if Trim(cmbSearchText.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFindText.Caption]));
    cmbSearchText.SetFocus;
    exit;
  end;
  if Trim(cmbReplace.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbReplace.Caption]));
    cmbReplace.SetFocus;
    exit;
  end;
  AddSearchLastValue;
  AddReplaceLastValue;
  ModalResult:=mrOk;
end;

procedure TfmReplaceDialog.FormShow(Sender: TObject);
begin
  cmbSearchText.SetFocus;
end;

end.
