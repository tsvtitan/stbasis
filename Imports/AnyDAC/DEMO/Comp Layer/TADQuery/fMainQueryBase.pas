unit fMainQueryBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Grids, DBGrids, DB, StdCtrls, FMTBcd, ComCtrls, ExtCtrls, Buttons, jpeg,
  fMainBase, fMainCompBase,
  daADStanIntf, daADStanOption,
  daADCompClient, daADGUIxFormsfResourceOptions,
  daADGUIxFormsfUpdateOptions, daADGUIxFormsfFormatOptions,
  daADGUIxFormsfFetchOptions, daADGUIxFormsControls;

type
  TfrmMainQueryBase = class(TfrmMainCompBase)
    pnlSubPageControl: TPanel;
    pcMain: TADGUIxFormsPageControl;
    tsData: TTabSheet;
    tsOptions: TTabSheet;
    ADGUIxFormsPanelTree1: TADGUIxFormsPanelTree;
    frmUpdateOptions: TfrmADGUIxFormsUpdateOptions;
    frmResourceOptions: TfrmADGUIxFormsResourceOptions;
    frmFormatOptions: TfrmADGUIxFormsFormatOptions;
    frmFetchOptions: TfrmADGUIxFormsFetchOptions;
    pnlDataSet: TPanel;
    btnSave: TSpeedButton;
    lblDataSet: TLabel;
    cbDataSet: TComboBox;
    pnlMainSep: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pcMainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure cbDataSetClick(Sender: TObject);
  private
    FDataSets: TList;
  protected
    procedure RegisterDS(ADataSet: TADRdbmsDataSet);
  public
    procedure GetConnectionDefs(AList: TStrings); override;
    procedure SetConnDefName(AConnDefName: String); override;
    procedure ConnectionActive(AValue: Boolean); override;
    function GetFormatOptions: TADFormatOptions; override;
    function GetRDBMSKind: TADRDBMSKind; override;
  end;

  TADHackDataSet = class(TADRdbmsDataSet)
  public
    property UpdateOptions;
    property FormatOptions;
    property FetchOptions;
    property ResourceOptions;
  end;

var
  frmMainQueryBase: TfrmMainQueryBase;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmMainQueryBase.FormCreate(Sender: TObject);
begin
  FDataSets := TList.Create;
  inherited FormCreate(Sender);
end;

procedure TfrmMainQueryBase.FormDestroy(Sender: TObject);
begin
  FDataSets.Free;
  FDataSets := nil;
end;

procedure TfrmMainQueryBase.RegisterDS(ADataSet: TADRdbmsDataSet);
begin
  FDataSets.Add(ADataSet);
  cbDataSet.Items.Add(ADataSet.Name);
end;

procedure TfrmMainQueryBase.cbDataSetClick(Sender: TObject);
var
  oDS: TADHackDataSet;
begin
  if FDataSets.Count = 0 then
    Exit;
  oDS := TADHackDataSet(FDataSets[cbDataSet.ItemIndex]);
  frmUpdateOptions.LoadFrom(oDS.UpdateOptions);
  frmFormatOptions.LoadFrom(oDS.FormatOptions);
  frmFetchOptions.LoadFrom(oDS.FetchOptions);
  frmResourceOptions.LoadFrom(oDS.ResourceOptions);
end;

procedure TfrmMainQueryBase.btnSaveClick(Sender: TObject);
var
  oDS: TADHackDataSet;
begin
  oDS := TADHackDataSet(FDataSets[cbDataSet.ItemIndex]);
  frmUpdateOptions.SaveTo(oDS.UpdateOptions);
  frmFormatOptions.SaveTo(oDS.FormatOptions);
  frmFetchOptions.SaveTo(oDS.FetchOptions);
  frmResourceOptions.SaveTo(oDS.ResourceOptions);
end;

procedure TfrmMainQueryBase.pcMainChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pcMain.ActivePage = tsData then begin
    if cbDataSet.ItemIndex = -1 then
      cbDataSet.ItemIndex := 0;
    cbDataSetClick(nil);
  end;
  AllowChange := True;
end;

procedure TfrmMainQueryBase.GetConnectionDefs(AList: TStrings);
begin
  ADManager.GetConnectionDefNames(AList);
end;

procedure TfrmMainQueryBase.ConnectionActive(AValue: Boolean);
begin
  if AValue then
    dmlMainComp.dbMain.Open
  else
    dmlMainComp.dbMain.Close;
end;

procedure TfrmMainQueryBase.SetConnDefName(AConnDefName: String);
begin
  dmlMainComp.dbMain.ConnectionDefName := AConnDefName;
end;

function TfrmMainQueryBase.GetFormatOptions: TADFormatOptions;
begin
  Result := dmlMainComp.dbMain.FormatOptions;
end;

function TfrmMainQueryBase.GetRDBMSKind: TADRDBMSKind;
begin
  Result := dmlMainComp.dbMain.RDBMSKind;
end;

end.
