unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, inifiles, tsvDbGrid, Db, dbgrids,
  DBClient, DBCtrls, Gauges, VirtualTrees, VirtualDBTree, grids, DBTables;

type
  TfmMain = class(TForm)
    pnBottom: TPanel;
    btClose: TButton;
    pcMain: TPageControl;
    tsInput: TTabSheet;
    tsExport: TTabSheet;
    pnInputTop: TPanel;
    pnFind: TPanel;
    lbFind: TLabel;
    edFind: TEdit;
    pnFilter: TPanel;
    lbFilter: TLabel;
    edFilter: TEdit;
    pnInputGrid: TPanel;
    ds: TDataSource;
    cdsAncement: TClientDataSet;
    DBNav: TDBNavigator;
    cdsAncementtreeheading_id: TIntegerField;
    cdsAncementtreeheadingname: TStringField;
    cdsAncementtextannouncement: TStringField;
    cdsAncementreleasenum: TStringField;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox2: TGroupBox;
    lbBeforeTree: TLabel;
    lbAfterTree: TLabel;
    lbPointerTree: TLabel;
    edBeforeTree: TEdit;
    edAfterTree: TEdit;
    edPointerTree: TEdit;
    edExportReleaseNum: TEdit;
    btExport: TButton;
    sd: TSaveDialog;
    gag: TGauge;
    pnText: TPanel;
    Panel2: TPanel;
    dbMemoText: TDBMemo;
    grbText: TGroupBox;
    lbRecordCount: TLabel;
    Label1: TLabel;
    edOOO: TEdit;
    procedure btCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cdsAncementCalcFields(DataSet: TDataSet);
    procedure edFilterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFindKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pcMainChange(Sender: TObject);
    procedure btExportClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure dbMemoTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsAncementAfterInsert(DataSet: TDataSet);
    procedure cdsAncementAfterDelete(DataSet: TDataSet);
    procedure cdsAncementAfterOpen(DataSet: TDataSet);
    procedure cdsAncementBeforeDelete(DataSet: TDataSet);
    procedure cdsAncementAfterPost(DataSet: TDataSet);
    procedure edOOOKeyPress(Sender: TObject; var Key: Char);
  private
    Grid: TNewdbGrid;
    function GetIniFileName: string;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure GridOnEditButtonClick(Sender: TObject);
    function GetTreeHeadingName(treeheading_id: Integer): string;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
    procedure ExportAnnouncementToFile(FileName: string);
    procedure GridOnExit(Sender: TObject);
    function GetDefaultStrColumns: string;
    procedure SetDefaultStrColumns(Value: string);
    function StrToHexStr(S:String):String;
    function HexStrToStr(S:String):String;
    procedure GridTitleClick(Column: TColumn);
    procedure GridOnKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
  public
    function InitData: Boolean;
  end;

var
  fmMain: TfmMain;

const
  ConstCheckDataFail='Файлы данных не найдены.';
  ConstInitDataFail='База данных инициализирована неверно.';
  ConstFileTreeHeading='treeheading.xml';
  ConstFileAnnouncement='ancement.xml';
  fmtRecordCount='Всего: %d';
  fmtSaveFileName=' %d';
  fmtDateTimeSave='dd.mm.yyyy hh-nn-ss';
  fmtRegisterMidas='%s "%s" /s';
  ConstFileRegSvr32='regsvr32.exe';
  ConstFileMidas='midas.dll';


function ShowErrorEx(Mess: String): Integer;
function ShowWarningEx(Mess: String): Integer;
function ShowInfoEx(Mess: String): Integer;
function ShowQuestionEx(Mess: String): Integer;
function ShowErrorQuestionEx(Mess: String): Integer;
function DeleteWarningEx(Mess: String): Integer;
function GetWinSysDir: string;

  
function GetDataDir: string;
function CheckData: Boolean;

implementation

uses UTreeHeading, tsvRTFStream;

{$R *.dfm}

function GetWinSysDir: string;
var
  wsd: PChar;
  WinSysDir:String;
begin
  Result:='';
  GetMem(wsd,256);
  GetSystemDirectory(wsd,256);
  WinSysDir:=StrPas(wsd)+'\';
  FreeMem(wsd,256);
  result:=WinSysDir;
end;

function ShowErrorEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONERROR);
  Result:=MessageDlg(Mess,mtError,[mbOk],0);
