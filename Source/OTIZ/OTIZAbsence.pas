unit OTIZAbsence;

{$I stbasis.inc}

interface

uses
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, DBCtrls, Placemnt, NTimeCode,
  Db, IBDatabase, IBCustomDataSet, UMainUnited, IBQuery;

type
  TfrmAbsence = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    GridAbsence: TRxDBGrid;
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
    quAbsenceSelect: TIBQuery;
    trRead: TIBTransaction;
    dsAbsenceSelect: TDataSource;
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
    procedure GridAbsenceEnter(Sender: TObject);
    procedure GridAbsenceExit(Sender: TObject);
    procedure GridAbsenceGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure quAbsenceSelectAfterScroll(DataSet: TDataSet);
    procedure ButtonSetupClick(Sender: TObject);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
   AbsenceAction:TAbsenceAction;
   AbsenceParams:PParamRBookInterface;
   Refreshing:Boolean;
   FirstActive:Boolean;
   FhInterface: THandle;
  public
   constructor Create(AOwner:TComponent;AhInterface: THandle;AAbsenceAction:TAbsenceAction;AParams:PParamRBookInterface); virtual;
   procedure DoRefresh;
  end;

var
  frmAbsence: TfrmAbsence;

implementation

{$R *.DFM}

uses TypInfo, SysUtils, NTimeData, UAdjust, OTIZAbsenceEdit;

constructor TfrmAbsence.Create(AOwner:TComponent;AhInterface: THandle;AAbsenceAction:TAbsenceAction;AParams:PParamRBookInterface);
begin
 FirstActive:=True;
 AbsenceAction:=AAbsenceAction;
 AbsenceParams:=AParams;
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 inherited Create(AOwner);

 AssignFont(_GetOptions.RBTableFont,GridAbsence.Font);
 GridAbsence.TitleFont.Assign(GridAbsence.Font);

 PanelRight.Visible:=(AbsenceAction=aaAbsenceEdit) or _GetOptions.isEditRBOnSelect;
 PanelSelecting.Visible:=not PanelRight.Visible;
 if AbsenceAction=aaAbsenceEdit then begin
   Caption:=CaptionAbsenceEdit;
   PanelClose.Visible:=True;
   PanelOKCancel.Visible:=False;
   FormStyle:=fsMDIChild;
 end
 else begin
  Caption:=CaptionAbsenceSelect;
  PanelClose.Visible:=False;
  PanelOKCancel.Visible:=True;
  BorderIcons:=[biSystemMenu];
 end;
end;

procedure TfrmAbsence.DoRefresh;
var I:Integer;
    LastAbsence:String;
begin
 Refreshing:=True;

 try
  LastAbsence:=quAbsenceSelect.Bookmark;
 except
 end;

 if quAbsenceSelect.Active then quAbsenceSelect.Close;
 quAbsenceSelect.SQL.Text:=sqlSelAbsenceAll;
 if not trRead.InTransaction then trRead.StartTransaction;
 try
  quAbsenceSelect.Open;
  trRead.CommitRetaining;
 except
  trRead.RollbackRetaining;
  {$IFDEF DEBUG}
  Raise;
  {$ENDIF}
 end;

 try
  quAbsenceSelect.Bookmark:=LastAbsence;
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

  ButtonAdd.Enabled:=_isPermission(tbAbsence,InsConst);
  ButtonEdit.Enabled:=_isPermission(tbAbsence,UpdConst);
  ButtonDelete.Enabled:=_isPermission(tbAbsence,DelConst);

 case AbsenceAction of
  aaAbsenceSelect:ButtonOK.Enabled:=not quAbsenceSelect.IsEmpty;
 end;

 Refreshing:=False;
end;

procedure TfrmAbsence.FormResize(Sender: TObject);
begin
 EditSearch.Width:=GridAbsence.Width-EditSearch.Left;
end;

procedure TfrmAbsence.FormCreate(Sender: TObject);
begin
 Refreshing:=False;
 ChangeDatabase(Self,dbSTBasis);

 DoRefresh;

 if AbsenceParams<>nil then
  with AbsenceParams.Locate do
   if KeyFields<>nil then
    try
     quAbsenceSelect.Locate(KeyFields,KeyValues,Options);
    except
    end;
