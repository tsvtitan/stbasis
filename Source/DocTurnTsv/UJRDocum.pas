unit UJRDocum;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UJRMainGrid, IBDatabase, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls,
  Buttons, ExtCtrls, dbgrids, IB, Menus, tsvDbGrid, IBUpdateSQL, UMainUnited;

type
  TfmJRDocum = class(TfmJRMainGrid)
    pnSQL: TPanel;
    bibAdd: TBitBtn;
    bibChange: TBitBtn;
    bibDel: TBitBtn;
    bibConduct: TBitBtn;
    pmAdd: TPopupMenu;
    bibView: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibDelClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure pmAddPopup(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
  private
    isFindNum,isFindTypeDocName,isFindDateDocFrom,isFindDateDocTo: Boolean;
    FindNum,FindTypeDocName: String;
    FindDateDocFrom,FindDateDocTo: TDateTime;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
    function CheckPermission: Boolean; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure InitModalParams(hInterface: THandle; Param: PParamJournalInterface); override;
  end;

var
  fmJRDocum: TfmJRDocum;

implementation

uses UDocTurnTsvCode, UDocTurnTsvDM, UDocTurnTsvData, UEditJRDocum;

{$R *.DFM}

type

  TTempMenuItem=class(TMenuItem)
  public
    interfacename: string;
    typedoc_id: Integer;
    sign: Integer;
  end;

procedure TfmJRDocum.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
  inherited;
  try
   Caption:=NameJrDocum;
   
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);

   cl:=Grid.Columns.Add;
   cl.FieldName:='prefixnumsufix';
   cl.Title.Caption:='Номер';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='typedocname';
   cl.Title.Caption:='Вид документа';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='datedoc';
   cl.Title.Caption:='Дата документа';
   cl.Width:=150;

   LastOrderStr:=' order by datedoc desc ';

   Grid.VisibleRowNumber:=true;
   
   LoadFromIni;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;  
end;

procedure TfmJRDocum.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmJRDocum:=nil;
end;

function TfmJRDocum.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLJrDocum+GetFilterString+GetLastOrderStr;
end;

function TfmJRDocum.CheckPermission: Boolean;
var
  isPerm: Boolean;
begin
  isPerm:=_isPermissionOnInterface(FhInterface,ttiaView);
  bibOk.Enabled:=isPerm;
  bibView.Enabled:=isPerm;
  if pnSQL.Visible then begin
   bibChange.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaChange);
   bibAdd.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaAdd);
   bibDel.Enabled:=isPerm and _isPermissionOnInterface(FhInterface,ttiaDelete);
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end;
  Result:=isPerm;
end;

procedure TfmJRDocum.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindNum or isFindTypeDocName or isFindDateDocFrom or isFindDateDocTo);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG}
   on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end; 
end;

procedure TfmJRDocum.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if AnsiUpperCase(fn)=AnsiUpperCase('prefixnumsufix') then fn:='1';
   if AnsiUpperCase(fn)=AnsiUpperCase('typedocname') then fn:='td.name';
   id:=MainQr.fieldByName('docum_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('docum_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmJRDocum.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if bibChange.Enabled then bibChange.Click;
end;

procedure TfmJRDocum.LoadFromIni;
begin
 inherited;
 try
    FindNum:=ReadParam(ClassName,'Num',FindNum);
    FindTypeDocName:=ReadParam(ClassName,'TypeDocName',FindTypeDocName);
    FindDateDocFrom:=ReadParam(ClassName,'DateDocFrom',FindDateDocFrom);
    isFindDateDocFrom:=ReadParam(ClassName,'isDateDocFrom',isFindDateDocFrom);
    FindDateDocTo:=ReadParam(ClassName,'DateDocTo',FindDateDocTo);
    isFindDateDocTo:=ReadParam(ClassName,'isDateDocTo',isFindDateDocTo);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG}
   on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end;
end;


procedure TfmJRDocum.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'Num',FindNum);
    WriteParam(ClassName,'TypeDocName',FindTypeDocName);
    WriteParam(ClassName,'DateDocFrom',FindDateDocFrom);
    WriteParam(ClassName,'isDateDocFrom',isFindDateDocFrom);
    WriteParam(ClassName,'DateDocTo',FindDateDocTo);
    WriteParam(ClassName,'isDateDocTo',isFindDateDocTo);

    WriteParam(ClassName,'Inside',FilterInside);

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmJRDocum.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmJRDocum.bibFilterClick(Sender: TObject);
var
  fm: TfmEditJRDocum;
  filstr: string;
