unit UIntrprTsvCode;

interface



uses Windows, Forms, UIntrprTsvData, UMainUnited, Classes, UIntrprTsvDm, dialogs,
     IBDatabase, IBQuery, Controls, tsvHint, db, SysUtils, IBServices, stdctrls,
     comctrls, tsvDesignCore, tsvInterpreterCore, RAI2Parser, typinfo;

// Internal

procedure DeInitAll;
procedure CreateLibraryInterpreter;
procedure FreeLibraryInterpreter;
procedure ClearListInterpreterHandles;

procedure ClearListInterfaceHandles;
function GetInterfaceInfoByHandle(hInterface: THandle): PInfoInterface;
function GetInterfaceInfoByInterfaceId(Interface_id: Integer): PInfoInterface;
procedure AddToListInterfaceHandles;
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
function RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
function CloseInterface(InterfaceHandle: THandle): Boolean; stdcall;
function ExecProcInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
procedure ClearListMenuHandles;
procedure MenuClickProc(MenuHandle: THandle);stdcall;
function GetMenuInfoByHandle(hMenu: THandle): PInfoMenu;
function GetMenuInfoByMenuId(Menu_id: Integer): PInfoMenu;
procedure AddToListMenuRootHandles;
procedure ClearListToolBarHandles;
procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
procedure AddToListToolBarHandles;
procedure AddToListInterpreterFunHandles;
procedure ClearListInterpreterFunHandles;


function CreateInterpreter(PCI: PCreateInterpreter): THandle; stdcall;
function RunInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
function ResetInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
function FreeInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
function IsValidInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
function SetInterpreterParams(InterpreterHandle: THandle; Owner: Pointer; PSIP: PSetInterpreterParam): Boolean; stdcall;
function CallInterpreterFun(InterpreterHandle: THandle; Instance: TObject; Args: TArguments; FunName: PChar): Variant; stdcall;
function GetInterpreterDocumentByName(InterpreterHandle: THandle; const DocumentName: String; Visible: Boolean=true): Variant;
function GetInterpreterInterfaceName(InterpreterHandle: THandle): Variant;

function GetCreateInterfaceName: PChar; stdcall;
procedure GetInterpreterIdentifers(Owner: Pointer; PGIIP: PGetInterpreterIdentiferParams); stdcall;
procedure CreateInterfaceInInterpreter(InterpreterHandle: THandle);
procedure ViewInterfaceInInterpreter(InterpreterHandle: THandle; Param: Pointer);
procedure RefreshInterfaceInInterpreter(InterpreterHandle: THandle; Param: Pointer);
procedure CloseInterfaceInInterpreter(InterpreterHandle: THandle);
function ExecProcInterfaceInInterpreter(InterpreterHandle: THandle; Param: Pointer): Boolean;

// Export
procedure InitAll_; stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;

                         
implementation

uses Graphics, UInterpreter, RAI2, tsvSecurity;

//******************* Internal ************************

procedure InitAll_; stdcall;
begin
 try
  dm:=Tdm.Create(nil);
  CreateLibraryInterpreter;
  ListInterpreterHandles:=TList.Create;

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  ListToolBarHandles:=TList.Create;
  AddToListToolBarHandles;

  ListInterpreterFunHandles:=TList.Create;
  AddToListInterpreterFunHandles;

  isInitAll:=true;
 except
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  ClearListInterpreterFunHandles;
  ListInterpreterFunHandles.Free;
  
  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  ClearListInterpreterHandles;
  ListInterpreterHandles.Free;

  FreeLibraryInterpreter;
  dm.Free;
 except
 end;
end;

procedure CreateLibraryInterpreter;
var
  TCLI: TCreateLibraryInterpreter;
begin
  FillChar(TCLI,SizeOf(TCLI),0);
  TCLI.GUID:=LibraryInterpreterGUID;
  TCLI.Hint:=LibraryInterpreterHint;
  TCLI.CreateProc:=CreateInterpreter;
  TCLI.RunProc:=RunInterpreter;
  TCLI.ResetProc:=ResetInterpreter;
  TCLI.FreeProc:=FreeInterpreter;
  TCLI.IsValidProc:=IsValidInterpreter;
  TCLI.SetParamsProc:=SetInterpreterParams;
  TCLI.CallFunProc:=CallInterpreterFun;
  TCLI.GetCreateInterfaceNameProc:=GetCreateInterfaceName;
  TCLI.GetInterpreterIdentifersProc:=GetInterpreterIdentifers;
  hLibraryInterpreter:=_CreateLibraryInterpreter(@TCLI);
end;

procedure FreeLibraryInterpreter;
begin
  _FreeLibraryInterpreter(hLibraryInterpreter);
end;

procedure ClearListInterpreterHandles;
var
  i: Integer;
begin
  for i:=ListInterpreterHandles.Count-1 downto 0 do begin
    FreeInterpreter(THandle(ListInterpreterHandles.Items[i]));
  end;
  ListInterpreterHandles.Clear;
end;

function CreateInterpreter(PCI: PCreateInterpreter): THandle; stdcall;
var
  ipas: TInterpreterPascal;
begin
  Result:=INTERPRETER_INVALID_HANDLE;
  if not IsValidPointer(PCI,SizeOf(TCreateInterpreter)) then exit;
  ipas:=TInterpreterPascal.Create;
  ListInterpreterHandles.Add(ipas);
  Result:=THandle(ipas);
end;

function RunInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
var
  ipas: TInterpreterPascal;
begin
  Result:=false;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  Result:=ipas.Run;
end;

function ResetInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
var
  ipas: TInterpreterPascal;
begin
  Result:=false;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  Result:=ipas.Reset;
end;

function FreeInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
var
  ipas: TInterpreterPascal;
begin
  Result:=false;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  ListInterpreterHandles.Remove(ipas);
  ipas.Free;
  Result:=true;
end;

function IsValidInterpreter(InterpreterHandle: THandle): Boolean;stdcall;
begin
  Result:=ListInterpreterHandles.IndexOf(Pointer(InterpreterHandle))<>-1;
end;

function SetInterpreterParams(InterpreterHandle: THandle; Owner: Pointer; PSIP: PSetInterpreterParam): Boolean; stdcall;
var
  ipas: TInterpreterPascal;
begin
  Result:=false;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  ipas.SetInterpreterParams(Owner,PSIP);
  Result:=true;
end;

function CallInterpreterFun(InterpreterHandle: THandle; Instance: TObject; Args: TArguments; FunName: PChar): Variant; stdcall;
var
  ipas: TInterpreterPascal;
begin
  Result:=Null;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  Result:=ipas.CallInterpreterFun(Instance,Args,FunName);
end;

function GetInterpreterDocumentByName(InterpreterHandle: THandle; const DocumentName: String; Visible: Boolean): Variant;
var
  ipas: TInterpreterPascal;
begin
  Result:=varEmpty;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  Result:=ipas.DocumentByName(DocumentName,Visible);
end;

function GetInterpreterInterfaceName(InterpreterHandle: THandle): Variant;
var
  ipas: TInterpreterPascal;
begin
  Result:='';
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  Result:=ipas.NameInterface;
end;

function GetCreateInterfaceName: PChar; stdcall;
begin
  Result:=ConstCreateInterfaceLocal;
end;

type
  PTempGetInterpreterIdentifer=^TTempGetInterpreterIdentifer;
  TTempGetInterpreterIdentifer=packed record
    Owner: Pointer;
    Proc: TGetInterpreterIdentiferItemProc;
    Identifers: TStringList;
    LastTyp: TTokenTyp;
    Code: String;

    ColorVar: TColor;
    ColorProcedure: TColor;
    ColorFunction: TColor;
    ColorType: TColor;
    ColorProperty: TColor;
    ColorConst: TColor;
    ColorBackGround: TColor;
    ColorCaption: TColor;
    ColorParams: TColor;
    ColorHint: TColor;
  end;

procedure ViewIdentifer(Owner: Pointer;
                        sType,sCaption,sParams,sValue,sHint: String;
                        cType: TColor);
var
  TGIII: TGetInterpreterIdentiferItem;
  PGIIIC: PGetInterpreterIdentiferItemCaption;
  i: Integer;
