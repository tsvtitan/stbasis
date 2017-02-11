library invalidtsv;

{$I stbasis.inc}     



uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  UInvalidTsvCode in 'InvalidTsv\UInvalidTsvCode.pas',
  UInvalidTsvData in 'InvalidTsv\UInvalidTsvData.pas',
  UInvalidTsvDM in 'InvalidTsv\UInvalidTsvDM.pas' {dm: TDataModule},
  UInvalidTsvOptions in 'InvalidTsv\UInvalidTsvOptions.pas' {fmOptions},
  URBInvalidCategory in 'InvalidTsv\URBInvalidCategory.pas' {fmRBInvalidCategory},
  UEditRBInvalidCategory in 'InvalidTsv\UEditRBInvalidCategory.pas' {fmEditRBInvalidCategory},
  URBViewPlace in 'InvalidTsv\URBViewPlace.pas' {fmRBViewPlace},
  UEditRBViewPlace in 'InvalidTsv\UEditRBViewPlace.pas' {fmEditRBViewPlace},
  URBInvalidGroup in 'InvalidTsv\URBInvalidGroup.pas' {fmRBInvalidGroup},
  UEditRBInvalidGroup in 'InvalidTsv\UEditRBInvalidGroup.pas' {fmEditRBInvalidGroup},
  URBPhysician in 'InvalidTsv\URBPhysician.pas' {fmRBPhysician},
  UEditRBPhysician in 'InvalidTsv\UEditRBPhysician.pas' {fmEditRBPhysician},
  URBInvalid in 'InvalidTsv\URBInvalid.pas' {fmRBInvalid},
  UEditRBInvalid in 'InvalidTsv\UEditRBInvalid.pas' {fmEditRBInvalid},
  URBVisit in 'InvalidTsv\URBVisit.pas' {fmRBVisit},
  UEditRBVisit in 'InvalidTsv\UEditRBVisit.pas' {fmEditRBVisit},
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  URBBranch in 'InvalidTsv\URBBranch.pas' {fmRBBranch},
  UEditRBBranch in 'InvalidTsv\UEditRBBranch.pas' {fmEditRBBranch},
  tsvAdjust in 'United\tsvAdjust.pas' {fmAdjust};

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

