unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, DB, Buttons, Grids, DBGrids, ExtCtrls,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADCompDataMove, jpeg;

type
  TfrmMain = class(TfrmMainCompBase)
    dtmMain: TADDataMove;
    btnTabToASCMove: TSpeedButton;
    btnASCToTabMove: TSpeedButton;
    btnTabToTabMove: TSpeedButton;
    qryMoved: TADQuery;
    qryLoaded: TADQuery;
    dsMoved: TDataSource;
    dsLoaded: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    grdLoaded: TDBGrid;
    Panel3: TPanel;
    Splitter1: TSplitter;
    grdMoved: TDBGrid;
    procedure btnTabToASCMoveClick(Sender: TObject);
    procedure btnASCToTabMoveClick(Sender: TObject);
    procedure btnTabToTabMoveClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure CloseQueries;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  dmMainComp,
  daADStanUtil;

{$R *.dfm}

{ ---------------------------------------------------------------------------- }
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  // These properties is used for optimised TADDataMove work.
  // You may set up the ones in design time.
  with dtmMain do begin
    Mode := dmAlwaysInsert;
    Options := Options + [poClearDest] - [poOptimiseDest];
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMain.btnASCToTabMoveClick(Sender: TObject);
begin
  CloseQueries;
  // ASCII file to Table in RDBMS
  with dtmMain do begin
    // Set up kind of source
    SourceKind := skAscii;
    // Set up ASCII file name
    // ADExpandStr utility expands the variables like '$(ADHOME)' to the string
    AsciiFileName := ADExpandStr('$(ADHOME)\DEMO\Comp Layer\TADDataMove\Main\Data.txt');
    // Set delimiter char
    AsciiDataDef.Separator := ';';
    // If ASCII file contains the field names AsciiDataDef.WithFieldNames must be True
    AsciiDataDef.WithFieldNames := True;
    // Use TADQuery as Destination
    Destination := qryLoaded;
  end;
  dtmMain.Execute;

  // show data in dbgrid
  qryLoaded.Open;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMain.btnTabToASCMoveClick(Sender: TObject);
begin
  CloseQueries;
  // Table in RDBMS to ASCII file
  with dtmMain do begin
    // Set up ASCII file name
    AsciiFileName := ADExpandStr('$(ADHOME)\DEMO\Comp Layer\TADDataMove\Main\DataOut.txt');
    // Use TADQuery as Source
    Source := qryLoaded;
    // Set up kind of destination
    DestinationKind := skAscii;
  end;
  dtmMain.Execute;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMain.btnTabToTabMoveClick(Sender: TObject);
begin
  CloseQueries;
  // Table to Table in RDBMS
  with dtmMain do begin
    // Use TADTable as Source
    Source := qryLoaded;
    // Use TADTable as Destination
    Destination := qryMoved;
    // Setting other properties
    Mode := dmAlwaysInsert;
    Options := Options + [poClearDest];
  end;
  dtmMain.Execute;

  // show data in dbgrid
  qryLoaded.Open;
  qryMoved.Open;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMain.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  btnTabToASCMove.Enabled := True;
  btnASCToTabMove.Enabled := True;
  btnTabToTabMove.Enabled := True;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmMain.CloseQueries;
begin
  qryMoved.Close;
  qryLoaded.Close;
end;

end.
