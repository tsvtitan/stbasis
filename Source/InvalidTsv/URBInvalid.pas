unit URBInvalid;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL, grids;

type
   TfmRBInvalid = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    isFindfname,isFindname,isFindsname,isFindAddress: Boolean;
    Findfname,Findname,Findsname,FindAddress: String;
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
  fmRBInvalid: TfmRBInvalid;

implementation

uses UMainUnited, UInvalidTsvCode, UInvalidTsvDM, UInvalidTsvData, UEditRBInvalid;

{$R *.DFM}

procedure TfmRBInvalid.FormCreate(Sender: TObject);
var
  cl: TColumn;
  ifl: TIntegerField;
  sfl: TStringField;
  dfl: TDateField;
begin
 inherited;
 try
  Caption:=NameRbkInvalid;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  Grid.OnDrawColumnCell:=GridDrawColumnCell;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='invalid_id';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='fname';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainSmallNameLength;
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='fname';
  cl.Title.Caption:='Фамилия';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='name';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainSmallNameLength;

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Имя';
  cl.Width:=150;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='sname';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainSmallNameLength;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sname';
  cl.Title.Caption:='Отчество';
  cl.Width:=150;

  dfl:=TDateField.Create(nil);
  dfl.FieldName:='birthdate';
  dfl.DisplayFormat:='yyyy';
  dfl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='birthdate';
  cl.Title.Caption:='Год рождения';
  cl.Width:=100;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='address';
  sfl.DataSet:=Mainqr;
  sfl.Size:=DomainNameLength;

  cl:=Grid.Columns.Add;
  cl.FieldName:='address';
  cl.Title.Caption:='Адрес';
  cl.Width:=150;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='childhood';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='childhoodplus';
  cl.Title.Caption:='Инвалид детства';
  cl.Width:=80;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='uvo';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='uvoplus';
  cl.Title.Caption:='УВО';
  cl.Width:=80;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='ivo';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='ivoplus';
  cl.Title.Caption:='ИВО';
  cl.Width:=80;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='autotransport';
  ifl.Visible:=false;
  ifl.DataSet:=Mainqr;

  cl:=Grid.Columns.Add;
  cl.FieldName:='autotransportplus';
  cl.Title.Caption:='Автотранспорт';
  cl.Width:=80;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInvalid.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBInvalid:=nil;
end;

