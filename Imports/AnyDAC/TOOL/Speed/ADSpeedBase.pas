{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - base classes                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ADSpeed.inc}

unit ADSpeedBase;

interface

uses
  Windows, SysUtils, Classes, DB;

type
  TADSpeedCustomDataSetTest = class;
  TADSpeedCustomDataSet = class;
  TADSpeedTestManager = class;

  {---------------------------------------------------------------------------}
  { TADSpeedCustomDataSetTest                                                 }
  {---------------------------------------------------------------------------}
  TADSpeedProgressEvent = procedure (ATest: TADSpeedCustomDataSetTest) of object;
  TADSpeedCustomDataSetTest = class(TObject)
  private
    FPerfCounterPerSec: TLargeInteger;
    FPerfCounter: TLargeInteger;
    FTimes: Integer;
    FError: String;
    FTestingDataSet: TADSpeedCustomDataSet;
    FStep: Integer;
    function GetTime: Double;
    procedure SetTime(const AValue: Double);
    function GetTimeStr: String;
    procedure SetError(const AValue: String);
  protected
    procedure InternalExecute; virtual; abstract;
    procedure InternalPrepareStep; virtual;
    procedure InternalPrepare; virtual;
    procedure InternalUnPrepare; virtual;
    procedure SetTestingDataSet(ADataSet: TADSpeedCustomDataSet); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Execute(AProgressEvent: TADSpeedProgressEvent);
    class function GetName: String; virtual; abstract;
    class function GetDescription: String; virtual;
    property Time: Double read GetTime write SetTime;
    property TimeStr: string read GetTimeStr;
    property Step: Integer read FStep;
    property Times: Integer read FTimes write FTimes;
    property Error: String read FError write SetError;
    property TestingDataSet: TADSpeedCustomDataSet read FTestingDataSet write SetTestingDataSet;
  end;
  TADSpeedCustomDataSetTestClass = class of TADSpeedCustomDataSetTest;

  {---------------------------------------------------------------------------}
  { TADSpeedCustomDataSet                                                     }
  {---------------------------------------------------------------------------}
  TADSpeedCustomDataSet = class(TObject)
  private
    FDataSet: TDataSet;
  public
    constructor Create; virtual;
    procedure BeginBatch(AWithDelete: Boolean); virtual;
    procedure EndBatch; virtual;
    class function GetName: String; virtual; abstract;
    class function GetDescription: String; virtual;
    class function GetCanExecute: Boolean; virtual;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;
  TADSpeedCustomDataSetClass = class of TADSpeedCustomDataSet;

  {---------------------------------------------------------------------------}
  { TADSpeedTestManager                                                       }
  {---------------------------------------------------------------------------}
  TADSpeedTestStartEvent = procedure (AManager: TADSpeedTestManager) of object;
  TADSpeedTestProgressEvent = procedure (AManager: TADSpeedTestManager;
    ATest: TADSpeedCustomDataSetTest; APctDone: Integer) of object;
  TADSpeedTestEndEvent = procedure (AManager: TADSpeedTestManager) of object;
  TADSpeedTestErrorEvent = procedure (AManager: TADSpeedTestManager; E: Exception) of object;
  TADSpeedTestTestEvent = procedure (AManager: TADSpeedTestManager;
    ADSInd, ATestInd: Integer) of Object;
  TADSpeedTestManager = class(TObject)
  private
    FTestClassList: TList;
    FDSClassList: TList;
    FTests: TList;
    FTestCountList: TList;
    FExclusions: TStringList;
    FOnStart: TADSpeedTestStartEvent;
    FOnProgress: TADSpeedTestProgressEvent;
    FOnError: TADSpeedTestErrorEvent;
    FOnEnd: TADSpeedTestEndEvent;
    FStep, FTotal: Integer;
    FIsRunning: Boolean;
    FCanceled: Boolean;
    FAfterTest: TADSpeedTestTestEvent;
    FBeforeTest: TADSpeedTestTestEvent;
    function GetDSClass(AIndex: Integer): TADSpeedCustomDataSetClass;
    function GetDSCount: Integer;
    function GetTestClass(AIndex: Integer): TADSpeedCustomDataSetTestClass;
    function GetTestCount: Integer;
    function GetTests(ADSInd, ATestInd: Integer): TADSpeedCustomDataSetTest;
    procedure DoProgress(ATest: TADSpeedCustomDataSetTest);
    function GetTestTimes(AIndex: Integer): Integer;
    procedure SetTestTimes(AIndex: Integer; ATimes: Integer);
  protected
    FShareDataSets: Boolean;
    procedure SetupDataSet(ADS: TADSpeedCustomDataSet; ADataSetIndex: Integer); virtual;
    function GetIsValid: Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearTests;
    procedure AllocTests;
    procedure RegisterTest(ATest: TADSpeedCustomDataSetTestClass; ADefTimes: Integer); virtual;
    procedure RegisterDS(ADS: TADSpeedCustomDataSetClass); virtual;
    procedure ExcludeTest(ATest: TADSpeedCustomDataSetTestClass; daADS: TADSpeedCustomDataSetClass);
    procedure Execute(ATest: TADSpeedCustomDataSetTestClass; ADS: TADSpeedCustomDataSetClass);
    function IndexOfTest(ATest: TADSpeedCustomDataSetTestClass): Integer; overload;
    function IndexOfDS(ADS: TADSpeedCustomDataSetClass): Integer; overload;
    function IndexOfTest(const ATestName: String): Integer; overload;
    function IndexOfDS(const ADSName: String): Integer; overload;
    procedure Cancel;
    property DSCount: Integer read GetDSCount;
    property TestCount: Integer read GetTestCount;
    property DSClass[AIndex: Integer]: TADSpeedCustomDataSetClass read GetDSClass;
    property TestClass[AIndex: Integer]: TADSpeedCustomDataSetTestClass read GetTestClass;
    property TestTimes[AIndex: Integer]: Integer read GetTestTimes write SetTestTimes;
    property Tests[ADSInd, ATestInd: Integer]: TADSpeedCustomDataSetTest read GetTests;
    property IsRunning: Boolean read FIsRunning;
    property IsValid: Boolean read GetIsValid;
    property BeforeTest: TADSpeedTestTestEvent read FBeforeTest write FBeforeTest;
    property AfterTest: TADSpeedTestTestEvent read FAfterTest write FAfterTest;
    property OnStart: TADSpeedTestStartEvent read FOnStart write FOnStart;
    property OnProgress: TADSpeedTestProgressEvent read FOnProgress write FOnProgress;
    property OnError: TADSpeedTestErrorEvent read FOnError write FOnError;
    property OnEnd: TADSpeedTestEndEvent read FOnEnd write FOnEnd;
  end;

  TADSpeedRegister = function(): TADSpeedTestManager;
  TADSpeedUnRegister = procedure();

