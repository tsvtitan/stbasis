unit fMainCompBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Grids, DBGrids, DB, StdCtrls, FMTBcd, ComCtrls, ExtCtrls, Buttons, jpeg,
  fMainBase, fMainConnectionDefBase,
  daADStanIntf, daADStanOption,
  daADCompClient;

type
  TfrmMainCompBase = class(TfrmMainConnectionDefBase)
    StatusBar1: TStatusBar;
  public
    procedure GetConnectionDefs(AList: TStrings); override;
    procedure SetConnDefName(AConnDefName: String); override;
    procedure ConnectionActive(AValue: Boolean); override;
    function GetFormatOptions: TADFormatOptions; override;
    function GetRDBMSKind: TADRDBMSKind; override;
  end;

var
  frmMainCompBase: TfrmMainCompBase;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmMainCompBase.GetConnectionDefs(AList: TStrings);
begin
  ADManager.GetConnectionDefNames(AList);
end;

procedure TfrmMainCompBase.ConnectionActive(AValue: Boolean);
begin
  if AValue then
    dmlMainComp.dbMain.Open
  else
    dmlMainComp.dbMain.Close;
end;

procedure TfrmMainCompBase.SetConnDefName(AConnDefName: String);
begin
  dmlMainComp.dbMain.ConnectionDefName := AConnDefName;
end;

function TfrmMainCompBase.GetFormatOptions: TADFormatOptions;
begin
  Result := dmlMainComp.dbMain.FormatOptions;
end;

function TfrmMainCompBase.GetRDBMSKind: TADRDBMSKind;
begin
  Result := dmlMainComp.dbMain.RDBMSKind;
end;

end.
