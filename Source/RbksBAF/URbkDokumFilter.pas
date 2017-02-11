unit URbkDokumFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URbkEdit, IBDatabase, Db, IBCustomDataSet, IBQuery, StdCtrls, Buttons,
  ExtCtrls, ComCtrls;

type
  TfmRbkDocumFilter = class(TFmRbkEdit)
    Panel2: TPanel;
    LbNum: TLabel;
    LbTypeDoc: TLabel;
    EdNum: TEdit;
    EdTypeDoc: TEdit;
    BtCallTypeDoc: TButton;
    grbBirthDate: TGroupBox;
    lbBirthDateFrom: TLabel;
    lbBirthDateTo: TLabel;
    DPFirst: TDateTimePicker;
    DPNext: TDateTimePicker;
    btCallPeriod: TBitBtn;
    CB: TCheckBox;
    procedure CBClick(Sender: TObject);
    procedure btCallPeriodClick(Sender: TObject);
    procedure BtCallTypeDocClick(Sender: TObject);
    procedure EdTypeDocKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    TypeDoc_id: Integer;
    { Public declarations }
  end;

var
  fmRbkDocumFilter: TfmRbkDocumFilter;

implementation
Uses UMainUnited, UFuncProc, Uconst;

{$R *.DFM}

procedure TfmRbkDocumFilter.CBClick(Sender: TObject);
var
  Cl:Tcolor;
begin
  dpFirst.enabled:=cb.checked;
  DpNext.enabled:=cb.checked;
  btCallPeriod.enabled:=cb.checked;
  if CB.Checked then Cl:=clWindow else cl:=clMenu;
  DPFirst.Color:=cl;
  DPNext.Color:=cl;
end;

procedure TfmRbkDocumFilter.btCallPeriodClick(Sender: TObject);
var
  P: PInfoEnterPeriod;
begin
 try
  GetMem(P,sizeof(TInfoEnterPeriod));
  try
   ZeroMemory(P,sizeof(TInfoEnterPeriod));
   P.TypePeriod:=tepYear;
   P.LoadAndSave:=false;
   P.DateBegin:=dpFirst.DateTime;
   P.DateEnd:=dpNext.DateTime;
   if _ViewEnterPeriod(P) then begin
     dpFirst.DateTime:=P.DateBegin;
     dpNext.DateTime:=P.DateEnd;
   end;
  finally
    FreeMem(P,sizeof(TInfoEnterPeriod));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;

end;

procedure TfmRbkDocumFilter.BtCallTypeDocClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typeDoc_id';
  TPRBI.Locate.KeyValues:=TypeDoc_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameTypeDoc,@TPRBI) then begin
    ChangeFlag:=true;
    TypeDoc_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'TypeDoc_id');
    EdTypeDoc.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'Name');
  end;
end;

procedure TfmRbkDocumFilter.EdTypeDocKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    EdTypeDoc.Clear;
    ChangeFlag:=true;
    TypeDoc_id:=0;
  end;
end;

procedure TfmRbkDocumFilter.btClearClick(Sender: TObject);
begin
  EdNum.Clear;
  EdTypeDoc.Clear;
  TypeDoc_id:=0;
  CB.Checked:=false;
  DPFirst.Checked:=false;
  DPNext.Checked:=false;
end;

end.
