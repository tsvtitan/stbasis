unit URBAPUnitPrice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPUnitPrice = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPUnitPrice: TfmRBAPUnitPrice;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPUnitPrice.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPUnitPrice;
  QuerySQL:=SQLRbkAPUnitPrice;
  TableName:=tbAPUnitPrice;
  DeleteQuery:='единицу измерения <%s> ?';
end;

procedure TfmRBAPUnitPrice.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPUnitPrice:=nil;
end;

end.