var
  ADSpeedRegister: TADSpeedRegister = nil;
  ADSpeedUnregister: TADSpeedUnRegister = nil;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedCustomDataSetTest                                                 }
{---------------------------------------------------------------------------}
constructor TADSpeedCustomDataSetTest.Create;
begin
  inherited Create;
  QueryPerformanceFrequency(FPerfCounterPerSec);
  FTimes := 1;
  FPerfCounter := 0;
  FError := '';
end;

{---------------------------------------------------------------------------}
destructor TADSpeedCustomDataSetTest.Destroy;
begin
  FTestingDataSet := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
class function TADSpeedCustomDataSetTest.GetDescription: String;
begin
  Result := '';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.Execute(AProgressEvent: TADSpeedProgressEvent);
var
  i: Integer;
  C1, C2: TLargeInteger;
begin
  FPerfCounter := 0;
  FError := '';
  try
    InternalPrepare;
    try
      for i := 1 to FTimes do begin
        FStep := i;
        InternalPrepareStep;
        QueryPerformanceCounter(C1);
        InternalExecute;
        QueryPerformanceCounter(C2);
        FPerfCounter := FPerfCounter + (C2 - C1);
        if Assigned(AProgressEvent) then
          AProgressEvent(Self);
      end;
    finally
      InternalUnPrepare;
    end;
  except
    on E: Exception do begin
      FPerfCounter := -1;
      FError := E.ClassName + ': ' + E.Message;
    end;
  end;
end;

{---------------------------------------------------------------------------}
function TADSpeedCustomDataSetTest.GetTime: Double;
begin
  if FPerfCounter = -1 then
    Result := 0
  else
    Result := FPerfCounter / FPerfCounterPerSec;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.SetTime(const AValue: Double);
begin
  FPerfCounter := Trunc(AValue * FPerfCounterPerSec);
end;

