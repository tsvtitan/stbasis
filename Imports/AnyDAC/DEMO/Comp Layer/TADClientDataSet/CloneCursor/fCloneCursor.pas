unit fCloneCursor;

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
  TfrmCloneCursor = class(TfrmMainCompBase)
    cdsOrders: TADClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    btnClone: TSpeedButton;
    cdsClone: TADClientDataSet;
    DataSource2: TDataSource;
    edtStart: TLabeledEdit;
    edtEnd: TLabeledEdit;
    btnCheck: TSpeedButton;
    mmHint: TMemo;
    btnCancelRange: TSpeedButton;
    Splitter1: TSplitter;
    Panel1: TPanel;
    ADTableAdapter1: TADTableAdapter;
    ADCommand1: TADCommand;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCloneClick(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnCancelRangeClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCloneCursor: TfrmCloneCursor;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmCloneCursor.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
end;

procedure TfrmCloneCursor.btnCloneClick(Sender: TObject);
begin
  if not dmlMainComp.dbMain.Connected then
    exit;
  cdsClone.CloneCursor(cdsOrders, False);
  cdsClone.Active := True;
end;

procedure TfrmCloneCursor.cbDBClick(Sender: TObject);
begin
  cdsClone.Close;
  cdsOrders.Close;
  inherited cbDBClick(Sender);
  cdsOrders.Active := True;
end;

procedure TfrmCloneCursor.btnCheckClick(Sender: TObject);
begin
  if not cdsClone.Active then
    exit;
  with cdsClone do begin
    SetRange([edtStart.Text], [edtEnd.Text]);
    GotoCurrent(cdsOrders);
  end;
end;

procedure TfrmCloneCursor.btnCancelRangeClick(Sender: TObject);
begin
  cdsOrders.CancelRange;
end;

end.
