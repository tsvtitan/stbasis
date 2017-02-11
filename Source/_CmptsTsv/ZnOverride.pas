{*************************************************************************}
{                                                                         }
{         Property Editors Project                                        }
{                                                                         }
{         Copyright (c) 2000 Michael Skachkov a.k.a. Master Yoda          }
{                                                                         }
{*************************************************************************}
unit ZnOverride;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, extctrls, comctrls, toolwin, DsgnIntf, buttons;

const
  {TModalResult}
  MODAL_RESULT_IMG_WIDTH  = 18;
  MODAL_RESULT_IMG_HEIGHT = 18;

type
  TZnModalResultProperty = class(TModalResultProperty)
  private
    FBitmap: TBitMap;
    FHeight: Integer;
  protected
    FImgHeight: Integer;
    FImgPrefix: string;
    FImgWidth: Integer;
    FLongestValue: string;
  public
    constructor Create(const ADesigner: IFormDesigner; APropCount: Integer); override;
    destructor Destroy; override;
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
                           const ARect: TRect; ASelected: Boolean); override;
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
                                var AHeight: Integer); override;
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
                               var AWidth: Integer); override;
  end;

implementation

uses ZnUtils;


{ TZnModalResultProperty }

constructor TZnModalResultProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);;
  FBitmap:= TBitmap.Create;
  FImgPrefix:= 'TMODALRESULT_';
  FImgWidth:= MODAL_RESULT_IMG_WIDTH;
  FImgHeight:= MODAL_RESULT_IMG_HEIGHT;
  FLongestValue:= 'mrYesToAll';
end;

destructor TZnModalResultProperty.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

procedure TZnModalResultProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
begin
  ZnListDrawValue(Value, ACanvas, ARect, ASelected, FBitmap, FImgPrefix, FHeight,
                         FImgWidth);
end;

procedure TZnModalResultProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
begin
  FHeight:= ZnListMeasureHeight(Value, ACanvas, Aheight, FImgHeight);
end;

procedure TZnModalResultProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth:= ZnListMeasureWidth(Value, FLongestValue, ACanvas, AWidth, FImgWidth);
end;

end.
