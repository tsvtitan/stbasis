unit fMetaTables;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls,
  fMainLayers,
  daADDatSManager, daADPhysIntf, jpeg;

type
  TfrmMetaTables = class(TfrmMainLayers)
    rgMain: TRadioGroup;
    edtWildCard: TLabeledEdit;
    btnFetch: TSpeedButton;
    cbTable: TComboBox;
    Label1: TLabel;
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
  frmMetaTables: TfrmMetaTables;

implementation

uses
  uDatSUtils;

{$R *.dfm}

procedure TfrmMetaTables.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FTab := TADDatSTable.Create('TableOfMetaInfo');
end;

procedure TfrmMetaTables.FormDestroy(Sender: TObject);
begin
  FMetaCommIntf := nil;
  FTab.Free;
  inherited FormDestroy(Sender);
end;

procedure TfrmMetaTables.cbDBClick(Sender: TObject);
begin
  inherited cbDBClick(Sender);
  FConnIntf.CreateMetaInfoCommand(FMetaCommIntf);

  btnFetch.Enabled := True;
end;

procedure TfrmMetaTables.btnFetchClick(Sender: TObject);
begin
  if rgMain.ItemIndex = 0 then
    with FMetaCommIntf do begin
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
    with FMetaCommIntf do begin
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

procedure TfrmMetaTables.rgMainClick(Sender: TObject);
begin
  if rgMain.ItemIndex = 0 then
    cbTable.Enabled := False
  else
    cbTable.Enabled := True;
end;

end.
