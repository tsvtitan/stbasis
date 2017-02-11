unit URBTypeNumerator;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL,
  ImgList, dbtree, UMainUnited, ComCtrls, grids, tsvTVNavigator;

type
   TfmRBTypeNumerator = class(TfmRBMainGrid)
    pnDetail: TPanel;
    pnGroup: TPanel;
    splDetail: TSplitter;
    IL: TImageList;
    dsDetail: TDataSource;
    qrDetail: TIBQuery;
    tranDetail: TIBTransaction;
    updDetail: TIBUpdateSQL;
    tcDetail: TTabControl;
    pntsDetail: TPanel;
    RGView: TRadioGroup;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure qrGroupAfterScroll(DataSet: TDataSet);
    procedure bibAdjustDetailClick(Sender: TObject);
    procedure tcDetailChange(Sender: TObject);
    procedure RGViewClick(Sender: TObject);
    procedure bibAdjustClick(Sender: TObject);
  private
    TVNavigator: TTVNavigator;
    
    LastPageIndex: Integer;
    LastOrderDetail: string;
    GridDetail: TNewdbGrid;
    isFindNAmeTypeNumerator,isFindAboutType: Boolean;
    FindNAmeTypeNumerator,FindAboutType: string;

    isFindNameNumerator,isFindAbout,IsFindStartDate,IsFindEndDate: Boolean;
    FindNameNumerator,FindAbout: string;
    FindStartDate,FindEndDate: TDateTime;    


    FindViewOfGoods,FindTypeOfGoods: Integer;
    LastGroupId: String;
    oldHeight,oldWidth:Integer;
    LastActiveControlName:AnsiString;
    


    procedure TypeNumeratorsOnEnterOnEnter(Sender: TObject);
    procedure GridDetailOnDblClick(Sender: TObject);


//Типы нумераторов
    procedure bibAddTypeNumeratorOnClick(Sender: TObject);
    procedure bibChangeTypeNumeratorOnClick(Sender: TObject);
    procedure bibDelTypeNumeratorOnClick(Sender: TObject);

//Нумераторы
    procedure bibAddDetailNumeratorsOnClick(Sender: TObject);
    procedure bibChangeDetailNumeratorsOnClick(Sender: TObject);
    procedure bibDelDetailNumeratorsOnClick(Sender: TObject);
    procedure GridDetailNumeratorsOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);

//Связь с документами
    procedure bibAddDetailLinkTypeDocNumeratorOnClick(Sender: TObject);
    procedure bibChangeDetailLinkTypeDocNumeratorOnClick(Sender: TObject);
    procedure bibDelDetailLinkTypeDocNumeratorOnClick(Sender: TObject);
    procedure GridDetailLinkTypeDocNumeratorOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);

    procedure GridEnter(Sender: TObject);
    procedure GridOnExit(Sender: TObject);
    procedure GridDetailOnExit(Sender: TObject);


  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    procedure ShowingChanged; override;
  public
    procedure ActiveQueryDetail(CheckPerm: Boolean);
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface); override;
  end;

var
  fmRBTypeNumerator: TfmRBTypeNumerator;

implementation

uses USysVAVCode, USysVAVDM, USysVAVData,
     typInfo, UAdjust, UEditRBLinkTypeDocNumerator,
  UEditRBNumerators, UEditRBTypeNumerator,STVAVKit;

{$R *.DFM}

function GetGridName(Index: Integer): String;
begin
  Result:='';
  if Index=0 then Result:='GridDetailNumerators';
  if Index=1 then Result:='GridDetailLinkTypeDocNumerator';
end;


