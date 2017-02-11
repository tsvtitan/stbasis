unit CalendarForm;

interface

uses
  Windows, Forms, Grids, DBGrids, StdCtrls, Classes, Controls, ExtCtrls,
  ComCtrls, RXDBCtrl, DBCtrls, Db, IBDatabase, IBCustomDataSet, IBQuery,
  Placemnt, Graphics;

type
  TfrmCalendar = class(TForm)
    PanelTop: TPanel;
    btnCalNew: TButton;
    btnCalDelete: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    PanelWeek: TPanel;
    ButtonWeekAdd: TButton;
    ButtonWeekDelete: TButton;
    ButtonWeekEdit: TButton;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    ButtonHolidayAdd: TButton;
    ButtonHolidayDelete: TButton;
    ButtonHolidayEdit: TButton;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    ButtonCarryAdd: TButton;
    ButtonCarryDelete: TButton;
    ButtonCarryEdit: TButton;
    TabSheet4: TTabSheet;
    Panel5: TPanel;
    ButtonExceptAdd: TButton;
    ButtonExceptDelete: TButton;
    ButtonExceptEdit: TButton;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GridYear: TRxDBGrid;
    GridExcept: TRxDBGrid;
    GridWeek: TRxDBGrid;
    GridHoliday: TRxDBGrid;
    GridCarry: TRxDBGrid;
    btnRefresh: TButton;
    PanelBottom: TPanel;
    PanelClose: TPanel;
    btnClose: TButton;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    Splitter: TSplitter;
    quYearSelect: TIBQuery;
    dsYearSelect: TDataSource;
    trRead: TIBTransaction;
    FormStorage: TFormStorage;
    quWeekSelect: TIBQuery;
    dsWeekSelect: TDataSource;
    quYearDelete: TIBQuery;
    trWrite: TIBTransaction;
    quHolidaySelect: TIBQuery;
    dsHolidaySelect: TDataSource;
    quHolidaySelectholiday: TDateField;
    quHolidaySelectname: TStringField;
    dsCarrySelect: TDataSource;
    quCarrySelect: TIBQuery;
    quExceptSelect: TIBQuery;
    dsExceptSelect: TDataSource;
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
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCalNewClick(Sender: TObject);
    procedure GridYearTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure GridYearCheckButton(Sender: TObject; ACol: Integer;
      Field: TField; var Enabled: Boolean);
    procedure GridYearGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    procedure btnCalDeleteClick(Sender: TObject);
    procedure ButtonWeekAddClick(Sender: TObject);
    procedure ButtonWeekDeleteClick(Sender: TObject);
    procedure ButtonWeekEditClick(Sender: TObject);
    procedure ButtonHolidayAddClick(Sender: TObject);
    procedure ButtonHolidayDeleteClick(Sender: TObject);
    procedure ButtonHolidayEditClick(Sender: TObject);
    procedure ButtonCarryAddClick(Sender: TObject);
    procedure ButtonCarryDeleteClick(Sender: TObject);
    procedure ButtonCarryEditClick(Sender: TObject);
    procedure ButtonExceptAddClick(Sender: TObject);
    procedure ButtonExceptDeleteClick(Sender: TObject);
    procedure ButtonExceptEditClick(Sender: TObject);
  private
    { Private declarations }
   procedure ChangeDatabase(DB:TIBDatabase);
   function GetYearOrder:Integer;
   procedure SetYearOrder(const AYearOrder:Integer);
  public
    { Public declarations }
   procedure DoRefresh;
   property YearOrder:Integer read GetYearOrder write SetYearOrder;
  end;

var
  frmCalendar: TfrmCalendar;

implementation

uses SysUtils, CalendarCode, CalendarConst, CalendarNew, CalWeekEdit,
  CalHolidayEdit, CalCarryEdit, CalExceptEdit;

{$R *.DFM}

procedure TfrmCalendar.ChangeDatabase(DB:TIBDatabase);
var I:Integer;
begin
 try
  for I:=1 to ComponentCount do
   if Components[I-1] is TIBTransaction then
   with Components[I-1] as TIBTransaction do DefaultDatabase:=DB;
 except
 end;
 try
  for I:=1 to ComponentCount do
   if Components[I-1] is TIBCustomDataSet then
   with Components[I-1] as TIBCustomDataSet do Database:=DB;
 except
 end;
end;

function TfrmCalendar.GetYearOrder:Integer;
begin
 try
  Result:=FormStorage.StoredValue['YearOrder'];
 except
  Result:=0;
 end;
end;

procedure TfrmCalendar.SetYearOrder(const AYearOrder:Integer);
begin
 try
  FormStorage.StoredValue['YearOrder']:=AYearOrder;
  DoRefresh;
 except
 end;
end;

