unit RoundType;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, Db,
  IBDatabase, IBCustomDataSet, IBQuery, Grids, DBGrids, RXDBCtrl, DBCtrls,
  StdCtrls, CalendarCode, UMainUnited, ExtCtrls;

type
  TfrmRoundType = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridRoundType: TRxDBGrid;
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
    quRoundTypeSelect: TIBQuery;
    trRead: TIBTransaction;
    dsRoundTypeSelect: TDataSource;
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
    procedure GridRoundTypeEnter(Sender: TObject);
    procedure GridRoundTypeExit(Sender: TObject);
    procedure GridRoundTypeGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quRoundTypeSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   RoundTypeAction:TRoundTypeAction;
   RoundTypeParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
   constructor Create(AOwner:TComponent;AhInterface: THandle;ARoundTypeAction:TRoundTypeAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmRoundType: TfrmRoundType;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, CalendarData, UAdjust, RoundTypeEdit;

constructor TfrmRoundType.Create(AOwner:TComponent;AhInterface: THandle;ARoundTypeAction:TRoundTypeAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 RoundTypeAction:=ARoundTypeAction;
 RoundTypeParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridRoundType.Font);
 GridRoundType.TitleFont.Assign(GridRoundType.Font);

 PanelRight.Visible:=(RoundTypeAction=rtRoundTypeEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if RoundTypeAction=rtRoundTypeEdit then begin
   Caption:=CaptionRoundTypeEdit;
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:=CaptionRoundTypeSelect;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmRoundType.DoRefresh;
var I:Integer;
    Last:String;
begin
 Refreshing:=True;

 try
  Last:=quRoundTypeSelect.Bookmark;
 except
  Last:='';
 end; 
 
 if quRoundTypeSelect.Active then quRoundTypeSelect.Close;
 quRoundTypeSelect.SQL.Text:=sqlSelRoundTypeAll;
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quRoundTypeSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quRoundTypeSelect.Bookmark:=Last;
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

  ButtonAdd.Enabled:=_isPermission(tbRoundType,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbRoundType,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbRoundType,DelConst);

 case RoundTypeAction of
  rtRoundTypeSelect:ButtonOK.Enabled:=not quRoundTypeSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmRoundType.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridRoundType.Width-EditSearch.Left;
end;

procedure TfrmRoundType.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if RoundTypeParams<>nil then
  with RoundTypeParams.Locate do
   if KeyFields<>nil then
    try
     quRoundTypeSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmRoundType.FormDestroy(Sender: TObject);
begin
 if RoundTypeAction=rtRoundTypeEdit then frmRoundType:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmRoundType.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if RoundTypeAction=rtRoundTypeEdit then Action:=caFree;
 if (ModalResult=mrOK) and (RoundTypeParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quRoundTypeSelect,GridRoundType,RoundTypeParams);
 Application.Hint:='';
end;

procedure TfrmRoundType.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmRoundType.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmRoundType.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmRoundType.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmRoundType.ButtonCloseClick(Sender: TObject);
begin
 if RoundTypeAction<>rtRoundTypeEdit then Exit;
 Close;
end;

procedure TfrmRoundType.GridRoundTypeEnter(Sender: TObject);
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

procedure TfrmRoundType.GridRoundTypeExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmRoundType.GridRoundTypeGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmRoundType.quRoundTypeSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridRoundType.DataSource.DataSet.Active then
     begin
      GridRoundType.SelectedRows.Clear;
      GridRoundType.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmRoundType.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridRoundType.Columns);
end;

procedure TfrmRoundType.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quRoundTypeSelect.Active) or quRoundTypeSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridRoundType.SetFocus;
   quRoundTypeSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridRoundType.SetFocus;
   quRoundTypeSelect.Prior;
   Exit;
  end;
  if GridRoundType.SelectedField=nil then Exit;

  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('À')..byte('ÿ')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quRoundTypeSelect.Locate(GridRoundType.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmRoundType.ButtonAddClick(Sender: TObject);
begin
 if AddRoundType then DoRefresh;
end;

procedure TfrmRoundType.ButtonEditClick(Sender: TObject);
begin
 if (RoundTypeAction=rtRoundTypeEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quRoundTypeSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditRoundType(quRoundTypeSelect.FieldByName(fldRoundTypeRoundTypeID).AsInteger) then
   DoRefresh;
 end else
 if (RoundTypeAction=rtRoundTypeSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmRoundType.ButtonDeleteClick(Sender: TObject);
begin
 if quRoundTypeSelect.IsEmpty then Exit;
 if DeleteRoundType(quRoundTypeSelect.FieldByName(fldRoundTypeRoundTypeID).AsInteger) then
  DoRefresh;
end;

procedure TfrmRoundType.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridRoundType.Columns);
end;

end.
