unit fClients;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg,
  fMainLayers,
  daADStanIntf,
  daADPhysIntf;

type
  TfrmClients = class(TfrmMainLayers)
    Panel1: TPanel;
    rgClients: TRadioGroup;
    Panel2: TPanel;
    mmInfo: TMemo;
    procedure cbDBClick(Sender: TObject);
  end;

var
  frmClients: TfrmClients;

implementation

uses
  dmMainBase, daADStanFactory;

{$R *.dfm}

procedure TfrmClients.cbDBClick(Sender: TObject);
var
  oConnectionDef: IADStanConnectionDef;
  oRemMoni: IADMoniRemoteClient;
  oFFMoni: IADMoniFlatFileClient;
  oMoni: IADMoniClient;
  oStream: TStream;
begin
  // 1) Set connection definition to use none, remote or flat file monitoring
  oConnectionDef := ADPhysManager.ConnectionDefs.ConnectionDefByName(cbDB.Text);
  case rgClients.ItemIndex of
  0: // turn off
    oConnectionDef.MonitorBy := '';
  1: // remote
    begin
      oConnectionDef.MonitorBy := 'Indy';
      oConnectionDef.AsString['MonitorByIndy_Host'] := '127.0.0.1';
      // or ADMoniIndyClientLink1.Host := '127.0.0.1';
      oConnectionDef.AsInteger['MonitorByIndy_Port'] := 8050;
      // or ADMoniIndyClientLink1.Port := 8050;
      oConnectionDef.AsInteger['MonitorCategories'] := $FFFF;
      // or ADMoniIndyClientLink1.EventKinds := [ekLiveCycle..ekVendor];
    end;
  2: // flat file
    begin
      oConnectionDef.MonitorBy := 'FlatFile';
      oConnectionDef.AsString['MonitorByFlatFile_FileName'] := 'trace_' + oConnectionDef.Name + '.txt';
      // or ADMoniFlatFileClientLink1.FileName := sFlatFileName;
      oConnectionDef.AsBoolean['MonitorByFlatFile_FileAppend'] := False;
      // or ADMoniFlatFileClientLink1.FileAppend := False;
    end;
  end;

  // 2) connecting to RDBMS
  inherited cbDBClick(Sender);

  // 3) Get remote or flat file monitoring client
  case rgClients.ItemIndex of
  0: // turn off
    Exit;
  1: // remote
    begin
      ADCreateInterface(IADMoniRemoteClient, oRemMoni);
      oMoni := oRemMoni as IADMoniClient;
    end;
  2: // flat file
    begin
      ADCreateInterface(IADMoniFlatFileClient, oFFMoni);
      oMoni := oFFMoni as IADMoniClient;
    end;
  end;

  // 4) Produce custom trace output
  oMoni.Tracing := True;
  oMoni.Notify(ekVendor, esStart,    Self, 'Start monitoring',        ['Form', 'frmClients']);
  oMoni.Notify(ekVendor, esProgress, Self, 'Progress monitoring',     ['Form', 'frmClients']);
  oMoni.Notify(ekVendor, esEnd,      Self, 'End monitoring',          ['Form', 'frmClients']);
  oMoni.Notify(ekError,  esProgress, Self, 'Error during monitoring', ['Form', 'frmClients']);
  oMoni.Tracing := False;

  // 5) Print flat file
  if rgClients.ItemIndex = 2 then begin
    ADCreateInterface(IADMoniFlatFileClient, oFFMoni);
    oStream := TFileStream.Create(oFFMoni.FileName, fmOpenRead or fmShareDenyNone);
    try
      Console.Lines.LoadFromStream(oStream);
    finally
      oStream.Free;
    end;
  end;
end;

end.
