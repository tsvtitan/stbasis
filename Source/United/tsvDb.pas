unit tsvDb;

interface

uses Classes, DB, DBClient,
     tsvCrypter;

type

  TTsvDb=class(TComponent)
  private
    FFileName: string;
    FIsInit: Boolean;
    FCrypter: TTsvCrypter;
    FDataSet: TClientDataSet;
    FCipherKey: String;
    FOldHash: string;
    function GetChanges: Boolean;
    function GetNewHash: string;
    function GetReadOnly: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(const FileName: string);
    procedure Done;
    procedure CreateDb;
    procedure ReCreate(const FileName: String);
    procedure LoadFromFile(const FileName: String);
    procedure SaveToFile(const FileName: String);
    function ReadParam(const AName: String; var AValue: String): Boolean; overload;
    function ReadParam(const AName: String; Stream: TStream): Boolean; overload;
    procedure WriteParam(const AName, AValue: String; IsNew: Boolean);
    function DeleteParam(const AName: String): Boolean;
    function ExistsParam(const AName: String): Boolean;
    procedure UpdateFile(IgnoreChanges: Boolean=false);
    function HashValue(Field: TBlobField): String;

    property FileName: string read FFileName;
    property Crypter: TTsvCrypter read FCrypter write FCrypter;
    property CipherKey: String read FCipherKey write FCipherKey;
    property DataSet: TClientDataSet read FDataSet;
    property Changes: Boolean read GetChanges;
    property IsInit: Boolean read FIsInit;
    property ReadOnly: Boolean read GetReadOnly;
  end;

const
  DefaultCipherAlgorithm=caRC5;
  DefaultCipherMode=cmCTS;
  DefaultHashAlgorithm=haMD5;
  DefaultHashFormat=hfHEX;
  SDb_Name='NAME';
  SDb_Value='VALUE';
  SDb_Note='NOTE';
  SDb_Type='TYPE';
  SDb_Sync='SYNC';
  Db_MaxName=100;
  Db_MaxNote=250;


implementation

uses SysUtils, IdCoder, IdCoder3to4, UMainUnited;


{ TTsvDb }

constructor TTsvDb.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSet:=TClientDataSet.Create(FDataSet);
end;

destructor TTsvDb.Destroy;
begin
  FDataSet:=nil;
  inherited Destroy;
end;

procedure TTsvDb.Init(const FileName: string);
begin
  try
    LoadFromFile(FileName);
    FIsInit:=true;
  except
  end;  
end;

procedure TTsvDb.Done;
begin
  if FIsInit then begin
    FIsInit:=false;
    UpdateFile;
  end;
end;

procedure TTsvDb.CreateDb;
begin
  with FDataSet do begin
    Close;
    FieldDefs.Clear;
    FieldDefs.Add(SDb_Name,ftString,Db_MaxName);
    FieldDefs.Add(SDb_Value,ftBlob,MaxInt);
    FieldDefs.Add(SDb_Note,ftString,Db_MaxNote);
    FieldDefs.Add(SDb_Type,ftInteger);
    FieldDefs.Add(SDb_Sync,ftInteger);
    CreateDataSet;
  end;
end;

procedure TTsvDb.ReCreate(const FileName: String);
begin
  CreateDb;
  SaveToFile(FileName);
  FFileName:=FileName;
end;

procedure TTsvDb.LoadFromFile(const FileName: String);
var
  PackedStream: TMemoryStream;
begin
  PackedStream:=TMemoryStream.Create;
  try
    try
      PackedStream.LoadFromFile(FileName);
      PackedStream.Position:=0;
      FCrypter.DecodeStream(FCipherKey,PackedStream,DefaultCipherAlgorithm,DefaultCipherMode);
      PackedStream.Position:=0;
      FDataSet.LoadFromStream(PackedStream);
      FDataSet.MergeChangeLog;
      FFileName:=FileName;
      FOldHash:=GetNewHash;
    except
      raise;
    end;
  finally
    PackedStream.Free;
  end;
end;

procedure TTsvDb.SaveToFile(const FileName: String);
var
  UnPackedStream: TMemoryStream;
