unit URbkDepart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkTV, ImgList, Db, IBDatabase, IBCustomDataSet, IBQuery, DBCtrls,
  StdCtrls, Buttons, ExtCtrls, comctrls, Ib, Mask;

type
  TFmRbkDepart = class(TFmRbkTV)
    PnFields: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdCode: TDBEdit;
    DBEdFtype: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btRefreshClick(Sender: TObject);
    procedure btInsertClick(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btDelClick(Sender: TObject);
    procedure btMoreClick(Sender: TObject);
    procedure btFilterClick(Sender: TObject);
  private
    isFindName, isFindCode, IsFindFType: Boolean;
    FindName, findCode, FindFType: String;
  protected
    function CheckPermission: Boolean; override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
  public
    FilterInside:Boolean;
    procedure ActiveQuery(CheckPerm: Boolean);override;
    { Public declarations }
  end;

var
  FmRbkDepart: TFmRbkDepart;

implementation
uses UMainUnited, Uconst, UFuncProc, URbkDepartEdit;
{$R *.DFM}

procedure TFmRbkDepart.FormCreate(Sender: TObject);
begin
 inherited;
 try
  Caption:=NameDepart;
  IbQ.Database:=IBDB;
  RbkTran.AddDatabase(IBDB);
  IBDB.AddTransaction(RbkTran);

  TV.ParentField:='parent_id';
  TV.ListField:='name';
  TV.KeyField:='Depart_id';
  TV.DisplayField:='name';
  DBEdCode.DataField:='Code';
  DbEdFType.DataField:='Ftype';
  LastOrderStr:=' order by name ';
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmRbkDepart.LoadFromIni;
begin
 inherited;
  try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindCode:=ReadParam(ClassName,'Code',FindCode);
    FindFtype:=ReadParam(ClassName,'ftype',Findftype);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TFmRbkDepart.SaveToIni;
begin
 inherited;
 try
   writeParam(ClassName,'name',FindName);
   writeParam(ClassName,'Code',FindCode);
   writeParam(ClassName,'Ftype',FindFtype);
   writeParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


function TFmRbkDepart.CheckPermission: Boolean;
var
  isPerm:Boolean;
begin
  isPerm:=_isPermission(tbDepart,SelConst);
  if not ViewSelect then begin
   btInsert.Enabled:=isPerm and _isPermission(tbDepart,InsConst);
   btEdit.Enabled:=isPerm and _isPermission(tbDepart,UpdConst);
   btDel.Enabled:=isPerm and _isPermission(tbDepart,DelConst);
   btMore.Enabled:=isPerm;
   btFilter.Enabled:=isPerm;
   btAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;

procedure TFmRbkDepart.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then fmRBkDepart:=nil;
end;

procedure TFmRbkDepart.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
   inherited;

  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  TV.Items.BeginUpdate;
  try
    IbQ.sql.Clear;
    sqls:='Select * from '+tbDepart+' '+WhereStr+LastOrderStr;
    IbQ.sql.Add(sqls);
    IbQ.Transaction.Active:=false;
    IbQ.Transaction.Active:=true;
    IbQ.Active:=true;
    SetImageToTreeNodes;
    SetImageFilter(isFindName or isFindCode or IsFindFType);
    ViewCount;
  finally
   TV.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;


procedure TFmRbkDepart.btRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TFmRbkDepart.btInsertClick(Sender: TObject);
var
  fm: TfmRBkDepartEdit;
begin
  if not IbQ.Active then exit;
  fm:=TfmRBkDepartEdit.Create(nil);
  try
    fm.btPost.OnClick:=fm.AddNode;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkDepart.btEditClick(Sender: TObject);
var
  fm: TfmRBkDepartEdit;
  nd: TTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if not IbQ.Active then exit;
  if IbQ.RecordCount=0 then exit;
  fm:=TfmRBkDepartEdit.Create(nil);
  try
    fm.btPost.OnClick:=fm.EditNode;
    fm.Caption:=CaptionChange;
    fm.edName.Text:=IbQ.fieldByName('Name').AsString;
    fm.EdCode.text:=IbQ.fieldByName('Code').AsString;
    fm.EdFType.text:=IbQ.fieldByName('FType').AsString;
    if nd.Parent<>nil then
    begin
      fm.ParentDepartId:=IbQ.fieldByName('parent_id').AsInteger;
      fm.EdParent.Text:=nd.Parent.Text;
    end;
    fm.ChangeFlag:=false;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkDepart.btDelClick(Sender: TObject);
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
     qr.Transaction:=RbkTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbDepart+' where Depart_id='+
       IbQ.FieldByName('Depart_id').asString;
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
  if IbQ.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' מעהוכ <'+IbQ.FieldByName('name').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TFmRbkDepart.btMoreClick(Sender: TObject);
var
  fm: TfmRBkDepartEdit;
  nd: TTreeNode;
begin
  nd:=TV.Selected;
  if nd=nil then exit;
  if not IbQ.Active then exit;
  if IbQ.RecordCount=0 then exit;
  fm:=TfmRBkDepartEdit.Create(nil);
  try
    fm.btPost.OnClick:=nil;
    fm.btPost.Visible:=false;
    fm.BtCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edName.Text:=IbQ.fieldByName('name').AsString;
    fm.EdCode.text:=IbQ.fieldByName('Code').AsString;
    fm.EdFType.text:=IbQ.fieldByName('FType').AsString;
    fm.BtCallParent.Enabled:=false;
    if nd.Parent<>nil then begin
      fm.ParentDepartId:=IbQ.fieldByName('parent_id').AsInteger;
      fm.EdParent.Text:=nd.Parent.Text;
    end;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

procedure TFmRbkDepart.btFilterClick(Sender: TObject);
var
  fm: TfmRBkDepartEdit;
  filstr: string;
begin
 fm:=TfmRBkDepartEdit.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.BtPost.OnClick:=fm.Setfilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindCode)<>'' then fm.edCode.Text:=FindCode;
  if Trim(FindFType)<>'' then fm.edFType.Text:=FindFType;

  fm.PnFilter.Visible:=true;
  fm.btClear.Visible:=true;
  fm.EdParent.Enabled:=false;
  fm.BtCallParent.Enabled:=false;
  fm.lbParent.Enabled:=false;
  fm.CBInsideFilter.Checked:=FilterInside;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then
  begin
    FindName:=Trim(fm.edName.Text);
    FindCode:=Trim(fm.edCode.Text);
    FindFType:=Trim(fm.edFtype.Text);
    FilterInSide:=fm.CBInsideFilter.Checked;
    if FilterInSide then filstr:='%';
    WhereStr:=GetFilterString;
    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;


function TFmRbkDepart.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:='';
    isFindName:=Trim(FindName)<>'';
    isFindCode:=Trim(FindCode)<>'';
    isFindFType:=Trim(FindFType)<>'';

    if isFindName or isFindCode or isFindFType then   wherestr:=' where ';

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindCode then begin
        addstr2:=' Upper(Code) like '+
         AnsiUpperCase(QuotedStr(FilInSide+FindCode+'%'))+' ';
     end;

     if isFindFType then begin
        addstr2:=' Upper(FType) like '+
         AnsiUpperCase(QuotedStr(FilInSide+FindFType+'%'))+' ';
     end;

     if isFindName and isFindCode and isFindFType  then and1:=' and ';
     Result:=wherestr+addstr1+and1+addstr2;
end;


end.
