unit UGotoLineDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmGotoLineDialog = class(TForm)
    pnBut: TPanel;
    Panel2: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    grbGotoLine: TGroupBox;
    cmbLine: TComboBox;
    lbLine: TLabel;
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

procedure TfmGotoLineDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Hint:='';
end;

procedure TfmGotoLineDialog.AddLastValue;
var
  val: integer;
begin
  val:=cmbLine.Items.IndexOf(Trim(cmbLine.Text));
  if val=-1 then begin
    cmbLine.Items.Insert(0,Trim(cmbLine.Text));
  end else begin
    cmbLine.Items.Delete(val);
    cmbLine.Items.Insert(0,Trim(cmbLine.Text));
  end;
end;

procedure TfmGotoLineDialog.bibOkClick(Sender: TObject);
begin
  if not isInteger(cmbLine.Text) then exit;
  if (StrToInt(cmbLine.Text)>MaxLine)or(StrToInt(cmbLine.Text)<1) then begin
   ShowErrorEx(Format(ConstFmtMaxLine,[1,MaxLine]));
   cmbLine.SetFocus;
   exit;
  end;
  AddLastValue;
  ModalResult:=mrOk;
end;

procedure TfmGotoLineDialog.FormShow(Sender: TObject);
begin
  cmbLine.SetFocus;
end;

end.
