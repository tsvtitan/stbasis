unit UEditRBPms_Image;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ExtDlgs, IBTable, tsvPicture, ComCtrls;

type
  TfmEditRBPms_Image = class(TfmEditRB)
    lbHouseNumber: TLabel;
    edHouseNumber: TEdit;
    bibImageLoad: TButton;
    bibImageSave: TButton;
    lbImage: TLabel;
    OD: TOpenPictureDialog;
    SD: TSavePictureDialog;
    pnImage: TPanel;
    bibClearImage: TButton;
    lbStreet: TLabel;
    edStreet: TEdit;
    btStreet: TButton;
    ScrollBox1: TScrollBox;
    imImage: TImage;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibImageLoadClick(Sender: TObject);
    procedure bibImageSaveClick(Sender: TObject);
    procedure bibClearImageClick(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btStreetClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_image_id: Variant;
    street_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Image: TfmEditRBPms_Image;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Image;

{$R *.DFM}

procedure TfmEditRBPms_Image.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Image.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPms_Image,1));
    tb.TableName:=AnsiUpperCase(tbPms_Image);
    tb.Filter:=' Pms_image_id='+id+' ';
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Append;
    tb.FieldByName('Pms_image_id').AsInteger:=strtoint(id);
    tb.FieldByName('pms_street_id').AsInteger:=street_id;
    tb.FieldByName('housenumber').AsString:=Trim(edHouseNumber.Text);
    TtsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;

    oldPms_image_id:=strtoint(id);

    TfmRBPms_Image(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Image(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Image(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_image_id').AsInteger:=oldPms_image_id;
      FieldByName('pms_street_id').AsInteger:=street_id;
      FieldByName('street_name').AsString:=Trim(edStreet.Text);
      FieldByName('housenumber').AsString:=Trim(edHouseNumber.Text);
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

procedure TfmEditRBPms_Image.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Image.UpdateRBooks: Boolean;
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

    id:=inttostr(oldPms_Image_id);
    tb.Database:=IBDB;
    tb.Transaction:=ibtran;
    tb.Transaction.Active:=true;
    tb.TableName:=AnsiUpperCase(tbPms_Image);
    tb.Filter:=' Pms_image_id='+id+' ';
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Edit;
    tb.FieldByName('Pms_image_id').AsInteger:=strtoint(id);
    tb.FieldByName('pms_street_id').AsInteger:=street_id;
    tb.FieldByName('housenumber').AsString:=Trim(edHouseNumber.Text);
    TtsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;


    TfmRBPms_Image(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Image(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Image(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Image_id').AsInteger:=oldPms_Image_id;
      FieldByName('pms_street_id').AsInteger:=street_id;
      FieldByName('street_name').AsString:=Trim(edStreet.Text);
      FieldByName('housenumber').AsString:=Trim(edHouseNumber.Text);
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

procedure TfmEditRBPms_Image.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Image.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edStreet.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbStreet.Caption]));
    edStreet.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edHouseNumber.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbHouseNumber.Caption]));
    edHouseNumber.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Image.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Image.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edStreet.MaxLength:=DomainNameLength;
  edHouseNumber.MaxLength:=DomainShortNameLength;
end;

procedure TfmEditRBPms_Image.bibImageLoadClick(Sender: TObject);
begin
  if not Od.Execute then exit;
  imImage.Picture.LoadFromFile(od.FileName);
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Image.bibImageSaveClick(Sender: TObject);
begin
  if not Sd.Execute then exit;
  imImage.Picture.SaveToFile(sd.FileName);
end;

procedure TfmEditRBPms_Image.bibClearImageClick(Sender: TObject);
begin
  imImage.Picture.Assign(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Image.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Image.btStreetClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='pms_street_id';
  TPRBI.Locate.KeyValues:=street_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPms_Street,@TPRBI) then begin
   ChangeFlag:=true;
   street_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'pms_street_id');
   edStreet.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
