unit FilterCB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls, CashBasis, Data, WinTab;

type
  TFCBFilter = class(TFMaket)
    BClear: TButton;
    Label1: TLabel;
    Edit: TEdit;
    CheckBox: TCheckBox;
    procedure BClearClick(Sender: TObject);
    procedure BOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCBFilter: TFCBFilter;

implementation

{$R *.DFM}

procedure TFCBFilter.BClearClick(Sender: TObject);
begin
  inherited;
  Edit.Clear;
end;

procedure TFCBFilter.BOkClick(Sender: TObject);
begin
  inherited;
  try
    inside := False;
    if CheckBox.Checked then
      inside := True;
    TempList.Clear;
    TempList.Add(Edit.Text);
    ModalResult := mrOk;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

end.
