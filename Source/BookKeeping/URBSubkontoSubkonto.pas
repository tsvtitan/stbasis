unit URBSubkontoSubkonto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, IBUpdateSQL, tsvDbGrid;

type
  TfmRBSubkontoSubkonto = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
  private
    isFindSub1,isFindSub2,isFindRelField: Boolean;
    FindSub1,FindSub2,FindRelField: String;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBSubkontoSubkonto: TfmRBSubkontoSubkonto;

implementation

uses UMainUnited, UBookKeepingCode, UBookKeepingDM, UBookKeepingData, UEditRBSubkontoSubkonto;

{$R *.DFM}

procedure TfmRBSubkontoSubkonto.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkSubkontoSubkonto;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='subkonto_name';
  cl.Title.Caption:='Субконто1';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='subkonto_name1';
  cl.Title.Caption:='Субконто2';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='ss_relfield';
  cl.Title.Caption:='Связующее поле';
  cl.Width:=180;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSubkontoSubkonto:=nil;
end;

procedure TfmRBSubkontoSubkonto.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  try
   Mainqr.sql.Clear;
   sqls:=GetSQL;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindSub1 or isFindSub2 or isFindRelField);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBSubkontoSubkonto.LoadFromIni;
begin
 inherited;
 try
    FindSub1:=ReadParam(ClassName,'ss_subkonto1',FindSub1);
    FindSub2:=ReadParam(ClassName,'ss_subkonto2',FindSub2);
    FindRelField:=ReadParam(ClassName,'ss_relfield',FindRelField);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.SaveToIni;
begin
 Inherited;
 try
    WriteParam(ClassName,'ss_subkonto1',FindSub1);
    WriteParam(ClassName,'ss_subkonto2',FindSub2);
    WriteParam(ClassName,'ss_relfield',FindRelField);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSubkontoSubkonto.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSubkontoSubkonto;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSubkontoSubkonto.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('ss_subkonto1;ss_subkonto2',VarArrayOf([fm.idSub1,fm.idSub2]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSubkontoSubkonto;
  qr: TIBQuery;
  sqls: string;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBSubkontoSubkonto.Create(nil);
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.idSub1:=Mainqr.fieldByName('ss_subkonto1').AsString;
    fm.idSub2:=Mainqr.fieldByName('ss_subkonto2').AsString;
    fm.RelField:=Mainqr.fieldByName('ss_RelField').AsString;
    sqls := 'select * from '+tbKindSubkonto+' where subkonto_id='+fm.idSub1;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then begin
      fm.LevelTab1:=qr.fieldByName('subkonto_level').AsString;
    end;
    sqls := 'select * from '+tbKindSubkonto+' where subkonto_id='+fm.idSub2;
    qr.SQL.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    if not qr.IsEmpty then begin
      fm.SubTab2:=qr.fieldByName('subkonto_tablename').AsString;
    end;
    fm.ESub1.Text := Mainqr.fieldByName('subkonto_name').AsString;
    fm.ESub2.Text := Mainqr.fieldByName('subkonto_name1').AsString;
    fm.cbRelField.Text := fm.RelField;

    fm.ChangeFlag := false;

    fm.LSub2.Enabled := true;
    fm.ESub2.Enabled := true;
    fm.BSub2.Enabled := true;
    fm.LRelField.Enabled := true;
    fm.cbRelField.Enabled := true;

    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('ss_subkonto1;ss_subkonto2',VarArrayOf([fm.idSub1,fm.idSub2]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
    qr.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbSubkontoSubkonto+
           ' where ss_subkonto1='+ QuotedStr(Mainqr.FieldByName('ss_subkonto1').asString)+
           ' and ss_subkonto2='+QuotedStr(Mainqr.FieldByName('ss_subkonto2').asString);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveQuery(false);
     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
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
  if  Mainqr.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' текущую запись ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,
               'Доступ к приложению <'+Mainqr.FieldByName('taname').AsString+
               '> у пользователя <'+Mainqr.FieldByName('tuname').AsString+'> используется.');
    end;
  end;
end;

procedure TfmRBSubkontoSubkonto.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSubkontoSubkonto;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBSubkontoSubkonto.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;

    fm.ESub1.Text := Mainqr.fieldByName('subkonto_name').AsString;
    fm.ESub2.Text := Mainqr.fieldByName('subkonto_name1').AsString;
    fm.cbRelField.Text := Mainqr.fieldByName('ss_RelField').AsString;;

    fm.LSub2.Enabled := true;
    fm.ESub2.Enabled := true;
    fm.BSub2.Enabled := true;
    fm.LRelField.Enabled := true;
    fm.cbRelField.Enabled := true;
    fm.BSub1.Visible := false;
    fm.BSub2.Visible := false;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSubkontoSubkonto.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSubkontoSubkonto;
  filstr: string;
begin
try
 fm:=TfmEditRBSubkontoSubkonto.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  fm.LSub2.Enabled := true;
  fm.ESub2.Enabled := true;
  fm.BSub2.Enabled := true;
  fm.LRelField.Enabled := true;
  fm.cbRelField.Enabled := true;

  if Trim(FindSub1)<>'' then fm.ESub1.Text:=FindSub1;
  if Trim(FindSub2)<>'' then fm.ESub2.Text:=FindSub2;
  if Trim(FindRelField)<>'' then fm.cbRelField.Text:=FindRelField;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindSub1:=Trim(fm.ESub1.Text);
    FindSub2:=Trim(fm.ESub2.Text);
    FindRelField:=Trim(fm.cbRelField.Text);

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

function TfmRBSubkontoSubkonto.GetFilterString: string;
var
  FilInSide: string;
  wherestr,andstr: string;
  addstr1,addstr2,addstr3: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then begin
      Result := KillWhereFromWhereStr(Result);
      exit;
    end;

    isFindSub1:=Trim(FindSub1)<>'';
    isFindSub2:=Trim(FindSub2)<>'';
    isFindRelField:=Trim(FindRelField)<>'';

    if isFindSub1 or isFindSub2 or isFindRelField then begin
     wherestr:=' and ';
     andstr := ' and '
    end else begin
    end;
    if FilterInside then FilInSide:='%';

     if isFindSub1 then begin
        addstr1:=' Upper(ks1.subkonto_name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSub1+'%'))+' ';
     end;
     if isFindSub2 then begin
        addstr2:=andstr + ' Upper(ks2.subkonto_name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSub2+'%'))+' ';
     end;
     if isFindRelField then begin
        addstr3:=andstr + ' Upper(ss_RelField) like '+AnsiUpperCase(QuotedStr(FilInSide+FindRelField+'%'))+' ';
     end;

     Result:=wherestr+addstr1+addstr2+addstr3;
end;


function TfmRBSubkontoSubkonto.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSubkontoSubkonto+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSubkontoSubkonto.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id1:=MainQr.fieldByName('ss_subkonto1').asString;
   id2:=MainQr.fieldByName('ss_subkonto2').asString;
   if fn= 'SUBKONTO_NAME' then fn := 'KS1.SUBKONTO_NAME';
   if fn= 'SUBKONTO_NAME1' then fn := 'KS2.SUBKONTO_NAME';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('ss_subkonto1;ss_subkonto2',VarArrayOf([id1,id2]),[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.


