unit USalPeriod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Grids, DBGrids, Buttons, IBCustomDataSet, IBQuery,
  IBTable, dbtree, comctrls, ImgList, Db, menus, IBDatabase, UMainUnited,
  IBEvents, IBSQLMonitor,IB, tsvDbGrid,DBClient, Provider, DBTables, IBUpdateSQL,
  URBMainGrid;

type
  TfmSalPeriod = class(TForm)
    bibClosePeriod: TButton;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    edCalcPeriod: TEdit;
    bibCurCalcPeriod: TBitBtn;
    bOpenPeriod: TButton;
    lbStatusCurCalcPeriod: TLabel;
    Mainqr: TIBQuery;
    IBTran: TIBTransaction;
    bReversePeriod: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibCurCalcPeriodClick(Sender: TObject);
    procedure bibClosePeriodClick(Sender: TObject);
    procedure bOpenPeriodClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bReversePeriodClick(Sender: TObject);

  private
//    FTypeEntry: TTypeEntry;
//    NewLeft,NewTop,NewWidth,NewHeight: Integer;
    NewWindowState: TWindowState;
    FhInterface: THandle;
    NewLeft,NewTop,NewWidth,NewHeight: Integer;

//    procedure SetTypeEntry(Value: TTypeEntry);

//    function GetFilterString: string;
  protected
    procedure LoadFromIni; dynamic;
    procedure SaveToIni;dynamic;


  public
    ViewSelect: Boolean;
    CurCalcPeriod_id: Integer;
    calcperiod_id: Integer;
    changeFlag :Boolean;
    StatuscurPeriod:Integer;
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface); dynamic;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface); dynamic;
    procedure ReturnModalParams(Param: PParamRBookInterface);dynamic;

    procedure SetInterfaceHandle(Value: THandle);

//    constructor Create(AOwner: TComponent);override;
//    destructor Destroy; override;
  end;



var
  fmSalPeriod: TfmSalPeriod;

implementation

uses comobj,ActiveX,
     USalaryVAVData, USalaryVAVCode,UTreeBuilding, StSalaryKit;

//type
//  TRptExcelThreadTest=class(TRptExcelThread)

//    PBHandle: LongWord;
//  public
//    fmParent: TfmSalPeriod;
//    procedure Execute;override;
//    destructor Destroy;override;
//  end;

//var
//  Rpt: TRptExcelThreadTest;

{$R *.DFM}

procedure TfmSalPeriod.FormCreate(Sender: TObject);
var
  curdate: TDate;
begin
  LoadFromIni;
 try
  ViewSelect:=not _GetOptions.isEditRBOnSelect;
//  FTypeEntry:=tte_None;
  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;
  NewLeft:=Left;
  NewTop:=Top;
  NewWidth:=Width;
  NewHeight:=Height;
  NewWindowState:=WindowState;

  WindowState:=wsMinimized;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

 try
  Caption:=NameSal;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  IBTran.Params.Clear;
  IBTran.Params.Add('read_committed');
  IBTran.Params.Add('rec_version');
  IBTran.Params.Add('nowait');

  
  curdate:=_GetDateTimeFromServer;
  
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
  CurCalcPeriod_id:=GetIDCurCalcPeriod({mainqr});
  bibCurCalcPeriod.Click;



  case GetStatusCurCalcPeriod of
  1: begin
        lbStatusCurCalcPeriod.Caption:='Подготовлен к открытию';
        bOpenPeriod.Enabled:=true;
        bibClosePeriod.Enabled:=false;
     end;
  2: begin
        lbStatusCurCalcPeriod.Caption:='Период открыт';
        bOpenPeriod.Enabled:=false;
        bibClosePeriod.Enabled:=true;
     end;
 end;
end;
procedure TfmSalPeriod.FormDestroy(Sender: TObject);
begin
//  _RemoveFromLastOpenEntryes(FTypeEntry);
  SaveToIni;
  if fsCreatedMDIChild in FormState then
   fmSalPeriod:=nil;
end;

procedure TfmSalPeriod.bibCurCalcPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
   FillChar(TPRBI,SizeOf(TPRBI),0);
   TPRBI.Visual.TypeView:=tviOnlyData;
   TPRBI.Locate.KeyFields:='calcperiod_id';
   TPRBI.Locate.KeyValues:=calcperiod_id;
   TPRBI.Locate.Options:=[loCaseInsensitive];
   if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
      ChangeFlag:=true;
      calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
      edCalcPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
      StatuscurPeriod:=GetFirstValueFromParamRBookInterface(@TPRBI,'status');
   end;
end;

