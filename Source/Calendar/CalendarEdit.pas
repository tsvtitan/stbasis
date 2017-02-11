unit CalendarEdit;

{$I stbasis.inc}

interface

uses
  Windows, Forms, Grids, DBGrids, StdCtrls, Classes, Controls, ExtCtrls,
  ComCtrls, RXDBCtrl, DBCtrls, Db, IBDatabase, IBCustomDataSet, IBQuery,
  Placemnt, Graphics, CalendarCode, UMainUnited;

type
  TfrmCalendar = class(TForm)
    PanelTop: TPanel;
    btnCalNew: TButton;
    btnCalDelete: TButton;
    PageControl: TPageControl;
    TabSheet2: TTabSheet;
    PanelHolidayEdit: TPanel;
    ButtonHolidayAdd: TButton;
    ButtonHolidayDelete: TButton;
    ButtonHolidayEdit: TButton;
    TabSheet3: TTabSheet;
    PanelCarryEdit: TPanel;
    ButtonCarryAdd: TButton;
    ButtonCarryDelete: TButton;
    ButtonCarryEdit: TButton;
    GridCalendar: TRxDBGrid;
    GridHoliday: TRxDBGrid;
    GridCarry: TRxDBGrid;
    ButtonRefresh: TButton;
    PanelBottom: TPanel;
    PanelClose: TPanel;
    btnClose: TButton;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    Splitter: TSplitter;
    quCalendarSelect: TIBQuery;
    dsCalendarSelect: TDataSource;
    trRead: TIBTransaction;
    quCalendarDelete: TIBQuery;
    trWrite: TIBTransaction;
    quHolidaySelect: TIBQuery;
    dsHolidaySelect: TDataSource;
    dsCarrySelect: TDataSource;
    quCarrySelect: TIBQuery;
    quHolidaySelectname: TStringField;
    quCalendarSelectcalendar_id: TIntegerField;
    quCalendarSelectstartdate: TDateField;
    LabelCount: TLabel;
    PanelOKCancel: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quHolidaySelectholiday: TDateField;
    quHolidaySelectholiday_id: TIntegerField;
    PanelSelecting: TPanel;
    ButtonRefreshSel: TButton;
    btnGridColsSet: TButton;
    btnHolidayGridColsSet: TButton;
    btnCarryGridColsSet: TButton;
    quCalendarSelectHolidaysAddPayPercent: TIntegerField;
    ButtonRefreshHoliday: TButton;
    ButtonRefreshCarry: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure CommonGridEnter(Sender: TObject);
    procedure CommonGridExit(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure btnCalNewClick(Sender: TObject);
    procedure GridCalendarTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure GridCalendarCheckButton(Sender: TObject; ACol: Integer;
      Field: TField; var Enabled: Boolean);
    procedure GridCalendarGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure btnCalDeleteClick(Sender: TObject);
    procedure ButtonHolidayAddClick(Sender: TObject);
    procedure ButtonHolidayDeleteClick(Sender: TObject);
    procedure ButtonHolidayEditClick(Sender: TObject);
    procedure ButtonCarryAddClick(Sender: TObject);
    procedure ButtonCarryDeleteClick(Sender: TObject);
    procedure ButtonCarryEditClick(Sender: TObject);
    procedure CommonAfterScroll(DataSet: TDataSet);
    procedure CommonGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure btnWeekGridColsSetClick(Sender: TObject);
    procedure GridCalendarDblClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   CalendarAction:TCalendarAction;
   CalendarParams:PParamRBookInterface;
   FirstActive:Boolean;
   FhInterface: THandle;
   FCalendarOrder:Integer;
   Refreshing:Boolean;
   DefaultCalendarSelectStr:String;
   function GetCalendarOrder:Integer;
   procedure SetCalendarOrder(const ACalendarOrder:Integer);
   property CalendarOrder:Integer read GetCalendarOrder write SetCalendarOrder;
  public
   constructor Create(AOwner: TComponent;AhInterface: THandle;ACalendarAction:TCalendarAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmCalendar: TfrmCalendar;

implementation

uses TypInfo, SysUtils, CalendarData, CalendarNew, CalHolidayEdit, CalCarryEdit,
     UAdjust;

{$R *.DFM}

constructor TfrmCalendar.Create(AOwner: TComponent;AhInterface: THandle;ACalendarAction:TCalendarAction;AParams:PParamRBookInterface);
var I:Integer;
begin
 CalendarAction:=ACalendarAction;
 CalendarParams:=AParams;
 FirstActive:=True;
 FhInterface:=AhInterface;
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridCalendar.Font);
 GridCalendar.TitleFont.Assign(GridCalendar.Font);
 AssignFont(_GetOptions.RBTableFont,GridHoliday.Font);
 GridHoliday.TitleFont.Assign(GridHoliday.Font);
 AssignFont(_GetOptions.RBTableFont,GridCarry.Font);
 GridCarry.TitleFont.Assign(GridCarry.Font);

 if CalendarAction=caCalendarEdit then begin
   _OnVisibleInterface(FhInterface,True);
   Caption:=FormCaptionCalendarEdit;
   PanelSelecting.Visible:=False;
   ButtonRefreshHoliday.Visible:=False;
   ButtonRefreshCarry.Visible:=False;
   FormStyle:=fsMDIChild;
  end
 else begin
  case CalendarAction of
   caCalendarSelect:Caption:=FormCaptionCalendarSelect;
   caHolidaySelect:Caption:=FormCaptionHolidaySelect;
   caCarrySelect:Caption:=FormCaptionCarrySelect;
  end;
  if CalendarAction=caCalendarSelect then
  begin
   PageControl.Visible:=False;
   GridCalendar.Align:=alClient;
  end else GridCalendar.Visible:=False;

  PanelTop.Visible:=False;
  Splitter.Visible:=False;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  for I:=1 to PageControl.PageCount do
   PageControl.Pages[I-1].TabVisible:=False;

  PanelHolidayEdit.Visible:=_GetOptions.isEditRBOnSelect;
  PanelCarryEdit.Visible:=_GetOptions.isEditRBOnSelect;
  PanelSelecting.Visible:=(not _GetOptions.isEditRBOnSelect) or (CalendarAction=caCalendarSelect);

  case CalendarAction of
   caHolidaySelect:PageControl.Pages[0].TabVisible:=True;
   caCarrySelect:PageControl.Pages[1].TabVisible:=True;
  end;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmCalendar.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 case CalendarAction of
  caCalendarEdit,caCalendarSelect:
   DefaultCalendarSelectStr:='select calendar_id,startdate,HolidaysAddPayPercent from calendar ';
  else begin
   DefaultCalendarSelectStr:='select calendar_id,startdate,HolidaysAddPayPercent from calendar where calendar_id=:calendar_id ';
  end;
 end;

 DoRefresh;

 case CalendarAction of
  caCalendarSelect:begin
   if CalendarParams<>nil then
    with CalendarParams.Locate do
     if KeyFields<>nil then
      quCalendarSelect.Locate(KeyFields,KeyValues,Options);
  end;  
  caHolidaySelect:begin
   if not quCalendarSelect.IsEmpty then
    PageControl.Pages[0].Caption:=Format('Праздники календаря от %s',[FormatDateTime('dd mmmm yyyyг.',quCalendarSelect.FieldByName('startdate').AsDateTime)]);
   if CalendarParams<>nil then
    with CalendarParams.Locate do
     if KeyFields<>nil then
      quHolidaySelect.Locate(KeyFields,KeyValues,Options);
  end;
  caCarrySelect:begin
   if not quCalendarSelect.IsEmpty then
    PageControl.Pages[1].Caption:=Format('Переносы календаря от %s',[FormatDateTime('dd mmmm yyyyг.',quCalendarSelect.FieldByName('startdate').AsDateTime)]);
   if CalendarParams<>nil then
    with CalendarParams.Locate do
     if KeyFields<>nil then
      quCarrySelect.Locate(KeyFields,KeyValues,Options);
  end;
 end;
end;

function TfrmCalendar.GetCalendarOrder:Integer;
begin
 Result:=FCalendarOrder;
end;

procedure TfrmCalendar.SetCalendarOrder(const ACalendarOrder:Integer);
begin
 FCalendarOrder:=ACalendarOrder;
 DoRefresh;
end;

procedure TfrmCalendar.DoRefresh;
var TempStr:String;
    I:Integer;
    LastCalendar,LastHoliday,LastCarry:String;
begin
 Refreshing:=True;

 LastCalendar:=quCalendarSelect.Bookmark;
 LastHoliday:=quHolidaySelect.Bookmark;
 LastCarry:=quCarrySelect.Bookmark;

 if quCalendarSelect.Active then quCalendarSelect.Close;
 quCalendarSelect.SQL.Text:=DefaultCalendarSelectStr;
 case CalendarOrder of
  0:TempStr:='';
  1:TempStr:=' order by startdate asc';
  2:TempStr:=' order by startdate desc';
 end;
 if CalendarAction=caCalendarEdit then
  quCalendarSelect.SQL.Text:=quCalendarSelect.SQL.Text+TempStr;

//Exec for all modal action
{ if CalendarParams<>nil then
  case CalendarAction of
   caHolidaySelect:quCalendarSelect.ParamByName(fldCalendarCalendarID).AsInteger:=PHolidayParams(CalendarParams)^.Calendar_ID;
   caCarrySelect:quCalendarSelect.ParamByName(fldCalendarCalendarID).AsInteger:=PCarryParams(CalendarParams)^.Calendar_ID;
  end;}

 if quHolidaySelect.Active then quHolidaySelect.Close;

 if quCarrySelect.Active then quCarrySelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quCalendarSelect.Open;
  Application.ProcessMessages;

  if CalendarAction in [caCalendarEdit,caHolidaySelect] then
  begin
   quHolidaySelect.Open;
   Application.ProcessMessages;
  end;
  if CalendarAction in [caCalendarEdit,caCarrySelect] then
  begin
   quCarrySelect.Open;
   Application.ProcessMessages;
  end;

  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quCalendarSelect.Bookmark:=LastCalendar;
  quHolidaySelect.Bookmark:=LastHoliday;
  quCarrySelect.Bookmark:=LastCarry;
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

  btnCalNew.Enabled:=_isPermission(tbCalendar,InsConst);
  btnCalDelete.Enabled:=_isPermission(tbCalendar,DelConst);

  ButtonHolidayAdd.Enabled:=_isPermission(tbHoliday,InsConst);
  ButtonHolidayDelete.Enabled:=_isPermission(tbHoliday,DelConst);
  ButtonHolidayEdit.Enabled:=_isPermission(tbHoliday,UpdConst);

  ButtonCarryAdd.Enabled:=_isPermission(tbCarry,InsConst);
  ButtonCarryDelete.Enabled:=_isPermission(tbCarry,DelConst);
  ButtonCarryEdit.Enabled:=_isPermission(tbCarry,UpdConst);

 case CalendarAction of
  caCalendarSelect:ButtonOK.Enabled:=not quCalendarSelect.IsEmpty;
  caHolidaySelect:ButtonOK.Enabled:=not quHolidaySelect.IsEmpty;
  caCarrySelect:ButtonOK.Enabled:=not quCarrySelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmCalendar.FormDestroy(Sender: TObject);
begin
 if CalendarAction=caCalendarEdit then frmCalendar:=nil;
 _OnVisibleInterface(FhInterface,false);
end;

procedure TfrmCalendar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if CalendarAction=caCalendarEdit then Action:=caFree else
 if (ModalResult=mrOK) and (CalendarParams<>nil) then
 case CalendarAction of
  caCalendarSelect:begin
   ReturnModalParamsFromDataSetAndGrid(quCalendarSelect,GridCalendar,CalendarParams);
  end;
  caHolidaySelect:begin
   ReturnModalParamsFromDataSetAndGrid(quHolidaySelect,GridHoliday,CalendarParams);
  end;
  caCarrySelect:begin
   ReturnModalParamsFromDataSetAndGrid(quCarrySelect,GridCarry,CalendarParams);
  end;
 end;
 Application.Hint:='';
end;

function IsChildFocused(C:TWinControl):Boolean;
var A:Integer;
begin
 Result:=False;
 for A:=1 to C.ControlCount do
  if (C.Controls[A-1] is TWinControl) and (TWinControl(C.Controls[A-1]).Focused) then
  begin
   Result:=True;
   Break;
  end;
end;

procedure TfrmCalendar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Shift=[]) and (CalendarAction=caCalendarEdit) then
 case Key of
  VK_F2:if (GridCalendar.Focused or IsChildFocused(PanelTop)) and btnCalNew.Enabled then btnCalNew.Click else
         if (GridHoliday.Focused or IsChildFocused(PanelHolidayEdit)) and ButtonHolidayAdd.Enabled then ButtonHolidayAdd.Click else
          if (GridCarry.Focused or IsChildFocused(PanelCarryEdit)) and ButtonCarryAdd.Enabled then ButtonCarryAdd.Click;
  VK_F3:if (GridHoliday.Focused or IsChildFocused(PanelHolidayEdit)) and ButtonHolidayEdit.Enabled then ButtonHolidayEdit.Click else
          if (GridCarry.Focused or IsChildFocused(PanelCarryEdit)) and ButtonCarryEdit.Enabled then ButtonCarryEdit.Click;
  VK_F4:if (GridCalendar.Focused or IsChildFocused(PanelTop)) and btnCalDelete.Enabled then btnCalDelete.Click else
         if (GridHoliday.Focused or IsChildFocused(PanelHolidayEdit)) and ButtonHolidayDelete.Enabled then ButtonHolidayDelete.Click else
          if (GridCarry.Focused or IsChildFocused(PanelCarryEdit)) and ButtonCarryDelete.Enabled then ButtonCarryDelete.Click;
  VK_F5:ButtonRefresh.Click;
  VK_F6:;
  VK_F7:;
  VK_F8:btnHolidayGridColsSet.Click;
 end;
 _MainFormKeyDown(Key,Shift);
