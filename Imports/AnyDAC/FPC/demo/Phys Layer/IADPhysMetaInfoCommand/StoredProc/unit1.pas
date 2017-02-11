unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls,
  daADStanDef, daADStanAsync, daADStanExpr, daADStanOption, daADStanPool,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysOracl;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnConnect: TButton;
    btnFetch: TButton;
    edtPackage: TLabeledEdit;
    edtProcName: TLabeledEdit;
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
    edtProcName.Enabled := False
  else
    edtProcName.Enabled := True;
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
      MetaInfoKind := mkPackages;         // setting the meta info kind
      ObjectScopes := [osMy, osSystem];   // setting scope of objects
      Wildcard     := edtWildCard.Text;   // use wildcard like "LIKE" in SQL

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end
  else if rgMain.ItemIndex = 1 then
    with FMeta do begin
      BaseObjectName := edtPackage.Text;  // setting the package name to BaseObjectName
      MetaInfoKind   := mkProcs;          // setting the meta info kind
      Wildcard       := '';

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end
  else if rgMain.ItemIndex = 2 then
    with FMeta do begin
      BaseObjectName := edtPackage.Text;  // setting the package name to BaseObjectName
      CommandText    := edtProcName.Text; // setting the proc name to CommandText
      MetaInfoKind   := mkProcArgs;       // setting the meta info kind
      Wildcard       := '';

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end;

  Console.Clear;
  PrintRows(FTab, Console.Lines, 'Meta info table');
end;

initialization
  {$I unit1.lrs}

end.