end;

function ShowWarningEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONWARNING);
  Result:=MessageDlg(Mess,mtWarning,[mbOk],0);
end;

function ShowInfoEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONINFORMATION);
  Result:=MessageDlg(Mess,mtInformation,[mbOk],0);
end;

function ShowQuestionEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONQUESTION);
  Result:=MessageDlg(Mess,mtConfirmation,[mbYes,mbNo],0);
end;

function ShowErrorQuestionEx(Mess: String): Integer;
begin
  MessageBeep(MB_ICONQUESTION);
  Result:=MessageDlg(Mess,mtError,[mbYes,mbNo],0);
end;

function DeleteWarningEx(Mess: String): Integer;
begin
  Result:=ShowQuestionEx('Удалить'+' '+Mess);
end;

function CheckData: Boolean;
var
  dir: String;
begin
  Result:=false;
  dir:=GetDataDir;
  if not FileExists(Dir+ConstFileTreeHeading) then exit;
  if not FileExists(Dir+ConstFileAnnouncement) then exit;
  Result:=true;
end;

function TfmMain.GetIniFileName;
begin
  Result:=Application.ExeName;
  Result:=Copy(Result,1,Length(Result)-3)+'ini';
end;

function GetDataDir: string;
begin
  Result:=ExtractFilePath(Application.ExeName);
end;

procedure TfmMain.LoadFromIni;
var
  fi: TIniFile;
begin
  fi:=nil;
  try
    fi:=TIniFile.Create(GetIniFileName);
    edBeforeTree.Text:=fi.ReadString(ClassName,edBeforeTree.Name,edBeforeTree.Text);
    edAfterTree.Text:=fi.ReadString(ClassName,edAfterTree.Name,edAfterTree.Text);
    edPointerTree.Text:=fi.ReadString(ClassName,edPointerTree.Name,edPointerTree.Text);
    Grid.DefaultRowHeight:=fi.ReadInteger(ClassName,Grid.Name,Grid.DefaultRowHeight);
    edFilter.Text:=fi.ReadString(ClassName,edFilter.Name,edFilter.Text);
    fmMain.WindowState:=TWindowState(fi.ReadInteger(ClassName,fmMain.Name,Integer(fmMain.WindowState)));
    edOOO.Text:=fi.ReadString(ClassName,edOOO.Name,edOOO.Text);
    SetDefaultStrColumns(fi.ReadString(ClassName,'Columns',GetDefaultStrColumns));
  finally
    fi.Free;
  end;
end;

function TfmMain.GetDefaultStrColumns: string;
var
  ms: TMemoryStream;
  s: string;
begin
  Result:='';
  ms:=TMemoryStream.Create;
  try
    Grid.Columns.SaveToStream(ms);
    ms.Position:=0;
    SetLength(s,ms.Size);
    Move(ms.Memory^,Pointer(s)^,ms.Size);
    Result:=StrTohexStr(s); 
  finally
    ms.Free;
  end;  
end;

procedure TfmMain.SetDefaultStrColumns(Value: string);
var
  ms: TMemoryStream;
  s: string;
begin
  ms:=TMemoryStream.Create;
  try
    s:=HexStrToStr(Value);
    ms.SetSize(Length(s));
    Move(Pointer(s)^,ms.Memory^,ms.Size);
    Grid.Columns.LoadFromStream(ms);
  finally
    ms.Free;
  end;  
end;

procedure TfmMain.SaveToIni;
var
  fi: TIniFile;
