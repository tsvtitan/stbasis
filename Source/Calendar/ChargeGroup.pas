unit ChargeGroup;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, CalendarCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmChargeGroup = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridChargeGroup: TRxDBGrid;
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
    quChargeGroupSelect: TIBQuery;
    trRead: TIBTransaction;
    dsChargeGroupSelect: TDataSource;
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
    procedure GridChargeGroupEnter(Sender: TObject);
    procedure GridChargeGroupExit(Sender: TObject);
    procedure GridChargeGroupGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quChargeGroupSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   ChargeGroupAction:TChargeGroupAction;
   ChargeGroupParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
    { Public declarations }
   constructor Create(AOwner:TComponent;AhInterface: THandle;AChargeGroupAction:TChargeGroupAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmChargeGroup: TfrmChargeGroup;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, CalendarData, UAdjust, ChargeGroupEdit;

constructor TfrmChargeGroup.Create(AOwner:TComponent;AhInterface: THandle;AChargeGroupAction:TChargeGroupAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 ChargeGroupAction:=AChargeGroupAction;
 ChargeGroupParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridChargeGroup.Font);
 GridChargeGroup.TitleFont.Assign(GridChargeGroup.Font);

 PanelRight.Visible:=(ChargeGroupAction=cgChargeGroupEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if ChargeGroupAction=cgChargeGroupEdit then begin
   Caption:=CaptionChargeGroupEdit;
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:=CaptionChargeGroupSelect;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmChargeGroup.DoRefresh;
var I:Integer;
    Last:String;
begin
 Refreshing:=True;

 try
  Last:=quChargeGroupSelect.Bookmark;
 except
 end;

 if quChargeGroupSelect.Active then quChargeGroupSelect.Close;
 quChargeGroupSelect.SQL.Text:=sqlSelChargeGroupAll;
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quChargeGroupSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quChargeGroupSelect.Bookmark:=Last;
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

  ButtonAdd.Enabled:=_isPermission(tbChargeGroup,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbChargeGroup,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbChargeGroup,DelConst);

 case ChargeGroupAction of
  cgChargeGroupSelect:ButtonOK.Enabled:=not quChargeGroupSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmChargeGroup.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridChargeGroup.Width-EditSearch.Left;
end;

procedure TfrmChargeGroup.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if ChargeGroupParams<>nil then
  with ChargeGroupParams.Locate do
   if KeyFields<>nil then
    try
     quChargeGroupSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmChargeGroup.FormDestroy(Sender: TObject);
begin
 if ChargeGroupAction=cgChargeGroupEdit then frmChargeGroup:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmChargeGroup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if ChargeGroupAction=cgChargeGroupEdit then Action:=caFree;
 if (ModalResult=mrOK) and (ChargeGroupParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quChargeGroupSelect,GridChargeGroup,ChargeGroupParams);
 Application.Hint:='';
end;

procedure TfrmChargeGroup.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmChargeGroup.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmChargeGroup.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmChargeGroup.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmChargeGroup.ButtonCloseClick(Sender: TObject);
begin
 if ChargeGroupAction<>cgChargeGroupEdit then Exit;
 Close;
end;

procedure TfrmChargeGroup.GridChargeGroupEnter(Sender: TObject);
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

procedure TfrmChargeGroup.GridChargeGroupExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmChargeGroup.GridChargeGroupGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmChargeGroup.quChargeGroupSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridChargeGroup.DataSource.DataSet.Active then
     begin
      GridChargeGroup.SelectedRows.Clear;
      GridChargeGroup.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmChargeGroup.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridChargeGroup.Columns);
end;

procedure TfrmChargeGroup.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quChargeGroupSelect.Active) or quChargeGroupSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridChargeGroup.SetFocus;
   quChargeGroupSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridChargeGroup.SetFocus;
   quChargeGroupSelect.Prior;
   Exit;
  end;
  if GridChargeGroup.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('À')..byte('ÿ')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quChargeGroupSelect.Locate(GridChargeGroup.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmChargeGroup.ButtonAddClick(Sender: TObject);
begin
 if AddChargeGroup then DoRefresh;
end;

procedure TfrmChargeGroup.ButtonEditClick(Sender: TObject);
begin
 if (ChargeGroupAction=cgChargeGroupEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quChargeGroupSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditChargeGroup(quChargeGroupSelect.FieldByName(fldChargeGroupChargeGroupID).AsInteger) then
   DoRefresh;
 end else
 if (ChargeGroupAction=cgChargeGroupSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmChargeGroup.ButtonDeleteClick(Sender: TObject);
begin
 if quChargeGroupSelect.IsEmpty then Exit;
 if DeleteChargeGroup(quChargeGroupSelect.FieldByName(fldChargeGroupChargeGroupID).AsInteger) then
  DoRefresh;
end;

procedure TfrmChargeGroup.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridChargeGroup.Columns);
end;

end.
