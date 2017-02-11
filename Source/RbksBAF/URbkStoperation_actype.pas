unit URbkStoperation_actype;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls, DbGrids, tsvDbGrid;

type
  TFmRbkStoperation_acType = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridColumns;
    procedure ActivateRbkQuery;
    { Public declarations }
  end;

var
  FmRbkStoperation_acType: TFmRbkStoperation_acType;

implementation
uses UMainUnited, URbkStOperation_AcTypeEdit, Uconst;

{$R *.DFM}

procedure TFmRbkStoperation_acType.ActivateRbkQuery;
begin
  TableName:=tbStOperation_AcType;
  StandartSQL:='Select Op_Ac.*, StOp.Name as operation, AcT.Name as Account from '+
    tbStOperation_AcType+' Op_Ac join StandartOperation StOp on '+
    'Op_Ac.StandartOperation_id=StOp.StandartOperation_id join AccountType AcT '+
    'on Op_Ac.AccountType_id=AcT.AccountType_id ';
end;

procedure TFmRbkStoperation_acType.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameStOperation_AccountType;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkStoperation_acType.SetGridColumns;
var
  Col: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

  Col:=Grid.Columns.Add;
  Col.FieldName:='Operation';
  Col.Title.Caption:='Операции';
  Col.Width:=100;
  New(P);
  P.GridName:='Operation';
  P.FieldName:='StOp.Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='Account';
  Col.Title.Caption:='Проводки';
  Col.Width:=100;
  New(P);
  P.GridName:='Account';
  P.FieldName:='AcT.Name';
  FilterValues.Add(P);
end;

procedure TFmRbkStoperation_acType.BtInsertClick(Sender: TObject);
var
  fm: TfmRbkStoperation_AcTypeEdit;
  AcId, SOId:Integer;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmRbkStoperation_AcTypeEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.BtPost.OnClick:=fm.AddRecord;
    if fm.ShowModal = mrOk then
    begin
      Acid:=fm.NewAccountType_id;
      SOId:=fm.NewStandartOperation_id;
      RefreshQuery(false);
      RbkQuery.locate('StandartOperation_id; AccountType_id',
        varArrayOf([SOId,AcId]),[]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkStoperation_acType.BtEditClick(Sender: TObject);
var
  fm:TfmRbkStoperation_AcTypeEdit;
  AcId, SOId:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TfmRbkStoperation_AcTypeEdit.Create(Application);
  try
    AcId:=RbkQuery.FieldByName('AccountType_id').AsInteger;
    SOId:=RbkQuery.FieldByName('StandartOperation_id').AsInteger;
    fm.EdStandartOperation.text:=RbkQuery.fieldByName('Operation').AsString;
    fm.EdAccountType.text:=RbkQuery.fieldByName('Account').AsString;
    fm.BtPost.OnClick:=fm.EditRecord;
    fm.Caption:=CaptionChange;
    fm.AccountType_id:=AcId;
    fm.StandartOperation_id:=SOId;
    if fm.ShowModal = mrOk then
    begin
      Acid:=fm.NewAccountType_id;
      SOId:=fm.NewStandartOperation_id;
      RefreshQuery(false);
      RbkQuery.locate('StandartOperation_id; AccountType_id',
        varArrayOf([SOId,AcId]),[]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkStoperation_acType.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then FmRbkStoperation_acType:=nil;
end;

procedure TFmRbkStoperation_acType.BtDelClick(Sender: TObject);
var
  DelQ: TIbQuery;
begin
  if RbkQuery.IsEmpty then exit;
  if DeleteWarning(Application.Handle,'запись  <операция - '+
    RbkQuery.FieldByName('Operation').AsString+#13+', проводка - '+
    RbkQuery.FieldByName('Account').AsString+'>')=mrYes then
  begin
    DelQ:=TIbQuery.Create(nil);
    DelQ.Database:=IbDb;
    DelQ.Transaction:=RbkTrans;
    DelQ.SQL.Add('Delete from '+TableName+' where StandartOperation_id = '+
      RbkQuery.fieldByName('StandartOperation_id').AsString+' and AccountType_id='+
      RbkQuery.fieldByName('AccountType_id').AsString);
    try
      DelQ.Transaction.Active:=true;
      DelQ.ExecSQL;
      DelQ.Transaction.CommitRetaining;
      RefreshQuery(true);
    finally
      DelQ.Free;
    end;
  end;
end;

procedure TFmRbkStoperation_acType.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkStoperation_acType.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  AcId, SOId:Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount<2 then exit;
  Screen.Cursor:=crHourGlass;
  AcId:=RbkQuery.FieldByName('AccountType_id').AsInteger;
  SOId:=RbkQuery.FieldByName('StandartOperation_id').AsInteger;
  try
   fn:=Column.FieldName;
   if fn='OPERATION' then fn:='StOp.Name';
   if fn='ACCOUNT' then fn:='AcT.Name';
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   RbkQuery.locate('StandartOperation_id; AccountType_id', varArrayOf([SOId,AcId]),[]);
  finally
    Screen.Cursor:=crDefault;
  end;
end;



end.
