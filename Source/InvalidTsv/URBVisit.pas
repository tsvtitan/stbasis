unit URBVisit;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL;

type
   TfmRBVisit = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindInvalidFio,isFindInvalidGroupName,isFindPhysicianFio,isFindViewPlaceName,isFindInvalidCategoryName,isFindSickGroupName,
    isFindVisitDateFrom,isFindVisitDateTo,isFindComingInvalidGroupName,isFindOrdinalNumber,isFindBranchName: Boolean;
    FindInvalidFio,FindInvalidGroupName,FindPhysicianFio,FindViewPlaceName,
    FindInvalidCategoryName,FindSickGroupName,FindComingInvalidGroupName,FindOrdinalNumber,FindBranchName: string;
    FindVisitDateFrom,FindVisitDateTo: TDateTime;
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
  fmRBVisit: TfmRBVisit;

implementation

uses UMainUnited, UInvalidTsvCode, UInvalidTsvDM, UInvalidTsvData, UEditRBVisit;

{$R *.DFM}

procedure TfmRBVisit.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkVisit;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='ordinalnumber';
  cl.Title.Caption:='Номер по порядку';
  cl.Width:=60;

  cl:=Grid.Columns.Add;
  cl.FieldName:='visitdate';
  cl.Title.Caption:='Дата посещения';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='invalidfio';
  cl.Title.Caption:='ФИО инвалида';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='cominginvalidgroupname';
  cl.Title.Caption:='Является инвалидом';
  cl.Width:=100;
  
  cl:=Grid.Columns.Add;
  cl.FieldName:='invalidgroupname';
  cl.Title.Caption:='Установленная группа';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sickgroupname';
  cl.Title.Caption:='Группа болезни';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='sickname';
  cl.Title.Caption:='Болезнь';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='physicianfio';
  cl.Title.Caption:='Врач';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='viewplacename';
  cl.Title.Caption:='Место осмотра';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='invalidcategoryname';
  cl.Title.Caption:='Категория';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='branchname';
  cl.Title.Caption:='Отделение';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='inputdate';
  cl.Title.Caption:='Дата ввода';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='determinationdate';
  cl.Title.Caption:='Дата установления инвалидности';
  cl.Width:=100;

//  DefLastOrderStr:=' order by ordinalnumber, visitdate ';

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBVisit.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBVisit:=nil;
end;

