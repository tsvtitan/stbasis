unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons,
  daADStanDef, daADStanAsync, daADStanExpr, daADStanOption, daADStanPool,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysMySQL;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnConnect: TButton;
    btnFetch: TButton;
    cbTable: TComboBox;
    edtWildCard: TLabeledEdit;
    Label1: TLabel;
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
    cbTable.Enabled := False
  else
    cbTable.Enabled := True;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  ADPhysManager.Open;

  ADPhysManager.CreateConnection('MySQL_Demo', FConn);
  FConn.Open;

  FConn.CreateMetaInfoCommand(FMeta);
end;

procedure TForm1.btnFetchClick(Sender: TObject);
begin
  if rgMain.ItemIndex = 0 then
    with FMeta do begin
      MetaInfoKind := mkTables;           // setting the meta info kind
      ObjectScopes := [osMy, osSystem];   // setting scope of objects
      TableKinds   := [tkTable, tkView];  // fetch only info about tables and views
      Wildcard     := edtWildCard.Text;   // use wildcard like "LIKE" in SQL

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end
  else
    with FMeta do begin
      // Note! You must encapsulate a table name to the specified for RDBMS separators,
      // for ex. in MySQL the name Categories is to be `Categories`, in DB2 "Categories" etc.
      CommandText  := cbTable.Text;       // setting the table name (in commas) to CommandText
      MetaInfoKind := mkTableFields;      // setting the meta info kind
      Wildcard     := '';

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end;

  Console.Clear;
  PrintRows(FTab, Console.Lines, 'Meta info of tables');
end;

initialization
  {$I unit1.lrs}

end.

