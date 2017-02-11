{-------------------------------------------------------------------------------}
{ AnyDAC Phys Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAPhysLayerCNN;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf;

type
  TADQAPhysTsHolderBase = class (TADQATsHolderBase)
  public
    function RunBeforeTest: Boolean; override;
  end;

  TADQAPhysCNNTsHolder = class (TADQAPhysTsHolderBase)
  public
    procedure RegisterTests; override;
    procedure TestConvertData;
    procedure TestEscapeFuncs;
    procedure TestPhysTransactions;
    // with Stan Layer
    procedure TestConnectionPooling;
  end;

  TADQATsThreadForPooling = class (TThread)
  private
    FConnectionDef: IADStanConnectionDef;
    FCounter: TADQATsThreadCounter;
    FConnection: IADPhysConnection;
    FCommand: IADPhysCommand;
  public
    constructor Create(AConnectionDef: IADStanConnectionDef; ACounter: TADQATsThreadCounter);
    procedure Execute; override;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}  
  Math,
  ADQAConst, ADQAUtils, ADQAEvalFuncs, ADQAVarField,
  daADStanUtil, daADStanConst, daADStanError;

{-------------------------------------------------------------------------------}
{ TADQAPhysTsHolderBase                                                         }
{-------------------------------------------------------------------------------}
function TADQAPhysTsHolderBase.RunBeforeTest: Boolean;
begin
  Result := inherited RunBeforeTest;
  if (FRDBMSKind <> mkUnknown) and Result then
    Result := ConnectionSwitch;
end;