procedure TfmRBTypeNumerator.FormCreate(Sender: TObject);
var
  ifl: TIntegerField;
  sfl: TStringField;
  bfl: TIBBCDField;
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkTypeNumerator;

  LastPageIndex:=-1;
  FindViewOfGoods:=-1;
  FindTypeOfGoods:=-1;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  FillGridColumnsFromTb(IBDB,tbTypeNumerator,Grid);
  Grid.DataSource:=ds;
  pnGroup.Height:=200;

  qrDetail.Database:=IBDB;
  tranDetail.AddDatabase(IBDB);
  IBDB.AddTransaction(tranDetail);
  Grid.OnEnter:=GridEnter;
  Grid.OnExit:=GridOnExit;


  GridDetail:=TNewdbGrid.Create(self);
  GridDetail.Parent:=pntsDetail;
  GridDetail.Align:=alClient;
  GridDetail.DataSource:=dsDetail;
  GridDetail.Name:='GridDetail';
  GridDetail.RowSelected.Visible:=true;
  AssignFont(_GetOptions.RBTableFont,GridDetail.Font);
  GridDetail.TitleFont.Assign(Grid.Font);
  GridDetail.RowSelected.Font.Assign(GridDetail.Font);
  GridDetail.RowSelected.Brush.Style:=bsClear;
  GridDetail.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridDetail.RowSelected.Font.Color:=clWhite;
  GridDetail.RowSelected.Pen.Style:=psClear;
  GridDetail.CellSelected.Visible:=true;
  GridDetail.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridDetail.CellSelected.Font.Assign(GridDetail.Font);
  GridDetail.CellSelected.Font.Color:=clHighlightText;
  GridDetail.TitleCellMouseDown.Font.Assign(GridDetail.Font);
  GridDetail.Options:=Grid.Options-[dgEditing]-[dgTabs];
  GridDetail.RowSizing:=false;
  GridDetail.ReadOnly:=true;
  GridDetail.OnKeyDown:=FormKeyDown;
  GridDetail.OnDblClick:=GridDetailOnDblClick;
  GridDetail.OnEnter:=TypeNumeratorsOnEnterOnEnter;
  GridDetail.OnExit:=GridDetailOnExit;



  GridDetail.TabOrder:=1;
  LoadFromIni;
  RGViewClick(nil);  
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.FormDestroy(Sender: TObject);
begin
  inherited;
  GridDetail.Free;
  if FormState=[fsCreatedMDIChild] then
   fmRBTypeNumerator:=nil;
end;

function TfmRBTypeNumerator.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkTypeNumerator+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBTypeNumerator.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindNAmeTypeNumerator or isFindAboutType);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.ActiveQueryDetail(CheckPerm: Boolean);
var
  hInterfaceDetail: THandle;
  sqls: string;

  procedure SetParamsByActivePage;
  var
    cl: TColumn;
    isCreate: Boolean;
  begin
    isCreate:=false;
    if LastPageIndex<>-1 then begin
     if LastPageIndex<>tcDetail.TabIndex then begin
       GridDetail.Name:=GetGridName(LastPageIndex);
       SaveGridProp(ClassName,TDbGrid(GridDetail));
       GridDetail.ClearColumnSort;
       GridDetail.Columns.Clear;
       LastOrderDetail:='';
       isCreate:=true;
     end;
    end else isCreate:=true;

    LastPageIndex:=tcDetail.TabIndex;
    //Нумераторы
    if tcDetail.TabIndex=0 then begin
      hInterfaceDetail:=hInterfaceRbkNumerators;
      sqls:=SQLRbkNumerators+' where n.typenumerator_id=:Typenumerator_id '+LastOrderDetail;
      if not isCreate then exit;
//      bibAddDetail.OnClick:=bibAddDetailNumeratorsOnClick;
//      bibChangeDetail.OnClick:=bibChangeDetailNumeratorsOnClick;
//      bibDelDetail.OnClick:=bibDelDetailNumeratorsOnClick;
      GridDetail.OnTitleClickWithSort:=GridDetailNumeratorsOnTitleClickWithSort;
      GridDetail.OnDrawColumnCell:=nil;

      FillGridColumnsFromTb(IBDB,tbNumerators,GridDetail);

      GridDetail.Name:=GetGridName(tcDetail.TabIndex);

      LoadGridProp(ClassName,TDbGrid(GridDetail));
    end;
    if tcDetail.TabIndex=1 then begin
      hInterfaceDetail:=hInterfaceRbkNumerators;
      sqls:=SQLRbkLinkTypeDocNumerator+' where ltdn.typenumerator_id=:Typenumerator_id '+LastOrderDetail;
      if not isCreate then exit;
