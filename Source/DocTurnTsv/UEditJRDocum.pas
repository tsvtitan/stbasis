unit UEditJRDocum;

interface

{ $I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB;

type
  TfmEditJRDocum = class(TfmEditRB)
    lbTypeDocName: TLabel;
    edTypeDocName: TEdit;
    bibTypeDocName: TBitBtn;
    grbDate: TGroupBox;
    lbDateFrom: TLabel;
    dtpDateFrom: TDateTimePicker;
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    grbNum: TGroupBox;
    lbNum: TLabel;
    edNum: TEdit;
    lbPrefix: TLabel;
    edPrefix: TEdit;
    lbSufix: TLabel;
    edSufix: TEdit;
    bibDate: TBitBtn;
    bibNum: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bibTypeDocNameClick(Sender: TObject);
    procedure bibDateClick(Sender: TObject);
    procedure edTypeDocNameChange(Sender: TObject);
    procedure dtpDateFromChange(Sender: TObject);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
  private
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    Username: String;
    olddocum_id: Integer;
    typedoc_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure SetDefaultDatePosition;
  end;

var
  fmEditJRDocum: TfmEditJRDocum;

implementation

uses UDocTurnTsvCode, UDocTurnTsvData, UMainUnited, UJRDocum;

{$R *.DFM}

procedure TfmEditJRDocum.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edTypeDocName.MaxLength:=DomainNameLength;
  edNum.MaxLength:=9;
  edPrefix.MaxLength:=DomainSmallNameLength;
  edSufix.MaxLength:=DomainSmallNameLength;

  curDate:=_GetDateTimeFromServer;
  dtpDateFrom.Date:=curDate;
  dtpDateTo.Date:=curDate;
end;

procedure TfmEditJRDocum.SetDefaultDatePosition;
begin
  dtpDateFrom.Checked:=false;
  dtpDateFrom.ShowCheckbox:=false;
  dtpDateFrom.Visible:=true;
  lbDateFrom.Caption:='Дата:';
  dtpDateFrom.Left:=lbDateFrom.Left+lbDateFrom.Width+10;
  bibDate.Visible:=false;
  grbDate.Width:=160;
  grbDate.Left:=(grbNum.Left+grbNum.Width)-grbDate.Width;

  dtpDateTo.Checked:=false;
  dtpDateTo.Visible:=false;
  lbDateTo.Visible:=false;
end;

procedure TfmEditJRDocum.bibTypeDocNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  Sign: Boolean;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typedoc_id';
  TPRBI.Locate.KeyValues:=typedoc_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
   Sign:=GetFirstValueFromParamRBookInterface(@TPRBI,'sign');
   if (not Sign)or(TypeEditRBook=terbFilter) then begin
    ChangeFlag:=true;
    edTypeDocName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
    typedoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typedoc_id');
   end; 
  end;
end;

procedure TfmEditJRDocum.bibDateClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
 try
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=ReadParam(ClassName,'period',P.TypePeriod);
   P.LoadAndSave:=false;
   P.DateBegin:=dtpDateFrom.DateTime;
   P.DateEnd:=dtpDateTo.DateTime;
   if _ViewEnterPeriod(P) then begin
     dtpDateFrom.DateTime:=P.DateBegin;
     dtpDateTo.DateTime:=P.DateEnd;
     WriteParam(ClassName,'period',P.TypePeriod);
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditJRDocum.edTypeDocNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditJRDocum.dtpDateFromChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

function TfmEditJRDocum.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edTypeDocName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeDocName.Caption]));
    bibTypeDocName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditJRDocum.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

