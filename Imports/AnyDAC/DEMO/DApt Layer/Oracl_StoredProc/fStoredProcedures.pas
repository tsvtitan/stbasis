unit fStoredProcedures;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  fMainLayers,
  daADDatSManager, daADPhysIntf, daADDAptIntf, jpeg;

type
  TfrmStoredProcedures = class(TfrmMainLayers)
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStoredProcedures: TfrmStoredProcedures;

implementation

{$R *.dfm}

uses
  daADStanOption, daADStanFactory,
  uDatSUtils;

procedure TfrmStoredProcedures.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  cbDB.ItemIndex := cbDB.Items.IndexOf('Oracle_Demo');
  cbDBClick(nil);
end;

procedure TfrmStoredProcedures.cbDBClick(Sender: TObject);
var
  oComm:  IADPhysCommand;
  oAdapt: IADDAptTableAdapter;
begin
  inherited cbDBClick(Sender);
  // 1. create table adapter
  ADCreateInterface(IADDAptTableAdapter, oAdapt);
  with oAdapt do begin

    // 2. assign command
    FConnIntf.CreateCommand(oComm);
    SelectCommand := oComm;

    // 3. set DatSTable name, where rows will be fetched
    DatSTableName := 'StoredProc';

    // 4. set up SelectCommand
    with SelectCommand do begin
      // set package name
      BaseObjectName := 'ADQA_testpack';
      // set porcedure's name
      CommandText := 'SelectShippers';
      // we have stored procedure with cursor
      CommandKind := skStoredProcWithCrs;
      Prepare;
    end;

    // 5. fetch rows
    Define;
    Fetch;

    PrintRows(DatSTable, Console.Lines, 'Fetched rows ------------------');
  end;
end;

end.

