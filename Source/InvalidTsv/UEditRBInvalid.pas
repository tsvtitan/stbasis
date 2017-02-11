unit UEditRBInvalid;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, Mask;

type
  TfmEditRBInvalid = class(TfmEditRB)
    lbfname: TLabel;
    edfname: TEdit;
    lbName: TLabel;
    edname: TEdit;
    lbsname: TLabel;
    edsname: TEdit;
    lbAddress: TLabel;
    edAddress: TEdit;
    lbBirthDate: TLabel;
    dtpBirthDate: TDateTimePicker;
    chbChildHood: TCheckBox;
    chbIVO: TCheckBox;
    chbUVO: TCheckBox;
    chbAutotransport: TCheckBox;
    meYear: TMaskEdit;
    procedure edfnameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpBirthDateChange(Sender: TObject);
    procedure chbChildHoodClick(Sender: TObject);
    procedure meYearExit(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldinvalid_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure SetYearByDate;
  end;

var
  fmEditRBInvalid: TfmEditRBInvalid;

implementation

uses UInvalidTsvCode, UInvalidTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBInvalid.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBInvalid.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbInvalid,1));
    sqls:='Insert into '+tbInvalid+
          ' (invalid_id,fname,name,sname,birthdate,address,childhood,uvo,ivo,autotransport) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edfname.Text))+
          ','+QuotedStr(Trim(edname.Text))+
          ','+QuotedStr(Trim(edsname.Text))+
          ','+QuotedStr(DateToStr(dtpBirthDate.Date))+
          ','+iff(Trim(edAddress.Text)<>'',QuotedStr(Trim(edAddress.Text)),'null')+
          ','+inttostr(Integer(chbChildHood.Checked))+
          ','+inttostr(Integer(chbUVO.Checked))+
          ','+inttostr(Integer(chbIVO.Checked))+
          ','+inttostr(Integer(chbAutotransport.Checked))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldinvalid_id:=strtoint(id);
 
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

procedure TfmEditRBInvalid.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBInvalid.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldinvalid_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbInvalid+
          ' set fname='+QuotedStr(Trim(edfname.Text))+
          ', name='+QuotedStr(Trim(edname.Text))+
          ', sname='+QuotedStr(Trim(edsname.Text))+
          ', birthdate='+QuotedStr(DateToStr(dtpBirthDate.Date))+
          ', address='+iff(Trim(edAddress.Text)<>'',QuotedStr(Trim(edAddress.Text)),'null')+
          ', childhood='+inttostr(Integer(chbChildHood.Checked))+
          ', uvo='+inttostr(Integer(chbUVO.Checked))+
          ', ivo='+inttostr(Integer(chbIVO.Checked))+
          ', autotransport='+inttostr(Integer(chbAutotransport.Checked))+
          ' where invalid_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

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

procedure TfmEditRBInvalid.ChangeClick(Sender: TObject);
begin
  meYearExit(nil);
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBInvalid.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edfname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbfName.Caption]));
    edfName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edsName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbsName.Caption]));
    edsName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(meYear.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbBirthDate.Caption]));
    meYear.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBInvalid.edfnameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBInvalid.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edfname.MaxLength:=DomainSmallNameLength;
  edname.MaxLength:=DomainSmallNameLength;
  edsname.MaxLength:=DomainSmallNameLength;
  dtpBirthDate.DateTime:=_GetDateTimeFromServer;
  edAddress.MaxLength:=DomainNameLength;

  SetYearByDate;
end;

procedure TfmEditRBInvalid.dtpBirthDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBInvalid.chbChildHoodClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBInvalid.SetYearByDate;
begin
  meYear.Text:=FormatDateTime(fmtYear,dtpBirthDate.DateTime);
end;

procedure TfmEditRBInvalid.meYearExit(Sender: TObject);
var
  dt: TDateTime;
begin
  try
    dt:=EncodeDate(StrToInt(meYear.Text),1,1);
    dtpBirthDate.DateTime:=dt;
  except
    on E: Exception do begin
      ShowErrorEx(ConstInvalidYear);
      meYear.SetFocus;
    end;  
  end;
end;

end.
