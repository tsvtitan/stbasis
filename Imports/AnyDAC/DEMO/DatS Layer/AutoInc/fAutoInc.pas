unit fAutoInc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, daADPhysIntf, jpeg;

type
  TfrmAutoInc = class(TfrmMainLayers)
    btnInsert: TSpeedButton;
    edtSeed: TLabeledEdit;
    edtStep: TLabeledEdit;
    procedure FormDestroy(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
    FTab: TADDatSTable;
    FCommIntf: IADPhysCommand;
  public
    { Public declarations }
  end;

var
  frmAutoInc: TfrmAutoInc;

implementation

uses
  uDatSUtils;

var
  glInsertedRow: Integer;

{$R *.dfm}

procedure TfrmAutoInc.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create('Shippers');
  glInsertedRow := 0;

  edtSeed.Text := IntToStr(-1);
  edtStep.Text := IntToStr(-1);
end;

procedure TfrmAutoInc.FormDestroy(Sender: TObject);
begin
  FCommIntf := nil;
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmAutoInc.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf.CreateCommand(FCommIntf);
  with FCommIntf do begin
    Prepare('select * from {id Shippers}');
    Define(FTab);
    with FTab.Columns.ColumnByName('ShipperID') do begin   // If you wish add rows to table
      AutoIncrement := True;                               // you must set up identity column
      // All of numeric columns (dtByte/dtSByte, dtIntXX/dtUIntXX, dtDouble, dtBCD/dtFmtBCD, dtCurrency)
      // may be identity in AnyDAC
      AutoIncrementSeed := StrToInt(edtSeed.Text);
      AutoIncrementStep := StrToInt(edtStep.Text);
    end;
    Open;
    Fetch(FTab);
  end;
  PrintRows(FTab, Console.Lines, 'The table...');

  btnInsert.Enabled := True;
end;

procedure TfrmAutoInc.btnInsertClick(Sender: TObject);
begin
  FTab.Rows.Add([Unassigned, 'string' + IntToStr(glInsertedRow), glInsertedRow * 3]);
  Inc(glInsertedRow);
  PrintRows(FTab, Console.Lines, 'Inserted rows...');
end;

end.


