unit URBChargeTree;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeView, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, URBMainGrid, ImgList, comctrls,
  dbtree, Mask, IB, Menus;

type
   TfmRBChargeTree = class(TfmRBMainTreeView)
    pnFields: TPanel;
    lbName: TLabel;
    dbedShortName: TDBEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
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
  fmRBChargeTree: TfmRBChargeTree;

implementation

uses UMainUnited, USalaryTsvCode, USalaryTsvDM, USalaryTsvData, UEditRBChargeTree;

{$R *.DFM}

procedure TfmRBChargeTree.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkChargeTree;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  TreeView.ParentField:='parent_id';
  TreeView.ListField:='chargename';
  TreeView.KeyField:='chargetree_id';

  dbedShortname.DataField:='chargeshortname';

{  TreeView.MasterField:='chargetree_id';
  TreeView.DetailField:='parent_id';
  TreeView.ItemField:='chargename';

  dbedShortname.DataField:='chargeshortname';}

  LastOrderStr:=' order by ch.name ';

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBChargeTree.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBChargeTree:=nil;
end;

function TfmRBChargeTree.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkChargeTree+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBChargeTree.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  inherited;
  
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  TreeView.Items.BeginUpdate;
  try
    Mainqr.sql.Clear;
    sqls:=GetSql;
    Mainqr.sql.Add(sqls);
    Mainqr.Transaction.Active:=false;
    Mainqr.Transaction.Active:=true;
    Mainqr.Active:=true;
    LocateToFirstNode;
    SetImageToTreeNodes;
    SetImageFilter(isFindName);
    ViewCount;
  finally
   TreeView.FullCollapse;
   TreeView.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBChargeTree.TreeViewDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfmRBChargeTree.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBChargeTree.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBChargeTree.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBChargeTree.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBChargeTree;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBChargeTree.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('chargetree_id',fm.oldchargetree_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBChargeTree.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBChargeTree;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBChargeTree.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('chargename').AsString;
    fm.charge_id:=Mainqr.fieldByName('charge_id').AsInteger;
    fm.oldchargetree_id:=MainQr.FieldByName('chargetree_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentChargeTreeId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('chargetree_id',fm.oldchargetree_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBChargeTree.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbChargeTree+' where chargetree_id='+
          Mainqr.FieldByName('chargetree_id').asString;
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
  if Mainqr.isEmpty then exit;
  but:=DeleteWarningEx('зависимость <'+Mainqr.FieldByName('chargename').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBChargeTree.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBChargeTree;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBChargeTree.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('chargename').AsString;
    fm.charge_id:=Mainqr.fieldByName('charge_id').AsInteger;
    fm.oldchargetree_id:=MainQr.FieldByName('chargetree_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentChargeTreeId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBChargeTree.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBChargeTree;
  filstr: string;
begin
 fm:=TfmEditRBChargeTree.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.edName.Color:=clWindow;
  fm.edName.ReadOnly:=false;
  fm.edParent.Enabled:=false;
  fm.bibParent.Enabled:=false;
  fm.lbParent.Enabled:=false;
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

function TfmRBChargeTree.GetFilterString: string;
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
        addstr1:=' Upper(ch.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


procedure TfmRBChargeTree.FormResize(Sender: TObject);
begin
  inherited;
  dbedShortName.Width:=TreeView.Width-dbedShortName.Left;
end;

end.
