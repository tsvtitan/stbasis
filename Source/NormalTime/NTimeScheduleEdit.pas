unit NTimeScheduleEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls;

type
  TfrmScheduleEdit = class(TForm)
    Label1: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    EditCurDate: TEdit;
    Button1: TButton;
    Button2: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    EditAvgYear: TRxSpinEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   CurCalendarDate:TDateTime;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddSchedule(Calendar_ID:Integer):Boolean;
function EditSchedule(Calendar_ID,Schedule_ID:Integer):Boolean;
function DeleteSchedule(Calendar_ID,Schedule_ID:Integer):Boolean;

implementation

uses StrUtils, NTimeData, UMainUnited;

{$R *.DFM}

function AddSchedule(Calendar_ID:Integer):Boolean;
var frmScheduleEdit:TfrmScheduleEdit;
begin
 Result:=False;
 frmScheduleEdit:=TfrmScheduleEdit.Create(Application);
 with frmScheduleEdit do
 try
  ChangeDatabase(frmScheduleEdit,dbSTBasis);
  CurID:=Calendar_ID;
  quTemp.SQL.Text:=Format(sqlSelStartDateCalendar,[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else CurCalendarDate:=quTemp.FieldByName(fldCalendarStartDate).AsDateTime;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionScheduleAdd;
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyã.',CurCalendarDate);
  DoSQLStr:=sqlAddSchedule;
  GetNewID:=True;
  Result:=frmScheduleEdit.ShowModal=mrOK;
 finally
  frmScheduleEdit.Free;
 end;
end;

function EditSchedule(Calendar_ID,Schedule_ID:Integer):Boolean;
var frmScheduleEdit:TfrmScheduleEdit;
begin
 Result:=False;
 frmScheduleEdit:=TfrmScheduleEdit.Create(Application);
 with frmScheduleEdit do
 try
  ChangeDatabase(frmScheduleEdit,dbSTBasis);
  CurID:=Schedule_ID;
  quTemp.SQL.Text:=Format(sqlSelStartDateCalendar,[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgCalendarNotExist)
   else CurCalendarDate:=quTemp.FieldByName(fldCalendarStartDate).AsDateTime;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  quTemp.SQL.Text:=Format(sqlSelSchedule,[Schedule_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else begin
    EditName.Text:=quTemp.FieldByName(fldScheduleName).AsString;
    EditAvgYear.Value:=quTemp.FieldByName(fldScheduleAvgYear).AsFloat;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionScheduleUpdate;
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyã.',CurCalendarDate);
  DoSQLStr:=sqlUpdSchedule;
  GetNewID:=False;
  Result:=frmScheduleEdit.ShowModal=mrOK;
 finally
  frmScheduleEdit.Free;
 end;
end;

function DeleteSchedule(Calendar_ID,Schedule_ID:Integer):Boolean;
var frmScheduleEdit:TfrmScheduleEdit;
    ScheduleName:String;
    ScheduleCalendar:TDateTime;
begin
 Result:=False;
 frmScheduleEdit:=TfrmScheduleEdit.Create(Application);
 with frmScheduleEdit do
 try
  ChangeDatabase(frmScheduleEdit,dbSTBasis);
  quTemp.SQL.Text:=Format(sqlSelStartDateCalendar,[Calendar_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  quTemp.Open;
  if quTemp.IsEmpty then raise Exception.Create(msgCalendarNotExist)
   else ScheduleCalendar:=quTemp.FieldByName(fldCalendarStartDate).AsDateTime;
  quTemp.Close;
  quTemp.SQL.Text:=Format(sqlSelSchedule,[Schedule_ID]);
  quTemp.Open;
  if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else ScheduleName:=quTemp.FieldByName(fldScheduleName).AsString;
  quTemp.Close;
  if ShowQuestion(Handle,Format(CaptionScheduleDelete,[ScheduleName,FormatDateTime('dd mmmm yyyyã.',ScheduleCalendar)]))=mrYes then
  begin
   quTemp.SQL.Text:=Format(sqlDelSchedule,[Schedule_ID]);
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
  frmScheduleEdit.Free;
 end;
end;

procedure TfrmScheduleEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Schedule_ID:Integer;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if EditName.Text='' then
  begin
   ShowInfo(Handle,Format(ConstFieldNoEmpty,[Label1.Caption]));
   EditName.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Schedule_ID:=GetGenId(dbSTBasis,tbSchedule,1) else Schedule_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,ReplaceStr(EditAvgYear.Text,',','.'),Schedule_ID,CurID]);
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