begin
  UnPackedStream:=TMemoryStream.Create;
  try
    try
      FDataSet.MergeChangeLog;
      FDataSet.SaveToStream(UnPackedStream);
      UnPackedStream.Position:=0;
      FCrypter.EncodeStream(FCipherKey,UnPackedStream,DefaultCipherAlgorithm,DefaultCipherMode);
      UnPackedStream.Position:=0;
      UnPackedStream.SaveToFile(FileName);
      FOldHash:=GetNewHash;
    except
    end;
  finally
    UnPackedStream.Free;
  end;
end;

function TTsvDb.ReadParam(const AName: String; var AValue: String): Boolean;
begin
  Result:=false;
  AValue:='';
  if FDataSet.Locate(SDb_Name,AName,[loCaseInsensitive]) then begin
    AValue:=FDataSet.FieldByName(SDb_Value).Value;
    Result:=True;
  end;
end;

function TTsvDb.ReadParam(const AName: String; Stream: TStream): Boolean;
begin
  Result:=false;
  if FDataSet.Locate(SDb_Name,AName,[loCaseInsensitive]) then begin
    TBlobField(FDataSet.FieldByName(SDb_Value)).SaveToStream(Stream);
    Result:=True;
  end;
end;

procedure TTsvDb.WriteParam(const AName, AValue: String; IsNew: Boolean);
begin
  if FDataSet.Locate(SDb_Name,AName,[loCaseInsensitive]) then begin
    FDataSet.Edit;
    try
      try
        FDataSet.FieldByName(SDb_Value).Value:=AValue;
      except
        FDataSet.Cancel;
      end;
    finally
      FDataSet.Post;
    end;
  end else begin
    if IsNew then begin
      FDataSet.Append;
      try
        try
          FDataSet.FieldByName(SDb_Name).AsString:=AName;
          FDataSet.FieldByName(SDb_Value).Value:=AValue;
        except
          FDataSet.Cancel;
        end;
      finally
        FDataSet.Post;
      end;
    end;
  end;
end;

function TTsvDb.DeleteParam(const AName: String): Boolean;
begin
  Result:=false;
  if FDataSet.Locate(SDb_Name,AName,[loCaseInsensitive]) then begin
    FDataSet.Delete;
    Result:=true;
  end;
end;

function TTsvDb.ExistsParam(const AName: String): Boolean;
begin
  Result:=FDataSet.Locate(SDb_Name,AName,[loCaseInsensitive]);
end;

procedure TTsvDb.UpdateFile(IgnoreChanges: Boolean=false);
begin
  if not IgnoreChanges then begin
    if Changes then
      SaveToFile(FFileName);
  end else SaveToFile(FFileName);
end;

function TTsvDb.HashValue(Field: TBlobField): String; 
var
  Ms: TMemoryStream;
begin
  Result:='';
  if Assigned(Field) and Assigned(FCrypter) then begin
    Ms:=TMemoryStream.Create;
    try
      Field.SaveToStream(Ms);
      Ms.Position:=0;
      Result:=FCrypter.HashStream(Ms,DefaultHashAlgorithm,DefaultHashFormat);
    finally
      Ms.Free;
    end;
  end; 
end;

function TTsvDb.GetNewHash: string;
var
  Ms: TMemoryStream;
begin
  Result:='';
  try
    if FDataSet.Active and Assigned(FCrypter) then begin
      Ms:=TMemoryStream.Create;
      try
        FDataSet.MergeChangeLog;
        FDataSet.SaveToStream(Ms);
        Ms.Position:=0;
        Result:=FCrypter.HashStream(Ms,DefaultHashAlgorithm,DefaultHashFormat);
      finally
        Ms.Free;
      end;
    end;
  except
  end;
end;

function TTsvDb.GetChanges: Boolean;
var
  FNewHash: string;
begin
  FNewHash:=GetNewHash;
  Result:=not AnsiSameText(FOldHash,FNewHash);
end;

function TTsvDb.GetReadOnly: Boolean;
var
  FileNandle: Integer;
begin
  Result:=true;
  if FileExists(FFileName) then begin
    FileNandle:=0;
    try
      FileNandle:=FileOpen(FFileName,fmOpenWrite);
      Result:=not(FileNandle>0);
    finally
      FileClose(FileNandle);
    end;
  end;
end;

end.
