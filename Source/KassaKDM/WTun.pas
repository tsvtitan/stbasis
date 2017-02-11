unit WTun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinMaket, StdCtrls, CheckLst, Buttons, Data;

type
  TFTuning = class(TFMaket)
    GroupBox: TGroupBox;
    CLBFields: TCheckListBox;
    BBUp: TBitBtn;
    BBDown: TBitBtn;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BBDownClick(Sender: TObject);
    procedure BBUpClick(Sender: TObject);
    procedure BOkClick(Sender: TObject);
    procedure CLBFieldsClickCheck(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTuning: TFTuning;

implementation

{$R *.DFM}

procedure TFTuning.FormResize(Sender: TObject);
begin
  inherited;
  BOk.Left := Width-175;
  BOk.Top := Height-58;
  BCancel.Left := Width-87;
  BCancel.Top := Height-58;
  GroupBox.Width := Width-20;
  GroupBox.Height := Height-78;
  CLBFields.Width := Width-84;
  CLBFields.Height := Height-118;
  BBUp.Left := Width-69;
  BBDown.Left := Width-69;
end;

procedure TFTuning.FormActivate(Sender: TObject);
begin
  inherited;
  CLBFields.SetFocus;
end;

procedure TFTuning.BBDownClick(Sender: TObject);
var
  Temp: string;
  TempBool: Boolean;
begin
  inherited;
  try
    if (CLBFields.ItemIndex<>-1)and (CLBFields.ItemIndex<>CLBFields.Items.Count-1) then begin
      Temp := CLBFields.Items.Strings[CLBFields.ItemIndex];
      TempBool := CLBFields.Checked[CLBFields.ItemIndex];
      CLBFields.Items.Strings[CLBFields.ItemIndex] := CLBFields.Items.Strings[CLBFields.ItemIndex+1];
      CLBFields.Checked[CLBFields.ItemIndex] := CLBFields.Checked[CLBFields.ItemIndex+1];
      CLBFields.Items.Strings[CLBFields.ItemIndex+1] := Temp;
      CLBFields.Checked[CLBFields.ItemIndex+1] := TempBool;
      CLBFields.ItemIndex := CLBFields.ItemIndex+1;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFTuning.BBUpClick(Sender: TObject);
var
  Temp: string;
  TempBool: Boolean;
begin
  inherited;
  try
    if (CLBFields.ItemIndex<>-1)and (CLBFields.ItemIndex<>0) then begin
      Temp := CLBFields.Items.Strings[CLBFields.ItemIndex];
      TempBool := CLBFields.Checked[CLBFields.ItemIndex];
      CLBFields.Items.Strings[CLBFields.ItemIndex] := CLBFields.Items.Strings[CLBFields.ItemIndex-1];
      CLBFields.Checked[CLBFields.ItemIndex] := CLBFields.Checked[CLBFields.ItemIndex-1];
      CLBFields.Items.Strings[CLBFields.ItemIndex-1] := Temp;
      CLBFields.Checked[CLBFields.ItemIndex-1] := TempBool;
      CLBFields.ItemIndex := CLBFields.ItemIndex-1;
    end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TFTuning.BOkClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  TempList.Clear;
  for i:=0 to CLBFields.Items.Count-1 do begin
    TempList.Add(CLBFields.Items[i]);
    if CLBFields.Checked[i] then
      TempList.Add('Yes')
    else
      TempList.Add('No');
  end;
  ModalResult := mrOk;
end;

procedure TFTuning.CLBFieldsClickCheck(Sender: TObject);
var
  i,count: integer;
begin
  inherited;
  count:=0;
  for i:=0 to CLBFields.Items.Count-1 do begin
    if CLBFields.Checked[i] then
      count := count+1;
  end;
  if count=0 then
    CLBFields.Checked[CLBFields.ItemIndex] := True;
end;

end.
