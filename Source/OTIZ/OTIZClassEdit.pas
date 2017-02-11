unit OTIZClassEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmClassEdit = class(TForm)
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

function AddClass:Boolean;
function EditClass(Class_Id:Integer):Boolean;
function DeleteClass(Class_Id:Integer):Boolean;

implementation

uses UMainUnited, NTimeData;

{$R *.DFM}

function AddClass:Boolean;
var frmClassEdit: TfrmClassEdit;
begin
 frmClassEdit:=TfrmClassEdit.Create(Application);
 with frmClassEdit do
 try
  ChangeDatabase(frmClassEdit,dbSTBasis);
  Caption:='Добавить разряд';
  DoSQLStr:='insert into class (num,class_id) values (''%s'',%d)';
  GetNewID:=True;
  Result:=frmClassEdit.ShowModal=mrOK;
 finally
  frmClassEdit.Free;
 end;
end;

function EditClass(Class_Id:Integer):Boolean;
var frmClassEdit: TfrmClassEdit;
begin
 Result:=False;
 frmClassEdit:=TfrmClassEdit.Create(Application);
 with frmClassEdit do
 try
  ChangeDatabase(frmClassEdit,dbSTBasis);
  CurID:=Class_ID;
  quTemp.SQL.Text:=Format('select num from class where class_id=%d',[Class_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditName.Text:=quTemp.FieldByName('num').AsString;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить разряд';
  DoSQLStr:='update class set num=''%s'' where class_id=%d';
  GetNewID:=False;
  Result:=frmClassEdit.ShowModal=mrOK;
 finally
  frmClassEdit.Free;
 end;
end;

function DeleteClass(Class_Id:Integer):Boolean;
var frmClassEdit: TfrmClassEdit;
    ClassNum:String;
begin
 Result:=False;
 frmClassEdit:=TfrmClassEdit.Create(Application);
 with frmClassEdit do
 try
  ChangeDatabase(frmClassEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select num from class where class_id=%d',[Class_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else ClassNum:=quTemp.FieldByName('num').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if Application.MessageBox(PChar(Format('Удалить разряд "%s"?',[ClassNum])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from class where class_id=%d',[Class_ID]);
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
  frmClassEdit.Free;
 end;
end;

procedure TfrmClassEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Class_ID:Integer;
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
  if GetNewID then Class_ID:=GetGenId(dbSTBasis,'class',1) else Class_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,Class_ID]);
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
