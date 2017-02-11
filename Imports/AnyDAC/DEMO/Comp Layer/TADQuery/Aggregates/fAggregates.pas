unit fAggregates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, Grids, DBGrids, ComCtrls, Buttons, jpeg,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions, daADPhysIntf,
  daADDAptIntf, daADCompDataSet, daADCompClient, fMainQueryBase,
  daADGUIxFormsControls;

type
  TfrmAggregates = class(TfrmMainQueryBase)
    qryAggregates: TADQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    edtUser: TLabeledEdit;
    edtMax: TLabeledEdit;
    edtAvg: TLabeledEdit;
    edtSum: TLabeledEdit;
    edtUsrRes: TLabeledEdit;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure edtUserKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAggregates: TfrmAggregates;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmAggregates.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  RegisterDS(qryAggregates);
end;

procedure TfrmAggregates.cbDBClick(Sender: TObject);
begin
  qryAggregates.Close;
  inherited cbDBClick(Sender);
  qryAggregates.Open;
end;

procedure TfrmAggregates.edtUserKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    with qryAggregates.Aggregates.Items[3] do begin
      Expression := edtUser.Text;
      Active := True;
      edtUsrRes.Text := VarToStr(Value);
    end
end;

procedure TfrmAggregates.DataSource1DataChange(Sender: TObject; Field: TField);
var
  oAggr: TADAggregates;
begin
  oAggr := qryAggregates.Aggregates;
  edtAvg.Text := VarToStr(oAggr.Items[0].Value);
  edtSum.Text := VarToStr(oAggr.Items[1].Value);
  edtMax.Text := VarToStr(oAggr.Items[2].Value);
  edtUsrRes.Text := VarToStr(oAggr.Items[3].Value);
end;

end.
