unit MPosting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTab, IBDatabase, Db, IBCustomDataSet, IBQuery, Grids, DBGrids,
  ExtCtrls, DBCtrls, StdCtrls, Data,Kassa,IB,WTun,inifiles;

type
  TFMPosting = class(TFTable)
    PHeader: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    PData: TPanel;
    LDok: TLabel;
    LNumDok: TLabel;
    LNumPost: TLabel;
    LDate: TLabel;
    LTime: TLabel;
    LDebit: TLabel;
    LDSub1: TLabel;
    LDSub2: TLabel;
    LDSub3: TLabel;
    LKSub3: TLabel;
    LKSub2: TLabel;
    LKSub1: TLabel;
    LKredit: TLabel;
    LOper: TLabel;
    LPost: TLabel;
    LCount: TLabel;
    LSum: TLabel;
    Label18: TLabel;
    LCur: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure IBTableAfterScroll(DataSet: TDataSet);
    procedure BTunClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMPosting: TFMPosting;

implementation

{$R *.DFM}

procedure TFMPosting.FormCreate(Sender: TObject);
var
   sqls: string;
   cl: TColumn;
   List: TStrings;
begin
inherited;
  try
    List := TStringList.Create;
    ModeView := MView;
    Caption := 'Журнал проводок';
{    IBTable.Database := IBDatabase;
    IBTable.Transaction := IBTransaction;}
    sqls :=  'select DOK_NAME,MP_DOCUMENTID,MP_IDINDOCUMENT,MP_DATE,MP_TIME,P1.PA_GROUPID, '+
             'P2.PA_GROUPID,MP_CONTENTSOPERA,MP_CONTENTSPOSTI,MP_COUNT,MP_SUMMA,MP_DOKUMENT, '+
             'MP_SUBKONTODT1,MP_SUBKONTODT2,MP_SUBKONTODT3,MP_SUBKONTOKT1,MP_SUBKONTOKT2,'+
             'MP_SUBKONTOKT3, MP_DEBETID,MP_CREDITID,MP_CURRENCY_ID '+
             'from MAGAZINEPOSTINGS,PLANACCOUNTS P1, PLANACCOUNTS P2, DOCUMENTS '+
             'where MP_DEBETID=P1.PA_ID AND MP_CREDITID=P2.PA_ID AND MP_DOKUMENT=DOK_ID ';


    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;

    SourceQuery := sqls;

    DBGrid.Columns.Clear;
    cl:=DBGrid.Columns.Add;
    cl.FieldName:='DOK_NAME';
    cl.Title.Caption:='Документ';
    cl.Width:=150;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_DOCUMENTID';
    cl.Title.Caption:='№ док';
    cl.Width:=40;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_IDINDOCUMENT';
    cl.Title.Caption:='№ проводки';
    cl.Width:=40;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_DATE';
    cl.Title.Caption:='Дата';
    cl.Width:=60;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_TIME';
    cl.Title.Caption:='Время';
    cl.Width:=60;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_GROUPID';
    cl.Title.Caption:='Дебет';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='PA_GROUPID1';
    cl.Title.Caption:='Кредит';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_CONTENTSOPERA';
    cl.Title.Caption:='Операция';
    cl.Width:=200;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_CONTENTSPOSTI';
    cl.Title.Caption:='Проводка';
    cl.Width:=70;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_COUNT';
    cl.Title.Caption:='Кол-во';
    cl.Width:=50;

    cl:=DBGrid.Columns.Add;
    cl.FieldName:='MP_SUMMA';
    cl.Title.Caption:='Сумма';
    cl.Width:=100;

{    BFilter.OnClick := BFilterClick; }
    BTun.OnClick := BTunClick;
{    OnDestroy := FormDestroy;
    DBGrid.OnDblClick := DBGridDblClick;

      LoadFromIni;
      List.Add(FindNum);
      List.Add(FindNam);
      List.Add(FindNamAc);
      List.Add(FindCur);
      List.Add(FindAmo);
      List.Add(FindBal);
      List.Add(FindSaldo);
      List.Add(FindSub1);
      List.Add(FindSub2);
      List.Add(FindSub3);
      sqls := CompareQuery(List);

    IBTable.SQL.Clear;
    IBTable.SQL.Add(sqls);
    IBTable.Active := True;
    List.free;     }
    MView := false;
  except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFMPosting.FormResize(Sender: TObject);
