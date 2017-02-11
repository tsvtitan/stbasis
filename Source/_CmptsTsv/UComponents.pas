unit UComponents;

interface

uses Classes,
     Controls,
     stdctrls,
     extctrls,
     menus,
     ActnList,
     buttons,
     mask,
     grids,
     checklst,
     Appevnts,
     forms,
     UMainUnited,
     comctrls,
     mplayer,
     olectnrs,
     TeeProcs,
     TeEngine,
     Chart,
     DBChart,
     db,
     dbgrids,
     dbctrls,
     dbclient,
     IBTable,
     IBQuery,
     IBStoredProc,
     IBDatabase,
     IBUpdateSQL,
     IBCustomDataSet,
     IBSQL,
     IBDatabaseInfo,
     IBSQLMonitor,
     IBEvents,
     dialogs,
     extdlgs,
     tsvColorBox,
     tsvDbGrid,
     tsvListBox,
     tsvStorage,
     tsvAngleLabel,
     tsvGradient,
     tsvMemDS,
     tsvHintEx,
     FR_Class,
     FR_View,
     FR_DBSet,
     FR_DSet,
     FR_E_TXT,
     FR_E_RTF,
     FR_E_CSV,
     FR_E_HTM,
     FR_PTabl,

     VirtualTrees,
     VirtualDBTree,

     ToolEdit,
     CurrEdit,
     RxCombos,
     RXCtrls,
     RxRichEd,
     RXClock,
     Animate,
     RXGrids,
     GIFCtrl,
     RxCalc,
     TimerLst,
     RxNotify,
     RXDBCtrl,
     RxLookup,
     DBRichEd,
     RxMemDS,
     RxDBComb,

     tsvHtmlControls,
     tsvVirtualDbTree,
     tsvComCtrls,
     tsvStdctrls,
     tsvXMLDoc,
     tsvHttpSend,
     tsvStrings,

     IdHttp,

     AbZipper;

