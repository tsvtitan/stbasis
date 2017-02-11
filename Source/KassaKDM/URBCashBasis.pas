unit URBCashBasis;

interface

{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, IBUpdateSQL, tsvDbGrid;

type
   TfmRBCashBasis = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
  private
    isFindCB_Text: Boolean;
    FindCB_Text: String;
  protected
//    procedure GridTitleClick(Column: TColumn); override;
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBCashBasis: TfmRBCashBasis;

implementation

uses UMainUnited, UKassaKDMCode, UKassaKDMDM, UKassaKDMData,UEditRBCashBasis;

{$R *.DFM}

procedure TfmRBCashBasis.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkCashBasis;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='cb_text';
  cl.Title.Caption:='Основание кассового ордера';
  cl.Width:=180;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashBasis.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBCashBasis:=nil;
end;

procedure TfmRBCashBasis.ActiveQuery(CheckPerm: Boolean);
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
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindCB_Text);
   ViewCount;
  finally
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

{procedure TfmRBCashBasis.GridTitleClick(Column: TColumn);
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
   if UpperCase(fn)=UpperCase('cb_text') then fn:='cb_text';
   id1:=MainQr.fieldByName('cb_text').asString;
   MainQr.Active:=false;
   MainQr.SQL.Clear;
   LastOrderStr:=' Order by '+fn;
   sqls:='Select * from '+tbCashBasis+' '+
         GetFilterString+LastOrderStr;
   MainQr.SQL.Add(sqls);
   MainQr.Transaction.Active:=false;
   MainQr.Transaction.Active:=true;
   MainQr.Active:=true;
   MainQr.First;
   MainQr.Locate('cb_text',id1,[LocaseInsensitive]);
  finally
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} {on E: Exception do Assert(false,E.message); {$ENDIF}
{ end;
end;}

procedure TfmRBCashBasis.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBCashBasis.LoadFromIni;
begin
 inherited;
 try
    FindCB_Text:=ReadParam(ClassName,'cb_text',FindCB_Text);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashBasis.SaveToIni;
begin
 Inherited;
 try
   WriteParam(ClassName,'cb_text',FindCB_Text);
   WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashBasis.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBCashBasis.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBCashBasis;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBCashBasis.Create(nil);
  try
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('cb_text',Trim(fm.Edit.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashBasis.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBCashBasis;
begin
 try
  if Mainqr.isEmpty then exit;
  fm:=TfmEditRBCashBasis.Create(nil);
  try
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.cb_id:=Mainqr.fieldByName('cb_id').AsInteger;
    fm.Edit.Text:=Mainqr.fieldByName('cb_text').AsString;
    fm.cb_text:=Mainqr.fieldByName('cb_text').AsString;
    fm.oldcb_text:=fm.cb_text;
    fm.ChangeFlag := false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('cb_text',Trim(fm.Edit.Text),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashBasis.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbCashBasis+
           ' where cb_id='+ QuotedStr(Mainqr.FieldByName('cb_id').asString);
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
      ShowError(Application.Handle,
               'Доступ к приложению <'+Mainqr.FieldByName('taname').AsString+
               '> у пользователя <'+Mainqr.FieldByName('tuname').AsString+'> используется.');
    end;
  end;
end;

procedure TfmRBCashBasis.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBCashBasis;
begin
 try
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBCashBasis.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.cb_id:=Mainqr.fieldByName('cb_id').AsInteger;
    fm.Edit.Text:=Mainqr.fieldByName('cb_text').AsString;
    fm.cb_text:=Mainqr.fieldByName('cb_text').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBCashBasis.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBCashBasis;
  filstr: string;
begin
try
 inherited;
 fm:=TfmEditRBCashBasis.Create(nil);
 try
  fm.Caption:=CaptionFilter;
  fm.bibOK.OnClick:=fm.filterClick;

  if Trim(FindCB_Text)<>'' then fm.Edit.Text:=FindCB_Text;

  fm.cbInString.Visible:=true;
  fm.bibClear.Visible:=true;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    FindCB_Text:=Trim(fm.Edit.Text);

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

function TfmRBCashBasis.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr2: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then begin
      exit;
    end;

    isFindCB_Text:=Trim(FindcB_Text)<>'';

    if isFindCB_Text then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindCB_Text then begin
        addstr2:=' Upper(cb_text) like '+AnsiUpperCase(QuotedStr(FilInSide+FindCB_Text+'%'))+' ';
     end;

     Result:=wherestr+addstr2;
end;


{procedure TfmRBCashBasis.Button1Click(Sender: TObject);
var
  P: PCashBasisParams;
begin
  GetMem(P,SizeOf(TCashBasisParams));
  try
    FillChar(P^,SizeOf(TCashBasisParams),0);
    P.username:='adminuser';
    if _ViewEntryFromMain(tte_rbksCashBasis,P,true) then begin
      ShowMessage(P.username);
    end;
  finally
    FreeMem(P,SizeOf(TCashBasisParams));
  end;

end;
}

function TfmRBCashBasis.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkCashBasis+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBCashBasis.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('cb_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('cb_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
