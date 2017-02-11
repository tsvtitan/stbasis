program PojectBasa1;

uses
  Forms,
  Kassa in 'Kassa.pas' {Form1},
  WinTab in 'WinTab.pas' {FTable},
  WinMaket in 'WinMaket.pas' {FMaket},
  AddCB in 'AddCB.pas' {FAddCB},
  Data in 'Data.pas',
  CashBasis in 'CashBasis.pas',
  EditCB in 'EditCB.pas',
  FilterCB in 'FilterCB.pas' {FCBFilter},
  WTun in 'WTun.pas' {FTuning},
  PlanAccounts in 'PlanAccounts.pas' {PlanAc},
  AddPlanAc in 'AddPlanAc.pas' {FAddAccount},
  EditPA in 'EditPA.pas' {FEditAccount},
  FilterPa in 'FilterPa.pas' {FPAFilter},
  CashAppend in 'CashAppend.pas' {FAppend},
  AddCA in 'AddCA.pas' {FAddCA},
  EditCA in 'EditCA.pas' {FEditCA},
  FilterCA in 'FilterCA.pas' {FCAFilter},
  CashOrder in 'CashOrder.pas' {FCashOrder},
  AddCO in 'AddCO.pas' {FAddCO},
  ChooseCO in 'ChooseCO.pas' {FChooseDoc},
  BankAccount in 'BankAccount.pas' {FBank},
  Emp in 'Emp.pas' {FEmp},
  Currency in 'Currency.pas' {FCur},
  NDS in 'NDS.pas' {FNDS},
  Doc in 'Doc.pas' {FDoc},
  EditCO in 'EditCO.pas' {FEditCO},
  FilterCO1 in 'FilterCO1.pas' {FCOFilter},
  MPosting in 'MPosting.pas' {FMPosting};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.     
