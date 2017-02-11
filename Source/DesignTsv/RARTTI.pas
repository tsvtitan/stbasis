{***********************************************************
                R&A Library
              R&A Form Designer
       Copyright (C) 192001 Andrei Prygounkov

       class       : TRARTTIMaker
       description : create RTTI on the fly

       author      : Andrei Prygounkov
       e-mail      : a.prygounkov@gmx.de
       www         : http://ralib.hotbox.ru.htm
************************************************************}

{$INCLUDE RA.INC}

{$IFDEF RA_D3}
  {$DEFINE VMT_D3}
{$ENDIF RA_D3}
{$IFDEF RA_D4}
  {$DEFINE VMT_D4}
{$ENDIF RA_D4}
{$IFDEF RA_D5}
  {$DEFINE VMT_D4}
{$ENDIF RA_D5}
{$IFDEF RA_D6}
  {$DEFINE VMT_D4}
{$ENDIF RA_D5}


unit RARTTI;

interface

uses SysUtils, Classes;

const

  vmtOffset = vmtSelfPtr;

type

 {$IFDEF VMT_D3}
 { Delphi 3 only - not 2, not 4 }
  TVMT = packed record
		SelfPtr           : Pointer;    //  vmtSelfPtr           = -64;
		IntfTable         : Pointer;    //  vmtIntfTable         = -60;
		AutoTable         : Pointer;    //  vmtAutoTable         = -56;
		InitTable         : Pointer;    //  vmtInitTable         = -52;
		TypeInfo          : Pointer;    //  vmtTypeInfo          = -48;
		FieldTable        : Pointer;    //  vmtFieldTable        = -44;
		MethodTable       : Pointer;    //  vmtMethodTable       = -40;
		DynamicTable      : Pointer;    //  vmtDynamicTable      = -36;
		ClassName         : Pointer;    //  vmtClassName         = -32;
		InstanceSize      : Pointer;    //  vmtInstanceSize      = -28;
		Parent            : Pointer;    //  vmtParent            = -24;
		SafeCallException : Pointer;    //  vmtSafeCallException = -20;
		DefaultHandler    : Pointer;    //  vmtDefaultHandler    = -16;
		NewInstance       : Pointer;    //  vmtNewInstance       = -12;
		FreeInstance      : Pointer;    //  vmtFreeInstance      = -8;
		Destroy           : Pointer;    //  vmtDestroy           = -4;

		QueryInterface    : Pointer;    //  vmtQueryInterface    = 0;
    AddRef            : Pointer;    //  vmtAddRef            = 4;
    Release           : Pointer;    //  vmtRelease           = 8;
    CreateObject      : Pointer;    //  vmtCreateObject      = 12;
  end;
 {$ENDIF VMT_D3}

 {$IFDEF VMT_D4}
 { Delphi 4 and 5 only - not 2, not 3 }
  TVMT = packed record
    SelfPtr           : Pointer;    //  vmtSelfPtr           = -76;
    IntfTable         : Pointer;    //  vmtIntfTable         = -72;
    AutoTable         : Pointer;    //  vmtAutoTable         = -68;
    InitTable         : Pointer;    //  vmtInitTable         = -64;
    TypeInfo          : Pointer;    //  vmtTypeInfo          = -60;
    FieldTable        : Pointer;    //  vmtFieldTable        = -56;
    MethodTable       : Pointer;    //  vmtMethodTable       = -52;
    DynamicTable      : Pointer;    //  vmtDynamicTable      = -48;
    ClassName         : Pointer;    //  vmtClassName         = -44;
    InstanceSize      : Pointer;    //  vmtInstanceSize      = -40;
    Parent            : Pointer;    //  vmtParent            = -36;
    SafeCallException : Pointer;    //  vmtSafeCallException = -32;
    AfterConstruction : Pointer;    //  vmtAfterConstruction = -28;
    BeforeDestruction : Pointer;    //  vmtBeforeDestruction = -24;
    Dispatch          : Pointer;    //  vmtDispatch          = -20;
    DefaultHandler    : Pointer;    //  vmtDefaultHandler    = -16;
    NewInstance       : Pointer;    //  vmtNewInstance       = -12;
    FreeInstance      : Pointer;    //  vmtFreeInstance      = -8;
    Destroy           : Pointer;    //  vmtDestroy           = -4;

    QueryInterface    : Pointer;    //  vmtQueryInterface    = 0;
    AddRef            : Pointer;    //  vmtAddRef            = 4;
    Release           : Pointer;    //  vmtRelease           = 8;
    CreateObject      : Pointer;    //  vmtCreateObject      = 12;
  end;
 {$ENDIF VMT_D3}

  PVMT = ^TVMT;

  TMethodEntry = packed record
    Size: Word;
    Code: Pointer;
    Name: ShortString;
  end;
  PMethodEntry = ^TMethodEntry;

  TMethodTable = packed record
    EntryCount: Word;
    Entries: record end; // array[Word] of TMethodTableEntry;
  end;
  PMethodTable = ^TMethodTable;


  TRClass = packed record
    VMT: TVMT;
    VirtualTable: array[0..999] of Pointer;
    ClassName: ShortString;
  end;

  PPointer = ^Pointer;

  TRARTTIMaker = class(TComponent)
  private
    FClass: TClass;
  public
    RClass: TRClass;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure MakeClass(Ancestor: TObject);
    property CClass: TClass read FClass;
  end;

 // ERARTTIMakerError = class(Exception);

  function IncPtr(P: Pointer; i: Integer): Pointer;
  function GetVMT(Instance: TObject): PVMT;
  procedure ReadMethodTable(Obj: TObject; Ss: TStrings);

