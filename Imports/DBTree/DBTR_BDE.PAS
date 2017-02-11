unit dbtr_bde;

interface
uses DB;
{Only one compiler directive may be define at once}

{$DEFINE BORLAND_BDE}
{DEFINE APOLLO}

function DBTrDataSetLocate(DataSet : TDataSet; const KeyFields: string;
   const KeyValues: Variant; Options: TLocateOptions): Boolean;

implementation

function DBTrDataSetLocate(DataSet : TDataSet; const KeyFields: string;
   const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
{$IFDEF BORLAND_BDE}
  Result := DataSet.Locate(KeyFields, KeyValues, Options);
{$ENDIF}
{$IFDEF APOLLO}
{$ENDIF}
end;

end.
