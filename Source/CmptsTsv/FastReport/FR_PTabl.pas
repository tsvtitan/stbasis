
{******************************************}
{                                          }
{               FastReport v2.4            }
{            Print table component         }
{                                          }
{ Copyright (c) 1998-2001 by Tzyganenko A. }
{                                          }
{******************************************}

unit FR_PTabl;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBGrids, Printers, FR_DSet, FR_DBSet
{$IFDEF IBO}
, IB_Components
{$ENDIF}
, FR_Class, FR_View;

type
  TfrPrintColumnEvent = procedure(ColumnNo: Integer; var Width: Integer) of object;

  TfrDataSection = (frOther, frHeader, frData, frFooter);

{$IFDEF IBO}
  TfrPrintDataEvent = procedure(Field: TIB_Column; Memo: TStringList; View: TfrView; Section: TfrDataSection) of object;
{$ELSE}
  TfrPrintDataEvent = procedure(Field: TField; Memo: TStringList; View: TfrView; Section: TfrDataSection) of object;
{$ENDIF}

  TfrPrintOption = (frpoHeader, frpoHeaderOnEveryPage, frpoFooter);
  TfrPrintOptions = set of TfrPrintOption;

  TfrFrameLine = (frLeft, frTop, frRight, frBottom);
  TfrFrameLines = set of TfrFrameLine;

  TfrWidthsArray = Array[0..255] of Word;
  TfrCustomWidthsEvent = procedure(var Widths: TfrWidthsArray; DataColumns, PageActiveWidth: integer) of object;

  TfrPageMargins = class(TPersistent)
  private
    FLeft: Integer;
    FTop: Integer;
    FRight: Integer;
    FBottom: Integer;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
  published
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Right: Integer read FRight write FRight;
    property Bottom: Integer read FBottom write FBottom;
  end;

  TfrSectionParams = class(TPersistent)
  private
    FFont: TFont;
    FColor: TColor;
    FFrame: TfrFrameLines;
    FFrameWidth: Single;
    procedure SetFont(Value: TFont);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function GetFrameTyp: Integer;
  published
    property Font: TFont read FFont write SetFont;
    property Color: TColor read FColor write FColor;
    property Frame: TfrFrameLines read FFrame write FFrame;
    property FrameWidth: Single read FFrameWidth write FFrameWidth;
  end;

  TfrAdvSectionParams = class(TfrSectionParams)
  private
    FAlign: TAlignment;
    FText: String;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    function GetAlign: Integer;
  published
    property Align: TAlignment read FAlign write FAlign default taCenter;
    property Text: String read FText write FText;
  end;

  TfrCustomPrintDataSet = class(TComponent)
  private
    FWidths: TfrWidthsArray;
    FCustomizeWidths: TfrCustomWidthsEvent;
    FpgSize: Integer;
    FpgWidth: Integer;
    FpgHeight: Integer;
    FPageMargins: TfrPageMargins;
    FOrientation: TPrinterOrientation;
    FTitle, FPageHeader, FPageFooter, FSummary: TfrAdvSectionParams;
    FHeader, FBody: TfrSectionParams;
    FWidth: Integer;
    FReport: TfrReport;
    FPreview: TfrPreview;
    FReportDataSet: TfrDBDataSet;
    FColumnDataSet: TfrUserDataSet;
    FOnPrintColumn: TfrPrintColumnEvent;
    FOnPrintData: TfrPrintDataEvent;
    FFooter: TfrSectionParams;
    FPrintOptions: TfrPrintOptions;
    procedure OnEnterRect(Memo: TStringList; View: TfrView); virtual;
    procedure OnPrintColumn_(ColNo: Integer; var Width: Integer); virtual;
    function GetFieldCount: Integer; virtual;
    function RealColumnIndex(Index: Integer): Integer;
    procedure SetPageMargins(Value: TfrPageMargins);
    procedure SetTitle(Value: TfrAdvSectionParams);
    procedure SetPageHeader(Value: TfrAdvSectionParams);
    procedure SetPageFooter(Value: TfrAdvSectionParams);
    procedure SetHeader(Value: TfrSectionParams);
    procedure SetBody(Value: TfrSectionParams);
    procedure SetFooter(const Value: TfrSectionParams);
    function GetColWidths(Index: Integer): word;
    procedure SetColWidths(Index: Integer; const Value: word);
    function GetColCount: integer;
    procedure SetSummary(const Value: TfrAdvSectionParams);
  protected
    { Protected declarations }
  {$IFDEF IBO}
    FDataSet: TIB_Dataset;
  {$ELSE}
    FDataSet: TDataset;
  {$ENDIF}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateDS; virtual;
    property ColWidths[Index: Integer]: word read GetColWidths write SetColWidths;
    property ColCount: integer read GetColCount;

    procedure BuildReport;
    procedure ShowReport;

    property PageSize: Integer read FpgSize write FpgSize;
    property PageWidth: Integer read FpgWidth write FpgWidth;
    property PageHeight: Integer read FpgHeight write FpgHeight;
    property PageMargins: TfrPageMargins read FPageMargins write SetPageMargins;
    property Orientation: TPrinterOrientation read FOrientation write FOrientation default poPortrait;
    property Title: TfrAdvSectionParams read FTitle write SetTitle;
    property PageHeader: TfrAdvSectionParams read FPageHeader write SetPageHeader;
    property PageFooter: TfrAdvSectionParams read FPageFooter write SetPageFooter;
    property Header: TfrSectionParams read FHeader write SetHeader;
    property Footer: TfrSectionParams read FFooter write SetFooter;
    property Summary: TfrAdvSectionParams read FSummary write SetSummary;
    property Body: TfrSectionParams read FBody write SetBody;
    property Preview: TfrPreview read FPreview write FPreview;
    property Report: TfrReport read FReport;
    property OnPrintColumn: TfrPrintColumnEvent read FOnPrintColumn write FOnPrintColumn;
    property OnPrintData: TfrPrintDataEvent read FOnPrintData write FOnPrintData;
    property PrintOptions: TfrPrintOptions read FPrintOptions write FPrintOptions;
    property OnCustomizeWidths: TfrCustomWidthsEvent read FCustomizeWidths write FCustomizeWidths;
  end;

  TfrPrintTable = class(TfrCustomPrintDataSet)
  private
    FAutoWidth: Boolean;
    procedure OnEnterRect(Memo: TStringList; View: TfrView); override;
    procedure OnPrintColumn_(ColNo: Integer; var Width: Integer); override;
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateDS; override;
  published
    property AutoWidth: Boolean read FAutoWidth write FAutoWidth default True;
  {$IFDEF IBO}
    property DataSet: TIB_DataSet read FDataSet write FDataSet;
  {$ELSE}
    property DataSet: TDataSet read FDataSet write FDataSet;
  {$ENDIF}
    property PageSize;
    property PageWidth;
    property PageHeight;
    property PageMargins;
    property Orientation;
    property Title;
    property PageHeader;
    property PageFooter;
    property Header;
    property Footer;
    property Summary;
    property Body;
    property PrintOptions;
    property OnPrintColumn;
    property OnPrintData;
    property OnCustomizeWidths;
  end;

