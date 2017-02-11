
{******************************************}
{                                          }
{             FastReport v2.4              }
{             Report options               }
{                                          }
{ Copyright (c) 1998-2001 by Tzyganenko A. }
{                                          }
{******************************************}

unit FR_Dopt;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Const, ExtCtrls;

type
  TfrDocOptForm = class(TForm)
    GroupBox1: TGroupBox;
    CB1: TCheckBox;
    GroupBox2: TGroupBox;
    CB2: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    LB1: TListBox;
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LB1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    procedure Localize;
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

uses FR_Prntr, FR_Utils;


procedure TfrDocOptForm.FormActivate(Sender: TObject);
begin
  LB1.Items.Assign(Prn.Printers);
  LB1.ItemIndex := Prn.PrinterIndex;
end;

procedure TfrDocOptForm.Localize;
begin
  Caption := frLoadStr(frRes + 370);
  GroupBox1.Caption := frLoadStr(frRes + 371);
  CB1.Caption := frLoadStr(frRes + 372);
  GroupBox2.Caption := frLoadStr(frRes + 373);
  CB2.Caption := frLoadStr(frRes + 374);
  Button1.Caption := frLoadStr(SOk);
  Button2.Caption := frLoadStr(SCancel);
end;

procedure TfrDocOptForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TfrDocOptForm.LB1DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  r: TRect;
begin
  r := ARect;
  r.Right := r.Left + 18;
  r.Bottom := r.Top + 16;
  OffsetRect(r, 2, 0);
  with LB1.Canvas do
  begin
    FillRect(ARect);
    BrushCopy(r, Image1.Picture.Bitmap, Rect(0, 0, 18, 16), clOlive);
    TextOut(ARect.Left + 24, ARect.Top + 1, LB1.Items[Index]);
  end;
end;

end.

