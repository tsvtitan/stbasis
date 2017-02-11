unit tsvOtherEdit;

interface

uses classes,Windows, DsgnIntf, imglist, graphics;

type

  { TFilenameProperty }

  TFilenameProperty = class(TStringProperty)
  protected
    function GetFilter: string; virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  { TImageIndexProperty }

  TImageIndexProperty = class(TIntegerProperty)
  private
    FImages: TCustomImageList;
    function GetImages(Comp: TPersistent; var ImageIndex: Integer): TCustomImageList;
    procedure GetImageIndexValues(Proc: TGetStrProc);
  public
    procedure Edit; override;
    procedure Initialize; override;
    destructor Destroy; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc);override;
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer); override;
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer); override;
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); override;
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
  end;


 { TPageControlEditor }

  TPageControlEditor = class(TComponentEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  { TToolBarEditor }

  TToolBarEditor = class(TComponentEditor)
    procedure CreateToolButton(Index: Integer);
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


  { TExtendedBoolProperty }

  TExtendedBoolProperty = class(TBoolProperty)
  private
    procedure GetExtendedBoolValues(Proc: TGetStrProc);
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc);override;
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer); override;
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer); override;
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); override;
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
  end;

  { TInterfaceNameProperty }

  TInterfaceNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

 { TExtendedComponentProperty }

  TExtendedComponentProperty=class(TComponentProperty)
  private
    function GetComponentFromVar(Value: string): TComponent;
    function GetValueFromVar(Component: TComponent): String;
  public
    function AllEqual: Boolean; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetProperties(Proc: TGetPropEditProc); override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

 { TExtendedVariantProperty }

  TExtendedVariantProperty = class(TPropertyEditor)
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure GetProperties(Proc: TGetPropEditProc); override;
  end;


 { TInterfaceEditor }

  TInterfaceEditor = class(TComponentEditor)
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;
  

implementation

uses Consts, Sysutils, Dialogs, Forms, FileUtil, {UComponents, }comctrls, typinfo,
     menus, ActnList, tsvListBox, UMainUnited, tsvInterpreterCore, tsvDesignCore;

const
  ConstExtendedBoolPropertyTrue='True';
  ConstExtendedBoolPropertyFalse='False';
  SNull = '(Null)';
  SString = 'String';
  SUnknown = '(Unknown)';
  SUnknownType = 'Неизвестный тип';

{ TFilenameProperty }

function TFilenameProperty.GetFilter: string;
begin
  Result := SDefaultFilter;
end;

procedure TFilenameProperty.Edit;
var
  FileOpen: TOpenDialog;
begin
  FileOpen := TOpenDialog.Create(Application);
  try
    FileOpen.Filename := GetValue;
    FileOpen.InitialDir := ExtractFilePath(FileOpen.Filename);
    if (ExtractFileName(FileOpen.Filename) = '') or not
      ValidFileName(ExtractFileName(FileOpen.Filename)) then
      FileOpen.Filename := '';
    FileOpen.Filter := GetFilter;
    FileOpen.Options := FileOpen.Options + [ofHideReadOnly];
    if FileOpen.Execute then SetValue(FileOpen.Filename);
  finally
    FileOpen.Free;
  end;
end;

function TFilenameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog {$IFDEF WIN32}, paRevertable {$ENDIF}];
end;


{ TPageControlEditor }

procedure TPageControlEditor.Edit;
var
  pc: TPageControl;
  tb: TTabSheet;
begin
  if Component is TPageControl then begin
    pc:=TPageControl(Component);
    tb:=TTabSheet.Create(Designer.Form);
    tb.Name:=Designer.UniqueName(TTabSheet.ClassName);
    tb.Parent:=pc;
    if tb<>nil then begin
     tb.PageControl:=pc;
     Designer.SelectComponent(tb);
     Designer.Modified;
    end; 
  end;
end;

procedure TPageControlEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Edit;
    1: begin
      if Component is TPageControl then begin
        TPageControl(Component).SelectNextPage(true);
      end;
    end;
    2: begin
      if Component is TPageControl then begin
        TPageControl(Component).SelectNextPage(false);
      end;
    end;
  end;
end;

function TPageControlEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Новая закладка';
    1: Result := 'Следующая';
    2: Result := 'Предыдущая';
  else Result := '';
  end;
end;

function TPageControlEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


{ TPageControlEditor }

procedure TToolBarEditor.CreateToolButton(Index: Integer);
var
  tb: TToolBar;
  bt: TToolButton;
begin
  if Component is TToolBar then begin
    tb:=TToolBar(Component);
    bt:=TToolButton.Create(Designer.Form);
    bt.Name:=Designer.UniqueName(TToolButton.ClassName);
    case Index of
      0: bt.Style:=tbsButton;
      1: begin
        bt.Style:=tbsSeparator;
        bt.Width:=8;
      end; 
    end;
    bt.Parent:=tb;
    if bt<>nil then begin
     Designer.SelectComponent(bt);
     Designer.Modified;
    end;
  end;
end;


procedure TToolBarEditor.ExecuteVerb(Index: Integer);
begin
  CreateToolButton(Index);
end;

function TToolBarEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Новая кнопка';
    1: Result := 'Новый сепаратор';
  else Result := '';
  end;
end;

function TToolBarEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{ TImageIndexProperty }

function TImageIndexProperty.GetImages(Comp: TPersistent; var ImageIndex: Integer): TCustomImageList;
begin
  Result:=nil;
  ImageIndex:=-1;
  if Comp is TMenuItem then begin
    if TMenuItem(Comp).GetParentMenu<>nil then begin
      Result:=TMenuItem(Comp).GetParentMenu.Images;
      ImageIndex:=TMenuItem(Comp).ImageIndex;
    end;
  end;
  if Comp is TToolButton then begin
    if TToolButton(Comp).Parent is TToolBar then
      Result:=TToolBar(TToolButton(Comp).Parent).Images;
  end;
  if Comp is TTabSheet then begin
    if TTabSheet(Comp).Parent is TPageControl then
      Result:=TPageControl(TTabSheet(Comp).Parent).Images;
  end;
  if Comp is TCoolBand then begin
    if TCoolBands(TCoolBand(Comp).Collection).CoolBar<>nil then
     Result:=TCoolBands(TCoolBand(Comp).Collection).CoolBar.Images;
  end;
  if Comp is TtsvListBoxItem then begin
    if TtsvListBoxItems(TtsvListBoxItem(Comp).Collection).ListBox<>nil then
     Result:=TtsvListBoxItems(TtsvListBoxItem(Comp).Collection).ListBox.Images;
  end;
  
end;

procedure TImageIndexProperty.Initialize; 
var
  Comp: TPersistent;
  FImageIndex: Integer;
begin
  inherited;
  Comp:=GetComponent(0);
  FImages:=nil;
  FImageIndex:=GetOrdValue;
  FImages:=GetImages(Comp,FImageIndex);
  if FImages=nil then exit;
end;

procedure TImageIndexProperty.Edit;
begin
  inherited;
end;

function TImageIndexProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes +[paMultiSelect, paValueList, paRevertable];
end;

procedure TImageIndexProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
begin
  inherited PropDrawValue(ACanvas, ARect, ASelected);
{  if GetVisualValue<>'' then begin
    if FImages<>nil then begin
       inherited PropDrawValue(ACanvas, ARect, ASelected);
//       ListDrawStretchValue(GetVisualValue, ACanvas, ARect, True);
     end;
  end else
    inherited PropDrawValue(ACanvas, ARect, ASelected);}
end;

procedure TImageIndexProperty.ListDrawValue(const Value: string; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);

var
  vRight,vTop: Integer;
  vOldPenColor, vOldBrushColor: TColor;
begin
  with ACanvas do
  try
    if FImages=nil then exit;
    vRight := (ARect.Bottom - ARect.Top) {* 2} + ARect.Left+2;
    vTop:=ARect.Top+ ((ARect.Bottom - ARect.Top)div 2 -(TextHeight('W')div 2));

    vOldPenColor := Pen.Color;
    vOldBrushColor := Brush.Color;

    FillRect(ARect);

    FImages.DrawOverlay(ACanvas,ARect.Left+2,ARect.Top+2,strtoint(Value),3,true);

    Brush.Style:=bsClear;
    TextOut(vRight,vTop,Value);

    Brush.Color := vOldBrushColor;
    Pen.Color := vOldPenColor;
  finally
  end;
