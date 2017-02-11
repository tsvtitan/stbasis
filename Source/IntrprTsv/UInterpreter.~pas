unit UInterpreter;

interface

uses Windows, Messages, Classes, Controls, sysutils, Forms, UMainUnited,
     tsvInterpreterCore, RAI2, RAI2Parser, UMainForm, tsvComCtrls, tsvStdCtrls;

type

  EPrgError=class(ERAI2Error)
  end;

  TInterpreter=class;
  TInterpreterPascal=class;

  TRunTimeForm=class(TfmMainForm)
  private
   FInterpreterPascal: TInterpreterPascal;
  public
   constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
   procedure WndProc(var Message: TMessage); override;
   procedure DoClose(var Action: TCloseAction); override;
   destructor Destroy; override;
  published
    property EnabledAdjust; 
  end;

  TReaderEx=class(TReader)
  public
    property PropName;
  end;

  TInterpreter=class(TObject)
  public
    constructor Create; virtual;
    function Run: Boolean; virtual;
    function Pause: Boolean; virtual;
    function Compile: Boolean; virtual;
    function Reset: Boolean; virtual;
    function TraceInto: Boolean; virtual;
    function StepOver: Boolean; virtual;
  end;

  TPrgParser=class(TRAI2Parser)
  end;
  
  TPrg=class(TRAI2Program)
  public
    function GetMainFunction: TRAI2FunDesc; override; 
    procedure CreateInterface;
    procedure ViewInterface;
    procedure RefreshInterface;
    procedure CloseInterface;
  end;

  TInterpreterPascal=class(TInterpreter)
  private
    Prg: TPrg;
    isDestroy: Boolean;
    isBreakWhile: Boolean;
    IsRelease: Boolean;
    FDesignOwner: Pointer;
    FMessageProc: TMessageInterpreterProc;
    FGetUnitsProc: TGetInterpreterUnitsProc;
    FGetFormsProc: TGetInterpreterFormsProc;
    FGetDocumentsProc: TGetInterpreterDocumentsProc;
    FOnRunProc: TOnRunInterpreterProc;
    FOnResetProc: TOnResetInterpreterProc;
    FOnFreeProc: TOnFreeInterpreterProc;
    FTypeInterface: TTypeInterface;
    FNameInterface: string;
    FParam: Pointer;
    FisExecProc: Boolean;
    FExecProcParams: Pointer;
    FhInterface: THandle;
    FInterfaceComponent: TInterface;

    ListRealMethodData: TList;
    ListForms: TList;
    FReaderComponent: TComponent;
    FHandle: THandle;

    procedure ClearListRealMethodData;
    procedure ClearListForms;
    procedure ClearAll;
    function GetMainForm: TForm;
    procedure WndProc(var Message: TMessage);
    function GetRunTimeFormByName(Identifer: string): TRunTimeForm;
    procedure PrgGetValue(Sender: TObject; Identifer: string; var Value: Variant;  Args: TArgs; var Done: Boolean);
    procedure PrgError(Sender: TObject);
{    procedure PrgOnSetValue(Sender: TObject; Identifer: string;
                                    const Value: Variant; Args: TArgs; var Done: Boolean);
}

    procedure ReaderExOnFindMethod(Reader: TReader; const MethodName: string;
                                   var Address: Pointer; var Error: Boolean);
    procedure ReaderExOnSetName(Reader: TReader; Component: TComponent; var Name: string);

    procedure ViewMessage(TypeMessage: TTypeMessageInterpreterProc; Line,Pos: Integer; UnitName,Message: String);

    procedure SetUnits;
    procedure SetCodes;
    procedure SetForms;
    procedure SetInterfaceComponent;
    procedure GetInterfaceComponent;
    function GetInfoForm(fm: TForm): Pointer;
    procedure RemoveByForm(fm: TForm);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Run: Boolean; override;
    function Pause: Boolean; override;
    function Compile: Boolean; override;
    function Reset: Boolean; override;
    function TraceInto: Boolean; override;
    function StepOver: Boolean; override;

    procedure SetInterpreterParams(AOwner: Pointer; PSIP: PSetInterpreterParam);

    procedure CreateInterfaceInInterpreter;
    procedure ViewInterfaceInInterpreter;
    procedure RefreshInterfaceInInterpreter;
    procedure CloseInterfaceInInterpreter;
    function ExecProcInterfaceInInterpreter(ExecProcParam: Pointer): Boolean;
    procedure FormCreate(fm: TForm);
    procedure FormDestroy(fm: TForm);
    function CallInterpreterFun(Instance: TObject; Args: TArguments; FunName: String): Variant;
    function DocumentByName(const DocumentName: string; Visible: Boolean): Variant;

    property NameInterface: String read FNameInterface;  
  end;


