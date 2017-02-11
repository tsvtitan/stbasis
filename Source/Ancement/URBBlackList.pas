unit URBBlackList;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, grids, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBBlackList = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindBlackString: Boolean;
    FindBlackString: String;

    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                     DataCol: Integer; Column: TColumn; State: TGridDrawState);
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
  fmRBBlackList: TfmRBBlackList;

implementation

uses UMainUnited, UAncementCode, UAncementDM, UAncementData, UEditRBBlackList;

{$R *.DFM}

procedure TfmRBBlackList.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkBlackList;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='blackstring';
  cl.Title.Caption:='Строка исключения';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='infirstplus';
  cl.Title.Caption:='Сначала';
  cl.Width:=40;

  cl:=Grid.Columns.Add;
  cl.FieldName:='inlastplus';
  cl.Title.Caption:='С конца';
  cl.Width:=40;

  cl:=Grid.Columns.Add;
  cl.FieldName:='inallplus';
  cl.Title.Caption:='Везде';
  cl.Width:=40;

  cl:=Grid.Columns.Add;
  cl.FieldName:='about';
  cl.Title.Caption:='Примечание';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='datebegin';
  cl.Title.Caption:='Дата начала';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='dateend';
  cl.Title.Caption:='Дата окончания';
  cl.Width:=60;

  Grid.OnDrawColumnCell:=GridDrawColumnCell;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBlackList.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBBlackList:=nil;
end;

function TfmRBBlackList.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkBlacklist+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBBlackList.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindBlackString);
   ViewCount;
  finally
   Mainqr.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBlackList.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('blacklist_id').asString;
   if UpperCase(fn)=UpperCase('infirstplus') then fn:='infirst';
   if UpperCase(fn)=UpperCase('inlastplus') then fn:='inlast';
   if UpperCase(fn)=UpperCase('inallplus') then fn:='inall';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('blacklist_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBlackList.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBBlackList.LoadFromIni;
begin
 inherited;
 try
    FindBlackString:=ReadParam(ClassName,'blackstring',FindBlackString);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBlackList.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'blackstring',FindBlackString);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBlackList.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBBlackList.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  rt: TRect;
  chk: Boolean;
begin
  if not Mainqr.Active then exit;
  if Mainqr.isEmpty then exit;
  rt.Right:=rect.Right;
  rt.Left:=rect.Left;
  rt.Top:=rect.Top+2;
  rt.Bottom:=rect.Bottom-2;

  if Column.Title.Caption='Сначала' then begin
    chk:=Boolean(Mainqr.FieldByName('infirst').AsInteger);
    if not chk then DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK)
    else DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
  end;
  if Column.Title.Caption='С конца' then begin
    chk:=Boolean(Mainqr.FieldByName('inlast').AsInteger);
    if not chk then DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK)
    else DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
  end;
  if Column.Title.Caption='Везде' then begin
    chk:=Boolean(Mainqr.FieldByName('inall').AsInteger);
    if not chk then DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK)
    else DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
  end;
end;

procedure TfmRBBlackList.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBBlackList;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBBlackList.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('blacklist_id',fm.oldblacklist_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBlackList.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBBlackList;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBBlackList.Create(nil);
  try
    fm.oldblacklist_id:=Mainqr.fieldByName('blacklist_id').AsInteger;
    fm.edBlackString.Text:=Mainqr.fieldByName('blackstring').AsString;
    fm.chbInFirst.Checked:=Mainqr.fieldByName('infirst').AsInteger=1;
    fm.chbInLast.Checked:=Mainqr.fieldByName('inLast').AsInteger=1;
    fm.chbInAll.Checked:=Mainqr.fieldByName('inAll').AsInteger=1;
    if trim(Mainqr.fieldByName('datebegin').AsString)<>'' then
      fm.dtpDateBegin.Date:=Mainqr.fieldByName('datebegin').AsDateTime;
    if trim(Mainqr.fieldByName('dateend').AsString)<>'' then
      fm.dtpDateEnd.Date:=Mainqr.fieldByName('dateend').AsDateTime;
      fm.meAbout.Lines.Text:=Mainqr.fieldByName('about').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('blacklist_id',fm.oldblacklist_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBlackList.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbBlackList+' where blacklist_id='+
          Mainqr.FieldByName('blacklist_id').asString;
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
  but:=DeleteWarningEx('исключение <'+Mainqr.FieldByName('blackstring').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBBlackList.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBBlackList;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBBlackList.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.oldblacklist_id:=Mainqr.fieldByName('blacklist_id').AsInteger;
    fm.edBlackString.Text:=Mainqr.fieldByName('blackstring').AsString;
    fm.chbInFirst.Checked:=Mainqr.fieldByName('infirst').AsInteger=1;
    fm.chbInLast.Checked:=Mainqr.fieldByName('inLast').AsInteger=1;
    fm.chbInAll.Checked:=Mainqr.fieldByName('inAll').AsInteger=1;
    if trim(Mainqr.fieldByName('datebegin').AsString)<>'' then
      fm.dtpDateBegin.Date:=Mainqr.fieldByName('datebegin').AsDateTime;
    if trim(Mainqr.fieldByName('dateend').AsString)<>'' then
      fm.dtpDateEnd.Date:=Mainqr.fieldByName('dateend').AsDateTime;
      fm.meAbout.Lines.Text:=Mainqr.fieldByName('about').AsString;    
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBlackList.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBBlackList;
  filstr: string;
begin
 fm:=TfmEditRBBlackList.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.chbInFirst.Enabled:=false;
  fm.chbInLast.Enabled:=false;
  fm.chbInAll.Enabled:=false;
  fm.meAbout.Enabled:=false;
  fm.meAbout.Color:=clBtnFace;
  fm.dtpDateBegin.Enabled:=false;
  fm.dtpDateBegin.Color:=clBtnFace;
  fm.dtpDateend.Enabled:=false;
  fm.dtpDateend.Color:=clBtnFace;

  if Trim(FindBlackString)<>'' then fm.edBlackString.Text:=FindBlackString;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    Inherited;

    FindBlackString:=Trim(fm.edBlackString.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBBlackList.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindBlackString:=Trim(FindBlackString)<>'';

    if isFindBlackString then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindBlackString then begin
        addstr1:=' Upper(blackstring) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBlackString+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.