procedure TfmSalPeriod.bibClosePeriodClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  IdCur:Integer;
  IdNext:Integer;
    TrRead,TrWrite:TIBTransaction;
begin

    case GetStatusCurCalcPeriod() of
    0: ShowMessage ('Нельзя закрыть неоткрытый период');
    1: begin
           IdCur:= GetIDCurCalcPeriod ();
            sqls:='Update '+tbcalcperiod+
                  ' set status=2'+
                  ' where calcperiod_id='+IntToStr(IdCur);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.ExecSQL;

            qr.Transaction.Commit;
        end;
    2:
       begin


// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

  qr.Database:=IBDB;
  TrWrite:=TIBTransaction.Create(nil);
  qr.Transaction:=TrWrite;
  TrWrite.DefaultDatabase:=IBDB;
  TrWrite.Params.Add('read_committed');
  TrWrite.Params.Add('rec_version');
  TrWrite.Params.Add('nowait');
  TrWrite.DefaultAction:=TARollback;
  qr.Transaction.Active:=true;

  IdCur:= GetIDCurCalcPeriod ;
  IdNext:= GetIDNextCalcPeriod;

    sqls:='Update '+tbcalcperiod+
          ' set status=3'+
          ' where calcperiod_id='+IntToStr(IdCur);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    sqls:='Update '+tbcalcperiod+
          ' set status=1'+
          ' where calcperiod_id='+IntToStr(IdNext);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
  end;
//    end;
    3: ShowMessage ('Невозможно закрыть уже закрытый период');
end;
 bibCurCalcPeriod.Click;
 bibClosePeriod.Enabled:=false;
end;


procedure TfmSalPeriod.bOpenPeriodClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
  IdCur:Integer;
  TrRead,TrWrite:TIBTransaction;

begin
// Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
  qr.Database:=IBDB;
  TrWrite:=TIBTransaction.Create(nil);
  qr.Transaction:=TrWrite;
  TrWrite.DefaultDatabase:=IBDB;
  TrWrite.Params.Add('read_committed');
  TrWrite.Params.Add('rec_version');
  TrWrite.Params.Add('nowait');
  TrWrite.DefaultAction:=TARollback;
  qr.Transaction.Active:=true;

    case GetStatusCurCalcPeriod() of
    0: ShowMessage ('Необходимо закрыть текущий период');
    1: begin
           IdCur:= GetIDCurCalcPeriod ();
            sqls:='Update '+tbcalcperiod+
                  ' set status=2'+
                  ' where calcperiod_id='+IntToStr(IdCur);
            qr.SQL.Clear;
            qr.SQL.Add(sqls);
            qr.ExecSQL;

            qr.Transaction.Commit;
        end;
    2: ShowMessage ('Период уже открыт');
    3: ShowMessage ('Невозможно открыть уже закрытый период');
    end;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
    bibClosePeriod.Enabled:=true;
    lbStatusCurCalcPeriod.Caption:='Период открыт';
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
 bibCurCalcPeriod.Click;
end;

{procedure TfmSalPeriod.InitParams(TypeEntry: TTypeEntry);
begin
   _AddToLastOpenEntryes(TypeEntry);
   FTypeEntry:=TypeEntry;
   ViewSelect:=false;
//   ActiveQuery(true);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then
    WindowState:=wsNormal;
   BringToFront;
   Show;
end;}
{procedure TfmSalPeriod.SetTypeEntry(Value: TTypeEntry);
begin
  if Value<>FTypeEntry then begin
    FTypeEntry:=Value;
  end;
end;}


procedure TfmSalPeriod.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
  Application.Hint:='';

end;
procedure TfmSalPeriod.LoadFromIni;

  procedure LoadFormProp;
  begin
    NewWindowState:=TWindowState(ReadParam(ClassName,'WindowState',Integer(WindowState)));
    if NewWindowState<>wsMaximized then begin
     NewLeft:=ReadParam(ClassName,'Left',Left);
     NewTop:=ReadParam(ClassName,'Top',Top);
     NewWidth:=ReadParam(ClassName,'Width',Width);
     NewHeight:=ReadParam(ClassName,'Height',Height);
    end;
  end;

begin
      LoadFormProp;
end;

procedure TfmSalPeriod.SaveToIni;

  procedure SaveFormProp;
  begin
    if FormState=[fsCreatedMDIChild] then begin
     WriteParam(ClassName,'Left',Left);
     WriteParam(ClassName,'Top',Top);
     WriteParam(ClassName,'Width',Width);
     WriteParam(ClassName,'Height',Height);
     WriteParam(ClassName,'WindowState',Integer(WindowState));
    end;
  end;