end;

procedure TImageIndexProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth := AWidth+4;
end;

procedure TImageIndexProperty.ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
begin
  if FImages=nil then
   AHeight := AHeight
  else AHeight := FImages.Height+4;
end;

procedure TImageIndexProperty.GetImageIndexValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  if FImages=nil then exit;
  for I := 0 to FImages.Count-1 do begin
    Proc(inttostr(I));
  end;
end;

procedure TImageIndexProperty.GetValues(Proc: TGetStrProc);
begin
  GetImageIndexValues(Proc);
end;

destructor TImageIndexProperty.Destroy;
begin
  FImages:=nil;
  inherited;
end;

{ TExtendedBoolProperty }

function TExtendedBoolProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes +[paMultiSelect, paValueList, paRevertable];
end;

procedure TExtendedBoolProperty.PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
  ASelected: Boolean);
var
  vRight,vTop: Integer;
  vOldPenColor, vOldBrushColor: TColor;
  tmps: string;
  rt: TRect;
begin
  tmps:=GetVisualValue;
  if tmps<>'' then begin
    inherited PropDrawValue(ACanvas, ARect, ASelected);
    with ACanvas do
    try
      vRight := (ARect.Bottom - ARect.Top) {* 2} + ARect.Left+2;
      vTop:=ARect.Top+ ((ARect.Bottom - ARect.Top)div 2 -(TextHeight('W')div 2));

      vOldPenColor := Pen.Color;
      vOldBrushColor := Brush.Color;

      FillRect(ARect);

      rt.Left:=ARect.Left+1;
      rt.Top:=ARect.Top+1;
      rt.Right:=vRight-1;
      rt.Bottom:=ARect.Bottom-1;

      if tmps=ConstExtendedBoolPropertyFalse then
       DrawFrameControl(ACanvas.Handle,rt,DFC_BUTTON,DFCS_BUTTONCHECK)
      else
       DrawFrameControl(ACanvas.Handle,rt,DFC_BUTTON,DFCS_CHECKED);

      Brush.Style:=bsClear;
      TextOut(vRight,vTop,Value);

      Brush.Color := vOldBrushColor;
      Pen.Color := vOldPenColor;
    finally
    end;
  end else
    inherited PropDrawValue(ACanvas, ARect, ASelected);
end;

procedure TExtendedBoolProperty.ListDrawValue(const Value: string; ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
var
  vRight,vTop: Integer;
  vOldPenColor, vOldBrushColor: TColor;
  rt: TRect;
begin
  with ACanvas do
  try
    vRight := (ARect.Bottom - ARect.Top) {* 2} + ARect.Left+2;
    vTop:=ARect.Top+ ((ARect.Bottom - ARect.Top)div 2 -(TextHeight('W')div 2));

    vOldPenColor := Pen.Color;
    vOldBrushColor := Brush.Color;

    FillRect(ARect);

    rt.Left:=ARect.Left+1;
    rt.Top:=ARect.Top+1;
    rt.Right:=vRight-1;
    rt.Bottom:=ARect.Bottom-1;
    
    if Value=ConstExtendedBoolPropertyFalse then
     DrawFrameControl(ACanvas.Handle,rt,DFC_BUTTON,DFCS_BUTTONCHECK)
    else
     DrawFrameControl(ACanvas.Handle,rt,DFC_BUTTON,DFCS_CHECKED);

    Brush.Style:=bsClear;
    TextOut(vRight,vTop,Value);

    Brush.Color := vOldBrushColor;
    Pen.Color := vOldPenColor;
  finally
  end;
end;

procedure TExtendedBoolProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
begin
  AWidth := AWidth;
end;

procedure TExtendedBoolProperty.ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer);
begin
  AHeight := AHeight;
end;

procedure TExtendedBoolProperty.GetExtendedBoolValues(Proc: TGetStrProc);
begin
  Proc(ConstExtendedBoolPropertyTrue);
  Proc(ConstExtendedBoolPropertyFalse);
end;

procedure TExtendedBoolProperty.GetValues(Proc: TGetStrProc);
begin
  GetExtendedBoolValues(Proc);
