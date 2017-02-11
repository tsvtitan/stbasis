unit RasDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Ras, RasUtils, RasHelperClasses;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    PhonebookListView: TListView;
    PhonebookLabel: TLabel;
    PhonebookBtn: TButton;
    PBRefreshBtn: TButton;
    PBAddBtn: TButton;
    PBEditBtn: TButton;
    PBDeleteBtn: TButton;
    PBRenameBtn: TButton;
    PhonebookOpenDialog: TOpenDialog;
    ConnectionsListView: TListView;
    CORefreshBtn: TButton;
    COHangupBtn: TButton;
    COAutoRefreshCheckBox: TCheckBox;
    AutoRefreshTimer: TTimer;
    DialerMessagesMemo: TMemo;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PhoneNumberEdit: TEdit;
    Label3: TLabel;
    DIDialBtn: TButton;
    PBDialBtn: TButton;
    DIHangupBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PBRefreshBtnClick(Sender: TObject);
    procedure PBAddBtnClick(Sender: TObject);
    procedure PBEditBtnClick(Sender: TObject);
    procedure PBDeleteBtnClick(Sender: TObject);
    procedure PhonebookBtnClick(Sender: TObject);
    procedure CORefreshBtnClick(Sender: TObject);
    procedure COHangupBtnClick(Sender: TObject);
    procedure PBRenameBtnClick(Sender: TObject);
    procedure COAutoRefreshCheckBoxClick(Sender: TObject);
    procedure PBDialBtnClick(Sender: TObject);
    procedure DIDialBtnClick(Sender: TObject);
    procedure DIHangupBtnClick(Sender: TObject);
  private
    procedure RasPhonebookChange(Sender: TObject);
    procedure RasConnectionsListChange(Sender: TObject);
    procedure RasDialerNotify(Sender: TObject; State: TRasConnState; ErrorCode: DWORD);
  public
    RasPhonebook: TRasPhonebook;
    RasConnectionsList: TRasConnectionsList;
    RasDialer: TRasDialer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  RasPhonebook := TRasPhonebook.Create;
  RasPhonebook.OnRefresh := RasPhonebookChange;
  RasConnectionsList := TRasConnectionsList.Create;
  RasConnectionsList.OnRefresh := RasConnectionsListChange;
  RasPhonebook.Refresh;
  PhonebookBtn.Enabled := (Win32Platform = VER_PLATFORM_WIN32_NT);
  RasDialer := TRasDialer.Create;
  RasDialer.OnNotify := RasDialerNotify;
  PhonebookBtnClick(nil);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  RasConnectionsList.Free;
  RasPhonebook.Free;
  RasDialer.Free;
end;

procedure TMainForm.RasPhonebookChange(Sender: TObject);
var
  I: Integer;
begin
  PhonebookLabel.Caption := RasPhonebook.PhoneBook;
  with PhonebookListView.Items do
  begin
    BeginUpdate;
    try
      Clear;
      for I := 0 to RasPhonebook.Count - 1 do
        with Add, RasPhonebook[I] do
        begin
          Caption := Name;
          SubItems.Add(PhoneNumber);
          SubItems.Add(UserName);
          if PasswordStored then
            SubItems.Add(Password);
        end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TMainForm.PBRefreshBtnClick(Sender: TObject);
begin
  RasPhonebook.Refresh;
end;

procedure TMainForm.PBAddBtnClick(Sender: TObject);
begin
  RasPhonebook.CreateEntryInteractive(Self.Handle);
end;

procedure TMainForm.PBEditBtnClick(Sender: TObject);
begin
  if PhonebookListView.Selected <> nil then
    RasPhonebook[PhonebookListView.Selected.Index].EditEntry(Application.Handle);
end;

procedure TMainForm.PBDeleteBtnClick(Sender: TObject);
begin
  with PhonebookListView do
    if (Selected <> nil) and (MessageBox(Handle, 'Delete entry ?', PChar(Caption),
      MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2) = ID_YES) then
        RasPhonebook[Selected.Index].DeleteEntry;
end;

procedure TMainForm.PBRenameBtnClick(Sender: TObject);
var
  NewName: String;
begin
  NewName := '';
  with PhonebookListView do
    if (Selected <> nil) and InputQuery(Caption, 'Enter a new name', NewName) then
      RasPhonebook[Selected.Index].RenameEntry(NewName);
end;

procedure TMainForm.PhonebookBtnClick(Sender: TObject);
begin
  with PhonebookOpenDialog do
  begin
    FileName := RasPhonebook.PhoneBook;
    if Execute then begin
      RasPhonebook.PhoneBook := FileName;
    end;  
  end;
end;

procedure TMainForm.RasConnectionsListChange(Sender: TObject);
var
  I: Integer;
  SelectedConnection: String;
begin
  with ConnectionsListView do
  begin
    Items.BeginUpdate;
    try
      if Selected <> nil then
        SelectedConnection := Selected.Caption
      else
        SelectedConnection := ''; 
      Items.Clear;
      for I := 0 to RasConnectionsList.Count - 1 do
        with Items.Add, RasConnectionsList[I] do
        begin
          Caption := Name;
          SubItems.Add(DeviceName);
          SubItems.Add(ConnStatusStr);
        end;
      Selected := FindCaption(0, SelectedConnection, False, True, False);
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TMainForm.CORefreshBtnClick(Sender: TObject);
begin
  RasConnectionsList.Refresh;
end;

procedure TMainForm.COHangupBtnClick(Sender: TObject);
begin
  with ConnectionsListView do
    if (Selected <> nil) then
      RasConnectionsList[Selected.Index].HangUp;
end;

procedure TMainForm.COAutoRefreshCheckBoxClick(Sender: TObject);
begin
  AutoRefreshTimer.Enabled := COAutoRefreshCheckBox.Enabled;
end;

procedure TMainForm.RasDialerNotify(Sender: TObject; State: TRasConnState;
  ErrorCode: DWORD);
begin
  with DialerMessagesMemo do
  begin
    Lines.Add(RasConnStatusString(State, ErrorCode));
    SelStart := GetTextLen - 1;
  end;  
end;

procedure TMainForm.PBDialBtnClick(Sender: TObject);
begin
  with PhonebookListView do
    if (Selected <> nil) then
    begin
      RasDialer.Assign(RasPhonebook[Selected.Index]);
      UserNameEdit.Text := RasDialer.UserName;
      PasswordEdit.Text := RasDialer.Password;
      PhoneNumberEdit.Text := RasDialer.PhoneNumber;
      PageControl1.ActivePage := TabSheet3;
    end;
end;

procedure TMainForm.DIDialBtnClick(Sender: TObject);
begin
  DialerMessagesMemo.Lines.Clear;
  RasDialer.UserName := UserNameEdit.Text;
  RasDialer.Password := PasswordEdit.Text;
  RasDialer.PhoneNumber := PhoneNumberEdit.Text;
  RasDialer.Dial;
end;

procedure TMainForm.DIHangupBtnClick(Sender: TObject);
begin
  RasDialer.HangUp;
end;

end.