begin
  fi:=nil;
  try
    fi:=TIniFile.Create(GetIniFileName);
    fi.WriteString(ClassName,edBeforeTree.Name,edBeforeTree.Text);
    fi.WriteString(ClassName,edAfterTree.Name,edAfterTree.Text);
    fi.WriteString(ClassName,edPointerTree.Name,edPointerTree.Text);
    fi.WriteInteger(ClassName,Grid.Name,Grid.DefaultRowHeight);
    fi.WriteString(ClassName,edFilter.Name,edFilter.Text);
    fi.WriteInteger(ClassName,fmMain.Name,Integer(fmMain.WindowState));
    fi.WriteString(ClassName,edOOO.Name,edOOO.Text);
    fi.WriteString(ClassName,'Columns',GetDefaultStrColumns);
  finally
    fi.Free;
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveToIni;
  
  cdsAncement.Cancel;
  cdsAncement.MergeChangeLog;
  cdsAncement.SaveToFile(GetDataDir+ConstFileAnnouncement);

  fmTreeHeading.cdsTree.Cancel;
  fmTreeHeading.cdsTree.SaveToFile(GetDataDir+ConstFileTreeHeading);

  Grid.Parent:=nil;
  Grid.Free;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin

  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnInputGrid;
  Grid.Align:=alClient;
  Grid.DataSource:=ds;
  Grid.Name:='Grid';
  Grid.RowSelected.Visible:=true;
  Grid.VisibleRowNumber:=false;
  Grid.TitleFont.Assign(Grid.Font);
  Grid.RowSelected.Font.Assign(Grid.Font);
  Grid.RowSelected.Brush.Style:=bsClear;
  Grid.RowSelected.Brush.Color:=clBlack;
  Grid.RowSelected.Font.Color:=clWhite;
  Grid.RowSelected.Pen.Style:=psClear;
  Grid.CellSelected.Visible:=true;
  Grid.CellSelected.Brush.Color:=clBlue;
  Grid.CellSelected.Font.Assign(Grid.Font);
  Grid.CellSelected.Font.Color:=clHighlightText;
  Grid.TitleCellMouseDown.Font.Assign(Grid.Font);
  Grid.TitleCellMouseDown.Visible:=true;
  Grid.Options:=Grid.Options-[dgTabs]+[dgCancelOnExit,dgMultiSelect];
  Grid.RowSizing:=true;
  Grid.ReadOnly:=false;
  Grid.OnEditButtonClick:=GridOnEditButtonClick;
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
  Grid.OnExit:=GridOnExit;
  Grid.ColumnSortEnabled:=true;
  Grid.OnTitleClick:=GridTitleClick;
  Grid.OnKeyDown:=GridOnKeyDown;

  cl:=Grid.Columns.Add;
  cl.Title.Caption:='Выпуск';
  cl.Field:=cdsAncementreleasenum;
  cl.Width:=40;

  cl:=Grid.Columns.Add;
  cl.Title.Caption:='Рубрика';
  cl.ReadOnly:=true;
  cl.ButtonStyle:=cbsEllipsis;
  cl.Field:=cdsAncementtreeheadingname;
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.Title.Caption:='Текст объявления';
  cl.Field:=cdsAncementtextannouncement;
  cl.Width:=300;


{ Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyPress:=GridKeyPress;
  Grid.TabOrder:=1;}

  pcMain.ActivePageIndex:=0;
  LoadFromIni;
end;

procedure TfmMain.GridOnExit(Sender: TObject);
begin
  
end;

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  Close;
end;

function TfmMain.InitData: Boolean;
begin
  Screen.Cursor:=crHourGlass;
  try
    Result:=false;

    fmTreeHeading.cdsTree.Active:=false;
    
    fmTreeHeading.cdsTree.LoadFromFile(GetDataDir+ConstFileTreeHeading);
    if fmTreeHeading.TreeView.GetFirst<>nil then begin
      fmTreeHeading.TreeView.Expanded[fmTreeHeading.TreeView.GetFirst]:=true;
    end;

    cdsAncement.Active:=false;

    try
      cdsAncement.LoadFromFile(GetDataDir+ConstFileAnnouncement);
    except
      on E: Exception do begin
        ShowErrorEx(E.Message);
      end;
    end;  

    cdsAncement.Filter:=' releasenum = '+QuotedStr(edFilter.Text)+' ';
    cdsAncement.Filtered:=Trim(edFilter.Text)<>'';

    Result:=true;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmMain.GridOnEditButtonClick(Sender: TObject);
begin
  fmTreeHeading.TreeView.CollapseAll;
  fmTreeHeading.TreeView.GoToRec(cdsAncement.FieldByName('treeheading_id').AsInteger);
  fmTreeHeading.ActiveControl:=fmTreeHeading.TreeView;
  if fmTreeHeading.ShowModal=mrOk then begin
    cdsAncement.Edit;
    cdsAncement.FieldByName('treeheading_id').AsInteger:=fmTreeHeading.cdsTree.FieldByName('treeheading_id').AsInteger;
  end;
end;

