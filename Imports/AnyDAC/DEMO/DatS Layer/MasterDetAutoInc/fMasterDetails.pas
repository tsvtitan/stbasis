unit fMasterDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, daADPhysIntf, jpeg;

type
  TfrmMasterDetails = class(TfrmMainLayers)
    btnInsertMast: TSpeedButton;
    btnInsertDet: TSpeedButton;
    btnPrint: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnInsertMastClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInsertDetClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    FMaster, FDetails: TADDatSTable;
    FDatSManager: TADDatSManager;
    FCommIntf: IADPhysCommand;
    FMasterRow: TADDatSRow;
  end;

var
  frmMasterDetails: TfrmMasterDetails;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmMasterDetails.FormCreate(Sender: TObject);
var
  oCatPK: TADDatSUniqueConstraint;
  oProdFK: TADDatSForeignKeyConstraint;
begin
  inherited FormCreate(Sender);
  FDatSManager := TADDatSManager.Create;

  // 1) define master table
  FMaster := FDatSManager.Tables.Add('Categories');
  with FMaster.Columns do begin
    with Add('CategoryID', dtInt32) do begin
      SourceID := 1;
      // Set up column, appropriate for DB identity field
      ServerAutoIncrement := True;
    end;
    with Add('CategoryName') do begin
      SourceID := 2;
      Size := 15;
      AllowDBNull := False;
    end;
    Add('Description', dtMemo).SourceID := 3;
    Add('Picture', dtBlob).SourceID := 4;
  end;

  // 2) add primary key constraint
  oCatPK := FMaster.Constraints.AddUK('CatPK', 'CategoryID', True);

  // 3) define details table
  FDetails := FDatSManager.Tables.Add('Products');
  with FDetails.Columns do begin
    with Add('ProductID', dtInt32) do begin
      SourceID := 1;
      // Set up column, appropriate for DB identity field
      ServerAutoIncrement := True;
    end;
    with Add('ProductName') do begin
      SourceID := 2;
      Size := 40;
      AllowDBNull := False;
    end;
    Add('CategoryID', dtInt32).SourceID := 3;
  end;

  // 4) add foreign key constraint
  oProdFK := FDetails.Constraints.AddFK('ProdFK', 'Categories', 'CategoryID', 'CategoryID');

  // 5) add relation
  FDatSManager.Relations.Add('Cat_Prod', oCatPK, oProdFK);
end;

procedure TfrmMasterDetails.FormDestroy(Sender: TObject);
begin
  FDatSManager.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmMasterDetails.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf.CreateCommand(FCommIntf);
  with FCommIntf.Options.FormatOptions.MapRules.Add do begin
    PrecMax  := 10;
    PrecMin  := 10;
    SourceDataType := dtFmtBCD;
    TargetDataType := dtInt32;
  end;

  with FCommIntf do begin
    Prepare('select * from {id Categories}');
    Open;
    Fetch(FMaster);

    Prepare('select ProductID, ProductName, CategoryID from {id Products}');
    Open;
    Fetch(FDetails);
  end;

  btnPrintClick(Sender);
  FMasterRow := FMaster.Rows[0];

  btnInsertMast.Enabled := True;
  btnInsertDet.Enabled := True;
  btnPrint.Enabled := True;
end;

procedure TfrmMasterDetails.btnInsertMastClick(Sender: TObject);
begin
  FMasterRow := FMaster.Rows.Add([
    Unassigned,
    'string' + IntToStr(Random(10))
  ]);
end;

procedure TfrmMasterDetails.btnInsertDetClick(Sender: TObject);
begin
  FDetails.Rows.Add([
    Unassigned,
    'string' + IntToStr(Random(100)),
    FMasterRow.GetData(0)
  ]);
end;

procedure TfrmMasterDetails.btnPrintClick(Sender: TObject);
var
  i: Integer;
  oView: TADDatSView;
begin
  Console.Clear;
  for i := 0 to FMaster.Rows.Count - 1 do begin
    oView := FMaster.Rows[i].GetChildRows(FDetails);
    PrintRow(FMaster.Rows[i], Console.Lines, 'master row +++++++++++++++++++++++++++++++++');
    PrintRows(oView, Console.Lines, 'child rows -----------------');
  end;
end;

end.


