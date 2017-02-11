unit tsvComCtrls;

interface

uses Windows, Messages, Classes, Controls, Graphics, ComCtrls;

type
  TNewDateTimePicker=class(ComCtrls.TDateTimePicker)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TDateTimePicker=class(TNewDateTimePicker)
  end;

  TTSVCustomTreeView=class(TCustomTreeView)
  public
    property Items;
  end;

  TNewRichEdit=class(ComCtrls.TRichEdit)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TRichEdit=class(TNewRichEdit)
  end;

   
implementation

uses UMainUnited, stdctrls;

{ TNewDateTimePicker }

procedure TNewDateTimePicker.CMEnter(var Message: TCMEnter);
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

procedure TNewDateTimePicker.CMExit(var Message: TCMExit);
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

{ TNewRichEdit }

procedure TNewRichEdit.CMEnter(var Message: TCMEnter);
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

procedure TNewRichEdit.CMExit(var Message: TCMExit);
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

end.
