unit fCachedUpdates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, Buttons, ExtCtrls, StdCtrls, Grids, DBGrids, DBCtrls,
  fMainQueryBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient, daADCompDataSet, fMainCompBase,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
  daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
  daADGUIxFormsControls, jpeg;

type
  TfrmCachedUpdates = class(TfrmMainQueryBase)
    qryProducts: TADQuery;
    qryProductsProductID: TIntegerField;
    qryProductsProductName: TStringField;
    qryProductsSupplierID: TIntegerField;
    qryProductsCategoryID: TIntegerField;
    qryProductsQuantityPerUnit: TStringField;
    qryProductsUnitPrice: TCurrencyField;
    qryProductsUnitsInStock: TSmallintField;
    qryProductsUnitsOnOrder: TSmallintField;
    qryProductsReorderLevel: TSmallintField;
    qryProductsDiscontinued: TBooleanField;
    qryProductsCategoryName: TStringField;
    usProducts: TADUpdateSQL;
    usCategories: TADUpdateSQL;
    dsProducts: TDataSource;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    btnApply: TSpeedButton;
    btnCancel: TSpeedButton;
    btnCommit: TSpeedButton;
    btnRevert: TSpeedButton;
    btnUndoLast: TSpeedButton;
    Panel1: TPanel;
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCommitClick(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
    procedure btnUndoLastClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure qryProductsUpdateRecord(ASender: TDataSet;
      ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADPhysUpdateRowOptions);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCachedUpdates: TfrmCachedUpdates;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmCachedUpdates.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  RegisterDS(qryProducts);
end;

procedure TfrmCachedUpdates.qryProductsUpdateRecord(ASender: TDataSet;
  ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
  AOptions: TADPhysUpdateRowOptions);
begin
  // Categories and Products DB tables are related one-to-many.
  // qryProducts.SQL is a join of Products and Categories tables.
  // usProducts posts changes to Products table and usCategories
  // to Categories one. At first, we post changes to Products
  // (detail) table, at second to Categories (master) one.
  if not (ARequest in [arLock, arUnlock]) then begin
    usProducts.ConnectionName := qryProducts.ConnectionName;
    usProducts.DataSet := qryProducts;
    usProducts.Apply(ARequest, AAction, AOptions);

    if AAction = eaApplied then begin
      usCategories.ConnectionName := qryProducts.ConnectionName;
      usCategories.DataSet := qryProducts;
      usCategories.Apply(ARequest, AAction, AOptions);
    end;
  end;
  AAction := eaApplied;
end;

procedure TfrmCachedUpdates.btnApplyClick(Sender: TObject);
begin
  qryProducts.ApplyUpdates;
end;

procedure TfrmCachedUpdates.btnCancelClick(Sender: TObject);
begin
  qryProducts.CancelUpdates;
end;

procedure TfrmCachedUpdates.btnCommitClick(Sender: TObject);
begin
  qryProducts.CommitUpdates;
end;

procedure TfrmCachedUpdates.btnRevertClick(Sender: TObject);
begin
  qryProducts.RevertRecord;
end;

procedure TfrmCachedUpdates.btnUndoLastClick(Sender: TObject);
begin
  qryProducts.UndoLastChange(True);
end;

procedure TfrmCachedUpdates.cbDBClick(Sender: TObject);
begin
  qryProducts.Close;
  inherited cbDBClick(Sender);
  qryProducts.Open;
end;

end.
