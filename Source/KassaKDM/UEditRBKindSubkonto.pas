unit UEditRBKindSubkonto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, ComCtrls;

type
  TfmEditRBKindSubkonto = class(TfmEditRB)
    LTable: TLabel;
    CBTable: TComboBox;
    LFieldWithId: TLabel;
    CBFieldWithId: TComboBox;
    LName: TLabel;
    EName: TEdit;
    LFieldWithText: TLabel;
    CBFieldWithText: TComboBox;
    LInterface: TLabel;
    LLevel: TLabel;
    udLevel: TUpDown;
    ELevel: TEdit;
    cmbInterfaces: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure CBTableChange(Sender: TObject);
    procedure ELevelChange(Sender: TObject);
    procedure udLevelClick(Sender: TObject; Button: TUDBtnType);
    procedure bibClearClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function AddTriggers(id_sub: integer): Boolean;
  public
    subkonto_id: integer;
//    oldca_text: string;
//    ca_id: Integer;
//    ca_text: string;
    function DropTriggers(id_sub: integer): Boolean;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBKindSubkonto: TfmEditRBKindSubkonto;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBKindSubkonto.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBKindSubkonto.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbKindSubkonto+
          ' (SUBKONTO_ID,SUBKONTO_NAME,SUBKONTO_TABLENAME,SUBKONTO_FIELDWITHID,'+
          'SUBKONTO_FIELDWITHTEXT,SUBKONTO_NAMEINTERFACE,SUBKONTO_LEVEL) values '+
          ' (gen_id(gen_KindSubkonto_id,1),'+QuotedStr(Trim(EName.Text))+','+
          QuotedStr(Trim(AnsiUpperCase(CBTable.Text)))+','+QuotedStr(Trim(AnsiUpperCase(CBFieldWithId.Text)))+','+
          QuotedStr(Trim(AnsiUpperCase(CBFieldWithText.Text)))+','+QuotedStr(Trim(AnsiUpperCase(cmbInterfaces.Text)))+','+
          IntToStr(udLevel.Position)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    qr.Transaction.Active := true;
    sqls := 'select * from '+tbKindSubkonto+
            ' where subkonto_name='+QuotedStr(Trim(EName.Text));
    qr.SQl.Clear;
    qr.SQL.Add(sqls);
    qr.Open;
    AddTriggers(qr.FieldByName('subkonto_id').AsInteger);
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBKindSubkonto.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBKindSubkonto.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id2:=IntToStr(SUBKONTO_ID);//fmRBKindSubkonto.MainQr.FieldByname('username').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbKindSubkonto+
          ' set SUBKONTO_NAME='+QuotedStr(Trim(EName.Text))+','+
          ' SUBKONTO_NAME='+QuotedStr(Trim(EName.Text))+','+
          ' SUBKONTO_TABLENAME='+QuotedStr(Trim(AnsiUpperCase(CBTable.Text)))+','+
          ' SUBKONTO_FIELDWITHID='+QuotedStr(Trim(AnsiUpperCase(CBFieldWithId.Text)))+','+
          ' SUBKONTO_FIELDWITHTEXT='+QuotedStr(Trim(AnsiUpperCase(CBFieldWithText.Text)))+','+
          ' SUBKONTO_NAMEINTERFACE='+QuotedStr(Trim(AnsiUpperCase(cmbInterfaces.Text)))+','+
          ' SUBKONTO_LEVEL='+IntToStr(udLevel.Position)+
          ' where SUBKONTO_ID='+id2;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    AddTriggers(StrToInt(id2));
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBKindSubkonto.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBKindSubkonto.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(cmbInterfaces.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LInterface.Caption]));
    cmbInterfaces.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(EName.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LName.Caption]));
    EName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(CBTable.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LTable.Caption]));
    CBTable.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(CBFieldWithId.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LFieldWithId.Caption]));
    CBFieldWithId.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(CBFieldWithText.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LFieldWithText.Caption]));
    CBFieldWithText.SetFocus;
    Result:=false;
    exit;
  end;
  if CBTable.Items.IndexOf(trim(CBTable.Text))=-1 then begin
    MessageBox(Application.Handle,
               Pchar('Таблицы <'+Trim(CBTable.Text)+'> не существует'),
               ConstError,MB_OK+MB_ICONERROR);
    CBTable.SetFocus;
    CBFieldWithText.SetFocus;
    Result:=false;
    exit;
  end;
  if CBFieldWithId.Items.IndexOf(trim(CBFieldWithId.Text))=-1 then begin
    MessageBox(Application.Handle,
               Pchar('Поле <'+Trim(CBFieldWithId.Text)+'> в таблице <'+Trim(CBTable.Text)+'> не существует'),
               ConstError,MB_OK+MB_ICONERROR);
    CBFieldWithId.SetFocus;
    Result:=false;
    exit;
  end;
  if CBFieldWithText.Items.IndexOf(trim(CBFieldWithText.Text))=-1 then begin
    MessageBox(Application.Handle,
               Pchar('Поле <'+Trim(CBFieldWithText.Text)+'> в таблице <'+Trim(CBTable.Text)+'> не существует'),
               ConstError,MB_OK+MB_ICONERROR);
    CBFieldWithText.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBKindSubkonto.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure fmEditRBKindSubkontoGetInterfaceProc(Owner: Pointer; PGI: PGetInterface); stdcall;
