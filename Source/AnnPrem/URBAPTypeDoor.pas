unit URBAPTypeDoor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeDoor = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeDoor: TfmRBAPTypeDoor;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeDoor.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeDoor;
  QuerySQL:=SQLRbkAPTypeDoor;
  TableName:=tbAPTypeDoor;
  DeleteQuery:='вид двери <%s> ?';
end;

procedure TfmRBAPTypeDoor.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeDoor:=nil;
end;

end.
