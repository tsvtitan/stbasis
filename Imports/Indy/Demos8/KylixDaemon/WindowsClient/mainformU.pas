unit mainformU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

type
  Tmainform = class(TForm)
    myclient: TIdTCPClient;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainform: Tmainform;

implementation

{$R *.DFM}

procedure Tmainform.Button1Click(Sender: TObject);
begin
if edit1.text <> '' then
   begin
       myclient.host:=edit1.text;
       myclient.connect;
       if myclient.connected then
          begin
              myclient.Writeln('test');    // send command
              showmessage(myclient.readln);   //read response from server
              myclient.Disconnect;
          end;

   end else
   showmessage('Please enter a host before sending a test msg');

end;

end.
