unit URBAPCountRoom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPCountRoom = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPCountRoom: TfmRBAPCountRoom;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPCountRoom.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPCountRoom;
  QuerySQL:=SQLRbkAPCountRoom;
  TableName:=tbAPCountRoom;
  DeleteQuery:='комнатность <%s> ?';
end;

procedure TfmRBAPCountRoom.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPCountRoom:=nil;
end;

end.
