unit fCalculatedColumns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fDatSLayerBase,
  daADDatSManager, daADStanIntf, jpeg;

type
  TfrmCalculatedColumns = class(TfrmDatSLayerBase)
    btnCreateTable: TSpeedButton;
    btnModify: TSpeedButton;
    edtCurExpression: TLabeledEdit;
    mmInfo: TMemo;
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateTableClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure edtCurExpressionKeyPress(Sender: TObject; var Key: Char);
  private
    FTab: TADDatSTable;
  public
    procedure AddRows;
    procedure ModifyExpression;
  end;

var
  frmCalculatedColumns: TfrmCalculatedColumns;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmCalculatedColumns.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

procedure TfrmCalculatedColumns.btnCreateTableClick(Sender: TObject);
begin
  // create table
  FTab := TADDatSTable.Create('Table');
  FTab.Columns.Add('id', dtInt32);
  FTab.Columns.Add('cnt', dtInt16);
  FTab.Columns.Add('price', dtCurrency);
  // calculated column
  FTab.Columns.Add('total', dtDouble, 'price * cnt');

  // add rows
  AddRows;
  PrintRows(FTab, Console.Lines, 'Our table');

  btnModify.Enabled := True;
  edtCurExpression.Text := 'price * cnt';
  btnCreateTable.Enabled := False;
end;

procedure TfrmCalculatedColumns.AddRows;
begin
  FTab.Rows.Add([1, 10, 2]);
  FTab.Rows.Add([2, 5, 7]);
end;

procedure TfrmCalculatedColumns.btnModifyClick(Sender: TObject);
begin
  edtCurExpression.Text := '(price * 1.20) * cnt';
  ModifyExpression;
end;

procedure TfrmCalculatedColumns.edtCurExpressionKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    ModifyExpression;
end;

procedure TfrmCalculatedColumns.ModifyExpression;
begin
  FTab.Columns[3].Expression := edtCurExpression.Text;
  FTab.Clear;
  AddRows;
  PrintRows(FTab, Console.Lines, 'Our table');
end;

end.
