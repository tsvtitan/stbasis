unit UEditJRSqlOperation;

interface

{ $I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls;

type
  TfmEditJRSqlOperation = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbUsername: TLabel;
    edUsername: TEdit;
    bibUserName: TButton;
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
  fmEditJRSqlOperation: TfmEditJRSqlOperation;

implementation

uses USysTsvCode, USysTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditJRSqlOperation.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfmEditJRSqlOperation.FormCreate(Sender: TObject);
var
  curDate: TDate;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
  curDate:=_GetDateTimeFromServer;
  dtpDateFrom.Date:=curDate;
  dtpDateFrom.Checked:=false;
  dtpDateTo.Date:=curDate;
  dtpDateTo.Checked:=false;
end;

procedure TfmEditJRSqlOperation.bibUserNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='User_name';
  TPRBI.Locate.KeyValues:=Username;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkUsers,@TPRBI) then begin
   ChangeFlag:=true;
   edUsername.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   Username:=GetFirstValueFromParamRBookInterface(@TPRBI,'user_name');
  end;
end;

end.