end;

procedure TfrmCalendar.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmCalendar.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmCalendar.btnCloseClick(Sender: TObject);
begin
 if CalendarAction<>caCalendarEdit then Exit;
 Close;
end;

procedure TfrmCalendar.CommonGridEnter(Sender: TObject);
var C:Integer;
begin
 if Sender is TCustomDBGrid then
 begin
  DBNavigator.DataSource:=TCustomDBGrid(Sender).DataSource;
  if TCustomDBGrid(Sender).DataSource.DataSet is TIBQuery then
   C:=GetRecordCount(TCustomDBGrid(Sender).DataSource.DataSet as TIBQuery)
  else C:=0;
  LabelCount.Enabled:=True;
  LabelCount.Caption:=ViewCountText+Format('%d',[C]);
 end;
end;

procedure TfrmCalendar.CommonGridExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmCalendar.ButtonRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmCalendar.btnCalNewClick(Sender: TObject);
var CurID:Integer;
begin
 if CalendarAction<>caCalendarEdit then Exit;
 if quCalendarSelect.IsEmpty then CurID:=-1 else CurID:=quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger;
 if NewCalendar(CurID) then DoRefresh;
end;

procedure TfrmCalendar.GridCalendarTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
begin
 if AnsiUpperCase(Field.FullName)=AnsiUpperCase(fldCalendarStartDate) then
  if CalendarOrder=2 then CalendarOrder:=0 else CalendarOrder:=CalendarOrder+1;
