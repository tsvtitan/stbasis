unit URbkTypePay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls, dbgrids;

type
  TFmRbkTypePay = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;

  public
    procedure SetGridTitleNames;
    { Public declarations }
  end;

var
  FmRbkTypePay: TFmRbkTypePay;

implementation
uses UMainUnited, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkTypePay.FormCreate(Sender: TObject);
begin
  inherited;
  RbkQuery.DataBase:=IbDb;
  RbkQuery.Transaction:=RbkTrans;
  RbkTrans.AddDatabase(IBDB);
  Ibdb.AddTransaction(RbkTrans);
  SetGridTitleNames;
  LoadFromIni;
  CreateSQl(tbTypePay);
  Caption:=NameTypePay;
end;

procedure TFmRbkTypePay.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTypePay:=nil;
end;

procedure TFmRbkTypePay.BtDelClick(Sender: TObject);
begin
  DeletingRec:='вид оплаты <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTypePay.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Ќаименование вида оплаты';
  cl.Width:=200;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Name';
  FilterValues.Add(P);
end;

procedure TFmRbkTypePay.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbTypePay+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkTypePay.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

end.
