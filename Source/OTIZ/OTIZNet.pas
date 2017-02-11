unit OTIZNet;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, Placemnt, NTimeCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmNet = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridNet: TRxDBGrid;
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
    quNetSelect: TIBQuery;
    trRead: TIBTransaction;
    dsNetSelect: TDataSource;
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
    procedure GridNetEnter(Sender: TObject);
    procedure GridNetExit(Sender: TObject);
    procedure GridNetGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quNetSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
   NetAction:TNetAction;
   NetParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
    { Public declarations }
   constructor Create(AOwner:TComponent;AhInterface: THandle;ANetAction:TNetAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmNet: TfrmNet;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, OTIZNetEdit;

constructor TfrmNet.Create(AOwner:TComponent;AhInterface: THandle;ANetAction:TNetAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 NetAction:=ANetAction;
 NetParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridNet.Font);
 GridNet.TitleFont.Assign(GridNet.Font);

 PanelRight.Visible:=(NetAction=naNetEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if NetAction=naNetEdit then begin
   Caption:='Сетки';
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:='Выбор сетки';
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmNet.DoRefresh;
var I:Integer;
    LastNet:String;
begin
 Refreshing:=True;

 try
  LastNet:=quNetSelect.Bookmark;
 except
 end;

 if quNetSelect.Active then quNetSelect.Close;
 quNetSelect.SQL.Text:='select net_id,name from net ';
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quNetSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quNetSelect.Bookmark:=LastNet;
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

  ButtonAdd.Enabled:=_isPermission(tbNet,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbNet,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbNet,DelConst);

 case NetAction of
  naNetSelect:ButtonOK.Enabled:=not quNetSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmNet.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridNet.Width-EditSearch.Left;
end;

procedure TfrmNet.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if NetParams<>nil then
  with NetParams.Locate do
   if KeyFields<>nil then
    try
     quNetSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmNet.FormDestroy(Sender: TObject);
begin
 if NetAction=naNetEdit then frmNet:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmNet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if NetAction=naNetEdit then Action:=caFree;
 if (ModalResult=mrOK) and (NetParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quNetSelect,GridNet,NetParams);
 Application.Hint:='';
end;

procedure TfrmNet.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmNet.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmNet.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmNet.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmNet.ButtonCloseClick(Sender: TObject);
begin
 if NetAction<>naNetEdit then Exit;
 Close;
end;

procedure TfrmNet.GridNetEnter(Sender: TObject);
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

procedure TfrmNet.GridNetExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmNet.GridNetGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmNet.quNetSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridNet.DataSource.DataSet.Active then
     begin
      GridNet.SelectedRows.Clear;
      GridNet.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmNet.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridNet.Columns);
end;

procedure TfrmNet.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quNetSelect.Active) or quNetSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridNet.SetFocus;
   quNetSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridNet.SetFocus;
   quNetSelect.Prior;
   Exit;
  end;
  if GridNet.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('А')..byte('я')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quNetSelect.Locate(GridNet.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmNet.ButtonAddClick(Sender: TObject);
begin
 if AddNet then DoRefresh;
end;

procedure TfrmNet.ButtonEditClick(Sender: TObject);
begin
 if (NetAction=naNetEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quNetSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditNet(quNetSelect.FieldByName('net_id').AsInteger) then
   DoRefresh;
 end else
 if (NetAction=naNetSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmNet.ButtonDeleteClick(Sender: TObject);
begin
 if quNetSelect.IsEmpty then Exit;
 if DeleteNet(quNetSelect.FieldByName('net_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmNet.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridNet.Columns);
end;

end.
