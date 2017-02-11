unit FilterPa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AddPlanAc, Db, IBCustomDataSet, IBTable, StdCtrls, ExtCtrls, Mask,IB,IBQuery,
  Data;

type
  TFPAFilter = class(TFAddAccount)
    BClear: TButton;
    CheckBox: TCheckBox;
    procedure BClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BOkClick1(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPAFilter: TFPAFilter;

implementation

uses Kassa;

{$R *.DFM}

procedure TFPAFilter.BClearClick(Sender: TObject);
begin
  inherited;
  MENum.Clear;
  ENam.Clear;
  ENamAc.Clear;
  CBCur.Checked := false;
  CBAmount.Checked := false;
  CBBal.Checked := false;
  RBAct.Checked := false;
  RBPas.Checked := false;
  RBActPas.Checked := false;
  CBSub1.Text := '';
  CBSub2.Text := '';
  CBSub3.Text := '';
end;

procedure TFPAFilter.FormCreate(Sender: TObject);
begin
  inherited;
  BOk.OnClick := nil;
  BOk.OnClick := BOkClick1;
end;

procedure TFPAFilter.BOkClick1(Sender: TObject);
var
  qr: TIBQuery;
  sqls, SaldoStr, TempStr, Account: string;
  Cur,Amo,Bal,ParentSaldo: string;
  Sub1Id,Sub2Id,Sub3Id,ParentId: string;
  List: TStrings;
begin
  inherited;
// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  List := TStringList.Create;
  Cur := '';
  Amo := '';
  Bal := '';
  Sub1Id := '0';
  Sub2Id := '0';
  Sub3Id := '0';
  ParentId := 'Null';
  ParentSaldo := '';
  qr.Database:=Form1.IBDatabase;
  qr.Transaction:=Form1.IBTransaction;
  qr.Transaction.Active:=true;
  try
//    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    if (CBCur.Checked) then Cur := '*';
    if (CBAmount.Checked) then Amo := '*';
    if (CBBal.Checked) then Bal := '*';
    if RBAct.Checked then
      SaldoStr := RBAct.Caption;
    if RBPas.Checked then
      SaldoStr := RBPas.Caption;
    if RBActPas.Checked then
      SaldoStr := RBActPas.Caption;

    sqls := 'Select * from KINDSALDO where KS_NAME='+''#39''+SaldoStr+''#39'';
    qr.SQL.Add(sqls);
    qr.Open;
    SaldoStr := Trim(qr.FieldByName('KS_SHORTNAME').AsString);
    qr.Active := false;

    List := divide(MENum.Text);

    if (List.Strings[0]<>'') then begin
      Account := List.Strings[0];
      if (List.Strings[1]<>'') then begin
        Account := Account+'.'+List.Strings[1];
        if (List.Strings[2]<>'') then begin
          Account := Account+'.'+List.Strings[2];
        end;
      end;
    end;
    TempList.Clear;
    TempList.Add(Account);
    TempList.Add(ENam.Text);
    TempList.Add(ENamAc.Text);
    TempList.Add(Cur);
    TempList.Add(Amo);
    TempList.Add(Bal);
    TempList.Add(SaldoStr);
    TempList.Add(CBSub1.Text);
    TempList.Add(CBSub2.Text);
    TempList.Add(CBSub3.Text);
    inside := CheckBox.Checked;
//    Result:=true;
  finally
    qr.Free;
    List.Free;
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

end.
