unit OTIZCategory;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, Placemnt, NTimeCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmCategory = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridCategory: TRxDBGrid;
    PanelClose: TPanel;
    ButtonClose: TButton;
    PanelOKCancel: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    EditSearch: TEdit;
    LabelCount: TLabel;
    PanelNavigator: TPanel;
    DBNavigator: TDBNavigator;
    Label1: TLabel;
    ButtonAdd: TButton;
    ButtonEdit: TButton;
    ButtonDelete: TButton;
    PanelSelecting: TPanel;
    ButtonSetup2: TButton;
    ButtonRefresh: TButton;
    quCategorySelect: TIBQuery;
    trRead: TIBTransaction;
    dsCategorySelect: TDataSource;
    ButtonEditRefresh: TButton;
    ButtonSetup: TButton;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonEditRefreshClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure GridCategoryEnter(Sender: TObject);
    procedure GridCategoryExit(Sender: TObject);
    procedure GridCategoryGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quCategorySelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   CategoryAction:TCategoryAction;
   CategoryParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
   constructor Create(AOwner:TComponent;AhInterface: THandle;ACategoryAction:TCategoryAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmCategory: TfrmCategory;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, OTIZCategoryEdit;

constructor TfrmCategory.Create(AOwner:TComponent;AhInterface: THandle;ACategoryAction:TCategoryAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 CategoryAction:=ACategoryAction;
 CategoryParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridCategory.Font);
 GridCategory.TitleFont.Assign(GridCategory.Font);

 PanelRight.Visible:=(CategoryAction=caCategoryEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if CategoryAction=caCategoryEdit then begin
   Caption:='Категории';
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:='Выбор категории';
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmCategory.DoRefresh;
var I:Integer;
    LastCategory:String;
begin
 Refreshing:=True;

 try
  LastCategory:=quCategorySelect.Bookmark;
 except
 end;

 if quCategorySelect.Active then quCategorySelect.Close;
 quCategorySelect.SQL.Text:='select c.category_id,c.name,c.categorytype_id,t.name as typename from category c left join categorytype t on c.categorytype_id=t.categorytype_id ';
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quCategorySelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quCategorySelect.Bookmark:=LastCategory;
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

  ButtonAdd.Enabled:=_isPermission(tbCategory,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbCategory,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbCategory,DelConst);

 case CategoryAction of
  caCategorySelect:ButtonOK.Enabled:=not quCategorySelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmCategory.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridCategory.Width-EditSearch.Left;
end;

procedure TfrmCategory.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if CategoryParams<>nil then
  with CategoryParams.Locate do
   if KeyFields<>nil then
    try
     quCategorySelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmCategory.FormDestroy(Sender: TObject);
begin
 if CategoryAction=caCategoryEdit then frmCategory:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if CategoryAction=caCategoryEdit then Action:=caFree;
 if (ModalResult=mrOK) and (CategoryParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quCategorySelect,GridCategory,CategoryParams);
 Application.Hint:='';
end;

procedure TfrmCategory.FormKeyDown(Sender: TObject; var Key: Word;
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
  VK_F8:ButtonSetup2.Click;                             //Setup cols
 end;
 _MainFormKeyDown(Key,Shift);
end;

procedure TfrmCategory.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmCategory.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmCategory.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmCategory.ButtonCloseClick(Sender: TObject);
begin
 if CategoryAction<>caCategoryEdit then Exit;
 Close;
end;

procedure TfrmCategory.GridCategoryEnter(Sender: TObject);
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

procedure TfrmCategory.GridCategoryExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmCategory.GridCategoryGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
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

procedure TfrmCategory.quCategorySelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridCategory.DataSource.DataSet.Active then
     begin
      GridCategory.SelectedRows.Clear;
      GridCategory.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmCategory.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridCategory.Columns);
end;

procedure TfrmCategory.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quCategorySelect.Active) or quCategorySelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridCategory.SetFocus;
   quCategorySelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridCategory.SetFocus;
   quCategorySelect.Prior;
   Exit;
  end;
  if GridCategory.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('А')..byte('я')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quCategorySelect.Locate(GridCategory.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmCategory.ButtonAddClick(Sender: TObject);
begin
 if AddCategory then DoRefresh;
end;

procedure TfrmCategory.ButtonEditClick(Sender: TObject);
begin
 if (CategoryAction=caCategoryEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quCategorySelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditCategory(quCategorySelect.FieldByName('category_id').AsInteger) then
   DoRefresh;
 end else
 if (CategoryAction=caCategorySelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmCategory.ButtonDeleteClick(Sender: TObject);
begin
 if quCategorySelect.IsEmpty then Exit;
 if DeleteCategory(quCategorySelect.FieldByName('category_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmCategory.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridCategory.Columns);
end;

end.
