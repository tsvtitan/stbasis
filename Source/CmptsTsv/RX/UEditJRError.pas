unit UEditJRError;

interface

{ $I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls;

type
  TfmEditJRError = class(TfmEditRB)
    lbClassError: TLabel;
    edClassError: TEdit;
    lbUsername: TLabel;
    edUsername: TEdit;
    bibUserName: TBitBtn;
    grbDate: TGroupBox;
    lbDateFrom: TLabel;
    dtpDateFrom: TDateTimePicker;
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    grbHint: TGroupBox;
    meHint: TMemo;
    lbCompName: TLabel;
    edCompName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bibUserNameClick(Sender: TObject);
  private
  protected
  public
    Username: String;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditJRError: TfmEditJRError;

implementation

uses USysTsvCode, USysTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditJRError.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditJRError.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDBSec);
  IBDBSec.AddTransaction(IBTran);
  curDate:=_GetDateTimeFromServer;
  dtpDateFrom.Date:=curDate;
  dtpDateFrom.Checked:=false;
  dtpDateTo.Date:=curDate;
  dtpDateTo.Checked:=false;
end;

procedure TfmEditJRError.bibUserNameClick(Sender: TObject);
var
  P: PUserParams;
begin
 try
  getMem(P,sizeof(TUserParams));
  try
   ZeroMemory(P,sizeof(TUserParams));
   StrCopy(P.user_name,Pchar(Username));
   if ViewEntry_(tte_rbksUsers,p,true) then begin
     ChangeFlag:=true;
     edUsername.Text:=P.name;
     UserName:=P.user_name;
   end;
  finally
    FreeMem(P,sizeof(TUserParams));
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

end.
