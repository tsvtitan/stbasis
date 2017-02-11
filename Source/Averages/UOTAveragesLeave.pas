unit UOTAveragesLeave;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UMainUnited, StdCtrls, Buttons, StAverages, IBDatabase, Db,
  IBCustomDataSet, IBQuery, ComCtrls, RXSpin, ExtCtrls, DBCtrls, Mask,
  ToolEdit, CurrEdit, Grids, DBGrids, RXDBCtrl, RxMemDS;

type
  TfmOTAveragesLeave = class(TForm)
    bibEmp: TBitBtn;
    edEmp: TEdit;
    Label1: TLabel;
    quEmpPlant: TIBQuery;
    trRead: TIBTransaction;
    grbBirthDate: TGroupBox;
    lbBirthDateFrom: TLabel;
    lbBirthDateTo: TLabel;
    dtpBirthDateFrom: TDateTimePicker;
    dtpBirthDateTo: TDateTimePicker;
    bibBirthDate: TBitBtn;
    Button1: TButton;
    cbEmpPlants: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    EditPercent: TRxSpinEdit;
    CurrencyEdit1: TCurrencyEdit;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    memData: TRxMemoryData;
    RxDBGrid1: TRxDBGrid;
    dsData: TDataSource;
    Label6: TLabel;
    Button2: TButton;
    memDataFDate: TDateField;
    memDataLeaveDaysCount: TIntegerField;
    memDataLeaveHoursCount: TFloatField;
    memDataNormalDaysCount: TIntegerField;
    memDataNormalHoursCount: TFloatField;
    memDataCalendarDays: TIntegerField;
    memDataOnePay: TCurrencyField;
    CurrencyEdit2: TCurrencyEdit;
    Label7: TLabel;
    GroupBox1: TGroupBox;
    LabelM1: TLabel;
    EditM1D: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    EditM1H: TEdit;
    Label11: TLabel;
    Bevel1: TBevel;
    LabelM2: TLabel;
    Label12: TLabel;
    EditM2D: TEdit;
    Label13: TLabel;
    EditM2H: TEdit;
    Label14: TLabel;
    RadioGroup3: TRadioGroup;
    EditM1P: TCurrencyEdit;
    EditM2P: TCurrencyEdit;
    Bevel2: TBevel;
    LabelM3: TLabel;
    Label8: TLabel;
    EditM3D: TEdit;
    Label15: TLabel;
    EditM3H: TEdit;
    Label16: TLabel;
    EditM3P: TCurrencyEdit;
    Label4: TLabel;
    EditM1ND: TEdit;
    Label17: TLabel;
    EditM1NH: TEdit;
    Label18: TLabel;
    EditM2ND: TEdit;
    Label19: TLabel;
    EditM2NH: TEdit;
    Label20: TLabel;
    EditM3ND: TEdit;
    Label21: TLabel;
    EditM3NH: TEdit;
    Label22: TLabel;
    CurrencyEdit3: TCurrencyEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bibEmpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure bibBirthDateClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FhInterface: THandle;
    Emp:TEmployeeLeaveInfo;
  public
    constructor Create(AOwner:TComponent;AhInterface: THandle;AParams:Pointer); virtual;
    procedure DoRefresh(AFirstOnce:Boolean);
  end;

var
  fmOTAveragesLeave: TfmOTAveragesLeave;

implementation

{$R *.DFM}

uses DateUtil, AveragesCode, AveragesData, StSalaryKit;

constructor TfmOTAveragesLeave.Create(AOwner:TComponent;AhInterface: THandle;AParams:Pointer);
begin
 inherited Create(AOwner);
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 FormStyle:=fsMDIChild;
end;

procedure TfmOTAveragesLeave.DoRefresh(AFirstOnce:Boolean);
begin
end;

procedure TfmOTAveragesLeave.FormDestroy(Sender: TObject);
begin
 _OnVisibleInterface(FhInterface,False);
 fmOTAveragesLeave:=nil;
end;

procedure TfmOTAveragesLeave.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyDown(Key,Shift);
end;

procedure TfmOTAveragesLeave.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;

procedure TfmOTAveragesLeave.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TfmOTAveragesLeave.bibEmpClick(Sender: TObject);
var Data:TParamRBookInterface;
begin
 try
  Data.Visual.TypeView:=tvibvModal;
  Data.Locate.KeyFields:='emp_id';
  Data.Locate.KeyValues:=emp.emp_id;
  Data.Locate.Options:=[];
  if _ViewInterfaceFromName('Справочник сотрудников',@Data) then
  begin
   emp.emp_id:=GetFirstValueFromParamRBookInterface(@Data,'emp_id');
   edEmp.Text:=GetFirstValueFromParamRBookInterface(@Data,'fname')+' '+GetFirstValueFromParamRBookInterface(@Data,'name')+' '+GetFirstValueFromParamRBookInterface(@Data,'sname');
  end;
  cbEmpPlants.Items.Clear;
  quEmpPlant.SQL.Text:='select ep.*,d.name as departname from empplant ep join depart d on ep.depart_id=d.depart_id where emp_id='+IntToStr(emp.emp_id);
  try
   quEmpPlant.Open;
   while not quEmpPlant.EOF do
   begin
    cbEmpPlants.Items.AddObject(quEmpPlant.FieldByName('departname').AsString,TObject(quEmpPlant.FieldByName('empplant_id').AsInteger));
    quEmpPlant.Next;
   end;
   if cbEmpPlants.Items.Count>0 then
    cbEmpPlants.ItemIndex:=0;
  finally
   quEmpPlant.Close;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOTAveragesLeave.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfmOTAveragesLeave.FormCreate(Sender: TObject);
begin
 ChangeDataBase(Self,dbSTBasis);
