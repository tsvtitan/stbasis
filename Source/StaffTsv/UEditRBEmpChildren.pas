unit UEditRBEmpChildren;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpChildren = class(TfmEditRB)
    lbFname: TLabel;
    edFName: TEdit;
    lbname: TLabel;
    edname: TEdit;
    lbsname: TLabel;
    edsname: TEdit;
    lbbirthdate: TLabel;
    dtpBirthdate: TDateTimePicker;
    lbSex: TLabel;
    edSex: TEdit;
    bibSex: TBitBtn;
    lbAddress: TLabel;
    edAddress: TEdit;
    lbWorkPlace: TLabel;
    edWorkPlace: TEdit;
    lbTypeRelation: TLabel;
    edTypeRelation: TEdit;
    bibTypeRelation: TBitBtn;
    procedure edFNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibTypeRelationClick(Sender: TObject);
    procedure bibSexClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    sex_id: Integer;
    typerelation_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpChildren: TfmEditRBEmpChildren;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpChildren.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpChildren.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbEmpChildren,1));
    sqls:='Insert into '+tbEmpChildren+
          ' (children_id,emp_id,sex_id,typerelation_id'+
          ',fname,name,sname,birthdate,address,workplace) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          GetStrFromCondition(Trim(edSex.Text)<>'',
                              inttostr(sex_id),
                              'null')+','+
          inttostr(typerelation_id)+','+
          QuotedStr(Trim(edFName.Text))+','+
          QuotedStr(Trim(edName.Text))+','+
          QuotedStr(Trim(edSName.Text))+','+
          QuotedStr(DateTimeToStr(dtpBirthdate.Date))+','+
          QuotedStr(Trim(edAddress.Text))+','+
          QuotedStr(Trim(edWorkPlace.Text))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpChildren(false);
    ParentEmpForm.qrEmpChildren.Locate('children_id',id,[LocaseInsensitive]);
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpChildren.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpChildren.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=ParentEmpForm.qrEmpChildren.FieldByName('children_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpChildren+
          ' set emp_id='+inttostr(emp_id)+
          ', typerelation_id='+inttostr(typerelation_id)+
          ', sex_id='+GetStrFromCondition(Trim(edSex.Text)<>'',
                                          inttostr(sex_id),
                                          'null')+
          ', fname='+QuotedStr(Trim(edFName.Text))+
          ', name='+QuotedStr(Trim(edName.Text))+
          ', sname='+QuotedStr(Trim(edsName.Text))+
          ', birthdate='+QuotedStr(DatetimeToStr(dtpBirthdate.Date))+
          ', address='+QuotedStr(Trim(edAddress.Text))+
          ', workplace='+QuotedStr(Trim(edWorkPlace.Text))+
          ' where children_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpChildren(false);
    ParentEmpForm.qrEmpChildren.Locate('children_id',id,[LocaseInsensitive]);
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBEmpChildren.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpChildren.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edFname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFname.Caption]));
    edFname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbname.Caption]));
    edname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edsname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbsname.Caption]));
    edsname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAddress.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAddress.Caption]));
    edAddress.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edWorkPlace.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbWorkPlace.Caption]));
    edWorkPlace.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTypeRelation.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeRelation.Caption]));
    bibTypeRelation.SetFocus;
    Result:=false;
    exit;
  end;
{  if trim(edSex.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSex.Caption]));
    bibSex.SetFocus;
    Result:=false;
    exit;
  end;}
end;

procedure TfmEditRBEmpChildren.edFNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpChildren.FormCreate(Sender: TObject);
var
  curdate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edFName.MaxLength:=DomainNameLength;
  edname.MaxLength:=DomainNameLength;
  edsname.MaxLength:=DomainNameLength;
  edAddress.MaxLength:=DomainNameLength;
  edWorkPlace.MaxLength:=DomainNameLength;

  curdate:=_GetDateTimeFromServer;
  dtpBirthdate.date:=curdate;
end;

procedure TfmEditRBEmpChildren.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpChildren.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpChildren.bibTypeRelationClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typerelation_id';
  TPRBI.Locate.KeyValues:=typerelation_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeRelation,@TPRBI) then begin
   ChangeFlag:=true;
   typerelation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typerelation_id');
   edTypeRelation.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpChildren.bibSexClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sex_id';
  TPRBI.Locate.KeyValues:=sex_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeRelation,@TPRBI) then begin
   ChangeFlag:=true;
   sex_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sex_id');
   edSex.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
