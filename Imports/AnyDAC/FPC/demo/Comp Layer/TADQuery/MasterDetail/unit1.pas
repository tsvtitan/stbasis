unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
    DBGrids, DB, StdCtrls,
  daADGUIxConsoleWait, daADPhysMySQL, daADPhysMSAcc, daADCompClient, daADStanOption;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnConnect: TButton;
    btnOpen: TButton;
    Button1: TButton;
    cbxCacheDetails: TCheckBox;
    dsOrders: TDatasource;
    dsOrderDetails: TDatasource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    procedure btnConnectClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbxCacheDetailsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    oConn: TADConnection;
    qryOrders: TADQuery;
    qryOrderDetails: TADQuery;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  oConn := TADConnection.Create(nil);

  qryOrders := TADQuery.Create(nil);
  qryOrders.Connection := oConn;
  qryOrders.FetchOptions.Items := [fiBlobs, fiDetails];
  qryOrders.SQL.Text := 'select Freight from {id Orders}';
  dsOrders.DataSet := qryOrders;

  qryOrderDetails := TADQuery.Create(nil);
  qryOrderDetails.Connection := oConn;
  qryOrderDetails.FetchOptions.Items := [fiBlobs, fiDetails];
  qryOrderDetails.FetchOptions.Cache := [fiBlobs];
  qryOrderDetails.SQL.Text := 'select * from {id Order Details} ' +
                              'where OrderID = :OrderID';
  qryOrderDetails.DataSource := dsOrders;
  qryOrderDetails.IndexFieldNames := 'OrderID';
  dsOrderDetails.DataSet := qryOrderDetails;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  qryOrders.Free;
  qryOrderDetails.Free;
  oConn.Free;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  oConn.ConnectionDefName := 'Access_Demo';
  oConn.Open;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  qryOrders.Open;
  qryOrderDetails.Open;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  qryOrders.Refresh;
end;

procedure TForm1.cbxCacheDetailsChange(Sender: TObject);
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

initialization
  {$I unit1.lrs}

end.

