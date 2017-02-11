unit URbkTypeRegion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, StdCtrls,
  DBCtrls, ExtCtrls, Buttons;

type
  TFmRbkTypeRegion = class(TFmRbk)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkTypeRegion: TFmRbkTypeRegion;

implementation
uses UmainUnited, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkTypeRegion.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTypeRegion:=nil;
end;

procedure TFmRbkTypeRegion.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameTypeRegion;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl('TypeRegion');
end;

procedure TFmRbkTypeRegion.BtDelClick(Sender: TObject);
begin
  DeletingRec:='тип региона <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTypeRegion.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbTypeRegion+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkTypeRegion.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkTypeRegion.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Название типа региона';
  cl.Width:=300;
  New(P);
  P.FieldName:='Name';
  P.GridName:='Name';
  FilterValues.Add(P);
end;
end.
