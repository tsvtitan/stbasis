{-------------------------------------------------------------------------------}
{ DevEx - AnyDAC adapters                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit cxADAdapters;

interface

uses
  DB, cxDBData, cxFilter, cxDBFilter;

type
  { TcxADProviderDetailFilterAdapter }

  TcxADProviderDetailFilterAdapter = class(TcxDBProviderDetailFilterAdapter)
  public
    function IsCurrentQuery(ADataSet: TDataSet; const AParamNames: string; const AParamValues: Variant): Boolean; override;
    procedure ReopenSQL(ADataSet: TDataSet; const AParamNames: string; const AParamValues: Variant; var AReopened: Boolean); override;
  end;

  { TcxADFilterOperatorAdapter }

  TcxADFilterOperatorAdapter = class(TcxDBFilterOperatorAdapter)
  public
    procedure PrepareOperatorClass(ASender: TObject; ADataSet: TDataSet;
      var AOperatorClass: TcxFilterOperatorClass); override;
  end;

implementation

uses
  TypInfo, daADCompClient, daADStanParam, cxVariants;

{ TcxADProviderDetailFilterAdapter }

function TcxADProviderDetailFilterAdapter.IsCurrentQuery(ADataSet: TDataSet;
  const AParamNames: string; const AParamValues: Variant): Boolean;
var
  oParams: TADParams;
begin
  Result := False;
  if IsPublishedProp(ADataSet, 'Params') then
  begin
    oParams := GetObjectProp(ADataSet, 'Params') as TADParams;
    if oParams <> nil then
    begin
      if VarEquals(oParams.ParamValues[AParamNames], AParamValues) then
        Result := True;
    end;
  end;
end;

procedure TcxADProviderDetailFilterAdapter.ReopenSQL(ADataSet: TDataSet;
  const AParamNames: string; const AParamValues: Variant; var AReopened: Boolean);
var
  oParams: TADParams;
begin
  if IsPublishedProp(ADataSet, 'Params') then
  begin
    oParams := GetObjectProp(ADataSet, 'Params') as TADParams;
    if oParams <> nil then
    begin
      if VarEquals(oParams.ParamValues[AParamNames], AParamValues) then
        ADataSet.First
      else
      begin
        ADataSet.DisableControls;
        try
          ADataSet.Active := False;
          oParams.ParamValues[AParamNames] := AParamValues;
          ADataSet.Active := True;
        finally
          ADataSet.EnableControls;
        end;
        AReopened := True; // set Flag if Query reopened
      end;
    end;
  end;
end;

{ TcxADFilterOperatorAdapter }

procedure TcxADFilterOperatorAdapter.PrepareOperatorClass(ASender: TObject;
  ADataSet: TDataSet; var AOperatorClass: TcxFilterOperatorClass);
begin
  if AOperatorClass.InheritsFrom(TcxFilterNullOperator) or
    AOperatorClass.InheritsFrom(TcxFilterNotNullOperator) then
  begin
    if ADataSet is TADQuery then
    begin
      if AOperatorClass.InheritsFrom(TcxFilterNotNullOperator) then
        AOperatorClass := TcxFilterSQLNotNullOperator
      else
        AOperatorClass := TcxFilterSQLNullOperator;
    end;
  end;  
end;

initialization
  cxDetailFilterControllers.RegisterAdapter(TADRdbmsDataSet, TcxADProviderDetailFilterAdapter);
  cxFilterOperatorAdapters.RegisterAdapter(TADRdbmsDataSet, TcxADFilterOperatorAdapter);

finalization
  cxDetailFilterControllers.UnregisterAdapter(TADRdbmsDataSet, TcxADProviderDetailFilterAdapter);
  cxFilterOperatorAdapters.UnregisterAdapter(TADRdbmsDataSet, TcxADFilterOperatorAdapter);

end.
