unit URbkExperiencePercent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls, DbGrids, tsvDbGrid;

type
  TFmRbkExperiencePercent = class(TFmRbk)
    PnDetailGrid: TPanel;
    Panel1: TPanel;
    PnDetailBtns: TPanel;
    BtPercInsert: TButton;
    BtPercEdit: TButton;
    BtPercDel: TButton;
    Spl: TSplitter;
    IBDetail: TIBQuery;
    IBTranDetail: TIBTransaction;
    DetailDS: TDataSource;
    BtPercOptions: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RbkQueryAfterScroll(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure BtPercDelClick(Sender: TObject);
    procedure BtPercOptionsClick(Sender: TObject);
    procedure BtPercInsertClick(Sender: TObject);
    procedure BtPercEditClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
    procedure DetailGridDblClick(Sender: TObject);
    procedure DetailGridTitleClick(Column: TColumn);
    procedure SetGridColumns;
  public
    DetailGrid: TNewDbGrid;
    DetailOrderStr:String;
    procedure ActivePercent(Perm:Boolean);
    { Public declarations }
  end;

var
  FmRbkExperiencePercent: TFmRbkExperiencePercent;

implementation
Uses UConst, UmainUnited, UFuncProc, UAdjust, UrbkExpPercentEdit;

{$R *.DFM}

procedure TFmRbkExperiencePercent.FormCreate(Sender: TObject);
var
  cl:TColumn;
begin
  inherited;
  RbkQuery.DataBase:=IbDb;
  RbkQuery.Transaction:=RbkTrans;
  RbkTrans.AddDatabase(IBDB);
  Ibdb.AddTransaction(RbkTrans);
  SetGridColumns;
  Caption:=NameTypePay;
  LoadFromIni;
  CreateSQl(tbTypePay);

  IbTranDetail.AddDatabase(IBDB);
  Ibdb.AddTransaction(IbTranDetail);
  IBDetail.DataBase:=IbDb;
  IBDetail.Transaction:=IbTranDetail;

  DetailGrid:=TNewdbGrid.Create(self);
  DetailGrid.Parent:=PnDetailGrid;
  DetailGrid.Align:=alClient;
  AssignFont(_GetOptions.RBTableFont,DetailGrid.Font);
  DetailGrid.TitleFont.Assign(DetailGrid.Font);
  DetailGrid.RowSelected.Font.Assign(DetailGrid.Font);

  DetailGrid.Width:=pnGrid.Width-PnModify.Width;
  DetailGrid.DataSource:=DetailDS;
  DetailGrid.RowSelected.Visible:=true;
  DetailGrid.RowSelected.Brush.Style:=bsClear;
  DetailGrid.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  DetailGrid.RowSelected.Font.Color:=clWhite;
  DetailGrid.RowSelected.Pen.Style:=psClear;
  DetailGrid.CellSelected.Visible:=true;
  DetailGrid.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  DetailGrid.CellSelected.Font.Assign(DetailGrid.Font);
  DetailGrid.CellSelected.Font.Color:=clHighlightText;
  DetailGrid.TitleCellMouseDown.Font.Assign(DetailGrid.Font);
  DetailGrid.Options:=Grid.Options-[dgEditing]-[dgTabs];
  DetailGrid.ReadOnly:=true;
  DetailGrid.OnKeyDown:=FormKeyDown;

  cl:=DetailGrid.Columns.Add;
  cl.FieldName:='experience';
  cl.Title.Caption:='Стаж';
  cl.Width:=80;

  cl:=DetailGrid.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Процент';
  cl.Width:=80;
  DetailGrid.OnDblClick:=DetailGridDblClick;
  DetailGrid.OnTitleClick:=DetailGridTitleClick;
  Grid.TabOrder:=3;
  PnDetailBtns.TabOrder:=4;
end;

procedure TFmRbkExperiencePercent.SetGridColumns;
var
  Col: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

  Col:=Grid.Columns.Add;
  Col.FieldName:='Name';
  Col.Title.Caption:='Вид доплаты';
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

procedure TFmRbkExperiencePercent.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkExperiencePercent.RbkQueryAfterScroll(DataSet: TDataSet);
begin
  inherited;
  ActivePercent(true);
end;

procedure TFmRbkExperiencePercent.ActivePercent(Perm:Boolean);
  function CheckPermissionExpPercent: Boolean;
  var
   isPermNew: Boolean;
  begin
   isPermNew:=_isPermission(tbexperiencepercent,SelConst);
   BtPercInsert.Enabled:=isPermNew and _isPermission(tbexperiencepercent,InsConst);
   BtPercEdit.Enabled:=isPermNew and _isPermission(tbexperiencepercent,UpdConst);
   BtPercDel.Enabled:=isPermNew and _isPermission(tbexperiencepercent,DelConst);
   Result:=isPermNew;
  end;
var
  SQLStr:String;
begin
  try
    try
      Screen.Cursor:=crHourGlass;
      IBDetail.Active:=false;
      IBTranDetail.Active:=false;
      if not CheckPermissionExpPercent then exit;
      SQLStr:='Select * from '+tbexperiencepercent+
        ' where typePay_id='+RbkQuery.fieldByname('typePay_id').AsString+' '+
        DetailOrderStr;
      IBDetail.SQL.text:=SQLStr;
      IBDetail.Transaction.Active:=false;
      IBDetail.Transaction.Active:=true;
      IBDetail.Active:=true;
    finally
       Screen.Cursor:=crDefault;
    end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmRbkExperiencePercent.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  FmRbkExperiencePercent:=nil;
end;

procedure TFmRbkExperiencePercent.BtDelClick(Sender: TObject);
begin
  DeletingRec:='тип доплаты <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkExperiencePercent.BtPercDelClick(Sender: TObject);
var
  DelQ: TIbQuery;
begin
  if IBDetail.IsEmpty then exit;
  DeletingRec:='процент от стажа <'+
    IBDetail.FieldByName('EXPERIENCE').AsString+'> ?';
  if DeleteWarning(Application.Handle,DeletingRec)=mrYes then
  begin
    DelQ:=TIbQuery.Create(nil);
    DelQ.Database:=IbDb;
    DelQ.Transaction:=IBTranDetail;
    DelQ.SQL.Add('Delete from '+tbexperiencepercent+' where '+tbexperiencepercent+
      '_id = '+IBDetail.fieldByName(tbexperiencepercent+'_id').AsString);
    try
      DelQ.Transaction.Active:=true;
      DelQ.ExecSQL;
      DelQ.Transaction.Commit;
      ActivePercent(true);
    finally
      DelQ.Free;
    end;
  end;
end;

procedure TFmRbkExperiencePercent.BtPercOptionsClick(Sender: TObject);
begin
  SetAdjustColumns(DetailGrid.Columns);
end;

procedure TFmRbkExperiencePercent.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   id:=RbkQuery.fieldByName(TableName+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by Name';
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkExperiencePercent.BtPercInsertClick(Sender: TObject);
var
  fm: TFmRbkExpPercentEdit;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TFmRbkExpPercentEdit.Create(Application);
  fm.TypePay_id:=RbkQuery.fieldByName(tbTypePay+'_id').Asinteger;
  try
    fm.Caption:=CaptionAdd;
    fm.BtPost.OnClick:=fm.AddRecord;
    if fm.ShowModal = mrOk then
    begin
      ActivePercent(true);
      IBDetail.Locate(tbexperiencepercent+'_id', fm.Locate_id,[]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkExperiencePercent.BtPercEditClick(Sender: TObject);
var
  fm: TFmRbkExpPercentEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty)  then Exit;
  if (IBDetail.IsEmpty) or (not IBDetail.Active) then exit;
  fm:=TFmRbkExpPercentEdit.Create(Application);
  try
    id:=IBDetail.FieldByName(tbExperiencepercent+'_id').AsInteger;
    fm.BtPost.OnClick:=fm.EditRecord;
    fm.Caption:=CaptionChange;

    fm.Locate_id:=id;
    fm.TypePay_id:=IBDetail.FieldByName('TypePay_id').AsInteger;
    fm.EdExperience.text:=IBDetail.FieldByName('Experience').AsString;
    fm.EdPercent.text:=IBDetail.FieldByName('Percent').AsString;

    if (fm.ShowModal = mrOk)  and (fm.ChangeFlag) then
    begin
      ActivePercent(true);
      IBDetail.Locate(tbexperiencepercent+'_id', fm.Locate_id,[]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkExperiencePercent.DetailGridDblClick(Sender: TObject);
begin
  if not IBDetail.Active then exit;
  if IBDetail.IsEmpty then exit;
  if BtPercEdit.Visible then BtPercEdit.Click;
end;

procedure TFmRbkExperiencePercent.DetailGridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not IBDetail.Active then exit;
  if IBDetail.Isempty then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=IBDetail.fieldByName(tbexperiencepercent+'_id').asInteger;
   IBDetail.Active:=false;
   IBDetail.SQL.Clear;
   DetailOrderStr:=' Order by '+fn;
   ActivePercent(false);
   IBDetail.Locate(tbexperiencepercent+'_id', id, []);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

end.
