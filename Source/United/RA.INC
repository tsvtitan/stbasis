{***********************************************************
                R&A Library
       Copyright (C) 1996-2000 R&A

       description : include module for all RALib units

       programmer  : Andrey Prigunkov
       e-mail      : black@infa.ru
                     ncuxxu@pisem.net
       www         : http://www.infa.ru/black
************************************************************}

{ Determine compiler version }

{ Borland Delphi 2 }
{$IFDEF VER90}
  {$DEFINE RA_D}
  {$DEFINE RA_D2}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{ Borland C++ Builder 1 }
{$IFDEF VER93}
  {$DEFINE RA_D2}
  {$DEFINE RA_B}
  {$DEFINE RA_B1}
  {$DEFINE RA_B1H}  {Builder 1 or higher}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{ Borland Delphi 3 }
{$IFDEF VER100}
  {$DEFINE RA_D}
  {$DEFINE RA_D3}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{ Borland C++ Builder 3 }
{$IFDEF VER110}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE RA_D35H} {Delphi 3.5 or higher}
  {$DEFINE RA_B}
  {$DEFINE RA_B3}   {Builder 3}
  {$DEFINE RA_B1H}  {Builder 1 or higher}
  {$DEFINE RA_B3H}  {Builder 3 or higher}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{ Borland Delphi 4 }
{$IFDEF VER120}
  {$DEFINE RA_D}
  {$DEFINE RA_D4}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE RA_D35H} {Delphi 3.5 or higher}
  {$DEFINE RA_D4H}  {Delphi 4 or higher}
  {$DEFINE RA_D43H} {Delphi 4.3 or higher}
  {$DEFINE RA_QR3H} {QuickReport 3 or higher}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{$IFDEF RA_D4}
  { if you don't have installed Update pack 3 under Delphi 4 uncomment next line }
  //{$UNDEF RA_D43H}
{$ENDIF RA_D4}

{ Borland C++ Builder 4 }
{$IFDEF VER125}
  {$DEFINE RA_D}
  {$DEFINE RA_D4}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE RA_D35H} {Delphi 3.5 or higher}
  {$DEFINE RA_D4H}  {Delphi 4 or higher}
  {$DEFINE RA_QR3H} {QuickReport 3 or higher}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{ Borland Delphi 5, Borland C++ Builder 5 }
{$IFDEF VER130}
  {$DEFINE RA_D}
  {$DEFINE RA_D5}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE RA_D35H} {Delphi 3.5 or higher}
  {$DEFINE RA_D4H}  {Delphi 4 or higher}
  {$DEFINE RA_D5H}  {Delphi 5 or higher}
  {$DEFINE RA_QR3H} {QuickReport 3 or higher}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{ Borland Delphi 6 }
{$IFDEF VER140}
  {$DEFINE RA_D}
  {$DEFINE RA_D6}   {Delphi 6}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE RA_D35H} {Delphi 3.5 or higher}
  {$DEFINE RA_D4H}  {Delphi 4 or higher}
  {$DEFINE RA_D5H}  {Delphi 5 or higher}
  {$DEFINE RA_D6H}  {Delphi 6 or higher}
  {$DEFINE RA_QR3H} {QuickReport 3 or higher}
  // {$DEFINE MSWINDOWS} - already defined in Delphi 6
{$ENDIF}

{ Borland Kylix 1 }
{$IFDEF LINUX}
  {$DEFINE RA_D}    {Delphi, not CBuilder}
  {$DEFINE RA_K}    {Kylix}
  {$DEFINE RA_K1}   {Kylix 1}
  {$DEFINE RA_K1H}  {Kylix 1 or higher}
  {$DEFINE RA_D3H}  {Delphi 3 or higher}
  {$DEFINE RA_D35H} {Delphi 3.5 or higher}
  {$DEFINE RA_D4H}  {Delphi 4 or higher}
  {$DEFINE RA_D5H}  {Delphi 5 or higher}
  {$DEFINE RA_D6H}  {Delphi 6 or higher}
  // {$DEFINE RA_QR3H} {QuickReport 3 or higher}
  // {$DEFINE LINUX} - already defined in Kylix 1
{$ENDIF}

{$IFNDEF RA_D2}
 {$IFNDEF RA_D3}
  {$IFNDEF RA_D4}
   {$IFNDEF RA_D5}
    {$IFNDEF RA_D6}
     {$IFNDEF RA_K1}
      {$IFNDEF RA_B1}
       {$IFNDEF RA_B3}

        { Delphi 7 ? }
        {$DEFINE RA_D}
        {$DEFINE RA_D3H}  {Delphi 3 or higher}
        {$DEFINE RA_D35H} {Delphi 3.5 or higher}
        {$DEFINE RA_D4H}  {Delphi 4 or higher}
        {$DEFINE RA_D5H}  {Delphi 5 or higher}
        {$DEFINE RA_D6H}  {Delphi 6 or higher}

        {$IFDEF LINUX}
         { Kylix 2 ? }
         {$DEFINE RA_K2}
        {$ENDIF}

       {$ENDIF}
      {$ENDIF}
     {$ENDIF}
    {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}


{ Select library to use: VCL or CLX}

// Uncomment next $DEFINE if you wish to compile library
// with CLX support under Delphi 6 or higher.
// CLX support is enabled automatically in Kylix

//{$DEFINE RA_CLX}

{$IFDEF MSWINDOWS}
  {$IFNDEF RA_CLX}
    {$DEFINE RA_VCL}
  {$ENDIF RA_CLX}
{$ENDIF MSWINDOWS}

{$IFDEF RA_K}
  {$DEFINE RA_CLX}
  {$UNDEF RA_VCL}
{$ENDIF RA_K}


// Enable new property editor for integer types
{$DEFINE RAI2_INTEGERPROPERTY}
// enables dblclick feature in new property editor
{.$DEFINE RAI2_INTEGERPROPERTY_DBLCLICK}



{ Compiler Options }

{$BOOLEVAL OFF}
{$EXTENDEDSYNTAX ON}
{$OPENSTRINGS ON}
{$LONGSTRINGS ON}

{$OPTIMIZATION OFF} // R&A Library was writen and debugged with this option, don't turn ON sucks optimization
{$RANGECHECKS ON}
{$STACKCHECKS ON}
{$IOCHECKS ON}
{$OVERFLOWCHECKS ON}

