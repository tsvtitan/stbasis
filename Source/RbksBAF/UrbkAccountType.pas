unit UrbkAccountType;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls, DbGrids, tsvDbGrid;

type
  TFmRbkAccountType = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkAccountType: TFmRbkAccountType;

implementation
Uses UMainUnited, Uconst;

{$R *.DFM}

procedure TFmRbkAccountType.FormCreate(Sender: TObject);
begin
  inherited;
  caption:=NameAccountType;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(TbAccountType);
end;

procedure TFmRbkAccountType.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  FmRbkAccountType:=nil;
end;

procedure TFmRbkAccountType.BtDelClick(Sender: TObject);
begin
  DeletingRec:='тип проводки <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkAccountType.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(TbAccountType+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkAccountType.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkAccountType.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Типовая операция';
  cl.Width:=300;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Debit';
  cl.Title.Caption:='Дебит';
  cl.Width:=50;
  New(P);
  P.GridName:='Debit';
  P.FieldName:='Debit';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='kredit';
  cl.Title.Caption:='Кредит';
  cl.Width:=50;
  New(P);
  P.GridName:='kredit';
  P.FieldName:='kredit';
  FilterValues.Add(P);
end;


end.
