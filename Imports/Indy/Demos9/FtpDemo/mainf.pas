// This demo demonstrates the use of IdFTP and IdDebugLog components
// There is some problems with ABORT function.
//
// This demo supports both UNIX and DOS directory listings
//
unit mainf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdIntercept, IdLogBase, IdLogDebug, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, StdCtrls, ExtCtrls, ComCtrls;

type
  TMainForm = class(TForm)
    DirectoryListBox: TListBox;
    IdFTP1: TIdFTP;
    IdLogDebug1: TIdLogDebug;
    DebugListBox: TListBox;
    Panel1: TPanel;
    FtpServerEdit: TEdit;
    ConnectButton: TButton;
    Splitter1: TSplitter;
    Label1: TLabel;
    UploadOpenDialog1: TOpenDialog;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    TraceCheckBox: TCheckBox;
    CommandPanel: TPanel;
    UploadButton: TButton;
    AbortButton: TButton;
    BackButton: TButton;
    DeleteButton: TButton;
    DownloadButton: TButton;
    UserIDEdit: TEdit;
    PasswordEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure ConnectButtonClick(Sender: TObject);
    procedure IdLogDebug1LogItem(ASender: TComponent; var AText: String);
    procedure UploadButtonClick(Sender: TObject);
    procedure DirectoryListBoxDblClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure IdFTP1Disconnected(Sender: TObject);
    procedure IdFTP1Work(Sender: TComponent; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdFTP1WorkEnd(Sender: TComponent; AWorkMode: TWorkMode);
    procedure IdFTP1WorkBegin(Sender: TComponent; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure AbortButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
    procedure TraceCheckBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DirectoryListBoxClick(Sender: TObject);
  private
    { Private declarations }
    AbortTransfer: Boolean;
    TransferrignData: Boolean;
    BytesToTransfer: LongWord;
    procedure ChageDir(DirName: String);
    procedure SetFunctionButtons(Value: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.SetFunctionButtons(Value: Boolean);
Var
  i: Integer;
begin
  with CommandPanel do
    for i := 0 to ControlCount - 1 do
      if Controls[i].Name <> 'AbortButton' then Controls[i].Enabled := Value;
end;

procedure TMainForm.ConnectButtonClick(Sender: TObject);
begin
  ConnectButton.Enabled := false;
  if IdFTP1.Connected then try
    if TransferrignData then IdFTP1.Abort;
    IdFTP1.Quit;
    IdFTP1.Disconnect;
    DirectoryListBox.Items.Clear;
    SetFunctionButtons(false);
    Panel3.Caption := 'Current directory is: ';
  finally
    ConnectButton.Caption := 'Connect';
    ConnectButton.Enabled := true;
    ConnectButton.Default := true;
  end
  else
    with IdFTP1 do try
      User := UserIDEdit.Text;
      Password := PasswordEdit.Text;
      Host := FtpServerEdit.Text;
      Connect;
      Self.ChageDir('/');
      SetFunctionButtons(true);
    finally
      if Connected then begin
        ConnectButton.Enabled := true;
        ConnectButton.Caption := 'Disconnect';
        ConnectButton.Default := false;
      end;
    end;
end;

procedure TMainForm.IdLogDebug1LogItem(ASender: TComponent;
  var AText: String);
begin
  DebugListBox.ItemIndex := DebugListBox.Items.Add(AText);
  Application.ProcessMessages;
end;

procedure TMainForm.UploadButtonClick(Sender: TObject);
begin
  if IdFTP1.Connected then begin
    if UploadOpenDialog1.Execute then try
      SetFunctionButtons(false);
      IdFTP1.TransferType := ftBinary;
      IdFTP1.Put(UploadOpenDialog1.FileName, ExtractFileName(UploadOpenDialog1.FileName));
      ChageDir(idftp1.RetrieveCurrentDir);
    finally
      SetFunctionButtons(true);
    end;
  end;
end;

procedure TMainForm.ChageDir(DirName: String);
begin
  try
    SetFunctionButtons(false);
    IdFTP1.ChangeDir(DirName);
    IdFTP1.TransferType := ftASCII;
    Panel3.Caption := 'Current directory is: ' + IdFTP1.RetrieveCurrentDir +
      '              Remote system is ' + IdFTP1.SystemDesc;;
    DirectoryListBox.Items.Clear;
    IdFTP1.List(DirectoryListBox.Items);
  finally
    SetFunctionButtons(true);
  end;
end;

function GetNameFromDirLine(Line: String; Var IsDirectory: Boolean): String;
Var
  i: Integer;
  DosListing: Boolean;
begin
  IsDirectory := Line[1] = 'd';
  DosListing := false;
  for i := 0 to 7 do begin
    if (i = 2) and not IsDirectory then begin
      IsDirectory := Copy(Line, 1, Pos(' ', Line) - 1) = '<DIR>';
      if not IsDirectory then
        DosListing := Line[1] in ['0'..'9']
      else DosListing := true;
    end;
    Delete(Line, 1, Pos(' ', Line));
    While Line[1] = ' ' do Delete(Line, 1, 1);
    if DosListing and (i = 2) then break;
  end;
  Result := Line;
end;

procedure TMainForm.DirectoryListBoxDblClick(Sender: TObject);
Var
  Name, Line: String;
  IsDirectory: Boolean;
begin
  if not IdFTP1.Connected then exit;
  Line := DirectoryListBox.Items[DirectoryListBox.ItemIndex];
  Name := GetNameFromDirLine(Line, IsDirectory);
  if IsDirectory then begin
    // Change directory
    SetFunctionButtons(false);
    ChageDir(Name);
    SetFunctionButtons(true);
  end
  else begin
    try
      SaveDialog1.FileName := Name;
      if SaveDialog1.Execute then begin
        SetFunctionButtons(false);
        IdFTP1.TransferType := ftBinary;
        BytesToTransfer := IdFTP1.Size(Name);
        IdFTP1.Get(Name, SaveDialog1.FileName, true);
      end;
    finally
      SetFunctionButtons(true);
    end;
  end;
end;

procedure TMainForm.DeleteButtonClick(Sender: TObject);
Var
  Name, Line: String;
  IsDirectory: Boolean;
begin
  if not IdFTP1.Connected then exit;
  Line := DirectoryListBox.Items[DirectoryListBox.ItemIndex];
  Name := GetNameFromDirLine(Line, IsDirectory);
  if IsDirectory then try
    SetFunctionButtons(false);
    idftp1.RemoveDir(Name);
    ChageDir(idftp1.RetrieveCurrentDir);
  finally
  end
  else
  try
    SetFunctionButtons(false);
    idftp1.Delete(Name);
    ChageDir(idftp1.RetrieveCurrentDir);
  finally
  end;
end;

procedure TMainForm.IdFTP1Disconnected(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Disconnected.';
end;

procedure TMainForm.IdFTP1Work(Sender: TComponent; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
Var
  S: String;
begin
  if BytesToTransfer > 0 then S := ' from ' + IntToStr(BytesToTransfer)
  else S := '.';

  case AWorkMode of
    wmRead: StatusBar1.SimpleText := 'Dowloaded ' + IntToStr(AWorkCount) + ' bytes' + S;
    wmWrite: StatusBar1.SimpleText := 'Uploaded ' + IntToStr(AWorkCount) + ' bytes' + S;
  end;
  Application.ProcessMessages;
  if AbortTransfer then IdFTP1.Abort;
  AbortTransfer := false;
end;

procedure TMainForm.IdFTP1WorkEnd(Sender: TComponent; AWorkMode: TWorkMode);
begin
  AbortButton.Visible := false;
  StatusBar1.SimpleText := 'Transfer complete.';
  BytesToTransfer := 0;
  TransferrignData := false;
end;

procedure TMainForm.IdFTP1WorkBegin(Sender: TComponent; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  TransferrignData := true;
  AbortButton.Visible := true;
  AbortTransfer := false;
end;

procedure TMainForm.AbortButtonClick(Sender: TObject);
begin
  AbortTransfer := true;
end;

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
  if not IdFTP1.Connected then exit;
  try
    ChageDir('..');
  finally end;
end;

procedure TMainForm.IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
  const asStatusText: String);
begin
  DebugListBox.ItemIndex := DebugListBox.Items.Add(asStatusText);
  StatusBar1.SimpleText := asStatusText;
end;

procedure TMainForm.TraceCheckBoxClick(Sender: TObject);
begin
  IdLogDebug1.Active := TraceCheckBox.Checked;
  DebugListBox.Visible := TraceCheckBox.Checked;
  if DebugListBox.Visible then Splitter1.Top := DebugListBox.Top + 5;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetFunctionButtons(false);
  IdLogDebug1.Active := true;
end;

procedure TMainForm.DirectoryListBoxClick(Sender: TObject);
Var
  Line: String;
  IsDirectory: Boolean;
begin
  if not IdFTP1.Connected then exit;
  Line := DirectoryListBox.Items[DirectoryListBox.ItemIndex];
  GetNameFromDirLine(Line, IsDirectory);
  if IsDirectory then DownloadButton.Caption := 'Change dir'
  else DownloadButton.Caption := 'Download';
end;

end.