function TfmRBVisit.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkVisit+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBVisit.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindInvalidFio or isFindInvalidGroupName or isFindPhysicianFio or
                  isFindViewPlaceName or isFindInvalidCategoryName or isFindSickGroupName or
                  isFindVisitDateFrom or isFindVisitDateTo or isFindComingInvalidGroupName or
                  isFindOrdinalNumber or isFindBranchName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBVisit.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('visit_id').asString;
   if AnsiSameText(fn,'sickgroupname') then fn:='sg.name';
   if AnsiSameText(fn,'invalidfio') then fn:='2';
   if AnsiSameText(fn,'invalidbirthdate') then fn:='i.birthdate';
   if AnsiSameText(fn,'invalidcategoryname') then fn:='ic.name';
   if AnsiSameText(fn,'physicianfio') then fn:='5';
   if AnsiSameText(fn,'viewplacename') then fn:='vp.name';
   if AnsiSameText(fn,'invalidgroupname') then fn:='ig.name';
   if AnsiSameText(fn,'cominginvalidgroupname') then fn:='ig1.name';
   if AnsiSameText(fn,'branchname') then fn:='b.name';

   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('visit_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBVisit.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBVisit.LoadFromIni;
begin
 inherited;
 try
    FindInvalidFio:=ReadParam(ClassName,'InvalidFio',FindInvalidFio);
    FindInvalidGroupName:=ReadParam(ClassName,'InvalidGroupName',FindInvalidGroupName);
    FindPhysicianFio:=ReadParam(ClassName,'PhysicianFio',FindPhysicianFio);
    FindViewPlaceName:=ReadParam(ClassName,'ViewPlaceName',FindViewPlaceName);
    FindInvalidCategoryName:=ReadParam(ClassName,'InvalidCategoryName',FindInvalidCategoryName);
    FindSickGroupName:=ReadParam(ClassName,'SickName',FindSickGroupName);
    FindVisitDateFrom:=ReadParam(ClassName,'VisitDateFrom',FindVisitDateFrom);
    isFindVisitDateFrom:=ReadParam(ClassName,'isVisitDateFrom',isFindVisitDateFrom);
    FindVisitDateTo:=ReadParam(ClassName,'VisitDateTo',FindVisitDateTo);
    isFindVisitDateTo:=ReadParam(ClassName,'isVisitDateTo',isFindVisitDateTo);
    FindComingInvalidGroupName:=ReadParam(ClassName,'ComingInvalidGroupName',FindComingInvalidGroupName);
    FindOrdinalNumber:=ReadParam(ClassName,'OrdinalNumber',FindOrdinalNumber);
    FindBranchName:=ReadParam(ClassName,'BranchName',FindBranchName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBVisit.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'InvalidFio',FindInvalidFio);
    WriteParam(ClassName,'InvalidGroupName',FindInvalidGroupName);
    WriteParam(ClassName,'PhysicianFio',FindPhysicianFio);
    WriteParam(ClassName,'ViewPlaceName',FindViewPlaceName);
    WriteParam(ClassName,'InvalidCategoryName',FindInvalidCategoryName);
    WriteParam(ClassName,'SickName',FindSickGroupName);
    WriteParam(ClassName,'VisitDateFrom',FindVisitDateFrom);
    WriteParam(ClassName,'isVisitDateFrom',isFindVisitDateFrom);
    WriteParam(ClassName,'VisitDateTo',FindVisitDateTo);
    WriteParam(ClassName,'isVisitDateTo',isFindVisitDateTo);
    WriteParam(ClassName,'ComingInvalidGroupName',FindComingInvalidGroupName);
    WriteParam(ClassName,'OrdinalNumber',FindOrdinalNumber);
    WriteParam(ClassName,'BranchName',FindBranchName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBVisit.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBVisit.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBVisit;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBVisit.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.FillOrdinalNumber;
    fm.FillInvalidGroup;
    fm.FillPhysician;
    fm.FillViewPlace;
    fm.FillInvalidCategory;
    fm.FillBranch;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('visit_id',fm.oldvisit_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBVisit.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBVisit;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBVisit.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;

    fm.edOrdinal.Text:=Mainqr.fieldByName('ordinalnumber').AsString;
    fm.dtpVisitDate.DateTime:=Mainqr.fieldByName('visitdate').AsDateTime;
    fm.edInvalidFio.Text:=Mainqr.fieldByName('invalidfio').AsString;
    fm.invalid_id:=Mainqr.fieldByName('invalid_id').AsInteger;
    fm.FillInvalidGroup;
    fm.cmbInvalidGroup.ItemIndex:=fm.cmbInvalidGroup.Items.IndexOf(Mainqr.fieldByName('invalidgroupname').AsString);
    fm.cmbComingInvalidGroup.ItemIndex:=fm.cmbComingInvalidGroup.Items.IndexOf(Mainqr.fieldByName('cominginvalidgroupname').AsString);
    fm.edSickGroup.Text:=Mainqr.fieldByName('sickgroupname').AsString;
    fm.sickgroup_id:=Mainqr.fieldByName('sickgroup_id').AsInteger;
    fm.edSick.Text:=Mainqr.fieldByName('sickname').AsString;
    fm.dtpDeterminationDate.DateTime:=Mainqr.fieldByName('determinationdate').AsDateTime;
    fm.FillPhysician;
    fm.cmbPhysician.ItemIndex:=fm.cmbPhysician.Items.IndexOf(Mainqr.fieldByName('physicianfio').AsString);
    fm.FillViewPlace;
    fm.cmbViewPlace.ItemIndex:=fm.cmbViewPlace.Items.IndexOf(Mainqr.fieldByName('viewplacename').AsString);
    fm.FillInvalidCategory;
    fm.cmbInvalidCategory.ItemIndex:=fm.cmbInvalidCategory.Items.IndexOf(Mainqr.fieldByName('invalidcategoryname').AsString);
    fm.FillBranch;
    fm.cmbBranch.ItemIndex:=fm.cmbBranch.Items.IndexOf(Mainqr.fieldByName('branchname').AsString);

    fm.rbFirstUvo.Checked:=Mainqr.fieldByName('firstuvo').AsInteger=1;
    fm.autotransport:=Mainqr.fieldByName('autotransport').AsInteger=1;

    fm.oldvisit_id:=MainQr.FieldByName('visit_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('visit_id',fm.oldvisit_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBVisit.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbVisit+' where visit_id='+
          Mainqr.FieldByName('visit_id').asString;
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
  but:=DeleteWarningEx('посещение <'+Mainqr.FieldByName('invalidfio').AsString+'> за '+
                                     Mainqr.FieldByName('visitdate').AsString+' ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBVisit.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBVisit;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBVisit.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edOrdinal.Text:=Mainqr.fieldByName('ordinalnumber').AsString;
    fm.dtpVisitDate.DateTime:=Mainqr.fieldByName('visitdate').AsDateTime;
    fm.edInvalidFio.Text:=Mainqr.fieldByName('invalidfio').AsString;
    fm.invalid_id:=Mainqr.fieldByName('invalid_id').AsInteger;
    fm.FillInvalidGroup;
    fm.cmbInvalidGroup.ItemIndex:=fm.cmbInvalidGroup.Items.IndexOf(Mainqr.fieldByName('invalidgroupname').AsString);
    fm.cmbComingInvalidGroup.ItemIndex:=fm.cmbComingInvalidGroup.Items.IndexOf(Mainqr.fieldByName('cominginvalidgroupname').AsString);
    fm.edSickGroup.Text:=Mainqr.fieldByName('sickgroupname').AsString;
    fm.sickgroup_id:=Mainqr.fieldByName('sickgroup_id').AsInteger;
    fm.edSick.Text:=Mainqr.fieldByName('sickname').AsString;
    fm.dtpDeterminationDate.DateTime:=Mainqr.fieldByName('determinationdate').AsDateTime;
    fm.FillPhysician;
    fm.cmbPhysician.ItemIndex:=fm.cmbPhysician.Items.IndexOf(Mainqr.fieldByName('physicianfio').AsString);
    fm.FillViewPlace;
    fm.cmbViewPlace.ItemIndex:=fm.cmbViewPlace.Items.IndexOf(Mainqr.fieldByName('viewplacename').AsString);
    fm.FillInvalidCategory;
    fm.cmbInvalidCategory.ItemIndex:=fm.cmbInvalidCategory.Items.IndexOf(Mainqr.fieldByName('invalidcategoryname').AsString);
    fm.FillBranch;
    fm.cmbBranch.ItemIndex:=fm.cmbBranch.Items.IndexOf(Mainqr.fieldByName('branchname').AsString);
    fm.rbFirstUvo.Checked:=Mainqr.fieldByName('firstuvo').AsInteger=1;
    fm.autotransport:=Mainqr.fieldByName('autotransport').AsInteger=1;

    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBVisit.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBVisit;
  filstr: string;
begin
 fm:=TfmEditRBVisit.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.FillInvalidGroup;
  fm.FillPhysician;
  fm.FillViewPlace;
  fm.FillInvalidCategory;
  fm.FillBranch;
  fm.SetEnabledFilter(true);

  if isFindVisitDateFrom then begin
   fm.dtpVisitDate.Date:=FindVisitDateFrom;
  end;
  fm.dtpVisitDate.Checked:=isFindVisitDateFrom;
  if isFindVisitDateTo then begin
   fm.dtpVisitDateTo.Date:=FindVisitDateTo;
  end;
  fm.dtpVisitDateTo.Checked:=isFindVisitDateTo;

  if Trim(FindInvalidFio)<>'' then fm.edInvalidFio.Text:=FindInvalidFio;
  if Trim(FindInvalidGroupName)<>'' then fm.cmbInvalidGroup.Text:=FindInvalidGroupName;
  if Trim(FindPhysicianFio)<>'' then fm.cmbPhysician.Text:=FindPhysicianFio;
  if Trim(FindViewPlaceName)<>'' then fm.cmbViewPlace.Text:=FindViewPlaceName;
  if Trim(FindInvalidCategoryName)<>'' then fm.cmbInvalidCategory.Text:=FindInvalidCategoryName;
  if Trim(FindSickGroupName)<>'' then fm.edSickGroup.Text:=FindSickGroupName;
  if Trim(FindComingInvalidGroupName)<>'' then fm.cmbComingInvalidGroup.Text:=FindComingInvalidGroupName;
  if Trim(FindOrdinalNumber)<>'' then fm.edOrdinal.Text:=FindOrdinalNumber;
  if Trim(FindBranchName)<>'' then fm.cmbBranch.Text:=FindBranchName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindVisitDateFrom:=fm.dtpVisitDate.Date;
    isFindVisitDateFrom:=fm.dtpVisitDate.Checked;
    FindVisitDateTo:=fm.dtpVisitDateTo.Date;
    isFindVisitDateTo:=fm.dtpVisitDateTo.Checked;

    FindInvalidFio:=Trim(fm.edInvalidFio.Text);
    FindInvalidGroupName:=Trim(fm.cmbInvalidGroup.Text);
    FindPhysicianFio:=Trim(fm.cmbPhysician.Text);
    FindViewPlaceName:=Trim(fm.cmbViewPlace.Text);
    FindInvalidCategoryName:=Trim(fm.cmbInvalidCategory.Text);
    FindSickGroupName:=Trim(fm.edSickGroup.Text);
    FindComingInvalidGroupName:=Trim(fm.cmbComingInvalidGroup.Text);
    FindOrdinalNumber:=Trim(fm.edOrdinal.Text);
    FindBranchName:=Trim(fm.cmbBranch.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBVisit.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7,addstr8,addstr9,addstr10,addstr11: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindInvalidFio:=Trim(FindInvalidFio)<>'';
    isFindInvalidGroupName:=Trim(FindInvalidGroupName)<>'';
    isFindPhysicianFio:=Trim(FindPhysicianFio)<>'';
    isFindViewPlaceName:=Trim(FindViewPlaceName)<>'';
    isFindInvalidCategoryName:=Trim(FindInvalidCategoryName)<>'';
    isFindSickGroupName:=Trim(FindSickGroupName)<>'';
    isFindComingInvalidGroupName:=Trim(FindComingInvalidGroupName)<>'';
    isFindOrdinalNumber:=Trim(FindOrdinalNumber)<>'';
    isFindOrdinalNumber:=isInteger(Trim(FindOrdinalNumber));
    isFindBranchName:=Trim(FindBranchName)<>'';

    if isFindInvalidFio or isFindInvalidGroupName or isFindPhysicianFio or
       isFindViewPlaceName or isFindInvalidCategoryName or isFindSickGroupName or
       isFindVisitDateFrom or isFindVisitDateTo or isFindComingInvalidGroupName or
       isFindOrdinalNumber or isFindBranchName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindInvalidFio then begin
        addstr1:=' Upper(i.fname||'' ''||i.name||'' ''||i.sname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInvalidFio+'%'))+' ';
     end;

     if isFindInvalidGroupName then begin
        addstr2:=' Upper(ig.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInvalidGroupName+'%'))+' ';
     end;

     if isFindPhysicianFio then begin
        addstr3:=' Upper(p.fname||'' ''||p.name||'' ''||p.sname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPhysicianFio+'%'))+' ';
     end;

     if isFindViewPlaceName then begin
        addstr4:=' Upper(vp.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindViewPlaceName+'%'))+' ';
     end;

     if isFindInvalidCategoryName then begin
        addstr5:=' Upper(ic.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindInvalidCategoryName+'%'))+' ';
     end;

     if isFindSickGroupName then begin
        addstr6:=' Upper(sg.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSickGroupName+'%'))+' ';
     end;

     if isFindVisitDateFrom then begin
        addstr7:=' visitdate>='+AnsiUpperCase(QuotedStr(DateToStr(FindVisitDateFrom)))+' ';
     end;

     if isFindVisitDateTo then begin
        addstr8:=' visitdate<='+AnsiUpperCase(QuotedStr(DateToStr(FindVisitDateTo)))+' ';
     end;

     if isFindComingInvalidGroupName then begin
        addstr9:=' Upper(ig1.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindComingInvalidGroupName+'%'))+' ';
     end;

     if isFindOrdinalNumber then begin
        addstr10:=' v.ordinalnumber= '+FindOrdinalNumber+' ';
     end;

     if isFindBranchName then begin
        addstr11:=' Upper(b.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindBranchName+'%'))+' ';
     end;

     if (isFindInvalidFio and isFindInvalidGroupName)or
        (isFindInvalidFio and isFindPhysicianFio)or
        (isFindInvalidFio and isFindViewPlaceName)or
        (isFindInvalidFio and isFindInvalidCategoryName)or
        (isFindInvalidFio and isFindSickGroupName)or
        (isFindInvalidFio and isFindVisitDateFrom)or
        (isFindInvalidFio and isFindVisitDateTo)or
        (isFindInvalidFio and isFindComingInvalidGroupName)or
        (isFindInvalidFio and isFindOrdinalNumber)or
        (isFindInvalidFio and isFindBranchName)
      then and1:=' and ';

     if (isFindInvalidGroupName and isFindPhysicianFio)or
        (isFindInvalidGroupName and isFindViewPlaceName)or
        (isFindInvalidGroupName and isFindInvalidCategoryName)or
        (isFindInvalidGroupName and isFindSickGroupName)or
        (isFindInvalidGroupName and isFindVisitDateFrom)or
        (isFindInvalidGroupName and isFindVisitDateTo)or
        (isFindInvalidGroupName and isFindComingInvalidGroupName)or
        (isFindInvalidGroupName and isFindOrdinalNumber)or
        (isFindInvalidGroupName and isFindBranchName)
      then and2:=' and ';

     if (isFindPhysicianFio and isFindViewPlaceName)or
        (isFindPhysicianFio and isFindInvalidCategoryName)or
        (isFindPhysicianFio and isFindSickGroupName)or
        (isFindPhysicianFio and isFindVisitDateFrom)or
        (isFindPhysicianFio and isFindVisitDateTo)or
        (isFindPhysicianFio and isFindComingInvalidGroupName)or
        (isFindPhysicianFio and isFindOrdinalNumber)or
        (isFindPhysicianFio and isFindBranchName)
      then and3:=' and ';

     if (isFindViewPlaceName and isFindInvalidCategoryName)or
        (isFindViewPlaceName and isFindSickGroupName)or
        (isFindViewPlaceName and isFindVisitDateFrom)or
        (isFindViewPlaceName and isFindVisitDateTo)or
        (isFindViewPlaceName and isFindComingInvalidGroupName)or
        (isFindViewPlaceName and isFindOrdinalNumber)or
        (isFindViewPlaceName and isFindBranchName)
      then and4:=' and ';

     if (isFindInvalidCategoryName and isFindSickGroupName)or
        (isFindInvalidCategoryName and isFindVisitDateFrom)or
        (isFindInvalidCategoryName and isFindVisitDateTo)or
        (isFindInvalidCategoryName and isFindComingInvalidGroupName)or
        (isFindInvalidCategoryName and isFindOrdinalNumber)or
        (isFindInvalidCategoryName and isFindBranchName)
      then and5:=' and ';

     if (isFindSickGroupName and isFindVisitDateFrom)or
        (isFindSickGroupName and isFindVisitDateTo)or
        (isFindSickGroupName and isFindComingInvalidGroupName)or
        (isFindSickGroupName and isFindOrdinalNumber)or
        (isFindSickGroupName and isFindBranchName)
      then and6:=' and ';

     if (isFindVisitDateFrom and isFindVisitDateTo)or
        (isFindVisitDateFrom and isFindComingInvalidGroupName)or
        (isFindVisitDateFrom and isFindOrdinalNumber)or
        (isFindVisitDateFrom and isFindBranchName)
      then and7:=' and ';

     if (isFindVisitDateTo and isFindComingInvalidGroupName)or
        (isFindVisitDateTo and isFindOrdinalNumber)or
        (isFindVisitDateTo and isFindBranchName)
      then and8:=' and ';

     if (isFindComingInvalidGroupName and isFindOrdinalNumber)or
        (isFindComingInvalidGroupName and isFindBranchName)
      then and9:=' and ';

     if (isFindOrdinalNumber and isFindBranchName)
      then and10:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7+and7+
                      addstr8+and8+
                      addstr9+and9+
                      addstr10+and10+
                      addstr11;
end;


end.
