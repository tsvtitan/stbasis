unit fBatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ExtCtrls, Menus, ComCtrls,
  fMainBase, fMainLayers,
  daADDatSManager, daADStanIntf, daADStanOption, daADPhysIntf,
  daADGUIxFormsfLogin, daADGUIxFormsfError, jpeg;

type
  TfrmMain = class(TfrmMainLayers)
    chbBlobs: TCheckBox;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    edtRecordsToInsert: TEdit;
    procedure cbDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.cbDBClick(Sender: TObject);
var
  oComm1: IADPhysCommand;
  oComm2: IADPhysCommand;
  i, iBatchSize: Integer;
  iTime1, iTime2: LongWord;
begin
  inherited cbDBClick(Sender);
  Console.Clear;
  iBatchSize := StrToInt(edtRecordsToInsert.Text);
  FConnIntf.CreateCommand(oComm1);
  FConnIntf.CreateCommand(oComm2);

  // Ordinary executing
  with oComm1 do begin
    Prepare('delete from {id ADQA_Batch_test}');
    Execute;
  end;
  with oComm2 do begin
    if chbBlobs.Checked then
      CommandText := 'insert into {id ADQA_Batch_test}(tint, tstring, tblob) values(:f1, :f2, :f3)'
    else
      CommandText := 'insert into {id ADQA_Batch_test}(tint, tstring) values(:f1, :f2)';

    // Setup parameters
    Params[0].DataType := ftInteger;
    Params[1].DataType := ftString;
    Params[1].Size := 20;
    if chbBlobs.Checked then
      Params[2].DataType := ftBlob;
    Prepare;

    iTime1 := GetTickCount;
    Console.Lines.Add('begining ...');
    FConnIntf.TxBegin;
    // execute 10,000 times
    for i := 0 to iBatchSize - 1 do begin
      Params[0].AsInteger := i;
      Params[1].AsString := 'qweqwe' + IntToStr(i);
      if chbBlobs.Checked then
        Params[2].AsBlob := 'asdasd' + IntToStr(i);
      Execute;
    end;
    FConnIntf.TxCommit;
  end;
  iTime1 := GetTickCount - iTime1;
  Console.Lines.Add('end at ' + FloatToStr(iTime1 / 1000.0) + ' sec.');
  StatusBar1.Panels[0].Text := 'Time is ' + FloatToStr(iTime1 / 1000.0) + ' sec.';

  // Batch executing
  oComm1.Execute;

  with oComm2 do begin
    Disconnect;

    // Setup parameters
    Params[0].DataType := ftInteger;
    Params[1].DataType := ftString;
    Params[1].Size := 20;
    if chbBlobs.Checked then
      Params[2].DataType := ftBlob;
    // Set up parameters' array size for batch executing
    Params.ArraySize := iBatchSize;
    Prepare;

    iTime2 := GetTickCount;
    Console.Lines.Add('begining batch...');
    FConnIntf.TxBegin;
    // set 10,000 times parameter values
    for i := 0 to iBatchSize - 1 do begin
      Params[0].AsIntegers[i] := i;
      Params[1].AsStrings[i] := 'qweqwe' + IntToStr(i);
      if chbBlobs.Checked then
        Params[2].AsBlobs[i] := 'asdasd' + IntToStr(i);
    end;
    // execute once
    Execute(iBatchSize, 0);
    FConnIntf.TxCommit;
  end;
  iTime2 := GetTickCount - iTime2;
  Console.Lines.Add('end at ' + FloatToStr(iTime2 / 1000.0) + ' sec.');
  StatusBar1.Panels[1].Text := 'Batch time is ' + FloatToStr(iTime2 / 1000.0) + ' sec.';
  Console.Lines.Add(Format('The Batch Ratio (OrdinaryExecTime / BatchExecTime) = %4.3f',
    [iTime1 / iTime2]));
end;

end.
