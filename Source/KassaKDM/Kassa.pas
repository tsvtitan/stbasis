unit Kassa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, IBDatabase, Db, Data;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MDic: TMenuItem;
    Mkas: TMenuItem;
    MCB: TMenuItem;
    MMag: TMenuItem;
    MPlanAc: TMenuItem;
    MCA: TMenuItem;
    MKassa: TMenuItem;
    MOpen: TMenuItem;
    OpenDialog: TOpenDialog;
    IBDatabase: TIBDatabase;
    IBTransaction: TIBTransaction;
    NMPosting: TMenuItem;
    procedure MCBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MPlanAcClick(Sender: TObject);
    procedure MCAClick(Sender: TObject);
    procedure MKassaClick(Sender: TObject);
    procedure MOpenClick(Sender: TObject);
    procedure NMPostingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses WinTab, CashBasis, PlanAccounts, CashAppend, CashOrder, MPosting;

{$R *.DFM}

procedure TForm1.MCBClick(Sender: TObject);
var
   fm: TFCashBasis;
begin
  fm := TFCashBasis.Create(nil);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OnCloseForm:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TempList := TStringList.Create;
  MView := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TempList.Add('sdf');
  TempList.Free;
end;

procedure TForm1.MPlanAcClick(Sender: TObject);
var
  fm: TPlanAc;
begin
  fm := TPlanAc.Create(nil);
end;

procedure TForm1.MCAClick(Sender: TObject);
var
   fm: TFCashAppend;
begin
  fm := TFCashAppend.Create(nil);
end;

procedure TForm1.MKassaClick(Sender: TObject);
var
   fm: TFCashOrder;
begin
  fm := TFCashOrder.Create(nil);
end;

procedure TForm1.MOpenClick(Sender: TObject);
begin
 if (OpenDialog.Execute) then
   IBDatabase.DatabaseName := OpenDialog.FileName;
   IBDatabase.Connected := True;
   IBTransaction.Active := True;
//   FTable.IBTable.
end;

procedure TForm1.NMPostingClick(Sender: TObject);
var
  fm: TFMPosting;
begin
  fm := TFMPosting.Create(nil);
end;

end.