//      bibAddDetail.OnClick:=bibAddDetailLinkTypeDocNumeratorOnClick;
//      bibChangeDetail.OnClick:=bibChangeDetailLinkTypeDocNumeratorOnClick;
//      bibDelDetail.OnClick:=bibDelDetailLinkTypeDocNumeratorOnClick;
      GridDetail.OnTitleClickWithSort:=GridDetailLinkTypeDocNumeratorOnTitleClickWithSort;

      FillGridColumnsFromTb(IBDB,tbLinkTypeDocNumerator,GridDetail);
      FillGridColumnsFromTb(IBDB,tbTypeNumerator,GridDetail);
      FillGridColumnsFromTb(IBDB,tbTypeDoc,GridDetail);

      GridDetail.Name:=GetGridName(tcDetail.TabIndex);
      LoadGridProp(ClassName,TDbGrid(GridDetail));
    end;
  end;

  function CheckPermissionDetail: Boolean;
  var
    isPerm: Boolean;
  begin
    isPerm:=_isPermissionOnInterface(hInterfaceDetail,ttiaView);
//    bibChangeDetail.Enabled:=isPerm and _isPermissionOnInterface(hInterfaceDetail,ttiaChange);
//    bibAddDetail.Enabled:=isPerm and _isPermissionOnInterface(hInterfaceDetail,ttiaAdd);
//    bibDelDetail.Enabled:=isPerm and _isPermissionOnInterface(hInterfaceDetail,ttiaDelete);
//    bibAdjustDetail.Enabled:=isPerm;
    Result:=isPerm;
  end;

