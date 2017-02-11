unit fUpdateSQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, Buttons, ExtCtrls, StdCtrls, Grids, DBGrids, DBCtrls,
  fMainCompBase,
  daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADGUIxFormsfResourceOptions, daADGUIxFormsfFetchOptions,
    daADGUIxFormsfFormatOptions, daADGUIxFormsfUpdateOptions,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, jpeg;

type
  TfrmUpdateSQL = class(TfrmMainCompBase)
    spSel: TADStoredProc;
    spSelREGIONID: TIntegerField;
    spSelREGIONDESCRIPTION: TStringField;
    dsSel: TDataSource;
    ADUpdateSQL1: TADUpdateSQL;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpdateSQL: TfrmUpdateSQL;

implementation

uses
  dmMainComp;

{$R *.dfm}

procedure TfrmUpdateSQL.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  cbDB.ItemIndex := cbDB.Items.IndexOf('Oracle_Demo');
  cbDB.OnClick(nil);
end;

procedure TfrmUpdateSQL.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  spSel.Open;
end;

end.
