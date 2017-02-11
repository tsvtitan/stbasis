unit tsvStdCtrls;

interface

uses Windows, Messages, Classes, Controls, Graphics, StdCtrls;

type

  TNewEdit=class(StdCtrls.TEdit)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TEdit=class(TNewEdit)
  end;

  TNewMemo=class(StdCtrls.TMemo)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TMemo=class(TNewMemo)
  end;

  TNewListBox=class(StdCtrls.TListBox)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TListBox=class(TNewListBox)
  end;

  TNewComboBox=class(StdCtrls.TComboBox)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    FCurrentIndex: Integer;
    FEnabledDown: Boolean;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    function FindNextControl(CurControl: TWinControl; GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
    procedure SelectNext(CurControl: TWinControl; GoForward, CheckTabStop: Boolean);
  protected
    procedure DoEnter; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  published
    property EnabledDown: Boolean read FEnabledDown write FEnabledDown;
  end;

  TComboBox=class(TNewComboBox)
  end;


implementation

uses UMainUnited, SysUtils, Forms;

{ TNewEdit }

procedure TNewEdit.CMEnter(var Message: TCMEnter);
var
  lb: TLabel;
begin
  FOldColor:=Color;
  Color:=iff(Color<>clBtnFace,_GetOptions.ElementFocusColor,Color);
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    FOldLabelColor:=lb.Font.Color;
    lb.Font.Color:=_GetOptions.ElementLabelFocusColor;
  end;
  inherited;
end;

procedure TNewEdit.CMExit(var Message: TCMExit);
var
  lb: TLabel;
begin
  inherited;
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    lb.Font.Color:=FOldLabelColor;
  end;
  Color:=FOldColor;
end;

{ TNewMemo }

procedure TNewMemo.CMEnter(var Message: TCMEnter);
var
  lb: TLabel;
begin
  FOldColor:=Color;
  Color:=iff(Color<>clBtnFace,_GetOptions.ElementFocusColor,Color);
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    FOldLabelColor:=lb.Font.Color;
    lb.Font.Color:=_GetOptions.ElementLabelFocusColor;
  end;
  inherited;
end;

procedure TNewMemo.CMExit(var Message: TCMExit);
var
  lb: TLabel;
begin
  inherited;
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    lb.Font.Color:=FOldLabelColor;
  end;
  Color:=FOldColor;
end;

{ TNewListBox }

procedure TNewListBox.CMEnter(var Message: TCMEnter);
var
  lb: TLabel;
begin
  FOldColor:=Color;
  Color:=iff(Color<>clBtnFace,_GetOptions.ElementFocusColor,Color);
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    FOldLabelColor:=lb.Font.Color;
    lb.Font.Color:=_GetOptions.ElementLabelFocusColor;
  end;
  inherited;
end;

procedure TNewListBox.CMExit(var Message: TCMExit);
var
  lb: TLabel;
begin
  inherited;
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    lb.Font.Color:=FOldLabelColor;
  end;
  Color:=FOldColor;
end;

{ TNewComboBox }

procedure TNewComboBox.CMEnter(var Message: TCMEnter);
var
  lb: TLabel;
begin
  FOldColor:=Color;
  Color:=iff(Color<>clBtnFace,_GetOptions.ElementFocusColor,Color);
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    FOldLabelColor:=lb.Font.Color;
    lb.Font.Color:=_GetOptions.ElementLabelFocusColor;
  end;
  inherited;
end;

procedure TNewComboBox.CMExit(var Message: TCMExit);
var
  lb: TLabel;
begin
  inherited;
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    lb.Font.Color:=FOldLabelColor;
  end;
  Color:=FOldColor;
end;

procedure TNewComboBox.DoEnter; 
begin
  if FEnabledDown then
    DroppedDown:=true;
  inherited;
end;

function TNewComboBox.FindNextControl(CurControl: TWinControl;
  GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
var
  I, StartIndex: Integer;
  List: TList;
  Form: TCustomForm;
begin
  Result := nil;
  Form:=GetParentForm(CurControl);
  if not Assigned(Form) then exit;
  List := TList.Create;
  try
    Form.GetTabOrderList(List);
    if List.Count > 0 then
    begin
      StartIndex := List.IndexOf(CurControl);
      if StartIndex = -1 then
        if GoForward then StartIndex := List.Count - 1 else StartIndex := 0;
      I := StartIndex;
      repeat
        if GoForward then
        begin
          Inc(I);
          if I = List.Count then I := 0;
        end else
        begin
          if I = 0 then I := List.Count;
          Dec(I);
        end;
        CurControl := List[I];
        if CurControl.CanFocus and
          (not CheckTabStop or CurControl.TabStop) and
          (not CheckParent or (CurControl.Parent = Self)) then
          Result := CurControl;
      until (Result <> nil) or (I = StartIndex);
    end;
  finally
    List.Free;
  end;
end;

procedure TNewComboBox.SelectNext(CurControl: TWinControl;
  GoForward, CheckTabStop: Boolean);
begin
  CurControl := FindNextControl(CurControl, GoForward,
    CheckTabStop, not CheckTabStop);
  if CurControl <> nil then CurControl.SetFocus;
end;

procedure TNewComboBox.KeyDown(var Key: Word; Shift: TShiftState);

  procedure ClearWord;
  var
    s: string;
  begin
    s:=Copy(Text,1,SelStart);
    ItemIndex:=-1;
    Text:=s;
    SelStart:=Length(s);
    SelLength:=Length(Text)-SelStart;
  end;

begin
  if EnabledDown then begin
    case Key of
      VK_DELETE,VK_BACK: ClearWord;
      VK_TAB: begin
        FCurrentIndex:=ItemIndex;
        if Shift=[] then begin
          SelectNext(TWinControl(Self),true,true)
        end else if Shift=[ssSHIFT] then
          SelectNext(TWinControl(Self),false,true);
        if FCurrentIndex>-1 then
          Text:=Items.Strings[FCurrentIndex]
        else Text:='';
        SendMessage(Handle, CB_SETCURSEL, FCurrentIndex, 0);
        exit;
      end;
      VK_RETURN: begin
        FCurrentIndex:=ItemIndex;
      end;
     else begin
     end;
    end;
  end;  
  inherited;
end;

procedure TNewComboBox.KeyUp(var Key: Word; Shift: TShiftState);

  function GetWordStringIndex(s: string): Integer;
  var
    i: Integer;
    APos: Integer;
  begin
    Result:=-1;
    for i:=0 to Items.Count-1 do begin
      APos:=AnsiPos(AnsiUpperCase(s),AnsiUpperCase(Items.Strings[i]));
      if Apos=1 then begin
        Result:=i;
        exit;
      end;
    end;
  end;

var
  val: Integer;
  s: string;
begin
  if EnabledDown then begin
     case Key of
      VK_DELETE,VK_BACK,VK_TAB,
      VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN:;
      VK_RETURN: begin
        if FCurrentIndex>-1 then
          Text:=Items.Strings[FCurrentIndex]
        else Text:='';
        SendMessage(Handle, CB_SETCURSEL, FCurrentIndex, 0);
      end;
      else begin
       S:=Copy(Text,1,SelStart);
       val:=GetWordStringIndex(S);
       if val<>-1 then begin
         Text:=Items.Strings[val];
         ItemIndex:=val;
         SelStart:=Length(s);
         SelLength:=Length(Text)-SelStart;
       end;
       FCurrentIndex:=val;
      end;
     end;
  end;   
  inherited;
end;

end.
