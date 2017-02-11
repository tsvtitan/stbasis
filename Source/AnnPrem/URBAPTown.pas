unit URBAPTown;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTown = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTown: TfmRBAPTown;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTown.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTown;
  QuerySQL:=SQLRbkAPTown;
  TableName:=tbAPTown;
  DeleteQuery:='город <%s> ?';
end;

procedure TfmRBAPTown.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTown:=nil;
end;

end.