const
  ConstCreateInterfaceLocal='CreateInterface';
  ConstViewInterfaceLocal='ViewInterface';
  ConstRefreshInterfaceLocal='RefreshInterface';
  ConstCloseInterfaceLocal='CloseInterface';

implementation

uses Dialogs, typinfo, UIntrprTsvData, tsvDocument;

const
  ConstInterpreterReaderBuffer=4096;
  WM_RESET=WM_USER+1;
  WParamRunTimeFormClose=1;
{  WM_RUNTIMEFORM=WM_USER+1;
  WParamRunTimeFormClose=1;}

type
  PInfoForm=^TInfoForm;
  TInfoForm=packed record
    Form: TRunTimeForm;
    FormName: String;
    FormClassName: string;
  end;

  PInfoRealMethodData=^TInfoRealMethodData;
  TInfoRealMethodData=packed record
    Obj: TObject;
    EventName: string;
    Method: TMethod;
  end;


{ TPrgParser }


{ TPrg }

function TPrg.GetMainFunction: TRAI2FunDesc;
begin
  Result:=Adapter.FindFunDesc('',ConstViewInterfaceLocal);
end;

procedure TPrg.CreateInterface;
var
  FunDesc: TRAI2FunDesc;  
begin
  FunDesc := Adapter.FindFunDesc('',ConstCreateInterfaceLocal);
  if FunDesc<>nil then
    ExecFunction(FunDesc);
end;

procedure TPrg.ViewInterface;
var
  FunDesc: TRAI2FunDesc;
begin
  FunDesc := Adapter.FindFunDesc('',ConstViewInterfaceLocal);
  if FunDesc<>nil then
    ExecFunction(FunDesc);
end;

procedure TPrg.RefreshInterface;
var
  FunDesc: TRAI2FunDesc;
begin
  FunDesc := Adapter.FindFunDesc('',ConstRefreshInterfaceLocal);
  if FunDesc<>nil then
    ExecFunction(FunDesc);
end;

procedure TPrg.CloseInterface;
var
  FunDesc: TRAI2FunDesc;
begin
  FunDesc := Adapter.FindFunDesc('',ConstCloseInterfaceLocal);
  if FunDesc<>nil then
    ExecFunction(FunDesc);
end;

{ TRunTimeForm }

constructor TRunTimeForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner,Dummy);
  AssignFont(_GetOptions.FormFont,Font);
  Visible:=false;
end;

procedure TRunTimeForm.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_CLOSE: begin
    end;
  end;
  inherited WndProc(Message);
end;

procedure TRunTimeForm.DoClose(var Action: TCloseAction);
begin
  Inherited DoClose(Action);
  if FInterpreterPascal.GetMainForm=Self then begin
    case Action of
      caFree: begin
        FInterpreterPascal.IsRelease:=true;
        if fsCreatedMDIChild in Self.FormState then begin
           FInterpreterPascal.Reset;
        end else begin
           FInterpreterPascal.Reset;
        end;
      end;
    end;    
  end;
end;

destructor TRunTimeForm.Destroy;
var
  P: PInfoForm;
begin
  if FInterpreterPascal<>nil then begin
    P:=FInterpreterPascal.GetInfoForm(Self);
    if P<>nil then begin
     SaveToIniBySection(ClassName+FInterpreterPascal.NameInterface+P.FormName);
     FInterpreterPascal.FormDestroy(Self);
     P.Form:=nil;
     FInterpreterPascal.ListForms.Remove(P);
     FInterpreterPascal:=nil;
     Dispose(P);
    end; 
  end;  
  inherited;
end;


{ TInterpreter }

constructor TInterpreter.Create;
begin
end;

function TInterpreter.Run: Boolean;
begin
 Result:=false;
end;

function TInterpreter.Pause: Boolean;
begin
 Result:=false;
end;

function TInterpreter.Compile: Boolean;
begin
 Result:=false;
end;

function TInterpreter.Reset: Boolean;
begin
 Result:=false;
end;

function TInterpreter.TraceInto: Boolean;
begin
 Result:=false;
end;

function TInterpreter.StepOver: Boolean;
begin
 Result:=false;
end;

{ TInterpreterPascal }

constructor TInterpreterPascal.Create;
begin
  inherited Create;
  FHandle:=AllocateHWnd(WndProc);
  Prg:=TPrg.Create(nil);
  Prg.OnGetValue:=PrgGetValue;
  Prg.OnError:=PrgError;
  Prg.Adapter.hInterpreter:=THandle(Self);
  ListRealMethodData:=TList.Create;
  ListForms:=TList.Create;
  isDestroy:=false;
{ Prg.OnSetValue:=PrgOnSetValue;
  Prg.OnError:=PrgOnError;}
