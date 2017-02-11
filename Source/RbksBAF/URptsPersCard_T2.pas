unit URptsPersCard_T2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Word97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet, comobj;

type
  TfmRptsCard_T2 = class(TfmRptMain)
    EdEmp: TEdit;
    LbEmp: TLabel;
    BtCallEmp: TButton;
    procedure bibGenClick(Sender: TObject);
    procedure BtCallEmpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function getBasicSQlString: String;
    function getPassportSQlString: String;
    function getEducSQlString: String;
    function getFamStateSQlString: String;
    function getEmpConnectSQlString: String;
    function getEmpTypeLiveSQlString: String;
    function GetEmpPlantSqlString: string;

    procedure GenerateReport;override;
    procedure OnRptTerminate(Sender: TObject);
    procedure getEmpPassport;
    procedure PrepareQuery(sqls: string);
    procedure FillBasicFields(Doc: OleVariant);
    procedure FillEducationFields(Doc: OleVariant);
    procedure FillRelationFields(Doc: OleVariant);
    procedure FillConnectFields(Doc: OleVariant);
    procedure FillTypeLiveFields(Doc: OleVariant);
    procedure FillEmpPlantFields(Doc: OleVariant);

  end;

var
  fmRptsCard_T2: TfmRptsCard_T2;
  Emp_id, EmpPassport_id: Integer;
implementation
uses URptThread, UMainUnited, UFuncProc, ActiveX, Uconst;

type
  TWdBorderType = (wdBorderBottom, wdBorderDiagonalDown, wdBorderDiagonalUp,
    wdBorderHorizontal, wdBorderLeft, wdBorderRight, wdBorderTop);
  PCellBorderInfo = ^TCellBorderInfo;
  TCellBorderInfo = packed record
    Cell: OleVariant;
    BT: TWdBorderType;
  end;

  TRptWordThreadLocal=class(TRptWordThread)
  private
    PBHandle: LongWord;
  public
    CellList: TList;
    fmParent: TfmRptsCard_T2;
    procedure Execute;override;
    destructor Destroy;override;
    procedure AddToCellList(Cell: OleVariant; BT: TWdBorderType);
    procedure ClearCellList;
    procedure SetCellBorderLine;

  end;
var
  Rpt: TRptWordThreadLocal;
  filePath: string;
{$R *.DFM}

{$R Resource\pc2.res}

procedure TfmRptsCard_T2.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRptsPersCard_T2;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  getEmpPassport;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure ExtractRes(ResName, ResType, ResFileName : String);
var
  Res : TResourceStream;
begin
 try
  Res := TResourceStream.Create(Hinstance, Resname, Pchar(ResType));
  try
   Res.SavetoFile(ResFileName);
  finally
   Res.Free;
  end;
 except
 end;
end;

function GetDocFile: boolean;
var
  P: PMainOption;
begin
  Result:=false;
  New(P);
  try
   FillChar(P^,SizeOf(TMainOption),0);
   P^:=_GetOptions;
   FilePath:=P.DirTemp+'\pc2.doc' ;
   ExtractRes('PC2','REPORT',FilePath);
   result:=true;
  finally
    Dispose(P);
  end;
end;

procedure TfmRptsCard_T2.bibGenClick(Sender: TObject);
begin
  if trim(edEmp.text)<>'' then inherited;
end;

procedure TfmRptsCard_T2.BtCallEmpClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tvibvModal;
 TPRBI.Locate.KeyFields:='Emp_ID';
 TPRBI.Locate.KeyValues:=Emp_id;
 TPRBI.Locate.Options:=[];
 if _ViewInterfaceFromName(NameRbkEmp,@TPRBI) then begin
   Emp_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Emp_id');
   EdEmp.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'FName')+' '+
     GetFirstValueFromParamRBookInterface(@TPRBI,'Name')+
     GetFirstValueFromParamRBookInterface(@TPRBI,'SName');
 end;
end;

procedure TfmRptsCard_T2.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
end;

procedure TfmRptsCard_T2.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptWordThreadLocal.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume; // запуск нити
end;


procedure TfmRptsCard_T2.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then fmRptsCard_T2:=nil;
end;




procedure TRptWordThreadLocal.Execute;
var
  Doc: OleVariant;
  SQlS:String;
