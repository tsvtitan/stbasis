unit UOTSalary;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, Grids, ComCtrls, tsvDbGrid, IB,
  Menus, Mask, ToolEdit, CurrEdit, IBUpdateSQL;

type
   TfmOTSalary = class(TfmRBMainGrid)
    splTop: TSplitter;
    grbEmpPlant: TGroupBox;
    pnGridEmpPlant: TPanel;
    pnButEmpPlant: TPanel;
    bibEmpPlantRefresh: TBitBtn;
    bibEmpPlantView: TBitBtn;
    bibEmpPlantAdjust: TBitBtn;
    grbEmp: TGroupBox;
    pnGridEmp: TPanel;
    pnButEmp: TPanel;
    bibEmpRefresh: TBitBtn;
    bibEmpView: TBitBtn;
    bibEmpFilter: TBitBtn;
    bibEmpAdjust: TBitBtn;
    Splitter1: TSplitter;
    grbSalary: TGroupBox;
    pnGridSalary: TPanel;
    pnButSalary: TPanel;
    bibCalcItogy: TBitBtn;
    BitBtn12: TBitBtn;
    ibtranEmpPlant: TIBTransaction;
    qrEmpPlant: TIBQuery;
    dsEmpPlant: TDataSource;
    ibtranChargeOn: TIBTransaction;
    dsChargeEmpPlantOn: TDataSource;
    PC2: TPageControl;
    TSChargeOn: TTabSheet;
    TSChargeOff: TTabSheet;
    TSChargeConst: TTabSheet;
    BitBtn9: TBitBtn;
    qrChargeOn: TIBQuery;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    bibDelete: TBitBtn;
    ibtranChargeOff: TIBTransaction;
    qrChargeOff: TIBQuery;
    dsChargeEmpPlantOff: TDataSource;
    ibtranChargeConst: TIBTransaction;
    qrChargeConst: TIBQuery;
    dsChargeEmpPlantConst: TDataSource;
    Label2: TLabel;
    edCalcPeriod: TEdit;
    bibCalcPeriod: TBitBtn;
    bibCurCalcPeriod: TBitBtn;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    cedSummaOn: TCurrencyEdit;
    cedSummaOff: TCurrencyEdit;
    cedItog: TCurrencyEdit;
    Label5: TLabel;
    TabSheet1: TTabSheet;
    Label6: TLabel;
    cedOklad: TCurrencyEdit;
    Label7: TLabel;
    CurrencyEdit4: TCurrencyEdit;
    Label8: TLabel;
    cePrivelege: TCurrencyEdit;
    Label9: TLabel;
    cedNorma: TCurrencyEdit;
    Label10: TLabel;
    cedFact: TCurrencyEdit;
    ibtUpdate: TIBTransaction;
    UpdateQr: TIBQuery;
    qrChargeSumm: TIBQuery;
    qrCharge: TIBQuery;
    ibtranCharge: TIBTransaction;
    Button1: TButton;
    qrPrivelege: TIBQuery;
    ibtranPrivelege: TIBTransaction;
    ibtranPrivelege1: TIBTransaction;
    qrPrivelege1: TIBQuery;
    ceNormDay: TCurrencyEdit;
    ceFactDay: TCurrencyEdit;
    ceNormNight: TCurrencyEdit;
    ceFactNight: TCurrencyEdit;
    ceNormEvening: TCurrencyEdit;
    ceFactEvening: TCurrencyEdit;
    Label12: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    IBTranYearSumm: TIBTransaction;
    Button2: TButton;
    qrYearSumm: TIBQuery;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure bibAdjustClick(Sender: TObject);
    procedure bibEmpPlantAdjustClick(Sender: TObject);
    procedure bibEmpPlantRefreshClick(Sender: TObject);
    procedure bibEmpPlantViewClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure qrEmpPlantAfterScroll(DataSet: TDataSet);
    procedure bibCalcPeriodClick(Sender: TObject);
    procedure bibCurCalcPeriodClick(Sender: TObject);
    procedure edCalcPeriodChange(Sender: TObject);
    procedure bibDeleteClick(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure bibCalcItogyClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private

    isFindFName,isFindName,isFindSName,isFindSex,
    isFindFamilyStateName,isFindNationName,isFindTownName,
    isFindInn,isFindCountryName,isFindRegionName,isFindStateName,
    isFindPlaceMentName: Boolean;
    FindFName,FindName,FindSName,FindInn,
    FindFamilyStateName,FindNationName,FindTownName,FindPlaceMentName,
    FindCountryName,FindRegionName,FindStateName: String;
    FindSex: string;


    LastOrderStrEmpPlant: string;
    LastOrderStrEmpPlantChargeOn: string;
    LastOrderStrEmpPlantChargeOff: string;
    LastOrderStrEmpPlantChargeConst: string;


    procedure GridTitleClickEmpPlant(Column: TColumn);
    procedure GridTitleClickEmpPlantChargeOn(Column: TColumn);
    procedure GridTitleClickEmpPlantChargeOff(Column: TColumn);
    procedure GridTitleClickEmpPlantChargeConst(Column: TColumn);
    procedure GridDblClickEmpPlant(Sender: TObject);
    procedure GridDblClickEmpPlantChargeOn(Sender: TObject);
    procedure GridDblClickEmpPlantChargeOff(Sender: TObject);
    procedure GridDblClickEmpPlantChargeConst(Sender: TObject);


  protected
    PointClicked: TPoint;
    FoldPosX, FoldPosY: Integer;
    GridEmpPlant: TNewDbGrid;
    GridEmpPlantChargeOn: TNewDbGrid;
    GridEmpPlantChargeOff: TNewDbGrid;
    GridEmpPlantChargeConst: TNewDbGrid;

    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
    function CheckPermission: Boolean; override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    procedure SetImageFilter(FilterOn: Boolean);override;
    function GetFilterString: string;
    procedure SaveGridProperty(Grid: TNewDbGrid);
    procedure LoadGridProperty(Grid: TNewDbGrid);

  public
    NeedReCalc:Boolean;
    ChargeFlag:Integer; //Храню вид добавление записи (0 - нач. 1 - удер. 2- постоян. 3 - резерв)
    CurCalcPeriod_id:Integer; //Храню ид текущего (реального) периода
    calcperiod_id:Integer; //Храню ид выбранного (нереального - архивного) периода
    changeFlag :Boolean;
    StatuscurPeriod:Integer;

    id: Integer;
    mrot: Double;
    oklad: Double;
    //    ChargeFlag: Integer;
//    CalcPeriod_id: Integer;
    correctperiod_id: Integer;
    empplant_id: Integer;
    Charge_id: Integer;
    percent:Double;
    hours:Double;
    days:Double;
    summa:Double;
    itemcreatedate:Tdate;
    creatoremp_id : Integer;
    itemmodifydate:Tdate;
    modificatoremp_id: Integer;
    algorithm_id: Integer;
    typebaseamount: Integer;
           typepercent: Integer;
           typemultiply: Integer;
           typefactorworktime: Integer;
    statuscalcperiod: Integer;
    schedule_id: Integer;
    category: Integer;
   NormaDay:Double;
   NormaEvening:Double;
   NormaNight:Double;
   Norma:Double;
   Fact:Double;
   FactDay:Double;
   FactEvening:Double;
   FactNight:Double;
setka:Integer;
shift_id:Integer;
net_id:Integer;
k_oplaty:Double;
   Privilegent:Double;
   Dependent:Double;
summ:Double;
 calcstartdate:TdateTime; //Число начала рассчета
 calcenddate:TdateTime; //Число конца рассчета
percentnalog:Double;
OldYearSumm:Currency;

    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure ActiveEmpPlant(CheckPerm: Boolean);
    procedure ActiveEmpPlantChargeOn(CheckPerm: Boolean);
    procedure ActiveEmpPlantChargeOff(CheckPerm: Boolean);
    procedure ActiveEmpPlantChargeConst(CheckPerm: Boolean);
    procedure ActivePrivelege(CheckPerm: Boolean);
  end;

var
  fmOTSalary: TfmOTSalary;

implementation

uses UMainUnited, USalaryVAVCode, USalaryVAVDM, USalaryVAVData, UAdjust,
      UEditRBAddCharge, UTreeBuilding, UEditRBAddConstCharge,
  USalaryVAVOptions,stcalendarutil, URBPrivilege, UEditRBPrivilege , StSalaryKit;

{$R *.DFM}
//---------------------------------------------------------------------------
procedure TfmOTSalary.SaveGridProperty(Grid: TNewDbGrid);
begin
 if Grid=nil then exit;
 try
   SaveGridProp(Grid.Name,TDbGrid(Grid));
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.LoadGridProperty(Grid: TNewDbGrid);
begin
 if Grid=nil then exit;
 try
   LoadGridProp(Grid.name,TDbGrid(Grid));
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
//  InitCalendarUtil(IBDB);
  ibtranCharge.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranCharge);
  qrCharge.Database:=IBDB;

  Caption:=NameSalary;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