begin
  if PGI.TypeInterface=ttiRBook then
    TfmEditRBKindSubkonto(Owner).cmbInterfaces.Items.Add(PGI.Name);
end;

procedure TfmEditRBKindSubkonto.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  IBDB.GetTableNames(CBTable.Items);
  udLevel.Max := 10;
  cmbInterfaces.Clear;
  _GetInterfaces(Self,fmEditRBKindSubkontoGetInterfaceProc);
end;

procedure TfmEditRBKindSubkonto.CBTableChange(Sender: TObject);
begin
  inherited;
  if CBTable.Items.IndexOf(Trim(CBTable.Text))<>-1 then begin
     IBDB.GetFieldNames(Trim(CBTable.Text),CBFieldWithId.Items);
     CBFieldWithText.Items:=CBFieldWithId.Items;
  end
  else begin
    CBFieldWithId.Items.Clear;
    CBFieldWithText.Items.Clear;
  end;
  EditChange(Sender);
end;

procedure TfmEditRBKindSubkonto.ELevelChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBKindSubkonto.udLevelClick(Sender: TObject;
  Button: TUDBtnType);
begin
  inherited;
  ELevel.Text := IntToStr(udLevel.Position);
  ChangeFlag:=true;
end;

procedure TfmEditRBKindSubkonto.bibClearClick(Sender: TObject);
begin
  inherited;
  udLevel.Position := 1;
end;

function TfmEditRBKindSubkonto.AddTriggers(id_sub: integer): Boolean;
var
  qr: TIBQuery;
  sqls,SubTabName,FieldId,maskstr,FieldText: string;
  SubLevel,i: integer;
begin
  try
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
  try
   DropTriggers(id_sub);
   qr.Database := IBDB;
   qr.Transaction := IBT;
   sqls := 'select * from '+tbKindSubkonto+
           ' where subkonto_id='+IntToStr(id_sub);
   qr.SQL.Clear;
   qr.SQl.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     SubLevel := qr.FieldByName('subkonto_level').AsInteger;
     SubTabName := Trim(qr.FieldByName('subkonto_tablename').AsString);
     FieldId := Trim(qr.FieldByName('subkonto_fieldwithid').AsString);
     FieldText := Trim(qr.FieldByName('subkonto_fieldwithtext').AsString);
   end;
   i:=1;
   while i<=SubLevel do begin
     if i=SubLevel then maskstr := QuotedStr(maskstr)+'||old.'+FieldId+'||'+QuotedStr(';%')
     else maskstr := maskstr+'%;';
     i:=i+1;
   end;

   sqls := 'CREATE TRIGGER '+SubTabName+'_BD0Kassa FOR '+SubTabName+
   ' ACTIVE BEFORE DELETE POSITION 0 '+
   ' as '+
    ' declare variable ctn integer; '+
    ' declare variable err varchar(200); '+
   ' begin '+
     ' select count(*) from cashorders '+
      ' where cashorders.co_kindkassa in (select PAKS_PA_ID from '+tbPlanAccounts_KindSubkonto+
      ' where '+tbPlanAccounts_KindSubkonto+'.PAKS_subkonto_id='+IntToStr(id_sub)+')'+' and '+
      ' cashorders.co_idinsubkas like('+(maskstr)+')'+
      ' into ctn; '+
     ' if (ctn>0) then begin '+
        ' err='+QuotedStr('Запись <')+'||old.'+FieldText+'||'+QuotedStr('> используется в кассовых ордерах')+'; '+
        ' execute procedure error(err); '+
     ' end '+
     ' select count(*) from cashorders '+
      ' where cashorders.co_idkoraccount in (select PAKS_PA_ID from '+tbPlanAccounts_KindSubkonto+
      ' where '+tbPlanAccounts_KindSubkonto+'.PAKS_subkonto_id='+IntToStr(id_sub)+')'+' and '+
      ' cashorders.co_idinsubkonto like('+(maskstr)+')'+
      ' into ctn; '+
     ' if (ctn>0) then begin '+
        ' err='+QuotedStr('Запись <')+'||old.'+FieldText+'||'+QuotedStr('> используется в кассовых ордерах')+'; '+
        ' execute procedure error(err); '+
      ' end '+
   ' end ';
   qr.SQL.Clear;
   qr.SQl.Add(sqls);
   qr.ExecSQL;
   qr.Transaction.Commit;
   qr.Transaction.Active := true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmEditRBKindSubkonto.DropTriggers(id_sub: integer): Boolean;
var
  qr: TIBQuery;
  sqls,SubTabName: string;
begin
  try
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
  try
   qr.Database := IBDB;
   qr.Transaction := IBT;
   sqls := 'select * from '+tbKindSubkonto+
           ' where subkonto_id='+IntToStr(id_sub);
   qr.SQL.Clear;
   qr.SQl.Add(sqls);
   qr.Open;
   if not qr.IsEmpty then begin
     SubTabName := Trim(qr.FieldByName('subkonto_tablename').AsString);
     sqls := 'Drop trigger '+SubTabName+
             '_BD0Kassa';
     qr.SQL.Clear;
     qr.SQl.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
     qr.Transaction.Active := true;
    end;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
        result := false;
//    TempStr:=TranslateIBError(E.Message);
//    ShowError(Handle,TempStr);
//    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