{$IFNDEF IBO}
  TfrPrintGrid = class(TfrCustomPrintDataSet)
  private
    FDBGrid: TDBGrid;
    function RealGridIndex(Index: Integer): Integer;
    procedure OnEnterRect(Memo: TStringList; View: TfrView); override;
    procedure OnPrintColumn_(ColNo: Integer; var Width: Integer); override;
    function GetFieldCount: Integer; override;
  protected
    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure CreateDS; override;
  published
    property DBGrid: TDBGrid read FDBGrid write FDBGrid;
    property PageSize;
    property PageWidth;
    property PageHeight;
    property PageMargins;
    property Orientation;
    property Title;
    property PageHeader;
    property PageFooter;
    property Header;
    property Body;
    property OnPrintColumn;
 end;
{$ENDIF}


implementation

{$IFDEF Delphi2}
uses DBTables;
{$ENDIF}

{ TfrSectionParams }

constructor TfrSectionParams.Create;
begin
  inherited Create;
  FFont := TFont.Create;
  FFont.Name := 'Arial';
{$IFNDEF Delphi2}
  FFont.Charset := frCharset;
{$ENDIF}
  FFont.Size := 10;
  FColor := clWhite;
  FFrame := [frLeft, frTop, frRight, frBottom];
  FFrameWidth := 1;
end;

destructor TfrSectionParams.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TfrSectionParams.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  FFont.Assign(TfrSectionParams(Source).Font);
  FColor := TfrSectionParams(Source).Color;
  FFrame := TfrSectionParams(Source).Frame;
