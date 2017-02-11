unit URbkPersonDocType;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, dbgrids, tsvDbGrid;

type
  TFmRbkPersonDocType = class(TFmRbk)
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
  FmRbkPersonDocType: TFmRbkPersonDocType;

implementation
Uses Uconst, UmainUnited, UFuncProc;

{$R *.DFM}

procedure TFmRbkPersonDocType.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NamePersonDocType;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbPersonDocType);
end;

procedure TFmRbkPersonDocType.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  FmRbkPersonDocType:=nil;
end;

procedure TFmRbkPersonDocType.BtDelClick(Sender: TObject);
begin
  DeletingRec:='документ <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkPersonDocType.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
    fn:=Column.FieldName;
    id:=RbkQuery.fieldByName(tbPersonDocType+'_id').asInteger;
    RbkQuery.Active:=false;
    RbkQuery.SQL.Clear;
    SetLastOrderFromTypeSort(fn,TypeSort);
    RefreshQuery(true);
    Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkPersonDocType.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;


procedure TFmRbkPersonDocType.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Название документа';
  cl.Width:=350;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='maskNum';
  cl.Title.Caption:='Маска номера';
  cl.Width:=50;
  New(P);
  P.GridName:='maskNum';
  P.FieldName:='maskNum';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='maskSeries';
  cl.Title.Caption:='Маска серии';
  cl.Width:=50;
  New(P);
  P.GridName:='maskSeries';
  P.FieldName:='maskSeries';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='NPP';
  cl.Title.Caption:='НПП';
  cl.Width:=50;
  New(P);
  P.GridName:='NPP';
  P.FieldName:='NPP';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Code';
  cl.Title.Caption:='Код';
  cl.Width:=50;
  New(P);
  P.GridName:='Code';
  P.FieldName:='Code';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='SmallName';
  cl.Title.Caption:='Сокр.';
  cl.Width:=50;
  New(P);
  P.GridName:='SmallName';
  P.FieldName:='SmallName';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='MaskPodrCode';
  cl.Title.Caption:='Маска кода подразделения';
  cl.Width:=50;
  New(P);
  P.GridName:='MaskPodrCode';
  P.FieldName:='MaskPodrCode';
  FilterValues.Add(P);

end;


end.
