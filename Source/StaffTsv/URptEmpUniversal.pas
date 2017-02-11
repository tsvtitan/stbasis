unit URptEmpUniversal;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet;

type
  TfmRptEmpUniversal = class(TfmRptMain)
    lbFName: TLabel;
    lbName: TLabel;
    lbSName: TLabel;
    lbSex: TLabel;
    lbPerscardnum: TLabel;
    lbFamilyStateName: TLabel;
    lbNationname: TLabel;
    lbBorntownname: TLabel;
    lbInn: TLabel;
    edFname: TEdit;
    edName: TEdit;
    edSname: TEdit;
    edPerscardnum: TEdit;
    edFamilyStateName: TEdit;
    bibFamilyStateName: TBitBtn;
    edNationname: TEdit;
    bibNationname: TBitBtn;
    edBorntownname: TEdit;
    bibBorntownname: TBitBtn;
    edSex: TEdit;
    bibSex: TBitBtn;
    edInn: TEdit;
    grbBirthDate: TGroupBox;
    dtpBirthDateFrom: TDateTimePicker;
    lbBirthDateFrom: TLabel;
    lbBirthDateTo: TLabel;
    dtpBirthDateTo: TDateTimePicker;
    bibBirthDate: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibSexClick(Sender: TObject);
    procedure bibBirthDateClick(Sender: TObject);
    procedure bibFamilyStateNameClick(Sender: TObject);
    procedure bibNationnameClick(Sender: TObject);
    procedure bibBorntownnameClick(Sender: TObject);
  private
    procedure OnRptTerminate(Sender: TObject);
    function GetFilterString: string;
  public
    sex_id: Integer;
    familystate_id: Integer;
    nation_id: Integer;
    borntown_id: Integer;

    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;
  end;

var
  fmRptEmpUniversal: TfmRptEmpUniversal;

implementation

uses UStaffTsvCode,URptThread,comobj,UMainUnited,ActiveX,
     UStaffTsvData;

type
  TRptExcelThreadTest=class(TRptExcelThread)
  private
    PBHandle: LongWord;
  public
    fmParent: TfmRptEmpUniversal;
    procedure Execute;override;
    destructor Destroy;override;
  end;

var
  Rpt: TRptExcelThreadTest;

{$R *.DFM}

procedure TfmRptEmpUniversal.FormCreate(Sender: TObject);
var
  curdate: TDate;
begin
 inherited;
 try
  Caption:=NameRptEmpUniversal;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  curdate:=_GetDateTimeFromServer;
  edFname.MaxLength:=DomainNameLength;
  edName.MaxLength:=DomainSmallNameLength;
  edSname.MaxLength:=DomainSmallNameLength;
  edSex.MaxLength:=DomainNameLength;
  edPerscardnum.MaxLength:=DomainSmallNameLength;
  edInn.MaxLength:=12;
  dtpBirthDateFrom.Date:=curdate;
  dtpBirthDateFrom.Checked:=false;
  dtpBirthDateTo.Date:=curdate;
  dtpBirthDateTo.Checked:=false;
  edFamilyStateName.MaxLength:=DomainNameLength;
  edNationname.MaxLength:=DomainNameLength;
  edBorntownname.MaxLength:=DomainNameLength;
  
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptEmpUniversal.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmRptEmpUniversal:=nil;
end;

