unit URBAPTypePhone;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypePhone = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypePhone: TfmRBAPTypePhone;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypePhone.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypePhone;
  QuerySQL:=SQLRbkAPTypePhone;
  TableName:=tbAPTypePhone;
  DeleteQuery:='вид телефона <%s> ?';
end;

procedure TfmRBAPTypePhone.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypePhone:=nil;
end;

end.
