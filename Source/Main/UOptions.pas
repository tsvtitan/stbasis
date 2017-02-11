unit UOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, ImgList;

type
  TfmOptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btOk: TButton;
    btCancel: TButton;
    pnPage: TPanel;
    pnTopStatus: TPanel;
    lbTopStatus: TLabel;
    pg: TPageControl;
    ilTV: TImageList;
    spl: TSplitter;
    pnTV: TPanel;
    TV: TTreeView;
    procedure TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure btOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
//    procedure GenerateTreeView;
{    procedure BeforeSetOptions;
    procedure AfterSetOptions(isOK: Boolean);
    function CheckOptions: Boolean;}
//    procedure ViewFromPointer(P: Pointer);
    procedure ViewNode(Node: TTreeNode);
  end;

  TDefaultTabSheet=class(TTabSheet)
  private
    FLabelNone: TLabel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmOptions: TfmOptions;

implementation

uses UMainData, UMainUnited, UMainCode, UMain;

{$R *.DFM}

{ TDefaultTabSheet }

constructor TDefaultTabSheet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabelNone:=TLabel.Create(Self);
  FLabelNone.Parent:=Self;
  FLabelNone.Align:=alClient;
  FLabelNone.Alignment:=taCenter;
  FLabelNone.Layout:=tlCenter;
  FLabelNone.Caption:='Настройки данного пункта недоступны';
end;

destructor TDefaultTabSheet.Destroy;
begin
  FLabelNone.Free;
  inherited Destroy;
end;

type

   TFillDirection=(fdLR,fdRL,fdTB,fdBT);

   TGradientLabel=class(TCustomLabel)
   private
     FFromColor: TColor;
     FToColor: TColor;
     FColorCount: Integer;
     procedure FillGradientRect(canvas: tcanvas; Recty: trect;
                                fbcolor, fecolor: tcolor; fcolors:
                                Integer; fdirect: TFillDirection);
   public
     procedure Paint; override;
     property FromColor: TColor read FFromColor write FFromColor;
     property ToColor: TColor read FToColor write FToColor;
     property ColorCount: Integer read FColorCount write FColorCount;
   end;


procedure TfmOptions.TVAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
{var
  rt: Trect;}
begin
{  if GetFocus<>tv.Handle then begin
    if Node=Tv.Selected then begin
      tv.Canvas.Brush.Style:=bsSolid;
      tv.Canvas.Brush.Color:=clBtnFace;
      rt:=Node.DisplayRect(true);
      tv.Canvas.FillRect(rt);
      tv.Canvas.Brush.Style:=bsClear;
      tv.Canvas.TextOut(rt.Left+2,rt.top+1,node.text);
 //     tv.Canvas.DrawFocusRect(rt);
//      DefaultDraw:=false;
    end else begin
     DefaultDraw:=true;
    end;
  end else DefaultDraw:=true;  }
end;

(*function TfmOptions.CheckOptions: Boolean;
var
  CheckFail: Boolean;

   procedure CheckOptionsLocal(List: TList);
   var
     i: Integer;
     P: PInfoOption;
   begin
     if CheckFail then exit;
     for i:=List.Count-1 downto 0 do begin
       P:=List.Items[i];
       if isValidPointer(@P.CheckOptionProc) then begin
         P.CheckOptionProc(THandle(P),CheckFail);
         if CheckFail then begin
           exit;
         end;
       end;
       CheckOptionsLocal(P.List);
     end;
   end;

begin
 CheckFail:=false;
 Result:=false;
 try
   CheckOptionsLocal(ListOptions);
   Result:=not CheckFail;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;*)

procedure TfmOptions.btOkClick(Sender: TObject);
begin
  if Not CheckOptions_ then exit;
  ModalResult:=mrOk;
end;

procedure TfmOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MainFormKeyDown_(Key,Shift);
end;

procedure TfmOptions.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MainFormKeyUp_(Key,Shift);
end;

procedure TfmOptions.FormKeyPress(Sender: TObject; var Key: Char);
begin
  MainFormKeyPress_(Key);
end;

procedure TfmOptions.TVChange(Sender: TObject; Node: TTreeNode);
begin
  ViewNode(Tv.Selected);
end;