begin
  FillChar(TGIII,SizeOf(TGIII),0);
  try
    TGIII.Caption:=PChar(SCaption);
    TGIII.Brush:=TBrush.Create;
    TGIII.Brush.Color:=PTempGetInterpreterIdentifer(Owner).ColorBackGround;

    New(PGIIIC);
    FillChar(PGIIIC^,SizeOf(PGIIIC^),0);
    PGIIIC.Caption:=PChar(sType);
    PGIIIC.Brush:=TBrush.Create;
    PGIIIC.Brush.Color:=PTempGetInterpreterIdentifer(Owner).ColorBackGround;
    PGIIIC.Font:=TFont.Create;
    PGIIIC.Font.Color:=cType;
    PGIIIC.Width:=55;
    SetLength(TGIII.CaptionEx,Length(TGIII.CaptionEx)+1);
    TGIII.CaptionEx[Length(TGIII.CaptionEx)-1]:=PGIIIC;

    New(PGIIIC);
    FillChar(PGIIIC^,SizeOf(PGIIIC^),0);
    PGIIIC.Caption:=PChar(sCaption);
    PGIIIC.Brush:=TBrush.Create;
    PGIIIC.Brush.Color:=PTempGetInterpreterIdentifer(Owner).ColorBackGround;
    PGIIIC.Font:=TFont.Create;
    PGIIIC.Font.Style:=[fsBold];
    PGIIIC.Font.Color:=PTempGetInterpreterIdentifer(Owner).ColorCaption;
    PGIIIC.AutoSize:=true;
    SetLength(TGIII.CaptionEx,Length(TGIII.CaptionEx)+1);
    TGIII.CaptionEx[Length(TGIII.CaptionEx)-1]:=PGIIIC;

    New(PGIIIC);
    FillChar(PGIIIC^,SizeOf(PGIIIC^),0);
    PGIIIC.Caption:=PChar(sParams);
    PGIIIC.Brush:=TBrush.Create;
    PGIIIC.Brush.Color:=PTempGetInterpreterIdentifer(Owner).ColorBackGround;
    PGIIIC.Font:=TFont.Create;
    PGIIIC.Font.Color:=PTempGetInterpreterIdentifer(Owner).ColorParams;
    PGIIIC.AutoSize:=true;
    SetLength(TGIII.CaptionEx,Length(TGIII.CaptionEx)+1);
    TGIII.CaptionEx[Length(TGIII.CaptionEx)-1]:=PGIIIC;

    if Trim(sValue)<>'' then begin
      New(PGIIIC);
      FillChar(PGIIIC^,SizeOf(PGIIIC^),0);
      PGIIIC.Caption:=PChar(sValue);
      PGIIIC.Brush:=TBrush.Create;
      PGIIIC.Brush.Color:=PTempGetInterpreterIdentifer(Owner).ColorBackGround;
      PGIIIC.Font:=TFont.Create;
      PGIIIC.Font.Color:=clBlack;
      PGIIIC.AutoSize:=true;
      SetLength(TGIII.CaptionEx,Length(TGIII.CaptionEx)+1);
      TGIII.CaptionEx[Length(TGIII.CaptionEx)-1]:=PGIIIC;
    end;

    if Trim(sHint)<>'' then begin
      New(PGIIIC);
      FillChar(PGIIIC^,SizeOf(PGIIIC^),0);
      PGIIIC.Caption:=PChar(' { '+sHint+' } ');
      PGIIIC.Brush:=TBrush.Create;
      PGIIIC.Brush.Color:=PTempGetInterpreterIdentifer(Owner).ColorBackGround;
      PGIIIC.Font:=TFont.Create;
      PGIIIC.Font.Color:=PTempGetInterpreterIdentifer(Owner).ColorHint;
      SetLength(TGIII.CaptionEx,Length(TGIII.CaptionEx)+1);
      TGIII.CaptionEx[Length(TGIII.CaptionEx)-1]:=PGIIIC;
    end;

    PTempGetInterpreterIdentifer(Owner).Proc(PTempGetInterpreterIdentifer(Owner).Owner,@TGIII);

  finally
    for i:=Low(TGIII.CaptionEx) to High(TGIII.CaptionEx) do begin
      PGIIIC:=TGIII.CaptionEx[i];
      if isValidPointer(PGIIIC.Brush) then PGIIIC.Brush.Free;
      if isValidPointer(PGIIIC.Font) then PGIIIC.Font.Free;
      if isValidPointer(PGIIIC.Pen) then PGIIIC.Pen.Free;
      Dispose(PGIIIC);
    end;
    TGIII.Brush.Free;
  end;
end;

type
  PTempIdentifer=^TTempIdentifer;
  TTempIdentifer=packed record
    Typ: TTokenTyp;
    PrevTyp: TTokenTyp;
  end;

procedure GetInterpreterVar(Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;
var
  P: PTempGetInterpreterIdentifer;
const
  TypVar=[ttIdentifer,ttBegin,ttIf,ttThen,ttElse,ttWhile,ttTry,ttFinally,ttExcept,ttLB,ttCol,ttSemicolon,ttLS,
          ttRepeat,ttUntil,ttTo,ttCase,ttNot,ttMul,ttDiv,ttIntDiv,ttMod,ttAnd,ttPlus,ttMinus,ttOr,
          ttEqu,ttGreater,ttLess,ttNotEqu,ttEquGreater,ttEquLess];
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIV) then exit;
  P:=PTempGetInterpreterIdentifer(Owner);
  if not (P.LastTyp in TypVar) then exit;
  if P.Identifers.Count=0 then
    ViewIdentifer(P,kwVAR,PGIV.Identifer,' : '+PGIV.TypeText+';','',PGIV.Hint,P.ColorVar)
  else
//    if PTempIdentifer(P.Identifers.Objects[P.Identifers.Count-1]).PrevTyp<>ttPoint then
      ViewIdentifer(P,kwVAR,PGIV.Identifer,' : '+PGIV.TypeText+';','',PGIV.Hint,P.ColorVar);
end;

procedure GetInterpreterFun(Owner: Pointer; PGIF: PGetInterpreterFun); stdcall;
var
  P: PTempGetInterpreterIdentifer;
  isProc: Boolean;
  i: Integer;
  sParams: string;
  kwProc: string;
  clProc: TColor;
const
  TypFun=[ttIdentifer,ttBegin,ttIf,ttThen,ttElse,ttWhile,ttTry,ttFinally,ttExcept,ttLB,ttCol,ttSemicolon,ttLS,
          ttRepeat,ttUntil,ttTo,ttCase,ttNot,ttMul,ttDiv,ttIntDiv,ttMod,ttAnd,ttPlus,ttMinus,ttOr,
          ttEqu,ttGreater,ttLess,ttNotEqu,ttEquGreater,ttEquLess];
  TypProc=[ttIdentifer,ttBegin,ttThen,ttElse,ttWhile,ttTry,ttFinally,ttExcept,ttLB,ttCol,ttSemicolon,
           ttRepeat,ttEqu,ttNotEqu];
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIF) then exit;
  P:=PTempGetInterpreterIdentifer(Owner);
  isProc:=PGIF.ProcResultType.ParamText=nil;
  for i:=Low(PGIF.ProcParams) to High(PGIF.ProcParams) do begin
    if i=Low(PGIF.ProcParams) then begin
     sParams:=' ('+PGIF.ProcParams[i].ParamText;
    end else begin
     sParams:=sParams+'; '+PGIF.ProcParams[i].ParamText;
    end;
    if i=High(PGIF.ProcParams) then begin
     sParams:=sParams+')';
    end;
  end;
  if isProc then begin
    if not (P.LastTyp in TypProc) then exit;
    sParams:=sParams+';';
    kwProc:=kwPROCEDURE;
    clProc:=P.ColorProcedure;
  end else begin
    if not (P.LastTyp in TypFun) then exit;
    sParams:=sParams+': '+PGIF.ProcResultType.ParamText+';';
    kwProc:=kwFUNCTION;
    clProc:=P.ColorFunction;
  end;
  if P.Identifers.Count=0 then
    ViewIdentifer(P,kwProc,PGIF.Identifer,sParams,'',PGIF.Hint,clProc)
  else
//    if PTempIdentifer(P.Identifers.Objects[P.Identifers.Count-1]).PrevTyp<>ttPoint then
      ViewIdentifer(P,kwProc,PGIF.Identifer,sParams,'',PGIF.Hint,clProc);
end;

procedure GetInterpreterConst(Owner: Pointer; PGIC: PGetInterpreterConst); stdcall;
var
  P: PTempGetInterpreterIdentifer;
  sParam: string;
const
  TypConst=[ttIdentifer,ttIf,ttLB,ttCol,ttLS,
            ttUntil,ttTo,ttCase,ttNot,ttMul,ttDiv,ttIntDiv,ttMod,ttAnd,ttPlus,ttMinus,ttOr,
            ttEqu,ttGreater,ttLess,ttNotEqu,ttEquGreater,ttEquLess];
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIC) then exit;
  P:=PTempGetInterpreterIdentifer(Owner);
  if not (P.LastTyp in TypConst) then exit;
  if PGIC.TypeInfo=nil then begin
    sParam:=' : '+VarType2TypeName(VarType(PGIC.Value))+';';
  end else begin
    sParam:=' : '+PTypeInfo(PGIC.TypeInfo).Name+';';
  end;
  if P.Identifers.Count=0 then
    ViewIdentifer(P,kwCONST,PGIC.Identifer,sParam,'',PGIC.Hint,P.ColorConst)
  else
//    if PTempIdentifer(P.Identifers.Objects[P.Identifers.Count-1]).PrevTyp<>ttPoint then
    ViewIdentifer(P,kwCONST,PGIC.Identifer,sParam,'',PGIC.Hint,P.ColorConst);
end;

procedure GetInterpreterClass(Owner: Pointer; PGICL: PGetInterpreterClass); stdcall;
var
  P: PTempGetInterpreterIdentifer;
  sParams: string;
