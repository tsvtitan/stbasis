unit mainform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdNNTP,
  IdBaseComponent, IdIntercept, IdSSLIntercept, IdSSLOpenSSL, ComCtrls, StdCtrls,
  IdMessage, ActnList, Menus, 
  ExtCtrls, ToolWin, ImgList, IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    IdOSSLNNTP: TIdConnectionInterceptOpenSSL;
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
    redtArticle: TRichEdit;
    lvMessageParts: TListView;
    sptrlMessageParts: TSplitter;
    IdAntiFreeze1: TIdAntiFreeze;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    acStop: TAction;
    Stop1: TMenuItem;
    IdMessage1: TIdMessage;
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
    procedure IdNNTP1Work(Sender: TComponent; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdNNTP1WorkEnd(Sender: TComponent; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
    procedure IdOSSLNNTPGetPassword(var Password: String);
    procedure IdOSSLNNTPStatusInfo(Msg: String);
    procedure IdNNTP1WorkBegin(Sender: TComponent; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure acStopExecute(Sender: TObject);
  private
    FNewsGroupsRetrieved : Integer;
    function ParseXOVERItem(ALine : String) : TListItem;
  public
    FStopped: Boolean;
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

uses
  idGlobal, iniFiles, setup, ConnectThread;

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
    Ini.WriteString('Server','User_ID', IdNNTP1.UserId);
    Ini.WriteString('Server','Password', IdNNTP1.Password);
    Ini.WriteBool('Server','Use_SSL', IdNNTP1.InterceptEnabled );
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
         ConnectThreaded(IdNNTP1);
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
begin
  if Screen.Cursor <> crDefault then begin
    exit;
  end;
  Screen.Cursor := crHourGlass; try
    if lvArticles.Selected <> nil then
    begin
      {We to typecast the Selected.Data which is the article index}
      IdNNTP1.GetArticle(Integer(lvArticles.Selected.Data),'',IdMessage1);
      redtArticle.Lines := IdMessage1.Headers;
      redtArticle.Lines.Add('');
      if IdMessage1.MessageParts.Count >0 then
      begin
        redtArticle.Lines.AddStrings(TIdText(IdMessage1.MessageParts.Items[0]).Body);
        if IdMessage1.MessageParts.Count > 1 then
        begin
          sptrlMessageParts.Visible := True;
          lvMessageParts.Visible := False;
        end
        else
        begin
          {Hide the message part list}
          lvMessageParts.Visible := False;
          sptrlMessageParts.Visible := False;
        end;
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
            li.Caption := Newsgroup;
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
    edtUserID.Text := IdNNTP1.UserId;
    edtPassword.Text := IdNNTP1.Password;
    chkUseSSL.Checked := IdNNTP1.InterceptEnabled;
    edtCert.Text := IdOSSLNNTP.SSLOptions.CertFile;
    edtRoot.Text := IdOSSLNNTP.SSLOptions.RootCertFile;
    edtKey.Text := IdOSSLNNTP.SSLOptions.KeyFile;
    If ShowModal = mrOk then
    begin
      IdNNTP1.Host := edtServer.Text;
      IdNNTP1.Port := spnedtPort.Value;
      IdNNTP1.UserId := edtUserID.Text;
      IdNNTP1.Password := edtPassword.Text;
      IdNNTP1.InterceptEnabled := chkUseSSL.Checked ;
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

procedure TForm1.IdNNTP1Work(Sender: TComponent; AWorkMode: TWorkMode;
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
    IdNNTP1.Binding.CloseSocket;
    Screen.Cursor := crDefault
  end;
end;

procedure TForm1.IdNNTP1WorkEnd(Sender: TComponent; AWorkMode: TWorkMode);
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
    IdNNTP1.UserId := Ini.ReadString('Server','User_ID', IdNNTP1.UserId);
    IdNNTP1.Password := Ini.ReadString('Server','Password', IdNNTP1.Password);
    IdNNTP1.InterceptEnabled := Ini.ReadBool('Server','Use_SSL', False );

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

procedure TForm1.IdNNTP1WorkBegin(Sender: TComponent; AWorkMode: TWorkMode;
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

end.
