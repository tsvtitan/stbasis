unit UDocTurnTsvCode;

interface

{$I stbasis.inc}

uses Windows, Forms, UDocTurnTsvData, UMainUnited, Classes, UDocTurnTsvDm, graphics, dialogs,
     IBDatabase, IBQuery, Controls, tsvHint, db, SysUtils, IBServices, stdctrls,
     comctrls, extctrls;

// Internal

procedure DeInitAll;
procedure ClearListInterfaceHandles;
procedure AddToListInterfaceHandles;
function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
function RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
procedure ClearListMenuHandles;
procedure ClearListMenuDocums;
procedure MenuClickProc(MenuHandle: THandle);stdcall;
procedure AddToListMenuRootHandles;
function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
procedure ClearListToolBarHandles;
procedure ToolButtonClickProc(ToolButtonHandle: THandle);stdcall;
procedure AddToListToolBarHandles;
procedure ClearListOptionHandles;
procedure AddToListOptionRootHandles;
procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;
procedure ClearListDocums(ClassType: TClass);
procedure RefreshListDocums(ClassType: TClass);

// Export
procedure InitAll_;stdcall;
procedure GetInfoLibrary_(P: PInfoLibrary);stdcall;
procedure RefreshLibrary_;stdcall;
procedure SetConnection_(IBDbase: TIBDatabase; IBTran: TIBTransaction;
                         IBDBSecurity: TIBDatabase; IBTSecurity: TIBTransaction);stdcall;


implementation

uses ActiveX,Menus,tsvDbGrid,dbtree, URBMainTreeView, UDocMainGrid,
     URBTypeDoc, URBBasisTypeDoc,
     UJRDocum,
     UDocWarrant,
     UDocTurnTsvOptions;

//******************* Internal ************************

procedure InitAll_;stdcall;
begin
 try
  CoInitialize(nil);
  dm:=Tdm.Create(nil);
  fmOptions:=TfmOptions.Create(nil);

  ListInterfaceHandles:=TList.Create;
  AddToListInterfaceHandles;

  ListMenuDocums:=TList.Create;
  ListMenuHandles:=Tlist.Create;
  AddToListMenuRootHandles;

  ListOptionHandles:=TList.Create;
  AddToListOptionRootHandles;

  ListToolBarHandles:=TList.Create;
  AddToListToolBarHandles;

  ListDocums:=TList.Create;

  isInitAll:=true;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure DeInitAll;
begin
 try
  if not isInitAll then exit;

  FreeAndNil(fmRBTypeDoc);
  FreeAndNil(fmJRDocum);
  FreeAndNil(fmRBBasisTypeDoc);
  
  ClearListDocums(TForm);
  ListDocums.Free;

  FreeAndNil(fmOptions);

  ClearListMenuDocums;
  ListMenuDocums.Free;

  ClearListMenuHandles;
  ListMenuHandles.free;

  ClearListOptionHandles;
  ListOptionHandles.Free;

  ClearListToolBarHandles;
  ListToolBarHandles.Free;

  ClearListInterfaceHandles;
  ListInterfaceHandles.Free;

  CoUnInitialize;
 except
//  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
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
  if ToolButtonHandle=hToolButtonJrDocum then MenuClickProc(hMenuJrDocum);
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

var
  tBar1: THandle;
begin
  if (hMenuJrDocum<>MENU_INVALID_HANDLE) then begin
   tbar1:=CreateToolBarLocal('Документы','Панель документов',0);
   ListToolBarHandles.Add(Pointer(tbar1));
   if hMenuJrDocum<>MENU_INVALID_HANDLE then
    hToolButtonJrDocum:=CreateToolButtonLocal(tbar1,'Журнал документов',NameJrDocum,0,ToolButtonClickProc);
   _RefreshToolBar(tbar1);
  end;
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
end;

procedure BeforeSetOptionProc(OptionHandle: THandle);stdcall;
begin
end;

