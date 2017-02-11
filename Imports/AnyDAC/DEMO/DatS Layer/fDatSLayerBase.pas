unit fDatSLayerBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  fMainBase, StdCtrls, ExtCtrls, ComCtrls, jpeg;

type
  TfrmDatSLayerBase = class(TfrmMainBase)
    pnlControlButtons: TPanel;
    Console: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDatSLayerBase: TfrmDatSLayerBase;

implementation

{$R *.dfm}

end.
