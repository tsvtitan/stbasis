library annprem;

{$I stbasis.inc}     

{%File 'stbasis.inc'}
{%File 'Ancement\RX.INC'}

uses
  SysUtils,
  Classes,
  Windows,
  RxRichEd in 'Ancement\RxRichEd.pas',
  MaxMin in 'Ancement\MAXMIN.PAS',
  RxMemDS in 'Ancement\RxMemDS.pas',
  StrUtils in 'United\StrUtils.pas',
  UAnnPremCode in 'AnnPrem\UAnnPremCode.pas',
  UAnnPremData in 'AnnPrem\UAnnPremData.pas',
  UAnnPremDM in 'AnnPrem\UAnnPremDM.pas' {dm: TDataModule},
  UAnnPremOptions in 'AnnPrem\UAnnPremOptions.pas' {fmOptions},
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  URBAP in 'AnnPrem\URBAP.pas' {fmRBAP},
  UEditRBAP in 'AnnPrem\UEditRBAP.pas' {fmEditRBAP},
  URBAPTypePremises in 'AnnPrem\URBAPTypePremises.pas' {fmRBAPTypePremises},
  URBAPTypeInternet in 'AnnPrem\URBAPTypeInternet.pas' {fmRBAPTypeInternet},
  URBAPBuilder in 'AnnPrem\URBAPBuilder.pas' {fmRBAPBuilder},
  URBAPTypeWater in 'AnnPrem\URBAPTypeWater.pas' {fmRBAPTypeWater},
  URBAPTypeHeat in 'AnnPrem\URBAPTypeHeat.pas' {fmRBAPTypeHeat},
  URBAPTypeSanitary in 'AnnPrem\URBAPTypeSanitary.pas' {fmRBAPTypeSanitary},
  URBAPTown in 'AnnPrem\URBAPTown.pas' {fmRBAPTown},
  URBAPRegion in 'AnnPrem\URBAPRegion.pas' {fmRBAPRegion},
  URBAPStreet in 'AnnPrem\URBAPStreet.pas' {fmRBAPStreet},
  URBAPTypePhone in 'AnnPrem\URBAPTypePhone.pas' {fmRBAPTypePhone},
  URBAPCountRoom in 'AnnPrem\URBAPCountRoom.pas' {fmRBAPCountRoom},
  URBAPTypeBuilding in 'AnnPrem\URBAPTypeBuilding.pas' {fmRBAPTypeBuilding},
  URBAPTypeApartment in 'AnnPrem\URBAPTypeApartment.pas' {fmRBAPTypeApartment},
  URBAPPlanning in 'AnnPrem\URBAPPlanning.pas' {fmRBAPPlanning},
  URBAPTypeBalcony in 'AnnPrem\URBAPTypeBalcony.pas' {fmRBAPTypeBalcony},
  URBAPTypeGarage in 'AnnPrem\URBAPTypeGarage.pas' {fmRBAPTypeGarage},
  URBAPTypeBath in 'AnnPrem\URBAPTypeBath.pas' {fmRBAPTypeBath},
  URBAPTypeSewerage in 'AnnPrem\URBAPTypeSewerage.pas' {fmRBAPTypeSewerage},
  URBAPStyle in 'AnnPrem\URBAPStyle.pas' {fmRBAPStyle},
  URBAPUnitPrice in 'AnnPrem\URBAPUnitPrice.pas' {fmRBAPUnitPrice},
  URBAPTypeCondition in 'AnnPrem\URBAPTypeCondition.pas' {fmRBAPTypeCondition},
  URBAPTypePlate in 'AnnPrem\URBAPTypePlate.pas' {fmRBAPTypePlate},
  URBAPTypeFurniture in 'AnnPrem\URBAPTypeFurniture.pas' {fmRBAPTypeFurniture},
  URBAPTypeDoor in 'AnnPrem\URBAPTypeDoor.pas' {fmRBAPTypeDoor},
  URBAPHomeTech in 'AnnPrem\URBAPHomeTech.pas' {fmRBAPHomeTech},
  URBAPFieldView in 'AnnPrem\URBAPFieldView.pas' {fmRBAPFieldView},
  UEditRBAPFieldView in 'AnnPrem\UEditRBAPFieldView.pas' {fmEditRBAPFieldView},
  URBAPAgency in 'AnnPrem\URBAPAgency.pas' {fmRBAPAgency},
  UEditRBAPAgency in 'AnnPrem\UEditRBAPAgency.pas' {fmEditRBAPAgency},
  URBAPOperation in 'AnnPrem\URBAPOperation.pas' {fmRBAPOperation},
  UEditRBAPOperation in 'AnnPrem\UEditRBAPOperation.pas' {fmEditRBAPOperation},
  URBAPLandMark in 'AnnPrem\URBAPLandMark.pas' {fmRBAPLandMark},
  URBAPPremises in 'AnnPrem\URBAPPremises.pas' {fmRBAPPremises},
  UEditRBAPPremises in 'AnnPrem\UEditRBAPPremises.pas' {fmEditRBAPPremises},
  tsvMemIniFile in 'AnnPrem\tsvMemIniFile.pas',
  USrvMain in 'United\USrvMain.pas' {fmSrvMain},
  USrvImportPremises in 'AnnPrem\USrvImportPremises.pas' {fmSrvImportPremises},
  UAPPremisesDefs in 'AnnPrem\UAPPremisesDefs.pas',
  UEditRBAPBuilder in 'AnnPrem\UEditRBAPBuilder.pas' {fmEditRBAPBuilder},
  UEditRBAPRegionStreet in 'AnnPrem\UEditRBAPRegionStreet.pas' {fmEditRBAPRegionStreet},
  URBAPRegionStreet in 'AnnPrem\URBAPRegionStreet.pas' {fmRBAPRegionStreet},
  URBAPDirection in 'AnnPrem\URBAPDirection.pas' {fmRBAPDirection};

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
    //  InitAll;
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

{$R *.RES}
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

