unit OTIZCategoryTypeEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmCategoryTypeEdit = class(TForm)
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

function AddCategoryType:Boolean;
function EditCategoryType(CategoryType_Id:Integer):Boolean;
function DeleteCategoryType(CategoryType_Id:Integer):Boolean;

implementation

uses UMainUnited, NTimeData;

{$R *.DFM}

function AddCategoryType:Boolean;
var frmCategoryTypeEdit: TfrmCategoryTypeEdit;
begin
 frmCategoryTypeEdit:=TfrmCategoryTypeEdit.Create(Application);
 with frmCategoryTypeEdit do
 try
  ChangeDatabase(frmCategoryTypeEdit,dbSTBasis);
  Caption:=CaptionCategoryTypeAdd;
  DoSQLStr:=sqlAddCategoryType;
  GetNewID:=True;
  Result:=frmCategoryTypeEdit.ShowModal=mrOK;
 finally
  frmCategoryTypeEdit.Free;
 end;
end;

function EditCategoryType(CategoryType_Id:Integer):Boolean;
var frmCategoryTypeEdit: TfrmCategoryTypeEdit;
begin
 Result:=False;
 frmCategoryTypeEdit:=TfrmCategoryTypeEdit.Create(Application);
 with frmCategoryTypeEdit do
 try
  ChangeDatabase(frmCategoryTypeEdit,dbSTBasis);
  CurID:=CategoryType_ID;
  quTemp.SQL.Text:=Format(sqlSelCategoryType,[CategoryType_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else begin
    EditName.Text:=quTemp.FieldByName(fldCategoryTypeName).AsString;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionCategoryTypeUpdate;
  DoSQLStr:=sqlUpdCategoryType;
  GetNewID:=False;
  Result:=frmCategoryTypeEdit.ShowModal=mrOK;
 finally
  frmCategoryTypeEdit.Free;
 end;
end;

function DeleteCategoryType(CategoryType_Id:Integer):Boolean;
var frmCategoryTypeEdit: TfrmCategoryTypeEdit;
    CategoryTypeName:String;
begin
 Result:=False;
 frmCategoryTypeEdit:=TfrmCategoryTypeEdit.Create(Application);
 with frmCategoryTypeEdit do
 try
  ChangeDatabase(frmCategoryTypeEdit,dbSTBasis);
  quTemp.SQL.Text:=Format(sqlSelCategoryType,[CategoryType_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else CategoryTypeName:=quTemp.FieldByName(fldCategoryTypeName).AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if ShowQuestion(Handle,Format(CaptionCategoryTypeDelete,[CategoryTypeName]))=mrYes then
  begin
   quTemp.SQL.Text:=Format(sqlDelCategoryType,[CategoryType_ID]);
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
  frmCategoryTypeEdit.Free;
 end;
end;

procedure TfrmCategoryTypeEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var CategoryType_ID:Integer;
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if EditName.Text='' then
  begin
   ShowInfo(Handle,Format(ConstFieldNoEmpty,[Label1.Caption]));
   EditName.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then CategoryType_ID:=GetGenId(dbSTBasis,tbCategoryType,1) else CategoryType_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,CategoryType_ID]);
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
