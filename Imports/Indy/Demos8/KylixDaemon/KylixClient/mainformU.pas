unit mainformU;

interface

uses
  SysUtils, Types, Classes, Variants, QGraphics, QControls, QForms, QDialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, QStdCtrls,
  QExtCtrls;

type
  Tmainform = class(TForm)
    myclient: TIdTCPClient;
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainform: Tmainform;

implementation

{$R *.xfm}

procedure Tmainform.Button1Click(Sender: TObject);
begin
myclient.Host:= edit1.text;
myclient.connect;
if myclient.connected then
    begin
       myclient.writeln('test');
       showmessage(myclient.readln);
       myclient.disconnect;

    end;
end;

end.
