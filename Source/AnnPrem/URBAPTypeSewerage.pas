unit URBAPTypeSewerage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeSewerage = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeSewerage: TfmRBAPTypeSewerage;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeSewerage.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeSewerage;
  QuerySQL:=SQLRbkAPTypeSewerage;
  TableName:=tbAPTypeSewerage;
  DeleteQuery:='вид канализации <%s> ?';
end;

procedure TfmRBAPTypeSewerage.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeSewerage:=nil;
end;

end.
