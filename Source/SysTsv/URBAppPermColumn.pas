unit URBAppPermColumn;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBAppPermColumn = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindAppName,isFindObj,isFindCol,isFindPerm: Boolean;
    FindAppName,FindObj,FindCol,FindPerm: String;
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
  fmRBAppPermColumn: TfmRBAppPermColumn;

implementation

uses UMainUnited, USysTsvCode, USysTsvDM, USysTsvData, UEditRBAppPermColumn;

{$R *.DFM}

procedure TfmRBAppPermColumn.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkAppPermColumn;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='appname';
  cl.Title.Caption:='Приложение';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='obj';
  cl.Title.Caption:='Обьект';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='col';
  cl.Title.Caption:='Колонка';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='perm';
  cl.Title.Caption:='Право';
  cl.Width:=100;
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBAppPermColumn:=nil;
end;

function TfmRBAppPermColumn.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkAppPermColumn+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBAppPermColumn.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindAppName or isFindObj or isFindCol or isFindPerm);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('apppermcolumn_id').asString;
   if UpperCase(fn)=UpperCase('appname') then fn:='a.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('apppermcolumn_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBAppPermColumn.LoadFromIni;
begin
 inherited;
 try
    FindAppName:=ReadParam(ClassName,'appname',FindAppName);
    FindObj:=ReadParam(ClassName,'obj',FindObj);
    FindCol:=ReadParam(ClassName,'col',FindCol);
    FindPerm:=ReadParam(ClassName,'perm',FindPerm);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'appname',FindAppName);
    WriteParam(ClassName,'obj',FindObj);
    WriteParam(ClassName,'col',FindCol);
    WriteParam(ClassName,'perm',FindPerm);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBAppPermColumn.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBAppPermColumn;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBAppPermColumn.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('apppermcolumn_id',fm.oldapppermcolumn_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBAppPermColumn;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAppPermColumn.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edApp.Text:=Mainqr.fieldByName('appname').AsString;
    fm.app_id:=Mainqr.fieldByName('app_id').AsInteger;
    fm.oldapppermcolumn_id:=MainQr.FieldByName('apppermcolumn_id').AsInteger;
    fm.cmbObj.ItemIndex:=fm.cmbObj.Items.IndexOf(Mainqr.fieldByName('obj').AsString);
    fm.edObjChange(nil);
    fm.cmbColumn.ItemIndex:=fm.cmbColumn.Items.IndexOf(Mainqr.fieldByName('col').AsString);
    fm.cmbPerm.ItemIndex:=fm.cmbPerm.Items.IndexOf(Mainqr.fieldByName('perm').AsString);
    fm.cmbPermChange(nil);
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('apppermcolumn_id',fm.oldapppermcolumn_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbAppPermColumn+' where apppermcolumn_id='+
          Mainqr.FieldByName('apppermcolumn_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveQuery(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('текущее право на колонку <'+Mainqr.FieldByName('col').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBAppPermColumn.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBAppPermColumn;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBAppPermColumn.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edApp.Text:=Mainqr.fieldByName('appname').AsString;
    fm.app_id:=Mainqr.fieldByName('app_id').AsInteger;
    fm.oldapppermcolumn_id:=MainQr.FieldByName('apppermcolumn_id').AsInteger;
    fm.cmbObj.ItemIndex:=fm.cmbObj.Items.IndexOf(Mainqr.fieldByName('obj').AsString);
    fm.edObjChange(nil);
    fm.cmbColumn.ItemIndex:=fm.cmbColumn.Items.IndexOf(Mainqr.fieldByName('col').AsString);
    fm.cmbPerm.ItemIndex:=fm.cmbPerm.Items.IndexOf(Mainqr.fieldByName('perm').AsString);
    fm.cmbPermChange(nil);
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBAppPermColumn.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBAppPermColumn;
  filstr: string;
begin
 try
  fm:=TfmEditRBAppPermColumn.Create(nil);
  try
   fm.TypeEditRBook:=terbFilter;
   fm.edApp.ReadOnly:=false;
   fm.edApp.Color:=clWindow;

   fm.cmbPerm.ItemIndex:=-1;
   fm.cmbPerm.Style:=csDropDown;
   fm.cmbObj.Style:=csDropDown;
   fm.cmbColumn.Style:=csDropDown;

   if Trim(FindAppName)<>'' then fm.edApp.Text:=FindAppName;
   if Trim(FindObj)<>'' then fm.cmbObj.Text:=FindObj;
   if Trim(FindCol)<>'' then fm.cmbColumn.Text:=FindCol;
   if Trim(FindPerm)<>'' then begin
    fm.cmbPerm.Text:=FindPerm;
   end;

   fm.cbInString.Checked:=FilterInSide;

   fm.ChangeFlag:=false;

   if fm.ShowModal=mrOk then begin

    inherited;

    FindAppName:=Trim(fm.edApp.Text);
    FindObj:=Trim(fm.cmbObj.Text);
    FindCol:=Trim(fm.cmbColumn.Text);
    FindPerm:=Trim(fm.cmbperm.Text);

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

function TfmRBAppPermColumn.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindAppName:=Trim(FindAppName)<>'';
    isFindObj:=Trim(FindObj)<>'';
    isFindCol:=Trim(FindCol)<>'';
    isFindPerm:=Trim(FindPerm)<>'';

    if isFindAppName or isFindObj or isFindCol or isFindPerm then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindAppName then begin
        addstr1:=' Upper(a.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAppName+'%'))+' ';
     end;

     if isFindObj then begin
        addstr2:=' Upper(obj) like '+AnsiUpperCase(QuotedStr(FilInSide+FindObj+'%'))+' ';
     end;

     if isFindCol then begin
        addstr3:=' Upper(col) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCol+'%'))+' ';
     end;

     if isFindPerm then begin
        addstr4:=' Upper(perm) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPerm+'%'))+' ';
     end;

     if (isFindAppName and isFindObj)or
        (isFindAppName and isFindCol)or
        (isFindAppName and isFindPerm)
        then and1:=' and ';

     if (isFindObj and isFindCol)or
        (isFindObj and isFindPerm)
        then and2:=' and ';

     if (isFindCol and isFindPerm)
        then and3:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4;
end;


end.
