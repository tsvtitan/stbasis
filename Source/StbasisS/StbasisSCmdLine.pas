unit StbasisSCmdLine;

interface

uses Classes;

type

  TStbasisSCmdLine=class(TComponent)
  public
    function ParamExists(const Param: String): Boolean;
    function ValueByParam(const Param: String): String; 
  end;

implementation

uses SysUtils;

{ TStbasisSCmdLine }

const
  SwitchChars=['/','-'];

function TStbasisSCmdLine.ParamExists(const Param: String): Boolean;
begin
  Result:=FindCmdLineSwitch(Param,SwitchChars,true);
end;

function TStbasisSCmdLine.ValueByParam(const Param: String): String; 
var
  i: Integer;
  ParamExists: Boolean;
  S: string;
  Chars: TSysCharSet;  
begin
  ParamExists:=false;
  Chars:=SwitchChars;
  for i:=1 to ParamCount do begin
    S:=ParamStr(i);
    if (Chars = []) or (S[1] in Chars) then begin
      if (AnsiCompareText(Copy(S, 2, Maxint), Param) = 0) then begin
        ParamExists:=True;
      end;
    end else begin
      if ParamExists then begin
        Result:=S;
        exit;
      end;  
    end;  
  end;
end;

end.
