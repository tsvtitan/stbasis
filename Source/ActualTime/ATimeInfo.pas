unit ATimeInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Db, RxMemDS, Grids, DBGrids, RXDBCtrl, IBDatabase,
  IBCustomDataSet, IBQuery, StdCtrls, ExtCtrls;

type
  TftmATimeInfo = class(TForm)
    mdInfo: TRxMemoryData;
    mdInfoAbsenceName: TStringField;
    GridInfo: TRxDBGrid;
    dsInfo: TDataSource;
    mdInfoCommonSumma: TFloatField;
    quShiftSelect: TIBQuery;
    trRead: TIBTransaction;
    quAbsenceSelect: TIBQuery;
    Panel1: TPanel;
    ButtonRefresh: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mdInfoCalcFields(DataSet: TDataSet);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure GridInfoGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridInfoTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
  private
    FEmpPlant_id:Integer;
    FStartDate,FEndDate:TDateTime;
    procedure DoUpdate;
  public
  end;

procedure ShowActualInfo(EmpName:String;EmpPlant_id:Integer;StartDate,EndDate:TDateTime);
procedure HideActualInfo;

implementation

{$R *.DFM}

uses UMainUnited, CalendarData, StCalendarUtil;

var ftmATimeInfo:TftmATimeInfo;

procedure ShowActualInfo(EmpName:String;EmpPlant_id:Integer;StartDate,EndDate:TDateTime);
begin
 if ftmATimeInfo=nil then
  ftmATimeInfo:=TftmATimeInfo.Create(Application);
 if ftmATimeInfo<>nil then
 begin
  ftmATimeInfo.Label2.Caption:=EmpName;
  ftmATimeInfo.FEmpPlant_id:=EmpPlant_id;
  ftmATimeInfo.FStartDate:=StartDate;
  ftmATimeInfo.FEndDate:=EndDate;
  ftmATimeInfo.DoUpdate;
  ftmATimeInfo.Show;
 end;
end;

procedure HideActualInfo;
begin
 if ftmATimeInfo<>nil then
 begin
  ftmATimeInfo.Free;
  ftmATimeInfo:=nil;
 end;
end;

procedure TftmATimeInfo.DoUpdate;
var A:Integer;
    F1:TFloatField;
    IDs1,IDs2:TRecordsIDs;
begin
 if quShiftSelect.Active then quShiftSelect.Close;
 if quAbsenceSelect.Active then quAbsenceSelect.Close;
 try
  quShiftSelect.Open;
  quAbsenceSelect.Open;
 except
  Exit;
 end;
 mdInfo.DisableControls;
 mdInfo.EmptyTable;
 mdInfo.Close;
 try
  for A:=mdInfo.Fields.Count downto 1 do
   if mdInfo.Fields[A-1].Tag>0 then mdInfo.Fields[A-1].Free;
  GridInfo.Columns.RebuildColumns;

  quShiftSelect.First;A:=1;
  while not quShiftSelect.EOF do
  begin
   F1:=TFloatField.Create(mdInfo);
   F1.Name:='mdInfoShift'+quShiftSelect.FieldByName(fldShiftShiftID).AsString;
   F1.DisplayLabel:=quShiftSelect.FieldByName(fldShiftName).AsString;
   F1.FieldKind:=fkData;
   F1.FieldName:='Shift'+IntToStr(A);
   F1.DataSet:=mdInfo;
   F1.Tag:=quShiftSelect.FieldByName(fldShiftShiftID).AsInteger;

   quShiftSelect.Next;
   Inc(A);
  end;

  GridInfo.Columns.RebuildColumns;

  for A:=1 to GridInfo.Columns.Count do
   if UpperCase(GridInfo.Columns[A-1].Field.FullName)='ABSENCENAME' then
    GridInfo.Columns[A-1].Width:=200;
    
  for A:=1 to GridInfo.Columns.Count do
   if UpperCase(GridInfo.Columns[A-1].Field.FullName)='COMMONSUMMA' then
   begin
    GridInfo.Columns[A-1].Index:=GridInfo.Columns.Count-1;
    Break;
   end;

 except
 end;
 try
  mdInfo.Open;
 except
 end;

 SetLength(IDs1,1);
 SetLength(IDs2,1);

 try
  quAbsenceSelect.First;
  while not quAbsenceSelect.EOF do
  begin
   mdInfo.Append;
   mdInfo.FieldByName('AbsenceName').AsString:=quAbsenceSelect.FieldByName('name').AsString;
   for A:=1 to mdInfo.Fields.Count do
    if mdInfo.Fields[A-1].Tag>0 then
    begin
     IDs1[0]:=quAbsenceSelect.FieldByName('absence_id').AsInteger;
     IDs2[0]:=mdInfo.Fields[A-1].Tag;
     mdInfo.Fields[A-1].AsFloat:=GetActualTime(FEmpPlant_ID,IDs1,IDs2,FStartDate,FEndDate,True);
    end;
   mdInfo.Post;
   quAbsenceSelect.Next;
  end;
 except
 end;

 if not mdInfo.IsEmpty then mdInfo.First;
 mdInfo.EnableControls;
end;

procedure TftmATimeInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TftmATimeInfo.FormDestroy(Sender: TObject);
begin
 ftmATimeInfo:=nil;
end;

procedure TftmATimeInfo.FormCreate(Sender: TObject);
begin
 ChangeDatabase(Self,dbSTBasis);
 AssignFont(_GetOptions.RBTableFont,GridInfo.Font);
 GridInfo.TitleFont.Assign(GridInfo.Font);
end;

procedure TftmATimeInfo.mdInfoCalcFields(DataSet: TDataSet);
var A:Integer;
    S:Double;
begin
 S:=0;
 for A:=1 to DataSet.Fields.Count do
  if DataSet.Fields[A-1].Tag>0 then
   S:=S+DataSet.Fields[A-1].AsFloat;
 DataSet.FieldByName('CommonSumma').AsFloat:=S;
end;

procedure TftmATimeInfo.ButtonRefreshClick(Sender: TObject);
begin
 DoUpdate;
end;

procedure TftmATimeInfo.GridInfoGetCellParams(Sender: TObject;
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

procedure TftmATimeInfo.GridInfoTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
begin
 mdInfo.SortOnFields(Field.FullName);
end;

end.
