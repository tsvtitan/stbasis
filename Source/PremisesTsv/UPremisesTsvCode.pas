unit UPremisesTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UPremisesTsvData, UMainUnited, Classes, UPremisesTsvDm, graphics, dialogs,
     IBDatabase, IBQuery, Controls, tsvHint, db, SysUtils, IBServices, stdctrls,
     comctrls, extctrls;

// Internal
procedure DeInitAll;
procedure ClearListInterfaceHandles;
procedure AddToListInterfaceHandles;
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
function RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
procedure ClearListMenuHandles;
procedure MenuClickProc(MenuHandle: THandle);stdcall;
procedure AddToListMenuRootHandles;
procedure ClearListToolBarHandles;
procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
procedure AddToListToolBarHandles;
procedure ClearListOptionHandles;
procedure AddToListOptionRootHandles;
procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;
procedure CheckOptionProc(OptionHandle: THandle; var CheckFail: Boolean);stdcall;
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;

// Export
procedure InitAll_;stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;


implementation

uses ActiveX,Menus,tsvDbGrid,FileCtrl,shellapi, tsvSecurity,

     URBPms_Street,URBPms_Region,URBPms_Balcony,URBPms_Condition,URBPms_SanitaryNode,
     URBPms_CountRoom,URBPms_TypeRoom,URBPms_Station,URBPms_TypeHouse,URBPms_Stove,
     URBPms_Furniture,URBPms_Door,URBPms_Agent,URBPms_Planning,URBPms_Premises,
     URBPms_Phone,URBPms_Document,URBPms_SaleStatus,URBPms_TypePremises,URBPms_SelfForm,
     URBPms_Perm,URptPms_Price,USrvPms_ImportPrice,URBPms_UnitPrice, URBPms_Water,
     URBPms_Heat, URBPms_Style, URBPms_Builder, URBPms_Investor,
     URBPms_Image,URBPms_Advertisment,
     URBPms_Premises_Advertisment, URBPms_City_Region, URBPms_Regions_Correspond,
     URBPms_Taxes{,URBPms_AreaBuilding},URBPms_ExchangeFormula,URBPms_PopulatedPoint,
     URBPms_LandFeature,
     URBPms_LocationStatus, URBPms_Direction_Correspond,{URBPms_LandMark,}
     URBPms_Object, URBPms_Direction, URBPms_AccessWays,


     UPremisesTsvOptions;

//******************* Internal ************************

procedure InitAll_; stdcall;
begin
 try
  CoInitialize(nil);

  dm:=Tdm.Create(nil);
  fmOptions:=TfmOptions.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  ListOptionHandles:=TList.Create;
  AddToListOptionRootHandles;

  ListToolBarHandles:=TList.Create;
  AddToListToolBarHandles;

  fmOptions.LoadFromIni(OPTION_INVALID_HANDLE);

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  FreeAndNil(fmRBPms_Street);
  FreeAndNil(fmRBPms_Region);
  FreeAndNil(fmRBPms_Balcony);
  FreeAndNil(fmRBPms_Condition);
  FreeAndNil(fmRBPms_SanitaryNode);
  FreeAndNil(fmRBPms_Heat);
  FreeAndNil(fmRBPms_Water);
  FreeAndNil(fmRBPms_Builder);
  FreeAndNil(fmRBPms_Investor);
  FreeAndNil(fmRBPms_Style);
  FreeAndNil(fmRBPms_CountRoom);
  FreeAndNil(fmRBPms_TypeRoom);
  FreeAndNil(fmRBPms_Station);
  FreeAndNil(fmRBPms_TypeHouse);
  FreeAndNil(fmRBPms_Stove);
  FreeAndNil(fmRBPms_Furniture);
  //---------------------------
  FreeAndNil(fmRBPms_Advertisment);
  FreeAndNil(fmRBPms_Premises_Advertisment);
  FreeAndNil(fmRBPms_City_Region);
  FreeAndNil(fmRBPms_Regions_Correspond);
  FreeAndNil(fmRBPms_Direction_Correspond);
  FreeAndNil(fmRBPms_Taxes);
{  FreeAndNil(fmRBPms_LandMark);
 } FreeAndNil(fmRBPms_ExchangeFormula);
{  FreeAndNil(fmRBPms_AreaBuilding);
 } FreeAndNil(fmRBPms_PopulatedPoint);
  FreeAndNil(fmRBPms_LandFeature);
  FreeAndNil(fmRBPms_LocationStatus);
  FreeAndNil(fmRBPms_Object);
  FreeAndNil(fmRBPms_Direction);
  FreeAndNil(fmRBPms_AccessWays);
  //---------------------------
  FreeAndNil(fmRBPms_Door);
  FreeAndNil(fmRBPms_Agent);
  FreeAndNil(fmRBPms_Planning);
  FreeAndNil(fmRBPms_Phone);
  FreeAndNil(fmRBPms_Premises);
  FreeAndNil(fmRBPms_Document);
  FreeAndNil(fmRBPms_SaleStatus);
  FreeAndNil(fmRBPms_TypePremises);
  FreeAndNil(fmRBPms_SelfForm);
  FreeAndNil(fmRBPms_Perm);
  FreeAndNil(fmRBPms_UnitPrice);
  FreeAndNil(fmRBPms_Image);
  FreeAndNil(fmRptPms_Price);
  FreeAndNil(fmSrvPms_ImportPrice);

  FreeAndNil(fmOptions);

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListOptionHandles;
  ListOptionHandles.Free;

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  dm.Free;

  CoUnInitialize;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ClearListToolBarHandles;
var
  i: Integer;
begin
  for i:=0 to ListToolBarHandles.Count-1 do begin
    _FreeToolBar(THandle(ListToolBarHandles.Items[i]));
  end;
  ListToolBarHandles.Clear;
end;

procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
begin
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
                                 ImageIndex: Integer; Proc: TToolButtonClickProc=nil;
                                 Style: TToolButtonStyleEx=tbseButton;
                                 Control: TControl=nil): THandle;
  var
   CTBLocal: TCreateToolButton;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Result:=TOOLBUTTON_INVALID_HANDLE;
    Image:=TBitmap.Create;
    FillChar(CTBLocal,SizeOf(TCreateToolButton),0);
    CTBLocal.Name:=Name;
    CTBLocal.Hint:=Hint;
    dm.IL.GetBitmap(ImageIndex,Image);
    CTBLocal.Bitmap:=Image;
    CTBLocal.ToolButtonClickProc:=Proc;
    CTBLocal.Style:=Style;
    CTBLocal.Control:=Control;
    Result:=_CreateToolButton(TH,@CTBLocal);
   finally
     Image.Free;
   end;
  end;

begin
end;

procedure ClearListOptionHandles;
var
  i: Integer;
begin
  for i:=0 to ListOptionHandles.Count-1 do begin
    _FreeOption(THandle(ListOptionHandles.Items[i]));
  end;
  ListOptionHandles.Clear;
end;

procedure AddToListOptionRootHandles;

  function CreateOptionLocal(ParentHandle: THandle; Name: PChar;
                             ImageIndex: Integer): THandle;
  var
   OCLocal: TCreateOption;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Image:=TBitmap.Create;
    FillChar(OCLocal,SizeOf(TCreateOption),0);
    OCLocal.Name:=Name;
    OCLocal.BeforeSetOptionProc:=BeforeSetOptionProc;
    OCLocal.AfterSetOptionProc:=AfterSetOptionProc;
    OCLocal.CheckOptionProc:=CheckOptionProc;
    if ImageIndex<>-1 then begin
     dm.IL.GetBitmap(ImageIndex,Image);
     OCLocal.Bitmap:=Image;
    end;
    Result:=_CreateOption(ParentHandle,@OCLocal);
   finally
     Image.Free;
   end;
  end;

begin
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Premises) then begin
    hOptionData:=CreateOptionLocal(OPTION_ROOT_HANDLE,'Данные',-1);
    ListOptionHandles.Add(Pointer(hOptionData));
    if hOptionData<>MENU_INVALID_HANDLE then begin
      hOptionPremises:=CreateOptionLocal(hOptionData,NameRbkPms_Premises,-1);
    end;
  end;
  if isPermissionOnInterfaceView(hInterfaceRptPms_Price)then begin
    hOptionReport:=CreateOptionLocal(OPTION_ROOT_HANDLE,'Отчеты',-1);
    ListOptionHandles.Add(Pointer(hOptionReport));
    if hOptionReport<>MENU_INVALID_HANDLE then begin
      hOptionRptPrice:=CreateOptionLocal(hOptionReport,NameRptPms_Price,-1);
    end;
  end;
  if isPermissionOnInterfaceView(hInterfaceSrvPms_ImportPrice)then begin
    hOptionOperation:=CreateOptionLocal(OPTION_ROOT_HANDLE,'Операции',-1);
    ListOptionHandles.Add(Pointer(hOptionOperation));
    if hOptionOperation<>MENU_INVALID_HANDLE then begin
      hOptionImport:=CreateOptionLocal(hOptionOperation,NameSrvPms_ImportPrice,-1);
    end;
  end;
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;

  procedure BeforeSetOption;
  var
    wc: TWinControl;
  begin
    if OptionHandle=hOptionPremises then begin
      wc:=FindControl(_GetOptionParentWindow(hOptionPremises));
      if isValidPointer(wc) then begin
        fmOptions.pc.ActivePage:=fmOptions.tsPremises;
        fmOptions.pnPremises.Parent:=wc;
      end;
    end;
    if OptionHandle=hOptionRptPrice then begin
      wc:=FindControl(_GetOptionParentWindow(hOptionRptPrice));
      if isValidPointer(wc) then begin
        fmOptions.pc.ActivePage:=fmOptions.tsRptPrice;
        fmOptions.pnPrice.Parent:=wc;
      end;
    end;
    if OptionHandle=hOptionImport then begin
      wc:=FindControl(_GetOptionParentWindow(hOptionImport));
      if isValidPointer(wc) then begin
        fmOptions.pc.ActivePage:=fmOptions.tsImport;
        fmOptions.pnImport.Parent:=wc;
      end;
    end;
  end;

