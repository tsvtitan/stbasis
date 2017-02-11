unit OTIZCategoryEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery, Mask,
  ToolEdit;

type
  TfrmCategoryEdit = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    Label2: TLabel;
    ComboEdit1: TComboEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComboEdit1ButtonClick(Sender: TObject);
  private
   CurID:Integer;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddCategory:Boolean;
function EditCategory(Category_Id:Integer):Boolean;
function DeleteCategory(Category_Id:Integer):Boolean;

implementation

uses UMainUnited, NTimeData, NTimeCode;

{$R *.DFM}

function AddCategory:Boolean;
var frmCategoryEdit: TfrmCategoryEdit;
begin
 frmCategoryEdit:=TfrmCategoryEdit.Create(Application);
 with frmCategoryEdit do
 try
  ChangeDatabase(frmCategoryEdit,dbSTBasis);
  Caption:='Добавить категорию';
  DoSQLStr:='insert into category (name,categorytype_id,category_id) values (''%s'',%s,%d)';
  GetNewID:=True;
  Result:=frmCategoryEdit.ShowModal=mrOK;
 finally
  frmCategoryEdit.Free;
 end;
end;

function EditCategory(Category_Id:Integer):Boolean;
var frmCategoryEdit: TfrmCategoryEdit;
begin
 Result:=False;
 frmCategoryEdit:=TfrmCategoryEdit.Create(Application);
 with frmCategoryEdit do
 try
  ChangeDatabase(frmCategoryEdit,dbSTBasis);
  CurID:=Category_ID;
  quTemp.SQL.Text:=Format('select c.name,c.categorytype_id,t.name as typename from category c left join categorytype t on c.categorytype_id=t.categorytype_id where c.category_id=%d',[Category_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditName.Text:=quTemp.FieldByName('name').AsString;
    ComboEdit1.Text:=quTemp.FieldByName('typename').AsString;
    ComboEdit1.Tag:=quTemp.FieldByName('categorytype_id').AsInteger;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:='Изменить категорию';
  DoSQLStr:='update category set name=''%s'',categorytype_id=%s where category_id=%d';
  GetNewID:=False;
  Result:=frmCategoryEdit.ShowModal=mrOK;
 finally
  frmCategoryEdit.Release;
 end;
end;

function DeleteCategory(Category_Id:Integer):Boolean;
var frmCategoryEdit: TfrmCategoryEdit;
    CategoryName:String;
begin
 Result:=False;
 frmCategoryEdit:=TfrmCategoryEdit.Create(Application);
 with frmCategoryEdit do
 try
  ChangeDatabase(frmCategoryEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select name from category where category_id=%d',[Category_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else CategoryName:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if Application.MessageBox(PChar(Format('Удалить категорию "%s"?',[CategoryName])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from category where category_id=%d',[Category_ID]);
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
  frmCategoryEdit.Free;
 end;
end;

procedure TfrmCategoryEdit.ComboEdit1ButtonClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 Data.Visual.TypeView:=tvibvModal;
 Data.Locate.KeyFields:='categorytype_id';
 Data.Locate.KeyValues:=ComboEdit1.Tag;
 Data.Locate.Options:=[];
 if _ViewInterfaceFromName(IntNameCategoryType,@Data) then
 begin
  ComboEdit1.Tag:=GetFirstValueFromParamRBookInterface(@Data,'categorytype_id');
  quTemp.SQL.Text:=Format('select name from categorytype where categorytype_id=%d',[ComboEdit1.Tag]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then ComboEdit1.Text:=''
    else ComboEdit1.Text:=quTemp.FieldByName('name').AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
 end;
end;

procedure TfrmCategoryEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Category_ID:Integer;
    S1:String;
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
  if ComboEdit1.Enabled and (ComboEdit1.Text='') then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле <%s>.',[Label2.Caption]));
   ComboEdit1.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Category_ID:=GetGenId(dbSTBasis,'category',1) else Category_ID:=CurID;
  if ComboEdit1.Tag=0 then S1:='null' else S1:=IntToStr(ComboEdit1.Tag);
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,S1,Category_ID]);
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