end;

function TExtendedBoolProperty.GetValue: string;
begin
  Result:=inherited GetValue;
end;

procedure TExtendedBoolProperty.SetValue(const Value: string);
var
  I: Integer;
begin
  if CompareText(Value, ConstExtendedBoolPropertyFalse) = 0 then
    I := 0
  else if CompareText(Value, ConstExtendedBoolPropertyTrue) = 0 then
    I := 1
  else
    I := StrToInt(Value);
  SetOrdValue(I);
end;


{ TInterfaceNameProperty }

function TInterfaceNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList, paRevertable, paFullWidthName];
end;

type
  PTempInterfaceNameProperty=^TTempInterfaceNameProperty;
  TTempInterfaceNameProperty=packed record
    obj: TInterface;
    Proc: TGetStrProc;
  end;

function GetTypeInterfaceByObj(obj: TInterface): TTypeInterface;
begin
  Result:=ttiNone;
  if obj is TiRBookInterface then Result:=ttiRBook;
  if obj is TiReportInterface then Result:=ttiReport;
  if obj is TiWizardInterface then Result:=ttiWizard;
  if obj is TiJournalInterface then Result:=ttiJournal;
  if obj is TiServiceInterface then Result:=ttiService;
  if obj is TiDocumentInterface then Result:=ttiDocument;
  if obj is TiNoneInterface then Result:=ttiNone;
end;

procedure InterfaceNamePropertyGetInterfaceProc(Owner: Pointer; PGI: PGetInterface); stdcall;
var
  ti: TTypeInterface;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGI) then exit;
  ti:=GetTypeInterfaceByObj(PTempInterfaceNameProperty(Owner).obj);
  if ti=PGI.TypeInterface then begin
    PTempInterfaceNameProperty(Owner).Proc(PGI.Name);
  end;
end;

procedure TInterfaceNameProperty.GetValues(Proc: TGetStrProc);
var
  obj: TPersistent;
  TTINP: TTempInterfaceNameProperty;
begin
  obj:=GetComponent(0);
  if obj is TInterface then begin
   FillChar(TTINP,SizeOf(TTINP),0);
   TTINP.obj:=TInterface(obj);
   TTINP.Proc:=Proc;
   _GetInterfaces(@TTINP,InterfaceNamePropertyGetInterfaceProc);
  end; 
end;

{ TExtendedComponentProperty }

function TExtendedComponentProperty.GetAttributes: TPropertyAttributes;
var
  ct: TComponent;
begin
  ct:=TComponent(GetOrdValue);
  if (ct<>nil) then
    if AllEqual then
      Result := [paMultiSelect, paValueList, paSortList, paRevertable, paSubProperties]
    else Result := inherited GetAttributes
  else Result := inherited GetAttributes;
end;

function TExtendedComponentProperty.AllEqual: Boolean;
var
  I: Integer;
  LInstance: TComponent;
begin
  Result := False;
  LInstance := TComponent(GetOrdValue);
  if PropCount > 1 then
    for I := 1 to PropCount - 1 do
      if TComponent(GetOrdValueAt(I)) <> LInstance then
        Exit;
  Result := true;
end;

procedure TExtendedComponentProperty.GetProperties(Proc: TGetPropEditProc);
var
  I: Integer;
  Components: TDesignerSelectionList;
begin
  Components := TDesignerSelectionList.Create;
  try
    for I := 0 to PropCount - 1 do
      Components.Add(TComponent(GetOrdValueAt(I)));
    GetComponentProperties(Components, tkProperties, Designer, Proc);
  finally
    Components.Free;
  end;
end;

type
  PTempComponentProperty=^TTempComponentProperty;
  TTempComponentProperty=packed record
    ClassType: TClass;
    Proc: TGetStrProc;
    Value: String;
    Result: TComponent;
  end;

procedure GetValuesGetInterpreterVarProc(Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIV) then exit;
  if TVarData(PGIV.TypeValue).VType=varClass then begin
    if isClassParent(V2C(PGIV.TypeValue),PTempComponentProperty(Owner).ClassType) then begin
     PTempComponentProperty(Owner).Proc(PGIV.Identifer);
    end;
  end;
end;

