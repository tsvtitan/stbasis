unit StbasisSUtils;

interface

uses Windows, Classes, SysUtils, ShellApi, Graphics;

type
  TSetOfChar=set of Char;

function CreateUniqueId: String;
function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
function DeleteDelimAndReverse(S: string): string;
function CheckUniqueIdByAdapter(const UniqueId: string): Boolean;
procedure FillUniqueIdsByAdapter(Strings: TStrings);

function CharIsNumber(const C: AnsiChar): Boolean;
function CharIsDigit(const C: AnsiChar): Boolean;
function CharIsControl(const C: AnsiChar): Boolean;
function CharIsPrintable(const C: AnsiChar): Boolean;

function  PosChar(const F: AnsiChar; const S: AnsiString;
          const Index: Integer = 1): Integer;

function  CopyRange(const S: AnsiString;
          const StartIndex, StopIndex: Integer): AnsiString;


function StrIPos(const SubStr, S: AnsiString): Integer;
function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
function StrStripNonNumberChars(const S: AnsiString): AnsiString;
function StrDelete(const psSub, psMain: string): string;
function  StrBetweenChar(const S: AnsiString;
          const FirstDelim, SecondDelim: AnsiChar;
          const FirstOptional: Boolean = False;
          const SecondOptional: Boolean = False): AnsiString;

function GetChangedText(const Text: string; SelStart, SelLength: integer; Key: char): string;
function ChangeChar(Value: string; chOld, chNew: char): string;

function GetWinSysDir: string;
function GetCompName: String;
function GetAssociatedIcon(const Filename: string; SmallIcon: boolean): HICON;
function GetVersion(const FileName: string): string;
function GetFileSize(const FileName: string): Integer;
function GetDefaultControlHeight(Font: TFont): Integer;
function IsClassParent(AClassIn: TClass; AClassParent: TClass): Boolean;

function GetTetrad(P:PByteArray;idx:integer):byte;
procedure bmpChangeColor(BMP:TBitmap;OldColor,NewColor:TColor);

function CreateDirEx(dir: String): Boolean;
function WordReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags; WordDelim: TSetOfChar): string;
function FileTimeToDateTimeEx(AFileTime: TFileTime): TDateTime;
function DateTimeToFileDateEx(ADateTime: TDateTime): TFileTime;
function GetModuleName(Module: HMODULE): string;
procedure StrParseDelim(S, Delim: string; Strings: TStringList);

implementation

uses Controls, ActiveX,
     IpTypes, IpFunctions, idAssignedNumbers;

var
  AnsiCharTypes: array [AnsiChar] of Word;
const
  AnsiSigns          = ['-', '+'];

const
  // CharType return values
  C1_UPPER  = $0001; // Uppercase
  C1_LOWER  = $0002; // Lowercase
  C1_DIGIT  = $0004; // Decimal digits
  C1_SPACE  = $0008; // Space characters
  C1_PUNCT  = $0010; // Punctuation
  C1_CNTRL  = $0020; // Control characters
  C1_BLANK  = $0040; // Blank characters
  C1_XDIGIT = $0080; // Hexadecimal digits
  C1_ALPHA  = $0100; // Any linguistic character: alphabetic, syllabary, or ideographic


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

function DeleteDelimAndReverse(S: string): string;
begin
  Result:=Copy(s, 26, 12)+Copy(s, 21, 4)+Copy(s, 16, 4)+Copy(s, 11, 4)+Copy(s, 2, 8);
end;

function CheckUniqueIdByAdapter(const UniqueId: string): Boolean;
var
  PAdapter, PMem: PipAdapterInfo;
  OutBufLen: ULONG;
  S: string;
begin
  Result:=false;
  VVGetAdaptersInfo(PAdapter, OutBufLen);
  PMem:= PAdapter;
  try
    while Assigned(PAdapter) do begin
      S:=PAdapter.AdapterName;
      S:=DeleteDelimAndReverse(S);
      if AnsiSameText(S,UniqueId) then begin
        Result:=true;
        exit;
      end;
      PAdapter:=PAdapter.Next;
    end;
  finally
    if Assigned(PAdapter) then
      Freemem(PMem, OutBufLen);
  end;
end;

procedure FillUniqueIdsByAdapter(Strings: TStrings);
var
  PAdapter, PMem: PipAdapterInfo;
  OutBufLen: ULONG;
  S: string;
