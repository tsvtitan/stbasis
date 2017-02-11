
{******************************************}
{                                          }
{             FastReport v2.4              }
{              About window                }
{                                          }
{ Copyright (c) 1998-2001 by Tzyganenko A. }
{                                          }
{******************************************}

unit FR_About;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Const;

type
  TfrAboutForm = class(TForm)
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Bevel2: TBevel;
    Label5: TLabel;
    PBox: TPaintBox;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure PBoxPaint(Sender: TObject);
  private
    { Private declarations }
    procedure Localize;
  public
    { Public declarations }
  end;


implementation

uses FR_Utils;

{$R *.DFM}

procedure TfrAboutForm.Localize;
begin
  Caption := frLoadStr(frRes + 540);
  Button1.Caption := frLoadStr(SOk);
end;

procedure TfrAboutForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfrAboutForm.PBoxPaint(Sender: TObject);
begin
  PBox.Canvas.BrushCopy(Rect(0, 0, PBox.Width, PBox.Height),
    Image1.Picture.Bitmap,
    Rect(0, 0, PBox.Width, PBox.Height),
    Image1.Picture.Bitmap.TransparentColor);
end;

end.

