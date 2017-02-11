//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("sourceforcompile\daADGUIxFormsfAsync.pas", Daadguixformsfasync, frmADGUIxFormsAsyncExecute);
USEFORMNS("sourceforcompile\daADGUIxFormsfError.pas", Daadguixformsferror, frmADGUIxFormsError);
USEFORMNS("sourceforcompile\daADGUIxFormsfFetchOptions.pas", Daadguixformsffetchoptions, frmADGUIxFormsFetchOptions); /* TFrame: File Type */
USEFORMNS("sourceforcompile\daADGUIxFormsfFormatOptions.pas", Daadguixformsfformatoptions, frmADGUIxFormsFormatOptions); /* TFrame: File Type */
USEFORMNS("sourceforcompile\daADGUIxFormsfOptsBase.pas", Daadguixformsfoptsbase, frmADGUIxFormsOptsBase);
USEFORMNS("sourceforcompile\daADGUIxFormsfQBldrConn.pas", Daadguixformsfqbldrconn, frmADGUIxFormsQBldrConn);
USEFORMNS("sourceforcompile\daADGUIxFormsfQBldrLink.pas", Daadguixformsfqbldrlink, frmADGUIxFormsQBldrLink);
USEFORMNS("sourceforcompile\daADGUIxFormsfResourceOptions.pas", Daadguixformsfresourceoptions, frmADGUIxFormsResourceOptions); /* TFrame: File Type */
USEFORMNS("sourceforcompile\daADGUIxFormsfUpdateOptions.pas", Daadguixformsfupdateoptions, frmADGUIxFormsUpdateOptions); /* TFrame: File Type */
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