procedure AfterSetOptionProc(OptionHandle: THandle; isOk: Boolean);stdcall;
begin
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

procedure ClearListMenuDocums;
var
  i: Integer;
  P: PTempDocumRecord;
begin
  for i:=0 to ListMenuDocums.Count-1 do begin
    P:=ListMenuDocums.Items[i];
    Dispose(P);
  end;
  ListMenuDocums.Clear;
end;

procedure MenuClickProc(MenuHandle: THandle);stdcall;
var
  TPRBI: TParamRBookInterface;
  TPJI: TParamJournalInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  FillChar(TPJI,SizeOf(TPJI),0);

  if MenuHandle=hMenuRbkTypeDoc then ViewInterface(hInterfaceRbkTypeDoc,@TPRBI);
  if MenuHandle=hMenuJrDocum then ViewInterface(hInterfaceJrDocum,@TPJI);
  if MenuHandle=hMenuRbkBasisTypeDoc then ViewInterface(hInterfaceRbkBasisTypeDoc,@TPRBI);
end;

function GetTempDocumRecordByMenu(MenuHandle: THandle): PTempDocumRecord;
var
  i: Integer;
  P: PTempDocumRecord;
begin
  Result:=nil;
  for i:=0 to ListMenuDocums.Count-1 do begin
    P:=ListMenuDocums.Items[i];
    if P.hMenu=MenuHandle then begin
      Result:=P;
      exit;
    end;
  end;
end;

procedure MenuDocumClickProc(MenuHandle: THandle);stdcall;
var
  TPDI: TParamDocumentInterface;
  P: PTempDocumRecord;
