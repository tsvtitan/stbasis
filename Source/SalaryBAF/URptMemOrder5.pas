unit URptMemOrder5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet;

type
  TfmRptMemOrder5 = class(TfmRptMain)
    EdPeriod: TEdit;
    Label1: TLabel;
    BtCallPeriod: TButton;
    procedure BtCallPeriodClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibGenClick(Sender: TObject);
  private
    { Private declarations }
    procedure OnRptTerminate(Sender: TObject);
  public
    calcperiod_id: Integer;
    startdate,enddate: TDateTime;

    procedure GenerateReport;override;
    function GetSQlString: String;
    { Public declarations }
  end;

var
  fmRptMemOrder5: TfmRptMemOrder5;

implementation
uses URptThread, ActiveX, UMainUnited, USalBafFuncProc, USalBafConst;

type
  TRptExcelThreadLocal=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptMemOrder5;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadLocal;

{$R *.DFM}

procedure TfmRptMemOrder5.BtCallPeriodClick(Sender: TObject);
var
  P: PCalcPeriodParams;
begin
 try
  getMem(P,sizeof(TCalcPeriodParams));
  try
   ZeroMemory(P,sizeof(TCalcPeriodParams));
   P.calcperiod_id:=calcperiod_id;
   if _ViewEntryFromMain(tte_rbkscalcperiod,P,true) then begin
     calcperiod_id:=P.calcperiod_id;
     edPeriod.Text:=P.name;
     startdate:=P.startdate;
     enddate:=IncMonth(startdate,CalcSalaryPeriodStep)-1;
   end;
  finally
    FreeMem(P,sizeof(TCalcPeriodParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptMemOrder5.FormDestroy(Sender: TObject);
begin
  inherited;
//  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then fmRptMemOrder5:=nil;
end;

procedure TfmRptMemOrder5.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadLocal.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  // запуск нити
  Rpt.Resume;
end;

procedure TRptExcelThreadLocal.Execute;
var
  Wb: OleVariant;
  Sh: OleVariant;
  qr: TIbQuery;
  K, MaxRow, dataRow, Row, Col: Integer;
  IsLeftCol:Boolean;
  summa: Currency;

  procedure SetPageSetup;
  begin
    Sh.PageSetup.Orientation:=xlLandscape;
    Sh.PageSetup.Leftmargin:=1.5;
    Sh.PageSetup.rightmargin:=1.5;
    Sh.PageSetup.TopMargin:=2;
    Sh.PageSetup.BottomMargin:=2;
  end;

  procedure SetBorderLine(range: Olevariant; BorderType: Integer);
  begin
    Case BorderType of // обрамление ячейки
      1: begin
           range.Borders[xlEdgeBottom].LineStyle:=xlContinuous;
           range.Borders[xlEdgeTop].LineStyle:=xlContinuous;
           range.Borders[xlEdgeLeft].LineStyle:=xlContinuous;
           range.Borders[xlEdgeRight].LineStyle:=xlContinuous;
         end;
      2: range.Borders[xlEdgeBottom].LineStyle:=xlContinuous; // линия снизу
    end;
  end;

  procedure SetColumnwidth;
  var
    range: Olevariant;
  begin
    range:=Sh.Cells;    range.font.Name:= 'Times New Roman';

    Range:=sh.columns[1];     Range.columnWidth:=21.71;
    Range:=sh.columns[2];     Range.columnWidth:=10.43;
    Range:=sh.columns[3];     Range.columnWidth:=1.43;
    Range:=sh.columns[4];     Range.columnWidth:=0.58;
    Range:=sh.columns[5];     Range.columnWidth:=9;
    Range:=sh.columns[6];     Range.columnWidth:=2.29;
    Range:=sh.columns[7];     Range.columnWidth:=6.71;
    Range:=sh.columns[8];     Range.columnWidth:=9;
    Range:=sh.columns[9];     Range.columnWidth:=1.43;
    Range:=sh.columns[10];    Range.columnWidth:=4.29;
    Range:=sh.columns[11];    Range.columnWidth:=0.58;
    Range:=sh.columns[12];    Range.columnWidth:=5.29;
    Range:=sh.columns[13];    Range.columnWidth:=8.43;
    Range:=sh.columns[14];    Range.columnWidth:=13;
    Range:=sh.columns[15];    Range.columnWidth:=1.43;
    Range:=sh.columns[16];    Range.columnWidth:=9;
    Range:=sh.columns[17];    Range.columnWidth:=2.43;
    Range:=sh.columns[18];    Range.columnWidth:=1.71;
    Range:=sh.columns[19];    Range.columnWidth:=4.14;
    Range:=sh.columns[20];    Range.columnWidth:=9;
  end;

  procedure CreateHeader;
  var
    Range: OleVariant;
    i:integer;
  begin
    // ds,jh
    Range:=Sh.Range[Sh.Cells[1,7],Sh.Cells[4,7]];
    range.font.Size:=9;
//    range.HorizontalAlignment:= xlcenter;

    Sh.Cells[1,7].Value:='МЕМОРИАЛЬНЫЙ ОРДЕР 5';
    Sh.Cells[1,7].font.Size:=10;
    Sh.Cells[1,7].font.Bold:=true;

    Sh.Cells[2,3].Value:='Свод расчётных ведомостей по заработной плате и стипендиям';
    Sh.Cells[2,3].font.Bold:=true;

    Sh.Cells[5,6].Value:='за ';
    Sh.Cells[5,7].Value:=fmParent.EdPeriod.Text;
    range:=Sh.Range[Sh.Cells[5,7],Sh.Cells[5,12]];
    SetBorderLine(range,2);
    Range.merge;
    Sh.Cells[5,13].value:=' года';

    range:=Sh.Range[Sh.Cells[4,17],Sh.Cells[6,17]];
    Range.HorizontalAlignment:= xlright;
    Sh.Cells[4,17].value:='Форма 405 по ОКУД';
    Sh.Cells[5,17].value:='Дата';
    Sh.Cells[6,17].value:='по ОКПО';

    Sh.Cells[3,19].value:='КОДЫ';
    Sh.Cells[4,19].value:='0504405';
    Sh.Cells[8,19].value:='383';

    for i:=0 to 5 do
    begin
      range:=Sh.Range[Sh.Cells[3+i,19],Sh.Cells[3+i,20]];
      Range.HorizontalAlignment:= xlcenter;
      Range.merge;
      SetBorderLine(Range,1);
    end;
    range:=Sh.Range[Sh.Cells[4,19],Sh.Cells[8,20]];
    SetBorderLine(Range,1);
    Range.Borders.Weight:=xlMedium;


    Sh.Cells[6,1].Value:='Учреждение (централизованная бухгалтерия)';
    range:=Sh.Range[Sh.Cells[6,4],Sh.Cells[6,14]];
    range.merge;
    SetBorderLine(range,2);

    Sh.Cells[7,1].Value:='Источник финансирования';
    range:=Sh.Range[Sh.Cells[7,2],Sh.Cells[7,14]];
    SetBorderLine(range,2);
    range.merge;

    Sh.Cells[8,1].Value:='Единица измерения:руб.';

  end;

  procedure CreateColumnHeader(HRow:Integer);
  var
    range:OleVariant;
  begin
    range:=Sh.rows[HRow];
    range.RowHeight:=24.75;
    Range:=Sh.Range[Sh.Cells[HRow,1],Sh.Cells[HRow,4]];
    SetBorderLine(range,1);
    Range.merge;
    Range.Value:='Наименование показателя';

    Range:=Sh.Range[Sh.Cells[HRow,10],Sh.Cells[HRow,15]];
    SetBorderLine(range,1);
    Range.merge;
    Range.Value:='Наименование показателя';


    Sh.Cells[HRow,5].Value:='Дебет    субсчёта';
    SetBorderLine(Sh.Cells[HRow,5],1);
    Sh.Cells[HRow,16].Value:='Дебет    субсчёта';
    SetBorderLine(Sh.Cells[HRow,16],1);

    Range:=Sh.Range[Sh.Cells[HRow,6],Sh.Cells[HRow,7]];
    SetBorderLine(Range,1);
    Range.merge;
    Range.Value:='Кредит    субсчёта';

    Range:=Sh.Range[Sh.Cells[HRow,17],Sh.Cells[HRow,19]];
    SetBorderLine(Range,1);
    Range.merge;
    Range.Value:='Кредит    субсчёта';

    SetBorderLine(Sh.Cells[HRow,8],1);
     Sh.Cells[HRow,8].Value:='Cумма';

    SetBorderLine(Sh.Cells[HRow,20],1);
    Sh.Cells[HRow,20].Value:='Cумма';

    // перенос текста по словам и выравнивание
    Sh.rows[HRow].wraptext:=true;
    Sh.rows[HRow].HorizontalAlignment:= xlcenter;
    Sh.rows[HRow].VerticalAlignment:= xlcenter;
  end;

  procedure AddRepStr(Name,Deb,Kred:String; Summa:Currency; IsleftCol: Boolean);
  var
    Range: OleVariant;
  begin
    Sh.rows[dataRow+row].wraptext:=true;
    Sh.rows[dataRow+row].VerticalAlignment:= xlcenter;

    if IsleftCol then Range:=Sh.Range[Sh.Cells[dataRow+row,1],Sh.Cells[dataRow+row,4]] else
      Range:=Sh.Range[Sh.Cells[dataRow+row,10],Sh.Cells[dataRow+row,15]];
    SetBorderLine(range,1);
    Range.merge;
    Range.rows.Autofit;
    Range.Value:=Name;

    if IsleftCol then range:=Sh.Cells[dataRow+row,5] else
      range:=Sh.Cells[dataRow+row,16];
    SetBorderLine(range,1);
    range.Value:=Deb;

    if IsleftCol then range:=Sh.Range[Sh.Cells[dataRow+row,6],Sh.Cells[dataRow+row,7]] else
      range:=Sh.Range[Sh.Cells[dataRow+row,17],Sh.Cells[dataRow+row,19]];
    range.merge;
    SetBorderLine(range,1);
    range.Value:=Kred;

    if IsleftCol then range:=Sh.Cells[dataRow+row,8] else range:=Sh.Cells[dataRow+row,20];
    range.Value:=Summa;
    SetBorderLine(range,1);
  end;

  procedure CreateFooter(Row:Integer);
  var
    range: OleVariant;
  begin
    Sh.Cells[row,1].value:='Исполнитель';
    Sh.Cells[row,1].HorizontalAlignment:= xlright;
    SetBorderLine(Sh.Cells[row,2],2);
    Sh.Cells[row+1,2].value:='(должность)';
    Sh.Cells[row+1,2].HorizontalAlignment:= xlcenter;
    range:=Sh.Range[Sh.Cells[row,4],Sh.Cells[Row,5]];
    range.merge;
    SetBorderLine(range,2);

    range:=Sh.Range[Sh.Cells[row+1,4],Sh.Cells[Row+1,5]];
    range.merge;
    range.value:='(подпись)';
    range.HorizontalAlignment:= xlcenter;

    range:=Sh.Range[Sh.Cells[row,7],Sh.Cells[Row,8]];
    range.merge;
    SetBorderLine(range,2);

    range:=Sh.Range[Sh.Cells[row+1,7],Sh.Cells[Row+1,8]];
    range.merge;
    range.value:='(расшифровка)';
    range.HorizontalAlignment:= xlcenter;

    range:=Sh.Range[Sh.Cells[row,10],Sh.Cells[Row,13]];
    range.merge;
    range.value:='Главный бухгалтер';
    range.HorizontalAlignment:= xlright;


    range:=Sh.cells[row,14];
    SetBorderLine(range,2);

    range:=Sh.cells[row+1,14];
    range.value:='(подпись)';
    range.HorizontalAlignment:= xlcenter;

    range:=Sh.Range[Sh.Cells[row,16],Sh.Cells[Row,17]];
    range.merge;
    SetBorderLine(range,2);

    range:=Sh.Range[Sh.Cells[row+1,16],Sh.Cells[Row+1,17]];
    range.merge;
    range.value:='(расшифровка)';
    range.HorizontalAlignment:= xlcenter;

  end;


var
  Range: OleVariant;
  Selection: OleVariant;
  sqls: string;
  RecCount: Integer;
  i: Integer;
  CurFlag: Integer;
  CurY: Integer;
begin
 try
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    fmParent.Mainqr.Active:=false;
    fmParent.Mainqr.SQL.Clear;
    fmParent.Mainqr.Transaction.Active:=true;
    sqls:=fmParent.GetSQlString;

    fmParent.Mainqr.SQL.Add(sqls);
    fmParent.Mainqr.Active:=true;
    RecCount:=GetRecordCount(fmParent.Mainqr,true);
    RecCount:=RecCount+1;

    if RecCount=0 then exit;

    _SetSplashStatus(ConstReportExecute);
    PBHandle:=_CreateProgressBar(1,RecCount,'',clred,nil);

    if not CreateReport then exit;
    Wb:=Excel.Workbooks.Add;
    Sh:=Wb.Sheets.Item[1];
    SetPageSetup;

    SetColumnwidth;
    CreateHeader;
    CreateColumnHeader(10);
    fmParent.Mainqr.First;
    Row:=0; k:=0;
    dataRow:=11;
    maxrow:=0;
    summa:=0;
    i:=0;
    while not fmParent.Mainqr.Eof do
    begin
      if Terminated then exit;
      Range:=Sh.Range[Sh.Cells[1,1],Sh.Cells[dataRow+row,1]];
      if range.height>550 then
      begin
        row:=0;
        if IsLeftCol then
        begin
          IsLeftCol:=range.height<550;
        end else
        begin
          Sh:=Wb.Sheets.Item[Wb.Sheets.Count-1];
          SetPageSetup;
          SetColumnwidth;
          CreateColumnHeader(1);
          dataRow:=2;
          maxRow:=0;
          IsLeftCol:=true;
        end;
      end;
      Summa:=Summa+fmParent.Mainqr.fieldByName('Summa').AsCurrency;
      AddRepStr(fmParent.Mainqr.fieldByName('name').AsString,
        fmParent.Mainqr.fieldByName('Debit').AsString,
        fmParent.Mainqr.fieldByName('Kredit').AsString,
        fmParent.Mainqr.fieldByName('Summa').AsCurrency,IsLeftCol);
      Row:=Row+1;
      if MaxRow<DataRow+Row then MaxRow:=DataRow+Row;
      _SetProgressStatus(PBHandle,i);
      inc(i);
      fmParent.Mainqr.Next;
    end;
      AddRepStr('ВСЕГО:','','',Summa,IsLeftCol);
      CreateFooter(maxrow+3);


   finally
    if not VarIsEmpty(Excel) then begin
     Excel.ActiveWindow.WindowState:=xlMaximized;
     Excel.Visible:=true;
     Excel.WindowState:=xlMaximized;
    end;
    DoTerminate;
   end;
  finally
   CoUninitialize;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


procedure TfmRptMemOrder5.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

destructor TRptExcelThreadLocal.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;


function TfmRptMemOrder5.GetSQlString: String;
begin
  Result:='Select Act.Name as Name, AcT.Debit, AcT.kredit, Sum(S.Summa) as Summa from Salary s '+
        'join charge ch on ch.charge_id=S.charge_id '+
        'join stoperation_accounttype StAc on ch.standartoperation_id=StAc.standartoperation_id '+
        'join accountType AcT on StAc.accountType_id=AcT.accountType_id '+
        'where S.calcperiod_id='+IntToStr(calcperiod_id)+
        'group by Act.Name, AcT.debit, AcT.kredit';
end;



procedure TfmRptMemOrder5.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameMemOrder5;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  edPeriod.MaxLength:=DomainNameLength;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptMemOrder5.bibGenClick(Sender: TObject);
begin
  if trim(edPeriod.text)<>'' then inherited;

end;

end.