begin
 try
  fm:=TfmEditJRDocum.Create(nil);
  try
   fm.TypeEditRBook:=terbFilter;
   fm.edTypeDocName.ReadOnly:=false;
   fm.edTypeDocName.Color:=clWindow;
   fm.edPrefix.Enabled:=false;
   fm.edPrefix.Color:=clBtnFace;
   fm.lbPrefix.Enabled:=false;
   fm.edSufix.Enabled:=false;
   fm.edSufix.Color:=clBtnFace;
   fm.lbSufix.Enabled:=false;

   if Trim(FindNum)<>'' then fm.edNum.Text:=FindNum;
   if Trim(FindTypeDocName)<>'' then fm.edTypeDocName.Text:=FindTypeDocName;

   fm.dtpDateFrom.DateTime:=FindDateDocFrom;
   fm.dtpDateFrom.Checked:=isFindDateDocFrom;
   fm.dtpDateFrom.Checked:=isFindDateDocFrom;
   fm.dtpDateTo.DateTime:=FindDateDocTo;
   fm.dtpDateTo.Checked:=isFindDateDocTo;
   fm.dtpDateTo.Checked:=isFindDateDocTo;

   fm.cbInString.Visible:=true;
   fm.bibClear.Visible:=true;
   fm.cbInString.Checked:=FilterInSide;

   fm.ChangeFlag:=false;

   if fm.ShowModal=mrOk then begin

    inherited;

    FindNum:=Trim(fm.edNum.Text);
    FindTypeDocName:=Trim(fm.edTypeDocName.Text);
    FindDateDocFrom:=fm.dtpDateFrom.DateTime;
    isFindDateDocFrom:=fm.dtpDateFrom.Checked;
    FindDateDocTo:=fm.dtpDateTo.DateTime;
    isFindDateDocTo:=fm.dtpDateTo.Checked;


    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
   end;
  finally
   fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

function TfmJRDocum.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  isFindNoRemoved: Boolean;
  addstr1,addstr2,addstr3,addstr4,addstr5: string;
  and1,and2,and3,and4: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindNum:=Trim(FindNum)<>'';
    isFindTypeDocName:=Trim(FindTypeDocName)<>'';
    isFindDateDocFrom:=isFindDateDocFrom;
    isFindDateDocTo:=isFindDateDocTo;
    isFindNoRemoved:=Trim(inherited GetFilterStringNoRemoved)<>'';

    if isFindNum or isFindTypeDocName or isFindDateDocFrom or isFindDateDocTo or
       isFindNoRemoved then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindNum then begin
        addstr1:=' Upper(num) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNum+'%'))+' ';
     end;
     if isFindTypeDocName then begin
        addstr2:=' Upper(td.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTypeDocName+'%'))+' ';
     end;
     if isFindDateDocFrom then begin
        addstr3:=' datedoc >= '+QuotedStr(DateTimeToStr(FindDateDocFrom))+' ';
     end;
     if isFindDateDocTo then begin
        addstr4:=' datedoc <= '+QuotedStr(DateTimeToStr(FindDateDocTo))+' ';
     end;
     if isFindNoRemoved then begin
        addstr5:=' '+inherited GetFilterStringNoRemoved+' ';
     end;

     if (isFindNum and isFindTypeDocName)or
        (isFindNum and isFindDateDocFrom)or
        (isFindNum and isFindDateDocTo)or
        (isFindNum and isFindNoRemoved)
        then and1:=' and ';

     if (isFindTypeDocName and isFindDateDocFrom)or
        (isFindTypeDocName and isFindDateDocTo)or
        (isFindTypeDocName and isFindNoRemoved)
        then and2:=' and ';

     if (isFindDateDocFrom and isFindDateDocTo)or
        (isFindDateDocFrom and isFindNoRemoved)
        then and3:=' and ';

     if (isFindDateDocTo and isFindNoRemoved)
        then and4:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5;

end;


