unit URBStorePlace;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBStorePlace = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    FirstStartForm, isFindNameStorePlace,isFindStoreType,isFindRespondents,isFindPlant,isFindAbout: Boolean;
    FindNameStorePlace,FindStoreType,FindRespondents,FindPlant,FindAbout: String;
    FindStoreType_id,FindRespondents_id,FindPlant_id: Integer;    
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
  fmRBStorePlace: TfmRBStorePlace;

implementation

uses UMainUnited, UStoreVAVCode, UStoreVAVDM, UStoreVAVData,
  StVAVKit, UEditRBStorePlace;

{$R *.DFM}

procedure TfmRBStorePlace.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkStorePlace;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  FirstStartForm:=true;

  DefLastOrderStr:=' order by NAMESTOREPLACE';

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStorePlace.FormDestroy(Sender: TObject);
begin
  inherited;
 if FormState=[fsCreatedMDIChild] then
   fmRBStorePlace:=nil;
end;

function TfmRBStorePlace.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkStorePlace+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBStorePlace.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
  cl: TColumn;

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
          grid.Columns.Clear;
          FillGridColumnsFromTb(IBDB,tbStorePlace,grid);
          FillGridColumnsFromTb(IBDB,tbStoreType,grid);
          FillGridColumnsFromTb(IBDB,tbRespondents,grid);
