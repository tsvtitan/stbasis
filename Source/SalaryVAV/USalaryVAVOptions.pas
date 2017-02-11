unit USalaryVAVOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase, Mask, ToolEdit,
  CurrEdit;

type
  TfmOptions = class(TForm)
    ilShortCut: TImageList;
    ilOptions: TImageList;
    pc: TPageControl;
    tsRBSalary: TTabSheet;
    pnRBsalary: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cedShiftDay: TCurrencyEdit;
    cedShiftEvening: TCurrencyEdit;
    cedShiftNight: TCurrencyEdit;
    cedPrivilegent: TCurrencyEdit;
    cedDependent: TCurrencyEdit;
    Label5: TLabel;
    Label6: TLabel;
    ceMaxSummForPrivelege: TCurrencyEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
  private
//    fi: TIniFile;
  public
    procedure LoadFromIni;
    procedure SaveToIni;

//    procedure FillRBEmpOptions;
//    procedure SetRBEmpOptions;
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited,  USalaryVAVCode, USalaryVAVData;

{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;

  ConstShiftDay := 0;
  ConstShiftEvening := 0.5;
  ConstShiftNight := 1;
  ConstPrivilegent := 400;
  ConstDependent := 300;
  ConstMaxSummForPrivelege := 20000;

  LoadFromIni();
end;

procedure TfmOptions.LoadFromIni;
begin
 try
   cedShiftDay.Value:=ReadParam(ConstRBSalaryClassName,cedShiftDay.Name,cedShiftDay.Value);
   ConstShiftDay:=cedShiftDay.Value;
   cedShiftEvening.Value:=ReadParam(ConstRBSalaryClassName,cedShiftEvening.Name,cedShiftEvening.Value);
   ConstShiftEvening:=cedShiftEvening.Value;
   cedShiftNight.Value:=ReadParam(ConstRBSalaryClassName,cedShiftNight.Name,cedShiftNight.Value);
   ConstShiftNight:=cedShiftNight.Value;
   cedPrivilegent.Value:=ReadParam(ConstRBSalaryClassName,cedPrivilegent.Name,cedPrivilegent.Value);
   ConstPrivilegent:=cedPrivilegent.Value;
   cedDependent.Value:=ReadParam(ConstRBSalaryClassName,cedDependent.Name,cedDependent.Value);
   ConstDependent:=cedDependent.Value;
   ceMaxSummForPrivelege.Value:=ReadParam(ConstRBSalaryClassName,ceMaxSummForPrivelege.Name,ceMaxSummForPrivelege.Value);
   ConstMaxSummForPrivelege:=ceMaxSummForPrivelege.Value;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOptions.SaveToIni;
begin
  try
   WriteParam(ConstRBSalaryClassName,cedShiftDay.Name,cedShiftDay.Value);
   WriteParam(ConstRBSalaryClassName,cedShiftEvening.Name,cedShiftEvening.Value);
   WriteParam(ConstRBSalaryClassName,cedShiftNight.Name,cedShiftNight.Value);
   WriteParam(ConstRBSalaryClassName,cedPrivilegent.Name,cedPrivilegent.Value);
   WriteParam(ConstRBSalaryClassName,cedDependent.Name,cedDependent.Value);
   WriteParam(ConstRBSalaryClassName,ceMaxSummForPrivelege.Name,ceMaxSummForPrivelege.Value);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;
end.
