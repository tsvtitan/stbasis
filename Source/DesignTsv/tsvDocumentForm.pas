unit tsvDocumentForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, buttons, Menus, Commctrl,
  TypInfo, imglist, Mask, olectnrs, UMainUnited;

type

  TDocumentForm=class;
  TDocumentFormScrollBox=class;

  TDocumentFormCommand=(dfcNone,dfcNewDocument,dfcOpenDocument,dfcSaveDocument,dfcSaveToBaseDocuments,dfcViewOption);

  PDocumentFormKeyboard=^TDocumentFormKeyboard;
  TDocumentFormKeyboard=packed record
    Key: Word;
    Shift: TShiftState;
    Command: TDocumentFormCommand;
  end;

  TDocumentFormListKeyboard=class
  private
    FList: TList;
    function GetCount: Integer;
    function GetDocumentFormKeyboard(Index: Integer): PDocumentFormKeyboard;
  public
    constructor Create;
    destructor Destroy;override;
    function Add(ACommand: TDocumentFormCommand; AKey: Word; AShift: TShiftState): PDocumentFormKeyboard;
    procedure Clear;
    procedure GetDocumentFormKeyboardFromKey(AKey: Word; AShift: TShiftState; AList: TList);
    procedure GetDocumentFormKeyboardFromCommand(ACommand: TDocumentFormCommand; AList: TList);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: PDocumentFormKeyboard read GetDocumentFormKeyboard;
  end;

  TOnDocumentFormCommand=procedure (Sender: TObject; DocumentFormCommand: TDocumentFormCommand) of object;

  TDocumentFormScrollBox=class(TScrollBox)
  private
    FIncrementID: Integer;
    FListForms: TList;
    FActiveDocumentForm: TDocumentForm;
    FLastLeft,FLastTop: Integer;
    FLastInc: Integer;
    FOnDocumentFormCommand: TOnDocumentFormCommand;
    FDFLK: TDocumentFormListKeyboard;

    procedure SetRangeScrollBar(X,Y: Integer);
    procedure SetDefaultKeyBoard;
    procedure RunDocumentFormCommandNewDocument;
    procedure RunDocumentFormCommandOpenDocument;
    procedure RunDocumentFormCommandSaveDocument;
    function GetNewDocumentName(ByFileName: string=''): string;
    function ExistsDocumentNameNotForm(DocumentName: string; Form: TDocumentForm=nil): Boolean;

    procedure SetRealScrollBoxRange;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ClearListForms;
    function CreateDocumentFormStream(Stream: TStream): TDocumentForm;
    function CreateDocumentForm(View: Boolean=true): TDocumentForm;
    function ExistsDocumentName(DocumentName: string): Boolean;

    procedure RunDocumentFormCommand(Sender: TObject; DocumentFormCommand: TDocumentFormCommand);

    property ActiveDocumentForm: TDocumentForm read FActiveDocumentForm;
    property ListForms: TList read FListForms;
    property DocumentFormListKeyboard: TDocumentFormListKeyboard read FDFLK;
    property OnDocumentFormCommand: TOnDocumentFormCommand read FOnDocumentFormCommand write FOnDocumentFormCommand;
  end;

  TDocumentFormOleContainer=class(TOleContainer)
  private
    FDocumentForm: TDocumentForm;
    PointClicked: TPoint;
    FoldPosX, FoldPosY: Integer;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;

    procedure SaveToStreamAsDocument(Stream: TStream);
    procedure LoadFromStreamAsDocument(Stream: TStream);
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;  X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;  X, Y: Integer); override;
  end;

  TDocumentForm = class(TForm)
    pnTop: TPanel;
    lbName: TLabel;
    edName: TEdit;
    lbOleClass: TLabel;
    edOleClass: TEdit;
    odAll: TOpenDialog;
    sdAll: TSaveDialog;
    sbOle: TScrollBox;
    lbHint: TLabel;
    meHint: TMemo;
    procedure edNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FChangeFlag: Boolean;
    FDocumentFormScrollBox: TDocumentFormScrollBox;
    FDocumentOle: TDocumentFormOleContainer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMIconEraseBkgnd(var Message: TWMIconEraseBkgnd); message WM_ICONERASEBKGND;
    procedure WMNCCreate(var Message: TWMNCCreate);message WM_NCCREATE;
    procedure WMMDIActivate(var Message: TWMMDIActivate);message WM_MDIACTIVATE;
    procedure WMPaint(var Message: TWMPaint);message WM_PAINT;
    procedure WMClose(var Message: TWMClose);message WM_CLOSE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure DoClose(var Action: TCloseAction); override;
    procedure Resizing(State: TWindowState);override;
    procedure Activate; override;
  public
    RealyName: string;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure Click;override;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(FileName: String);
    procedure SaveToFile(FileName: String);
    function LoadDocumentFromFileWithDialog: Boolean;
    function SaveDocumentToFileWithDialog: Boolean;
  end;
  
  function GetHintDocumentFormCommand(ACommand: TDocumentFormCommand; Default: string=''):String;
  function GetHintWithShortCutFromDocumentFormCommand(DFSB: TDocumentFormScrollBox;
                ACommand: TDocumentFormCommand; Default: string):String;
  function GetShortCutFromDocumentFormCommand(DFSB: TDocumentFormScrollBox; ACommand: TDocumentFormCommand): TShortCut;

