unit UEditRBBustripstous;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBBustripstous = class(TfmEditRB)
    lbPlant: TLabel;
    edPlant: TEdit;
    bibPlant: TBitBtn;
    lbSeat: TLabel;
    edSeat: TEdit;
    bibSeat: TBitBtn;
    lbDateStart: TLabel;
    lbDateFinish: TLabel;
    dtpDateStart: TDateTimePicker;
    dtpDateFinish: TDateTimePicker;
    lbFName: TLabel;
    lbName: TLabel;
    lbSName: TLabel;
    edFname: TEdit;
    edName: TEdit;
    edSname: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bibPlantClick(Sender: TObject);
    procedure bibSeatClick(Sender: TObject);
    procedure edPlantChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldbustripstous_id: Integer;
    plant_id: Variant;
    seat_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBBustripstous: TfmEditRBBustripstous;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBBustripstous.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBBustripstous.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbBustripstous,1));
    sqls:='Insert into '+tbBustripstous+
          ' (bustripstous_id,plant_id,seat_id,fname,name,sname,datestart,datefinish) values '+
          ' ('+id+
          ','+inttostr(plant_id)+
          ','+inttostr(seat_id)+
          ','+QuotedStr(Trim(edFname.Text))+
          ','+QuotedStr(Trim(edname.Text))+
          ','+QuotedStr(Trim(edSname.Text))+
          ','+QuotedStr(DateTimeToStr(dtpDateStart.Date))+
          ','+QuotedStr(DateTimeToStr(dtpDateFinish.Date))+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldbustripstous_id:=strtoint(id);

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

procedure TfmEditRBBustripstous.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBBustripstous.UpdateRBooks: Boolean;
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

    id:=inttostr(oldbustripstous_id);//fmRBBustripstous.MainQr.FieldByName('bustripstous_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbBustripstous+
          ' set plant_id='+inttostr(plant_id)+
          ', seat_id='+inttostr(seat_id)+
          ', fname='+QuotedStr(Trim(edFname.Text))+
          ', name='+QuotedStr(Trim(edname.Text))+
          ', sname='+QuotedStr(Trim(edSname.Text))+
          ', datestart='+QuotedStr(DateTimeToStr(dtpDateStart.Date))+
          ', datefinish='+QuotedStr(DateTimeToStr(dtpDateFinish.Date))+
          ' where bustripstous_id='+id;
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

procedure TfmEditRBBustripstous.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBBustripstous.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edPlant.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPlant.Caption]));
    bibPlant.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSeat.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSeat.Caption]));
    bibSeat.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFname.Caption]));
    edFname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbname.Caption]));
    edname.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSname.Caption]));
    edSname.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBBustripstous.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edPlant.MaxLength:=DomainNameLength;
  edSeat.MaxLength:=DomainNameLength;
  edFname.MaxLength:=DomainNameLength;
  edName.MaxLength:=DomainSmallNameLength;
  edSname.MaxLength:=DomainSmallNameLength;
  
  dtpDateStart.Date:=_GetDateTimeFromServer;
  dtpDateFinish.Date:=dtpDateStart.Date;
end;

procedure TfmEditRBBustripstous.bibPlantClick(Sender: TObject);
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
   edPlant.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'smallname');
  end;
end;

procedure TfmEditRBBustripstous.bibSeatClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='seat_id';
  TPRBI.Locate.KeyValues:=seat_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSeat,@TPRBI) then begin
   ChangeFlag:=true;
   seat_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'seat_id');
   edSeat.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBBustripstous.edPlantChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