(*procedure TfmOptions.GenerateTreeView;

  function FindNode(Level: Integer; NodeCaption: String): TTreeNode;
  var
    i: Integer;
    nd: TTreeNode; 
  begin
    Result:=nil;
    for i:=0 to Tv.Items.Count-1 do begin
      nd:=Tv.Items[i];
      if nd.Level=Level then begin
       if nd.Text=NodeCaption then begin
        Result:=nd;
        exit;
       end;
      end; 
    end;
  end;
  
  procedure FillTreeView(ndParent: TTReeNode; List: TList; Level: Integer);
  var
    i: Integer;
    P: PInfoOption;
    ndNew: TTreeNode;
    tbs: TTabSheet;
    AndMask: TBitmap;
    cur: Integer;
  begin
    if not isValidPointer(List) then exit;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P<>nil then begin
        ndNew:=FindNode(Level,P.Name);
        if ndNew=nil then begin
         ndNew:=Tv.Items.AddChildObject(ndParent,P.Name,P);
         if isValidPointer(P.Bitmap) then begin
          AndMask:=TBitmap.Create;
          try
           CopyBitmap(P.Bitmap,AndMask);
           AndMask.Mask(AndMask.Canvas.Pixels[0,0]);
           cur:=ilTv.Add(P.Bitmap,AndMask);
           ndNew.ImageIndex:=cur;
           ndNew.SelectedIndex:=cur;
          finally
           AndMask.Free;
          end;
         end;

         tbs:=TTabSheet.Create(nil);
         tbs.PageControl:=pg;
         tbs.TabVisible:=false;
//         P.ParentWindow:=tbs.Handle;
        end;
        FillTreeView(ndNew,P.List,Level+1);
      end;
    end;
  end;

  procedure ClearImageList;
  var
    i: Integer;
  begin
    for i:=ilTV.Count-1 downto 3 do begin
      ilTV.Delete(i);
    end;
  end;


var
 i: Integer;
 P: PInfoLib;
begin
(* try
  TV.Items.BeginUpdate;
  try
   TV.Items.Clear;
   ClearPageControl;
   ClearImageList;
   FillTreeView(nil,ListOptionsRoot,0);
   for i:=0 to ListLibs.Count-1 do begin
    P:=ListLibs.Items[i];
    if P.Active then
     if isValidPointer(@P.GetListOptionsRoot) then
      FillTreeView(nil,P.GetListOptionsRoot,0);
   end;
  finally
   SetImageToTreeNodes(TV);
   OpenFirstLevelOnTreeView(TV);
   if Tv.Items.Count>0 then
    ViewNode(Tv.Items[0]);
   TV.Items.EndUpdate;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do if isAppLoaded then Assert(false,E.message); {$ENDIF}
 end;
end; *)

procedure TfmOptions.ViewNode(Node: TTreeNode);
var
  P: PInfoOption;
begin
  if Node=nil then exit;
  Node.MakeVisible;
  Node.Selected:=true;
  p:=Node.Data;
  if not isValidPointer(p) then exit;
  if P.TabSheet=nil then exit;
{  lbTopStatus.Caption:=Node.Text
                       +' '+inttostr(Node.ImageIndex)
                       +' '+inttostr(Node.SelectedIndex)
                       +' '+inttostr(Node.StateIndex);}
  lbTopStatus.Caption:=Node.Text;
  pg.ActivePage:=P.TabSheet;
end;

(*procedure TfmOptions.BeforeSetOptions;

   procedure BeforeSetOptionsLocal(List: TList);
   var
     i: Integer;
     P: PInfoOption;
   begin
     for i:=List.Count-1 downto 0 do begin
       P:=List.Items[i];
       if isValidPointer(@P.BeforeSetOptionProc) then begin
         P.BeforeSetOptionProc(THandle(P));
       end;
       BeforeSetOptionsLocal(P.List);
     end;
   end;
   
var
 oldFlag: dWord;
begin
 try
  AssignFont(_GetOptions.FormFont,Font);
  Screen.Cursor:=crHourGlass;
  oldFlag:=GetThreadPriority(GetCurrentThread);
  //SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_HIGHEST);
  try
    BeforeSetOptionsLocal(ListOptions);
  finally
//    HandleNeededToWinControl(pg);
    SetThreadPriority(GetCurrentThread,oldFlag);
    Screen.Cursor:=crDefault;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOptions.AfterSetOptions(isOK: Boolean);

   procedure AfterSetOptionsLocal(List: TList);
   var
     i: Integer;
     P: PInfoOption;
   begin
     for i:=List.Count-1 downto 0 do begin
       P:=List.Items[i];
       if isValidPointer(@P.AfterSetOptionProc) then begin
         P.AfterSetOptionProc(THandle(P),isOk);
       end;
       AfterSetOptionsLocal(P.List);
     end;
   end;

var
 oldFlag: dWord;
begin
 try
  oldFlag:=GetThreadPriority(GetCurrentThread);
  try
   AfterSetOptionsLocal(ListOptions);
   if isRefreshEntyes then begin
    // RefreshFromBase;
     isRefreshEntyes:=false;
   end;
  finally
    SetThreadPriority(GetCurrentThread,oldFlag);
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;*)

procedure TfmOptions.Button1Click(Sender: TObject);
var
  i: Integer;
  tbs: TTabSheet;
//  rt: TRect;

begin
  for i:=0 to pg.PageCount-1 do begin
    tbs:=pg.Pages[i];
    SendMessage(tbs.Handle,CM_INVALIDATE,0,0);
{    rt:=tbs.ClientRect;
    InvalidateRect(tbs.handle,@rt,true);}
    

  end;
end;

{procedure TfmOptions.ViewFromPointer(P: Pointer);
var
  i: Integer;
  nd: TTreeNode;
begin
  if not isValidPointer(P) then exit;
  for i:=0 to TV.Items.Count-1 do begin
    nd:=TV.Items[i];
    if nd.Data=P then begin
      ViewNode(nd);
      exit;
    end;
  end;
end;}

procedure TfmOptions.FormCreate(Sender: TObject);
var
  lb: TGradientLabel;
begin
  AssignFont(_GetOptions.FormFont,Font);
  lb:=TGradientLabel.Create(nil);
  lb.Parent:=lbTopStatus.Parent;
  lb.Align:=lbTopStatus.Align;
  lb.Font.Assign(lbTopStatus.Font);
  lb.FromColor:=clBtnShadow;
  lb.ToColor:=clBtnFace;
  lb.ColorCount:=256;
  lbTopStatus.Free;
  lb.Name:='lbTopStatus';
  lbTopStatus:=TLabel(lb);
end;

{ TGradientLabel }

procedure TGradientLabel.FillGradientRect(canvas: tcanvas; Recty: trect;
                                          fbcolor, fecolor: tcolor; fcolors: Integer; fdirect: TFillDirection);
var
  i, j, h, w: Integer;
  R, G, B: Longword;
  beginRGBvalue, RGBdifference: array[0..2] of Longword;
begin
  beginRGBvalue[0] := GetRvalue(colortoRGB(FBcolor));
  beginRGBvalue[1] := GetGvalue(colortoRGB(FBcolor));
  beginRGBvalue[2] := GetBvalue(colortoRGB(FBcolor));

  RGBdifference[0] := GetRvalue(colortoRGB(FEcolor)) - beginRGBvalue[0];
  RGBdifference[1] := GetGvalue(colortoRGB(FEcolor)) - beginRGBvalue[1];
  RGBdifference[2] := GetBvalue(colortoRGB(FEcolor)) - beginRGBvalue[2];

  canvas.pen.style := pssolid;
  canvas.pen.mode := pmcopy;

  j := 0;
  h := recty.bottom - recty.top;
  w := recty.right - recty.left;
  R:=0;
  G:=0;
  B:=0;

  case fdirect of
    fdRL: begin

     for i := fcolors downto 0 do begin
      recty.left  := muldiv(i - 1, w, fcolors);
      recty.right := muldiv(i, w, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, Recty.right - recty.left, h, patcopy);
      inc(j);
     end;
    end;
    fdLR: begin

     for i :=0 to fcolors do begin
      recty.left  := muldiv(i-1 , w, fcolors);
      recty.right := muldiv(i , w, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, Recty.right - recty.left, h, patcopy);
      inc(j);
     end;
    end;
    fdTB: begin

     for i :=0 to fcolors do begin
      recty.Top  := muldiv(i-1 , h, fcolors);
      recty.Bottom := muldiv(i , h, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, w,Recty.Bottom - recty.top, patcopy);
      inc(j);
     end;

    end;
    fdBT: begin

     for i :=fcolors downto 0 do begin
      recty.Top  := muldiv(i-1 , h, fcolors);
      recty.Bottom := muldiv(i , h, fcolors);
      if fcolors>1 then begin
        R := beginRGBvalue[0] + LongWord(muldiv(j, RGBDifference[0], fcolors));
        G := beginRGBvalue[1] + LongWord(muldiv(j, RGBDifference[1], fcolors));
        B := beginRGBvalue[2] + LongWord(muldiv(j, RGBDifference[2], fcolors));
      end;
      canvas.brush.color := RGB(R, G, B);
      patBlt(canvas.handle, recty.left, recty.top, w,Recty.Bottom - recty.top, patcopy);
      inc(j);
     end;

    end;
  end;
end;


procedure TGradientLabel.Paint;

   function GetShortString(w: integer; str,text: string): string;
   var
     i: Integer;
     tmps: string;
     neww: Integer;
   begin
    result:=text;
    for i:=1 to Length(text) do begin
      tmps:=tmps+text[i];
      neww:=Canvas.TextWidth(tmps+str);
      if neww>=(w-Canvas.TextWidth(str)) then begin
       result:=tmps+str;
       exit;
      end;
    end;
   end;

var
  Rect: TRect;
  Flags: Longint;
  wd: Integer;
  NewText: string;
begin
  FillGradientRect(Canvas,GetClientRect,FFromColor, FToColor ,FColorCount,fdTB);
  with Canvas do begin
    Canvas.Font := Self.Font;
    Brush.Style := bsClear;
    Rect := ClientRect;
    Flags:=DT_SINGLELINE or DT_VCENTER;
    Rect.Left:=Rect.Left+3;
    NewText:=Text;
    wd:=TextWidth(NewText);
    if wd>(Width-3) then NewText:=GetShortString(Width-3,'...',NewText);
    DrawText(Canvas.Handle, PChar(NewText), Length(NewText), Rect, Flags);
  end;
end;

end.
