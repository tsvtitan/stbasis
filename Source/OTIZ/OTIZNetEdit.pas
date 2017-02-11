unit OTIZNetEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmNetEdit = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddNet:Boolean;
function EditNet(Net_Id:Integer):Boolean;
function DeleteNet(Net_Id:Integer):Boolean;

implementation

uses UMainUnited, NTimeData;

{$R *.DFM}

function AddNet:Boolean;
var frmNetEdit: TfrmNetEdit;
begin
 frmNetEdit:=TfrmNetEdit.Create(Application);
 with frmNetEdit do
 try
  ChangeDatabase(frmNetEdit,dbSTBasis);
  Caption:='Добавить сетку';
  DoSQLStr:='insert into net (name,net_id) values (''%s'',%d)';
  GetNewID:=True;
  Result:=frmNetEdit.ShowModal=mrOK;
 finally
  frmNetEdit.Free;
 end;
end;

function EditNet(Net_Id:Integer):Boolean;
var frmNetEdit: TfrmNetEdit;
begin
 Result:=False;
 frmNetEdit:=TfrmNetEdit.Create(Application);
 with frmNetEdit do
 try
  ChangeDatabase(frmNetEdit,dbSTBasis);
  CurID:=Net_ID;
  quTemp.SQL.Text:=Format('select name from net where net_id=%d',[Net_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditName.Text:=quTemp.FieldByName('name').AsString;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить сетку';
  DoSQLStr:='update net set name=''%s'' where net_id=%d';
  GetNewID:=False;
  Result:=frmNetEdit.ShowModal=mrOK;
 finally
  frmNetEdit.Free;
 end;
end;

function DeleteNet(Net_Id:Integer):Boolean;
var frmNetEdit: TfrmNetEdit;
    NetName:String;
begin
 Result:=False;
 frmNetEdit:=TfrmNetEdit.Create(Application);
 with frmNetEdit do
 try
  ChangeDatabase(frmNetEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select name from net where net_id=%d',[Net_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else NetName:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if Application.MessageBox(PChar(Format('Удалить сетку "%s"?',[NetName])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from net where net_id=%d',[Net_ID]);
   if not trTemp.InTransaction then trTemp.StartTransaction;
   try
    quTemp.ExecSQL;
    trTemp.Commit;
    Result:=True;
   except
    trTemp.Rollback;
   end;
  end;
 finally
  frmNetEdit.Free;
 end;
end;

procedure TfrmNetEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Net_ID:Integer;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if EditName.Text='' then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label1.Caption]));
   EditName.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Net_ID:=GetGenId(dbSTBasis,'net',1) else Net_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,Net_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.ExecSQL;
   trTemp.Commit;
  except
   trTemp.Rollback;
   CanClose:=False;
   {$IFDEF DEBUG}
   Raise;
   {$ENDIF}
  end;
 end;
end;

end.
