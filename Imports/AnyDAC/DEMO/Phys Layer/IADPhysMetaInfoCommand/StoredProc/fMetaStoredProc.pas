unit fMetaStoredProc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls, jpeg,
  fMainLayers,
  daADStanIntf, daADDatSManager, daADPhysIntf;

type
  TfrmMetaStoredProc = class(TfrmMainLayers)
    rgMain: TRadioGroup;
    edtWildCard: TLabeledEdit;
    btnFetch: TSpeedButton;
    edtProcName: TLabeledEdit;
    edtPackage: TLabeledEdit;
    mmInfo: TMemo;
    procedure btnFetchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgMainClick(Sender: TObject);
    procedure cbDBClick(Sender: TObject);
  private
    FMetaCommIntf: IADPhysMetaInfoCommand;
    FTab: TADDatSTable;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMetaStoredProc: TfrmMetaStoredProc;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmMetaStoredProc.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create('TableOfMetaInfo');
  cbDB.Items.Delete(cbDB.Items.IndexOf('Access_Demo'));
  cbDB.Items.Delete(cbDB.Items.IndexOf('MySQL_Demo'));
end;

procedure TfrmMetaStoredProc.FormDestroy(Sender: TObject);
begin
  FMetaCommIntf := nil;
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmMetaStoredProc.cbDBClick(Sender: TObject);
begin
  btnFetch.Enabled := True;
  inherited cbDBClick(Sender);
  FConnIntf.CreateMetaInfoCommand(FMetaCommIntf);
end;

procedure TfrmMetaStoredProc.btnFetchClick(Sender: TObject);
begin
  if (rgMain.ItemIndex = 0) and (GetRDBMSKind = mkOracle) then
    with FMetaCommIntf do begin
      MetaInfoKind := mkPackages;         // setting the meta info kind
      ObjectScopes := [osMy, osSystem];   // setting scope of objects
      Wildcard     := edtWildCard.Text;   // use wildcard like "LIKE" in SQL

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end
  else if rgMain.ItemIndex = 1 then
    with FMetaCommIntf do begin
      BaseObjectName := edtPackage.Text;  // setting the package name to BaseObjectName
      MetaInfoKind   := mkProcs;          // setting the meta info kind
      Wildcard       := '';

      Prepare;                            // preparing the meta info command interface
      Define(FTab);                       // defining a meta info table structure
      Open;
      Fetch(FTab);                        // fetching meta info
    end
  else if rgMain.ItemIndex = 2 then
    with FMetaCommIntf do begin
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

procedure TfrmMetaStoredProc.rgMainClick(Sender: TObject);
begin
  if rgMain.ItemIndex = 0 then
    edtProcName.Enabled := False
  else
    edtProcName.Enabled := True;
end;

end.
