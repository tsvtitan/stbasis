unit StCalendarGrid;

{$I stbasis.inc}

interface

uses Windows, Classes, Controls, Grids, PickDate;

type

 TStCalendar=class(TRxCalendar)
 private
  procedure CreateParams(var Params: TCreateParams); override;
  function IsCellHoliday(ACol, ARow: Integer): Boolean;
  function NextDayIsHoliday(ACol, ARow: Integer): Boolean;
  function IsCellPrevDayWeekendAndHoliday(ACol, ARow: Integer): Boolean;
  function IsCellCarryingFrom(ACol, ARow: Integer):Boolean;
  function IsCellCarryingTo(ACol, ARow: Integer):Boolean;
  procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
 public
  constructor Create(AOwner: TComponent); override;
  procedure PrevPart;
  procedure NextPart;
 published
  property CalendarDate;
  property Day;
  property Month;
  property ReadOnly;
  property UseCurrentDate;
  property WeekendColor;
  property Year;
  property OnChange;
 end;

implementation

uses Graphics, ExtCtrls, SysUtils, DateUtil, StCalendarUtil;

constructor TStCalendar.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 Weekends:=[Sun,Sat];
end;

procedure TStCalendar.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
end;

function TStCalendar.IsCellHoliday(ACol, ARow: Integer): Boolean;
var TheDay:Byte;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsHoliday(EncodeDate(Year,Month,TheDay));
end;

function TStCalendar.NextDayIsHoliday(ACol, ARow: Integer): Boolean;
var TheDay:Word;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 if IsWeekend(ACol, ARow) or IsHoliday(EncodeDate(Year,Month,TheDay)) then Exit;
 Result:=IsHoliday(IncDay(EncodeDate(Year,Month,TheDay),1));
end;

//Празник попавший на выходной
function TStCalendar.IsCellPrevDayWeekendAndHoliday(ACol, ARow: Integer): Boolean;
var TheDay:Byte;
begin
 Result:=False;
 if IsWeekend(ACol, ARow) then Exit;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsPrevDayWeekendAndHoliday(EncodeDate(Year,Month,TheDay));
end;

function TStCalendar.IsCellCarryingFrom(ACol, ARow: Integer):Boolean;
var TheDay:Byte;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsCarryingFrom(EncodeDate(Year,Month,TheDay));
end;

function TStCalendar.IsCellCarryingTo(ACol, ARow: Integer):Boolean;
var TheDay:Byte;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsCarryingTo(EncodeDate(Year,Month,TheDay));
end;

procedure TStCalendar.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var TheText: string;
    D, M, Y: Word;
begin
 TheText := CellText[ACol, ARow];
 DecodeDate(CalendarDate, Y, M, D);
 D := StrToIntDef(TheText, 0);
 with ARect, Canvas do begin
  if {((not (gdSelected in AState)) or (not Focused)) and } (D<>0) then
  begin
   Brush.Color := clWindow;
   Font.Color := clWindowText;
  end;
  if IsWeekend(ACol, ARow) or IsCellHoliday(ACol, ARow) or
   IsCellPrevDayWeekendAndHoliday(ACol, ARow) then
   Font.Color := WeekendColor;

  if IsCellCarryingTo(ACol, ARow) then
   Font.Color := WeekendColor;

  if IsCellCarryingFrom(ACol, ARow) then
   Font.Color := clWindowText;
  TextRect(ARect, Left + (Right - Left - TextWidth(TheText)) div 2,
   Top + (Bottom - Top - TextHeight(TheText)) div 2, TheText);
  //Если сегодня
  if (D>0) and (D<=DaysPerMonth(Y,M)) and (EncodeDate(Y,M,D)=SysUtils.Date) then
   Frame3D(Canvas, ARect, clBtnFace, clBtnShadow, 3);
  Brush.Color := clBlack;
  Brush.Style := bsSolid;
  Font.Color := clWindowText;
  if (NextDayIsHoliday(ACol, ARow)) then
   Ellipse(Right,Top,Right-((Right - Left) div 3),Top+((Bottom - Top) div 2));
 end;
end;

procedure TStCalendar.PrevPart;
begin
 PrevMonth;
 PrevMonth;
 PrevMonth;
end;

procedure TStCalendar.NextPart;
begin
 NextMonth;
 NextMonth;
 NextMonth;
end;

end.
