unit URBAPTypeSanitary;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeSanitary = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeSanitary: TfmRBAPTypeSanitary;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeSanitary.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeSanitary;
  QuerySQL:=SQLRbkAPTypeSanitary;
  TableName:=tbAPTypeSanitary;
  DeleteQuery:='вид санузла <%s> ?';
end;

procedure TfmRBAPTypeSanitary.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeSanitary:=nil;
end;

end.