end;

procedure TfrSectionParams.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TfrSectionParams.GetFrameTyp: Integer;
begin
  Result := 0;
  if frLeft in FFrame then
    Result := frftLeft;
  if frRight in FFrame then
    Result := Result + frftRight;
  if frTop in FFrame then
    Result := Result + frftTop;
  if frBottom in FFrame then
    Result := Result + frftBottom;
end;


{ TfrAdvSectionParams }

constructor TfrAdvSectionParams.Create;
begin
  inherited Create;
  FAlign := taCenter;
  FFrame := [];
end;

procedure TfrAdvSectionParams.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  FAlign := TfrAdvSectionParams(Source).Align;
  FText := TfrAdvSectionParams(Source).Text;
end;

function TfrAdvSectionParams.GetAlign: Integer;
begin
  Result := 0;
  if FAlign = taLeftJustify then
    Result := frtaLeft
  else if FAlign = taRightJustify then
    Result := frtaRight
  else if FAlign = taCenter then
    Result := frtaCenter
end;


{ TfrPageMargins }

constructor TfrPageMargins.Create;
begin
  inherited Create;
  FLeft   := 0;
  FTop    := 0;
  FRight  := 0;
  FBottom := 0;
end;

procedure TfrPageMargins.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  FLeft   := TfrPageMargins(Source).Left;
  FTop    := TfrPageMargins(Source).Top;
  FRight  := TfrPageMargins(Source).Right;
  FBottom := TfrPageMargins(Source).Bottom;
end;


{ TfrCustomPrintDataSet }

constructor TfrCustomPrintDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPageMargins := TfrPageMargins.Create;
  FpgSize := 9;
  FTitle := TfrAdvSectionParams.Create;
  FTitle.Font.Style := [fsBold];
  FTitle.Font.Size := 12;

  FPageHeader := TfrAdvSectionParams.Create;

  FPageFooter := TfrAdvSectionParams.Create;

  FSummary := TfrAdvSectionParams.Create;
  FSummary.Font.Style := [fsItalic];
  FSummary.Font.Size := 12;

  FHeader := TfrSectionParams.Create;
  FHeader.Font.Style := [fsBold];
  FHeader.Font.Color := clWhite;
  FHeader.Color := clNavy;

  FFooter := TfrSectionParams.Create;
  FFooter.Font.Style := [fsItalic];
  FFooter.Color := clSilver;


  FBody := TfrSectionParams.Create;
  FReport := TfrReport.Create(Self);
  FReport.PreviewButtons := [pbZoom, pbSave, pbPrint, pbFind, pbHelp, pbExit, pbPageSetup];

  FReportDataSet := TfrDBDataSet.Create(Self);
  FReportDataSet.Name := 'frGridDBDataSet1';

  FColumnDataSet := TfrUserDataSet.Create(Self);
  FColumnDataSet.Name := 'frGridUserDataSet1';
  FColumnDataSet.RangeEnd := reCount;

  FPrintOptions:=[frpoHeader, frpoHeaderOnEveryPage];
end;

destructor TfrCustomPrintDataSet.Destroy;
begin
  FReportDataSet.Free;
  FColumnDataSet.Free;
  FReport.Free;
  FTitle.Free;
  FPageHeader.Free;
  FPageFooter.Free;
  FSummary.Free;
  FHeader.Free;
  FFooter.Free;
  FBody.Free;
  FPageMargins.Free;
  inherited Destroy;
end;

procedure TfrCustomPrintDataSet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FPreview) then
    FPreview := nil;
end;

function TfrCustomPrintDataSet.RealColumnIndex(Index: Integer): Integer;
var
  Y, I: Integer;
begin
  Result := 0;
  Y := -1;
  for I := 0 to FDataSet.FieldCount - 1 do
    if FDataSet.Fields[I].Visible then
    begin
      Inc(Y);
      if Y = Index then
      begin
        Result := I;
        break;
      end;
    end;
end;

procedure TfrCustomPrintDataSet.SetPageMargins(Value: TfrPageMargins);
begin
  FPageMargins.Assign(Value);
end;

procedure TfrCustomPrintDataSet.SetTitle(Value: TfrAdvSectionParams);
begin
  FTitle.Assign(Value);
end;

