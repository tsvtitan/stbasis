unit UEditRBAlgorithm;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,IB,
  ComCtrls;

type
  TfmEditRBAlgorithm = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    pc: TPageControl;
    tsBaseSumm: TTabSheet;
    tsFactor: TTabSheet;
    tsMultiply: TTabSheet;
    tsPercent: TTabSheet;
    lbTypeBaseSumm: TLabel;
    cmbTypeBaseSumm: TComboBox;
    grbBaseSumm: TGroupBox;
    lbbs_amountmonthsback: TLabel;
    edbs_amountmonthsback: TEdit;
    udbs_amountmonthsback: TUpDown;
    lbbs_totalamountmonths: TLabel;
    edbs_totalamountmonths: TEdit;
    udbs_totalamountmonths: TUpDown;
    lbbs_multiplyfactoraverage: TLabel;
    edbs_multiplyfactoraverage: TEdit;
    lbbs_divideamountperiod: TLabel;
    edbs_divideamountperiod: TEdit;
    udbs_divideamountperiod: TUpDown;
    lbbs_salary: TLabel;
    edbs_salary: TEdit;
    lbbs_tariffrate: TLabel;
    edbs_tariffrate: TEdit;
    lbbs_averagemonthsbonus: TLabel;
    edbs_averagemonthsbonus: TEdit;
    lbbs_annualbonuses: TLabel;
    edbs_annualbonuses: TEdit;
    lbbs_minsalary: TLabel;
    edbs_minsalary: TEdit;
    Label10: TLabel;
    cmbTypeFactor: TComboBox;
    grbTypeFactor: TGroupBox;
    lbkrv_typeratetime: TLabel;
    lbkrv_amountmonthsback: TLabel;
    edkrv_typeratetime: TEdit;
    udkrv_typeratetime: TUpDown;
    edkrv_amountmonthsback: TEdit;
    udkrv_amountmonthsback: TUpDown;
    lbkrv_totalamountmonths: TLabel;
    edkrv_totalamountmonths: TEdit;
    udkrv_totalamountmonths: TUpDown;
    Label14: TLabel;
    cmbTypeMultiply: TComboBox;
    grbMultiply: TGroupBox;
    lbu_besiderowtable: TLabel;
    edu_besiderowtable: TEdit;
    bibu_besiderowtable: TBitBtn;
    Label15: TLabel;
    cmbTypePercent: TComboBox;
    grbPercent: TGroupBox;
    lbp_percentadditionalcharge: TLabel;
    edp_percentadditionalcharge: TEdit;
    bibp_percentadditionalcharge: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbTypeBaseSummChange(Sender: TObject);
    procedure edbs_multiplyfactoraverageKeyPress(Sender: TObject;
      var Key: Char);
    procedure edbs_amountmonthsbackChange(Sender: TObject);
    procedure cmbTypeFactorChange(Sender: TObject);
    procedure edkrv_typeratetimeChange(Sender: TObject);
    procedure cmbTypeMultiplyChange(Sender: TObject);
    procedure bibu_besiderowtableClick(Sender: TObject);
    procedure cmbTypePercentChange(Sender: TObject);
    procedure edu_besiderowtableChange(Sender: TObject);
    procedure bibp_percentadditionalchargeClick(Sender: TObject);
    procedure edu_besiderowtableKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edp_percentadditionalchargeKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure edp_percentadditionalchargeChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    procedure EnableControls(wt: TWinControl; Flag: Boolean);
  public
    oldalgorithm_id: Integer;
    absence_id: Integer;
    TypePay_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure ChangeBaseSumm;
    procedure ChangeTypeFactor;
    procedure ChangeMultiply;
    procedure ChangePercent;
  end;

var
  fmEditRBAlgorithm: TfmEditRBAlgorithm;

implementation