function TfmMain.GetTreeHeadingName(treeheading_id: Integer): string;
begin
  Result:=fmTreeHeading.GetTreeViewPath(treeheading_id,edBeforeTree.Text,edAfterTree.Text,edPointerTree.Text);
end;

procedure TfmMain.cdsAncementCalcFields(DataSet: TDataSet);
begin
  DataSet['treeheadingname']:=GetTreeHeadingName(DataSet.FieldByName('treeheading_id').AsInteger);
end;

procedure TfmMain.edFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  cdsAncement.Filter:=' releasenum = '+QuotedStr(edFilter.Text)+' ';
  cdsAncement.Filtered:=Trim(edFilter.Text)<>'';
end;

procedure TfmMain.edFindKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if grid.SelectedField.FullName='treeheadingname' then exit;
  cdsAncement.Locate(grid.SelectedField.FullName,Trim(edFind.Text),[loCaseInsensitive,loPartialKey]);
end;

procedure TfmMain.edFindKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
end;

procedure TfmMain.pcMainChange(Sender: TObject);
begin
  case pcMain.ActivePageIndex of
    0: begin
      DBNav.Visible:=true;
      gag.Visible:=false;
      lbRecordCount.Visible:=true;
    end;
    1: begin
      DBNav.Visible:=false;
      gag.Visible:=true;
      lbRecordCount.Visible:=false;
    end;
  end;
end;

procedure TfmMain.btExportClick(Sender: TObject);
begin
  sd.FileName:=edOOO.Text+' '+FormatDateTime(fmtDateTimeSave,Now);
  if not sd.Execute then exit;
  ExportAnnouncementToFile(sd.FileName);
end;

procedure TfmMain.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked then begin
    edExportReleaseNum.Enabled:=false;
    edExportReleaseNum.Color:=clBtnFace;
  end else begin
    edExportReleaseNum.Enabled:=true;
    edExportReleaseNum.Color:=clWindow;
  end;
end;

procedure TfmMain.ExportAnnouncementToFile(FileName: string);
var
  rs: TTsvRTFMemoryStream;
  IncCount: Integer;


  procedure ExportLocal;
  var
    b: TBookmark;
    Node: PVirtualNode;
    Data: PDBVTData;
    i: Integer;
    fnt: TFont;
  begin
    cdsAncement.DisableControls;
    b:=cdsAncement.GetBookmark;
    fnt:=TFont.Create;
    fnt.Size:=8;
    try
      Node:=fmTreeHeading.TreeView.GetFirst;
      i:=0;
      gag.MaxValue:=fmTreeHeading.TreeView.TotalCount;
      While Assigned(Node) Do Begin
        Data:=fmTreeHeading.TreeView.GetNodeData(Node);
        inc(i);
        if Assigned(Data) then begin
          if RadioButton2.Checked then begin
            cdsAncement.Filter:=' releasenum='+QuotedStr(edExportReleaseNum.text)+' and treeheading_id='+inttostr(Data.ID);
          end else begin
            cdsAncement.Filter:=' treeheading_id='+inttostr(Data.ID);
          end;
          cdsAncement.Filtered:=false;
          cdsAncement.Filtered:=true;
          cdsAncement.First;
          if not cdsAncement.IsEmpty then
            rs.CreateString(fmTreeHeading.GetTreeViewPath(Data.ID,edBeforeTree.Text,edAfterTree.Text,edPointerTree.Text),fnt,true);
          while not cdsAncement.Eof do begin
            rs.CreateString(cdsAncement.FieldByName('textannouncement').AsString,fnt,true);
            cdsAncement.Next;
            IncCount:=IncCount+1;
          end;
        end;
        Node:=fmTreeHeading.TreeView.GetNext(Node);
        gag.Progress:=i;
      end;
    finally
      gag.Progress:=0;
      fnt.Free;
      cdsAncement.Filter:=' releasenum = '+QuotedStr(edFilter.Text)+' ';
      cdsAncement.Filtered:=Trim(edFilter.Text)<>'';
      cdsAncement.GotoBookmark(b);
      cdsAncement.EnableControls;
    end;
  end;

  procedure DisableControl(isTrue: Boolean);
  begin
    if isTrue then begin
      pcMain.Enabled:=false;
    end else begin
      pcMain.Enabled:=true;
    end;
  end;

var
  NewFileName: string;
  NewFileExt: string;
