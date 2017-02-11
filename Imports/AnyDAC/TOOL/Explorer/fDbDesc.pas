{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer base class for RDBMS objects property pages                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fDbDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Menus,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, ComCtrls, Buttons, DB, IniFiles,
  daADDatSManager, daADStanParam,
  daADPhysIntf,
  daADCompDataSet, daADCompClient,
  fBaseDesc, fExplorer, daADStanIntf, daADDAptIntf, daADStanOption,
  daADGUIxFormsControls;

type
  TADDbNode = class(TADExplorerNode)
  private
    function GetHierarchyName: String;
    function GetRDBMSName: String;
    function GetObjTypeName: String;
  public
    constructor Create;
    procedure GetParamStack(AStack: TStringList); virtual;
    procedure SetQParams(AQuery: TADQuery);
    function GetDef(var ARDBMS, AHier: String): TIniFile;
    property RDBMSName: String read GetRDBMSName;
    property HierarchyName: String read GetHierarchyName;
    property ObjTypeName: String read GetObjTypeName;
  end;

  {---------------------------------------------------------------------------}
  TfrmDbDesc = class(TfrmBaseDesc)
    qSQL: TADQuery;
    dsSQL: TDataSource;
    pmGrid: TPopupMenu;
    pnlMainBG: TADGUIxFormsPanel;
    miMemo: TMenuItem;
    pcMain: TADGUIxFormsPageControl;
    tsSQL: TTabSheet;
    Splitter1: TSplitter;
    Panel1: TADGUIxFormsPanel;
    Bevel1: TBevel;
    Panel2: TADGUIxFormsPanel;
    btnRun: TSpeedButton;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    Panel4: TADGUIxFormsPanel;
    dbgSQL: TDBGrid;
    pnlEnterSQLSubTitle: TADGUIxFormsPanel;
    procedure btnRunClick(Sender: TObject);
    procedure mmSQLChange(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure dbgDblClick(Sender: TObject);
    procedure dbgColEnter(Sender: TObject);
    procedure miMemoClick(Sender: TObject);
    procedure pmGridPopup(Sender: TObject);
    procedure mmSQLDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure mmSQLDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    FSQLs: TStringList;
    FSQLIndex: Integer;
    FSQLFromHistory: Boolean;
    procedure SQLsChanged(Sender: TObject);
    procedure ShowMemo(AGrid: TDBGrid);
  public
    mmSQL: TADGUIxFormsMemo;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadData; override;
    procedure DoKeyDown(var Key: Word; Shift: TShiftState); override;
  end;

var
  frmDbDesc: TfrmDbDesc;

implementation

{$R *.dfm}

uses
  fDbObjDesc, fDbSetDesc, fBlob;

{-----------------------------------------------------------------------------}
{ TfrmDbDesc                                                                  }
{-----------------------------------------------------------------------------}
constructor TfrmDbDesc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  mmSQL := TADGUIxFormsMemo.Create(Self);
  with mmSQL do begin
    Parent := Panel1;
    Hint := 'SQL query text';
    Align := alClient;
    BorderStyle := bsNone;
    ScrollBars := ssBoth;
    TabOrder := 0;
    WordWrap := False;
    OnChange := mmSQLChange;
    OnDragDrop := mmSQLDragDrop;
    OnDragOver := mmSQLDragOver;
  end;
  FSQLs := TStringList.Create;
  FSQLs.OnChange := SQLsChanged;
  FSQLIndex := 0;
  FSQLFromHistory := False;
  SQLsChanged(nil);
  mmSQLChange(nil);
end;

{-----------------------------------------------------------------------------}
destructor TfrmDbDesc.Destroy;
begin
  FSQLs.Free;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.SQLsChanged(Sender: TObject);
begin
  btnPrev.Enabled := FSQLIndex > 0;
  btnNext.Enabled := FSQLIndex < FSQLs.Count - 1;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.mmSQLChange(Sender: TObject);
begin
  btnRun.Enabled := (Trim(mmSQL.Text) <> '');
  FSQLFromHistory := False;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.btnRunClick(Sender: TObject);
begin
  try
    qSQL.Disconnect;
    qSQL.Connection := ExplNode.Connection;
    qSQL.SQL.Assign(mmSQL.Lines);
    qSQL.Prepare;
    if qSQL.Command.CommandKind in [skSelect, skSelectForUpdate, skStoredProcWithCrs] then begin
      qSQL.Open;
      ExplNode.Explorer.stbDown.Panels[0].Text := 'Ok';
    end
    else begin
      qSQL.ExecSQL;
      ExplNode.Explorer.stbDown.Panels[0].Text := 'Ok. Rows affected: ' +
        IntToStr(qSQL.RowsAffected);
    end;
  except
    on E: Exception do begin
      ExplNode.Explorer.stbDown.Panels[0].Text := E.Message;
      raise;
    end;
  end;
  if not FSQLFromHistory then begin
    FSQLIndex := FSQLs.Count;
    FSQLs.Add(mmSQL.Text);
    FSQLFromHistory := True;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.btnPrevClick(Sender: TObject);
begin
  if FSQLIndex > 0 then begin
    Dec(FSQLIndex);
    mmSQL.Text := FSQLs[FSQLIndex];
    FSQLFromHistory := True;
    SQLsChanged(nil);
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.btnNextClick(Sender: TObject);
begin
  if FSQLIndex < FSQLs.Count - 1 then begin
    Inc(FSQLIndex);
    mmSQL.Text := FSQLs[FSQLIndex];
    FSQLFromHistory := True;
    SQLsChanged(nil);
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.pcMainChange(Sender: TObject);
begin
  if pcMain.ActivePage = tsSQL then begin
    SetDS(dsSQL);
    mmSQL.SetFocus;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.LoadData;
begin
  pcMain.OnChange(nil);
  inherited LoadData;
end;

{----------------------------------------------------------------------------}
procedure TfrmDbDesc.DoKeyDown(var Key: Word; Shift: TShiftState);
begin
  if pcMain.ActivePage <> tsSQL then
    Exit;
  if (Key = VK_F9) and (Shift = []) then begin
    if btnRun.Enabled then
      btnRun.Click;
    Key := 0;
  end
  else if ((Key = VK_UP) or (Key = VK_LEFT)) and (Shift = [ssAlt]) then begin
    if btnPrev.Enabled then
      btnPrev.Click;
    Key := 0;
  end
  else if ((Key = VK_DOWN) or (Key = VK_RIGHT)) and (Shift = [ssAlt]) then begin
    if btnNext.Enabled then
      btnNext.Click;
    Key := 0;
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.ShowMemo(AGrid: TDBGrid);
begin
  if frmBlob = nil then
    frmBlob := TfrmBlob.Create(Application);
  frmBlob.FocusField(AGrid.SelectedField);
  frmBlob.BringToFront;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.dbgDblClick(Sender: TObject);
begin
  if ExplNode.Explorer.DblclickMemo then
    ShowMemo(TDBGrid(Sender));
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.dbgColEnter(Sender: TObject);
begin
  if (frmBlob <> nil) and frmBlob.Visible then
    frmBlob.FocusField(TDBGrid(Sender).SelectedField);
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.pmGridPopup(Sender: TObject);
begin
  miMemo.Enabled := (Screen.ActiveControl is TCustomDBGrid) and
    (TDBGrid(Screen.ActiveControl).SelectedField <> nil);
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.miMemoClick(Sender: TObject);
begin
  ShowMemo(TDBGrid(Screen.ActiveControl));
end;

{-----------------------------------------------------------------------------}
{ TADDbNode                                                                   }
{-----------------------------------------------------------------------------}
constructor TADDbNode.Create;
begin
  inherited Create;
  FStatus := FStatus + [nsSettingsInvalidate];
end;

{-----------------------------------------------------------------------------}
function TADDbNode.GetHierarchyName: String;
begin
  Result := Explorer.Hierarchy;
end;

{-----------------------------------------------------------------------------}
function TADDbNode.GetRDBMSName: String;
begin
  Result := C_AD_PhysRDBMSKinds[Connection.RDBMSKind];
end;

{-----------------------------------------------------------------------------}
function TADDbNode.GetObjTypeName: String;
var
  oSetNode: TADDbSetNode;
begin
  oSetNode := TADDbSetNode(GetParent(TADDbSetNode));
  if oSetNode = nil then
    Result := ''
  else
    Result := oSetNode.ObjTypeName;
end;

{-----------------------------------------------------------------------------}
procedure TADDbNode.GetParamStack(AStack: TStringList);
begin
  if ParentNode is TADDbNode then
    TADDbNode(ParentNode).GetParamStack(AStack);
end;

{-----------------------------------------------------------------------------}
procedure TADDbNode.SetQParams(AQuery: TADQuery);
var
  oStack: TStringList;
  i: Integer;
begin
  oStack := TStringList.Create;
  try
    GetParamStack(oStack);
    for i := 0 to AQuery.Params.Count - 1 do
      AQuery.Params[i].AsString := oStack.Values[AQuery.Params[i].Name];
    for i := 0 to AQuery.Macros.Count - 1 do
      AQuery.Macros[i].AsIdentifier := oStack.Values[AQuery.Macros[i].Name];
  finally
    oStack.Free;
  end;
end;

{-----------------------------------------------------------------------------}
function TADDbNode.GetDef(var ARDBMS, AHier: String): TIniFile;
begin
  Result := TIniFile.Create(Explorer.DefinitionFileName);
  if Result.SectionExists(RDBMSName + '.Hierarchy.' + HierarchyName) then begin
    ARDBMS := RDBMSName;
    AHier := HierarchyName;
  end
  else if Result.SectionExists(RDBMSName + '.Hierarchy.ByObjType') then begin
    ARDBMS := RDBMSName;
    AHier := 'ByObjType';
  end
  else begin
    ARDBMS := 'ANY';
    AHier := 'ByObjType';
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.mmSQLDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = ExplNode.Explorer.tvLeft);
  if Accept then begin
    mmSQL.SelStart := LoWord(SendMessage(mmSQL.Handle, EM_CHARFROMPOS, 0, MakeLParam(X, Y)));
    ShowCaret(mmSQL.Handle);
  end;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbDesc.mmSQLDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  mmSQL.SelText := ExplNode.Explorer.tvLeft.Selected.Text;
end;

end.
