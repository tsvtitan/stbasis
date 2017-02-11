unit UEditJRMagazinePostings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, Mask, ComCtrls, UFrameSubkonto;

type
  TfmEditJRMagazinePostings = class(TfmEditRB)
    PView: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    DTPDate: TDateTimePicker;
    GBDebit: TGroupBox;
    GBCredit: TGroupBox;
    PDoc: TPanel;
    Label1: TLabel;
    EDoc: TEdit;
    POper: TPanel;
    Label2: TLabel;
    LKolvo: TLabel;
    EKolvo: TEdit;
    ESumma: TEdit;
    Label8: TLabel;
    PFilter: TPanel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    DTPBeg: TDateTimePicker;
    CBDateFilter: TCheckBox;
    DTPFin: TDateTimePicker;
    CBNumFilter: TCheckBox;
    ENumBeg: TEdit;
    ENumFin: TEdit;
    BDebitFilter: TButton;
    MEDebitFilter: TMaskEdit;
    MECreditFilter: TMaskEdit;
    BCreditFilter: TButton;
    ENum: TEdit;
    Label3: TLabel;
    ENumPosting: TEdit;
    Label4: TLabel;
    cbInStringCopy: TCheckBox;
    FrameSubDT: TFrameSubkonto;
    FrameSubKT: TFrameSubkonto;
    DTPTime: TDateTimePicker;
    MEDebit: TMaskEdit;
    BDebit: TButton;
    MECredit: TMaskEdit;
    BCredit: TButton;
    GBCurrency: TGroupBox;
    BCursCur: TButton;
    ECursCur: TEdit;
    Label5: TLabel;
    BCur: TButton;
    ECur: TEdit;
    LCurrency: TLabel;
    mText: TMemo;
    Label6: TLabel;
    BDoc: TButton;
    procedure CBNumFilterClick(Sender: TObject);
    procedure CBDateFilterClick(Sender: TObject);
    procedure BDebitFilterClick(Sender: TObject);
    procedure BCreditFilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure BDebitClick(Sender: TObject);
    procedure BCreditClick(Sender: TObject);
    procedure BCurClick(Sender: TObject);
    procedure BCursCurClick(Sender: TObject);
    procedure ENumKeyPress(Sender: TObject; var Key: Char);
    procedure ESummaKeyPress(Sender: TObject; var Key: Char);
    procedure BDocClick(Sender: TObject);
  private
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function InsertSubkonto(id:integer): Boolean;
  public
    DebitId,CreditId,NumOper,NumPost,DocId,MP_ID: Integer;
    CurId,CursCur,Summa,Count: String;
    CurDt,CurCt,AmoDt,AmoCt: Boolean;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditJRMagazinePostings: TfmEditJRMagazinePostings;

implementation

uses UBookKeepingCode, UBookKeepingData, UMainUnited;

{$R *.DFM}

procedure TfmEditJRMagazinePostings.CBNumFilterClick(Sender: TObject);
begin
  inherited;
  Label13.Enabled := CBNumFilter.Checked;
  ENumBeg.Enabled := CBNumFilter.Checked;
  Label14.Enabled := CBNumFilter.Checked;
  ENumFin.Enabled := CBNumFilter.Checked;

end;

procedure TfmEditJRMagazinePostings.CBDateFilterClick(Sender: TObject);
begin
  inherited;
  Label9.Enabled := CBDateFilter.Checked;
  DTPBeg.Enabled := CBDateFilter.Checked;
  Label12.Enabled := CBDateFilter.Checked;
  DTPFin.Enabled := CBDateFilter.Checked;
end;

procedure TfmEditJRMagazinePostings.BDebitFilterClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
begin
  try
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       ChangeFlag:=true;
       MEDebitFilter.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditJRMagazinePostings.BCreditFilterClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
