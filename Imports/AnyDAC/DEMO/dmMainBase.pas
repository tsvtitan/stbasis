{$I daAD.inc}

unit dmMainBase;

interface

uses
  SysUtils, Classes, DB,
{$IFDEF AnyDAC_MONITOR}
  daADMoniBase, daADMoniIndyClient, daADMoniFlatFile,
{$ENDIF}
  daADPhysOracl, daADPhysDB2, daADPhysMSAcc, daADPhysMSSQL,
    daADPhysMySQL, daADPhysManager, daADPhysODBC, daADPhysASA,
{$IFDEF AnyDAC_D6}
    daADPhysDbExp, 
{$ENDIF}
  daADGUIxFormsfError, daADGUIxFormsfLogin, daADGUIxFormsfAsync,
    daADGUIxFormsWait, daADStanIntf;

type
  TdmlMainBase = class(TDataModule)
    ADGUIxFormsLoginDialog1: TADGUIxFormsLoginDialog;
    ADGUIxFormsErrorDialog1: TADGUIxFormsErrorDialog;
    ADPhysODBCDriverLink1: TADPhysODBCDriverLink;
    ADPhysMySQLDriverLink1: TADPhysMySQLDriverLink;
    ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink;
    ADPhysMSAccessDriverLink1: TADPhysMSAccessDriverLink;
    ADPhysDB2DriverLink1: TADPhysDB2DriverLink;
    ADPhysOraclDriverLink1: TADPhysOraclDriverLink;
    ADPhysASADriverLink1: TADPhysASADriverLink;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    ADGUIxFormsAsyncExecuteDialog1: TADGUIxFormsAsyncExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmlMainBase: TdmlMainBase;

implementation

{$R *.dfm}

end.
