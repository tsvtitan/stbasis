unit URBAPTypeCondition;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeCondition = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeCondition: TfmRBAPTypeCondition;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeCondition.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeCondition;
  QuerySQL:=SQLRbkAPTypeCondition;
  TableName:=tbAPTypeCondition;
  DeleteQuery:='вид состояния <%s> ?';
end;

procedure TfmRBAPTypeCondition.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeCondition:=nil;
end;

end.
