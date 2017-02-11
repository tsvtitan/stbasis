unit OTIZSeatClass;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, autotree, dbtree, StdCtrls, Grids, DBGrids, RXDBCtrl,
  DBCtrls, Placemnt, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmSeatClass = class(TForm)
    TreeDepart: TDBTreeView;
    PanelBottom: TPanel;
    Splitter1: TSplitter;
    PanelTop: TPanel;
    PanelRight: TPanel;
    Label1: TLabel;
    EditSearch: TEdit;
    ButtonAdd: TButton;
    ButtonEdit: TButton;
    ButtonDelete: TButton;
    ButtonRefresh: TButton;
    ButtonSetup: TButton;
    PanelClose: TPanel;
    ButtonClose: TButton;
    LabelCount: TLabel;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    quDepartSelect: TIBQuery;
    dsDepart: TDataSource;
    trRead: TIBTransaction;
    trWrite: TIBTransaction;
    quSeatClassSelect: TIBQuery;
    dsSeatClassSelect: TDataSource;
    FormStorage: TFormStorage;
    GridSeatClass: TRxDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure GridSeatClassEnter(Sender: TObject);
    procedure GridSeatClassExit(Sender: TObject);
    procedure GridSeatClassGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure CommontAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
  private
    { Private declarations }
   Refreshing:Boolean;
   function GetLastDepart:String;
   procedure SetLastDepart(L:String);
   function GetLastSeatClass:String;
   procedure SetLastSeatClass(L:String);
   property LastDepart:String read GetLastDepart write SetLastDepart;
   property LastSeatClass:String read GetLastSeatClass write SetLastSeatClass;
  public
    { Public declarations }
   procedure DoRefresh(FirstOnce:Boolean);
  end;

var
  frmSeatClass: TfrmSeatClass;

implementation

{$R *.DFM}

uses SysUtils, UMainUnited, NTimeData, UAdjust, NTimeCode,
  OTIZSeatClassEdit;

procedure TfrmSeatClass.FormCreate(Sender: TObject);
begin
 Caption:='Штатное расписание';
 FormStyle:=fsMDIChild;

 FormStorage.IniFileName:=_GetIniFileName;
 FormStorage.IniSection:='SeatClassEdit';
 FormStorage.Active:=True;

 ChangeDatabase(Self,dbSTBasis);

 DoRefresh(True);//This is first refresh!!!
end;

procedure TfrmSeatClass.DoRefresh(FirstOnce:Boolean);
var I:Integer;
begin
 Refreshing:=True;
 //При первом разе запоминать в ini ненадо!
 if not FirstOnce then
 try
  LastDepart:=quDepartSelect.Bookmark;
  LastSeatClass:=quSeatClassSelect.Bookmark;
 except
 end;

 if quDepartSelect.Active then quDepartSelect.Close;
 if quSeatClassSelect.Active then quSeatClassSelect.Close;

 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quDepartSelect.Open;
  quSeatClassSelect.Open;

  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quDepartSelect.Bookmark:=LastDepart;
  quSeatClassSelect.Bookmark:=LastSeatClass;
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

  ButtonAdd.Enabled:=_isPermission(tbSeatClass,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbSeatClass,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbSeatClass,DelConst);

 Refreshing:=False;
end;

function TfrmSeatClass.GetLastDepart:String;
begin
 try
  Result:=HexStrToString(FormStorage.StoredValue['LastDepart']);
 except
  Result:='';
 end;
end;

procedure TfrmSeatClass.SetLastDepart(L:String);
begin
 try
  FormStorage.StoredValue['LastDepart']:=StringToHexStr(L);
 except
 end;
end;

function TfrmSeatClass.GetLastSeatClass:String;
begin
 try
  Result:=HexStrToString(FormStorage.StoredValue['LastSeatClass']);
 except
  Result:='';
 end;
end;

procedure TfrmSeatClass.SetLastSeatClass(L:String);
begin
 try
  FormStorage.StoredValue['LastSeatClass']:=StringToHexStr(L);
 except
 end;
end;

procedure TfrmSeatClass.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridSeatClass.Width+TreeDepart.Width+Splitter1.Width-EditSearch.Left;
end;

