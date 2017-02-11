unit UEditRBVisit;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBVisit = class(TfmEditRB)
    lbVisitDate: TLabel;
    lbInvalidFio: TLabel;
    edInvalidFio: TEdit;
    bibInvalidFio: TBitBtn;
    dtpVisitDate: TDateTimePicker;
    lbInvalidGroup: TLabel;
    lbSick: TLabel;
    edSick: TEdit;
    bibSick: TBitBtn;
    lbDeterminationDate: TLabel;
    dtpDeterminationDate: TDateTimePicker;
    lbPhysician: TLabel;
    lbViewPlace: TLabel;
    lbInvalidCategory: TLabel;
    dtpVisitDateTo: TDateTimePicker;
    bibVisitDate: TBitBtn;
    lbVisitDateTo: TLabel;
    cmbInvalidGroup: TComboBox;
    cmbPhysician: TComboBox;
    cmbViewPlace: TComboBox;
    cmbInvalidCategory: TComboBox;
    cmbComingInvalidGroup: TComboBox;
    lbOrdinal: TLabel;
    edOrdinal: TEdit;
    lbSickGroup: TLabel;
    edSickGroup: TEdit;
    bibSickGroup: TBitBtn;
    rbComingInvalidGroup: TRadioButton;
    rbFirstUvo: TRadioButton;
    lbBranch: TLabel;
    cmbBranch: TComboBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpVisitDateChange(Sender: TObject);
    procedure bibInvalidFioClick(Sender: TObject);
    procedure bibSickClick(Sender: TObject);
    procedure bibVisitDateClick(Sender: TObject);
    procedure bibSickGroupClick(Sender: TObject);
    procedure rbComingInvalidGroupClick(Sender: TObject);
  private
    FAutotransport: Boolean; 
    procedure SetAutotransport(Value: Boolean);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;

    procedure SetLastComingInvalidGroup(InInvalid_id: Integer);
    function GetMaxOrdinalNumber: Integer;
  public
    oldvisit_id: Integer;
    sick_id,sickgroup_id,invalid_id: Variant;
    property Autotransport: Boolean read FAutotransport write SetAutotransport;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

    procedure SetEnabledFilter(isEnabled: Boolean);
    procedure FillInvalidGroup;
    procedure FillPhysician;
    procedure FillViewPlace;
    procedure FillInvalidCategory;
    procedure FillOrdinalNumber;
    procedure FillBranch;
  end;

var
  fmEditRBVisit: TfmEditRBVisit;

implementation

uses UInvalidTsvCode, UInvalidTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBVisit.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBVisit.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;

  vp_id,dd,ic_id,ci_id,p_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    if cmbViewPlace.Enabled then vp_id:=inttostr(Integer(Pointer(cmbViewPlace.Items.Objects[cmbViewPlace.ItemIndex])))
    else vp_id:='null';

    if dtpDeterminationDate.Enabled then dd:=QuotedStr(DateToStr(dtpDeterminationDate.Date))
    else dd:='null';

    if cmbInvalidCategory.Enabled then ic_id:=inttostr(Integer(Pointer(cmbInvalidCategory.Items.Objects[cmbInvalidCategory.ItemIndex])))
    else ic_id:='null';

    if cmbComingInvalidGroup.Enabled then ci_id:=inttostr(Integer(Pointer(cmbComingInvalidGroup.Items.Objects[cmbComingInvalidGroup.ItemIndex])))
    else ci_id:='null';

    if cmbPhysician.Enabled then p_id:=inttostr(Integer(Pointer(cmbPhysician.Items.Objects[cmbPhysician.ItemIndex])))
    else p_id:='null';


    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbVisit,1));
    sqls:='Insert into '+tbVisit+
          ' (visit_id,visitdate,sickname,sickgroup_id,invalid_id,inputdate,viewplace_id,determinationdate,'+
          'invalidcategory_id,invalidgroup_id,cominginvalidgroup_id,branch_id,ordinalnumber,physician_id,firstuvo) values '+
          ' ('+id+
          ','+QuotedStr(DateToStr(dtpVisitDate.Date))+
          ','+iff(Trim(edSick.Text)<>'',QuotedStr(Trim(edSick.Text)),'null')+
          ','+inttostr(sickgroup_id)+
          ','+inttostr(invalid_id)+
          ','+QuotedStr(DateToStr(_GetDateTimeFromServer))+
          ','+vp_id+
          ','+dd+
          ','+ic_id+
          ','+inttostr(Integer(Pointer(cmbInvalidGroup.Items.Objects[cmbInvalidGroup.ItemIndex])))+
          ','+ci_id+
          ','+inttostr(Integer(Pointer(cmbBranch.Items.Objects[cmbBranch.ItemIndex])))+
          ','+Trim(edOrdinal.text)+
          ','+p_id+
          ','+iff(rbFirstUvo.Checked,'1','0')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldvisit_id:=strtoint(id);

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