procedure TfmRptEmpUniversal.LoadFromIni;
begin
 inherited;
 try
    edFname.Text:=ReadParam(ClassName,'Fname',edFname.Text);
    edname.Text:=ReadParam(ClassName,'Name',edname.Text);
    edSname.Text:=ReadParam(ClassName,'Sname',edSname.Text);
    edSex.Text:=ReadParam(ClassName,'Sex',edSex.Text);
    dtpbirthdateFrom.date:=ReadParam(ClassName,'BirthDateFrom',dtpbirthdateFrom.date);
    dtpbirthdateFrom.Checked:=false;
    dtpbirthdateFrom.Checked:=ReadParam(ClassName,'isBirthDateFrom',dtpbirthdateFrom.Checked);
    dtpbirthdateTo.date:=ReadParam(ClassName,'BirthDateTo',dtpbirthdateTo.date);
    dtpbirthdateTo.Checked:=false;
    dtpbirthdateTo.Checked:=ReadParam(ClassName,'isBirthDateTo',dtpbirthdateTo.Checked);
    edPerscardnum.text:=ReadParam(ClassName,'Perscardnum',edPerscardnum.text);
    edInn.text:=ReadParam(ClassName,'Inn',edInn.text);
    edFamilyStateName.text:=ReadParam(ClassName,'FamilyStateName',edFamilyStateName.text);
    edNationname.Text:=ReadParam(ClassName,'NationName',edNationname.Text);
    edBorntownname.text:=ReadParam(ClassName,'BornTownName',edBorntownname.text);
    cbInString.Checked:=ReadParam(ClassName,'Inside',cbInString.Checked);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptEmpUniversal.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'Fname',edFname.Text);
    WriteParam(ClassName,'Name',edname.Text);
    WriteParam(ClassName,'Sname',edSname.Text);
    WriteParam(ClassName,'Sex',edSex.Text);
    WriteParam(ClassName,'BirthDateFrom',dtpbirthdateFrom.date);
    WriteParam(ClassName,'isBirthDateFrom',dtpbirthdateFrom.Checked);
    WriteParam(ClassName,'BirthDateTo',dtpbirthdateTo.date);
    WriteParam(ClassName,'isBirthDateTo',dtpbirthdateTo.Checked);
    WriteParam(ClassName,'Perscardnum',edPerscardnum.text);
    WriteParam(ClassName,'Inn',edInn.text);
    WriteParam(ClassName,'FamilyStateName',edFamilyStateName.text);
    WriteParam(ClassName,'NationName',edNationname.Text);
    WriteParam(ClassName,'BornTownName',edBorntownname.text);
    WriteParam(ClassName,'Inside',cbInString.Checked);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptEmpUniversal.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptEmpUniversal.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadTest.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
end;

procedure TfmRptEmpUniversal.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;  
end;

procedure TfmRptEmpUniversal.bibSexClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sex_id';
  TPRBI.Locate.KeyValues:=sex_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSex,@TPRBI) then begin
   sex_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sex_id');
   edSex.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmRptEmpUniversal.bibBirthDateClick(Sender: TObject);
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

procedure TfmRptEmpUniversal.bibFamilyStateNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='familystate_id';
  TPRBI.Locate.KeyValues:=familystate_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkFamilystate,@TPRBI) then begin
   familystate_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'familystate_id');
   edFamilyStateName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmRptEmpUniversal.bibNationnameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='nation_id';
  TPRBI.Locate.KeyValues:=nation_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkNation,@TPRBI) then begin
   nation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'nation_id');
   edNationname.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmRptEmpUniversal.bibBorntownnameClick(Sender: TObject);
{var
  P: PTownParams;}
begin
 try
{  getMem(P,sizeof(TTownParams));
  try
   ZeroMemory(P,sizeof(TTownParams));
   P.Town_id:=borntown_id;
   if _ViewEntryFromMain(tte_rbkstown,p,true) then begin
     borntown_id:=P.Town_id;
     edBorntownname.Text:=P.TownName;
   end;
  finally
    FreeMem(P,sizeof(TTownParams));
  end;}
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmRptEmpUniversal.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  isFindFName,isFindName,isFindSName,isFindSex,isFindBirthFrom,isFindBirthTo,
  isFindPerscardnum,isFindFamilyStateName,isFindNationName,isFindBornTownName,
  isFindInn: Boolean;
  FilterInside: Boolean;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,addstr8,
  addstr9,addstr10,addstr11: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10: string;
