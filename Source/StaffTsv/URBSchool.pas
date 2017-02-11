unit URBSchool;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeView, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, URBMainGrid, ImgList, comctrls,
  dbtree, Mask, IB, Menus, tsvDbGrid;

type
   TfmRBSchool = class(TfmRBMainTreeView)
    pnFields: TPanel;
    lbTownName: TLabel;
    dbedTownName: TDBEdit;
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
    isFindName,isFindTownName: Boolean;
    FindName,FindTownName: String;
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
  fmRBSchool: TfmRBSchool;

implementation

uses UMainUnited, UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBSchool;

{$R *.DFM}

procedure TfmRBSchool.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkSchool;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  TreeView.ParentField:='parent_id';
  TreeView.ListField:='schoolname';
  TreeView.KeyField:='school_id';

  dbedTownname.DataField:='townname';

  LastOrderStr:=' order by s.name ';
  
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSchool.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSchool:=nil;
end;

function TfmRBSchool.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSchool+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSchool.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  inherited;

  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
//  Mainqr.DisableControls;
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
    SetImageFilter(isFindName or isFindTownName);
    ViewCount;
  finally
   TreeView.FullCollapse;
   TreeView.Items.EndUpdate;
//   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSchool.TreeViewDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfmRBSchool.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'schoolname',FindName);
    FindTownName:=ReadParam(ClassName,'townname',FindTownName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSchool.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'schoolname',FindName);
    WriteParam(ClassName,'townname',FindTownName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSchool.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSchool.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSchool;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSchool.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('school_id',fm.oldschool_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSchool.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSchool;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBSchool.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('schoolname').AsString;
    fm.town_id:=Mainqr.fieldByName('town_id').AsInteger;
    fm.edTown.Text:=Mainqr.fieldByName('townname').AsString;
    fm.oldschool_id:=MainQr.FieldByName('school_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentSchoolId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('school_id',fm.oldschool_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSchool.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbSchool+' where school_id='+
          Mainqr.FieldByName('school_id').asString;
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
  but:=DeleteWarningEx('учебное заведение <'+Mainqr.FieldByName('schoolname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
{      ShowError(Application.Handle,
               'Учебное заведение <'+Mainqr.FieldByName('name').AsString+'> используется.');}
    end;
  end;
end;

procedure TfmRBSchool.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSchool;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBSchool.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('schoolname').AsString;
    fm.town_id:=Mainqr.fieldByName('town_id').AsInteger;
    fm.edTown.Text:=Mainqr.fieldByName('townname').AsString;
    fm.bibParent.Enabled:=false;
    if nd.Parent<>nil then begin
      fm.ParentSchoolId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSchool.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSchool;
  filstr: string;
begin
 fm:=TfmEditRBSchool.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindTownName)<>'' then fm.edTown.Text:=FindTownName;

  fm.edTown.Color:=clWindow;
  fm.edTown.ReadOnly:=false;
  fm.edParent.Enabled:=false;
  fm.bibParent.Enabled:=false;
  fm.lbParent.Enabled:=false;
  
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindTownName:=Trim(fm.edTown.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBSchool.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindTownName:=Trim(FindTownName)<>'';

    if isFindName or isFindTownName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindTownName then begin
        addstr2:=' Upper(t.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTownName+'%'))+' ';
     end;

     if isFindName and isFindTownName
      then and1:=' and '; 

     Result:=wherestr+addstr1+and1+addstr2;
end;


procedure TfmRBSchool.FormResize(Sender: TObject);
begin
  inherited;
  dbedTownName.Width:=TreeView.Width-dbedTownName.Left;
end;

end.