begin
  Strings.BeginUpdate;
  VVGetAdaptersInfo(PAdapter, OutBufLen);
  PMem:= PAdapter;
  try
    while Assigned(PAdapter) do begin
      S:=PAdapter.AdapterName;
      S:=DeleteDelimAndReverse(S);
      Strings.Add(S);
      PAdapter:=PAdapter.Next;
    end;
  finally
    if Assigned(PAdapter) then
      Freemem(PMem, OutBufLen);
    Strings.EndUpdate;  
  end;
end;

function CreateUniqueId: String;
var
  s: string;
begin
  s:=Copy(CreateClassID, 1, 37);
  Result:=DeleteDelimAndReverse(s);
end;

function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
begin
  if IsTrue then Result:=ValueTrue
  else Result:=ValueFalse;
end;

function CharIsNumber(const C: AnsiChar): Boolean;
begin
  Result := ((AnsiCharTypes[C] and C1_DIGIT) <> 0) or
     (C in AnsiSigns) or (C = DecimalSeparator);
end;

function CharIsDigit(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_DIGIT) <> 0;
end;

function CharIsControl(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_CNTRL) <> 0;
end;

function CharIsPrintable(const C: AnsiChar): Boolean;
begin
  Result := not CharIsControl(C);
end;

function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
begin
  Result := Copy(S, 1, Count);
end;

function GetChangedText(const Text: string; SelStart, SelLength: integer; Key: char): string;
begin
  Result := Text;
  if SelLength > 0 then
    Delete(Result, SelStart + 1, SelLength);
  if Key <> #0 then
    Insert(Key, Result, SelStart + 1);
end;

function PosChar(const F: AnsiChar; const S: AnsiString;
    const Index: Integer): Integer;
var P    : PAnsiChar;
    L, I : Integer;
begin
  L := Length(S);
  if (L = 0) or (Index > L) then
    begin
      Result := 0;
      exit;
    end;
  if Index < 1 then
    I := 1 else
    I := Index;
  P := Pointer(S);
  Inc(P, I - 1);
  While I <= L do
    if P^ = F then
      begin
        Result := I;
        exit;
      end else
      begin
        Inc(P);
        Inc(I);
      end;
  Result := 0;
end;

function CopyRange(const S: AnsiString; const StartIndex, StopIndex: Integer): AnsiString;
var L, I : Integer;
begin
  L := Length(S);
  if (StartIndex > StopIndex) or (StopIndex < 1) or (StartIndex > L) or (L = 0) then
    Result := '' else
    begin
      if StartIndex <= 1 then
        if StopIndex >= L then
          begin
            Result := S;
            exit;
          end else
          I := 1
      else
        I := StartIndex;
      Result := Copy(S, I, StopIndex - I + 1);
    end;
end;

function StrIPos(const SubStr, S: AnsiString): integer;
begin
  Result := Pos(AnsiUpperCase(SubStr), AnsiUpperCase(S));
end;

function StrStripNonNumberChars(const S: AnsiString): AnsiString;
var
  I: Integer;
  C: AnsiChar;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if CharIsNumber(C) then
      Result := Result + C;
  end;
end;

function StrRestOf(const ps: AnsiString; const n: integer): AnsiString;
begin
  Result := Copy(ps, n, (Length(ps) - n + 1));
end;

function StrDeleteChars(const ps: string; const piPos: integer; const piCount: integer): string;
begin
  Result := StrLeft(ps, piPos - 1) + StrRestOf(ps, piPos + piCount);
end;

function StrDelete(const psSub, psMain: string): string;
var
  liPos: integer;
begin
  Result := psMain;
  if psSub = '' then
    exit;

  liPos := StrIPos(psSub, psMain);

  while liPos > 0 do
    begin
      Result := StrDeleteChars(Result, liPos, Length(psSub));
      liPos := StrIPos(psSub, Result);
    end;
end;

function StrBetweenChar(const S: AnsiString;
    const FirstDelim, SecondDelim: AnsiChar;
    const FirstOptional: Boolean; const SecondOptional: Boolean): AnsiString;
var I, J: Integer;
begin
  Result := '';
  I := PosChar(FirstDelim, S);
  if (I = 0) and not FirstOptional then
    exit;
  J := PosChar(SecondDelim, S, I + 1);
  if J = 0 then
    if not SecondOptional then
      exit else
      J := Length(S) + 1;
  Result := CopyRange(S, I + 1, J - 1);
