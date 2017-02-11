unit fIndices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, Grids, DBGrids, ComCtrls, Buttons,
  fMainQueryBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADGUIxFormsControls, jpeg;

type
  TfrmIndices = class(TfrmMainQueryBase)
    qryMain: TADQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    cbIndexes: TComboBox;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure cbIndexesChange(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIndices: TfrmIndices;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmIndices.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited FormCreate(Sender);
  RegisterDS(qryMain);
  for i := 0 to qryMain.Indexes.Count - 1 do
    cbIndexes.Items.Add(qryMain.Indexes[i].Name);
end;

procedure TfrmIndices.cbDBClick(Sender: TObject);
begin
  qryMain.Close;
  inherited cbDBClick(Sender);
  qryMain.Open;
end;

procedure TfrmIndices.cbIndexesChange(Sender: TObject);
begin
  // See the set of indices in design time.
  // Simple click on Indexes property of TADQuery
  qryMain.IndexName := cbIndexes.Text;
end;

procedure TfrmIndices.DBGrid1TitleClick(Column: TColumn);
begin
  // Dynamic sorting
  qryMain.IndexFieldNames := Column.Field.FieldName;
end;

end.

