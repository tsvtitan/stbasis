{-------------------------------------------------------------------------------}
{ AnyDAC dbExpress drivers registration unit                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysDBExpReg;

interface

uses
  DBXpress;

type
  TADPhysDBXGetSQLDriverProc = function(VendorLib, SResourceFile: PChar;
    out pDriver): SQLResult; stdcall;
  TADPhysDBXLibRegistratorProc = procedure (const ADriverName: String;
    AGetDrvProc: TADPhysDBXGetSQLDriverProc) of object;
  TADPhysDBXDeRegistratorProc = procedure (const ADriverName: String)
    of object;

procedure ADSetDbXpressLibRegistrator(ARegProc: TADPhysDBXLibRegistratorProc;
  AUnRegProc: TADPhysDBXDeRegistratorProc);
procedure ADRegisterDbXpressLib(const ADriverName: String;
  AGetDrvProc: TADPhysDBXGetSQLDriverProc);
procedure ADUnRegisterDbXpressLib(const ADriverName: String);

{-------------------------------------------------------------------------------}
implementation

uses
  Classes, SysUtils;

var
  FRegistrator: TADPhysDBXLibRegistratorProc = nil;
  FDeRegistrator: TADPhysDBXDeRegistratorProc = nil;
  FTempList: TStringList;

{-------------------------------------------------------------------------------}
procedure ADSetDbXpressLibRegistrator(ARegProc: TADPhysDBXLibRegistratorProc;
  AUnRegProc: TADPhysDBXDeRegistratorProc);
var
  i: Integer;
begin
  FRegistrator := ARegProc;
  FDeRegistrator := AUnRegProc;
  if Assigned(FRegistrator) then
    try
      for i := 0 to FTempList.Count - 1 do
        FRegistrator(FTempList[i], TADPhysDBXGetSQLDriverProc(FTempList.Objects[i]))
    finally
      FTempList.Clear;
    end;
end;

{-------------------------------------------------------------------------------}
procedure ADRegisterDbXpressLib(const ADriverName: String;
  AGetDrvProc: TADPhysDBXGetSQLDriverProc);
begin
  if Assigned(FRegistrator) then
    FRegistrator(ADriverName, AGetDrvProc)
  else
    FTempList.AddObject(ADriverName, TObject(Pointer(@AGetDrvProc)));
end;

{-------------------------------------------------------------------------------}
procedure ADUnRegisterDbXpressLib(const ADriverName: String);
var
  i: Integer;
begin
  if Assigned(FDeRegistrator) then
    FDeRegistrator(ADriverName)
  else if FTempList <> nil then begin
    i := FTempList.IndexOf(ADriverName);
    if i <> -1 then
      FTempList.Delete(i);
  end;
end;

{-------------------------------------------------------------------------------}
initialization

  FTempList := TStringList.Create;

finalization

  FreeAndNil(FTempList);

end.
