unit MsgEdtAdv;

interface

uses
  {$IFDEF Linux}
    QGraphics,   QControls,   QForms,   QButtons,   QStdCtrls,   QDialogs,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,   stdctrls, Buttons,
  {$ENDIF}
  SysUtils, Classes;

type
  TfrmAdvancedOptions = class(TForm)
    lblSender: TLabel;
    edtSender: TEdit;
    mmoExtraHeaders: TMemo;
    bbtnOk: TBitBtn;
    bbtnCancel: TBitBtn;
    Label1: TLabel;
  private
    { Private declarations }
  protected
  public
    { Public declarations }
  end;

var
  frmAdvancedOptions: TfrmAdvancedOptions;

implementation

{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

end.
