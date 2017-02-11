unit URBUsersGroup;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL,
  ImgList, dbtree, UMainUnited, ComCtrls, grids, tsvTVNavigator, DualList;

type
   TfmRBUsersGroup = class(TfmRBMainGrid)
    pnDetail: TPanel;
    splDetail: TSplitter;
    IL: TImageList;
    dsDetail: TDataSource;
    qrDetail: TIBQuery;
    tranDetail: TIBTransaction;
    updDetail: TIBUpdateSQL;
    tcDetail: TTabControl;
    pntsDetail: TPanel;
    pnGroup: TPanel;
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
    isFindGroupNAme,isFindInterfaceName: Boolean;
    FindGroupNAme,FindInterfaceName: string;

//    isFindNameNumerator,isFindAbout,IsFindStartDate,IsFindEndDate: Boolean;
//    FindNameNumerator,FindAbout: string;
//    FindStartDate,FindEndDate: TDateTime;


//    FindViewOfGoods,FindTypeOfGoods: Integer;
//    LastGroupId: String;
    LastActiveControlName:AnsiString;
    oldHeight,oldWidth:Integer;



    procedure UsersGroupsOnEnterOnEnter(Sender: TObject);
    procedure GridDetailOnDblClick(Sender: TObject);

//Группы
    procedure bibAddUsersGroupOnClick(Sender: TObject);
    procedure bibChangeUsersGroupOnClick(Sender: TObject);
    procedure bibDelUsersGroupOnClick(Sender: TObject);

//Нумераторы
    procedure bibAddDetailUsersInGroupOnClick(Sender: TObject);
    procedure bibChangeDetailUsersInGroupOnClick(Sender: TObject);
    procedure bibDelDetailUsersInGroupOnClick(Sender: TObject);
    procedure GridDetailUsersInGroupOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);

//Связь с документами
    procedure bibAddDetailUsersAccessRightsOnClick(Sender: TObject);
    procedure bibChangeDetailUsersAccessRightsOnClick(Sender: TObject);
    procedure bibDelDetailUsersAccessRightsOnClick(Sender: TObject);
    procedure GridDetailUsersAccessRightsOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);

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
  fmRBUsersGroup: TfmRBUsersGroup;

implementation

uses USysVAVCode, USysVAVDM, USysVAVData,
     typInfo, UAdjust,
  UEditRBUsersGroup, STVAVKit, UEditRBUsersInGroup;

{$R *.DFM}

function GetGridName(Index: Integer): String;
begin
  Result:='';
  if Index=0 then Result:='GridDetailUsersInGroup';
  if Index=1 then Result:='GridDetailUsersAccessRights';
end;


procedure TfmRBUsersGroup.FormCreate(Sender: TObject);
var
//  ifl: TIntegerField;
//  sfl: TStringField;
//  bfl: TIBBCDField;
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkUsersGroup;

  LastPageIndex:=-1;
//  FindViewOfGoods:=-1;
//  FindTypeOfGoods:=-1;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  FillGridColumnsFromTb(IBDB,tbUsersGroup,Grid);
  Grid.DataSource:=ds;
  Grid.Parent:= pnGroup;
  Grid.OnEnter:=GridEnter;
  Grid.OnExit:=GridOnExit;

  pnGroup.Height:=200;  


  qrDetail.Database:=IBDB;
  tranDetail.AddDatabase(IBDB);
  IBDB.AddTransaction(tranDetail);

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
  GridDetail.OnEnter:=UsersGroupsOnEnterOnEnter;
  GridDetail.OnExit:=GridDetailOnExit;

  GridDetail.TabOrder:=1;
//  pnButDetail.TabOrder:=2;
  LoadFromIni;
  RGViewClick(nil);  
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersGroup.FormDestroy(Sender: TObject);
begin
  inherited;
  GridDetail.Free;
  if FormState=[fsCreatedMDIChild] then
   fmRBUsersGroup:=nil;
end;