const
  TypClass=[ttIdentifer,ttBegin,ttIf,ttThen,ttElse,ttWhile,ttTry,ttFinally,ttExcept,ttLB,ttCol,ttColon,
            ttSemicolon,ttLS,ttRepeat,ttUntil,ttTo,ttCase,ttNot,ttAnd,ttPlus,ttMinus,ttOr,
            ttEqu,ttNotEqu];
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGICL) then exit;
  P:=PTempGetInterpreterIdentifer(Owner);
  if not (P.LastTyp in TypClass) then exit;
  if PGICL.ClassType.ClassParent<>nil then begin
   sParams:=' : class('+PGICL.ClassType.ClassParent.ClassName+');';
  end else begin
   sParams:=' : class;';
  end;
  if P.Identifers.Count=0 then
    ViewIdentifer(P,kwTYPE,PGICL.ClassType.ClassName,sParams,'',PGICL.Hint,P.ColorType)
  else
//    if PTempIdentifer(P.Identifers.Objects[P.Identifers.Count-1]).PrevTyp<>ttPoint then
      ViewIdentifer(P,kwTYPE,PGICL.ClassType.ClassName,sParams,'',PGICL.Hint,P.ColorType);
end;

type
  PTempGetDesignPropertyTranslate=^TTempGetDesignPropertyTranslate;
  TTempGetDesignPropertyTranslate=packed record
    Hint: string;
    Cls: TClass;
  end;

procedure GetDesignPropertyTranslate(Owner: Pointer; PGDPT: PGetDesignPropertyTranslate); stdcall;
var
  P: PTempGetDesignPropertyTranslate;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGDPT) then exit;
  New(P);
  FillChar(P^,SizeOf(P^),0);
  P.Hint:=PGDPT.Translate;
  P.Cls:=PGDPT.Cls;
  TStringList(Owner).AddObject(PGDPT.Real,TObject(P));
end;

procedure GetDesignPropertyRemove(Owner: Pointer; PGDPR: PGetDesignPropertyRemove);stdcall;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGDPR) then exit;
  TStringList(Owner).AddObject(PGDPR.Name,TObject(PGDPR.Cls));
end;

type
  PTempGetInterpreterClassForProp=^TTempGetInterpreterClassForProp;
  TTempGetInterpreterClassForProp=packed record
    ClassType: TClass;
    str: TStringList;
    OnlyMethods: Boolean;
    P: PTempGetInterpreterIdentifer; 
  end;

  PInfoProperty=^TInfoProperty;
  TInfoProperty=packed record
    Param: string;
    sType: string;
    sHint: string;
    Color: TColor;
  end;

procedure GetInterpreterClassForProp(Owner: Pointer; PGICL: PGetInterpreterClass); stdcall;

  function GetParamByResultType(IPP: TInterpreterProcParam): string;
  begin
    Result:='';
    if Trim(IPP.ParamText)<>'' then begin
      Result:=' : '+IPP.ParamText+';';
    end;
  end;

var
  P: PTempGetInterpreterClassForProp;
  PInfo: PInfoProperty;
  i,j: Integer;
  isProc: Boolean;
  isAdd: Boolean;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGICL) then exit;
  P:=PTempGetInterpreterClassForProp(Owner);
  if not isClassParent(P.ClassType,PGICL.ClassType) then exit;
//  if P.ClassType<>PGICL.ClassType then exit;

  if not P.OnlyMethods then
    for i:=Low(PGICL.Properties) to High(PGICL.Properties) do begin
      New(PInfo);
      FillChar(PInfo^,SizeOf(PInfo^),0);
      PInfo.Color:=P.P.ColorProperty;
      PInfo.sHint:=PGICL.Properties[i].Hint;
      PInfo.sType:=kwPROPERTY;
      PInfo.Param:=GetParamByResultType(PGICL.Properties[i].ReadProcResultType);
      P.str.AddObject(PGICL.Properties[i].Identifer,TObject(PInfo));
    end;

  for i:=Low(PGICL.Methods) to High(PGICL.Methods) do begin
    isProc:=PGICL.Methods[i].ProcResultType.ParamText=nil;
    isAdd:=true;
{    if isProc then
      if P.OnlyMethods then isAdd:=false;}
    if isAdd then begin
      New(PInfo);
      FillChar(PInfo^,SizeOf(PInfo^),0);
      for j:=Low(PGICL.Methods[i].ProcParams) to High(PGICL.Methods[i].ProcParams) do begin
        if j=Low(PGICL.Methods[i].ProcParams) then begin
         PInfo.Param:=' ('+PGICL.Methods[i].ProcParams[j].ParamText;
        end else begin
         PInfo.Param:=PInfo.Param+'; '+PGICL.Methods[i].ProcParams[j].ParamText;
        end;
        if j=High(PGICL.Methods[i].ProcParams) then begin
         PInfo.Param:=PInfo.Param+')';
        end;
      end;
      if isProc then begin
        PInfo.Param:=PInfo.Param+';';
        PInfo.sType:=kwPROCEDURE;
        PInfo.Color:=P.P.ColorProcedure;
      end else begin
        PInfo.Param:=PInfo.Param+': '+PGICL.Methods[i].ProcResultType.ParamText+';';
        PInfo.sType:=kwFUNCTION;
        PInfo.Color:=P.P.ColorFunction;
      end;
      P.str.AddObject(PGICL.Methods[i].Identifer,TObject(PInfo));
    end;
  end;
end;