procedure TfmEditRBVisit.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBVisit.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
  vp_id,dd,ic_id,ci_id,p_id: string;
  
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    if cmbViewPlace.Enabled then vp_id:=inttostr(Integer(Pointer(cmbViewPlace.Items.Objects[cmbViewPlace.ItemIndex])))
    else vp_id:='null';

    if dtpDeterminationDate.Enabled then dd:=QuotedStr(DateToStr(dtpDeterminationDate.Date))
    else dd:='null';

    if cmbInvalidCategory.Enabled then ic_id:=inttostr(Integer(Pointer(cmbInvalidCategory.Items.Objects[cmbInvalidCategory.ItemIndex])))
    else ic_id:='null';

    if cmbComingInvalidGroup.Enabled then ci_id:=inttostr(Integer(Pointer(cmbComingInvalidGroup.Items.Objects[cmbComingInvalidGroup.ItemIndex])))
    else ci_id:='null';

    if cmbPhysician.Enabled then p_id:=inttostr(Integer(Pointer(cmbPhysician.Items.Objects[cmbPhysician.ItemIndex])))
    else p_id:='null';

    id:=inttostr(oldvisit_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbVisit+
          ' set visitdate='+QuotedStr(DateToStr(dtpVisitDate.Date))+
          ', sickname='+iff(Trim(edSick.Text)<>'',QuotedStr(Trim(edSick.Text)),'null')+
          ', sickgroup_id='+inttostr(sickgroup_id)+
          ', invalid_id='+inttostr(invalid_id)+
          ', viewplace_id='+vp_id+
          ', determinationdate='+dd+
          ', invalidcategory_id='+ic_id+
          ', invalidgroup_id='+inttostr(Integer(Pointer(cmbInvalidGroup.Items.Objects[cmbInvalidGroup.ItemIndex])))+
          ', cominginvalidgroup_id='+ci_id+
          ', branch_id='+inttostr(Integer(Pointer(cmbBranch.Items.Objects[cmbBranch.ItemIndex])))+
          ', physician_id='+p_id+
          ', ordinalnumber='+Trim(edOrdinal.text)+
          ', firstuvo='+iff(rbFirstUvo.Checked,'1','0')+
          ' where visit_id='+id;
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

procedure TfmEditRBVisit.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBVisit.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edOrdinal.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbOrdinal.Caption]));
    edOrdinal.SetFocus;
    Result:=false;
    exit;
  end;
  if not isInteger(edOrdinal.Text) then begin
    ShowErrorEx(Format(ConstFieldFormatInvalid,[lbOrdinal.Caption]));
    edOrdinal.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edInvalidFio.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbInvalidFio.Caption]));
    bibInvalidFio.SetFocus;
    Result:=false;
    exit;
  end;
  if not FAutotransport and (cmbComingInvalidGroup.ItemIndex=-1) and rbComingInvalidGroup.Checked then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[rbComingInvalidGroup.Caption]));
    cmbComingInvalidGroup.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbInvalidGroup.ItemIndex=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbInvalidGroup.Caption]));
    cmbInvalidGroup.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSickGroup.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSickGroup.Caption]));
    bibSickGroup.SetFocus;
    Result:=false;
    exit;
  end;
  if not FAutotransport and (cmbPhysician.ItemIndex=-1) then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPhysician.Caption]));
    cmbPhysician.SetFocus;
    Result:=false;
    exit;
  end;
  if not FAutotransport and (cmbViewPlace.ItemIndex=-1) then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbViewPlace.Caption]));
    cmbViewPlace.SetFocus;
    Result:=false;
    exit;
  end;
  if not FAutotransport and (cmbInvalidCategory.ItemIndex=-1) then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbInvalidCategory.Caption]));
    cmbInvalidCategory.SetFocus;
    Result:=false;
    exit;
  end;
  if (cmbBranch.ItemIndex=-1) then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbBranch.Caption]));
    cmbBranch.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBVisit.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBVisit.FormCreate(Sender: TObject);
