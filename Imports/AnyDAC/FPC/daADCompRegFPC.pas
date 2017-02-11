unit daADCompRegFPC; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazarusPackageIntf,
  daADStanConst, daADStanUtil, daADStanDef, daADStanAsync, daADStanPool,
    daADStanExpr, daADStanFactory,
{$IFDEF AnyDAC_MONITOR}
    daADMoniCustom, daADMoniFlatFile,
{$ENDIF}
  daADDAptManager,
  daADPhysODBC, daADPhysMSAcc, daADPhysMSSQL, daADPhysDb2, daADPhysMySQL,
    daADPhysOracl, daADPhysASA, daADPhysADS, daADPhysManager,
  daADCompClient, daADCompDataMove;

procedure Register;

implementation


procedure RegisterUnitAnyDAC;
begin
  RegisterComponents('AnyDAC', [TADManager, TADConnection, TADCommand,
    TADTableAdapter, TADSchemaAdapter, TADQuery, TADStoredProc, TADMetaInfoQuery,
    TADUpdateSQL, TADDataMove, TADTable, TADClientDataSet]);
  RegisterComponents('AnyDAC Links', [
{$IFDEF AnyDAC_MONITOR}
    TADMoniCustomClientLink, TADMoniFlatFileClientLink,
{$ENDIF}
    TADPhysOraclDriverLink, TADPhysDB2DriverLink, TADPhysMSAccessDriverLink,
    TADPhysMSSQLDriverLink, TADPhysMySQLDriverLink, TADPhysASADriverLink,
    TADPhysADSDriverLink, TADPhysODBCDriverLink]);
end;

procedure Register;
begin
  RegisterUnit('AnyDAC', @RegisterUnitAnyDAC);
end;

end.