begin
      SaveFormProp;
end;

procedure TfmSalPeriod.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   with Param.Locate do begin
    if KeyFields<>nil then
      MainQr.Locate(KeyFields,KeyValues,Options);
   end;
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
   end; 
   BringToFront;
   Show;
end;

procedure TfmSalPeriod.SetInterfaceHandle(Value: THandle);
begin
  FhInterface:=Value;
end;

procedure TfmSalPeriod.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  FhInterface:=hInterface;
//  bibClose.Cancel:=true;
//  bibOk.OnClick:=MR;
//  bibClose.Caption:=CaptionCancel;
//  bibOk.Visible:=true;
//  Grid.OnDblClick:=MR;
//  Grid.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
//  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
//  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  with Param.Locate do begin
    if KeyFields<>nil then
      MainQr.Locate(KeyFields,KeyValues,Options);
  end;
end;
procedure TfmSalPeriod.ReturnModalParams(Param: PParamRBookInterface);
begin
//  ReturnModalParamsFromDataSetAndGrid(MainQr,Grid,Param);
end;


{
procedure TfmSalPeriod.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  CurInterface:=hInterface;
  SetInterfaceHandle(hInterfaceRbkEmp);
  VisibleAllTabSheets(false);
  tbsEmpConnect.TabVisible:=true;
  pgLink.ActivePage:=tbsEmpConnect;
  miAdjustTabs.Enabled:=false;
  _OnVisibleInterface(hInterface,true);
  ViewSelect:=false;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  ActiveQuery(true);
  with Param.Locate do begin
    if KeyFields<>nil then
      MainQr.Locate(KeyFields,KeyValues,Options);
  end;
  FormStyle:=fsMDIChild;
  if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
  end;
  BringToFront;
  Show;
  SetPositionEdSearch;
end;

procedure TfmSalPeriod.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  CurInterface:=hInterface;
  SetInterfaceHandle(hInterfaceRbkEmp);
  VisibleAllTabSheets(false);
  tbsEmpConnect.TabVisible:=true;
  pgLink.ActivePage:=tbsEmpConnect;
  miAdjustTabs.Enabled:=false;
  pnButEmpConnect.Visible:=_GetOptions.isEditRBOnSelect;
  bibClose.Cancel:=true;
  bibOk.OnClick:=MR;
  bibClose.Caption:=CaptionCancel;
  bibOk.Visible:=true;
  GridEmpConnect.OnDblClick:=MR;
  GridEmpConnect.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  ActiveQuery(true);
  with Param.Locate do begin
    if KeyFields<>nil then
      MainQr.Locate(KeyFields,KeyValues,Options);
  end;
  SetPositionEdSearch;
end;

procedure TfmSalPeriod.ReturnModalParams(Param: PParamRBookInterface);
begin
  ReturnModalParamsFromDataSetAndGrid(qrEmpConnect,GridEmpConnect,Param);
end;

function TfmSalPeriod.CheckPermission: Boolean;
begin
  Result:=inherited CheckPermission;
end;

    }
procedure TfmSalPeriod.bReversePeriodClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  IdCur:Integer;
  IdNext:Integer;
  IdPrev:Integer;
    TrRead,TrWrite:TIBTransaction;
begin
 try
  qr:=TIBQuery.Create(nil);
  try

  qr.Database:=IBDB;
  TrWrite:=TIBTransaction.Create(nil);
  qr.Transaction:=TrWrite;
  TrWrite.DefaultDatabase:=IBDB;
  TrWrite.Params.Add('read_committed');
  TrWrite.Params.Add('rec_version');
  TrWrite.Params.Add('nowait');
  TrWrite.DefaultAction:=TARollback;
  qr.Transaction.Active:=true;

  IdCur:= GetIDCurCalcPeriod ;
  IdPrev:= GetIDPrevCalcPeriod;

//Необходимо удалить все данные за текущий рассчетный период

    sqls:='Delete '+tbSalary+
          ' where calcperiod_id='+IntToStr(IdCur);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    sqls:='Update '+tbcalcperiod+
          ' set status=0'+
          ' where calcperiod_id='+IntToStr(IdCur);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    sqls:='Update '+tbcalcperiod+
          ' set status=1'+
          ' where calcperiod_id='+IntToStr(IdPrev);
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    ShowMessage('Проверь!!!! Все ли данные удалил?');
    qr.Transaction.Commit;
  finally
    qr.Free;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

 bibCurCalcPeriod.Click;
 bibClosePeriod.Enabled:=false;
end;

end.