procedure TfrCustomPrintDataSet.SetPageHeader(Value: TfrAdvSectionParams);
begin
  FPageHeader.Assign(Value);
end;

procedure TfrCustomPrintDataSet.SetPageFooter(Value: TfrAdvSectionParams);
begin
  FPageFooter.Assign(Value);
end;

procedure TfrCustomPrintDataSet.SetHeader(Value: TfrSectionParams);
begin
  FHeader.Assign(Value);
end;

procedure TfrCustomPrintDataSet.SetBody(Value: TfrSectionParams);
begin
  FBody.Assign(Value);
end;

procedure TfrCustomPrintDataSet.CreateDS;
begin
end;

function TfrCustomPrintDataSet.GetFieldCount: Integer;
var
  i: Integer;
  b: Boolean;
begin
  Result := FDataSet.FieldCount;
  b := True;
  for i := 0 to FDataSet.FieldCount - 1 do
    if (FDataSet.Fields[i] <> nil) and FDataSet.Fields[i].Visible then
    begin
      if b then
      begin
        b := False;
        Result := 0;
      end;
      Inc(Result);
    end;
end;

procedure TfrCustomPrintDataSet.BuildReport;
var
  v: TfrView;
  b: TfrBandView;
  Page: TfrPage;
  LeftMargin: Integer;
begin
  CreateDS;
  if FDataSet = nil then Exit;

  FReport.OnBeforePrint := OnEnterRect;
  FReport.OnPrintColumn := OnPrintColumn_;
  FReport.Preview := FPreview;

  FReportDataSet.DataSet := FDataSet;
  FColumnDataSet.RangeEndCount := GetFieldCount;

  FReport.Clear;
  FReport.Pages.Add;
  Page := FReport.Pages[0];
  with Page do
  begin
    pgMargins.Left   := Round(FPageMargins.Left   * 18 / 5);
    pgMargins.Top    := Round(FPageMargins.Top    * 18 / 5);
    pgMargins.Right  := Round(FPageMargins.Right  * 18 / 5);
    pgMargins.Bottom := Round(FPageMargins.Bottom * 18 / 5);
    ChangePaper(Integer(FpgSize), FpgWidth * 10, FpgHeight * 10, -1, FOrientation);
  end;

  LeftMargin := Page.PrnInfo.Ofx;
  if Page.pgMargins.Left <> 0 then
    LeftMargin := Page.pgMargins.Left;

  if Assigned(FCustomizeWidths) then FCustomizeWidths(FWidths, FColumnDataSet.RangeEndCount, Page.RightMargin-Page.LeftMargin);

// Title
  if FTitle.Text <> '' then
  begin
    b := TfrBandView(frCreateObject(gtBand, ''));
    b.SetBounds(0, 20, 1000, 30);
    b.Flags := b.Flags or flStretched;
    b.BandType := btReportTitle;
    Page.Objects.Add(b);
    v := frCreateObject(gtMemo, '');
    v.SetBounds(0, 20, 20, 20);
    v.BandAlign := baWidth;
    TfrMemoView(v).Alignment:= FTitle.GetAlign + frtaMiddle;
    TfrMemoView(v).Font := FTitle.Font;
    v.FrameTyp := FTitle.GetFrameTyp;
    v.FrameWidth := FTitle.FrameWidth;
    v.FillColor := FTitle.Color;
    v.Memo.Add(FTitle.Text);
    Page.Objects.Add(v);
  end;

// Summary
  if FSummary.Text <> '' then
  begin
    b := TfrBandView(frCreateObject(gtBand, ''));
    b.SetBounds(0, 20, 1000, 30);
    b.Flags := b.Flags or flStretched;
    b.BandType := btReportSummary;
    Page.Objects.Add(b);
    v := frCreateObject(gtMemo, '');
    v.SetBounds(0, 20, 20, 20);
    v.BandAlign := baWidth;
    TfrMemoView(v).Alignment:= FSummary.GetAlign + frtaMiddle;
    TfrMemoView(v).Font := FSummary.Font;
    v.FrameTyp := FSummary.GetFrameTyp;
    v.FrameWidth := FSummary.FrameWidth;
    v.FillColor := FSummary.Color;
    v.Memo.Add(FSummary.Text);
    Page.Objects.Add(v);
  end;

