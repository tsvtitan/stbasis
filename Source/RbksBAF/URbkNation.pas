unit URbkNation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, DbGrids, tsvDbGrid;

type
  TFmRbkNation = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkNation: TFmRbkNation;

implementation
Uses UmainUnited, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkNation.FormCreate(Sender: TObject);
begin
  inherited;
  caption:=NameNation;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbNation);
end;

procedure TFmRbkNation.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkNation:=nil;
end;

procedure TFmRbkNation.BtDelClick(Sender: TObject);
begin
  DeletingRec:='национальность <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkNation.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbNation+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   SetLastOrderFromTypeSort(fn,TypeSort);
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkNation.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkNation.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Национальность';
  cl.Width:=350;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

end.
