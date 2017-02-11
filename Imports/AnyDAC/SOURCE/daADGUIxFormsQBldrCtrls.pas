{ --------------------------------------------------------------------------- }
{ AnyDAC Schema Builder controls                                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{ Portions copyright:                                                         }
{ - Sergey Orlik, 1996-99. The source is based on Open Query Builder.         }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADGUIxFormsQBldrCtrls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Buttons, ExtCtrls, StdCtrls, Menus, CheckLst, Grids,
  daADGUIxFormsControls;

const
  WM_AD_BldrGridCellSelected = WM_USER + 1000;

type
  TADGUIxFormsQBldrControllerBase = class;
  TADGUIxFormsQBldrFields = class;
  TADGUIxFormsQBldrTable = class;
  TADGUIxFormsQBldrLink = class;
  TADGUIxFormsQBldrGrid = class;
  TADGUIxFormsQBldrArea = class;

  TADGUIxFormsQBldrControllerBase = class(TObject)
  private
    FQBTableList: TControl;
    FQBArea: TADGUIxFormsQBldrArea;
    FUseTableAliases: Boolean;
    FCurObj: TObject;
    FCurSubObj: String;
    FOnChanged: TNotifyEvent;
  protected
    procedure DoGetFields(ATable: TADGUIxFormsQBldrTable; AFields: TStrings); virtual; abstract;
    procedure DoGetTable(var ATableName: String); virtual; abstract;
    procedure DoFieldChecked(ATable: TADGUIxFormsQBldrTable; const AFieldName: String; AChecked: Boolean); virtual; abstract;
    procedure DoTableFocused(ATable: TADGUIxFormsQBldrTable); virtual; abstract;
    procedure DoFieldFocused(ATable: TADGUIxFormsQBldrTable; const AFieldName: String); virtual; abstract;
    procedure DoLinkFocused(ALink: TADGUIxFormsQBldrLink); virtual; abstract;
    procedure DoAreaFocused(AArea: TADGUIxFormsQBldrArea); virtual; abstract;
    procedure DoChanged;
  public
    function NewTable(AOwner: TComponent): TADGUIxFormsQBldrTable; virtual;
    function NewLink(AOwner: TComponent): TADGUIxFormsQBldrLink; virtual;
    function NewArea(AOwner: TComponent): TADGUIxFormsQBldrArea; virtual;
    procedure TableFocused(ATable: TADGUIxFormsQBldrTable);
    procedure FieldFocused(ATable: TADGUIxFormsQBldrTable; const AFieldName: String);
    procedure LinkFocused(ALink: TADGUIxFormsQBldrLink);
    procedure AreaFocused(AArea: TADGUIxFormsQBldrArea);
    procedure ObjectDeleted(AObj: TObject);
    property QBTableList: TControl read FQBTableList write FQBTableList;
    property QBArea: TADGUIxFormsQBldrArea read FQBArea write FQBArea;
    property UseTableAliases: Boolean read FUseTableAliases
      write FUseTableAliases default True;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged; 
  end;

  TADGUIxFormsQBldrFields = class(TCheckListBox)
  private
    FArrBold: array of Integer;
    FColor2: TColor;
    procedure WMLButtonDown(var Message: TWMLButtonDblClk); message WM_LButtonDown;
    procedure WMVScroll(var Message: TMessage); message WM_VSCroll;
    procedure WMKeyDown(var Message: TMessage); message WM_KeyDown;
    procedure AllocArrBold;
    procedure SelectItemBold(AItem: Integer);
    procedure UnSelectItemBold(AItem: Integer);
    function  GetItemY(AItem: Integer): Integer;
    function GetQBArea: TADGUIxFormsQBldrArea;
    function GetQBTable: TADGUIxFormsQBldrTable;
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure ClickCheck; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property QBArea: TADGUIxFormsQBldrArea read GetQBArea;
    property QBTable: TADGUIxFormsQBldrTable read GetQBTable;
    property Color2: TColor read FColor2 write FColor2;
  end;

  TADGUIxFormsQBldrTable = class(TADGUIxFormsPanel)
  private
    FCloseBtn,
    FMinBtn  : TSpeedButton;
    FFields  : TADGUIxFormsQBldrFields;
    FCaption : TLabel;
    FTableName : String;
    FTableAlias: String;
    FPopMenu : TPopupMenu;
    function  GetRowY(FldN: Integer): Integer;
    procedure DoCloseBtn(Sender: TObject);
    procedure DoUnlinkBtn(Sender: TObject);
    procedure DoSelectAll(Sender: TObject);
    procedure DoUnSelectAll(Sender: TObject);
    procedure DoDragOver(Sender, Source: TObject; X, Y: Integer;
                        State: TDragState; var Accept: Boolean);
    procedure DoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DoMinBtn(Sender: TObject);
    procedure UpdateLayout;
    function GetMinimized: Boolean;
    procedure SetMinimized(AValue: Boolean);
    function GetFullTableName: String;
    function GetRefTableName: String;
    function GetQBArea: TADGUIxFormsQBldrArea;
    procedure WMNCHitTest(var Message: TMessage); message WM_NCHitTest;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
  protected
    procedure DoEnter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Activate(const ATableName, ATableAlias: String;
      X, Y: Integer; IsMin: Boolean; W, H: Integer);
    property Minimized: Boolean read GetMinimized write SetMinimized;
    property TableName: String read FTableName;
    property TableAlias: String read FTableAlias;
    property FullTableName: String read GetFullTableName;
    property RefTableName: String read GetRefTableName;
    property QBArea: TADGUIxFormsQBldrArea read GetQBArea;
    property Fields: TADGUIxFormsQBldrFields read FFields;
  end;

  TADGUIxFormsQBldrLink = class(TShape)
  private
    FTbl1,
    FTbl2: TADGUIxFormsQBldrTable;
    FFldN1,
    FFldN2: Integer;
    FFldNam1,
    FFldNam2: String;
    FLinkOpt,
    FLinkType: Integer;
    FLnkX,
    FLnkY: Byte;
    FRgn : HRgn;
    FPopMenu: TPopupMenu;
    procedure DoClick(X, Y: Integer);
    procedure CMHitTest(var Message: TCMHitTest); message CM_HitTest;
    function  ControlAtPos(const Pos: TPoint): TControl;
    procedure SetFldN1(const Value: Integer);
    procedure SetFldN2(const Value: Integer);
    procedure SetFldNam1(const Value: String);
    procedure SetFldNam2(const Value: String);
    function GetQBArea: TADGUIxFormsQBldrArea;
    procedure DoOptions(Sender: TObject);
    procedure DoUnlink(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Activate(ATbl1, ATbl2: TADGUIxFormsQBldrTable; AFldN1,
      AFldN2: Integer): Boolean;
    procedure Rebound;
    property LinkOpt: Integer read FLinkOpt write FLinkOpt;
    property LinkType: Integer read FLinkType write FLinkType;
    property Tbl1: TADGUIxFormsQBldrTable read FTbl1 write FTbl1;
    property Tbl2: TADGUIxFormsQBldrTable read FTbl2 write FTbl2;
    property FldN1: Integer read FFldN1 write SetFldN1;
    property FldN2: Integer read FFldN2 write SetFldN2;
    property FldNam1: String read FFldNam1 write SetFldNam1;
    property FldNam2: String read FFldNam2 write SetFldNam2;
    property QBArea: TADGUIxFormsQBldrArea read GetQBArea;
  end;

  TADGUIxFormsQBldrGrid = class(TStringGrid)
  private
    FCurrCol: Integer;
    FIsEmpty: Boolean;
    FmnuTbl: TPopupMenu;
    FmnuFunc: TPopupMenu;
    FmnuGroup: TPopupMenu;
    FmnuSort: TPopupMenu;
    FmnuShow: TPopupMenu;
    FQBArea: TADGUIxFormsQBldrArea;
    procedure DoDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DoDragDrop(Sender, Source: TObject; X, Y: Integer);
    function  MaxSW(s1, s2:String): Integer;
    procedure mnuFunctionClick(Sender: TObject);
    procedure mnuGroupClick(Sender: TObject);
    procedure mnuRemoveClick(Sender: TObject);
    procedure mnuShowClick(Sender: TObject);
    procedure mnuSortClick(Sender: TObject);
    procedure WMBldrGridCellSelected(var AMessage: TMessage); message WM_AD_BldrGridCellSelected;
  protected
    procedure WndProc(var Message: TMessage); override;
    function  FindSameColumn(aCol: Integer): Boolean;
    procedure ClickCell(X, Y: Integer);
    function  SelectCell(ACol, ARow: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure InsertDefault(aCol: Integer);
    procedure Insert(aCol: Integer; aField, aTable: String);
    procedure RemoveColumns(const sRefTableName: String);
    procedure RemoveColumn(aCol: Integer);
    function  FindColumn(const sCol, sRefTableName: String): Integer;
    property  QBArea: TADGUIxFormsQBldrArea read FQBArea write FQBArea;
    property  IsEmpty: Boolean read FIsEmpty;
  end;

  TADGUIxFormsQBldrArea = class(TScrollBox)
  private
    FQBController: TADGUIxFormsQBldrControllerBase;
    FLoading: Boolean;
    procedure DoDragOver(Sender, Source: TObject; X, Y: Integer;
                         State: TDragState; var Accept: Boolean);
    procedure DoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure RemoveTable(ATable: TADGUIxFormsQBldrTable);
    procedure RemoveLink(ALink: TADGUIxFormsQBldrLink);
    procedure SetQBController(const Value: TADGUIxFormsQBldrControllerBase);
    function  FindOtherLink(const ALink: TADGUIxFormsQBldrLink;
      const ATbl: TADGUIxFormsQBldrTable; const AFldN: Integer): Boolean;
  protected
    procedure Click; override;
    function  CreateAlias(const ATableName: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    function  InsertTable(X, Y: Integer; const ATableName: String = ''): TADGUIxFormsQBldrTable;
    function  InsertLink(ATbl1, ATbl2: TADGUIxFormsQBldrTable; AFldN1, AFldN2: Integer): TADGUIxFormsQBldrLink;
    function  FindTable(const ATableName: String): TADGUIxFormsQBldrTable;
    function  FindLink(const ALink: TADGUIxFormsQBldrLink): Boolean;
    procedure ReboundLinks(ATable: TADGUIxFormsQBldrTable);
    procedure UnlinkTable(ATable: TADGUIxFormsQBldrTable);
    procedure BeginLoad;
    procedure EndLoad;
    property  QBController: TADGUIxFormsQBldrControllerBase read FQBController write SetQBController;
    property  Loading: Boolean read FLoading;
  end;

const
  cFld  = 0;
  cTbl  = 1;
  cShow = 2;
  cSort = 3;
  cFunc = 4;
  cGroup= 5;

  sSorts : array [1..3] of String =
    ('',
     'Asc',
     'Desc');
  sFuncs : array [1..6] of String =
    ('',
     'Avg',
     'Count',
     'Max',
     'Min',
     'Sum');

implementation

uses
{$IFDEF AnyDAC_D9}
  Types,
{$ENDIF}  
  Dialogs,
  daADGUIxFormsfQBldrLink, daADStanResStrs;

const
  Hand = 15;
  Hand2 = 12;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrControllerBase                                             }
{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrControllerBase.AreaFocused(AArea: TADGUIxFormsQBldrArea);
begin
  if FCurObj <> AArea then begin
    FCurObj := AArea;
    FCurSubObj := '';
    DoAreaFocused(AArea);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrControllerBase.TableFocused(ATable: TADGUIxFormsQBldrTable);
begin
  if FCurObj <> ATable then begin
    FCurObj := ATable;
    FCurSubObj := '';
    DoTableFocused(ATable);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrControllerBase.FieldFocused(ATable: TADGUIxFormsQBldrTable;
  const AFieldName: String);
begin
  if (FCurObj <> ATable) and (FCurSubObj <> AFieldName) then begin
    FCurObj := ATable;
    FCurSubObj := AFieldName;
    DoFieldFocused(ATable, AFieldName);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrControllerBase.LinkFocused(ALink: TADGUIxFormsQBldrLink);
begin
  if FCurObj <> ALink then begin
    FCurObj := ALink;
    FCurSubObj := '';
    DoLinkFocused(ALink);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrControllerBase.ObjectDeleted(AObj: TObject);
begin
  if FCurObj = AObj then
    AreaFocused(QBArea);
  DoChanged;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrControllerBase.NewArea(AOwner: TComponent): TADGUIxFormsQBldrArea;
begin
  Result := TADGUIxFormsQBldrArea.Create(AOwner);
  DoChanged;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrControllerBase.NewLink(AOwner: TComponent): TADGUIxFormsQBldrLink;
begin
  Result := TADGUIxFormsQBldrLink.Create(AOwner);
  DoChanged;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrControllerBase.NewTable(AOwner: TComponent): TADGUIxFormsQBldrTable;
begin
  Result := TADGUIxFormsQBldrTable.Create(AOwner);
  DoChanged;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrControllerBase.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged(nil);
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrFields                                                     }
{ --------------------------------------------------------------------------- }
function GetBldrArea(ACtrl: TControl): TADGUIxFormsQBldrArea;
var
  oCtrl: TControl;
begin
  oCtrl := ACtrl.Parent;
  while (oCtrl <> nil) and not (oCtrl is TADGUIxFormsQBldrArea) do
    oCtrl := oCtrl.Parent;
  Result := TADGUIxFormsQBldrArea(oCtrl);
end;

{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrFields.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FArrBold := nil;
  Color := clWhite;
  Color2 := clInfoBk;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsQBldrFields.Destroy;
begin
  FArrBold := nil;
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrFields.GetQBArea: TADGUIxFormsQBldrArea;
begin
  Result := GetBldrArea(Self);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrFields.GetQBTable: TADGUIxFormsQBldrTable;
begin
  Result := TADGUIxFormsQBldrTable(Parent);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
begin
  if not (odSelected in State) then
    if Index mod 2 = 0 then
      Canvas.Brush.Color := Color
    else
      Canvas.Brush.Color := Color2;
  if (Index >= 0) and (Index <= Items.Count - 1) then begin
    if FArrBold[Index] = 1 then
      Canvas.Font.Style := [fsBold];
    inherited;
    if FArrBold[Index] = 1 then
      Canvas.Font.Style := [];
  end
  else
    inherited;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.WMLButtonDown(var Message: TWMLButtonDblClk);
begin
  inherited;
  BeginDrag(False);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.ClickCheck;
begin
  inherited;
  if QBArea.Loading then
    Exit;
  QBArea.QBController.DoFieldChecked(QBTable, Items[ItemIndex], Checked[ItemIndex]);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.AllocArrBold;
begin
  SetLength(FArrBold, Items.Count);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.SelectItemBold(AItem: Integer);
begin
  if FArrBold[AItem] = 0 then
    FArrBold[AItem] := 1;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.UnSelectItemBold(AItem: Integer);
begin
  if FArrBold[AItem] = 1 then
    FArrBold[AItem] := 0;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrFields.GetItemY(AItem: Integer): Integer;
var
  R: TRect;
begin
  R := ItemRect(AItem);
  Result := (R.Top + R.Bottom) div 2 + 1;
  if Result < 0 then
    Result := 0
  else if Result > ClientHeight then
    Result := ClientHeight;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.WMVScroll(var Message: TMessage);
begin
  inherited;
  QBArea.ReboundLinks(QBTable);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.WMKeyDown(var Message: TMessage);
var
  iPrevTop: Integer;
begin
  iPrevTop := TopIndex;
  inherited;
  if iPrevTop <> TopIndex then
    QBArea.ReboundLinks(QBTable);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrFields.Click;
begin
  inherited Click;
  QBArea.QBController.FieldFocused(QBTable, Items[ItemIndex]);
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrTable                                                      }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrTable.Create(AOwner: TComponent);
var
  mnuArr: array [1..5] of TMenuItem;
  iBrdWidth: Integer;
begin
  inherited Create(AOwner);
  Visible := False;
  ShowHint := True;
  BevelInner := bvLowered;
  BevelOuter := bvRaised;
  BorderWidth := 4;
  Font.Style := [fsBold];
  Font.Size := 8;
  Color := clLtGray;
  iBrdWidth := BorderWidth + 2;

  FCaption := TLabel.Create(Self);
  FCaption.Parent := Self;
  FCaption.Color := clLtGray;
  FCaption.AutoSize := False;
  FCaption.Top := iBrdWidth;
  FCaption.Left := iBrdWidth;
  FCaption.Height := 16;
  FCaption.Width := Width - 2 * (iBrdWidth) - 24;
  FCaption.Anchors := [akLeft, akRight, akTop];

  FMinBtn := TSpeedButton.Create(Self);
  FMinBtn.Parent := Self;
  FMinBtn.Hint := S_AD_QBldrMinBtnHint;
  FMinBtn.Width := 12;
  FMinBtn.Height := 12;
  FMinBtn.Margin := -1;
  FMinBtn.Spacing := 0;
  FMinBtn.Top := iBrdWidth + 2;
  FMinBtn.Left := Width - iBrdWidth - 14 - FMinBtn.Width;
  FMinBtn.Anchors := [akTop, akRight];
  FMinBtn.OnClick := DoMinBtn;

  FCloseBtn := TSpeedButton.Create(Self);
  FCloseBtn.Parent := Self;
  FCloseBtn.Hint := S_AD_QBldrCloseBtnHint;
  FCloseBtn.Width := 12;
  FCloseBtn.Height := 12;
  FCloseBtn.Margin := -1;
  FCloseBtn.Spacing := 0;
  FCloseBtn.Top := 8;
  FCloseBtn.Left := Width - iBrdWidth - 14;
  FCloseBtn.Glyph.LoadFromResourceName(HInstance, 'ADQBCLOSE');
  FCloseBtn.Anchors := [akTop, akRight];
  FCloseBtn.OnClick := DoCloseBtn;

  FFields := TADGUIxFormsQBldrFields.Create(Self);
  FFields.BorderStyle := bsNone;
  FFields.Parent := Self;
  FFields.Style := lbStandard;
  FFields.ParentFont := False;
  FFields.Font.Style := [];
  FFields.Font.Size := 8;
  FFields.Font.Color := clInfoText;
  FFields.Top := FCaption.Top + FCaption.Height;
  FFields.Left := iBrdWidth;
  FFields.Width := Width - 2 * iBrdWidth;
  FFields.Height := Height - FFields.Top - iBrdWidth;
  FFields.Anchors := [akLeft, akRight, akTop, akBottom];
  FFields.OnDragOver := DoDragOver;
  FFields.OnDragDrop := DoDragDrop;

  mnuArr[1] := NewItem(S_AD_QBldrSelectAllCapt, 0, False, True, DoSelectAll, 0, 'mnuSelectAll');
  mnuArr[2] := NewItem(S_AD_QBldrUnSelectAllCapt, 0, False, True, DoUnSelectAll, 0, 'mnuUnSelectAll');
  mnuArr[3] := NewLine;
  mnuArr[4] := NewItem(S_AD_QBldrUnlinkCapt, 0, False, True, DoUnlinkBtn, 0, 'mnuUnLink');
  mnuArr[5] := NewItem(S_AD_QBldrCloseCapt, 0, False, True, DoCloseBtn, 0, 'mnuClose');
  FPopMenu := NewPopupMenu(Self, 'mnu', paLeft, True, mnuArr);
  FPopMenu.PopupComponent := Self;
  FFields.PopupMenu := FPopMenu;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsQBldrTable.Destroy;
begin
  if QBArea <> nil then
    QBArea.QBController.ObjectDeleted(Self);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrTable.GetQBArea: TADGUIxFormsQBldrArea;
begin
  Result := GetBldrArea(Self);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrTable.GetMinimized: Boolean;
begin
  Result := FMinBtn.Tag <> 0;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.SetMinimized(AValue: Boolean);
begin
  if AValue then begin
    FMinBtn.Tag := 1;
    FMinBtn.Glyph.LoadFromResourceName(HInstance, 'ADQBRESTORE');
  end
  else begin
    FMinBtn.Tag := 0;
    FMinBtn.Glyph.LoadFromResourceName(HInstance, 'ADQBMINIMIZE')
  end;
  UpdateLayout;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrTable.GetFullTableName: String;
begin
  if FTableAlias <> '' then
    Result := FTableName + ' ' + FTableAlias
  else
    Result := FTableName;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrTable.GetRefTableName: String;
begin
  if FTableAlias <> '' then
    Result := FTableAlias
  else
    Result := FTableName;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrTable.GetRowY(FldN: Integer): Integer;
var
  pnt: TPoint;
  Y: Integer;
begin
  if not Minimized then
    Y := FFields.GetItemY(FldN)
  else
    Y := -11;
  pnt.X := FFields.Left;
  pnt.Y := FFields.Top + Y;
  pnt := Parent.ScreenToClient(ClientToScreen(pnt));
  Result := pnt.Y;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.UpdateLayout;
var
  i, iFieldsHeight: Integer;
  iWidth, W: Integer;
  s: String;
begin
  Canvas.Font := Font;
  if not Minimized then begin
    iFieldsHeight := FFields.ItemHeight * FFields.Items.Count;
    iWidth := 110;
    for i := 0 to FFields.Items.Count - 1 do begin
      W := Canvas.TextWidth(FFields.Items[i]);
      if iWidth < W then
        iWidth := W;
    end;
  end
  else begin
    iFieldsHeight := 0;
    iWidth := 0;
  end;

  iWidth := iWidth + 20 + FFields.GetCheckWidth;
  if QBArea.QBController.UseTableAliases then
    s := FTableName + ': ' + FTableAlias
  else
    s := FTableName;
  W := Canvas.TextWidth(s);
  if W > iWidth - 40 then
    iWidth := W + 40;

  Width := iWidth;
  Height := iFieldsHeight + 2 * (BorderWidth + 2) + FCaption.Height;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.Activate(const ATableName, ATableAlias: String;
  X, Y: Integer; IsMin: Boolean; W, H: Integer);
begin
  FTableName := ATableName;
  if ATableAlias <> '' then
    FTableAlias := ATableAlias
  else if QBArea.QBController.UseTableAliases then
    FTableAlias := QBArea.CreateAlias(ATableName)
  else
    FTableAlias := '';
  if FTableAlias <> '' then
    FCaption.Caption := FTableName + ': ' + FTableAlias
  else
    FCaption.Caption := FTableName;
  Hint := FCaption.Caption;

  QBArea.QBController.DoGetFields(Self, FFields.Items);
  FFields.AllocArrBold;

  Minimized := IsMin;
  Top := Y;
  Left := X;
  if not Minimized then begin
    if W <> -1 then
      Width := W;
    if H <> -1 then
      Height := H;
  end;
  FFields.Visible := True;
  FCloseBtn.Visible := True;
  FMinBtn.Visible := True;
  Visible := True;

  if not QBArea.Loading then
    QBArea.QBController.TableFocused(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoCloseBtn(Sender: TObject);
begin
  with QBArea do begin
    UnlinkTable(Self);
    DoUnSelectAll(nil);
    RemoveTable(Self);
  end;
  Free;
  Abort;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoUnlinkBtn(Sender: TObject);
begin
  QBArea.UnlinkTable(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoMinBtn(Sender: TObject);
begin
  Minimized := not Minimized;
  QBArea.ReboundLinks(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoSelectAll(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to FFields.Items.Count - 1 do begin
    FFields.Checked[i] := True;
    QBArea.QBController.DoFieldChecked(Self, FFields.Items[i], True);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoUnSelectAll(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FFields.Items.Count - 1 do begin
    FFields.Checked[i] := False;
    QBArea.QBController.DoFieldChecked(Self, FFields.Items[i], False);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source = QBArea.QBController.QBTableList) or
     (Source is TADGUIxFormsQBldrFields) then
    Accept := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  nRow: Integer;
  hRow: Integer;
begin
  if Source is TADGUIxFormsQBldrFields then begin
    hRow := FFields.ItemHeight;
    if hRow <> 0 then
      nRow := Y div hRow
    else
      nRow := 0;
    if nRow > FFields.Items.Count - 1 then
      nRow := FFields.Items.Count - 1;
    // handler for target's '*' row
    if nRow = 0 then
      Exit;
    // handler for source's '*' row
    if TADGUIxFormsQBldrTable(TWinControl(Source).Parent).FFields.ItemIndex = 0 then
      Exit;
    if Source <> FFields then
      QBArea.InsertLink(
        TADGUIxFormsQBldrTable(TWinControl(Source).Parent), Self,
        TADGUIxFormsQBldrTable(TWinControl(Source).Parent).FFields.ItemIndex, nRow)
    else begin
      if nRow <> FFields.ItemIndex then
        QBArea.InsertLink(Self, Self, FFields.ItemIndex, nRow);
    end;
  end
  else if Source = QBArea.QBController.QBTableList then begin
    X := X + Left + TWinControl(Sender).Left;
    Y := Y + Top + TWinControl(Sender).Top;
    QBArea.InsertTable(X, Y);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.WMNCHitTest(var Message: TMessage);
var
  oPos: TPoint;
begin
  inherited;
  oPos := Point(Message.LParamLo, Message.LParamHi);
  oPos := Parent.ScreenToClient(oPos);
  if not Minimized and
     (oPos.X > Left) and (oPos.X <= Left + Width - 1) and
     (oPos.Y > Top + Height - 4) and (oPos.Y < Top + Height) then
    Message.Result := HTBOTTOM
  else
  if not Minimized and
     (oPos.X > Left + Width - 4) and (oPos.X <= Left + Width) and
     (oPos.Y > Top + FCaption.Height) and (oPos.Y < Top + Height) then
    Message.Result := HTRIGHT
  else
  if (oPos.X > Left) and (oPos.X <= Left + FMinBtn.Left) and
     (oPos.Y > Top) and (oPos.Y < Top + FCaption.Height) then
    Message.Result := HTCAPTION;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.WMMove(var Message: TMessage);
begin
  inherited;
  QBArea.ReboundLinks(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.WMSize(var Message: TMessage);
begin
  inherited;
  QBArea.ReboundLinks(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  inherited;
  if Message.HitTest = HTCAPTION then
    QBArea.QBController.TableFocused(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrTable.DoEnter;
begin
  inherited DoEnter;
  QBArea.QBController.TableFocused(Self);
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrLink                                                       }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrLink.Create(AOwner: TComponent);
var
  mnuArr: array [1..4] of TMenuItem;
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  Width := 105;
  Height := 105;
  FRgn := CreateRectRgn(0, 0, Hand, Hand);
  mnuArr[1] := NewItem('', 0, False, False, nil, 0, 'mnuLinkName');
  mnuArr[2] := NewLine;
  mnuArr[3] := NewItem(S_AD_QBldrLinkOptsCapt, 0, False, True, DoOptions, 0, 'mnuOptions');
  mnuArr[4] := NewItem(S_AD_QBldrUnlinkCapt, 0, False, True, DoUnlink, 0, 'mnuUnlink');
  FPopMenu := NewPopupMenu(Self, 'mnu', paLeft, False, mnuArr);
  FPopMenu.PopupComponent := Self;
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxFormsQBldrLink.Destroy;
begin
  if QBArea <> nil then
    QBArea.QBController.ObjectDeleted(Self);
  DeleteObject(FRgn);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrLink.Activate(ATbl1, ATbl2: TADGUIxFormsQBldrTable; AFldN1, AFldN2: Integer): Boolean;
begin
  Tbl1 := ATbl1;
  Tbl2 := ATbl2;
  FldN1 := AFldN1;
  FldN2 := AFldN2;
  if QBArea.FindLink(Self) then begin
    ShowMessage('These tables are already linked.');
    Result := False;
  end
  else begin
    Tbl1.Fields.SelectItemBold(FFldN1);
    Tbl1.Fields.Refresh;
    Tbl2.Fields.SelectItemBold(FFldN2);
    Tbl2.Fields.Refresh;
    OnDragOver := QBArea.DoDragOver;
    OnDragDrop := QBArea.DoDragDrop;
    Rebound;
    Visible := True;
    if not QBArea.Loading then
      QBArea.QBController.LinkFocused(Self);
    Result := True;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.SetFldN1(const Value: Integer);
begin
  FFldN1 := Value;
  FFldNam1 := FTbl1.FFields.Items[FFldN1];
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.SetFldN2(const Value: Integer);
begin
  FFldN2 := Value;
  FFldNam2 := FTbl2.FFields.Items[FFldN2];
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.SetFldNam1(const Value: String);
begin
  FFldNam1 := Value;
  FFldN1 := FTbl1.FFields.Items.IndexOf(Value);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.SetFldNam2(const Value: String);
begin
  FFldNam2 := Value;
  FFldN2 := FTbl2.FFields.Items.IndexOf(Value);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.Rebound;
var
  X1,X2,
  Y1,Y2 : Integer;
begin
  FPopMenu.Items[0].Caption := FTbl1.FTableName + ' :: ' + FTbl2.FTableName;
  if FTbl1 = FTbl2 then begin
    X1 := FTbl1.Left + FTbl1.Width;
    X2 := FTbl1.Left + FTbl1.Width + Hand;
  end
  else if FTbl1.Left < FTbl2.Left then begin
    if FTbl1.Left + FTbl1.Width + Hand < FTbl2.Left then begin              //A
      X1 := FTbl1.Left + FTbl1.Width;
      X2 := FTbl2.Left;
      FLnkX := 1;
    end
    else if FTbl1.Left + FTbl1.Width > FTbl2.Left + FTbl2.Width then begin  //B
      X1 := FTbl2.Left + FTbl2.Width;
      X2 := FTbl1.Left + FTbl1.Width + Hand;
      FLnkX := 3;
    end
    else begin
      X1 := FTbl1.Left + FTbl1.Width;
      X2 := FTbl2.Left + FTbl2.Width + Hand;
      FLnkX := 2;
    end;
  end
  else if FTbl2.Left + FTbl2.Width + Hand > FTbl1.Left then begin           //C
    if FTbl2.Left + FTbl2.Width > FTbl1.Left + FTbl1.Width then begin
      X1 := FTbl1.Left + FTbl1.Width;
      X2 := FTbl2.Left + FTbl2.Width + Hand;
      FLnkX := 2;
    end
    else begin
      X1 := FTbl2.Left + FTbl2.Width;
      X2 := FTbl1.Left + FTbl1.Width + Hand;
      FLnkX := 3;
    end;
  end
  else begin                                                                //D
    X1 := FTbl2.Left + FTbl2.Width;
    X2 := FTbl1.Left;
    FLnkX := 4;
  end;

  Y1 := FTbl1.GetRowY(FFldN1);
  Y2 := FTbl2.GetRowY(FFldN2);
  if Y1 < Y2 then begin                                                     //M
    Y1 := FTbl1.GetRowY(FFldN1) - Hand div 2;
    Y2 := FTbl2.GetRowY(FFldN2) + Hand div 2;
    FLnkY := 1;
  end
  else begin                                                                //N
    Y2 := FTbl1.GetRowY(FFldN1) + Hand div 2;
    Y1 := FTbl2.GetRowY(FFldN2) - Hand div 2;
    FLnkY := 2;
  end;
  SetBounds(X1, Y1, X2 - X1, Y2 - Y1);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.Paint;
var
  ArrRgn, pntArray: array [1..4] of TPoint;
  ArrCnt: Integer;
begin
  if FTbl1 <> FTbl2 then begin
    if (FLnkX = 1) and (FLnkY = 1) or (FLnkX = 4) and (FLnkY = 2) then begin
      pntArray[1].X := 0;
      pntArray[1].Y := Hand div 2;
      pntArray[2].X := Hand;
      pntArray[2].Y := Hand div 2;
      pntArray[3].X := Width - Hand;
      pntArray[3].Y := Height - Hand div 2;
      pntArray[4].X := Width;
      pntArray[4].Y := Height - Hand div 2;
      ArrRgn[1].X := pntArray[2].X + 5;
      ArrRgn[1].Y := pntArray[2].Y - 5;
      ArrRgn[2].X := pntArray[2].X - 5;
      ArrRgn[2].Y := pntArray[2].Y + 5;
      ArrRgn[3].X := pntArray[3].X - 5;
      ArrRgn[3].Y := pntArray[3].Y + 5;
      ArrRgn[4].X := pntArray[3].X + 5;
      ArrRgn[4].Y := pntArray[3].Y - 5;
    end;
    if Width > Hand + Hand2 then begin
      if (FLnkX = 2) and (FLnkY = 1) or (FLnkX = 3) and (FLnkY = 2) then begin
        pntArray[1].X := 0;
        pntArray[1].Y := Hand div 2;
        pntArray[2].X := Hand;
        pntArray[2].Y := Hand div 2;
        pntArray[3].X := Width-5;
        pntArray[3].Y := Height-Hand div 2;
        pntArray[4].X := Width-Hand;
        pntArray[4].Y := Height-Hand div 2;
        ArrRgn[1].X := pntArray[2].X+5;
        ArrRgn[1].Y := pntArray[2].Y-5;
        ArrRgn[2].X := pntArray[2].X-5;
        ArrRgn[2].Y := pntArray[2].Y+5;
        ArrRgn[3].X := pntArray[3].X-5;
        ArrRgn[3].Y := pntArray[3].Y+5;
        ArrRgn[4].X := pntArray[3].X+5;
        ArrRgn[4].Y := pntArray[3].Y-5;
      end;
      if (FLnkX = 3) and (FLnkY = 1) or (FLnkX = 2) and (FLnkY = 2) then begin
        pntArray[1].X := Width - Hand;
        pntArray[1].Y := Hand div 2;
        pntArray[2].X := Width - 5;
        pntArray[2].Y := Hand div 2;
        pntArray[3].X := Hand;
        pntArray[3].Y := Height - Hand div 2;
        pntArray[4].X := 0;
        pntArray[4].Y := Height - Hand div 2;
        ArrRgn[1].X := pntArray[2].X - 5;
        ArrRgn[1].Y := pntArray[2].Y - 5;
        ArrRgn[2].X := pntArray[2].X + 5;
        ArrRgn[2].Y := pntArray[2].Y + 5;
        ArrRgn[3].X := pntArray[3].X + 5;
        ArrRgn[3].Y := pntArray[3].Y + 5;
        ArrRgn[4].X := pntArray[3].X - 5;
        ArrRgn[4].Y := pntArray[3].Y - 5;
      end;
    end
    else begin
      if (FLnkX = 2) and (FLnkY = 1) or (FLnkX = 3) and (FLnkY = 2) or
         (FLnkX = 3) and (FLnkY = 1) or (FLnkX = 2) and (FLnkY = 2) then begin
        pntArray[1].X := 0;
        pntArray[1].Y := Hand div 2;
        pntArray[2].X := Width - Hand2;
        pntArray[2].Y := Hand div 2;
        pntArray[3].X := Width - Hand2;
        pntArray[3].Y := Height - Hand div 2;
        pntArray[4].X := 0;
        pntArray[4].Y := Height - Hand div 2;
        ArrRgn[1].X := pntArray[2].X - 5;
        ArrRgn[1].Y := pntArray[2].Y - 5;
        ArrRgn[2].X := pntArray[2].X + 5;
        ArrRgn[2].Y := pntArray[2].Y + 5;
        ArrRgn[3].X := pntArray[3].X + 5;
        ArrRgn[3].Y := pntArray[3].Y + 5;
        ArrRgn[4].X := pntArray[3].X - 5;
        ArrRgn[4].Y := pntArray[3].Y - 5;
      end;
    end;
    if (FLnkX = 4) and (FLnkY = 1) or (FLnkX = 1) and (FLnkY = 2) then begin
      pntArray[1].X := Width;
      pntArray[1].Y := Hand div 2;
      pntArray[2].X := Width-Hand;
      pntArray[2].Y := Hand div 2;
      pntArray[3].X := Hand;
      pntArray[3].Y := Height-Hand div 2;
      pntArray[4].X := 0;
      pntArray[4].Y := Height-Hand div 2;
      ArrRgn[1].X := pntArray[2].X-5;
      ArrRgn[1].Y := pntArray[2].Y-5;
      ArrRgn[2].X := pntArray[2].X+5;
      ArrRgn[2].Y := pntArray[2].Y+5;
      ArrRgn[3].X := pntArray[3].X+5;
      ArrRgn[3].Y := pntArray[3].Y+5;
      ArrRgn[4].X := pntArray[3].X-5;
      ArrRgn[4].Y := pntArray[3].Y-5;
    end;
  end
  else begin
    pntArray[1].X := 0;
    pntArray[1].Y := Hand div 2;
    pntArray[2].X := Hand - 5;
    pntArray[2].Y := Hand div 2;
    pntArray[3].X := Hand - 5;
    pntArray[3].Y := Height - Hand div 2;
    pntArray[4].X := 0;
    pntArray[4].Y := Height - Hand div 2;
    ArrRgn[1].X := pntArray[2].X + 5;
    ArrRgn[1].Y := pntArray[2].Y - 5;
    ArrRgn[2].X := pntArray[2].X - 5;
    ArrRgn[2].Y := pntArray[2].Y + 5;
    ArrRgn[3].X := pntArray[3].X - 5;
    ArrRgn[3].Y := pntArray[3].Y + 5;
    ArrRgn[4].X := pntArray[3].X + 5;
    ArrRgn[4].Y := pntArray[3].Y - 5;
  end;
  Canvas.PolyLine(pntArray);
  Canvas.Brush := Parent.Brush;
  DeleteObject(FRgn);
  ArrCnt := 4;
  FRgn := CreatePolygonRgn(ArrRgn, ArrCnt, ALTERNATE);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.DoClick(X, Y: Integer);
var
  pnt: TPoint;
begin
  QBArea.QBController.LinkFocused(Self);
  pnt.X := X;
  pnt.Y := Y;
  pnt := ClientToScreen(pnt);
  FPopMenu.Popup(pnt.X, pnt.Y);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.CMHitTest(var Message: TCMHitTest);
begin
  if PtInRegion(FRgn, Message.XPos, Message.YPos) then
    Message.Result := 1;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrLink.ControlAtPos(const Pos: TPoint): TControl;
var
  i: Integer;
  scrnP, P: TPoint;
begin
  scrnP := ClientToScreen(Pos);
  for i := Parent.ControlCount - 1 downto 0 do begin
    Result := Parent.Controls[i];
    if (Result is TADGUIxFormsQBldrLink) and (Result <> Self) then
      with Result do begin
        P := Result.ScreenToClient(scrnP);
        if Perform(CM_HITTEST, 0, Integer(PointToSmallPoint(P))) <> 0 then
          Exit;
      end;
    end;
  Result := nil;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_RBUTTONDOWN then
    if not PtInRegion(FRgn, TWMMouse(Message).XPos, TWMMouse(Message).YPos) then
      ControlAtPos(SmallPointToPoint(TWMMouse(Message).Pos))
    else
      DoClick(TWMMouse(Message).XPos, TWMMouse(Message).YPos)
  else if Message.Msg = WM_LBUTTONDOWN then
    QBArea.QBController.LinkFocused(Self);
  inherited WndProc(Message);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrLink.GetQBArea: TADGUIxFormsQBldrArea;
begin
  Result := TADGUIxFormsQBldrArea(Parent);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.DoOptions(Sender: TObject);
var
  AForm: TfrmADGUIxFormsQBldrLink;
begin
  AForm := TfrmADGUIxFormsQBldrLink.Create(Application);
  try
    AForm.txtTable1.Text := Tbl1.TableName;
    AForm.txtCol1.Text := FldNam1;
    AForm.txtTable2.Text := Tbl2.TableName;
    AForm.txtCol2.Text := FldNam2;
    AForm.RadioOpt.ItemIndex := LinkOpt;
    AForm.RadioType.ItemIndex := LinkType;
    if AForm.ShowModal = mrOk then begin
      LinkOpt := AForm.RadioOpt.ItemIndex;
      LinkType := AForm.RadioType.ItemIndex;
      QBArea.QBController.DoChanged;
    end;
  finally
    AForm.Free;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrLink.DoUnlink(Sender: TObject);
begin
  if not QBArea.FindOtherLink(Self, Tbl1, FldN1) then begin
    Tbl1.Fields.UnSelectItemBold(FldN1);
    Tbl1.Fields.Refresh;
  end;
  if not QBArea.FindOtherLink(Self, Tbl2, FldN2) then begin
    Tbl2.Fields.UnSelectItemBold(FldN2);
    Tbl2.Fields.Refresh;
  end;
  QBArea.RemoveLink(Self);
  Free;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrGrid                                                       }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrGrid.Create(AOwner: TComponent);
var
  oItem: TMenuItem;
begin
  inherited Create(AOwner);
  Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
    goColSizing, goColMoving];
  ColCount := 2;
  RowCount := 6;
  Cells[0, cFld] := S_AD_QBldrFieldCapt;
  Cells[0, cTbl] := S_AD_QBldrTableCapt;
  Cells[0, cShow] := S_AD_QBldrGrdShow;
  Cells[0, cSort] := S_AD_QBldrSortCapt;
  Cells[0, cFunc] := S_AD_QBldrFunctionCapt;
  Cells[0, cGroup] := S_AD_QBldrGrdGroup;
  OnDragOver := DoDragOver;
  OnDragDrop := DoDragDrop;
  FIsEmpty := True;
  Color := clInfoBk;
  // tables
  FmnuTbl := TPopupMenu.Create(Self);
  with FmnuTbl do begin
    AutoPopup := False;
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Caption := S_AD_QBldrRemoveCapt;
      OnClick := mnuRemoveClick;
    end;
    Items.Add(oItem);
  end;
  // functions
  FmnuFunc := TPopupMenu.Create(Self);
  with FmnuFunc do begin
    AutoPopup := False;
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 1;
      Caption := S_AD_QBldrNoFunctionCapt;
      Checked := True;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuFunctionClick;
    end;
    Items.Add(oItem);
    Items.Add(NewLine);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 2;
      Caption := S_AD_QBldrAverageCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuFunctionClick;
    end;
    Items.Add(oItem);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 3;
      Caption := S_AD_QBldrCountCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuFunctionClick;
    end;
    Items.Add(oItem);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 4;
      Caption := S_AD_QBldrMaximumCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuFunctionClick;
    end;
    Items.Add(oItem);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 5;
      Caption := S_AD_QBldrMinimumCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuFunctionClick;
    end;
    Items.Add(oItem);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 6;
      Caption := S_AD_QBldrSumCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuFunctionClick;
    end;
  end;
  // grouping
  FmnuGroup := TPopupMenu.Create(Self);
  with FmnuGroup do begin
    AutoPopup := False;
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Caption := S_AD_QBldrGrdGroup;
      Checked := True;
      OnClick := mnuGroupClick;
    end;
    Items.Add(oItem);
  end;
  // sorting
  FmnuSort := TPopupMenu.Create(Self);
  with FmnuSort do begin
    AutoPopup := False;
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 1;
      Caption := S_AD_QBldrNoSortCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuSortClick;
    end;
    Items.Add(oItem);
    Items.Add(NewLine);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 2;
      Caption := S_AD_QBldrAscendingCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuSortClick;
    end;
    Items.Add(oItem);
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Tag := 3;
      Caption := S_AD_QBldrDescendingCapt;
      GroupIndex := 1;
      RadioItem := True;
      OnClick := mnuSortClick;
    end;
    Items.Add(oItem);
  end;
  // show
  FmnuShow := TPopupMenu.Create(Self);
  with FmnuShow do begin
    AutoPopup := False;
    oItem := TMenuItem.Create(Self);
    with oItem do begin
      Caption := S_AD_QBldrGrdShow;
      Checked := True;
      OnClick := mnuShowClick;
    end;
    Items.Add(oItem);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_RBUTTONDOWN then
    ClickCell(TWMMouse(Message).XPos, TWMMouse(Message).YPos);
  inherited WndProc(Message);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrGrid.MaxSW(s1, s2: String): Integer;
begin
  Result := Canvas.TextWidth(s1);
  if Result < Canvas.TextWidth(s2) then
    Result := Canvas.TextWidth(s2);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.InsertDefault(aCol: Integer);
begin
  Cells[aCol, cShow] := S_AD_QBldrGrdShow;
  Cells[aCol, cSort] := '';
  Cells[aCol, cFunc] := '';
  Cells[aCol, cGroup] := '';
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.Insert(aCol: Integer; aField, aTable: String);
var
  i: Integer;
begin
  if FIsEmpty then begin
    FIsEmpty := False;
    aCol := 1;
    Cells[aCol, cFld] := aField;
    Cells[aCol, cTbl] := aTable;
    InsertDefault(aCol);
  end
  else begin
    if aCol = -1 then begin
      ColCount := ColCount + 1;
      aCol := ColCount - 1;
      Cells[aCol, cFld] := aField;
      Cells[aCol, cTbl] := aTable;
      InsertDefault(aCol);
    end
    else begin
      ColCount := ColCount + 1;
      for i := ColCount - 1 downto aCol + 1 do
        MoveColumn(i - 1, i);
      Cells[aCol, cFld] := aField;
      Cells[aCol, cTbl] := aTable;
      InsertDefault(aCol);
    end;
    if aCol > 1 then
      ColWidths[aCol - 1] := MaxSW(Cells[aCol - 1, cFld], Cells[aCol - 1, cTbl]) + 8;
    if aCol < ColCount - 1 then
      ColWidths[aCol + 1] := MaxSW(Cells[aCol + 1, cFld], Cells[aCol + 1, cTbl]) + 8;
    ColWidths[ColCount - 1] := MaxSW(Cells[ColCount - 1, cFld], Cells[ColCount - 1, cTbl]) + 8;
  end;
  ColWidths[aCol] := MaxSW(aTable, aField) + 8;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrGrid.FindColumn(const sCol, sRefTableName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 1 to ColCount - 1 do
    if (Cells[i, cFld] = sCol) and (AnsiCompareText(Cells[i, cTbl], sRefTableName) = 0) then begin
      Result := i;
      Break;
    end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrGrid.FindSameColumn(aCol: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to ColCount - 1 do
    if (i <> aCol) and (Cells[i, cFld] = Cells[aCol, cFld]) then begin
      Result := True;
      Break;
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.RemoveColumn(aCol: Integer);
var
  i: Integer;
begin
  if ColCount > 2 then
    DeleteColumn(aCol)
  else begin
    for i := 0 to RowCount - 1 do
      Cells[1, i] := '';
    FIsEmpty := True;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.RemoveColumns(const sRefTableName: String);
var
  i: Integer;
begin
  for i := ColCount - 1 downto 1 do
    if AnsiCompareText(Cells[i, cTbl], sRefTableName) = 0 then
      RemoveColumn(i);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.ClickCell(X, Y: Integer);
var
  P: TPoint;
  mCol, mRow: Integer;
begin
  MouseToCell(X, Y, mCol, mRow);
  FCurrCol := mCol;
  P.X := X;
  P.Y := Y;
  P := ClientToScreen(P);
  if (mCol > 0) and (mCol < ColCount) and not FIsEmpty then begin
    if (Cells[mCol, 0] = '*') and (mRow <> cFld) and (mRow <> cFunc) then
      Exit;
    case mRow of
      cFld:
        begin
          FmnuTbl.Popup(P.X, P.Y);
        end;
      cShow:
        begin
          if Cells[mCol, cShow] = S_AD_QBldrGrdShow then
            FmnuShow.Items[0].Checked := True
          else
            FmnuShow.Items[0].Checked := False;
          FmnuShow.Popup(P.X, P.Y);
        end;
      cSort:
        begin
          if Cells[mCol, cSort] = sSorts[1] then
            FmnuSort.Items[0].Checked := True
          else if Cells[mCol, cSort] = sSorts[2] then
            FmnuSort.Items[2].Checked := True
          else
            FmnuSort.Items[3].Checked := True;
          FmnuSort.Popup(P.X, P.Y);
        end;
      cFunc:
        begin
          if Cells[mCol, cFunc] = sFuncs[1] then
            FmnuFunc.Items[0].Checked := True
          else if Cells[mCol, cFunc] = sFuncs[2] then
            FmnuFunc.Items[2].Checked := True
          else if Cells[mCol, cFunc] = sFuncs[3] then
            FmnuFunc.Items[3].Checked := True
          else if Cells[mCol, cFunc] = sFuncs[4] then
            FmnuFunc.Items[4].Checked := True
          else if Cells[mCol, cFunc] = sFuncs[5] then
            FmnuFunc.Items[5].Checked := True;
          if Cells[mCol, 0] = '*' then begin
            FmnuFunc.Items[2].Enabled := False;
            FmnuFunc.Items[4].Enabled := False;
            FmnuFunc.Items[5].Enabled := False;
          end
          else begin
            FmnuFunc.Items[2].Enabled := True;
            FmnuFunc.Items[4].Enabled := True;
            FmnuFunc.Items[5].Enabled := True;
          end;
          FmnuFunc.Popup(P.X, P.Y);
        end;
      cGroup:
        begin
          if Cells[mCol, cGroup] = S_AD_QBldrGrdGroup then
            FmnuGroup.Items[0].Checked := True
          else
            FmnuGroup.Items[0].Checked := False;
          FmnuGroup.Popup(P.X, P.Y);
        end;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  inherited SelectCell(ACol, ARow);
  if ARow <= cGroup then begin
    Result := True;
    if ACol > 0 then
      PostMessage(Handle, WM_AD_BldrGridCellSelected, 0, 0);
  end
  else
    Result := False;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.WMBldrGridCellSelected(var AMessage: TMessage);
begin
  QBArea.QBController.FieldFocused(QBArea.FindTable(Cells[Col, cTbl]),
    Cells[Col, cFld]);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.DoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source is TADGUIxFormsQBldrFields then
    Accept := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.DoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  dCol, dRow: Integer;
  oTab: TADGUIxFormsQBldrTable;
begin
  if Source is TADGUIxFormsQBldrFields then begin
    oTab := TADGUIxFormsQBldrTable(TWinControl(Source).Parent);
    oTab.Fields.Checked[oTab.Fields.ItemIndex] := True;
    MouseToCell(X, Y, dCol, dRow);
    if dCol = 0 then
      Exit;
    Insert(dCol, oTab.Fields.Items[oTab.Fields.ItemIndex], oTab.RefTableName);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.mnuFunctionClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := (Sender as TMenuItem);
  if not Item.Checked then begin
    Item.Checked := True;
    Cells[FCurrCol, cFunc] := sFuncs[Item.Tag];
    QBArea.QBController.DoChanged;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.mnuGroupClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := (Sender as TMenuItem);
  if Item.Checked then begin
    Cells[FCurrCol, cGroup] := '';
    Item.Checked := False;
  end
  else begin
    Cells[FCurrCol, cGroup] := S_AD_QBldrGrdGroup;
    Item.Checked := True;
  end;
  QBArea.QBController.DoChanged;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.mnuRemoveClick(Sender: TObject);
var
  oTab: TADGUIxFormsQBldrTable;
begin
  oTab := QBArea.FindTable(Cells[FCurrCol, cTbl]);
  if not FindSameColumn(FCurrCol) then
    oTab.Fields.Checked[oTab.Fields.Items.IndexOf(Cells[FCurrCol, cFld])] := False;
  RemoveColumn(FCurrCol);
  Refresh;
  QBArea.QBController.DoChanged;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.mnuShowClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := (Sender as TMenuItem);
  if Item.Checked then begin
    Cells[FCurrCol, cShow] := '';
    Item.Checked := False;
  end
  else begin
    Cells[FCurrCol, cShow] := S_AD_QBldrGrdShow;
    Item.Checked := True;
  end;
  QBArea.QBController.DoChanged;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrGrid.mnuSortClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  Item := (Sender as TMenuItem);
  if not Item.Checked then begin
    Item.Checked := True;
    Cells[FCurrCol, cSort] := sSorts[Item.Tag];
    QBArea.QBController.DoChanged;
  end;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxFormsQBldrArea                                                       }
{ --------------------------------------------------------------------------- }
constructor TADGUIxFormsQBldrArea.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnDragOver := DoDragOver;
  OnDragDrop := DoDragDrop;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrArea.InsertTable(X, Y: Integer;
  const ATableName: String): TADGUIxFormsQBldrTable;
var
  sName: String;
begin
  if ATableName <> '' then
    sName := ATableName
  else
    QBController.DoGetTable(sName);
  Result := QBController.NewTable(Self);
  try
    Result.Parent := Self;
    Result.Activate(sName, '', X, Y, False, -1, -1);
  except
    Result.Free;
    raise;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrArea.InsertLink(ATbl1, ATbl2: TADGUIxFormsQBldrTable;
  AFldN1, AFldN2: Integer): TADGUIxFormsQBldrLink;
begin
  Result := QBController.NewLink(Self);
  try
    Result.Parent := Self;
    if not Result.Activate(ATbl1, ATbl2, AFldN1, AFldN2) then
      FreeAndNil(Result);
  except
    Result.Free;
    raise;
  end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrArea.FindTable(const ATableName: String): TADGUIxFormsQBldrTable;
var
  i: Integer;
  oTab: TADGUIxFormsQBldrTable;
begin
  Result := nil;
  for i := ControlCount - 1 downto 0 do
    if Controls[i] is TADGUIxFormsQBldrTable then begin
      oTab := TADGUIxFormsQBldrTable(Controls[i]);
      if AnsiCompareText(oTab.RefTableName, ATableName) = 0 then begin
        Result := oTab;
        Exit;
      end;
    end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrArea.FindLink(const ALink: TADGUIxFormsQBldrLink): Boolean;
var
  i: Integer;
  oLink: TADGUIxFormsQBldrLink;
begin
  Result := False;
  for i := ControlCount - 1 downto 0 do
    if Controls[i] is TADGUIxFormsQBldrLink then begin
      oLink := TADGUIxFormsQBldrLink(Controls[i]);
      if oLink <> ALink then
        if (oLink.Tbl1 = ALink.Tbl1) and (oLink.FldN1 = ALink.FldN1) and
           (oLink.Tbl2 = ALink.Tbl2) and (oLink.FldN2 = ALink.FldN2) or
           (oLink.Tbl1 = ALink.Tbl2) and (oLink.FldN1 = ALink.FldN2) and
           (oLink.Tbl2 = ALink.Tbl1) and (oLink.FldN2 = ALink.FldN1) then begin
          Result := True;
          Exit;
        end;
    end;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrArea.FindOtherLink(const ALink: TADGUIxFormsQBldrLink;
  const ATbl: TADGUIxFormsQBldrTable; const AFldN: Integer): Boolean;
var
  i: Integer;
  oLink: TADGUIxFormsQBldrLink;
begin
  Result := False;
  for i := ControlCount - 1 downto 0 do
    if Controls[i] is TADGUIxFormsQBldrLink then begin
      oLink := TADGUIxFormsQBldrLink(Controls[i]);
      if oLink <> ALink then
        if (oLink.Tbl1 = ATbl) and (oLink.FldN1 = AFldN) or
           (oLink.Tbl2 = ATbl) and (oLink.FldN2 = AFldN) then begin
          Result := True;
          Exit;
        end;
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.ReboundLinks(ATable: TADGUIxFormsQBldrTable);
var
  i: Integer;
  oLink: TADGUIxFormsQBldrLink;
begin
  for i := 0 to ControlCount - 1 do begin
    if Controls[i] is TADGUIxFormsQBldrLink then begin
      oLink := TADGUIxFormsQBldrLink(Controls[i]);
      if (oLink.Tbl1 = ATable) or (oLink.Tbl2 = ATable) then
        oLink.Rebound;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.UnlinkTable(ATable: TADGUIxFormsQBldrTable);
var
  i: Integer;
  oLink: TADGUIxFormsQBldrLink;
begin
  for i := ControlCount - 1 downto 0 do begin
    if Controls[i] is TADGUIxFormsQBldrLink then
    begin
      oLink := TADGUIxFormsQBldrLink(Controls[i]);
      if (oLink.Tbl1 = ATable) or (oLink.Tbl2 = ATable) then begin
        RemoveLink(oLink);
        if not FindOtherLink(oLink, oLink.Tbl1, oLink.FldN1) then begin
          oLink.Tbl1.Fields.UnSelectItemBold(oLink.FldN1);
          oLink.Tbl1.Fields.Refresh;
        end;
        if not FindOtherLink(oLink, oLink.Tbl2, oLink.FldN2) then begin
          oLink.Tbl2.Fields.UnSelectItemBold(oLink.FldN2);
          oLink.Tbl2.Fields.Refresh;
        end;
        oLink.Free;
      end;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.RemoveTable(ATable: TADGUIxFormsQBldrTable);
begin
  QBController.ObjectDeleted(ATable);
  RemoveControl(ATable);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.RemoveLink(ALink: TADGUIxFormsQBldrLink);
begin
  QBController.ObjectDeleted(ALink);
  RemoveControl(ALink);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.DoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if Source = QBController.QBTableList then
    Accept := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.DoDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if not (Sender is TADGUIxFormsQBldrArea) then begin
    X := X + TControl(Sender).Left;
    Y := Y + TControl(Sender).Top;
  end;
  if Source = QBController.QBTableList then
    InsertTable(X, Y);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxFormsQBldrArea.CreateAlias(const ATableName: String): String;
var
  i, j: Integer;
  lFound: Boolean;
  ch: Char;
begin
  j := -1;
  i := 1;
  while (i <= Length(ATableName)) and not (ATableName[i] in ['A'..'Z', 'a'..'z']) do
    Inc(i);
  if i > Length(ATableName) then
    ch := 'A'
  else
    ch := UpCase(ATableName[i]);
  repeat
    Result := ch;
    Inc(j);
    if j > 0 then
      Result := Result + IntToStr(j);
    lFound := False;
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TADGUIxFormsQBldrTable then
        if AnsiCompareText(TADGUIxFormsQBldrTable(Controls[i]).TableAlias, Result) = 0 then begin
          lFound := True;
          Break;
        end;
  until not lFound;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.BeginLoad;
begin
  FLoading := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.EndLoad;
begin
  FLoading := False;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.Click;
begin
  inherited Click;
  QBController.AreaFocused(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxFormsQBldrArea.SetQBController(const Value: TADGUIxFormsQBldrControllerBase);
begin
  FQBController := Value;
  FQBController.AreaFocused(Self);
end;

end.
