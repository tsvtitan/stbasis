library storetsv;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  UStoreTsvCode in 'StoreTsv\UStoreTsvCode.pas',
  UStoreTsvData in 'StoreTsv\UStoreTsvData.pas',
  UStoreTsvDM in 'StoreTsv\UStoreTsvDM.pas' {dm: TDataModule},
  UStoreTsvOptions in 'StoreTsv\UStoreTsvOptions.pas' {fmOptions},
  UMainUnited in 'United\UMainUnited.pas',
  URBUnitOfMeasure in 'StoreTsv\URBUnitOfMeasure.pas' {fmRBUnitOfMeasure},
  UEditRBUnitOfMeasure in 'StoreTsv\UEditRBUnitOfMeasure.pas' {fmEditRBUnitOfMeasure},
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBTypeOfPrice in 'StoreTsv\URBTypeOfPrice.pas' {fmRBTypeOfPrice},
  UEditRBTypeOfPrice in 'StoreTsv\UEditRBTypeOfPrice.pas' {fmEditRBTypeOfPrice},
  URBGTD in 'StoreTsv\URBGTD.pas' {fmRBGTD},
  UEditRBGTD in 'StoreTsv\UEditRBGTD.pas' {fmEditRBGTD},
  URBNomenclatureGroup in 'StoreTsv\URBNomenclatureGroup.pas' {fmRBNomenclatureGroup},
  UEditRBNomenclatureGroup in 'StoreTsv\UEditRBNomenclatureGroup.pas' {fmEditRBNomenclatureGroup},
  URBNomenclature in 'StoreTsv\URBNomenclature.pas' {fmRBNomenclature},
  UEditRBNomenclature in 'StoreTsv\UEditRBNomenclature.pas' {fmEditRBNomenclature},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  tsvAdjust in 'United\tsvAdjust.pas' {fmAdjust},
  UEditRBNomenclatureProperties in 'StoreTsv\UEditRBNomenclatureProperties.pas' {fmEditRBNomenclatureProperties},
  UEditRBNomenclatureUnitOfMeasure in 'StoreTsv\UEditRBNomenclatureUnitOfMeasure.pas' {fmEditRBNomenclatureUnitOfMeasure},
  UEditRBNomenclatureTypeOfprice in 'StoreTsv\UEditRBNomenclatureTypeOfPrice.pas' {fmEditRBNomenclatureTypeOfPrice},
  tsvTVNavigator in 'United\tsvTVNavigator.pas';

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
     // InitAll;
    end;
    DLL_PROCESS_DETACH: begin
      DeInitAll;
    end;
  end;
end;

exports
  GetInfoLibrary_ name ConstGetInfoLibrary,
  RefreshLibrary_ name ConstRefreshLibrary,
  SetConnection_ name ConstSetConnection,
  InitAll_ name ConstInitAll;
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

