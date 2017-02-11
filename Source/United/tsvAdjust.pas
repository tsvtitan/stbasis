unit tsvAdjust;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst, dbgrids, comctrls, tsvDbOrder,
  ImgList;

type

  TCheckListBox=class(CheckLst.TCheckListBox)
  private
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
  public
    ImageWidth: Integer;  
  end;

  TComboBox=class(stdctrls.TComboBox)
  public
    ImageWidth: Integer;
  end;


  TfmAdjust = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    fd: TFontDialog;
    pcMain: TPageControl;
    tsColumns: TTabSheet;
    tsDbOrders: TTabSheet;
    pnColumns: TPanel;
    gbColumns: TGroupBox;
    pnListColumns: TPanel;
    pnButColumns: TPanel;
    btUpColumns: TBitBtn;
    btDownColumns: TBitBtn;
    bibCheckAllColumns: TBitBtn;
    bibUnCheckAllColumns: TBitBtn;
    Panel1: TPanel;
    clbListColumns: TCheckListBox;
    pnFontColumns: TPanel;
    lbFont: TLabel;
    edFont: TEdit;
    bibFont: TButton;
    pnDbOrders: TPanel;
    grbDbOrders: TGroupBox;
    pnListDbOrders: TPanel;
    pnButDbOrders: TPanel;
    bibUpDbOrders: TBitBtn;
    bibDownDbOrders: TBitBtn;
    bibCheckAllDbOrders: TBitBtn;
    bibUncheckAllDbOrders: TBitBtn;
    Panel6: TPanel;
    chbDbOrders: TCheckListBox;
    il: TImageList;
    pnDbOrdersBottom: TPanel;
    lbDbOrdersType: TLabel;
    cmbDbOrdersType: TComboBox;
    ButtonColumnsDefault: TButton;
    procedure btUpColumnsClick(Sender: TObject);
    procedure btDownColumnsClick(Sender: TObject);
    procedure clbListColumnsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clbListColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure clbListColumnsClickCheck(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure clbListColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure bibCheckAllColumnsClick(Sender: TObject);
    procedure bibUnCheckAllColumnsClick(Sender: TObject);
    procedure bibFontClick(Sender: TObject);
    procedure clbListColumnsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chbDbOrdersClickCheck(Sender: TObject);
    procedure bibUncheckAllDbOrdersClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure chbDbOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure chbDbOrdersClick(Sender: TObject);
    procedure cmbDbOrdersTypeChange(Sender: TObject);
    procedure ButtonColumnsDefaultClick(Sender: TObject);
  private
    FDbOrders: TtsvDbOrders;
    MaxWidthDbOrders: Integer;
    MaxWidthColumns: Integer;
    Columns: TDBGridColumns;
    DbOrders: TtsvDbOrders;
    DefaultGridColumns: TDBGridColumns;

    ptCur: TPoint;
    function GetSelectedIndex: Integer;
    procedure LoadFromIni;
    procedure SaveToIni;
    function GetCurrentCheckListBox: TCheckListBox;
    procedure EnableFontPanel(isEnable: Boolean);
    procedure EnableTypeOrderPanel(isEnable: Boolean);
    procedure FillColumns;
    procedure SetColumns;
    procedure FillDbOrders;
    procedure SetDbOrders;
  public
  end;

function SetAdjust(Columns: TDBGridColumns; DbOrders: TtsvDbOrders; DefaultGridColumns: TDBGridColumns=nil): Boolean;

implementation

uses UMainUnited, typinfo, grids;

type
  PInfoColumn=^TInfoColumn;
  TInfoColumn=packed record
    cl,clNew: TColumn;
  end;

{$R *.DFM}

procedure TCheckListBox.CNDrawItem(var Message: TWMDrawItem); 
begin
  with Message.DrawItemStruct^ do
    if not UseRightToLeftAlignment then
      rcItem.Left := rcItem.Left + ImageWidth
    else
      rcItem.Right := rcItem.Right - ImageWidth;
  inherited;
end;

type
  TCustomGridHack=class(TCustomGrid)
  public
    property DefaultColWidth;
  end;

function SetAdjust(Columns: TDBGridColumns; DbOrders: TtsvDbOrders; DefaultGridColumns: TDBGridColumns=nil): Boolean;
var
  fm: TfmAdjust;
begin
 result:=false;
 try

  fm:=TfmAdjust.Create(nil);
  try
   fm.LoadFromIni;
   fm.ButtonColumnsDefault.Enabled:=Assigned(DefaultGridColumns);
   fm.Columns:=Columns;
   fm.DbOrders:=DbOrders;
   fm.DefaultGridColumns:=DefaultGridColumns;

   fm.EnableFontPanel(false);
   if Columns<>nil then fm.FillColumns
   else fm.tsColumns.TabVisible:=false;

   fm.EnableTypeOrderPanel(false);
   if DbOrders<>nil then fm.FillDbOrders
   else fm.tsDbOrders.TabVisible:=false;

   if fm.ShowModal=mrOk then begin
     Screen.Cursor:=crHourGlass;
     try
       if Columns<>nil then fm.SetColumns;
       if DbOrders<>nil then fm.SetDbOrders;

       result:=true;
     finally
       Screen.Cursor:=crDefault;
     end;
   end;
   fm.SaveToIni;
  finally
    fm.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmAdjust.FillColumns;
var
  i: Integer;
  cl,clNew: TColumn;
  val: Integer;
  P: PInfoColumn;
  s: string;
begin
  clbListColumns.Clear;
  MaxWidthColumns:=0;
  for i:=0 to Columns.Count-1 do begin
    cl:=Columns[i];
    clNew:=TColumn.Create(nil);
    clNew.Assign(cl);
    clNew.Field:=cl.Field;
    New(P);
    P.cl:=cl;
    P.clNew:=clNew;
    val:=clbListColumns.Items.AddObject(clNew.Title.Caption,TObject(P));
    clbListColumns.Checked[val]:=clNew.Visible;
    s:=clNew.Title.Caption;
    if MaxWidthColumns<clbListColumns.Canvas.TextWidth(s) then
      MaxWidthColumns:=clbListColumns.Canvas.TextWidth(s);
  end;
end;

procedure TfmAdjust.SetColumns;
var
  i: Integer;
  cl,clNew: TColumn;
begin
  for i:=0 to clbListColumns.Items.Count-1 do begin
    clNew:=PInfoColumn(clbListColumns.Items.Objects[i]).clNew;
    cl:=PInfoColumn(clbListColumns.Items.Objects[i]).cl;
    cl.Assign(clNew);
    cl.Index:=i;
    if cl.Visible<>clbListColumns.Checked[i] then begin
      cl.Visible:=clbListColumns.Checked[i];
      cl.Width:=50;
    end;

    clNew.Free;
    Dispose(PInfoColumn(clbListColumns.Items.Objects[i]));
  end;
end;

procedure TfmAdjust.FillDbOrders;
var
  i,val: Integer;
  s: string;
begin
  FDbOrders.Assign(DbOrders);
  MaxWidthDbOrders:=0;
  for i:=0 to FDbOrders.Count-1 do begin
    val:=chbDbOrders.Items.AddObject(FDbOrders.Items[i].Caption,FDbOrders.Items[i]);
    chbDbOrders.Checked[val]:=FDbOrders.Items[i].Enabled;
    s:=FDbOrders.Items[i].Caption;
    if MaxWidthDbOrders<chbDbOrders.Canvas.TextWidth(s) then
      MaxWidthDbOrders:=chbDbOrders.Canvas.TextWidth(s);
  end;
end;

procedure TfmAdjust.SetDbOrders;
var
  i: Integer;
  di: TtsvDbOrderItem;
begin
  for i:=0 to chbDbOrders.Items.Count-1 do begin
    di:=TtsvDbOrderItem(chbDbOrders.Items.Objects[i]);
    di.Index:=i;
    di.Enabled:=chbDbOrders.Checked[i];
  end;
  DbOrders.Assign(FDbOrders);
end;

function TfmAdjust.GetSelectedIndex: Integer;
var
  I: Integer;
  chb: TCheckListBox;
begin
  result:=-1;
  chb:=GetCurrentCheckListBox;
  if chb=nil then exit;
  for i:=0 to chb.Items.Count-1 do begin
    if chb.Selected[i] then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TfmAdjust.btUpColumnsClick(Sender: TObject);
var
  Index: Integer;
  chb: TCheckListBox;
begin
  Index:=GetSelectedIndex;
  chb:=GetCurrentCheckListBox;
  if chb=nil then exit;
  if Index>0 then begin
    chb.Items.Move(Index,Index-1);
    chb.ItemIndex:=Index-1;
  end;
  chb.SetFocus;
end;

procedure TfmAdjust.btDownColumnsClick(Sender: TObject);
var
  Index: Integer;
  chb: TCheckListBox;
begin
  Index:=GetSelectedIndex;
  chb:=GetCurrentCheckListBox;
  if chb=nil then exit;
  if (Index<>-1)and(Index<>chb.Items.Count-1) then begin
    chb.Items.Move(Index,Index+1);
    chb.ItemIndex:=Index+1;
  end;
  chb.SetFocus;
end;

procedure TfmAdjust.clbListColumnsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  val: Integer;
begin
   if (Shift=[ssLeft]) then begin
    val:=TCheckListBox(Sender).ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val=TCheckListBox(Sender).ItemIndex then begin
       TCheckListBox(Sender).BeginDrag(true);
     end;
    end;
   end;
end;

procedure TfmAdjust.clbListColumnsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  val: Integer;
begin
  Accept:=false;
  if Sender=Source then begin
    val:=TCheckListBox(Sender).ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val<>TCheckListBox(Sender).ItemIndex then begin
       ptCur:=Point(X,Y);
       Accept:=true;
     end;
    end;
  end;
end;

procedure TfmAdjust.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyDown(Key,Shift);
end;

procedure TfmAdjust.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPress(Key);
end;

procedure TfmAdjust.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUp(Key,Shift);
end;

procedure TfmAdjust.clbListColumnsClickCheck(Sender: TObject);
var
  i: Integer;
  CheckCount: Integer;
begin
  CheckCount:=0;
  for i:=0 to TCheckListBox(Sender).Items.Count-1 do begin
    if TCheckListBox(Sender).Checked[i] then
     inc(CheckCount);
  end;
  if CheckCount=0 then begin
    if TCheckListBox(Sender).Items.Count<>0 then
      TCheckListBox(Sender).Checked[TCheckListBox(Sender).ItemIndex]:=true;
    exit;
  end;
end;

procedure TfmAdjust.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Hint:='';
end;

procedure TfmAdjust.clbListColumnsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  val:=TCheckListBox(Sender).ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    if val<>TCheckListBox(Sender).ItemIndex then begin
     if TCheckListBox(Sender).ItemIndex=-1 then exit;
     TCheckListBox(Sender).Items.Move(TCheckListBox(Sender).ItemIndex,val);
     TCheckListBox(Sender).ItemIndex:=val;
    end;
  end;
end;

procedure TfmAdjust.LoadFromIni;
begin
 try
    Left:=ReadParam(ClassName,'Left',Left);
    Top:=ReadParam(ClassName,'Top',Top);
    Height:=ReadParam(ClassName,'Height',Height);
    Width:=ReadParam(ClassName,'Width',Width);
    pcMain.ActivePageIndex:=ReadParam(ClassName,'PageIndex',pcMain.ActivePageIndex);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmAdjust.SaveToIni;
begin
 try
    WriteParam(ClassName,'Left',Left);
    WriteParam(ClassName,'Top',Top);
    WriteParam(ClassName,'Height',Height);
    WriteParam(ClassName,'Width',Width);
    WriteParam(ClassName,'PageIndex',pcMain.ActivePageIndex);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmAdjust.FormCreate(Sender: TObject);
begin
  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;

  FDbOrders:=TtsvDbOrders.Create(Self);
  pcMain.ActivePageIndex:=0;


  chbDbOrders.ImageWidth:=0;
  cmbDbOrdersType.ItemIndex:=0;
 // il.BkColor:=clWindow;
end;

procedure TfmAdjust.bibCheckAllColumnsClick(Sender: TObject);
var
  i: Integer;
  chb: TCheckListBox;
begin
  chb:=GetCurrentCheckListBox;
  if chb=nil then exit;
  for i:=0 to chb.Items.Count-1 do
    chb.Checked[i]:=true;
end;

procedure TfmAdjust.bibUnCheckAllColumnsClick(Sender: TObject);
var
  i: Integer;
  onecheck: boolean;
  chb: TCheckListBox;
begin
  onecheck:=false;
  chb:=GetCurrentCheckListBox;
  if chb=nil then exit;
  for i:=0 to chb.Items.Count-1 do begin
   if chb.Checked[i] then begin
     if onecheck then
      chb.Checked[i]:=false
     else
      onecheck:=true;
   end;
  end;    
end;

procedure TfmAdjust.bibFontClick(Sender: TObject);
var
  cl: TColumn;
begin
  fd.Font.Assign(edFont.Font);
  fd.MinFontSize:=edFont.Font.Size;
  fd.MaxFontSize:=edFont.Font.Size;
  if not fd.Execute then exit;
  edFont.Font.Assign(fd.Font);
  edFont.Text:=edFont.Font.Name;
  bibFont.Height:=edFont.Height;
  if clbListColumns.ItemIndex<>-1 then begin
    cl:=PInfoColumn(clbListColumns.Items.Objects[clbListColumns.ItemIndex]).clNew;
    cl.Font.Assign(fd.Font);
  end;
end;

procedure TfmAdjust.clbListColumnsClick(Sender: TObject);
var
  cl: TColumn;
begin
  if clbListColumns.ItemIndex<>-1 then begin
    cl:=PInfoColumn(clbListColumns.Items.Objects[clbListColumns.ItemIndex]).clNew;
    edFont.Font.Assign(cl.Font);
    edFont.Text:=edFont.Font.Name;
    EnableFontPanel(true);
  end else begin
    EnableFontPanel(false);
  end;
end;

procedure TfmAdjust.EnableFontPanel(isEnable: Boolean);
begin
  lbFont.Enabled:=isEnable;
  edFont.Enabled:=isEnable;
  edFont.Color:=iff(isEnable,clWindow,clBtnFace);
  bibFont.Enabled:=isEnable;
end;

procedure TfmAdjust.FormDestroy(Sender: TObject);
begin
  FDbOrders.Free;
end;

function TfmAdjust.GetCurrentCheckListBox: TCheckListBox;
begin
  Result:=nil;
  if pcMain.ActivePage=tsColumns then Result:=clbListColumns;
  if pcMain.ActivePage=tsDbOrders then Result:=chbDbOrders;
end;

procedure TfmAdjust.chbDbOrdersClickCheck(Sender: TObject);
begin
  if chbDbOrders.ItemIndex=-1 then exit;
  FDbOrders.Items[chbDbOrders.ItemIndex].Enabled:=chbDbOrders.Checked[chbDbOrders.ItemIndex];
end;

procedure TfmAdjust.bibUncheckAllDbOrdersClick(Sender: TObject);
var
  i: Integer;
  chb: TCheckListBox;
begin
  chb:=GetCurrentCheckListBox;
  if chb=nil then exit;
  for i:=0 to chb.Items.Count-1 do begin
   if chb.Checked[i] then begin
     chb.Checked[i]:=false
   end;
  end;
end;

procedure TfmAdjust.FormResize(Sender: TObject);
begin
  SendMessage(clbListColumns.Handle, LB_SETHORIZONTALEXTENT, MaxWidthColumns+clbListColumns.GetCheckWidth+2, 0);
  clbListColumns.Invalidate;
  SendMessage(chbDbOrders.Handle, LB_SETHORIZONTALEXTENT, MaxWidthDbOrders+chbDbOrders.GetCheckWidth+Il.Width+3, 0);
  chbDbOrders.Invalidate;
end;

procedure TfmAdjust.chbDbOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  di: TtsvDbOrderItem;
  ImageIndex: Integer;
  X,Y: Integer;
  s: string;
  b: TBitmap;
  Canvas: TCanvas;
  TypeOrder: TTypeDbOrder;
begin
  if Control=chbDbOrders then begin
    di:=TtsvDbOrderItem(chbDbOrders.Items.Objects[Index]);
    TypeOrder:=di.TypeOrder;
    Canvas:=chbDbOrders.Canvas;
    s:=chbDbOrders.Items.Strings[Index];
  end else begin
    TypeOrder:=TTypeDbOrder(Index);
    Canvas:=cmbDbOrdersType.Canvas;
    s:=cmbDbOrdersType.Items.Strings[Index];
  end;

  if TypeOrder in [tdboNone..tdboDesc] then begin
    b:=TBitmap.Create;
    try
      Canvas.FillRect(Rect);
      b.Width:=Il.Width;
      b.Height:=Il.Height;
      X:=Rect.Left;
      Y:=Rect.Top+((Rect.Bottom-Rect.Top) div 2) -(Il.Height div 2);
      if odSelected in State then begin
        ImageIndex:=Integer(TypeOrder);
      end else begin
        ImageIndex:=Integer(TypeOrder);
      end;
      Il.GetBitmap(ImageIndex,b);
      b.TransparentColor:=clWhite;
      b.Transparent:=true;
      Canvas.Draw(X,Y,b);
      if Control=chbDbOrders then
       Y:=Rect.Top+((Rect.Bottom-Rect.Top) div 2) -(Canvas.TextHeight(s) div 2)
      else Y:=Rect.Top+((Rect.Bottom-Rect.Top) div 2) -(Canvas.TextHeight(s) div 2)-1;
      X:=X+Il.Width+1;
      Canvas.TextOut(X,Y,s);
    finally
      b.Free;
    end;
  end;
end;

procedure TfmAdjust.EnableTypeOrderPanel(isEnable: Boolean);
begin
  lbDbOrdersType.Enabled:=isEnable;
  cmbDbOrdersType.Enabled:=isEnable;
  cmbDbOrdersType.Color:=iff(isEnable,clWindow,clBtnFace);
end;

procedure TfmAdjust.chbDbOrdersClick(Sender: TObject);
var
  di: TtsvDbOrderItem;
begin
  if chbDbOrders.ItemIndex<>-1 then begin
    di:=TtsvDbOrderItem(chbDbOrders.Items.Objects[chbDbOrders.ItemIndex]);
    cmbDbOrdersType.ItemIndex:=Integer(di.TypeOrder);
    EnableTypeOrderPanel(true);
  end else begin
    EnableTypeOrderPanel(false);
  end;
end;

procedure TfmAdjust.cmbDbOrdersTypeChange(Sender: TObject);
var
  di: TtsvDbOrderItem;
begin
  if chbDbOrders.ItemIndex=-1 then exit;
  if cmbDbOrdersType.ItemIndex<>-1 then begin
    di:=TtsvDbOrderItem(chbDbOrders.Items.Objects[chbDbOrders.ItemIndex]);
    di.TypeOrder:=TTypedbOrder(cmbDbOrdersType.ItemIndex);
    chbDbOrders.Invalidate;
  end;
end;

procedure TfmAdjust.ButtonColumnsDefaultClick(Sender: TObject);
begin
  Columns.Assign(DefaultGridColumns);
  FillColumns;
end;

end.
