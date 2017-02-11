{ Unit: LightColorPropertyEditor
  ===========================================================================
  Bluecave Software
                  (C) Copyright 2001, Jouni Airaksinen (Mintus@Codefield.com)
  ===========================================================================
    Version 1.0.1

    New color property editor.
    Features:
      - Adds couple of new items to dropdown menu
        * FlatStyle Encarta colors
        * LightWave interface colors
      - '< Other... >' item opens Color dialog
        * Custom colors are saved to registry

    2001-02-17: Damn. Forgot that DFS.INC file .. :/  Fixed also the default
      color for the dialog to be the current color.

      TODO: Expert manager to manage which items to be shown on the dropdown
        list. It would automatically generate a unit which would hold the
        correct const values.


    2001-02-11: First release


  =========================================================================== }
unit LightColorPropertyEditor;

interface

{$I DFS.inc}

uses
  Windows, Classes, SysUtils, Graphics, Forms, DsgnIntf;

{ from FlatStyle }
function RxIdentToColor(const Ident: string; var Color: Longint): Boolean;
function RxColorToString(Color: TColor): string;
function RxStringToColor(S: string): TColor;
procedure RxGetColorValues(Proc: TGetStrProc);

{ TLightColorProperty }

type
  TLightColorProperty = class(TColorProperty)
  public
    function GetValue: string; override;
    procedure GetValues (Proc: TGetStrProc); override;
    procedure SetValue (const Value: string); override;
{$IFDEF DFS_COMPILER_5_UP}
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); override;
{$ENDIF}
  end;

procedure Register;

implementation

uses
  LightColors, Dialogs;

type
  TColorEntry = record
    Value: TColor;
    Name: PChar;
  end;

const
  StrOther = '< Другие... >';

{ set correct registry path to save ColorDialog.CustomColors }
{$IFDEF DFS_COMPILER_2}
  DelphiVersion = '2.0\';
{$ELSE}
  {$IFDEF DFS_COMPILER_3}
    DelphiVersion = '3.0\';
  {$ELSE}
    {$IFDEF DFS_COMPILER_4}
      DelphiVersion = '4.0\';
    {$ELSE}
      {$IFDEF DFS_COMPILER_4}
        DelphiVersion = '4.0\';
      {$ELSE}
        {$IFDEF DFS_COMPILER_5_UP}
           DelphiVersion = '5.0\';
        {$ELSE}
          {$IFDEF DFS_UNKNOWN_COMPILER}
             DelphiVersion = ''; { goes to Delphi\ root }
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

  clInfoBk16 = TColor($02E1FFFF);
  clNone16 = TColor($02FFFFFF);
//  ColorCount = 36;
  ColorCount = 35;