var
  dt: TDateTime;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  
  FAutotransport:=false;

  dt:=_GetDateTimeFromServer;
  dtpVisitDate.DateTime:=dt;
  dtpVisitDate.Checked:=false;
  dtpVisitDateTo.DateTime:=dt;
  dtpVisitDateTo.Checked:=false;
  dtpDeterminationDate.DateTime:=dt;

  edInvalidFio.MaxLength:=DomainSmallNameLength+DomainSmallNameLength+DomainSmallNameLength;
  cmbComingInvalidGroup.MaxLength:=DomainNameLength;
  cmbInvalidGroup.MaxLength:=DomainNameLength;
  edSickGroup.MaxLength:=DomainNameLength;
  edSick.MaxLength:=DomainNameLength;
  cmbPhysician.MaxLength:=DomainSmallNameLength+DomainSmallNameLength+DomainSmallNameLength;
  cmbViewPlace.MaxLength:=DomainNameLength;
  cmbInvalidCategory.MaxLength:=DomainNameLength;
  cmbBranch.MaxLength:=DomainNameLength;
  edOrdinal.MaxLength:=9;
end;

procedure TfmEditRBVisit.dtpVisitDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBVisit.bibInvalidFioClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='invalid_id';
  TPRBI.Locate.KeyValues:=invalid_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkInvalid,@TPRBI) then begin
   ChangeFlag:=true;
   invalid_id:=GetFirstValueFromPRBI(@TPRBI,'invalid_id');
   edInvalidFio.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'fname')+' '+
                      GetFirstValueFromParamRBookInterface(@TPRBI,'name')+' '+
                      GetFirstValueFromParamRBookInterface(@TPRBI,'sname');
   if TypeEditRBook=terbAdd then
     SetLastComingInvalidGroup(invalid_id);
   autotransport:=GetFirstValueFromPRBI(@TPRBI,'autotransport')=1;
  end;
end;

procedure TfmEditRBVisit.bibSickClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sick_id';
  TPRBI.Locate.KeyValues:=sick_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSick,@TPRBI) then begin
   ChangeFlag:=true;
   sick_id:=GetFirstValueFromPRBI(@TPRBI,'sick_id');
   edSick.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBVisit.SetEnabledFilter(isEnabled: Boolean);
