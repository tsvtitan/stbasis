unit URBAPPlanning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPPlanning = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPPlanning: TfmRBAPPlanning;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPPlanning.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPPlanning;
  QuerySQL:=SQLRbkAPPlanning;
  TableName:=tbAPPlanning;
  DeleteQuery:='планировку <%s> ?';
end;

procedure TfmRBAPPlanning.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPPlanning:=nil;
end;

end.
