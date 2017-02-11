unit URbkTypeTown;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids,
  StdCtrls, DBCtrls, ExtCtrls, Buttons;

type
  TFmRbkTypeTown = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
  FmRbkTypeTown: TFmRbkTypeTown;

implementation
uses UmainUnited, Uconst, UFuncProc;

{$R *.DFM}

procedure TFmRbkTypeTown.FormCreate(Sender: TObject);
begin
  inherited;
  caption:=NameTypeTown;
  SetGridTitleNames;
  LoadFromIni;  
  CreateSQl('TypeTown');
end;

procedure TFmRbkTypeTown.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTypeTown:=nil;
end;

procedure TFmRbkTypeTown.BtDelClick(Sender: TObject);
begin
  DeletingRec:='тип нас. пункта <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTypeTown.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Ќазвание типа нас. пункта';
  cl.Width:=200;
  New(P);
  P.FieldName:='Name';
  P.GridName:='Name';
  FilterValues.Add(P);
end;

procedure TFmRbkTypeTown.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbTypeTown+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkTypeTown.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

end.
