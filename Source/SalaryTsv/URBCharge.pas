unit URBCharge;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, grids, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBCharge = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindShortName,isFindStandartoperation,
    isFindchargegroup,isFindroundtype,isFindalgorithm,isFindFlag: Boolean;
    FindName,FindShortName,FindStandartoperation,
    Findchargegroup,Findroundtype,Findalgorithm: String;
    FindFlag: integer;

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
  fmRBCharge: TfmRBCharge;

implementation

uses UMainUnited, USalaryTsvCode, USalaryTsvDM, USalaryTsvData, UEditRBCharge;

{$R *.DFM}

procedure TfmRBCharge.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkCharge;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='chargename';
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='shortname';
  cl.Title.Caption:='Краткое';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='standartoperationname';
  cl.Title.Caption:='Операция';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='chargegroupname';
  cl.Title.Caption:='Группа';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='roundtypename';
  cl.Title.Caption:='Вид округления';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='algorithmname';
  cl.Title.Caption:='Алгоритм';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='flagplus';
  cl.Title.Caption:='Это удержание';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fallsintototalplus';
  cl.Title.Caption:='Входит в итого';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fixedamount';
  cl.Title.Caption:='Фикс. сумма';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fixedrateathours';
  cl.Title.Caption:='Фикс. норма в часах';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='fixedpercent';
  cl.Title.Caption:='Фикс. процент';
  cl.Width:=100;

  Grid.OnDrawColumnCell:=GridDrawColumnCell;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCharge.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBCharge:=nil;
end;

function TfmRBCharge.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkCharge+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBCharge.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindShortName or isFindStandartoperation or
                  isFindchargegroup or isFindroundtype or isFindalgorithm or isFindFlag);
   ViewCount;
  finally
   Mainqr.EnableControls; 
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCharge.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('charge_id').asString;
   if UpperCase(fn)=UpperCase('chargename') then fn:='ch.name';
   if UpperCase(fn)=UpperCase('standartoperationname') then fn:='so.name';
   if UpperCase(fn)=UpperCase('chargegroupname') then fn:='cg.name';
   if UpperCase(fn)=UpperCase('roundtypename') then fn:='rt.name';
   if UpperCase(fn)=UpperCase('algorithmname') then fn:='al.name';
   if UpperCase(fn)=UpperCase('flagplus') then fn:='flag';
   if UpperCase(fn)=UpperCase('fallsintototalplus') then fn:='fallsintototal';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('charge_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCharge.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBCharge.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindShortName:=ReadParam(ClassName,'shortname',FindShortName);
    FindStandartoperation:=ReadParam(ClassName,'Standartoperation',FindStandartoperation);
    Findchargegroup:=ReadParam(ClassName,'chargegroup',Findchargegroup);
    Findroundtype:=ReadParam(ClassName,'roundtype',Findroundtype);
    Findalgorithm:=ReadParam(ClassName,'algorithm',Findalgorithm);
    FindFlag:=ReadParam(ClassName,'Flag',FindFlag);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCharge.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'shortname',FindShortName);
    WriteParam(ClassName,'Standartoperation',FindStandartoperation);
    WriteParam(ClassName,'chargegroup',Findchargegroup);
    WriteParam(ClassName,'roundtype',Findroundtype);
    WriteParam(ClassName,'algorithm',Findalgorithm);
    WriteParam(ClassName,'Flag',FindFlag);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCharge.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBCharge.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
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
  if Column.Title.Caption='Это удержание' then begin
    chk:=Boolean(Mainqr.FieldByName('flag').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
  if Column.Title.Caption='Входит в итого' then begin
    chk:=Boolean(Mainqr.FieldByName('fallsintototal').AsInteger);
    if not chk then Begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_BUTTONCHECK);
    end else begin
     DrawFrameControl(Grid.Canvas.Handle,Rt,DFC_BUTTON,DFCS_CHECKED);
    end;
  end;
end;

