unit URbkState;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkATE, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls;

type
  TFmRbkState = class(TFmRbkATE)
    procedure FormCreate(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmRbkState: TFmRbkState;

implementation
Uses UMainUnited, Uconst;
{$R *.DFM}

procedure TFmRbkState.FormCreate(Sender: TObject);
begin
  TableName:=tbState;
  Caption:=NameState;
  inherited;
end;

procedure TFmRbkState.BtDelClick(Sender: TObject);
begin
  DeletingRec:='נאימם <'+RbkQuery.FieldByName('Name').AsString+'> ?';
  inherited;
end;

procedure TFmRbkState.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRBkState:=nil;
end;

end.