end;

procedure TInterpreterPascal.ClearListRealMethodData;
var
  i: Integer;
  P: PInfoRealMethodData;
begin
  for i:=0 to ListRealMethodData.Count-1 do begin
    P:=ListRealMethodData.Items[i];
    Dispose(P);
  end;
  ListRealMethodData.Clear;
end;

function TInterpreterPascal.GetInfoForm(fm: TForm): Pointer;
var
  i: Integer;
  P: PInfoForm;
begin
  Result:=nil;
  for i:=0 to ListForms.Count-1 do begin
    P:=ListForms.Items[i];
    if P.Form=fm then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure TInterpreterPascal.RemoveByForm(fm: TForm);
var
  P: PInfoForm;
begin
  P:=GetInfoForm(fm);
  if P=nil then exit;
  P.Form.FInterpreterPascal:=nil;
  FormDestroy(fm);
  P.Form.SaveToIniBySection(P.Form.ClassName+NameInterface+P.FormName);
  if IsRelease then begin
    P.Form.Release;
  end else begin
    P.Form.Free;
  end;
  P.Form:=nil;
  ListForms.Remove(P);
  Dispose(P);
end;

procedure TInterpreterPascal.ClearListForms;
var
  i: Integer;
  P: PInfoForm;
begin
  for i:=ListForms.Count-1 downto 0 do begin
    P:=ListForms.Items[i];
    if P.Form<>nil then
      RemoveByForm(P.Form);
  end;
  ListForms.Clear;
end;

destructor TInterpreterPascal.Destroy;
begin
  isDestroy:=true;
  isBreakWhile:=true;
  SendMessage(FHandle,WM_RESET,0,0);
  ClearListForms;
  ListForms.Free;
  ClearListRealMethodData;
  ListRealMethodData.Free;
  PostMessage(FHandle, CM_RELEASE, 0, 0);
  DeallocateHWnd(FHandle);
  if isValidPointer(FInterfaceComponent) then FreeAndNil(FInterfaceComponent);
  if @FOnFreeProc<>nil then FOnFreeProc(FDesignOwner);
  inherited Destroy;
end;

procedure TInterpreterPascal.SetInterpreterParams(AOwner: Pointer; PSIP: PSetInterpreterParam);
var
  P: PGetInterface;
begin
  FDesignOwner:=AOwner;
  FMessageProc:=nil;
  FGetUnitsProc:=nil;
  FGetFormsProc:=nil;
  FGetDocumentsProc:=nil;
  FOnRunProc:=nil;
  FOnResetProc:=nil;
  FOnFreeProc:=nil;
  if isValidPointer(@PSIP.MessageProc) then  FMessageProc:=PSIP.MessageProc;
  if isValidPointer(@PSIP.GetUnitsProc) then  FGetUnitsProc:=PSIP.GetUnitsProc;
  if isValidPointer(@PSIP.GetFormsProc) then  FGetFormsProc:=PSIP.GetFormsProc;
  if isValidPointer(@PSIP.GetDocumentsProc) then  FGetDocumentsProc:=PSIP.GetDocumentsProc;
  if isValidPointer(@PSIP.OnRunProc) then  FOnRunProc:=PSIP.OnRunProc;
  if isValidPointer(@PSIP.OnResetProc) then  FOnResetProc:=PSIP.OnResetProc;
  if isValidPointer(@PSIP.OnFreeProc) then  FOnFreeProc:=PSIP.OnFreeProc;
  FhInterface:=PSIP.hInterface;
  P:=_GetInterface(FhInterface);
  if P<>nil then begin
    FTypeInterface:=P.TypeInterface;
    FNameInterface:=P.Name;
  end;
  FParam:=PSIP.Param;
  FisExecProc:=PSIP.isExecProc;
  FExecProcParams:=PSIP.ExecProcParams;
end;

procedure TInterpreterPascal.ViewMessage(TypeMessage: TTypeMessageInterpreterProc;
                                         Line,Pos: Integer; UnitName,Message: String);
begin
  if isValidPointer(@FMessageProc) then FMessageProc(FDesignOwner,THandle(Self),TypeMessage,Line,Pos,PChar(UnitName),PChar(Message));
end;

procedure GetInterpreterUnitProc(Owner: Pointer; PGIU: PGetInterpreterUnit); stdcall;
begin
  if not IsValidPointer(PGIU,SizeOf(TGetInterpreterUnit)) then exit;
  if not isValidPointer(Owner) then exit;
  TInterpreterPascal(Owner).Prg.Source:=PGIU.Code;
