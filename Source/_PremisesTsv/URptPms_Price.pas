unit URptPms_Price;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URptMain, OleCtnrs, StdCtrls, Buttons, ExtCtrls, Excel97, ComCtrls, IBQuery,
  IBDatabase, Db, IBCustomDataSet, CheckLst, Menus, URptThread;

type
  TfmRptPms_Price=class;

  TTypePrice=(tpSaleClient,tpSaleAgent,tpSaleInspector,tpLeaseClient,tpLeaseAgent,
              tpLeaseInspector1,tpLeaseInspector2,tpShareClient,tpShareAgent,tpShareInspector,
              tpLeaseAgent2,tpShareAgent2,tpShareInspector2,tpShareClient2,tpShareClient3);

  TRptExcelThreadPms_Price=class(TRptExcelThread)
  private
    function GetTerminated: Boolean;
  public
    FPlantName: string;
    FCurPB: THandle;
    fmParent: TfmRptPms_Price;
    procedure Execute;override;
    destructor Destroy;override;
    procedure Synchronize(Method: TThreadMethod);
    procedure GetPlantName;
    procedure FreeCurPB;

    property Terminated read GetTerminated;
  end;

  TfmRptPms_Price = class(TfmRptMain)
    grbPrice: TGroupBox;
    rbSale: TRadioButton;
    rbLease: TRadioButton;
    rbShare: TRadioButton;
    cmbSale: TComboBox;
    cmbLease: TComboBox;
    cmbShare: TComboBox;
    lbxStatus: TCheckListBox;
    lbStatus: TLabel;
    grbRealyRecyled: TGroupBox;
    rbRealy: TRadioButton;
    rbRecyled: TRadioButton;
    rbAll: TRadioButton;
    bibMore: TButton;
    chbFirstSortByStation: TCheckBox;
    pmStatus: TPopupMenu;
    miCheckAll: TMenuItem;
    miUnCheckAll: TMenuItem;
    lbColumns: TLabel;
    lbxColumns: TCheckListBox;
    btUpColumns: TBitBtn;
    btDownColumns: TBitBtn;
    pmColumns: TPopupMenu;
    miColumnsCheckAll: TMenuItem;
    miColumnsUnCheckAll: TMenuItem;
    miColumnsDefault: TMenuItem;
    chbUseStyle: TCheckBox;
    grbOffice: TGroupBox;
    chbOffice: TCheckListBox;
    grbPeriod: TGroupBox;
    lbDateFrom: TLabel;
    lbDateTo: TLabel;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    bibDate: TButton;
    N1: TMenuItem;
    N2: TMenuItem;
    miColumnsSave: TMenuItem;
    miColumnsLoad: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibBreakClick(Sender: TObject);
    procedure bibDateClick(Sender: TObject);
    procedure rbSaleClick(Sender: TObject);
    procedure cmbSaleChange(Sender: TObject);
    procedure lbxStatusClickCheck(Sender: TObject);
    procedure bibMoreClick(Sender: TObject);
    procedure miCheckAllClick(Sender: TObject);
    procedure miUnCheckAllClick(Sender: TObject);
    procedure miColumnsCheckAllClick(Sender: TObject);
    procedure miColumnsUnCheckAllClick(Sender: TObject);
    procedure btUpColumnsClick(Sender: TObject);
    procedure btDownColumnsClick(Sender: TObject);
    procedure lbxColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbxColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbxColumnsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbxColumnsClickCheck(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btColumnsDefaultClick(Sender: TObject);
    procedure miColumnsDefaultClick(Sender: TObject);
    procedure miColumnsSaveClick(Sender: TObject);
    procedure miColumnsLoadClick(Sender: TObject);
  private
    ptCur: TPoint;
    
    procedure OnRptTerminate(Sender: TObject);
    function GetTypeOperation: Integer;
    function CheckOtherPermission: Boolean;

    procedure FillOffice;
    procedure SaveOffice;
    procedure LoadOffice;

    procedure FillStations(Strings: TStrings);
    procedure SaveStations(chbStatus: TCheckListBox);
    procedure LoadStations(chbStatus: TCheckListBox);

    procedure FillColumns(Default: Boolean=false);
    procedure SaveColumns;
    procedure LoadColumns;

    procedure UnCheckAll(chb: TCheckListBox; UnCheck: Boolean=true);
    function GetCurrentStation: TCheckListBox;

    procedure SetMoreOrLess(isMore: Boolean);

    function GetSelectedIndex: Integer;

    function isCheckedColumn(Index: Integer): Boolean;
    function GetColumnPosition(Index: Integer): Integer;
    function GetColumnsName: string;

    procedure SaveColumnsTo(const FileName: String; Stream: TStream; ToFile: Boolean=true);
    procedure LoadColumnsFrom(const FileName: String; Stream: TStream; FromFile: Boolean=true);

    function GetResFileName(TypePrice: TTypePrice): string;
  public
    curdate: TDate;
    sex_id: Integer;
    familystate_id: Integer;
    nation_id: Integer;
    borntown_id: Integer;

    procedure LoadFromIni;override;
    procedure SaveToIni;override;
    procedure GenerateReport;override;

    function GetColumnCount: Integer;
    function GetTypePriceIndex: Integer;
    function GetStationFilter: string;
    function GetRecyledFilter: String;
    function GetOrder: string;
    function GetStatusName: string;
    function GetOfficeFilter: string;

  end;

var
  fmRptPms_Price: TfmRptPms_Price;

  IscnppDateArrivals,IscnppRegionName,IscnppStreetName,IscnppHouseNumber,IscnppApartmentNumber,
  IscnppCountRoomName,IscnppTypeRoomName,IscnppPlanningName,IscnppPhoneName,IscnppSaleStatusName,
  IscnppFloor,IscnppCountFloor,IscnppTypeHouseName,IscnppGeneralArea,IscnppDwellingArea,
  IscnppKitchenArea,IscnppBalconyName,IscnppConditionName,IscnppStoveName,IscnppSanitaryNodeName,
  IscnppWaterName,IscnppHeatName,IscnppDelivery,IscnppBuilderName,IscnppPrice2,
  IscnppSelfFormName,IscnppNote,
  IscnppAgentName,IscnppStationName,
  IscnppDateTimeUpdate,IscnppFurnitureName,
  IscnppDoorName,IscnppPriceUnitPrice,IscnppContactClientInfo,
  IscnppFloorCountFloorTypeHouseName,IscnppGeneralDwellingKitchenArea,IscnppPaymentTerm,
  IscnppDecoration,IscnppGlassy,IscnppBlockSection,IscnppContact,IscnppClientInfo,IscnppPrice

  : Boolean;

  IndcnppDateArrivals,IndcnppRegionName,IndcnppStreetName,IndcnppHouseNumber,IndcnppApartmentNumber,
  IndcnppCountRoomName,IndcnppTypeRoomName,IndcnppPlanningName,IndcnppPhoneName,IndcnppSaleStatusName,
  IndcnppFloor,IndcnppCountFloor,IndcnppTypeHouseName,IndcnppGeneralArea,IndcnppDwellingArea,
  IndcnppKitchenArea,IndcnppBalconyName,IndcnppConditionName,IndcnppStoveName,IndcnppSanitaryNodeName,
  IndcnppWaterName,IndcnppHeatName,IndcnppDelivery,IndcnppBuilderName,IndcnppPrice2,
  IndcnppSelfFormName,IndcnppNote,
  IndcnppAgentName,IndcnppStationName,
  IndcnppDateTimeUpdate,IndcnppFurnitureName,
  IndcnppDoorName,IndcnppPriceUnitPrice,IndcnppContactClientInfo,
  IndcnppFloorCountFloorTypeHouseName,IndcnppGeneralDwellingKitchenArea,IndcnppPaymentTerm,
  IndcnppDecoration,IndcnppGlassy,IndcnppBlockSection,IndcnppContact,IndcnppClientInfo,IndcnppPrice

  : Integer;

function GetPms_Station_IdBySortNumber(SortNumber: Integer): string;
function TranslateContact(Value: string): string;

implementation

uses UPremisesTsvCode,comobj,UMainUnited,ActiveX,
     UPremisesTsvData, FileCtrl, UPremisesTsvOptions, UPms_United,
     URptPms_PriceLeaseClient, URptPms_PriceLeaseAgent, URptPms_PriceLeaseInspector1,
     URptPms_PriceLeaseInspector2, URptPms_PriceSaleClient, URptPms_PriceSaleAgent,
     URptPms_PriceSaleInspector, URptPms_PriceShareClient, URptPms_PriceShareAgent,
     URptPms_PriceShareInspector,URptPms_PriceLeaseAgent2, URptPms_PriceShareAgent2,
     URptPms_PriceShareInspector2, URptPms_PriceShareClient2, URptPms_PriceShareClient3;


var
  Rpt: TRptExcelThreadPms_Price;

{$R *.DFM}

function GetPms_Station_IdBySortNumber(SortNumber: Integer): string;
var
 qr: TIbQuery;
 tran: TIBTransaction;
 sqls: string;
begin
 Result:='';
 qr:=TIBQuery.Create(nil);
 tran:=TIBTransaction.Create(nil);
 try
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qr.Transaction:=tran;
   qr.Database:=IBDB;
   tran.Active:=true;

   sqls:=SQLRbkPms_Station+
         ' where sortnumber='+inttostr(SortNumber)+
         ' order by sortnumber';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   qr.First;
   while not qr.Eof do begin
     Result:=Result+qr.FieldByName('pms_station_id').AsString;
     qr.Next;
     Result:=iff(not qr.Eof,Result+',',Result);
   end;
 finally
   tran.free;
   qr.Free;
 end;
end;

function TranslateContact(Value: string): string;
var
 Apos: Integer;
 s: string;
const
 Delim=',';
begin
 Apos:=-1;
 while Apos<>0 do begin
   APos:=Pos(Delim,Value);
   if Apos>0 then begin
     s:=iff(s='','',s+' ')+ChangeString(Copy(Value,1,APos),' ','');
     Value:=Copy(Value,APos+Length(Delim),Length(Value));
   end else s:=iff(s='','',s+' ')+ChangeString(Value,' ','');
 end;
 Result:=s;
end;


procedure TfmRptPms_Price.FormCreate(Sender: TObject);
var
  Y,M,D: Word;
begin
 inherited;
 try
  Caption:=NameRptPms_Price;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  curdate:=_GetDateTimeFromServer;
  DecodeDate(curdate,Y,M,D);
  dtpDateFrom.Date:=StrToDate('01.01.'+inttostr(Y-10));
  dtpDateTo.Date:=curdate;

  cmbSale.ItemIndex:=0;
  cmbLease.ItemIndex:=0;
  cmbShare.ItemIndex:=0;

  CheckOtherPermission;

  FillOffice;
  FillStations(lbxStatus.Items);

  LoadFromIni;

  SetMoreOrLess(false);

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptPms_Price.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(Rpt);
  if FormState=[fsCreatedMDIChild] then
   fmRptPms_Price:=nil;
end;

function TfmRptPms_Price.GetTypeOperation: Integer;
begin
  Result:=-1;
  if rbSale.Checked then Result:=0;
  if rbLease.Checked then Result:=1;
  if rbShare.Checked then Result:=2;
end;

function TfmRptPms_Price.CheckOtherPermission: Boolean;
var
  TPRBI: TParamRBookInterface;
  T: TInfoConnectUser;
  s,e,i: Integer;
  perm: string;
  isSelect: Boolean;
begin
  isSelect:=false;
  FillChar(T,SizeOf(T),0);
  _GetInfoConnectUser(@T);
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' '+tbUsers+'.user_id='+inttostr(T.User_id)+' and typeoperation='+inttostr(GetTypeOperation)+' ');
  if _ViewInterfaceFromName(NameRbkPms_Perm,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    for i:=s to e do begin
      perm:=GetValueByPRBI(@TPRBI,i,'perm');
      if AnsiSameText(perm,SelConst) then isSelect:=true;
    end;
  end;
  bibGen.Enabled:=isSelect;
  Result:=isSelect;
end;

function TfmRptPms_Price.GetCurrentStation: TCheckListBox;
begin
  Result:=lbxStatus;
end;

function TfmRptPms_Price.GetTypePriceIndex: Integer;
begin
  Result:=-1;
  if rbSale.Checked then Result:=cmbSale.ItemIndex;
  if rbLease.Checked then Result:=cmbLease.ItemIndex;
  if rbShare.Checked then Result:=cmbShare.ItemIndex;
end;

procedure TfmRptPms_Price.UnCheckAll(chb: TCheckListBox; UnCheck: Boolean=true);
var
  i: Integer;
begin
  for i:=0 to chb.Items.Count-1 do begin
    chb.Checked[i]:=not UnCheck;  
  end;
end;

function TfmRptPms_Price.GetStatusName: string;
begin
  Result:='';
  if rbSale.Checked then Result:='lbxSaleStatus';
  if rbLease.Checked then Result:='lbxLeaseStatus';
  if rbShare.Checked then Result:='lbxShareStatus';
end;

procedure TfmRptPms_Price.LoadStations(chbStatus: TCheckListBox);
var
  s: string;
  Apos: Integer;
  val: string;
  ind: Integer;
begin
  if chbStatus=nil then exit;
  s:=ReadParam(ClassName,GetStatusName+inttostr(GetTypePriceIndex),s);
  UnCheckAll(chbStatus);
  if Trim(s)='' then exit;
  APos:=-1;
  while Apos<>0 do begin
    Apos:=AnsiPos(ConstDelimStation,s);
    if APos>0 then begin
       val:=Copy(s,1,Apos-1);
       s:=Copy(s,Apos+Length(ConstDelimStation),Length(s));
       ind:=chbStatus.Items.IndexOfObject(TObject(StrToInt(val)));
       if ind<>-1 then
         chbStatus.Checked[ind]:=true;
    end else begin
      ind:=chbStatus.Items.IndexOfObject(TObject(StrToInt(s)));
      if ind<>-1 then
        chbStatus.Checked[ind]:=true;
    end;
  end;
end;

procedure TfmRptPms_Price.LoadFromIni;
begin
 inherited;
 try
    LoadOffice;
    rbSale.Checked:=ReadParam(ClassName,rbSale.Name,rbSale.Checked);
    rbLease.Checked:=ReadParam(ClassName,rbLease.Name,rbLease.Checked);
    rbShare.Checked:=ReadParam(ClassName,rbShare.Name,rbShare.Checked);
    cmbSale.ItemIndex:=ReadParam(ClassName,cmbSale.Name,cmbSale.ItemIndex);
    cmbLease.ItemIndex:=ReadParam(ClassName,cmbLease.Name,cmbLease.ItemIndex);
    cmbShare.ItemIndex:=ReadParam(ClassName,cmbShare.Name,cmbShare.ItemIndex);
    LoadStations(GetCurrentStation);
    chbFirstSortByStation.Checked:=ReadParam(ClassName,chbFirstSortByStation.Name,chbFirstSortByStation.Checked);
    chbUseStyle.Checked:=ReadParam(ClassName,chbUseStyle.Name,chbUseStyle.Checked);
    FillColumns;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptPms_Price.SaveStations(chbStatus: TCheckListBox);
var
  s: string;
  i: Integer;
  Flag: Boolean;
begin
  if chbStatus=nil then exit;
  Flag:=true;
  for i:=0 to chbStatus.Items.Count-1 do begin
    if chbStatus.Checked[i] then begin
      if Flag then s:=Inttostr(Integer(chbStatus.Items.Objects[i]))
      else s:=s+ConstDelimStation+Inttostr(Integer(chbStatus.Items.Objects[i]));
      Flag:=false;
    end;
  end;
  WriteParam(ClassName,GetStatusName+inttostr(GetTypePriceIndex),s);
end;

procedure TfmRptPms_Price.SaveToIni;
begin
 inherited;
 try
    SaveOffice;
    WriteParam(ClassName,rbSale.Name,rbSale.Checked);
    WriteParam(ClassName,rbLease.Name,rbLease.Checked);
    WriteParam(ClassName,rbShare.Name,rbShare.Checked);
    WriteParam(ClassName,cmbSale.Name,cmbSale.ItemIndex);
    WriteParam(ClassName,cmbLease.Name,cmbLease.ItemIndex);
    WriteParam(ClassName,cmbShare.Name,cmbShare.ItemIndex);
    SaveStations(GetCurrentStation);
    WriteParam(ClassName,chbFirstSortByStation.Name,chbFirstSortByStation.Checked);
    WriteParam(ClassName,chbUseStyle.Name,chbUseStyle.Checked);
    SaveColumns;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRptPms_Price.OnRptTerminate(Sender: TObject);
begin
  FreeAndNil(Rpt);
  bibBreakClick(nil);
  lbDateFrom.Enabled:=true;
  dtpDateFrom.Color:=clWindow;
  dtpDateFrom.Enabled:=true;
  lbDateTo.Enabled:=true;
  dtpDateTo.Color:=clWindow;
  dtpDateTo.Enabled:=true;
  bibDate.Enabled:=true;
  grbPrice.Enabled:=true;
  rbRealy.Enabled:=true;
  rbRecyled.Enabled:=true;
  rbAll.Enabled:=true;
end;

procedure TfmRptPms_Price.GenerateReport;
begin
  if Rpt<>nil then exit;
  Rpt:=TRptExcelThreadPms_Price.Create;
  Rpt.fmParent:=Self;
  Rpt.OnTerminate:=OnRptTerminate;
  Rpt.Resume;
  lbDateFrom.Enabled:=false;
  dtpDateFrom.Color:=clBtnFace;
  dtpDateFrom.Enabled:=false;
  lbDateTo.Enabled:=false;
  dtpDateTo.Color:=clBtnFace;
  dtpDateTo.Enabled:=false;
  bibDate.Enabled:=false;
  rbRealy.Enabled:=false;
  rbRecyled.Enabled:=false;
  rbAll.Enabled:=false;
  grbPrice.Enabled:=false;
end;

procedure TfmRptPms_Price.bibBreakClick(Sender: TObject);
begin
  if Rpt<>nil then
    Rpt.Terminate;
  inherited;
end;

procedure TfmRptPms_Price.bibDateClick(Sender: TObject);
var
  T: TInfoEnterPeriod;
begin
  FillChar(T,SizeOf(T),0);
  T.TypePeriod:=tepInterval;
  T.LoadAndSave:=false;
  T.DateBegin:=dtpDateFrom.DateTime;
  T.DateEnd:=dtpDateTo.DateTime;
  if _ViewEnterPeriod(@T) then begin
    dtpDateFrom.DateTime:=T.DateBegin;
    dtpDateTo.DateTime:=T.DateEnd;
  end;
end;

{ TRptExcelThreadPms_Price }

destructor TRptExcelThreadPms_Price.Destroy;
begin
  inherited;
  FreeCurPB;
end;

procedure TRptExcelThreadPms_Price.FreeCurPB;
begin
  _FreeProgressBar(FCurPB);
end;

procedure TRptExcelThreadPms_Price.Synchronize(Method: TThreadMethod);
begin
  inherited Synchronize(Method);
end;

function TRptExcelThreadPms_Price.GetTerminated: Boolean;
begin
  Result:=inherited Terminated;
end;

procedure TRptExcelThreadPms_Price.GetPlantName;
var
  TPRBI: TParamRbookInterface;
begin
  FPlantName:='';
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr('ПРЕДПРИЯТИЕ')+' ');
  if _ViewInterfaceFromName(NameRbkConst,@TPRBI) then begin
    FPlantName:=GetFirstValueFromPRBI(@TPRBI,'valueview');
  end;