begin
  if isEnabled then begin

    lbVisitDate.Caption:='Дата посещения с:';
    dtpVisitDate.ShowCheckbox:=true;
    dtpVisitDate.Checked:=false;
    lbVisitDateTo.Visible:=true;
    dtpVisitDateTo.Visible:=true;
    dtpVisitDateTo.ShowCheckbox:=true;
    dtpVisitDateTo.Checked:=false;
    bibVisitDate.Visible:=true;

    edInvalidFio.ReadOnly:=false;
    edInvalidFio.Color:=clWindow;

    cmbComingInvalidGroup.Style:=csDropDown;
    cmbComingInvalidGroup.Color:=clWindow;

    cmbInvalidGroup.Style:=csDropDown;
    cmbInvalidGroup.Color:=clWindow;

    edSickGroup.ReadOnly:=false;
    edSickGroup.Color:=clWindow;;

    lbSick.Enabled:=false;
    edSick.Enabled:=false;
    edSick.Color:=clBtnFace;
    bibSick.Enabled:=false;
    
    dtpDeterminationDate.Enabled:=false;
    dtpDeterminationDate.Color:=clBtnFace;

    cmbPhysician.Style:=csDropDown;
    cmbPhysician.Color:=clWindow;

    cmbViewPlace.Style:=csDropDown;
    cmbViewPlace.Color:=clWindow;

    cmbInvalidCategory.Style:=csDropDown;
    cmbInvalidCategory.Color:=clWindow;

    cmbBranch.Style:=csDropDown;
    cmbBranch.Color:=clWindow;

  end else begin

  end;
end;

procedure TfmEditRBVisit.bibVisitDateClick(Sender: TObject);
var
  T: TInfoEnterPeriod;
begin
  T.DateBegin:=dtpVisitDate.Date;
  T.DateEnd:=dtpVisitDateTo.Date;
  T.LoadAndSave:=false;
  T.TypePeriod:=tepMonth;
  if _ViewEnterPeriod(@T) then begin
    dtpVisitDate.Date:=T.DateBegin;
    dtpVisitDateTo.Date:=T.DateEnd;
  end;
end;

procedure TfmEditRBVisit.FillInvalidGroup;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkInvalidGroup,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbComingInvalidGroup.Items.BeginUpdate;
    cmbInvalidGroup.Items.BeginUpdate;
    try
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'invalidgroup_id');
        cmbInvalidGroup.Items.AddObject(sname,TObject(Pointer(id)));
        cmbComingInvalidGroup.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbInvalidGroup.Items.EndUpdate;
      cmbComingInvalidGroup.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBVisit.FillPhysician;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkPhysician,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbPhysician.Items.BeginUpdate;
    try
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'fname')+' '+
               GetValueByPRBI(@TPRBI,i,'name')+' '+
               GetValueByPRBI(@TPRBI,i,'sname');
        id:=GetValueByPRBI(@TPRBI,i,'physician_id');
        cmbPhysician.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbPhysician.Items.EndUpdate;
    end;  
  end;
end;

procedure TfmEditRBVisit.FillViewPlace;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkViewPlace,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbViewPlace.Items.BeginUpdate;
    try
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'viewplace_id');
        cmbViewPlace.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbViewPlace.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBVisit.FillInvalidCategory;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkInvalidCategory,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbInvalidCategory.Items.BeginUpdate;
    try
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'invalidcategory_id');
        cmbInvalidCategory.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbInvalidCategory.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBVisit.FillBranch;
var
  TPRBI: TParamRBookInterface;
  i,s,e: Integer;
  sname: string;
  id: Integer;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  if _ViewInterfaceFromName(NameRbkBranch,@TPRBI) then begin
    GetStartAndEndByPRBI(@TPRBI,s,e);
    cmbBranch.Items.BeginUpdate;
    try
      for i:=s to e do begin
        sname:=GetValueByPRBI(@TPRBI,i,'name');
        id:=GetValueByPRBI(@TPRBI,i,'branch_id');
        cmbBranch.Items.AddObject(sname,TObject(Pointer(id)));
      end;
    finally
      cmbBranch.Items.EndUpdate;
    end;
  end;
end;

procedure TfmEditRBVisit.SetLastComingInvalidGroup(InInvalid_id: Integer);
var
  TPRBI: TParamRBookInterface;
  sname: string;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' where v.invalid_id='+IntToStr(InInvalid_id)+' ');
  TPRBI.Condition.OrderStr:=PChar(' order by v.visitdate desc ');
  if _ViewInterfaceFromName(NameRbkVisit,@TPRBI) then begin
    sname:=GetFirstValueFromPRBI(@TPRBI,'invalidgroupname');
    cmbComingInvalidGroup.ItemIndex:=cmbComingInvalidGroup.Items.IndexOf(sname);
  end;
