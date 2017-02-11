unit tsvLog;

interface

uses Classes, UMainUnited;

type
  TLogType=TTypeLogItem;
  
type

  TLog=class(TComponent)
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
    function Write(const Message: String; LogType: TLogType): Boolean;
    function WriteInfo(const Message: String): Boolean;
    function WriteError(const Message: String): Boolean;
    function WriteWarn(const Message: String): Boolean;

    procedure Clear; 

    property Active: Boolean read FActive write FActive; 
  end;

implementation

uses SysUtils, Forms;

{ TLog }

constructor TLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileStream:=nil;
  FActive:=true;
end;

destructor TLog.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TLog.Init(const FileName: String);
begin
  if Trim(FileName)='' then exit;
  try
    if not FIsInit and not Assigned(FFileStream) then begin
      FFileName:=ExpandFileName(FileName);
      if not FileExists(FileName) or FClearOnInit then begin
        FFileStream:=TFileStream.Create(FileName,fmCreate);
        FreeAndNil(FFileStream);
      end;

      FFileStream:=TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
      FFileStream.Position:=FFileStream.Size;
      FIsInit:=true;
    end;
  except
    on E: Exception do
      ShowError(Application.Handle,Format('Log failed: %s',[E.Message]));
  end;  
end;

procedure TLog.Done; 
begin
  if Assigned(FFileStream) then begin
    FreeAndNil(FFileStream);
    FIsInit:=false;
  end;  
end;

function TLog.Write(const Message: String; LogType: TLogType): Boolean; 
var
  Buffer: String;
  S: string;
const
  SUnknown='Unknown';
  SInformation='Info';
  SWarning='Warn';
  SError='Error';
  SConfirm='Confirm';
  SFormatMessage='%s [%s]: %s';
  SFormatDateTime='dd.mm.yy hh:nn:ss.zzz';
  SReturn=#13#10;
begin
  Result:=false;
  if not FIsInit then exit;
  S:=SUnknown;
  case LogType of
    tliInformation: S:=SInformation;
    tliWarning: S:=SWarning;
    tliError: S:=SError;
    tliConfirmation: S:=SConfirm;
  end;
  Buffer:=Format(SFormatMessage,[FormatDateTime(SFormatDateTime,Now),S,Message]);
  if Assigned(FFileStream) then begin
    Buffer:=Buffer+SReturn;
    FFileStream.Write(Pointer(Buffer)^,Length(Buffer));
  end;
end;

function TLog.WriteInfo(const Message: String): Boolean; 
begin
  Result:=Write(Message,tliInformation);
end;

function TLog.WriteError(const Message: String): Boolean;
begin
  Result:=Write(Message,tliError);
end;

function TLog.WriteWarn(const Message: String): Boolean;
begin
  Result:=Write(Message,tliWarning);
end;

function TLog.GetIsInit: Boolean; 
begin
  Result:=FIsInit;
end;

function TLog.GetClearOnInit: Boolean; 
begin
  Result:=FClearOnInit;
end;

procedure TLog.SetClearOnInit(Value: Boolean); 
begin
  FClearOnInit:=Value;
end;

procedure TLog.Clear; 
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

function TLog.GetFileName: String; 
begin
  Result:=FFileName;
end;

end.
