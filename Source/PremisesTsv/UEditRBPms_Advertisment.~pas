unit UEditRBPms_Advertisment;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Advertisment = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    edAmount: TEdit;
    udAmount: TUpDown;
    lbAmount: TLabel;
    cmbTypeOperation: TComboBox;
    lbTypeOperation: TLabel;
    LabelSortnumber: TLabel;
    EditSortnumber: TEdit;
    UpDownSortnumber: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udAmountChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edAmountChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Advertisment_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Advertisment: TfmEditRBPms_Advertisment;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Advertisment;

{$R *.DFM}

procedure TfmEditRBPms_Advertisment.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Advertisment.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  operation:integer;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbPms_Advertisment,1));
    operation:=integer(cmbTypeOperation.Items.Objects[cmbTypeOperation.ItemIndex]);
    sqls:='Insert into '+tbPms_Advertisment+
          ' (Pms_Advertisment_id,name,amount,sortnumber,note,typeoperation) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+inttostr(udAmount.Position)+
          ','+inttostr(UpDownSortnumber.Position)+
          ','+QuotedStr(Trim(edNote.Text))+
          ','+QuotedStr(IntToStr(operation))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Advertisment_id:=strtoint(id);

    TfmRBPms_Advertisment(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Advertisment(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Advertisment(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Advertisment_id').AsInteger:=oldPms_Advertisment_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('amount').AsInteger:=udAmount.Position;
      FieldByName('sortnumber').AsInteger:=UpDownSortnumber.Position;
      FieldByName('typeoperation').AsInteger:=cmbTypeOperation.ItemIndex;

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

procedure TfmEditRBPms_Advertisment.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Advertisment.UpdateRBooks: Boolean;
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

    id:=inttostr(oldPms_Advertisment_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Advertisment+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+QuotedStr(Trim(edNote.text))+
          ', amount='+inttostr(udAmount.Position)+
          ', sortnumber='+inttostr(UpDownSortnumber.Position)+
          ', typeoperation='+inttostr(cmbTypeOperation.ItemIndex)+
          ' where Pms_Advertisment_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Advertisment(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Advertisment(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Advertisment(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Advertisment_id').AsInteger:=oldPms_Advertisment_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('amount').AsInteger:=udAmount.Position;
      FieldByName('sortnumber').AsInteger:=UpDownSortnumber.Position;
      FieldByName('typeoperation').AsInteger:=cmbTypeOperation.ItemIndex;

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

procedure TfmEditRBPms_Advertisment.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Advertisment.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNote.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    edNote.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(cmbTypeOperation.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeOperation.Caption]));
    cmbTypeOperation.SetFocus;
    Result:=false;
    exit;
  end;


end;

procedure TfmEditRBPms_Advertisment.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Advertisment.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNoteLength;
  edNote.MaxLength:=DomainNoteLength;
  edAmount.MaxLength:=3;
end;

procedure TfmEditRBPms_Advertisment.udAmountChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Advertisment.edAmountChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
