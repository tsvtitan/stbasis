unit URbkATEEdit;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, StdCtrls, ExtCtrls, Buttons, IBDatabase, Db, IBCustomDataSet,
  IBQuery, Mask;

type
  TfmRbkATEEdit = class(TFmRbkEdit)
    lbCode: TLabel;
    LbName: TLabel;
    EdCode: TEdit;
    EdName: TEdit;
    LbSmallName: TLabel;
    EdSocr: TEdit;
    EdPostIndex: TMaskEdit;
    LbPostIndex: TLabel;
    EdGNINMB: TMaskEdit;
    LbGNINMB: TLabel;
    procedure BtPostClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    EditMode:Boolean;
    filter:String;
    flag:Boolean;
    function CheckFieldvaluesExist:Boolean;
    function GetInsertString:String;
    function GetUpdateString:String;
    function GetFilterString:String;
    procedure SetFilter(Sender: TObject);
    { Public declarations }
  end;

var
  fmRbkATEEdit: TfmRbkATEEdit;

implementation
uses UMainUnited, UFuncProc, Uconst;

{$R *.DFM}

function TfmRbkATEEdit.CheckFieldvaluesExist:Boolean;
begin
  Result:=true;
  if trim(EdCode.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbCode.Caption]));
   EdCode.SetFocus;
   Result:=false;
   exit;
  end;

  if trim(EdName.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[lbName.Caption]));
   EdName.SetFocus;
   Result:=false;
   exit;
  end;

  if trim(EdGNINMB.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbGNINMB.Caption]));
   EdGNINMB.SetFocus;
   Result:=false;
   exit;
  end;

  if trim(EdPostIndex.Text) = '' then
  begin
   ShowError(Handle,Format(ConstEmptyField,[LbPostIndex.Caption]));
   EdPostIndex.SetFocus;
   Result:=false;
   exit;
  end;
  
end;


function TfmRbkATEEdit.GetInsertString:String;
var
  S:String;
begin
  Locate_id:=GetGenId(IBDB, TbName,1);
  S:='Insert into '+TbName+' ('+TbName+'_id, Code, Name, Socr,'+
    ' GNINMB, postIndex) values ('+
    IntToStr(Locate_id)+', '+CoolStr(EdCode.text)+
    ', '+CoolStr(EdName.Text)+', '+CoolStr(EdSocr.Text)+
    ', '+CoolStr(EdGNINMB.text)+', '+CoolStr(EdPostIndex.text)+')';
  Result:=S;
end;

function TfmRbkATEEdit.GetUpdateString:String;
var
  S:String;
begin
  S:='Update '+TbName+' Set Code='+CoolStr(edCode.Text)+', Name='+
     CoolStr(edName.Text)+', Socr='+CoolStr(EdSocr.Text)+
     ', GNINMB = '+CoolStr(EDGNINMB.Text)+
     ', PostIndex = '+CoolStr(EdPostIndex.Text)+
     ' where '+TbName+'_id ='+IntToStr(Locate_id);
  Result:=S;
end;

procedure TfmRbkATEEdit.BtPostClick(Sender: TObject);
begin
  if not CheckFieldvaluesExist then exit;
  if not EditMode then IBQ.SQL.text:=GetInsertString else
    IBQ.SQL.Text:=GetUpdateString;
  IbQ.Database:=IBDB;
  IbQ.Transaction.AddDatabase(IBDB);
  try
    IbQ.Transaction.Active:=true;
    IbQ.ExecSQL;
    IbQ.Transaction.CommitRetaining;
    ModalResult:=mrOk;
  except
    ShowError(Handle,'Ошибка выполнения запроса');
  end;
end;

procedure TfmRbkATEEdit.FormActivate(Sender: TObject);
begin
  if PnFilter.Visible then Height:=Height+40;
  EdCode.SetFocus;
end;

function TfmRbkATEEdit.GetFilterString;
var
  S, delimtr:String;

begin
  delimtr:=' and ';
  if trim(EdCode.text)<>'' then S:='code like '+QuotedStr('%'+
    trim(EdCode.text)+'%');

  if trim(EdName.text)<>'' then
  begin
    if S<>'' then S:=delimtr+S;
    S:=' Name like '+QuotedStr('%'+
    trim(EdName.text)+'%');
  end;

  if trim(EdGNINMB.text)<>'' then
  begin
    if S<>'' then S:=delimtr+S;
    S:=' GNINMB like '+QuotedStr('%'+trim(EdGNINMB.text)+'%');
  end;

  if trim(EdSocr.text)<>'' then
  begin
    if S<>'' then S:=delimtr+S;
    S:=' Socr like '+QuotedStr('%'+trim(EdSocr.text)+'%');
  end;

  if S<>'' then S:=' where '+S;
  Result:=S;
end;

procedure TfmRbkATEEdit.SetFilter(Sender:TObject);
begin
  filter:=GetFilterString;
  ModalResult:=mrOk;
end;

end.
