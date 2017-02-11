unit URBAPTypeInternet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeInternet = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeInternet: TfmRBAPTypeInternet;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeInternet.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeInternet;
  QuerySQL:=SQLRbkAPTypeInternet;
  TableName:=tbAPTypeInternet;
  DeleteQuery:='вид интернета <%s> ?';
end;

procedure TfmRBAPTypeInternet.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeInternet:=nil;
end;

end.
