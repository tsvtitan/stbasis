unit fTableUpdates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, daADPhysIntf, jpeg;

type
  TfrmTableUpdates = class(TfrmMainLayers)
    btnChange: TSpeedButton;
    btnAccept: TSpeedButton;
    btnReject: TSpeedButton;
    btnFirstChange: TSpeedButton;
    btnSavePoint: TSpeedButton;
    btnNextChange: TSpeedButton;
    btnLastChange: TSpeedButton;
    btnRestorePoint: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnRejectClick(Sender: TObject);
    procedure btnFirstChangeClick(Sender: TObject);
    procedure btnNextChangeClick(Sender: TObject);
    procedure btnLastChangeClick(Sender: TObject);
    procedure btnSavePointClick(Sender: TObject);
    procedure btnRestorePointClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    FTab: TADDatSTable;
    FCommIntf: IADPhysCommand;
    FSavePoint: LongWord;
    FCurRow: TADDatSRow;
    FChangeRowNum: Integer;
  end;

var
  frmTableUpdates: TfrmTableUpdates;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmTableUpdates.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create('Shippers');
end;

procedure TfrmTableUpdates.FormDestroy(Sender: TObject);
begin
  FCommIntf := nil;
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmTableUpdates.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf.CreateCommand(FCommIntf);
  with FCommIntf do begin
    Prepare('select * from {id Shippers}');
    Define(FTab);
    Open;
    Fetch(FTab);
  end;
  PrintRows(FTab, Console.Lines, 'The table...', True);

  btnChange.Enabled := True;
  btnAccept.Enabled := True;
  btnReject.Enabled := True;
  btnFirstChange.Enabled := True;
  btnSavePoint.Enabled := True;
  btnNextChange.Enabled := True;
  btnLastChange.Enabled := True;
  btnRestorePoint.Enabled := True;
end;

procedure TfrmTableUpdates.btnChangeClick(Sender: TObject);
begin
  with FTab.Rows[FChangeRowNum] do begin
    BeginEdit;
    SetValues([30 + FChangeRowNum, 'string', 20 - FChangeRowNum]);
    EndEdit;
  end;
  PrintRows(FTab, Console.Lines, 'Changed values...', True);

  Inc(FChangeRowNum);
  FChangeRowNum := FChangeRowNum mod FTab.Rows.Count; 
end;

procedure TfrmTableUpdates.btnAcceptClick(Sender: TObject);
begin
  FTab.Updates.AcceptChanges;
  PrintRows(FTab, Console.Lines, 'Accepting changes...', True);
end;

procedure TfrmTableUpdates.btnRejectClick(Sender: TObject);
begin
  FTab.Updates.RejectChanges;
  PrintRows(FTab, Console.Lines, 'Rejecting changes...', True);
end;

procedure TfrmTableUpdates.btnFirstChangeClick(Sender: TObject);
begin
  FCurRow := FTab.Updates.FirstChange;
  if FCurRow <> nil then
    PrintRow(FCurRow, Console.Lines, 'First change...', True);
end;

procedure TfrmTableUpdates.btnNextChangeClick(Sender: TObject);
begin
  FCurRow := FTab.Updates.NextChange(FCurRow);
  if FCurRow <> nil then
    PrintRow(FCurRow, Console.Lines, 'Next change...', True);
end;

procedure TfrmTableUpdates.btnLastChangeClick(Sender: TObject);
begin
  FCurRow := FTab.Updates.LastChange;
  if FCurRow <> nil then
    PrintRow(FCurRow, Console.Lines, 'Last change...', True);
end;

procedure TfrmTableUpdates.btnSavePointClick(Sender: TObject);
begin
  FSavePoint := FTab.Updates.SavePoint;
end;

procedure TfrmTableUpdates.btnRestorePointClick(Sender: TObject);
begin
  FTab.Updates.SavePoint := FSavePoint;
  PrintRows(FTab, Console.Lines, 'Restoring point...', True);
end;

end.