function TfmRBUsersGroup.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkUsersGroup+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBUsersGroup.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindGroupNAme or isFindInterfaceName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersGroup.ActiveQueryDetail(CheckPerm: Boolean);
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

    if tcDetail.TabIndex=0 then begin
//      hInterfaceDetail:=hInterfaceRbkUsersInGroup;
      sqls:=SQLRbkUsersInGroup+' where UserGroup_id=:UserGroup_id '+LastOrderDetail;
      if not isCreate then exit;
      GridDetail.OnTitleClickWithSort:=GridDetailUsersInGroupOnTitleClickWithSort;
      GridDetail.OnDrawColumnCell:=nil;

      FillGridColumnsFromTb(IBDB,tbUsersInGroup,GridDetail);
      cl:=GridDetail.Columns.Add;
      cl.FieldName:='NAME';
      cl.Title.Caption:='Пользователи';
      cl.Width:=200;

      GridDetail.Name:=GetGridName(tcDetail.TabIndex);

      LoadGridProp(ClassName,TDbGrid(GridDetail));
    end;
    if tcDetail.TabIndex=1 then begin
//      hInterfaceDetail:=hInterfaceRbkUsersInGroup;
      sqls:=SQLRbkUsersAccessRights+' where UserGroup_id=:UserGroup_id '+LastOrderDetail;
      if not isCreate then exit;
      GridDetail.OnTitleClickWithSort:=GridDetailUsersAccessRightsOnTitleClickWithSort;
      FillGridColumnsFromTb(IBDB,tbUsersAccessRights,GridDetail);
      FillGridColumnsFromTb(IBDB,tbUsersGroup,GridDetail);
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
    Result:=isPerm;
  end;

begin
 try
  SetParamsByActivePage;
  qrDetail.Active:=false;
  if CheckPerm then
//   if not CheckPermissionDetail then exit;

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

procedure TfmRBUsersGroup.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('UserGroup_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('UserGroup_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersGroup.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBUsersGroup.LoadFromIni;
begin
 inherited;
 try
    FindGroupNAme:=ReadParam(ClassName,'FindGroupNAme',FindGroupNAme);
    FindInterfaceName:=ReadParam(ClassName,'FindInterfaceName',FindInterfaceName);

//    FindNameNumerator:=ReadParam(ClassName,'FindNameNumerator',FindNameNumerator);
//    FindAbout:=ReadParam(ClassName,'FindAbout',FindAbout);
//    FindStartDate:=ReadParam(ClassName,'FindStartDate',FindStartDate);
//    FindEndDate:=ReadParam(ClassName,'FindEndDate',FindEndDate);

    isFindGroupNAme:=ReadParam(ClassName,'isFindGroupNAme',isFindGroupNAme);
    isFindInterfaceName:=ReadParam(ClassName,'isFindInterfaceName',isFindInterfaceName);

//    isFindNameNumerator:=ReadParam(ClassName,'isFindNameNumerator',isFindNameNumerator);
//    isFindAbout:=ReadParam(ClassName,'isFindAbout',isFindAbout);
//    isFindStartDate:=ReadParam(ClassName,'isFindStartDate',isFindStartDate);
//    isFindEndDate:=ReadParam(ClassName,'isFindEndDate',isFindEndDate);


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

procedure TfmRBUsersGroup.SaveToIni;
begin
 inherited;
 try
   GridDetail.Name:=GetGridName(LastPageIndex);
   SaveGridProp(ClassName,TDbGrid(GridDetail));
    WriteParam(ClassName,'FindGroupNAme',FindGroupNAme);
    WriteParam(ClassName,'FindInterfaceName',FindInterfaceName);

    WriteParam(ClassName,'isFindGroupNAme',isFindGroupNAme);
    WriteParam(ClassName,'isFindInterfaceName',isFindInterfaceName);

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

procedure TfmRBUsersGroup.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBUsersGroup.bibAddClick(Sender: TObject);
begin
     if LastActiveControlName='Grid' then bibAddUsersGroupOnClick(nil);
     if LastActiveControlName='GridDetail' then
        begin
          if tcDetail.TabIndex=0 then
              begin
                bibAddDetailUsersInGroupOnClick(nil);
              end;
          if tcDetail.TabIndex=1 then
              begin
                bibDelDetailUsersAccessRightsOnClick(nil);
              end;
         end;
end;

procedure TfmRBUsersGroup.bibChangeClick(Sender: TObject);
begin
     if LastActiveControlName='Grid' then bibChangeUsersGroupOnClick(nil);
     if LastActiveControlName='GridDetail' then
        begin
          if tcDetail.TabIndex=0 then
              begin
                bibChangeDetailUsersInGroupOnClick(nil);
              end;
          if tcDetail.TabIndex=1 then
              begin
                bibChangeDetailUsersAccessRightsOnClick(nil);
              end;

        end;
end;

procedure TfmRBUsersGroup.bibDelClick(Sender: TObject);
begin
     if LastActiveControlName='Grid' then bibDelUsersGroupOnClick(nil);
     if LastActiveControlName='GridDetail' then
        begin
          if tcDetail.TabIndex=0 then
              begin
                bibDelDetailUsersInGroupOnClick(nil);
              end;
          if tcDetail.TabIndex=1 then
              begin
                bibDelDetailUsersAccessRightsOnClick(nil);
              end;

        end;
end;

procedure TfmRBUsersGroup.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBUsersGroup;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBUsersGroup.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.UserGroup_id:=Mainqr.FieldByName('UserGroup_id').AsInteger;
    fm.oldUserGroup_id:=fm.UserGroup_id;
    fm.edNameUsersGroup.Text:=Mainqr.FieldByName('GroupName').AsString;
//    fm.meAbout.Text:=Mainqr.fieldByName('ABOUT').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsersGroup.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBUsersGroup;
begin
 fm:=TfmEditRBUsersGroup.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindGroupNAme)<>'' then fm.edNameUsersGroup.Text:=FindGroupNAme;
