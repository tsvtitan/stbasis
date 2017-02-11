unit URbkRegion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, DBGrids;

type
   TFmRbkRegion = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    procedure SetGridColumns;
    procedure ActivateRbkQuery;
    { Public declarations }
  end;

var
  FmRbkRegion: TFmRbkRegion;

implementation
Uses UrbkRegionEdit, UMainUnited, Uconst, UFuncProc;

{$R *.DFM}
procedure TFmRbkRegion.ActivateRbkQuery;
begin
  TableName:=tbRegion;
  StandartSQL:='Select Reg.Code, Reg.SmallName, Reg.Region_id, Reg.Country_id, '+
    'Reg.TypeRegion_id, Reg.Name, Reg.PostIndex, Reg.GNINMB, Cntr.Name as Country, TpR.Name as TpName from '+
    TbRegion+' Reg join '+tbCountry+' Cntr ON Reg.Country_id = Cntr.Country_id join '+
    TbTypeRegion+' TpR ON Reg.TypeRegion_id = TpR.TypeRegion_id ';
end;

procedure TFmRbkRegion.SetGridColumns;
var
  Col: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

  Col:=Grid.Columns.Add;
  Col.FieldName:='Name';
  Col.Title.Caption:='Название';
  Col.Width:=350;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Reg.Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='postIndex';
  Col.Title.Caption:='Почтовый индекс';
  Col.Width:=50;
  New(P);
  P.GridName:='postIndex';
  P.FieldName:='Reg.postIndex';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='GNINMB';
  Col.Title.Caption:='ГНИНМБ';
  Col.Width:=40;
  New(P);
  P.GridName:='GNINMB';
  P.FieldName:='Reg.GNINMB';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='TpName';
  Col.Title.Caption:='тип';
  Col.Width:=200;
  New(P);
  P.GridName:='TpName';
  P.FieldName:='TpR.Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='Country';
  Col.Title.Caption:='страна';
  Col.Width:=150;
  New(P);
  P.GridName:='Country';
  P.FieldName:='Cntr.Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='Code';
  Col.Title.Caption:='код';
  Col.Width:=40;
  New(P);
  P.GridName:='Code';
  P.FieldName:='Reg.Code';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='SmallName';
  Col.Title.Caption:='сокр.';
  Col.Width:=150;
  New(P);
  P.GridName:='SmallName';
  P.FieldName:='Reg.SmallName';
  FilterValues.Add(P);
end;

procedure TFmRbkRegion.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRegion;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkRegion.BtInsertClick(Sender: TObject);
var
  fm: TfmRbkRegionEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmRbkRegionEdit.Create(Application);
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

procedure TFmRbkRegion.BtEditClick(Sender: TObject);
var
  fm: TfmRbkRegionEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TfmRbkRegionEdit.Create(Application);
  try
    id:=RbkQuery.FieldByName('Region_id').AsInteger;
    fm.EditMode:=true;
    fm.Locate_id:=id;
    fm.Caption:=CaptionChange;
    fm.TypeRegion_id:=RbkQuery.FieldByName('TypeRegion_id').AsInteger;
    fm.Country_id:=RbkQuery.FieldByName('Country_id').AsInteger;
    fm.EdCode.text:=RbkQuery.FieldByName('Code').AsString;
    fm.EdName.text:=RbkQuery.FieldByName('Name').AsString;
    fm.EdPostIndex.text:=RbkQuery.FieldByName('PostIndex').AsString;
    fm.EdGNINMB.text:=RbkQuery.FieldByName('GNINMB').AsString;
    fm.EdSmallName.text:=RbkQuery.FieldByName('SmallName').AsString;
    fm.EdType.text:=RbkQuery.FieldByName('tpname').AsString;
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

procedure TFmRbkRegion.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkRegion:=nil;
end;

procedure TFmRbkRegion.BtDelClick(Sender: TObject);
begin
  DeletingRec:='регион <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;


procedure TFmRbkRegion.GridTitleClick(Column: TColumn);
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

procedure TFmRbkRegion.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;


end.

