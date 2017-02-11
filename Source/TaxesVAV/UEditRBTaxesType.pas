unit UEditRBTaxesType;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBTaxesType = class(TfmEditRB)
    lbTaxesType: TLabel;
    edNameTaxes: TEdit;
    RGStatusTaxes: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameTaxesChange(Sender: TObject);
    procedure cbStatusTaxesClick(Sender: TObject);
    procedure cbStatusTaxesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldTaxesType_id: Integer;
    CheckStatusTaxes:Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTaxesType: TfmEditRBTaxesType;

implementation

uses UTaxesVAVCode, UTaxesVAVData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBTaxesType.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTaxesType.AddToRBooks: Boolean;
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

    CheckStatusTaxes:=RGStatusTaxes.ItemIndex;
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbTaxesType,1));
    sqls:='Insert into '+ tbTaxesType +
          ' (TaxesType_id,NameTaxes,statustaxes) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edNameTaxes.text))+
          ','+IntToStr(CheckStatusTaxes)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldTaxesType_id:=strtoint(id);

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
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

procedure TfmEditRBTaxesType.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTaxesType.UpdateRBooks: Boolean;
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
    CheckStatusTaxes:=RGStatusTaxes.ItemIndex;
    id:=inttostr(oldTaxesType_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTaxesType+
          ' set NameTaxes='+QuotedStr(Trim(edNameTaxes.text))+
          ', StatusTaxes='+IntToStr(CheckStatusTaxes)+
          ' where TaxesType_id='+id;

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
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBTaxesType.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBTaxesType.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNameTaxes.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTaxesType.Caption]));
    edNameTaxes.SetFocus;
    Result:=false;
    exit;
  end;  
  if RGStatusTaxes.ItemIndex=-1 then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[RGStatusTaxes.Caption]));
    RGStatusTaxes.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBTaxesType.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameTaxes.MaxLength:=DomainNoteLength;
//  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBTaxesType.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTaxesType.edNameTaxesChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTaxesType.cbStatusTaxesClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTaxesType.cbStatusTaxesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ChangeFlag:=true;
end;

end.