procedure TfrmSeatClass.FormDestroy(Sender: TObject);
begin
 frmSeatClass:=nil;
end;

procedure TfrmSeatClass.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 Application.Hint:='';
end;

procedure TfrmSeatClass.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Shift=[] then
 case Key of
  VK_F2:if ButtonAdd.Enabled then ButtonAdd.Click;      //Add
  VK_F3:if ButtonEdit.Enabled then ButtonEdit.Click;    //Edit
  VK_F4:if ButtonDelete.Enabled then ButtonDelete.Click;//Delete
  VK_F5:ButtonRefresh.Click;                            //Refresh
  VK_F6:;                                               //View all
  VK_F7:;                                               //Filter
  VK_F8:ButtonSetup.Click;                             //Setup cols
 end;
 _MainFormKeyDown(Key,Shift);
end;

procedure TfrmSeatClass.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmSeatClass.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmSeatClass.ButtonRefreshClick(Sender: TObject);
begin
 DoRefresh(False);
end;

procedure TfrmSeatClass.ButtonCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmSeatClass.GridSeatClassEnter(Sender: TObject);
var C:Integer;
begin
 if Sender is TCustomDBGrid then
 begin
  DBNavigator.DataSource:=TCustomDBGrid(Sender).DataSource;
  if TCustomDBGrid(Sender).DataSource.DataSet is TIBQuery then
   C:=GetRecordCount(TCustomDBGrid(Sender).DataSource.DataSet as TIBQuery)
  else C:=0;
 end;
 if Sender is TDBTreeView then
 begin
  DBNavigator.DataSource:=TDBTreeView(Sender).DataSource;
  if TDBTreeView(Sender).DataSource.DataSet is TIBQuery then
   C:=GetRecordCount(TDBTreeView(Sender).DataSource.DataSet as TIBQuery)
  else C:=0;
 end;
 LabelCount.Enabled:=True;
 LabelCount.Caption:=ViewCountText+Format('%d',[C]);
end;

procedure TfrmSeatClass.GridSeatClassExit(Sender: TObject);
begin
 DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmSeatClass.GridSeatClassGetCellParams(Sender: TObject;
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

procedure TfrmSeatClass.CommontAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     LastDepart:=quDepartSelect.Bookmark;
     TreeDepart.RefreshItems;
    end;
  2:begin
     if GridSeatClass.DataSource.DataSet.Active then
     begin
      GridSeatClass.SelectedRows.Clear;
      GridSeatClass.SelectedRows.CurrentRowSelected:=True;
     end;
     LastSeatClass:=quSeatClassSelect.Bookmark;
    end;
 end;
end;

procedure TfrmSeatClass.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridSeatClass.Columns);
end;

procedure TfrmSeatClass.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quSeatClassSelect.Active) or quSeatClassSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridSeatClass.SetFocus;
   quSeatClassSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridSeatClass.SetFocus;
   quSeatClassSelect.Prior;
   Exit;
  end;
  if GridSeatClass.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('А')..byte('я')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quSeatClassSelect.Locate(GridSeatClass.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
 end;
end;

procedure TfrmSeatClass.ButtonAddClick(Sender: TObject);
begin
 if (not quDepartSelect.Active) or quDepartSelect.IsEmpty then Exit;
 if AddSeatClass(quDepartSelect.FieldByName('depart_id').AsInteger) then DoRefresh(False);
end;

procedure TfrmSeatClass.ButtonEditClick(Sender: TObject);
begin
 if (not quDepartSelect.Active) or (not quSeatClassSelect.Active) or
  quDepartSelect.IsEmpty or (quSeatClassSelect.IsEmpty) then Exit;
 if EditSeatClass(quDepartSelect.FieldByName('depart_id').AsInteger,
  quSeatClassSelect.FieldByName('seatclass_id').AsInteger) then DoRefresh(False);
end;

procedure TfrmSeatClass.ButtonDeleteClick(Sender: TObject);
begin
 if (not quSeatClassSelect.Active) or (quSeatClassSelect.IsEmpty) then Exit;
 if DeleteSeatClass(quSeatClassSelect.FieldByName('seatclass_id').AsInteger) then DoRefresh(False);
end;

end.
