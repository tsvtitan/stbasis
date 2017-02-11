unit fMasterDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons, ComCtrls,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient, daADCompDataSet, jpeg;

type
  TfrmMasterDetail = class(TfrmMainCompBase)
    cdsOrders: TADClientDataSet;
    cdsOrdDetails: TADClientDataSet;
    dsOrders: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dsOrdDetails: TDataSource;
    Splitter1: TSplitter;
    adOrders: TADTableAdapter;
    adOrderDetails: TADTableAdapter;
    cmOrders: TADCommand;
    cmOrderDetails: TADCommand;
    chbFetchOnDemand: TCheckBox;
    pnlFetchOnDemand: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure cbDBClick(Sender: TObject);
    procedure chbFetchOnDemandClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMasterDetail: TfrmMasterDetail;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmMasterDetail.cbDBClick(Sender: TObject);
begin
  with dmlMainComp.dbMain.FetchOptions do
    Items := Items - [fiMeta];

  cdsOrders.Close;
  cdsOrdDetails.Close;
  inherited cbDBClick(Sender);
  cdsOrders.Active := True;
  cdsOrdDetails.Active := True;
end;

procedure TfrmMasterDetail.chbFetchOnDemandClick(Sender: TObject);
begin
  // In this mode the client dataset fetches additional packets of data as needed (for example,
  // as a user scrolls through data, or conducts a search).
  if chbFetchOnDemand.Checked then
    cdsOrders.FetchOptions.Mode := fmOnDemand
  else
    cdsOrders.FetchOptions.Mode := fmManual;
  if chbFetchOnDemand.Checked then
    cdsOrdDetails.FetchOptions.Mode := fmOnDemand
  else
    cdsOrdDetails.FetchOptions.Mode := fmManual;
end;

procedure TfrmMasterDetail.Button1Click(Sender: TObject);
begin
  cdsOrders.ApplyUpdates();
  cdsOrdDetails.ApplyUpdates();
end;

procedure TfrmMasterDetail.Button2Click(Sender: TObject);
begin
  cdsOrders.CancelUpdates();
  cdsOrdDetails.CancelUpdates();
  cdsOrders.Refresh;
  cdsOrdDetails.Refresh;
end;

end.
