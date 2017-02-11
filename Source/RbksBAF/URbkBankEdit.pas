unit URbkBankEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls;

type
  TFmRbkBankEdit = class(TFmRbkEdit)
    LbName: TLabel;
    LbBik: TLabel;
    LbBikrkc: TLabel;
    LbkorAccount: TLabel;
    LbAddress: TLabel;
    EdName: TEdit;
    EdAddress: TEdit;
    EdBik: TEdit;
    EdBikRkc: TEdit;
    EdKorAccount: TEdit;
    procedure BtPostClick(Sender: TObject);
  private
    { Private declarations }
  public
    EditMode:Boolean;
    Bank_id:String;
    { Public declarations }
    function CheckFieldvaluesExist:Boolean;
    function GetInsertString:String;
    function GetUpdateString:String;

  end;

var
  FmRbkBankEdit: TFmRbkBankEdit;

implementation
Uses UConst,UmainUnited, UFuncProc, UrbkBank;

{$R *.DFM}

procedure TFmRbkBankEdit.BtPostClick(Sender: TObject);
begin
  if not CheckFieldvaluesExist then exit;
  if not EditMode then IBQ.SQL.Add(GetInsertString) else
    IBQ.SQL.Add(GetUpdateString);
  IbQ.Database:=IBDB;
  IbQ.Transaction.AddDatabase(IBDB);
  try
    IbQ.Transaction.Active:=true;
    IbQ.ExecSQL;
    IbQ.Transaction.CommitRetaining;
    ModalResult:=mrOk;
  except
    ShowError(Handle,'Ошибка выполнения запроса');
  end;
end;


function TFmRbkBankEdit.CheckFieldvaluesExist:Boolean;
begin
  Result:=true;
  if trim(EdName.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbName.Caption]));
   EdName.SetFocus;
   Result:=false;
   exit;
  end;
  if trim(EdAddress.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbAddress.Caption]));
   EdAddress.SetFocus;
   Result:=false;
   exit;
  end;
  if trim(EdBik.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbBik.Caption]));
   EdBik.SetFocus;
   Result:=false;
   exit;
  end;
  if trim(EdBikRkc.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbBikRkc.Caption]));
   EdBikRkc.SetFocus;
   Result:=false;
   exit;
  end;
  if trim(EdKorAccount.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbKorAccount.Caption]));
   EdKorAccount.SetFocus;
   Result:=false;
   exit;
  end;
end;

function TFmRbkBankEdit.GetInsertString:String;
var
  S:String;
begin
  Locate_id:=GetGenId(IBDB, TbName,1);
  S:='Insert into '+tbBank+' (Bank_id, Name, Address,'+#13+
     'Bik,  BikRkc, KorAccount) values (';
  S:=S+IntToStr(Locate_id)+', '+CoolStr(EdName.Text)+', '+CoolStr(EdAddress.Text)+
  ', '+CoolStr(EdBik.Text)+', '+CoolStr(EdBikrkc.Text)+', '+
  CoolStr(EdKorAccount.Text)+')';
  Result:=S;
end;

function TFmRbkBankEdit.GetUpdateString:String;
var
  S:String;
  Region_id:String;
begin
  Bank_id:=FmRbkBank.RbkQuery.FieldByName('Bank_id').AsString;
  S:='Update '+tbBank+' Set Name='+CoolStr(edName.Text)+', Address='+#13+
     CoolStr(EdAddress.Text)+', Bik = '+CoolStr(EdBik.Text)+
     ', Bikrkc='+CoolStr(EdBikrkc.Text)+', Koraccount='+CoolStr(EdKorAccount.Text)+
     ' where Bank_id ='+Bank_id;
  Result:=S;
end;


end.