begin
  fmOptions.Visible:=true;
  fmOptions.LoadFromIni(OptionHandle);
  BeforeSetOption;
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;

  procedure AfterSetOption;
  begin
     if OptionHandle=hOptionPremises then begin
       fmOptions.pnPremises.Parent:=fmOptions.tsPremises;
     end;
     if OptionHandle=hOptionRptPrice then begin
       fmOptions.pnPrice.Parent:=fmOptions.tsRptPrice;
     end;
     if OptionHandle=hOptionImport then begin
       fmOptions.pnImport.Parent:=fmOptions.tsImport;
     end;
  end;

begin
  AfterSetOption;
  if isOK then fmOptions.SaveToIni(OptionHandle)
  else fmOptions.LoadFromIni(OptionHandle);
  fmOptions.Visible:=false;
end;

procedure CheckOptionProc(OptionHandle: THandle; var CheckFail: Boolean);stdcall;
begin
 {if OptionHandle=hOptionRptPrice then begin
   CheckFail:=not DirectoryExists(fmOptions.edReportDir.Text);
   if CheckFail then begin
      if _ViewOption(OptionHandle) then begin
        ShowErrorEx('Директория <'+Trim(fmOptions.edReportDir.Text)+'> не существует.');
        fmOptions.edReportDir.SetFocus;
      end;
    end;
  end;}
end;

procedure ClearListMenuHandles;
var
  i: Integer;
