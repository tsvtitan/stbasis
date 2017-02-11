unit Main;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Grids, Menus, ComCtrls, IdSMTP, IdComponent, IdTCPConnection,
   IdTCPClient, IdMessageClient, IdPOP3, IdBaseComponent, IdMessage,
   StdCtrls, ExtCtrls, ToolWin, ActnList, ImgList, Buttons,
   IdAntiFreezeBase, IdAntiFreeze, IdIMAP4, IdMailBox, FileCtrl;


const
  stPOP3 = 0;
  stIMAP4 = 1;

type
   TfrmMain = class(TForm)
    aclMain: TActionList;
    mniActions: TMenuItem;
    bbtSaveAttachment: TBitBtn;
    lblMsgCc: TLabel;
    actCheckMail: TAction;
    mniCheckMail: TMenuItem;
    lblMsgDate: TLabel;
    actDeleteMsg: TAction;
    mniDeleteMsg: TMenuItem;
    actDisconnect: TAction;
    mniDisconnect: TMenuItem;
    mniExit: TMenuItem;
    lblMsgFrom: TLabel;
    AntiFreeze: TIdAntiFreeze;
    imlToolBar: TImageList;
    lblAttachment: TLabel;
    lblReceipt: TLabel;
    lblOrganization: TLabel;
    lblFrom: TLabel;
    lblTo: TLabel;
    lblCc: TLabel;
    lblSubject: TLabel;
    lblDate: TLabel;
    lblPriority: TLabel;
    lsvHeaders: TListView;
      lvMessageParts: TListView;
    mmnMain: TMainMenu;
    memMsgBody: TMemo;
      Msg: TIdMessage;
    mniSep1: TMenuItem;
    mniSep2: TMenuItem;
    lblMsgOrganization: TLabel;
    pnlMsgHeader: TPanel;
      pnlBottom: TPanel;
    pnlMsgBody: TPanel;
      pnlMain: TPanel;
      pnlAttachments: TPanel;
      pnlServerName: TPanel;
      pnlTop: TPanel;
      POP: TIdPOP3;
    lblMsgPriority: TLabel;
    actPurgeMarkedMsgs: TAction;
    mniPurgeMarkedMsgs: TMenuItem;
    lblMsgReceipt: TLabel;
    lblMsgRecipients: TLabel;
    actRetrieveMsg: TAction;
    mniRetrieveMsg: TMenuItem;
    svdAttachment: TSaveDialog;
    actSend: TAction;
    mniSend: TMenuItem;
    actSetup: TAction;
    mniSetup: TMenuItem;
    splMain: TSplitter;
    stbMain: TStatusBar;
    stbMailBoxes: TStatusBar;
    lblMsgSubject: TLabel;
    tbtConnect: TToolButton;
    tbtSep1: TToolButton;
    tbtDisconnect: TToolButton;
    tbtRetrieveMsg: TToolButton;
    tbtMarkDeleteMsg: TToolButton;
    tbtPurgeMarkedMsgs: TToolButton;
    tbtComposeMsg: TToolButton;
    tbtSetup: TToolButton;
    tbtSep4: TToolButton;
    tbtSep5: TToolButton;
    mniSelectForDeletetion: TMenuItem;
    tbtRetrieveHeaders: TToolButton;
    actRetrieveHeaders: TAction;
    pnlMailBox: TPanel;
    trvMailBoxes: TTreeView;
    lblMailBoxName: TLabel;
    pmnMailBox: TPopupMenu;
    mniNewMailBox: TMenuItem;
    mniRenameMailBox: TMenuItem;
    mniDeleteMailBox: TMenuItem;
    IMAP: TIdIMAP4;
    tbrMain: TToolBar;
    actSelectMailBox: TAction;
    mniSelectMailBox: TMenuItem;
    actDeleteMailBox: TAction;
    actRenameMailBox: TAction;
    actNewMailBox: TAction;
      function FindAttachment(stFilename: string): integer;
      procedure bbtSaveAttachmentClick(Sender: TObject);
      procedure actCheckMailExecute(Sender: TObject);
      procedure actDeleteMsgExecute(Sender: TObject);
      procedure actDisconnectExecute(Sender: TObject);
      procedure mniExitClick(Sender: TObject);
      procedure FormActivate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormCreate(Sender: TObject);
      procedure lvMessagePartsClick(Sender: TObject);
      procedure pnlServerNameClick(Sender: TObject);
      procedure actPurgeMarkedMsgsExecute(Sender: TObject);
      procedure actRetrieveMsgExecute(Sender: TObject);
      procedure actSendExecute(Sender: TObject);
      procedure actSetupExecute(Sender: TObject);
      procedure ShowBusy(blBusy: boolean);
      procedure ShowFileStatus;
      procedure ShowStatus(stStatus: string);
    procedure lsvHeadersDblClick(Sender: TObject);
    procedure mniSelectForDeletetionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actRetrieveHeadersExecute(Sender: TObject);
    procedure actSelectMailBoxExecute(Sender: TObject);
    procedure trvMailBoxesDblClick(Sender: TObject);
    procedure actDeleteMailBoxExecute(Sender: TObject);
    procedure actRenameMailBoxExecute(Sender: TObject);
    procedure actNewMailBoxExecute(Sender: TObject);
   private
    { Private declarations }
      procedure RetrieveIncomingHeaders(inMsgCount: Integer);
      procedure ResetHeadersGrid;
      procedure ToggleStatus(const Status: Boolean);
      procedure ReadConfiguration;
      procedure RefreshMailBoxTree;
   public
    { Public declarations }
    FAttachPath: string;
    FMsgCount, FMailBoxSize: integer;
   end;