begin
  try
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       MECreditFilter.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditJRMagazinePostings.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditJRMagazinePostings.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditJRMagazinePostings.FormCreate(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  DebitId := 0;
  CreditId := 0;
  CurId := 'NULL';
  CurDt := false;
  CurCt := false;
  AmoDt := false;
  AmoCt := false;
  Count := 'NULL';
  NumOper := 0;
  NumPost := 0;
  DocId := 0;
  MP_ID := 0;
  DTPDate.DateTime := _GetDateTimeFromServer;
  DTPTime.DateTime := _GetDateTimeFromServer;
  try
    try
      qr:= TIBQuery.Create(nil);
      qr.Database := IBDB;
      qr.Transaction := IBTran;
      sqls := 'select max(MP_IDOPER) as MaxValue from '+tbMagazinePostings;
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then
        ENum.Text := IntToStr(qr.FieldByName('MaxValue').AsInteger+1);
    finally
      qr.free;
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

procedure TfmEditJRMagazinePostings.bibClearClick(Sender: TObject);
begin
  inherited;
  MEDebitFilter.Text:='';
  MECreditFilter.Text:='';
  CBNumFilter.Checked:=false;
  CBDateFilter.Checked:=false;
  DTPBeg.Date := _GetDateTimeFromServer;
  DTPFin.Date := _GetDateTimeFromServer;
end;

procedure TfmEditJRMagazinePostings.BDebitClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
begin
  try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='pa_id';
     TPRBI.Locate.KeyValues:=DebitId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       ChangeFlag:=true;
       DebitId := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_id');
       CurDt := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_currency')<>'';
       AmoDt := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_amount')<>'';
       GBCurrency.Enabled := CurDt or CurCt;
       LKolvo.Enabled := AmoDt or AmoCt;
       EKolvo.Enabled := AmoDt or AmoCt;
       if not GBCurrency.Enabled then begin
         ECur.Text := '';
         ECursCur.Text := '';
         CurId := 'NULL';
         CursCur := 'NULL';
       end;
       if not LKolvo.Enabled then begin
         EKolvo.Text := '';
         Count:='NULL';
       end;
       MEDebit.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
       FrameSubDt.InitData(DebitId,-1,tbMPSubkonto,'MP_ID','MPS_SUBKONTO_ID','MPS_DEBIT');
     end;
   finally
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

procedure TfmEditJRMagazinePostings.BCreditClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
begin
  try
   FillChar(TPRBI,SizeOf(TPRBI),0);
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     TPRBI.Visual.TypeView:=tvibvModal;
     TPRBI.Locate.KeyFields:='pa_id';
     TPRBI.Locate.KeyValues:=CreditId;
     TPRBI.Locate.Options:=[loCaseInsensitive];
     if DebitId<>0 then
       sqls := 'PA_ID IN (select KREDIT from ACCOUNTTYPE WHERE DEBIT='+
                       IntToStr(DebitId)+')';
     TPRBI.Condition.wherestr:=PChar(sqls);
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       ChangeFlag:=true;
       CreditId := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_id');
       MECredit.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       CurCt := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_currency')<>'';
       AmoCt := GetFirstValueFromParamRBookInterface(@TPRBI,'pa_amount')<>'';
       GBCurrency.Enabled := CurDt or CurCt;
       LKolvo.Enabled := AmoDt or AmoCt;
       EKolvo.Enabled := AmoDt or AmoCt;
       if not GBCurrency.Enabled then begin
         ECur.Text := '';
         ECursCur.Text := '';
         CurId := 'NULL';
         CursCur := 'NULL';
       end;
       if not LKolvo.Enabled then begin
         EKolvo.Text := '';
         Count:='NULL';
       end;
       EditChange(Sender);
       FrameSubKt.InitData(CreditId,-1,tbMPSubkonto,'MP_ID','MPS_SUBKONTO_ID','MPS_CREDIT');
     end;
   finally
     qr.Free;
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

procedure TfmEditJRMagazinePostings.BCurClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
  s: PChar;
  t: integer;
begin
  try
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if CurId<>'NULL' then begin
       TPRBI.Locate.KeyFields:='currency_id';
       TPRBI.Locate.KeyValues:=CurId;
       TPRBI.Locate.Options:=[loCaseInsensitive];
     end;
     if _ViewInterfaceFromName(NameRbkCurrency,@TPRBI) then begin
       CurId := GetFirstValueFromParamRBookInterface(@TPRBI,'currency_id');
       ECur.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'shortname');
       sqls := 'select * from ratecurrency where currency_id = '+CurId+
               'Order by indate';
       qr.SQL.Clear;
       qr.SQL.Add(sqls);
       qr.Open;
       qr.Last;
       if not qr.IsEmpty then begin
         ECursCur.Text := Trim(qr.FieldByName('factor').AsString);
         s:=PChar(ECursCur.Text);
         t := Pos(',',s);
         s[t-1]:='.';
         CursCur := s;
       end
       else begin
         ECursCur.Text := '';
         CursCur := 'NULL';
       end;
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditJRMagazinePostings.BCursCurClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
  s: PChar;
  t: integer;