begin
  BAdd.Left := Width - 88;
  BEdit.Left := Width - 88;
  BDel.Left := Width - 88;
  BRef.Top := BAdd.Top;
  BRef.Left := Width - 88;
  BAcc.Left := Width - 88;
  BFilter.Top := BEdit.Top;
  BFilter.Left := Width - 88;
  BTun.Top := BDel.Top;
  BTun.Left := Width - 88;
  BClose.Left := Width - 88;
  BClose.Top := Height - 54;
  DBGrid.Width := Width - 105;
  DBGrid.Height := Height - 218;
  EFind.Width := Width - 150;
  DBNavigator.Top := Height - 50;
  LSelect.Top := Height - 48;
  PHeader.Top := Height - 184;
  PData.Top := Height - 124;
  PHeader.Width := DBGrid.Width;
  PData.Width := DBGrid.Width;
end;

procedure TFMPosting.IBTableAfterScroll(DataSet: TDataSet);
var
  qr: TIBQuery;
  sqls: string;
  Sub,ValSub: TStrings;
begin
inherited;
try
  qr := TIBQuery.Create(nil);
  qr.Database:=Form1.IBDatabase;
  qr.Transaction:=Form1.IBTransaction;
  qr.Transaction.Active:=true;
  Sub := TStringList.Create;
  ValSub := TStringList.Create;
  LDok.Caption := '';
  LNumDok.Caption := '';
  LNumPost.Caption := '';
  LDate.Caption := '';
  LTime.Caption := '';
  LDebit.Caption := '';
  LKredit.Caption := '';
  LDSub1.Caption := '';
  LDSub2.Caption := '';
  LDSub3.Caption := '';
  LKSub1.Caption := '';
  LKSub2.Caption := '';
  LKSub3.Caption := '';
  LOper.Caption := '';
  LPost.Caption := '';
  LCount.Caption := '';
  LSum.Caption := '';
  LCur.Caption := '';
  try
    if Trim(IBTable.FieldByName('MP_CURRENCY_ID').AsString)<>'' then begin
      sqls := 'Select * from CURRENCY where CURRENCY_ID='+Trim(IBTable.FieldByName('MP_CURRENCY_ID').AsString);
      qr.SQL.Add(sqls);
      qr.Open;
      if not qr.IsEmpty then
        LCur.Caption := Trim(qr.FieldByName('SHORTNAME').AsString);
    end;
    LDok.Caption := Trim(IBTable.FieldByName('DOK_NAME').AsString);
    LNumDok.Caption := Trim(IBTable.FieldByName('MP_DOCUMENTID').AsString);
    LNumPost.Caption := Trim(IBTable.FieldByName('MP_IDINDOCUMENT').AsString);
    LDate.Caption := Trim(IBTable.FieldByName('MP_DATE').AsString);
    LTime.Caption := Trim(IBTable.FieldByName('MP_TIME').AsString);
    LDebit.Caption := Trim(IBTable.FieldByName('PA_GROUPID').AsString);
    LKredit.Caption := Trim(IBTable.FieldByName('PA_GROUPID1').AsString);
    LOper.Caption := Trim(IBTable.FieldByName('MP_CONTENTSOPERA').AsString);
    LPost.Caption := Trim(IBTable.FieldByName('MP_CONTENTSPOSTI').AsString);
    LSum.Caption := Trim(IBTable.FieldByName('MP_SUMMA').AsString);
    if (Trim(IBTable.FieldByName('MP_SUBKONTODT1').AsString)<>'') and
       (Trim(IBTable.FieldByName('MP_SUBKONTODT1').AsString)<>'0') then
      Sub.Add(Trim(IBTable.FieldByName('MP_SUBKONTODT1').AsString));
    if (Trim(IBTable.FieldByName('MP_SUBKONTODT2').AsString)<>'') and
       (Trim(IBTable.FieldByName('MP_SUBKONTODT2').AsString)<>'0') then
      Sub.Add(Trim(IBTable.FieldByName('MP_SUBKONTODT2').AsString));
    if (Trim(IBTable.FieldByName('MP_SUBKONTODT3').AsString)<>'') and
       (Trim(IBTable.FieldByName('MP_SUBKONTODT3').AsString)<>'0') then
      Sub.Add(Trim(IBTable.FieldByName('MP_SUBKONTODT3').AsString));
    ValSub := TakeFromSubkonto(Trim(IBTable.FieldByName('MP_DEBETID').AsString),Sub);
    if ValSub.Count>0 then
      LDSub1.Caption := ValSub[0];
    if ValSub.Count>1 then
      LDSub2.Caption := ValSub[1];
    if ValSub.Count>2 then
      LDSub3.Caption := ValSub[2];
    Sub.Clear;
    ValSub.Clear;
    if (Trim(IBTable.FieldByName('MP_SUBKONTOKT1').AsString)<>'') and
       (Trim(IBTable.FieldByName('MP_SUBKONTOKT1').AsString)<>'0') then
      Sub.Add(Trim(IBTable.FieldByName('MP_SUBKONTOKT1').AsString));
    if (Trim(IBTable.FieldByName('MP_SUBKONTOKT2').AsString)<>'') and
       (Trim(IBTable.FieldByName('MP_SUBKONTOKT2').AsString)<>'0') then
      Sub.Add(Trim(IBTable.FieldByName('MP_SUBKONTOKT2').AsString));
    if (Trim(IBTable.FieldByName('MP_SUBKONTOKT3').AsString)<>'') and
       (Trim(IBTable.FieldByName('MP_SUBKONTOKT3').AsString)<>'0') then
      Sub.Add(Trim(IBTable.FieldByName('MP_SUBKONTOKT3').AsString));
    ValSub := TakeFromSubkonto(Trim(IBTable.FieldByName('MP_CREDITID').AsString),Sub);
    if ValSub.Count>0 then
      LKSub1.Caption := ValSub[0];
    if ValSub.Count>1 then
      LKSub2.Caption := ValSub[1];
    if ValSub.Count>2 then
      LKSub3.Caption := ValSub[2];
    LDok.Hint := LDok.Caption;
    LNumDok.Hint := LNumDok.Caption;
    LNumPost.Hint := LNumPost.Caption;
    LDate.Hint := LDate.Caption;
    LTime.Hint := LTime.Caption;
    LDebit.Hint := LDebit.Caption;
    LKredit.Hint := LKredit.Caption;
    LDSub1.Hint := LDSub1.Caption;
    LDSub2.Hint := LDSub2.Caption;
    LDSub3.Hint := LDSub3.Caption;
    LKSub1.Hint := LKSub1.Caption;
    LKSub2.Hint := LKSub2.Caption;
    LKSub3.Hint := LKSub3.Caption;
    LOper.Hint := LOper.Caption;
    LPost.Hint := LPost.Caption;
    LCount.Hint := LCount.Caption;
    LSum.Hint := LSum.Caption;
    LCur.Hint := LCur.Caption;
  finally
    qr.free;
    Sub.Free;
    ValSub.Free;
  end;
except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
end;
end;

procedure TFMPosting.BTunClick(Sender: TObject);
var
  fm: TFTuning;
  i,j,Id,m: integer;
begin
  try
    fm := TFTuning.Create(nil);
    Id := 0;
    try
      fm.CLBFields.Items.Clear;
      for i:=0 to DBGrid.Columns.Count-1 do begin
        fm.CLBFields.Items.Add(DBGrid.Columns.Items[i].Title.Caption);
        fm.CLBFields.Checked[i] := DBGrid.Columns.Items[i].Visible;
      end;
      if fm.ShowModal=mrOk then
      for i:=0 to DBGrid.Columns.Count-1 do begin
        for j:=0 to DBGrid.Columns.Count-1 do begin
          if DBGrid.Columns.Items[j].Title.Caption=TempList[i*2] then
            Id := DBGrid.Columns.Items[j].ID;
        end;
        DBGrid.Columns.FindItemId(Id).Index := i;
        if TempList[i*2+1]='Yes' then
          DBGrid.Columns.Items[i].Visible := true
        else
          DBGrid.Columns.Items[i].Visible := false;
      end;
    finally
      fm.free;
      ActivateQuery;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

end.
