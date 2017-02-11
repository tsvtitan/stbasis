unit UMainOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst, UMainData,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type
  TfmMainOptions = class(TForm)
    pc: TPageControl;
    tsGeneral: TTabSheet;
    tsDataBase: TTabSheet;
    pnGeneral: TPanel;
    pnDataBase: TPanel;
    tsShortCut: TTabSheet;
    grbBaseDir: TGroupBox;
    edBaseDir: TEdit;
    bibBaseDir: TBitBtn;
    chbLastOpen: TCheckBox;
    tsLibrary: TTabSheet;
    pnLibrary: TPanel;
    clbLibrary: TCheckListBox;
    grbLibrary: TGroupBox;
    pngrbLibrary: TPanel;
    meLibrary: TMemo;
    splLibrary: TSplitter;
    pnShortCut: TPanel;
    pnShortCutBottom: TPanel;
    tvShortCut: TTreeView;
    htShortCut: THotKey;
    lbShortCut: TLabel;
    ilShortCut: TImageList;
    ilOptions: TImageList;
    tsConsts: TTabSheet;
    pnConsts: TPanel;
    sgConsts: TStringGrid;
    grbConsts: TGroupBox;
    pngrbConsts: TPanel;
    meConsts: TMemo;
    splConsts: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure bibBaseDirClick(Sender: TObject);
    procedure clbLibraryClick(Sender: TObject);
    procedure clbLibraryClickCheck(Sender: TObject);
    procedure tvShortCutAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure tvShortCutChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure sgConstsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgConstsDblClick(Sender: TObject);
    procedure sgConstsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    Const_Id: Integer;
    procedure htShortCutKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
    function AddToTreeViewHotKeys(ndParent: TTreeNode; ndText: String;
                                  PData: Pointer; TypeHotKey: TTypeHotKeys;
                                  ShCut: TShortCut):TTreeNode;
    procedure CleartvShortCut;
    procedure ClearStringGridConsts;
    procedure ViewConstHint(Row: Integer);
  public
    isChangeLibrary: Boolean;
    isChangeConsts: Boolean;
    NewDataBaseName: string;
    procedure FillCheckListBoxLibrary;
    procedure SetLibraryFromCheckListBox;
    procedure FillTreeViewHotKeys;
    procedure SetHotKeysFromTreeView;
    procedure FillStringGridConsts;
    procedure SetConstsFromStringGrid;
//    procedure SaveToIniLibrary;
  end;

  TNewHotKey=class(THotKey)
  public
   property OnKeyUp;
  end;

  TNewStringGrid=class(TStringGrid)
  public
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMPaint(var Msg: TWMPaint); message WM_Paint;
    procedure WndProc(var Message: TMessage);override;
  end;

var
  fmMainOptions: TfmMainOptions;
const
  WM_REDRAW=WM_USER+1000;  

implementation


uses UMainCode, UServerConnect, UMainUnited, UMain, UEditConst;

{$R *.DFM}

procedure TNewStringGrid.WMVScroll(var Msg: TWMVScroll);
begin
  {ModifyScrollBar(SB_VERT, Msg.ScrollCode, Msg.Pos);
  setPlace;}
  inherited;
end;

procedure TNewStringGrid.WMHScroll(var Msg: TWMHScroll);
begin
{  ModifyScrollBar(SB_HORZ, Msg.ScrollCode, Msg.Pos);
  setPlace;}
  inherited;
end;

procedure TNewStringGrid.WMPaint(var Msg: TWMPaint);
begin
  inherited;
end;

procedure TNewStringGrid.WndProc(var Message: TMessage);
begin
  case Message.Msg of
     WM_REDRAW: begin
       RecreateWnd;
     end;
  end;
  inherited;
end;

procedure TfmMainOptions.FormCreate(Sender: TObject);
var
  sgNew: TNewStringGrid;
