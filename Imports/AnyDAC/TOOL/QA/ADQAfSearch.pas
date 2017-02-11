{-------------------------------------------------------------------------------}
{ AnyDAC QA main form                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAfSearch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  daADGUIxFormsControls;

type
  TfrmADQASearch = class(TForm)
    pnlMain: TADGUIxFormsPanel;
    pnlGray: TADGUIxFormsPanel;
    pnlOptions: TADGUIxFormsPanel;
    pnlTitle: TADGUIxFormsPanel;
    lblTitle: TLabel;
    pnlTitleBottomLine: TADGUIxFormsPanel;
    Label3: TLabel;
    cbTestName: TComboBox;
    pnlButtons: TADGUIxFormsPanel;
    btnOk: TButton;
    Button1: TButton;
    procedure btnFindClick(Sender: TObject);
  private
    { Private declarations }
    FFindClicked: Boolean;
  public
    { Public declarations }
    property FindClicked: Boolean read FFindClicked write FFindClicked;
  end;

var
  frmADQASearch: TfrmADQASearch;

implementation

{$R *.dfm}

{-------------------------------------------------------------------------------}
{ TfrmADQASearch                                                                }
{-------------------------------------------------------------------------------}
procedure TfrmADQASearch.btnFindClick(Sender: TObject);
begin
  if (cbTestName.Text <> '') and (cbTestName.Items.IndexOf(cbTestName.Text) = -1) then
    cbTestName.Items.Add(cbTestName.Text);
  Close;
  FFindClicked := True;
end;

end.