function TfmRBInvalid.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkInvalid+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBInvalid.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindfname or isFindname or isFindsname or isFindAddress);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInvalid.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('invalid_id').asString;
   if AnsiSameText(fn,'childhoodplus') then fn:='childhood';
   if AnsiSameText(fn,'ivoplus') then fn:='ivo';
   if AnsiSameText(fn,'uvoplus') then fn:='uvo';
   if AnsiSameText(fn,'autotransportplus') then fn:='autotransport';
   if AnsiSameText(fn,'autotransportplus') then fn:='autotransport';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('invalid_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInvalid.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBInvalid.LoadFromIni;
begin
 inherited;
 try
    Findfname:=ReadParam(ClassName,'fname',Findfname);
    Findname:=ReadParam(ClassName,'name',Findname);
    Findsname:=ReadParam(ClassName,'sname',Findsname);
    FindAddress:=ReadParam(ClassName,'Address',FindAddress);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInvalid.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'fname',Findfname);
    WriteParam(ClassName,'name',Findname);
    WriteParam(ClassName,'sname',Findsname);
    WriteParam(ClassName,'Address',FindAddress);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBInvalid.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBInvalid.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBInvalid;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBInvalid.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('invalid_id',fm.oldinvalid_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInvalid.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBInvalid;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBInvalid.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edfname.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edname.Text:=Mainqr.fieldByName('name').AsString;
    fm.edsname.Text:=Mainqr.fieldByName('sname').AsString;
    fm.dtpBirthDate.DateTime:=Mainqr.fieldByName('birthdate').AsDateTime;
    fm.SetYearByDate;
    fm.edAddress.Text:=Mainqr.fieldByName('address').AsString;
    fm.chbChildHood.Checked:=Boolean(Mainqr.fieldByName('childhood').AsInteger);
    fm.chbIVO.Checked:=Boolean(Mainqr.fieldByName('ivo').AsInteger);
    fm.chbUVO.Checked:=Boolean(Mainqr.fieldByName('uvo').AsInteger);
    fm.chbAutotransport.Checked:=Boolean(Mainqr.fieldByName('autotransport').AsInteger);
    fm.oldinvalid_id:=MainQr.FieldByName('invalid_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('invalid_id',fm.oldinvalid_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInvalid.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbInvalid+' where invalid_id='+
          Mainqr.FieldByName('invalid_id').asString;
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
  but:=DeleteWarningEx('инвалида c ФИО <'+Mainqr.FieldByName('fname').AsString+' '
                                         +Mainqr.FieldByName('name').AsString+' '
                                         +Mainqr.FieldByName('sname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBInvalid.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBInvalid;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBInvalid.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edfname.Text:=Mainqr.fieldByName('fname').AsString;
    fm.edname.Text:=Mainqr.fieldByName('name').AsString;
    fm.edsname.Text:=Mainqr.fieldByName('sname').AsString;
    fm.dtpBirthDate.DateTime:=Mainqr.fieldByName('birthdate').AsDateTime;
    fm.SetYearByDate;
    fm.edAddress.Text:=Mainqr.fieldByName('address').AsString;
    fm.chbChildHood.Checked:=Boolean(Mainqr.fieldByName('childhood').AsInteger);
    fm.chbIVO.Checked:=Boolean(Mainqr.fieldByName('ivo').AsInteger);
    fm.chbUVO.Checked:=Boolean(Mainqr.fieldByName('uvo').AsInteger);
    fm.chbAutotransport.Checked:=Boolean(Mainqr.fieldByName('autotransport').AsInteger);
    fm.oldinvalid_id:=MainQr.FieldByName('invalid_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBInvalid.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBInvalid;
  filstr: string;
begin
 fm:=TfmEditRBInvalid.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.dtpBirthDate.Enabled:=false;
  fm.dtpBirthDate.Color:=clBtnFace;
  fm.meYear.Enabled:=false;
  fm.meYear.Color:=clBtnFace;
  fm.chbChildHood.Enabled:=false;
  fm.chbIVO.Enabled:=false;
  fm.chbUVO.Enabled:=false;
  fm.chbAutotransport.Enabled:=false;


  if Trim(FindfName)<>'' then fm.edfName.Text:=FindfName;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindsName)<>'' then fm.edsName.Text:=FindsName;
  if Trim(FindAddress)<>'' then fm.edAddress.Text:=FindAddress;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindfName:=Trim(fm.edfName.Text);
    FindName:=Trim(fm.edName.Text);
    FindsName:=Trim(fm.edsName.Text);
    FindAddress:=Trim(fm.edAddress.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBInvalid.GetFilterString: string;
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
    isFindAddress:=Trim(FindAddress)<>'';

    if isFindFName or isFindName or isFindSName or isFindAddress then begin
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

     if isFindAddress then begin
        addstr4:=' Upper(address) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAddress+'%'))+' ';
     end;

     if (isFindFName and isFindName)or
        (isFindFName and isFindSName)or
        (isFindFName and isFindAddress)
       then  and1:=' and ';

     if (isFindName and isFindSName)or
        (isFindName and isFindAddress)
       then  and2:=' and ';

     if (isFindSName and isFindAddress)
       then  and3:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4;
end;

procedure TfmRBInvalid.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
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
  if Column.Title.Caption='Инвалид детства' then begin
    chk:=Boolean(Mainqr.FieldByName('childhood').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
  if Column.Title.Caption='УВО' then begin
    chk:=Boolean(Mainqr.FieldByName('uvo').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
  if Column.Title.Caption='ИВО' then begin
    chk:=Boolean(Mainqr.FieldByName('ivo').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
  if Column.Title.Caption='Автотранспорт' then begin
    chk:=Boolean(Mainqr.FieldByName('autotransport').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;

procedure TfmRBInvalid.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if MainQr.IsEmpty then exit;
  if grid.SelectedField=nil then exit;
  if not AnsiSameText(grid.SelectedField.FullName,'birthdate') then
    inherited;
end;

end.
