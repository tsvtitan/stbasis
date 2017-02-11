unit UEditRBBasisTypeDoc;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB;

type
  TfmEditRBBasisTypeDoc = class(TfmEditRB)
    lbFor: TLabel;
    edFor: TEdit;
    lbWhat: TLabel;
    edWhat: TEdit;
    bibFor: TBitBtn;
    bibWhat: TBitBtn;
    procedure edForChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibForClick(Sender: TObject);
    procedure bibWhatClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldfortypedoc_id: Integer;
    oldwhattypedoc_id: Integer;
    fortypedoc_id: Integer;
    whattypedoc_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBBasisTypeDoc: TfmEditRBBasisTypeDoc;

implementation

uses UDocTurnTsvCode, UDocTurnTsvData, UMainUnited, URBBasisTypeDoc;

{$R *.DFM}

procedure TfmEditRBBasisTypeDoc.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBBasisTypeDoc.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbBasisTypeDoc+
          ' (fortypedoc_id,whattypedoc_id) values '+
          ' ('+inttostr(fortypedoc_id)+','+inttostr(whattypedoc_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBBasisTypeDoc(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBBasisTypeDoc(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBBasisTypeDoc(fmParent).MainQr do begin
      Insert;
      FieldByName('fortypedoc_id').AsInteger:=fortypedoc_id;
      FieldByName('whattypedoc_id').AsInteger:=whattypedoc_id;
      FieldByName('fortypedocname').AsString:=Trim(edFor.Text);
      FieldByName('whattypedocname').AsString:=Trim(edWhat.Text);
      Post;
    end;
    
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

procedure TfmEditRBBasisTypeDoc.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBBasisTypeDoc.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id1,id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id1:=inttostr(oldfortypedoc_id);
    id2:=inttostr(oldwhattypedoc_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbBasisTypeDoc+
          ' set fortypedoc_id='+inttostr(fortypedoc_id)+
          ', whattypedoc_id='+inttostr(whattypedoc_id)+
          ' where fortypedoc_id='+id1+' and whattypedoc_id='+id2;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBBasisTypeDoc(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBBasisTypeDoc(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBBasisTypeDoc(fmParent).MainQr do begin
      Edit;
      FieldByName('fortypedoc_id').AsInteger:=fortypedoc_id;
      FieldByName('whattypedoc_id').AsInteger:=whattypedoc_id;
      FieldByName('fortypedocname').AsString:=Trim(edFor.Text);
      FieldByName('whattypedocname').AsString:=Trim(edWhat.Text);
      Post;
    end;
    
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

procedure TfmEditRBBasisTypeDoc.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBBasisTypeDoc.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edFor.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFor.Caption]));
    bibFor.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edWhat.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbWhat.Caption]));
    bibWhat.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBBasisTypeDoc.edForChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBBasisTypeDoc.FormCreate(Sender: TObject);
begin
  inherited;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edFor.MaxLength:=DomainNameLength;
  edWhat.MaxLength:=DomainNameLength;

end;

procedure TfmEditRBBasisTypeDoc.bibForClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typedoc_id';
  TPRBI.Locate.KeyValues:=fortypedoc_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
   ChangeFlag:=true;
   fortypedoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typedoc_id');
   edFor.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBBasisTypeDoc.bibWhatClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tvibvModal;
 TPRBI.Locate.KeyFields:='typedoc_id';
 TPRBI.Locate.KeyValues:=whattypedoc_id;
 TPRBI.Locate.Options:=[loCaseInsensitive];
 if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
   ChangeFlag:=true;
   whattypedoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typedoc_id');
   edWhat.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
 end;
end;

end.
