unit ChooseCO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls,Data;

type
  TFChooseDoc = class(TFMaket)
    GroupBox1: TGroupBox;
    LBCO: TListBox;
    procedure BOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FChooseDoc: TFChooseDoc;

implementation

{$R *.DFM}

procedure TFChooseDoc.BOkClick(Sender: TObject);
begin
  inherited;
  TempStr := '';
  TempStr := LBCO.Items[LBCO.ItemIndex];
  ModalResult := mrOk;
end;

procedure TFChooseDoc.FormCreate(Sender: TObject);
begin
  inherited;
  LBCO.ItemIndex := 0;
end;

procedure TFChooseDoc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  Case Key of
  VK_Enter: begin
            BOk.OnClick(nil);
            end;
  VK_ESC: begin
          BCancel.OnClick(nil);
          end;
  end;
end;

end.