begin
 try
  try
   if CoInitialize(nil)<>S_OK then exit;
   try

//    _SetSplashStatus(ConstReportExecute);
//    PBHandle:=_CreateProgressBar(1,RecCount,'',clred,nil);
    CellList:=TList.Create;

    if not GetDocFile then exit;
    if not CreateReport then exit; ///???
    Doc:=Word.Documents.Open(filePath);
    Doc.Activewindow.View.TableGridlines:=false; //сокрытие сетки
    Doc.Activate;
    fmParent.PrepareQuery(fmParent.getBasicSQlString);
    fmRptsCard_T2.FillBasicFields(Doc);
    fmParent.PrepareQuery(fmRptsCard_T2.getPassportSQlString);
    fmRptsCard_T2.FillBasicFields(Doc);
    fmParent.PrepareQuery(fmRptsCard_T2.getEducSQlString);
    fmRptsCard_T2.FillEducationFields(Doc);
    fmParent.PrepareQuery(fmRptsCard_T2.getFamStateSQlString);
    fmParent.FillRelationFields(Doc);
    fmParent.PrepareQuery(fmRptsCard_T2.getEmpConnectSQlString);
    fmParent.FillConnectFields(Doc);
    fmParent.PrepareQuery(fmRptsCard_T2.getEmpTypeLiveSQlString);
    fmParent.FillTypeLiveFields(Doc);
    fmParent.PrepareQuery(fmRptsCard_T2.GetEmpPlantSqlString);
    fmParent.FillEmpPlantFields(Doc);
        
    SetCellBorderLine;
   finally
    ClearCellList;
    CellList.free;
    if not VarIsEmpty(Word) then begin
     Word.WindowState:=wdWindowStateMinimize;
     Word.Visible:=true;
     Word.WindowState:=wdWindowStateMinimize;
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

procedure TfmRptsCard_T2.FillBasicFields(Doc: OleVariant);
var
  i:integer;
  Sel, Fld:OleVariant;
  FldCode: string;

  procedure getFieldsText(FldCode: string);
  var
    S: String;
  begin
    try
      if trim(FldCode)='' then exit;
      Fld.result.text:=Mainqr.FieldByName(FldCode).AsString;
    except
    end;
  end;
begin
  for i:=1 to Doc.Fields.Count do
  begin
    Fld:=Doc.Fields.Item(i);
    FldCode:=trim(Fld.Code.text);
    getFieldsText(FldCode);
  end;
end;

destructor TRptWordThreadLocal.Destroy;
begin
  inherited;
//  _FreeProgressBar(PBHandle);
end;


function TfmRptsCard_T2.getBasicSQlString: String;
begin
  Result:='Select Emp.Fname, Emp.Name, Emp.SName, Emp.TabNum, Emp.BirthDate as BirthDay, Sx.Name as Sex, '+
    'Cntr.Name as Country, fmSt.Name as famState  From Emp '+
    'join Sex Sx on Sx.Sex_id=Emp.Sex_id join Country cntr on Emp.country_id=cntr.country_id '+
    'join FamilyState FmSt on Emp.FamilyState_id=FmSt.FamilyState_id '+
    'where Emp_id='+IntToStr(emp_id);
end;


function TfmRptsCard_T2.getPassportSQlString: String;
begin
  Result:='Select PD.*, pl.FullName as Plant from EmpPersonDoc PD Join Plant Pl on'+
    ' PD.Plant_id=Pl.Plant_id where PD.emp_id='+IntToStr(Emp_id)+' and '+
    'Pd.PersonDocType_id='+IntToStr(EmpPassport_id);
end;                                   

function TfmRptsCard_T2.getEducSQlString: String;
begin
  Result:='Select D.*, ts.Name as TypeStudy, Ed.Name as Educ, Sch.Name as School from Diplom D '+
  'join Educ Ed on D.Educ_id=Ed.Educ_id join TypeStud ts on D.TypeStud_id=ts.TypeStud_id'+
  ' join School sch on D.School_id=Sch.School_id'+
  ' where D.Emp_id='+IntToStr(Emp_id);
end;

