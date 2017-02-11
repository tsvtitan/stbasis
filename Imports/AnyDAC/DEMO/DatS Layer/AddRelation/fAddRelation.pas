unit fAddRelation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainBase,
  daADDatSManager, daADStanIntf, fDatSLayerBase, jpeg;

type
  TfrmAddRelation = class(TfrmDatSLayerBase)
    btnCreateDatSManager: TSpeedButton;
    btnCreateRel: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateDatSManagerClick(Sender: TObject);
    procedure btnCreateRelClick(Sender: TObject);
  private
    { Private declarations }
    FTab1, FTab2, FTab3: TADDatSTable;
    FDatSManager: TADDatSManager;
  public
    { Public declarations }
  end;

var
  frmAddRelation: TfrmAddRelation;

implementation

uses
  uDatSUtils;

var
  oPK1, oPK2, oPK3: TADDatSUniqueConstraint;
  oFK, oFK1, oFK2: TADDatSForeignKeyConstraint;

{$R *.dfm}

procedure TfrmAddRelation.btnCreateDatSManagerClick(Sender: TObject);
begin
  FDatSManager := TADDatSManager.Create;

  FTab1 := FDatSManager.Tables.Add('Table1');
  with FTab1.Columns.Add('pkey1', dtInt32) do begin
    AutoIncrement := True;
    AutoIncrementSeed := -1;
    AutoIncrementStep := -1;
    Attributes := Attributes - [caAllowNull];
  end;
  FTab1.Columns.Add('name', dtAnsiString).Size := 15;

  FTab2 := FDatSManager.Tables.Add('Table2');
  with FTab2.Columns.Add('pkey2', dtInt32) do begin
    AutoIncrement := True;
    AutoIncrementSeed := 1;
    AutoIncrementStep := 2;
    Attributes := Attributes - [caAllowNull];
  end;
  FTab2.Columns.Add('fkey', dtInt32);

  FTab3 := FDatSManager.Tables.Add('Table3');
  with FTab3.Columns.Add('pkey3', dtInt32) do begin
    AutoIncrement := True;
    AutoIncrementSeed := -10;
    AutoIncrementStep := 4;
    Attributes := Attributes - [caAllowNull];
  end;
  FTab3.Columns.Add('fkey1', dtInt32);
  FTab3.Columns.Add('fkey2', dtInt32);

  // unique key constraints
  oPK1 := FTab1.Constraints.AddUK('PK1', 'pkey1', True);
  oPK2 := FTab2.Constraints.AddUK('PK2', 'pkey2', True);
  oPK3 := FTab3.Constraints.AddUK('PK3', 'pkey3', True);
  // foreign key constraints
  oFK := FTab2.Constraints.AddFK('FK21', 'Table1', 'pkey1', 'fkey');
  oFK1 := FTab3.Constraints.AddFK('FK31', 'Table1', 'pkey1', 'fkey1');
  oFK2 := FTab3.Constraints.AddFK('FK32', 'Table2', 'pkey2', 'fkey2');

  btnCreateRel.Enabled := True;
end;

procedure TfrmAddRelation.btnCreateRelClick(Sender: TObject);
var
  i, j, k: Integer;
  oRel: TADDatSRelation;

  procedure PrintChildRows(ATab: TADDatSTable);
  var
    oRelations: TADDatSRelationArray;
    oRel: TADDatSRelation;
    oRow: TADDatSRow;
    oChildView: TADDatSView;
    i, j: Integer;
  begin
    oRelations := ATab.ChildRelations;
    for i := 0 to Length(oRelations) - 1 do begin
      oRel := oRelations[i];

      for j := 0 to ATab.Rows.Count - 1 do begin
        oRow := ATab.Rows[j];
        PrintRow(oRow, Console.Lines, '------ Parent Row ' + ATab.Name);
        oChildView := oRow.GetChildRows(oRel);
        try
          // Print values of rows from child view
          PrintRows(oChildView, Console.Lines, 'child rows');
        finally
          oChildView.Free;
        end;
      end;
    end;
  end;

begin
  // 1. create relation (first way) and add it to DatSManager
  oRel := TADDatSRelation.Create;
  FDatSManager.Relations.Add(oRel);
  with oRel do begin
    Name := 'Tab1_Tab2';
    ParentKeyConstraint := oPK1;
    ChildKeyConstraint := oFK;
  end;

  // 2. second way
  {oRel := TADDatSRelation.Create('RelName', oPK1, oFK);}

  // 3. third way
  FDatSManager.Relations.Add('Tab1_Tab3', oPK1, oFK1);

  // 4. fourth way
  FDatSManager.Relations.Add('Tab2_Tab3',
    FTab2.Columns.ColumnByName('pkey2'),
    FTab3.Columns.ColumnByName('fkey2'));

  // 5. populate the tables
  for i := 0 to 2 do begin
    FTab1.Rows.Add([Unassigned, 'parent row #' + IntToStr(i)]);
    for j := 0 to 2 do begin
      FTab2.Rows.Add([Unassigned, FTab1.Rows[i].GetData('pkey1')]);
      for k := 0 to 2 do
        FTab3.Rows.Add([Unassigned, FTab1.Rows[i].GetData('pkey1'), FTab2.Rows[i * 3 + j].GetData('pkey2')]);
    end;
  end;

  // 6. print rows
  PrintChildRows(FTab1);
  PrintChildRows(FTab2);
end;

procedure TfrmAddRelation.FormDestroy(Sender: TObject);
begin
  FDatSManager.Free;
end;

end.


