unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons,
  daADStanDef, daADStanAsync,
  daADDatSManager,
  daADGUIxConsoleWait,
  daADPhysIntf, daADPhysManager, daADPhysMSAcc;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCreateConnection: TButton;
    Console: TMemo;
    procedure btnCreateConnectionClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{ TForm1 }

procedure TForm1.btnCreateConnectionClick(Sender: TObject);
var
  oConn: IADPhysConnection;
begin
  ADPhysManager.ConnectionDefs.Storage.FileName := '$(ADHOME)\DB\ADConnectionDefs.ini';
  ADPhysManager.Open;

  // -----------------------------------------------------------------------
  // (1) Using existing definition "as-is"
  // Set connection definition name to Access_Demo
  ADPhysManager.CreateConnection('Access_Demo', oConn);
  oConn.Open;
  Console.Lines.Add('Connected to Access_Demo');
  oConn.Close;
  oConn := nil;

  // -----------------------------------------------------------------------
  // (2) Overriding parent definition without changing itself
  // Adding new definition
  with ADPhysManager.ConnectionDefs.AddConnectionDef do begin
    // set parent definition
    ParentDefinition := ADPhysManager.ConnectionDefs.ConnectionDefByName('Access_Demo');
    Name := 'MyDefOverride';
    AsBoolean['ReadOnly'] := True;
  end;
  // Connect through my definition
  ADPhysManager.CreateConnection('MyDefOverride', oConn);
  oConn.Open;
  Console.Lines.Add('Connected to MyDefOverride');
  oConn.Close;
  oConn := nil;

  // -----------------------------------------------------------------------
  // (3) Creating new definition "on-fly"
  // Adding new definition
  with ADPhysManager.ConnectionDefs.AddConnectionDef do begin
    Name := 'MyDefNew';
    DriverID := 'MSAcc';
    Database := '$(ADHOME)\DB\Data\ADDemo.mdb';  // using properties
    Params.Add('Tracing=True');                  // using Params
    AsBoolean['ReadOnly'] := True;               // using AsXXX properties
  end;
  // Connect through my definition
  ADPhysManager.CreateConnection('MyDefNew', oConn);
  oConn.Open;
  Console.Lines.Add('Connected to MyDefNew');
  oConn.Close;
  oConn := nil;
  // to make new definition persistent call following:
  // ADPhysManager.ConnectionDefs.Save;

  // -----------------------------------------------------------------------
  // (4) Creating new definition using AnyDAC connection string
  ADPhysManager.CreateConnection('DriverID=MSAcc;Database=$(ADHOME)\DB\Data\ADDemo.mdb;ReadOnly=True', oConn);
  oConn.Open;
  Console.Lines.Add('Connected using connection string');
  oConn.Close;
  oConn := nil;
end;

initialization
  {$I unit1.lrs}

end.

