unit fSchemaAdapter;

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
  TfrmSchemaAdapter = class(TfrmMainCompBase)
    ADSchemaAdapter1: TADSchemaAdapter;
    ADTableAdapter1: TADTableAdapter;
    ADTableAdapter2: TADTableAdapter;
    ADCommand1: TADCommand;
    ADCommand2: TADCommand;
    ADClientDataSet1: TADClientDataSet;
    ADClientDataSet1OrderID: TADAutoIncField;
    ADClientDataSet1CustomerID: TStringField;
    ADClientDataSet1EmployeeID: TIntegerField;
    ADClientDataSet1OrderDate: TSQLTimeStampField;
    ADClientDataSet1RequiredDate: TSQLTimeStampField;
    ADClientDataSet1ShippedDate: TSQLTimeStampField;
    ADClientDataSet1ShipVia: TIntegerField;
    ADClientDataSet1Freight: TCurrencyField;
    ADClientDataSet1ShipName: TStringField;
    ADClientDataSet1ShipAddress: TStringField;
    ADClientDataSet1ShipCity: TStringField;
    ADClientDataSet1ShipRegion: TStringField;
    ADClientDataSet1ShipPostalCode: TStringField;
    ADClientDataSet1ShipCountry: TStringField;
    ADClientDataSet2: TADClientDataSet;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Button1: TButton;
    procedure cbDBClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSchemaAdapter: TfrmSchemaAdapter;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmSchemaAdapter.cbDBClick(Sender: TObject);
var
  oRel: TADDatSRelation;
begin
  ADClientDataSet2.Active := False;
  ADClientDataSet1.Active := False;
  inherited cbDBClick(Sender);
  ADClientDataSet1.Active := True;
  ADClientDataSet2.Active := True;

  // Add relation
  with ADSchemaAdapter1.DatSManager do
    oRel := Relations.Add(
      'Orders_OrderDetails',
      Tables.ItemsS['[Orders]'].Columns.ItemsS['OrderID'],
      Tables.ItemsS['[Order Details]'].Columns.ItemsS['OrderID']);
  with oRel.ChildKeyConstraint do begin
    InsertRule := crCascade;
    UpdateRule := crCascade;
    DeleteRule := crCascade;
  end;
end;

procedure TfrmSchemaAdapter.Button1Click(Sender: TObject);
begin
  ADSchemaAdapter1.Update;
  Invalidate;
end;

end.

