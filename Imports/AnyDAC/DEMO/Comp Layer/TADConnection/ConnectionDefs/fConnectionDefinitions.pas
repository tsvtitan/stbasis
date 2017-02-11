unit fConnectionDefinitions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, Buttons, ComCtrls,
  fConnProperties, fMainBase,
  daADStanIntf,
  daADCompClient, jpeg;

type
  TfrmConnectionDefinitions = class(TfrmMainBase)
    memPInfo: TMemo;
    pcConnDefs: TPageControl;
    tsFromDefFile: TTabSheet;
    tsFromSpecFile: TTabSheet;
    tsClone: TTabSheet;
    tsOnFly: TTabSheet;
    Memo1: TMemo;
    btnLoadConnectionDefs1: TButton;
    OpenDialog1: TOpenDialog;
    edtConnectionDefFileName: TEdit;
    lblConnDefName: TLabel;
    Memo2: TMemo;
    btnBrowse: TButton;
    btnLoadConnectionDefs2: TButton;
    btnLoadConnectionDefs4: TButton;
    cbConnectionDefs5: TComboBox;
    Label11: TLabel;
    edtName: TEdit;
    btnTestConn1: TButton;
    lblConnectionDefs1: TLabel;
    lblPath: TLabel;
    lblPath_ConnDef: TLabel;
    cbConnectionDefs2: TComboBox;
    lblConnectionDefs2: TLabel;
    btnTestConn5: TButton;
    lblPInfo: TLabel;
    cbConnectionDefs1: TComboBox;
    btnTestConn2: TButton;
    btnTestConn3: TButton;
    tsForceErrors: TTabSheet;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    btnGenerateConnDefs: TButton;
    btnCreateAndLoad: TButton;
    Bevel1: TBevel;
    tsAdd: TTabSheet;
    pnlProperties1: TPanel;
    pnlProperties2: TPanel;
    Panel2: TPanel;
    btnLoadConnectionDefs3: TButton;
    cbConnectionDefs4: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    btnTestConn4: TButton;
    procedure btnTestConn1Click(Sender: TObject);
    procedure btnLoadConnectionDefs1Click(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnLoadConnectionDefs2Click(Sender: TObject);
    procedure btnTestConn5Click(Sender: TObject);
    procedure btnGenerateConnDefsClick(Sender: TObject);
    procedure btnCreateAndLoadClick(Sender: TObject);
    procedure btnTestConn2Click(Sender: TObject);
    procedure pcConnDefsChange(Sender: TObject);
    procedure btnTestConn3Click(Sender: TObject);
    procedure btnLoadConnDefs4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tsAddShow(Sender: TObject);
    procedure btnLoadConnectionDefs3Click(Sender: TObject);
    procedure tsOnFlyShow(Sender: TObject);
    procedure btnTestConn4Click(Sender: TObject);
  private
    FProperties: TfrmProperties;
    procedure TestConnection(AConnName: string);
    procedure DeleteConnectionDef(AConnName: string);
    procedure LoadConnectionDefs(AFileName: string);
  public
    { Public declarations }
  end;

var
  frmConnectionDefinitions: TfrmConnectionDefinitions;

implementation

uses
  dmMainComp;

{$R *.dfm}

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.FormCreate(Sender: TObject);
begin
  FProperties := TfrmProperties.Create(nil);
  FProperties.Parent := pnlProperties1;
end;

{ ---------------------------------------------------------------------------- }
{ --- The service procedures ------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.TestConnection(AConnName: string);
begin
  dmlMainComp.dbMain.ConnectionDefName := AConnName;
  dmlMainComp.dbMain.Connected := True;
  memPInfo.Lines.Add('Connect to ' + dmlMainComp.dbMain.ConnectionDefName);
  dmlMainComp.dbMain.Connected := False;
  memPInfo.Lines.Add('Close connection');
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.DeleteConnectionDef(AConnName: string);
begin
  if ADManager.IsConnectionDef(AConnName) then begin
    ADManager.DeleteConnectionDef(AConnName);
    ADManager.SaveConnectionDefFile;
    memPInfo.Lines.Add('Delete connection from ConnectionDefs');
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.LoadConnectionDefs(AFileName: string);
begin
  memPInfo.Lines.Add('Load connection definition file...');
  ADManager.ConnectionDefFileAutoLoad := False;
  if AFileName <> '' then
    ADManager.ConnectionDefFileName := AFileName;
  ADManager.LoadConnectionDefFile;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.pcConnDefsChange(Sender: TObject);
begin
  ADManager.Close;
  ADManager.Open;
end;

{ ---------------------------------------------------------------------------- }
{ --- New private ------------------------------------------------------------ }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.tsOnFlyShow(Sender: TObject);
begin
  FProperties.Parent := pnlProperties1;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnTestConn1Click(Sender: TObject);
var
  oDef: IADStanConnectionDef;
begin
  memPInfo.Lines.Add('Adding private connection definition');
  // Ddding private connection definition.
  oDef := ADManager.ConnectionDefs.AddConnectionDef;
  try
    // Set connection definition parameters using IADStanConnectionDef properties.
    oDef.Name := FProperties.edtNewName.Text;
    oDef.DriverID := FProperties.cbDriverID.Text;
    oDef.Database := FProperties.edtDatabase.Text;
    oDef.UserName := FProperties.edtUserName.Text;
    oDef.Password := FProperties.edtPassword.Text;
    oDef.MonitorBy := 'Indy';
    // Set connection definition parameters using IADStanDefinition AsXXX properties.
    if (oDef.DriverID = 'MSSQL2000') or (oDef.DriverID = 'MSSQL2005') then
      oDef.AsString['Server'] := FProperties.edtSrvHost.Text;
    if oDef.DriverID = 'MySQL' then begin
      oDef.AsString['Host'] := FProperties.edtSrvHost.Text;
      oDef.AsInteger['Port'] := StrToInt(FProperties.edtPort.Text);
    end;
    TestConnection(FProperties.edtNewName.Text);
  finally
    // Delete private connection definition.
    // Actually definition will be destroyed (a) after this call (b) and here
    // will be no more references to definition.
    oDef.Delete;
  end;
end;

{ ---------------------------------------------------------------------------- }
{ --- New persistent --------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.tsAddShow(Sender: TObject);
begin
  FProperties.Parent := pnlProperties2
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnLoadConnectionDefs3Click(
  Sender: TObject);
begin
  LoadConnectionDefs('');
  ADManager.GetConnectionDefNames(cbConnectionDefs4.Items);
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnTestConn4Click(Sender: TObject);
var
  oDef: IADStanConnectionDef;
begin
  memPInfo.Lines.Add('Adding persistent connection definition');
  // Ddding connection definition.
  oDef := ADManager.ConnectionDefs.AddConnectionDef;
  // Set connection definition parameters using IADStanConnectionDef properties.
  oDef.Name := FProperties.edtNewName.Text;
  oDef.DriverID := FProperties.cbDriverID.Text;
  oDef.Database := FProperties.edtDatabase.Text;
  oDef.UserName := FProperties.edtUserName.Text;
  oDef.Password := FProperties.edtPassword.Text;
  oDef.MonitorBy := 'Indy';
  // Set connection definition parameters using IADStanDefinition AsXXX properties.
  if (oDef.DriverID = 'MSSQL2000') or (oDef.DriverID = 'MSSQL2005') then
    oDef.AsString['Server'] := FProperties.edtSrvHost.Text;
  if oDef.DriverID = 'MySQL' then begin
    oDef.AsString['Host'] := FProperties.edtSrvHost.Text;
    oDef.AsInteger['Port'] := StrToInt(FProperties.edtPort.Text);
  end;
  // Mark definition persistent and save it into the file
  oDef.MarkPersistent;
  oDef.Apply;
  TestConnection(FProperties.edtNewName.Text);
end;

{ ---------------------------------------------------------------------------- }
{ --- New cloned ------------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnLoadConnDefs4Click(Sender: TObject);
begin
  LoadConnectionDefs('');
  ADManager.GetConnectionDefNames(cbConnectionDefs5.Items);
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnTestConn5Click(Sender: TObject);
var
  oDef: IADStanConnectionDef;
begin
  oDef := ADManager.ConnectionDefs.ConnectionDefByName(cbConnectionDefs5.Text);
  with ADManager.ConnectionDefs.AddConnectionDef do begin
    // Set new name
    Name := edtName.Text;
    // Clone connection definition simple assigning the parameters
    Params.AddStrings(oDef.Params);
  end;

  TestConnection(edtName.Text);
  DeleteConnectionDef(edtName.Text);
end;

{ ---------------------------------------------------------------------------- }
{ --- Local Connection Definition File --------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnLoadConnectionDefs1Click(Sender: TObject);
begin
  LoadConnectionDefs('');

  memPInfo.Lines.Add('Check if connection definition file is loaded');
  if not ADManager.ConnectionDefFileLoaded then
    memPInfo.Lines.Add('The connection definitions file is not loaded!')
  else
    memPInfo.Lines.Add('The connection definitions file is loaded!');

  lblPath_ConnDef.Caption := ADManager.ConnectionDefFileName;
  ADManager.GetConnectionDefNames(cbConnectionDefs1.Items);
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnTestConn2Click(Sender: TObject);
begin
  TestConnection(cbConnectionDefs1.Text);
end;

{ ---------------------------------------------------------------------------- }
{ --- Set Filename explicitly ------------------------------------------------ }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnLoadConnectionDefs2Click(Sender: TObject);
begin
  memPInfo.Lines.Add('Load the connection definition file ' + edtConnectionDefFileName.Text);
  LoadConnectionDefs(edtConnectionDefFileName.Text);

  ADManager.GetConnectionDefNames(cbConnectionDefs2.Items);
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
     edtConnectionDefFileName.Text := OpenDialog1.FileName;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnTestConn3Click(Sender: TObject);
begin
  TestConnection(cbConnectionDefs2.Text);
end;

{ ---------------------------------------------------------------------------- }
{ --- Force Errors ----------------------------------------------------------- }
{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnGenerateConnDefsClick(Sender: TObject);
begin
  with ADManager.ConnectionDefs.AddConnectionDef do begin
    Name := 'MyDef';
    DriverID := 'MSAcc';
  end;
  with ADManager.ConnectionDefs.AddConnectionDef do begin
    Name := 'MyDef';
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TfrmConnectionDefinitions.btnCreateAndLoadClick(Sender: TObject);
begin
  with ADManager.ConnectionDefs.AddConnectionDef do begin
    Name := 'MyOnFlyDef';
    DriverID := 'MSAcc';
  end;
  ADManager.LoadConnectionDefFile;
end;

end.
