unit tsvComponentFont;

interface

uses Classes, Graphics;

type

  TComponentFont=class(TComponent)
  private
    FFont: TFont;
    procedure SetFont(Value: TFont);
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure SetFontFromHexStr(HexStr: string);
    function GetFontAsHexStr: String;
  published
    property Font: TFont read FFont write SetFont;
  end;


implementation

uses UMainUnited;

{ TComponentFont }

constructor TComponentFont.Create(AOwner: TComponent);
begin
  inHerited Create(AOwner);
  FFont:=TFont.Create;
end;

destructor TComponentFont.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TComponentFont.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TComponentFont.SetFontFromHexStr(HexStr: string);
var
  Realstr: string;
  ms: TMemoryStream;
begin
  ms:=TMemoryStream.Create;
  try
    Realstr:=HexStrToStr(HexStr);
    try
      ms.SetSize(Length(Realstr));
      Move(Pointer(Realstr)^,ms.Memory^,ms.Size);
      ms.Position:=0;
      ms.ReadComponent(Self);
    except
    end;
  finally
    ms.Free;
  end;
end;

function TComponentFont.GetFontAsHexStr: String;
var
  ms: TMemoryStream;
  tmps: string;
begin
  ms:=TMemoryStream.Create;
  try
    ms.WriteComponent(Self);
    SetLength(tmps,ms.Size);
    Move(ms.Memory^,Pointer(tmps)^,ms.Size);
    tmps:=StrToHexStr(tmps);
    Result:=tmps;
  finally
    ms.Free;
  end;
end;


end.
