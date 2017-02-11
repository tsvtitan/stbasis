unit URBAPTypeBuilding;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeBuilding = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeBuilding: TfmRBAPTypeBuilding;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeBuilding.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeBuilding;
  QuerySQL:=SQLRbkAPTypeBuilding;
  TableName:=tbAPTypeBuilding;
  DeleteQuery:='тип дома <%s> ?';
end;

procedure TfmRBAPTypeBuilding.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeBuilding:=nil;
end;

end.
