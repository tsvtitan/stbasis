unit URbkPlacement;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkATE, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  DBCtrls, ExtCtrls;

type
  TFmRbkPlacement = class(TFmRbkATE)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmRbkPlacement: TFmRbkPlacement;

implementation
Uses UmainUnited, UConst;

{$R *.DFM}

procedure TFmRbkPlacement.FormCreate(Sender: TObject);
begin
  TableName:=tbPlacement;
  Caption:=NamePlacement;
  inherited;
end;

procedure TFmRbkPlacement.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then  fmRbkPlacement:=nil;
end;

end.