procedure GetInterpreterIdentifers(Owner: Pointer; PGIIP: PGetInterpreterIdentiferParams); stdcall;
var
  TTGII: TTempGetInterpreterIdentifer;
  isGetProp: Boolean;

  function GetPropertyHint(Name: string; objClass: TClass; strHint: TStringList): string;
  var
    i: Integer;
    P: PTempGetDesignPropertyTranslate;
  begin
    Result:='';
    for i:=0 to strHint.Count-1 do begin
      P:=PTempGetDesignPropertyTranslate(strHint.Objects[i]);
      if AnsiSameText(strHint.Strings[i],Name) then begin
        Result:=P.Hint;
        if P.Cls=objClass then exit;
      end;
    end;
  end;

  function isRemoveProperty(Name: string; objClass: TClass; strDel: TStringList): Boolean;
  var
    i: Integer;
    cls: TClass;
  begin
    Result:=false;
    for i:=0 to strDel.Count-1 do begin
      if AnsiSameText(Name,strDel.Strings[i]) then begin
       cls:=TClass(strDel.Objects[i]);
       if cls<>nil then begin
         if cls=objClass then Result:=true;
       end else Result:=true;
      end;
      if Result then exit;
    end;
  end;

  procedure GetInterpreterClasses(objClass: TClass; str: TStringList; OnlyMethods: Boolean);
  var
    TGICFP: TTempGetInterpreterClassForProp;
  begin
    FillChar(TGICFP,SizeOf(TGICFP),0);
    TGICFP.ClassType:=objClass;
    TGICFP.str:=str;
    TGICFP.OnlyMethods:=OnlyMethods;
    TGICFP.P:=@TTGII;
     _GetInterpreterClasses(@TGICFP,GetInterpreterClassForProp);
  end;
  
  procedure GetObjectProps(objClass: TClass; str: TStringList; OnlyMethods: Boolean);
  var
    I,Count: Integer;
    PropInfo: PPropInfo;
    PropList: PPropList;
    P: PInfoProperty;
    PHint: PTempGetDesignPropertyTranslate;
    strHint: TStringList;
    strDel: TStringList;
  begin
    if objClass=nil then exit;
    strHint:=TStringList.Create;
    strDel:=TStringList.Create;
    try
      GetInterpreterClasses(objClass,str,OnlyMethods);
      if OnlyMethods then exit;
      _GetDesignPropertyTranslates(strHint,GetDesignPropertyTranslate);
      _GetDesignPropertyRemoves(strDel,GetDesignPropertyRemove);
      Count := GetTypeData(ObjClass.ClassInfo)^.PropCount;
      if Count > 0 then begin
        GetMem(PropList, Count * SizeOf(Pointer));
        try
          GetPropInfos(ObjClass.ClassInfo, PropList);
          for I :=0  to Count - 1 do begin
            PropInfo := PropList^[I];
            if PropInfo = nil then break;
            if not isRemoveProperty(PropInfo.Name,objClass,strDel) then begin
              New(P);
              FillChar(P^,SizeOf(P^),0);
              P.Param:=' : '+PropInfo.PropType^.Name+';';
              P.sType:=kwPROPERTY;
              P.Color:=TTGII.ColorProperty;
              P.sHint:=GetPropertyHint(PropInfo.Name,objClass,strHint);
              str.AddObject(PropInfo.Name,TObject(P));
            end;  
          end;
        finally
          FreeMem(PropList, Count * SizeOf(Pointer));
        end;
      end;
    finally
     strDel.Free;
     for i:=0 to strHint.Count-1 do begin
       PHint:=PTempGetDesignPropertyTranslate(strHint.Objects[i]);
       DisPose(PHint);
     end;
     strHint.Free;
    end;
  end;

  procedure FillComponents(objOwner: TObject; strList: TStringList; DesignClass: TClass);
  var
    i: Integer;
  begin
   if ObjOwner=nil then exit;
   if not (ObjOwner is TComponent) then exit;
   for i:=TComponent(ObjOwner).ComponentCount-1 downto 0 do begin
     if not (TComponent(ObjOwner).Components[i] is DesignClass) then begin
       if Trim(TComponent(ObjOwner).Components[i].Name)<>'' then
         strList.AddObject(TComponent(ObjOwner).Components[i].Name,TComponent(ObjOwner).Components[i]);
     end;
   end;
  end;

  procedure GetComponents(objOwner: TObject; str: TStringList);
  var
    i: Integer;
    P: PInfoProperty;
    strList: TStringList;
    ct: TComponent;
  begin
    strList:=TStringList.Create;
    try
      FillComponents(objOwner,strList,PGIIP.DesignClassType);
      for i:=strList.Count-1 downto 0  do begin
        ct:=TComponent(strList.Objects[i]);
        New(P);
        FillChar(P^,SizeOf(P^),0);
        P.Param:=' : '+ct.ClassName+';';
        P.sType:=kwVAR;
        P.Color:=TTGII.ColorVar;
        if ct is TControl then P.sHint:=TControl(ct).Hint;
        str.Insert(0,ct.Name);
        str.Objects[0]:=TObject(P);
      end;
    finally
      strList.Free;
    end;
  end;

  procedure ViewIdentiferByStr(str: TStringList);
  var
    i: Integer;
    P: PInfoProperty;
  begin
    for i:=0 to str.Count-1 do begin
      P:=PInfoProperty(str.Objects[i]);
      ViewIdentifer(@TTGII,P.sType,str.Strings[i],P.Param,'',P.sHint,P.Color);
      Dispose(P);
    end;
  end;

  procedure GetProps;
  var
    obj,nextobj: TObject;
    cls: TClass;
    CurClass: TClass;
    tmpObj: TObject;
    i: Integer;

    str: TStringList;
    strCV: TStringList;
    strC: TStringList;

    val: Integer;
    FlagNext: Boolean;
  begin
    if TTGII.Identifers.Count=0 then exit;
    if TTGII.Identifers.Count=1 then begin
      if not (TTGII.LastTyp in [ttPoint]) then exit;
    end else begin
      if not (TTGII.LastTyp in [ttPoint,ttIdentifer]) then exit;
    end;
    str:=TStringList.Create;
    str.Duplicates:=dupIgnore;
    str.Sorted:=true;
    strCV:=TStringList.Create;
    strC:=TStringList.Create;
    try
      cls:=nil;
      obj:=GetInterpreterVarObjectByName(TTGII.Identifers.Strings[0]);
      if obj=nil then begin
        cls:=GetInterpreterClassByName(TTGII.Identifers.Strings[0]);
        if cls=nil then exit;
      end;
      if obj<>nil then begin
       nextObj:=obj;
       CurClass:=nextObj.ClassType;
      end else begin
       nextObj:=nil;
       CurClass:=cls;
      end;
      if TTGII.Identifers.Count=1 then begin
        if TTGII.LastTyp=ttIdentifer then GetObjectProps(CurClass,str,nextObj=nil)
        else begin
          if nextObj<>nil then GetComponents(nextObj,strCV);
          GetObjectProps(CurClass,str,nextObj=nil);
        end;
        exit;
      end else begin
        for i:=1 to TTGII.Identifers.Count-1 do begin
          val:=-1;
          if nextObj<>nil then begin
            FillComponents(nextObj,strC,PGIIP.DesignClassType);
            val:=strC.IndexOf(TTGII.Identifers.Strings[i]);
          end;
          if val<>-1 then begin
            if (TTGII.LastTyp=ttPoint) then begin
              nextObj:=strC.Objects[val];
              CurClass:=nextObj.ClassType;
            end else begin
              if i<TTGII.Identifers.Count-1 then begin
                nextObj:=strC.Objects[val];
                CurClass:=nextObj.ClassType;
              end;  
            end;
          end else begin

            try
              FlagNext:=IsPublishedProp(CurClass,TTGII.Identifers.Strings[i]);
            except
              FlagNext:=false;
            end;

            if FlagNext then begin
             if PropIsType(CurClass,TTGII.Identifers.Strings[i],tkClass) then begin
               if nextObj<>nil then begin
                 if (TTGII.LastTyp=ttPoint) then begin
                   tmpObj:=TObject(GetOrdProp(nextObj,TTGII.Identifers.Strings[i]));
                   if tmpObj<>nil then begin
                     nextobj:=tmpObj;
                     CurClass:=nextObj.ClassType;
                   end else break;
                 end else begin
                  if i<TTGII.Identifers.Count-1 then begin
                    tmpObj:=TObject(GetOrdProp(nextObj,TTGII.Identifers.Strings[i]));
                    if tmpObj<>nil then begin
                      nextobj:=tmpObj;
                      CurClass:=nextObj.ClassType;
                    end else break;
                  end;
                 end;
               end else begin
                if (TTGII.LastTyp=ttPoint) then
                  if i=TTGII.Identifers.Count-1 then break;
               end;
             end else begin
               if (TTGII.LastTyp=ttPoint) then
                 if i=TTGII.Identifers.Count-1 then break;
             end;
            end else begin
              if (TTGII.LastTyp=ttPoint) then
                if i=TTGII.Identifers.Count-1 then break;
            end;

          end;
          if (i=TTGII.Identifers.Count-1) then begin
            if (obj=nextObj)and(TTGII.LastTyp=ttIdentifer) then
              if nextObj<>nil then GetComponents(nextObj,strCV);
            GetObjectProps(CurClass,str,nextObj=nil);
          end;
        end;
      end;

    finally
      strC.Free;

      isGetProp:=(strCV.Count<>0)or(str.Count<>0);

      ViewIdentiferByStr(strCV);
      strCV.Free;

      str.Sort;
      ViewIdentiferByStr(str);
      str.Free;
    end;
  end;

  procedure GetVars;
  begin
    _GetInterpreterVars(@TTGII,GetInterpreterVar);
  end;

  procedure GetFuns;
  begin
    _GetInterpreterFuns(@TTGII,GetInterpreterFun);
  end;

  procedure GetConsts;
  begin
    _GetInterpreterConsts(@TTGII,GetInterpreterConst);
  end;

  procedure GetClasses;
  begin
    _GetInterpreterClasses(@TTGII,GetInterpreterClass);
  end;

  procedure ClearIdentifers(Index: Integer; Identifers: TStringList);
  var
    PIdentifer: PTempIdentifer;
    i: Integer;
  begin
    if Index>Identifers.Count-1 then exit;
    for i:=Index downto 0 do begin
      PIdentifer:=PTempIdentifer(Identifers.Objects[i]);
      Dispose(PIdentifer);
      Identifers.Delete(i);
    end;
  end;

  procedure GetInterpreterIdentifersLocal;
  var
    Parser: TPrgParser;
    Token: string;
    Typ,PrevTyp: TTokenTyp;
    APos: Integer;
    Identifers: TStringList;
    PIdentifer: PTempIdentifer;
  begin
    isGetProp:=false;
    Parser:=TPrgParser.Create;
    Identifers:=TStringList.Create;
    TTGII.Identifers:=Identifers;
    TTGII.Code:=Copy(PGIIP.Code,1,PGIIP.Pos);
    try
      Parser.Source:=GetPrevWord(TTGII.Code,[';','=','>','<'],APos);
      PrevTyp:=ttSemicolon;
      while True do begin
        try
          Token:=Parser.Token;
          Typ:=TokenTyp(Token);
          case Typ of
            ttEmpty: break;
            ttIdentifer: begin
              New(PIdentifer);
              PIdentifer.PrevTyp:=PrevTyp;
              PIdentifer.Typ:=Typ;
              Identifers.AddObject(Token,TObject(PIdentifer));
            end;
            ttBegin: begin
              ClearIdentifers(Identifers.Count-1,Identifers);
            end;
            ttLB,ttRB,ttCol,ttLS,ttRS: ClearIdentifers(Identifers.Count-1,Identifers);
          end;
          PrevTyp:=Typ;
        except
          exit;
        end;
      end;
      TTGII.LastTyp:=PrevTyp;
      GetProps;
      if not isGetProp then begin
        GetVars;
        GetFuns;
        GetConsts;
        GetClasses;
      end;  

    finally
      ClearIdentifers(Identifers.Count-1,Identifers);
      Identifers.Free;
      Parser.Free;
    end;
  end;

begin
  if not isValidPointer(PGIIP) then exit;
  if Trim(PGIIP.Code)='' then exit;
  if not isValidPointer(PGIIP.DesignClassType) then exit; 
  FillChar(TTGII,SizeOf(TTGII),0);
  TTGII.Owner:=Owner;
  TTGII.ColorVar:=PGIIP.ColorVar;
  TTGII.ColorProcedure:=PGIIP.ColorProcedure;
  TTGII.ColorFunction:=PGIIP.ColorFunction;
  TTGII.ColorType:=PGIIP.ColorType;
  TTGII.ColorProperty:=PGIIP.ColorProperty;
  TTGII.ColorConst:=PGIIP.ColorConst;
  TTGII.ColorBackGround:=PGIIP.ColorBackGround;
  TTGII.ColorCaption:=PGIIP.ColorCaption;
  TTGII.ColorParams:=PGIIP.ColorParams;
  TTGII.ColorHint:=PGIIP.ColorHint;
  TTGII.Proc:=PGIIP.GetInterpreterIdentiferItemProc;
  GetInterpreterIdentifersLocal;
end;

procedure CreateInterfaceInInterpreter(InterpreterHandle: THandle);
var
  ipas: TInterpreterPascal;
