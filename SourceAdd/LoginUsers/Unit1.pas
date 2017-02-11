unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IBDatabase, IBDatabaseInfo, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    IBDatabaseInfo1: TIBDatabaseInfo;
    IBDatabase1: TIBDatabase;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  Memo1.Lines.Clear;
  IBDatabase1.Connected:=true;

  for i:=0 to IBDatabaseInfo1.UserNames.Count-1 do begin
    Memo1.Lines.Add(IBDatabaseInfo1.UserNames[i]);
  end;
end;

end.
