unit URbkCountryEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls;

type
  TFmRbkCountryEdit = class(TFmRbkEdit)
    EdCode: TEdit;
    LbCode: TLabel;
    LbName: TLabel;
    lbName1: TLabel;
    lbAlfa2: TLabel;
    lbAlfa3: TLabel;
    EdName: TEdit;
    EdName1: TEdit;
    EdAlfa2: TEdit;
    EdAlfa3: TEdit;
    procedure BtPostClick(Sender: TObject);
  private
    { Private declarations }
  public
    EditMode:Boolean;
    Locate_id: integer;
    function CheckFieldvaluesExist:Boolean;
    function GetInsertString: string;
    function GetUpdateString: string;
  end;

var
  FmRbkCountryEdit: TFmRbkCountryEdit;

implementation
Uses UMainUnited, Uconst;

{$R *.DFM}

function TFmRbkCountryEdit.CheckFieldvaluesExist:Boolean;
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
end;

function TFmRbkCountryEdit.GetInsertString: string;
var
  S:String;
begin
  Locate_id:=GetGenId(IBDB, TbName,1);
  S:='Insert into '+TbName+' ('+TbName+'_id, Code, Name, Name1,'+
    ' alfa2, alfa3) values ('+
    IntToStr(Locate_id)+', '+CoolStr(EdCode.text)+
    ', '+CoolStr(EdName.Text)+', '+CoolStr(EdName1.Text)+
    ', '+CoolStr(EdAlfa2.text)+', '+CoolStr(EdAlfa3.text)+')';
  Result:=S;
end;

function TFmRbkCountryEdit.GetUpdateString:String;
var
  S:String;
begin
  S:='Update '+TbName+' Set Code='+CoolStr(edCode.Text)+', Name='+
     CoolStr(edName.Text)+', Name1='+CoolStr(EdName1.Text)+
     ', alfa2 = '+CoolStr(EdAlfa2.Text)+
     ', alfa3 = '+CoolStr(EdAlfa3.Text)+
     ' where '+TbName+'_id ='+IntToStr(Locate_id);
  Result:=S;
end;


procedure TFmRbkCountryEdit.BtPostClick(Sender: TObject);
begin
  if not CheckFieldvaluesExist then exit;
  if not EditMode then IBQ.SQL.Text:=GetInsertString else
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

end.
