unit tsvInterpreterCheckList;

interface

uses Classes, UMainUnited, tsvInterpreterCore;

procedure TCheckListBox_Read_Checked(var Value: Variant; Args: TArguments);
procedure TCheckListBox_Write_Checked(const Value: Variant; Args: TArguments);

implementation

uses CheckLst;

procedure TCheckListBox_Read_Checked(var Value: Variant; Args: TArguments);
begin
  Value := TCheckListBox(Args.Obj).Checked[Args.Values[0]];
end;

procedure TCheckListBox_Write_Checked(const Value: Variant; Args: TArguments);
begin
  TCheckListBox(Args.Obj).Checked[Args.Values[0]] := Value;
end;

end.
