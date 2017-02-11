unit UEditRBPms_Planning;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ExtDlgs, IBTable, tsvPicture, ComCtrls;

type
  TfmEditRBPms_Planning = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    bibImageLoad: TButton;
    bibImageSave: TButton;
    lbImage: TLabel;
    OD: TOpenPictureDialog;
    SD: TSavePictureDialog;
    pnImage: TPanel;
    imImage: TImage;
    bibClearImage: TButton;
    lbSortNumber: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibImageLoadClick(Sender: TObject);
    procedure bibImageSaveClick(Sender: TObject);
    procedure bibClearImageClick(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Planning_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Planning: TfmEditRBPms_Planning;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Planning;

{$R *.DFM}

procedure TfmEditRBPms_Planning.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Planning.AddToRBooks: Boolean;
var
  tb: TIBTable;
  sqls: string;
  id: string;
  ms: TMemoryStream;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  tb:=TIBTable.Create(nil);
  ms:=TMemoryStream.Create;
  try

    tb.Database:=IBDB;
    tb.Transaction:=ibtran;
    tb.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbPms_Planning,1));
    tb.TableName:=AnsiUpperCase(tbPms_Planning);
    tb.Filter:=' Pms_Planning_id='+id+' ';
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Append;
    tb.FieldByName('Pms_Planning_id').AsInteger:=strtoint(id);
    tb.FieldByName('name').AsString:=Trim(edName.Text);
    tb.FieldByName('note').AsString:=Trim(edNote.Text);
    tb.FieldByName('sortnumber').AsInteger:=udSort.Position;
    TtsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;

    oldPms_Planning_id:=strtoint(id);

    TfmRBPms_Planning(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Planning(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Planning(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Planning_id').AsInteger:=oldPms_Planning_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
      ms.Position:=0;
      TBlobField(FieldByName('image')).LoadFromStream(ms);
      Post;
    end;

    Result:=true;
  finally
    ms.Free;
    tb.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBPms_Planning.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Planning.UpdateRBooks: Boolean;
var
  tb: TIBTable;
  sqls: string;
  id: string;
  ms: TMemoryStream;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  tb:=TIBTable.Create(nil);
  ms:=TMemoryStream.Create;
  try

    id:=inttostr(oldPms_Planning_id);
    tb.Database:=IBDB;
    tb.Transaction:=ibtran;
    tb.Transaction.Active:=true;
    tb.TableName:=AnsiUpperCase(tbPms_Planning);
    tb.Filter:=' Pms_Planning_id='+id+' ';
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Edit;
    tb.FieldByName('Pms_Planning_id').AsInteger:=strtoint(id);
    tb.FieldByName('name').AsString:=Trim(edName.Text);
    tb.FieldByName('note').AsString:=Trim(edNote.Text);
    tb.FieldByName('sortnumber').AsInteger:=udSort.Position;
    TtsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;


    TfmRBPms_Planning(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Planning(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Planning(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Planning_id').AsInteger:=oldPms_Planning_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
      ms.Position:=0;
      TBlobField(FieldByName('image')).LoadFromStream(ms);
      Post;
    end;

    Result:=true;
  finally
    ms.Free;
    tb.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBPms_Planning.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Planning.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNote.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    edNote.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Planning.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Planning.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainShortNameLength;
  edNote.MaxLength:=DomainNoteLength;
  edSort.MaxLength:=3;
end;

procedure TfmEditRBPms_Planning.bibImageLoadClick(Sender: TObject);
begin
  if not Od.Execute then exit;
  imImage.Picture.LoadFromFile(od.FileName);
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Planning.bibImageSaveClick(Sender: TObject);
begin
  if not Sd.Execute then exit;
  imImage.Picture.SaveToFile(sd.FileName);
end;

procedure TfmEditRBPms_Planning.bibClearImageClick(Sender: TObject);
begin
  imImage.Picture.Assign(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Planning.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

end.
