unit UEditRBNumerators;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBNumerators = class(TfmEditRB)
    lbNameNumerator: TLabel;
    edNameNumerator: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    lbSuffix: TLabel;
    edSuffix: TEdit;
    lbPrefix: TLabel;
    edPrefix: TEdit;
    DTPStartDate: TDateTimePicker;
    lbStartDate: TLabel;
    edStartNum: TEdit;
    lbStartNum: TLabel;
    bibStartNum: TButton;
    lbNAmeTypeNumerator: TLabel;
    bNameTypeNumerator: TButton;
    edNameTypeNumerator: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameNumeratorChange(Sender: TObject);
    procedure bNameTypeNumeratorClick(Sender: TObject);
    procedure bibStartNumClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure edNameTypeNumeratorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    numerators_id,oldNumerators_id: Integer;
    TypeNumerator_id,oldTypeNumerator_id: Integer;
    NameGenerator: AnsiString;
    fmParent:TForm;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBNumerators: TfmEditRBNumerators;

implementation

uses USysVAVCode, USysVAVData, UMainUnited, URBTypeNumerator,StVavKit;

{$R *.DFM}

procedure TfmEditRBNumerators.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBNumerators.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbTypeNumerator,1));
    try
      NameGenerator:='GEN_NUMERATOR_'+id+'_ID';
      sqls:='CREATE GENERATOR '+NameGenerator;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.sql.Clear;
    finally
      sqls:='Insert into '+ tbNumerators +
            ' (Numerators_id,NameNumerators,Prefix,Suffix,StartDate,TypeNumerator_id,NameGenerator,About) values '+
            ' ('+id+
            ','+QuotedStr(Trim(edNameNumerator.text))+
            ','+QuotedStr(Trim(edPrefix.text))+
            ','+QuotedStr(Trim(edSuffix.text))+
            ','+QuotedStr(DateToStr(DTPStartDate.Date))+
            ','+IntToStr(TypeNumerator_id)+
            ','+QuotedStr(Trim(NameGenerator))+
            ','+QuotedStr(Trim(meAbout.text))+')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;

    //≈сли запись падает куда и планировали
    if (oldTypeNumerator_id=TypeNumerator_id) then
    begin

      TfmRBTypeNumerator(fmParent).updDetail.InsertSQL.Clear;
      TfmRBTypeNumerator(fmParent).updDetail.InsertSQL.Add(sqls);

      with TfmRBTypeNumerator(fmParent).qrDetail do begin
        Insert;
        FieldByName('Numerators_id').AsInteger:=StrToInt(id);
        FieldByName('NameNumerators').AsString:=Trim(edNameNumerator.text);
        FieldByName('Prefix').AsString:=Trim(edPrefix.text);
        FieldByName('Suffix').AsString:=Trim(edSuffix.text);
        FieldByName('StartDate').AsString:=DateToStr(DTPStartDate.Date);
        FieldByName('TypeNumerator_id').AsInteger:=TypeNumerator_id;
        FieldByName('NAMEGenerator').AsString:=Trim(NameGenerator);
        FieldByName('About').AsString:=Trim(meAbout.text);
        FieldByName('NameTypeNumerator').AsString:=Trim(edNameTypeNumerator.text);
        Post;
      end;
    end;
     oldNumerators_id:=strtoint(id);
     qr.Transaction.Commit;
    end;
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

procedure TfmEditRBNumerators.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBNumerators.UpdateRBooks: Boolean;
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

    id:=inttostr(Numerators_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbNumerators+
            ' set NameNumerators='+QuotedStr(Trim(edNameNumerator.text))+
            ', Prefix='+QuotedStr(Trim(edPrefix.text))+
            ', Suffix='+QuotedStr(Trim(edSuffix.text))+
            ', StartDate='+QuotedStr(DateToStr(DTPStartDate.Date))+
            ', TypeNumerator_id='+IntToStr(TypeNumerator_id)+
            ', about='+QuotedStr(Trim(meAbout.text))+
            ' where Numerators_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    //≈сли запись падает куда и планировали
    if (oldTypeNumerator_id=TypeNumerator_id) then
    begin

            TfmRBTypeNumerator(fmParent).updDetail.ModifySQL.Clear;
            TfmRBTypeNumerator(fmParent).updDetail.ModifySQL.Add(sqls);

            with TfmRBTypeNumerator(fmParent).qrDetail do begin
              Edit;
              FieldByName('Numerators_id').AsInteger:=StrToInt(id);
              FieldByName('NameNumerators').AsString:=Trim(edNameNumerator.text);
              FieldByName('Prefix').AsString:=Trim(edPrefix.text);
              FieldByName('Suffix').AsString:=Trim(edSuffix.text);
              FieldByName('StartDate').AsString:=DateToStr(DTPStartDate.Date);
              FieldByName('TypeNumerator_id').AsInteger:=TypeNumerator_id;
              FieldByName('About').AsString:=Trim(meAbout.text);;
              Post;
            end;
    end
            else
    begin
      sqls:='Delete from '+tbNumerators+' where numerators_id='+inttostr(oldNumerators_id);
      TfmRBTypeNumerator(fmParent).updDetail.DeleteSQL.Clear;
      TfmRBTypeNumerator(fmParent).updDetail.DeleteSQL.Add(sqls);
      TfmRBTypeNumerator(fmParent).qrDetail.Delete;
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
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBNumerators.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBNumerators.CheckFieldsFill: Boolean;
begin
  Result:=false;
  if trim(edNameNumerator.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameNumerator.Caption]));
    edNameNumerator.SetFocus;
    exit;
  end;
  if trim(edNameTypeNumerator.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameTypeNumerator.Caption]));
    edNameTypeNumerator.SetFocus;
    exit;
  end;
  result:=true;
end;

procedure TfmEditRBNumerators.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameTypeNumerator.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBNumerators.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBNumerators.edNameNumeratorChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBNumerators.bNameTypeNumeratorClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypeNumerator_id';
  TPRBI.Locate.KeyValues:=TypeNumerator_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeNumerator,@TPRBI) then begin
   ChangeFlag:=true;
   TypeNumerator_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeNumerator_id');
   edNameTypeNumerator.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NameTypeNumerator');
  end;
end;

procedure TfmEditRBNumerators.bibStartNumClick(Sender: TObject);
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    try
      NameGenerator:='GEN_NUMERATOR_'+IntToStr(Numerators_id)+'_ID';
      qr.sql.Clear;
    finally
      sqls:='SET GENERATOR '+NameGenerator + ' TO ' +edStartNum.Text;
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.Commit;
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
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

procedure TfmEditRBNumerators.SpeedButton1Click(Sender: TObject);
begin
    try
      edStartNum.Text:=inttostr(GetGenId(IBDB,'NUMERATOR_'+IntToStr(Numerators_id),0));
    except
    end;
end;

procedure TfmEditRBNumerators.edNameTypeNumeratorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edNameTypeNumerator.Text:='';
    ChangeFlag:=true;
    TypeNumerator_id:=0;
  end;

end;

end.