end;

function ChangeChar(Value: string; chOld, chNew: char): string;
var
  i: Integer;
  tmps: string;
begin
  for i:=1 to Length(Value) do begin
    if Value[i]=chOld then
     Value[i]:=chNew;
    tmps:=tmps+Value[i];
  end;
  Result:=tmps;
end;

function GetCompName: String;
var
  wsd: PChar;
  Dir: String;
  nSize: DWORD;
begin
  Result:='';
  nSize:=256;
  GetMem(wsd,nSize);
  try
    GetComputerName(wsd,nSize);
    Dir:=StrPas(wsd);
    result:=Dir;
  finally
    FreeMem(wsd,nSize);
  end;
end;

function GetWinSysDir: string;
var
  wsd: PChar;
  Dir: String;
const
  lDir=256;
begin
  Result:='';
  GetMem(wsd,lDir);
  try
    GetSystemDirectory(wsd,lDir);
    Dir:=StrPas(wsd);
    result:=Dir;
  finally
    FreeMem(wsd,lDir);
  end;
end;

function GetAssociatedIcon(const Filename: string; SmallIcon: boolean): HICON;
const
  cSmall: array[boolean] of Cardinal = (SHGFI_LARGEICON, SHGFI_SMALLICON);
var pfsi: TShFileInfo; hLarge: HICON; w: word;
begin
  FillChar(pfsi, sizeof(pfsi), 0);
  ShGetFileInfo(PChar(Filename), 0, pfsi, sizeof(pfsi),
    SHGFI_ICONLOCATION or SHGFI_ATTRIBUTES or SHGFI_ICON or cSmall[SmallIcon] or SHGFI_USEFILEATTRIBUTES);
  Result := pfsi.hIcon;
  if Result = 0 then
    ExtractIconEx(pfsi.szDisplayName, pfsi.iIcon, hLarge, Result, 1);
  if not SmallIcon then
    Result := hLarge;
  if Result = 0 then
    ExtractAssociatedIcon(GetFocus, PChar(Filename), w);
end;

function GetVersion(const FileName: string): string;
var
  dwHandle: DWord;
  dwLen: DWord;
  lpData: Pointer;
  v1,v2,v3,v4: Word;
  VerValue: PVSFixedFileInfo;