type
  PInfoHintDocumentFormCommand=^TInfoHintDocumentFormCommand;
  TInfoHintDocumentFormCommand=packed record
    Hint: String;
    Command: TDocumentFormCommand;
  end;

var
  ListHintDocumentFormCommand: TList;

const
  ConstdfcNone='Неизвестная';


implementation

uses ActiveX, comobj, Toolwin, consts, UDesignTsvData;

{$R *.DFM}
{$R tsv.res}

const

  DocumentFormReadWriteSize=4096;
  DocumentFormCaption='Новый документ %d';
  DocumentFormDialogSave='Сохранить документ <%s>?';
  DocumentFormFilterExt='Все файлы (*.*)|*.*';
  DocumentFormNameAreadyExists='Документ с именем <%s> уже существует.';

  ConstdfcNewDocument='Новый документ';
  ConstdfcOpenDocument='Открыть документ';
  ConstdfcSaveDocument='Сохранить документ';


{ TDocumentFormKeyboard }

constructor TDocumentFormListKeyboard.Create;
begin
  FList:=TList.Create;
end;

destructor TDocumentFormListKeyboard.Destroy;
begin
  FList.Free;
end;

procedure TDocumentFormListKeyboard.Clear;
var
  i: Integer;
  P: PDocumentFormKeyboard;
begin
  for i:=0 to FList.Count-1 do begin
    P:=FList.Items[i];
    Dispose(P);
  end;
  FList.Clear;
end;

function TDocumentFormListKeyboard.Add(ACommand: TDocumentFormCommand; AKey: Word;
               AShift: TShiftState): PDocumentFormKeyboard;
var
  P: PDocumentFormKeyboard;
begin
  New(P);
  P.Key:=Akey;
  P.Shift:=AShift;
  P.Command:=ACommand;
  FList.Add(P);
  Result:=P;
end;

procedure TDocumentFormListKeyboard.GetDocumentFormKeyboardFromKey(AKey: Word; AShift: TShiftState; AList: TList);
var
  i: Integer;
  P: PDocumentFormKeyboard;
begin
  if AList=nil then exit;
  for i:=0 to FList.Count-1 do begin
    P:=FList.Items[i];
    if (P.Key=AKey) and (P.Shift=AShift) then
      AList.Add(P);
  end;
end;

procedure TDocumentFormListKeyboard.GetDocumentFormKeyboardFromCommand(ACommand: TDocumentFormCommand; AList: TList);
var
  i: Integer;
  P: PDocumentFormKeyboard;
begin
  if AList=nil then exit;
  for i:=0 to FList.Count-1 do begin
    P:=FList.Items[i];
    if P.Command=ACommand then
      AList.Add(P);
  end;
end;

function TDocumentFormListKeyboard.GetCount: Integer;
begin
  Result:=FList.Count;
end;

function TDocumentFormListKeyboard.GetDocumentFormKeyboard(Index: Integer): PDocumentFormKeyboard;
begin
  Result:=nil;
  if (Index>=0) or (Index<=FList.Count-1) then
    Result:=FList.Items[Index];
end;

{ TDocumentFormScrollBox }