begin
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  ipas.CreateInterfaceInInterpreter;
end;

procedure ViewInterfaceInInterpreter(InterpreterHandle: THandle; Param: Pointer);
var
  ipas: TInterpreterPascal;
begin
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  ipas.ViewInterfaceInInterpreter;
end;

procedure RefreshInterfaceInInterpreter(InterpreterHandle: THandle; Param: Pointer);
var
  ipas: TInterpreterPascal;
begin
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  ipas.RefreshInterfaceInInterpreter;
end;

procedure CloseInterfaceInInterpreter(InterpreterHandle: THandle);
var
  ipas: TInterpreterPascal;
begin
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  ipas.CloseInterfaceInInterpreter;
end;

function ExecProcInterfaceInInterpreter(InterpreterHandle: THandle; Param: Pointer): Boolean;
var
  ipas: TInterpreterPascal;
begin
  Result:=false;
  if not IsValidInterpreter(InterpreterHandle) then exit;
  ipas:=TInterpreterPascal(InterpreterHandle);
  Result:=ipas.ExecProcInterfaceInInterpreter(Param);
end;

procedure ClearListMenuHandles;
var
  i: Integer;
  P: PInfoMenu;
begin
  for i:=0 to ListMenuHandles.Count-1 do begin
    P:=ListMenuHandles.Items[i];
    _FreeMenu(P.hMenu);
    Dispose(P);
  end;
  ListMenuHandles.Clear;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPJI: TParamJournalInterface;
  TPWI: TParamWizardInterface;
  TPDI: TParamDocumentInterface;
  TPSI: TParamServiceInterface;
  TPRI: TParamReportInterface;
  TPNI: TParamNoneInterface;
  P: PInfoMenu;
  PInterface: PInfoInterface;
  tp: TTypeInterface;
  CurrPointer: Pointer;
begin
  P:=GetMenuInfoByHandle(MenuHandle);
  if P=nil then exit;
  if not VarIsNull(P.TypeInterface) then begin
    tp:=P.TypeInterface;
    CurrPointer:=nil;
    case tp of
      ttiNone: begin
        FillChar(TPNI,SizeOf(TPNI),0);
        CurrPointer:=@TPNI;
      end;
      ttiRBook: begin
        FillChar(TPRBI,SizeOf(TPRBI),0);
        CurrPointer:=@TPRBI;
      end;
      ttiReport: begin
        FillChar(TPRI,SizeOf(TPRI),0);
        CurrPointer:=@TPRI;
      end;
      ttiWizard: begin
        FillChar(TPWI,SizeOf(TPWI),0);
        CurrPointer:=@TPWI;
      end;
      ttiJournal: begin
        FillChar(TPJI,SizeOf(TPJI),0);
        CurrPointer:=@TPJI;
      end;
      ttiService: begin
        FillChar(TPSI,SizeOf(TPSI),0);
        CurrPointer:=@TPSI;
      end;
      ttiDocument: begin
        FillChar(TPDI,SizeOf(TPDI),0);
        CurrPointer:=@TPDI;
      end;
    end;
    PInterface:=GetInterfaceInfoByInterfaceId(P.Interface_id);
    if PInterface<>nil then begin
     ViewInterface(PInterface.hInterface,CurrPointer);
    end;
  end;
end;

function GetMenuInfoByHandle(hMenu: THandle): PInfoMenu;
var
  i: Integer;
  P: PInfoMenu;
begin
  Result:=nil;
  for i:=0 to ListMenuHandles.Count-1 do begin
    P:=ListMenuHandles.Items[i];
    if P.hMenu=hMenu then begin
      Result:=P;
      exit;
    end;
  end;
end;

function GetMenuInfoByMenuId(Menu_id: Integer): PInfoMenu;
var
  i: Integer;
  P: PInfoMenu;
begin
  Result:=nil;
  for i:=0 to ListMenuHandles.Count-1 do begin
    P:=ListMenuHandles.Items[i];
    if P.Menu_id=Menu_id then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure AddToListMenuRootHandles;

  function CreateMenuLocal(ParentHandle: THandle; Name: PChar;
                           Hint: PChar;
                           TypeCreateMenu: TTypeCreateMenu=tcmAddLast;
                           InsertMenuHandle: THandle=MENU_INVALID_HANDLE;
                           ShortCut: TShortCut=0;
                           Image: TBitmap=nil;
                           ChangePrevious: Boolean=false): THandle;
  var
   CMLocal: TCreateMenu;
  begin
    FillChar(CMLocal,SizeOf(TCreateMenu),0);
    CMLocal.Name:=Name;
    CMLocal.Hint:=Hint;
    CMLocal.MenuClickProc:=MenuClickProc;
    CMLocal.ShortCut:=ShortCut;
    CMLocal.TypeCreateMenu:=TypeCreateMenu;
    CMLocal.InsertMenuHandle:=InsertMenuHandle;
    if not Image.Empty then
     CMLocal.Bitmap:=Image;
    CMLocal.ChangePrevious:=ChangePrevious;
    Result:=_CreateMenu(ParentHandle,@CMLocal);
  end;

  procedure FreeNonUseMenu;

    function ChildExists(Menu_id: Integer): Boolean;
    var
      i: Integer;
      PInfo: PInfoMenu;
    begin
      Result:=false;
      for i:=0 to ListMenuHandles.Count-1 do begin
        PInfo:=ListMenuHandles.Items[i];
        if PInfo.Parent_id=Menu_id then begin
          Result:=true;
          exit;
        end;
      end;
    end;

  var
    i: Integer;
    PInfo: PInfoMenu;
    PInterface: PInfoInterface;
  begin
    for i:=ListMenuHandles.Count-1 downto 0 do begin
      PInfo:=ListMenuHandles.Items[i];
      PInterface:=GetInterfaceInfoByInterfaceId(PInfo.Interface_id);
      if (PInterface=nil) then begin
       if not ChildExists(PInfo.Menu_id) then begin
        if PInfo.Name<>ConstsMenuSeparator then begin
          _FreeMenu(PInfo.hMenu);
          Dispose(PInfo);
          ListMenuHandles.Delete(i);
        end;  
       end;  
      end;
    end;
  end;
  
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
  ms: TMemoryStream;
  changeflag: Boolean;
  hMenu: THandle;
  PInfo,PParent: PInfoMenu;
  Image: TBitmap;
  menu_id,parent_id: Integer;
  isCreate: Boolean;
  sname,shint: string;
  shortcut: TShortCut;
  hLast,hLastParent: THandle;
  TypeCreateMenu: TTypeCreateMenu;
  PInterface: PInfoInterface;
  CheckPerm: Boolean;
begin
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  ms:=TMemoryStream.Create;
  try
    qr.Database:=IBDB;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.ParamCheck:=false;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:='Select menu_id,m.interface_id,m.name,m.hint,m.shortcut,m.changeflag,'+
          'm.parent_id,m.image,i.interfacetype'+
          ' from '+tbMenu+' m left join '+
          tbInterface+' i on m.interface_id=i.interface_id'+
         ' where i.interpreterguid='+QuotedStr(LibraryInterpreterGUID)+
         ' or i.interpreterguid is null'+
         ' order by m.parent_id desc, m.sortvalue desc';
    qr.SQL.Text:=sqls;
    qr.Active:=true;
    qr.Last;
    if not qr.IsEmpty then begin
      Image:=TBitmap.Create;
      try
        hLast:=MENU_INVALID_HANDLE;
        hLastParent:=hLast;
        hMenu:=MENU_INVALID_HANDLE;
        while not qr.Bof do begin
          sname:=qr.FieldByName('name').AsString;
          menu_id:=qr.FieldByName('menu_id').AsInteger;
          parent_id:=qr.FieldByName('parent_id').AsInteger;
          shint:=qr.FieldByName('hint').AsString;
          shortcut:=TShortCut(qr.FieldByName('shortcut').AsInteger);
          changeflag:=Boolean(qr.FieldByName('changeflag').AsInteger);
          ms.Clear;
          TBlobField(qr.FieldByName('image')).SaveToStream(ms);
          ms.Position:=0;
          try
          Image.LoadFromStream(ms);
          except
          end;
          PParent:=GetMenuInfoByMenuId(parent_id);
          isCreate:=false;
          PInterface:=GetInterfaceInfoByInterfaceId(qr.FieldByName('interface_id').AsInteger);
          CheckPerm:=true;
          if PInterface<>nil then
            CheckPerm:=_isPermissionOnInterface(PInterface.hInterface,ttiaView);
          if CheckPerm then
            if PParent=nil then begin
              if hLast=MENU_INVALID_HANDLE then TypeCreateMenu:=tcmAddFirst
              else TypeCreateMenu:=tcmInsertAfter;
              hMenu:=CreateMenuLocal(MENU_ROOT_HANDLE,PChar(sname),PChar(shint),
                                     TypeCreateMenu,hLast,shortcut,Image,ChangeFlag);
              if hMenu<>MENU_INVALID_HANDLE then isCreate:=true;
            end else begin
              if hLastParent<>PParent.hMenu then begin
                hLast:=MENU_INVALID_HANDLE;
                TypeCreateMenu:=tcmAddFirst;
              end else begin
                TypeCreateMenu:=tcmInsertAfter;
              end;
              hMenu:=CreateMenuLocal(PParent.hMenu,PChar(sname),PChar(shint),
                                     TypeCreateMenu,hLast,shortcut,Image,ChangeFlag);
              if hMenu<>MENU_INVALID_HANDLE then isCreate:=true;
              hLastParent:=PParent.hMenu;
            end;
          if isCreate then begin
            hLast:=hMenu;
            New(PInfo);
            FillChar(PInfo^,SizeOf(PInfo^),0);
            PInfo.Menu_id:=menu_id;
            PInfo.Interface_id:=qr.FieldByName('interface_id').AsInteger;
            if PParent<>nil then PInfo.Parent_id:=PParent.Menu_id;
            PInfo.hMenu:=hMenu;
            PInfo.TypeInterface:=qr.FieldByName('interfacetype').Value;
            PInfo.Name:=sname;
            ListMenuHandles.Add(PInfo);
          end;
          qr.Prior;
        end;
      finally
        Image.Free;
      end;
    end;
    FreeNonUseMenu;
  finally
    ms.Free;
    tran.free;
    qr.free;
  end;  
