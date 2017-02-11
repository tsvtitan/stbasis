unit CalWeekEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXSpin, StdCtrls, ExtCtrls, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmCalWeekEdit = class(TForm)
    Label1: TLabel;
    EditWeekName: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    RxSpinEdit1: TRxSpinEdit;
    RxSpinEdit2: TRxSpinEdit;
    RxSpinEdit3: TRxSpinEdit;
    RxSpinEdit4: TRxSpinEdit;
    RxSpinEdit5: TRxSpinEdit;
    RxSpinEdit6: TRxSpinEdit;
    RxSpinEdit7: TRxSpinEdit;
    RxSpinEdit8: TRxSpinEdit;
    RxSpinEdit9: TRxSpinEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    Label11: TLabel;
    EditCurDate: TEdit;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
   CurID:Integer;
   CurCalendarDate:TDateTime;
   DoSQLStr:String;
  public
    { Public declarations }
  end;

function AddCalendarWeek(YearID:Integer):Boolean;
function EditCalendarWeek(YearID,WeekID:Integer):Boolean;
function DeleteCalendarWeek(YearID,WeekID:Integer):Boolean;

implementation

uses StrUtils, CalendarData, UMainUnited;

{$R *.DFM}

function AddCalendarWeek(YearID:Integer):Boolean;
var
  frmCalWeekEdit: TfrmCalWeekEdit;
begin
 Result:=False;
 frmCalWeekEdit:=TfrmCalWeekEdit.Create(Application);
 with frmCalWeekEdit do
 try
  ChangeDatabase(frmCalWeekEdit,dbSTBasis);
  CurID:=YearID;
  quTemp.SQL.Text:=Format('select fyear from fyear where fyear_id=%d',[YearID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CurCalendarDate:=quTemp.FieldByName('fyear').AsDateTime;
  finally
   quTemp.Close;
  end;
  Caption:='Добавить неделю';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  DoSQLStr:='insert into week (name,d1,d2,d3,d4,d5,d6,d7,beforeholiday,avgyear,fyear_id) values (''%s'',%s,%s,%s,%s,%s,%s,%s,%s,%s,%d)';
  Result:=frmCalWeekEdit.ShowModal=mrOK;
 finally
  frmCalWeekEdit.Release;
 end;
end;

function EditCalendarWeek(YearID,WeekID:Integer):Boolean;
var
  frmCalWeekEdit: TfrmCalWeekEdit;
begin
 Result:=False;
 frmCalWeekEdit:=TfrmCalWeekEdit.Create(Application);
 with frmCalWeekEdit do
 try
  ChangeDatabase(frmCalWeekEdit,dbSTBasis);
  CurID:=WeekID;
  quTemp.SQL.Text:=Format('select fyear from fyear where fyear_id=%d',[YearID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else CurCalendarDate:=quTemp.FieldByName('fyear').AsDateTime;
  finally
   quTemp.Close;
  end;
  quTemp.SQL.Text:=Format('select name,d1,d2,d3,d4,d5,d6,d7,beforeholiday,avgyear from week where week_id=%d',[WeekID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditWeekName.Text:=quTemp.FieldByName('name').AsString;
    RxSpinEdit1.Value:=quTemp.FieldByName('d1').AsFloat;
    RxSpinEdit2.Value:=quTemp.FieldByName('d2').AsFloat;
    RxSpinEdit3.Value:=quTemp.FieldByName('d3').AsFloat;
    RxSpinEdit4.Value:=quTemp.FieldByName('d4').AsFloat;
    RxSpinEdit5.Value:=quTemp.FieldByName('d5').AsFloat;
    RxSpinEdit6.Value:=quTemp.FieldByName('d6').AsFloat;
    RxSpinEdit7.Value:=quTemp.FieldByName('d7').AsFloat;
    RxSpinEdit8.Value:=quTemp.FieldByName('beforeholiday').AsFloat;
    RxSpinEdit9.Value:=quTemp.FieldByName('avgyear').AsFloat;
   end;
  finally
   quTemp.Close;
  end;
  Caption:='Изменить неделю';
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',CurCalendarDate);
  DoSQLStr:='update week set name=''%s'',d1=%s,d2=%s,d3=%s,d4=%s,d5=%s,d6=%s,d7=%s,beforeholiday=%s,avgyear=%s where week_id=%d';
  Result:=frmCalWeekEdit.ShowModal=mrOK;
 finally
  frmCalWeekEdit.Release;
 end;
end;

function DeleteCalendarWeek(YearID,WeekID:Integer):Boolean;
var
  frmCalWeekEdit: TfrmCalWeekEdit;
  WeekName:String;
  WeekYear:TDateTime;
begin
 Result:=False;
 frmCalWeekEdit:=TfrmCalWeekEdit.Create(Application);
 with frmCalWeekEdit do
 try
  ChangeDatabase(frmCalWeekEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select fyear from fyear where fyear_id=%d',[YearID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Указанный календарь не существует.')
   else WeekYear:=quTemp.FieldByName('fyear').AsDateTime;
  finally
   quTemp.Close;
  end;
  quTemp.SQL.Text:=Format('select name from week where week_id=%d',[WeekID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else WeekName:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
  end;
  if Application.MessageBox(PChar(Format('Удалить неделю "%s" календаря от %s?',[WeekName,FormatDateTime('dd mmmm yyyyг.',WeekYear)])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from week where week_id=%d',[WeekID]);
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
  frmCalWeekEdit.Release;
 end;
end;

procedure TfrmCalWeekEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if EditWeekName.Text='' then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label1.Caption]));
   CanClose:=False;
   Exit;
  end;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditWeekName.Text,ReplaceStr(RxSpinEdit1.Text,',','.')
   ,ReplaceStr(RxSpinEdit2.Text,',','.'),ReplaceStr(RxSpinEdit3.Text,',','.'),ReplaceStr(RxSpinEdit4.Text,',','.'),ReplaceStr(RxSpinEdit5.Text,',','.')
   ,ReplaceStr(RxSpinEdit6.Text,',','.'),ReplaceStr(RxSpinEdit7.Text,',','.'),ReplaceStr(RxSpinEdit8.Text,',','.'),ReplaceStr(RxSpinEdit9.Text,',','.'),CurID]);
  try
   if not trTemp.InTransaction then trTemp.StartTransaction;
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
