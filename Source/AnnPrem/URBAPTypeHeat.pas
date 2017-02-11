unit URBAPTypeHeat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeHeat = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeHeat: TfmRBAPTypeHeat;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeHeat.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeHeat;
  QuerySQL:=SQLRbkAPTypeHeat;
  TableName:=tbAPTypeHeat;
  DeleteQuery:='вид отопления <%s> ?';
end;

procedure TfmRBAPTypeHeat.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeHeat:=nil;
end;

end.