uses USalaryTsvCode, USalaryTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBAlgorithm.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAlgorithm.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbAlgorithm,1));
    sqls:='Insert into '+tbAlgorithm+
          ' (algorithm_id,name,typefactorworktime,typebaseamount,'+
          'typepercent,typemultiply,bs_amountmonthsback,bs_totalamountmonths,'+
          'bs_divideamountperiod,bs_multiplyfactoraverage,bs_salary,bs_tariffrate,'+
          'bs_averagemonthsbonus,bs_annualbonuses,bs_minsalary,krv_typeratetime,'+
          'krv_amountmonthsback,krv_totalamountmonths,u_besiderowtable,'+
          'typepay_id) values '+
          ' ('+id+','+
          QuotedStr(Trim(edName.Text))+','+
          inttostr(cmbTypeFactor.ItemIndex)+','+
          inttostr(cmbTypeBaseSumm.ItemIndex)+','+
          inttostr(cmbTypePercent.ItemIndex)+','+
          inttostr(cmbTypeMultiply.ItemIndex)+','+
          GetStrFromCondition(edbs_amountmonthsback.Enabled,
                              edbs_amountmonthsback.Text,
                              'null')+','+
          GetStrFromCondition(edbs_totalamountmonths.Enabled,
                              edbs_totalamountmonths.Text,
                              'null')+','+
          GetStrFromCondition(edbs_divideamountperiod.Enabled,
                              edbs_divideamountperiod.Text,
                              'null')+','+
          GetStrFromCondition(edbs_multiplyfactoraverage.Enabled,
                              ChangeChar(Trim(edbs_multiplyfactoraverage.Text),',','.'),
                              'null')+','+
          GetStrFromCondition(edbs_salary.Enabled,
                              ChangeChar(Trim(edbs_salary.Text),',','.'),
                              'null')+','+
          GetStrFromCondition(edbs_tariffrate.Enabled,
                              ChangeChar(Trim(edbs_tariffrate.Text),',','.'),
                              'null')+','+
          GetStrFromCondition(edbs_averagemonthsbonus.Enabled,
                              ChangeChar(Trim(edbs_averagemonthsbonus.Text),',','.'),
                              'null')+','+
          GetStrFromCondition(edbs_annualbonuses.Enabled,
                              ChangeChar(Trim(edbs_annualbonuses.Text),',','.'),
                              'null')+','+
          GetStrFromCondition(edbs_minsalary.Enabled,
                              ChangeChar(Trim(edbs_minsalary.Text),',','.'),
                              'null')+','+
          GetStrFromCondition(edkrv_typeratetime.Enabled,
                              edkrv_typeratetime.Text,
                              'null')+','+
          GetStrFromCondition(edkrv_amountmonthsback.Enabled,
                              edkrv_amountmonthsback.Text,
                              'null')+','+
          GetStrFromCondition(edkrv_totalamountmonths.Enabled,
                              edkrv_totalamountmonths.Text,
                              'null')+','+
          GetStrFromCondition(edu_besiderowtable.Enabled,
                              inttostr(absence_id),
                              'null')+','+
          GetStrFromCondition(edp_percentadditionalcharge.Enabled,
                              inttostr(TypePay_id),
                              'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldalgorithm_id:=strtoint(id);

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

procedure TfmEditRBAlgorithm.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAlgorithm.UpdateRBooks: Boolean;
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

    id:=inttostr(oldalgorithm_id);//fmRBMilrank.MainQr.FieldByName('milrank_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbAlgorithm+
          ' set name='+QuotedStr(Trim(edName.Text))+','+
          ' typefactorworktime='+inttostr(cmbTypeFactor.ItemIndex)+','+
          ' typebaseamount='+inttostr(cmbTypeBaseSumm.ItemIndex)+','+
          ' typepercent='+inttostr(cmbTypePercent.ItemIndex)+','+
          ' typemultiply='+inttostr(cmbTypeMultiply.ItemIndex)+','+
          ' bs_amountmonthsback='+GetStrFromCondition(edbs_amountmonthsback.Enabled,
                                                      edbs_amountmonthsback.Text,
                                                      'null')+','+
          ' bs_totalamountmonths='+GetStrFromCondition(edbs_totalamountmonths.Enabled,
                                                       edbs_totalamountmonths.Text,
                                                       'null')+','+
          ' bs_divideamountperiod='+GetStrFromCondition(edbs_divideamountperiod.Enabled,
                                                        edbs_divideamountperiod.Text,
                                                        'null')+','+
          ' bs_multiplyfactoraverage='+GetStrFromCondition(edbs_multiplyfactoraverage.Enabled,
                                                           ChangeChar(Trim(edbs_multiplyfactoraverage.Text),',','.'),
                                                           'null')+','+
          ' bs_salary='+GetStrFromCondition(edbs_salary.Enabled,
                                            ChangeChar(Trim(edbs_salary.Text),',','.'),
                                            'null')+','+
          ' bs_tariffrate='+GetStrFromCondition(edbs_tariffrate.Enabled,
                                                ChangeChar(Trim(edbs_tariffrate.Text),',','.'),
                                                'null')+','+
          ' bs_averagemonthsbonus='+GetStrFromCondition(edbs_averagemonthsbonus.Enabled,
                                                        ChangeChar(Trim(edbs_averagemonthsbonus.Text),',','.'),
                                                        'null')+','+
          ' bs_annualbonuses='+GetStrFromCondition(edbs_annualbonuses.Enabled,
                                                   ChangeChar(Trim(edbs_annualbonuses.Text),',','.'),
                                                   'null')+','+
          ' bs_minsalary='+GetStrFromCondition(edbs_minsalary.Enabled,
                                               ChangeChar(Trim(edbs_minsalary.Text),',','.'),
                                               'null')+','+
          ' krv_typeratetime='+GetStrFromCondition(edkrv_typeratetime.Enabled,
                                                   edkrv_typeratetime.Text,
                                                   'null')+','+
          ' krv_amountmonthsback='+GetStrFromCondition(edkrv_amountmonthsback.Enabled,
                                                       edkrv_amountmonthsback.Text,
                                                       'null')+','+
          ' krv_totalamountmonths='+GetStrFromCondition(edkrv_totalamountmonths.Enabled,
                                                        edkrv_totalamountmonths.Text,
                                                        'null')+','+
          ' u_besiderowtable='+GetStrFromCondition(edu_besiderowtable.Enabled,
                                                   inttostr(absence_id),
                                                   'null')+','+
          ' typepay_id='+GetStrFromCondition(edp_percentadditionalcharge.Enabled,
                                                            inttostr(TypePay_id),
                                                            'null')+
          ' where algorithm_id='+id;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBAlgorithm.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBAlgorithm.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_amountmonthsback.text)='') and (edbs_amountmonthsback.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_amountmonthsback.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_amountmonthsback.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_totalamountmonths.text)='') and (edbs_totalamountmonths.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_totalamountmonths.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_totalamountmonths.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_divideamountperiod.text)='') and (edbs_divideamountperiod.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_divideamountperiod.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_divideamountperiod.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_multiplyfactoraverage.text)='') and (edbs_multiplyfactoraverage.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_multiplyfactoraverage.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_multiplyfactoraverage.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_salary.text)='') and (edbs_salary.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_salary.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_salary.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_tariffrate.text)='') and (edbs_tariffrate.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_tariffrate.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_tariffrate.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_averagemonthsbonus.text)='') and (edbs_averagemonthsbonus.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_averagemonthsbonus.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_averagemonthsbonus.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_annualbonuses.text)='') and (edbs_annualbonuses.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_annualbonuses.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_annualbonuses.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edbs_minsalary.text)='') and (edbs_minsalary.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbbs_minsalary.Caption]));
    pc.ActivePage:=tsBaseSumm;
    edbs_minsalary.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edkrv_typeratetime.text)='') and (edkrv_typeratetime.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbkrv_typeratetime.Caption]));
    pc.ActivePage:=tsFactor;
    edkrv_typeratetime.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edkrv_amountmonthsback.text)='') and (edkrv_amountmonthsback.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbkrv_amountmonthsback.Caption]));
    pc.ActivePage:=tsFactor;
    edkrv_amountmonthsback.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edkrv_totalamountmonths.text)='') and (edkrv_totalamountmonths.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbkrv_totalamountmonths.Caption]));
    pc.ActivePage:=tsFactor;
    edkrv_totalamountmonths.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edu_besiderowtable.text)='') and (edu_besiderowtable.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbu_besiderowtable.Caption]));
    pc.ActivePage:=tsMultiply;
    bibu_besiderowtable.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(edp_percentadditionalcharge.text)='') and (edp_percentadditionalcharge.Enabled)  then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbp_percentadditionalcharge.Caption]));
    pc.ActivePage:=tsPercent;
    bibp_percentadditionalcharge.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAlgorithm.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAlgorithm.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  pc.ActivePageIndex:=0;
  cmbTypeBaseSumm.ItemIndex:=0;
  ChangeBaseSumm;
  cmbTypeFactor.ItemIndex:=0;
  ChangeTypeFactor;
  cmbTypeMultiply.ItemIndex:=0;
  ChangeMultiply;
  cmbTypePercent.ItemIndex:=0;
  ChangePercent;
