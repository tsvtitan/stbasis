unit fMain;
{***************************************************************
 *
 * Project  : Client
 * Unit Name: fMain
 * Purpose  : Demonstrates sending / receiving record data and use of buffers
 * Version  : 1.0
 * Date     : Sat 14 Jul 2001  -  03:50:24
 * Author   : Allen O'Neill <allen_oneill@hotmail.com>
 * History  :
 * Tested   : Sat 14 Jul 2001  // Allen O'Neill <allen_oneill@hotmail.com>
 *
 ****************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  Direction = (dirLeft,dirRight);

type
  MyRecord = Packed Record
  MyInteger : Integer;
  MyString : String[250];
  MyBool : Boolean;
  MyDirection : Direction;
  end;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    edtServerIP: TEdit;
    Label2: TLabel;
    edtServerPort: TEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    cboSendDirection: TComboBox;
    Label4: TLabel;
    edtSendMyInteger: TEdit;
    edtSendMyString: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    cboSendMyBoolean: TComboBox;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cboReceiveDirection: TComboBox;
    edtReceiveMyInteger: TEdit;
    edtReceiveMyString: TEdit;
    cboReceiveMyBoolean: TComboBox;
    Button1: TButton;
    Button2: TButton;
    IdTCPClient: TIdTCPClient;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  MySendingRecord : MyRecord;
  MyReceivingRecord : MyRecord;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
// init
with MySendingRecord do
  begin
  MyInteger := StrToInt(edtSendMyInteger.text);
  MyString := edtSendMyString.text;
  case cboSendDirection.ItemIndex of
    0 : MyDirection := dirLeft;
    1 : MyDirection := dirRight;
    end;
  case cboSendMyBoolean.ItemIndex of
    0 : MyBool := true;
    1 : MyBool := false;
    end;
  end;

cboReceiveDirection.ItemIndex := -1;
edtReceiveMyInteger.text := '';
edtReceiveMyString.text := '';
cboReceiveMyBoolean.ItemIndex := -1;

// send and receive
with IdTCPClient do
  begin
  Host := edtServerIP.text;
  Port := StrToInt(edtServerPort.text);
  Connect;
  WriteBuffer(MySendingRecord,SizeOf(MySendingRecord),true);
  ReadBuffer(MyReceivingRecord,SizeOf(MyReceivingRecord));
  Disconnect;
  end;

// Show record buffer data received back

case MyReceivingRecord.MyDirection of
  dirLeft : cboReceiveDirection.ItemIndex := 0;
  dirRight : cboReceiveDirection.ItemIndex := 1;
  end;

edtReceiveMyInteger.text := IntToStr(MyReceivingRecord.MyInteger);
edtReceiveMyString.text := MyReceivingRecord.MyString;

case MyReceivingRecord.MyBool of
  true : cboReceiveMyBoolean.ItemIndex := 0;
  false : cboReceiveMyBoolean.ItemIndex := 1;
  end;


end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
cboSendDirection.ItemIndex := 0;
cboSendMyBoolean.ItemIndex := 0;
cboReceiveDirection.ItemIndex := -1;
cboReceiveMyBoolean.ItemIndex := -1;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
application.terminate;
end;

end.