function TfmRptsCard_T2.getEmpConnectSQlString: String;
begin
  Result:='Select EC.ConnectString as ConString, ct.Name as ConType from EmpConnect EC '+
    'join ConnectionType ct on Ec.ConnectionType_id=ct.ConnectionType_id where ec.Emp_id='+
    IntToStr(Emp_id);
end;

function TfmRptsCard_T2.getFamStateSQlString: String;
begin
  Result:='Select C.*, T.Name as Relation from Children c join TypeRelation T on'+
    ' c.Typerelation_id=t.Typerelation_id where c.emp_id='+IntToStr(Emp_id);
end;

function TfmRptsCard_T2.getEmpTypeLiveSQlString: String;
begin
  Result:='Select Es.*, cntr.Name as country, tl.Name as tpLive, str.Name as street,'+
   ' str.Postindex as str_postIndex, Reg.Name||'+QuotedStr(' ')+'||Reg.Socr as region, state.Name as state, '+
   'twn.Name as town,  pl.Name as Placement'+
   ' from EmpStreet ES left join TypeLive tl on es.TypeLive_id=tl.TypeLive_id left join'+
   ' Street str on str.Street_id=es.Street_id left join country cntr on'+
   ' es.country_id=cntr.Country_id left join Region reg on es.region_id=reg.region_id'+
   ' left join state on state.state_id=es.state_id join town twn on twn.town_id=es.town_id'+
   ' left join placement pl on pl.placement_id=es.placement_id'+
   ' where es.Emp_id='+IntToStr(Emp_id);
end;

function TfmRptsCard_T2.GetEmpPlantSqlString: string;
begin
  Result:='select ep.datestart, Ep.DateFinish, pl.FullName as plant, '+
   ' prf.name as prof from empLaborBook ep join plant pl on ep.plant_id=pl.plant_id'+
   ' join prof prf on ep.prof_id=prf.prof_id'+
   ' where ep.emp_id='+IntToStr(Emp_id)+' order by ep.DateStart';
end;

procedure TfmRptsCard_T2.FillTypeLiveFields(Doc: OleVariant);
var
  tbl, Cell: OleVariant;
  i:integer;
begin
  tbl:=Doc.Tables.Item(10);
  i:=0;
  Mainqr.First;
  While not Mainqr.Eof do
  begin
    Cell:=tbl.Cell(4+i,2);
    cell.range.text:=Mainqr.FieldByName('TpLive').AsString+' - '+
      Mainqr.FieldByName('str_postIndex').AsString+' '+
      Mainqr.FieldByName('country').AsString+' '+
      Mainqr.FieldByName('region').AsString+' '+
      Mainqr.FieldByName('state').AsString+' '+
      Mainqr.FieldByName('town').AsString+' '+
      Mainqr.FieldByName('placement').AsString;
    rpt.AddToCellList(Cell, wdBorderBottom);
    Mainqr.Next;
    i:=i+1;
    if not Mainqr.Eof then tbl.Rows.Add;
  end;
end;


procedure TfmRptsCard_T2.FillEducationFields(Doc: OleVariant);
var
  tbl, Cell: OleVariant;
  i:integer;
begin
  tbl:=Doc.Tables.Item(4);
  i:=0;
  While not Mainqr.Eof do
  begin
    Cell:=tbl.Cell(2+i,1);
    cell.range.text:=Mainqr.FieldByName('Educ').AsString;
    rpt.AddToCellList(Cell, wdBorderBottom);
    Cell:=tbl.Cell(2+i,2);
    cell.range.text:=Mainqr.FieldByName('School').AsString+' '+
      Mainqr.FieldByName('DateWhere').AsString ;
    rpt.AddToCellList(Cell, wdBorderBottom);
    Mainqr.Next;
    i:=i+1;
    if not Mainqr.Eof then tbl.Rows.Add;
  end;
end;

procedure TfmRptsCard_T2.FillRelationFields(Doc: OleVariant);
var
  tbl, Cell: OleVariant;
  i:integer;