var
  Colors: array[0..ColorCount - 1] of TColorEntry = (
    (Value: lwPale;         Name: 'lwPale'),
    (Value: lwDarkGray;     Name: 'lwDarkGray'),
    (Value: lwGray;         Name: 'lwGray'),
    (Value: lwLightGray;    Name: 'lwLightGray'),

    (Value: lwBeige;        Name: 'lwBeige'),
    (Value: lwBrightBeige;  Name: 'lwBrightBeige'),
    (Value: lwLightBeige;   Name: 'lwLightBeige'),

    (Value: lwCyan;         Name: 'lwCyan'),
    (Value: lwBrightCyan;   Name: 'lwBrightCyan'),
    (Value: lwLightCyan;    Name: 'lwLightCyan'),

    (Value: lwGreen;        Name: 'lwGreen'),
    (Value: lwBrightGreen;  Name: 'lwBrightGreen'),
    (Value: lwLightGreen;   Name: 'lwLightGreen'),

    (Value: lwViolet;       Name: 'lwViolet'),
    (Value: lwBrightViolet; Name: 'lwBrightViolet'),
    (Value: lwLightViolet;  Name: 'lwLightViolet'),

    { copied from FlatStyle, because our editor overrides it's editor }
    (Value: ecDarkBlue;     Name: 'ecDarkBlue'),
    (Value: ecBlue;         Name: 'ecBlue'),
    (Value: ecLightBlue;    Name: 'ecLightBlue'),
    (Value: ecDarkRed;      Name: 'ecDarkRed'),
    (Value: ecRed;          Name: 'ecRed'),
    (Value: ecLightRed;     Name: 'ecLightRed'),
    (Value: ecDarkGreen;    Name: 'ecDarkGreen'),
    (Value: ecGreen;        Name: 'ecGreen'),
    (Value: ecLightGreen;   Name: 'ecLightGreen'),
    (Value: ecDarkYellow;   Name: 'ecDarkYellow'),
    (Value: ecYellow;       Name: 'ecYellow'),
    (Value: ecLightYellow;  Name: 'ecLightYellow'),
    (Value: ecDarkBrown;    Name: 'ecDarkBrown'),
    (Value: ecBrown;        Name: 'ecBrown'),
    (Value: ecLightBrown;   Name: 'ecLightBrown'),
    (Value: ecDarkKaki;     Name: 'ecDarkKaki'),
    (Value: ecKaki;         Name: 'ecKaki'),
    (Value: ecLightKaki;    Name: 'ecLightKaki'),

//    { Whistler colors}
//    (Value: whBtnFace;      Name: 'whBtnFace'),
//

    { Other item }
    (Value: 0;              Name: StrOther)
  );

function RxColorToString(Color: TColor): string;
var
  I: Integer;
begin
  if not ColorToIdent(Color, Result) then begin
    for I := Low(Colors) to High(Colors) do
      if Colors[I].Value = Color then
      begin
        Result := StrPas(Colors[I].Name);
        Exit;
      end;
    FmtStr(Result, '$%.8x', [Color]);
  end;
end;

function RxIdentToColor(const Ident: string; var Color: Longint): Boolean;
var
  I: Integer;
  Text: array[0..63] of Char;
begin
  StrPLCopy(Text, Ident, SizeOf(Text) - 1);
  for I := Low(Colors) to High(Colors) do
    if StrIComp(Colors[I].Name, Text) = 0 then begin
      Color := Colors[I].Value;
      Result := True;
      Exit;
    end;
  Result := IdentToColor(Ident, Color);
end;

function RxStringToColor(S: string): TColor;
var
  I: Integer;
  Text: array[0..63] of Char;
begin
  StrPLCopy(Text, S, SizeOf(Text) - 1);
  for I := Low(Colors) to High(Colors) do
    if StrIComp(Colors[I].Name, Text) = 0 then
    begin
      Result := Colors[I].Value;
      Exit;
    end;
  Result := StringToColor(S);
end;

procedure RxGetColorValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  GetColorValues(Proc);
  for I := Low(Colors) to High(Colors) do Proc(StrPas(Colors[I].Name));
end;

function TLightColorProperty.GetValue: string;
var
  Color: TColor;
begin
  Color := TColor(GetOrdValue);
  if Color = clNone16 then Color := clNone
  else if Color = clInfoBk16 then Color := clInfoBk;
  Result := RxColorToString(Color);
end;

procedure TLightColorProperty.GetValues(Proc: TGetStrProc);
begin
  RxGetColorValues(Proc);
end;

procedure TLightColorProperty.SetValue(const Value: string);
var
  OldValue, NewValue: string;
  ColorDialog: TColorDialog;
//  c: Char;
//  i: Integer;
//  Regs: TRegistry;
begin
  NewValue := Value;
  if NewValue = StrOther then
  begin
    ColorDialog := TColorDialog.Create(Application);
    try
      OldValue := Self.Value;

      ColorDialog.Options := [cdFullOpen, cdAnyColor];
      ColorDialog.Color := RxStringToColor(OldValue);

      { load custom colors }
{      Regs := TRegistry.Create;
      try
        Regs.RootKey := HKEY_CURRENT_USER;
        Regs.OpenKey('\Software\Borland\Delphi\' + DelphiVersion + '\Property Editors\TColorProperty', True);
        for c := 'A' to 'P' do
          ColorDialog.CustomColors.Add('Color' + c + '=' +
            Regs.ReadString('Color' + c));
      finally
        Regs.CloseKey;
        Regs.Free;
      end;}

      if ColorDialog.Execute then
      begin
        NewValue := RxColorToString(ColorDialog.Color);

        { save custom colors }
{        Regs := TRegistry.Create;
        try
          Regs.RootKey := HKEY_CURRENT_USER;
          Regs.OpenKey('\Software\Borland\Delphi\' + DelphiVersion + 'Property Editors\TColorProperty', True);
          with ColorDialog.CustomColors do
            for i := 0 to Count - 1 do
              Regs.WriteString(Names[i], Values[Names[i]]);
        finally
          Regs.CloseKey;
          Regs.Free;
        end;}

      end
      else
        NewValue := OldValue;
    finally
      ColorDialog.Free;
    end;
  end;
  SetOrdValue(RxStringToColor(NewValue));
end;

{$IFDEF DFS_COMPILER_5_UP}
procedure TLightColorProperty.ListDrawValue(const Value: string; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);

  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red, Green, Blue, Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or (TColorQuad(AColor).Green > 192) or
       (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else if ASelected then
      Result := clWhite
    else
      Result := AColor;
  end;

var
  vRight: Integer;
  vOldPenColor, vOldBrushColor: TColor;
begin
  if Value <> StrOther then
    vRight := (ARect.Bottom - ARect.Top) + ARect.Left
  else
    vRight := (ARect.Right - ARect.Left - ACanvas.TextWidth(StrOther)) div 2 - 1;
  with ACanvas do
  try
    vOldPenColor := Pen.Color;
    vOldBrushColor := Brush.Color;
    if Value = StrOther then
      if ASelected then
        Brush.Color := clHighLight
      else
        Brush.Color := clWindow;
    Pen.Color := Brush.Color;

    Rectangle(ARect.Left, ARect.Top, vRight, ARect.Bottom);
    if Value <> StrOther then
    begin
      Brush.Color := RxStringToColor(Value);
      Pen.Color := ColorToBorderColor(ColorToRGB(Brush.Color));
      Rectangle(ARect.Left + 1, ARect.Top + 1, vRight - 1, ARect.Bottom - 1);
    end;
    Brush.Color := vOldBrushColor;
    Pen.Color := vOldPenColor;
  finally
    ACanvas.TextRect(Rect(vRight, ARect.Top, ARect.Right, ARect.Bottom),
      vRight + 1, ARect.Top + 1, Value);
  end;
end;
{$ENDIF}

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TColor), TPersistent, '', TLightColorProperty);
end;

end.
