unit fCompareRows;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fDatSLayerBase,
  daADDatSManager, daADStanIntf, jpeg;

type
  TfrmCompareRows = class(TfrmDatSLayerBase)
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FTab: TADDatSTable;
    FRow, FRowDiff: TADDatSRow;
  end;

var
  frmCompareRows: TfrmCompareRows;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmCompareRows.FormCreate(Sender: TObject);
begin
  // creating and defining a table structure
  FTab := TADDatSTable.Create('Tab');
  with FTab.Columns do begin
    Add('ID', dtInt32);
    Add('f1', dtAnsiString).Size := 5;
    Add('f2', dtAnsiString).Size := 5;
    Add('f3', dtDouble);
  end;

  // populating the table
  FRow := FTab.Rows.Add([1, 'Hello', 'world', 3.1415926535]);
  FRowDiff := FTab.NewRow;
  PrintRowVersion(FRow, Console.Lines);
end;

procedure TfrmCompareRows.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

procedure TfrmCompareRows.SpeedButton1Click(Sender: TObject);
var
  i: TADDatSRowVersion;
  s: String;
begin
  Console.Lines.Add('');
  // Copying data to buffer...
  FTab.Import(FRow, FRowDiff);

  // editing
  with FRow do begin
    Console.Lines.Add('Changing values...');
    BeginEdit;
    SetValues([10, 'World', 'hello', 0.5]);
    PrintRowVersion(FRow, Console.Lines);
  end;

  // Comparing
  with FRow do
   for i := Low(TADDatSRowVersion) to High(TADDatSRowVersion) do
    if HasVersion(i) then begin
      Console.Lines.Add(RowVersions[i]);
      case CompareRows(nil, nil, nil, -1, FRowDiff, nil, i, [], ADEmptyCC) of
      0:  s:= 'FRow = FRowDiff';
      1:  s:= 'FRow > FRowDiff';
      -1: s:= 'FRow < FRowDiff';
      end;
      Console.Lines.Add(s);
    end;
end;

end.
