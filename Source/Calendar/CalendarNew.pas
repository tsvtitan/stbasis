unit CalendarNew;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, ExtCtrls, IBDatabase, Db, IBCustomDataSet,
  IBQuery, IBStoredProc, RXSpin;

type
  TfrmCalendarNew = class(TForm)
    ComboEdit1: TComboEdit;
    Label1: TLabel;
    btnOK: TButton;
    btnClose: TButton;
    Label2: TLabel;
    DateEdit1: TDateEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    Label3: TLabel;
    RxSpinEdit1: TRxSpinEdit;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RadioButtonsClick(Sender: TObject);
    procedure ComboEdit1ButtonClick(Sender: TObject);
  private
   BaseOn:Integer;
   procedure UpdateView;
  public
  end;

function NewCalendar(ABaseOn:Integer):Boolean;

implementation

uses DateUtil, CalendarData, UMainUnited, CalendarCode;

{$R *.DFM}

function NewCalendar(ABaseOn:Integer):Boolean;
var
  frmCalendarNew: TfrmCalendarNew;
begin
 frmCalendarNew:=TfrmCalendarNew.Create(Application);
 with frmCalendarNew do
 try
  ChangeDatabase(frmCalendarNew,dbSTBasis);

  BaseOn:=ABaseOn;
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[BaseOn]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then RadioButton1.Enabled:=False else
   begin
    RadioButton1.Caption:=FormatDateTime('Копировать данные из календаря от dd mmmm yyyyг.',quTemp.FieldByName('startdate').AsDateTime);
    RadioButton1.Checked:=True;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  UpdateView;
  Result:=frmCalendarNew.ShowModal=mrOK;
 finally
  frmCalendarNew.Free;
 end;
end;

procedure TfrmCalendarNew.UpdateView;
begin
 GroupBox2.Enabled:=RadioButton1.Checked;
 CheckBox1.Enabled:=RadioButton1.Checked;
 CheckBox2.Enabled:=RadioButton1.Checked;
 CheckBox3.Enabled:=RadioButton1.Checked;
end;

procedure TfrmCalendarNew.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);

procedure CopyCalendar(FromID,ToID:Integer);
begin
 if CheckBox1.Checked then
 begin
  quTemp.SQL.Text:='insert into holiday (calendar_id,holiday_id,name,holiday) select '+
   IntToStr(ToID)+' as calendar_id,gen_id(gen_holiday_id,1) as holiday_id,name,holiday from holiday where calendar_id='+IntToStr(FromID);
  quTemp.ExecSQL;
  quTemp.SQL.Text:='update holiday h1 set h1.holiday=(select cast(extract(month from h2.holiday) || ''/'' ||'+
  ' extract(day from h2.holiday) || ''/'' || '+
  ' extract(year from (select startdate from calendar where calendar_id='+IntToStr(ToID)+')) as date)'+
  ' from holiday h2 where h2.holiday_id=h1.holiday_id) where calendar_id='+IntToStr(ToID);
  quTemp.ExecSQL;
 end;
 if CheckBox2.Checked then
 begin
  quTemp.SQL.Text:='insert into carry (calendar_id,carry_id,fromdate,todate,description) select '+
   IntToStr(ToID)+' as calendar_id,gen_id(gen_carry_id,1) as carry_id,fromdate,todate,description from carry where calendar_id='+IntToStr(FromID);
  quTemp.ExecSQL;
  quTemp.SQL.Text:='update carry c1 set c1.fromdate=(select cast(extract(month from c2.fromdate) || ''/'' ||'+
  ' extract(day from c2.fromdate) || ''/'' || '+
  ' extract(year from (select startdate from calendar where calendar_id='+IntToStr(ToID)+')) as date)'+
  ' from carry c2 where c2.carry_id=c1.carry_id),'+
  ' c1.todate=(select cast(extract(month from c2.todate) || ''/'' ||'+
  ' extract(day from c2.todate) || ''/'' || '+
  ' extract(year from (select startdate from calendar where calendar_id='+IntToStr(ToID)+')) as date)'+
  ' from carry c2 where c2.carry_id=c1.carry_id) where calendar_id='+IntToStr(ToID);
  quTemp.ExecSQL;
 end;
 if CheckBox3.Checked then
 begin
  //Copy all schedules (use avgyear field as temp for store source id)
  quTemp.SQL.Text:='insert into schedule (calendar_id,schedule_id,name,avgyear) select '+
   IntToStr(ToID)+' as calendar_id,gen_id(gen_schedule_id,1) as schedule_id,name,s2.schedule_id from schedule s2 where calendar_id='+IntToStr(FromID);
  quTemp.ExecSQL;
  //Copy normaltime for prior copy schedule (Error:duplicate record!!!)
  quTemp.SQL.Text:='insert into normaltime (schedule_id,normaltime_id,shift_id,workdate,timecount) select '+
   's3.schedule_id,gen_id(gen_normaltime_id,1) as normaltime_id,shift_id,cast(extract(month from n2.workdate) '+
   ' || ''/'' || extract(day from n2.workdate) || ''/'' || extract(year from (select startdate from calendar where calendar_id='+
   IntToStr(ToID)+')) as date),timecount from '+
   'normaltime n2,schedule s2, schedule s3 where (s2.calendar_id='+IntToStr(ToID)+') and '+
                                                     ////////////////////////////////
   '(n2.schedule_id=cast(s2.avgyear as integer)) and (n2.schedule_id<>s2.schedule_id) and (s3.calendar_id='+IntToStr(ToID)+') and (s3.schedule_id not in '+
   '(select cast(avgyear as integer) from schedule where calendar_id='+IntToStr(FromID)+'))';
  quTemp.ExecSQL;
  //Return original avgyear
{  quTemp.SQL.Text:='update schedule set avgyear= select '+
   IntToStr(ToID)+' as calendar_id,gen_id(gen_schedule_id,1) as schedule_id,name,s2.schedule_id from schedule s2 where calendar_id='+IntToStr(FromID);
  quTemp.ExecSQL;}
 end;
