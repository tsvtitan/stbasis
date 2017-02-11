unit URBStoreType;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBStoreType = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    FirstStartForm, isFindName,isFindAbout: Boolean;
    FindName,FindAbout: String;
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
  fmRBStoreType: TfmRBStoreType;

implementation

uses UMainUnited, UStoreVAVCode, UStoreVAVDM, UStoreVAVData, UEditRBStoreType,
  StVAVKit;

{$R *.DFM}

procedure TfmRBStoreType.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkStoreType;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  FirstStartForm:=true;

  DefLastOrderStr:=' order by namestoretype';

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStoreType.FormDestroy(Sender: TObject);
begin
  inherited;
 if FormState=[fsCreatedMDIChild] then
   fmRBStoreType:=nil;
end;

function TfmRBStoreType.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkStoreType+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBStoreType.ActiveQuery(CheckPerm: Boolean);
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
      if FirstStartForm then
        begin
          FillGridColumnsFromTb(IBDB,tbStoreType,grid);
          LoadFromIni;
          FirstStartForm:=false;
          ActiveQuery(false);
        end;

   SetImageFilter(isFindName or isFindAbout);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStoreType.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('StoreType_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('StoreType_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStoreType.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBStoreType.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'Name',FindName);
    FindAbout:=ReadParam(ClassName,'About',FindAbout);
    isFindName:=ReadParam(ClassName,'isFindName',isFindName);
    isFindName:=ReadParam(ClassName,'isFindAbout',isFindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStoreType.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'FindName',FindName);
    WriteParam(ClassName,'isFindName',isFindName);
    WriteParam(ClassName,'FindAbout',FindAbout);
    WriteParam(ClassName,'isFindAbout',isFindAbout);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStoreType.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBStoreType.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBStoreType;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBStoreType.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('storetype_id',fm.oldstoretype_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBStoreType.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBStoreType;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBstoretype.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edstoreType.Text:=Mainqr.fieldByName('NameStoreType').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('About').AsString;
    fm.oldStoreType_id:=Mainqr.fieldByName('StoreType_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('storetype_id',fm.oldStoreType_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBStoreType.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbStoreType+' where StoreType_id='+
          Mainqr.FieldByName('StoreType_id').asString;
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
                  Pchar(CaptionDelete+' место хранения <'+Mainqr.FieldByName('NameStoreType').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBStoreType.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBStoreType;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBStoreType.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edstoreType.Text:=Mainqr.fieldByName('NameStoreType').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('About').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBStoreType.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBStoreType;
  filstr: string;
begin
 fm:=TfmEditRBStoreType.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindName)<>'' then fm.edstoreType.Text:=FindName;
  if Trim(FindAbout)<>'' then fm.meAbout.Text:=FindAbout;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edstoreType.Text);
    FindAbout:=Trim(fm.meAbout.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBStoreType.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;


    isFindName :=trim(FindName)<>'';
    isFindAbout:=trim(FindAbout)<>'';

    if isFindName or
       isFindAbout then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(NameStoreType) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName +'%'))+' ';
     end;

     if isFindAbout then begin
        addstr2:=' Upper(about) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAbout+'%'))+' ';
     end;


     if (isFindName and isFindAbout) then
         and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;


end.
