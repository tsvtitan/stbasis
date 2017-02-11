unit ATimeDivergenceEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolEdit, StdCtrls, Mask, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmDivergenceEdit = class(TForm)
    DateEdit1: TDateEdit;
    ComboEdit1: TComboEdit;
    ComboEdit2: TComboEdit;
    ComboEdit3: TComboEdit;
    ComboEdit4: TComboEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label7: TLabel;
    EditCurDate: TEdit;
    Label8: TLabel;
    EditCurEmp: TEdit;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    procedure ComboEdit1ButtonClick(Sender: TObject);
    procedure ComboEdit2ButtonClick(Sender: TObject);
    procedure ComboEdit3ButtonClick(Sender: TObject);
    procedure ComboEdit4ButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComboEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
   CurID,CurCalendarID,CurEmpID:Integer;
   CurCalendarDate:TDateTime;
   CurEmp:String;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddDivergence(Calendar_ID,EmpPlant_ID:Integer):Boolean;
function EditDivergence(Calendar_ID,EmpPlant_ID,Divergence_ID:Integer):Boolean;
function DeleteDivergence(Divergence_ID:Integer):Boolean;

implementation

{$R *.DFM}

uses DateUtil, CalendarData, UMainUnited, CalendarCode;

function AddDivergence(Calendar_ID,EmpPlant_ID:Integer):Boolean;
var frmDivergenceEdit: TfrmDivergenceEdit;
begin
 Result:=False;
 frmDivergenceEdit:=TfrmDivergenceEdit.Create(Application);
 with frmDivergenceEdit do
 try
  CurCalendarID:=Calendar_ID;
  CurEmpID:=EmpPlant_ID;
  ChangeDatabase(frmDivergenceEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CurCalendarDate:=quTemp.FieldByName('startdate').AsDateTime;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  quTemp.SQL.Text:=Format('select emp.fname||'' ''||emp.name||'' ''||emp.sname as fullname from empplant join emp on empplant.emp_id=emp.emp_id where empplant_id=%d',[EmpPlant_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный сотрудник не существует.')
   else CurEmp:=quTemp.FieldByName('fullname').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Добавить отклонение';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  EditCurEmp.Text:=CurEmp;
  DoSQLStr:='insert into divergence (SCHEDULE_ID,NET_ID,CLASS_ID,CATEGORY_ID,STARTDATE,EMPPLANT_ID,DIVERGENCE_ID) values (%s,%s,%s,%s,CAST(''%s'' AS DATE),%d,%d)';
  GetNewID:=True;
  Result:=frmDivergenceEdit.ShowModal=mrOK;
 finally
  frmDivergenceEdit.Free;
 end;
end;

function EditDivergence(Calendar_ID,EmpPlant_ID,Divergence_ID:Integer):Boolean;
var frmDivergenceEdit: TfrmDivergenceEdit;
begin
 Result:=False;
 frmDivergenceEdit:=TfrmDivergenceEdit.Create(Application);
 with frmDivergenceEdit do
 try
  CurCalendarID:=Calendar_ID;
  CurEmpID:=EmpPlant_ID;
  ChangeDatabase(frmDivergenceEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CurCalendarDate:=quTemp.FieldByName('startdate').AsDateTime;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  CurEmpID:=EmpPlant_ID;
  quTemp.SQL.Text:=Format('select emp.fname||'' ''||emp.name||'' ''||emp.sname as fullname from empplant join emp on empplant.emp_id=emp.emp_id where empplant_id=%d',[EmpPlant_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный сотрудник не существует.')
   else CurEmp:=quTemp.FieldByName('fullname').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  quTemp.SQL.Text:=Format('select d.SCHEDULE_ID, d.NET_ID, d.CLASS_ID, d.CATEGORY_ID, d.STARTDATE, '+
  'd.EMPPLANT_ID, d.DIVERGENCE_ID, s.name as schedulename, n.name as netname, c.num as classnum, '+
  'cat.name as categoryname from divergence d '+
  'left join schedule s on d.schedule_id=s.schedule_id '+
  'left join net n on d.net_id=n.net_id '+
  'left join class c on d.class_id=c.class_id '+
  'left join category cat on d.category_id=cat.category_id '+
  'where divergence_id=%d',[Divergence_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    DateEdit1.Date:=quTemp.FieldByName('startdate').AsDateTime;
    ComboEdit1.Tag:=quTemp.FieldByName('schedule_id').AsInteger;
    ComboEdit2.Tag:=quTemp.FieldByName('net_id').AsInteger;
    ComboEdit3.Tag:=quTemp.FieldByName('class_id').AsInteger;
    ComboEdit4.Tag:=quTemp.FieldByName('category_id').AsInteger;
    ComboEdit1.Text:=quTemp.FieldByName('schedulename').AsString;
    ComboEdit2.Text:=quTemp.FieldByName('netname').AsString;
    ComboEdit3.Text:=quTemp.FieldByName('classnum').AsString;
    ComboEdit4.Text:=quTemp.FieldByName('categoryname').AsString;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить отклонение';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  EditCurEmp.Text:=CurEmp;
  CurID:=Divergence_ID;
  DoSQLStr:='update divergence set SCHEDULE_ID=%s,NET_ID=%s,CLASS_ID=%s,CATEGORY_ID=%s,STARTDATE=CAST(''%s'' AS DATE),EMPPLANT_ID=%d where DIVERGENCE_ID=%d';
  GetNewID:=False;
  Result:=frmDivergenceEdit.ShowModal=mrOK;
 finally
  frmDivergenceEdit.Free;
 end;
end;

function DeleteDivergence(Divergence_ID:Integer):Boolean;
var frmDivergenceEdit: TfrmDivergenceEdit;
begin
 Result:=False;
 frmDivergenceEdit:=TfrmDivergenceEdit.Create(Application);
 with frmDivergenceEdit do
 try
  ChangeDatabase(frmDivergenceEdit,dbSTBasis);
  if ShowQuestion(Handle,'Удалить отклонение?')=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from divergence where divergence_id=%d',[Divergence_ID]);
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
  frmDivergenceEdit.Free;
 end;
end;

procedure TfrmDivergenceEdit.ComboEdit1ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='calendar_id;schedule_id';
 Data.Locate.KeyValues:=VarArrayOf([CurCalendarID,ComboEdit1.Tag]);
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName('Schedule',@Data) then
 begin
  ComboEdit1.Tag:=GetFirstValueFromParamRBookInterface(@Data,'schedule_id');
  quTemp.SQL.Text:=Format('select name from schedule where schedule_id=%d',[ComboEdit1.Tag]);
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

procedure TfrmDivergenceEdit.ComboEdit2ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='net_id';
 Data.Locate.KeyValues:=ComboEdit2.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName('Net',@Data) then
 begin
  ComboEdit2.Tag:=GetFirstValueFromParamRBookInterface(@Data,'net_id');
  quTemp.SQL.Text:=Format('select name from net where net_id=%d',[ComboEdit2.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit2.Text:=''
    else ComboEdit2.Text:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;
end;

procedure TfrmDivergenceEdit.ComboEdit3ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='class_id';
 Data.Locate.KeyValues:=ComboEdit3.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName('Class',@Data) then
 begin
  ComboEdit3.Tag:=GetFirstValueFromParamRBookInterface(@Data,'class_id');
  quTemp.SQL.Text:=Format('select num from class where class_id=%d',[ComboEdit3.Tag]);
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
end;

procedure TfrmDivergenceEdit.ComboEdit4ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='category_id';
 Data.Locate.KeyValues:=ComboEdit4.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName('Category',@Data) then
 begin
  ComboEdit4.Tag:=GetFirstValueFromParamRBookInterface(@Data,'category_id');
  quTemp.SQL.Text:=Format('select name from category where category_id=%d',[ComboEdit4.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit4.Text:=''
    else ComboEdit4.Text:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;
end;

procedure TfrmDivergenceEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Divergence_ID:Integer;
    S1,S2,S3,S4:String;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if DateEdit1.Date=0 then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label1.Caption]));
   DateEdit1.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Divergence_ID:=GetGenId(dbSTBasis,tbDivergence,1) else Divergence_ID:=CurID;
  if ComboEdit1.Tag=0 then S1:='null' else S1:=IntToStr(ComboEdit1.Tag);
  if ComboEdit2.Tag=0 then S2:='null' else S2:=IntToStr(ComboEdit2.Tag);
  if ComboEdit3.Tag=0 then S3:='null' else S3:=IntToStr(ComboEdit3.Tag);
  if ComboEdit4.Tag=0 then S4:='null' else S4:=IntToStr(ComboEdit4.Tag);
  quTemp.SQL.Text:=Format(DoSQLStr,[S1,S2,S3,S4,FormatDateTime('dd/mm/yyyy',DateEdit1.Date),CurEmpID,Divergence_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.ExecSQL;
   trTemp.Commit;
  except
   trTemp.Rollback;
   CanClose:=False;
  end;
 end;
end;

procedure TfrmDivergenceEdit.ComboEditKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if not (Sender is TComboEdit) then Exit;
 if (Shift=[]) and ((Key=VK_DELETE) or (Key=VK_BACK)) then
 with Sender as TComboEdit do
 begin
  Tag:=0;
  Text:='';
 end;
end;

end.
