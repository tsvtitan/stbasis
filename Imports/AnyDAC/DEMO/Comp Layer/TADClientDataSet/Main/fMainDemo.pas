unit fMainDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, DBClient, Grids, DBGrids, DBTables,
  fMainBase, fProperties,
  daADGUIxFormsWait, jpeg, ExtCtrls;

type
  TfrmMainDemo = class(TfrmMainBase)
    btnShowProperties: TButton;
    ClientDataSet1: TClientDataSet;
    Table1: TTable;
    Table2: TTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ClientDataSet1CustNo: TFloatField;
    ClientDataSet1Company: TStringField;
    ClientDataSet1Addr1: TStringField;
    ClientDataSet1Addr2: TStringField;
    ClientDataSet1City: TStringField;
    ClientDataSet1State: TStringField;
    ClientDataSet1Zip: TStringField;
    ClientDataSet1Country: TStringField;
    ClientDataSet1Phone: TStringField;
    ClientDataSet1FAX: TStringField;
    ClientDataSet1TaxRate: TFloatField;
    ClientDataSet1Contact: TStringField;
    ClientDataSet1LastInvoiceDate: TDateTimeField;
    ClientDataSet1Table2: TDataSetField;
    DataSource3: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    procedure btnShowPropertiesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    destructor Destroy; override;
  end;

var
  frmMainDemo: TfrmMainDemo;

implementation

{$R *.dfm}

procedure TfrmMainDemo.btnShowPropertiesClick(Sender: TObject);
var
  oFrm: TfrmProperties;
begin
  oFrm := TfrmProperties.Create(Application);
  oFrm.LoadClientDataSet('', ClientDataSet1);
  oFrm.Show;
end;

destructor TfrmMainDemo.Destroy;
begin
  inherited Destroy;
end;

end.
