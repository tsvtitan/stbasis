unit Main;
{ модуль разработан ФИО }

procedure ViewInterface;
begin
  fm.iIBQuery1.Database:=MaindataBase;
  fm.iIBTransaction1.DefaultDatabase:=fm.iIBQuery1.Database;
  fm.iIBQuery1.Active:=true;
  ReturnInterface.ReturnData:=fm.iIBQuery1;
end;

end.
