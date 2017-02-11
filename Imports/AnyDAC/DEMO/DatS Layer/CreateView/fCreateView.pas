unit fCreateView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fDatSLayerBase,
  daADDatSManager, daADStanIntf, jpeg;

type
  TfrmCreateView = class(TfrmDatSLayerBase)
    btnCreateTable: TSpeedButton;
    btnCreateView: TSpeedButton;
    btnPrint: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateTableClick(Sender: TObject);
    procedure btnCreateViewClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    FTab: TADDatSTable;
    FDataView1, FDataView2, FDataView3, FDefaultView: TADDatSView;
  public
    { Public declarations }
  end;

var
  frmCreateView: TfrmCreateView;

implementation

uses
  uDatSUtils;

{$R *.dfm}

const
  Names: array [0..6] of String = ('Lamp', 'Table', 'Spoon', 'Cup', 'Dish', 'Table-cloth', 'Chair');
  Prices: array [0..6] of Currency = (134.12, 462.22, 3.35, 24.44, 120.10, 22.14, 321.35);

procedure TfrmCreateView.btnCreateTableClick(Sender: TObject);
var
  i: Integer;
begin
  FTab := TADDatSTable.Create('Orders');
  FTab.Columns.Add('id', dtInt32);
  FTab.Columns.Add('name').Size := 11;
  FTab.Columns.Add('price', dtCurrency);

  // populate the table
  for i := 0 to 6 do
    FTab.Rows.Add([i, Names[i], Prices[i]]);

  btnCreateView.Enabled := True;
end;

procedure TfrmCreateView.btnCreateViewClick(Sender: TObject);
begin
  // 1) first way, explicit mechanism usage
  // Sorted by price and rows with prices < 50.12
  FDataView1 := TADDatSView.Create;
  FDataView1.Name := 'Sorting1';
  FDataView1.Mechanisms.Add(TADDatSMechSort.Create('price', '', '', []));
  FDataView1.Mechanisms.Add(TADDatSMechFilter.Create('price < 50.12'));
  FTab.Views.Add(FDataView1);
  FDataView1.Active := True;

  // 2) second way, implicit mechanism usage
  // Sorted by price
  FDataView2 := TADDatSView.Create;
  FDataView2.Name := 'Sorting2';
  FDataView2.Sort := 'price';
  FTab.Views.Add(FDataView2);
  FDataView2.Active := True;

  // 3) third way, even more short
  // Sorted by name and rows with id < 2
  FDataView3 := TADDatSView.Create(FTab, 'id < 2', 'name');

  // 4) get default view
  FDefaultView := FTab.DefaultView;
  FDefaultView.RowFilter := 'id > 2';

  btnPrint.Enabled := True;
end;

procedure TfrmCreateView.btnPrintClick(Sender: TObject);
begin
  PrintRows(FTab, Console.Lines, 'Our table...');
  PrintRows(FTab.Views.ViewByName('Sorting1'), Console.Lines, 'Sorted by price and rows with prices < 50.12 ...');
  PrintRows(FTab.Views.ViewByName('Sorting2'), Console.Lines, 'Sorted by price ...');
  PrintRows(FDataView3, Console.Lines, 'Sorted by name and rows with id < 2 ...');
  PrintRows(FDefaultView, Console.Lines, 'Default view with rows with id > 2 ...');
end;

procedure TfrmCreateView.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

end.


