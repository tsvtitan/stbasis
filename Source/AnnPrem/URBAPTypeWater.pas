unit URBAPTypeWater;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeWater = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeWater: TfmRBAPTypeWater;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeWater.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeWater;
  QuerySQL:=SQLRbkAPTypeWater;
  TableName:=tbAPTypeWater;
  DeleteQuery:='вид водоснабжения <%s> ?';
end;

procedure TfmRBAPTypeWater.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeWater:=nil;
end;

end.