{LoadNode is a recursive routine called by LoadNodes which
creates a node or returns the reference to an existing node}
procedure LoadTreeViewNodes(tv: TTreeView; lst: TStrings; sep: Char);

function GetTreeViewPath(MainNode: TTreeNode; SepChar: Char) : String;

var
   frmMain: TfrmMain;
   IncomingServerType: Integer;
   IncomingServerName: String;
   IncomingServerPort: Integer;
   IncomingServerUser: String;
   IncomingServerPassword: String;
   OutgoingServerName: String;
   OutgoingServerPort: Integer;
   OutgoingServerUser: String;
   OutgoingServerPassword: String;
   OutgoingAuthType: Integer;
   UserEmail: String;

implementation

uses Setup, MsgEditor, inifiles;

{$R *.DFM}

procedure TfrmMain.ShowBusy(blBusy: boolean);
begin
   if blBusy then
      screen.cursor := crHourglass
   else
      screen.cursor := crDefault;
end; (*  *)

procedure TfrmMain.ShowStatus(stStatus: string);
begin
   stbMain.Panels[1].text := stStatus;
   stbMain.Refresh;
end; (*  *)

procedure TfrmMain.ShowFileStatus;
begin
   stbMailBoxes.Panels[0].text := IntToStr(FMsgCount);
   stbMailBoxes.Panels[1].text := format('Mail takes up %dK on the server', [FMailBoxSize]);
   stbMain.Refresh;
end; (*  *)

function TfrmMain.FindAttachment(stFilename: string): integer;
var
   intIndex: Integer;
   found: boolean;
begin
   intIndex := -1;
   result := -1;
   if (Msg.MessageParts.Count < 1) then exit; //no attachments (or anything else)
   found := false;
   stFilename := uppercase(stFilename);
   repeat
      inc(intIndex);
      if (Msg.MessageParts.Items[intIndex] is TIdAttachment) then
         begin //general attachment
            if stFilename = uppercase(TIdAttachment(Msg.MessageParts.Items[intIndex]).Filename) then
               found := true;
         end;
   until found or (intIndex > Pred(Msg.MessageParts.Count));
   if found then
      result := intIndex
   else
      result := -1;
end; (*  *)

procedure TfrmMain.bbtSaveAttachmentClick(Sender: TObject);
var
   intIndex: integer;
   fname: string;
   intMSGIndex: integer;
begin
  // Find selected
   for intIndex := 0 to lvMessageParts.Items.Count - 1 do
      if lvMessageParts.Items[intIndex].Selected then
         begin
            //now find which TIdAttachment it is in MSG
            intMSGIndex := FindAttachment(lvMessageParts.Items[intIndex].caption);
            if intMSGIndex > 0 then
               begin
                  fname := FAttachPath + TIdAttachment(Msg.MessageParts.Items[intMSGIndex]).filename;
                  svdAttachment.FileName := fname;
                  if svdAttachment.Execute then
                     begin
                        Showbusy(true);
                        TIdAttachment(Msg.MessageParts.Items[intMSGIndex]).SaveToFile(svdAttachment.FileName);
                        Showbusy(false);
                     end;
               end;
         end;
