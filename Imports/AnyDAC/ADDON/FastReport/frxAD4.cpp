//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("frxAD4.res");
USEPACKAGE("vcl40.bpi");
USEUNIT("frxADReg.pas");
USERES("frxADReg.dcr");
USEPACKAGE("vcldb40.bpi");
USEPACKAGE("daADDclD740.bpi");
USEPACKAGE("frx4.bpi");
USEPACKAGE("frxDB4.bpi");
USEPACKAGE("fs4.bpi");
USEPACKAGE("fqb40.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
