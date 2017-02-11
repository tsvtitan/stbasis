unit ActualTime;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, CalendarData,
  StdCtrls, ComCtrls, ExtCtrls, Grids, DBGrids, RXDBCtrl, Placemnt, CalendarCode,
  Menus, Db, IBCustomDataSet, IBQuery, IBDatabase, DBCtrls, RxMemDS, UMainUnited;

type
  TfrmActualTime = class(TForm)
    PanelBottom: TPanel;
    PanelTop: TPanel;
    SplitterV: TSplitter;
    LookupCalendar: TComboBox;
    LabelCalendar: TLabel;
    PanelRight: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    GridActualTime: TRxDBGrid;
    PanelDivergence: TPanel;
    LabelDivergence: TLabel;
    GridDivergence: TRxDBGrid;
    PanelDivergenceEdit: TPanel;
    btnDivergenceAdd: TButton;
    btnDivergenceEdit: TButton;
    btnDivergenceDelete: TButton;
    SplitterH: TSplitter;
    PanelActualTime: TPanel;
    Button4: TButton;
    PanelLeft: TPanel;
    GridEmp: TRxDBGrid;
    PanelEmpSearch: TPanel;
    EditEmpSearch: TEdit;
    PanelClose: TPanel;
    ButtonClose: TButton;
    pmSetup: TPopupMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    PanelTop2: TPanel;
    ButtonFilter: TButton;
    btnSetup: TButton;
    ButtonRefresh: TButton;
    trRead: TIBTransaction;
    trWrite: TIBTransaction;
    quCalSelect: TIBQuery;
    quEmpSelect: TIBQuery;
    quActualTime: TIBQuery;
    quDivergence: TIBQuery;
    dsCalSelect: TDataSource;
    dsEmpSelect: TDataSource;
    dsActualTime: TDataSource;
    dsDivergence: TDataSource;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    LabelCount: TLabel;
    mdActualTime: TRxMemoryData;
    mdActualTimeScheduleDate: TDateField;
    mdActualTimeInfo: TStringField;
    quShiftSelect: TIBQuery;
    quATimeChange: TIBQuery;
    quAbsenceSelect: TIBQuery;
    mdActualTimeLeft: TIntegerField;
    Bevel1: TBevel;
    ButtonCopy: TButton;
    RxDBGrid1: TRxDBGrid;
    DataSource1: TDataSource;
    ButtonReplace: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonCloseClick(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure ButtonFilterClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PanelEmpSearchResize(Sender: TObject);
    procedure LookupCalendarChange(Sender: TObject);
    procedure CommonAfterScroll(DataSet: TDataSet);
    procedure EditEmpSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetupClick(Sender: TObject);
    procedure CommonGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure CommonGridEnter(Sender: TObject);
    procedure CommonGridExit(Sender: TObject);
    procedure btnDivergenceAddClick(Sender: TObject);
    procedure btnDivergenceEditClick(Sender: TObject);
    procedure btnDivergenceDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure GridActualTimeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mdActualTimeLeftGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure GridActualTimeDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure GridActualTimeGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure GridActualTimeGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridActualTimeTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure GridActualTimeCellClick(Column: TColumn);
    procedure GridActualTimeShowEditor(Sender: TObject; Field: TField;
      var AllowEdit: Boolean);
    procedure GridActualTimeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GridActualTimeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GridActualTimeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonReplaceClick(Sender: TObject);
    procedure GridActualTimeEditChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure PanelActualTimeResize(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ButtonCopyClick(Sender: TObject);
  private
   ActualTimeAction:TActualTimeAction;
   ActualTimeParams:PParamServiceInterface;
   FhInterface: THandle;
   FirstActive:Boolean;
   Refreshing:Boolean;
   FTimeDefValue:TStringList;
//   GetFullText:Boolean;

   StartSelecting:Boolean;
   StartCopy:Boolean;
   SCol,SRow:Integer;
   LastSelMode:TSelMode;

   procedure RecreateActualTimeGrid;
   procedure mdActualTimeScheduleDateChange(Sender: TField);

   procedure ClearSelecting(ADataSet:TDataSet);
   procedure SelectAll(ADataSet:TDataSet);
   procedure MouseToCell2(AGrid:TRxDBGrid; X, Y: Integer; var ACol, ARow: Longint);
   function GetHideField(F:TField):TIntegerField;

   procedure mdActualTimeDataGetText(Sender: TField;var Text: String; DisplayText: Boolean);

  public
   constructor Create(AOwner: TComponent;AhInterface: THandle;AActualTimeAction:TActualTimeAction;AParams:PParamServiceInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmActualTime: TfrmActualTime;

implementation

{$R *.DFM}

uses TypInfo, StrUtils, SysUtils, UAdjust, ATimeFilter,
  StCalendarUtil, DateUtil, ATimeDivergenceEdit, ATimeInfo;

constructor TfrmActualTime.Create(AOwner: TComponent;AhInterface: THandle;AActualTimeAction:TActualTimeAction;AParams:PParamServiceInterface);
//var I:Integer;
begin
 ActualTimeAction:=AActualTimeAction;
 ActualTimeParams:=AParams;
 FirstActive:=True;
// GetFullText:=False;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);

 FTimeDefValue:=TStringList.Create;
 FTimeDefValue.Add('1,0');
 FTimeDefValue.Add('2,0');
 FTimeDefValue.Add('3,0');
 FTimeDefValue.Add('4,0');
 FTimeDefValue.Add('5,0');
 FTimeDefValue.Add('6,0');
 FTimeDefValue.Add('7,0');
 FTimeDefValue.Add('8,0');
 FTimeDefValue.Add('9,0');

 inherited Create(AOwner);

 Caption:='Фактические отработки';
 FormStyle:=fsMDIChild;

 AssignFont(_GetOptions.RBTableFont,GridEmp.Font);
 GridEmp.TitleFont.Assign(GridEmp.Font);
 AssignFont(_GetOptions.RBTableFont,GridActualTime.Font);
 GridActualTime.TitleFont.Assign(GridActualTime.Font);
 AssignFont(_GetOptions.RBTableFont,GridDivergence.Font);
 GridDivergence.TitleFont.Assign(GridDivergence.Font);
end;

procedure TfrmActualTime.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);
 DoRefresh;
end;

procedure TfrmActualTime.mdActualTimeScheduleDateChange(Sender: TField);
var NewID:Integer;
    ATime,AAbsence:String;
begin
 quATimeChange.SQL.Text:=Format('delete from actualtime where (shift_id=%s) and (empplant_id=%d) and (workdate=CAST(''%s'' AS DATE))',
  [Sender.LookupKeyFields,quEmpSelect.FieldByName('empplant_id').AsInteger,mdActualTimeScheduleDate.AsString]);
 if not quATimeChange.Transaction.InTransaction then quATimeChange.Transaction.StartTransaction;
 try
  quATimeChange.ExecSQL;
  quATimeChange.Transaction.Commit;
 except
  quATimeChange.Transaction.Rollback;
  Exit;
 end;
 if Sender.AsString='' then Exit;
 if Pos(';',Sender.AsString)=0 then
 begin
  ATime:=Sender.AsString;
  AAbsence:=quAbsenceSelect.FieldByName('Absence_id').AsString;
 end else
 begin
  AAbsence:=ExtractWord(1,Sender.AsString,[';']);
  if Trim(AAbsence)='' then AAbsence:=quAbsenceSelect.FieldByName('Absence_id').AsString;
  ATime:=ExtractWord(3,Sender.AsString,[';']);
  ATime:=ReplaceStr(ATime,',','.');
 end;
 if Trim(ATime)<>'' then
 begin
  NewID:=GetGenId(dbSTBasis,tbActualTime,1);
  quATimeChange.SQL.Text:=Format('insert into actualtime (actualtime_id,shift_id,empplant_id,absence_id,workdate,timecount) values (%d,%s,%d,%s,CAST(''%s'' AS DATE),%s)',
   [NewID,Sender.LookupKeyFields,quEmpSelect.FieldByName('empplant_id').AsInteger,AAbsence,mdActualTimeScheduleDate.AsString,ATime]);
  if not quATimeChange.Transaction.InTransaction then quATimeChange.Transaction.StartTransaction;
  try
   quATimeChange.ExecSQL;
   quATimeChange.Transaction.Commit;
  except
   quATimeChange.Transaction.Rollback;
  end;
 end;
// UpdateScheduleInfo;
end;

procedure TfrmActualTime.RecreateActualTimeGrid;
var D,Last:TDateTime;
    A,CurEmp:Integer;
    F1:TStringField;
    F2:TIntegerField;
//    CurNormalTime:Double;
//    B:String;
//    Progress1,Progress2:DWord;
begin
 //Объявляем о начале рефреша
 Refreshing:=True;

 LastSelMode:=slmNone;
 StartSelecting:=False;
 StartCopy:=False;

 mdActualTime.DisableControls;
{ PanelWait.BringToFront;

 PanelTop1.Enabled:=False;
 PanelTop2.Enabled:=False;
 PanelBottom.Enabled:=False;
 GridSchedule.Enabled:=False;
}
 mdActualTime.EmptyTable;
 mdActualTime.Close;
 try
  for A:=mdActualTime.Fields.Count downto 1 do
   if (UpperCase(mdActualTime.Fields[A-1].FullName)<>UpperCase('LEFT')) and
      (UpperCase(mdActualTime.Fields[A-1].FullName)<>UpperCase('ScheduleDate')) and
      (UpperCase(mdActualTime.Fields[A-1].FullName)<>UpperCase('Info')) then mdActualTime.Fields[A-1].Free;

  GridActualTime.Columns.RebuildColumns;
{  for A:=1 to GridActualTime.Columns.Count do
    GridActualTime.Columns[A-1].ReadOnly:=False;}
  quShiftSelect.First;A:=1;
  while not quShiftSelect.EOF do
  begin
   F1:=TStringField.Create(mdActualTime);
   F1.Name:='mdActualTimeShift'+quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F1.DisplayLabel:=quShiftSelect.FieldByName(fldShiftName).AsString;
   F1.Size:=200;
   F1.FieldKind:=fkData;
   F1.FieldName:='Shift'+IntToStr(A);
   F1.LookupKeyFields:=quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F1.KeyFields:='Col'+IntToStr(A);
   F1.DataSet:=mdActualTime;
   F1.OnGetText:=mdActualTimeDataGetText;

   F2:=TIntegerField.Create(mdActualTime);
   F2.Name:='mdActualTimeCol'+quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F2.Visible:=False;
   F2.FieldKind:=fkData;
   F2.FieldName:='Col'+IntToStr(A);
   F2.LookupKeyFields:='';
   F2.KeyFields:='hide';
   F2.DataSet:=mdActualTime;

   quShiftSelect.Next;
   Inc(A);
  end;
  GridActualTime.Columns.RebuildColumns;
  for A:=1 to GridActualTime.Columns.Count do
  begin
   if UpperCase(GridActualTime.Columns[A-1].Field.FullName)='LEFT' then
    GridActualTime.Columns[A-1].Width:=16 else
    GridActualTime.Columns[A-1].Width:=90;
   if GridActualTime.Columns[A-1].Field.LookupKeyFields<>'' then
    GridActualTime.Columns[A-1].PickList.Assign(FTimeDefValue);
   if GridActualTime.Columns[A-1].Field.KeyFields='hide' then
    GridActualTime.Columns[A-1].Visible:=False;
  end;
 except
 end;
 try
  mdActualTime.Open;
 except
 end;
 if not quEmpSelect.IsEmpty then
 try
  CurEmp:=quEmpSelect.FieldByName('empplant_id').AsInteger;

  D:=quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime;
  Last:=GelLastDateForCalendar(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger);

{  ProgressBar.Position:=0;
  ProgressBar.Max:=DaysBetween(D,Last);
  Progress1:=_CreateProgressBar(0,DaysBetween(D,Last),'',clNavy);
  LabelProgress.Caption:='Создание календаря...';
  Application.ProcessMessages;}
  while D<=Last do
  begin
   mdActualTime.Append;
   mdActualTimeScheduleDate.AsDateTime:=D;
   if IsFreeday(D) then
    mdActualTimeInfo.AsString:='выходной';
   if IsCarryingFrom(D) then
    mdActualTimeInfo.AsString:='';
   if IsCarryingTo(D) then
    mdActualTimeInfo.AsString:='пер. выходной';
   if IsHoliday(D) then
    mdActualTimeInfo.AsString:='праздник';
   mdActualTime.Post;
{   ProgressBar.StepIt;
   _SetProgressStatus(Progress1,ProgressBar.Position);
   Application.ProcessMessages;}
   D:=IncDay(D,1);
  end;

//  _FreeProgressBar(Progress);

  //Новый и быстрый способ
{  ProgressBar.Position:=0;
  ProgressBar.Max:=ProgressBar.Max*A;
  Progress2:=_CreateProgressBar(0,ProgressBar.Max,'',clRed);
  LabelProgress.Caption:='Заполнение значений...';
  Application.ProcessMessages;}
  quActualTime.SQL.Text:=Format('select t.absence_id,a.shortname as absencename,t.workdate,t.shift_id,t.timecount from actualtime t left join absence a on t.absence_id=a.absence_id where empplant_id=%d',[CurEmp]);
  try
   quActualTime.Open;
   while not quActualTime.EOF do
   begin
    if mdActualTime.Locate('ScheduleDate',quActualTime.FieldByName('WorkDate').AsDateTime,[]) then
    begin
     for A:=1 to mdActualTime.Fields.Count do
      if mdActualTime.Fields[A-1].LookupKeyFields=quActualTime.FieldByName('Shift_ID').AsString then
      begin
       mdActualTime.Edit;
       mdActualTime.Fields[A-1].AsString:=
        quActualTime.FieldByName('Absence_id').AsString+' ;'+
        quActualTime.FieldByName('AbsenceName').AsString+' ;'+
        quActualTime.FieldByName('TimeCount').AsString;
       mdActualTime.Post;
      end;
    end;
    quActualTime.Next;
{    ProgressBar.StepIt;
   _SetProgressStatus(Progress2,ProgressBar.Position);}
   end;
   quActualTime.Close;
  except
  end;

{  _FreeProgressBar(Progress1);
  _FreeProgressBar(Progress2);}

  mdActualTime.First;
  for A:=mdActualTime.Fields.Count downto 1 do
   if mdActualTime.Fields[A-1].LookupKeyFields<>'' then mdActualTime.Fields[A-1].OnChange:=mdActualTimeScheduleDateChange;

  GridActualTime.Color:=clWindow;
 except
 end else GridActualTime.Color:=clBtnFace;
 GridActualTime.Enabled:=not quEmpSelect.IsEmpty;

{ PanelTop1.Enabled:=True;
 PanelTop2.Enabled:=True;
 PanelBottom.Enabled:=True;
 GridSchedule.Enabled:=True;

 UpdateScheduleInfo;        }

 mdActualTime.EnableControls;
// PanelWait.SendToBack;

 try
  GridActualTime.Col:=3;
 except
 end;
{ for A:=1 to GridActualTime.Columns.Count do
  if GridActualTime.Columns[A-1].Field.LookupKeyFields='' then
   GridActualTime.Columns[A-1].ReadOnly:=True;}

 Refreshing:=False;
end;

procedure TfrmActualTime.DoRefresh;
var //TempStr:String;
    I:Integer;
    LastCalendar,LastEmployee,LastDivergence,LastActualTime:String;
begin
 Refreshing:=True;

 try
  LastCalendar:=quCalSelect.Bookmark;
  LastEmployee:=quEmpSelect.Bookmark;
  LastDivergence:=quDivergence.Bookmark;
  LastActualTime:=mdActualTime.Bookmark;
 except
 end; 

 if quCalSelect.Active then quCalSelect.Close;
 quCalSelect.SQL.Text:='select calendar_id,startdate from calendar order by startdate ';

 if quEmpSelect.Active then quEmpSelect.Close;
 quEmpSelect.SQL.Text:='select e.emp_id,ep.empplant_id,e.tabnum,e.perscardnum,e.fname,e.name,e.sname,'+
  'n.name as netname,c.num as classnum,p.smallname as plantname,cat.name as categoryname,'+
  's.name as seatname,d.name as departname,prof.name as profname '+
  'from emp e '+
  'join empplant ep on e.emp_id=ep.emp_id '+
  'join net n on ep.net_id=n.net_id '+
  'join class c on ep.class_id=c.class_id '+
  'join plant p on ep.plant_id=p.plant_id '+
  'join category cat on ep.category_id=cat.category_id '+
  'join seat s on ep.seat_id=s.seat_id '+
  'join depart d on ep.depart_id=d.depart_id '+
  'join prof on ep.prof_id=prof.prof_id ';

 if quShiftSelect.Active then quShiftSelect.Close;

 if quDivergence.Active then quDivergence.Close;

 if quAbsenceSelect.Active then quAbsenceSelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quCalSelect.Open;
  quEmpSelect.Open;
  quDivergence.Open;
  quShiftSelect.Open;
  quAbsenceSelect.Open;

  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
 end;

 LookupCalendar.Items.Clear;
 quCalSelect.First;
 while not quCalSelect.EOF do
 begin
  LookupCalendar.Items.AddObject(FormatDateTime('dd mmmm yyyyг.',
   quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime),
   Pointer(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger));
  quCalSelect.Next;
 end;

 try
  quCalSelect.Bookmark:=LastCalendar;
  quEmpSelect.Bookmark:=LastEmployee;
  quDivergence.Bookmark:=LastDivergence;
 except
 end;

 try
  for I:=1 to LookupCalendar.Items.Count do
   if Integer(LookupCalendar.Items.Objects[I-1])=quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger then
   begin
    LookupCalendar.ItemIndex:=I-1;
    Break;
   end;
 except
 end;

 RecreateActualTimeGrid;

 try
  mdActualTime.Bookmark:=LastActualTime;
 except
 end;

 for I:=1 to ComponentCount do
  if Components[I-1] is TRxDBGrid then
   with Components[I-1] as TRxDBGrid do
   if (DataSource<>nil)and (DataSource.DataSet<>nil) and DataSource.DataSet.Active then
   try
    SelectedRows.Clear;
    SelectedRows.CurrentRowSelected:=True;
   except
   end;

  btnDivergenceAdd.Enabled:=_isPermission(tbDivergence,InsConst);
  btnDivergenceEdit.Enabled:=_isPermission(tbDivergence,UpdConst);
  btnDivergenceDelete.Enabled:=_isPermission(tbDivergence,DelConst);

 Refreshing:=False;
end;

procedure TfrmActualTime.FormDestroy(Sender: TObject);
begin
 HideActualInfo;
 FTimeDefValue.Free;
 if ActualTimeAction=aaActualTimeEdit then frmActualTime:=nil;
// _RemoveFromLastOpenEntryes(FTypeEntry);
end;

procedure TfrmActualTime.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 //Exec for all modal action
 if ActualTimeAction=aaActualTimeEdit then Action:=caFree;
 Application.Hint:='';
 HideActualInfo;
end;

procedure TfrmActualTime.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Shift=[]) and (ActualTimeAction=aaActualTimeEdit) then
 case Key of
  VK_F5:ButtonRefresh.Click;
  VK_F6:;
  VK_F7:;
//  VK_F8:btnHolidayGridColsSet.Click;
 end;
 _MainFormKeyDown(Key,Shift);
end;

procedure TfrmActualTime.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmActualTime.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmActualTime.ButtonCloseClick(Sender: TObject);
begin
 if ActualTimeAction<>aaActualTimeEdit then Exit;
 Close;
end;

procedure TfrmActualTime.btnSetupClick(Sender: TObject);
var P:TPoint;
begin
 P.x:=btnSetup.Left;
 P.y:=btnSetup.Top+btnSetup.Height;
 P:=PanelTop2.ClientToScreen(P);
 pmSetup.Popup(P.x,P.y);
end;

procedure TfrmActualTime.ButtonFilterClick(Sender: TObject);
begin
 frmATimeFilter:=TfrmATimeFilter.Create(Application);
 try
  frmATimeFilter.ShowModal;
 finally
//  frmATimeFilter.Release;
  frmATimeFilter.Free;
 end;
end;

procedure TfrmActualTime.ButtonRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmActualTime.FormResize(Sender: TObject);
begin
 LookupCalendar.Width:=PanelTop2.Left-LookupCalendar.Left;
end;

procedure TfrmActualTime.PanelEmpSearchResize(Sender: TObject);
begin
 EditEmpSearch.Width:=PanelEmpSearch.Width-EditEmpSearch.Left;
end;

procedure TfrmActualTime.LookupCalendarChange(Sender: TObject);
begin
 if ActualTimeAction<>aaActualTimeEdit then Exit;
 try
  quCalSelect.Locate(fldCalendarCalendarID,Integer(LookupCalendar.Items.Objects[LookupCalendar.ItemIndex]),[]);
 except
 end;
end;

procedure TfrmActualTime.CommonAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     RecreateActualTimeGrid;
    end;
  2:begin
     if GridEmp.DataSource.DataSet.Active then
     begin
      GridEmp.SelectedRows.Clear;
      GridEmp.SelectedRows.CurrentRowSelected:=True;
     end;
     RecreateActualTimeGrid;
    end;
  3:begin
     if GridDivergence.DataSource.DataSet.Active then
     begin
      GridDivergence.SelectedRows.Clear;
      GridDivergence.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
  4:begin
     if GridActualTime.DataSource.DataSet.Active then
     try
      GridActualTime.SelectedRows.Clear;
      GridActualTime.SelectedRows.CurrentRowSelected:=True;
//      GridActualTime.OnCellClick(GridActualTime.Columns[GridActualTime.Col]);
     except
     end;
    end;
 end;
end;

procedure TfrmActualTime.EditEmpSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quEmpSelect.Active) or quEmpSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridEmp.SetFocus;
   quEmpSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridEmp.SetFocus;
   quEmpSelect.Prior;
   Exit;
  end;
  if GridEmp.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('А')..byte('я')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quEmpSelect.Locate(GridEmp.SelectedField.FullName,Trim(EditEmpSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmActualTime.SetupClick(Sender: TObject);
begin
 case TRXDBGrid(Sender).Tag of
  1:SetAdjustColumns(GridEmp.Columns);
  3:SetAdjustColumns(GridDivergence.Columns);
 end;
end;

procedure TfrmActualTime.CommonGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var Index:Integer;
begin
 with Sender as TRxDBGrid do
 try
 if SelectedRows.Find(Field.DataSet.Bookmark, Index) then
  if SelectedRows[Index]=Field.DataSet.Bookmark then
   SetSelectedRowParams(AFont,Background);
 with Sender as TRxDBGrid do
 if Highlight then
  if Field.DataSet.IsEmpty then Background:=Color else
   SetSelectedColParams(AFont,Background);
 except
 end;
end;

procedure TfrmActualTime.CommonGridEnter(Sender: TObject);
var C:Integer;
begin
 if Sender is TCustomDBGrid then
 begin
  DBNavigator.DataSource:=TCustomDBGrid(Sender).DataSource;
  if TCustomDBGrid(Sender).DataSource.DataSet is TIBQuery then
   C:=GetRecordCount(TCustomDBGrid(Sender).DataSource.DataSet as TIBQuery)
  else
   if TCustomDBGrid(Sender).DataSource.DataSet is TDataSet then
    C:=TDataSet(TCustomDBGrid(Sender).DataSource.DataSet).RecordCount
   else C:=0;
  LabelCount.Enabled:=True;
  LabelCount.Caption:=ViewCountText+Format('%d',[C]);
 end;
end;

procedure TfrmActualTime.CommonGridExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmActualTime.btnDivergenceAddClick(Sender: TObject);
begin
 if quCalSelect.IsEmpty or quEmpSelect.IsEmpty then Exit;
 if AddDivergence(quCalSelect.FieldByName('calendar_id').AsInteger,
    quEmpSelect.FieldByName('empplant_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmActualTime.btnDivergenceEditClick(Sender: TObject);
begin
 if quCalSelect.IsEmpty or quEmpSelect.IsEmpty or (not btnDivergenceEdit.Enabled) then Exit;
 if EditDivergence(quCalSelect.FieldByName('calendar_id').AsInteger,
    quEmpSelect.FieldByName('empplant_id').AsInteger,
    quDivergence.FieldByName('divergence_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmActualTime.btnDivergenceDeleteClick(Sender: TObject);
begin
 if quDivergence.IsEmpty then Exit;
 if DeleteDivergence(quDivergence.FieldByName('divergence_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmActualTime.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridEmp.Columns);
// SetMinColumnsWidth(GridActualTime.Columns);
 SetMinColumnsWidth(GridDivergence.Columns);
 FormResize(Sender);
end;

procedure TfrmActualTime.GridActualTimeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if ((Key=VK_DELETE) or (Key=VK_BACK)) and
    (GridActualTime.DataSource.State=dsBrowse) and
    (GridActualTime.SelectedField.LookupKeyFields<>'') then
 begin
  GridActualTime.DataSource.DataSet.Edit;
  GridActualTime.SelectedField.Clear;
  GridActualTime.DataSource.DataSet.Post;
 end;
end;

procedure TfrmActualTime.MouseToCell2(AGrid: TRxDBGrid; X, Y: Integer; var ACol, ARow: Longint);
begin
 ACol:=-1;
 ARow:=-1;
 if AGrid=nil then Exit;
 AGrid.MouseToCell(X,Y,ACol,ARow);
 if (AGrid.DataSource<>nil) and (AGrid.DataSource.DataSet<>nil) then
  ARow:=AGrid.DataSource.DataSet.RecNo+(ARow-AGrid.Row);
end;

//Получаем скрытое поле для поля данных или nil
function TfrmActualTime.GetHideField(F:TField):TIntegerField;
var DS:TDataSet;
begin
 DS:=F.DataSet;
 try
  Result:=DS.FieldByName(F.KeyFields) as TIntegerField;
 except
  Result:=nil;
 end;
end;

//Очищаем всё
procedure TfrmActualTime.ClearSelecting(ADataSet:TDataSet);
var B:String;
    I:Integer;
begin
 B:=ADataSet.Bookmark;
 ADataSet.DisableControls;
 ADataSet.First;
 while not ADataSet.EOF do
 begin
  ADataSet.Edit;
  for I:=1 to ADataSet.Fields.Count do
  if (ADataSet.Fields[I-1].KeyFields='hide') or //Только для скрытых полей
     (UpperCase(ADataSet.Fields[I-1].FullName)=UpperCase('LEFT')) then
  begin
   //Убираем выделение строк
   ADataSet.Fields[I-1].AsInteger:=0;
   //Убираем выделение заголовков
   ADataSet.Fields[I-1].Tag:=0;
  end;
  ADataSet.Post;
  ADataSet.Next;
 end;
 ADataSet.EnableControls;
 ADataSet.Bookmark:=B;
end;

//Выделяем всё
procedure TfrmActualTime.SelectAll(ADataSet:TDataSet);
var B:String;
    I:Integer;
begin
 B:=ADataSet.Bookmark;
 ADataSet.DisableControls;
 ADataSet.First;
 while not ADataSet.EOF do
 begin
  ADataSet.Edit;
  for I:=1 to ADataSet.Fields.Count do
  begin
   if ADataSet.Fields[I-1].KeyFields='hide' then//Только для скрытых полей
    //Ставим выделение строки
    ADataSet.Fields[I-1].AsInteger:=1;
   //Выделяем заголовок
   if UpperCase(ADataSet.Fields[I-1].FullName)=UpperCase('LEFT') then
    ADataSet.Fields[I-1].Tag:=1;
  end;
  ADataSet.Post;
  ADataSet.Next;
 end;
 ADataSet.EnableControls;
 ADataSet.Bookmark:=B;
end;

procedure TfrmActualTime.mdActualTimeLeftGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
 Text:='';
end;

procedure TfrmActualTime.mdActualTimeDataGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
 if DisplayText then
 begin
  Text:=ExtractWord(3,Sender.AsString,[';'])+' '+ExtractWord(2,Sender.AsString,[';']);
 end else
 begin
  Text:=Sender.AsString;
 end;
end;

procedure TfrmActualTime.GridActualTimeDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var R:TRect;
begin
 TRxDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
 if UpperCase(Column.Field.FullName)='LEFT' then
 begin
  R:=Rect;
  DrawEdge(TRxDBGrid(Sender).Canvas.Handle,R,EDGE_RAISED,BF_BOTTOMRIGHT);
 end else
 if (gdSelected in State) and (Column.Field.LookupKeyFields<>'') then
 begin
  //У выбранного элемента рисуем красный квадрат
  TRxDBGrid(Sender).Canvas.Brush.Color:=clRed;
  TRxDBGrid(Sender).Canvas.Pen.Color:=clRed;
  TRxDBGrid(Sender).Canvas.Rectangle(Rect.Right-6,Rect.Bottom-6,Rect.Right,Rect.Bottom);
 end;
end;

procedure TfrmActualTime.GridActualTimeGetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
var WorkField:TIntegerField;
begin
 //Подсветка заголовка если выбрана вся колонка
 WorkField:=GetHideField(Field);
 if (WorkField<>nil) and (WorkField.Tag=1) then
 begin
  Background:=clBlack;
  AFont.Color:=clWhite;
 end;
end;

procedure TfrmActualTime.GridActualTimeGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var WorkField:TIntegerField;
begin
 WorkField:=GetHideField(Field);
 if WorkField<>nil then
 begin
  //Подсветка выделенной ячейки
  if WorkField.AsInteger=1 then
  begin
   Background:=clTeal;
   AFont.Color:=clWhite;
  end;
  //Подсветка ячейки для копирования
  if WorkField.AsInteger=2 then
  begin
   Background:=clGreen;
   AFont.Color:=clWhite;
  end;
 end;
 //Выбранная ячейка
 if Highlight then
 begin
  Background:=clHighlight;
  AFont.Color:=clWhite;
 end;
 //Крайнее левое поле обрабатываем особо
 if UpperCase(Field.FullName)='LEFT' then
 begin
  Background:=clBtnFace;
  AFont.Color:=clBlack;
  //Подсветка заголовка если выбрана вся строка
  if Field.AsInteger=1 then
  begin
   Background:=clBlack;
   AFont.Color:=clWhite;
  end;
 end;
 if (UpperCase(Field.FullName)=UpperCase('ScheduleDate')) or
    (UpperCase(Field.FullName)=UpperCase('Info')) then
  begin Background:=clInfoBk; AFont.Color:=clBtnText end;
end;

procedure TfrmActualTime.GridActualTimeTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
var B:String;
    WorkField:TIntegerField;
begin
 if UpperCase(Field.FullName)=UpperCase('LEFT') then
 begin
  SelectAll(Field.DataSet);
  LastSelMode:=slmAll;
 end
 else
 begin
  WorkField:=GetHideField(Field);
  if WorkField<>nil then
  begin
   //Очищаем только если не удерживает CTRL
   if ((GetAsyncKeyState(VK_LCONTROL)=0) and (GetAsyncKeyState(VK_RCONTROL)=0)) or
     (LastSelMode<>slmCols) then ClearSelecting(Field.DataSet);
   LastSelMode:=slmCols;

   B:=WorkField.DataSet.Bookmark;
   WorkField.DataSet.DisableControls;
   WorkField.DataSet.First;
   while not WorkField.DataSet.EOF do
   begin
    WorkField.DataSet.Edit;
    WorkField.AsInteger:=1;
    WorkField.DataSet.Post;
    WorkField.DataSet.Next;
   end;
   WorkField.Tag:=1;
   WorkField.DataSet.EnableControls;
   WorkField.DataSet.Bookmark:=B;
  end;
 end;
end;

procedure TfrmActualTime.GridActualTimeCellClick(Column: TColumn);
var I:Integer;
//    T:String;
begin
{ if (Column.Field.KeyFields<>'hide') and (Column.Field.KeyFields<>'none') then
 begin
  T:=Column.Field.AsString;
  T:=ExtractWord(1,T,[';']);
  quAbsenceSelect.Locate('absence_id',T,[]);
 end;}
 if UpperCase(Column.Field.FullName)=UpperCase('LEFT') then
 begin
  //Очищаем только если не удерживает CTRL
  if ((GetAsyncKeyState(VK_LCONTROL)=0) and (GetAsyncKeyState(VK_RCONTROL)=0)) or
   (LastSelMode<>slmRows) then ClearSelecting(Column.Field.DataSet);
  LastSelMode:=slmRows;
  Column.Field.DataSet.Edit;
  for I:=1 to Column.Field.DataSet.Fields.Count do
  begin
   if Column.Field.DataSet.Fields[I-1].KeyFields='hide' then//Только для скрытых полей
    //Выделяем саму ячейку
    Column.Field.DataSet.Fields[I-1].AsInteger:=1;
   if UpperCase(Column.Field.DataSet.Fields[I-1].FullName)=UpperCase('LEFT') then
    Column.Field.DataSet.Fields[I-1].AsInteger:=1
  end;
  Column.Field.DataSet.Post;
 end;
end;

procedure TfrmActualTime.GridActualTimeShowEditor(Sender: TObject;
  Field: TField; var AllowEdit: Boolean);
begin
 AllowEdit:=(UpperCase(Field.FullName)<>UpperCase('LEFT')) and
            (UpperCase(Field.FullName)<>UpperCase('ScheduleDate')) and
            (UpperCase(Field.FullName)<>UpperCase('Info'));
end;

procedure TfrmActualTime.GridActualTimeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button=mbRight then
 begin
  MouseToCell2(TRxDBGrid(Sender),X,Y,SCol,SRow);
  if (SCol>0) and (SRow>0) then
   if TRxDBGrid(Sender).Canvas.Pixels[X,Y]=clRed then StartCopy:=True else
    StartSelecting:=True;
 end;
end;

procedure TfrmActualTime.GridActualTimeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var Col,Row,C,R,First,Last:Integer;
    B:String;
    WorkField:TIntegerField;
begin
 MouseToCell2(TRxDBGrid(Sender),X,Y,Col,Row);
// Caption:=IntToStr(Row);
 if (Col>0) and (Row>0) then
 begin
  if StartCopy then
  begin
   ClearSelecting(TRxDBGrid(Sender).DataSource.DataSet);
   if Row>Srow then
    begin First:=SRow;Last:=Row;end
   else
    begin First:=Row;Last:=SRow;end;
   B:=TRxDBGrid(Sender).DataSource.DataSet.Bookmark;
   TRxDBGrid(Sender).DataSource.DataSet.DisableControls;
   for R:=First to Last do
   begin
    TRxDBGrid(Sender).DataSource.DataSet.RecNo:=R;
    TRxDBGrid(Sender).DataSource.DataSet.Edit;
    WorkField:=GetHideField(TRxDBGrid(Sender).Columns[SCol].Field);
    if WorkField<>nil then
     WorkField.AsInteger:=2;
    TRxDBGrid(Sender).DataSource.DataSet.Post;
   end;
   TRxDBGrid(Sender).DataSource.DataSet.EnableControls;
   TRxDBGrid(Sender).DataSource.DataSet.Bookmark:=B;
  end;
  if StartSelecting then
  try
   ClearSelecting(TRxDBGrid(Sender).DataSource.DataSet);
   B:=TRxDBGrid(Sender).DataSource.DataSet.Bookmark;
   TRxDBGrid(Sender).DataSource.DataSet.DisableControls;
   for C:=SCol to Col do
   begin
    for R:=SRow to Row do
    begin
     TRxDBGrid(Sender).DataSource.DataSet.RecNo:=R;
     TRxDBGrid(Sender).DataSource.DataSet.Edit;
     WorkField:=GetHideField(TRxDBGrid(Sender).Columns[C].Field);
     if WorkField<>nil then
      WorkField.AsInteger:=1;
     TRxDBGrid(Sender).DataSource.DataSet.Post;
    end;
    TRxDBGrid(Sender).DataSource.DataSet.EnableControls;
    TRxDBGrid(Sender).DataSource.DataSet.Bookmark:=B;
   end;
  except
   StartSelecting:=False;
  end;
 end;
end;

procedure TfrmActualTime.GridActualTimeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Col,Row,R,First,Last:Integer;
    B,V:String;
begin
 MouseToCell2(TRxDBGrid(Sender),X,Y,Col,Row);
 if (Col>0) and (Row>0) then
  if ((SCol=Col) and (SRow=Row)) or StartCopy then
   ClearSelecting(TRxDBGrid(Sender).DataSource.DataSet);
 if StartSelecting then
 begin
  LastSelMode:=slmRectangle;
  StartSelecting:=False;
 end;
 if StartCopy then
 begin
  if Row>Srow then
   begin First:=SRow;Last:=Row;end
  else
   begin First:=Row;Last:=SRow;end;
  B:=TRxDBGrid(Sender).DataSource.DataSet.Bookmark;
  TRxDBGrid(Sender).DataSource.DataSet.DisableControls;
  V:=TRxDBGrid(Sender).Columns[SCol].Field.AsString;
  for R:=First to Last do
  begin
   TRxDBGrid(Sender).DataSource.DataSet.RecNo:=R;
   TRxDBGrid(Sender).DataSource.DataSet.Edit;
   TRxDBGrid(Sender).Columns[SCol].Field.AsString:=V;
   TRxDBGrid(Sender).DataSource.DataSet.Post;
  end;
  TRxDBGrid(Sender).DataSource.DataSet.EnableControls;
  TRxDBGrid(Sender).DataSource.DataSet.Bookmark:=B;
  StartCopy:=False;
 end;
end;

procedure TfrmActualTime.ButtonReplaceClick(Sender: TObject);
var Old:String;
begin
 mdActualTime.Edit;
 try
  Old:=GridActualTime.Columns[GridActualTime.Col].Field.AsString;
  GridActualTime.Columns[GridActualTime.Col].Field.AsString:=
        quAbsenceSelect.FieldByName('Absence_id').AsString+';'+
        quAbsenceSelect.FieldByName('shortname').AsString+';'+ExtractWord(3,Old,[';']);
 finally
  mdActualTime.Post;
 end;
end;

procedure TfrmActualTime.GridActualTimeEditChange(Sender: TObject);
begin
 if not Assigned(GridActualTime.SelectedField.OnChange) then Exit;
 if Pos(';',GridActualTime.SelectedField.AsString)=0 then
 begin
  GridActualTime.SelectedField.OnChange:=nil;
  GridActualTime.SelectedField.DataSet.Edit;
  GridActualTime.SelectedField.AsString:=quAbsenceSelect.FieldByName('Absence_id').AsString+';'+
        quAbsenceSelect.FieldByName('shortname').AsString+';'+GridActualTime.SelectedField.AsString;
  GridActualTime.SelectedField.DataSet.Post;
  GridActualTime.SelectedField.OnChange:=mdActualTimeScheduleDateChange;
 end;
end;

procedure TfrmActualTime.Button5Click(Sender: TObject);
begin
 if Refreshing then Exit;
 ShowActualInfo(quEmpSelect.FieldByName('fname').AsString+' '+
          quEmpSelect.FieldByName('name').AsString+' '+
          quEmpSelect.FieldByName('sname').AsString,
  quEmpSelect.FieldByName('empplant_id').AsInteger,
  quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime,
  GelLastDateForCalendar(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger));
end;

procedure TfrmActualTime.PanelActualTimeResize(Sender: TObject);
begin
 try
  RxDBGrid1.Columns[0].Width:=RxDBGrid1.ClientWidth;
 except
 end;
end;

procedure TfrmActualTime.Button4Click(Sender: TObject);
var E,S:TRecordsIDs;
    I:Integer;
begin
 /////////////////////////////
 Exit;
 /////////////////////////////
 //Привер вызова функции заполнения табеля
 SetLength(E,1);
 SetLength(S,3);
 E[0]:=quEmpSelect.FieldByName('empplant_id').AsInteger;
 quShiftSelect.First;I:=0;
 while not quShiftSelect.EOF do
 begin
  S[I]:=quShiftSelect.FieldByName('shift_id').AsInteger;
  Inc(I);
  quShiftSelect.Next;
 end;
 FillActualTimePeriod(E,S,quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime,
  GelLastDateForCalendar(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger),
  quAbsenceSelect.FieldByName('Absence_id').AsInteger,0);
end;

procedure TfrmActualTime.ButtonCopyClick(Sender: TObject);
var E:TRecordsIDs;
begin
 //Привер вызова функции переноса нарм в факты
 SetLength(E,1);
 E[0]:=quEmpSelect.FieldByName('empplant_id').AsInteger;
 if CopyActualTimeFromNormalTime(E,quCalSelect.FieldByName(fldCalendarStartDate).AsDateTime,
  GelLastDateForCalendar(quCalSelect.FieldByName(fldCalendarCalendarID).AsInteger),
  quAbsenceSelect.FieldByName('Absence_id').AsInteger) then
  RecreateActualTimeGrid;
end;

end.


