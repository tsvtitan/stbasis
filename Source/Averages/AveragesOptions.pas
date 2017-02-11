unit AveragesOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmAveragesOptions = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PanelSickOptions: TPanel;
    PanelLeaveOptions: TPanel;
    TabSheet3: TTabSheet;
    PanelNoneOptions: TPanel;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAveragesOptions: TfrmAveragesOptions;

implementation

{$R *.DFM}

end.
