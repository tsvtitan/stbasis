unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IBDatabase, Db, Grids, DBGrids, IBCustomDataSet, IBQuery;

type
  TForm1 = class(TForm)
    dsMaster: TDataSource;
    dsDetail: TDataSource;
    grdMaster: TDBGrid;
    grdDetail: TDBGrid;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    qrMaster: TIBQuery;
    qrDetail: TIBQuery;
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
