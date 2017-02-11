unit URBAPTypeFurniture;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeFurniture = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeFurniture: TfmRBAPTypeFurniture;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeFurniture.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeFurniture;
  QuerySQL:=SQLRbkAPTypeFurniture;
  TableName:=tbAPTypeFurniture;
  DeleteQuery:='вид мебели <%s> ?';
end;

procedure TfmRBAPTypeFurniture.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeFurniture:=nil;
end;

end.