end;

procedure TfrmMain.RetrieveIncomingHeaders(inMsgCount: Integer);
var
   stTemp: string;
   intIndex: integer;
   itm: TListItem;
begin
   stTemp := stbMain.Panels[1].text;
   lsvHeaders.Items.Clear;
   case IncomingServerType of
     stPOP3:
     begin
          for intIndex := 1 to inMsgCount do
          begin
               // Clear the message properties
               ShowStatus(format('Messsage %d of %d', [intIndex, inMsgCount]));
               Application.ProcessMessages;
               Msg.Clear;
               POP.RetrieveHeader(intIndex, Msg);
               // Add info to ListView
               itm := lsvHeaders.Items.Add;
               itm.ImageIndex := 5;
               itm.Caption := Msg.Subject;
               itm.SubItems.Add(Msg.From.Text);
               itm.SubItems.Add(DateToStr(Msg.Date));
               itm.SubItems.Add(IntToStr(POP.RetrieveMsgSize(intIndex)));
               itm.SubItems.Add('n/a');
               // itm.SubItems.Add(POP.RetrieveUIDL(intIndex));
          end;
     end;
     stIMAP4:
     begin
          for intIndex := 1 to inMsgCount do
          begin
               // Clear the message properties
               ShowStatus(format('Messsage %d of %d', [intIndex, inMsgCount]));
               Application.ProcessMessages;
               Msg.Clear;
               IMAP.RetrieveHeader(intIndex, Msg);
               // Add info to ListView
               itm := lsvHeaders.Items.Add;
               itm.ImageIndex := 5;
               itm.Caption := Msg.Subject;
               itm.SubItems.Add(Msg.From.Text);
               itm.SubItems.Add(DateToStr(Msg.Date));
               itm.SubItems.Add(IntToStr(IMAP.RetrieveMsgSize(intIndex)));
               itm.SubItems.Add('n/a');
          end;
     end;
   end;
   ShowStatus(stTemp);
end;

procedure TfrmMain.ResetHeadersGrid;
begin
   lsvHeaders.Items.Clear;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  {Set up authentication dialog-box}
//  frmSMTPAuthentication.cboAuthType.ItemIndex := Ord( frmMessageEditor.SMTP.AuthenticationType );
//  frmSMTPAuthentication.edtAccount.Text := fmSetup.Account.Text;
//  frmSMTPAuthentication.edtPassword.Text := fmSetup.Password.Text;
//  frmSMTPAuthentication.EnableControls;

   ResetHeadersGrid;
   ToggleStatus(False);
end;

procedure TfrmMain.ToggleStatus(const Status: Boolean);
begin
   actCheckMail.Enabled := not Status;
   actRetrieveMsg.Enabled := Status;
   actDeleteMsg.Enabled := Status;
   actPurgeMarkedMsgs.Enabled := Status;
   actDisconnect.Enabled := Status;
   if Status then
      ShowStatus('Connected')
   else
      ShowStatus('Not connected');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   actDisconnect.Execute;
end;

