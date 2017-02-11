unit NTimeShiftEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmShiftEdit = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    EditPercent: TRxSpinEdit;
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

function AddShift:Boolean;
function EditShift(Shift_Id:Integer):Boolean;
function DeleteShift(Shift_Id:Integer):Boolean;

implementation

uses UMainUnited, NTimeData;

{$R *.DFM}

function AddShift:Boolean;
var frmShiftEdit: TfrmShiftEdit;
begin
 frmShiftEdit:=TfrmShiftEdit.Create(Application);
 with frmShiftEdit do
 try
  ChangeDatabase(frmShiftEdit,dbSTBasis);
  Caption:=CaptionShiftAdd;
  DoSQLStr:=sqlAddShift;
  GetNewID:=True;
  Result:=frmShiftEdit.ShowModal=mrOK;
 finally
  frmShiftEdit.Free;
 end;
end;

function EditShift(Shift_Id:Integer):Boolean;
var frmShiftEdit: TfrmShiftEdit;
begin
 Result:=False;
 frmShiftEdit:=TfrmShiftEdit.Create(Application);
 with frmShiftEdit do
 try
  ChangeDatabase(frmShiftEdit,dbSTBasis);
  CurID:=Shift_ID;
  quTemp.SQL.Text:=Format(sqlSelShift,[Shift_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else begin
    EditName.Text:=quTemp.FieldByName(fldShiftName).AsString;
    EditPercent.Value:=quTemp.FieldByName(fldShiftAddPayPercent).AsInteger;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionShiftUpdate;
  DoSQLStr:=sqlUpdShift;
  GetNewID:=False;
  Result:=frmShiftEdit.ShowModal=mrOK;
 finally
  frmShiftEdit.Free;
 end;
end;

function DeleteShift(Shift_Id:Integer):Boolean;
var frmShiftEdit: TfrmShiftEdit;
    ShiftName:String;
begin
 Result:=False;
 frmShiftEdit:=TfrmShiftEdit.Create(Application);
 with frmShiftEdit do
 try
  ChangeDatabase(frmShiftEdit,dbSTBasis);
  quTemp.SQL.Text:=Format(sqlSelShift,[Shift_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else ShiftName:=quTemp.FieldByName(fldShiftName).AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if ShowQuestion(Handle,Format(CaptionShiftDelete,[ShiftName]))=mrYes then
  begin
   quTemp.SQL.Text:=Format(sqlDelShift,[shift_ID]);
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
  frmShiftEdit.Free;
 end;
end;

procedure TfrmShiftEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Shift_ID:Integer;
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
  if GetNewID then Shift_ID:=GetGenId(dbSTBasis,tbShift,1) else Shift_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,EditPercent.AsInteger,Shift_ID]);
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
