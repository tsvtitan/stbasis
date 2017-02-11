unit AddPlanAc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls, ExtCtrls, Mask, DBCtrls, Db, IBCustomDataSet, IBTable,
  IBQuery, Data, IB, Grids, DBGrids;

type
  TFAddAccount = class(TFMaket)
    Label1: TLabel;
    Label2: TLabel;
    MENum: TMaskEdit;
    ENam: TEdit;
    Label3: TLabel;
    ENamAc: TEdit;
    Panel1: TPanel;
    CBCur: TCheckBox;
    CBAmount: TCheckBox;
    CBBal: TCheckBox;
    RBAct: TRadioButton;
    RBPas: TRadioButton;
    RBActPas: TRadioButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CBSub1: TComboBox;
    CBSub2: TComboBox;
    CBSub3: TComboBox;
    IBTable: TIBQuery;
    procedure FormCreate(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  end;

var
  FAddAccount: TFAddAccount;

implementation

uses Kassa;

{$R *.DFM}

procedure TFAddAccount.FormCreate(Sender: TObject);
var
  i,c: integer;
  qr: TIBQuery;
  sqls: string;
begin
  inherited;
  qr := TIBQuery.Create(nil);
  qr.Database:=Form1.IBDatabase;
  qr.Transaction:=Form1.IBTransaction;
  qr.Transaction.Active:=true;
  sqls := 'select count(*) as ctn from KINDSUBKONTO';
  qr.SQL.Add(sqls);
  qr.Open;
  try
    if not IBTable.Active then
      IBTable.Active := True;
    IBTable.First;
    for i:=0 to qr.FieldByName('ctn').AsInteger-1 do begin
      c :=IBTable.FieldByName('SUBKONTO_ID').AsInteger;
      if (c<>0) then begin
        CBSub1.Items.Add(Trim(IBTable.FieldByName('SUBKONTO_NAME').AsString));
        CBSub2.Items.Add(Trim(IBTable.FieldByName('SUBKONTO_NAME').AsString));
        CBSub3.Items.Add(Trim(IBTable.FieldByName('SUBKONTO_NAME').AsString));
      end;
      IBTable.Next;
    end;
    BOk.OnClick := BOkClick;
    OnKeyDown := FormKeyDown;
    qr.Free;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFAddAccount.BOkClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls, SaldoStr, TempStr, Account: string;
  Cur,Amo,Bal,ParentSaldo: string;
  SaldoID,Sub1Id,Sub2Id,Sub3Id,ParentId: string;
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

    qr.Database:=Form1.IBDatabase;
    qr.Transaction:=Form1.IBTransaction;
    qr.Transaction.Active:=true;

    sqls := 'Select KS_ID from KINDSALDO where KS_NAME='+''#39''+SaldoStr+''#39'';
    qr.SQL.Add(sqls);
    qr.Open;
    SaldoId := Trim(qr.FieldByName('KS_ID').AsString);
    qr.Active := false;

    if CBSub1.Text<>'' then begin
      IBTable.Locate('SUBKONTO_NAME',CBSub1.Text,[loCaseInsensitive]);
      Sub1Id := Trim(IBTable.FieldByName('SUBKONTO_ID').AsString);
    end;
    if CBSub2.Text<>'' then begin
      IBTable.Locate('SUBKONTO_NAME',CBSub2.Text,[loCaseInsensitive]);
      Sub2Id := Trim(IBTable.FieldByName('SUBKONTO_ID').AsString);
    end;
    if CBSub3.Text<>'' then begin
      IBTable.Locate('SUBKONTO_NAME',CBSub3.Text,[loCaseInsensitive]);
      Sub3Id := Trim(IBTable.FieldByName('SUBKONTO_ID').AsString);
    end;

    List := divide(MENum.Text);

    if (List.Strings[2]<>'') and ((List.Strings[0]='') or (List.Strings[1]='')) then begin
      Application.MessageBox(PChar('Некорректный ввод номера счета'),PChar('Ошибка'),
      MB_OK+MB_ICONERROR);
      Abort;
    end;
    if (List.Strings[1]<>'') and (List.Strings[2]='') and (List.Strings[0]='') then begin
      Application.MessageBox(PChar('Некорректный ввод номера счета'),PChar('Ошибка'),
      MB_OK+MB_ICONERROR);
      Abort;
    end;

    if List.Strings[2]<>'' then begin
      sqls := 'Select * from PLANACCOUNTS'+
              ' where PA_GROUPID Like('#39''+List.Strings[0]+'.'+List.Strings[1]+''#39')';
      qr.Active := false;
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if (qr.IsEmpty) then begin
        Application.MessageBox(PChar('Для создаваемого субсчета <'+List.Strings[0]+'.'+
        List.Strings[1]+'.'+List.Strings[2]+'> нет счета-папки <'+List.Strings[0]+'.'+
        List.Strings[1]+'>'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
      end
      else begin
        ParentId := Trim(qr.FieldByName('PA_ID').AsString);
        ParentSaldo := Trim(qr.FieldByName('PA_KS_ID').AsString);
      end;
    end;
    if (List.Strings[1]<>'') and (List.Strings[2]='') then begin
      sqls := 'Select * from PLANACCOUNTS'+
              ' where PA_GROUPID Like('#39''+List.Strings[0]+''#39')';
      qr.Active := false;
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if (qr.IsEmpty) then begin
        Application.MessageBox(PChar('Для создаваемого субсчета <'+List.Strings[0]+'.'+
        List.Strings[1]+'> нет счета-папки <'+List.Strings[0]+'>'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;
      end
      else begin
        ParentId := Trim(qr.FieldByName('PA_ID').AsString);
        ParentSaldo := Trim(qr.FieldByName('PA_KS_ID').AsString);
      end;
    end;

    if (ParentSaldo<>SaldoId) and (List.Strings[1]<>'') then begin
        Application.MessageBox(PChar('Для создаваемого субсчета сальдо'+
        ' должно быть таким же как у счета-папки'),PChar('Ошибка'), MB_OK+MB_ICONERROR);
        Abort;

    end;
    if (ENam.Text='')or (ENamAc.Text='') then begin
      Application.MessageBox(PChar('Введите имя и полное наименование'),PChar('Ошибка'),MB_OK+MB_ICONERROR);
      Abort;
    end;
    if (List.Strings[0]<>'') then begin
      Account := List.Strings[0];
      if (List.Strings[1]<>'') then begin
        Account := Account+'.'+List.Strings[1];
        if (List.Strings[2]<>'') then begin
          Account := Account+'.'+List.Strings[2];
        end;
      end;
    end;
        sqls:='Insert into PLANACCOUNTS'+
          ' (PA_ID,PA_GROUPID,PA_PARENTID,PA_SHORTNAME,PA_CURRENCY,PA_AMOUNT,'+
          'PA_BALANCE,PA_KS_ID,PA_SUBKONTO1,PA_SUBKONTO2,PA_SUBKONTO3,'+
          'PA_NAMEACCOUNT) values '+
          ' (gen_id(gen_planaccounts_id,1),'+QuotedStr(Trim(Account))+','+(Trim(ParentId))+','+QuotedStr(Trim(ENam.Text))+','+
           QuotedStr(Trim(Cur))+','+QuotedStr(Trim(Amo))+','+QuotedStr(Trim(Bal))+','+QuotedStr(Trim(SaldoId))+','+
           (Trim(Sub1Id))+','+(Trim(Sub2Id))+','+
           (Trim(Sub3Id))+','+QuotedStr(Trim(ENamAc.Text))+')';

    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := True;    

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

procedure TFAddAccount.FormKeyDown(Sender: TObject; var Key: Word;
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

end.