// Header
  if frpoHeader in FPrintOptions then
  begin
    b := TfrBandView(frCreateObject(gtBand, ''));
    b.BandType := btMasterHeader;
    b.SetBounds(0, 60, 1000, 30);
    b.Flags := b.Flags or flStretched;
    if frpoHeaderOnEveryPage in FPrintOptions then
      b.Flags := b.Flags or flBandRepeatHeader;
    Page.Objects.Add(b);

    v := frCreateObject(gtMemo, '');
    v.SetBounds(LeftMargin, 60, 20, 30);
    TfrMemoView(v).Alignment := frtaCenter + frtaMiddle;
    TfrMemoView(v).Font := FHeader.Font;
    v.FillColor := FHeader.Color;
    v.FrameTyp := FHeader.GetFrameTyp;
    v.FrameWidth := FHeader.FrameWidth;
    v.Flags := v.Flags or flWordWrap or flStretched;
    v.Memo.Add('[Header]');
    Page.Objects.Add(v);
  end;

// Body
  b := TfrBandView(frCreateObject(gtBand, ''));
  b.BandType := btMasterData;
  b.Dataset := FReportDataSet.Name;
  b.SetBounds(0, 100, 1000, 18);
  b.Flags := b.Flags or flStretched;
  Page.Objects.Add(b);

  b := TfrBandView(frCreateObject(gtBand, ''));
  b.BandType := btCrossData;
  b.Dataset := FColumnDataSet.Name;
  b.SetBounds(LeftMargin, 0, 20, 1000);
  Page.Objects.Add(b);

  v := frCreateObject(gtMemo, '');
  v.SetBounds(LeftMargin, 100, 20, 18);
  TfrMemoView(v).Font := FBody.Font;
  v.FillColor := FBody.Color;
  v.FrameTyp := FBody.GetFrameTyp;
  v.FrameWidth := FBody.FrameWidth;
  TfrMemoView(v).GapX := 3;
  v.Flags := v.Flags or flWordWrap or flStretched;
  v.Memo.Add('[Cell]');
  Page.Objects.Add(v);


// Footer
  if frpoFooter in FPrintOptions then
  begin
    b:=TfrBandView(frCreateObject(gtBand, ''));
    b.BandType := btMasterFooter;
    b.SetBounds(0, 140, 1000, 30);
    Page.Objects.Add(b);

    v := frCreateObject(gtMemo, '');
    v.SetBounds(LeftMargin, 140, 20, 30);
    TfrMemoView(v).Alignment := frtaCenter + frtaMiddle;
    TfrMemoView(v).Font := FFooter.Font;
    v.FillColor := FFooter.Color;
    v.FrameTyp := FFooter.GetFrameTyp;
    v.FrameWidth := FFooter.FrameWidth;
    v.Flags := v.Flags or flWordWrap or flStretched;
    v.Memo.Add('[Footer]');
    Page.Objects.Add(v);
  end;

// Page header
  if FPageHeader.Text <> '' then
  begin
    b := TfrBandView(frCreateObject(gtBand, ''));
    b.BandType := btPageHeader;
    b.SetBounds(0, 160, 1000, 30);
    Page.Objects.Add(b);

    v := frCreateObject(gtMemo, '');
    v.SetBounds(0, 160, 20, 20);
    v.BandAlign := baWidth;
    TfrMemoView(v).Alignment := FPageHeader.GetAlign;
    TfrMemoView(v).Font := FPageHeader.Font;
    v.FillColor := FPageHeader.Color;
    v.FrameTyp := FPageHeader.GetFrameTyp;
    v.FrameWidth := FPageHeader.FrameWidth;
    v.Memo.Add(FPageHeader.Text);
    Page.Objects.Add(v);
  end;

// Page footer
  if FPageFooter.Text <> '' then
  begin
    b := TfrBandView(frCreateObject(gtBand, ''));
    b.BandType := btPageFooter;
    b.SetBounds(0, 260, 1000, 30);
    Page.Objects.Add(b);

    v := frCreateObject(gtMemo, '');
    v.SetBounds(0, 270, 20, 20);
    v.BandAlign := baWidth;
    TfrMemoView(v).Alignment := FPageFooter.GetAlign;
    TfrMemoView(v).Font := FPageFooter.Font;
    v.FillColor := FPageFooter.Color;
    v.FrameTyp := FPageFooter.GetFrameTyp;
    v.FrameWidth := FPageFooter.FrameWidth;
    v.Memo.Add(FPageFooter.Text);
    Page.Objects.Add(v);
  end;
