library design;

{$I stbasis.inc}     
{%File 'DesignTsv\CompilerDefines.INC'}

uses
  SysUtils,
  Classes,
  Windows,
  UMainUnited in 'United\UMainUnited.pas',
  URBMainGrid in 'United\URBMainGrid.pas' {fmRBMainGrid},
  URBMainTreeView in 'United\URBMainTreeView.pas' {fmRBMainTreeView},
  UJRMainGrid in 'United\UJRMainGrid.pas' {fmJRMainGrid},
  UEditRB in 'United\UEditRB.pas' {fmEditRB},
  tsvAdjust in 'United\tsvAdjust.pas' {fmAdjust},
  tsvHint in 'United\tsvHint.pas',
  UDesignTsvCode in 'DesignTsv\UDesignTsvCode.pas',
  UDesignTsvData in 'DesignTsv\UDesignTsvData.pas',
  UDesignTsvDM in 'DesignTsv\UDesignTsvDM.pas' {dm: TDataModule},
  tsvDbGrid in 'United\tsvDbGrid.pas',
  dbtree in 'United\DBTREE.PAS',
  URBInterface in 'DesignTsv\URBInterface.pas' {fmRBInterface},
  tsvPicture in 'United\tsvPicture.pas',
  RAStrUtil in 'DesignTsv\RAStrUtil.pas',
  RADBConst in 'DesignTsv\RADBConst.pas',
  RAEditor in 'DesignTsv\RAEditor.pas',
  RAHLEditor in 'DesignTsv\RAHLEditor.pas',
  RAHLParser in 'DesignTsv\RAHLParser.pas',
  RACtlConst in 'DesignTsv\RACtlConst.pas',
  UEditRBInterface in 'DesignTsv\UEditRBInterface.pas' {fmEditRBInterface},
  UDesignTsvOptions in 'DesignTsv\UDesignTsvOptions.pas' {fmOptions},
  tsvColorBox in 'United\tsvColorBox.pas',
  tsvFontBox in 'United\tsvFontBox.pas',
  UEditOptionsRBInterfaceScript in 'DesignTsv\UEditOptionsRBInterfaceScript.pas' {fmEditOptionsRBInterfaceScript},
  UEditOptionsKeyRBInterfaceScript in 'United\UEditOptionsKeyRBInterfaceScript.pas' {fmEditOptionsKeyRBInterfaceScript},
  UGotoLineDialog in 'DesignTsv\UGotoLineDialog.pas' {fmGotoLineDialog},
  UFindDialog in 'DesignTsv\UFindDialog.pas' {fmFindDialog},
  UReplaceDialog in 'DesignTsv\UReplaceDialog.pas' {fmReplaceDialog},
  tsvDesignForm in 'DesignTsv\tsvDesignForm.pas' {DesignForm},
  ELDsgnr in 'DesignTsv\ELDsgnr.pas',
  ELPropInsp in 'DesignTsv\ELPropInsp.pas',
  ELD5_Adds in 'DesignTsv\ELD5_Adds.pas',
  ZPropLst in 'DesignTsv\ZPropLst.pas',
  rmTVComboBox in 'DesignTsv\rmTVComboBox.pas',
  rmScrnCtrls in 'DesignTsv\rmScrnCtrls.pas',
  rmPathTreeView in 'DesignTsv\rmPathTreeView.pas',
  rmHint in 'DesignTsv\rmHint.pas',
  rmLibrary in 'DesignTsv\rmLibrary.pas',
  rmBtnEdit in 'DesignTsv\rmBtnEdit.pas',
  rmSpeedBtns in 'DesignTsv\rmSpeedBtns.pas',
  rmBaseEdit in 'DesignTsv\rmBaseEdit.pas',
  UAlignPalette in 'DesignTsv\UAlignPalette.pas' {AlignPalette},
  UTabOrder in 'DesignTsv\UTabOrder.pas' {fmTabOrders},
  DsgnIntf in 'United\DsgnIntf.pas',
  UEditOptionsKeyRBInterfaceForms in 'United\UEditOptionsKeyRBInterfaceForms.pas' {fmEditOptionsKeyRBInterfaceForms},
  ELSConsts in 'DesignTsv\ELSConsts.pas',
  ELControls in 'DesignTsv\ELControls.pas',
  ELUtils in 'DesignTsv\ELUtils.pas',
  ELStringsEdit in 'DesignTsv\ELStringsEdit.pas',
  tsvComCtrls in 'United\tsvComCtrls.pas',
  tsvClasses in 'DesignTsv\tsvClasses.pas',
  RARTTI in 'United\RARTTI.pas',
  tsvInterbase in 'United\tsvInterbase.pas',
  URBMenu in 'DesignTsv\URBMenu.pas' {fmRBMenu},
  UEditRBMenu in 'DesignTsv\UEditRBMenu.pas' {fmEditRBMenu},
  URBToolBar in 'DesignTsv\URBToolBar.pas' {fmRBToolbar},
  UEditRBToolbar in 'DesignTsv\UEditRBToolbar.pas' {fmEditRBToolbar},
  URBToolbutton in 'DesignTsv\URBToolbutton.pas' {fmRBToolbutton},
  UEditRBToolbutton in 'DesignTsv\UEditRBToolbutton.pas' {fmEditRBToolbutton},
  tsvDocumentForm in 'DesignTsv\tsvDocumentForm.pas' {DocumentForm},
  URBInterfacePermission in 'DesignTsv\URBInterfacePermission.pas' {fmRBInterfacePermission},
  UEditRBInterfacePermission in 'DesignTsv\UEditRBInterfacePermission.pas' {fmEditRBInterfacePermission},
  tsvDesignCore in 'United\tsvDesignCore.pas',
  tsvInterpreterCore in 'United\tsvInterpreterCore.pas',
  tsvHintEx in 'United\tsvHintEx.pas';

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
//      InitAll;
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

