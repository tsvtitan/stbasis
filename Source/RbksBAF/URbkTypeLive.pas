unit URbkTypeLive;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, dbgrids, UNewDbGrids;

type
  TFmRbkTypeLive = class(TFmRbk)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkTypeLive: TFmRbkTypeLive;

implementation
Uses UmainUnited, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkTypeLive.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTypeLive:=nil;
end;

procedure TFmRbkTypeLive.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameTypeLive;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbTypeLive);
end;

procedure TFmRbkTypeLive.BtDelClick(Sender: TObject);
begin
  DeletingRec:='вид отпуска <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTypeLive.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Вид проживания';
  cl.Width:=200;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

procedure TFmRbkTypeLive.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbTypeLive+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkTypeLive.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

end.
