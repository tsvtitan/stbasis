unit tsvInterpreterComObj;

interface

uses ComObj, UMainUnited, tsvInterpreterCore;

procedure ComObj_CreateOleObject(var Value: Variant; Args: TArguments);
procedure ComObj_GetActiveOleObject(var Value: Variant; Args: TArguments);
procedure ComObj_OleError(var Value: Variant; Args: TArguments);
procedure ComObj_OleCheck(var Value: Variant; Args: TArguments);

implementation

{function CreateOleObject(const ClassName: string): IDispatch;}
procedure ComObj_CreateOleObject(var Value: Variant; Args: TArguments);
begin
  Value := CreateOleObject(Args.Values[0]);
end;

{function GetActiveOleObject(const ClassName: string): IDispatch;}
procedure ComObj_GetActiveOleObject(var Value: Variant; Args: TArguments);
begin
  Value := GetActiveOleObject(Args.Values[0]);
end;

{procedure OleError(ErrorCode: HResult);}
procedure ComObj_OleError(var Value: Variant; Args: TArguments);
begin
  OleError(Args.Values[0]);
end;

{procedure OleCheck(Result: HResult);}
procedure ComObj_OleCheck(var Value: Variant; Args: TArguments);
begin
  OleCheck(Args.Values[0]);
end;


end.