//          FillGridColumnsFromTb(IBDB,tbplant,grid);
         cl:=Grid.Columns.Add;
         cl.FieldName:='SmallName';
         cl.Title.Caption:='Принадлежность';
         cl.Width:=150;

          LoadFromIni;
          FirstStartForm:=false;
          ActiveQuery(false);
        end;

   SetImageFilter(isFindNameStorePlace or isFindAbout or isFindStoreType or
                  isFindRespondents or isFindPlant);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStorePlace.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if (UpperCase(Trim(fn))='ABOUT') then fn:='sp.About';
   id:=MainQr.fieldByName('StorePlace_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('StorePlace_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStorePlace.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBStorePlace.LoadFromIni;
begin
 inherited;
 try
    FindNameStorePlace:=ReadParam(ClassName,'FindNameStorePlace',FindNameStorePlace);
    FindStoreType:=ReadParam(ClassName,'FindStoreType',FindStoreType);
    FindRespondents:=ReadParam(ClassName,'FindRespondents',FindRespondents);
    FindPlant:=ReadParam(ClassName,'FindPlant',FindPlant);
    FindAbout:=ReadParam(ClassName,'About',FindAbout);
    FindStoreType_id:=ReadParam(ClassName,'FindStoreType_id',FindStoreType_id);
    FindRespondents_id:=ReadParam(ClassName,'FindRespondents_id',FindRespondents_id);
    FindPlant_id:=ReadParam(ClassName,'FindPlant_id',FindPlant_id);
    isFindNameStorePlace:=ReadParam(ClassName,'isFindNameStorePlace',isFindNameStorePlace);
    isFindStoreType:=ReadParam(ClassName,'isFindStoreType',isFindStoreType);
    isFindRespondents:=ReadParam(ClassName,'isFindRespondents',isFindRespondents);
    isFindPlant:=ReadParam(ClassName,'isFindPlant',isFindPlant);
    isFindAbout:=ReadParam(ClassName,'isFindAbout',isFindPlant);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStorePlace.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'FindNameStorePlace',FindNameStorePlace);
    WriteParam(ClassName,'FindStoreType',FindStoreType);
    WriteParam(ClassName,'FindRespondents',FindRespondents);
    WriteParam(ClassName,'FindPlant',FindPlant);
    WriteParam(ClassName,'About',FindAbout);
    WriteParam(ClassName,'FindStoreType_id',FindStoreType_id);
    WriteParam(ClassName,'FindRespondents_id',FindRespondents_id);
    WriteParam(ClassName,'FindPlant_id',FindPlant_id);
    WriteParam(ClassName,'isFindNameStorePlace',isFindNameStorePlace);
    WriteParam(ClassName,'isFindStoreType',isFindStoreType);
    WriteParam(ClassName,'isFindRespondents',isFindRespondents);
    WriteParam(ClassName,'isFindPlant',isFindPlant);
    WriteParam(ClassName,'isFindAbout',isFindPlant);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBStorePlace.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBStorePlace.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBStorePlace;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBStorePlace.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('StorePlace_id',fm.oldStorePlace_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBStorePlace.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBStorePlace;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBStorePlace.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edNameStorePlace.Text:=Mainqr.fieldByName('NameStorePlace').AsString;
    fm.edStoreType.Text:=Mainqr.fieldByName('NameStoreType').AsString;
    fm.edRespondents.Text:=Mainqr.fieldByName('FName').AsString +' ' +Mainqr.fieldByName('Name').AsString +' '+ Mainqr.fieldByName('SName').AsString ;
    fm.edPlant.Text:=Mainqr.fieldByName('SmallName').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('About').AsString;
    fm.StoreType_id:=Mainqr.fieldByName('StoreType_id').AsInteger;
    fm.Respondents_id:=Mainqr.fieldByName('Respondents_id').AsInteger;
    fm.Plant_id:=Mainqr.fieldByName('Plant_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('StorePlace_id',fm.oldStorePlace_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBStorePlace.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbStorePlace+' where StorePlace_id='+
          Mainqr.FieldByName('StorePlace_id').asString;
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
                  Pchar(CaptionDelete+' место хранения <'+Mainqr.FieldByName('Name').AsString+'> ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBStorePlace.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBStorePlace;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBStorePlace.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edNameStorePlace.Text:=Mainqr.fieldByName('NameStorePlace').AsString;
    fm.edStoreType.Text:=Mainqr.fieldByName('NameStoreType').AsString;
    fm.edRespondents.Text:=Mainqr.fieldByName('FName').AsString +' ' +Mainqr.fieldByName('Name').AsString +' '+ Mainqr.fieldByName('SName').AsString ;
    fm.edPlant.Text:=Mainqr.fieldByName('SmallName').AsString;
    fm.meAbout.Text:=Mainqr.fieldByName('About').AsString;
    fm.StoreType_id:=Mainqr.fieldByName('StoreType_id').AsInteger;
    fm.Respondents_id:=Mainqr.fieldByName('Respondents_id').AsInteger;
    fm.Plant_id:=Mainqr.fieldByName('Plant_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBStorePlace.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBStorePlace;
  filstr: string;
begin
 fm:=TfmEditRBStorePlace.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindNameStorePlace)<>'' then fm.edNameStorePlace.Text:=FindNameStorePlace;
  if Trim(FindStoreType)<>'' then
       begin
         fm.edStoreType.Text:=FindStoreType;
         fm.StoreType_id:=FindStoreType_id;
       end;
  if Trim(FindRespondents)<>'' then
       begin
         fm.edRespondents.Text:=FindRespondents;
         fm.Respondents_id:=FindRespondents_id;
       end;
  if Trim(FindPlant)<>'' then
       begin
          fm.edPlant.Text:=FindPlant;
          fm.Plant_id:=FindPlant_id;
       end;
  if Trim(FindAbout)<>'' then fm.meAbout.Text:=FindAbout;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindNameStorePlace:=Trim(fm.edNameStorePlace.Text);
    FindStoreType:=Trim(fm.edStoreType.Text);
    if (Trim(fm.edStoreType.Text)<>'') then
        FindStoreType_id:=fm.StoreType_id;
    FindRespondents:=fm.edRespondents.Text;
    if (Trim(fm.edRespondents.Text)<>'') then
        FindRespondents_id:=fm.Respondents_id;
    FindPlant:=fm.edPlant.Text;
    if (Trim(fm.edPlant.Text)<>'') then
        FindPlant_id:=fm.Plant_id;
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

function TfmRBStorePlace.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5: string;
  and1,and2,and3,and4: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;


    isFindNameStorePlace :=trim(FindNameStorePlace)<>'';
    isFindStoreType :=trim(FindStoreType)<>'';
    isFindRespondents :=trim(FindRespondents)<>'';
    isFindPlant :=trim(FindPlant)<>'';
    isFindAbout:=trim(FindAbout)<>'';

    if isFindNameStorePlace or isFindStoreType or isFindRespondents or isFindPlant or
       isFindAbout then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNameStorePlace then begin
        addstr1:=' Upper(nameStorePlace) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNameStorePlace +'%'))+' ';
     end;
     if isFindStoreType then begin
        addstr2:=' sp.StoreType_id =  '+IntToStr(FindStoreType_id) +' ';
     end;
     if isFindRespondents then begin
        addstr3:=' sp.Respondents_id =  '+IntToStr(FindRespondents_id) +' ';
     end;
     if isFindPlant then begin
        addstr4:=' sp.Plant_id =  '+IntToStr(FindPlant_id) +' ';
     end;
     if isFindAbout then begin
        addstr5:=' Upper(about) like '+AnsiUpperCase(QuotedStr(FilInSide+FindAbout+'%'))+' ';
     end;

     if (isFindNameStorePlace and (isFindAbout or isFindStoreType or isFindRespondents or isFindPlant)) then
         and1:=' and ';
     if (isFindStoreType and isFindRespondents) then
         and2:=' and ';
     if (isFindRespondents and isFindPlant) then
         and3:=' and ';
     if (isFindPlant and isFindAbout) then
         and4:=' and ';

     Result:=wherestr+addstr1+and1+addstr2+and2+addstr3+and3+addstr4+and4+addstr5;
end;


end.