end;


procedure TRptExcelThreadPms_Price.Execute;
var
  M: TMainOption;

  FSyncOfficeId: String;
  UseStyle: Boolean;

  function GetTypeOperation: string;
  begin
    Result:='';
    if fmParent.rbSale.Checked then Result:=fmParent.rbSale.Caption;
    if fmParent.rbLease.Checked then Result:=fmParent.rbLease.Caption;
    if fmParent.rbShare.Checked then Result:=fmParent.rbShare.Caption;
  end;

  function GetPriceName: string;
  begin
    Result:='';
    if fmParent.rbSale.Checked then Result:=fmParent.cmbSale.Text;
    if fmParent.rbLease.Checked then Result:=fmParent.cmbLease.Text;
    if fmParent.rbShare.Checked then Result:=fmParent.cmbShare.Text;
  end;

  function ExtractResourceToFile(const FileName: string; ResName: string): Boolean;
  var
    rs: TResourceStream;
  begin
    rs:=nil;
    try
      Result:=false;
      rs:=TResourceStream.Create(HINSTANCE,ResName,ConstResTypeReport);
      rs.SaveToFile(FileName);
      Result:=true;
    finally
      rs.Free;
    end;
  end;

   function GetFileName(TypePrice: TTypePrice): string;
   var
     ToFile: string;
     FromFile: string;
     S: String;
     Dir: String;
   begin
     S:=FormatDateTime('dd.mm.yyyy hh.nn.ss',Now);
     ToFile:=M.DirTemp+'\'+GetTypeOperation+' - '+GetPriceName+' - '+S+ConstExtExcel;
     ToFile:=ExpandFileName(ToFile);
     FileSetAttr(ToFile,DDL_READWRITE);
     DeleteFile(ToFile);
     Dir:=ExpandFileName(fmOptions.edReportDir.Text);
     if not DirectoryExists(Dir) then begin
       if not ExtractResourceToFile(ToFile,fmParent.GetResFileName(TypePrice)) then exit;
     end else begin
       FromFile:=Dir+'\'+fmParent.GetResFileName(TypePrice)+ConstExtExcel;
       if not FileExists(FromFile) then begin
         if not ExtractResourceToFile(ToFile,fmParent.GetResFileName(TypePrice)) then exit;
       end else begin
         if not CopyFile(PChar(FromFile),PChar(ToFile),false) then exit;
       end;
     end;
     Result:=ToFile;
   end;


   function GCP(Index: Integer): Integer;
   begin
     Result:=fmParent.GetColumnPosition(Index)+1;
   end;

   function isCC(Index: Integer): Boolean;
   begin
     Result:=fmParent.isCheckedColumn(Index);
   end;


   procedure RptSaleRun;
   begin
     case fmParent.cmbSale.ItemIndex of
       0: RtpSaleRunClient(Self,fmParent,fmOptions,GetFileName(tpSaleClient),GetTypeOperation,UseStyle,FSyncOfficeId);
       1: RtpSaleRunAgent(Self,fmParent,fmOptions,GetFileName(tpSaleAgent),GetTypeOperation,UseStyle,FSyncOfficeId);
       2: RtpSaleRunInspector(Self,fmParent,fmOptions,GetFileName(tpSaleInspector),GetTypeOperation,UseStyle,FSyncOfficeId);
     end;
   end;

   procedure RptLeaseRun;
   begin
     case fmParent.cmbLease.ItemIndex of
       0: RtpLeaseRunClient(Self,fmParent,fmOptions,GetFileName(tpLeaseClient),GetTypeOperation,UseStyle,FSyncOfficeId);
       1: RtpLeaseRunAgent(Self,fmParent,fmOptions,GetFileName(tpLeaseAgent),GetTypeOperation,UseStyle,FSyncOfficeId);
       2: RtpLeaseRunInspector1(Self,fmParent,fmOptions,GetFileName(tpLeaseInspector1),GetTypeOperation,UseStyle,FSyncOfficeId);
       3: RtpLeaseRunInspector2(Self,fmParent,fmOptions,GetFileName(tpLeaseInspector2),GetTypeOperation,UseStyle,FSyncOfficeId);
       4: RtpLeaseRunAgent2(Self,fmParent,fmOptions,GetFileName(tpLeaseAgent2),GetTypeOperation,UseStyle,FSyncOfficeId);
     end;
   end;

   procedure RptShareRun;
   begin
     case fmParent.cmbShare.ItemIndex of
       0: RtpShareRunClient(Self,fmParent,fmOptions,GetFileName(tpShareClient),GetTypeOperation,UseStyle,FSyncOfficeId);
       1: RtpShareRunAgent(Self,fmParent,fmOptions,GetFileName(tpShareAgent),GetTypeOperation,UseStyle,FSyncOfficeId);
       2: RtpShareRunInspector(Self,fmParent,fmOptions,GetFileName(tpShareInspector),GetTypeOperation,UseStyle,FSyncOfficeId);
       3: RtpShareRunAgent2(Self,fmParent,fmOptions,GetFileName(tpShareAgent2),GetTypeOperation,UseStyle,FSyncOfficeId);
       4: RtpShareRunInspector2(Self,fmParent,fmOptions,GetFileName(tpShareInspector2),GetTypeOperation,UseStyle,FSyncOfficeId);
       5: RtpShareRunClient2(Self,fmParent,fmOptions,GetFileName(tpShareClient2),GetTypeOperation,UseStyle,FSyncOfficeId);
       6: RtpShareRunClient3(Self,fmParent,fmOptions,GetFileName(tpShareClient3),GetTypeOperation,UseStyle,FSyncOfficeId);
     end;
   end;

  procedure SetSyncOfficeId;
  var
    TPRBI: TParamRbookInterface;
  begin
    FSyncOfficeId:='';
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr('ОФИС')+' ');
    if _ViewInterfaceFromName(NameRbkConst,@TPRBI) then begin
      FSyncOfficeId:=GetFirstValueFromPRBI(@TPRBI,'valueview');
    end;
  end;