end;

procedure TInterpreterPascal.SetUnits;
begin
  if isValidPointer(@FGetUnitsProc) then begin
    FGetUnitsProc(FDesignOwner,Self,GetInterpreterUnitProc);
  end;
end;

procedure GetInterpreterConstProc(Owner: Pointer; PGIC: PGetInterpreterConst); stdcall;
begin
  if not isValidPointer(PGIC) then exit;
  TPrg(Owner).Adapter.AddConst('',PGIC.Identifer,PGIC.Value);
end;

procedure GetInterpreterClassProc(Owner: Pointer; PGICL: PGetInterpreterClass); stdcall;
var
  i,j: Integer;
  arr: array of Word;
begin
  if not isValidPointer(PGICL) then exit;
  TPrg(Owner).Adapter.AddClass('',PGICL.ClassType,PGICL.ClassType.ClassName);

  // methods
  for i:=Low(PGICL.Methods) to High(PGICL.Methods) do begin
    SetLength(arr,0);
    if isValidPointer(@PGICL.Methods[i].Proc) then begin
      for j:=Low(PGICL.Methods[i].ProcParams) to High(PGICL.Methods[i].ProcParams) do begin
        SetLength(arr,Length(arr)+1);
        arr[Length(arr)-1]:=PGICL.Methods[i].ProcParams[j].ParamType;
      end;
      TPrg(Owner).Adapter.AddGet(PGICL.ClassType,
                                 PGICL.Methods[i].Identifer,
                                 PGICL.Methods[i].Proc,
                                 Length(PGICL.Methods[i].ProcParams),
                                 arr,
                                 PGICL.Methods[i].ProcResultType.ParamType);
    end;
  end;

  // proprties
  for i:=Low(PGICL.Properties) to High(PGICL.Properties) do begin
    SetLength(arr,0);
    if isValidPointer(@PGICL.Properties[i].ReadProc) then begin
      for j:=Low(PGICL.Properties[i].ReadProcParams) to High(PGICL.Properties[i].ReadProcParams) do begin
        SetLength(arr,Length(arr)+1);
        arr[Length(arr)-1]:=PGICL.Properties[i].ReadProcParams[j].ParamType;
      end;
      if not PGICL.Properties[i].isIndexProperty then begin
       TPrg(Owner).Adapter.AddGet(PGICL.ClassType,
                                  PGICL.Properties[i].Identifer,
                                  PGICL.Properties[i].ReadProc,
                                  Length(PGICL.Properties[i].ReadProcParams),
                                  arr,
                                  PGICL.Properties[i].ReadProcResultType.ParamType);
      end else begin
       TPrg(Owner).Adapter.AddIGet(PGICL.ClassType,
                                   PGICL.Properties[i].Identifer,
                                   PGICL.Properties[i].ReadProc,
                                   Length(PGICL.Properties[i].ReadProcParams),
                                   arr,
                                   PGICL.Properties[i].ReadProcResultType.ParamType);
       TPrg(Owner).Adapter.AddIDGet(PGICL.ClassType,
                                    PGICL.Properties[i].ReadProc,
                                    Length(PGICL.Properties[i].ReadProcParams),
                                    arr,
                                    PGICL.Properties[i].ReadProcResultType.ParamType);  
      end;
    end;
    SetLength(arr,0);
    if isValidPointer(@PGICL.Properties[i].WriteProc) then begin
      for j:=Low(PGICL.Properties[i].WriteProcParams) to High(PGICL.Properties[i].WriteProcParams) do begin
        SetLength(arr,Length(arr)+1);
        arr[Length(arr)-1]:=PGICL.Properties[i].WriteProcParams[j].ParamType;
      end;
      if not PGICL.Properties[i].isIndexProperty then begin
       TPrg(Owner).Adapter.AddSet(PGICL.ClassType,
                                  PGICL.Properties[i].Identifer,
                                  PGICL.Properties[i].WriteProc,
                                  Length(PGICL.Properties[i].WriteProcParams),
                                  arr);
      end else begin
       TPrg(Owner).Adapter.AddISet(PGICL.ClassType,
                                   PGICL.Properties[i].Identifer,
                                   PGICL.Properties[i].WriteProc,
                                   Length(PGICL.Properties[i].WriteProcParams),
                                   arr);
       TPrg(Owner).Adapter.AddIDSet(PGICL.ClassType,
                                    PGICL.Properties[i].WriteProc,
                                    Length(PGICL.Properties[i].WriteProcParams),
                                    arr);   
      end;
    end;
  end;
