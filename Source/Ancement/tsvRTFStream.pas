unit tsvRTFStream;

interface

uses Windows, Classes, graphics, SysUtils;

type
  TTsvRTFMemoryStream=class(TMemoryStream)
  private
    FClosed: Boolean;
    FPosFontTable: Integer;
    FFontTable: TList;
    FPosColorTable: Integer;
    FColorTable: TList;
    procedure WriteString(S: string);
    procedure InsertString(Pos: Integer; S: string);
    function GetFontIdentFromFontTable(Font: TFont): string;
    function GetColorIdentFromColorTable(Font: TFont): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; reintroduce;

    procedure OpenRtf;
    procedure CloseRtf;
    procedure CreateHeader;
    procedure OpenBody;
    procedure CloseBody;
    procedure CreateString(S: String; Font: TFont; FromNewLine: Boolean=false);

    property Closed: Boolean read FClosed;
  end;

implementation

constructor TTsvRTFMemoryStream.Create;
begin
  FClosed:=false;
  FPosColorTable:=0;
  FColorTable:=TList.Create;
  FFontTable:=TList.Create;
end;

destructor TTsvRTFMemoryStream.Destroy;
begin
  Clear;
  FFontTable.Free;
  FColorTable.Free;
  inherited;
end;

procedure TTsvRTFMemoryStream.Clear;
var
  i: Integer;
begin
  for i:=0 to FFontTable.Count-1 do
    TFont(FFontTable.Items[i]).Free;
  FFontTable.Clear;
  FColorTable.Clear;
  inherited Clear;
end;

procedure TTsvRTFMemoryStream.WriteString(S: string);
begin
  Write(Pointer(S)^,Length(S));
end;

procedure TTsvRTFMemoryStream.InsertString(Pos: Integer; S: string);
var
  msAfter: TMemoryStream;
begin
  if (Pos<0)or(Pos>Size) then exit;
  msAfter:=TMemoryStream.Create;
  try
    Position:=Pos;
    msAfter.CopyFrom(Self,Size-Pos);
    Position:=Pos;
    WriteString(S);
    msAfter.Position:=0;
    CopyFrom(msAfter,msAfter.Size);
  finally
    msAfter.Free;
  end;
end;

procedure TTsvRTFMemoryStream.OpenRtf;
begin
  FClosed:=false;
  WriteString('{');
end;

procedure TTsvRTFMemoryStream.CloseRtf;
begin
  WriteString('}');
  FClosed:=true;
end;

procedure TTsvRTFMemoryStream.CreateHeader;
begin
  WriteString('\rtf');
  WriteString('\ansi');
  WriteString('\ansicpg1251');
  WriteString('\deff0\deflang1049');

  WriteString('{');
  WriteString('\fonttbl');
  FPosFontTable:=Position;
  WriteString('}');

  WriteString('{');
  WriteString('\colortbl ;');
  FPosColorTable:=Position;            
  WriteString('}');
end;

procedure TTsvRTFMemoryStream.OpenBody;
begin
  WriteString('\viewkind4');
  WriteString('\uc1');
  WriteString('\pard');
end;

procedure TTsvRTFMemoryStream.CloseBody;
begin
  WriteString('\par');
end;

function TTsvRTFMemoryStream.GetFontIdentFromFontTable(Font: TFont): string;

  function IndexOfFont: Integer;
  var
    i: Integer;
    fnt: TFont;  
  begin
    Result:=-1;
    for i:=0 to FFontTable.Count-1 do begin
      fnt:=FFontTable.Items[i];
      if (fnt.Name=Font.Name) then begin
        Result:=i;
        exit;
      end;
    end;
  end;

  function GetFontString: string;
  begin
    Result:=Format('{\f%d\fnil %s}',[FFontTable.Count,Font.Name]);
  end;

var
  val: Integer;
  fnt: TFont;
  S: String;
begin
  val:=IndexOfFont;
  if val=-1 then begin
    S:=GetFontString;
    InsertString(FPosFontTable,S);
    FPosFontTable:=FPosFontTable+Length(S);
    FPosColorTable:=FPosColorTable+Length(S);
    fnt:=TFont.Create;
    fnt.Assign(Font);
    val:=FFontTable.Add(fnt);
  end;
  Result:='\f'+inttostr(val);
end;

function TTsvRTFMemoryStream.GetColorIdentFromColorTable(Font: TFont): string;
var
  r,g,b: Byte;
  val: Integer;
  S: string;
begin
  r:=GetRValue(ColorToRGB(Font.Color));
  g:=GetGValue(ColorToRGB(Font.Color));
  b:=GetBValue(ColorToRGB(Font.Color));
  val:=FColorTable.IndexOf(Pointer(Font.Color));
  if val=-1 then begin
    S:=Format('\red%d\green%d\blue%d;',[r,g,b]);
    InsertString(FPosColorTable,S);
    FPosColorTable:=FPosColorTable+Length(S);
    val:=FColorTable.Add(Pointer(Font.Color));
  end;
  Result:='\cf'+inttostr(val+1);
end;

procedure TTsvRTFMemoryStream.CreateString(S: String; Font: TFont; FromNewLine: Boolean=false);
var
  i: Integer;
begin
  if not Assigned(Font) then exit;
  WriteString('{');
  WriteString(GetColorIdentFromColorTable(Font));
  if fsBold in Font.Style then WriteString('\b');
  if fsItalic in Font.Style then WriteString('\i');
  if fsUnderline in Font.Style then WriteString('\ul');
  if fsStrikeOut in Font.Style then WriteString('\strike');
  WriteString(GetFontIdentFromFontTable(Font));
  WriteString('\fs'+inttostr(Abs(Font.Size*2)));
  WriteString(' ');
                                                                               
  for i:=1 to Length(S) do begin
    if (Byte(S[i]) in [byte('À')..byte('ÿ')])or
       (Byte(S[i]) in [byte('\'),byte('/')])or
       (Byte(S[i]) in [byte('{'),byte('}')]) then begin
      WriteString('\'''+AnsiLowerCase(IntToHex(Byte(S[i]),2)));
    end else begin
      if S[i]=#13 then
        WriteString('\par')
      else
        WriteString(S[i]);
    end;
  end;
  if fsBold in Font.Style then WriteString('\b0');
  if fsItalic in Font.Style then WriteString('\i0');
  if fsUnderline in Font.Style then WriteString('\ul0');
  if fsStrikeOut in Font.Style then WriteString('\strike0');
  if FromNewLine then begin
    WriteString('\par');
  end;
  WriteString(' ');
  WriteString('}');
end;

end.
