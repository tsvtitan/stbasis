unit fPooling;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  fMainLayers,
  daADDatSManager, daADPhysIntf, jpeg;

type
  TfrmPooling = class(TfrmMainLayers)
    Label1: TLabel;
    lblTotalExec: TLabel;
    Label2: TLabel;
    lblTotalTime: TLabel;
    cbPooled: TCheckBox;
    btnRun: TSpeedButton;
    procedure btnRunClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    FCount: Integer;
    FStartTime: LongWord;
  public
    procedure Executed;
  end;

var
  frmPooling: TfrmPooling;

implementation

{$R *.dfm}

type
  TConnectThread = class(TThread)
  private
    FForm: TfrmPooling;
  public
    constructor Create(AForm: TfrmPooling);
    procedure Execute; override;
  end;

constructor TConnectThread.Create(AForm: TfrmPooling);
begin
  FForm := AForm;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TConnectThread.Execute;
var
  i:      Integer;
  oTab:   TADDatSTable;
  oConn:  IADPhysConnection;
  oComm:  IADPhysCommand;
  lClose: Boolean;
begin
  ADPhysManager.CreateConnection(FForm.cbDB.Text, oConn);
  oConn.CreateCommand(oComm);
  oTab := TADDatSTable.Create;
  lClose := False;
  try
    for i := 1 to 50 do
      with oComm do begin
        if oConn.State = csDisconnected then begin
          lClose := True;
          oConn.Open;
        end;
        Prepare('select count(*) from {id Region}');
        Define(oTab);
        Open;
        if lClose then
          oConn.Close;
        Synchronize(FForm.Executed);
      end;
  finally
    oTab.Free;
  end;
end;

procedure TfrmPooling.Executed;
begin
  Inc(FCount);
  if (FCount mod 10) = 0 then
    lblTotalExec.Caption := IntToStr(FCount);
  if FCount = 500 then
    lblTotalTime.Caption := FloatToStr((GetTickCount - FStartTime) / 1000.0);
end;

procedure TfrmPooling.btnRunClick(Sender: TObject);
var
  i: Integer;
begin
  ADPhysManager.Close;
  while ADPhysManager.State <> dmsInactive do
    Sleep(0);
  ADPhysManager.Open;
  if cbPooled.Checked then begin
    ADPhysManager.ConnectionDefs.ConnectionDefByName(cbDB.Text).Pooled := True;
    Console.Lines.Add('Run pooled...');
  end
  else begin
    ADPhysManager.ConnectionDefs.ConnectionDefByName(cbDB.Text).Pooled := False;
    Console.Lines.Add('Run non pooled...');
  end;
  FStartTime := GetTickCount;
  FCount := 0;
  lblTotalExec.Caption := '---';
  lblTotalTime.Caption := '---';
  for i := 1 to 10 do
    TConnectThread.Create(Self);
end;

procedure TfrmPooling.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf := nil;

  cbPooled.Enabled := True;
  btnRun.Enabled := True;
end;

end.
