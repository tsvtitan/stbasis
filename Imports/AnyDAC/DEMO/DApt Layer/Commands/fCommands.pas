unit fCommands;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  fMainLayers,
  daADDatSManager,
  daADPhysIntf,
  daADDAptIntf, jpeg;

type
  TfrmCommands = class(TfrmMainLayers)
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCommands: TfrmCommands;

implementation

{$R *.dfm}

uses
  dmMainBase,
  uDatSUtils,
  daADStanFactory;

procedure TfrmCommands.cbDBClick(Sender: TObject);
var
  oComm:  IADPhysCommand;
  oAdapt: IADDAptTableAdapter;
  i:      Integer;
begin
  inherited cbDBClick(Sender);
  // 1. Create table adapter and setup it
  ADCreateInterface(IADDAptTableAdapter, oAdapt);
  with oAdapt do begin
    FConnIntf.CreateCommand(oComm);
    SelectCommand := oComm;
    SelectCommand.Prepare('select * from {id ADQA_map1}');
    Define;
    Fetch;
    PrintRows(DatSTable, Console.Lines, 'Fetched rows ----------------');

    // 2. Redirect all record inserts into ADQA_map2 table instead ADQA_map1
    FConnIntf.CreateCommand(oComm);
    InsertCommand := oComm;
    InsertCommand.CommandText := 'insert into {id ADQA_map2}(id2, name2) values(:NEW_id1, :NEW_name1)';

    // 3. Redirect all record deletes into ADQA_map3 table instead ADQA_map1
    FConnIntf.CreateCommand(oComm);
    DeleteCommand := oComm;
    DeleteCommand.CommandText := 'delete from {id ADQA_map3} where id3 = :OLD_id1';

    // 4. Redirect all record updates into ADQA_map4 table instead ADQA_map1
    FConnIntf.CreateCommand(oComm);
    UpdateCommand := oComm;
    UpdateCommand.CommandText := 'update {id ADQA_map4} set id4 = :NEW_id1, name4 = :NEW_name1 where id4 = :OLD_id1';

    // 5. Add new rows
    for i := 0 to 4 do
      DatSTable.Rows.Add([i, 'string' + IntToStr(i)]);
    PrintRows(DatSTable, Console.Lines, 'Rows after addition ----------------');

    // 6. Post changes to RDBMS
    // In this example 5 new records will be inserted into ADQA_map2 table
    Update;
    PrintRows(DatSTable, Console.Lines, 'Rows after posting updates ----------------');
  end;
end;

end.

