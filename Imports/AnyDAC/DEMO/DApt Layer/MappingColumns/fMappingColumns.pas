unit fMappingColumns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  fMainLayers,
  daADDatSManager, daADPhysIntf, daADDAptIntf, jpeg;

type
  TfrmMappingColumns = class(TfrmMainLayers)
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMappingColumns: TfrmMappingColumns;

implementation

{$R *.dfm}

uses
  daADStanFactory,
  uDatSUtils;

procedure TfrmMappingColumns.cbDBClick(Sender: TObject);
var
  oComm:  IADPhysCommand;
  oAdapt: IADDAptTableAdapter;
  i:      Integer;
begin
  inherited cbDBClick(Sender);
  // 1. create table adapter
  ADCreateInterface(IADDAptTableAdapter, oAdapt);
  with oAdapt do begin

    // 2. assign command
    FConnIntf.CreateCommand(oComm);
    SelectCommand := oComm;
    SelectCommand.Prepare('select * from {id ADQA_map1}');

    // 3. set source result set name
    SourceRecordSetName := EncodeName('ADQA_map1');
    // 4. set DatSTable name, where rows will be fetched
    DatSTableName := 'mapper';
    // 5. set update table name
    UpdateTableName := EncodeName('ADQA_map2');

    // 6. setup column mappings, seting the same 3 names
    ColumnMappings.Add(EncodeField('id1'), 'num', EncodeField('id2'));
    ColumnMappings.Add(EncodeField('name1'), 'title', EncodeField('name2'));

    // 7. fetch rows
    Define;
    Fetch;
    PrintRows(DatSTable, Console.Lines, 'Fetched rows ------------------');

    // 8. append rows and post changes to RDBMS
    // Note! New rows will be added to ADQA_map2(id2, name2) table
    for i := 0 to 9 do
      DatSTable.Rows.Add([i, 'first' + IntToStr(i)]);
    Update;
    PrintRows(DatSTable, Console.Lines, 'Rows after posting changes ------------------');
  end;
end;

end.