var
  TCLI: TCreateLogItem;
begin
   M:=_GetOptions;
   if not DirectoryExists(M.DirTemp) then begin
     FillChar(TCLI,SizeOf(TCLI),0);
     TCLI.Text:=PChar(Format('Директория %s не найдена.',[M.DirTemp]));
     TCLI.TypeLogItem:=tliError;
      _CreateLogItem(@TCLI);
      _ViewLog(true);
     exit;
   end;
   
   if CoInitialize(nil)<>S_OK then exit;
   try
     try
       if not CreateReport(false) then exit;
       IscnppDateArrivals:=isCC(cnppDateArrivals);
       IscnppRegionName:=isCC(cnppRegionName);
       IscnppStreetName:=isCC(cnppStreetName);
       IscnppHouseNumber:=isCC(cnppHouseNumber);
       IscnppApartmentNumber:=isCC(cnppApartmentNumber);
       IscnppCountRoomName:=isCC(cnppCountRoomName);
       IscnppTypeRoomName:=isCC(cnppTypeRoomName);
       IscnppPlanningName:=isCC(cnppPlanningName);
       IscnppPhoneName:=isCC(cnppPhoneName);
       IscnppSaleStatusName:=isCC(cnppSaleStatusName);
       IscnppFloor:=isCC(cnppFloor);
       IscnppCountFloor:=isCC(cnppCountFloor);
       IscnppTypeHouseName:=isCC(cnppTypeHouseName);
       IscnppGeneralArea:=isCC(cnppGeneralArea);
       IscnppDwellingArea:=isCC(cnppDwellingArea);
       IscnppKitchenArea:=isCC(cnppKitchenArea);
       IscnppBalconyName:=isCC(cnppBalconyName);
       IscnppConditionName:=isCC(cnppConditionName);
       IscnppStoveName:=isCC(cnppStoveName);
       IscnppSanitaryNodeName:=isCC(cnppSanitaryNodeName);
       IscnppWaterName:=isCC(cnppWaterName);
       IscnppHeatName:=isCC(cnppHeatName);
       IscnppSelfFormName:=isCC(cnppSelfFormName);
       IscnppNote:=isCC(cnppNote);
       IscnppAgentName:=isCC(cnppAgentName);
       IscnppStationName:=isCC(cnppStationName);
       IscnppDateTimeUpdate:=isCC(cnppDateTimeUpdate);
       IscnppFurnitureName:=isCC(cnppFurnitureName);
       IscnppDoorName:=isCC(cnppDoorName);
       IscnppPriceUnitPrice:=isCC(cnppPriceUnitPrice);
       IscnppContactClientInfo:=isCC(cnppContactClientInfo);
       IscnppFloorCountFloorTypeHouseName:=isCC(cnppFloorCountFloorTypeHouseName);
       IscnppGeneralDwellingKitchenArea:=isCC(cnppGeneralDwellingKitchenArea);
       IscnppPaymentTerm:=isCC(cnppPaymentTerm);
       IscnppDelivery:=isCC(cnppDelivery);
       IscnppBuilderName:=isCC(cnppBuilderName);
       IscnppPrice2:=isCC(cnppPrice2);
       IscnppDecoration:=isCC(cnppDecoration);
       IscnppGlassy:=isCC(cnppGlassy);
       IscnppBlockSection:=isCC(cnppBlockSection);
       IscnppContact:=isCC(cnppContact);
       IscnppClientInfo:=isCC(cnppClientInfo);
       IscnppPrice:=isCC(cnppPrice);

       IndcnppDateArrivals:=GCP(cnppDateArrivals);
       IndcnppRegionName:=GCP(cnppRegionName);
       IndcnppStreetName:=GCP(cnppStreetName);
       IndcnppHouseNumber:=GCP(cnppHouseNumber);
       IndcnppApartmentNumber:=GCP(cnppApartmentNumber);
       IndcnppCountRoomName:=GCP(cnppCountRoomName);
       IndcnppTypeRoomName:=GCP(cnppTypeRoomName);
       IndcnppPlanningName:=GCP(cnppPlanningName);
       IndcnppPhoneName:=GCP(cnppPhoneName);
       IndcnppSaleStatusName:=GCP(cnppSaleStatusName);
       IndcnppFloor:=GCP(cnppFloor);
       IndcnppCountFloor:=GCP(cnppCountFloor);
       IndcnppTypeHouseName:=GCP(cnppTypeHouseName);
       IndcnppGeneralArea:=GCP(cnppGeneralArea);
       IndcnppDwellingArea:=GCP(cnppDwellingArea);
       IndcnppKitchenArea:=GCP(cnppKitchenArea);
       IndcnppBalconyName:=GCP(cnppBalconyName);
       IndcnppConditionName:=GCP(cnppConditionName);
       IndcnppStoveName:=GCP(cnppStoveName);
       IndcnppSanitaryNodeName:=GCP(cnppSanitaryNodeName);
       IndcnppWaterName:=GCP(cnppWaterName);
       IndcnppHeatName:=GCP(cnppHeatName);
       IndcnppSelfFormName:=GCP(cnppSelfFormName);
       IndcnppNote:=GCP(cnppNote);
       IndcnppAgentName:=GCP(cnppAgentName);
       IndcnppStationName:=GCP(cnppStationName);
       IndcnppDateTimeUpdate:=GCP(cnppDateTimeUpdate);
       IndcnppFurnitureName:=GCP(cnppFurnitureName);
       IndcnppDoorName:=GCP(cnppDoorName);
       IndcnppPriceUnitPrice:=GCP(cnppPriceUnitPrice);
       IndcnppContactClientInfo:=GCP(cnppContactClientInfo);
       IndcnppFloorCountFloorTypeHouseName:=GCP(cnppFloorCountFloorTypeHouseName);
       IndcnppGeneralDwellingKitchenArea:=GCP(cnppGeneralDwellingKitchenArea);
       IndcnppPaymentTerm:=GCP(cnppPaymentTerm);
       IndcnppDelivery:=GCP(cnppDelivery);
       IndcnppBuilderName:=GCP(cnppBuilderName);
       IndcnppPrice2:=GCP(cnppPrice2);
       IndcnppDecoration:=GCP(cnppDecoration);
       IndcnppGlassy:=GCP(cnppGlassy);
       IndcnppBlockSection:=GCP(cnppBlockSection);
       IndcnppContact:=GCP(cnppContact);
       IndcnppClientInfo:=GCP(cnppClientInfo);
       IndcnppPrice:=GCP(cnppPrice);

       SetSyncOfficeId;
       UseStyle:=fmParent.chbUseStyle.Checked;

       if fmParent.rbSale.Checked then RptSaleRun;
       if fmParent.rbLease.Checked then RptLeaseRun;
       if fmParent.rbShare.Checked then RptShareRun;
     except
      {$IFDEF DEBUG}
        on E: Exception do begin
         try
           TCLI.ViewLogItemProc:=nil;
           TCLI.TypeLogItem:=tliError;
           TCLI.Text:=PChar(E.message);
           _CreateLogItem(@TCLI);

           Assert(false,E.message);
         except
           Application.HandleException(nil);
         end;
        end;
      {$ENDIF}
     end;
   finally
     if not VarIsEmpty(Excel) then begin
       if not VarIsEmpty(Excel.ActiveWindow) then
         Excel.ActiveWindow.WindowState:=xlMaximized;
       Excel.Visible:=true;
       Excel.WindowState:=xlMaximized;
       Excel.WindowState:=xlMaximized;
     end;
     CoUninitialize;
     DoTerminate;
   end;
