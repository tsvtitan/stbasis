unit URbkCountry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, StdCtrls,
  DBCtrls, ExtCtrls, Buttons, tsvDbGrid;

type
  TFmRbkCountry = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
  private
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkCountry: TFmRbkCountry;

implementation
Uses UmainUnited, Uconst, UFuncProc, URbkCountryEdit;
{$R *.DFM}

procedure TFmRbkCountry.FormCreate(Sender: TObject);
begin
  inherited;
  caption:=NameCountry;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbCountry);
end;

procedure TFmRbkCountry.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkCountry:=nil;
end;

procedure TFmRbkCountry.BtDelClick(Sender: TObject);
begin
  DeletingRec:='страну <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;


procedure TFmRbkCountry.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbCountry+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   SetLastOrderFromTypeSort(fn,TypeSort);
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkCountry.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkCountry.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  cl:=Grid.Columns.Add;
  cl.FieldName:='Code';
  cl.Title.Caption:='Код';
  cl.Width:=40;
  New(P);
  P.GridName:='Code';
  P.FieldName:='Code';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Название страны';
  cl.Width:=150;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Name1';
  cl.Title.Caption:='Полное название';
  cl.Width:=100;
  New(P);
  P.GridName:='Name1';
  P.FieldName:='Name1';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='alfa2';
  cl.Title.Caption:='Сокр.1';
  cl.Width:=40;
  New(P);
  P.GridName:='alfa2';
  P.FieldName:='alfa2';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='alfa3';
  cl.Title.Caption:='Сокр.2';
  cl.Width:=40;
  New(P);
  P.GridName:='alfa3';
  P.FieldName:='alfa3';
  FilterValues.Add(P);
end;


procedure TFmRbkCountry.BtInsertClick(Sender: TObject);
var
  fm: TFmRbkCountryEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TFmRbkCountryEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.TbName:=Tablename;
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

end.
