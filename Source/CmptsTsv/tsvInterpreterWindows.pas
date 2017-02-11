unit tsvInterpreterWindows;

interface

uses Windows, UMainUnited, tsvInterpreterCore;

procedure Windows_GetLastError(var Value: Variant; Args: TArguments);
procedure Windows_Sleep(var Value: Variant; Args: TArguments);

implementation

{ function GetLastError: DWORD; stdcall; }
procedure Windows_GetLastError(var Value: Variant; Args: TArguments);
begin
  Value := Integer(GetLastError);
end;

{ procedure Sleep(dwMilliseconds: DWORD) }
procedure Windows_Sleep(var Value: Variant; Args: TArguments);
begin
  Sleep(DWORD(Args.Values[0]));
end;


end.