end;

procedure TfmEditRBAlgorithm.ChangeBaseSumm;
begin
  case cmbTypeBaseSumm.ItemIndex of
    0: begin
      EnableControls(grbBaseSumm,false);
    end;
    1:begin
      EnableControls(grbBaseSumm,false);
    end;
    2: begin
      EnableControls(grbBaseSumm,false);
    end;
    3: begin
      EnableControls(grbBaseSumm,true);

      lbbs_amountmonthsback.Enabled:=false;
      edbs_amountmonthsback.Enabled:=false;
      edbs_amountmonthsback.Color:=clBtnFace;
      udbs_amountmonthsback.Enabled:=false;

      lbbs_totalamountmonths.Enabled:=false;
      edbs_totalamountmonths.Enabled:=false;
      edbs_totalamountmonths.Color:=clBtnFace;
      udbs_totalamountmonths.Enabled:=false;

      lbbs_divideamountperiod.Enabled:=false;
      edbs_divideamountperiod.Enabled:=false;
      edbs_divideamountperiod.Color:=clBtnFace;
      udbs_divideamountperiod.Enabled:=false;

    end;
    4: begin
      EnableControls(grbBaseSumm,true);
    end;
    5: begin
      EnableControls(grbBaseSumm,false);
    end;

  end;
