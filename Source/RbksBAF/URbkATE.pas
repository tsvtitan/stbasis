unit URbkATE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, DBGrids, tsvDbGrid;

type
   TFmRbkATE = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
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
  FmRbkATE: TFmRbkATE;

implementation
Uses UMainUnited, Uconst, UFuncProc, URbkATEEdit, URbkRegion;

{$R *.DFM}
procedure TFmRbkATE.ActivateRbkQuery;
begin
//  TableName:=tbRegion;
  CreateSQl(tableName);
end;

procedure TFmRbkATE.SetGridColumns;
var
  Cl: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

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
  cl.Title.Caption:='Наименование';
  cl.Width:=150;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Socr';
  cl.Title.Caption:='Сокр.';
  cl.Width:=40;
  New(P);
  P.GridName:='Socr';
  P.FieldName:='Socr';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='GNINMB';
  cl.Title.Caption:='ГНИНМБ';
  cl.Width:=40;
  New(P);
  P.GridName:='GNINMB';
  P.FieldName:='GNINMB';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='PostIndex';
  cl.Title.Caption:='Почт. индекс';
  cl.Width:=40;
  New(P);
  P.GridName:='PostIndex';
  P.FieldName:='PostIndex';
  FilterValues.Add(P);
end;

procedure TFmRbkATE.FormCreate(Sender: TObject);
begin
  inherited;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkATE.BtInsertClick(Sender: TObject);
var
  fm: TfmRbkATEEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmRbkATEEdit.Create(Application);
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

procedure TFmRbkATE.BtEditClick(Sender: TObject);
var
  fm: TfmRbkATEEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TfmRbkATEEdit.Create(Application);
  try
    id:=RbkQuery.FieldByName(TableName+'_id').AsInteger;
    fm.TbName:=Tablename;
    fm.EditMode:=true;
    fm.Locate_id:=id;
    fm.Caption:=CaptionChange;
    fm.EdCode.text:=RbkQuery.FieldByName('Code').AsString;
    fm.EdName.text:=RbkQuery.FieldByName('Name').AsString;
    fm.EdSocr.text:=RbkQuery.FieldByName('Socr').AsString;
    fm.EdGNINMB.text:=RbkQuery.FieldByName('GNINMB').AsString;
    fm.EdPostIndex.text:=RbkQuery.FieldByName('PostIndex').AsString;

    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkATE.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
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

procedure TFmRbkATE.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;


end.

