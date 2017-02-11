unit MainWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  TfmMainWizard = class(TForm)
    PanelBottom: TPanel;
    Panel2: TPanel;
    btClose: TButton;
    PanelTop: TPanel;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    btFinish: TButton;
    pnImage: TPanel;
    shpImage: TShape;
    ImageLogo: TImage;
    PC: TPageControl;
    btPrior: TButton;
    btNext: TButton;
    procedure btCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btNextClick(Sender: TObject);
    procedure btPriorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
  public
    procedure SetBtnsEnable;
    { Public declarations }
  end;

implementation

uses UMainUnited;

procedure _MainFormKeyDownCurrent(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyDown;
procedure _MainFormKeyUpCurrent(var Key: Word; Shift: TShiftState);stdcall;
                         external MainExe name ConstMainFormKeyUp;
procedure _MainFormKeyPressCurrent(var Key: Char);stdcall;
                         external MainExe name ConstMainFormKeyPress;

{$R *.DFM}

procedure TfmMainWizard.btCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfmMainWizard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Hint:='';
  Action:=caFree;
end;

procedure TfmMainWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyDownCurrent(Key,Shift);
end;

procedure TfmMainWizard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  _MainFormKeyPressCurrent(Key);
end;

procedure TfmMainWizard.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  _MainFormKeyUpCurrent(Key,Shift);
end;

procedure TfmMainWizard.btNextClick(Sender: TObject);
begin
  if PC.ActivePageIndex<PC.PageCount-1 then
    PC.ActivePageIndex:=PC.ActivePageIndex+1;
  SetBtnsEnable;
end;

procedure TfmMainWizard.btPriorClick(Sender: TObject);
begin
  if PC.ActivePageIndex>0 then
    PC.ActivePageIndex:=PC.ActivePageIndex-1;
  SetBtnsEnable;
end;

procedure TfmMainWizard.SetBtnsEnable;
begin
  btPrior.Enabled:=(PC.ActivePageIndex>0);
  btNext.Enabled:=(PC.ActivePageIndex<>PC.PageCount-1);
end;

procedure TfmMainWizard.FormActivate(Sender: TObject);
begin
  SetBtnsEnable;
end;

end.
