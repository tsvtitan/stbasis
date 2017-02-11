unit URbkProf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, Buttons,
  StdCtrls, DBCtrls, ExtCtrls, tsvDbGrid;

type
  TFmRbkProf = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
    { Private declarations }
  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkProf: TFmRbkProf;

implementation
uses UMainUnited, Uconst, UFuncProc;

{$R *.DFM}

procedure TFmRbkProf.FormCreate(Sender: TObject);
begin
  inherited;
  RbkQuery.DataBase:=IbDb;
  RbkQuery.Transaction:=RbkTrans;
  RbkTrans.AddDatabase(IBDB);
  Ibdb.AddTransaction(RbkTrans);
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbProf);
  caption:=nameProf;
end;

procedure TFmRbkProf.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkProf:=nil;
end;

procedure TFmRbkProf.BtDelClick(Sender: TObject);
begin
  DeletingRec:='профессию <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkProf.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Название профессии';
  cl.Width:=300;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

procedure TFmRbkProf.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbProf+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   SetLastOrderFromTypeSort(fn,TypeSort);
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkProf.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;


end.
