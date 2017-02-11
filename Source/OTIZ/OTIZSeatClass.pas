unit OTIZSeatClass;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, {autotree, }dbtree, StdCtrls, Grids, DBGrids, RXDBCtrl,
  DBCtrls, Placemnt, IBDatabase, Db, IBCustomDataSet, IBQuery, NTimeCode, UMainUnited, ImgList,
  tsvComCtrls;

type
  TfrmSeatClass = class(TForm)
    PanelBottom: TPanel;
    Splitter1: TSplitter;
    PanelTop: TPanel;
    PanelRight: TPanel;
    GridSeatClass: TRxDBGrid;
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
    ImageList: TImageList;
    PanelSelecting: TPanel;
    ButtonSetup2: TButton;
    Button1: TButton;
    PanelOKCancel: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    PanelDepart: TPanel;
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
    procedure TreeDepartGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeDepartGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure FormPaint(Sender: TObject);
    procedure TreeDepartChange(Sender: TObject; Node: TTreeNode);
  private
   SeatClassAction:TSeatClassAction;
   SeatClassParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
   TreeDepart:TDBTreeView;
  public
   procedure DoRefresh;
   constructor Create(AOwner: TComponent;AhInterface: THandle;ASeatClassAction:TSeatClassAction;AParams:PParamRBookInterface);
  end;

var
  frmSeatClass: TfrmSeatClass;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, OTIZSeatClassEdit;

