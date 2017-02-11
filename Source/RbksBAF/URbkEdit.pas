unit URbkEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DbGrids, Db, IbQuery, IbDatabase, IBCustomDataSet,
  Buttons;

type
  TFmRbkEdit = class(TForm)
    PnBtn: TPanel;
    Panel1: TPanel;
    BtPost: TBitBtn;
    BtCancel: TButton;
    PnEdit: TPanel;
    IBQ: TIBQuery;
    Trans: TIBTransaction;
    PnFilter: TPanel;
    CBInsideFilter: TCheckBox;
    btClear: TBitBtn;
    procedure BtPostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    TbName: String;
    ListControls:TList;
    FilterSQL: String;
    Locate_id: integer;
    ChangeFlag: Boolean;
    procedure ClearList;
    procedure EditGen(Cols: TDBGridColumns; tableName, id: string;
      fillEdit: Boolean);
    procedure OnKeyPressInt(Sender: TObject; var Key: Char);
    procedure OnKeyPressFloat(Sender: TObject; var Key: Char);
    procedure IsEditChange(Sender: TObject);
    function ModifyTable:Boolean;
    function GetInsertSQlString: string;
    function GetUpdateSQlString: string;
    function CoolStr(FufloStr:String):String;
    procedure ApplyFilter(Sender:TObject);
    { Public declarations }
  end;

var
  FmRbkEdit: TFmRbkEdit;
  Edit: Boolean;
  Change: Boolean;
  String_Id: String;

implementation
uses UMainUnited, Uconst, URbk, UFuncProc;
{$R *.DFM}

procedure TFmRbkEdit.EditGen(Cols: TDBGridColumns; tableName, id: string;
  fillEdit: Boolean);
var
  i: Integer;
  lb: TLabel;
  ed: TEdit;
  Y, maxY: Integer;
  X: Integer;
  cl: TColumn;
  fl: TField;
begin
  Y:=15;
  X:=20;
  Edit:=fillEdit;
  TbName:=tableName;
  String_Id:=Id;
  for i:=0 to Cols.Count-1 do begin
     cl:=Cols[i];
     lb:=TLabel.Create(nil);
     ListControls.Add(lb);
     lb.Left:=X;
     lb.Top:=Y;
     lb.Caption:=cl.Title.Caption;
     lb.AutoSize:=true;
     lb.Parent:=PnEdit;
     fl:=cl.field;
     ed:=Tedit.Create(nil);
     ed.OnChange:=IsEditChange;
     ListControls.Add(ed);
     ed.Left:=X;
     maxY:=(lb.Top+lb.Height)+3;
     ed.Top:=maxY;
     Ed.Name:=Cols[i].Field.FieldName;
     if fillEdit then ed.Text:=Cols[i].Field.AsString else ed.Text:='';
     case fl.DataType of
      ftString: begin
       ed.Width:=250;
       ed.MaxLength:=100;
       ed.Tag:=1;
      end;

      ftInteger: begin
       ed.Width:=200;
       ed.MaxLength:=6;
       ed.OnKeyPress:=OnKeyPressInt;
       ed.Tag:=2;
      end;

      ftFloat: begin
       ed.Width:=200;
       ed.MaxLength:=16;
       ed.OnKeyPress:=OnKeyPressFloat;
       ed.Tag:=3;
      end;
     end;
     ed.Parent:=PnEdit;
     Y:=(ed.Top+ed.Height)+8;
     Height:=maxY+100;
     Width:=300;
  end;
end;