begin
  try
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if CurId<>'NULL' then begin
       TPRBI.Condition.wherestr := PChar(tbRateCurrency+'.currency_id='+CurId);
     end;
     if _ViewInterfaceFromName(NameRbkRateCurrency,@TPRBI) then begin
       ECursCur.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'FACTOR');
       s:=PChar(ECursCur.Text);
       t := Pos(',',s);
       s[t-1]:='.';
       CursCur := s;
      end
       else begin
         ECursCur.Text := '';
         CursCur := 'NULL';
       end;
       EditChange(Sender);
   finally
     qr.Free;
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

procedure TfmEditJRMagazinePostings.ENumKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
    if (not(Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditJRMagazinePostings.ESummaKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (not (Key in ['0'..'9']))and((Char(Key)<>','))and((Integer(Key)<>VK_BACK)) then Key:=#0;
end;

function TfmEditJRMagazinePostings.AddToRBooks: Boolean;
var
 qr: TIBQuery;
 sqls,str: String;
// additon: String;
 InfUser: TInfoConnectUser;
 id: integer;
begin
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
 try
    FillChar(InfUser,SizeOf(InfUser),0);
    _GetInfoConnectUser(@InfUser);
    sqls := 'insert into '+tbMagazinePostings+
            ' (MP_ID,MP_DOCUM_ID,MP_CREDIT,MP_DEBIT,MP_DATE,MP_CONTENTSOPERA,'+
            'MP_COUNT,MP_SUMMA,MP_CURRENCY_ID,MP_CURSCURRENCY,MP_WHOADD,MP_DATEADD,'+
            'MP_WHOCHANGE,MP_DATECHANGE,MP_IDOPER,MP_NUMPOST) values ('+
            ' gen_id(gen_MagazinePostings_ID,1),'+
            IntToStr(DocId)+','+
            IntToStr(CreditId)+','+
            IntToStr(DebitId)+','+
            QuotedStr(DateToStr(DTPDate.Date)+' '+TimeToStr(DTPTime.Time))+','+
            QuotedStr(mText.Lines.Text)+','+
            Count+','+
            Summa+','+
            CurId+','+
            CursCur+','+
            IntToStr(InfUser.User_id)+','+
            QuotedStr(DateTimeToStr(_GetDateTimeFromServer))+','+
            IntToStr(InfUser.User_id)+','+
            QuotedStr(DateTimeToStr(_GetDateTimeFromServer))+','+
            IntToStr(NumOper)+','+
            IntToStr(NumPost)+')';
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    id := GetGenId(IBDB,tbMagazinePostings,0);
    InsertSubkonto(id);
    qr.Transaction.Commit;
    Result:=true;
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
end;

procedure TfmEditJRMagazinePostings.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

procedure TfmEditJRMagazinePostings.ChangeClick(Sender: TObject);
begin
  if ChangeFlag or FrameSubDt.ChangeFlag or FrameSubKt.ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditJRMagazinePostings.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if (Trim(EDoc.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label1.Caption]));
    EDoc.SetFocus;
    Result:=false;
    exit;
  end;
  if (Trim(ENum.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label3.Caption]));
    ENum.SetFocus;
    Result:=false;
    exit;
  end
  else begin
      try
        NumOper := StrToInt(Trim(ENum.Text));
      except
        ShowError(Handle,'Неверный формат числа');
        ENum.SetFocus;
        Result:=false;
        exit
      end;
  end;
  if (Trim(ENumPosting.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label4.Caption]));
    ENumPosting.SetFocus;
    Result:=false;
    exit;
  end
  else begin
      try
        NumPost := StrToInt(Trim(ENumPosting.Text));
      except
        ShowError(Handle,'Неверный формат числа');
        ENumPosting.SetFocus;
        Result:=false;
        exit
      end;
  end;
  if (DebitId=0) then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[GBDebit.Caption]));
    BDebit.SetFocus;
    Result:=false;
    exit;
  end;
  if not FrameSubDT.CheckFieldsFill then begin
    Result:=false;
    exit;
  end;
  if (CreditId=0) then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[GBCredit.Caption]));
    BCredit.SetFocus;
    Result:=false;
    exit;
  end;
  if not FrameSubKT.CheckFieldsFill then begin
    Result:=false;
    exit;
  end;
  if (GBCurrency.Enabled) and (CurId='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LCurrency.Caption]));
    BCur.SetFocus;
    Result:=false;
    exit;
  end;
  if (GBCurrency.Enabled) then begin
    if(ECursCur.Text='') then begin
      ShowError(Handle,Format(ConstFieldNoEmpty,[Label5.Caption]));
      BCursCur.SetFocus;
      Result:=false;
      exit;
    end
    else begin
      try
        CursCur := FormatFloat('0.00',StrToFloat(ECursCur.Text));
        CursCur := ChangeSymbol(CursCur,',','.');
      except
        ShowError(Handle,'Неверный формат суммы');
        ECursCur.SetFocus;
        Result:=false;
        exit
      end;
    end;
  end;
  if (Trim(ESumma.Text)='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[Label8.Caption]));
    ESumma.SetFocus;
    Result:=false;
    exit;
  end
  else begin
    try
      Summa := FormatFloat('0.00',StrToFloat(ESumma.Text));
      Summa := ChangeSymbol(Summa,',','.');
    except
      ShowError(Handle,'Неверный формат суммы');
      ESumma.SetFocus;
      Result:=false;
      exit;
    end;
  end;
  if (LKolvo.Enabled) then begin
   if(EKolvo.Text='NULL') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LKolvo.Caption]));
    EKolvo.SetFocus;
    Result:=false;
    exit;
   end
   else begin
     try
      Count := FormatFloat('0',StrToFloat(EKolvo.Text));
      Count := ChangeSymbol(Count,',','.');
     except
      ShowError(Handle,'Неверный формат числа');
      EKolvo.SetFocus;
      Result:=false;
      exit;
     end;
   end;
  end;
