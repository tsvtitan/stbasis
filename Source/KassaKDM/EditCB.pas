unit EditCB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AddCB, StdCtrls, IBQuery, Kassa, Data,IB;

type
  TFEditCB = class(TFAddCB)
  procedure BOkClick1(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEditCB: TFEditCB;

implementation

procedure TFEditCB.BOkClick1(Sender: TObject);
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
    sqls:='Update '+'CASHBASIS'+
          ' set CB_TEXT='+QuotedStr(Trim(Edit.Text))+
          ' where CB_ID='+IntToStr(IDRec);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
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

procedure TFEditCB.FormCreate(Sender: TObject);
begin
  Caption := 'Изменить';
  BOk.OnClick := nil;
  BOk.OnClick := BOkClick1;
end;

end.
