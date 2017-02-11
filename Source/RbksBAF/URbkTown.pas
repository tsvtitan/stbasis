unit URbkTown;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkATE, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls;

type
  TFmRbkTown = class(TFmRbkATE)
    procedure FormCreate(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmRbkTown: TFmRbkTown;

implementation
Uses UMainUnited, Uconst;
{$R *.DFM}

procedure TFmRbkTown.FormCreate(Sender: TObject);
begin
  TableName:=tbTown;
  Caption:=NameTown;
  inherited;
end;

procedure TFmRbkTown.BtDelClick(Sender: TObject);
begin
  DeletingRec:='город <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkTown.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkTown:=nil;
end;

end.