end;

procedure TfmOTAveragesLeave.bibBirthDateClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
 try
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepYear;
   P.LoadAndSave:=false;
   P.DateBegin:=dtpBirthDateFrom.DateTime;
   P.DateEnd:=dtpBirthDateTo.DateTime;
   if _ViewEnterPeriod(P) then begin
     dtpBirthDateFrom.DateTime:=P.DateBegin;
     dtpBirthDateTo.DateTime:=P.DateEnd;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOTAveragesLeave.Button1Click(Sender: TObject);
var CalcShift:Integer;
    ASalaryInfo:TSalaryInfo;
    ALeave:TLeave;
    Lucre,AveragePay,AllPay:Currency;
    I:Integer;
    D,M1,M2,Y1,Y2:Word;
begin
 with Emp do
 begin
  try
   EmpPlant_id:=Integer(cbEmpPlants.Items.Objects[cbEmpPlants.ItemIndex]);
  except
   EmpPlant_id:=-1;
  end;
  if EmpPlant_id=-1 then begin ShowInfo(Handle,'Выберите сотрудника.');Exit;end;
  StartDate:=dtpBirthDateFrom.DateTime;
  EndDate:=dtpBirthDateTo.DateTime;
  ///////////////////////////////////////////
  SetLength(WorkAbsence_ids,1);
  WorkAbsence_ids[0]:=11;
  ///////////////////////////////////////////
  try
   Oklad:=GetOklad(Integer(cbEmpPlants.Items.Objects[cbEmpPlants.ItemIndex]));
  except
   Oklad:=-1;
  end;
  if Oklad=-1 then begin ShowInfo(Handle,'Выберите сотрудника.');Exit;end;
  OkladFlag:=True;
  PayPercent:=EditPercent.AsInteger;
  CalculateType:=RadioGroup3.ItemIndex+1;
  if CalculateType<1 then begin ShowInfo(Handle,'Выберите вид расчёта.');Exit;end;
  CalculateSubType:=RadioGroup1.ItemIndex+1;
  if CalculateSubType<1 then begin ShowInfo(Handle,'Выберите тип расчёта.');Exit;end;

  if (Emp.CalculateType=6) and (DaysBetween(StartDate,EndDate)>14) then
  begin
   ShowInfo(Handle,'Для вида "Расчёт отпуска ликвидатору аварии на ЧАЭС" указан период больше 14 календарных дней, что противоречит существующему законодательству.'+#10+
    'Укажите меньшее значение.');
   Exit;
  end;

  if (Emp.CalculateType=4) then
  begin
   DecodeDate(StartDate,Y1,M1,D);
   DecodeDate(EndDate,Y2,M2,D);
   if (Y1<>Y2) or (M1<>M2) then
   begin
    ShowInfo(Handle,'Для вида "Расчёт прочих средних" указан период больше одного месяца.'+#10+
     'Укажите меньшее значение.');
    Exit;
   end;
  end;
 end;
 CalculateLeaveList(Emp,CalcShift,ASalaryInfo,ALeave,AveragePay,Lucre,AllPay);
 CurrencyEdit1.Value:=AllPay;
 CurrencyEdit3.Value:=Lucre;
 CurrencyEdit2.Value:=AveragePay;
 memData.EmptyTable;
 for I:=Low(ALeave) to High(ALeave) do
 begin
  memData.Append;
  memData.FieldByName('FDate').Value:=ALeave[I].FDate;
  memData.FieldByName('LeaveDaysCount').Value:=ALeave[I].LeaveDaysCount;
  memData.FieldByName('LeaveHoursCount').Value:=ALeave[I].LeaveHoursCount;
  memData.FieldByName('NormalDaysCount').Value:=ALeave[I].NormalDaysCount;
  memData.FieldByName('NormalHoursCount').Value:=ALeave[I].NormalHoursCount;
  memData.FieldByName('CalendarDays').Value:=ALeave[I].CalendarDays;
  memData.FieldByName('OnePay').Value:=ALeave[I].OnePay;
  memData.Edit;
 end;
 memData.First;
 LabelM1.Caption:=FormatDateTime('mmmm yyyy г.',ASalaryInfo[0].Month);
 EditM1D.Text:=IntToStr(ASalaryInfo[0].ODays);
 EditM1H.Text:=FloatToStr(ASalaryInfo[0].OHours);
 EditM1ND.Text:=IntToStr(ASalaryInfo[0].NDays);
 EditM1NH.Text:=FloatToStr(ASalaryInfo[0].NHours);
 EditM1P.Value:=ASalaryInfo[0].Pay;

 LabelM2.Caption:=FormatDateTime('mmmm yyyy г.',ASalaryInfo[1].Month);
 EditM2D.Text:=IntToStr(ASalaryInfo[1].ODays);
 EditM2H.Text:=FloatToStr(ASalaryInfo[1].OHours);
 EditM2ND.Text:=IntToStr(ASalaryInfo[1].NDays);
 EditM2NH.Text:=FloatToStr(ASalaryInfo[1].NHours);
 EditM2P.Value:=ASalaryInfo[1].Pay;

 LabelM3.Caption:=FormatDateTime('mmmm yyyy г.',ASalaryInfo[2].Month);
 EditM3D.Text:=IntToStr(ASalaryInfo[2].ODays);
 EditM3H.Text:=FloatToStr(ASalaryInfo[2].OHours);
 EditM3ND.Text:=IntToStr(ASalaryInfo[2].NDays);
 EditM3NH.Text:=FloatToStr(ASalaryInfo[2].NHours);
 EditM3P.Value:=ASalaryInfo[2].Pay;
end;

procedure TfmOTAveragesLeave.Button2Click(Sender: TObject);
begin
 Close;
end;

end.