begin
  Left:=-1000;
  Top:=-1000;
  isChangeLibrary:=false;
  tvShortCut.FullExpand;
  lbShortCut.Enabled:=false;
  htShortCut.Enabled:=false;
  TNewHotKey(htShortCut).OnKeyUp:=htShortCutKeyUp;

  isChangeConsts:=false;  
  sgNew:=TNewStringGrid.Create(Self);
  sgNew.RowCount:=sgConsts.RowCount;
  sgNew.ColCount:=sgConsts.ColCount;
  sgNew.FixedRows:=sgConsts.FixedRows;
  sgNew.FixedCols:=sgConsts.FixedCols;
  sgNew.DefaultRowHeight:=sgConsts.DefaultRowHeight;
  sgNew.Options:=sgConsts.Options;
  sgNew.Align:=sgConsts.Align;
  sgNew.DefaultColWidth:=sgConsts.DefaultColWidth;
  sgNew.Height:=sgConsts.Height;
  sgNew.OnSelectCell:=sgConsts.OnSelectCell;
  sgNew.OnDblClick:=sgConsts.OnDblClick;
  sgNew.OnKeyDown:=sgConsts.OnKeyDown;
  sgConsts.Free;
  sgNew.parent:=pnConsts;
  sgNew.Name:='sgConsts';
  sgConsts:=sgNew;
  sgNew.TabOrder:=1;
  grbConsts.TabOrder:=2;
  
end;

procedure TfmMainOptions.CleartvShortCut;
var
  i: integer;
  P: PNodeHotKey;
begin
 tvShortCut.Items.BeginUpdate;
 try
  for i:=0 to tvShortCut.Items.Count-1 do begin
    P:=PNodeHotKey(tvShortCut.Items[i].data);
    Dispose(P);
  end;
  tvShortCut.Items.Clear;
 finally
   tvShortCut.Items.EndUpdate;
 end; 
end;

procedure TfmMainOptions.ClearStringGridConsts;
var
  i: integer;
  P: PInfoCellConst;
begin
  for i:=sgConsts.RowCount-1 downto 1 do begin
    P:=PInfoCellConst(sgConsts.Objects[0,i]);
    sgConsts.Cells[0,i]:='';
    sgConsts.Cells[1,i]:='';
    sgConsts.Objects[0,i]:=nil;
    if P<>nil then
     Dispose(P);
  end;
  sgConsts.RowCount:=2;
  pnConsts.Enabled:=false;
end;

procedure TfmMainOptions.FormDestroy(Sender: TObject);
begin
  CleartvShortCut;
  ClearStringGridConsts;
  sgConsts.Free;
end;

procedure TfmMainOptions.bibBaseDirClick(Sender: TObject);
var
  fm: TfmServerConnect;
  Prot: TProtocol;
  SrvName: array[0..ConstSrvName] of char;
begin
  try
   fm:=nil;
   try
    fm:=TfmServerConnect.Create(nil);
    FillChar(SrvName,sizeof(SrvName),0);
    GetProtocolAndServerName_(PChar(edBaseDir.Text),Prot,SrvName);
    fm.SetParams(Prot,SrvName);
    if fm.ShowModal=mrOk then begin
     if ConnectServer(fm.ConnectString,ConstConnectUserName,ConstConnectUserPass,'') then
       edBaseDir.Text:=fm.ConnectString;
    end;
   finally
    fm.Free;
   end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmMainOptions.FillCheckListBoxLibrary;
var
  i: integer;
  P: PInfoLib;
begin
  meLibrary.Lines.Clear;
  clbLibrary.Clear;
  for i:=0 to ListLibs.Count-1 do begin
   P:=ListLibs.Items[i];
   clbLibrary.Items.AddObject(P.ExeName,TObject(P));
   clbLibrary.Checked[i]:=P.Active
  end;
  if clbLibrary.Items.Count>0 then
   clbLibrary.ItemIndex:=0;
  clbLibraryClick(nil);
  isChangeLibrary:=false;
