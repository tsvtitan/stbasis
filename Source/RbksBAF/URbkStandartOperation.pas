unit URbkStandartOperation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls, DbGrids, tsvDbGrid;

type
  TFmRbkStandartOperation = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkStandartOperation: TFmRbkStandartOperation;

implementation
Uses UMainUnited, UConst;
{$R *.DFM}

procedure TFmRbkStandartOperation.FormCreate(Sender: TObject);
begin
  inherited;
  caption:=NameStandartOperation;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbStandartOperation);
end;

procedure TFmRbkStandartOperation.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkStandartOperation:=nil;
end;

procedure TFmRbkStandartOperation.BtDelClick(Sender: TObject);
begin
  DeletingRec:='типовую операцию <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkStandartOperation.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbStandartOperation+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkStandartOperation.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkStandartOperation.SetGridTitleNames;
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
  cl.FieldName:='Code';
  cl.Title.Caption:='Код';
  cl.Width:=50;
  New(P);
  P.GridName:='Code';
  P.FieldName:='Code';
  FilterValues.Add(P);
end;


end.
