unit URBAPTypeBath;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeBath = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeBath: TfmRBAPTypeBath;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeBath.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeBath;
  QuerySQL:=SQLRbkAPTypeBath;
  TableName:=tbAPTypeBath;
  DeleteQuery:='тип бани <%s> ?';
end;

procedure TfmRBAPTypeBath.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeBath:=nil;
end;

end.
