unit URbkTypeStreet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, URbk,
  IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, StdCtrls,
  DBCtrls, ExtCtrls, Buttons;

type
  TFmRbkTypeStreet = class(TFmRbk)
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
  FmRbkTypeStreet: TFmRbkTypeStreet;

implementation
Uses UmainUnited, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkTypeStreet.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTypeStreet:=nil;
end;

procedure TFmRbkTypeStreet.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameTypeStreet;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbTypeStreet);
end;

procedure TFmRbkTypeStreet.BtDelClick(Sender: TObject);
begin
  DeletingRec:='тип улицы <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTypeStreet.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Название типа улицы';
  cl.Width:=200;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

procedure TFmRbkTypeStreet.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbTypeStreet+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkTypeStreet.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

end.