procedure TfmJRDocum.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
    VK_F2: begin
     if pnSQL.Visible then
      if bibAdd.Enabled then
        bibAdd.Click;
    end;
    VK_F3: begin
     if pnSQL.Visible then
      if bibChange.Enabled then
        bibChange.Click;
    end; 
    VK_F4: begin
     if pnSQL.Visible then
      if bibDel.Enabled then
       bibDel.Click;
    end;
    VK_F6: begin
     if bibView.Enabled then
       bibView.Click;
    end;
   end;
  end; 
  inherited;
end;

procedure TfmJRDocum.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbDocum+' where docum_id='+
          Mainqr.FieldByName('docum_id').AsString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     
     ViewCount;

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
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('документ с номером <'+Mainqr.FieldByName('prefixnumsufix').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmJRDocum.InitModalParams(hInterface: THandle; Param: PParamJournalInterface); 
begin
  pnSQL.Visible:=false;  
  inherited;
end;

procedure TfmJRDocum.bibAddClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  fm: TfmEditJRDocum;
  Sign: Boolean;
  TPDI: TParamDocumentInterface;
  InterfaceName: string;
begin
  if not Mainqr.Active then exit;
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
    Sign:=GetFirstValueFromParamRBookInterface(@TPRBI,'sign');
    InterfaceName:=GetFirstValueFromParamRBookInterface(@TPRBI,'interfacename');
    if not Sign then begin
      fm:=TfmEditJRDocum.Create(nil);
      try
        fm.fmParent:=Self;
        fm.bibOk.OnClick:=fm.AddClick;
        fm.Caption:=CaptionAdd;
        fm.edTypeDocName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
        fm.typedoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typedoc_id');
        fm.ActiveControl:=fm.edNum;
        fm.SetDefaultDatePosition;
        if fm.ShowModal=mrok then begin
         ViewCount;
         MainQr.Locate('docum_id',fm.olddocum_id,[loCaseInsensitive]);
        end;
      finally
        fm.Free;
      end;
    end else begin
      FillChar(TPDI,SizeOf(TPDI),0);
      TPDI.Visual.TypeView:=tviMdiChild;
      TPDI.TypeOperation:=todAdd;
      TPDI.Head.TypeDocId:=GetFirstValueFromParamRBookInterface(@TPRBI,'typedoc_id');
      _ViewInterfaceFromName(PChar(InterfaceName),@TPDI);
    end;
  end;
end;

procedure TfmJRDocum.pmAddPopup(Sender: TObject);
{var
  TPRBI: TParamRBookInterface;
  StartInc,EndInc: Integer;
  i: Integer;
  mi: TTempMenuItem;
  hInt: Thandle;
  InterfaceName: string;
  isFail: Boolean;}
begin
{  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.OrderStr:=PChar(' name ');
  if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
   GetStartAndEndByParamRBookInterface(@TPRBI,StartInc,EndInc);
   pmAdd.Items.Clear;
   for i:=StartInc to EndInc do begin
     InterfaceName:=GetValueByParamRBookInterface(@TPRBI,i,'interfacename',varString);
     hInt:=0;
     isFail:=false;
     if Trim(InterfaceName)<>'' then begin
      hInt:=_GetInterfaceHandleFromName(PChar(InterfaceName));
      if not _isValidInterface(hInt) then isFail:=true;
     end;
     if not isFail then begin
      mi:=TTempMenuItem.Create(nil);
      mi.Caption:=GetValueByParamRBookInterface(@TPRBI,i,'name',varString);
      mi.InterfaceName:=InterfaceName;
      mi.typedoc_id:=GetValueByParamRBookInterface(@TPRBI,i,'typedoc_id',varInteger);
      mi.sign:=GetValueByParamRBookInterface(@TPRBI,i,'sign',varInteger);
      if Trim(InterfaceName)<>'' then
       mi.Enabled:=_isPermissionOnInterface(hInt,ttiaView);
      pmAdd.Items.Add(mi);
     end; 
   end;
  end;}
end;

procedure TfmJRDocum.bibChangeClick(Sender: TObject);
var
  fm: TfmEditJRDocum;
  Sign: Boolean;
  TPDI: TParamDocumentInterface;
  InterfaceName: string;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  Sign:=Boolean(Mainqr.FieldByName('sign').AsInteger);
  InterfaceName:=Mainqr.FieldByName('interfacename').AsString;
  if not Sign then begin
    fm:=TfmEditJRDocum.Create(nil);
    try
      fm.fmParent:=Self;
      fm.bibOk.OnClick:=fm.ChangeClick;
      fm.Caption:=CaptionChange;
      fm.edTypeDocName.Text:=Mainqr.FieldByName('typedocname').AsString;
      fm.typedoc_id:=Mainqr.FieldByName('typedoc_id').AsInteger;
      fm.edNum.Text:=Mainqr.FieldByName('num').AsString;
      fm.edPrefix.Text:=Mainqr.FieldByName('prefix').AsString;
      fm.edSufix.Text:=Mainqr.FieldByName('sufix').AsString;
      fm.dtpDateFrom.DateTime:=Mainqr.FieldByName('datedoc').AsDateTime;
      fm.SetDefaultDatePosition;
      fm.ChangeFlag:=false;
      if fm.ShowModal=mrok then begin
         MainQr.Locate('docum_id',fm.olddocum_id,[loCaseInsensitive]);
      end;
    finally
      fm.Free;
    end;
  end else begin
    FillChar(TPDI,SizeOf(TPDI),0);
    TPDI.Visual.TypeView:=tviMdiChild;
    TPDI.TypeOperation:=todChange;
    TPDI.Head.DocumentId:=Mainqr.FieldByName('docum_id').AsInteger;
    TPDI.Head.DocumentNumber:=Mainqr.FieldByName('num').AsInteger;
    TPDI.Head.DocumentDate:=Mainqr.FieldByName('datedoc').AsDateTime;
    TPDI.Head.DocumentPrefix:=PChar(Mainqr.FieldByName('prefix').AsString);
    TPDI.Head.DocumentSufix:=PChar(Mainqr.FieldByName('sufix').AsString);
    TPDI.Head.TypeDocId:=Mainqr.FieldByName('typedoc_id').AsInteger;
    if _ViewInterfaceFromName(PChar(InterfaceName),@TPDI) then begin
      Caption:=Caption;
    end;
  end;
end;

procedure TfmJRDocum.bibViewClick(Sender: TObject);
var
  fm: TfmEditJRDocum;
  Sign: Boolean;
  TPDI: TParamDocumentInterface;
  InterfaceName: string;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  Sign:=Boolean(Mainqr.FieldByName('sign').AsInteger);
  InterfaceName:=Mainqr.FieldByName('interfacename').AsString;
  if not Sign then begin
    fm:=TfmEditJRDocum.Create(nil);
    try
      fm.bibOk.OnClick:=nil;
      fm.bibOk.Visible:=false;
      fm.bibCancel.Caption:=CaptionClose;
      fm.Caption:=CaptionView;
      fm.edTypeDocName.Text:=Mainqr.FieldByName('typedocname').AsString;
      fm.typedoc_id:=Mainqr.FieldByName('typedoc_id').AsInteger;
      fm.edNum.Text:=Mainqr.FieldByName('num').AsString;
      fm.edPrefix.Text:=Mainqr.FieldByName('prefix').AsString;
      fm.edSufix.Text:=Mainqr.FieldByName('sufix').AsString;
      fm.dtpDateFrom.DateTime:=Mainqr.FieldByName('datedoc').AsDateTime;
      fm.SetDefaultDatePosition;
      if fm.ShowModal=mrok then begin
      end;
    finally
      fm.Free;
    end;
  end else begin
    FillChar(TPDI,SizeOf(TPDI),0);
    TPDI.Visual.TypeView:=tviMdiChild;
    TPDI.TypeOperation:=todView;
    TPDI.Head.DocumentId:=Mainqr.FieldByName('docum_id').AsInteger;
    TPDI.Head.DocumentNumber:=Mainqr.FieldByName('num').AsInteger;
    TPDI.Head.DocumentDate:=Mainqr.FieldByName('datedoc').AsDateTime;
    TPDI.Head.DocumentPrefix:=PChar(Mainqr.FieldByName('prefix').AsString);
    TPDI.Head.DocumentSufix:=PChar(Mainqr.FieldByName('sufix').AsString);
    TPDI.Head.TypeDocId:=Mainqr.FieldByName('typedoc_id').AsInteger;
    _ViewInterfaceFromName(PChar(InterfaceName),@TPDI);
  end;
end;

end.
