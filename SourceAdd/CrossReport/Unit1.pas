unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IBDatabase, Db, IBCustomDataSet, IBQuery, FR_Class, FR_DSet, FR_DBSet,
  Grids, DBGrids, FR_E_CSV, FR_E_TXT, FR_E_RTF, FR_E_HTM;

type
  TForm1 = class(TForm)
    frReport1: TfrReport;
    qrCross: TIBQuery;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    frDBDataSet1: TfrDBDataSet;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    frReport2: TfrReport;
    qrViewPlace: TIBQuery;
    frDBDataSet2: TfrDBDataSet;
    frRTFExport1: TfrRTFExport;
    frCSVExport1: TfrCSVExport;
    qrInvalidChildHood: TIBQuery;
    qrInvalidAutoTransport: TIBQuery;
    qrInvalidIvo: TIBQuery;
    qrInvalidUvo: TIBQuery;
    qrCrossGroup: TIBQuery;
    frHTMExport1: TfrHTMExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
