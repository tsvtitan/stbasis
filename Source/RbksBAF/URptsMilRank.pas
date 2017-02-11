unit URptsMilRank;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, Buttons,
  ExtCtrls;

type
  TfmRptsMilRank = class(TfmRptMain)
    EdMilrank: TEdit;
    LbMilrank: TLabel;
    BtMilRank: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtMilRankClick(Sender: TObject);
    procedure EdMilrankKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure bibGenClick(Sender: TObject);
  private
    Milrank_id: integer;
    procedure OnRptTerminate(Sender: TObject);
    { Private declarations }
  public
    function GetSQLString: string;
    procedure GenerateReport;override;
    { Public declarations }
  end;

var
  fmRptsMilRank: TfmRptsMilRank;

implementation
Uses UMainUnited, Uconst, UfuncProc, ActiveX, Excel97, URptThread;
{$R *.DFM}

type
  TRptMilRank=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptsMilRank;
    procedure Execute;override;
    destructor Destroy;override;
  end;
var
  RptMilRank: TRptMilRank;


procedure TfmRptsMilRank.FormCreate(Sender: TObject);
begin
  inherited;
  try
   Caption:=NameRptsMilRank;
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);

   LoadFromIni;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRptsMilRank.GenerateReport;
begin
  if RptMilRank<>nil then exit;
  RptMilRank:=TRptMilRank.Create;
  RptMilRank.fmParent:=Self;
  RptMilRank.OnTerminate:=OnRptTerminate;
  // запуск нити
  RptMilRank.Resume;
end;


function TfmRptsMilRank.GetSQLString: string;
var
  tmps: string;
begin
  tmps:='Select E.Fname, E.name, E.Sname, M.craftnum, MR.Name as MilRankName'+
    ' from Emp E join Military M on E.emp_id=M.Emp_id join MilRank MR on '+
    'M.MilRank_id=Mr.MilRank_id ';
  if EdMilrank.text<>'' then tmps:=tmps+'where M.MilRank_id = '+IntTostr(Milrank_id);
  Result:=tmps;
end;


//------------------------------------------------------------------
procedure TRptMilRank.Execute;
var
  Wb: OleVariant;
  Sh: OleVariant;
  Range: OleVariant;
  qr: TIbQuery;
  RecCount: Integer;
  i: Integer;
