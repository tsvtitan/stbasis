unit URBTaxesType;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBTaxesType = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    FirstStartForm, isFindNameTAxes,isFindStatusTaxes: Boolean;
    FindStatusTaxes:Integer;
    FindNameTaxes: String;
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
  fmRBTaxesType: TfmRBTaxesType;

implementation

uses UMainUnited, UTaxesVAVCode, UTaxesVAVDM, UTaxesVAVData, UEditRBTaxesType,
  StVAVKit;

{$R *.DFM}

procedure TfmRBTaxesType.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkTaxesType;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

{  cl:=Grid.Columns.Add;
  cl.FieldName:='numrelease';
  cl.Title.Caption:='Ќомер выпуска';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='daterelease';
  cl.Title.Caption:='ƒата выпуска';
  cl.Width:=80;

  cl:=Grid.Columns.Add;
  cl.FieldName:='about';
  cl.Title.Caption:='ѕримечание';
  cl.Width:=150;}
  FirstStartForm:=true;

  DefLastOrderStr:=' order by nametaxes';

//  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTaxesType.FormDestroy(Sender: TObject);
begin
  inherited;
 if FormState=[fsCreatedMDIChild] then
   fmRBTaxesType:=nil;
end;

function TfmRBTaxesType.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkTaxesType+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBTaxesType.ActiveQuery(CheckPerm: Boolean);
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
          FillGridColumnsFromTb(IBDB,tbTaxesType,grid);
          LoadFromIni;
          FirstStartForm:=false;
          ActiveQuery(false);
        end;

   SetImageFilter(isFindNameTAxes or isFindStatusTaxes);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTaxesType.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('TAXESTYPE_ID').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('TAXESTYPE_ID',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTaxesType.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBTaxesType.LoadFromIni;
begin
 inherited;
 try
    FindNameTaxes:=ReadParam(ClassName,'NAMETAXES',FindNameTaxes);
    FindStatusTaxes:=ReadParam(ClassName,'StatusTaxes',FindStatusTaxes);
    isFindNameTaxes:=ReadParam(ClassName,'isFindNameTaxes',isFindNameTaxes);
    isFindStatusTaxes:=ReadParam(ClassName,'isFindAbout',isFindStatusTaxes);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTaxesType.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'NameTaxes',FindNameTaxes);
    WriteParam(ClassName,'isFindNameTAxes',isFindNameTAxes);
    WriteParam(ClassName,'StatusTaxes',FindStatusTaxes);
    WriteParam(ClassName,'isFindAbout',isFindStatusTaxes);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBTaxesType.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBTaxesType.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBTaxesType;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBTaxesType.Create(nil);
  try
    fm.RGStatusTaxes.Items.Clear;
    fm.RGStatusTaxes.Items.Add('налог с физических лиц');
    fm.RGStatusTaxes.Items.Add('налог с юридических лиц');
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('TaxesType_id',fm.oldTaxesType_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTaxesType.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBTaxesType;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTaxesType.Create(nil);
  try
    fm.RGStatusTaxes.Items.Clear;
    fm.RGStatusTaxes.Items.Add('налог с физических лиц');
    fm.RGStatusTaxes.Items.Add('налог с юридических лиц');
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edNameTaxes.Text:=Mainqr.fieldByName('NameTaxes').AsString;
    fm.RGStatusTaxes.ItemIndex:=Mainqr.fieldByName('StatusTaxes').AsInteger;
    fm.ChangeFlag:=false;
    fm.oldTaxesType_id:=Mainqr.fieldByName('TaxesType_id').AsInteger;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('TaxesType_id',fm.oldTaxesType_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTaxesType.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbTaxesType+' where TaxesType_id='+
          Mainqr.FieldByName('TaxesType_id').asString;
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
                  Pchar(CaptionDelete+' место хранени€ <'+Mainqr.FieldByName('NameTaxes').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBTaxesType.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBTaxesType;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBTaxesType.Create(nil);
  try
    fm.RGStatusTaxes.Items.Clear;
    fm.RGStatusTaxes.Items.Add('налог с физических лиц');
    fm.RGStatusTaxes.Items.Add('налог с юридических лиц');
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edNameTaxes.Text:=Mainqr.fieldByName('NameTaxes').AsString;
    fm.RGStatusTaxes.ItemIndex:=Mainqr.fieldByName('StatusTaxes').AsInteger;
       if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBTaxesType.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBTaxesType;
  filstr: string;
begin
 fm:=TfmEditRBTaxesType.Create(nil);
 try
    fm.RGStatusTaxes.Items.Clear;
    fm.RGStatusTaxes.Items.Add('налог с физических лиц');
    fm.RGStatusTaxes.Items.Add('налог с юридических лиц');
    fm.RGStatusTaxes.Items.Add('все налоги');
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindNameTaxes)<>'' then fm.edNameTaxes.Text:=FindNameTaxes;
  fm.RGStatusTaxes.ItemIndex:=FindStatusTaxes;


  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNameTaxes:=Trim(fm.edNameTaxes.Text);
    FindStatusTaxes:=fm.RGStatusTaxes.ItemIndex;


    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBTaxesType.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4: string;
  and1,and2,and3: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;


    isFindNameTAxes :=trim(FindNameTaxes)<>'';
    isFindStatusTaxes:=FindStatusTaxes<>2;

    if isFindNameTAxes or
       isFindStatusTaxes then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNameTAxes then begin
        addstr1:=' Upper(nameTaxes) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNameTaxes +'%'))+' ';
     end;

     if isFindStatusTaxes then begin
        addstr2:=' StatusTaxes = '+IntToStr(FindStatusTaxes)+' ';
     end;


     if (isFindNameTAxes and isFindStatusTaxes) then
         and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;


end.
