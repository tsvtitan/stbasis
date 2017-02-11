{-------------------------------------------------------------------------------}
{ AnyDAC QA Escape functions                                                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAEvalFuncs;

interface

uses
  daADStanIntf, 
  Classes;

type
  TADQAFunc = class (TObject)
  private
    FEscFunc: String;
    FTrueRes: Variant;
    FResType: TADDataType;
  public
    property EscFunc: String read FEscFunc write FEscFunc;
    property TrueRes: Variant read FTrueRes write FTrueRes;
    property ResType: TADDataType read FResType write FResType;
  end;

  TADQAEvalFuncs = class (TObject)
  private
    FList: TList;
    FSecFunc: Integer;
    function GetTrueRes(AIndex: Integer): Variant;
    function GetEscFunc(AIndex: Integer): String;
    function GetResType(AIndex: Integer): TADDataType;
    function GetCount: Integer;
    function RegisterFunc(AEscFunc: String; ATrueRes: Variant;
      AResType: TADDataType = dtAnsiString): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    procedure InitForPhysLayer;
    property TrueRes[AIndex: Integer]: Variant read GetTrueRes;
    property EscFunc[AIndex: Integer]: String read GetEscFunc;
    property ResType[AIndex: Integer]: TADDataType read GetResType;
    property Count: Integer read GetCount;
  end;


implementation

uses
  SysUtils, Math
{$IFDEF AnyDAC_D6}
  , DateUtils, SqlTimSt
{$ENDIF}  
  ;

{-------------------------------------------------------------------------------}
{ TADQAEvalFuncs                                                                }
{-------------------------------------------------------------------------------}
constructor TADQAEvalFuncs.Create;
begin
  inherited Create;
  FList := TList.Create;
  FSecFunc := -1;
end;

{-------------------------------------------------------------------------------}
destructor TADQAEvalFuncs.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    TADQAFunc(FList[i]).Free;
  FList.Free;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADQAEvalFuncs.RegisterFunc(AEscFunc: String; ATrueRes: Variant;
  AResType: TADDataType = dtAnsiString): Integer;
var
  oFunc: TADQAFunc;
begin
  oFunc := TADQAFunc.Create;
  with oFunc do begin
    EscFunc := AEscFunc;
    TrueRes := ATrueRes;
    ResType := AResType;
  end;
  Result := FList.Add(oFunc);
end;

{-------------------------------------------------------------------------------}
function TADQAEvalFuncs.GetTrueRes(AIndex: Integer): Variant;
begin
  Result := TADQAFunc(FList[AIndex]).TrueRes;
end;

{-------------------------------------------------------------------------------}
function TADQAEvalFuncs.GetEscFunc(AIndex: Integer): String;
var
  H, MM, S, MS: Word;
begin
  Result := TADQAFunc(FList[AIndex]).EscFunc;
  if AIndex = FSecFunc then begin
    DecodeTime(Now, H, MM, S, MS);
    TADQAFunc(FList[AIndex]).TrueRes := S;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQAEvalFuncs.GetResType(AIndex: Integer): TADDataType;
begin
  Result := TADQAFunc(FList[AIndex]).ResType;
end;

{-------------------------------------------------------------------------------}
function TADQAEvalFuncs.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
procedure TADQAEvalFuncs.Init;
var
  sPrevDateFormat: String;
  sPrevDateSeparator: Char;
  wYear, wMonth, wDay, H, MM, S, MS: Word;
begin
  sPrevDateFormat    := ShortDateFormat;
  sPrevDateSeparator := DateSeparator;
  ShortDateFormat    := 'yyyy/mm/dd';
  DateSeparator      := '-';
  try
    RegisterFunc('UPPER(''abcde'')', 'ABCDE');
    RegisterFunc('LOWER(''AbCde'')', 'abcde');
    RegisterFunc('SUBSTRING(''Abcde'', 2, 3)', 'bcd');
    RegisterFunc('TRIM('' abcde '')', 'abcde');
    RegisterFunc('TRIMLEFT('' abcde'')', 'abcde');
    RegisterFunc('TRIMRIGHT(''abcde '')', 'abcde');
    DecodeDate(Date(), wYear, wMonth, wDay);
    DecodeTime(Now(), H, MM, S, MS);
    RegisterFunc('YEAR(NOW)', wYear, dtInt32);
    RegisterFunc('MONTH(NOW)', wMonth, dtInt32);
    RegisterFunc('DAY(NOW)', wDay, dtInt32);
    RegisterFunc('HOUR(NOW)', H, dtInt32);
    RegisterFunc('DATE(NOW)', Date(), dtDateTime);
    RegisterFunc('ABS(-35)', 35, dtInt32);
    RegisterFunc('CEIL(-2.8)', Ceil(-2.8), dtInt32);
    RegisterFunc('COS(2)', Cos(2), dtDouble);
    RegisterFunc('COSH(2)', Cosh(2), dtDouble);
    RegisterFunc('EXP(2)', Exp(2), dtDouble);
    RegisterFunc('FLOOR(-2.8)', Floor(-2.8), dtInt32);
    RegisterFunc('LN(10)', Ln(10), dtDouble);
    RegisterFunc('LOG(3, 45)', LogN(3, 45), dtDouble);
    RegisterFunc('MOD(6, 4)', 6 mod 4, dtInt32);
    RegisterFunc('POWER(2, 5)', Power(2, 5), dtDouble);
    RegisterFunc('ROUND(1.5)', Integer(Round(1.5)), dtInt32);
    RegisterFunc('SIGN(-5)', -1 {Sign(-5)}, dtInt32);
    RegisterFunc('SIN(3)', Sin(3), dtDouble);
    RegisterFunc('SINH(3)', Sinh(3), dtDouble);
    RegisterFunc('SQRT(9)', Sqrt(9), dtDouble);
    RegisterFunc('TAN(8)', Tan(8), dtDouble);
    RegisterFunc('TANH(8)', Tanh(8), dtDouble);
    RegisterFunc('TRUNC(12.24)', Trunc(12.24) + 0.0, dtDouble);
    RegisterFunc('CHR(45)', Chr(45));
    RegisterFunc('CONCAT(''abc'', ''de'')', 'abcde');
    RegisterFunc('INITCAP(''abcde'')', 'Abcde');
    RegisterFunc('INITCAP(''ABCDE'')', 'Abcde');
    RegisterFunc('LPAD(''abcde'', 8, ''R'')', 'RRRabcde');
    RegisterFunc('REPLACE(''222abcd'', ''2'', ''3'')', '333abcd');
    RegisterFunc('RPAD(''abcde'', 8, ''R'')', 'abcdeRRR');
{$IFDEF AnyDAC_D6}
    RegisterFunc('SOUNDEX(''apples'')', 'A142');
{$ENDIF}
    RegisterFunc('SUBSTR(''abcdef'', 3, 2)', 'cd');
    RegisterFunc('TRANSLATE(''1abcd24'', ''124'', ''567'')', '5abcd67');
    RegisterFunc('ASCII(''A'')', Ord('A'), dtInt32);
    RegisterFunc('INSTR(''abecdefeh'', ''e'', 4, 2)', 8, dtInt32);
    RegisterFunc('LENGTH(''abc'')', 3, dtInt32);
    RegisterFunc('ADD_MONTHS(Date(Now), 3)', IncMonth(Date, 3), dtDateTime);
    RegisterFunc('MONTHS_BETWEEN(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''), ' +
                 'TO_DATE(''2003-03-14'', ''yyyy/mm/dd''))', -2.41935483870968, dtDouble);
    RegisterFunc('LAST_DAY(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''))',
                 StrToDate('2003-01-31'), dtDateTime);
    RegisterFunc('FIRST_DAY(TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))',
                 StrToDate('2003-01-01'), dtDateTime);
    RegisterFunc('NEXT_DAY(TO_DATE(''2003-01-02'', ''yyyy/mm/dd''), ''' +
                 LongDayNames[3] + ''')', StrToDate('2003-01-07'), dtDateTime);
    RegisterFunc('TO_CHAR(1210.73, ''0.0'')', FormatFloat('0.0', 1210.7));
    RegisterFunc('TO_CHAR(1210.73, ''#,##0.0'')', FormatFloat('#,##0.0', 1210.7));
    RegisterFunc('TO_CHAR(21, ''0000##'')', '000021');
    RegisterFunc('TO_CHAR(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''), ''yyyy/mm/dd'')',
                 '2003/01/01');
    // RegisterFunc('TO_CHAR(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''), ''MON DDth, YYYY'')', 'JAN 01st, 2003');
    RegisterFunc('TO_NUMBER(''' + FloatToStr(1210.73) + ''', ''9999.9'')', 1210.73, dtDouble);
    RegisterFunc('DECODE(2, 3, 1, 2, 4)', 4, dtInt32);
    RegisterFunc('IF(1>2, 3, 4)', 4, dtInt32);
    RegisterFunc('IF(1<2, 3, 4)', 3, dtInt32);
    RegisterFunc('NVL('''', ''orange'')', 'orange');
    RegisterFunc('GREATEST(11, 2, 3, 10)', 11, dtInt32);
    RegisterFunc('LEAST(11, 2, 3, 10)', 2, dtInt32);
{$IFDEF AnyDAC_D6}
    RegisterFunc('DIFFERENCE(''apples'', ''trees'')', 0, dtDouble);
{$ENDIF}
    RegisterFunc('INSERT(''apple tree'', 1, 5, ''orange'')', 'orange tree');
    RegisterFunc('LOCATE(''g'', ''aggregate'', 4)', 6, dtInt32);
    RegisterFunc('POSITION(''agree'', ''disagree'')', 4, dtInt32);
    RegisterFunc('REPEAT(''bla'', 3)', 'blablabla');
    RegisterFunc('SPACE(4)', '    ');
    RegisterFunc('ACOS(0.5)', 1.0471975511966, dtDouble);
    RegisterFunc('ASIN(0.5)', 0.523598775598299, dtDouble);
    RegisterFunc('ATAN(0.5)', 0.463647609000806, dtDouble);
    RegisterFunc('ATAN2(4, 5)', 0.896055384571344, dtDouble);
    RegisterFunc('COT(0.5)', 1.83048772171245, dtDouble);
    RegisterFunc('DEGREES(PI)', 180, dtDouble);
    RegisterFunc('LOG10(100)', 2, dtDouble);
    RegisterFunc('RADIANS(180)', 3.151592653589, dtDouble);
    RegisterFunc('PI', 3.151592653589, dtDouble);
    RegisterFunc('DAYNAME(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''))', LongDayNames[4]);
    RegisterFunc('DAYOFMONTH(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('DAYOFYEAR(TO_DATE(''2003-02-01'', ''yyyy/mm/dd''))', 32, dtInt32);
    RegisterFunc('MONTHNAME(TO_DATE(''2003-01-01'', ''yyyy/mm/dd''))', LongMonthNames[1]);
    RegisterFunc('EXTRACT(''year'', TO_DATE(''2003-01-01'', ''yyyy/mm/dd''))', 2003, dtInt32);
    RegisterFunc('EXTRACT(''month'', TO_DATE(''2003-01-01'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('EXTRACT(''day'', TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 2, dtInt32);
    RegisterFunc('QUARTER(TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('WEEK(TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('TIMESTAMPADD(''day'', 1, TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))',
                 StrToDate('2003-01-03'), dtDateTime);
    RegisterFunc('TIMESTAMPADD(''week'', 1, TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))',
                 StrToDate('2003-01-09'), dtDateTime);
    RegisterFunc('TIMESTAMPADD(''month'', 1, TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))',
                 StrToDate('2003-02-02'), dtDateTime);
    RegisterFunc('TIMESTAMPADD(''year'', 1, TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))',
                 StrToDate('2004-01-02'), dtDateTime);
    RegisterFunc('TIMESTAMPDIFF(''day'', TO_DATE(''2003-01-01'', ''yyyy/mm/dd''), ' +
                 'TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('TIMESTAMPDIFF(''week'', TO_DATE(''2003-01-09'', ''yyyy/mm/dd''), ' +
                 'TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('TIMESTAMPDIFF(''month'', TO_DATE(''2003-02-02'', ''yyyy/mm/dd''), ' +
                 'TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 1, dtInt32);
    RegisterFunc('TIMESTAMPDIFF(''year'', TO_DATE(''2005-01-02'', ''yyyy/mm/dd''), ' +
                 'TO_DATE(''2003-01-02'', ''yyyy/mm/dd''))', 2, dtInt32);
    RegisterFunc('CONVERT(''CHAR'', 124)', '124');
    RegisterFunc('CONVERT(''WCHAR'', 124)', '124', dtWideString);
    RegisterFunc('CONVERT(''DECIMAL'', ''' + FloatToStr(1.2354) + ''')', 1.2345, dtDouble);
    RegisterFunc('CONVERT(''INTEGER'', ''12345'')', 12345, dtInt32);
    RegisterFunc('CONVERT(''INTERVAL_MONTH'', TO_DATE(''2003-02-02'', ''yyyy/mm/dd''))', 2, dtInt32);
    RegisterFunc('CONVERT(''INTERVAL_YEAR'', TO_DATE(''2003-02-02'', ''yyyy/mm/dd''))', 2003, dtInt32);
    RegisterFunc('CONVERT(''INTERVAL_DAY'', TO_DATE(''2003-02-02'', ''yyyy/mm/dd''))', 2, dtInt32);
    DecodeTime(Now, H, MM, S, MS);
    RegisterFunc('CONVERT(''INTERVAL_HOUR'', NOW)', H, dtInt32);
    DecodeTime(Now, H, MM, S, MS);
    RegisterFunc('CONVERT(''INTERVAL_MINUTE'', NOW)', MM, dtInt32);
    DecodeTime(Now, H, MM, S, MS);
    FSecFunc := RegisterFunc('CONVERT(''INTERVAL_SECOND'', NOW)', S, dtInt32);
    RegisterFunc('CONVERT(''DATE'', NOW)', Date, dtDateTime);
    RegisterFunc('CONVERT(''TIMESTAMP'', CURDATE)',
{$IFDEF AnyDAC_D6}
                  VarSQLTimeStampCreate(DateTimeToSQLTimeStamp(Date)),
{$ELSE}
                  Date,
{$ENDIF}
                  dtDateTimeStamp);
  finally
    ShortDateFormat := sPrevDateFormat;
    DateSeparator   := sPrevDateSeparator;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAEvalFuncs.InitForPhysLayer;
var
  sPrevDateFormat: String;
  sPrevDateSeparator: Char;
begin
  sPrevDateFormat    := ShortDateFormat;
  sPrevDateSeparator := DateSeparator;
  ShortDateFormat    := 'yyyy/mm/dd';
  DateSeparator      := '-';
  try
    RegisterFunc('ABS(-35)', 35, dtInt32);
    RegisterFunc('ACOS(0.5)', 1.0471975511966, dtDouble);
    RegisterFunc('ASCII(''A'')', Ord('A'), dtInt32);
    RegisterFunc('ASIN(0.5)', 0.523598775598299, dtDouble);
    RegisterFunc('ATAN(0.5)', 0.463647609000806, dtDouble);
    RegisterFunc('BIT_LENGTH(''abcde'')', 40, dtInt32);
    RegisterFunc('CEILING(-2.8)', Ceil(-2.8), dtInt32);
    RegisterFunc('CHAR(45)', Chr(45));
    RegisterFunc('CHAR_LENGTH(''abc'')', 3, dtInt32);
    RegisterFunc('CONCAT(''abc'', ''de'')', 'abcde');
    RegisterFunc('COS(2)', Cos(2), dtDouble);
    RegisterFunc('DAYNAME({d ''2003-01-01''})', LongDayNames[4], dtUnknown);
    RegisterFunc('DAYOFMONTH({d ''2003-01-01''})', 1, dtInt32);
    RegisterFunc('DAYOFWEEK({d ''2004-01-01''})', 5, dtInt32);
    RegisterFunc('DAYOFYEAR({d ''2003-02-01''})', 32, dtInt32);
    RegisterFunc('DEGREES({fn PI()})', 180, dtDouble);
    RegisterFunc('DECODE(2, 3, 1, 2, 4)', 4, dtInt32);
    RegisterFunc('DIFFERENCE(''apples'', ''trees'')', 0, dtDouble);
    RegisterFunc('EXP(2)', Exp(2), dtDouble);
    RegisterFunc('EXTRACT(''year'', {d ''2003-01-01''})', 2003, dtInt32);
    RegisterFunc('EXTRACT(''month'', {d ''2003-01-01''})', 1, dtInt32);
    RegisterFunc('EXTRACT(''day'', {d ''2003-01-02''})', 2, dtInt32);
    RegisterFunc('FLOOR(-2.8)', Floor(-2.8), dtInt32);
    RegisterFunc('HOUR({t ''11:20:05''})', 11, dtInt32);
    RegisterFunc('IF(1>2, 3, 4)', 4, dtInt32);
    RegisterFunc('IF(1<2, 3, 4)', 3, dtInt32);
    RegisterFunc('IFNULL(NULL, ''orange'')', 'orange');
    RegisterFunc('INSERT(''apple tree'', 1, 5, ''orange'')', 'orange tree');
    RegisterFunc('LCASE(''AbCde'')', 'abcde');
    RegisterFunc('LEFT(''AbCde'', 3)', 'AbC');
    RegisterFunc('LENGTH(''abc'')', 3, dtInt32);
    RegisterFunc('LOCATE(''g'', ''aggregate'', 4)', 6, dtInt32);
    RegisterFunc('LOG10(100)', 2, dtDouble);
    RegisterFunc('LTRIM('' abcde'')', 'abcde');
    RegisterFunc('MINUTE({t ''11:20:05''})', 20, dtInt32);
    RegisterFunc('MOD(6, 4)', 6 mod 4, dtInt32);
    RegisterFunc('MONTH({d ''2003-10-01''})', 10, dtInt32);
    RegisterFunc('MONTHNAME({d ''2003-01-01''})', LongMonthNames[1], dtUnknown);
    RegisterFunc('LOG(45)', Ln(45), dtDouble);
    RegisterFunc('OCTET_LENGTH(''abcde'')', 5, dtInt32);
    RegisterFunc('PI()', 3.141592653589, dtDouble);
    RegisterFunc('POSITION(''agree'', ''disagree'')', 4, dtInt32);
    RegisterFunc('POWER(2, 5)', Power(2, 5), dtDouble);
    RegisterFunc('QUARTER({d ''2003-01-02''})', 1, dtInt32);
    RegisterFunc('RADIANS(180)', 3.141592653589, dtDouble);
    RegisterFunc('REPEAT(''bla'', 3)', 'blablabla');
    RegisterFunc('REPLACE(''222abcd'', ''2'', ''3'')', '333abcd');
    RegisterFunc('RIGHT(''AbCde'', 3)', 'Cde');
    RegisterFunc('ROUND(1.51)', Integer(Round(1.51)), dtInt32);
    RegisterFunc('RTRIM(''abcde '')', 'abcde');
    RegisterFunc('SECOND({t ''11:20:05''})', 5, dtInt32);
    RegisterFunc('SIGN(-5)', -1 {Sign(-5)}, dtInt32);
    RegisterFunc('SIN(3)', Sin(3), dtDouble);
    RegisterFunc('SOUNDEX(''apples'')', 'A142');
    RegisterFunc('SPACE(4)', '    ');
    RegisterFunc('SQRT(9)', Sqrt(9), dtDouble);
    RegisterFunc('SUBSTRING(''Abcde'', 2, 3)', 'bcd');
    RegisterFunc('TAN(8)', Tan(8), dtDouble);
    RegisterFunc('TIMESTAMPADD(''day'', 1, {d ''2003-01-02''})',
                 StrToDate('2003-01-03'), dtDateTime);
    RegisterFunc('TIMESTAMPADD(''week'', 1, {d ''2003-01-02''})',
                 StrToDate('2003-01-09'), dtDateTime);
    RegisterFunc('TIMESTAMPADD(''month'', 1, {d ''2003-01-02''})',
                 StrToDate('2003-02-02'), dtDateTime);
    RegisterFunc('TIMESTAMPADD(''year'', 1, {d ''2003-01-02''})',
                 StrToDate('2004-01-02'), dtDateTime);
    RegisterFunc('TIMESTAMPDIFF(''day'', {d ''2003-01-01''}, {d ''2003-01-02''})', 1, dtInt32);
    RegisterFunc('TIMESTAMPDIFF(''week'', {d ''2003-01-02''}, {d ''2003-01-09''})', 1, dtInt32);
    RegisterFunc('TIMESTAMPDIFF(''month'', {d ''2003-01-02''}, {d ''2003-02-02''})', 1, dtInt32);
    RegisterFunc('TIMESTAMPDIFF(''year'', {d ''2003-01-02''}, {d ''2005-01-02''})', 2, dtInt32);
    RegisterFunc('TRUNCATE(12.24)', Trunc(12.24) + 0.0, dtDouble);
    RegisterFunc('UCASE(''abcde'')', 'ABCDE');
    RegisterFunc('WEEK({d ''2003-01-02''})', 1, dtInt32);
    RegisterFunc('YEAR({d ''2003-10-01''})', 2003, dtInt32);
    {RegisterFunc('CATALOG()', '');
    RegisterFunc('SCHEMA()', '');}
  finally
    ShortDateFormat := sPrevDateFormat;
    DateSeparator   := sPrevDateSeparator;
  end;
end;

end.
