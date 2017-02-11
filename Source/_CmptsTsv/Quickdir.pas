unit Quickdir;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, inifiles;

type
  TfrmQuickDirs = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    edtDescription: TEdit;
    edtPath: TEdit;
    lstbDirectories: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn2: TBitBtn;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstbDirectoriesClick(Sender: TObject);
    procedure edtDescriptionChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure edtPathChange(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
      Updating : Boolean;
    procedure UpdateEditBoxes;
    procedure SaveQuickDirs;
  public
    { Public declarations }
    strlDirectories : TStringList;
  end;

var
  frmQuickDirs: TfrmQuickDirs;

implementation

uses SysUtils, Dialogs;

{$R *.DFM}

procedure TfrmQuickDirs.UpdateEditBoxes;
begin
  Updating := True;
  with lstbDirectories do
  begin
    if Items.Count > 0 then
      begin
        edtDescription.Text := lstbDirectories.Items[lstbDirectories.ItemIndex];
        edtPath.Text := strlDirectories[lstbDirectories.ItemIndex];;
      end { if }
    else
      begin
        edtDescription.Text := '<emtpy>';
        edtPath.Text := '<emtpy>';
        edtDescription.ReadOnly := True;
        edtPath.ReadOnly := True;
      end { if }
  end; { with }
  Updating := False;
end;

procedure TfrmQuickDirs.SaveQuickDirs;
var
  IniFile : TIniFile;
  i : Integer;
begin
  IniFile := TIniFile.Create('Pictedit.ini');
  with IniFile do
  try
    WriteInteger('General', 'QuickDirCount', strlDirectories.Count);
    EraseSection('Long names');
    EraseSection('Path');
    for i := 1 to strlDirectories.Count do
    begin
      WriteString('Long names', 'Directory' + IntToStr(i),
        lstbDirectories.Items[Pred(i)]);
      WriteString('Path', 'Directory' + IntToStr(i),
        strlDirectories[Pred(i)]);
    end; { for }
  finally
    IniFile.Free;
  end; { finally }
end;

procedure TfrmQuickDirs.FormShow(Sender: TObject);
begin
  lstbDirectories.ItemIndex := 0;
  UpdateEditBoxes;
end;

procedure TfrmQuickDirs.FormCreate(Sender: TObject);
begin
  strlDirectories := TStringList.Create;
end;

procedure TfrmQuickDirs.FormDestroy(Sender: TObject);
begin
  strlDirectories.Free;
end;

procedure TfrmQuickDirs.lstbDirectoriesClick(Sender: TObject);
begin
  UpdateEditBoxes;
end;

procedure TfrmQuickDirs.edtDescriptionChange(Sender: TObject);
var
  OldItemIndex : Integer;
begin
  if not Updating then
    with lstbDirectories do
    begin
      OldItemIndex := ItemIndex;
      Items[ItemIndex] := edtDescription.Text;
      ItemIndex := OldItemIndex;
    end; { with }
end;

procedure TfrmQuickDirs.OKBtnClick(Sender: TObject);
begin
  SaveQuickDirs;
end;

procedure TfrmQuickDirs.BitBtn2Click(Sender: TObject);
var
  OldItemIndex : Integer;
begin
  if lstbDirectories.Items.Count = 0 then
    Exit;
  if MessageDlg('Are you sure you want to delete the selected item?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  with lstbDirectories do
  begin
    strlDirectories.Delete(ItemIndex);
    OldItemIndex := ItemIndex;
    Items.Delete(ItemIndex);
    if OldItemIndex = Items.Count then
      ItemIndex := Pred(Items.Count)
    else
      ItemIndex := OldItemIndex;
    UpdateEditBoxes;
  end; { with }
end;

procedure TfrmQuickDirs.edtPathChange(Sender: TObject);
begin
  if not Updating then
    strlDirectories[lstbDirectories.ItemIndex] := edtPath.Text;
end;

procedure TfrmQuickDirs.SpeedButton2Click(Sender: TObject);
var
  OldItemIndex : Integer;
begin
  with lstbDirectories do
  begin
    if (ItemIndex > 0) then
    begin
      strlDirectories.Exchange(ItemIndex, Pred(ItemIndex));
      OldItemIndex := ItemIndex;
      Items.Exchange(ItemIndex, Pred(ItemIndex));
      ItemIndex := OldItemIndex - 1;
    end; { if }
  end; { with }
end;

procedure TfrmQuickDirs.SpeedButton3Click(Sender: TObject);
var
  OldItemIndex : Integer;
begin
  with lstbDirectories do
  begin
    if (ItemIndex >= 0) and (ItemIndex < Pred(Items.Count)) then
    begin
      strlDirectories.Exchange(ItemIndex, Succ(ItemIndex));
      OldItemIndex := ItemIndex;
      Items.Exchange(ItemIndex, Succ(ItemIndex));
      ItemIndex := OldItemIndex + 1;
    end; { if }
  end; { with }
end;

end.