begin
 try
  SetParamsByActivePage;
  qrDetail.Active:=false;
  if CheckPerm then
   if not CheckPermissionDetail then exit;

  Screen.Cursor:=crHourGlass;
  qrDetail.DisableControls;
  try
   qrDetail.sql.Clear;
   qrDetail.sql.Add(sqls);
   qrDetail.Transaction.Active:=false;
   qrDetail.Transaction.Active:=true;
   qrDetail.Active:=true;
  finally
   qrDetail.EnableControls;
   Screen.Cursor:=crDefault;
  end;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('typenumerator_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('typenumerator_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBTypeNumerator.LoadFromIni;
begin
 inherited;
 try
    FindNAmeTypeNumerator:=ReadParam(ClassName,'FindNAmeTypeNumerator',FindNAmeTypeNumerator);
    FindAboutType:=ReadParam(ClassName,'FindAboutType',FindAboutType);

    FindNameNumerator:=ReadParam(ClassName,'FindNameNumerator',FindNameNumerator);
    FindAbout:=ReadParam(ClassName,'FindAbout',FindAbout);
    FindStartDate:=ReadParam(ClassName,'FindStartDate',FindStartDate);
    FindEndDate:=ReadParam(ClassName,'FindEndDate',FindEndDate);

    isFindNAmeTypeNumerator:=ReadParam(ClassName,'isFindNAmeTypeNumerator',isFindNAmeTypeNumerator);
    isFindAboutType:=ReadParam(ClassName,'isFindAboutType',isFindAboutType);

    isFindNameNumerator:=ReadParam(ClassName,'isFindNameNumerator',isFindNameNumerator);
    isFindAbout:=ReadParam(ClassName,'isFindAbout',isFindAbout);
    isFindStartDate:=ReadParam(ClassName,'isFindStartDate',isFindStartDate);
    isFindEndDate:=ReadParam(ClassName,'isFindEndDate',isFindEndDate);


    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
    pnDetail.Height:=ReadParam(ClassName,'pnDetailHeight',pnDetail.Height);
    tcDetail.TabIndex:=ReadParam(ClassName,'tcDetailTabIndex',tcDetail.TabIndex);
    oldHeight:=ReadParam(ClassName,'oldHeight',oldHeight);
    if oldHeight = 0 then oldHeight:=50;
    oldWidth:=ReadParam(ClassName,'oldWidth',oldWidth);
    if oldWidth = 0 then oldWidth:=50;
    RGView.ItemIndex:=ReadParam(ClassName,'RGViewItemIndex',RGView.ItemIndex);    
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.SaveToIni;
begin
 inherited;
 try
   GridDetail.Name:=GetGridName(LastPageIndex);
   SaveGridProp(ClassName,TDbGrid(GridDetail));
    WriteParam(ClassName,'FindNAmeTypeNumerator',FindNAmeTypeNumerator);
    WriteParam(ClassName,'FindAboutType',FindAboutType);

    WriteParam(ClassName,'FindNameNumerator',FindNameNumerator);
    WriteParam(ClassName,'FindAbout',FindAbout);
    WriteParam(ClassName,'FindStartDate',FindStartDate);
    WriteParam(ClassName,'FindEndDate',FindEndDate);

    WriteParam(ClassName,'isFindNAmeTypeNumerator',isFindNAmeTypeNumerator);
    WriteParam(ClassName,'isFindAboutType',isFindAboutType);

    WriteParam(ClassName,'isFindNameNumerator',isFindNameNumerator);
    WriteParam(ClassName,'isFindAbout',isFindAbout);
    WriteParam(ClassName,'isFindStartDate',isFindStartDate);
    WriteParam(ClassName,'isFindEndDate',isFindEndDate);

    WriteParam(ClassName,'Inside',FilterInside);
    WriteParam(ClassName,'pnDetailHeight',pnDetail.Height);
    WriteParam(ClassName,'tcDetailTabIndex',tcDetail.TabIndex);
    WriteParam(ClassName,'oldHeight',oldHeight);
    WriteParam(ClassName,'oldWidth',oldWidth);
    WriteParam(ClassName,'RGViewItemIndex',RGView.ItemIndex);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBTypeNumerator.bibAddClick(Sender: TObject);
begin
     if LastActiveControlName='Grid' then bibAddTypeNumeratorOnClick(nil);
     if LastActiveControlName='GridDetail' then
        begin
          if tcDetail.TabIndex=0 then
              begin
                bibAddDetailNumeratorsOnClick(nil);
              end;
          if tcDetail.TabIndex=1 then
              begin
                bibAddDetailLinkTypeDocNumeratorOnClick(nil);
              end;

        end;
end;

procedure TfmRBTypeNumerator.bibChangeClick(Sender: TObject);
begin
     if LastActiveControlName='Grid' then bibChangeTypeNumeratorOnClick(nil);
     if LastActiveControlName='GridDetail' then
        begin
          if tcDetail.TabIndex=0 then
              begin
                bibChangeDetailNumeratorsOnClick(nil);
              end;
          if tcDetail.TabIndex=1 then
              begin
                bibChangeDetailLinkTypeDocNumeratorOnClick(nil);
              end;

        end;
end;

procedure TfmRBTypeNumerator.bibDelClick(Sender: TObject);
begin
     if LastActiveControlName='Grid' then bibDelTypeNumeratorOnClick(nil);
     if LastActiveControlName='GridDetail' then
        begin
          if tcDetail.TabIndex=0 then
              begin
                bibDelDetailNumeratorsOnClick(nil);
              end;
          if tcDetail.TabIndex=1 then
              begin
                bibDelDetailLinkTypeDocNumeratorOnClick(nil);
              end;

        end;
end;

procedure TfmRBTypeNumerator.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBTypeNumerator;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTypeNumerator.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.oldTypeNumerator_id:=Mainqr.FieldByName('TypeNumerator_id').AsInteger;
    fm.edNameTypeNumerator.Text:=Mainqr.FieldByName('NameTypeNumerator').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('ABOUT').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeNumerator.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBTypeNumerator;
begin
 fm:=TfmEditRBTypeNumerator.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindNAmeTypeNumerator)<>'' then fm.edNameTypeNumerator.Text:=FindNAmeTypeNumerator;
  if Trim(FindAboutType)<>'' then fm.meAbout.Text:=FindAboutType;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNAmeTypeNumerator:=Trim(fm.edNameTypeNumerator.Text);
    FindAboutType:=Trim(fm.meAbout.Text);

    FilterInSide:=fm.cbInString.Checked;

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBTypeNumerator.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindNAmeTypeNumerator:=Trim(FindNAmeTypeNumerator)<>'';
    isFindAboutType:=Trim(FindAboutType)<>'';

    if isFindNAmeTypeNumerator or isFindAboutType then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNAmeTypeNumerator then begin
        addstr1:=' Upper(tn.NameTypeNumerator) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNAmeTypeNumerator+'%'))+' ';
     end;

     if isFindAboutType then begin
        addstr2:=' Upper(tn.about) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAboutType+'%'))+' ';
     end;

     if (isFindNAmeTypeNumerator and isFindAboutType) then
      and1:=' and ';


     Result:=wherestr+addstr1+and1+addstr2;
