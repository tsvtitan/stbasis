unit fUPD_CachedUpdates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, Buttons, ExtCtrls, StdCtrls, Grids, DBGrids, DBCtrls,
  fMainQueryBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADGUIxFormsControls, jpeg;

type
  TfrmCachedUpdates = class(TfrmMainQueryBase)
    qrProducts: TADQuery;
    qrProductsProductID: TIntegerField;
    qrProductsProductName: TStringField;
    qrProductsSupplierID: TIntegerField;
    qrProductsCategoryID: TIntegerField;
    qrProductsQuantityPerUnit: TStringField;
    qrProductsUnitPrice: TCurrencyField;
    qrProductsUnitsInStock: TSmallintField;
    qrProductsUnitsOnOrder: TSmallintField;
    qrProductsReorderLevel: TSmallintField;
    qrProductsDiscontinued: TBooleanField;
    qrProductsCategoryName: TStringField;
    usProducts: TADUpdateSQL;
    usCategories: TADUpdateSQL;
    dsProducts: TDataSource;
    DBGrid1: TDBGrid;
    btnApply: TSpeedButton;
    btnCancel: TSpeedButton;
    btnCommit: TSpeedButton;
    btnRevert: TSpeedButton;
    btnUndoLast: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    procedure qrProductsUpdateRecord(ASender: TDataSet;
      ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADPhysUpdateRowOptions);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCommitClick(Sender: TObject);
    procedure btnRevertClick(Sender: TObject);
    procedure btnUndoLastClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCachedUpdates: TfrmCachedUpdates;

implementation

uses dmMainComp;

{$R *.dfm}

procedure TfrmCachedUpdates.qrProductsUpdateRecord(ASender: TDataSet;
      ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADPhysUpdateRowOptions);
begin
  usProducts.ConnectionName := qrProducts.ConnectionName;
  usProducts.DataSet := qrProducts;
  usProducts.Apply(ARequest, AAction, AOptions);

  usCategories.ConnectionName := qrProducts.ConnectionName;
  usCategories.DataSet := qrProducts;
  usCategories.Apply(ARequest, AAction, AOptions);

  AAction := eaApplied;
end;

procedure TfrmCachedUpdates.btnApplyClick(Sender: TObject);
begin
  qrProducts.ApplyUpdates;
end;

procedure TfrmCachedUpdates.btnCancelClick(Sender: TObject);
begin
  qrProducts.CancelUpdates;
end;

procedure TfrmCachedUpdates.btnCommitClick(Sender: TObject);
begin
  qrProducts.CommitUpdates;
end;

procedure TfrmCachedUpdates.btnRevertClick(Sender: TObject);
begin
  qrProducts.RevertRecord;
end;

procedure TfrmCachedUpdates.btnUndoLastClick(Sender: TObject);
begin
  qrProducts.UndoLastChange(True);
end;

procedure TfrmCachedUpdates.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  RegisterDS(qrProducts);
end;

procedure TfrmCachedUpdates.cbDBClick(Sender: TObject);
begin
  qrProducts.Close;
  inherited cbDBClick(Sender);
  qrProducts.SQL.Clear;
  qrProducts.SQL.Add('select p.*, c.CategoryName from ');
  qrProducts.SQL.Add(dmlMainComp.dbMain.EncodeObjectName('', '', '', 'Categories'));
  qrProducts.SQL.Add(' c,');
  qrProducts.SQL.Add(dmlMainComp.dbMain.EncodeObjectName('', '', '', 'Products'));
  qrProducts.SQL.Add(' p');
  qrProducts.SQL.Add('where p.CategoryID = c.CategoryID');
  qrProducts.Open
end;

end.
