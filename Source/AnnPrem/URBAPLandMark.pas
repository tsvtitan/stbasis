unit URBAPLandMark;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPLandMark = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPLandMark: TfmRBAPLandMark;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPLandMark.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPLandMark;
  QuerySQL:=SQLRbkAPLandMark;
  TableName:=tbAPLandMark;
  DeleteQuery:='ориентир <%s> ?';
end;

procedure TfmRBAPLandMark.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPLandMark:=nil;
end;

end.
