unit URBMenu;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeView, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, URBMainGrid, ImgList, comctrls,
  dbtree, IB, Menus;

type
   TfmRBMenu = class(TfmRBMainTreeView)
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
  fmRBMenu: TfmRBMenu;

implementation

uses UMainUnited, UDesignTsvCode, UDesignTsvDM, UDesignTsvData, UEditRBMenu,
     tsvPicture;

{$R *.DFM}

procedure TfmRBMenu.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkMenu;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  TreeView.ParentField:='parent_id';
  TreeView.ListField:='name';
  TreeView.KeyField:='menu_id';
  TreeView.DisplayField:='name';

  LastOrderStr:=' order by parent desc, sortvalue desc';

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMenu.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBMenu:=nil;
end;

function TfmRBMenu.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkMenu+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBMenu.ActiveQuery(CheckPerm: Boolean);
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

procedure TfmRBMenu.TreeViewDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfmRBMenu.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMenu.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBMenu.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBMenu.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBMenu;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBMenu.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('menu_id',fm.oldmenu_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBMenu.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBMenu;
  nd: TTreeNode;
  ms: TMemoryStream;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBMenu.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meHint.Lines.Text:=Mainqr.fieldByName('hint').AsString;
    fm.edInterface.Text:=Mainqr.fieldByName('interfacename').AsString;
    fm.interface_id:=Mainqr.fieldByName('interface_id').AsInteger;
    fm.htShortCut.HotKey:=Mainqr.fieldByName('shortcut').AsInteger;
    fm.chbChangeFlag.Checked:=Boolean(Mainqr.fieldByName('changeflag').AsInteger);
    fm.udSort.Position:=Mainqr.fieldByName('sortvalue').AsInteger;
    fm.oldmenu_id:=MainQr.FieldByName('menu_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentMenuId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
    ms.Position:=0;
    TTsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    fm.chbImageStretchClick(nil);

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('menu_id',fm.oldmenu_id,[loCaseInsensitive]);
    end;
  finally
    ms.Free;
    fm.Free;
  end;
end;

procedure TfmRBMenu.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbMenu+' where menu_id='+
          Mainqr.FieldByName('menu_id').asString;
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
  but:=DeleteWarningEx('меню <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBMenu.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBMenu;
  nd: TTreeNode;
  ms: TMemoryStream;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBMenu.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.meHint.Lines.Text:=Mainqr.fieldByName('hint').AsString;
    fm.edInterface.Text:=Mainqr.fieldByName('interfacename').AsString;
    fm.interface_id:=Mainqr.fieldByName('interface_id').AsInteger;
    fm.htShortCut.HotKey:=Mainqr.fieldByName('shortcut').AsInteger;
    fm.chbChangeFlag.Checked:=Boolean(Mainqr.fieldByName('changeflag').AsInteger);
    fm.udSort.Position:=Mainqr.fieldByName('sortvalue').AsInteger;
    fm.oldmenu_id:=MainQr.FieldByName('menu_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentMenuId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
    ms.Position:=0;
    TTsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    fm.chbImageStretchClick(nil);

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    ms.Free;
    fm.Free;
  end;
end;

procedure TfmRBMenu.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBMenu;
  filstr: string;
begin
 fm:=TfmEditRBMenu.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.edParent.Enabled:=false;
  fm.bibParent.Enabled:=false;
  fm.lbParent.Enabled:=false;

  fm.edInterface.Enabled:=false;
  fm.bibInterface.Enabled:=false;
  fm.lbInterface.Enabled:=false;

  fm.meHint.Enabled:=false;
  fm.meHint.Color:=clBtnFace;
  fm.lbHint.Enabled:=false;

  fm.lbShortCut.Enabled:=false;
  fm.htShortCut.Enabled:=false;

  fm.chbChangeFlag.Enabled:=false;

  fm.bibImageLoad.Enabled:=false;
  fm.bibImageSave.Enabled:=false;
  fm.bibImageCopy.Enabled:=false;
  fm.bibImagePaste.Enabled:=false;
  fm.bibImageClear.Enabled:=false;
  fm.chbImageStretch.Enabled:=false;

  fm.lbSort.Enabled:=false;
  fm.edSort.Color:=clBtnFace;
  fm.edSort.Enabled:=false;
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

function TfmRBMenu.GetFilterString: string;
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
        addstr1:=' Upper(m.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