end;

procedure TfrmAbsence.FormDestroy(Sender: TObject);
begin
 if AbsenceAction=aaAbsenceEdit then frmAbsence:=nil;
 _OnVisibleInterface(FhInterface,False);
end;

procedure TfrmAbsence.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if AbsenceAction=aaAbsenceEdit then Action:=caFree;
 if (ModalResult=mrOK) and (AbsenceParams<>nil) then
  ReturnModalParamsFromDataSetAndGrid(quAbsenceSelect,GridAbsence,AbsenceParams);
 Application.Hint:='';
end;

procedure TfrmAbsence.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmAbsence.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 _MainFormKeyUp(Key,Shift);
end;

procedure TfrmAbsence.FormKeyPress(Sender: TObject; var Key: Char);
begin
 _MainFormKeyPress(Key);
end;

procedure TfrmAbsence.ButtonEditRefreshClick(Sender: TObject);
begin
 DoRefresh;
end;

procedure TfrmAbsence.ButtonCloseClick(Sender: TObject);
begin
 if AbsenceAction<>aaAbsenceEdit then Exit;
 Close;
end;

procedure TfrmAbsence.GridAbsenceEnter(Sender: TObject);
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

procedure TfrmAbsence.GridAbsenceExit(Sender: TObject);
begin
 if Sender is TCustomDBGrid then
  DBNavigator.DataSource:=nil;
 LabelCount.Enabled:=False;
end;

procedure TfrmAbsence.GridAbsenceGetCellParams(Sender: TObject; Field: TField;
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

procedure TfrmAbsence.quAbsenceSelectAfterScroll(DataSet: TDataSet);
begin
 if Refreshing then Exit;
 case DataSet.Tag of
  1:begin
     if GridAbsence.DataSource.DataSet.Active then
     begin
      GridAbsence.SelectedRows.Clear;
      GridAbsence.SelectedRows.CurrentRowSelected:=True;
     end;
    end;
 end;
end;

procedure TfrmAbsence.ButtonSetupClick(Sender: TObject);
begin
 SetAdjustColumns(GridAbsence.Columns);
end;

procedure TfrmAbsence.EditSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 try
  if (not quAbsenceSelect.Active) or quAbsenceSelect.IsEmpty then Exit;
  if Key=VK_DOWN then
  begin
   GridAbsence.SetFocus;
   quAbsenceSelect.Next;
   Exit;
  end;
  if Key=VK_UP then
  begin
   GridAbsence.SetFocus;
   quAbsenceSelect.Prior;
   Exit;
  end;
  if GridAbsence.SelectedField=nil then Exit;
  if not ((Key in [byte('A')..byte('z')])or
     (Key in [byte('À')..byte('ÿ')])or
     (Key in [byte('0')..byte('9')])) then Exit;
  quAbsenceSelect.Locate(GridAbsence.SelectedField.FullName,Trim(EditSearch.Text),[loPartialKey]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfrmAbsence.ButtonAddClick(Sender: TObject);
begin
 if AddAbsence then DoRefresh;
end;

procedure TfrmAbsence.ButtonEditClick(Sender: TObject);
begin
 if (AbsenceAction=aaAbsenceEdit) or (UpperCase(TComponent(Sender).Name)='BUTTONEDIT') then
 begin
  if quAbsenceSelect.IsEmpty or (not ButtonEdit.Enabled) then Exit;
  if EditAbsence(quAbsenceSelect.FieldByName(fldAbsenceAbsenceID).AsInteger) then
   DoRefresh;
 end else
 if (AbsenceAction=aaAbsenceSelect) and ButtonOK.Enabled then
  ButtonOK.Click;
end;

procedure TfrmAbsence.ButtonDeleteClick(Sender: TObject);
begin
 if quAbsenceSelect.IsEmpty then Exit;
 if DeleteAbsence(quAbsenceSelect.FieldByName(fldAbsenceAbsenceID).AsInteger) then
  DoRefresh;
end;

procedure TfrmAbsence.FormPaint(Sender: TObject);
begin
 if not FirstActive then Exit;
 FirstActive:=False;
 SetMinColumnsWidth(GridAbsence.Columns);
end;

end.
