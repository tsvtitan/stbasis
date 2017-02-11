unit URBUserEmp;

interface

{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, inifiles, IBDatabase, IB, Menus;

type
   TfmRBUserEmp = class(TfmRBMainGrid)
    Button1: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    isFindUserName,isFindEmp: Boolean;
    FindUserName,FindEmp: String;
  protected
    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
    function CheckPermission: Boolean; override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBUserEmp: TfmRBUserEmp;

implementation

uses UMainUnited, UKassaKDMCode, UKassaKDMDM, UKassaKDMData, UEditRBUserEmp;

{$R *.DFM}

procedure TfmRBUserEmp.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameUserEmp;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='username';
  cl.Title.Caption:='Пользователь';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='empname';
  cl.Title.Caption:='Сотрудник';
  cl.Width:=180;
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBUserEmp.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBUserEmp:=nil;
end;

function TfmRBUserEmp.CheckPermission: Boolean;
begin
  isPerm:=_isPermission(tbUserEmp,SelConst)and
          _isPermission(tbEmp,SelConst);
  bibOk.Enabled:=isPerm;         
  if not ViewSelect then begin
   bibAdd.Enabled:=isPerm and _isPermission(tbUserEmp,InsConst);
   bibChange.Enabled:=isPerm and _isPermission(tbUserEmp,UpdConst);
   bibDel.Enabled:=isPerm and _isPermission(tbUserEmp,DelConst);
   bibView.Enabled:=isPerm;
   bibFilter.Enabled:=isPerm;
   bibAdjust.Enabled:=isPerm;
  end else begin
   pnSQL.Visible:=false;
  end;
  Result:=isPerm;
end;

procedure TfmRBUserEmp.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  try
   Mainqr.sql.Clear;
   sqls:='Select ue.*, e.fname||'' ''||e.name||'' ''||e.sname as empname from '+
         tbUserEmp+' ue join '+
         tbEmp+' e on ue.emp_id=e.emp_id '+
         GetFilterString+LastOrderStr;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindUserName or isFindEmp);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.GridTitleClick(Column: TColumn);
var
  fn: string;
  id1: string;
  sqls: string;
begin
 try
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  try
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('empname') then fn:='2';
   id1:=MainQr.fieldByName('username').asString;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   LastOrderStr:=' Order by '+fn;
   sqls:='Select ue.*, e.fname||'' ''||e.name||'' ''||e.sname as empname from '+
         tbUserEmp+' ue join '+
         tbEmp+' e on ue.emp_id=e.emp_id '+
         GetFilterString+LastOrderStr;
   MainQr.SQL.Add(sqls);
   MainQr.Transaction.Active:=false;
   MainQr.Transaction.Active:=true;
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('username',id1,[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBUserEmp.LoadFromIni;
var
  fi: TIniFile;
begin
 inherited;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    FindUserName:=fi.ReadString(ClassName,'username',FindUserName);
    FindEmp:=fi.ReadString(ClassName,'emp',FindEmp);
    FilterInside:=fi.ReadBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.SaveToIni;
var
  fi: TIniFile;
begin
 Inherited;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString(ClassName,'username',FindUserName);
    fi.WriteString(ClassName,'emp',FindEmp);
    fi.WriteBool(ClassName,'Inside',FilterInside);
  finally
   fi.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBUserEmp.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBUserEmp;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBUserEmp.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('username',Trim(fm.edUsername.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBUserEmp;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBUserEmp.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.emp_id:=Mainqr.fieldByName('emp_id').AsInteger;
    fm.edEmp.Text:=Mainqr.fieldByName('empname').AsString;
    fm.user_name:=Mainqr.fieldByName('user_name').AsString;
    fm.olduser_name:=fm.user_name;
    fm.edUserName.Text:=Mainqr.fieldByName('username').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('username',Trim(fm.edUsername.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbUserEmp+
           ' where username='+ QuotedStr(Mainqr.FieldByName('username').asString)+
           ' and emp_id='+Mainqr.FieldByName('emp_id').asString;
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
  if  Mainqr.isEmpty then exit;
  but:=MessageBox(Application.Handle,
                  Pchar(CaptionDelete+' текущую запись ?'),
                  ConstWarning,MB_YESNO+MB_ICONWARNING);
  if but=ID_YES then begin
    if not deleteRecord then begin
    {  ShowError(Application.Handle,
               'Доступ к приложению <'+Mainqr.FieldByName('taname').AsString+
               '> у пользователя <'+Mainqr.FieldByName('tuname').AsString+'> используется.');}
    end;
  end;
end;

procedure TfmRBUserEmp.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBUserEmp;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBUserEmp.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.emp_id:=Mainqr.fieldByName('emp_id').AsInteger;
    fm.edEmp.Text:=Mainqr.fieldByName('empname').AsString;
    fm.user_name:=Mainqr.fieldByName('user_name').AsString;
    fm.edUserName.Text:=Mainqr.fieldByName('username').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserEmp.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBUserEmp;
  filstr: string;
begin
try
 fm:=TfmEditRBUserEmp.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;
  fm.edEmp.Color:=clWindow;
  fm.edEmp.ReadOnly:=false;
  fm.edUsername.Color:=clWindow;
  fm.edUsername.ReadOnly:=false;

  if Trim(FindEmp)<>'' then fm.edEmp.Text:=FindEmp;
  if Trim(FindUserName)<>'' then fm.edUsername.Text:=FindUserName;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindEmp:=Trim(fm.edEmp.Text);
    FindUserName:=Trim(fm.edUserName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmRBUserEmp.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:='';

    isFindEmp:=Trim(FindEmp)<>'';
    isFindUserName:=Trim(FindUserName)<>'';

    if isFindEmp or isFindUserName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindEmp then begin
        addstr1:=' Upper(e.fname||'' ''||e.name||'' ''||e.sname) like '+AnsiUpperCase(QuotedStr(FilInSide+Findemp+'%'))+' ';
     end;

     if isFindUserName then begin
        addstr2:=' Upper(cb_text) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
     end;

     if (isFindEmp and isFindUserName)
       then and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


procedure TfmRBUserEmp.Button1Click(Sender: TObject);
var
  P: PUserEmpParams;
begin
  GetMem(P,SizeOf(TUserEmpParams));
  try
    FillChar(P^,SizeOf(TUserEmpParams),0);
    P.username:='adminuser';
    if _ViewEntryFromMain(tte_rbksuseremp,P,true) then begin
      ShowMessage(P.username);
    end;
  finally
    FreeMem(P,SizeOf(TUserEmpParams));
  end;

end;

end.