end;

procedure ClearListToolBarHandles;
var
  i,j: Integer;
  P: PInfoToolbar;
  PToolButton: PInfoToolButton;
begin
  for i:=0 to ListToolBarHandles.Count-1 do begin
    P:=ListToolBarHandles.Items[i];
    _FreeToolBar(P.hToolbar);
    for j:=0 to P.ListToolButtons.Count-1 do begin
     PToolButton:=P.ListToolButtons.Items[j];
     Dispose(PToolButton);
    end;
    P.ListToolButtons.Free;
    Dispose(P);
  end;
  ListToolBarHandles.Clear;
end;

function GetToolButtonInfoByHandle(hToolButton: THandle): PInfoToolButton;
var
  i,j: Integer;
  P: PInfoToolButton;
  PToolbar: PInfoToolBar;
begin
  Result:=nil;
  for i:=0 to ListToolBarHandles.Count-1 do begin
    PToolbar:=ListToolBarHandles.Items[i];
    for j:=0 to PToolbar.ListToolButtons.Count-1 do begin
      P:=PToolbar.ListToolButtons.Items[j];
      if P.hToolButton=hToolButton then begin
        Result:=P;
        exit;
      end;
    end;
  end;
end;

procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPJI: TParamJournalInterface;
  TPWI: TParamWizardInterface;
  TPDI: TParamDocumentInterface;
  TPSI: TParamServiceInterface;
  TPRI: TParamReportInterface;
  P: PInfoToolButton;
  PInterface: PInfoInterface;
  tp: TTypeInterface;
  CurrPointer: Pointer;
begin
  P:=GetToolButtonInfoByHandle(ToolButtonHandle);
  if P=nil then exit;
  if not VarIsNull(P.TypeInterface) then begin
    tp:=P.TypeInterface;
    CurrPointer:=nil;
    case tp of
      ttiNone: CurrPointer:=nil;
      ttiRBook: begin
        FillChar(TPRBI,SizeOf(TPRBI),0);
        CurrPointer:=@TPRBI;
      end;
      ttiReport: begin
        FillChar(TPRI,SizeOf(TPRI),0);
        CurrPointer:=@TPRI;
      end;
      ttiWizard: begin
        FillChar(TPWI,SizeOf(TPWI),0);
        CurrPointer:=@TPWI;
      end;
      ttiJournal: begin
        FillChar(TPJI,SizeOf(TPJI),0);
        CurrPointer:=@TPJI;
      end;
      ttiService: begin
        FillChar(TPSI,SizeOf(TPSI),0);
        CurrPointer:=@TPSI;
      end;
      ttiDocument: begin
        FillChar(TPDI,SizeOf(TPDI),0);
        CurrPointer:=@TPDI;
      end;
    end;
    PInterface:=GetInterfaceInfoByInterfaceId(P.Interface_id);
    if PInterface<>nil then begin
     ViewInterface(PInterface.hInterface,CurrPointer);
    end;
  end;
end;

procedure AddToListToolBarHandles;

  function CreateToolBarLocal(Name,Hint: PChar;
                              ShortCut: TShortCut;
                              Visible: Boolean=true;
                              Position: TToolBarPosition=tbpTop): THandle;
  var
    CTBLocal: TCreateToolBar;
  begin
    FillChar(CTBLocal,SizeOf(TCreateToolBar),0);
    CTBLocal.Name:=Name;
    CTBLocal.Hint:=Hint;
    CTBLocal.ShortCut:=ShortCut;
    CTBLocal.Visible:=Visible;
    CTBLocal.Position:=Position;
    Result:=_CreateToolBar(@CTBLocal);
  end;

  function CreateToolButtonLocal(TH: THandle; Name,Hint: PChar;
                                 Image: TBitmap=nil; 
                                 Style: TToolButtonStyleEx=tbseButton;
                                 ShortCut: TShortCut=0;
                                 Control: TControl=nil): THandle;
  var
   CTBLocal: TCreateToolButton;
  begin
   FillChar(CTBLocal,SizeOf(TCreateToolButton),0);
   CTBLocal.Name:=Name;
   CTBLocal.Hint:=Hint;
   if not Image.Empty then
     CTBLocal.Bitmap:=Image;
   CTBLocal.ToolButtonClickProc:=ToolButtonClickProc;
   CTBLocal.Style:=Style;
   CTBLocal.ShortCut:=ShortCut;
   CTBLocal.Control:=Control;
   Result:=_CreateToolButton(TH,@CTBLocal);
  end;

  procedure FreeNonUseToolbar;
  var
    i: Integer;
    P: PInfoToolbar;
  begin
    for i:=ListToolBarHandles.Count-1 downto 0 do begin
      P:=ListToolBarHandles.Items[i];
      if (P.ListToolButtons.Count=0)
          then begin
        _FreeToolBar(P.hToolbar);
        P.ListToolButtons.Free;
        Dispose(P);
        ListToolBarHandles.Delete(i);
      end;
    end;
  end;

var
  qr: TIBQuery;
  tran: TIBTransaction;
  ms: TMemoryStream;
  sqls: string;
  Image: TBitmap;
  hToolbar: THandle;
  tname,thint: string;
  tbname,tbhint: string;
  toolbar_id,lasttoolbar_id: Integer;
  tbarshortcut,tbutshortcut: TShortCut;
  PInterface: PInfoInterface;
  CheckPerm: Boolean;
  PInfo: PInfoToolBar;
  hToolButton: THandle;
  PToolButton: PInfoToolButton;
  Style: TToolButtonStyleEx;
  i: Integer; 
begin
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  ms:=TMemoryStream.Create;
  try
    qr.Database:=IBDB;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.ParamCheck:=false;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:='Select t.toolbar_id,t.name as toolbarname,t.hint as toolbarhint,t.shortcut as toolbarshortcut,'+
          'tb.toolbutton_id,tb.interface_id,tb.name as toolbuttonname,tb.hint as toolbuttonhint,tb.shortcut as toolbuttonshortcut,'+
          'tb.image,tb.style,i.interfacetype'+
          ' from '+tbToolbar+' t '+
          'join '+tbToolbutton+' tb on t.toolbar_id=tb.toolbar_id left '+
          'join '+tbInterface+' i on tb.interface_id=i.interface_id'+
         ' where i.interpreterguid='+QuotedStr(LibraryInterpreterGUID)+
         ' or i.interpreterguid is null'+
         ' order by t.name, tb.sortvalue';
    qr.SQL.Text:=sqls;
    qr.Active:=true;
    qr.First;
    if not qr.IsEmpty then begin
      Image:=TBitmap.Create;
      try
        hToolbar:=TOOLBAR_INVALID_HANDLE;
        lasttoolbar_id:=-1;
        PInfo:=nil;
        while not qr.Eof do begin
          toolbar_id:=qr.FieldByName('toolbar_id').AsInteger;
          if toolbar_id<>lasttoolbar_id then begin
            tname:=qr.FieldByName('toolbarname').AsString;
            thint:=qr.FieldByName('toolbarhint').AsString;
            tbarshortcut:=qr.FieldByName('toolbarshortcut').AsInteger;
            hToolbar:=CreateToolBarLocal(PChar(tname),PChar(thint),tbarshortcut);
            if hToolbar<>TOOLBAR_INVALID_HANDLE then begin
             New(PInfo);
             FillChar(PInfo^,SizeOf(PInfo^),0);
             PInfo.Toolbar_id:=toolbar_id;
             PInfo.hToolbar:=hToolbar;
             PInfo.ListToolButtons:=TList.Create;
             ListToolBarHandles.Add(PInfo);
            end;
          end; 
          if hToolbar<>TOOLBAR_INVALID_HANDLE then begin
            PInterface:=GetInterfaceInfoByInterfaceId(qr.FieldByName('interface_id').AsInteger);
            CheckPerm:=true;
            if PInterface<>nil then
              CheckPerm:=_isPermissionOnInterface(PInterface.hInterface,ttiaView);
            if CheckPerm then begin
              tbname:=qr.FieldByName('toolbuttonname').AsString;
              tbhint:=qr.FieldByName('toolbuttonhint').AsString;
              tbutshortcut:=qr.FieldByName('toolbuttonshortcut').AsInteger;
              style:=TToolButtonStyleEx(qr.FieldByName('style').AsInteger);
              ms.Clear;
              TBlobField(qr.FieldByName('image')).SaveToStream(ms);
              ms.Position:=0;
              try
              Image.LoadFromStream(ms);
              except
              end;
              hToolButton:=CreateToolButtonLocal(hToolbar,PChar(tbname),PChar(tbhint),Image,style,tbutshortcut);
              if hToolButton<>TOOLBUTTON_INVALID_HANDLE then begin
                New(PToolButton);
                FillChar(PToolButton^,SizeOf(PToolButton^),0);
                PToolButton.ToolButton_id:=qr.FieldByName('toolbutton_id').AsInteger;
                PToolButton.hToolButton:=hToolButton;
                PToolButton.TypeInterface:=qr.FieldByName('interfacetype').Value;
                PToolButton.Interface_id:=qr.FieldByName('interface_id').AsInteger;
                PInfo.ListToolButtons.Add(PToolButton);
              end;  
            end;
          end;  
          lasttoolbar_id:=toolbar_id;
          qr.Next;
        end;
        for i:=0 to ListToolBarHandles.Count-1 do
          _RefreshToolBar(PInfoToolBar(ListToolBarHandles.Items[i]).hToolbar);
      finally
        Image.Free;
      end;
    end;
    FreeNonUseToolbar;
  finally
    ms.Free;
    tran.free;
    qr.free;
  end;  
