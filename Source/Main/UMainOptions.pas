unit UMainOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, stdctrls, Buttons, IBServices, CheckLst, UMainData,
  menus, ImgList, Grids, IBQuery, IBDatabase, filectrl, tsvColorBox, Tabs,
  UMainUnited;

type
  TfmMainOptions = class(TForm)
    pc: TPageControl;
    tsGeneral: TTabSheet;
    tsDataBase: TTabSheet;
    pnGeneral: TPanel;
    pnDataBase: TPanel;
    tsShortCut: TTabSheet;
    grbBaseDir: TGroupBox;
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
    tsRBooks: TTabSheet;
    pnRBooks: TPanel;
    chbEditRBOnSelect: TCheckBox;
    fd: TFontDialog;
    cd: TColorDialog;
    tsDirs: TTabSheet;
    pnDirs: TPanel;
    Panel1: TPanel;
    edBaseDir: TEdit;
    GroupBox1: TGroupBox;
    Panel5: TPanel;
    edDirsTemp: TEdit;
    btClearParams: TButton;
    tsLog: TTabSheet;
    pnLog: TPanel;
    chbLogStayOnTop: TCheckBox;
    ilLog: TImageList;
    grbLog: TGroupBox;
    pngrbLog: TPanel;
    lvLog: TListView;
    chbLogViewDateTime: TCheckBox;
    tsSqlMonitor: TTabSheet;
    pnSQLMonitor: TPanel;
    chbSQLMonitorEnabled: TCheckBox;
    grbSqlMonitor: TGroupBox;
    chbSQLPrepear: TCheckBox;
    chbSqlExecute: TCheckBox;
    chbSQLFetch: TCheckBox;
    chbSQLError: TCheckBox;
    chbSQLStmt: TCheckBox;
    chbSQLConnect: TCheckBox;
    chbSQLTransact: TCheckBox;
    chbSQLBlob: TCheckBox;
    chbService: TCheckBox;
    chbSQLMisc: TCheckBox;
    lbSqlMonitorLimit: TLabel;
    edSqlMonitorLimit: TEdit;
    udSqlMonitorLimit: TUpDown;
    tsInterfaces: TTabSheet;
    pnInterfaces: TPanel;
    splInterfaces: TSplitter;
    tsVisual: TTabSheet;
    pnVisual: TPanel;
    grbVisualTable: TGroupBox;
    lbRBooksTableFont: TLabel;
    lbRBooksTableColorRecord: TLabel;
    lbRBooksTableColorCursor: TLabel;
    edRBooksTableFont: TEdit;
    bibRBooksTableFont: TButton;
    cmbRBooksTableRecordColor: TComboBox;
    cmbRBooksTableColorCursor: TComboBox;
    chbRBooksVisibleRowNumber: TCheckBox;
    grbVisualForms: TGroupBox;
    lbVisualForms: TLabel;
    edVisualForms: TEdit;
    bibVisualForms: TButton;
    chbViewFindPanel: TCheckBox;
    chbViewEditPanel: TCheckBox;
    lbLogLimit: TLabel;
    edLogLimit: TEdit;
    udLogLimit: TUpDown;
    btSaveParamsToFile: TButton;
    tcInterfaces: TTabControl;
    pcInterface: TPageControl;
    tsInterfaceHint: TTabSheet;
    pnGrbInterfaceHint: TPanel;
    meInterfaceHint: TMemo;
    pnBackInterfaces: TPanel;
    lbInterfaces: TListBox;
    tsInterfacePerm: TTabSheet;
    pnInterfacePerm: TPanel;
    lbInterfacePerm: TListBox;
    bvInterfacePerm: TBevel;
    lvInterfacePerm: TListView;
    pmInterface: TPopupMenu;
    miViewInterface: TMenuItem;
    miRefreshInterface: TMenuItem;
    miCloseInterface: TMenuItem;
    chbMaximizeMainWindow: TCheckBox;
    ilInterface: TImageList;
    chbClearTempDir: TCheckBox;
    lbColorElementFocus: TLabel;
    cmbColorElementFocus: TComboBox;
    lbFilterColor: TLabel;
    cmbFilterColor: TComboBox;
    btLoadParamsFromFile: TButton;
    od: TOpenDialog;
    sd: TSaveDialog;
    chbTypeFilter: TCheckBox;
    GroupBox2: TGroupBox;
    Panel3: TPanel;
    EditLogFile: TEdit;
    ButtonLogFile: TButton;
    bibDirsTemp: TButton;
    bibBaseDir: TButton;
    GroupBoxSplash: TGroupBox;
    CheckBoxVisibleSplash: TCheckBox;
    CheckBoxVisbleSplashVersion: TCheckBox;
    CheckBoxVisibleSplashStatus: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bibBaseDirClick(Sender: TObject);
    procedure clbLibraryClick(Sender: TObject);
    procedure clbLibraryClickCheck(Sender: TObject);
    procedure tvShortCutAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure tvShortCutChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure bibRBooksTableFontClick(Sender: TObject);
    procedure bibRBooksTableColorRecordClick(Sender: TObject);
    procedure bibRBooksTableColorCursorClick(Sender: TObject);
    procedure bibDirsTempClick(Sender: TObject);
    procedure btClearParamsClick(Sender: TObject);
    procedure chbSQLMonitorEnabledClick(Sender: TObject);
    procedure lbInterfacesClick(Sender: TObject);
    procedure bibVisualFormsClick(Sender: TObject);
    procedure btSaveParamsToFileClick(Sender: TObject);
    procedure tcInterfacesChange(Sender: TObject);
    procedure lbInterfacePermClick(Sender: TObject);
    procedure pmInterfacePopup(Sender: TObject);
    procedure miViewInterfaceClick(Sender: TObject);
    procedure miRefreshInterfaceClick(Sender: TObject);
    procedure miCloseInterfaceClick(Sender: TObject);
    procedure btLoadParamsFromFileClick(Sender: TObject);
    procedure ButtonLogFileClick(Sender: TObject);
  private
    function GetTypeInterfaceByTabSet: TTypeInterface;
    procedure htShortCutKeyUp(Sender: TObject; var Key: Word;
                                Shift: TShiftState);
    function AddToTreeViewHotKeys(ndParent: TTreeNode; ndText: String;
                                  PData: Pointer; TypeHotKey: TTypeHotKeys;
                                  ShCut: TShortCut):TTreeNode;
    procedure CleartvShortCut;
    procedure ClearlbInterfaces;

  public
    tmpColor: TTSVColorBox;
    isChangeLibrary: Boolean;
    isChangeConsts: Boolean;
    NewDataBaseName: string;
    procedure FillCheckListBoxLibrary;
    procedure SetLibraryFromCheckListBox;
    procedure FillTreeViewHotKeys;
    procedure SetHotKeysFromTreeView;
    procedure FillInterfaces;
    procedure FillInterfacePermissions;
    procedure LoadFromIni(OptionHandle: THandle);
    procedure SaveToIni(OptionHandle: THandle);
  end;

  TNewHotKey=class(THotKey)
  public
   property OnKeyUp;
  end;

