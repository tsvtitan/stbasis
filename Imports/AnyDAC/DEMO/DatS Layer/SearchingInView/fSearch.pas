unit fSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, daADPhysIntf, jpeg;

type
  TfrmSearch = class(TfrmMainLayers)
    edtShipperId: TLabeledEdit;
    edtCompanyName: TEdit;
    edtPhone: TEdit;
    Label3: TLabel;
    btnFindSorted: TSpeedButton;
    btnLocate: TSpeedButton;
    cbLocate: TComboBox;
    Label4: TLabel;
    btnFindUnSorted: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindSortedClick(Sender: TObject);
    procedure btnLocateClick(Sender: TObject);
    procedure btnFindUnSortedClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
    FTab: TADDatSTable;
    FDataView: TADDatSView;
    FCommIntf: IADPhysCommand;
  public
    { Public declarations }
  end;

var
  frmSearch: TfrmSearch;

implementation

uses
  uDatSUtils;

{$R *.dfm}


procedure TfrmSearch.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create('Tab');
end;

procedure TfrmSearch.FormDestroy(Sender: TObject);
begin
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmSearch.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf.CreateCommand(FCommIntf);
  with FCommIntf do begin
    Prepare('select * from {id Shippers}');
    Define(FTab);
    Open;
    Fetch(FTab);
  end;
  PrintRows(FTab, Console.Lines, 'The table...');
  FDataView := FTab.DefaultView;

  btnFindSorted.Enabled := True;
  btnFindUnSorted.Enabled := True;
  btnLocate.Enabled := True;
end;

procedure TfrmSearch.btnFindSortedClick(Sender: TObject);
var
  i: Integer;
begin
  // Add sort to the view and find row using sorted column values
  FDataView.Mechanisms.AddSort('ShipperID;CompanyName');
  i := FDataView.Find([StrToInt(edtShipperId.Text), edtCompanyName.Text]);

  if i <> -1 then
    PrintRow(FDataView.Rows[i], Console.Lines, 'Found row')
  else
    Console.Lines.Add('Row don''t found');
  FDataView.Mechanisms.Clear;
end;

procedure TfrmSearch.btnFindUnSortedClick(Sender: TObject);
var
  i: Integer;
begin
  // Find row specifing column names and values
  i := FDataView.Find([edtShipperId.Text, edtCompanyName.Text, edtPhone.Text],
    'ShipperID;CompanyName;Phone');

  if i <> -1 then
    PrintRow(FDataView.Rows[i], Console.Lines, 'Found row')
  else
    Console.Lines.Add('Row don''t found');
end;

procedure TfrmSearch.btnLocateClick(Sender: TObject);
var
  oMech: TADDatSMechFilter;
  i: Integer;
begin
  // Locate row using locating mechanism
  oMech := TADDatSMechFilter.Create(cbLocate.Text);
  oMech.Locator := True;
  FDataView.Mechanisms.Add(oMech);
  FDataView.Locate(i, True, True);

  if i <> -1 then
    PrintRow(FDataView.Rows[i], Console.Lines, 'Found row')
  else
    Console.Lines.Add('Row don''t found');
  FDataView.Mechanisms.Clear;
end;

end.
