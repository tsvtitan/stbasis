unit UEditRBPms_Premises_Advertisment;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Premises_Advertisment = class(TfmEditRB)
    lbAdvertisment: TLabel;
    edAdvertisment: TEdit;
    edAgent: TEdit;
    lbAgent: TLabel;
    lbPremises: TLabel;
    edPremises: TEdit;
    btAdvertisment: TButton;
    btPremises: TButton;
    btAgent: TButton;
    procedure edAdvertismentChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edPremisesChange(Sender: TObject);
    procedure btAdvertismentClick(Sender: TObject);
    procedure btPremisesClick(Sender: TObject);
    procedure btAgentClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Advertisment_id: Integer;
    oldPms_Agent_id: Integer;
    oldPms_Premises_id: Integer;
    Pms_Advertisment_id: Integer;
    Pms_Premises_id: Integer;
    Pms_Agent_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Premises_Advertisment: TfmEditRBPms_Premises_Advertisment;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Premises_Advertisment;

{$R *.DFM}

procedure TfmEditRBPms_Premises_Advertisment.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Premises_Advertisment.AddToRBooks: Boolean;
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
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbPms_Premises_Advertisment+
          ' (Pms_Advertisment_id,Pms_Premises_id,Pms_Agent_id) values '+
          ' ('+inttostr(Pms_Advertisment_id)+
          ','+inttostr(Pms_Premises_id)+
          ','+inttostr(Pms_Agent_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Advertisment_id:=Pms_Advertisment_id;
    oldPms_Premises_id:=Pms_Premises_id;
    oldPms_Agent_id:=Pms_Agent_id;


    TfmRBPms_Premises_Advertisment(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Premises_Advertisment(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Premises_Advertisment(fmParent).MainQr do begin
      Insert;
       FieldByName('pms_advertisment_id').AsInteger:=Pms_Advertisment_id;
       FieldByName('pms_agent_id').AsInteger:=Pms_Agent_id;
       FieldByName('pms_premises_id').AsInteger:=Pms_Premises_id;
    //   FieldByName('advertisment_name').AsString:=edAdvertisment.Text;
      // FieldByName('agent_name').AsString:=edAgent.Text;
       FieldByName('premises_id').AsString:=edPremises.text;
      Post;

    end;
    TfmRBPms_Premises_Advertisment(fmParent).ActiveQuery(true);
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

procedure TfmEditRBPms_Premises_Advertisment.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Premises_Advertisment.UpdateRBooks: Boolean;
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

    sqls:='Update '+tbPms_Premises_Advertisment+
          ' set pms_advertisment_id='+inttostr(Pms_Advertisment_id)+
          ', pms_agent_id='+inttostr(Pms_Agent_id)+
          ', pms_premises_id='+inttostr(Pms_Premises_id)+
          ' where pms_advertisment_id='+IntToStr(oldPms_Advertisment_id)+' and pms_agent_id='
           +IntToStr(oldPms_Agent_id)+' and pms_premises_id='+IntToStr(oldPms_Premises_id);;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Premises_Advertisment(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Premises_Advertisment(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Premises_Advertisment(fmParent).MainQr do begin
      Edit;
       FieldByName('pms_advertisment_id').AsInteger:=Pms_Advertisment_id;
       FieldByName('pms_agent_id').AsInteger:=Pms_Agent_id;
       FieldByName('pms_premises_id').AsInteger:=Pms_Premises_id;
      Post;
    end;
    TfmRBPms_Premises_Advertisment(fmParent).ActiveQuery(true);
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

procedure TfmEditRBPms_Premises_Advertisment.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Premises_Advertisment.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edAdvertisment.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAdvertisment.Caption]));
    edAdvertisment.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPremises.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPremises.Caption]));
    edPremises.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAgent.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAgent.Caption]));
    edAgent.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Premises_Advertisment.edAdvertismentChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Premises_Advertisment.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
 {
  edName.MaxLength:=DomainShortNameLength;
  edNote.MaxLength:=DomainNoteLength;
  edSort.MaxLength:=3;
}end;

procedure TfmEditRBPms_Premises_Advertisment.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Premises_Advertisment.edPremisesChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Premises_Advertisment.btAdvertismentClick(Sender: TObject);
 var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_advertisment_id';
  TPRBI.Locate.KeyValues:=Pms_Advertisment_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPms_Advertisment,@TPRBI) then begin
   ChangeFlag:=true;
   Pms_Advertisment_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_advertisment_id');
   edAdvertisment.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBPms_Premises_Advertisment.btPremisesClick(
  Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_premises_id';
  TPRBI.Locate.KeyValues:=Pms_Premises_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPms_Premises,@TPRBI) then begin
   ChangeFlag:=true;
   Pms_Premises_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_premises_id');
   edPremises.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_premises_id');
   if lbAgent.Caption<>'Агент:' then begin
     Pms_Agent_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_agent_id');
     edAgent.text:=inttostr(Pms_Agent_id);
   end;
  end;
end;

procedure TfmEditRBPms_Premises_Advertisment.btAgentClick(Sender: TObject);
 var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_agent_id';
  TPRBI.Locate.KeyValues:=Pms_Agent_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPms_Agent,@TPRBI) then begin
   ChangeFlag:=true;
     Pms_Agent_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_agent_id');
     edAgent.text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   end;
  

end;

end.