{---------------------------------------------------------------------------}
function TADSpeedCustomDataSetTest.GetTimeStr: String;
begin
  if FPerfCounter = -1 then
    if FError = '' then
      Result := '<failed>'
    else
      Result := FError
  else if FPerfCounter <> 0 then
    Result := FormatFloat('0.0000', Time)
  else
    Result := '';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.SetError(const AValue: String);
begin
  FError := AValue;
  if FError <> '' then
    FPerfCounter := -1;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.InternalPrepareStep;
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.InternalPrepare;
begin
  with FTestingDataSet.DataSet do
    DisableControls;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.InternalUnPrepare;
begin
  with FTestingDataSet.DataSet do
    EnableControls;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSetTest.SetTestingDataSet(ADataSet: TADSpeedCustomDataSet);
begin
  FTestingDataSet := ADataSet;
end;

{---------------------------------------------------------------------------}
{ TADSpeedCustomDataSet                                                     }
{---------------------------------------------------------------------------}
constructor TADSpeedCustomDataSet.Create;
begin
  inherited Create;
  FDataSet := nil;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSet.BeginBatch(AWithDelete: Boolean);
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDataSet.EndBatch;
begin
  // nothing
end;

{---------------------------------------------------------------------------}
class function TADSpeedCustomDataSet.GetDescription: String;
begin
  Result := '';
end;

{---------------------------------------------------------------------------}
class function TADSpeedCustomDataSet.GetCanExecute: Boolean;
begin
  Result := True;
end;

{---------------------------------------------------------------------------}
{ TADSpeedTestManager                                                       }
{---------------------------------------------------------------------------}
constructor TADSpeedTestManager.Create;
begin
  inherited Create;
  FTestClassList := TList.Create;
  FDSClassList := TList.Create;
  FTests := TList.Create;
  FExclusions := TStringList.Create;
  FExclusions.Sorted := True;
  FExclusions.Duplicates := dupError;
  FTestCountList := TList.Create;
end;

{---------------------------------------------------------------------------}
destructor TADSpeedTestManager.Destroy;
begin
  ClearTests;
  FTestClassList.Free;
  FTestClassList := nil;
  FDSClassList.Free;
  FDSClassList := nil;
  FTests.Free;
  FTests := nil;
  FExclusions.Free;
  FExclusions := nil;
  FTestCountList.Free;
  FTestCountList := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.SetupDataSet(ADS: TADSpeedCustomDataSet;
  ADataSetIndex: Integer);
begin
  // nothing
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetIsValid: Boolean;
begin
  // nothing
  Result := True;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.AllocTests;
var
  i, j: Integer;
  oTest: TADSpeedCustomDataSetTest;
  oDS: TADSpeedCustomDataSet;
begin
  if FTests.Count > 0 then
    Exit;
  for i := 0 to DSCount - 1 do begin
    if FShareDataSets then begin
      oDS := DSClass[i].Create;
      SetupDataSet(oDS, i);
    end
    else
      oDS := nil;
    for j := 0 to TestCount - 1 do begin
      if FExclusions.IndexOf(TestClass[j].ClassName + '$' + DSClass[i].ClassName) <> -1 then
        FTests.Add(nil)
      else begin
        oTest := TestClass[j].Create;
        oTest.Times := TestTimes[j];
        if not FShareDataSets then begin
          oDS := DSClass[i].Create;
          SetupDataSet(oDS, i);
        end;
        oTest.TestingDataSet := oDS;
        FTests.Add(oTest);
      end;
    end;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.ClearTests;
var
  i: Integer;
  oDataSets: TList;
begin
  oDataSets := TList.Create;
  try
    for i := 0 to FTests.Count - 1 do
      if FTests[i] <> nil then begin
        if oDataSets.IndexOf(TADSpeedCustomDataSetTest(FTests[i]).TestingDataSet) = -1 then
          oDataSets.Add(TADSpeedCustomDataSetTest(FTests[i]).TestingDataSet);
        TADSpeedCustomDataSetTest(FTests[i]).Free;
      end;
    FTests.Clear;
    for i := 0 to oDataSets.Count - 1 do
      TADSpeedCustomDataSet(oDataSets[i]).Free;
  finally
    oDataSets.Free;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.ExcludeTest(
  ATest: TADSpeedCustomDataSetTestClass;
  daADS: TADSpeedCustomDataSetClass);
