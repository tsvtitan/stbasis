unit fTableAdapter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Grids, DBGrids, DBCtrls, DB,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, jpeg;

type
  TfrmTableAdapter = class(TfrmMainCompBase)
    adOrders: TADTableAdapter;
    cmSelect: TADCommand;
    cmDelete: TADCommand;
    cmUpdate: TADCommand;
    cmInsert: TADCommand;
    cdsOrders: TADClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTableAdapter: TfrmTableAdapter;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmTableAdapter.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  // Following settings you can make at design time
  // Select command
  cmSelect.CommandText.Text := 'select * from {id Orders}';
  // Delete command
  cmDelete.CommandText.Text := 'delete from {id Orders} where OrderID=:OLD_OrderID';
  // Insert command
  cmInsert.CommandText.Text := 'insert into {id Orders}(OrderID, CustomerID, EmployeeID, OrderDate, ' +
                               'RequredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ' +
                               'ShipRegion, ShipPostalCode, ShipCountry) values(:NEW_OrderID, :NEW_CustomerID, ' +
                               ':NEW_EmployeeID, :NEW_OrderDate, :NEW_RequredDate, :NEW_ShippedDate, :NEW_ShipVia, ' +
                               ':NEW_reight, :NEW_ShipName, :NEW_ShipAddress, :NEW_ShipCity, ' +
                               ':NEW_ShipRegion, :NEW_ShipPostalCode, :NEW_ShipCountry)';
  // Update commandt
  cmUpdate.CommandText.Text := 'update {id Orders} set OrderID = :NEW_OrderID, CustomerID = :NEW_CustomerID, ' +
                               'EmployeeID = :NEW_EmployeeID, OrderDate = :NEW_OrderDate, RequredDate = :NEW_RequredDate, ' +
                               'ShippedDate = :NEW_ShippedDate, ShipVia = :NEW_ShipVia, ' +
                               'Freight = :NEW_Freight, ShipName = :NEW_ShipName, ShipAddress = :NEW_ShipAddress, ' +
                               'ShipCity = :NEW_ShipCity, ShipRegion = :NEW_ShipRegion, ShipPostalCode = :NEW_ShipRegion, ' +
                               'ShipCountry = :NEW_ShipCountry where OrderID = :OLD_OrderID';
end;

procedure TfrmTableAdapter.cbDBClick(Sender: TObject);
begin
  cmSelect.Close;
  cmDelete.Close;
  cmUpdate.Close;
  cmInsert.Close;
  cdsOrders.Active := False;
  inherited cbDBClick(Sender);
  cdsOrders.Active := True;
end;

end.

