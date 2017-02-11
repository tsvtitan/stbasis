unit OTIZCategoryType;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, Placemnt, NTimeCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmCategoryType = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridCategoryType: TRxDBGrid;
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
    quCategoryTypeSelect: TIBQuery;
    trRead: TIBTransaction;
    dsCategoryTypeSelect: TDataSource;
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
    procedure GridCategoryTypeEnter(Sender: TObject);
    procedure GridCategoryTypeExit(Sender: TObject);
    procedure GridCategoryTypeGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quCategoryTypeSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   CategoryTypeAction:TCategoryTypeAction;
   CategoryTypeParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
   constructor Create(AOwner:TComponent;AhInterface: THandle;ACategoryTypeAction:TCategoryTypeAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmCategoryType: TfrmCategoryType;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, OTIZCategoryTypeEdit;

constructor TfrmCategoryType.Create(AOwner:TComponent;AhInterface: THandle;ACategoryTypeAction:TCategoryTypeAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 CategoryTypeAction:=ACategoryTypeAction;
 CategoryTypeParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridCategoryType.Font);
 GridCategoryType.TitleFont.Assign(GridCategoryType.Font);

 PanelRight.Visible:=(CategoryTypeAction=ctCategoryTypeEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if CategoryTypeAction=ctCategoryTypeEdit then begin
   Caption:=CaptionCategoryTypeEdit;
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:=CaptionCategoryTypeSelect;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmCategoryType.DoRefresh;
var I:Integer;
    LastCategoryType:String;
begin
 Refreshing:=True;

 try
  LastCategoryType:=quCategoryTypeSelect.Bookmark;
 except
 end;

 if quCategoryTypeSelect.Active then quCategoryTypeSelect.Close;
 quCategoryTypeSelect.SQL.Text:=sqlSelCategoryTypeAll;
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quCategoryTypeSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quCategoryTypeSelect.Bookmark:=LastCategoryType;
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

  ButtonAdd.Enabled:=_isPermission(tbCategoryType,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbCategoryType,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbCategoryType,DelConst);

 case CategoryTypeAction of
  ctCategoryTypeSelect:ButtonOK.Enabled:=not quCategoryTypeSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmCategoryType.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridCategoryType.Width-EditSearch.Left;
end;

procedure TfrmCategoryType.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if CategoryTypeParams<>nil then
  with CategoryTypeParams.Locate do
   if KeyFields<>nil then
    try
     quCategoryTypeSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmCategoryType.FormDestroy(Sender: TObject);
begin
 if CategoryTypeAction=ctCategoryTypeEdit then frmCategoryType:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmCategoryType.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if CategoryTypeAction=ctCategoryTypeEdit then Action:=caFree;
 if (ModalResult=mrOK) and (CategoryTypeParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quCategoryTypeSelect,GridCategoryType,CategoryTypeParams);
 Application.Hint:='';
end;

procedure TfrmCategoryType.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmCategoryType.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmCategoryType.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmCategoryType.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmCategoryType.ButtonCloseClick(Sender: TObject);
begin
 if CategoryTypeAction<>ctCategoryTypeEdit then Exit;
 Close;
end;

procedure TfrmCategoryType.GridCategoryTypeEnter(Sender: TObject);
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

procedure TfrmCategoryType.GridCategoryTypeExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmCategoryType.GridCategoryTypeGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmCategoryType.quCategoryTypeSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridCategoryType.DataSource.DataSet.Active then
     begin
      GridCategoryType.SelectedRows.Clear;
      GridCategoryType.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmCategoryType.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridCategoryType.Columns);
end;

procedure TfrmCategoryType.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quCategoryTypeSelect.Active) or quCategoryTypeSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridCategoryType.SetFocus;
   quCategoryTypeSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridCategoryType.SetFocus;
   quCategoryTypeSelect.Prior;
   Exit;
  end;
  if GridCategoryType.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('À')..byte('ÿ')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quCategoryTypeSelect.Locate(GridCategoryType.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmCategoryType.ButtonAddClick(Sender: TObject);
begin
 if AddCategoryType then DoRefresh;
end;

procedure TfrmCategoryType.ButtonEditClick(Sender: TObject);
begin
 if (CategoryTypeAction=ctCategoryTypeEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quCategoryTypeSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditCategoryType(quCategoryTypeSelect.FieldByName(fldCategoryTypeCategoryTypeID).AsInteger) then
   DoRefresh;
 end else
 if (CategoryTypeAction=ctCategoryTypeSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmCategoryType.ButtonDeleteClick(Sender: TObject);
begin
 if quCategoryTypeSelect.IsEmpty then Exit;
 if DeleteCategoryType(quCategoryTypeSelect.FieldByName(fldCategoryTypeCategoryTypeID).AsInteger) then
  DoRefresh;
end;

procedure TfrmCategoryType.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridCategoryType.Columns);
end;

end.

