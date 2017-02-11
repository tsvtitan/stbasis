unit fAsync;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, ComCtrls,
  fMainQueryBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADGUIxFormsControls, jpeg;

type
  TfrmAsync = class(TfrmMainQueryBase)
    qryExecSQL: TADQuery;
    btnExec: TSpeedButton;
    mmExample: TMemo;
    btnExecCancelDlg: TSpeedButton;
    btnAsyncExec: TSpeedButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure btnExecCancelDlgClick(Sender: TObject);
    procedure btnAsyncExecClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAsync: TfrmAsync;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmAsync.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  RegisterDS(qryExecSQL);

  btnExec.Enabled := False;
  btnExecCancelDlg.Enabled := False;
  btnAsyncExec.Enabled := False;
end;

procedure TfrmAsync.cbDBClick(Sender: TObject);
begin
  btnExec.Enabled := False;
  btnExecCancelDlg.Enabled := False;
  btnAsyncExec.Enabled := False;

  qryExecSQL.Close;
  inherited cbDBClick(Sender);

  btnExec.Enabled := True;
  btnExecCancelDlg.Enabled := True;
  btnAsyncExec.Enabled := True;
end;

procedure TfrmAsync.btnExecClick(Sender: TObject);
begin
  qryExecSQL.SQL.Text := 'delete from {id Orders} where OrderID > 1000000';
  qryExecSQL.ExecSQL;
  mmExample.Text := qryExecSQL.SQL.Text;
end;

procedure TfrmAsync.btnExecCancelDlgClick(Sender: TObject);
begin
  qryExecSQL.ResourceOptions.AsyncCmdMode := amCancelDialog;
  qryExecSQL.SQL.Text := 'select count(*) from {id Order Details} a, {id Order Details} b group by a.OrderID';
  mmExample.Text := qryExecSQL.SQL.Text;
  qryExecSQL.Open;
end;

procedure TfrmAsync.btnAsyncExecClick(Sender: TObject);
begin
  qryExecSQL.ResourceOptions.AsyncCmdMode := amAsync;
  qryExecSQL.SQL.Text := 'select count(*) from {id Order Details} a, {id Order Details} b group by a.OrderID';
  mmExample.Text := qryExecSQL.SQL.Text;
  qryExecSQL.Open;
end;

end.
