unit URBNomenclature;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL,
  ImgList, dbtree, UMainUnited, ComCtrls, grids, tsvTVNavigator;

type
   TfmRBNomenclature = class(TfmRBMainGrid)
    pnDetail: TPanel;
    pnGroup: TPanel;
    splDetail: TSplitter;
    splGroup: TSplitter;
    IL: TImageList;
    dsGroup: TDataSource;
    qrGroup: TIBQuery;
    tranGroup: TIBTransaction;
    dsDetail: TDataSource;
    qrDetail: TIBQuery;
    tranDetail: TIBTransaction;
    updDetail: TIBUpdateSQL;
    chbNoTreeView: TCheckBox;
    tcDetail: TTabControl;
    pntsDetail: TPanel;
    pnButDetail: TPanel;
    bibAddDetail: TBitBtn;
    bibChangeDetail: TBitBtn;
    bibDelDetail: TBitBtn;
    bibAdjustDetail: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure qrGroupAfterScroll(DataSet: TDataSet);
    procedure MainqrCalcFields(DataSet: TDataSet);
    procedure bibAdjustDetailClick(Sender: TObject);
    procedure chbNoTreeViewClick(Sender: TObject);
    procedure tcDetailChange(Sender: TObject);
  private
    TVNavigator: TTVNavigator;
    
    LastPageIndex: Integer;
    LastOrderDetail: string;
    GridDetail: TNewdbGrid;
    isFindNum,isFindName,isFindFullName,isFindArticle,isFindOKDP,
    isFindViewOfGoods,isFindTypeOfGoods,isFindGtd,isFindCountry,isFindGroup: Boolean;
    FindNum,FindName,FindFullName,FindArticle,FindOKDP,FindGroup,
    FindGtd,FindCountry: string;
    FindViewOfGoods,FindTypeOfGoods: Integer;
    LastGroupId: String;


    procedure TreeViewClick(Sender: TObject);
    procedure TreeViewOnEnter(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure GridDetailOnDblClick(Sender: TObject);

    procedure bibAddDetailPropertiesOnClick(Sender: TObject);
    procedure bibChangeDetailPropertiesOnClick(Sender: TObject);
    procedure bibDelDetailPropertiesOnClick(Sender: TObject);
    procedure GridDetailPropertiesOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);

    procedure bibAddDetailUnitsOnClick(Sender: TObject);
    procedure bibChangeDetailUnitsOnClick(Sender: TObject);
    procedure bibDelDetailUnitsOnClick(Sender: TObject);
    procedure GridDetailUnitsOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
    procedure GridDetailUnitsDrawColumnCell(Sender: TObject; const Rect: TRect;
                                            DataCol: Integer; Column: TColumn; State: TGridDrawState);

    procedure bibAddDetailTypeOfPriceOnClick(Sender: TObject);
    procedure bibChangeDetailTypeOfPriceOnClick(Sender: TObject);
    procedure bibDelDetailTypeOfPriceOnClick(Sender: TObject);
    procedure GridDetailTypeOfPriceOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);

  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    procedure ShowingChanged; override;
  public
    TreeView: TDBTreeView;
    procedure LocateToFirstNode;
    procedure ActiveQueryTreeView;
    procedure ActiveQueryDetail(CheckPerm: Boolean);
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface); override;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface); override;
  end;

var
  fmRBNomenclature: TfmRBNomenclature;

  function GetViewOfGoodsByValue(Value: Integer): string;
  function GetTypeOfGoodsByValue(Value: Integer): string;

implementation

uses UStoreTsvCode, UStoreTsvDM, UStoreTsvData, UEditRBNomenclature,
     URBMainTreeView, typInfo, tsvAdjust, UEditRBNomenclatureProperties,
  UEditRBNomenclatureUnitOfMeasure, UEditRBNomenclatureTypeOfprice;

{$R *.DFM}

function GetViewOfGoodsByValue(Value: Integer): string;
begin
  Result:='';
  case Value of
    0: Result:='Товар';
    1: Result:='Услуга';
    2: Result:='Набор';
  end;
end;

function GetTypeOfGoodsByValue(Value: Integer): string;
begin
  Result:='';
  case Value of
    0: Result:='Штучный';
    1: Result:='Весовой';
  end;
end;

function GetGridName(Index: Integer): String;
begin
  Result:='';
  if Index=0 then Result:='GridDetailPrice';
  if Index=1 then Result:='GridDetailUnits';
  if Index=2 then Result:='GridDetailProperties';
end;


