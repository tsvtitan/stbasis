unit Main;
{ модуль разработан ФИО }

procedure ViewInterface;
begin
  if fm1.FormStyle<>fsMdiChild then begin
    fm1.ifrReport1.ShowReport;
    fm1.FormStyle:=fsMdiChild;
    ShowInfoEx('First');
  end else begin
    fm1.iIBQuery1.Active:=false;
    fm1.iIBQuery1.Active:=true;
    fm1.ifrReport1.ShowReport;
    fm1.BringToFront;
    ShowInfoEx('Last');
  end;
end;

end.
