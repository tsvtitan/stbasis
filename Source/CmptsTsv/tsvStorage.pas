unit tsvStorage;

interface

uses Classes, Dialogs, Sysutils, DsgnIntf;

type
   TtsvStorage=class(TComponent)
   private
     FMemStream: TMemoryStream;
     FFileName: TFileName;
     function GetSize: Integer;
     procedure SetFileName(Value: TFileName);
     procedure ReadData(Stream: TStream);
     procedure WriteData(Stream: TStream);
   protected
     procedure DefineProperties(Filer: TFiler); override;

   public
     constructor Create(AOwner: TComponent);override;
     destructor Destroy; override;
     procedure Clear;
     function Empty: Boolean;
     procedure LoadFromStream(Stream: TStream);
     procedure SaveToStream(Stream: TStream);
     procedure LoadFromFile(const AFileName: String);
     procedure SaveToFile(const AFileName: String);

   published
     property Size: Integer read GetSize;
     property FileName: TFileName read FFileName write SetFileName;

   end;

 TtsvStorageEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    constructor Create(aOwner: TComponent; aDesigner: IFormDesigner); override;
    destructor Destroy; override;

    procedure LoadFile;
    procedure SaveFile;
  end;

implementation

const
  ConstFilter='Все файлы (*.*)|*.*';
  
{ TtsvStorage }

constructor TtsvStorage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMemStream:=TMemoryStream.Create;
end;

destructor TtsvStorage.Destroy;
begin
  FMemStream.Free;
  inherited;
end;

procedure TtsvStorage.ReadData(Stream: TStream);
begin
  LoadFromStream(Stream);
end;

procedure TtsvStorage.WriteData(Stream: TStream);
begin
  SaveToStream(Stream);
end;

procedure TtsvStorage.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor<>nil then
     Result:=not (Filer.Ancestor is TtsvStorage)
    else Result:=not Empty; 
  end;
  
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data',ReadData,WriteData,DoWrite); 
end;

procedure TtsvStorage.Clear;
begin
  FMemStream.Clear;
end;

function TtsvStorage.Empty: Boolean;
begin
  Result:=FMemStream.Size=0;
end;

procedure TtsvStorage.LoadFromStream(Stream: TStream);
begin
  FMemStream.LoadFromStream(Stream);
end;

procedure TtsvStorage.SaveToStream(Stream: TStream);
begin
  FMemStream.SaveToStream(Stream);
end;

procedure TtsvStorage.LoadFromFile(const AFileName: String);
begin
  FMemStream.LoadFromFile(AFileName);
  FFileName:=ExtractFileName(AFileName);
end;

procedure TtsvStorage.SaveToFile(const AFileName: String);
begin
  FMemStream.SaveToFile(AFileName);
end;

function TtsvStorage.GetSize: Integer;
begin
  Result:=FMemStream.Size;
end;

procedure TtsvStorage.SetFileName(Value: TFileName);
begin
  if Value<>FFileName then begin
    if not (csLoading in ComponentState) then
     LoadFromFile(Value)
    else FFileName:=Value;
  end;
end;

{ TtsvStorageEditor }

constructor TtsvStorageEditor.Create(aOwner: TComponent; aDesigner: IFormDesigner);
begin
  inherited Create(aOwner, aDesigner);
end;

destructor TtsvStorageEditor.Destroy;
begin
  inherited Destroy;
end;

procedure TtsvStorageEditor.LoadFile;
var
  od: TOpenDialog;
begin
  od:=TOpenDialog.Create(nil);
  try
   od.Filter := ConstFilter;
   od.FileName:=(Component as TtsvStorage).FileName;
   if not od.Execute then exit;
   (Component as TtsvStorage).LoadFromFile(od.FileName);
   Designer.Modified;
  finally
   od.Free;
  end;
end;

procedure TtsvStorageEditor.SaveFile;
var
  sd: TSaveDialog;
begin
  sd:=TSaveDialog.Create(nil);
  try
   sd.Filter := ConstFilter;
   sd.FileName:=(Component as TtsvStorage).FileName;
   if not sd.Execute then exit;
   (Component as TtsvStorage).SaveToFile(sd.FileName);
   Designer.Modified;
  finally
   sd.Free;
  end;
end;

procedure TtsvStorageEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: LoadFile;
    1: SaveFile;
    2: begin
     (Component as TtsvStorage).Clear;
     Designer.Modified;
    end; 
  end;
end;

function TtsvStorageEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;

function TtsvStorageEditor.GetVerb(Index: Integer): string;
begin
  Result:='';
  case Index of
    0: Result:='Загрузить';
    1: Result:='Сохранить';
    2: Result:='Очистить';
  end;
end;

end.