begin
  P:=GetTempDocumRecordByMenu(MenuHandle);
  if P=nil then exit;
  FillChar(TPDI,SizeOf(TPDI),0);
  TPDI.Visual.TypeView:=tviMdiChild;
  TPDI.TypeOperation:=todAdd;
  TPDI.Head.TypeDocId:=P.TypeDocId;
  _ViewInterface(P.hInterface,@TPDI);
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

  procedure CreateDocumMenus;
  var
    isFreeDocs: Boolean;
    List: TList;
    hMenuCurrent: THandle;
    TPRBI: TParamRBookInterface;
    s,e,i: Integer;
    InterfaceName: string;
    MenuName: string;
    hInterface: THandle;
    P: PTempDocumRecord;
  begin
    hMenuDocs:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuDocums,PChar(ChangeString(ConstsMenuDocums,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
    ListMenuHandles.Add(Pointer(hMenuDocs));

    List:=TList.Create;
    try
      FillChar(TPRBI,Sizeof(TPRBI),0);
      TPRBI.Visual.TypeView:=tviOnlyData;
      TPRBI.Condition.WhereStr:=' sign=1 ';
      TPRBI.Condition.OrderStr:=' name ';
      if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
        GetStartAndEndByPRBI(@TPRBI,s,e);
        for i:=s to e do begin
          InterfaceName:=GetValueByPRBI(@TPRBI,i,'interfacename');
          if Trim(InterfaceName)<>'' then begin
            hInterface:=_GetInterfaceHandleFromName(PChar(InterfaceName));
            if _isValidInterface(hInterface) then begin
              if _isPermissionOnInterface(hInterface,ttiaView) then begin
                MenuName:=GetValueByPRBI(@TPRBI,i,'name');
                hMenuCurrent:=CreateMenuLocal(hMenuDocs,PChar(MenuName),PChar(InterfaceName),tcmAddLast,
                                              MENU_INVALID_HANDLE,-1,0,MenuDocumClickProc);
                if hMenuCurrent<>MENU_INVALID_HANDLE then begin
                  New(P);
                  FillChar(P^,SizeOf(TTempDocumRecord),0);
                  P.hInterface:=hInterface;
                  P.InterfaceName:=InterfaceName;
                  P.hMenu:=hMenuCurrent;
                  P.TypeDocId:=GetValueByPRBI(@TPRBI,i,'typedoc_id');
                  ListMenuDocums.Add(P);
                  List.Add(Pointer(hMenuCurrent));
                end;  
              end;
            end;
          end;
        end;
      end;

      isFreeDocs:=(hMenuDocs<>MENU_INVALID_HANDLE)and
                  (List.Count=0);
      if isFreeDocs then
        if _FreeMenu(hMenuDocs) then hMenuDocs:=MENU_INVALID_HANDLE;
        
    finally
      List.Free;
    end;    
  end;

var
  isFreeDocTurn: Boolean;
  isFreeRBooks: Boolean;
  isFreeJournals: Boolean;
begin
  // RBooks

  hMenuRBooks:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuRBooks,PChar(ChangeString(ConstsMenuRBooks,'&','')),
                               tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuRBooks));

  hMenuDocTurn:=CreateMenuLocal(hMenuRBooks,ConstsMenuDocTurn,ConstsMenuDocTurn,tcmAddFirst);

  hMenuRbkTypeDoc:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkTypeDoc) then
   hMenuRbkTypeDoc:=CreateMenuLocal(hMenuDocTurn,'Виды документов',NameRbkTypeDoc,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);

  hMenuRbkBasisTypeDoc:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceRbkBasisTypeDoc) then
   hMenuRbkBasisTypeDoc:=CreateMenuLocal(hMenuDocTurn,'Основания вида документа',NameRbkBasisTypeDoc,tcmAddLast,MENU_INVALID_HANDLE,-1,0,MenuClickProc);
   
  isFreeDocTurn:=(hMenuDocTurn<>MENU_INVALID_HANDLE)and
                 (hMenuRbkTypeDoc=MENU_INVALID_HANDLE)and
                 (hMenuRbkBasisTypeDoc=MENU_INVALID_HANDLE);

  if isFreeDocTurn then
    if _FreeMenu(hMenuDocTurn) then hMenuDocTurn:=MENU_INVALID_HANDLE;

  isFreeRBooks:=(hMenuRBooks<>MENU_INVALID_HANDLE)and
                (hMenuDocTurn=MENU_INVALID_HANDLE);
  if isFreeRBooks then
    if _FreeMenu(hMenuRBooks) then hMenuRBooks:=MENU_INVALID_HANDLE;

  // Docums

  CreateDocumMenus;

  // Journals

  hMenuJournals:=CreateMenuLocal(MENU_ROOT_HANDLE,ConstsMenuJournals,PChar(ChangeString(ConstsMenuJournals,'&','')),
                                tcmInsertBefore,_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuService));
  ListMenuHandles.Add(Pointer(hMenuJournals));

  hMenuJrDocum:=MENU_INVALID_HANDLE;
  if isPermissionOnInterfaceView(hInterfaceJrDocum) then
   hMenuJrDocum:=CreateMenuLocal(hMenuJournals,'Журнал документов',NameJrDocum,tcmAddLast,MENU_INVALID_HANDLE,0,0,MenuClickProc);

  isFreeJournals:=(hMenuJournals<>MENU_INVALID_HANDLE)and
                  (hMenuJrDocum=MENU_INVALID_HANDLE);
  if isFreeJournals then
    if _FreeMenu(hMenuJournals) then hMenuJournals:=MENU_INVALID_HANDLE;
   
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
  hInterfaceRbkTypeDoc:=CreateLocalInterface(NameRbkTypeDoc,NameRbkTypeDoc);
  CreateLocalPermission(hInterfaceRbkTypeDoc,tbTypeDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkTypeDoc,tbTypeDoc,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkTypeDoc,tbTypeDoc,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkTypeDoc,tbTypeDoc,ttpDelete,false,ttiaDelete);

  hInterfaceJrDocum:=CreateLocalInterface(NameJrDocum,NameJrDocum,ttiJournal);
  CreateLocalPermission(hInterfaceJrDocum,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrDocum,tbTypeDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrDocum,tbBasisTypeDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceJrDocum,tbDocum,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceJrDocum,tbDocum,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceJrDocum,tbDocum,ttpDelete,false,ttiaDelete);

  hInterfaceRbkBasisTypeDoc:=CreateLocalInterface(NameRbkBasisTypeDoc,NameRbkBasisTypeDoc);
  CreateLocalPermission(hInterfaceRbkBasisTypeDoc,tbBasisTypeDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkBasisTypeDoc,tbTypeDoc,ttpSelect,false);
  CreateLocalPermission(hInterfaceRbkBasisTypeDoc,tbBasisTypeDoc,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceRbkBasisTypeDoc,tbBasisTypeDoc,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceRbkBasisTypeDoc,tbBasisTypeDoc,ttpDelete,false,ttiaDelete);

  hInterfaceDocWarrantHead:=CreateLocalInterface(NameDocWarrantHead,NameDocWarrantHead,ttiDocument);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbWarrantHead,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbDocum,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbPlant,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbRespondents,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbWarrantHead,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbDocum,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbWarrantHead,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbDocum,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbWarrantHead,ttpDelete,false,ttiaDelete);
  CreateLocalPermission(hInterfaceDocWarrantHead,tbDocum,ttpDelete,false,ttiaDelete);

  hInterfaceDocWarrantRecord:=CreateLocalInterface(NameDocWarrantRecord,NameDocWarrantRecord,ttiDocument);
  CreateLocalPermission(hInterfaceDocWarrantRecord,tbWarrantRecord,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantRecord,tbUnitOfMeasure,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantRecord,tbNomenclature,ttpSelect,false);
  CreateLocalPermission(hInterfaceDocWarrantRecord,tbWarrantRecord,ttpInsert,false,ttiaAdd);
  CreateLocalPermission(hInterfaceDocWarrantRecord,tbWarrantRecord,ttpUpdate,false,ttiaChange);
  CreateLocalPermission(hInterfaceDocWarrantRecord,tbWarrantRecord,ttpDelete,false,ttiaDelete);

