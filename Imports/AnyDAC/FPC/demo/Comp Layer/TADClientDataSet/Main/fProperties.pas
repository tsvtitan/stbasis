unit fProperties;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, LResources, DBGrids,
    Db, StdCtrls, ComCtrls, Buttons,
  daADStanOption, daADGUIxConsoleWait,
  daADDatSManager,
  daADPhysIntf,
  daADCompDataSet, daADCompClient;

type
  TfrmProperties = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    edtAggs: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ListBox1: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    edtName: TEdit;
    Label5: TLabel;
    edtFields: TEdit;
    cbxPrimary: TCheckBox;
    cbxDesc: TCheckBox;
    cbxUnique: TCheckBox;
    cbxNoCase: TCheckBox;
    cbxNullLess: TCheckBox;
    btnIndAdd: TButton;
    btnIndDel: TButton;
    btnIndMod: TButton;
    btnIndClearAll: TButton;
    Label6: TLabel;
    Label7: TLabel;
    ListBox2: TListBox;
    edtAggName: TEdit;
    cbxAggActive: TCheckBox;
    Label8: TLabel;
    edtAggExp: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    edtAggIndexName: TEdit;
    edtAggGrpLevel: TEdit;
    btnAggAdd: TButton;
    btnAggDel: TButton;
    btnAggMod: TButton;
    btnAggClearAll: TButton;
    Label12: TLabel;
    edtFltExp: TEdit;
    cbxFltNoPartial: TCheckBox;
    cbxFltCaseIns: TCheckBox;
    cbxFltActive: TCheckBox;
    cbxFltFound: TCheckBox;
    btnFltFirst: TButton;
    btnFltPrev: TButton;
    btnFltNext: TButton;
    btnFltLast: TButton;
    Label13: TLabel;
    bntRngSetStart: TButton;
    btnRngEditStart: TButton;
    btnRngSetEnd: TButton;
    btnRngEditEnd: TButton;
    btnRngApply: TButton;
    btnRngClear: TButton;
    TabSheet5: TTabSheet;
    cbxRngStartExclusive: TCheckBox;
    cbxRngEndExclusive: TCheckBox;
    cbxCloneReset: TCheckBox;
    cbxCloneKeepSettings: TCheckBox;
    btnCloneDoit: TButton;
    Label1: TLabel;
    edtInsFields: TEdit;
    Label14: TLabel;
    edtDescFields: TEdit;
    Label15: TLabel;
    edtExpression: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    edtFilter: TEdit;
    lblGroupState: TLabel;
    procedure btnIndAddClick(Sender: TObject);
    procedure btnIndDelClick(Sender: TObject);
    procedure btnIndClearAllClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btnAggAddClick(Sender: TObject);
    procedure btnAggDelClick(Sender: TObject);
    procedure btnAggClearAllClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure btnAggModClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure cbxFltActiveClick(Sender: TObject);
    procedure btnFltFirstClick(Sender: TObject);
    procedure btnFltPrevClick(Sender: TObject);
    procedure btnFltNextClick(Sender: TObject);
    procedure btnFltLastClick(Sender: TObject);
    procedure bntRngSetStartClick(Sender: TObject);
    procedure btnRngEditStartClick(Sender: TObject);
    procedure btnRngSetEndClick(Sender: TObject);
    procedure btnRngEditEndClick(Sender: TObject);
    procedure btnRngApplyClick(Sender: TObject);
    procedure btnRngClearClick(Sender: TObject);
    procedure btnCloneDoitClick(Sender: TObject);
  private
    ADClientDataSet1: TADClientDataSet;
    FDS: TADClientDataSet;
    procedure LoadIndex;
    procedure LoadIndexes;
    procedure LoadAgg;
    procedure LoadAggs;
    procedure SetDS(ADS: TADClientDataSet);
    procedure UpdateFilter;
    procedure GenerateData;
  public
    destructor Destroy; override;
  end;

var
  frmProperties: TfrmProperties;

implementation

Uses Variants;

procedure TfrmProperties.FormCreate(Sender: TObject);
begin
  ADClientDataSet1 := TADClientDataSet.Create(Self);
  ADClientDataSet1.IndexesActive := True;
  ADClientDataSet1.AggregatesActive := True;
  GenerateData;
  SetDS(ADClientDataSet1);
  LoadIndexes;
//  ListBox1.ItemIndex := 0;
//  ListBox1Click(nil);
  LoadAggs;
//  ListBox2.ItemIndex := 0;
//  ListBox2Click(nil);
end;

