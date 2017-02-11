unit URBTreeHeading;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeView, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, inifiles, IBDatabase, URBMainGrid, ImgList, comctrls,
  dbtree, IB, Menus;

type
   TfmRBTreeHeading = class(TfmRBMainTreeView)
    EdFindNode: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure EdFindNodeKeyPress(Sender: TObject; var Key: Char);
    procedure EdFindNodeChange(Sender: TObject);
  private
    isFindNameHeading: Boolean;
    FindNameHeading: String;
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
  fmRBTreeHeading: TfmRBTreeHeading;
  TekNode: TTreeNode;

implementation

uses tsvIniFiles, UMainUnited, UAncementCode, UAncementDM, UAncementData, UEditRBTreeHeading;

{$R *.DFM}

procedure TfmRBTreeHeading.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkTreeHeading;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  TreeView.ParentField:='parent_id';
  TreeView.ListField:='nameheading';
  TreeView.KeyField:='treeheading_id';
  TreeView.DisplayField:='nameheading';

  LastOrderStr:=' order by sortnumber, nameheading, ';

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTreeHeading.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBTreeHeading:=nil;
end;

function TfmRBTreeHeading.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkTreeHeading+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBTreeHeading.ActiveQuery(CheckPerm: Boolean);
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
    SetImageFilter(isFindNameHeading);
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

procedure TfmRBTreeHeading.TreeViewDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfmRBTreeHeading.LoadFromIni;
var
  fi: TTSVIniFile;
begin
 inherited;
 try
  fi:=TTSVIniFile.Create(GetIniFileName);
  try
    FindNameHeading:=fi.ReadString(ClassName,'nameheading',FindNameHeading);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTreeHeading.SaveToIni;
var
  fi: TTSVIniFile;
begin
 inherited;
 try
  fi:=TTSVIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'nameheading',FindNameHeading);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTreeHeading.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBTreeHeading.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBTreeheading;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBTreeheading.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('treeheading_id',fm.oldtreeheading_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTreeHeading.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBTreeheading;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBTreeheading.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edNameHeading.Text:=Mainqr.fieldByName('nameheading').AsString;
    fm.udSortNumber.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldtreeheading_id:=MainQr.FieldByName('treeheading_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentTreeHeadingId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('treeheading_id',fm.oldtreeheading_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTreeHeading.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbTreeHeading+' where treeheading_id='+
          Mainqr.FieldByName('treeheading_id').asString;
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
  but:=DeleteWarning('рубрику <'+Mainqr.FieldByName('nameheading').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTreeHeading.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBTreeheading;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBTreeheading.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edNameHeading.Text:=Mainqr.fieldByName('nameheading').AsString;
    fm.udSortNumber.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldtreeheading_id:=MainQr.FieldByName('treeheading_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentTreeHeadingId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTreeHeading.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBTreeheading;
  filstr: string;
begin
 fm:=TfmEditRBTreeheading.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindNameHeading)<>'' then fm.edNameHeading.Text:=FindNameHeading;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;

  fm.edParent.Enabled:=false;
  fm.bibParent.Enabled:=false;
  fm.lbParent.Enabled:=false;
  fm.lbSortNumber.Enabled:=false;
  fm.edSortNumber.Enabled:=false;
  fm.edSortNumber.Color:=clBtnface;
  fm.udSortNumber.Enabled:=false;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNameHeading:=Trim(fm.edNameHeading.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBTreeHeading.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindNameHeading:=Trim(FindNameHeading)<>'';

    if isFindNameHeading then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNameHeading then begin
        addstr1:=' Upper(nameheading) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNameHeading+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


procedure TfmRBTreeHeading.EdFindNodeKeyPress(Sender: TObject;
  var Key: Char);
var
SearchString :String;
Title :String;
begin
if (TekNode = nil) then   TekNode:=TreeView.Items.GetFirstNode;

SearchString:=EdFindNode.Text;
//Проверяю на пробел для раскрытия
 if (Key = ' ') then
        begin
          if (TreeView.Selected <> nil) then
          TreeView.Selected.expand(false);
          if (TekNode.Count > 0 ) then
                TekNode := TekNode.GetNext();
                TekNode.Selected:=true;                
//        ShowMessage(IntToStr(TekNode.Count));
        Exit;
       end;
//Проверяю на BackSpace для возврата назад
  if (Key = #8) then
      begin
        Exit;
      end;

//Ищу текст
  if (TekNode <> nil)  then
      while (TekNode <> nil) do
        begin
           title := TekNode.Text;
           Label2.Caption:=TekNode.Text;
           Label3.Caption:=IntToStr(TekNode.Count);
//           a:=SearchString;
           if (AnsiStrLIComp(PChar(title),PChar(SearchString),Length(SearchString)) = 0) then
                TekNode.Selected:=true;
             begin
  //             ShowMessage(IntToStr(TekNode.AbsoluteIndex));
             end;
//             ShowMessage(IntToStr(TekNode.Count)+' ' + TekNode.Text);
                           TekNode.Selected:=true;
             TekNode := TekNode.GetNextChild(TekNode);
        end
end;

procedure TfmRBTreeHeading.EdFindNodeChange(Sender: TObject);
begin
//

end;

end.
