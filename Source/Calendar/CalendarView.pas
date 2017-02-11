unit CalendarView;

{$I stbasis.inc}

interface

uses
  Windows, Classes, Forms, Controls, StdCtrls, Menus, Buttons,
  StCalendarUtil, StCalendarGrid, Placemnt, ExtCtrls, UMainUnited;

type
  TfrmCalendarView = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ToolPanel: TPanel;
    InfoPanel01: TPanel;
    InfoPanel02: TPanel;
    InfoPanel03: TPanel;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    InfoPanel: TPanel;
    InfoPanel11: TPanel;
    WorkingDaysLabel01: TLabel;
    InfoPanel22: TPanel;
    WorkingDaysLabel02: TLabel;
    InfoPanel33: TPanel;
    WorkingDaysLabel03: TLabel;
    PrevYearButton: TSpeedButton;
    PrevPartButton: TSpeedButton;
    NextYearButton: TSpeedButton;
    NextPartButton: TSpeedButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrevYearButtonClick(Sender: TObject);
    procedure PrevPartButtonClick(Sender: TObject);
    procedure NextPartButtonClick(Sender: TObject);
    procedure NextYearButtonClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
   Calendar01: TStCalendar;
   Calendar02: TStCalendar;
   Calendar03: TStCalendar;
   FhInterface: THandle;
   LastYear,LastPart:Integer;
   FirstActive:Boolean;
   procedure LoadFromIni;
   procedure SaveToIni;
  public
   constructor Create(AOwner: TComponent;AhInterface: THandle;AParams:PParamServiceInterface);virtual;
   procedure UpdateView;
  end;

var
  frmCalendarView: TfrmCalendarView;

implementation

uses SysUtils, DateUtil, CalendarCode, CalendarData;

{$R *.DFM}

const
 IniSection='CalendarView';

procedure TfrmCalendarView.UpdateView;
//var I:Byte;
begin
 WorkingDaysLabel01.Caption:='Раб. дней :'+IntToStr(GetWorkingDaysInMonth(Calendar01.CalendarDate));
 WorkingDaysLabel02.Caption:='Раб. дней :'+IntToStr(GetWorkingDaysInMonth(Calendar02.CalendarDate));
 WorkingDaysLabel03.Caption:='Раб. дней :'+IntToStr(GetWorkingDaysInMonth(Calendar03.CalendarDate));
{  I:=1;
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
 end;}
 InfoPanel01.Caption:=LongMonthNames[Calendar01.Month];
 InfoPanel02.Caption:=LongMonthNames[Calendar02.Month];
 InfoPanel03.Caption:=LongMonthNames[Calendar03.Month];
 InfoPanel.Caption:=IntToStr(LastYear)+'г. '+IntToStr(LastPart+1)+' квартал';
end;

constructor TfrmCalendarView.Create(AOwner: TComponent;AhInterface: THandle;AParams:PParamServiceInterface);
begin
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);
 FormStyle:=fsMDIChild;
 Caption:=MenuItemCaptionCalendarView;
 LoadFromIni;
 Calendar01:=TStCalendar.Create(Self);
  with Calendar01 do begin
    Parent := Panel1;
    Align := alClient;
    ParentFont := True;
    SetBounds(2, 2, 50, 50);
    TabOrder := 0;
    UseCurrentDate := False;
    Year:=LastYear;
    Month:=LastPart*3+1;
    UpdateCalendar;
  end;
  Calendar02 := TStCalendar.Create(Self);
  with Calendar02 do begin
    Parent := Panel2;
    Align := alClient;
    ParentFont := True;
    SetBounds(2, 2, 50, 50);
    TabOrder := 1;
    UseCurrentDate := False;
    Year:=LastYear;
    Month:=LastPart*3+2;
    UpdateCalendar;
  end;
  Calendar03 := TStCalendar.Create(Self);
  with Calendar03 do begin
    Parent := Panel3;
    Align := alClient;
    ParentFont := True;
    SetBounds(2, 2, 50, 50);
    TabOrder := 2;
    UseCurrentDate := False;
    Year:=LastYear;
    Month:=LastPart*3+3;
    UpdateCalendar;
  end;
  ActiveControl := Calendar01;
  Resize;
  UpdateView;
end;

procedure TfrmCalendarView.LoadFromIni;
begin
 LastYear:=ReadParam(IniSection,'LastYear',2000);
 LastPart:=ReadParam(IniSection,'LastPart',0);
end;

procedure TfrmCalendarView.SaveToIni;
begin
 WriteParam(IniSection,'LastYear',LastYear);
 WriteParam(IniSection,'LastPart',LastPart);
end;

procedure TfrmCalendarView.FormDestroy(Sender: TObject);
begin
 SaveToIni;
 Calendar01.Free;
 Calendar02.Free;
 Calendar03.Free;
 frmCalendarView:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmCalendarView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfrmCalendarView.FormResize(Sender: TObject);
begin
 Panel1.Top:=ToolPanel.Height;
 Panel2.Top:=ToolPanel.Height;
 Panel3.Top:=ToolPanel.Height;
 Panel1.Height:=ClientHeight-ToolPanel.Height;
 Panel2.Height:=ClientHeight-ToolPanel.Height;
 Panel3.Height:=ClientHeight-ToolPanel.Height;
 Panel1.Width:=ClientWidth div 3;
 Panel2.Width:=ClientWidth div 3;
 Panel3.Width:=ClientWidth div 3;
 Panel1.Left:=0;
 Panel2.Left:=Panel1.Width;
 Panel3.Left:=Panel1.Width*2;
end;

procedure TfrmCalendarView.PrevYearButtonClick(Sender: TObject);
begin
 Calendar01.PrevYear;
 Calendar02.PrevYear;
 Calendar03.PrevYear;
 LastYear:=LastYear-1;
 UpdateView;
end;

procedure TfrmCalendarView.PrevPartButtonClick(Sender: TObject);
begin
 Calendar01.PrevPart;
 Calendar02.PrevPart;
 Calendar03.PrevPart;
 LastPart:=LastPart-1;
 if LastPart=-1 then
 begin
  LastPart:=3;
  LastYear:=LastYear-1;
 end;
 UpdateView;
end;

procedure TfrmCalendarView.NextPartButtonClick(Sender: TObject);
begin
 Calendar01.NextPart;
 Calendar02.NextPart;
 Calendar03.NextPart;
 LastPart:=LastPart+1;
 if LastPart=4 then
 begin
  LastPart:=0;
  LastYear:=LastYear+1;
 end;
 UpdateView;
end;

procedure TfrmCalendarView.NextYearButtonClick(Sender: TObject);
begin
 Calendar01.NextYear;
 Calendar02.NextYear;
 Calendar03.NextYear;
 LastYear:=LastYear+1;
 UpdateView;
end;

procedure TfrmCalendarView.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
end;

procedure TfrmCalendarView.FormCreate(Sender: TObject);
begin
 FirstActive:=True;
end;

end.
