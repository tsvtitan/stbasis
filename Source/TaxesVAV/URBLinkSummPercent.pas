unit URBLinkSummPercent;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBLinkSummPercent = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    FirstStartForm,isFindLinkSummPercent, isFindParentProperties: Boolean;
    FindLinkSummPercent,FindParentProperties: String;
    FindParentProperties_id: Integer;
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
  fmRBLinkSummPercent: TfmRBLinkSummPercent;

implementation

uses UMainUnited, UTaxesVAVCode, UTaxesVAVDM, UTaxesVAVData, UEditRBLinkSummPercent,
  StVAVKit;

{$R *.DFM}

procedure TfmRBLinkSummPercent.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkLinkSummPercent;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  FirstStartForm:=true;

{  cl:=Grid.Columns.Add;
  cl.FieldName:='numrelease';
  cl.Title.Caption:='Номер выпуска';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='daterelease';
  cl.Title.Caption:='Дата выпуска';
  cl.Width:=80;

  cl:=Grid.Columns.Add;
  cl.FieldName:='about';
  cl.Title.Caption:='Примечание';
  cl.Width:=150;}

  DefLastOrderStr:=' order by v.LinkSummPercent_id';

//  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLinkSummPercent.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBLinkSummPercent:=nil;
end;

function TfmRBLinkSummPercent.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkLinkSummPercent+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBLinkSummPercent.ActiveQuery(CheckPerm: Boolean);
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
          FillGridColumnsFromTb(IBDB,tbLinkSummPercent,grid);
          LoadFromIni;
          FirstStartForm:=false;
          ActiveQuery(false);
        end;

   SetImageFilter(isFindLinkSummPercent or isFindParentProperties);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLinkSummPercent.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('release_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('release_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLinkSummPercent.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBLinkSummPercent.LoadFromIni;
begin
 inherited;
 try
    FindLinkSummPercent:=ReadParam(ClassName,'LinkSummPercent',FindLinkSummPercent);
    FindParentProperties:=ReadParam(ClassName,'ParentProperties',FindParentProperties);
    FindParentProperties_id:=ReadParam(ClassName,'ParentProperties_id',FindParentProperties_id);

    isFindLinkSummPercent:=ReadParam(ClassName,'isFindLinkSummPercent',isFindLinkSummPercent);
    isFindParentProperties:=ReadParam(ClassName,'isFindParentProperties',isFindParentProperties);

    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLinkSummPercent.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'LinkSummPercent',FindLinkSummPercent);
    WriteParam(ClassName,'ParentProperties',FindParentProperties);
    WriteParam(ClassName,'ParentProperties_id',FindParentProperties_id);
    WriteParam(ClassName,'isFindLinkSummPercent',isFindLinkSummPercent);
    WriteParam(ClassName,'isFindParentProperties',isFindParentProperties);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBLinkSummPercent.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBLinkSummPercent.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBLinkSummPercent;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBLinkSummPercent.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('LinkSummPercent_id',fm.oldLinkSummPercent_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBLinkSummPercent.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBLinkSummPercent;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBLinkSummPercent.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edLinkSummPercent.Text:=Mainqr.fieldByName('LinkSummPercent').AsString;
    fm.ParentProperties_id:=Mainqr.fieldByName('properties_id').AsInteger;
    if (fm.ParentProperties_id<>0) then
          fm.edNameTaxes.Text:=Mainqr.fieldByName('nameproperties').AsString;
    fm.oldLinkSummPercent_id:=MainQr.FieldByName('LinkSummPercent_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('LinkSummPercent_id',fm.oldLinkSummPercent_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBLinkSummPercent.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbLinkSummPercent+' where LinkSummPercent_id='+
          Mainqr.FieldByName('LinkSummPercent_id').asString;
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
                  Pchar(CaptionDelete+' выпуск № <'+Mainqr.FieldByName('numrelease').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBLinkSummPercent.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBLinkSummPercent;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBLinkSummPercent.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edLinkSummPercent.Text:=Mainqr.fieldByName('LinkSummPercent').AsString;
    fm.ParentProperties_id:=Mainqr.fieldByName('properties_id').AsInteger;
        if (fm.ParentProperties_id<>0) then
          fm.edNameTaxes.Text:=Mainqr.fieldByName('nameproperties').AsString;
    fm.oldLinkSummPercent_id:=MainQr.FieldByName('LinkSummPercent_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBLinkSummPercent.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBLinkSummPercent;
  filstr: string;
begin
 fm:=TfmEditRBLinkSummPercent.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindLinkSummPercent)<>'' then fm.edLinkSummPercent.Text:=FindLinkSummPercent;
  if Trim(FindParentProperties)<>'' then
      begin
         fm.edNameTaxes.Text:=FindParentProperties;
         fm.ParentProperties_id:=FindParentProperties_id;
      end;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindLinkSummPercent:=Trim(fm.edLinkSummPercent.Text);
    FindParentProperties:=Trim(fm.edNameTaxes.Text);
    FindParentProperties_id:=fm.ParentProperties_id;

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBLinkSummPercent.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    if (Trim(FindLinkSummPercent)<>'') then isFindLinkSummPercent:=true else isFindLinkSummPercent:=false ;
    if (Trim(FindParentProperties)<>'') then isFindParentProperties:=true else isFindParentProperties:=false;
//    isFindLinkSummPercent:=isInteger(FindLinkSummPercent);
//    isFindParentProperties:=isInteger(FindParentProperties);

    if isFindLinkSummPercent or
       isFindParentProperties then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindLinkSummPercent then begin
        addstr1:=' Upper(LinkSummPercent) like '+AnsiUpperCase(QuotedStr(FilInSide+FindLinkSummPercent+'%'))+' ';
     end;

     if isFindParentProperties then begin
        addstr2:=' v.properties_id ='+IntToStr(FindParentProperties_id)+' ';
     end;

     if (isFindLinkSummPercent and isFindParentProperties) then
      and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;


end.