procedure TfmRBNomenclature.FormCreate(Sender: TObject);
var
  ifl: TIntegerField;
  sfl: TStringField;
  bfl: TIBBCDField;
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkNomenclature;

  LastPageIndex:=-1;
  FindViewOfGoods:=-1;
  FindTypeOfGoods:=-1;

  qrGroup.Database:=IBDB;
  tranGroup.AddDatabase(IBDB);
  IBDB.AddTransaction(tranGroup);

  TreeView:=TDBTreeView.Create(nil);
  TreeView.Parent:=pnGroup;
  AssignFont(_GetOptions.RBTableFont,TreeView.Font);
  TreeView.Align:=alClient;
  TreeView.Images:=IL;
  TreeView.ReadOnly:=true;
  TreeView.DataSource:=dsGroup;
  TreeView.HideSelection:=false;
  TreeView.OnKeyDown:=FormKeyDown;
  TreeView.OnClick:=TreeViewClick;
  TreeView.OnChange:=TreeViewChange;
  TreeView.OnEnter:=TreeViewOnEnter;

  TreeView.ParentField:='parent_id';
  TreeView.ListField:='name';
  TreeView.KeyField:='nomenclaturegroup_id';
  TreeView.DisplayField:='name';

  TVNavigator:=TTVNavigator.Create(nil);
  TVNavigator.Parent:=pnBottom;
  TVNavigator.TreeView:=TreeView;
  TVNavigator.VisibleButtons:=TTVButtonSet(DBNav.VisibleButtons);
  TVNavigator.SetBounds(DBNav.Left,DBNav.Top,DBNav.Width,DBNav.Height);
  TVNavigator.Hints.Assign(DBNav.Hints);
  TVNavigator.Visible:=false;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='nomenclature_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='nomenclaturegroup_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='gtd_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='country_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;
  
  sfl:=TStringField.Create(nil);
  sfl.FieldName:='num';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Номер';
  cl.Width:=60;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='name';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='fullname';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Полное наименование';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='article';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Артикул';
  cl.Width:=80;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='okdp';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='ОКДП';
  cl.Width:=80;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='viewofgoods';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='viewofgoodsplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Вид товара';
  cl.Width:=100;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='typeofgoods';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='typeofgoodsplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Тип товара';
  cl.Width:=100;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='gtdnum';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Номер ГТД';
  cl.Width:=80;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='countryname';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Страна производитель';
  cl.Width:=100;

  bfl:=TIBBCDField.Create(nil);
  bfl.FieldName:='ndsrate';
  bfl.Precision:=DomainMoneyPrecision;
  bfl.Size:=DomainMoneySize;
  bfl.Visible:=false;
  bfl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='ndsrateplus';
  sfl.FieldKind:=fkCalculated;
  sfl.Alignment:=taRightJustify;
  sfl.DataSet:=Mainqr;
  
  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Ставка НДС';
  cl.Width:=100;

  bfl:=TIBBCDField.Create(nil);
  bfl.FieldName:='nprate';
  bfl.Precision:=DomainMoneyPrecision;
  bfl.Size:=DomainMoneySize;
  bfl.Visible:=false;
  bfl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='nprateplus';
  sfl.FieldKind:=fkCalculated;
  sfl.Alignment:=taRightJustify;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Ставка НП';
  cl.Width:=100;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='nomenclaturegroupname';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Группа';
  cl.Width:=80;

  Grid.OnEnter:=TreeViewOnEnter;
  pnGroup.TabOrder:=1;
  Grid.TabOrder:=2;
  pnDetail.TabOrder:=3;

  qrDetail.Database:=IBDB;
  tranDetail.AddDatabase(IBDB);
  IBDB.AddTransaction(tranDetail);

  GridDetail:=TNewdbGrid.Create(self);
  GridDetail.Parent:=pntsDetail;
  GridDetail.Align:=alClient;
  GridDetail.DataSource:=dsDetail;
  GridDetail.Name:='GridDetail';
  GridDetail.RowSelected.Visible:=true;
  GridDetail.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
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
  GridDetail.OnEnter:=TreeViewOnEnter;
  GridDetail.TabOrder:=1;
  pnButDetail.TabOrder:=2;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.FormDestroy(Sender: TObject);
begin
  inherited;
  TVNavigator.Free;
  TreeView.Parent:=nil;
  TreeView.Free;
  GridDetail.Free;
  if FormState=[fsCreatedMDIChild] then
   fmRBNomenclature:=nil;
end;

function TfmRBNomenclature.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkNomenclature+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBNomenclature.LocateToFirstNode;
var
  val: Variant;
begin
  if qrGroup.IsEmpty then exit;
  if TreeView.Items.Count=0 then exit;
  if Trim(LastGroupId)='' then 
   val:=TreeView.DBTreeNodes.GetKeyFieldValue(TreeView.Items[0])
  else val:=LastGroupId; 
  qrGroup.locate(TreeView.KeyField,val,[loCaseInsensitive]);
end;

procedure TfmRBNomenclature.ActiveQueryTreeView;
var
 sqls: String;