begin
  Result:='';
  dwLen:=GetFileVersionInfoSize(Pchar(FileName),dwHandle);
  if dwlen<>0 then begin
    GetMem(lpData, dwLen);
    try
      if GetFileVersionInfo(Pchar(FileName),dwHandle,dwLen,lpData) then begin
        VerQueryValue(lpData, '\', Pointer(VerValue), dwLen);
        V1 := VerValue.dwFileVersionMS shr 16;
        V2 := VerValue.dwFileVersionMS and $FFFF;
        V3 := VerValue.dwFileVersionLS shr 16;
        V4 := VerValue.dwFileVersionLS and $FFFF;
        Result:=inttostr(V1)+'.'+inttostr(V2)+'.'+inttostr(V3)+'.'+inttostr(V4);
      end;
    finally
      FreeMem(lpData, dwLen);
    end;
  end;
end;

function GetFileSize(const FileName: string): Integer;
var
  HFile: THandle;
begin
  HFile:=FileOpen(FileName,fmShareDenyRead);
  try
    Result:=Windows.GetFileSize(HFile,nil);
  finally
    FileClose(HFile);
  end;
end;

function GetDefaultControlHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
  Ctl3D: Boolean;
begin
  Ctl3D:=true;
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  if NewStyleControls then
  begin
    if Ctl3D then I := 8 else I := 6;
    I := GetSystemMetrics(SM_CYBORDER) * I;
  end else
  begin
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then I := Metrics.tmHeight;
    I := I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;
  Result := Metrics.tmHeight + I;
end;

function IsClassParent(AClassIn: TClass; AClassParent: TClass): Boolean;
var
  AncestorClass: TClass;
begin
  AncestorClass := AClassIn;
  while (AncestorClass <> AClassParent) do
  begin
    if AncestorClass=nil then begin Result:=false; exit; end;
    AncestorClass := AncestorClass.ClassParent;
  end;
  Result:=true;
end;

type
 PLongintArray=^TLongintArray;
 TLongintArray = array[0..(Maxint div 16) - 1] of Longint;

function GetTetrad(P:PByteArray;idx:integer):byte;
{получить тетраду из массива байтов, тетрада помещается в первые 4 бита Result,
остальные 4 бита обнуляются}
var
 n:integer;
begin
{odd - нечетное}
 n:=idx shr 1;
 if odd(idx) then begin
  Result:=P[n] and $0F;
 end else begin
  Result:=P[n] shr 4;
 end;
end;

procedure bmpChangeColor(BMP:TBitmap;OldColor,NewColor:TColor);
var
 w,iy,ix,ix3,h,w_1,h_1: Longint;
 TempBmp:TBitmap;
 ips: PlongintArray;
 wps:PWordArray;
 bps:PByteArray;
 c,cfrom,cto:longint;
 wfrom,wto:word;
 b,bfrom,bto,bnt:byte;
 svColor:Tcolor;
 nt:integer;
 isoddix:boolean;
 pint:^longint;
 r:Trect;
begin
 if bmp.empty then exit;
 w:=BMP.Width;
 h:=BMP.Height;
 w_1:=w-1;
 h_1:=h-1;
 svColor:=bmp.canvas.pixels[0,0];
 bmp.canvas.pixels[0,0]:=OldColor;
 case bmp.PixelFormat of
 pf32bit:begin
  ips:=bmp.scanline[0];
  cfrom:=ips^[0] and $00FFFFFF;
  bmp.canvas.pixels[0,0]:=NewColor;
  ips:=bmp.scanline[0];
  cto:=ips^[0] and $00FFFFFF;
  bmp.canvas.pixels[0,0]:=svColor;
  for iy:=0 to h_1 do begin
   ips:=bmp.scanline[iy];
   for ix:=0 to w_1 do begin
    if (ips^[ix] and $00FFFFFF)=cfrom then ips^[ix]:=cto;
   end;
  end;
 end;pf16bit,pf15bit:begin
  wps:=bmp.scanline[0];
  wfrom:=wps^[0];
  bmp.canvas.pixels[0,0]:=NewColor;
  wps:=bmp.scanline[0];
  wto:=wps^[0];
  bmp.canvas.pixels[0,0]:=svColor;
  for iy:=0 to h_1 do begin
   wps:=bmp.scanline[iy];
   for ix:=0 to w_1 do begin
    if wps^[ix]=wfrom then wps^[ix]:=wto;
   end;
  end;
 end;{pf8bit:begin
  bps:=bmp.scanline[0];
  bfrom:=bps^[0];
  bmp.canvas.pixels[0,0]:=NewColor;
  bps:=bmp.scanline[0];
  bto:=bps^[0];
  bmp.canvas.pixels[0,0]:=svColor;
  for iy:=0 to h_1 do begin
   bps:=bmp.scanline[iy];
   for ix:=0 to w_1 do begin
    if bps^[ix]=bfrom then bps^[ix]:=bto;
   end;
  end;
 end;}pf4bit:begin
  bps:=bmp.scanline[0];
  bfrom:=GetTetrad(bps,0);
  bmp.canvas.pixels[0,0]:=NewColor;
  bps:=bmp.scanline[0];
  bto:=GetTetrad(bps,0);
  bmp.canvas.pixels[0,0]:=svColor;
  for iy:=0 to h_1 do begin
   bps:=bmp.scanline[iy];
   for ix:=0 to w_1 do begin
//gettetrad
    nt:=ix shr 1;
    bnt:=bps[nt];
    isoddix:=odd(ix);
    if isoddix then b:=bnt and $0F
    else b:=bnt shr 4;
    if b=bfrom then begin //settetrad
     if isoddix then bps[nt]:=(bnt and $F0)or bto
     else bps[nt]:=(bnt and $0F) or (bto shl 4);
    end;
   end;
  end;
 end;pf8bit,pf24bit:begin
  bps:=bmp.scanline[0];
  move(bps^,cfrom,3);
  bmp.canvas.pixels[0,0]:=NewColor;
  bps:=bmp.scanline[0];
  move(bps^,cto,3);
  bmp.canvas.pixels[0,0]:=svColor;
  cfrom:=cfrom and $00ffffff;
  cto:=cto and $00ffffff;
  for iy:=0 to h_1 do begin
   bps:=bmp.scanline[iy];
   for ix:=0 to w_1 do begin
// load 3 bytes
    ix3:=ix*3;
    pint:=@(bps^[ix3]);
    c:=(pint^) and $00ffffff;
    if c=cfrom then begin
//move 3 bytes
//     pint:=@(bps^[ix3]);
     c:=pint^ and $FF000000;
     pint^:=c or cto;
    end;
   end;
  end;
 end else begin
//  raise exception.Create(SInvalidPixelFormat);
(*  bmp.canvas.pixels[0,0]:=svColor;
  tempbmp:=TBitmap.Create;
  tempbmp.pixelformat:=pf24bit;
  tempbmp.width:=w;
  tempbmp.height:=h;
  bitblt(tempbmp.canvas.handle,0,0,w,h,bmp.canvas.handle,0,0,SRCCOPY);
  bmpChangeColor(tempBMP,OldColor,NewColor);
  bitblt(bmp.canvas.handle,0,0,w,h,tempbmp.canvas.handle,0,0,SRCCOPY);
  tempbmp.Free;*)
  tempbmp:=TBitmap.Create;
  tempbmp.pixelformat:=bmp.pixelformat;
  tempbmp.Palette:=bmp.Palette;
  with tempbmp do begin
   Height := h;
   Width := w;
   R := Bounds(0, 0, w,h);
   Canvas.Brush.Color := NewColor;
   Canvas.BrushCopy(R, bmp, R,oldColor);
  end;
  bmp.assign(tempbmp);
  tempbmp.Free;
 end;end;
end;

function CreateDirEx(dir: String): Boolean;

  procedure GetDirs(str: TStringList);
  var
    i: Integer;
    s,tmps: string;
  begin
    tmps:='';
    for i:=1 to Length(dir) do begin
      if dir[i]='\' then begin
        s:=tmps;
        str.Add(s);
      end;
      tmps:=tmps+dir[i];
    end;
    str.Add(Dir);
  end;

var
  str: TStringList;
  i: Integer;
  isCreate: Boolean;
begin
  str:=TStringList.Create;
  try
   isCreate:=false;
   GetDirs(str);
   for i:=0 to str.Count-1 do begin
     isCreate:=createdir(str.Strings[i]);
   end;
   Result:=isCreate;
  finally
   str.Free;
  end;
end;

function WordReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags; WordDelim: TSetOfChar): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
  Ch: Char;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Ch:=Copy(SearchStr,Offset+Length(OldPattern),1)[1];
    if Ch in WordDelim then begin
      Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
      NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    end else begin
      Result := Result + Copy(NewStr, 1, Offset - 1) + OldPattern;
      NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    end;  
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function FileTimeToDateTimeEx(AFileTime: TFileTime): TDateTime;
var
  SystemTime: TSystemTime;
