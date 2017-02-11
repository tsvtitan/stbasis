unit fAcceptChanges;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADStanIntf, daADPhysIntf, jpeg;

type
  TfrmAcceptChanges = class(TfrmMainLayers)
    btnChange: TSpeedButton;
    btnAccept: TSpeedButton;
    btnReject: TSpeedButton;
    btnJournal: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnRejectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure btnJournalClick(Sender: TObject);
  private
    FTabShipp, FTabReg: TADDatSTable;
    FDatSManager: TADDatSManager;
    FCommIntf: IADPhysCommand;
  public
    { Public declarations }
  end;

var
  frmAcceptChanges: TfrmAcceptChanges;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmAcceptChanges.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  // create DatSManager and configure it to register changes
  // in all it tables
  FDatSManager := TADDatSManager.Create;
  FDatSManager.UpdatesRegistry := True;
  // create tables
  FTabShipp := FDatSManager.Tables.Add('Shippers');
  FTabReg := FDatSManager.Tables.Add('Region');
end;

procedure TfrmAcceptChanges.FormDestroy(Sender: TObject);
begin
  FDatSManager.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmAcceptChanges.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf.CreateCommand(FCommIntf);
  with FCommIntf do begin
    Prepare('select * from {id Shippers}');
    Define(FTabShipp);
    Open;
    Fetch(FTabShipp);

    Prepare('select * from {id Region}');
    Define(FTabReg);
    Open;
    Fetch(FTabReg);
  end;
  PrintRows(FTabShipp, Console.Lines, 'Shippers table...', True);
  PrintRows(FTabReg, Console.Lines, 'Region table...', True);

  btnChange.Enabled := True;
  btnAccept.Enabled := True;
  btnReject.Enabled := True;
  btnJournal.Enabled := True;
end;

procedure TfrmAcceptChanges.btnChangeClick(Sender: TObject);
begin
  FTabReg.Rows[FTabReg.Rows.Count - 1].Delete;
  with FTabShipp.Rows[0] do begin
    BeginEdit;
    SetValues([30, 'string31', 20]);
    EndEdit;
  end;
  with FTabReg.Rows[1] do begin
    BeginEdit;
    SetValues([32, 'string33']);
    EndEdit;
  end;

  PrintRows(FTabShipp, Console.Lines, '[Shippers] after changing...', True);
  PrintRows(FTabReg, Console.Lines, '[Region] after changing...', True);
end;

procedure TfrmAcceptChanges.btnAcceptClick(Sender: TObject);
begin
  FDatSManager.AcceptChanges;

  PrintRows(FTabShipp, Console.Lines, '[Shippers] after accepting changes...', True);
  PrintRows(FTabReg, Console.Lines, '[Region] after accepting changes...', True);
end;

procedure TfrmAcceptChanges.btnRejectClick(Sender: TObject);
begin
  FDatSManager.RejectChanges;

  PrintRows(FTabShipp, Console.Lines, '[Shippers] after rejecting changes...', True);
  PrintRows(FTabReg, Console.Lines, '[Region] after rejecting changes...', True);
end;

procedure TfrmAcceptChanges.btnJournalClick(Sender: TObject);
var
  oRow: TADDatSRow;
begin
  Console.Lines.Add('DatSManager changes journal...');
  with FDatSManager.Updates do begin
    oRow := FirstChange();
    while oRow <> nil do begin
      PrintRow(oRow, Console.Lines, oRow.Table.Name, True);
      oRow := NextChange(oRow);
    end;
  end;
  Console.Lines.Add('');
end;

end.