begin
  Screen.Cursor:=crHourGlass;
  qrGroup.AfterScroll:=nil;
  TreeView.Items.BeginUpdate;
  try
    qrGroup.sql.Clear;
    sqls:=SQLRbkNomenclatureGroup;
    qrGroup.sql.Add(sqls);
    qrGroup.Transaction.Active:=false;
    qrGroup.Transaction.Active:=true;
    qrGroup.Active:=true;
    LocateToFirstNode;
    SetImageToTreeNodesByTreeView(TreeView);
  finally
   TreeView.FullCollapse;
   TreeView.Items.EndUpdate;
   qrGroup.AfterScroll:=qrGroupAfterScroll;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmRBNomenclature.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindNum or isFindName or isFindFullName or isFindArticle or isFindOKDP or
                  isFindViewOfGoods or isFindTypeOfGoods or isFindGtd or isFindCountry or isFindGroup);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.ActiveQueryDetail(CheckPerm: Boolean);
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
      hInterfaceDetail:=hInterfaceRbkNomenclatureTypeOfPrice;
      sqls:=SQLRbkNomenclatureTypeOfPrice+' where ntp.nomenclature_id=:nomenclature_id '+LastOrderDetail;
      if not isCreate then exit;
      bibAddDetail.OnClick:=bibAddDetailTypeOfPriceOnClick;
      bibChangeDetail.OnClick:=bibChangeDetailTypeOfPriceOnClick;
      bibDelDetail.OnClick:=bibDelDetailTypeOfPriceOnClick;
      GridDetail.OnTitleClickWithSort:=GridDetailTypeOfPriceOnTitleClickWithSort;
      GridDetail.OnDrawColumnCell:=nil;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='typeofpricename';
      cl.Title.Caption:='Тип цены';
      cl.Width:=100;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='unitofmeasurename';
      cl.Title.Caption:='Единица измерения';
      cl.Width:=100;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='currencyname';
      cl.Title.Caption:='Валюта';
      cl.Width:=100;
      
      cl:=GridDetail.Columns.Add;
      cl.FieldName:='pay';
      cl.Title.Caption:='Наценка';
      cl.Width:=60;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='price';
      cl.Title.Caption:='Цена';
      cl.Width:=60;

      GridDetail.Name:=GetGridName(tcDetail.TabIndex);
      LoadGridProp(ClassName,TDbGrid(GridDetail));
    end;
    if tcDetail.TabIndex=1 then begin
      hInterfaceDetail:=hInterfaceRbkNomenclatureUnitOfMeasure;
      sqls:=SQLRbkNomenclatureUnitOfMeasure+' where nm.nomenclature_id=:nomenclature_id '+LastOrderDetail;
      if not isCreate then exit;
      bibAddDetail.OnClick:=bibAddDetailUnitsOnClick;
      bibChangeDetail.OnClick:=bibChangeDetailUnitsOnClick;
      bibDelDetail.OnClick:=bibDelDetailUnitsOnClick;
      GridDetail.OnTitleClickWithSort:=GridDetailUnitsOnTitleClickWithSort;
      GridDetail.OnDrawColumnCell:=GridDetailUnitsDrawColumnCell;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='unitofmeasurename';
      cl.Title.Caption:='Единица измерения';
      cl.Width:=150;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='isbaseunitplus';
      cl.Title.Caption:='Это базовая единица';
      cl.Width:=100;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='code';
      cl.Title.Caption:='Штрих код';
      cl.Width:=100;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='weigth';
      cl.Title.Caption:='Вес';
      cl.Width:=60;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='calcfactor';
      cl.Title.Caption:='Коэффициент пересчета';
      cl.Width:=60;

      GridDetail.Name:=GetGridName(tcDetail.TabIndex);
      LoadGridProp(ClassName,TDbGrid(GridDetail));
    end;
    if tcDetail.TabIndex=2 then begin
      hInterfaceDetail:=hInterfaceRbkNomenclatureProperties;
      sqls:=SQLRbkNomenclatureProperties+' where nvp.nomenclature_id=:nomenclature_id '+LastOrderDetail;
      if not isCreate then exit;
      bibAddDetail.OnClick:=bibAddDetailPropertiesOnClick;
      bibChangeDetail.OnClick:=bibChangeDetailPropertiesOnClick;
      bibDelDetail.OnClick:=bibDelDetailPropertiesOnClick;
      GridDetail.OnTitleClickWithSort:=GridDetailPropertiesOnTitleClickWithSort;
      GridDetail.OnDrawColumnCell:=nil;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='nameproperties';
      cl.Title.Caption:='Свойство';
      cl.Width:=150;

      cl:=GridDetail.Columns.Add;
      cl.FieldName:='valueproperties';
      cl.Title.Caption:='Значение';
      cl.Width:=100;

      GridDetail.Name:=GetGridName(tcDetail.TabIndex);
      LoadGridProp(ClassName,TDbGrid(GridDetail));
    end;

  end;

  function CheckPermissionDetail: Boolean;
  var
    isPerm: Boolean;
  begin
    isPerm:=_isPermissionOnInterface(hInterfaceDetail,ttiaView);
    bibChangeDetail.Enabled:=isPerm and _isPermissionOnInterface(hInterfaceDetail,ttiaChange);
    bibAddDetail.Enabled:=isPerm and _isPermissionOnInterface(hInterfaceDetail,ttiaAdd);
    bibDelDetail.Enabled:=isPerm and _isPermissionOnInterface(hInterfaceDetail,ttiaDelete);
    bibAdjustDetail.Enabled:=isPerm;
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

procedure TfmRBNomenclature.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('num') then fn:='n.num';
   if AnsiUpperCase(fn)=AnsiUpperCase('name') then fn:='n.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('gtdnum') then fn:='g.num';
   if AnsiUpperCase(fn)=AnsiUpperCase('countryname') then fn:='c.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('viewofgoodsplus') then fn:='viewofgoods';
   if AnsiUpperCase(fn)=AnsiUpperCase('typeofgoodsplus') then fn:='typeofgoods';
   if AnsiUpperCase(fn)=AnsiUpperCase('ndsrateplus') then fn:='ndsrate';
   if AnsiUpperCase(fn)=AnsiUpperCase('nprateplus') then fn:='nprate';
   if AnsiUpperCase(fn)=AnsiUpperCase('nomenclaturegroupname') then fn:='ng.name';
   id:=MainQr.fieldByName('nomenclature_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('nomenclature_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBNomenclature.LoadFromIni;
begin
 inherited;
 try
    FindNum:=ReadParam(ClassName,'num',FindNum);
    FindName:=ReadParam(ClassName,'name',FindName);
    FindFullName:=ReadParam(ClassName,'fullname',FindFullName);
    FindArticle:=ReadParam(ClassName,'article',FindArticle);
    FindOKDP:=ReadParam(ClassName,'okdp',FindOKDP);
    FindViewOfGoods:=ReadParam(ClassName,'viewofgoods',FindViewOfGoods);
    FindTypeOfGoods:=ReadParam(ClassName,'typeofgoods',FindTypeOfGoods);
    FindGtd:=ReadParam(ClassName,'gtd',FindGtd);
    FindCountry:=ReadParam(ClassName,'country',FindCountry);
    FindGroup:=ReadParam(ClassName,'group',FindGroup);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
    pnGroup.Width:=ReadParam(ClassName,'pnGroupWidth',pnGroup.Width);
    pnDetail.Height:=ReadParam(ClassName,'pnDetailHeight',pnDetail.Height);
    tcDetail.TabIndex:=ReadParam(ClassName,'tcDetailTabIndex',tcDetail.TabIndex);
    chbNoTreeView.OnClick:=nil;
    chbNoTreeView.Checked:=ReadParam(ClassName,'chbNoTreeViewChecked',chbNoTreeView.Checked);
    chbNoTreeView.OnClick:=chbNoTreeViewClick;
    splGroup.Visible:=not chbNoTreeView.Checked;
    pnGroup.Visible:=splGroup.Visible;
    if splGroup.Visible then FindGroup:='';

 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.SaveToIni;
begin
 inherited;
 try
   GridDetail.Name:=GetGridName(LastPageIndex);
   SaveGridProp(ClassName,TDbGrid(GridDetail));
    WriteParam(ClassName,'num',FindNum);
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'fullname',FindFullName);
    WriteParam(ClassName,'article',FindArticle);
    WriteParam(ClassName,'okdp',FindOKDP);
    WriteParam(ClassName,'viewofgoods',FindViewOfGoods);
    WriteParam(ClassName,'typeofgoods',FindTypeOfGoods);
    WriteParam(ClassName,'gtd',FindGtd);
    WriteParam(ClassName,'country',FindCountry);
    WriteParam(ClassName,'group',FindGroup);
    WriteParam(ClassName,'Inside',FilterInside);
    WriteParam(ClassName,'pnGroupWidth',pnGroup.Width);
    WriteParam(ClassName,'pnDetailHeight',pnDetail.Height);
    WriteParam(ClassName,'tcDetailTabIndex',tcDetail.TabIndex);
    WriteParam(ClassName,'chbNoTreeViewChecked',chbNoTreeView.Checked);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBNomenclature.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBNomenclature;