var
  fmMainOptions: TfmMainOptions;

implementation


uses UMainCode, UServerConnect, UMain,
     tsvPathUtils, ULoginDb;

{$R *.DFM}


procedure TfmMainOptions.FormCreate(Sender: TObject);
var
  tmpCB: TTSVColorBox;
begin

  Left:=ConstOptionLeft;
  Top:=ConstOptionTop;
  ClientWidth:=ConstOptionWidth;
  ClientHeight:=ConstOptionHeight;
  Constraints.MinWidth:=ConstOptionMinWidth;
  Constraints.MinHeight:=ConstOptionMinHeight;

  isChangeLibrary:=false;
  tvShortCut.FullExpand;
  lbShortCut.Enabled:=false;
  htShortCut.Enabled:=false;
  TNewHotKey(htShortCut).OnKeyUp:=htShortCutKeyUp;

  isChangeConsts:=false;

  edRBooksTableFont.Text:=edRBooksTableFont.Font.Name;

  tmpCB:=TTSVColorBox.Create(nil);
  tmpCB.Parent:=cmbRBooksTableRecordColor.Parent;
  tmpCB.TabOrder:=cmbRBooksTableRecordColor.TabOrder;
  tmpCB.OnChange:=cmbRBooksTableRecordColor.OnChange;
  tmpCB.Style:=[cbStandardColors,cbExtendedColors,cbSystemColors,
                 cbIncludeNone,cbIncludeDefault,cbCustomColor,cbPrettyNames];
  tmpCB.SetBounds(cmbRBooksTableRecordColor.Left,cmbRBooksTableRecordColor.Top,
                   cmbRBooksTableRecordColor.Width,cmbRBooksTableRecordColor.Height);
  cmbRBooksTableRecordColor.Free;
  tmpCB.Name:='cmbRBooksTableRecordColor';
  cmbRBooksTableRecordColor:=TComboBox(tmpCB);

  tmpCB:=TTSVColorBox.Create(nil);
  tmpCB.Parent:=cmbRBooksTableColorCursor.Parent;
  tmpCB.TabOrder:=cmbRBooksTableColorCursor.TabOrder;
  tmpCB.OnChange:=cmbRBooksTableColorCursor.OnChange;
  tmpCB.Style:=[cbStandardColors,cbExtendedColors,cbSystemColors,
                 cbIncludeNone,cbIncludeDefault,cbCustomColor,cbPrettyNames];
  tmpCB.SetBounds(cmbRBooksTableColorCursor.Left,cmbRBooksTableColorCursor.Top,
                   cmbRBooksTableColorCursor.Width,cmbRBooksTableColorCursor.Height);
  cmbRBooksTableColorCursor.Free;
  tmpCB.Name:='cmbRBooksTableColorCursor';
  cmbRBooksTableColorCursor:=TComboBox(tmpCB);

  tmpCB:=TTSVColorBox.Create(nil);
  tmpCB.Parent:=cmbColorElementFocus.Parent;
  tmpCB.TabOrder:=cmbColorElementFocus.TabOrder;
  tmpCB.OnChange:=cmbColorElementFocus.OnChange;
  tmpCB.Style:=[cbStandardColors,cbExtendedColors,cbSystemColors,
                 cbIncludeNone,cbIncludeDefault,cbCustomColor,cbPrettyNames];
  tmpCB.SetBounds(cmbColorElementFocus.Left,cmbColorElementFocus.Top,
                   cmbColorElementFocus.Width,cmbColorElementFocus.Height);
  cmbColorElementFocus.Free;
  tmpCB.Name:='cmbColorElementFocus';
  cmbColorElementFocus:=TComboBox(tmpCB);

  tmpCB:=TTSVColorBox.Create(nil);
  tmpCB.Parent:=cmbFilterColor.Parent;
  tmpCB.TabOrder:=cmbFilterColor.TabOrder;
  tmpCB.OnChange:=cmbFilterColor.OnChange;
  tmpCB.Style:=[cbStandardColors,cbExtendedColors,cbSystemColors,
                 cbIncludeNone,cbIncludeDefault,cbCustomColor,cbPrettyNames];
  tmpCB.SetBounds(cmbFilterColor.Left,cmbFilterColor.Top,
                   cmbFilterColor.Width,cmbFilterColor.Height);
  cmbFilterColor.Free;
  tmpCB.Name:='cmbFilterColor';
  cmbFilterColor:=TComboBox(tmpCB);
  
  tmpColor:=TTSVColorBox.Create(nil);

  pcInterface.ActivePageIndex:=0;

  LoadFromIni(OPTION_INVALID_HANDLE);
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

