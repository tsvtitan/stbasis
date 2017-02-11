unit fMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, Grids, DBGrids, ExtCtrls, DBCtrls, 
  uDADataTable, uDABINAdapter, uDAClasses, uDADriverManager, uDAInterfaces,
  uDAEngine, uDACDSDataTable, uDAScriptingProvider,
  uDAAnyDACDriver, daADGUIxFormsWait, daADPhysManager, daADPhysMSSQL,
  daADPhysMySQL;

type
  TForm1 = class(TForm)
    bTestDS: TButton;
    DADriverManager1: TDADriverManager;
    DASchema1: TDASchema;
    DAConnectionManager1: TDAConnectionManager;
    Memo: TMemo;
    dtCustomers: TDACDSDataTable;
    dsCustomers: TDADataSource;
    DBGrid1: TDBGrid;
    dtOrders: TDACDSDataTable;
    dsOrders: TDADataSource;
    DBGrid2: TDBGrid;
    cbApplyCustomersSchema: TCheckBox;
    cbApplyOrdersSchema: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    cbSkipCustomers: TCheckBox;
    cbSkipOrders: TCheckBox;
    Button4: TButton;
    cbCloseBeforeTest: TCheckBox;
    Button5: TButton;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    Button6: TButton;
    Button1: TButton;
    ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    DABINAdapter1: TDABINAdapter;
    ADPhysMySQLDriverLink1: TADPhysMySQLDriverLink;
    procedure FormCreate(Sender: TObject);
    procedure bTestDSClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fConnection : IDAConnection;
    fBINAdapter : TDABINAdapter;

  public

  end;

var
  Form1: TForm1;

implementation

uses uROTypes;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  fBINAdapter := TDABINAdapter.Create(NIL);
  fConnection := DAConnectionManager1.NewConnection('AnyDAC');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fBINAdapter.Free;
end;

procedure TForm1.bTestDSClick(Sender: TObject);
var stream : Binary;
    customers,
    orders : IDADataset;
    i : integer;
    start : Cardinal;
begin
  if cbCloseBeforeTest.Checked then begin
    dtCustomers.Close;
    dtOrders.Close;
  end;

  stream := Binary.Create;

  with fBINAdapter do try
    customers := DASchema1.NewDataset(fConnection, 'Customers');
    //customers.Where.AddText(' 1=2');
    orders := DASchema1.NewDataset(fConnection, 'Orders');
    //orders.Where.AddText(' 1=2');

    start := GetTickCount;

    // Writes the data
    Initialize(stream, aiWrite);
    if not cbSkipCustomers.Checked
      then WriteDataset(customers, [woSchema, woRows], -1);

    if not cbSkipOrders.Checked
      then WriteDataset(orders, [woRows, woSchema], -1);
    Finalize;
    // End of write data

    Memo.Lines.Add('WRITE completed in '+IntToStr(GetTickCount-start)+'ms');

    // Logging info
    Memo.Lines.Add('Stream is now '+IntToStr(stream.Size)+' bytes long');

    start := GetTickCount;
    Initialize(stream, aiReadFromBeginning);

    // Reads the data
    if not cbSkipCustomers.Checked then begin
      if cbApplyCustomersSchema.Checked
        then ReadDataset('Customers', dtCustomers, TRUE);

      ReadDataset('Customers', dtCustomers);
    end;

    if not cbSkipOrders.Checked then begin
      if cbApplyOrdersSchema.Checked
        then ReadDataset('Orders', dtOrders, TRUE);
      ReadDataset('Orders', dtOrders);
    end;

    Finalize;

    // End of read data
    Memo.Lines.Add('READ completed in '+IntToStr(GetTickCount-start)+'ms');
    
    // Logging info
    Memo.Lines.Add('The stream contains '+IntToStr(DatasetCount)+' datasets and '+IntToStr(DeltaCount)+' deltas');
    for i := 0 to (DatasetCount-1) do Memo.Lines.Add('Dataset -> '+DatasetNames[i]);
    for i := 0 to (DeltaCount-1) do Memo.Lines.Add('Delta -> '+DeltaNames[i]);
    Memo.Lines.Add(' ');
  finally
    stream.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  dtCustomers.Active := dtCustomers.Active XOR TRUE;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  dtOrders.Active := dtOrders.Active XOR TRUE
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if dtOrders.MasterSource=NIL then begin
    dtOrders.MasterFields := 'CustomerID';
    dtOrders.DetailFields := 'CustomerID';
    dtOrders.MasterSource := dsCustomers;
  end

  else begin
    dtOrders.MasterSource := NIL;
    dtOrders.MasterFields := '';
    dtOrders.DetailFields := '';
  end;

  bTestDS.Enabled := dtOrders.MasterSource=NIL;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ShowMessage(Format('Changes: Customers %d, Orders %d', [dtCustomers.Delta.Count, dtOrders.Delta.Count]));
end;

procedure TForm1.Button6Click(Sender: TObject);
var stream : TStream;
    i : integer;
    orddelta,
    custdelta : TDADelta;
begin
  if not dtCustomers.Active or  not dtOrders.Active then begin
    MessageDlg('Both datatables must be open!', mtError, [mbOK], 0);
    Exit;
  end;

  stream := TMemoryStream.Create;

  custdelta := TDADelta.Create(dtCustomers);
  orddelta := TDADelta.Create(dtOrders);
  with fBINAdapter do try
    // Writes the data
    Initialize(stream, aiWrite);
    if not cbSkipCustomers.Checked
      then WriteDelta(dtCustomers);

    if not cbSkipOrders.Checked
      then WriteDelta(dtOrders);
    Finalize;
    // End of write data

    // Logging info
    Memo.Lines.Add('Stream is now '+IntToStr(stream.Size)+' bytes long');

    Initialize(stream, aiReadFromBeginning);

    // Reads the data
    if not cbSkipCustomers.Checked then begin
      ReadDelta('dtCustomers', custdelta);
      Memo.Lines.Add('Customers delta contains '+IntToStr(custdelta.Count)+' changes');
    end;

    if not cbSkipOrders.Checked then begin
      ReadDelta('dtOrders', orddelta);
      Memo.Lines.Add('Orders delta contains '+IntToStr(orddelta.Count)+' changes');
    end;

    Finalize;

    // Logging info
    Memo.Lines.Add('The stream contains '+IntToStr(DatasetCount)+' datasets and '+IntToStr(DeltaCount)+' deltas');
    for i := 0 to (DatasetCount-1) do Memo.Lines.Add('Dataset -> '+DatasetNames[i]);
    for i := 0 to (DeltaCount-1) do Memo.Lines.Add('Delta -> '+DeltaNames[i]);
    Memo.Lines.Add(' ');

  finally
    stream.Free;

    custdelta.Free;
    orddelta.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo.Lines.Clear;
end;

end.
