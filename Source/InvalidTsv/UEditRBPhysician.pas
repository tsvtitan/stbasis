unit UEditRBPhysician;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBPhysician = class(TfmEditRB)
    lbfname: TLabel;
    edfname: TEdit;
    lbName: TLabel;
    edName: TEdit;
    lbsname: TLabel;
    edsname: TEdit;
    lbSeatName: TLabel;
    edSeatName: TEdit;
    procedure edfnameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldphysician_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPhysician: TfmEditRBPhysician;

implementation

uses UInvalidTsvCode, UInvalidTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBPhysician.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPhysician.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPhysician,1));
    sqls:='Insert into '+tbPhysician+
          ' (physician_id,fname,name,sname,seatname) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edfname.Text))+
          ','+QuotedStr(Trim(edname.Text))+
          ','+QuotedStr(Trim(edsname.Text))+
          ','+QuotedStr(Trim(edSeatName.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldphysician_id:=strtoint(id);
 
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

procedure TfmEditRBPhysician.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPhysician.UpdateRBooks: Boolean;
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

    id:=inttostr(oldphysician_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPhysician+
          ' set fname='+QuotedStr(Trim(edfname.Text))+
          ', name='+QuotedStr(Trim(edname.Text))+
          ', sname='+QuotedStr(Trim(edsname.Text))+
          ', seatname='+QuotedStr(Trim(edseatname.Text))+
          ' where physician_id='+id;
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

procedure TfmEditRBPhysician.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPhysician.CheckFieldsFill: Boolean;
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
  if trim(edSeatName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSeatName.Caption]));
    edSeatName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPhysician.edfnameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPhysician.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edfName.MaxLength:=DomainSmallNameLength;
  edName.MaxLength:=DomainSmallNameLength;
  edsName.MaxLength:=DomainSmallNameLength;
  edSeatName.MaxLength:=DomainNameLength;
end;

end.
