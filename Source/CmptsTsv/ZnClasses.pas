{*************************************************************************}
{                                                                         }
{         Property Editors Project                                        }
{                                                                         }
{         Copyright (c) 2000 Michael Skachkov a.k.a. Master Yoda          }
{                                                                         }
{*************************************************************************}

unit ZnClasses;

interface

uses DsgnIntf, Windows, Graphics, ZnUtils;

type
  TZnEnumProperty = class(TEnumProperty)
  private
    FBitmap: TBitMap;
    FFont: TFont;
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

{ TZnEnumProperty }

constructor TZnEnumProperty.Create(const ADesigner: IFormDesigner;
  APropCount: Integer);
begin
  inherited Create(ADesigner, APropCount);;
  FBitmap:= TBitmap.Create;
  FFont:= TFont.Create;
  FFont.Name:= 'Tahoma';
end;

destructor TZnEnumProperty.Destroy;
begin
  FBitmap.Free;
  FFont.Free;
  inherited Destroy;
end;

procedure TZnEnumProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
begin
  ACanvas.Font.Assign(FFont);
  ZnListDrawValue(Value, ACanvas, ARect, ASelected, FBitmap, FImgPrefix, FHeight,
                         FImgWidth);
end;

procedure TZnEnumProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
begin
  FHeight:= ZnListMeasureHeight(Value, ACanvas, Aheight, FImgHeight);
end;

procedure TZnEnumProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth:= ZnListMeasureWidth(Value, FLongestValue, ACanvas, AWidth, FImgWidth);
end;

end.
