unit UJRSqlOperation;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UJRMainGrid, IBDatabase, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls,
  Buttons, ExtCtrls, dbgrids, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
  TfmJRSqlOperation = class(TfmJRMainGrid)
    pnHint: TPanel;
    grbHint: TGroupBox;
    pngrbHint: TPanel;
    dbmeHint: TDBMemo;
    spl: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    isFindUserName,isFindHint,isFindInDateFrom,isFindInDateTo,
    isFindName,isFindCompName: Boolean;
    FindUserName,FindHint,FindName,
    FindCompName: String;
    FindInDateFrom,FindInDateTo: TDateTime;
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
  fmJRSqlOperation: TfmJRSqlOperation;

implementation

uses UMainUnited, USysTsvCode, USysTsvDM, USysTsvData, UEditJRSqlOperation;

{$R *.DFM}

procedure TfmJRSqlOperation.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
  inherited;
  try
   Caption:=NameJrnSqlOperation;
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);

   cl:=Grid.Columns.Add;
   cl.FieldName:='tuname';
   cl.Title.Caption:='Пользователь';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='indatetime';
   cl.Title.Caption:='Дата и время';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='name';
   cl.Title.Caption:='Операция';
   cl.Width:=150;

   cl:=Grid.Columns.Add;
   cl.FieldName:='compname';
   cl.Title.Caption:='Компьютер';
   cl.Width:=150;

   dbmeHint.DataField:='hint';

   FindInDateFrom:=Date+StrToTime('0:00:00');
   FindInDateTo:=Date+StrToTime('23:59:59');

   LastOrderStr:=' order by indatetime ';
   
   LoadFromIni;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;  
end;

procedure TfmJRSqlOperation.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmJRSqlOperation:=nil;
end;

function TfmJRSqlOperation.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLJrnSqlOperation+GetFilterString+GetLastOrderStr;
end;

procedure TfmJRSqlOperation.ActiveQuery(CheckPerm: Boolean);
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
   Mainqr.Last;
   SetImageFilter(isFindUserName or isFindHint or isFindInDateFrom or
                  isFindInDateTo or isFindName or isFindCompName);
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

procedure TfmJRSqlOperation.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('tuname') then fn:='tu.name';
   id:=MainQr.fieldByName('journalsqloperation_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('journalsqloperation_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmJRSqlOperation.GridDblClick(Sender: TObject);
begin

end;

procedure TfmJRSqlOperation.LoadFromIni;
begin
 inherited;
 try
    FindUserName:=ReadParam(ClassName,'UserName',FindUserName);
    FindHint:=ReadParam(ClassName,'Hint',FindHint);
    FindName:=ReadParam(ClassName,'Name',FindName);
    FindCompName:=ReadParam(ClassName,'CompName',FindCompName);
    isFindInDateFrom:=ReadParam(ClassName,'isInDateFrom',isFindInDateFrom);
    if isFindInDateFrom then
     FindInDateFrom:=ReadParam(ClassName,'InDateFrom',FindInDateFrom)+StrToTime('0:00:00');
    isFindInDateTo:=ReadParam(ClassName,'isInDateTo',isFindInDateTo);
    if isFindInDateTo then
     FindInDateTo:=ReadParam(ClassName,'InDateTo',FindInDateTo)+StrToTime('23:59:59');

    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);

    pnHint.Height:=ReadParam(ClassName,pnHint.Name,pnHint.Height);
 except
  {$IFDEF DEBUG}
   on E: Exception do Assert(false,E.message);
  {$ENDIF}
 end;
end;


procedure TfmJRSqlOperation.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'UserName',FindUserName);
    WriteParam(ClassName,'Hint',FindHint);
    WriteParam(ClassName,'Name',FindName);
    WriteParam(ClassName,'CompName',FindCompName);
    WriteParam(ClassName,'isInDateFrom',isFindInDateFrom);
    WriteParam(ClassName,'InDateFrom',FindInDateFrom);
    WriteParam(ClassName,'isInDateTo',isFindInDateTo);
    WriteParam(ClassName,'InDateTo',FindInDateTo);

    WriteParam(ClassName,'Inside',FilterInside);

    WriteParam(ClassName,pnHint.Name,pnHint.Height);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmJRSqlOperation.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmJRSqlOperation.bibClearClick(Sender: TObject);
var
  but: Integer;

  function ClearRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   result:=false;
   try
    Screen.Cursor:=crHourGlass;
    qr:=TIBQuery.Create(nil);
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbJournalSqlOperation;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     ActiveQuery(false);
     Result:=true;
    finally
     qr.Free;
     Screen.Cursor:=crDefault;
    end;
   except
    on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
    end;
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=ShowQuestionEx(CaptionClear+' '+AnsiLowerCase(NameJrnSqlOperation)+' ?');
  if but=mrYes then begin
    if not ClearRecord then begin
      ShowErrorEx(
               NameJrnSqlOperation+' используется.');
    end;
  end;