end;

procedure TfmEditRBAlgorithm.cmbTypeBaseSummChange(Sender: TObject);
begin
  ChangeFlag:=true;
  ChangeBaseSumm;
end;

procedure TfmEditRBAlgorithm.EnableControls(wt: TWinControl; Flag: Boolean);
var
  i: Integer;
  ct: TControl;
const
  clTrue=clWindow;
  clFalse=clBtnFace;  
begin
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    if ct is TLabel then begin
      TLabel(ct).Enabled:=Flag;
    end;
    if ct is TEdit then begin
      if Flag then TEdit(ct).Color:=clTrue
      else TEdit(ct).Color:=clFalse;
      TEdit(ct).Enabled:=Flag;
    end;
    if ct is TUpDown then begin
      TUpDown(ct).Enabled:=Flag;
    end;
    if ct is TBitBtn then begin
      TBitBtn(ct).Enabled:=Flag;
    end;
  end;
end;

procedure TfmEditRBAlgorithm.edbs_multiplyfactoraverageKeyPress(
  Sender: TObject; var Key: Char);
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

procedure TfmEditRBAlgorithm.edbs_amountmonthsbackChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAlgorithm.ChangeTypeFactor;
begin
  case cmbTypeFactor.ItemIndex of
    0: begin
      EnableControls(grbTypeFactor,false);
    end;
    1:begin
      EnableControls(grbTypeFactor,false);

      lbkrv_typeratetime.Enabled:=true;
      edkrv_typeratetime.Enabled:=true;
      edkrv_typeratetime.Color:=clWindow;
      udkrv_typeratetime.Enabled:=true;

    end;
    2: begin
      EnableControls(grbTypeFactor,false);
    end;
    3: begin
      EnableControls(grbTypeFactor,true);
    end;
  end;
