unit URbkTypeDoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, DBGrids, tsvDbGrid;

type
  TFmRbkTypeDoc = class(TFmRbk)
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
  FmRbkTypeDoc: TFmRbkTypeDoc;

implementation
Uses UmainUnited, Uconst, UFuncProc;

{$R *.DFM}

procedure TFmRbkTypeDoc.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameTypeDoc;
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbTypeDoc);
end;

procedure TFmRbkTypeDoc.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTypeDoc:=nil;
end;

procedure TFmRbkTypeDoc.BtDelClick(Sender: TObject);
begin
  DeletingRec:='вид документа <'+RbkQuery.FieldByName('name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTypeDoc.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
    fn:=Column.FieldName;
    id:=RbkQuery.fieldByName(tbTypeDoc+'_id').asInteger;
    RbkQuery.Active:=false;
    RbkQuery.SQL.Clear;
    SetLastOrderFromTypeSort(fn,TypeSort);
    RefreshQuery(true);
    Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkTypeDoc.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

procedure TFmRbkTypeDoc.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Виды документов';
  cl.Width:=350;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

end.
