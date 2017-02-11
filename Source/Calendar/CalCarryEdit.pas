unit CalCarryEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, ToolEdit, StdCtrls, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmCalCarryEdit = class(TForm)
    Label3: TLabel;
    EditCarryName: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label11: TLabel;
    EditCurDate: TEdit;
    GroupBox1: TGroupBox;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   CurCalendarDate:TDateTime;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddCalendarCarry(Calendar_ID:Integer):Boolean;
function EditCalendarCarry(Calendar_ID,Carry_ID:Integer):Boolean;
function DeleteCalendarCarry(Calendar_ID,Carry_ID:Integer):Boolean;

implementation

{$R *.DFM}

uses DateUtil, CalendarData, UMainUnited, StCalendarUtil;

function AddCalendarCarry(Calendar_ID:Integer):Boolean;
var
  frmCalCarryEdit: TfrmCalCarryEdit;
begin
 Result:=False;
 frmCalCarryEdit:=TfrmCalCarryEdit.Create(Application);
 with frmCalCarryEdit do
 try
  ChangeDatabase(frmCalCarryEdit,dbSTBasis);
  CurID:=Calendar_ID;
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
  Caption:='Добавить перенос';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  DoSQLStr:='insert into carry (description,fromdate,todate,carry_id,calendar_id) values (''%s'',CAST(''%s'' AS DATE),CAST(''%s'' AS DATE),%d,%d)';
  GetNewID:=True;
  Result:=frmCalCarryEdit.ShowModal=mrOK;
 finally
  frmCalCarryEdit.Free;
 end;
end;

function EditCalendarCarry(Calendar_ID,Carry_ID:Integer):Boolean;
var
  frmCalCarryEdit: TfrmCalCarryEdit;
begin
 Result:=False;
 frmCalCarryEdit:=TfrmCalCarryEdit.Create(Application);
 with frmCalCarryEdit do
 try
  ChangeDatabase(frmCalCarryEdit,dbSTBasis);
  CurID:=Carry_ID;
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
  quTemp.SQL.Text:=Format('select description,fromdate,todate from carry where carry_id=%d',[Carry_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditCarryName.Text:=quTemp.FieldByName('description').AsString;
    DateEdit1.Date:=quTemp.FieldByName('fromdate').AsDateTime;
    DateEdit2.Date:=quTemp.FieldByName('todate').AsDateTime;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить перенос';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  DoSQLStr:='update carry set description=''%s'',fromdate=CAST(''%s'' AS DATE),todate=CAST(''%s'' AS DATE),carry_id=%d where carry_id=%d';
  GetNewID:=False;
  Result:=frmCalCarryEdit.ShowModal=mrOK;
 finally
  frmCalCarryEdit.Free;
 end;
end;

function DeleteCalendarCarry(Calendar_ID,Carry_ID:Integer):Boolean;
var
  frmCalCarryEdit: TfrmCalCarryEdit;
  CarryName:String;
  CarryCalendar:TDateTime;
begin
 Result:=False;
 frmCalCarryEdit:=TfrmCalCarryEdit.Create(Application);
 with frmCalCarryEdit do
 try
  ChangeDatabase(frmCalCarryEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select startdate from calendar where calendar_id=%d',[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  quTemp.Open;
  if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CarryCalendar:=quTemp.FieldByName('startdate').AsDateTime;
  quTemp.Close;
  quTemp.SQL.Text:=Format('select description from carry where carry_id=%d',[Carry_ID]);
  quTemp.Open;
  if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else CarryName:=quTemp.FieldByName('description').AsString;
  quTemp.Close;
  if Application.MessageBox(PChar(Format('Удалить перенос "%s" календаря от %s?',[CarryName,FormatDateTime('dd mmmm yyyyг.',CarryCalendar)])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from carry where carry_id=%d',[Carry_ID]);
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
  frmCalCarryEdit.Free;
 end;
end;

procedure TfrmCalCarryEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Carry_ID:Integer;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if DateEdit1.Date=0 then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label1.Caption]));
   DateEdit1.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if not IsFreeDay(DateEdit1.Date) then
  begin
   ShowInfo(Handle,Format('Переносить можно только из выходных дней.',[]));
   DateEdit1.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if DateEdit2.Date=0 then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label2.Caption]));
   DateEdit2.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if IsFreeDay(DateEdit2.Date) or IsHoliday(DateEdit2.Date) then
  begin
   ShowInfo(Handle,Format('Переносить можно только на рабочие дни.',[]));
   DateEdit2.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Carry_ID:=GetGenId(dbSTBasis,'carry',1) else Carry_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditCarryName.Text,
   FormatDateTime('dd/mm/yyyy',DateEdit1.Date),
   FormatDateTime('dd/mm/yyyy',DateEdit2.Date),Carry_ID,CurID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.ExecSQL;
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

end.
