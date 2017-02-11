unit UEditRBToolbutton;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, ExtDlgs, IBTable, clipbrd;

type
  TfmEditRBToolbutton = class(TfmEditRB)
    lbName: TLabel;
    lbToolbar: TLabel;
    lbHint: TLabel;
    lbShortCut: TLabel;
    lbInterface: TLabel;
    edName: TEdit;
    edToolbar: TEdit;
    bibToolbar: TButton;
    meHint: TMemo;
    grbImage: TGroupBox;
    srlbxImage: TScrollBox;
    imImage: TImage;
    bibImageLoad: TButton;
    bibImageSave: TButton;
    bibImageCopy: TButton;
    bibImagePaste: TButton;
    chbImageStretch: TCheckBox;
    bibImageClear: TButton;
    htShortCut: THotKey;
    edInterface: TEdit;
    bibInterface: TButton;
    OD: TOpenPictureDialog;
    SD: TSavePictureDialog;
    lbStyle: TLabel;
    cmbStyle: TComboBox;
    lbSort: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure htShortCutEnter(Sender: TObject);
    procedure edToolbarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibImageLoadClick(Sender: TObject);
    procedure bibImageSaveClick(Sender: TObject);
    procedure bibImageCopyClick(Sender: TObject);
    procedure bibImagePasteClick(Sender: TObject);
    procedure bibImageClearClick(Sender: TObject);
    procedure chbImageStretchClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bibToolbarClick(Sender: TObject);
    procedure bibInterfaceClick(Sender: TObject);
    procedure edInterfaceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
  private
    PointClicked: TPoint;
    FoldPosX, FoldPosY: Integer;
  protected
    procedure LoadFromIni; override;
    procedure SaveToIni; override;
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldtoolbutton_id: Integer;
    interface_id: Integer;
    toolbar_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBToolbutton: TfmEditRBToolbutton;

implementation

uses UDesignTsvCode, UDesignTsvData, UMainUnited, URBToolbutton, tsvPicture, menus;

{$R *.DFM}
var
  AData: THandle;
  APalette: HPALETTE;


