unit UEditRBSickGroup;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBSickGroup = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbParent: TLabel;
    edParent: TEdit;
    bibParent: TBitBtn;
    lbNote: TLabel;
    meNote: TMemo;
    lbSort: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibParentClick(Sender: TObject);
    procedure edParentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldsickgroup_id: Integer;
    ParentSickGroupId: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSickGroup: TfmEditRBSickGroup;

implementation

uses USickTsvCode, USickTsvData, UMainUnited, URBSickGroup;

{$R *.DFM}

procedure TfmEditRBSickGroup.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBSickGroup.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbSickGroup,1));
    if ParentSickGroupId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentSickGroupId);
    sqls:='Insert into '+tbSickGroup+
          ' (sickgroup_id,name,parent_id,sortnumber,note) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+parent_id+
          ','+inttostr(udSort.Position)+
          ','+QuotedStr(Trim(meNote.Lines.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldsickgroup_id:=strtoint(id);

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

procedure TfmEditRBSickGroup.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSickGroup.UpdateRBooks: Boolean;
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

    id:=inttostr(oldsickgroup_id);
    if ParentSickGroupId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentSickGroupId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSickGroup+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ', parent_id='+parent_id+
          ', sortnumber='+inttostr(udSort.Position)+
          ', note='+QuotedStr(Trim(meNote.Lines.Text))+
          ' where sickgroup_id='+id;
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

procedure TfmEditRBSickGroup.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBSickGroup.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBSickGroup.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBSickGroup.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edParent.MaxLength:=DomainNameLength;
  meNote.MaxLength:=DomainNoteLength;

end;

procedure TfmEditRBSickGroup.bibParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sickgroup_id';
  TPRBI.Locate.KeyValues:=ParentSickGroupId;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSickGroup,@TPRBI) then begin
   ChangeFlag:=true;
   ParentSickGroupId:=GetFirstValueFromParamRBookInterface(@TPRBI,'sickgroup_id');
   edParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBSickGroup.edParentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edParent.Text)=Length(edParent.SelText) then begin
      edParent.Text:='';
      ParentSickGroupId:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

procedure TfmEditRBSickGroup.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

end.