end;

procedure TfmJRSqlOperation.bibFilterClick(Sender: TObject);
var
  fm: TfmEditJRSqlOperation;
  filstr: string;
begin
 try
  fm:=TfmEditJRSqlOperation.Create(nil);
  try
   fm.Caption:=CaptionFilter;
   fm.bibOK.OnClick:=fm.filterClick;
   fm.edUsername.ReadOnly:=false;
   fm.edUsername.Color:=clWindow;

   if Trim(FindUserName)<>'' then fm.edUserName.Text:=FindUserName;
   if Trim(FindHint)<>'' then fm.meHint.Text:=FindHint;
   if Trim(FindName)<>'' then fm.edName.Text:=FindName;
   if Trim(FindCompname)<>'' then fm.edCompName.Text:=FindCompname;
   fm.dtpDateFrom.DateTime:=FindInDateFrom;
   fm.dtpDateFrom.Checked:=isFindInDateFrom;
   fm.dtpDateTo.DateTime:=FindInDateTo;
   fm.dtpDateTo.Checked:=isFindInDateTo;

   fm.cbInString.Visible:=true;
   fm.bibClear.Visible:=true;
   fm.cbInString.Checked:=FilterInSide;

   fm.ChangeFlag:=false;

   if fm.ShowModal=mrOk then begin

    inherited;

    FindUserName:=Trim(fm.edUserName.Text);
    FindHint:=Trim(fm.meHint.Text);
    FindName:=Trim(fm.edName.Text);
    FindCompName:=Trim(fm.edCompName.Text);
    FindInDateFrom:=fm.dtpDateFrom.DateTime;
    isFindInDateFrom:=fm.dtpDateFrom.Checked;
    FindInDateTo:=fm.dtpDateTo.DateTime;
    isFindInDateTo:=fm.dtpDateTo.Checked;


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

function TfmJRSqlOperation.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,addstr6: string;
  and1,and2,and3,and4,and5: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindUserName:=Trim(FindUserName)<>'';
    isFindhint:=Trim(Findhint)<>'';
    isFindName:=Trim(FindName)<>'';
    isFindCompName:=Trim(FindCompName)<>'';
    isFindInDateFrom:=isFindInDateFrom;
    isFindInDateTo:=isFindInDateTo;

    if isFindUserName or isFindhint or isFindName or
       isFindInDateFrom or isFindInDateTo or isFindCompName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindUserName then begin
        addstr1:=' Upper(tu.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
     end;
     if isFindHint then begin
        addstr2:=' Upper(hint) like '+AnsiUpperCase(QuotedStr(FilInSide+FindHint+'%'))+' ';
     end;
     if isFindName then begin
        addstr3:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;
     if isFindInDateFrom then begin
        addstr4:=' indatetime >= '+QuotedStr(DateTimeToStr(FindInDateFrom))+' ';
     end;
     if isFindInDateTo then begin
        addstr5:=' indatetime <= '+QuotedStr(DateTimeToStr(FindInDateTo))+' ';
     end;
     if isFindCompName then begin
        addstr6:=' Upper(compname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCompname+'%'))+' ';
     end;

     if (isFindUserName and isFindHint)or
        (isFindUserName and isFindName)or
        (isFindUserName and isFindInDateFrom)or
        (isFindUserName and isFindInDateTo) or
        (isFindUserName and isFindCompName)
        then and1:=' and ';

     if (isFindHint and isFindName)or
        (isFindHint and isFindInDateFrom)or
        (isFindHint and isFindInDateTo) or
        (isFindHint and isFindCompName)
        then and2:=' and ';

     if (isFindName and isFindInDateFrom)or
        (isFindName and isFindInDateTo)or
        (isFindName and isFindCompName)
        then and3:=' and ';

     if (isFindInDateFrom and isFindInDateTo)or
        (isFindInDateFrom and isFindCompname) 
        then and4:=' and ';

     if (isFindInDateTo and isFindCompName)
        then and5:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2+and2+
                      addstr3+and3+
                      addstr4+and4+
                      addstr5+and5+
                      addstr6;

end;


procedure TfmJRSqlOperation.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=LastKey then begin
   LastKey:=0;
   exit;
  end;
  if Shift=[] then begin
   case Key of
     VK_F4: begin
       if bibClear.Enabled then
        bibClear.Click;
     end;
   end;
  end; 
  inherited;
end;

end.
