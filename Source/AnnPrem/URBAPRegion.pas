unit URBAPRegion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPRegion = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPRegion: TfmRBAPRegion;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPRegion.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPRegion;
  QuerySQL:=SQLRbkAPRegion;
  TableName:=tbAPRegion;
  DeleteQuery:='נאימם <%s> ?';
end;

procedure TfmRBAPRegion.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPRegion:=nil;
end;

end.
