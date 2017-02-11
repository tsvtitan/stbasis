unit fConnProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmProperties = class(TFrame)
    cbDriverID: TComboBox;
    Label3: TLabel;
    edtNewName: TLabeledEdit;
    edtUserName: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtSrvHost: TLabeledEdit;
    edtPort: TLabeledEdit;
    Bevel1: TBevel;
    mmInfo: TMemo;
    edtDatabase: TLabeledEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure cbDriverIDClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmProperties.cbDriverIDClick(Sender: TObject);
begin
  edtNewName.Clear;
  edtDatabase.Clear;
  edtUserName.Clear;
  edtPassword.Clear;
  edtSrvHost.Clear;
  edtPort.Clear;
  
  edtPort.Enabled := False;
  edtSrvHost.Enabled := False;
  if cbDriverID.ItemIndex in [1, 2, 4, 6] then begin
    edtSrvHost.Enabled := True;
    if cbDriverID.ItemIndex = 4 then
      edtPort.Enabled := True
    else
  end;
end;

end.
