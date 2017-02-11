unit fMechanisms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, jpeg;

type
  TfrmMechanisms = class(TfrmMainLayers)
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
    FDefaultView: TADDatSView;
  public
    { Public declarations }
  end;

var
  frmMechanisms: TfrmMechanisms;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmMechanisms.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

procedure TfrmMechanisms.btnCreateTableClick(Sender: TObject);
var
  i: Integer;
begin
  // create table
  FTab := TADDatSTable.Create('Table1');
  with FTab.Columns do begin
    Add('id', dtInt32);
    Add('name').Size := 15;
    Add('price1', dtBCD);
    Add('price2', dtBCD);
  end;
  // populate table
  for i := 0 to 6 do
    FTab.Rows.Add([i, 'thing' + IntToStr(6 - i), 20 + i, 20 - i]);
  btnCreateTable.Enabled := False;
  btnCreateView.Enabled := True;
end;

procedure TfrmMechanisms.btnCreateViewClick(Sender: TObject);
begin
  FDefaultView := FTab.DefaultView;
  btnPrint.Enabled := True;
end;

procedure TfrmMechanisms.btnPrintClick(Sender: TObject);
var
  oMechFilter: TADDatSMechFilter;
begin
  // 1) Default view
  PrintRows(FTab, Console.Lines, 'Our table...');
  PrintRows(FDefaultView, Console.Lines, 'Default view...');

  // 2) first way - set view property
  FDefaultView.Sort := 'name';
  PrintRows(FDefaultView, Console.Lines, 'Default view with sort [name]...');
  // clear mechanism list
  FDefaultView.Mechanisms.Clear;

  // 3) second way - call mechanisms method
  FDefaultView.Mechanisms.AddSort('price1');
  PrintRows(FDefaultView, Console.Lines, 'Add sort mechanism [price1]...');
  FDefaultView.Mechanisms.Clear;

  // ... similar, but with expression
  FDefaultView.Mechanisms.AddSort('price2 - price1', []);
  PrintRows(FDefaultView, Console.Lines, 'Add sort mechanism [price2 - price1]...');
  FDefaultView.Mechanisms.Clear;

  // 4) filtering
  oMechFilter := TADDatSMechFilter.Create('id > 3');
  FDefaultView.Mechanisms.Add(oMechFilter);
  PrintRows(FDefaultView, Console.Lines, 'Add filter mechanism [id > 3]...');
  FDefaultView.Mechanisms.Clear;

  // 5) too
  FDefaultView.Mechanisms.AddFilter('id > 5');
  PrintRows(FDefaultView, Console.Lines, 'Once more add filter mechanism [id > 5]....');
  FDefaultView.Mechanisms.Clear;
end;

end.