end;

procedure TfrCustomPrintDataSet.ShowReport;
begin
  try
    BuildReport;
    FDataSet.DisableControls;
    FReport.ShowReport;
  finally
    FDataSet.EnableControls;
  end;
end;

procedure TfrCustomPrintDataSet.OnEnterRect(Memo: TStringList; View: TfrView);
begin
// empty method
end;

procedure TfrCustomPrintDataSet.OnPrintColumn_(ColNo: Integer; var Width: Integer);
begin
//--  Width := FWidths[ColNo]; - do not set here. It will be set in descendants
  if Assigned(FOnPrintColumn) then
    FOnPrintColumn(ColNo, Width);
  FWidth := Width;
end;


procedure TfrCustomPrintDataSet.SetFooter(const Value: TfrSectionParams);
begin
  FFooter := Value;
end;

function TfrCustomPrintDataSet.GetColWidths(Index: Integer): word;
begin
  if (Index>=0) and (Index<=High(FWidths)) then
    Result:=FWidths[Index]
  else
    Result:=0;
end;

procedure TfrCustomPrintDataSet.SetColWidths(Index: Integer;
  const Value: word);
begin
  if (Index>=0) and (Index<=High(FWidths)) then
    FWidths[Index]:=Value;
end;

function TfrCustomPrintDataSet.GetColCount: integer;
begin
  Result:=FColumnDataSet.RangeEndCount;
end;

procedure TfrCustomPrintDataSet.SetSummary(
  const Value: TfrAdvSectionParams);
begin
  FSummary := Value;
end;

{ TfrPrintTable }

constructor TfrPrintTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoWidth := True;
end;

procedure TfrPrintTable.CreateDS;
var
  i, n: Integer;
  s: String;
  b: TBitmap;
  c: TCanvas;
{$IFDEF IBO}
  f: TIB_Column;
{$ELSE}
  f: TField;
{$ENDIF}

begin
  if FDataSet = nil then Exit;
  if FAutoWidth then
  begin
    FDataSet.DisableControls;

    b := TBitmap.Create;
    c := b.Canvas;

    c.Font := FHeader.Font;
    c.Font.Height := -Round(FHeader.Font.Size * 96 / 72); //--- go to FR coords

    for i := 0 to FDataSet.FieldCount - 1 do
      FWidths[i] := c.TextWidth(FDataSet.Fields[RealColumnIndex(i)].DisplayLabel) + 8;

    c.Font := FBody.Font;
    c.Font.Height := -Round(FBody.Font.Size * 96 / 72); //--- go to FR coords

    FDataSet.First;
    while not FDataSet.EOF do
    begin
      for i := 0 to FDataSet.FieldCount - 1 do
      begin
        f := FDataSet.Fields[RealColumnIndex(i)];

        if f.InheritsFrom(TBLOBField) then
          s:=Trim(f.AsString)
        else
          s:=Trim(f.DisplayText);

        n := c.TextWidth(s) + 8;

        if n > FWidths[i] then
          FWidths[i] := n;
      end;
      FDataSet.Next;
    end;
    b.Free;

    FDataSet.EnableControls;
  end;
end;

procedure TfrPrintTable.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DataSet) then
    DataSet := nil;
end;

procedure TfrPrintTable.OnEnterRect(Memo: TStringList; View: TfrView);
var
{$IFDEF IBO}
  f: TIB_Column;
{$ELSE}
  f: TField;
{$ENDIF}
  s: TfrDataSection;

begin
  s:=frOther;

  if Memo[0] = '[Cell]' then
  begin
    f := FDataSet.Fields[RealColumnIndex(FColumnDataSet.RecNo)];
    if f.InheritsFrom(TBLOBField) then
      Memo[0] := Trim(f.AsString)
    else
      Memo[0] := Trim(f.DisplayText);

    s:=frData;

    View.dx := FWidth;
    case f.Alignment of
      taLeftJustify : TfrMemoView(View).Alignment := frtaLeft;
      taRightJustify: TfrMemoView(View).Alignment := frtaRight;
      taCenter      : TfrMemoView(View).Alignment := frtaCenter;
    end;
  end;
  if Memo[0] = '[Header]' then
  begin
    f := FDataSet.Fields[RealColumnIndex(FColumnDataSet.RecNo)];
    Memo[0] := f.DisplayLabel;
    s:=frHeader;

    View.dx := FWidth;
  end;

  if Memo[0] = '[Footer]' then
  begin
    Memo[0] := '';
    s:=frFooter;
    View.dx := FWidth;
  end;
  if Assigned(FOnPrintData) then
    FOnPrintData(FDataSet.Fields[RealColumnIndex(FColumnDataSet.RecNo)], Memo, View, s);
