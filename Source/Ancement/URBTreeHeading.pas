unit URBTreeHeading;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeView, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, URBMainGrid, ImgList, comctrls,
  dbtree, IB, Menus;

type
   TfmRBTreeHeading = class(TfmRBMainTreeView)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure EdFindNodeChange(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    TekNode: TTreeNode;
    isFindNameHeading: Boolean;
    FindNameHeading: String;
    function GetTreeHeadingIdByNode(nd: TTreeNode): Integer;
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

  
implementation

uses UMainUnited, UAncementCode, UAncementDM, UAncementData, UEditRBTreeHeading;

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

//  LastOrderStr:=' order by treeheading_id, sortnumber ';
  
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
begin
 inherited;
 try
    FindNameHeading:=ReadParam(ClassName,'nameheading',FindNameHeading);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTreeHeading.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'nameheading',FindNameHeading);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTreeHeading.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

function TfmRBTreeHeading.GetTreeHeadingIdByNode(nd: TTreeNode): Integer;
begin
  Result:=TreeView.DBTreeNodes.GetKeyFieldValue(nd);
end;

procedure TfmRBTreeHeading.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBTreeheading;
  ParentNode: TTreeNode;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBTreeheading.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    if TreeView.Selected<>nil then begin
      ParentNode:=TreeView.Selected.Parent;
      if ParentNode<>nil then begin
        fm.ParentTreeHeadingId:=GetTreeHeadingIdByNode(ParentNode);
        fm.edParent.Text:=ParentNode.Text;
      end;
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
    fm.edNameHeading.Text:=Mainqr.fieldByName('nameheading').AsString;
    fm.udSortNumber.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldtreeheading_id:=MainQr.FieldByName('treeheading_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentTreeHeadingId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    fm.SetFontFromStringHex(MainQr.FieldByName('font').AsString);
    fm.TypeEditRBook:=terbChange;
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
  but:=DeleteWarningEx('рубрику <'+Mainqr.FieldByName('nameheading').AsString+'> ?');
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
    fm.TypeEditRBook:=terbView;
    fm.edNameHeading.Text:=Mainqr.fieldByName('nameheading').AsString;
    fm.udSortNumber.Position:=Mainqr.fieldByName('sortnumber').AsInteger;
    fm.oldtreeheading_id:=MainQr.FieldByName('treeheading_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentTreeHeadingId:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParent.Text:=nd.Parent.Text;
    end;
    fm.SetFontFromStringHex(MainQr.FieldByName('font').AsString);
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
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindNameHeading)<>'' then fm.edNameHeading.Text:=FindNameHeading;

  fm.edParent.Enabled:=false;
  fm.bibParent.Enabled:=false;
  fm.lbParent.Enabled:=false;
  fm.lbSortNumber.Enabled:=false;
  fm.edSortNumber.Enabled:=false;
  fm.edSortNumber.Color:=clBtnface;
  fm.udSortNumber.Enabled:=false;
  fm.GrbFont.Enabled:=false;
  fm.meFont.Enabled:=false;
  fm.meFont.Color:=clBtnFace;
  fm.bibFont.Enabled:=false;


  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNameHeading:=Trim(fm.edNameHeading.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
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


procedure TfmRBTreeHeading.EdFindNodeChange(Sender: TObject);
var
  SearchString, LastSearchString :String;
  Title :String;
  str: PChar;
  LastChar: char;
  posstr, counter :Integer;
begin
  try
  if (TekNode = nil) then   TekNode:=TreeView.Items.GetFirstNode;
  if TekNode=nil then exit;
  if Sender=nil then exit;
  SearchString:=TEdit(Sender).Text;
  if ( Trim(SearchString)='') then
       begin
        TekNode:=TreeView.Items.GetFirstNode;
        if TekNode<>nil then begin
         TekNode.Selected:=true;
         TekNode.MakeVisible();
        end;
        exit;
       end;

  str:=Pchar(SearchString);
  LastChar:=str[Length(SearchString)-1];
  posstr := 0;
  counter := 1;
  while counter <= Length(SearchString) do
     begin
//       Posstr_old:=Posstr;
       if (str[counter-1]=' ') then
       Posstr:=counter;
       counter := counter+1;
    end;

    LastSearchString := Copy (SearchString,posstr+1,Length(SearchString)-posstr);
  //Проверяю на пробел для раскрытия
         if (LastChar = ' ') then
          begin
           if TreeView.Selected<>nil then
            if (TreeView.Selected.HasChildren = true) then
                begin
                   TekNode := TreeView.Selected;
                   TekNode := TekNode.GetNext();
                   if TekNode<>nil then begin
                    TekNode.Selected:=true;
                    TekNode := TreeView.Selected;
                    TekNode.Selected:=true;
                   end; 
                end;
              Exit;
          end
        else
        begin

//Ищу текст
  if (TekNode <> nil)  then
      while (TekNode <> nil)or(Length(TekNode.Text)<=0) do
        begin
          if (Length(TekNode.Text)>0) then
           begin
           title := TekNode.Text;
           if (AnsiStrLIComp(PChar(title),PChar(LastSearchString),Length(LastSearchString)) = 0) then
             begin
                   TekNode.Selected:=true;
                   exit;
             end;
             TekNode := TekNode.GetNextChild(TekNode);
             if TekNode=nil then break;
           end;
           end
        end;
except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
end;
end;

procedure TfmRBTreeHeading.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
///  inherited;
end;

end.
