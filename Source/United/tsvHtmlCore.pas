unit tsvHtmlCore;

interface

uses Windows, Classes;

const
  IID_ItsvHtmlElement:   TGUID = '{C1C0E99E-44DA-49FD-BFAE-C338D022A044}';

type

  ItsvHtmlElement=interface//(IUnknown)
  ['{C1C0E99E-44DA-49FD-BFAE-C338D022A044}']
    function GetBeginHtml: PChar; stdcall;
    function GetBodyHtml: PChar; stdcall;
    function GetEndHtml: PChar; stdcall;
  end;


implementation

end.
