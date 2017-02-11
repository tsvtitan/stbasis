unit URBToolbutton;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBInterfacePermission = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure MainqrCalcFields(DataSet: TDataSet);
  private
    isFindName,isFindHint,isFindInterface,isFindToolBar,isFindStyle: Boolean;
    FindName,FindHint,FindInterface,FindToolBar: String;
    FindStyle: Integer;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBInterfacePermission: TfmRBInterfacePermission;

  function GetStyleByValue(Value: Integer): string;

implementation

uses UMainUnited, UDesignTsvCode, UDesignTsvDM, UDesignTsvData, UEditRBToolbutton,
     tsvPicture;

{$R *.DFM}

function GetStyleByValue(Value: Integer): string;
begin
  Result:='';
  case Value of
    0: Result:='Кнопка';
    1: Result:='Выбор';
    2: Result:='Выпадающее меню';
    3: Result:='Сепаратор';
    4: Result:='Делитель';
  end;
end;

procedure TfmRBInterfacePermission.FormCreate(Sender: TObject);
var
  cl: TColumn;
  ifl: TIntegerField;
  sfl: TStringField;
  bfl: TBlobField;
begin
 inherited;
 try
  Caption:=NameRbkToolBar;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='toolbutton_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='name';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='hint';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Описание';
  cl.Width:=150;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='shortcut';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='shortcutplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Горячая клавиша';
  cl.Width:=100;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='style';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='styleplus';
  sfl.FieldKind:=fkCalculated;
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Стиль';
  cl.Width:=100;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='interface_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='interfacename';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Интерфейс';
  cl.Width:=100;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='toolbar_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='toolbarname';
  sfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Панель инструментов';
  cl.Width:=100;

  bfl:=TBlobField.Create(nil);
  bfl.FieldName:='image';
  bfl.Visible:=false;
  bfl.DataSet:=Mainqr;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBToolbutton:=nil;
end;