end;

procedure TfmEditJRMagazinePostings.BDocClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  try
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if DocId<>0 then begin
       TPRBI.Locate.KeyFields:='docum_id';
       TPRBI.Locate.KeyValues:=DocId;
       TPRBI.Locate.Options:=[loCaseInsensitive];
     end;
     if _ViewInterfaceFromName(NameJrDocum,@TPRBI) then begin
       EDoc.Text := VarToStr(GetFirstValueFromPJI(@TPRBI,'typedocname'))+' № '+
                    VarToStr(GetFirstValueFromPJI(@TPRBI,'prefixnumsufix'))+ ' от '+
                    VarToStr(GetFirstValueFromPJI(@TPRBI,'datedoc'));
       DocId := GetFirstValueFromPJI(@TPRBI,'docum_id');
       ENum.Text := GetFirstValueFromPJI(@TPRBI,'NUM');
       NumOper := GetFirstValueFromPJI(@TPRBI,'NUM');
       DTPDate.Date := GetFirstValueFromPJI(@TPRBI,'DATEDOC');
       DTPTime.Time := GetFirstValueFromPJI(@TPRBI,'DATEDOC');
       ENumPosting.Text := '1';
       NumPost := 1;
       ENum.ReadOnly := true;
       DTPDate.Enabled := false;
       DTPTime.Enabled := false;
      end;
      EditChange(Sender);
   finally
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

