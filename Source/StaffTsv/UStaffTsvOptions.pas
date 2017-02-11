unit UStaffTsvOptions;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, IBServices, CheckLst,
  menus, ImgList, Grids, IBQuery, IBDatabase;

type
  TfmOptions = class(TForm)
    ilShortCut: TImageList;
    ilOptions: TImageList;
    pc: TPageControl;
    tsRBEmp: TTabSheet;
    pnRBEmp: TPanel;
    chbRBEmpAllTabs: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure FillRBEmpOptions;
    procedure SetRBEmpOptions;
  end;

var
  fmOptions: TfmOptions;

implementation


uses UMainUnited, URBEmp, UStaffTsvCode, UStaffTsvData;

{$R *.DFM}

procedure TfmOptions.FormCreate(Sender: TObject);
begin
  Left:=-1000;
  Top:=-1000;
end;

procedure TfmOptions.LoadFromIni;
begin
 try
   chbRBEmpAllTabs.Checked:=ReadParam(ConstRBEmpClassName,ConstRBEmpMultiLine,chbRBEmpAllTabs.Checked)
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOptions.SaveToIni;
begin
 try
   WriteParam(ConstRBEmpClassName,ConstRBEmpMultiLine,chbRBEmpAllTabs.Checked)
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmOptions.FillRBEmpOptions;
begin
(* if fi=nil then exit;
 try
   if fmRBEmp=nil then
    chbRBEmpAllTabs.Checked:=fi.ReadBool(ConstRBEmpClassName,ConstRBEmpMultiLine,chbRBEmpAllTabs.Checked)
   else
    chbRBEmpAllTabs.Checked:=fmRBEmp.pgLink.MultiLine;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;*)
end;

procedure TfmOptions.SetRBEmpOptions;
begin
(* if fi=nil then exit;
 try
   if fmRBEmp=nil then
    fi.WriteBool(ConstRBEmpClassName,ConstRBEmpMultiLine,chbRBEmpAllTabs.Checked)
   else
    fmRBEmp.pgLink.MultiLine:=chbRBEmpAllTabs.Checked;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;*)
end;

end.