procedure TExtendedComponentProperty.GetValues(Proc: TGetStrProc);
var
  TTDCP: TTempComponentProperty;
  TypeData: PTypeData;
begin
  TypeData:=GetTypeData(GetPropType);
  FillChar(TTDCP,SizeOf(TTDCP),0);
  TTDCP.Proc:=Proc;
  TTDCP.ClassType:=TypeData.ClassType;
  _GetInterpreterVars(@TTDCP,GetValuesGetInterpreterVarProc);
  inherited GetValues(Proc);
end;

procedure GetValueFromVarGetInterpreterVarProc(Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIV) then exit;
  if TVarData(PGIV.TypeValue).VType=varClass then begin
    if isClassParent(V2C(PGIV.TypeValue),PTempComponentProperty(Owner).ClassType) then begin
     if V2O(PGIV.Value)=PTempComponentProperty(Owner).Result then begin
       PTempComponentProperty(Owner).Value:=PGIV.Identifer;
     end;
    end;
  end;
end;

function TExtendedComponentProperty.GetValueFromVar(Component: TComponent): String;
var
  TTDCP: TTempComponentProperty;
  TypeData: PTypeData;
begin
  Result:='';
  TypeData:=GetTypeData(GetPropType);
  FillChar(TTDCP,SizeOf(TTDCP),0);
  TTDCP.Proc:=nil;
  TTDCP.ClassType:=TypeData.ClassType;
  TTDCP.Result:=Component;
  _GetInterpreterVars(@TTDCP,GetValueFromVarGetInterpreterVarProc);
  Result:=TTDCP.Value;
end;

function TExtendedComponentProperty.GetValue: string;
begin
  Result:=GetValueFromVar(TComponent(GetOrdValue));
  if Trim(Result)='' then
    Result:=inherited GetValue;
end;

procedure GetComponentFromVarGetInterpreterVarProc(Owner: Pointer; PGIV: PGetInterpreterVar); stdcall;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIV) then exit;
  if TVarData(PGIV.TypeValue).VType=varClass then begin
    if isClassParent(V2C(PGIV.TypeValue),PTempComponentProperty(Owner).ClassType) then begin
     if AnsiSameText(PGIV.Identifer,PTempComponentProperty(Owner).Value) then begin
       PTempComponentProperty(Owner).Result:=TComponent(V2O(PGIV.Value));
     end;
    end;
  end;
end;

function TExtendedComponentProperty.GetComponentFromVar(Value: string): TComponent;
var
  TTDCP: TTempComponentProperty;
  TypeData: PTypeData;
begin
  TypeData:=GetTypeData(GetPropType);
  FillChar(TTDCP,SizeOf(TTDCP),0);
  TTDCP.Proc:=nil;
  TTDCP.ClassType:=TypeData.ClassType;
  TTDCP.Value:=Value;
  _GetInterpreterVars(@TTDCP,GetComponentFromVarGetInterpreterVarProc);
  Result:=TTDCP.Result;
end;

procedure TExtendedComponentProperty.SetValue(const Value: string);
var
  ct: TComponent;
begin
  ct:=GetComponentFromVar(Value);
  if ct<>nil then begin
    SetOrdValue(Longint(ct));
  end else
    inherited SetValue(Value);
end;


{ TVariantTypeProperty }

var
  VarTypeNames: array[varEmpty..varByte] of string = (
    'Unassigned', // varEmpty
    'Null',       // varNull
    'Smallint',   // varSmallint
    'Integer',    // varInteger
    'Single',     // varSingle
    'Double',     // varDouble
    'Currency',   // varCurrency
    'Date',       // varDate
    'OleStr',     // varOleStr
    '',           // varDispatch
    '',           // varError
    'Boolean',    // varBoolean
    '',           // varVariant
    '',           // varUnknown
    '',           // ????????
    '',           // ????????
    '',           // ????????
    'Byte'       // varByte
    );

type
  TVariantTypeProperty = class(TNestedProperty)
  public
    function AllEqual: Boolean; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetName: string; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
   end;

function TVariantTypeProperty.AllEqual: Boolean;
var
  i: Integer;
  V1, V2: Variant;
