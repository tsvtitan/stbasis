unit fProperties;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, StdCtrls, ComCtrls, Buttons,
{$IFDEF APR}
  gsAPRRunner,
{$ENDIF}
  DBClient,
  DBTables,
  daADDatSManager, daADStanIntf, daADStanParam,
  daADPhysIntf,
  daADDAptIntf,
  daADCompDataSet, daADCompClient, daADStanOption;

type
  TfrmProperties = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    edtAggs: TEdit;
    ADClientDataSet1: TADClientDataSet;
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
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
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
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    FDS: TADClientDataSet;
{$IFDEF APR}
    APRCreator1: TAPRCreatorGS;
    APRPlayer1: TAPRPlayerGS;
{$ENDIF}
    procedure LoadIndex;
    procedure LoadIndexes;
    procedure LoadAgg;
    procedure LoadAggs;
    procedure SetDS(ADS: TADClientDataSet);
    procedure UpdateFilter;
    procedure AssignData(ACDS: TClientDataSet);
    procedure GenerateData;
  public
    { Public declarations }
    procedure LoadClientDataSet(FileName: String; ACDS: TClientDataSet);
    destructor Destroy; override;
  end;

var
  frmProperties: TfrmProperties;

implementation

Uses Variants;

{$R *.DFM}

procedure TfrmProperties.FormCreate(Sender: TObject);
begin
  ADClientDataSet1.IndexesActive := True;
  ADClientDataSet1.AggregatesActive := True;
  SetDS(ADClientDataSet1);
  LoadIndexes;
  ListBox1.ItemIndex := 1;
  ListBox1Click(nil);
  LoadAggs;
  ListBox2.ItemIndex := 0;
  ListBox2Click(nil);
{$IFDEF APR}
  APRCreator1 := TAPRCreatorGS.Create(Self);
  APRPlayer1 := TAPRPlayerGS.Create(Self);
  with APRPlayer1 do begin
    AtOpenFileName := 'I_A_Add.XML';
    AtOpenRunning := True;
  end;
{$ELSE}
  SpeedButton1.Enabled := False;
  SpeedButton2.Enabled := False;
{$ENDIF}
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

procedure TfrmProperties.SpeedButton1Click(Sender: TObject);
begin
{$IFDEF APR}
  APRCreator1.Open;
{$ENDIF}
end;

procedure TfrmProperties.SpeedButton2Click(Sender: TObject);
begin
{$IFDEF APR}
  APRPlayer1.Open;
{$ENDIF}
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
  oTable: TTable;
  i: Integer;
begin
  oTable := TTable.Create(nil);
  with oTable do begin
    DatabaseName := 'DBDEMOS';
    TableName := 'country.db';
    Open;
  end;
  with ADClientDataSet1 do begin
    Close;
    FieldDefs.Assign(oTable.FieldDefs);
    IndexDefs.Assign(oTable.IndexDefs);
    CreateDataSet;
  end;
  while not oTable.EOF do begin
    ADClientDataSet1.Append;
    for i := 0 to oTable.FieldCount - 1 do
      ADClientDataSet1.Fields[i].Assign(oTable.Fields[i]);
    ADClientDataSet1.Post;
    oTable.Next;
  end;
end;

type
  __TClientDataSet = class(TClientDataSet)
  public
    procedure UpdateFieldDefs;
  end;

procedure __TClientDataSet.UpdateFieldDefs;
begin
  FieldDefs.BeginUpdate;
  try
    FieldDefs.Clear;
    InitFieldDefsFromFields;
  finally
    FieldDefs.EndUpdate;
  end;
end;

procedure TfrmProperties.AssignData(ACDS: TClientDataSet);

  procedure CopyDSData(AADDS: TADDataSet; ACDS: TClientDataSet);
  var
    i: Integer;
  begin
    ACDS.First;
    while not ACDS.EOF do begin
      AADDS.Append;
      for i := 0 to ACDS.FieldCount - 1 do
        if ACDS.Fields[i].DataType = ftDataSet then
          CopyDSData(TADDataSet(TDataSetField(AADDS.Fields[i]).NestedDataSet),
            TClientDataSet(TDataSetField(ACDS.Fields[i]).NestedDataSet))
        else
          AADDS.Fields[i].Assign(ACDS.Fields[i]);
      AADDS.Post;
      ACDS.Next;
    end;
  end;

begin
  ADClientDataSet1.DisableControls;
  ACDS.DisableControls;
  try
    with ADClientDataSet1 do begin
      Close;
      __TClientDataSet(ACDS).UpdateFieldDefs;
      FieldDefs.Assign(ACDS.FieldDefs);
      IndexDefs.Assign(ACDS.IndexDefs);
      CreateDataSet;
    end;
    CopyDSData(ADClientDataSet1, ACDS);
    ADClientDataSet1.First;
  finally
    ADClientDataSet1.EnableControls;
    ACDS.EnableControls;
  end;
end;

procedure TfrmProperties.LoadClientDataSet(FileName: String;
  ACDS: TClientDataSet);
begin
  ADClientDataSet1.Close;
  ADClientDataSet1.IndexFieldNames := '';
  ADClientDataSet1.IndexName := '';
  ADClientDataSet1.Filtered := False;
  ADClientDataSet1.Filter := '';
  if FileName <> '' then begin
    // ???  ADClientDataSet1.FileName := FileName;
  end
  else if ACDS <> nil then
    AssignData(ACDS)
  else
    GenerateData;
  ADClientDataSet1.Open;
end;

end.
