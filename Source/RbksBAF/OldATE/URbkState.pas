unit URbkState;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, DBGrids;

type
  TFmRbkState = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
  private
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure ActivateRbkQuery;
    procedure SetGridTitleNames;
  end;

var
  FmRbkState: TFmRbkState;

implementation
uses UmainUnited, UrbkStateEdit, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkState.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameState;
  SetGridTitleNames;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkState.ActivateRbkQuery;
begin
  TableName:=tbState;
  StandartSQL:='Select St.*, Cntr.Name as country from State st join '+tbCountry+
  ' Cntr on St.Country_id = Cntr.'+tbCountry+'_id';
end;


procedure TFmRbkState.BtInsertClick(Sender: TObject);
var
  fm: TfmRbkStateEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmRbkStateEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.EditMode:=false;
    if fm.ShowModal = mrOK then
    begin
      RefreshQuery(false);
      Locate(fm.Locate_id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkState.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkState:=nil;
end;

procedure TFmRbkState.BtDelClick(Sender: TObject);
begin
  DeletingRec:='округ <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkState.SetGridTitleNames;
var
  cl:TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;
  cl:=Grid.Columns.Add;
  cl.FieldName:='Code';
  cl.Title.Caption:='Код';
  cl.Width:=40;
  New(P);
  P.GridName:='Code';
  P.FieldName:='St.Code';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Name';
  cl.Title.Caption:='Название округа';
  cl.Width:=200;
  New(P);
  P.GridName:='Name';
  P.FieldName:='St.Name';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='SmallName';
  cl.Title.Caption:='Сокр. наименование';
  cl.Width:=60;
  New(P);
  P.GridName:='SmallName';
  P.FieldName:='St.SmallName';
  FilterValues.Add(P);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Country';
  cl.Title.Caption:='Страна';
  cl.Width:=60;
  New(P);
  P.GridName:='Country';
  P.FieldName:='Cntr.Name';
  FilterValues.Add(P);
end;

procedure TFmRbkState.GridTitleClick(Column: TColumn);
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
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkState.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;


procedure TFmRbkState.BtEditClick(Sender: TObject);
var
  fm: TfmRbkStateEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TfmRbkStateEdit.Create(Application);
  try
    id:=RbkQuery.FieldByName(TableName+'_id').AsInteger;
    fm.EditMode:=true;
    fm.Caption:=CaptionChange;
    fm.Country_id:=RbkQuery.FieldByName('Country_id').AsInteger;
    fm.EdCode.text:=RbkQuery.FieldByName('Code').AsString;
    fm.EdName.text:=RbkQuery.FieldByName('Name').AsString;
    fm.EdSmallName.text:=RbkQuery.FieldByName('SmallName').AsString;
    fm.EdCountry.text:=RbkQuery.FieldByName('Country').AsString;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(id);
    end;
  finally
    fm.Free;
  end;
end;

end.
