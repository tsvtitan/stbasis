unit URBAP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db,
  IBQuery, DBCtrls, StdCtrls, ExtCtrls, dbgrids, tsvDbGrid, 
  UEditRBAP;

type
  TfmRBAP = class(TfmRBMainGrid)
    procedure FormCreate(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    FQuerySQL: String;
    FIndexFindName: Integer;
    FIndexFindFullName: Integer;
    FIndexFindVariant: Integer;
    FFieldKeyName: String;
    FTableName: String;
    FDeleteQuery: String;

    procedure SetTableName(Value: String);
  protected
    procedure InitColumns; virtual;
    procedure InitFilters; virtual;
    procedure InitOrders; virtual;
    function GetSortFieldName(FieldName: String): String; virtual;
    function GetSql: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetEditClass: TfmEditRBAPClass; virtual;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;

    property QuerySQL: String read FQuerySQL write FQuerySQL;
    property FieldKeyName: String read FFieldKeyName write FFieldKeyName;
    property TableName: String read FTableName write SetTableName;
    property DeleteQuery: String read FDeleteQuery write FDeleteQuery;

    property IndexFindName: Integer read FIndexFindName write FIndexFindName;
    property IndexFindFullName: Integer read FIndexFindFullName write FIndexFindFullName;
    property IndexFindVariant: Integer read FIndexFindVariant write FIndexFindVariant;

  end;

var
  fmRBAP: TfmRBAP;

implementation

uses UMainUnited, UAnnPremCode, UAnnPremDM, UAnnPremData;

{$R *.DFM}

procedure TfmRBAP.FormCreate(Sender: TObject);
begin
  inherited;
  Mainqr.Database:=IBDB;
  Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  InitColumns;
  InitFilters;
  InitOrders;
  LoadFromIni;
end;

procedure TfmRBAP.InitColumns;
var
  cl: TColumn;
begin
  Grid.Columns.Clear;

  cl:=Grid.Columns.Add;
  cl.FieldName:='NAME';
  cl.Title.Caption:='Наименование';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='FULLNAME';
  cl.Title.Caption:='Полное';
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.FieldName:='PRIORITY';
  cl.Title.Caption:='Порядок';
  cl.Width:=80;
end;

procedure TfmRBAP.InitFilters; 
begin
  Filters.Clear;
  FIndexFindName:=Filters.Add('NAME',tdbcLike,false).Index;
  FIndexFindFullName:=Filters.Add('FULLNAME',tdbcLike,false).Index;
  FIndexFindVariant:=Filters.Add('VARIANT',tdbcLike,false).Index;
end;

procedure TfmRBAP.InitOrders;
begin
  DefaultOrders.Clear;
  DefaultOrders.Add('Наименование','NAME',false,tdboAsc);
  DefaultOrders.Add('Полное','FULLNAME',false,tdboAsc);
  DefaultOrders.Add('Порядок','PRIORITY',true,tdboAsc);
end;

function TfmRBAP.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=FQuerySQL+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAP.ActiveQuery(CheckPerm: Boolean);
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

function TfmRBAP.GetSortFieldName(FieldName: String): String;
begin
  Result:=FieldName;
end;

procedure TfmRBAP.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); 
var
  fn: string;
  id: string;
begin
  try
    if not MainQr.Active then exit;
    fn:=GetSortFieldName(Column.FieldName);
    id:=MainQr.fieldByName(FFieldKeyName).asString;
    SetLastOrderFromTypeSort(fn,TypeSort);
    ActiveQuery(false);
    MainQr.First;
    MainQr.Locate(FFieldKeyName,id,[loCaseInsensitive]);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRBAP.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAP;
begin
  if not Mainqr.Active then exit;
  fm:=GetEditClass.Create(nil);
  try
    fm.ParentForm:=Self;
    fm.InitAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate(FFieldKeyName,fm.OldFieldKeyValue,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAP.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAP;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=GetEditClass.Create(nil);
  try
    fm.ParentForm:=Self;
    fm.InitUpdate;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      MainQr.Locate(FFieldKeyName,fm.OldFieldKeyValue,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAP.bibDelClick(Sender: TObject);
begin
  if not Mainqr.IsEmpty then
    DeleteRecord(Format(FDeleteQuery,[Mainqr.FieldByName('NAME').AsString]),
                 FTableName,FFieldKeyName,Mainqr.FieldByName(FFieldKeyName).asString);
end;

procedure TfmRBAP.SetTableName(Value: String);
begin
  FTableName:=Value;
  FFieldKeyName:=Value+'_ID';
end;

procedure TfmRBAP.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAP;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=GetEditClass.Create(nil);
  try
    fm.ParentForm:=Self;
    fm.InitView;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBAP.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAP;
begin
  fm:=GetEditClass.Create(nil);
  try
    fm.ParentForm:=Self;
    fm.InitFilter;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrOk then begin
      inherited;
      fm.DoneFilter;
      ActiveQuery(false);
    end;
  finally
    fm.Free;
  end;
end;

function TfmRBAP.GetEditClass: TfmEditRBAPClass;
begin
  Result:=TfmEditRBAP;
end;

end.