//  edSearch.TabOrder:=1;
  grid.parent:=pnGridEmp;
  grid.OnDblClick:=gridDblClick;
  grid.TabOrder:=1;
  pnBut.TabOrder:=3;

   cl:=Grid.Columns.Add;
   cl.FieldName:='tabnum';
   cl.Title.Caption:='Табельный номер';
   cl.Width:=80;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fname';
  cl.Title.Caption:='Фамилия';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Имя';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sname';
  cl.Title.Caption:='Отчество';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sexshortname';
  cl.Title.Caption:='Пол';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='birthdate';
  cl.Title.Caption:='Дата рождения';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='perscardnum';
  cl.Title.Caption:='Номер личной карточки';
  cl.Width:=80;

  cl:=Grid.Columns.Add;
  cl.FieldName:='continioussenioritydate';
  cl.Title.Caption:='Непрерывный стаж';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='familystatename';
  cl.Title.Caption:='Семейное положение';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='nationname';
  cl.Title.Caption:='Национальность';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='countryname';
  cl.Title.Caption:='Страна';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='regionname';
  cl.Title.Caption:='Край, область';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='statename';
  cl.Title.Caption:='Район';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='townname';
  cl.Title.Caption:='Город';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='placementname';
  cl.Title.Caption:='Нас. пункт';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='inn';
  cl.Title.Caption:='ИНН';
  cl.Width:=80;

  ibtranEmpPlant.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpPlant);
  qrEmpPlant.Database:=IBDB;

  GridEmpPlant:=TNewdbGrid.Create(self);
  GridEmpPlant.Parent:=pnGridEmpPlant;
  GridEmpPlant.Align:=alClient;
  GridEmpPlant.DataSource:=dsEmpPlant;
  GridEmpPlant.Name:='GridEmpPlant';
  GridEmpPlant.RowSelected.Visible:=true;
  AssignFont(_GetOptions.RBTableFont,GridEmpPlant.Font);
  GridEmpPlant.TitleFont.Assign(GridEmpPlant.Font);
  GridEmpPlant.RowSelected.Font.Assign(GridEmpPlant.Font);
  GridEmpPlant.RowSelected.Brush.Style:=bsClear;
  GridEmpPlant.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpPlant.RowSelected.Font.Color:=clWhite;
  GridEmpPlant.RowSelected.Pen.Style:=psClear;
  GridEmpPlant.CellSelected.Visible:=true;
  GridEmpPlant.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpPlant.CellSelected.Font.Assign(GridEmpPlant.Font);
  GridEmpPlant.CellSelected.Font.Color:=clHighlightText;
  GridEmpPlant.TitleCellMouseDown.Font.Assign(GridEmpPlant.Font);
  GridEmpPlant.Options:=GridEmpPlant.Options-[dgEditing]-[dgTabs];
  GridEmpPlant.ReadOnly:=true;
  GridEmpPlant.OnKeyDown:=FormKeyDown;
  GridEmpPlant.OnTitleClick:=GridTitleClickEmpPlant;
  GridEmpPlant.OnDblClick:=GridDblClickEmpPlant;
  GridEmpPlant.TabOrder:=101;
  pnButEmpPlant.TabOrder:=102;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Где работает';
  cl.Width:=150;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='netname';
  cl.Title.Caption:='Сетка';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='classnum';
  cl.Title.Caption:='Разряд';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='reasondocumnum';
  cl.Title.Caption:='На основании приказа';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='categoryname';
  cl.Title.Caption:='Категория';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='seatname';
  cl.Title.Caption:='Должность';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='departname';
  cl.Title.Caption:='Отдел';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='orderdocumnum';
  cl.Title.Caption:='Приказ о принятии';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='profname';
  cl.Title.Caption:='Профессия';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата поступления на работу';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='motivedocumnum';
  cl.Title.Caption:='Уволен по документу';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='motivename';
  cl.Title.Caption:='Причина уволнения';
  cl.Width:=100;

  cl:=GridEmpPlant.Columns.Add;
  cl.FieldName:='releasedate';
  cl.Title.Caption:='Дата увольнения';
  cl.Width:=100;

  LastOrderStrEmpPlant:=' order by p.smallname ';


  ibtranChargeOn.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranChargeOn);
  qrChargeOn.Database:=IBDB;
//  qrChargeOn.Transaction:=ibtranChargeOn;  

  GridEmpPlantChargeOn:=TNewdbGrid.Create(self);
  GridEmpPlantChargeOn.Parent:=TSChargeOn;
  GridEmpPlantChargeOn.Align:=alClient;
  GridEmpPlantChargeOn.DataSource:=dsChargeEmpPlantOn;
  GridEmpPlantChargeOn.Name:='GridEmpPlantChargeOn';
  GridEmpPlantChargeOn.RowSelected.Visible:=true;
  AssignFont(_GetOptions.RBTableFont,GridEmpPlantChargeOn.Font);
  GridEmpPlantChargeOn.TitleFont.Assign(GridEmpPlantChargeOn.Font);
  GridEmpPlantChargeOn.RowSelected.Font.Assign(GridEmpPlantChargeOn.Font);
  GridEmpPlantChargeOn.RowSelected.Brush.Style:=bsClear;
  GridEmpPlantChargeOn.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpPlantChargeOn.RowSelected.Font.Color:=clWhite;
  GridEmpPlantChargeOn.RowSelected.Pen.Style:=psClear;
  GridEmpPlantChargeOn.CellSelected.Visible:=true;
  GridEmpPlantChargeOn.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpPlantChargeOn.CellSelected.Font.Assign(GridEmpPlantChargeOn.Font);
  GridEmpPlantChargeOn.CellSelected.Font.Color:=clHighlightText;
  GridEmpPlantChargeOn.TitleCellMouseDown.Font.Assign(GridEmpPlantChargeOn.Font);
  GridEmpPlantChargeOn.Options:=GridEmpPlantChargeOn.Options-[dgEditing]-[dgTabs];
  GridEmpPlantChargeOn.ReadOnly:=true;
  GridEmpPlantChargeOn.OnKeyDown:=FormKeyDown;
  GridEmpPlantChargeOn.OnTitleClick:=GridTitleClickEmpPlantChargeOn;
  GridEmpPlantChargeOn.OnDblClick:=GridDblClickEmpPlantChargeOn;
  GridEmpPlantChargeOn.TabOrder:=101;
  pnButSalary.TabOrder:=102;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='calcperiod';
  cl.Title.Caption:='Рассчетный период';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='correctperiod';
  cl.Title.Caption:='Период корректировки';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='chargeshortname';
  cl.Title.Caption:='Вид начисления';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='basesumm';
  cl.Title.Caption:='Базовая сумма';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='days';
  cl.Title.Caption:='Дни';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='hours';
  cl.Title.Caption:='Часы';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Процент';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOn.Columns.Add;
  cl.FieldName:='summa';
  cl.Title.Caption:='Сумма';
  cl.Width:=100;


//  LastOrderStrEmpPlantChargeOn:='  order by p.salary_id ';

  ibtranChargeOff.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranChargeOff);
  qrChargeOff.Database:=IBDB;



//  qrChargeOff.Transaction:=ibtranChargeOff;

  GridEmpPlantChargeOff:=TNewdbGrid.Create(self);
  GridEmpPlantChargeOff.Parent:=TSChargeOff;
  //GridEmpPlantChargeOff.Parent:=pnGridEmpPlantChargeOff;
  GridEmpPlantChargeOff.Align:=alClient;
  GridEmpPlantChargeOff.DataSource:=dsChargeEmpPlantOff;
  GridEmpPlantChargeOff.Name:='GridEmpPlantChargeOff';
  GridEmpPlantChargeOff.RowSelected.Visible:=true;
  AssignFont(_GetOptions.RBTableFont,GridEmpPlantChargeOff.Font);
  GridEmpPlantChargeOff.TitleFont.Assign(GridEmpPlantChargeOff.Font);
  GridEmpPlantChargeOff.RowSelected.Font.Assign(GridEmpPlantChargeOff.Font);
  GridEmpPlantChargeOff.RowSelected.Brush.Style:=bsClear;
  GridEmpPlantChargeOff.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpPlantChargeOff.RowSelected.Font.Color:=clWhite;
  GridEmpPlantChargeOff.RowSelected.Pen.Style:=psClear;
  GridEmpPlantChargeOff.CellSelected.Visible:=true;
  GridEmpPlantChargeOff.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpPlantChargeOff.CellSelected.Font.Assign(GridEmpPlantChargeOff.Font);
  GridEmpPlantChargeOff.CellSelected.Font.Color:=clHighlightText;
  GridEmpPlantChargeOff.TitleCellMouseDown.Font.Assign(GridEmpPlantChargeOff.Font);
  GridEmpPlantChargeOff.Options:=GridEmpPlantChargeOff.Options-[dgEditing]-[dgTabs];
  GridEmpPlantChargeOff.ReadOnly:=true;
  GridEmpPlantChargeOff.OnKeyDown:=FormKeyDown;
  GridEmpPlantChargeOff.OnTitleClick:=GridTitleClickEmpPlantChargeOff;
  GridEmpPlantChargeOff.OnDblClick:=GridDblClickEmpPlantChargeOff;
  GridEmpPlantChargeOff.TabOrder:=101;
  pnButSalary.TabOrder:=102;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='calcperiod';
  cl.Title.Caption:='Рассчетный период';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='correctperiod';
  cl.Title.Caption:='Период корректировки';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='chargeshortname';
  cl.Title.Caption:='Вид начисления';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='basesumm';
  cl.Title.Caption:='Базовая сумма';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='days';
  cl.Title.Caption:='Дни';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='hours';
  cl.Title.Caption:='Часы';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Процент';
  cl.Width:=100;

  cl:=GridEmpPlantChargeOff.Columns.Add;
  cl.FieldName:='summa';
  cl.Title.Caption:='Сумма';
  cl.Width:=100;
//  LastOrderStrEmpPlantChargeOn:=' order by p.salary_id ';



  ibtranChargeConst.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranChargeConst);
  qrChargeConst.Database:=IBDB;

  GridEmpPlantChargeConst:=TNewdbGrid.Create(self);
  GridEmpPlantChargeConst.Parent:=TSChargeConst;
  GridEmpPlantChargeConst.Align:=alClient;
  GridEmpPlantChargeConst.DataSource:=dsChargeEmpPlantConst;
  GridEmpPlantChargeConst.Name:='GridEmpPlantChargeConst';
  GridEmpPlantChargeConst.RowSelected.Visible:=true;
  AssignFont(_GetOptions.RBTableFont,GridEmpPlantChargeConst.Font);
  GridEmpPlantChargeConst.TitleFont.Assign(GridEmpPlantChargeConst.Font);
  GridEmpPlantChargeConst.RowSelected.Font.Assign(GridEmpPlantChargeConst.Font);
  GridEmpPlantChargeConst.RowSelected.Brush.Style:=bsClear;
  GridEmpPlantChargeConst.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpPlantChargeConst.RowSelected.Font.Color:=clWhite;
  GridEmpPlantChargeConst.RowSelected.Pen.Style:=psClear;
  GridEmpPlantChargeConst.CellSelected.Visible:=true;
  GridEmpPlantChargeConst.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpPlantChargeConst.CellSelected.Font.Assign(GridEmpPlantChargeConst.Font);
  GridEmpPlantChargeConst.CellSelected.Font.Color:=clHighlightText;
  GridEmpPlantChargeConst.TitleCellMouseDown.Font.Assign(GridEmpPlantChargeConst.Font);
  GridEmpPlantChargeConst.Options:=GridEmpPlantChargeConst.Options-[dgEditing]-[dgTabs];
  GridEmpPlantChargeConst.ReadOnly:=true;
  GridEmpPlantChargeConst.OnKeyDown:=FormKeyDown;
  GridEmpPlantChargeConst.OnTitleClick:=GridTitleClickEmpPlantChargeConst;
  GridEmpPlantChargeConst.OnDblClick:=GridDblClickEmpPlantChargeConst;
  GridEmpPlantChargeConst.TabOrder:=101;
  pnButSalary.TabOrder:=102;

  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='chargeshortname';
  cl.Title.Caption:='Вид начисления';
  cl.Width:=100;

