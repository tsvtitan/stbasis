{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - test data generator form                              }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit fADSpeedGenData;

interface

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, daADStanIntf, daADDatSManager, daADStanOption, daADStanParam,
  daADPhysIntf, daADDAptIntf, daADStanDef, DB, daADCompClient,
  daADCompDataSet, daADCompDataMove, StdCtrls, ComCtrls, daADGUIxFormsWait,
  daADPhysManager, daADPhysOracl, daADPhysMSSQL, daADGUIxFormsfOptsBase,
  ExtCtrls, daADGUIxFormsControls;

type
  TADSpeedGenDataFrm = class(TfrmADGUIxFormsOptsBase)
    ADConnection1: TADConnection;
    qInsLong: TADQuery;
    qDelLong: TADQuery;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    qDelSmall: TADQuery;
    qInsSmall: TADQuery;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    ADPhysOraclDriverLink1: TADPhysOraclDriverLink;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure Execute(const AConnDefName: String);
  end;

var
  ADSpeedGenDataFrm: TADSpeedGenDataFrm;

implementation

uses Math;

{$R *.dfm}

{---------------------------------------------------------------------------}
procedure TADSpeedGenDataFrm.Button1Click(Sender: TObject);
var
  i, j, iRecs: Integer;
  s: String;
begin
  ProgressBar1.Position := 0;
  try
    qDelLong.ExecSQL;
    ADConnection1.StartTransaction;
    iRecs := StrToInt(Edit1.Text);
    for i := 1 to iRecs do begin
      qInsLong.Params[0].AsFloat := i - 1;
      SetLength(s, 15);
      for j := 1 to Length(s) do
        s[j] := Char(Ord('a') + Random(25));
      qInsLong.Params[1].AsString := s;
      SetLength(s, 100000 + Random(100000));
      for j := 1 to Length(s) do
        s[j] := Char(Ord('a') + Random(25));
      qInsLong.Params[2].AsMemo := s;
      qInsLong.ExecSQL;
      if i mod 10 = 0 then begin
        ADConnection1.Commit;
        ADConnection1.StartTransaction;
      end;
      ProgressBar1.Position := MulDiv(i, 100, iRecs);
    end;
    ADConnection1.Commit;
  except
    ADConnection1.Rollback;
    raise;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedGenDataFrm.Button2Click(Sender: TObject);
var
  i, j, iRecs: Integer;
  s: String;
begin
  ProgressBar1.Position := 0;
  try
    qDelSmall.ExecSQL;
    ADConnection1.StartTransaction;
    iRecs := StrToInt(Edit2.Text) * 1000;
    qInsSmall.Params.ArraySize := 1000;
    for i := 1 to iRecs do begin
      qInsSmall.Params[0].AsFloats[(i - 1) mod 1000] := i - 1;
      SetLength(s, 30 + Random(70));
      for j := 1 to Length(s) do
        s[j] := Char(Ord('a') + Random(25));
      qInsSmall.Params[1].AsStrings[(i - 1) mod 1000] := s;
      qInsSmall.Params[2].AsDateTimes[(i - 1) mod 1000] := Now() - 500 + Random(1000);
      qInsSmall.Params[3].AsFloats[(i - 1) mod 1000] := Trunc(Random(9999999999));
      qInsSmall.Params[4].AsFloats[(i - 1) mod 1000] := Trunc(Random(9999999999));
      SetLength(s, 10 + Random(10));
      for j := 1 to Length(s) do
        s[j] := Char(Ord('a') + Random(25));
      qInsSmall.Params[5].AsStrings[(i - 1) mod 1000] := s;
{$IFDEF AnyDAC_D6}
      qInsSmall.Params[6].AsFloats[(i - 1) mod 1000] := RoundTo(Random * Random(9999999999), -4);
{$ELSE}
      qInsSmall.Params[6].AsFloats[(i - 1) mod 1000] := Random * Random(9999999999);
{$ENDIF}
      qInsSmall.Params[7].AsFloats[(i - 1) mod 1000] := Random(99999);
      qInsSmall.Params[8].AsFloats[(i - 1) mod 1000] := Random(99999);
      qInsSmall.Params[9].AsDateTimes[(i - 1) mod 1000] := Now() - 500 + Random(1000);
      if i mod 1000 = 0 then begin
        qInsSmall.Execute(1000);
        ADConnection1.Commit;
        ADConnection1.StartTransaction;
      end;
      ProgressBar1.Position := MulDiv(i, 100, iRecs);
    end;
    ADConnection1.Commit;
  except
    ADConnection1.Rollback;
    raise;
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedGenDataFrm.Execute(const AConnDefName: String);
begin
  with TADSpeedGenDataFrm.Create(nil) do
  try
    ADConnection1.ConnectionDefName := AConnDefName;
    ADConnection1.Connected := True;
    ShowModal;
  finally
    Free;
  end;
end;

end.
