unit Main;
{ модуль разработан ФИО }

procedure ViewInterface;
var
  RBook: TObjectRBookInterface;
begin
  fm.iButton1.OnClick:=EmptyFormiButton1Click;
 { RBook:=TObjectRBookInterface.Create(nil);
  try
   RBook.Visual.TypeView:=tvibvModal;
   RBook.Visual.MultiSelect:=true;
   if ViewInterfaceByName('Справочник констант',RBook) then begin
     ShowInfoEx('Ok');
   end else begin
     ShowErrorEx('Fail');
   end;
  finally
    RBook.Free;
  end;      }
end;

procedure EmptyFormiButton1Click(Sender: TObject);
var
  i: Integer;
begin
   if fm.RBookInterface1.ViewInterface then begin
     ShowInfoEx('Ok');
//   if ViewInterfaceByName('Справочник констант',fm.ObjectRBookInterface1) then begin
  {   for i:=0 to fm.RBookInterface1.DataSet.RecordCount-1 do begin
       ShowInfoEx('Ok');
     end;     }
   end else begin
     ShowErrorEx('Fail');
   end;
end;

end.
