unit URBEmp;

interface
{$I stbasis.inc}
{$R 'tsv.res'}

uses            
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, Grids, ComCtrls, tsvDbGrid, IB,
  Menus, UMainUnited, IBUpdateSQL;

type
   TfmRBEmpMain = class(TfmRBMainGrid)
    pnLink: TPanel;
    splBottom: TSplitter;
    dsEmpConnect: TDataSource;
    qrEmpConnect: TIBQuery;
    ibtranEmpConnect: TIBTransaction;
    qrEmpsciencename: TIBQuery;
    ibtranEmpsciencename: TIBTransaction;
    dsEmpsciencename: TDataSource;
    qrEmplanguage: TIBQuery;
    ibtranEmplanguage: TIBTransaction;
    dsEmplanguage: TDataSource;
    dsChildren: TDataSource;
    qrEmpChildren: TIBQuery;
    ibtranChildren: TIBTransaction;
    dsEmpProperty: TDataSource;
    qrEmpProperty: TIBQuery;
    ibtranEmpProperty: TIBTransaction;
    dsEmpStreet: TDataSource;
    qrEmpStreet: TIBQuery;
    ibtranEmpStreet: TIBTransaction;
    dsEmpPersonDoc: TDataSource;
    qrEmpPersonDoc: TIBQuery;
    ibtranEmpPersonDoc: TIBTransaction;
    dsEmpMilitary: TDataSource;
    qrEmpMilitary: TIBQuery;
    ibtranEmpMilitary: TIBTransaction;
    dsEmpDiplom: TDataSource;
    qrEmpDiplom: TIBQuery;
    ibtranEmpDiplom: TIBTransaction;
    dsEmpBiography: TDataSource;
    qrEmpBiography: TIBQuery;
    ibtranEmpBiography: TIBTransaction;
    dsEmpPhoto: TDataSource;
    qrEmpPhoto: TIBQuery;
    ibtranEmpPhoto: TIBTransaction;
    dsEmpPlant: TDataSource;
    qrEmpPlant: TIBQuery;
    ibtranEmpPlant: TIBTransaction;
    pmAdjust: TPopupMenu;
    miAdjustColumns: TMenuItem;
    miAdjustTabs: TMenuItem;
    grbLink: TGroupBox;
    pngrbLink: TPanel;
    pgLink: TPageControl;
    tbsEmpConnect: TTabSheet;
    pnEmpConnect: TPanel;
    pnButEmpConnect: TPanel;
    bibAddEmpConnect: TBitBtn;
    bibChangeEmpConnect: TBitBtn;
    bibDelEmpConnect: TBitBtn;
    bibAdjustEmpConnect: TBitBtn;
    tbsEmpsciencename: TTabSheet;
    pnEmpsciencename: TPanel;
    pnButEmpsciencename: TPanel;
    bibAddEmpsciencename: TBitBtn;
    bibChangeEmpsciencename: TBitBtn;
    bibDelEmpsciencename: TBitBtn;
    bibAdjustEmpsciencename: TBitBtn;
    tbsEmplanguage: TTabSheet;
    pnEmplanguage: TPanel;
    pnButEmplanguage: TPanel;
    bibAddEmplanguage: TBitBtn;
    bibChangeEmplanguage: TBitBtn;
    bibDelEmplanguage: TBitBtn;
    bibAdjustEmplanguage: TBitBtn;
    tbsEmpChildren: TTabSheet;
    pnChildren: TPanel;
    pnButChildren: TPanel;
    bibAddEmpChildren: TBitBtn;
    bibChangeEmpChildren: TBitBtn;
    bibDelEmpChildren: TBitBtn;
    bibAdjustEmpChildren: TBitBtn;
    tbsEmpproperty: TTabSheet;
    pnEmpProperty: TPanel;
    pnButEmpProperty: TPanel;
    bibAddEmpProperty: TBitBtn;
    bibChangeEmpProperty: TBitBtn;
    bibDelEmpProperty: TBitBtn;
    bibAdjustEmpProperty: TBitBtn;
    tbsEmpStreet: TTabSheet;
    pnEmpStreet: TPanel;
    pnButEmpStreet: TPanel;
    bibAddEmpStreet: TBitBtn;
    bibChangeEmpStreet: TBitBtn;
    bibDelEmpStreet: TBitBtn;
    bibAdjustEmpStreet: TBitBtn;
    tbsEmpPersonDoc: TTabSheet;
    pnEmpPersonDoc: TPanel;
    pnButEmpPersonDoc: TPanel;
    bibAddEmpPersonDoc: TBitBtn;
    bibChangeEmpPersonDoc: TBitBtn;
    bibDelEmpPersonDoc: TBitBtn;
    bibAdjustEmpPersonDoc: TBitBtn;
    tbsEmpMilitary: TTabSheet;
    pnEmpMilitary: TPanel;
    pnButEmpMilitary: TPanel;
    bibAddEmpMilitary: TBitBtn;
    bibChangeEmpMilitary: TBitBtn;
    bibDelEmpMilitary: TBitBtn;
    bibAdjustEmpMilitary: TBitBtn;
    tbsEmpDiplom: TTabSheet;
    pnEmpDiplom: TPanel;
    pnButEmpDiplom: TPanel;
    bibAddEmpDiplom: TBitBtn;
    bibChangeEmpDiplom: TBitBtn;
    bibDelEmpDiplom: TBitBtn;
    bibAdjustEmpDiplom: TBitBtn;
    tbsEmpBiography: TTabSheet;
    pnEmpBiography: TPanel;
    splEmpBiography: TSplitter;
    pnButEmpBiography: TPanel;
    bibAddEmpBiography: TBitBtn;
    bibChangeEmpBiography: TBitBtn;
    bibDelEmpBiography: TBitBtn;
    bibAdjustEmpBiography: TBitBtn;
    grbEmpBiography: TGroupBox;
    pngrbEmpBiography: TPanel;
    dbmeEmpBiography: TDBMemo;
    tbsEmpPhoto: TTabSheet;
    pnEmpPhoto: TPanel;
    Splitter1: TSplitter;
    pnButEmpPhoto: TPanel;
    bibAddEmpPhoto: TBitBtn;
    bibChangeEmpPhoto: TBitBtn;
    bibDelEmpPhoto: TBitBtn;
    bibAdjustEmpPhoto: TBitBtn;
    grbEmpPhoto: TGroupBox;
    pngrbEmpPhoto: TPanel;
    chbPhotoStretch: TCheckBox;
    srlbxPhoto: TScrollBox;
    imPhoto: TImage;
    tbsEmpPlant: TTabSheet;
    pnEmpPlant: TPanel;
    pnButEmpPlant: TPanel;
    bibAddEmpPlant: TBitBtn;
    bibChangeEmpPlant: TBitBtn;
    bibDelEmpPlant: TBitBtn;
    bibAdjustEmpPlant: TBitBtn;
    tbsEmpFaceAccount: TTabSheet;
    pnEmpFaceAccount: TPanel;
    pnButEmpFaceAccount: TPanel;
    bibAddEmpFaceAccount: TBitBtn;
    bibChangeEmpFaceAccount: TBitBtn;
    bibDelEmpFaceAccount: TBitBtn;
    bibAdjustEmpFaceAccount: TBitBtn;
    dsEmpFaceAccount: TDataSource;
    qrEmpFaceAccount: TIBQuery;
    ibtranEmpFaceAccount: TIBTransaction;
    tbsEmpSickList: TTabSheet;
    dsEmpSickList: TDataSource;
    qrEmpSickList: TIBQuery;
    ibtranEmpSickList: TIBTransaction;
    pnEmpSickList: TPanel;
    pnButEmpSickList: TPanel;
    bibAddEmpSickList: TBitBtn;
    bibChangeEmpSickList: TBitBtn;
    bibDelEmpSickList: TBitBtn;
    bibAdjustEmpSickList: TBitBtn;
    tbsEmpLaborBook: TTabSheet;
    pnEmpLaborBook: TPanel;
    splEmpLaborBook: TSplitter;
    pnButEmpLaborBook: TPanel;
    bibAddEmpLaborBook: TBitBtn;
    bibChangeEmpLaborBook: TBitBtn;
    bibDelEmpLaborBook: TBitBtn;
    bibAdjustEmpLaborBook: TBitBtn;
    grbEmpLaborBook: TGroupBox;
    pngrbEmpLaborBook: TPanel;
    dbmepngrbEmpLaborBook: TDBMemo;
    dsEmpLaborBook: TDataSource;
    qrEmpLaborBook: TIBQuery;
    ibtranEmpLaborBook: TIBTransaction;
    tbsEmpRefreshCourse: TTabSheet;
    pnEmpRefreshCourse: TPanel;
    pnButEmpRefreshCourse: TPanel;
    bibAddEmpRefreshCourse: TBitBtn;
    bibChangeEmpRefreshCourse: TBitBtn;
    bibDelEmpRefreshCourse: TBitBtn;
    bibAdjustEmpRefreshCourse: TBitBtn;
    dsEmpRefreshCourse: TDataSource;
    qrEmpRefreshCourse: TIBQuery;
    ibtranEmpRefreshCourse: TIBTransaction;
    tbsEmpLeave: TTabSheet;
    pnEmpLeave: TPanel;
    pnButEmpLeave: TPanel;
    bibAddEmpLeave: TBitBtn;
    bibChangeEmpLeave: TBitBtn;
    bibDelEmpLeave: TBitBtn;
    bibAdjustEmpLeave: TBitBtn;
    dsEmpLeave: TDataSource;
    qrEmpLeave: TIBQuery;
    ibtranEmpLeave: TIBTransaction;
    tbsEmpQual: TTabSheet;
    pnEmpQual: TPanel;
    pnButEmpQual: TPanel;
    bibAddEmpQual: TBitBtn;
    bibChangeEmpQual: TBitBtn;
    bibDelEmpQual: TBitBtn;
    bibAdjustEmpQual: TBitBtn;
    dsEmpQual: TDataSource;
    qrEmpQual: TIBQuery;
    ibtranEmpQual: TIBTransaction;
    tbsEmpEncouragements: TTabSheet;
    pnEmpEncouragements: TPanel;
    pnButEmpEncouragements: TPanel;
    bibAddEmpEncouragements: TBitBtn;
    bibChangeEmpEncouragements: TBitBtn;
    bibDelEmpEncouragements: TBitBtn;
    bibAdjustEmpEncouragements: TBitBtn;
    dsEmpEncouragements: TDataSource;
    qrEmpEncouragements: TIBQuery;
    ibtranEmpEncouragements: TIBTransaction;
    tbsEmpBustripsfromus: TTabSheet;
    pnEmpBustripsfromus: TPanel;
    pnButEmpBustripsfromus: TPanel;
    bibAddEmpBustripsfromus: TBitBtn;
    bibChangeEmpBustripsfromus: TBitBtn;
    bibDelEmpBustripsfromus: TBitBtn;
    bibAdjustEmpBustripsfromus: TBitBtn;
    dsEmpBustripsfromus: TDataSource;
    qrEmpBustripsfromus: TIBQuery;
    ibtranEmpBustripsfromus: TIBTransaction;
    tbsEmpReferences: TTabSheet;
    pnButempreferences: TPanel;
    bibAddempreferences: TBitBtn;
    bibChangeempreferences: TBitBtn;
    bibDelempreferences: TBitBtn;
    bibAdjustempreferences: TBitBtn;
    pnempreferences: TPanel;
    dsempreferences: TDataSource;
    qrempreferences: TIBQuery;
    ibtranEmpReferences: TIBTransaction;
    miAll: TMenuItem;
    BitBtn1: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure bibAddEmpConnectClick(Sender: TObject);
    procedure bibChangeEmpConnectClick(Sender: TObject);
    procedure bibDelEmpConnectClick(Sender: TObject);
    procedure bibAddEmpsciencenameClick(Sender: TObject);
    procedure bibChangeEmpsciencenameClick(Sender: TObject);
    procedure bibDelEmpsciencenameClick(Sender: TObject);
    procedure bibAddEmplanguageClick(Sender: TObject);
    procedure bibChangeEmplanguageClick(Sender: TObject);
    procedure bibDelEmplanguageClick(Sender: TObject);
    procedure bibAddEmpChildrenClick(Sender: TObject);
    procedure bibChangeEmpChildrenClick(Sender: TObject);
    procedure pgLinkChange(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibDelEmpChildrenClick(Sender: TObject);
    procedure bibAddEmpPropertyClick(Sender: TObject);
    procedure bibChangeEmpPropertyClick(Sender: TObject);
    procedure bibDelEmpPropertyClick(Sender: TObject);
    procedure bibAddEmpStreetClick(Sender: TObject);
    procedure bibChangeEmpStreetClick(Sender: TObject);
    procedure bibDelEmpStreetClick(Sender: TObject);
    procedure bibAddEmpPersonDocClick(Sender: TObject);
    procedure bibChangeEmpPersonDocClick(Sender: TObject);
    procedure bibDelEmpPersonDocClick(Sender: TObject);
    procedure bibAddEmpMilitaryClick(Sender: TObject);
    procedure bibChangeEmpMilitaryClick(Sender: TObject);
    procedure bibDelEmpMilitaryClick(Sender: TObject);
    procedure bibAddEmpDiplomClick(Sender: TObject);
    procedure bibChangeEmpDiplomClick(Sender: TObject);
    procedure bibDelEmpDiplomClick(Sender: TObject);
    procedure bibAdjustEmpConnectClick(Sender: TObject);
    procedure bibAddEmpBiographyClick(Sender: TObject);
    procedure bibChangeEmpBiographyClick(Sender: TObject);
    procedure bibDelEmpBiographyClick(Sender: TObject);
    procedure bibAddEmpPhotoClick(Sender: TObject);
    procedure chbPhotoStretchClick(Sender: TObject);
    procedure qrEmpPhotoAfterScroll(DataSet: TDataSet);
    procedure bibChangeEmpPhotoClick(Sender: TObject);
    procedure bibDelEmpPhotoClick(Sender: TObject);
    procedure bibAddEmpPlantClick(Sender: TObject);
    procedure bibChangeEmpPlantClick(Sender: TObject);
    procedure bibDelEmpPlantClick(Sender: TObject);
    procedure bibAdjustClick(Sender: TObject);
    procedure miAdjustColumnsClick(Sender: TObject);
    procedure miAdjustTabsClick(Sender: TObject);
    procedure imPhotoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imPhotoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imPhotoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bibAddEmpFaceAccountClick(Sender: TObject);
    procedure bibChangeEmpFaceAccountClick(Sender: TObject);
    procedure bibDelEmpFaceAccountClick(Sender: TObject);
    procedure bibAddEmpSickListClick(Sender: TObject);
    procedure bibChangeEmpSickListClick(Sender: TObject);
    procedure bibDelEmpSickListClick(Sender: TObject);
    procedure bibAddEmpLaborBookClick(Sender: TObject);
    procedure bibChangeEmpLaborBookClick(Sender: TObject);
    procedure bibDelEmpLaborBookClick(Sender: TObject);
    procedure bibAddEmpRefreshCourseClick(Sender: TObject);
    procedure bibChangeEmpRefreshCourseClick(Sender: TObject);
    procedure bibDelEmpRefreshCourseClick(Sender: TObject);
    procedure bibAddEmpLeaveClick(Sender: TObject);
    procedure bibChangeEmpLeaveClick(Sender: TObject);
    procedure bibDelEmpLeaveClick(Sender: TObject);
    procedure bibAddEmpQualClick(Sender: TObject);
    procedure bibChangeEmpQualClick(Sender: TObject);
    procedure bibDelEmpQualClick(Sender: TObject);
    procedure bibAddEmpEncouragementsClick(Sender: TObject);
    procedure bibChangeEmpEncouragementsClick(Sender: TObject);
    procedure bibDelEmpEncouragementsClick(Sender: TObject);
    procedure bibAddEmpBustripsfromusClick(Sender: TObject);
    procedure bibChangeEmpBustripsfromusClick(Sender: TObject);
    procedure bibDelEmpBustripsfromusClick(Sender: TObject);
    procedure bibAddempreferencesClick(Sender: TObject);
    procedure bibChangeempreferencesClick(Sender: TObject);
    procedure bibDelempreferencesClick(Sender: TObject);
    procedure miAllClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    LastOrderStrEmpConnect: string;
    LastOrderStrEmpsciencename: string;
    LastOrderStrEmplanguage: string;
    LastOrderStrEmpChildren: string;
    LastOrderStrEmpProperty: string;
    LastOrderStrEmpStreet: string;
    LastOrderStrEmpPersonDoc: string;
    LastOrderStrEmpMilitary: string;
    LastOrderStrEmpDiplom: string;
    LastOrderStrEmpBiography: string;
    LastOrderStrEmpPhoto: string;
    LastOrderStrEmpPlant: string;
    LastOrderStrEmpFaceAccount: string;
    LastOrderStrEmpSickList: string;
    LastOrderStrEmpLaborBook: string;
    LastOrderStrEmpRefreshCourse: string;
    LastOrderStrEmpLeave: string;
    LastOrderStrEmpQual: string;
    LastOrderStrEmpEncouragements: string;
    LastOrderStrEmpBustripsfromus: string;
    LastOrderStrEmpReferences: string;

    isFindFName,isFindName,isFindSName,isFindSex,
    isFindFamilyStateName,isFindNationName,isFindTownName,
    isFindInn,isFindCountryName,isFindRegionName,isFindStateName,
    isFindPlaceMentName: Boolean;
    FindFName,FindName,FindSName,FindInn,
    FindFamilyStateName,FindNationName,FindTownName,FindPlaceMentName,
    FindCountryName,FindRegionName,FindStateName: String;
    FindSex: string;
    isFindRelease: Boolean;
    FindRelease: Integer;
    isTown: Boolean;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                 DataCol: Integer; Column: TColumn;
                                 State: TGridDrawState);
    procedure GridDblClickEmpConnect(Sender: TObject);
    procedure GridDblClickEmpsciencename(Sender: TObject);
    procedure GridDblClickEmpLanguage(Sender: TObject);
    procedure GridDblClickEmpChildren(Sender: TObject);
    procedure GridDblClickEmpProperty(Sender: TObject);
    procedure GridDblClickEmpStreet(Sender: TObject);
    procedure GridDblClickEmpPersonDoc(Sender: TObject);
    procedure GridDblClickEmpMilitary(Sender: TObject);
    procedure GridDblClickEmpDiplom(Sender: TObject);
    procedure GridDblClickEmpBiography(Sender: TObject);
    procedure GridDblClickEmpPhoto(Sender: TObject);
    procedure GridDblClickEmpPlant(Sender: TObject);
    procedure GridDblClickEmpFaceAccount(Sender: TObject);
    procedure GridDblClickEmpSickList(Sender: TObject);
    procedure GridDblClickEmpLaborBook(Sender: TObject);
    procedure GridDrawColumnCellEmpLaborBook(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridDblClickEmpRefreshCourse(Sender: TObject);
    procedure GridDblClickEmpLeave(Sender: TObject);
    procedure GridDblClickEmpQual(Sender: TObject);
    procedure GridDblClickEmpEncouragements(Sender: TObject);
    procedure GridDblClickEmpBustripsfromus(Sender: TObject);
    procedure GridDrawColumnCellEmpBustripsfromus(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridDblClickEmpReferences(Sender: TObject);
    procedure GridDrawColumnCellEmpReferences(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  protected
    PointClicked: TPoint;
    FoldPosX, FoldPosY: Integer;

    GridEmpConnect: TNewDbGrid;
    GridEmpsciencename: TNewDbGrid;
    GridEmplanguage: TNewDbGrid;
    GridEmpChildren: TNewDbGrid;
    GridEmpProperty: TNewDbGrid;
    GridEmpStreet: TNewDbGrid;
    GridEmpPersonDoc: TNewDbGrid;
    GridEmpMilitary: TNewDbGrid;
    GridEmpDiplom: TNewDbGrid;
    GridEmpBiography: TNewDbGrid;
    GridEmpPhoto: TNewDbGrid;
    GridEmpPlant: TNewDbGrid;
    GridEmpFaceAccount: TNewDbGrid;
    GridEmpSickList: TNewDbGrid;
    GridEmpLaborBook: TNewDbGrid;
    GridEmpRefreshCourse: TNewDbGrid;
    GridEmpLeave: TNewDbGrid;
    GridEmpQual: TNewDbGrid;
    GridEmpEncouragements: TNewDbGrid;
    GridEmpBustripsfromus: TNewDbGrid;
    GridEmpReferences: TNewDbGrid;
    TmpGrid: TNewDbGrid;
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    procedure FillGridPopupMenu; override;
    procedure ActiveAll;
    function GetGridFromTabSheet(tbs: TTabSheet): TNewDbGrid;
    procedure SaveGridProperty(Grid: TNewDbGrid);
    procedure LoadGridProperty(Grid: TNewDbGrid);
    procedure VisibleAllTabSheets(Vis: Boolean);

  public

    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure GridTitleClickWithSortEmpConnect(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpConnect: String;
    procedure ActiveEmpConnect(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpsciencename(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpsciencename: String;
    procedure ActiveEmpsciencename(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpLanguage(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpLanguage: String;
    procedure ActiveEmpLanguage(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpChildren(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpChildren: String;
    procedure ActiveEmpChildren(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpProperty(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpProperty: String;
    procedure ActiveEmpProperty(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpStreet(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpStreet: String;
    procedure ActiveEmpStreet(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpPersonDoc(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpPersonDoc: String;
    procedure ActiveEmpPersonDoc(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpMilitary(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpMilitary: String;
    procedure ActiveEmpMilitary(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpDiplom(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpDiplom: String;
    procedure ActiveEmpDiplom(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpBiography(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpBiography: String;
    procedure ActiveEmpBiography(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpPhoto(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpPhoto: String;
    procedure ActiveEmpPhoto(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpPlant(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpPlant: String;
    procedure ActiveEmpPlant(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpFaceAccount(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpFaceAccount: String;
    procedure ActiveEmpFaceAccount(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpSickList(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpSickList: String;
    procedure ActiveEmpSickList(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpLaborBook(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpLaborBook: String;
    procedure ActiveEmpLaborBook(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpRefreshCourse(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpRefreshCourse: String;
    procedure ActiveEmpRefreshCourse(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpLeave(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpLeave: String;
    procedure ActiveEmpLeave(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpQual(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpQual: String;
    procedure ActiveEmpQual(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpEncouragements(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpEncouragements: String;
    procedure ActiveEmpEncouragements(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpBustripsfromus(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpBustripsfromus: String;
    procedure ActiveEmpBustripsfromus(CheckPerm: Boolean);

    procedure GridTitleClickWithSortEmpReferences(Column: TColumn; TypeSort: TTypeColumnSort);
    function GetSqlEmpReferences: String;
    procedure ActiveEmpReferences(CheckPerm: Boolean);

    procedure SetParamsFromOptions;
  end;

  TfmRBEmp=class(TfmRBEmpMain)
  public
    destructor Destroy; override;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface);override;
  end;

  TfmRBEmpConnect=class(TfmRBEmpMain)
  public
    CurInterface: THandle;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);override;
    procedure InitModalParams(hInterface: THandle; Param: PParamRBookInterface);override;
    procedure ReturnModalParams(Param: PParamRBookInterface);override;
    function CheckPermission: Boolean; override;
  end;

var
  fmRBEmp: TfmRBEmp;
  fmRBEmpConnect: TfmRBEmpConnect;

implementation

uses UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBEmp,
     UEditRBEmpConnect, UEditRBEmpScienceName, UEditRBEmpLanguage,
     UEditRBEmpChildren, UEditRBEmpProperty ,UEditRBEmpStreet,
     UEditRBEmpPersonDoc, UEditRBEmpMilitary, UEditRBEmpDiplom, tsvAdjust,
     UEditRBEmpBiography, UEditRBEmpPhoto, tsvPicture, UEditRBEmpPlant,
     UEditRBEmpFaceAccount, UEditRBEmpSickList, UEditRBEmpLaborBook,
     UEditRBEmpRefreshCourse, UEditRBEmpLeave, UEditRBEmpQual,
     UEditRBEmpEncouragements, UEditRBEmpBustripsfromus, UEditRBEmpReferences,
  UStaffTsvOptions;

{$R *.DFM}

function TfmRBEmpMain.GetGridFromTabSheet(tbs: TTabSheet): TNewDbGrid;
var
  BreakFlag: Boolean;
  retGrid: TNewDbGrid;

  procedure GetGrid(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
  begin
    if BreakFlag then exit;
    for i:=0 to wt.ControlCount-1 do begin
       ct:=wt.Controls[i];
       if ct is TNewDbGrid then begin
         retGrid:=TNewDbGrid(ct);
         BreakFlag:=true;
         exit;
       end;
       if ct is TWinControl then
         GetGrid(TWinControl(ct));
    end;
  end;

begin
  retGrid:=nil;
  Result:=nil;
  if tbs=nil then exit;
  BreakFlag:=false;
  GetGrid(tbs);
  Result:=retGrid;
end;

procedure TfmRBEmpMain.SaveGridProperty(Grid: TNewDbGrid);
begin
 if Grid=nil then exit;
 try
   SaveGridProp(Grid.Name,TDbGrid(Grid));
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.LoadGridProperty(Grid: TNewDbGrid);
begin
 if Grid=nil then exit;
 try
   LoadGridProp(Grid.name,TDbGrid(Grid));
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Screen.Cursors[crImageMove] := LoadCursor(HINSTANCE,CursorMove);
  Screen.Cursors[crImageDown] := LoadCursor(HINSTANCE,CursorDown);
  imPhoto.Cursor:=crImageMove;
  
  Caption:=NameRbkEmp;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  grid.OnDrawColumnCell:=GridDrawColumnCell;
  grid.Constraints.MinHeight:=30;
//  edSearch.TabOrder:=1;
  grid.TabOrder:=1;
  pnLink.TabOrder:=2;
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

  ibtranEmpConnect.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpConnect);
  qrEmpConnect.Database:=IBDB;

  GridEmpConnect:=TNewdbGrid.Create(self);
  GridEmpConnect.Parent:=pnEmpConnect;
  GridEmpConnect.Align:=alClient;
  GridEmpConnect.DataSource:=dsEmpConnect;
  GridEmpConnect.Name:='GridEmpConnect';
  GridEmpConnect.RowSelected.Visible:=true;
  GridEmpConnect.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpConnect.Font);
  GridEmpConnect.TitleFont.Assign(GridEmpConnect.Font);
  GridEmpConnect.RowSelected.Font.Assign(GridEmpConnect.Font);
  GridEmpConnect.RowSelected.Brush.Style:=bsClear;
  GridEmpConnect.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpConnect.RowSelected.Font.Color:=clWhite;
  GridEmpConnect.RowSelected.Pen.Style:=psClear;
  GridEmpConnect.CellSelected.Visible:=true;
  GridEmpConnect.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpConnect.CellSelected.Font.Assign(GridEmpConnect.Font);
  GridEmpConnect.CellSelected.Font.Color:=clHighlightText;
  GridEmpConnect.TitleCellMouseDown.Font.Assign(GridEmpConnect.Font);
  GridEmpConnect.Options:=GridEmpConnect.Options-[dgEditing]-[dgTabs];
  GridEmpConnect.ReadOnly:=true;
  GridEmpConnect.OnKeyDown:=FormKeyDown;
//  GridEmpConnect.OnTitleClick:=GridTitleClickEmpConnect;
  GridEmpConnect.OnTitleClickWithSort:=GridTitleClickWithSortEmpConnect;
  GridEmpConnect.OnDblClick:=GridDblClickEmpConnect;
  GridEmpConnect.TabOrder:=1;
  pnButEmpConnect.TabOrder:=2;


  cl:=GridEmpConnect.Columns.Add;
  cl.FieldName:='connectiontypename';
  cl.Title.Caption:='Тип связи';
  cl.Width:=150;

  cl:=GridEmpConnect.Columns.Add;
  cl.FieldName:='connectstring';
  cl.Title.Caption:='Строка связи';
  cl.Width:=200;

  LastOrderStrEmpConnect:=' order by ct.name ';

  ibtranEmpsciencename.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpsciencename);
  qrEmpsciencename.Database:=IBDB;

  GridEmpsciencename:=TNewdbGrid.Create(self);
  GridEmpsciencename.Parent:=pnEmpsciencename;
  GridEmpsciencename.Align:=alClient;
  GridEmpsciencename.DataSource:=dsEmpsciencename;
  GridEmpsciencename.Name:='GridEmpsciencename';
  GridEmpsciencename.RowSelected.Visible:=true;
  GridEmpsciencename.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpsciencename.Font);
  GridEmpsciencename.TitleFont.Assign(GridEmpsciencename.Font);
  GridEmpsciencename.RowSelected.Font.Assign(GridEmpsciencename.Font);
  GridEmpsciencename.RowSelected.Brush.Style:=bsClear;
  GridEmpsciencename.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpsciencename.RowSelected.Font.Color:=clWhite;
  GridEmpsciencename.RowSelected.Pen.Style:=psClear;
  GridEmpsciencename.CellSelected.Visible:=true;
  GridEmpsciencename.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpsciencename.CellSelected.Font.Assign(GridEmpsciencename.Font);
  GridEmpsciencename.CellSelected.Font.Color:=clHighlightText;
  GridEmpsciencename.TitleCellMouseDown.Font.Assign(GridEmpsciencename.Font);
  GridEmpsciencename.Options:=GridEmpsciencename.Options-[dgEditing]-[dgTabs];
  GridEmpsciencename.ReadOnly:=true;
  GridEmpsciencename.OnKeyDown:=FormKeyDown;
  GridEmpsciencename.OnTitleClickWithSort:=GridTitleClickWithSortEmpsciencename;
  GridEmpsciencename.OnDblClick:=GridDblClickEmpsciencename;
  GridEmpsciencename.TabOrder:=101;
  pnButEmpsciencename.TabOrder:=102;


  cl:=GridEmpsciencename.Columns.Add;
  cl.FieldName:='sciencename';
  cl.Title.Caption:='Ученое звание';
  cl.Width:=200;

  cl:=GridEmpsciencename.Columns.Add;
  cl.FieldName:='schoolname';
  cl.Title.Caption:='Учебное заведение';
  cl.Width:=200;

  LastOrderStrEmpsciencename:=' order by s.name ';

  ibtranEmplanguage.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmplanguage);
  qrEmplanguage.Database:=IBDB;

  GridEmplanguage:=TNewdbGrid.Create(self);
  GridEmplanguage.Parent:=pnEmplanguage;
  GridEmplanguage.Align:=alClient;
  GridEmplanguage.DataSource:=dsEmplanguage;
  GridEmplanguage.Name:='GridEmplanguage';
  GridEmplanguage.RowSelected.Visible:=true;
  GridEmplanguage.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmplanguage.Font);
  GridEmplanguage.TitleFont.Assign(GridEmplanguage.Font);
  GridEmplanguage.RowSelected.Font.Assign(GridEmplanguage.Font);
  GridEmplanguage.RowSelected.Brush.Style:=bsClear;
  GridEmplanguage.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmplanguage.RowSelected.Font.Color:=clWhite;
  GridEmplanguage.RowSelected.Pen.Style:=psClear;
  GridEmplanguage.CellSelected.Visible:=true;
  GridEmplanguage.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmplanguage.CellSelected.Font.Assign(GridEmplanguage.Font);
  GridEmplanguage.CellSelected.Font.Color:=clHighlightText;
  GridEmplanguage.TitleCellMouseDown.Font.Assign(GridEmplanguage.Font);
  GridEmplanguage.Options:=GridEmplanguage.Options-[dgEditing]-[dgTabs];
  GridEmplanguage.ReadOnly:=true;
  GridEmplanguage.OnKeyDown:=FormKeyDown;
  GridEmplanguage.OnTitleClickWithSort:=GridTitleClickWithSortEmplanguage;
  GridEmplanguage.OnDblClick:=GridDblClickEmplanguage;
  GridEmplanguage.TabOrder:=101;
  pnButEmplanguage.TabOrder:=102;

  cl:=GridEmplanguage.Columns.Add;
  cl.FieldName:='languagename';
  cl.Title.Caption:='Язык';
  cl.Width:=200;

  cl:=GridEmplanguage.Columns.Add;
  cl.FieldName:='knowlevelname';
  cl.Title.Caption:='Уровень знания';
  cl.Width:=150;

  LastOrderStrEmplanguage:=' order by l.name ';

  ibtranChildren.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranChildren);
  qrEmpChildren.Database:=IBDB;

  GridEmpChildren:=TNewdbGrid.Create(self);
  GridEmpChildren.Parent:=pnChildren;
  GridEmpChildren.Align:=alClient;
  GridEmpChildren.DataSource:=dsChildren;
  GridEmpChildren.Name:='GridEmpChildren';
  GridEmpChildren.RowSelected.Visible:=true;
  GridEmpChildren.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpChildren.Font);
  GridEmpChildren.TitleFont.Assign(GridEmpChildren.Font);
  GridEmpChildren.RowSelected.Font.Assign(GridEmpChildren.Font);
  GridEmpChildren.RowSelected.Brush.Style:=bsClear;
  GridEmpChildren.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpChildren.RowSelected.Font.Color:=clWhite;
  GridEmpChildren.RowSelected.Pen.Style:=psClear;
  GridEmpChildren.CellSelected.Visible:=true;
  GridEmpChildren.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpChildren.CellSelected.Font.Assign(GridEmpChildren.Font);
  GridEmpChildren.CellSelected.Font.Color:=clHighlightText;
  GridEmpChildren.TitleCellMouseDown.Font.Assign(GridEmpChildren.Font);
  GridEmpChildren.Options:=GridEmpChildren.Options-[dgEditing]-[dgTabs];
  GridEmpChildren.ReadOnly:=true;
  GridEmpChildren.OnKeyDown:=FormKeyDown;
  GridEmpChildren.OnTitleClickWithSort:=GridTitleClickWithSortEmpChildren;
  GridEmpChildren.OnDblClick:=GridDblClickEmpChildren;
  GridEmpChildren.TabOrder:=101;
  pnButChildren.TabOrder:=102;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='fname';
  cl.Title.Caption:='Фамилия';
  cl.Width:=150;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Имя';
  cl.Width:=100;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='sname';
  cl.Title.Caption:='Отчество';
  cl.Width:=150;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='birthdate';
  cl.Title.Caption:='Дата рождения';
  cl.Width:=100;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='address';
  cl.Title.Caption:='Адрес';
  cl.Width:=100;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='workplace';
  cl.Title.Caption:='Место работы или учебы';
  cl.Width:=100;

  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='typerelationname';
  cl.Title.Caption:='Категория родственника';
  cl.Width:=100;

{  cl:=GridEmpChildren.Columns.Add;
  cl.FieldName:='sexname';
  cl.Title.Caption:='Пол';
  cl.Width:=60;}

  LastOrderStrEmpChildren:=' order by fname ';

  ibtranEmpProperty.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpProperty);
  qrEmpProperty.Database:=IBDB;

  GridEmpProperty:=TNewdbGrid.Create(self);
  GridEmpProperty.Parent:=pnEmpProperty;
  GridEmpProperty.Align:=alClient;
  GridEmpProperty.DataSource:=dsEmpProperty;
  GridEmpProperty.Name:='GridEmpProperty';
  GridEmpProperty.RowSelected.Visible:=true;
  GridEmpProperty.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpProperty.Font);
  GridEmpProperty.TitleFont.Assign(GridEmpProperty.Font);
  GridEmpProperty.RowSelected.Font.Assign(GridEmpProperty.Font);
  GridEmpProperty.RowSelected.Brush.Style:=bsClear;
  GridEmpProperty.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpProperty.RowSelected.Font.Color:=clWhite;
  GridEmpProperty.RowSelected.Pen.Style:=psClear;
  GridEmpProperty.CellSelected.Visible:=true;
  GridEmpProperty.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpProperty.CellSelected.Font.Assign(GridEmpProperty.Font);
  GridEmpProperty.CellSelected.Font.Color:=clHighlightText;
  GridEmpProperty.TitleCellMouseDown.Font.Assign(GridEmpProperty.Font);
  GridEmpProperty.Options:=GridEmpProperty.Options-[dgEditing]-[dgTabs];
  GridEmpProperty.ReadOnly:=true;
  GridEmpProperty.OnKeyDown:=FormKeyDown;
  GridEmpProperty.OnTitleClickWithSort:=GridTitleClickWithSortEmpProperty;
  GridEmpProperty.OnDblClick:=GridDblClickEmpProperty;
  GridEmpProperty.TabOrder:=101;
  pnButEmpProperty.TabOrder:=102;

  cl:=GridEmpProperty.Columns.Add;
  cl.FieldName:='propertyname';
  cl.Title.Caption:='Признак';
  cl.Width:=300;

  LastOrderStrEmpProperty:=' order by p.name ';

  ibtranEmpStreet.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpStreet);
  qrEmpStreet.Database:=IBDB;

  GridEmpStreet:=TNewdbGrid.Create(self);
  GridEmpStreet.Parent:=pnEmpStreet;
  GridEmpStreet.Align:=alClient;
  GridEmpStreet.DataSource:=dsEmpStreet;
  GridEmpStreet.Name:='GridEmpStreet';
  GridEmpStreet.RowSelected.Visible:=true;
  GridEmpStreet.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpStreet.Font);
  GridEmpStreet.TitleFont.Assign(GridEmpStreet.Font);
  GridEmpStreet.RowSelected.Font.Assign(GridEmpStreet.Font);
  GridEmpStreet.RowSelected.Brush.Style:=bsClear;
  GridEmpStreet.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpStreet.RowSelected.Font.Color:=clWhite;
  GridEmpStreet.RowSelected.Pen.Style:=psClear;
  GridEmpStreet.CellSelected.Visible:=true;
  GridEmpStreet.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpStreet.CellSelected.Font.Assign(GridEmpStreet.Font);
  GridEmpStreet.CellSelected.Font.Color:=clHighlightText;
  GridEmpStreet.TitleCellMouseDown.Font.Assign(GridEmpStreet.Font);
  GridEmpStreet.Options:=GridEmpStreet.Options-[dgEditing]-[dgTabs];
  GridEmpStreet.ReadOnly:=true;
  GridEmpStreet.OnKeyDown:=FormKeyDown;
  GridEmpStreet.OnTitleClickWithSort:=GridTitleClickWithSortEmpStreet;
  GridEmpStreet.OnDblClick:=GridDblClickEmpStreet;
  GridEmpStreet.TabOrder:=101;
  pnButEmpStreet.TabOrder:=102;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='countryname';
  cl.Title.Caption:='Страна';
  cl.Width:=100;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='regionname';
  cl.Title.Caption:='Край, область';
  cl.Width:=100;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='statename';
  cl.Title.Caption:='Район';
  cl.Width:=100;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='townname';
  cl.Title.Caption:='Город';
  cl.Width:=150;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='placementname';
  cl.Title.Caption:='Нас. пункт';
  cl.Width:=100;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='streetname';
  cl.Title.Caption:='Улица';
  cl.Width:=150;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='housenum';
  cl.Title.Caption:='Номер дома';
  cl.Width:=60;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='buildnum';
  cl.Title.Caption:='Номер корпуса';
  cl.Width:=60;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='flatnum';
  cl.Title.Caption:='Номер квартиры';
  cl.Width:=60;

  cl:=GridEmpStreet.Columns.Add;
  cl.FieldName:='typelivename';
  cl.Title.Caption:='Тип проживания';
  cl.Width:=100;

  LastOrderStrEmpStreet:=' order by s.name ';

  ibtranEmpPersonDoc.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpPersonDoc);
  qrEmpPersonDoc.Database:=IBDB;

  GridEmpPersonDoc:=TNewdbGrid.Create(self);
  GridEmpPersonDoc.Parent:=pnEmpPersonDoc;
  GridEmpPersonDoc.Align:=alClient;
  GridEmpPersonDoc.DataSource:=dsEmpPersonDoc;
  GridEmpPersonDoc.Name:='GridEmpPersonDoc';
  GridEmpPersonDoc.RowSelected.Visible:=true;
  GridEmpPersonDoc.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpPersonDoc.Font);
  GridEmpPersonDoc.TitleFont.Assign(GridEmpPersonDoc.Font);
  GridEmpPersonDoc.RowSelected.Font.Assign(GridEmpPersonDoc.Font);
  GridEmpPersonDoc.RowSelected.Brush.Style:=bsClear;
  GridEmpPersonDoc.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpPersonDoc.RowSelected.Font.Color:=clWhite;
  GridEmpPersonDoc.RowSelected.Pen.Style:=psClear;
  GridEmpPersonDoc.CellSelected.Visible:=true;
  GridEmpPersonDoc.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpPersonDoc.CellSelected.Font.Assign(GridEmpPersonDoc.Font);
  GridEmpPersonDoc.CellSelected.Font.Color:=clHighlightText;
  GridEmpPersonDoc.TitleCellMouseDown.Font.Assign(GridEmpPersonDoc.Font);
  GridEmpPersonDoc.Options:=GridEmpPersonDoc.Options-[dgEditing]-[dgTabs];
  GridEmpPersonDoc.ReadOnly:=true;
  GridEmpPersonDoc.OnKeyDown:=FormKeyDown;
  GridEmpPersonDoc.OnTitleClickWithSort:=GridTitleClickWithSortEmpPersonDoc;
  GridEmpPersonDoc.OnDblClick:=GridDblClickEmpPersonDoc;
  GridEmpPersonDoc.TabOrder:=101;
  pnButEmpPersonDoc.TabOrder:=102;

  cl:=GridEmpPersonDoc.Columns.Add;
  cl.FieldName:='persondoctypename';
  cl.Title.Caption:='Тип документа';
  cl.Width:=150;

  cl:=GridEmpPersonDoc.Columns.Add;
  cl.FieldName:='serial';
  cl.Title.Caption:='Серия';
  cl.Width:=60;

  cl:=GridEmpPersonDoc.Columns.Add;
  cl.FieldName:='num';
  cl.Title.Caption:='Номер';
  cl.Width:=60;

  cl:=GridEmpPersonDoc.Columns.Add;
  cl.FieldName:='datewhere';
  cl.Title.Caption:='Дата выдачи';
  cl.Width:=70;

  cl:=GridEmpPersonDoc.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Кем выдан';
  cl.Width:=150;

  LastOrderStrEmpPersonDoc:=' order by pdt.name ';

  ibtranEmpMilitary.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpMilitary);
  qrEmpMilitary.Database:=IBDB;

  GridEmpMilitary:=TNewdbGrid.Create(self);
  GridEmpMilitary.Parent:=pnEmpMilitary;
  GridEmpMilitary.Align:=alClient;
  GridEmpMilitary.DataSource:=dsEmpMilitary;
  GridEmpMilitary.Name:='GridEmpMilitary';
  GridEmpMilitary.RowSelected.Visible:=true;
  GridEmpMilitary.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpMilitary.Font);
  GridEmpMilitary.TitleFont.Assign(GridEmpMilitary.Font);
  GridEmpMilitary.RowSelected.Font.Assign(GridEmpMilitary.Font);
  GridEmpMilitary.RowSelected.Brush.Style:=bsClear;
  GridEmpMilitary.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpMilitary.RowSelected.Font.Color:=clWhite;
  GridEmpMilitary.RowSelected.Pen.Style:=psClear;
  GridEmpMilitary.CellSelected.Visible:=true;
  GridEmpMilitary.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpMilitary.CellSelected.Font.Assign(GridEmpMilitary.Font);
  GridEmpMilitary.CellSelected.Font.Color:=clHighlightText;
  GridEmpMilitary.TitleCellMouseDown.Font.Assign(GridEmpMilitary.Font);
  GridEmpMilitary.Options:=GridEmpMilitary.Options-[dgEditing]-[dgTabs];
  GridEmpMilitary.ReadOnly:=true;
  GridEmpMilitary.OnKeyDown:=FormKeyDown;
  GridEmpMilitary.OnTitleClickWithSort:=GridTitleClickWithSortEmpMilitary;
  GridEmpMilitary.OnDblClick:=GridDblClickEmpMilitary;
  GridEmpMilitary.TabOrder:=101;
  pnButEmpMilitary.TabOrder:=102;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='milrankname';
  cl.Title.Caption:='Воинское звание';
  cl.Width:=150;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='rankname';
  cl.Title.Caption:='Состав';
  cl.Width:=60;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='groupmilname';
  cl.Title.Caption:='Группа';
  cl.Width:=60;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='readyname';
  cl.Title.Caption:='Годность';
  cl.Width:=70;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Военкомат';
  cl.Width:=150;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='craftnum';
  cl.Title.Caption:='Специальность';
  cl.Width:=150;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='specinclude';
  cl.Title.Caption:='Спец. учет';
  cl.Width:=150;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='mob';
  cl.Title.Caption:='МОБ предписание';
  cl.Width:=150;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Начало службы';
  cl.Width:=80;

  cl:=GridEmpMilitary.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Конец службы';
  cl.Width:=80;

  LastOrderStrEmpMilitary:=' order by mr.name ';

  ibtranEmpDiplom.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpDiplom);
  qrEmpDiplom.Database:=IBDB;

  GridEmpDiplom:=TNewdbGrid.Create(self);
  GridEmpDiplom.Parent:=pnEmpDiplom;
  GridEmpDiplom.Align:=alClient;
  GridEmpDiplom.DataSource:=dsEmpDiplom;
  GridEmpDiplom.Name:='GridEmpDiplom';
  GridEmpDiplom.RowSelected.Visible:=true;
  GridEmpDiplom.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpDiplom.Font);
  GridEmpDiplom.TitleFont.Assign(GridEmpDiplom.Font);
  GridEmpDiplom.RowSelected.Font.Assign(GridEmpDiplom.Font);
  GridEmpDiplom.RowSelected.Brush.Style:=bsClear;
  GridEmpDiplom.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpDiplom.RowSelected.Font.Color:=clWhite;
  GridEmpDiplom.RowSelected.Pen.Style:=psClear;
  GridEmpDiplom.CellSelected.Visible:=true;
  GridEmpDiplom.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpDiplom.CellSelected.Font.Assign(GridEmpDiplom.Font);
  GridEmpDiplom.CellSelected.Font.Color:=clHighlightText;
  GridEmpDiplom.TitleCellMouseDown.Font.Assign(GridEmpDiplom.Font);
  GridEmpDiplom.Options:=GridEmpDiplom.Options-[dgEditing]-[dgTabs];
  GridEmpDiplom.ReadOnly:=true;
  GridEmpDiplom.OnKeyDown:=FormKeyDown;
  GridEmpDiplom.OnTitleClickWithSort:=GridTitleClickWithSortEmpDiplom;
  GridEmpDiplom.OnDblClick:=GridDblClickEmpDiplom;
  GridEmpDiplom.TabOrder:=101;
  pnButEmpDiplom.TabOrder:=102;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='educname';
  cl.Title.Caption:='Вид образования';
  cl.Width:=80;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='schoolname';
  cl.Title.Caption:='Учебное заведение';
  cl.Width:=100;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='craftname';
  cl.Title.Caption:='Квалификация';
  cl.Width:=100;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='typestudname';
  cl.Title.Caption:='Вид обучения';
  cl.Width:=80;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='professionname';
  cl.Title.Caption:='Специальность';
  cl.Width:=100;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='num';
  cl.Title.Caption:='Номер';
  cl.Width:=60;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='datewhere';
  cl.Title.Caption:='Дата выдачи';
  cl.Width:=80;

  cl:=GridEmpDiplom.Columns.Add;
  cl.FieldName:='finishdate';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=80;

  LastOrderStrEmpDiplom:=' order by p.name ';

  ibtranEmpBiography.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpBiography);
  qrEmpBiography.Database:=IBDB;

  GridEmpBiography:=TNewdbGrid.Create(self);
  GridEmpBiography.Parent:=pnEmpBiography;
  GridEmpBiography.Align:=alClient;
  GridEmpBiography.DataSource:=dsEmpBiography;
  GridEmpBiography.Name:='GridEmpBiography';
  GridEmpBiography.RowSelected.Visible:=true;
  GridEmpBiography.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpBiography.Font);
  GridEmpBiography.TitleFont.Assign(GridEmpBiography.Font);
  GridEmpBiography.RowSelected.Font.Assign(GridEmpBiography.Font);
  GridEmpBiography.RowSelected.Brush.Style:=bsClear;
  GridEmpBiography.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpBiography.RowSelected.Font.Color:=clWhite;
  GridEmpBiography.RowSelected.Pen.Style:=psClear;
  GridEmpBiography.CellSelected.Visible:=true;
  GridEmpBiography.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpBiography.CellSelected.Font.Assign(GridEmpBiography.Font);
  GridEmpBiography.CellSelected.Font.Color:=clHighlightText;
  GridEmpBiography.TitleCellMouseDown.Font.Assign(GridEmpBiography.Font);
  GridEmpBiography.Options:=GridEmpBiography.Options-[dgEditing]-[dgTabs];
  GridEmpBiography.ReadOnly:=true;
  GridEmpBiography.OnKeyDown:=FormKeyDown;
  GridEmpBiography.OnTitleClickWithSort:=GridTitleClickWithSortEmpBiography;
  GridEmpBiography.OnDblClick:=GridDblClickEmpBiography;
  GridEmpBiography.TabOrder:=101;
  pnButEmpBiography.TabOrder:=102;

  cl:=GridEmpBiography.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=90;

  cl:=GridEmpBiography.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=90;

  LastOrderStrEmpBiography:=' order by datestart ';

  ibtranEmpPhoto.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpPhoto);
  qrEmpPhoto.Database:=IBDB;

  GridEmpPhoto:=TNewdbGrid.Create(self);
  GridEmpPhoto.Parent:=pnEmpPhoto;
  GridEmpPhoto.Align:=alClient;
  GridEmpPhoto.DataSource:=dsEmpPhoto;
  GridEmpPhoto.Name:='GridEmpPhoto';
  GridEmpPhoto.RowSelected.Visible:=true;
  GridEmpPhoto.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpPhoto.Font);
  GridEmpPhoto.TitleFont.Assign(GridEmpPhoto.Font);
  GridEmpPhoto.RowSelected.Font.Assign(GridEmpPhoto.Font);
  GridEmpPhoto.RowSelected.Brush.Style:=bsClear;
  GridEmpPhoto.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpPhoto.RowSelected.Font.Color:=clWhite;
  GridEmpPhoto.RowSelected.Pen.Style:=psClear;
  GridEmpPhoto.CellSelected.Visible:=true;
  GridEmpPhoto.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpPhoto.CellSelected.Font.Assign(GridEmpPhoto.Font);
  GridEmpPhoto.CellSelected.Font.Color:=clHighlightText;
  GridEmpPhoto.TitleCellMouseDown.Font.Assign(GridEmpPhoto.Font);
  GridEmpPhoto.Options:=GridEmpPhoto.Options-[dgEditing]-[dgTabs];
  GridEmpPhoto.ReadOnly:=true;
  GridEmpPhoto.OnKeyDown:=FormKeyDown;
  GridEmpPhoto.OnTitleClickWithSort:=GridTitleClickWithSortEmpPhoto;
  GridEmpPhoto.OnDblClick:=GridDblClickEmpPhoto;
  GridEmpPhoto.TabOrder:=101;
  pnButEmpPhoto.TabOrder:=102;

  cl:=GridEmpPhoto.Columns.Add;
  cl.FieldName:='datephoto';
  cl.Title.Caption:='Дата фотографии';
  cl.Width:=90;

  cl:=GridEmpPhoto.Columns.Add;
  cl.FieldName:='note';
  cl.Title.Caption:='Примечание';
  cl.Width:=200;

  LastOrderStrEmpPhoto:=' order by datephoto ';

  TControl(chbPhotoStretch).Align:=alBottom;
  srlbxPhoto.Align:=alClient;

  ibtranEmpPlant.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpPlant);
  qrEmpPlant.Database:=IBDB;

  GridEmpPlant:=TNewdbGrid.Create(self);
  GridEmpPlant.Parent:=pnEmpPlant;
  GridEmpPlant.Align:=alClient;
  GridEmpPlant.DataSource:=dsEmpPlant;
  GridEmpPlant.Name:='GridEmpPlant';
  GridEmpPlant.RowSelected.Visible:=true;
  GridEmpPlant.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
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
  GridEmpPlant.OnTitleClickWithSort:=GridTitleClickWithSortEmpPlant;
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
  cl.Title.Caption:='Дата уволнения';
  cl.Width:=100;

  LastOrderStrEmpPlant:=' order by p.smallname ';

  ibtranEmpFaceAccount.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpFaceAccount);
  qrEmpFaceAccount.Database:=IBDB;

  GridEmpFaceAccount:=TNewdbGrid.Create(self);
  GridEmpFaceAccount.Parent:=pnEmpFaceAccount;
  GridEmpFaceAccount.Align:=alClient;
  GridEmpFaceAccount.DataSource:=dsEmpFaceAccount;
  GridEmpFaceAccount.Name:='GridEmpFaceAccount';
  GridEmpFaceAccount.RowSelected.Visible:=true;
  GridEmpFaceAccount.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpFaceAccount.Font);
  GridEmpFaceAccount.TitleFont.Assign(GridEmpFaceAccount.Font);
  GridEmpFaceAccount.RowSelected.Font.Assign(GridEmpFaceAccount.Font);
  GridEmpFaceAccount.RowSelected.Brush.Style:=bsClear;
  GridEmpFaceAccount.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpFaceAccount.RowSelected.Font.Color:=clWhite;
  GridEmpFaceAccount.RowSelected.Pen.Style:=psClear;
  GridEmpFaceAccount.CellSelected.Visible:=true;
  GridEmpFaceAccount.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpFaceAccount.CellSelected.Font.Assign(GridEmpFaceAccount.Font);
  GridEmpFaceAccount.CellSelected.Font.Color:=clHighlightText;
  GridEmpFaceAccount.TitleCellMouseDown.Font.Assign(GridEmpFaceAccount.Font);
  GridEmpFaceAccount.Options:=GridEmpFaceAccount.Options-[dgEditing]-[dgTabs];
  GridEmpFaceAccount.ReadOnly:=true;
  GridEmpFaceAccount.OnKeyDown:=FormKeyDown;
  GridEmpFaceAccount.OnTitleClickWithSort:=GridTitleClickWithSortEmpFaceAccount;
  GridEmpFaceAccount.OnDblClick:=GridDblClickEmpFaceAccount;
  GridEmpFaceAccount.TabOrder:=101;
  pnButEmpFaceAccount.TabOrder:=102;

  cl:=GridEmpFaceAccount.Columns.Add;
  cl.FieldName:='num';
  cl.Title.Caption:='Номер счета';
  cl.Width:=100;

  cl:=GridEmpFaceAccount.Columns.Add;
  cl.FieldName:='bankname';
  cl.Title.Caption:='Банк';
  cl.Width:=130;

  cl:=GridEmpFaceAccount.Columns.Add;
  cl.FieldName:='currencyname';
  cl.Title.Caption:='Валюта';
  cl.Width:=100;

  cl:=GridEmpFaceAccount.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Процент';
  cl.Width:=60;

  cl:=GridEmpFaceAccount.Columns.Add;
  cl.FieldName:='summ';
  cl.Title.Caption:='Сумма';
  cl.Width:=100;

  LastOrderStrEmpFaceAccount:=' order by num ';

  ibtranEmpSickList.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpSickList);
  qrEmpSickList.Database:=IBDB;

  GridEmpSickList:=TNewdbGrid.Create(self);
  GridEmpSickList.Parent:=pnEmpSickList;
  GridEmpSickList.Align:=alClient;
  GridEmpSickList.DataSource:=dsEmpSickList;
  GridEmpSickList.Name:='GridEmpSickList';
  GridEmpSickList.RowSelected.Visible:=true;
  GridEmpSickList.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpSickList.Font);
  GridEmpSickList.TitleFont.Assign(GridEmpSickList.Font);
  GridEmpSickList.RowSelected.Font.Assign(GridEmpSickList.Font);
  GridEmpSickList.RowSelected.Brush.Style:=bsClear;
  GridEmpSickList.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpSickList.RowSelected.Font.Color:=clWhite;
  GridEmpSickList.RowSelected.Pen.Style:=psClear;
  GridEmpSickList.CellSelected.Visible:=true;
  GridEmpSickList.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpSickList.CellSelected.Font.Assign(GridEmpSickList.Font);
  GridEmpSickList.CellSelected.Font.Color:=clHighlightText;
  GridEmpSickList.TitleCellMouseDown.Font.Assign(GridEmpSickList.Font);
  GridEmpSickList.Options:=GridEmpSickList.Options-[dgEditing]-[dgTabs];
  GridEmpSickList.ReadOnly:=true;
  GridEmpSickList.OnKeyDown:=FormKeyDown;
  GridEmpSickList.OnTitleClickWithSort:=GridTitleClickWithSortEmpSickList;
  GridEmpSickList.OnDblClick:=GridDblClickEmpSickList;
  GridEmpSickList.TabOrder:=101;
  pnButEmpSickList.TabOrder:=102;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='sickname';
  cl.Title.Caption:='Болезнь';
  cl.Width:=150;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='num';
  cl.Title.Caption:='Номер б/л';
  cl.Width:=100;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='absencename';
  cl.Title.Caption:='Вид неявки';
  cl.Width:=100;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=100;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=100;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='percent';
  cl.Title.Caption:='Процент доплаты';
  cl.Width:=100;

  LastOrderStrEmpSickList:=' order by num ';

  ibtranEmpLaborBook.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpLaborBook);
  qrEmpLaborBook.Database:=IBDB;

  GridEmpLaborBook:=TNewdbGrid.Create(self);
  GridEmpLaborBook.Parent:=pnEmpLaborBook;
  GridEmpLaborBook.Align:=alClient;
  GridEmpLaborBook.DataSource:=dsEmpLaborBook;
  GridEmpLaborBook.Name:='GridEmpLaborBook';
  GridEmpLaborBook.RowSelected.Visible:=true;
  GridEmpLaborBook.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpLaborBook.Font);
  GridEmpLaborBook.TitleFont.Assign(GridEmpLaborBook.Font);
  GridEmpLaborBook.RowSelected.Font.Assign(GridEmpLaborBook.Font);
  GridEmpLaborBook.RowSelected.Brush.Style:=bsClear;
  GridEmpLaborBook.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpLaborBook.RowSelected.Font.Color:=clWhite;
  GridEmpLaborBook.RowSelected.Pen.Style:=psClear;
  GridEmpLaborBook.CellSelected.Visible:=true;
  GridEmpLaborBook.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpLaborBook.CellSelected.Font.Assign(GridEmpLaborBook.Font);
  GridEmpLaborBook.CellSelected.Font.Color:=clHighlightText;
  GridEmpLaborBook.TitleCellMouseDown.Font.Assign(GridEmpLaborBook.Font);
  GridEmpLaborBook.Options:=GridEmpLaborBook.Options-[dgEditing]-[dgTabs];
  GridEmpLaborBook.ReadOnly:=true;
  GridEmpLaborBook.OnKeyDown:=FormKeyDown;
  GridEmpLaborBook.OnTitleClickWithSort:=GridTitleClickWithSortEmpLaborBook;
  GridEmpLaborBook.OnDblClick:=GridDblClickEmpLaborBook;
  GridEmpLaborBook.OnDrawColumnCell:=GridDrawColumnCellEmpLaborBook;
  GridEmpLaborBook.TabOrder:=101;
  pnButEmpLaborBook.TabOrder:=102;

  cl:=GridEmpLaborBook.Columns.Add;
  cl.FieldName:='profname';
  cl.Title.Caption:='Профессия';
  cl.Width:=100;

  cl:=GridEmpLaborBook.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Где работал';
  cl.Width:=150;

  cl:=GridEmpLaborBook.Columns.Add;
  cl.FieldName:='motivename';
  cl.Title.Caption:='Причина';
  cl.Width:=100;

  cl:=GridEmpSickList.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=100;

  cl:=GridEmpLaborBook.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=100;

  cl:=GridEmpLaborBook.Columns.Add;
  cl.FieldName:='mainprofplus';
  cl.Title.Caption:='Основная профессия';
  cl.Width:=100;

  LastOrderStrEmpLaborBook:=' order by datestart ';

  ibtranEmpRefreshCourse.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpRefreshCourse);
  qrEmpRefreshCourse.Database:=IBDB;

  GridEmpRefreshCourse:=TNewdbGrid.Create(self);
  GridEmpRefreshCourse.Parent:=pnEmpRefreshCourse;
  GridEmpRefreshCourse.Align:=alClient;
  GridEmpRefreshCourse.DataSource:=dsEmpRefreshCourse;
  GridEmpRefreshCourse.Name:='GridEmpRefreshCourse';
  GridEmpRefreshCourse.RowSelected.Visible:=true;
  GridEmpRefreshCourse.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpRefreshCourse.Font);
  GridEmpRefreshCourse.TitleFont.Assign(GridEmpRefreshCourse.Font);
  GridEmpRefreshCourse.RowSelected.Font.Assign(GridEmpRefreshCourse.Font);
  GridEmpRefreshCourse.RowSelected.Brush.Style:=bsClear;
  GridEmpRefreshCourse.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpRefreshCourse.RowSelected.Font.Color:=clWhite;
  GridEmpRefreshCourse.RowSelected.Pen.Style:=psClear;
  GridEmpRefreshCourse.CellSelected.Visible:=true;
  GridEmpRefreshCourse.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpRefreshCourse.CellSelected.Font.Assign(GridEmpRefreshCourse.Font);
  GridEmpRefreshCourse.CellSelected.Font.Color:=clHighlightText;
  GridEmpRefreshCourse.TitleCellMouseDown.Font.Assign(GridEmpRefreshCourse.Font);
  GridEmpRefreshCourse.Options:=GridEmpRefreshCourse.Options-[dgEditing]-[dgTabs];
  GridEmpRefreshCourse.ReadOnly:=true;
  GridEmpRefreshCourse.OnKeyDown:=FormKeyDown;
  GridEmpRefreshCourse.OnTitleClickWithSort:=GridTitleClickWithSortEmpRefreshCourse;
  GridEmpRefreshCourse.OnDblClick:=GridDblClickEmpRefreshCourse;
  GridEmpRefreshCourse.TabOrder:=101;
  pnButEmpRefreshCourse.TabOrder:=102;

  cl:=GridEmpRefreshCourse.Columns.Add;
  cl.FieldName:='profname';
  cl.Title.Caption:='Профессия';
  cl.Width:=100;

  cl:=GridEmpRefreshCourse.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Где';
  cl.Width:=150;

  cl:=GridEmpRefreshCourse.Columns.Add;
  cl.FieldName:='documnum';
  cl.Title.Caption:='На основании';
  cl.Width:=100;

  cl:=GridEmpRefreshCourse.Columns.Add;
  cl.FieldName:='absencename';
  cl.Title.Caption:='Вид неявки';
  cl.Width:=100;

  cl:=GridEmpRefreshCourse.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=100;

  cl:=GridEmpRefreshCourse.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=100;

  LastOrderStrEmpRefreshCourse:=' order by datestart ';

  ibtranEmpLeave.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpLeave);
  qrEmpLeave.Database:=IBDB;

  GridEmpLeave:=TNewdbGrid.Create(self);
  GridEmpLeave.Parent:=pnEmpLeave;
  GridEmpLeave.Align:=alClient;
  GridEmpLeave.DataSource:=dsEmpLeave;
  GridEmpLeave.Name:='GridEmpLeave';
  GridEmpLeave.RowSelected.Visible:=true;
  GridEmpLeave.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpLeave.Font);
  GridEmpLeave.TitleFont.Assign(GridEmpLeave.Font);
  GridEmpLeave.RowSelected.Font.Assign(GridEmpLeave.Font);
  GridEmpLeave.RowSelected.Brush.Style:=bsClear;
  GridEmpLeave.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpLeave.RowSelected.Font.Color:=clWhite;
  GridEmpLeave.RowSelected.Pen.Style:=psClear;
  GridEmpLeave.CellSelected.Visible:=true;
  GridEmpLeave.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpLeave.CellSelected.Font.Assign(GridEmpLeave.Font);
  GridEmpLeave.CellSelected.Font.Color:=clHighlightText;
  GridEmpLeave.TitleCellMouseDown.Font.Assign(GridEmpLeave.Font);
  GridEmpLeave.Options:=GridEmpLeave.Options-[dgEditing]-[dgTabs];
  GridEmpLeave.ReadOnly:=true;
  GridEmpLeave.OnKeyDown:=FormKeyDown;
  GridEmpLeave.OnTitleClickWithSort:=GridTitleClickWithSortEmpLeave;
  GridEmpLeave.OnDblClick:=GridDblClickEmpLeave;
  GridEmpLeave.TabOrder:=101;
  pnButEmpLeave.TabOrder:=102;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='typeleavename';
  cl.Title.Caption:='Вид отпуска';
  cl.Width:=150;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='documnum';
  cl.Title.Caption:='На основании';
  cl.Width:=100;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='absencename';
  cl.Title.Caption:='Вид неявки';
  cl.Width:=100;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='forperiod';
  cl.Title.Caption:='За период с';
  cl.Width:=80;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='forperiodon';
  cl.Title.Caption:='За период по';
  cl.Width:=80;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=80;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='mainamountcalday';
  cl.Title.Caption:='Дней основного';
  cl.Width:=90;

  cl:=GridEmpLeave.Columns.Add;
  cl.FieldName:='addamountcalday';
  cl.Title.Caption:='Дней дополнительного';
  cl.Width:=90;

  LastOrderStrEmpLeave:=' order by datestart ';

  ibtranEmpQual.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpQual);
  qrEmpQual.Database:=IBDB;

  GridEmpQual:=TNewdbGrid.Create(self);
  GridEmpQual.Parent:=pnEmpQual;
  GridEmpQual.Align:=alClient;
  GridEmpQual.DataSource:=dsEmpQual;
  GridEmpQual.Name:='GridEmpQual';
  GridEmpQual.RowSelected.Visible:=true;
  GridEmpQual.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpQual.Font);
  GridEmpQual.TitleFont.Assign(GridEmpQual.Font);
  GridEmpQual.RowSelected.Font.Assign(GridEmpQual.Font);
  GridEmpQual.RowSelected.Brush.Style:=bsClear;
  GridEmpQual.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpQual.RowSelected.Font.Color:=clWhite;
  GridEmpQual.RowSelected.Pen.Style:=psClear;
  GridEmpQual.CellSelected.Visible:=true;
  GridEmpQual.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpQual.CellSelected.Font.Assign(GridEmpQual.Font);
  GridEmpQual.CellSelected.Font.Color:=clHighlightText;
  GridEmpQual.TitleCellMouseDown.Font.Assign(GridEmpQual.Font);
  GridEmpQual.Options:=GridEmpQual.Options-[dgEditing]-[dgTabs];
  GridEmpQual.ReadOnly:=true;
  GridEmpQual.OnKeyDown:=FormKeyDown;
  GridEmpQual.OnTitleClickWithSort:=GridTitleClickWithSortEmpQual;
  GridEmpQual.OnDblClick:=GridDblClickEmpQual;
  GridEmpQual.TabOrder:=101;
  pnButEmpQual.TabOrder:=102;

  cl:=GridEmpQual.Columns.Add;
  cl.FieldName:='typeresqualname';
  cl.Title.Caption:='Тип результата';
  cl.Width:=150;

  cl:=GridEmpQual.Columns.Add;
  cl.FieldName:='resdocumnum';
  cl.Title.Caption:='Результат';
  cl.Width:=100;

  cl:=GridEmpQual.Columns.Add;
  cl.FieldName:='documnum';
  cl.Title.Caption:='На основании';
  cl.Width:=100;

  cl:=GridEmpQual.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=80;

  LastOrderStrEmpQual:=' order by datestart ';

  ibtranEmpEncouragements.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpEncouragements);
  qrEmpEncouragements.Database:=IBDB;

  GridEmpEncouragements:=TNewdbGrid.Create(self);
  GridEmpEncouragements.Parent:=pnEmpEncouragements;
  GridEmpEncouragements.Align:=alClient;
  GridEmpEncouragements.DataSource:=dsEmpEncouragements;
  GridEmpEncouragements.Name:='GridEmpEncouragements';
  GridEmpEncouragements.RowSelected.Visible:=true;
  GridEmpEncouragements.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpEncouragements.Font);
  GridEmpEncouragements.TitleFont.Assign(GridEmpEncouragements.Font);
  GridEmpEncouragements.RowSelected.Font.Assign(GridEmpEncouragements.Font);
  GridEmpEncouragements.RowSelected.Brush.Style:=bsClear;
  GridEmpEncouragements.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpEncouragements.RowSelected.Font.Color:=clWhite;
  GridEmpEncouragements.RowSelected.Pen.Style:=psClear;
  GridEmpEncouragements.CellSelected.Visible:=true;
  GridEmpEncouragements.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpEncouragements.CellSelected.Font.Assign(GridEmpEncouragements.Font);
  GridEmpEncouragements.CellSelected.Font.Color:=clHighlightText;
  GridEmpEncouragements.TitleCellMouseDown.Font.Assign(GridEmpEncouragements.Font);
  GridEmpEncouragements.Options:=GridEmpEncouragements.Options-[dgEditing]-[dgTabs];
  GridEmpEncouragements.ReadOnly:=true;
  GridEmpEncouragements.OnKeyDown:=FormKeyDown;
  GridEmpEncouragements.OnTitleClickWithSort:=GridTitleClickWithSortEmpEncouragements;
  GridEmpEncouragements.OnDblClick:=GridDblClickEmpEncouragements;
  GridEmpEncouragements.TabOrder:=101;
  pnButEmpEncouragements.TabOrder:=102;

  cl:=GridEmpEncouragements.Columns.Add;
  cl.FieldName:='typeencouragementsname';
  cl.Title.Caption:='Вид';
  cl.Width:=150;

  cl:=GridEmpEncouragements.Columns.Add;
  cl.FieldName:='documnum';
  cl.Title.Caption:='На основании';
  cl.Width:=100;

  cl:=GridEmpEncouragements.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=80;

  LastOrderStrEmpEncouragements:=' order by datestart ';

  ibtranEmpBustripsfromus.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpBustripsfromus);
  qrEmpBustripsfromus.Database:=IBDB;

  GridEmpBustripsfromus:=TNewdbGrid.Create(self);
  GridEmpBustripsfromus.Parent:=pnEmpBustripsfromus;
  GridEmpBustripsfromus.Align:=alClient;
  GridEmpBustripsfromus.DataSource:=dsEmpBustripsfromus;
  GridEmpBustripsfromus.Name:='GridEmpBustripsfromus';
  GridEmpBustripsfromus.RowSelected.Visible:=true;
  GridEmpBustripsfromus.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpBustripsfromus.Font);
  GridEmpBustripsfromus.TitleFont.Assign(GridEmpBustripsfromus.Font);
  GridEmpBustripsfromus.RowSelected.Font.Assign(GridEmpBustripsfromus.Font);
  GridEmpBustripsfromus.RowSelected.Brush.Style:=bsClear;
  GridEmpBustripsfromus.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpBustripsfromus.RowSelected.Font.Color:=clWhite;
  GridEmpBustripsfromus.RowSelected.Pen.Style:=psClear;
  GridEmpBustripsfromus.CellSelected.Visible:=true;
  GridEmpBustripsfromus.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpBustripsfromus.CellSelected.Font.Assign(GridEmpBustripsfromus.Font);
  GridEmpBustripsfromus.CellSelected.Font.Color:=clHighlightText;
  GridEmpBustripsfromus.TitleCellMouseDown.Font.Assign(GridEmpBustripsfromus.Font);
  GridEmpBustripsfromus.Options:=GridEmpBustripsfromus.Options-[dgEditing]-[dgTabs];
  GridEmpBustripsfromus.ReadOnly:=true;
  GridEmpBustripsfromus.OnKeyDown:=FormKeyDown;
  GridEmpBustripsfromus.OnTitleClickWithSort:=GridTitleClickWithSortEmpBustripsfromus;
  GridEmpBustripsfromus.OnDblClick:=GridDblClickEmpBustripsfromus;
  GridEmpBustripsfromus.OnDrawColumnCell:=GridDrawColumnCellEmpBustripsfromus;
  GridEmpBustripsfromus.TabOrder:=101;
  pnButEmpBustripsfromus.TabOrder:=102;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='empprojfname';
  cl.Title.Caption:='К кому ушел проект';
  cl.Width:=120;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='empdirectfname';
  cl.Title.Caption:='Кто направил';
  cl.Width:=120;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='documnum';
  cl.Title.Caption:='На основании';
  cl.Width:=100;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='absencename';
  cl.Title.Caption:='Вид неявки';
  cl.Width:=100;
  
  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='num';
  cl.Title.Caption:='Номер ком. удостоверения';
  cl.Width:=100;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата факт. выбытия';
  cl.Width:=80;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата факт. прибытия';
  cl.Width:=80;

  cl:=GridEmpBustripsfromus.Columns.Add;
  cl.FieldName:='okplus';
  cl.Title.Caption:='Заверено';
  cl.Width:=80;

  LastOrderStrEmpBustripsfromus:=' order by datestart ';

  ibtranEmpReferences.AddDatabase(IBDB);
  IBDB.AddTransaction(ibtranEmpReferences);
  qrEmpReferences.Database:=IBDB;

  GridEmpReferences:=TNewdbGrid.Create(self);
  GridEmpReferences.Parent:=pnEmpReferences;
  GridEmpReferences.Align:=alClient;
  GridEmpReferences.DataSource:=dsEmpReferences;
  GridEmpReferences.Name:='GridEmpReferences';
  GridEmpReferences.RowSelected.Visible:=true;
  GridEmpReferences.VisibleRowNumber:=_GetOptions.VisibleRowNumber;
  AssignFont(_GetOptions.RBTableFont,GridEmpReferences.Font);
  GridEmpReferences.TitleFont.Assign(GridEmpReferences.Font);
  GridEmpReferences.RowSelected.Font.Assign(GridEmpReferences.Font);
  GridEmpReferences.RowSelected.Brush.Style:=bsClear;
  GridEmpReferences.RowSelected.Brush.Color:=_GetOptions.RBTableRecordColor;
  GridEmpReferences.RowSelected.Font.Color:=clWhite;
  GridEmpReferences.RowSelected.Pen.Style:=psClear;
  GridEmpReferences.CellSelected.Visible:=true;
  GridEmpReferences.CellSelected.Brush.Color:=_GetOptions.RBTableCursorColor;
  GridEmpReferences.CellSelected.Font.Assign(GridEmpReferences.Font);
  GridEmpReferences.CellSelected.Font.Color:=clHighlightText;
  GridEmpReferences.TitleCellMouseDown.Font.Assign(GridEmpReferences.Font);
  GridEmpReferences.Options:=GridEmpReferences.Options-[dgEditing]-[dgTabs];
  GridEmpReferences.ReadOnly:=true;
  GridEmpReferences.OnKeyDown:=FormKeyDown;
  GridEmpReferences.OnTitleClickWithSort:=GridTitleClickWithSortEmpReferences;
  GridEmpReferences.OnDblClick:=GridDblClickEmpReferences;
  GridEmpReferences.OnDrawColumnCell:=GridDrawColumnCellEmpReferences;
  GridEmpReferences.TabOrder:=101;
  pnButEmpReferences.TabOrder:=102;

  cl:=GridEmpReferences.Columns.Add;
  cl.FieldName:='typereferencesname';
  cl.Title.Caption:='Вид справки';
  cl.Width:=120;

  cl:=GridEmpReferences.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата начала';
  cl.Width:=80;

  cl:=GridEmpReferences.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=80;

  cl:=GridEmpReferences.Columns.Add;
  cl.FieldName:='okplus';
  cl.Title.Caption:='Заверено';
  cl.Width:=80;

  LastOrderStrEmpReferences:=' order by datestart ';

  LoadFromIni;

  SetParamsFromOptions;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.FormDestroy(Sender: TObject);
begin
// Screen.Cursor:=crHourGlass;
 try
  inherited;
  DestroyCursor(Screen.Cursors[crImageMove]);
  DestroyCursor(Screen.Cursors[crImageDown]);
  Screen.Cursors[crImageMove] := 0;
  Screen.Cursors[crImageDown] := 0;
  GridEmpConnect.Free;
  GridEmpsciencename.Free;
  GridEmplanguage.Free;
  GridEmpProperty.Free;
  GridEmpStreet.Free;
  GridEmpPersonDoc.Free;
  GridEmpMilitary.Free;
  GridEmpDiplom.Free;
  GridEmpBiography.Free;
  GridEmpPhoto.Free;
  GridEmpPlant.Free;
  GridEmpFaceAccount.Free;
  GridEmpSickList.Free;
  GridEmpLaborBook.Free;
  GridEmpRefreshCourse.Free;
  GridEmpLeave.Free;
  GridEmpQual.Free;
  GridEmpEncouragements.Free;
  GridEmpBustripsfromus.Free;
  GridEmpReferences.Free;
 finally
  //Screen.Cursor:=crDefault;
 end;  
end;

function TfmRBEmpMain.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkEmp+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBEmpMain.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  try
   Mainqr.Active:=false;
   if CheckPerm then
    if not CheckPermission then exit;

   Screen.Cursor:=crHourGlass;
   Mainqr.DisableControls;
   Mainqr.AfterScroll:=nil;
   try
    Mainqr.sql.Clear;
    sqls:=GetSql;
    Mainqr.sql.Add(sqls);
    Mainqr.Transaction.Active:=false;
    Mainqr.Transaction.Active:=true;
    Mainqr.Active:=true;
    SetImageFilter(isFindFName or isFindName or isFindSName or isFindSex or
                  isFindFamilyStateName or isFindNationName or isFindTownName or isFindInn or
                  isFindCountryName or isFindRegionName or isFindStateName or
                  isFindPlaceMentName or isFindRelease);
    ViewCount;
   finally
    Mainqr.AfterScroll:=MainqrAfterScroll;
    Mainqr.EnableControls;
    Screen.Cursor:=crDefault;
   end;
  finally
   ActiveAll;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.ActiveAll;
var
  i: Integer;
begin
  if not pnLink.Visible then exit;

  for i:=0 to ComponentCount-1 do begin
   if Components[i] is TIBQuery then
    if Components[i]<>Mainqr then
      TIBQuery(Components[i]).Active:=false;
   if Components[i] is TIBTransaction then
    if Components[i]<>IBTran then
      TIBTransaction(Components[i]).Active:=false;
   if Components[i] is TNewDBgrid then
    if Components[i]<>Grid then
      TNewDBgrid(Components[i]).ClearColumnSort;
  end;

  SaveGridProperty(TmpGrid);
  TmpGrid:=GetGridFromTabSheet(pgLink.ActivePage);
  LoadGridProperty(TmpGrid);

  if pgLink.ActivePage=tbsEmpMilitary then ActiveEmpMilitary(true);
  if pgLink.ActivePage=tbsEmpConnect then ActiveEmpConnect(true);
  if pgLink.ActivePage=tbsEmpsciencename then ActiveEmpsciencename(true);
  if pgLink.ActivePage=tbsEmpLanguage then ActiveEmpLanguage(true);
  if pgLink.ActivePage=tbsEmpChildren then ActiveEmpChildren(true);
  if pgLink.ActivePage=tbsEmpProperty then ActiveEmpProperty(true);
  if pgLink.ActivePage=tbsEmpStreet then ActiveEmpStreet(true);
  if pgLink.ActivePage=tbsEmpPersonDoc then ActiveEmpPersonDoc(true);
  if pgLink.ActivePage=tbsEmpDiplom then ActiveEmpDiplom(true);
  if pgLink.ActivePage=tbsEmpBiography then ActiveEmpBiography(true);
  if pgLink.ActivePage=tbsEmpPhoto then ActiveEmpPhoto(true);
  if pgLink.ActivePage=tbsEmpPlant then ActiveEmpPlant(true);
  if pgLink.ActivePage=tbsEmpFaceAccount then ActiveEmpFaceAccount(true);
  if pgLink.ActivePage=tbsEmpSickList then ActiveEmpSickList(true);
  if pgLink.ActivePage=tbsEmpLaborBook then ActiveEmpLaborBook(true);
  if pgLink.ActivePage=tbsEmpRefreshCourse then ActiveEmpRefreshCourse(true);
  if pgLink.ActivePage=tbsEmpLeave then ActiveEmpLeave(true);
  if pgLink.ActivePage=tbsEmpQual then ActiveEmpQual(true);
  if pgLink.ActivePage=tbsEmpEncouragements then ActiveEmpEncouragements(true);
  if pgLink.ActivePage=tbsEmpBustripsfromus then ActiveEmpBustripsfromus(true);
  if pgLink.ActivePage=tbsEmpReferences then ActiveEmpReferences(true);

end;

procedure TfmRBEmpMain.bibAdjustEmpConnectClick(Sender: TObject);
var
  Columns: TDBGridColumns;
begin
  Columns:=nil;
  if Sender=bibAdjustEmpChildren then Columns:=GridEmpChildren.Columns;
  if Sender=bibAdjustEmpConnect then Columns:=GridEmpConnect.Columns;
  if Sender=bibAdjustEmpsciencename then Columns:=GridEmpsciencename.Columns;
  if Sender=bibAdjustEmplanguage then Columns:=GridEmplanguage.Columns;
  if Sender=bibAdjustEmpProperty then Columns:=GridEmpProperty.Columns;
  if Sender=bibAdjustEmpStreet then Columns:=GridEmpStreet.Columns;
  if Sender=bibAdjustEmpPersonDoc then Columns:=GridEmpPersonDoc.Columns;
  if Sender=bibAdjustEmpMilitary then Columns:=GridEmpMilitary.Columns;
  if Sender=bibAdjustEmpDiplom then Columns:=GridEmpDiplom.Columns;
  if Sender=bibAdjustEmpBiography then Columns:=GridEmpBiography.Columns;
  if Sender=bibAdjustEmpPhoto then Columns:=GridEmpPhoto.Columns;
  if Sender=bibAdjustEmpPlant then Columns:=GridEmpPlant.Columns;
  if Sender=bibAdjustEmpFaceAccount then Columns:=GridEmpFaceAccount.Columns;
  if Sender=bibAdjustEmpSickList then Columns:=GridEmpSickList.Columns;
  if Sender=bibAdjustEmpLaborBook then Columns:=GridEmpLaborBook.Columns;
  if Sender=bibAdjustEmpRefreshCourse then Columns:=GridEmpRefreshCourse.Columns;
  if Sender=bibAdjustEmpLeave then Columns:=GridEmpLeave.Columns;
  if Sender=bibAdjustEmpQual then Columns:=GridEmpQual.Columns;
  if Sender=bibAdjustEmpEncouragements then Columns:=GridEmpEncouragements.Columns;
  if Sender=bibAdjustEmpBustripsfromus then Columns:=GridEmpBustripsfromus.Columns;
  if Sender=bibAdjustEmpReferences then Columns:=GridEmpReferences.Columns;
  SetAdjust(Columns,nil);
end;

procedure TfmRBEmpMain.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('name') then fn:='e.name';
   if UpperCase(fn)=UpperCase('familystatename') then fn:='fs.name';
   if UpperCase(fn)=UpperCase('nationname') then fn:='n.name';
   if UpperCase(fn)=UpperCase('countryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('regionname') then fn:='r.name';
   if UpperCase(fn)=UpperCase('statename') then fn:='st.name';
   if UpperCase(fn)=UpperCase('townname') then fn:='t.name';
   if UpperCase(fn)=UpperCase('placementname') then fn:='pm.name';
   if UpperCase(fn)=UpperCase('sexshortname') then fn:='s.shortname';
   id:=MainQr.fieldByName('emp_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   Mainqr.AfterScroll:=nil;
   MainQr.First;
   MainQr.Locate('emp_id',id,[loCaseInsensitive]);
   Mainqr.AfterScroll:=MainqrAfterScroll;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if MainQr.isEmpty then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBEmpMain.LoadFromIni;

  procedure LoadPageProp;
  var
   i: Integer;
   tbs: TTabSheet;
  begin
    for i:=0 to pgLink.PageCount-1 do begin
     tbs:=pgLink.Pages[i];
     tbs.PageIndex:=ReadParam(ClassName,'tbsPageIndex'+tbs.Name,i);
    end;
    for i:=0 to pgLink.PageCount-1 do begin
     tbs:=pgLink.Pages[i];
     tbs.TabVisible:=ReadParam(ClassName,'tbsVisible'+tbs.Name,tbs.TabVisible);
    end;
  end;

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
    FindRelease:=ReadParam(ClassName,'Release',FindRelease);
    isTown:=ReadParam(ClassName,'isTown',isTown);
    FindInn:=ReadParam(ClassName,'Inn',FindInn);
    pnLink.Height:=ReadParam(ClassName,pnLink.Name,pnLink.Height);
    grbEmpBiography.Width:=ReadParam(ClassName,grbEmpBiography.Name,grbEmpBiography.Width);
    grbEmpPhoto.Width:=ReadParam(ClassName,grbEmpPhoto.Name,grbEmpPhoto.Width);
    chbPhotoStretch.Checked:=ReadParam(ClassName,chbPhotoStretch.Name,chbPhotoStretch.Checked);
    grbEmpLaborBook.Width:=ReadParam(ClassName,grbEmpLaborBook.Name,grbEmpLaborBook.Width);

    pgLink.ActivePageIndex:=ReadParam(ClassName,'ActivePageIndex',pgLink.ActivePageIndex);
    LoadPageProp;


    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.SaveToIni;

  procedure SavePageProp;
  var
   i: Integer;
   tbs: TTabSheet;
  begin
    for i:=0 to pgLink.PageCount-1 do begin
     tbs:=pgLink.Pages[i];
     WriteParam(ClassName,'tbsPageIndex'+tbs.Name,tbs.PageIndex);
     WriteParam(ClassName,'tbsVisible'+tbs.Name,tbs.TabVisible);
   end;
  end;

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
    WriteParam(ClassName,'Release',FindRelease);
    WriteParam(ClassName,'isTown',isTown);
    WriteParam(ClassName,'Inn',FindInn);
    WriteParam(ClassName,pnLink.Name,pnLink.Height);
    WriteParam(ClassName,grbEmpBiography.Name,grbEmpBiography.Width);
    WriteParam(ClassName,grbEmpLaborBook.Name,grbEmpLaborBook.Width);
    WriteParam(ClassName,grbEmpPhoto.Name,grbEmpPhoto.Width);
    WriteParam(ClassName,chbPhotoStretch.Name,chbPhotoStretch.Checked);
    WriteParam(ClassName,'ActivePageIndex',pgLink.ActivePageIndex);
    SaveGridProperty(TmpGrid);
    SavePageProp;
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBEmpMain.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBEmp;
  TPRBI: TParamRBookInterface;
  TPRBIChild: TParamRBookInterface;
  V: Variant;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBEmp.Create(nil);
  try
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Страна'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.country_id:=V;
        fm.edCountry.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
       end; 
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Край, область'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.region_id:=V;
        fm.edregion.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' region_id='+inttostr(fm.region_id)+' ');
        if _ViewInterfaceFromName(NameRbkRegion,@TPRBIChild) then begin
         fm.regioncode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Район'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.state_id:=V;
        fm.edstate.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' state_id='+inttostr(fm.state_id)+' ');
        if _ViewInterfaceFromName(NameRbkState,@TPRBIChild) then begin
         fm.statecode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Город'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.town_id:=V;
        fm.edtown.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' town_id='+inttostr(fm.town_id)+' ');
        if _ViewInterfaceFromName(NameRbkTown,@TPRBIChild) then begin
         fm.towncode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Населенный пункт'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.placement_id:=V;
        fm.edplacement.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' placement_id='+inttostr(fm.placement_id)+' ');
        if _ViewInterfaceFromName(NameRbkPlacement,@TPRBIChild) then begin
         fm.placementcode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;
    
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('emp_id',fm.oldemp_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;  
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBEmp;
begin
 try
  if not Mainqr.Active then exit;
  if MainQr.isEmpty then exit;
  fm:=TfmEditRBEmp.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
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
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('emp_id',fm.oldemp_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmp+' where emp_id='+
          inttostr(Mainqr.fieldbyName('emp_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     _AddSqlOperationToJournal(PChar(ConstDelete),PChar(sqls));

     ActiveQuery(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if MainQr.isEmpty then exit;
  but:=DeleteWarningEx('сотрудника с табельным номером <'+
                        Mainqr.FieldByName('tabnum').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBEmpMain.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBEmp;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBEmp.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBEmp;
  filstr: string;
begin
try
 fm:=TfmEditRBEmp.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

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
  fm.lbContinioussenioritydate.Visible:=false;
  fm.dtpContinioussenioritydate.Visible:=false;
  fm.lbRelease.Visible:=true;
  fm.cmbRelease.Visible:=true;


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
  if (FindRelease>-1) and (FindRelease<fm.cmbRelease.Items.Count)
           then fm.cmbRelease.ItemIndex:=FindRelease;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

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
    FindRelease:=fm.cmbRelease.ItemIndex;

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmRBEmpMain.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,
  addstr8,addstr9,addstr10,addstr11,addstr12,addstr13: string;
  and1,and2,and3,and4,and5,and6,and7,
  and8,and9,and10,and11,and12: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

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
    isFindRelease:=FindRelease>0;

    if isFindFName or isFindName or isFindSName or isFindSex or isFindInn or
       isFindFamilyStateName or isFindNationName or isFindTownName or
       isFindCountryName or isFindRegionName or isFindStateName or
       isFindPlaceMentName or isFindRelease then begin
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

     if isFindRelease then begin
       case FindRelease of
         1: addstr13:=' ep.releasedate is null ';
         2: addstr13:=' ep.releasedate is not null ';
       else
         addstr13:=' ep.releasedate is null and ep.releasedate is not null ';
       end;

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
        (isFindFName and isFindPlaceMentName)or
        (isFindFName and isFindRelease)
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
        (isFindName and isFindPlaceMentName)or
        (isFindName and isFindRelease)
        then and2:=' and ';

     if (isFindSName and isFindSex)or
        (isFindSName and isFindFamilyStateName)or
        (isFindSName and isFindNationName)or
        (isFindSName and isFindInn) or
        (isFindSName and isFindCountryName)or
        (isFindSName and isFindRegionName)or
        (isFindSName and isFindStateName)or
        (isFindSName and isFindTownName)or
        (isFindSName and isFindPlaceMentName)or
        (isFindSName and isFindRelease)
        then and3:=' and ';

     if (isFindSex and isFindFamilyStateName)or
        (isFindSex and isFindNationName)or
        (isFindSex and isFindInn)or
        (isFindSex and isFindCountryName)or
        (isFindSex and isFindRegionName)or
        (isFindSex and isFindStateName)or
        (isFindSex and isFindTownName)or
        (isFindSex and isFindPlaceMentName)or
        (isFindSex and isFindRelease)
        then and4:=' and ';

     if (isFindFamilyStateName and isFindNationName)or
        (isFindFamilyStateName and isFindInn)or
        (isFindFamilyStateName and isFindCountryName)or
        (isFindFamilyStateName and isFindRegionName)or
        (isFindFamilyStateName and isFindStateName)or
        (isFindFamilyStateName and isFindTownName)or
        (isFindFamilyStateName and isFindPlaceMentName)or
        (isFindFamilyStateName and isFindRelease)
        then and5:=' and ';

     if (isFindNationName and isFindInn)or
        (isFindNationName and isFindCountryName)or
        (isFindNationName and isFindRegionName)or
        (isFindNationName and isFindStateName)or
        (isFindNationName and isFindTownName)or
        (isFindNationName and isFindPlaceMentName)or
        (isFindNationName and isFindRelease)
        then and6:=' and ';

     if (isFindInn and isFindCountryName)or
        (isFindInn and isFindRegionName)or
        (isFindInn and isFindStateName)or
        (isFindInn and isFindTownName)or
        (isFindInn and isFindPlaceMentName)or
        (isFindInn and isFindRelease)
        then and7:=' and ';

     if (isFindCountryName and isFindRegionName)or
        (isFindCountryName and isFindStateName)or
        (isFindCountryName and isFindTownName)or
        (isFindCountryName and isFindPlaceMentName)or
        (isFindCountryName and isFindRelease)
        then and8:=' and ';

     if (isFindRegionName and isFindStateName)or
        (isFindRegionName and isFindTownName)or
        (isFindRegionName and isFindPlaceMentName)or
        (isFindRegionName and isFindRelease)
        then and9:=' and ';

     if (isFindStateName and isFindTownName)or
        (isFindStateName and isFindPlaceMentName)or
        (isFindStateName and isFindRelease)
        then and10:=' and ';

     if (isFindTownName and isFindPlaceMentName)or
        (isFindTownName and isFindRelease)
        then and11:=' and ';

     if (isFindPlaceMentName and isFindRelease)
        then and12:=' and ';

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
                      addstr12+and12+
                      addstr13;
end;

procedure TfmRBEmpMain.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                 DataCol: Integer; Column: TColumn;
                                 State: TGridDrawState);
  procedure DrawSexName;
  var
    value: Integer;
    tmps: string;
  begin
    value:=Mainqr.FieldByName('sex').AsInteger;
    case Value of
      0: tmps:='Мужской';
      1: tmps:='Женский';
    end;
    Grid.Canvas.TextRect(Rect, 0, 0, tmps);
  end;

begin
  if not Mainqr.Active then exit;
  if MainQr.isEmpty then exit;
  if column.Title.Caption='Пол' then begin
//    DrawSexName;
  end;
end;

procedure TfmRBEmpMain.MainqrAfterScroll(DataSet: TDataSet);
begin
  ActiveAll;
end;

function  TfmRBEmpMain.GetSqlEmpConnect: string;
begin
  Result:=SQLRbkEmpConnect+' where ec.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
          LastOrderStrEmpConnect;
end;

procedure TfmRBEmpMain.ActiveEmpConnect(CheckPerm: Boolean);

 function CheckPermissionEmpConnect: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpConnect,ttiaView) and isPerm;
  bibAddEmpConnect.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpConnect,ttiaAdd);
  bibChangeEmpConnect.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpConnect,ttiaChange);
  bibDelEmpConnect.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpConnect,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpConnect.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpConnect then exit;


  Screen.Cursor:=crHourGlass;
  qrEmpConnect.DisableControls;
  try
   qrEmpConnect.sql.Clear;
   sqls:=GetSqlEmpConnect;
   qrEmpConnect.sql.Add(sqls);
   qrEmpConnect.Transaction.Active:=false;
   qrEmpConnect.Transaction.Active:=true;
   qrEmpConnect.Active:=true;
  finally
   Screen.Cursor:=crDefault;
   qrEmpConnect.EnableControls;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpConnect(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpConnect.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('connectiontypename') then fn:='ct.name';
   id1:=qrEmpConnect.fieldByName('empconnect_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpConnect:='';
     tcsAsc: LastOrderStrEmpConnect:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpConnect:=' Order by '+fn+' desc ';
   end;
   ActiveEmpConnect(false);
   qrEmpConnect.First;
   qrEmpConnect.Locate('empconnect_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpConnect(Sender: TObject);
begin
  if not qrEmpConnect.Active then exit;
  if qrEmpConnect.RecordCount=0 then exit;
  if bibChangeEmpConnect.Enabled then begin
   bibChangeEmpConnect.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpConnectClick(Sender: TObject);
var
  fm: TfmEditRBEmpConnect;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpConnect.Active then exit;
  fm:=TfmEditRBEmpConnect.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpConnectClick(Sender: TObject);
var
  fm: TfmEditRBEmpConnect;
begin
 try
  if not qrEmpConnect.Active then exit;
  if qrEmpConnect.RecordCount=0 then exit;
  fm:=TfmEditRBEmpConnect.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.connectiontype_id:=qrEmpConnect.fieldByName('connectiontype_id').AsInteger;
    fm.oldconnectiontype_id:=qrEmpConnect.fieldByName('connectiontype_id').AsInteger;
    fm.edConnectionType.Text:=qrEmpConnect.fieldByName('connectiontypename').AsString;
    fm.edConnectionString.Text:=qrEmpConnect.fieldByName('connectstring').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpConnectClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpConnect;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpConnect+
           ' where empconnect_id='+inttostr(qrEmpConnect.FieldByName('empconnect_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpConnect(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpConnect.isEmpty then exit;
  but:=DeleteWarningEx('средство связи <'+
                        qrEmpConnect.FieldByName('connectiontypename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function  TfmRBEmpMain.GetSqlEmpsciencename: string;
begin
  Result:=SQLRbkEmpSciencename+' where sn.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpsciencename;
end;

procedure TfmRBEmpMain.ActiveEmpsciencename(CheckPerm: Boolean);

 function CheckPermissionEmpsciencename: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpSciencename,ttiaView) and isPerm;
  bibAddEmpSciencename.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpSciencename,ttiaAdd);
  bibChangeEmpSciencename.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpSciencename,ttiaChange);
  bibDelEmpSciencename.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpSciencename,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpsciencename.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpsciencename then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpsciencename.DisableControls;
  try
   qrEmpsciencename.sql.Clear;
   sqls:=GetSqlEmpsciencename;
   qrEmpsciencename.sql.Add(sqls);
   qrEmpsciencename.Transaction.Active:=false;
   qrEmpsciencename.Transaction.Active:=true;
   qrEmpsciencename.Active:=true;
  finally
   qrEmpsciencename.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpsciencename(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrEmpsciencename.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('sciencename') then fn:='s.name';
   if UpperCase(fn)=UpperCase('schoolname') then fn:='sc.name';
   id1:=qrEmpsciencename.fieldByName('sciencename_id').asString;
   id2:=qrEmpsciencename.fieldByName('emp_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpsciencename:='';
     tcsAsc: LastOrderStrEmpsciencename:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpsciencename:=' Order by '+fn+' desc ';
   end;
   ActiveEmpsciencename(false);
   qrEmpsciencename.First;
   qrEmpsciencename.Locate('sciencename_id;emp_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpsciencename(Sender: TObject);
begin
  if not qrEmpsciencename.Active then exit;
  if qrEmpsciencename.RecordCount=0 then exit;
  if bibChangeEmpsciencename.Enabled then begin
   bibChangeEmpsciencename.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpsciencenameClick(Sender: TObject);
var
  fm: TfmEditRBEmpScienceName;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpsciencename.Active then exit;
  fm:=TfmEditRBEmpScienceName.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpsciencenameClick(Sender: TObject);
var
  fm: TfmEditRBEmpScienceName;
begin
 try
  if not qrEmpsciencename.Active then exit;
  if qrEmpsciencename.RecordCount=0 then exit;
  fm:=TfmEditRBEmpScienceName.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.sciencename_id:=qrEmpsciencename.fieldByName('sciencename_id').AsInteger;
    fm.oldsciencename_id:=qrEmpsciencename.fieldByName('sciencename_id').AsInteger;
    fm.edScienceName.Text:=qrEmpsciencename.fieldByName('sciencename').AsString;
    fm.school_id:=qrEmpsciencename.fieldByName('school_id').AsInteger;
    fm.edSchool.Text:=qrEmpsciencename.fieldByName('schoolname').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpsciencenameClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpsciencename;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpSciencename+
           ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
           ' and sciencename_id='+qrEmpsciencename.FieldByName('sciencename_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpsciencename(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpsciencename.isEmpty then exit;
  but:=DeleteWarningEx('ученое звание <'+
                        qrEmpsciencename.FieldByName('sciencename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function  TfmRBEmpMain.GetSqlEmpLanguage: string;
begin
  Result:=SQLRbkEmpLanguage+' where el.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmplanguage;
end;

procedure TfmRBEmpMain.ActiveEmpLanguage(CheckPerm: Boolean);

 function CheckPermissionEmpLanguage: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpLanguage,ttiaView)and isPerm;
  bibAddEmplanguage.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLanguage,ttiaAdd);
  bibChangeEmplanguage.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLanguage,ttiaChange);
  bibDelEmplanguage.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLanguage,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmplanguage.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpLanguage then exit;

  Screen.Cursor:=crHourGlass;
  qrEmplanguage.DisableControls;
  try
   qrEmplanguage.sql.Clear;
   sqls:=GetSqlEmpLanguage;
   qrEmplanguage.sql.Add(sqls);
   qrEmplanguage.Transaction.Active:=false;
   qrEmplanguage.Transaction.Active:=true;
   qrEmplanguage.Active:=true;
  finally
   qrEmplanguage.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpLanguage(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrEmplanguage.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('languagename') then fn:='l.name';
   if UpperCase(fn)=UpperCase('knowlevelname') then fn:='kl.name';
   id1:=qrEmplanguage.fieldByName('language_id').asString;
   id2:=qrEmplanguage.fieldByName('emp_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpLanguage:='';
     tcsAsc: LastOrderStrEmpLanguage:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpLanguage:=' Order by '+fn+' desc ';
   end;
   ActiveEmpLanguage(false);
   qrEmpLanguage.First;
   qrEmplanguage.Locate('language_id;emp_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpLanguage(Sender: TObject);
begin
  if not qrEmplanguage.Active then exit;
  if qrEmplanguage.RecordCount=0 then exit;
  if bibChangeEmplanguage.Enabled then begin
   bibChangeEmplanguage.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmplanguageClick(Sender: TObject);
var
  fm: TfmEditRBEmpLanguage;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmplanguage.Active then exit;
  fm:=TfmEditRBEmpLanguage.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmplanguageClick(Sender: TObject);
var
  fm: TfmEditRBEmpLanguage;
begin
 try
  if not qrEmplanguage.Active then exit;
  if qrEmplanguage.RecordCount=0 then exit;
  fm:=TfmEditRBEmpLanguage.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.language_id:=qrEmplanguage.fieldByName('language_id').AsInteger;
    fm.oldlanguage_id:=qrEmplanguage.fieldByName('language_id').AsInteger;
    fm.edLanguage.Text:=qrEmplanguage.fieldByName('languagename').AsString;
    fm.knowlevel_id:=qrEmplanguage.fieldByName('knowlevel_id').AsInteger;
    fm.edKnowLevel.Text:=qrEmplanguage.fieldByName('knowlevelname').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmplanguageClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmplanguage;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpLanguage+
           ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
           ' and language_id='+qrEmplanguage.FieldByName('language_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpLanguage(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmplanguage.isEmpty then exit;
  but:=DeleteWarningEx('иностранный язык <'+
                        qrEmplanguage.FieldByName('languagename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function  TfmRBEmpMain.GetSqlEmpChildren: string;
begin
  Result:=SQLRbkEmpChildren+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpChildren;
end;

procedure TfmRBEmpMain.ActiveEmpChildren(CheckPerm: Boolean);

 function CheckPermissionEmpChildren: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpChildren,ttiaView)and isPerm;
  bibAddEmpChildren.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpChildren,ttiaAdd);
  bibChangeEmpChildren.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpChildren,ttiaChange);
  bibDelEmpChildren.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpChildren,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpChildren.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpChildren then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpChildren.DisableControls;
  try
   qrEmpChildren.sql.Clear;
   sqls:=GetSqlEmpChildren;
   qrEmpChildren.sql.Add(sqls);
   qrEmpChildren.Transaction.Active:=false;
   qrEmpChildren.Transaction.Active:=true;
   qrEmpChildren.Active:=true;
  finally
   qrEmpChildren.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpChildren(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpChildren.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpChildren.fieldByName('children_id').asString;
   if UpperCase(fn)=UpperCase('typerelationname') then fn:='tr.name';
   if UpperCase(fn)=UpperCase('sexname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('name') then fn:='ec.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpChildren:='';
     tcsAsc: LastOrderStrEmpChildren:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpChildren:=' Order by '+fn+' desc ';
   end;
   ActiveEmpChildren(false);
   qrEmpChildren.First;
   qrEmpChildren.Locate('children_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpChildren(Sender: TObject);
begin
  if not qrEmpChildren.Active then exit;
  if qrEmpChildren.RecordCount=0 then exit;
  if bibChangeEmpChildren.Enabled then begin
   bibChangeEmpChildren.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpChildrenClick(Sender: TObject);
var
  fm: TfmEditRBEmpChildren;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpChildren.Active then exit;
  fm:=TfmEditRBEmpChildren.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpChildrenClick(Sender: TObject);
var
  fm: TfmEditRBEmpChildren;
begin
 try
  if not qrEmpChildren.Active then exit;
  if qrEmpChildren.RecordCount=0 then exit;
  fm:=TfmEditRBEmpChildren.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.sex_id:=qrEmpChildren.fieldByName('sex_id').AsInteger;
    fm.edSex.Text:=qrEmpChildren.fieldByName('sexname').AsString;
    fm.typerelation_id:=qrEmpChildren.fieldByName('typerelation_id').AsInteger;
    fm.edTypeRelation.Text:=qrEmpChildren.fieldByName('typerelationname').AsString;
    fm.edFName.Text:=qrEmpChildren.fieldByName('fname').AsString;
    fm.edName.Text:=qrEmpChildren.fieldByName('name').AsString;
    fm.edSName.Text:=qrEmpChildren.fieldByName('sname').AsString;
    fm.dtpBirthdate.Date:=qrEmpChildren.fieldByName('birthdate').AsdateTime;
    fm.edAddress.Text:=qrEmpChildren.fieldByName('address').AsString;
    fm.edWorkPlace.Text:=qrEmpChildren.fieldByName('workplace').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.pgLinkChange(Sender: TObject);
begin
  ActiveAll;
end;

procedure TfmRBEmpMain.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Mainqr.AfterScroll:=nil;
  try
   inherited;
   ActiveAll;
  finally
    Mainqr.AfterScroll:=MainqrAfterScroll;
  end;
end;

procedure TfmRBEmpMain.bibDelEmpChildrenClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranChildren;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpChildren+
           ' where children_id='+qrEmpChildren.FieldByName('children_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpChildren(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpChildren.isEmpty then exit;
  but:=DeleteWarningEx('родственника <'+
                        qrEmpChildren.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpProperty: string;
begin
  Result:=SQLRbkEmpProperty+' where ep.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpProperty;
end;

procedure TfmRBEmpMain.ActiveEmpProperty(CheckPerm: Boolean);

 function CheckPermissionEmpProperty: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpProperty,ttiaView)and isPerm;
  bibAddEmpProperty.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpProperty,ttiaAdd);
  bibChangeEmpProperty.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpProperty,ttiaChange);
  bibDelEmpProperty.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpProperty,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpProperty.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpProperty then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpProperty.DisableControls;
  try
   qrEmpProperty.sql.Clear;
   sqls:=GetSqlEmpProperty;
   qrEmpProperty.sql.Add(sqls);
   qrEmpProperty.Transaction.Active:=false;
   qrEmpProperty.Transaction.Active:=true;
   qrEmpProperty.Active:=true;
  finally
   qrEmpProperty.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpProperty(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not qrEmpProperty.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('propertyname') then fn:='p.name';
   id1:=qrEmpProperty.fieldByName('property_id').asString;
   id2:=qrEmpProperty.fieldByName('emp_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpProperty:='';
     tcsAsc: LastOrderStrEmpProperty:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpProperty:=' Order by '+fn+' desc ';
   end;
   ActiveEmpProperty(false);
   qrEmpProperty.First;
   qrEmpProperty.Locate('property_id;emp_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpProperty(Sender: TObject);
begin
  if not qrEmpProperty.Active then exit;
  if qrEmpProperty.RecordCount=0 then exit;
  if bibChangeEmpProperty.Enabled then begin
   bibChangeEmpProperty.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpPropertyClick(Sender: TObject);
var
  fm: TfmEditRBEmpProperty;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpProperty.Active then exit;
  fm:=TfmEditRBEmpProperty.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpPropertyClick(Sender: TObject);
var
  fm: TfmEditRBEmpProperty;
begin
 try
  if not qrEmpProperty.Active then exit;
  if qrEmpProperty.RecordCount=0 then exit;
  fm:=TfmEditRBEmpProperty.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.property_id:=qrEmpProperty.fieldbyname('property_id').AsInteger;
    fm.oldproperty_id:=qrEmpProperty.fieldbyname('property_id').AsInteger;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.edProperty.Text:=qrEmpProperty.fieldByName('propertyname').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpPropertyClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpProperty;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpProperty+
           ' where property_id='+qrEmpProperty.FieldByName('property_id').asString+
           ' and emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpProperty(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpProperty.isEmpty then exit;
  but:=DeleteWarningEx('признак <'+
                        qrEmpProperty.FieldByName('propertyname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpStreet: string;
begin
  Result:=SQLRbkEmpStreet+' where es.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpStreet;
end;

procedure TfmRBEmpMain.ActiveEmpStreet(CheckPerm: Boolean);

 function CheckPermissionEmpStreet: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpStreet,ttiaView)and isPerm;
  bibAddEmpStreet.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpStreet,ttiaAdd);
  bibChangeEmpStreet.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpStreet,ttiaChange);
  bibDelEmpStreet.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpStreet,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpStreet.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpStreet then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpStreet.DisableControls;
  try
   qrEmpStreet.sql.Clear;
   sqls:=GetSqlEmpStreet;
   qrEmpStreet.sql.Add(sqls);
   qrEmpStreet.Transaction.Active:=false;
   qrEmpStreet.Transaction.Active:=true;
   qrEmpStreet.Active:=true;
  finally
   qrEmpStreet.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpStreet(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpStreet.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('streetname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('townname') then fn:='t.name';
   if UpperCase(fn)=UpperCase('typelivename') then fn:='tl.name';
   if UpperCase(fn)=UpperCase('countryname') then fn:='ct.name';
   if UpperCase(fn)=UpperCase('regionname') then fn:='r.name';
   if UpperCase(fn)=UpperCase('statename') then fn:='st.name';
   if UpperCase(fn)=UpperCase('placementname') then fn:='pm.name';
   id1:=qrEmpStreet.fieldByName('empstreet_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpStreet:='';
     tcsAsc: LastOrderStrEmpStreet:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpStreet:=' Order by '+fn+' desc ';
   end;
   ActiveEmpStreet(false);
   qrEmpStreet.First;
   qrEmpStreet.Locate('empstreet_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpStreet(Sender: TObject);
begin
  if not qrEmpStreet.Active then exit;
  if qrEmpStreet.RecordCount=0 then exit;
  if bibChangeEmpStreet.Enabled then begin
   bibChangeEmpStreet.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpStreetClick(Sender: TObject);
var
  fm: TfmEditRBEmpStreet;
  TPRBI: TParamRBookInterface;
  TPRBIChild: TParamRBookInterface;
  V: Variant;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpStreet.Active then exit;
  fm:=TfmEditRBEmpStreet.Create(nil);
  try
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Страна'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.country_id:=V;
        fm.edCountry.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
       end; 
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Край, область'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.region_id:=V;
        fm.edregion.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' region_id='+inttostr(fm.region_id)+' ');
        if _ViewInterfaceFromName(NameRbkRegion,@TPRBIChild) then begin
         fm.regioncode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Район'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.state_id:=V;
        fm.edstate.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' state_id='+inttostr(fm.state_id)+' ');
        if _ViewInterfaceFromName(NameRbkState,@TPRBIChild) then begin
         fm.statecode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Город'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.town_id:=V;
        fm.edtown.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' town_id='+inttostr(fm.town_id)+' ');
        if _ViewInterfaceFromName(NameRbkTown,@TPRBIChild) then begin
         fm.towncode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Населенный пункт'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      if ifExistsDataInParamRBookInterface(@TPRBI) then begin
       V:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
       if IsInteger(V) then begin
        fm.placement_id:=V;
        fm.edplacement.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
        FillChar(TPRBIChild,SizeOf(TPRBIChild),0);
        TPRBIChild.Visual.TypeView:=tviOnlyData;
        TPRBIChild.Condition.WhereStr:=PChar(' placement_id='+inttostr(fm.placement_id)+' ');
        if _ViewInterfaceFromName(NameRbkPlacement,@TPRBIChild) then begin
         fm.placementcode:=GetFirstValueFromParamRBookInterface(@TPRBIChild,'code');
        end;
       end;
      end;
    end;

    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
   fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpStreetClick(Sender: TObject);
var
  fm: TfmEditRBEmpStreet;
begin
 try
  if not qrEmpStreet.Active then exit;
  if qrEmpStreet.isEmpty then exit;
  fm:=TfmEditRBEmpStreet.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.country_id:=qrEmpStreet.fieldbyname('country_id').AsInteger;
    fm.edcountry.Text:=qrEmpStreet.fieldByName('countryname').AsString;
    fm.region_id:=qrEmpStreet.fieldbyname('region_id').AsInteger;
    fm.edregion.Text:=qrEmpStreet.fieldByName('regionname').AsString;
    fm.regioncode:=qrEmpStreet.fieldbyname('regioncode').AsString;
    fm.state_id:=qrEmpStreet.fieldbyname('state_id').AsInteger;
    fm.edstate.Text:=qrEmpStreet.fieldByName('statename').AsString;
    fm.statecode:=qrEmpStreet.fieldbyname('statecode').AsString;
    fm.town_id:=qrEmpStreet.fieldbyname('town_id').AsInteger;
    fm.edtown.Text:=qrEmpStreet.fieldByName('townname').AsString;
    fm.towncode:=qrEmpStreet.fieldbyname('towncode').AsString;
    fm.placement_id:=qrEmpStreet.fieldbyname('placement_id').AsInteger;
    fm.edplacement.Text:=qrEmpStreet.fieldByName('placementname').AsString;
    fm.placementcode:=qrEmpStreet.fieldbyname('placementcode').AsString;
    fm.street_id:=qrEmpStreet.fieldbyname('street_id').AsInteger;
    fm.oldstreet_id:=qrEmpStreet.fieldbyname('street_id').AsInteger;
    fm.edStreet.Text:=qrEmpStreet.fieldByName('streetname').AsString;
    fm.typelive_id:=qrEmpStreet.fieldbyname('typelive_id').AsInteger;
    fm.edTypeLive.Text:=qrEmpStreet.fieldByName('typelivename').AsString;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.edhousenum.Text:=qrEmpStreet.fieldByName('housenum').AsString;
    fm.edbuildnum.Text:=qrEmpStreet.fieldByName('buildnum').AsString;
    fm.edflatnum.Text:=qrEmpStreet.fieldByName('flatnum').AsString;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpStreetClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpStreet;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpStreet+
           ' where empstreet_id='+qrEmpStreet.FieldByName('empstreet_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpStreet(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpStreet.isEmpty then exit;
  but:=DeleteWarningEx('место жительства по улице <'+
                        qrEmpStreet.FieldByName('streetname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpPersonDoc: string;
begin
  Result:=SQLRbkEmpPersonDoc+' where epd.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPersonDoc;
end;

procedure TfmRBEmpMain.ActiveEmpPersonDoc(CheckPerm: Boolean);

 function CheckPermissionEmpPersonDoc: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpPersonDoc,ttiaView)and isPerm;
  bibAddEmpPersonDoc.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPersonDoc,ttiaAdd);
  bibChangeEmpPersonDoc.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPersonDoc,ttiaChange);
  bibDelEmpPersonDoc.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPersonDoc,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpPersonDoc.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpPersonDoc then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpPersonDoc.DisableControls;
  try
   qrEmpPersonDoc.sql.Clear;
   sqls:=GetSqlEmpPersonDoc;
   qrEmpPersonDoc.sql.Add(sqls);
   qrEmpPersonDoc.Transaction.Active:=false;
   qrEmpPersonDoc.Transaction.Active:=true;
   qrEmpPersonDoc.Active:=true;
  finally
   qrEmpPersonDoc.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpPersonDoc(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpPersonDoc.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('persondoctypename') then fn:='pdt.name';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   id1:=qrEmpPersonDoc.fieldByName('persondoctype_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpPersonDoc:='';
     tcsAsc: LastOrderStrEmpPersonDoc:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpPersonDoc:=' Order by '+fn+' desc ';
   end;
   ActiveEmpPersonDoc(false);
   qrEmpPersonDoc.First;
   qrEmpPersonDoc.Locate('persondoctype_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpPersonDoc(Sender: TObject);
begin
  if not qrEmpPersonDoc.Active then exit;
  if qrEmpPersonDoc.isEmpty then exit;
  if bibChangeEmpPersonDoc.Enabled then begin
   bibChangeEmpPersonDoc.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpPersonDocClick(Sender: TObject);
var
  fm: TfmEditRBEmpPersonDoc;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpPersonDoc.Active then exit;
  fm:=TfmEditRBEmpPersonDoc.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpPersonDocClick(Sender: TObject);
var
  fm: TfmEditRBEmpPersonDoc;
begin
 try
  if not qrEmpPersonDoc.Active then exit;
  if qrEmpPersonDoc.isempty then exit;
  fm:=TfmEditRBEmpPersonDoc.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.persondoctype_id:=qrEmpPersonDoc.fieldbyname('persondoctype_id').AsInteger;
    fm.oldpersondoctype_id:=fm.persondoctype_id;
    fm.edPersonDocName.Text:=qrEmpPersonDoc.fieldByName('persondoctypename').AsString;
    fm.plant_id:=qrEmpPersonDoc.fieldbyname('plant_id').AsInteger;
    fm.edPlantName.Text:=qrEmpPersonDoc.fieldByName('plantname').AsString;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.msedSerial.Text:=qrEmpPersonDoc.fieldByName('serial').AsString;
    fm.msedSerial.EditMask:=qrEmpPersonDoc.fieldByName('maskseries').AsString;
    fm.msedNum.Text:=qrEmpPersonDoc.fieldByName('num').AsString;
    fm.msedNum.EditMask:=qrEmpPersonDoc.fieldByName('masknum').AsString;
    fm.msedPodrCode.Text:=qrEmpPersonDoc.fieldByName('podrcode').AsString;
    fm.msedPodrCode.EditMask:=qrEmpPersonDoc.fieldByName('maskpodrcode').AsString;
    if Trim(qrEmpPersonDoc.fieldByName('datewhere').AsString)<>'' then
     fm.dtpDateWhere.dateTime:=qrEmpPersonDoc.fieldByName('datewhere').AsDateTime;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpPersonDocClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpPersonDoc;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpPersonDoc+
           ' where persondoctype_id='+qrEmpPersonDoc.FieldByName('persondoctype_id').asString+
           ' and emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpPersonDoc(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpPersonDoc.isEmpty then exit;
  but:=DeleteWarningEx('документ удостоверяющий личность <'+
                        qrEmpPersonDoc.FieldByName('persondoctypename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
{      ShowError(Application.Handle,
               'Документ удостоверяющий личность <'+
               qrEmpStreet.FieldByName('persondoctypename').AsString+'> используется.');}
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpMilitary: string;
begin
  Result:=SQLRbkEmpMilitary+' where m.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpMilitary;
end;

procedure TfmRBEmpMain.ActiveEmpMilitary(CheckPerm: Boolean);

 function CheckPermissionEmpMilitary: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpMilitary,ttiaView)and isPerm;
  bibAddEmpMilitary.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpMilitary,ttiaAdd);
  bibChangeEmpMilitary.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpMilitary,ttiaChange);
  bibDelEmpMilitary.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpMilitary,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpMilitary.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpMilitary then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpMilitary.DisableControls;
  try
   qrEmpMilitary.sql.Clear;
   sqls:=GetSqlEmpMilitary;
   qrEmpMilitary.sql.Add(sqls);
   qrEmpMilitary.Transaction.Active:=false;
   qrEmpMilitary.Transaction.Active:=true;
   qrEmpMilitary.Active:=true;
  finally
   qrEmpMilitary.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpMilitary(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpMilitary.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('milrankname') then fn:='mr.name';
   if UpperCase(fn)=UpperCase('rankname') then fn:='r.name';
   if UpperCase(fn)=UpperCase('groupmilname') then fn:='gm.name';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('readyname') then fn:='rd.name';
   id1:=qrEmpMilitary.fieldByName('military_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpMilitary:='';
     tcsAsc: LastOrderStrEmpMilitary:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpMilitary:=' Order by '+fn+' desc ';
   end;
   ActiveEmpMilitary(false);
   qrEmpMilitary.First;
   qrEmpMilitary.Locate('military_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpMilitary(Sender: TObject);
begin
  if not qrEmpMilitary.Active then exit;
  if qrEmpMilitary.isEmpty then exit;
  if bibChangeEmpMilitary.Enabled then begin
   bibChangeEmpMilitary.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpMilitaryClick(Sender: TObject);
var
  fm: TfmEditRBEmpMilitary;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpMilitary.Active then exit;
  fm:=TfmEditRBEmpMilitary.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpMilitaryClick(Sender: TObject);
var
  fm: TfmEditRBEmpMilitary;
begin
 try
  if not qrEmpMilitary.Active then exit;
  if qrEmpMilitary.isempty then exit;
  fm:=TfmEditRBEmpMilitary.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.plant_id:=qrEmpMilitary.fieldByName('plant_id').AsInteger;
    fm.edPlantName.text:=qrEmpMilitary.fieldByName('plantname').AsString;
    fm.milrank_id:=qrEmpMilitary.fieldByName('milrank_id').AsInteger;
    fm.edMilRank.text:=qrEmpMilitary.fieldByName('milrankname').AsString;
    fm.rank_id:=qrEmpMilitary.fieldByName('rank_id').AsInteger;
    fm.edRank.text:=qrEmpMilitary.fieldByName('rankname').AsString;
    fm.groupmil_id:=qrEmpMilitary.fieldByName('groupmil_id').AsInteger;
    fm.edGroupMil.text:=qrEmpMilitary.fieldByName('groupmilname').AsString;
    fm.edReady.text:=qrEmpMilitary.fieldByName('readyname').AsString;
    fm.ready_id:=qrEmpMilitary.fieldByName('ready_id').AsInteger;
    fm.edCraftNum.text:=qrEmpMilitary.fieldByName('craftnum').AsString;
    fm.edSpecInclude.text:=qrEmpMilitary.fieldByName('specinclude').AsString;
    fm.edMOB.text:=qrEmpMilitary.fieldByName('mob').AsString;
    if Trim(qrEmpMilitary.fieldByName('datestart').AsString)<>'' then
     fm.dtpDateStart.dateTime:=qrEmpMilitary.fieldByName('datestart').AsDateTime;
    if Trim(qrEmpMilitary.fieldByName('datefinish').AsString)<>'' then
     fm.dtpDateFinish.dateTime:=qrEmpMilitary.fieldByName('datefinish').AsDateTime;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpMilitaryClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpMilitary;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbMilitary+
           ' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
           ' and military_id='+inttostr(qrEmpMilitary.fieldbyName('military_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpMilitary(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpMilitary.isEmpty then exit;
  but:=DeleteWarningEx('воинский учет со званием <'+
                        qrEmpMilitary.FieldByName('milrankname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpDiplom: string;
begin
  Result:=SQLRbkEmpDiplom+' where d.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpDiplom;
end;

procedure TfmRBEmpMain.ActiveEmpDiplom(CheckPerm: Boolean);

 function CheckPermissionEmpDiplom: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpDiplom,ttiaView)and isPerm;
  bibAddEmpDiplom.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpDiplom,ttiaAdd);
  bibChangeEmpDiplom.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpDiplom,ttiaChange);
  bibDelEmpDiplom.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpDiplom,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpDiplom.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpDiplom then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpDiplom.DisableControls;
  try
   qrEmpDiplom.sql.Clear;
   sqls:=GetSqlEmpDiplom;
   qrEmpDiplom.sql.Add(sqls);
   qrEmpDiplom.Transaction.Active:=false;
   qrEmpDiplom.Transaction.Active:=true;
   qrEmpDiplom.Active:=true;
  finally
   qrEmpDiplom.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpDiplom(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpDiplom.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('professionname') then fn:='p.name';
   if UpperCase(fn)=UpperCase('typestudname') then fn:='ts.name';
   if UpperCase(fn)=UpperCase('educname') then fn:='e.name';
   if UpperCase(fn)=UpperCase('craftname') then fn:='c.name';
   if UpperCase(fn)=UpperCase('schoolname') then fn:='s.name';
   id1:=qrEmpDiplom.fieldByName('diplom_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpDiplom:='';
     tcsAsc: LastOrderStrEmpDiplom:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpDiplom:=' Order by '+fn+' desc ';
   end;
   ActiveEmpDiplom(false);
   qrEmpDiplom.First;
   qrEmpDiplom.Locate('diplom_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpDiplom(Sender: TObject);
begin
  if not qrEmpDiplom.Active then exit;
  if qrEmpDiplom.isEmpty then exit;
  if bibChangeEmpDiplom.Enabled then begin
   bibChangeEmpDiplom.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpDiplomClick(Sender: TObject);
var
  fm: TfmEditRBEmpDiplom;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpDiplom.Active then exit;
  fm:=TfmEditRBEmpDiplom.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpDiplomClick(Sender: TObject);
var
  fm: TfmEditRBEmpDiplom;
begin
 try
  if not qrEmpDiplom.Active then exit;
  if qrEmpDiplom.isempty then exit;
  fm:=TfmEditRBEmpDiplom.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.olddiplom_id:=qrEmpDiplom.fieldByName('diplom_id').AsInteger;
    fm.profession_id:=qrEmpDiplom.fieldByName('profession_id').AsInteger;
    fm.edProfession.text:=qrEmpDiplom.fieldByName('professionname').AsString;
    fm.typestud_id:=qrEmpDiplom.fieldByName('typestud_id').AsInteger;
    fm.edTypeStud.text:=qrEmpDiplom.fieldByName('typestudname').AsString;
    fm.educ_id:=qrEmpDiplom.fieldByName('educ_id').AsInteger;
    fm.edEduc.text:=qrEmpDiplom.fieldByName('educname').AsString;
    fm.craft_id:=qrEmpDiplom.fieldByName('craft_id').AsInteger;
    fm.edCraft.text:=qrEmpDiplom.fieldByName('craftname').AsString;
    fm.school_id:=qrEmpDiplom.fieldByName('school_id').AsInteger;
    fm.edSchool.text:=qrEmpDiplom.fieldByName('schoolname').AsString;
    fm.edNum.text:=qrEmpDiplom.fieldByName('num').AsString;
    fm.dtpDateWhere.dateTime:=qrEmpDiplom.fieldByName('datewhere').AsDateTime;
    fm.dtpFinishDate.dateTime:=qrEmpDiplom.fieldByName('finishdate').AsDateTime;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpDiplomClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpDiplom;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbDiplom+
           ' where diplom_id='+inttostr(qrEmpDiplom.fieldbyName('diplom_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpDiplom(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpDiplom.isEmpty then exit;
  but:=DeleteWarningEx('диплом по специальности <'+
                        qrEmpDiplom.FieldByName('professionname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpBiography: string;
begin
  Result:=SQLRbkEmpBiography+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpBiography;
end;

procedure TfmRBEmpMain.ActiveEmpBiography(CheckPerm: Boolean);

 function CheckPermissionEmpBiography: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpBiography,ttiaView)and isPerm;
  bibAddEmpBiography.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpBiography,ttiaAdd);
  bibChangeEmpBiography.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpBiography,ttiaChange);
  bibDelEmpBiography.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpBiography,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpBiography.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpBiography then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpBiography.DisableControls;
  try
   qrEmpBiography.sql.Clear;
   sqls:=GetSqlEmpBiography;
   qrEmpBiography.sql.Add(sqls);
   qrEmpBiography.Transaction.Active:=false;
   qrEmpBiography.Transaction.Active:=true;
   qrEmpBiography.Active:=true;
  finally
   qrEmpBiography.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpBiography(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpBiography.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpBiography.fieldByName('biography_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpBiography:='';
     tcsAsc: LastOrderStrEmpBiography:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpBiography:=' Order by '+fn+' desc ';
   end;
   ActiveEmpBiography(false);
   qrEmpBiography.First;
   qrEmpBiography.Locate('biography_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpBiography(Sender: TObject);
begin
  if not qrEmpBiography.Active then exit;
  if qrEmpBiography.isEmpty then exit;
  if bibChangeEmpBiography.Enabled then begin
   bibChangeEmpBiography.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpBiographyClick(Sender: TObject);
var
  fm: TfmEditRBEmpBiography;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpBiography.Active then exit;
  fm:=TfmEditRBEmpBiography.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpBiographyClick(Sender: TObject);
var
  fm: TfmEditRBEmpBiography;
begin
 try
  if not qrEmpBiography.Active then exit;
  if qrEmpBiography.isempty then exit;
  fm:=TfmEditRBEmpBiography.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.meNote.Lines.text:=qrEmpBiography.fieldByName('note').AsString;
    fm.dtpDateStart.dateTime:=qrEmpBiography.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.dateTime:=qrEmpBiography.fieldByName('datefinish').AsDateTime;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpBiographyClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpBiography;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbBiography+
           ' where biography_id='+inttostr(qrEmpBiography.fieldbyName('biography_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpBiography(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpBiography.isEmpty then exit;
  but:=DeleteWarningEx('примечание <'+
                        qrEmpBiography.FieldByName('note').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpPhoto: string;
begin
  Result:=SQLRbkEmpPhoto+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPhoto;
end;

procedure TfmRBEmpMain.ActiveEmpPhoto(CheckPerm: Boolean);

 function CheckPermissionEmpPhoto: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpPhoto,ttiaView)and isPerm;
  bibAddEmpPhoto.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPhoto,ttiaAdd);
  bibChangeEmpPhoto.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPhoto,ttiaChange);
  bibDelEmpPhoto.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPhoto,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpPhoto.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpPhoto then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpPhoto.DisableControls;
  qrEmpPhoto.AfterScroll:=nil;
  imPhoto.Picture.Assign(nil);
  try
   qrEmpPhoto.sql.Clear;
   sqls:=GetSqlEmpPhoto;
   qrEmpPhoto.sql.Add(sqls);
   qrEmpPhoto.Transaction.Active:=false;
   qrEmpPhoto.Transaction.Active:=true;
   qrEmpPhoto.Active:=true;
  finally
   qrEmpPhoto.AfterScroll:=qrEmpPhotoAfterScroll;
   qrEmpPhotoAfterScroll(qrEmpPhoto);
   qrEmpPhoto.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpPhoto(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpPhoto.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpPhoto.fieldByName('photo_id').asString;
   case TypeSort of
     tcsNone: LastOrderStrEmpPhoto:='';
     tcsAsc: LastOrderStrEmpPhoto:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpPhoto:=' Order by '+fn+' desc ';
   end;
   ActiveEmpPhoto(false);
   qrEmpPhoto.First;
   qrEmpPhoto.Locate('photo_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpPhoto(Sender: TObject);
begin
  if not qrEmpPhoto.Active then exit;
  if qrEmpPhoto.isEmpty then exit;
  if bibChangeEmpPhoto.Enabled then begin
   bibChangeEmpPhoto.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpPhotoClick(Sender: TObject);
var
  fm: TfmEditRBEmpPhoto;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpPhoto.Active then exit;
  fm:=TfmEditRBEmpPhoto.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.chbPhotoStretchClick(Sender: TObject);
begin
  imPhoto.AutoSize:=not chbPhotoStretch.Checked;
  imPhoto.Stretch:=chbPhotoStretch.Checked;
  if imPhoto.Stretch then begin
   srlbxPhoto.HorzScrollBar.Range:=0;
   srlbxPhoto.VertScrollBar.Range:=0;
   imPhoto.Align:=alClient;
  end else begin
   imPhoto.Align:=alNone;
   if (imPhoto.Picture.Height>srlbxPhoto.Height-4)or
      (imPhoto.Picture.Width>srlbxPhoto.Width-4) then begin
    imPhoto.Height:=imPhoto.Picture.Height;
    imPhoto.Width:=imPhoto.Picture.Width;
   end else begin
    imPhoto.AutoSize:=false;
    imPhoto.Height:=srlbxPhoto.Height-4;
    imPhoto.Width:=srlbxPhoto.Width-4;
   end;
   srlbxPhoto.HorzScrollBar.Range:=imPhoto.Width;
   srlbxPhoto.VertScrollBar.Range:=imPhoto.Height;
  end;
end;


procedure TfmRBEmpMain.qrEmpPhotoAfterScroll(DataSet: TDataSet);
var
  newPic: TTsvPicture;
  ms: TMemoryStream;
begin
  ms:=TMemoryStream.Create;
  try
   TBlobField(DataSet.FieldByName('photo')).SaveToStream(ms);
   newpic:=TTsvPicture(imPhoto.Picture);
   try
     ms.Position:=0;
     newPic.LoadFromStream(ms);
     chbPhotoStretchClick(nil);
   except
   end;
  finally
   ms.Free;
  end; 
end;

procedure TfmRBEmpMain.bibChangeEmpPhotoClick(Sender: TObject);
var
  fm: TfmEditRBEmpPhoto;
  ms: TMemoryStream;
begin
 try
  if not qrEmpPhoto.Active then exit;
  if qrEmpPhoto.isempty then exit;
  fm:=TfmEditRBEmpPhoto.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.meNote.Lines.text:=qrEmpPhoto.fieldByName('note').AsString;
    fm.dtpDatePhoto.dateTime:=qrEmpPhoto.fieldByName('datephoto').AsDateTime;
    TBlobField(qrEmpPhoto.fieldByName('photo')).SaveToStream(ms);
    ms.Position:=0;
    TTsvPicture(fm.imPhoto.Picture).LoadFromStream(ms);
    fm.chbPhotoStretchClick(nil);
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    ms.Free;
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpPhotoClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpPhoto;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbPhoto+
           ' where photo_id='+inttostr(qrEmpPhoto.fieldbyName('photo_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpPhoto(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpPhoto.isEmpty then exit;
  but:=DeleteWarningEx('текущую фотографию ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpPlant: string;
begin
  Result:=SQLRbkEmpPlant+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpPlant;
end;

procedure TfmRBEmpMain.ActiveEmpPlant(CheckPerm: Boolean);

 function CheckPermissionEmpPlant: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpPlant,ttiaView)and isPerm;
  bibAddEmpPlant.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPlant,ttiaAdd);
  bibChangeEmpPlant.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPlant,ttiaChange);
  bibDelEmpPlant.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpPlant,ttiaDelete);
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
  qrEmpPlant.DisableControls;
  try
   qrEmpPlant.sql.Clear;
   sqls:=GetSqlEmpPlant;
   qrEmpPlant.sql.Add(sqls);
   qrEmpPlant.Transaction.Active:=false;
   qrEmpPlant.Transaction.Active:=true;
   qrEmpPlant.Active:=true;
  finally
   qrEmpPlant.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpPlant(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpPlant.Active then exit;
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
   case TypeSort of
     tcsNone: LastOrderStrEmpPlant:='';
     tcsAsc: LastOrderStrEmpPlant:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpPlant:=' Order by '+fn+' desc ';
   end;
   ActiveEmpPlant(false);
   qrEmpPlant.First;
   qrEmpPlant.Locate('empplant_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpPlant(Sender: TObject);
begin
  if not qrEmpPlant.Active then exit;
  if qrEmpPlant.isEmpty then exit;
  if bibChangeEmpPlant.Enabled then begin
   bibChangeEmpPlant.Click;
  end;
end;


procedure TfmRBEmpMain.bibAddEmpPlantClick(Sender: TObject);
var
  fm: TfmEditRBEmpPlant;
  TPRBI: TParamRBookInterface;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpPlant.Active then exit;
  fm:=TfmEditRBEmpPlant.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Предприятие'))+' ');
    if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
      fm.plant_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
      fm.edPlant.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
    end;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

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

procedure SetLastFactPay(empplant_id: Integer; var pay: Currency; var factpay_id: Integer);
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
   sqls:='Select pay,factpay_id from '+tbFactPay+
         ' where factpay_id=(select max(n1.factpay_id) from '+tbFactPay+' n1'+
         ' where n1.empplant_id='+inttostr(empplant_id)+')';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     pay:=qrnew.FieldByName('pay').AsCurrency;
     factpay_id:=qrnew.FieldByName('factpay_id').AsInteger;
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

procedure TfmRBEmpMain.bibChangeEmpPlantClick(Sender: TObject);
var
  fm: TfmEditRBEmpPlant;
  schedulename: string;
  pay: Currency;
begin
 try
  if not qrEmpPlant.Active then exit;
  if qrEmpPlant.isempty then exit;
  fm:=TfmEditRBEmpPlant.Create(nil);
  try
    fm.ParentEmpForm:=Self;
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
    SetLastFactPay(qrEmpPlant.fieldByName('empplant_id').AsInteger,pay,fm.factpay_id);
    fm.edPay.Text:=FloatToStr(pay);

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpPlantClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpPlant;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpPlant+
           ' where empplant_id='+inttostr(qrEmpPlant.fieldbyName('empplant_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpPlant(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpPlant.isEmpty then exit;
  but:=DeleteWarningEx('текущее место работы ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBEmpMain.bibAdjustClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt.x:=bibAdjust.Left+bibAdjust.Width;
  pt.y:=bibAdjust.Top+bibAdjust.Height;
  pt:=pnModal.ClientToScreen(pt);
  pmAdjust.Popup(pt.x,pt.y);
end;

procedure TfmRBEmpMain.miAdjustColumnsClick(Sender: TObject);
begin
  SetAdjust(Grid.Columns,nil);
end;

procedure TfmRBEmpMain.miAdjustTabsClick(Sender: TObject);
var
  lasttbs: TTabSheet;
begin
  lasttbs:=pglink.ActivePage;
//  SetAdjustTabs(pglink);
  if pglink.ActivePage<>lasttbs then
    ActiveAll;
end;

procedure TfmRBEmpMain.imPhotoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetCursor(Screen.Cursors[crImageDown]);
  PointClicked:=imPhoto.ClientToScreen(Point(X,Y));
  FoldPosX:=(imPhoto.Parent as TScrollBox).HorzScrollBar.Position;
  FoldPosY:=(imPhoto.Parent as TScrollBox).VertScrollBar.Position;
end;

procedure TfmRBEmpMain.imPhotoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 CurPoint: TPoint;
begin
  if (imPhoto.Parent is TScrollBox) and (ssLeft in Shift) then begin
   CurPoint:=imPhoto.ClientToScreen(Point(X,Y));
   (imPhoto.Parent as TScrollBox).HorzScrollBar.Position:=FOldPosX-CurPoint.X+PointClicked.X;
   (imPhoto.Parent as TScrollBox).VertScrollBar.Position:=FOldPosY-CurPoint.Y+PointClicked.Y;
  end;
end;

procedure TfmRBEmpMain.imPhotoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imPhoto.Cursor:=crImageMove;
end;

function TfmRBEmpMain.GetSqlEmpFaceAccount: string;
begin
  Result:=SQLRbkEmpFaceAccount+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpFaceAccount;
end;

procedure TfmRBEmpMain.ActiveEmpFaceAccount(CheckPerm: Boolean);

 function CheckPermissionEmpFaceAccount: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpFaceAccount,ttiaView)and isPerm;
  bibAddEmpFaceAccount.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpFaceAccount,ttiaAdd);
  bibChangeEmpFaceAccount.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpFaceAccount,ttiaChange);
  bibDelEmpFaceAccount.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpFaceAccount,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpFaceAccount.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpFaceAccount then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpFaceAccount.DisableControls;
  try
   qrEmpFaceAccount.sql.Clear;
   sqls:=GetSqlEmpFaceAccount;
   qrEmpFaceAccount.sql.Add(sqls);
   qrEmpFaceAccount.Transaction.Active:=false;
   qrEmpFaceAccount.Transaction.Active:=true;
   qrEmpFaceAccount.Active:=true;
  finally
   qrEmpFaceAccount.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpFaceAccount(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpFaceAccount.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpFaceAccount.fieldByName('empfaceaccount_id').asString;
   if UpperCase(fn)=UpperCase('currencyname') then fn:='c.name';
   if UpperCase(fn)=UpperCase('bankname') then fn:='b.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpFaceAccount:='';
     tcsAsc: LastOrderStrEmpFaceAccount:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpFaceAccount:=' Order by '+fn+' desc ';
   end;
   ActiveEmpFaceAccount(false);
   qrEmpFaceAccount.First;
   qrEmpFaceAccount.Locate('empfaceaccount_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpFaceAccount(Sender: TObject);
begin
  if not qrEmpFaceAccount.Active then exit;
  if qrEmpFaceAccount.isEmpty then exit;
  if bibChangeEmpFaceAccount.Enabled then begin
   bibChangeEmpFaceAccount.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpFaceAccountClick(Sender: TObject);
var
  fm: TfmEditRBEmpFaceAccount;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpFaceAccount.Active then exit;
  fm:=TfmEditRBEmpFaceAccount.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpFaceAccountClick(Sender: TObject);
var
  fm: TfmEditRBEmpFaceAccount;
begin
 try
  if not qrEmpFaceAccount.Active then exit;
  if qrEmpFaceAccount.isempty then exit;
  fm:=TfmEditRBEmpFaceAccount.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.edNum.Text:=qrEmpFaceAccount.fieldByName('num').AsString;
    fm.currency_id:=qrEmpFaceAccount.fieldByName('currency_id').AsInteger;
    fm.edCurrency.Text:=qrEmpFaceAccount.fieldByName('currencyname').AsString;
    fm.bank_id:=qrEmpFaceAccount.fieldByName('bank_id').AsInteger;
    fm.edBank.Text:=qrEmpFaceAccount.fieldByName('bankname').AsString;
    fm.edPercent.Text:=qrEmpFaceAccount.fieldByName('percent').AsString;
    fm.edSumm.Text:=qrEmpFaceAccount.fieldByName('summ').AsString;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpFaceAccountClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpFaceAccount;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpFaceAccount+
           ' where empfaceaccount_id='+
           inttostr(qrEmpFaceAccount.fieldbyName('empfaceaccount_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpFaceAccount(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpFaceAccount.isEmpty then exit;
  but:=DeleteWarningEx('лицевой счет <'+
                        qrEmpFaceAccount.FieldByName('num').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpSickList: string;
begin
  Result:=SQLRbkEmpSickList+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpSickList;
end;

procedure TfmRBEmpMain.ActiveEmpSickList(CheckPerm: Boolean);

 function CheckPermissionEmpSickList: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpSickList,ttiaView)and isPerm;
  bibAddEmpSickList.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpSickList,ttiaAdd);
  bibChangeEmpSickList.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpSickList,ttiaChange);
  bibDelEmpSickList.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpSickList,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpSickList.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpSickList then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpSickList.DisableControls;
  try
   qrEmpSickList.sql.Clear;
   sqls:=GetSqlEmpSickList;
   qrEmpSickList.sql.Add(sqls);
   qrEmpSickList.Transaction.Active:=false;
   qrEmpSickList.Transaction.Active:=true;
   qrEmpSickList.Active:=true;
  finally
   qrEmpSickList.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpSickList(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpSickList.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpSickList.fieldByName('empsicklist_id').asString;
   if UpperCase(fn)=UpperCase('sickname') then fn:='s.name';
   if UpperCase(fn)=UpperCase('absencename') then fn:='a.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpSickList:='';
     tcsAsc: LastOrderStrEmpSickList:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpSickList:=' Order by '+fn+' desc ';
   end;
   ActiveEmpSickList(false);
   qrEmpSickList.First;
   qrEmpSickList.Locate('empsicklist_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpSickList(Sender: TObject);
begin
  if not qrEmpSickList.Active then exit;
  if qrEmpSickList.isEmpty then exit;
  if bibChangeEmpSickList.Enabled then begin
   bibChangeEmpSickList.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpSickListClick(Sender: TObject);
var
  fm: TfmEditRBEmpSickList;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpSickList.Active then exit;
  fm:=TfmEditRBEmpSickList.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpSickListClick(Sender: TObject);
var
  fm: TfmEditRBEmpSickList;
begin
 try
  if not qrEmpSickList.Active then exit;
  if qrEmpSickList.isempty then exit;
  fm:=TfmEditRBEmpSickList.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.edNum.Text:=qrEmpSickList.fieldByName('num').AsString;
    fm.sick_id:=qrEmpSickList.fieldByName('sick_id').AsInteger;
    fm.edSick.Text:=qrEmpSickList.fieldByName('sickname').AsString;
    fm.absence_id:=qrEmpSickList.fieldByName('absence_id').AsInteger;
    fm.edAbsence.Text:=qrEmpSickList.fieldByName('absencename').AsString;
    fm.dtpDateStart.Date:=qrEmpSickList.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.Date:=qrEmpSickList.fieldByName('datefinish').AsDateTime;
    fm.edPercent.Text:=qrEmpSickList.fieldByName('percent').AsString;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpSickListClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpSickList;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpSickList+
           ' where empsicklist_id='+
           inttostr(qrEmpSickList.fieldbyName('empsicklist_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpSickList(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpSickList.isEmpty then exit;
  but:=DeleteWarningEx('текущий больничный лист ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpLaborBook: string;
begin
  Result:=SQLRbkEmpLaborBook+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpLaborBook;
end;

procedure TfmRBEmpMain.ActiveEmpLaborBook(CheckPerm: Boolean);

 function CheckPermissionEmpLaborBook: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpLaborBook,ttiaView)and isPerm;
  bibAddEmpLaborBook.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLaborBook,ttiaAdd);
  bibChangeEmpLaborBook.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLaborBook,ttiaChange);
  bibDelEmpLaborBook.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLaborBook,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpLaborBook.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpLaborBook then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpLaborBook.DisableControls;
  try
   qrEmpLaborBook.sql.Clear;
   sqls:=GetSqlEmpLaborBook;
   qrEmpLaborBook.sql.Add(sqls);
   qrEmpLaborBook.Transaction.Active:=false;
   qrEmpLaborBook.Transaction.Active:=true;
   qrEmpLaborBook.Active:=true;
  finally
   qrEmpLaborBook.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpLaborBook(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpLaborBook.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpLaborBook.fieldByName('emplaborbook_id').asString;
   if UpperCase(fn)=UpperCase('profname') then fn:='pr.name';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('motivename') then fn:='m.name';
   if UpperCase(fn)=UpperCase('mainprofplus') then fn:='mainprof';
   case TypeSort of
     tcsNone: LastOrderStrEmpLaborBook:='';
     tcsAsc: LastOrderStrEmpLaborBook:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpLaborBook:=' Order by '+fn+' desc ';
   end;
   ActiveEmpLaborBook(false);
   qrEmpLaborBook.First;
   qrEmpLaborBook.Locate('emplaborbook_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpLaborBook(Sender: TObject);
begin
  if not qrEmpLaborBook.Active then exit;
  if qrEmpLaborBook.isEmpty then exit;
  if bibChangeEmpLaborBook.Enabled then begin
   bibChangeEmpLaborBook.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpLaborBookClick(Sender: TObject);
var
  fm: TfmEditRBEmpLaborBook;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpLaborBook.Active then exit;
  fm:=TfmEditRBEmpLaborBook.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpLaborBookClick(Sender: TObject);
var
  fm: TfmEditRBEmpLaborBook;
begin
 try
  if not qrEmpLaborBook.Active then exit;
  if qrEmpLaborBook.isempty then exit;
  fm:=TfmEditRBEmpLaborBook.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.prof_id:=qrEmpLaborBook.fieldbyname('prof_id').AsInteger;
    fm.edProf.text:=qrEmpLaborBook.fieldbyname('profname').AsString;
    fm.plant_id:=qrEmpLaborBook.fieldbyname('plant_id').AsInteger;
    fm.edPlant.text:=qrEmpLaborBook.fieldbyname('plantname').AsString;
    fm.motive_id:=qrEmpLaborBook.fieldbyname('motive_id').AsInteger;
    fm.edMotive.text:=qrEmpLaborBook.fieldbyname('motivename').AsString;
    fm.dtpDateStart.dateTime:=qrEmpLaborBook.fieldByName('datestart').AsDateTime;
    if Trim(qrEmpLaborBook.fieldByName('datefinish').AsString)<>'' then
     fm.dtpDateFinish.dateTime:=qrEmpLaborBook.fieldByName('datefinish').AsDateTime;
    fm.meHint.Lines.text:=qrEmpLaborBook.fieldByName('hint').AsString;
    fm.chbMainProf.Checked:=Boolean(qrEmpLaborBook.fieldByName('mainprof').AsInteger);
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpLaborBookClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpLaborBook;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpLaborBook+
           ' where emplaborbook_id='+
           inttostr(qrEmpLaborBook.fieldbyName('emplaborbook_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpLaborBook(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpLaborBook.isEmpty then exit;
  but:=DeleteWarningEx('текущую запись в трудовой книжке ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBEmpMain.GridDrawColumnCellEmpLaborBook(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;    
begin
  if not qrEmpLaborBook.Active then exit;
  if qrEmpLaborBook.isEmpty then exit;
  if Column.Title.Caption='Основная профессия' then begin
    rt.Right:=rect.Right;
    rt.Left:=rect.Left;
    rt.Top:=rect.Top+2;
    rt.Bottom:=rect.Bottom-2;
    chk:=Boolean(qrEmpLaborBook.FieldByName('mainprof').AsInteger);
    if not chk then Begin
     DrawFrameControl(GridEmpLaborBook.Canvas.Handle, Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(GridEmpLaborBook.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpRefreshCourse: string;
begin
  Result:=SQLRbkEmpRefreshCourse+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpRefreshCourse;
end;

procedure TfmRBEmpMain.ActiveEmpRefreshCourse(CheckPerm: Boolean);

 function CheckPermissionEmpRefreshCourse: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpRefreshCourse,ttiaView)and isPerm;
  bibAddEmpRefreshCourse.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpRefreshCourse,ttiaAdd);
  bibChangeEmpRefreshCourse.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpRefreshCourse,ttiaChange);
  bibDelEmpRefreshCourse.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpRefreshCourse,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpRefreshCourse.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpRefreshCourse then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpRefreshCourse.DisableControls;
  try
   qrEmpRefreshCourse.sql.Clear;
   sqls:=GetSqlEmpRefreshCourse;
   qrEmpRefreshCourse.sql.Add(sqls);
   qrEmpRefreshCourse.Transaction.Active:=false;
   qrEmpRefreshCourse.Transaction.Active:=true;
   qrEmpRefreshCourse.Active:=true;
  finally
   qrEmpRefreshCourse.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpRefreshCourse(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpRefreshCourse.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpRefreshCourse.fieldByName('emprefreshcourse_id').asString;
   if UpperCase(fn)=UpperCase('profname') then fn:='pr.name';
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('documnum') then fn:='d.num';
   if UpperCase(fn)=UpperCase('absencename') then fn:='a.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpRefreshCourse:='';
     tcsAsc: LastOrderStrEmpRefreshCourse:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpRefreshCourse:=' Order by '+fn+' desc ';
   end;
   ActiveEmpRefreshCourse(false);
   qrEmpRefreshCourse.First;
   qrEmpRefreshCourse.Locate('emprefreshcourse_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpRefreshCourse(Sender: TObject);
begin
  if not qrEmpRefreshCourse.Active then exit;
  if qrEmpRefreshCourse.isEmpty then exit;
  if bibChangeEmpRefreshCourse.Enabled then begin
   bibChangeEmpRefreshCourse.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpRefreshCourseClick(Sender: TObject);
var
  fm: TfmEditRBEmpRefreshCourse;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpRefreshCourse.Active then exit;
  fm:=TfmEditRBEmpRefreshCourse.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpRefreshCourseClick(Sender: TObject);
var
  fm: TfmEditRBEmpRefreshCourse;
begin
 try
  if not qrEmpRefreshCourse.Active then exit;
  if qrEmpRefreshCourse.isempty then exit;
  fm:=TfmEditRBEmpRefreshCourse.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.prof_id:=qrEmpRefreshCourse.fieldbyname('prof_id').AsInteger;
    fm.edProf.text:=qrEmpRefreshCourse.fieldbyname('profname').AsString;
    fm.plant_id:=qrEmpRefreshCourse.fieldbyname('plant_id').AsInteger;
    fm.edPlant.text:=qrEmpRefreshCourse.fieldbyname('plantname').AsString;
    fm.docum_id:=qrEmpRefreshCourse.fieldbyname('docum_id').AsInteger;
    fm.edDocum.text:=qrEmpRefreshCourse.fieldbyname('documnum').AsString;
    fm.absence_id:=qrEmpRefreshCourse.fieldbyname('absence_id').AsInteger;
    fm.edAbsence.text:=qrEmpRefreshCourse.fieldbyname('absencename').AsString;

    fm.dtpDateStart.dateTime:=qrEmpRefreshCourse.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.dateTime:=qrEmpRefreshCourse.fieldByName('datefinish').AsDateTime;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpRefreshCourseClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpRefreshCourse;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpRefreshCourse+
           ' where emprefreshcourse_id='+
           inttostr(qrEmpRefreshCourse.fieldbyName('emprefreshcourse_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpRefreshCourse(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpRefreshCourse.isEmpty then exit;
  but:=DeleteWarningEx('текущую переподготовку ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpLeave: string;
begin
  Result:=SQLRbkEmpLeave+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpLeave;
end;

procedure TfmRBEmpMain.ActiveEmpLeave(CheckPerm: Boolean);

 function CheckPermissionEmpLeave: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpLeave,ttiaView)and isPerm;
  bibAddEmpLeave.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLeave,ttiaAdd);
  bibChangeEmpLeave.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLeave,ttiaChange);
  bibDelEmpLeave.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpLeave,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpLeave.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpLeave then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpLeave.DisableControls;
  try
   qrEmpLeave.sql.Clear;
   sqls:=GetSqlEmpLeave;
   qrEmpLeave.sql.Add(sqls);
   qrEmpLeave.Transaction.Active:=false;
   qrEmpLeave.Transaction.Active:=true;
   qrEmpLeave.Active:=true;
  finally
   qrEmpLeave.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpLeave(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpLeave.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpLeave.fieldByName('empleave_id').asString;
   if UpperCase(fn)=UpperCase('documnum') then fn:='d.num';
   if UpperCase(fn)=UpperCase('typeleavename') then fn:='tl.name';
   if UpperCase(fn)=UpperCase('absencename') then fn:='a.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpLeave:='';
     tcsAsc: LastOrderStrEmpLeave:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpLeave:=' Order by '+fn+' desc ';
   end;
   ActiveEmpLeave(false);
   qrEmpLeave.First;
   qrEmpLeave.Locate('empleave_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpLeave(Sender: TObject);
begin
  if not qrEmpLeave.Active then exit;
  if qrEmpLeave.isEmpty then exit;
  if bibChangeEmpLeave.Enabled then begin
   bibChangeEmpLeave.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpLeaveClick(Sender: TObject);
var
  fm: TfmEditRBEmpLeave;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpLeave.Active then exit;
  fm:=TfmEditRBEmpLeave.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpLeaveClick(Sender: TObject);
var
  fm: TfmEditRBEmpLeave;
begin
 try
  if not qrEmpLeave.Active then exit;
  if qrEmpLeave.isempty then exit;
  fm:=TfmEditRBEmpLeave.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.docum_id:=qrEmpLeave.fieldbyname('docum_id').AsInteger;
    fm.edDocum.text:=qrEmpLeave.fieldbyname('documnum').AsString;
    fm.typeleave_id:=qrEmpLeave.fieldbyname('typeleave_id').AsInteger;
    fm.edTypeLeave.text:=qrEmpLeave.fieldbyname('typeleavename').AsString;
    fm.absence_id:=qrEmpLeave.fieldbyname('absence_id').AsInteger;
    fm.edAbsence.text:=qrEmpLeave.fieldbyname('absencename').AsString;
    fm.dtpForPeriod.dateTime:=qrEmpLeave.fieldByName('forperiod').AsDateTime;
    fm.dtpForPeriodOn.dateTime:=qrEmpLeave.fieldByName('forperiodon').AsDateTime;
    fm.dtpDateStart.dateTime:=qrEmpLeave.fieldByName('datestart').AsDateTime;
    fm.edMainAmountCalDay.text:=qrEmpLeave.fieldbyname('mainamountcalday').AsString;
    fm.edAddAmountCalDay.text:=qrEmpLeave.fieldbyname('addamountcalday').AsString;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpLeaveClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpLeave;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpLeave+
           ' where empleave_id='+
           inttostr(qrEmpLeave.fieldbyName('empleave_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpLeave(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpLeave.isEmpty then exit;
  but:=DeleteWarningEx('текущий отпуск ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpQual: string;
begin
  Result:=SQLRbkEmpQual+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpQual;
end;

procedure TfmRBEmpMain.ActiveEmpQual(CheckPerm: Boolean);

 function CheckPermissionEmpQual: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpQual,ttiaView)and isPerm;
  bibAddEmpQual.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpQual,ttiaAdd);
  bibChangeEmpQual.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpQual,ttiaChange);
  bibDelEmpQual.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpQual,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpQual.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpQual then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpQual.DisableControls;
  try
   qrEmpQual.sql.Clear;
   sqls:=GetSqlEmpQual;
   qrEmpQual.sql.Add(sqls);
   qrEmpQual.Transaction.Active:=false;
   qrEmpQual.Transaction.Active:=true;
   qrEmpQual.Active:=true;
  finally
   qrEmpQual.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpQual(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpQual.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpQual.fieldByName('empqual_id').asString;
   if UpperCase(fn)=UpperCase('documnum') then fn:='d1.num';
   if UpperCase(fn)=UpperCase('resdocumnum') then fn:='d2.num';
   if UpperCase(fn)=UpperCase('typeresqualname') then fn:='trq.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpQual:='';
     tcsAsc: LastOrderStrEmpQual:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpQual:=' Order by '+fn+' desc ';
   end;
   ActiveEmpQual(false);
   qrEmpQual.First;
   qrEmpQual.Locate('empqual_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpQual(Sender: TObject);
begin
  if not qrEmpQual.Active then exit;
  if qrEmpQual.isEmpty then exit;
  if bibChangeEmpQual.Enabled then begin
   bibChangeEmpQual.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpQualClick(Sender: TObject);
var
  fm: TfmEditRBEmpQual;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpQual.Active then exit;
  fm:=TfmEditRBEmpQual.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpQualClick(Sender: TObject);
var
  fm: TfmEditRBEmpQual;
begin
 try
  if not qrEmpQual.Active then exit;
  if qrEmpQual.isempty then exit;
  fm:=TfmEditRBEmpQual.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.docum_id:=qrEmpQual.fieldbyname('docum_id').AsInteger;
    fm.edDocum.text:=qrEmpQual.fieldbyname('documnum').AsString;
    fm.resdocum_id:=qrEmpQual.fieldbyname('resdocum_id').AsInteger;
    fm.edResDocum.text:=qrEmpQual.fieldbyname('resdocumnum').AsString;
    fm.typeresqual_id:=qrEmpQual.fieldbyname('typeresqual_id').AsInteger;
    fm.edTypeResQual.text:=qrEmpQual.fieldbyname('typeresqualname').AsString;
    fm.dtpDateStart.dateTime:=qrEmpQual.fieldByName('datestart').AsDateTime;

    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpQualClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpQual;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpQual+
           ' where empqual_id='+
           inttostr(qrEmpQual.fieldbyName('empqual_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpQual(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpQual.isEmpty then exit;
  but:=DeleteWarningEx('аттестацию за <'+
                        qrEmpQual.FieldByName('datestart').AsString+'> ?');

  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpEncouragements: string;
begin
  Result:=SQLRbkEmpEncouragements+' where emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpEncouragements;
end;

procedure TfmRBEmpMain.ActiveEmpEncouragements(CheckPerm: Boolean);

 function CheckPermissionEmpEncouragements: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpEncouragements,ttiaView)and isPerm;
  bibAddEmpEncouragements.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpEncouragements,ttiaAdd);
  bibChangeEmpEncouragements.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpEncouragements,ttiaChange);
  bibDelEmpEncouragements.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpEncouragements,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpEncouragements.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpEncouragements then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpEncouragements.DisableControls;
  try
   qrEmpEncouragements.sql.Clear;
   sqls:=GetSqlEmpEncouragements;
   qrEmpEncouragements.sql.Add(sqls);
   qrEmpEncouragements.Transaction.Active:=false;
   qrEmpEncouragements.Transaction.Active:=true;
   qrEmpEncouragements.Active:=true;
  finally
   qrEmpEncouragements.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpEncouragements(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpEncouragements.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpEncouragements.fieldByName('empencouragements_id').asString;
   if UpperCase(fn)=UpperCase('documnum') then fn:='d.num';
   if UpperCase(fn)=UpperCase('typeencouragementsname') then fn:='te.name';
   case TypeSort of
     tcsNone: LastOrderStrEmpEncouragements:='';
     tcsAsc: LastOrderStrEmpEncouragements:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpEncouragements:=' Order by '+fn+' desc ';
   end;
   ActiveEmpEncouragements(false);
   qrEmpEncouragements.First;
   qrEmpEncouragements.Locate('empencouragements_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpEncouragements(Sender: TObject);
begin
  if not qrEmpEncouragements.Active then exit;
  if qrEmpEncouragements.isEmpty then exit;
  if bibChangeEmpEncouragements.Enabled then begin
   bibChangeEmpEncouragements.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpEncouragementsClick(Sender: TObject);
var
  fm: TfmEditRBEmpEncouragements;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpEncouragements.Active then exit;
  fm:=TfmEditRBEmpEncouragements.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeEmpEncouragementsClick(Sender: TObject);
var
  fm: TfmEditRBEmpEncouragements;
begin
 try
  if not qrEmpEncouragements.Active then exit;
  if qrEmpEncouragements.isempty then exit;
  fm:=TfmEditRBEmpEncouragements.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.docum_id:=qrEmpEncouragements.fieldbyname('docum_id').AsInteger;
    fm.edDocum.text:=qrEmpEncouragements.fieldbyname('documnum').AsString;
    fm.typeencouragements_id:=qrEmpEncouragements.fieldbyname('typeencouragements_id').AsInteger;
    fm.edTypeEncouragements.text:=qrEmpEncouragements.fieldbyname('typeencouragementsname').AsString;
    fm.dtpDateStart.dateTime:=qrEmpEncouragements.fieldByName('datestart').AsDateTime;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpEncouragementsClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpEncouragements;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpEncouragements+
           ' where empencouragements_id='+
           inttostr(qrEmpEncouragements.fieldbyName('empencouragements_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpEncouragements(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpEncouragements.isEmpty then exit;
  but:=DeleteWarningEx('поощрение-взыскание за <'+
                        qrEmpEncouragements.FieldByName('datestart').AsString+'> ?');

  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpBustripsfromus: string;
begin
  Result:=SQLRbkEmpBustripsfromus+' where eb.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpBustripsfromus;
end;

procedure TfmRBEmpMain.ActiveEmpBustripsfromus(CheckPerm: Boolean);

 function CheckPermissionEmpBustripsfromus: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpBustripsfromus,ttiaView)and isPerm;
  bibAddEmpBustripsfromus.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpBustripsfromus,ttiaAdd);
  bibChangeEmpBustripsfromus.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpBustripsfromus,ttiaChange);
  bibDelEmpBustripsfromus.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpBustripsfromus,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpBustripsfromus.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpBustripsfromus then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpBustripsfromus.DisableControls;
  try
   qrEmpBustripsfromus.sql.Clear;
   sqls:=GetSqlEmpBustripsfromus;
   qrEmpBustripsfromus.sql.Add(sqls);
   qrEmpBustripsfromus.Transaction.Active:=false;
   qrEmpBustripsfromus.Transaction.Active:=true;
   qrEmpBustripsfromus.Active:=true;
  finally
   qrEmpBustripsfromus.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpBustripsfromus(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpBustripsfromus.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpBustripsfromus.fieldByName('empbustripsfromus_id').asString;
   if UpperCase(fn)=UpperCase('documnum') then fn:='d.num';
   if UpperCase(fn)=UpperCase('empprojfname') then fn:='ep.fname';
   if UpperCase(fn)=UpperCase('empdirectfname') then fn:='ed.fname';
   if UpperCase(fn)=UpperCase('okplus') then fn:='ok';
   if UpperCase(fn)=UpperCase('absencename') then fn:='a.name';
   if UpperCase(fn)=UpperCase('num') then fn:='eb.num';
   case TypeSort of
     tcsNone: LastOrderStrEmpBustripsfromus:='';
     tcsAsc: LastOrderStrEmpBustripsfromus:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpBustripsfromus:=' Order by '+fn+' desc ';
   end;
   ActiveEmpBustripsfromus(false);
   qrEmpBustripsfromus.First;
   qrEmpBustripsfromus.Locate('empbustripsfromus_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpBustripsfromus(Sender: TObject);
begin
  if not qrEmpBustripsfromus.Active then exit;
  if qrEmpBustripsfromus.isEmpty then exit;
  if bibChangeEmpBustripsfromus.Enabled then begin
   bibChangeEmpBustripsfromus.Click;
  end;
end;

procedure TfmRBEmpMain.bibAddEmpBustripsfromusClick(Sender: TObject);
var
  fm: TfmEditRBEmpBustripsfromus;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpBustripsfromus.Active then exit;
  fm:=TfmEditRBEmpBustripsfromus.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDrawColumnCellEmpBustripsfromus(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;
begin
  if not qrEmpBustripsfromus.Active then exit;
  if qrEmpBustripsfromus.isEmpty then exit;
  if Column.Title.Caption='Заверено' then begin
    rt.Right:=rect.Right;
    rt.Left:=rect.Left;
    rt.Top:=rect.Top+2;
    rt.Bottom:=rect.Bottom-2;
    chk:=Boolean(qrEmpBustripsfromus.FieldByName('ok').AsInteger);
    if not chk then Begin
     DrawFrameControl(GridEmpBustripsfromus.Canvas.Handle, Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(GridEmpBustripsfromus.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;


procedure TfmRBEmpMain.bibChangeEmpBustripsfromusClick(Sender: TObject);
var
  fm: TfmEditRBEmpBustripsfromus;
begin
 try
  if not qrEmpBustripsfromus.Active then exit;
  if qrEmpBustripsfromus.isempty then exit;
  fm:=TfmEditRBEmpBustripsfromus.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.docum_id:=qrEmpBustripsfromus.fieldbyname('docum_id').AsInteger;
    fm.edDocum.text:=qrEmpBustripsfromus.fieldbyname('documnum').AsString;
    fm.Absence_id:=qrEmpBustripsfromus.fieldbyname('absence_id').AsInteger;
    fm.edAbsence.text:=qrEmpBustripsfromus.fieldbyname('absencename').AsString;
    fm.empproj_id:=qrEmpBustripsfromus.fieldbyname('empproj_id').AsInteger;
    fm.edEmpProj.text:=qrEmpBustripsfromus.fieldbyname('empprojfname').AsString;
    fm.empdirect_id:=qrEmpBustripsfromus.fieldbyname('empdirect_id').AsInteger;
    fm.edEmpdirect.text:=qrEmpBustripsfromus.fieldbyname('empdirectfname').AsString;
    fm.edNum.text:=qrEmpBustripsfromus.fieldbyname('num').AsString;
    fm.dtpDateStart.dateTime:=qrEmpBustripsfromus.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.dateTime:=qrEmpBustripsfromus.fieldByName('datefinish').AsDateTime;
    fm.chbOk.Checked:=Boolean(qrEmpBustripsfromus.fieldByName('ok').AsInteger);
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelEmpBustripsfromusClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpBustripsfromus;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpBustripsfromus+
           ' where empbustripsfromus_id='+
           inttostr(qrEmpBustripsfromus.fieldbyName('empbustripsfromus_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpBustripsfromus(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpBustripsfromus.isEmpty then exit;
  but:=DeleteWarningEx('текущую командировку ?');

  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

function TfmRBEmpMain.GetSqlEmpReferences: string;
begin
  Result:=SQLRbkEmpReferences+' where er.emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+
         LastOrderStrEmpReferences;
end;

procedure TfmRBEmpMain.ActiveEmpReferences(CheckPerm: Boolean);

 function CheckPermissionEmpReferences: Boolean;
 var
  isPermNew: Boolean;
 begin
  isPermNew:=_isPermissionOnInterface(hInterfaceRbkEmpReferences,ttiaView)and isPerm;
  bibAddEmpReferences.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpReferences,ttiaAdd);
  bibChangeEmpReferences.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpReferences,ttiaChange);
  bibDelEmpReferences.Enabled:=isPermNew and _isPermissionOnInterface(hInterfaceRbkEmpReferences,ttiaDelete);
  Result:=isPermNew;
 end;

var
 sqls: String;
begin
 try
  qrEmpReferences.Active:=false;
  if CheckPerm then
   if not CheckPermissionEmpReferences then exit;

  Screen.Cursor:=crHourGlass;
  qrEmpReferences.DisableControls;
  try
   qrEmpReferences.sql.Clear;
   sqls:=GetSqlEmpReferences;
   qrEmpReferences.sql.Add(sqls);
   qrEmpReferences.Transaction.Active:=false;
   qrEmpReferences.Transaction.Active:=true;
   qrEmpReferences.Active:=true;
  finally
   qrEmpReferences.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridTitleClickWithSortEmpReferences(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1: string;
begin
 try
   if not qrEmpReferences.Active then exit;
   fn:=Column.FieldName;
   id1:=qrEmpReferences.fieldByName('empreferences_id').asString;
   if UpperCase(fn)=UpperCase('typereferencesname') then fn:='tr.name';
   if UpperCase(fn)=UpperCase('okplus') then fn:='ok';
   case TypeSort of
     tcsNone: LastOrderStrEmpReferences:='';
     tcsAsc: LastOrderStrEmpReferences:=' Order by '+fn+' asc ';
     tcsDesc: LastOrderStrEmpReferences:=' Order by '+fn+' desc ';
   end;
   ActiveEmpReferences(false);
   qrEmpReferences.First;
   qrEmpReferences.Locate('empreferences_id',id1,[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.GridDblClickEmpReferences(Sender: TObject);
begin
  if not qrEmpReferences.Active then exit;
  if qrEmpReferences.isEmpty then exit;
  if bibChangeEmpReferences.Enabled then begin
   bibChangeEmpReferences.Click;
  end;
end;

procedure TfmRBEmpMain.GridDrawColumnCellEmpReferences(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;
begin
  if not qrEmpReferences.Active then exit;
  if qrEmpReferences.isEmpty then exit;
  if Column.Title.Caption='Заверено' then begin
    rt.Right:=rect.Right;
    rt.Left:=rect.Left;
    rt.Top:=rect.Top+2;
    rt.Bottom:=rect.Bottom-2;
    chk:=Boolean(qrEmpReferences.FieldByName('ok').AsInteger);
    if not chk then Begin
     DrawFrameControl(GridEmpReferences.Canvas.Handle, Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(GridEmpReferences.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;

procedure TfmRBEmpMain.bibAddempreferencesClick(Sender: TObject);
var
  fm: TfmEditRBEmpReferences;
begin
 try
  if Mainqr.IsEmpty then exit;
  if not qrEmpReferences.Active then exit;
  fm:=TfmEditRBEmpReferences.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibChangeempreferencesClick(Sender: TObject);
var
  fm: TfmEditRBEmpReferences;
begin
 try
  if not qrEmpReferences.Active then exit;
  if qrEmpReferences.isempty then exit;
  fm:=TfmEditRBEmpReferences.Create(nil);
  try
    fm.ParentEmpForm:=Self;
    fm.emp_id:=Mainqr.fieldbyname('emp_id').AsInteger;
    fm.typereferences_id:=qrEmpReferences.fieldbyname('typereferences_id').AsInteger;
    fm.edTypeReferences.text:=qrEmpReferences.fieldbyname('typereferencesname').AsString;
    fm.dtpDateStart.dateTime:=qrEmpReferences.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.dateTime:=qrEmpReferences.fieldByName('datefinish').AsDateTime;
    fm.chbOk.Checked:=Boolean(qrEmpReferences.fieldByName('ok').AsInteger);
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBEmpMain.bibDelempreferencesClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
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
     qr.Transaction:=ibtranEmpReferences;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbEmpReferences+
           ' where empreferences_id='+
           inttostr(qrEmpReferences.fieldbyName('empreferences_id').AsInteger);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveEmpReferences(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.isEmpty then exit;
  if qrEmpReferences.isEmpty then exit;
  but:=DeleteWarningEx('текущую справку ?');

  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBEmpMain.miAllClick(Sender: TObject);
begin
  _ViewOption(hOptionEmp);
end;

procedure TfmRBEmpMain.BitBtn1Click(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Visual.MultiSelect:=true;
  TPRBI.Condition.WhereStr:=PChar(' emp_id='+inttostr(Mainqr.fieldbyName('emp_id').AsInteger)+' ');
  TPRBI.Locate.KeyFields:='emp_id';
  TPRBI.Locate.KeyValues:=inttostr(Mainqr.fieldbyName('emp_id').AsInteger);
  TPRBI.Locate.Options:=[loCaseInsensitive];

  if _ViewInterfaceFromName(NameRbkEmpConnect,@TPRBI) then begin
    ShowMessage(GetFirstValueFromParamRBookInterface(@TPRBI,'connectiontypename'));
  end;
end;

procedure TfmRBEmpMain.FillGridPopupMenu;

  procedure CreateFromMenuItem(MenuItem,MiParent: TMenuItem);
  var
    i: Integer;
    mi: TMenuItem;
  begin
    for i:=0 to MiParent.Count-1 do begin
      mi:=TMenuItem.Create(nil);
      mi.Caption:=MiParent.Items[i].Caption;
      mi.Hint:=MiParent.Items[i].Hint;
      mi.OnClick:=MiParent.Items[i].OnClick;
      mi.Visible:=MiParent.Items[i].Visible;
      mi.Enabled:=MiParent.Items[i].Enabled;
      MenuItem.Add(mi);
    end;
  end;

  procedure CreateMenuItem(bt: TButton);
  var
    mi: TMenuItem;
  begin
    mi:=TMenuItem.Create(nil);
    if bt<>nil then begin
     mi.Caption:=bt.Caption;
     mi.Hint:=bt.Hint;
     mi.OnClick:=bt.OnClick;
     mi.Visible:=bt.Visible and bt.Showing;
     mi.Enabled:=bt.Enabled;
    end else begin
     mi.Caption:='-';
    end;
    if bt=bibAdjust then begin
      CreateFromMenuItem(mi,pmAdjust.Items);
    end;
    pmGrid.Items.Add(mi);
  end;
  
  procedure FillFromControl(wt: TWinControl);
  var
    ct: TControl;
    i: Integer;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if ct is TWinControl then
        FillFromControl(TWinControl(ct));
      if ct is TButton then
        CreateMenuItem(TButton(ct));
    end;
  end;

begin
  pmGrid.Items.Clear;
  FillFromControl(pnSQL);
  CreateMenuItem(nil);
  FillFromControl(pnModal);
end;

procedure TfmRBEmpMain.VisibleAllTabSheets(Vis: Boolean);
var
   i: Integer;
   ts: TTabSheet;
begin
   for i:=0 to pgLink.PageCount-1 do begin
     ts:=pgLink.Pages[i];
     ts.TabVisible:=Vis;
   end;
end;

procedure TfmRBEmpMain.SetParamsFromOptions;
begin
   if fmOptions=nil then exit;
   pgLink.MultiLine:=fmOptions.chbRBEmpAllTabs.Checked;
end;

{ TfmRBEmp }

destructor TfmRBEmp.Destroy;
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRbEmp:=nil;
end;

procedure TfmRBEmp.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
begin
  pnLink.Visible:=false;
  inherited;
end;


{ TfmRBEmpConnect }

constructor TfmRBEmpConnect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:=Format(fmtEmpConnect,[NameRbkEmp,NameRbkEmpConnect]);
end;

destructor TfmRBEmpConnect.Destroy;
begin
  SetInterfaceHandle(CurInterface);
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBEmpConnect:=nil;
end;

procedure TfmRBEmpConnect.InitMdiChildParams(hInterface: THandle; Param: PParamRBookInterface);
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

procedure TfmRBEmpConnect.InitModalParams(hInterface: THandle; Param: PParamRBookInterface);
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

procedure TfmRBEmpConnect.ReturnModalParams(Param: PParamRBookInterface);
begin
  ReturnModalParamsFromDataSetAndGrid(qrEmpConnect,GridEmpConnect,Param);
end;

function TfmRBEmpConnect.CheckPermission: Boolean;
begin
  Result:=inherited CheckPermission;
end;


end.