end;

procedure GetInterpreterFunProc(Owner: Pointer; PGIF: PGetInterpreterFun); stdcall;
var
  j: Integer;
  arr: array of Word;
begin
  if not isValidPointer(PGIF) then exit;
  SetLength(arr,0);
  if isValidPointer(@PGIF.Proc) then begin
    for j:=Low(PGIF.ProcParams) to High(PGIF.ProcParams) do begin
      SetLength(arr,Length(arr)+1);
      arr[Length(arr)-1]:=PGIF.ProcParams[j].ParamType;
    end;
    TPrg(Owner).Adapter.AddFun('',
                               PGIF.Identifer,
                               PGIF.Proc,
                               Length(PGIF.ProcParams),
                               arr,
                               PGIF.ProcResultType.ParamType);
  end;
end;

procedure GetInterpreterEventProc(Owner: Pointer; PGIE: PGetInterpreterEvent); stdcall;
begin
  if not isValidPointer(PGIE) then exit;
  TPrg(Owner).Adapter.AddHandler('',PGIE.Identifer,TRAI2EventClass(PGIE.EventClass),PGIE.EventProc);
end;

procedure GetInterpreterVarProc(Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;
begin
  if not isValidPointer(PGIV) then exit;
  TPrg(Owner).Adapter.AddConst('',PGIV.Identifer,PGIV.Value);
end;

procedure TInterpreterPascal.SetInterfaceComponent;
begin
  if isValidPointer(FInterfaceComponent) then FreeAndNil(FInterfaceComponent);
  case FTypeInterface of
    ttiNone: begin
      FInterfaceComponent:=TiNoneInterface.Create(nil);
    end;
    ttiRBook: begin
      FInterfaceComponent:=TiRBookInterface.Create(nil);
    end;
    ttiReport: begin
      FInterfaceComponent:=TiReportInterface.Create(nil);
    end;
    ttiWizard: begin
      FInterfaceComponent:=TiWizardInterface.Create(nil);
    end;
    ttiJournal: begin
      FInterfaceComponent:=TiJournalInterface.Create(nil);
    end;
    ttiService: begin
      FInterfaceComponent:=TiServiceInterface.Create(nil);
    end;
    ttiDocument: begin
      FInterfaceComponent:=TiDocumentInterface.Create(nil);
    end;
  end;
  if isValidPointer(FInterfaceComponent) then begin
   Prg.Adapter.AddConst('',ConstReturnInterface,O2V(FInterfaceComponent));
  end;
end;

procedure TInterpreterPascal.GetInterfaceComponent;
begin
  if not isValidPointer(FInterfaceComponent) then exit;
  case FTypeInterface of
    ttiNone: begin
    end;
    ttiRBook: begin
      if isValidPointer(FParam) then begin
        if FInterfaceComponent is TiRBookInterface then begin
          FillParamRBookInterfaceFromDataSet(TiRBookInterface(FInterfaceComponent).ReturnData,PParamRBookInterface(FParam),[]);
        end;  
      end;
    end;
  end;
end;

procedure TInterpreterPascal.SetCodes;
begin
  SetInterfaceComponent;
  _GetInterpreterConsts(Prg,GetInterpreterConstProc);
  _GetInterpreterClasses(Prg,GetInterpreterClassProc);
  _GetInterpreterFuns(Prg,GetInterpreterFunProc);
  _GetInterpreterEvents(Prg,GetInterpreterEventProc);
  _GetInterpreterVars(Prg,GetInterpreterVarProc);
end;

procedure TInterpreterPascal.ReaderExOnSetName(Reader: TReader; Component: TComponent; var Name: string);
begin
  FReaderComponent:=Component;
end;

procedure TInterpreterPascal.ReaderExOnFindMethod(Reader: TReader; const MethodName: string;
                                                  var Address: Pointer; var Error: Boolean);
var
  FunDesc: TRAI2FunDesc;
  Method: TMethod;
  TypeName: string;
  PI: PPropInfo;
  PReal: PInfoRealMethodData;
begin
  FunDesc:=Prg.Adapter.FindFunDesc(Prg.CurUnitName, MethodName);
  if FunDesc<>nil then begin
     if (FReaderComponent<>nil) then begin
       PI:=GetPropInfo(FReaderComponent,TReaderEx(Reader).PropName,[tkMethod]);
       if PI=nil then
         PI:=GetPropInfo(Reader.Root,TReaderEx(Reader).PropName,[tkMethod]);
     end else PI:=GetPropInfo(Reader.Root,TReaderEx(Reader).PropName,[tkMethod]);
     if PI<>nil then begin
       New(PReal);
       FillChar(PReal^,Sizeof(TInfoRealMethodData),0);
       TypeName:=PI^.PropType^.Name;
       Method:=TMethod(Prg.NewEvent(Prg.CurUnitName,FunDesc.Identifer,TypeName,Reader.Root));
       Address:=Method.Code;
       Error:=Method.Code=nil;
       if FReaderComponent=nil then PReal.Obj:=Reader.Root
       else PReal.Obj:=FReaderComponent;
       PReal.EventName:=TReaderEx(Reader).PropName;
       PReal.Method.Code:=Method.Code;
       PReal.Method.Data:=Method.Data;
       ListRealMethodData.Add(PReal);
     end;
  end;
end;

function FindGlobalComponentProc(const Name: string): TComponent;
var
  obj: TObject;
begin
  Result:=nil;
  obj:=GetInterpreterVarObjectByName(Name);
  if obj<>nil then begin
    if obj is TComponent then
      Result:=TComponent(obj);
  end;
end;

procedure GetInterpreterFormProc(Owner: Pointer; PGIF: PGetInterpreterForm); stdcall;

  procedure GetFormParams(ms: TStream; var FormName,FormClassName: string);
  var
    parser: TParser;
  begin
    parser:=TParser.Create(ms);
    try
      parser.NextToken;
      FormName:=parser.TokenString;
      parser.NextToken;
      parser.NextToken;
      FormClassName:=parser.TokenString;
    finally
      parser.Free;
    end;
  end;

  procedure SetRealMethodData;
  var
    i: Integer;
    P: PInfoRealMethodData;
  begin
    for i:=0 to TInterpreterPascal(Owner).ListRealMethodData.Count-1 do begin
      P:=TInterpreterPascal(Owner).ListRealMethodData.Items[i];
      if P.Obj<>nil then
       SetMethodProp(P.Obj,P.EventName,P.Method);
    end;
  end;

var
  msOut: TMemoryStream;
  ss: TStringStream;
  rd: TReaderEx;
  fm: TRunTimeForm;
  FormName,FormClassName: string;
  PInfo: PInfoForm;
  OldFind: TFindGlobalComponent;
begin
  if not IsValidPointer(PGIF,SizeOf(TGetInterpreterForm)) then exit;
  if not isValidPointer(Owner) then exit;
  msOut:=TMemoryStream.Create;
  ss:=TStringStream.Create(PGIF.Form);
  try
   ss.Position:=0;
   ObjectTextToBinary(ss,msOut);
   ss.Position:=0;
   GetFormParams(ss,FormName,FormClassName);
   msOut.Position:=0;

   rd:=TReaderEx.Create(msOut,ConstInterpreterReaderBuffer);
   try
    rd.OnFindMethod:=TInterpreterPascal(Owner).ReaderExOnFindMethod;
    rd.OnSetName:=TInterpreterPascal(Owner).ReaderExOnSetName;
    fm:=TRunTimeForm.CreateNew(nil);
    fm.FInterpreterPascal:=Owner;
    TInterpreterPascal(Owner).FReaderComponent:=nil;
    TInterpreterPascal(Owner).ClearListRealMethodData;
    try
     rd.ReadRootComponent(fm);
    except
     on E: Exception do begin
       TInterpreterPascal(Owner).ViewMessage(tmiWarning,0,0,TInterpreterPascal(Owner).Prg.CurUnitName,E.Message);
     end;
    end;
    SetRealMethodData;
//    fm.Name:='';
    New(PInfo);
    FillChar(PInfo^,sizeof(TInfoForm),0);
    PInfo.Form:=fm;
    if PInfo.Form.Left<0 then PInfo.Form.Left:=0;
    if PInfo.Form.Top<0 then PInfo.Form.Top:=0;
    PInfo.FormName:=FormName;
    PInfo.FormClassName:=FormClassName;
    TInterpreterPascal(Owner).ListForms.Add(PInfo);
    TInterpreterPascal(Owner).FormCreate(fm);
    AssignFont(_GetOptions.FormFont,fm.Font);
    fm.LoadFromIniBySection(fm.ClassName+TInterpreterPascal(Owner).NameInterface+FormName);
   finally
    rd.Free;
    OldFind:=FindGlobalComponent;
    FindGlobalComponent:=FindGlobalComponentProc;
    GlobalFixupReferences;
    FindGlobalComponent:=OldFind;
   end;
  finally
   ss.Free;
   msOut.Free;
  end;
end;

procedure TInterpreterPascal.SetForms;
begin
  if isValidPointer(@FGetFormsProc) then FGetFormsProc(FDesignOwner,Self,GetInterpreterFormProc);
end;

type
  PTempGetInterpreterDocument=^TTempGetInterpreterDocument;
  TTempGetInterpreterDocument=packed record
    DocumentName: string;
    Interpreter: TInterpreterPascal;
    Result: Variant;
    isFind: Boolean;
    Visible: Boolean;
  end;

procedure GetInterpreterDocumentProc(Owner: Pointer; PGID: PGetInterpreterDocument; var isBreak: Boolean); stdcall;
var
  PTGID: PTempGetInterpreterDocument;
  ms: TMemoryStream;
  D: TDocument;
begin
  if not IsValidPointer(PGID,SizeOf(TGetInterpreterDocument)) then exit;
  if not isValidPointer(Owner) then exit;
  PTGID:=Owner;
  if AnsiSameText(PTGID.DocumentName,PGID.DocumentName) then begin
    isBreak:=true;
    PTGID.isFind:=true;
    ms:=TMemoryStream.Create;
    D:=TDocument.Create(nil);
    try
      ms.SetSize(PGID.DocumentSize);
      ms.Write(PGID.Document^,ms.Size);
      ms.Position:=0;
      D.OleClass:=PGID.DocumentClass;
      D.LoadFromStream(ms);
      if D.Run then begin
        if PTGID.Visible then
          D.DoVerbDefault(true);
        PTGID.Result:=D.OleObject;
      end;
    finally
      D.Free;
      ms.Free;
    end;
  end;
end;

function TInterpreterPascal.DocumentByName(const DocumentName: string; Visible: Boolean): Variant;
var
  TTGID: TTempGetInterpreterDocument;
begin
  Result:=varEmpty;
  if isValidPointer(@FGetDocumentsProc) then begin
    FillChar(TTGID,SizeOf(TTGID),0);
    TTGID.DocumentName:=DocumentName;
    TTGID.Interpreter:=Self;
    TTGID.Result:=varEmpty;
    TTGID.Visible:=Visible;
    FGetDocumentsProc(FDesignOwner,@TTGID,GetInterpreterDocumentProc);
    if not TTGID.isFind then
      raise Exception.CreateFmt(fmtDocumentNotFound,[DocumentName]);
    Result:=TTGID.Result;
  end;  
end;

function TInterpreterPascal.GetMainForm: TForm;
begin
  Result:=nil;
  if ListForms.Count>0 then
    Result:=PInfoForm(ListForms.Items[0]).Form;
end;

procedure TInterpreterPascal.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_RELEASE: begin
      Prg.Free;
      Prg:=nil;
    end;
    else
      DefaultHandler(Message);
  end;
end;

procedure TInterpreterPascal.ClearAll;
begin
  GetInterfaceComponent;
  ClearListForms;
  ClearListRealMethodData;
  if not IsRelease then begin
    Prg.Source:='';
    Prg.Adapter.Clear;
  end;  
end;

function TInterpreterPascal.GetRunTimeFormByName(Identifer: string): TRunTimeForm;
var
  i: Integer;
  PInfo: PInfoForm;
begin
  Result:=nil;
  for i:=0 to ListForms.Count-1 do begin
    PInfo:=ListForms.Items[i];
    if AnsiSameText(PInfo.FormName,Identifer) then begin
      Result:=PInfo.Form;
      exit;
    end;
  end; 
end;

function GetComponentByName(AOwner: TObject; Identifer: String): TObject;
begin
  Result:=nil;
  if not isValidPointer(AOwner) then exit;
  if not (AOwner is TComponent) then exit;
  Result:=TComponent(AOwner).FindComponent(Identifer);
end;

procedure TInterpreterPascal.PrgGetValue(Sender: TObject; Identifer: string; var Value: Variant;  Args: TArgs; var Done: Boolean);
var
  obj: TObject;
begin
  obj:=nil;
  if Args.Obj=nil then begin
   obj:=GetRunTimeFormByName(Identifer);
  end;
  if Obj<>nil then begin
   Value:=O2V(obj);
   Done:=true;
  end else begin
   if Args.ObjTyp=varObject then begin
    obj:=GetComponentByName(Args.Obj,Identifer);
    if obj<>nil then begin
     Value:=O2V(obj);
     Done:=true;
    end;
   end; 
  end;
end;

procedure TInterpreterPascal.PrgError(Sender: TObject);
begin
   ViewMessage(tmiWarning,Prg.LastError.ErrLine,Prg.LastError.ErrPos,Prg.LastError.ErrUnitName,Prg.LastError.Message);
end;

function TInterpreterPascal.Run: Boolean;
var
  Msg: TMsg;
begin
  Result:=false;
  try
   isBreakWhile:=false;
   IsRelease:=false;
   ClearAll;
   
   SetUnits;
   SetCodes;
   Prg.Compile;
   CreateInterfaceInInterpreter;
   SetForms;

   if @FOnRunProc<>nil then FOnRunProc(FDesignOwner);

   if not FisExecProc then begin
     Prg.Run;
     Result:=true;
   end else begin
     Prg.Run;
     Result:=ExecProcInterfaceInInterpreter(FExecProcParams);
   end;
   
   Result:=true;
   
   if GetMainForm<>nil then begin
    while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do begin
     if isBreakWhile then break;
     if isDestroy then break;
     TranslateMessage(Msg);
     DispatchMessage(Msg);
    end;
   end else Reset;

  except
    on E: Exception do begin
      if E is EPrgError.ClassParent then begin
        ViewMessage(tmiError,EPrgError(E).ErrLine,EPrgError(E).ErrPos,EPrgError(E).ErrUnitName,E.Message);
      end else begin
        ViewMessage(tmiError,0,0,'',E.Message);
      end;
    end;
  end;
end;

function TInterpreterPascal.Pause: Boolean;
begin
  Result:=false;
end;

function TInterpreterPascal.Compile: Boolean;
begin
  Result:=false;
end;

function TInterpreterPascal.Reset: Boolean;
begin
  isBreakWhile:=true;
  SendMessage(FHandle,WM_RESET,0,0);
  ClearAll;
  Result:=ListForms.Count=0;
  if @FOnResetProc<>nil then FOnResetProc(FDesignOwner);
end;

function TInterpreterPascal.TraceInto: Boolean;
begin
  Result:=false;
end;

function TInterpreterPascal.StepOver: Boolean;
begin
  Result:=false;
end;

procedure TInterpreterPascal.CreateInterfaceInInterpreter;
begin
  Prg.CreateInterface;
end;

procedure TInterpreterPascal.ViewInterfaceInInterpreter;
begin
  Prg.ViewInterface;
end;

procedure TInterpreterPascal.RefreshInterfaceInInterpreter;
begin
  Prg.RefreshInterface;
end;

procedure TInterpreterPascal.CloseInterfaceInInterpreter;
begin
  Prg.CloseInterface;
end;

function TInterpreterPascal.ExecProcInterfaceInInterpreter(ExecProcParam: Pointer): Boolean;
var
  P: PParamExecProcNoneInterface;
  Args: TArguments;
  i: Integer;
begin
  Result:=false;
  if not isValidPointer(ExecProcParam) then exit;
  P:=PParamExecProcNoneInterface(ExecProcParam);
  Args:=TArguments.Create;
  try
    Args.Count:=0;
    for i:=Low(P.Params) to High(P.Params) do begin
      Args.Values[Args.Count] := P.Params[i].Value;
      inc(Args.Count);
    end;
    P.Result:=Prg.CallFunctionEx(nil,Prg.CurUnitName,P.ProcName,Args,Null);
    for i:=0 to Args.Count-1 do begin
      P.Params[Low(P.Params)+i].Value:=Args.Values[i];
    end;
    Result:=true;
  finally
    Args.Free;
  end;
end;

function TInterpreterPascal.CallInterpreterFun(Instance: TObject; Args: TArguments; FunName: String): Variant;
begin
  Result:=Prg.CallFunctionEx(Instance,Prg.CurUnitName,FunName,Args,Null);
end;

procedure TInterpreterPascal.FormCreate(fm: TForm);
var
  PPI: PPropInfo;
  M: TMethod;
  N: TNotifyEvent;
begin
  if fm=nil then exit;
  PPI:=GetPropInfo(fm,'ONCREATE',[tkMethod]);
  if PPI<>nil then begin
    M:=GetMethodProp(fm,PPI);
    N:=nil;
    if M.Code<>nil then begin
      @N:=M.Code;
    //   N(fm);
       M.Code:=nil;
       M.Data:=nil;
       SetMethodProp(fm,PPI,M);
    end;
  end;
end;

procedure TInterpreterPascal.FormDestroy(fm: TForm);
var
  PPI: PPropInfo;
  M: TMethod;
  N: TNotifyEvent;
begin
  if fm=nil then exit;
  PPI:=GetPropInfo(fm,'ONDESTROY',[tkMethod]);
  if PPI<>nil then begin
    M:=GetMethodProp(fm,PPI);
    N:=nil;
    if M.Code<>nil then begin
      @N:=M.Code;
//      N(fm);
      M.Code:=nil;
      M.Data:=nil;
      SetMethodProp(fm,PPI,M);
    end;
  end;
end;



end.
