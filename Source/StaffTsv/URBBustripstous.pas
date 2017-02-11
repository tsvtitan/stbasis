unit URBBustripstous;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBBustripstous = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindPlantName,isFindSeatName,isFindFName,isFindName,isFindSName: Boolean;
    FindPlantName, FindSeatName, FindFName, FindName, FindSName: string;
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
  fmRBBustripstous: TfmRBBustripstous;

implementation

uses UMainUnited, UStaffTsvCode, UStaffTsvDM, UStaffTsvData, UEditRBBustripstous;

{$R *.DFM}

procedure TfmRBBustripstous.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkBustripstous;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='plantname';
  cl.Title.Caption:='Откуда';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='seatname';
  cl.Title.Caption:='Должность';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fname';
  cl.Title.Caption:='Фамилия';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Имя';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sname';
  cl.Title.Caption:='Отчество';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='datestart';
  cl.Title.Caption:='Дата прибытия';
  cl.Width:=80;

  cl:=Grid.Columns.Add;
  cl.FieldName:='datefinish';
  cl.Title.Caption:='Дата выбытия';
  cl.Width:=80;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBustripstous.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBBustripstous:=nil;
end;

function TfmRBBustripstous.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkBustripstous+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBBustripstous.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindPlantName or isFindSeatName or isFindFName
                  or isFindName or isFindSName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBustripstous.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('bustripstous_id').asString;
   if UpperCase(fn)=UpperCase('plantname') then fn:='p.smallname';
   if UpperCase(fn)=UpperCase('seatname') then fn:='s.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('bustripstous_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBustripstous.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBBustripstous.LoadFromIni;
begin
 inherited;
 try
    FindPlantName:=ReadParam(ClassName,'plantname',FindPlantName);
    FindSeatName:=ReadParam(ClassName,'seatname',FindSeatName);
    FindFName:=ReadParam(ClassName,'fname',FindFName);
    FindName:=ReadParam(ClassName,'name',FindName);
    FindSName:=ReadParam(ClassName,'sname',FindSName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBustripstous.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'plantname',FindPlantName);
    WriteParam(ClassName,'seatname',FindSeatName);
    WriteParam(ClassName,'fname',FindFName);
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'sname',FindSName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBBustripstous.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBBustripstous.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBBustripstous;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBBustripstous.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('bustripstous_id',fm.oldbustripstous_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBustripstous.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBBustripstous;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBBustripstous.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edPlant.Text:=Mainqr.fieldByName('plantname').AsString;
    fm.plant_id:=Mainqr.fieldByName('plant_id').AsInteger;
    fm.edSeat.Text:=Mainqr.fieldByName('seatname').AsString;
    fm.seat_id:=Mainqr.fieldByName('seat_id').AsInteger;
    fm.edFname.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edname.Text:=Mainqr.fieldByName('name').AsString;
    fm.edsname.Text:=Mainqr.fieldByName('sname').AsString;
    fm.dtpDateStart.Date:=Mainqr.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.Date:=Mainqr.fieldByName('datefinish').AsDateTime;
    fm.oldbustripstous_id:=Mainqr.fieldByName('bustripstous_id').AsInteger;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('bustripstous_id',fm.oldbustripstous_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBustripstous.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbBustripstous+' where bustripstous_id='+
          Mainqr.FieldByName('bustripstous_id').asString;
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
  but:=DeleteWarningEx('текущую командировку ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBBustripstous.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBBustripstous;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBBustripstous.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edPlant.Text:=Mainqr.fieldByName('plantname').AsString;
    fm.plant_id:=Mainqr.fieldByName('plant_id').AsInteger;
    fm.edSeat.Text:=Mainqr.fieldByName('seatname').AsString;
    fm.seat_id:=Mainqr.fieldByName('seat_id').AsInteger;
    fm.edFname.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edname.Text:=Mainqr.fieldByName('name').AsString;
    fm.edsname.Text:=Mainqr.fieldByName('sname').AsString;
    fm.dtpDateStart.Date:=Mainqr.fieldByName('datestart').AsDateTime;
    fm.dtpDateFinish.Date:=Mainqr.fieldByName('datefinish').AsDateTime;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBBustripstous.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBBustripstous;
  filstr: string;
begin
 fm:=TfmEditRBBustripstous.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edPlant.ReadOnly:=false;
  fm.edPlant.Color:=clWindow;
  fm.edSeat.ReadOnly:=false;
  fm.edSeat.Color:=clWindow;
  fm.dtpDateStart.Color:=clBtnFace;
  fm.dtpDateStart.Enabled:=false;
  fm.dtpDateFinish.Color:=clBtnFace;
  fm.dtpDateFinish.Enabled:=false;

  if Trim(FindPlantName)<>'' then fm.edPlant.Text:=FindPlantName;
  if Trim(FindSeatName)<>'' then fm.edSeat.Text:=FindSeatName;
  if Trim(FindFName)<>'' then fm.edFname.Text:=FindFName;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindSName)<>'' then fm.edSName.Text:=FindSName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindPlantName:=Trim(fm.edPlant.Text);
    FindSeatName:=Trim(fm.edSeat.Text);
    FindFName:=Trim(fm.edFName.Text);
    FindName:=Trim(fm.edName.Text);
    FindSName:=Trim(fm.edSName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBBustripstous.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5: string;
  and1,and2,and3,and4: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindFName:=Trim(FindFName)<>'';
    isFindName:=Trim(FindName)<>'';
    isFindSName:=Trim(FindSName)<>'';
    isFindPlantName:=Trim(FindPlantName)<>'';
    isFindSeatName:=Trim(FindSeatName)<>'';

    if isFindFName or isFindName or isFindSName
       or isFindPlantName or isFindSeatName then begin
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

     if isFindPlantName then begin
        addstr4:=' Upper(p.smallname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPlantName+'%'))+' ';
     end;

     if isFindSeatName then begin
        addstr5:=' Upper(s.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSeatName+'%'))+' ';
     end;


     if (isFindFName and isFindName)or
        (isFindFName and isFindSName)or
        (isFindFName and isFindPlantName)or
        (isFindFName and isFindSeatName)
        then and1:=' and ';

     if (isFindName and isFindSName)or
        (isFindName and isFindPlantName)or
        (isFindName and isFindSeatName)
        then and2:=' and ';

     if (isFindSName and isFindPlantName)or
        (isFindSName and isFindSeatName)
        then and3:=' and ';

     if (isFindPlantName and isFindSeatName)
        then and4:=' and ';


     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5;
end;


end.
