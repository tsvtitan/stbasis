unit UEditRBUsersAccessRights;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBUsersAccessRights = class(TfmEditRB)
    edTypeDoc: TEdit;
    bibTypeDoc: TBitBtn;
    lbTypeDoc: TLabel;
    lbTypeNumerator: TLabel;
    edTypeNumerator: TEdit;
    bibTypeNumerator: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameStorePlaceChange(Sender: TObject);
    procedure bibTypeDocClick(Sender: TObject);
    procedure edTypeDocKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibTypeNumeratorClick(Sender: TObject);
    procedure edTypeNumeratorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    TypeDoc_id,TypeNumerator_id: Integer;
    OldTypeDoc_id,OldTypeNumerator_id: Integer;
    fmParent:Tform;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBUsersAccessRights: TfmEditRBUsersAccessRights;

implementation

uses USysVAVCode, USysVAVData, UMainUnited, URBTypeNumerator;

{$R *.DFM}

procedure TfmEditRBUsersAccessRights.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBUsersAccessRights.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbUsersAccessRights+
          ' (TypeDoc_id,TypeNumerator_id) values '+
          '('+IntToStr(TypeDoc_id)+
          ','+IntToStr(TypeNumerator_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    //≈сли запись падает куда и планировали
    if (oldTypeNumerator_id=TypeNumerator_id) then
    begin
      TfmRBTypeNumerator(fmParent).updDetail.InsertSQL.Clear;
      TfmRBTypeNumerator(fmParent).updDetail.InsertSQL.Add(sqls);

      with TfmRBTypeNumerator(fmParent).qrDetail do begin
        Insert;
        FieldByName('TypeDoc_id').AsInteger:=TypeDoc_id;
        FieldByName('TypeNumerator_id').AsInteger:=TypeNumerator_id;
        FieldByName('NameTypeNumerator').AsString:=Trim(edTypeNumerator.text);
        FieldByName('NAme').AsString:=Trim(edTypeDoc.text);
        Post;
      end;
    end;
    qr.Transaction.Commit;
    OldTypeDoc_id:=TypeDoc_id;
    OldTypeNumerator_id:=TypeNumerator_id;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBUsersAccessRights.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBUsersAccessRights.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

//    OldTypeDoc_id:=TypeDoc_id;
//    OldTypeNumerator_id:=TypeNumerator_id;
  //    id:=inttostr(oldStorePlace_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbUsersAccessRights+
          ' set TypeDoc_id='+IntToStr(TypeDoc_id)+
          ', TypeNumerator_id='+IntToStr(TypeNumerator_id)+
          ' where TypeDoc_id='+IntToStr(OldTypeDoc_id) + ' and TypeNumerator_id='+IntToStr(oldTypeNumerator_id) ;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    //≈сли запись падает куда и планировали
    if (oldTypeNumerator_id=TypeNumerator_id) then
    begin
            TfmRBTypeNumerator(fmParent).updDetail.ModifySQL.Clear;
            TfmRBTypeNumerator(fmParent).updDetail.ModifySQL.Add(sqls);

            with TfmRBTypeNumerator(fmParent).qrDetail do begin
              Edit;
              FieldByName('TypeDoc_id').AsInteger:=TypeDoc_id;
              FieldByName('TypeNumerator_id').AsInteger:=TypeNumerator_id;
              FieldByName('NameTypeNumerator').AsString:=Trim(edTypeNumerator.text);
              FieldByName('NAme').AsString:=Trim(edTypeDoc.text);
              Post;
            end;
    end
        else
    begin
      sqls:='Delete from '+tbUsersAccessRights+' where TypeDoc_id='+inttostr(OldTypeDoc_id) +
                'and TypeNumerator_id ='+inttostr(OldTypeNumerator_id) ;
      TfmRBTypeNumerator(fmParent).updDetail.DeleteSQL.Clear;
      TfmRBTypeNumerator(fmParent).updDetail.DeleteSQL.Add(sqls);
      TfmRBTypeNumerator(fmParent).qrDetail.Delete;
    end;
    OldTypeDoc_id:=TypeDoc_id;
    OldTypeNumerator_id:=TypeNumerator_id;
    qr.Transaction.Commit;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBUsersAccessRights.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBUsersAccessRights.CheckFieldsFill: Boolean;
begin
  Result:=false;
  if trim(edTypeDoc.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeDoc.Caption]));
    edTypeDoc.SetFocus;
    exit;
  end;
  if trim(edTypeNumerator.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbTypeNumerator.Caption]));
    edTypeNumerator.SetFocus;
    exit;
  end;
 Result:=true;
end;

procedure TfmEditRBUsersAccessRights.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

//  edNameStorePlace.MaxLength:=DomainSmallNameLength;
//  meAbout.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBUsersAccessRights.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBUsersAccessRights.edNameStorePlaceChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBUsersAccessRights.bibTypeDocClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypeDoc_id';
  TPRBI.Locate.KeyValues:=TypeDoc_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeDoc,@TPRBI) then begin
   ChangeFlag:=true;
   TypeDoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeDoc_id');
   edTypeDoc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TfmEditRBUsersAccessRights.edTypeDocKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edTypeDoc.Text:='';
    ChangeFlag:=true;
    TypeDoc_id:=0;
  end;
end;

procedure TfmEditRBUsersAccessRights.bibTypeNumeratorClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
  n:Ansistring;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='TypeNumerator_id';
  TPRBI.Locate.KeyValues:=TypeNumerator_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeNumerator,@TPRBI) then begin
   ChangeFlag:=true;
   TypeNumerator_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeNumerator_id');
   edTypeNumerator.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'NAMETYPENUMERATOR');
  end;
end;

procedure TfmEditRBUsersAccessRights.edTypeNumeratorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edTypeNumerator.Text:='';
    ChangeFlag:=true;
    TypeNumerator_id:=0;
  end;
end;

end.
