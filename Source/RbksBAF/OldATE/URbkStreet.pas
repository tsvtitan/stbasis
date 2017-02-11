unit URbkStreet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids, StdCtrls,
  DBCtrls, ExtCtrls, Buttons;

type
  TFmRbkStreet = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure ActivateRbkQuery;
    procedure SetGridColumns;
    { Public declarations }
  end;

var
  FmRbkStreet: TFmRbkStreet;

implementation
Uses UMainUnited, URbkStreetEdit, Uconst, UFuncProc;

{$R *.DFM}

procedure TFmRbkStreet.ActivateRbkQuery;
begin
  TableName:=tbStreet;
  StandartSQl:='Select Str.Street_id, Str.Name, TpS.Name as TpName, Twn.Town_id, TpS.TypeStreet_id,'+#13+
   ' Twn.Name as Town from '+TbStreet+' Str join '+tbTypeStreet+
    ' TpS ON Str.TypeStreet_id = TpS.TypeStreet_id join '+TbTown+
    ' Twn ON Str.Town_id = Twn.Town_id ';
end;

procedure TFmRbkStreet.SetGridColumns;
var
  Col: TColumn;
  P : PFilterParams;
begin
  Grid.Columns.Clear;

  New(P);
  Col:=Grid.Columns.Add;
  Col.FieldName:='Name';
  Col.Title.Caption:='Название улицы';
  P.GridName:='Name';
  P.FieldName:='Str.Name';
  FilterValues.Add(P);

  New(P);
  Col:=Grid.Columns.Add;
  Col.FieldName:='TpName';
  Col.Title.Caption:='тип улицы';
  P.GridName:='TpName';
  P.FieldName:='TpS.Name';
  FilterValues.Add(P);

  New(P);
  Col:=Grid.Columns.Add;
  Col.FieldName:='Town';
  Col.Title.Caption:='Нас. пункта';
  P.GridName:='Town';
  P.FieldName:='Twn.Name';
  FilterValues.Add(P);
end;


procedure TFmRbkStreet.FormCreate(Sender: TObject);
begin
  inherited;
  caption:=NameStreet;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;



procedure TFmRbkStreet.BtInsertClick(Sender: TObject);
var
  fm: TfmrbkStreetEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmrbkStreetEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.EditMode:=false;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(fm.Locate_id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkStreet.BtEditClick(Sender: TObject);
var
  fm: TfmrbkStreetEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmrbkStreetEdit.Create(Application);
  try
    fm.EditMode:=true;
    fm.Caption:=CaptionChange;
    fm.TypeStreet_id:=RbkQuery.FieldByName('TypeStreet_id').AsInteger;
    fm.Town_id:=RbkQuery.FieldByName('Town_id').AsInteger;
    
    fm.EdNameStreet.text:=RbkQuery.FieldByName('Name').AsString;
    fm.EdTypeStreet.text:=RbkQuery.FieldByName('TpName').AsString;
    fm.EdTown.text:=RbkQuery.FieldByName('Town').AsString;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(fm.Locate_id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkStreet.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkStreet:=nil;
end;

procedure TFmRbkStreet.BtDelClick(Sender: TObject);
begin
  DeletingRec:='улицу <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkStreet.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=RbkQuery.fieldByName(tbStreet+'_id').asInteger;
   RbkQuery.Active:=false;
   RbkQuery.SQL.Clear;
   OrderSQL:=' Order by '+fn;
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkStreet.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;
end.
