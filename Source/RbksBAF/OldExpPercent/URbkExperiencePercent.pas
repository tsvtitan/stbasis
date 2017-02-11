unit URbkExperiencePercent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls, dbgrids;

type
  TFmRbkExperiencepercent = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    { Public declarations }
    procedure SetGridColumns;
    procedure ActivateRbkQuery;
  end;

var
  FmRbkExperiencepercent: TFmRbkExperiencepercent;

implementation
Uses UrbkExpPercentEdit, UMainUnited, Uconst, UFuncProc;
{$R *.DFM}

procedure TFmRbkExperiencepercent.ActivateRbkQuery;
begin
  TableName:=tbexperiencepercent;
  StandartSQL:='Select ExP.*, Tp.name as Name, Tp.TypePay_id from '+tbexperiencepercent+
     ' ExP join '+tbTypePay+' tp ON ExP.TypePay_id = tp.TypePay_id';
end;

procedure TFmRbkExperiencepercent.SetGridColumns;
var
  Col: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

  Col:=Grid.Columns.Add;

  Col.FieldName:='Name';
  Col.Title.Caption:='Вид оплаты';
  Col.Width:=200;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Tp.Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='experience';
  Col.Title.Caption:='Стаж';
  Col.Width:=50;
  New(P);
  P.GridName:='experience';
  P.FieldName:='experience';
  FilterValues.Add(P);


  Col:=Grid.Columns.Add;
  Col.FieldName:='Percent';
  Col.Title.Caption:='Процент';
  Col.Width:=50;
  New(P);
  P.GridName:='Percent';
  P.FieldName:='Percent';
  FilterValues.Add(P);
end;



procedure TFmRbkExperiencepercent.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=nameexperiencepercent;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkExperiencepercent.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  FmRbkExperiencepercent:=nil;
end;

procedure TFmRbkExperiencepercent.BtDelClick(Sender: TObject);
begin
  DeletingRec:='данные по виду оплаты <'+RbkQuery.FieldByName('Name').AsString+#13+
    'стаж - '+RbkQuery.FieldByName('Experience').AsString+' > ?';
  inherited;
end;

procedure TFmRbkExperiencepercent.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: Integer;
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   if fn='Name' then fn:='tp.name';
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

procedure TFmRbkExperiencepercent.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;

//указать лок. ид

procedure TFmRbkExperiencepercent.BtInsertClick(Sender: TObject);
var
  fm: TFmRbkExpPercentEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TFmRbkExpPercentEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.BtPost.OnClick:=fm.AddRecord;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(fm.Locate_id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkExperiencepercent.BtEditClick(Sender: TObject);
var
  fm: TFmRbkExpPercentEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TFmRbkExpPercentEdit.Create(Application);
  try
    id:=RbkQuery.FieldByName(tbExperiencepercent+'_id').AsInteger;
    fm.BtPost.OnClick:=fm.EditRecord;
    fm.Caption:=CaptionChange;

    fm.Locate_id:=id;
    fm.TypePay_id:=RbkQuery.FieldByName('TypePay_id').AsInteger;
    fm.EdTypePay.text:=RbkQuery.FieldByName('Name').AsString;
    fm.EdExperience.text:=RbkQuery.FieldByName('Experience').AsString;
    fm.EdPercent.text:=RbkQuery.FieldByName('Percent').AsString;

    if (fm.ShowModal = mrOk)  and (fm.ChangeFlag) then
    begin
      RefreshQuery(false);
      Locate(id);
    end;
  finally
    fm.Free;
  end;
end;


end.
