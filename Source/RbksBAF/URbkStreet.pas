unit URbkStreet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkATE, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls;

type
  TFmRbkStreet = class(TFmRbkATE)
    procedure BtDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmRbkStreet: TFmRbkStreet;

implementation
Uses UMainUnited, Uconst;

{$R *.DFM}

procedure TFmRbkStreet.BtDelClick(Sender: TObject);
begin
  DeletingRec:='улицу <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkStreet.FormCreate(Sender: TObject);
begin
  TableName:=tbStreet;
  Caption:=NameStreet;
  inherited;
end;

procedure TFmRbkStreet.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkStreet:=nil;
end;

end.
