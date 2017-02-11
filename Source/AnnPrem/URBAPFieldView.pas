unit URBAPFieldView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls, UEditRBAP, UEditRBAPFieldView;

type
  TfmRBAPFieldView = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FIndexFindFields: Integer;
  protected
    procedure InitFilters; override;
    function GetEditClass: TfmEditRBAPClass; override;
  public
    property IndexFindFields: Integer read FIndexFindFields write FIndexFindFields;
  end;

var
  fmRBAPFieldView: TfmRBAPFieldView;

implementation

uses UAnnPremData, UMainUnited;

{$R *.DFM}

procedure TfmRBAPFieldView.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPFieldView;
  QuerySQL:=SQLRbkAPFieldView;
  TableName:=tbAPFieldView;
  DeleteQuery:='представление <%s> ?';
end;

procedure TfmRBAPFieldView.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPFieldView:=nil;
end;

procedure TfmRBAPFieldView.InitFilters;
begin
  inherited InitFilters;
  FIndexFindFields:=Filters.Add('FIELDS',tdbcLike,false).Index;
end;

function TfmRBAPFieldView.GetEditClass: TfmEditRBAPClass;
begin
  Result:=TfmEditRBAPFieldView;
end;

end.
