unit URBAPTypePremises;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypePremises = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypePremises: TfmRBAPTypePremises;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypePremises.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypePremises;
  QuerySQL:=SQLRbkAPTypePremises;
  TableName:=tbAPTypePremises;
  DeleteQuery:='тип недвидимости <%s> ?';
end;

procedure TfmRBAPTypePremises.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypePremises:=nil;
end;

end.
