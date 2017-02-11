unit UEditRBPms_Agent;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Agent = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    lbSortNumber: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    lbOffice: TLabel;
    ComboBoxOffice: TComboBox;
    edPhone: TEdit;
    lbPhone: TLabel;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edSortChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Agent_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure FillOffice(AOffice_Id: Integer);
  end;

var
  fmEditRBPms_Agent: TfmEditRBPms_Agent;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Agent;

{$R *.DFM}

procedure TfmEditRBPms_Agent.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Agent.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  office_id: Integer;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    office_id:=Integer(ComboBoxOffice.Items.Objects[ComboBoxOffice.ItemIndex]);

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbPms_Agent,1));
    sqls:='Insert into '+tbPms_Agent+
          ' (Pms_Agent_id,name,sync_office_id,sortnumber,note,phone) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+inttostr(office_id)+
          ','+inttostr(udSort.Position)+
          ','+QuotedStr(Trim(edNote.Text))+
          ','+QuotedStr(Trim(edPhone.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Agent_id:=strtoint(id);

    TfmRBPms_Agent(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Agent(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Agent(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Agent_id').AsInteger:=oldPms_Agent_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('sync_office_id').AsInteger:=office_id;
      FieldByName('office_name').AsString:=Trim(ComboBoxOffice.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
      FieldByName('phone').AsString:=Trim(edPhone.Text);

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

procedure TfmEditRBPms_Agent.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Agent.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  office_id: Integer;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    office_id:=Integer(ComboBoxOffice.Items.Objects[ComboBoxOffice.ItemIndex]);

    id:=inttostr(oldPms_Agent_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Agent+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', sync_office_id='+IntTostr(office_id)+
          ', note='+QuotedStr(Trim(edNote.text))+
          ', sortnumber='+inttostr(udSort.Position)+
          ', phone='+QuotedStr(Trim(edPhone.text))+
          ' where Pms_Agent_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Agent(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Agent(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Agent(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Agent_id').AsInteger:=oldPms_Agent_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('sync_office_id').AsInteger:=office_id;
      FieldByName('office_name').AsString:=Trim(ComboBoxOffice.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
      FieldByName('phone').AsString:=Trim(edPhone.Text);
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

procedure TfmEditRBPms_Agent.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Agent.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if ComboBoxOffice.ItemIndex=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbOffice.Caption]));
    ComboBoxOffice.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNote.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    edNote.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Agent.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Agent.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainShortNameLength;
  edNote.MaxLength:=DomainNoteLength;
  edSort.MaxLength:=3;
  edPhone.MaxLength:=DomainNoteLength;

end;

procedure TfmEditRBPms_Agent.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Agent.edSortChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Agent.FillOffice(AOffice_Id: Integer);
var
  qr: TIBQuery;
  sqls: string;
  id: Integer;
  Index: Integer;
  IndexNew: Integer;
begin
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:=SQLRbkSync_Office;
    qr.SQL.Add(sqls);
    qr.Open;

    if qr.Active then begin
      IndexNew:=-1;
      ComboBoxOffice.Items.BeginUpdate;
      try
        ComboBoxOffice.Clear;
        qr.First;
        while not qr.Eof do begin
          ID:=qr.FieldByName('sync_office_id').AsInteger;
          Index:=ComboBoxOffice.Items.AddObject(qr.FieldByName('name').AsString,TObject(id));
          if id=AOffice_Id then
            IndexNew:=Index;
          qr.Next;
        end;
      finally
        ComboBoxOffice.Items.EndUpdate;
        ComboBoxOffice.ItemIndex:=IndexNew;
      end;
    end;

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

end.
