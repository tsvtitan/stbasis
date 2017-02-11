unit ChargeGroupEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmChargeGroupEdit = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    Label2: TLabel;
    EditCode: TEdit;
    Label3: TLabel;
    EditGroup: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddChargeGroup:Boolean;
function EditChargeGroup(ChargeGroup_Id:Integer):Boolean;
function DeleteChargeGroup(ChargeGroup_Id:Integer):Boolean;

implementation

uses UMainUnited, CalendarData;

{$R *.DFM}

function AddChargeGroup:Boolean;
var frmChargeGroupEdit: TfrmChargeGroupEdit;
begin
 frmChargeGroupEdit:=TfrmChargeGroupEdit.Create(Application);
 with frmChargeGroupEdit do
 try
  ChangeDatabase(frmChargeGroupEdit,dbSTBasis);
  Caption:=CaptionChargeGroupAdd;
  DoSQLStr:=sqlAddChargeGroup;
  GetNewID:=True;
  Result:=frmChargeGroupEdit.ShowModal=mrOK;
 finally
  frmChargeGroupEdit.Free;
 end;
end;

function EditChargeGroup(ChargeGroup_Id:Integer):Boolean;
var frmChargeGroupEdit: TfrmChargeGroupEdit;
begin
 Result:=False;
 frmChargeGroupEdit:=TfrmChargeGroupEdit.Create(Application);
 with frmChargeGroupEdit do
 try
  ChangeDatabase(frmChargeGroupEdit,dbSTBasis);
  CurID:=ChargeGroup_ID;
  quTemp.SQL.Text:=Format(sqlSelChargeGroup,[ChargeGroup_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else begin
    EditName.Text:=quTemp.FieldByName(fldChargeGroupName).AsString;
    EditCode.Text:=quTemp.FieldByName(fldChargeGroupCode).AsString;
    EditGroup.Text:=quTemp.FieldByName(fldChargeGroupGroupID).AsString;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionChargeGroupUpdate;
  DoSQLStr:=sqlUpdChargeGroup;
  GetNewID:=False;
  Result:=frmChargeGroupEdit.ShowModal=mrOK;
 finally
  frmChargeGroupEdit.Free;
 end;
end;

function DeleteChargeGroup(ChargeGroup_Id:Integer):Boolean;
var frmChargeGroupEdit: TfrmChargeGroupEdit;
    ChargeGroupName:String;
begin
 Result:=False;
 frmChargeGroupEdit:=TfrmChargeGroupEdit.Create(Application);
 with frmChargeGroupEdit do
 try
  ChangeDatabase(frmChargeGroupEdit,dbSTBasis);
  quTemp.SQL.Text:=Format(sqlSelChargeGroup,[ChargeGroup_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else ChargeGroupName:=quTemp.FieldByName(fldChargeGroupName).AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if ShowQuestion(Handle,Format(CaptionChargeGroupDelete,[ChargeGroupName]))=mrYes then
  begin
   quTemp.SQL.Text:=Format(sqlDelChargeGroup,[ChargeGroup_ID]);
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
  frmChargeGroupEdit.Free;
 end;
end;

procedure TfrmChargeGroupEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var ChargeGroup_ID:Integer;
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
  if EditCode.Text='' then
  begin
   ShowInfo(Handle,Format(ConstFieldNoEmpty,[Label2.Caption]));
   EditCode.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if EditGroup.Text='' then
  begin
   ShowInfo(Handle,Format(ConstFieldNoEmpty,[Label3.Caption]));
   EditGroup.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then ChargeGroup_ID:=GetGenId(dbSTBasis,tbChargeGroup,1) else ChargeGroup_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,EditCode.Text,EditGroup.Text,ChargeGroup_ID]);
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