begin
  tbl:=Doc.Tables.Item(9);
  i:=0;
  Mainqr.First;
  While not Mainqr.Eof do
  begin
    Cell:=tbl.Cell(3+i,1);
    cell.range.text:='15.'+IntToStr(i+1)+'. - '+Mainqr.FieldByName('Relation').AsString+
    ':  '+Mainqr.FieldByName('FName').AsString+' '+
    Mainqr.FieldByName('Name').AsString+' '+Mainqr.FieldByName('SName').AsString;
    rpt.AddToCellList(Cell, wdBorderBottom);
    Mainqr.Next;
    i:=i+1;
    if not Mainqr.Eof then tbl.Rows.Add;
  end;
end;

procedure TfmRptsCard_T2.FillConnectFields(Doc: OleVariant);
var
  tbl, Cell: OleVariant;
  i:integer;
begin
  tbl:=Doc.Tables.Item(11);
  i:=0;
  Mainqr.First;
  While not Mainqr.Eof do
  begin
    if (not Mainqr.Eof) and (i<>0) then tbl.Rows.Add;
    Cell:=tbl.Cell(1+i,2);
    cell.range.text:=Mainqr.FieldByName('ConType').AsString;
    rpt.AddToCellList(Cell,wdBorderBottom);
    Cell:=tbl.Cell(1+i,3);
    cell.range.text:=Mainqr.FieldByName('ConString').AsString;
    Rpt.AddToCellList(Cell,wdBorderBottom);
    Mainqr.Next;
    i:=i+1;
  end;
end;

procedure TfmRptsCard_T2.FillEmpPlantFields(Doc: OleVariant);
var
  tbl, Cell: OleVariant;
  i:integer;
begin
  tbl:=Doc.Tables.Item(7);
  i:=0;
  Mainqr.First;
  While not Mainqr.Eof do
  begin
    if (not Mainqr.Eof) and (i<>0) then tbl.Rows.Add;
    Cell:=tbl.Cell(4+i,1);
    cell.range.text:=Mainqr.FieldByName('DateStart').AsString;
    rpt.AddToCellList(Cell,wdBorderBottom);
    Cell:=tbl.Cell(4+i,2);
    cell.range.text:=Mainqr.FieldByName('DateFinish').AsString;
    Rpt.AddToCellList(Cell,wdBorderBottom);

    Cell:=tbl.Cell(4+i,3);
    cell.range.text:=Mainqr.FieldByName('Plant').AsString;
    Rpt.AddToCellList(Cell,wdBorderBottom);

    Cell:=tbl.Cell(4+i,4);
    cell.range.text:=Mainqr.FieldByName('Prof').AsString;
    Rpt.AddToCellList(Cell,wdBorderBottom);
    Mainqr.Next;
    i:=i+1;
  end;
end;


procedure TfmRptsCard_T2.getEmpPassport;
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tviOnlyData;
 TPRBI.Locate.KeyFields:='Passport_ID';
 TPRBI.Locate.KeyValues:=EmpPassport_id;
 TPRBI.Locate.Options:=[];
 if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then
   EmpPassport_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'Passport_ID');
end;


procedure TfmRptsCard_T2.PrepareQuery(sqls: string);
begin
  Mainqr.Active:=false;
  Mainqr.SQL.Clear;
  Mainqr.Transaction.Active:=true;
  Mainqr.SQL.Add(sqls);
  Mainqr.Active:=true;
end;

procedure TRptWordThreadLocal.AddToCellList(Cell: Olevariant; BT: TWdBorderType);
var
  PCB: PCellBorderInfo;
begin
  New(PCB);
  PCB.Cell:=Cell;
  Pcb.BT:=BT;
  CellList.Add(PCB);
end;

procedure TRptWordThreadLocal.ClearCellList;
var
  i: integer;
  PCB: PCellBorderInfo;
begin
  for i:=0 to CellList.Count-1 do
  begin
    PCb:=CellList.Items[i];
    Dispose(PCb);
  end;
end;

procedure TRptWordThreadLocal.SetCellBorderLine;
var
  i: integer;
  PCB: PCellBorderInfo;
  Cell, BD: Olevariant;
begin
  try
    for i:=0 to CellList.Count-1 do
    begin
      PCb:=CellList.Items[i];
      cell:=PCb.Cell;
//      Cell.Range.Font.Italic:=true;
//    Bd:=Cell.Borders.Item(wdBorderBottom);
//    BD.LineStyle:=wdLineStyleSingle;
    end;
  except
   on E: Exception do Assert(false,E.message);
  end;
end;

end.
