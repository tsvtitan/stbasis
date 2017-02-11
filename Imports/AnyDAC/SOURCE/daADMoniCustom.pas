{-------------------------------------------------------------------------------}
{ AnyDAC monitor custom implementation                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADMoniCustom;

interface

uses
  Classes,
  daADStanIntf, daADMoniBase;

{$IFDEF AnyDAC_MONITOR}
type
  {-----------------------------------------------------------------------------}
  { TADMoniCustomClientLink                                                     }
  {-----------------------------------------------------------------------------}
  TADMoniCustomClientLink = class(TADMoniClientLinkBase)
  private
    FCClient: IADMoniCustomClient;
  protected
    function GetMoniClient: IADMoniClient; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CClient: IADMoniCustomClient read FCClient;
  end;

  {-----------------------------------------------------------------------------}
  { TADMoniCustomClient                                                         }
  {-----------------------------------------------------------------------------}
  TADMoniCustomClient = class(TADMoniClientBase, IADMoniCustomClient)
  private
    FLevel: Integer;
  protected
    // IADMoniClient
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); override;
    procedure SetupFromDefinition(const AParams: IADStanDefinition); override;
    // IADMoniCustomClient
    // other
    procedure DoTraceMsg(const AClassName, AObjName, AMessage: String); virtual;
  public
    destructor Destroy; override;
  end;
{$ENDIF}

{-------------------------------------------------------------------------------}
implementation

{$IFDEF AnyDAC_MONITOR}
uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
  daADStanConst, daADStanUtil, daADStanFactory;

{-------------------------------------------------------------------------------}
{ TADMoniCustomClient                                                           }
{-------------------------------------------------------------------------------}
destructor TADMoniCustomClient.Destroy;
begin
  SetTracing(False);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClient.SetupFromDefinition(const AParams: IADStanDefinition);
var
  i: Integer;
begin
  ASSERT(AParams <> nil);
  if AParams.HasValue(S_AD_MoniCategories) then begin
    i := AParams.AsInteger[S_AD_MoniCategories];
    SetEventKinds(PADMoniEventKinds(@i)^ * [ekLiveCycle .. ekVendor]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClient.DoTraceMsg(const AClassName, AObjName,
  AMessage: String);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
type
  __TInterfacedObject = class(TInterfacedObject)
  end;

function VarRec2Variant(AArg: PVarRec): Variant;
begin
  with AArg^ do
    case VType of
      vtInteger:    Result := VInteger;
      vtBoolean:    Result := VBoolean;
      vtChar:       Result := VChar;
      vtExtended:   Result := VExtended^;
      vtString:     Result := VString^;
{$IFDEF AnyDAC_D6Base}
      vtPointer:    Result := LongWord(VPointer);
{$ELSE}
      vtPointer:    Result := Integer(VPointer);
{$ENDIF}
      vtPChar:      Result := String(VPChar);
      vtAnsiString: Result := String(VAnsiString);
      vtCurrency:   Result := VCurrency^;
      vtWideString: Result := WideString(VWideString);
      vtPWideChar:  Result := WideString(VPWideChar);
      vtInt64:
        begin
{$IFDEF AnyDAC_D6Base}
          Result := VInt64^;
{$ELSE}
          TVarData(Result).VType := varInt64;
          Decimal(Result).lo64 := VInt64^;
{$ENDIF}
        end;
      vtObject:
        // special case - for NULL and Unassigned
        if Byte(LongWord(VObject)) = 0 then
          Result := Null
        else if Byte(LongWord(VObject)) = 1 then
          Result := Unassigned
        else
          ASSERT(False);
      else
        // vtObject, vtClass, vtVariant, vtInterface
        ASSERT(False);
      end;
end;

procedure TADMoniCustomClient.Notify(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ASender: TObject; const AMsg: String;
  const AArgs: array of const);
var
  s, sClassName, sName: String;
  i, iHigh, iLow: Integer;
  lQuotes: Boolean;
  iRefCount: Integer;
  oObjIntf: IADStanObject;
begin
  if AStep = esEnd then
    Dec(FLevel);
  if GetTracing and (AKind in GetEventKinds) then begin
    s := StringOfChar(' ', FLevel * 4);
    case AStep of
    esStart:    s := s + '>> ';
    esProgress: s := s + ' . ';
    esEnd:      s := s + '<< ';
    end;
    s := s + AMsg;
    iHigh := High(AArgs);
    iLow := Low(AArgs);
    if iHigh - iLow + 1 >= 2 then begin
      s := s + ' [';
      i := iLow;
      while i < iHigh do begin
        if i <> iLow then
          s := s + ', ';
        lQuotes := False;
        s := s + ADIdentToStr(VarRec2Variant(@AArgs[i]), lQuotes) + '=' +
          ADValToStr(VarRec2Variant(@AArgs[i + 1]), lQuotes);
        Inc(i, 2);
      end;
      s := s + ']';
    end;
    if ASender <> nil then begin
      sClassName := ASender.ClassName;
      if (ASender <> nil) and (ASender is TInterfacedObject) then begin
        iRefCount := __TInterfacedObject(ASender).FRefCount; // ???
        __TInterfacedObject(ASender).FRefCount := 2;
        try
          if Supports(ASender, IADStanObject, oObjIntf) then begin
            sName := oObjIntf.GetName;
            oObjIntf := nil;
          end;
        finally
          __TInterfacedObject(ASender).FRefCount := iRefCount;
        end;
        if sName = '' then
          sName := '$' + IntToHex(Integer(ASender), 8);
      end;
    end
    else begin
      sClassName := '<nil>';
      sName := '';
    end;
    DoTraceMsg(sClassName, sName, s);
    if GetOutputHandler <> nil then
      GetOutputHandler.HandleOutput(sClassName, sName, s);
  end;
  if AStep = esStart then
    Inc(FLevel);
end;

{-------------------------------------------------------------------------------}
{ TADMoniCustomClientLink                                                       }
{-------------------------------------------------------------------------------}
constructor TADMoniCustomClientLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCClient := MoniClient as IADMoniCustomClient;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniCustomClientLink.Destroy;
begin
  FCClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniCustomClientLink.GetMoniClient: IADMoniClient;
var
  oCClient: IADMoniCustomClient;
begin
  ADCreateInterface(IADMoniCustomClient, oCClient);
  Result := oCClient as IADMoniClient;
end;

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADMoniCustomClient, IADMoniCustomClient);
{$ENDIF}

end.