end;


procedure TfmMainOptions.clbLibraryClick(Sender: TObject);
var
  P: PInfoLib;
begin
  if clbLibrary.ItemIndex<>-1 then begin
   P:=Pointer(clbLibrary.items.Objects[clbLibrary.ItemIndex]);
   if P<>nil then
    meLibrary.Lines.Text:=P.Hint;
  end;
end;

procedure TfmMainOptions.SetLibraryFromCheckListBox;
var
  i: integer;
  P: PInfoLib;
begin
  for i:=0 to clbLibrary.Items.Count-1 do begin
   P:=Pointer(clbLibrary.items.Objects[i]);
   if P<>nil then
     P.Active:=clbLibrary.Checked[i];
  end;
end;

procedure TfmMainOptions.clbLibraryClickCheck(Sender: TObject);
begin
  isChangeLibrary:=true;
end;

procedure TfmMainOptions.tvShortCutAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
var
  rt: Trect;
begin
  if GetFocus<>tvShortCut.Handle then begin
    if Node=tvShortCut.Selected then begin
      tvShortCut.Canvas.Brush.Style:=bsSolid;
      tvShortCut.Canvas.Brush.Color:=clBtnFace;
      rt:=Node.DisplayRect(true);
      tvShortCut.Canvas.FillRect(rt);
      tvShortCut.Canvas.Brush.Style:=bsClear;
      tvShortCut.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
 //     tv.Canvas.DrawFocusRect(rt);
//      DefaultDraw:=false;
    end else begin
     DefaultDraw:=true;
    end;
  end else DefaultDraw:=true;
end;

procedure TfmMainOptions.tvShortCutChange(Sender: TObject;
  Node: TTreeNode);
var
  nd: TTreeNode;
  P: PNodeHotKey;
begin
  nd:=tvShortCut.Selected;
  if nd=nil then exit;
  P:=nd.data;
  case P.TypeHotKey of
    thkNone: begin
      lbShortCut.Enabled:=false;
      htShortCut.Enabled:=false;
      htShortCut.HotKey:=0;
    end;
    thkMenu,thkNewMenu,thkUpper,thkLower,thkRussian,thkEnglish: begin
      lbShortCut.Enabled:=true;
      htShortCut.Enabled:=true;
      htShortCut.HotKey:=P.tmpShortCut;
    end;
  end;
end;

procedure TfmMainOptions.htShortCutKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
var
  nd: TTreeNode;
  P: PNodeHotKey;           
begin
  inherited;
  nd:=tvShortCut.Selected;
  if nd=nil then exit;
  P:=nd.data;
  case P.TypeHotKey of
    thkNone: begin
      P.tmpShortCut:=0;
    end;
    thkMenu,thkNewMenu,thkUpper,thkLower,thkRussian,thkEnglish: begin
      P.tmpShortCut:=htShortCut.HotKey;
    end;
  end;
end;

function TfmMainOptions.AddToTreeViewHotKeys(ndParent: TTreeNode; ndText: String;
                        PData: Pointer; TypeHotKey: TTypeHotKeys;
                        ShCut: TShortCut): TTreeNode;
var
  P: PNodeHotKey;
begin
  new(P);
  P.TypeHotKey:=TypeHotKey;
  P.PData:=PData;
  P.tmpShortCut:=ShCut;
  Result:=tvShortCut.Items.AddChildObject(ndParent,ndText,P);
end;