procedure TfmMainOptions.FormDestroy(Sender: TObject);
begin
  CleartvShortCut;
  cmbRBooksTableColorCursor.Free;
  cmbRBooksTableRecordColor.Free;
  cmbColorElementFocus.Free;
  cmbFilterColor.Free;
  tmpColor.Free;
  ClearlbInterfaces;
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
  val: Integer;
  PList: PInfoLib;
begin
  Screen.Cursor:=crHourGlass;
  clbLibrary.Items.BeginUpdate;
  try
   clbLibrary.Clear;
   meLibrary.Lines.Clear;
   for i:=0 to ListLibs.Count-1 do begin
     PList:=PInfoLib(ListLibs.Items[i]);
     if PList.TypeLib<>ttleSecurity then begin
       val:=clbLibrary.Items.AddObject(PList.ExeName,TObject(PList));
       clbLibrary.Checked[val]:=PList.Active;
       clbLibrary.ItemEnabled[val]:=not PList.StopLoad;
     end;
   end;
   if clbLibrary.Items.Count>0 then
     clbLibrary.ItemIndex:=0;
   clbLibraryClick(nil);
   isChangeLibrary:=false;
  finally
   clbLibrary.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmMainOptions.clbLibraryClick(Sender: TObject);
var
  P: PInfoLib;
  str: TStringList;
  i: Integer;
