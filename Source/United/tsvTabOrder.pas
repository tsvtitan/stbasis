unit tsvTabOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CheckLst;

type
  TfmTabOrder = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    pnTabOrder: TPanel;
    gbTabOrder: TGroupBox;
    pnList: TPanel;
    pnListR: TPanel;
    btUp: TBitBtn;
    btDown: TBitBtn;
    Panel1: TPanel;
    clbList: TCheckListBox;
    Panel4: TPanel;
    procedure btUpClick(Sender: TObject);
    procedure btDownClick(Sender: TObject);
    procedure clbListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clbListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure clbListEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure clbListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clbListClick(Sender: TObject);
  private
    ptCur: TPoint;
    function GetSelectedIndex: Integer;
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    procedure InitTabOrder(wt: TWinControl);
    procedure BackUpTabOrder;
  end;

implementation

{$R *.DFM}

uses UMainUnited;

const
  fmtControlString='%s';
  fmtControlStringWithHint='%s (%s)';

type
  THackControl=class(TControl)
  end;

procedure TfmTabOrder.InitTabOrder(wt: TWinControl);

  function GetStr(ct: TWinControl): string;
  var
    lb: TLabel;
  begin
    lb:=GetLabelByWinControl(ct);
    if lb<>nil then begin
      if Trim(ct.Hint)<>'' then
        Result:=Format(fmtControlStringWithHint,[iff(Trim(lb.Caption)<>'',lb.Caption,'пустой заголовок'),ct.Hint])
      else
        Result:=Format(fmtControlString,[iff(Trim(lb.Caption)<>'',lb.Caption,'пустой заголовок')]);
    end else begin
      if Trim(ct.Hint)<>'' then
        Result:=Format(fmtControlStringWithHint,[iff(Trim(THackControl(ct).Caption)<>'',THackControl(ct).Caption,'без заголовка'),ct.Hint])
      else
        Result:=Format(fmtControlString,[iff(Trim(THackControl(ct).Caption)<>'',THackControl(ct).Caption,'без заголовка')]);
    end;
  end;
  
var
  List: TList;
  i: Integer;
  ct: TControl;
  str: string;
  newi: Integer;
begin
  List:=TList.Create;
  try
    wt.GetTabOrderList(List);
    clbList.Items.Clear;
    newi:=0;
    for i:=0 to List.Count-1 do begin
      ct:=List.Items[i];
      if (Trim(ct.Name)<>'')and
         (ct is TWinControl) and
//         (ct.CanFocus)and
         (not (csAcceptsControls in ct.ControlStyle)) then begin
        str:=GetStr(TWinControl(ct));
        clbList.Items.AddObject(str,ct);
        clbList.Checked[newi]:=TWinControl(ct).TabStop;
        clbList.ItemEnabled[newi]:=TWinControl(ct).Visible;
        inc(newi);
      end;
    end;
    if clbList.Items.Count<>0 then
     clbList.ItemIndex:=0;
  finally
   List.Free;
  end;
end;

function TfmTabOrder.GetSelectedIndex: Integer;
var
  I: Integer;
begin
 result:=-1;
  for i:=0 to clbList.Items.Count-1 do begin
    if clbList.Selected[i] then begin
      Result:=i;
      exit;
    end;
  end;
end;

procedure TfmTabOrder.btUpClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if Index>0 then begin
   clbList.Items.Move(Index,Index-1);
   clbList.ItemIndex:=Index-1;
  end;
  clbList.SetFocus;
end;

procedure TfmTabOrder.btDownClick(Sender: TObject);
var
  Index: Integer;
begin
  Index:=GetSelectedIndex;
  if (Index<>-1)and(Index<>clbList.Items.Count-1) then begin
   clbList.Items.Move(Index,Index+1);
   clbList.ItemIndex:=Index+1;
  end;
  clbList.SetFocus;
end;

procedure TfmTabOrder.BackUpTabOrder;
var
  i: Integer;
  ct: TControl;
