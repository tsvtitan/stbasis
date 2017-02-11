unit URBAPTypeBalcony;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBAP, Menus, IBCustomDataSet, IBUpdateSQL, IBDatabase, Db, IBQuery,
  DBCtrls, StdCtrls, ExtCtrls;

type
  TfmRBAPTypeBalcony = class(TfmRBAP)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRBAPTypeBalcony: TfmRBAPTypeBalcony;

implementation

uses UAnnPremData;

{$R *.DFM}

procedure TfmRBAPTypeBalcony.FormCreate(Sender: TObject);
begin
  inherited;
  Caption:=NameRbkAPTypeBalcony;
  QuerySQL:=SQLRbkAPTypeBalcony;
  TableName:=tbAPTypeBalcony;
  DeleteQuery:='вид балкона <%s> ?';
end;

procedure TfmRBAPTypeBalcony.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
    fmRBAPTypeBalcony:=nil;
end;

end.
