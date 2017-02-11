{***************************************************}
{*                                                 *}
{*    ECP Calendar main unit                       *}
{*                                                 *}
{*    Copyright (c) 1998-99 Bishop Computer Center *}
{*                                                 *}
{***************************************************}

{
+ 1. Список недель поправить
  2. Написать процедуру с учётом исключений
+ 3. Реализовать отображение переносов
+ 4. В меню доделать
- 5. Подсказка на каждый день
+ 6. Спрятать указатель дня полностью
+ 7. Кнопку запретить
- 8. Косяк при переходе EConvertError
+ 9. Косяк при выходе в ECPLIB.DLL
  10.УСКОРИТЬ
}

unit CalendarUnit;
                        
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ECPCalendarUnit, ExtCtrls, Buttons, Placemnt, Mask, RXCtrls, AppEvent, ConstsUnit,
  Grids, Menus, Waiter, ECPFormUnit;

type
  TCalendarForm = class(TECPForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ToolPanel: TPanel;
    InfoPanel01: TPanel;
    InfoPanel02: TPanel;
    InfoPanel03: TPanel;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    FormStorage: TFormStorage;
    YearLabel: TLabel;
    PartLabel: TLabel;
    PrevYearButton: TRxSpeedButton;
    PrevPartButton: TRxSpeedButton;
    NextYearButton: TRxSpeedButton;
    NextPartButton: TRxSpeedButton;
    AppEvents: TAppEvents;
    InfoPanel: TPanel;
    InfoPanel11: TPanel;
    PopupMenu: TPopupMenu;
    InfoItem: TMenuItem;
    WorkingDaysLabel01: TLabel;
    WorkingHours40Label01: TLabel;
    WorkingHours36Label01: TLabel;
    InfoPanel22: TPanel;
    WorkingDaysLabel02: TLabel;
    WorkingHours40Label02: TLabel;
    WorkingHours36Label02: TLabel;
    InfoPanel33: TPanel;
    WorkingDaysLabel03: TLabel;
    WorkingHours40Label03: TLabel;
    WorkingHours36Label03: TLabel;
    EmployeeWaiter: TWaiter;
    N2: TMenuItem;
    TitleItem: TMenuItem;
    MTitleItem: TMenuItem;
    InfoPanelItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure AppEventsException(Sender: TObject; E: Exception);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure InfoItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure TitleItemClick(Sender: TObject);
    procedure MTitleItemClick(Sender: TObject);
    procedure InfoPanelItemClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMSysCommand(var Message:TWMSysCommand); message wm_SysCommand;
    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  public
    { Public declarations }
   Calendar01: TECPCalendar;
   Calendar02: TECPCalendar;
   Calendar03: TECPCalendar;
   procedure UpdateView;
   procedure NextPart;
   procedure PrevPart;
  end;

var
  CalendarForm: TCalendarForm;

implementation

uses DB, DateUtil, Registry, ECPLibUnit, CalendarCommonUnit,
  CalendarInfoUnit;

{$R *.DFM}
const
 cm_AboutCommand=$00a0;

var Shown:Boolean=False;

procedure TCalendarForm.UpdateView;
var I:Byte;
begin
 if CalendarDataModule.taWeeks.State=dsInactive then Exit;
 if InfoPanel11.Visible then
 begin
  WorkingDaysLabel01.Caption:='Раб. дней :'+IntToStr(GetWorkingDaysInMonth(Calendar01.CalendarDate));
  WorkingDaysLabel02.Caption:='Раб. дней :'+IntToStr(GetWorkingDaysInMonth(Calendar02.CalendarDate));
  WorkingDaysLabel03.Caption:='Раб. дней :'+IntToStr(GetWorkingDaysInMonth(Calendar03.CalendarDate));
  I:=1;
  CalendarDataModule.taWeeks.First;
  with CalendarDataModule do
  while not taWeeks.EOF do
  begin
   case I of
    1:begin
       WorkingHours40Label01.Caption:='Раб. часов :'+FloatToStrF(GetExceptWorkingHoursInMonth(Calendar01.CalendarDate),ffGeneral,6,2);
       WorkingHours40Label02.Caption:='Раб. часов :'+FloatToStrF(GetExceptWorkingHoursInMonth(Calendar02.CalendarDate),ffGeneral,6,2);
       WorkingHours40Label03.Caption:='Раб. часов :'+FloatToStrF(GetExceptWorkingHoursInMonth(Calendar03.CalendarDate),ffGeneral,6,2);
       WorkingHours40Label01.Hint:='Количество рабочих часов по '+taWeeks.FieldByName('Week').AsString+'-часовой рабочей недели';
       WorkingHours40Label02.Hint:='Количество рабочих часов по '+taWeeks.FieldByName('Week').AsString+'-часовой рабочей недели';
       WorkingHours40Label03.Hint:='Количество рабочих часов по '+taWeeks.FieldByName('Week').AsString+'-часовой рабочей недели';
      end;
    2:begin
       WorkingHours36Label01.Caption:=FloatToStrF(GetExceptWorkingHoursInMonth(Calendar01.CalendarDate),ffGeneral,6,2);
       WorkingHours36Label02.Caption:=FloatToStrF(GetExceptWorkingHoursInMonth(Calendar02.CalendarDate),ffGeneral,6,2);
       WorkingHours36Label03.Caption:=FloatToStrF(GetExceptWorkingHoursInMonth(Calendar03.CalendarDate),ffGeneral,6,2);
       WorkingHours36Label01.Hint:='Количество рабочих часов по '+taWeeks.FieldByName('Week').AsString+'-часовой рабочей недели';
       WorkingHours36Label02.Hint:='Количество рабочих часов по '+taWeeks.FieldByName('Week').AsString+'-часовой рабочей недели';
       WorkingHours36Label03.Hint:='Количество рабочих часов по '+taWeeks.FieldByName('Week').AsString+'-часовой рабочей недели';
      end;
   else Break;
   end;
   Inc(I);
   taWeeks.Next;
  end;
 end;
 if InfoPanel01.Visible then
 begin
  InfoPanel01.Caption:=LongMonthNames[Calendar01.Month];
  InfoPanel02.Caption:=LongMonthNames[Calendar02.Month];
  InfoPanel03.Caption:=LongMonthNames[Calendar03.Month];
 end; 
  InfoPanel.Caption:=YearLabel.Caption+'г. '+IntToStr(StrToInt(PartLabel.Caption)+1)+' квартал';
end;

procedure TCalendarForm.WMSysCommand(var Message:TWMSysCommand);
begin
 case Message.CmdType of
  cm_AboutCommand:
   AboutProg(CalendarProgID);
  else
   inherited;
 end;
end;

procedure TCalendarForm.WMNCHitTest(var M: TWMNCHitTest);
begin
 inherited;
 if M.Result=htClient then  { Мышь сидит на окне?                    }
  M.Result:=htCaption;    { Если да - то пусть Windows думает, что }                                { мышь на caption bar                    }
end;

procedure TCalendarForm.FormCreate(Sender: TObject);
var SysMenu:HMenu;
    R:TRegistry;
    Temp:String;
begin
  R:=TRegistry.Create;
  R.OpenKey(FormStorage.IniFileName,True);
  R.WriteString('',Application.ExeName);
  R.CloseKey;
  Temp:=FormStorage.IniFileName;
  Delete(Temp,LastPos('\',Temp),Length(Temp));
  R.OpenKey(Temp,True);
  R.WriteString('',IntToStr(CalendarProgID));
  R.Destroy;
  Application.Title:=GetProgName(CalendarProgID);
  CalendarForm.Caption:=GetProgName(CalendarProgID);
  SysMenu:=GetSystemMenu(Handle,False);
  AppendMenu(SysMenu,MF_SEPARATOR,0,'');
  AppendMenu(SysMenu,MF_String,cm_AboutCommand,'О программе...');
  FormStorage.RestoreFormPlacement;
  Calendar01:=TECPCalendar.Create(Self);
  with Calendar01 do begin
    Parent := Panel1;
    Align := alClient;
    ParentFont := True;
    SetBounds(2, 2, 50, 50);
    TabOrder := 0;
    UseCurrentDate := False;
    Weekends:=[Sun,Sat];
    Year:=StrToInt(YearLabel.Caption);
    Month:=StrToInt(PartLabel.Caption)*3+1;
    UpdateCalendar;
  end;
  Calendar02 := TECPCalendar.Create(Self);
  with Calendar02 do begin
    Parent := Panel2;
    Align := alClient;
    ParentFont := True;
    SetBounds(2, 2, 50, 50);
    TabOrder := 1;
    UseCurrentDate := False;
    Weekends:=[Sun,Sat];
    Year:=StrToInt(YearLabel.Caption);
    Month:=StrToInt(PartLabel.Caption)*3+2;
    UpdateCalendar;
  end;
  Calendar03 := TECPCalendar.Create(Self);
  with Calendar03 do begin
    Parent := Panel3;
    Align := alClient;
    ParentFont := True;
    SetBounds(2, 2, 50, 50);
    TabOrder := 2;
    UseCurrentDate := False;
    Weekends:=[Sun,Sat];
    Year:=StrToInt(YearLabel.Caption);
    Month:=StrToInt(PartLabel.Caption)*3+3;
    UpdateCalendar;
  end;
  ActiveControl := Calendar01;
end;

procedure TCalendarForm.FormResize(Sender: TObject);
begin
 Panel1.Top:=ToolPanel.Height;
 Panel2.Top:=ToolPanel.Height;
 Panel3.Top:=ToolPanel.Height;
 Panel1.Height:=CalendarForm.ClientHeight-ToolPanel.Height;
 Panel2.Height:=CalendarForm.ClientHeight-ToolPanel.Height;
 Panel3.Height:=CalendarForm.ClientHeight-ToolPanel.Height;
 Panel1.Width:=CalendarForm.ClientWidth div 3;
 Panel2.Width:=CalendarForm.ClientWidth div 3;
 Panel3.Width:=CalendarForm.ClientWidth div 3;
 Panel1.Left:=0;
 Panel2.Left:=Panel1.Width;
 Panel3.Left:=Panel1.Width*2;
end;

procedure TCalendarForm.NextPart;
begin
 Calendar01.NextMonth;
 Calendar01.NextMonth;
 Calendar01.NextMonth;
 Calendar02.NextMonth;
 Calendar02.NextMonth;
 Calendar02.NextMonth;
 Calendar03.NextMonth;
 Calendar03.NextMonth;
 Calendar03.NextMonth;
end;

procedure TCalendarForm.PrevPart;
begin
 Calendar01.PrevMonth;
 Calendar01.PrevMonth;
 Calendar01.PrevMonth;
 Calendar02.PrevMonth;
 Calendar02.PrevMonth;
 Calendar02.PrevMonth;
 Calendar03.PrevMonth;
 Calendar03.PrevMonth;
 Calendar03.PrevMonth;
end;

procedure TCalendarForm.SpeedButton1Click(Sender: TObject);
begin
 Calendar01.PrevYear;
 Calendar02.PrevYear;
 Calendar03.PrevYear;
 YearLabel.Caption:=IntToStr(StrToInt(YearLabel.Caption)-1);
 UpdateView;
end;

procedure TCalendarForm.SpeedButton3Click(Sender: TObject);
begin
 Calendar01.NextYear;
 Calendar02.NextYear;
 Calendar03.NextYear;
 YearLabel.Caption:=IntToStr(StrToInt(YearLabel.Caption)+1);
 UpdateView;
end;

procedure TCalendarForm.SpeedButton2Click(Sender: TObject);
begin
 PrevPart;
 PartLabel.Caption:=IntToStr(StrToInt(PartLabel.Caption)-1);
 if StrToInt(PartLabel.Caption)=-1 then
 begin
  PartLabel.Caption:='3';
  YearLabel.Caption:=IntToStr(StrToInt(YearLabel.Caption)-1);
 end;
 UpdateView;
end;

procedure TCalendarForm.SpeedButton4Click(Sender: TObject);
begin
 NextPart;
 PartLabel.Caption:=IntToStr(StrToInt(PartLabel.Caption)+1);
 if StrToInt(PartLabel.Caption)=4 then
 begin
  PartLabel.Caption:='0';
  YearLabel.Caption:=IntToStr(StrToInt(YearLabel.Caption)+1);
 end;
 UpdateView;
end;

procedure TCalendarForm.AppEventsException(Sender: TObject; E: Exception);
begin
 try
  AddEventItem(CalendarProgID,User,EV_Error,-1,-1,'Внутренняя ошибка программы СООБЩЕНИЕ: '+E.Message);
 except
 end;
 Application.MessageBox(PChar('Внутренняя ошибка программы'+#10+'СООБЩЕНИЕ: '+E.Message),'Ошибка',MB_OK+MB_ICONEXCLAMATION);
end;

procedure TCalendarForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 try
  AddEventItem(CalendarProgID,User,EV_Logoff,-1,-1,'Завершение работы');
 except
 end;
end;

procedure DoEmployeeInit;stdcall;
begin
 with CalendarDataModule do
 begin
  if ECPEmployees=nil then Exit;
  ECPEmployees.EmployeesInit;
 end;
end;

procedure TCalendarForm.FormShow(Sender: TObject);
begin
 if Shown then Exit;
 Shown:=True;
 DoEmployeeInit;
 UpdateView;
 HideSplashWindow;
end;

procedure TCalendarForm.InfoItemClick(Sender: TObject);
begin
 with CalendarDataModule do
 begin
  taWeeks.First;
  taExcepts.Refresh;
  taHolidays.Refresh;
  taCarrying.Refresh;
 end;
 CalendarInfoForm:=TCalendarInfoForm.Create(Application);
 try
  with CalendarDataModule do
  if (ECPEmployees<>nil) and (User.LogResult<>LG_DeveloperLogSuccess) and (User.LogResult<>LG_AccessNotUse) then
  begin
   ECPEmployees.GetEmployeeInfo(User.Department,User.TabNo);
   CalendarInfoForm.UserEdit.Text:=ECPEmployees.Family+' '+ECPEmployees.Name+' '+ECPEmployees.SecondName;
   CalendarInfoForm.DetailBtn.Enabled:=True;
  end else
  begin
   CalendarInfoForm.UserEdit.Text:='Неизвестный пользователь';
   CalendarInfoForm.DetailBtn.Enabled:=False;
  end;
  CalendarInfoForm.RightsEdit.Text:=GetRightsStr(User.Rights);
  with CalendarInfoForm do
   CurYearLabel.Caption:='Текущий год :'+YearLabel.Caption+'г.';
  CalendarInfoForm.ShowModal;
 finally
  CalendarInfoForm.Free;
  CalendarInfoForm:=nil;
 end;
end;

procedure TCalendarForm.PopupMenuPopup(Sender: TObject);
begin
 TitleItem.Checked:=CalendarForm.BorderStyle=bsNone;
 MTitleItem.Checked:=not InfoPanel01.Visible;
 InfoPanelItem.Checked:=not InfoPanel11.Visible;
end;

procedure TCalendarForm.TitleItemClick(Sender: TObject);
begin
 TitleItem.Checked:=not TitleItem.Checked;
 if TitleItem.Checked then BorderStyle:=bsNone else BorderStyle:=bsSizeable;
end;

procedure TCalendarForm.MTitleItemClick(Sender: TObject);
begin
 MTitleItem.Checked:=not MTitleItem.Checked;
 InfoPanel01.Visible:=not InfoPanel01.Visible;
 InfoPanel02.Visible:=not InfoPanel02.Visible;
 InfoPanel03.Visible:=not InfoPanel03.Visible;
end;

procedure TCalendarForm.InfoPanelItemClick(Sender: TObject);
begin
 InfoPanelItem.Checked:=not InfoPanelItem.Checked;
 InfoPanel11.Visible:=not InfoPanel11.Visible;
 InfoPanel22.Visible:=not InfoPanel22.Visible;
 InfoPanel33.Visible:=not InfoPanel33.Visible;
end;

end.
