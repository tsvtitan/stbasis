unit fADSpeedUIDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fADSpeedUI, ImgList, Menus, ActnList, ComCtrls, ToolWin,
  ExtCtrls, Grids, StdCtrls, daADGUIxFormsControls;

type
  TADSpeedUIDBFrm = class(TADSpeedUIFrm)
    actConnect: TAction;
    actDisconnect: TAction;
    actEditDefinition: TAction;
    actGenData: TAction;
    Connection1: TMenuItem;
    Disconnect1: TMenuItem;
    N3: TMenuItem;
    EditDefinitions1: TMenuItem;
    GenerateData1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure actConnectExecute(Sender: TObject);
    procedure actDisconnectExecute(Sender: TObject);
    procedure actEditDefinitionExecute(Sender: TObject);
    procedure actGenDataExecute(Sender: TObject);
  private
    procedure WMAfterStartup(var Message: TMessage); message WM_ADSpeed_AfterStartup;
  end;

var
  ADSpeedUIDBFrm: TADSpeedUIDBFrm;

implementation

{$R *.dfm}

uses
  ShellAPI,
  daADStanUtil, fADSpeedGenData, ADSpeedBaseDB;

{---------------------------------------------------------------------------}
procedure TADSpeedUIDBFrm.FormCreate(Sender: TObject);
begin
  inherited;
{$IFDEF AnyDACSPEED_ORA}
  TADSpeedDBTestManager(FMgr).ConnDefName := 'Oracle_Demo';
  Caption := Caption + ' [Oracle mode] - [' + TADSpeedDBTestManager(FMgr).ConnDefName + ']';
{$ENDIF}
{$IFDEF AnyDACSPEED_MSSQL}
  TADSpeedDBTestManager(FMgr).ConnDefName := 'MSSQL2000_Demo';
  Caption := Caption + ' [MSSQL mode] - [' + TADSpeedDBTestManager(FMgr).ConnDefName + ']';
{$ENDIF}
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIDBFrm.WMAfterStartup(var Message: TMessage);
begin
  if ADGetCmdParam('N', '') = '1' then
    actConnectExecute(nil);
  inherited;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIDBFrm.actConnectExecute(Sender: TObject);
begin
  TADSpeedDBTestManager(FMgr).OpenConnections;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIDBFrm.actDisconnectExecute(Sender: TObject);
begin
  TADSpeedDBTestManager(FMgr).CloseConnections;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIDBFrm.actEditDefinitionExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(ADExpandStr('$(ADHOME)\DB\ADConnectionDefs.ini')),
    nil, nil, SW_SHOW);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedUIDBFrm.actGenDataExecute(Sender: TObject);
begin
  TADSpeedGenDataFrm.Execute(TADSpeedDBTestManager(FMgr).ConnDefName);
end;

end.
