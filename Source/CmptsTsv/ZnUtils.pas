{*************************************************************************}
{                                                                         }
{         Property Editors Project                                        }
{                                                                         }
{         Copyright (c) 2000 Michael Skachkov a.k.a. Master Yoda          }
{                                                                         }
{*************************************************************************}
unit ZnUtils;

interface

uses Windows, Classes, Graphics, SysUtils;

function ZnListMeasureHeight(Value: string; ACanvas: TCanvas;
                             var AHeight: Integer; ImgHeight: Integer): Integer;
function ZnListMeasureWidth(Value, LongestValue: string; ACanvas: TCanvas;
                            var AWidth: Integer; ImgWidth: Integer): Integer;
procedure ZnListDrawValue(Value: string;  ACanvas: TCanvas; const ARect: TRect;
                   ASelected: Boolean; Bitmap: TBitmap; Prefix: string;
                   Height, ImgWidth: Integer);
implementation

uses ZnConsts, imglist;

function ZnListMeasureHeight(Value: string; ACanvas: TCanvas;
                             var AHeight: Integer; ImgHeight: Integer): Integer;
begin
  Result:= ITEM_TOP_INDENT + ACanvas.TextHeight('M') + ITEM_BOTTOM_INDENT;

  if Result < (ITEM_TOP_INDENT + ImgHeight + ITEM_BOTTOM_INDENT) then
    Result:= ITEM_TOP_INDENT + ImgHeight + ITEM_BOTTOM_INDENT;

  AHeight:= Result;
end;

function ZnListMeasureWidth(Value, LongestValue: string; ACanvas: TCanvas;
                            var AWidth: Integer; ImgWidth: Integer): Integer;
begin
  Result:= IMG_LEFT_INDENT + ImgWidth + IMG_RIGHT_INDENT +
           TEXT_LEFT_INDENT + ACanvas.TextWidth(LongestValue) +
           TEXT_RIGHT_INDENT;

  if Result < AWidth then
    Result:= AWidth;

  AWidth:= Result;
end;

procedure ZnListDrawValue(Value: string;  ACanvas: TCanvas; const ARect: TRect;
                   ASelected: Boolean; Bitmap: TBitmap; Prefix: string;
                   Height, ImgWidth: Integer);
var
  vRight, TopDelta: Integer;
  TextDrawRect: TRect;
//  il: TCustomImageList;
begin
  with ACAnvas do
  begin
    if ASelected then
    begin
      Brush.Color:= clHighlight;
      Font.Color:= clHighlightText;
      DrawFocusRect(ARect);
    end
    else
    begin
      Brush.Color:= clWindow;
      Font.Color:= clWindowText;
    end;

    FillRect(ARect);

    Bitmap.LoadFromResourceName(HInstance, UpperCase(Prefix + Value));

    Draw(ARect.Left + IMG_LEFT_INDENT, ARect.Top + ITEM_TOP_INDENT, Bitmap);
{    il:=TCustomImageList.Create(nil);
    try
     il.Width:=Bitmap.Width;
     il.Height:=Bitmap.Height;
     il.Add(Bitmap,nil);
//     Draw(ARect.Left + IMG_LEFT_INDENT, ARect.Top + ITEM_TOP_INDENT, Bitmap);
     il.DrawOverlay(ACanvas,ARect.Left + IMG_LEFT_INDENT, ARect.Top + ITEM_TOP_INDENT,0,3,true);
    finally
      il.Free;
    end;      }

    vRight:= ARect.Left + IMG_LEFT_INDENT +
             ImgWidth + IMG_RIGHT_INDENT + TEXT_LEFT_INDENT;

    TopDelta:= (Height - TextHeight('M')) div 2;


    TextDrawRect:= Rect(vRight, ARect.Top, ARect.Right, ARect.Bottom);

    with TextDrawRect do
      TextRect(TextDrawRect, Left, Top + TopDelta, Value);
  end;
end;

end.