begin
  if clbLibrary.ItemIndex<>-1 then begin
   P:=Pointer(clbLibrary.items.Objects[clbLibrary.ItemIndex]);
   if isValidPointer(P) then begin
     str:=TStringList.Create;
     try
       meLibrary.Lines.Clear;
       if Trim(P.Hint)<>'' then begin
         str.Text:=P.Hint;
         meLibrary.Lines.Add(Format('Описание: %s',[Trim(str.Text)]));
         meLibrary.Lines.Add('');
       end;
       if Trim(P.Condition)<>'' then begin
         str.Text:=Trim(P.Condition);
         meLibrary.Lines.Add('Условия:');
         for i:=0 to str.Count-1 do begin
           meLibrary.Lines.Add(Format('%d. %s',[i+1,str.Strings[i]]));
         end;  
         meLibrary.Lines.Add('');
       end;
       if Trim(P.Programmers)<>'' then begin
         str.Text:=Trim(P.Programmers);
         meLibrary.Lines.Add(Format('Разработчики: %s',[Trim(str.Text)]));
       end;
       meLibrary.SelStart:=0;
       meLibrary.SelText:='';  
     finally
       str.Free;
     end;  
   end;
  end;
end;

procedure TfmMainOptions.SetLibraryFromCheckListBox;
var
  i: integer;
  P: PInfoLib;
begin
  for i:=0 to clbLibrary.Items.Count-1 do begin
    P:=Pointer(clbLibrary.items.Objects[i]);
    SaveLibraryActive(P.ExeName,clbLibrary.Checked[i]);
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
{var
  rt: Trect;}
