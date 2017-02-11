unit fRowFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, daADPhysIntf, jpeg;

type
  TfrmRowFilter = class(TfrmMainLayers)
    cbRowStates: TComboBox;
    cbRowFilter: TComboBox;
    Label3: TLabel;
    Label1: TLabel;
    btnChange: TSpeedButton;
    btnAccept: TSpeedButton;
    btnResetFilters: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbRowFilterChange(Sender: TObject);
    procedure cbRowStatesChange(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure btnResetFiltersClick(Sender: TObject);
  private
    { Private declarations }
    FTab: TADDatSTable;
    FDataView: TADDatSView;
    FCommIntf: IADPhysCommand;
  public
    { Public declarations }
  end;

var
  frmRowFilter: TfrmRowFilter;

implementation

uses
  uDatSUtils;

{$R *.dfm}


procedure TfrmRowFilter.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create;
end;

procedure TfrmRowFilter.FormDestroy(Sender: TObject);
begin
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmRowFilter.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  // fetching table
  FConnIntf.CreateCommand(FCommIntf);
  with FCommIntf do begin
    Prepare('select * from {id Shippers}');
    Define(FTab);
    Open;
    Fetch(FTab);
  end;
  FDataView := FTab.DefaultView;
  PrintRows(FTab, Console.Lines, 'The table...', True);

  cbRowStates.Enabled := True;
  cbRowFilter.Enabled := True;
  btnChange.Enabled := True;
  btnAccept.Enabled := True;
  btnResetFilters.Enabled := True;
end;

procedure TfrmRowFilter.cbRowFilterChange(Sender: TObject);
begin
  with FDataView do begin
    RowFilter := cbRowFilter.Text;
    PrintRows(FDataView, Console.Lines, 'View with RowFilter = ' + cbRowFilter.Text, True);
  end
end;

procedure TfrmRowFilter.cbRowStatesChange(Sender: TObject);
begin
  with FDataView do begin
    RowStateFilter := [TADDatSRowState(cbRowStates.ItemIndex)];
    PrintRows(FDataView, Console.Lines, 'View with RowStateFilter = ' + cbRowStates.Text, True);
  end
end;

procedure TfrmRowFilter.btnResetFiltersClick(Sender: TObject);
begin
  cbRowStates.ItemIndex := -1;
  cbRowFilter.ItemIndex := -1;
  with FDataView do begin
    RowFilter := '';
    RowStateFilter := [];
  end;
end;

procedure TfrmRowFilter.btnChangeClick(Sender: TObject);
begin
  with FTab.Rows[0] do begin
    BeginEdit;
    SetValues([Unassigned, 'String', 10]);
    EndEdit;
  end;
  FTab.Rows[2].Delete;
  PrintRows(FDataView, Console.Lines, 'View after rows editing...', True);
end;

procedure TfrmRowFilter.btnAcceptClick(Sender: TObject);
begin
  FTab.AcceptChanges;
  PrintRows(FTab, Console.Lines, 'View after accepting row changes...', True);
end;

end.