//  if Trim(FindAboutType)<>'' then fm.meAbout.Text:=FindAboutType;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindGroupNAme:=Trim(fm.edNameUsersGroup.Text);
//    FindAboutType:=Trim(fm.meAbout.Text);

    FilterInSide:=fm.cbInString.Checked;

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBUsersGroup.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindGroupNAme:=Trim(FindGroupNAme)<>'';
    isFindInterfaceName:=Trim(FindInterfaceName)<>'';

    if isFindGroupNAme or isFindInterfaceName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindGroupNAme then begin
        addstr1:=' Upper(tn.GroupName) like '+AnsiUpperCase(QuotedStr(FilInSide+FindGroupNAme+'%'))+' ';
     end;

     if isFindInterfaceName then begin
        addstr2:=' Upper(tn.InterFaceName) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInterfaceName+'%'))+' ';
     end;

     if (isFindGroupNAme and isFindInterfaceName) then
      and1:=' and ';


     Result:=wherestr+addstr1+and1+addstr2;
end;

procedure TfmRBUsersGroup.ShowingChanged;
begin
  inherited;
end;

procedure TfmRBUsersGroup.qrGroupAfterScroll(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmRBUsersGroup.GridDetailOnDblClick(Sender: TObject);
begin
  if not qrDetail.Active then exit;
  if qrDetail.RecordCount=0 then exit;
  bibChange.Click;
end;

procedure TfmRBUsersGroup.bibAdjustDetailClick(Sender: TObject);
begin
  SetAdjustColumns(GridDetail.Columns);
end;

procedure TfmRBUsersGroup.bibAddDetailUsersAccessRightsOnClick(Sender: TObject);
//var
//  fm: TfmEditRBUsersAccessRights;
begin
{  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBUsersAccessRights.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.ActiveControl:=fm.bibTypeDoc;
    fm.UsersGroup_id:=MainQr.FieldByName('UsersGroup_id').AsInteger;
    fm.OldUsersGroup_id:=fm.UsersGroup_id;
    fm.edUsersGroup.Text:=MainQr.FieldByName('NameUsersGroup').AsString;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('UsersGroup_id;TypeDoc_id',
                      VarArrayOf([fm.UsersGroup_id,fm.TypeDoc_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;   }
end;

procedure TfmRBUsersGroup.bibChangeDetailUsersAccessRightsOnClick(Sender: TObject);
//var
//  fm: TfmEditRBUsersAccessRights;
begin
{  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  fm:=TfmEditRBUsersAccessRights.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.ActiveControl:=fm.bibTypeDoc;
    fm.TypeDoc_id:=qrDetail.FieldByName('TypeDoc_id').AsInteger;
    fm.UsersGroup_id:=qrDetail.FieldByName('UsersGroup_id').AsInteger;
    fm.OldUsersGroup_id:=fm.UsersGroup_id;
    fm.OldTypeDoc_id:=fm.TypeDoc_id;    
    fm.edTypeDoc.Text:=qrDetail.FieldByName('name').AsString;
    fm.edUsersGroup.Text:=qrDetail.FieldByName('NameUsersGroup').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('TypeDoc_id;UsersGroup_id',
                      VarArrayOf([fm.TypeDoc_id,fm.UsersGroup_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;}
end;

procedure TfmRBUsersGroup.bibDelDetailUsersAccessRightsOnClick(Sender: TObject);
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
     sqls:='Delete from '+tbUsersAccessRights+' where typedoc_id='+qrdetail.FieldByName('typedoc_id').asString+
           ' and UserGroup_id='+qrdetail.FieldByName('UserGroup_id').asString;
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
                  '> - <'+qrdetail.FieldByName('Groupname').AsString+'>  ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBUsersGroup.GridDetailUsersAccessRightsOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
//   id1:=qrDetail.fieldByName('TypeDoc_id').asString;
   id2:=qrDetail.fieldByName('UserGroup_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('TypeDoc_id;UserGroup_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsersGroup.bibAddDetailUsersInGroupOnClick(Sender: TObject);
var
  fm: TfmEditRBUsersInGroup;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBUsersInGroup.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.FillGridSrc(MainQr.FieldByName('UserGroup_id').AsInteger);
    fm.FillGridDst(MainQr.FieldByName('UserGroup_id').AsInteger);

//    fm.ActiveControl:=fm.edNameNumerator;
    fm.UserGroup_id:=MainQr.FieldByName('UserGroup_id').AsInteger;
//    fm.oldUsersGroup_id:=fm.UsersGroup_id;
//    fm.edNameUsersGroup.Text:=MainQr.FieldByName('NameUsersGroup').AsString;
    if fm.ShowModal=mrok then begin
    qrDetail.Locate('UsersInGroup_id',
                      VarArrayOf([fm.UsersInGroup_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsersGroup.bibChangeDetailUsersInGroupOnClick(Sender: TObject);
//var
//  fm: TfmEditRBUsersInGroup;
begin
{  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  fm:=TfmEditRBUsersInGroup.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.ActiveControl:=fm.edNameNumerator;
    fm.UsersGroup_id:=qrDetail.FieldByName('UsersGroup_id').AsInteger;
    fm.edNameUsersGroup.Text:=qrDetail.FieldByName('NameUsersGroup').AsString;
    fm.UsersInGroup_id:=qrDetail.FieldByName('UsersInGroup_id').AsInteger;
    fm.oldUsersInGroup_id:=fm.UsersInGroup_id;
    fm.oldUsersGroup_id:=fm.UsersGroup_id;
    fm.edNameNumerator.Text:=qrDetail.FieldByName('NameUsersInGroup').AsString;
    fm.edPrefix.Text:=qrDetail.FieldByName('Prefix').AsString;
    fm.edSuffix.Text:=qrDetail.FieldByName('Suffix').AsString;
    fm.meAbout.Text:=qrDetail.FieldByName('About').AsString;
    fm.DTPStartDate.DateTime:=qrDetail.FieldByName('StartDate').AsDateTime;

    fm.lbStartNum.Enabled:=true;
    fm.edStartNum.Enabled:=true;
    fm.bibStartNum.Enabled:=true;


    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('UsersInGroup_id',
                      VarArrayOf([fm.UsersInGroup_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;}
end;

procedure TfmRBUsersGroup.bibDelDetailUsersInGroupOnClick(Sender: TObject);
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
     id:=qrdetail.FieldByName('UsersInGroup_id').asString;
     sqls:='Delete from '+tbUsersInGroup+' where UsersInGroup_id='+id;
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
                  Pchar(CaptionDelete+' нумератор <'+qrdetail.FieldByName('nameUsersInGroup').AsString+
                  '> действующий с <'+qrdetail.FieldByName('StartDate').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBUsersGroup.GridDetailUsersInGroupOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
   id1:=qrDetail.fieldByName('UsersInGroup_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('UsersInGroup_id',VarArrayOf([id1]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;



procedure TfmRBUsersGroup.UsersGroupsOnEnterOnEnter(Sender: TObject);
begin
  if Sender=Grid then begin
    DBNav.DataSource:=ds;
    DBNav.Visible:=true;
  end;
  if Sender=GridDetail then begin
    DBNav.DataSource:=dsDetail;
    DBNav.Visible:=true;
  end;
end;


procedure TfmRBUsersGroup.tcDetailChange(Sender: TObject);
begin
  if tcDetail.TabIndex<>-1 then
    ActiveQueryDetail(true);
end;

procedure TfmRBUsersGroup.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
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

procedure TfmRBUsersGroup.bibAddUsersGroupOnClick(Sender: TObject);
var
  fm: TfmEditRBUsersGroup;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBUsersGroup.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.UserGroup_id:=Mainqr.FieldByName('UserGroup_id').AsInteger;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('UserGroup_id',fm.oldUserGroup_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsersGroup.bibChangeUsersGroupOnClick(Sender: TObject);
var
  fm: TfmEditRBUsersGroup;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBUsersGroup.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.UserGroup_id:=Mainqr.FieldByName('UserGroup_id').AsInteger;
    fm.oldUserGroup_id:=Mainqr.FieldByName('UserGroup_id').AsInteger;
    fm.edNameUsersGroup.Text:=Mainqr.FieldByName('GroupName').AsString;
//    fm.meAbout.Text:=Mainqr.fieldByName('ABOUT').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('UserGroup_id',fm.oldUserGroup_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsersGroup.bibDelUsersGroupOnClick(Sender: TObject);
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
     sqls:='Delete from '+tbUsersGroup+' where UserGroup_id='+
          Mainqr.FieldByName('UserGroup_id').asString;
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
                  Pchar(CaptionDelete+' тип нумератора <'+Mainqr.FieldByName('Groupname').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;



procedure TfmRBUsersGroup.RGViewClick(Sender: TObject);
begin
 case RGView.ItemIndex of
   0:
     begin
      oldWidth:=pnGroup.Width;
      pnGroup.Align:=alTop;
      pnGroup.Height:=oldHeight;
      splDetail.Align:=alTop;
      pnDetail.Align:=alClient;
//      pnButDetail.Visible:=true;
//      pnButDetail.Align:=alRight;
      GridDetail.Parent:=pntsDetail;
      GridDetail.Align:=alClient;
      Grid.Parent:=pnGroup;
      Grid.Align:=alClient;
      splDetail.Cursor:=crVSplit;
     end;
   1:
     begin
      oldHeight:=pnGroup.Height;
//      pnButDetail.Align:=alRight;
//      pnButDetail.Visible:=false;
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

procedure TfmRBUsersGroup.bibAdjustClick(Sender: TObject);
begin
if LastActiveControlName='Grid' then SetAdjustColumns(Grid.Columns);
if LastActiveControlName='GridDetail' then SetAdjustColumns(GridDetail.Columns);
end;

procedure TfmRBUsersGroup.GridEnter(Sender: TObject);
begin
  LastActiveControlName:='Grid';
end;


procedure TfmRBUsersGroup.GridOnExit(Sender: TObject);
begin
  LastActiveControlName:='Grid';
end;
procedure TfmRBUsersGroup.GridDetailOnExit(Sender: TObject);
begin
  LastActiveControlName:='GridDetail';
end;


end.
