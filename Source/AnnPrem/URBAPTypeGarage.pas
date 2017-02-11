unit URBAPTypeGarage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeGarage = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeGarage: TfmRBAPTypeGarage;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeGarage.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeGarage;
  QuerySQL:=SQLRbkAPTypeGarage;
  TableName:=tbAPTypeGarage;
  DeleteQuery:='тип гаража <%s> ?';
end;

procedure TfmRBAPTypeGarage.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeGarage:=nil;
end;

end.
