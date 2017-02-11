{ --------------------------------------------------------------------------- }
{ AnyDAC sources configuration file                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }

{$B-} // Boolean short-circuit evaluation ON
{$H+} // Long strings ON
{$T-} // Type-checked pointers OFF
{$X+} // Extended syntax ON

{$WARNINGS ON}
{$HINTS ON}

{$ifdef VER100}      // Delphi 3
  {$define AnyDAC_D3}
  {$define AnyDAC_DELPHI}
  {$define MSWINDOWS}
{$endif}

{$ifdef VER110}      // C++ Builder 3
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_BCB}
  {$define MSWINDOWS}
{$endif}

{$ifdef VER120}      // Delphi 4
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_DELPHI}
  {$define MSWINDOWS}
{$endif}

{$ifdef VER125}      // C++ Builder 4
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_BCB}
  {$define MSWINDOWS}
{$endif}

{$ifdef VER130}      // C++ Builder 5 & Delphi 5
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$ifdef BCB}
    {$define AnyDAC_BCB}    // C++ Builder 5
  {$else}
    {$define AnyDAC_DELPHI} // Delphi 5
  {$endif}
  {$define MSWINDOWS}
{$endif}

{$ifdef VER140}      // Delphi 6 and C++ Builder 6
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_D6}
  {$ifdef BCB}
    {$define AnyDAC_BCB}    // C++ Builder 6
  {$else}
    {$define AnyDAC_DELPHI} // Delphi 6
  {$endif}
{$endif}

{$ifdef VER150}      // Delphi 7
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_D6}
  {$define AnyDAC_D7}
  {$define AnyDAC_DELPHI}
{$endif}

{$ifdef VER160}      // Delphi 8
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_D6}
  {$define AnyDAC_D7}
  {$define AnyDAC_D8}
  {$define AnyDAC_DELPHI}
{$endif}

{$ifdef VER170}      // Delphi 2005
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_D6}
  {$define AnyDAC_D7}
  {$define AnyDAC_D8}
  {$define AnyDAC_D9}
  {$define AnyDAC_DELPHI}
{$endif}

{$ifdef VER180} // Delphi 2006
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_D6}
  {$define AnyDAC_D7}
  {$define AnyDAC_D8}
  {$define AnyDAC_D9}
  {$define AnyDAC_D10}
  {$define AnyDAC_DELPHI}
{$endif}

{$ifdef VER185} // Delphi 2007
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_D6}
  {$define AnyDAC_D7}
  {$define AnyDAC_D8}
  {$define AnyDAC_D9}
  {$define AnyDAC_D10}
  {$define AnyDAC_D11}
  {$define AnyDAC_DELPHI}
{$endif}

{$ifdef FPC}    // FPC
  {$define AnyDAC_D3}
  {$define AnyDAC_D35}
  {$define AnyDAC_D4}
  {$define AnyDAC_D5}
  {$define AnyDAC_D6Base}
  {$define AnyDAC_FPC}
  {$MODE Delphi}
{$endif}

{$ifdef AnyDAC_BCB}
  {$objexportall on}
{$endif}

{$ifdef AnyDAC_D7}
  {$warn UNSAFE_TYPE off}
  {$warn UNSAFE_CODE off}
  {$warn UNSAFE_CAST off}
{$endif}

// Common
{$define AnyDAC_NOLOCALE_DATA}
{$define AnyDAC_NOLOCALE_META}
{.$define AnyDAC_DEBUG}           // define for profiling
{$ifndef FPC}
  {$define AnyDAC_REGEXP}
{$endif}
{$IFDEF AnyDAC_D6}
  {$IF not (DEFINED(CLR) or DEFINED(AnyDAC_DEBUG))}
    {$DEFINE AnyDAC_FactCodeRTL}
  {$IFEND}
{$ENDIF}

{$I daADEnv.inc}

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// If you are using specific 3d Party version $DEFINE one of these names and
// $UNDEF others. Or regenerate daADEnv.inc file. For that go to $(ADHOME)\Build
// directory and run command file updateEnv.bat
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

// Indy
{.$undef AnyDAC_MONITOR}
{.$undef AnyDAC_INDY8}            // AnyDAC_INDY8 is defined by default for D6.
{.$undef AnyDAC_INDY9}            // AnyDAC_INDY9 is defined by default for D7.
{.$undef AnyDAC_INDY10}           // AnyDAC_INDY10 is defined by default for D5, D2005.

// SynEdit
{.$undef AnyDAC_SynEdit}         // define to integrate AnyDAC with SynEdit

// dbExpress driver
{$define AnyDAC_DBX_GETPARBUG}    // define to workaround getParameter bug
{$define AnyDAC_DBX_GETINDBUG}    // define to workaround MSSQL getIndices (uniq/pk/nonuniq) bug
{$define AnyDAC_DBX_ORACATBUG}    // define to workaround Oracle catalog representation
{$define AnyDAC_DBX_ORASCHBUG}    // define to workaround Oracle schema representation
{$define AnyDAC_DBX_MYSQLCMDBUG}  // define to workaround MySQL ISQLCommand.Close bug
{$define AnyDAC_DBX_ODBCINDBUG}   // define to wrokaround Open ODBC driver getIndices bug

// Oracle driver
{.$define AnyDAC_OCI_USE_BINDDYNAMIC} // define when dynamic bind will be stable

