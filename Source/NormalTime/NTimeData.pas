unit NTimeData;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, IBDatabase, IBCustomDataSet, Db, IBQuery, dbgrids, UMainUnited;

type
  TdmNormalTime = class(TDataModule)
    ilNormalTime: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSetMode=(smNone,smRectangle,smCols,smRows,smAll);

const
  IntNameSeat='Справочник должностей';
  IntNameDocument='Журнал документов';
  
  IntNameSchedule='Редактор графиков и норм времени';
  IntHintSchedule='';
  IntNameShift='Справочник смен';
  IntHintShift='';
  IntNameNet='Справочник сеток';
  IntHintNet='';
  IntNameClass='Справочник разрядов';
  IntHintClass='';
  IntNameAbsence='Справочник видов неявок';
  IntHintAbsence='';
  IntNameCategory='Справочник категорий';
  IntHintCategory='';
  IntNameCategoryType='Справочник типов категорий';
  IntHintCategoryType='';
  IntNameSeatClass='Штатное расписание';
  IntHintSeatClass='';

  SplashCaptionShift='Справочник смен';
  MenuItemCaptionShift='Смены';
  MenuItemHintShift='';
  tbShift='shift';
  CaptionShiftEdit='Смены';
  CaptionShiftSelect='Выбор смены';
  CaptionShiftAdd='Добавить смену';
  CaptionShiftUpdate='Изменить смену';
  CaptionShiftDelete='Удалить смену <%s>?';
  sqlAddShift='insert into shift (name,addpaypercent,shift_id) values (''%s'',%d,%d)';
  sqlSelShift='select name,addpaypercent from shift where shift_id=%d';
  sqlDelShift='delete from shift where shift_id=%d';
  sqlUpdShift='update shift set name=''%s'',addpaypercent=%d where shift_id=%d';
  sqlSelShiftAll='select shift_id,name,addpaypercent from shift ';
  fldShiftName='name';
  fldShiftShiftID='shift_id';
  fldShiftAddPayPercent='addpaypercent';
  iniLastShift='LastShift';

  tbCalendar='calendar';
  fldCalendarCalendarID='calendar_id';
  fldCalendarStartDate='startdate';
  sqlSelStartDateCalendar='select startdate from calendar where calendar_id=%d';
  iniLastCalendar='LastCalendar';

  SplashCaptionSchedule='Редактор графиков и норм времени';
  MenuItemCaptionSchedule='Графики и нормы времени';
  MenuItemHintSchedule='';
  tbSchedule='schedule';
  sqlSelSchedule='select name,avgyear from schedule where schedule_id=%d';
  sqlAddSchedule='insert into schedule (name,avgyear,schedule_id,calendar_id) values (''%s'',%s,%d,%d)';
  sqlUpdSchedule='update schedule set name=''%s'',avgyear=%s,schedule_id=%d where schedule_id=%d';
  sqlDelSchedule='delete from schedule where schedule_id=%d';
  CaptionScheduleEdit='Графики и нормы времени';
  CaptionScheduleSelect='Выбор графика';
  CaptionScheduleAdd='Добавить график';
  CaptionScheduleUpdate='Изменить график';
  CaptionScheduleDelete='Удалить график <%s> календаря от %s?';
  fldScheduleScheduleID='schedule_id';
  fldScheduleName='name';
  fldScheduleAvgYear='avgyear';
  iniLastSchedule='LastSchedule';

  SplashCaptionNet='Справочник сеток';
  MenuItemCaptionNet='Сетки';
  MenuItemHintNet='';
  tbNet='net';

  SplashCaptionClass='Справочник разрядов';
  MenuItemCaptionClass='Разряды';
  MenuItemHintClass='';
  tbClass='class';

  SplashCaptionCategory='Справочник категорий';
  MenuItemCaptionCategory='Категории';
  MenuItemHintCategory='';
  tbCategory='category';

  SplashCaptionAbsence='Справочник видов неявок';
  MenuItemCaptionAbsence='Виды неявок';
  MenuItemHintAbsence='';
  tbAbsence='absence';
  CaptionAbsenceSelect='Выбор вида неявки';
  CaptionAbsenceEdit='Виды неявок';
  CaptionAbsenceAdd='Добавить вид неявки';
  CaptionAbsenceUpdate='Изменить вид неявки';
  CaptionAbsenceDelete='Удалить вид неявки <%s>?';
  fldAbsenceAbsenceID='absence_id';
  fldAbsenceName='name';
  fldAbsenceShortName='shortname';
  sqlAddAbsence='insert into absence (name,shortname,absence_id) values (''%s'',''%s'',%d)';
  sqlSelAbsence='select name,shortname from absence where absence_id=%d';
  sqlUpdAbsence='update absence set name=''%s'',shortname=''%s'' where absence_id=%d';
  sqlDelAbsence='delete from absence where Absence_id=%d';
  sqlSelAbsenceAll='select absence_id,name,shortname from absence ';
  iniLastAbsence='LastAbsence';

  tbSeatClass='seatclass';
  MenuItemCaptionSeatClass='Штатное расписание';
  MenuItemHintSeatClass='Штатное расписание';

  SplashCaptionCategoryType='Справочник типов категорий';
  MenuItemCaptionCategoryType='Типы категорий';
  MenuItemHintCategoryType='';
  tbCategoryType='categorytype';
  CaptionCategoryTypeEdit='Типы категорий';
  CaptionCategoryTypeSelect='Выбор типа категории';
  CaptionCategoryTypeAdd='Добавить тип категории';
  CaptionCategoryTypeUpdate='Изменить тип категории';
  CaptionCategoryTypeDelete='Удалить тип категории <%s>?';
  sqlAddCategoryType='insert into categorytype (name,categorytype_id) values (''%s'',%d)';
  sqlSelCategoryType='select name from categorytype where categorytype_id=%d';
  sqlDelCategoryType='delete from categorytype where categorytype_id=%d';
  sqlUpdCategoryType='update categorytype set name=''%s'' where categorytype_id=%d';
  sqlSelCategoryTypeAll='select categorytype_id,name from categorytype ';
  fldCategoryTypeCategoryTypeID='categorytype_id';
  fldCategoryTypeName='name';
  iniLastCategoryType='LastCategoryType';

  tbNormalTime='normaltime';
  fldNormalTimeWorkDate='workdate';
  fldNormalTimeShiftID='shift_id';
  fldNormalTimeTimeCount='timecount';
  iniLastNormalTime='LastNormalTime';
