unit URBAPStyle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPStyle = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPStyle: TfmRBAPStyle;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPStyle.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPStyle;
  QuerySQL:=SQLRbkAPStyle;
  TableName:=tbAPStyle;
  DeleteQuery:='стиль <%s> ?';
end;

procedure TfmRBAPStyle.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPStyle:=nil;
end;

end.
