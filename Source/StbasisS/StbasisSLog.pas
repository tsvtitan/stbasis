unit StbasisSLog;

interface

uses Classes;

type
  TStbasisSLogType=(ltInformation,ltWarning,ltError);
  TStbasisSLogOutput=set of (loScreen,loFile);
  
type

  TStbasisSLog=class(TComponent)
  private
    FFileStream: TFileStream;
    FIsInit: Boolean;
    FClearOnInit: Boolean;
    FFileName: string;
    FActive: Boolean;
  protected
    function GetIsInit: Boolean;
    function GetClearOnInit: Boolean;
    procedure SetClearOnInit(Value: Boolean);
    function GetFileName: String;

    property IsInit: Boolean read GetIsInit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(const FileName: String); virtual;
    procedure Done; virtual; 
    function Write(const Message: String; LogType: TStbasisSLogType; LogOutput: TStbasisSLogOutput): Boolean;
    function WriteInfo(const Message: String; LogOutput: TStbasisSLogOutput): Boolean;
    function WriteError(const Message: String; LogOutput: TStbasisSLogOutput): Boolean;
    function WriteWarn(const Message: String; LogOutput: TStbasisSLogOutput): Boolean;
    function WriteToFile(const Message: String; LogType: TStbasisSLogType): Boolean;
    function WriteToScreen(const Message: String; LogType: TStbasisSLogType): Boolean;
    function WriteToBoth(const Message: String; LogType: TStbasisSLogType): Boolean;

    procedure Clear; 

    property Active: Boolean read FActive write FActive; 
  end;

implementation

uses SysUtils;

{ TStbasisSLog }

constructor TStbasisSLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileStream:=nil;
  FActive:=true;
end;

destructor TStbasisSLog.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TStbasisSLog.Init(const FileName: String); 
begin
  if not FIsInit and not Assigned(FFileStream) then begin
    FFileName:=FileName;
    if not FileExists(FileName) or FClearOnInit then begin
      FFileStream:=TFileStream.Create(FileName,fmCreate);
      FreeAndNil(FFileStream);
    end;

    FFileStream:=TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
    FFileStream.Position:=FFileStream.Size;
    FIsInit:=true;
  end;
end;

procedure TStbasisSLog.Done; 
begin
  if Assigned(FFileStream) then begin
    FreeAndNil(FFileStream);
    FIsInit:=false;
  end;  
end;

function TStbasisSLog.Write(const Message: String; LogType: TStbasisSLogType; LogOutput: TStbasisSLogOutput): Boolean; 
var
  Buffer: String;
  S: string;
const
  SUnknown='Unknown';
  SInformation='Info';
  SWarning='Warn';
  SError='Error';
  SFormatMessage='%s [%s]: %s';
  SFormatDateTime='dd.mm.yy hh:nn:ss.zzz';
  SReturn=#13#10;
begin
  Result:=false;
  S:=SUnknown;
  case LogType of
    ltInformation: S:=SInformation;
    ltWarning: S:=SWarning;
    ltError: S:=SError;
  end;
  Buffer:=Format(SFormatMessage,[FormatDateTime(SFormatDateTime,Now),S,Message]);
  if loScreen in LogOutput then ;
  if loFile in LogOutput then
    if Assigned(FFileStream) then begin
      Buffer:=Buffer+SReturn;
      FFileStream.Write(Pointer(Buffer)^,Length(Buffer));
    end;
end;

function TStbasisSLog.WriteInfo(const Message: String; LogOutput: TStbasisSLogOutput): Boolean; 
begin
  Result:=Write(Message,ltInformation,LogOutput);
end;

function TStbasisSLog.WriteError(const Message: String; LogOutput: TStbasisSLogOutput): Boolean; 
begin
  Result:=Write(Message,ltError,LogOutput);
end;

function TStbasisSLog.WriteWarn(const Message: String; LogOutput: TStbasisSLogOutput): Boolean; 
begin
  Result:=Write(Message,ltWarning,LogOutput);
end;

function TStbasisSLog.WriteToFile(const Message: String; LogType: TStbasisSLogType): Boolean; 
begin
  Result:=Write(Message,LogType,[loFile]);
end;

function TStbasisSLog.WriteToScreen(const Message: String; LogType: TStbasisSLogType): Boolean; 
begin
  Result:=Write(Message,LogType,[loScreen]);
end;

function TStbasisSLog.WriteToBoth(const Message: String; LogType: TStbasisSLogType): Boolean; 
begin
  Result:=Write(Message,LogType,[loScreen,loFile]);
end;

function TStbasisSLog.GetIsInit: Boolean; 
begin
  Result:=FIsInit;
end;

function TStbasisSLog.GetClearOnInit: Boolean; 
begin
  Result:=FClearOnInit;
end;

procedure TStbasisSLog.SetClearOnInit(Value: Boolean); 
begin
  FClearOnInit:=Value;
end;

procedure TStbasisSLog.Clear; 
var
  Old: Boolean;
begin
  FActive:=true;
  Old:=FClearOnInit;
  try
    Done;
    FClearOnInit:=true;
    Init(FFileName);
  finally
    FClearOnInit:=Old;
    FActive:=true;
  end;
end;

function TStbasisSLog.GetFileName: String; 
begin
  Result:=FFileName;
end;

end.
