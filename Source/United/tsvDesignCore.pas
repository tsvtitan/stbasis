unit tsvDesignCore;

interface

uses Windows,Classes,Controls,Graphics,typinfo,dsgnintf,UMainUnited;

const
  DESIGNPALETTE_INVALID_HANDLE=0;
  DESIGNPALETTEBUTTON_INVALID_HANDLE=0;
  DESIGNPROPERTYTRANSLATE_INVALID_HANDLE=0;
  DESIGNPROPERTYREMOVE_INVALID_HANDLE=0;
  DESIGNPROPERTYEDITOR_INVALID_HANDLE=0;
  DESIGNCOMPONENTEDITOR_INVALID_HANDLE=0;
  DESIGNCODETEMPLATE_INVALID_HANDLE=0;
  DESIGNFORMTEMPLATE_INVALID_HANDLE=0;

  ConstisValidDesignPalette='isValidDesignPalette';
  ConstisValidDesignPaletteButton='isValidDesignPaletteButton';
  ConstCreateDesignPalette='CreateDesignPalette';
  ConstCreateDesignPaletteButton='CreateDesignPaletteButton';
  ConstFreeDesignPalette='FreeDesingPalette';
  ConstFreeDesignPaletteButton='FreeDesignPaletteButton';
  ConstGetDesignPalettes='GetDesignPalettes';
  ConstisValidDesignPropertyTranslate='isValidDesignPropertyTranslate';
  ConstCreateDesignPropertyTranslate='CreateDesignPropertyTranslate';
  ConstFreeDesignPropertyTranslate='FreeDesignPropertyTranslate';
  ConstGetDesignPropertyTranslates='GetDesignPropertyTranslates';
  ConstisValidDesignPropertyRemove='isValidDesignPropertyRemove';
  ConstCreateDesignPropertyRemove='CreateDesignPropertyRemove';
  ConstFreeDesignPropertyRemove='FreeDesignPropertyRemove';
  ConstGetDesignPropertyRemoves='GetDesignPropertyRemoves';
  ConstisValidDesignPropertyEditor='isValidDesignPropertyEditor';
  ConstCreateDesignPropertyEditor='CreateDesignPropertyEditor';
  ConstFreeDesignPropertyEditor='FreeDesignPropertyEditor';
  ConstisValidDesignComponentEditor='isValidDesignComponentEditor';
  ConstCreateDesignComponentEditor='CreateDesignComponentEditor';
  ConstFreeDesignComponentEditor='FreeDesignComponentEditor';
  ConstisValidDesignCodeTemplate='isValidDesignCodeTemplate';
  ConstCreateDesignCodeTemplate='CreateDesignCodeTemplate';
  ConstFreeDesignCodeTemplate='FreeDesignCodeTemplate';
  ConstGetDesignCodeTemplates='GetDesignCodeTemplates';
  ConstGetDesignCodeTemplateCodeByName='GetDesignCodeTemplateCodeByName';
  ConstisValidDesignFormTemplate='isValidDesignFormTemplate';
  ConstCreateDesignFormTemplate='CreateDesignFormTemplate';
  ConstFreeDesignFormTemplate='FreeDesignFormTemplate';
  ConstGetDesignFormTemplates='GetDesignFormTemplates';
  ConstGetDesignFormTemplateFormByName='GetDesignFormTemplateFormByName';

  