{-------------------------------------------------------------------------------}
{ TADQAPhysTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQAPhysCNNTsHolder.RegisterTests;
begin
  RegisterTest('FormatOptions; Convert data',  TestConvertData, mkUnknown, False);
  RegisterTest('Transactions;DB2',             TestPhysTransactions, mkDB2, False);
  RegisterTest('Transactions;MS Access',       TestPhysTransactions, mkMSAccess, False);
  RegisterTest('Transactions;MSSQL',           TestPhysTransactions, mkMSSQL, False);
  RegisterTest('Transactions;ASA',             TestPhysTransactions, mkASA, False);
  RegisterTest('Transactions;MySQL',           TestPhysTransactions, mkMySQL, False);
  RegisterTest('Transactions;Oracle',          TestPhysTransactions, mkOracle, False);
  RegisterTest('Escape functions;DB2',         TestEscapeFuncs, mkDB2);
  RegisterTest('Escape functions;MS Access',   TestEscapeFuncs, mkMSAccess);
  RegisterTest('Escape functions;MSSQL',       TestEscapeFuncs, mkMSSQL);
  RegisterTest('Escape functions;ASA',         TestEscapeFuncs, mkASA);
  RegisterTest('Escape functions;MySQL',       TestEscapeFuncs, mkMySQL);
  RegisterTest('Escape functions;Oracle',      TestEscapeFuncs, mkOracle);
  RegisterTest('Connection pooling;DB2',       TestConnectionPooling, mkDB2, False);
  RegisterTest('Connection pooling;MS Access', TestConnectionPooling, mkMSAccess, False);
  RegisterTest('Connection pooling;MSSQL',     TestConnectionPooling, mkMSSQL, False);
  RegisterTest('Connection pooling;ASA',       TestConnectionPooling, mkASA, False);
  RegisterTest('Connection pooling;MySQL',     TestConnectionPooling, mkMySQL, False);
  RegisterTest('Connection pooling;Oracle',    TestConnectionPooling, mkOracle, False);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCNNTsHolder.TestConvertData;
var
  eSrc, eDest:    TADDataType;
  oFormatOptions: TADFormatOptions;
  pSrc, pDest,
  pSave:          Pointer;
  V1, V2:         Variant;
  lwDestSize:     LongWord;
  bSrc_dtByte:    Byte;          // dtByte
  bSrc_dtSByte:   ShortInt;      // dtSByte
  iSrc_dtInt16:   SmallInt;      // dtInt16
  iSrc_dtInt32:   Integer;       // dtInt32
  iSrc_dtInt64:   Int64;         // dtInt64
  wSrc_dtUInt16:  Word;          // dtUInt16
  lwSrc_dtUInt32: LongWord;      // dtUInt32
  iSrc_dtUInt64:  Int64;         // dtUInt64
  rSrc_dtDouble:  Double;        // dtDouble
  rSrc_dtCurrency:Currency;      // dtCurrency
  rSrc_dtBCD:     TBcd;          // dtBCD, dtFmtBCD

  function ConvertData(var ApDest: Pointer; ASrcType,
      daADestType: TADDataType): Boolean;
  begin
    Result := True;
    case ASrcType of
    dtByte:     pSrc := @bSrc_dtByte;
    dtSByte:    pSrc := @bSrc_dtSByte;
    dtInt16:    pSrc := @iSrc_dtInt16;
    dtInt32:    pSrc := @iSrc_dtInt32;
    dtInt64:    pSrc := @iSrc_dtInt64;
    dtUInt16:   pSrc := @wSrc_dtUInt16;
    dtUInt32:   pSrc := @lwSrc_dtUInt32;
    dtUInt64:   pSrc := @iSrc_dtUInt64;
    dtDouble:   pSrc := @rSrc_dtDouble;
    dtCurrency: pSrc := @rSrc_dtCurrency;
    dtBCD,
    dtFmtBCD:   pSrc := @rSrc_dtBCD;
    else
      begin
        Result := False;
        Exit;
      end;
    end;
    // The pointers pSrc and pDest must be unequal!!!
    // But if i send to ConvertRawData equal ASrcType and daADestType (for ex. dtSByte) - after
    // proc. executing i get ApDest = ApSrc. Then at the next time if i send into the procedure the equal ApSrc and ApDest -
    // it is memory collision
    oFormatOptions.ConvertRawData(ASrcType, daADestType, pSrc, 0,
                                  ApDest, 0, lwDestSize);
  end;

  function GetTypeSize(AType: TADDataType): Integer;
  begin
    case AType of
    dtByte:     Result := SizeOf(Byte);
    dtSByte:    Result := SizeOf(ShortInt);
    dtInt16:    Result := SizeOf(SmallInt);
    dtInt32:    Result := SizeOf(Integer);
    dtInt64:    Result := SizeOf(Int64);
    dtUInt16:   Result := SizeOf(Word);
    dtUInt32:   Result := SizeOf(LongWord);
    dtUInt64:   Result := SizeOf(Int64);
    dtDouble:   Result := SizeOf(Double);
    dtCurrency: Result := SizeOf(Currency);
    dtBCD,
    dtFmtBCD:   Result := SizeOf(TBcd);
    else        Result := -1;
    end;
  end;

  function GetValue(APointer: Pointer; AType: TADDataType): Variant;
{$IFNDEF AnyDAC_D6}
  var
    cr: Currency;
{$ENDIF}
  begin
    ASSERT(APointer <> nil);
    case AType of
    dtByte:     Result := PByte(APointer)^;
    dtSByte:    Result := PShortInt(APointer)^;
    dtInt16:    Result := PSmallInt(APointer)^;
    dtInt32:    Result := PInteger(APointer)^;
{$IFDEF AnyDAC_D6}
    dtInt64:    Result := PInt64(APointer)^;
{$ELSE}
    dtInt64:
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := PInt64(APointer)^;
      end;
{$ENDIF}
    dtUInt16:   Result := PWord(APointer)^;
{$IFDEF AnyDAC_D6}
    dtUInt32:   Result := PLongWord(APointer)^;
    dtUInt64:   Result := PUInt64(APointer)^;
{$ELSE}
    dtUInt32:   Result := PInteger(APointer)^;
    dtUInt64:
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := PUInt64(APointer)^;
      end;
{$ENDIF}
    dtDouble:   Result := PDouble(APointer)^;
    dtCurrency: Result := PCurrency(APointer)^;
{$IFDEF AnyDAC_D6}
    dtBCD,
    dtFmtBCD:   Result := VarFMTBcdCreate(PBcd(APointer)^);
{$ELSE}
    dtBCD,
    dtFmtBCD:
      begin
        BCDToCurr(PBcd(APointer)^, cr);
        Result := cr;
      end;
{$ENDIF}
    else
      raise Exception.Create(UnsuppType(ADDataTypesNames[AType]));
    end;
  end;

begin
  oFormatOptions := TADFormatOptions.Create(nil);
  try
    for eDest := Low(TADDataType) to High(TADDataType) do begin
      case eDest of
      dtUnknown,
      dtBoolean,
      dtDateTime..dtObject:
        continue;
      dtByte,
      dtSByte:
        begin
          bSrc_dtByte    := Byte(C_BYTE);
          bSrc_dtSByte   := ShortInt(C_SBYTE);
          iSrc_dtInt16   := C_BYTE;
          iSrc_dtInt32   := C_BYTE;
          iSrc_dtInt64   := Int64(C_BYTE);
          wSrc_dtUInt16  := C_BYTE;
          lwSrc_dtUInt32 := C_BYTE;
          iSrc_dtUInt64  := Int64(C_BYTE);
          rSrc_dtDouble  := C_BYTE;
          rSrc_dtCurrency:= C_BYTE;
{$IFDEF AnyDAC_D6}
          rSrc_dtBCD     := VarToBcd(C_BYTE);
{$ELSE}
          CurrToBCD(C_BYTE, rSrc_dtBCD);
{$ENDIF}
        end;
      dtInt16,
      dtUInt16:
        begin
          bSrc_dtByte    := Byte(C_BYTE);
          bSrc_dtSByte   := ShortInt(C_SBYTE);
          iSrc_dtInt16   := C_INT16;
          iSrc_dtInt32   := C_INT16;
          iSrc_dtInt64   := Int64(C_INT16);
          wSrc_dtUInt16  := C_INT16;
          lwSrc_dtUInt32 := C_INT16;
          iSrc_dtUInt64  := Int64(C_INT16);
          rSrc_dtDouble  := C_INT16;
          rSrc_dtCurrency:= C_INT16;
{$IFDEF AnyDAC_D6}
          rSrc_dtBCD     := VarToBcd(C_INT16);
{$ELSE}
          CurrToBCD(C_INT16, rSrc_dtBCD);
{$ENDIF}
        end;
      dtInt32,
      dtUInt32:
        begin
          bSrc_dtByte    := Byte(C_BYTE);
          bSrc_dtSByte   := ShortInt(C_SBYTE);
          iSrc_dtInt16   := C_INT16;
          iSrc_dtInt32   := C_INT32;
          iSrc_dtInt64   := Int64(C_INT32);
          wSrc_dtUInt16  := C_UINT16;
          lwSrc_dtUInt32 := C_INT32;
          iSrc_dtUInt64  := Int64(C_INT32);
          rSrc_dtDouble  := C_INT32;
          rSrc_dtCurrency:= C_INT32;
{$IFDEF AnyDAC_D6}
          rSrc_dtBCD     := VarToBcd(C_INT32);
{$ELSE}
          CurrToBCD(C_INT32, rSrc_dtBCD);
{$ENDIF}
        end;
      dtInt64,
      dtUInt64:
        begin
          bSrc_dtByte    := Byte(C_BYTE);
          bSrc_dtSByte   := ShortInt(C_SBYTE);
          iSrc_dtInt16   := C_INT16;
          iSrc_dtInt32   := C_INT32;
          iSrc_dtInt64   := Int64(C_INT64);
          wSrc_dtUInt16  := C_UINT16;
          lwSrc_dtUInt32 := C_INT32;
          iSrc_dtUInt64  := Int64(C_INT64);
          rSrc_dtDouble  := C_INT64;
          rSrc_dtCurrency:= C_INT64;
{$IFDEF AnyDAC_D6}
          rSrc_dtBCD     := VarToBcd(C_INT64);
{$ELSE}
          CurrToBCD(C_INT64, rSrc_dtBCD);
{$ENDIF}
        end;
      dtDouble,
      dtCurrency,
      dtBCD,
      dtFmtBCD:
        begin
          bSrc_dtByte    := Byte(C_BYTE);
          bSrc_dtSByte   := ShortInt(C_SBYTE);
          iSrc_dtInt16   := C_INT16;
          iSrc_dtInt32   := C_INT32;
          iSrc_dtInt64   := Int64(C_INT64);
          wSrc_dtUInt16  := C_UINT16;
          lwSrc_dtUInt32 := C_INT32;
          iSrc_dtUInt64  := Int64(C_INT32);
          rSrc_dtDouble  := C_DOUBLE;
          rSrc_dtCurrency:= C_DOUBLE;
{$IFDEF AnyDAC_D6}
          rSrc_dtBCD     := VarToBcd(C_DOUBLE);
{$ELSE}
          CurrToBCD(C_DOUBLE, rSrc_dtBCD);
{$ENDIF}
        end;
      end;
      for eSrc := Low(TADDataType) to High(TADDataType) do begin
        case eSrc of
        dtUnknown,
        dtBoolean,
        dtDateTime..dtObject: continue;
        end;
        GetMem(pSave, GetTypeSize(eDest));
        pDest := pSave;
        try
          try
            if not ConvertData(pDest, eSrc, eDest) then
              continue;
            // comparing
            V1 := GetValue(pSrc, eSrc);
            V2 := GetValue(pDest, eDest);
            if Compare(V1, V2, ftFloat) <> 0 then
              Error(WrongConvertData(ADDataTypesNames[eSrc], ADDataTypesNames[eDest],
                    VarToStr(V1), VarToStr(V2)));
          except
            on E: Exception do
              Error(WrongConvertData(ADDataTypesNames[eSrc], ADDataTypesNames[eDest],
                E.Message));
          end;
        finally
          FreeMem(pSave);
        end;
      end;
    end;
  finally
    oFormatOptions.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCNNTsHolder.TestConnectionPooling;
var
  oConnectionDef: IADStanConnectionDef;
  iTickTrue,
  iTickFalse: LongWord;

  procedure CreateConnectionDef(APooled: Boolean);
  begin
    OpenPhysManager;
    oConnectionDef := ADPhysManager.ConnectionDefs.AddInternal as IADStanConnectionDef;
    oConnectionDef.ParentDefinition := ADPhysManager.ConnectionDefs.ConnectionDefByName(GetConnectionDef(FRDBMSKind));
    oConnectionDef.Pooled := APooled;
  end;

  function RunThreads: LongWord;
  var
    oCounter: TADQATsThreadCounter;
    i:        Integer;
  begin
    oCounter := TADQATsThreadCounter.Create(C_THREAD_COUNT);
    try
      Result := GetTickCount;
      for i := 0 to C_THREAD_COUNT - 1 do begin
        TADQATsThreadForPooling.Create(oConnectionDef, oCounter);
        Sleep(0);
      end;
      oCounter.Wait;
      Result := GetTickCount - Result;
    finally
      oConnectionDef := nil;
      ADPhysManager.Close(True);
      oCounter.Free;
    end;
  end;

begin
  SetConnectionDefFileName(CONN_DEF_STORAGE);

  CreateConnectionDef(True);
  iTickTrue := RunThreads;
  Trace(C_AD_PhysRDBMSKinds[FRDBMSKind] + ', pooled time = ' + FloatToStr(iTickTrue / 1000) + ' sec');

  CreateConnectionDef(False);
  iTickFalse := RunThreads;
  Trace(C_AD_PhysRDBMSKinds[FRDBMSKind] + ', not pooled time = ' + FloatToStr(iTickFalse / 1000) + ' sec');

  if iTickFalse < iTickTrue then
    Error(PoolingError(iTickFalse, iTickTrue));
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6}
type
  EVariantTypeCastError = EVariantError;
{$ENDIF}