procedure TfmRBCharge.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBCharge;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBCharge.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('charge_id',fm.oldcharge_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBCharge.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBCharge;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBCharge.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.oldcharge_id:=Mainqr.fieldByName('charge_id').AsInteger;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edShortName.Text:=Mainqr.fieldByName('shortname').AsString;
    fm.edstandartoperation.Text:=Mainqr.fieldByName('standartoperationname').AsString;
    fm.standartoperation_id:=Mainqr.fieldByName('standartoperation_id').AsInteger;
    fm.edchargegroup.Text:=Mainqr.fieldByName('chargegroupname').AsString;
    fm.chargegroup_id:=Mainqr.fieldByName('chargegroup_id').AsInteger;
    fm.edroundtype.Text:=Mainqr.fieldByName('roundtypename').AsString;
    fm.roundtype_id:=Mainqr.fieldByName('roundtype_id').AsInteger;
    fm.edalgorithm.Text:=Mainqr.fieldByName('algorithmname').AsString;
    fm.algorithm_id:=Mainqr.fieldByName('algorithm_id').AsInteger;
    fm.chbflag.Checked:=Mainqr.fieldByName('flag').AsInteger=1;
    fm.chbfallsintototal.Checked:=Mainqr.fieldByName('fallsintototal').AsInteger=1;
    fm.edfixedamount.Text:=Mainqr.fieldByName('fixedamount').AsString;
    fm.edfixedrateathours.Text:=Mainqr.fieldByName('fixedrateathours').AsString;
    fm.edfixedpercent.Text:=Mainqr.fieldByName('fixedpercent').AsString;

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('charge_id',fm.oldcharge_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBCharge.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbCharge+' where charge_id='+
          Mainqr.FieldByName('charge_id').asString;
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
  but:=DeleteWarningEx('начисление <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBCharge.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBCharge;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBCharge.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edShortName.Text:=Mainqr.fieldByName('shortname').AsString;
    fm.edstandartoperation.Text:=Mainqr.fieldByName('standartoperationname').AsString;
    fm.standartoperation_id:=Mainqr.fieldByName('standartoperation_id').AsInteger;
    fm.edchargegroup.Text:=Mainqr.fieldByName('chargegroupname').AsString;
    fm.chargegroup_id:=Mainqr.fieldByName('chargegroup_id').AsInteger;
    fm.edroundtype.Text:=Mainqr.fieldByName('roundtypename').AsString;
    fm.roundtype_id:=Mainqr.fieldByName('roundtype_id').AsInteger;
    fm.edalgorithm.Text:=Mainqr.fieldByName('algorithmname').AsString;
    fm.algorithm_id:=Mainqr.fieldByName('algorithm_id').AsInteger;
    fm.chbflag.Checked:=Mainqr.fieldByName('flag').AsInteger=1;
    fm.chbfallsintototal.Checked:=Mainqr.fieldByName('fallsintototal').AsInteger=1;
    fm.edfixedamount.Text:=Mainqr.fieldByName('fixedamount').AsString;
    fm.edfixedrateathours.Text:=Mainqr.fieldByName('fixedrateathours').AsString;
    fm.edfixedpercent.Text:=Mainqr.fieldByName('fixedpercent').AsString;
    
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBCharge.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBCharge;
  filstr: string;
begin
 fm:=TfmEditRBCharge.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

//  fm.lbstandartoperation.Enabled:=false;
  fm.edstandartoperation.Enabled:=true;
  fm.edstandartoperation.Color:=clWindow;
  fm.edstandartoperation.ReadOnly:=false;
  fm.bibstandartoperation.Enabled:=true;

//  fm.lbchargegroup.Enabled:=false;
  fm.edchargegroup.Enabled:=true;
  fm.edchargegroup.Color:=clWindow;
  fm.edchargegroup.ReadOnly:=false;
  fm.bibchargegroup.Enabled:=true;

//  fm.lbroundtype.Enabled:=true;
  fm.edroundtype.Enabled:=true;
  fm.edroundtype.Color:=clWindow;
  fm.edroundtype.ReadOnly:=false;
  fm.bibroundtype.Enabled:=true;

//  fm.lbalgorithm.Enabled:=false;
  fm.edalgorithm.Enabled:=true;
  fm.edalgorithm.Color:=clWindow;
  fm.edalgorithm.ReadOnly:=false;
  fm.bibalgorithm.Enabled:=true;

  fm.chbflag.Visible:=false;
  fm.chbflag.Enabled:=false;
  fm.cmbFlag.Visible:=true;
  fm.lbFlag.Visible:=true;

  fm.chbfallsintototal.Enabled:=false;

  fm.lbfixedamount.Enabled:=false;
  fm.edfixedamount.Enabled:=false;
  fm.edfixedamount.Color:=clBtnFace;
  
  fm.lbfixedrateathours.Enabled:=false;
  fm.edfixedrateathours.Enabled:=false;
  fm.edfixedrateathours.Color:=clBtnFace;

  fm.lbfixedpercent.Enabled:=false;
  fm.edfixedpercent.Enabled:=false;
  fm.edfixedpercent.Color:=clBtnFace;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindShortName)<>'' then fm.edShortName.Text:=FindShortName;
  if Trim(FindStandartoperation)<>'' then fm.edStandartoperation.Text:=FindStandartoperation;
  if Trim(Findchargegroup)<>'' then fm.edchargegroup.Text:=Findchargegroup;
  if Trim(Findroundtype)<>'' then fm.edroundtype.Text:=Findroundtype;
  if Trim(Findalgorithm)<>'' then fm.edalgorithm.Text:=Findalgorithm;
  if (FindFlag>-1) and (FindFlag<fm.cmbFlag.Items.Count)
           then fm.cmbFlag.ItemIndex:=FindFlag;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    Inherited;
    
    FindName:=Trim(fm.edName.Text);
    FindShortName:=Trim(fm.edShortName.Text);
    FindStandartoperation:=Trim(fm.edStandartoperation.Text);
    Findchargegroup:=Trim(fm.edchargegroup.Text);
    Findroundtype:=Trim(fm.edroundtype.Text);
    Findalgorithm:=Trim(fm.edalgorithm.Text);
    FindFlag:=fm.cmbFlag.ItemIndex;

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBCharge.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6,addstr7: string;
  and1,and2,and3,and4,and5,and6: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindShortName:=Trim(FindShortName)<>'';
    isFindStandartoperation:=Trim(FindStandartoperation)<>'';
    isFindchargegroup:=Trim(Findchargegroup)<>'';
    isFindroundtype:=Trim(Findroundtype)<>'';
    isFindalgorithm:=Trim(Findalgorithm)<>'';
    isFindFlag:=FindFlag>0;

    if isFindName or isFindShortName or isFindStandartoperation or
       isFindchargegroup or isFindroundtype or isFindalgorithm or isFindFlag then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(ch.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindShortName then begin
        addstr2:=' Upper(ch.shortname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindShortName+'%'))+' ';
     end;

     if isFindStandartoperation then begin
        addstr3:=' Upper(so.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindStandartoperation+'%'))+' ';
     end;

     if isFindchargegroup then begin
        addstr4:=' Upper(cg.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Findchargegroup+'%'))+' ';
     end;

     if isFindroundtype then begin
        addstr5:=' Upper(rt.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Findroundtype+'%'))+' ';
     end;

     if isFindalgorithm then begin
        addstr6:=' Upper(al.name) like '+AnsiUpperCase(QuotedStr(FilInSide+Findalgorithm+'%'))+' ';
     end;

     if isFindFlag then begin
       case FindFlag of
         1: addstr7:=' flag=0 ';
         2: addstr7:=' flag=1 ';
       else
         addstr7:=' flag=0 and flag=1 ';
       end;
     end;

     if (isFindName and isFindShortName)or
        (isFindName and isFindStandartoperation)or
        (isFindName and isFindchargegroup)or
        (isFindName and isFindroundtype)or
        (isFindName and isFindalgorithm)or
        (isFindName and isFindFlag)
        then and1:=' and ';

     if (isFindShortName and isFindStandartoperation)or
        (isFindShortName and isFindchargegroup)or
        (isFindShortName and isFindroundtype)or
        (isFindShortName and isFindalgorithm)or
        (isFindShortName and isFindFlag)
        then and2:=' and ';

     if (isFindStandartoperation and isFindchargegroup)or
        (isFindStandartoperation and isFindroundtype)or
        (isFindStandartoperation and isFindalgorithm)or
        (isFindStandartoperation and isFindFlag)
        then and3:=' and ';

     if (isFindchargegroup and isFindroundtype)or
        (isFindchargegroup and isFindalgorithm)or
        (isFindchargegroup and isFindFlag)
        then and4:=' and ';

     if (isFindroundtype and isFindalgorithm)or
        (isFindroundtype and isFindFlag)
        then and5:=' and ';

     if (isFindalgorithm and isFindFlag)
        then and6:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6+and6+
                      addstr7;
end;


end.
