unit URptsEducation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, Buttons,
  ExtCtrls;

type
  TfmRptsEducation = class(TfmRptMain)
    RGReportType: TRadioGroup;
    EdEduc: TEdit;
    EdProfession: TEdit;
    BtTypeStudy: TButton;
    BtProfession: TButton;
    procedure BtTypeStudyClick(Sender: TObject);
    procedure BtProfessionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EdEducKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdProfessionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure OnRptTerminate(Sender: TObject);
    function getSQLString: string;
  public
    Educ_ID, profession_id: Integer;
    procedure GenerateReport;override;
  end;

var
  fmRptsEducation: TfmRptsEducation;

implementation
Uses UMainUnited, Uconst, UfuncProc, URptThread, ActiveX, Excel97;
{$R *.DFM}

type
  TRptExcelThreadLocal=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptsEducation;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadLocal;

procedure TfmRptsEducation.BtTypeStudyClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='Educ_ID';
  TPRBI.Locate.KeyValues:=Educ_ID;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkEduc,@TPRBI) then begin
    Educ_ID:=GetFirstValueFromParamRBookInterface(@TPRBI,'Educ_ID');
    EdEduc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TfmRptsEducation.BtProfessionClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='profession_ID';
  TPRBI.Locate.KeyValues:=profession_ID;
  TPRBI.Locate.Options:=[];
  if _ViewInterfaceFromName(NameRbkprofession,@TPRBI) then begin
    profession_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'profession_ID');
    EdProfession.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TfmRptsEducation.FormCreate(Sender: TObject);
begin
  inherited;
  try
   Caption:=NameRptsEducation;
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);
   RGReportType.ItemIndex:=0;
   LoadFromIni;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmRptsEducation.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then fmRptsEducation:=nil;
end;

procedure TfmRptsEducation.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptsEducation.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadLocal.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  // запуск нити
  Rpt.Resume;
end;

function TfmRptsEducation.getSQLString: string;
var
  tmps: string;
begin
  case RGReportType.itemIndex of
    0: begin
         tmps:='Select E.fname, E.name, E.SName, S.name as School, D.finishdate,'+
         ' d.Num, d.Datewhere, ed.name as EducName from diplom d join Emp E on '+
         'd.emp_id=e.emp_id join school s on d.school_id=s.school_id join educ'+
         ' ed on d.educ_id=ed.educ_id ';
         if EdEduc.text<>'' then tmps:=tmps+'where ed.educ_id='+IntToStr(Educ_id);
         tmps:=tmps+' order by ed.name, E.Fname';
       end;
    1: begin
         tmps:='Select E.fname, E.name, E.SName, S.name as School, D.finishdate,'+
         ' d.Num, d.Datewhere, P.name as profName from diplom d join Emp E on '+
         'd.emp_id=e.emp_id join school s on d.school_id=s.school_id join profession p'+
         ' on D.profession_id=P.profession_id ';
         if EdProfession.text<>'' then tmps:=tmps+'where P.profession_id='+
           IntToStr(profession_id);
         tmps:=tmps+' order by P.name, E.Fname';
       end;
    end;
   Result:=tmps;
end;

