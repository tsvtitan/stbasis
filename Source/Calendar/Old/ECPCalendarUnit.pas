{***************************************************}
{*                                                 *}
{*    ECP Calendar unit                            *}
{*                                                 *}
{*    Copyright (c) 1998-99 Bishop Computer Center *}
{*                                                 *}
{***************************************************}
unit ECPCalendarUnit;

interface

uses Windows, Classes, Controls, Grids, PickDate;

type

 TECPCalendar=class(TRxCalendar)
 public
  constructor Create(AOwner: TComponent); override;
  procedure CreateParams(var Params: TCreateParams); override;
  function IsCellHoliday(ACol, ARow: Integer): Boolean;
  function NextDayIsHoliday(ACol, ARow: Integer): Boolean;
  function PrevDayIsWeekendAndHoliday(ACol, ARow: Integer): Boolean;
  function IsCellCarryingFrom(ACol, ARow: Integer):Boolean;
  function IsCellCarryingTo(ACol, ARow: Integer):Boolean;
  procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
 end;

implementation

uses Graphics, SysUtils, ExtCtrls, ECPLibUnit, DateUtil, CalendarCommonUnit;

constructor TECPCalendar.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

procedure TECPCalendar.CreateParams(var Params: TCreateParams);
begin
 inherited CreateParams(Params);
end;

function TECPCalendar.IsCellHoliday(ACol, ARow: Integer): Boolean;
var TheDay:Byte;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsHoliday(EncodeDate(Year,Month,TheDay));
end;

function TECPCalendar.NextDayIsHoliday(ACol, ARow: Integer): Boolean;
var TheDay:Word;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 if IsWeekend(ACol, ARow) or IsHoliday(EncodeDate(Year,Month,TheDay)) then Exit;
 Result:=IsHoliday(IncDay(EncodeDate(Year,Month,TheDay),1));
end;

function TECPCalendar.PrevDayIsWeekendAndHoliday(ACol, ARow: Integer): Boolean;
var D,DOld:TDateTime;
    {Y,M,} TheDay:Word;
    Flag:Boolean;
begin
 Result:=False;
 if IsWeekend(ACol, ARow) then Exit;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 D:=EncodeDate(Year,Month,TheDay);
 DOld:=D;
 D:=IncDay(D,-1);//Взять предыдущий день
// DecodeDate(D,Y,M,TheDay);
 if (DayOfWeek(D)=1) or (DayOfWeek(D)=7) then//Выходной ?
 begin
  Flag:=IsHoliday(D);//Праздник ?
  D:=IncDay(D,-1);//Взять ещё днём раньше
//  DecodeDate(D,Y,M,TheDay);     //Если один из дней одновременно то...
  Result:=(((DayOfWeek(D)=1) or (DayOfWeek(D)=7)) and IsHoliday(D)) or Flag;
 end
 else
 begin
  D:=IncDay(DOld,-2);
//  DecodeDate(D,Y,M,TheDay);
  Flag:=((DayOfWeek(D)=1) or (DayOfWeek(D)=7)) and IsHoliday(D);
  D:=IncDay(D,-1);
//  DecodeDate(D,Y,M,TheDay);
  Result:=Flag and (((DayOfWeek(D)=1) or (DayOfWeek(D)=7)) and IsHoliday(D));
 end;
end;

function TECPCalendar.IsCellCarryingFrom(ACol, ARow: Integer):Boolean;
var TheDay:Byte;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsCarryingFrom(EncodeDate(Year,Month,TheDay));
end;

function TECPCalendar.IsCellCarryingTo(ACol, ARow: Integer):Boolean;
var TheDay:Byte;
begin
 Result:=False;
 TheDay:=FMonthOffset + ACol + (ARow - 1) * 7;
 if (TheDay < 1) or (TheDay > DaysThisMonth) then Exit;
 Result:=IsCarryingTo(EncodeDate(Year,Month,TheDay));
end;

procedure TECPCalendar.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
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
   PrevDayIsWeekendAndHoliday(ACol, ARow) or IsCellCarryingTo(ACol, ARow) then
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

end.
