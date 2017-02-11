
{******************************************}
{                                          }
{             FastReport v2.4              }
{            Registration unit             }
{                                          }
{ Copyright (c) 1998-2001 by Tzyganenko A. }
{                                          }
{******************************************}


unit FR_reg;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms
{$IFNDEF Delphi6}
, DsgnIntf;
{$ELSE}
, DesignIntf, DesignEditors;
{$ENDIF}

type
  TfrRepEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
    procedure DoDesign;
  end;

  TfrPrintTblEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
    procedure DoShow;
  end;

procedure Register;

implementation

uses Dialogs, FR_Class, FR_DSet, FR_DBSet,
  FR_OLE, FR_Rich, FR_ChBox, FR_Shape, FR_BarC, FR_RRect,
  FR_Desgn, FR_View, FR_Dock, FR_Ctrls, FR_Combo, FR_Utils, FR_Cross
{$IFDEF DATAMANAGER}
, FRD_Mngr, FR_DBOp
{$ENDIF}
, FR_E_TXT, FR_E_RTF, FR_E_CSV, FR_E_HTM, FR_Const, FR_PTabl, FR_DCtrl
  {$IFDEF TeeChart}, FR_Chart {$ENDIF}
  {$IFDEF RX}, FR_RxRTF {$ENDIF};

{-----------------------------------------------------------------------}

procedure TfrRepEditor.ExecuteVerb(Index: Integer);
begin
  DoDesign;
end;

function TfrRepEditor.GetVerb(Index: Integer): String;
begin
  Result := frLoadStr(SDesignReport);
end;

function TfrRepEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TfrRepEditor.DoDesign;
begin
  TfrReport(Component).DesignReport;
  if TfrReport(Component).StoreInDFM then
    if TfrReport(Component).ComponentModified then
      Designer.Modified;
end;

{----------------------------------------------------------------------------}
procedure TfrPrintTblEditor.ExecuteVerb(Index: Integer);
begin
  DoShow;
end;

function TfrPrintTblEditor.GetVerb(Index: Integer): String;
begin
  Result := frLoadStr(SPreview);
end;

function TfrPrintTblEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TfrPrintTblEditor.DoShow;
begin
  TfrCustomPrintDataSet(Component).ShowReport;
end;

{-----------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('FastReport',
    [TfrReport, TfrCompositeReport, TfrDBDataSet, TfrUserDataset,
     TfrOLEObject, TfrRichObject, TfrCheckBoxObject,
     TfrShapeObject, TfrBarCodeObject,
     {$IFDEF TeeChart} TfrChartObject, {$ENDIF}
     {$IFDEF RX} TfrRxRichObject, {$ENDIF}
     TfrRoundRectObject, TfrCrossObject,
     TfrTextExport, TfrRTFExport, TfrCSVExport, TfrHTMExport,
     TfrDesigner,
{$IFDEF DATAMANAGER}
     TfrDataStorage,
{$ENDIF}
     TfrPreview, TfrPrintTable,
{$IFNDEF IBO}
     TfrPrintGrid,
{$ENDIF}
     TfrDialogControls]);
  RegisterComponents('FR Tools',
    [TfrSpeedButton, TfrDock, TfrToolBar,
     TfrTBButton, TfrTBSeparator, TfrTBPanel,
     TfrComboEdit, TfrComboBox, TfrFontComboBox
{$IFDEF DATAMANAGER}
     , TfrOpenDBDialog
{$ENDIF}
    ]);
  RegisterComponentEditor(TfrReport, TfrRepEditor);
  RegisterComponentEditor(TfrPrintTable, TfrPrintTblEditor);
{$IFNDEF IBO}
  RegisterComponentEditor(TfrPrintGrid, TfrPrintTblEditor);
{$ENDIF}
end;

end.