end;

procedure TfmRBTypeNumerator.ShowingChanged;
begin
  inherited;
end;

procedure TfmRBTypeNumerator.qrGroupAfterScroll(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmRBTypeNumerator.GridDetailOnDblClick(Sender: TObject);
begin
  if not qrDetail.Active then exit;
  if qrDetail.RecordCount=0 then exit;
  bibAdd.Click;
  //  bibChangeDetail.Click;
end;

procedure TfmRBTypeNumerator.bibAdjustDetailClick(Sender: TObject);
begin
  SetAdjustColumns(GridDetail.Columns);
end;

procedure TfmRBTypeNumerator.bibAddDetailLinkTypeDocNumeratorOnClick(Sender: TObject);
var
  fm: TfmEditRBLinkTypeDocNumerator;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBLinkTypeDocNumerator.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.ActiveControl:=fm.bibTypeDoc;
    fm.TypeNumerator_id:=MainQr.FieldByName('TypeNumerator_id').AsInteger;
    fm.OldTypeNumerator_id:=fm.TypeNumerator_id;
    fm.edTypeNumerator.Text:=MainQr.FieldByName('NameTypeNumerator').AsString;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('TypeNumerator_id;TypeDoc_id',
                      VarArrayOf([fm.TypeNumerator_id,fm.TypeDoc_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeNumerator.bibChangeDetailLinkTypeDocNumeratorOnClick(Sender: TObject);
var
  fm: TfmEditRBLinkTypeDocNumerator;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if qrdetail.RecordCount=0 then exit;
  fm:=TfmEditRBLinkTypeDocNumerator.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.ActiveControl:=fm.bibTypeDoc;
    fm.TypeDoc_id:=qrDetail.FieldByName('TypeDoc_id').AsInteger;
    fm.TypeNumerator_id:=qrDetail.FieldByName('TypeNumerator_id').AsInteger;
    fm.OldTypeNumerator_id:=fm.TypeNumerator_id;
    fm.OldTypeDoc_id:=fm.TypeDoc_id;    
    fm.edTypeDoc.Text:=qrDetail.FieldByName('name').AsString;
    fm.edTypeNumerator.Text:=qrDetail.FieldByName('NameTypeNumerator').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('TypeDoc_id;TypeNumerator_id',
                      VarArrayOf([fm.TypeDoc_id,fm.TypeNumerator_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeNumerator.bibDelDetailLinkTypeDocNumeratorOnClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbLinkTypeDocNumerator+' where typedoc_id='+qrdetail.FieldByName('typedoc_id').asString+
           ' and TypeNumerator_id='+qrdetail.FieldByName('TypeNumerator_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     updDetail.DeleteSQL.Clear;
     updDetail.DeleteSQL.Add(sqls);
     qrDetail.Delete;
     qr.Transaction.Commit;
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if qrdetail.RecordCount=0 then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' связку <'+qrdetail.FieldByName('name').AsString+
                  '> - <'+qrdetail.FieldByName('nameTypeNumerator').AsString+'>  ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTypeNumerator.GridDetailLinkTypeDocNumeratorOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
   id1:=qrDetail.fieldByName('TypeDoc_id').asString;
   id2:=qrDetail.fieldByName('TypeNumerator_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('TypeDoc_id;TypeNumerator_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTypeNumerator.bibAddDetailNumeratorsOnClick(Sender: TObject);
var
  fm: TfmEditRBNumerators;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBNumerators.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.ActiveControl:=fm.edNameNumerator;
    fm.TypeNumerator_id:=MainQr.FieldByName('TypeNumerator_id').AsInteger;
    fm.oldTypeNumerator_id:=fm.TypeNumerator_id;
    fm.edNameTypeNumerator.Text:=MainQr.FieldByName('NameTypeNumerator').AsString;
    if fm.ShowModal=mrok then begin
    qrDetail.Locate('numerators_id',
                      VarArrayOf([fm.numerators_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeNumerator.bibChangeDetailNumeratorsOnClick(Sender: TObject);
var
  fm: TfmEditRBNumerators;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if qrdetail.RecordCount=0 then exit;  
  fm:=TfmEditRBNumerators.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.ActiveControl:=fm.edNameNumerator;
    fm.TypeNumerator_id:=qrDetail.FieldByName('TypeNumerator_id').AsInteger;
    fm.edNameTypeNumerator.Text:=qrDetail.FieldByName('NameTypeNumerator').AsString;
    fm.numerators_id:=qrDetail.FieldByName('Numerators_id').AsInteger;
    fm.oldNumerators_id:=fm.numerators_id;
    fm.oldTypeNumerator_id:=fm.TypeNumerator_id;
    fm.edNameNumerator.Text:=qrDetail.FieldByName('NameNumerators').AsString;
    fm.edPrefix.Text:=qrDetail.FieldByName('Prefix').AsString;
    fm.edSuffix.Text:=qrDetail.FieldByName('Suffix').AsString;
    fm.meAbout.Text:=qrDetail.FieldByName('About').AsString;
    fm.DTPStartDate.DateTime:=qrDetail.FieldByName('StartDate').AsDateTime;

    fm.lbStartNum.Enabled:=true;
    fm.edStartNum.Enabled:=true;
    fm.bibStartNum.Enabled:=true;


    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('numerators_id',
                      VarArrayOf([fm.numerators_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeNumerator.bibDelDetailNumeratorsOnClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
    id: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     id:=qrdetail.FieldByName('numerators_id').asString;
     sqls:='Delete from '+tbNumerators+' where numerators_id='+id;
     qr.sql.Add(sqls);
     qr.ExecSQL;

     updDetail.DeleteSQL.Clear;
     updDetail.DeleteSQL.Add(sqls);
     qrDetail.Delete;

     qr.sql.Clear;
     sqls:='delete from RDB$GENERATORS where RDB$GENERATOR_NAME = ''GEN_NUMERATOR_'+id+'_ID''';
     qr.sql.Add(sqls);
     qr.ExecSQL;

     qr.Transaction.Commit;
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if qrdetail.RecordCount=0 then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' нумератор <'+qrdetail.FieldByName('nameNumerators').AsString+
                  '> действующий с <'+qrdetail.FieldByName('StartDate').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTypeNumerator.GridDetailNumeratorsOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
   id1:=qrDetail.fieldByName('numerators_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('numerators_id',VarArrayOf([id1]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;



procedure TfmRBTypeNumerator.TypeNumeratorsOnEnterOnEnter(Sender: TObject);
begin
  LastActiveControlName:='GridDetail';
  if Sender=Grid then begin
    DBNav.DataSource:=ds;
    DBNav.Visible:=true;
  end;
  if Sender=GridDetail then begin
    DBNav.DataSource:=dsDetail;
    DBNav.Visible:=true;
  end;
end;


procedure TfmRBTypeNumerator.tcDetailChange(Sender: TObject);
begin
  if tcDetail.TabIndex<>-1 then
    ActiveQueryDetail(true);
end;

procedure TfmRBTypeNumerator.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
var
  s: string;
  Pos: Integer;
begin
   _OnVisibleInterface(hInterface,true);
   FhInterface:=hInterface;
   ViewSelect:=false;
   WhereString:=PrepearWhereString(Param.Condition.WhereStr);
   LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
   SQLString:=Param.SQL.Select;
   if Trim(LastOrderStr)='' then  LastOrderStr:=DefLastOrderStr;
   ActiveQuery(true);
   ActiveQueryDetail(true);
   FormStyle:=fsMDIChild;
   if WindowState=wsMinimized then begin
    WindowState:=wsNormal;
   end;
   BringToFront;
   Show;
end;

procedure TfmRBTypeNumerator.RGViewClick(Sender: TObject);
begin
 case RGView.ItemIndex of
   0:
     begin
      oldWidth:=pnGroup.Width;
      pnGroup.Align:=alTop;
      pnGroup.Height:=oldHeight;
      splDetail.Align:=alTop;
      pnDetail.Align:=alClient;
      GridDetail.Parent:=pntsDetail;
      GridDetail.Align:=alClient;
      Grid.Parent:=pnGroup;
      Grid.Align:=alClient;
      splDetail.Cursor:=crVSplit;
     end;
   1:
     begin
      oldHeight:=pnGroup.Height;
      splDetail.Align:=alLeft;
      pnGroup.Align:=alLeft;
      pnGroup.Width:=oldWidth;
      pnDetail.Align:=alClient;
      GridDetail.Parent:=pntsDetail;
      GridDetail.Align:=alClient;
      Grid.Parent:=pnGroup;
      Grid.Align:=alClient;
      splDetail.Cursor:=crHSplit;
     end;
 end;
end;


procedure TfmRBTypeNumerator.GridEnter(Sender: TObject);
begin
  LastActiveControlName:='Grid';
end;


procedure TfmRBTypeNumerator.GridOnExit(Sender: TObject);
begin
  LastActiveControlName:='Grid';
end;
procedure TfmRBTypeNumerator.GridDetailOnExit(Sender: TObject);
begin
  LastActiveControlName:='GridDetail';
end;

procedure TfmRBTypeNumerator.bibAddTypeNumeratorOnClick(Sender: TObject);
var
  fm: TfmEditRBTypeNumerator;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBTypeNumerator.Create(nil);
  try
     fm.fmParent:=Self;
     fm.bibOk.OnClick:=fm.AddClick;
     fm.Caption:=CaptionAdd;
     if fm.ShowModal=mrok then begin
        ViewCount;
        MainQr.Locate('typenumerator_id',fm.oldtypenumerator_id,[loCaseInsensitive]);
     end;
       finally
         fm.Free;
       end;
end;

procedure TfmRBTypeNumerator.bibChangeTypeNumeratorOnClick(Sender: TObject);
var
  fm: TfmEditRBTypeNumerator;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTypeNumerator.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.oldTypeNumerator_id:=Mainqr.FieldByName('TypeNumerator_id').AsInteger;
    fm.edNameTypeNumerator.Text:=Mainqr.FieldByName('NameTypeNumerator').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('ABOUT').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('TypeNumerator_id',fm.oldTypeNumerator_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTypeNumerator.bibDelTypeNumeratorOnClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbTypeNumerator+' where TypeNumerator_id='+
          Mainqr.FieldByName('TypeNumerator_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     qr.Transaction.Commit;
     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free;
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' тип нумератора <'+Mainqr.FieldByName('nametypenumerator').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTypeNumerator.bibAdjustClick(Sender: TObject);
begin
if LastActiveControlName='Grid' then SetAdjustColumns(Grid.Columns);
if LastActiveControlName='GridDetail' then SetAdjustColumns(GridDetail.Columns);
end;

end.
