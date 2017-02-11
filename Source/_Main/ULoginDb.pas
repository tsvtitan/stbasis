unit ULoginDb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfmLoginDb = class(TForm)
    lbUser: TLabel;
    lbPass: TLabel;
    edPass: TEdit;
    edUser: TEdit;
    pnBottom: TPanel;
    Panel: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLoginDb: TfmLoginDb;

implementation

{$R *.DFM}

end.
