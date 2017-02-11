unit AddCA;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls,IBQuery,IB,Data;

type
  TFAddCA = class(TFMaket)
    Label1: TLabel;
    Edit: TEdit;
    procedure BOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAddCA: TFAddCA;

implementation

uses Kassa;

{$R *.DFM}

procedure TFAddCA.BOkClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
  inherited;
// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
//    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    qr.Database:=Form1.IBDatabase;
    qr.Transaction:=Form1.IBTransaction;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+'CASHAPPEND'+
          ' (CA_ID,CA_TEXT) values '+
          ' (gen_id(gen_cashappend_id,1),'+QuotedStr(Trim(Edit.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;
//    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
 ModalResult := mrOk;
end;

procedure TFAddCA.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  Case Key of
  VK_Enter: begin
            BOk.OnClick(nil);
            end;
  VK_ESC: begin
          BCancel.OnClick(nil);
          end;
  end;
end;

procedure TFAddCA.FormCreate(Sender: TObject);
begin
  inherited;
//
end;

procedure TFAddCA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFAddCA.FormDestroy(Sender: TObject);
begin
  Caption := Caption;
end;

end.