procedure TfrmMain.actCheckMailExecute(Sender: TObject);
var MailBoxSl : TStringList;
begin
   Showbusy(true);
   ShowStatus('Connecting....');
   case IncomingServerType of
     stPOP3:
     begin
          if POP.Connected then
          begin
               POP.Disconnect;
          end;
          POP.Host := IncomingServerName;
          POP.Port := IncomingServerPort;
          POP.Username := IncomingServerUser;
          POP.Password := IncomingServerPassword;
          POP.Connect ( 5000 );
          ToggleStatus(True);
          FMsgCount := POP.CheckMessages;
          FMailBoxSize := POP.RetrieveMailBoxSize div 1024;
          ShowFileStatus;
          if FMsgCount > 0 then
          begin
               //ShowFileStatus;
               //RetrieveIncomingHeaders(FMsgCount);
          end
          else
          begin
               ShowStatus('No messages on server');
          end;
     end;
     stIMAP4:
     begin
          if IMAP.Connected then
          begin
               IMAP.Disconnect;
          end;
          IMAP.Host := IncomingServerName;
          IMAP.Port := IncomingServerPort;
          IMAP.Username := IncomingServerUser;
          IMAP.Password := IncomingServerPassword;
          IMAP.Connect ( 5000 );
          ToggleStatus(True);
          MailBoxSl := TStringList.Create;
          try
             IMAP.ListMailBoxes ( MailBoxSl );
             LoadTreeViewNodes ( trvMailBoxes, MailBoxSl, '/' );
          finally
                 MailBoxSl.Free;
          end;
          IMAP.SelectMailBox ( 'INBOX' );
          lblMailBoxName.Caption := 'Selected MailBox: INBOX';
          FMsgCount := IMAP.MailBox.TotalMsgs;
          FMailBoxSize := IMAP.RetrieveMailBoxSize div 1024;
          ShowFileStatus;
          if FMsgCount = 0 then
          begin
               ShowStatus('No messages in mailbox');
          end;
     end;
   end;
   Showbusy(false);
end;

procedure TfrmMain.actRetrieveMsgExecute(Sender: TObject);
var
   stTemp: string;
   intIndex: Integer;
   li: TListItem;
begin
   stTemp := stbMain.Panels[1].text;
   if lsvHeaders.Selected = nil then
      begin
         Exit;
      end;
   //initialise
   Showbusy(true);
   Msg.Clear;
   memMsgBody.Clear;
   lvMessageParts.Items.Clear;
   lblMsgFrom.Caption := '';
   lblMsgCc.Caption := '';
   lblMsgSubject.Caption := '';
   lblMsgDate.Caption := '';
   lblMsgReceipt.Caption := '';
   lblMsgOrganization.Caption := '';
   lblMsgPriority.Caption := '';
   pnlAttachments.visible := false;

   //get message and put into MSG
   ShowStatus('Retrieving message "' + lsvHeaders.Selected.SubItems.Strings[3] + '"');
   if ( IncomingServerType = stPOP3 ) then
      POP.Retrieve(lsvHeaders.Selected.Index + 1, Msg)
   else
       IMAP.Retrieve(lsvHeaders.Selected.Index + 1, Msg);
   stbMain.Panels[0].text := lsvHeaders.Selected.SubItems.Strings[3];

   //Setup fields on screen from MSG
   lblMsgFrom.Caption := Msg.From.Text;
   lblMsgRecipients.Caption := Msg.Recipients.EmailAddresses;
   lblMsgCc.Caption := Msg.CCList.EMailAddresses;
   lblMsgSubject.Caption := Msg.Subject;
   lblMsgDate.Caption := FormatDateTime('dd mmm yyyy hh:mm:ss', Msg.Date);
   lblMsgReceipt.Caption := Msg.ReceiptRecipient.Text;
   lblMsgOrganization.Caption := Msg.Organization;
   lblMsgPriority.Caption := IntToStr(Ord(Msg.Priority) + 1);

   //Setup attachments list
   ShowStatus('Decoding attachments (' + IntToStr(Msg.MessageParts.Count) + ')');
   for intIndex := 0 to Pred(Msg.MessageParts.Count) do
      begin
         if (Msg.MessageParts.Items[intIndex] is TIdAttachment) then
            begin //general attachment
               pnlAttachments.visible := true;
               li := lvMessageParts.Items.Add;
               li.ImageIndex := 8;
               li.Caption := TIdAttachment(Msg.MessageParts.Items[intIndex]).Filename;
    //         li.SubItems.Add(TIdAttachment(Msg.MessageParts.Items[intIndex]).ContentType);
            end
         else
            begin //body text
               if Msg.MessageParts.Items[intIndex] is TIdText then
                  begin
                     memMsgBody.Lines.Clear;
                     memMsgBody.Lines.AddStrings(TIdText(Msg.MessageParts.Items[intIndex]).Body);
                  end
            end;
      end;
   ShowStatus(stTemp);
   Showbusy(false);
end;

procedure TfrmMain.actDeleteMsgExecute(Sender: TObject);
begin
   if lsvHeaders.Selected <> nil then
      begin
         Showbusy(true);
         if ( IncomingServerType = stPOP3 ) then
            POP.Delete(lsvHeaders.Selected.Index + 1)
         else
             IMAP.DeleteMsgs([lsvHeaders.Selected.Index + 1]);
         lsvHeaders.Selected.ImageIndex := 3;
         Showbusy(false);
      end;
