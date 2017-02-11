unit URBAPHomeTech;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPHomeTech = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPHomeTech: TfmRBAPHomeTech;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPHomeTech.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPHomeTech;
  QuerySQL:=SQLRbkAPHomeTech;
  TableName:=tbAPHomeTech;
  DeleteQuery:='бытовую технику <%s> ?';
end;

procedure TfmRBAPHomeTech.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPHomeTech:=nil;
end;

end.