destructor TfrmProperties.Destroy;
begin
  inherited Destroy;
end;

procedure TfrmProperties.SetDS(ADS: TADClientDataSet);
begin
  FDS := ADS;
  DataSource1.DataSet := FDS;
end;

{------------------------------------------------------------------------------}
{ Indexes                                                                      }
{------------------------------------------------------------------------------}
procedure TfrmProperties.DBGrid1TitleClick(Column: TColumn);
var
  S: String;
  ind: TADIndex;
begin
  S := 'By_' + Column.FieldName;
  with FDS.Indexes do begin
    ind := FindIndex(S);
    if ind = nil then begin
      ind := Add;
      ind.Name := S;
      ind.Fields := Column.FieldName;
      ind.Active := True;
    end
    else begin
      if soDescending in ind.Options then
        ind.Options := ind.Options - [soDescending]
      else
        ind.Options := ind.Options + [soDescending];
    end;
    FDS.IndexName := S;
  end;
  LoadIndexes;
end;

procedure TfrmProperties.btnIndAddClick(Sender: TObject);
var
  opts: TADSortOptions;
begin
  with FDS.Indexes.Add do begin
    Name := edtName.Text;
    if edtFields.Text <> '' then begin
      Fields := edtFields.Text;
      CaseInsFields := edtInsFields.Text;
      DescFields := edtDescFields.Text;
    end
    else if edtExpression.Text <> '' then
      Expression := edtExpression.Text;
    opts := [];
    if cbxPrimary.Checked then
      Include(opts, soPrimary);
    if cbxUnique.Checked then
      Include(opts, soUnique);
    if cbxDesc.Checked then
      Include(opts, soDescending);
    if cbxNoCase.Checked then
      Include(opts, soNoCase);
    if cbxNullLess.Checked then
      Include(opts, soNullLess);
    Options := opts;
    Filter := edtFilter.Text;
    Active := True;
  end;
  LoadIndexes;
end;

procedure TfrmProperties.Edit1Exit(Sender: TObject);
var
  opts: TADSortOptions;
  oInd: TADIndex;
begin
  if ListBox1.ItemIndex > 0 then begin
    oInd := FDS.Indexes.FindIndex(ListBox1.Items[ListBox1.ItemIndex]);
    with oInd do begin
      BeginUpdate;
      Name := edtName.Text;
      if edtFields.Text <> '' then begin
        Fields := edtFields.Text;
        CaseInsFields := edtInsFields.Text;
        DescFields := edtDescFields.Text;
      end
      else if edtExpression.Text <> '' then
        Expression := edtExpression.Text;
      opts := [];
      if cbxPrimary.Checked then
        Include(opts, soPrimary);
      if cbxUnique.Checked then
        Include(opts, soUnique);
      if cbxDesc.Checked then
        Include(opts, soDescending);
      if cbxNoCase.Checked then
        Include(opts, soNoCase);
      if cbxNullLess.Checked then
        Include(opts, soNullLess);
      Options := opts;
      Filter := edtFilter.Text;
      EndUpdate;
    end;
    LoadIndexes;
  end;
end;

procedure TfrmProperties.btnIndDelClick(Sender: TObject);
begin
  if ListBox1.ItemIndex > 0 then
    FDS.Indexes.IndexByName(ListBox1.Items[ListBox1.ItemIndex]).Free;
  LoadIndexes;
end;

procedure TfrmProperties.btnIndClearAllClick(Sender: TObject);
begin
  FDS.Indexes.Clear;
  LoadIndexes;
end;

procedure TfrmProperties.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex > 0 then
    FDS.IndexName := ListBox1.Items[ListBox1.ItemIndex]
  else begin
    FDS.IndexName := '';
    FDS.IndexFieldNames := '';
  end;
end;

procedure TfrmProperties.ListBox1Click(Sender: TObject);
begin
  LoadIndex;
end;

procedure TfrmProperties.LoadIndexes;
var
  i, j: Integer;
begin
  j := ListBox1.ItemIndex;
  ListBox1.Items.Clear;
  ListBox1.Items.Add('<as is>');
  for i := 0 to FDS.Indexes.Count - 1 do
    ListBox1.Items.Add(FDS.Indexes[i].Name);
  if j >= ListBox1.Items.Count then
    j := ListBox1.Items.Count - 1;
  ListBox1.ItemIndex := j;
  LoadIndex;
end;

