unit main;

interface

uses
  {$IFDEF Linux}
  QForms, QDialogs, QControls, QGraphics, QStdCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  {$ENDIF}
  SysUtils, Classes, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdQotd;

type
  TfrmQuoteOfTheDayDemo = class(TForm)
    mmoQuoteOfTheDay: TMemo;
    lblServer: TLabel;
    edtQuoteDayServer: TEdit;
    lblQuote: TLabel;
    btnQuote: TButton;
    IdQtdDemo: TIdQOTD;
    procedure btnQuoteClick(Sender: TObject);
  private
  public
  end;

var
  frmQuoteOfTheDayDemo: TfrmQuoteOfTheDayDemo;

implementation
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TfrmQuoteOfTheDayDemo.btnQuoteClick(Sender: TObject);
begin
  IdQtdDemo.Host := edtQuoteDayServer.Text;
  {Get the quote of the day}
  mmoQuoteOfTheDay.Lines.Text := IdQtdDemo.Quote;
end;

end.