end;

procedure TfmRptPms_Price.rbSaleClick(Sender: TObject);
var
  isPerm: Boolean;
begin
  isPerm:=CheckOtherPermission;
  cmbSale.Enabled:=rbSale.Checked and isPerm;
  cmbSale.Color:=iff(rbSale.Checked and isPerm,clWindow,clBtnFace);

  cmbLease.Enabled:=rbLease.Checked and isPerm;
  cmbLease.Color:=iff(rbLease.Checked and isPerm,clWindow,clBtnFace);

  cmbShare.Enabled:=rbShare.Checked and isPerm;
  cmbShare.Color:=iff(rbShare.Checked and isPerm,clWindow,clBtnFace);

  lbStatus.Enabled:=isPerm;
  lbxStatus.Enabled:=isPerm;
  lbxStatus.Color:=iff(isPerm,clWindow,clBtnFace);
  LoadStations(GetCurrentStation);
  FillColumns;
end;

procedure TfmRptPms_Price.FillStations(Strings: TStrings);
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' sortnumber ');
  if _ViewInterfaceFromName(NameRbkPms_Station,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    Strings.BeginUpdate;
    try
      Strings.Clear;
      Strings.AddObject('пустой',nil);
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'pms_Station_id');
        Strings.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

procedure TfmRptPms_Price.cmbSaleChange(Sender: TObject);
begin
  LoadStations(GetCurrentStation);
  FillColumns;
