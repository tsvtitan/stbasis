{******************************************}
{                                          }
{             FastReport v4.0              }
{       AD components registration         }
{                                          }
{                                          }
{     Created by: Serega Glazkin           }
{******************************************}
{                                          }
{                                          }
{     E-mail: glserega@mezonplus.ru        }
{                                          }
{                                          }
{******************************************}

unit frxADReg;

interface

{$I frx.inc}

procedure Register;

implementation

uses
  Windows, Messages, SysUtils, Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
, DesignIntf, DesignEditors
{$ENDIF}
, frxADComponents;

procedure Register;
begin
  RegisterComponents('FastReport 4.0', [TfrxADComponents]);
end;

end.
