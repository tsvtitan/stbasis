unit URptTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, Db,
  IBCustomDataSet, IBQuery, IBDatabase, Spin;

type
  TfmRptTest = class(TfmRptMain)
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Button2: TButton;
    BibSal: TBitBtn;
    edschedule: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BibSalClick(Sender: TObject);
  private
    procedure OnRptTerminate(Sender: TObject);
  public
    schedule_id: Integer;
    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
  end;

var
  fmRptTest: TfmRptTest;

implementation

uses USalaryVAVCode,URptThread,comobj,UMainUnited,ActiveX,
     USalaryVAVData,  StCalendarUtil;

type
  TRptExcelThreadTest=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public

    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadTest;
  TypePeriod: TTypeEnterPeriod;

{$R *.DFM}

procedure TfmRptTest.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:='test';
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptTest.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmRptTest:=nil;
end;

procedure TfmRptTest.LoadFromIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
{    FindName:=fi.ReadString(ClassName,'name',FindName);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);}
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptTest.SaveToIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
{    fi.WriteString(ClassName,'name',FindName);
    fi.WriteBool(ClassName,'Inside',FilterInside);}
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptTest.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptTest.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadTest.Create;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRptTest.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;  
end;

{ TRptExcelThreadTest }

destructor TRptExcelThreadTest.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;

procedure TRptExcelThreadTest.Execute;
var
  Wb: OleVariant;
  Sh: Variant;
  i,j: Integer;
  Data: Variant;
  Range: Variant;
const
  Max=1000;
  isLow=false;
begin
 try
  if CoInitialize(nil)<>S_OK then exit;
  try
    PBHandle:=_CreateProgressBar(1,Max,'',clred,nil);
    if not CreateReport then exit;

    Wb:=Excel.Workbooks.Add;
    Sh:=Wb.Sheets.Item[1];

   if isLow then begin
    for i:=1 to Max do begin
     if Terminated then exit;
     _SetProgressStatus(PBHandle,i);
     sh.Cells[i,1]:='test '+inttostr(i);
     sh.Cells[i,2]:='test '+inttostr(i);
     sh.Cells[i,3]:='test '+inttostr(i);
     sh.Cells[i,4]:='test '+inttostr(i);
     sh.Cells[i,5]:='test '+inttostr(i);
     sh.Cells[i,6]:='test '+inttostr(i);
     sh.Cells[i,7]:='test '+inttostr(i);
     sh.Cells[i,8]:='test '+inttostr(i);
    end;
   end else begin
    Data:= VarArrayCreate([1,Max],VarVariant);
    for i:=1 to Max do begin
      if Terminated then exit;
       Data[i]:='test'+inttostr(i);
      //Data[i]:= VarArrayOf(['testA'+inttostr(i), 'testB'+inttostr(i), 'testC'+inttostr(i)]);
  //    Range := Sh.Range['A'+inttostr(i)+':C'+inttostr(i)]; // To assign range
//      Range.Value := Data[i];
//      Range.Value := VarArrayOf(['testA'+inttostr(i), 'testB'+inttostr(i), 'testC'+inttostr(i)]);
      _SetProgressStatus(PBHandle,i);
    end;
//    Data:= VarArrayOf(['testA'+inttostr(i), 'testB'+inttostr(i), 'testC'+inttostr(i)]);
    Range := Sh.Range['A1:C'+inttostr(Max)];
    Range.Value:=Data;

{[    Range := Sh.Column(1); // To assign range
    Range:=Data;

{    Range := Sh.Range['B1:B'+inttostr(Max)]; // To assign range
    Range.Value := Data;
    Range := Sh.Range['C1:C'+inttostr(Max)]; // To assign range
    Range.Value := Data;
    Range := Sh.Range['D1:D'+inttostr(Max)]; // To assign range
    Range.Value := Data;}
   end;

  finally
   Excel.ActiveWindow.WindowState:=xlMaximized;
   Excel.Visible:=true;
   Excel.WindowState:=xlMaximized;
   _FreeProgressBar(PBHandle);
   DoTerminate;
  end;
 finally
  CoUninitialize;
 end;
end;

procedure TfmRptTest.Button1Click(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
 try
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=TypePeriod;
   P.LoadAndSave:=true;
   P.DateBegin:=DateTimePicker1.DateTime;
   P.DateEnd:=DateTimePicker2.DateTime;
   if _ViewEnterPeriod(P) then begin
     DateTimePicker1.DateTime:=P.DateBegin;
     DateTimePicker2.DateTime:=P.DateEnd;
     TypePeriod:=P.TypePeriod;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


procedure TfmRptTest.Button2Click(Sender: TObject);
begin
  inherited;

  //Получить текущий календарь

  //Получить рассчетный год
  //Получить рассчетный период
  //Получить текущего сотрудника
  //Проверить когда принят на работу
  //Проверить уволен-ли?
  //Проверить были среди месяца повышения или понижения?
  //Получить его оклад или тариф      
  //Получить оклад или тариф это
  //Получить сетку
  //Получить смену
  //Получить МРОТ
  //Получить признаки по которым производятся начисления если такие есть
  //Получить количество иждевенцев
  //Получить норму льготы на налог
  //Получить совокупный годовой доход
  //Получить норма налога
  //Получить стаж
  //Получить процент от стажа
  //Получить процент от нужный в виде начисления
  //Получить график
  //Получить норму времени
  //Получить факт отработанного времени (по видам)
  //Получить округление до
  //Получить номер лицевого счета сотрудника
  //Проверить премии
  //Получить всего начислений
  //Получить всего удержаний
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить
  //Получить




end;

procedure TfmRptTest.BibSalClick(Sender: TObject);
  //Получает текущий календарь

  var
  P: PScheduleParams;
begin
 try
  getMem(P,sizeof(TScheduleParams));
  InitCalendarUtil(IBDB);
  try
   ZeroMemory(P,sizeof(TScheduleParams));
   P.Schedule_ID:=schedule_id;
   P.Calendar_ID:=GetCurrentCalendarID;
   if _ViewEntryFromMain(tte_rbksSchedule,p,true) then begin
//     ChangeFlag:=true;
     schedule_id:=P.Schedule_ID;
     edschedule.Text:=P.Name;
   end;
  finally
    DoneCalendarUtil;
    FreeMem(P,sizeof(TScheduleParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


end.
