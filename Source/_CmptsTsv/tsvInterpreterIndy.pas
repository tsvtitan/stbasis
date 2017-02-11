unit tsvInterpreterIndy;

interface

uses Classes,
     IdHttp, IdMultiPartFormData,
     tsvInterpreterCore;


{ TIdMultiPartFormDataStream }

procedure TIdMultiPartFormDataStream_Create(var Value: Variant; Args: TArguments);
procedure TIdMultiPartFormDataStream_AddFormField(var Value: Variant; Args: TArguments);
procedure TIdMultiPartFormDataStream_AddFile(var Value: Variant; Args: TArguments);
procedure TIdMultiPartFormDataStream_AddStreamAsFile(var Value: Variant; Args: TArguments);

{ TIdHttp }

procedure TIdHttp_Post(var Value: Variant; Args: TArguments);

implementation

{ TIdMultiPartFormDataStream }

// constructor TIdMultiPartFormDataStream.Create;
procedure TIdMultiPartFormDataStream_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TIdMultiPartFormDataStream.Create);
end;

//procedure AddFormField(const AFieldName, AFieldValue: string);
procedure TIdMultiPartFormDataStream_AddFormField(var Value: Variant; Args: TArguments);
begin
  TIdMultiPartFormDataStream(Args.Obj).AddFormField(Args.Values[0],Args.Values[1]);
end;

//procedure AddFile(const AFieldName, AFileName, AContentType: string);
procedure TIdMultiPartFormDataStream_AddFile(var Value: Variant; Args: TArguments);
begin
  TIdMultiPartFormDataStream(Args.Obj).AddFile(Args.Values[0],Args.Values[1],Args.Values[2]);
end;

//procedure AddStreamAsFile(const AFieldName, AFileName, AContentType: string; AStream: TStream);
procedure TIdMultiPartFormDataStream_AddStreamAsFile(var Value: Variant; Args: TArguments);
begin
  TIdMultiPartFormDataStream(Args.Obj).AddStreamAsFile(Args.Values[0],Args.Values[1],Args.Values[2],
                                                       V2O(Args.Values[3]) as TStream);
end;

{ TIdHttp }

// function Post(AURL: string; const ASource: TIdMultiPartFormDataStream): string; overload;
procedure TIdHttp_Post(var Value: Variant; Args: TArguments);
var
  AURL: string;
  ASource: TIdMultiPartFormDataStream;
begin
  AURL:=Args.Values[0];
  ASource:=V2O(Args.Values[1]) as TIdMultiPartFormDataStream;
  Value:=TIdHttp(Args.Obj).Post(AURL,ASource);
end;

end.