var
  isInitData: Boolean=False;

  dmNormalTime: TdmNormalTime;
  dbSTBasis: TIBDatabase;
  trDefault: TIBTransaction;

  ListOptionHandles: TList;
  ListToolBarHandles: TList;
  ListInterfaceHandles: TList;
  ListMenuHandles: TList;

  hInterfaceRbkSchedule: THandle;
  hInterfaceRbkShift: THandle;
  hInterfaceRbkNet: THandle;
  hInterfaceRbkClass: THandle;
  hInterfaceRbkAbsence: THandle;
  hInterfaceRbkCategory: THandle;
  hInterfaceRbkCategoryType: THandle;
  hInterfaceRbkSeatClass: THandle;

  hMenuRBooks: THandle;

  hMenuRBooksSchedule: THandle;
  hMenuRBooksShift: THandle;
  hMenuRBooksNet: THandle;
  hMenuRBooksClass: THandle;
  hMenuRBooksAbsence: THandle;
  hMenuRBooksCategory: THandle;
  hMenuRBooksCategoryType: THandle;
  hMenuRBooksSeatClass: THandle;

  hToolButtonSchedule: THandle;
  hToolButtonShift: THandle;
  hToolButtonNet: THandle;
  hToolButtonClass: THandle;
  hToolButtonAbsence: THandle;
  hToolButtonCategory: THandle;
  hToolButtonCategoryType: THandle;
  hToolButtonSeatClass: THandle;

procedure ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TCustomDBGrid; Param: PParamRBookInterface);

implementation

{$R *.DFM}

procedure ReturnModalParamsFromDataSetAndGrid(DataSet: TDataSet; Grd: TCustomDBGrid; Param: PParamRBookInterface);
var
  i{,j}: Integer;
begin
  if DataSet=nil then exit;
  if Grd=nil then exit;
  if DataSet.IsEmpty then exit;
  DataSet.DisableControls;
  try
   SetLength(Param.Result,DataSet.FieldCount);
   for i:=0 to DataSet.FieldCount-1 do
     Param.Result[i].FieldName:=DataSet.Fields[i].FieldName;
{   if Param.Visual.MultiSelect then begin
     for i:=0 to DataSet.FieldCount-1 do begin
       for j:=0 to Grd.SelectedRows.Count-1 do begin
         SetLength(Param.Result[i].Values,Grd.SelectedRows.Count);
         DataSet.GotoBookmark(pointer(Grd.SelectedRows.Items[j]));
         Param.Result[i].Values[j]:=DataSet.Fields[i].Value;
       end;
     end;
    end else begin}
      for i:=0 to DataSet.FieldCount-1 do begin
         SetLength(Param.Result[i].Values,1);
         Param.Result[i].Values[0]:=DataSet.Fields[i].Value;
      end;
//    end;
  finally
   DataSet.EnableControls;
  end;
end;

end.
