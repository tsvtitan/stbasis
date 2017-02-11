unit URBProperties;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainTreeView, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, URBMainGrid, ImgList, comctrls,
  dbtree, IB, Menus;

type
   TfmRBProperties = class(TfmRBMainTreeView)
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
    isFindNameProperties: Boolean;
    FindNameProperties: String;

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
  fmRBProperties: TfmRBProperties;


implementation

uses UMainUnited, UStoreVAVCode, UStoreVAVDM, UStoreVAVData, UEditRBProperties;

{$R *.DFM}

procedure TfmRBProperties.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameRbkProperties;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  TreeView.ParentField:='parent_id';
  TreeView.ListField:='nameproperties';
  TreeView.KeyField:='properties_id';
  TreeView.DisplayField:='nameproperties';

  LastOrderStr:=' order by properties_id';

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBProperties.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBProperties:=nil;
end;

function TfmRBProperties.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkProperties+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBProperties.ActiveQuery(CheckPerm: Boolean);
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
    SetImageFilter(isFindNameProperties);
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

procedure TfmRBProperties.TreeViewDblClick(Sender: TObject);
begin
  inherited;
end;

procedure TfmRBProperties.LoadFromIni;
begin
 inherited;
 try
    FindNameProperties:=ReadParam(ClassName,'nameproperties',FindNameProperties);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBProperties.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'NameProperties',FindNameProperties);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBProperties.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBProperties.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBProperties;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBProperties.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('Properties_id',fm.oldProperties_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBProperties.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBProperties;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBProperties.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edNameProperties.Text:=Mainqr.fieldByName('NameProperties').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('ABout').AsString;
    fm.oldProperties_id:=MainQr.FieldByName('properties_id').AsInteger;
    fm.edParentProperties.Text:=Mainqr.fieldByName('NameProperties1').AsString;
    fm.ParentProperties_ID :=MainQr.FieldByName('properties_id1').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentProperties_id:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParentProperties.Text:=nd.Parent.Text;
    end;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('nameproperties_id',fm.oldProperties_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBProperties.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbProperties+' where nameproperties_id='+
          Mainqr.FieldByName('nameproperties_id').asString;
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
  if Mainqr.RecordCount=0 then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' свойство <'+Mainqr.FieldByName('nameproperties').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBProperties.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBProperties;
  nd: TTreeNode;
begin
  nd:=TreeView.Selected;
  if nd=nil then exit;
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBProperties.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edNameProperties.Text:=Mainqr.fieldByName('nameProperties').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('ABout').AsString;
    fm.oldProperties_id:=MainQr.FieldByName('properties_id').AsInteger;
    if nd.Parent<>nil then begin
      fm.ParentProperties_ID:=Mainqr.fieldByName('parent_id').AsInteger;
      fm.edParentProperties.Text:=nd.Parent.Text;
    end;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBProperties.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBProperties;
  filstr: string;
begin
 fm:=TfmEditRBProperties.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindNameProperties)<>'' then fm.edNameProperties.Text:=FindNameProperties;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;

  fm.edParentProperties.Enabled:=false;
  fm.bibParentProperties.Enabled:=false;
  fm.lbParent.Enabled:=false;


  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNameProperties:=Trim(fm.edNameProperties.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBProperties.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindNameProperties:=Trim(FindNameProperties)<>'';

    if isFindNameProperties then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNameProperties then begin
        addstr1:=' Upper(NameProperties) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNameProperties+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


procedure TfmRBProperties.EdFindNodeChange(Sender: TObject);
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

procedure TfmRBProperties.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
///  inherited;
end;

end.