end;

function CreateAndViewTypeDoc(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBTypeDoc=nil then
       fmRBTypeDoc:=TfmRBTypeDoc.Create(Application);
     fmRBTypeDoc.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBTypeDoc;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBTypeDoc.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkTypeDoc,Param);
  end;
end;

function CreateAndViewDocum(InterfaceHandle: THandle; Param: PParamJournalInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmJRDocum=nil then
       fmJRDocum:=TfmJRDocum.Create(Application);
     fmJRDocum.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmJRDocum;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmJRDocum.Create(nil);
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
    tviOnlyData: Result:=QueryForParamJournalInterface(IBDB,SQLJRDocum,Param);
  end;
end;

function CreateAndViewBasisTypeDoc(InterfaceHandle: THandle; Param: PParamRBookInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   begin
    result:=false;
    try
     if fmRBBasisTypeDoc=nil then
       fmRBBasisTypeDoc:=TfmRBBasisTypeDoc.Create(Application);
     fmRBBasisTypeDoc.InitMdiChildParams(InterfaceHandle,Param);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmRBBasisTypeDoc;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmRBBasisTypeDoc.Create(nil);
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
    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLRbkBasisTypeDoc,Param);
  end;
end;

function CreateAndViewDocWarrant(InterfaceHandleHead,InterfaceHandleRecord: THandle; Param: PParamDocumentInterface): Boolean;

   function CreateAndViewAsMDIChild: Boolean;
   var
     fm: TfmDocWarrant;
   begin
    result:=false;
    try
{     if fmDocWarrant=nil then
        fmDocWarrant:=TfmDocWarrant.Create(Application);
     fmDocWarrant.InitMdiChildParams(InterfaceHandleHead,InterfaceHandleRecord,Param);}
     fm:=TfmDocWarrant.Create(Application);
     fm.InitMdiChildParams(InterfaceHandleHead,InterfaceHandleRecord,Param);
     ListDocums.Add(fm);
     Result:=true;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   end;

   function CreateAndViewAsModal: Boolean;
   var
    fm: TfmDocWarrant;
   begin
    Result:=false;
    try
     fm:=nil;
     try
       fm:=TfmDocWarrant.Create(nil);
       fm.InitModalParams(InterfaceHandleHead,InterfaceHandleRecord,Param);
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
//    tviOnlyData: Result:=QueryForParamRBookInterface(IBDB,SQLDocWarrant,Param);
  end;
end;

function ViewInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceRbkTypeDoc then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewTypeDoc(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceJrDocum then begin
    if not isValidPointer(Param,SizeOf(TParamJournalInterface)) then exit;
    Result:=CreateAndViewDocum(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceRbkBasisTypeDoc then begin
    if not isValidPointer(Param,SizeOf(TParamRBookInterface)) then exit;
    Result:=CreateAndViewBasisTypeDoc(InterfaceHandle,Param);
  end;
  if InterfaceHandle=hInterfaceDocWarrantHead then begin
    if not isValidPointer(Param,SizeOf(TParamDocumentInterface)) then exit;
    Result:=CreateAndViewDocWarrant(hInterfaceDocWarrantHead,hInterfaceDocWarrantRecord,Param);
  end;
end;

function RefreshDocum(InterfaceHandle: THandle; Param: PParamRefreshJournalInterface): Boolean;
begin
  Result:=false;
  if fmJRDocum=nil then exit;
  fmJRDocum.ActiveQuery(false);
  Result:=fmJRDocum.LocateByRefreshParam(Param);
end;

function RefreshInterface(InterfaceHandle: THandle; Param: Pointer): Boolean; stdcall;
begin
  Result:=false;
  if InterfaceHandle=hInterfaceJrDocum then begin
    if not isValidPointer(Param,SizeOf(TParamRefreshJournalInterface)) then exit;
    Result:=RefreshDocum(InterfaceHandle,Param);
  end;
end;

procedure ClearListDocums(ClassType: TClass);
var
  i: Integer;
  obj: TObject;
begin
  for i:=ListDocums.Count-1 downto 0 do begin
   obj:=ListDocums.Items[i];
   if obj is ClassType then
    TObject(obj).Free;
  end;
  ListDocums.Clear;
end;

procedure RefreshListDocums(ClassType: TClass);
var
  i: Integer;
  obj: TObject;
begin
  for i:=0 to ListDocums.Count-1 do begin
   obj:=ListDocums.Items[i];
   if (obj is ClassType) and (obj is TfmDocMainGrid) then
    TfmDocMainGrid(obj).ActiveQuery(true);
  end;
end;

function isPermissionOnInterfaceView(InterfaceHandle: THandle): Boolean;
var
    isRemove: Boolean;
begin
    isRemove:=false;
    if InterfaceHandle=hInterfaceRbkTypeDoc then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBTypeDoc)
      else if fmRBTypeDoc<>nil then begin
       fmRBTypeDoc.SetInterfaceHandle(InterfaceHandle);
       fmRBTypeDoc.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceJrDocum then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmJRDocum)
      else if fmJRDocum<>nil then begin
       fmJRDocum.SetInterfaceHandle(InterfaceHandle);
       fmJRDocum.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceRbkBasisTypeDoc then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then FreeAndNil(fmRBBasisTypeDoc)
      else if fmRBBasisTypeDoc<>nil then begin
       fmRBBasisTypeDoc.SetInterfaceHandle(InterfaceHandle);
       fmRBBasisTypeDoc.ActiveQuery(true);
      end;
    end;
    if InterfaceHandle=hInterfaceDocWarrantHead then begin
      isRemove:=not _isPermissionOnInterface(InterfaceHandle,ttiaView);
      if isRemove then begin
        ClearListDocums(TfmDocWarrant);
      end else begin
        RefreshListDocums(TfmDocWarrant);
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
  
    ClearListMenuDocums;

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
