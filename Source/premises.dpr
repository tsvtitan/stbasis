library premises;

{$I stbasis.inc}     

{$R 'PremisesTsv\RptPms_Price.res' 'PremisesTsv\RptPms_Price.rc'}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  VirtualDBTree in 'United\VirtualDBTree.pas',
  VirtualTrees in 'United\VirtualTrees.pas',
  UPremisesTsvCode in 'PremisesTsv\UPremisesTsvCode.pas',
  UPremisesTsvData in 'PremisesTsv\UPremisesTsvData.pas',
  UPremisesTsvDM in 'PremisesTsv\UPremisesTsvDM.pas' {dm: TDataModule},
  UPremisesTsvOptions in 'PremisesTsv\UPremisesTsvOptions.pas' {fmOptions},
  URBPms_Street in 'PremisesTsv\URBPms_Street.pas' {fmRBPms_Street},
  UEditRBPms_Street in 'PremisesTsv\UEditRBPms_Street.pas' {fmEditRBPMS_Street},
  URBPms_Region in 'PremisesTsv\URBPms_Region.pas' {fmRBPms_Region},
  UEditRBPms_Region in 'PremisesTsv\UEditRBPms_Region.pas' {fmEditRBPms_Region},
  URBPms_Balcony in 'PremisesTsv\URBPms_Balcony.pas' {fmRBPms_Balcony},
  UEditRBPms_Balcony in 'PremisesTsv\UEditRBPms_Balcony.pas' {fmEditRBPms_Balcony},
  URBPms_Condition in 'PremisesTsv\URBPms_Condition.pas' {fmRBPms_Condition},
  UEditRBPms_Condition in 'PremisesTsv\UEditRBPms_Condition.pas' {fmEditRBPms_Condition},
  URBPms_SanitaryNode in 'PremisesTsv\URBPms_SanitaryNode.pas' {fmRBPms_SanitaryNode},
  UEditRBPms_SanitaryNode in 'PremisesTsv\UEditRBPms_SanitaryNode.pas' {fmEditRBPms_SanitaryNode},
  URBPms_CountRoom in 'PremisesTsv\URBPms_CountRoom.pas' {fmRBPms_CountRoom},
  UEditRBPms_CountRoom in 'PremisesTsv\UEditRBPms_CountRoom.pas' {fmEditRBPms_CountRoom},
  URBPms_TypeRoom in 'PremisesTsv\URBPms_TypeRoom.pas' {fmRBPms_TypeRoom},
  UEditRBPms_TypeRoom in 'PremisesTsv\UEditRBPms_TypeRoom.pas' {fmEditRBPms_TypeRoom},
  URBPms_Station in 'PremisesTsv\URBPms_Station.pas' {fmRBPms_Station},
  UEditRBPms_Station in 'PremisesTsv\UEditRBPms_Station.pas' {fmEditRBPms_Station},
  URBPms_TypeHouse in 'PremisesTsv\URBPms_TypeHouse.pas' {fmRBPms_TypeHouse},
  UEditRBPms_TypeHouse in 'PremisesTsv\UEditRBPms_TypeHouse.pas' {fmEditRBPms_TypeHouse},
  URBPms_Stove in 'PremisesTsv\URBPms_Stove.pas' {fmRBPms_Stove},
  UEditRBPms_Stove in 'PremisesTsv\UEditRBPms_Stove.pas' {fmEditRBPms_Stove},
  URBPms_Furniture in 'PremisesTsv\URBPms_Furniture.pas' {fmRBPms_Furniture},
  UEditRBPms_Furniture in 'PremisesTsv\UEditRBPms_Furniture.pas' {fmEditRBPms_Furniture},
  URBPms_Door in 'PremisesTsv\URBPms_Door.pas' {fmRBPms_Door},
  UEditRBPms_Door in 'PremisesTsv\UEditRBPms_Door.pas' {fmEditRBPms_Door},
  URBPms_Agent in 'PremisesTsv\URBPms_Agent.pas' {fmRBPms_Agent},
  UEditRBPms_Agent in 'PremisesTsv\UEditRBPms_Agent.pas' {fmEditRBPms_Agent},
  URBPms_Planning in 'PremisesTsv\URBPms_Planning.pas' {fmRBPms_Planning},
  UEditRBPms_Planning in 'PremisesTsv\UEditRBPms_Planning.pas' {fmEditRBPms_Planning},
  tsvDbImage in 'United\tsvDbImage.pas',
  URBPms_Premises in 'PremisesTsv\URBPms_Premises.pas' {fmRBPms_Premises},
  UEditRBPms_Premises in 'PremisesTsv\UEditRBPms_Premises.pas' {fmEditRBPms_Premises},
  URBPms_Phone in 'PremisesTsv\URBPms_Phone.pas' {fmRBPms_Phone},
  UEditRBPms_Phone in 'PremisesTsv\UEditRBPms_Phone.pas' {fmEditRBPms_Phone},
  URBPms_Document in 'PremisesTsv\URBPms_Document.pas' {fmRBPms_Document},
  UEditRBPms_Document in 'PremisesTsv\UEditRBPms_Document.pas' {fmEditRBPms_Document},
  tsvStdCtrls in 'United\tsvStdCtrls.pas',
  tsvComCtrls in 'United\tsvComCtrls.pas',
  URBPms_SaleStatus in 'PremisesTsv\URBPms_SaleStatus.pas' {fmRBPms_SaleStatus},
  UEditRBPms_SaleStatus in 'PremisesTsv\UEditRBPms_SaleStatus.pas' {fmEditRBPms_SaleStatus},
  URBPms_TypePremises in 'PremisesTsv\URBPms_TypePremises.pas' {fmRBPms_TypePremises},
  UEditRBPms_TypePremises in 'PremisesTsv\UEditRBPms_TypePremises.pas' {fmEditRBPms_TypePremises},
  URBPms_SelfForm in 'PremisesTsv\URBPms_SelfForm.pas' {fmRBPms_SelfForm},
  UEditRBPms_SelfForm in 'PremisesTsv\UEditRBPms_SelfForm.pas' {fmEditRBPms_SelfForm},
  tsvComponentFont in 'United\tsvComponentFont.pas',
  URBPms_Perm in 'PremisesTsv\URBPms_Perm.pas' {fmRBPms_Perm},
  UEditRBPms_Perm in 'PremisesTsv\UEditRBPms_Perm.pas' {fmEditRBPms_Perm},
  URptPms_Price in 'PremisesTsv\URptPms_Price.pas' {fmRptPms_Price},
  URptThread in 'United\URptThread.pas',
  USrvPms_ImportPrice in 'PremisesTsv\USrvPms_ImportPrice.pas' {fmSrvPms_ImportPrice},
  tsvColorBox in 'United\tsvColorBox.pas',
  tsvValedit in 'United\tsvValedit.pas',
  URBPms_UnitPrice in 'PremisesTsv\URBPms_UnitPrice.pas' {fmRBPms_UnitPrice},
  UEditRBPms_UnitPrice in 'PremisesTsv\UEditRBPms_UnitPrice.pas' {fmEditRBPms_UnitPrice},
  URptMain in 'United\URptMain.pas' {fmRptMain},
  tsvDbOrder in 'United\tsvDbOrder.pas',
  tsvDbFilter in 'United\tsvDbFilter.pas',
  tsvTabOrder in 'United\tsvTabOrder.pas',
  UPms_United in 'PremisesTsv\UPms_United.pas',
  URBPms_Water in 'PremisesTsv\URBPms_Water.pas' {fmRBPms_Water},
  UEditRBPms_Water in 'PremisesTsv\UEditRBPms_Water.pas' {fmEditRBPms_Water},
  URBPms_Heat in 'PremisesTsv\URBPms_Heat.pas' {fmRBPms_Heat},
  UEditRBPms_Heat in 'PremisesTsv\UEditRBPms_Heat.pas' {fmEditRBPms_Heat},
  URBPms_Style in 'PremisesTsv\URBPms_Style.pas' {fmRBPms_Style},
  UEditRBPms_Style in 'PremisesTsv\UEditRBPms_Style.pas' {fmEditRBPms_Style},
  URBPms_Builder in 'PremisesTsv\URBPms_Builder.pas' {fmRBPms_Builder},
  UEditRBPms_Builder in 'PremisesTsv\UEditRBPms_Builder.pas' {fmEditRBPms_Builder},
  URptPms_PriceLeaseClient in 'PremisesTsv\URptPms_PriceLeaseClient.pas',
  URptPms_PriceLeaseAgent in 'PremisesTsv\URptPms_PriceLeaseAgent.pas',
  URptPms_PriceLeaseInspector1 in 'PremisesTsv\URptPms_PriceLeaseInspector1.pas',
  URptPms_PriceLeaseInspector2 in 'PremisesTsv\URptPms_PriceLeaseInspector2.pas',
  URptPms_PriceSaleClient in 'PremisesTsv\URptPms_PriceSaleClient.pas',
  URptPms_PriceSaleAgent in 'PremisesTsv\URptPms_PriceSaleAgent.pas',
  URptPms_PriceSaleInspector in 'PremisesTsv\URptPms_PriceSaleInspector.pas',
  URptPms_PriceShareClient in 'PremisesTsv\URptPms_PriceShareClient.pas',
  URptPms_PriceShareAgent in 'PremisesTsv\URptPms_PriceShareAgent.pas',
  URptPms_PriceShareInspector in 'PremisesTsv\URptPms_PriceShareInspector.pas',
  URptPms_PriceLeaseAgent2 in 'PremisesTsv\URptPms_PriceLeaseAgent2.pas',
  URptPms_PriceShareAgent2 in 'PremisesTsv\URptPms_PriceShareAgent2.pas',
  StbasisSClientDataSet in 'United\StbasisSClientDataSet.pas',
  URptPms_PriceShareInspector2 in 'PremisesTsv\URptPms_PriceShareInspector2.pas',
  URptPms_PriceShareClient2 in 'PremisesTsv\URptPms_PriceShareClient2.pas',
  URptPms_PriceShareClient3 in 'PremisesTsv\URptPms_PriceShareClient3.pas',
  UEditRBPms_Image in 'PremisesTsv\UEditRBPms_Image.pas' {fmEditRBPms_Image},
  URBPms_Image in 'PremisesTsv\URBPms_Image.pas' {fmRBPms_Image},
  UAdvertisment_in_Premises in 'PremisesTsv\UAdvertisment_in_Premises.pas' {fmAdvertisment_in_Premises},
  UEditRBPms_Premises_Advertisment in 'PremisesTsv\UEditRBPms_Premises_Advertisment.pas' {fmEditRBPms_Premises_Advertisment},
  URBPms_Premises_Advertisment in 'PremisesTsv\URBPms_Premises_Advertisment.pas' {fmRBPms_Premises_Advertisment},
  UEditRBPms_Advertisment in 'PremisesTsv\UEditRBPms_Advertisment.pas' {fmEditRBPms_Advertisment},
  URBPms_Advertisment in 'PremisesTsv\URBPms_Advertisment.pas' {fmRBPms_Advertisment},
  URBPms_City_Region in 'PremisesTsv\URBPms_City_Region.pas' {fmRBPms_City_Region},
  UEditRBPms_City_Region in 'PremisesTsv\UEditRBPms_City_Region.pas' {fmEditRBPms_City_Region},
  URBPms_Regions_Correspond in 'PremisesTsv\URBPms_Regions_Correspond.pas' {fmRBPms_Regions_Correspond},
  UEditRBPms_Regions_Correspond in 'PremisesTsv\UEditRBPms_Regions_Correspond.pas' {fmEditRBPms_Regions_Correspond},
  URBPms_Investor in 'PremisesTsv\URBPms_Investor.pas' {fmRBPms_Investor},
  UEditRBPms_Investor in 'PremisesTsv\UEditRBPms_Investor.pas' {fmEditRBPms_Investor},
  tsvSecurity in 'United\tsvSecurity.pas',
  tsvDb in 'United\tsvDb.pas',
  URptPms_PriceLandAgent in 'PremisesTsv\URptPms_PriceLandAgent.pas',
  URptPms_PriceLandClient1 in 'PremisesTsv\URptPms_PriceLandClient1.pas',
  URptPms_PriceLandClient in 'PremisesTsv\URptPms_PriceLandClient.pas',
  UEditRBPms_Taxes in 'PremisesTsv\UEditRBPms_Taxes.pas' {fmEditRBPms_Taxes},
  URBPms_Taxes in 'PremisesTsv\URBPms_Taxes.pas' {fmRBPms_Taxes},
  URBPms_AccessWays in 'PremisesTsv\URBPms_AccessWays.pas' {fmRBPms_AccessWays},
  URBPms_Direction in 'PremisesTsv\URBPms_Direction.pas' {fmRBPms_Direction},
  URBPms_Direction_Correspond in 'PremisesTsv\URBPms_Direction_Correspond.pas' {fmRBPms_Direction_Correspond},
  URBPms_ExchangeFormula in 'PremisesTsv\URBPms_ExchangeFormula.pas' {fmRBPms_ExchangeFormula},
  URBPms_LandFeature in 'PremisesTsv\URBPms_LandFeature.pas' {fmRBPms_LandFeature},
  URBPms_LocationStatus in 'PremisesTsv\URBPms_LocationStatus.pas' {fmRBPms_LocationStatus},
  URBPms_Object in 'PremisesTsv\URBPms_Object.pas' {fmRBPms_Object},
  UEditRBPms_AccessWays in 'PremisesTsv\UEditRBPms_AccessWays.pas' {fmEditRBPms_AccessWays},
  UEditRBPms_Direction in 'PremisesTsv\UEditRBPms_Direction.pas' {fmEditRBPms_Direction},
  UEditRBPms_Direction_Correspond in 'PremisesTsv\UEditRBPms_Direction_Correspond.pas' {fmEditRBPms_Direction_Correspond},
  UEditRBPms_ExchangeFormula in 'PremisesTsv\UEditRBPms_ExchangeFormula.pas' {fmEditRBPms_ExchangeFormula},
  UEditRBPms_LandFeature in 'PremisesTsv\UEditRBPms_LandFeature.pas' {fmEditRBPms_LandFeature},
  UEditRBPms_LocationStatus in 'PremisesTsv\UEditRBPms_LocationStatus.pas' {fmEditRBPms_LocationStatus},
  UEditRBPms_Object in 'PremisesTsv\UEditRBPms_Object.pas' {fmEditRBPms_Object},
  URBPms_PopulatedPoint in 'PremisesTsv\URBPms_PopulatedPoint.pas' {fmRBPms_PopulatedPoint},
  UEditRBPms_PopulatedPoint in 'PremisesTsv\UEditRBPms_PopulatedPoint.pas' {fmEditRBPms_PopulatedPoint};

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

