unit Main;
{ модуль разработан ФИО }
interface
procedure fmbtShowClick(Sender: TObject);

implementation

procedure ViewInterface;
begin
  fm.qrConst.Database:=MainDataBase;
  fm.FormStyle:=fsMDIChild;
end;

procedure fmbtShowClick(Sender: TObject);
begin
  fm.rpt.ShowReport;
end;

end.