end;

procedure TfmRptPms_Price.lbxStatusClickCheck(Sender: TObject);
begin
  SaveStations(GetCurrentStation);
end;

function TfmRptPms_Price.GetStationFilter: string;
var
  chb: TCheckListBox;
  i: Integer;
  Flag,Flag1: Boolean;
  id: String;
begin
  Result:='';
  chb:=GetCurrentStation;
  if chb=nil then exit;
  Flag:=true;
  Flag1:=true;
  for i:=0 to chb.Items.Count-1 do begin
    if chb.Checked[i] then begin
      if chb.Items.Objects[i]<>nil then begin
        id:=IntTostr(Integer(chb.Items.Objects[i]));
        if Flag then begin
          if Flag1 then
            Result:=' and p.pms_station_id in ('+id
          else Result:=Result+' or p.pms_station_id in ('+id;
        end else Result:=Result+','+id;
        Flag:=false;
      end else begin
        if Flag1 then Result:=' and ( p.pms_station_id is null';
        Flag1:=false;
      end;
    end;
  end;
  if (not Flag1)or (not Flag) then begin
    if not Flag1 then Result:=Result+') ';
    if not Flag then Result:=Result+') ';
  end;
end;

function TfmRptPms_Price.GetRecyledFilter: String;
begin
  Result:='';
  if rbRealy.Checked then Result:=' and p.recyled=0 ';
  if rbRecyled.Checked then Result:=' and p.recyled=1 ';
  if rbAll.Checked then Result:=' and p.recyled in (0,1) ';
end;

procedure TfmRptPms_Price.SetMoreOrLess(isMore: Boolean);
var
  h: Integer;
begin
  bibMore.Caption:=Iff(isMore,'меньше','больше');
  grbPrice.Height:=iff(not isMore,bibMore.Top+bibMore.Height+9,lbxStatus.top+lbxStatus.Height+9);
  h:=grbOffice.Top+grbOffice.Height+grbRealyRecyled.Height+grbPrice.Height+pnBut.Height+3;
  Constraints.MinHeight:=h+40;
  Constraints.MaxHeight:=Constraints.MinHeight;
  Height:=h;
end;

procedure TfmRptPms_Price.bibMoreClick(Sender: TObject);
begin
  SetMoreOrLess(iff(bibMore.Caption='больше',true,false));
end;

function TfmRptPms_Price.GetOrder: string;
begin
  if rbShare.Checked and (cmbShare.ItemIndex in [3,4]) then begin
    Result:='p.contact, cr.sortnumber, r.sortnumber, p.price';
  end else begin
    Result:='cr.sortnumber, r.sortnumber, s.name, p.housenumber, p.apartmentnumber';
  end;

  if chbFirstSortByStation.Checked then
    Result:='Order by st.sortnumber, '+Result
  else
    Result:='Order by '+Result;

end;

procedure TfmRptPms_Price.miCheckAllClick(Sender: TObject);
begin
  UnCheckAll(lbxStatus,false);
  SaveStations(GetCurrentStation);
end;

procedure TfmRptPms_Price.miUnCheckAllClick(Sender: TObject);
begin
  UnCheckAll(lbxStatus,true);
  SaveStations(GetCurrentStation);
