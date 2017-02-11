unit UOTAveragesSick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UMainUnited, StdCtrls, Buttons, StAverages, IBDatabase, Db,
  IBCustomDataSet, IBQuery, ComCtrls, RXSpin, ExtCtrls, DBCtrls, Mask,
  ToolEdit, CurrEdit, Grids, DBGrids, RXDBCtrl, RxMemDS;

type
  TfmOTAveragesSick = class(TForm)
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
    CheckBox1: TCheckBox;
    CurrencyEdit1: TCurrencyEdit;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    memData: TRxMemoryData;
    RxDBGrid1: TRxDBGrid;
    dsData: TDataSource;
    Label6: TLabel;
    Button2: TButton;
    memDataFDate: TDateField;
    memDataSickDaysCount: TIntegerField;
    memDataSickHoursCount: TFloatField;
    memDataNormalDaysCount: TIntegerField;
    memDataNormalHoursCount: TFloatField;
    memDataCalendarDays: TIntegerField;
    memDatawithoutPay: TBooleanField;
    memDataPayPercent: TIntegerField;
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
    Emp:TEmployeeSickInfo;
  public
    constructor Create(AOwner:TComponent;AhInterface: THandle;AParams:Pointer); virtual;
    procedure DoRefresh(AFirstOnce:Boolean);
  end;

var
  fmOTAveragesSick: TfmOTAveragesSick;

implementation

{$R *.DFM}

uses DateUtil, AveragesCode, AveragesData, StSalaryKit;

constructor TfmOTAveragesSick.Create(AOwner:TComponent;AhInterface: THandle;AParams:Pointer);
begin
 inherited Create(AOwner);
 FhInterface:=AhInterface;
 _OnVisibleInterface(FhInterface,True);
 FormStyle:=fsMDIChild;
end;

procedure TfmOTAveragesSick.DoRefresh(AFirstOnce:Boolean);
begin
end;

procedure TfmOTAveragesSick.FormDestroy(Sender: TObject);
begin
 _OnVisibleInterface(FhInterface,False);
 fmOTAveragesSick:=nil;
end;

procedure TfmOTAveragesSick.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyDown(Key,Shift);
end;

procedure TfmOTAveragesSick.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;

procedure TfmOTAveragesSick.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TfmOTAveragesSick.bibEmpClick(Sender: TObject);
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

procedure TfmOTAveragesSick.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfmOTAveragesSick.FormCreate(Sender: TObject);
begin
 ChangeDataBase(Self,dbSTBasis);
end;

procedure TfmOTAveragesSick.bibBirthDateClick(Sender: TObject);
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

procedure TfmOTAveragesSick.Button1Click(Sender: TObject);
var CalcShift:Integer;
    ASalaryInfo:TSalaryInfo;
    ASick:TSick;
    AveragePay,AllPay:Currency;
    I:Integer;
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
  ///////////////////////////////////////////////
  SetLength(WorkAbsence_ids,1);
  WorkAbsence_ids[0]:=11;
  ////////////////////////////////////////////////
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
  if CalculateSubType<1 then begin ShowInfo(Handle,'Выберите вид расчёта.');Exit;end;
  CalculateTimeType:=RadioGroup2.ItemIndex+1;
  if CalculateTimeType<1 then begin ShowInfo(Handle,'Выберите тип расчёта.');Exit;end;
  if (CalculateType=2) and (DaysBetween(StartDate,EndDate)>14) then
  begin
   ShowInfo(Handle,'Для вида "Расчёт пособия по уходу за больным" указан период больше 14 дней, что противоречит существующему законодательству.'+#10+
    'Укажите меньшее значение.');
   Exit; 
  end;
  WithoutPay:=CheckBox1.Checked;
 end;
 CalculateSickList(Emp,CalcShift,ASalaryInfo,ASick,AveragePay,AllPay);
 CurrencyEdit1.Value:=AllPay;
 CurrencyEdit2.Value:=AveragePay;
 memData.EmptyTable;
 for I:=Low(ASick) to High(ASick) do
 begin
  memData.Append;
  memData.FieldByName('FDate').Value:=ASick[I].FDate;
  memData.FieldByName('SickDaysCount').Value:=ASick[I].SickDaysCount;
  memData.FieldByName('SickHoursCount').Value:=ASick[I].SickHoursCount;
  memData.FieldByName('NormalDaysCount').Value:=ASick[I].NormalDaysCount;
  memData.FieldByName('NormalHoursCount').Value:=ASick[I].NormalHoursCount;
  memData.FieldByName('CalendarDays').Value:=ASick[I].CalendarDays;
  memData.FieldByName('WithoutPay').Value:=ASick[I].WithoutPay;
  memData.FieldByName('PayPercent').Value:=ASick[I].PayPercent;
  memData.FieldByName('OnePay').Value:=ASick[I].OnePay;
  memData.Edit;
 end;
 memData.First;
 LabelM1.Caption:=FormatDateTime('mmmm yyyy г.',ASalaryInfo[0].Month);
 EditM1D.Text:=IntToStr(ASalaryInfo[0].ODays);
 EditM1H.Text:=FloatToStr(ASalaryInfo[0].OHours);
 EditM1P.Value:=ASalaryInfo[0].Pay;
 LabelM2.Caption:=FormatDateTime('mmmm yyyy г.',ASalaryInfo[1].Month);
 EditM2D.Text:=IntToStr(ASalaryInfo[1].ODays);
 EditM2H.Text:=FloatToStr(ASalaryInfo[1].OHours);
 EditM2P.Value:=ASalaryInfo[1].Pay;
end;

procedure TfmOTAveragesSick.Button2Click(Sender: TObject);
begin
 Close;
end;

end.