end;

procedure TfrPrintTable.OnPrintColumn_(ColNo: Integer; var Width: Integer);
var
  b: TBitmap;
  c: TCanvas;
  n, n1: Integer;
begin
  if FAutoWidth then
//    Width := FWidths[RealColumnIndex(ColNo - 1)]
    Width :=FWidths[ColNo-1]
  else
  begin
    b := TBitmap.Create;
    c := b.Canvas;
    c.Handle := GetDC(0);
    c.Font := FBody.Font;
    n := FDataSet.Fields[RealColumnIndex(ColNo - 1)].DisplayWidth;
    n1 := Length(FDataSet.Fields[RealColumnIndex(ColNo - 1)].DisplayLabel);
    if n1 > n then
      n := n1;
    Width := c.TextWidth('0') * n + 8;
    b.Free;
  end;
  FWidth := Width;
  inherited OnPrintColumn_(ColNo, Width);
end;


{ TfrPrintGrid }

{$IFNDEF IBO}
type
  THackDBGrid = class(TDBGrid)
  end;

procedure TfrPrintGrid.CreateDS;
begin
  if (FDBGrid = nil) or (DBGrid.DataSource = nil) or
     (DBGrid.DataSource.Dataset = nil) then Exit;
  FDataSet := DBGrid.DataSource.Dataset;
end;

procedure TfrPrintGrid.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DBGrid) then
    DBGrid := nil;
end;

function TfrPrintGrid.GetFieldCount: Integer;
var
  i: Integer;
begin
  if DBGrid.Columns.Count = 0 then
    Result := inherited GetFieldCount
  else
  begin
    Result := 0;
    for i := 0 to DBGrid.Columns.Count - 1 do
      if DBGrid.Columns[i].Width > 0 then
        Inc(Result);
  end;
end;

function TfrPrintGrid.RealGridIndex(Index: Integer): Integer;
var
  Y, I: Integer;
begin
  Result := 0;
  Y := -1;
  for I := 0 to DBGrid.Columns.Count - 1 do
    if DBGrid.Columns[i].Width > 0 then
    begin
      Inc(Y);
      if Y = Index then
      begin
        Result := I;
        break;
      end;
    end;
end;

procedure TfrPrintGrid.OnEnterRect(Memo: TStringList; View: TfrView);
var
  f: TField;
begin
  if Memo[0] = '[Cell]' then
  begin
    if DBGrid.Columns.Count = 0 then
      f := FDataSet.Fields[RealColumnIndex(FColumnDataSet.RecNo)] else
      f := DBGrid.Columns[RealGridIndex(FColumnDataSet.RecNo)].Field;
    Memo[0] := f.DisplayText;
    View.dx := FWidth;
    case f.Alignment of
      taLeftJustify : TfrMemoView(View).Alignment := frtaLeft;
      taRightJustify: TfrMemoView(View).Alignment := frtaRight;
      taCenter      : TfrMemoView(View).Alignment := frtaCenter;
    end;
  end;
  if Memo[0] = '[Header]' then
  begin
    if DBGrid.Columns.Count = 0 then
    begin
      f := FDataSet.Fields[RealColumnIndex(FColumnDataSet.RecNo)];
      Memo[0] := f.DisplayLabel;
    end
    else
      Memo[0] := DBGrid.Columns[RealGridIndex(FColumnDataSet.RecNo)].Title.Caption;
    View.dx := FWidth;
  end;
end;

procedure TfrPrintGrid.OnPrintColumn_(ColNo: Integer; var Width: Integer);
var
  d: Integer;
begin
  if dgIndicator in DBGrid.Options then
    d := 1 else
    d := 0;
  Width := THackDBGrid(DBGrid).ColWidths[RealGridIndex(ColNo - 1) + d];
  inherited OnPrintColumn_(ColNo, Width);
end;
{$ENDIF}


end.