begin
{  if GetFocus<>tvShortCut.Handle then begin
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
  end else DefaultDraw:=true;   }
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
  if not isValidPointer(P) then exit;
  case P.TypeHotKey of
    thkNone: begin
      lbShortCut.Enabled:=false;
      htShortCut.Enabled:=false;
      htShortCut.HotKey:=0;
    end;
    thkMenu,thkNewMenu,thkTbMenu,
    thkUpper,thkLower,thkRussian,thkEnglish,thkFirstUpper,thkTrimSpaceForOne: begin
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
    thkMenu,thkNewMenu,thkTbMenu,
    thkUpper,thkLower,thkRussian,thkEnglish,thkFirstUpper,thkTrimSpaceForOne: begin
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
    AndMask: TBitmap;
  begin
    for i:=0 to miParent.Count-1 do begin
      mi:=miParent.Items[i];
      if mi.Visible then begin
        curThk:=thkMenu;
        if mi is TNewMenuItem then curThk:=thkNewMenu;
        if mi is TTBMenuItem then curThk:=thkTbMenu;
        if mi.Count>0 then curThk:=thkNone;
        if mi.Caption<>'-' then begin
         ndNext:=AddToTreeViewHotKeys(ndCur,TranslateMenuCaption(mi.Caption),
                                      Pointer(mi),curThk,mi.ShortCut);
         if not mi.Bitmap.Empty then begin
           AndMask:=TBitmap.Create;
           try
            CopyBitmap(mi.Bitmap,AndMask);
            AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
            cur:=ilShortCut.Add(mi.Bitmap,AndMask);
            ndNext.ImageIndex:=cur;
            ndNext.SelectedIndex:=cur;
           finally
            AndMask.Free;
           end; 
         end else begin
           if (mi.GetImageList<>nil)and(mi.ImageIndex<>-1) then begin
              bmp:=TBitmap.Create;
              AndMask:=TBitmap.Create;
              try
               mi.GetImageList.GetBitmap(mi.ImageIndex,bmp);
               CopyBitmap(bmp,AndMask);
               AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
               cur:=ilShortCut.Add(bmp,AndMask);
               ndNext.ImageIndex:=cur;
               ndNext.SelectedIndex:=cur;
              finally
               AndMask.Free;
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
    AddToTreeViewHotKeys(ndCur,'Перевод первой буквы каждого слова в верхний регистр',nil,thkFirstUpper,HotKeyFirstUpperCase);
    AddToTreeViewHotKeys(ndCur,'Сокращение нескольких пробелов до одного',nil,thkTrimSpaceForOne,HotKeyTrimSpaceForOne);

  finally
    SetImageToTreeNodes(tvShortCut);
    OpenFirstLevelOnTreeView(tvShortCut);
    tvShortCut.Items.EndUpdate;
    lbShortCut.Enabled:=false;
    htShortCut.HotKey:=0;
    htShortCut.Enabled:=false;
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
        if IsValidPointer(P.PData) then
          TMenuItem(P.PData).ShortCut:=P.tmpShortCut;
      end;
      thkNewMenu: begin
        if IsValidPointer(P.PData) then begin
         TNewMenuItem(P.PData).ShortCut:=P.tmpShortCut;
         if IsValidPointer(TNewMenuItem(P.PData).P) then
          TNewMenuItem(P.PData).P.ShortCut:=P.tmpShortCut;
        end; 
      end;
      thkTbMenu: begin
        if IsValidPointer(P.PData) then begin
         TTBMenuItem(P.PData).ShortCut:=P.tmpShortCut;
         if IsValidPointer(TTBMenuItem(P.PData).tb) then
          if IsValidPointer(TTBMenuItem(P.PData).tb.P) then
           TTBMenuItem(P.PData).tb.P.ShortCut:=P.tmpShortCut;
        end; 
      end;
      thkUpper: HotKeyUpperCase:=P.tmpShortCut;
      thkLower: HotKeyLowerCase:=P.tmpShortCut;
      thkRussian: HotKeyToRussian:=P.tmpShortCut;
      thkEnglish: HotKeyToEnglish:=P.tmpShortCut;
      thkFirstUpper: HotKeyFirstUpperCase:=P.tmpShortCut;
      thkTrimSpaceForOne: HotKeyTrimSpaceForOne:=P.tmpShortCut;
    end;
  end;
end;

procedure TfmMainOptions.bibRBooksTableFontClick(Sender: TObject);
begin
   fd.Font.Assign(edRBooksTableFont.Font);
   fd.Options:=fd.Options;
   if not fd.Execute then exit;
   edRBooksTableFont.Font.Assign(fd.Font);
   edRBooksTableFont.Text:=edRBooksTableFont.Font.Name;
end;

procedure TfmMainOptions.bibRBooksTableColorRecordClick(Sender: TObject);
begin
{   cd.Color:=pnRBooksTableColorRecord.Color;
   if not cd.Execute then exit;
   pnRBooksTableColorRecord.Color:=cd.Color;}
end;

procedure TfmMainOptions.bibRBooksTableColorCursorClick(Sender: TObject);
begin
{   cd.Color:=pnRBooksTableColorCursor.Color;
   if not cd.Execute then exit;
   pnRBooksTableColorCursor.Color:=cd.Color;}
end;

procedure TfmMainOptions.bibDirsTempClick(Sender: TObject);
begin
  edDirsTemp.Text:=SelectDirectoryEx(Application.Handle,edDirsTemp.Text,ConstSelectDir,
                                     [tbReturnOnlyFSDirs]);
end;

procedure TfmMainOptions.btClearParamsClick(Sender: TObject);
begin
  ClearParams_;
  SaveParams_;
end;