const
  MainFont = 'Times New Roman';

  procedure SetPageSetup(Orient: integer);
  begin
    if orient=0 then Sh.PageSetup.Orientation:=xlportrait else
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
      3: range.Borders[xlEdgeTop].LineStyle:=xlContinuous; //   линия сверху
      4: range.Borders[xlEdgeRight].LineStyle:=xlContinuous; //   линия справа
    end;
  end;

  procedure SetColumnHeader;
  begin
    Sh.Cells[2,1].value:='Фамилия';
    Sh.Cells[2,2].value:='Имя';
    SetBorderLine(Sh.Cells[2,2],1);
    Sh.Cells[2,3].value:='Отчество';
    SetBorderLine(Sh.Cells[2,3],1);
    Sh.Cells[2,4].value:='Воинская специальность';

    Range:=sh.columns[1];   Range.columnWidth:=9;
    Range:=sh.columns[2];   Range.columnWidth:=9;
    Range:=sh.columns[3];   Range.columnWidth:=12;
    Range:=sh.columns[4];   Range.columnWidth:=35;

    Range:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,4]];
    Range.font.Name:=mainFont;
    Range.font.Size:=10;
    Range.RowHeight:=25;
    Range.font.Bold:=true;
    Range.wraptext:=true;
    Range.HorizontalAlignment:= xlcenter;
    Range.VerticalAlignment:=xlcenter;
    SetBorderLine(range,2);
    SetBorderLine(range,3);
  end;

  procedure RunReport;
  var
    OldMilRank, NewMilRank: string;
    MilRankCount: integer;

      procedure PrintGroopFooter;
      begin
        i:=i+1;
        Range:=Sh.Range[Sh.Cells[2+i,1],Sh.Cells[2+i,4]];
        Range.merge;
        Range.font.Name:=MainFont;
        Range.font.Size:=10;
        Range.RowHeight:=15;
        Range.font.Bold:=true;
        SetBorderLine(Range,3);
        Range.value:='Итого: '+IntToStr(MilRankCount)+' человек';
        MilRankCount:=0;
      end;

      procedure PrintHeader;
      begin
        Range:=Sh.Range[Sh.Cells[2+i,1],Sh.Cells[2+i,4]];
        Range.merge;
        Range.font.Bold:=true;
        Range.font.Name:=MainFont;
        Range.font.Size:=10;
        Range.RowHeight:=20;
        Range.HorizontalAlignment:= xlcenter;
        Range.VerticalAlignment:=xlcenter;
        Range.value:=NewMilRank;
        SetBorderLine(Range,2);
        i:=i+1;
      end;

  begin
    SetPageSetup(0);
    Range:=Sh.Range[Sh.Cells[1,1],Sh.Cells[1,4]];
    Range.font.Bold:=true;
    Range.font.Name:=MainFont;
    Range.font.Size:=12;
    Range.Merge;
    Range.Value:='Сведения об воинских званиях сотрудников на '+DateToStr(Now);
    Range.RowHeight:=20;
    Range.HorizontalAlignment:= xlcenter;
    Range.VerticalAlignment:=xlcenter;

    setcolumnHeader;

    fmParent.Mainqr.First;
    i:=1;
    while not fmParent.Mainqr.Eof do begin
      NewMilRank:=fmParent.Mainqr.FieldByName('MilRankName').AsString;
      if NewMilRank<>OldMilRank then PrintHeader;
      MilRankCount:=MilRankCount+1;
      Sh.Cells[2+i,1].value:=fmParent.Mainqr.FieldByName('FName').AsString;
      setBorderLine(Sh.Cells[2+i,1],4);
      Sh.Cells[2+i,2].value:=fmParent.Mainqr.FieldByName('Name').AsString;
      setBorderLine(Sh.Cells[2+i,2],4);
      Sh.Cells[2+i,3].value:=fmParent.Mainqr.FieldByName('SName').AsString;
      setBorderLine(Sh.Cells[2+i,3],4);
      Sh.Cells[2+i,4].value:=fmParent.Mainqr.FieldByName('craftnum').AsString;
      OldMilRank:=NewMilRank;
      fmParent.Mainqr.Next;
      NewMilRank:=fmParent.Mainqr.FieldByName('MilRankName').AsString;
      if ((i<>0) and (NewMilRank<>OldMilRank)) or (fmParent.Mainqr.Eof) then printGroopFooter;
      _SetProgressStatus(PBHandle,i);
      i:=i+1;
    end;

  end;



var
  sqls: string;
  CurFlag: Integer;
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

    if RecCount=0 then exit;

    _SetSplashStatus(ConstReportExecute);
    PBHandle:=_CreateProgressBar(1,RecCount,'',clred,nil);

    if not CreateReport then exit;
    Wb:=Excel.Workbooks.Add;
    Sh:=Wb.Sheets.Item[1];
    RunReport;
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

procedure TfmRptsMilRank.BtMilRankClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='MilRank_ID';
  TPRBI.Locate.KeyValues:=MilRank_ID;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkMilrank,@TPRBI) then begin
    MilRank_ID:=GetFirstValueFromParamRBookInterface(@TPRBI,'MilRank_ID');
    EdMilRank.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'MilRankName');
  end;
end;


procedure TfmRptsMilRank.EdMilrankKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    EdMilRank.Clear;
    MilRank_ID:=0;
  end;
end;


procedure TfmRptsMilRank.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(RptMilRank);
  bibBreakClick(nil);
end;

Destructor TRptMilRank.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;

procedure TfmRptsMilRank.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then fmRptsMilRank:=nil;
end;

procedure TfmRptsMilRank.bibGenClick(Sender: TObject);
begin
  inherited;
  //
end;

end.
