unit ImageWin;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
  FileCtrl, StdCtrls, ExtCtrls, Buttons, Spin, Dialogs;

type
  TImageForm = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    PathLabel: TLabel;
    FileEdit: TEdit;
    UpDownGroup: TGroupBox;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    DisabledGrp: TGroupBox;
    SpeedButton2: TSpeedButton;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    FileListBox1: TFileListBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    ViewBtn: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    FilterComboBox1: TFilterComboBox;
    CheckBox1: TCheckBox;
    StretchCheck: TCheckBox;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    cmbQuickDirs: TComboBox;
    SpeedButton3: TSpeedButton;
    Label3: TLabel;
    BitBtn5: TBitBtn;
    SaveDialog1: TSaveDialog;
    BitBtn6: TBitBtn;
    WaitLabel: TLabel;
    procedure FileListBox1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure ViewAsGlyph(const FileExt: string);
    procedure CheckBox1Click(Sender: TObject);
    procedure StretchCheckClick(Sender: TObject);
    procedure FileEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbQuickDirsChange(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
      DefaultDir : string;
      strlDirectories : TStringList;
    procedure LoadQuickDirs;
  end;

var
  ImageForm: TImageForm;

implementation

uses SysUtils, ViewWin, Quickdir;

{$R *.DFM}

const
  DefaultAppName = 'Default application directory';

procedure TImageForm.LoadQuickDirs;
var
  IniFile : TIniFile;
  QuickDirCount, i, LastDirIndex : Integer;
begin
  IniFile := TIniFile.Create('Pictedit.ini');
  with IniFile do
  try
    cmbQuickDirs.Clear;
    cmbQuickDirs.Items.Add(DefaultAppName);
    strlDirectories.Clear;
    strlDirectories.Add(DefaultDir);
    QuickDirCount := ReadInteger('General', 'QuickDirCount', 0);
    for i := 1 to QuickDirCount do
    begin
      cmbQuickDirs.Items.Add(ReadString('Long names', 'Directory' + IntToStr(i),
        'No name available'));
      strlDirectories.Add(ReadString('Path', 'Directory' + IntToStr(i),
        DefaultDir));
    end; { for }
    LastDirIndex := ReadInteger('General', 'LastDirIndex', 0);
    cmbQuickDirs.ItemIndex := LastDirIndex;
    cmbQuickDirsChange(Self);
    CheckBox1.Checked := ReadBool('General', 'ViewAsGlyph', True);
    StretchCheck.Checked := ReadBool('General', 'Stretch', False);
  finally
    IniFile.Free;
  end; { finally }
end;

procedure TImageForm.FileListBox1Click(Sender: TObject);
var
  FileExt: string[4];
begin
  FileExt := UpperCase(ExtractFileExt(FileListBox1.Filename));
  if (FileExt = '.BMP') or (FileExt = '.ICO') or (FileExt = '.WMF') then
  begin
    Image1.Picture.LoadFromFile(FileListBox1.Filename);
    Label1.Caption := ExtractFilename(FileListBox1.Filename);
    if (FileExt = '.BMP') then
      begin
        Label3.Caption := Format('(%d x %d)', [Image1.Picture.Width,
          Image1.Picture.Height]);
        ViewForm.Image1.Picture := Image1.Picture;
        ViewAsGlyph(FileExt);
      end { if }
    else
      Label3.Caption := '(n/a)';
    if FileExt = '.ICO' then Icon := Image1.Picture.Icon;
    if FileExt = '.WMF' then
      ViewForm.Image1.Picture.Metafile := Image1.Picture.Metafile;
  end;
end;

procedure TImageForm.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    ViewAsGlyph(UpperCase(ExtractFileExt(FileListBox1.Filename)))
  else
    begin
      DeleteObject(BitBtn1.Glyph.ReleaseHandle);
      BitBtn1.Glyph := nil;
      DeleteObject(BitBtn2.Glyph.ReleaseHandle);
      BitBtn2.Glyph := nil;
      DeleteObject(SpeedButton1.Glyph.ReleaseHandle);
      SpeedButton1.Glyph := nil;
      DeleteObject(SpeedButton2.Glyph.ReleaseHandle);
      SpeedButton2.Glyph := nil;
    end; { else }
end;

procedure TImageForm.ViewAsGlyph(const FileExt: string);
begin
  if CheckBox1.Checked and (FileExt = '.BMP') then
  begin
    SpeedButton1.Glyph := Image1.Picture.Bitmap;
    SpeedButton2.Glyph := Image1.Picture.Bitmap;
    SpinEdit1.Value := SpeedButton1.NumGlyphs;
    BitBtn1.Glyph := Image1.Picture.Bitmap;
    BitBtn2.Glyph := Image1.Picture.Bitmap;
  end;
end;

procedure TImageForm.ViewBtnClick(Sender: TObject);
begin
  ViewForm.HorzScrollBar.Range := Image1.Picture.Width;
  ViewForm.VertScrollBar.Range := Image1.Picture.Height;
  ViewForm.Caption := Label1.Caption;
  ViewForm.Show;
end;

procedure TImageForm.SpinEdit1Change(Sender: TObject);
begin
  SpeedButton1.NumGlyphs := SpinEdit1.Value;
  SpeedButton2.NumGlyphs := SpinEdit1.Value;
  BitBtn1.NumGlyphs := SpinEdit1.Value;
  BitBtn2.NumGlyphs := SpinEdit1.Value;
end;

procedure TImageForm.StretchCheckClick(Sender: TObject);
begin
  Image1.Stretch := StretchCheck.Checked;
end;

procedure TImageForm.FileEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FileListBox1.ApplyFilePath(FileEdit.Text);
    Key := #0;
  end;
end;

procedure TImageForm.FormShow(Sender: TObject);
begin
  GetDir(0, DefaultDir);
  LoadQuickDirs;
end;

procedure TImageForm.FormCreate(Sender: TObject);
begin
  strlDirectories := TStringList.Create;
end;

procedure TImageForm.FormDestroy(Sender: TObject);
begin
  ChDir(DefaultDir);
  strlDirectories.Free;
end;

procedure TImageForm.cmbQuickDirsChange(Sender: TObject);
begin
  PathLabel.Visible := False;
  WaitLabel.Visible := True;
  Application.ProcessMessages;
  try
    if strlDirectories[cmbQuickDirs.ItemIndex] = '' then
      raise Exception.Create('Invalid directory');
    DirectoryListBox1.Directory := strlDirectories[cmbQuickDirs.ItemIndex];
  except
    MessageDlg('The entry "' + cmbQuickDirs.Items[cmbQuickDirs.ItemIndex] +
      '" does not point to a valid directory.   Please verify.', mtError,
      [mbOk], 0);
  end; { except }
  Application.ProcessMessages;
  WaitLabel.Visible := False;
  PathLabel.Visible := True;
end;

procedure TImageForm.BitBtn5Click(Sender: TObject);
begin
  if Label1.Caption <> '' then
    SaveDialog1.Filename := Label1.Caption;
  if SaveDialog1.Execute then
    Image1.Picture.SaveToFile(SaveDialog1.Filename)
  else
    begin
      ModalResult := mrNone;
      cmbQuickDirs.SetFocus;
    end; { else }
end;

procedure TImageForm.BitBtn6Click(Sender: TObject);
var
  DirDescription : string;
  IniFile : TIniFile;
begin
  DirDescription := '';
  if InputQuery('Adding new Quick Directory', 'Enter name for Quick Directory:',
    DirDescription) then
  begin
    cmbQuickDirs.Items.Add(DirDescription);
    strlDirectories.Add(DirectoryListBox1.Directory);
    cmbQuickDirs.ItemIndex := Pred(cmbQuickDirs.Items.Count);
    IniFile := TIniFile.Create('Pictedit.ini');
    with IniFile do
    try
      WriteInteger('General', 'QuickDirCount', Pred(cmbQuickDirs.Items.Count));
      WriteString('Long names', 'Directory' +
        IntToStr(Pred(cmbQuickDirs.Items.Count)), DirDescription);
      WriteString('Path', 'Directory' +
        IntToStr(Pred(cmbQuickDirs.Items.Count)), DirectoryListBox1.Directory);
    finally
      IniFile.Free;
    end; { finally }
  end; { if }
end;

procedure TImageForm.SpeedButton3Click(Sender: TObject);
begin
  frmQuickDirs := TfrmQuickDirs.Create(Self);
  with frmQuickDirs do
  try
    lstbDirectories.Items.AddStrings(cmbQuickDirs.Items);
    lstbDirectories.Items.Delete(0);
    strlDirectories.AddStrings(Self.strlDirectories);
    strlDirectories.Delete(0);
    if (ShowModal = mrOk) then
    with Self do
    begin
      cmbQuickDirs.Items.Clear;
      cmbQuickDirs.Items.AddStrings(frmQuickDirs.lstbDirectories.Items);
      cmbQuickDirs.Items.Insert(0, DefaultAppName);
      cmbQuickDirs.ItemIndex := 0;
      strlDirectories.Clear;
      strlDirectories.AddStrings(frmQuickDirs.strlDirectories);
      strlDirectories.Insert(0, DefaultDir);
      DirectoryListBox1.Directory := DefaultDir;
    end; { with }
  finally
    frmQuickDirs.Free;
  end; { finally }
end;

procedure TImageForm.BitBtn3Click(Sender: TObject);
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create('Pictedit.ini');
  with IniFile do
  try
    WriteInteger('General', 'LastDirIndex', cmbQuickDirs.ItemIndex);
    WriteBool('General', 'ViewAsGlyph', CheckBox1.Checked);
    WriteBool('General', 'Stretch', StretchCheck.Checked);
  finally
    IniFile.Free;
  end; { finally }
end;

end.
