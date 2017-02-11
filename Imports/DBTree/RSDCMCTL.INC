(*
 COPYRIGHT (c) RSD software 1997, 98
 All Rights Reserved.
*)

{Types and constants for custom draw service}

const
 {Custom draw constants}
 NM_CUSTOMDRAW   = NM_FIRST-12;
 CDDS_PREPAINT   = $00000001;
 CDDS_POSTPAINT  = $00000002;
 CDDS_PREERASE   = $00000003;
 CDDS_POSTERASE  = $00000004;
 CDDS_ITEM       = $00010000;

 CDDS_ITEMPREPAINT  = CDDS_ITEM Or CDDS_PREPAINT;
 CDDS_ITEMPOSTPAINT = CDDS_ITEM Or CDDS_POSTPAINT;
 CDDS_ITEMPREERASE  = CDDS_ITEM Or CDDS_PREERASE;
 CDDS_ITEMPOSTERASE = CDDS_ITEM Or CDDS_POSTERASE;

 CDRF_DODEFAULT       = $00000000;
 CDRF_NEWFONT         = $00000002;
 CDRF_SKIPDEFAULT     = $00000004;
 CDRF_NOTIFYPOSTPAINT = $00000010;
 CDRF_NOTIFYITEMDRAW  = $00000020;
 CDRF_NOTIFYPOSTERASE = $00000040;
 CDRF_NOTIFYITEMERASE = $00000080;


type
 {Custom draw types}
  TNMCustomDraw = record
    hdr : TNMHDR;
    dwDrawStage : DWORD; // State of the Drawing
    hdc : HDC;
    rc : TRECT;
    dwItemSpec : DWORD;
    uItemState : UINT;
    LItemlParam : LPARAM;
  end;

  PNMCustomDraw = ^TNMCustomDraw;

  TNMLVCustomDraw = record
    nmcd : TNMCustomDraw;
    clrText : COLORREF;
    clrTextBk : COLORREF;
  end;

  PNMLVCustomDraw = ^TNMLVCustomDraw;

