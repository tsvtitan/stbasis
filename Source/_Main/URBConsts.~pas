unit URBConsts;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL, grids;

type
   TfmRBConst = class(TfmRBMainGrid)
    Button1: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindValue,isFindNote: Boolean;
    FindName,FindValue,FindNote: String;
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                     DataCol: Integer; Column: TColumn; State: TGridDrawState);

  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    function SetValuesToEditForm(TypeSetValuesToEditForm: TTypeSetValuesToEditForm): Boolean; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBConst: TfmRBConst;

implementation

uses UMainUnited, UMainCode,  UMainData, UEditRBConsts, tsvInterbase;

{$R *.DFM}

procedure TfmRBConst.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkConst;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='valueview';
  cl.Title.Caption:='Отображаемое значение';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='note';
  cl.Title.Caption:='Описание';
  cl.Width:=150;

  if isPermissionColumn_(tbConstEx,'consttype',SelConst) then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='consttypeplus';
   cl.Title.Caption:='Тип константы';
   cl.Width:=100;
  end;

  if isPermissionColumn_(tbConstEx,'tablename',SelConst) then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='tablename';
   cl.Title.Caption:='Имя таблицы';
   cl.Width:=100;
  end; 

  if isPermissionColumn_(tbConstEx,'fieldname',SelConst) then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='fieldname';
   cl.Title.Caption:='Имя поля';
   cl.Width:=100;
  end; 

  if isPermissionColumn_(tbConstEx,'valuetable',SelConst) then begin
   cl:=Grid.Columns.Add;
   cl.FieldName:='valuetable';
   cl.Title.Caption:='Значение';
   cl.Width:=100;
  end;

  Grid.OnDrawColumnCell:=GridDrawColumnCell;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBConst:=nil;
end;

function TfmRBConst.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkConst+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBConst.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindValue or isFindNote);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('constex_id').asString;
   if AnsiUpperCase(fn)=AnsiUpperCase('consttypeplus') then fn:='consttype';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('constex_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBConst.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindValue:=ReadParam(ClassName,'value',FindValue);
    FindNote:=ReadParam(ClassName,'note',FindNote);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'value',FindValue);
    WriteParam(ClassName,'note',FindNote);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBConst.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBConsts;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBConsts.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.FillCmbObj;
    fm.FillCmbColumn;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('constex_id',fm.oldconstex_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBConsts;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBConsts.Create(nil);
  try
    EditForm:=fm;
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbChange;
    SetValuesToEditForm(tefNone);
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('constex_id',fm.oldconstex_id,[loCaseInsensitive]);
    end;
  finally
    EditForm:=nil;
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;

    function DropTriggers: Boolean;
    begin
     result:=false;
     try
      ExecSql(IBDB,'Drop trigger '+GetBeforeDeleteTriggerName(Mainqr.FieldByName('name').asString,
                                                         Mainqr.FieldByName('valueview').asString,
                                                         Mainqr.FieldByName('tablename').asString,
                                                         Mainqr.FieldByName('fieldname').asString));
      Result:=true;
     except
     end;
    end;

  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbConstEx+' where constex_id='+
          Mainqr.FieldByName('constex_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     if Mainqr.FieldByName('consttype').AsInteger=1 then
       DropTriggers;
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
  but:=DeleteWarningEx('константу <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBConst.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBConsts;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBConsts.Create(nil);
  try
    EditForm:=fm;
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbView;
    SetValuesToEditForm(tefNone);

    if fm.ShowModal=mrok then begin
    end;
  finally
    EditForm:=nil;
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBConst.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBConsts;
  filstr: string;
begin
 try
  fm:=TfmEditRBConsts.Create(nil);
  try
   fm.TypeEditRBook:=terbFilter;

   fm.lbType.Enabled:=false;
   fm.cmbType.ItemIndex:=-1;
   fm.cmbType.Enabled:=false;
   fm.cmbType.Color:=clBtnFace;

   if Trim(FindName)<>'' then fm.edName.Text:=FindName;
   if Trim(FindValue)<>'' then fm.edValueView.Text:=FindValue;
   if Trim(FindNote)<>'' then fm.meAbout.Lines.Text:=FindNote;

   fm.cbInString.Checked:=FilterInSide;

   fm.ChangeFlag:=false;

   if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindValue:=Trim(fm.edValueView.Text);
    FindNote:=Trim(fm.meAbout.Lines.Text);

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

function TfmRBConst.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3: string;
  and1,and2: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindValue:=Trim(FindValue)<>'';
    isFindNote:=Trim(FindNote)<>'';

    if isFindName or isFindValue or isFindNote then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindValue then begin
        addstr2:=' Upper(valueview) like '+AnsiUpperCase(QuotedStr(FilInSide+FindValue+'%'))+' ';
     end;

     if isFindNote then begin
        addstr3:=' Upper(note) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNote+'%'))+' ';
     end;


     if (isFindName and isFindValue)or
        (isFindName and isFindNote)
        then and1:=' and ';

     if (isFindValue and isFindNote)
        then and2:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3;
end;

procedure TfmRBConst.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                     DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  tmps: string;
  val: Integer;
begin
  if Mainqr.isEmpty then exit;
  
  if Column.Title.Caption='Тип константы' then begin

    rt.Right:=rect.Right;
    rt.Left:=rect.Left+2;
    rt.Top:=rect.Top+2;
    rt.Bottom:=rect.Bottom-2;

    val:=Mainqr.FieldByName('consttype').AsInteger;
    case Val of
      1: tmps:='Ссылка';
    else
      tmps:='По умолчанию';
    end;

    if Grid.DrawRow=Grid.CurrentRow then
     Grid.Canvas.Font.Color:=clHighlightText
    else
     Grid.Canvas.Font.Color:=clWindowText;

    Grid.Canvas.Brush.Style:=bsClear;
    Grid.Canvas.FillRect(Rect);
    Grid.Canvas.TextRect(rect,rt.left,rt.top,tmps);
    
  end;
end;

function TfmRBConst.SetValuesToEditForm(TypeSetValuesToEditForm: TTypeSetValuesToEditForm): Boolean;
begin
  Result:=inherited SetValuesToEditForm(TypeSetValuesToEditForm);
  if not Result then exit;
  with TfmEditRBConsts(EditForm) do begin
    FillCmbObj;
    FillCmbColumn;
    cmbType.ItemIndex:=Mainqr.fieldByName('consttype').AsInteger;
    cmbTypeChange(nil);
    edName.Text:=Mainqr.fieldByName('name').AsString;
    meAbout.Lines.Text:=Mainqr.fieldByName('note').AsString;
    edValueView.Text:=Mainqr.fieldByName('valueview').AsString;
    oldconstex_id:=Mainqr.fieldByName('constex_id').AsInteger;
    cmbObj.ItemIndex:=cmbObj.Items.IndexOf(Mainqr.fieldByName('tablename').AsString);
    edObjChange(nil);
    cmbColumn.ItemIndex:=cmbColumn.Items.IndexOf(Mainqr.fieldByName('fieldname').AsString);
    edValueTable.Text:=Mainqr.fieldByName('valuetable').AsString;

    OldName:=edName.Text;
    OldValueView:=edValueView.Text;
    OldTableName:=cmbObj.Text;
    OldColumnName:=cmbColumn.Text;
  end;
  Result:=true;
end;

end.