end;

procedure TfrmMain.actPurgeMarkedMsgsExecute(Sender: TObject);
begin
   if ( IncomingServerType = stPOP3 ) then
      POP.Disconnect
   else
   begin
        IMAP.ExpungeMailBox;
        IMAP.Disconnect;
   end;
   ToggleStatus(False);
   actCheckMailExecute(Sender);
end;

procedure TfrmMain.actDisconnectExecute(Sender: TObject);
begin
   if ( IncomingServerType = stPOP3 ) then
      if POP.Connected then
      begin
         try
            POP.Reset;
         except
            ShowStatus('Your POP server doesn''t have Reset feature');
         end;
         POP.Disconnect;
         ToggleStatus(False);
      end
   else
       if IMAP.Connected then
       begin
            IMAP.Disconnect;
            ToggleStatus(False);
       end;
end;

procedure TfrmMain.actSetupExecute(Sender: TObject);
begin
  Application.CreateForm(TfmSetup, fmSetup);
  fmSetup.ShowModal;
end;

procedure TfrmMain.actSendExecute(Sender: TObject);
begin
   frmMessageEditor.ShowModal;
end;

procedure TfrmMain.lvMessagePartsClick(Sender: TObject);
begin
  {display message parts we selected}
   if lvMessageParts.Selected <> nil then
      begin
         if lvMessageParts.Selected.Index > Msg.MessageParts.Count then
            begin
               MessageDlg('Unknown index', mtInformation, [mbOK], 0);
            end
         else
            begin
            showmessage(TIdAttachment(Msg.MessageParts.Items[lvMessageParts.Selected.Index]).Filename);
            end;
      end;
end;

procedure TfrmMain.mniExitClick(Sender: TObject);
begin
   close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // read the configuration from ini file
  ReadConfiguration;

   name := 'frmMain';

   //setup path to put attachments into
   FAttachPath := IncludeTrailingBackSlash(ExtractFileDir(Application.exename)); //starting directory
   FAttachPath := FAttachPath + 'Attach\';
   if not DirectoryExists(FAttachPath) then ForceDirectories(FAttachPath);

   FMsgCount := 0; FMailBoxSize := 0;
   Showbusy(false);
   IMAP := TIdIMAP4.Create(nil);
end;

procedure TfrmMain.pnlServerNameClick(Sender: TObject);
begin
   actSetupExecute(Sender); //show setup screen
end;

procedure TfrmMain.ReadConfiguration;
var
  MailIni: TIniFile;
begin
  MailIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Mail.ini');
  with MailIni do begin
    IncomingServerName := ReadString('Incoming', 'ServerName', 'pop3.server.com');
    IncomingServerPort := StrToInt(ReadString('Incoming', 'ServerPort', '110'));
    IncomingServerUser := ReadString('Incoming', 'ServerUser', 'your_login');
    IncomingServerPassword := ReadString('Incoming', 'ServerPassword', 'your_password');
    IncomingServerType := ReadInteger('Incoming', 'IncomingServerType', 0);

    if ( IncomingServerType = stPOP3 ) then
       frmMain.pnlMailBox.Visible := False
    else
        frmMain.pnlMailBox.Visible := True;

    OutgoingServerName := ReadString('Outgoing', 'ServerName', 'smtp.server.com');
    OutgoingServerPort := StrToInt(ReadString('Outgoing', 'ServerPort', '25'));
    OutgoingServerUser := ReadString('Outgoing', 'ServerUser', 'your_login');
    OutgoingServerPassword := ReadString('Outgoing', 'ServerPassword', 'your_password');
    OutgoingAuthType := ReadInteger('Outgoing', 'OutgoingAuthenticationType', 0);

    UserEmail := ReadString('Email', 'PersonalEmail', 'your@email.com');
  end;
  MailIni.Free;
end;

procedure TfrmMain.lsvHeadersDblClick(Sender: TObject);
begin
  actRetrieveMsgExecute(Sender);
end;

