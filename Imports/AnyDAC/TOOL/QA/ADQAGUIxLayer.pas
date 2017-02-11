{-------------------------------------------------------------------------------}
{ AnyDAC GUIx Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAGUIxLayer;

interface

uses
  Classes, Windows, SysUtils,
  ADQAPack,
  daADStanIntf,
  daADGUIxIntf,
  daADPhysIntf;

type
  TADQAGUIxTsHolder = class (TADQATsHolderBase)
  public
    procedure RegisterTests; override;
    procedure TestLoginDialog;
    procedure TestWaitCursor;
    procedure TestErrorDialog;
  end;

implementation

uses
  Forms, Dialogs, Controls, DB,
  daADStanFactory,
  ADQAConst, ADQAUtils;

{-------------------------------------------------------------------------------}
{ TADQAGUIxTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQAGUIxTsHolder.RegisterTests;
begin
  RegisterTest('Login dialog', TestLoginDialog, mkOracle);
  RegisterTest('Wait cursor', TestWaitCursor, mkUnknown);
  RegisterTest('Error dialog', TestErrorDialog, mkOracle);
end;

{-------------------------------------------------------------------------------}
procedure TADQAGUIxTsHolder.TestErrorDialog;
var
  oErrorDlg: IADGUIxErrorDialog;
  oConnectionDef: IADStanConnectionDef;
  oConn: IADPhysConnection;
  oComm: IADPhysCommand;
begin
  SetConnectionDefFileName(CONN_DEF_STORAGE);
  OpenPhysManager;
  oConnectionDef := ADPhysManager.ConnectionDefs.ConnectionDefByName(ORACLE_CONN);

  ADCreateInterface(IADGUIxErrorDialog, oErrorDlg);
  ADPhysManager.CreateConnection(oConnectionDef, oConn);
  oConn.Open;

  // NOT silent mode
  oConn.CreateCommand(oComm);
  with oComm do begin
    CommandText := 'insert into {id Categories}(CategoryID) values(:ID)';
    Params[0].AsInteger := 1;
    try
      Execute;
    except
      Application.HandleException(nil);
    end;
  end;
  if MessageDlg(DidYouSee('Error Dialog'), mtInformation,
                [mbYes, mbNo], 0) <> Ord(mrYes) then
    Error('Error dialog is invisible (SilentMode = False)');

  // Silent mode
  FADGUIxSilentMode := True;
  try
    with oComm do begin
      CommandText := 'insert into {id Categories}(CategoryID) values(:ID)';
      Params[0].AsInteger := 1;
      try
        Execute;
      except
        Application.HandleException(nil);
      end;
    end;
    if MessageDlg(DidYouSee('Error Dialog'), mtInformation,
                  [mbYes, mbNo], 0) <> Ord(mrNo) then
      Error('Error dialog is visible (SilentMode = True)');
  finally
    FADGUIxSilentMode := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAGUIxTsHolder.TestLoginDialog;
var
  oLoginDlg: IADGUIxLoginDialog;
  oConnectionDef: IADStanConnectionDef;
  oConn: IADPhysConnection;
begin
  SetConnectionDefFileName(CONN_DEF_STORAGE);
  OpenPhysManager;
  oConnectionDef := ADPhysManager.ConnectionDefs.ConnectionDefByName(ORACLE_CONN);

  ADCreateInterface(IADGUIxLoginDialog, oLoginDlg);
  ADPhysManager.CreateConnection(oConnectionDef, oConn);

  // NOT silent mode
  oConn.Login := oLoginDlg;
  oConn.Open;
  if MessageDlg(DidYouSee('Login Dialog'), mtInformation,
                [mbYes, mbNo], 0) <> Ord(mrYes) then
    Error('Login dialog is invisible (SilentMode = False)');

  // Silent mode
  FADGUIxSilentMode := True;
  try
    oConn.Close;
    oConn.Open;
    if MessageDlg(DidYouSee('Login Dialog'), mtInformation,
                  [mbYes, mbNo], 0) <> Ord(mrNo) then
      Error('Login dialog is visible (SilentMode = True)');
  finally
    FADGUIxSilentMode := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAGUIxTsHolder.TestWaitCursor;
var
  oWaitCrs: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWaitCrs);

  // NOT silent mode
  oWaitCrs.WaitCursor := gcrHourGlass;
  oWaitCrs.StartWait;
  Sleep(1000);
  oWaitCrs.StopWait;
  if MessageDlg(DidYouSee('Hour Glass mouse cursor'), mtInformation,
                [mbYes, mbNo], 0) <> Ord(mrYes) then
    Error('Wait cursor [dcrHourGlass] fails (SilentMode = False)');

  oWaitCrs.WaitCursor := gcrSQLWait;
  oWaitCrs.StartWait;
  Sleep(1000);
  oWaitCrs.StopWait;
  if MessageDlg(DidYouSee('SQL wait mouse cursor'), mtInformation,
               [mbYes, mbNo], 0) <> Ord(mrYes) then
    Error('Wait cursor [dcrSQLWait] fails (SilentMode = False)');

  // Silent mode
  FADGUIxSilentMode := True;
  try
    oWaitCrs.WaitCursor := gcrHourGlass;
    oWaitCrs.StartWait;
    Sleep(1000);
    oWaitCrs.StopWait;
    if MessageDlg(DidYouSee('Hour Glass mouse cursor'), mtInformation,
                  [mbYes, mbNo], 0) <> Ord(mrNo) then
      Error('Wait cursor [dcrHourGlass] fails (SilentMode = True)');
  finally
    FADGUIxSilentMode := False;
  end;
end;

initialization

  ADQAPackManager.RegisterPack('GUIx Layer', TADQAGUIxTsHolder);

end.
