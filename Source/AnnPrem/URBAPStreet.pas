unit URBAPStreet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPStreet = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPStreet: TfmRBAPStreet;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPStreet.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPStreet;
  QuerySQL:=SQLRbkAPStreet;
  TableName:=tbAPStreet;
  DeleteQuery:='улицу <%s> ?';
end;

procedure TfmRBAPStreet.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPStreet:=nil;
end;

end.