constructor TDocumentFormScrollBox.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FListForms:=TList.Create;
  FActiveDocumentForm:=nil;
  FLastLeft:=0;
  FLastTop:=0;
  FLastInc:=10;
  FIncrementID:=0;
  FDFLK:=TDocumentFormListKeyboard.Create;
  SetDefaultKeyBoard;
end;

procedure TDocumentFormScrollBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;

destructor TDocumentFormScrollBox.Destroy;
begin
  FDFLK.Free;
  FActiveDocumentForm:=nil;
  ClearListForms;
  FListForms.Free;
  inherited;
end;

procedure TDocumentFormScrollBox.ClearListForms;
var
  i: Integer;
  fm: TDocumentForm;
begin
  for i:=FListForms.Count-1 downto 0 do begin
    fm:=FListForms.Items[i];
    fm.Free;
  end;
  FListForms.Clear;
end;

function TDocumentFormScrollBox.CreateDocumentFormStream(Stream: TStream): TDocumentForm;
var
  fm: TDocumentForm;
  NewStyle: Longint;
begin
  fm:=TDocumentForm.Create(nil);
  fm.ParentWindow:=Handle;

  if (FLastLeft+fm.Width>=Width)or
     (FLastTop+fm.Height>=Height) then begin
   FLastLeft:=0;
   FLastTop:=0;
  end;

  fm.Left:=FLastLeft;
  fm.Top:=FLastTop;
  inc(FLastLeft,FLastInc);
  inc(FLastTop,FLastInc);

  inc(FIncrementID);

  fm.LoadFromStream(Stream);

  fm.FDocumentFormScrollBox:=Self;
  fm.Caption:=GetNewDocumentName;
  fm.Visible:=true;
  fm.BringToFront;


  NewStyle:=GetWindowLong(fm.Handle, GWL_STYLE) or Longint(WS_POPUP);
  SetWindowLong(fm.Handle,GWL_STYLE,NewStyle);

  FListForms.Add(fm);

  SetRealScrollBoxRange;
  
  FActiveDocumentForm:=fm;
  fm.FChangeFlag:=false;
  Result:=fm;


end;

function TDocumentFormScrollBox.CreateDocumentForm(View: Boolean=true): TDocumentForm;
var
  fm: TDocumentForm;
  NewStyle: Longint;
begin
  fm:=TDocumentForm.Create(nil);
  fm.ParentWindow:=Handle;

  if (FLastLeft+fm.Width>=Width)or
     (FLastTop+fm.Height>=Height) then begin
   FLastLeft:=0;
   FLastTop:=0;
  end;

  fm.Left:=FLastLeft;
  fm.Top:=FLastTop;
  inc(FLastLeft,FLastInc);
  inc(FLastTop,FLastInc);

  inc(FIncrementID);
  
  fm.FDocumentFormScrollBox:=Self;
  fm.Caption:=GetNewDocumentName;
  if View then begin
   fm.Visible:=true;
   fm.BringToFront;
  end;


  NewStyle:=GetWindowLong(fm.Handle, GWL_STYLE) or Longint(WS_POPUP);
  SetWindowLong(fm.Handle,GWL_STYLE,NewStyle);

  FListForms.Add(fm);

  SetRealScrollBoxRange;
  
  FActiveDocumentForm:=fm;
  fm.FChangeFlag:=false;
  Result:=fm;
end;

procedure TDocumentFormScrollBox.SetRangeScrollBar(X,Y: Integer);
begin
  HorzScrollBar.Range:=X;
  VertScrollBar.Range:=Y;
end;

procedure TDocumentFormScrollBox.SetDefaultKeyBoard;
begin
  if FDFLK=nil then exit;
  FDFLK.Clear;
  FDFLK.Add(dfcNewDocument,Ord('N'),[ssCtrl]);
  FDFLK.Add(dfcOpenDocument,Ord('O'),[ssCtrl]);
  FDFLK.Add(dfcSaveToBaseDocuments,Ord('S'),[ssCtrl]);
end;

function TDocumentFormScrollBox.ExistsDocumentNameNotForm(DocumentName: string; Form: TDocumentForm=nil): Boolean;
var
  fm: TDocumentForm;
  i: Integer;
