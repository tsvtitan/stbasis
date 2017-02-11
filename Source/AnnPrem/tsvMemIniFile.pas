unit tsvMemIniFile;

interface

uses Classes, inifiles;

type
  TtsvMemIniFile=class(TMemIniFile)
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(FileName: string);
  end;

implementation

uses SysUtils;

{ TtsvMemIniFile }

constructor TtsvMemIniFile.Create;
begin
  inherited Create('');
end;

destructor TtsvMemIniFile.Destroy;
begin
  inherited Destroy;
end;

procedure TtsvMemIniFile.SaveToStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    List.SaveToStream(Stream);
  finally
    List.Free;
  end;
end;

procedure TtsvMemIniFile.SaveToFile(FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmCreate);
    SaveToStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TtsvMemIniFile.LoadFromStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    SetStrings(List);
  finally
    List.Free;
  end;
end;

procedure TtsvMemIniFile.LoadFromFile(FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmOpenRead);
    LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

end.
