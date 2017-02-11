unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ed1: TEdit;
    ed2: TEdit;
    edCircle: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;

implementation

uses StbasisUdfData;

 function _GetServerDate: PIBDateTime; cdecl;
                         external 'stbasisudf.dll' name 'Now';

 function _sys_AddStr(Str1, Str2, Str3, Str4: PChar): PChar; cdecl;
                         external 'stbasisudf.dll' name 'sys_AddStr';
 function _sys_CompareStr(var MaxCompareStr: Integer; SubStr: PChar; Str: PChar): Integer; cdecl;
                         external 'stbasisudf.dll' name 'sys_CompareStr';
 function _sys_CompareStr2(SubStr: PChar; Str: PChar): Integer; cdecl;
                         external 'stbasisudf.dll' name 'sys_CompareStr2';
 function _sys_CompareStrByWord(SubStr: PChar; Str: PChar): Integer; cdecl;
                         external 'stbasisudf.dll' name 'sys_CompareStrByWord';
 function _sys_CompareStr4(SubStr: PChar; Str: PChar): Integer; cdecl;
                         external 'stbasisudf.dll' name 'sys_CompareStr4';

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  dt: PIBDateTime;
begin
  dt:=_GetServerDate;

  Edit1.Text:='Days='+inttostr(dt.Days)+' MSec10='+inttostr(dt.MSec10);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  t1: TTime;
  i: Integer;
  MaxCompareStr,p: Integer;
  s1: string;
begin
  t1:=time;
  MaxCompareStr:=strtoint(Edit2.text);
  for i:=1 to strtoint(edCircle.Text) do begin
    //CompareStr('Привет все из дурдома','Привет дурдома все из');
//    p:=_sys_CompareStr(MaxCompareStr,PChar(ed1.text),PChar(ed2.text));
    p:=_sys_CompareStrByWord(PChar(ed1.text),PChar(ed2.text));
//    _sys_AddStr(PChar(s1),s2,'','');
  end;
  Caption:=inttostr(p);
  ShowMessage(FormatDateTime('ss.zzz',time-t1));
end;

function StrFastCopy( s1 : PChar; const s : string ) :PChar;
var
  len : Integer;
begin
  len := Length(s);
  StrMove(S1, PChar(s), len);
  Result := s1 + len;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  s0, s1 : PChar;
  //ss : string;
  i : Integer;
  t1: TTime;
begin
  t1:=Time;
  GetMem(s0, 1000 );
  for i := 0 To 10000 - 1 do
  begin
    s1 := StrFastCopy(s0, '>>>>>...>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    s1 := StrFastCopy(s1, 'Мама ');
    s1 := StrFastCopy(s1, 'мыла ');
    s1 := StrFastCopy(s1, 'раму');
  //  StrFastCopy(s1, #10);
    s1 := s0;
    //ss := s0;
  end;
  ShowMessage(s1);
  ShowMessage(FormatDateTime('ss.zzz',time-t1));
  FreeMem(s0);
end;

end.
 