implementation


 { IncPtr - from Sergey Orlik book "Secrets of Delphi by examples" }
function IncPtr(P: Pointer; i: Integer): Pointer;
asm
        { ->    EAX P  }
        {       EDX i  }
        PUSH    EBX
        MOV     EBX, EAX
        ADD     EBX, EDX
        MOV     EAX, EBX
        POP     EBX
end;

function GetVMT(Instance: TObject): PVMT;
begin
  Result := Pointer(Instance.ClassType);
  Result := IncPtr(Result, vmtOffset);
end;

procedure ReadMethodTable(Obj: TObject; Ss: TStrings);
var
  I: Integer;
  VMT: PVMT;
  MethodTable: PMethodTable;
  P: Pointer;
  C: Word;
begin
  Ss.Clear;
  VMT := Pointer(Obj.ClassType);
  VMT := IncPtr(VMT, vmtOffset);
  MethodTable := VMT^.MethodTable;
  if MethodTable <> nil then
  begin
    C := MethodTable^.EntryCount;
    P := @MethodTable^.Entries;
    for i := 0 to C - 1 do    { Iterate }
    begin
      Ss.Add(IntToStr(Integer(TMethodEntry(P^).Code)) + ' = '
         + '"' + TMethodEntry(P^).Name + '"');
      P := IncPtr(P, 6 + Length(TMethodEntry(P^).Name) + 1);
    end;    { for }
  end;
end;    { ReadMethodTable }


{ TRARTTIMaker }

constructor TRARTTIMaker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;    { Create }

destructor TRARTTIMaker.Destroy;
begin
  inherited Destroy;
end;    { Destroy }

procedure TRARTTIMaker.MakeClass(Ancestor: TObject);
var
  AncestorVMT: PVMT;
  VirtualCount: Integer;
begin
  Assert(Ancestor <> nil);
  VirtualCount := 50;
 { copy VMT from Ancestor }
  AncestorVMT := GetVMT(Ancestor);
  Move(AncestorVMT^, RClass.VMT, sizeof(TVMT) + VirtualCount * 4);

 { change some fields }
  RClass.VMT.ClassName := @RClass.ClassName[0];
  RClass.ClassName := 'MyClass';
  RClass.VMT.Parent := AncestorVMT;

  FClass := @RClass.VMT.QueryInterface;
end;



end.
