unit CalExceptEdit;

{$I stbasis.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, Mask, ToolEdit, IBDatabase, Db, IBCustomDataSet,
  IBQuery;

type
  TfrmCalExceptEdit = class(TForm)
    Label11: TLabel;
    EditCurDate: TEdit;
    Label1: TLabel;
    DateEdit1: TDateEdit;
    RxSpinEdit1: TRxSpinEdit;
    Label2: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    quTemp: TIBQuery;
    trTemp: TIBTransaction;
    Label3: TLabel;
    EditExceptName: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
   CurID:Integer;
   DoSQLStr:String;
  public
    { Public declarations }
  end;

function AddCalendarExcept(WeekName:String;WeekID:Integer):Boolean;
function EditCalendarExcept(WeekName:String;ExceptID:Integer):Boolean;
function DeleteCalendarExcept(WeekName:String;ExceptID:Integer):Boolean;

implementation

{$R *.DFM}

uses StrUtils, CalendarData, UMainUnited;

function AddCalendarExcept(WeekName:String;WeekID:Integer):Boolean;
var
  frmCalExceptEdit: TfrmCalExceptEdit;
begin
 Result:=False;
 frmCalExceptEdit:=TfrmCalExceptEdit.Create(Application);
 with frmCalExceptEdit do
 try
  ChangeDatabase(frmCalExceptEdit,dbSTBasis);
  CurID:=WeekID;
  Caption:='Добавить исключение';
  EditCurDate.Text:=WeekName;
  DoSQLStr:='insert into dateexcept (description,dateexcept,timecount,week_id) values (''%s'',CAST(''%s'' AS DATE),%s,%d)';
  Result:=frmCalExceptEdit.ShowModal=mrOK;
 finally
  frmCalExceptEdit.Release;
 end;
end;

function EditCalendarExcept(WeekName:String;ExceptID:Integer):Boolean;
var
  frmCalExceptEdit: TfrmCalExceptEdit;
begin
 Result:=False;
 frmCalExceptEdit:=TfrmCalExceptEdit.Create(Application);
 with frmCalExceptEdit do
 try
  ChangeDatabase(frmCalExceptEdit,dbSTBasis);
  CurID:=ExceptID;
  quTemp.SQL.Text:=Format('select description,dateexcept,timecount from dateexcept where dateexcept_id=%d',[ExceptID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else begin
    EditExceptName.Text:=quTemp.FieldByName('description').AsString;
    DateEdit1.Date:=quTemp.FieldByName('dateexcept').AsDateTime;
    RxSpinEdit1.Value:=quTemp.FieldByName('timecount').AsFloat;
   end;
  finally
   quTemp.Close;
  end;
  Caption:='Изменить исключение';
  EditCurDate.Text:=WeekName;
  DoSQLStr:='update dateexcept set description=''%s'',dateexcept=CAST(''%s'' AS DATE),timecount=%s where dateexcept_id=%d';
  Result:=frmCalExceptEdit.ShowModal=mrOK;
 finally
  frmCalExceptEdit.Release;
 end;
end;

function DeleteCalendarExcept(WeekName:String;ExceptID:Integer):Boolean;
var
  frmCalExceptEdit: TfrmCalExceptEdit;
  ExceptName:String;
begin
 Result:=False;
 frmCalExceptEdit:=TfrmCalExceptEdit.Create(Application);
 with frmCalExceptEdit do
 try
  ChangeDatabase(frmCalExceptEdit,dbSTBasis);
  quTemp.SQL.Text:=Format('select description from dateexcept where dateexcept_id=%d',[ExceptID]);
  try
   quTemp.Open;
   if quTemp.IsEmpty then raise Exception.Create('Нет данных для отображения.')
   else ExceptName:=quTemp.FieldByName('description').AsString;
  finally
   quTemp.Close;
  end;
  if Application.MessageBox(PChar(Format('Удалить исключение "%s" для недели "%s"?',[ExceptName,WeekName])),'Подтверждение',mb_YesNo+mb_IconQuestion)=mrYes then
  begin
   quTemp.SQL.Text:=Format('delete from dateexcept where dateexcept_id=%d',[ExceptID]);
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
  frmCalExceptEdit.Release;
 end;
end;

procedure TfrmCalExceptEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=True;
 if ModalResult=mrOK then
 begin
  if DateEdit1.Date=0 then
  begin
   ShowInfo(Handle,Format('Укажите значение в поле "%s".',[Label1.Caption]));
   CanClose:=False;
   Exit;
  end;
  quTemp.SQL.Text:=Format(DoSQLStr,[EditExceptName.Text,
   FormatDateTime('dd/mm/yyyy',DateEdit1.Date),
   ReplaceStr(RxSpinEdit1.Text,',','.'),CurID]);
  try
   if not trTemp.InTransaction then trTemp.StartTransaction;
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
