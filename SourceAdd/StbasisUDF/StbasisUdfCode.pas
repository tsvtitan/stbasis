unit StbasisUdfCode;

interface

uses Windows, SysUtils,StbasisUdfData;

procedure InitAll;
procedure DeInitAll;

function ServerDate(var ServerIBDateTime: TIBDateTime): PIBDateTime; cdecl; export;
function Trim(P: PChar): PChar; cdecl; export;
function LTrim(P: PChar): PChar; cdecl; export;
function RTrim(P: PChar): PChar; cdecl; export;
function SubStr(PSubStr, PStr: PChar): Integer; cdecl; export;
function SubStrEx(PStr: PChar; var FromPos, ToPos: Integer): PChar; cdecl; export;
function ChangeStringEx(PStr,PStrOld,PStrNew: PChar): PChar; cdecl; export;
function Now: PIBDateTime; cdecl; export;
function AddStr(Str1, Str2, Str3: PChar): PChar; cdecl; export;


function sys_CreateMainId: PChar; cdecl; export;
function sys_DateTimeToDate(var DateTime: TIBDateTime): PIBDateTime; cdecl; export;
function sys_DateTimeToTime(var DateTime: TIBDateTime): PIBDateTime; cdecl; export;
function sys_DateTimeToYear(var DateTime: TIBDateTime): Integer; cdecl; export;
function sys_DateTimeToMonth(var DateTime: TIBDateTime): Integer; cdecl; export;
function sys_DateTimeToDay(var DateTime: TIBDateTime): Integer; cdecl; export;
function sys_FormatDateTime(Format: PChar; var DateTime: TIBDateTime): PChar; cdecl; export;

function sys_AddStr(Str1, Str2, Str3, Str4: PChar): PChar; cdecl; export;
function sys_CompareStr(var MaxCompareLen: Integer; SubStr, Str: PChar): Integer; cdecl; export;
function sys_CompareStr2(SubStr, Str: PChar): Integer; cdecl; export;
function sys_CompareStrByWord(SubStr, Str: PChar): Integer; cdecl; export;
function sys_CompareStr4(SubStr, Str: PChar): Integer; cdecl; export;
function sys_AnsiPos(SubStr, Str: PChar): Integer; cdecl; export;
function sys_Like(SubStr, Str: PChar): Integer; cdecl; export;


implementation

uses Classes, Controls, Dialogs, ActiveX, math;

(*
declare external function ServerDate
  date
returns
  date
entry_point 'ServerDate'
module_name 'stbasisudf.dll';
*)

function ServerDate(var ServerIBDateTime: TIBDateTime): PIBDateTime; cdecl; export;
var
  DateTime: TDateTime;
  DelphyDays : Integer;
begin
  DateTime := SysUtils.Now;
  DelphyDays := Trunc(DateTime);
  with ServerIBDateTime do begin
    Days := DelphyDays + IBDateDelta;
    MSec10 := Trunc((DateTime - DelphyDays) * MSecsPerDay10);
  end;
  Result := @ServerIBDateTime;
end;

function Now: PIBDateTime; cdecl; export;
var
  DateTime: TDateTime;
  DelphyDays : Integer;
begin
  DateTime := SysUtils.Now;
  DelphyDays := Trunc(DateTime);
  with RetServerDate do begin
    Days := DelphyDays + IBDateDelta;
    MSec10 := Trunc((DateTime - DelphyDays) * MSecsPerDay10);
  end;
  Result := @RetServerDate;
end;

procedure TrimX(var CString: PChar; Mode : Integer);
var
  PChr: PChar;
begin
// Trim left
  if Mode and 2 > 0 then
    while (CString^ = ' ') do
     Inc(CString);

// Trim right
  if Mode and 1 > 0 then begin
    PChr:= CString + StrLen(CString) - 1;
    while (PChr > CString) and (PChr^ = ' ') do
     Dec(PChr);
    PChr[1]:= #0;
  end;
end;

(*
declare external function Trim
  cstring(256), integer
returns
  cstring(256)
entry_point 'Trim'
module_name 'stbasisudf.dll';
*)