procedure TADQAPhysCNNTsHolder.TestEscapeFuncs;
var
  oTestEvalFuncs: TADQAEvalFuncs;
  s:              String;
  i:              Integer;
  V1, V2:         Variant;

  procedure PrepareTest;
  begin
    oTestEvalFuncs := TADQAEvalFuncs.Create;
    oTestEvalFuncs.InitForPhysLayer;
  end;

  function GetFuncFromServer(AFunc: String): String;
  var
    oTab: TADDatSTable;
  begin
    oTab := FDatSManager.Tables.Add;
    with FCommIntf do begin
      Prepare(Format('select distinct %s from {id Shippers}', [AFunc]));
      Define(oTab);
      Open;
      Fetch(oTab);
    end;
    Result := oTab.Rows[0].GetData(0);
  end;

  procedure PrepareTest2;
  var
    i: Integer;
  begin
    with FCommIntf do begin
      Prepare('delete from {id ADQA_LockTable}');
      Execute;
    end;
    for i := 0 to 9 do
      with FCommIntf do begin
        Prepare(Format('insert into {id ADQA_LockTable}(id, name) values(%d, ''abcde%d'')', [i, i]));
        Execute;
      end;
    for i := 0 to 9 do
      with FCommIntf do begin
        Prepare('insert into {id ADQA_LockTable}(id, name) values(-1, ''abc%de' + IntToStr(i) + ''')');
        Execute;
      end;
  end;

begin
  PrepareTest;
  try
    // 1.
    for i := 0 to oTestEvalFuncs.Count - 1 do
      try
        with oTestEvalFuncs do begin
          s := Format('select distinct {fn %s} from {id Shippers}', [EscFunc[i]]);
          with FCommIntf do begin
            Prepare(s);
            Define(FTab);
            Open;
            Fetch(FTab);
          end;
          V1 := FTab.Rows[0].GetData(0);
          V2 := TrueRes[i];
          if oTestEvalFuncs.ResType[i] = dtUnknown then
            case FRDBMSKind of
            mkMSSQL,
            mkASA:
              begin
                if AnsiCompareText(Copy(EscFunc[i], 1, 3), 'day') = 0 then
                  V2 := GetFuncFromServer('DATENAME(weekday, ''2003/01/01'')')
                else
                  V2 := GetFuncFromServer('DATENAME(month, ''2003/01/01'')');
              end;
            mkMySQL:
              begin
                if AnsiCompareText(Copy(EscFunc[i], 1, 3), 'day') = 0 then
                  V2 := GetFuncFromServer('DAYNAME(''2003/01/01'')')
                else
                  V2 := GetFuncFromServer('MONTHNAME(''2003/01/01'')');
              end;
            mkOracle:
              begin
                if AnsiCompareText(Copy(EscFunc[i], 1, 3), 'day') = 0 then
                  V2 := GetFuncFromServer('RTRIM(TO_CHAR(TO_DATE(''2003-01-01'', ' +
                                          '''YYYY-MM-DD''), ''DAY''))')
                else
                  V2 := GetFuncFromServer('RTRIM(TO_CHAR(TO_DATE(''2003-01-01'', ' +
                                          '''YYYY-MM-DD''), ''MONTH''))');
              end;
            mkDB2:
              begin
                if AnsiCompareText(copy(EscFunc[i], 1, 3), 'day') = 0 then
                  V2 := GetFuncFromServer('DAYNAME({d ''2003-01-01''})')
                else
                  V2 := GetFuncFromServer('MONTHNAME({d ''2003-01-01''})');
              end;
            end;
          if oTestEvalFuncs.ResType[i] <> dtDouble then begin
            if Compare(V1, V2) <> 0 then begin
              Compare(V1, V2);
              Error(EscapeFuncFails(EscFunc[i], V1, V2));
            end;
          end
          else
            if Compare(V1, V2, ftFloat) <> 0 then
              Error(EscapeFuncFails(EscFunc[i], V1, V2));
          FTab.Clear;
        end;
      except
        on E: Exception do begin
          if E is EVariantTypeCastError then
            Error(EscapeFuncFails(oTestEvalFuncs.EscFunc[i], V1, V2))
          else
            Error(oTestEvalFuncs.EscFunc[i] + ' ' + E.Message);
        end;
      end;

    // 2.
    PrepareTest2;
    with FCommIntf do begin
      try
        Prepare('select name from {id ADQA_LockTable} where name like {escape ''\'' ''abc\%%''}');
        Define(FTab);
        Open;
        Fetch(FTab);
      except
        on E: Exception do begin
          Error(E.Message);
          Exit;
        end;
      end;

      if not CheckRowsCount(FTab, 10) then
        Exit;
      for i := 0 to FTab.Rows.Count - 1 do begin
        V1 := FTab.Rows[i].GetData(0);
        V2 := 'abc%de' + IntToStr(i);
        if V1 <> V2 then
          Error(WrongValueInTable('name', i, V1, V2) + '. {escape ''\'' ''abc\%%''}');
      end;
    end;
  finally
    oTestEvalFuncs.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysCNNTsHolder.TestPhysTransactions;
var
  oConn1, oConn2: IADPhysConnection;
  oComm1, oComm2: IADPhysCommand;
  oTab1, oTab2:   TADDatSTable;
  sConnectionDef: String;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    SetConnectionDefFileName(CONN_DEF_STORAGE);
    OpenPhysManager;

    FDatSManager.Reset;

    oTab1 := FDatSManager.Tables.Add;
    oTab2 := FDatSManager.Tables.Add;

    sConnectionDef := GetConnectionDef(FRDBMSKind);
    ADPhysManager.CreateConnection(sConnectionDef, oConn1);
    oConn1.LoginPrompt := False;
    oConn1.Open;
    if FRDBMSKind in [mkMSAccess, mkMSSQL, mkDB2, mkASA] then
      oConn1.TxOptions.Isolation := xiDirtyRead
    else
      oConn1.TxOptions.Isolation := xiReadCommitted;
    if FRDBMSKind = mkMSAccess then
      oConn1.TxOptions.AutoCommit := True;

    oConn1.CreateCommand(oComm1);

    ADPhysManager.CreateConnection(sConnectionDef, oConn2);
    oConn2.LoginPrompt := False;
    oConn2.Open;
    if FRDBMSKind in [mkMSAccess, mkMSSQL, mkDB2, mkASA] then
      oConn2.TxOptions.Isolation := xiDirtyRead
    else
      oConn2.TxOptions.Isolation := xiReadCommitted;
    if FRDBMSKind = mkMSAccess then
      oConn2.TxOptions.AutoCommit := True;

    oConn2.CreateCommand(oComm2);

    oConn1.TxBegin;
    with oComm1 do begin
      Prepare('delete from {id ADQA_TransTable}');
      Execute;
    end;
    for i := 0 to 9 do
      with oComm1 do begin
        Prepare('insert into {id ADQA_TransTable}(id, name) values(' +
                IntToStr(i) + ', ''not changed' + IntToStr(i) + ''')');
        Execute;
      end;
    oConn1.TxCommit;
  end;

