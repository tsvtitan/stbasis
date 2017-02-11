unit UEditRBEmpPhoto;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, ExtDlgs, clipbrd, IBTable, IB, URBEmp;

type
  TfmEditRBEmpPhoto = class(TfmEditRB)
    lbDatePhoto: TLabel;
    dtpDatePhoto: TDateTimePicker;
    lbNote: TLabel;
    meNote: TMemo;
    lbPhoto: TLabel;
    srlbxPhoto: TScrollBox;
    imPhoto: TImage;
    bibPhotoLoad: TBitBtn;
    bibPhotoSave: TBitBtn;
    OD: TOpenPictureDialog;
    SD: TSavePictureDialog;
    bibPhotoCopy: TBitBtn;
    bibPhotoPaste: TBitBtn;
    chbPhotoStretch: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edhousenumKeyPress(Sender: TObject; var Key: Char);
    procedure meNoteChange(Sender: TObject);
    procedure dtpDatePhotoChange(Sender: TObject);
    procedure bibPhotoLoadClick(Sender: TObject);
    procedure bibPhotoSaveClick(Sender: TObject);
    procedure bibPhotoCopyClick(Sender: TObject);
    procedure bibPhotoPasteClick(Sender: TObject);
    procedure chbPhotoStretchClick(Sender: TObject);
    procedure imPhotoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imPhotoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imPhotoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    PointClicked: TPoint;
    FoldPosX, FoldPosY: Integer;
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    profession_id: Integer;
    typestud_id: Integer;
    educ_id: Integer;
    craft_id: Integer;
    school_id: Integer;
    olddiplom_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

  TNewHotKey=class(THotKey)
  public
   property OnKeyUp;
  end;


var
  fmEditRBEmpPhoto: TfmEditRBEmpPhoto;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited, tsvPicture;

var
  AData: THandle;
  APalette: HPALETTE;

{$R *.DFM}

procedure TfmEditRBEmpPhoto.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPhoto.AddToRBooks: Boolean;
var
  tb: TIBTable;
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
    id:=inttostr(GetGenId(IBDB,tbPhoto,1));
    tb.TableName:=AnsiUpperCase(tbPhoto);
    tb.Filter:=' photo_id='+id;
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Append;
    tb.FieldByName('photo_id').AsString:=id;
    tb.FieldByName('emp_id').AsInteger:=emp_id;
    tb.FieldByName('datephoto').AsDateTime:=dtpDatePhoto.DateTime;
    tb.FieldByName('note').AsString:=meNote.Lines.Text;
    TTsvPicture(imPhoto.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('photo')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;

    ParentEmpForm.ActiveEmpPhoto(false);
    ParentEmpForm.qrEmpPhoto.AfterScroll:=nil;
    ParentEmpForm.qrEmpPhoto.Locate('photo_id',id,[LocaseInsensitive]);
    ParentEmpForm.qrEmpPhoto.AfterScroll:=ParentEmpForm.qrEmpPhotoAfterScroll;
    ParentEmpForm.qrEmpPhotoAfterScroll(ParentEmpForm.qrEmpPhoto);
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

procedure TfmEditRBEmpPhoto.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPhoto.UpdateRBooks: Boolean;
var
  tb: TIBTable;
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
    id:=ParentEmpForm.qrEmpPhoto.FieldByName('photo_id').AsString;
    tb.TableName:=AnsiUpperCase(tbPhoto);
    tb.Filter:=' photo_id='+id;
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Locate('photo_id',id,[LocaseInsensitive]);
    tb.Edit;
    tb.FieldByName('photo_id').AsString:=id;
    tb.FieldByName('emp_id').AsInteger:=emp_id;
    tb.FieldByName('datephoto').AsDateTime:=dtpDatePhoto.DateTime;
    tb.FieldByName('note').AsString:=meNote.Lines.Text;
    TTsvPicture(imPhoto.Picture).SaveToStream(ms);
    ms.Position:=0;
    TBlobField(tb.FieldByName('photo')).LoadFromStream(ms);
    tb.Post;
    tb.Transaction.Commit;

    ParentEmpForm.ActiveEmpPhoto(false);
    ParentEmpForm.qrEmpPhoto.AfterScroll:=nil;
    ParentEmpForm.qrEmpPhoto.Locate('photo_id',id,[LocaseInsensitive]);
    ParentEmpForm.qrEmpPhoto.AfterScroll:=ParentEmpForm.qrEmpPhotoAfterScroll;
    ParentEmpForm.qrEmpPhotoAfterScroll(ParentEmpForm.qrEmpPhoto);
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

procedure TfmEditRBEmpPhoto.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpPhoto.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(meNote.Lines.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    meNote.SetFocus;
    Result:=false;
    exit;
  end;
  if TTsvPicture(imPhoto.Picture).isEmpty then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPhoto.Caption]));
    bibPhotoLoad.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBEmpPhoto.FormCreate(Sender: TObject);
