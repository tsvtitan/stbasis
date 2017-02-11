unit OTIZSeatClassEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXSpin, CurrEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls,
  Mask, ToolEdit;

type
  TfrmSeatClassEdit = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label71: TLabel;
    ComboEdit1: TComboEdit;
    ComboEdit2: TComboEdit;
    ComboEdit3: TComboEdit;
    Button1: TButton;
    Button2: TButton;
    EditCurDepart: TEdit;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    Label4: TLabel;
    CurrencyEdit1: TCurrencyEdit;
    Label5: TLabel;
    CurrencyEdit2: TCurrencyEdit;
    Label6: TLabel;
    RxSpinEdit1: TRxSpinEdit;
    Label7: TLabel;
    CurrencyEdit3: TCurrencyEdit;
    Label8: TLabel;
    RxSpinEdit2: TRxSpinEdit;
    Label9: TLabel;
    RxSpinEdit3: TRxSpinEdit;
    procedure ComboEdit1ButtonClick(Sender: TObject);
    procedure ComboEdit2ButtonClick(Sender: TObject);
    procedure ComboEdit3ButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
  private
   CurID,CurDepartID:Integer;
   CurDepart:String;
   GetNewID:Boolean;
  public
  end;

function AddSeatClass(Depart_ID:Integer):Boolean;
function EditSeatClass(Depart_ID,SeatClass_ID:Integer):Boolean;
function DeleteSeatClass(SeatClass_ID:Integer):Boolean;

implementation

{$R *.DFM}

uses StrUtils, NTimeData, UMainUnited, NTimeCode;

