unit NTimeShift;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, Placemnt, NTimeCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmShift = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridShift: TRxDBGrid;
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
    quShiftSelect: TIBQuery;
    trRead: TIBTransaction;
    dsShiftSelect: TDataSource;
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
    procedure GridShiftEnter(Sender: TObject);
    procedure GridShiftExit(Sender: TObject);
    procedure GridShiftGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quShiftSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   ShiftAction:TShiftAction;
   ShiftParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
    { Public declarations }
   constructor Create(AOwner:TComponent;AhInterface: THandle;AShiftAction:TShiftAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmShift: TfrmShift;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, NTimeShiftEdit;

constructor TfrmShift.Create(AOwner:TComponent;AhInterface: THandle;AShiftAction:TShiftAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 ShiftAction:=AShiftAction;
 ShiftParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridShift.Font);
 GridShift.TitleFont.Assign(GridShift.Font);

 PanelRight.Visible:=(ShiftAction=saShiftEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if ShiftAction=saShiftEdit then begin
   Caption:=CaptionShiftEdit;
   PanelSelecting.Visible:=False;
   PanelRight.Visible:=True;
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:=CaptionShiftSelect;
  PanelSelecting.Visible:=True;
  PanelRight.Visible:=False;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmShift.DoRefresh;
var I:Integer;
    LastShift:String;
begin
 Refreshing:=True;

 try
  LastShift:=quShiftSelect.Bookmark;
 except
 end;

 if quShiftSelect.Active then quShiftSelect.Close;
 quShiftSelect.SQL.Text:=sqlSelShiftAll;
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quShiftSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quShiftSelect.Bookmark:=LastShift;
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

  ButtonAdd.Enabled:=_isPermission(tbShift,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbShift,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbShift,DelConst);

 case ShiftAction of
  saShiftSelect:ButtonOK.Enabled:=not quShiftSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmShift.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridShift.Width-EditSearch.Left;
end;

procedure TfrmShift.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if ShiftParams<>nil then
  with ShiftParams.Locate do
   if KeyFields<>nil then
    try
     quShiftSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmShift.FormDestroy(Sender: TObject);
begin
{ CloseAllSql(Self);
 ChangeDataBase(Self,nil);}
 if ShiftAction=saShiftEdit then frmShift:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmShift.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if ShiftAction=saShiftEdit then Action:=caFree;
 if (ModalResult=mrOK) and (ShiftParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quShiftSelect,GridShift,ShiftParams);
 Application.Hint:='';
end;

procedure TfrmShift.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmShift.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmShift.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmShift.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmShift.ButtonCloseClick(Sender: TObject);
begin
 if ShiftAction<>saShiftEdit then Exit;
 Close;
end;

procedure TfrmShift.GridShiftEnter(Sender: TObject);
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

procedure TfrmShift.GridShiftExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmShift.GridShiftGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmShift.quShiftSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridShift.DataSource.DataSet.Active then
     begin
      GridShift.SelectedRows.Clear;
      GridShift.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmShift.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridShift.Columns);
end;

procedure TfrmShift.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quShiftSelect.Active) or quShiftSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridShift.SetFocus;
   quShiftSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridShift.SetFocus;
   quShiftSelect.Prior;
   Exit;
  end;
  if GridShift.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('À')..byte('ÿ')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quShiftSelect.Locate(GridShift.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmShift.ButtonAddClick(Sender: TObject);
begin
 if AddShift then DoRefresh;
end;

procedure TfrmShift.ButtonEditClick(Sender: TObject);
begin
 if (ShiftAction=saShiftEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quShiftSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditShift(quShiftSelect.FieldByName(fldShiftShiftID).AsInteger) then
   DoRefresh;
 end else
 if (ShiftAction=saShiftSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmShift.ButtonDeleteClick(Sender: TObject);
begin
 if quShiftSelect.IsEmpty then Exit;
 if DeleteShift(quShiftSelect.FieldByName(fldShiftShiftID).AsInteger) then
  DoRefresh;
end;

procedure TfrmShift.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridShift.Columns);
end;

end.

