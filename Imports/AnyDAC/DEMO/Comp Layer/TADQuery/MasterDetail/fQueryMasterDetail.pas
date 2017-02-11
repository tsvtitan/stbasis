unit fQueryMasterDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, Buttons, ExtCtrls, StdCtrls, ComCtrls, jpeg,
  fMainQueryBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
    daADGUIxFormsControls,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient;

type
  TfrmMasterDetail = class(TfrmMainQueryBase)
    DBGrid2: TDBGrid;
    DBGrid1: TDBGrid;
    qryOrders: TADQuery;
    qryOrdersOrderID: TIntegerField;
    qryOrdersCustomerID: TStringField;
    qryOrdersEmployeeID: TIntegerField;
    qryOrdersOrderDate: TSQLTimeStampField;
    qryOrdersRequiredDate: TSQLTimeStampField;
    qryOrdersShippedDate: TSQLTimeStampField;
    qryOrdersFreight: TCurrencyField;
    qryOrdersShipVia: TIntegerField;
    qryOrdersShipName: TStringField;
    qryOrdersShipAddress: TStringField;
    qryOrdersShipCity: TStringField;
    qryOrdersShipRegion: TStringField;
    qryOrdersShipPostalCode: TStringField;
    qryOrdersShipCountry: TStringField;
    dsOrders: TDataSource;
    qryOrderDetails: TADQuery;
    qryOrderDetailsOrderID: TIntegerField;
    qryOrderDetailsProductID: TIntegerField;
    qryOrderDetailsUnitPrice: TCurrencyField;
    qryOrderDetailsQuantity: TSmallintField;
    qryOrderDetailsDiscount: TFloatField;
    dsOrderDetails: TDataSource;
    Splitter1: TSplitter;
    mmComment: TMemo;
    Panel1: TPanel;
    cbxCacheDetails: TCheckBox;
    Button1: TButton;
    procedure cbDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxCacheDetailsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMasterDetail: TfrmMasterDetail;

implementation

uses dmMainComp;

{$R *.dfm}

procedure TfrmMasterDetail.cbDBClick(Sender: TObject);
begin
  Button1.Enabled := False;
  qryOrderDetails.Close;
  qryOrders.Close;
  inherited cbDBClick(Sender);
  qryOrders.Open;
  qryOrderDetails.Open;
  Button1.Enabled := True;
end;

procedure TfrmMasterDetail.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  RegisterDS(qryOrders);
  RegisterDS(qryOrderDetails);
  Button1.Enabled := False;
end;

procedure TfrmMasterDetail.Button1Click(Sender: TObject);
begin
  qryOrders.Refresh;
end;

procedure TfrmMasterDetail.cbxCacheDetailsClick(Sender: TObject);
begin
  // Set qryOrderDetails.IndexFieldName to the fields,
  // corresponding to detail paramaters. For example,
  // for query:
  //    select * from {id Order Details}
  //    where OrderID = :OrderID
  // set qryOrderDetails.IndexFieldNames to OrderID
  with qryOrderDetails.FetchOptions do
    if cbxCacheDetails.Checked then
      // cache fetched detail records and query if no detail records in cache
      Cache := Cache + [fiDetails]
    else
      // do not cache detail records and query them each time master changed
      Cache := Cache - [fiDetails];
  if qryOrderDetails.Active then begin
    qryOrderDetails.Close;
    qryOrderDetails.Open;
  end;
end;

end.