function TfmEditJRMagazinePostings.InsertSubkonto(id:integer): Boolean;
var
 qr: TIBQuery;
 sqls,str: String;
 i,AddSubId: integer;
begin
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  Result := false;
 try
   i:=1;
   str:='NULL';
    while FrameSubDt.idInSub[i] <> 0 do begin
      AddSubId:=FrameSubKT.NameSubkonto.IndexOf(FrameSubDT.NameSubkonto[i-1]);
      if (AddSubId<>-1) and (FrameSubKT.idInSub[AddSubId-1]<>0) then
        str := IntToStr(FrameSubKT.idInSub[AddSubId-1])
      else
        str := 'NULL';  
      sqls := 'insert into '+tbMPSubkonto+
              ' (mp_id,mps_subkonto_id,mps_debit,mps_credit)'+
              'values('+IntToStr(id)+','+
              IntToStr(FrameSubDt.idSub[i])+','+
              IntToStr(FrameSubDt.idInSub[i])+','+
              str+')';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      i:=i+1;
    end;
   i:=1;
   str:='NULL';
    while FrameSubKt.idInSub[i] <> 0 do begin
      AddSubId:=FrameSubDT.NameSubkonto.IndexOf(FrameSubKT.NameSubkonto[i-1]);
      if (AddSubId=-1) or ((AddSubId<>-1) and (FrameSubDT.idInSub[AddSubId-1]=0)) then begin
        sqls := 'insert into '+tbMPSubkonto+
                ' (mp_id,mps_subkonto_id,mps_debit,mps_credit)'+
                'values('+IntToStr(id)+','+
                IntToStr(FrameSubKt.idSub[i])+','+
                str+','+
                IntToStr(FrameSubKt.idInSub[i])+')';
        qr.SQL.Clear;
        qr.SQL.Add(sqls);
        qr.ExecSQL;
      end;
      i:=i+1;
    end;

//    qr.Transaction.Commit;
    Result:=true;
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
end;

function TfmEditJRMagazinePostings.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id2: string;
  InfUser: TInfoConnectUser;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    FillChar(InfUser,SizeOf(InfUser),0);
    _GetInfoConnectUser(@InfUser);
    sqls := 'Update '+tbMagazinePostings+
            ' set MP_DOCUM_ID='+IntToStr(DocId)+','+
            ' MP_CREDIT='+IntToStr(CreditId)+','+
            ' MP_DEBIT='+IntToStr(DebitId)+','+
            ' MP_DATE='+QuotedStr(DateToStr(DTPDate.Date)+' '+TimeToStr(DTPTime.Time))+','+
            ' MP_CONTENTSOPERA='+QuotedStr(mText.Lines.Text)+','+
            ' MP_COUNT='+Count+','+
            ' MP_SUMMA='+Summa+','+
            ' MP_CURRENCY_ID='+CurId+','+
            ' MP_CURSCURRENCY='+CursCur+','+
            ' MP_WHOCHANGE='+IntToStr(InfUser.User_id)+','+
            ' MP_DATECHANGE='+QuotedStr(DateTimeToStr(_GetDateTimeFromServer))+','+
            ' MP_IDOPER='+IntToStr(NumOper)+','+
            ' MP_NUMPOST='+IntToStr(NumPost)+
            ' where MP_ID='+IntToStr(MP_ID);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    sqls := 'delete from '+tbMPSubkonto+
            ' where MP_ID='+IntToStr(MP_ID);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    InsertSubkonto(MP_ID);
    qr.Transaction.Commit;
    Result:=true;
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
end;

end.
