{-------------------------------------------------------------------------------}
{ AnyDAC GUIx layer API                                                         }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADGUIxIntf;

interface

uses
  Windows, Messages, Classes,
  daADStanIntf, daADStanError;

type
  IADGUIxLoginDialog = interface;
  IADGUIxDefaultLoginDialog = interface;
  IADGUIxWaitCursor = interface;
  IADGUIxAsyncExecuteDialog = interface;
  IADGUIxErrorDialog = interface;

  { --------------------------------------------------------------------------}
  { Login dialog                                                              }
  { --------------------------------------------------------------------------}
  TADGUIxLoginAction = procedure of object;
  TADGUIxLoginHistoryStorage = (hsRegistry, hsFile);
  TADGUIxLoginDialogEvent = procedure (ASender: TObject; var AResult: Boolean) of object;

  IADGUIxLoginDialog = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2200}']
    // private
    function GetConnectionDef: IADStanConnectionDef;
    function GetOnHide: TNotifyEvent;
    function GetOnShow: TNotifyEvent;
    function GetCaption: String;
    function GetChangeExpiredPassword: Boolean;
    function GetHistoryEnabled: Boolean;
    function GetHistoryKey: String;
    function GetHistoryStorage: TADGUIxLoginHistoryStorage;
    function GetHistoryWithPassword: Boolean;
    function GetLoginRetries: Integer;
    function GetOnChangePassword: TADGUIxLoginDialogEvent;
    function GetOnLogin: TADGUIxLoginDialogEvent;
    function GetVisibleItems: TStrings;
    procedure SetConnectionDef(const AValue: IADStanConnectionDef);
    procedure SetOnHide(const AValue: TNotifyEvent);
    procedure SetOnShow(const AValue: TNotifyEvent);
    procedure SetCaption(const AValue: String);
    procedure SetChangeExpiredPassword(const AValue: Boolean);
    procedure SetHistoryEnabled(const AValue: Boolean);
    procedure SetHistoryKey(const AValue: String);
    procedure SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
    procedure SetHistoryWithPassword(const AValue: Boolean);
    procedure SetLoginRetries(const AValue: Integer);
    procedure SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
    procedure SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
    procedure SetVisibleItems(const AValue: TStrings);
    // public
    procedure GetAllLoginParams;
    function Execute(AAction: TADGUIxLoginAction = nil): Boolean;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef write SetConnectionDef;
    property Caption: String read GetCaption write SetCaption;
    property HistoryEnabled: Boolean read GetHistoryEnabled write SetHistoryEnabled;
    property HistoryWithPassword: Boolean read GetHistoryWithPassword write SetHistoryWithPassword;
    property HistoryStorage: TADGUIxLoginHistoryStorage read GetHistoryStorage write SetHistoryStorage;
    property HistoryKey: String read GetHistoryKey write SetHistoryKey;
    property VisibleItems: TStrings read GetVisibleItems write SetVisibleItems;
    property LoginRetries: Integer read GetLoginRetries write SetLoginRetries;
    property ChangeExpiredPassword: Boolean read GetChangeExpiredPassword write SetChangeExpiredPassword;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnLogin: TADGUIxLoginDialogEvent read GetOnLogin write SetOnLogin;
    property OnChangePassword: TADGUIxLoginDialogEvent read GetOnChangePassword write SetOnChangePassword;
  end;

  IADGUIxDefaultLoginDialog = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2204}']
    // private
    function GetLoginDialog: IADGUIxLoginDialog;
    // public
    property LoginDialog: IADGUIxLoginDialog read GetLoginDialog;
  end;

  { --------------------------------------------------------------------------}
  { "Wait, working ..."                                                       }
  { --------------------------------------------------------------------------}
  TADGUIxScreenCursor = (gcrDefault, gcrHourGlass, gcrSQLWait, gcrOther);
  IADGUIxWaitCursor = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2201}']
    // private
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    // public
    procedure StartWait;
    procedure StopWait;
    procedure PushWait;
    procedure PopWait;
    property WaitCursor: TADGUIxScreenCursor read GetWaitCursor write SetWaitCursor;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
  end;

  { --------------------------------------------------------------------------}
  { Async execution dialog                                                    }
  { --------------------------------------------------------------------------}
  IADGUIxAsyncExecuteDialog = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2202}']
    // private
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    // public
    procedure Execute(AShow: Boolean; const AExecutor: IADStanAsyncExecutor);
    function IsFormActive: Boolean;
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
    property Caption: String read GetCaption write SetCaption;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
  end;

  { --------------------------------------------------------------------------}
  { Error dialog                                                              }
  { --------------------------------------------------------------------------}
  TADGUIxErrorDialogEvent = procedure (ASender: TObject; AException: EADDBEngineException) of object;
  IADGUIxErrorDialog = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2203}']
    // private
    function GetOnShow: TADGUIxErrorDialogEvent;
    procedure SetOnShow(const AValue: TADGUIxErrorDialogEvent);
    function GetOnHide: TADGUIxErrorDialogEvent;
    procedure SetOnHide(const AValue: TADGUIxErrorDialogEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    // public
    procedure Execute(E: EADDBEngineException);
    property Caption: String read GetCaption write SetCaption;
    property OnShow: TADGUIxErrorDialogEvent read GetOnShow write SetOnShow;
    property OnHide: TADGUIxErrorDialogEvent read GetOnHide write SetOnHide;
  end;

var
  FADGUIxSilentMode: Boolean;
  FADGUIxInteractive: Boolean;

  function ADGUIxSilent: Boolean;

{-------------------------------------------------------------------------------}
implementation

function ADGUIxSilent: Boolean;
begin
  Result := FADGUIxSilentMode or (GetCurrentThreadID <> MainThreadID);
end;

{-------------------------------------------------------------------------------}
initialization

  FADGUIxSilentMode := False;
  FADGUIxInteractive := False;

end.
