{-------------------------------------------------------------------------------}
{ AnyDAC Data Adapter Layer API                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADDAptIntf;

interface

uses
  SysUtils,
  daADStanIntf, daADStanOption, daADStanError,
  daADDatSManager,
  daADPhysIntf,
  daADDAptColumn;

type
  IADDAptTableAdapter = interface;
  IADDAptTableAdapters = interface;
  IADDAptSchemaAdapter = interface;
  EADDAptRowUpdateException = class;

  {-----------------------------------------------------------------------------}
  TADDAptReconcileAction = (raSkip, raAbort, raMerge, raCorrect, raCancel, raRefresh);

  IADDAptUpdateHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2301}']
    procedure ReconcileRow(ARow: TADDatSRow; var Action: TADDAptReconcileAction);
    procedure UpdateRow(ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
      AUpdRowOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction);
  end;

  {-----------------------------------------------------------------------------}
  // Data table business processor. It maps SELECT command to DataTable and back
  // to INSERT / UPDATE / DELETE commands. It is able:
  // - fetch data from SelectCommand into DataTable
  // - post updates from DataTable rows to DB
  // - reconcilation

  IADDAptTableAdapter = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2304}']
    // private
    function GetSourceRecordSetID: Integer;
    procedure SetSourceRecordSetID(const AValue: Integer);
    function GetSourceRecordSetName: String;
    procedure SetSourceRecordSetName(const AValue: String);
    function GetUpdateTableName: String;
    procedure SetUpdateTableName(const AValue: String);
    function GetDatSTableName: String;
    procedure SetDatSTableName(const AValue: String);
    function GetDatSTable: TADDatSTable;
    procedure SetDatSTable(AValue: TADDatSTable);
    function GetColumnMappings: TADDAptColumnMappings;
    function GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    procedure SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
    function GetTableMappings: IADDAptTableAdapters;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);

    function GetSelectCommand: IADPhysCommand;
    procedure SetSelectCommand(const AValue: IADPhysCommand);
    function GetInsertCommand: IADPhysCommand;
    procedure SetInsertCommand(const AValue: IADPhysCommand);
    function GetUpdateCommand: IADPhysCommand;
    procedure SetUpdateCommand(const AValue: IADPhysCommand);
    function GetDeleteCommand: IADPhysCommand;
    procedure SetDeleteCommand(const AValue: IADPhysCommand);
    function GetLockCommand: IADPhysCommand;
    procedure SetLockCommand(const AValue: IADPhysCommand);
    function GetUnLockCommand: IADPhysCommand;
    procedure SetUnLockCommand(const AValue: IADPhysCommand);
    function GetFetchRowCommand: IADPhysCommand;
    procedure SetFetchRowCommand(const AValue: IADPhysCommand);

    function GetOptions: IADStanOptions;
    function GetErrorHandler: IADStanErrorHandler;
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    function GetUpdateHandler: IADDAptUpdateHandler;
    procedure SetUpdateHandler(const AValue: IADDAptUpdateHandler);
    function GetDescribeHandler: IADPhysDescribeHandler;
    procedure SetDescribeHandler(const AValue: IADPhysDescribeHandler);

    // ??? temporary solution
    function GetObj: TObject;

    // public
    function Define: TADDatSTable;
    procedure Fetch(AAll: Boolean = False); overload;
    function Update(AMaxErrors: Integer = -1): Integer; overload;
    function Reconcile: Boolean;
    procedure Reset;

    procedure Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
      AColumn: Integer; ARowOptions: TADPhysFillRowOptions); overload;
    procedure Update(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = [];
      AForceRequest: TADPhysRequest = arFromRow); overload;
    procedure Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []);
    procedure UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []);

    property SourceRecordSetID: Integer read GetSourceRecordSetID write SetSourceRecordSetID;
    property SourceRecordSetName: String read GetSourceRecordSetName write SetSourceRecordSetName;
    property UpdateTableName: String read GetUpdateTableName write SetUpdateTableName;
    property DatSTableName: String read GetDatSTableName write SetDatSTableName;
    property DatSTable: TADDatSTable read GetDatSTable write SetDatSTable;
    property ColumnMappings: TADDAptColumnMappings read GetColumnMappings;
    property MetaInfoMergeMode: TADPhysMetaInfoMergeMode read GetMetaInfoMergeMode
      write SetMetaInfoMergeMode;
    property TableMappings: IADDAptTableAdapters read GetTableMappings;
    property DatSManager: TADDatSManager read GetDatSManager write SetDatSManager;

    property SelectCommand: IADPhysCommand read GetSelectCommand write SetSelectCommand;
    property InsertCommand: IADPhysCommand read GetInsertCommand write SetInsertCommand;
    property UpdateCommand: IADPhysCommand read GetUpdateCommand write SetUpdateCommand;
    property DeleteCommand: IADPhysCommand read GetDeleteCommand write SetDeleteCommand;
    property LockCommand: IADPhysCommand read GetLockCommand write SetLockCommand;
    property UnLockCommand: IADPhysCommand read GetUnLockCommand write SetUnLockCommand;
    property FetchRowCommand: IADPhysCommand read GetFetchRowCommand write SetFetchRowCommand;

    property Options: IADStanOptions read GetOptions;
    property ErrorHandler: IADStanErrorHandler read GetErrorHandler write SetErrorHandler;
    property UpdateHandler: IADDAptUpdateHandler read GetUpdateHandler
      write SetUpdateHandler;
    property DescribeHandler: IADPhysDescribeHandler read GetDescribeHandler
      write SetDescribeHandler;
  end;

  IADDAptTableAdapters = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2305}']
    // private
    function GetItems(AIndex: Integer): IADDAptTableAdapter;
    function GetCount: Integer;
    // public
    function Lookup(ATable: Pointer; ANameKind: TADPhysNameKind): IADDAptTableAdapter;
    function Add(const ASourceRecordSetName: String = ''; const ADatSTableName: String = '';
      const AUpdateTableName: String = ''): IADDAptTableAdapter; overload;
    procedure Add(const AAdapter: IADDAptTableAdapter); overload;
    procedure Remove(ATable: Pointer; ANameKind: TADPhysNameKind); overload;
    procedure Remove(const AAdapter: IADDAptTableAdapter); overload;
    property Items[AIndex: Integer]: IADDAptTableAdapter read GetItems;
    property Count: Integer read GetCount;
  end;

  {-----------------------------------------------------------------------------}
  // Data schema business processor. It is able:
  // - post updates from all DataTable's rows to DB
  // - reconcilation
  // - create IADDAptView's

  IADDAptSchemaAdapter = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2306}']
    // private
    function GetErrorHandler: IADStanErrorHandler;
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);
    function GetTableAdapters: IADDAptTableAdapters;
    function GetUpdateHandler: IADDAptUpdateHandler;
    procedure SetUpdateHandler(const AValue: IADDAptUpdateHandler);

    // public
    function Update(AMaxErrors: Integer = -1): Integer;
    function Reconcile: Boolean;

    property DatSManager: TADDatSManager read GetDatSManager write SetDatSManager;
    property TableAdapters: IADDAptTableAdapters read GetTableAdapters;

    property ErrorHandler: IADStanErrorHandler read GetErrorHandler write SetErrorHandler;
    property UpdateHandler: IADDAptUpdateHandler read GetUpdateHandler
      write SetUpdateHandler;
  end;

  {-----------------------------------------------------------------------------}
  EADDAptRowUpdateException = class(EADException)
  private
    FAction: TADErrorAction;
    FRequest: TADPhysUpdateRequest;
    FRow: TADDatSRow;
    FException: Exception;
  public
    constructor Create(ARequest: TADPhysUpdateRequest; ARow: TADDatSRow;
      AAction: TADErrorAction; AException: Exception); overload;
    property Exception: Exception read FException;
    property Request: TADPhysUpdateRequest read FRequest;
    property Row: TADDatSRow read FRow;
    property Action: TADErrorAction read FAction write FAction;
  end;

implementation

{-------------------------------------------------------------------------------}
{ EADDAptRowUpdateException                                                     }
{-------------------------------------------------------------------------------}
constructor EADDAptRowUpdateException.Create(ARequest: TADPhysUpdateRequest;
  ARow: TADDatSRow; AAction: TADErrorAction; AException: Exception);
begin
  inherited Create(0, '');
  FRequest := ARequest;
  FRow := ARow;
  FAction := AAction;
  FException := AException;
end;

end.

