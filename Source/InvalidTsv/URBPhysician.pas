unit URBPhysician;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBPhysician = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindfname,isFindname,isFindsname,isFindseatname: Boolean;
    Findfname,Findname,Findsname,Findseatname: String;
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
  fmRBPhysician: TfmRBPhysician;

implementation

uses UMainUnited, UInvalidTsvCode, UInvalidTsvDM, UInvalidTsvData, UEditRBPhysician;

{$R *.DFM}

procedure TfmRBPhysician.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkPhysician;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='fname';
  cl.Title.Caption:='Фамилия';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Имя';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sname';
  cl.Title.Caption:='Отчество';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='seatname';
  cl.Title.Caption:='Должность';
  cl.Width:=150;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPhysician.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBPhysician:=nil;
end;

function TfmRBPhysician.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkPhysician+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBPhysician.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindfname or isFindname or isFindsname or isFindseatname);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPhysician.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('physician_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('physician_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPhysician.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBPhysician.LoadFromIni;
begin
 inherited;
 try
    Findfname:=ReadParam(ClassName,'fname',Findfname);
    Findname:=ReadParam(ClassName,'name',Findname);
    Findsname:=ReadParam(ClassName,'sname',Findsname);
    Findseatname:=ReadParam(ClassName,'seatname',Findseatname);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPhysician.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'fname',Findfname);
    WriteParam(ClassName,'name',Findname);
    WriteParam(ClassName,'sname',Findsname);
    WriteParam(ClassName,'seatname',Findseatname);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBPhysician.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBPhysician.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBPhysician;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBPhysician.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('physician_id',fm.oldphysician_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPhysician.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBPhysician;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPhysician.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edfname.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edname.Text:=Mainqr.fieldByName('name').AsString;
    fm.edsname.Text:=Mainqr.fieldByName('sname').AsString;
    fm.edseatname.Text:=Mainqr.fieldByName('seatname').AsString;
    fm.oldphysician_id:=MainQr.FieldByName('physician_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('physician_id',fm.oldphysician_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPhysician.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbPhysician+' where physician_id='+
          Mainqr.FieldByName('physician_id').asString;
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
  but:=DeleteWarningEx('врача c ФИО <'+Mainqr.FieldByName('fname').AsString+' '
                                      +Mainqr.FieldByName('name').AsString+' '
                                      +Mainqr.FieldByName('sname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBPhysician.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBPhysician;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBPhysician.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edfname.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edname.Text:=Mainqr.fieldByName('name').AsString;
    fm.edsname.Text:=Mainqr.fieldByName('sname').AsString;
    fm.edseatname.Text:=Mainqr.fieldByName('seatname').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBPhysician.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBPhysician;
  filstr: string;
begin
 fm:=TfmEditRBPhysician.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindfName)<>'' then fm.edfName.Text:=FindfName;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindsName)<>'' then fm.edsName.Text:=FindsName;
  if Trim(FindseatName)<>'' then fm.edseatName.Text:=FindSeatName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindfName:=Trim(fm.edfName.Text);
    FindName:=Trim(fm.edName.Text);
    FindsName:=Trim(fm.edsName.Text);
    FindseatName:=Trim(fm.edseatName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBPhysician.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindFName:=Trim(FindFName)<>'';
    isFindName:=Trim(FindName)<>'';
    isFindSName:=Trim(FindSName)<>'';
    isFindSeatName:=Trim(FindSeatName)<>'';

    if isFindFName or isFindName or isFindSName or isFindSeatName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindFName then begin
        addstr1:=' Upper(fname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFName+'%'))+' ';
     end;

     if isFindName then begin
        addstr2:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindSName then begin
        addstr3:=' Upper(sname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSName+'%'))+' ';
     end;

     if isFindSeatName then begin
        addstr4:=' Upper(seatname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSeatName+'%'))+' ';
     end;

     if (isFindFName and isFindName)or
        (isFindFName and isFindSName)or
        (isFindFName and isFindSeatName)
       then  and1:=' and ';

     if (isFindName and isFindSName)or
        (isFindName and isFindSeatName)
       then  and2:=' and ';

     if (isFindSName and isFindSeatName)
       then  and3:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4;
end;


end.
