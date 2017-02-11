unit CalExcept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, DBGrids, RXDBCtrl, Db, IBCustomDataSet,
  IBQuery, DBCtrls, IBDatabase, Placemnt;

type
  TfrmCalExcept = class(TForm)
    GridExcept: TRxDBGrid;
    PanelExceptEdit: TPanel;
    Panel1: TPanel;
    Bevel4: TBevel;
    ButtonExceptAdd: TButton;
    ButtonExceptDelete: TButton;
    ButtonExceptEdit: TButton;
    btnExceptGridColsSet: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ButtonClose: TButton;
    EditCurDate: TEdit;
    Label11: TLabel;
    EditCurWeek: TEdit;
    Label1: TLabel;
    quExceptSelect: TIBQuery;
    dsExceptSelect: TDataSource;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    LabelCount: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    FormStorage: TFormStorage;
    procedure ButtonExceptAddClick(Sender: TObject);
    procedure ButtonExceptDeleteClick(Sender: TObject);
    procedure ButtonExceptEditClick(Sender: TObject);
    procedure btnExceptGridColsSetClick(Sender: TObject);
    procedure GridExceptGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure ButtonCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
   WeekID:Integer;
   procedure DoRefresh;
  public
    { Public declarations }
  end;

procedure EditExcept(AYear:TDateTime;AWeek:String;AWeekID:Integer);

implementation

uses CalExceptEdit, StGridCols, UMainUnited, CalendarData, CalendarCode,
  CalendarEdit;

{$R *.DFM}

procedure EditExcept(AYear:TDateTime;AWeek:String;AWeekID:Integer);
var
  frmCalExcept: TfrmCalExcept;
begin
 frmCalExcept:=TfrmCalExcept.Create(Application);
 with frmCalExcept do
 try
  FormStorage.IniFileName:=_GetIniFileName;
  FormStorage.IniSection:='CalExceptEdit';
  FormStorage.Active:=True;

  WeekID:=AWeekID;
  ChangeDatabase(frmCalExcept,dbSTBasis);
  EditCurDate.Text:=FormatDateTime('dd mmmm yyyyг.',AYear);
  EditCurWeek.Text:=Aweek;
  DoRefresh;
  ShowModal;
 finally
  frmCalExcept.Release;
 end;
end;

procedure TfrmCalExcept.DoRefresh;
var C:Integer;
begin
 if quExceptSelect.Active then quExceptSelect.Close;
 try
  quExceptSelect.Open;
 except
 end;
 C:=GetRecordCount(quExceptSelect);
 LabelCount.Caption:=Format('Всего записей: %d',[C]);

 GridExcept.SelectedRows.Clear;
 GridExcept.SelectedRows.CurrentRowSelected:=True;

 ButtonExceptAdd.Enabled:=_isPermission(tbExcept,InsConst);
 ButtonExceptDelete.Enabled:=_isPermission(tbExcept,DelConst);
 ButtonExceptEdit.Enabled:=_isPermission(tbExcept,UpdConst);

end;

procedure TfrmCalExcept.ButtonExceptAddClick(Sender: TObject);
begin
 if AddCalendarExcept(EditCurWeek.Text,WeekID) then DoRefresh;
end;

procedure TfrmCalExcept.ButtonExceptDeleteClick(Sender: TObject);
begin
 if quExceptSelect.IsEmpty then Exit;
 if DeleteCalendarExcept(EditCurWeek.Text,quExceptSelect.FieldByName('dateexcept_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmCalExcept.ButtonExceptEditClick(Sender: TObject);
begin
 if quExceptSelect.IsEmpty then Exit;
 if EditCalendarExcept(EditCurWeek.Text,quExceptSelect.FieldByName('dateexcept_id').AsInteger) then DoRefresh;
end;

procedure TfrmCalExcept.btnExceptGridColsSetClick(Sender: TObject);
begin
 GridColumnsSetting('',GridExcept.Columns);
end;

procedure TfrmCalExcept.GridExceptGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var Index:Integer;
begin
 with Sender as TRxDBGrid do
 if SelectedRows.Find(Field.DataSet.Bookmark, Index) then
  if SelectedRows[Index]=Field.DataSet.Bookmark then
   SetSelectedRowParams(AFont,Background);
 with Sender as TRxDBGrid do
 if Highlight then
  if Field.DataSet.IsEmpty then Background:=Color else
   SetSelectedColParams(AFont,Background);
end;

procedure TfrmCalExcept.ButtonCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmCalExcept.Button1Click(Sender: TObject);
begin
 DoRefresh;
end;

end.