{  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='days';
  cl.Title.Caption:='Дни';
  cl.Width:=100;

  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='hours';
  cl.Title.Caption:='Часы';
  cl.Width:=100;
 }
  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Процент';
  cl.Width:=100;

  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='summa';
  cl.Title.Caption:='Сумма';
  cl.Width:=100;

  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='startdate';
  cl.Title.Caption:='Дата начала';
  cl.Width:=100;

  cl:=GridEmpPlantChargeConst.Columns.Add;
  cl.FieldName:='enddate';
  cl.Title.Caption:='Дата конца';
  cl.Width:=100;

  CurCalcPeriod_id:=GetIDCurCalcPeriod();
  bibCurCalcPeriod.Click;

  ibtranPrivelege.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranPrivelege);
  qrPrivelege.Database:=IBDB;

  ibtranPrivelege1.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranPrivelege1);
  qrPrivelege1.Database:=IBDB;

  LoadFromIni;

  calcperiod_id:=CurCalcperiod_id;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.FormDestroy(Sender: TObject);
begin
// Screen.Cursor:=crHourGlass;
 try
  inherited;
  GridEmpPlant.Free;
  GridEmpPlantChargeOn.Free;
  GridEmpPlantChargeOff.Free;
  GridEmpPlantChargeConst.Free;

  if FormState=[fsCreatedMDIChild] then
   fmOTSalary:=nil;
 finally
  //Screen.Cursor:=crDefault;
 end;
end;
//---------------------------------------------------------------------------
function TfmOTSalary.CheckPermission: Boolean;
begin
  isPerm:=_isPermission(tbEmp,SelConst)and
          _isPermission(tbFamilystate,SelConst)and
          _isPermission(tbNation,SelConst)and
          _isPermission(tbCountry,SelConst)and
          _isPermission(tbRegion,SelConst)and
          _isPermission(tbState,SelConst)and
          _isPermission(tbTown,SelConst)and
          _isPermission(tbPlaceMent,SelConst)and
          _isPermission(tbSex,SelConst);
  bibOk.Enabled:=isPerm;
  if not ViewSelect then begin
   bibAdd.Enabled:=isPerm and _isPermission(tbEmp,InsConst);
   bibChange.Enabled:=isPerm and _isPermission(tbEmp,UpdConst);
   bibDel.Enabled:=isPerm and _isPermission(tbEmp,DelConst);
   bibView.Enabled:=isPerm;
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  try
   Mainqr.Active:=false;
   if CheckPerm then
    if not CheckPermission then exit;

   Screen.Cursor:=crHourGlass;
   Mainqr.AfterScroll:=nil;
   try
    Mainqr.sql.Clear;
    sqls:='Select e.*, fs.name as familystatename, '+
         'n.name as nationname, '+
         's.shortname as sexshortname, s.name as sexname,'+
         'ct.name as countryname, ct.code as countrycode,'+
         'r.name as regionname, r.code as regioncode,'+
         'st.name as statename, st.code as statecode,'+
         't.name as townname, t.code as towncode,'+
         'pm.name as placementname, pm.code as placementcode '+
         'from '+
         tbEmp+' e join '+
         tbFamilystate+' fs on e.familystate_id=fs.familystate_id join '+
         tbNation+' n on e.nation_id=n.nation_id join '+
         tbSex+' s on e.sex_id=s.sex_id left join '+
         tbCountry+' ct on e.country_id=ct.country_id left join '+
         tbRegion+' r on e.region_id=r.region_id left join '+
         tbState+' st on e.state_id=st.state_id left join '+
         tbTown+' t on e.town_id=t.town_id left join '+
         tbPlaceMent+' pm on e.placement_id=pm.placement_id '+
         GetFilterString+LastOrderStr;
    Mainqr.sql.Add(sqls);
    Mainqr.Transaction.Active:=false;
    Mainqr.Transaction.Active:=true;
    Mainqr.Active:=true;
    SetImageFilter(isFindFName or isFindName or isFindSName or isFindSex or
                  isFindFamilyStateName or isFindNationName or isFindTownName or isFindInn or
                  isFindCountryName or isFindRegionName or isFindStateName or
                  isFindPlaceMentName);
    ViewCount;
   finally
    Mainqr.AfterScroll:=MainqrAfterScroll;
    Screen.Cursor:=crDefault;
   end;
  finally
   ActiveEmpPlant(true);
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridTitleClick(Column: TColumn);
var
  fn: string;
  id: string;
  sqls: string;