end;

procedure ClearListInterfaceHandles;
var
  i: Integer;
  P: PInfoInterface;
begin
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    P:=ListInterfaceHandles.Items[i];
    _FreeInterface(P.hInterface);
    Dispose(P);
  end;
  ListInterfaceHandles.Clear;
end;

function GetInterfaceInfoByHandle(hInterface: THandle): PInfoInterface;
var
  i: Integer;
  P: PInfoInterface;
begin
  Result:=nil;
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    P:=ListInterfaceHandles.Items[i];
    if P.hInterface=hInterface then begin
      Result:=P;
      exit;
    end;
  end;
end;

function GetInterfaceInfoByInterfaceId(Interface_id: Integer): PInfoInterface;
var
  i: Integer;
  P: PInfoInterface;
begin
  Result:=nil;
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    P:=ListInterfaceHandles.Items[i];
    if P.Interface_id=Interface_id then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure AddToListInterfaceHandles;

  function CreateLocalInterface(Name,Hint: PChar;
                                TypeInterface: TTypeInterface=ttiRBook;
                                ChangePrevious: Boolean=false;
                                AutoRun: Boolean=false): THandle;
  var
    TPCI: TCreateInterface;                       
  begin
    FillChar(TPCI,SizeOf(TCreateInterface),0);
    TPCI.Name:=Name;
    TPCI.Hint:=Hint;
    TPCI.ViewInterface:=ViewInterface;
    TPCI.RefreshInterface:=RefreshInterface;
    TPCI.CloseInterface:=CloseInterface;
    TPCI.ExecProcInterface:=ExecProcInterface;
    TPCI.TypeInterface:=TypeInterface;
    TPCI.ChangePrevious:=ChangePrevious;
    TPCI.AutoRun:=AutoRun;
    Result:=_CreateInterface(@TPCI);
  end;

  function CreateLocalPermission(InterfaceHandle: THandle;
                                 DBObject: PChar;
                                 DBPermission: TTypeDBPermission=ttpSelect;
                                 DBSystem: Boolean=false;
                                 Action: TTypeInterfaceAction=ttiaView): Boolean;
  var
     TCPFI: TCreatePermissionForInterface;
  begin
     FillCHar(TCPFI,SizeOf(TCreatePermissionForInterface),0);
     TCPFI.Action:=Action;
     TCPFI.DBObject:=DBObject;
     TCPFI.DBPermission:=DBPermission;
     TCPFI.DBSystem:=DBSystem;
     Result:=_CreatePermissionForInterface(InterfaceHandle,@TCPFI);
  end;

  procedure CreateLocalPermissions(PInfo: PInfoInterface);
  var
    TPRBI: TParamRBookInterface;
    i,StartInc,EndInc: Integer;
    dbObject: string;
    DbPermission: TTypeDbpermission;
    Action: TTypeInterfaceAction;
  begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.SQL.Select:=PChar('Select * from '+tbInterfacePermission+' where interface_id='+inttostr(PInfo.Interface_id));
    if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
      GetStartAndEndByPRBI(@TPRBI,StartInc,EndInc);
      for i:=StartInc to EndInc do begin
        dbObject:=GetValueByPRBI(@TPRBI,i,'dbObject');
        DbPermission:=TTypeDBPermission(GetValueByPRBI(@TPRBI,i,'permission'));
        Action:=TTypeInterfaceAction(GetValueByPRBI(@TPRBI,i,'interfaceaction'));
        CreateLocalPermission(PInfo.hInterface,PChar(dbObject),DbPermission,false,Action);
      end;
    end;
  end;

var
  TPRBI: TParamRBookInterface;
  i,StartInc,EndInc: Integer;
  sname,shint: string;
  changeflag,autorun: Boolean;
  TypeInterface: TTypeInterface;
  hInterface: THandle;
  PInfo: PInfoInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.SQL.Select:=PChar('Select interface_id,name,hint,changeflag,interfacetype,priority,autoflag from '+
                          tbInterface+' where interpreterguid='+QuotedStr(LibraryInterpreterGUID)+
                          ' order by priority');
  if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,StartInc,EndInc);
    for i:=StartInc to EndInc do begin
      sname:=GetValueByPRBI(@TPRBI,i,'name');
      shint:=GetValueByPRBI(@TPRBI,i,'hint');
      changeflag:=GetValueByPRBI(@TPRBI,i,'changeflag');
      autorun:=GetValueByPRBI(@TPRBI,i,'autoflag');
      TypeInterface:=TTypeInterface(GetValueByPRBI(@TPRBI,i,'interfacetype'));
      hInterface:=CreateLocalInterface(PChar(sname),PChar(shint),TypeInterface,changeflag,autorun);
      if hInterface<>INTERFACE_INVALID_HANDLE then begin
        New(PInfo);
        FillChar(PInfo^,SizeOf(PInfo^),0);
        PInfo.Interface_id:=GetValueByPRBI(@TPRBI,i,'interface_id');
        PInfo.TypeInterface:=TypeInterface;
        PInfo.Priority:=GetValueByPRBI(@TPRBI,i,'priority');
        PInfo.hInterface:=hInterface;
        PInfo.Name:=sname;
        ListInterfaceHandles.Add(PInfo);
        CreateLocalPermissions(PInfo);
      end;
    end;
  end;
end;

procedure MessageInterpreterProc(Owner: Pointer; InterpreterHandle: THandle; TypeMessage: TTypeMessageInterpreterProc;
                                 Line,Pos: Integer; UnitName,Message: PChar); stdcall;
var
  TCLI: TCreateLogItem;
  P: PInfoInterface;
begin
  if not isValidPointer(Owner) then exit; 
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  FillChar(TCLI,SizeOf(TCLI),0);
  TCLI.Text:=PChar(Format(fmtInterfaceNameMessage,[P.Name,Message]));
  case TypeMessage of
    tmiWarning: TCLI.TypeLogItem:=tliWarning;
    tmiHint: TCLI.TypeLogItem:=tliInformation;
    tmiError: TCLI.TypeLogItem:=tliError;
    tmiOk: ;
  end;
  _CreateLogItem(@TCLI);
end;

function GetInterfaceCodeByInterfaceId(Interface_id: Integer): string;
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
begin
  Result:='';
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    qr.Database:=IBDB;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.ParamCheck:=false;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:='Select code from '+tbInterface+' where interface_id='+inttostr(Interface_id);
    qr.SQL.Text:=sqls;
    qr.Active:=true;
    qr.First;
    if not qr.IsEmpty then begin
      Result:=TBlobField(qr.FieldByName('code')).AsString;
    end;
  finally
    tran.free;
    qr.free;
  end;  
end;

procedure GetInterpreterUnitsProc(Owner,ProcOwner: Pointer; Proc: TGetInterpreterUnitProc); stdcall;
var
  TGIU: TGetInterpreterUnit;
  P: PInfoInterface;
begin
  if not isValidPointer(@Proc) then exit;
  if not isValidPointer(Owner) then exit;
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  FillChar(TGIU,SizeOf(TGIU),0);
  TGIU.Code:=PChar(GetInterfaceCodeByInterfaceId(P.Interface_id));
  Proc(ProcOwner,@TGIU);
end;

procedure GetInterpreterFormsProc(Owner,ProcOwner: Pointer; Proc: TGetInterpreterFormProc); stdcall;
var
  TGIF: TGetInterpreterForm;
  P: PInfoInterface;
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
begin
  if not isValidPointer(@Proc) then exit;
  if not isValidPointer(Owner) then exit;
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    qr.Database:=IBDB;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.ParamCheck:=false;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:='Select form from '+tbInterfaceForm+' where interface_id='+inttostr(P.Interface_id);
    qr.SQL.Text:=sqls;
    qr.Active:=true;
    qr.First;
    while not qr.Eof do begin
      FillChar(TGIF,SizeOf(TGIF),0);
      TGIF.Form:=PChar(TBlobField(qr.FieldByName('form')).AsString);
      Proc(ProcOwner,@TGIF);
      qr.Next;
    end;
  finally
    tran.free;
    qr.free;
  end;  