procedure TFmRbkEdit.OnKeyPressInt(Sender: TObject; var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TFmRbkEdit.OnKeyPressFloat(Sender: TObject; var Key: Char);
var
  APos: Integer;
begin
  if (not (Char(Key) in ['0'..'9']))and (char(Key)<>DecimalSeparator)and
  (Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if char(Key)=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;


procedure TFmRbkEdit.BtPostClick(Sender: TObject);
var
  I: Integer;
  ed: Tedit;
  ct: TControl;
  lb: TLabel;
begin
  if not Change then ModalResult:=mrOk;
  for i:=0 to ListControls.Count-1 do begin
    ct:=ListControls.Items[i];
    if ct is TEdit then begin
     ed:=TEdit(ct);
     if Trim(ed.Text)='' then begin
       lb:=TLabel(ListControls.Items[i-1]);
       ShowError(Handle,Format(ConstFieldNoEmpty,[lb.Caption]));
       ed.SetFocus;
       exit;
     end;
    end;
  end;
  if ModifyTable then  ModalResult:=mrOk;
end;

procedure TFmRbkEdit.FormCreate(Sender: TObject);
begin
  ListControls:=TList.Create;
end;

procedure TFmRbkEdit.ClearList;
var
  i: Integer;
  ct: TControl;
begin
  for i:=0 to ListControls.Count-1 do begin
    ct:=ListControls.Items[i];
    ct.Free;
  end;
  ListControls.Clear;
end;



procedure TFmRbkEdit.FormDestroy(Sender: TObject);
begin
  ClearList;
  ListControls.Free;
end;

function TFmRbkEdit.ModifyTable:Boolean;
var
  IbQ: TIbQuery;
  IBT: TIbTransaction;
begin
  IbQ:=TIbQuery.Create(Nil);
  IbQ.Database:=IBDB;
  IBT:=TIbTransaction.Create(nil);
  IBT.DefaultDatabase:=IbDB;
  IbQ.Transaction:=IbT;
  if not edit then IbQ.SQL.Add(GetInsertSQlString) else
    IbQ.SQL.Add(GetUpdateSQlString);
  try
    IbQ.Transaction.Active:=true;
    IbQ.ExecSQL;
    IbQ.Transaction.CommitRetaining;
    Result:=true;
  finally
    IbT.free;
    IbQ.free;
  end;
end;

function TFmRbkEdit.GetInsertSQlString: string;
var
  I: Integer;
  ed: Tedit;
  ct: TControl;
  S: String;
  ValS, EndStr: string;
begin
  Locate_id:=GetGenId(IBDB, TbName,1);
  Result:='';
  S:='Insert into '+TbName+' ('+TbName+'_id, ';
  ValS:='values ('+IntToStr(Locate_id)+', ';
  for i:=0 to ListControls.Count-1 do
  begin
    if i<ListControls.Count-1 then EndStr:=', ' else EndStr:=')';
    ct:=ListControls.Items[i];
    if ct is TEdit then
    begin
      ed:=TEdit(ct);
      S:=S+ed.Name+EndStr;
      Case Ed.Tag of
        1:ValS:=ValS+QuotedStr(Trim(Ed.Text))+EndStr; //string
        2,3:ValS:=ValS+Trim(Ed.Text)+EndStr; //string
      end;
    end;
  end;
  S:=S+ValS;
  Result:=S;
end;

function TFmRbkEdit.GetUpdateSQlString: string;
var
  I: Integer;
  ed: Tedit;
  ct: TControl;
  S,Val, EndStr: String;
begin
  Result:='';
  S:='Update '+TbName+' set ';
  for i:=0 to ListControls.Count-1 do
  begin
    if i< ListControls.Count-1 then EndStr:=', ' else EndStr:=' ';
    ct:=ListControls.Items[i];
    if ct is TEdit then
    begin
      ed:=TEdit(ct);
      if trim(ed.text)<>'' then
      begin
        Case Ed.Tag of
          1: val:=QuotedStr(Trim(Ed.Text)); //string
          2,3: val:=Trim(Ed.Text);
        end;
        S:=S+ed.Name+' = '+Val+EndStr;
      end;
    end;
  end;
  S:=S+'where '+TbName+'_id = '+String_Id;
  Result:=S;
end;

procedure TFmRbkEdit.BtCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFmRbkEdit.ApplyFilter(Sender:TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFmRbkEdit.FormActivate(Sender: TObject);
var
  I: Integer;
  ed: Tedit;
  ct: TControl;
begin
  if PnFilter.Visible then Height:=Height+40;
  if (not PnEdit.Enabled) or (ListControls.Count=0) then
  begin
    BtCancel.SetFocus;
    exit;
  end else
  for i:=0 to ListControls.Count-1 do
  begin
    ct:=ListControls.Items[i];
    if ct is TEdit then
    begin
      Ed:=TEdit(Ct);
      Ed.SetFocus;
      break;
    end;
  end;
end;

procedure TFmRbkEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TFmRbkEdit.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;

procedure TFmRbkEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyDown(Key,Shift);
end;

function TFmRbkEdit.CoolStr(FufloStr:String):String;
var
  tmpstr:String;
begin
  tmpstr:=Trim(FufloStr);
  if tmpstr='' then result:='null' else  Result:=QuotedStr(tmpstr);
end;

procedure TFmRbkEdit.IsEditChange(Sender: TObject);
begin
  Change:=true;
end;

procedure TFmRbkEdit.btClearClick(Sender: TObject);
var
  I: Integer;
  ct: TControl;
begin
  for i:=0 to ListControls.Count-1 do
  begin
    ct:=ListControls.Items[i];
    if ct is TEdit then TEdit(Ct).Clear;
  end;
  CBInsideFilter.Checked:=false;
end;

procedure TFmRbkEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Hint:='';
end;

end.
