unit fMainBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Grids, DBGrids, DB, StdCtrls, SqlExpr, ComCtrls, ExtCtrls, Buttons, ShellAPI,
  daADStanIntf, daADStanOption, daADStanConst,
  daADGUIxFormsWait,
  daADPhysIntf,
  daADCompClient, daADCompDataSet, jpeg;

type
  TfrmMainBase = class(TForm)
    pnlSubstrate: TPanel;
    pnlButtons: TPanel;
    pnlBorder: TPanel;
    pnlTitle: TPanel;
    pnlMain: TPanel;
    lblTitle: TLabel;
    imgAnyDAC: TImage;
    btnClose: TButton;
    lblInfo: TLabel;
    imgInfo: TImage;
    pnlBottom: TPanel;
    imgGradient: TImage;
    procedure btnCloseClick(Sender: TObject);
    procedure lblInfoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblInfoMouseLeave(Sender: TObject);
    procedure lblInfoClick(Sender: TObject);
    procedure imgAnyDACClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMainBase: TfrmMainBase;

implementation

{$R *.dfm}

{ ---------------------------------------------------------------------------- }
constructor TfrmMainBase.Create(AOwner: TComponent);
var
  s: string;
begin
  inherited Create(AOwner);
  s := ChangeFileExt(Application.ExeName, '.htm');
  lblInfo.Enabled := FileExists(s);
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMainBase.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMainBase.lblInfoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lblInfo.Enabled then
    lblInfo.Font.Style := lblInfo.Font.Style + [fsUnderline];
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMainBase.lblInfoMouseLeave(Sender: TObject);
begin
  if lblInfo.Enabled then
    lblInfo.Font.Style := lblInfo.Font.Style + [fsUnderline];
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMainBase.lblInfoClick(Sender: TObject);
var
  s: string;
begin
  s := ChangeFileExt(Application.ExeName, '.htm');
  if FileExists(s) then begin
    if ShellExecute(Self.Handle, nil, PChar(s), nil, nil, SW_SHOW) < 33 then
      raise Exception.Create('It is not possible to show you information, be sure that:' + C_AD_EOL +
                             '- the file ' + QuotedStr(s) + ' exists;' + C_AD_EOL +
                             '- you have installed the Internet Explorer.');
  end
  else
    lblInfo.Enabled := False;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMainBase.imgAnyDACClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar('http://www.da-soft.com/AnyDAC.html'), nil, nil, SW_SHOW);
end;

end.