function AddSeatClass(Depart_ID:Integer):Boolean;
var frmSeatClassEdit: TfrmSeatClassEdit;
begin
 Result:=False;
 frmSeatClassEdit:=TfrmSeatClassEdit.Create(Application);
 with frmSeatClassEdit do
 try
  CurDepartID:=Depart_ID;
  ChangeDatabase(frmSeatClassEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select name from depart where depart_id=%d',[Depart_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else CurDepart:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Добавить штатные единицы';
  EditCurDepart.Text:=CurDepart;
  GetNewID:=True;
  Result:=frmSeatClassEdit.ShowModal=mrOK;
 finally
  frmSeatClassEdit.Free;
 end;
end;

function EditSeatClass(Depart_ID,SeatClass_ID:Integer):Boolean;
var frmSeatClassEdit: TfrmSeatClassEdit;
begin
 Result:=False;
 frmSeatClassEdit:=TfrmSeatClassEdit.Create(Application);
 with frmSeatClassEdit do
 try
  CurDepartID:=Depart_ID;
  ChangeDatabase(frmSeatClassEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select name from depart where depart_id=%d',[Depart_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then CurDepart:=''
   else CurDepart:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  quTemp.SQL.Text:=Format('select sc.*,s.name as seatname,c.num as classname,d.num as documname from seatclass sc '+
   'left join seat s on s.seat_id=sc.seat_id '+
   'left join class c on c.class_id=sc.class_id '+
   'left join docum d on d.docum_id=sc.docum_id '+
   'where seatclass_id=%d',[SeatClass_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    ComboEdit1.Tag:=quTemp.FieldByName('seat_id').AsInteger;
    ComboEdit2.Tag:=quTemp.FieldByName('class_id').AsInteger;
    ComboEdit3.Tag:=quTemp.FieldByName('docum_id').AsInteger;
    ComboEdit1.Text:=quTemp.FieldByName('seatname').AsString;
    ComboEdit2.Text:=quTemp.FieldByName('classname').AsString;
    ComboEdit3.Text:=quTemp.FieldByName('documname').AsString;
    CurrencyEdit1.Text:=quTemp.FieldByName('minpay').AsString;
    CurrencyEdit2.Text:=quTemp.FieldByName('maxpay').AsString;
    RxSpinEdit1.Value:=quTemp.FieldByName('staffcount').AsInteger;
    CurrencyEdit3.Text:=quTemp.FieldByName('addpay').AsString;
    RxSpinEdit2.Value:=quTemp.FieldByName('northfactor').Asfloat;
    RxSpinEdit3.Value:=quTemp.FieldByName('regionfactor').Asfloat;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить штатные единицы';
  EditCurDepart.Text:=CurDepart;
  CurID:=SeatClass_ID;
  GetNewID:=False;
  Result:=frmSeatClassEdit.ShowModal=mrOK;
 finally
  frmSeatClassEdit.Free;
 end;
end;

function DeleteSeatClass(SeatClass_ID:Integer):Boolean;
var frmSeatClassEdit: TfrmSeatClassEdit;
begin
 Result:=False;
 frmSeatClassEdit:=TfrmSeatClassEdit.Create(Application);
 with frmSeatClassEdit do
 try
  ChangeDatabase(frmSeatClassEdit,dbSTBasis);
  if ShowQuestion(Handle,'Удалить запись о щтатных еденицах?')=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from seatclass where seatclass_id=%d',[SeatClass_ID]);
   if not trTemp.InTransaction then trTemp.StartTransaction;
   try
    quTemp.ExecSQL;
    trTemp.Commit;
    Result:=True;
   except
    trTemp.Rollback;
   end;
  end;
 finally
  frmSeatClassEdit.Free;
 end;
end;

procedure TfrmSeatClassEdit.ComboEdit1ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 FillChar(Data,SizeOf(Data),0);  ////////////////////////////////////////////////////////////////
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='seat_id';
 Data.Locate.KeyValues:=ComboEdit1.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameSeat,@Data) then
 begin
  ComboEdit1.Tag:=GetFirstValueFromParamRBookInterface(@Data,'seat_id');
  quTemp.SQL.Text:=Format('select name from seat where seat_id=%d',[ComboEdit1.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit1.Text:=''
    else ComboEdit1.Text:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;
end;

procedure TfrmSeatClassEdit.ComboEdit2ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 FillChar(Data,SizeOf(Data),0);
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='class_id';
 Data.Locate.KeyValues:=ComboEdit2.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameClass,@Data) then
 begin
  ComboEdit2.Tag:=GetFirstValueFromParamRBookInterface(@Data,'class_id');
//  ComboEdit2.Text:=GetFirstValueFromParamRBookInterface(@Data,'num');
  quTemp.SQL.Text:=Format('select num from class where class_id=%d',[ComboEdit2.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit2.Text:=''
    else ComboEdit2.Text:=quTemp.FieldByName('num').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;
end;

procedure TfrmSeatClassEdit.ComboEdit3ButtonClick(Sender: TObject);
var
 //Data:TParamRBookInterface;
 Data:TParamJournalInterface;
begin
 FillChar(Data,SizeOf(Data),0);
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='docum_id';
 Data.Locate.KeyValues:=ComboEdit3.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameDocument,@Data) then
 begin
  ComboEdit3.Tag:=GetFirstValueFromParamJournalInterface(@Data,'docum_id');
  quTemp.SQL.Text:=Format('select num from docum where docum_id=%d',[ComboEdit3.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit3.Text:=''
    else ComboEdit3.Text:=quTemp.FieldByName('num').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;
{ Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='docum_id';
 Data.Locate.KeyValues:=ComboEdit3.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameDocument,@Data) then
 begin
  ComboEdit3.Tag:=GetFirstValueFromParamRBookInterface(@Data,'docum_id');
  quTemp.SQL.Text:=Format('select num from docum where docum_id=%d',[ComboEdit3.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit3.Text:=''
    else ComboEdit3.Text:=quTemp.FieldByName('num').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;}
end;

procedure TfrmSeatClassEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var SeatClass_ID:Integer;
    DoSQLStr,ValueStr:String;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if ComboEdit1.Enabled and (ComboEdit1.Text='') then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label1.Caption]));
   ComboEdit1.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if ComboEdit2.Enabled and (ComboEdit2.Text='') then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label2.Caption]));
   ComboEdit2.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if ComboEdit3.Enabled and (ComboEdit3.Text='') then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label3.Caption]));
   ComboEdit3.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if CurrencyEdit1.Enabled and (CurrencyEdit1.Text='') then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label4.Caption]));
   CurrencyEdit1.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if CurrencyEdit2.Enabled and (CurrencyEdit2.Text='') then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label5.Caption]));
   CurrencyEdit2.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then
  begin
   SeatClass_ID:=GetGenId(dbSTBasis,tbSeatClass,1);
   DoSQLStr:='';ValueStr:='';
   if Label1.Enabled then begin DoSQLStr:=DoSQLStr+'seat_id,';ValueStr:=ValueStr+IntToStr(ComboEdit1.Tag)+','; end;
   if Label2.Enabled then begin DoSQLStr:=DoSQLStr+'class_id,';ValueStr:=ValueStr+IntToStr(ComboEdit2.Tag)+','; end;
   if Label3.Enabled then begin DoSQLStr:=DoSQLStr+'docum_id,';ValueStr:=ValueStr+IntToStr(ComboEdit3.Tag)+','; end;
   if Label4.Enabled then begin DoSQLStr:=DoSQLStr+'minpay,';ValueStr:=ValueStr+ReplaceStr(FloatToStr(CurrencyEdit1.Value),',','.')+','; end;
   if Label5.Enabled then begin DoSQLStr:=DoSQLStr+'maxpay,';ValueStr:=ValueStr+ReplaceStr(FloatToStr(CurrencyEdit2.Value),',','.')+','; end;
   if Label6.Enabled then begin DoSQLStr:=DoSQLStr+'staffcount,';ValueStr:=ValueStr+IntToStr(RxSpinEdit1.AsInteger)+','; end;
   if Label7.Enabled then begin DoSQLStr:=DoSQLStr+'addpay,';ValueStr:=ValueStr+ReplaceStr(FloatToStr(CurrencyEdit3.Value),',','.')+','; end;
   if Label8.Enabled then begin DoSQLStr:=DoSQLStr+'northfactor,';ValueStr:=ValueStr+ReplaceStr(FloatToStr(RxSpinEdit2.Value),',','.')+','; end;
   if Label9.Enabled then begin DoSQLStr:=DoSQLStr+'regionfactor,';ValueStr:=ValueStr+ReplaceStr(FloatToStr(RxSpinEdit3.Value),',','.')+','; end;
   DoSQLStr:='insert into seatclass ('+DoSQLStr+'depart_id,seatclass_id) values ('+ValueStr+'%d,%d)';
  end
  else
  begin
   SeatClass_ID:=CurID;
   DoSQLStr:='';ValueStr:='';
   if Label1.Enabled then begin DoSQLStr:=DoSQLStr+'seat_id='+IntToStr(ComboEdit1.Tag)+','; end;
   if Label2.Enabled then begin DoSQLStr:=DoSQLStr+'class_id='+IntToStr(ComboEdit2.Tag)+','; end;
   if Label3.Enabled then begin DoSQLStr:=DoSQLStr+'docum_id='+IntToStr(ComboEdit3.Tag)+','; end;
   if Label4.Enabled then begin DoSQLStr:=DoSQLStr+'minpay='+ReplaceStr(FloatToStr(CurrencyEdit1.Value),',','.')+','; end;
   if Label5.Enabled then begin DoSQLStr:=DoSQLStr+'maxpay='+ReplaceStr(FloatToStr(CurrencyEdit2.Value),',','.')+','; end;
   if Label6.Enabled then begin DoSQLStr:=DoSQLStr+'staffcount='+IntToStr(RxSpinEdit1.AsInteger)+','; end;
   if Label7.Enabled then begin DoSQLStr:=DoSQLStr+'addpay='+ReplaceStr(FloatToStr(CurrencyEdit3.Value),',','.')+','; end;
   if Label8.Enabled then begin DoSQLStr:=DoSQLStr+'northfactor='+ReplaceStr(FloatToStr(RxSpinEdit2.Value),',','.')+','; end;
   if Label9.Enabled then begin DoSQLStr:=DoSQLStr+'regionfactor='+ReplaceStr(FloatToStr(RxSpinEdit3.Value),',','.')+','; end;
   DoSQLStr:='update seatclass set '+DoSQLStr+'depart_id=%d where seatclass_id=%d';
  end;
  quTemp.SQL.Text:=Format(DoSQLStr,[CurDepartID,SeatClass_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.ExecSQL;
   trTemp.Commit;
  except
   on E: Exception do begin// ShowInfo(Handle,E.message);
   trTemp.Rollback;
   CanClose:=False;
   end;
  end;
 end;
end;

procedure TfrmSeatClassEdit.FormActivate(Sender: TObject);
const
    FCount=12;
    F:array[1..FCount] of string=('seat_id','seatname','class_id',
                             'classname','docum_id','documname',
                             'minpay','maxpay','staffcount',
                             'addpay','northfactor','regionfactor');
var C:String;
    I,S:Integer;
begin
 if GetNewID then C:=InsConst else C:=UpdConst;

 S:=0;
 for I:=1 to FCount do
  if not _isPermissionColumn(PChar(tbSeatClass),PChar(F[I]),PChar(C)) then Inc(S);

 if S=FCount then Exit;

 Label1.Enabled:=_isPermissionColumn(tbSeatClass,'seat_id',PChar(C));
 ComboEdit1.Enabled:=Label1.Enabled;
 Label2.Enabled:=_isPermissionColumn(tbSeatClass,'class_id',PChar(C));
 ComboEdit2.Enabled:=Label2.Enabled;
 Label3.Enabled:=_isPermissionColumn(tbSeatClass,'docum_id',PChar(C));
 ComboEdit3.Enabled:=Label3.Enabled;

 Label4.Enabled:=_isPermissionColumn(tbSeatClass,'minpay',PChar(C));
 CurrencyEdit1.Enabled:=Label4.Enabled;
 if CurrencyEdit1.Enabled then CurrencyEdit1.Color:=clWindow else CurrencyEdit1.Color:=clBtnFace;
 Label5.Enabled:=_isPermissionColumn(tbSeatClass,'maxpay',PChar(C));
 CurrencyEdit2.Enabled:=Label5.Enabled;
 if CurrencyEdit2.Enabled then CurrencyEdit2.Color:=clWindow else CurrencyEdit2.Color:=clBtnFace;

 Label6.Enabled:=_isPermissionColumn(tbSeatClass,'staffcount',PChar(C));
 RxSpinEdit1.Enabled:=Label6.Enabled;
 if RxSpinEdit1.Enabled then RxSpinEdit1.Color:=clWindow else RxSpinEdit1.Color:=clBtnFace;

 Label7.Enabled:=_isPermissionColumn(tbSeatClass,'addpay',PChar(C));
 CurrencyEdit3.Enabled:=Label7.Enabled;
 if CurrencyEdit3.Enabled then CurrencyEdit3.Color:=clWindow else CurrencyEdit3.Color:=clBtnFace;

 Label8.Enabled:=_isPermissionColumn(tbSeatClass,'northfactor',PChar(C));
 RxSpinEdit2.Enabled:=Label8.Enabled;
 if RxSpinEdit2.Enabled then RxSpinEdit2.Color:=clWindow else RxSpinEdit2.Color:=clBtnFace;
 Label9.Enabled:=_isPermissionColumn(tbSeatClass,'regionfactor',PChar(C));
 RxSpinEdit3.Enabled:=Label9.Enabled;
 if RxSpinEdit3.Enabled then RxSpinEdit3.Color:=clWindow else RxSpinEdit3.Color:=clBtnFace;
end;

end.
