unit fPooling;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, StdCtrls, ExtCtrls, Buttons, ComCtrls, fMainCompBase,
  daADCompClient, daADPhysIntf, fMainConnectionDefBase, jpeg;

type
  TfrmMain = class(TfrmMainCompBase)
    Label1: TLabel;
    lblTotalExec: TLabel;
    Label2: TLabel;
    lblTotalTime: TLabel;
    chPooled: TCheckBox;
    btnRun: TSpeedButton;
    Bevel1: TBevel;
    procedure btnRunClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    FCount: Integer;
    FStartTime: LongWord;
  public
    procedure Executed;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

type
  TConnectThread = class(TThread)
  private
    FForm: TfrmMain;
  public
    constructor Create(AForm: TfrmMain);
    procedure Execute; override;
  end;

constructor TConnectThread.Create(AForm: TfrmMain);
begin
  FForm := AForm;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TConnectThread.Execute;
var
  oConn:  TADConnection;
  oQuery: TADQuery;
  i: Integer;
begin
  oConn  := TADConnection.Create(nil);
  oQuery := TADQuery.Create(nil);
  try
    oQuery.Connection := oConn;
    oConn.ConnectionDefName := FForm.cbDB.Text;
    for i := 1 to 50 do begin
      oQuery.SQL.Text := 'select count(*) from {id Region}';
      oQuery.Open;
      oConn.Close;
      Synchronize(FForm.Executed);
    end;
  finally
    oConn.Free;
    oQuery.Free;
  end;
end;

procedure TfrmMain.Executed;
begin
  Inc(FCount);
  if (FCount mod 10) = 0 then
    lblTotalExec.Caption := IntToStr(FCount);
  if FCount = 500 then begin
    lblTotalTime.Caption := FloatToStr((GetTickCount - FStartTime) / 1000.0);
    btnRun.Enabled := True;
  end;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
  i: Integer;
begin
  btnRun.Enabled := False;
  ADManager.Close;
  while ADManager.State <> dmsInactive do
    Sleep(0);
  ADManager.Open;
  if chPooled.Checked then
    ADManager.ConnectionDefs.ConnectionDefByName(cbDB.Text).Pooled := True
  else
    ADManager.ConnectionDefs.ConnectionDefByName(cbDB.Text).Pooled := False;
  FStartTime := GetTickCount;
  FCount := 0;
  lblTotalExec.Caption := '---';
  lblTotalTime.Caption := '---';
  for i := 1 to 10 do
    TConnectThread.Create(Self);
end;

procedure TfrmMain.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  btnRun.Enabled := True;
end;

end.