type

  PGetDesignPaletteButton=^TGetDesignPaletteButton;
  TGetDesignPaletteButton=packed record
    Hint: PChar;
    Cls: TPersistentClass;
    Bitmap: TBitmap;
    UseForInterfaces: TSetTypeInterface;
  end;

  PGetDesignPalette=^TGetDesignPalette;
  TGetDesignPalette=packed record
    Name: PChar;
    Hint: PChar;
    Buttons: array of PGetDesignPaletteButton;
  end;

  TGetDesignPaletteProc=procedure (Owner: Pointer; PGDP: PGetDesignPalette); stdcall;

  PCreateDesignPalette=^TCreateDesignPalette;
  TCreateDesignPalette=packed record
    Name: PChar;
    Hint: PChar;
  end;

  PCreateDesignPaletteButton=^TCreateDesignPaletteButton;
  TCreateDesignPaletteButton=packed record
    Hint: PChar;
    Cls: TPersistentClass;
    Bitmap: TBitmap;
    UseForInterfaces: TSetTypeInterface;
  end;

  PGetDesignPropertyTranslate=^TGetDesignPropertyTranslate;
  TGetDesignPropertyTranslate=packed record
    Real: PChar;
    Translate: PChar;
    Cls: TPersistentClass;
  end;

  TGetDesignPropertyTranslateProc=procedure(Owner: Pointer; PGDPT: PGetDesignPropertyTranslate); stdcall;

  PCreateDesignPropertyTranslate=^TCreateDesignPropertyTranslate;
  TCreateDesignPropertyTranslate=packed record
    Real: PChar;
    Translate: PChar;
    Cls: TPersistentClass;
  end;

  PGetDesignPropertyRemove=^TGetDesignPropertyRemove;
  TGetDesignPropertyRemove=packed record
    Name: PChar;
    Cls: TPersistentClass;
  end;

  TGetDesignPropertyRemoveProc=procedure(Owner: Pointer; PGDPR: PGetDesignPropertyRemove);stdcall;

  PCreateDesignPropertyRemove=^TCreateDesignPropertyRemove;
  TCreateDesignPropertyRemove=packed record
    Name: PChar;
    Cls: TPersistentClass;
  end;

  PCreateDesignPropertyEditor=^TCreateDesignPropertyEditor;
  TCreateDesignPropertyEditor=packed record
    PropertyType: PTypeInfo;
    ComponentClass: TClass;
    PropertyName: PChar;
    EditorClass: TPropertyEditorClass;
  end;

  PCreateDesignComponentEditor=^TCreateDesignComponentEditor;
  TCreateDesignComponentEditor=packed record
    ComponentClass: TComponentClass;
    ComponentEditor: TComponentEditorClass;
  end;

  PGetDesignCodeTemplate=^TGetDesignCodeTemplate;
  TGetDesignCodeTemplate=packed record
    Name: PChar;
    Hint: PChar;
  end;

  TGetDesignCodeTemplateProc=procedure(Owner: Pointer; PGDCT: PGetDesignCodeTemplate);stdcall;
  TGetDesignCodeProc=function(DesignCodeTemplateHandle: THandle): PChar;stdcall;
  
  PCreateDesignCodeTemplate=^TCreateDesignCodeTemplate;
  TCreateDesignCodeTemplate=packed record
    Name: PChar;
    Hint: PChar;
    GetCodeProc: TGetDesignCodeProc;
  end;

  PGetDesignFormTemplate=^TGetDesignFormTemplate;
  TGetDesignFormTemplate=packed record
    Name: PChar;
    Hint: PChar;
  end;

  TGetDesignFormTemplateProc=procedure(Owner: Pointer; PGDCT: PGetDesignFormTemplate);stdcall;
  TGetDesignFormProc=function(DesignFormTemplateHandle: THandle): PChar; stdcall;

  PCreateDesignFormTemplate=^TCreateDesignFormTemplate;
  TCreateDesignFormTemplate=packed record
    Name: PChar;
    Hint: PChar;
    GetFormProc: TGetDesignFormProc;
  end;

  procedure _GetDesignPalettes(Owner: Pointer; Proc: TGetDesignPaletteProc); stdcall;
                               external MainExe name ConstGetDesignPalettes;

  procedure _GetDesignPropertyTranslates(Owner: Pointer; Proc: TGetDesignPropertyTranslateProc); stdcall;
                                         external MainExe name ConstGetDesignPropertyTranslates;

  procedure _GetDesignPropertyRemoves(Owner: Pointer; Proc: TGetDesignPropertyRemoveProc); stdcall;
                                      external MainExe name ConstGetDesignPropertyRemoves;

  function _CreateDesignPalette(PCDP: PCreateDesignPalette): THandle; stdcall;
                                external MainExe name ConstCreateDesignPalette;
  function _CreateDesignPaletteButton(DesignPaletteHandle: THandle; PCDPB: PCreateDesignPaletteButton): THandle; stdcall;
                                external MainExe name ConstCreateDesignPaletteButton;
  function _FreeDesignPalette(DesignPaletteHandle: THandle): Boolean; stdcall;
                              external MainExe name ConstFreeDesignPalette;

  function _CreateDesignPropertyTranslate(PCDPT: PCreateDesignPropertyTranslate): THandle; stdcall;
                                          external MainExe name ConstCreateDesignPropertyTranslate;
  function _FreeDesignPropertyTranslate(DesignPropertyTranslateHandle: THandle): Boolean; stdcall;
                                        external MainExe name ConstFreeDesignPropertyTranslate;

  function _CreateDesignPropertyRemove(PCDPR: PCreateDesignPropertyRemove): THandle; stdcall;
                                       external MainExe name ConstCreateDesignPropertyRemove;
  function _FreeDesignPropertyRemove(DesignPropertyRemoveHandle: THandle): Boolean; stdcall;
                                     external MainExe name ConstFreeDesignPropertyRemove;

  function _CreateDesignPropertyEditor(PCDPE: PCreateDesignPropertyEditor): THandle; stdcall;
                                       external MainExe name ConstCreateDesignPropertyEditor;
  function _FreeDesignPropertyEditor(DesignPropertyEditorHandle: THandle): Boolean; stdcall;
                                     external MainExe name ConstFreeDesignPropertyEditor;

  function _CreateDesignComponentEditor(PCDCE: PCreateDesignComponentEditor): THandle; stdcall;
                                        external MainExe name ConstCreateDesignComponentEditor;
  function _FreeDesignComponentEditor(DesignComponentEditorHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeDesignComponentEditor;

  function _CreateDesignCodeTemplate(PCDCT: PCreateDesignCodeTemplate): THandle; stdcall;
                                        external MainExe name ConstCreateDesignCodeTemplate;
  function _FreeDesignCodeTemplate(DesignCodeTemplateHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeDesignCodeTemplate;
  procedure _GetDesignCodeTemplates(Owner: Pointer; Proc: TGetDesignCodeTemplateProc); stdcall;
                                             external MainExe name ConstGetDesignCodeTemplates;
  function _GetDesignCodeTemplateCodeByName(DesignCodeTemplateName: PChar): PChar; stdcall;
                                            external MainExe name ConstGetDesignCodeTemplateCodeByName;
  function _CreateDesignFormTemplate(PCDCT: PCreateDesignFormTemplate): THandle; stdcall;
                                        external MainExe name ConstCreateDesignFormTemplate;
  function _FreeDesignFormTemplate(DesignFormTemplateHandle: THandle): Boolean; stdcall;
                                      external MainExe name ConstFreeDesignFormTemplate;
  procedure _GetDesignFormTemplates(Owner: Pointer; Proc: TGetDesignFormTemplateProc); stdcall;
                                             external MainExe name ConstGetDesignFormTemplates;
  function _GetDesignFormTemplateFormByName(DesignFormTemplateName: PChar): PChar; stdcall;
                                            external MainExe name ConstGetDesignFormTemplateFormByName;

  function GetDesignPropertyTranslateByName(Name: string; ClassType: TClass): string;                                            
  function isClassParent(AClassIn: TClass; AClass: TClass):boolean;                                          

type
  TExtendedMethodProperty = class(TMethodProperty)
  public
    function AllEqual: Boolean; override;
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetEditLimit: Integer; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const AValue: string); override;
    function GetFormMethodName: string; override;
    function GetTrimmedEventName: string;
  end;




implementation

uses SysUtils, Consts;

{ TExtendedMethodProperty }

function TExtendedMethodProperty.AllEqual: Boolean;
var
  I: Integer;
  V, T: TMethod;
begin
  Result := False;
  if PropCount > 1 then
  begin
    V := GetMethodValue;
    for I := 1 to PropCount - 1 do
    begin
      T := GetMethodValueAt(I);
      if (T.Code <> V.Code) or (T.Data <> V.Data) then Exit;
    end;
  end;
  Result := True;
end;

procedure TExtendedMethodProperty.Edit;
var
  FormMethodName: string;
begin
  FormMethodName := GetValue;
  if (FormMethodName = '') or
    Designer.MethodFromAncestor(GetMethodValue) then
  begin
    if FormMethodName = '' then
      FormMethodName := GetFormMethodName;
    if FormMethodName = '' then
      raise EPropertyError.CreateRes(@SCannotCreateName);
    SetValue(FormMethodName);
  end;
  Designer.ShowMethod(FormMethodName);
end;

function TExtendedMethodProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList, paRevertable];
end;

