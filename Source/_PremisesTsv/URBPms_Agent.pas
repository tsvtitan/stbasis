unit URBPms_Agent;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBPms_Agent = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    IndexFindName, IndexFindNote, IndexFindOffice: Integer;
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBPms_Agent: TfmRBPms_Agent;

implementation

uses UMainUnited, UPremisesTsvCode, UPremisesTsvDM, UPremisesTsvData, UEditRBPms_Agent;

{$R *.DFM}

procedure TfmRBPms_Agent.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkPms_Agent;

  Database:=IBDB;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='Note';
  cl.Title.Caption:='Описание';
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sortnumber';
  cl.Title.Caption:='Порядок';
  cl.Width:=80;

  IndexFindName:=Filters.Add('a.name',tdbcLike,false).Index;
  IndexFindNote:=Filters.Add('a.note',tdbcLike,false).Index;
  IndexFindOffice:=Filters.Add('so.name',tdbcLike,false).Index;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Agent.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPms_Agent:=nil;
end;

function TfmRBPms_Agent.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPms_Agent+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPms_Agent.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(Filters.Enabled);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Agent.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('office_name') then fn:='so.name';
   if UpperCase(fn)=UpperCase('name') then fn:='a.name';
   if UpperCase(fn)=UpperCase('note') then fn:='a.note';
   id:=MainQr.fieldByName('Pms_Agent_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('Pms_Agent_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPms_Agent.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPms_Agent;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPms_Agent.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.FillOffice(-1);
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('Pms_Agent_id',fm.oldPms_Agent_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Agent.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPms_Agent;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Agent.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.FillOffice(Mainqr.fieldByName('sync_office_id').AsInteger);
    fm.edNote.Text:=Mainqr.fieldByName('Note').AsString;
    fm.udSort.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldPms_Agent_id:=MainQr.FieldByName('Pms_Agent_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('Pms_Agent_id',fm.oldPms_Agent_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Agent.bibDelClick(Sender: TObject);
begin
  if not Mainqr.IsEmpty then
    DeleteRecord('агента <'+Mainqr.FieldByName('name').AsString+'> ?',tbPms_Agent,
                 'Pms_Agent_id',Mainqr.FieldByName('Pms_Agent_id').asString);
end;

procedure TfmRBPms_Agent.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPms_Agent;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPms_Agent.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.FillOffice(Mainqr.fieldByName('sync_office_id').AsInteger);
    fm.edNote.Text:=Mainqr.fieldByName('Note').AsString;
    fm.udSort.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldPms_Agent_id:=MainQr.FieldByName('Pms_Agent_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPms_Agent.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPms_Agent;
begin
 fm:=TfmEditRBPms_Agent.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.FillOffice(-1);
  
  fm.lbSortNumber.Enabled:=false;
  fm.edSort.Enabled:=false;
  fm.edSort.Color:=clBtnFace;
  fm.udSort.Enabled:=false;

  fm.edName.Text:=Filters.Items[IndexFindName].Value;
  fm.ComboBoxOffice.ItemIndex:=fm.ComboBoxOffice.Items.IndexOf(Filters.Items[IndexFindOffice].Value);
  fm.edNote.Text:=Filters.Items[IndexFindNote].Value;

  fm.cbInString.Checked:=Filters.FilterInside;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    Filters.Items[IndexFindName].Value:=Trim(fm.edName.Text);
    Filters.Items[IndexFindName].Enabled:=Trim(fm.edName.Text)<>'';
    Filters.Items[IndexFindOffice].Value:=Trim(fm.ComboBoxOffice.Text);
    Filters.Items[IndexFindOffice].Enabled:=fm.ComboBoxOffice.ItemIndex<>-1;
    Filters.Items[IndexFindNote].Value:=Trim(fm.edNote.Text);
    Filters.Items[IndexFindNote].Enabled:=Trim(fm.edNote.Text)<>'';

    Filters.FilterInside:=fm.cbInString.Checked;

    ActiveQuery(false);
  end;
 finally
  fm.Free;
 end;
end;

end.
