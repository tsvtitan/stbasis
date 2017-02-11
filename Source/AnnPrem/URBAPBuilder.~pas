unit URBAPBuilder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery, DBGrids,
  DBCtrls, StdCtrls, ExtCtrls, UEditRBAP, UEditRBAPBuilder;

type
  TfmRBAPBuilder = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FIndexFindPhones: Integer;
    FIndexFindAddress: Integer;
    FIndexFindSite: Integer;
    FIndexFindEmail: Integer;
  protected
    procedure InitColumns; override;
    procedure InitFilters; override;
    procedure InitOrders; override;
    function GetSortFieldName(FieldName: String): String; override;
    function GetEditClass: TfmEditRBAPClass; override;
  public
    property IndexFindPhones: Integer read FIndexFindPhones write FIndexFindPhones;
    property IndexFindAddress: Integer read FIndexFindAddress write FIndexFindAddress;
    property IndexFindSite: Integer read FIndexFindSite write FIndexFindSite;
    property IndexFindEmail: Integer read FIndexFindEmail write FIndexFindEmail;
  end;

var
  fmRBAPBuilder: TfmRBAPBuilder;

implementation

uses UMainUnited, UAnnPremData;

{$R *.DFM}

procedure TfmRBAPBuilder.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPBuilder;
  QuerySQL:=SQLRbkAPBuilder;
  TableName:=tbAPBuilder;
  DeleteQuery:='застройщика <%s> ?';
end;

procedure TfmRBAPBuilder.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPBuilder:=nil;
end;

procedure TfmRBAPBuilder.InitColumns;
var
  cl: TColumn;
begin
  inherited InitColumns;

  cl:=Grid.Columns.Add;
  cl.FieldName:='ADDRESS';
  cl.Title.Caption:='Адрес';
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.FieldName:='PHONES';
  cl.Title.Caption:='Телефоны';
  cl.Width:=100;
end;

procedure TfmRBAPBuilder.InitFilters;
begin
  inherited InitFilters;
  Filters.Items[IndexFindName].FieldName:='NAME';
  Filters.Items[IndexFindFullName].FieldName:='FULLNAME';
  FIndexFindPhones:=Filters.Add('PHONES',tdbcLike,false).Index;
  FIndexFindAddress:=Filters.Add('ADDRESS',tdbcLike,false).Index;
  FIndexFindSite:=Filters.Add('SITE',tdbcLike,false).Index;
  FIndexFindEmail:=Filters.Add('EMAIL',tdbcLike,false).Index;
end;

procedure TfmRBAPBuilder.InitOrders;
begin
  inherited InitOrders;
  DefaultOrders.Items[0].FieldName:='NAME';
  DefaultOrders.Items[1].FieldName:='FULLNAME';
  DefaultOrders.Items[2].FieldName:='PRIORITY';
end;

function TfmRBAPBuilder.GetEditClass: TfmEditRBAPClass;
begin
  Result:=TfmEditRBAPBuilder;
end;

function TfmRBAPBuilder.GetSortFieldName(FieldName: String): String;
begin
  Result:=inherited GetSortFieldName(FieldName);
  if AnsiSameText(FieldName,'NAME') then Result:='NAME';
  if AnsiSameText(FieldName,'FULLNAME') then Result:='FULLNAME';
  if AnsiSameText(FieldName,'PRIORITY') then Result:='PRIORITY';
end;

end.