function TExtendedMethodProperty.GetEditLimit: Integer;
begin
  Result := MaxIdentLength;
end;

function TExtendedMethodProperty.GetFormMethodName: string;
var
  fm: TComponent;
  ct: TPersistent;
begin
  fm:=Designer.GetRoot;
  if fm<>nil then begin
    Result:=fm.Name;
    ct:=GetComponent(0);
    if ct<>nil then
     if ct<>fm then
      if ct is TComponent then
      Result:=fm.Name+TComponent(ct).Name;
  end;
  if Result = '' then
    raise EPropertyError.CreateRes(@SCannotCreateName);
  Result := Result + GetTrimmedEventName;
end;

function TExtendedMethodProperty.GetTrimmedEventName: string;
begin
  Result := GetName;
  if (Length(Result) >= 2) and
    (Result[1] in ['O','o']) and (Result[2] in ['N','n']) then
    Delete(Result,1,2);
end;

function TExtendedMethodProperty.GetValue: string;
begin
  Result := Designer.GetMethodName(GetMethodValue);
end;

procedure TExtendedMethodProperty.GetValues(Proc: TGetStrProc);
begin
  Designer.GetMethods(GetTypeData(GetPropType), Proc);
end;

procedure TExtendedMethodProperty.SetValue(const AValue: string);
var
  NewMethod: Boolean;
  CurValue: string;
  OldMethod: TMethod;