procedure TfmMainOptions.LoadFromIni(OptionHandle: THandle);
begin
  if (OptionHandle=hOptionSqlMonitor)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    chbSQLMonitorEnabled.Checked:=ReadParam(ConstSectionOptions,chbSQLMonitorEnabled.Name,chbSQLMonitorEnabled.Checked);
    chbSQLPrepear.Checked:=ReadParam(ConstSectionOptions,chbSQLPrepear.Name,chbSQLPrepear.Checked);
    chbSqlExecute.Checked:=ReadParam(ConstSectionOptions,chbSqlExecute.Name,chbSqlExecute.Checked);
    chbSQLFetch.Checked:=ReadParam(ConstSectionOptions,chbSQLFetch.Name,chbSQLFetch.Checked);
    chbSQLError.Checked:=ReadParam(ConstSectionOptions,chbSQLError.Name,chbSQLError.Checked);
    chbSQLStmt.Checked:=ReadParam(ConstSectionOptions,chbSQLStmt.Name,chbSQLStmt.Checked);
    chbSQLConnect.Checked:=ReadParam(ConstSectionOptions,chbSQLConnect.Name,chbSQLConnect.Checked);
    chbSQLTransact.Checked:=ReadParam(ConstSectionOptions,chbSQLTransact.Name,chbSQLTransact.Checked);
    chbSQLBlob.Checked:=ReadParam(ConstSectionOptions,chbSQLBlob.Name,chbSQLBlob.Checked);
    chbService.Checked:=ReadParam(ConstSectionOptions,chbService.Name,chbService.Checked);
    chbSQLMisc.Checked:=ReadParam(ConstSectionOptions,chbSQLMisc.Name,chbSQLMisc.Checked);
    udSqlMonitorLimit.Position:=ReadParam(ConstSectionOptions,udSqlMonitorLimit.Name,udSqlMonitorLimit.Position);
  end;
  if (OptionHandle=hOptionDirs)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    chbClearTempDir.Checked:=ReadParam(ConstSectionOptions,chbClearTempDir.Name,chbClearTempDir.Checked);
  end;
end;

procedure TfmMainOptions.SaveToIni(OptionHandle: THandle);
begin
  if (OptionHandle=hOptionSqlMonitor)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,chbSQLMonitorEnabled.Name,chbSQLMonitorEnabled.Checked);
    WriteParam(ConstSectionOptions,chbSQLPrepear.Name,chbSQLPrepear.Checked);
    WriteParam(ConstSectionOptions,chbSqlExecute.Name,chbSqlExecute.Checked);
    WriteParam(ConstSectionOptions,chbSQLFetch.Name,chbSQLFetch.Checked);
    WriteParam(ConstSectionOptions,chbSQLError.Name,chbSQLError.Checked);
    WriteParam(ConstSectionOptions,chbSQLStmt.Name,chbSQLStmt.Checked);
    WriteParam(ConstSectionOptions,chbSQLConnect.Name,chbSQLConnect.Checked);
    WriteParam(ConstSectionOptions,chbSQLTransact.Name,chbSQLTransact.Checked);
    WriteParam(ConstSectionOptions,chbSQLBlob.Name,chbSQLBlob.Checked);
    WriteParam(ConstSectionOptions,chbService.Name,chbService.Checked);
    WriteParam(ConstSectionOptions,chbSQLMisc.Name,chbSQLMisc.Checked);
    WriteParam(ConstSectionOptions,udSqlMonitorLimit.Name,udSqlMonitorLimit.Position);
  end;
  if (OptionHandle=hOptionDirs)or(OptionHandle=OPTION_INVALID_HANDLE) then begin
    WriteParam(ConstSectionOptions,chbClearTempDir.Name,chbClearTempDir.Checked);
  end;
end;

procedure TfmMainOptions.chbSQLMonitorEnabledClick(Sender: TObject);
begin
  chbSQLPrepear.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSqlExecute.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLFetch.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLError.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLStmt.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLConnect.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLTransact.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLBlob.Enabled:=chbSQLMonitorEnabled.Checked;
  chbService.Enabled:=chbSQLMonitorEnabled.Checked;
  chbSQLMisc.Enabled:=chbSQLMonitorEnabled.Checked;
end;

var
  TempTypeInterface: TTypeInterface;
   
procedure MainOptionsGetInterfaceProc(Owner: Pointer; PGI: PGetInterface); stdcall;
var
  PNew: PGetInterface;
  isAdd: Boolean;
