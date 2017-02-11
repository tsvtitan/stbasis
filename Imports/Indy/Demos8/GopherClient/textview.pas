unit textview;

interface

uses
  {$IFDEF Linux}
  QControls, QStdCtrls, QGraphics, QForms, QDialogs, QComCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Buttons,
  {$ENDIF}
  SysUtils, Classes, StdCtrls;

type
  TfrmTextView = class(TForm)
    btnOk: TButton;
    mmoTextFile: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTextView: TfrmTextView;

implementation

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

end.
