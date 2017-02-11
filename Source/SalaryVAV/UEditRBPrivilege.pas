unit UEditRBPrivilege;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, UEditRB, Mask,
  ToolEdit, CurrEdit, RXCtrls;

type
  TfmEditRBPrivelege = class(TfmEditRB)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    bReCalc: TButton;
    CESPJanuary: TCurrencyEdit;
    CESPFebruary: TCurrencyEdit;
    CESPMarch: TCurrencyEdit;
    CESPApril: TCurrencyEdit;
    CESPMay: TCurrencyEdit;
    CESPJune: TCurrencyEdit;
    CESPJuly: TCurrencyEdit;
    CESPAugust: TCurrencyEdit;
    CESPSeptember: TCurrencyEdit;
    CESPOctober: TCurrencyEdit;
    CESPNovember: TCurrencyEdit;
    CESPDecember: TCurrencyEdit;
    CEDPJanuary: TCurrencyEdit;
    CEDPFebruary: TCurrencyEdit;
    CEDPMarch: TCurrencyEdit;
    CEDPApril: TCurrencyEdit;
    CEDPMay: TCurrencyEdit;
    CEDPJune: TCurrencyEdit;
    CEDPJuly: TCurrencyEdit;
    CEDPAugust: TCurrencyEdit;
    CEDPSeptember: TCurrencyEdit;
    CEDPOctober: TCurrencyEdit;
    CEDPNovember: TCurrencyEdit;
    CEDPDecember: TCurrencyEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    CEAllSP: TCurrencyEdit;
    CEAllDP: TCurrencyEdit;
    CETotal: TCurrencyEdit;
    CEAllJanuary: TCurrencyEdit;
    CEAllFebruary: TCurrencyEdit;
    CEAllMarch: TCurrencyEdit;
    CEAllApril: TCurrencyEdit;
    CEAllMay: TCurrencyEdit;
    CEAllJune: TCurrencyEdit;
    CEAllJuly: TCurrencyEdit;
    CEAllAugust: TCurrencyEdit;
    CEAllSeptember: TCurrencyEdit;
    CEAllOctober: TCurrencyEdit;
    CEAllNovember: TCurrencyEdit;
    CEAllDecember: TCurrencyEdit;
//    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bReCalcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEditRBPrivelege: TfmEditRBPrivelege;

implementation

{$R *.DFM}

procedure TfmEditRBPrivelege.FormCreate(Sender: TObject);
begin
  inherited;

//  GVPrivelege.Cells(2,2):='asdfa sdf ';

end;

procedure TfmEditRBPrivelege.bReCalcClick(Sender: TObject);
begin
//Пересчет значений


CEAllJanuary.Value   := CESPJanuary.Value   + CEDPJanuary.Value;
CEAllFebruary.Value  := CESPFebruary.Value  + CEDPFebruary.Value;
CEAllMarch.Value     := CESPMarch.Value     + CEDPMarch.Value;
CEAllApril.Value     := CESPApril.Value     + CEDPApril.Value;
CEAllMay.Value       := CESPMay.Value       + CEDPMay.Value;
CEAllJune.Value      := CESPJune.Value      + CEDPJune.Value;
CEAllJuly.Value      := CESPJuly.Value      + CEDPJuly.Value;
CEAllAugust.Value    := CESPAugust.Value    + CEDPAugust.Value;
CEAllSeptember.Value := CESPSeptember.Value + CEDPSeptember.Value;
CEAllOctober.Value   := CESPOctober.Value   + CEDPOctober.Value;
CEAllNovember.Value  := CESPNovember.Value  + CEDPNovember.Value;
CEAllDecember.Value  := CESPDecember.Value  + CEDPDecember.Value;

CEAllSP.Value:=   CESPJanuary.Value   +
                  CESPFebruary.Value  +
                  CESPMarch.Value     +
                  CESPApril.Value     +
                  CESPMay.Value       +
                  CESPJune.Value      +
                  CESPJuly.Value      +
                  CESPAugust.Value    +
                  CESPSeptember.Value +
                  CESPOctober.Value   +
                  CESPNovember.Value  +
                  CESPDecember.Value;

CEAllDP.Value:=   CEDPJanuary.Value   +
                  CEDPFebruary.Value  +
                  CEDPMarch.Value     +
                  CEDPApril.Value     +
                  CEDPMay.Value       +
                  CEDPJune.Value      +
                  CEDPJuly.Value      +
                  CEDPAugust.Value    +
                  CEDPSeptember.Value +
                  CEDPOctober.Value   +
                  CEDPNovember.Value  +
                  CEDPDecember.Value;
CETotal.Value:= CEAllSP.Value + CEAllDP.Value;
 end;

end.
