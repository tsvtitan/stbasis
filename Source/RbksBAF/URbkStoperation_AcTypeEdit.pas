unit URbkStoperation_AcTypeEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls, IB;

type
  TfmRbkStoperation_AcTypeEdit = class(TFmRbkEdit)
    EdStandartOperation: TEdit;
    EdAccountType: TEdit;
    LbStandartoperation: TLabel;
    LbAccountType: TLabel;
    BtCallStandartoperation: TButton;
    BtAccountType: TButton;
    procedure BtCallStandartoperationClick(Sender: TObject);
    procedure BtAccountTypeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
  protected
    function UpdateRBooks: Boolean;
    function AddToRBooks: Boolean;
  public
    AccountType_id, StandartOperation_id:Integer;
    NewAccountType_id, NewStandartOperation_id:Integer;
    procedure AddRecord(Sender: TObject);
    procedure EditRecord(Sender: TObject);
    function CheckNeedFields:Boolean;
  end;

var
  fmRbkStoperation_AcTypeEdit: TfmRbkStoperation_AcTypeEdit;

implementation
Uses UMainUnited, UfuncProc, Uconst;

{$R *.DFM}

procedure TfmRbkStoperation_AcTypeEdit.AddRecord(Sender: TObject);
begin
  if not CheckNeedFields then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

procedure TfmRbkStoperation_AcTypeEdit.EditRecord(Sender: TObject);
begin
  if ChangeFlag then
  begin
   if not CheckNeedFields then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmRbkStoperation_AcTypeEdit.CheckNeedFields:Boolean;
begin
  Result:=false;
  if trim(EdStandartOperation.text)='' then
  begin
    ShowWarning(Application.handle,'”кажите типовую операцию');
    EdStandartOperation.SetFocus;
    exit;
  end;
  if trim(EdAccountType.text)='' then
  begin
    ShowWarning(Application.handle,'”кажите проводку');
    EdAccountType.SetFocus;
    exit;
  end;
  Result:=true;
end;

procedure TfmRbkStoperation_AcTypeEdit.BtCallStandartoperationClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tvibvModal;
 TPRBI.Locate.KeyFields:='STANDARTOPERATION_ID';
 TPRBI.Locate.KeyValues:=StandartOperation_id;
 TPRBI.Locate.Options:=[];
 if _ViewInterfaceFromName(NameStandartoperation,@TPRBI) then begin
   ChangeFlag:=true;
   NewStandartOperation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'StandartOperation_id');
   EdStandartOperation.text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
 end;
end;

procedure TfmRbkStoperation_AcTypeEdit.BtAccountTypeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tvibvModal;
 TPRBI.Locate.KeyFields:='ACCOUNTTYPE_ID';
 TPRBI.Locate.KeyValues:=AccountType_id;
 TPRBI.Locate.Options:=[];
 if _ViewInterfaceFromName(NameAccountType,@TPRBI) then begin
   ChangeFlag:=true;
   NewACCOUNTTYPE_ID:=GetFirstValueFromParamRBookInterface(@TPRBI,'ACCOUNTTYPE_ID');
   EdACCOUNTTYPE.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
 end;
end;

function TfmRbkStoperation_AcTypeEdit.AddToRBooks: Boolean;
var
  sqls: string;
begin
 Result:=false;
 try
   Screen.Cursor:=crHourGlass;
   try
     IbQ.Database:=IBDB;
     IbQ.Transaction:=trans;
     trans.AddDatabase(IbDb);
     IbDb.AddTransaction(trans);
     IbQ.Transaction.Active:=true;
     sqls:='Insert into '+tbStOperation_AcType+
           ' (StandartOperation_id, AccountType_id) values '+
           ' ('+IntToStr(NewStandartOperation_id)+','+
           IntToSTr(NewAccountType_id)+')';
     IbQ.SQL.Add(sqls);
     IbQ.ExecSQL;
     IbQ.Transaction.Commit;
     Result:=true;
   finally
     Screen.Cursor:=crDefault;
   end;
 except
   on E: EIBInterBaseError do
   begin
     TempStr:=TranslateIBError(E.Message);
     ShowError(Handle,TempStr);
     Assert(false,TempStr);
   end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmRbkStoperation_AcTypeEdit.UpdateRBooks: Boolean;
var
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  try
    IbQ.Database:=IBDB;
    IbQ.Transaction:=Trans;
    IbQ.Transaction.AddDatabase(IbDb);
    IbDb.AddTransaction(Trans);
    IbQ.Transaction.Active:=true;
    sqls:='Update '+tbStOperation_AcType+
          ' set StandartOperation_id='+IntToStr(NewStandartOperation_id)+
          ', AccountType_id = '+IntToStr(NewAccountType_id)+
          ' where StandartOperation_id='+IntToStr(StandartOperation_id)+
          ' and AccountType_id='+IntToStr(AccountType_id);
    IbQ.SQL.Add(sqls);
    IbQ.ExecSQL;
    IbQ.Transaction.Commit;
    Result:=true;
  finally
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
end;
procedure TfmRbkStoperation_AcTypeEdit.FormActivate(Sender: TObject);
begin
  NewAccountType_id:=AccountType_id;
  NewStandartOperation_id:=StandartOperation_id;
end;

end.
