unit URbkMotive;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, dbGrids,tsvDbGrid;

type
  TFmRbkMotive = class(TFmRbk)
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
  end;

var
  FmRbkMotive: TFmRbkMotive;

implementation
Uses UmainUnited, Uconst, UFuncProc;

{$R *.DFM}

procedure TFmRbkMotive.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=nameMotive;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbMotive);
end;

procedure TFmRbkMotive.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkMotive:=nil;
end;

procedure TFmRbkMotive.BtDelClick(Sender: TObject);
begin
  DeletingRec:='мотив увольнения <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkMotive.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
    fn:=Column.FieldName;
    id:=RbkQuery.fieldByName(tbMotive+'_id').asInteger;
    RbkQuery.Active:=false;
    RbkQuery.SQL.Clear;
    SetLastOrderFromTypeSort(fn,TypeSort);
    RefreshQuery(true);
    Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkMotive.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkMotive.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Причины увольнения';
  cl.Width:=350;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;


end.