begin
  if not isValidPointer(PGI) then exit;
  isAdd:=false;
  if TempTypeInterface in [ttiNone..ttiHelp] then begin
    if TempTypeInterface=PGI.TypeInterface then isAdd:=true;
  end else isAdd:=true;

  if isAdd then begin
   New(PNew);
   FillChar(PNew^,SizeOf(TGetInterface),0);
   PNew.Name:=PGI.Name;
   PNew.Hint:=PGI.Hint;
   PNew.TypeInterface:=PGI.TypeInterface;
   PNew.hInterface:=PGI.hInterface;
   TfmMainOptions(Owner).lbInterfaces.Items.AddObject(PNew.Name,TObject(PNew));
  end;
end;

function TfmMainOptions.GetTypeInterfaceByTabSet: TTypeInterface;
begin
  Result:=ttiNone;
  if tcInterfaces.TabIndex=0 then Result:=ttiRBook;
  if tcInterfaces.TabIndex=1 then Result:=ttiReport;
  if tcInterfaces.TabIndex=2 then Result:=ttiDocument;
  if tcInterfaces.TabIndex=3 then Result:=ttiJournal;
  if tcInterfaces.TabIndex=4 then Result:=ttiWizard;
  if tcInterfaces.TabIndex=5 then Result:=ttiService;
  if tcInterfaces.TabIndex=6 then Result:=ttiHelp;
  if tcInterfaces.TabIndex=7 then Result:=ttiNone;
  if tcInterfaces.TabIndex=8 then Result:=TTypeInterface(-1);
end;

procedure TfmMainOptions.ClearlbInterfaces;
var
  i: Integer;
  P: PGetInterface;
begin
  for i:=0 to lbInterfaces.Items.Count-1 do begin
    P:=PGetInterface(lbInterfaces.Items.Objects[i]);
    Dispose(P);
  end;
  lbInterfaces.Items.Clear;
end;

procedure TfmMainOptions.FillInterfaces;
begin
 lbInterfaces.Items.BeginUpdate;
 try
  ClearlbInterfaces;
  meInterfaceHint.Lines.Text:='';
  TempTypeInterface:=GetTypeInterfaceByTabSet;
  GetInterfaces_(Self,MainOptionsGetInterfaceProc);
  if lbInterfaces.Items.Count>0 then begin
    lbInterfaces.ItemIndex:=0;
  end else lbInterfacePerm.ItemIndex:=-1;

  lbInterfacesClick(nil);
 finally
  lbInterfaces.Items.EndUpdate;
 end;
end;

procedure TfmMainOptions.lbInterfacesClick(Sender: TObject);
var
  P: PGetInterface;
begin
  meInterfaceHint.Lines.Text:='';
  lvInterfacePerm.Items.Clear;
  if lbInterfaces.ItemIndex<>-1 then begin
   P:=Pointer(lbInterfaces.items.Objects[lbInterfaces.ItemIndex]);
   if isValidPointer(P) then meInterfaceHint.Lines.Text:=P.Hint;
   FillInterfacePermissions;
  end;
end;

procedure TfmMainOptions.bibVisualFormsClick(Sender: TObject);
begin
   fd.Font.Assign(edVisualForms.Font);
   if not fd.Execute then exit;
   edVisualForms.Font.Assign(fd.Font);
   edVisualForms.Text:=edVisualForms.Font.Name;
end;

procedure TfmMainOptions.tcInterfacesChange(Sender: TObject);
begin
  FillInterfaces;
end;

procedure TfmMainOptions.lbInterfacePermClick(Sender: TObject);
begin
  FillInterfacePermissions;
end;

procedure MainOptionsGetInterfacePermissionProc(Owner: Pointer; PGIP: PGetInterfacePermission); stdcall;

  function TranslateDBPermissionLocal(DBPerm: TTypeDbPermission): string;
  begin
    Result:='';
    case DBPerm of
       ttpSelect: Result:=ConstSelect;
       ttpInsert: Result:=ConstInsert;
       ttpUpdate: Result:=ConstUpdate;
       ttpDelete: Result:=ConstDelete;
       ttpExecute: Result:=ConstExecute;
    end;
  end;
  