begin
  PrepareTest;
  // test
  oConn1.TxBegin;
  if not oConn1.TxIsActive then
    Error(TransIsInactive);
  with oComm1 do begin
    Prepare('update {id ADQA_TransTable} set id = ' + IntToStr(NEW_VAL1) +
            ' where id = ' + IntToStr(3));
    Execute;
  end;
  oConn2.TxBegin;
  if not oConn2.TxIsActive then
    Error(TransIsInactive);
  with oComm2 do begin
    Prepare('update {id ADQA_TransTable} set id = ' + IntToStr(NEW_VAL2) +
            ' where id = ' + IntToStr(4));
    Execute;
  end;
  oConn1.TxCommit;
  if oConn1.TxIsActive then
    Error(TransIsActive);
  RefetchTable('ADQA_TransTable', oTab1, oComm1);
  oConn2.TxCommit;
  if oConn2.TxIsActive then
    Error(TransIsActive);
  RefetchTable('ADQA_TransTable', oTab2, oComm2);

  // analysis
  with oTab1 do begin
    if (Rows[Rows.Count - 1].GetData(0) <> NEW_VAL1) and
       (Rows[Rows.Count - 2].GetData(0) <> NEW_VAL1) then
      Error('#1. ' + ErrorResultTrans);
    if (oConn1.TxOptions.Isolation = xiDirtyRead) and
       (Rows[Rows.Count - 1].GetData(0) <> NEW_VAL2) or
       (oConn1.TxOptions.Isolation <> xiDirtyRead) and
       (Rows[Rows.Count - 1].GetData(0) = NEW_VAL2) then
      Error(ThereIsUnexpRow);
  end;
  with oTab2 do begin
    if (Rows[Rows.Count - 1].GetData(0) <> NEW_VAL1) and
       (Rows[Rows.Count - 2].GetData(0) <> NEW_VAL1) then
      Error('#2. ' + ErrorResultTrans);
    if Rows[Rows.Count - 1].GetData(0) <> NEW_VAL2 then
      Error('#3. ' + ErrorResultTrans);
  end;