type

   // Standart

   TiMainMenu=class(TMainMenu, IAdditionalComponent)
   end;

   TiPopupMenu=class(TPopupMenu, IAdditionalComponent)
   end;

   TiMenuItem=class(TMenuItem, IAdditionalComponent)
   end;

   TiLabel=class(TLabel, IAdditionalControl)
   end;

   TiEdit=class(TNewEdit, IAdditionalControl)
   end;

   TiMemo=class(TNewMemo, IAdditionalControl)
   end;

   TiButton=class(TButton, IAdditionalControl)
   end;

   TiCheckBox=class(TCheckBox, IAdditionalControl)
   end;

   TiRadioButton=class(TRadioButton, IAdditionalControl)
   end;

   TiListBox=class(TNewListBox, IAdditionalControl)
   end;

   TiComboBox=class(TNewComboBox, IAdditionalControl)
   published
     property ItemIndex;
   end;

   TiScrollBar=class(TScrollBar, IAdditionalControl)
   end;

   TiGroupBox=class(TGroupBox, IAdditionalControl)
   end;

   TiRadioGroup=class(TRadioGroup, IAdditionalControl)
   end;

   TiPanel=class(TPanel, IAdditionalControl)
   end;

   TiActionList=class(TActionList, IAdditionalComponent)
   end;

   TiBitBtn=class(TBitBtn, IAdditionalControl)
   end;

   TiSpeedButton=class(TSpeedButton, IAdditionalControl)
   end;

   TiMaskEdit=class(TMaskEdit, IAdditionalControl)
   end;

   TiStringGrid=class(TStringGrid, IAdditionalControl)
   end;

   TiDrawGrid=class(TDrawGrid, IAdditionalControl)
   end;

   TiImage=class(TImage, IAdditionalControl)
   end;

   TiShape=class(TShape, IAdditionalControl)
   end;

   TiBevel=class(TBevel, IAdditionalControl)
   end;

   TiScrollBox=class(TScrollBox, IAdditionalControl)
   end;

   TiCheckListBox=class(TCheckListBox, IAdditionalControl)
   end;

   TiSplitter=class(TSplitter, IAdditionalControl)
   end;

   TiStaticText=class(TStaticText, IAdditionalControl)
   end;

   TiControlBar=class(TControlBar, IAdditionalControl)
   end;

   TiApplicationEvents=class(TApplicationEvents, IAdditionalComponent)
   end;

   TiChart=class(TChart, IAdditionalComponent)
   end;
   
   TiTabControl=class(TTabControl, IAdditionalControl)
   end;

   TiPageControl=class(TPageControl, IAdditionalControl)
   end;

   TiTabSheet=class(TTabSheet, IAdditionalControl)
   end;

   TiImageList=class(TImageList, IAdditionalComponent)
   end;

   TiRichEdit=class(TNewRichEdit, IAdditionalControl)
   end;

   TiTrackBar=class(TTrackBar, IAdditionalControl)
   end;

   TiProgressBar=class(TProgressBar, IAdditionalControl)
   end;

   TiUpDown=class(TUpDown, IAdditionalControl)
   end;

   TiHotKey=class(THotKey, IAdditionalControl)
   end;

   TiAnimate=class(TAnimate, IAdditionalControl)
   end;

   TiDateTimePicker=class(TNewDateTimePicker, IAdditionalControl)
   end;

   TiMonthCalendar=class(TMonthCalendar, IAdditionalControl)
   end;

   TiTreeView=class(TTreeView, IAdditionalControl)
   end;

   TiListView=class(TListView, IAdditionalControl)
   end;

   TiStatusBar=class(TStatusBar, IAdditionalControl)
   end;

   TiToolBar=class(TToolBar, IAdditionalControl)
   end;

   TiToolButton=class(TToolButton, IAdditionalControl)
   end;


   TiCoolBar=class(TCoolBar, IAdditionalControl)
   end;

   TiPageScroller=class(TPageScroller, IAdditionalControl)
   end;

   TiTimer=class(TTimer, IAdditionalComponent)
   end;

   TiPaintBox=class(TPaintBox, IAdditionalControl)
   end;

   TiMediaPlayer=class(TMediaPlayer, IAdditionalControl)
   end;

   TiOleContainer=class(TOleContainer, IAdditionalControl)
   end;

   TiOpenDialog=class(TOpenDialog, IAdditionalComponent)
   end;

   TiSaveDialog=class(TSaveDialog, IAdditionalComponent)
   end;

   TiOpenPictureDialog=class(TOpenPictureDialog, IAdditionalComponent)
   end;

   TiSavePictureDialog=class(TSavePictureDialog, IAdditionalComponent)
   end;

   TiFontDialog=class(TFontDialog, IAdditionalComponent)
   end;

   TiColorDialog=class(TColorDialog, IAdditionalComponent)
   end;

   TiPrintDialog=class(TPrintDialog, IAdditionalComponent)
   end;

   TiPrinterSetupDialog=class(TPrinterSetupDialog, IAdditionalComponent)
   end;

   TiFindDialog=class(TFindDialog, IAdditionalComponent)
   end;

   TiReplaceDialog=class(TReplaceDialog, IAdditionalComponent)
   end;

   TiDataSource=class(TDataSource, IAdditionalComponent)
   end;

   TiClientDataSet=class(TClientDataSet, IAdditionalComponent)
   end;

   TiDBGrid=class(TDBGrid, IAdditionalControl)
   end;

   TiDBNavigator=class(TDBNavigator, IAdditionalControl)
   end;

   TiDBText=class(TDBText, IAdditionalControl)
   end;

   TiDBEdit=class(TDBEdit, IAdditionalControl)
   end;

   TiDBMemo=class(TDBMemo, IAdditionalControl)
   end;

   TiDBImage=class(TDBImage, IAdditionalControl)
   end;

   TiDBListBox=class(TDBListBox, IAdditionalControl)
   end;

   TiDBComboBox=class(TDBComboBox, IAdditionalControl)
   end;

   TiDBCheckBox=class(TDBCheckBox, IAdditionalControl)
   end;

   TiDBRadioGroup=class(TDBRadioGroup, IAdditionalControl)
   end;

   TiDBRichEdit=class(TDBRichEdit, IAdditionalControl)
   end;

   TiDBChart=class(TDBChart, IAdditionalControl)
   end;

   TiVirtualDBTree=class(TtsvVirtualDbTree, IAdditionalControl)
   end;
   
   // Interbase

   TiIBTable=class(TIBTable, IAdditionalComponent)
   end;

   TiIBQuery=class(TIBQuery, IAdditionalComponent)
   end;

   TiIBStoredProc=class(TIBStoredProc, IAdditionalComponent)
   end;

   TiIBDatabase=class(TIBDatabase, IAdditionalComponent)
   end;

   TiIBTransaction=class(TIBTransaction, IAdditionalComponent)
   end;

   TiIBUpdateSql=class(TIBUpdateSql, IAdditionalComponent)
   end;

   TiIBDataSet=class(TIBDataSet, IAdditionalComponent)
   end;

   TiIBSQL=class(TIBSQL, IAdditionalComponent)
   end;

   TiIBDataBaseInfo=class(TIBDataBaseInfo, IAdditionalComponent)
   end;

   TiIBSqlMonitor=class(TIBSqlMonitor, IAdditionalComponent)
   end;

   TiIBEvents=class(TIBEvents, IAdditionalComponent)
   end;


   // Tsv
   
   TitsvColorBox=class(TtsvColorBox, IAdditionalControl)
   end;

   TitsvDBGrid=class(TNewDBGrid, IAdditionalControl)
   end;

   TitsvListBox=class(TtsvListBox, IAdditionalControl)
   end;

   TitsvStorage=class(TtsvStorage, IAdditionalComponent)
   end;

   TitsvAngelLabel=class(TtsvAngleLabel, IAdditionalControl)
   end;

   TitsvGradient=class(TtsvGradient, IAdditionalControl)
   end;

   TitsvMemoryData=class(TtsvMemoryData, IAdditionalComponent)
   end;

   TitsvHintEx=class(TtsvHintEx, IAdditionalComponent)
   end;

   TitsvXMLDocument=class(TtsvXMLDocument,IAdditionalComponent)
   end;

   TitsvHttpSend=class(TtsvHttpSend,IAdditionalComponent)
   end;

   TitsvStringList=class(TtsvStringList,IAdditionalComponent)
   end;

   // FastReport

   TifrReport=class(TfrReport, IAdditionalComponent)
   private
    procedure SetMDIPreview(Value: Boolean);
    function GetMDIPreview: Boolean;
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
   published
     property MDIPreview: Boolean read GetMDIPreview write SetMDIPreview default False;
     
   end;

   TifrCompositeReport=class(TfrCompositeReport, IAdditionalComponent)
   end;

   TifrDBDataset=class(TfrDBDataset, IAdditionalComponent)
   end;

   TifrUserDataset=class(TfrUserDataset, IAdditionalComponent)
   end;

   TifrTextExport=class(TfrTextExport, IAdditionalComponent)
   end;

   TifrRtfExport=class(TfrRtfExport, IAdditionalComponent)
   end;

   TifrCSVExport=class(TfrCSVExport, IAdditionalComponent)
   end;

   TifrHTMExport=class(TfrHTMExport, IAdditionalComponent)
   end;

   TifrPreview=class(TfrPreview, IAdditionalComponent)
   end;

   TifrPrintTable=class(TfrPrintTable, IAdditionalComponent)
   end;

   TifrPrintGrid=class(TfrPrintGrid, IAdditionalComponent)
   end;
   
   // Rx

   TiComboEdit=class(TComboEdit,IAdditionalControl)
   end;

   TiFileNameEdit=class(TFileNameEdit,IAdditionalControl)
   end;

   TiDirectoryEdit=class(TDirectoryEdit,IAdditionalControl)
   end;

   TiDateEdit=class(TDateEdit,IAdditionalControl)
   end;

   TiRxCalcEdit=class(TRxCalcEdit,IAdditionalControl)
   end;

   TiCurrencyEdit=class(TCurrencyEdit,IAdditionalControl)
   end;

   TiFontComboBox=class(TFontComboBox,IAdditionalControl)
   end;

   TiColorComboBox=class(TColorComboBox,IAdditionalControl)
   end;

   TiRxLabel=class(TRxLabel,IAdditionalControl)
   end;

   TiRxRichEdit=class(TRxRichEdit,IAdditionalControl)
   end;

   TiRxClock=class(TRxClock,IAdditionalControl)
   end;

   TiAnimatedImage=class(TAnimatedImage,IAdditionalControl)
   end;

   TiRxDrawGrid=class(TRxDrawGrid,IAdditionalControl)
   end;

   TiRxSpeedButton=class(TRxSpeedButton,IAdditionalControl)
   end;

   TiRxGifAnimator=class(TRxGifAnimator,IAdditionalControl)
   end;

   TiRxCalculator=class(TRxCalculator,IAdditionalControl)
   end;

   TiRxTimerList=class(TRxTimerList,IAdditionalControl)
   end;

   TiRxFolderMonitor=class(TRxFolderMonitor,IAdditionalControl)
   end;

   TiRxMemoryData=class(TRxMemoryData,IAdditionalControl)
   end;

   TiRxDBGrid=class(TRxDBGrid,IAdditionalControl)
   end;

   TiRxDBLookupList=class(TRxDBLookupList,IAdditionalControl)
   end;

   TiRxDBLookupCombo=class(TRxDBLookupCombo,IAdditionalControl)
   end;

   TiRxLookupEdit=class(TRxLookupEdit,IAdditionalControl)
   end;

   TiDBDateEdit=class(TDBDateEdit,IAdditionalControl)
   end;

   TiRxDBCalcEdit=class(TRxDBCalcEdit,IAdditionalControl)
   end;

   TiRxDBComboEdit=class(TRxDBComboEdit,IAdditionalControl)
   end;

   TiRxDBRichEdit=class(TRxDBRichEdit,IAdditionalControl)
   end;

   TiDBStatusLabel=class(TDBStatusLabel,IAdditionalControl)
   end;

   TiRxDbComboBox=class(TRxDbComboBox,IAdditionalControl)
   end;

   // tsvHtmlControls

   TitsvHtmlPage=class(TtsvHtmlPage,IAdditionalControl)
   end;

   TitsvHtmlFrame=class(TtsvHtmlFrame,IAdditionalControl)
   end;

   TitsvHtmlLabel=class(TtsvHtmlLabel,IAdditionalControl)
   end;

   TiIdHttp=class(TIdHttp,IAdditionalControl)
   end;

   // ABBREVIA

   TiAbZipper=class(TAbZipper,IAdditionalComponent)
   end;

implementation

{ TifrReport }

constructor TifrReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited MDIPreview:=false;
  StoreInDFM:=true;
end;

destructor TifrReport.Destroy;
begin
  Terminated:=true;
  Application.ProcessMessages;
  inherited Destroy;
end;

procedure TifrReport.SetMDIPreview(Value: Boolean);
begin
  if Value<>GetMDIPreview then begin
    if Value then ModalPreview:=false
    else ModalPreview:=true;
    Inherited MDIPreview:=Value;
  end;
end;

function TifrReport.GetMDIPreview: Boolean;
begin
  Result:= inherited MDIPreview;
end;


end.
