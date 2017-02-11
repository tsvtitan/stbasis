unit UEditRBAPOperation;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBAPOperation = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbParent: TLabel;
    edParent: TEdit;
    bibParent: TButton;
    lbFullName: TLabel;
    lbPriority: TLabel;
    edPriority: TEdit;
    udPriority: TUpDown;
    edFullName: TEdit;
    lbFieldViewName: TLabel;
    edFieldViewName: TEdit;
    btFieldViewName: TButton;
    LabelLink: TLabel;
    edLink: TEdit;
    meFormat: TMemo;
    lbFormat: TLabel;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibParentClick(Sender: TObject);
    procedure edParentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure udPriorityChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btFieldViewNameClick(Sender: TObject);
    procedure edFieldViewNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldOperation_id: Integer;
    ap_field_view_id: Integer;
    ParentOperationId: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBAPOperation: TfmEditRBAPOperation;

implementation

uses UMainUnited, URBAPOperation, UAnnPremData;

{$R *.DFM}

procedure TfmEditRBAPOperation.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAPOperation.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
  parent_id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbAPOperation,1));
    if ParentOperationId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentOperationId);
    sqls:='Insert into '+tbAPOperation+
          ' (AP_OPERATION_ID,NAME,PARENT_ID,PRIORITY,FULLNAME,AP_FIELD_VIEW_ID,LINK,FORMAT) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+parent_id+
          ','+inttostr(udPriority.Position)+
          ','+QuotedStr(Trim(edFullName.Text))+
          ','+iff(Trim(edFieldViewName.Text)<>'',InttoStr(ap_field_view_id),'NULL')+
          ','+iff(Trim(edLink.Text)<>'',QuotedStr(Trim(edLink.Text)),'NULL')+
          ','+iff(Trim(meFormat.Lines.Text)<>'',QuotedStr(Trim(meFormat.Lines.Text)),'NULL')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldOperation_id:=strtoint(id);

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBAPOperation.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAPOperation.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id,parent_id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldOperation_id);
    if ParentOperationId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentOperationId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbAPOperation+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ', parent_id='+parent_id+
          ', priority='+inttostr(udPriority.Position)+
          ', fullname='+QuotedStr(Trim(edFullName.Text))+
          ', ap_field_view_id='+iff(Trim(edFieldViewName.Text)<>'',InttoStr(ap_field_view_id),'NULL')+
          ', link='+iff(Trim(edLink.Text)<>'',QuotedStr(Trim(edLink.Text)),'NULL')+
          ', format='+iff(Trim(meFormat.Lines.Text)<>'',QuotedStr(Trim(meFormat.Lines.Text)),'NULL')+
          ' where ap_operation_id='+id;
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBAPOperation.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBAPOperation.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFullName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFullName.Caption]));
    edFullName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAPOperation.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAPOperation.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edParent.MaxLength:=DomainNameLength;
  edFullName.MaxLength:=DomainNoteLength;
  edFieldViewName.MaxLength:=DomainNameLength;
  edLink.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBAPOperation.bibParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='AP_OPERATION_ID';
  TPRBI.Locate.KeyValues:=ParentOperationId;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAPOperation,@TPRBI) then begin
   ChangeFlag:=true;
   ParentOperationId:=GetFirstValueFromParamRBookInterface(@TPRBI,'AP_OPERATION_ID');
   edParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
  end;
end;

procedure TfmEditRBAPOperation.edParentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edParent.Text)=Length(edParent.SelText) then begin
      edParent.Text:='';
      ParentOperationId:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBAPOperation.udPriorityChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAPOperation.btFieldViewNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='AP_FIELD_VIEW_ID';
  TPRBI.Locate.KeyValues:=ap_field_view_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAPFieldView,@TPRBI) then begin
   ChangeFlag:=true;
   ap_field_view_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'AP_FIELD_VIEW_ID');
   edFieldViewName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAME');
  end;
end;

procedure TfmEditRBAPOperation.edFieldViewNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edFieldViewName.Text)=Length(edFieldViewName.SelText) then begin
      edFieldViewName.Text:='';
      ap_field_view_id:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

end.