end;

{-------------------------------------------------------------------------------}
{  TADQATsThreadForPooling                                                      }
{-------------------------------------------------------------------------------}
constructor TADQATsThreadForPooling.Create(AConnectionDef: IADStanConnectionDef;
      ACounter: TADQATsThreadCounter);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FConnectionDef := AConnectionDef;
  FCounter := ACounter;
  Resume;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsThreadForPooling.Execute;
const
  C_COUNT = 2;
var
  oTab: TADDatSTable;
  i:    Integer;
begin
  try
    ADPhysManager.CreateConnection(FConnectionDef, FConnection);
    FConnection.LoginPrompt := False;
    try
      if FConnection.State = csDisconnected then
        FConnection.Open;
      FConnection.CreateCommand(FCommand);
    except
      Exit;
    end;
    oTab := TADDatSTable.Create;
    try
      for i := 0 to C_COUNT - 1 do
        try
          FCommand.Prepare('select * from {id Shippers}');
          try
            FCommand.Define(oTab);
            FCommand.Open;
            FCommand.Fetch(oTab);
          finally
            FCommand.Unprepare;
          end;
        except
        end;
    finally
      oTab.Free;
    end;
  finally
    FCounter.Decrease;
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Phys Layer', TADQAPhysCNNTsHolder);

end.
