{-------------------------------------------------------------------------------}
{ AnyDAC interface factories                                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanFactory;

interface

uses
  SysUtils, Classes, daADStanIntf;

type
  TADObject = class;
  TADObjectClass = class of TADObject;
  TADFactory = class;
  TADSingletonFactory = class;
  TADMultyInstanceFactory = class;

  TADObject = class(TInterfacedObject, IUnknown, IADStanComponentReference)
  private
    FComponentReference: IInterfaceComponentReference;
  protected
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    // IADStanComponentReference
    procedure SetComponentReference(const AValue: IInterfaceComponentReference);
  public
    function ADDecRef(const AValue: Integer = 1): Integer;
    function ADAddRef(const AValue: Integer = 1): Integer;
    constructor Create; virtual;
    procedure Initialize; virtual;
    destructor Destroy; override;
  end;

  TADFactory = class(TObject)
  private
    FClass: TADObjectClass;
    FClassID: TGUID;
  protected
    function CreateObject: TADObject; virtual; abstract;
  public
    constructor Create(AClass: TADObjectClass; const AClassID: TGUID);
  end;

  TADSingletonFactory = class(TADFactory)
  private
    FSingleton: TADObject;
    FSingletonIntf: IUnknown;
  public
    destructor Destroy; override;
    function CreateObject: TADObject; override;
  end;

  TADMultyInstanceFactory = class(TADFactory)
  public
    function CreateObject: TADObject; override;
  end;

  procedure ADCreateInterface(const AIID: TGUID; out AIntf; const ARequired: Boolean = True);
  procedure ADTerminate;

implementation

uses
  Windows,
{$IFNDEF AnyDAC_D6Base}
  ActiveX, ComObj,
{$ENDIF}  
  daADStanResStrs, daADStanUtil,
  daADGUIxIntf;

{ ---------------------------------------------------------------------------- }
{ TADManager                                                                   }
{ ---------------------------------------------------------------------------- }
type
  TADManager = class(TObject)
  private
    FFactories: TList;
    FLock: TADMREWSynchronizer;
    FObjects: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateInterface(const AIID: TGUID; out AIntf; ARequired: Boolean);
    procedure AddFactory(AFactory: TADFactory);
    procedure AddObj;
    procedure RemObj;
  end;

var
  GTerminating: Boolean;
  GManager: TADManager;

{ ---------------------------------------------------------------------------- }
constructor TADManager.Create;
begin
  inherited Create;
  FFactories := TList.Create;
  FLock := TADMREWSynchronizer.Create;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.AddFactory(AFactory: TADFactory);
begin
  FLock.BeginWrite;
  try
    FFactories.Add(AFactory);
  finally
    FLock.EndWrite;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.CreateInterface(const AIID: TGUID; out AIntf; ARequired: Boolean);
var
  i: Integer;
  oFact: TADFactory;

  procedure ObjFactMissError;
  var
    s: String;
  begin
    if IsEqualGUID(AIID, IADGUIxWaitCursor) then
      s := Format(S_AD_StanHowToReg, ['TADGUIxWaitCursor']);
    raise Exception.CreateFmt('Object factory for class %s missing' + s, [GUIDToString(AIID)]);
  end;

  procedure IntfNotImplError;
  begin
    raise Exception.CreateFmt('Class [%s] does not implement interface [%s]',
      [oFact.FClass.ClassName, GUIDToString(AIID)]);
  end;

begin
  FLock.BeginRead;
  try
    oFact := nil;
    for i := 0 to FFactories.Count - 1 do
      if IsEqualGUID(AIID, TADFactory(FFactories[i]).FClassID) then begin
        oFact := TADFactory(FFactories[i]);
        Break;
      end;
  finally
    FLock.EndRead;
  end;
  if oFact = nil then begin
    if not ARequired then begin
      IUnknown(AIntf) := nil;
      Exit;
    end;
    ObjFactMissError;
  end;
  if not Supports(TObject(oFact.CreateObject), AIID, AIntf) then
    IntfNotImplError;
end;

{ ---------------------------------------------------------------------------- }
destructor TADManager.Destroy;
var
  i: Integer;
begin
  FLock.BeginWrite;
  for i := FFactories.Count - 1 downto 0 do
    TADFactory(FFactories[i]).Free;
  FreeAndNil(FFactories);
  FreeAndNil(FLock);
  GManager := nil;
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.AddObj;
begin
  InterlockedIncrement(FObjects);
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.RemObj;
begin
  InterlockedDecrement(FObjects);
end;

{ ---------------------------------------------------------------------------- }
procedure ADCreateInterface(const AIID: TGUID; out AIntf; const ARequired: Boolean = True);
begin
  if GTerminating then
    IUnknown(AIntf) := nil
  else
    GManager.CreateInterface(AIID, AIntf, ARequired);
end;

{ ---------------------------------------------------------------------------- }
procedure ADTerminate;
begin
  if not GTerminating then begin
    GTerminating := True;
    FreeAndNil(GManager);
  end;
end;

{ ---------------------------------------------------------------------------- }
{ TADObject                                                                    }
{ ---------------------------------------------------------------------------- }
constructor TADObject.Create;
begin
  inherited Create;
  Initialize;
  if GManager <> nil then
    GManager.AddObj;
end;

{ ---------------------------------------------------------------------------- }
procedure TADObject.Initialize;
begin
  // nothing
end;

{ ---------------------------------------------------------------------------- }
destructor TADObject.Destroy;
begin
  if GManager <> nil then
    GManager.RemObj;
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
function TADObject.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  Result := inherited QueryInterface(IID, Obj);
  if (Result = E_NOINTERFACE) and Assigned(FComponentReference) then
    Result := FComponentReference.QueryInterface(IID, Obj);
end;

{ ---------------------------------------------------------------------------- }
function TADObject.ADAddRef(const AValue: Integer = 1): Integer;
begin
  if AValue = 1 then
    Result := InterlockedIncrement(FRefCount)
  else begin
    Inc(FRefCount, AValue);
    Result := FRefCount;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADObject.ADDecRef(const AValue: Integer = 1): Integer;
begin
  if AValue = 1 then
    Result := InterlockedDecrement(FRefCount)
  else begin
    Dec(FRefCount, AValue);
    Result := FRefCount;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADObject.SetComponentReference(const AValue: IInterfaceComponentReference);
begin
  FComponentReference := AValue;
end;

{ ---------------------------------------------------------------------------- }
{ TADFactory                                                                   }
{ ---------------------------------------------------------------------------- }
constructor TADFactory.Create(AClass: TADObjectClass; const AClassID: TGUID);
begin
  inherited Create;
  FClass := AClass;
  FClassID := AClassID;
  GManager.AddFactory(Self);
end;

{ ---------------------------------------------------------------------------- }
{ TADSingletonFactory                                                          }
{ ---------------------------------------------------------------------------- }
function TADSingletonFactory.CreateObject: TADObject;
begin
  if FSingleton = nil then begin
    FSingleton := FClass.Create;
    FSingletonIntf := FSingleton as IUnknown;
  end;
  Result := FSingleton;
end;

{ ---------------------------------------------------------------------------- }
destructor TADSingletonFactory.Destroy;
begin
  if not GTerminating and (FSingleton <> nil) and (FSingleton.RefCount > 1) then
    MessageBox(0,
      PChar('Class [' + FClass.ClassName + '] singleton factory has unreleased interfaces'),
      PChar('AnyDAC Warning'), MB_TASKMODAL or MB_ICONWARNING);
  try
    FSingletonIntf := nil;
  except
    { TODO -oDA : Once I will cleanup AV here };
    Pointer(FSingletonIntf) := nil;
  end;
  FSingleton := nil;
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
{ TADMultyInstanceFactory                                                      }
{ ---------------------------------------------------------------------------- }
function TADMultyInstanceFactory.CreateObject: TADObject;
begin
  Result := FClass.Create;
end;

{ ---------------------------------------------------------------------------- }
initialization
  GTerminating := False;
  GManager := TADManager.Create;

{ ---------------------------------------------------------------------------- }
finalization
  ADTerminate;

end.