end;

procedure TfmRptPms_Price.miColumnsCheckAllClick(Sender: TObject);
begin
  UnCheckAll(lbxColumns,false);
  SaveColumns;
end;

procedure TfmRptPms_Price.miColumnsUnCheckAllClick(Sender: TObject);
begin
  UnCheckAll(lbxColumns,true);
  SaveColumns;
end;

function TfmRptPms_Price.GetSelectedIndex: Integer;
var
  I: Integer;
  chb: TCheckListBox;
begin
  result:=-1;
  chb:=lbxColumns;
  if chb=nil then exit;
  for i:=0 to chb.Items.Count-1 do begin
    if chb.Selected[i] then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TfmRptPms_Price.btUpColumnsClick(Sender: TObject);
var
  Index: Integer;
  chb: TCheckListBox;
begin
  Index:=GetSelectedIndex;
  chb:=lbxColumns;
  if chb=nil then exit;
  if Index>0 then begin
    chb.Items.Move(Index,Index-1);
    chb.ItemIndex:=Index-1;
    SaveColumns;
  end;
  chb.SetFocus;
end;

procedure TfmRptPms_Price.btDownColumnsClick(Sender: TObject);
var
  Index: Integer;
  chb: TCheckListBox;
begin
  Index:=GetSelectedIndex;
  chb:=lbxColumns;
  if chb=nil then exit;
  if (Index<>-1)and(Index<>chb.Items.Count-1) then begin
    chb.Items.Move(Index,Index+1);
    chb.ItemIndex:=Index+1;
    SaveColumns;
  end;
  chb.SetFocus;
end;

procedure TfmRptPms_Price.lbxColumnsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  val:=TCheckListBox(Sender).ItemAtPos(Classes.Point(X,Y),true);
  if val<>-1 then begin
    if val<>TCheckListBox(Sender).ItemIndex then begin
     if TCheckListBox(Sender).ItemIndex=-1 then exit;
     TCheckListBox(Sender).Items.Move(TCheckListBox(Sender).ItemIndex,val);
     TCheckListBox(Sender).ItemIndex:=val;
     SaveColumns;
    end;
  end;
end;

procedure TfmRptPms_Price.lbxColumnsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  val: Integer;
begin
  Accept:=false;
  if Sender=Source then begin
    val:=TCheckListBox(Sender).ItemAtPos(Classes.Point(X,Y),true);
    if val<>-1 then begin
     if val<>TCheckListBox(Sender).ItemIndex then begin
       ptCur:=Classes.Point(X,Y);
       Accept:=true;
     end;
    end;
  end;
end;

procedure TfmRptPms_Price.lbxColumnsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  val: Integer;
begin
   if (Shift=[ssLeft]) then begin
    val:=TCheckListBox(Sender).ItemAtPos(Classes.Point(X,Y),true);
    if val<>-1 then begin
     if val=TCheckListBox(Sender).ItemIndex then begin
       TCheckListBox(Sender).BeginDrag(true);
     end;
    end;
   end;
end;

function TfmRptPms_Price.GetResFileName(TypePrice: TTypePrice): string;
begin
 Result:='';
 case TypePrice of
   tpSaleClient: Result:=ConstResNamePms_Price_SaleClient;
   tpSaleAgent: Result:=ConstResNamePms_Price_SaleAgent;
   tpSaleInspector: Result:=ConstResNamePms_Price_SaleInspector;
   tpLeaseClient: Result:=ConstResNamePms_Price_LeaseClient;
   tpLeaseAgent: Result:=ConstResNamePms_Price_LeaseAgent;
   tpLeaseAgent2: Result:=ConstResNamePms_Price_LeaseAgent2;
   tpLeaseInspector1: Result:=ConstResNamePms_Price_LeaseInspector1;
   tpLeaseInspector2: Result:=ConstResNamePms_Price_LeaseInspector2;
   tpShareClient: Result:=ConstResNamePms_Price_ShareClient;
   tpShareAgent: Result:=ConstResNamePms_Price_ShareAgent;
   tpShareInspector: Result:=ConstResNamePms_Price_ShareInspector;
   tpShareAgent2: Result:=ConstResNamePms_Price_ShareAgent2;
   tpShareInspector2: Result:=ConstResNamePms_Price_ShareInspector2;
   tpShareClient2: Result:=ConstResNamePms_Price_ShareClient2;
   tpShareClient3: Result:=ConstResNamePms_Price_ShareClient3;
 end;
end;

