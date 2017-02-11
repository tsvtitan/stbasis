unit tsvInterpreterXml;

interface

uses Classes, XMLDoc,
     tsvInterpreterCore;

{ TXMLDocument }

procedure TXMLDocument_Create(var Value: Variant; Args: TArguments);
procedure TXMLDocument_LoadFromStream(var Value: Variant; Args: TArguments);
procedure TXMLDocument_LoadFromFile(var Value: Variant; Args: TArguments);
procedure TXMLDocument_SaveToStream(var Value: Variant; Args: TArguments);
procedure TXMLDocument_SaveToFile(var Value: Variant; Args: TArguments);

implementation

{ TXMLDocument }

{ constructor Create(AOwner: TComponent) }
procedure TXMLDocument_Create(var Value: Variant; Args: TArguments);
begin
  Value := O2V(TXMLDocument.Create(V2O(Args.Values[0]) as TComponent));
end;

{  procedure LoadFromStream(Stream: TStream; EncodingType: TXMLEncodingType = xetUnknown); }
procedure TXMLDocument_LoadFromStream(var Value: Variant; Args: TArguments);
begin
  TXMLDocument(Args.Obj).LoadFromStream(V2O(Args.Values[0]) as TStream);
end;

// procedure TXMLDocument.LoadFromFile(const AFileName: DOMString = '');
procedure TXMLDocument_LoadFromFile(var Value: Variant; Args: TArguments);
begin
  TXMLDocument(Args.Obj).LoadFromFile(Args.Values[0]);
end;

{  procedure SaveToStream(Stream: TStream); }
procedure TXMLDocument_SaveToStream(var Value: Variant; Args: TArguments);
begin
  TXMLDocument(Args.Obj).SaveToStream(V2O(Args.Values[0]) as TStream);
end;

// procedure TXMLDocument.SaveToFile(const AFileName: DOMString = '');
procedure TXMLDocument_SaveToFile(var Value: Variant; Args: TArguments);
begin
  TXMLDocument(Args.Obj).SaveToFile(Args.Values[0]);
end;

end.