var
  curdate: TDate;
begin
  inherited;
  imPhoto.Cursor:=crImageMove;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  curdate:=_GetDateTimeFromServer;
  meNote.MaxLength:=DomainNoteLength;
  dtpDatePhoto.date:=curdate;

  chbPhotoStretchClick(nil);
end;

procedure TfmEditRBEmpPhoto.edhousenumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBEmpPhoto.meNoteChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPhoto.dtpDatePhotoChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPhoto.bibPhotoLoadClick(Sender: TObject);
begin
  if not Od.Execute then exit;
  imPhoto.Picture.LoadFromFile(od.FileName);
  chbPhotoStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPhoto.bibPhotoSaveClick(Sender: TObject);
begin
  if not Sd.Execute then exit;
  imPhoto.Picture.SaveToFile(sd.FileName);
  chbPhotoStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPhoto.bibPhotoCopyClick(Sender: TObject);
begin
  imPhoto.Picture.SaveToClipboardFormat(CF_PICTURE,AData,APalette);
end;

procedure TfmEditRBEmpPhoto.bibPhotoPasteClick(Sender: TObject);
begin
  imPhoto.Picture.LoadFromClipBoardFormat(CF_PICTURE,AData,0);
  chbPhotoStretchClick(nil);
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpPhoto.chbPhotoStretchClick(Sender: TObject);
begin
  imPhoto.AutoSize:=not chbPhotoStretch.Checked;
  imPhoto.Stretch:=chbPhotoStretch.Checked;
  if imPhoto.Stretch then begin
   srlbxPhoto.HorzScrollBar.Range:=0;
   srlbxPhoto.VertScrollBar.Range:=0;
   imPhoto.Align:=alClient;
  end else begin
   imPhoto.Align:=alNone;
   if (imPhoto.Picture.Height>srlbxPhoto.Height-4)or
      (imPhoto.Picture.Width>srlbxPhoto.Width-4) then begin
    imPhoto.Height:=imPhoto.Picture.Height;
    imPhoto.Width:=imPhoto.Picture.Width;
   end else begin
    imPhoto.AutoSize:=false;
    imPhoto.Height:=srlbxPhoto.Height-4;
    imPhoto.Width:=srlbxPhoto.Width-4;
   end;
   srlbxPhoto.HorzScrollBar.Range:=imPhoto.Width;
   srlbxPhoto.VertScrollBar.Range:=imPhoto.Height;
  end;
end;

procedure TfmEditRBEmpPhoto.imPhotoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetCursor(Screen.Cursors[crImageDown]);
  PointClicked:=imPhoto.ClientToScreen(Point(X,Y));
  FoldPosX:=(imPhoto.Parent as TScrollBox).HorzScrollBar.Position;
  FoldPosY:=(imPhoto.Parent as TScrollBox).VertScrollBar.Position;
end;

procedure TfmEditRBEmpPhoto.imPhotoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 CurPoint: TPoint;
begin
  if (imPhoto.Parent is TScrollBox) and (ssLeft in Shift) then begin
   CurPoint:=imPhoto.ClientToScreen(Point(X,Y));
   (imPhoto.Parent as TScrollBox).HorzScrollBar.Position:=FOldPosX-CurPoint.X+PointClicked.X;
   (imPhoto.Parent as TScrollBox).VertScrollBar.Position:=FOldPosY-CurPoint.Y+PointClicked.Y;
  end;
end;

procedure TfmEditRBEmpPhoto.imPhotoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  imPhoto.Cursor:=crImageMove;
end;

end.
