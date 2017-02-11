unit Main;
{ модуль разработан ФИО }

procedure ViewInterface;
begin
//  DesignForm.OnDblClick:=DesignFormOnClick;
//  DesignForm.OnHelp:=DesignFormHelp;
//  DesignForm.iButton1.OnMouseMove:=DesignFormiButton1MouseMove;
  DesignForm.OnKeyDown:=DesignFormKeyDown;
end;

procedure DesignFormOnClick(Sender: TObject);
begin
 ShowInfoEx('Test');
end;

function DesignFormHelp(Command: Word;  Data: Integer; var CallHelp: Boolean): Boolean;
begin
 ShowInfoEx('Help');
 CallHelp:=true;
end;

procedure DesignFormiButton1MouseMove(Sender: TObject;  Shift: TShiftState;  X: Integer; Y: Integer);
var
  x1,y1: string;
begin
  x1:=X;
  y1:=Y;
  DesignForm.iLabel1.Caption:='X:'+X+' - Y:'+Y;
end;

procedure DesignFormKeyDown(Sender: TObject; var Key: Word; var Shift: TShiftState);
begin
  with DesignForm do begin

  end;
end;

end.