function Trim(P: PChar): PChar; cdecl; export;
begin
  TrimX(P,1);
  TrimX(P,2);
  Result:=P;
end;

(*
declare external function LTrim
  cstring(256), integer
returns
  cstring(256)
entry_point 'LTrim'
module_name 'stbasisudf.dll';
*)
function LTrim(P: PChar): PChar; cdecl; export;
begin
  TrimX(P,2);
  Result:=P;
end;

(*
declare external function RTrim
  cstring(256), integer
returns
  cstring(256)
entry_point 'RTrim'
module_name 'stbasisudf.dll';
*)
function RTrim(P: PChar): PChar; cdecl; export;
begin
  TrimX(P,1);
  Result:=P;
end;

(*
 declare external function SubStr
  cstring(254),
  cstring(254)
  returns
  integer by value
  entry_point 'SubStr'
  module_name 'stbasisudf.dll';
*)
function SubStr(PSubStr, PStr: PChar): Integer; cdecl; export;
begin
  result:= Pos(String(PSubStr), String(PStr)) - 1;
end;

function SubStrEx(PStr: PChar; var FromPos, ToPos: Integer): PChar; cdecl; export;
begin
  Result:=PChar(Copy(PStr,FromPos,ToPos));
end;

function ChangeString(Value: string; strOld, strNew: string): string;
var
  tmps: string;
  APos: Integer;
  s1,s3: string;
  lOld: Integer;
begin
  Apos:=-1;
  s3:=Value;
  lOld:=Length(strOld);
  while APos<>0 do begin
    APos:=Pos(strOld,s3);
    if APos>0 then begin
      SetLength(s1,APos-1);
      Move(Pointer(s3)^,Pointer(s1)^,APos-1);
      s3:=Copy(s3,APos+lOld,Length(s3)-APos-lOld+1);
      tmps:=tmps+s1+strNew;
    end else
      tmps:=tmps+s3;
  end;
  Result:=tmps;
end;

function ChangeStringEx(PStr,PStrOld,PStrNew: PChar): PChar; cdecl; export;
var
  s1,s2,s3: string;
begin
  s1:=PStr;
  s2:=PStrOld;
  s3:=PStrNew;
  Result:=PChar(ChangeString(s1,s2,s3));
end;

function AddStr(Str1, Str2, Str3: PChar): PChar; cdecl; export;
var
  i,j,k :integer;
  s, s1,s2,s3 :String;
