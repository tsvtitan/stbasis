unit URbkDocum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbk, IBDatabase, Db, IBCustomDataSet, IBQuery, Buttons, StdCtrls,
  DBCtrls, ExtCtrls, dbgrids, tsvDbGrid;

type
  TFmRbkDocum = class(TFmRbk)
    procedure FormCreate(Sender: TObject);
    procedure BtInsertClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
    procedure BtFilterClick(Sender: TObject);
  private
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
  public
    curdate: TDateTime;
    procedure SetGridColumns;
    procedure ActivateRbkQuery;
  end;

var
  FmRbkDocum: TFmRbkDocum;

implementation
Uses UrbkDocumEdit, UMainUnited, Uconst, UFuncProc, URbkDokumFilter;
{$R *.DFM}

procedure TFmRbkDocum.ActivateRbkQuery;
begin
  TableName:=tbDocum;
  StandartSQL:='Select Doc.*, Tp.name as Name from '+TbDocum+
     ' Doc join '+tbTypeDoc+' tp ON Doc.TypeDoc_id = '+tbTypeDoc+'.TypeDoc_id';
end;

procedure TFmRbkDocum.SetGridColumns;
var
  Col: TColumn;
  P:PFilterParams;
begin
  Grid.Columns.Clear;

  Col:=Grid.Columns.Add;
  Col.FieldName:='Name';
  Col.Title.Caption:='Тип документа';
  Col.Width:=350;
  New(P);
  P.GridName:='Name';
  P.FieldName:='Tp.Name';
  FilterValues.Add(P);

  Col:=Grid.Columns.Add;
  Col.FieldName:='Num';
  Col.Title.Caption:='Номер';
  Col.Width:=200;
  New(P);
  P.GridName:='Num';
  P.FieldName:='Doc.Num';
  FilterValues.Add(P);


  Col:=Grid.Columns.Add;
  Col.FieldName:='dateDoc';
  Col.Title.Caption:='Дата документа';
  Col.Width:=150;
  New(P);
  P.GridName:='DateDoc';
  P.FieldName:='Doc.dateDoc';
  FilterValues.Add(P);
end;


procedure TFmRbkDocum.FormCreate(Sender: TObject);
begin
  inherited;
  curdate:=_GetDateTimeFromServer;
  Caption:=NameDocum;
  SetGridColumns;
  LoadFromIni;
  ActivateRbkQuery;
end;

procedure TFmRbkDocum.BtInsertClick(Sender: TObject);
var
  fm: TfmRbkDocumEdit;
begin
  if not RbkQuery.Active then Exit;
  fm:=TfmRbkDocumEdit.Create(Application);
  try
    fm.Caption:=CaptionAdd;
    fm.BtPost.OnClick:=fm.AddRecord;
    fm.DPDateDoc.DateTime:=curdate;
    if fm.ShowModal = mrOk then
    begin
      RefreshQuery(false);
      Locate(fm.Locate_id);
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkDocum.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkDocum:=nil;
end;

procedure TFmRbkDocum.BtDelClick(Sender: TObject);
begin
  DeletingRec:='документ <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkDocum.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
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
   SetLastOrderFromTypeSort(fn,TypeSort);
   RefreshQuery(true);
   Locate(id);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TFmRbkDocum.GridDblClick(Sender: TObject);
begin
  if not RbkQuery.Active then exit;
  if RbkQuery.RecordCount=0 then exit;
  if PnModify.Visible and BtEdit.Enabled then begin
   BtEdit.Click;
  end else BtMore.Click;
end;


procedure TFmRbkDocum.BtFilterClick(Sender: TObject);
var
  fm: TfmRbkDocumFilter;
  Id:Integer;
  P: PFilterParams;
begin
  if not RbkQuery.Active  then Exit;
  fm:=TfmRbkDocumFilter.Create(Application);
  try
    fm.DPFirst.DateTime:=curdate;
    fm.DPNext.DateTime:=curdate;
    fm.DPFirst.Checked:=false;
    fm.DPNext.Checked:=false;

    P:=GetFilterPointer('Name');
    if P<>nil then  fm.EdTypeDoc.text:=P.filterValue;

    P:=GetFilterPointer('Num');
    if P<>nil then  fm.EdNum.text:=P.filterValue;

    P:=GetFilterPointer('DateDoc');
    if P<>nil then
    begin
      if P.Period1<>'' then
      begin
        fm.DPFirst.Date:=StrToDate(P.period1);
        fm.DPFirst.Checked:=true;
        fm.CB.Checked:=true;
      end;
      if P.Period2<>'' then
      begin
        fm.DPNext.Date:=StrToDate(P.period2);
        fm.DPNext.Checked:=true;
        fm.CB.Checked:=true;
      end;

    end;
    fm.BtPost.OnClick:=fm.ApplyFilter;
    fm.Caption:=CaptionFilter;
    if fm.showMoDal=mrOk then
    begin
      P:=GetFilterPointer('Name');
      if P<>nil then  P.filterValue:=trim(fm.EdTypeDoc.text);
      P:=GetFilterPointer('Num');
      if P<>nil then  P.filterValue:=trim(fm.EdNum.text);

      P:=GetFilterPointer('DateDoc');
      if P<>nil then
      begin
        P.Period1:='';
        P.period2:='';
        if fm.cb.Checked then
        begin
          if fm.DPFirst.Checked then P.Period1:=DateToStr(fm.DPFirst.Date);
          if fm.DPNext.Checked then P.Period2:=DateToStr(fm.DPNext.Date);
        end
      end;
      CreateFilterString;
      RefreshQuery(false);
      ViewBtFiltered;
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkDocum.BtEditClick(Sender: TObject);
var
  fm:TfmRbkDocumEdit;
  Id:Integer;
begin
  if (not RbkQuery.Active) or (RbkQuery.IsEmpty) then Exit;
  fm:=TfmRbkDocumEdit.Create(Application);
  try
    id:=RbkQuery.FieldByName('Docum_id').AsInteger;
    fm.BtPost.OnClick:=fm.EditRecord;
    fm.Caption:=CaptionChange;
//    fm.ChangeFlag:=true;
    fm.TypeDoc_id:=RbkQuery.FieldByName('TypeDoc_id').AsInteger;

    fm.EdNum.text:=RbkQuery.FieldByName('Num').AsString;
    fm.EdTypeDoc.text:=RbkQuery.FieldByName('Name').AsString;
    fm.DPDateDoc.date:=RbkQuery.FieldByName('DateDoc').AsDateTime;

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