procedure TfrmProperties.LoadIndex;
begin
  if ListBox1.ItemIndex > 0 then
    with FDS.Indexes.FindIndex(ListBox1.Items[ListBox1.ItemIndex]) do begin
      edtName.Text := Name;
      edtFields.Text := Fields;
      edtInsFields.Text := CaseInsFields;
      edtDescFields.Text := DescFields;
      edtExpression.Text := Expression;
      edtFilter.Text := Filter;
      cbxPrimary.Checked := soPrimary in Options;
      cbxUnique.Checked := soUnique in Options;
      cbxDesc.Checked := soDescending in Options;
      cbxNoCase.Checked := soNoCase in Options;
      cbxNullLess.Checked := soNullLess in Options;
    end
  else begin
    edtName.Text := '';
    edtFields.Text := '';
    edtInsFields.Text := '';
    edtDescFields.Text := '';
    edtExpression.Text := '';
    edtFilter.Text := '';
    cbxPrimary.State := cbGrayed;
    cbxUnique.State := cbGrayed;
    cbxDesc.State := cbGrayed;
    cbxNoCase.State := cbGrayed;
    cbxNullLess.State := cbGrayed;
  end;
end;

{------------------------------------------------------------------------------}
{ Aggregates                                                                   }
{------------------------------------------------------------------------------}
procedure TfrmProperties.btnAggAddClick(Sender: TObject);
begin
  with FDS.Aggregates.Add do begin
    Name := edtAggName.Text;
    Expression := edtAggExp.Text;
    IndexName := edtAggIndexName.Text;
    GroupingLevel := StrToInt(edtAggGrpLevel.Text);
    Active := cbxAggActive.Checked;
  end;
  LoadAggs;
end;

procedure TfrmProperties.btnAggModClick(Sender: TObject);
begin
  if ListBox2.ItemIndex <> -1 then
    with FDS.Aggregates.AggregateByName(ListBox2.Items[ListBox2.ItemIndex]) do begin
      Name := edtAggName.Text;
      Expression := edtAggExp.Text;
      IndexName := edtAggIndexName.Text;
      GroupingLevel := StrToInt(edtAggGrpLevel.Text);
      Active := cbxAggActive.Checked;
      LoadAggs;
    end;
end;

procedure TfrmProperties.btnAggDelClick(Sender: TObject);
begin
  if ListBox2.ItemIndex <> -1 then
    FDS.Aggregates.AggregateByName(ListBox2.Items[ListBox2.ItemIndex]).Free;
  LoadAggs;
end;

procedure TfrmProperties.btnAggClearAllClick(Sender: TObject);
begin
  FDS.Aggregates.Clear;
  LoadAggs;
end;

procedure TfrmProperties.ListBox2Click(Sender: TObject);
begin
  LoadAgg;
end;

procedure TfrmProperties.LoadAggs;
var
  i, j: Integer;
begin
  j := ListBox2.ItemIndex;
  ListBox2.Items.Clear;
  for i := 0 to FDS.Aggregates.Count - 1 do
    ListBox2.Items.Add(FDS.Aggregates[i].Name);
  DataSource1DataChange(nil, nil);
  if j >= ListBox2.Items.Count then
    j := ListBox2.Items.Count - 1;
  ListBox2.ItemIndex := j;
  LoadAgg;
end;

procedure TfrmProperties.LoadAgg;
begin
  if ListBox2.ItemIndex <> -1 then
    with FDS.Aggregates.AggregateByName(ListBox2.Items[ListBox2.ItemIndex]) do begin
      edtAggName.Text := Name;
      edtAggExp.Text := Expression;
      edtAggIndexName.Text := IndexName;
      edtAggGrpLevel.Text := IntToStr(GroupingLevel);
      cbxAggActive.Checked := Active;
    end
  else begin
    edtAggName.Text := '';
    edtAggExp.Text := '';
    edtAggIndexName.Text := '';
    edtAggGrpLevel.Text := '0';
    cbxAggActive.State := cbGrayed;
  end;
end;

procedure TfrmProperties.DataSource1DataChange(Sender: TObject; Field: TField);
var
  i: Integer;
  S, S1: String;
  V: Variant;
  esGrpPos: TGroupPosInds;