end;

procedure TfrmCalendar.GridCalendarCheckButton(Sender: TObject; ACol: Integer;
  Field: TField; var Enabled: Boolean);
begin
 Enabled:=AnsiUpperCase(Field.FullName)=AnsiUpperCase(fldCalendarStartDate);
end;

procedure TfrmCalendar.GridCalendarGetBtnParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
  IsDown: Boolean);
begin
 if AnsiUpperCase(Field.FullName)=AnsiUpperCase(fldCalendarStartDate) then
 case CalendarOrder of
  0:SortMarker:=TSortMarker(smNone);
  1:SortMarker:=smDown;
  2:SortMarker:=smUp;
 end;
end;

procedure TfrmCalendar.btnCalDeleteClick(Sender: TObject);
begin
 if CalendarAction<>caCalendarEdit then Exit;
 if quCalendarSelect.IsEmpty then Exit;
 if Application.MessageBox(PChar(FormatDateTime('Удалить календарь от dd mmmm yyyyг. ?',quCalendarSelect.FieldByName('startdate').AsDateTime)),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
 begin
  quCalendarDelete.ParamByName('id').AsInteger:=quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger;
  if not trWrite.InTransaction then trWrite.StartTransaction;
  try
   quCalendarDelete.ExecSQL;
   trWrite.Commit;
   DoRefresh;
  except
   trWrite.Rollback;
  end;
 end;
end;

procedure TfrmCalendar.ButtonHolidayAddClick(Sender: TObject);
begin
 if quCalendarSelect.IsEmpty then Exit;
 if AddCalendarHoliday(quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger) then
  DoRefresh;
end;

procedure TfrmCalendar.ButtonHolidayDeleteClick(Sender: TObject);
begin
 if quCalendarSelect.IsEmpty or quHolidaySelect.IsEmpty then Exit;
 if DeleteCalendarHoliday(quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger,quHolidaySelect.FieldByName(fldHolidayHolidayID).AsInteger) then
  DoRefresh;
end;

procedure TfrmCalendar.ButtonHolidayEditClick(Sender: TObject);
begin
 if (CalendarAction=caCalendarEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONHOLIDAYEDIT') then
 begin
  if quCalendarSelect.IsEmpty or quHolidaySelect.IsEmpty or (not ButtonHolidayEdit.Enabled) then Exit;
  if EditCalendarHoliday(quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger,quHolidaySelect.FieldByName(fldHolidayHolidayID).AsInteger) then
   DoRefresh;
 end else
 if (CalendarAction=caHolidaySelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmCalendar.ButtonCarryAddClick(Sender: TObject);
begin
 if quCalendarSelect.IsEmpty then Exit;
 if AddCalendarCarry(quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger) then
  DoRefresh;
end;

procedure TfrmCalendar.ButtonCarryDeleteClick(Sender: TObject);
begin
 if quCalendarSelect.IsEmpty or quCarrySelect.IsEmpty then Exit;
 if DeleteCalendarCarry(quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger,quCarrySelect.FieldByName(fldCarryCarryID).AsInteger) then
  DoRefresh;
end;

procedure TfrmCalendar.ButtonCarryEditClick(Sender: TObject);
begin
 if (CalendarAction=caCalendarEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONCARRYEDIT') then
 begin
  if quCalendarSelect.IsEmpty or quCarrySelect.IsEmpty or (not ButtonCarryEdit.Enabled) then Exit;
  if EditCalendarCarry(quCalendarSelect.FieldByName(fldCalendarCalendarID).AsInteger,quCarrySelect.FieldByName(fldCarryCarryID).AsInteger) then
   DoRefresh;
 end else
 if (CalendarAction=caCarrySelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmCalendar.CommonAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridCalendar.DataSource.DataSet.Active then
     begin
      GridCalendar.SelectedRows.Clear;
      GridCalendar.SelectedRows.CurrentRowSelected:=True;
     end;
     if GridHoliday.DataSource.DataSet.Active then
     begin
      GridHoliday.SelectedRows.Clear;
      GridHoliday.SelectedRows.CurrentRowSelected:=True;
     end;
     if GridCarry.DataSource.DataSet.Active then
     begin
      GridCarry.SelectedRows.Clear;
      GridCarry.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmCalendar.CommonGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var Index:Integer;
begin
 with Sender as TRxDBGrid do
 try
 if SelectedRows.Find(Field.DataSet.Bookmark, Index) then
  if SelectedRows[Index]=Field.DataSet.Bookmark then
   SetSelectedRowParams(AFont,Background);
 except
 end;
 with Sender as TRxDBGrid do
 if Highlight then
  if Field.DataSet.IsEmpty then Background:=Color else
   SetSelectedColParams(AFont,Background);
end;

procedure TfrmCalendar.btnWeekGridColsSetClick(Sender: TObject);
begin
 case CalendarAction of
  caCalendarEdit:case TComponent(Sender).Tag of
                  1:SetAdjustColumns(GridHoliday.Columns);
                  2:SetAdjustColumns(GridCarry.Columns);
                 end;
  caCalendarSelect:SetAdjustColumns(GridCalendar.Columns);
  caHolidaySelect:SetAdjustColumns(GridHoliday.Columns);
  caCarrySelect:SetAdjustColumns(GridCarry.Columns);
 end;
end;

procedure TfrmCalendar.GridCalendarDblClick(Sender: TObject);
begin
 if (CalendarAction=caCalendarSelect) and ButtonOK.Enabled then ButtonOK.Click;
end;

procedure TfrmCalendar.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridCalendar.Columns);
 SetMinColumnsWidth(GridHoliday.Columns);
 SetMinColumnsWidth(GridCarry.Columns);
end;

end.

