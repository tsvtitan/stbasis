{ --------------------------------------------------------------------------- }
{ AnyDAC Explorer class for RDBMS object property page                        }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I daAD.inc}

unit fDbObjDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids, ExtCtrls, StdCtrls, Buttons, Menus, DBGrids, DB,
  daADStanOption, daADDatSManager, daADStanParam, daADStanIntf,
  daADDAptIntf,
  daADPhysIntf,
  daADCompDataSet, daADCompClient,
  daADGUIxFormsControls,
  fBaseDesc, fDbDesc, fExplorer;

type
  {---------------------------------------------------------------------------}
  TADDbObjNode = class(TADDbNode)
  private
    FParams: TStringList;
    FProps: TStringList;
  protected
    function GetStatus: TADExplorerNodeStatuses; override;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateExpander: TADExplorerNodeExpander; override;
    function CreateFrame: TFrame; override;
    procedure GetParamStack(AStack: TStringList); override;
    property Params: TStringList read FParams;
    property Props: TStringList read FProps;
  end;

  {---------------------------------------------------------------------------}
  TADDbObjNodeExpander = class(TADExplorerNodeExpander)
  private
    FValsIndex: Integer;
    FVals: TStringList;
    function GetSubSets(const AParentTypeName: String): String;
  public
    constructor Create(ANode: TADExplorerNode); override;
    destructor Destroy; override;
    function Next: TADExplorerNode; override;
  end;

  {---------------------------------------------------------------------------}
  TfrmDbObjDesc = class(TfrmDbDesc)
    tsDef: TTabSheet;
    tsData: TTabSheet;
    sgDef: TStringGrid;
    dsData: TDataSource;
    dbgData: TDBGrid;
    qData: TADQuery;
    Panel5: TADGUIxFormsPanel;
    Panel6: TADGUIxFormsPanel;
    pnlPropertiesSubTitle: TADGUIxFormsPanel;
    pnlDataSubTitle: TADGUIxFormsPanel;
    procedure pcMainChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadData; override;
  end;

var
  frmDbObjDesc: TfrmDbObjDesc;

implementation

{$R *.dfm}

uses
  fDbSetDesc, IniFiles,
  daADStanUtil;

{-----------------------------------------------------------------------------}
{ TADDbObjNode                                                                }
{-----------------------------------------------------------------------------}
constructor TADDbObjNode.Create;
begin
  inherited Create;
  FParams := TStringList.Create;
  FProps := TStringList.Create;
end;

{-----------------------------------------------------------------------------}
destructor TADDbObjNode.Destroy;
begin
  FProps.Free;
  FParams.Free;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
procedure TADDbObjNode.GetParamStack(AStack: TStringList);
var
  i: Integer;
begin
  for i := 0 to FParams.Count - 1 do
    AStack.Add(FParams[i]);
  inherited GetParamStack(AStack);
end;

{-----------------------------------------------------------------------------}
function TADDbObjNode.GetStatus: TADExplorerNodeStatuses;
begin
  Result := inherited GetStatus;
  if ParentNode is TADDbSetNode then
    if TADDbSetNode(ParentNode).ObjTerminal then
      Exclude(Result, nsExpandable);
end;

{-----------------------------------------------------------------------------}
function TADDbObjNode.CreateExpander: TADExplorerNodeExpander;
begin
  Result := TADDbObjNodeExpander.Create(Self);
end;

{-----------------------------------------------------------------------------}
function TADDbObjNode.CreateFrame: TFrame;
begin
  Result := TfrmDbObjDesc.Create(nil);
end;

{-----------------------------------------------------------------------------}
{ TADDbObjNodeExpander                                                        }
{-----------------------------------------------------------------------------}
constructor TADDbObjNodeExpander.Create(ANode: TADExplorerNode);
var
  sVal: String;
  i: Integer;
begin
  inherited Create(ANode);
  FVals := TStringList.Create;
  FValsIndex := 0;
  sVal := GetSubSets(TADDbNode(ANode).ObjTypeName);
  i := 1;
  while i <= Length(sVal) do
    FVals.Add(ADExtractFieldName(sVal, i));
end;

{-----------------------------------------------------------------------------}
destructor TADDbObjNodeExpander.Destroy;
begin
  FVals.Free;
  inherited Destroy;
end;

{-----------------------------------------------------------------------------}
function TADDbObjNodeExpander.GetSubSets(const AParentTypeName: String): String;
var
  oDef: TIniFile;
  i, j: Integer;
  sName, sVal, sRDBMS, sHier: String;
begin
  i := 0;
  Result := '';
  oDef := TADDbNode(Node).GetDef(sRDBMS, sHier);
  try
    while True do begin
      sName := 'Level';
      if i > 0 then
        sName := sName + IntToStr(i);
      sVal := oDef.ReadString(sRDBMS + '.Hierarchy.' + sHier, sName, '');
      if sVal = '' then
        Break;
      j := Pos(AParentTypeName + ':', sVal);
      if j > 0 then begin
        Result := Copy(sVal, j + Length(AParentTypeName) + 1, Length(sVal));
        Break;
      end;
      Inc(i);
    end;
  finally
    oDef.Free;
  end;
end;

{-----------------------------------------------------------------------------}
function TADDbObjNodeExpander.Next: TADExplorerNode;
begin
  if FValsIndex < FVals.Count then begin
    Result := TADDbSetNode.Create(Node, FVals[FValsIndex],
      GetSubSets(FVals[FValsIndex]) = '');
    Inc(FValsIndex);
  end
  else
    Result := nil;
end;

{-----------------------------------------------------------------------------}
{ TfrmDbObjDesc                                                               }
{-----------------------------------------------------------------------------}
procedure TfrmDbObjDesc.LoadData;
var
  i: Integer;
  oPage: TTabSheet;
begin
  with TADDbObjNode(ExplNode).FProps do begin
    sgDef.RowCount := Count + 1;
    sgDef.Cells[0, 0] := 'Property';
    sgDef.Cells[1, 0] := 'Value';
    for i := 0 to Count - 1 do begin
      sgDef.Cells[0, i + 1] := Names[i];
{$IFDEF AnyDAC_D7}
      sgDef.Cells[1, i + 1] := ValueFromIndex[i];
{$ELSE}
      sgDef.Cells[1, i + 1] := Values[Names[i]];
{$ENDIF}
    end;
  end;

  oPage := pcMain.ActivePage;
  if ExplNode.ParentNode is TADDbSetNode then begin
    qData.Disconnect;
    qData.Connection := ExplNode.Connection;
    qData.SQL.Text := TADDbSetNode(ExplNode.ParentNode).DataSQL;
    tsData.TabVisible := (qData.SQL.Text <> '');
  end
  else
    tsData.TabVisible := False;
  if (oPage = nil) or not oPage.TabVisible then
    pcMain.ActivePage := tsDef;
  inherited LoadData;
end;

{-----------------------------------------------------------------------------}
procedure TfrmDbObjDesc.pcMainChange(Sender: TObject);
begin
  inherited pcMainChange(Sender);
  if pcMain.ActivePage = tsData then begin
    qData.Close;
    TADDbObjNode(ExplNode).SetQParams(qData);
    qData.Open;
    SetDS(dsData);
  end
  else if pcMain.ActivePage = tsDef then
    SetDS(nil);
end;

end.
