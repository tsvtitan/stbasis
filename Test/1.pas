unit Main;
{ модуль разработан ФИО }

procedure ViewInterface;
var
  ct: TObject;
begin
  ct:=TObject.Create(nil);
  try

  finally
    ct.Free;
  end;
end;

end.