end;

procedure GetInterpreterDocumentsProc(Owner,ProcOwner: Pointer; Proc: TGetInterpreterDocumentProc); stdcall;
var
  TGID: TGetInterpreterDocument;
  P: PInfoInterface;
  qr: TIBQuery;
  tran: TIBTransaction;
  isBreak: Boolean;
  sqls: string;
  ms: TMemoryStream;
begin
  if not isValidPointer(@Proc) then exit;
  if not isValidPointer(Owner) then exit;
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  ms:=TMemoryStream.Create;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
    qr.Database:=IBDB;
    tran.AddDatabase(IBDB);
    IBDB.AddTransaction(tran);
    tran.Params.Text:=DefaultTransactionParamsTwo;
    qr.ParamCheck:=false;
    qr.Transaction:=tran;
    qr.Transaction.Active:=true;
    sqls:='Select name,document,oleclass from '+tbInterfaceDocument+' where interface_id='+inttostr(P.Interface_id);
    qr.SQL.Text:=sqls;
    qr.Active:=true;
    qr.First;
    isBreak:=false;
    while not qr.Eof do begin
      if isBreak then Break;
      FillChar(TGID,SizeOf(TGID),0);
      TGID.DocumentName:=PChar(qr.FieldByName('name').AsString);
      ms.Clear;
      TBlobField(qr.FieldByName('document')).SaveToStream(ms);
      ms.Position:=0;
      TGID.DocumentSize:=ms.Size;
      TGID.Document:=ms.Memory;
      TGID.DocumentClass:=PChar(qr.FieldByName('oleclass').AsString);
      Proc(ProcOwner,@TGID,isBreak);
      qr.Next;
    end;
  finally
    tran.free;
    qr.free;
    ms.Free;
  end;
end;

procedure OnRunInterpreterProc(Owner: Pointer); stdcall;
var
  P: PInfoInterface;
begin
  if not isValidPointer(Owner) then exit;
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  _OnVisibleInterface(THandle(Owner),true);
  P.isRunning:=true;
end;

procedure OnResetInterpreterProc(Owner: Pointer); stdcall;
var
  P: PInfoInterface;
begin
  if not isValidPointer(Owner) then exit;
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  _OnVisibleInterface(THandle(Owner),false);
  P.isRunning:=false;
  FreeInterpreter(P.hInterpreter);
end;

procedure OnFreeInterpreterProc(Owner: Pointer); stdcall;
var
  P: PInfoInterface;
begin
  if not isValidPointer(Owner) then exit;
  P:=GetInterfaceInfoByHandle(THandle(Owner));
  if P=nil then exit;
  P.hInterpreter:=0;
end;

function RunInterpreterEx(P: PInfoInterface; Param: Pointer; isExecProc: Boolean; ExecProcParams: Pointer): Boolean;
var
  TCI: TCreateInterpreter;
  hInterpreter: THandle;
  TSIP: TSetInterpreterParam;
begin
  FillChar(TCI,SizeOf(TCI),0);
  hInterpreter:=CreateInterpreter(@TCI);
  P.hInterpreter:=hInterpreter;
  P.isRunning:=false;

  FillChar(TSIP,SizeOf(TSIP),0);
  TSIP.MessageProc:=MessageInterpreterProc;
  TSIP.GetUnitsProc:=GetInterpreterUnitsProc;
  TSIP.GetFormsProc:=GetInterpreterFormsProc;
  TSIP.GetDocumentsProc:=GetInterpreterDocumentsProc;
  TSIP.OnRunProc:=OnRunInterpreterProc;
  TSIP.OnResetProc:=OnResetInterpreterProc;
  TSIP.OnFreeProc:=OnFreeInterpreterProc;
  TSIP.hInterface:=P.hInterface;
  TSIP.Param:=Param;
  TSIP.isExecProc:=isExecProc;
  TSIP.ExecProcParams:=ExecProcParams;
  SetInterpreterParams(hInterpreter,Pointer(P.hInterface),@TSIP);

  Result:=RunInterpreter(hInterpreter);
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=GetInterfaceInfoByHandle(InterfaceHandle);
  if P=nil then exit;
  if P.isRunning then begin
   ViewInterfaceInInterpreter(P.hInterpreter,Param);
   Result:=true;
   exit;
  end;
  Result:=RunInterpreterEx(P,Param,false,nil);
end;

function RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=GetInterfaceInfoByHandle(InterfaceHandle);
  if P=nil then exit;
  if P.isRunning then begin
   RefreshInterfaceInInterpreter(P.hInterpreter,Param);
   Result:=true;
   exit;
  end; 
end;

function CloseInterface(InterfaceHandle: THandle): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=GetInterfaceInfoByHandle(InterfaceHandle);
  if P=nil then exit;
  if P.isRunning then begin
    CloseInterfaceInInterpreter(P.hInterpreter);
    Result:=ResetInterpreter(P.hInterpreter);
    exit;
  end;
end;

function ExecProcInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
var
  P: PInfoInterface;
begin
  Result:=false;
  P:=GetInterfaceInfoByHandle(InterfaceHandle);
  if P=nil then exit;
  if P.isRunning then begin
    Result:=ExecProcInterfaceInInterpreter(P.hInterpreter,Param);
    exit;
  end;
  Result:=RunInterpreterEx(P,nil,true,Param);
end;

// Some functions for interpreter

procedure Self_CreateDocumentByName(var Value: Variant; Args: TArguments);
begin
  if Args.Count=1 then
    Value:=GetInterpreterDocumentByName(Args.hInterpreter,Args.Values[0],false)
  else Value:=GetInterpreterDocumentByName(Args.hInterpreter,Args.Values[0],Args.Values[1]);
end;

procedure Self_GetInterfaceName(var Value: Variant; Args: TArguments);
begin
  Value:=GetInterpreterInterfaceName(Args.hInterpreter);
end;

procedure ClearListInterpreterFunHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterpreterFunHandles.Count-1 do begin
    _FreeInterpreterFun(THandle(ListInterpreterFunHandles.Items[i]));
  end;
  ListInterpreterFunHandles.Clear;
end;

procedure AddToListInterpreterFunHandles;

   function CreateInterpreterFunLocal(Identifer: PChar;
                                      Proc: TInterpreterReadProc;
                                      ProcParams: TArrOfInterpreterProcParam;
                                      ProcResultType: PInterpreterProcParam;
                                      Hint: PChar=nil): THandle;
   var
     TCIF: TCreateInterpreterFun;
     i: Integer;
   begin
     FillChar(TCIF,SizeOf(TCIF),0);
     TCIF.Identifer:=Identifer;
     TCIF.Proc:=Proc;
     for i:=Low(ProcParams) to High(ProcParams) do begin
      SetLength(TCIF.ProcParams,Length(TCIF.ProcParams)+1);
      TCIF.ProcParams[Length(TCIF.ProcParams)-1].ParamText:=ProcParams[i].ParamText;
      TCIF.ProcParams[Length(TCIF.ProcParams)-1].ParamType:=ProcParams[i].ParamType;
     end;
     if ProcResultType<>nil then
      TCIF.ProcResultType:=ProcResultType^;
     TCIF.Hint:=Hint;
     Result:=_CreateInterpreterFun(@TCIF);
     if Result<>INTERPRETERFUN_INVALID_HANDLE then
      ListInterpreterFunHandles.Add(Pointer(Result));
   end;

begin
  // Stbasis

  CreateInterpreterFunLocal('CreateDocumentByName',Self_CreateDocumentByName,ArrPP(['const Name',varString,'Visible: Boolean=false',varBoolean]),PP('Variant',varVariant),'������� �������� �� �����');
  CreateInterpreterFunLocal('GetInterfaceName',Self_GetInterfaceName,nil,PP('String',varString),'�������� ��� ����������');
end;
//********************* end of Internal *****************


//********************* Export *************************

procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
begin
  if P=nil then exit;
  P.Hint:=LibraryHint;
  P.TypeLib:=MainTypeLib;
  P.Programmers:=LibraryProgrammers;

  FSecurity.LoadDb;
  P.StopLoad:=not FSecurity.Check([sctInclination,sctRunCount]);
  P.Condition:=PChar(FSecurity.Condition);
  FSecurity.DecRunCount;
  FSecurity.SaveDb;
end;

procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;
begin
  IBDB:=IBDbase;
  IBT:=IBTran;
  IBDBSec:=IBDBSecurity;
  IBTSec:=IBTSecurity;
end;

procedure RefreshLibrary_;stdcall;
begin
 try
  Screen.Cursor:=crHourGlass;
  try

    /// Refresh ????????
     
    ClearListInterfaceHandles;
    AddToListInterfaceHandles;

    ClearListMenuHandles;
    AddToListMenuRootHandles;

    ClearListToolBarHandles;
    AddToListToolBarHandles;

    ClearListInterpreterFunHandles;
    AddToListInterpreterFunHandles;

  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//**************** end of Export *************************


end.