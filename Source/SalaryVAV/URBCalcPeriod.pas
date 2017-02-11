unit URBCalcPeriod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus,tsvDbGrid, IBUpdateSQL;




type
  TfmRBCalcPeriod = class(TfmRBMainGrid)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindShortName: Boolean;
    FindName,FindShortName: String;
  protected
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
//    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
    function CheckPermission: Boolean; override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBCalcPeriod: TfmRBCalcPeriod;

implementation
uses UMainUnited, USalaryVAVCode, USalaryVAVDM, USalaryVAVData,UEditRBCalcPeriod, UTreeBuilding, StSalaryKit;
{$R *.DFM}
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
  inherited;
  try
   Caption:=NameCalcPeriod;
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);
   cl:=Grid.Columns.Add;
   cl.FieldName:='Name';
   cl.Title.Caption:='Рассчетный период';
   cl.Width:=200;
   cl:=Grid.Columns.Add;
   cl.FieldName:='STARTDATE';
   cl.Title.Caption:='Начинается с';
   cl.Width:=150;

   LoadFromIni;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.FormDestroy(Sender: TObject);
begin
  inherited;
   if FormState=[fsCreatedMDIChild] then
   fmRBCalcPeriod:=nil;

end;

function TfmRBCalcPeriod.CheckPermission: Boolean;
begin
  isPerm:=_isPermission(tbcalcperiod,SelConst);
  bibOk.Enabled:=isPerm;
  if not ViewSelect then begin
   bibAdd.Enabled:=isPerm and _isPermission(tbcalcperiod,InsConst);
   bibChange.Enabled:=isPerm and _isPermission(tbcalcperiod,UpdConst);
   bibDel.Enabled:=isPerm and _isPermission(tbcalcperiod,DelConst);
   bibView.Enabled:=isPerm;
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindShortName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('calcperiod_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('calcperiod_id',id,[loCaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCalcPeriod.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBCalcPeriod.LoadFromIni;
begin
 inherited;
  try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
 {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.SaveToIni;
begin
 inherited;
  try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBCalcPeriod.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBCalcPeriod;
  Year, Month, Day: Word;

begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBCalcPeriod.Create(nil);

  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    fm.DTP1.DateTime:=GetNewCalcPeriod();
    DecodeDate(fm.DTP1.DateTime, Year, Month, Day);
    fm.edName.Text:= LongMonthNames[Month] + ' ' +IntToStr(Year);
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('calcperiod_id',fm.oldcalcperiod_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBCalcPeriod.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBcalcperiod;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBcalcperiod.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.DTP1.DateTime:=Mainqr.fieldByName('startdate').AsDateTime;
    fm.oldcalcperiod_id:=MainQr.FieldByName('calcperiod_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('calcperiod_id',fm.oldcalcperiod_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbcalcperiod+' where calcperiod_id='+
          Mainqr.FieldByName('calcperiod_id').asString;
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
                  Pchar(CaptionDelete+' рассчетный период <'+Mainqr.FieldByName('name').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
      ShowError(Application.Handle,
               'Рассчетный период <'+Mainqr.FieldByName('name').AsString+'> используется.');
    end;
  end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBcalcperiod;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBcalcperiod.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.DTP1.DateTime:=Mainqr.fieldByName('startdate').AsDateTime;
    fm.LStatus.Visible:=true;
    case Mainqr.fieldByName('status').AsInteger  of
            0: fm.LStatus.Caption:='Не использован';
            1: fm.LStatus.Caption:='Межпериодный';
            2: fm.LStatus.Caption:='Период открыт';
            3: fm.LStatus.Caption:='Период закрыт';
    end;
    if fm.ShowModal=mrok then begin
    fm.LStatus.Visible:=false;
    end;
  finally
    fm.Free;
  end;
end;
//-----------------------------------------------------------------------------
procedure TfmRBCalcPeriod.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBcalcperiod;
  filstr: string;
begin
 fm:=TfmEditRBcalcperiod.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

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
//-----------------------------------------------------------------------------
function TfmRBCalcPeriod.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:='';

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;
//-----------------------------------------------------------------------------
function TfmRBCalcPeriod.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkCalcPeriod+GetFilterString+GetLastOrderStr;
end;
//-----------------------------------------------------------------------------
end.
