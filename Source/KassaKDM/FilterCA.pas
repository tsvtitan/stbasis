unit FilterCA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls, Data;

type
  TFCAFilter = class(TFMaket)
    Label1: TLabel;
    Edit: TEdit;
    BClear: TButton;
    CheckBox: TCheckBox;
    procedure BClearClick(Sender: TObject);
    procedure BOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCAFilter: TFCAFilter;

implementation

{$R *.DFM}

procedure TFCAFilter.BClearClick(Sender: TObject);
begin
  inherited;
  Edit.Clear;
end;

procedure TFCAFilter.BOkClick(Sender: TObject);
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