procedure TfrmCalendar.DoRefresh;
var TempStr:String;
begin
 if quYearSelect.Active then quYearSelect.Close;
 case YearOrder of
  0:TempStr:='';
  1:TempStr:='ORDER BY FYEAR ASC';
  2:TempStr:='ORDER BY FYEAR DESC';
 end;
 quYearSelect.SQL.Text:='SELECT FYEAR_ID,FYEAR FROM FYEAR '+TempStr;

 if quWeekSelect.Active then quWeekSelect.Close;

 if quHolidaySelect.Active then quHolidaySelect.Close;

 if quCarrySelect.Active then quCarrySelect.Close;

 if quExceptSelect.Active then quExceptSelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quYearSelect.Open;
  quWeekSelect.Open;
  quHolidaySelect.Open;
  quCarrySelect.Open;
  quExceptSelect.Open;

  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
 end;
end;

procedure TfrmCalendar.FormDestroy(Sender: TObject);
begin
 inherited;
 frmCalendar:=nil;
end;

procedure TfrmCalendar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfrmCalendar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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

procedure TfrmCalendar.FormCreate(Sender: TObject);
begin
 ChangeDatabase(dbSTBasis);
 FormStorage.IniFileName:=_GetIniFileName;
 FormStorage.IniSection:='Calendar';
 FormStorage.Active:=True;
end;

procedure TfrmCalendar.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmCalendar.CommonGridEnter(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=TCustomDBGrid(Sender).DataSource;
end;

procedure TfrmCalendar.CommonGridExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
end;

procedure TfrmCalendar.btnRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmCalendar.btnCalNewClick(Sender: TObject);
var CurDate:TDateTime;
begin
 if quYearSelect.IsEmpty then CurDate:=0 else CurDate:=quYearSelect.FieldByName('fyear').AsDateTime;
 if NewCalendar(CurDate) then DoRefresh;
end;

procedure TfrmCalendar.GridYearTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
begin
 if AnsiUpperCase(Field.FullName)='FYEAR' then
  if YearOrder=2 then YearOrder:=0 else YearOrder:=YearOrder+1;
end;

procedure TfrmCalendar.GridYearCheckButton(Sender: TObject; ACol: Integer;
  Field: TField; var Enabled: Boolean);
begin
 Enabled:=AnsiUpperCase(Field.FullName)='FYEAR';
end;

procedure TfrmCalendar.GridYearGetBtnParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
  IsDown: Boolean);
begin
 if AnsiUpperCase(Field.FullName)='FYEAR' then
 case YearOrder of
  0:SortMarker:=smNone;
  1:SortMarker:=smDown;
  2:SortMarker:=smUp;
 end;
end;

procedure TfrmCalendar.btnCalDeleteClick(Sender: TObject);
begin
 if quYearSelect.IsEmpty then Exit;
 if Application.MessageBox(PChar(FormatDateTime('Будет произведена попытка удаления календаря. Данное действие невозможно выполнить для информации находящейся в работе.'#10'Попытаться удалить календарь от dd mmmm yyyyг. ?',quYearSelect.FieldByName('fyear').AsDateTime)),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
 begin
  quYearDelete.ParamByName('id').AsInteger:=quYearSelect.FieldByName('fyear_id').AsInteger;
  if not trWrite.InTransaction then trWrite.StartTransaction;
  try
   quYearDelete.ExecSQL;
   trWrite.CommitRetaining;
   DoRefresh;
  except
   trWrite.RollbackRetaining;
  end;
 end;
end;

procedure TfrmCalendar.ButtonWeekAddClick(Sender: TObject);
begin
 AddCalendarWeek;
end;

procedure TfrmCalendar.ButtonWeekDeleteClick(Sender: TObject);
begin
 DeleteCalendarWeek;
end;

procedure TfrmCalendar.ButtonWeekEditClick(Sender: TObject);
begin
 EditCalendarWeek;
end;

procedure TfrmCalendar.ButtonHolidayAddClick(Sender: TObject);
begin
 AddCalendarHoliday;
end;

procedure TfrmCalendar.ButtonHolidayDeleteClick(Sender: TObject);
begin
 DeleteCalendarHoliday;
end;

procedure TfrmCalendar.ButtonHolidayEditClick(Sender: TObject);
begin
 EditCalendarHoliday;
end;

procedure TfrmCalendar.ButtonCarryAddClick(Sender: TObject);
begin
 AddCalendarCarry;
end;

procedure TfrmCalendar.ButtonCarryDeleteClick(Sender: TObject);
begin
 DeleteCalendarCarry;
end;

procedure TfrmCalendar.ButtonCarryEditClick(Sender: TObject);
begin
 EditCalendarCarry;
end;

procedure TfrmCalendar.ButtonExceptAddClick(Sender: TObject);
begin
 AddCalendarExcept;
end;

procedure TfrmCalendar.ButtonExceptDeleteClick(Sender: TObject);
begin
 DeleteCalendarExcept;
end;

procedure TfrmCalendar.ButtonExceptEditClick(Sender: TObject);
begin
 EditCalendarExcept;
end;

end.
