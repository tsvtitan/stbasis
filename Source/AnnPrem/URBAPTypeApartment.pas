unit URBAPTypeApartment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeApartment = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeApartment: TfmRBAPTypeApartment;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeApartment.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeApartment;
  QuerySQL:=SQLRbkAPTypeApartment;
  TableName:=tbAPTypeApartment;
  DeleteQuery:='тип квартиры <%s> ?';
end;

procedure TfmRBAPTypeApartment.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeApartment:=nil;
end;

end.