procedure TfmEditJRDocum.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmEditJRDocum.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditJRDocum.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  CU: TInfoConnectUser;
  dt: TDateTime;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    dt:=_GetDateTimeFromServer;

    qr.Database:=IBDB;
    qr.ParamCheck:=false;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbDocum,1));
    sqls:='Insert into '+tbDocum+
          ' (docum_id,typedoc_id,num,prefix,sufix,datedoc,whoadd,dateadd,whochange,datechange) values'+
          ' ('+id+
          ','+inttostr(typedoc_id)+
          ','+QuotedStr(Trim(edNum.Text))+
          ','+QuotedStr(Trim(edPrefix.Text))+
          ','+QuotedStr(Trim(edSufix.Text))+
          ','+QuotedStr(DateToStr(dtpDateFrom.Date))+
          ','+inttostr(CU.User_id)+
          ','+QuotedStr(DateTimeToStr(dt))+
          ','+inttostr(CU.User_id)+
          ','+QuotedStr(DateTimeToStr(dt))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    olddocum_id:=strtoint(id);

    TfmJRDocum(fmParent).IBUpd.InsertSQL.Clear;
    TfmJRDocum(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmJRDocum(fmParent).MainQr do begin
      Insert;
      FieldByName('docum_id').AsInteger:=olddocum_id;
      FieldByName('typedoc_id').AsInteger:=typedoc_id;
      FieldByName('typedocname').AsString:=Trim(edTypeDocName.Text);
      FieldByName('num').AsString:=Trim(edNum.Text);
      FieldByName('prefixnumsufix').AsString:=Trim(edPrefix.Text)+Trim(edNum.Text)+Trim(edSufix.Text);
      FieldByName('prefix').Required:=false;
      FieldByName('prefix').AsString:=Trim(edPrefix.Text);
      FieldByName('sufix').Required:=false;
      FieldByName('sufix').AsString:=Trim(edSufix.Text);
      FieldByName('datedoc').AsDateTime:=dtpDateFrom.Date;
      FieldByName('whoadd').Value:=CU.User_id;
      FieldByName('dateadd').AsDateTime:=dt;
      FieldByName('whochange').Value:=CU.User_id;
      FieldByName('datechange').AsDateTime:=dt;
      FieldByName('sign').AsInteger:=0;
      Post;
    end;

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

function TfmEditJRDocum.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  CU: TInfoConnectUser;
  dt: TDateTime;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    FillChar(CU,SizeOf(TInfoConnectUser),0);
    _GetInfoConnectUser(@CU);
    dt:=_GetDateTimeFromServer;

    id:=inttostr(olddocum_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbDocum+
          ' set num='+QuotedStr(Trim(edNum.Text))+
          ', prefix='+QuotedStr(Trim(edPrefix.Text))+
          ', sufix='+QuotedStr(Trim(edSufix.Text))+
          ', typedoc_id='+inttostr(typedoc_id)+
          ', datedoc='+QuotedStr(DateToStr(dtpDateFrom.Date))+
          ', whochange='+inttostr(CU.User_id)+
          ', datechange='+QuotedStr(DateTimeToStr(dt))+
          ' where docum_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmJRDocum(fmParent).IBUpd.ModifySQL.Clear;
    TfmJRDocum(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmJRDocum(fmParent).MainQr do begin
      Edit;
      FieldByName('docum_id').AsInteger:=olddocum_id;
      FieldByName('typedoc_id').AsInteger:=typedoc_id;
      FieldByName('typedocname').AsString:=Trim(edTypeDocName.Text);
      FieldByName('num').AsString:=Trim(edNum.Text);
      FieldByName('prefixnumsufix').AsString:=Trim(edPrefix.Text)+Trim(edNum.Text)+Trim(edSufix.Text);
      FieldByName('prefix').Required:=false;
      FieldByName('prefix').AsString:=Trim(edPrefix.Text);
      FieldByName('sufix').Required:=false;
      FieldByName('sufix').AsString:=Trim(edSufix.Text);
      FieldByName('datedoc').AsDateTime:=dtpDateFrom.Date;
      FieldByName('whochange').Value:=CU.User_id;
      FieldByName('datechange').AsDateTime:=dt;
      FieldByName('sign').AsInteger:=0;
      Post;
    end;

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

procedure TfmEditJRDocum.edNumKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

end.
