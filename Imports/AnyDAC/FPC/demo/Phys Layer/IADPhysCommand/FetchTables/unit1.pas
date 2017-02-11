unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
    Buttons, StdCtrls,
  daADStanDef, daADStanAsync, daADStanExpr,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysMySQL;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnConnect: TButton;
    btnFetch: TButton;
    Console: TMemo;
    procedure btnConnectClick(Sender: TObject);
    procedure btnFetchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FConnIntf: IADPhysConnection;
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
  FTab := TADDatSTable.Create('Shippers');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FTab.Free;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  ADPhysManager.Open;
  ADPhysManager.CreateConnection('MySQL_Demo', FConnIntf);
  FConnIntf.Open;
end;

procedure TForm1.btnFetchClick(Sender: TObject);
var
  oCommIntf: IADPhysCommand;
begin
  // create command interface
  FConnIntf.CreateCommand(oCommIntf);
  with oCommIntf do begin
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

initialization
  {$I unit1.lrs}

end.