procedure TfmRptPms_Price.FillColumns(Default: Boolean=false);

  procedure FillSaleColumns;
  var
    Index: Integer;
  begin
    Index:=GetTypePriceIndex;
    case Index of
      0: begin // Клиентский
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
      1:begin // Агентский
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
      2:begin // Инспекторский
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
    end;
  end;

  procedure FillLeaseColumns;
  var
    Index: Integer;
  begin
    Index:=GetTypePriceIndex;
    case Index of
      0: begin // Клиентский
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFurnitureName),TObject(Pointer(cnppFurnitureName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloorCountFloorTypeHouseName),TObject(Pointer(cnppFloorCountFloorTypeHouseName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralDwellingKitchenArea),TObject(Pointer(cnppGeneralDwellingKitchenArea)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDoorName),TObject(Pointer(cnppDoorName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPaymentTerm),TObject(Pointer(cnppPaymentTerm)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
      end;
      1,4: begin //Агентский, Агентский 2
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFurnitureName),TObject(Pointer(cnppFurnitureName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloorCountFloorTypeHouseName),TObject(Pointer(cnppFloorCountFloorTypeHouseName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralDwellingKitchenArea),TObject(Pointer(cnppGeneralDwellingKitchenArea)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDoorName),TObject(Pointer(cnppDoorName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPaymentTerm),TObject(Pointer(cnppPaymentTerm)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
      end;
      2: begin // Инспекторский №1
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFurnitureName),TObject(Pointer(cnppFurnitureName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloorCountFloorTypeHouseName),TObject(Pointer(cnppFloorCountFloorTypeHouseName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralDwellingKitchenArea),TObject(Pointer(cnppGeneralDwellingKitchenArea)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDoorName),TObject(Pointer(cnppDoorName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPaymentTerm),TObject(Pointer(cnppPaymentTerm)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
      end;
      3: begin // Инспекторский №2
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFurnitureName),TObject(Pointer(cnppFurnitureName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloorCountFloorTypeHouseName),TObject(Pointer(cnppFloorCountFloorTypeHouseName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralDwellingKitchenArea),TObject(Pointer(cnppGeneralDwellingKitchenArea)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDoorName),TObject(Pointer(cnppDoorName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPaymentTerm),TObject(Pointer(cnppPaymentTerm)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
         lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
      end;
    end;
  end;

  procedure FillShareColumns;
  var
    Index: Integer;
  begin
    Index:=GetTypePriceIndex;
    case Index of
      0: begin // Клиентский
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
      1:begin // Агентский
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
      2:begin // Инспекторский
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
      3:begin // Агентский №2
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContact),TObject(Pointer(cnppContact)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppClientInfo),TObject(Pointer(cnppClientInfo)));
      end;
      4:begin // Инспекторский №2
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppApartmentNumber),TObject(Pointer(cnppApartmentNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContactClientInfo),TObject(Pointer(cnppContactClientInfo)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppContact),TObject(Pointer(cnppContact)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppClientInfo),TObject(Pointer(cnppClientInfo)));
      end;
      5: begin // Клиентский 2
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
      6: begin // Клиентский 3
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateArrivals),TObject(Pointer(cnppDateArrivals)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountRoomName),TObject(Pointer(cnppCountRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeRoomName),TObject(Pointer(cnppTypeRoomName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPlanningName),TObject(Pointer(cnppPlanningName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppRegionName),TObject(Pointer(cnppRegionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStreetName),TObject(Pointer(cnppStreetName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHouseNumber),TObject(Pointer(cnppHouseNumber)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPhoneName),TObject(Pointer(cnppPhoneName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSaleStatusName),TObject(Pointer(cnppSaleStatusName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppNote),TObject(Pointer(cnppNote)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppFloor),TObject(Pointer(cnppFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppCountFloor),TObject(Pointer(cnppCountFloor)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppTypeHouseName),TObject(Pointer(cnppTypeHouseName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGeneralArea),TObject(Pointer(cnppGeneralArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDwellingArea),TObject(Pointer(cnppDwellingArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppKitchenArea),TObject(Pointer(cnppKitchenArea)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSanitaryNodeName),TObject(Pointer(cnppSanitaryNodeName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppConditionName),TObject(Pointer(cnppConditionName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBalconyName),TObject(Pointer(cnppBalconyName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStoveName),TObject(Pointer(cnppStoveName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppSelfFormName),TObject(Pointer(cnppSelfFormName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPriceUnitPrice),TObject(Pointer(cnppPriceUnitPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppAgentName),TObject(Pointer(cnppAgentName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppStationName),TObject(Pointer(cnppStationName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDateTimeUpdate),TObject(Pointer(cnppDateTimeUpdate)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppWaterName),TObject(Pointer(cnppWaterName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppHeatName),TObject(Pointer(cnppHeatName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDelivery),TObject(Pointer(cnppDelivery)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBuilderName),TObject(Pointer(cnppBuilderName)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice2),TObject(Pointer(cnppPrice2)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppPrice),TObject(Pointer(cnppPrice)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppDecoration),TObject(Pointer(cnppDecoration)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppGlassy),TObject(Pointer(cnppGlassy)));
        lbxColumns.Items.AddObject(GetColumnPremisesName(cnppBlockSection),TObject(Pointer(cnppBlockSection)));
      end;
    end;
  end;

  function GetTypePrice: TTypePrice;
  var
    Index: Integer;
  begin
    Result:=tpSaleClient;
    if rbSale.Checked then begin
      Index:=GetTypePriceIndex;
      case Index of
        0: Result:=tpSaleClient;
        1: Result:=tpSaleAgent;
        2: Result:=tpSaleInspector;
      end;
    end;
    if rbLease.Checked then begin
      Index:=GetTypePriceIndex;
      case Index of
        0: Result:=tpLeaseClient;
        1: Result:=tpLeaseAgent;
        2: Result:=tpLeaseInspector1;
        3: Result:=tpLeaseInspector2;
        4: Result:=tpLeaseAgent2;
      end;  
    end;
    if rbShare.Checked then begin
      Index:=GetTypePriceIndex;
      case Index of
        0: Result:=tpShareClient;
        1: Result:=tpShareAgent;
        2: Result:=tpShareInspector;
        3: Result:=tpShareAgent2;
        4: Result:=tpShareInspector2;
        5: Result:=tpShareClient2;
        6: Result:=tpShareClient3;
      end;
    end;
  end;

  procedure LoadFromResource;
  var
    rs: TResourceStream;
    TypePrice: TTypePrice;
    TCLI: TCreateLogItem;
  begin
    rs:=nil;
    try
      TypePrice:=GetTypePrice;
      try
        rs:=TResourceStream.Create(HINSTANCE,GetResFileName(TypePrice),ConstResTypeColumn);
        rs.Position:=0;
        LoadColumnsFrom('',rs,false);
      except
        on E: Exception do begin
          FillChar(TCLI,Sizeof(TCLI),0);
          TCLI.Text:=PChar(E.Message);
          TCLI.TypeLogItem:=tliError;
          _CreateLogItem(@TCLI);
        end;
      end;
    finally
      rs.Free;
    end;
  end;

begin
  lbxColumns.Items.BeginUpdate;
  try
    lbxColumns.Items.Clear;
    if rbSale.Checked then FillSaleColumns;
    if rbLease.Checked then FillLeaseColumns;
    if rbShare.Checked then FillShareColumns;
    UnCheckAll(lbxColumns,false);
    LoadFromResource;
    if not Default then
      LoadColumns;
  finally
    lbxColumns.Items.EndUpdate;
  end;
end;

procedure TfmRptPms_Price.lbxColumnsClickCheck(Sender: TObject);
begin
  SaveColumns;
end;

function TfmRptPms_Price.isCheckedColumn(Index: Integer): Boolean;
var
  i: Integer;
  ind: Integer;
begin
  Result:=false;
  for i:=0 to lbxColumns.Items.Count-1 do begin
    ind:=Integer(Pointer(lbxColumns.Items.Objects[i]));
    if ind=Index then begin
      Result:=lbxColumns.Checked[i];
      exit;
    end;
  end;
end;

function TfmRptPms_Price.GetColumnPosition(Index: Integer): Integer;
var
  i,ind: Integer;
  incr: Integer;
begin
  Result:=-1;
  incr:=0;
  for i:=0 to lbxColumns.Items.Count-1 do begin
    ind:=Integer(Pointer(lbxColumns.Items.Objects[i]));
    if ind=Index then begin
      Result:=incr;
      exit;
    end;
    if lbxColumns.Checked[i] then
      inc(incr);
  end;
end;

function TfmRptPms_Price.GetColumnCount: Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to lbxColumns.Items.Count-1 do begin
    if lbxColumns.Checked[i] then begin
      Inc(Result);
    end;
  end;
end;

function TfmRptPms_Price.GetColumnsName: string;
begin
  Result:='';
  if rbSale.Checked then Result:='lbxSaleColumns';
  if rbLease.Checked then Result:='lbxLeaseColumns';
  if rbShare.Checked then Result:='lbxShareColumns';
end;

procedure TfmRptPms_Price.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  _SaveParams;
  inherited;
end;

procedure TfmRptPms_Price.FillOffice;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkSync_Office,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    chbOffice.Items.BeginUpdate;
    try
      chbOffice.Items.Clear;
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'sync_office_id');
        chbOffice.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      chbOffice.Items.EndUpdate;
    end;
  end;
end;

procedure TfmRptPms_Price.SaveOffice;
var
  i: Integer;
  S: string;
begin
  for i:=0 to chbOffice.Items.Count-1 do begin
    S:=chbOffice.Name+IntToStr(Integer(chbOffice.Items.Objects[i]));
    WriteParam(ClassName,S,chbOffice.Checked[i]);
  end;
end;

procedure TfmRptPms_Price.LoadOffice;
var
  i: Integer;
  S: string;
begin
  for i:=0 to chbOffice.Items.Count-1 do begin
    S:=chbOffice.Name+IntToStr(Integer(chbOffice.Items.Objects[i]));
    chbOffice.Checked[i]:=ReadParam(ClassName,S,chbOffice.Checked[i]);
  end;
end;

function TfmRptPms_Price.GetOfficeFilter: string;

  function GetCheckCount: Integer;
  var
    i: Integer;
  begin
    Result:=0;
    for i:=0 to chbOffice.Items.Count-1 do
      if chbOffice.Checked[i] then
        Inc(Result);
  end;

var
  i: Integer;
  CheckCount: Integer;
  Flag: Boolean;                    
begin
  Result:='';
  CheckCount:=GetCheckCount;
  Flag:=true;
  for i:=0 to chbOffice.Items.Count-1 do begin
    if chbOffice.Checked[i] and Flag then begin
      Flag:=false;
      if CheckCount<=1 then
        Result:=' and sync_office_id='+IntToStr(Integer(chbOffice.Items.Objects[i]))+' '
      else
        Result:=' and (sync_office_id='+IntToStr(Integer(chbOffice.Items.Objects[i]))+'';
    end else
      if chbOffice.Checked[i] then
        Result:=Result+' or sync_office_id='+IntToStr(Integer(chbOffice.Items.Objects[i]))+'';
  end;
  if CheckCount>1 then
    Result:=Result+') ';
end;

procedure TfmRptPms_Price.btColumnsDefaultClick(Sender: TObject);
begin
  FillColumns(true);
  SaveColumns;
end;

procedure TfmRptPms_Price.miColumnsDefaultClick(Sender: TObject);
begin
  FillColumns(true);
  SaveColumns;
end;

procedure TfmRptPms_Price.miColumnsSaveClick(Sender: TObject);
var
  Dialog: TSaveDialog;
begin
  Dialog:=TSaveDialog.Create(nil);
  try
    Dialog.Filter:='Файлы колонок (*.clm)|*.clm|Все файлы (*.*)|*.*';
    Dialog.DefaultExt:='.clm';
    if Dialog.Execute then begin
      SaveColumnsTo(Dialog.FileName,nil,true);
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TfmRptPms_Price.SaveColumnsTo(const FileName: String; Stream: TStream; ToFile: Boolean=true);
var
  i: Integer;
  Str: TStringList;
  S,S1: String;
begin
  Str:=TStringList.Create;
  try
    for i:=0 to lbxColumns.Items.Count-1 do begin
      if lbxColumns.Checked[i] then S1:='1'
      else S1:='0';
      S:=Format('%s=%s',[lbxColumns.Items.Strings[i],S1]);
      Str.Add(S);
    end;
    if ToFile then
      Str.SaveToFile(FileName)
    else
      Str.SaveToStream(Stream);
  finally
    Str.Free;
  end;
end;

procedure TfmRptPms_Price.miColumnsLoadClick(Sender: TObject);
var
  Dialog: TOpenDialog;
begin
  Dialog:=TOpenDialog.Create(nil);
  try
    Dialog.Filter:='Файлы колонок (*.clm)|*.clm|Все файлы (*.*)|*.*';
    if Dialog.Execute then begin
      LoadColumnsFrom(Dialog.FileName,nil,true);
    end;
  finally
    Dialog.Free;
  end;
end;

procedure TfmRptPms_Price.LoadColumnsFrom(const FileName: String; Stream: TStream; FromFile: Boolean=true);
var
  i: Integer;
  Str: TStringList;
  Index: Integer;
  AEnabled: Boolean;
begin
  Str:=TStringList.Create;
  try
    if FromFile then
      Str.LoadFromFile(FileName)
    else
      Str.LoadFromStream(Stream);

    for i:=0 to Str.Count-1 do begin
      Index:=lbxColumns.Items.IndexOf(Str.Names[i]);
      AEnabled:=Boolean(StrToInt(Str.Values[Str.Names[i]]));
      if Index<>-1 then begin
        lbxColumns.Items.Move(Index,i);
        lbxColumns.Checked[i]:=AEnabled;
      end;
    end;
  finally
    Str.Free;
  end;
end;

procedure TfmRptPms_Price.SaveColumns;
var
  Stream: TMemoryStream;
  S: String;
  Section: String;
begin
  Stream:=TMemoryStream.Create;
  try
    SaveColumnsTo('',Stream,false);
    Stream.Position:=0;
    S:='';
    SetLength(S,Stream.Size);
    FillChar(Pointer(S)^,Stream.Size,0);
    Stream.Read(Pointer(S)^,Stream.Size);
    S:=StrToHexStr(S);
    Section:=GetColumnsName+inttostr(GetTypePriceIndex);
    WriteParam(ClassName,Section,S);
  finally
    Stream.Free;
  end;
end;

procedure TfmRptPms_Price.LoadColumns;
var
  Stream: TMemoryStream;
  S: String;
  Section: String;
begin
  Stream:=TMemoryStream.Create;
  try
    S:='';
    Section:=GetColumnsName+inttostr(GetTypePriceIndex);
    S:=ReadParam(ClassName,Section,S);
    S:=HexStrToStr(S);
    Stream.SetSize(Length(S));
    Stream.Write(Pointer(S)^,Length(S));
    Stream.Position:=0;
    LoadColumnsFrom('',Stream,false);
  finally
    Stream.Free;
  end;
end;

{procedure TfmRptPms_Price.SaveColumns;
var
  s: string;
  i: Integer;
  Flag: Boolean;
begin
  Flag:=true;
  for i:=0 to lbxColumns.Items.Count-1 do begin
    if Flag then begin
      s:=Inttostr(Integer(lbxColumns.Items.Objects[i]));
      Flag:=false;
    end else s:=s+ConstDelimColumn+Inttostr(Integer(lbxColumns.Items.Objects[i]));
  end;
  WriteParam(ClassName,GetColumnsName+'Order'+inttostr(GetTypePriceIndex),s);
  Flag:=true;
  for i:=0 to lbxColumns.Items.Count-1 do begin
    if lbxColumns.Checked[i] then begin
      if Flag then s:=Inttostr(Integer(lbxColumns.Items.Objects[i]))
      else s:=s+ConstDelimColumn+Inttostr(Integer(lbxColumns.Items.Objects[i]));
      Flag:=false;
    end;
  end;
  WriteParam(ClassName,GetColumnsName+'Checked'+inttostr(GetTypePriceIndex),s);
end;}

{procedure TfmRptPms_Price.LoadColumns;
var
  sOrder,sChecked: string;
  APos,ind: Integer;
  val: string;
begin
  sOrder:=ReadParam(ClassName,GetColumnsName+'Order'+inttostr(GetTypePriceIndex),sOrder);
  if Trim(sOrder)='' then exit;
  lbxColumns.Items.Clear;
  APos:=-1;
  while Apos<>0 do begin
    Apos:=AnsiPos(ConstDelimColumn,sOrder);
    if APos>0 then begin
       val:=Copy(sOrder,1,Apos-1);
       sOrder:=Copy(sOrder,Apos+Length(ConstDelimColumn),Length(sOrder));
       lbxColumns.Items.AddObject(GetColumnPremisesName(StrToInt(val)),TObject(Pointer(StrToInt(val))));
    end else begin
       lbxColumns.Items.AddObject(GetColumnPremisesName(StrToInt(sOrder)),TObject(Pointer(StrToInt(sOrder))));
    end;
  end;
  sChecked:=ReadParam(ClassName,GetColumnsName+'Checked'+inttostr(GetTypePriceIndex),sOrder);
  if Trim(sChecked)<>'' then UnCheckAll(lbxColumns);
  APos:=-1;
  while Apos<>0 do begin
    Apos:=AnsiPos(ConstDelimColumn,sChecked);
    if APos>0 then begin
       val:=Copy(sChecked,1,Apos-1);
       sChecked:=Copy(sChecked,Apos+Length(ConstDelimColumn),Length(sChecked));
       ind:=lbxColumns.Items.IndexOfObject(TObject(StrToInt(val)));
       if ind<>-1 then
         lbxColumns.Checked[ind]:=true;
    end else begin
      ind:=lbxColumns.Items.IndexOfObject(TObject(StrToInt(sChecked)));
      if ind<>-1 then
        lbxColumns.Checked[ind]:=true;
    end;
  end;
end;}


end.