begin
  Update;
  DisableControl(true);
  rs:=TTsvRTFMemoryStream.Create;
  try
    IncCount:=0;
    rs.OpenRtf;
    rs.CreateHeader;
    rs.OpenBody;
    ExportLocal;
    rs.CloseBody;
    rs.CloseRtf;
    NewFileName:=ExtractFileName(FileName);
    NewFileName:=ChangeFileExt(NewFileName,'');
    NewFileExt:=ExtractFileExt(FileName);
    NewFileName:=NewFileName+Format(fmtSaveFileName,[IncCount])+NewFileExt;
    rs.SaveToFile(NewFileName);
  finally
    rs.Free;
    DisableControl(false);
  end;
end;

procedure TfmMain.dbMemoTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then Key:=0;
end;

function TfmMain.StrToHexStr(S:String):String;
var
  i: Integer;
  l: Integer;
begin
  l:=Length(S);
  Result:='';
  for i:=1 to l do
   Result:=Result+IntToHex(Word(S[i]),2);
end;

function TfmMain.HexStrToStr(S:String):String;
var
  l: Integer;
  APos: Integer;
  tmps: string;
begin
  l:=Length(S);
  APos:=1;
  Result:='';
  while APos<(l+1) do begin
    tmps:=Copy(S,APos,2);
    Result:=Result+Char(StrToIntDef('$'+tmps,0));
    inc(APos,2);
  end;
end;

procedure TfmMain.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
begin
  if cdsAncement.IsEmpty then exit;
  fn:=Column.FieldName;
  if AnsiUpperCase(fn)='TREEHEADINGNAME' then fn:='treeheading_id';
  case TypeSort of
    tcsNone: cdsAncement.IndexName:='';
    tcsAsc: cdsAncement.IndexName:=AnsiUpperCase(fn+'Asc');
    tcsDesc: cdsAncement.IndexName:=AnsiUpperCase(fn+'Desc');
  end;
end;

procedure TfmMain.GridTitleClick(Column: TColumn);
begin
end;

procedure TfmMain.cdsAncementAfterInsert(DataSet: TDataSet);
begin
  lbRecordCount.Caption:=Format(fmtRecordCount,[cdsAncement.RecordCount]);
end;

procedure TfmMain.cdsAncementAfterDelete(DataSet: TDataSet);
begin
  Screen.Cursor:=crDefault;
  lbRecordCount.Caption:=Format(fmtRecordCount,[cdsAncement.RecordCount]);
end;

procedure TfmMain.cdsAncementAfterOpen(DataSet: TDataSet);
begin
  lbRecordCount.Caption:=Format(fmtRecordCount,[cdsAncement.RecordCount]);
end;

procedure TfmMain.GridOnKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
var
  b: TBookmark;

begin
   if Shift=[ssCtrl] then
    if (Key=Ord('A')) or (Key=Ord('a')) then begin
       Screen.Cursor:=crHourGlass;
       cdsAncement.DisableControls;
       b:=cdsAncement.GetBookmark;
       try
         cdsAncement.First;
         while not cdsAncement.Eof do begin
           Grid.SelectedRows.CurrentRowSelected:=true;
           cdsAncement.Next;
         end;
       finally
         cdsAncement.GotoBookmark(b);
         cdsAncement.EnableControls;
         Screen.Cursor:=crDefault;
       end;
    end;
end;

procedure TfmMain.cdsAncementBeforeDelete(DataSet: TDataSet);
begin
  Screen.Cursor:=crHourGlass;
end;

procedure TfmMain.cdsAncementAfterPost(DataSet: TDataSet);
begin
  lbRecordCount.Caption:=Format(fmtRecordCount,[cdsAncement.RecordCount]);
end;

function isValidKey(Key: Char): Boolean;
begin
  Result:=(Byte(Key) in [byte('A')..byte('z')]) or
          (Byte(Key) in [byte('А')..byte('я')])or
          (Byte(Key) in [byte('0')..byte('9')])or
          (Byte(Key) in [byte(' ')]);
end;

procedure TfmMain.edOOOKeyPress(Sender: TObject; var Key: Char);
begin
  if (not IsValidKey(Key))and
     (Word(Key)<>VK_BACK)and
     (Word(Key)<>VK_DELETE) then Key:=Char(nil);
end;

end.