begin
 try
  if not MainQr.Active then exit;
  if MainQr.isEmpty then exit;
  Screen.Cursor:=crHourGlass;
  Mainqr.AfterScroll:=nil;
  try
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('familystatename') then fn:='fs.name';
   if UpperCase(fn)=UpperCase('nationname') then fn:='n.name';
   if UpperCase(fn)=UpperCase('countryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('regionname') then fn:='r.name';
   if UpperCase(fn)=UpperCase('statename') then fn:='st.name';
   if UpperCase(fn)=UpperCase('townname') then fn:='t.name';
   if UpperCase(fn)=UpperCase('placementname') then fn:='pm.name';
   if UpperCase(fn)=UpperCase('sexshortname') then fn:='s.shortname';
   id:=MainQr.fieldByName('emp_id').asString;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   LastOrderStr:=' Order by '+fn;
    sqls:='Select e.*, fs.name as familystatename, '+
         'n.name as nationname, '+
         's.shortname as sexshortname, s.name as sexname,'+
         'ct.name as countryname, ct.code as countrycode,'+
         'r.name as regionname, r.code as regioncode,'+
         'st.name as statename, st.code as statecode,'+
         't.name as townname, t.code as towncode,'+
         'pm.name as placementname, pm.code as placementcode '+
         'from '+
         tbEmp+' e join '+
         tbFamilystate+' fs on e.familystate_id=fs.familystate_id join '+
         tbNation+' n on e.nation_id=n.nation_id join '+
         tbSex+' s on e.sex_id=s.sex_id left join '+
         tbCountry+' ct on e.country_id=ct.country_id left join '+
         tbRegion+' r on e.region_id=r.region_id left join '+
         tbState+' st on e.state_id=st.state_id left join '+
         tbTown+' t on e.town_id=t.town_id left join '+
         tbPlaceMent+' pm on e.placement_id=pm.placement_id '+
         GetFilterString+LastOrderStr;
   MainQr.SQL.Add(sqls);
   MainQr.Transaction.Active:=false;
   MainQr.Transaction.Active:=true;
   MainQr.Active:=true;
   MainQr.Locate('emp_id',id,[loCaseInsensitive]);
  finally
    Mainqr.AfterScroll:=MainqrAfterScroll;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if MainQr.isEmpty then exit;
  bibEmpView.Click;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.LoadFromIni;
begin
 inherited;
  try
    FindFName:=ReadParam(ClassName,'Fname',FindFName);
    FindName:=ReadParam(ClassName,'Name',FindName);
    FindSName:=ReadParam(ClassName,'Sname',FindSName);
    FindSex:=ReadParam(ClassName,'Sex',FindSex);
    FindFamilyStateName:=ReadParam(ClassName,'FamilyStateName',FindFamilyStateName);
    FindNationName:=ReadParam(ClassName,'NationName',FindNationName);
    FindCountryName:=ReadParam(ClassName,'CountryName',FindCountryName);
    FindRegionName:=ReadParam(ClassName,'RegionName',FindRegionName);
    FindStateName:=ReadParam(ClassName,'StateName',FindStateName);
    FindTownName:=ReadParam(ClassName,'TownName',FindTownName);
    FindPlaceMentName:=ReadParam(ClassName,'PlaceMentName',FindPlaceMentName);
    FindInn:=ReadParam(ClassName,'Inn',FindInn);
    grbEmp.Height:=ReadParam(ClassName,grbEmp.Name,grbEmp.Height);
    grbEmpPlant.Height:=ReadParam(ClassName,grbEmpPlant.Name,grbEmpPlant.Height);
    grbSalary.Height:=ReadParam(ClassName,grbSalary.Name,grbSalary.Height);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
    LoadGridProperty(GridEmpPlant);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.SaveToIni;
begin
 inherited;
  try
    WriteParam(ClassName,'Fname',FindFName);
    WriteParam(ClassName,'Name',FindName);
    WriteParam(ClassName,'Sname',FindSName);
    WriteParam(ClassName,'Sex',FindSex);
    WriteParam(ClassName,'FamilyStateName',FindFamilyStateName);
    WriteParam(ClassName,'NationName',FindNationName);
    WriteParam(ClassName,'CountryName',FindCountryName);
    WriteParam(ClassName,'RegionName',FindRegionName);
    WriteParam(ClassName,'StateName',FindStateName);
    WriteParam(ClassName,'TownName',FindTownName);
    WriteParam(ClassName,'PlaceMentName',FindPlaceMentName);
    WriteParam(ClassName,'Inn',FindInn);
    WriteParam(ClassName,grbEmp.Name,grbEmp.Height);
    WriteParam(ClassName,grbEmpPlant.Name,grbEmpPlant.Height);
    WriteParam(ClassName,grbSalary.Name,grbSalary.Height);

    WriteParam(ClassName,'Inside',FilterInside);
    SaveGridProperty(GridEmpPlant);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.bibViewClick(Sender: TObject);
//var
//  fm: TfmEditRBEmp;
begin
{ try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBEmp.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edTabNum.Text:=Mainqr.fieldByName('tabnum').AsString;
    fm.edFName.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edSName.Text:=Mainqr.fieldByName('sname').AsString;
    fm.edSex.Text:=Mainqr.fieldByName('sexname').AsString;
    fm.sex_id:=Mainqr.fieldByName('sex_id').AsInteger;
    fm.dtpBirthDate.Date:=Mainqr.fieldByName('birthdate').AsDateTime;
    fm.edPerscardnum.Text:=Mainqr.fieldByName('perscardnum').AsString;
    fm.familystate_id:=Mainqr.fieldByName('familystate_id').AsInteger;
    fm.edFamilyStateName.Text:=Mainqr.fieldByName('familystatename').AsString;
    fm.nation_id:=Mainqr.fieldByName('nation_id').AsInteger;
    fm.edNationname.Text:=Mainqr.fieldByName('nationname').AsString;
    fm.edCountry.Text:=Mainqr.fieldByName('countryname').AsString;
    fm.country_id:=Mainqr.fieldByName('country_id').AsInteger;
    fm.edRegion.Text:=Mainqr.fieldByName('Regionname').AsString;
    fm.Region_id:=Mainqr.fieldByName('Region_id').AsInteger;
    fm.Regioncode:=Mainqr.fieldByName('Regioncode').AsString;
    fm.edState.Text:=Mainqr.fieldByName('Statename').AsString;
    fm.State_id:=Mainqr.fieldByName('State_id').AsInteger;
    fm.Statecode:=Mainqr.fieldByName('Statecode').AsString;
    fm.edTown.Text:=Mainqr.fieldByName('Townname').AsString;
    fm.Town_id:=Mainqr.fieldByName('Town_id').AsInteger;
    fm.Towncode:=Mainqr.fieldByName('Towncode').AsString;
    fm.edPlacement.Text:=Mainqr.fieldByName('Placementname').AsString;
    fm.Placement_id:=Mainqr.fieldByName('Placement_id').AsInteger;
    fm.Placementcode:=Mainqr.fieldByName('Placementcode').AsString;
    fm.dtpContinioussenioritydate.Date:=Mainqr.fieldByName('continioussenioritydate').AsDateTime;
    fm.edInn.Text:=Mainqr.fieldByName('inn').AsString;
    fm.oldemp_id:=MainQr.FieldByName('emp_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} //on E: Exception do Assert(false,E.message); {$ENDIF}
// end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.bibFilterClick(Sender: TObject);
//var
//  fm: TfmEditRBEmp;
//  filstr: string;
begin
{try
 fm:=TfmEditRBEmp.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  fm.lbTabNum.Enabled:=false;
  fm.edTabNum.Enabled:=false;
  fm.edTabNum.Color:=clBtnFace;
  fm.bibTabNumNext.Enabled:=false;
  fm.edSex.Color:=clWindow;
  fm.edSex.ReadOnly:=false;
  fm.lbBirthDate.Enabled:=false;
  fm.dtpBirthDate.Enabled:=false;
  fm.dtpBirthDate.Color:=clBtnFace;
  fm.lbPerscardnum.Enabled:=false;
  fm.edPerscardnum.Enabled:=false;
  fm.edPerscardnum.Color:=clBtnFace;
  fm.edFamilyStateName.Color:=clWindow;
  fm.edFamilyStateName.ReadOnly:=false;
  fm.edNationName.Color:=clWindow;
  fm.edNationName.ReadOnly:=false;
  fm.edCountry.Color:=clWindow;
  fm.edCountry.ReadOnly:=false;
  fm.edRegion.Color:=clWindow;
  fm.edRegion.ReadOnly:=false;
  fm.edState.Color:=clWindow;
  fm.edState.ReadOnly:=false;
  fm.edTown.Color:=clWindow;
  fm.edTown.ReadOnly:=false;
  fm.edPlacement.Color:=clWindow;
  fm.edPlacement.ReadOnly:=false;
  fm.lbContinioussenioritydate.Enabled:=false;
  fm.dtpContinioussenioritydate.Enabled:=false;
  fm.dtpContinioussenioritydate.Color:=clBtnFace;

  if Trim(FindFName)<>'' then fm.edFName.Text:=FindFName;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindSName)<>'' then fm.edSName.Text:=FindSName;
  if Trim(FindSex)<>'' then fm.edSex.Text:=FindSex;
  if Trim(FindFamilyStateName)<>'' then fm.edFamilyStateName.Text:=FindFamilyStateName;
  if Trim(FindNationName)<>'' then fm.edNationName.Text:=FindNationName;
  if Trim(FindCountryName)<>'' then fm.edCountry.Text:=FindCountryName;
  if Trim(FindRegionName)<>'' then fm.edRegion.Text:=FindRegionName;
  if Trim(FindStateName)<>'' then fm.edState.Text:=FindStateName;
  if Trim(FindTownName)<>'' then fm.edTown.Text:=FindTownName;
  if Trim(FindPlacementName)<>'' then fm.edPlacement.Text:=FindPlacementName;
  if Trim(FindInn)<>'' then fm.edInn.Text:=FindInn;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindFName:=Trim(fm.edFName.Text);
    FindName:=Trim(fm.edName.Text);
    FindSName:=Trim(fm.edSName.Text);
    FindSex:=Trim(fm.edSex.Text);
    FindFamilyStateName:=Trim(fm.edFamilyStateName.Text);
    FindNationName:=Trim(fm.edNationName.Text);
    FindCountryName:=Trim(fm.edCountry.Text);
    FindRegionName:=Trim(fm.edRegion.Text);
    FindStateName:=Trim(fm.edState.Text);
    FindTownName:=Trim(fm.edTown.Text);
    FindPlaceMentName:=Trim(fm.edPlaceMent.Text);
    FindInn:=Trim(fm.edInn.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
 except
  {$IFDEF DEBUG}// on E: Exception do Assert(false,E.message); {$ENDIF}
// end;
end;
//---------------------------------------------------------------------------
function TfmOTSalary.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,
  addstr8,addstr9,addstr10,addstr11,addstr12: string;
  and1,and2,and3,and4,and5,and6,and7,
  and8,and9,and10,and11: string;
begin
    Result:='';

    isFindFName:=Trim(FindFName)<>'';
    isFindName:=Trim(FindName)<>'';
    isFindSName:=Trim(FindSName)<>'';
    isFindSex:=Trim(FindSex)<>'';
    isFindFamilyStateName:=Trim(FindFamilyStateName)<>'';
    isFindNationName:=Trim(FindNationName)<>'';
    isFindCountryName:=Trim(FindCountryName)<>'';
    isFindRegionName:=Trim(FindRegionName)<>'';
    isFindStateName:=Trim(FindStateName)<>'';
    isFindTownName:=Trim(FindTownName)<>'';
    isFindPlaceMentName:=Trim(FindPlaceMentName)<>'';
    isFindInn:=Trim(FindInn)<>'';

    if isFindFName or isFindName or isFindSName or isFindSex or isFindInn or
       isFindFamilyStateName or isFindNationName or isFindTownName or
       isFindCountryName or isFindRegionName or isFindStateName or
       isFindPlaceMentName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindFName then begin
        addstr1:=' Upper(fname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFName+'%'))+' ';
     end;

     if isFindName then begin
        addstr2:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindSName then begin
        addstr3:=' Upper(sname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSName+'%'))+' ';
     end;

     if isFindSex then begin
        addstr4:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSex+'%'))+' ';
     end;

     if isFindFamilyStateName then begin
        addstr5:=' Upper(fs.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFamilyStateName+'%'))+' ';
     end;

     if isFindNationName then begin
        addstr6:=' Upper(n.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNationName+'%'))+' ';
     end;

     if isFindInn then begin
        addstr7:=' Upper(inn) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInn+'%'))+' ';
     end;

     if isFindCountryName then begin
       addstr8:=' Upper(ct.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCountryName+'%'))+' '
     end;

     if isFindRegionName then begin
       addstr9:=' Upper(r.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindRegionName+'%'))+' '
     end;

     if isFindStateName then begin
       addstr10:=' Upper(st.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindStateName+'%'))+' '
     end;

     if isFindTownName then begin
       addstr11:=' Upper(t.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTownName+'%'))+' '
     end;

     if isFindPlaceMentName then begin
       addstr12:=' Upper(pm.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPlaceMentName+'%'))+' '
     end;


     if (isFindFName and isFindName)or
        (isFindFName and isFindSName)or
        (isFindFName and isFindSex)or
        (isFindFName and isFindFamilyStateName)or
        (isFindFName and isFindNationName)or
        (isFindFName and isFindCountryName)or
        (isFindFName and isFindRegionName)or
        (isFindFName and isFindStateName)or
        (isFindFName and isFindTownName)or
        (isFindFName and isFindPlaceMentName)
        then and1:=' and ';

     if (isFindName and isFindSName)or
        (isFindName and isFindSex)or
        (isFindName and isFindFamilyStateName)or
        (isFindName and isFindNationName)or
        (isFindName and isFindInn)or
        (isFindName and isFindCountryName)or
        (isFindName and isFindRegionName)or
        (isFindName and isFindStateName)or
        (isFindName and isFindTownName)or
        (isFindName and isFindPlaceMentName)
        then and2:=' and ';

     if (isFindSName and isFindSex)or
        (isFindSName and isFindFamilyStateName)or
        (isFindSName and isFindNationName)or
        (isFindSName and isFindInn) or
        (isFindSName and isFindCountryName)or
        (isFindSName and isFindRegionName)or
        (isFindSName and isFindStateName)or
        (isFindSName and isFindTownName)or
        (isFindSName and isFindPlaceMentName)
        then and3:=' and ';

     if (isFindSex and isFindFamilyStateName)or
        (isFindSex and isFindNationName)or
        (isFindSex and isFindInn)or
        (isFindSex and isFindCountryName)or
        (isFindSex and isFindRegionName)or
        (isFindSex and isFindStateName)or
        (isFindSex and isFindTownName)or
        (isFindSex and isFindPlaceMentName)
        then and4:=' and ';

     if (isFindFamilyStateName and isFindNationName)or
        (isFindFamilyStateName and isFindInn)or
        (isFindFamilyStateName and isFindCountryName)or
        (isFindFamilyStateName and isFindRegionName)or
        (isFindFamilyStateName and isFindStateName)or
        (isFindFamilyStateName and isFindTownName)or
        (isFindFamilyStateName and isFindPlaceMentName)
        then and5:=' and ';

     if (isFindNationName and isFindInn)or
        (isFindNationName and isFindCountryName)or
        (isFindNationName and isFindRegionName)or
        (isFindNationName and isFindStateName)or
        (isFindNationName and isFindTownName)or
        (isFindNationName and isFindPlaceMentName)
        then and6:=' and ';

     if (isFindNationName and isFindCountryName)or
        (isFindNationName and isFindRegionName)or
        (isFindNationName and isFindStateName)or
        (isFindNationName and isFindTownName)or
        (isFindNationName and isFindPlaceMentName)
        then and7:=' and ';

     if (isFindCountryName and isFindRegionName)or
        (isFindCountryName and isFindStateName)or
        (isFindCountryName and isFindTownName)or
        (isFindCountryName and isFindPlaceMentName)
        then and8:=' and ';

     if (isFindRegionName and isFindStateName)or
        (isFindRegionName and isFindTownName)or
        (isFindRegionName and isFindPlaceMentName)
        then and9:=' and ';

     if (isFindStateName and isFindTownName)or
        (isFindStateName and isFindPlaceMentName)
        then and10:=' and ';

     if (isFindTownName and isFindPlaceMentName)
        then and11:=' and ';

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
                      addstr11+and11+
                      addstr12;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.MainqrAfterScroll(DataSet: TDataSet);
begin
ActiveEmpPlant(true);
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.ActiveEmpPlant(CheckPerm: Boolean);

 function CheckPermissionEmpPlant: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermission(tbEmpPlant,SelConst) and
             _isPermission(tbNet,SelConst) and
             _isPermission(tbClass,SelConst) and
             _isPermission(tbPlant,SelConst) and
             _isPermission(tbDocum,SelConst) and
             _isPermission(tbSeat,SelConst) and
             _isPermission(tbDepart,SelConst) and
             _isPermission(tbMotive,SelConst) and
             _isPermission(tbProf,SelConst) and
             _isPermission(tbSchedule,SelConst) and
             isPerm;
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpPlant.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpPlant then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpPlant.AfterScroll:=nil;
  try
   qrEmpPlant.sql.Clear;
   sqls:='Select ep.*,n.name as netname,c.num as classnum,p.smallname as plantname,'+
         'rd.num as reasondocumnum,ct.name as categoryname,s.name as seatname,'+
         'd.name as departname,od.num as orderdocumnum,m.name as motivename,'+
         'pr.name as profname, dm.num as motivedocumnum'+
         ' from '+tbEmpPlant+' ep '+
         ' join '+tbNet+' n on ep.net_id=n.net_id'+
         ' join '+tbClass+' c on ep.class_id=c.class_id'+
         ' join '+tbPlant+' p on ep.plant_id=p.plant_id'+
         ' join '+tbDocum+' rd on ep.reasondocum_id=rd.docum_id'+
         ' join '+tbCategory+' ct on ep.category_id=ct.category_id'+
         ' join '+tbSeat+' s on ep.seat_id=s.seat_id'+
         ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
         ' join '+tbDocum+' od on ep.orderdocum_id=od.docum_id'+
         ' join '+tbProf+' pr on ep.prof_id=pr.prof_id'+
         ' left join '+tbMotive+' m on ep.motive_id=m.motive_id'+
         ' left join '+tbDocum+' dm on ep.motivedocum_id=dm.docum_id'+
         ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPlant;
   qrEmpPlant.sql.Add(sqls);
   qrEmpPlant.Transaction.Active:=false;
   qrEmpPlant.Transaction.Active:=true;
   qrEmpPlant.Active:=true;
  finally
   qrEmpPlant.AfterScroll:=qrEmpPlantAfterScroll;
   qrEmpPlantAfterScroll(nil);
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridTitleClickEmpPlant(Column: TColumn);
var
  fn: string;
  id1: string;
  sqls: string;
begin
 try
  if not qrEmpPlant.Active then exit;
  if qrEmpPlant.isEmpty then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id1:=qrEmpPlant.fieldByName('empplant_id').asString;
   if UpperCase(fn)=UpperCase('motivedocumnum') then fn:='dm.num';
   if UpperCase(fn)=UpperCase('netname') then fn:='n.name';
   if UpperCase(fn)=UpperCase('classnum') then fn:='c.num';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('reasondocumnum') then fn:='rd.num';
   if UpperCase(fn)=UpperCase('categoryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('seatname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('departname') then fn:='d.name';
   if UpperCase(fn)=UpperCase('orderdocumnum') then fn:='od.num';
   if UpperCase(fn)=UpperCase('motivename') then fn:='m.name';
   if UpperCase(fn)=UpperCase('profname') then fn:='pr.name';
   qrEmpPlant.Active:=false;
   qrEmpPlant.SQL.Clear;
   LastOrderStrEmpPlant:=' Order by '+fn;
   sqls:='Select ep.*,n.name as netname,c.num as classnum,p.smallname as plantname,'+
         'rd.num as reasondocumnum,ct.name as categoryname,s.name as seatname,'+
         'd.name as departname,od.num as orderdocumnum,m.name as motivename,'+
         'pr.name as profname, dm.num as motivedocumnum '+
         ' from '+tbEmpPlant+' ep '+
         ' join '+tbNet+' n on ep.net_id=n.net_id'+
         ' join '+tbClass+' c on ep.class_id=c.class_id'+
         ' join '+tbPlant+' p on ep.plant_id=p.plant_id'+
         ' join '+tbDocum+' rd on ep.reasondocum_id=rd.docum_id'+
         ' join '+tbCategory+' ct on ep.category_id=ct.category_id'+
         ' join '+tbSeat+' s on ep.seat_id=s.seat_id'+
         ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
         ' join '+tbDocum+' od on ep.orderdocum_id=od.docum_id'+
         ' join '+tbProf+' pr on ep.prof_id=pr.prof_id'+
         ' left join '+tbMotive+' m on ep.motive_id=m.motive_id'+
         ' left join '+tbDocum+' dm on ep.motivedocum_id=dm.docum_id'+
         ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPlant;
   qrEmpPlant.SQL.Add(sqls);
   qrEmpPlant.Transaction.Active:=false;
   qrEmpPlant.Transaction.Active:=true;
   qrEmpPlant.Active:=true;
   qrEmpPlant.Locate('empplant_id',id1,[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridTitleClickEmpPlantChargeOn(Column: TColumn);
var
  fn: string;
  id1: string;
  sqls: string;
begin
exit;
 try
  if not qrChargeOn.Active then exit;
  if qrChargeOn.isEmpty then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id1:=qrChargeOn.fieldByName('empplant_id').asString;
   if UpperCase(fn)=UpperCase('motivedocumnum') then fn:='dm.num';
   if UpperCase(fn)=UpperCase('netname') then fn:='n.name';
   if UpperCase(fn)=UpperCase('classnum') then fn:='c.num';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('reasondocumnum') then fn:='rd.num';
   if UpperCase(fn)=UpperCase('categoryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('seatname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('departname') then fn:='d.name';
   if UpperCase(fn)=UpperCase('orderdocumnum') then fn:='od.num';
   if UpperCase(fn)=UpperCase('motivename') then fn:='m.name';
   if UpperCase(fn)=UpperCase('profname') then fn:='pr.name';
   qrChargeOn.Active:=false;
   qrChargeOn.SQL.Clear;
   LastOrderStrEmpPlantChargeOn:=' Order by '+fn;
   sqls:='Select ep.*,n.name as netname,c.num as classnum,p.smallname as plantname,'+
         'rd.num as reasondocumnum,ct.name as categoryname,s.name as seatname,'+
         'd.name as departname,od.num as orderdocumnum,m.name as motivename,'+
         'pr.name as profname, dm.num as motivedocumnum'+
         ' from '+tbEmpPlant+' ep '+
         ' join '+tbNet+' n on ep.net_id=n.net_id'+
         ' join '+tbClass+' c on ep.class_id=c.class_id'+
         ' join '+tbPlant+' p on ep.plant_id=p.plant_id'+
         ' join '+tbDocum+' rd on ep.reasondocum_id=rd.docum_id'+
         ' join '+tbCategory+' ct on ep.category_id=ct.category_id'+
         ' join '+tbSeat+' s on ep.seat_id=s.seat_id'+
         ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
         ' join '+tbDocum+' od on ep.orderdocum_id=od.docum_id'+
         ' join '+tbProf+' pr on ep.prof_id=pr.prof_id'+
         ' left join '+tbMotive+' m on ep.motive_id=m.motive_id'+
         ' left join '+tbDocum+' dm on ep.motivedocum_id=dm.docum_id'+
         ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPlantChargeOn;
   qrChargeOn.SQL.Add(sqls);
   qrChargeOn.Transaction.Active:=false;
   qrChargeOn.Transaction.Active:=true;
   qrChargeOn.Active:=true;
   qrChargeOn.Locate('empplant_id',id1,[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//---------------------------------------------------------------------------
procedure TfmOTSalary.GridTitleClickEmpPlantChargeOff(Column: TColumn);
var
  fn: string;
  id1: string;
  sqls: string;
begin
exit;
 try
  if not qrChargeOff.Active then exit;
  if qrChargeOff.isEmpty then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id1:=qrChargeOff.fieldByName('empplant_id').asString;
   if UpperCase(fn)=UpperCase('motivedocumnum') then fn:='dm.num';
   if UpperCase(fn)=UpperCase('netname') then fn:='n.name';
   if UpperCase(fn)=UpperCase('classnum') then fn:='c.num';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('reasondocumnum') then fn:='rd.num';
   if UpperCase(fn)=UpperCase('categoryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('seatname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('departname') then fn:='d.name';
   if UpperCase(fn)=UpperCase('orderdocumnum') then fn:='od.num';
   if UpperCase(fn)=UpperCase('motivename') then fn:='m.name';
   if UpperCase(fn)=UpperCase('profname') then fn:='pr.name';
   qrChargeOff.Active:=false;
   qrChargeOff.SQL.Clear;
   LastOrderStrEmpPlantChargeOff:=' Order by '+fn;
   sqls:='Select ep.*,n.name as netname,c.num as classnum,p.smallname as plantname,'+
         'rd.num as reasondocumnum,ct.name as categoryname,s.name as seatname,'+
         'd.name as departname,od.num as orderdocumnum,m.name as motivename,'+
         'pr.name as profname, dm.num as motivedocumnum'+
         ' from '+tbEmpPlant+' ep '+
         ' join '+tbNet+' n on ep.net_id=n.net_id'+
         ' join '+tbClass+' c on ep.class_id=c.class_id'+
         ' join '+tbPlant+' p on ep.plant_id=p.plant_id'+
         ' join '+tbDocum+' rd on ep.reasondocum_id=rd.docum_id'+
         ' join '+tbCategory+' ct on ep.category_id=ct.category_id'+
         ' join '+tbSeat+' s on ep.seat_id=s.seat_id'+
         ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
         ' join '+tbDocum+' od on ep.orderdocum_id=od.docum_id'+
         ' join '+tbProf+' pr on ep.prof_id=pr.prof_id'+
         ' left join '+tbMotive+' m on ep.motive_id=m.motive_id'+
         ' left join '+tbDocum+' dm on ep.motivedocum_id=dm.docum_id'+
         ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPlantChargeOff;
   qrChargeOff.SQL.Add(sqls);
   qrChargeOff.Transaction.Active:=false;
   qrChargeOff.Transaction.Active:=true;
   qrChargeOff.Active:=true;
   qrChargeOff.Locate('empplant_id',id1,[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//---------------------------------------------------------------------------
procedure TfmOTSalary.GridTitleClickEmpPlantChargeConst(Column: TColumn);
var
  fn: string;
  id1: string;
  sqls: string;
begin
exit;
 try
  if not qrChargeConst.Active then exit;
  if qrChargeConst.isEmpty then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id1:=qrChargeConst.fieldByName('empplant_id').asString;
   if UpperCase(fn)=UpperCase('motivedocumnum') then fn:='dm.num';
   if UpperCase(fn)=UpperCase('netname') then fn:='n.name';
   if UpperCase(fn)=UpperCase('classnum') then fn:='c.num';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('reasondocumnum') then fn:='rd.num';
   if UpperCase(fn)=UpperCase('categoryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('seatname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('departname') then fn:='d.name';
   if UpperCase(fn)=UpperCase('orderdocumnum') then fn:='od.num';
   if UpperCase(fn)=UpperCase('motivename') then fn:='m.name';
   if UpperCase(fn)=UpperCase('profname') then fn:='pr.name';
   qrChargeConst.Active:=false;
   qrChargeConst.SQL.Clear;
   LastOrderStrEmpPlantChargeConst:=' Order by '+fn;
   sqls:='Select ep.*,n.name as netname,c.num as classnum,p.smallname as plantname,'+
         'rd.num as reasondocumnum,ct.name as categoryname,s.name as seatname,'+
         'd.name as departname,od.num as orderdocumnum,m.name as motivename,'+
         'pr.name as profname, dm.num as motivedocumnum'+
         ' from '+tbEmpPlant+' ep '+
         ' join '+tbNet+' n on ep.net_id=n.net_id'+
         ' join '+tbClass+' c on ep.class_id=c.class_id'+
         ' join '+tbPlant+' p on ep.plant_id=p.plant_id'+
         ' join '+tbDocum+' rd on ep.reasondocum_id=rd.docum_id'+
         ' join '+tbCategory+' ct on ep.category_id=ct.category_id'+
         ' join '+tbSeat+' s on ep.seat_id=s.seat_id'+
         ' join '+tbDepart+' d on ep.depart_id=d.depart_id'+
         ' join '+tbDocum+' od on ep.orderdocum_id=od.docum_id'+
         ' join '+tbProf+' pr on ep.prof_id=pr.prof_id'+
         ' left join '+tbMotive+' m on ep.motive_id=m.motive_id'+
         ' left join '+tbDocum+' dm on ep.motivedocum_id=dm.docum_id'+
         ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPlantChargeConst;
   qrChargeConst.SQL.Add(sqls);
   qrChargeConst.Transaction.Active:=false;
   qrChargeConst.Transaction.Active:=true;
   qrChargeConst.Active:=true;
   qrChargeConst.Locate('empplant_id',id1,[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//---------------------------------------------------------------------------
procedure TfmOTSalary.GridDblClickEmpPlant(Sender: TObject);
begin
  if not qrEmpPlant.Active then exit;
  if qrEmpPlant.isEmpty then exit;
  bibEmpPlantView.Click;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridDblClickEmpPlantChargeOn(Sender: TObject);
begin
  if not qrChargeOn.Active then exit;
  if qrChargeOn.isEmpty then exit;
//  bibEmpPlantView.Click;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridDblClickEmpPlantChargeOff(Sender: TObject);
begin
  if not qrChargeOff.Active then exit;
  if qrChargeOff.isEmpty then exit;
//  bibEmpPlantView.Click;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.GridDblClickEmpPlantChargeConst(Sender: TObject);
begin
  if not qrChargeConst.Active then exit;
  if qrChargeConst.isEmpty then exit;
//  bibEmpPlantView.Click;
end;
//---------------------------------------------------------------------------

procedure TfmOTSalary.bibAdjustClick(Sender: TObject);
begin
  SetAdjustColumns(Grid.Columns);
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.bibEmpPlantAdjustClick(Sender: TObject);
begin
  SetAdjustColumns(GridEmpPlant.Columns);
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.SetImageFilter(FilterOn: Boolean);
begin
  if FilterOn then begin
    bibEmpfilter.Font.Color:=ConstColorFilter;
  end else begin
    bibEmpfilter.Font.Color:=clWindowText;
  end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.bibEmpPlantRefreshClick(Sender: TObject);
begin
  ActiveEmpPlant(true);
end;
//---------------------------------------------------------------------------
procedure SetLastEmpPlantSchedule(empplant_id: Integer; var schedule_id: Integer;
                                  var schedulename: string);
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select max(schedule_id)as schedule_id from '+
         tbEmpPlantSchedule+' where empplant_id='+inttostr(empplant_id);
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     schedule_id:=qrnew.FieldByName('schedule_id').AsInteger;
   end else exit;
   qrnew.SQL.Clear;
   qrnew.Transaction.Active:=true;
   sqls:='Select name from '+tbSchedule+
         ' where schedule_id='+inttostr(schedule_id);
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     schedulename:=qrnew.FieldByName('name').AsString;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//---------------------------------------------------------------------------
procedure TfmOTSalary.bibEmpPlantViewClick(Sender: TObject);
//var
//  fm: TfmEditRBEmpPlant;
//  schedulename: string;
begin
{ try
  if not qrEmpPlant.Active then exit;
  if qrEmpPlant.isempty then exit;
  fm:=TfmEditRBEmpPlant.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.net_id:=qrEmpPlant.fieldByName('net_id').AsInteger;
    fm.edNet.text:=qrEmpPlant.fieldByName('netname').AsString;
    fm.class_id:=qrEmpPlant.fieldByName('class_id').AsInteger;
    fm.edClass.text:=qrEmpPlant.fieldByName('classnum').AsString;
    fm.plant_id:=qrEmpPlant.fieldByName('plant_id').AsInteger;
    fm.edPlant.text:=qrEmpPlant.fieldByName('plantname').AsString;
    fm.reasondocum_id:=qrEmpPlant.fieldByName('reasondocum_id').AsInteger;
    fm.edReasonDocum.text:=qrEmpPlant.fieldByName('reasondocumnum').AsString;
    fm.category_id:=qrEmpPlant.fieldByName('category_id').AsInteger;
    fm.edCategory.text:=qrEmpPlant.fieldByName('categoryname').AsString;
    fm.seat_id:=qrEmpPlant.fieldByName('seat_id').AsInteger;
    fm.edSeat.text:=qrEmpPlant.fieldByName('seatname').AsString;
    fm.depart_id:=qrEmpPlant.fieldByName('depart_id').AsInteger;
    fm.edDepart.text:=qrEmpPlant.fieldByName('departname').AsString;
    fm.orderdocum_id:=qrEmpPlant.fieldByName('orderdocum_id').AsInteger;
    fm.edOrderDocum.text:=qrEmpPlant.fieldByName('orderdocumnum').AsString;
    fm.motive_id:=qrEmpPlant.fieldByName('motive_id').AsInteger;
    fm.edMotive.text:=qrEmpPlant.fieldByName('motivename').AsString;
    fm.motivedocum_id:=qrEmpPlant.fieldByName('motivedocum_id').AsInteger;
    fm.edMotiveDocum.text:=qrEmpPlant.fieldByName('motivedocumnum').AsString;
    fm.prof_id:=qrEmpPlant.fieldByName('prof_id').AsInteger;
    fm.edProf.text:=qrEmpPlant.fieldByName('profname').AsString;
    fm.dtpDateStart.dateTime:=qrEmpPlant.fieldByName('datestart').AsDateTime;
    if Trim(qrEmpPlant.fieldByName('releasedate').ASString)<>'' then
      fm.dtpReleaseDate.dateTime:=qrEmpPlant.fieldByName('releasedate').AsDateTime;
    SetLastEmpPlantSchedule(qrEmpPlant.fieldByName('empplant_id').AsInteger,
                            fm.schedule_id,schedulename);
    fm.edschedule.Text:=schedulename;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} //on E: Exception do Assert(false,E.message); {$ENDIF}
 //end;
end;
//---------------------------------------------------------------------------

procedure TfmOTSalary.BitBtn1Click(Sender: TObject);
var
  fm: TfmEditRBAddCharge;
  fm1: TfmEditRBAddConstCharge;
  TPRBI: TParamRBookInterface;
begin
if (CalcPeriod_id<>Curcalcperiod_id) then
        ShowMessage ('Нельзя добавлять, изменять или удалять данные из другого рассчетного периода')
        else
        begin

  case PC2.ActivePageIndex of
//Добавляю начисление
  0:
        begin
            ChargeFlag:=0;
 try
  if Mainqr.IsEmpty then exit;
  if not qrChargeOn.Active then exit;
  fm:=TfmEditRBAddCharge.Create(nil);
  try
    fm.empplant_id:=qrEmpPlant.fieldbyname('empplant_id').AsInteger;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:='Добавление начисления';
    if fm.ShowModal=mrok then begin
        ActiveEmpPlantChargeOn(true);
        ActiveEmpPlantChargeOff(true);
        //  ActiveEmpPlantChargeConst(true);
        NeedReCalc:=true;
    end;
  finally
   fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
        end;
//Добавляю удержание
  1:    begin
            ChargeFlag:=1;
        try
         try
          if Mainqr.IsEmpty then exit;
          if not qrChargeOff.Active then exit;
          fm:=TfmEditRBAddCharge.Create(nil);
          fm.empplant_id:=qrEmpPlant.fieldbyname('empplant_id').AsInteger;
          fm.bibOk.OnClick:=fm.AddClick;
          fm.Caption:='Добавление удержания';
          if fm.ShowModal=mrok then begin
                  ActiveEmpPlantChargeOn(true);
                  ActiveEmpPlantChargeOff(true);
                  //  ActiveEmpPlantChargeConst(true);
                  NeedReCalc:=true;
              end;
          finally
             fm.Free;
          end;
        except
          {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
        end;


        end;
//Добавляю постоянные начисления
  2:    begin
            ChargeFlag:=2;
 try
  if Mainqr.IsEmpty then exit;
  if not qrChargeConst.Active then exit;
  fm1:=TfmEditRBAddConstCharge.Create(nil);
  try
    fm1.empplant_id:=qrEmpPlant.fieldbyname('empplant_id').AsInteger;
    fm1.bibOk.OnClick:=fm1.AddClick;
    fm1.Caption:='Добавление постоянного начисления/удержания ';
    if fm1.ShowModal=mrok then begin
        //  ActiveEmpPlantChargeOn(true);
        //  ActiveEmpPlantChargeOff(true);
          ActiveEmpPlantChargeConst(true);
        NeedReCalc:=true;
    end;
  finally
   fm1.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

        end;
  3:    begin
            ChargeFlag:=3;
        end;
  end;


end;
end;
//------------------------------------------------------------------------
procedure TfmOTSalary.ActiveEmpPlantChargeOn(CheckPerm: Boolean);

 function CheckPermissionEmpPlantChargeOn: Boolean;
 var
  isPermNew: Boolean;

 begin
  isPermNew:=_isPermission(tbEmpPlant,SelConst) and
             _isPermission(tbNet,SelConst) and
             _isPermission(tbClass,SelConst) and
             _isPermission(tbPlant,SelConst) and
             _isPermission(tbDocum,SelConst) and
             _isPermission(tbSeat,SelConst) and
             _isPermission(tbDepart,SelConst) and
             _isPermission(tbMotive,SelConst) and
             _isPermission(tbProf,SelConst) and
             _isPermission(tbAlgorithm,SelConst) and
             _isPermission(tbCharge,SelConst) and
             _isPermission(tbConstCharge,SelConst) and
             _isPermission(tbMrot,SelConst) and
             isPerm;
  Result:=isPermNew;
 end;
var
 sqls: String;
begin
 try
  qrChargeOn.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpPlantChargeOn then exit;

  Screen.Cursor:=crHourGlass;
  try
   qrChargeOn.sql.Clear;
        sqls:='select sal.*, cp.name as calcperiod, cp1.name as correctperiod,'+
              ' ch.shortname as chargeshortname, sal.days , sal.hours ,sal.percent,'+
              ' e.fname, e.name , e.sname, ee.fname, ee.name , ee.sname'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' '+
         LastOrderStrEmpPlantChargeOn;
   qrChargeOn.sql.Add(sqls);
   qrChargeOn.Transaction.Active:=false;
   qrChargeOn.Transaction.Active:=true;
   qrChargeOn.Active:=true;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//------------------------------------------------------------------------
procedure TfmOTSalary.ActiveEmpPlantChargeOff(CheckPerm: Boolean);

 function CheckPermissionEmpPlantChargeOff: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermission(tbEmpPlant,SelConst) and
             _isPermission(tbNet,SelConst) and
             _isPermission(tbClass,SelConst) and
             _isPermission(tbPlant,SelConst) and
             _isPermission(tbDocum,SelConst) and
             _isPermission(tbSeat,SelConst) and
             _isPermission(tbDepart,SelConst) and
             _isPermission(tbMotive,SelConst) and
             _isPermission(tbProf,SelConst) and
             _isPermission(tbSchedule,SelConst) and
             _isPermission(tbAlgorithm,SelConst) and
             _isPermission(tbCharge,SelConst) and
             _isPermission(tbConstCharge,SelConst) and
             _isPermission(tbMrot,SelConst) and
             isPerm;
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrChargeOff.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpPlantChargeOff then exit;

  Screen.Cursor:=crHourGlass;
  try
//     qrChargeOff.Database:=IBDB;
//     qrChargeOff.Transaction:=ibtranChargeOff;
//     IBDB.AddTransaction(ibtranChargeOff);
//     qrChargeOff.Transaction.Active:=true;

   qrChargeOff.sql.Clear;
        sqls:='select sal.*, cp.name as calcperiod, cp1.name as correctperiod,'+
              ' ch.shortname as chargeshortname, sal.days , sal.hours ,sal.percent,'+
              ' e.fname, e.name , e.sname, ee.fname, ee.name , ee.sname'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=1)'+
              ' where sal.empplant_id ='+ inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger)+' '+
              ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' '+
         LastOrderStrEmpPlantChargeOff;
   qrChargeOff.sql.Add(sqls);
   qrChargeOff.Transaction.Active:=false;
   qrChargeOff.Transaction.Active:=true;
   qrChargeOff.Active:=true;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//------------------------------------------------------------------------
procedure TfmOTSalary.ActiveEmpPlantChargeConst(CheckPerm: Boolean);

 function CheckPermissionConstCharge: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermission(tbEmpPlant,SelConst) and
             _isPermission(tbNet,SelConst) and
             _isPermission(tbClass,SelConst) and
             _isPermission(tbPlant,SelConst) and
             _isPermission(tbDocum,SelConst) and
             _isPermission(tbSeat,SelConst) and
             _isPermission(tbDepart,SelConst) and
             _isPermission(tbMotive,SelConst) and
             _isPermission(tbProf,SelConst) and
             _isPermission(tbSchedule,SelConst) and
             _isPermission(tbAlgorithm,SelConst) and
             _isPermission(tbCharge,SelConst) and
             _isPermission(tbConstCharge,SelConst) and
             _isPermission(tbMrot,SelConst) and
             isPerm;
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrChargeConst.Active:=false;
  if CheckPerm then
   if not CheckPermissionConstCharge then exit;

  Screen.Cursor:=crHourGlass;
  try
   qrChargeConst.sql.Clear;
        sqls:='select ch.shortname as chargeshortname, cc.* '+
              ' from ' + tbConstCharge + ' cc'+
              ' join ' + tbcharge + ' ch on  cc.charge_id in (select ch.charge_id from charge)'+
              ' where cc.empplant_id ='+ inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger)+' and  '+
//              ' startdate < '''+ DateToStr(now-62) + ''' and '+
              ' enddate is null or enddate > ''' +DateToStr(now+62) + ''''+
         LastOrderStrEmpPlantChargeConst;
   qrChargeConst.sql.Add(sqls);
   qrChargeConst.Transaction.Active:=false;
   qrChargeConst.Transaction.Active:=true;
   qrChargeConst.Active:=true;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOTSalary.qrEmpPlantAfterScroll(DataSet: TDataSet);
begin
  Button2Click(nil);
//  bibCalcItogy.Click;
end;

procedure TfmOTSalary.bibCalcPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
//Получаю рассчетный период
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='calcperiod_id';
  TPRBI.Locate.KeyValues:=calcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameCalcPeriod,@TPRBI) then begin
     ChangeFlag:=true;
     calcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'calcperiod_id');
     edCalcPeriod.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
ActiveQuery(true);
end;



procedure TfmOTSalary.bibCurCalcPeriodClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
//Получаю рассчетный период
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
ActiveQuery(true);
end;


procedure TfmOTSalary.edCalcPeriodChange(Sender: TObject);
begin
  ActiveEmpPlant(true);
//MainqrAfterScroll();
end;

procedure TfmOTSalary.bibDeleteClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecordChargeOn: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=ibtranChargeOn;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbSalary+' where salary_id='+
          inttostr(qrChargeOn.fieldbyName('salary_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     _AddSqlOperationToJournal(PChar(ConstDelete),PChar(sqls));

ActiveEmpPlantChargeOn(false);
//     ActiveQuery(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

  function DeleteRecordChargeOff: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=ibtranChargeOff;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbSalary+' where salary_id='+
          inttostr(qrChargeOff.fieldbyName('salary_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     _AddSqlOperationToJournal(PChar(ConstDelete),PChar(sqls));

ActiveEmpPlantChargeOff(false);
//     ActiveQuery(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;


  function DeleteRecordConstCharge: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=ibtranChargeConst;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbConstCharge+' where ConstCharge_id='+
          inttostr(qrChargeConst.fieldbyName('ConstCharge_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     _AddSqlOperationToJournal(PChar(ConstDelete),PChar(sqls));

ActiveEmpPlantChargeConst(false);
//     ActiveQuery(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;


begin
  case PC2.ActivePageIndex of
  0:
  begin
  if qrChargeOn.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' начисление <'+
                        qrChargeOn.FieldByName('chargeshortname').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not DeleteRecordChargeOn then begin
    end
    else NeedReCalc:=true;
  end;
  end;
  1:
  begin
  if qrChargeOff.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' удержание <'+
                        qrChargeOff.FieldByName('chargeshortname').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not DeleteRecordChargeOff then begin
    end
        else NeedReCalc:=true;
  end;
  end;

  2:
  begin
  if qrChargeConst.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' постоянное начисление <'+
                        qrChargeConst.FieldByName('chargeshortname').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not DeleteRecordConstCharge then begin
    end
        else NeedReCalc:=true;
  end;
  end;
  end;
  end;

procedure TfmOTSalary.BitBtn9Click(Sender: TObject);
begin
    ActiveEmpPlantChargeOn(true);
    ActiveEmpPlantChargeOff(true);
    ActiveEmpPlantChargeConst(true);


end;

procedure TfmOTSalary.BitBtn12Click(Sender: TObject);
begin

  case PC2.ActivePageIndex of
  0:  SetAdjustColumns(GridEmpPlantChargeOn.Columns);
  1:  SetAdjustColumns(GridEmpPlantChargeOff.Columns);
  2:  SetAdjustColumns(GridEmpPlantChargeConst.Columns);
  end;
end;



procedure TfmOTSalary.bibCalcItogyClick(Sender: TObject);
  var
    qr: TIBQuery;
    sqls: string;
begin
ActivePrivelege(false);
cedSummaOn.Value:=0;
cedSummaOff.Value:=0;
cedItog.Value:=0;


//Пересчет итогов
//Итого начислено
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
    try
     qr.Database:=IBDB;
     qr.Transaction:=ibtranChargeOn;
//     qr.Transaction.Active:=true;
     sqls:='Select SUM(summa) as summa from '+tbSalary+ ' sal '+
                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
                ' where sal.empplant_id ='+ inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger)+' '+
                ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' ';
     qr.sql.Add(sqls);
     qr.Open;
//     qr.Transaction.Commit;
     cedSummaOn.Value:=qr.fieldbyName('SUMMA').AsFloat;
     qr.Active:=false;

     qr.sql.Clear;
     sqls:='Select SUM(summa) as summa from '+tbSalary+ ' sal '+
                ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=1)'+
                ' where sal.empplant_id ='+ inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger)+' '+
                ' and sal.calcperiod_id = ' +IntToStr(calcperiod_id)+ ' ';
     qr.sql.Add(sqls);
     qr.Open;
//     qr.Transaction.Commit;
     cedSummaOff.Value:=qr.fieldbyName('SUMMA').AsFloat;


   finally
    qr.Free;
    Screen.Cursor:=crDefault;
   end;
  end;
  cedItog.Value:=cedSummaOn.Value - cedSummaOff.Value;
end;

procedure TfmOTSalary.Button1Click(Sender: TObject);
var
fm:TfmEditRBPrivelege;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBPrivelege.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
fm.CESPJanuary.Value    :=qrPrivelege.fieldbyName('SP1').AsFloat;
fm.CESPFebruary.Value   :=qrPrivelege.fieldbyName('SP2').AsFloat;
fm.CESPMarch.Value      :=qrPrivelege.fieldbyName('SP3').AsFloat;
fm.CESPApril.Value      :=qrPrivelege.fieldbyName('SP4').AsFloat;
fm.CESPMay.Value        :=qrPrivelege.fieldbyName('SP5').AsFloat;
fm.CESPJune.Value       :=qrPrivelege.fieldbyName('SP6').AsFloat;
fm.CESPJuly.Value       :=qrPrivelege.fieldbyName('SP7').AsFloat;
fm.CESPAugust.Value     :=qrPrivelege.fieldbyName('SP8').AsFloat;
fm.CESPSeptember.Value  :=qrPrivelege.fieldbyName('SP9').AsFloat;
fm.CESPOctober.Value    :=qrPrivelege.fieldbyName('SP10').AsFloat;
fm.CESPNovember.Value   :=qrPrivelege.fieldbyName('SP11').AsFloat;
fm.CESPDecember.Value   :=qrPrivelege.fieldbyName('SP12').AsFloat;

fm.CEDPJanuary.Value   :=qrPrivelege.fieldbyName('DP1').AsFloat;
fm.CEDPFebruary.Value  :=qrPrivelege.fieldbyName('DP2').AsFloat;
fm.CEDPMarch.Value     :=qrPrivelege.fieldbyName('DP3').AsFloat;
fm.CEDPApril.Value     :=qrPrivelege.fieldbyName('DP4').AsFloat;
fm.CEDPMay.Value       :=qrPrivelege.fieldbyName('DP5').AsFloat;
fm.CEDPJune.Value      :=qrPrivelege.fieldbyName('DP6').AsFloat;
fm.CEDPJuly.Value      :=qrPrivelege.fieldbyName('DP7').AsFloat;
fm.CEDPAugust.Value    :=qrPrivelege.fieldbyName('DP8').AsFloat;
fm.CEDPSeptember.Value :=qrPrivelege.fieldbyName('DP9').AsFloat;
fm.CEDPOctober.Value   :=qrPrivelege.fieldbyName('DP10').AsFloat;
fm.CEDPNovember.Value  :=qrPrivelege.fieldbyName('DP11').AsFloat;
fm.CEDPDecember.Value  :=qrPrivelege.fieldbyName('DP12').AsFloat;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

//------------------------------------------------------------------------
procedure TfmOTSalary.ActivePrivelege(CheckPerm: Boolean);

 function CheckPermissionPrivelege: Boolean;
 var
  isPermNew: Boolean;

 begin
  isPermNew:=_isPermission(tbEmpPlant,SelConst) and
             _isPermission(tbPrivelege,SelConst) and
             isPerm;
  Result:=isPermNew;
 end;
var
 sqls: String;
// curYear:String;
 Summa:Double;
 i: Integer;

begin
 try
  qrPrivelege.Active:=false;
  qrPrivelege.Database:=IBDB;

  if CheckPerm then
   if not CheckPermissionPrivelege then exit;

  Screen.Cursor:=crHourGlass;
  try
   qrPrivelege.sql.Clear;
        sqls:='select pr.* '+' from ' + tbPrivelege + ' pr '+
              ' where pr.empplant_id ='+ inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger)+' '+
              ' and pr.year_ = ' +GetCurrentYear(calcperiod_id)+ ' ';
   qrPrivelege.sql.Add(sqls);
   ibtranPrivelege.AddDatabase(IBDB);
   qrPrivelege.Transaction:=ibtranPrivelege;
   qrPrivelege.Transaction.Active:=false;
   qrPrivelege.Transaction.Active:=true;
   qrPrivelege.Active:=true;
      Summa:=0;
   for i:=1 to GetCurrentMonth(CalcPeriod_ID) do
   begin
   Summa:= Summa + qrPrivelege.fieldbyName('SP'+inttostr(i)).AsFloat +
                   qrPrivelege.fieldbyName('DP'+inttostr(i)).AsFloat;
   end;
   cePrivelege.Value:=Summa;  


  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

 procedure TfmOTSalary.Button2Click(Sender: TObject);
var
sqls:String;
YearSumm:Currency;
    schedule_id: Integer;    
//        Ps: PScheduleParams;
 ////////////////////////////
 IDs1,IDs2:TRecordsIDs;
 ////////////////////////////
begin
case PC2.ActivePageIndex of
  0:  ActiveEmpPlantChargeOn(true);
  1:  ActiveEmpPlantChargeOff(true);
  2:  ActiveEmpPlantChargeConst(true);
  3:  begin
 calcstartdate:=GetCalcPeriodStartDate (calcperiod_id) ;
 calcenddate:=IncMonth(calcstartdate,1)-1;

  EmpPlant_id:=qrEmpPlant.fieldbyName('empplant_id').AsInteger;
     //Получить текущий календарь и график
 try
  schedule_id:= GetCalendar_ID(empplant_id,calcstartdate) ;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

  SetLength(IDs1,1);
  SetLength(IDs2,1);
  IDs1[0]:=11;
  cedOklad.Value:=GetOklad(empplant_id);
  IDs2[0]:=1;
  ceNormDay.Value:=GetNormalTime(Schedule_id,IDs2,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
  IDs2[0]:=2;
  ceNormEvening.Value:=GetNormalTime(Schedule_id,IDs2,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
  IDs2[0]:=3;
  ceNormNight.Value:=GetNormalTime(Schedule_id,IDs2,calcstartdate, calcenddate,True,[dtOrdinary,dtFree,dtHoliday]);
  IDs2[0]:=1;
  ceFactDay.Value:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
  IDs2[0]:=2;
  ceFactEvening.Value:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
  IDs2[0]:=3;
  ceFactNight.Value:=GetActualTime(EmpPlant_id,IDs1,IDs2,calcstartdate, calcenddate,True);
  cedNorma.Value:=ceNormDay.Value+ceNormEvening.Value+ceNormNight.Value;
  cedFact.Value:=ceNormDay.Value+ceNormEvening.Value+ceNormNight.Value;
  ActivePrivelege(true);

//****************************************************************************
//Предусмотреть в будущем начальные остатки с другого места работы
OldYearSumm:=0;
//****************************************************************************
        IBTranYearSumm.AddDatabase(IBDB);
        IBDB.AddTransaction(IBTranYearSumm);
        qrYearSumm.Database:=IBDB;
        qrYearSumm.Transaction:=IBTranYearSumm;
        sqls:='select SUM(sal.summa) as summa'+
              ' from ' + tbSalary + ' sal'+
              ' join ' + tbcalcperiod + ' cp on sal.calcperiod_id = cp.calcperiod_id '+
              ' join ' + tbcalcperiod + ' cp1 on  sal.correctperiod_id = cp1.calcperiod_id'+
              ' join ' + tbemp + ' e on  sal.creatoremp_id = e.emp_id'+
              ' join ' + tbemp + ' ee on  sal.modifycatoremp_id = ee.emp_id'+
              ' join ' + tbcharge + ' ch on  sal.charge_id in (select ch.charge_id from charge where ch.flag=0)'+
              ' where sal.empplant_id ='+ inttostr(empplant_id)+' '+
              ' and sal.calcperiod_id in (select cp.calcperiod_id from '+tbCalcperiod+' where cp.startdate like ''%' +GetCurrentYear(calcperiod_id)+'%'')';
   qrYearSumm.sql.clear;
   qrYearSumm.sql.Add(sqls);
   qrYearSumm.Active:=true;

        YearSumm:=OldYearSumm+qrYearSumm.FieldByName('summa').AsFloat;


  end
  end;
  bibCalcItogy.Click;
end;

end.
