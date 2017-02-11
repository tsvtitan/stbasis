unit URBSickGroup;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeViewEx, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, ImgList, comctrls,
  dbtree, IB, Menus, VirtualTrees;

type
   TfmRBSickGroup = class(TfmRBMainTreeViewEx)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName: Boolean;
    FindName: String;
  protected
    procedure TreeViewDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBSickGroup: TfmRBSickGroup;

implementation

uses UMainUnited, USickTsvCode, USickTsvDM, USickTsvData, UEditRBSickGroup;

{$R *.DFM}

procedure TfmRBSickGroup.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkSickGroup;
  
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  TreeView.KeyFieldName:='sickgroup_id';
  TreeView.ParentFieldName:='parent_id';
  TreeView.ViewFieldName:='name';

  DefLastOrderStr:=' order by c.inc ';
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSickGroup.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSickGroup:=nil;
end;

function TfmRBSickGroup.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSickGroup+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSickGroup.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  inherited;

  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  try
    Mainqr.sql.Clear;
    sqls:=GetSql;
    Mainqr.sql.Add(sqls);
    Mainqr.Transaction.Active:=false;
    Mainqr.Transaction.Active:=true;
    Mainqr.Active:=true;
    SetImageFilter(isFindName);
    ViewCount;
  finally
    TreeView.CollapseAll;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSickGroup.TreeViewDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfmRBSickGroup.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSickGroup.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSickGroup.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSickGroup.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSickGroup;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSickGroup.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('sickgroup_id',fm.oldsickgroup_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSickGroup.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSickGroup;
  nd: PVirtualNode;
begin
  nd:=TreeView.FocusedNode;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBSickGroup.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meNote.Lines.Text:=Mainqr.fieldByName('note').AsString;
    fm.udSort.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldsickgroup_id:=MainQr.FieldByName('sickgroup_id').AsInteger;
    if nd.Parent<>TreeView.RootNode then begin
      fm.ParentSickGroupId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=TreeView.NodeText[nd.Parent];
    end;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('sickgroup_id',fm.oldsickgroup_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSickGroup.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbSickGroup+' where sickgroup_id='+
          Mainqr.FieldByName('sickgroup_id').asString;
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
  but:=DeleteWarningEx('группу <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBSickGroup.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSickGroup;
  nd: PVirtualNode;
begin
  nd:=TreeView.FocusedNode;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBSickGroup.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meNote.Lines.Text:=Mainqr.fieldByName('note').AsString;
    fm.udSort.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.bibParent.Enabled:=false;
    if nd.Parent<>TreeView.RootNode then begin
      fm.ParentSickGroupId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=TreeView.NodeText[nd.Parent];
    end;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSickGroup.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSickGroup;
  filstr: string;
begin
 fm:=TfmEditRBSickGroup.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.edParent.Enabled:=false;
  fm.bibParent.Enabled:=false;
  fm.lbParent.Enabled:=false;

  fm.meNote.Enabled:=false;
  fm.meNote.Color:=clBtnFace;
  fm.lbNote.Enabled:=false;

  fm.lbSort.Enabled:=false;
  fm.edSort.Enabled:=false;
  fm.edSort.Color:=clBtnFace;
  fm.udSort.Enabled:=false;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBSickGroup.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
