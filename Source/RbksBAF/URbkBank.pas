unit URbkBank;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, dbgrids, DBTables, Grids, tsvDbGrid;

type
  TFmRbkBank = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
   public
    procedure SetGridColumns;
    procedure ActivateRbkQuery;
    { Public declarations }
  end;

var
  FmRbkBank: TFmRbkBank;

implementation
uses UMainUnited, UConst, URbkBankEdit, UFuncProc;
{$R *.DFM}

procedure TFmRbkBank.ActivateRbkQuery;
begin
  TableName:=tbBank;
  StandartSQL:='Select * FROM '+tbBank;
end;

procedure TFmRbkBank.SetGridColumns;
var
  Col: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

  Col:=Grid.Columns.Add;
  Col.FieldName:='Name';
  Col.Title.Caption:='Название';
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='Address';
  Col.Title.Caption:='Адрес';
  New(P);
  P.GridName:='Address';
  P.FieldName:='Address';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='Bik';
  Col.Title.Caption:='Бик';
  New(P);
  P.GridName:='Bik';
  P.FieldName:='Bik';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='BikRkc';
  Col.Title.Caption:='Бик РКЦ';
  New(P);
  P.GridName:='BikRkc';
  P.FieldName:='BikRkc';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='corraccount';
  Col.Title.Caption:='Корр счет';
  New(P);
  P.GridName:='corraccount';
  P.FieldName:='corraccount';
  FilterValues.Add(P);
end;

procedure TFmRbkBank.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameBank;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkBank.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); 
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(TableName+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   SetLastOrderFromTypeSort(fn,TypeSort);
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkBank.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkBank.BtInsertClick(Sender: TObject);
var
  fm: TfmRbkBankEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmRbkBankEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.EditMode:=false;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(fm.Locate_id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkBank.BtEditClick(Sender: TObject);
var
  fm: TfmRbkBankEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TfmRbkBankEdit.Create(Application);
  try
    id:=RbkQuery.FieldByName('Bank_id').AsInteger;
    fm.Bank_id:=IntTostr(id);
    fm.EditMode:=true;
    fm.Caption:=CaptionChange;
    fm.EdName.text:=RbkQuery.FieldByName('Name').AsString;
    fm.EdBik.text:=RbkQuery.FieldByName('Bik').AsString;
    fm.EdBikRkc.text:=RbkQuery.FieldByName('BikRkc').AsString;
    fm.EdAddress.text:=RbkQuery.FieldByName('Address').AsString;
    fm.EdKorAccount.text:=RbkQuery.FieldByName('CorrAccount').AsString;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkBank.BtDelClick(Sender: TObject);
begin
  DeletingRec:='банк <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkBank.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkBank:=nil;
end;



end.
