unit URBKindSubkonto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, IBUpdateSQL, tsvDbGrid;

type
  TfmRBKindSubkonto = class(TfmRBMainGrid)
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
    isFindSubkonto_Name,isFindSubkonto_TableName,isFindSubkonto_FieldWithId,
    isFindSubkonto_FieldWithText,isFindSubkonto_NameInterface: Boolean;
    FindSubkonto_Name,FindSubkonto_TableName,FindSubkonto_FieldWithId,
    FindSubkonto_FieldWithText,FindSubkonto_NameInterface: String;
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
  fmRBKindSubkonto: TfmRBKindSubkonto;

implementation

uses UMainUnited, UBookKeepingCode, UBookKeepingDM, UBookKeepingData, UEditRBKindSubkonto;

{$R *.DFM}

procedure TfmRBKindSubkonto.FormCreate(Sender: TObject);
var
 cl: TColumn;
// Inf:
begin
 inherited;
 try
  Caption:=NameRbkKindSubkonto;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='Subkonto_name';
  cl.Title.Caption:='Наименование';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='Subkonto_nameinterface';
  cl.Title.Caption:='Интерфейс';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='Subkonto_tablename';
  cl.Title.Caption:='Таблица';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='Subkonto_fieldwithid';
  cl.Title.Caption:='Поле с ИД';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='Subkonto_fieldwithtext';
  cl.Title.Caption:='Поле с содержанием';
  cl.Width:=180;

//  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBKindSubkonto:=nil;
end;

procedure TfmRBKindSubkonto.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindSubkonto_Name or isFindSubkonto_TableName or isFindSubkonto_FieldWithId
                    or isFindSubkonto_FieldWithText or isFindSubkonto_NameInterface);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBKindSubkonto.LoadFromIni;
begin
 inherited;
 try
   FindSubkonto_Name:=ReadParam(ClassName,'Subkonto_Name',FindSubkonto_Name);
   FindSubkonto_TableName:=ReadParam(ClassName,'Subkonto_TableName',FindSubkonto_TableName);
   FindSubkonto_FieldWithId:=ReadParam(ClassName,'Subkonto_FieldWithId',FindSubkonto_FieldWithId);
   FindSubkonto_FieldWithText:=ReadParam(ClassName,'Subkonto_FieldWithText',FindSubkonto_FieldWithText);
   FindSubkonto_NameInterface:=ReadParam(ClassName,'Subkonto_NameInterface',FindSubkonto_NameInterface);
   FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.SaveToIni;
