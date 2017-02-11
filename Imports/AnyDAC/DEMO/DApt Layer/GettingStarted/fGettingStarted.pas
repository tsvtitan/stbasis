unit fGettingStarted;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  fMainLayers,
  daADDatSManager, daADPhysIntf, daADDAptIntf, jpeg;

type
  TfrmGettingStarted = class(TfrmMainLayers)
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGettingStarted: TfrmGettingStarted;

implementation

{$R *.dfm}

uses
  dmMainBase,
  uDatSUtils,
  daADStanFactory;

procedure TfrmGettingStarted.cbDBClick(Sender: TObject);
var
  oComm:     IADPhysCommand;
  oSchAdapt: IADDAptSchemaAdapter;
  oAdapt:    IADDAptTableAdapter;
  oTab:      TADDatSTable;
begin
  Console.Clear;
  inherited cbDBClick(Sender);
  // 1. create schema manager
  // It is not required, we can create standalone table adapter.
  ADCreateInterface(IADDAptSchemaAdapter, oSchAdapt);

  // 2. create and assign DatSManager to schema adapter
  // It is not required, AnyDAC will automatically allocate
  // DatSManager, if it is not assigned.
  oSchAdapt.DatSManager := TADDatSManager.Create;

  // 3. create table adapter
  // It will handle "Shippers" result set and put it
  // into "MappedShippers" DatSTable.
  oAdapt := oSchAdapt.TableAdapters.Add(EncodeName('Shippers'), 'MappedShippers');

  // 4. map result set columns to DatSTable columns
  // It is not required, AnyDAC by default will handle all
  // result set columns using they names.
  oAdapt.ColumnMappings.Add(EncodeField('ShipperID'),   'MappedShipperID');
  oAdapt.ColumnMappings.Add(EncodeField('CompanyName'), 'MappedCompanyName');
  oAdapt.ColumnMappings.Add(EncodeField('Phone'),       'MappedPhone');
  // Note! EncodeName and EncodeField functions aren't AnyDAC methods.
  // They serve to encoding name with separators of concrete RDBMS and
  // help this demo making clear program code. E.g. for MySQL the name
  // 'ADQA_map1' must be encoded as '`ADQA_map1`', in MSSQL as '[ADQA_map1]' etc.

  // 5. create and assign command to table adapter
  FConnIntf.CreateCommand(oComm);
  oAdapt.SelectCommand := oComm;
  oAdapt.SelectCommand.Prepare('select * from {id Shippers}');

  // 6. create DatSTable to fetch result set
  oAdapt.Define;

  // 7. fetch result set
  oAdapt.Fetch(True);

  // 8. get DatSTable and print it
  oTab := oAdapt.DatSTable;
  PrintRows(oTab, Console.Lines);

  // 9. compiler here will release schema adapter, table
  // adapter and command interfaces.
end;

end.