begin
  if FDS = nil then
    SetDS(ADClientDataSet1);
  S := '';
  for i := 0 to FDS.Aggregates.Count - 1 do begin
    if S <> '' then
      S := S + '|';
    S := S + ' ' + FDS.Aggregates[i].Name + ' = ';
    V := FDS.Aggregates[i].Value;
    if VarIsNull(V) then
      S := S + 'Null'
    else begin
      S1 := V;
      S := S + S1;
    end;
  end;
  edtAggs.Text := S;
  esGrpPos := FDS.GetGroupState(FDS.GroupingLevel);
  S := '[';
  if gbFirst in esGrpPos then
    S := S + 'S'
  else
    S := S + ' ';
  if gbMiddle in esGrpPos then
    S := S + 'M'
  else
    S := S + ' ';
  if gbLast in esGrpPos then
    S := S + 'L'
  else
    S := S + ' ';
  S := S + ']';
  lblGroupState.Caption := S;
end;

{------------------------------------------------------------------------------}
{ Filtering                                                                    }
{------------------------------------------------------------------------------}
procedure TfrmProperties.UpdateFilter;
var
  opts: TFilterOptions;
begin
  opts := [];
  if cbxFltNoPartial.Checked then
    opts := opts + [foNoPartialCompare];
  if cbxFltCaseIns.Checked then
    opts := opts + [foCaseInsensitive];
  FDS.Filter := edtFltExp.Text;
  FDS.FilterOptions := opts;
end;

procedure TfrmProperties.cbxFltActiveClick(Sender: TObject);
begin
  UpdateFilter;
  FDS.Filtered := cbxFltActive.Checked;
end;

procedure TfrmProperties.btnFltFirstClick(Sender: TObject);
begin
  UpdateFilter;
  cbxFltFound.Checked := FDS.FindFirst;
end;

procedure TfrmProperties.btnFltPrevClick(Sender: TObject);
begin
  UpdateFilter;
  cbxFltFound.Checked := FDS.FindPrior;
end;

procedure TfrmProperties.btnFltNextClick(Sender: TObject);
begin
  UpdateFilter;
  cbxFltFound.Checked := FDS.FindNext;
end;

procedure TfrmProperties.btnFltLastClick(Sender: TObject);
begin
  UpdateFilter;
  cbxFltFound.Checked := FDS.FindLast;
end;

{------------------------------------------------------------------------------}
{ Ranges                                                                       }
{------------------------------------------------------------------------------}
procedure TfrmProperties.bntRngSetStartClick(Sender: TObject);
begin
  FDS.SetRangeStart;
  FDS.KeyExclusive := cbxRngStartExclusive.Checked;
end;

procedure TfrmProperties.btnRngEditStartClick(Sender: TObject);
begin
  FDS.EditRangeStart;
  FDS.KeyExclusive := cbxRngStartExclusive.Checked;
end;

procedure TfrmProperties.btnRngSetEndClick(Sender: TObject);
begin
  FDS.SetRangeEnd;
  FDS.KeyExclusive := cbxRngEndExclusive.Checked;
end;

procedure TfrmProperties.btnRngEditEndClick(Sender: TObject);
begin
  FDS.EditRangeEnd;
  FDS.KeyExclusive := cbxRngEndExclusive.Checked;
end;

procedure TfrmProperties.btnRngApplyClick(Sender: TObject);
begin
  FDS.ApplyRange;
end;

procedure TfrmProperties.btnRngClearClick(Sender: TObject);
begin
  FDS.CancelRange;
end;

{------------------------------------------------------------------------------}
{ Cloning                                                                      }
{------------------------------------------------------------------------------}
procedure TfrmProperties.btnCloneDoitClick(Sender: TObject);
begin
  with TfrmProperties.Create(Application) do begin
    ADClientDataSet1.CloneCursor(Self.ADClientDataSet1,
      cbxCloneReset.Checked, cbxCloneKeepSettings.Checked);
    Show;
  end;
end;

{------------------------------------------------------------------------------}
{ Fill data                                                                    }
{------------------------------------------------------------------------------}
procedure TfrmProperties.GenerateData;
var
  i: Integer;
begin
  with ADClientDataSet1 do begin
    Close;
    FieldDefs.Add('f1', ftInteger);
    FieldDefs.Add('f2', ftString, 30);
    FieldDefs.Add('f3', ftDateTime);
    FieldDefs.Add('f4', ftFloat);
    CreateDataSet;
    for i := 1 to 10 do begin
      Append;
      Fields[0].AsInteger := Random(100);
      Fields[1].AsString := 'q' + Chr(30 + Random(30)) + 'w' + Chr(30 + Random(30));
      Fields[2].AsDateTime := Now;
      Fields[3].AsFloat := Random();
      Post;
    end;
  end;
end;

initialization
  {$I fProperties.lrs}

end.