constructor TfrmSeatClass.Create(AOwner: TComponent;AhInterface: THandle;ASeatClassAction:TSeatClassAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 SeatClassAction:=ASeatClassAction;
 SeatClassParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 TreeDepart:=TDBTreeView.Create(Self);
 with TreeDepart do
 begin
  Parent:=PanelDepart;
  ShowNodeHint:=True;
  DataSource:=dsDepart;
  KeyField := 'depart_id';
  ListField := 'name';
  ParentField := 'parent_id';
  SeparatedSt := ' - ';
  ReadOnly := True;
  HideSelection := False;
  Indent := 19;
  OnChange := TreeDepartChange;
  OnGetImageIndex := TreeDepartGetImageIndex;
  OnGetSelectedIndex := TreeDepartGetSelectedIndex;
  Align := alClient;
  ParentColor := False;
  TabOrder:=1;
  Options := [trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren];
  SelectedIndex := -1;
  OnEnter := GridSeatClassEnter;
  OnExit := GridSeatClassExit;
  Images := ImageList;
 end;

 AssignFont(_GetOptions.RBTableFont,GridSeatClass.Font);
 GridSeatClass.TitleFont.Assign(GridSeatClass.Font);

 PanelRight.Visible:=(SeatClassAction=scSeatClassEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if SeatClassAction=scSeatClassEdit then begin
   Caption:='Штатное расписание';
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:='Выбор штатного расписания';
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmSeatClass.FormCreate(Sender: TObject);

 function GetDepartForSeatClass(ASeatClass_ID:Integer):Integer;
 begin
  Result:=-1;
  try
   quTemp.SQL.Text:=Format('select depart_id from seatclass where seatclass_id=%d',[ASeatClass_ID]);
   try
    quTemp.Open;
    if not quTemp.IsEmpty then
     Result:=quTemp.FieldByName('depart_id').AsInteger;
   finally
    quTemp.Close;
   end;
  except
  end;
 end;

{var
  D:Integer;}

begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if SeatClassParams<>nil then
  with SeatClassParams.Locate do
   if KeyFields<>nil then
   begin
{    if PSeatClassParams(SeatClassParams)^.SeatClass_ID>-1 then
    try
     D:=GetDepartForSeatClass(PSeatClassParams(SeatClassParams)^.SeatClass_ID);
     if D>-1 then
     begin
      if quDepartSelect.Locate('depart_id',D,[]) then
       quSeatClassSelect.Locate('SeatClass_id',PSeatClassParams(SeatClassParams)^.SeatClass_ID,[]);
     end;
    except
    end
    else
    begin
     if quDepartSelect.Locate('depart_id',PSeatClassParams(SeatClassParams)^.Depart_id,[]) then
      quSeatClassSelect.Locate('Seat_id;Class_id',VarArrayOf([PSeatClassParams(SeatClassParams)^.Seat_ID,PSeatClassParams(SeatClassParams)^.Class_ID]),[]);
    end;}
   end;
end;

procedure TfrmSeatClass.DoRefresh;
var I:Integer;
    LastDepart,LastSeatClass:String;
begin
 Refreshing:=True;

 CheckColumnsPermission(tbSeatClass,GridSeatClass.Columns);

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

 ButtonOK.Enabled:=not quSeatClassSelect.IsEmpty;

 Refreshing:=False;
end;

procedure TfrmSeatClass.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridSeatClass.Width+TreeDepart.Width+Splitter1.Width-EditSearch.Left;
end;

procedure TfrmSeatClass.FormDestroy(Sender: TObject);
begin
 TreeDepart.DataSource:=nil;
 TreeDepart.Free;
 TreeDepart:=nil;
 frmSeatClass:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmSeatClass.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if SeatClassAction=scSeatClassEdit then Action:=caFree;
 if (ModalResult=mrOK) and (SeatClassParams<>nil) then
 case SeatClassAction of
  scSeatClassSelect:try
   ReturnModalParamsFromDataSetAndGrid(quSeatClassSelect,GridSeatClass,SeatClassParams);
  except
  end;
 end;
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
 DoRefresh;
end;

procedure TfrmSeatClass.ButtonCloseClick(Sender: TObject);
begin
 if SeatClassAction<>scSeatClassEdit then Exit;
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
 end else
 if Sender is TDBTreeView then
 begin
  DBNavigator.DataSource:=TDBTreeView(Sender).DataSource;
  if TDBTreeView(Sender).DataSource.DataSet is TIBQuery then
   C:=GetRecordCount(TDBTreeView(Sender).DataSource.DataSet as TIBQuery)
  else C:=0;
 end else C:=0;
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
  2:begin
     if GridSeatClass.DataSource.DataSet.Active then
     begin
      GridSeatClass.SelectedRows.Clear;
      GridSeatClass.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
 ButtonOK.Enabled:=not quSeatClassSelect.IsEmpty;
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
 if AddSeatClass(quDepartSelect.FieldByName('depart_id').AsInteger) then DoRefresh;
end;

procedure TfrmSeatClass.ButtonEditClick(Sender: TObject);
begin
 if (SeatClassAction=scSeatClassEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if (not ButtonEdit.Enabled) or (not quDepartSelect.Active) or (not quSeatClassSelect.Active) or
   quDepartSelect.IsEmpty or (quSeatClassSelect.IsEmpty) then Exit;
  if EditSeatClass(quDepartSelect.FieldByName('depart_id').AsInteger,
   quSeatClassSelect.FieldByName('seatclass_id').AsInteger) then DoRefresh;
 end else
 if (SeatClassAction=scSeatClassSelect) and ButtonOK.Enabled and (not quSeatClassSelect.IsEmpty) then
  ButtonOK.Click;
end;

procedure TfrmSeatClass.ButtonDeleteClick(Sender: TObject);
begin
 if (not quSeatClassSelect.Active) or (quSeatClassSelect.IsEmpty) then Exit;
 if DeleteSeatClass(quSeatClassSelect.FieldByName('seatclass_id').AsInteger) then DoRefresh;
end;

procedure TfrmSeatClass.TreeDepartGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
 Node.ImageIndex:=0;
end;

procedure TfrmSeatClass.TreeDepartGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
 Node.SelectedIndex:=1;
end;

procedure TfrmSeatClass.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridSeatClass.Columns);
end;

procedure TfrmSeatClass.TreeDepartChange(Sender: TObject; Node: TTreeNode);
begin
 ButtonOK.Enabled:=not quSeatClassSelect.IsEmpty;
end;

end.


