unit mainform;

interface

uses
  {$IFDEF LINUX}
  QForms, QImgList, QActnList, QMenus, QTypes, QStdCtrls,QComCtrls, QControls, QExtCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ActnList,
  ExtCtrls, ToolWin, ImgList,Menus, ComCtrls, StdCtrls,
  {$ENDIF}
  SysUtils, Classes,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdNNTP,
  IdBaseComponent,  IdSSLOpenSSL, IdMessage, IdAntiFreezeBase,
  IdAntiFreeze, IdIOHandler, IdIOHandlerSocket;

type
  TForm1 = class(TForm)
    IdNNTP1: TIdNNTP;
    mmnuMainProgram: TMainMenu;
    ActionList1: TActionList;
    actConnected: TAction;
    actExit: TAction;
    File1: TMenuItem;
    Connected1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    actOptions: TAction;
    View1: TMenuItem;
    actOptions1: TMenuItem;
    StatusBar1: TStatusBar;
    pnlTopPains: TPanel;
    lvNewsGroups: TListView;
    lvArticles: TListView;
    spltrTopPains: TSplitter;
    ToolBar1: TToolBar;
    spltrMessageList: TSplitter;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    pnlMessageView: TPanel;
    lvMessageParts: TListView;
    sptrlMessageParts: TSplitter;
    IdAntiFreeze1: TIdAntiFreeze;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    acStop: TAction;
    Stop1: TMenuItem;
    IdMessage1: TIdMessage;
    IdOSSLNNTP: TIdSSLIOHandlerSocket;
    redtArticle: TMemo;
    procedure IdNNTP1NewsgroupList(const ANewsgroup: String; const ALow,
      AHigh: Cardinal; const AType: String; var ACanContinue: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvNewsGroupsClick(Sender: TObject);
    procedure lvArticlesClick(Sender: TObject);
    procedure actConnectedExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure IdNNTP1Status(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
    procedure IdNNTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdNNTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
    procedure IdOSSLNNTPGetPassword(var Password: String);
    procedure IdOSSLNNTPStatusInfo(Msg: String);
    procedure IdNNTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure acStopExecute(Sender: TObject);
    procedure lvMessagePartsClick(Sender: TObject);
  private
    FNewsGroupsRetrieved : Integer;
    Procedure OriginalArticleView;
    function ParseXOVERItem(ALine : String) : TListItem;
  public
    FStopped: Boolean;
  end;

var
  Form1: TForm1;

implementation
{$IFNDEF LINUX}{$R *.DFM}{$ELSE}{$R *.xfm}{$ENDIF}

uses
  idGlobal, iniFiles, setup;

procedure TForm1.IdNNTP1NewsgroupList(const ANewsgroup: String; const ALow,
  AHigh: Cardinal; const AType: String; var ACanContinue: Boolean);
var li : TListItem;
begin
  Inc(FNewsGroupsRetrieved);
  StatusBar1.SimpleText := Format('Retreived %d newsgroups',
    [FNewsGroupsRetrieved]);
  li := lvNewsGroups.Items.Add;
  li.Caption := ANewsgroup;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Ini : TIniFile;
begin
  {make sure that we aren't connected to the server}
  IdNNTP1.Disconnect;
  {Save our newsreader settings}
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  try
    Ini.WriteString('Server','Host_Name', IdNNTP1.Host );
    Ini.WriteInteger('Server','Port', IdNNTP1.Port );
    Ini.WriteString('Server','User_ID', IdNNTP1.UserName);
    Ini.WriteString('Server','Password', IdNNTP1.Password);
    Ini.WriteBool('Server','Use_SSL', IdNNTP1.IOHandler is TIdSSLIOHandlerSocket);
    Ini.WriteString('Server','Certificate',  IdOSSLNNTP.SSLOptions.CertFile );
    Ini.WriteString('Server','Root',IdOSSLNNTP.SSLOptions.RootCertFile );
    Ini.WriteString('Server','Key', IdOSSLNNTP.SSLOptions.KeyFile );

  finally
    Ini.Free;
  end;
end;

procedure TForm1.lvNewsGroupsClick(Sender: TObject);
var idx : Integer;
    strs : TStringList;
begin
  if Screen.Cursor <> crDefault then begin
    exit;
  end;
  Screen.Cursor := crHourGlass; try
    if (lvNewsGroups.Selected <> nil) then
    try
      // reconnect
      if Not IdNNTP1.Connected then
      begin
        IdNNTP1.Connect;
      end;
      strs := TStringList.Create;
      try
        IdNNTP1.SelectGroup(lvNewsGroups.Selected.Caption);
        lvArticles.Items.Clear;
        {Get article information from Lowest to Highest articles}
        IdNNTP1.SendXOVER(IntToStr(IdNNTP1.MsgLow)+'-'+IntToStr(IdNNTP1.MsgHigh),strs);
        lvArticles.Items.BeginUpdate;
        try
          lvArticles.Items.Clear;
          idx := 0;
          while idx < Strs.Count do
          begin
            ParseXOVERItem ( Strs [ idx ] );
            Inc (idx);
          end;
        finally
          lvArticles.Items.EndUpdate;
        end;
      finally
        FreeAndNil(strs);
      end;
    except
      IdNNTP1.Disconnect;
    end;
  finally Screen.Cursor := crDefault; end;
end;

function TForm1.ParseXOVERItem(ALine: String): TListItem;
var Subject, From, References, MsgId, ExtraData : String;
    ArticleIndex, ByteCount, LineCount : Cardinal;
    Date : TDateTime;
begin
  ParseXOVER( ALine, ArticleIndex, Subject, From, Date, MsgId, References,
              ByteCount, LineCount, ExtraData);
  Result := lvArticles.Items.Add;
  { Article Index }
  {We use the data property to store the integer.
   I know typecasting can be ugly}
  Result.Data := Pointer ( ArticleIndex );
  { Subject }
  Result.Caption := Subject;
  { From }
  Result.SubItems.Add ( From );
  { Date }
  Result.SubItems.Add ( DateTimeToStr ( Date ) );
  {Line Count}
  Result.SubItems.Add ( IntToStr ( LineCount ) );
  {Message ID -workaround because the GetArticle does not seem to work with
  article indexes}
  Result.SubItems.Add ( MsgId);
end;

procedure TForm1.lvArticlesClick(Sender: TObject);
var partIdx : Integer;
    li : TListItem;
    OnlyText: Boolean;
begin
  if Screen.Cursor <> crDefault then begin
    exit;
  end;
  Screen.Cursor := crHourGlass; try
    if lvArticles.Selected <> nil then
    begin
      lvMessageParts.Items.Clear;
      {We to typecast the Selected.Data which is the article index}
      IdNNTP1.GetArticle(Integer(lvArticles.Selected.Data),'',IdMessage1);
      OriginalArticleView;
      if IdMessage1.MessageParts.Count >0 then
      begin
        OnlyText := true;

        li := lvMessageParts.Items.Add;
        li.Caption := 'Original View';
        for PartIdx := 0 to IdMessage1.MessageParts.Count -1 do
        begin
          li := lvMessageParts.Items.Add;
          if IdMessage1.MessageParts[PartIdx] is TIdText then
          begin
            li.Caption := 'Text Part';
            // redtArticle.Lines.AddStrings(TIdText(IdMessage1.MessageParts.Items[0]).Body);
          end
          else
          begin
            li.Caption := (IdMessage1.MessageParts[PartIdx] as TIdAttachment).FileName;
            OnlyText := false;
          end;
        end;

        sptrlMessageParts.Visible := not OnlyText;
        lvMessageParts.Visible := not OnlyText;
      end;
    end;
  finally Screen.Cursor := crDefault; end;
end;

procedure TForm1.actConnectedExecute(Sender: TObject);
var idx : Integer;
    li : TListItem;
    NewsGroup : String;
    Hi, Lo : Cardinal;
    Stat : String;
    NewsList : TStringList;
begin
  if Screen.Cursor <> crDefault then begin
    exit;
  end;
  Screen.Cursor := crHourGlass; try
    {This works as a toggle menu item}
    if Not IdNNTP1.Connected then
    begin
      IdNNTP1.Connect;
      try
        NewsList := TStringList.Create;
        try
          {Get newsgroup list}
          IdNNTP1.GetNewsgroupList(NewsList);
          {process newsgroups after list}
          idx := 0;
          while idx < NewsList.Count do
          begin
            li := lvNewsGroups.Items.Add;
            ParseNewsGroup( NewsList[idx],NewsGroup,Hi,Lo, Stat);
            {Newsgroup name}
            li.Caption := Newsgroup;
            {Article estimated to be in newsgroup}

            {if lo is greater than Hi, we have no articles}
            if (Lo >= Hi) then
              li.SubItems.Add('None')
            else
              li.SubItems.Add(IntToStr(Hi - Lo));
            {Newsgroup status}
            {This should never be nil but just in case, we check}
            if Length(LowerCase(Stat[1])) > 0 then
              case Stat[1] of
                'y' : li.SubItems.Add('Permitted');
                'n' : li.SubItems.Add('Read-Only');
                'm' : li.SubItems.Add('Moderated');
              end;
            Inc (idx);
          end;
        finally
          NewsList.Free;
        end;
      except
        IdNNTP1.Disconnect;
      end; // try finally
    end // if Not Connected then
    else
    begin
      {Close the connection}
      IdNNTP1.Disconnect;
      {Clear the List Views}
      lvNewsGroups.Items.Clear;
      lvArticles.Items.Clear;
    end; //else .. if Not IdNNTP1.Connected then
  finally Screen.Cursor := crDefault; end;
end;

procedure TForm1.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.actOptionsExecute(Sender: TObject);
begin
  with TfrmNewsSetup.Create(Application) do
  try
    edtServer.Text := IdNNTP1.Host;
    spnedtPort.Value := IdNNTP1.Port;
    edtUserID.Text := IdNNTP1.UserName;
    edtPassword.Text := IdNNTP1.Password;
    chkUseSSL.Checked := IdNNTP1.IOHandler is TIdSSLIOHandlerSocket;
    edtCert.Text := IdOSSLNNTP.SSLOptions.CertFile;
    edtRoot.Text := IdOSSLNNTP.SSLOptions.RootCertFile;
    edtKey.Text := IdOSSLNNTP.SSLOptions.KeyFile;
    If ShowModal = mrOk then
    begin
      IdNNTP1.Host := edtServer.Text;
      IdNNTP1.Port := spnedtPort.Value;
      IdNNTP1.UserName := edtUserID.Text;
      IdNNTP1.Password := edtPassword.Text;
      if chkUseSSL.Checked then
        IdNNTP1.IOHandler := IdOSSLNNTP
      else
        IdNNTP1.IOHandler := nil;
      IdOSSLNNTP.SSLOptions.CertFile := edtCert.Text;
      IdOSSLNNTP.SSLOptions.RootCertFile := edtRoot.Text;
      IdOSSLNNTP.SSLOptions.KeyFile := edtKey.Text;
   end; //if ShowModal = mrOk then
  finally
    Free;
  end;
end;

procedure TForm1.IdNNTP1Status(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin
  StatusBar1.SimpleText := asStatusText;
  case axStatus of
    hsConnected : actConnected.Checked := True;
    hsDisconnected : actConnected.Checked := False;
  end;
end;

procedure TForm1.IdNNTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  if not FStopped then
  begin
    if AWorkMode = wmRead then
    begin // if AWorkMode = wmRead then
      StatusBar1.SimpleText := Format('Received %d from %s.  Please wait...',[AWorkCount,IdNNTP1.Host]);
    end
    else
    begin
      StatusBar1.SimpleText := Format('Sent %d to %s.  Please wait...',[AWorkCount,IdNNTP1.Host]);
    end; //else..if AWorkMode = wmRead then
  end
  else
  begin
    StatusBar1.SimpleText := 'Stopping...';
    IdNNTP1.DisconnectSocket;
    Screen.Cursor := crDefault
  end;
end;

procedure TForm1.IdNNTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  acStop.enabled := false;
  StatusBar1.SimpleText := 'Ready';
end;

procedure TForm1.FormCreate(Sender: TObject);
var Ini : TIniFile;
begin
  {Retrieve our previous newsreader settings}
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0),'.ini'));
  try
    IdNNTP1.Host := Ini.ReadString('Server','Host_Name', IdNNTP1.Host);
    IdNNTP1.Port := Ini.ReadInteger('Server','Port', IdNNTP1.Port);
    IdNNTP1.UserName := Ini.ReadString('Server','User_ID', IdNNTP1.UserName);
    IdNNTP1.Password := Ini.ReadString('Server','Password', IdNNTP1.Password);
    if Ini.ReadBool('Server','Use_SSL', False ) then begin
      IdNNTP1.IOHandler := IdOSSLNNTP;
    end
    else begin
      IdNNTP1.IOHandler := nil;
    end;

    IdOSSLNNTP.SSLOptions.CertFile := Ini.ReadString('Server','Certificate',  IdOSSLNNTP.SSLOptions.CertFile );
    IdOSSLNNTP.SSLOptions.RootCertFile := Ini.ReadString('Server','Root', IdOSSLNNTP.SSLOptions.RootCertFile );
    IdOSSLNNTP.SSLOptions.KeyFile := Ini.ReadString('Server','Key', IdOSSLNNTP.SSLOptions.KeyFile );
  finally
    Ini.Free;
  end;
end;

procedure TForm1.IdOSSLNNTPGetPassword(var Password: String);
begin
  Password := 'aaaa';
end;

procedure TForm1.IdOSSLNNTPStatusInfo(Msg: String);
begin
  StatusBar1.SimpleText := Msg;
end;

procedure TForm1.IdNNTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  FStopped := false;
  acStop.enabled := true;
  Application.ProcessMessages;
end;

procedure TForm1.acStopExecute(Sender: TObject);
begin
  FStopped := true;
  Screen.Cursor := crDefault
end;

procedure TForm1.OriginalArticleView;
begin
  redtArticle.Lines.Clear;
  redtArticle.Lines := IdMessage1.Headers;
  redtArticle.Lines.Add('');
  if Length(IdMessage1.Body.Text) > 0 then
     redtArticle.Lines.AddStrings(IdMessage1.Body);
end;


procedure TForm1.lvMessagePartsClick(Sender: TObject);
begin
  if lvMessageParts.Selected <> nil then
  begin
    if lvMessageParts.Selected.Index = 0 then
      OriginalArticleView
    else
    begin
      if IdMessage1.MessageParts[lvMessageParts.Selected.Index - 1] is TIdText then
      begin
        redtArticle.Lines.Assign(TIdText(IdMessage1.MessageParts[lvMessageParts.Selected.Index - 1]).Body);
      end;
    end;
  end;
end;

end.

