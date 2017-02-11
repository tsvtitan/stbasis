unit WinMaket;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, IBSQL, CashBasis,Data;

type
  TFMaket = class(TForm)
    BOk: TButton;
    BCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMaket: TFMaket;

implementation

uses AddCB;

{$R *.DFM}

procedure TFMaket.FormCreate(Sender: TObject);
begin
 Caption:=Caption;
end;

procedure TFMaket.BCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFMaket.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFMaket.FormDeactivate(Sender: TObject);
begin
 if Visible = true then
   SetFocus();
end;

procedure TFMaket.FormDestroy(Sender: TObject);
begin
  Caption := Caption;
end;

procedure TFMaket.BOkClick(Sender: TObject);
begin
//  ModalResult := mrOk;
end;

procedure TFMaket.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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
