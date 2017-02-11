unit fCreateTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fDatSLayerBase,
  daADDatSManager, daADStanIntf, jpeg;

type
  TfrmCreateTable = class(TfrmDatSLayerBase)
    btnCreateTable: TSpeedButton;
    btnDefColumns: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateTableClick(Sender: TObject);
    procedure btnDefColumnsClick(Sender: TObject);
  private
    { Private declarations }
    FTab: TADDatSTable;
    FCol: TADDatSColumn;
  public
    { Public declarations }
  end;

var
  frmCreateTable: TfrmCreateTable;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmCreateTable.btnCreateTableClick(Sender: TObject);
begin
  FTab := TADDatSTable.Create('Table');

  btnDefColumns.Enabled := True;
end;

procedure TfrmCreateTable.btnDefColumnsClick(Sender: TObject);
begin
  // define column
  FCol := TADDatSColumn.Create;
  FTab.Columns.Add(FCol);                                             // adding to table
  with FCol do begin
    Name := 'name';                                                   // you may set name during create
                                                                      // FCol := TADDatSColumn.Create('name');
    DataType := dtAnsiString;
    Size := 6;                                                        // size of string
  end;

  // define identity column
  with FTab.Columns.Add('id', dtInt32) do begin
    AutoIncrement := True;                                            // autoincremental field
    AutoIncrementSeed := -1;                                          // starting value of autoinc. field
    AutoIncrementStep := -1;                                          // step of increment
    Attributes := Attributes - [caAllowNull];                         // setting not allow nulls attribute
  end;
  // Note! Identity column may be of any AnyDAC numeric type: dtByte, dtSByte, dtIntXX/dtUIntXX, dtBCD, dtFmtBCD,
  // dtDouble, dtCurrency

  // define other columns
  FTab.Columns.Add('memo', dtMemo);
  FTab.Columns.Add('image', dtBlob);
  with FTab.Columns.Add('price', dtFmtBCD) do begin
    Precision := 10;
    Scale := 4;
  end;
  FTab.Columns.Add('modified', dtBoolean);
  FTab.Columns.Add('date_modif', dtDate);
  FTab.Columns.Add('time_modif', dtTime);
  FTab.Columns.Add('datetime_modif', dtDateTime);

  // populate the table
  FTab.Rows.Add(['first', Unassigned, 'memo column', 'image', 123.3434, True, Date, Time, Now]);
  Sleep(1000);
  FTab.Rows.Add(['second', Unassigned, 'memo column 2', 'image 2', 111222.23, False, Date, Time, Now]);

  PrintRows(FTab, Console.Lines, 'The table...');
end;

procedure TfrmCreateTable.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

end.
