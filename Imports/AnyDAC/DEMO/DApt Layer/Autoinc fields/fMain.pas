unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  fMainLayers,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient;

type
  TfrmMain = class(TfrmMainLayers)
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  daADStanFactory,
  uDatSUtils;

procedure TfrmMain.cbDBClick(Sender: TObject);
var
  oComm:      IADPhysCommand;
  oSchAdapt:  IADDAptSchemaAdapter;
  oMastAdapt,
  oDetAdapt:  IADDAptTableAdapter;
  oMastRow:   TADDatSRow;
begin
  inherited cbDBClick(Sender);

  // 1. create schema adapter
  ADCreateInterface(IADDAptSchemaAdapter, oSchAdapt);

  // 2. add master table adapter
  oMastAdapt := oSchAdapt.TableAdapters.Add(EncodeName('ADQA_master_autoinc'), 'master');
  with oMastAdapt do begin
    ColumnMappings.Add(EncodeField('id1'),   'parent_id');
    ColumnMappings.Add(EncodeField('name1'), 'title1');
    FConnIntf.CreateCommand(oComm);
    SelectCommand := oComm;
    SelectCommand.Prepare('select * from {id ADQA_master_autoinc}');
    Define;
    with DatSTable.Columns[0] do
      ServerAutoIncrement := True;   // Set this property if a table in RDBMS has identity field
                                     // Setting this property automatically assign
                                     //   AutoIncrementSeed := -1;
                                     //   AutoIncrementStep := -1;
                                     // in order duplicate key error doesn't arise
    Fetch;
    PrintRows(DatSTable, Console.Lines, 'Fetched master rows --------------');
  end;

  // 3. add detail table adapter
  oDetAdapt := oSchAdapt.TableAdapters.Add(EncodeName('ADQA_details_autoinc'), 'details');
  with oDetAdapt do begin
    ColumnMappings.Add(EncodeField('id2'),    'child_id');
    ColumnMappings.Add(EncodeField('fk_id1'), 'fk_parent_id');
    ColumnMappings.Add(EncodeField('name2'),  'title2');
    FConnIntf.CreateCommand(oComm);
    SelectCommand := oComm;
    SelectCommand.Prepare('select * from {id ADQA_details_autoinc}');
    Define;
    with DatSTable.Columns[0] do
      ServerAutoIncrement := True;
    Fetch;
    PrintRows(DatSTable, Console.Lines, 'Fetched detail rows --------------');
  end;

  // 4. add constraints to our DatSManager
  with oSchAdapt.DatSManager.Tables.ItemsS['master'] do
    Constraints.AddUK('master_pk',  'parent_id', True);
  with oSchAdapt.DatSManager.Tables.ItemsS['details'] do begin
    Constraints.AddUK('details_pk', 'child_id',  True);
    with Constraints.AddFK('details_fk_master', 'master', 'parent_id', 'fk_parent_id') do begin
      UpdateRule := crCascade;
      DeleteRule := crCascade;
      AcceptRejectRule := arCascade;
    end;
  end;

  // 5. add new row to the master table
  oMastRow := oMastAdapt.DatSTable.Rows.Add([Unassigned, 'master new row']); // Set Unassigned for identity fields
  PrintRows(oMastAdapt.DatSTable, Console.Lines, 'Master rows after addition --------------');

  // 6. add new rows to the detail table
  oDetAdapt.DatSTable.Rows.Add([Unassigned, oMastRow.GetData('parent_id'), 'details new row 1']);
  oDetAdapt.DatSTable.Rows.Add([Unassigned, oMastRow.GetData('parent_id'), 'details new row 2']);
  PrintRows(oDetAdapt.DatSTable, Console.Lines, 'Detail rows after addition --------------');

  // 7. Post changes to RDBMS and reconcile errors
  oSchAdapt.Update;
  oSchAdapt.Reconcile;
  PrintRows(oMastAdapt.DatSTable, Console.Lines, 'Master rows after posting updates --------------');
  PrintRows(oDetAdapt.DatSTable, Console.Lines, 'Detail rows after posting updates --------------');
end;

end.

