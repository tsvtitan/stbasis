{-------------------------------------------------------------------------------}
{ AnyDAC expression evaluation engine                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanExpr;

interface

implementation

uses
  Classes, SysUtils, Math,
{$IFDEF AnyDAC_D10}
  Windows,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants, StrUtils, DateUtils,
  {$IFDEF AnyDAC_D6}
  FMTBcd, SQLTimSt,
  {$ENDIF}
{$ELSE}
  Windows, ActiveX, ComObj,   
{$ENDIF}
  daADStanIntf, daADStanUtil, daADStanError, daADStanConst, daADStanFactory
{$IFDEF AnyDAC_REGEXP}
  , daADStanRegExpr
{$ENDIF}
  ;

type
  TADExpressionToken = (etEnd, etSymbol, etName, etLiteral,  etLParen,
    etRParen, etEQ, etNE, etGE, etLE, etGT, etLT, etCONCAT, etADD,
    etSUB, etMUL, etDIV, etComma, etLIKE, etISNULL, etISNOTNULL, etIN,
    etNOTIN, etANY, etSOME, etALL, etNOTLIKE, etBETWEEN, etNOTBETWEEN,
    etFIRST, etLAST, etNEXT, etPRIOR, etTHIS, etABS, etDAY, etMONTH,
    etQUARTER, etYEAR, etOF, etEMBEDDING, etNULL);

  TADExpressionOperator = (canNOTDEFINED, canASSIGN, canOR, canAND, canNOT,
    canEQ, canNE, canGE, canLE, canGT, canLT, canLIKE, canISBLANK, canNOTBLANK,
    canIN, canCONCAT, canADD, canSUB, canMUL, canDIV, canNOTIN, canANY,
    canALL, canNOTLIKE, canBETWEEN, canNOTBETWEEN);

  TADExpressionNodeKind = (enUnknown, enField, enConst, enOperator, enFunc);

  PDEExpressionNode = ^TADExpressionNode;
  TADExpressionNode = record
    FNext: PDEExpressionNode;
    FLeft: PDEExpressionNode;
    FRight: PDEExpressionNode;
    FDataType: TADDataType;
    FScopeKind: TADExpressionScopeKind;
    FKind: TADExpressionNodeKind;
    FOperator: TADExpressionOperator;
    FData: Variant;
    FFuncInd: Integer;
    FColumnInd: Integer;
    FArgs: TList;
    FPartial: Boolean;
  end;

  TADExpression = class(TInterfacedObject, IADStanExpressionEvaluator)
  private
    FRoot, FNodes: PDEExpressionNode;
    FSubAggregates: array of PDEExpressionNode;
    FDataSource: IADStanExpressionDataSource;
    FOptions: TADExpressionOptions;
    function NewNode(AKind: TADExpressionNodeKind; AOperator: TADExpressionOperator;
      const AData: Variant; ALeft, ARight: PDEExpressionNode;
      AFuncInd: Integer): PDEExpressionNode;
    procedure ClearNodes;
    function InternalEvaluate(ANode: PDEExpressionNode): Variant;
  protected
    // IADStanExpressionEvaluator
    function HandleNotification(AKind, AReason: Word; AParam1, AParam2: LongWord): Boolean;
    function Evaluate: Variant;
    function GetSubAggregateCount: Integer;
    function GetSubAggregateKind(AIndex: Integer): TADAggregateKind;
    function EvaluateSubAggregateArg(AIndex: Integer): Variant;
    function GetDataSource: IADStanExpressionDataSource;
    function GetDataType: TADDataType;
  public
    constructor Create(AOptions: TADExpressionOptions;
      const ADataSource: IADStanExpressionDataSource);
{$IFDEF AnyDAC_DEBUG}
    procedure Dump(AStrs: TStrings);
{$ENDIF}
    destructor Destroy; override;
  end;

  TADExprParserBmk = record
    FSourcePtr: PChar;
    FToken: TADExpressionToken;
    FTokenString: String;
  end;

  TADExpressionParser = class(TADObject, IADStanExpressionParser)
  private
    FExpression: TADExpression;
    FText: String;
    FSourcePtr: PChar;
    FTokenPtr: PChar;
    FTokenString: String;
    FUCTokenString: String;
    FToken: TADExpressionToken;
    FNumericLit: Boolean;
    FTokenNumber: Double;
    FParserOptions: TADParserOptions;
    FDataSource: IADStanExpressionDataSource;
    FInSQLLang: Boolean;
    FFixedColumnName: String;
    procedure NextToken;
    function NextTokenIsLParen : Boolean;
    function ParseExpr: PDEExpressionNode;
    function ParseExpr2: PDEExpressionNode;
    function ParseExpr3: PDEExpressionNode;
    function ParseExpr4: PDEExpressionNode;
    function ParseExprNatural(AEnableList: Boolean): PDEExpressionNode;
    function ParseExpr5(AEnableList: Boolean): PDEExpressionNode;
    function ParseExpr6: PDEExpressionNode;
    function ParseExpr7: PDEExpressionNode;
    function TokenName: string;
    function TokenSymbolIs(const S: string): Boolean;
    function TokenSymbolIsFunc(const S: string): Integer;
    procedure GetFuncResultInfo(Node: PDEExpressionNode);
    procedure TypeCheckArithOp(Node: PDEExpressionNode);
    procedure GetScopeKind(Root, Left, Right : PDEExpressionNode);
    procedure SaveState(var ABmk: TADExprParserBmk);
    procedure RestoreState(var ABmk: TADExprParserBmk);
    procedure FixupFieldNode(ANode: PDEExpressionNode; const AColumnName: String);
    procedure Optimize(ANode: PDEExpressionNode);
  protected
    // IADStanExpressionParser
    function Prepare(const ADataSource: IADStanExpressionDataSource;
      const AExpression: String; AOptions: TADExpressionOptions;
      AParserOptions: TADParserOptions; const AFixedColumnName: String): IADStanExpressionEvaluator;
    function GetDataSource: IADStanExpressionDataSource;
  end;

  PDEExpressionFunction = function (const AArgs: Variant; AExpr: TADExpression): Variant;
  TADFuncDesc = class
  private
    FScopeKind: TADExpressionScopeKind;
    FScopeKindArg: Integer;
    FDataType: TADDataType;
    FDataTypeArg: Integer;
    FArgMin: Integer;
    FArgMax: Integer;
    FCall: PDEExpressionFunction;
  end;

const
  cWordSet: set of char = ['A'..'Z', 'a'..'z'];
  HoursPerDay = 24;
  MinsPerHour = 60;
  SecsPerMin  = 60;
  MSecsPerSec = 1000;
  MinsPerDay  = HoursPerDay * MinsPerHour;
  SecsPerDay  = MinsPerDay * SecsPerMin;
  MSecsPerDay = SecsPerDay * MSecsPerSec;

var
  ADFunctions: TStringList;

{-------------------------------------------------------------------------------}
function IsNumeric(DataType: TADDataType): Boolean;
begin
  Result := DataType in [
    dtSByte, dtInt16, dtInt32, dtInt64,
    dtByte, dtUInt16, dtUInt32, dtUInt64,
    dtDouble, dtCurrency, dtBCD, dtFmtBCD];
end;

{-------------------------------------------------------------------------------}
function IsTemporal(DataType: TADDataType): Boolean;
begin
  Result := DataType in [dtDateTime, dtTime, dtDate, dtDateTimeStamp];
end;

{-------------------------------------------------------------------------------}
function IsString(DataType: TADDataType): Boolean;
begin
  Result := DataType in [dtAnsiString, dtWideString];
end;

{-------------------------------------------------------------------------------}
function IsBLOB(DataType: TADDataType): Boolean;
begin
  Result := DataType in [dtByteString, dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo];
end;

{-------------------------------------------------------------------------------}
{ TADFuncDesc                                                                   }
{-------------------------------------------------------------------------------}
function StrIsNull(const V: Variant): Boolean;
var
  tp: Integer;
  ws: WideString;
begin
  tp := (VarType(V) and varTypeMask);
  Result := (tp = varEmpty) or (tp = varNull);
  if not Result then
    if tp = varString then
      Result := V = ''
    else if tp = varOleStr then begin
      ws := V;
      Result := ws = '';
    end;
end;

{-------------------------------------------------------------------------------}
function StrToVar(const S: String): Variant;
begin
  if S = '' then
    Result := Null
  else
    Result := S;
end;

{-------------------------------------------------------------------------------}
function FunLike(const AStr, AMask: Variant; ANoCase: Boolean;
  AManyCharsMask, AOneCharMask, AEscapeChar: Char): Variant;
begin
  if VarIsNull(AStr) or VarIsNull(AMask) then
    Result := False
  else
    Result := ADStrLike(AStr, AMask, ANoCase, AManyCharsMask, AOneCharMask, AEscapeChar);
end;

{-------------------------------------------------------------------------------}
function FunUpper(const AArgs: Variant; AExpr: TADExpression): Variant;
{$IFNDEF AnyDAC_D6Base}
var
  ws: WideString;
{$ENDIF}  
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if VarType(AArgs[0]) = varOleStr then begin
{$IFDEF AnyDAC_D6Base}
      Result := WideUpperCase(AArgs[0]);
{$ELSE}
      ws := AArgs[0];
      if Length(ws) > 0 then
        CharUpperBuffW(Pointer(ws), Length(ws));
      Result := ws;
{$ENDIF}      
    end
    else
      Result := AnsiUpperCase(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunLower(const AArgs: Variant; AExpr: TADExpression): Variant;
{$IFNDEF AnyDAC_D6Base}
var
  ws: WideString;
{$ENDIF}  
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if VarType(AArgs[0]) = varOleStr then begin
{$IFDEF AnyDAC_D6Base}
      Result := WideLowerCase(AArgs[0])
{$ELSE}
      ws := AArgs[0];
      if Length(ws) > 0 then
        CharLowerBuffW(Pointer(ws), Length(ws));
      Result := ws;
{$ENDIF}
    end
    else
      Result := AnsiLowerCase(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunSubstring(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  s: String;
  ind, cnt: Integer;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    s := AArgs[0];
    ind := AArgs[1];
    if ind < 0 then
      ind := Length(s) + ind + 1;
    if VarArrayHighBound(AArgs, 1) = 1 then
      cnt := Length(s)
    else if StrIsNull(AArgs[2]) or (AArgs[2] <= 0) then begin
      Result := Null;
      Exit;
    end
    else
      cnt := AArgs[2];
    Result := StrToVar(Copy(s, ind, cnt));
  end;
end;

{-------------------------------------------------------------------------------}
type
  TADTrimMode = set of (tmLeft, tmRight);

function InternalTrim(const AArgs: Variant; AExpr: TADExpression; AMode: TADTrimMode): Variant;
var
  I, L: Integer;
  sWhere, sWhat: String;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    sWhere := AArgs[0];
    if VarArrayHighBound(AArgs, 1) = 1 then begin
      if StrIsNull(AArgs[1]) then begin
        Result := Null;
        Exit;
      end
      else
        sWhat := AArgs[1];
    end
    else
      sWhat := ' ';
    L := Length(sWhere);
    I := 1;
    if tmLeft in AMode then
      while (I <= L) and (StrScan(PChar(sWhat), sWhere[I]) <> nil) do
        Inc(I);
    if I > L then
      sWhere := ''
    else begin
      if tmRight in AMode then
        while (L >= I) and (StrScan(PChar(sWhat), sWhere[L]) <> nil) do
          Dec(L);
      sWhere := Copy(sWhere, I, L - I + 1);
    end;
    Result := StrToVar(sWhere);
  end;
end;

{-------------------------------------------------------------------------------}
function FunTrim(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := InternalTrim(AArgs, AExpr, [tmLeft, tmRight]);
end;

{-------------------------------------------------------------------------------}
function FunTrimLeft(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := InternalTrim(AArgs, AExpr, [tmLeft]);
end;

{-------------------------------------------------------------------------------}
function FunTrimRight(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := InternalTrim(AArgs, AExpr, [tmRight]);
end;

{-------------------------------------------------------------------------------}
function FunYear(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[0], Y, M, D);
    Result := Y;
  end;
end;

{-------------------------------------------------------------------------------}
function FunMonth(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[0], Y, M, D);
    Result := M;
  end;
end;

{-------------------------------------------------------------------------------}
function FunDay(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[0], Y, M, D);
    Result := D;
  end;
end;

{-------------------------------------------------------------------------------}
function FunHour(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  H, M, S, MS: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    H := 0;
    M := 0;
    S := 0;
    MS := 0;
    DecodeTime(AArgs[0], H, M, S, MS);
    Result := H;
  end;
end;

{-------------------------------------------------------------------------------}
function FunMinute(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  H, M, S, MS: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    H := 0;
    M := 0;
    S := 0;
    MS := 0;
    DecodeTime(AArgs[0], H, M, S, MS);
    Result := M;
  end;
end;

{-------------------------------------------------------------------------------}
function FunSecond(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  H, M, S, MS: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    H := 0;
    M := 0;
    S := 0;
    MS := 0;
    DecodeTime(AArgs[0], H, M, S, MS);
    Result := S;
  end;
end;

{-------------------------------------------------------------------------------}
function FunGetDate(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := Now;
end;

{-------------------------------------------------------------------------------}
function FunDate(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Integer(Trunc(AArgs[0]));
end;

{-------------------------------------------------------------------------------}
function FunTime(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  dt: TDateTime;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    dt := AArgs[0];
    Result := dt - Trunc(dt);
  end;
end;

{-------------------------------------------------------------------------------}
function FunAbs(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  d: Double;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    d := AArgs[0];
    Result := Abs(d);
  end;
end;

{-------------------------------------------------------------------------------}
function FunCeil(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Ceil(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunCos(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Cos(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunCosh(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Cosh(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunExp(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Exp(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunFloor(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Floor(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunLn(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Ln(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunLog(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    Result := LogN(AArgs[0], AArgs[1]);
end;

{-------------------------------------------------------------------------------}
function FunMod(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else if AArgs[1] = 0 then
    Result := AArgs[0]
  else
    Result := AArgs[0] mod AArgs[1];
end;

{-------------------------------------------------------------------------------}
function FunPower(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    Result := Power(AArgs[0], AArgs[1]);
end;

{-------------------------------------------------------------------------------}
function FunRound(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
{ TODO -cEXP :
  Support for
  1) for number
  2) for date
  3) Arg#2 - format mask
}
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Round(AArgs[0]) + 0.0;
end;

{-------------------------------------------------------------------------------}
function FunSign(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else if AArgs[0] > 0.0 then
    Result := 1
  else if AArgs[0] < 0.0 then
    Result := -1
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function FunSin(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := sin(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunSinh(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := sinh(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunSqrt(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := sqrt(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunTan(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := tan(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunTanh(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := tanh(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunTrunc(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
{ TODO -cEXP :
  Support for
  1) for number
  2) for date
  3) Arg#2 - format mask
}
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Trunc(AArgs[0]) + 0.0;
end;

{-------------------------------------------------------------------------------}
function FunChr(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  s: String;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    s := Chr(Integer(AArgs[0]));
    Result := s;
  end;
end;

{-------------------------------------------------------------------------------}
function FunConcat(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := AArgs[1]
  else if StrIsNull(AArgs[1]) then
    Result := AArgs[0]
  else
    Result := Concat(VarToStr(AArgs[0]), VarToStr(AArgs[1]));
end;

{-------------------------------------------------------------------------------}
function FunInitCap(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  i: Integer;
  s: String;
  lInit: Boolean;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    s := AArgs[0];
    lInit := False;
    for i := 1 to Length(s) do
      if (s[i] in cWordSet) and not lInit then begin
        s[i] := ADCharUpperCase(s[i]);
        lInit := True;
      end
      else
        if (s[i] in cWordSet) then
          s[i] := ADCharLowerCase(s[i]);
    Result := s;
  end;
end;

{-------------------------------------------------------------------------------}
function InternalPad(const AArgs: Variant; AExpr: TADExpression; AFront: Boolean): Variant;
var
  n: Integer;
  s, ps: String;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) or
    (VarArrayHighBound(AArgs, 1) = 2) and StrIsNull(AArgs[2]) then
    Result := Null
  else begin
    s := AArgs[0];
    n := AArgs[1] - Length(s);
    if (VarArrayHighBound(AArgs, 1) = 1) then
      ps := ' '
    else
      ps := AArgs[2];
    while Length(ps) < n do
      ps := ps + ps;
    if Length(ps) > n then
      ps := Copy(ps, 1, n);
    if AFront then
      Result := StrToVar(ps + s)
    else
      Result := StrToVar(s + ps);
  end;
end;

{-------------------------------------------------------------------------------}
function FunLPad(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := InternalPad(AArgs, AExpr, True);
end;

{-------------------------------------------------------------------------------}
function FunRPad(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := InternalPad(AArgs, AExpr, False);
end;

{-------------------------------------------------------------------------------}
function FunReplace(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sWhere, sFrom, sTo: String;
  i: Integer;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else if StrIsNull(AArgs[1]) then
    Result := AArgs[0]
  else begin
    sWhere := AArgs[0];
    sFrom := AArgs[1];
    if VarArrayHighBound(AArgs, 1) = 2 then
      sTo := AArgs[2]
    else
      sTo := '';
    while True do begin
      i := Pos(sFrom, sWhere);
      if i = 0 then
        Break;
      Delete(sWhere, i, Length(sFrom));
      if sTo <> '' then
        Insert(sTo, sWhere, i);
    end;
    Result := StrToVar(sWhere);
  end;
end;

{$IFDEF AnyDAC_D6Base}
{-------------------------------------------------------------------------------}
function FunSoundex(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sWhat: String;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    sWhat := AArgs[0];
    sWhat := Trim(sWhat);
    if sWhat = '' then
      Result := Null
    else
      Result := Soundex(sWhat, 4);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function FunTranslate(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sWhere, sFrom, sTo: String;
  i, j: Integer;
  pCh: PChar;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) or StrIsNull(AArgs[2]) then
    Result := Null
  else begin
    sWhere := AArgs[0];
    sFrom := AArgs[1];
    sTo := AArgs[2];
    for i := 1 to Length(sFrom) do begin
      pCh := StrScan(PChar(sWhere), sFrom[i]);
      if pCh <> nil then begin
        j := pCh - PChar(sWhere) + 1;
        if i > Length(sTo) then
          Delete(sWhere, j, 1)
        else
          sWhere[j] := sTo[i];
      end;
    end;
    Result := StrToVar(sWhere);
  end;
end;

{-------------------------------------------------------------------------------}
function FunAscii(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  s: String;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    s := AArgs[0];
    Result := Ord(s[1]);
  end;
end;

{-------------------------------------------------------------------------------}
function FunInstr(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sWhere, sWhat: String;
  iCount, iFrom, hBnd: Integer;
  pStart, pCh: PChar;
  v: Variant;
  bReverse: Boolean;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    sWhere := AArgs[0];
    sWhat := AArgs[1];
    hBnd := VarArrayHighBound(AArgs, 1);
    iCount := 1;
    iFrom := 1;
    bReverse := False;
    if hBnd >= 2 then begin
      v := AArgs[2];
      if StrIsNull(v) then begin
        Result := Null;
        Exit;
      end;
      iFrom := v;
      bReverse := iFrom < 0;
      if bReverse then
        iFrom := Length(sWhere) + iFrom + 1;
      if hBnd >= 3 then begin
        v := AArgs[3];
        if StrIsNull(v) or (v <= 0) then begin
          Result := Null;
          Exit;
        end;
        iCount := v;
      end;
    end;
    pStart := PChar(sWhere) + iFrom - 1;
    pCh := nil;
    while iCount > 0 do begin
      if bReverse then begin
        pCh := ADStrRPos(pStart, PChar(sWhat));
        if pCh = nil then
          Break;
        pStart := pCh - Length(sWhat);
      end
      else begin
        pCh := StrPos(pStart, PChar(sWhat));
        if pCh = nil then
          Break;
        pStart := pCh + Length(sWhat);
      end;
      Dec(iCount);
    end;
    if pCh = nil then
      Result := 0
    else
      Result := pCh - PChar(sWhere) + 1;
  end;
end;

{-------------------------------------------------------------------------------}
function FunLength(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Length(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunAddMonths(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    Result := IncMonth(AArgs[0], AArgs[1]);
end;

{-------------------------------------------------------------------------------}
function FunLastDay(const AArgs: Variant; AExpr: TADExpression): Variant;
{$IFNDEF AnyDAC_D6Base}
const
  DaysPerMonth: array[1..12] of Integer =
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
{$ENDIF}
var
  AYear, AMonth, ADay: Word;
  dt: TDateTime;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    dt := AArgs[0];
    AYear := 0;
    AMonth := 0;
    ADay := 0;
    DecodeDate(dt, AYear, AMonth, ADay);
{$IFDEF AnyDAC_D6Base}
    ADay := DaysInAMonth(AYear, AMonth);
{$ELSE}
    ADay := DaysPerMonth[AMonth];
    if (AMonth = 2) and
       (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0)) then
      Inc(ADay);
{$ENDIF}
    Result := EncodeDate(AYear, AMonth, ADay) + (dt - Trunc(dt));
    TVarData(Result).VType := varDate;
  end;
end;

{-------------------------------------------------------------------------------}
function FunFirstDay(const AArgs: Variant; AExpr: TADExpression): Variant;
{$IFNDEF AnyDAC_D6Base}
var
  AYear, AMonth, ADay: Word;
  dt: TDateTime;
{$ENDIF}
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
{$IFDEF AnyDAC_D6Base}
    Result := StartOfTheMonth(AArgs[0]);
{$ELSE}
    dt := AArgs[0];
    DecodeDate(AArgs[0], AYear, AMonth, ADay);
    Result := EncodeDate(AYear, AMonth, 1) + (dt - Int(dt));
    TVarData(Result).VType := varDate;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function FunMonthsBW(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  AYear1, AMonth1, ADay1: Word;
  AYear2, AMonth2, ADay2: Word;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    AYear1 := 0;
    AMonth1 := 0;
    ADay1 := 0;
    DecodeDate(AArgs[0], AYear1, AMonth1, ADay1);
    AYear2 := 0;
    AMonth2 := 0;
    ADay2 := 0;
    DecodeDate(AArgs[1], AYear2, AMonth2, ADay2);
    Result := (Integer(AYear1 * 12 * 31 + AMonth1 * 31 + ADay1) -
               Integer(AYear2 * 12 * 31 + AMonth2 * 31 + ADay2)) / 31;
  end;
end;

{-------------------------------------------------------------------------------}
function FunNextDay(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  dt: TDateTime;
  nd, d: String;
  i: Integer;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    dt := AArgs[0];
    nd := AArgs[1];
    for i := 1 to 7 do begin
      dt := dt + 1;
      d := '';
      DateTimeToString(d, 'dddd', dt);
      if AnsiCompareText(d, nd) = 0 then begin
        Result := dt;
        Exit;
      end;
    end;
    Result := Null;
    { TODO -cEXP :
      ORA-01846: not valid day of week
    }
  end;
end;

{-------------------------------------------------------------------------------}
function FunToChar(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  N, i: Integer;
  E: Extended;
  V: Variant;
{$IFDEF AnyDAC_D7}
  rFS: TFormatSettings;
{$ELSE}
  sPrevDateFmt: String;
  cPrevDateSep: Char;
{$ENDIF}
  sFormatDate: String;
begin
{ TODO -cEXP :
  support of Oracle's mask
}
  N := VarArrayHighBound(AArgs, 1);
  if StrIsNull(AArgs[0]) or
    (N > 0) and StrIsNull(AArgs[1]) or
    (N > 1) and StrIsNull(AArgs[2]) then
    Result := Null
  else begin
    V := AArgs[0];
    if N > 0 then
      if (VarType(V) and varTypeMask) = varDate then begin
{$IFDEF AnyDAC_D7}
        rFS.ShortDateFormat := AArgs[1];
        sFormatDate := AArgs[1];
        for i := 1 to Length(sFormatDate) do
          if sFormatDate[i] in [' ', '-', '\', '.', '/'] then begin
            rFS.DateSeparator := sFormatDate[i];
            Break;
          end;
        Result := FormatDateTime(sFormatDate, V, rFS);
{$ELSE}
        sPrevDateFmt := ShortDateFormat;
        cPrevDateSep := DateSeparator;
        try
          ShortDateFormat := AArgs[1];
          sFormatDate := AArgs[1];
          for i := 1 to Length(sFormatDate) do
            if sFormatDate[i] in [' ', '-', '\', '.', '/'] then begin
              DateSeparator := sFormatDate[i];
              Break;
            end;
          Result := FormatDateTime(sFormatDate, V);
        finally
          ShortDateFormat := sPrevDateFmt;
          DateSeparator := cPrevDateSep;
        end;
{$ENDIF}
      end
{$IFDEF AnyDAC_D6Base}
      else if VarIsNumeric(V) then begin
{$ELSE}
      else if VarType(V) in [varSmallInt, varInteger, varBoolean, vt_i1,
                             varByte, vt_ui2, vt_ui4, varInt64,
                             varSingle, varDouble, varCurrency] then begin
{$ENDIF}
        E := V;
        Result := FormatFloat(AArgs[1], E);
      end
{$IFDEF AnyDAC_D6}
      else if VarIsFMTBcd(V) then
        Result := FormatBcd(AArgs[1], VarToBcd(V))
      else if VarIsSQLTimeStamp(V) then
        Result := SQLTimeStampToStr(AArgs[1], VarToSQLTimeStamp(V))
{$ENDIF}
      else
        Result := VarAsType(V, varString)
    else
      Result := VarAsType(V, varString);
  end;
end;

{-------------------------------------------------------------------------------}
function FunToDate(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  N, i: Integer;
  sDate: String;
{$IFDEF AnyDAC_D7}
  rFS: TFormatSettings;
{$ELSE}
  sPrevDateFmt: String;
  cPrevDateSep: Char;
{$ENDIF}
begin
{ TODO -cEXP :
  support of Oracle's mask
}
  N := VarArrayHighBound(AArgs, 1);
  if StrIsNull(AArgs[0]) or
    (N > 0) and StrIsNull(AArgs[1]) or
    (N > 1) and StrIsNull(AArgs[2]) then
    Result := Null
  else begin
    sDate := AArgs[0];
{$IFDEF AnyDAC_D7}
    if N > 0 then
      rFS.ShortDateFormat := AArgs[1]
    else
      rFS.ShortDateFormat := ShortDateFormat;
    for i := 1 to Length(sDate) do
      if sDate[i] in [' ', '-', '\', '.', '/'] then begin
        rFS.DateSeparator := sDate[i];
        Break;
      end;
    Result := StrToDate(sDate, rFS);
{$ELSE}
    sPrevDateFmt := ShortDateFormat;
    cPrevDateSep := DateSeparator;
    try
      if N > 0 then
        ShortDateFormat := AArgs[1]
      else
        ShortDateFormat := ShortDateFormat;
      for i := 1 to Length(sDate) do
        if sDate[i] in [' ', '-', '\', '.', '/'] then begin
          DateSeparator := sDate[i];
          Break;
        end;
      Result := StrToDate(sDate);
    finally
      ShortDateFormat := sPrevDateFmt;
      DateSeparator := cPrevDateSep;
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function VarRemOleStr(const AValue: Variant): Variant;
begin
  if VarType(AValue) = varOleStr then
    Result := VarAsType(AValue, varString)
  else
    Result := AValue;
end;

{-------------------------------------------------------------------------------}
function FunToNumber(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  N: Integer;
begin
{ TODO -cEXP :
  support of Oracle's mask
}
  N := VarArrayHighBound(AArgs, 1);
  if StrIsNull(AArgs[0]) or
    (N > 0) and StrIsNull(AArgs[1]) or
    (N > 1) and StrIsNull(AArgs[2]) then
    Result := Null
  else
    Result := VarAsType(VarRemOleStr(AArgs[0]), varDouble);
end;

{-------------------------------------------------------------------------------}
function FunDecode(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  n, i: Integer;
begin
  n := VarArrayHighBound(AArgs, 1);
  i := 1;
  Result := AArgs[0];
  while i <= n - 1 do begin
    if Result = AArgs[i] then begin
      Result := AArgs[i + 1];
      Break;
    end;
    Inc(i, 2);
  end;
  if i = n then
    Result := AArgs[i];
end;

{-------------------------------------------------------------------------------}
function FunIIF(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  // it is handled internally by evaluator
  Result := Unassigned;
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
function FunNvl(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := AArgs[0];
  if StrIsNull(Result) then
    Result := AArgs[1];
end;

{-------------------------------------------------------------------------------}
function FunGreatest(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  n, i: Integer;
begin
  n := VarArrayHighBound(AArgs, 1);
  Result := AArgs[0];
  for i := 0 to n do begin
    if StrIsNull(AArgs[i]) then begin
      Result := Null;
      Break;
    end;
    if Result < AArgs[i] then
      Result := AArgs[i];
  end;
end;

{-------------------------------------------------------------------------------}
function FunLeast(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  n, i: Integer;
begin
  n := VarArrayHighBound(AArgs, 1);
  Result := AArgs[0];
  for i := 0 to n do begin
    if StrIsNull(AArgs[i]) then begin
      Result := Null;
      Break;
    end;
    if Result > AArgs[i] then
      Result := AArgs[i];
  end;
end;

{-------------------------------------------------------------------------------}
function FunAggSum(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akSum;
end;

{-------------------------------------------------------------------------------}
function FunAggAvg(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akAvg;
end;

{-------------------------------------------------------------------------------}
function FunAggCount(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akCount;
end;

{-------------------------------------------------------------------------------}
function FunAggMin(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akMin;
end;

{-------------------------------------------------------------------------------}
function FunAggMax(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akMax;
end;

{-------------------------------------------------------------------------------}
function FunAggFirst(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akFirst;
end;

{-------------------------------------------------------------------------------}
function FunAggLast(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := akLast;
end;

{-------------------------------------------------------------------------------}
function FunRowNum(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := AExpr.FDataSource.RowNum;
end;

{$IFDEF AnyDAC_REGEXP}
{-------------------------------------------------------------------------------}
function FunRegExpLike(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    Result := ExecRegExpr(AArgs[1], AArgs[0]);
end;
{$ENDIF}

{$IFDEF AnyDAC_D6Base}
{-------------------------------------------------------------------------------}
function FunDiff(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  vSound1, vSound2: Variant;
  aV: TADVariantArray;
  function SoundexInteger(const AText: string; ALength: TSoundexIntLength = 4): Integer;
  var
    LResult: string;
    I: Integer;
  begin
    LResult := AText;
    Result := Ord(LResult[1]) - Ord('A');
    if ALength > 1 then
    begin
      Result := Result * 26 + StrToInt(LResult[2]);
      for I := 3 to ALength do
        Result := Result * 7 + StrToInt(LResult[I]);
    end;
    Result := Result * 9 + ALength;
  end;

begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    SetLength(aV, 1);
    aV[0] := AArgs[0];
    vSound1 := FunSoundex(aV, AExpr);
    aV[0] := AArgs[1];
    vSound2 := FunSoundex(aV, AExpr);
    Result := SoundexInteger(VarToStr(vSound1)) - SoundexInteger(VarToStr(vSound2));
  end
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function FunInsert(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  i, iIndex, iCount: Integer;
  sWhat, sTo: String;
begin
  for i := 0 to 2 do
    if StrIsNull(AArgs[i]) then begin
        Result := Null;
        exit;
    end;
  sTo := AArgs[0];
  sWhat := AArgs[3];
  iIndex := VarAsType(AArgs[1], varInteger);
  iCount := VarAsType(AArgs[2], varInteger);
  Delete(sTo, iIndex, iCount);
  if not StrIsNull(AArgs[3]) then
    Insert(sWhat, sTo, iIndex);
  Result := sTo;
end;

{-------------------------------------------------------------------------------}
function FunLeft(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  iIndex: Integer;
begin
  if StrIsNull(AArgs[0]) then begin
    Result := Null;
    exit;
  end
  else
    if StrIsNull(AArgs[1]) then
      Result := AArgs[0]
    else begin
      iIndex := VarAsType(AArgs[1], varInteger);
      Result := Copy(VarToStr(AArgs[0]), 1, iIndex);
    end
end;

{-------------------------------------------------------------------------------}
function FunRight(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  iIndex: Integer;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if StrIsNull(AArgs[1]) then
      Result := AArgs[0]
    else begin
      iIndex := VarAsType(AArgs[1], varInteger);
      Result := Copy(VarToStr(AArgs[0]), Length(AArgs[0]) - iIndex + 1, iIndex);
    end
end;

{-------------------------------------------------------------------------------}
function FunOCTLen(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Length(AArgs[0]);
    if VarType(AArgs[0]) = varOleStr then
      Result := Result * 2;
end;

{-------------------------------------------------------------------------------}
function FunPos(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    Result := Pos(VarToStr(AArgs[0]), VarToStr(AArgs[1]));
end;

{-------------------------------------------------------------------------------}
function FunLocate(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    if (VarArrayHighBound(AArgs, 1) > 1) and not StrIsNull(AArgs[2]) then
      Result := ADPosEx(VarToStr(AArgs[0]), VarToStr(AArgs[1]), AArgs[2])
    else
      Result := Pos(VarToStr(AArgs[0]), VarToStr(AArgs[1]));
end;

{-------------------------------------------------------------------------------}
function FunRepeat(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  i: Integer;
begin
  Result := '';
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if StrIsNull(AArgs[1]) then
      Result := AArgs[0]
    else
      for i := 0 to AArgs[1] - 1 do
        Result := Result + AArgs[0];
end;

{-------------------------------------------------------------------------------}
function FunSpace(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  i: Integer;
begin
  Result := '';
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    for i := 0 to AArgs[0] - 1 do
      Result := Result + ' ';
end;

{-------------------------------------------------------------------------------}
function FunACos(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if (AArgs[0] < -1) or (AArgs[0] > 1) then
      Result := Null
    else
      Result := ArcCos(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunASin(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if (AArgs[0] < -1) or (AArgs[0] > 1) then
      Result := Null
    else
      Result := ArcSin(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunATan(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := ArcTan(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunATan2(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else
    if AArgs[0] <> 0 then
      Result := ArcTan(AArgs[1]/AArgs[0])
    else
      Result := Null;
end;

{-------------------------------------------------------------------------------}
function FunCot(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    if Tan(AArgs[0]) <> 0 then
      Result := 1 / Tan(AArgs[0])
    else
      Result := Null;
end;

{-------------------------------------------------------------------------------}
function FunDegrees(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := 180 / C_AD_Pi * AArgs[0];
end;

{-------------------------------------------------------------------------------}
function FunLog10(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := Log10(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunPi(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := C_AD_Pi;
end;

{-------------------------------------------------------------------------------}
function FunRadians(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := C_AD_Pi / 180 * AArgs[0];
end;

{-------------------------------------------------------------------------------}
function FunRand(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  iRange, iLen, i: Integer;
  sRange, sVal: String;
begin
  if not VarIsArray(AArgs) then
    Result := Random
  else begin
    if (VarType(AArgs[0]) = varString) or
       (VarType(AArgs[0]) = varOleStr) then begin
      sRange := AArgs[0];
      if VarArrayHighBound(AArgs, 1) >= 1 then
        iLen := AArgs[1]
      else
        iLen := 1;
      SetLength(sVal, iLen);
      for i := 1 to iLen do
        sVal[i] := sRange[1 + Random(Length(sRange))];
    end
    else begin
      iRange := VarAsType(AArgs[0], varInteger);
      Result := Random(iRange);
    end;
  end
end;

{-------------------------------------------------------------------------------}
function FunGetTime(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := Now - Trunc(Now);
end;

{-------------------------------------------------------------------------------}
function FunGetCurDate(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  Result := Trunc(Now) + 0.0;
end;

{-------------------------------------------------------------------------------}
function FunDayName(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  s: String;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    s := '';
    DateTimeToString(s, 'dddd', TDateTime(VarAsType(AArgs[0], varDouble)));
    Result := s;
  end
end;

{-------------------------------------------------------------------------------}
function FunDayOfWeek(const AArgs: Variant; AExpr: TADExpression): Variant;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else
    Result := DayOfWeek(AArgs[0]);
end;

{-------------------------------------------------------------------------------}
function FunDayOfYear(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[0], Y, M, D);
    Result := Integer(Trunc(AArgs[0] - EncodeDate(Y, 1, 1)) + 1);
  end
end;

{-------------------------------------------------------------------------------}
function FunExtract(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D: Word;
  H, MM, S, MS: Word;
  sWhat: String;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    sWhat := Trim(AnsiUpperCase(AArgs[0]));
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[1], Y, M, D);
    H := 0;
    MM := 0;
    S := 0;
    MS := 0;
    DecodeTime(AArgs[1], H, MM, S, MS);
    if sWhat = 'YEAR' then
      Result :=  Y;
    if sWhat = 'MONTH' then
      Result :=  M;
    if sWhat = 'DAY' then
      Result :=  D;
    if sWhat = 'HOUR' then
      Result :=  H;
    if sWhat = 'MINUTE' then
      Result :=  MM;
    if sWhat = 'SECOND' then
      Result :=  S;
  end
end;

{-------------------------------------------------------------------------------}
function FunMonthName(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  s: String;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    s := '';
    DateTimeToString(s, 'mmmm', TDateTime(VarAsType(AArgs[0], varDouble)));
    Result := s;
  end
end;

{-------------------------------------------------------------------------------}
function FunQuarter(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[0], Y, M, D);
    if M < 4 then
      Result := 1
    else if (M >= 4) and (M < 7) then
      Result := 2
    else if (M >= 6) and (M < 10) then
      Result := 3
    else
      Result := 4;
  end
end;

{-------------------------------------------------------------------------------}
function FunTimeStampAdd(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sWhat: String;
  iInterval: Integer;
begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) or StrIsNull(AArgs[2]) then
    Result := Null
  else begin
    sWhat := Trim(AnsiUpperCase(AArgs[0]));
    iInterval := AArgs[1];
    if sWhat = 'FRAC_SECOND' then
      Result := ((AArgs[2] * MSecsPerDay) + iInterval div 1000) / MSecsPerDay;
    if sWhat = 'SECOND' then
      Result := ((AArgs[2] * SecsPerDay) + iInterval) / SecsPerDay;
    if sWhat = 'MINUTE' then
      Result := ((AArgs[2] * MinsPerDay) + iInterval) / MinsPerDay;
    if sWhat = 'HOUR' then
      Result := ((AArgs[2] * HoursPerDay) + iInterval) / HoursPerDay;
    if sWhat = 'DAY' then
      Result := AArgs[2] + iInterval;
    if sWhat = 'WEEK' then
      Result := AArgs[2] + iInterval * 7;
    if sWhat = 'MONTH' then
      Result := IncMonth(AArgs[2], iInterval);
    if sWhat = 'QUARTER' then
      Result := IncMonth(AArgs[2], iInterval * 3);
    if sWhat = 'YEAR' then
      Result := IncMonth(AArgs[2], iInterval * 12);
  end
end;

{-------------------------------------------------------------------------------}
function FunTimeStampDiff(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sWhat: String;
  d: TDateTime;
  r: Double;

  function Span(A1, A2: TDateTime): TDateTime;
  begin
    if A1 > A2 then
        Result := A1 - A2
      else
        Result := A2 - A1;
  end;

begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) or StrIsNull(AArgs[2]) then
    Result := Null
  else begin
    sWhat := Trim(AnsiUpperCase(AArgs[0]));
    if sWhat = 'FRAC_SECOND' then begin
      d := MSecsPerDay * Span(AArgs[1], AArgs[2]);
      Result := Integer(Trunc(d) * 1000);
    end;
    if sWhat = 'SECOND' then begin
      d := SecsPerDay * Span(AArgs[1], AArgs[2]);
      Result := Integer(Trunc(d));
    end;
    if sWhat = 'MINUTE' then begin
      d := MinsPerDay * Span(AArgs[1], AArgs[2]);
      Result := Integer(Trunc(d));
    end;
    if sWhat = 'HOUR' then begin
      d := HoursPerDay * Span(AArgs[1], AArgs[2]);
      Result := Integer(Trunc(d));
    end;
    if sWhat = 'DAY' then
      Result := Integer(Trunc(Span(AArgs[1], AArgs[2])));
    if sWhat = 'WEEK' then
      Result := Integer(Trunc(Span(AArgs[1], AArgs[2]) / 7));
    if sWhat = 'MONTH' then
      Result := Integer(Trunc(Span(AArgs[1], AArgs[2]) / 30.4375));
    if sWhat = 'QUARTER' then
      Result := Integer(Trunc(Trunc(Span(AArgs[1], AArgs[2]) / 30.4375) / 3));
    if sWhat = 'YEAR' then begin
      Result := Integer(Trunc(Span(AArgs[1], AArgs[2]) / 365.25));
      r := VarAsType(Span(AArgs[1], AArgs[2]), varDouble);
      if (r / 365 = Trunc(r / 365)) and (r / 365 > 0) then
        Result := r / 365;
    end;
  end
end;

{-------------------------------------------------------------------------------}
function FunWeek(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  Y, M, D, W: Word;
begin
  if StrIsNull(AArgs[0]) then
    Result := Null
  else begin
    Y := 0;
    M := 0;
    D := 0;
    DecodeDate(AArgs[0], Y, M, D);
    D := Word(Trunc(AArgs[0] - EncodeDate(Y, 1, 1)) + 1);
    W := Word(D div 7);
    if D mod 7 <> 0 then
      Inc(W);
    Result := W;
  end
end;

{-------------------------------------------------------------------------------}
function FunConvert(const AArgs: Variant; AExpr: TADExpression): Variant;
var
  sType: String;
  V: Variant;
  Y, M, D, H, MM, S, MS: Word;

  procedure Unsupported;
  begin
    ADException(nil, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTypeMis, []);
  end;

begin
  if StrIsNull(AArgs[0]) or StrIsNull(AArgs[1]) then
    Result := Null
  else begin
    sType := Trim(AnsiUpperCase(AArgs[0]));
    V := AArgs[1];
    Y := 0;
    M := 0;
    D := 0;
    H := 0;
    MM := 0;
    S := 0;
    MS := 0;
    if sType = 'BIGINT' then
{$IFDEF AnyDAC_D6Base}
      Result := VarAsType(V, varInt64)
{$ELSE}
      Result := VarAsType(V, vt_i8)
{$ENDIF}
    else if sType = 'BINARY' then
      Unsupported
    else if sType = 'BIT' then
      Result := VarAsType(V, varBoolean)
    else if sType = 'CHAR' then
      Result := VarAsType(V, varString)
    else if sType = 'DECIMAL' then
{$IFDEF AnyDAC_D6}
      Result := VarAsType(V, VarFMTBcd)
{$ELSE}
      Result := VarAsType(V, varCurrency)
{$ENDIF}
    else if sType = 'DOUBLE' then
      Result := VarAsType(VarRemOleStr(V), varDouble)
    else if sType = 'FLOAT' then
      Result := VarAsType(VarRemOleStr(V), varDouble)
    else if sType = 'GUID' then
      Result := GUIDToString(StringToGUID(V))
    else if sType = 'INTEGER' then
      Result := VarAsType(V, varInteger)
    else if sType = 'INTERVAL_MONTH' then begin
      DecodeDate(V, Y, M, D);
      Result := M;
    end
    else if sType = 'INTERVAL_YEAR' then begin
      DecodeDate(V, Y, M, D);
      Result := Y;
    end
    else if sType = 'INTERVAL_YEAR_TO_MONTH' then
      Unsupported
    else if sType = 'INTERVAL_DAY' then begin
      DecodeDate(V, Y, M, D);
      Result := D;
    end
    else if sType = 'INTERVAL_HOUR' then begin
      DecodeTime(V, H, MM, S, MS);
      Result := H;
    end
    else if sType = 'INTERVAL_MINUTE' then begin
      DecodeTime(V, H, MM, S, MS);
      Result := MM;
    end
    else if sType = 'INTERVAL_SECOND' then begin
      DecodeTime(V, H, MM, S, MS);
      Result := S;
    end
    else if sType = 'INTERVAL_DAY_TO_HOUR' then
      Unsupported
    else if sType = 'INTERVAL_DAY_TO_MINUTE' then
      Unsupported
    else if sType = 'INTERVAL_DAY_TO_SECOND' then
      Unsupported
    else if sType = 'INTERVAL_HOUR_TO_MINUTE' then
      Unsupported
    else if sType = 'INTERVAL_HOUR_TO_SECOND' then
      Unsupported
    else if sType = 'INTERVAL_MINUTE_TO_SECOND' then
      Unsupported
    else if sType = 'LONGVARBINARY' then
      Result := VarAsType(V, varString)
    else if sType = 'LONGVARCHAR' then
      Result := VarAsType(V, varString)
    else if sType = 'NUMERIC' then
{$IFDEF AnyDAC_D6}
      Result := VarAsType(V, VarFMTBcd)
{$ELSE}
      Result := VarAsType(V, varCurrency)
{$ENDIF}
    else if sType = 'REAL' then
      Result := VarAsType(VarRemOleStr(V), varSingle)
    else if sType = 'SMALLINT' then
      Result := VarAsType(V, varSmallint)
    else if sType = 'DATE' then
      Result := Trunc(VarAsType(V, varDate)) + 0.0
    else if sType = 'TIME' then
      Result := VarAsType(V, varDate) - (Trunc(VarAsType(V, varDate)) + 0.0)
    else if sType = 'TIMESTAMP' then
{$IFDEF AnyDAC_D6}
      Result := VarAsType(V, VarSQLTimeStamp)
{$ELSE}
      Result := VarAsType(V, varDate)
{$ENDIF}
    else if sType = 'TINYINT' then
{$IFDEF AnyDAC_D6Base}
      Result := VarAsType(V, varShortInt)
{$ELSE}
      Result := VarAsType(V, vt_i1)
{$ENDIF}
    else if sType = 'VARBINARY' then
      Result := VarAsType(V, varString)
    else if sType = 'VARCHAR' then
      Result := VarAsType(V, varString)
    else if sType = 'WCHAR' then
      Result := VarAsType(V, varOleStr)
    else if sType = 'WLONGVARCHAR' then
      Result := VarAsType(V, varOleStr)
    else if sType = 'WVARCHAR' then
      Result := VarAsType(V, varOleStr)
    else
      Unsupported;
  end
end;

{-------------------------------------------------------------------------------}
procedure ADExpressionRegisterFunc(const AName: String; AScopeKind: TADExpressionScopeKind;
  AScopeKindArg: Integer; ADataType: TADDataType; ADataTypeArg: Integer;
  AArgMin: Integer; AArgMax: Integer; ACall: PDEExpressionFunction);
var
  pFuncDesc: TADFuncDesc;
begin
  pFuncDesc := TADFuncDesc.Create;
  with pFuncDesc do begin
    FScopeKind := AScopeKind;
    FScopeKindArg := AScopeKindArg;
    FDataType := ADataType;
    FDataTypeArg := ADataTypeArg;
    FArgMin := AArgMin;
    FArgMax := AArgMax;
    FCall := ACall;
  end;
  ADFunctions.AddObject(UpperCase(AName), pFuncDesc);
end;

{-------------------------------------------------------------------------------}
function GetFuncDesc(AIndex: Integer): TADFuncDesc;
begin
  Result := TADFuncDesc(ADFunctions.Objects[AIndex]);
end;

{-------------------------------------------------------------------------------}
{ TADExpression                                                                 }
{-------------------------------------------------------------------------------}
constructor TADExpression.Create(AOptions: TADExpressionOptions;
  const ADataSource: IADStanExpressionDataSource);
begin
  inherited Create;
  FOptions := AOptions;
  FDataSource := ADataSource;
  FSubAggregates := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADExpression.Destroy;
begin
  ClearNodes;
  FSubAggregates := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADExpression.GetSubAggregateCount: Integer;
begin
  Result := Length(FSubAggregates);
end;

{-------------------------------------------------------------------------------}
function TADExpression.GetSubAggregateKind(AIndex: Integer): TADAggregateKind;
var
  pNode: PDEExpressionNode;
  pFunc: TADFuncDesc;
begin
  pNode := FSubAggregates[AIndex];
  pFunc := GetFuncDesc(pNode^.FFuncInd);
  Result := pFunc.FCall(Null, nil);
end;

{-------------------------------------------------------------------------------}
function TADExpression.HandleNotification(AKind, AReason: Word; AParam1, AParam2: LongWord): Boolean;
begin
  { TODO -cEXP : HandleNotification and expression unpreparing at column changes }
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADExpression.GetDataSource: IADStanExpressionDataSource;
begin
  Result := FDataSource;
end;

{-------------------------------------------------------------------------------}
function TADExpression.GetDataType: TADDataType;
begin
  Result := FRoot^.FDataType;
end;

{-------------------------------------------------------------------------------}
function TADExpression.NewNode(AKind: TADExpressionNodeKind;
  AOperator: TADExpressionOperator; const AData: Variant;
  ALeft, ARight: PDEExpressionNode; AFuncInd: Integer): PDEExpressionNode;
begin
  New(Result);
  with Result^ do begin
    FNext := FNodes;
    FKind := AKind;
    FOperator := AOperator;
    FData := AData;
    FLeft := ALeft;
    FRight := ARight;
    FArgs := nil;
    FDataType := dtUnknown;
    FScopeKind := ckUnknown;
    FFuncInd := AFuncInd;
    FColumnInd := -1;
    FPartial := False;
  end;
  if (AKind = enFunc) and (GetFuncDesc(AFuncInd).FScopeKind = ckAgg) then begin
    SetLength(FSubAggregates, Length(FSubAggregates) + 1);
    FSubAggregates[Length(FSubAggregates) - 1] := Result;
  end;
  FNodes := Result;
end;

{-------------------------------------------------------------------------------}
procedure TADExpression.ClearNodes;
var
  Node: PDEExpressionNode;
begin
  FSubAggregates := nil;
  while FNodes <> nil do begin
    Node := FNodes;
    FNodes := Node^.FNext;
    FreeAndNil(Node^.FArgs);
    Dispose(Node);
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpression.InternalEvaluate(ANode: PDEExpressionNode): Variant;
var
  l, r: Variant;
  i: Integer;
  pR: PDEExpressionNode;
  esc: String;
  pFunc: TADFuncDesc;
{$IFNDEF AnyDAC_D6Base}
  crL, crR: Currency;
{$ENDIF}

  procedure EvalError(const AMsg: String);
  begin
    ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprEvalError, [AMsg]);
  end;

  function VarIsString(const V: Variant): Boolean;
  var
    tp: Integer;
  begin
    tp := VarType(V);
    Result := (tp = varString) or (tp = varOleStr);
  end;

  procedure UpperCaseLR;
  begin
    if VarIsString(l) then
      l := AnsiUpperCase(l);
    if VarIsString(r) then
      r := AnsiUpperCase(r);
  end;

{$IFDEF AnyDAC_FPC}
  procedure NormalaizeStringsLR;
  var
    tpL, tpR: Integer;
    ws: WideString;
  begin
    tpL := VarType(l);
    tpR := VarType(r);
    if (tpL = varOleStr) and (tpR = varString) then begin
      ws := r;
      r := ws;
    end
    else if (tpR = varOleStr) and (tpL = varString) then begin
      ws := l;
      l := ws;
    end;
  end;
{$ENDIF}
  
  function PartialEQ(AForce: Boolean): Boolean;
  var
    sL, sR: String;
    ln, lnL, lnR: Integer;
    partial: Boolean;
  begin
    if VarIsString(l) and VarIsString(r) then begin
      sL := l;
      sR := r;
      lnL := Length(sL);
      lnR := Length(sR);
      if l <> '' then begin
        partial := False;
        if sL[lnL] = '*' then begin
          partial := True;
          Dec(lnL);
        end;
        if r <> '' then begin
          if sR[lnR] = '*' then begin
            partial := True;
            Dec(lnR);
          end;
          if partial or AForce then begin
            ln := lnR;
            if ln > lnL then
              ln := lnL;
            if lnL < lnR then
              Result := False
            else if (ekNoCase in FOptions) then
              Result := ({$IFDEF AnyDAC_NOLOCALE_DATA} StrLIComp {$ELSE} AnsiStrLIComp {$ENDIF}
                         (PChar(sL), PChar(sR), ln) = 0)
            else
              Result := ({$IFDEF AnyDAC_NOLOCALE_DATA} StrLComp {$ELSE} AnsiStrLComp {$ENDIF}
                         (PChar(sL), PChar(sR), ln) = 0);
            Exit;
          end;
        end;
      end;
      if (ekNoCase in FOptions) then
        Result := ({$IFDEF AnyDAC_NOLOCALE_DATA} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
                   (sL, sR) = 0)
      else
        Result := ({$IFDEF AnyDAC_NOLOCALE_DATA} CompareStr {$ELSE} AnsiCompareStr {$ENDIF}
                   (sL, sR) = 0);
    end
    else begin
      UpperCaseLR;
      Result := l = r;
    end;
  end;

  function EvaluteNodeValue(ANode: PDEExpressionNode): Variant;
  begin
    if ANode^.FKind = enField then
      Result := FDataSource.VarData[ANode^.FColumnInd]
    else if ANode^.FKind = enConst then
      Result := ANode^.FData
    else
      Result := InternalEvaluate(ANode);
{$IFNDEF AnyDAC_D6Base}
    if TVarData(Result).VType = varInt64 then begin
      if Decimal(Result).Lo64 > MAXINT then
        raise Exception.Create('Variant operation with Int64 greater than MAXINT is not supported in D5');
      Result := Integer(Decimal(Result).Lo64);
    end;
{$ENDIF}
  end;

begin
  try
    case ANode^.FKind of
    enUnknown:
      ;
    enField:
      Result := FDataSource.VarData[ANode^.FColumnInd];
    enConst:
      Result := ANode^.FData;
    enOperator:
      case ANode^.FOperator of
      canNOTDEFINED:
        ;
      canASSIGN:
        FDataSource.VarData[ANode^.FRight^.FColumnInd] := EvaluteNodeValue(ANode^.FLeft);
      canOR:
        Result := Boolean(EvaluteNodeValue(ANode^.FLeft)) or Boolean(EvaluteNodeValue(ANode^.FRight));
      canAND:
        Result := Boolean(EvaluteNodeValue(ANode^.FLeft)) and Boolean(EvaluteNodeValue(ANode^.FRight));
      canNOT:
        Result := not Boolean(EvaluteNodeValue(ANode^.FLeft));
      canEQ, canNE, canGE, canLE, canGT, canLT:
        begin
          l := EvaluteNodeValue(ANode^.FLeft);
          pR := ANode^.FRight;
          if pR^.FOperator in [canANY, canALL] then begin
            for i := 0 to pR^.FArgs.Count - 1 do begin
              r := EvaluteNodeValue(PDEExpressionNode(pR^.FArgs[i]));
{$IFDEF AnyDAC_FPC}
              if ((VarType(l) = varString) or (VarType(l) = varOleStr)) and
                 ((VarType(r) = varString) or (VarType(r) = varOleStr)) then
                NormalaizeStringsLR;
{$ENDIF}
              if (ekNoCase in FOptions) and (ekPartial in FOptions) then
                UpperCaseLR;
              case ANode^.FOperator of
                canEQ:
                  if ekPartial in FOptions then
                    Result := PartialEQ(ANode^.FPartial)
                  else
                    Result := l = r;
                canNE: Result := l <> r;
                canGE: Result := l >= r;
                canLE: Result := l <= r;
                canGT: Result := l > r;
                canLT: Result := l < r;
              end;
              if (pR^.FOperator = canANY) and Result or
                 (pR^.FOperator = canALL) and not Result then
                Break;
            end;
          end
          else begin
            r := EvaluteNodeValue(ANode^.FRight);
{$IFDEF AnyDAC_FPC}
            if ((VarType(l) = varString) or (VarType(l) = varOleStr)) and
               ((VarType(r) = varString) or (VarType(r) = varOleStr)) then
              NormalaizeStringsLR;
{$ENDIF}
            if (ekNoCase in FOptions) and (ekPartial in FOptions) then
              UpperCaseLR;
            case ANode^.FOperator of
              canEQ:
                if ekPartial in FOptions then
                  Result := PartialEQ(ANode^.FPartial)
                else
{$IFNDEF AnyDAC_D6Base}
                if (VarType(l) in [varCurrency, varDouble]) or
                   (VarType(r) in [varCurrency, varDouble]) then begin
                  crL := l;
                  crR := r;
                  Result := crL = crR;
                end
                else
{$ENDIF}
                  Result := l = r;
              canNE:
                if ekPartial in FOptions then
                  Result := not PartialEQ(ANode^.FPartial)
                else
                  Result := l <> r;
              canGE: Result := l >= r;
              canLE: Result := l <= r;
              canGT: Result := l > r;
              canLT: Result := l < r;
            end;
          end;
        end;
      canLIKE, canNOTLIKE:
        begin
          if ANode^.FArgs <> nil then
            esc := EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[0]))
          else
            esc := #9;
          Result := FunLike(EvaluteNodeValue(ANode^.FLeft), EvaluteNodeValue(ANode^.FRight),
                            ekNoCase in FOptions, '%', '_', esc[1]);
          if ANode^.FOperator = canNOTLIKE then
            Result := not Result;
        end;
      canISBLANK, canNOTBLANK:
        begin
          if ANode^.FLeft^.FKind = enField then
            Result := StrIsNull(FDataSource.VarData[ANode^.FLeft^.FColumnInd])
          else
            Result := StrIsNull(EvaluteNodeValue(ANode^.FLeft));
          if ANode^.FOperator = canNOTBLANK then
            Result := not Result;
        end;
      canIN, canNOTIN:
        begin
          Result := False;
          l := EvaluteNodeValue(ANode^.FLeft);
          for i := 0 to ANode^.FArgs.Count - 1 do
            if l = EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[i])) then begin
              Result := True;
              Break;
            end;
          if ANode^.FOperator = canNOTIN then
            Result := not Result;
        end;
      canCONCAT, canADD:
        Result := EvaluteNodeValue(ANode^.FLeft) + EvaluteNodeValue(ANode^.FRight);
      canSUB:
        Result := EvaluteNodeValue(ANode^.FLeft) - EvaluteNodeValue(ANode^.FRight);
      canMUL:
        Result := EvaluteNodeValue(ANode^.FLeft) * EvaluteNodeValue(ANode^.FRight);
      canDIV:
        Result := EvaluteNodeValue(ANode^.FLeft) / EvaluteNodeValue(ANode^.FRight);
      canBETWEEN, canNOTBETWEEN:
        begin
          l := EvaluteNodeValue(ANode^.FLeft);
          Result := (l >= EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[0]))) and
                    (l <= EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[1])));
          if ANode^.FOperator = canNOTBETWEEN then
            Result := not Result;
        end;
      end;
    enFunc:
      begin
        pFunc := GetFuncDesc(ANode^.FFuncInd);
        if pFunc.FScopeKind = ckAgg then
          Result := FDataSource.SubAggregateValue[ADIndexOf(Pointer(FSubAggregates), -1, ANode)]
        else begin
          if LongWord(@pFunc.FCall) = LongWord(@FunIIF) then begin
            r := EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[0]));
            if StrIsNull(r) then
              Result := Null
            else if r then
              Result := EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[1]))
            else
              Result := EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[2]));
          end
          else begin
            if (ANode^.FArgs = nil) or (ANode^.FArgs.Count = 0) then
              r := null
            else begin
              r := VarArrayCreate([0, ANode^.FArgs.Count - 1], varVariant);
              for i := 0 to ANode^.FArgs.Count - 1 do
                r[i] := EvaluteNodeValue(PDEExpressionNode(ANode^.FArgs.Items[i]));
            end;
            Result := pFunc.FCall(r, Self);
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      EvalError(E.Message);
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpression.Evaluate: Variant;
begin
  Result := InternalEvaluate(FRoot);
end;

{-------------------------------------------------------------------------------}
function TADExpression.EvaluateSubAggregateArg(AIndex: Integer): Variant;
var
  pNode: PDEExpressionNode;
begin
  pNode := FSubAggregates[AIndex];
  if (pNode^.FArgs = nil) or (pNode^.FArgs.Count = 0) then
    Result := '*'
  else
    Result := InternalEvaluate(PDEExpressionNode(pNode^.FArgs.Items[0]));
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_DEBUG}
procedure TADExpression.Dump(AStrs: TStrings);
const
  enk2s: array[TADExpressionNodeKind] of String = (
    'enUnknown', 'enField', 'enConst', 'enOperator', 'enFunc');
  bool2s: array[Boolean] of String = (
    'False', 'True');
  esk2s: array[TADExpressionScopeKind] of String = (
    'ckUnknown', 'ckField', 'ckAgg', 'ckConst'
  );
  co2s: array[TADExpressionOperator] of String = (
    'canNOTDEFINED', 'canASSIGN', 'canOR', 'canAND', 'canNOT', 'canEQ', 'canNE',
    'canGE', 'canLE', 'canGT', 'canLT', 'canLIKE', 'canISBLANK', 'canNOTBLANK',
    'canIN', 'canCONCAT', 'canADD', 'canSUB', 'canMUL', 'canDIV', 'canNOTIN',
    'canANY', 'canALL', 'canNOTLIKE', 'canBETWEEN', 'canNOTBETWEEN'
  );

  function Var2Text(const AValue: Variant): String;
  begin
    if VarIsEmpty(AValue) then
      Result := 'Unassigned'
    else if VarIsNull(AValue) then
      Result := 'Null'
    else
      Result := AValue;
  end;

  procedure DumpNode(ANode: PDEExpressionNode; AIndent: Integer; AList: TStrings);
  var
    st: String;
    i: Integer;
  begin
    with ANode^ do begin
      st := '';
      for i := 1 to AIndent do
        st := st + ' ';
      AList.Add(st +
        'FKind: ' + enk2s[FKind] + ' ' +
        'FOper: ' + co2s[FOperator] + ' ' +
        'FData tp: ' + IntToStr(VarType(FData)) + ' ' +
        'FData vl: ' + Var2Text(FData) + ' ' +
        'FDataType: ' + C_AD_DataTypeNames[FDataType] + ' ' +
        'FScopeKind: ' + esk2s[FScopeKind]
      );
      if (FArgs <> nil) and (FArgs.Count > 0) then begin
        AList.Add(st + 'ARGS:');
        for i := 0 to FArgs.Count - 1 do
          DumpNode(PDEExpressionNode(FArgs[i]), AIndent + 2, AList);
      end;
      if FLeft <> nil then begin
        AList.Add(st + 'LEFT:');
        DumpNode(FLeft, AIndent + 2, AList);
      end;
      if FRight <> nil then begin
        AList.Add(st + 'RIGHT:');
        DumpNode(FRight, AIndent + 2, AList);
      end;
    end;
  end;

begin
  AStrs.Clear;
  if FRoot <> nil then
    DumpNode(FRoot, 0, AStrs)
  else
    AStrs.Add('-= EMPTY =-');
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADExpressionParser                                                           }
{-------------------------------------------------------------------------------}
function TADExpressionParser.Prepare(const ADataSource: IADStanExpressionDataSource;
  const AExpression: String; AOptions: TADExpressionOptions;
  AParserOptions: TADParserOptions; const AFixedColumnName: String):
  IADStanExpressionEvaluator;
var
  Root, DefField: PDEExpressionNode;
begin
  if AExpression = '' then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprEmpty, []);
  FExpression := TADExpression.Create(AOptions, ADataSource);
  try
    FFixedColumnName := AFixedColumnName;
    FDataSource := ADataSource;
    FParserOptions := AParserOptions;
    FText := AExpression;
    FSourcePtr := PChar(FText);
    NextToken;
    Root := ParseExpr;
    if FToken <> etEnd then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTermination, []);
    if (poAggregate in FParserOptions) and (Root^.FScopeKind <> ckAgg) then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprMBAgg, []);
    if (not (poAggregate in FParserOptions)) and (Root^.FScopeKind = ckAgg) then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprCantAgg, []);
    if (poDefaultExpr in FParserOptions) and (AFixedColumnName <> '') then begin
      DefField := FExpression.NewNode(enField, canNOTDEFINED, AFixedColumnName,
        nil, nil, -1);
      FixupFieldNode(DefField, AFixedColumnName);
      if (IsTemporal(DefField^.FDataType) and IsString(Root^.FDataType)) or
        ((DefField^.FDataType = dtBoolean) and IsString(Root^.FDataType)) then
        Root^.FDataType := DefField^.FDataType;
      if not (
          (Root^.FDataType = dtUnknown) or
          (Root^.FKind = enConst) and VarIsNull(Root^.FData) or
          (IsTemporal(DefField^.FDataType) and IsTemporal(Root^.FDataType)) or
          (IsNumeric(DefField^.FDataType) and IsNumeric(Root^.FDataType)) or
          (IsString(DefField^.FDataType) and IsString(Root^.FDataType)) or
          (DefField^.FDataType = dtBoolean) and (Root^.FDataType = dtBoolean)
         ) then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTypeMis, []);
      Root := FExpression.NewNode(enOperator, canASSIGN, Unassigned, Root,
        DefField, -1);
    end;
    if not (poAggregate in FParserOptions) and not (poDefaultExpr in FParserOptions)
      and (Root^.FDataType <> dtBoolean) then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprIncorrect, []);
    if poCheck in FParserOptions then
      Optimize(Root);
    FExpression.FRoot := Root;
    Result := FExpression;
  except
    FreeAndNil(FExpression);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.GetDataSource: IADStanExpressionDataSource;
begin
  Result := FDataSource;
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.Optimize(ANode: PDEExpressionNode);
begin
  // ???
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.FixupFieldNode(ANode: PDEExpressionNode; const AColumnName: String);
begin
  with ANode^ do
    if FKind = enField then begin
      if poFieldNameGiven in FParserOptions then
        FColumnInd := FDataSource.VarIndex[FFixedColumnName];
      if FColumnInd = -1 then
        FColumnInd := FDataSource.VarIndex[AColumnName];
      if FColumnInd = -1 then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ColumnDoesnotFound,
          [AColumnName]);
      FDataType := FDataSource.VarType[FColumnInd];
      FScopeKind := FDataSource.VarScope[FColumnInd];
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.SaveState(var ABmk: TADExprParserBmk);
begin
  ABmk.FSourcePtr := FSourcePtr;
  ABmk.FToken := FToken;
  ABmk.FTokenString := FTokenString;
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.RestoreState(var ABmk: TADExprParserBmk);
begin
  FSourcePtr := ABmk.FSourcePtr;
  FToken := ABmk.FToken;
  FTokenString := ABmk.FTokenString;
  FUCTokenString := UpperCase(ABmk.FTokenString);
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.NextTokenIsLParen : Boolean;
var
  P : PChar;
begin
  P := FSourcePtr;
  while (P^ <> #0) and (P^ <= ' ') do
    Inc(P);
  Result := P^ = '(';
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.NextToken;
type
  ASet = Set of Char;
var
  tmpPtr, P, TokenStart: PChar;
  L: Integer;
  StrBuf: array[0..255] of Char;
  PrevToken: TADExpressionToken;
  PrevTokenStr: String;
  ch2: Char;
  sign: Double;
  prevDecSep: Char;
  bmk: TADExprParserBmk;

  procedure Skip(TheSet: ASet);
  begin
    while (P^ <> #0) and (P^ in TheSet) do
      Inc(P);
  end;

  procedure SkipWS;
  begin
    while (P^ <> #0) and (P^ <= ' ') do
      Inc(P);
  end;

  procedure SkpiWhileNot(TheSet: ASet);
  begin
    while (P^ <> #0) and not (P^ in TheSet) do
      Inc(P);
  end;

  procedure ExtractToken(TheSet: ASet);
  begin
    SkipWS;
    TokenStart := P;
    Skip(TheSet);
    SetString(FTokenString, TokenStart, P - TokenStart);
    FUCTokenString := AnsiUpperCase(FTokenString);
  end;

  procedure ExtractWord;
  begin
    ExtractToken(['A'..'Z', 'a'..'z']);
  end;

  procedure DoNaturalComp;
  begin
    if (FUCTokenString = 'EQUAL') or (FUCTokenString = 'SAME') then
      FToken := etEQ
    else if (FUCTokenString = 'GREATER') or
        (FUCTokenString = 'UPPER') and (P^ <> '(') then
      FToken := etGT
    else if (FUCTokenString = 'LESS') or
        (FUCTokenString = 'LOWER') and (P^ <> '(') then
      FToken := etLT;
    if FToken in [etGT, etLT] then begin
      ExtractWord;
      if FUCTokenString <> 'THAN' then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_InvalidKeywordUse, []);
      tmpPtr := P;
      ExtractWord;
      if FUCTokenString = 'OR' then begin
        ExtractWord;
        if (FUCTokenString = 'EQUAL') or (FUCTokenString = 'SAME') then begin
          if FToken = etGT then
            FToken := etGE
          else if FToken = etLT then
            FToken := etLE;
        end
        else
          ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_InvalidKeywordUse, []);
      end
      else
        P := tmpPtr;
    end;
  end;

begin
  PrevToken := FToken;
  PrevTokenStr := FUCTokenString;
  FTokenString := '';
  P := FSourcePtr;
  SkipWS;
  // /* comment */
  if (P^ <> #0) and (P^ = '/') and (P[1] <> #0) and (P[1] = '*') then begin
    Inc(P, 2);
    SkpiWhileNot(['*']);
    if (P^ = '*') and (P[1] <> #0) and (P[1] = '/') then
      Inc(P, 2)
    else
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprInvalidChar,
        [String(P)]);
  end
  // -- comment
  else if (P^ <> #0) and (P^ = '-') and (P[1] <> #0) and (P[1] = '-') then begin
    Inc(P, 2);
    SkpiWhileNot([#13, #10]);
  end;
  SkipWS;
  FTokenPtr := P;

  case P^ of
  'A'..'Z', 'a'..'z', 'À'..'ß', 'à'..'ÿ':
    begin
      ExtractToken(['A'..'Z', 'a'..'z', '0'..'9', '$', '#', '_', '.',
             'À'..'ß', 'à'..'ÿ']);
      FToken := etSymbol;
      if FUCTokenString = 'NOT' then begin
        SaveState(bmk);
        tmpPtr := P;
        ExtractWord;
        if FUCTokenString = 'IN' then
          FToken := etNOTIN
        else if FUCTokenString = 'LIKE' then
          FToken := etNOTLIKE
        else if FUCTokenString = 'BETWEEN' then
          FToken := etNOTBETWEEN
        else begin
          RestoreState(bmk);
          P := tmpPtr;
        end;
      end
      else if FUCTokenString = 'LIKE' then
        FToken := etLIKE
      else if FUCTokenString = 'IN' then
        FToken := etIN
      else if FUCTokenString = 'ANY' then
        FToken := etANY
      else if FUCTokenString = 'SOME' then
        FToken := etSOME
      else if FUCTokenString = 'ALL' then
        FToken := etALL
      else if FUCTokenString = 'BETWEEN' then
        FToken := etBETWEEN
      else if FUCTokenString = 'FIRST' then
        FToken := etFIRST
      else if FUCTokenString = 'LAST' then
        FToken := etLAST
      else if (FUCTokenString = 'PRIOR') or (FUCTokenString = 'PREVIOS') then
        FToken := etPRIOR
      else if (FUCTokenString = 'NEXT') or (FUCTokenString = 'FOLLOWS') then
        FToken := etNEXT
      else if (FUCTokenString = 'THIS') or (FUCTokenString = 'CURREDE') then
        FToken := etTHIS
      else if not FInSQLLang and (FUCTokenString = 'DAY') then
        FToken := etDAY
      else if not FInSQLLang and (FUCTokenString = 'MONTH') then
        FToken := etMONTH
      else if not FInSQLLang and (FUCTokenString = 'QUARTER') then
        FToken := etQUARTER
      else if not FInSQLLang and (FUCTokenString = 'YEAR') then
        FToken := etYEAR
      else if not FInSQLLang and (FUCTokenString = 'OF') then
        FToken := etOF
      else if FUCTokenString = 'IS' then begin
        ExtractWord;
        if FUCTokenString = 'NOT' then begin
          ExtractWord;
          if FUCTokenString = 'NULL' then
            FToken := etISNOTNULL;
        end
        else if FUCTokenString = 'NULL' then
          FToken := etISNULL
        else
          DoNaturalComp;
        if FToken = etSYMBOL then
          ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_InvalidKeywordUse, []);
      end
      else if FUCTokenString = 'NULL' then
        FToken := etNULL
      else
        DoNaturalComp;
    end;
  '[', '"':
    begin
      if P^ = '[' then
        ch2 := ']'
      else
        ch2 := '"';
      Inc(P);
      TokenStart := P;
      P := AnsiStrScan(P, ch2);
      if P = nil then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNameError, []);
      SetString(FTokenString, TokenStart, P - TokenStart);
      FToken := etName;
      Inc(P);
    end;
  '''':
    begin
      Inc(P);
      L := 0;
      while True do begin
        if P^ = #0 then
          ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprStringError, []);
        if P^ = '''' then begin
          Inc(P);
          if P^ <> '''' then
            Break;
        end;
        if L < SizeOf(StrBuf) then begin
          StrBuf[L] := P^;
          Inc(L);
        end;
        Inc(P);
      end;
      SetString(FTokenString, StrBuf, L);
      FToken := etLiteral;
      FNumericLit := False;
    end;
  '-', '+', '0'..'9', '.':
    begin
      if (PrevToken <> etLiteral) and (PrevToken <> etName) and
         ((PrevToken <> etSymbol) or (PrevTokenStr = 'AND')) and
         (PrevToken <> etRParen) and (PrevToken <> etEMBEDDING) then begin
        if P^ = '-' then begin
          sign := -1;
          Inc(P);
        end
        else if P^ = '+' then begin
          sign := 1;
          Inc(P);
        end
        else
          sign := 1;
        ExtractToken(['0'..'9', '.']);
        FToken := etLiteral;
        FNumericLit := True;
        prevDecSep := DecimalSeparator;
        DecimalSeparator := '.';
        try
          FTokenNumber := StrToFloat(FTokenString) * sign;
        finally
          DecimalSeparator := prevDecSep;
        end;
      end
      else if P^ = '+' then begin
        Inc(P);
        FToken := etADD;
      end
      else if P^ = '-' then begin
        FToken := etSUB;
        Inc(P);
      end
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprInvalidChar,
          [String(P)]);
    end;
  '(':
    begin
      Inc(P);
      FToken := etLParen;
    end;
  ')':
    begin
      Inc(P);
      FToken := etRParen;
    end;
  '<':
    begin
      Inc(P);
      case P^ of
      '=':
        begin
          Inc(P);
          FToken := etLE;
        end;
      '>':
        begin
          Inc(P);
          FToken := etNE;
        end;
      else
        FToken := etLT;
      end;
    end;
  '^', '!':
    begin
      Inc(P);
      if P^ = '=' then begin
        Inc(P);
        FToken := etNE;
      end
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprInvalidChar,
          [String(P)]);
    end;
  '=':
    begin
      Inc(P);
      FToken := etEQ;
    end;
  '>':
    begin
      Inc(P);
      if P^ = '=' then begin
        Inc(P);
        FToken := etGE;
      end
      else
        FToken := etGT;
    end;
  '|':
    begin
      Inc(P);
      if P^ = '|' then begin
        Inc(P);
        FToken := etCONCAT;
      end
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprInvalidChar,
          [String(P)]);
    end;
  '*':
    begin
      Inc(P);
      FToken := etMUL;
    end;
  '/':
    begin
      Inc(P);
      FToken := etDIV;
   end;
  ',':
    begin
      Inc(P);
      FToken := etComma;
    end;
  '@':
    begin
      Inc(P);
      if P^ = '@' then begin
        Inc(P);
        FToken := etEMBEDDING;
        ExtractToken(['0'..'9']);
      end
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprInvalidChar,
          [String(P)]);
    end;
  #0:
    FToken := etEnd;
  else
    ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprInvalidChar,
      [String(P)]);
  end;
  FSourcePtr := P;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr: PDEExpressionNode;
begin
  Result := ParseExpr2;
  while TokenSymbolIs('OR') do begin
    NextToken;
    Result := FExpression.NewNode(enOperator, canOR, Unassigned, Result,
      ParseExpr2, -1);
    GetScopeKind(Result, Result^.FLeft, Result^.FRight);
    Result^.FDataType := dtBoolean;
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr2: PDEExpressionNode;
begin
  Result := ParseExpr3;
  while TokenSymbolIs('AND') do begin
    NextToken;
    Result := FExpression.NewNode(enOperator, canAND, Unassigned, Result,
      ParseExpr3, -1);
    GetScopeKind(Result, Result^.FLeft, Result^.FRight);
    Result^.FDataType := dtBoolean;
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr3: PDEExpressionNode;
begin
  if TokenSymbolIs('NOT') then begin
    NextToken;
    Result := FExpression.NewNode(enOperator, canNOT, Unassigned, ParseExpr4,
      nil, -1);
    Result^.FDataType := dtBoolean;
  end
  else
    Result := ParseExpr4;
  GetScopeKind(Result, Result^.FLeft, Result^.FRight);
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr4: PDEExpressionNode;
const
  Operators: array[etEQ..etLT] of TADExpressionOperator = (
    canEQ, canNE, canGE, canLE, canGT, canLT);
var
  eOperator: TADExpressionOperator;
  Left, Right: PDEExpressionNode;
begin
  Result := ParseExprNatural(False);
  if (FToken in [etEQ..etLT, etLIKE, etNOTLIKE, etISNULL, etISNOTNULL,
                 etIN, etNOTIN, etBETWEEN, etNOTBETWEEN]) then begin
    case FToken of
    etEQ..etLT:
      eOperator := Operators[FToken];
    etLIKE:
      eOperator := canLIKE;
    etNOTLIKE:
      eOperator := canNOTLIKE;
    etISNULL:
      eOperator := canISBLANK;
    etISNOTNULL:
      eOperator := canNOTBLANK;
    etIN:
      eOperator := canIN;
    etNOTIN:
      eOperator := canNOTIN;
    etBETWEEN:
      eOperator := canBETWEEN;
    etNOTBETWEEN:
      eOperator := canNOTBETWEEN;
    else
      eOperator := canNOTDEFINED;
    end;
    NextToken;
    Left := Result;
    if eOperator in [canIN, canNOTIN] then begin
      if FToken <> etLParen then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoLParen,
          [TokenName]);
      NextToken;
      Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, nil, -1);
      Result^.FDataType := dtBoolean;
      if FToken <> etRParen then begin
        Result^.FArgs := TList.Create;
        repeat
          Right := ParseExpr;
          if IsTemporal(Left^.FDataType) then
            Right^.FDataType := Left^.FDataType;
          Result^.FArgs.Add(Right);
          if (FToken <> etComma) and (FToken <> etRParen) then
            ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoRParenOrComma,
              [TokenName]);
          if FToken = etComma then
            NextToken;
        until (FToken = etRParen) or (FToken = etEnd);
        if FToken <> etRParen then
          ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoRParen,
            [TokenName]);
        NextToken;
      end
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprEmptyInList, []);
    end
    else if eOperator in [canBETWEEN, canNOTBETWEEN] then begin
      Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, nil, -1);
      Result^.FDataType := dtBoolean;
      Result^.FArgs := TList.Create;
      Result^.FArgs.Add(ParseExprNatural(False));
      if TokenSymbolIs('AND') then
        NextToken
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprExpected, ['AND']);
      Result^.FArgs.Add(ParseExprNatural(False));
    end
    else begin
      if eOperator in [canEQ, canNE, canGE, canLE, canGT, canLT] then begin
        Right := ParseExprNatural(True);
        Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, Right, -1);
      end
      else if eOperator in [canLIKE, canNOTLIKE] then begin
        Right := ParseExprNatural(False);
        Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, Right, -1);
        if TokenSymbolIs('ESCAPE') then begin
          NextToken;
          Result^.FArgs := TList.Create;
          Result^.FArgs.Add(ParseExprNatural(False));
        end;
      end
      else begin
        Right := nil;
        Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, Right, -1);
      end;
      if Right <> nil then begin
        if (Left^.FKind = enField) and (Right^.FKind = enConst) then
          Right^.FDataType := Left^.FDataType
        else if (Right^.FKind = enField) and (Left^.FKind = enConst) then
          Left^.FDataType := Right^.FDataType
      end;
      if IsBLOB(Left^.FDataType) and (eOperator in [canLIKE, canNOTLIKE]) then begin
        if Right^.FKind = enConst then
          Right^.FDataType := dtAnsiString;
      end
      else if not (eOperator in [canISBLANK, canNOTBLANK])
          and (IsBLOB(Left^.FDataType) or
             (Right <> nil) and IsBLOB(Right^.FDataType)) then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTypeMis, []);
      Result^.FDataType := dtBoolean;
      if Right <> nil then begin
        if IsTemporal(Left^.FDataType) and IsString(Right^.FDataType) then
          Right^.FDataType := Left^.FDataType
        else if IsTemporal(Right^.FDataType) and IsString(Left^.FDataType) then
          Left^.FDataType := Right^.FDataType;
      end;
      GetScopeKind(Result, Left, Right);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function NaturalDateExpr(const D, M, Q, Y: String; DM, dmOf, MM, mmOf, QM, YM: TADExpressionToken): String;
begin
  if YM <> etEnd then
    Result := 'SYSDATE'
  else
    Result := '';

  case YM of
  etABS:  Result := 'ADD_MONTHS(SYSDATE, (' + Y + ' - YEAR(SYSDATE)) * 12)';
  etFIRST: Result := 'ADD_MONTHS(SYSDATE, - (12 * 2000))';
  etLAST: Result := 'ADD_MONTHS(SYSDATE, 12 * 2000)';
  etPRIOR: Result := 'ADD_MONTHS(SYSDATE, -12)';
  etNEXT: Result := 'ADD_MONTHS(SYSDATE, 12)';
  end;

  if (QM <> etEnd) and (Result = '') then
    Result := 'SYSDATE';
  case QM of
  etABS:  Result := 'ADD_MONTHS(' + Result + ', ' + Q + ' * 3 - MONTH(' + Result + '))';
  etFIRST: Result := 'ADD_MONTHS(' + Result + ', 1 - MONTH(' + Result + '))';
  etLAST: Result := 'ADD_MONTHS(' + Result + ', 12 - MONTH(' + Result + '))';
  etPRIOR: Result := 'ADD_MONTHS(' + Result + ', -3)';
  etNEXT: Result := 'ADD_MONTHS(' + Result + ', 3)';
  end;

  if (MM <> etEnd) and (Result = '') then
    Result := 'SYSDATE';
  case MM of
  etABS:
    case mmOf of
    etQUARTER:
      Result := 'ADD_MONTHS(' + Result + ', TRUNC((MONTH(' + Result +
        ') - 1) / 3) * 3 + 1 - MONTH(' + Result + ') + ' + M + ')';
    else
      Result := 'ADD_MONTHS(' + Result + ', ' + M + ' - MONTH(' + Result + '))';
    end;
  etFIRST:
    case mmOf of
    etQUARTER:
      Result := 'ADD_MONTHS(' + Result + ', TRUNC((MONTH(' + Result +
        ') - 1) / 3) * 3 + 1 - MONTH(' + Result + '))';
    else
      Result := 'ADD_MONTHS(' + Result + ', 1 - MONTH(' + Result + '))';
    end;
  etLAST:
    case mmOf of
    etQUARTER:
      Result := 'ADD_MONTHS(' + Result + ', TRUNC((MONTH(' + Result +
        ') - 1) / 3 + 1) * 3 - MONTH(' + Result + '))';
    else
      Result := 'ADD_MONTHS(' + Result + ', 12 - MONTH(' + Result + '))';
    end;
  etPRIOR: Result := 'ADD_MONTHS(' + Result + ', -1)';
  etNEXT: Result := 'ADD_MONTHS(' + Result + ', 1)';
  end;

  if (DM <> etEnd) and (Result = '') then
    Result := 'SYSDATE';
  case DM of
  etABS:
    case dmOf of
    etMONTH:
      Result := 'FIRST_DAY(' + Result + ') - 1 + ' + D;
    etQUARTER:
      Result := 'FIRST_DAY(ADD_MONTHS(' + Result + ', TRUNC((MONTH(' + Result +
        ') - 1) / 3) * 3 + 1 - MONTH(' + Result + '))) - 1 + ' + D;
    else
      Result := 'TO_DATE(''01' + DateSeparator + '01' + DateSeparator +
        ''' || TO_CHAR(YEAR(' + Result + ', )), ''DD/MM/YYYY'') - 1 + ' + D;
    end;
  etFIRST:
    case dmOf of
    etMONTH:
      Result := 'FIRST_DAY(' + Result + ')';
    etQUARTER:
      Result := 'FIRST_DAY(ADD_MONTHS(' + Result + ', TRUNC((MONTH(' + Result +
        ') - 1) / 3) * 3 + 1 - MONTH(' + Result + ')))';
    else
      Result := 'TO_DATE(''01' + DateSeparator + '01' + DateSeparator +
        ''' || TO_CHAR(YEAR(' + Result + ')), ''DD/MM/YYYY'')';
    end;
  etLAST:
    case dmOf of
    etMONTH:
      Result := 'LAST_DAY(' + Result + ')';
    etQUARTER:
      Result := 'LAST_DAY(ADD_MONTHS(' + Result + ', TRUNC((MONTH(' + Result +
        ') - 1) / 3 + 1) * 3 - MONTH(' + Result + ')))';
    else
      Result := 'TO_DATE(''31' + DateSeparator + '12' + DateSeparator +
        ''' || TO_CHAR(YEAR(' + Result + ')), ''DD/MM/YYYY'')';
    end;
  etPRIOR: Result := Result + ' - 1';
  etNEXT: Result := Result + ' + 1';
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExprNatural(AEnableList: Boolean): PDEExpressionNode;
var
  d, m, q, y: String;
  dm, mm, qm, ym: TADExpressionToken;
  dmOf, mmOf: TADExpressionToken;
  s: String;
  Bmk, Bmk2: TADExprParserBmk;
  ePriorToken: TADExpressionToken;
begin
  Result := ParseExpr5(AEnableList);
  // List of values and after that natural lang - not supported !
  if FToken in [etFIRST, etLAST, etNEXT, etPRIOR, etTHIS,
                etDAY, etMONTH, etQUARTER, etYEAR] then begin
    d := '';
    m := '';
    q := '';
    y := '';
    dm := etEnd;
    mm := etEnd;
    qm := etEnd;
    ym := etEnd;
    dmOf := etEnd;
    mmOf := etEnd;
    SaveState(Bmk2);
    while FToken in [etFIRST, etLAST, etNEXT, etPRIOR, etTHIS,
             etDAY, etMONTH, etQUARTER, etYEAR] do begin
      ePriorToken := FToken;
      if FToken in [etFIRST, etLAST, etNEXT, etPRIOR, etTHIS] then begin
        SaveState(Bmk);
        NextToken;
      end
      else begin
        Bmk.FToken := etABS;
        Bmk.FTokenString := '@@' + IntToStr(Integer(Pointer(Result)));
      end;
      case FToken of
      etDAY:
        begin
          dm := Bmk.FToken;
          if Bmk.FToken = etABS then
            d := Bmk.FTokenString;
        end;
      etMONTH:
        begin
          mm := Bmk.FToken;
          if Bmk.FToken = etABS then
            m := Bmk.FTokenString;
        end;
      etQUARTER:
        begin
          qm := Bmk.FToken;
          if Bmk.FToken = etABS then
            q := Bmk.FTokenString;
        end;
      etYEAR:
        begin
          ym := Bmk.FToken;
          if Bmk.FToken = etABS then
            y := Bmk.FTokenString;
        end;
      else
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTermination, []);
      end;
      if (dmOf = etEnd) and (FToken = etDAY) or
        (dmOf = etDAY) then
        dmOf := FToken;
      if (mmOf = etEnd) and (FToken = etMONTH) or
        (mmOf = etMONTH) then
        mmOf := FToken;
      NextToken;
      if FToken = etOF then
        NextToken
      else if (ePriorToken in [etDAY, etMONTH, etQUARTER, etYEAR]) and (FToken = etLParen) then begin
        // this is not natural language, but function call
        RestoreState(Bmk2);
        FToken := etSymbol;
        Result := ParseExpr5(False);
        Exit;
      end;
      // Last succesfully parsed place in input stream
      SaveState(Bmk);
      if not (FToken in [etEnd, etFIRST, etLAST, etNEXT, etPRIOR, etTHIS]) then
        try
          Result := ParseExpr5(False);
        except
          // no exceptions visible
        end;
    end;
    // Back to good place, because
    // after that it is work of ParseExpr4 and higher
    RestoreState(Bmk);
    s := NaturalDateExpr(d, m, q, y, dm, dmOf, mm, mmOf, qm, ym);
    if s = '' then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTermination, []);
    FInSQLLang := True;
    try
      FSourcePtr := PChar(s);
      NextToken;
      Result := ParseExpr5(False);
      if FToken <> etEnd then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTermination, []);
    finally
      RestoreState(Bmk);
      FInSQLLang := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr5(AEnableList: Boolean): PDEExpressionNode;
const
  OperatorsList: array[etANY..etALL] of TADExpressionOperator = (
    canANY, canANY, canALL);
  Operators: array[etCONCAT..etSUB] of TADExpressionOperator = (
    canCONCAT, canADD, canSUB);
var
  eOperator: TADExpressionOperator;
  Left, Right: PDEExpressionNode;
begin
  if FToken in [etANY, etSOME, etALL] then begin
    if not AEnableList then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprExpected,
        [TokenName]);
    eOperator := OperatorsList[FToken];
    NextToken;
    if FToken <> etLParen then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoLParen,
        [TokenName]);
    NextToken;
    if FToken = etRParen then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprEmptyInList, []);
    Result := FExpression.NewNode(enOperator, eOperator, Unassigned, nil, nil, -1);
    Result^.FArgs := TList.Create;
    repeat
      Result^.FArgs.Add(ParseExpr);
      if (FToken <> etComma) and (FToken <> etRParen) then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoRParenOrComma,
          [TokenName]);
      if FToken = etComma then
        NextToken;
    until (FToken = etRParen) or (FToken = etEnd);
    if FToken <> etRParen then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoRParenOrComma,
        [TokenName]);
    NextToken;
    Result^.FDataType := PDEExpressionNode(Result^.FArgs.Items[0])^.FDataType;
    { TODO -cEXP : Nobody knows what to do with that ... }
    // Result.FScopeKind := PDEExpressionNode(Result.FArgs.Items[0])^.FScopeKind;
  end
  else begin
    Result := ParseExpr6;
    while FToken in [etCONCAT, etADD, etSUB] do begin
      eOperator := Operators[FToken];
      Left := Result;
      NextToken;
      Right := ParseExpr6;
      Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, Right, -1);
      TypeCheckArithOp(Result);
      GetScopeKind(Result, Left, Right);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr6: PDEExpressionNode;
const
  Operators: array[etMUL .. etDIV] of TADExpressionOperator = (
    canMUL, canDIV);
var
  eOperator: TADExpressionOperator;
  Left, Right: PDEExpressionNode;
begin
  Result := ParseExpr7;
  while FToken in [etMUL, etDIV] do begin
    eOperator := Operators[FToken];
    Left := Result;
    NextToken;
    Right := ParseExpr7;
    Result := FExpression.NewNode(enOperator, eOperator, Unassigned, Left, Right, -1);
    TypeCheckArithOp(Result);
    GetScopeKind(Result, Left, Right);
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.ParseExpr7: PDEExpressionNode;
var
  FuncName: string;
  FuncInd: Integer;
begin
  Result := nil;
  case FToken of
  etSymbol:
    begin
      FuncInd := TokenSymbolIsFunc(FTokenString);
      if FuncInd <> -1 then begin
        FuncName := FUCTokenString;
        if not NextTokenIsLParen then
          Result := FExpression.NewNode(enFunc, canNOTDEFINED, FuncName, nil,
            nil, FuncInd)
        else begin
          NextToken;
          if FToken <> etLParen then
            ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoLParen,
              [TokenName]);
          NextToken;
          if (FuncName = 'COUNT') and (FToken = etMUL) then
            NextToken;
          Result := FExpression.NewNode(enFunc, canNOTDEFINED, FuncName, nil,
            nil, FuncInd);
          if FToken <> etRParen then begin
            Result^.FArgs := TList.Create;
            repeat
              Result^.FArgs.Add(ParseExpr);
              if (FToken <> etComma) and (FToken <> etRParen) then
                ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoRParenOrComma,
                  [TokenName]);
              if FToken = etComma then
                NextToken;
            until (FToken = etRParen) or (FToken = etEnd);
          end;
        end;
        GetFuncResultInfo(Result);
      end
      else if TokenSymbolIs('NULL') then begin
        Result := FExpression.NewNode(enConst, canNOTDEFINED,
          {$IFDEF AnyDAC_D6Base}Variants.{$ENDIF}Null, nil, nil, -1);
        Result^.FScopeKind := ckConst;
      end
      else if TokenSymbolIs('TRUE') then begin
        Result := FExpression.NewNode(enConst, canNOTDEFINED, 1, nil, nil, -1);
        Result^.FScopeKind := ckConst;
      end
      else if TokenSymbolIs('FALSE') then begin
        Result := FExpression.NewNode(enConst, canNOTDEFINED, 0, nil, nil, -1);
        Result^.FScopeKind := ckConst;
      end
      else begin
        Result := FExpression.NewNode(enField, canNOTDEFINED, FTokenString, nil, nil, -1);
        FixupFieldNode(Result, FTokenString);
      end;
    end;
  etName:
    begin
      Result := FExpression.NewNode(enField, canNOTDEFINED, FTokenString, nil, nil, -1);
      FixupFieldNode(Result, FTokenString);
    end;
  etNULL:
    begin
      Result := FExpression.NewNode(enConst, canNOTDEFINED, Null, nil, nil, -1);
      Result^.FDataType := dtUnknown;
      Result^.FScopeKind := ckConst;
    end;
  etLiteral:
    begin
      if FNumericLit then begin
        Result := FExpression.NewNode(enConst, canNOTDEFINED, FTokenNumber, nil, nil, -1);
        Result^.FDataType := dtDouble;
      end
      else begin
        Result := FExpression.NewNode(enConst, canNOTDEFINED, FTokenString, nil, nil, -1);
        Result^.FDataType := dtAnsiString;
      end;
      Result^.FScopeKind := ckConst;
    end;
  etLParen:
    begin
      NextToken;
      Result := ParseExpr;
      if FToken <> etRParen then
        ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprNoRParen, [TokenName]);
    end;
  etEMBEDDING:
    Result := PDEExpressionNode(Pointer(StrToInt(FTokenString)));
  etFIRST, etLAST, etNEXT, etPRIOR, etTHIS, etABS, etDAY, etMONTH,
  etQUARTER, etYEAR, etOF:
    Exit;
  else
    ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprExpected, [TokenName]);
  end;
  NextToken;
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.GetScopeKind(Root, Left, Right: PDEExpressionNode);
begin
  if (Left = nil) and (Right = nil) then
    Exit;
  if Right = nil then begin
    Root^.FScopeKind := Left^.FScopeKind;
    Exit;
  end;
  if ((Left^.FScopeKind = ckField) and (Right^.FScopeKind = ckAgg))
    or ((Left^.FScopeKind = ckAgg) and (Right^.FScopeKind = ckField)) then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprBadScope, []);
  if (Left^.FScopeKind = ckConst) and (Right^.FScopeKind = ckConst) then
    Root^.FScopeKind := ckConst
  else if (Left^.FScopeKind = ckAgg) or (Right^.FScopeKind = ckAgg) then
    Root^.FScopeKind := ckAgg
  else if (Left^.FScopeKind = ckField) or (Right^.FScopeKind = ckField) then
    Root^.FScopeKind := ckField;
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.GetFuncResultInfo(Node : PDEExpressionNode);
var
  i, n: Integer;
  pFuncDesc: TADFuncDesc;
begin
  i := TokenSymbolIsFunc(Node^.FData);
  if (Node^.FArgs = nil) then
    n := 0
  else
    n := Node^.FArgs.Count;
  pFuncDesc := GetFuncDesc(i);
  if (pFuncDesc.FArgMin > n) or (pFuncDesc.FArgMax < n) then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTypeMis, []);
  if pFuncDesc.FDataType = dtUnknown then begin
    if pFuncDesc.FDataTypeArg = -1 then
      Node^.FDataType := dtUnknown
    else
      Node^.FDataType := PDEExpressionNode(Node^.FArgs.
        Items[pFuncDesc.FDataTypeArg])^.FDataType;
  end
  else
    Node^.FDataType := pFuncDesc.FDataType;
  if pFuncDesc.FScopeKind = ckUnknown then
    Node^.FScopeKind := PDEExpressionNode(Node^.FArgs.
      Items[pFuncDesc.FScopeKindArg])^.FScopeKind
  else
    Node^.FScopeKind := pFuncDesc.FScopeKind;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.TokenName: string;
begin
  if FSourcePtr = FTokenPtr then
    Result := '<nothing>'
  else begin
    SetString(Result, FTokenPtr, FSourcePtr - FTokenPtr);
    Result := '''' + Result + '''';
  end;
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.TokenSymbolIs(const S: string): Boolean;
begin
  Result := (FToken = etSymbol) and (FUCTokenString = S);
end;

{-------------------------------------------------------------------------------}
function TADExpressionParser.TokenSymbolIsFunc(const S: string): Integer;
begin
  Result := -1;
  if not ADFunctions.Find(UpperCase(S), Result) then
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADExpressionParser.TypeCheckArithOp(Node: PDEExpressionNode);
begin
  with Node^ do begin
    if IsNumeric(FLeft^.FDataType) and IsNumeric(FRight^.FDataType) then
      FDataType := dtDouble
    else if IsString(FLeft^.FDataType) and IsString(FRight^.FDataType) and
        ((FOperator = canADD) or (FOperator = canCONCAT)) then
      FDataType := dtAnsiString
    else if IsTemporal(FLeft^.FDataType) and IsNumeric(FRight^.FDataType) and
        (FOperator = canADD) then
      FDataType := dtDateTime
    else if IsTemporal(FLeft^.FDataType) and IsNumeric(FRight^.FDataType) and
        (FOperator = canSUB) then
      FDataType := FLeft^.FDataType
    else if IsTemporal(FLeft^.FDataType) and IsTemporal(FRight^.FDataType) and
        (FOperator = canSUB) then
      FDataType := dtDouble
    else if IsString(FLeft^.FDataType) and IsTemporal(FRight^.FDataType) and
        (FOperator = canSUB) then begin
      FLeft^.FDataType := FRight^.FDataType;
      FDataType := dtDouble;
    end
    else if IsString(FLeft^.FDataType) and IsNumeric(FRight^.FDataType) and
        (FLeft^.FKind = enConst) then
      FLeft^.FDataType := dtDateTime
    else
      ADException(Self, [S_AD_LStan, S_AD_LStan_PEval], er_AD_ExprTypeMis, []);
  end;
end;

{-------------------------------------------------------------------------------}
{ Initialization && finalization                                                }
{-------------------------------------------------------------------------------}
procedure FreeFuncs;
var
  i: Integer;
begin
  for i := 0 to ADFunctions.Count - 1 do
    ADFunctions.Objects[i].Free;
  FreeAndNil(ADFunctions);
end;

{-------------------------------------------------------------------------------}
procedure AllocFuncs;
begin
  ADFunctions := TStringList.Create;
  ADFunctions.Capacity := 100;
  ADFunctions.Sorted := True;
  ADFunctions.Duplicates := dupError;

  ADExpressionRegisterFunc('UPPER',     ckUnknown, 0, dtUnknown,  0, 1, 1, @FunUpper);
  ADExpressionRegisterFunc('LOWER',     ckUnknown, 0, dtUnknown,  0, 1, 1, @FunLower);
  ADExpressionRegisterFunc('SUBSTRING', ckUnknown, 0, dtUnknown,  0, 2, 3, @FunSubstring);
  ADExpressionRegisterFunc('TRIM',      ckUnknown, 0, dtUnknown,  0, 1, 2, @FunTrim);
  ADExpressionRegisterFunc('TRIMLEFT',  ckUnknown, 0, dtUnknown,  0, 1, 2, @FunTrimLeft);
  ADExpressionRegisterFunc('TRIMRIGHT', ckUnknown, 0, dtUnknown,  0, 1, 2, @FunTrimRight);
  ADExpressionRegisterFunc('YEAR',      ckUnknown, 0, dtInt16, -1, 1, 1, @FunYear);
  ADExpressionRegisterFunc('MONTH',     ckUnknown, 0, dtInt16, -1, 1, 1, @FunMonth);
  ADExpressionRegisterFunc('DAY',       ckUnknown, 0, dtInt16, -1, 1, 1, @FunDay);
  ADExpressionRegisterFunc('HOUR',      ckUnknown, 0, dtInt16, -1, 1, 1, @FunHour);
  ADExpressionRegisterFunc('MINUTE',    ckUnknown, 0, dtInt16, -1, 1, 1, @FunMinute);
  ADExpressionRegisterFunc('SECOND',    ckUnknown, 0, dtInt16, -1, 1, 1, @FunSecond);
  ADExpressionRegisterFunc('GETDATE',   ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetDate);
  ADExpressionRegisterFunc('DATE',      ckUnknown, 0, dtDateTime, -1, 1, 1, @FunDate);
  ADExpressionRegisterFunc('TIME',      ckUnknown, 0, dtDateTime, -1, 1, 1, @FunTime);
  ADExpressionRegisterFunc('SUM',       ckAgg,   -1, dtDouble,  -1, 1, 1, @FunAggSum);
  ADExpressionRegisterFunc('MIN',       ckAgg,   -1, dtUnknown,  0, 1, 1, @FunAggMin);
  ADExpressionRegisterFunc('MAX',       ckAgg,   -1, dtUnknown,  0, 1, 1, @FunAggMax);
  ADExpressionRegisterFunc('AVG',       ckAgg,   -1, dtDouble,  -1, 1, 1, @FunAggAvg);
  ADExpressionRegisterFunc('COUNT',     ckAgg,   -1, dtInt32, -1, 0, 1, @FunAggCount);
  ADExpressionRegisterFunc('TFIRST',    ckAgg,   -1, dtUnknown,  0, 1, 1, @FunAggFirst);
  ADExpressionRegisterFunc('TLAST',     ckAgg,   -1, dtUnknown,  0, 1, 1, @FunAggLast);
  // ---------------------------------------------
  // Oracle's
  // Numeric
  ADExpressionRegisterFunc('ABS',       ckUnknown, 0, dtDouble,  -1, 1, 1, @FunAbs);
  ADExpressionRegisterFunc('CEIL',      ckUnknown, 0, dtInt32, -1, 1, 1, @FunCeil);
  ADExpressionRegisterFunc('COS',       ckUnknown, 0, dtDouble,  -1, 1, 1, @FunCos);
  ADExpressionRegisterFunc('COSH',      ckUnknown, 0, dtDouble,  -1, 1, 1, @FunCosh);
  ADExpressionRegisterFunc('EXP',       ckUnknown, 0, dtDouble,  -1, 1, 1, @FunExp);
  ADExpressionRegisterFunc('FLOOR',     ckUnknown, 0, dtInt32, -1, 1, 1, @FunFloor);
  ADExpressionRegisterFunc('LN',        ckUnknown, 0, dtDouble,  -1, 1, 1, @FunLn);
  ADExpressionRegisterFunc('LOG',       ckUnknown, 0, dtDouble,  -1, 2, 2, @FunLog);
  ADExpressionRegisterFunc('MOD',       ckUnknown, 0, dtInt32, -1, 2, 2, @FunMod);
  ADExpressionRegisterFunc('POWER',     ckUnknown, 0, dtDouble,  -1, 2, 2, @FunPower);
  ADExpressionRegisterFunc('ROUND',     ckUnknown, 0, dtDouble,  -1, 1, 2, @FunRound);
  ADExpressionRegisterFunc('SIGN',      ckUnknown, 0, dtInt32, -1, 1, 1, @FunSign);
  ADExpressionRegisterFunc('SIN',       ckUnknown, 0, dtDouble,  -1, 1, 1, @FunSin);
  ADExpressionRegisterFunc('SINH',      ckUnknown, 0, dtDouble,  -1, 1, 1, @FunSinh);
  ADExpressionRegisterFunc('SQRT',      ckUnknown, 0, dtDouble,  -1, 1, 1, @FunSqrt);
  ADExpressionRegisterFunc('TAN',       ckUnknown, 0, dtDouble,  -1, 1, 1, @FunTan);
  ADExpressionRegisterFunc('TANH',      ckUnknown, 0, dtDouble,  -1, 1, 1, @FunTanh);
  ADExpressionRegisterFunc('TRUNC',     ckUnknown, 0, dtDouble,  -1, 1, 2, @FunTrunc);
  ADExpressionRegisterFunc('ROWNUM',    ckField,  -1, dtInt32, -1, 0, 0, @FunRowNum);
  // Strings, result string
  ADExpressionRegisterFunc('CHR',       ckUnknown, 0, dtAnsiString,  -1, 1, 1, @FunChr);
  ADExpressionRegisterFunc('CONCAT',    ckUnknown, 0, dtUnknown,  0, 2, 2, @FunConcat);
  ADExpressionRegisterFunc('INITCAP',   ckUnknown, 0, dtUnknown,  0, 1, 1, @FunInitCap);
  ADExpressionRegisterFunc('LPAD',      ckUnknown, 0, dtUnknown,  0, 2, 3, @FunLPad);
  ADExpressionRegisterFunc('LTRIM',     ckUnknown, 0, dtUnknown,  0, 1, 2, @FunTrimLeft);
  ADExpressionRegisterFunc('REPLACE',   ckUnknown, 0, dtUnknown,  0, 2, 3, @FunReplace);
  ADExpressionRegisterFunc('RPAD',      ckUnknown, 0, dtUnknown,  0, 2, 3, @FunRPad);
  ADExpressionRegisterFunc('RTRIM',     ckUnknown, 0, dtUnknown,  0, 1, 2, @FunTrimRight);
{$IFDEF AnyDAC_D6Base}
  ADExpressionRegisterFunc('SOUNDEX',   ckUnknown, 0, dtAnsiString,  -1, 1, 1, @FunSoundex);
{$ENDIF}
  ADExpressionRegisterFunc('SUBSTR',    ckUnknown, 0, dtUnknown,  0, 2, 3, @FunSubstring);
  ADExpressionRegisterFunc('TRANSLATE', ckUnknown, 0, dtUnknown,  0, 3, 3, @FunTranslate);
  // Strings, result integer
  ADExpressionRegisterFunc('ASCII',     ckUnknown, 0, dtInt32, -1, 1, 1, @FunAscii);
  ADExpressionRegisterFunc('INSTR',     ckUnknown, 0, dtInt32, -1, 2, 4, @FunInstr);
  ADExpressionRegisterFunc('LENGTH',    ckUnknown, 0, dtInt32, -1, 1, 1, @FunLength);
  // Date
  ADExpressionRegisterFunc('ADD_MONTHS',ckUnknown, 0, dtDateTime, -1, 2, 2, @FunAddMonths);
  ADExpressionRegisterFunc('MONTHS_BETWEEN',
                                        ckUnknown, 0, dtInt32, -1, 2, 2,    @FunMonthsBW);
  ADExpressionRegisterFunc('LAST_DAY',  ckUnknown, 0, dtDateTime, -1, 1, 1, @FunLastDay);
  ADExpressionRegisterFunc('FIRST_DAY', ckUnknown, 0, dtDateTime, -1, 1, 1, @FunFirstDay);
  ADExpressionRegisterFunc('NEXT_DAY',  ckUnknown, 0, dtDateTime, -1, 2, 2, @FunNextDay);
  ADExpressionRegisterFunc('SYSDATE',   ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetDate);
  // Convert
  ADExpressionRegisterFunc('TO_CHAR',   ckUnknown, 0, dtAnsiString,  -1, 1, 2, @FunToChar);
  ADExpressionRegisterFunc('TO_DATE',   ckUnknown, 0, dtDateTime, -1, 1, 2,    @FunToDate);
  ADExpressionRegisterFunc('TO_NUMBER', ckUnknown, 0, dtDouble,  -1, 1, 2,     @FunToNumber);
  // Others
  ADExpressionRegisterFunc('DECODE',    ckUnknown, 2, dtUnknown,  2, 3, MAXINT, @FunDecode);
  ADExpressionRegisterFunc('IIF',       ckUnknown, 1, dtUnknown,  1, 3, 3,      @FunIIF);
  ADExpressionRegisterFunc('IF',        ckUnknown, 1, dtUnknown,  1, 3, 3,      @FunIIF);
  ADExpressionRegisterFunc('NVL',       ckUnknown, 0, dtUnknown,  0, 2, 2,      @FunNvl);
  ADExpressionRegisterFunc('GREATEST',  ckUnknown, 0, dtUnknown,  0, 1, MAXINT, @FunGreatest);
  ADExpressionRegisterFunc('LEAST',     ckUnknown, 0, dtUnknown,  0, 1, MAXINT, @FunLeast);
  // Used in semi-natural language
  ADExpressionRegisterFunc('TODAY',     ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetDate);
{$IFDEF AnyDAC_REGEXP}
  // Regular expressions
  ADExpressionRegisterFunc('REGEXP_LIKE',
                                        ckUnknown, 0, dtBoolean, -1, 2, 2, @FunRegExpLike);
{$ENDIF}

  // ---------------------------------------------
  // ODBC escape funcs
  // + ASCII
  // x BIT_LENGTH
  ADExpressionRegisterFunc('CHAR',             ckUnknown, 0, dtAnsiString,  -1, 1, 1, @FunChr);
  ADExpressionRegisterFunc('CHAR_LENGTH',      ckUnknown, 0, dtInt32, -1, 1, 1, @FunLength);
  ADExpressionRegisterFunc('CHARACTER_LENGTH', ckUnknown, 0, dtInt32, -1, 1, 1, @FunLength);
  // + CONCAT
{$IFDEF AnyDAC_D6Base}
  // - DIFFERENCE
  ADExpressionRegisterFunc('DIFFERENCE',       ckUnknown, 0, dtInt16,  -1, 2, 2, @FunDiff);
{$ENDIF}  
  // - INSERT
  ADExpressionRegisterFunc('INSERT',           ckUnknown, 0, dtAnsiString,  -1, 4, 4, @FunInsert);
  ADExpressionRegisterFunc('LCASE',            ckUnknown, 0, dtUnknown,  0, 1, 1, @FunLower);
  // - LEFT
  ADExpressionRegisterFunc('LEFT',             ckUnknown, 0, dtAnsiString,  -1, 2, 2, @FunLeft);
  // + LENGTH
  // - LOCATE
  ADExpressionRegisterFunc('LOCATE',           ckUnknown, 0, dtInt32, -1, 2, 3, @FunLocate);
  // + LTRIM
  // - OCTET_LENGTH
  ADExpressionRegisterFunc('OCTET_LENGTH',     ckUnknown, 0, dtInt16,  -1, 1, 1, @FunOCTLen);
  // - POSITION
  ADExpressionRegisterFunc('POSITION',         ckUnknown, 0, dtInt32,  -1, 2, 2, @FunPos);
  // - REPEAT
  ADExpressionRegisterFunc('REPEAT',           ckUnknown, 0, dtAnsiString,  -1, 2, 2, @FunRepeat);
  // + REPLACE
  // - RIGHT
  ADExpressionRegisterFunc('RIGHT',            ckUnknown, 0, dtAnsiString,  -1, 2, 2, @FunRight);
  // + RTRIM
  // + SOUNDEX
  // - SPACE
  ADExpressionRegisterFunc('SPACE',            ckUnknown, 0, dtAnsiString,  -1, 1, 1, @FunSpace);
  // + SUBSTRING
  ADExpressionRegisterFunc('UCASE',            ckUnknown, 0, dtUnknown,  0, 1, 1, @FunUpper);
  // + ABS
  // - ACOS
  ADExpressionRegisterFunc('ACOS',             ckUnknown, 0, dtDouble,  -1, 1, 1, @FunACos);
  // - ASIN
  ADExpressionRegisterFunc('ASIN',             ckUnknown, 0, dtDouble,  -1, 1, 1, @FunASin);
  // - ATAN
  ADExpressionRegisterFunc('ATAN',             ckUnknown, 0, dtDouble,  -1, 1, 1, @FunATan);
  // - ATAN2
  ADExpressionRegisterFunc('ATAN2',            ckUnknown, 0, dtDouble,  -1, 2, 2, @FunATan2);
  ADExpressionRegisterFunc('CEILING',          ckUnknown, 0, dtInt32, -1, 1, 1,   @FunCeil);
  // + COS
  // - COT
  ADExpressionRegisterFunc('COT',              ckUnknown, 0, dtDouble,  -1, 1, 1, @FunCot);
  // - ADGREES
  ADExpressionRegisterFunc('DEGREES',          ckUnknown, 0, dtDouble,  -1, 1, 1, @FunDegrees);
  // + EXP
  // + FLOOR
  // + LOG
  // - LOG10
  ADExpressionRegisterFunc('LOG10',            ckUnknown, 0, dtDouble,  -1, 1, 1, @FunLog10);
  // + MOD
  // - PI
  ADExpressionRegisterFunc('PI',               ckConst, 0, dtDouble,  -1, 0, 0,   @FunPi);
  // + POWER
  // - RADIANS
  ADExpressionRegisterFunc('RADIANS',          ckUnknown, 0, dtDouble,  -1, 1, 1, @FunRadians);
  // - RAND
  Randomize;
  ADExpressionRegisterFunc('RAND',             ckUnknown, 0, dtUnknown,  0, 0, 2, @FunRand);   //??????
  // + ROUND
  // + SIGN
  // + SIN
  // + SQRT
  // + TAN
  ADExpressionRegisterFunc('TRUNCATE',         ckUnknown, 0, dtDouble,  -1, 1, 2, @FunTrunc);
  // - CURRENT_DATE
  ADExpressionRegisterFunc('CURRENT_DATE',     ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetCurDate);
  // - CURRENT_TIME
  ADExpressionRegisterFunc('CURRENT_TIME',     ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetTime);
  // - CURRENT_TIMESTAMP
  ADExpressionRegisterFunc('CURRENT_TIMESTAMP',
                                               ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetDate);
  ADExpressionRegisterFunc('CURDATE',          ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetCurDate);
  ADExpressionRegisterFunc('CURTIME',          ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetTime);
  // - DAYNAME
  ADExpressionRegisterFunc('DAYNAME',          ckUnknown,  0, dtAnsiString, -1, 1, 1, @FunDayName);
  ADExpressionRegisterFunc('DAYOFMONTH',       ckUnknown,  0, dtInt16, -1, 1, 1, @FunDay);
  // - DAYOFWEEK
  ADExpressionRegisterFunc('DAYOFWEEK',        ckUnknown,  0, dtInt16, -1, 1, 1, @FunDayOfWeek);
  // - DAYOFYEAR
  ADExpressionRegisterFunc('DAYOFYEAR',        ckUnknown,  0, dtInt16, -1, 1, 1, @FunDayOfYear);
  // - EXTRACT
  ADExpressionRegisterFunc('EXTRACT',          ckUnknown,  0, dtInt32, -1, 2, 2, @FunExtract);
  // + HOUR
  // + MINUTE
  // + MONTH
  // - MONTHNAME
  ADExpressionRegisterFunc('MONTHNAME',        ckUnknown,  0, dtAnsiString, -1, 1, 1, @FunMonthName);
  ADExpressionRegisterFunc('NOW',              ckConst,  -1, dtDateTime, -1, 0, 0, @FunGetDate);
  // - QUARTER
  ADExpressionRegisterFunc('QUARTER',          ckUnknown,  0, dtInt16, -1, 1, 1, @FunQuarter);
  // + SECOND
  // - TIMESTAMPADD
  ADExpressionRegisterFunc('TIMESTAMPADD',     ckUnknown,  0, dtDateTime, -1, 3, 3, @FunTimeStampAdd);
  // - TIMESTAMPDIFF
  ADExpressionRegisterFunc('TIMESTAMPDIFF',    ckUnknown,  0, dtInt32, -1, 3, 3, @FunTimeStampDiff);
  // - WEEK
  ADExpressionRegisterFunc('WEEK',             ckUnknown,  0, dtInt16, -1, 1, 1, @FunWeek);
  // + YEAR
  // - DATABASE
  // ADExpressionRegisterFunc('DATABASE',         ckConst,  -1, dtAnsiString, -1, 0, 0, @FunDatabase);
  ADExpressionRegisterFunc('IFNULL',           ckUnknown,  0, dtUnknown, 0, 2, 2, @FunNvl);
  // - USER
  // ADExpressionRegisterFunc('USER',             ckConst,  -1, dtAnsiString, -1, 0, 0, @FunUser);
  // - CONVERT
  ADExpressionRegisterFunc('CONVERT',          ckUnknown,  0, dtUnknown, -1, 2, 2, @FunConvert); //?????

end;

{-------------------------------------------------------------------------------}
initialization
  AllocFuncs;
  TADMultyInstanceFactory.Create(TADExpressionParser, IADStanExpressionParser);

finalization
  FreeFuncs;

end.
