unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdQotd;

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
{$R *.DFM}

procedure TfrmQuoteOfTheDayDemo.btnQuoteClick(Sender: TObject);
begin
  IdQtdDemo.Host := edtQuoteDayServer.Text;
  {Get the quote of the day}
  mmoQuoteOfTheDay.Lines.Text := IdQtdDemo.Quote;
end;

end.