begin
  FileTimeToSystemTime(AFileTime,SystemTime);
  Result:=SystemTimeToDateTime(SystemTime);
end;

function DateTimeToFileDateEx(ADateTime: TDateTime): TFileTime;
var
  SystemTime: TSystemTime;
begin
  DateTimeToSystemTime(ADateTime,SystemTime);
  SystemTimeToFileTime(SystemTime,Result);
end;

procedure LoadCharTypes;
var
  CurrChar: AnsiChar;
  CurrType: Word;
begin
  for CurrChar := Low(AnsiChar) to High(AnsiChar) do
  begin
    GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @CurrChar, SizeOf(AnsiChar), CurrType);
    AnsiCharTypes[CurrChar] := CurrType;
  end;
end;

function GetModuleName(Module: HMODULE): string;
var
  ModName: array[0..MAX_PATH] of Char;
begin
  SetString(Result, ModName, GetModuleFileName(Module, ModName, SizeOf(ModName)));
end;

procedure StrParseDelim(S, Delim: string; Strings: TStringList);
var
  APos: Integer;
begin
  APos:=-1;
  while Apos<>0 do begin
    Apos:=AnsiPos(Delim,S);
    if Apos>0 then begin
      Strings.Add(Copy(S,1,Apos-1));
      S:=Copy(S,Apos+Length(Delim),Length(S));
    end else
      Strings.Add(S);
  end;
end;

initialization

  LoadCharTypes;

end.
