unit RoundTypeEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmRoundTypeEdit = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    EditFactor: TComboBox;
    Label2: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddRoundType:Boolean;
function EditRoundType(RoundType_Id:Integer):Boolean;
function DeleteRoundType(RoundType_Id:Integer):Boolean;

implementation

uses UMainUnited, CalendarData;

{$R *.DFM}

function AddRoundType:Boolean;
var frmRoundTypeEdit: TfrmRoundTypeEdit;
begin
 frmRoundTypeEdit:=TfrmRoundTypeEdit.Create(Application);
 with frmRoundTypeEdit do
 try
  ChangeDatabase(frmRoundTypeEdit,dbSTBasis);
  Caption:=CaptionRoundTypeAdd;
  DoSQLStr:=sqlAddRoundType;
  GetNewID:=True;
  Result:=frmRoundTypeEdit.ShowModal=mrOK;
 finally
  frmRoundTypeEdit.Free;
 end;
end;

function EditRoundType(RoundType_Id:Integer):Boolean;
var frmRoundTypeEdit: TfrmRoundTypeEdit;
begin
 Result:=False;
 frmRoundTypeEdit:=TfrmRoundTypeEdit.Create(Application);
 with frmRoundTypeEdit do
 try
  ChangeDatabase(frmRoundTypeEdit,dbSTBasis);
  CurID:=RoundType_ID;
  quTemp.SQL.Text:=Format(sqlSelRoundType,[RoundType_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else begin
    EditName.Text:=quTemp.FieldByName(fldRoundTypeName).AsString;
    EditFactor.ItemIndex:=quTemp.FieldByName(fldRoundTypeFactor).AsInteger+2;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionRoundTypeUpdate;
  DoSQLStr:=sqlUpdRoundType;
  GetNewID:=False;
  Result:=frmRoundTypeEdit.ShowModal=mrOK;
 finally
  frmRoundTypeEdit.Free;
 end;
end;

function DeleteRoundType(RoundType_Id:Integer):Boolean;
var frmRoundTypeEdit: TfrmRoundTypeEdit;
    RoundTypeName:String;
begin
 Result:=False;
 frmRoundTypeEdit:=TfrmRoundTypeEdit.Create(Application);
 with frmRoundTypeEdit do
 try
  ChangeDatabase(frmRoundTypeEdit,dbSTBasis);
  quTemp.SQL.Text:=Format(sqlSelRoundType,[RoundType_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else RoundTypeName:=quTemp.FieldByName(fldRoundTypeName).AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if ShowQuestion(Handle,Format(CaptionRoundTypeDelete,[RoundTypeName]))=mrYes then
  begin
   quTemp.SQL.Text:=Format(sqlDelRoundType,[RoundType_ID]);
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
  frmRoundTypeEdit.Free;
 end;
end;

procedure TfrmRoundTypeEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var RoundType_ID:Integer;
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
  if EditFactor.ItemIndex=-1 then
  begin
   ShowInfo(Handle,Format(ConstFieldNoEmpty,[Label2.Caption]));
   EditFactor.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then RoundType_ID:=GetGenId(dbSTBasis,tbRoundType,1) else RoundType_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,EditFactor.ItemIndex-2,RoundType_ID]);
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
