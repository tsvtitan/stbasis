unit AddCB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {WinMaket,} StdCtrls, IBSQL, {Data,} IBQuery, {Kassa,} IBDatabase, IB,
  IBServices, ExtCtrls, CashBasis, UEditRB, Buttons;

type
  TFAddCB = class(TfmEditRB)
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
  FAddCB: TFAddCB;

implementation

//uses Kassa;

{$R *.DFM}

procedure TFAddCB.BOkClick(Sender: TObject);
//var
//  qr: TIBQuery;
//  sqls: string;
begin
  inherited;
// Result:=false;
 try
{  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
//    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    qr.Database:=Form1.IBDatabase;
    qr.Transaction:=Form1.IBTransaction;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+'CASHBASIS'+
          ' (CB_ID,CB_TEXT) values '+
          ' (gen_id(gen_cashbasis_id,1),'+QuotedStr(Trim(Edit.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;
//    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end; }
 except
  on E: EIBInterBaseError do begin
//    TempStr:=TranslateIBError(E.Message);
//    ShowError(Handle,TempStr);
 //   Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
 ModalResult := mrOk;
end;

procedure TFAddCB.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
{  Case Key of
  VK_Enter: begin
            BOk.OnClick(nil);
            end;
  VK_ESC: begin
          BCancel.OnClick(nil);
          end;
  end;}
end;

procedure TFAddCB.FormCreate(Sender: TObject);
begin
  inherited;
//
end;

procedure TFAddCB.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := caFree;
end;

procedure TFAddCB.FormDestroy(Sender: TObject);
begin
//  Caption := Caption;
end;  

end.
