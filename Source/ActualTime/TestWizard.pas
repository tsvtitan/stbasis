unit TestWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, PageMngr;

type
  TfrmTestWizard = class(TForm)
    Notebook: TNotebook;
    PanelBottom: TPanel;
    Panel2: TPanel;
    ButtonPrior: TButton;
    ButtonNext: TButton;
    ButtonClose: TButton;
    PanelTop: TPanel;
    Label1: TLabel;
    PageManager: TPageManager;
    ImageLogo: TImage;
    Label5: TLabel;
    PageProxy1: TPageProxy;
    PageProxy2: TPageProxy;
    PageProxy3: TPageProxy;
    PageProxy4: TPageProxy;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Bevel2: TBevel;
    procedure ButtonCloseClick(Sender: TObject);
    procedure PageManagerCheckButtons(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTestWizard: TfrmTestWizard;

implementation

{$R *.DFM}

procedure TfrmTestWizard.ButtonCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmTestWizard.PageManagerCheckButtons(Sender: TObject);
begin
 case PageManager.PageIndex of
  0:ButtonNext.Enabled:=Edit1.Text<>'';
 end;
end;

procedure TfrmTestWizard.Edit1Change(Sender: TObject);
begin
 PageManagerCheckButtons(Sender);
end;

end.