begin
  Result := False;
  if PropCount > 1 then
  begin
    V1 := GetVarValue;
    for i := 1 to PropCount - 1 do
    begin
      V2 := GetVarValueAt(i);
      if VarType(V1) <> VarType(V2) then Exit;
    end;
  end;
  Result := True;
end;

function TVariantTypeProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

function TVariantTypeProperty.GetName: string;
begin
  Result := 'Type';
end;

function TVariantTypeProperty.GetValue: string;
begin
  case VarType(GetVarValue) and varTypeMask of
    Low(VarTypeNames)..High(VarTypeNames):
      Result := VarTypeNames[VarType(GetVarValue)];
    varString:
      Result := SString;
  else
    Result := SUnknown;
  end;
end;

procedure TVariantTypeProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
begin
  for i := 0 to High(VarTypeNames) do
    if VarTypeNames[i] <> '' then
      Proc(VarTypeNames[i]);
  Proc(SString);
end;

procedure TVariantTypeProperty.SetValue(const Value: string);

  function GetSelectedType: Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to High(VarTypeNames) do
      if VarTypeNames[i] = Value then
      begin
        Result := i;
        break;
      end;
    if (Result = -1) and (Value = SString) then
      Result := varString;
  end;

var
  NewType: Integer;
  V: Variant;
begin
  V := GetVarValue;
  NewType := GetSelectedType;
  case NewType of
    varEmpty: VarClear(V);
    varNull: V := NULL;
    -1: raise Exception.Create(SUnknownType);
  else
    try
      VarCast(V, V, NewType);
    except
      { If it cannot cast, clear it and then cast again. }
      VarClear(V);
      VarCast(V, V, NewType);
    end;
  end;
  SetVarValue(V);
end;

{ TVariantProperty }

function TExtendedVariantProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties];
end;

procedure TExtendedVariantProperty.GetProperties(Proc: TGetPropEditProc);
begin
  Proc(TVariantTypeProperty.Create(Self));
end;

function VarToStrDef(const V: Variant; const ADefault: string): string;
begin
  if not VarIsNull(V) then
    Result := V
  else
    Result := ADefault;
end;

function TExtendedVariantProperty.GetValue: string;

  function GetVariantStr(const Value: Variant): string;
  begin
    case VarType(Value) of
      varBoolean:
        Result := BooleanIdents[Value = True];
      varCurrency:
        Result := CurrToStr(Value);
    else
      Result := VarToStrDef(Value, SNull);
    end;
  end;

var
  Value: Variant;
begin
  Value := GetVarValue;
  if VarType(Value) <> varDispatch then
    Result := GetVariantStr(Value)
  else
    Result := 'ERROR';
end;

procedure TExtendedVariantProperty.SetValue(const Value: string);

  function Cast(var Value: Variant; NewType: Integer): Boolean;
  var
    V2: Variant;
  begin
    Result := True;
    if NewType = varCurrency then
      Result := AnsiPos(CurrencyString, Value) > 0;
    if Result then
    try
      VarCast(V2, Value, NewType);
      Result := (NewType = varDate) or (VarToStr(V2) = VarToStr(Value));
      if Result then Value := V2;
    except
      Result := False;
    end;
  end;

var
  V: Variant;
  OldType: Integer;
begin
  OldType := VarType(GetVarValue);
  V := Value;
  if Value = '' then
    VarClear(V) else
  if (CompareText(Value, SNull) = 0) then
    V := NULL else
  if not Cast(V, OldType) then
    V := Value;
  SetVarValue(V);
end;


{ TInterfaceEditor }

procedure TInterfaceEditor.Edit;
begin
  if Component is TInterface then
    TInterface(Component).View;
end;

procedure TInterfaceEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: begin
      Edit;
    end;
    1: begin
      if Component is TInterface then
        TInterface(Component).Refresh;
    end;
    2: begin
      if Component is TInterface then
        TInterface(Component).Close;
    end;
    3: begin
      if Component is TInterface then
        TInterface(Component).ExecProc;
    end;
  end;
end;

function TInterfaceEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Показать интерфейс';
    1: Result := 'Обновить интерфейс';
    2: Result := 'Закрыть интерфейс';
    3: Result := 'Выполнить процедуру';
  else Result := '';
  end;
end;

function TInterfaceEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;

end.