begin
    for i:=0 to clbList.Items.Count-1 do begin
     ct:=TControl(clbList.Items.Objects[i]);
     if ct is TWinControl then begin
       TWinControl(ct).TabOrder:=i;
       TWinControl(ct).TabStop:=clbList.Checked[i];
     end;
    end;
end;

procedure TfmTabOrder.clbListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  tmps: string;
  x,y: Integer;
begin
  with clbList.Canvas do begin
    Brush.Style:=bsSolid;
    Brush.Color:=clWindow;
    Pen.Style:=psClear;
    FillRect(rect);
    tmps:=clbList.Items.Strings[Index];
    if State=[odSelected,odFocused] then begin
      Brush.Style:=bsSolid;
      Brush.Color:=clHighlight;
      Font.Color:=clHighlightText;
  //    FillRect(rect);
      Brush.Style:=bsClear;
      x:=rect.Left+2;
      y:=rect.Top;
      TextOut(x,y,tmps);
    end else begin
      Brush.Style:=bsSolid;
      Brush.Color:=clWindow;
      Font.Color:=clWindowText;
//      FillRect(rect);
      if PtInRect(rect,ptCur) then begin
       DrawFocusRect(rect);
      end;
      Brush.Style:=bsClear;
      x:=rect.Left+2;
      y:=rect.Top;
      TextOut(x,y,tmps);
    end;
  end;
end;

procedure TfmTabOrder.clbListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  val: Integer;
begin
   if (Shift=[ssLeft]) then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val=clbList.ItemIndex then begin
       clbList.BeginDrag(true);
     end;
    end;
   end;
end;

procedure TfmTabOrder.clbListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  val: Integer;
begin
  Accept:=false;
  if Sender=Source then begin
    val:=clbList.ItemAtPos(Point(X,Y),true);
    if val<>-1 then begin
     if val<>clbList.ItemIndex then begin
       ptCur:=Point(X,Y);
       Accept:=true;
     end;
    end;
  end;
end;

procedure TfmTabOrder.clbListEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  exit;
  val:=clbList.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    clbList.Items.Move(clbList.ItemIndex,val);
    clbList.ItemIndex:=val;
  end;
end;

procedure TfmTabOrder.clbListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
 val: Integer;
begin
  val:=clbList.ItemAtPos(Point(X,Y),true);
  if val<>-1 then begin
    if val<>clbList.ItemIndex then begin
     if clbList.ItemIndex=-1 then exit;
     clbList.Items.Move(clbList.ItemIndex,val);
     clbList.ItemIndex:=val;
    end;
  end;
end;

procedure TfmTabOrder.FormShow(Sender: TObject);
begin
  clbList.SetFocus;
end;

procedure TfmTabOrder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Hint:='';
end;

procedure TfmTabOrder.LoadFromIni;
begin
  Left:=ReadParam(ClassName,'Left',Left);
  Top:=ReadParam(ClassName,'Top',Top);
  Height:=ReadParam(ClassName,'Height',Height);
  Width:=ReadParam(ClassName,'Width',Width);
end;

procedure TfmTabOrder.SaveToIni;
begin
  WriteParam(ClassName,'Left',Left);
  WriteParam(ClassName,'Top',Top);
  WriteParam(ClassName,'Height',Height);
  WriteParam(ClassName,'Width',Width);
end;

procedure TfmTabOrder.FormCreate(Sender: TObject);
begin
  Left:=Screen.width div 2-Width div 2;
  Top:=Screen.Height div 2-Height div 2;

  LoadFromIni;
end;

procedure TfmTabOrder.FormDestroy(Sender: TObject);
begin
  SaveToIni;
end;

procedure TfmTabOrder.clbListClick(Sender: TObject);
{var
  ct: TWinControl;}
begin
  if clbList.ItemIndex<>-1 then begin
 {   ct:=TWinControl(clbList.Items.Objects[clbList.ItemIndex]);
    if LastControl<>nil then begin
      if ct.CanFocus then begin
        ct.Perform(CM_EXIT,0,0);
      end;
    end;
    if ct.CanFocus then begin
      ct.Perform(CM_ENTER,0,0);
    end;
    LastControl:=ct; }
  end;
end;

end.
