unit dmMainComp;

interface

uses
  SysUtils, Classes, DB,
  dmMainBase,
  daADStanIntf, daADStanOption, daADStanDef,
  daADMoniIndyClient, daADMoniBase, daADMoniFlatFile,
  daADPhysIntf, daADPhysOracl, daADPhysDB2, daADPhysDBExp, daADPhysMSAcc,
    daADPhysMSSQL, daADPhysMySQL, daADPhysManager, daADPhysODBC, daADPhysASA,
  daADCompClient,
  daADGUIxFormsfError, daADGUIxFormsfLogin, daADGUIxFormsfAsync,
  daADGUIxFormsWait;

type
  TdmlMainComp = class(TdmlMainBase)
    dbMain: TADConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmlMainComp: TdmlMainComp;

implementation

{$R *.dfm}

end.
