unit UEditRBEmpMilitary;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpMilitary = class(TfmEditRB)
    lbReady: TLabel;
    lbCraftNum: TLabel;
    edCraftNum: TEdit;
    lbDateStart: TLabel;
    dtpDateStart: TDateTimePicker;
    lbPlantName: TLabel;
    edPlantName: TEdit;
    bibPlantName: TBitBtn;
    lbMilRank: TLabel;
    edMilRank: TEdit;
    bibMilrank: TBitBtn;
    lbRank: TLabel;
    edRank: TEdit;
    bibRank: TBitBtn;
    lbGroupMil: TLabel;
    edGroupMil: TEdit;
    bibGroupMil: TBitBtn;
    lbSpecInclude: TLabel;
    edSpecInclude: TEdit;
    lbMOB: TLabel;
    edMOB: TEdit;
    lbDateFinish: TLabel;
    dtpDateFinish: TDateTimePicker;
    edReady: TEdit;
    bibReady: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure bibPlantNameClick(Sender: TObject);
    procedure bibMilrankClick(Sender: TObject);
    procedure bibRankClick(Sender: TObject);
    procedure bibGroupMilClick(Sender: TObject);
    procedure edPlantNameChange(Sender: TObject);
    procedure bibReadyClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Variant;
    plant_id: Variant;
    milrank_id: Variant;
    rank_id: Variant;
    groupmil_id: Variant;
    ready_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpMilitary: TfmEditRBEmpMilitary;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpMilitary.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpMilitary.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbMilitary,1));
    sqls:='Insert into '+tbMilitary+
          ' (military_id,emp_id,plant_id,milrank_id,rank_id,groupmil_id,'+
          'ready_id,craftnum,specinclude,mob,datestart,datefinish) values '+
          ' ('+
          id+','+
          inttostr(emp_id)+','+
          inttostr(plant_id)+','+
          inttostr(milrank_id)+','+
          inttostr(rank_id)+','+
          inttostr(groupmil_id)+','+
          inttostr(ready_id)+','+
          QuotedStr(Trim(edCraftNum.Text))+','+
          QuotedStr(Trim(edSpecInclude.Text))+','+
          QuotedStr(Trim(edMOB.Text))+','+
          GetStrFromCondition(dtpDateStart.Checked,
                              QuotedStr(DateTimeToStr(dtpDateStart.Date)),
                              'null')+','+
          GetStrFromCondition(dtpDateFinish.Checked,
                              QuotedStr(DateTimeToStr(dtpDateFinish.Date)),
                              'null')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpMilitary(false);
    ParentEmpForm.qrEmpMilitary.Locate('military_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpMilitary.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpMilitary.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpMilitary.FieldByName('military_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbMilitary+
          ' set emp_id='+inttostr(emp_id)+
          ', plant_id='+inttostr(plant_id)+
          ', milrank_id='+inttostr(milrank_id)+
          ', rank_id='+inttostr(rank_id)+
          ', groupmil_id='+inttostr(groupmil_id)+
          ', ready_id='+inttostr(ready_id)+
          ', craftnum='+QuotedStr(Trim(edCraftNum.Text))+
          ', specinclude='+QuotedStr(Trim(edSpecInclude.Text))+
          ', mob='+QuotedStr(Trim(edMOB.Text))+
          ', datestart='+GetStrFromCondition(dtpDateStart.Checked,
                              QuotedStr(DateTimeToStr(dtpDateStart.Date)),
                              'null')+
          ', datefinish='+GetStrFromCondition(dtpDateFinish.Checked,
                              QuotedStr(DateTimeToStr(dtpDateFinish.Date)),
                              'null')+
          ' where military_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpMilitary(false);
    ParentEmpForm.qrEmpMilitary.Locate('military_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpMilitary.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpMilitary.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edPlantName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPlantName.Caption]));
    bibPlantName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edMilRank.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbMilRank.Caption]));
    bibMilRank.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edRank.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRank.Caption]));
    bibRank.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edGroupMil.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbGroupMil.Caption]));
    bibGroupMil.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edReady.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbReady.Caption]));
    bibReady.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCraftNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCraftNum.Caption]));
    edCraftNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSpecInclude.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSpecInclude.Caption]));
    edSpecInclude.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edMOB.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbMOB.Caption]));
    edMOB.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpMilitary.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpMilitary.FormCreate(Sender: TObject);
var
  curdate: Tdate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edPlantName.MaxLength:=DomainNameLength;
  edMilRank.MaxLength:=DomainNameLength;
  edRank.MaxLength:=DomainNameLength;
  edGroupMil.MaxLength:=DomainNameLength;
  edCraftNum.MaxLength:=DomainSmallNameLength;
  edSpecInclude.MaxLength:=DomainSmallNameLength;
  edMOB.MaxLength:=DomainNameLength;
  edReady.MaxLength:=DomainNameLength;

  curdate:=_GetDateTimeFromServer;

  dtpDateStart.date:=curdate;
  dtpDateStart.Checked:=false;
  dtpDateFinish.date:=curdate;
  dtpDateFinish.Checked:=false;

end;

procedure TfmEditRBEmpMilitary.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpMilitary.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpMilitary.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpMilitary.bibPlantNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='plant_id';
  TPRBI.Locate.KeyValues:=plant_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPlant,@TPRBI) then begin
   ChangeFlag:=true;
   plant_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'plant_id');
   edPlantName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'smallname');
  end;
end;

procedure TfmEditRBEmpMilitary.bibMilrankClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='milrank_id';
  TPRBI.Locate.KeyValues:=milrank_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkMilrank,@TPRBI) then begin
   ChangeFlag:=true;
   milrank_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'milrank_id');
   edMilRank.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpMilitary.bibRankClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='rank_id';
  TPRBI.Locate.KeyValues:=rank_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRank,@TPRBI) then begin
   ChangeFlag:=true;
   rank_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'rank_id');
   edRank.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpMilitary.bibGroupMilClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='groupmil_id';
  TPRBI.Locate.KeyValues:=groupmil_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkGroupMil,@TPRBI) then begin
   ChangeFlag:=true;
   groupmil_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'groupmil_id');
   edGroupMil.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpMilitary.edPlantNameChange(Sender: TObject);
begin
   ChangeFlag:=true;
end;

procedure TfmEditRBEmpMilitary.bibReadyClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='ready_id';
  TPRBI.Locate.KeyValues:=ready_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkReady,@TPRBI) then begin
   ChangeFlag:=true;
   ready_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'ready_id');
   edReady.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
