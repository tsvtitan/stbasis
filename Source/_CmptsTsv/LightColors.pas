{ Unit: LightColors
  ===========================================================================
  Bluecave Software
                  (C) Copyright 2001, Jouni Airaksinen (Mintus@Codefield.com)
  ===========================================================================

    Color constants.

    The 'lw' prefix means LightWave.

  =========================================================================== }
unit LightColors;

{$WEAKPACKAGEUNIT ON}

interface

uses Graphics;

const
  lwPale = TColor($00D0D0D0);         {208 208 208}  { selected tab }
  lwDarkGray = TColor($00505050);     {80   80  80}  { borders }
  lwGray = TColor($00A0A0A0);         {160 160 160}  { menus, unselected tabs }
  lwLightGray = TColor($00BCBCBC);    {188 188 188}  { gray button }

  lwBeige = TColor($00B4C4C4);        {196 196 180}  { button face }
  lwBrightBeige = TColor($00BFFFFF);  {255 255 191}  { selected text }
  lwLightBeige = TColor($00D8E8E8);   {232 232 216}  { hotkey }

  lwCyan = TColor($00C4C4B4);         {180 196 196}  { button face }
  lwBrightCyan = TColor($00FFFFBF);   {191 255 255}  { selected text }
  lwLightCyan = TColor($00E8E8D8);    {216 232 232}  { hotkey }

  lwGreen = TColor($00B8BAB8);        {184 196 184}  { button face }
  lwBrightGreen = TColor($00CFFFCF);  {207 255 207}  { selected text }
  lwLightGreen = TColor($00DCE8DC);   {220 232 220}  { hotkey }

  lwViolet = TColor($02C4C2B8);       {184 184 196}  { button face }
  lwBrightViolet = TColor($02FFCFCF); {207 207 255}  { selected text }
  lwLightViolet = TColor($02E8DCDC);  {220 220 232}  { hotkey }


  { LightWave Interface colors }
  lwBorder = lwDarkGray;

  lwBtnArrow = clBlack;

  lwMenu = lwGray;
  lwMenuSelected = clBlack;
  lwMenuSelectedText = lwGray;
  lwMenuBorder = lwDarkGray;

  lwBackground = lwGray;

  lwSelectedTab = lwPale;
  lwTab = lwGray;


  { copied from FlatStyle }
  { Standard Encarta & FlatStyle Color Constants }
  ecDarkBlue = TColor($00996633);
  ecBlue = TColor($00CF9030);
  ecLightBlue = TColor($00CFB78F);

  ecDarkRed = TColor($00302794);
  ecRed = TColor($005F58B0);
  ecLightRed = TColor($006963B6);

  ecDarkGreen = TColor($00385937);
  ecGreen = TColor($00518150);
  ecLightGreen = TColor($0093CAB1);

  ecDarkYellow = TColor($004EB6CF);
  ecYellow = TColor($0057D1FF);
  ecLightYellow = TColor($00B3F8FF);

  ecDarkBrown = TColor($00394D4D);
  ecBrown = TColor($00555E66);
  ecLightBrown = TColor($00829AA2);

  ecDarkKaki = TColor($00D3D3D3);
  ecKaki = TColor($00C8D7D7);
  ecLightKaki = TColor($00E0E9EF);

implementation

end.