end;

procedure TfmEditRBVisit.FillOrdinalNumber;
begin
  edOrdinal.Text:=inttostr(GetMaxOrdinalNumber);
end;

function TfmEditRBVisit.GetMaxOrdinalNumber: Integer;
var
  TPRBI: TParamRBookInterface;
  dt: TDateTime;
  dbegin,dend: string;
begin
  Result:=0;
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.SQL.Select:=PChar('Select max(ordinalnumber)+1 as maxvalue from '+tbVisit+' ');
  dt:=_GetDateTimeFromServer;
  dbegin:=QuotedStr('01.01.'+FormatDateTime(fmtYear,dt));
  dend:=QuotedStr('31.12.'+FormatDateTime(fmtYear,dt));
  TPRBI.Condition.WhereStr:=PChar(' visitdate>='+dbegin+' and visitdate<='+dend+' ');
  if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
    Result:=GetFirstValueFromPRBI(@TPRBI,'maxvalue');
    if Result=0 then Result:=1;
  end;
end;

procedure TfmEditRBVisit.bibSickGroupClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sickgroup_id';
  TPRBI.Locate.KeyValues:=sickgroup_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSickGroup,@TPRBI) then begin
   ChangeFlag:=true;
   sickgroup_id:=GetFirstValueFromPRBI(@TPRBI,'sickgroup_id');
   edSickGroup.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBVisit.SetAutotransport(Value: Boolean);
begin
  if Value<>FAutotransport then begin
    rbComingInvalidGroup.Enabled:=not Value;
    rbComingInvalidGroup.Checked:=true;
    cmbComingInvalidGroup.Enabled:=not Value;
    cmbComingInvalidGroup.Color:=iff(not Value,clWindow,clBtnFace);
    cmbComingInvalidGroup.ItemIndex:=Iff(not Value,cmbComingInvalidGroup.ItemIndex,-1);
    rbFirstUvo.Enabled:=not Value;
    lbDeterminationDate.Enabled:=not Value;
    dtpDeterminationDate.Enabled:=not Value;
    dtpDeterminationDate.Color:=iff(not Value,clWindow,clBtnFace);
    lbPhysician.Enabled:=not Value;
    cmbPhysician.Enabled:=not Value;
    cmbPhysician.Color:=iff(not Value,clWindow,clBtnFace);
    cmbPhysician.ItemIndex:=Iff(not Value,cmbPhysician.ItemIndex,-1);
    lbViewPlace.Enabled:=not Value;
    cmbViewPlace.Enabled:=not Value;
    cmbViewPlace.Color:=iff(not Value,clWindow,clBtnFace);
    cmbViewPlace.ItemIndex:=Iff(not Value,cmbViewPlace.ItemIndex,-1);
    lbInvalidCategory.Enabled:=not Value;
    cmbInvalidCategory.Enabled:=not Value;
    cmbInvalidCategory.Color:=iff(not Value,clWindow,clBtnFace);
    cmbInvalidCategory.ItemIndex:=Iff(not Value,cmbInvalidCategory.ItemIndex,-1);
    FAutotransport:=Value;
  end;
end;

procedure TfmEditRBVisit.rbComingInvalidGroupClick(Sender: TObject);
begin
  ChangeFlag:=true;
  if rbComingInvalidGroup.Checked then begin
    cmbComingInvalidGroup.Enabled:=true;
    cmbComingInvalidGroup.Color:=clWindow;
  end else begin
    cmbComingInvalidGroup.ItemIndex:=-1;
    cmbComingInvalidGroup.Enabled:=false;
    cmbComingInvalidGroup.Color:=clBtnFace;
  end;
end;

end.
