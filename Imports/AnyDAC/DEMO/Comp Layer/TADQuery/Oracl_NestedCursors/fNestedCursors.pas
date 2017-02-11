unit fNestedCursors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, Grids, DBGrids, ComCtrls, Buttons, ExtCtrls,
  fMainQueryBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADGUIxFormsControls, jpeg;

type
  TfrmNestedCursors = class(TfrmMainQueryBase)
    ADQuery1: TADQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ADQuery1CRS: TDataSetField;
    ADQuery1CATEGORYID: TIntegerField;
    ADClientDataSet1: TADClientDataSet;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    btnOpenClose: TSpeedButton;
    btnPrepUnprep: TSpeedButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenCloseClick(Sender: TObject);
    procedure btnPrepUnprepClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNestedCursors: TfrmNestedCursors;

implementation

uses dmMainComp;

{$R *.dfm}

procedure TfrmNestedCursors.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  RegisterDS(ADQuery1);
  cbDB.ItemIndex := cbDB.Items.IndexOf('Oracle_Demo');
  cbDBClick(nil);
end;

procedure TfrmNestedCursors.btnOpenCloseClick(Sender: TObject);
begin
  ADQuery1.Active := not ADQuery1.Active;
end;

procedure TfrmNestedCursors.btnPrepUnprepClick(Sender: TObject);
begin
  ADQuery1.Prepared := not ADQuery1.Prepared;
end;

procedure TfrmNestedCursors.cbDBClick(Sender: TObject);
begin
  ADQuery1.Close;
  inherited cbDBClick(Sender);
  ADQuery1.Open;
  ADClientDataSet1.DataSetField := ADQuery1CRS;
  ADClientDataSet1.Open;
end;

end.
