unit UEditRBNomenclatureGroup;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBNomenclatureGroup = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbParent: TLabel;
    edParent: TEdit;
    bibParent: TBitBtn;
    lbNote: TLabel;
    meNote: TMemo;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibParentClick(Sender: TObject);
    procedure edParentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldnomenclaturegroup_id: Integer;
    ParentNomenclatureGroupId: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBNomenclatureGroup: TfmEditRBNomenclatureGroup;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBNomenclatureGroup;

{$R *.DFM}

procedure TfmEditRBNomenclatureGroup.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureGroup.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbNomenclatureGroup,1));
    if ParentNomenclatureGroupId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentNomenclatureGroupId);
    sqls:='Insert into '+tbNomenclatureGroup+
          ' (nomenclaturegroup_id,name,parent_id,note) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+parent_id+
          ','+QuotedStr(Trim(meNote.Lines.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldnomenclaturegroup_id:=strtoint(id);

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

procedure TfmEditRBNomenclatureGroup.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureGroup.UpdateRBooks: Boolean;
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

    id:=inttostr(oldnomenclaturegroup_id);
    if ParentNomenclatureGroupId=0 then
      parent_id:='null'
    else
      parent_id:=inttostr(ParentNomenclatureGroupId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbNomenclatureGroup+
          ' set name='+QuotedStr(Trim(edName.Text))+
          ', parent_id='+parent_id+
          ', note='+QuotedStr(Trim(meNote.Lines.Text))+
          ' where nomenclaturegroup_id='+id;
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

procedure TfmEditRBNomenclatureGroup.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureGroup.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBNomenclatureGroup.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBNomenclatureGroup.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);
end;

procedure TfmEditRBNomenclatureGroup.bibParentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='nomenclaturegroup_id';
  TPRBI.Locate.KeyValues:=ParentNomenclatureGroupId;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkNomenclatureGroup,@TPRBI) then begin
   ChangeFlag:=true;
   ParentNomenclatureGroupId:=GetFirstValueFromParamRBookInterface(@TPRBI,'nomenclaturegroup_id');
   edParent.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBNomenclatureGroup.edParentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure ClearParent;
  begin
    if Length(edParent.Text)=Length(edParent.SelText) then begin
      edParent.Text:='';
      ParentNomenclatureGroupId:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearParent;
  end;
end;

end.
