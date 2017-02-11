unit tsvClasses;

interface

uses Classes,SysUtils;

//type

(*TSVWriter = class(TWriter)
  private
    FRootAncestor: TComponent;
    FPropPath: string;
    FAncestorList: TList;
    FAncestorPos: Integer;
    FChildPos: Integer;
//  procedure WriteBuffer;
    procedure WriteData(Instance: TComponent); virtual; // linker optimization
  protected
    procedure WriteBinary(WriteData: TStreamProc);
    procedure WritePrefix(Flags: TFilerFlags; AChildPos: Integer);
    procedure WriteProperty(Instance: TPersistent; PropInfo: Pointer);
    procedure WriteProperties(Instance: TPersistent);
    procedure WritePropName(const PropName: string);
    procedure WriteValue(Value: TValueType);
  public
    destructor Destroy; override;
//  procedure FlushBuffer; override;
//  procedure Write(const Buf; Count: Longint);
    procedure WriteBoolean(Value: Boolean);
    procedure WriteCollection(Value: TCollection);
    procedure WriteComponent(Component: TComponent);
    procedure WriteChar(Value: Char);
    procedure WriteDescendent(Root: TComponent; AAncestor: TComponent);
    procedure WriteFloat(const Value: Extended);
    procedure WriteSingle(const Value: Single);
    procedure WriteCurrency(const Value: Currency);
    procedure WriteDate(const Value: TDateTime);
    procedure WriteIdent(const Ident: string);
    procedure WriteInteger(Value: Longint); overload;
    procedure WriteInteger(Value: Int64); overload;
    procedure WriteListBegin;
    procedure WriteListEnd;
    procedure WriteRootComponent(Root: TComponent);
    procedure WriteSignature;
    procedure WriteStr(const Value: string);
    procedure WriteString(const Value: string);
    procedure WriteWideString(const Value: WideString);
    property RootAncestor: TComponent read FRootAncestor write FRootAncestor;
  end;*)

implementation

{ TTSVWriter }

