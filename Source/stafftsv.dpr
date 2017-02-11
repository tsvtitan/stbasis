library stafftsv;

{$I stbasis.inc}     

uses
  SysUtils,
  Classes,
  Windows,
  dbtree in 'United\DBTREE.PAS',
  tsvPicture in 'United\tsvPicture.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  UEditRBConnectiontype in 'StaffTsv\UEditRBConnectiontype.pas' {fmEditRBConnectiontype},
  UEditRBCraft in 'StaffTsv\UEditRBCraft.pas' {fmEditRBCraft},
  UEditRBEduc in 'StaffTsv\UEditRBEduc.pas' {fmEditRBEduc},
  UEditRBEmp in 'StaffTsv\UEditRBEmp.pas' {fmEditRBEmp},
  UEditRBEmpBiography in 'StaffTsv\UEditRBEmpBiography.pas' {fmEditRBEmpBiography},
  UEditRBEmpChildren in 'StaffTsv\UEditRBEmpChildren.pas' {fmEditRBEmpChildren},
  UEditRBEmpConnect in 'StaffTsv\UEditRBEmpConnect.pas' {fmEditRBEmpConnect},
  UEditRBEmpDiplom in 'StaffTsv\UEditRBEmpDiplom.pas' {fmEditRBEmpDiplom},
  UEditRBEmpLanguage in 'StaffTsv\UEditRBEmpLanguage.pas' {fmEditRBEmpLanguage},
  UEditRBEmpMilitary in 'StaffTsv\UEditRBEmpMilitary.pas' {fmEditRBEmpMilitary},
  UEditRBEmpPersonDoc in 'StaffTsv\UEditRBEmpPersonDoc.pas' {fmEditRBEmpPersonDoc},
  UEditRBEmpPhoto in 'StaffTsv\UEditRBEmpPhoto.pas' {fmEditRBEmpPhoto},
  UEditRBEmpPlant in 'StaffTsv\UEditRBEmpPlant.pas' {fmEditRBEmpPlant},
  UEditRBEmpProperty in 'StaffTsv\UEditRBEmpProperty.pas' {fmEditRBEmpProperty},
  UEditRBEmpScienceName in 'StaffTsv\UEditRBEmpScienceName.pas' {fmEditRBEmpScienceName},
  UEditRBEmpStreet in 'StaffTsv\UEditRBEmpStreet.pas' {fmEditRBEmpStreet},
  UEditRBFamilystate in 'StaffTsv\UEditRBFamilystate.pas' {fmEditRBFamilystate},
  UEditRBGroupmil in 'StaffTsv\UEditRBGroupmil.pas' {fmEditRBGroupmil},
  UEditRBKnowlevel in 'StaffTsv\UEditRBKnowlevel.pas' {fmEditRBKnowlevel},
  UEditRBLanguage in 'StaffTsv\UEditRBLanguage.pas' {fmEditRBLanguage},
  UEditRBMilrank in 'StaffTsv\UEditRBMilrank.pas' {fmEditRBMilrank},
  UEditRBProfession in 'StaffTsv\UEditRBProfession.pas' {fmEditRBProfession},
  UEditRBProperty in 'StaffTsv\UEditRBProperty.pas' {fmEditRBProperty},
  UEditRBRank in 'StaffTsv\UEditRBRank.pas' {fmEditRBRank},
  UEditRBReady in 'StaffTsv\UEditRBReady.pas' {fmEditRBReady},
  UEditRBSchool in 'StaffTsv\UEditRBSchool.pas' {fmEditRBSchool},
  UEditRBSciencename in 'StaffTsv\UEditRBSciencename.pas' {fmEditRBSciencename},
  UEditRBSex in 'StaffTsv\UEditRBSex.pas' {fmEditRBSex},
  UEditRBTypeLive in 'StaffTsv\UEditRBTypeLive.pas' {fmEditRBTypeLive},
  UEditRBTypeRelation in 'StaffTsv\UEditRBTypeRelation.pas' {fmEditRBTypeRelation},
  UEditRBTypeStud in 'StaffTsv\UEditRBTypeStud.pas' {fmEditRBTypeStud},
  URBConnectiontype in 'StaffTsv\URBConnectiontype.pas' {fmRBConnectiontype},
  URBCraft in 'StaffTsv\URBCraft.pas' {fmRBCraft},
  URBEduc in 'StaffTsv\URBEduc.pas' {fmRBEduc},
  URBEmp in 'StaffTsv\URBEmp.pas' {fmRBEmpMain},
  URBFamilystate in 'StaffTsv\URBFamilystate.pas' {fmRBFamilystate},
  URBGroupmil in 'StaffTsv\URBGroupmil.pas' {fmRBGroupmil},
  URBKnowlevel in 'StaffTsv\URBKnowlevel.pas' {fmRBKnowlevel},
  UStaffTsvCode in 'StaffTsv\UStaffTsvCode.pas',
  UStaffTsvData in 'StaffTsv\UStaffTsvData.pas',
  UStaffTsvDM in 'StaffTsv\UStaffTsvDM.pas' {dm: TDataModule},
  URBLanguage in 'StaffTsv\URBLanguage.pas' {fmRBLanguage},
  URBMilrank in 'StaffTsv\URBMilrank.pas' {fmRBMilrank},
  URBProfession in 'StaffTsv\URBProfession.pas' {fmRBProfession},
  URBProperty in 'StaffTsv\URBProperty.pas' {fmRBProperty},
  URBRank in 'StaffTsv\URBRank.pas' {fmRBRank},
  URBReady in 'StaffTsv\URBReady.pas' {fmRBReady},
  URBSchool in 'StaffTsv\URBSchool.pas' {fmRBSchool},
  URBSciencename in 'StaffTsv\URBSciencename.pas' {fmRBSciencename},
  URBSex in 'StaffTsv\URBSex.pas' {fmRBSex},
  URBTypeLive in 'StaffTsv\URBTypeLive.pas' {fmRBTypeLive},
  URBTypeRelation in 'StaffTsv\URBTypeRelation.pas' {fmRBTypeRelation},
  URBTypeStud in 'StaffTsv\URBTypeStud.pas' {fmRBTypeStud},
  UMainUnited in 'United\UMainUnited.pas',
  tsvDbGrid in 'United\tsvDbGrid.pas',
  tsvHint in 'United\tsvHint.pas',
  URBCurrency in 'StaffTsv\URBCurrency.pas' {fmRBCurrency},
  UEditRBCurrency in 'StaffTsv\UEditRBCurrency.pas' {fmEditRBCurrency},
  URBRateCurrency in 'StaffTsv\URBRateCurrency.pas' {fmRBRateCurrency},
  UEditRBRateCurrency in 'StaffTsv\UEditRBRateCurrency.pas' {fmEditRBRateCurrency},
  URBTypeEncouragements in 'StaffTsv\URBTypeEncouragements.pas' {fmRBTypeEncouragements},
  UEditRBTypeEncouragements in 'StaffTsv\UEditRBTypeEncouragements.pas' {fmEditRBTypeEncouragements},
  URBTypeResQual in 'StaffTsv\URBTypeResQual.pas' {fmRBTypeResQual},
  UEditRBTypeResQual in 'StaffTsv\UEditRBTypeResQual.pas' {fmEditRBTypeResQual},
  UEditRBEmpFaceAccount in 'StaffTsv\UEditRBEmpFaceAccount.pas' {fmEditRBEmpFaceAccount},
  UEditRBEmpSickList in 'StaffTsv\UEditRBEmpSickList.pas' {fmEditRBEmpSickList},
  UEditRBEmpLaborBook in 'StaffTsv\UEditRBEmpLaborBook.pas' {fmEditRBEmpLaborBook},
  UEditRBEmpRefreshCourse in 'StaffTsv\UEditRBEmpRefreshCourse.pas' {fmEditRBEmpRefreshCourse},
  UEditRBEmpLeave in 'StaffTsv\UEditRBEmpLeave.pas' {fmEditRBEmpLeave},
  UEditRBEmpQual in 'StaffTsv\UEditRBEmpQual.pas' {fmEditRBEmpQual},
  UEditRBEmpEncouragements in 'StaffTsv\UEditRBEmpEncouragements.pas' {fmEditRBEmpEncouragements},
  UEditRBEmpBustripsfromus in 'StaffTsv\UEditRBEmpBustripsfromus.pas' {fmEditRBEmpBustripsfromus},
  URBBustripstous in 'StaffTsv\URBBustripstous.pas' {fmRBBustripstous},
  UEditRBBustripstous in 'StaffTsv\UEditRBBustripstous.pas' {fmEditRBBustripstous},
  URBAddAccount in 'StaffTsv\URBAddAccount.pas' {fmRBAddAccount},
  UEditRBAddAccount in 'StaffTsv\UEditRBAddAccount.pas' {fmEditRBAddAccount},
  URptThread in 'United\URptThread.pas',
  Excel97 in 'United\excel97.pas',
  URptMain in 'United\URptMain.pas' {fmRptMain},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  URBTypeReferences in 'StaffTsv\URBTypeReferences.pas' {fmRBTypeReferences},
  UEditRBTypeReferences in 'StaffTsv\UEditRBTypeReferences.pas' {fmEditRBTypeReferences},
  UEditRBEmpReferences in 'StaffTsv\UEditRBEmpReferences.pas' {fmEditRBEmpReferences},
  UStaffTsvOptions in 'StaffTsv\UStaffTsvOptions.pas' {fmOptions},
  StCalendarUtil in 'United\StCalendarUtil.pas',
  URptEmpUniversal in 'StaffTsv\URptEmpUniversal.pas' {fmRptEmpUniversal},
  tsvTVNavigatorEx in 'United\tsvTVNavigatorEx.pas',
  URBPlant in 'StaffTsv\URBPlant.pas' {fmRBPlant},
  UEditRBPlant in 'StaffTsv\UEditRBPlant.pas' {fmEditRBPlant},
  tsvColorBox in 'United\tsvColorBox.pas',
  tsvComCtrls in 'United\tsvComCtrls.pas',
  StVAVKit in 'United\StVAVKit.pas',
  tsvAdjust in 'United\tsvAdjust.pas' {fmAdjust};

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
  
begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.

