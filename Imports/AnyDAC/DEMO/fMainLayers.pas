unit fMainLayers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Grids, DBGrids, DB, StdCtrls, FMTBcd, SqlExpr, ComCtrls, ExtCtrls, Buttons,
  fMainConnectionDefBase,
  daADStanIntf, daADStanOption,
  daADPhysIntf, jpeg;

type
  TfrmMainLayers = class(TfrmMainConnectionDefBase)
    Console: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    FConnIntf: IADPhysConnection;
    FShowLoginDialog: Boolean;
  public
    procedure GetConnectionDefs(AList: TStrings); override;
    procedure SetConnDefName(AConnDefName: String); override;
    procedure ConnectionActive(AValue: Boolean); override;
    function GetFormatOptions: TADFormatOptions; override;
    function GetRDBMSKind: TADRDBMSKind; override;
    // service funcs
    function EncodeName(AName: String): String;
    function EncodeField(AField: String): String;
  end;

var
  frmMainLayers: TfrmMainLayers;

implementation

{$R *.dfm}

procedure TfrmMainLayers.FormCreate(Sender: TObject);
begin
  ADPhysManager.ConnectionDefs.Storage.FileName := '$(ADHOME)\DB\ADConnectionDefs.ini';
  ADPhysManager.Open;
  inherited FormCreate(Sender);
  FShowLoginDialog := True;
end;

procedure TfrmMainLayers.FormDestroy(Sender: TObject);
begin
  FConnIntf := nil;
end;

procedure TfrmMainLayers.GetConnectionDefs(AList: TStrings);
var
  i: Integer;
begin
  AList.BeginUpdate;
  AList.Clear;
  for i := 0 to ADPhysManager.ConnectionDefs.Count - 1 do
    AList.Add(ADPhysManager.ConnectionDefs[i].Name);
  AList.EndUpdate;
end;

procedure TfrmMainLayers.ConnectionActive(AValue: Boolean);
begin
  if AValue then begin
    if not FShowLoginDialog then
      FConnIntf.LoginPrompt := False;
    FConnIntf.Open
  end
  else
    FConnIntf := nil;
end;

function TfrmMainLayers.GetFormatOptions: TADFormatOptions;
begin
  Result := FConnIntf.Options.FormatOptions;
end;

procedure TfrmMainLayers.SetConnDefName(AConnDefName: String);
begin
  ADPhysManager.CreateConnection(AConnDefName, FConnIntf);
end;

function TfrmMainLayers.GetRDBMSKind: TADRDBMSKind;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  FConnIntf.CreateMetadata(oConnMeta);
  Result := oConnMeta.Kind;
end;

function TfrmMainLayers.EncodeField(AField: String): String;
var
  oConnMeta: IADPhysConnectionMetaData;
begin
  FConnIntf.CreateMetadata(oConnMeta);
  if oConnMeta.Kind = mkMySQL then
    Result := oConnMeta.NameQuotaChar1 + AField + oConnMeta.NameQuotaChar2
  else
    Result := AField;
end;

function TfrmMainLayers.EncodeName(AName: String): String;
var
  oConnMeta: IADPhysConnectionMetaData;
begin
  FConnIntf.CreateMetadata(oConnMeta);
  Result := oConnMeta.NameQuotaChar1 + AName + oConnMeta.NameQuotaChar2;
end;

end.