procedure TfmMainOptions.FillTreeViewHotKeys;

  procedure FillTreeViewFromMain(ndCur: TTreeNode; miParent: TMenuItem);
  var
    i: integer;
    mi: TMenuItem;
    curThk: TTypeHotKeys;
    ndNext: TTreeNode;
    cur: Integer;
    bmp: TBitmap;
  begin
    for i:=0 to miParent.Count-1 do begin
      mi:=miParent.Items[i];
      if mi.Visible then begin
        curThk:=thkMenu;
        if mi is TNewMenuItem then curThk:=thkNewMenu;
        if mi.Count>0 then curThk:=thkNone;
        if mi.Caption<>'-' then begin
         ndNext:=AddToTreeViewHotKeys(ndCur,TranslateMenuCaption(mi.Caption),
                                      Pointer(mi),curThk,mi.ShortCut);
         if not mi.Bitmap.Empty then begin
           cur:=ilShortCut.Add(mi.Bitmap,nil);
           ndNext.ImageIndex:=cur;
           ndNext.SelectedIndex:=cur;
         end else begin
           if (mi.GetImageList<>nil)and(mi.ImageIndex<>-1) then begin
              bmp:=TBitmap.Create;
              try
               mi.GetImageList.GetBitmap(mi.ImageIndex,bmp);
               cur:=ilShortCut.Add(bmp,nil);
               ndNext.ImageIndex:=cur;
               ndNext.SelectedIndex:=cur;
              finally
               bmp.free;
              end;
           end;
         end;
         FillTreeViewFromMain(ndNext,mi);
        end;
      end;
    end;
  end;

  procedure ClearImageList;
  var
    i: Integer;
  begin
    for i:=ilShortCut.Count-1 downto 3 do begin
      ilShortCut.Delete(i);
    end;
  end;
  
var
  ndCur,ndNext: TTreeNode;
  i: Integer;
  mi: TMenuItem;
  curThk: TTypeHotKeys;
begin
  if fmMain=nil then exit;
  tvShortCut.Items.BeginUpdate;
  try
    CleartvShortCut;
    ClearImageList;
    ndCur:=AddToTreeViewHotKeys(nil,'Меню',nil,thkNone,0);
    for i:=0 to fmMain.mm.Items.Count-1 do begin
      mi:=fmMain.mm.Items[i];
      if mi.Visible then begin
        curThk:=thkNone;
        if mi.Caption<>'-' then begin
         ndNext:=AddToTreeViewHotKeys(ndCur,TranslateMenuCaption(mi.Caption),
                                      Pointer(mi),curThk,mi.ShortCut);
         FillTreeViewFromMain(ndNext,mi);
        end; 
      end;  
    end;
    ndCur:=AddToTreeViewHotKeys(nil,'Операции',nil,thkNone,0);
    AddToTreeViewHotKeys(ndCur,'Перевод в верхний регистр',nil,thkUpper,HotKeyUpperCase);
    AddToTreeViewHotKeys(ndCur,'Перевод в нижний регистр',nil,thkLower,HotKeyLowerCase);
    AddToTreeViewHotKeys(ndCur,'Перевод на русский',nil,thkRussian,HotKeyToRussian);
    AddToTreeViewHotKeys(ndCur,'Перевод на английский',nil,thkEnglish,HotKeyToEnglish);

  finally
    SetImageToTreeNodes(tvShortCut);
    OpenFirstLevelOnTreeView(tvShortCut);
    tvShortCut.Items.EndUpdate;
  end;
end;

procedure TfmMainOptions.SetHotKeysFromTreeView;
var
  i: Integer;
  P: PNodeHotKey;
begin
  for i:=0 to tvShortCut.Items.Count-1 do begin
    P:=PNodeHotKey(tvShortCut.Items[i].data);
    case P.TypeHotKey of
      thkNone:;
      thkMenu: begin
        TMenuItem(P.PData).ShortCut:=P.tmpShortCut;
      end;
      thkNewMenu: begin
        TNewMenuItem(P.PData).ShortCut:=P.tmpShortCut;
        TNewMenuItem(P.PData).P.ShortCut:=P.tmpShortCut;
      end;
      thkUpper: HotKeyUpperCase:=P.tmpShortCut;
      thkLower: HotKeyLowerCase:=P.tmpShortCut;
      thkRussian: HotKeyToRussian:=P.tmpShortCut;
      thkEnglish: HotKeyToEnglish:=P.tmpShortCut;
    end;
  end;