procedure TfrmMain.mniSelectForDeletetionClick(Sender: TObject);
var i : integer;
begin
     for i := 0 to lsvHeaders.Items.Count - 1 do
     begin
          Showbusy(true);
          if ( IncomingServerType = stPOP3 ) then
             POP.Delete(i+1)
          else
              IMAP.DeleteMsgs([i+1]);
          lsvHeaders.Items[i].ImageIndex := 3;
          Showbusy(false);
     end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
     IMAP.Free;
end;

procedure TfrmMain.actRetrieveHeadersExecute(Sender: TObject);
begin
   Showbusy(true);
   ShowStatus('Retrieving Headers....');
   case IncomingServerType of
     stPOP3:
     begin
          ToggleStatus(True);
          FMsgCount := POP.CheckMessages;
          if FMsgCount > 0 then
          begin
               ShowFileStatus;
               RetrieveIncomingHeaders(FMsgCount);
          end
          else
          begin
               ShowStatus('No messages on server');
          end;
     end;
     stIMAP4:
     begin
          ToggleStatus(True);
          if ( trvMailBoxes.Selected <> nil ) then
          begin
               IMAP.SelectMailBox ( GetTreeViewPath ( trvMailBoxes.Selected, '/' ) );
               lblMailBoxName.Caption := 'Selected MailBox: ' + GetTreeViewPath ( trvMailBoxes.Selected, '/' );
          end;
          FMsgCount := IMAP.MailBox.TotalMsgs;
          if FMsgCount > 0 then
          begin
               ShowFileStatus;
               RetrieveIncomingHeaders(FMsgCount);
          end
          else
          begin
               ShowStatus('No messages on server');
          end;
     end;
   end;
   Showbusy(false);
end;

procedure LoadTreeViewNodes(tv: TTreeView; lst: TStrings; sep: Char);
var tree: TTreeView;    // caller's tree
    sepchar: Char;      // path separator char
    list: TStringList;  // temporary store of treenode refs
    ix: integer;

function LoadNode(const path: string): TTreeNode;
var node: TTreeNode;
    p,ix: integer;
    s: string;
begin
     if path <> '' then s := path else s := '<Empty path>';
     p := list.IndexOf(s);
     if p >= 0 then
        Result := TTreeNode(list.Objects[p])
     else
     begin
          p := -1;
          // find position of final separator
          for ix := Length(s) downto 1 do
          begin
               if s[ix]=sepchar then
               begin
                    p := ix;
                    Break;
               end;
          end;
          if p < 0 then
             node := nil  // root node
          else
          begin               // find parent node (recursive)
               node := LoadNode(Copy(s,1,p-1));
               s := Copy(s,p+1,Length(s)-p);
          end;
          Result := tree.Items.AddChild(node,s);
          list.AddObject(path,Result); // save node reference
     end;
end;

begin
     tree    := tv;  // save caller info
     sepchar := sep; // save caller info
     list    := nil; // in order to avoid nested try/finally
     tree.Items.BeginUpdate;
     try
        tree.Items.Clear;
        list := TStringList.Create;
        list.Sorted := True;
        for ix := 0 to lst.Count-1 do
            LoadNode(lst[ix]);
     finally
            list.Free;
            tree.Items.EndUpdate;
     end;
end;

function GetTreeViewPath(MainNode: TTreeNode; SepChar: Char) : String;

  function GetNodePath ( Node : TTreeNode ): String;
  begin
       if ( Node.Parent <> nil ) then
          Result := GetNodePath ( Node.Parent ) + SepChar + Node.Text
       else
           Result := Node.Text;
  end;

begin
     if ( MainNode.Parent <> nil )then
        Result := GetNodePath ( MainNode.Parent ) + SepChar + MainNode.Text
     else Result := MainNode.Text;
end;

procedure TfrmMain.RefreshMailBoxTree;
var MailBoxSl : TStringList;
begin
   Showbusy(true);
   ShowStatus('Connecting....');
   case IncomingServerType of
     stIMAP4:
     begin
          if IMAP.Connected then
          ToggleStatus(True);
          MailBoxSl := TStringList.Create;
          try
             IMAP.ListMailBoxes ( MailBoxSl );
             LoadTreeViewNodes ( trvMailBoxes, MailBoxSl, '/' );
          finally
                 MailBoxSl.Free;
          end;
     end;
   end;
   Showbusy(false);
