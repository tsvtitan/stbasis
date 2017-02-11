unit URptTestThread;

interface

{$I stbasis.inc}

uses Classes,Forms, Controls, ComObj, SysUtils, RptThread;

type
  TRptThreadTest=class(TRptExcelThread)
  private
    procedure CreateReport;
    procedure FreeReport;
  public
    constructor Create; override;
    procedure Execute; override;
    destructor Destroy;override;
  end;

var
  rptThreadTest: TRptThreadTest;

implementation

uses Windows, Graphics, OleServer, Excel97, ActiveX, Dialogs,
     UMainUnited, UStaffTsvCode, UStaffTsvData;

procedure TRptThreadTest.CreateReport;
begin
 Screen.Cursor:=crHourGlass;
 try
  try
   VarClear(Excel);
   Excel:=CreateOleObject(ConstExcelOle);
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
 finally
  Screen.Cursor:=crDefault;
 end;
end;

procedure TRptThreadTest.FreeReport;
begin
 if not VarIsEmpty(Excel) then
  Excel.Quit;
end;

constructor TRptThreadTest.Create;
begin
  inherited Create;
end;

destructor TRptThreadTest.Destroy;
begin
  rptThreadTest:=nil;
  inherited;
end;

procedure TRptThreadTest.Execute;
var
  hPB: LongWord;
  Wb: Variant;
  Sh: Variant;
  i: Integer;
  Data: Variant;
  Range: Variant;
const
  Max=1000;
  isLow=true;
begin
 try
  hPB:=0;
  CoInitialize(nil);
  CreateReport;
  if VarIsEmpty(Excel) then exit;
  try
   hPB:=_CreateProgressBar(1,Max,'Создание отчета',clred,nil);
   Excel.Visible:=false;
   Wb:=Excel.Workbooks.Add;
   Sh:=Wb.Sheets.Item[1];
   if isLow then begin
    for i:=1 to Max do begin
     _SetProgressStatus(hPB,i);
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
      Data[i]:='test '+inttostr(i);
      _SetProgressStatus(hPB,i);
    end;
    Range := Sh.Range['A1:A'+inttostr(Max)]; // To assign range
    Range.Value := Data;
    Range := Sh.Range['B1:B'+inttostr(Max)]; // To assign range
    Range.Value := Data;
    Range := Sh.Range['C1:C'+inttostr(Max)]; // To assign range
    Range.Value := Data;
    Range := Sh.Range['D1:D'+inttostr(Max)]; // To assign range
    Range.Value := Data;
   end;
   Excel.Visible:=true;
//   Sh.PrintPreview;

//   Excel.WindowState:=Integer(xlMaximized)+1;




  finally

//   FreeReport;
//   ExApp.Free;
   _FreeProgressBar(hPB);
  end;
 except
  ShowMessage('Except');
 end;
end;



end.