end;

procedure TfmEditRBAlgorithm.cmbTypeFactorChange(Sender: TObject);
begin
  ChangeFlag:=true;
  ChangeTypeFactor;
end;

procedure TfmEditRBAlgorithm.edkrv_typeratetimeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAlgorithm.ChangeMultiply;
begin
  case cmbTypeMultiply.ItemIndex of
    0: begin
      EnableControls(grbMultiply,false);
    end;
    1:begin
      EnableControls(grbMultiply,false);
    end;
    2: begin
      EnableControls(grbMultiply,false);
    end;
    3: begin
      EnableControls(grbMultiply,false);

      lbu_besiderowtable.Enabled:=true;
      edu_besiderowtable.Enabled:=true;
      bibu_besiderowtable.Enabled:=true;

    end;
  end;
end;

procedure TfmEditRBAlgorithm.cmbTypeMultiplyChange(Sender: TObject);
begin
  ChangeFlag:=true;
  ChangeMultiply;
end;

procedure TfmEditRBAlgorithm.bibu_besiderowtableClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='absence_id';
  TPRBI.Locate.KeyValues:=absence_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAbsence,@TPRBI) then begin
   ChangeFlag:=true;
   absence_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'absence_id');
   edu_besiderowtable.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBAlgorithm.ChangePercent;
begin
  case cmbTypePercent.ItemIndex of
    0: begin
      EnableControls(grbPercent,false);
    end;
    1:begin
      EnableControls(grbPercent,false);
    end;
    2: begin
      EnableControls(grbPercent,false);
    end;
    3: begin
      EnableControls(grbPercent,false);
    end;
    4: begin
      EnableControls(grbPercent,false);
      lbp_percentadditionalcharge.Enabled:=true;
      edp_percentadditionalcharge.Enabled:=true;
      bibp_percentadditionalcharge.Enabled:=true;
    end;
    5: begin
      EnableControls(grbPercent,false);
      lbp_percentadditionalcharge.Enabled:=true;
      edp_percentadditionalcharge.Enabled:=true;
      bibp_percentadditionalcharge.Enabled:=true;
    end;
  end;
end;

procedure TfmEditRBAlgorithm.cmbTypePercentChange(Sender: TObject);
begin
  ChangeFlag:=true;
  ChangePercent;
end;

procedure TfmEditRBAlgorithm.edu_besiderowtableChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAlgorithm.bibp_percentadditionalchargeClick(
  Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypePay_id';
  TPRBI.Locate.KeyValues:=TypePay_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypePay,@TPRBI) then begin
   ChangeFlag:=true;
   TypePay_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypePay_id');
   edp_percentadditionalcharge.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBAlgorithm.edu_besiderowtableKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edu_besiderowtable.Text:='';
    absence_id:=0;
  end;
end;

procedure TfmEditRBAlgorithm.edp_percentadditionalchargeKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edp_percentadditionalcharge.Text:='';
    TypePay_id:=0;
  end;
end;

procedure TfmEditRBAlgorithm.edp_percentadditionalchargeChange(
  Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAlgorithm.bibClearClick(Sender: TObject);
begin
  inherited;
  cmbTypeFactor.ItemIndex:=0;
  cmbTypeBaseSumm.ItemIndex:=0;
  cmbTypePercent.ItemIndex:=0;
  cmbTypeMultiply.ItemIndex:=0;
end;

end.
