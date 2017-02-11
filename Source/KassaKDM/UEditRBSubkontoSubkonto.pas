unit UEditRBSubkontoSubkonto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB;

type
  TfmEditRBSubkontoSubkonto = class(TfmEditRB)
    LSub1: TLabel;
    ESub1: TEdit;
    BSub1: TButton;
    LSub2: TLabel;
    ESub2: TEdit;
    BSub2: TButton;
    LRelField: TLabel;
    cbRelField: TComboBox;
    procedure BSub1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure BSub2Click(Sender: TObject);
    procedure ESub2Change(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    idSub1,idSub2,SubTab2,RelField,LevelTab1: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSubkontoSubkonto: TfmEditRBSubkontoSubkonto;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBSubkontoSubkonto.BSub1Click(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='subkonto_id';
  TPRBI.Locate.KeyValues:=idSub1;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkKindSubkonto,@TPRBI) then begin
   ChangeFlag:=true;
   idSub1:=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_id');
   ESub1.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_name');
   LevelTab1 :=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_level');
   if idSub1<>'0' then begin
     LSub2.Enabled := true;
     ESub2.Enabled := true;
     BSub2.Enabled := true;
     LRelField.Enabled := true;
     cbRelField.Enabled := true;
   end
   else begin
     LSub2.Enabled := false;
     ESub2.Enabled := false;
     BSub2.Enabled := false;
     LRelField.Enabled := false;
     cbRelField.Enabled := false;
   end;
  end;
end;

procedure TfmEditRBSubkontoSubkonto.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBSubkontoSubkonto.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbSubkontoSubkonto+
          ' (SS_SUBKONTO1,SS_SUBKONTO2,SS_RELFIELD) values '+
          '('+idSub1+','+idSub2+','+QuotedStr(RelField)+')';
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
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBSubkontoSubkonto.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSubkontoSubkonto.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id1,id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id1:=idSub1;
    id2:=idSub2;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSubkontoSubkonto+
          ' set SS_SUBKONTO1='+idSub1+','+'SS_SUBKONTO2='+idSub2+','+
                'SS_RELFIELD='+QuotedStr(Trim(cbRelField.Text))+
          ' where SS_SUBKONTO1='+id1+' and '+'SS_SUBKONTO2='+id2;
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
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBSubkontoSubkonto.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBSubkontoSubkonto.CheckFieldsFill: Boolean;
begin
  Result:=true;
  RelField := Trim(cbRelField.Text);
  if (trim(ESub1.Text)='') or (idSub1='0') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LSub1.Caption]));
    ESub1.SetFocus;
    Result:=false;
    exit;
  end;
  if (trim(ESub2.Text)='') or (idSub2='0') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LSub2.Caption]));
    ESub2.SetFocus;
    Result:=false;
    exit;
  end;
  if (RelField='') then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[LRelField.Caption]));
    cbRelField.SetFocus;
    Result:=false;
    exit;
  end
  else begin
    if cbRelField.Items.IndexOf(Trim(cbRelField.Text))=-1 then begin
      ShowMessage('Поле <'+Trim(RelField)+'> в таблице <'+tbKindSubkonto+'> отсутсвует');
      cbRelField.SetFocus;
      Result:=false;
      exit;
    end;
  end;
end;

procedure TfmEditRBSubkontoSubkonto.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBSubkontoSubkonto.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  idSub1:='0';
  idSub2:='0';
  RelField:='';
end;

procedure TfmEditRBSubkontoSubkonto.BSub2Click(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
    FillChar(TPRBI,SizeOf(TPRBI),0);
    TPRBI.Visual.TypeView:=tvibvModal;
    TPRBI.Locate.KeyFields:='subkonto_id';
    TPRBI.Locate.KeyValues:=idSub2;
    TPRBI.Locate.Options:=[loCaseInsensitive];
    TPRBI.Condition.WhereStr := PChar('subkonto_level='+IntToStr(StrToInt(LevelTab1)+1));
    if _ViewInterfaceFromName(NameRbkKindSubkonto,@TPRBI) then begin
     ChangeFlag:=true;
     idSub2:=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_id');
     SubTab2 := GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_tablename');
     ESub2.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'subkonto_name');
    end;

end;

procedure TfmEditRBSubkontoSubkonto.ESub2Change(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
begin
  inherited;
 try
  qr := TIBQuery.Create(nil);
  qr.Database := IBDB;
  qr.Transaction := IBTran;
  try
  if idSub2<>'0' then begin
     sqls := 'select * from '+SubTab2;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.Open;
     cbRelField.Items.Clear;
     cbRelField.Items := qr.FieldList;
  end;
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
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

end.