var
  li: TListItem;
begin
  if not isValidPointer(Owner) then exit;
  if not isValidPointer(PGIP) then exit;
  if Integer(PGIP.Action)=TfmMainOptions(Owner).lbInterfacePerm.ItemIndex then begin
    li:=TfmMainOptions(Owner).lvInterfacePerm.Items.Add;
    li.Caption:=AnsiUpperCase(PGIP.DbObject);
    li.SubItems.Add(TranslateDBPermissionLocal(PGIP.DbPerm));
  end;
end;

procedure TfmMainOptions.FillInterfacePermissions;
var
  P: PGetInterface;
begin
  if lbInterfaces.ItemIndex=-1 then exit;
  P:=PGetInterface(lbInterfaces.Items.Objects[lbInterfaces.ItemIndex]);
  lvInterfacePerm.Items.Clear;
  _GetInterfacePermissions(self,P.hInterface,MainOptionsGetInterfacePermissionProc);
end;

procedure TfmMainOptions.pmInterfacePopup(Sender: TObject);
begin
  miViewInterface.Enabled:=false;
  miRefreshInterface.Enabled:=false;
  miCloseInterface.Enabled:=false;
  if lbInterfaces.Items.Count>0 then begin
    miViewInterface.Enabled:=true;
    miRefreshInterface.Enabled:=true;
    miCloseInterface.Enabled:=true;
  end;
end;

procedure TfmMainOptions.miViewInterfaceClick(Sender: TObject);
var
  P: PGetInterface;
begin
  if lbInterfaces.ItemIndex<>-1 then begin
   P:=Pointer(lbInterfaces.items.Objects[lbInterfaces.ItemIndex]);
   if isValidPointer(P) then begin
     if _isPermissionOnInterface(P.hInterface,ttiaView) then
       ViewInterfaceWithDefaultParam(P.hInterface);
   end;  
  end;
end;

procedure TfmMainOptions.miRefreshInterfaceClick(Sender: TObject);
var
  P: PGetInterface;
begin
  if lbInterfaces.ItemIndex<>-1 then begin
   P:=Pointer(lbInterfaces.items.Objects[lbInterfaces.ItemIndex]);
   if isValidPointer(P) then begin
     RefreshInterfaceWithDefaultParam(P.hInterface);
   end;  
  end;
end;

procedure TfmMainOptions.miCloseInterfaceClick(Sender: TObject);
var
  P: PGetInterface;
begin
  if lbInterfaces.ItemIndex<>-1 then begin
   P:=Pointer(lbInterfaces.items.Objects[lbInterfaces.ItemIndex]);
   if isValidPointer(P) then begin
     CloseInterfaceWithDefaultParam(P.hInterface);
   end;  
  end;
end;

procedure TfmMainOptions.btLoadParamsFromFileClick(Sender: TObject);
var
  TLPFF: TLoadParamsFromFile;
begin
  od.DefaultExt:=dfePrm;
  od.Filter:=fltParams;
  if not od.Execute then exit;
  Screen.Cursor:=crHourGlass;
  try
    FillChar(TLPFF,SizeOf(TLPFF),0);
    TLPFF.FileName:=PChar(od.FileName);
    if LoadParamsFromFile_(@TLPFF) then begin
      BeforeSetOptions_;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmMainOptions.btSaveParamsToFileClick(Sender: TObject);
var
  TSPTF: TSaveParamsToFile;
begin
  sd.DefaultExt:=dfePrm;
  sd.Filter:=fltParams;
  sd.FileName:=UserName;
  if not sd.Execute then exit;
  Screen.Cursor:=crHourGlass;
  try
    FillChar(TSPTF,SizeOf(TSPTF),0);
    TSPTF.FileName:=PChar(sd.FileName);
    SaveParamsToFile_(@TSPTF);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmMainOptions.ButtonLogFileClick(Sender: TObject);
var
  S: String;
begin
  S:=ExpandFileName(EditLogFile.Text);
  od.DefaultExt:=dfeLog;
  od.Filter:=fltLog;
  od.FileName:=S;
  if not od.Execute then exit;
  EditLogFile.Text:=od.FileName;
end;

end.