begin
    Result:='';

    isFindFName:=Trim(edFname.Text)<>'';
    isFindName:=Trim(edname.Text)<>'';
    isFindSName:=Trim(edSname.Text)<>'';
    isFindSex:=Trim(edSex.Text)<>'';
    isFindBirthFrom:=dtpBirthDateFrom.Checked;
    isFindBirthTo:=dtpBirthDateTo.Checked;
    isFindPerscardnum:=Trim(edPerscardnum.Text)<>'';
    isFindInn:=Trim(edInn.Text)<>'';
    isFindFamilyStateName:=Trim(edFamilyStateName.text)<>'';
    isFindNationName:=Trim(edNationname.Text)<>'';
    isFindBornTownName:=Trim(edBorntownname.Text)<>'';
    FilterInside:=cbInString.Checked;

    if isFindFName or isFindName or isFindSName or isFindSex or isFindBirthFrom or
       isFindBirthTo or isFindPerscardnum or isFindFamilyStateName or isFindNationName or
       isFindBornTownName or isFindInn then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindFName then begin
        addstr1:=' Upper(fname) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edFName.Text)+'%'))+' ';
     end;

     if isFindName then begin
        addstr2:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edName.Text)+'%'))+' ';
     end;

     if isFindSName then begin
        addstr3:=' Upper(sname) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edSName.Text)+'%'))+' ';
     end;

     if isFindSex then begin
        addstr4:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edSex.Text)+'%'))+' ';
     end;

     if isFindBirthFrom then begin
        addstr5:=' e.birthdate>='+QuotedStr(DateToStr(dtpBirthDateFrom.Date))+' ';
     end;

     if isFindBirthTo then begin
        addstr6:=' e.birthdate<='+QuotedStr(DateToStr(dtpBirthDateTo.Date))+' ';
     end;

     if isFindPerscardnum then begin
        addstr7:=' Upper(e.perscardnum) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edPerscardnum.Text)+'%'))+' ';
     end;

     if isFindInn then begin
        addstr8:=' Upper(inn) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edInn.Text)+'%'))+' ';
     end;

     if isFindFamilyStateName then begin
        addstr9:=' Upper(fs.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edFamilyStateName.text)+'%'))+' ';
     end;

     if isFindNationName then begin
        addstr10:=' Upper(n.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edNationname.Text)+'%'))+' ';
     end;

     if isFindBornTownName then begin
        addstr11:=' Upper(t.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Trim(edBorntownname.Text)+'%'))+' ';
     end;


     if (isFindFName and isFindName)or
        (isFindFName and isFindSName)or
        (isFindFName and isFindSex)or
        (isFindFName and isFindBirthFrom)or
        (isFindFName and isFindBirthTo)or
        (isFindFName and isFindPerscardnum)or
        (isFindFName and isFindInn)or
        (isFindFName and isFindFamilyStateName)or
        (isFindFName and isFindNationName)or
        (isFindFName and isFindBornTownName)
        then and1:=' and ';

     if (isFindName and isFindSName)or
        (isFindName and isFindSex)or
        (isFindName and isFindBirthFrom)or
        (isFindName and isFindBirthTo)or
        (isFindName and isFindPerscardnum)or
        (isFindName and isFindInn)or
        (isFindName and isFindFamilyStateName)or
        (isFindName and isFindNationName)or
        (isFindName and isFindBornTownName)
        then and2:=' and ';

     if (isFindSName and isFindSex)or
        (isFindSName and isFindBirthFrom)or
        (isFindSName and isFindBirthTo)or
        (isFindSName and isFindPerscardnum)or
        (isFindSName and isFindInn)or
        (isFindSName and isFindFamilyStateName)or
        (isFindSName and isFindNationName)or
        (isFindSName and isFindBornTownName)
        then and3:=' and ';

     if (isFindSex and isFindBirthFrom)or
        (isFindSex and isFindBirthTo)or
        (isFindSex and isFindPerscardnum)or
        (isFindSex and isFindInn)or
        (isFindSex and isFindFamilyStateName)or
        (isFindSex and isFindNationName)or
        (isFindSex and isFindBornTownName)
        then and4:=' and ';

     if (isFindBirthFrom and isFindBirthTo)or
        (isFindBirthFrom and isFindPerscardnum)or
        (isFindBirthFrom and isFindInn)or
        (isFindBirthFrom and isFindFamilyStateName)or
        (isFindBirthFrom and isFindNationName)or
        (isFindBirthFrom and isFindBornTownName)
        then and5:=' and ';

     if (isFindBirthTo and isFindPerscardnum)or
        (isFindBirthTo and isFindInn)or
        (isFindBirthTo and isFindFamilyStateName)or
        (isFindBirthTo and isFindNationName)or
        (isFindBirthTo and isFindBornTownName)
        then and6:=' and ';

     if (isFindPerscardnum and isFindInn)or
        (isFindPerscardnum and isFindFamilyStateName)or
        (isFindPerscardnum and isFindNationName)or
        (isFindPerscardnum and isFindBornTownName)
        then and7:=' and ';

     if (isFindInn and isFindFamilyStateName)or
        (isFindInn and isFindNationName)or
        (isFindInn and isFindBornTownName)
        then and8:=' and ';

     if (isFindFamilyStateName and isFindNationName)or
        (isFindFamilyStateName and isFindBornTownName)
        then and9:=' and ';

     if (isFindNationName and isFindBornTownName)
        then and10:=' and ';
        
     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7+and7+
                      addstr8+and8+
                      addstr9+and9+
                      addstr10+and10+
                      addstr11;
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
  Sh: OleVariant;
  Data: OleVariant;
  Range: OleVariant;
  sqls: string;
  RecCount: Integer;
  Row,Column,i: Integer;
  dx,dy: Integer;
  TCPB: TCreateProgressBar;
  TSPBS: TSetProgressBarStatus;
