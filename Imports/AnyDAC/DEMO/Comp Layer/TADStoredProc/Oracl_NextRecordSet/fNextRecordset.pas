unit fNextRecordset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Grids, DBGrids, Buttons, ExtCtrls, FmtBCD, ComCtrls,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, jpeg;

type
  TfrmNextRecordset = class(TfrmMainCompBase)
    spRefCrs: TADStoredProc;
    dsRefCrs: TDataSource;
    DBGrid1: TDBGrid;
    spInOutPars: TADStoredProc;
    Label1: TLabel;
    Label2: TLabel;
    edtPin1: TEdit;
    edtPin2: TEdit;
    Label3: TLabel;
    edtPout1: TEdit;
    Label4: TLabel;
    edtPout2: TEdit;
    btnExecProc: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    btnReopen: TSpeedButton;
    btnNextRS: TSpeedButton;
    Memo1: TMemo;
    Label7: TLabel;
    procedure btnExecProcClick(Sender: TObject);
    procedure btnReopenClick(Sender: TObject);
    procedure btnNextRSClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNextRecordset: TfrmNextRecordset;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmNextRecordset.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  cbDB.ItemIndex := cbDB.Items.IndexOf('Oracle_Demo');
  cbDBClick(nil);
end;

procedure TfrmNextRecordset.cbDBClick(Sender: TObject);
begin
  spRefCrs.Close;
  inherited cbDBClick(Sender);
  spRefCrs.Open;
end;

procedure TfrmNextRecordset.btnExecProcClick(Sender: TObject);
begin
  spInOutPars.Prepare;
  spInOutPars.Params[0].AsFloat := StrToFloat(edtPin1.Text);
  spInOutPars.Params[1].AsString := edtPin2.Text;
  spInOutPars.ExecProc;
  edtPout1.Text := spInOutPars.Params[2].AsString;
  edtPout2.Text := spInOutPars.Params[3].AsString;
end;

procedure TfrmNextRecordset.btnReopenClick(Sender: TObject);
begin
  spRefCrs.Close;
  spRefCrs.Open;
end;

procedure TfrmNextRecordset.btnNextRSClick(Sender: TObject);
begin
  spRefCrs.NextRecordSet;
end;

end.