end;

{insert into normaltime (schedule_id,normaltime_id,shift_id,workdate,timecount) select
s3.schedule_id,gen_id(gen_normaltime_id,1) as normaltime_id,n2.shift_id,n2.workdate,n2.timecount from
normaltime n2,schedule s2, schedule s3 where (s2.calendar_id=5) and
(n2.schedule_id=cast(s2.avgyear as integer)) and (s3.calendar_id=5) and (s3.schedule_id not in
(select cast(avgyear as integer) from schedule where calendar_id=10))}

{select cast(s2.name as integer) as schedule_id,workdate,s3.schedule_id from
normaltime n2,schedule s2, schedule s3 where (s2.calendar_id=16) and
(n2.schedule_id=cast(s2.name as integer)) and (s3.calendar_id=16) and (s3.schedule_id not in
(select cast(name as integer) from schedule where calendar_id=0))}

var NewID:Integer;
    DateStr:String;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if (not ValidDate(DateEdit1.Date)) or (DateEdit1.Date=0) then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label2.Caption]));
   CanClose:=False;
   Exit;
  end;
  if RadioButton1.Checked and (CheckBox1.Checked or CheckBox2.Checked or CheckBox3.Checked) then
   if Application.MessageBox('Данные скопированные из другого календаря могут быть представлены не корректно применительно к новому календарю, что может привести к выполнению не верных расчётов.'#10'Всё равно выполнить копирование информации?',ConstQuestion,mb_IconQuestion+mb_YesNo)=mrNo then
   begin
    CheckBox1.Checked:=False;
    CheckBox2.Checked:=False;
    CheckBox3.Checked:=False;
   end;
  if not trTemp.InTransaction then trTemp.StartTransaction;
  NewID:=GetGenId(dbSTBasis,'calendar',1);
  DateStr:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);
  quTemp.SQL.Text:=Format('insert into calendar (calendar_id,startdate,HolidaysAddPayPercent) values (%d,CAST(''%s'' AS DATE),%d)',[NewID,DateStr,RxSpinEdit1.AsInteger]);
  try
   quTemp.ExecSQL;
   if RadioButton1.Checked then CopyCalendar(BaseOn,NewID);
   trTemp.Commit;
  except
   trTemp.Rollback;
   CanClose:=False;
   {$IFDEF DEBUG}
   Raise;
   {$ENDIF}
  end;
 end;
end;

procedure TfrmCalendarNew.RadioButtonsClick(Sender: TObject);
begin
 UpdateView;
end;

procedure TfrmCalendarNew.ComboEdit1ButtonClick(Sender: TObject);
var
//  Data:TParamRBookInterface;
  Data:TParamJournalInterface;
begin
 FillChar(Data,SizeOf(Data),0);
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:=fldDocumentsDocID;
 Data.Locate.KeyValues:=ComboEdit1.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameDocunents,@Data) then
 begin
  try
   ComboEdit1.Tag:=GetFirstValueFromParamJournalInterface(@Data,fldDocumentsDocID);
   ComboEdit1.Text:=GetFirstValueFromParamJournalInterface(@Data,fldDocumentsName);
  except
   ComboEdit1.Tag:=0;
   ComboEdit1.Text:='';
  end;
 end;
{ FillChar(Data,SizeOf(Data),0);
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:=fldDocumentsDocID;
 Data.Locate.KeyValues:=ComboEdit1.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameDocunents,@Data) then
 begin
  try
   ComboEdit1.Tag:=GetFirstValueFromParamRBookInterface(@Data,fldDocumentsDocID);
   ComboEdit1.Text:=GetFirstValueFromParamRBookInterface(@Data,fldDocumentsName);
  except
   ComboEdit1.Tag:=0;
   ComboEdit1.Text:='';
  end;
 end;}
end;

end.
