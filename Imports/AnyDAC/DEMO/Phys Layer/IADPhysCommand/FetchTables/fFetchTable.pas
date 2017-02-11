unit fFetchTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, ExtCtrls, StdCtrls, Buttons,
  fMainLayers,
  daADDatSManager, daADPhysIntf, jpeg;

type
  TfrmFetchTable = class(TfrmMainLayers)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
    FTab: TADDatSTable;
    FCommIntf: IADPhysCommand;
  public
    { Public declarations }
  end;

var
  frmFetchTable: TfrmFetchTable;

implementation

uses
  uDatSUtils;

{$R *.dfm}


procedure TfrmFetchTable.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create('Shippers');
end;

procedure TfrmFetchTable.FormDestroy(Sender: TObject);
begin
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmFetchTable.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  // create command interface
  FConnIntf.CreateCommand(FCommIntf);

  with FCommIntf do begin
    Prepare('select * from {id Shippers}');                       // prepare a command
    Define(FTab);
    {Define(FTab, mmOverride); - if we wish redefine our table, which was defined before
     Define(FTab, mmRely); - if we want check our table definition
    }
    Open;                                                         // open command interface
    Fetch(FTab);                                                  // fetching table
  end;
  PrintRows(FTab, Console.Lines, 'Fetching a table...');
end;

end.