end;

procedure TfrmMain.actSelectMailBoxExecute(Sender: TObject);
begin
     case IncomingServerType of
     stIMAP4:
     begin
          Showbusy(true);
          ShowStatus('Selecting MailBox...');
          if Assigned (trvMailBoxes.Selected) then
          begin
               if IMAP.SelectMailBox ( GetTreeViewPath ( trvMailBoxes.Selected, '/' ) ) then
               begin
                    lblMailBoxName.Caption := 'Selected MailBox: ' + IMAP.MailBox.Name;
                    FMsgCount := IMAP.MailBox.TotalMsgs;
                    FMailBoxSize := IMAP.RetrieveMailBoxSize div 1024;
                    ShowFileStatus;
                    if FMsgCount = 0 then
                    begin
                         ShowStatus('No messages in mailbox');
                    end;
               end
               else
               begin
                    MessageDlg ( 'Error selecting mailbox!', mtError, [mbOK], 0 );
               end;
          end;
          Showbusy(false);
     end;
     end;
end;

procedure TfrmMain.trvMailBoxesDblClick(Sender: TObject);
begin
     actSelectMailBox.Execute;
end;

procedure TfrmMain.actDeleteMailBoxExecute(Sender: TObject);
begin
     case IncomingServerType of
     stIMAP4:
     begin
          Showbusy(true);
          ShowStatus('Deleting MailBox...');
          if Assigned (trvMailBoxes.Selected) then
          begin
               if ( MessageDlg ('Delete mailbox "' + trvMailBoxes.Selected.Text + '"?', mtConfirmation, [mbYes, mbNo], 0 ) = mrYes ) then
               begin
                    if not IMAP.DeleteMailBox (GetTreeViewPath (trvMailBoxes.Selected, '/')) then
                    begin
                         MessageDlg ( 'Error deleting mailbox!', mtError, [mbOK], 0 );
                    end
                    else
                    begin
                         RefreshMailBoxTree;
                    end;
               end;
          end;
          Showbusy(false);
     end;
     end;
end;

procedure TfrmMain.actRenameMailBoxExecute(Sender: TObject);
var NewMBName : String;
begin
     case IncomingServerType of
     stIMAP4:
     begin
          Showbusy(true);
          ShowStatus('Renaming MailBox...');
          if Assigned (trvMailBoxes.Selected) then
          begin
               NewMBName := InputBox ( 'Rename MailBox', 'Enter new name for mailbox "' +
               trvMailBoxes.Selected.Text + '": ', '' );
               if ( NewMBName <> '' ) then
               begin
                    if not IMAP.RenameMailBox ( GetTreeViewPath ( trvMailBoxes.Selected, '/' ),
                           GetTreeViewPath ( trvMailBoxes.Selected.Parent, '/' ) + '/' + NewMBName ) then
                    begin
                         MessageDlg ( 'Error renaming mailbox!', mtError, [mbOK], 0 );
                    end
                    else
                    begin
                         RefreshMailBoxTree;
                    end;
               end;
          end;
          Showbusy(false);
     end;
     end;
end;

procedure TfrmMain.actNewMailBoxExecute(Sender: TObject);
var NewMBName : String;
begin
     case IncomingServerType of
     stIMAP4:
     begin
          NewMBName := InputBox ( 'Create New MailBox', 'Enter new mailbox name: ', '' );
          if ( NewMBName <> '' ) then
          begin
               Showbusy(true);
               ShowStatus('Creating new MailBox...');
               if Assigned (trvMailBoxes.Selected) then
               begin
                    if not IMAP.CreateMailBox ( GetTreeViewPath ( trvMailBoxes.Selected, '/' ) + '/' + NewMBName ) then
                    begin
                         MessageDlg ( 'Error creating mailbox!', mtError, [mbOK], 0 );
                    end
                    else
                    begin
                         RefreshMailBoxTree;
                    end;
               end
               else
               begin
                    if not IMAP.CreateMailBox ( NewMBName ) then
                    begin
                         MessageDlg ( 'Error creating mailbox!', mtError, [mbOK], 0 );
                    end
                    else
                    begin
                         RefreshMailBoxTree;
                    end;
               end;
               Showbusy(false);
          end;
     end;
     end;
end;

end.

