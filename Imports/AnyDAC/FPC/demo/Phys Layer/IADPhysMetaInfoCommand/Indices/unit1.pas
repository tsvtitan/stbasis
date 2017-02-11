unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons,
  daADStanDef, daADStanAsync, daADStanExpr, daADStanOption, daADStanPool,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysOracl;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnFetch: TButton;
    btnConnect: TButton;
    edtIndexName: TLabeledEdit;
    edtTableName: TLabeledEdit;
    edtWildCard: TLabeledEdit;
    Console: TMemo;
    rgMain: TRadioGroup;
    procedure btnConnectClick(Sender: TObject);
    procedure btnFetchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgMainClick(Sender: TObject);
  private
    FConn: IADPhysConnection;
    FMeta: IADPhysMetaInfoCommand;
    FTab: TADDatSTable;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

uses
  uDatSUtils;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTab := TADDatSTable.Create('TableOfMetaInfo');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

procedure TForm1.rgMainClick(Sender: TObject);
begin
  if rgMain.ItemIndex = 0 then
    edtIndexName.Enabled := False
  else
    edtIndexName.Enabled := True;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  ADPhysManager.Open;

  ADPhysManager.CreateConnection('Oracle_Demo', FConn);
  FConn.Open;

  FConn.CreateMetaInfoCommand(FMeta);
end;

procedure TForm1.btnFetchClick(Sender: TObject);
begin
  if rgMain.ItemIndex = 0 then
    with FMeta do begin
      CommandText  := edtTableName.Text;
      MetaInfoKind := mkIndexes;          // setting the meta info kind
      {
        if you'd like fetch info only of primary keys in the base, you should
        set MetaInfoKind := mkPrimaryKey
      }
      ObjectScopes := [osMy, osSystem];   // setting scope of objects
      Wildcard     := edtWildCard.Text;   // use wildcard like "LIKE" in SQL

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end
  else
    with FMeta do begin
      // Note! You must encapsulate a table name (and index name) to the specified for RDBMS separators
      // for ex. in MySQL the name Categories is to be `Categories`
      BaseObjectName := edtTableName.Text;  // setting the table name (in commas!!!) to BaseObjectName
      CommandText    := edtIndexName.Text;  // setting the index name (in commas!!!) to CommandText
      MetaInfoKind   := mkIndexFields;      // setting the meta info kind
      Wildcard       := '';
      {
        if you'd like fetch info only of primary key fields, you should
        set MetaInfoKind := mkPrimaryKeyFields
      }

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end;

  Console.Clear;
  PrintRows(FTab, Console.Lines, 'Meta info about indices');
end;

initialization
  {$I unit1.lrs}

end.