(*
destructor TTSVWriter.Destroy;
begin
//WriteBuffer;
  inherited Destroy;
end;

{rocedure TTSVWriter.FlushBuffer;
begin
//WriteBuffer;
end;

{rocedure TTSVWriter.Write(const Buf; Count: Longint); assembler;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EDX
        MOV     EBX,ECX
        MOV     EDI,EAX
        JMP     @@6
@@1:    MOV     ECX,[EDI].TTSVWriter.BufSize
        SUB     ECX,[EDI].TTSVWriter.BufPos
        JA      @@2
        MOV     EAX,EDI
        CALL    TTSVWriter.WriteBuffer
        MOV     ECX,[EDI].TTSVWriter.FBufSize
@@2:    CMP     ECX,EBX
        JB      @@3
        MOV     ECX,EBX
@@3:    SUB     EBX,ECX
        PUSH    EDI
        MOV     EAX,[EDI].TTSVWriter.FBuffer
        ADD     EAX,[EDI].TTSVWriter.FBufPos
        ADD     [EDI].TTSVWriter.FBufPos,ECX
@@5:    MOV     EDI,EAX
        MOV     EDX,ECX
        SHR     ECX,2
        CLD
        REP     MOVSD
        MOV     ECX,EDX
        AND     ECX,3
        REP     MOVSB
        POP     EDI
@@6:    OR      EBX,EBX
        JNE     @@1
        POP     EBX
        POP     EDI
        POP     ESI
end;}

procedure TTSVWriter.WriteBinary(WriteData: TStreamProc);
var
  Stream: TMemoryStream;
  Count: Longint;
begin
  Stream := TMemoryStream.Create;
  try
    WriteData(Stream);
    WriteValue(vaBinary);
    Count := Stream.Size;
    Write(Count, SizeOf(Count));
    Write(Stream.Memory^, Count);
  finally
    Stream.Free;
  end;
end;

{rocedure TTSVWriter.WriteBuffer;
begin
  Stream.WriteBuffer(FBuffer^, FBufPos);
  FBufPos := 0;
end;}

procedure TTSVWriter.WriteBoolean(Value: Boolean);
begin
  if Value then
    WriteValue(vaTrue) else
    WriteValue(vaFalse);
end;

procedure TTSVWriter.WriteChar(Value: Char);
begin
  WriteString(Value);
end;

procedure TTSVWriter.WriteCollection(Value: TCollection);
var
  I: Integer;
begin
  WriteValue(vaCollection);
  if Value <> nil then
    for I := 0 to Value.Count - 1 do
    begin
      WriteListBegin;
      WriteProperties(Value.Items[I]);
      WriteListEnd;
    end;
  WriteListEnd;
end;

procedure TTSVWriter.WriteComponent(Component: TComponent);

  function FindAncestor(const Name: string): TComponent;
  var
    I: Integer;
  begin
    for I := 0 to FAncestorList.Count - 1 do
    begin
      Result := FAncestorList[I];
      if SameText(Result.Name, Name) then Exit;
    end;
    Result := nil;
  end;

var
  OldAncestor: TPersistent;
  OldRootAncestor: TComponent;
  AncestorComponent: TComponent;
begin
{ OldAncestor := Ancestor;
  OldRootAncestor := RootAncestor;
  try
    Include(Component.ComponentState, csWriting);
    if Assigned(FAncestorList) then
      Ancestor := FindAncestor(Component.Name);
    if Assigned(FOnFindAncestor) and ((Ancestor = nil) or (Ancestor is
      TComponent)) then
    begin
      AncestorComponent := TComponent(Ancestor);
      FOnFindAncestor(Self, Component, Component.Name, AncestorComponent,
        FRootAncestor);
      Ancestor := AncestorComponent;
    end;
    Component.WriteState(Self);
    Exclude(Component.FComponentState, csWriting);
  finally
    Ancestor := OldAncestor;
    FRootAncestor := OldRootAncestor;
  end;        }
end;

procedure TTSVWriter.WriteData(Instance: TComponent);
var
  PreviousPosition, PropertiesPosition: Longint;
  OldAncestorList: TList;
  OldAncestorPos, OldChildPos: Integer;
  OldRoot, OldRootAncestor: TComponent;
  Flags: TFilerFlags;
begin
  if FBufSize - FBufPos < Length(Instance.ClassName) +
    Length(Instance.Name) + 1+5+3 then WriteBuffer;
     { Prefix + vaInt + integer + 2 end lists }
  PreviousPosition := Position;
  Flags := [];
  if csInline in Instance.ComponentState then
    if (Ancestor <> nil) and (csAncestor in Instance.ComponentState) and (FAncestorList <> nil) then
      // If the AncestorList is not nil, this really came from an ancestor form
      Include(Flags, ffInherited)
    else
      // otherwise the Ancestor is the original frame
      Include(Flags, ffInline)
  else if Ancestor <> nil then
    Include(Flags, ffInherited);
  if (FAncestorList <> nil) and (FAncestorPos < FAncestorList.Count) and
    ((Ancestor = nil) or (FAncestorList[FAncestorPos] <> Ancestor)) then
    Include(Flags, ffChildPos);
  WritePrefix(Flags, FChildPos);
  WriteStr(Instance.ClassName);
  WriteStr(Instance.Name);
  PropertiesPosition := Position;
  if (FAncestorList <> nil) and (FAncestorPos < FAncestorList.Count) then
  begin
    if Ancestor <> nil then Inc(FAncestorPos);
    Inc(FChildPos);
  end;
  WriteProperties(Instance);
  WriteListEnd;
  OldAncestorList := FAncestorList;
  OldAncestorPos := FAncestorPos;
  OldChildPos := FChildPos;
  OldRoot := FRoot;
  OldRootAncestor := FRootAncestor;
  try
    FAncestorList := nil;
    FAncestorPos := 0;
    FChildPos := 0;
    if not IgnoreChildren then
      try
        if (FAncestor <> nil) and (FAncestor is TComponent) then
        begin
          if (FAncestor is TComponent) and (csInline in TComponent(FAncestor).ComponentState) then
            FRootAncestor := TComponent(FAncestor);
          FAncestorList := TList.Create;
          TComponent(FAncestor).GetChildren(AddAncestor, FRootAncestor);
        end;
        if csInline in Instance.ComponentState then
          FRoot := Instance;
        Instance.GetChildren(WriteComponent, FRoot);
      finally
        FAncestorList.Free;
      end;
  finally
    FAncestorList := OldAncestorList;
    FAncestorPos := OldAncestorPos;
    FChildPos := OldChildPos;
    FRoot := OldRoot;
    FRootAncestor := OldRootAncestor;
  end;
  WriteListEnd;
  if (Instance <> Root) and (Flags = [ffInherited]) and
    (Position = PropertiesPosition + (1 + 1)) then { (1 + 1) is two end lists }
    Position := PreviousPosition;
end;

procedure TTSVWriter.WriteDescendent(Root: TComponent; AAncestor: TComponent);
begin
  FRootAncestor := AAncestor;
  FAncestor := AAncestor;
  FRoot := Root;
  FLookupRoot := Root;
  WriteSignature;
  WriteComponent(Root);
end;

procedure TTSVWriter.WriteFloat(const Value: Extended);
begin
  WriteValue(vaExtended);
  Write(Value, SizeOf(Extended));
end;

procedure TTSVWriter.WriteSingle(const Value: Single);
begin
  WriteValue(vaSingle);
  Write(Value, SizeOf(Single));
end;

procedure TTSVWriter.WriteCurrency(const Value: Currency);
begin
  WriteValue(vaCurrency);
  Write(Value, SizeOf(Currency));
end;

procedure TTSVWriter.WriteDate(const Value: TDateTime);
begin
  WriteValue(vaDate);
  Write(Value, SizeOf(TDateTime));
end;

procedure TTSVWriter.WriteIdent(const Ident: string);
begin
  if SameText(Ident, 'False') then WriteValue(vaFalse) else
  if SameText(Ident ,'True') then WriteValue(vaTrue) else
  if SameText(Ident ,'Null') then WriteValue(vaNull) else
  if SameText(Ident, 'nil') then WriteValue(vaNil) else
  begin
    WriteValue(vaIdent);
    WriteStr(Ident);
  end;
end;

procedure TTSVWriter.WriteInteger(Value: Longint);
begin
  if (Value >= Low(ShortInt)) and (Value <= High(ShortInt)) then
  begin
    WriteValue(vaInt8);
    Write(Value, SizeOf(Shortint));
  end else
  if (Value >= Low(SmallInt)) and (Value <= High(SmallInt)) then
  begin
    WriteValue(vaInt16);
    Write(Value, SizeOf(Smallint));
  end
  else
  begin
    WriteValue(vaInt32);
    Write(Value, SizeOf(Integer));
  end;
end;

procedure TTSVWriter.WriteInteger(Value: Int64);
begin
  if (Value >= Low(Integer)) and (Value <= High(Integer)) then
    WriteInteger(Longint(Value))
  else
  begin
    WriteValue(vaInt64);
    Write(Value, Sizeof(Int64));
  end;
end;

procedure TTSVWriter.WriteListBegin;
begin
  WriteValue(vaList);
end;

procedure TTSVWriter.WriteListEnd;
begin
  WriteValue(vaNull);
end;

procedure TTSVWriter.WritePrefix(Flags: TFilerFlags; AChildPos: Integer);
var
  Prefix: Byte;
begin
  if Flags <> [] then
  begin
    Prefix := $F0 or Byte(Flags);
    Write(Prefix, SizeOf(Prefix));
    if ffChildPos in Flags then WriteInteger(AChildPos);
  end;
end;

procedure TTSVWriter.WriteProperties(Instance: TPersistent);
var
  I, Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
begin
  Count := GetTypeData(Instance.ClassInfo)^.PropCount;
  if Count > 0 then
  begin
    GetMem(PropList, Count * SizeOf(Pointer));
    try
      GetPropInfos(Instance.ClassInfo, PropList);
      for I := 0 to Count - 1 do
      begin
        PropInfo := PropList^[I];
        if PropInfo = nil then break;
        if IsStoredProp(Instance, PropInfo) then
          WriteProperty(Instance, PropInfo);
      end;
    finally
      FreeMem(PropList, Count * SizeOf(Pointer));
    end;
  end;
  Instance.DefineProperties(Self);
end;

procedure TTSVWriter.WriteProperty(Instance: TPersistent; PropInfo: Pointer);
var
  PropType: PTypeInfo;

  function AncestorValid: Boolean;
  begin
    Result := (Ancestor <> nil) and ((Instance.ClassType = Ancestor.ClassType) or
      (Instance = Root));
  end;

  procedure WritePropPath;
  begin
    WritePropName(PPropInfo(PropInfo)^.Name);
  end;

  procedure WriteSet(Value: Longint);
  var
    I: Integer;
    BaseType: PTypeInfo;
  begin
    BaseType := GetTypeData(PropType)^.CompType^;
    WriteValue(vaSet);
    for I := 0 to SizeOf(TIntegerSet) * 8 - 1 do
      if I in TIntegerSet(Value) then WriteStr(GetEnumName(BaseType, I));
    WriteStr('');
  end;

  procedure WriteIntProp(IntType: PTypeInfo; Value: Longint);
  var
    Ident: string;
    IntToIdent: TIntToIdent;
  begin
    IntToIdent := FindIntToIdent(IntType);
    if Assigned(IntToIdent) and IntToIdent(Value, Ident) then
      WriteIdent(Ident)
    else
      WriteInteger(Value);
  end;

  procedure WriteCollectionProp(Collection: TCollection);
  var
    SavePropPath: string;
  begin
    WritePropPath;
    SavePropPath := FPropPath;
    try
      FPropPath := '';
      WriteCollection(Collection);
    finally
      FPropPath := SavePropPath;
    end;
  end;

  procedure WriteOrdProp;
  var
    Value: Longint;

    function IsDefaultValue: Boolean;
    begin
      if AncestorValid then
        Result := Value = GetOrdProp(Ancestor, PropInfo) else
        Result := Value = PPropInfo(PropInfo)^.Default;
    end;

  begin
    Value := GetOrdProp(Instance, PropInfo);
    if not IsDefaultValue then
    begin
      WritePropPath;
      case PropType^.Kind of
        tkInteger:
          WriteIntProp(PPropInfo(PropInfo)^.PropType^, Value);
        tkChar:
          WriteChar(Chr(Value));
        tkSet:
          WriteSet(Value);
        tkEnumeration:
          WriteIdent(GetEnumName(PropType, Value));
      end;
    end;
  end;

  procedure WriteFloatProp;
  var
    Value: Extended;

    function IsDefaultValue: Boolean;
    begin
      if AncestorValid then
        Result := Value = GetFloatProp(Ancestor, PropInfo) else
        Result := Value = 0;
    end;

  begin
    Value := GetFloatProp(Instance, PropInfo);
    if not IsDefaultValue then
    begin
      WritePropPath;
      WriteFloat(Value);
    end;
  end;

  procedure WriteInt64Prop;
  var
    Value: Int64;

    function IsDefaultValue: Boolean;
    begin
      if AncestorValid then
        Result := Value = GetInt64Prop(Ancestor, PropInfo) else
        Result := Value = 0;
    end;

  begin
    Value := GetInt64Prop(Instance, PropInfo);
    if not IsDefaultValue then
    begin
      WritePropPath;
      WriteInteger(Value);
    end;
  end;

  procedure WriteStrProp;
  var
    Value: string;

    function IsDefault: Boolean;
    begin
      if AncestorValid then
        Result := Value = GetStrProp(Ancestor, PropInfo) else
        Result := Value = '';
    end;

  begin
    Value := GetStrProp(Instance, PropInfo);
    if not IsDefault then
    begin
      WritePropPath;
      WriteString(Value);
    end;
  end;

  procedure WriteObjectProp;
  var
    Value: TObject;
    OldAncestor: TPersistent;
    SavePropPath, ComponentValue: string;

    function IsDefault: Boolean;
    var
      AncestorValue: TObject;
    begin
      AncestorValue := nil;
      if AncestorValid then
      begin
        AncestorValue := TObject(GetOrdProp(Ancestor, PropInfo));
        if (AncestorValue <> nil) and (TComponent(AncestorValue).Owner = FRootAncestor) and
          (Value <> nil) and (TComponent(Value).Owner = Root) and
          SameText(TComponent(AncestorValue).Name, TComponent(Value).Name) then
          AncestorValue := Value;
      end;
      Result := Value = AncestorValue;
    end;

    function GetComponentValue(Component: TComponent): string;
    begin
      if Component.Owner = LookupRoot then
        Result := Component.Name
      else if Component = LookupRoot then
        Result := 'Owner'                                                       { Do not translate }
      else if (Component.Owner <> nil) and (Component.Owner.Name <> '') and
        (Component.Name <> '') then
        Result := Component.Owner.Name + '.' + Component.Name
      else if Component.Name <> '' then
        Result := Component.Name + '.Owner'                                     { Do not translate }
      else Result := '';
    end;

  begin
    Value := TObject(GetOrdProp(Instance, PropInfo));
    if (Value = nil) and not IsDefault then
    begin
      WritePropPath;
      WriteValue(vaNil);
    end
    else if Value is TPersistent then
      if Value is TComponent then
      begin
        if not IsDefault then
        begin
          ComponentValue := GetComponentValue(TComponent(Value));
          if ComponentValue <> '' then
          begin
            WritePropPath;
            WriteIdent(ComponentValue);
          end
        end
      end else if Value is TCollection then
      begin
        if not AncestorValid or
          not CollectionsEqual(TCollection(Value),
            TCollection(GetOrdProp(Ancestor, PropInfo))) then
            WriteCollectionProp(TCollection(Value));
      end else
      begin
        OldAncestor := Ancestor;
        SavePropPath := FPropPath;
        try
          FPropPath := FPropPath + PPropInfo(PropInfo)^.Name + '.';
          if AncestorValid then
            Ancestor := TPersistent(GetOrdProp(Ancestor, PropInfo));
          WriteProperties(TPersistent(Value));
        finally
          Ancestor := OldAncestor;
          FPropPath := SavePropPath;
        end;
      end
  end;

  procedure WriteMethodProp;
  var
    Value: TMethod;

    function IsDefaultValue: Boolean;
    var
      DefaultCode: Pointer;
    begin
      DefaultCode := nil;
      if AncestorValid then DefaultCode := GetMethodProp(Ancestor, PropInfo).Code;
      Result := (Value.Code = DefaultCode) or
        ((Value.Code <> nil) and (FLookupRoot.MethodName(Value.Code) = ''));
    end;

  begin
    Value := GetMethodProp(Instance, PropInfo);
    if not IsDefaultValue then
    begin
      WritePropPath;
      if Value.Code = nil then
        WriteValue(vaNil) else
        WriteIdent(FLookupRoot.MethodName(Value.Code));
    end;
  end;

  procedure WriteVariantProp;
  var
    Value: Variant;

    function IsDefaultValue: Boolean;
    begin
      if AncestorValid then
        Result := Value = GetVariantProp(Ancestor, PropInfo) else
        Result := VarIsEmpty(Value);
    end;

  var
    VType: Integer;
  begin
    Value := GetVariantProp(Instance, PropInfo);
    if not IsDefaultValue then
    begin
      if VarIsArray(Value) then raise EWriteError.CreateRes(@SWriteError);
      WritePropPath;
      VType := VarType(Value);
      case VType and varTypeMask of
        varEmpty: WriteValue(vaNil);
        varNull: WriteValue(vaNull);
        varOleStr: WriteWideString(Value);
        varString: WriteString(Value);
        varByte, varSmallInt, varInteger: WriteInteger(Value);
        varSingle: WriteSingle(Value);
        varDouble: WriteFloat(Value);
        varCurrency: WriteCurrency(Value);
        varDate: WriteDate(Value);
        varBoolean:
          if Value then
            WriteValue(vaTrue) else
            WriteValue(vaFalse);
      else
        try
          WriteString(Value);
        except
          raise EWriteError.CreateRes(@SWriteError);
        end;
      end;
    end;
  end;

begin
  if (PPropInfo(PropInfo)^.SetProc <> nil) and
    (PPropInfo(PropInfo)^.GetProc <> nil) then
  begin
    PropType := PPropInfo(PropInfo)^.PropType^;
    case PropType^.Kind of
      tkInteger, tkChar, tkEnumeration, tkSet: WriteOrdProp;
      tkFloat: WriteFloatProp;
      tkString, tkLString, tkWString: WriteStrProp;
      tkClass: WriteObjectProp;
      tkMethod: WriteMethodProp;
      tkVariant: WriteVariantProp;
      tkInt64: WriteInt64Prop;
    end;
  end;
end;

procedure TTSVWriter.WritePropName(const PropName: string);
begin
  WriteStr(FPropPath + PropName);
end;

procedure TTSVWriter.WriteRootComponent(Root: TComponent);
begin
  WriteDescendent(Root, nil);
end;

procedure TTSVWriter.WriteSignature;
begin
  Write(FilerSignature, SizeOf(FilerSignature));
end;

procedure TTSVWriter.WriteStr(const Value: string);
var
  L: Integer;
begin
  L := Length(Value);
  if L > 255 then L := 255;
  Write(L, SizeOf(Byte));
  Write(Value[1], L);
end;

procedure TTSVWriter.WriteString(const Value: string);
var
  L: Integer;
begin
  L := Length(Value);
  if L <= 255 then
  begin
    WriteValue(vaString);
    Write(L, SizeOf(Byte));
  end else
  begin
    WriteValue(vaLString);
    Write(L, SizeOf(Integer));
  end;
  Write(Pointer(Value)^, L);
end;

procedure TTSVWriter.WriteWideString(const Value: WideString);
var
  L: Integer;
begin
  WriteValue(vaWString);
  L := Length(Value);
  Write(L, SizeOf(Integer));
  Write(Pointer(Value)^, L * 2);
end;

procedure TTSVWriter.WriteValue(Value: TValueType);
begin
  Write(Value, SizeOf(Value));
end;*)

end.
