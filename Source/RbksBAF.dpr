library RbksBAF;



uses
  Windows,
  SysUtils,
  Classes,
  UConst in 'RbksBAF\UConst.pas',
  UMainUnited in 'United\UMainUnited.pas',
  URbk in 'RbksBAF\URbk.pas' {FmRbk},
  Controls in 'United\Controls.pas',
  URbkTV in 'RbksBAF\URbkTV.pas' {FmRbkTV},
  dbtree in 'United\Dbtree.pas',
  MainWizard in 'United\MainWizard.pas' {fmMainWizard},
  UFuncProc in 'RbksBAF\UFuncProc.pas',
  UAdjust in 'United\UAdjust.pas' {fmAdjust},
  tsvComCtrls in 'United\tsvComCtrls.pas',
  URbkEdit in 'RbksBAF\URbkEdit.pas' {FmRbkEdit},
  URbkCountry in 'RbksBAF\URbkCountry.pas' {FmRbkCountry},
  URbkATEEdit in 'RbksBAF\URbkATEEdit.pas' {fmRbkATEEdit},
  URbkCountryEdit in 'RbksBAF\URbkCountryEdit.pas' {FmRbkCountryEdit},
  URbkATE in 'RbksBAF\URbkATE.pas' {FmRbkATE},
  URbkRegion in 'RbksBAF\URbkRegion.pas' {FmRbkRegion},
  URbkStreet in 'RbksBAF\URbkStreet.pas' {FmRbkStreet},
  URbkTown in 'RbksBAF\URbkTown.pas' {FmRbkTown},
  URbkPlacement in 'RbksBAF\URbkPlacement.pas' {FmRbkPlacement},
  URbkState in 'RbksBAF\URbkState.pas' {FmRbkState},
  URbkProf in 'RbksBAF\URbkProf.pas' {FmRbkProf},
  URbkNation in 'RbksBAF\URbkNation.pas' {FmRbkNation},
  URbkMotive in 'RbksBAF\URbkMotive.pas' {FmRbkMotive},
  URbkPersonDocType in 'RbksBAF\URbkPersonDocType.pas' {FmRbkPersonDocType},
  URbkSeat in 'RbksBAF\URbkSeat.pas' {FmRbkSeat},
  URbkTypeDoc in 'RbksBAF\URbkTypeDoc.pas' {FmRbkTypeDoc},
  URbkTypeLeave in 'RbksBAF\URbkTypeLeave.pas' {FmRbkTypeLeave},
  URbkBank in 'RbksBAF\URbkBank.pas' {FmRbkBank},
  URbkBankEdit in 'RbksBAF\URbkBankEdit.pas' {FmRbkBankEdit},
  URbkDocum in 'RbksBAF\URbkDocum.pas' {FmRbkDocum},
  URbkDocumEdit in 'RbksBAF\URbkDocumEdit.pas' {FmRbkDocumEdit},
  URbkDokumFilter in 'RbksBAF\URbkDokumFilter.pas' {fmRbkDocumFilter},
  UrbkAccountType in 'RbksBAF\UrbkAccountType.pas' {FmRbkAccountType},
  URbkDepart in 'RbksBAF\URbkDepart.pas' {FmRbkDepart},
  URbkDepartEdit in 'RbksBAF\URbkDepartEdit.pas' {FmRbkDepartEdit},
  URbkExperiencePercent in 'RbksBAF\URbkExperiencePercent.pas' {FmRbkExperiencePercent},
  URbkExpPercentEdit in 'RbksBAF\URbkExpPercentEdit.pas' {FmRbkExpPercentEdit},
  URbkStandartOperation in 'RbksBAF\URbkStandartOperation.pas' {FmRbkStandartOperation},
  URbkStoperation_actype in 'RbksBAF\URbkStoperation_actype.pas' {FmRbkStoperation_acType},
  URbkStoperation_AcTypeEdit in 'RbksBAF\URbkStoperation_AcTypeEdit.pas' {fmRbkStoperation_AcTypeEdit},
  URptMain in 'United\URptMain.pas' {fmRptMain},
  URptThread in 'United\URptThread.pas',
  URptsPersCard_T2 in 'RbksBAF\URptsPersCard_T2.pas' {fmRptsCard_T2},
  URptsMilRank in 'RbksBAF\URptsMilRank.pas' {fmRptsMilRank},
  URptsEducation in 'RbksBAF\URptsEducation.pas' {fmRptsEducation},
  tsvDbGrid in 'United\tsvDbGrid.pas';

exports
  GetInfoLibrary_ name ConstGetInfoLibrary,
  RefreshLibrary_ name ConstRefreshLibrary,
  SetAppAndScreen_ name ConstSetAppAndScreen,
  SetConnection_ name ConstSetConnection,
  InitAll_ name ConstInitAll;

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
    //  InitAll;
    end;
    DLL_PROCESS_DETACH: begin
      FreeCreatures;
    end;
  end;
end;

begin
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