begin
  CurValue:= GetValue;
  if (CurValue <> '') and (AValue <> '') and (SameText(CurValue, AValue) or
    not Designer.MethodExists(AValue)) and not Designer.MethodFromAncestor(GetMethodValue) then
    Designer.RenameMethod(CurValue, AValue)
  else
  begin
    NewMethod := (AValue <> '') and not Designer.MethodExists(AValue);
    OldMethod := GetMethodValue;
    SetMethodValue(Designer.CreateMethod(AValue, GetTypeData(GetPropType)));
    if NewMethod then
    begin
      Designer.ShowMethod(AValue);
    end;
  end;
end;

type
  PTempGetDesignPropertyTranslate=^TTempGetDesignPropertyTranslate;
  TTempGetDesignPropertyTranslate=packed record
    Name: string;
    str: TStringList;
  end;

procedure GetDesignPropertyTranslateProc(Owner: Pointer; PGDPT: PGetDesignPropertyTranslate); stdcall;
var
  P: PTempGetDesignPropertyTranslate;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGDPT) then exit;
  P:=PTempGetDesignPropertyTranslate(Owner);
  if AnsiSameText(PGDPT.Real,P.Name) then begin
    P.str.AddObject(PGDPT.Translate,TObject(PGDPT.Cls));
  end;
end;

function GetDesignPropertyTranslateByName(Name: string; ClassType: TClass): string;
var
  TGDPT: TTempGetDesignPropertyTranslate;
  i: Integer;
  cls: TClass;
begin
  FillChar(TGDPT,SizeOf(TGDPT),0);
  TGDPT.Name:=Name;
  TGDPT.str:=TStringList.Create;
  try
    _GetDesignPropertyTranslates(@TGDPT,GetDesignPropertyTranslateProc);
    for i:=0 to TGDPT.str.Count-1 do begin
      Result:=TGDPT.str.Strings[i];
      cls:=TClass(TGDPT.str.Objects[i]);
      if cls=ClassType then exit;
    end;
  finally
    TGDPT.str.Free;
  end;
end;

function isClassParent(AClassIn: TClass; AClass: TClass):boolean;
var
  AncestorClass: TClass;
begin
  AncestorClass := AClassIn;
  while (AncestorClass <> AClass) do
  begin
    if AncestorClass=nil then begin Result:=false; exit;end;
    AncestorClass := AncestorClass.ClassParent;
  end;
  result:=true;
end;

end.
