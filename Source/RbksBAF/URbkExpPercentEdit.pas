unit URbkExpPercentEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls, Mask, Ib;

type
  TFmRbkExpPercentEdit = class(TFmRbkEdit)
    LbExperience: TLabel;
    LbPercent: TLabel;
    EdExperience: TMaskEdit;
    EdPercent: TMaskEdit;
    procedure EdExperienceChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    Locate_id, TypePay_id :integer;
    procedure AddRecord(Sender: TObject);
    procedure EditRecord(Sender: TObject);
//    procedure SetFilter(Sender: TObject);
    function CheckNeedFieldsExist:Boolean;
  end;

var
  FmRbkExpPercentEdit: TFmRbkExpPercentEdit;

implementation
Uses UMainUnited, URbkExperiencePercent, UConst, UFuncProc;
{$R *.DFM}

procedure TFmRbkExpPercentEdit.AddRecord(Sender: TObject);
var
  qr: TIBQuery;
  sqls:String;
begin
  if not CheckNeedFieldsExist then exit;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=trans;
    trans.AddDatabase(IbDb);
    IbDb.AddTransaction(trans);
    qr.Transaction.Active:=true;
    Locate_id:=GetGenId(IBDB,tbDocum,1);
    sqls:='Insert into '+tbexperiencepercent+
          ' (experiencepercent_id, TypePay_id, experience, percent) values '+
          ' ('+IntToStr(Locate_id)+','+IntToSTr(TypePay_id)+','+
          Trim(edExperience.Text)+','+Trim(Edpercent.Text)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    ModalResult:=mrOk;
  finally
    qr.Free;
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

function TFmRbkExpPercentEdit.CheckNeedFieldsExist:Boolean;
begin
  Result:=true;
  If trim(EdExperience.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbExperience.Caption]));
    EdExperience.SetFocus;
    Result:=false;
    exit;
  end;

  If trim(EdPercent.text) ='' then
  begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbPercent.Caption]));
    EdPercent.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TFmRbkExpPercentEdit.EditRecord(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
  if ChangeFlag then
  begin
   if not CheckNeedFieldsExist then exit;
     try
      Screen.Cursor:=crHourGlass;
      qr:=TIBQuery.Create(nil);
      try
        qr.Database:=IBDB;
        qr.Transaction:=Trans;
        qr.Transaction.AddDatabase(IbDb);
        IbDb.AddTransaction(Trans);
        qr.Transaction.Active:=true;
        sqls:='Update '+tbexperiencepercent+
              ' set TypePay_id='+IntToStr(TypePay_id)+
              ', Experience = '+trim(EdExperience.text)+
              ', percent = '+trim(EdPercent.Text)+
              ' where experiencepercent_id='+IntToStr(Locate_id);
        qr.SQL.Add(sqls);
        qr.ExecSQL;
        qr.Transaction.Commit;
        ModalResult:=mrOk;
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
  end else ModalResult:=mrOk;
end;


procedure TFmRbkExpPercentEdit.EdExperienceChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TFmRbkExpPercentEdit.FormActivate(Sender: TObject);
begin
  inherited;
  EdExperience.SetFocus;
end;

end.