begin
  Result:=false;
  for i:=0 to ListForms.Count-1 do begin
    fm:=ListForms.Items[i];
    if fm<>Form then
      if AnsiSameText(Trim(fm.edName.Text),Trim(DocumentName)) then begin
        Result:=true;
        exit;
      end;
  end;
end;

function TDocumentFormScrollBox.ExistsDocumentName(DocumentName: string): Boolean;
var
  fm: TDocumentForm;
  i: Integer;
begin
  Result:=false;
  for i:=0 to ListForms.Count-1 do begin
    fm:=ListForms.Items[i];
    if AnsiSameText(Trim(fm.edName.Text),Trim(DocumentName)) then begin
      Result:=true;
      exit;
    end;
  end;
end;

function TDocumentFormScrollBox.GetNewDocumentName(ByFileName: string): string;
begin
  if Trim(ByFileName)='' then
   Result:=Format(DocumentFormCaption,[FIncrementID])
  else Result:=ChangeFileExt(ExtractFileName(ByFileName),''); 
end;

procedure TDocumentFormScrollBox.RunDocumentFormCommandNewDocument;
var
  fm: TDocumentForm;
begin
  fm:=CreateDocumentForm(false);
  if not fm.FDocumentOle.InsertObjectDialog then begin
    fm.Free;
    exit;
  end;
  fm.edName.Text:=GetNewDocumentName;
  fm.edOleClass.Text:=fm.FDocumentOle.OleClassName;
  fm.FDocumentOle.DoVerb(ovShow);
  fm.Visible:=true;
end;

procedure TDocumentFormScrollBox.RunDocumentFormCommandOpenDocument;
var
  fm: TDocumentForm;
begin
  fm:=CreateDocumentForm(false);
  if not fm.LoadDocumentFromFileWithDialog then begin
   fm.Free;
   exit;
  end;
end;

procedure TDocumentFormScrollBox.RunDocumentFormCommandSaveDocument;
begin
  if FActiveDocumentForm=nil then exit;
  FActiveDocumentForm.SaveDocumentToFileWithDialog;
end;

procedure TDocumentFormScrollBox.RunDocumentFormCommand(Sender: TObject; DocumentFormCommand: TDocumentFormCommand);
begin
  case DocumentFormCommand of
    dfcNone:;
    dfcNewDocument: RunDocumentFormCommandNewDocument;
    dfcOpenDocument: RunDocumentFormCommandOpenDocument;
    dfcSaveDocument: RunDocumentFormCommandSaveDocument;
  end;
  if Assigned(FOnDocumentFormCommand) then
    FOnDocumentFormCommand(Sender,DocumentFormCommand);
end;

procedure TDocumentFormScrollBox.DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AList: TList;
  i: Integer;
  P: PDocumentFormKeyboard;
begin
  AList:=TList.Create;
  try
    FDFLK.GetDocumentFormKeyboardFromKey(Key,Shift,AList);
    for i:=0 to AList.Count-1 do begin
      P:=AList.Items[i];
      RunDocumentFormCommand(Sender,P.Command);
    end;
  finally
   AList.Free;
  end;
end;

procedure TDocumentFormScrollBox.SetRealScrollBoxRange;
var
  i: Integer;
  ct: TControl;
  maxX,maxY: Integer;
begin
  maxX:=0;
  maxY:=0;
  for i:=0 to FListForms.Count-1 do begin
    ct:=FListForms.Items[i];
    if (ct.Left+ct.Width)>maxX then MaxX:=ct.Left+ct.Width;
    if (ct.Top+ct.Height)>maxY then MaxY:=ct.Top+ct.Height;
  end;
  SetRangeScrollBar(maxX,maxY);
end;

{ TDocumentFormOleContainer }

constructor TDocumentFormOleContainer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Cursor:=crImageMove;

  Screen.Cursors[crImageMove] := LoadCursor(HINSTANCE,CursorMove);
  Screen.Cursors[crImageDown] := LoadCursor(HINSTANCE,CursorDown);
end;

destructor TDocumentFormOleContainer.Destroy;
begin
  DestroyCursor(Screen.Cursors[crImageMove]);
  DestroyCursor(Screen.Cursors[crImageDown]);
  Screen.Cursors[crImageMove] := 0;
  Screen.Cursors[crImageDown] := 0;
  
  inherited Destroy;
end;

procedure TDocumentFormOleContainer.SaveToStreamAsDocument(Stream: TStream);
begin
end;