begin
 try
  try
   if CoInitialize(nil)<>S_OK then exit;
   try
    _SetSplashStatus(ConstSqlExecute);
    fmParent.Mainqr.Active:=false;
    fmParent.Mainqr.SQL.Clear;
    fmParent.Mainqr.Transaction.Active:=true;
    sqls:='Select e.tabnum,e.fname,e.name,e.sname,s.shortname as sexshortname,'+
         'e.perscardnum,e.inn,'+
         'fs.name as familystatename,'+
         'n.name as nationname,e.birthdate'+
//         't.name as borntownname '+
         ' from '+
         tbEmp+' e join '+
         tbFamilystate+' fs on e.familystate_id=fs.familystate_id join '+
         tbNation+' n on e.nation_id=n.nation_id join '+
         tbSex+' s on e.sex_id=s.sex_id '+//left join '+
    //     tbTown+' t on e.borntown_id=t.town_id '+
         fmParent.GetFilterString+fmParent.LastOrderStr;

    fmParent.Mainqr.SQL.Add(sqls);
    fmParent.Mainqr.Active:=true;
    RecCount:=GetRecordCount(fmParent.Mainqr);
    RecCount:=RecCount+1;
    if RecCount=0 then exit;

    _SetSplashStatus(ConstReportExecute);
    
    TCPB.Min:=1;
    TCPB.Max:=RecCount;
    TCPB.Hint:='';
    TCPB.Color:=clRed;
    PBHandle:=_CreateProgressBar(@TCPB);

    if not CreateReport then exit;
    Wb:=Excel.Workbooks.Add;
    Sh:=Wb.Sheets.Item[1];
    Sh.PageSetup.Orientation:=xlLandscape;
    Data:=VarArrayCreate([1,RecCount,1,fmParent.Mainqr.Fields.Count],varVariant);
    Row:=1;
    Column:=1;
    Data[Row,Column]:='Табельный номер';
    Data[Row,Column+1]:='Фамилия';
    Data[Row,Column+2]:='Имя';
    Data[Row,Column+3]:='Отчество';
    Data[Row,Column+4]:='Пол';
    Data[Row,Column+5]:='Номер личной карточки';
    Data[Row,Column+6]:='ИНН';
    Data[Row,Column+7]:='Семейное положение';
    Data[Row,Column+8]:='Национальность';
    Data[Row,Column+9]:='Дата рождения';
//    Data[Row,Column+10]:='Где родился';
    Column:=Column+9;
    Inc(Row);
    fmParent.Mainqr.First;
    while not fmParent.Mainqr.EOF do begin
      if Terminated then exit;
      Column:=1;
      for i:=0 to fmParent.Mainqr.Fields.Count-1 do begin
        Data[Row,Column]:=FieldToVariant(fmParent.Mainqr.Fields[i]);
        Inc(Column);
      end;
      TSPBS.Progress:=Row;
      TSPBS.Hint:='';
      _SetProgressBarStatus(PBHandle,@TSPBS);
      Inc(Row);
      fmParent.Mainqr.Next;
    end;
    dx:=1;
    dy:=4;
    Range:=Sh.Range[Sh.Cells[dy,dx],Sh.Cells[dy+Row-2,dx+Column-2]];
    Range.Borders.LineStyle:=xlContinuous;
    Range.Borders.Weight:=xlThin;
    Range.Font.Size:=8;
    Range.Value:=Data;
    Range:=Sh.Range[Sh.Cells[dy,dx],Sh.Cells[dy,dx+Column-2]];
    Range.Font.Bold:=true;
    Range.HorizontalAlignment:=xlHAlignCenter;
    Range:=Sh.Range[Sh.Cells[dy,dx],Sh.Cells[dy+Row-2,dx+Column-2]];
    Range.Columns.AutoFit;

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

end.
