unit Main;
{ модуль разработан ФИО }

procedure ViewInterface;
begin
  fm.iButton1.OnClick:=OnClick;
end;

procedure OnClick;
var
  i: Integer;
begin
  for i:=0 to 100 do begin
    fm.iLabel1.Caption:=i;
    CreateLogItem(i,tliError);
  end;
end;

end.
