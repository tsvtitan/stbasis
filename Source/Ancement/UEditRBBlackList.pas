unit UEditRBBlackList;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBBlackList = class(TfmEditRB)
    lbBlackString: TLabel;
    edBlackString: TEdit;
    chbInLast: TCheckBox;
    lbDateBegin: TLabel;
    dtpDateBegin: TDateTimePicker;
    lbDateEnd: TLabel;
    dtpDateEnd: TDateTimePicker;
    chbInFirst: TCheckBox;
    chbInAll: TCheckBox;
    lbAbout: TLabel;
    meAbout: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edBlackStringChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldblacklist_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBBlackList: TfmEditRBBlackList;

implementation

uses UAncementCode, UAncementData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBBlackList.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBBlackList.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbBlackList,1));
    sqls:='Insert into '+tbBlackList+
          ' (blacklist_id,blackstring,infirst,inlast,inall,'+
          'about,datebegin,dateend) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edBlackString.text))+
          ','+GetStrFromCondition(chbInFirst.checked,'1','0')+
          ','+GetStrFromCondition(chbInLast.checked,'1','0')+
          ','+GetStrFromCondition(chbInAll.checked,'1','0')+
          ','+GetStrFromCondition(Trim(meAbout.Text)<>'',QuotedStr(Trim(meAbout.Text)),'null')+
          ','+GetStrFromCondition(dtpDateBegin.Checked,QuotedStr(DateToStr(dtpDateBegin.Date)),'null')+
          ','+GetStrFromCondition(dtpDateEnd.Checked,QuotedStr(DateToStr(dtpDateEnd.Date)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldblacklist_id:=strtoint(id);

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

procedure TfmEditRBBlackList.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBBlackList.UpdateRBooks: Boolean;
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

    id:=inttostr(oldblacklist_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbBlackList+
          ' set blackstring='+QuotedStr(Trim(edBlackString.text))+
          ', infirst='+GetStrFromCondition(chbInFirst.checked,'1','0')+
          ', inlast='+GetStrFromCondition(chbInLast.checked,'1','0')+
          ', inall='+GetStrFromCondition(chbInAll.checked,'1','0')+
          ', about='+GetStrFromCondition(Trim(meAbout.Text)<>'',QuotedStr(Trim(meAbout.Text)),'null')+
          ', datebegin='+GetStrFromCondition(dtpDateBegin.Checked,QuotedStr(DateToStr(dtpDateBegin.Date)),'null')+
          ', dateend='+GetStrFromCondition(dtpDateEnd.Checked,QuotedStr(DateToStr(dtpDateEnd.Date)),'null')+
          ' where blacklist_id='+id;

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

procedure TfmEditRBBlackList.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBBlackList.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edBlackString.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbBlackString.Caption]));
    edBlackString.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBBlackList.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edBlackString.MaxLength:=DomainSmallNameLength;
  meAbout.MaxLength:=DomainNoteLength;
  dtpDateBegin.Date:=_GetDateTimeFromServer;
  dtpDateBegin.Checked:=false;
  dtpDateEnd.Date:=dtpDateBegin.Date;
  dtpDateEnd.Checked:=false;
end;

procedure TfmEditRBBlackList.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBBlackList.edBlackStringChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
