unit UEditRBMagazinePostings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, Mask, ComCtrls, UFrameSubkonto;

type
  TfmEditRBMagazinePostings = class(TfmEditRB)
    PView: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    DTPDate: TDateTimePicker;
    ETime: TEdit;
    GBDebit: TGroupBox;
    EDebit: TEdit;
    GBCredit: TGroupBox;
    ECredit: TEdit;
    PDoc: TPanel;
    Label1: TLabel;
    EDoc: TEdit;
    POper: TPanel;
    EOper: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    EPosting: TEdit;
    LCurrency: TLabel;
    ECurrency: TEdit;
    LKolvo: TLabel;
    EKolvo: TEdit;
    ESumma: TEdit;
    Label8: TLabel;
    PFilter: TPanel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    DTPBeg: TDateTimePicker;
    CBDateFilter: TCheckBox;
    DTPFin: TDateTimePicker;
    CBNumFilter: TCheckBox;
    ENumBeg: TEdit;
    ENumFin: TEdit;
    BKassaFilter: TButton;
    MEDebitFilter: TMaskEdit;
    MECreditFilter: TMaskEdit;
    BKorAcFilter: TButton;
    ENum: TEdit;
    Label3: TLabel;
    ENumPosting: TEdit;
    Label4: TLabel;
    cbInStringCopy: TCheckBox;
    FrameSubDT: TFrameSubkonto;
    FrameSubKT: TFrameSubkonto;
    procedure CBNumFilterClick(Sender: TObject);
    procedure CBDateFilterClick(Sender: TObject);
    procedure BKassaFilterClick(Sender: TObject);
    procedure BKorAcFilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure bibClearClick(Sender: TObject);
  private
  public
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBMagazinePostings: TfmEditRBMagazinePostings;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBMagazinePostings.CBNumFilterClick(Sender: TObject);
begin
  inherited;
  Label13.Enabled := CBNumFilter.Checked;
  ENumBeg.Enabled := CBNumFilter.Checked;
  Label14.Enabled := CBNumFilter.Checked;
  ENumFin.Enabled := CBNumFilter.Checked;

end;

procedure TfmEditRBMagazinePostings.CBDateFilterClick(Sender: TObject);
begin
  inherited;
  Label9.Enabled := CBDateFilter.Checked;
  DTPBeg.Enabled := CBDateFilter.Checked;
  Label12.Enabled := CBDateFilter.Checked;
  DTPFin.Enabled := CBDateFilter.Checked;
end;

procedure TfmEditRBMagazinePostings.BKassaFilterClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
begin
  try
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       ChangeFlag:=true;
       MEDebitFilter.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditRBMagazinePostings.BKorAcFilterClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  sqls: string;
  qr: TIBQuery;
begin
  try
   if not _isPermission(tbPlanAccounts,SelConst) then
     exit;
   qr := TIBQuery.Create(nil);
   qr.Database := IBDB;
   qr.Transaction := IBTran;
   try
     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tvibvModal;
     if _ViewInterfaceFromName(NameRbkPlanAccounts,@TPRBI) then begin
       MECreditFilter.Text := GetFirstValueFromParamRBookInterface(@TPRBI,'PA_GROUPID');
       EditChange(Sender);
     end;
   finally
     qr.Free;
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

procedure TfmEditRBMagazinePostings.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditRBMagazinePostings.EditChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBMagazinePostings.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBMagazinePostings.bibClearClick(Sender: TObject);
begin
  inherited;
  MEDebitFilter.Text:='';
  MECreditFilter.Text:='';
  CBNumFilter.Checked:=false;
  CBDateFilter.Checked:=false;
  DTPBeg.Date := _GetDateTimeFromServer;
  DTPFin.Date := _GetDateTimeFromServer;
end;

end.