end;

procedure TfmMainOptions.FillStringGridConsts;

  procedure FillHeader;
  begin
    sgConsts.Cells[0,0]:='Наименование';
    sgConsts.Cells[1,0]:='Значение';
  end;

  procedure AddToStringGrid(TypeCellConst: TTypeCellConst; Value: Variant;
                            Name,Val,Hint: String; var Index: Integer);
  var
    PInf: PInfoCellConst;
  begin
    New(PInf);
    PInf.TypeCellConst:=TypeCellConst;
    PInf.Value:=Value;
    PInf.Hint:=Hint;
    sgConsts.Cells[0,Index]:=Name;
    sgConsts.Objects[0,Index]:=TObject(PInf);
    sgConsts.Cells[1,Index]:=Val;
    Index:=Index+1;
    sgConsts.RowCount:=sgConsts.RowCount+1;
  end;

  procedure FillGrid;
  var
    P: PConstParams;
    iStart: Integer;
    tmps: string;
  begin
    FillHeader;
    GetMem(P,sizeof(TConstParams));
    try
     ZeroMemory(P,sizeof(TConstParams));
     pnConsts.Enabled:=false;
     if ViewEntryFromMain_(tte_const,P,false,false) then begin
       Const_Id:=P.const_id;
       iStart:=1;
       AddToStringGrid(tccPlant,P.plant_id,
                       'Предприятие',P.plantname,
                       'Предприятие где установлена программа',iStart);
       AddToStringGrid(tccEmpBoss,P.empboss_id,
                       'Директор',P.empbossname,
                       'Генеральный директор предприятия',iStart);
       AddToStringGrid(tccEmpAccount,P.empaccount_id,
                       'Главный бухгалтер',P.empaccountname,
                       'Сотрудник являющийся главным бухгалтером',iStart);
       AddToStringGrid(tccEmpStaffBoss,P.empstaffboss_id,
                       'Начальник отдела кадров',P.empstaffbossname,
                       'Сотрудник являющийся начальником отдела кадров',iStart);
       tmps:=P.plantPFRcode;
       AddToStringGrid(tccPlantPFRcode,tmps,
                       'Код предприятия в ПФР',P.plantPFRcode,
                       'Код предприятия в ПФР',iStart);
       tmps:=P.IMNScode;
       AddToStringGrid(tccIMNScode,tmps,
                       'Номер ИМНС',P.IMNScode,
                       'Номер ИМНС куда платят налоги',iStart);
       AddToStringGrid(tccDefaultCurrency,P.defaultcurrency_id,
                       'Валюта по умолчанию',P.defaultcurrencyname,
                       'Валюта используемая по умолчанию',iStart);
       AddToStringGrid(tccDefaultProperty,P.defaultproperty_id,
                       'Группа по умолчанию',P.defaultpropertyname,
                       'Группа сотрудников по умолчанию',iStart);
       AddToStringGrid(tccLeaveAbsence,P.leaveabsence_id,
                       'Неявка при отпуске',P.leaveabsencename,
                       'Наименование неявки при отпуске',iStart);
       AddToStringGrid(tccRefreshCourseAbsence,P.refreshcourseabsence_id,
                       'Неявка при переподготовке',P.refreshcourseabsencename,
                       'Наименование неявки при переподготовке',iStart);
       AddToStringGrid(tccRoundto,P.roundto,
                       'Округлять до',inttostr(P.roundto),
                       'Количество знаков после запятой',iStart);
       AddToStringGrid(tccEmpPassport,P.emppassport_id,
                       'Паспорт по умолчанию',P.passportname,
                       'Наименование паспорта по умолчанию',iStart);


       sgConsts.RowCount:=sgConsts.RowCount-1;
       pnConsts.Enabled:=true;
       ViewConstHint(1);
     end; 
    finally
     FreeMem(P,sizeof(TConstParams));
    end; 
  end;