procedure TDocumentFormOleContainer.LoadFromStreamAsDocument(Stream: TStream);
begin
end;

procedure TDocumentFormOleContainer.MouseDown(Button: TMouseButton; Shift: TShiftState;  X, Y: Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  SetCursor(Screen.Cursors[crImageDown]);
  PointClicked:=Self.ClientToScreen(Point(X,Y));
  FoldPosX:=(Self.Parent as TScrollBox).HorzScrollBar.Position;
  FoldPosY:=(Self.Parent as TScrollBox).VertScrollBar.Position;
end;

procedure TDocumentFormOleContainer.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  CurPoint: TPoint;
begin
  inherited MouseMove(Shift,X,Y);
  if (Self.Parent is TScrollBox) and (ssLeft in Shift) then begin
   SetCursor(Screen.Cursors[crImageDown]);
   CurPoint:=Self.ClientToScreen(Point(X,Y));
   (Self.Parent as TScrollBox).HorzScrollBar.Position:=FOldPosX-CurPoint.X+PointClicked.X;
   (Self.Parent as TScrollBox).VertScrollBar.Position:=FOldPosY-CurPoint.Y+PointClicked.Y;
  end;
end;

procedure TDocumentFormOleContainer.MouseUp(Button: TMouseButton; Shift: TShiftState;  X, Y: Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
  Self.Cursor:=crImageMove;
end;

procedure TDocumentFormOleContainer.DblClick;
{var
  Hwnd: THandle;}
begin
  DoVerb(ovPrimary);
{  hwnd:=GetNextWindow(Application.MainForm.Handle,GW_HWNDNEXT);
  BringWindowToTop(hwnd);
  SetForegroundWindow(hwnd);}
end;

{ TDocumentForm }

constructor TDocumentForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDocumentOle:=TDocumentFormOleContainer.Create(nil);
  FDocumentOle.FDocumentForm:=Self;
  FDocumentOle.Align:=alNone;
  FDocumentOle.Parent:=sbOle;
  FDocumentOle.SizeMode:=smAutoSize;
  FDocumentOle.BorderStyle:=bsNone;
  FDocumentOle.AutoActivate:=aaManual;
  FDocumentOle.AllowInPlace:=false;
  FDocumentOle.AutoVerbMenu:=true;
  FDocumentOle.AllowActiveDoc:=false;
end;

destructor TDocumentForm.Destroy;
begin
  if FDocumentFormScrollBox<>nil then begin
    with FDocumentFormScrollBox do begin
      FListForms.Remove(Self);
      if FActiveDocumentForm=Self then
       if FListForms.Count>0 then begin
         TDocumentForm(FListForms.Items[FListForms.Count-1]).Activate;
      end else FActiveDocumentForm:=nil;
    end;
  end;
  FDocumentOle.Free;
  inherited Destroy;
end;

procedure TDocumentForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;

procedure TDocumentForm.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  if not(csDesigning in ComponentState) and (Message.Result = HTCLIENT) then
    Message.Result := HTCAPTION;
end;

procedure TDocumentForm.Click;
begin
  inherited;
end;

procedure TDocumentForm.Activate;
begin
  inherited;
  FDocumentFormScrollBox.FActiveDocumentForm:=Self;
  BringToFront;
end;

procedure TDocumentForm.DoClose(var Action: TCloseAction);
begin
  Action:=caFree;
  Inherited DoClose(Action);
end;

procedure TDocumentForm.Resizing(State: TWindowState);
begin
  inherited;
  if FDocumentFormScrollBox<>nil then begin
    FDocumentFormScrollBox.SetRealScrollBoxRange;
  end;
end;

procedure TDocumentForm.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  if FDocumentFormScrollBox<>nil then begin
    FDocumentFormScrollBox.SetRealScrollBoxRange;
  end;
end;

procedure TDocumentForm.WMIconEraseBkgnd(var Message: TWMIconEraseBkgnd);
begin
  inherited;
end;

procedure TDocumentForm.WMNCCreate(var Message: TWMNCCreate);
begin
  inherited;
end;

procedure TDocumentForm.WMMDIActivate(var Message: TWMMDIActivate);
begin
  inherited;
end;

procedure TDocumentForm.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;

procedure TDocumentForm.WMClose(var Message: TWMClose);
begin
  inherited;
end;

procedure TDocumentForm.LoadFromStream(Stream: TStream);
var
  rd: TReader;
begin
  try
    FDocumentOle.LoadFromStream(Stream);
    rd:=TReader.Create(Stream,DocumentFormReadWriteSize);
    try
      Width:=rd.ReadInteger;
      Height:=rd.ReadInteger;
      Left:=rd.ReadInteger;
      Top:=rd.ReadInteger;

      if Self.Left<0 then Self.Left:=0;
      if Self.Top<0 then Self.Top:=0;

    finally
      rd.Free;
    end;
  except
    raise;
  end;  
end;

procedure TDocumentForm.SaveToStream(Stream: TStream);
var
  wr: TWriter;
begin
  try
    FDocumentOle.SaveToStream(Stream);
    wr:=TWriter.Create(Stream,DocumentFormReadWriteSize);
    try
      wr.writeinteger(Width);
      wr.writeinteger(Height);
      wr.writeinteger(Left);
      wr.writeinteger(Top);

    finally
      wr.Free;
    end;
  except
    raise;
  end;
end;

procedure TDocumentForm.LoadFromFile(FileName: String);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
   fs:=TFileStream.Create(FileName,fmOpenRead);
   LoadFromStream(fs);
  finally
   fs.Free;
  end;
end;

procedure TDocumentForm.SaveToFile(FileName: String);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
   fs:=TFileStream.Create(FileName,fmCreate or fmOpenWrite);
   SaveToStream(fs);
  finally
   fs.Free;
  end;
end;

function TDocumentForm.LoadDocumentFromFileWithDialog: Boolean;
var
  s: string;
begin
  Result:=false;
  odAll.Filter:=DocumentFormFilterExt;
  if not odAll.Execute then exit;
  Screen.Cursor:=CrHourGlass;
  try
   FDocumentOle.CreateObjectFromFile(odAll.FileName,false);
   s:=FDocumentFormScrollBox.GetNewDocumentName(odAll.FileName);
   if FDocumentFormScrollBox.ExistsDocumentName(s) then
     s:=FDocumentFormScrollBox.GetNewDocumentName('');
   edName.Text:=s;
   Caption:=edName.Text;
   edOleClass.Text:=FDocumentOle.OleClassName;
   FDocumentOle.DoVerb(ovOpen);
   Visible:=true;
   Result:=true;
  finally
   Screen.Cursor:=crDefault;
  end;
end;

function TDocumentForm.SaveDocumentToFileWithDialog: Boolean;
begin
  Result:=false;
  if FDocumentOle.State=osEmpty then exit;
  sdAll.Filter:=DocumentFormFilterExt;
  sdAll.FileName:=edName.Text;
  sdAll.DefaultExt:='';
  if not sdAll.Execute then exit;
  Screen.Cursor:=CrHourGlass;
  try
   FDocumentOle.SaveAsDocument(sdAll.FileName);
   Result:=true;
  finally
   Screen.Cursor:=crDefault;
  end;
end;

procedure TDocumentForm.edNameChange(Sender: TObject);
begin
  if FDocumentFormScrollBox.ExistsDocumentNameNotForm(Trim(edName.Text),Self) then begin
    ShowErrorEx(Format(DocumentFormNameAreadyExists,[edName.Text]));
    edName.Text:=RealyName;
  end;  
  Caption:=edName.Text;
  RealyName:=Caption;
end;

procedure TDocumentForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  but: Integer;
begin
  but:=MessageDlg(Format(DocumentFormDialogSave,[edName.Text]),mtConfirmation,mbYesNoCancel,-1);
  case but of
    mrYes: begin
      SaveDocumentToFileWithDialog;
      CanClose:=true;
    end;
    mrNo: CanClose:=true;
    mrCancel: CanClose:=false;
  end;
end;

procedure TDocumentForm.WMSizing(var Message: TMessage);
var
  NewHeight, NewWidth: Integer;
  R: PRect;
begin
    R := PRect(Message.LParam);
    NewHeight:=R.Bottom-R.Top;
    NewWidth:=R.Right-R.Left;

    if Constraints.MinHeight>0 then
     if NewHeight<=Constraints.MinHeight then
        NewHeight:=Constraints.MinHeight;

    if Constraints.MinWidth>0 then
     if NewWidth<=Constraints.MinWidth then
        NewWidth:=Constraints.MinWidth;

    if Constraints.MaxHeight>0 then
      if NewHeight>=Constraints.MaxHeight then
        NewHeight:=Constraints.MaxHeight;

    if Constraints.MaxWidth>0 then
      if NewWidth>=Constraints.MaxWidth then
        NewWidth:=Constraints.MaxWidth;

    if Message.WParam in [WMSZ_BOTTOM,WMSZ_BOTTOMRIGHT,WMSZ_BOTTOMLEFT] then begin
     R.Bottom := R.Top + NewHeight;
    end else begin
     R.Top := R.Bottom - NewHeight;
    end;

    if Message.WParam in [WMSZ_RIGHT,WMSZ_TOPRIGHT,WMSZ_BOTTOMRIGHT] then begin
     R.Right := R.Left + NewWidth;
    end else begin
     R.Left := R.Right - NewWidth;
    end;

end;


////////////////////////////////////////////

procedure ClearListHintDocumentFormCommand;
var
  i: Integer;
  P: PInfoHintDocumentFormCommand;
begin
  for i:=0 to ListHintDocumentFormCommand.Count-1 do begin
    P:=ListHintDocumentFormCommand.Items[i];
    Dispose(P);
  end;
  ListHintDocumentFormCommand.Clear;
end;

procedure AddToListHintDocumentFormCommand(AHint: String; ACommand: TDocumentFormCommand);
var
  P: PInfoHintDocumentFormCommand;
begin
  New(P);
  P.Hint:=AHint;
  P.Command:=ACommand;
  ListHintDocumentFormCommand.Add(P);
end;

function GetHintDocumentFormCommand(ACommand: TDocumentFormCommand; Default: string=''):String;
var
  i: Integer;
  P: PInfoHintDocumentFormCommand;
begin
  Result:=Default;
  for i:=0 to ListHintDocumentFormCommand.Count-1 do begin
   P:=ListHintDocumentFormCommand.Items[i];
   if P.Command=ACommand then begin
     Result:=P.Hint;
     exit;
   end;
  end;
end;

function GetHintWithShortCutFromDocumentFormCommand(DFSB: TDocumentFormScrollBox;
             ACommand: TDocumentFormCommand; Default: string):String;
var
  AList: TList;
  tmps: string;
  P: PDocumentFormKeyboard;
  i: Integer;
begin
  Result:=Default;
  if DFSB=nil then exit;
  AList:=TList.Create;
  try
    DFSB.DocumentFormListKeyboard.GetDocumentFormKeyboardFromCommand(ACommand,AList);
    for i:=0 to AList.Count-1 do begin
      P:=AList.Items[i];
      if i=0 then tmps:=ShortCutToText(ShortCut(P.Key,P.Shift))
      else tmps:=tmps+', '+ShortCutToText(ShortCut(P.Key,P.Shift));
    end;
    if Trim(tmps)<>'' then
      Result:=GetHintDocumentFormCommand(ACommand,Default)+' ('+tmps+')';
  finally
    AList.Free;
  end;
end;

function GetShortCutFromDocumentFormCommand(DFSB: TDocumentFormScrollBox; ACommand: TDocumentFormCommand): TShortCut;
var
  AList: TList;
  P: PDocumentFormKeyboard;
  i: Integer;
begin
  Result:=0;
  if DFSB=nil then exit;
  AList:=TList.Create;
  try
    DFSB.DocumentFormListKeyboard.GetDocumentFormKeyboardFromCommand(ACommand,AList);
    for i:=0 to AList.Count-1 do begin
      P:=AList.Items[i];
      Result:=ShortCut(P.Key,P.Shift);
      exit;
    end;
  finally
    AList.Free;
  end;
end;


initialization
  ListHintDocumentFormCommand:=TList.Create;
  AddToListHintDocumentFormCommand(ConstdfcNewDocument,dfcNewDocument);
  AddToListHintDocumentFormCommand(ConstdfcOpenDocument,dfcOpenDocument);
  AddToListHintDocumentFormCommand(ConstdfcSaveDocument,dfcSaveDocument);

finalization
  ClearListHintDocumentFormCommand;
  ListHintDocumentFormCommand.Free;


end.