procedure TfmEditRBToolbutton.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBToolbutton.AddToRBooks: Boolean;
var
  tb: TIBTable;
  id: string;
  ms: TMemoryStream;
  sqls: string;
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
    id:=inttostr(GetGenId(IBDB,tbToolbutton,1));
    tb.TableName:=AnsiUpperCase(tbToolbutton);
    tb.Filter:=' toolbutton_id='+id;
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Append;
    tb.FieldByName('toolbutton_id').AsString:=id;
    tb.FieldByName('toolbar_id').Value:=toolbar_id;
    tb.FieldByName('name').AsString:=Trim(edName.Text);
    tb.FieldByName('hint').Value:=Iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
    tb.FieldByName('interface_id').Value:=Iff(Trim(edInterface.Text)<>'',interface_id,Null);
    tb.FieldByName('shortcut').AsInteger:=Integer(htShortCut.HotKey);
    tb.FieldByName('style').AsInteger:=cmbStyle.ItemIndex;
    tb.FieldByName('sortvalue').AsInteger:=udSort.Position;

    TTsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;
    oldtoolbutton_id:=strtoint(id);

    TfmRBToolbutton(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBToolbutton(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBToolbutton(fmParent).MainQr do begin
      Insert;
      FieldByName('toolbutton_id').AsInteger:=oldtoolbutton_id;
      FieldByName('toolbar_id').AsInteger:=toolbar_id;
      FieldByName('toolbarname').AsString:=Trim(edToolbar.Text);
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('hint').Value:=Iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
      FieldByName('interface_id').Value:=Iff(Trim(edInterface.Text)<>'',interface_id,Null);
      FieldByName('interfacename').Value:=Iff(Trim(edInterface.Text)<>'',Trim(edInterface.Text),Null);
      FieldByName('shortcut').AsInteger:=htShortCut.HotKey;
      FieldByName('style').AsInteger:=cmbStyle.ItemIndex;
      FieldByName('sortvalue').AsInteger:=udSort.Position;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBToolbutton.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBToolbutton.UpdateRBooks: Boolean;
var
  tb: TIBTable;
  id: string;
  ms: TMemoryStream;
  sqls: string;
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
    id:=inttostr(oldtoolbutton_id);
    tb.TableName:=AnsiUpperCase(tbToolbutton);
    tb.Filter:=' toolbutton_id='+id;
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Locate('toolbutton_id',id,[LocaseInsensitive]);
    tb.Edit;
    tb.FieldByName('toolbutton_id').AsString:=id;
    tb.FieldByName('toolbar_id').Value:=toolbar_id;
    tb.FieldByName('name').AsString:=Trim(edName.Text);
    tb.FieldByName('hint').Value:=Iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
    tb.FieldByName('interface_id').Value:=Iff(Trim(edInterface.Text)<>'',interface_id,Null);
    tb.FieldByName('shortcut').AsInteger:=Integer(htShortCut.HotKey);
    tb.FieldByName('style').AsInteger:=cmbStyle.ItemIndex;
    tb.FieldByName('sortvalue').AsInteger:=udSort.Position;

    TTsvPicture(imImage.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('image')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;

    TfmRBToolbutton(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBToolbutton(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBToolbutton(fmParent).MainQr do begin
      Edit;
      FieldByName('toolbutton_id').AsInteger:=oldtoolbutton_id;
      FieldByName('toolbar_id').AsInteger:=toolbar_id;
      FieldByName('toolbarname').AsString:=Trim(edToolbar.Text);
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('hint').Value:=Iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
      FieldByName('interface_id').Value:=Iff(Trim(edInterface.Text)<>'',interface_id,Null);
      FieldByName('interfacename').Value:=Iff(Trim(edInterface.Text)<>'',Trim(edInterface.Text),Null);
      FieldByName('shortcut').AsInteger:=htShortCut.HotKey;
      FieldByName('style').AsInteger:=cmbStyle.ItemIndex;
      FieldByName('sortvalue').AsInteger:=udSort.Position;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBToolbutton.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBToolbutton.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edToolBar.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbToolBar.Caption]));
    bibToolBar.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBToolbutton.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbutton.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  imImage.Cursor:=crImageMove;
  
  Screen.Cursors[crImageMove] := LoadCursor(HINSTANCE,CursorMove);
  Screen.Cursors[crImageDown] := LoadCursor(HINSTANCE,CursorDown);

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edToolbar.MaxLength:=DomainNameLength;
  edInterface.MaxLength:=DomainNameLength;
  meHint.MaxLength:=DomainNoteLength;

  chbImageStretchClick(nil);
  
  cmbStyle.Clear;
  for i:=0 to 4 do cmbStyle.Items.Add(GetStyleByValue(i));
  cmbStyle.ItemIndex:=0;

  LoadFromIni;
end;

procedure TfmEditRBToolbutton.htShortCutEnter(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbutton.edToolbarKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearInterface;
  begin
    if Length(edInterface.Text)=Length(edInterface.SelText) then begin
      edInterface.Text:='';
      interface_id:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearInterface;
  end;
end;

procedure TfmEditRBToolbutton.bibImageLoadClick(Sender: TObject);
begin
  if not Od.Execute then exit;
  imImage.Picture.LoadFromFile(od.FileName);
  chbImageStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbutton.bibImageSaveClick(Sender: TObject);
begin
  if not Sd.Execute then exit;
  imImage.Picture.SaveToFile(sd.FileName);
  chbImageStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbutton.bibImageCopyClick(Sender: TObject);
begin
  imImage.Picture.SaveToClipboardFormat(CF_PICTURE,AData,APalette);
end;

procedure TfmEditRBToolbutton.bibImagePasteClick(Sender: TObject);
begin
  imImage.Picture.LoadFromClipBoardFormat(CF_PICTURE,AData,0);
  chbImageStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbutton.bibImageClearClick(Sender: TObject);
begin
  imImage.Picture.Assign(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbutton.chbImageStretchClick(Sender: TObject);
begin
  imImage.AutoSize:=not chbImageStretch.Checked;
  imImage.Stretch:=chbImageStretch.Checked;
  if imImage.Stretch then begin
   srlbxImage.HorzScrollBar.Range:=0;
   srlbxImage.VertScrollBar.Range:=0;
   imImage.Align:=alClient;
  end else begin
   imImage.Align:=alNone;
   if (imImage.Picture.Height>srlbxImage.Height-4)or
      (imImage.Picture.Width>srlbxImage.Width-4) then begin
    imImage.Height:=imImage.Picture.Height;
    imImage.Width:=imImage.Picture.Width;
   end else begin
    imImage.AutoSize:=false;
    imImage.Height:=srlbxImage.Height-4;
    imImage.Width:=srlbxImage.Width-4;
   end;
   srlbxImage.HorzScrollBar.Range:=imImage.Width;
   srlbxImage.VertScrollBar.Range:=imImage.Height;
  end;
end;

procedure TfmEditRBToolbutton.FormDestroy(Sender: TObject);
begin
  inherited;
  DestroyCursor(Screen.Cursors[crImageMove]);
  DestroyCursor(Screen.Cursors[crImageDown]);
  Screen.Cursors[crImageMove] := 0;
  Screen.Cursors[crImageDown] := 0;

  SaveToIni;
end;

procedure TfmEditRBToolbutton.LoadFromIni;
begin
  chbImageStretch.Checked:=ReadParam(ClassName,'chbImageStretch.Checked',chbImageStretch.Checked);
end;

procedure TfmEditRBToolbutton.SaveToIni;
begin
  WriteParam(ClassName,'chbImageStretch.Checked',chbImageStretch.Checked);
end;


procedure TfmEditRBToolbutton.imImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetCursor(Screen.Cursors[crImageDown]);
  PointClicked:=imImage.ClientToScreen(Point(X,Y));
  FoldPosX:=(imImage.Parent as TScrollBox).HorzScrollBar.Position;
  FoldPosY:=(imImage.Parent as TScrollBox).VertScrollBar.Position;
end;

procedure TfmEditRBToolbutton.imImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 CurPoint: TPoint;
begin
  if (imImage.Parent is TScrollBox) and (ssLeft in Shift) then begin
   CurPoint:=imImage.ClientToScreen(Point(X,Y));
   (imImage.Parent as TScrollBox).HorzScrollBar.Position:=FOldPosX-CurPoint.X+PointClicked.X;
   (imImage.Parent as TScrollBox).VertScrollBar.Position:=FOldPosY-CurPoint.Y+PointClicked.Y;
  end;
end;

procedure TfmEditRBToolbutton.imImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imImage.Cursor:=crImageMove;
end;

procedure TfmEditRBToolbutton.bibToolbarClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='toolbar_id';
  TPRBI.Locate.KeyValues:=toolbar_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkToolbar,@TPRBI) then begin
   ChangeFlag:=true;
   toolbar_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'toolbar_id');
   edToolbar.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBToolbutton.bibInterfaceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='interface_id';
  TPRBI.Locate.KeyValues:=interface_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkInterface,@TPRBI) then begin
   ChangeFlag:=true;
   interface_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'interface_id');
   edInterface.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBToolbutton.edInterfaceKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearInterface;
  begin
    if Length(edInterface.Text)=Length(edInterface.SelText) then begin
      edInterface.Text:='';
      interface_id:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearInterface;
  end;
end;

procedure TfmEditRBToolbutton.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

end.
