unit StbasisSStand;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StbasisSConfig, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPServer, StbasisSTCPServer;

type
  TStbasisSStandForm = class(TForm)
    LabelTime: TLabel;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    FDateTime: TDateTime;
    FConfig: TStbasisSConfig;
    FDays: Word;
    FFormatStatus: String;
    FTCPServer: TStbasisSTCPServer;
    procedure TCPServerActivity(Active: Boolean);
  public
    procedure Init;
    procedure Done;
    procedure Start;
    procedure Stop;

    property Config: TStbasisSConfig read FConfig write FConfig;
    property TCPServer: TStbasisSTCPServer read FTCPServer write FTCPServer;  
  end;

implementation

uses StbasisSCode, StbasisSData, StbasisSUtils;

{$R *.DFM}

procedure TStbasisSStandForm.Init;
begin
  FFormatStatus:='Время работы: %d день %s';
  FTCPServer.OnActivity:=TCPServerActivity;
  Caption:=FDisplayName;
  Left:=FConfig.ReadInteger(SSectionPosition,'Left',Left);
  Top:=FConfig.ReadInteger(SSectionPosition,'Top',Top);
  FFormatStatus:=FConfig.ReadString(SSectionMain,'FormatStatus',FFormatStatus);
end;

procedure TStbasisSStandForm.Done;
begin
  FConfig.WriteString(SSectionMain,'FormatStatus',FFormatStatus);
  FConfig.WriteInteger(SSectionPosition,'Left',Left);
  FConfig.WriteInteger(SSectionPosition,'Top',Top);
  FTCPServer.OnActivity:=nil;
end;

procedure TStbasisSStandForm.Start;
begin
  FDays:=0;
  FDateTime:=Now;
  TimerTimer(Timer);
  Timer.Enabled:=true;
end;

procedure TStbasisSStandForm.Stop;
begin
  Timer.Enabled:=false;
  FDateTime:=Now;
  FDays:=0;
end;

procedure TStbasisSStandForm.TimerTimer(Sender: TObject);
var
  Hour, Min, Sec, MSec: Word;
  FCurrent: TDateTime;
begin
  FCurrent:=Now-FDateTime;
  DecodeTime(FCurrent,Hour,Min,Sec,MSec);
  if Hour>=24 then begin
    FDays:=FDays+1;
    FDateTime:=Now;
    FCurrent:=Now-FDateTime;
  end;
  LabelTime.Caption:=Format(FFormatStatus,[FDays,FormatDateTime('hh:nn:ss',FCurrent)]);
end;

procedure TStbasisSStandForm.TCPServerActivity(Active: Boolean);
begin
  LabelTime.Font.Color:=iff(Active,clRed,clBlack);
end;

end.