begin
  FExclusions.Add(ATest.ClassName + '$' + daADS.ClassName);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.RegisterDS(ADS: TADSpeedCustomDataSetClass);
begin
  FDSClassList.Add(ADS);
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.IndexOfDS(ADS: TADSpeedCustomDataSetClass): Integer;
begin
  Result := FDSClassList.IndexOf(ADS);
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.IndexOfDS(const ADSName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to DSCount - 1 do
    if CompareText(DSClass[i].GetName, ADSName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetDSCount: Integer;
begin
  Result := FDSClassList.Count;
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetDSClass(AIndex: Integer): TADSpeedCustomDataSetClass;
begin
  Result := TADSpeedCustomDataSetClass(FDSClassList[AIndex]);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.RegisterTest(ATest: TADSpeedCustomDataSetTestClass;
  ADefTimes: Integer);
begin
  FTestClassList.Add(ATest);
  FTestCountList.Add(Pointer(ADefTimes));
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.IndexOfTest(ATest: TADSpeedCustomDataSetTestClass): Integer;
begin
  Result := FTestClassList.IndexOf(ATest);
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.IndexOfTest(const ATestName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to TestCount - 1 do
    if CompareText(TestClass[i].GetName, ATestName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetTestCount: Integer;
begin
  Result := FTestClassList.Count;
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetTestClass(AIndex: Integer): TADSpeedCustomDataSetTestClass;
begin
  Result := TADSpeedCustomDataSetTestClass(FTestClassList[AIndex]);
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetTestTimes(AIndex: Integer): Integer;
begin
  Result := Integer(FTestCountList[AIndex]);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.SetTestTimes(AIndex: Integer; ATimes: Integer);
var
  i: Integer;
begin
  FTestCountList[AIndex] := TObject(ATimes);
  if FTests.Count > 0 then
    for i := 0 to DSCount - 1 do begin
      if Tests[i, AIndex] <> nil then
        Tests[i, AIndex].Times := ATimes;
    end;
end;

{---------------------------------------------------------------------------}
function TADSpeedTestManager.GetTests(ADSInd, ATestInd: Integer): TADSpeedCustomDataSetTest;
begin
  Result := TADSpeedCustomDataSetTest(FTests[TestCount * ADSInd + ATestInd]);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.DoProgress(ATest: TADSpeedCustomDataSetTest);
begin
  if MulDiv(FStep, 100, FTotal) <> MulDiv(FStep + 1, 100, FTotal) then begin
    Inc(FStep);
    if Assigned(FOnProgress) then
      FOnProgress(Self, ATest, MulDiv(FStep, 100, FTotal));
  end
  else
    Inc(FStep);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.Execute(ATest: TADSpeedCustomDataSetTestClass;
  ADS: TADSpeedCustomDataSetClass);
var
  i, j, i1, i2, j1, j2: Integer;
  oTest: TADSpeedCustomDataSetTest;
begin
  if FIsRunning then
    Exit;
  FIsRunning := True;
  FCanceled := False;
  try
    AllocTests;
    FTotal := 0;
    if ADS <> nil then begin
      i1 := IndexOfDS(ADS);
      i2 := i1;
    end
    else begin
      i1 := 0;
      i2 := DSCount - 1;
    end;
    if ATest <> nil then begin
      j1 := IndexOfTest(ATest);
      j2 := j1;
    end
    else begin
      j1 := 0;
      j2 := TestCount - 1;
    end;
    for i := i1 to i2 do
      for j := j1 to j2 do begin
        oTest := Tests[i, j];
        if oTest <> nil then
          FTotal := FTotal + oTest.Times;
      end;
    FStep := 0;
    if Assigned(FOnStart) then
      FOnStart(Self);
    for i := i1 to i2 do begin
      if FCanceled then
        Break;
      for j := j1 to j2 do begin
        if FCanceled then
          Break;
        oTest := Tests[i, j];
        if oTest <> nil then
          try
            if Assigned(FBeforeTest) then
              FBeforeTest(Self, i, j);
            try
              oTest.Execute(DoProgress);
            finally
              if Assigned(FAfterTest) then
                FAfterTest(Self, i, j);
            end;
          except
            on E: Exception do
              if Assigned(FOnError) then
                FOnError(Self, E);
          end;
      end;
    end;
    if Assigned(FOnEnd) then
      FOnEnd(Self);
  finally
    FIsRunning := False;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedTestManager.Cancel;
begin
  FCanceled := True;
end;

end.

