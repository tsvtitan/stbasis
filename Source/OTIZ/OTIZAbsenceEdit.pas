unit OTIZAbsenceEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, IBDatabase, Db, IBCustomDataSet, IBQuery;

type
  TfrmAbsenceEdit = class(TForm)
    Label1: TLabel;
    EditName: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    Label2: TLabel;
    EditName2: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
   CurID:Integer;
   DoSQLStr:String;
   GetNewID:Boolean;
  public
  end;

function AddAbsence:Boolean;
function EditAbsence(Absence_Id:Integer):Boolean;
function DeleteAbsence(Absence_Id:Integer):Boolean;

implementation

uses UMainUnited, NTimeData;

{$R *.DFM}

function AddAbsence:Boolean;
var frmAbsenceEdit: TfrmAbsenceEdit;
begin
 frmAbsenceEdit:=TfrmAbsenceEdit.Create(Application);
 with frmAbsenceEdit do
 try
  ChangeDatabase(frmAbsenceEdit,dbSTBasis);
  Caption:=CaptionAbsenceAdd;
  DoSQLStr:=sqlAddAbsence;
  GetNewID:=True;
  Result:=frmAbsenceEdit.ShowModal=mrOK;
 finally
  frmAbsenceEdit.Free;
 end;
end;

function EditAbsence(Absence_Id:Integer):Boolean;
var frmAbsenceEdit: TfrmAbsenceEdit;
begin
 Result:=False;
 frmAbsenceEdit:=TfrmAbsenceEdit.Create(Application);
 with frmAbsenceEdit do
 try
  ChangeDatabase(frmAbsenceEdit,dbSTBasis);
  CurID:=Absence_ID;
  quTemp.SQL.Text:=Format(sqlSelAbsence,[Absence_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else begin
    EditName.Text:=quTemp.FieldByName(fldAbsenceName).AsString;
    EditName2.Text:=quTemp.FieldByName(fldAbsenceShortName).AsString;
   end;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  Caption:=CaptionAbsenceUpdate;
  DoSQLStr:=sqlUpdAbsence;
  GetNewID:=False;
  Result:=frmAbsenceEdit.ShowModal=mrOK;
 finally
  frmAbsenceEdit.Free;
 end;
end;

function DeleteAbsence(Absence_Id:Integer):Boolean;
var frmAbsenceEdit: TfrmAbsenceEdit;
    AbsenceName:String;
begin
 Result:=False;
 frmAbsenceEdit:=TfrmAbsenceEdit.Create(Application);
 with frmAbsenceEdit do
 try
  ChangeDatabase(frmAbsenceEdit,dbSTBasis);
  quTemp.SQL.Text:=Format(sqlSelAbsence,[Absence_ID]);
  if not trTemp.InTransaction then trTemp.StartTransaction;
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create(msgNoDataForView)
   else AbsenceName:=quTemp.FieldByName(fldAbsenceName).AsString;
  finally
   quTemp.Close;
   trTemp.Commit;
  end;
  if ShowQuestion(Handle,Format(CaptionAbsenceDelete,[AbsenceName]))=mrYes then
  begin
   quTemp.SQL.Text:=Format(sqlDelAbsence,[Absence_ID]);
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
  frmAbsenceEdit.Free;
 end;
end;

procedure TfrmAbsenceEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var Absence_ID:Integer;
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
  if EditName2.Text='' then
  begin
   ShowInfo(Handle,Format(ConstFieldNoEmpty,[Label2.Caption]));
   EditName2.SetFocus;
   CanClose:=False;
   Exit;
  end;
  if GetNewID then Absence_ID:=GetGenId(dbSTBasis,tbAbsence,1) else Absence_ID:=CurID;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditName.Text,EditName2.Text,Absence_ID]);
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