function TfmRBInterfacePermission.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkToolbutton+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBInterfacePermission.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindName or isFindHint or isFindInterface or isFindToolBar or isFindStyle);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('shortcutplus') then fn:='tb.shortcut';
   if AnsiUpperCase(fn)=AnsiUpperCase('styleplus') then fn:='style';
   if AnsiUpperCase(fn)=AnsiUpperCase('toolbarname') then fn:='t.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('interfacename') then fn:='i.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('name') then fn:='tb.name';
   if AnsiUpperCase(fn)=AnsiUpperCase('hint') then fn:='tb.hint';
   id:=MainQr.fieldByName('toolbutton_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('toolbutton_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBInterfacePermission.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindHint:=ReadParam(ClassName,'hint',FindHint);
    FindInterface:=ReadParam(ClassName,'interface',FindInterface);
    FindToolBar:=ReadParam(ClassName,'toolbar',FindToolBar);
    FindStyle:=ReadParam(ClassName,'style',FindStyle);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'hint',FindHint);
    WriteParam(ClassName,'interface',FindInterface);
    WriteParam(ClassName,'toolbar',FindToolBar);
    WriteParam(ClassName,'style',FindStyle);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInterfacePermission.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBInterfacePermission.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBToolbutton;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBToolbutton.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('toolbutton_id',fm.oldtoolbutton_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInterfacePermission.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBToolbutton;
  ms: TMemoryStream;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBToolbutton.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meHint.Lines.Text:=Mainqr.fieldByName('hint').AsString;
    fm.htShortCut.HotKey:=Mainqr.fieldByName('shortcut').AsInteger;
    fm.edToolbar.Text:=Mainqr.fieldByName('toolbarname').AsString;
    fm.toolbar_id:=Mainqr.fieldByName('toolbar_id').AsInteger;
    fm.edInterface.Text:=Mainqr.fieldByName('interfacename').AsString;
    fm.interface_id:=Mainqr.fieldByName('interface_id').AsInteger;
    fm.oldtoolbutton_id:=MainQr.FieldByName('toolbutton_id').AsInteger;
    fm.cmbStyle.ItemIndex:=Mainqr.fieldByName('style').AsInteger;
    TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
    ms.Position:=0;
    TTsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    fm.chbImageStretchClick(nil);

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('toolbutton_id',fm.oldtoolbutton_id,[loCaseInsensitive]);
    end;
  finally
    ms.Free;
    fm.Free;
  end;
end;

procedure TfmRBInterfacePermission.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbToolbutton+' where toolbutton_id='+
          Mainqr.FieldByName('toolbutton_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     
     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('элемент <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBInterfacePermission.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBToolbutton;
  ms: TMemoryStream;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBToolbutton.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meHint.Lines.Text:=Mainqr.fieldByName('hint').AsString;
    fm.htShortCut.HotKey:=Mainqr.fieldByName('shortcut').AsInteger;
    fm.edToolbar.Text:=Mainqr.fieldByName('toolbarname').AsString;
    fm.toolbar_id:=Mainqr.fieldByName('toolbar_id').AsInteger;
    fm.edInterface.Text:=Mainqr.fieldByName('interfacename').AsString;
    fm.interface_id:=Mainqr.fieldByName('interface_id').AsInteger;
    fm.oldtoolbutton_id:=MainQr.FieldByName('toolbutton_id').AsInteger;
    fm.cmbStyle.ItemIndex:=Mainqr.fieldByName('style').AsInteger;
    TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
    ms.Position:=0;
    TTsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    fm.chbImageStretchClick(nil);
    if fm.ShowModal=mrok then begin
    end;
  finally
    ms.Free;
    fm.Free;
  end;
end;

procedure TfmRBInterfacePermission.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBToolbutton;
  filstr: string;
begin
 fm:=TfmEditRBToolbutton.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edToolbar.ReadOnly:=false;
  fm.edToolbar.Color:=clWindow;

  fm.edInterface.ReadOnly:=false;
  fm.edInterface.Color:=clWindow;
  
  fm.lbShortCut.Enabled:=false;
  fm.htShortCut.Enabled:=false;

  fm.bibImageLoad.Enabled:=false;
  fm.bibImageSave.Enabled:=false;
  fm.bibImageCopy.Enabled:=false;
  fm.bibImagePaste.Enabled:=false;
  fm.bibImageClear.Enabled:=false;
  fm.chbImageStretch.Enabled:=false;

  fm.cmbStyle.Style:=csDropDown;
  fm.cmbStyle.ItemIndex:=-1;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindHint)<>'' then fm.meHint.Lines.Text:=FindHint;
  if Trim(FindInterface)<>'' then fm.edInterface.Text:=FindInterface;
  if Trim(FindToolBar)<>'' then fm.edToolbar.Text:=FindToolBar;
  fm.cmbStyle.ItemIndex:=FindStyle;


  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindHint:=Trim(fm.meHint.Lines.Text);
    FindInterface:=Trim(fm.edInterface.Text);
    FindToolBar:=Trim(fm.edToolbar.Text);
    FindStyle:=fm.cmbStyle.Items.IndexOf(fm.cmbStyle.Text);


    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBInterfacePermission.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5: string;
  and1,and2,and3,and4: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindHint:=Trim(FindHint)<>'';
    isFindInterface:=Trim(FindInterface)<>'';
    isFindToolBar:=Trim(FindToolBar)<>'';
    isFindStyle:=FindStyle<>-1;

    if isFindName or isFindHint or isFindInterface or isFindToolBar or isFindStyle then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(tb.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindHint then begin
        addstr2:=' Upper(tb.hint) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHint+'%'))+' ';
     end;

     if isFindInterface then begin
        addstr3:=' Upper(i.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInterface+'%'))+' ';
     end;

     if isFindToolBar then begin
        addstr4:=' Upper(t.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindToolBar+'%'))+' ';
     end;

     if isFindStyle then begin
        addstr5:=' style='+inttostr(FindStyle)+' ';
     end;

     if (isFindName and isFindHint)or
        (isFindName and isFindInterface)or
        (isFindName and isFindToolBar)or
        (isFindName and isFindStyle)  then
      and1:=' and ';

     if (isFindHint and isFindInterface)or
        (isFindHint and isFindToolBar)or
        (isFindHint and isFindStyle)  then
      and2:=' and ';

     if (isFindInterface and isFindToolBar)or
        (isFindInterface and isFindStyle)  then
      and3:=' and ';

     if (isFindToolBar and isFindStyle)  then
      and4:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5;
end;

procedure TfmRBInterfacePermission.MainqrCalcFields(DataSet: TDataSet);
begin
  DataSet['shortcutplus']:=ShortCutToText(DataSet.fieldbyName('shortcut').AsInteger);
  DataSet['styleplus']:=GetStyleByValue(DataSet.fieldbyName('style').AsInteger);
end;

end.
