{ This file was automatically created by Lazarus. Do not edit!
This source is only used to compile and install the package.
 }

unit daADLaz; 

interface

uses
  daADCompClient, daADCompDataMove, daADCompDataSet, daADDAptColumn, 
    daADDAptIntf, daADDAptManager, daADDatSManager, daADGUIxConsoleWait, 
    daADGUIxIntf, daADMoniBase, daADMoniCustom, daADMoniFlatFile, daADPhysADS, 
    daADPhysADSMeta, daADPhysASA, daADPhysASAMeta, daADPhysCmdGenerator, 
    daADPhysCmdPreprocessor, daADPhysConnMeta, daADPhysDB2, daADPhysDb2Meta, 
    daADPhysIntf, daADPhysManager, daADPhysMSAcc, daADPhysMSAccMeta, 
    daADPhysMSSQL, daADPhysMSSQLMeta, daADPhysMySQL, daADPhysMySQLCli, 
    daADPhysMySQLMeta, daADPhysMySQLWrapper, daADPhysODBC, daADPhysODBCBase, 
    daADPhysODBCCli, daADPhysODBCMeta, daADPhysODBCWrapper, daADPhysOracl, 
    daADPhysOraclCli, daADPhysOraclMeta, daADPhysOraclWrapper, daADStanAsync, 
    daADStanConst, daADStanDef, daADStanError, daADStanExpr, daADStanFactory, 
    daADStanIntf, daADStanOption, daADStanParam, daADStanPool, daADStanResStrs, 
    daADStanSQLParser, daADStanTracer, daADStanUtil, daADCompRegFPC, 
    LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('daADCompRegFPC', @daADCompRegFPC.Register); 
end; 

initialization
  RegisterPackage('daADLaz', @Register); 
end.
