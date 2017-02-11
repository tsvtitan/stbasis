unit fCachedUpdates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons, DBCtrls, ComCtrls,
  fMainCompBase,
  daADStanIntf, daADStanOption, daADStanParam, daADMoniIndyClient, daADMoniFlatFile,
  daADDatSManager,
  daADGUIxFormsfLogin,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient, daADCompDataSet, jpeg;

type
  TfrmCachedUpdates = class(TfrmMainCompBase)
    cdsOrders: TADClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    btnSavePoint: TSpeedButton;
    btnRevertPoint: TSpeedButton;
    btnRevertRecord: TSpeedButton;
    btnULastChange: TSpeedButton;
    btnCancelUpdates: TSpeedButton;
    btnApplyUpdates: TSpeedButton;
    ADTableAdapter1: TADTableAdapter;
    Panel1: TPanel;
    ADCommand1: TADCommand;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSavePointClick(Sender: TObject);
    procedure btnRevertPointClick(Sender: TObject);
    procedure btnRevertRecordClick(Sender: TObject);
    procedure btnULastChangeClick(Sender: TObject);
    procedure btnCancelUpdatesClick(Sender: TObject);
    procedure btnApplyUpdatesClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    FSavePoint: Integer;
  public
    { Public declarations }
  end;

var
  frmCachedUpdates: TfrmCachedUpdates;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmCachedUpdates.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
end;

procedure TfrmCachedUpdates.FormDestroy(Sender: TObject);
begin
  cdsOrders.Close;
end;

procedure TfrmCachedUpdates.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  StatusBar1.SimpleText := 'Change''s Count = ' + IntToStr(cdsOrders.ChangeCount);
end;

procedure TfrmCachedUpdates.btnSavePointClick(Sender: TObject);
begin
  FSavePoint := cdsOrders.SavePoint;
end;

procedure TfrmCachedUpdates.btnRevertPointClick(Sender: TObject);
begin
  cdsOrders.SavePoint := FSavePoint;
end;

procedure TfrmCachedUpdates.btnRevertRecordClick(Sender: TObject);
begin
  cdsOrders.RevertRecord;
end;

procedure TfrmCachedUpdates.btnULastChangeClick(Sender: TObject);
begin
  cdsOrders.UndoLastChange(True);
end;

procedure TfrmCachedUpdates.btnCancelUpdatesClick(Sender: TObject);
begin
  cdsOrders.CancelUpdates;
end;

procedure TfrmCachedUpdates.btnApplyUpdatesClick(Sender: TObject);
begin
  cdsOrders.ApplyUpdates;
end;

procedure TfrmCachedUpdates.cbDBClick(Sender: TObject);
begin
  cdsOrders.Close;
  inherited cbDBClick(Sender);
  cdsOrders.Active := True;
end;

end.