begin
  s  := '';
  s1 := '';
  s2 := '';
  s3 := '';

  i := 0;
  while (I < 80) and (str1[i] <> #0) do
  begin
    if (str1[i]<> ' ') then s1 := String(s1)+str1[i];
    Inc(I);
  end;
  j := 0;
  while (j < 80) and (str2[j] <> #0) do
  begin
    if (str2[j]<> ' ') then s2 := String(s2)+str2[j];
    Inc(j);
  end;
  k := 0;
  while (k < 80) and (str3[k] <> #0) do
  begin
    if (str3[k]<> ' ') then s3 := String(s3)+str3[k];
    Inc(k);
  end;

   s := s1 + s2 + s3 + '   ';
   s[i+j+k] := #0;
   Result := PChar(s);
end;


{
russian:
  GUID_UDF - библиотека функций для получения GUID (уникального идентификатора).
  GUID характеризуется гарантией уникальности при использовании на разных компьютерах.
  подробнее по GUID см. www.microsoft.com.

  Поскольку у функции GUID возвращаемое значение меняется от старших разрядов к младшим, такие
  значения плохо упаковываются индексами IB. Для нормальной упаковки прилагается функция
  CreateReverseGUID, которая "переворачивает" значение GUID.
  При этом индекс автоматически оказывается упакованным в 8
  раз по сравнению с использованием CreateGUID!

  Функции CreateGUID и CreateReverseGUID проверены и являются thread-safe.
  Несмотря на то, что функции задекларированы как возвращающие
  36 символов, они возвращают реально всегда 32 символа. Поэтому
  первичный ключ для хранения GUID, получаемого из данных функций,
  следует объявлять как CHAR(32).

  Из стандартного строкового GUID вырезаны обрамляющие фигурные скобки
  и дефисы как не несущие полезной информации).

(c) Epsylon Technologies, Kouzmenko Dmitri, dima@demo.ru, http://ib.demo.ru (1251).

}

function CreateClassID: string;
var
 ClassID: TCLSID;
 P: PWideChar;
begin
 CoCreateGuid(ClassID);
 StringFromCLSID(ClassID, P);
 Result := P;
 CoTaskMemFree(P);
end;

{ DECLARE EXTERNAL FUNCTION CreateGUID
  integer, cstring(36)
  RETURNS PARAMETER 2
  ENTRY_POINT 'CreateGUID' MODULE_NAME 'GUID_UDF';}

procedure CreateGUID(var i: integer; p: pchar);
var s: string[36];
begin
 i:=0;
 s:=Copy(CreateClassID, 2, 36);
 StrPCopy(P,
   Copy(s, 1,  8)+
   Copy(s, 10, 4)+
   Copy(s, 15, 4)+
   Copy(s, 20, 4)+
   Copy(s, 25,12));
end;

{DECLARE EXTERNAL FUNCTION CreateRevGUID
  integer, cstring(36)
  RETURNS PARAMETER 2
  ENTRY_POINT 'CreateReverseGUID' MODULE_NAME 'GUID_UDF'}

procedure CreateReverseGUID(var i: integer; p: pchar);
var s: string[36];
begin
 i:=0;
 s:=Copy(CreateClassID, 2, 36);
 StrPCopy(P,
   Copy(s, 25, 12)+
   Copy(s, 20, 4)+
   Copy(s, 15, 4)+
   Copy(s, 10, 4)+
   Copy(s, 1, 8));
end;

function DeleteDelimAndReverse(S: string): string;
begin
  Result:=Copy(s, 26, 12)+Copy(s, 21, 4)+Copy(s, 16, 4)+Copy(s, 11, 4)+Copy(s, 2, 8);
end;

function sys_CreateMainId: PChar; cdecl; export;
var
  s: string;
begin
  s:=Copy(CreateClassID, 1, 37);
  S:=DeleteDelimAndReverse(s);
  Result:=PChar(S);
end;

function sys_DateTimeToDate(var DateTime: TIBDateTime): PIBDateTime; cdecl; export;
begin
  DateTime.MSec10:=0;
  Result := @DateTime;
end;

function sys_DateTimeToTime(var DateTime: TIBDateTime): PIBDateTime; cdecl; export;
begin
  DateTime.Days:=0;
  Result := @DateTime;
end;

function sys_DateTimeToYear(var DateTime: TIBDateTime): Integer; cdecl; export;
var
  dt: TDateTime;
  Y,M,D: Word;
begin
  dt := DateTime.Days-IBDateDelta;
  DecodeDate(dt,Y,M,D);
  Result := Y;
end;

function sys_DateTimeToMonth(var DateTime: TIBDateTime): Integer; cdecl; export;
var
  dt: TDateTime;
  Y,M,D: Word;
begin
  dt := DateTime.Days-IBDateDelta;
  DecodeDate(dt,Y,M,D);
  Result := M;
end;

function sys_DateTimeToDay(var DateTime: TIBDateTime): Integer; cdecl; export;
var
  dt: TDateTime;
  Y,M,D: Word;
begin
  dt := DateTime.Days-IBDateDelta;
  DecodeDate(dt,Y,M,D);
  Result := D;
end;

function sys_FormatDateTime(Format: PChar; var DateTime: TIBDateTime): PChar; cdecl; export;
var
  dt: TDate;
  tm: TTime;
begin
  dt:=DateTime.Days-IBDateDelta;
  if DateTime.MSec10>0 then tm:=DateTime.MSec10/power(10,9)
  else tm:=0;
  ShowMessage(FloatToStr(dt));
  Result:=PChar(FormatDateTime(Format,dt+tm));
end;

function sys_AddStr(Str1, Str2, Str3, Str4: PChar): PChar; cdecl; export;
var
  s1,s2,s3,s4: string;
begin
  s1:=Str1;
  s2:=Str2;
  s3:=Str3;
  s4:=Str4;
  Result:=PChar(s1+s2+s3+s4);
end;

Type
   TRetCount = packed record
       lngSubRows   : Word;
       lngCountLike : Word;
   end;


{function Matching(StrInputA: WideString;
                  StrInputB: WideString;
                  lngLen: Integer) : TRetCount;
Var
    TempRet   : TRetCount;
    PosStrB   : Integer;
    PosStrA   : Integer;
    StrA      : WideString;
    StrB      : WideString;
    StrTempA  : WideString;
    StrTempB  : WideString;
    la,lb: Integer;
begin
    StrA := String(StrInputA);
    StrB := String(StrInputB);

    la:=Length(strA) - lngLen + 1;
    For PosStrA:= 1 To la do
    begin
       StrTempA:= System.Copy(strA, PosStrA, lngLen);

       lb:=Length(strB) - lngLen + 1;
       For PosStrB:= 1 To lb do
       begin
          StrTempB:= System.Copy(strB, PosStrB, lngLen);
          If SysUtils.AnsiCompareText(StrTempA,StrTempB) = 0 Then
//          If SysUtils.CompareText(StrTempA,StrTempB) = 0 Then
          begin
             Inc(TempRet.lngCountLike);
             break;
          end;
       end;

       Inc(TempRet.lngSubRows);
    end; // PosStrA

    Matching.lngCountLike:= TempRet.lngCountLike;
    Matching.lngSubRows  := TempRet.lngSubRows;
end; { function }

function Matching(StrInputA: PChar;
                  StrInputB: PChar;
                  lngLen: Integer;
                  la,lb: Integer) : TRetCount;
Var
    TempRet   : TRetCount;
    PosStrB   : Integer;
    PosStrA   : Integer;
    StrTempA  : string;
    StrTempB  : String;
begin
   TempRet.lngCountLike:=0;
   TempRet.lngSubRows:=0;;


    For PosStrA:= 1 To la do
    begin
       StrTempA:= System.Copy(StrInputA, PosStrA, lngLen);

       For PosStrB:= 1 To lb do
       begin
          StrTempB:= System.Copy(StrInputB, PosStrB, lngLen);
          If SysUtils.SameText(StrTempA,StrTempB) Then
          begin
             Inc(TempRet.lngCountLike);
             break;
          end;
       end;

       Inc(TempRet.lngSubRows);
    end; // PosStrA

    Result.lngCountLike:= TempRet.lngCountLike;
    Result.lngSubRows  := TempRet.lngSubRows;
end; { function }

//------------------------------------------------------------------------------
function IndistinctMatching(MaxMatching     : Integer;
                            strInputMatching: PChar;
                            strInputStandart: PChar): Integer;
Var
    gret     : TRetCount;
    tret     : TRetCount;
    lngCurLen: Integer   ; //текущая длина подстроки
    l1,l2: Integer;
    la,lb: Integer;
begin
    //если не передан какой-либо параметр, то выход

    strInputMatching:=AnsiStrUpper(strInputMatching);
    strInputStandart:=AnsiStrUpper(strInputStandart);

    l1:=Length(strInputMatching);
    l2:=Length(strInputStandart);
    If (MaxMatching = 0) Or (l1 = 0) Or (l2 = 0) Then
    begin
        IndistinctMatching:= 0;
        exit;
    end;

    gret.lngCountLike:= 0;
    gret.lngSubRows  := 0;

    // Цикл прохода по длине сравниваемой фразы

    For lngCurLen:= 1 To MaxMatching do
    begin
        la:=l1 - lngCurLen + 1;
        lb:=l2 - lngCurLen + 1;
        //Сравниваем строку A со строкой B
        tret:= Matching(strInputMatching, strInputStandart, lngCurLen,la,lb);
        gret.lngCountLike := gret.lngCountLike + tret.lngCountLike;
        gret.lngSubRows   := gret.lngSubRows + tret.lngSubRows;
        //Сравниваем строку B со строкой A
        tret:= Matching(strInputStandart, strInputMatching, lngCurLen,lb,la);
        gret.lngCountLike := gret.lngCountLike + tret.lngCountLike;
        gret.lngSubRows   := gret.lngSubRows + tret.lngSubRows;
    end;

    If gret.lngSubRows = 0 Then
    begin
        Result:= 0;
        exit;
    end;

    Result:= Trunc((gret.lngCountLike / gret.lngSubRows) * 100);
end;

function sys_CompareStr(var MaxCompareLen: Integer; SubStr, Str: PChar): Integer; cdecl; export;
begin
  Result:=IndistinctMatching(MaxCompareLen,SubStr,Str);
end;

function IndistinctMatching2(A,B: String): Real;
var
  la,lb: Byte;

   function Match(i,j: Byte): integer;
      label _Loop;
      var GlobalSumm, Summ, Max: integer;
      begin
          GlobalSumm:=0;
          Max:=0;
          _Loop:
             if A[i]=B[j] then begin
               Inc(GlobalSumm);
               if(i<la) and (j<lb)then begin
                 Inc(i);
                 Inc(j);
                 goto _Loop;
               end;
             end;
          if(i<la) and (j<lb)then begin
             Summ := Match(i+1,j+1);
             if(Max < Summ)then
                Max := Summ;
          end;
          if(i<la)then begin
             Summ := Match(i+1,j);
             if(Max < Summ)then
                Max := Summ;
          end;
          if(j<lb)then begin
             Summ := Match(i,j+1);
             if(Max < Summ)then
                Max := Summ;
          end;
          Match := GlobalSumm + Max;
      end;

begin
  la:=Byte(Length(A));
  lb:=Byte(Length(B));
  Result:= Match(1,1) * 2.0 / (la + lb);
end;

function sys_CompareStr2(SubStr, Str: PChar): Integer; cdecl; export;
begin
  if AnsiSameText(SubStr,Str) then
    Result:=100
  else Result:=Round(IndistinctMatching2(SubStr,Str)*100);
end;

function StrFastCopy( s1 : PChar; const s : string ) :PChar;
var
  len : Integer;
begin
  len := Length(s);
  StrMove(S1, PChar(s), len);
  Result := s1 + len;
end;

function sys_CompareStrByWord(SubStr, Str: PChar): Integer; cdecl; export;

  procedure GetStrings(s: string; str: TStringList);
  var
    i: Integer;
    ch: char;
    p0: PChar;
    ppos: Integer;

    procedure Add;
    begin
      ch:=#0;
      if (ppos>2)and (ppos<=4) then begin
        Move(ch,Pointer(Integer(Pointer(p0))+ppos-1)^,1);
      end else if (ppos>4) then begin
        Move(ch,Pointer(Integer(Pointer(p0))+ppos-2)^,1); 
      end else
        Move(ch,Pointer(Integer(Pointer(p0))+ppos)^,1);
      if ppos>=2 then
        str.Add(p0);
      ppos:=0;
    end;

  const
    Separators: set of char = [' ','-','.',',','/','\', '#', '"', '''','!','?','$','@',
                               ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];
  begin
    GetMem(p0,Length(s));
    try
      ppos:=0;
      for i:=1 to Length(s) do begin
        ch:=s[i];
        if not (ch in Separators) then begin
          Move(ch,Pointer(Integer(Pointer(p0))+ppos)^,1);
          inc(ppos);
        end else if ppos>0 then
          Add;
      end;
      if ppos>0 then
        Add;
    finally
      FreeMem(p0, Length(s));
    end;  
  end;
  
var
  str1,str2: TStringList;
  WordFind,WordCount: Integer;
  s1,s2: string;
  i: Integer;
begin
  WordFind:=0;
  str1:=TStringList.Create;
  str2:=TStringList.Create;
  try
    s1:=AnsiUpperCase(SubStr);
    s2:=AnsiUpperCase(Str);
    GetStrings(s1,str1);
    GetStrings(s2,str2);
    WordCount:=str1.Count+str2.Count;
    for i:=0 to str1.Count-1 do begin
      if System.Pos(str1.Strings[i],s2)>0 then
        inc(WordFind);
    end;
    for i:=0 to str2.Count-1 do begin
      if System.Pos(str2.Strings[i],s1)>0 then
        inc(WordFind);
    end;
  finally
    str2.Free;
    str1.Free;
  end;
  if WordCount=0 then begin
    Result:=0;
    exit;
  end;
  Result:=Round(WordFind/WordCount*100);
end;

function sys_CompareStr4(SubStr, Str: PChar): Integer; cdecl; export;

  procedure CheckStr(s1,s2: string; var cf,cc: Integer);
  var
    ls1,ls2: Integer;
    j: Integer;
    i1,i2: Integer;
  const
    Separators: set of char = [' ','-','.',',','/','\', '#', '"', '''','!','?','$','@',
                               ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];
  begin
    ls1:=Length(s1);
    ls2:=Length(s2);
    i2:=1;
    for i1:=1 to ls1 do begin
      if not (s1[i1] in Separators) then begin
        Inc(cc);
        if ls2>=i2 then begin
          if s2[i2]=s1[i1] then begin
            Inc(cf);
            inc(i2);
          end else begin
            inc(i2);
            for j:=i2 to ls2 do begin
              inc(i2);
              if not (s2[j] in Separators) then
                if s2[j]=s1[i1] then begin
                  inc(cf);
                  break;
                end;
            end;
          end;
        end;
      end;  
    end;
  end;

var
  CharFind,CharCount: Integer;
  s1,s2: string;
begin
  CharFind:=0;
  CharCount:=0;
  s1:=AnsiUpperCase(Substr);
  s2:=AnsiUpperCase(Str);
  CheckStr(s1,s2,CharFind,CharCount);
//  CheckStr(s2,s1,CharFind,CharCount);
  if CharCount=0 then begin
    Result:=0;
    exit;
  end;
  Result:=Trunc(CharFind/CharCount*100);
end;

function sys_AnsiPos(SubStr, Str: PChar): Integer; cdecl; export;
begin
  Result:=AnsiPos(SubStr,Str);
end;

type
  TSetOfChar=set of char;

function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
var
  tmps: string;
  i: integer;
begin
  for i:=1 to Length(s) do begin
    if S[i] in SetOfChar then break;
    tmps:=tmps+S[i];
    Pos:=i;
  end;
  Result:=tmps;
end;

function isInteger(const Value: string): Boolean;
var
  E: Integer;
  ret: Integer;
begin
  Val(Value, ret, E);
  Result:=(E=0)and(ret<>Null);
end;

procedure GetAllWordsFromString(S: string; str: TStringList);
var
  Pos: Integer;
  word: string;
  incPos: Integer;
  isInc: Boolean;
const
  Separators: set of char = [#00,' ','-',#13, #10,'.',',','/','\', '#', '"', '''','!','?','$','@',
                             ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];
begin
  if SysUtils.Trim(S)='' then exit;
  incPos:=0;
  while true do begin
    Pos:=1;
    word:=GetFirstWord(s,Separators,Pos);
    if (s[Pos]=#13)or(s[Pos]=#10) then
      isInc:=false
    else isInc:=true;

    s:=Copy(s,Pos+1,Length(s)-Pos);
    if (SysUtils.Trim(word)<>'')and
       (Length(word)>1) then
          str.AddObject(word,TObject(Pointer(incPos)));
    if SysUtils.Trim(s)='' then exit;

    if isInc then
     incPos:=incPos+Pos;
  end;
end;

function sys_Like(SubStr, Str: PChar): Integer; cdecl; export;
var
  Astr: TStringList;
  i: Integer;
begin
  Result:=0;
  Astr:=TStringList.Create;
  try
    GetAllWordsFromString(SubStr,Astr);
    for i:=0 to Astr.Count-1 do begin
      Result:=AnsiPos(Astr.Strings[i],Str);
      if Result>0 then break;
    end;
  finally
    Astr.Free;
  end;
end;

procedure InitAll;
begin
end;

procedure DeInitAll;
begin
end;

end.
