unit UEditRBTypeBordereau;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBTypeBordereau = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbChargeName: TLabel;
    edChargeName: TEdit;
    bibChargeName: TBitBtn;
    lbPeriodsBack: TLabel;
    edPeriodsBack: TEdit;
    udPeriodsBack: TUpDown;
    lbPercent: TLabel;
    edPercent: TEdit;
    grbPeriods: TGroupBox;
    lbPeriods: TListBox;
    bibAddPeriod: TBitBtn;
    bibDelPeriod: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edChargeNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibChargeNameClick(Sender: TObject);
    procedure bibAddPeriodClick(Sender: TObject);
    procedure bibDelPeriodClick(Sender: TObject);
    procedure edPercentKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldtypebordereau_id: Integer;
    charge_id: Integer;
    lastcalcperiod_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTypeBordereau: TfmEditRBTypeBordereau;

implementation

uses USalaryTsvCode, USalaryTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBTypeBordereau.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTypeBordereau.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  i: Integer;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbTypeBordereau,1));
    sqls:='Insert into '+tbTypeBordereau+
          ' (typebordereau_id,name,charge_id,periodsback,percent) values '+
          ' ('+id+','+
          QuotedStr(Trim(edName.Text))+','+
          GetStrFromCondition(trim(edChargeName.Text)<>'',
                              inttostr(charge_id),
                              'null')+','+
          GetStrFromCondition(udPeriodsBack.Position<>0,
                              inttostr(udPeriodsBack.Position),
                              'null')+','+
          GetStrFromCondition(trim(edPercent.Text)<>'',
                              ChangeChar(Trim(edPercent.Text),',','.'),
                              'null')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    for i:=0 to lbPeriods.Items.Count-1 do begin
      sqls:='Insert into '+tbTypeBordereauCalcPeriod+
            ' (typebordereau_id,CalcPeriod_id) values '+
            '('+id+','+
            Inttostr(Integer(Pointer(TObject(lbPeriods.Items.Objects[i]))))+
            ')';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
    end;

    qr.Transaction.Commit;
    oldtypebordereau_id:=strtoint(id);

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

procedure TfmEditRBTypeBordereau.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTypeBordereau.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  i: Integer;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldtypebordereau_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTypeBordereau+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ', charge_id='+GetStrFromCondition(trim(edChargeName.Text)<>'',
                                             inttostr(charge_id),
                                             'null')+
          ', periodsback='+GetStrFromCondition(udPeriodsBack.Position<>0,
                                               inttostr(udPeriodsBack.Position),
                                               'null')+
          ', percent='+GetStrFromCondition(trim(edPercent.Text)<>'',
                                           ChangeChar(Trim(edPercent.Text),',','.'),
                                           'null')+

          ' where typebordereau_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    qr.SQL.Clear;
    sqls:='Delete from '+tbTypeBordereauCalcPeriod+' where typebordereau_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    for i:=0 to lbPeriods.Items.Count-1 do begin
      sqls:='Insert into '+tbTypeBordereauCalcPeriod+
            ' (typebordereau_id,CalcPeriod_id) values '+
            '('+id+','+
            Inttostr(Integer(Pointer(TObject(lbPeriods.Items.Objects[i]))))+
            ')';
      qr.SQL.Clear;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
    end;
    
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

procedure TfmEditRBTypeBordereau.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBTypeBordereau.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if Trim(edPercent.Text)<>'' then begin
   if not isFloat(edPercent.Text) then begin
    ShowErrorEx(Format(ConstFieldFormatInvalid,[lbPercent.Caption]));
    edPercent.SetFocus;
    Result:=false;
    exit;
   end;
  end else begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPercent.Caption]));
    edPercent.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBTypeBordereau.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBTypeBordereau.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edChargeName.MaxLength:=DomainNameLength;
  edPercent.MaxLength:=5;
  lastcalcperiod_id:=0;
end;

procedure TfmEditRBTypeBordereau.edChargeNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edChargeName.Text:='';
    charge_id:=0;
  end;
end;

procedure TfmEditRBTypeBordereau.bibChargeNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='charge_id';
  TPRBI.Locate.KeyValues:=charge_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCharge,@TPRBI) then begin
   ChangeFlag:=true;
   charge_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'charge_id');
   edChargeName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBTypeBordereau.bibAddPeriodClick(Sender: TObject);
var
  val: Integer;
  TPRBI: TParamRBookInterface;
  sname: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='CalcPeriod_id';
  TPRBI.Locate.KeyValues:=lastcalcperiod_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCalcPeriod,@TPRBI) then begin
   ChangeFlag:=true;
   lastcalcperiod_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'CalcPeriod_id');
   sname:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   val:=lbPeriods.Items.IndexOfObject(TObject(Pointer(lastcalcperiod_id)));
   if val=-1 then begin
     lbPeriods.Items.AddObject(sname,TObject(Pointer(lastcalcperiod_id)));
   end else begin
     lbPeriods.ItemIndex:=val;
   end;
  end;
end;

procedure TfmEditRBTypeBordereau.bibDelPeriodClick(Sender: TObject);
var
  i: Integer;
begin
  if lbPeriods.ItemIndex<>-1 then begin
    ChangeFlag:=true;
    for i:=lbPeriods.Items.Count-1 downto 0 do begin
      if lbPeriods.Selected[i] then
        lbPeriods.Items.Delete(i);
    end;
  end;
end;

procedure TfmEditRBTypeBordereau.edPercentKeyPress(Sender: TObject;
  var Key: Char);
var
  APos: Integer;
begin
  ChangeFlag:=true;
  if (not (Key in ['0'..'9']))and
   (Key<>DecimalSeparator)and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;

end.
