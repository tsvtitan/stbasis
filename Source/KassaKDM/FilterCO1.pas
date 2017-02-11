unit FilterCO1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, Mask, StdCtrls,IBQuery,Kassa,Data,IB, ComCtrls, AddPlanAc;

type
  TFCOFilter = class(TFMaket)
    CBTOrder: TComboBox;
    ENum: TEdit;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    MEKorAc: TMaskEdit;
    GBKassa: TGroupBox;
    MEKassa: TMaskEdit;
    LCur: TLabel;
    ECur: TEdit;
    BCur: TButton;
    LEmp: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LSumDebit: TLabel;
    EEmp: TEdit;
    EBasis: TEdit;
    EAppend: TEdit;
    ESum: TEdit;
    LNDS: TLabel;
    ENDS: TEdit;
    BNDS: TButton;
    DateTime1: TDateTimePicker;
    DateTime2: TDateTimePicker;
    Label1: TLabel;
    Label4: TLabel;
    BClear: TButton;
    CheckBox: TCheckBox;
    Label7: TLabel;
    ECashier: TEdit;
    BCashier: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BCurClick(Sender: TObject);
    procedure BNDSClick(Sender: TObject);
    procedure CBTOrderChange(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure BClearClick(Sender: TObject);
    procedure BCashierClick(Sender: TObject);
  private
    { Private declarations }
  public
    CurId,NDSId,TDocId,CashierId: string;
  end;

var
  FCOFilter: TFCOFilter;

implementation

//uses Kassa;

{$R *.DFM}

procedure TFCOFilter.FormCreate(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
  inherited;
  DateTime1.Date := Date;
  DateTime2.Date := Date;
  qr := TIBQuery.Create(nil);
  qr.Database:=Form1.IBDatabase;
  qr.Transaction := Form1.IBTransaction;
  qr.Transaction.Active:=true;
  sqls := 'select * from DOCUMENTS where DOK_ID<>0';
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  qr.First;
  while not qr.EOF do begin
    CBTOrder.Items.Add(Trim(qr.FieldByName('DOK_NAME').AsString));
    qr.Next;
  end;
end;

procedure TFCOFilter.BCurClick(Sender: TObject);
var
   IdList: TStrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('CURRENCY','');
      if IdList.Count<>0 then begin
        CurId := IdList[0];
        ECur.Text := IdList[1];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCOFilter.BNDSClick(Sender: TObject);
var
   IdList: TStrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('NDS','');
      if IdList.Count<>0 then begin
        NDSId := IdList[0];
        ENDS.Text := IdList[1];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFCOFilter.CBTOrderChange(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
  inherited;
  qr := TIBQuery.Create(nil);
  qr.Database:=Form1.IBDatabase;
  qr.Transaction := Form1.IBTransaction;
  qr.Transaction.Active:=true;
  sqls := 'select * from DOCUMENTS where DOK_ID<>0 AND DOK_NAME='+QuotedStr(CBTOrder.Text);
  qr.SQL.Clear;
  qr.SQL.Add(sqls);
  qr.Open;
  if not qr.IsEmpty then begin
    TDocId := Trim(qr.FieldByName('DOK_ID').AsString);
  end;
end;

procedure TFCOFilter.BOkClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls, KorAccount,KasAccount: string;
  List, List1: TStrings;
begin
  inherited;
// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  List := TStringList.Create;
  List1 := TStringList.Create;
  qr.Database:=Form1.IBDatabase;
  qr.Transaction:=Form1.IBTransaction;
  qr.Transaction.Active:=true;
  try
//    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    List1 := divide(MEKorAc.Text);
    if (List1.Strings[0]<>'') then begin
      KorAccount := List1.Strings[0];
      if (List1.Strings[1]<>'') then begin
        KorAccount := KorAccount+'.'+List1.Strings[1];
        if (List1.Strings[2]<>'') then begin
          KorAccount := KorAccount+'.'+List1.Strings[2];
        end;
      end;
    end;
    List1.Clear;
    List1 := divide(MEKassa.Text);
    if (List1.Strings[0]<>'') then begin
      KasAccount := List1.Strings[0];
      if (List1.Strings[1]<>'') then begin
        KasAccount := KasAccount+'.'+List1.Strings[1];
        if (List1.Strings[2]<>'') then begin
          KasAccount := KasAccount+'.'+List1.Strings[2];
        end;
      end;
    end;
    List1.Clear;
    TempList.Clear;
    TempList.Add(TDocId);
    TempList.Add(ENum.Text);
    TempList.Add(DateToStr(DateTime1.Date));
    TempList.Add(DateToStr(DateTime2.Date));
    TempList.Add(KorAccount);
    TempList.Add(KasAccount);
    TempList.Add(CurId);
    TempList.Add(EEmp.Text);
    TempList.Add(EBasis.Text);
    TempList.Add(EAppend.Text);
    TempList.Add(ESum.Text);
    TempList.Add(NDSId);
    TempList.Add(Cashierid);
    inside := CheckBox.Checked;
//    Result:=true;
  finally
    qr.Free;
    List.Free;
    List1.Free;
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

procedure TFCOFilter.BClearClick(Sender: TObject);
begin
  inherited;
  CBTOrder.Text :='';
  TDocId := '';
  ENum.Text := '';
  DateTime1.Date := Date;
  DateTime2.Date := Date;
  MEKorAc.Text := '';
  MEKassa.Text := '';
  ECur.Text := '';
  CurId := '';
  EEmp.Text := '';
  EBasis.Text := '';
  EAppend.Text := '';
  ESum.Text := '';
  ENDS.Text := '';
  NDSId := '';
  CashierId:='';
  ECashier.Text := '';
end;

procedure TFCOFilter.BCashierClick(Sender: TObject);
var
   sqls: string;
   IdList: Tstrings;
begin
  inherited;
  try
    IdList := TStringList.Create;
    try
      IdList := CreateForms('EMP','');
      if IdList.Count<>0 then begin
        CashierId := IdList[0];
        ECashier.Text := IdList[1]+' '+IdList[2]+' '+IdList[3];
      end;
    finally
      IdList.Free;
      TempList.Clear;
    end;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