begin
  ClearStringGridConsts;
  FillGrid;
  isChangeConsts:=false;
end;

procedure TfmMainOptions.ViewConstHint(Row: Integer);
var
  P: PInfoCellConst;
begin
  P:=PInfoCellConst(sgConsts.Objects[0,Row]);
  if P=nil then exit;
  meConsts.Lines.Text:=P.Hint;
end;

procedure TfmMainOptions.sgConstsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  ViewConstHint(ARow);
end;

procedure TfmMainOptions.sgConstsDblClick(Sender: TObject);
var
  fm: TfmEditConst;
  P: PInfoCellConst; 
begin
 if (sgConsts.Row<1) or (sgConsts.Row>sgConsts.RowCount-1) then exit;
 P:=PInfoCellConst(sgConsts.Objects[0,sgConsts.Row]);
 if P=nil then exit;
 try
  try
   fm:=TfmEditConst.Create(nil);
   fm.SetControlFromInfoCellConst(P,sgConsts.cells[1,sgConsts.Row]);
   fm.ChangeFlag:=false;
   if fm.ShowModal=mrOk then begin
     isChangeConsts:=fm.ChangeFlag;
     sgConsts.cells[1,sgConsts.Row]:=fm.GetInfoCellConstFromControl(P);
   end;
   sgConsts.SetFocus;
   SendMessage(sgConsts.Handle,WM_REDRAW,0,0);
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;  
end;

procedure TfmMainOptions.sgConstsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: sgConstsDblClick(nil);
  end;
end;

procedure TfmMainOptions.SetConstsFromStringGrid;

  function GetValueFromInfoCellConst(TypeCellConst: TTypeCellConst):string;
  var
    i: Integer;
    P: PInfoCellConst;
    vt: Integer;
  begin
    Result:='';
    for i:=1 to sgConsts.RowCount-1 do begin
     P:=PInfoCellConst(sgConsts.Objects[0,i]);
     if P<>nil then begin
       if P.TypeCellConst=TypeCellConst then begin
         vt:=VarType(P.Value);
         case vt of
           varString: Result:=QuotedStr(VarToStr(P.Value));
           varSmallint,varInteger: Result:=inttostr(P.Value);
           else begin
             Result:=VarToStr(P.Value);
           end;
         end;

         exit;
       end;
     end;
    end; 
  end;
  
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   tran.DefaultAction:=TARollback;
   qrnew.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Update '+tbConsts+' set'+
         ' defaultproperty_id='+GetValueFromInfoCellConst(tccDefaultProperty)+
         ', leaveabsence_id='+GetValueFromInfoCellConst(tccLeaveAbsence)+
         ', refreshcourseabsence_id='+GetValueFromInfoCellConst(tccRefreshCourseAbsence)+
         ', empstaffboss_id='+GetValueFromInfoCellConst(tccEmpStaffBoss)+
         ', defaultcurrency_id='+GetValueFromInfoCellConst(tccDefaultCurrency)+
         ', empaccount_id='+GetValueFromInfoCellConst(tccEmpAccount)+
         ', empboss_id='+GetValueFromInfoCellConst(tccEmpBoss)+
         ', plant_id='+GetValueFromInfoCellConst(tccPlant)+
         ', plantPFRcode='+GetValueFromInfoCellConst(tccPlantPFRcode)+
         ', IMNScode='+GetValueFromInfoCellConst(tccIMNScode)+
         ', roundto='+GetValueFromInfoCellConst(tccRoundto)+
         ', emppassport_id='+GetValueFromInfoCellConst(tccEmpPassport)+
         ' where const_id='+IntToStr(Const_id);
   qrnew.SQL.Add(sqls);
   qrnew.ExecSQL;
   tran.Commit;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
