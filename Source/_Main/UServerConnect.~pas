unit UServerConnect;

interface
{$I stbasis.inc}
uses
  Windows, SysUtils,Forms, ExtCtrls, StdCtrls, Classes, Controls, ComCtrls, Dialogs,
  Graphics, Buttons, IBServices;

type
  TfmServerConnect = class(TForm)
    gbDBServerInfo: TGroupBox;
    lblServerName: TLabel;
    lblProtocol: TLabel;
    lblDatabase: TLabel;
    cbProtocol: TComboBox;
    rbLocalServer: TRadioButton;
    rbRemoteServer: TRadioButton;
    cbDBServer: TComboBox;
    edtDatabase: TEdit;
    btnSelDB: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TButton;
    btCancel: TButton;
    bibTest: TButton;
    od: TOpenDialog;
    procedure btOkClick(Sender: TObject);
    procedure bibTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbLocalServerClick(Sender: TObject);
    procedure btnSelDBClick(Sender: TObject);
  private
    function GetConnectString: String;
  public
    ConnectString: String;
    procedure SetParams(Prot: TProtocol; SrvName: String);
    procedure AppOnExcept(Sender: TObject; E: Exception);
  end;

var
  fmServerConnect : TfmServerConnect;

implementation

uses UMainCode, UMainData, UMainUnited;

{$R *.DFM}


procedure TfmServerConnect.btOkClick(Sender: TObject);
begin
  ConnectString:=GetConnectString;
  ModalResult:=mrOk;
end;

procedure TfmServerConnect.bibTestClick(Sender: TObject);
begin
  ConnectString:=GetConnectString;
  if cbDBServer.Items.IndexOf(cbDBServer.Text)=-1 then
    cbDBServer.Items.Insert(0,cbDBServer.Text);
  if ConnectServer(ConnectString,ConstConnectUserName,ConstConnectUserPass,'') then begin
    ShowInfoEx('Соединено.');
  end else begin
    ShowErrorEx('Ошибка соединения.');
  end;
end;

procedure TfmServerConnect.FormCreate(Sender: TObject);
begin
  Application.OnException:=AppOnExcept;
  rbLocalServer.Checked:=true;
end;

procedure TfmServerConnect.rbLocalServerClick(Sender: TObject);
begin
  if rbLocalServer.Checked then begin
    lblServerName.Enabled:=false;
    cbDBServer.Enabled:=false;
    cbDBServer.Color:=clBtnface;
    lblProtocol.Enabled:=false;
    cbProtocol.Enabled:=false;
    cbProtocol.Color:=clBtnface;
    btnSelDB.Enabled:=true;
    cbDBServer.Text:='';
    cbProtocol.ItemIndex:=-1;
    edtDatabase.Text:='';
  end else begin
    lblServerName.Enabled:=true;
    cbDBServer.Enabled:=true;
    cbDBServer.Color:=clWindow;
    lblProtocol.Enabled:=true;
    cbProtocol.Enabled:=true;
    cbProtocol.Color:=clWindow;
    btnSelDB.Enabled:=false;
    cbDBServer.Text:='';
    cbProtocol.ItemIndex:=-1;
    edtDatabase.Text:='';
  end;
end;

procedure TfmServerConnect.btnSelDBClick(Sender: TObject);
begin
  od.FileName:=edtDatabase.Text;
  if not od.Execute then exit;
  edtDatabase.Text:=od.FileName;
end;

function TfmServerConnect.GetConnectString: String;
var
  tmps: string;
  pref_1,pref_2: string;
begin
  if trim(cbDBServer.Text)<>'' then begin
   case cbProtocol.ItemIndex of
     0: begin
       pref_1:='';
       pref_2:=':';
     end;
     1: begin
       pref_1:='\\';
       pref_2:='\';
     end;
     2: begin
       pref_1:='';
       pref_2:='@';
     end;
   end;
   tmps:=pref_1+trim(cbDBServer.Text)+pref_2+Trim(edtDatabase.text)
  end else begin
   tmps:=Trim(edtDatabase.text);
  end;
  Result:=tmps;
end;

procedure TfmServerConnect.SetParams(Prot: TProtocol; SrvName: String);
begin
  rbRemoteServer.Checked:=trim(SrvName)<>'';
  case Prot of
    TCP: begin
     cbDBServer.Items.Add(SrvName);
     cbDBServer.Text:=SrvName;
     cbProtocol.ItemIndex:=0;
     edtDatabase.Text:=Copy(MainDataBaseName,Length(SrvName)+2,
                            Length(MainDataBaseName)-Length(SrvName)+1);
    end;
    SPX: begin
     cbDBServer.Items.Add(SrvName);
     cbDBServer.Text:=SrvName;
     cbProtocol.ItemIndex:=2;
     edtDatabase.Text:=Copy(MainDataBaseName,Length(SrvName)+2,
                            Length(MainDataBaseName)-Length(SrvName)+1);
    end;
    NamedPipe:begin
     cbDBServer.Items.Add(SrvName);
     cbDBServer.Text:=SrvName;
     cbProtocol.ItemIndex:=1;
     edtDatabase.Text:=Copy(MainDataBaseName,Length(SrvName)+2,
                            Length(MainDataBaseName)-Length(SrvName)+1);
    end;
    Local:begin
     edtDatabase.Text:=MainDataBaseName;
    end;
  end;
end;

procedure TfmServerConnect.AppOnExcept(Sender: TObject; E: Exception);
begin
   AddErrorToJournal_(Pchar(E.Message),E.ClassType);
end;

end.
