unit textview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmTextView = class(TForm)
    redtTextFile: TRichEdit;
    btnOk: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTextView: TfrmTextView;

implementation

{$R *.DFM}

end.
