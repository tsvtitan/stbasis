unit OTIZClass;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, Placemnt, NTimeCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmClass = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridClass: TRxDBGrid;
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
    FormStorage: TFormStorage;
    PanelSelecting: TPanel;
    ButtonSetup2: TButton;
    ButtonRefresh: TButton;
    quClassSelect: TIBQuery;
    trRead: TIBTransaction;
    dsClassSelect: TDataSource;
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
    procedure GridClassEnter(Sender: TObject);
    procedure GridClassExit(Sender: TObject);
    procedure GridClassGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quClassSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   ClassAction:TClassAction;
   ClassParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
   constructor Create(AOwner:TComponent;AhInterface: THandle;AClassAction:TClassAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmClass: TfrmClass;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, OTIZClassEdit;

constructor TfrmClass.Create(AOwner:TComponent;AhInterface: THandle;AClassAction:TClassAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 ClassAction:=AClassAction;
 ClassParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridClass.Font);
 GridClass.TitleFont.Assign(GridClass.Font);

 PanelRight.Visible:=(ClassAction=caClassEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if ClassAction=caClassEdit then begin
   Caption:='Разряды';
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:='Выбор разряда';
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmClass.DoRefresh;
var I:Integer;
    LastClass:String;
begin
 Refreshing:=True;

 try
  LastClass:=quClassSelect.Bookmark;
 except
 end;

 if quClassSelect.Active then quClassSelect.Close;
 quClassSelect.SQL.Text:='select class_id,num from class ';
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quClassSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quClassSelect.Bookmark:=LastClass;
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

  ButtonAdd.Enabled:=_isPermission(tbClass,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbClass,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbClass,DelConst);

 case ClassAction of
  caClassSelect:ButtonOK.Enabled:=not quClassSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmClass.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridClass.Width-EditSearch.Left;
end;

procedure TfrmClass.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if ClassParams<>nil then
  with ClassParams.Locate do
   if KeyFields<>nil then
    try
     quClassSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmClass.FormDestroy(Sender: TObject);
begin
 if ClassAction=caClassEdit then frmClass:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmClass.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if ClassAction=caClassEdit then Action:=caFree;
 if (ModalResult=mrOK) and (ClassParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quClassSelect,GridClass,ClassParams);
 Application.Hint:='';
end;

procedure TfrmClass.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmClass.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmClass.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmClass.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmClass.ButtonCloseClick(Sender: TObject);
begin
 if ClassAction<>caClassEdit then Exit;
 Close;
end;

procedure TfrmClass.GridClassEnter(Sender: TObject);
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

procedure TfrmClass.GridClassExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmClass.GridClassGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmClass.quClassSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridClass.DataSource.DataSet.Active then
     begin
      GridClass.SelectedRows.Clear;
      GridClass.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmClass.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridClass.Columns);
end;

procedure TfrmClass.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quClassSelect.Active) or quClassSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridClass.SetFocus;
   quClassSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridClass.SetFocus;
   quClassSelect.Prior;
   Exit;
  end;
  if GridClass.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('А')..byte('я')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quClassSelect.Locate(GridClass.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmClass.ButtonAddClick(Sender: TObject);
begin
 if AddClass then DoRefresh;
end;

procedure TfrmClass.ButtonEditClick(Sender: TObject);
begin
 if (ClassAction=caClassEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quClassSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditClass(quClassSelect.FieldByName('class_id').AsInteger) then
   DoRefresh;
 end else
 if (ClassAction=caClassSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmClass.ButtonDeleteClick(Sender: TObject);
begin
 if quClassSelect.IsEmpty then Exit;
 if DeleteClass(quClassSelect.FieldByName('class_id').AsInteger) then
  DoRefresh;
end;

procedure TfrmClass.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridClass.Columns);
end;

end.