begin
  for i:=0 to ListMenuHandles.Count-1 do begin
    _FreeMenu(THandle(ListMenuHandles.Items[i]));
  end;
  ListMenuHandles.Clear;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPRI: TParamReportInterface;
  TPSI: TParamServiceInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);

  if MenuHandle=hMenuRBooksPms_Street then ViewInterface(hInterfaceRbkPms_Street,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Region then ViewInterface(hInterfaceRbkPms_Region,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Balcony then ViewInterface(hInterfaceRbkPms_Balcony,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Condition then ViewInterface(hInterfaceRbkPms_Condition,@TPRBI);
  if MenuHandle=hMenuRBooksPms_SanitaryNode then ViewInterface(hInterfaceRbkPms_SanitaryNode,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Heat then ViewInterface(hInterfaceRbkPms_Heat,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Water then ViewInterface(hInterfaceRbkPms_Water,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Builder then ViewInterface(hInterfaceRbkPms_Builder,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Investor then ViewInterface(hInterfaceRbkPms_Investor,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Style then ViewInterface(hInterfaceRbkPms_Style,@TPRBI);
  if MenuHandle=hMenuRBooksPms_CountRoom then ViewInterface(hInterfaceRbkPms_CountRoom,@TPRBI);
  if MenuHandle=hMenuRBooksPms_TypeRoom then ViewInterface(hInterfaceRbkPms_TypeRoom,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Station then ViewInterface(hInterfaceRbkPms_Station,@TPRBI);
  if MenuHandle=hMenuRBooksPms_TypeHouse then ViewInterface(hInterfaceRbkPms_TypeHouse,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Stove then ViewInterface(hInterfaceRbkPms_Stove,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Furniture then ViewInterface(hInterfaceRbkPms_Furniture,@TPRBI);
  //------------------
  if MenuHandle=hMenuRBooksPms_Advertisment then ViewInterface(hInterfaceRbkPms_Advertisment,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Premises_Advertisment then ViewInterface(hInterfaceRbkPms_Premises_Advertisment,@TPRBI);
  if MenuHandle=hMenuRBooksPms_City_Region then ViewInterface(hInterfaceRbkPms_City_Region,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Regions_Correspond then ViewInterface(hInterfaceRbkPms_Regions_Correspond,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Direction_Correspond then ViewInterface(hInterfaceRbkPms_Direction_Correspond,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Taxes then ViewInterface(hInterfaceRbkPms_Taxes,@TPRBI);
 
{  if MenuHandle=hMenuRBooksPms_AreaBuilding then ViewInterface(hInterfaceRbkPms_AreaBuilding,@TPRBI);
  if MenuHandle=hMenuRBooksPms_LandMark then ViewInterface(hInterfaceRbkPms_LandMark,@TPRBI);
 } if MenuHandle=hMenuRBooksPms_ExchangeFormula then ViewInterface(hInterfaceRbkPms_ExchangeFormula,@TPRBI);
  if MenuHandle=hMenuRBooksPms_LocationStatus then ViewInterface(hInterfaceRbkPms_LocationStatus,@TPRBI);
  if MenuHandle=hMenuRBooksPms_PopulatedPoint then ViewInterface(hInterfaceRbkPms_PopulatedPoint,@TPRBI);
  if MenuHandle=hMenuRBooksPms_LandFeature then ViewInterface(hInterfaceRbkPms_LandFeature,@TPRBI);

  if MenuHandle=hMenuRBooksPms_Object then ViewInterface(hInterfaceRbkPms_Object,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Direction then ViewInterface(hInterfaceRbkPms_Direction,@TPRBI);
  if MenuHandle=hMenuRBooksPms_AccessWays then ViewInterface(hInterfaceRbkPms_AccessWays,@TPRBI);

  //-------------------
  if MenuHandle=hMenuRBooksPms_Door then ViewInterface(hInterfaceRbkPms_Door,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Agent then ViewInterface(hInterfaceRbkPms_Agent,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Planning then ViewInterface(hInterfaceRbkPms_Planning,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Premises then ViewInterface(hInterfaceRbkPms_Premises,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Phone then ViewInterface(hInterfaceRbkPms_Phone,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Document then ViewInterface(hInterfaceRbkPms_Document,@TPRBI);
  if MenuHandle=hMenuRBooksPms_SaleStatus then ViewInterface(hInterfaceRbkPms_SaleStatus,@TPRBI);
  if MenuHandle=hMenuRBooksPms_TypePremises then ViewInterface(hInterfaceRbkPms_TypePremises,@TPRBI);
  if MenuHandle=hMenuRBooksPms_SelfForm then ViewInterface(hInterfaceRbkPms_SelfForm,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Perm then ViewInterface(hInterfaceRbkPms_Perm,@TPRBI);
  if MenuHandle=hMenuRBooksPms_UnitPrice then ViewInterface(hInterfaceRbkPms_UnitPrice,@TPRBI);
  if MenuHandle=hMenuRBooksPms_Image then ViewInterface(hInterfaceRbkPms_Image,@TPRBI);
  if MenuHandle=hMenuHelpPremises then begin
    ShellExecute(0,'open',PChar(ExtractFilePath(Application.ExeName)+ConstFileNameHelp),nil,nil,SW_SHOW);
  end;

  FillChar(TPRI,SizeOf(TPRI),0);

  if MenuHandle=hMenuReportPms_Price then ViewInterface(hInterfaceRptPms_Price,@TPRI);


  FillChar(TPSI,SizeOf(TPSI),0);

  if MenuHandle=hMenuOperationPms_ImportPrice then ViewInterface(hInterfaceSrvPms_ImportPrice,@TPSI);
end;

procedure AddToListMenuRootHandles;

  function CreateMenuLocal(ParentHandle: THandle; Name: PChar;
                           Hint: PChar;
                           TypeCreateMenu: TTypeCreateMenu=tcmAddLast;
                           InsertMenuHandle: THandle=MENU_INVALID_HANDLE;
                           ImageIndex: Integer=-1;
                           ShortCut: TShortCut=0;
                           Proc: TMenuClickProc=nil): THandle;
  var
   CMLocal: TCreateMenu;
   Image: TBitmap;
  begin
   Image:=nil;
   try
    Result:=MENU_INVALID_HANDLE;
    Image:=TBitmap.Create;
    FillChar(CMLocal,SizeOf(TCreateMenu),0);
    CMLocal.Name:=Name;
    CMLocal.Hint:=Hint;
    CMLocal.MenuClickProc:=Proc;
    CMLocal.ShortCut:=ShortCut;
    CMLocal.TypeCreateMenu:=TypeCreateMenu;
    CMLocal.InsertMenuHandle:=InsertMenuHandle;
    if ImageIndex<>-1 then begin
     dm.IL.GetBitmap(ImageIndex,Image);
     CMLocal.Bitmap:=Image;
    end;
    Result:=_CreateMenu(ParentHandle,@CMLocal);
   finally
     Image.Free;
   end;
  end;

var
  isFreeMenuRBooks: Boolean;
  isFreeMenuData: Boolean;
  isFreeReports: Boolean;
  isFreeOperations: Boolean;
  isFreeHelps: Boolean;
begin
  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuRBooksPms_Street:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Street) then
   hMenuRBooksPms_Street:=CreateMenuLocal(hMenuRBooks,'Улицы',NameRbkPms_Street,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Region:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Region) then
   hMenuRBooksPms_Region:=CreateMenuLocal(hMenuRBooks,'Районы',NameRbkPms_Region,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Balcony:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Balcony) then
   hMenuRBooksPms_Balcony:=CreateMenuLocal(hMenuRBooks,'Виды балкона',NameRbkPms_Balcony,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Condition:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Condition) then
   hMenuRBooksPms_Condition:=CreateMenuLocal(hMenuRBooks,'Состояния (ремонт)',NameRbkPms_Condition,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_SanitaryNode:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_SanitaryNode) then
   hMenuRBooksPms_SanitaryNode:=CreateMenuLocal(hMenuRBooks,'Типы санузла',NameRbkPms_SanitaryNode,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Heat:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Heat) then
   hMenuRBooksPms_Heat:=CreateMenuLocal(hMenuRBooks,'Отопление',NameRbkPms_Heat,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Water:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Water) then
   hMenuRBooksPms_Water:=CreateMenuLocal(hMenuRBooks,'Водоснабжение',NameRbkPms_Water,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Builder:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Builder) then
   hMenuRBooksPms_Builder:=CreateMenuLocal(hMenuRBooks,'Застройщики',NameRbkPms_Builder,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Investor:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Investor) then
   hMenuRBooksPms_Investor:=CreateMenuLocal(hMenuRBooks,'Инвестора',NameRbkPms_Investor,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Style:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Style) then
   hMenuRBooksPms_Style:=CreateMenuLocal(hMenuRBooks,'Стили',NameRbkPms_Style,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_CountRoom:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_CountRoom) then
   hMenuRBooksPms_CountRoom:=CreateMenuLocal(hMenuRBooks,'Количество комнат',NameRbkPms_CountRoom,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_TypeRoom:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_TypeRoom) then
   hMenuRBooksPms_TypeRoom:=CreateMenuLocal(hMenuRBooks,'Типы комнат',NameRbkPms_TypeRoom,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Station:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Station) then
   hMenuRBooksPms_Station:=CreateMenuLocal(hMenuRBooks,'Статус квартиры',NameRbkPms_Station,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_TypeHouse:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_TypeHouse) then
   hMenuRBooksPms_TypeHouse:=CreateMenuLocal(hMenuRBooks,'Типы дома',NameRbkPms_TypeHouse,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Stove:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Stove) then
   hMenuRBooksPms_Stove:=CreateMenuLocal(hMenuRBooks,'Виды плит',NameRbkPms_Stove,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  //плядь нашел эбаную менушку
  hMenuRBooksPms_Furniture:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Furniture) then
   hMenuRBooksPms_Furniture:=CreateMenuLocal(hMenuRBooks,'Виды мебели',NameRbkPms_Furniture,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  //---------------------
  hMenuRBooksPms_Advertisment:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Advertisment) then
   hMenuRBooksPms_Advertisment:=CreateMenuLocal(hMenuRBooks,'Реклама',NameRbkPms_Advertisment,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Premises_Advertisment:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Premises_Advertisment) then
   hMenuRBooksPms_Premises_Advertisment:=CreateMenuLocal(hMenuRBooks,'Реклама недвижимости',NameRbkPms_Premises_Advertisment,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_City_Region:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_City_Region) then
   hMenuRBooksPms_City_Region:=CreateMenuLocal(hMenuRBooks,'Районы города',NameRbkPms_City_Region,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Regions_Correspond:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Regions_Correspond) then
   hMenuRBooksPms_Regions_Correspond:=CreateMenuLocal(hMenuRBooks,'Районы и подрайны города',NameRbkPms_Regions_Correspond,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Direction_Correspond:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Direction_Correspond) then
   hMenuRBooksPms_Direction_Correspond:=CreateMenuLocal(hMenuRBooks,'Районы и направления города',NameRbkPms_Direction_Correspond,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Taxes:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Taxes) then
   hMenuRBooksPms_Taxes:=CreateMenuLocal(hMenuRBooks,'Налоги',NameRbkPms_Taxes,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
  {--------------}



{  hMenuRBooksPms_AreaBuilding:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_AreaBuilding) then
   hMenuRBooksPms_AreaBuilding:=CreateMenuLocal(hMenuRBooks,'Зем. постройки',NameRbkPms_AreaBuilding,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
 }
  hMenuRBooksPms_ExchangeFormula:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_ExchangeFormula) then
   hMenuRBooksPms_ExchangeFormula:=CreateMenuLocal(hMenuRBooks,'Формула обмена',NameRbkPms_ExchangeFormula,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_PopulatedPoint:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_PopulatedPoint) then
   hMenuRBooksPms_PopulatedPoint:=CreateMenuLocal(hMenuRBooks,'Населенный пункт',NameRbkPms_PopulatedPoint,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_LandFeature:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_LandFeature) then
   hMenuRBooksPms_LandFeature:=CreateMenuLocal(hMenuRBooks,'Зем. хар-ки(Назначение)',NameRbkPms_LandFeature,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_LocationStatus:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_LocationStatus) then
   hMenuRBooksPms_LocationStatus:=CreateMenuLocal(hMenuRBooks,'Статус расположения',NameRbkPms_LocationStatus,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

{  hMenuRBooksPms_LandMark:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_LandMark) then
   hMenuRBooksPms_LandMark:=CreateMenuLocal(hMenuRBooks,'Ориентир',NameRbkPms_LandMark,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

 }
  hMenuRBooksPms_Object:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Object) then
   hMenuRBooksPms_Object:=CreateMenuLocal(hMenuRBooks,'Объект',NameRbkPms_Object,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Direction:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Direction) then
   hMenuRBooksPms_Direction:=CreateMenuLocal(hMenuRBooks,'Направление',NameRbkPms_Direction,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_AccessWays:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_AccessWays) then
   hMenuRBooksPms_AccessWays:=CreateMenuLocal(hMenuRBooks,'Подъездные пути',NameRbkPms_AccessWays,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  //---------------------
  hMenuRBooksPms_Door:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Door) then
   hMenuRBooksPms_Door:=CreateMenuLocal(hMenuRBooks,'Виды дверей',NameRbkPms_Door,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Agent:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Agent) then
   hMenuRBooksPms_Agent:=CreateMenuLocal(hMenuRBooks,'Агенты',NameRbkPms_Agent,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Planning:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Planning) then
   hMenuRBooksPms_Planning:=CreateMenuLocal(hMenuRBooks,'Планировки',NameRbkPms_Planning,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Phone:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Phone) then
   hMenuRBooksPms_Phone:=CreateMenuLocal(hMenuRBooks,'Виды телефонов',NameRbkPms_Phone,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Document:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Document) then
   hMenuRBooksPms_Document:=CreateMenuLocal(hMenuRBooks,'Виды документов',NameRbkPms_Document,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_SaleStatus:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_SaleStatus) then
   hMenuRBooksPms_SaleStatus:=CreateMenuLocal(hMenuRBooks,'Статусы продажи',NameRbkPms_SaleStatus,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_TypePremises:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_TypePremises) then
   hMenuRBooksPms_TypePremises:=CreateMenuLocal(hMenuRBooks,'Типы недвижимости',NameRbkPms_TypePremises,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_SelfForm:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_SelfForm) then
   hMenuRBooksPms_SelfForm:=CreateMenuLocal(hMenuRBooks,'Формы собственности',NameRbkPms_SelfForm,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Perm:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Perm) then
   hMenuRBooksPms_Perm:=CreateMenuLocal(hMenuRBooks,'Права на операции',NameRbkPms_Perm,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_UnitPrice:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_UnitPrice) then
   hMenuRBooksPms_UnitPrice:=CreateMenuLocal(hMenuRBooks,'Единицы измерения цены',NameRbkPms_UnitPrice,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRBooksPms_Image:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Image) then
   hMenuRBooksPms_Image:=CreateMenuLocal(hMenuRBooks,'Изображения домов',NameRbkPms_Image,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeMenuRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Street=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Balcony=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Condition=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_SanitaryNode=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Heat=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Water=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Builder=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Investor=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Style=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_CountRoom=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_TypeRoom=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Station=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_TypeHouse=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Stove=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Furniture=MENU_INVALID_HANDLE)and
                   //-----------------
                    (hMenuRBooksPms_Advertisment=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Premises_Advertisment=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_City_Region=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Regions_Correspond=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Direction_Correspond=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Taxes=MENU_INVALID_HANDLE)and
  {                  (hMenuRBooksPms_AreaBuilding=MENU_INVALID_HANDLE)and
   }                 (hMenuRBooksPms_PopulatedPoint=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_LandFeature=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_ExchangeFormula=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_LocationStatus=MENU_INVALID_HANDLE)and
 {                   (hMenuRBooksPms_LandMark=MENU_INVALID_HANDLE)and
  }                  (hMenuRBooksPms_Object=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Direction=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_AccessWays=MENU_INVALID_HANDLE)and

                //-----------------------
                    (hMenuRBooksPms_Door=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Agent=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Planning=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Phone=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Document=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_SaleStatus=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_TypePremises=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_SelfForm=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Perm=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_UnitPrice=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Image=MENU_INVALID_HANDLE)and
                    (hMenuRBooksPms_Region=MENU_INVALID_HANDLE);
  if isFreeMenuRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

  hMenuData:=CreateMenuLocal(MENU_ROOT_HANDLE,'Данные','Данные',tcmInsertBefore,hMenuRBooks);
  ListMenuHandles.Add(Pointer(hMenuData));

  hMenuRBooksPms_Premises:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkPms_Premises) then
   hMenuRBooksPms_Premises:=CreateMenuLocal(hMenuData,'Недвижимость',NameRbkPms_Premises,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeMenuData:=(hMenuData<>MENU_INVALID_HANDLE)and
                  (hMenuRBooksPms_Premises=MENU_INVALID_HANDLE);
  if isFreeMenuData then
    if _FreeMenu(hMenuData) then hMenuData:=MENU_INVALID_HANDLE;

  hMenuReports:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuReports,PChar(ChangeString(ConstsMenuReports,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuReports));

  hMenuReportPms_Price:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRptPms_Price) then
   hMenuReportPms_Price:=CreateMenuLocal(hMenuReports,'Прайсы',NameRptPms_Price,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeReports:=(hMenuReports<>MENU_INVALID_HANDLE)and
                 (hMenuReportPms_Price=MENU_INVALID_HANDLE);
  if isFreeReports then
    if _FreeMenu(hMenuReports) then hMenuReports:=MENU_INVALID_HANDLE;

  hMenuOperations:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuOperations,PChar(ChangeString(ConstsMenuOperations,'&','')),
                                   tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuOperations));

  hMenuOperationPms_ImportPrice:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceSrvPms_ImportPrice) then
   hMenuOperationPms_ImportPrice:=CreateMenuLocal(hMenuOperations,'Импорт прайса',NameSrvPms_ImportPrice,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  isFreeOperations:=(hMenuOperations<>MENU_INVALID_HANDLE)and
                    (hMenuOperationPms_ImportPrice=MENU_INVALID_HANDLE);
  if isFreeOperations then
    if _FreeMenu(hMenuOperations) then hMenuOperations:=MENU_INVALID_HANDLE;

  hMenuHelps:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuHelp,PChar(ChangeString(ConstsMenuHelp,'&','')),tcmAddLast,MENU_INVALID_HANDLE);
  ListMenuHandles.Add(Pointer(hMenuHelps));

  hMenuHelpPremises:=MENU_INVALID_HANDLE;
  if FileExists(ExtractFilePath(Application.ExeName)+ConstFileNameHelp) then
   hMenuHelpPremises:=CreateMenuLocal(hMenuHelps,'Руководство пользователя','Руководство пользователя',tcmAddFirst,MENU_INVALID_HANDLE,-1,ShortCut(VK_F1,[]),MenuClickProc);

  isFreeHelps:=(hMenuHelps<>MENU_INVALID_HANDLE)and
               (hMenuHelpPremises=MENU_INVALID_HANDLE);
  if isFreeHelps then
    if _FreeMenu(hMenuHelps) then hMenuHelps:=MENU_INVALID_HANDLE;


end;

procedure ClearListInterfaceHandles;
var
  i: Integer;
begin
  for i:=0 to ListInterfaceHandles.Count-1 do begin
    _FreeInterface(THandle(ListInterfaceHandles.Items[i]));
  end;
  ListInterfaceHandles.Clear;
end;

procedure AddToListInterfaceHandles;

  function CreateLocalInterface(Name,Hint: PChar; TypeInterface: TTypeInterface=ttiRBook): THandle;
  var
    TPCI: TCreateInterface;
  begin
    FillChar(TPCI,SizeOf(TCreateInterface),0);
    TPCI.Name:=Name;
    TPCI.Hint:=Hint;
    TPCI.ViewInterface:=ViewInterface;
    TPCI.TypeInterface:=TypeInterface;
    TPCI.RefreshInterface:=RefreshInterface;
    Result:=_CreateInterface(@TPCI);
    ListInterfaceHandles.Add(Pointer(Result));
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


begin
  hInterfaceRbkPms_Street:=CreateLocalInterface(NameRbkPms_Street,NameRbkPms_Street);
  CreateLocalPermission(hInterfaceRbkPms_Street,tbPms_Street,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Street,tbPms_Street,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Street,tbPms_Street,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Street,tbPms_Street,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Region:=CreateLocalInterface(NameRbkPms_Region,NameRbkPms_Region);
  CreateLocalPermission(hInterfaceRbkPms_Region,tbPms_Region,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Region,tbPms_Region,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Region,tbPms_Region,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Region,tbPms_Region,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Balcony:=CreateLocalInterface(NameRbkPms_Balcony,NameRbkPms_Balcony);
  CreateLocalPermission(hInterfaceRbkPms_Balcony,tbPms_Balcony,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Balcony,tbPms_Balcony,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Balcony,tbPms_Balcony,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Balcony,tbPms_Balcony,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Condition:=CreateLocalInterface(NameRbkPms_Condition,NameRbkPms_Condition);
  CreateLocalPermission(hInterfaceRbkPms_Condition,tbPms_Condition,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Condition,tbPms_Condition,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Condition,tbPms_Condition,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Condition,tbPms_Condition,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_SanitaryNode:=CreateLocalInterface(NameRbkPms_SanitaryNode,NameRbkPms_SanitaryNode);
  CreateLocalPermission(hInterfaceRbkPms_SanitaryNode,tbPms_SanitaryNode,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_SanitaryNode,tbPms_SanitaryNode,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_SanitaryNode,tbPms_SanitaryNode,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_SanitaryNode,tbPms_SanitaryNode,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Heat:=CreateLocalInterface(NameRbkPms_Heat,NameRbkPms_Heat);
  CreateLocalPermission(hInterfaceRbkPms_Heat,tbPms_Heat,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Heat,tbPms_Heat,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Heat,tbPms_Heat,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Heat,tbPms_Heat,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Water:=CreateLocalInterface(NameRbkPms_Water,NameRbkPms_Water);
  CreateLocalPermission(hInterfaceRbkPms_Water,tbPms_Water,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Water,tbPms_Water,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Water,tbPms_Water,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Water,tbPms_Water,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Builder:=CreateLocalInterface(NameRbkPms_Builder,NameRbkPms_Builder);
  CreateLocalPermission(hInterfaceRbkPms_Builder,tbPms_Builder,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Builder,tbPms_Builder,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Builder,tbPms_Builder,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Builder,tbPms_Builder,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Investor:=CreateLocalInterface(NameRbkPms_Investor,NameRbkPms_Investor);
  CreateLocalPermission(hInterfaceRbkPms_Investor,tbPms_Investor,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Investor,tbPms_Investor,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Investor,tbPms_Investor,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Investor,tbPms_Investor,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Style:=CreateLocalInterface(NameRbkPms_Style,NameRbkPms_Style);
  CreateLocalPermission(hInterfaceRbkPms_Style,tbPms_Style,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Style,tbPms_Style,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Style,tbPms_Style,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Style,tbPms_Style,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_CountRoom:=CreateLocalInterface(NameRbkPms_CountRoom,NameRbkPms_CountRoom);
  CreateLocalPermission(hInterfaceRbkPms_CountRoom,tbPms_CountRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_CountRoom,tbPms_CountRoom,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_CountRoom,tbPms_CountRoom,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_CountRoom,tbPms_CountRoom,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_TypeRoom:=CreateLocalInterface(NameRbkPms_TypeRoom,NameRbkPms_TypeRoom);
  CreateLocalPermission(hInterfaceRbkPms_TypeRoom,tbPms_TypeRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_TypeRoom,tbPms_TypeRoom,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_TypeRoom,tbPms_TypeRoom,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_TypeRoom,tbPms_TypeRoom,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Station:=CreateLocalInterface(NameRbkPms_Station,NameRbkPms_Station);
  CreateLocalPermission(hInterfaceRbkPms_Station,tbPms_Station,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Station,tbPms_Station,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Station,tbPms_Station,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Station,tbPms_Station,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_TypeHouse:=CreateLocalInterface(NameRbkPms_TypeHouse,NameRbkPms_TypeHouse);
  CreateLocalPermission(hInterfaceRbkPms_TypeHouse,tbPms_TypeHouse,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_TypeHouse,tbPms_TypeHouse,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_TypeHouse,tbPms_TypeHouse,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_TypeHouse,tbPms_TypeHouse,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Stove:=CreateLocalInterface(NameRbkPms_Stove,NameRbkPms_Stove);
  CreateLocalPermission(hInterfaceRbkPms_Stove,tbPms_Stove,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Stove,tbPms_Stove,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Stove,tbPms_Stove,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Stove,tbPms_Stove,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Furniture:=CreateLocalInterface(NameRbkPms_Furniture,NameRbkPms_Furniture);
  CreateLocalPermission(hInterfaceRbkPms_Furniture,tbPms_Furniture,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Furniture,tbPms_Furniture,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Furniture,tbPms_Furniture,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Furniture,tbPms_Furniture,ttpDelete,false,ttiaDelete);
  //---------------------------------
  hInterfaceRbkPms_Advertisment:=CreateLocalInterface(NameRbkPms_Advertisment,NameRbkPms_Advertisment);
  CreateLocalPermission(hInterfaceRbkPms_Advertisment,tbPms_Advertisment,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Advertisment,tbPms_Advertisment,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Advertisment,tbPms_Advertisment,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Advertisment,tbPms_Advertisment,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Premises_Advertisment:=CreateLocalInterface(NameRbkPms_Premises_Advertisment,NameRbkPms_Premises_Advertisment);
  CreateLocalPermission(hInterfaceRbkPms_Premises_Advertisment,tbPms_Premises_Advertisment,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises_Advertisment,tbPms_Premises_Advertisment,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Premises_Advertisment,tbPms_Premises_Advertisment,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Premises_Advertisment,tbPms_Premises_Advertisment,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_City_Region:=CreateLocalInterface(NameRbkPms_City_Region,NameRbkPms_City_Region);
  CreateLocalPermission(hInterfaceRbkPms_City_Region,tbPms_City_Region,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_City_Region,tbPms_City_Region,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_City_Region,tbPms_City_Region,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_City_Region,tbPms_City_Region,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Regions_Correspond:=CreateLocalInterface(NameRbkPms_Regions_Correspond,NameRbkPms_Regions_Correspond);
  CreateLocalPermission(hInterfaceRbkPms_Regions_Correspond,tbPms_Regions_Correspond,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Regions_Correspond,tbPms_Regions_Correspond,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Regions_Correspond,tbPms_Regions_Correspond,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Regions_Correspond,tbPms_Regions_Correspond,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Direction_Correspond:=CreateLocalInterface(NameRbkPms_Direction_Correspond,NameRbkPms_Direction_Correspond);
  CreateLocalPermission(hInterfaceRbkPms_Direction_Correspond,tbPms_Direction_Correspond,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Direction_Correspond,tbPms_Direction_Correspond,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Direction_Correspond,tbPms_Direction_Correspond,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Direction_Correspond,tbPms_Direction_Correspond,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Taxes:=CreateLocalInterface(NameRbkPms_Taxes,NameRbkPms_Taxes);
  CreateLocalPermission(hInterfaceRbkPms_Taxes,tbPms_Taxes,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Taxes,tbPms_Taxes,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Taxes,tbPms_Taxes,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Taxes,tbPms_Taxes,ttpDelete,false,ttiaDelete);

{  hInterfaceRbkPms_AreaBuilding:=CreateLocalInterface(NameRbkPms_AreaBuilding,NameRbkPms_AreaBuilding);
  CreateLocalPermission(hInterfaceRbkPms_AreaBuilding,tbPms_AreaBuilding,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_AreaBuilding,tbPms_AreaBuilding,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_AreaBuilding,tbPms_AreaBuilding,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_AreaBuilding,tbPms_AreaBuilding,ttpDelete,false,ttiaDelete);
 }
  hInterfaceRbkPms_PopulatedPoint:=CreateLocalInterface(NameRbkPms_PopulatedPoint,NameRbkPms_PopulatedPoint);
  CreateLocalPermission(hInterfaceRbkPms_PopulatedPoint,tbPms_PopulatedPoint,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_PopulatedPoint,tbPms_PopulatedPoint,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_PopulatedPoint,tbPms_PopulatedPoint,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_PopulatedPoint,tbPms_PopulatedPoint,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_LandFeature:=CreateLocalInterface(NameRbkPms_LandFeature,NameRbkPms_LandFeature);
  CreateLocalPermission(hInterfaceRbkPms_LandFeature,tbPms_LandFeature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_LandFeature,tbPms_LandFeature,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_LandFeature,tbPms_LandFeature,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_LandFeature,tbPms_LandFeature,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_ExchangeFormula:=CreateLocalInterface(NameRbkPms_ExchangeFormula,NameRbkPms_ExchangeFormula);
  CreateLocalPermission(hInterfaceRbkPms_ExchangeFormula,tbPms_ExchangeFormula,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_ExchangeFormula,tbPms_ExchangeFormula,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_ExchangeFormula,tbPms_ExchangeFormula,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_ExchangeFormula,tbPms_ExchangeFormula,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_LocationStatus:=CreateLocalInterface(NameRbkPms_LocationStatus,NameRbkPms_LocationStatus);
  CreateLocalPermission(hInterfaceRbkPms_LocationStatus,tbPms_LocationStatus,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_LocationStatus,tbPms_LocationStatus,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_LocationStatus,tbPms_LocationStatus,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_LocationStatus,tbPms_LocationStatus,ttpDelete,false,ttiaDelete);

 { hInterfaceRbkPms_LandMark:=CreateLocalInterface(NameRbkPms_LandMark,NameRbkPms_LandMark);
  CreateLocalPermission(hInterfaceRbkPms_LandMark,tbPms_LandMark,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_LandMark,tbPms_LandMark,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_LandMark,tbPms_LandMark,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_LandMark,tbPms_LandMark,ttpDelete,false,ttiaDelete);
 }
  hInterfaceRbkPms_Object:=CreateLocalInterface(NameRbkPms_Object,NameRbkPms_Object);
  CreateLocalPermission(hInterfaceRbkPms_Object,tbPms_Object,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Object,tbPms_Object,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Object,tbPms_Object,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Object,tbPms_Object,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Direction:=CreateLocalInterface(NameRbkPms_Direction,NameRbkPms_Direction);
  CreateLocalPermission(hInterfaceRbkPms_Direction,tbPms_Direction,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Direction,tbPms_Direction,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Direction,tbPms_Direction,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Direction,tbPms_Direction,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_AccessWays:=CreateLocalInterface(NameRbkPms_AccessWays,NameRbkPms_AccessWays);
  CreateLocalPermission(hInterfaceRbkPms_AccessWays,tbPms_AccessWays,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_AccessWays,tbPms_AccessWays,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_AccessWays,tbPms_AccessWays,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_AccessWays,tbPms_AccessWays,ttpDelete,false,ttiaDelete);
  //----------------------------------
  hInterfaceRbkPms_Door:=CreateLocalInterface(NameRbkPms_Door,NameRbkPms_Door);
  CreateLocalPermission(hInterfaceRbkPms_Door,tbPms_Door,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Door,tbPms_Door,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Door,tbPms_Door,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Door,tbPms_Door,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Agent:=CreateLocalInterface(NameRbkPms_Agent,NameRbkPms_Agent);
  CreateLocalPermission(hInterfaceRbkPms_Agent,tbPms_Agent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Agent,tbPms_Agent,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Agent,tbPms_Agent,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Agent,tbPms_Agent,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Planning:=CreateLocalInterface(NameRbkPms_Planning,NameRbkPms_Planning);
  CreateLocalPermission(hInterfaceRbkPms_Planning,tbPms_Planning,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Planning,tbPms_Planning,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Planning,tbPms_Planning,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Planning,tbPms_Planning,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Phone:=CreateLocalInterface(NameRbkPms_Phone,NameRbkPms_Phone);
  CreateLocalPermission(hInterfaceRbkPms_Phone,tbPms_Phone,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Phone,tbPms_Phone,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Phone,tbPms_Phone,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Phone,tbPms_Phone,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Document:=CreateLocalInterface(NameRbkPms_Document,NameRbkPms_Document);
  CreateLocalPermission(hInterfaceRbkPms_Document,tbPms_Document,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Document,tbPms_Document,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Document,tbPms_Document,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Document,tbPms_Document,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_SaleStatus:=CreateLocalInterface(NameRbkPms_SaleStatus,NameRbkPms_SaleStatus);
  CreateLocalPermission(hInterfaceRbkPms_SaleStatus,tbPms_SaleStatus,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_SaleStatus,tbPms_SaleStatus,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_SaleStatus,tbPms_SaleStatus,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_SaleStatus,tbPms_SaleStatus,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_TypePremises:=CreateLocalInterface(NameRbkPms_TypePremises,NameRbkPms_TypePremises);
  CreateLocalPermission(hInterfaceRbkPms_TypePremises,tbPms_TypePremises,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_TypePremises,tbPms_TypePremises,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_TypePremises,tbPms_TypePremises,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_TypePremises,tbPms_TypePremises,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_SelfForm:=CreateLocalInterface(NameRbkPms_SelfForm,NameRbkPms_SelfForm);
  CreateLocalPermission(hInterfaceRbkPms_SelfForm,tbPms_SelfForm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_SelfForm,tbPms_SelfForm,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_SelfForm,tbPms_SelfForm,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_SelfForm,tbPms_SelfForm,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Perm:=CreateLocalInterface(NameRbkPms_Perm,NameRbkPms_Perm);
  CreateLocalPermission(hInterfaceRbkPms_Perm,tbPms_Perm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Perm,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Perm,tbPms_Perm,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Perm,tbPms_Perm,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Perm,tbPms_Perm,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_UnitPrice:=CreateLocalInterface(NameRbkPms_UnitPrice,NameRbkPms_UnitPrice);
  CreateLocalPermission(hInterfaceRbkPms_UnitPrice,tbPms_UnitPrice,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_UnitPrice,tbPms_UnitPrice,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_UnitPrice,tbPms_UnitPrice,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_UnitPrice,tbPms_UnitPrice,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Image:=CreateLocalInterface(NameRbkPms_Image,NameRbkPms_Image);
  CreateLocalPermission(hInterfaceRbkPms_Image,tbPms_Image,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Image,tbPms_Image,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Image,tbPms_Image,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Image,tbPms_Image,ttpDelete,false,ttiaDelete);

  hInterfaceRbkPms_Premises:=CreateLocalInterface(NameRbkPms_Premises,NameRbkPms_Premises);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Premises,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Region,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Street,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Balcony,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Condition,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_SanitaryNode,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Heat,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Water,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Builder,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Investor,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Style,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Agent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Door,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_CountRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_TypeRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Planning,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Station,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_TypeHouse,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Stove,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Furniture,ttpSelect,false);
  //-----------------------------------
 {  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Advertisment,ttpSelect,false); }
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_City_Region,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Taxes,ttpSelect,false);

 { CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_AreaBuilding,ttpSelect,false);
  }CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_PopulatedPoint,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_LandFeature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_ExchangeFormula,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_LocationStatus,ttpSelect,false);
 { CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_LandMark,ttpSelect,false);
  }CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Object,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Direction,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_AccessWays,ttpSelect,false);

 // CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Regions_Correspond,ttpSelect,false);


  // CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Premises_Advertisment,ttpSelect,false);

  //------------------------------------
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Phone,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Document,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_SaleStatus,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_TypePremises,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_SelfForm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Perm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_UnitPrice,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbConst,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Premises,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Premises,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkPms_Premises,tbPms_Premises,ttpDelete,false,ttiaDelete);

  hInterfaceRptPms_Price:=CreateLocalInterface(NameRptPms_Price,NameRptPms_Price,ttiReport);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Premises,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Region,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Street,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Balcony,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Condition,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_SanitaryNode,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Heat,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Water,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Builder,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Style,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Agent,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Door,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_CountRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_TypeRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Planning,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Station,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_TypeHouse,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Stove,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Furniture,ttpSelect,false);

    //-----------------------------------
 {  CreateLocalPermission(hInterfaceRbkPms_Price,tbPms_Advertisment,ttpSelect,false);  }
 // CreateLocalPermission(hInterfaceRptPms_Price,tbPms_City_Region,ttpSelect,false);
 //CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Regions_Correspond,ttpSelect,false);

  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Taxes,ttpSelect,false);

 { CreateLocalPermission(hInterfaceRptPms_Price,tbPms_AreaBuilding,ttpSelect,false);
  }CreateLocalPermission(hInterfaceRptPms_Price,tbPms_PopulatedPoint,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_LandFeature,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_ExchangeFormula,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_LocationStatus,ttpSelect,false);
{  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_LandMark,ttpSelect,false);
 } CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Object,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Direction,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_AccessWays,ttpSelect,false);

  //------------------------------------

  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Phone,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Document,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_SaleStatus,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_TypePremises,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_SelfForm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Perm,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_UnitPrice,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbPms_Image,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbUsers,ttpSelect,false);
  CreateLocalPermission(hInterfaceRptPms_Price,tbConst,ttpSelect,false);

  hInterfaceSrvPms_ImportPrice:=CreateLocalInterface(NameSrvPms_ImportPrice,NameSrvPms_ImportPrice,ttiService);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Premises,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Premises,ttpInsert,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Region,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Street,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Balcony,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Condition,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_SanitaryNode,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Heat,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Water,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Builder,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Style,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Agent,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Door,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_CountRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_TypeRoom,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Planning,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Station,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_TypeHouse,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Stove,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Furniture,ttpSelect,false);
    //-----------------------------------
 {  CreateLocalPermission(hInterfaceRbkPms_ImportPrice,tbPms_Advertisment,ttpSelect,false);
  // CreateLocalPermission(hInterfaceRbkPms_ImportPrice,tbPms_Premises_Advertisment,ttpSelect,false);
  } //CreateLocalPermission(hInterfaceRbkPms_ImportPrice,tbPms_Regions_Correspond,ttpSelect,false);

  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Taxes,ttpSelect,false);
{  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_AreaBuilding,ttpSelect,false);
 } CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_PopulatedPoint,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_LandFeature,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_ExchangeFormula,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_LocationStatus,ttpSelect,false);
{  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_LandMark,ttpSelect,false);
 }
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Object,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Direction,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_AccessWays,ttpSelect,false);

  //------------------------------------

  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Phone,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_Document,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_SaleStatus,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_TypePremises,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_SelfForm,ttpSelect,false);
  CreateLocalPermission(hInterfaceSrvPms_ImportPrice,tbPms_UnitPrice,ttpSelect,false);

end;

function CreateAndViewPms_Street(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Street=nil then
       fmRBPms_Street:=TfmRBPms_Street.Create(Application);
     fmRBPms_Street.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Street;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Street.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Street,Param);
  end;
end;

function CreateAndViewPms_Region(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Region=nil then
       fmRBPms_Region:=TfmRBPms_Region.Create(Application);
     fmRBPms_Region.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Region;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Region.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Region,Param);
  end;
end;

function CreateAndViewPms_Balcony(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Balcony=nil then
       fmRBPms_Balcony:=TfmRBPms_Balcony.Create(Application);
     fmRBPms_Balcony.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Balcony;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Balcony.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Balcony,Param);
  end;
end;

function CreateAndViewPms_Condition(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Condition=nil then
       fmRBPms_Condition:=TfmRBPms_Condition.Create(Application);
     fmRBPms_Condition.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Condition;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Condition.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Condition,Param);
  end;
end;

function CreateAndViewPms_SanitaryNode(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_SanitaryNode=nil then
       fmRBPms_SanitaryNode:=TfmRBPms_SanitaryNode.Create(Application);
     fmRBPms_SanitaryNode.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;
         
   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_SanitaryNode;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_SanitaryNode.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_SanitaryNode,Param);
  end;
end;

function CreateAndViewPms_Heat(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Heat=nil then
       fmRBPms_Heat:=TfmRBPms_Heat.Create(Application);
     fmRBPms_Heat.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Heat;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Heat.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Heat,Param);
  end;
end;

function CreateAndViewPms_Water(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Water=nil then
       fmRBPms_Water:=TfmRBPms_Water.Create(Application);
     fmRBPms_Water.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Water;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Water.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Water,Param);
  end;
end;

function CreateAndViewPms_Builder(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Builder=nil then
       fmRBPms_Builder:=TfmRBPms_Builder.Create(Application);
     fmRBPms_Builder.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Builder;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Builder.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Builder,Param);
  end;
end;

function CreateAndViewPms_Investor(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Investor=nil then
       fmRBPms_Investor:=TfmRBPms_Investor.Create(Application);
     fmRBPms_Investor.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Investor;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Investor.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Investor,Param);
  end;
end;

function CreateAndViewPms_Style(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Style=nil then
       fmRBPms_Style:=TfmRBPms_Style.Create(Application);
     fmRBPms_Style.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Style;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Style.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Style,Param);
  end;
end;

function CreateAndViewPms_CountRoom(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_CountRoom=nil then
       fmRBPms_CountRoom:=TfmRBPms_CountRoom.Create(Application);
     fmRBPms_CountRoom.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_CountRoom;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_CountRoom.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_CountRoom,Param);
  end;
end;

function CreateAndViewPms_TypeRoom(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_TypeRoom=nil then
       fmRBPms_TypeRoom:=TfmRBPms_TypeRoom.Create(Application);
     fmRBPms_TypeRoom.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_TypeRoom;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_TypeRoom.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_TypeRoom,Param);
  end;
end;

function CreateAndViewPms_Station(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Station=nil then
       fmRBPms_Station:=TfmRBPms_Station.Create(Application);
     fmRBPms_Station.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Station;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Station.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Station,Param);
  end;
end;

function CreateAndViewPms_TypeHouse(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_TypeHouse=nil then
       fmRBPms_TypeHouse:=TfmRBPms_TypeHouse.Create(Application);
     fmRBPms_TypeHouse.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_TypeHouse;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_TypeHouse.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_TypeHouse,Param);
  end;
end;

function CreateAndViewPms_Stove(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Stove=nil then
       fmRBPms_Stove:=TfmRBPms_Stove.Create(Application);
     fmRBPms_Stove.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Stove;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Stove.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Stove,Param);
  end;
end;

function CreateAndViewPms_Furniture(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Furniture=nil then
       fmRBPms_Furniture:=TfmRBPms_Furniture.Create(Application);
     fmRBPms_Furniture.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Furniture;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Furniture.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Furniture,Param);
  end;
end;

//***************************************************
function CreateAndViewPms_Advertisment(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Advertisment=nil then
       fmRBPms_Advertisment:=TfmRBPms_Advertisment.Create(Application);
       fmRBPms_Advertisment.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Advertisment;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Advertisment.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
       fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Advertisment,Param);
  end;
end;
function CreateAndViewPms_Premises_Advertisment(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Premises_Advertisment=nil then
       fmRBPms_Premises_Advertisment:=TfmRBPms_Premises_Advertisment.Create(Application);
     fmRBPms_Premises_Advertisment.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Premises_Advertisment;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Premises_Advertisment.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Premises_Advertisment,Param);
  end;
end;

function CreateAndViewPms_City_Region(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_City_Region=nil then
       fmRBPms_City_Region:=TfmRBPms_City_Region.Create(Application);
     fmRBPms_City_Region.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_City_Region;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_City_Region.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_City_Region,Param);
  end;
end;

function CreateAndViewPms_Regions_Correspond(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Regions_Correspond=nil then
       fmRBPms_Regions_Correspond:=TfmRBPms_Regions_Correspond.Create(Application);
     fmRBPms_Regions_Correspond.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Regions_Correspond;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Regions_Correspond.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Regions_Correspond,Param);
  end;
end;

function CreateAndViewPms_Direction_Correspond(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Direction_Correspond=nil then
       fmRBPms_Direction_Correspond:=TfmRBPms_Direction_Correspond.Create(Application);
     fmRBPms_Direction_Correspond.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Direction_Correspond;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Direction_Correspond.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Direction_Correspond,Param);
  end;
end;


function CreateAndViewPms_Taxes(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Taxes=nil then
       fmRBPms_Taxes:=TfmRBPms_Taxes.Create(Application);
     fmRBPms_Taxes.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Taxes;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Taxes.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Taxes,Param);
  end;
end;

{function CreateAndViewPms_AreaBuilding(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_AreaBuilding=nil then
       fmRBPms_AreaBuilding:=TfmRBPms_AreaBuilding.Create(Application);
     fmRBPms_AreaBuilding.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG}{ on E: Exception do Assert(false,E.message); {$ENDIF}
 {   end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_AreaBuilding;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_AreaBuilding.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG}{ on E: Exception do Assert(false,E.message); {$ENDIF}
{    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_AreaBuilding,Param);
  end;
end;
 }
function CreateAndViewPms_PopulatedPoint(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_PopulatedPoint=nil then
       fmRBPms_PopulatedPoint:=TfmRBPms_PopulatedPoint.Create(Application);
     fmRBPms_PopulatedPoint.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_PopulatedPoint;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_PopulatedPoint.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_PopulatedPoint,Param);
  end;
end;

function CreateAndViewPms_LandFeature(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_LandFeature=nil then
       fmRBPms_LandFeature:=TfmRBPms_LandFeature.Create(Application);
     fmRBPms_LandFeature.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_LandFeature;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_LandFeature.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_LandFeature,Param);
  end;
end;

function CreateAndViewPms_ExchangeFormula(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_ExchangeFormula=nil then
       fmRBPms_ExchangeFormula:=TfmRBPms_ExchangeFormula.Create(Application);
     fmRBPms_ExchangeFormula.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_ExchangeFormula;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_ExchangeFormula.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_ExchangeFormula,Param);
  end;
end;

function CreateAndViewPms_LocationStatus(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_LocationStatus=nil then
       fmRBPms_LocationStatus:=TfmRBPms_LocationStatus.Create(Application);
     fmRBPms_LocationStatus.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_LocationStatus;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_LocationStatus.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_LocationStatus,Param);
  end;
end;

{function CreateAndViewPms_LandMark(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_LandMark=nil then
       fmRBPms_LandMark:=TfmRBPms_LandMark.Create(Application);
     fmRBPms_LandMark.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG}{ on E: Exception do Assert(false,E.message); {$ENDIF}
{    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_LandMark;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_LandMark.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG}{ on E: Exception do Assert(false,E.message); {$ENDIF}
{    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_LandMark,Param);
  end;
end;    }

function CreateAndViewPms_Object(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Object=nil then
       fmRBPms_Object:=TfmRBPms_Object.Create(Application);
     fmRBPms_Object.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Object;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Object.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Object,Param);
  end;
end;

function CreateAndViewPms_Direction(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Direction=nil then
       fmRBPms_Direction:=TfmRBPms_Direction.Create(Application);
     fmRBPms_Direction.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Direction;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Direction.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Direction,Param);
  end;
end;

function CreateAndViewPms_AccessWays(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_AccessWays=nil then
       fmRBPms_AccessWays:=TfmRBPms_AccessWays.Create(Application);
     fmRBPms_AccessWays.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_AccessWays;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_AccessWays.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_AccessWays,Param);
  end;
end;
//***************************************************
function CreateAndViewPms_Door(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Door=nil then
       fmRBPms_Door:=TfmRBPms_Door.Create(Application);
     fmRBPms_Door.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Door;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Door.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Door,Param);
  end;
end;

function CreateAndViewPms_Agent(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Agent=nil then
       fmRBPms_Agent:=TfmRBPms_Agent.Create(Application);
     fmRBPms_Agent.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Agent;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Agent.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Agent,Param);
  end;
end;

function CreateAndViewPms_Planning(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Planning=nil then
       fmRBPms_Planning:=TfmRBPms_Planning.Create(Application);
     fmRBPms_Planning.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Planning;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Planning.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Planning,Param);
  end;
end;

function CreateAndViewPms_Premises(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Premises=nil then
       fmRBPms_Premises:=TfmRBPms_Premises.Create(Application);
     fmRBPms_Premises.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Premises;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Premises.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Premises,Param);
  end;
end;

function CreateAndViewPms_Phone(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Phone=nil then
       fmRBPms_Phone:=TfmRBPms_Phone.Create(Application);
     fmRBPms_Phone.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Phone;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Phone.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Phone,Param);
  end;
end;

function CreateAndViewPms_Document(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Document=nil then
       fmRBPms_Document:=TfmRBPms_Document.Create(Application);
     fmRBPms_Document.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Document;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Document.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Document,Param);
  end;
end;

function CreateAndViewPms_SaleStatus(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_SaleStatus=nil then
       fmRBPms_SaleStatus:=TfmRBPms_SaleStatus.Create(Application);
     fmRBPms_SaleStatus.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_SaleStatus;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_SaleStatus.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_SaleStatus,Param);
  end;
end;

function CreateAndViewPms_TypePremises(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_TypePremises=nil then
       fmRBPms_TypePremises:=TfmRBPms_TypePremises.Create(Application);
     fmRBPms_TypePremises.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_TypePremises;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_TypePremises.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_TypePremises,Param);
  end;
end;

function CreateAndViewPms_SelfForm(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_SelfForm=nil then
       fmRBPms_SelfForm:=TfmRBPms_SelfForm.Create(Application);
     fmRBPms_SelfForm.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_SelfForm;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_SelfForm.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_SelfForm,Param);
  end;
end;

function CreateAndViewPms_Perm(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Perm=nil then
       fmRBPms_Perm:=TfmRBPms_Perm.Create(Application);
     fmRBPms_Perm.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Perm;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Perm.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Perm,Param);
  end;
end;

function CreateAndViewPms_UnitPrice(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_UnitPrice=nil then
       fmRBPms_UnitPrice:=TfmRBPms_UnitPrice.Create(Application);
     fmRBPms_UnitPrice.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_UnitPrice;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_UnitPrice.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_UnitPrice,Param);
  end;
end;

function CreateAndViewPms_Image(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBPms_Image=nil then
       fmRBPms_Image:=TfmRBPms_Image.Create(Application);
     fmRBPms_Image.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBPms_Image;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBPms_Image.Create(nil);
       fm.InitModalParams(InterfaceHandle,Param);
       if fm.ShowModal=mrOk then begin
        fm.ReturnModalParams(Param);
        Result:=true;
       end;
     finally
       fm.Free;
     end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=false;
  case Param.Visual.TypeView of
    tviMdiChild: Result:=CreateAndViewAsMDIChild;
    tvibvModal: Result:=CreateAndViewAsModal;
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkPms_Image,Param);
  end;
end;

function CreateAndViewRptPms_Price(InterfaceHandle: THandle; Param: PParamReportInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRptPms_Price=nil then
       fmRptPms_Price:=TfmRptPms_Price.Create(Application);
     fmRptPms_Price.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
end;

function CreateAndViewSrvPms_InportPrice(InterfaceHandle: THandle; Param: PParamServiceInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmSrvPms_ImportPrice=nil then
       fmSrvPms_ImportPrice:=TfmSrvPms_ImportPrice.Create(Application);
     fmSrvPms_ImportPrice.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

begin
  Result:=CreateAndViewAsMDIChild;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;

  // RBooks

  if InterfaceHandle=hInterfaceRbkPms_Street then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Street(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Region then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Region(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Balcony then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Balcony(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Condition then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Condition(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_SanitaryNode then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_SanitaryNode(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Heat then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Heat(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Water then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Water(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Builder then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Builder(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Investor then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Investor(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Style then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Style(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_CountRoom then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_CountRoom(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_TypeRoom then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_TypeRoom(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Station then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Station(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_TypeHouse then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_TypeHouse(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Stove then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Stove(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Furniture then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Furniture(InterfaceHandle,Param);
  end;
 //-------------------------------------
  if InterfaceHandle=hInterfaceRbkPms_Advertisment then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Advertisment(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Premises_Advertisment then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Premises_Advertisment(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_City_Region then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_City_Region(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Regions_Correspond then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Regions_Correspond(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Direction_Correspond then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Direction_Correspond(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Taxes then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Taxes(InterfaceHandle,Param);
  end;

{  if InterfaceHandle=hInterfaceRbkPms_AreaBuilding then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_AreaBuilding(InterfaceHandle,Param);
  end;
 }
  if InterfaceHandle=hInterfaceRbkPms_PopulatedPoint then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_PopulatedPoint(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_LandFeature then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_LandFeature(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_ExchangeFormula then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_ExchangeFormula(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_LocationStatus then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_LocationStatus(InterfaceHandle,Param);
  end;

{  if InterfaceHandle=hInterfaceRbkPms_LandMark then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_LandMark(InterfaceHandle,Param);
  end;
 }
  if InterfaceHandle=hInterfaceRbkPms_Object then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Object(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Direction then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Direction(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_AccessWays then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_AccessWays(InterfaceHandle,Param);
  end;

 //--------------------------------------
  if InterfaceHandle=hInterfaceRbkPms_Door then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Door(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Agent then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Agent(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Planning then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Planning(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Premises then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Premises(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Phone then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Phone(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Document then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Document(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_SaleStatus then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_SaleStatus(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_TypePremises then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_TypePremises(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_SelfForm then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_SelfForm(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Perm then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Perm(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_UnitPrice then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_UnitPrice(InterfaceHandle,Param);
  end;

  if InterfaceHandle=hInterfaceRbkPms_Image then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewPms_Image(InterfaceHandle,Param);
  end;

  // Reports

  if InterfaceHandle=hInterfaceRptPms_Price then begin
    if not isValidPointer(Param,SizeOf(TParamReportInterface)) then exit;
    Result:=CreateAndViewRptPms_Price(InterfaceHandle,Param);
  end;

  // Services

  if InterfaceHandle=hInterfaceSrvPms_ImportPrice then begin
    if not isValidPointer(Param,SizeOf(TParamServiceInterface)) then exit;
    Result:=CreateAndViewSrvPms_InportPrice(InterfaceHandle,Param);
  end;


end;

function RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
  isRemove: Boolean;
begin
  isRemove:=false;
  if InterfaceHandle=hInterfaceRbkPms_Street then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Street)
    else if fmRBPms_Street<>nil then begin
     fmRBPms_Street.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Street.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Region then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Region)
    else if fmRBPms_Region<>nil then begin
     fmRBPms_Region.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Region.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Balcony then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Balcony)
    else if fmRBPms_Balcony<>nil then begin
     fmRBPms_Balcony.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Balcony.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Condition then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Condition)
    else if fmRBPms_Condition<>nil then begin
     fmRBPms_Condition.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Condition.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_SanitaryNode then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_SanitaryNode)
    else if fmRBPms_SanitaryNode<>nil then begin
     fmRBPms_SanitaryNode.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_SanitaryNode.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Heat then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Heat)
    else if fmRBPms_Heat<>nil then begin
     fmRBPms_Heat.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Heat.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Water then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Water)
    else if fmRBPms_Water<>nil then begin
     fmRBPms_Water.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Water.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Builder then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Builder)
    else if fmRBPms_Builder<>nil then begin
     fmRBPms_Builder.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Builder.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Investor then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Investor)
    else if fmRBPms_Investor<>nil then begin
     fmRBPms_Investor.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Investor.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_Style then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Style)
    else if fmRBPms_Style<>nil then begin
     fmRBPms_Style.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Style.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_CountRoom then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_CountRoom)
    else if fmRBPms_CountRoom<>nil then begin
     fmRBPms_CountRoom.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_CountRoom.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_TypeRoom then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_TypeRoom)
    else if fmRBPms_TypeRoom<>nil then begin
     fmRBPms_TypeRoom.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_TypeRoom.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Station then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Station)
    else if fmRBPms_Station<>nil then begin
     fmRBPms_Station.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Station.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_TypeHouse then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_TypeHouse)
    else if fmRBPms_TypeHouse<>nil then begin
     fmRBPms_TypeHouse.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_TypeHouse.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Stove then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Stove)
    else if fmRBPms_Stove<>nil then begin
     fmRBPms_Stove.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Stove.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Furniture then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Furniture)
    else if fmRBPms_Furniture<>nil then begin
     fmRBPms_Furniture.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Furniture.ActiveQuery(true);
    end;
  end;
//*************************************
  if InterfaceHandle=hInterfaceRbkPms_Advertisment then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Furniture)
    else if fmRBPms_Advertisment<>nil then begin
    fmRBPms_Advertisment.SetInterfaceHandle(InterfaceHandle);
    fmRBPms_Advertisment.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Premises_Advertisment then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Premises_Advertisment)
    else if fmRBPms_Premises_Advertisment<>nil then begin
     fmRBPms_Premises_Advertisment.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Premises_Advertisment.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_City_Region then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_City_Region)
    else if fmRBPms_City_Region<>nil then begin
     fmRBPms_City_Region.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_City_Region.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_Regions_Correspond then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Regions_Correspond)
    else if fmRBPms_Regions_Correspond<>nil then begin
     fmRBPms_Regions_Correspond.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Regions_Correspond.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_Direction_Correspond then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Direction_Correspond)
    else if fmRBPms_Direction_Correspond<>nil then begin
     fmRBPms_Direction_Correspond.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Direction_Correspond.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_Taxes then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Taxes)
    else if fmRBPms_Taxes<>nil then begin
     fmRBPms_Taxes.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Taxes.ActiveQuery(true);
    end;
  end;

{  if InterfaceHandle=hInterfaceRbkPms_AreaBuilding then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_AreaBuilding)
    else if fmRBPms_AreaBuilding<>nil then begin
     fmRBPms_AreaBuilding.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_AreaBuilding.ActiveQuery(true);
    end;
  end;
 }
  if InterfaceHandle=hInterfaceRbkPms_PopulatedPoint then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_PopulatedPoint)
    else if fmRBPms_PopulatedPoint<>nil then begin
     fmRBPms_PopulatedPoint.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_PopulatedPoint.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_LandFeature then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_LandFeature)
    else if fmRBPms_LandFeature<>nil then begin
     fmRBPms_LandFeature.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_LandFeature.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_ExchangeFormula then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_ExchangeFormula)
    else if fmRBPms_ExchangeFormula<>nil then begin
     fmRBPms_ExchangeFormula.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_ExchangeFormula.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_LocationStatus then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_LocationStatus)
    else if fmRBPms_LocationStatus<>nil then begin
     fmRBPms_LocationStatus.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_LocationStatus.ActiveQuery(true);
    end;
  end;

{  if InterfaceHandle=hInterfaceRbkPms_LandMark then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_LandMark)
    else if fmRBPms_LandMark<>nil then begin
     fmRBPms_LandMark.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_LandMark.ActiveQuery(true);
    end;
  end;
 }
  if InterfaceHandle=hInterfaceRbkPms_Object then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Object)
    else if fmRBPms_Object<>nil then begin
     fmRBPms_Object.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Object.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_Direction then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Direction)
    else if fmRBPms_Direction<>nil then begin
     fmRBPms_Direction.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Direction.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRbkPms_AccessWays then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_AccessWays)
    else if fmRBPms_AccessWays<>nil then begin
     fmRBPms_AccessWays.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_AccessWays.ActiveQuery(true);
    end;
  end;

//*************************************
  if InterfaceHandle=hInterfaceRbkPms_Door then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Door)
    else if fmRBPms_Door<>nil then begin
     fmRBPms_Door.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Door.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Agent then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Agent)
    else if fmRBPms_Agent<>nil then begin
     fmRBPms_Agent.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Agent.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Planning then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Planning)
    else if fmRBPms_Planning<>nil then begin
     fmRBPms_Planning.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Planning.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Premises then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Premises)
    else if fmRBPms_Premises<>nil then begin
     fmRBPms_Premises.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Premises.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Phone then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Phone)
    else if fmRBPms_Phone<>nil then begin
     fmRBPms_Phone.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Phone.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Document then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Document)
    else if fmRBPms_Document<>nil then begin
     fmRBPms_Document.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Document.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_SaleStatus then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_SaleStatus)
    else if fmRBPms_SaleStatus<>nil then begin
     fmRBPms_SaleStatus.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_SaleStatus.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_TypePremises then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_TypePremises)
    else if fmRBPms_TypePremises<>nil then begin
     fmRBPms_TypePremises.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_TypePremises.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_SelfForm then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_SelfForm)
    else if fmRBPms_SelfForm<>nil then begin
     fmRBPms_SelfForm.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_SelfForm.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Perm then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Perm)
    else if fmRBPms_Perm<>nil then begin
     fmRBPms_Perm.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Perm.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_UnitPrice then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_UnitPrice)
    else if fmRBPms_UnitPrice<>nil then begin
     fmRBPms_UnitPrice.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_UnitPrice.ActiveQuery(true);
    end;
  end;
  if InterfaceHandle=hInterfaceRbkPms_Image then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRBPms_Image)
    else if fmRBPms_Image<>nil then begin
     fmRBPms_Image.SetInterfaceHandle(InterfaceHandle);
     fmRBPms_Image.ActiveQuery(true);
    end;
  end;

  if InterfaceHandle=hInterfaceRptPms_Price then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmRptPms_Price)
    else if fmRptPms_Price<>nil then begin
      fmRptPms_Price.SetInterfaceHandle(InterfaceHandle);
    end;
  end;

  if InterfaceHandle=hInterfaceSrvPms_ImportPrice then begin
    isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
    if isRemove then FreeAndNil(fmSrvPms_ImportPrice)
    else if fmSrvPms_ImportPrice<>nil then begin
      fmSrvPms_ImportPrice.SetInterfaceHandle(InterfaceHandle);
    end;
  end;

  result:=not isRemove;
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

procedure SetAppAndScreen_(A: TApplication; S: TScreen);stdcall;
begin
  Application:=A;
  Screen:=S;
  fmOptions.ParentWindow:=A.Handle;
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
    ClearListInterfaceHandles;
    AddToListInterfaceHandles;

    ClearListMenuHandles;
    AddToListMenuRootHandles;

    ClearListOptionHandles;
    AddToListOptionRootHandles;

    FreeAndNil(fmOptions);
    fmOptions:=TfmOptions.Create(nil);
    fmOptions.ParentWindow:=Application.Handle;

    ClearListToolBarHandles;
    AddToListToolBarHandles;
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


//**************** end of Export *************************




end.