//------------------------------------------------------------------
procedure TRptExcelThreadLocal.Execute;
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
    Sh.Cells[2,4].value:='Учебное заведение';
    SetBorderLine(Sh.Cells[2,4],1);
    Sh.Cells[2,5].value:='Дата окончания';
    Sh.Cells[2,6].value:='№ диплома';
    SetBorderLine(Sh.Cells[2,6],1);
    Sh.Cells[2,7].value:='Дата выдачи';

    Range:=sh.columns[1];   Range.columnWidth:=9;
    Range:=sh.columns[2];   Range.columnWidth:=9;
    Range:=sh.columns[3];   Range.columnWidth:=12;
    Range:=sh.columns[4];   Range.columnWidth:=40;
    Range:=sh.columns[5];   Range.columnWidth:=8;
    Range:=sh.columns[6];   Range.columnWidth:=8;
    Range:=sh.columns[7];   Range.columnWidth:=8;

    Range:=Sh.Range[Sh.Cells[2,1],Sh.Cells[2,7]];
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

  procedure RunEducReport;
  var
    OldEduc, NewEduc: string;
    EducCount: integer;

      procedure PrintGroopFooter;
      begin
        i:=i+1;
        Range:=Sh.Range[Sh.Cells[2+i,1],Sh.Cells[2+i,7]];
        Range.merge;
        Range.font.Name:=MainFont;
        Range.font.Size:=10;
        Range.RowHeight:=15;
        Range.font.Bold:=true;
        SetBorderLine(Range,3);
        Range.value:='Итого: '+IntToStr(EducCount)+' человек';
        EducCount:=0;
      end;

      procedure PrintHeader;
      begin
        Range:=Sh.Range[Sh.Cells[2+i,1],Sh.Cells[2+i,7]];
        Range.merge;
        Range.font.Bold:=true;
        Range.font.Name:=MainFont;
        Range.font.Size:=10;
        Range.RowHeight:=20;
        Range.HorizontalAlignment:= xlcenter;
        Range.VerticalAlignment:=xlcenter;
        Range.value:=NewEduc;
        SetBorderLine(Range,2);
        i:=i+1;
      end;

  begin
    SetPageSetup(0);
    Range:=Sh.Range[Sh.Cells[1,1],Sh.Cells[1,7]];
    Range.font.Bold:=true;
    Range.font.Name:=MainFont;
    Range.font.Size:=12;
    Range.Merge;
    Range.Value:='Сведения об образовании сотрудников на '+DateToStr(Now);
    Range.RowHeight:=20;
    Range.HorizontalAlignment:= xlcenter;
    Range.VerticalAlignment:=xlcenter;

    setcolumnHeader;

    fmParent.Mainqr.First;
    i:=1;
    while not fmParent.Mainqr.Eof do begin
      NewEduc:=fmParent.Mainqr.FieldByName('EducName').AsString;
      if NewEduc<>OldEduc then PrintHeader;
      EducCount:=EducCount+1;
      Sh.Cells[2+i,1].value:=fmParent.Mainqr.FieldByName('FName').AsString;
      setBorderLine(Sh.Cells[2+i,1],4);
      Sh.Cells[2+i,2].value:=fmParent.Mainqr.FieldByName('Name').AsString;
      setBorderLine(Sh.Cells[2+i,2],4);
      Sh.Cells[2+i,3].value:=fmParent.Mainqr.FieldByName('SName').AsString;
      setBorderLine(Sh.Cells[2+i,3],4);
      Sh.Cells[2+i,4].value:=fmParent.Mainqr.FieldByName('School').AsString;
      setBorderLine(Sh.Cells[2+i,4],4);
      Sh.Cells[2+i,5].value:=fmParent.Mainqr.FieldByName('FinishDate').AsString;
      setBorderLine(Sh.Cells[2+i,5],4);
      Sh.Cells[2+i,6].value:=fmParent.Mainqr.FieldByName('Num').AsString;
      setBorderLine(Sh.Cells[2+i,6],4);
      Sh.Cells[2+i,7].value:=fmParent.Mainqr.FieldByName('DateWhere').AsString;
      OldEduc:=NewEduc;
      fmParent.Mainqr.Next;
      NewEduc:=fmParent.Mainqr.FieldByName('EducName').AsString;
      if ((i<>0) and (NewEduc<>OldEduc)) or (fmParent.Mainqr.Eof) then printGroopFooter;
      _SetProgressStatus(PBHandle,i);
      i:=i+1;
    end;

  end;

  procedure RunProfessionReport;
  var
    OldProf, NewProf: string;
    profCount: integer;

      procedure PrintGroopFooter;
      begin
        i:=i+1;
        Range:=Sh.Range[Sh.Cells[2+i,1],Sh.Cells[2+i,7]];
        Range.merge;
        Range.font.Name:=MainFont;
        Range.font.Size:=10;
        Range.RowHeight:=15;
        Range.font.Bold:=true;
        SetBorderLine(Range,3);
        Range.value:='Итого: '+IntToStr(profCount)+' человек';
        profCount:=0;
      end;

      procedure PrintHeader;
      begin
        Range:=Sh.Range[Sh.Cells[2+i,1],Sh.Cells[2+i,7]];
        Range.merge;
        Range.font.Bold:=true;
        Range.font.Name:=MainFont;
        Range.font.Size:=10;
        Range.RowHeight:=20;
        Range.HorizontalAlignment:= xlcenter;
        Range.VerticalAlignment:=xlcenter;
        Range.value:=NewProf;
        SetBorderLine(Range,2);
        i:=i+1;
      end;

  begin
    SetPageSetup(0);
    Range:=Sh.Range[Sh.Cells[1,1],Sh.Cells[1,7]];
    Range.font.Bold:=true;
    Range.font.Name:=MainFont;
    Range.font.Size:=12;
    Range.Merge;
    Range.Value:='Сведения о специальностях сотрудников на '+DateToStr(Now);
    Range.RowHeight:=20;
    Range.HorizontalAlignment:= xlcenter;
    Range.VerticalAlignment:=xlcenter;

    setcolumnHeader;

    fmParent.Mainqr.First;
    i:=1;
    while not fmParent.Mainqr.Eof do begin
      NewProf:=fmParent.Mainqr.FieldByName('ProfName').AsString;
      if NewProf<>OldProf then PrintHeader;
      ProfCount:=ProfCount+1;
      Sh.Cells[2+i,1].value:=fmParent.Mainqr.FieldByName('FName').AsString;
      setBorderLine(Sh.Cells[2+i,1],4);
      Sh.Cells[2+i,2].value:=fmParent.Mainqr.FieldByName('Name').AsString;
      setBorderLine(Sh.Cells[2+i,2],4);
      Sh.Cells[2+i,3].value:=fmParent.Mainqr.FieldByName('SName').AsString;
      setBorderLine(Sh.Cells[2+i,3],4);
      Sh.Cells[2+i,4].value:=fmParent.Mainqr.FieldByName('School').AsString;
      setBorderLine(Sh.Cells[2+i,4],4);
      Sh.Cells[2+i,5].value:=fmParent.Mainqr.FieldByName('FinishDate').AsString;
      setBorderLine(Sh.Cells[2+i,5],4);
      Sh.Cells[2+i,6].value:=fmParent.Mainqr.FieldByName('Num').AsString;
      setBorderLine(Sh.Cells[2+i,6],4);
      Sh.Cells[2+i,7].value:=fmParent.Mainqr.FieldByName('DateWhere').AsString;
      OldProf:=NewProf;
      fmParent.Mainqr.Next;
      NewProf:=fmParent.Mainqr.FieldByName('ProfName').AsString;
      if ((i<>0) and (NewProf<>OldProf)) or (fmParent.Mainqr.Eof) then printGroopFooter;
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
    if fmParent.RGReportType.ItemIndex=0 then RunEducReport else
      RunProfessionReport;
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

destructor TRptExcelThreadLocal.Destroy;
begin
  inherited;
  _FreeProgressBar(PBHandle);
end;


procedure TfmRptsEducation.EdEducKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    EdEduc.Clear;
    Educ_ID:=0;
  end;
end;

procedure TfmRptsEducation.EdProfessionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    EdProfession.Clear;
    profession_id:=0;
  end;
end;

end.