begin
 Inherited;
 try
   WriteParam(ClassName,'Subkonto_Name',FindSubkonto_Name);
   WriteParam(ClassName,'Subkonto_TableName',FindSubkonto_TableName);
   WriteParam(ClassName,'Subkonto_FieldWithId',FindSubkonto_FieldWithId);
   WriteParam(ClassName,'Subkonto_FieldWithText',FindSubkonto_FieldWithText);
   WriteParam(ClassName,'Subkonto_NameInterface',FindSubkonto_NameInterface);
   WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBKindSubkonto.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBKindSubkonto;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBKindSubkonto.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('subkonto_name',Trim(fm.EName.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBKindSubkonto;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBKindSubkonto.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.subkonto_id:=Mainqr.fieldByName('subkonto_id').AsInteger;
    fm.EName.Text:=Mainqr.fieldByName('subkonto_name').AsString;
    fm.cmbInterfaces.Text:=Mainqr.fieldByName('subkonto_nameinterface').AsString;
    fm.CBTable.Text:=Mainqr.fieldByName('subkonto_tablename').AsString;
    fm.CBFieldWithId.Text:=Mainqr.fieldByName('subkonto_fieldwithid').AsString;
    fm.CBFieldWithText.Text:=Mainqr.fieldByName('subkonto_fieldwithtext').AsString;
    if (fm.CBTable.Text<>'') then begin
      IBDB.GetFieldNames(Trim(fm.CBTable.Text),fm.CBFieldWithId.Items);
      fm.CBFieldWithText.Items:=fm.CBFieldWithId.Items;
    end;
    fm.ChangeFlag := false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('subkonto_name',Trim(fm.EName.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbKindSubkonto+
           ' where subkonto_id='+ QuotedStr(Mainqr.FieldByName('subkonto_id').asString);
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Active:=true;
     sqls := 'Drop trigger '+Mainqr.FieldByName('subkonto_tablename').asString+
             '_BD0Kassa';
     qr.SQL.Clear;
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

procedure TfmRBKindSubkonto.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBKindSubkonto;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBKindSubkonto.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.subkonto_id:=Mainqr.fieldByName('subkonto_id').AsInteger;
    fm.EName.Text:=Mainqr.fieldByName('subkonto_name').AsString;
    fm.cmbInterfaces.Text:=Mainqr.fieldByName('subkonto_nameinterface').AsString;
    fm.CBTable.Text:=Mainqr.fieldByName('subkonto_tablename').AsString;
    fm.CBFieldWithId.Text:=Mainqr.fieldByName('subkonto_fieldwithid').AsString;
    fm.CBFieldWithText.Text:=Mainqr.fieldByName('subkonto_fieldwithtext').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKindSubkonto.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBKindSubkonto;
  filstr: string;
begin
try
 fm:=TfmEditRBKindSubkonto.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;
//  fm.Edit.Color:=clWindow;
//  fm.Edit.ReadOnly:=false;

  if Trim(FindSubkonto_Name)<>'' then fm.EName.Text:=FindSubkonto_Name;
  if Trim(FindSubkonto_TableName)<>'' then fm.CBTable.Text:=FindSubkonto_TableName;
  if Trim(FindSubkonto_FieldWithId)<>'' then fm.CBFieldWithId.Text:=FindSubkonto_FieldWithId;
  if Trim(FindSubkonto_FieldWithText)<>'' then fm.CBFieldWithText.Text:=FindSubkonto_FieldWithText;
  if Trim(FindSubkonto_NameInterface)<>'' then fm.cmbInterfaces.Text:=FindSubkonto_NameInterface;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindSubkonto_Name := Trim(fm.EName.Text);
    FindSubkonto_TableName := Trim(fm.CBTable.Text);
    FindSubkonto_FieldWithId := Trim(fm.CBFieldWithId.Text);
    FindSubkonto_FieldWithText := Trim(fm.CBFieldWithText.Text);
    FindSubkonto_NameInterface := Trim(fm.cmbInterfaces.Text);

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

function TfmRBKindSubkonto.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,
  and1,and2,and3,and4,and5: string;
begin
    Result := inherited GetFilterString;
    if Trim(Result)<>'' then begin
      exit;
    end;

    isFindSubkonto_Name:=Trim(FindSubkonto_Name)<>'';
    isFindSubkonto_TableName:=Trim(FindSubkonto_TableName)<>'';
    isFindSubkonto_FieldWithId:=Trim(FindSubkonto_FieldWithId)<>'';
    isFindSubkonto_FieldWithText:=Trim(FindSubkonto_FieldWithText)<>'';
    isFindSubkonto_NameInterface:=Trim(FindSubkonto_NameInterface)<>'';

    if isFindSubkonto_Name or isFindSubkonto_TableName or isFindSubkonto_FieldWithId or
       isFindSubkonto_FieldWithText or isFindSubkonto_NameInterface then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindSubkonto_Name then begin
        addstr1:=' Upper(subkonto_name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSubkonto_Name+'%'))+' ';
     end;
     if isFindSubkonto_TableName then begin
        addstr2:=' Upper(subkonto_tablename) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSubkonto_TableName+'%'))+' ';
     end;
     if isFindSubkonto_FieldWithId then begin
        addstr3:=' Upper(subkonto_fieldwithid) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSubkonto_FieldWithId+'%'))+' ';
     end;
     if isFindSubkonto_FieldWithText then begin
        addstr4:=' Upper(subkonto_fieldwithtext) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSubkonto_FieldWithText+'%'))+' ';
     end;
     if isFindSubkonto_NameInterface then begin
        addstr5:=' Upper(subkonto_nameinterface) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSubkonto_NameInterface+'%'))+' ';
     end;
     if isFindSubkonto_Name and isFindSubkonto_TableName then
       and1 := ' AND ';
     if isFindSubkonto_FieldWithId and (isFindSubkonto_Name or isFindSubkonto_TableName) then
       and2 := ' AND ';
     if isFindSubkonto_FieldWithText and (isFindSubkonto_FieldWithId or isFindSubkonto_Name or isFindSubkonto_TableName) then
       and3 := ' AND ';
     if isFindSubkonto_NameInterface and (isFindSubkonto_FieldWithId or isFindSubkonto_Name or isFindSubkonto_TableName
        or isFindSubkonto_FieldWithText) then
       and4 := ' AND ';
     Result:=wherestr+addstr1+and1+addstr2+and2+addstr3+and3+addstr4+and4+addstr5;
end;

function TfmRBKindSubkonto.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkKindSubkonto+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBKindSubkonto.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('subkonto_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('subkonto_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