begin
  if not Mainqr.Active then exit;
  if qrGroup.IsEmpty then exit;
  fm:=TfmEditRBNomenclature.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    fm.isNoTreeView:=chbNoTreeView.Checked;
    if not chbNoTreeView.Checked then begin
     fm.nomenclaturegroup_id:=qrGroup.FieldByName('nomenclaturegroup_id').AsInteger;
     fm.oldnomenclaturegroup_id:=fm.nomenclaturegroup_id;
     fm.edGroup.Text:=qrGroup.FieldByName('name').AsString;
    end;
    fm.SetDefaultCountry;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('nomenclature_id',fm.oldnomenclature_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBNomenclature;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  if qrGroup.IsEmpty then exit;
  fm:=TfmEditRBNomenclature.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.isNoTreeView:=chbNoTreeView.Checked;
    fm.nomenclaturegroup_id:=Mainqr.FieldByName('nomenclaturegroup_id').AsInteger;
    fm.oldnomenclaturegroup_id:=fm.nomenclaturegroup_id;
    fm.edGroup.Text:=Mainqr.FieldByName('nomenclaturegroupname').AsString;
    fm.edNum.Text:=Mainqr.fieldByName('num').AsString;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edFullName.Text:=Mainqr.fieldByName('fullname').AsString;
    fm.edArticle.Text:=Mainqr.fieldByName('article').AsString;
    fm.edOkdp.Text:=Mainqr.fieldByName('okdp').AsString;
    fm.cmbViewOfGoods.ItemIndex:=Mainqr.fieldByName('viewofgoods').AsInteger;
    fm.cmbTypeOfGoods.ItemIndex:=Mainqr.fieldByName('typeofgoods').AsInteger;
    fm.gtd_id:=Mainqr.FieldByName('gtd_id').AsInteger;
    fm.edGtdNum.Text:=Mainqr.FieldByName('gtdnum').AsString;
    fm.edNdsRate.Text:=Mainqr.fieldByName('ndsrate').AsString;
    fm.country_id:=Mainqr.FieldByName('country_id').AsInteger;
    fm.edCountryName.Text:=Mainqr.FieldByName('countryname').AsString;
    fm.edNpRate.Text:=Mainqr.fieldByName('nprate').AsString;
    fm.oldnomenclature_id:=MainQr.FieldByName('nomenclature_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('nomenclature_id',fm.oldnomenclature_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbNomenclature+' where nomenclature_id='+
          Mainqr.FieldByName('nomenclature_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     
     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
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
  but:=DeleteWarningEx('номенклатуру <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBNomenclature.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBNomenclature;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBNomenclature.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.nomenclaturegroup_id:=Mainqr.FieldByName('nomenclaturegroup_id').AsInteger;
    fm.oldnomenclaturegroup_id:=fm.nomenclaturegroup_id;
    fm.edGroup.Text:=Mainqr.FieldByName('nomenclaturegroupname').AsString;
    fm.edNum.Text:=Mainqr.fieldByName('num').AsString;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edFullName.Text:=Mainqr.fieldByName('fullname').AsString;
    fm.edArticle.Text:=Mainqr.fieldByName('article').AsString;
    fm.edOkdp.Text:=Mainqr.fieldByName('okdp').AsString;
    fm.cmbViewOfGoods.ItemIndex:=Mainqr.fieldByName('viewofgoods').AsInteger;
    fm.cmbTypeOfGoods.ItemIndex:=Mainqr.fieldByName('typeofgoods').AsInteger;
    fm.gtd_id:=Mainqr.FieldByName('gtd_id').AsInteger;
    fm.edGtdNum.Text:=Mainqr.FieldByName('gtdnum').AsString;
    fm.edNdsRate.Text:=Mainqr.fieldByName('ndsrate').AsString;
    fm.country_id:=Mainqr.FieldByName('country_id').AsInteger;
    fm.edCountryName.Text:=Mainqr.FieldByName('countryname').AsString;
    fm.edNpRate.Text:=Mainqr.fieldByName('nprate').AsString;
    fm.oldnomenclature_id:=MainQr.FieldByName('nomenclature_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBNomenclature;
begin
 fm:=TfmEditRBNomenclature.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.lbGroup.Enabled:=chbNoTreeView.Checked;
  fm.edGroup.Enabled:=chbNoTreeView.Checked;
  fm.edGroup.ReadOnly:=not chbNoTreeView.Checked;
  fm.edGroup.Color:=Iff(not chbNoTreeView.Checked,clBtnFace,clWindow);
  fm.bibGroup.Enabled:=chbNoTreeView.Checked;

  fm.cmbViewOfGoods.Style:=csDropDown;
  fm.cmbViewOfGoods.ItemIndex:=-1;
  fm.cmbTypeOfGoods.Style:=csDropDown;
  fm.cmbTypeOfGoods.ItemIndex:=-1;
  fm.edGtdNum.ReadOnly:=false;
  fm.edGtdNum.Color:=clWindow;
  fm.edCountryName.ReadOnly:=false;
  fm.edCountryName.Color:=clWindow;
  fm.edNdsRate.Enabled:=false;
  fm.edNdsRate.Color:=clBtnFace;
  fm.lbNdsRate.Enabled:=false;
  fm.edNpRate.Enabled:=false;
  fm.edNpRate.Color:=clBtnFace;
  fm.lbNpRate.Enabled:=false;

  if Trim(FindNum)<>'' then fm.edNum.Text:=FindNum;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindFullName)<>'' then fm.edFullName.Text:=FindFullName;
  if Trim(FindArticle)<>'' then fm.edArticle.Text:=FindArticle;
  if Trim(FindOKDP)<>'' then fm.edOKDP.Text:=FindOKDP;
  fm.cmbViewOfGoods.ItemIndex:=FindViewOfGoods;
  fm.cmbTypeOfGoods.ItemIndex:=FindTypeOfGoods;
  if Trim(FindGtd)<>'' then fm.edGtdNum.Text:=FindGtd;
  if Trim(FindCountry)<>'' then fm.edCountryName.Text:=FindCountry;
  if chbNoTreeView.Checked then
   if Trim(FindGroup)<>'' then fm.edGroup.Text:=FindGroup;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNum:=Trim(fm.edNum.Text);
    FindName:=Trim(fm.edName.Text);
    FindFullName:=Trim(fm.edFullName.Text);
    FindArticle:=Trim(fm.edArticle.Text);
    FindOKDP:=Trim(fm.edOKDP.Text);
    FindViewOfGoods:=fm.cmbViewOfGoods.Items.IndexOf(fm.cmbViewOfGoods.Text);
    FindTypeOfGoods:=fm.cmbTypeOfGoods.Items.IndexOf(fm.cmbTypeOfGoods.Text);
    FindGtd:=trim(fm.edGtdNum.Text);
    FindCountry:=Trim(fm.edCountryName.Text);
    FindGroup:=Trim(fm.edGroup.Text);

    FilterInSide:=fm.cbInString.Checked;

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBNomenclature.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,addstr8,addstr9,addstr10,addstr11: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10: string;
  isFindByGroup: Boolean;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindNum:=Trim(FindNum)<>'';
    isFindName:=Trim(FindName)<>'';
    isFindFullName:=Trim(FindFullName)<>'';
    isFindArticle:=Trim(FindArticle)<>'';
    isFindOKDP:=Trim(FindOkdp)<>'';
    isFindViewOfGoods:=FindViewOfGoods<>-1;
    isFindTypeOfGoods:=FindTypeOfGoods<>-1;
    isFindGtd:=Trim(FindGtd)<>'';
    isFindCountry:=Trim(FindCountry)<>'';
    isFindByGroup:=not chbNoTreeView.Checked;
    isFindGroup:=Trim(FindGroup)<>'';

    if isFindNum or isFindName or isFindFullName or isFindArticle or isFindOKDP or
       isFindViewOfGoods or isFindTypeOfGoods or isFindGtd or isFindCountry or isFindByGroup or
       isFindGroup then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNum then begin
        addstr1:=' Upper(n.num) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNum+'%'))+' ';
     end;

     if isFindName then begin
        addstr2:=' Upper(n.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindFullName then begin
        addstr3:=' Upper(fullname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFullName+'%'))+' ';
     end;

     if isFindArticle then begin
        addstr4:=' Upper(article) like '+AnsiUpperCase(QuotedStr(FilInSide+FindArticle+'%'))+' ';
     end;

     if isFindOkdp then begin
        addstr5:=' Upper(okdp) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOkdp+'%'))+' ';
     end;

     if isFindViewOfGoods then begin
        addstr6:=' viewofgoods='+inttostr(FindViewOfGoods)+' ';
     end;

     if isFindTypeOfGoods then begin
        addstr7:=' typeofgoods='+inttostr(FindTypeOfGoods)+' ';
     end;

     if isFindGtd then begin
        addstr8:=' Upper(g.num) like '+AnsiUpperCase(QuotedStr(FilInSide+Findgtd+'%'))+' ';
     end;

     if isFindcountry then begin
        addstr9:=' Upper(c.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Findcountry+'%'))+' ';
     end;

     if isFindByGroup then begin
        addstr10:=' n.nomenclaturegroup_id=:nomenclaturegroup_id ';
     end;

     if isFindGroup then begin
        addstr11:=' Upper(ng.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindGroup+'%'))+' ';
     end;

     if (isFindNum and isFindName)or
        (isFindNum and isFindFullName)or
        (isFindNum and isFindArticle)or
        (isFindNum and isFindOKDP)or
        (isFindNum and isFindViewOfGoods)or
        (isFindNum and isFindTypeOfGoods)or
        (isFindNum and isFindGtd)or
        (isFindNum and isFindCountry)or
        (isFindNum and isFindByGroup)or
        (isFindNum and isFindGroup) then
      and1:=' and ';

     if (isFindName and isFindFullName)or
        (isFindName and isFindArticle)or
        (isFindName and isFindOKDP)or
        (isFindName and isFindViewOfGoods)or
        (isFindName and isFindTypeOfGoods)or
        (isFindName and isFindGtd)or
        (isFindName and isFindCountry)or
        (isFindName and isFindByGroup)or
        (isFindName and isFindGroup) then
      and2:=' and ';

     if (isFindFullName and isFindArticle)or
        (isFindFullName and isFindOKDP)or
        (isFindFullName and isFindViewOfGoods)or
        (isFindFullName and isFindTypeOfGoods)or
        (isFindFullName and isFindGtd)or
        (isFindFullName and isFindCountry)or
        (isFindFullName and isFindByGroup)or
        (isFindFullName and isFindGroup) then
      and3:=' and ';

     if (isFindArticle and isFindOKDP)or
        (isFindArticle and isFindViewOfGoods)or
        (isFindArticle and isFindTypeOfGoods)or
        (isFindArticle and isFindGtd)or
        (isFindArticle and isFindCountry)or
        (isFindArticle and isFindByGroup)or
        (isFindArticle and isFindGroup) then
      and4:=' and ';

     if (isFindOKDP and isFindViewOfGoods)or
        (isFindOKDP and isFindTypeOfGoods)or
        (isFindOKDP and isFindGtd)or
        (isFindOKDP and isFindCountry)or
        (isFindOKDP and isFindByGroup)or
        (isFindOKDP and isFindGroup) then
      and5:=' and ';

     if (isFindViewOfGoods and isFindTypeOfGoods)or
        (isFindViewOfGoods and isFindGtd)or
        (isFindViewOfGoods and isFindCountry)or
        (isFindViewOfGoods and isFindByGroup)or
        (isFindViewOfGoods and isFindGroup) then
      and6:=' and ';

     if (isFindTypeOfGoods and isFindGtd)or
        (isFindTypeOfGoods and isFindCountry)or
        (isFindTypeOfGoods and isFindByGroup)or
        (isFindTypeOfGoods and isFindGroup) then
      and7:=' and ';

     if (isFindGtd and isFindCountry)or
        (isFindGtd and isFindByGroup)or
        (isFindGtd and isFindGroup) then
      and8:=' and ';

     if (isFindCountry and isFindByGroup)or
        (isFindCountry and isFindGroup) then
      and9:=' and ';

     if (isFindByGroup and isFindGroup) then
      and10:=' and ';

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

procedure TfmRBNomenclature.ShowingChanged;
begin
  inherited;
end;

procedure TfmRBNomenclature.TreeViewClick(Sender: TObject);
begin
end;

procedure TfmRBNomenclature.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
var
  TPRBI: TParamRBookInterface;
  id: Variant;
begin
  _OnVisibleInterface(hInterface,true);
  FhInterface:=hInterface;
  ViewSelect:=false;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  SQLString:=Param.SQL.Select;
  if Trim(LastOrderStr)='' then  LastOrderStr:=LastOrderStr;
  TreeView.DataSource:=nil;
  ActiveQueryTreeView;
  ActiveQuery(true);
  ActiveQueryDetail(true);
  qrGroup.AfterScroll:=nil;
  FormStyle:=fsMDIChild;
  TreeView.DataSource:=dsGroup;
  TreeView.FullCollapse;
  LocateToFirstNode;

  if Param.Locate.KeyFields<>nil then begin
   id:=GetLocateValueByName(Param,'nomenclature_id');
   if id<>Null then begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' nomenclature_id='+inttostr(id)+' ');
    if _ViewInterfaceFromName(NameRbkNomenclature,@TPRBI) then begin
     if ifExistsDataInParamRBookInterface(@TPRBI) then begin
      qrGroup.locate(TreeView.KeyField,GetFirstValueFromParamRBookInterface(@TPRBI,'nomenclaturegroup_id'),[loCaseInsensitive]);
      Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
     end;
    end;
   end else Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
  end;

  if WindowState=wsMinimized then begin
  WindowState:=wsNormal;
  end;
  qrGroup.AfterScroll:=qrGroupAfterScroll;
  qrGroupAfterScroll(nil);
  BringToFront;
  Show;
  SetImageToTreeNodesByTreeView(TreeView);
  TreeView.Invalidate;
end;

procedure TfmRBNomenclature.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
var
  TPRBI: TParamRBookInterface;
  id: Variant;
begin
  FhInterface:=hInterface;
  bibClose.Cancel:=true;
  bibOk.OnClick:=MR;
  bibClose.Caption:=CaptionCancel;
  bibOk.Visible:=true;
  Grid.OnDblClick:=MR;
  pnDetail.Visible:=not ViewSelect;
  splDetail.Visible:=pnDetail.Visible;
  Grid.MultiSelect:=Param.Visual.MultiSelect;
  BorderIcons:=BorderIcons-[biMinimize];
  WindowState:=wsNormal;
  WhereString:=PrepearWhereString(Param.Condition.WhereStr);
  LastOrderStr:=PrepearOrderString(Param.Condition.OrderStr);
  SQLString:=Param.SQL.Select;
  if Trim(LastOrderStr)='' then  LastOrderStr:=LastOrderStr;
  TreeView.DataSource:=nil;
  ActiveQueryTreeView;
  ActiveQuery(true);
  ActiveQueryDetail(true);
  qrGroup.AfterScroll:=nil;
  TreeView.DataSource:=dsGroup;
  TreeView.FullCollapse;
  LocateToFirstNode;

  if Param.Locate.KeyFields<>nil then begin
   id:=GetLocateValueByName(Param,'nomenclature_id');
   if id<>Null then begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' nomenclature_id='+inttostr(id)+' ');
    if _ViewInterfaceFromName(NameRbkNomenclature,@TPRBI) then begin
     if ifExistsDataInParamRBookInterface(@TPRBI) then begin
      qrGroup.locate(TreeView.KeyField,GetFirstValueFromParamRBookInterface(@TPRBI,'nomenclaturegroup_id'),[loCaseInsensitive]);
      Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
     end;
    end;
   end else Locate(Param.Locate.KeyFields,Param.Locate.KeyValues,Param.Locate.Options);
  end;
  
  qrGroup.AfterScroll:=qrGroupAfterScroll;
  qrGroupAfterScroll(nil);
  SetImageToTreeNodesByTreeView(TreeView);
  TreeView.Invalidate;
end;

procedure TfmRBNomenclature.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
end;

procedure TfmRBNomenclature.qrGroupAfterScroll(DataSet: TDataSet);
begin
  ViewCount;
end;

procedure TfmRBNomenclature.MainqrCalcFields(DataSet: TDataSet);
begin
  DataSet['viewofgoodsplus']:=GetViewOfGoodsByValue(DataSet.fieldbyName('viewofgoods').AsInteger);
  DataSet['typeofgoodsplus']:=GetTypeOfGoodsByValue(DataSet.fieldbyName('typeofgoods').AsInteger);
  DataSet['ndsrateplus']:=DataSet.fieldbyName('ndsrate').AsString+'%';
  DataSet['nprateplus']:=DataSet.fieldbyName('nprate').AsString+'%';
end;

procedure TfmRBNomenclature.GridDetailOnDblClick(Sender: TObject);
begin
  if not qrDetail.Active then exit;
  if qrDetail.RecordCount=0 then exit;
  bibChangeDetail.Click;
end;

procedure TfmRBNomenclature.bibAdjustDetailClick(Sender: TObject);
begin
  SetAdjust(GridDetail.Columns,nil);
end;

procedure TfmRBNomenclature.bibAddDetailPropertiesOnClick(Sender: TObject);
var
  fm: TfmEditRBNomenclatureProperties;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBNomenclatureProperties.Create(nil);
  try
    fm.fmParent:=Self;
    fm.ActiveControl:=fm.bibValueProperties;
    fm.nomenclature_id:=MainQr.FieldByName('nomenclature_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('nomenclature_id;valueproperties_id',
                      VarArrayOf([fm.nomenclature_id,fm.valueproperties_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibChangeDetailPropertiesOnClick(Sender: TObject);
var
  fm: TfmEditRBNomenclatureProperties;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  if qrDetail.isEmpty then exit;
  fm:=TfmEditRBNomenclatureProperties.Create(nil);
  try
    fm.fmParent:=Self;
    fm.ActiveControl:=fm.bibValueProperties;
    fm.nomenclature_id:=qrDetail.FieldByName('nomenclature_id').AsInteger;
    fm.valueproperties_id:=qrDetail.FieldByName('valueproperties_id').AsInteger;
    fm.oldvalueproperties_id:=fm.valueproperties_id;
    fm.edNameProperties.Text:=qrDetail.FieldByName('nameproperties').AsString;
    fm.edValueProperties.Text:=qrDetail.FieldByName('valueproperties').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('nomenclature_id;valueproperties_id',
                      VarArrayOf([fm.nomenclature_id,fm.valueproperties_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibDelDetailPropertiesOnClick(Sender: TObject);
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
     sqls:='Delete from '+tbNomenclatureValueProperties+' where nomenclature_id='+qrdetail.FieldByName('nomenclature_id').asString+
           ' and valueproperties_id='+qrdetail.FieldByName('valueproperties_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     updDetail.DeleteSQL.Clear;
     updDetail.DeleteSQL.Add(sqls);
     qrDetail.Delete;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
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
  but:=DeleteWarningEx('значение <'+qrdetail.FieldByName('valueproperties').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBNomenclature.GridDetailPropertiesOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
   id1:=qrDetail.fieldByName('nomenclature_id').asString;
   id2:=qrDetail.fieldByName('valueproperties_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('nomenclature_id;valueproperties_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.bibAddDetailUnitsOnClick(Sender: TObject);
var
  fm: TfmEditRBNomenclatureUnitOfMeasure;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBNomenclatureUnitOfMeasure.Create(nil);
  try
    fm.fmParent:=Self;
    fm.ActiveControl:=fm.bibUnit;
    fm.nomenclature_id:=MainQr.FieldByName('nomenclature_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('nomenclature_id;unitofmeasure_id',
                      VarArrayOf([fm.nomenclature_id,fm.unitofmeasure_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibChangeDetailUnitsOnClick(Sender: TObject);
var
  fm: TfmEditRBNomenclatureUnitOfMeasure;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  if qrDetail.isEmpty then exit;
  fm:=TfmEditRBNomenclatureUnitOfMeasure.Create(nil);
  try
    fm.fmParent:=Self;
    fm.ActiveControl:=fm.bibUnit;
    fm.nomenclature_id:=qrDetail.FieldByName('nomenclature_id').AsInteger;
    fm.unitofmeasure_id:=qrDetail.FieldByName('unitofmeasure_id').AsInteger;
    fm.oldunitofmeasure_id:=fm.unitofmeasure_id;
    fm.edUnit.Text:=qrDetail.FieldByName('unitofmeasurename').AsString;
    fm.chbIsBaseUnit.Checked:=Boolean(qrDetail.FieldByName('isbaseunit').AsInteger);
    fm.edCode.Text:=qrDetail.FieldByName('code').AsString;
    fm.edWeigth.Text:=qrDetail.FieldByName('weigth').AsString;
    fm.edCalcFactor.Text:=qrDetail.FieldByName('calcfactor').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('nomenclature_id;unitofmeasure_id',
                      VarArrayOf([fm.nomenclature_id,fm.unitofmeasure_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibDelDetailUnitsOnClick(Sender: TObject);
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
     sqls:='Delete from '+tbNomenclatureUnitOfMeasure+' where nomenclature_id='+qrdetail.FieldByName('nomenclature_id').asString+
           ' and unitofmeasure_id='+qrdetail.FieldByName('unitofmeasure_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     updDetail.DeleteSQL.Clear;
     updDetail.DeleteSQL.Add(sqls);
     qrDetail.Delete;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
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
  but:=DeleteWarningEx('единицу измерения <'+qrdetail.FieldByName('unitofmeasurename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBNomenclature.GridDetailUnitsOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('unitofmeasurename') then fn:='um.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('isbaseunitplus') then fn:='isbaseunit';
   id1:=qrDetail.fieldByName('nomenclature_id').asString;
   id2:=qrDetail.fieldByName('unitofmeasure_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('nomenclature_id;unitofmeasure_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.GridDetailUnitsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;
begin
  if not qrDetail.Active then exit;
  if qrDetail.isEmpty then exit;
  rt.Right:=rect.Right;
  rt.Left:=rect.Left;
  rt.Top:=rect.Top+2;
  rt.Bottom:=rect.Bottom-2;
  if Column.Title.Caption='Это базовая единица' then begin
    chk:=Boolean(qrDetail.FieldByName('isbaseunit').AsInteger);
    if not chk then Begin
     DrawFrameControl(GridDetail.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(GridDetail.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;

procedure TfmRBNomenclature.chbNoTreeViewClick(Sender: TObject);
begin
  if chbNoTreeView.Checked then begin
    splGroup.Visible:=false;
    pnGroup.Visible:=false;
    TreeViewOnEnter(Grid);
    ActiveQuery(false);
  end else begin
    splGroup.Visible:=true;
    pnGroup.Visible:=true;
    FindGroup:='';
    ActiveQuery(false);
  end;
end;

procedure TfmRBNomenclature.TreeViewOnEnter(Sender: TObject);
begin
  if Sender=Grid then begin
    DBNav.DataSource:=ds;
    TVNavigator.Visible:=false;
    DBNav.Visible:=true;
  end;
  if Sender=GridDetail then begin
    DBNav.DataSource:=dsDetail;
    TVNavigator.Visible:=false;
    DBNav.Visible:=true;
  end;
  if Sender=TreeView then begin
    DBNav.Visible:=false;
    TVNavigator.TreeView:=TreeView;
    TVNavigator.Visible:=true;
  end;
end;

procedure TfmRBNomenclature.bibAddDetailTypeOfPriceOnClick(Sender: TObject);
var
  fm: TfmEditRBNomenclatureTypeOfPrice;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  fm:=TfmEditRBNomenclatureTypeOfPrice.Create(nil);
  try
    fm.fmParent:=Self;
    fm.ActiveControl:=fm.bibTypeOfPrice;
    fm.nomenclature_id:=MainQr.FieldByName('nomenclature_id').AsInteger;
    fm.SetDefaultCurrency;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('nomenclature_id;typeofprice_id',
                      VarArrayOf([fm.nomenclature_id,fm.typeofprice_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibChangeDetailTypeOfPriceOnClick(Sender: TObject);
var
  fm: TfmEditRBNomenclatureTypeOfPrice;
begin
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  if not qrDetail.Active then exit;
  if qrDetail.isEmpty then exit;
  fm:=TfmEditRBNomenclatureTypeOfPrice.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.ActiveControl:=fm.bibTypeOfPrice;
    fm.nomenclature_id:=qrDetail.FieldByName('nomenclature_id').AsInteger;
    fm.typeofprice_id:=qrDetail.FieldByName('typeofprice_id').AsInteger;
    fm.oldtypeofprice_id:=fm.typeofprice_id;
    fm.edTypeOfPrice.Text:=qrDetail.FieldByName('typeofpricename').AsString;
    fm.unitofmeasure_id:=qrDetail.FieldByName('unitofmeasure_id').AsInteger;
    fm.edUnit.Text:=qrDetail.FieldByName('unitofmeasurename').AsString;
    fm.currency_id:=qrDetail.FieldByName('currency_id').AsInteger;
    fm.edCurrency.Text:=qrDetail.FieldByName('currencyname').AsString;
    fm.edPay.Text:=qrDetail.FieldByName('pay').AsString;
    fm.edPrice.Text:=qrDetail.FieldByName('price').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     qrDetail.Locate('nomenclature_id;typeofprice_id',
                      VarArrayOf([fm.nomenclature_id,fm.typeofprice_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBNomenclature.bibDelDetailTypeOfPriceOnClick(Sender: TObject);
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
     sqls:='Delete from '+tbNomenclatureTypeOfPrice+' where nomenclature_id='+qrdetail.FieldByName('nomenclature_id').asString+
           ' and typeofprice_id='+qrdetail.FieldByName('typeofprice_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     updDetail.DeleteSQL.Clear;
     updDetail.DeleteSQL.Add(sqls);
     qrDetail.Delete;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
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
  but:=DeleteWarningEx('тип цены <'+qrdetail.FieldByName('typeofpricename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBNomenclature.GridDetailTypeOfPriceOnTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrDetail.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('typeofpricename') then fn:='tp.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('unitofmeasurename') then fn:='um.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('currencyname') then fn:='c.name';
   id1:=qrDetail.fieldByName('nomenclature_id').asString;
   id2:=qrDetail.fieldByName('typeofprice_id').asString;
   case TypeSort of
     tcsNone: LastOrderDetail:='';
     tcsAsc: LastOrderDetail:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderDetail:=' Order by '+fn+' desc ';
   end;
   ActiveQueryDetail(false);
   qrDetail.First;
   qrDetail.Locate('nomenclature_id;typeofprice_id',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBNomenclature.tcDetailChange(Sender: TObject);
begin
  if tcDetail.TabIndex<>-1 then
    ActiveQueryDetail(true);
end;

end.
