unit URBAPTypePlate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypePlate = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypePlate: TfmRBAPTypePlate;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypePlate.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypePlate;
  QuerySQL:=SQLRbkAPTypePlate;
  TableName:=tbAPTypePlate;
  DeleteQuery:='вид плиты <%s> ?';
end;

procedure TfmRBAPTypePlate.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypePlate:=nil;
end;

end.
